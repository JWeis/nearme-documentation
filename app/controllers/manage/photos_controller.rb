class Manage::PhotosController < Manage::BaseController

  before_filter :get_proper_hash, :only => [:create]

  def create
    @photo = Photo.new
    @photo.listing = @listing
    @photo.image_original_url = @image_url
    @photo.creator_id = current_user.id
    if @photo.save
      render :text => {
        :id => @photo.id, 
        :listing_id => @photo.listing_id,
        :thumbnail_dimensions => @photo.image.thumbnail_dimensions[:medium],
        :url => @photo.image_url(:medium),
        :destroy_url => destroy_space_wizard_photo_path(@photo),
        :resize_url =>  edit_manage_photo_path(@photo)
      }.to_json, 
      :content_type => 'text/plain' 
    else
      render :text => [{:error => @photo.errors.full_messages}], :content_type => 'text/plain', :status => 422
    end
  end

  def edit
    @photo = current_user.photos.find(params[:id])
    if request.xhr?
      render partial: 'resize_form', :locals => { :form_url => manage_photo_path(@photo), :object => @photo.image, :object_url => @photo.image_url(:original) }
    end
  end

  def update
    @photo = current_user.photos.find(params[:id])
    @photo.image_transformation_data = { :crop => params[:crop], :rotate => params[:rotate] }
    if @photo.save
      render partial: 'manage/photos/resize_succeeded'
    else
      render partial: 'resize_form', :locals => { :form_url => manage_photo_path(@photo), :object => @photo.image, :object_url => @photo.image_url(:original) }
    end
  end

  def destroy
    @photo = current_user.photos.find(params[:id])
    if @photo.destroy
      render :text => { success: true, id: @photo.id }, :content_type => 'text/plain'
    else
      render :text => { :errors => @photo.errors.full_messages }, :status => 422, :content_type => 'text/plain'
    end
  end


  private
  def get_proper_hash
    # we came from list your space flow
    if params[:user]
      photo_params = params[:user][:companies_attributes]["0"][:locations_attributes]["0"][:listings_attributes]["0"]
      @listing = Listing.find(photo_params[:id]) if photo_params[:id]
    # we came from dashboard
    elsif params[:listing]
      photo_params = params[:listing]
      @listing = current_user.listings.find(params[:listing][:id]) if params[:listing][:id].present?
    end
    @image_url = photo_params[:photos_attributes]["0"][:image]
  end

end
