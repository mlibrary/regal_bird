require "regal_bird"
require "json"
require "fileutils"

module Fledgling
  class TextToJson < RegalBird::Action
    def execute
      wrap_execution do
        content = File.read(txt_path)
        noun, count, comment = content.strip.split("\n")
        File.write(json_path, json_content(noun, count, comment))
        FileUtils.rm_f txt_path
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
