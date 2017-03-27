# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

module RegalBird

  class RepoFinder
    class << self
      def repositories
        @repositories ||= {}
      end

      def register(entity, repo)
        repositories[entity.to_s.to_sym] = repo
      end

      def for(entity)
        repositories[entity.to_s.to_sym]
      end
    end
  end

end
