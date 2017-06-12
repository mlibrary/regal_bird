
module RegalBird

  # Represents a series or tree of instructions.
  class Plan
    ActionDeclaration = Struct.new(:klass, :state, :num_workers)
    SourceDeclaration = Struct.new(:klass, :interval)

    attr_reader :name, :actions, :sources

    # @param name [String,Symbol]
    def initialize(name)
      @name = name
      @actions = []
      @sources = []
    end

    def add_source_declaration(declaration)
      @sources << declaration
      self
    end

    def add_source(klass, interval)
      add_source_declaration SourceDeclaration.new(klass, interval)
      self
    end

    def add_action_declaration(declaration)
      @actions << declaration
      self
    end

    def add_action(klass, state, num_workers)
      add_action_declaration ActionDeclaration.new(klass, state, num_workers)
      self
    end

    def eql?(other)
      name == other.name &&
        actions == other.actions &&
        sources == other.sources
    end
    alias_method :==, :eql?

  end



end

