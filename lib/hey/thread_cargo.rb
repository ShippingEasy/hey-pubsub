class Hey::ThreadCargo
  SANITIZABLE_VALUES_KEY = :sanitizable_values

  # Sets a namespaced value on the current thread
  def self.set(name, value)
    Thread.current[:hey] = {} if Thread.current[:hey].nil?
    Thread.current[:hey][name] = value
    value
  end

  # Returns a namespaced value from the current thread
  def self.get(name)
    return nil if Thread.current[:hey].nil?
    Thread.current[:hey][name]
  end

  def self.uuid
    return set(:uuid, SecureRandom.uuid) if get(:uuid).nil?
    get(:uuid)
  end

  # Adds the supplied values to the sanitized values array. It removes nils and duplicate values from the array.
  def self.sanitize!(*values)
    set(SANITIZABLE_VALUES_KEY, []) if get(SANITIZABLE_VALUES_KEY).nil?
    values = Array(values)
    set(SANITIZABLE_VALUES_KEY, get(SANITIZABLE_VALUES_KEY).concat(values).flatten.compact.uniq)
  end

  # Removes all namespaced values from the current thread.
  def self.purge!
    Thread.current[:hey] = nil
  end

  def self.sanitizable_values
    Array(get(SANITIZABLE_VALUES_KEY))
  end

  def self.to_h
    Thread.current[:hey] = {} if Thread.current[:hey].nil?
    Thread.current[:hey].clone
  end
end
