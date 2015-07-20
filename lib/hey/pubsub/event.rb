class Hey::Pubsub::Event
  def initialize(name:, uuid:, started_at:, ended_at:, metadata: {})
    @name = name
    @uuid = uuid
    @started_at = started_at
    @ended_at = ended_at
    @metadata = metadata
  end

  def to_hash
    {
      uuid: uuid,
      name: name,
      started_at: started_at,
      ended_at: ended_at,
      duration: duration,
      metadata: metadata
    }
  end

  private

  attr_reader :name, :uuid, :metadata, :started_at, :ended_at

  def duration
    @duration ||= 1000.0 * (ended_at - started_at)
  end
end
