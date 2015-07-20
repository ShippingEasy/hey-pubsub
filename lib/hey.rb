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

  def self.publish!(event_name, payload = {}, &block)
    payload = Hey::Pubsub::Payload.new(payload)
    pubsub_adapter.publish!(event_name, payload.to_h, &block)
  end

  def self.subscribe!(event_name, &block)
    pubsub_adapter.subscribe!(event_name, &block)
  end

  def self.set(name, value)
    Hey::ThreadCargo.set(name, value)
  end

  def self.set_current_actor!(name:, id: nil, type: nil)
    Hey::ThreadCargo.set_current_actor(name: name, id: id, type: type)
  end

  def self.sanitize!(*values)
    Hey::ThreadCargo.sanitize!(values)
  end
end

require "securerandom"
require "hey/configuration"
require "hey/thread_cargo"
require "hey/sanitized_hash"
require "hey/pubsub"
require "hey/pubsub/payload"
require "hey/pubsub/adapters/asn_adapter"
