# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "movie_searcher"
  s.version     = "0.0.3"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Linus Oleander", "Jon Maddox"]
  s.email       = ["linus@oleander.nu", "jon@mustacheinc.com"]
  s.homepage    = "http://github.com/oleander/MovieSearcher"
  s.summary     = %q{IMDB client using the IMDB API that their iPhone app uses}
  s.description = %q{IMDB client using the IMDB API that their iPhone app uses. It can also figure out what movie you are looking for just by looking at the release name of the movie}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('httparty')
  s.add_dependency('levenshtein')
  s.add_development_dependency('rspec')
end