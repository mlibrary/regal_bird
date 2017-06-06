require "logger"
require "yaml"
require "ostruct"

module RegalBird

  class Configuration <  OpenStruct
    DEFAULTS = {
      plan_dir: nil
    }.freeze

    def initialize(hash = {})
      super(hash.merge(DEFAULTS))
    end

    def plan_dir=(value)
      self[:plan_dir] = if value.nil?
        nil
      else
        Pathname.new(value)
      end
    end

    def plan_dir
      self[:plan_dir]
    end

    def valid?
      !plan_dir.nil?
    end

  end

end
