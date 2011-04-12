# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "blobject/version"

Gem::Specification.new do |s|
  s.name        = "blobject"
  s.version     = Blobject::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sam Taylor"]
  s.email       = ["sjltaylor@gmail.com"]
  s.homepage    = "http://sjltaylor.com"
  s.summary     = %q{fluent serializable object builder}
  #s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "blobject"
  
  s.add_dependency 'wirble'
  s.add_dependency 'shoulda'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
