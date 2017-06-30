require_relative "lib/config"
require_relative "fixture"

module Fledgling

  class FixtureBuilder

    attr_reader :fixtures

    def initialize
      @fixtures = []
    end

    def setup(num_txt, num_json)
      create_dirs!
      num_text.times do
        fixture = Fixture.new
        fixtures << fixture
        File.write(fixture.txt_path, fixture.txt_content)
      end
      num_json.times do
        fixture = Fixture.new
        fixtures << fixture
        File.write(fixture.json_path, fixture.json_content)
        make_file(json_content, ".json")
      end
    end

    def teardown
      `rm -rf #{Fledgling.root_dir}`
    end

    private

    def create_dirs!
      File.mkdir_p Fledgling.source_dir
      File.mkdir_p Fledgling.staging_dir
      File.mkdir_p Fledgling.done_dir
    end

  end

end
