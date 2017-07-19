When /^I upload avatar$/ do
  avatar = File.join(Rails.root, *%w[features fixtures photos], "intern chair.jpg")
  attach_file('user_avatar', avatar)
end

When /^I update company settings$/ do
  fill_in "company_name", with: "Updated name"
  fill_in "company_url", with: "http://updated-url.example.com"
  fill_in "company_email", with: "updated@example.com"
  fill_in "company_description", with: "this is updated description"
  within('form[@id="edit_company"]') do
    find('input[@type="submit"]').click
  end
end

When /^I update payouts settings$/ do
  if @paypal_gateway.present?
    fill_in "merchant_account_email", with: "paypal-update@example.com"
  else
    fill_in "company_payments_mailing_address_attributes_address", with: "Adelaide, South Australia, Australia"
  end
  find('input[@type="submit"]').click
end

Given /^no payout gateway defined$/ do
  PaymentGateway.destroy_all
end

Given /^paypal gateway is properly configured$/ do
  @paypal_gateway ||= PaymentGateway::PaypalAdaptivePaymentGateway.first || FactoryGirl.create(:paypal_adaptive_payment_gateway)
end

Then /^The company payouts settings should be updated$/ do
  company = model!("the company")
  if @paypal_gateway.blank?
    assert_equal "Adelaide, South Australia, Australia", company.mailing_address
  else
    assert_equal 1, company.reload.merchant_accounts.count
    assert_equal @paypal_gateway.id, company.reload.merchant_accounts.last.payment_gateway_id
    assert company.reload.merchant_accounts.last.verified?
  end
end

Then /^The company should be updated$/ do
  company = model!("the company")
  assert_equal "Updated name", company.name
  assert_equal "http://updated-url.example.com", company.url
  assert_equal "updated@example.com", company.email
  assert_equal "this is updated description", company.description
end

When /^I enable white label settings$/ do
  find('.company_white_label_enabled label.checkbox').click
end

When /^I update company white label settings$/ do
  fill_in "company_theme_attributes_contact_email", with: "test@domain.lvh.me"
  fill_in "company_theme_attributes_support_email", with: "test@domain.lvh.me"
  fill_in "company_domain_attributes_name", with: "domain.lvh.me"
  find(:css, 'input[type=submit]').click
end

Then /^The company white label settings should be updated$/ do
  company = model!("the company")
  assert_equal "domain.lvh.me", company.reload.domain.try(:name)
end