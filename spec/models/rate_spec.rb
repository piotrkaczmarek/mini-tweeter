require 'spec_helper'

describe Rate do

  describe "validation" do
    before do
      @user = FactoryGirl.create(:user)
      @micropost = @user.microposts.build(content: "Lorem ipsum", id: 1 )
      @rate = @micropost.rates.build(user_id: @user.id, micropost_id: @micropost.id)
    end
    subject { @rate }

    it { should respond_to(:user_id) }
    it { should respond_to(:micropost_id) }
    it { should respond_to(:score) }
    its(:user_id) { should eq @user.id }
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

end
