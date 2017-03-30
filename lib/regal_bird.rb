require "version"
require "configuration"

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
