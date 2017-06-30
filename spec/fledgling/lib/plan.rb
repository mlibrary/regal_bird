require "regal_bird"
require_relative "fledgling"

RegalBird::Plan.define("fledgling") do
  logger Fledgling.logger
  source Fledgling::TextSource, 2
  source Fledgling::JsonSource, 2
  action :ready, Fledgling::MoveToStaging, 1
  action :staged, Fledgling::DetermineType, 1
  action :txt,  Fledgling::TextToJson, 1
  action :json, Fledgling::JsonToYaml, 1
  action :yaml, Fledgling::MoveToDone, 1
  action :done, RegalBird::Action::Clean, 1
end

