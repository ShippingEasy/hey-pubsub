class Hey::ThreadCargo

  # Sets a namespaced value on the current thread
  def self.set(name, value)
    Thread.current[:hey] = {} if Thread.current[:hey].nil?
    Thread.current[:hey][name] = value
  end

  # Returns a namespaced value from the current thread
  def self.get(name)
    return nil if Thread.current[:hey].nil?
    Thread.current[:hey][name]
  end

  # Returns the actor from the current thread
  def self.current_actor
    get(:current_actor)
  end

  # Sets the actor to the current thread
  def self.set_current_actor(name:, type: nil, id: nil)
    set(:current_actor, { name: name, type: type, id: id})
  end

  # Adds the supplied values to the sanitized values array. It removes nils and duplicate values from the array.
  def self.sanitize!(values)
    set(:sanitizable_values, []) if get(:sanitizable_values).nil?
    values = Array(values)
    set(:sanitizable_values, get(:sanitizable_values).concat(values).flatten.compact.uniq)
  end

  # Removes all namespaced values from the current thread.
  def self.purge!
    set(:current_actor, nil)
    set(:sanitizable_values, nil)
  end

  def self.sanitizable_values
    Array(get(:sanitizable_values))
  end
end
