require 'standings/argument'

module Standings
  module ClassMethods

    def rank_by(column_name, args={})
      cattr_accessor :rank_config, :model_name
      self.rank_config = Argument.new(column_name, args)
      self.model_name = self.name.scan(/[A-Z][^A-Z]*/).join('_').downcase.pluralize
      self.define_class_methods(self.model_name)
    end

    def define_class_methods(model_name)
      (class << self; self end).class_eval do
        define_method "top_#{model_name}" do |user_limit = 3|
          self.order("#{self.rank_config.column_name} DESC, #{self.rank_config.sort_order.join(',')}").limit(user_limit)
        end
      end
    end
  end
end