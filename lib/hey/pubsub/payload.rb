class Hey::Pubsub::Payload
  def initialize(values = {})
    @values = values
    merge_values!
    sanitize_values!
  end

  def to_hash
    values
  end

  alias_method :to_h, :to_hash

  private

  attr_accessor :values

  def merge_values!
    Hey::ThreadCargo.uuid # initialize if it has never been set
    self.values = Hey::ThreadCargo.to_hash.merge(values)
  end

  def sanitize_values!
    traverse_hash(values) { |k, v| [k, sanitize_value!(v)] }
  end

  def sanitize_value!(value)
    Hey::ThreadCargo.sanitizable_values.each do |sanitizable_value|
      value = value.gsub(sanitizable_value, "")
    end
    value
  end

  def traverse_hash(h, &block)
    h.each_pair do |k, v|
      if v.is_a?(Hash)
        traverse_hash(v, &block)
      else
        yield(k, v)
      end
    end
  end
end
