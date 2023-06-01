module SortParam
  class Fields
    include Enumerable
    include Utilities

    def initialize(sort_string)
      @fields = {}

      return if blank?(sort_string)

      parse_and_build_fields(sort_string)
    end

    def names
      fields.keys
    end

    def <<(field)
      fields[field.name] = field
    end

    def each(&block)
      fields.values.each(&block)
    end

    private

    attr_reader :fields

    def parse_and_build_fields(sort_string)
      sort_string.split(",").each do |sort_token|
        sort_token.strip!
        field = Field.from_string(sort_token)
        next if field.nil?

        self << field
      end

      self
    end
  end
end
