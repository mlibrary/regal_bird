require "pathname"

module Fledgling
  def self.root_dir
    Pathname.new(__FILE__).parent.parent + "test"
  end

  def self.source_dir
    root_dir + "source"
  end

  def self.staging_dir
    root_dir + "staging"
  end

  def self.done_dir
    root_dir + "done"
  end
end

