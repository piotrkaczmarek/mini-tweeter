require 'spec_helper'

describe InvitationsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:org_admin) { FactoryGirl.create(:user) }
  let(:organization) { Organization.create(name: "org1", admin_id: org_admin.id) }
  before { org_admin.add_to organization }


  describe "#create" do

    describe "when user is signed in as organization admin" do
      before { sign_in org_admin, no_capybara: true }

      describe "when user is not a member of this organization" do
        it "should increase invitation count" do
          expect do
            post :create, { user_id: user.id, organization_id: organization.id }
          end.to change(Invitation, :count).by(1)
        end
      end

      describe "when user is already invited to this organization" do
        before :each do
          Invitation.create(user_id: user.id, organization_id: organization.id)
        end
        it "should not increase invitation count" do
          expect do
            post :create, { user_id: user.id, organization_id: organization.id }
          end.to change(Invitation, :count).by(0)
        end
      end
    
      describe "when user is a member of this organization" do
        before do
          user.add_to organization
        end
        it "should not increase invitation count" do
          expect do
            post :create, { user_id: user.id, organization_id: organization.id }
          end.to change(Invitation, :count).by(0)
        end
      end
    end

    describe "when user is not signed in as organization admin" do
      before do
        sign_in user, no_capybara: true
      end
     
      describe "when there is an attempt to invite someone" do
        it "should not change invitation count" do
          expect do
            post :create, { user_id: user.id, organization_id: organization.id }
          end.to change(Invitation, :count).by(0)
        end
      end
    end
  end

  describe "#accept" do

    describe "when user is signed in as invited user" do
      before do
        sign_in user, no_capybara: true
      end

      describe "when is invited to organization" do
        before :each do
          @invitation = Invitation.create(user_id: user.id, organization_id: organization.id)
        end

        describe "and he is not in any other organization" do
          it "should delete invitation" do
            post :accept, { id: @invitation.id }
            expect(Invitation.count).to eq 0
          end
          it "should change organization members count" do
            expect do
              post :accept, { id: @invitation.id }
            end.to change(Organization.find(organization.id).members, :count).by(1)
          end
          it "should change user's organization id" do
            post :accept, { id: @invitation.id }
            expect(User.find(user.id).organization_id).to eq organization.id
          end
        end

        describe "and he is already a member of different organization" do
          let(:other_org_admin) { FactoryGirl.create(:user) }
          let(:other_org) { Organization.create(name: "other",admin_id: other_org_admin.id) }
          before :each do
            other_org_admin.add_to other_org
            user.add_to other_org      
          end
 
          it "should delete invitation" do
            post :accept, { id: @invitation.id }
            expect(Invitation.count).to eq 0
          end
          it "should change inviting organization members count" do
            expect do
              post :accept, { id: @invitation.id }
            end.to change(Organization.find(organization.id).members, :count).by(1)
          end
          it "should change members count of the former user's organization" do
            expect do
              post :accept, { id: @invitation.id }
            end.to change(Organization.find(other_org.id).members, :count).by(-1)
          end
          it "should set user's organization id to the new organization" do
            post :accept, { id: @invitation.id }  
            expect(User.find(user.id).organization_id).to eq organization.id
          end
        end
      
        describe "and he is an admin of other organization" do
          let(:other_org) { Organization.create(name: "other",admin_id: user.id) }
          before do
            user.add_to other_org      
          end   
  
          it "should not delete invitation" do
            post :accept, { id: @invitation.id }
            expect(Invitation.count).to eq 1
          end
          it "should give explanation message" do
            post :accept, { id: @invitation.id }
            expect(flash[:error]).to_not eq nil
          end
          it "should not change former organization members count" do
            expect do
              post :accept, { id: @invitation.id }
            end.to change(Organization.find(other_org.id).members, :count).by(0)      
          end
          it "should not change inviting organization members count" do
            expect do
              post :accept, { id: @invitation.id }
            end.to change(Organization.find(organization.id).members, :count).by(0)
          end
          it "should not change user's organization id" do
            post :accept, { id: @invitation.id }  
            expect(User.find(user.id).organization_id).to eq other_org.id
          end     
        end
      end
    end

    describe "when user is not signed as invited user" do
      before :each do
        @invitation = Invitation.create(user_id: user.id, organization_id: organization.id) 
        sign_in org_admin, no_capybara: true
      end

      it "should not change invitation count" do
        post :accept, { id: @invitation.id }
        expect(Invitation.count).to eq 1
      end
      it "should not change invited user organization id" do
        post :accept, { id: @invitation.id }
        expect(user.organization_id).to eq nil
      end
      it "should not change organization members count" do
        expect do
          post :accept, { id: @invitation.id }
        end.to change(Organization.find(organization.id).members, :count).by(0)  
      end
    end
  end





  describe "#destroy" do
    before :each do
      @invitation = Invitation.create(user_id: user.id, organization_id: organization.id)
      @old_user_org_id = user.organization_id
    end
    describe "when user is logged in as organization admin" do
      before { sign_in org_admin, no_capybara: true }

      it "should change invitation count" do
        expect do
          delete :destroy, { id: @invitation.id }
        end.to change(Invitation, :count).by(-1)
      end
      it "should not change organization members count" do
        expect do
          delete :destroy, { id: @invitation.id }
        end.to change(Organization.find(organization.id).members, :count).by(0)       
      end
      it "should not change members organiztion id" do
        expect(User.find(user.id).organization_id).to eq @old_user_org_id 
      end

    end

    describe "when user is logged in as invited user" do
      before { sign_in user, no_capybara: true }

      it "should change invitation count" do
        expect do
          delete :destroy, { id: @invitation.id }
        end.to change(Invitation, :count).by(-1)
      end
      it "should not change organization members count" do
        expect do
          delete :destroy, { id: @invitation.id }
        end.to change(Organization.find(organization.id).members, :count).by(0)       
      end
      it "should not change members organiztion id" do
        expect(User.find(user.id).organization_id).to eq @old_user_org_id 
      end
    end

    describe "when user is logged in as some other user" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        sign_in other_user, no_capybara: true 
      end
      it "should not change invitation count" do
        expect do
          delete :destroy, { id: @invitation.id }
        end.to change(Invitation, :count).by(0)
      end
      it "should not change organization members count" do
        expect do
          delete :destroy, { id: @invitation.id }
        end.to change(Organization.find(organization.id).members, :count).by(0)       
      end
      it "should not change members organiztion id" do
        expect(User.find(user.id).organization_id).to eq @old_user_org_id 
      end
    end
  end

end
