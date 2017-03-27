
module RegalBird

  # Represents a series or tree of instructions.
  class Plan
    attr_reader :name

    def initialize(name)
      @name = name
      @map = {}
    end

    # @param state [Symbol]
    # @return [Action.class]
    def [](state)
      @map[state.to_sym]
    end
    alias_method :action, :[]

    def self.define(name, &block)
      instance = self.new(name)
      instance.instance_eval(&block)
      return instance
    end

    def eql?(other)
      name == other.name &&
        @map == other.instance_variable_get(:@map)
    end
    alias_method :==, :eql?

    protected

    # @param state [Symbol]
    # @param action_factory [Action.class]
    def add(state, action_factory)
      @map[state.to_sym] = action_factory
    end
  end

end

