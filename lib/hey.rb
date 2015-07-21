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

  module Behavior
    def publish!(event_name, payload = {}, &block)
      event = Hey::Pubsub::Event.new(name: event_name, metadata: payload)
      pubsub_adapter.publish!(event, &block)
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
require "hey/pubsub/event"
require "hey/pubsub/adapters/asn_adapter"
