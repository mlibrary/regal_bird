require "regal_bird/configuration"

module RegalBird
  class << self
    def config
      @config ||= Configuration.new
    end

    attr_writer :config

    def add_active_plan(active_plan)
      active_plans[active_plan.plan.name] = active_plan
    end

    def emit(plan_name, event)
      active_plans[plan_name].emit(event)
    end

    private

    def active_plans
      @active_plans ||= {}
    end

  end
end
