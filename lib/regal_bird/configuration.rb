# frozen_string_literal: true

require "ostruct"
require "pathname"
require "logger"

module RegalBird

  class Configuration < OpenStruct
    DEFAULTS = {
      plan_dir:   nil,
      connection: nil
    }.freeze

    def initialize(hash = {})
      super(hash.merge(DEFAULTS))
    end

    def plan_dir=(value)
      self[:plan_dir] = Pathname.new(value.to_s)
    end

    def plan_dir
      self[:plan_dir]
    end

    def valid?
      !plan_dir.nil?
    end

    def logger
      @logger ||= Logger.new("log/regal_bird.log")
    end

  end

end
