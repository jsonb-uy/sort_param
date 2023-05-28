module SortParam
  class Field
    attr_reader :name, :direction, :nulls

    def initialize(name, direction, nulls)
      @name = name
      @direction = direction
      @nulls = nulls
    end

    def to_h
      { name => { direction: direction, nulls: nulls } }
    end

    def to_sql
    end
  end
end
