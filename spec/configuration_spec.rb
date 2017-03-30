require "regal_bird/configuration"
require "pathname"

RSpec.describe RegalBird::Configuration do
  let(:config) { described_class.new }

  describe "#queue_adapter, #queue_adapter=" do
    it "defaults to :inline" do
      expect(config.queue_adapter).to eql(:inline)
    end
    it "accepts ActiveJob queue adapter symbols" do
      expect { config.queue_adapter = :resque }
        .to change { config.queue_adapter }
        .to :resque
    end
  end

  describe "#scheduler, #scheduler=" do
    it "defaults to :disabled" do
      expect(config.scheduler).to eql(:disabled)
    end
  end


  describe "#db, #db=" do
    it "has no default" do
      expect(config.db).to be_nil
    end
  end

  describe "#plan_dir, #plan_dir=" do
    it "has no default" do
      expect(config.plan_dir).to be_nil
    end
    it "converts strings to Pathnames" do
      expect { config.plan_dir = "some/dir" }
        .to change { config.plan_dir }
        .to Pathname.new("some/dir")
    end
    it "accepts Pathnames" do
      expect { config.plan_dir = Pathname.pwd }
        .to change { config.plan_dir }
          .to Pathname.pwd
    end
  end

  describe "#valid?" do
    let(:full_config) do
      described_class.new(
        queue_adapter: :test, db: {adapter: :test},
        scheduler: :disabled, plan_dir: Pathname.pwd
      )
    end
    [:db, :plan_dir, :queue_adapter, :scheduler].each do |field|
      it "is invalid when #{field} is nil" do
        full_config.public_send(:"#{field}=", nil)
        expect(config.valid?).to be false
      end
    end
  end

  it "allows arbitrary fields to be added" do
    expect { config.foo = :bar }
      .to change { config.foo }
      .from(nil).to(:bar)
  end

end