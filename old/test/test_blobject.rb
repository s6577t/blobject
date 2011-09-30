require 'helper'

class TestBlobject < Test::Unit::TestCase
  should "not be empty? if the blobject has data" do
    b = Blobject.new
    b.data = 'LOOK! some data. :)'
    assert !b.empty?
  end
  
  should "not be empty if the blobject complex with real data" do
    b = Blobject.new
    b.colors.red = '#ff0000'
    assert !b.empty?
  end
  
  should 'report empty when there are no descendants' do
    assert Blobject.new.empty?
  end
  
  should 'report empty? as true when descendants are empty Hash, Array or Blobjects' do
    b = Blobject.new
    b.array = []
    b.hash = {}
    b.blobject = Blobject.new
    assert b.empty?
  end
  
  should 'report empty? as false when descendants include a non-empty Array' do
    b = Blobject.new
    b.array = [1,2,3,4,5]
    assert !b.empty?
  end
  
  should 'report empty? as false when descendants include a non-empty Hash' do
    b = Blobject.new
    b.hash = {:key1 => 1, :key2 =>2, :key3 => 3}
    assert !b.empty?
  end
  
  should 'report empty? as false when descendants include a non-empty Blobject' do
    b = Blobject.new
    b.blobject = Blobject.new :initial_data => [1,2,3]
    assert !b.empty?
  end
end
