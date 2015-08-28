class ReviewsController < ApplicationController

  def index
    if params[:subject].blank? || params[:reviewable_parent_type].blank? || params[:reviewable_parent_id].blank?
      render nothing: true, status: :bad_request
    else
      @reviewable_parent = case params[:reviewable_parent_type]
       when 'Transactable'
         Transactable
       when 'Spree::Product'
         Spree::Product
       when 'User'
         User
       else
         raise NotImplementedError
       end.with_deleted.find(params[:reviewable_parent_id])

       # do not try to set default params[:page] - see reviews/index.html.haml
       tab_content, tab_header =
         Rails.cache.fetch(['reviews_view', @reviewable_parent, params[:subject], params[:page].present? ? params[:page] : 1], expires_in: 2.hours) do
         case params[:subject]
         when RatingConstants::TRANSACTABLE
           @reviews = @reviewable_parent.reviews.includes(:rating_answers, { rating_system: :rating_questions })
           @average_rating = @reviewable_parent.try(:average_rating)
           @question_average_rating = @reviewable_parent.question_average_rating
         when RatingConstants::HOST
           @reviews = Review.about_seller(@reviewable_parent).includes(:rating_answers, { rating_system: :rating_questions })
           @average_rating = @reviewable_parent.seller_average_rating
           @question_average_rating = @reviewable_parent.question_average_rating(@reviews)
         else
           raise NotImplementedError
         end
         @total_reviews = @reviews.length
         @reviews = @reviews.paginate(page: params[:page], total_entries: @total_reviews)
         @rating_questions = RatingSystem.active_with_subject(params[:subject]).try(:rating_questions)
          [
            render_to_string(template: 'reviews/index', formats: [:html], layout: false),
            render_to_string(partial: 'reviews/tab_header', formats: [:html])
          ]
        end
       render json: { tab_content: tab_content, tab_header: tab_header }
    end
  end

end

