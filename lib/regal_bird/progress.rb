module RegalBird

  # Tracks individual progress on a plan
  class Progress
    attr_accessor :id, :event_log, :plan

    # @param id [String] unique id
    # @param plan [Plan]
    def initialize(id, plan, event_log = EventLog.new)
      @id = id
      @plan = plan
      @event_log = event_log
    end

    def state
      event_log.state || :init
    end

    # Given the current state, run the next action as directed
    # by the plan.  Store the resulting event and update the state
    # accordingly.
    def run_next
      event = plan.action(state).new(event_log).execute
      event_log << event
    end

    def eql?(other)
      id == other.id &&
        plan == other.plan &&
        event_log == other.event_log
    end
    alias_method :==, :eql?
  end

end
