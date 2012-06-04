# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "blobject/version"

Gem::Specification.new do |s|
  s.name        = "blobject"
  s.version     = Blobject::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sam Taylor"]
  s.email       = ["sjltaylor@gmail.com"]
  s.homepage    = "https://github.com/sjltaylor/blobject"
  s.summary     = %q{serializable object builder}
  s.description = %q{Blobject provides a free flowing syntax for creating blobs of data.}

  s.rubyforge_project = "blobject"
  
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'debugger'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
