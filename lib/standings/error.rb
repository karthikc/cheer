module Error
  class InvalidColumnName < ArgumentError
    def message
      'First argument is not a symbol or string representing the primary rank column'
    end
  end

  class InvalidSortOrder < ArgumentError
    def message
      'Second argument is not an array of symbols or strings representing the sort column values'
    end
  end

  class InvalidAroundLimit < ArgumentError
    def message
      'Third argument is not an integer representing the around limit value'
    end
  end
end
