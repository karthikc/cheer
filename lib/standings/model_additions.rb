module Standings
  module ModelAdditions

    # Hookup event for InstanceMethods Module
    def self.extended(base)
      base.class_eval do
        model_name = self.name.underscore

        define_singleton_method :standing_methods do
          {
            current_rank: "current_#{model_name}_rank".to_sym,
            rank_around: "#{model_name.pluralize}_around".to_sym,
            top_rankers: "top_#{model_name.pluralize}".to_sym
          }
        end
      end
    end

    def rank_by(column_name, args = {})
      cattr_accessor :rank_config

      self.rank_config = Argument.new(column_name, args)

      rank_evaluator = RankEvaluator.new(model_klass: self, config: self.rank_config)

      # Define top_rankers method
      define_singleton_method self.standing_methods[:top_rankers] do |user_limit = 3|
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
        )
      end
    end

  end
end
