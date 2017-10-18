require "thor"
require "regal_bird"

module RegalBird
  class CLI < Thor

    option :plan_dir, required: true, aliases: "-p",
      desc: "Directory where plans are stored"
    desc "start", "Starts all plans"
    def start
      load_plans(options[:plan_dir])
      RegalBird::Plan.plans.each do |plan|
        RegalBird.add_active_plan(
          RegalBird::ActivePlanBuilder.new(plan).build(channel)
        )
      end
    end

    option :plan_dir, required: true, aliases: "-p",
      desc: "Directory where plans are stored"
    desc "purge", "Removes all plans from rabbitmq"
    def purge
      load_plans(options[:plan_dir])
      RegalBird::Plan.plans.each do |plan|
        RegalBird::ActivePlanBuilder.new(plan)
          .build(channel)
          .delete
      end
    end

    option :plan_dir, required: true, aliases: "-p",
      desc: "Directory where plans are stored"
    desc "start <plan_name>", "Start the specific plan"
    def start_plan(plan_name)
      load_plans(options[:plan_dir])
      RegalBird.add_active_plan(
        ActivePlanBuilder.new(RegalBird::Plan.plan(plan_name))
          .build(channel)
      )
    end

    option :plan_dir, required: true, aliases: "-p",
      desc: "Directory where plans are stored"
    desc "purge <plan_name>", "Purge a specific plan from rabbitmq"
    def purge_plan(plan_name)
      load_plans(options[:plan_dir])
      ActivePlanBuilder.new(RegalBird::Plan.plan(plan_name))
        .build(channel)
        .delete
    end

    private

    def load_plans(dir)
      #Dir[dir].each {|path| require path }
      Pathname.new(dir).children.each do |f|
        require f.to_s
      end
    end

    def channel
      @channel ||= RegalBird::Messaging::Channel.new
    end

  end
end
