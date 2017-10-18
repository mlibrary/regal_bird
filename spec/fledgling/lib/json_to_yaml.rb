require "regal_bird"
require "json"
require "yaml"
require "fileutils"

module Fledgling
  class JsonToYaml < RegalBird::Action
    def execute
      wrap_execution do
        content = File.read(json_path)
        File.write(yaml_path, yaml_content(json))
        FileUtils.rm_f json_path
        success(:yaml, {path: yaml_path})
      end
    end

    def yaml_content(json_string)
      YAML.dump(JSON.parse(json_path))
    end

    def json_path
      event.data[:path]
    end

    def yaml_path
      yaml_path.sub(".json", ".yaml")
    end

  end
end
