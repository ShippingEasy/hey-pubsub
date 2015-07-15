require "hey/version"

module Hey
  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Hey::Configuration.new
  end

  def self.pubsub_adapter
    configuration.pubsub_adapter
  end

  def self.publish!(event_name, payload = {})
    payload = Hey::Pubsub::Payload.new(payload)
    pubsub_adapter.broadcast!(event_name, payload.to_h)
  end

  def self.subscribe!(event_name)
    pubsub_adapter.subscribe!(event_name)
  end

  def self.current_actor
    Hey::ThreadCargo.current_actor
  end

  def self.set_current_actor(name:, id: nil, type: nil)
    Hey::ThreadCargo.set_current_actor(name: name, id: id, type: type)
  end
end

require "hey/pubsub"
require "hey/thread_cargo"
require "hey/pubsub/payload"
