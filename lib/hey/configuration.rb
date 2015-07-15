class Hey::Configuration
  attr_accessor :pubsub_adapter

  def initialize
    @pubsub_adapter = Hey::PubSub::AsnAdapter
  end
end
