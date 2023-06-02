# frozen_string_literal: true

module SortParam
  module Formatters
    class MySQL < Formatter
      def format(*fields)
        return format_collection(fields) if fields.size > 1

        field = fields[0]
        return nil if field.nil?

        field_defaults = definition.field_defaults(field.name) || {}
        column_name = field_defaults[:column_name] || field.name

        nulls = (field.nulls || field_defaults[:nulls]).to_s
        return "#{column_name} #{field.direction}" if nulls.nil?

        "#{nulls_order(column_name, nulls)}, #{column_name} #{field.direction}"
      end

      private

      def format_collection(fields)
        fields.map { |field| format(field) }.join(", ")
      end

      def nulls_order(column_name, nulls)
        return "#{column_name} is not null" if nulls == "first"
        return "#{column_name} is null" if nulls == "last"

        nil
      end
    end
  end
end
