
Factory.sequence :email do |n|
  "#{n}#{Time.now.to_f.to_s.gsub(/\./, '').slice(6, 20)}@example.com"
end

Factory.define :user do |u|
  u.name "Homer Simpson"
  u.email { Factory.next(:email) }
  u.remember_token "dummy_token"
  u.password 'password'
  u.password_confirmation 'password'
end

Factory.define :admin, :parent => :user, :class => User do |u|
  u.admin true
end

