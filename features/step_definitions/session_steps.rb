Given(/^I am logged in as #{capture_model}$/) do |user_instance|
  login model!(user_instance)
end

When(/^I log in as #{capture_model}$/) do |user_instance|
  login model!(user_instance)
end

Given /^I am logged in manually$/ do
  sign_up_manually
end

Then /^I should be logged out$/ do
  step "I should see \"Log In\""
end

Given (/^I am not logged in as #{capture_model}$/) do |user_instance|
  if page.has_content?("Log Out")
    user = model!(user_instance)
    click_link user.first_name
    click_link "Log Out"
  end
end

Then(/^I should be logged in as #{capture_model}$/) do |user_instance|
  user = model!(user_instance)
  Then "I should see \"Log Out\""
end

Then /^I should( not)? be redirected to the previous search page$/ do |without_redirect|
  current_path = URI.parse(current_url)
  if without_redirect
    assert_equal new_user_session_path, current_path.path
  else
    assert_equal search_path(:q => "Auckland"), [current_path.path, "?", current_path.query].join
  end
end

Then /^#{capture_model} should have password "([^"]*)"$/ do |user_instance, password|
  user = model!(user_instance)
  user.valid_password?(password).should be_true
end
