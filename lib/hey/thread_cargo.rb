class Hey::ThreadCargo
  def self.init!
    Thread.current[:hey] = {} if Thread.current[:hey].nil?
    Thread.current[:hey][:uuid] = SecureRandom.uuid if Thread.current[:hey][:uuid].nil?
  end

  def self.init_contexts!
    init!
    Thread.current[:hey][:contexts] = [] if Thread.current[:hey][:contexts].nil?
  end

  def self.uuid
    init!
    Thread.current[:hey][:uuid]
  end

  # Sets a context on the current thread
  def self.add_context(context)
    self.init_contexts!
    Thread.current[:hey][:contexts] << context
  end

  # Returns a context from the current thread
  def self.remove_context(context)
    self.init_contexts!
    Thread.current[:hey][:contexts].delete(context)
  end

  # Removes all namespaced values from the current thread.
  def self.purge!
    Thread.current[:hey] = nil
  end

  def self.contexts
    self.init_contexts!
    Thread.current[:hey][:contexts]
  end
end
