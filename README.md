# ImdbParty!

## How To Use

    imdb = ImdbParty::Imdb.new
    imdb.find_movie_by_title("The Dark Knight") => [{:title => "The Dark Knight", :year => "2008", :imdb_id => "tt0468569"}, {:title => "Batman Unmasked", ...}]
    
    movie = imdb.find_movie_by_id("tt0468569")
    movie.title => "The Dark Knight"
    movie.rating => 8.1
    movie.certification => "PG-13"
    
    imdb.top_250 => [{:title => "Shawshank Redemption", :year => "1994", :imdb_id => "tt0111161"}, {:title => "The Godfather", ...}]

    imdb.top_shows => [{:title => "Glee", :year => "2009", :imdb_id => "tt1327801"}, {:title => "Dexter", ...}]
    