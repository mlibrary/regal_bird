require 'logger'
require "securerandom"

class SourceWorkClass
  def initialize(event)
    @event = event
  end

  def execute
    l = Logger.new('test.log')
    l.level = Logger::INFO
    l.info "MYSOURCE"
    l.info @event
    [
      RegalBird::Event.new(
        item_id: SecureRandom.uuid,
        emitter: self.class.to_s,
        state: :ready,
        data: { i: rand(100) },
        start_time: Time.now,
        end_time: Time.now
      )
    ]
  end
end

class MyAction
  def initialize(event)
    @event = event
  end

  def execute
    l = Logger.new('test.log')
    l.level = Logger::INFO
    l.info "MYACTION"
    l.info @event
    RegalBird::Event.new(
      item_id: "foomp",
      emitter: self.class.to_s,
      state: :half_done,
      data: {},
      start_time: Time.now,
      end_time: Time.now
    )
  end
end

class MySecondAction < RegalBird::Action
  def execute
    wrap_execution do
      l = Logger.new('test.log')
      l.level = Logger::INFO
      l.info "MYSECONDACTION"
      l.info @event
      success(:done, {})
    end
  end
end

ch = RegalBird::Messaging::Channel.new
wx = RegalBird::Messaging::WorkExchange.new("wx", ch)
rx = RegalBird::Messaging::RetryExchange.new("rx", ch)
pa = RegalBird::Messaging::Polling::Arrangement.new(ch, wx, rx, SourceWorkClass, 10)
ia = RegalBird::Messaging::Invoked::Arrangement.new(ch, wx, rx, MyAction, :ready, 1)
ia2 = RegalBird::Messaging::Invoked::Arrangement.new(ch, wx, rx, MySecondAction, :half_done, 1)

logger = Logger.new('other.log')
logger.level = Logger::INFO
la = RegalBird::Messaging::Logging::Arrangement.new(ch, wx, logger)
