
require "regal_bird/messaging"

module RegalBird

  # Given a plan, create an active plan
  class ActivePlanBuilder

    def initialize(plan)
      @plan = plan
    end

    def build(channel)
      arrangements.each {|arrangement| exchange_builder.add(arrangement) }
      exchange = exchange_builder.build(channel)
      ActivePlan.new(
        plan,
        exchange,
        Messaging::Invoked::Publisher.new(exchange.work, exchange.retry)
      )
    end

    def arrangements
      plan.sources
        .map {|decl| [decl.klass, decl.interval] }
        .map {|source_class, interval|
          Messaging::Polling::ArrangementBuilder.new(source_class, interval)
        }
        .concat(
        plan.actions
          .map {|decl| [decl.klass, decl.state, decl.num_workers] }
          .map {|action_class, state, num_workers|
            Messaging::Invoked::ArrangementBuilder.new(action_class, state, num_workers)
          }
        )
        .concat(
          Messaging::Logging::ArrangementBuilder.new(plan.logger)
        )
    end

    def exchange_builder
      @exchange_builder ||= ExchangeBuilder.new(plan.name)
    end



  end

end