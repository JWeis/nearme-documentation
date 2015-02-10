class BuySellMarket::ProductsController < ApplicationController
  before_filter :set_product, only: [:show, :add_to_wish_list]
  before_filter :theme_name, only: [:show]

  def show
    begin
      @product = @product.decorate
      @product_properties = @product.product_properties.includes(:property)
      @product.track_impression(request.remote_ip)
      @rating_questions = RatingSystem.find_by(subject: platform_context.instance.bookable_noun).rating_questions
      @reviews = @product.reviews.paginate(page: params[:reviews_page])
    rescue ActiveRecord::RecordNotFound
      raise Transactable::NotFound
    end
  end

  private

  def set_product
    @product = Spree::Product.searchable.friendly.find(params[:id])
  end

  def theme_name
    @theme_name = 'buy-sell-theme'
  end
end
