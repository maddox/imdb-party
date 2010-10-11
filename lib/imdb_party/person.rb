module ImdbParty
  class Person
    attr_accessor :name, :role, :imdb_id
    
    def initialize(options={})
      @name = options["name"]["name"]
      @imdb_id = options["name"]["nconst"]
      
      @role = options["char"] if options["char"]
    end
    
  end
end
