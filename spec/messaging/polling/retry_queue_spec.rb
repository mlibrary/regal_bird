require "regal_bird/messaging/polling/retry_queue"

RSpec.describe RegalBird::Messaging::Polling::RetryQueue do
  let(:queue) { double(:queue, bind: nil) }
  let(:channel) { double(:channel, queue: queue) }
  let(:work_exchange) { double(:work_exchange, name: "some_work_exchange") }
  let(:retry_exchange) { double(:retry_exchange) }
  let(:step_class) { described_class }
  let(:routing_key) { "sometest.routing.key" }
  let(:queue_name) { "source-regalbird_messaging_polling_retryqueue-retry" }
  let(:interval) { 17 }
  subject { described_class.new(channel, work_exchange, retry_exchange, step_class, interval) }

  describe "#new" do
    it "initializes a non-exclusive, durable, dlx, size==1 queue" do
      expect(channel).to receive(:queue)
        .with(queue_name, {
        exclusive: false, auto_delete: false, durable: true,
        arguments: {
          "x-dead-letter-exchange" => work_exchange.name,
          "x-message-ttl" => interval * 1000,
          "x-max-length" => 1
        }
      })
      subject
    end

    it "binds the queue to the retry exchange on 'source' => step_class.to_s" do
      expect(queue).to receive(:bind)
        .with(retry_exchange, {arguments: {"x-match" => "all", "source" => step_class.to_s}})
      subject
    end
  end

  describe "#route" do
    it "binds on the source" do
      expect(subject.route).to eql({"source" => step_class.to_s})
    end
  end

end
