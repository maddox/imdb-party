# ImdbParty!

## How To Use

    imdb = ImdbParty::Imdb.new
    imdb.find_movie_by_title("The Dark Knight") => [{:title => "The Dark Knight", :year => "2008", :imdb_id => "tt0468569"}, {:title => "Batman Unmasked", ...}]