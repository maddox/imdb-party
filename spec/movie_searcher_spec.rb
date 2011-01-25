require 'spec_helper'

describe MovieSearcher do
  it "should only contain should instances of {ImdbParty::Movie}" do
    MovieSearcher.find_by_title("The Dark Knight").each{|movie| movie.should be_instance_of(ImdbParty::Movie)}
  end
  
  it "should only contain one instance of {ImdbParty::Movie}" do
    MovieSearcher.find_movie_by_id("tt0468569").should be_instance_of(ImdbParty::Movie)
  end
  
  it "should return nil if no movie is found" do
    MovieSearcher.find_movie_by_id("tt23223423423").should be_nil
  end
  
  it "should return nil if the movie title is to long" do
    MovieSearcher.find_by_release_name("asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd").should be_nil
  end
  
  it "should return nil when setting the limit to low" do
    MovieSearcher.find_by_release_name('Paranormal Activity 2 2010 UNRATED DVDRip XviD-Larceny', :options => {:limit => 0}).should be_nil
  end
  
  it "should return the right movie" do
    [{
      :title => "Live Free Or Die Hard 2007 DVDRIP XviD-CRNTV", :iid => "tt0337978"
    }, {
      :title => "The Chronicles of Narnia - The Voyage of the Dawn Treader TS XViD - FLAWL3SS", :iid => "tt0980970"
    }, {
      :title => "Heartbreaker 2010 LIMITED DVDRip XviD-SUBMERGE", :iid => "tt1465487"
    },{
      :title => "Paranormal Activity 2 2010 UNRATED DVDRip XviD-Larceny", :iid => "tt1536044",
      :title => "The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC", :iid => "tt0840361"
    }].each do |movie|
      MovieSearcher.find_by_release_name(movie[:title]).imdb_id.should eq(movie[:iid])
    end
  end
  
  it "should return nil if no value is being passed to it" do
    MovieSearcher.find_by_release_name("").should be_nil
  end
  
  it "should return nil if nil is being passed to it" do
    MovieSearcher.find_by_release_name(nil).should be_nil
  end
  
  it "should not have a rating if the details option isn't being passed" do
    MovieSearcher.find_by_release_name('Paranormal Activity 2 2010 UNRATED DVDRip XviD-Larceny').rating.should be_nil
  end
  
  it "should return a rating if the detail option is being passed" do
    MovieSearcher.find_by_release_name('Paranormal Activity 2 2010 UNRATED DVDRip XviD-Larceny', :options => {:details => true}).rating.should_not be_nil
  end
end

describe MovieSearcher, "should work as before" do
  before(:all) do
    @movie = MovieSearcher.find_movie_by_id("tt0382932")
  end

  it "have a title" do
    @movie.title.should eq("Ratatouille")
  end

  it "have an imdb_id" do
    @movie.imdb_id.should eq("tt0382932")
  end

  it "have a tagline" do
    @movie.tagline.should eq("Dinner is served... Summer 2007")
  end

  it "have a plot" do
    @movie.plot.should eq("Remy is a young rat in the French countryside who arrives in Paris, only to find out that his cooking idol is dead. When he makes an unusual alliance with a restaurant's new garbage boy, the culinary and personal adventures begin despite Remy's family's skepticism and the rat-hating world of humans.")
  end

  it "have a runtime" do
    @movie.runtime.should eq("111 min")
  end

  it "have a rating" do
    @movie.rating.should eq(8.1)
  end

  it "have a poster_url" do
    @movie.poster_url.should match(/http:\/\/ia.media-imdb.com\/images\/.*/)
  end

  it "have a release date" do
    @movie.release_date.should eq(DateTime.parse("2007-06-29"))
  end

  it "have a certification" do
    @movie.certification.should  eq("G")
  end

  it "have trailers" do
    @movie.trailers.should be_instance_of(Hash)
    @movie.should have(4).trailers
    @movie.trailers[@movie.trailers.keys.first].should eq("http://www.totaleclips.com/Player/Bounce.aspx?eclipid=e27826&bitrateid=461&vendorid=102&type=.mp4")
  end

  it "have genres" do
    @movie.genres.should be_instance_of(Array)
    @movie.genres.each{|genre| genre.should be_instance_of(String)}
    @movie.should have(4).genres
  end

  it "have actors" do
    @movie.actors.should be_instance_of(Array)
    @movie.actors.each{|actor| actor.should be_instance_of(ImdbParty::Person)}
    @movie.should have(4).actors
  end

  it "have directors" do
    @movie.directors.should be_instance_of(Array)
    @movie.directors.each{|director| director.should be_instance_of(ImdbParty::Person)}
    @movie.should have(2).directors
  end

  it "have writers" do
    @movie.writers.should be_instance_of(Array)
    @movie.writers.each{|writer| writer.should be_instance_of(ImdbParty::Person)}
    @movie.should have(2).writers
  end
  
  it "always return a date object when requesting the release date" do
    [{:imdb => "tt0066026", :date => "1970-03-01"}, {:imdb => "tt1446072", :date => "2010-11-27"}].each do |value|
      movie = MovieSearcher.find_movie_by_id(value[:imdb])
      movie.release_date.strftime('%Y %m %d').should eq(DateTime.parse(value[:date]).strftime('%Y %m %d'))
      movie.release_date.should be_instance_of(Date)
    end
  end
end

describe MovieSearcher, "should also work as before" do
  it "should have at least 15 results" do
    MovieSearcher.find_by_title("ratatouille").count.should >= 15
  end

  it "search for title with spaces in the name" do
    MovieSearcher.find_by_title("the truman show").count.should >= 1
  end

  it "search for bad title with no results" do
    MovieSearcher.find_by_title("sdkljlkkl123j4lk23kl3").count.should eq(0)
  end

  it "find movie by id" do
    MovieSearcher.find_movie_by_id("tt0382932").should be_instance_of(ImdbParty::Movie)
  end
  
  it "be an Array of {ImdbParty::Movie}" do
    MovieSearcher.top_250.should be_instance_of(Array)
    MovieSearcher.top_250.first.should be_instance_of(ImdbParty::Movie)
  end

  it "find popular shows" do
    MovieSearcher.popular_shows.should be_instance_of(Array)
    MovieSearcher.popular_shows.first.should be_instance_of(ImdbParty::Movie)
  end  
end

describe MovieSearcher, "should still have the same people" do
  before(:all) do
    @movie = MovieSearcher.find_movie_by_id("tt0382932")
  end

  it "should have a name" do
    @movie.actors.map(&:name).should include('Patton Oswalt')
  end

  it "should have a role" do
    @movie.actors.map(&:role).should include('Remy')
  end

  it "should have a name" do
    @movie.directors.map(&:name).should include('Brad Bird')
  end

  it "should not have a role" do
    @movie.directors.first.role.should be_nil
  end

  it "should have a name" do
    @movie.writers.map(&:name).should include('Brad Bird')
  end

  it "should not have a role" do
    @movie.writers.first.role.should be_nil
  end
end