require "event_log"

module RegalBird

  # Tracks individual progress on a plan
  class Progress
    attr_reader :id, :state

    # @param id [String] unique id
    # @param plan [Plan]
    def initialize(id, plan)
      @id = id
      @plan = plan
      @state = plan.initial_state
      @event_log = EventLog.new
    end

    # Given the current state, run the next action as directed
    # by the plan.  Store the resulting event and update the state
    # accordingly.
    def run_next
      event = plan.action(state).new(event_log).execute
      self.state = event.state.to_sym
      event_log << event
    end

    def self.define(&block)
      self.new(nil, nil).instance_eval(&block)
    end

    protected
    attr_writer :id, :plan, :state, :event_log

    private
    attr_reader :plan, :event_log

  end

end
