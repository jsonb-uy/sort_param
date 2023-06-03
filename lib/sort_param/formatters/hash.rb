# frozen_string_literal: true

module SortParam
  module Formatters
    class Hash < Formatter
      private

      def format_field(field)
        field_data = definition.field_defaults(field.name) || {}
        field_data.merge!(direction: field.direction)
        field_data.merge!(nulls: field.nulls) unless field.nulls.nil?

        { field.name => field_data }
      end

      def format_collection(fields)
        fields.map { |field| format(field) }
              .inject(&:merge!)
      end
    end
  end
end
