class Billing::Gateway::Processor::Base
  class InvalidStateError < StandardError; end

  def setup_api_on_initialize
  end

  protected

  def self.instance_client(client, instance)
    client.instance_clients.first.presence || client.instance_clients.create
  end

  def instance_client
    @instance_client ||= self.class.instance_client(@client, @instance)
  end

end
