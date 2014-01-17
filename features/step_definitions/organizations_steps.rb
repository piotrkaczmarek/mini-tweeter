Given /the following organizations exist/ do |organizations_table|
  organizations_table.hashes.each do |organization|
    Organization.create!(organization)
  end
end

Given /I create organization named "(.+)" with homesite "(.+)"/ do |name, homesite_url |
  fill_in "Name",    with: name
  fill_in "Homesite url", with: homesite_url
  click_button "Create new organization"

end

Given /^I remove (.+)$/ do |member|
  member = User.find_by_name(member)
  with_scope ("li#member_#{member.id}") do
    click_link("remove") 
  end
end

Given /^I follow organization (\w+)$/ do |organization_name|
  followed =  Organization.find_by_name(organization_name)
  @user.follow!(followed)
end

Then /^I should be following organization (\w+)$/ do |organization_name|
  organization = Organization.find_by_name(organization_name)
  assert @user.following?(organization)
end
