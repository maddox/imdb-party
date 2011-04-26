require 'rubygems'
require 'httparty'

directory = File.expand_path(File.dirname(__FILE__))
require File.join(directory, 'imdb_party', 'httparty_icebox')
require File.join(directory, 'imdb_party', 'imdb')
require File.join(directory, 'imdb_party', 'movie')
require File.join(directory, 'imdb_party', 'person')


puts ImdbParty::Imdb.new.find_movie_by_id('tt1391034').inspect
