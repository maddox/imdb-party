# MovieSearcher - *the almighty movie search gem*

## What is MovieSearcher

MovieSearcher makes it possible to get information about a movie.
It uses IMDB's API that their iPhone applications rely on.

It's build on top of [maddox's](https://github.com/maddox) [imdb-party](https://github.com/maddox/imdb-party) but adds some extra functionality and bugs fixes.

## What makes this gem so awesome?

MovieSearcher has a really cool feature (*method*) called `find_by_release_name` that makes it possible to search for a movie based on the release name.
You can for example specify ***Heartbreaker 2010 LIMITED DVDRip XviD-SUBMERGE*** and it will return the not to good [*Heartbreaker*](http://www.imdb.com/title/tt1465487/) by [*Pascal Chaumeil*](http://www.imdb.com/name/nm0154312/)

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
    
### Find a movie based on the release name
    
    $ MovieSearcher.find_by_release_name("Heartbreaker 2010 LIMITED DVDRip XviD-SUBMERGE").imdb_id 
    => tt1465487
    
### Find a movie based on a folder
    
    $ MovieSearcher.find_by_folder('~/Downloads/Its.Kind.of.a.Funny.Story.2010.DVDRip.XviD-AMIABLE')
    => #<ImdbParty::Movie:0x10198a060 ... >
    
### Find a movie based on a file containing and imdb link
  
  This method does not take any folder that starts with tilde **~** sign.
  
    $ MovieSearcher.find_by_file('/Users/linus/Downloads/Its.Kind.of.a.Funny.Story.2010.DVDRip.XviD-AMIABLE/its.kind.of.a.funny.story.2010.dvdrip.xvid-amiable.nfo')
    => #<ImdbParty::Movie:0x10198a060 ... >
    
### Find a movie based on a downloaded thingy (folder or file)

This method takes anything that you have download and tries to figure out what movie you're talking about.
If a folder is passed it will list all text files in the folder and try to find an imdb link.
If no link or no files are found, it will fall back on the name of the folder.
    
    $ MovieSearcher.find_by_download('/Users/linus/Downloads/some_thing_unknown')
    => #<ImdbParty::Movie:0x10198a060 ... >

### Find the top 250 movies of all time

    $ MovieSearcher.top_250 
    => [#<ImdbParty::Movie:0x10178ef68 @imdb_id="tt0111161", @poster_url="http://ia.media-imdb.com/images/M/MV5BMTM2NjEyNzk2OF5BMl5BanBnXkFtZTcwNjcxNjUyMQ@@._V1_.jpg" ... >, ...]

### Get the currently popular tv shows

    $ MovieSearcher.popular_shows 
    => [#<ImdbParty::Movie:0x101ff2858 @imdb_id="tt1327801", @poster_url="http://ia.media-imdb.com/images/M/MV5BMTYxMjYxNjQxNl5BMl5BanBnXkFtZTcwNTU5Nzk4Mw@@._V1_.jpg", @year="2009", @title="Glee">, ... ]
    
### Some configure alternatives

You can pass some options to the `find_by_release_name` method to specify how it should behave.

Here is an example.

    $ MovieSearcher.find_by_release_name("Heartbreaker 2010 LIMITED DVDRip XviD-SUBMERGE", :options => {:limit => 0.1, :details => true}) 

- ** :limit ** (Float) It defines how sensitive the parsing algorithm should be. Where 0.0 is super sensitive and 1.0 is don't care. The default value is 0.4 and workes in most cases. If you dont get any hits at all, try a large value.
- ** :details ** (Boolean) By default, the `find_by_release_name` only returns the most basic information about a movie, like *imdb_id*, *title* and *year*. If you set this to true, it will do another request to IMDB and get the casts, actors, rating and so on.

** The option param can't be passed to `find_by_title` **

** `find_movie_by_id` don't require that you pass the `:details` option to get all data **

## What is being returned?

The `find_by_title` method returns an `Array` of `ImdbParty::Movie` objects.

These are the accessors of `ImdbParty::Movie`

- **imdb_id** (String) The imdb id of the movie.
- **title** (String) The title of the movie.
- **directors** (Array) Related directors.
- **writers** (Array) Related writers.
- **tagline** (String) The movie tagline.
- **company** (String) Company who made the movie.
- **runtime** (String) The length of the movie, `120 min` for example.
- **rating** (Float) The movie rating, from 0 to 10.
- **poster_url** (String) Movie poster. **Beaware**, this image might expire. Use [tmdb_party](https://github.com/jduff/tmdb_party) if you want posters and images.
- **release_date** (Date) The release date of the movie.
- **certification** (String) The certification of the movie, *R* for example.
- **genres** (Array) The most relevant generes for the movie.
- **actors** (Array) Related actors.
- **trailers** (Hash) Related trailers. The key defines the quality of the trailer, like `H.264 480x360` and the value specify the url.

The `actors`, `writers` and `directors` accessors returns an `ImdbParty::Person` object that has the following accessors.

- **imdb_id** (String) The imdb id of the person.
- **role** (String) What role did the actor have in the movie. This is only set when working with an actor.
- **name** (String) The actual name of the actor.

## This sounds supr, how do I help?

- Start by copying the project or make your own branch.
- Navigate to the root path of the project and run `bundle`.
- Start by running all tests using rspec, `rspec spec/movie_searcher_spec.rb`.
- Implement your own code, write some tests, commit and do a pull request.

## Requirements

The gem is tested in OS X 10.6.6 using Ruby 1.8.7 and 1.9.2