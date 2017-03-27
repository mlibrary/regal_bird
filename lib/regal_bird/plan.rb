
module RegalBird

  # Represents a series or tree of instructions.
  class Plan
    def initialize
      @map = {}
    end

    # @param state [Symbol]
    # @return [Action.class]
    def [](state)
      @map[state.to_sym]
    end
    alias_method :action, :[]

    def self.define(&block)
      instance = self.new
      instance.instance_eval(&block)
      return instance
    end

    protected

    # @param state [Symbol]
    # @param action_factory [Action.class]
    def add(state, action_factory)
      @map[state.to_sym] = action_factory
    end
  end

end

