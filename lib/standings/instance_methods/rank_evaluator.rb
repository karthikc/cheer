module Standings
  module InstanceMethods
    class RankEvaluator
      def initialize(model_object)
        @model_object = model_object
        @model_klass  = model_object.class
      end

      def current_rank
        return high_rankers unless equal_rankers?
        high_rankers + position_amongst_equal_rankers
      end

      def rank_around
        offset = current_rank - (rank_config.around_limit + 1)
        limit_setting = rank_config.around_limit * 2 + 1

        if offset < 0
          limit_setting += offset
          offset = 0
        end

        model_klass.order("#{rank_column_name} DESC, #{combined_sort_order}")
        .limit(limit_setting)
        .offset(offset)
      end

      def prepare_leaderboard(user_limit = 3)
        {
          current_rank: current_rank,
          rank_around: rank_around,
          top_rankers_method => model_klass.public_send(top_rankers_method, user_limit)
        }
      end

      private

      attr_reader :model_object, :model_klass

      def rank_config
        @rank_config ||= model_klass.rank_config
      end

      def rank_column_name
        @rank_column_name ||= rank_config.column_name
      end

      def rank_column_value
        @rank_column_value ||= model_object.public_send(rank_column_name.to_sym)
      end

      def combined_sort_order
        @combined_sort_order ||= rank_config.sort_order.join(',')
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

      def top_rankers_method
        "top_#{model_klass.ranking_model_name}".to_sym
      end
    end
  end
end
