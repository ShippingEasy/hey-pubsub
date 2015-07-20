require "active_support/all"

module Hey::Pubsub::Adapters
  module AsnAdapter
    def self.subscribe!(event_name)
      if block_given?
        ActiveSupport::Notifications.subscribe(event_name) do |*args|
          asn_event = ActiveSupport::Notifications::Event.new(*args)

          payload = asn_event.payload.dup
          event = Hey::Pubsub::Event.new(uuid: payload.delete(:uuid),
                                         name: asn_event.name,
                                         started_at: asn_event.time,
                                         ended_at: asn_event.end,
                                         metadata: payload)

          yield(event.to_hash)
        end
      end
    end

    def self.publish!(event_name, payload = {})
      if block_given?
        ActiveSupport::Notifications.instrument(event_name, payload) do
          yield
        end
      else
        ActiveSupport::Notifications.instrument(event_name, payload)
      end
    end
  end
end
