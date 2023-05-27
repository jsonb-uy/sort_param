module SortParam
  class Definition
    def define(options = {}, &block)
      @fields = {}

      instance_eval(&block)
    end

    def default(sort_string)
      @default_sort = sort_string
    end

    def field(name, defaults = {})
      name = name.to_s
      return if name.strip.empty?

      fields[name] = defaults

      self
    end

    def load!(sort_string, mode: :default)
      fields = Fields.parse(sort_string)
      return fields.to_sql if mode == :sql

      fields.to_h
    end

    private

    attr_reader :fields
  end
end
