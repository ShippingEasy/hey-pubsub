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
    @sanitizable_values ||= Hey::ThreadCargo.sanitizable_values.collect { |value| [value, ""] }.to_h
  end

  def sanitize!(value)
    Hey::ThreadCargo.sanitizable_values.each { |substr| value.to_s.gsub!(substr, "") }
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
