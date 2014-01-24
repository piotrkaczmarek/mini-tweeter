class InvitationsController < ApplicationController
  before_action :signed_in_user

  def create
    @user = User.find(params[:user_id])
    if organization = current_user.admined_organization
      organization.invite @user
    end
    redirect_to @user
  end

  def accept
    invitation = Invitation.find(params[:id])
    user = invitation.user
    if current_user? user
      if user.admined_organization.nil?
        user.add_to invitation.organization
        invitation.delete
      else
        flash[:error] = "You are an admin of #{user.admined_organization.name} and you cannot join #{invitation.organization.name} unless you give admin rights to someone else or you delete #{user.admined_organization.name}"
      end
    end 
    redirect_to root_url
  end

  def destroy
    invitation = Invitation.find(params[:id])
    if current_user.admined_organization == invitation.organization or current_user? invitation.user
      invitation.delete
    end
    redirect_to invitation.user
  end
end
