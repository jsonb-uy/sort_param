# frozen_string_literal: true

module SortParam
  module Formatters
    class PG < Formatter
      def format(*fields)
        return format_collection(fields) if fields.size > 1

        field = fields[0]
        return nil if field.nil?

        field_defaults = definition.field_defaults(field.name) || {}
        column_name = field_defaults[:column_name] || field.name

        nulls = field.nulls || field_defaults[:nulls]
        "#{column_name} #{field.direction}#{nulls_order(nulls)}"
      end

      private

      def format_collection(fields)
        fields.map { |field| format(field) }.join(", ")
      end

      def nulls_order(nulls)
        return " nulls first" if nulls == :first

        " nulls last"
      end
    end
  end
end
