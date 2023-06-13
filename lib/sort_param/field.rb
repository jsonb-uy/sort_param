module SortParam
  class Field
    include Utilities

    SORT_SYMBOL_DIRECTION = { "+" => :asc, "-" => :desc }.freeze

    class << self
      def from_string(sort_string)
        return nil if blank?(sort_string)

        name = column_name(sort_string)
        return nil if blank?(name)

        direction = sort_direction(sort_string)
        nulls = nulls_order(sort_string)

        Field.new(name, direction, nulls)
      end

      private

      def sort_direction(str)
        return :asc unless SORT_SYMBOL_DIRECTION[str[0]]

        SORT_SYMBOL_DIRECTION[str[0]]
      end

      def column_name(str)
        name = SORT_SYMBOL_DIRECTION[str[0]].nil? ? str : str.slice(1..-1)
        name.strip!

        return nil if blank?(name)
        return name if nulls_order(name).nil?

        name.sub(/(:nulls_last|:nulls_first)$/, "")
      end

      def nulls_order(str)
        return :first if str.end_with?(":nulls_first")
        return :last if str.end_with?(":nulls_last")

        nil
      end
    end

    attr_reader :name, :direction, :nulls

    def initialize(name, direction, nulls = nil)
      @name = name
      @direction = direction
      @nulls = nulls
    end
  end
end
