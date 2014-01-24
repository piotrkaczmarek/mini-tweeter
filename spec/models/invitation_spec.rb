require 'spec_helper'

describe Invitation do
  
  describe 'validation' do
    let(:user) { FactoryGirl.create(:user) }
    let(:org_admin) { FactoryGirl.create(:user) }
    let(:organization) { Organization.create(name: "org1", admin_id: org_admin.id) }
    let(:invitation) {organization.invitations.build(user_id: user.id) }

    subject { invitation }
    
    it { should be_valid }

    it { should respond_to(:user) }
    it { should respond_to(:organization) }
    its(:user) { should eq user }
    its(:organization) { should eq organization }
   
    describe "when not valid" do
      describe "when there is no organization" do
        before { invitation.organization_id = nil }
        it { should_not be_valid }
      end
      describe "when there is no user" do
        before { invitation.user_id = nil }
        it { should_not be_valid }
      end
    end

  end
end
