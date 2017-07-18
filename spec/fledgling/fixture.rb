require_relative "lib/config"
require "faker"

module Fledgling

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
      JSON.generate(base_content)
    end

    def txt_content
      [noun, count, comment].join("\n")
    end

    def expected_content
      YAML.dump(base_content)
    end

    private

    def base_content
      {
        "noun" => noun,
        "count" => count,
        "comment" => comment
      }
    end

    def name
      @name ||= Faker::Food.spice
    end

    def noun
      @noun ||= Faker::Pokemon.name
    end

    def count
      @count ||= rand(1..100)
    end

    def comment
      @comment ||= Faker::HitchhikersGuideToTheGalaxy.marvin_quote
    end
  end

end
