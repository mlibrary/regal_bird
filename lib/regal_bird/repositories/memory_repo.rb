
module RegalBird

  class MemoryRepo
    def initialize
      @records = {}
    end

    def save(value)
      @records[identifier_for(value)] = value
    end

    def find(identifier)
      @records[identifier]
    end

    def all
      @records.values
    end

    def where_state(state)
      @records.values.select{|v| v&.state == state }
    end

    private

    def identifier_for(obj)
      return obj.id if obj.respond_to?(:id)
      return obj.name if obj.respond_to?(:name)
      return obj.object_id
    end

  end

end
