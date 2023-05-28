# frozen_string_literal: true

module SortParam
  module Formatters
    class Formatter
      def initialize(definition)
        @definition = definition
      end

      private

      attr_reader :definition
    end
  end
end
