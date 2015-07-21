require "active_support/all"

module Hey::Pubsub::Adapters
  module AsnAdapter
    def self.subscribe!(event_name)
      if block_given?
        ActiveSupport::Notifications.subscribe(event_name) do |*args|
          asn_event = ActiveSupport::Notifications::Event.new(*args)
          event = Hey::Pubsub::Event.new(name: asn_event.name,
                                         started_at: asn_event.time,
                                         ended_at: asn_event.end,
                                         metadata: asn_event.payload.dup)

          yield(event.to_h)
        end
      end
    end

    def self.publish!(event)
      if block_given?
        ActiveSupport::Notifications.instrument(event.name, event.metadata) do
          yield
        end
      else
        ActiveSupport::Notifications.instrument(event.name, event.metadata)
      end
    end
  end
end
