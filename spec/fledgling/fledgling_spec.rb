require "regal_bird"
require_relative "../util/rake"
require_relative "fixture"
require_relative "fixture_builder"
require_relative "lib/fledgling"

RSpec.describe "a simple end to end test", type: :integration do
  let(:plan_path) { Fledgling.root_dir.parent + "lib" + "plan.rb" }

  before(:each) do
    @fixture_builder = Fledgling::FixtureBuilder.new
  end

  after(:each) do
    @fixture_builder.teardown
  end

  it "processes the files" do
    @fixture_builder.setup(10,10)
    puts "executing #{plan_path}"
    Rake::Task["regal_bird:plan:start"].execute(plan_path)
    sleep 5
    @fixture_builder.fixtures.each do |fixture|
      expect(File.exist? fixture.expected_path).to be true
      expect(File.read fixture.expected_path).to eql(fixture.expected_content)
    end
  end

end
