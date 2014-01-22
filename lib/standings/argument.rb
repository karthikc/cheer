module Standings
  class Argument

    attr_reader :column_name, :sort_order, :around_limit, :scope

    def initialize(args = {})
      @model_klass  = args[:model_klass]
      @column_name  = parse_column_name(args[:column_name])
      @sort_order   = parse_sort_order(args[:sort_order])
      @around_limit = parse_around_limit(args[:around_limit])
      @scope        = parse_scope(args[:scope])

      validate_column_name
      validate_sort_order
      validate_around_limit
      validate_scope

      merge_sort_order
      @scope = model_klass.public_send(scope)
    end

    private

    attr_reader :model_klass

    def parse_column_name(column_name)
      [String, Symbol].include?(column_name.class) ? column_name.to_s : ''
    end

    def parse_sort_order(sort_order)
      sort_order.present? ? sort_order : ['id']
    end

    def parse_around_limit(around_limit)
      around_limit ? around_limit : 2
    end

    def parse_scope(scope)
      return scope.to_s if [String, Symbol].include?(scope.class)
      # If activerecord version is 4.0 or newer then use 'all'
      # else use 'scoped' as default value for :scope.
      ActiveRecord.version.to_s.to_i > 3 ? 'all' : 'scoped'
    end

    def validate_column_name
      return if column_name.present? && column_exists_in_db?
      raise Error::InvalidColumnName
    end

    def validate_around_limit
      return if around_limit.to_i > 0
      raise Error::InvalidAroundLimit
    end

    def validate_sort_order
      return if sort_order.is_a?(Array)
      raise Error::InvalidSortOrder
    end

    def validate_scope
      return if scope.present? && scope_is_defined?
      raise Error::InvalidScope
    end

    def column_exists_in_db?
      model_klass.column_names.include?(column_name)
    end

    def scope_is_defined?
      model_klass.respond_to?(scope)
    end

    def merge_sort_order
      # Ensure 'id' is always present in Sort Order.
      @sort_order | ['id']
      @sort_order = @sort_order.join(',')
    end
  end
end
