require "regal_bird/messaging/polling/consumer"

RSpec.describe RegalBird::Messaging::Polling::Consumer do
  let(:queue) do
    double(:queue,
      name: "test-queue-name",
      consumer_count: 3,
      subscribe: nil,
      ack: nil
    )
  end
  let(:publisher) { double(:publisher, retry: nil, success: nil) }
  let(:step_class) { double(:step_class, new: step) }
  let(:step) { double(:step, execute: events) }
  let(:events) { [double(:event1), double(:event2) ] }

  subject { described_class.new(queue, publisher, step_class) }

  describe "#new" do
    it "subscribes as non-exclusive, manual_ack, non-blocking" do
      expect(queue).to receive(:subscribe).with(
        hash_including(
          manual_ack: true,
          exclusive: false,
          block: false
        )
      )
      subject
    end

    it "subscribes with a consumer_tag of queue.name-count+1" do
      expect(queue).to receive(:subscribe).with(hash_including(
        consumer_tag: "#{queue.name}-#{queue.consumer_count + 1}"
      ))
      subject
    end

    it "subscribes with a block that calls #perform"

  end

  describe "#perform" do
    let(:message) do
      double(:message,
        delivery_tag: "some_delivery_tag",
        event: double(:event)
      )
    end

    it "retries the message" do
      expect(publisher).to receive(:retry).with(message)
      subject.perform(message)
    end

    it "acks the message" do
      expect(queue).to receive(:ack).with(message.delivery_tag)
      subject.perform(message)
    end

    it "executes the step_class with the event" do
      expect(step_class).to receive(:new).with(message.event)
      expect(step).to receive(:execute)
      subject.perform(message)
    end

    it "publishes all events from the step class" do
      events.each do |event|
        expect(publisher).to receive(:success).with(event)
      end
      subject.perform(message)
    end

  end


end
