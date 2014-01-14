class OrganizationsController < ApplicationController
  before_action :signed_in_user
  before_action :organization_admin, only: [:destroy, :update, :add_member, :change_admin]

  def index
    @organizations = Organization.paginate(page: params[:page])
    render 'index'
  end
  
  def new
    @organization = Organization.new(admin_id: current_user.id)
  end

  def show
    @organization = Organization.find(params[:id])
    @microposts = @organization.microposts.paginate(page: params[:page])
    render 'show'
  end

  def list_members
    @organization = Organization.find(params[:id]) unless @organization
    @members = @organization.members.paginate(page: params[:page])
    @admin = User.find(@organization.admin_id)
    render 'list_members'
  end

  def create
    @organization = Organization.new(organization_params)
    @user = current_user
    @organization.admin_id = @user.id
    if @organization.save
      @user.organization_id = @organization.id
      @user.disable_password_validation
      @user.save!
      flash[:success] = "#{@organization.name} successfully created!"
      index
    else
      render 'new'
    end
  end
  def update 
    if @organization.update_attributes(organization_params)
      flash[:success] = "Organization profile updated"
      redirect_to root_url
    else
      render 'edit'
    end
  end
  def destroy
    @organization.members.each do |member| 
      member.organization_id = nil
      member.disable_password_validation
      member.save!
    end
    @organization.destroy
    redirect_to root_url
  end

  def add_member
    @new_member = User.find(params.require(:new_member_id))
    @new_member.disable_password_validation
    if @new_member.update_attributes(organization_id: @organization.id)
      flash[:success] = "#{@new_member.name} added to #{@organization.name} successfully!"
    else
      flash[:error] = "Adding new member failed!"
    end
    redirect_to root_url
  end

  def remove_member
    @organization = Organization.find(params[:id])
    @current_user = current_user
    member_id = params.require(:member_id)

    if (member_id == @current_user.id.to_s or @current_user.id == @organization.admin_id)
      if member_id == @organization.admin_id.to_s
        flash[:error] = "You cannot remove organization admin. Change admin first or delete organization."
        redirect_to list_members_organization_url  
      else
        @member = User.find(member_id)
        @member.organization_id = nil
        @member.disable_password_validation
        @member.save!
        flash[:success] = "#{@member.name} removed from #{@organization.name}"
        redirect_to list_members_organization_url   
      end
    else
      redirect_to root_url
    end
  end

  def change_admin
    if new_admin_exists?
      if @new_admin.organization_id == @organization.id
        @organization.admin_id = @new_admin.id
        @organization.save
      else
        flash[:error] = "Can't change admin to user that is not a member of organization. Invite him first."
      end
      redirect_to root_url
    end
  end
  private
    def organization_admin
      @organization = Organization.find(params[:id])
      @current_user = current_user
      redirect_to root_url unless @current_user.id == @organization.admin_id
    end
    
    def organization_params
      params.require(:organization).permit(:name,:homesite_url)
    end

    def new_admin_exists?
      redirect_to root_url unless @new_admin = User.find_by_id(params.require(:new_admin_id))
      @new_admin
    end

end
