require 'spec_helper'
require 'blobject'

describe Blobject do
  
  let(:blobject){Blobject.new}
  
  describe 'should not be able to assign to a blobject' do
    expect {
      blobject.name = 'hello'
    }.to raise_error
  end
  
  describe '#modify' do
    
  end
end
