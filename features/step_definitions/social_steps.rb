Before do
  disable_remote_http
end

Given /^the (.*) OAuth request is successful$/ do |social|
  mock_successful_authentication_with_provider(social)
end

Given /^the (.*) OAuth request is unsuccessful$/ do |social|
  mock_unsuccessful_authentication_with_provider(social)
end

Given /^Existing user with (.*) email$/ do |social|
  pre_existing_user({:email => "#{social.downcase}@example.com"})
end

When /I sign up with (.*)$/ do |social|
  sign_up_with_provider(social)
end

Given /I signed up with (.*) without password$/ do |social|
  mock_successful_authentication_with_provider(social)
  sign_up_with_provider(social)
end

Given /I signed up with (.*) with password$/ do |social|
  sign_up_manually({:email => "#{social.downcase}@example.com"})
  mock_successful_authentication_with_provider(social)
  toggle_connection_with(social)
end

When /I connect to (.*)$/ do |social|
  mock_successful_authentication_with_provider(social)
  toggle_connection_with(social)
end

When /I disconnect (.*)/ do |social|
  toggle_connection_with(social)
end

When /I want to disconnect/ do
  visit edit_user_registration_path
end

Then /I cannot disconnect (.*)$/ do |social|
  toggle_connection_with(social)
  assert_not_nil Authentication.find_by_provider(social.downcase)
end

When /I try to sign up with (.*)$/ do |social|
  try_to_sign_up_with_provider(social)
end

When /I type in my password in edit page/ do
  update_current_user_information({:password => 'my_password'})
end

Then /I should have password/ do
  assert User.first.has_password?
end

When /I manually sign up with valid credentials$/ do 
  sign_up_manually({:name => 'User-1'})
end

When /I sign in with valid credentials/ do 
  login_manually
end

Given /There is no user with my email/ do
end

Then /an account should be created for that (.*) user$/ do |social|
  social = social.downcase
  user = Authentication.find_by_provider(social).user
  assert_equal "#{social}@example.com", user.email
  assert_equal 1, user.authentications.count
  assert_equal social, user.authentications.first.provider
end

Then /account of valid user should be connected with (.*)$/ do |social|
  social = social.downcase
  user = Authentication.find_by_provider(social).user
  assert_equal "valid@example.com", user.email
  assert_equal 1, user.authentications.count
  assert_equal social, user.authentications.first.provider
end

Then /there should be no (.*) account$/ do |social|
  assert_nil Authentication.find_by_provider(social.downcase)
end

Then /there should be (Twitter|Facebook|LinkedIn) account$/ do |social|
  assert_not_nil Authentication.find_by_provider(social.downcase)
end

Then /I am correctly signed in/ do
  user = User.find_by_email('valid@example.com')
  assert_equal "User-1", user.name
  assert_equal 1, User.all.count
end


