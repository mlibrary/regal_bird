require "logger"
require "yaml"
require "ostruct"

module RegalBird

  class Configuration <  OpenStruct
    DEFAULTS = {
      queue_adapter: :inline,
      scheduler: :disabled,
      plan_dir: nil,
      db: nil,
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
      [:queue_adapter, :scheduler, :plan_dir, :db]
        .select{|field| self.send(field).nil? }
        .empty?
    end

  end

end