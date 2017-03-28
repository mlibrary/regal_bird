# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "active_job"
require "repo_finder"
require "progress"
require "jobs/next_job"

module RegalBird

  class ProgressSchedulerJob < ActiveJob::Base
    def perform
      RepoFinder.for(Progress).all.each do |progress|
        NextJob.perform_later(progress.id)
      end
    end
  end

end
