module SortParam
  class Definition
    attr_reader :fields_hash

    # Creates a new SortParam definition that whitelists the columns that are allowed to
    # sorted (i.e. used in SQL ORDER BY).
    def initialize
      @fields_hash = {}
    end

    # Allows whitelisting columns using a block
    #
    # @param block [Proc] Field definition block
    #
    # @return [self] Definition instance
    def define(&block)
      raise ArgumentError.new("Missing block") unless block_given?

      instance_eval(&block)

      self
    end

    # Add a whitelisted column
    #
    # @param name [String, Symbol] column name
    # @param defaults [Hash] column default options:
    #   * nulls [Symbol] nulls sort order. `:last` or `:first`
    #   * rename [String, Proc] rename field in the formatted output.
    #     This can be a Proc code block that receives the :name as argument and
    #     returns a transformed field name.
    #
    # @return [self] Definition instance
    def field(name, **defaults)
      name = name.to_s
      return if name.strip.empty?

      fields_hash[name] = preprocess_field_defaults(name, defaults)

      self
    end

    # Get default column options
    #
    # @param name [String] column name
    #
    # @return [Hash, NilClass] Default options
    def field_defaults(name)
      return nil if @fields_hash[name].nil?

      @fields_hash[name].dup
    end

    # Parse then translate a sort string expression and raise an error if the sort string includes
    # a non-whitelisted sort field.
    #
    # @see #load
    #
    # @raise [SortParam::UnsupportedSortField] if :sort_string includes a non-whitelisted sort field.
    #
    def load!(sort_string, mode: :hash)
      fields = Fields.new(sort_string)
      validate_fields!(fields)

      format_fields(mode, fields)
    end

    # Parse then translate a sort string expression
    #
    # @param sort_string [String] Sort expression. Comma-separated sort fields.
    # @param mode [Symbol, NilClass] Translation format
    #   * `:pg` for PostgreSQL ORDER BY SQL.
    #   * `:mysql` for MySQL ORDER BY SQL.
    #   * `:hash`/nil for the default hash representation.
    #
    # @example Sort by first_name ASC and then by last_name DESC
    #   definition.load!("+first_name,-last_name")
    #   # OR
    #   definition.load!("first_name,-last_name")
    #
    # @example Sort by first_name DESC NULLS LAST
    #   definition.load!("-first_name:nulls_last")
    #
    # @example Sort by first_name ASC NULLS FIRST
    #   definition.load!("+first_name:nulls_first")
    #
    # @return [Hash, String, NilClass] Translated to SQL or Hash.
    #   Returns nil if there is no column to sort.
    #
    def load(sort_string, mode: :hash)
      fields = Fields.new(sort_string)
      fields = fields.reject { |field| non_whitelisted_fields(fields).include?(field.name) }

      format_fields(mode, fields)
    end

    private

    def format_fields(mode, fields)
      Formatters::Formatter.for(mode)
                           .new(self)
                           .format(*fields)
    end

    def preprocess_field_defaults(field, defaults)
      rename = defaults[:rename]
      return defaults unless rename.is_a?(Proc)

      defaults[:rename] = defaults[:rename].call(field)
      defaults
    end

    def non_whitelisted_fields(loaded_fields)
      loaded_fields.names - fields_hash.keys
    end

    def validate_fields!(loaded_fields)
      unknown_field = non_whitelisted_fields(loaded_fields).first
      return true if unknown_field.nil?

      raise SortParam::UnsupportedSortField.new("Unsupported sort field: #{unknown_field}")
    end
  end
end
