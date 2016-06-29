module Api
  class V2::ReverseProxyLinksController < BaseController

    skip_before_filter :require_authentication

    def index
      @scope = ReverseProxyLink.all
      @scope = @scope.where(use_on_path: params[:filter]) if params[:filter]
      render json: ApiSerializer.serialize_collection(@scope)
    end

    def create
      ReverseProxyLink.transaction do
        @error_reverse_proxy_link = ReverseProxyLink.new
        params[:data].each do |use_on_path, links_data|
          links_data.each do |link_data|
            ReverseProxyLink.where(use_on_path: use_on_path).destroy_all
            @reverse_proxy_link = ReverseProxyLink.new(use_on_path: use_on_path, destination_path: link_data[:url], name: link_data[:name])
            unless @reverse_proxy_link.save
              @error_reverse_proxy_link.errors.add(use_on_path, @reverse_proxy_link.errors.full_messages.join(', '))
            end
          end
        end
        raise ActiveRecord::Rollback if @error_reverse_proxy_link.errors.any?
      end

      if @error_reverse_proxy_link.errors.any?
        render json: ApiSerializer.serialize_errors(@error_reverse_proxy_link.errors)
      else
        render nothing: true, status: 204
      end
    end
  end
end

