class Hey::Pubsub::Payload
  def initialize(values = {})
    @values = values
    merge_values!
  end

  def to_h
    Hey::SanitizedHash.new(values).to_h
  end

  private

  attr_accessor :values

  def merge_values!
    Hey::ThreadCargo.uuid # initialize if it has never been set
    self.values = Hey::ThreadCargo.to_hash.merge(values)
  end
end
