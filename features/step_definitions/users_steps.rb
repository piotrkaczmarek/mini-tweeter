Given /^I am logged in as (\w+)$/ do |user_name|
  visit signin_path
  @user = User.find_by_name(user_name)
  fill_in "Email",    with: @user.email
  fill_in "Password", with: "password"
  click_button "Sign in"
  expect(page).to have_link('Sign out', href: signout_path)
end

Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    if user[:organization_id] == 'nil'
      user[:organization_id] = nil
    end
    user[:password] = "password"
    user[:password_confirmation] = user[:password]
    User.create!(user)


  end
end

Given /the following relationships exist/ do |relationships_table|
  relationships_table.hashes.each do |relationship|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    follower = User.find_by_name(relationship[:follower_id])
    followed = User.find_by_name(relationship[:followed_id])
    follower.follow!(followed)
  end
end

Given /^I follow (\w+)$/ do |user_name|
  followed =  User.find_by_name(user_name)
  @user.follow!(followed)
end
