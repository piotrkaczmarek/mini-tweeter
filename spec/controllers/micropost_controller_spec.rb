require 'spec_helper'

describe MicropostsController do
  before(:each) do
    MicropostsController.any_instance.stub(:signed_in_user)
  end
  describe "#rate_it" do
    before(:each) do
      @fake_post = mock('post1')
      @fake_post.stub(:rate_it)
      @fake_post.stub(:save).and_return(true)
      Micropost.stub(:find_by_id).and_return(@fake_post)
      MicropostsController.any_instance.stub(:current_user).
        and_return(FactoryGirl.create(:user))
    end
    describe "user rates micropost for the first time" do
      it "should call find_by_id method" do
        Micropost.should_receive(:find_by_id).with("1")
        put :rate, { rate: 4, id: 1 }
      end
      it "should call rate_it method" do
        @fake_post.should_receive(:rate_it)
        put :rate, { rate: 4, id: 1}
      end
    end

    describe "user rates micropost for the second time" do
      it "should call find_by_id method" do
        Micropost.should_receive(:find_by_id).with("1")
        put :rate, { rate: 4, id: 1 }
      end
      it "should call rate_it method" do
        @fake_post.should_receive(:rate_it)
        put :rate, { rate: 4, id: 1 }
      end
    end
  end

  describe "#answer" do
    before do
      @fake_post = mock('post1')
      @fake_post.stub(:id).and_return(1)
      Micropost.stub(:find_by_id).and_return(@fake_post)
    end
    it "should find post" do
      Micropost.should_receive(:find_by_id).with("1")
      post :answer, { id: 1 }
    end
  end


end 
