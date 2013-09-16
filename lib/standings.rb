require 'standings/version' # created by Bundler

require 'standings/error'
require 'standings/argument'
require 'standings/class_methods'
require 'standings/instance_methods'
require 'standings/instance_methods/rank_evaluator'

# Contains utility methods to find rank of a user.
require 'standings/model_additions'

ActiveRecord::Base.send(:include, Standings::ModelAdditions)
