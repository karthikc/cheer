module ElegantLeaderboard
  class Leaderboard

    def initialize(attributes = {})
      @model_klass    = attributes[:model_klass]
      @rank_evaluator = attributes[:rank_evaluator]

      define_public_methods
    end

    def to_hash(user_limit = 3)
      {
        standing_methods[:current_rank] => self.public_send(standing_methods[:current_rank]),
        standing_methods[:rank_around]  => self.public_send(standing_methods[:rank_around]),
        standing_methods[:top_rankers]  => self.public_send(standing_methods[:top_rankers], user_limit)
      }
    end

    private

    attr_reader :model_klass, :rank_evaluator

    def standing_methods
      @standing_methods ||= model_klass.standing_methods
    end

    def define_public_methods
      current_rank_method = standing_methods[:current_rank]
      rank_around_method  = standing_methods[:rank_around]
      top_rankers_method  = standing_methods[:top_rankers]

      self.class_eval do
        define_method current_rank_method do
          rank_evaluator.current_rank
        end

        define_method rank_around_method do
          rank_evaluator.rank_around
        end

        define_method top_rankers_method do |user_limit = 3|
          rank_evaluator.top_rankers(user_limit)
        end
      end
    end

  end
end
