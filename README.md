# MovieSearcher - the almighty movie search gem

## What is MovieSearcher

MovieSearcher makes it possible to get information about a movie.
It uses IMDB's API that their iPhone applications rely on.

It's build on top of [maddox's](https://github.com/maddox) [imdb-party](https://github.com/maddox/imdb-party) but adds some extra functionality and bugs fixes.

## What makes this gem so awesome?
MovieSearcher has a really cool feature called `find_by_release_name` that makes it possible to search for a movie based on the release name.
You can for example specify *Heartbreaker 2010 LIMITED DVDRip XviD-SUBMERGE* and it will return the not to good (Heartbreaker)[http://www.imdb.com/title/tt1465487/] by (Pascal Chaumeil)[http://www.imdb.com/name/nm0154312/]

## So how do I use it?

### Start by installing the gem

    sudo gem install movie_searcher
Start `irb` and include the gem, `require 'movie_searcher'`

### Search for a movie by title

    $ MovieSearcher.find_by_title("The Dark Knight")
    => [#<ImdbParty::Movie:0x1012a5858 @imdb_id="tt0468569", @year="2008", @title="The Dark Knight" ... >, ...]

### Get a movie by its imdb id

    $ movie = MovieSearcher.find_movie_by_id("tt0468569")
    $ movie.title 
    => "The Dark Knight"
    $ movie.rating 
    => 8.9
    $ movie.certification 
    => "PG-13"

### Find the top 250 movies of all time

    $ MovieSearcher.top_250 
    => [#<ImdbParty::Movie:0x10178ef68 @imdb_id="tt0111161", @poster_url="http://ia.media-imdb.com/images/M/MV5BMTM2NjEyNzk2OF5BMl5BanBnXkFtZTcwNjcxNjUyMQ@@._V1_.jpg" ... >, ...]

### Get the currently popular tv shows

    $ MovieSearcher.popular_shows 
    => [#<ImdbParty::Movie:0x101ff2858 @imdb_id="tt1327801", @poster_url="http://ia.media-imdb.com/images/M/MV5BMTYxMjYxNjQxNl5BMl5BanBnXkFtZTcwNTU5Nzk4Mw@@._V1_.jpg", @year="2009", @title="Glee">, ... ]
    
### Search for a release name
    $ MovieSearcher.find_by_release_name("Heartbreaker 2010 LIMITED DVDRip XviD-SUBMERGE").imdb_id 
    => tt1465487
    
## This sounds supr, how do I help?

- Start by copying the project or make your own branch.
- Navigate to the root path of the project and run `bundle`.
- Start by running all tests using rspec, `rspec spec/movie_searcher_spec.rb`.
- Implement your own code, write some tests, commit and do a pull request.

## Requirements

The gem is tested in OS X 10.6.6 using Ruby 1.8.7.