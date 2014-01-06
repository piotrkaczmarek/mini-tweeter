class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy, :rate]
  before_action :correct_user, only: :destroy
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:succes] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def rate
    @micropost = Micropost.find_by_id(params.require(:id))
    if @micropost
      user = current_user
      @micropost.rate_it(user.id,params.require(:rate).to_f)
      if @micropost.save
        flash[:succes] = "You just gave this post #{params[:rate]} points!"
      else
        flash[:error] = "Rating failed!"
      end
    else
      flash[:error] = "Error: micropost database query failed!"
    end
    redirect_to root_url
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
