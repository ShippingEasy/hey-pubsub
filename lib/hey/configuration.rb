class Hey::Configuration
  attr_accessor :pubsub_adapter, :global_namespace, :delimiter

  def initialize
    @pubsub_adapter = Hey::Pubsub::Adapters::AsnAdapter
    @delimiter = ":"
  end
end
