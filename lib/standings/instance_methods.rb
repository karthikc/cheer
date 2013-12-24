module Standings
  module InstanceMethods

    # Hookup event for InstanceMethods Module
    def self.included(base)
      base.class_eval do
        ranking_model_name = self.name.underscore

        # Define private rank_evaluator Method
        define_method :rank_evaluator do
          @rank_evaluator ||= RankEvaluator.new(
            model_klass: self.class,
            model_object: self,
            config: self.rank_config
          )
        end
        private :rank_evaluator

        # Define Current Rank Method
        define_method "current_#{ranking_model_name}_rank".to_sym do
          rank_evaluator.current_rank
        end

        # Define Around Rank Method
        define_method "#{ranking_model_name.pluralize}_around".to_sym do
          rank_evaluator.rank_around
        end

        # Define Leaderboard Method
        define_method :leaderboard do |user_limit = 3|
          Leaderboard.new(
            model_klass: self.class,
            rank_evaluator: rank_evaluator
          ).to_hash(user_limit)
        end
      end
    end

  end
end
