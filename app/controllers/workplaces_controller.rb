class WorkplacesController < ApplicationController
  before_filter :require_user, :except => [:show]
  before_filter :find_workplace, :only => [:edit, :update]

  def new
    @workplace = current_user.workplaces.build(:maximum_desks => 1, :confirm_bookings => false)
  end

  def create
    @workplace = current_user.workplaces.build(params[:workplace])
    if @workplace.save
      redirect_to @workplace
    else
      render :new
    end
  end

  def show
    @workplace = Workplace.find(params[:id])
  end

  def edit

  end

  def update
    if @workplace.update_attributes(params[:workplace])
      redirect_to @workplace
    else
      render :edit
    end
  end

  protected

  def find_workplace
    @workplace = current_user.workplaces.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to :root, :alert => "Could not find workspace"
  end
end
