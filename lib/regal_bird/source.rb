require "regal_bird/event"

module RegalBird

  # Run periodically, a source emits events from external
  # data stores.
  class Source

    # @return [Array<Event>]
    def execute
      raise NotImplementedError
    end

    def success(item_id, state, data)
      {
        item_id: item_id,
        state: state,
        data: data
      }
    end

    def wrap_execution
      start_time = Time.now.utc
      begin
        results = yield
        results.map do |result|
          RegalBird::Event.new(item_id: result[:item_id], state: result[:state],
            emitter: self.class.to_s, start_time: start_time, end_time: Time.now.utc,
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
