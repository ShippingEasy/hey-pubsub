class Hey::Configuration
  attr_accessor :pubsub_adapter, :namespace

  def initialize
    @pubsub_adapter = Hey::Pubsub::Adapters::AsnAdapter
    @namespace = "pubsub"
  end
end
