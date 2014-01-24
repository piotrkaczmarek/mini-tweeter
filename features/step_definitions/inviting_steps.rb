Then(/^there should be invitation to (.+) for (\w+)$/) do |organization_name, user_name|
  user = User.find_by_name(user_name)
  organization = Organization.find_by_name(organization_name)
  invitation = Invitation.where(user_id: user.id, organization_id: organization.id)
  expect(invitation.empty?).to eq false
end
Then(/^there should be no invitation to (.+) for (\w+)$/) do |organization_name, user_name|
  user = User.find_by_name(user_name)
  organization = Organization.find_by_name(organization_name)
  invitation = Invitation.where(user_id: user.id, organization_id: organization.id)
  expect(invitation.empty?).to eq true
end

And(/^I invite (\w+)$/) do | user_name |
  step %{I am on #{user_name}'s user page}
  step %{I press "Invite to #{@user.organization.name}"} 
end

Given /the following invitations exist/ do |invitations_table|
  invitations_table.hashes.each do |invitation|
    user = User.find_by_name(invitation[:invited_user])
    organization = Organization.find_by_name(invitation[:inviting_organization])
    Invitation.create(user_id: user.id, organization_id: organization.id)
  end
end

Then(/^I should be a member of (.+)$/) do |organization_name|
  organization = Organization.find_by_name(organization_name)
  expect(User.find(@user.id).organization).to eq organization
end

Then /^I should not be in any organization$/ do
  expect(User.find(@user.id).organization).to eq nil
end
