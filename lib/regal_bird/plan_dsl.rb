
# frozen_string_literal: true

module RegalBird

  class PlanDSL < SimpleDelegator

    def source(klass, interval)
      add_source(klass, interval)
    end

    def action(state, klass, num_workers)
      add_action(klass, state, num_workers)
    end

    def logger(new_logger)
      self.logger = new_logger
    end

  end

end
