module SortParam
  class Fields
    include Enumerable

    SORT_SYMBOL_DIRECTION = { "+" => :asc, "-" => :desc }.freeze

    class << self
      def parse(sort_string)
        sort_string = sort_string.to_s
        return if blank?(sort_string)

        fields = Fields.new
        sort_string.split(",").each do |sort_token|
          sort_token.strip!
          field = sort_token_to_field(sort_token)
          next if field.nil?

          fields << field
        end

        fields
      end

      private

      def sort_direction(str)
        return :asc unless SORT_SYMBOL_DIRECTION[str[0]]

        SORT_SYMBOL_DIRECTION[str[0]]
      end

      def column_name(str)
        return str unless SORT_SYMBOL_DIRECTION[str[0]]

        name = str.slice(1..-1)
        name.strip!
        return nil if blank?(name)
        return name if nulls_order(name).nil?

        name.sub!(/(:nulls_last|:nulls_first)$/, "")
      end

      def nulls_order(str)
        return :first if str.end_with?(":nulls_first")
        return :last if str.end_with?(":nulls_last")

        nil
      end

      def sort_token_to_field(token)
        return nil if blank?(token)

        name = column_name(token)
        return nil if blank?(name)

        direction = sort_direction(token)
        nulls = nulls_order(token)

        Field.new(name, direction, nulls)
      end

      def blank?(str)
        return true if str.nil?

        str = str.to_s
        str.strip!
        str.empty?
      end
    end

    def initialize
      @fields = {}
    end

    def names
      fields.keys
    end

    def <<(field)
      fields[field.name] = field
    end

    def to_h
      fields.values.map(&:to_h).inject(&:merge!)
    end

    def each(&block)
      fields.values.each(&block)
    end

    private

    attr_reader :fields
  end
end
