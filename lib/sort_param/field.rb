module SortParam
  class Field
    attr_reader :name, :direction, :options

    def initialize(name, direction, options = {})
      @name = name
      @direction = direction
      @options = options
    end
  end
end
