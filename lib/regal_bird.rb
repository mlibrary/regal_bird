# frozen_string_literal: true

require "regal_bird/configuration"
require "regal_bird/version"
require "regal_bird/action"
require "regal_bird/active_plan"
require "regal_bird/active_plan_builder"
require "regal_bird/event"
require "regal_bird/plan"
require "regal_bird/source"
require "regal_bird/messaging"

module RegalBird
  class << self
    def config
      @config ||= Configuration.new
    end

    attr_writer :config

    def add_active_plan(active_plan)
      @active_plans[active_plan.plan.name] = active_plan
    end

    def emit(plan_name, event)
      @active_plans[plan_name].emit(event)
    end

    private

    def active_plans
      @active_plans ||= {}
    end

  end
end
