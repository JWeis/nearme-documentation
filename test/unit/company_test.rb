require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

  should belong_to(:creator)
  should have_many(:locations)

  should validate_presence_of(:name)
  should validate_presence_of(:description)
  should_not allow_value('not_an_email').for(:email)
  should allow_value('an_email@domain.com').for(:email)
  should_not allow_value('not_a_url').for(:url)
  should allow_value('http://a-url.com').for(:url)

end