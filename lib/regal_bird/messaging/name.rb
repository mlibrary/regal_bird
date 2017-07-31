module RegalBird

  class Name
    class << self
      def work_exchange(plan)
        "#{plan.name}-work"
      end

      def retry_exchange(plan)
        "#{plan.name}-retry"
      end

      def work_queue(step_class)
        "action-#{step_class.to_s.downcase.gsub("::", "_")}-work"
      end

      def polling_retry_queue(step_class)
        "action-#{step_class.to_s.downcase.gsub("::", "_")}-retry"
      end

      def invoked_retry_queue(ttl)
        "action-retry-#{ttl}"
      end

      def logging_queue
        "logger-work"
      end
    end
  end

end