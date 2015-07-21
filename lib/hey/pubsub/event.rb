class Hey::Pubsub::Event
  attr_writer :name, :metadata, :started_at, :ended_at

  def initialize(name:, started_at: nil, ended_at: nil, metadata: {})
    @name = name
    @started_at = started_at
    @ended_at = ended_at
    @metadata = metadata
  end

  def to_h
    hash = { uuid: Hey::ThreadCargo.uuid, name: name, metadata: metadata }
    hash[:started_at] = started_at unless started_at.nil?
    hash[:ended_at] = ended_at unless ended_at.nil?
    hash[:duration] = duration unless duration.nil?
    hash
  end

  def started_at
    return if @started_at.nil?
    @started_at.strftime("%Y-%m-%dT%H:%M:%S.%L")
  end

  def ended_at
    return if @ended_at.nil?
    @ended_at.strftime("%Y-%m-%dT%H:%M:%S.%L")
  end

  def metadata
    merged_data = Hey::ThreadCargo.to_hash.merge(@metadata)
    Hey::SanitizedHash.new(merged_data).to_h
  end

  def name
    return @name if Hey.configuration.namespace.nil?
    "#{Hey.configuration.namespace}.#{@name}"
  end

  def duration
    return if @ended_at.nil? || @started_at.nil?
    1000.0 * (@ended_at - @started_at)
  end
end
