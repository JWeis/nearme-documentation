namespace :instance_profile do
  desc "fix instance profile issue"
  task :fix => :environment do
    puts 'InstanceProfileType correction started...'
    Instance.find_each do |i|
      PlatformContext.current = PlatformContext.new(i)
      profile_type = i.instance_profile_types.first_or_create(name: "User Instance Profile")
      User.where(admin: [nil, false]).where('instance_profile_type_id is null').update_all(instance_profile_type_id: profile_type.id)
    end
    puts 'Done'
  end

  desc 'creates instance profile types'
  task :populate => :environment do
    InstanceProfileType.where(name: 'Instance Profile Type').update_all(name: 'Default')
    InstanceProfileType.where(name: 'User Instance Profile').update_all(name: 'Default')
    Instance.find_each do |instance|
      instance.set_context!
      puts "Processing #{instance.name}"
      seller = instance.instance_profile_types.where(name: 'Seller', profile_type: InstanceProfileType::SELLER).first_or_create!
      buyer = instance.instance_profile_types.where(name: 'Buyer', profile_type: InstanceProfileType::BUYER).first_or_create!
      User.find_each do |u|
        if u.listings.count > 0
          u.create_seller_profile!(instance_profile_type: seller) if u.seller_profile.blank?
        end
        if u.reservations.count > 0 || u.orders.count > 0
          u.create_buyer_profile!(instance_profile_type: buyer) if u.buyer_profile.blank?
        end
      end
    end

  end
end
