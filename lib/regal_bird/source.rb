# frozen_string_literal: true

require "regal_bird/init"
require "regal_bird/source_result"

module RegalBird

  # Run periodically, a source emits events from external
  # data stores.
  class Source

    def initialize(result_builder = SourceResult)
      @result_builder = result_builder
    end

    # @param result [SourceResult]
    # @return [Array<Event>]
    def execute(result)
      raise NotImplementedError
    end

    def safe_execute
      result = result_builder.for(self)
      begin
        execute(result)
      rescue StandardError => e
        Settings.logger.error "#{e.message}\n#{e.backtrace}"
        []
      end
    end

    private

    attr_reader :result_builder
  end

end
