require "regal_bird/repositories/plan_file_repo"
require "yaml"
require "fileutils"

class FirstAction; end
class MiddleAction; end
class DoneAction; end

RSpec.describe RegalBird::PlanFileRepo do
  before(:all) { FileUtils.mkdir_p "/tmp/regal_bird_test" }
  before(:each) { FileUtils.rm_rf "/tmp/regal_bird_test/*"}
  after(:all) { FileUtils.remove_entry_secure "/tmp/regal_bird_test" }
  let(:repo) { described_class.new("/tmp/regal_bird_test" ) }
  it_behaves_like "a PlanRepo"

  describe "yaml" do
    let(:plan_hash) {{ init: FirstAction, middle: MiddleAction, end: DoneAction }}
    let(:plan_file_body) do
      plan_hash.map{|k,v| [k.to_s, v.to_s] }
        .to_h
        .to_yaml
    end
    let(:plan_name) { "some_plan_name" }
    let(:plan) { RegalBird::Plan.new(plan_name, plan_hash) }
    it "reads and writes sensible files" do
      File.write("/tmp/regal_bird_test/#{plan_name}.yml", plan_file_body)
      expect(repo.find(plan_name)).to eql(plan)
    end
  end

end
