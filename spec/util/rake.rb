# frozen_string_literal: true

require "rake"
require "regal_bird/tasks"

# Usage
# bundle exec rake -f spec/rake.rb [normal rake opts]

namespace :regal_bird do
  task :setup do
    RegalBird.config = RegalBird::Configuration.new(
      plan_dir: Pathname.new(__FILE__).dirname.parent + "plans",
      connection: nil
    )
  end
end
