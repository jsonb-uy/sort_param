# frozen_string_literal: true

module SortParam
  module Formatters
    class PG < Formatter
      private

      def format_collection(fields)
        fields.map { |field| format(field) }.join(", ")
      end

      def format_field(field)
        field_defaults = definition.field_defaults(field.name) || {}
        column_name = field_defaults[:column_name] || field.name

        nulls = (field.nulls || field_defaults[:nulls]).to_s
        "#{column_name} #{field.direction}#{nulls_order(nulls)}"
      end

      def nulls_order(nulls)
        return " nulls first" if nulls == "first"
        return " nulls last" if nulls == "last"

        nil
      end
    end
  end
end
