require "regal_bird/configuration"
require "regal_bird/version"
require "regal_bird/action"
require "regal_bird/event"
require "regal_bird/plan"
require "regal_bird/source"
require "regal_bird/messaging"

module RegalBird
  class << self
    def config
      @config ||= Configuration.new
    end
    def config=(obj)
      @config = obj
    end
  end
end
