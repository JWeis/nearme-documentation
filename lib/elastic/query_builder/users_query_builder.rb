# frozen_string_literal: true
module Elastic
  module QueryBuilder
    class UsersQueryBuilder < QueryBuilderBase
      def initialize(query, instance_profile_type:, searchable_custom_attributes: [], query_searchable_attributes: [], instance_profile_types: PlatformContext.current.instance.instance_profile_types.searchable)
        @query = query

        @searchable_custom_attributes = searchable_custom_attributes
        @query_searchable_attributes = query_searchable_attributes
        @instance_profile_type = instance_profile_type
        @instance_profile_types = instance_profile_types

        @filters = []
        @not_filters = []
      end

      def regular_query
        {
          sort: sorting_options,
          query: match_query,
          filter: { bool: { must: filters } }
        }.merge(aggregations)
      end

      def simple_query
        {
          _source: @query[:source],
          sort: sorting_options,
          query: @query[:query],
          filter: { bool: { must: filters } }
        }
      end

      private

      def filters
        @filters = []
        @filters.concat profiles_filters
        @filters.concat [geo_shape] if @query.dig(:location, :lat).present?
        @filters.concat [transactable_child] if @query.dig(:transactable, :custom_attributes)
        @filters
      end

      def match_query
        if @query[:query].blank?
          { match_all: { boost: QUERY_BOOST } }
        else
          match_bool_condition = {
            bool: {
              should: [
                simple_match_query
              ]
            }
          }

          match_bool_condition[:bool][:should] << multi_match_query if @query_searchable_attributes.present?

          match_bool_condition
        end
      end

      def simple_match_query
        {
          simple_query_string: {
            query: @query[:query],
            fields: search_by_query_attributes
          }
        }
      end

      def multi_match_query
        {
          nested: {
            path: 'user_profiles',
            query: {
              multi_match: {
                query: @query[:query],
                fields: search_by_query_attributes
              }
            }
          }
        }
      end

      def search_by_query_attributes
        searchable_main_attributes + @query_searchable_attributes
      end

      def searchable_main_attributes
        ['name^2', 'tags^10', 'company_name']
      end

      def sorting_options
        sorting_fields = []

        if @query[:sort].present?
          sorting_fields = @query[:sort].split(',').compact.map do |sort_option|
            next unless sort = sort_option.match(/([a-zA-Z\.\_\-]*)_(asc|desc)/)

            default_user_profile_body = {
              order: sort[2],
              nested_path: 'user_profiles',
              nested_filter: {
                term: {
                  'user_profiles.instance_profile_type_id': @instance_profile_type.id
                }
              }
            }

            body = default_user_profile_body

            if sort[1].split('.').first == 'custom_attributes'
              sort_column = "user_profiles.properties.#{sort[1].split('.').last}.raw"
            elsif sort[1].split('.').first == 'user'
              sort_column = sort[1].split('.').last
              body = sort[2]
            else
              sort_column = sort[1]
            end

            {
              sort_column => body
            }
          end.compact
        end

        return ['_score'] if sorting_fields.empty?

        sorting_fields
      end

      # TODO: rebuild and use new aggregation builder
      def aggregation_fields
        InstanceProfileType
          .all
          .flat_map { |p| p.custom_attributes.where(aggregate_in_search: true) }
          .map do |attr|
          {
            label: attr.name,
            field: "user_profiles.properties.#{attr.name}.raw",
            size: attr.valid_values.size + 1 # plus one extra for empty
          }
        end
      end

      def profiles_filters
        @instance_profile_types.map do |profile|
          build_profile_query(profile)
        end
      end

      def build_profile_query(profile)
        { nested: { path: 'user_profiles', query: { bool: { must: Elastic::QueryBuilder::UserProfileBuilder.build(@query, profile: profile) } } } }
      end

      def geo_shape
        {
          geo_shape: {
            geo_service_shape: {
              shape: {
                type: 'Point',
                coordinates: @query[:location].values_at(:lon, :lat)
              },
              relation: 'contains'
            }
          }
        }
      end

      def transactable_child
        HasTransactableChild.new(@query).as_json
      end

      class HasTransactableChild
        attr_reader :options

        def initialize(options)
          @options = options
        end

        def as_json(*args)
          {
            has_child: {
              type: 'transactable',
              filter: {
                bool: {
                  must: custom_attributes
                }
              }
            }
          }
        end

        def custom_attributes
          options.dig(:transactable, :custom_attributes).map do |attribute, values|
            custom_attribute "custom_attributes.#{attribute}", values
          end
        end

        def custom_attribute(name, values)
          { terms: { name => values } }
        end
      end
    end
  end
end
