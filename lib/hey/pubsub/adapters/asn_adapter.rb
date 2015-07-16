module Hey::Pubsub::Adapters
  module AsnAdapter
    def self.subscribe!(event_name)
      if block_given?
        ActiveSupport::Notifications.subscribe(event_name) do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          yield(event.payload)
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
