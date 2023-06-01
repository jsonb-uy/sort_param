module SortParam
  module Utilities
    def blank?(str)
      return true if str.nil? || str == ""
      return false unless str.is_a?(String)

      str.strip!
      str.empty?
    end
  end
end
