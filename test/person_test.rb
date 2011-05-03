require 'test_helper'

class PersonTest < Test::Unit::TestCase
  context "a person" do
    setup do
      @imdb = ImdbParty::Imdb.new
      @movie = @imdb.find_movie_by_id("tt0382932")
    end

    context "actors" do
      should "have a name" do
        assert_equal "Brad Garrett", @movie.actors.first.name
      end

      should "have a role" do
        assert_equal "Gusteau", @movie.actors.first.role
      end
    end

    context "directors" do
      should "have a name" do
        assert_equal "Brad Bird", @movie.directors.first.name
      end

      should "not have a role" do
        assert_equal nil, @movie.directors.first.role
      end
    end

    context "writers" do
      should "have a name" do
        assert_equal "Brad Bird", @movie.writers.first.name
      end

      should "not have a role" do
        assert_equal nil, @movie.writers.first.role
      end
    end


  end
end
