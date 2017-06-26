require "regal_bird/messaging/invoked/retry_queue"

RSpec.describe RegalBird::Messaging::Invoked::RetryQueue do
  let(:queue) { double(:queue, bind: nil) }
  let(:channel) { double(:channel, queue: queue) }
  let(:work_exchange) { double(:work_exchange, name: "some_work_exchange") }
  let(:retry_exchange) { double(:retry_exchange) }
  let(:routing_key) { "sometest.routing.key" }
  let(:queue_name) { "action-retry-#{ttl}" }
  let(:ttl) { 17 }
  subject { described_class.new(channel, work_exchange, retry_exchange, ttl) }

  describe "#new" do
    it "initializes a non-exclusive, non-durale, expiring, dlx queue" do
      expect(channel).to receive(:queue)
        .with(queue_name, {
        exclusive: false, auto_delete: true, durable: false,
        arguments: {
          "x-dead-letter-exchange" => work_exchange.name,
          "x-message-ttl" => ttl * 1000,
          "x-expires" => ttl * 2 * 1000
        }
      })
      subject
    end

    it "binds the queue to the retry exchange on 'retry-wait' => ttl" do
      expect(queue).to receive(:bind)
        .with(retry_exchange, {arguments: {"x-match" => "all", "retry-wait" => ttl}})
      subject
    end
  end

  describe "#route" do
    it "binds on the ttl" do
      expect(subject.route).to eql({"retry-wait" => ttl})
    end
  end

end
