module Standings
  class RankEvaluator

    def initialize(attributes = {})
      @model_object = attributes[:model_object]
      @model_klass  = attributes[:model_klass]
      @config       = attributes[:config]
    end

    def current_rank
      return high_rankers unless equal_rankers?
      high_rankers + position_amongst_equal_rankers
    end

    def rank_around
      offset = current_rank - (config.around_limit + 1)
      limit_setting = config.around_limit * 2 + 1

      if offset < 0
        limit_setting += offset
        offset = 0
      end

      top_rankers(limit_setting).offset(offset)
    end

    def top_rankers(user_limit)
      model_klass.order("#{rank_column_name} DESC, #{combined_sort_order}")
      .limit(user_limit)
    end

    private

    attr_reader :model_object, :model_klass, :config

    def rank_column_name
      @rank_column_name ||= config.column_name
    end

    def rank_column_value
      @rank_column_value ||= model_object.public_send(rank_column_name.to_sym)
    end

    def combined_sort_order
      @combined_sort_order ||= config.sort_order.join(',')
    end

    def high_rankers
      rankers = model_klass.where(
        "#{rank_column_name} > ?", rank_column_value
      ).order("#{rank_column_name} DESC")

      @high_rankers ||= rankers.count + 1
    end

    def equal_rankers?
      equal_rankers && equal_rankers.count > 1
    end

    def equal_rankers
      @equal_rankers ||= model_klass.where(
        "#{rank_column_name} = ?", rank_column_value
      ).order(combined_sort_order).select(:id)
    end

    def position_amongst_equal_rankers
      equal_rankers.pluck(:id).index(model_object.id).to_i
    end

  end
end
