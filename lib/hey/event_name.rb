class Hey::EventName
  def initialize(name)
    @name = name
  end

  def to_s
    [Hey.global_namespace, namespaces, name].flatten.compact.join(Hey.configuration.delimiter)
  end

  private

  attr_reader :name

  def namespaces
    @namespaces ||= Hey::ThreadCargo.contexts.map do |context|
      Array[context[:namespace]]
    end.flatten.compact
  end
end
