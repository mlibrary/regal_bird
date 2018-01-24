# frozen_string_literal: true

require "regal_bird/components"
require "regal_bird/action"

RSpec.describe RegalBird::Action do
  class TestAction < RegalBird::Action
    class Error < StandardError; end
    def initialize(event, result_builder = nil, &block)
      super(event, result_builder)
      @block = block
    end
    def execute(result)
      @block.call(result)
    end
  end

  describe RegalBird::Action::Clean do
    describe "#execute" do
      it "raises no error" do
        expect { RegalBird::Action::Clean.new(double(:event)).execute(nil) }
          .to_not raise_error
      end
    end
  end

  describe "#event" do
    let(:event) { double(:event) }
    let(:action) { TestAction.new(event){} }
    it "exposes the previous event" do
      expect(action.event).to eql(event)
    end
  end

  describe "#safe_execute" do
    let(:event) { double(:event) }
    let(:result_builder) { double(:builder, for: result) }
    let(:result) do
      double(
        :result,
        success: double(:success),
        noop: double(:noop),
        failure: double(:failure)
      )
    end

    context "when #execute runs without exception" do
      let(:action) { TestAction.new(event, result_builder) {|result| "foo" }}
      it "returns the result of #execute" do
        expect(action.safe_execute).to eql("foo")
      end
    end

    context "when #execute throws an exception" do
      let(:action) { TestAction.new(event, result_builder) {|_| raise TestAction::Error} }
      it "logs the exception" do
        expect(RegalBird.config.logger).to receive(:error)
        action.safe_execute
      end
      it "returns a failure event" do
        expect(action.safe_execute).to eql(result.failure)
      end
    end
  end
end
