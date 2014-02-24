module Cheer
  class RankEvaluator
    extend Forwardable

    def_delegator :@config, :column_name, :column_name
    def_delegator :@config, :sort_order, :sort_order
    def_delegator :@config, :around_limit, :around_limit
    def_delegator :@config, :model_klass, :model_klass

    def initialize(attributes = {})
      @model_object = attributes[:model_object]
      @config       = attributes[:config]
    end

    def current_rank
      return high_rankers unless equal_rankers?
      high_rankers + position_amongst_equal_rankers
    end

    def rank_around
      offset = current_rank - (around_limit + 1)
      limit_setting = around_limit * 2 + 1

      if offset < 0
        limit_setting += offset
        offset = 0
      end

      top_rankers(limit_setting).offset(offset)
    end

    def top_rankers(user_limit)
      model_klass.order("#{column_name} DESC, #{sort_order}")
                 .limit(user_limit)
    end

    private

    attr_reader :model_object

    def column_value
      @column_value ||= model_object.public_send(column_name)
    end

    def high_rankers
      rankers = model_klass.where("#{column_name} > ?", column_value)
                           .order("#{column_name} DESC")

      @high_rankers ||= rankers.count + 1
    end

    def equal_rankers?
      equal_rankers && equal_rankers.count > 1
    end

    def equal_rankers
      @equal_rankers ||= model_klass.where("#{column_name} = ?", column_value)
                                    .order(sort_order)
                                    .select(:id)
    end

    def position_amongst_equal_rankers
      equal_rankers.index(model_object).to_i
    end

  end
end
