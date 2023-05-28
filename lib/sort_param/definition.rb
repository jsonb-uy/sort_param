module SortParam
  class Definition
    def define(options = {}, &block)
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

    def load!(sort_string, mode: :default)
      fields = Fields.parse(sort_string)
      validate_fields!(fields)

      return fields.to_sql if mode == :sql

      fields.to_h
    end

    private

    attr_reader :fields_hash

    def validate_fields!(fields)
      unknown_field = (fields.names - fields_hash.keys).first
      return true if unknown_field.nil?

      raise StandardError.new("Unsupported sort field: #{unknown_field}")
    end
  end
end
