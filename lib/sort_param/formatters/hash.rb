# frozen_string_literal: true

module SortParam
  module Formatters
    class Hash < Formatter
      private

      def format_field(field)
        { formatted_field_name(field) => field_data(field) }
      end

      def format_collection(fields)
        fields.map { |field| format(field) }
              .inject(&:merge!)
      end

      def field_data(field)
        data = definition.field_defaults(field.name) || {}
        data.merge!(direction: field.direction)
        data.merge!(nulls: field.nulls) unless field.nulls.nil?
        data.delete(:formatted_name)
        data
      end
    end
  end
end
