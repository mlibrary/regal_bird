require "regal_bird"
require "pathname"

module Fledgling
  class DetermineType < RegalBird::Action
    def execute
      wrap_execution do
        case Pathname.new(event.data[:path]).extname
        when ".txt"
          success(:txt, {})
        when ".json"
          success(:json, {})
        else
          failure("could not determine extension")
        end
      end
    end
  end
end
