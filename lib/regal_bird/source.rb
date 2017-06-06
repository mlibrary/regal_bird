require "regal_bird/event"

module RegalBird

  class Source
    # @return [Event]
    def execute
      raise NotImplementedError
    end

    def success(source_id, state, data)
      {
        state: state,
        data: data.merge({source_id: source_id})
      }
    end

    def wrap_execution
      start_time = Time.now.utc
      begin
        results = yield
        results.map do |result|
          RegalBird::Event.new(state: result[:state], action: self.class.to_s,
            start_time: start_time, end_time: Time.now.utc,
            data: result[:data]
          )
        end
      rescue StandardError => e
        RegalBird.config.logger.error "#{e.message}\n#{e.backtrace}"
        []
      end
    end
  end

end
