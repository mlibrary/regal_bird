
module RegalBird

  # A record of execution.
  class Event

    attr_reader :action, :state, :data, :start_time, :end_time

    # @param action [Symbol] the name of the #Action
    # @param state [Symbol] the result state
    # @param data [Hash] short hash of data from the action that
    #   generated this event
    # @param start_time [Time]
    # @param end_time [Time]
    def initialize(action:, state:, data:, start_time:, end_time:)
      @action = action.to_sym
      @state = state.to_sym
      @data = data
      @start_time = start_time.utc
      @end_time = end_time.utc
    end

    def eql?(other)
      action == other.action &&
        state == other.state &&
        start_time == other.start_time &&
        end_time == other.end_time &&
        data == other.data
    end
    alias_method :==, :eql?
  end

end
