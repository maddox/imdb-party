require 'rspec'
require "#{File.dirname(__FILE__)}/../lib/movie_searcher.rb"
require "#{File.dirname(__FILE__)}/../lib/imdb_party/levenshtein.rb"

RSpec.configure do |config|
  config.mock_with :rspec
end