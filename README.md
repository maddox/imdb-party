# ImdbParty!

## How To Use

### Create an instance

    imdb = ImdbParty::Imdb.new
    imdb = ImdbParty::Imdb.new(:anonymize => true) # this will anonymize your requests to prevent getting your ip banned


### Search for a movie by title

    imdb.find_by_title("The Dark Knight") => [{:title => "The Dark Knight", :year => "2008", :imdb_id => "tt0468569"}, {:title => "Batman Unmasked", ...}]

### Get a movie by its imdb_id

    movie = imdb.find_movie_by_id("tt0468569")

    movie.title => "The Dark Knight"
    movie.rating => 8.1
    movie.certification => "PG-13"

### Get a movie trailer poster
    
    movie = imdb.find_movie_by_id("tt1210166")

    movie.trailer_url => "http://ia.media-imdb.com/images/M/MV5BODM1NDMxMTI3M15BMl5BanBnXkFtZTcwMDAzODY1Ng@@._V1_.jpg"

### Find the top 250 movies of all time

    imdb.top_250 => [{:title => "Shawshank Redemption", :year => "1994", :imdb_id => "tt0111161"}, {:title => "The Godfather", ...}]

### Get the currently popular tv shows

    imdb.popular_shows => [{:title => "Glee", :year => "2009", :imdb_id => "tt1327801"}, {:title => "Dexter", ...}]

## Running the tests

### Install dependencies

    gem install jeweler
    gem install shoulda
    gem install httparty

### Run the tests

    rake test
