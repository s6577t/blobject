# make sure we are using the latest minitest gem rather than the ruby distribution
# could also do this with gem 'minitest' but it's probably best to setup the bundle
# environment similar to running this with bundle exec.
require 'bundler'
Bundler.setup

$:.push 'lib'

require 'minitest/autorun'
require 'minitest/spec'

require 'minitest/reporters'

MiniTest::Unit.runner = MiniTest::SuiteRunner.new
MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new