module Standings
  module InstanceMethods

    def method_missing(method_id, *args, &block)
      method_name = method_id.to_s.to_sym

      # Call super if method is already defined or it excludes standing methods list.
      if self.methods.include?(method_name) || !self.class.standing_methods.include?(method_name)
        super
      else
        define_instance_methods
        public_send(method_name, *args, &block)
      end
    end

    private

    def define_instance_methods
      self.class.class_eval do
        delegate :current_rank,
                 :rank_around,
                 to: :rank_evaluator

        # Define Rank Evaluator Method
        define_method :rank_evaluator do
          @rank_evaluator ||= RankEvaluator.new(self)
        end

        # Define Current Rank Method
        define_method self.standing_methods.first do
          current_rank
        end

        # Define Around Rank Method
        define_method self.standing_methods.last do
          rank_around
        end
      end
    end
  end
end
