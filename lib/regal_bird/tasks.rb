namespace :regal_bird do

  desc "Configure Regal Bird. See README"
  task :setup

  task :prepare => [:setup] do
    require "regal_bird"
  end

  task :channel => [:prepare] do
    @channel ||= RegalBird::Messaging::Channel.new
  end

  desc "Start all plans"
  task :start => [:prepare, :channel] do
    Dir[RegalBird.config.plan_dir + "**" + "*.rb"].each do |path|
      Rake::Task["plan:start"].execute(path)
    end
  end

  desc "Purge all plans"
  task :purge => [:prepare, :channel] do
    Dir[RegalBird.config.plan_dir + "**" + "*.rb"].each do |path|
      Rake::Task["plan:purge"].execute(path)
    end
  end

  namespace :plan do
    desc "Start a specific plan by path"
    task :start, [:path] => [:channel] do
      RegalBird::Messaging::Steward.new(
        @channel,
        eval(File.read(args[:path]))
      )
    end

    desc "Purge all remnants of a plan, and rename the plan file"
    task :purge, [:path] => [:channel] do
      RegalBird::Messaging::Steward.new(
        @channel,
        eval(File.read(args[:path]))
      ).delete
      File.rename args[:path], args[:path] + ".purged"
    end
  end

end
