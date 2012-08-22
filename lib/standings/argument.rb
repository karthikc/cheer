module Standings
  class Argument
    attr_reader :column_name, :sort_order, :around_limit

    def initialize(column_name, args)
      @column_name = self.parse_column_name(column_name)
      @sort_order = self.parse_sort_order(args[:sort_order])
      @around_limit = self.parse_around_limit(args[:around_limit])
      self.validate_column_name
      self.validate_sort_order
      self.validate_around_limit
    end

    def parse_column_name(column_name)
      column_name && (column_name.is_a?(String) || column_name.is_a?(Symbol)) ? column_name.to_s : ""
    end

    def parse_sort_order(sort_order)
      sort_order.present? ? sort_order : ["id"]
    end

    def parse_around_limit(around_limit)
      around_limit ? around_limit : 2
    end

    def validate_column_name
      raise(ArgumentError, 'First argument is not a symbol or string representing the primary rank column') if @column_name.empty?
    end
    
    def validate_around_limit
      raise(ArgumentError, 'Third argument is not an integer representing the around limit value') if @around_limit.to_i == 0
    end

    def validate_sort_order
      if @sort_order.is_a?(Array)
        @sort_order.push("id")
        return
      end
      raise(ArgumentError, 'Second argument is not an array of symbols or strings representing the sort column values')
    end
  end
end