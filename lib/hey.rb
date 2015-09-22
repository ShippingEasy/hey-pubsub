require "hey/version"
require "ostruct"
require "securerandom"

module Hey
  SANITIZE_KEY = :sanitize

  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Hey::Configuration.new
  end

  def self.pubsub_adapter
    configuration.pubsub_adapter
  end

  def self.global_namespace
    configuration.global_namespace
  end

  module Behavior
    def publish!(event_name, payload = {}, &block)
      event_name = Hey::EventName.new(event_name).to_s
      event = Hey::Pubsub::Event.new(name: event_name, metadata: payload)
      pubsub_adapter.publish!(event, &block)
    end

    def subscribe!(event_name, &block)
      pubsub_adapter.subscribe!(event_name, &block)
    end

    def context(**hash)
      _context = Context.new(hash)
      ThreadCargo.add_context(_context)
      yield
    ensure
      ThreadCargo.remove_context(_context)
      ThreadCargo.purge! if ThreadCargo.contexts.empty?
    end
  end

  extend Hey::Behavior
end

require "hey/configuration"
require "hey/context"
require "hey/event_name"
require "hey/thread_cargo"
require "hey/sanitized_hash"
require "hey/pubsub"
require "hey/pubsub/event"
require "hey/pubsub/adapters/asn_adapter"
