require 'spec_helper'

describe Relationship do
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_user_id: followed.id) }

  describe "following user" do


    subject { relationship }
  
    it { should be_valid }
  
    describe "follower methods" do
      it { should respond_to(:follower) }
      it { should respond_to(:followed_user) }
      its(:follower) { should eq follower }
      its(:followed_user) { should eq followed }
      its(:followed_organization) { should eq nil }
    end
  
    describe "when followed user id is not present" do
      before { relationship.followed_user_id = nil }
      it { should_not be_valid }
    end
  
    describe "when follower id is not present" do
      before { relationship.follower_id = nil }
      it { should_not be_valid }
    end

    describe "when followed organization id is not present" do
      before { relationship.followed_organization_id = nil }
      it { should be_valid }
    end

  end

  describe "following organization" do

    let(:unfollowed) { FactoryGirl.create(:user) }
    let(:followed_organization) { Organization.create(name: "Org1", admin_id: unfollowed.id)}
    before { unfollowed.organization_id = followed_organization.id }
    let(:following_organization) { follower.relationships.build(followed_organization_id: followed_organization.id) }
  
    subject { following_organization }

    it { should be_valid }

    describe "follower methods" do
      it { should respond_to(:follower) }
      it { should respond_to(:followed_organization) }
      it { should respond_to(:followed_user) }
      its(:follower) { should eq follower }
      its(:followed_organization) { should eq followed_organization }
      its(:followed_user) { should eq nil }
    end

    describe "when followed organization id is not present" do
      before { following_organization.followed_organization_id = nil }
      it { should_not be_valid }
    end

    describe "when follower id is not present" do
      before { following_organization.follower_id = nil }
      it { should_not be_valid }
    end

    describe "when followed user id is not present" do
      before { following_organization.followed_user = nil }
      it { should be_valid }
    end

  end

end
