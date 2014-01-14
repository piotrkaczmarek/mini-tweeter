When(/^I give micropost (\d+) a rate of (\d+)$/) do |arg1, arg2|
  click_button("rate_micropost_#{arg1}_with_#{arg2}")
end

Given /the following microposts exist/ do |microposts_table|
  microposts_table.hashes.each do |micropost|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    micropost[:user] = User.find_by_name(micropost[:user])
    Micropost.create!(micropost)
  end
end

