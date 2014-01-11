require 'spec_helper'

describe Organization do
  describe "validation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:organization) { Organization.create(name: "corpo", admin_id: user.id) }

    before do 
      user.organization_id = organization.id
      user.save
    end
    subject { organization }
    
    it { should respond_to(:admin) }
    it { should respond_to(:name) }
    it { should respond_to(:homesite_url) }
    it { should respond_to(:admin_id) }
    it { should respond_to(:members) }

    it { should be_valid }

    describe "when name is not present" do
      before { organization.name = nil }
      it { should_not be_valid }
    end

    describe "when name is too long" do
      before { organization.name = "a"*51 }
      it { should_not be_valid }
    end
 
    describe "when admin_id is not present" do
      before { organization.admin_id = nil }
      it { should_not be_valid }
    end

    describe "#admin" do
      its(:admin) { should eq user }
    end
   
    describe "#members" do
      before do
        @user2 = FactoryGirl.create(:user, {organization_id: organization.id} )
      end
      its(:members) { should eq [user, @user2] }
    end
  end


end