require_relative "lib/config"
require "faker"

module Fledgling

  # Represents a unit of data, and defines how to write
  # that data to disk. Tests can compare actual results to
  # the corresponding methods on objects of this class.
  class Fixture
    def json_path
      Fledgling.source_dir + "#{name}.json"
    end

    def txt_path
      Fledgling.source_dir + "#{name}.txt"
    end

    def expected_path
      Fledgling.done_dir + "#{name}.yaml"
    end

    def json_content
      JSON.generate(content)
    end

    def txt_content
      [
        content["noun"],
        content["count"],
        content["comment"]
      ].join("\n")
    end

    def expected_content
      YAML.dump(content)
    end

    private

    def name
      @name ||= Faker::Food.spice
    end

    def content
      @content ||= {
        "noun" => Faker::Pokemon.name,
        "count" => rand(1..100),
        "comment" => Faker::HitchhikersGuideToTheGalaxy.marvin_quote
      }
    end
  end

end
