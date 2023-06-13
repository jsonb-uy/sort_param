module SortParam
  module Utilities
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def blank?(str)
        return true if str.nil? || str == ""
        return false unless str.is_a?(String)

        str.strip!
        str.empty?
      end
    end

    def blank?(str)
      self.class.blank?(str)
    end
  end
end
