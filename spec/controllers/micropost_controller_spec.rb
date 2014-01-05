require 'spec_helper'

describe MicropostsController do
  describe "rating micropost" do
    
    it "should call find_by_id method" do

      MicropostsController.any_instance.stub(:signed_in_user)
      Micropost.should_receive(:find_by_id).with("1")
      put :rate, { rate: 4, id: 1 }
    end
    it "should call add_rate method" do
      MicropostsController.any_instance.stub(:signed_in_user)
      MicropostsController.any_instance.stub(:current_user).
        and_return(FactoryGirl.create(:user))
      fake_post = Micropost.new(id: 1)
      Micropost.stub(:find_by_id).and_return(fake_post)
      fake_post.should_receive(:add_rate)
      put :rate, { rate: 4, id: 1 }
    end
  end
end 
