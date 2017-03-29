require "regal_bird/event_log"

module RegalBird

  # Tracks individual progress on a plan
  class Progress
    attr_accessor :id, :event_log, :plan

    # @param id [String] unique id
    # @param plan [Plan]
    def initialize(id, plan)
      @id = id
      @plan = plan
      @event_log = EventLog.new
    end

    def state
      event_log.state || :init
    end

    # Given the current state, run the next action as directed
    # by the plan.  Store the resulting event and update the state
    # accordingly.
    def run_next
      event = plan.action(state).new(event_log).execute
      self.state = event.state.to_sym
      event_log << event
    end
  end

end
