require 'spec_helper'

describe UsersController do


  describe "SessionsHelper.organization_admined_by(user)" do
    let(:user) { FactoryGirl.create(:user)}
    before { UsersController.any_instance.stub(:current_user).and_return(user) }

    describe "when current_user admins organization" do
      let(:user2) { FactoryGirl.create(:user)}
      let(:organization) { Organization.create(name: "Org1", admin_id: user.id) }
      before do
        user.organization_id = organization.id 
        get :show, { id: user2.id }
      end
      it "should show organization" do
        assigns(:org_admined_by_current_user).should == organization
      end
    end

    describe "when current_user does not admin organization" do
      before do
        get :show, { id: user.id }
      end
      it "should set @organization to nil" do
        assigns(:org_admined_by_current_user).should == nil
      end
    end
  

  end

  describe "#index" do
    let(:user1) { FactoryGirl.create(:user, name: "Bob") }
    let(:user2) { FactoryGirl.create(:user, name: "bobek") }
    let(:user3) { FactoryGirl.create(:user, name: "Rob") }
    before { sign_in user1, no_capybara: true }

    describe "when not searching" do
      it "should display all users" do
        get :index
        assigns(:users).should include(user1, user2, user3)
      end
    end
    
    describe "when searching by name" do
      it "should display matching users" do
        get :index, { q: "Bob" }
        assigns(:users).should include(user1, user2)       
      end
      it "should not display not matching users" do
        get :index, { q: "Bob" }
        assigns(:users).should_not include(user3) 
      end
    end
    
  end

end
