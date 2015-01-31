class Utils::DefaultAlertsCreator::WorkflowCreator

  def initialize
    @steps = {}
  end

  def create_all!
    raise NotImplemplementedError
  end

  protected

  def create_alert!(hash)
    alert = step(hash[:associated_class].to_s).workflow_alerts.find_or_initialize_by(template_path: hash[:path], alert_type: hash[:alert_type], recipient_type: hash[:recipient_type])
    alert.delay = hash.fetch(:delay, 0)
    alert.name ||= hash[:name].humanize
    alert.subject = hash[:subject] if alert.new_record?
    alert.layout_path = 'layouts/mailer' if alert.new_record?
    alert.custom_options = hash.fetch(:custom_options, {})
    alert.from = hash.fetch(:from, PlatformContext.current.theme.contact_email)
    alert.reply_to = hash.fetch(:no_reply, PlatformContext.current.theme.contact_email)
    alert.save!
    alert
  end

  def workflow
    if !@workflow
      @workflow ||= Workflow.find_or_initialize_by(workflow_type: workflow_type)
      @workflow.name = workflow_type.humanize
      @workflow.save!
    end
    @workflow
  end

  def step(associated_class)
    if !@steps[associated_class]
      step = workflow.workflow_steps.find_or_initialize_by(associated_class: associated_class)
      step.associated_class = associated_class
      step.name ||= associated_class.demodulize.gsub(/(?<=[a-z])(?=[A-Z])/, ' ')
      step.save!
      @steps[associated_class] = step
    end
    @steps[associated_class]
  end

end

