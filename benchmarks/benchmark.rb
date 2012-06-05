require 'benchmark'
require 'hashie'
require 'ostruct'
require_relative '../lib/blobject'


iterations = ARGV[0] || 1000000


class A # a foo-bar class the we'll use when benchmarking objects
  attr_accessor :member1
end


object   = A.new
blobject = Blobject.new
hash     = {}
hashie   = Hashie::Mash.new
ostruct  = OpenStruct.new

value = "data"



puts "\n\nITERATIONS: #{iterations}\n\n"
puts "\nBENCHMARK: assign\n=====================\n\n"



Benchmark.bm do |benchmark|

  benchmark.report("Object: ") do
    iterations.times do
      object.member1 = value
    end
  end

  benchmark.report("Hash: ") do
    iterations.times do
      hash[:member1] = value
    end
  end

  benchmark.report("Blobject: ") do
    iterations.times do
      blobject.member1 = value
    end
  end

  benchmark.report("Hashie: ") do
    iterations.times do
      hashie.member1 = value
    end
  end

  benchmark.report("OpenStruct: ") do
    iterations.times do
      ostruct.member1 = value
    end
  end
end



puts "\n\nBENCHMARK: read\n=====================\n\n"



Benchmark.bm do |benchmark|

  benchmark.report("Object: ") do
    iterations.times do
      value = object.member1
    end
  end

  benchmark.report("Hash: ") do
    iterations.times do
      value = hash[:member1]
    end
  end

  benchmark.report("Blobject: ") do
    iterations.times do
      value = blobject.member1
    end
  end

  benchmark.report("Hashie: ") do
    iterations.times do
      value = hashie.member1
    end
  end

  benchmark.report("OpenStruct: ") do
    iterations.times do
      value = ostruct.member1
    end
  end
end