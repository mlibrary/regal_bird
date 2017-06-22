require "regal_bird/messaging/invoked/work_queue"

RSpec.describe RegalBird::Messaging::Invoked::WorkQueue do
  let(:queue) { double(:queue, bind: nil) }
  let(:channel) { double(:channel, queue: queue) }
  let(:work_exchange) { double(:work_exchange) }
  let(:step_class) { described_class }
  let(:routing_key) { "sometest.routing.key" }
  let(:queue_name) { "action-regalbird_messaging_invoked_workqueue-work" }
  subject { described_class.new(channel, work_exchange, step_class, routing_key) }

  describe "#new" do
    it "initializes a non-exclusive, durable queue" do
      expect(channel).to receive(:queue)
        .with(queue_name, {
        exclusive: false, auto_delete: false, durable: true
      })
      subject
    end

    it "binds the queue to the exchange" do
      expect(queue).to receive(:bind).with(work_exchange, {routing_key: routing_key} )
      subject
    end
  end

  describe "#ack" do
    let(:delivery_tag) { :some_tag }
    it "acks exactly one message" do
      expect(queue).to receive(:ack).with(delivery_tag, false)
      subject.ack(delivery_tag)
    end
  end


end
