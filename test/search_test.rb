require 'test_helper'

class SearchTest < Test::Unit::TestCase
  context "imdb" do
    setup do
      @imdb = ImdbParty::Imdb.new
    end

    context "search for title" do
      setup do
        @results = @imdb.find_by_title("ratatouille")
      end

      should "have at least 15 results" do
        assert (@results.size >= 15)
      end
    end

    context "search for title with spaces in the name" do
      setup do
        @results = @imdb.find_by_title("the truman show")
      end

      should "have at least 1 result" do
        assert (@results.size >= 1)
      end
    end

    context "search for bad title with no results" do
      setup do
        @results = @imdb.find_by_title("sdkljlkkl123j4lk23kl3")
      end

      should "have 0 results" do
        assert_equal 0, @results.size
      end
    end

    context "find movie by id" do
      setup do
        @movie = @imdb.find_movie_by_id("tt0382932")
      end

      should "be a ImdbParty::Movie" do
        assert_equal ImdbParty::Movie, @movie.class
      end
    end

    context "find top 250 movies" do
      setup do
        @movies = @imdb.top_250
      end

      should "be an Array of Hashes" do
        assert_equal Array, @movies.class
        assert_equal Hash, @movies.first.class
      end
    end

    context "find popular shows" do
      setup do
        @shows = @imdb.popular_shows
      end

      should "be an Array of Hashes" do
        assert_equal Array, @shows.class
        assert_equal Hash, @shows.first.class
      end
    end

  end

  context "anonymous imdb" do
    setup do
      @imdb = ImdbParty::Imdb.new(:anonymize => true)
    end

    context "find popular shows" do
      setup do
        @shows = @imdb.popular_shows
      end

      should "be an Array of Hashes" do
        assert_equal Array, @shows.class
        assert_equal Hash, @shows.first.class
      end
    end

  end

end
