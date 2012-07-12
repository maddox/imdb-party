require 'test_helper'

class SlateTest < Test::Unit::TestCase
  context "a slate" do
    setup do
      @imdb = ImdbParty::Imdb.new
      @movie = @imdb.find_movie_by_id("tt1210166")
    end

    should "have a slate_url" do
      assert_match /http:\/\/ia.media-imdb.com\/images\/.*/, @movie.slate_url
    end
  
  end
end

