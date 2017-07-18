require "regal_bird"
require_relative "../util/rake"
require_relative "fixture"
require_relative "fixture_builder"
require_relative "lib/fledgling"

RSpec.describe "a simple end to end test", type: :integration do

  before(:each) do
    @fixture_builder = Fledgling::FixtureBuilder.new
  end

  after(:each) do
    @fixture_builder.teardown
  end

  xit "processes the files" do
    @fixture_builder.setup(10,10)
    Rake::Task["regal_bird:plan:start"].execute(Fledgling.root_dir + "plan.rb")
  end

end
