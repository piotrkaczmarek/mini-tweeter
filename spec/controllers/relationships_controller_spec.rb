require 'spec_helper'

describe RelationshipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:organization) { Organization.create(name: "Org1", admin_id: other_user.id) }

  before do
    sign_in user, no_capybara: true 
    other_user.organization_id = organization.id
  end
  describe "creating a relationship with Ajax" do

    describe "following user" do
      it "should increment the Relationship count" do
        expect do
          xhr :post, :create, relationship: { followed_user_id: other_user.id }
        end.to change(Relationship, :count).by(1)
      end

      it "should respond with success" do
        xhr :post, :create, relationship: { followed_user_id: other_user.id}
        expect(response).to be_success
      end
    end
 
    describe "following organiztion" do

      it "should increment the Relationship count" do
        expect do
          xhr :post, :create, relationship: { followed_organization_id: organization.id }
        end.to change(Relationship, :count).by(1)
      end
   
      it "should respond with success" do
        xhr :post, :create, relationship: { followed_organization_id: organization.id }
        expect(response).to be_success       
      end
    end

  end

  describe "destroying a relationship with Ajax" do
    
    describe "following user" do
      before { user.follow!(other_user) }
      let(:relationship) { user.relationships.find_by(followed_user_id: other_user.id)}

      it "should decrement the Relationship count" do
        expect do
          xhr :delete, :destroy, id: relationship.id
        end.to change(Relationship, :count).by(-1)
      end

      it "should respond with success" do
        xhr :delete, :destroy, id: relationship.id
        expect(response).to be_success
      end
    end 

    describe "following organization" do
      before { user.follow!(organization) }
      let(:relationship) { user.relationships.find_by(followed_organization_id: organization.id)}

      it "should decrement the Relationship count" do
        expect do
          xhr :delete, :destroy, id: relationship.id
        end.to change(Relationship, :count).by(-1)
      end

      it "should respond with success" do
        xhr :delete, :destroy, id: relationship.id
        expect(response).to be_success
      end
    end 

   

  end
end
