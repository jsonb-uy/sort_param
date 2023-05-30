# frozen_string_literal: true

module SortParam
  module Formatters
    class Formatter
      def self.for(mode)
        return Formatters::PG if mode == :pg
        return Formatters::MySQL if mode == :mysql

        Formatters::Hash
      end

      def initialize(definition)
        @definition = definition
      end

      private

      attr_reader :definition
    end
  end
end
