require 'bundler'
Bundler.setup

$:.push 'lib', 'spec'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/reporters'

Minitest::Reporters.use!
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'pry'
