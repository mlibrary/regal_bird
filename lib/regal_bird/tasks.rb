# frozen_string_literal: true

require "rake"

namespace :regal_bird do
  desc "Configure Regal Bird. See README"
  task :setup

  task prepare: [:setup] do
    require "regal_bird"
  end

  task channel: [:prepare] do
    @channel ||= RegalBird::Messaging::Channel.new
  end

  task require_plans: [:prepare] do
    require 'pry'; binding.pry
    Dir[RegalBird.config.plan_dir + "**" + "*.rb"].each do |path|
      require path
    end
  end

  desc "Start all plans"
  task start: [:require_plans] do
    RegalBird.plans.each do |plan|
      Rake::Task["plan:start"].execute(plan.name)
    end
  end

  desc "Purge all plans"
  task purge: [:require_plans] do
    RegalBird.plans.each do |plan|
      Rake::Task["plan:purge"].execute(plan.name)
    end
  end


  namespace :plan do
    desc "Start a specific plan by name"
    task :start, [:name] => [:require_plans, :channel] do |_, name|
      RegalBird.add_steward(
        RegalBird::Messaging::Steward.new(
          @channel,
          RegalBird::Plan.plan(name)
        )
      )
    end

    desc "Purge all remnants of a plan by name."
    task :purge, [:name] => [:channel] do |_, name|
      RegalBird::Messaging::Steward.new(
        @channel,
        RegalBird::Plan.plan(name)
      ).delete
    end

  end

end
