# frozen_string_literal: true

module SortParam
  module Formatters
    class Formatter
      include Utilities

      def self.for(mode)
        return Formatters::PG if mode == :pg
        return Formatters::MySQL if mode == :mysql

        Formatters::Hash
      end

      def initialize(definition)
        @definition = definition
      end

      def format(*fields)
        return format_collection(fields) if fields.size > 1

        field = fields[0]
        return nil if field.nil?

        format_field(field)
      end

      private

      attr_reader :definition

      def format_collection(fields)
        raise NotImplementedError
      end

      def format_field(field)
        raise NotImplementedError
      end

      def formatted_field_name(field)
        formatted_name = definition.field_defaults(field.name)[:formatted_name]

        blank?(formatted_name) ? field.name : formatted_name
      end
    end
  end
end
