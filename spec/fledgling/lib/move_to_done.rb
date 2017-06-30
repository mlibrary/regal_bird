require "regal_bird"
require "pathname"

module Fledgling
  class MoveToDone < RegalBird::Action
    def execute
      wrap_execution do
        path = Pathname.new(event.data[:path])
        new_path = Fledgling.done_dir + path.basename
        File.rename path, new_path
        success(:done, {path: new_path.to_s})
      end
    end
  end
end
