require 'spec_helper'

describe Micropost do
  
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum")}

  subject { @micropost }

  it { should respond_to(:content)}
  it { should respond_to(:user_id)}
  it { should respond_to(:user)}
  it { should respond_to(:rating)}
  it { should respond_to(:rated_by)}
  it { should respond_to(:rates) }
  it { should respond_to(:add_rate) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end

  describe "when rating is higher than 5.0" do
    before { @micropost.rating = 5.1 }
    before { @micropost.rated_by = 1 }
    it { should_not be_valid }
  end
  describe "when rating is lower than 0.0" do
    before { @micropost.rating = -0.1 }
    before { @micropost.rated_by = 1 }
    it { should_not be_valid }
  end
  describe "when rated_by is negative" do
    before { @micropost.rated_by = -2 }
    it { should_not be_valid }
  end

  describe "ratings" do
    describe "when there is no rates" do
      before { @micropost.valid? }
      its(:rated_by) { should eq 0 }
    end
    describe "when there is one rate" do
      before { @micropost.add_rate(user.id,3) }
      its(:rated_by) { should eq 1 }
      its(:rating) { should eq 3 }
    end
    describe "when the same user rates the same post again" do
      before { @micropost.rates.build(micropost_id: 1, user_id: 1, score: 3)} 
      before { @micropost.add_rate(1,4) }  
      its(:rated_by) { should eq 1 }
      its(:rating) { should eq 4 }
    end
    describe "when another user rates the same post" do
      before { @micropost.rates.build(micropost_id: 1, user_id: 1, score: 3)} 
      before { @micropost.rating = 3 }
      before { @micropost.rated_by = 1 }
      before { @micropost.add_rate(2,2) }  
      its(:rated_by) { should eq 2 }
      its(:rating) { should eq 2.5 }
    end

  end


end
