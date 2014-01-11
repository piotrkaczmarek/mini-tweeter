require 'spec_helper'

describe OrganizationsController do
  let(:user) { FactoryGirl.create(:user) }
  before do
    OrganizationsController.any_instance.stub(:signed_in_user)
  end

  describe "#create" do
    before :each do
      @organization = Organization.new(name: "orga")
      OrganizationsController.any_instance.stub(:current_user).and_return(user)
    end
    it "should increase organization count" do
      expect do
        post :create, {  organization: { name: @organization.name, homesite_url: nil } }
      end.to change(Organization, :count).by(1)
    end
    it "should assign current user as an organization admin" do
      post :create, {  organization: { name: @organization.name, homesite_url: nil } }
      assigns(:organization).admin_id.should == user.id
    end
  
  end

  describe "#destroy" do
    let(:organization) { Organization.create(name: "corpo", admin_id: user.id) } 

    describe "when logged in as organization admin" do
      before do
        OrganizationsController.any_instance.stub(:current_user).and_return(user) 
        delete :destroy, { id: organization.id }
      end
      it "should decrease organization count" do
        expect(Organization.count).to eq 0
      end
    end

    describe "when not logged in as organization admin" do
      before do
        @user2 = FactoryGirl.create(:user)
        OrganizationsController.any_instance.stub(:current_user).and_return(@user2)
        delete :destroy, { id: organization.id }
      end
      it "should not change organization count" do
        expect(Organization.count).to eq 1
      end
    end

  
  end
  
  describe "#update" do
    let(:old_url) { "old_url.com" }
    let(:old_name) { "old_name" }
    let(:organization) { Organization.create(name: old_name, homesite_url: old_url, admin_id: user.id) } 

    describe "when logged in as organization admin" do
      before { OrganizationsController.any_instance.stub(:current_user).and_return(user) }

      describe "updating homesite_url" do
        before do
          @new_url = "new_url.com" 
          post :update, { id: organization.id, organization: { homesite_url: @new_url } }
        end
        it "should change homesite_url" do
          expect(Organization.find(organization.id).homesite_url).to eq @new_url
        end 
        it "should not change name " do
          expect(Organization.find(organization.id).name).to eq old_name 
        end
      end

      describe "updating name" do
        before do
          @new_name = "new_name"
          post :update, { id: organization.id, organization: { name: @new_name } }
        end
        it "should change name" do
          expect(Organization.find(organization.id).name).to eq @new_name
        end
        it "should not change homesite_url" do
          expect(Organization.find(organization.id).homesite_url).to eq old_url 
        end
      end
  
      describe "updating both params" do
        before do
          @new_name = "new_name"
          @new_url = "new_url.com"
          post :update, { id: organization.id, organization: { name: @new_name, homesite_url: @new_url } }
        end
        it "should change name" do
          expect(Organization.find(organization.id).name).to eq @new_name
        end
        it "should change homesite_url" do
          expect(Organization.find(organization.id).homesite_url).to eq @new_url
        end
      end
      
      describe "when providing invalid params" do
        describe "when providing invalid name and valid homesite_url" do
          before do
            @new_name = ""
            @new_url = "new_url.com"
          post :update, { id: organization.id, organization: { name: @new_name, homesite_url: @new_url } }
          end
          it "should not change name" do
            expect(Organization.find(organization.id).name).to eq old_name          
          end
          it "should change homesite_url" do
            expect(Organization.find(organization.id).homesite_url).to eq old_url
          end
        end
    #    describe "when providing invalid homesite_url and valid name" do # no validation on homesite_url yet
    #    end
      end
    end

    describe "when not logged in as organization admin" do
      before :each do
        @user2 = FactoryGirl.create(:user)
        OrganizationsController.any_instance.stub(:current_user).and_return(@user2)
      end

      describe "updating both params" do
        before do
          @new_name = "new_name"
          @new_url = "new_url.com"
          post :update, { id: organization.id, organization: { name: @new_name, homesite_url: @new_url } }
        end
        it "should not change name" do
          expect(Organization.find(organization.id).name).to eq old_name 
        end
        it "should not change homesite_url" do
          expect(Organization.find(organization.id).homesite_url).to eq old_url 
        end
      end
    end
  end


  describe "#add_member" do
    before :each do
      let(:organization) { Organization.create(name: "corpo", admin_id: user.id) }
      @user = FactoryGirl.create(:user)
      post :add_member, {user_id: 1, organization_id: organization.id, new_member_id: @user.id }
    end
  
  end

  describe "#remove_member" do
    before :each do
      let(:organization) { Organization.create(name: "corpo", admin_id: user.id) }
      @user = FactoryGirl.create(:user, organization_id: organization.id)
      post :remove_member, {user_id: 1, organization_id: @organization.id, new_member_id: @user.id }
    end
  end

end
