# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "active_job"
require "repo_finder"
require "event_log"
require "plan"

module RegalBird

  class InitJob < ActiveJob::Base
    def perform(plan_id)
      RepoFinder.for(Plan).find(plan_id)
        .action(:init)
        .new(EventLog.new)
        .execute
    end
  end

end
