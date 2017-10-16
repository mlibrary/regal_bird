# frozen_string_literal: true

require "json"
require "active_support/core_ext/time"
require "regal_bird/event"


module RegalBird
  module Messaging

    module EventSerializer

      # @param event [RegalBird::Event]
      # @return [String] JSON-encoded string
      def self.serialize(event)
        JSON.generate(item_id: event.item_id,
          emitter: event.emitter,
          state: event.state,
          data: event.data,
          start_time: event.start_time.iso8601(9),
          end_time: event.end_time.iso8601(9))
      end

      def self.deserialize(string)
        hash = JSON.parse(string, symbolize_names: true)
        RegalBird::Event.new(
          item_id: hash[:item_id],
          emitter: hash[:emitter],
          state: hash[:state],
          data: hash[:data],
          start_time: Time.parse(hash[:start_time]),
          end_time: Time.parse(hash[:end_time])
        )
      end

    end

  end
end
