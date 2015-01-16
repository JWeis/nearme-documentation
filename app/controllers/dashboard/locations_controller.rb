class Dashboard::LocationsController < Dashboard::BaseController
  before_filter :redirect_if_draft_listing
  before_filter :find_location, except: [:new, :create]

  def new
    @location = @company.locations.build
    @location.administrator_id = current_user.id if current_user.is_location_administrator?
    @location.name_and_description_required = true if TransactableType.first.name == "Listing"
    build_approval_request_for_object(@location) unless @location.is_trusted?
    AvailabilityRule.default_template.apply(@location)
  end

  def create
    @location = @company.locations.build(location_params)
    @location.name_and_description_required = true if TransactableType.first.name == "Listing"
    build_approval_request_for_object(@location) unless @location.is_trusted?
    if @location.save
      flash[:success] = t('flash_messages.manage.locations.space_added', bookable_noun: platform_context.decorate.bookable_noun)
      event_tracker.created_a_location(@location , { via: 'dashboard' })
      event_tracker.updated_profile_information(current_user)
    else
      flash[:error] = view_context.array_to_unordered_list(@location.errors.full_messages)
    end
  end

  def edit
    build_approval_request_for_object(@location) unless @location.is_trusted?
  end

  def update
    @location.assign_attributes(location_params)
    build_approval_request_for_object(@location) unless @location.is_trusted?
    if @location.save
      flash[:success] = t('flash_messages.dashboard.locations.updated', bookable_noun: platform_context.decorate.bookable_noun)
    else
      flash[:error] = view_context.array_to_unordered_list(@location.errors.full_messages)
    end
  end

  def destroy
    if @location.destroy
      event_tracker.updated_profile_information(current_user)
      event_tracker.deleted_a_location(@location)
      @location.listings.each{|listing| event_tracker.deleted_a_listing(listing) }
      flash[:deleted] = t('flash_messages.manage.locations.space_deleted', name: @location.name)
    else
      flash[:error] = t('flash_messages.manage.locations.space_not_deleted', name: @location.name)
    end
  end

  private

  def redirect_if_draft_listing
    redirect_to new_space_wizard_url if current_user.has_draft_listings
  end

  def find_location
    begin
      @location = @company.locations.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      raise Location::NotFound
    end
  end

  def location_params
    params.require(:location).permit(secured_params.location)
  end

end
