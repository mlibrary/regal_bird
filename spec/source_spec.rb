# frozen_string_literal: true

require "regal_bird/components"
require "regal_bird/source"

module RegalBird

  RSpec.describe RegalBird::Source do
    class TestSource < RegalBird::Source
      class Error < StandardError; end
      def initialize(result_builder = nil, &block)
        super(result_builder)
        @block = block
      end
      def execute(result)
        @block.call(result)
      end
    end

    let(:result) do
      double(
        :result,
        success: [:success1, :success2],
        failure: []
      )
    end
    let(:result_builder) { double(:builder, for: result) }

    describe "#safe_execute" do
      context "when #execute runs without exception" do
        let(:source) { TestSource.new(result_builder) {|result| "foo" }}
        it "returns the result of #execute" do
          expect(source.safe_execute).to eql("foo")
        end
      end

      context "when #execute throws an exception" do
        let(:source) { TestSource.new(result_builder) {|_| raise TestSource::Error} }
        it "logs the exception" do
          expect(RegalBird.config.logger).to receive(:error)
          source.safe_execute
        end
        it "returns an empty array" do
          expect(source.safe_execute).to eql([])
        end
      end

    end
  end
end

