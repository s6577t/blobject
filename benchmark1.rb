require 'benchmark'
require_relative 'lib/blobject'

class A
  attr_accessor :member1

  def member1=v
    $m1 ||=0
    $m1 += 1
    @member1 = v
  end
end

iterations = 100000

a = A.new
b = blobject
h = {}

value = "VALUE"

a.member1 = value
b.modify { member1 value }
h[:member1] = value

puts "\n\nITERATIONS: #{iterations}\n\n"
puts "\nBENCHMARK: attr_write\n=====================\n\n"

Benchmark.bm do |benchmark|

  benchmark.report("Object: ") do
    iterations.times do
      a.member1 = value
    end
  end

  benchmark.report("Hash: ") do
    iterations.times do
      h[:member1] = value
    end
  end

  benchmark.report("Blobject: ") do
    iterations.times do
      b.member1 = value
    end
  end
end

puts "\n\nBENCHMARK: attr_read\n=====================\n\n"

Benchmark.bm do |benchmark|

  benchmark.report("Object: ") do
    iterations.times do
      v = a.member1
    end
  end

  benchmark.report("Hash: ") do
    iterations.times do
      v = h[:member1]
    end
  end

  benchmark.report("Blobject: ") do
    iterations.times do
      v = b.member1
    end
  end
end