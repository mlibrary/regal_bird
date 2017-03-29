
module RegalBird

  class EventLog
    def initialize(events = [])
      @events = events
    end

    # Get the latest value for the passed key.
    def get(key)
      index = events.rindex {|event| event.data.has_key?(key) }
      if index
        events[index].data[key]
      else
        nil
      end
    end

    def <<(event)
      events.push event
      self
    end

    def where_action(action)
      events.select do |event|
        event.action == action
      end
    end

    def state
      events.last&.state || :init
    end

    def eql?(other)
      events == other.events
    end
    alias_method :==, :eql?

    protected
    attr_reader :events

  end

end
