module Standings
  class Argument

    attr_reader :column_name, :sort_order, :around_limit

    def initialize(column_name, args = {})
      @column_name  = parse_column_name(column_name)
      @sort_order   = parse_sort_order(args[:sort_order])
      @around_limit = parse_around_limit(args[:around_limit])

      validate_column_name
      validate_sort_order
      validate_around_limit

      # Ensure 'id' is always present in Sort Order.
      sort_order | ["id"]
    end

    private

    def parse_column_name(column_name)
      [String, Symbol].include?(column_name.class) ? column_name.to_s : ""
    end

    def parse_sort_order(sort_order)
      sort_order.present? ? sort_order : ["id"]
    end

    def parse_around_limit(around_limit)
      around_limit ? around_limit : 2
    end

    def validate_column_name
      raise Error::InvalidColumnName if column_name.blank?
    end

    def validate_around_limit
      raise Error::InvalidAroundLimit if around_limit.to_i <= 0
    end

    def validate_sort_order
      raise Error::InvalidSortOrder unless sort_order.is_a?(Array)
    end

  end
end
