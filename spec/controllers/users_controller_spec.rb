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

end
