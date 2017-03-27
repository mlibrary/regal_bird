require "regal_bird/repo_finder"

module RegalBird
  class TestEntity; end

  RSpec.describe RepoFinder do
    describe "::register, ::for" do
      it "can register a repo to a symbol" do
        RepoFinder.register(:test_entity, :some_repo)
        expect(RepoFinder.for(:test_entity)).to eql(:some_repo)
      end
      it "can register a repository to an entity class" do
        RepoFinder.register(TestEntity, :some_repo)
        expect(RepoFinder.for(TestEntity)).to eql(:some_repo)
      end
      it "registers TestEntity and RegalBird::TestEntity identically" do
        RepoFinder.register(RegalBird::TestEntity, :some_repo)
        expect(RepoFinder.for(TestEntity)).to eql(:some_repo)
      end
    end
  end
  
end
