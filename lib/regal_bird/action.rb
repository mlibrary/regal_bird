require "securerandom"

module RegalBird

  class Action

    attr_reader :event_log

    # @param event_log [EventLog]
    def initialize(event_log)
      @event_log = event_log
    end

    # @return [Event]
    def execute
      raise NotImplementedError
    end

    def success(state, data)
      {state: state, data: data}
    end

    def noop
      {state: event_log.state, data: {}}
    end

    def failure(message)
      {state: event_log.state, data: {error: log_error(message)}}
    end

    def log_error(message)
      id = SecureRandom.uuid
      RegalBird.config.logger.error(id) { message }
      return id
    end

    def wrap_execution
      start_time = Time.now.utc
      begin
        result = yield
        RegalBird::Event.new(state: result[:state], action: self.class.to_s,
          start_time: start_time, end_time: Time.now.utc,
          data: result[:data]
        )
      rescue StandardError => e
        RegalBird::Event.new(state: event_log.state, action: self.class.to_s,
          start_time: start_time, end_time: Time.now.utc,
          data: {error: log_error("#{e.message}\n#{e.backtrace}")}
        )
      end
    end


  end

end
