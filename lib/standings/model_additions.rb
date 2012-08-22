require 'standings/class_methods'
require 'standings/instance_methods'

module Standings
  module ModelAdditions
    # Hookup event for ModelAdditions Module
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end
  end
end
