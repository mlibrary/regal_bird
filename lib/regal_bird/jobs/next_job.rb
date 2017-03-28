# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require "active_job"
require "repo_finder"
require "progress"

module RegalBird

  class NextJob < ActiveJob::Base
    def perform(progress_id)
      repo = RepoFinder.for(Progress)
      progress = repo.find(progress_id)
      progress.run_next
      repo.save(progress)
    end
  end

end

