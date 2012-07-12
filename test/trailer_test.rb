require 'test_helper'

class TrailerTest < Test::Unit::TestCase
  context "a trailer" do
    setup do
      @imdb = ImdbParty::Imdb.new
      @movie = @imdb.find_movie_by_id("tt1210166")
    end

    should "have a trailer_url" do
      assert_match /http:\/\/ia.media-imdb.com\/images\/.*/, @movie.trailer_url
    end
  
  end
end

