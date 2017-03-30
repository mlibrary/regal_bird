require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :regal_bird do
  desc "Enqueue plans and actions"
  task :schedule do
    require "regal_bird"
    InitSchedulerJob.perform_later
    ProgressSchedulerJob.perform_later
  end
end