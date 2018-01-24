require "config"
require "pathname"

# Establish a project root
module RegalBird
  def self.root
    Pathname.new(__FILE__).dirname.parent.parent
  end
end


# Load config variables
env = ENV["REGAL_BIRD_ENV"] || ENV["RAILS_ENV"] || "development"
Config.load_and_set_settings(Config.setting_files(RegalBird.root/"config", env))

# Create objects and services
Settings.plan_dir = Pathname.new(Settings.plan_dir)
Settings.logger = Logger.new(Settings.log_file)

module RegalBird
  class << self
    def add_active_plan(active_plan)
      active_plans[active_plan.plan.name] = active_plan
    end

    def emit(plan_name, event)
      active_plans[plan_name].emit(event)
    end

    def valid?
      !Settings.plan_dir.nil?
    end

    private

    def active_plans
      @active_plans ||= {}
    end

  end
end

