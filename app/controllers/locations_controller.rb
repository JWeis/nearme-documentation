class LocationsController < ApplicationController
  expose :location

  def create
    location.creator ||= current_user
    if location.save
      flash[:success] = "Successfully created location"
      redirect_to new_location_listing_path(location)
    else
      flash.new[:error] = "There was a problem saving your location. Please try again"
      render :new
    end
  end
end
