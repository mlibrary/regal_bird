require "active_job"
require "rspec/rails/matchers/active_job"

# ActiveJob test config
ActiveJob::Base.queue_adapter = :test
RSpec.configure do |config|
  # config.include(RSpec::ActiveJob)
  config.after(:each) do
    ::ActiveJob::Base.queue_adapter.enqueued_jobs = []
    ::ActiveJob::Base.queue_adapter.performed_jobs = []
  end
end
