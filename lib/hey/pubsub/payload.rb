class Hey::Pubsub::Payload
  def initialize(values = {})
    @values = values
    set_current_actor!
    sanitize!
  end

  def to_hash
    values
  end

  alias_method :to_h, :to_hash

  private

  def set_current_actor!
    values[:current_actor] = Hey::ThreadCargo.current_actor
  end

  def sanitize!
    traverse_hash(values) { |k, v| [k, sanitize_value!(v)] }
  end

  def sanitize_value!(value)
    Hey::ThreadCargo.sanitizable_values.each do |sanitizable_value|
      value.gsub!(sanitizable_value, "")
    end
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

  attr_reader :values
end
