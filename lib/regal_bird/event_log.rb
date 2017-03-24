
module RegalBird

  class EventLog
    def initialize(events = [])
      @events = events
    end

    # Get the latest value for the passed key.
    def get(key)
      index = @events.index {|event| event.has_key?(key) }
      @events[index][key]
    end

    def <<(event)
      @events.push event
    end

    def where_action(action)
      @events.select do
        event.action == action
      end
    end
  end

end
