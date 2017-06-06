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
      plan = RepoFinder.for(Plan).find(plan_id)
      progresses = plan.sources
        .map {|source| source.execute }
        .flatten
        .map {|event| Progress.new(new_id, plan, EventLog.new([event])) }

    end

    def new_id
      SecureRandom.uuid
    end

  end

end
