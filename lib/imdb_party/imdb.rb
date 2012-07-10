module ImdbParty
  class Imdb
    include HTTParty
    include HTTParty::Icebox
    cache :store => 'file', :timeout => 120, :location => Dir.tmpdir

    base_uri 'app.imdb.com'
    format :json

    def initialize(options={})
      self.class.base_uri 'anonymouse.org/cgi-bin/anon-www.cgi/https://app.imdb.com' if options[:anonymize]
    end

    def build_url(path, params={})
      default_params = {"api" => "v1", "appid" => "iphone1_1", "apiPolicy" => "app1_1", "apiKey" => "2wex6aeu6a8q9e49k7sfvufd6rhh0n", "locale" => "en_US", "timestamp" => Time.now.to_i}

      query_params = default_params.merge(params)
      query_param_array = []

      base_uri = URI.parse(self.class.base_uri)
      base_host = base_uri.host
      the_path = base_uri.path + path

      query_params.each_pair{|key, value| query_param_array << "#{key}=#{URI.escape(value.to_s)}" }
      uri = URI::HTTP.build(:scheme => 'https', :host => base_host, :path => the_path, :query => query_param_array.join("&"))

      query_param_array << "sig=app1-#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), default_params["apiKey"], uri.to_s)}"

      uri = URI::HTTP.build(:scheme => 'https', :host => base_host, :path => the_path, :query => query_param_array.join("&"))
      uri.to_s
    end

    def find_by_title(title)
      default_find_by_title_params = {"json" => "1", "nr" => 1, "tt" => "on", "q" => title}

      movie_results = []

      results = self.class.get("http://www.imdb.com/xml/find", :query => default_find_by_title_params).parsed_response

      keys = ["title_popular", "title_exact", "title_approx", "title_substring"]

      keys.each do |key|
        if results[key]
          results[key].each do |r|
            next unless r["id"] && r["title"]
            year = r["title_description"].match(/^(\d\d\d\d)/)
            h = {:title => r["title"], :year => year, :imdb_id => r["id"], :kind => r["key"]}
            movie_results << h
          end
      end


      end

      movie_results
    end

    def find_movie_by_id(imdb_id)
      url = build_url('/title/maindetails', :tconst => imdb_id)

      result = self.class.get(url).parsed_response
      Movie.new(result["data"])
    end

    def top_250
      url = build_url('/chart/top')

      results = self.class.get(url).parsed_response
      results["data"]["list"]["list"].map { |r| {:title => r["title"], :imdb_id => r["tconst"], :year => r["year"], :poster_url => (r["image"] ? r["image"]["url"] : nil)} }
    end

    def popular_shows
      url = build_url('/chart/tv')

      results = self.class.get(url).parsed_response
      results["data"]["list"].map { |r| {:title => r["title"], :imdb_id => r["tconst"], :year => r["year"], :poster_url => (r["image"] ? r["image"]["url"] : nil)} }
    end

  end
end
