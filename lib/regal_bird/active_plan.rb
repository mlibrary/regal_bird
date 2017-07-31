module RegalBird

  class ActivePlan

    attr_reader :plan

    def initialize(plan, exchange, user_event_publisher)
      @plan = plan
      @exchange = exchange
      @user_event_publisher = user_event_publisher
    end

    def emit(event)
      user_event_publisher.success(event)
    end

    def delete
      exchange.delete
    end

    private
    attr_reader :exchange, :user_event_publisher
  end

end