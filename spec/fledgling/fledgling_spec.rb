require "regal_bird"
require_relative "fixture"
require_relative "fixture_builder"
require_relative "lib/fledgling"

RSpec.describe "a simple end to end test", type: :integration do
  let(:plan_name) { "simple_fledgling" }

  before(:each) do
    @fixture_builder = Fledgling::FixtureBuilder.new
  end

  after(:each) do
    @fixture_builder.teardown
    RegalBird::CLI.new.invoke("purge_plan", [plan_name], plan_dir: Fledgling.plan_dir)
  end

  it "processes the files" do
    @fixture_builder.setup(0,1)
    puts "executing #{plan_name}"
    RegalBird::CLI.new.invoke("start_plan", [plan_name], plan_dir: Fledgling.plan_dir)

    sleep 30

    expect(Fledgling.done_dir.children).to match_array(
      @fixture_builder.fixtures
        .map {|fixture| fixture.expected_path }
    )
    @fixture_builder.fixtures.each do |fixture|
      expect(File.read fixture.expected_path).to eql(fixture.expected_content)
    end
  end

end
