
module RegalBird

  class Action

    attr_reader :event_log

    # @param event_log [EventLog]
    def initialize(event_log); end

    # @return [Event]
    def execute; end

  end

end
