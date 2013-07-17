require 'test_helper'

class MovieTest < Test::Unit::TestCase
  context "a movie" do
    setup do
      @imdb = ImdbParty::Imdb.new
      @movie = @imdb.find_movie_by_id("tt0382932")
    end

    should "have a title" do
      assert_equal "Ratatouille", @movie.title
    end

    should "have an imdb_id" do
      assert_equal "tt0382932", @movie.imdb_id
    end

    should "have a tagline" do
      assert_equal "Dinner is served... Summer 2007", @movie.tagline
    end

    should "have a plot" do
      assert_equal "With dreams of becoming a chef, a culinary genius in the form of a rat, makes an unusual alliance with a young kitchen worker at a famed restaurant.", @movie.plot
    end

    should "have a runtime" do
      assert_equal "111 min", @movie.runtime
    end

    should "have a rating" do
      assert_equal 8, @movie.rating
    end

    should "have a poster_url" do
      assert_match /http:\/\/ia.media-imdb.com\/images\/.*/, @movie.poster_url
    end

    should "have a release date" do
      assert_equal "2007-06-29", @movie.release_date
    end

    should "have a certification" do
      assert_equal "G", @movie.certification
    end

    should "have trailers" do
      assert_equal Hash, @movie.trailers.class
      assert_equal 0, @movie.trailers.keys.size
    end

    should "have genres" do
      assert_equal Array, @movie.genres.class
      assert_equal 4, @movie.genres.size
    end

    should "have actors" do
      assert_equal Array, @movie.actors.class
      assert_equal 4, @movie.actors.size
    end

    should "have directors" do
      assert_equal Array, @movie.directors.class
      assert_equal 2, @movie.directors.size
    end

    should "have writers" do
      assert_equal Array, @movie.writers.class
      assert_equal 2, @movie.writers.size
    end

  end

  context "a movie while anonymized" do
    setup do
      @imdb = ImdbParty::Imdb.new(:anonymize => true)
      @movie = @imdb.find_movie_by_id("tt0382932")
    end

    should "have a title" do
      assert_equal "Ratatouille", @movie.title
    end
  end

end
