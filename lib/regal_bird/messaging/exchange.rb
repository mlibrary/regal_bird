# frozen_string_literal: true

module RegalBird
  module Messaging

    class Exchange

      attr_reader :work, :retry

      def initialize(work_exchange, retry_exchange, arrangements = [])
        @work = work_exchange
        @retry = retry_exchange
        @arrangements = arrangements
      end

      def delete
        @arrangements.each{|arrangement| arrangement.delete }
        @retry.delete
        @work.delete
      end


    end

  end
end
