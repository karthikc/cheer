module Standings
  module ClassMethods

    def rank_by(column_name, args = {})
      cattr_accessor :rank_config, :ranking_model_name

      self.rank_config = Argument.new(column_name, args)
      self.ranking_model_name = self.name.scan(/[A-Z][^A-Z]*/).join('_').downcase.pluralize
      define_class_methods
    end

    def define_class_methods
      ranking_model_name = self.ranking_model_name

      self.const_set(:STANDING_METHODS, [
        "current_#{ranking_model_name.singularize}_rank".to_sym,
        "#{ranking_model_name}_around".to_sym
      ])

      self.class.instance_eval do
        define_method "top_#{ranking_model_name}" do |user_limit = 3|
          self.order("#{self.rank_config.column_name} DESC, #{self.rank_config.sort_order.join(',')}").limit(user_limit)
        end

        define_method :standing_methods do
          self::STANDING_METHODS
        end

        private_class_method :standing_methods
      end
    end
  end
end
