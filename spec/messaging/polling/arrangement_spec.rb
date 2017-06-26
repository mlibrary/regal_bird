require "regal_bird/messaging/polling/arrangement"
require "regal_bird/messaging/polling/consumer"
require "regal_bird/messaging/polling/publisher"
require "regal_bird/messaging/polling/retry_queue"
require "regal_bird/messaging/polling/work_queue"

RSpec.describe RegalBird::Messaging::Polling::Arrangement do
  let(:channel) { double(:channel) }
  let(:work_exchange) { double(:work_exchange) }
  let(:retry_exchange) { double(:retry_exchange) }
  let(:step_class) { Fixnum }
  let(:interval) { 30 }
  let(:arrangement) { described_class.new(channel, work_exchange, retry_exchange, step_class, interval) }

  let(:consumer) { double(:consumer) }
  let(:publisher) { double(:publisher, success: nil, retry: nil) }
  let(:retry_queue) { double(:retry_queue, binding: "foo") }
  let(:work_queue) { double(:work_queue, routing_key: "foobar" ) }

  before(:each) do
    allow(RegalBird::Messaging::Polling::Consumer).to receive(:new).and_return(consumer)
    allow(RegalBird::Messaging::Polling::Publisher).to receive(:new).and_return(publisher)
    allow(RegalBird::Messaging::Polling::RetryQueue).to receive(:new).and_return(retry_queue)
    allow(RegalBird::Messaging::Polling::WorkQueue).to receive(:new).and_return(work_queue)
  end

  describe "::new" do
    it "creates a Consumer" do
      expect(RegalBird::Messaging::Polling::Consumer).to receive(:new).with(
        work_queue, publisher, step_class
      )
      arrangement
    end

    it "creates a Publisher" do
      expect(RegalBird::Messaging::Polling::Publisher).to receive(:new).with(
        work_exchange, retry_exchange
      )
      arrangement
    end

    it "creates a RetryQueue" do
      expect(RegalBird::Messaging::Polling::RetryQueue).to receive(:new).with(
        channel, work_exchange, retry_exchange, step_class, interval
      )
      arrangement
    end

    it "creates a WorkQueue" do
      expect(RegalBird::Messaging::Polling::WorkQueue).to receive(:new).with(
        channel, work_exchange, step_class, "source.#{step_class.to_s}"
      )
      arrangement
    end

    it "retries the initial message" do
      expect(publisher).to receive(:retry).with(
        RegalBird::Messaging::Message.new(
          { routing_key: work_queue.routing_key },
          { headers: retry_queue.binding },
          RegalBird::Event.new(
            item_id: step_class.to_s,
            emitter: step_class,
            state: :source,
            data: {},
            start_time: Time.at(0),
            end_time: Time.at(0)
          )
        )
      )
      arrangement
    end



  end
end
