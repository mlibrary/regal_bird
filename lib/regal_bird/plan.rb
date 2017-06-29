# frozen_string_literal: true

require "regal_bird/plan_dsl"
require "regal_bird/action"

module RegalBird

  # Represents a series or tree of instructions.
  class Plan
    ActionDeclaration = Struct.new(:klass, :state, :num_workers)
    SourceDeclaration = Struct.new(:klass, :interval)

    attr_reader :name, :actions, :sources
    attr_accessor :logger

    # @param name [String,Symbol]
    def initialize(name)
      @name = name
      @actions = []
      @sources = []
      @logger = nil
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
      unless declaration.klass == Action::Clean
        @actions << declaration
      end
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

    def self.define(name, &block)
      plan = new(name)
      dsl = PlanDSL.new(plan)
      dsl.instance_eval(&block)
      plan
    end

  end

end
