class UsersController < ApplicationController
  before_action :signed_in_user,
                only: [:index,:edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    if params[:q]
      regex = "^#{params[:q]}"
      @users = User.select("id","name","organization_id").where("name ~* ?",regex).paginate(page: params[:page])
    else
      @users = User.select("id","name","organization_id").paginate(page: params[:page])
    end
  end

  def show
    @org_admined_by_current_user = organization_admined_by(current_user)
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Mini-tweeter!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def new
    @user = User.new
  end

  def edit
    #@user = User.find(params[:id]) # can be omitted as before_action does it
  end

  def update
    #@user = User.find(params[:id]) # can be omitted as before_action does it
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
private

    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)    
    end

  # Before filters


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end 

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def organization_admined_by(user)
      begin
        return Organization.find_by_admin_id(user.id)
      rescue
        return nil
      end
    end
end
