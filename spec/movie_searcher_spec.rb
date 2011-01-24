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
    MovieSearcher.find("asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd asd").should be_nil
  end
  
  it "should return nil when setting the limit to low" do
    MovieSearcher.find('Paranormal Activity 2 2010 UNRATED DVDRip XviD-Larceny', :options => {:limit => 0}).should be_nil
  end
  
  it "should return the right movie" do
    [{
      :title => "Live Free Or Die Hard 2007 DVDRIP XviD-CRNTV", :iid => "tt0337978"
    }, {
      :title => "The Chronicles of Narnia - The Voyage of the Dawn Treader TS XViD - FLAWL3SS", :iid => "tt0980970"
    }, {
      :title => "Heartbreaker 2010 LIMITED DVDRip XviD-SUBMERGE", :iid => "tt1465487"
    },{
      :title => "Paranormal Activity 2 2010 UNRATED DVDRip XviD-Larceny", :iid => "tt1536044"
    }].each do |movie|
      MovieSearcher.find(movie[:title]).imdb_id.should eq(movie[:iid])
    end
  end
  
  it "should return nil if no value is being passed to it" do
    MovieSearcher.find("").should be_nil
  end
  
  it "should return nil if nil is being passed to it" do
    MovieSearcher.find(nil).should be_nil
  end
  

end