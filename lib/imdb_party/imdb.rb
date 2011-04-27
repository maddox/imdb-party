module ImdbParty
  class Imdb
    include HTTParty
    include HTTParty::Icebox
    cache :store => 'file', :timeout => 120, :location => Dir.tmpdir
    
    base_uri 'app.imdb.com'
    default_params = {"api" => "v1", "appid" => "iphone1_1", "apiPolicy" => "app1_1", "apiKey" => "2wex6aeu6a8q9e49k7sfvufd6rhh0n", "locale" => "en_US", "timestamp" => Time.now.to_i, "sig" => "heres my signature"}

    def initialize(options={})
      self.class.base_uri 'http://anonymouse.org/cgi-bin/anon-www.cgi/http://app.imdb.com' if options[:anonymize]
    end
    
    def find_by_title(title)
      movie_results = []
      results = self.class.get('/find', :query => {:q => title}).parsed_response
      
      if results["data"] && results["data"]["results"]
        results["data"]["results"].each do |result_section|
          result_section["list"].each do |r|
            next unless r["tconst"] && r["title"]
            h = {:title => r["title"], :year => r["year"], :imdb_id => r["tconst"], :kind => r["type"]}
            h.merge!(:poster_url => r["image"]["url"]) if r["image"] && r["image"]["url"]
            movie_results << h
          end
        end
      end
      
      movie_results
    end

    def find_movie_by_id(imdb_id)
      result = self.class.get('/title/maindetails', :query => {:tconst => imdb_id}).parsed_response
      Movie.new(result["data"])
    end
    
    def top_250
      results = self.class.get('/chart/top').parsed_response
      results["data"]["list"]["list"].map { |r| {:title => r["title"], :imdb_id => r["tconst"], :year => r["year"], :poster_url => (r["image"] ? r["image"]["url"] : nil)} }
    end

    def popular_shows
      results = self.class.get('/chart/tv').parsed_response
      results["data"]["list"].map { |r| {:title => r["title"], :imdb_id => r["tconst"], :year => r["year"], :poster_url => (r["image"] ? r["image"]["url"] : nil)} }
    end
    
  end
end
