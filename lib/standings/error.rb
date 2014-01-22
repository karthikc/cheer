module Standings
  module Error

    class InvalidColumnName < ArgumentError
      def message
        ':column_name option is not a symbol or string'
      end
    end

    class InvalidSortOrder < ArgumentError
      def message
        ':sort_order option is not an array of symbols or strings'
      end
    end

    class InvalidAroundLimit < ArgumentError
      def message
        ':around_limit option is not an integer'
      end
    end

    class InvalidScope < ArgumentError
      def message
        ':scope option is not a symbol or string'
      end
    end

  end
end
