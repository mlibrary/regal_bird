require "regal_bird/repositories/memory_repo"
require_relative "../spec_helper"

RSpec.describe RegalBird::MemoryRepo do
  let(:repo) { described_class.new }
  it_behaves_like "a PlanRepo"
end
