
module RegalBird

  class Event

    attr_reader :item_id, :action, :state, :data, :start_time, :end_time

    # @param item_id [String]
    # @param action [String] the name of the #Action
    # @param state [Symbol] the result state
    # @param data [Hash] short hash of data from the action that
    #   generated this event
    # @param start_time [Time]
    # @param end_time [Time]
    def initialize(item_id:, action:, state:, data:, start_time:, end_time:)
      @item_id = item_id.to_s
      @action = action.to_s
      @state = state.to_sym
      @data = data
      @start_time = start_time.utc
      @end_time = end_time.utc
    end

    def eql?(other)
      action == other.action &&
        item_id == other.item_id &&
        state == other.state &&
        start_time == other.start_time &&
        end_time == other.end_time &&
        data == other.data
    end
    alias_method :==, :eql?
  end

end
