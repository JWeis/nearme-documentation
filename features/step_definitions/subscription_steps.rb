When(/^I subscribe to the service$/) do
  step "I click to review the booking"
  step("I provide reservation credit card details")
  step "I click to confirm the booking"
end

Then(/^I am subscribed to the service$/) do
  user = model!("the user")
  recurring_booking = user.recurring_bookings.last
  assert_equal model!("the location"), recurring_booking.location
end

Then(/^I should see all text:$/) do |table|
  table.rows.flatten.each do |text|
    should have_content(text)
  end
end

When(/^I (confirm|cancel) the subscription$/) do |button_text|
  click_button(button_text.capitalize)
end