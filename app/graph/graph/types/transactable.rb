# frozen_string_literal: true
module Graph
  module Types
    Transactable = GraphQL::ObjectType.define do
      name 'Transactable'

      global_id_field :id

      field :id, !types.Int
      field :created_at, types.String
      field :updated_at, types.String
      field :cover_photo_thumbnail_url, types.String
      field :cover_photo_url, types.String
      field :creator, !Types::User do
        resolve ->(obj, _arg, ctx) { Resolvers::User.new.call(nil, { id: obj.creator_id }, ctx) }
      end
      field :currency, !types.String
      field :description, types.String
      field :is_followed, !types.Boolean do
        argument :follower_id, types.ID
        resolve ->(obj, arg, _) { arg[:follower_id] ? obj.is_followed : false }
      end
      field :latitude, types.String
      field :location_id, types.ID
      field :longitude, types.String
      field :name, types.String
      field :photo_url, types.String
      field :show_path, !types.String
      field :slug, !types.String
      field :summary, types.String
      field :url, types.String
      field :time_based_booking, Types::Transactables::TimeBasedBooking
      field :orders, !types[Types::Order] do
        resolve ->(obj, _args, _ctx) { obj.source.orders }
      end
      field :custom_attribute_photos,
            !types[Types::Image],
            'Fetch images for photo custom attribute by name,
             ex: cover_images: custom_attribute_photo(name: "cover_image")
             by default they are ordered by DATE' do
        argument :name, !types.String
        argument :order, Types::CustomImageOrderEnum
        argument :order_direction, Types::OrderDirectionEnum
        resolve Graph::Resolvers::Transactables::CustomAttributePhotos.new
      end

      field :custom_attribute,
            types.String,
            'Fetch any custom attribute by name, ex: hair_color: custom_attribute(name: "hair_color")' do
        argument :name, !types.String
        resolve ->(obj, arg, _ctx) { obj.properties[arg[:name]] }
      end

      field :custom_attribute_array, !types[types.String] do
        argument :name, !types.String
        resolve ->(obj, arg, _ctx) { obj.properties[arg[:name]] }
      end
    end

    TransactableFilterEnum = GraphQL::EnumType.define do
      name 'TransactableFilter'
      description 'Available filters'
      value('ACTIVE', 'Active transactables')
      value('FEATURED', 'Featured transactables')
    end
  end
end
