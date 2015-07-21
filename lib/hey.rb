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
      event_name = "#{Hey.configuration.namespace}.#{event_name}" unless Hey.configuration.namespace.nil?
      event = Hey::Pubsub::Event.new(name: event_name, metadata: payload)
      pubsub_adapter.publish!(event, &block)
    end

    def subscribe!(event_name, &block)
      pubsub_adapter.subscribe!(event_name, &block)
    end

    def set(name, value)
      Hey::ThreadCargo.set(name, value)
    end

    def sanitize!(*values)
      Hey::ThreadCargo.sanitize!(values)
    end
  end

  extend Hey::Behavior
end

require "securerandom"
require "hey/configuration"
require "hey/thread_cargo"
require "hey/sanitized_hash"
require "hey/pubsub"
require "hey/pubsub/event"
require "hey/pubsub/adapters/asn_adapter"
