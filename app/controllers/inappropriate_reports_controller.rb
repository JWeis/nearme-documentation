class InappropriateReportsController < ApplicationController

  before_filter :find_reportable
  before_filter :redirect_unless_authenticated

  def create
    @report = InappropriateReport.create!(reportable: @reportable, user: current_user, ip_address: request.remote_ip, reason: params[:inappropriate_report][:reason])

    flash[:notice] = t("inappropriate_reports.report_has_been_sent")

    WorkflowStepJob.perform(WorkflowStep::ListingWorkflow::InappropriateReported, @report.id)

    redirect_to @reportable.decorate.show_path
  end

  def show
    render partial: 'shared/components/flag_as_inappropriate'
  end

  private

  def redirect_unless_authenticated
    unless current_user.present?
      render text: "<h4>#{I18n.t('inappropriate_reports.redirecting_to_log_in_page')}</h4><script>document.location = '#{ActionController::Base.helpers.escape_javascript(new_user_session_path(return_to: redirection_path(@reportable)))}'</script>"
    end
  end

  def redirection_path(object)
    case object
    when Transactable
      object.decorate.show_path
    when Location
      object.listings.searchable.first.try(:decorate).try(:show_path) || root_path
    else
      polymorphic_path(object)
    end
  end

  def find_reportable
    # For now we allow just Transactables
    return if !['Transactable', 'User'].include?(params[:reportable_type])
    @reportable = params[:reportable_type].constantize.find(params[:id])
    nil
  end
end
