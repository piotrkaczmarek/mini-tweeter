class RelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    if user_id = params[:relationship][:followed_user_id]
      @user = User.find(user_id)
      current_user.follow!(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js { render action: 'create_for_user' }
      end
    elsif organization_id = params[:relationship][:followed_organization_id]
      @organization = Organization.find(organization_id)
      current_user.follow!(@organization)
      respond_to do |format|
        format.html { redirect_to @organization }
        format.js  { render action: 'create_for_organization'}
      end
    end

  end

  def destroy
    if @user = Relationship.find_by_id(params[:id]).followed_user   
      current_user.unfollow!(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js { render action: 'destroy_for_user' }
      end
    elsif @organization = Relationship.find_by_id(params[:id]).followed_organization
      current_user.unfollow!(@organization)
      respond_to do |format|
        format.html { redirect_to @organization }
        format.js { render action: 'destroy_for_organization'}
      end
    end
  end

end
