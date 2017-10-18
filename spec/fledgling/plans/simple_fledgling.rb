require "regal_bird"
require_relative "../lib/fledgling"
require "logger"

mylogger = Logger.new("/home/bhock/code/regal_bird/spec/fledgling/log.txt")
mylogger.level = Logger::DEBUG

RegalBird::Plan.define("simple_fledgling") do
  #logger Logger.new(STDOUT)
  logger mylogger
  source Fledgling::TextSource, 1
  source Fledgling::JsonSource, 1
  action :ready, Fledgling::MoveToStaging, 1
  action :staged, Fledgling::DetermineType, 1
  action :txt,  Fledgling::TextToJson, 1
  action :json, Fledgling::JsonToYaml, 1
  action :yaml, Fledgling::MoveToDone, 1
  action :done, RegalBird::Action::Clean, 1
end

