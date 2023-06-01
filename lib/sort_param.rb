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
  def self.define(options = {}, &block)
    Definition.new.define(options, &block)
  end
end
