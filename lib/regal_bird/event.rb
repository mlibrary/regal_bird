
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
      @action = action
      @state = state
      @data = data
      @start_time = start_time
      @end_time = end_time
    end
  end

end
