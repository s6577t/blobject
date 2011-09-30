require 'spec_helper'
require 'blobject'

describe Blobject do
  
  let(:blobject){Blobject.new}
  
  it 'should not be able to assign to a blobject outside of a modify block using =' do
    expect {
      blobject.name = 'hello'
     
    }.to raise_error
  end
  
  it 'should not be able to assign to a blobject outside of a modify block without =' do
    expect {
      blobject.name 'hello'
    }.to raise_error
  end  
    
  it 'should raise an error when call members that have not been assign' do
    
    expect {
      blobject.meow
    }.to raise_error(NoMethodError)
  end
  
  describe '#empty?' do
    it 'should return true on an empty blobject' do
      blobject.should be_empty
    end
    
    it 'should return false on an non-empty blobject' do
      blobject.modify { name "Barry" }
      blobject.should_not be_empty
    end
  end
  
  describe '#modify' do
    
    it 'should store assignment of variables to any depth in the object graph' do
      
      b = blobject.modify do
        variable 'hello'
        deep.object.graph.member 123
      end
      
      blobject.variable.should == 'hello'
      blobject.deep.object.graph.member.should == 123
    end
    
    it 'should not handle more than one parameter' do
      expect {
        blobject.modify do
          name(1, 2)
        end
      }.to raise_error(NoMethodError)
    end
    
    it 'should return an empty blobject when a non-existing member is called' do
      blobject.modify do
        b = name
        name.should be_instance_of Blobject
        name.should be_empty
      end
    end
    
    it 'should allow assignment chaining' do
      blobject.modify do
        name.first('Barry').last('Watkins')
      end
      
      blobject.name.first.should == 'Barry'
      blobject.name.last.should == 'Watkins'
    end
  
    it 'should return self' do
      rtn = blobject.modify {}
      rtn.should equal blobject
    end
    
    it 'should allow for nested modification blocks' do
      
      blobject.modify do
        name do
          first 'barry'
          last 'mcdoodle'
        end
      end
      
      blobject.name.first.should == 'barry'
      blobject.name.last.should == 'mcdoodle'
      
    end
  end

  describe '#has_<name>' do
    
    it 'should return true when we have a member of name' do
      blobject.modify {name 'barry'}
      blobject.should have_name
    end
    
    it 'should return false otherwise' do
      blobject.should_not have_name
    end
  end
  
  describe '#[]' do
    it 'allows get via hash like dereferencing' do
      blobject.modify {name 'rod'}
      blobject[:name].should == 'rod'
    end
    
    it 'nil should be returned for a key miss' do
      blobject[:name].should == nil
    end
  end
  
  describe '#[]=' do
    it 'should relay to send' do
      blobject.should_receive(:send).with(:name, 'barry')
      blobject[:name] = 'barry'
    end
  end

  describe '#merge' do
    let(:data) do
      { :one => 1,
        :rest => [2,3,4,5,6,{:number => 7},8,9,0],
        :nested => {
          :structure => 'of values'
        } }
    end
    
    it 'should return self' do
      blobject.merge({}).should equal blobject
    end
    
    it 'should populate itself with the hash' do
      blobject.merge data

      blobject.one.should == 1
      blobject.rest[5].should be_instance_of(Blobject)
      blobject.rest[5].number.should == 7
      blobject.nested.structure.should == 'of values'
    end
  end

end
