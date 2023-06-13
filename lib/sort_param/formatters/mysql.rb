# frozen_string_literal: true

module SortParam
  module Formatters
    class MySQL < Formatter
      private

      def format_collection(fields)
        fields.map { |field| format(field) }.join(", ")
      end

      def format_field(field)
        field_defaults = definition.field_defaults(field.name) || {}

        column_name = formatted_field_name(field)
        nulls = (field.nulls || field_defaults[:nulls]).to_s
        nulls_sort_order = nulls_order(column_name, nulls)
        return "#{column_name} #{field.direction}" if nulls_sort_order.nil?

        "#{nulls_sort_order}, #{column_name} #{field.direction}"
      end

      def nulls_order(column_name, nulls)
        return "#{column_name} is not null" if nulls == "first"
        return "#{column_name} is null" if nulls == "last"

        nil
      end
    end
  end
end
