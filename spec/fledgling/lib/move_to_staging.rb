require "regal_bird"
require "pathname"
require "fileutils"

module Fledgling
  class MoveToStaging < RegalBird::Action
    def execute
      wrap_execution do
        path = Pathname.new(event.data[:path])
        new_path = Fledgling.staging_dir + path.basename
        FileUtils.mv path, new_path
        success(:staged, {path: new_path.to_s})
      end
    end
  end
end
