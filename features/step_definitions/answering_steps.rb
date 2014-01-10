When /^I answer (\w+)'s latest micropost$/ do |original_poster_name|
  original_poster = User.find_by_name(original_poster_name)
  post = original_poster.microposts.last
  click_button("answer_micropost_#{post.id}")
end


Then /^I should see "([^"]*)" button/ do |name|
  should have_button name
end
Then /^I should not see "([^"]*)" button/ do |name|
  should have_no_button name
end
