require 'spec_helper'

describe Rate do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  before { @micropost = user1.microposts.build(content: "Lorem ipsum", id: 1 ) }
  before { @rate = @micropost.add_rate(user2.id,3) }

  subject { @rate }

  it { should respond_to(:user_id) }
  it { should respond_to(:micropost_id) }
  it { should respond_to(:score) }
  its(:score) { should eq 3 }
  its(:user_id) { should eq user2.id }
  its(:micropost_id) { should eq @micropost.id }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @rate.user_id = nil }
    it { should_not be_valid }
  end
  describe "when micropost_id is not present" do
    before { @rate.micropost_id = nil }
    it { should_not be_valid }
  end

end
