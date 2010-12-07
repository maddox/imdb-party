# ImdbParty!

## How To Use

### Create an instance

    imdb = ImdbParty::Imdb.new
### Search for a movie by title

    imdb.find_by_title("The Dark Knight") => [{:title => "The Dark Knight", :year => "2008", :imdb_id => "tt0468569"}, {:title => "Batman Unmasked", ...}]

### Get a movie by its imdb_id

    movie = imdb.find_movie_by_id("tt0468569")

    movie.title => "The Dark Knight"
    movie.rating => 8.1
    movie.certification => "PG-13"

### Find the top 250 movies of all time

    imdb.top_250 => [{:title => "Shawshank Redemption", :year => "1994", :imdb_id => "tt0111161"}, {:title => "The Godfather", ...}]

### Get the currently popular tv shows

    imdb.popular_shows => [{:title => "Glee", :year => "2009", :imdb_id => "tt1327801"}, {:title => "Dexter", ...}]
