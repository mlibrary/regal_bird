
module RegalBird

  # Represents a series or tree of instructions.
  class Plan
    attr_reader :name

    # @param name [String,Symbol]
    # @param mappings [Hash<Symbol,Action.class>]
    def initialize(name, mappings)
      @name = name
      @map = mappings
    end

    def initial_state
      :init
    end

    def mappings
      @map.to_a
    end

    # @param state [Symbol]
    # @return [Action.class]
    def [](state)
      @map[state.to_sym]
    end
    alias_method :action, :[]

    def eql?(other)
      name == other.name &&
        mappings == other.mappings
    end
    alias_method :==, :eql?
  end

end

