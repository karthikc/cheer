module Standings
  module InstanceMethods

    def method_missing(method_id, *args, &block)
      method_name = method_id.to_s.to_sym

      # Call super if method is already defined or
      # it excludes standing methods list.
      if method_unknown?(method_name)
        super
      else
        define_instance_methods
        public_send(method_name, *args, &block)
      end
    end

    private

    INSTANCE_METHODS = [
      :current_rank,
      :rank_around,
      :prepare_leaderboard
    ]

    def method_unknown?(method_name)
      self.methods.include?(method_name) || !self.class.standing_methods.include?(method_name)
    end

    def define_instance_methods
      self.class.class_eval do
        delegate *INSTANCE_METHODS, to: :rank_evaluator

        # Define Rank Evaluator Method
        define_method :rank_evaluator do
          @rank_evaluator ||= RankEvaluator.new(self)
        end

        # Define Current Rank Method
        define_method self.standing_methods[0] do
          current_rank
        end

        # Define Around Rank Method
        define_method self.standing_methods[1] do
          rank_around
        end

        # Define Leaderboard Method
        define_method self.standing_methods[2] do |user_limit = 3|
          prepare_leaderboard(user_limit)
        end
      end
    end
  end
end
