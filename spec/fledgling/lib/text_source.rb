require "regal_bird"
require "pathname"

module Fledgling
  class TextSource < RegalBird::Source
    def execute
      wrap_execution do
        Dir[Fledgling.source_dir + "*.txt"]
          .map{|f| Pathname.new(f) }
          .map{|path| success(path.basename, :ready, {path: path.to_s} ) }
      end
    end
  end
end

