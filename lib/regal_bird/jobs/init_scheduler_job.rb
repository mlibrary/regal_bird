# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "active_job"
require "repo_finder"
require "plan"
require "jobs/init_job"

module RegalBird

  class InitSchedulerJob < ActiveJob::Base
    def perform
      RepoFinder.for(Plan).all.each do |plan|
        InitJob.perform_later(plan.name)
      end
    end
  end

end
