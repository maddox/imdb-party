require "#{File.dirname(__FILE__)}/../imdb_party.rb"
require 'levenshtein'

class MovieSearcher
  def initialize(args)
    args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] unless name == :options }
    
    @options = {
      :long => 15,
      :split => /\s+|\./,
      :imdb => ImdbParty::Imdb.new,
      :limit => 0.4
    }
    
    @options.merge!(args[:options]) unless args[:options].nil?
  end
  
  def self.find_by_release_name(search_value, options = {})
    this = MovieSearcher.new(options.merge(:search_value => search_value.to_s))
    return if this.to_long?
    
    return this.find_the_movie!
  end
  
  def to_long?
    @split = @search_value.split(@options[:split])
    @split.length > @options[:long]
  end
  
  def find_the_movie!
    current =  @split.length
    
    until current <= 0 do
      title = @split.take(current).join(' ')
      movies = @options[:imdb].find_by_title(title)
      break if movies.any?
      current -= 1 
    end
    
    return if movies.nil? or not movies.any?
    
    # Cleaning up the title, no years allowed
    title = title.gsub(/[^a-z0-9]/i, '').gsub(/(19|20)\d{2}/, '')
    
    movie = movies.map do |movie| 
      [movie, Levenshtein.normalized_distance(movie[:title].gsub(/[^a-z0-9]/i, ''), title, @options[:limit])]
    end.reject do |value|
      value.last.nil?
    end.sort_by do |_,value|
      value
    end.first
    
    return if movie.nil?
    
    return ImdbParty::Movie.new(movie.first)
  end
  
  def self.method_missing(m, *args, &block)  
    result = ImdbParty::Imdb.new.send(m, *args)
    return if result.nil?
    result.class == Array ? result.map{|r| ImdbParty::Movie.new(r)} : result
  end
end