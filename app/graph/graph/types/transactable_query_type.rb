# frozen_string_literal: true
module Graph
  module Types
    TransactableQueryType = GraphQL::ObjectType.define do
      field :transactables do
        type !types[Types::Transactable]
        argument :ids, types[types.ID], 'List of ids'
        argument :listing_type_id, types.ID
        argument :filters, types[Types::TransactableFilterEnum]
        argument :take, types.Int

        resolve Resolvers::Transactables.new
      end
    end
  end
end