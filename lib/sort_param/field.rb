module SortParam
  class Field
    attr_reader :name, :direction, :nulls

    def initialize(name, direction, nulls)
      @name = name
      @direction = direction
      @nulls = nulls
    end
  end
end
