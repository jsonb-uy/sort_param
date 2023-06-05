# frozen_string_literal: true

require_relative "sort_param/utilities"
require_relative "sort_param/formatters/formatter"
require_relative "sort_param/formatters/hash"
require_relative "sort_param/formatters/mysql"
require_relative "sort_param/formatters/pg"
require_relative "sort_param/field"
require_relative "sort_param/fields"
require_relative "sort_param/definition"
require_relative "sort_param/version"

module SortParam
  class UnsupportedSortField < StandardError; end

  # Creates a new SortParam definition that whitelists the columns that are allowed to
  # sorted (i.e. used in SQL ORDER BY).
  #
  # @param block [Proc] Field definition block
  #
  # @example
  #  SortParam.define do
  #    field :first_name
  #    field :last_name, nulls: :last
  #  end
  #
  # @return [Definition] Sort param definition
  #
  def self.define(&block)
    Definition.new.define(&block)
  end
end
