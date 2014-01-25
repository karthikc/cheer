module ElegantLeaderboard
  module ModelAdditions

    # Hookup event for ModelAdditions Module
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

    def leaderboard(name, args = {})
      define_method name.to_sym do |user_limit = 3|
        rank_evaluator = RankEvaluator.new(
          model_object: self,
          config: Argument.new(args.merge(model_klass: self.class))
        )

        Leaderboard.new(
          model_klass: self.class,
          rank_evaluator: rank_evaluator
        )
      end
    end

  end
end
