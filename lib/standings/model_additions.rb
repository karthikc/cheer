module Standings
  module ModelAdditions

    def rank_by(column_name, args = {})
      cattr_accessor :rank_config

      self.rank_config = Argument.new(column_name, args)

      rank_evaluator = RankEvaluator.new(model_klass: self, config: self.rank_config)

      define_singleton_method "top_#{self.name.underscore.pluralize}" do |user_limit = 3|
        rank_evaluator.top_rankers(user_limit)
      end

      # Include this module to get instance methods.
      # This module requires rank_config to be set.
      include InstanceMethods
    end

    def leaderboard(name, column_name, args = {})
      define_method name.to_sym do |user_limit = 3|
        rank_evaluator = RankEvaluator.new(
          model_klass: self.class,
          model_object: self,
          config: Argument.new(column_name, args)
        )

        Leaderboard.new(
          model_klass: self.class,
          rank_evaluator: rank_evaluator
        ).to_hash(user_limit)
      end
    end

  end
end
