class StaticPagesController < ApplicationController
  def home
    if signed_in?
      if flash[:original_post_id]
        @original_post = Micropost.find_by_id(flash[:original_post_id])
        post_begining = "@#{@original_post.user.name}: "
        @micropost = current_user.microposts.build(content: post_begining, answer_to_id: @original_post.id) 
      else
        @micropost = current_user.microposts.build
      end
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
