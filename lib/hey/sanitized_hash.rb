class Hey::SanitizedHash
  def initialize(hash = {})
    @hash = deep_dup(hash)
  end

  def to_h
    traverse(hash) { |k, v| [k, sanitize!(v)] }
  end

  private

  attr_reader :hash

  def sanitizable_values
    @sanitizable_values ||= Hey::ThreadCargo.contexts.map do |context|
      Array[context[Hey::SANITIZE_KEY]]
    end.flatten.compact
  end

  def sanitize!(value)
    sanitizable_values.each { |substr| value.to_s.gsub!(substr, "") }
  end

  def traverse(h, &block)
    h.each_pair do |k, v|
      if v.is_a?(Hash)
        traverse(v, &block)
      else
        yield(k, v)
      end
    end
  end

  def deep_dup(object)
    Marshal.load(Marshal.dump(object))
  end
end
