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
    it "should assign current user as a member" do
      post :create, {  organization: { name: @organization.name, homesite_url: nil } }
      assigns(:organization).members.should == [user]    
    end
  
  end

  describe "#destroy" do
    let(:organization) { Organization.create(name: "corpo", admin_id: user.id) }
    before :each do
      user.organization_id = organization.id 
    end
    describe "when logged in as organization admin" do
      before do
        OrganizationsController.any_instance.stub(:current_user).and_return(user) 
        @user2 = FactoryGirl.create(:user, organization_id: organization.id)
        delete :destroy, { id: organization.id }
      end
      it "should decrease organization count" do
        expect(Organization.count).to eq 0
      end
      it "should delete user's organization_id" do
        expect(User.find(user.id).organization_id).to eq nil
      end
      it "should delete other members' organization_id" do
        expect(User.find(@user2.id).organization_id).to eq nil
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
    let(:organization) { Organization.create(name: "org_name", admin_id: user.id) } 
    before :each do
      user.organization_id = organization.id
      user.save
      @user = FactoryGirl.create(:user)
    end

    describe "when logged in as organization admin" do
      before { OrganizationsController.any_instance.stub(:current_user).and_return(user) }

      describe "when adding a new user" do
        it "should increase organization members count" do
          expect do
            post :add_member, {id: organization.id, new_member_id: @user.id }
          end.to change(organization.members,:count).by(1)
        end
        it "should have correct members" do
          post :add_member, {id: organization.id, new_member_id: @user.id }
          expect(organization.members).to eq [user, @user]
        end
      end

      describe "when adding user that already is a member" do
        before do
          @user.organization_id = organization.id 
          @user.save!
        end
        it "should not change organization members count" do
          expect do
            post :add_member, {id: organization.id, new_member_id: @user.id }
          end.to change(organization.members,:count).by(0)
        end
        it "should have correct members" do
          post :add_member, {id: organization.id, new_member_id: @user.id }
          expect(organization.members).to eq [user, @user]
        end
      end
    end

    describe "when not logged in as organization admin" do
      before { OrganizationsController.any_instance.stub(:current_user).and_return(@user) }

      describe "when adding a new user" do
        it "should not change organization members count" do
          expect do
            post :add_member, {id: organization.id, new_member_id: @user.id }
          end.to change(organization.members,:count).by(0)
        end
        it "should have correct members" do
          post :add_member, {id: organization.id, new_member_id: @user.id }
          expect(organization.members).to eq [user]
        end        
      end
    end
  end

  describe "#remove_member" do
    let(:organization) { Organization.create(name: "org_name", admin_id: user.id) } 
    before :each do
      user.organization_id = organization.id
      user.save
      @user = FactoryGirl.create(:user, organization_id: organization.id)
    end
    describe "when logged in as organization admin" do
      before { OrganizationsController.any_instance.stub(:current_user).and_return(user) }

      describe "when removing other member" do
        it "should change organization members count" do
          expect do
            post :remove_member, {id: organization.id, member_id: @user.id }
          end.to change(organization.members, :count).by(-1)
        end
        it "should have correct members" do
          post :remove_member, {id: organization.id, member_id: @user.id }
          expect(organization.members).to eq [user]
        end
      end

      describe "when removing himself" do
        it "should not change organization members count" do
          expect do
            post :remove_member, {id: organization.id, member_id: user.id }
          end.to change(organization.members, :count).by(0)
        end
        it "should show explanation message" do
          post :remove_member, {id: organization.id, member_id: user.id }
          expect(flash[:error]).to eq "You cannot remove organization admin. Change admin first or delete organization."
        end
      end
    
      describe "when removing user that is not a member of organization" do
        before do
          @user2_org = organization.id + 1
          @user2 = FactoryGirl.create(:user, organization_id: @user2_org)
        end
        it "should not change user's organization_id" do
          post :remove_member, {id: organization.id, member_id: @user2.id }
          expect(@user2.organization_id).to eq @user2_org
        end
        it "should not change organization members count" do
          expect do
            post :remove_member, {id: organization.id, member_id: @user2.id }
          end
        end
      end

    end
    describe "when logged in as non-admin member" do
      before { OrganizationsController.any_instance.stub(:current_user).and_return(@user) }
      
      describe "when removing himself" do
        it "should change user's organization_id" do
          post :remove_member, {id: organization.id, member_id: @user.id }
          expect(User.find(@user.id).organization_id).to eq nil
        end
        it "should change organization members count" do
          expect do
            post :remove_member, {id: organization.id, member_id: @user.id }
          end.to change(organization.members, :count).by(-1)
        end
        it "should have correct members" do
          post :remove_member, {id: organization.id, member_id: @user.id }
          expect(organization.members).to eq [user]
        end
      end

      describe "when removing other member" do
        before do
          @user2 = FactoryGirl.create(:user, organization_id: organization.id)
        end
        it "should not change user's organization_id" do
          post :remove_member, {id: organization.id, member_id: @user2.id }
          expect(User.find(@user2.id).organization_id).to eq organization.id
        end
        it "should not change organization members count" do
          expect do
            post :remove_member, {id: organization.id, member_id: @user2.id }
          end.to change(organization.members, :count).by(0)
        end
        it "should have correct members" do
          post :remove_member, {id: organization.id, member_id: @user2.id }
          expect(organization.members).to eq [user, @user, @user2]
        end
      end
    end
  end
  
  describe "#change_admin" do
    before :each do
      @organization = Organization.create(name: "org_name", admin_id: user.id) 
    end
    let(:user2) { FactoryGirl.create(:user, organization_id: @organization.id) }
    let(:user3) { FactoryGirl.create(:user, organization_id: @organization.id + 1) }
    describe "when logged in as organization admin" do
      before do
        OrganizationsController.any_instance.stub(:current_user).and_return(user)
      end

      describe "when changing admin to member of the organization" do
        it "should change admin_id" do
          post :change_admin, { id: @organization.id, new_admin_id: user2.id }
          expect(Organization.find(@organization.id).admin_id).to eq user2.id
        end
      end

      describe "when changing admin to user that is not a member of organization" do
        before { post :change_admin, { id: @organization.id, new_admin_id: user3.id } }
        it "should not change admin_id" do
          expect(Organization.find(@organization.id).admin_id).to eq user.id
        end
        it "should show explanation message" do
          expect(flash[:error]).to eq "Can't change admin to user that is not a member of organization. Invite him first."
        end
      end

      describe "when changin admin to non-existent user" do
        it "should not change admin_id" do
          post :change_admin, { id: @organization.id, new_admin_id: 99999 }
          expect(Organization.find(@organization.id).admin_id).to eq user.id
        end
      end
    end
    
    describe "when not logged in as organization admin" do
      before do
        OrganizationsController.any_instance.stub(:current_user).and_return(user2) 
      end

      describe "when changing admin to member of the organization" do
        it "should not change admin_id" do
          post :change_admin, { id: @organization.id, new_admin_id: user2.id }
          expect(Organization.find(@organization.id).admin_id).to eq user.id
        end
      end
    end
  end

  describe "#show" do
    before :each do
      @member1 = FactoryGirl.create(:user)
      @organization = Organization.create(name: "OrgCorp", admin_id: @member1.id)
      @member1.organization_id = @organization.id
      @member1.save!
      @member2 = FactoryGirl.create(:user, organization_id: @organization.id)
      @not_member1 = FactoryGirl.create(:user, organization_id: @organization.id+1)
      @not_member2 = FactoryGirl.create(:user)
      @member1.microposts.create(content: "post1")
      @member1.microposts.create(content: "post2")
      @member2.microposts.create(content: "post3")
      @not_member1.microposts.create(content: "post4")
      @not_member2.microposts.create(content: "post5")

      get :show, { id: @organization.id, page: 1}
    end
    it "should show organization" do
      assigns(:organization).should == @organization
    end
    it "should show only members" do
      assigns(:members).should == [@member1, @member2]
    end
    it "should have proper number of posts" do
      assigns(:microposts).count.should == 3
    end
  end

  describe "#list_members" do
    before :each do
      @member1 = FactoryGirl.create(:user)
      @organization = Organization.create(name: "OrgCorp", admin_id: @member1.id)
      @member1.organization_id = @organization.id
      @member1.save!
      @member2 = FactoryGirl.create(:user, organization_id: @organization.id)
      @not_member1 = FactoryGirl.create(:user, organization_id: @organization.id+1)
      @not_member2 = FactoryGirl.create(:user)
      get :list_members, { id: @organization.id }
    end
    it "should show organization" do
      assigns(:organization).should == @organization
    end
    it "should show only members" do
      assigns(:members).should == [@member1, @member2]
    end
    it "should show admin" do
      assigns(:admin).should == @member1
    end
  end

  describe "#index" do
    before do
      @user1 = FactoryGirl.create(:user)
      @org1 = Organization.create(name: "Org1", admin_id: @user1.id)
      @user1.organization_id = @org1.id
      @user1.save!
      @user2 = FactoryGirl.create(:user)
      @org2 = Organization.create(name: "Org2", admin_id: @user2.id)
      @user2.organization_id = @org2.id
      @user2.save!

      get :index
    end

    it "should show all organizations" do
      assigns(:organizations).should == [@org1, @org2]
    end
  end


end
