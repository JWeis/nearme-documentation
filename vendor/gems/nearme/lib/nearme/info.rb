require 'pp'

module NearMe
  class Info

    def initialize(options = {})
    end

    def opsworks_client
      @opsworks_client ||= Aws::OpsWorks::Client.new region: 'us-east-1'
    end

    def stacks
      @stacks ||= opsworks_client.describe_stacks.data.stacks
    end

    def instances(stack_id)
      opsworks_client
        .describe_instances(stack_id: stack_id)
        .data
        .instances
        .map { |instance| instance.to_h.slice(:hostname, :public_dns, :public_ip) }
    end

    def latest_deployment(stack_id)
      deployment = opsworks_client
                   .describe_deployments(stack_id: stack_id)
                   .data
                   .deployments
                   .first

      return 'no deploys yet' unless deployment

      deployment.to_h.slice(:completed_at, :duration, :iam_user_arn, :command, :status, :custom_json)
    end

    def status
      info = {}
      quick_view = []
      stacks.each do |stack|
        info[stack.name]             = {}
        info[stack.name][:deploy]    = latest_deployment(stack.stack_id)
        info[stack.name][:instances] = instances(stack.stack_id)

        results = opsworks_client.describe_instances(stack_id: stack.stack_id).data.instances
        results.each do |r|
          if stack.name == 'nm-production'
            quick_view << "alias ssh_#{stack.name.sub(/nm-qa-\d/, '').sub('nm-', '')}#{r[:hostname].gsub('rails-qa-1', 'qa').gsub('rails-qa-', 'qa').gsub('rails-app1', '').gsub('rails-app-1', '').gsub('rails-app-', '').gsub('rails-app', '')}='ssh -A -t #{ENV['AWS_USER']}@52.9.77.133 ssh -A -t #{r[:private_ip]}'".gsub('productionutility1', 'utility') unless r[:public_ip].nil? || r[:public_ip].empty?
          else
            quick_view << "alias ssh_#{stack.name.sub(/nm-qa-\d/, '').sub('nm-', '')}#{r[:hostname].gsub('rails-qa-1', 'qa').gsub('rails-qa-', 'qa').gsub('rails-app1', '').gsub('rails-app-1', '').gsub('rails-app-', '').gsub('rails-app', '')}='ssh #{ENV['AWS_USER']}@#{r[:public_ip]}'".gsub('productionutility1', 'utility') unless r[:public_ip].nil? || r[:public_ip].empty?
          end
        end
      end
      pp info
      puts quick_view.join("\n")
    end
  end
end