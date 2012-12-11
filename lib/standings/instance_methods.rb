module Standings
  module InstanceMethods

    def method_missing(method_id, *args, &block)
      method_name = method_id.to_s.to_sym
      if !self.methods.include?(method_name)
        self.define_instance_methods
        self.send(method_name, *args, &block)
      else
        super
      end
    end

    def define_instance_methods
      singular_model_name = self.class.ranking_model_name.singularize
      self.class.class_eval do
        define_method "current_#{singular_model_name}_rank" do
          rank = self.high_rankers
          if self.equal_rankers?
            return rank + self.equal_rankers.order(self.class.rank_config.sort_order.join(',')).index(self)
          end
          return rank
        end
        define_method "#{self.ranking_model_name}_around" do
          off_set = self.send("current_#{singular_model_name}_rank".to_sym) - (self.class.rank_config.around_limit + 1)
          limit_setting = self.class.rank_config.around_limit*2 + 1
          if off_set < 0
            limit_setting += off_set
            off_set = 0
          end
          self.class.order("#{self.class.rank_config.column_name} DESC,#{self.class.rank_config.sort_order.join(',')}").limit(limit_setting).offset(off_set)
        end
      end
    end

    protected
    def high_rankers
      self.class.where("#{self.class.rank_config.column_name} > ?", self.send(self.class.rank_config.column_name.to_sym))
      .order("#{self.class.rank_config.column_name} DESC").size + 1
    end

    def equal_rankers?
      equal_rankers = self.equal_rankers
      equal_rankers && (equal_rankers.size > 1)
    end

    def equal_rankers
      self.class.where("#{self.class.rank_config.column_name} = ?", self.send(self.class.rank_config.column_name.to_sym))
    end
  end
end