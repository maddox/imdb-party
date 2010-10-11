module ImdbParty
  class Movie
    attr_accessor :imdb_id, :title, :directors, :writers, :tagline, :company, :plot, :runtime, :rating, :poster_url, :release_date, :certification, :genres, :actors, :trailers

    def initialize(options={})
      @imdb_id = options["tconst"]
      @title = options["title"]
      @tagline = options["tagline"]
      @plot = options["plot"]["outline"] if options["plot"]
      @runtime = "#{(options["runtime"]["time"]/60).to_i} min" if options["runtime"]
      @rating = options["rating"]
      @poster_url = options["image"]["url"] if options["image"]
      @release_date = options["release_date"]["normal"] if options["release_date"] && options["release_date"]["normal"]
      @certification = options["certificate"]["certificate"] if options["certificate"] && options["certificate"]["certificate"]
      @genres = options["genres"] || []

      # parse directors
      @directors = []
      options["directors_summary"].each do |d|
        @directors << d["name"]["name"] if d["name"] && d["name"]["name"]
      end

      # parse directors
      @writers = []
      options["writers_summary"].each do |w|
        @writers << w["name"]["name"] if w["name"] && w["name"]["name"]
      end

      # parse directors
      @actors = []
      options["cast_summary"].each do |a|
        @actors << a["name"]["name"] if a["name"] && a["name"]["name"]
      end

      #parse trailers
      @trailers = {}
      if options["trailer"]["encodings"] && options["trailer"]
        options["trailer"]["encodings"].each_pair do |k,v|
          @trailers[v["format"]] = v["url"]
        end
      end
      
      
    end
    
  end
end