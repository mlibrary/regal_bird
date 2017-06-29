# frozen_string_literal: true

require "regal_bird/messaging/invoked/consumer"

class TestError < StandardError; end

RSpec.describe RegalBird::Messaging::Invoked::Consumer do
  let(:queue) do
    double(:queue,
      name: "test-queue-name",
      consumer_count: 3,
      subscribe: nil,
      ack: nil)
  end
  let(:publisher) { double(:publisher, retry: nil, success: nil) }
  let(:step_class) { double(:step_class, new: step) }
  let(:step) { double(:step, execute: event) }
  let(:event) { double(:event) }

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
        event: double(:event))
    end

    it "executes the step_class with the event" do
      expect(step_class).to receive(:new).with(message.event)
      expect(step).to receive(:execute)
      subject.perform(message)
    end

    context "execute raises an error" do
      let(:test_error) { TestError.new("some_error_msg") }
      before(:each) do
        allow(test_error).to receive(:backtrace).and_return("a/real/back/trace")
        allow(step).to receive(:execute).and_raise(test_error)
      end
      it "retries the message" do
        expect(publisher).to receive(:retry)
          .with(message, "#{test_error.message}\n#{test_error.backtrace}")
        subject.perform(message)
      end
      it "acks the message" do
        expect(queue).to receive(:ack).with(message.delivery_tag)
        subject.perform(message)
      end
    end

    context "execute runs w/o error" do
      it "publishes the event from execute" do
        expect(publisher).to receive(:success).with(event)
        subject.perform(message)
      end
      it "acks the message" do
        expect(queue).to receive(:ack).with(message.delivery_tag)
        subject.perform(message)
      end
    end
  end
end
