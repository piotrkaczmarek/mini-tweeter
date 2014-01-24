module UsersHelper

  def gravatar_for(user, options = { size: 50 })
    enabled = false
    if enabled
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: "gravatar")
    else
      nil
    end
  end

  def already_invited?
    @invitation = Invitation.where(user_id: @user.id, organization_id: @org_admined_by_current_user)
    not @invitation.empty?
  end

  def already_member?
    @user.organization_id == @org_admined_by_current_user.id
  end

end
