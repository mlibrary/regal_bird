require "logger"
require "ostruct"
require "yaml"

module RegalBird

  class Configuration < OpenStruct

    def initialize(hash = {})
      super hash.merge(logger: NullLogger.new)
    end

    def self.from_yaml(path)
      new(YAML.load(path))
    end

    def valid?
      has_key? :queue_adapter
    end

    private

    class NullLogger < Logger
      def initialize(*args); end
      def add(*args, &block); end
    end

  end

end