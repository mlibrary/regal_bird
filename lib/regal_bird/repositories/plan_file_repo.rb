require "repositories/plan_repo"
require "plan"
require "pathname"

module RegalBird

  class PlanFileRepo < PlanRepo

    attr_reader :basedir

    def initialize(basedir)
      @basedir = Pathname.new basedir
    end

    def save(plan)
      File.write(path(plan.name), body(plan))
    end

    def find(name)
      reify(name, File.read(path(name)))
    end

    def all
      basedir
        .children
        .select{|p| p.extname == ".yml"}
        .map{|p| [p.basename(".yml"), File.read(p)]}
        .map{|pair| reify(*pair) }
    end

    private

    def path(name)
      basedir + "#{name}.yml"
    end

    def body(plan)
      plan.mappings
        .map{|state, action| [state, action.to_s]}
        .to_h
        .to_yaml
    end

    def reify(name, bodytext)
      maps = YAML.load(bodytext)
        .map{|state,klass| [state.to_sym, Module.const_get(klass)]}
        .to_h
      Plan.new(name.to_s, maps)
    end

  end

end