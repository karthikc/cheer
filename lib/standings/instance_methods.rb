module Standings
  module InstanceMethods

    # Hookup event for InstanceMethods Module
    def self.included(base)
      current_rank_method = base.standing_methods[:current_rank]
      rank_around_method  = base.standing_methods[:rank_around]

      base.class_eval do
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
        define_method current_rank_method do
          rank_evaluator.current_rank
        end

        # Define Around Rank Method
        define_method rank_around_method do
          rank_evaluator.rank_around
        end

        # Define Leaderboard Method
        define_method :leaderboard do |user_limit = 3|
          Leaderboard.new(
            model_klass: self.class,
            rank_evaluator: rank_evaluator
          )
        end
      end
    end

  end
end
