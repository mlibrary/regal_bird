require "pathname"

module Fledgling
  def self.root_dir
    Pathname.new(__FILE__).parent.parent
  end

  def self.test_dir
    root_dir + "test"
  end

  def self.plan_dir
    root_dir + "plans"
  end

  def self.source_dir
    test_dir + "source"
  end

  def self.staging_dir
    test_dir + "staging"
  end

  def self.done_dir
    test_dir + "done"
  end

  def self.logger
    @logger ||= Logger.new
  end
end

