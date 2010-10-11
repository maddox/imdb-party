require 'rubygems'
require 'httparty'

directory = File.expand_path(File.dirname(__FILE__))
# require File.join(directory, 'tvdb_party', 'httparty_icebox')
require File.join(directory, 'imdb_party', 'imdb')
require File.join(directory, 'imdb_party', 'movie')
# require File.join(directory, 'imdb_party', 'episode')
# require File.join(directory, 'imdb_party', 'banner')
# require File.join(directory, 'imdb_party', 'actor')

# imdb = ImdbParty::Imdb.new
# 
# puts imdb.popular_shows.inspect