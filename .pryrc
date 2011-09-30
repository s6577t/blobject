$:.push File.expand_path('../lib', __FILE__)
require 'ruby-debug'
require 'blobject'

def reload!
  load 'blobject.rb'
end