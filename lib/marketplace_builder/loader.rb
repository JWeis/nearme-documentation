# frozen_string_literal: true
module MarketplaceBuilder
  class Loader
    def self.load(source, options = {})
      default_options = {
        verbose: false,
        creators: [
          Creators::MarketplaceCreator,
          Creators::TransactableTypesCreator,
          Creators::InstanceProfileTypesCreator,
          Creators::ReservationTypesCreator,
          Creators::TopicsCreator,
          Creators::CategoriesCreator,
          Creators::PagesCreator,
          Creators::ContentHoldersCreator,
          Creators::MailersCreator,
          Creators::SMSCreator,
          Creators::LiquidViewsCreator,
          Creators::TranslationsCreator,
          Creators::WorkflowAlertsCreator,
          Creators::CustomModelTypesCreator,
          Creators::GraphQueriesCreator
        ]
      }
      options = options.reverse_merge(default_options)

      unless source.presence
        puts "\e[31mConfig path not provided\e[0m"
        return
      end

      source = File.expand_path(source, Rails.root)
      config_file = File.join(source, '.mpbuilderrc')

      unless File.directory? source
        puts "\e[31mTheme folder not found: #{source}\e[0m"
        return
      end

      unless File.file? config_file
        puts "\e[31m.mpbuilderrc config file not found at #{config_file}\e[0m"
        return
      end

      debug_level = options[:verbose].presence ? MarketplaceBuilder::Loggers::Logger::DEBUG : MarketplaceBuilder::Loggers::Logger::INFO

      config = JSON.parse(File.read(config_file))

      instance_id = config['instance_id']
      mode = config['mode'] || MarketplaceBuilder::MODE_APPEND

      builder = MarketplaceBuilder::Builder.new(instance_id, source, options[:creators], mode: mode, debug_level: debug_level)
      builder.execute!
    end
  end
end