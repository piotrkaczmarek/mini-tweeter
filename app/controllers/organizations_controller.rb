class OrganizationsController < ApplicationController
  before_action :signed_in_user
  before_action :organization_admin, only: [:destroy, :add_member, :remove_member]

  def create
    @organization = Organization.new(organization_params)
    @organization.admin_id = current_user.id
    if @organization.save
      flash[:success] = "#{@organization.name} successfully created!"
      redirect_to root_url
    else
      render 'new'
    end
  end
  def update 

  end
  def destroy
    @organization.destroy
    redirect_to root_url
  end

  def add_member

  end

  def remove_member

  end

  private
    def organization_admin
      @organization = Organization.find(params[:id])
      redirect_to root_url unless current_user.id == @organization.admin_id
    end
    
    def organization_params
      params.require(:organization).permit(:name,:homesite_url)
    end

end
