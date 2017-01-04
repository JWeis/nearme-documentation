# frozen_string_literal: true
module Graph
  module Types
    User = GraphQL::ObjectType.define do
      name 'User'
      description 'A user'

      global_id_field :id

      field :id, !types.ID
      field :name, !types.String
      field :custom_attribute,
            !types.String,
            'Fetch any custom attribute by name, ex: hair_color: custom_attribute(name: "hair_color")' do
        argument :name, !types.String
        resolve -> (obj, arg, _ctx) { obj.properties[arg[:name]] }
      end

      field :custom_attribute_photos,
            !types[Types::Image],
            'Fetch images for photo custom attribute by name,
             ex: cover_images: custom_attribute_photo(name: "cover_image")' do
        argument :name, !types.String
        resolve Graph::Resolvers::Users::CustomAttributePhotos.new
      end

      field :profile_path, !types.String
      field :avatar_url_thumb, !types.String
      field :avatar_url_bigger, !types.String
      field :name_with_affiliation, !types.String
      field :display_location, !types.String
      field :current_address, Types::Address
    end

    UserFilterEnum = GraphQL::EnumType.define do
      name 'UserFilter'
      description 'Available filters'
      value('FEATURED', 'Featured users')
      value('FEED_NOT_FOLLOWED_BY_USER', 'Not followed by current user')
    end
  end
end