require 'standings/version' # created by Bundler
require 'standings/model_additions' # Contains utility methods to find rank of a user.

ActiveRecord::Base.send(:include, Standings::ModelAdditions)
