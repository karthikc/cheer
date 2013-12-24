module Standings
  class Leaderboard

    def initialize(attributes = {})
      @model_klass    = attributes[:model_klass]
      @rank_evaluator = attributes[:rank_evaluator]
    end

    def to_hash(user_limit = 3)
      {
        current_rank_method => rank_evaluator.current_rank,
        rank_around_method  => rank_evaluator.rank_around,
        top_rankers_method  => rank_evaluator.top_rankers(user_limit)
      }
    end

    private

    attr_reader :model_klass, :rank_evaluator

    def ranking_model_name
      @ranking_model_name ||= model_klass.name.underscore
    end

    def top_rankers_method
      @top_rankers_method ||= "top_#{ranking_model_name.pluralize}".to_sym
    end

    def current_rank_method
      "current_#{ranking_model_name}_rank".to_sym
    end

    def rank_around_method
      "#{ranking_model_name.pluralize}_around".to_sym
    end

  end
end
