require "regal_bird"
require "json"

module Fledgling
  class TextToJson < RegalBird::Action
    def execute
      wrap_execution do
        content = File.read(txt_path)
        noun, count, comment = contents.strip.split("\n")
        `rm -f #{txt_path}`
        File.write(json_path, json_content)
        success(:json, {path: json_path})
      end
    end

    def json_content(noun, count, comment)
      JSON.generate({
        noun: noun,
        count: count,
        comment: comment
      })
    end

    def txt_path
      event.data[:path]
    end

    def json_path
      txt_path.sub(".txt", ".json")
    end

  end
end
