module SortParam
  class Definition
    attr_reader :fields_hash

    def define(options = {}, &block)
      raise ArgumentError.new("Missing block") unless block_given?

      @fields_hash = {}

      instance_eval(&block)
    end

    def default(sort_string)
      @default_sort = sort_string
    end

    def field(name, defaults = {})
      name = name.to_s
      return if name.strip.empty?

      fields_hash[name] = defaults

      self
    end

    def field_defaults(name)
      return nil if @fields_hash[name].nil?

      @fields_hash[name].dup
    end

    def load_param!(sort_string, mode: :default)
      fields = Fields.new(sort_string)
      validate_fields!(fields)

      formatter = Formatters::Formatter.for(mode)
      formatter.new(self).format(*fields)
    end

    private

    def validate_fields!(fields)
      unknown_field = (fields.names - fields_hash.keys).first
      return true if unknown_field.nil?

      raise StandardError.new("Unsupported sort field: #{unknown_field}")
    end
  end
end
