require 'spec/env'
require 'blobject'

describe Blobject do

  def b
    @b ||= Blobject.new
  end

  it 'raises an error if the call is not a reader, writer or checker' do

    proc do
      b.fish_for :salmon, :sole
    end.must_raise NoMethodError

    proc do
      b.checker_with_an_arg? :this_should_not_be_here
    end.must_raise NoMethodError

  end

  it 'provides access tot he internal hash with #hash' do
    assert b.hash.equal?(b.instance_variable_get :@hash)
  end

  it 'sets values when calling a writer' do
    b.number = 123
    assert_equal b.number, 123
  end

  it 'sets objects n levels deep' do
    b.name.nickname.back_at_school = 'Richard Head'
    assert_equal b.name.nickname.back_at_school, 'Richard Head'
  end

  it 'does not result in a graph containing empty blobjects' do
    b.fish.food
    assert !b.fish?, 'should not have assigned an empty blobject'
  end

  it 'turns hashes into blobjects when assigning' do
    
    b.name = { christian: "Vinnie", surname: "Jones" }
    
    assert_instance_of Blobject, b.name
    assert_equal b.name.christian, "Vinnie"
    assert_equal b.name.surname,   "Jones"
  end

  it 'can indicate whether it is empty' do
    b = Blobject.new
    b.must_be :empty?
    b.name = "something"
    b.wont_be :empty?
  end

  describe 'hash-like access' do

    it 'allows hash-style setters' do
      
      b[:foo]  = 123
      b['bar'] = 456
      
      assert_equal "#{b.foo}#{b.bar}", '123456'
    end

    it 'allows hash-style getters' do
      
      b.name = "Jimmy"
      
      assert_equal b[:name] , "Jimmy"
      assert_equal b['name'], "Jimmy"
    end
  end

  describe 'respond_to?' do
    
    it 'returns true if the blobject has the corresponding member' do
      b.name = 'jim'
      assert b.respond_to?(:name)
      assert b.respond_to?(:name=)
      assert b.respond_to?(:name?)
    end

    it 'should return true if a prohibited attribute name is a defined method' do
      def b.to_ary
        123
      end
      assert b.respond_to? :to_ary
    end

    it 'should return false if the methods ends with a !' do
      refute b.respond_to? :hello!
    end

    it 'returns true if the blobject has no corresponding member' do
      b.name = 'jim'
      assert b.respond_to?(:name)
      assert b.respond_to?(:name=)
      assert b.respond_to?(:name?)
    end

    it 'should return true if the blobject has the corresponding member but the accessor has not been memoized' do
      b = Blobject.new :name => 'barry'
      assert b.respond_to?(:name)
      assert b.respond_to?(:name=)
      assert b.respond_to?(:name?)
    end

    it 'returns false for :to_ary because that method is not allowed' do
      refute Blobject.new.respond_to? :to_ary
    end
  end

  describe 'to_hash' do

    it 'should recursively reify the blobject into a hash' do
      b.name.first = 'barry'
      b.number = 123456

      h = b.to_hash

      assert_instance_of Hash, h
      assert_instance_of Hash, h[:name]
      assert_equal h[:number], 123456
      assert_equal h[:name][:first], 'barry'
    end
  end

  describe 'from_json' do
    
    describe 'array' do
      
      it 'returns an array with blobjects not hashes' do
        json = '[1, true, {"meaning": false}]'
        array = Blobject.from_json json

        assert_instance_of Array, array
        assert_equal array[0], 1
        assert_equal array[1], true
        assert_instance_of Blobject, array[2]
      end
    end

    describe 'json object' do
      
      it 'returns a blobject which' do
        json = '{"name": {"first": "doogle"}}'
        b = Blobject.from_json json
        assert_equal b.name.first, 'doogle'
        assert b.name?

      end
    end
  end

  describe 'initialize' do
    it 'takes an initial value as a hash' do
      b = Blobject.new :inner => {:nested => :hash}, :value => 12345
      assert_equal b.value, 12345
      assert b.inner?
      assert_equal b.inner.nested, :hash
    end

    it 'recurses through the initial hash turning hashes into blobjects' do
      b = Blobject.new :name => {:first => 'doogle', :last => 'mcfoogle'}
      assert_instance_of Blobject, b.name
      assert_equal b.name.first, 'doogle'
    end

    it 'yields to a block with self as a parameter' do
      b = Blobject.new do |b|
        b.name = 'yield'
      end

      assert_equal 'yield', b.name
    end
  end

  describe 'checking' do

    it 'returns true if the attribute exists' do
      b.fish = 'bass'
      assert b.fish?
    end

    it 'returns false if the attribute does not exist' do
      assert !b.fish?
    end

    it 'does not indicate the boolean status of the value' do
      b.fish = false
      assert b.fish?
    end
  end

  describe 'memoization' do

    it 'creates checker, reader and writer memoize methods after they are called the first time' do

      b.method_unlikely_already_to_be_defined = 123

      b.methods.must_include :method_unlikely_already_to_be_defined
      b.methods.must_include :method_unlikely_already_to_be_defined=
      b.methods.must_include :method_unlikely_already_to_be_defined?

      b.another_method_unlikely_already_to_be_defined

      b.methods.must_include :another_method_unlikely_already_to_be_defined
      b.methods.must_include :another_method_unlikely_already_to_be_defined=
      b.methods.must_include :another_method_unlikely_already_to_be_defined?

      b.yet_another_method_unlikely_already_to_be_defined?

      b.methods.must_include :another_method_unlikely_already_to_be_defined
      b.methods.must_include :another_method_unlikely_already_to_be_defined=
      b.methods.must_include :another_method_unlikely_already_to_be_defined?
    end

    it 'does not redefine existing members' do

      def b.hello
        123
      end

      b.hello=456

      assert_equal 123, b.hello

      def b.oink= v
        @oink = v
      end

      b.oink = 123

      b.hash[:oink] = 456

      def b.oink_value
        @oink
      end

      assert_equal 123, b.oink_value

    end

    describe 'memoized reader' do
      it 'returns an empty blobject' do

        b.name.first = 'Harry'

        b = Blobject.new

        assert !b.name.nil?

        b.name.first = 'Barry'

        assert_equal b.name.first, 'Barry'
      end
    end
  end

  describe 'frozen blobject' do

    before :each do
      list_element = Blobject.new

      b.name.first = 'barry'
      b.data.list = [1, 2, 3, list_element]
      b.data.inner_hash = {:inner => {:one => 1}}

      b.freeze
    end

    it 'still provides access' do
      refute_nil b.name.first
    end

    it 'freezes the internal hash' do
      assert b.hash.frozen?
    end

    it 'allows access to existing attributes' do
      assert_equal b.name.first, 'barry'
    end

    it 'recursively freezes nested Blobjects' do
      assert b.frozen?
      assert b.name.frozen?
      assert b.data.list[3].frozen?
      assert b.data.inner_hash.frozen?
    end

    it 'raises an error when trying to set an attribute' do
      proc { b.hello = 123 }.must_raise RuntimeError
    end

    it 'still returns a blobject when trying to get an attribute' do
      b.meow_face.must_be_instance_of Blobject
      # check again to test memoized method
      b.meow_face.must_be_instance_of Blobject
    end
  end
end