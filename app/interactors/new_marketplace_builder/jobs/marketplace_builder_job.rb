module NewMarketplaceBuilder
  module Jobs
    class MarketplaceBuilderJob < Job
      def after_initialize(marketplace_release_id)
        @marketplace_release = MarketplaceRelease.find(marketplace_release_id)
      end

      def perform
        if @marketplace_release.ready_for_import?
          NewMarketplaceBuilder::Interactors::ImportInteractor.new(@marketplace_release.instance_id, @marketplace_release.zip_file, @marketplace_release.options).execute!
        elsif @marketplace_release.ready_for_export?
          NewMarketplaceBuilder::Interactors::ExportInteractor.new(@marketplace_release.instance_id, @marketplace_release).execute!
        end

        @marketplace_release.update! status: 'success'
      rescue StandardError => e
        @marketplace_release.update! status: 'error', error: e.message
        if Rails.env.development?
          raise e
        else
          Raygun.track_exception(e)
        end
      end
    end
  end
end

