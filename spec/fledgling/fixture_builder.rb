require_relative "lib/config"
require_relative "fixture"
require "fileutils"

module Fledgling

  # Builds and represents a set of fixtures in memory and on disk
  class FixtureBuilder

    attr_reader :fixtures

    def initialize
      @fixtures = []
    end

    def setup(num_txt, num_json)
      create_dirs!
      num_txt.times do
        fixture = Fixture.new
        fixtures << fixture
        File.write(fixture.txt_path, fixture.txt_content)
      end
      num_json.times do
        fixture = Fixture.new
        fixtures << fixture
        File.write(fixture.json_path, fixture.json_content)
      end
    end

    def teardown
      `rm -rf #{Fledgling.source_dir}`
      `rm -rf #{Fledgling.staging_dir}`
      `rm -rf #{Fledgling.done_dir}`
    end

    private

    def create_dirs!
      FileUtils.mkdir_p Fledgling.source_dir
      FileUtils.mkdir_p Fledgling.staging_dir
      FileUtils.mkdir_p Fledgling.done_dir
    end

  end

end
