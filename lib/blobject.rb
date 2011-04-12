Dir["#{File.dirname __FILE__}/blobject/*.rb"].each {|file| require "#{file}" }        

def blobject *parameters, &block
  Blobject.new *parameters, &block
end

# similar to OpenStruct
# b.foo.bar = 8 automatically creates a blobject called "foo" on "b"
# to check whether a variable is defined use the '?' syntax i.e: b.is_it_here? => nil, b.foo? == b.foo
# calling an unassigned member returns a new blobject unless the blobject is frozen
# a frozen blobject cannot be assigned new members or populated from a hash 
# does no cycle checking, intended for use in serialization
class Blobject
  class AssignToFrozenBlobjectException < Exception; end
  
public
  
  def frozen?
    @blobject_frozen == true
  end
  
  def freeze
    @blobject_frozen = true
    self
  end
  def unfreeze
    @blobject_frozen = false
    self
  end
  def defrost
    unfreeze
  end
  
  def initialize hash_of_initial_values_or_an_object={}, array_of_methods_to_copy_data_from_object=[]
     @values = {}
     
     if (hash_of_initial_values_or_an_object.class == Hash)
       merge_hash hash_of_initial_values_or_an_object
     else
       array_of_methods_to_copy_data_from_object.each do |accessor|
         @values[accessor.to_s] = hash_of_initial_values_or_an_object.send accessor
       end
     end     
     
     if block_given?
       yield self
     end 
     self
  end
  
  def method_missing(sym, *args, &block)
    
    str = sym.to_s
    
    assignment = /.*(?=\=$)/.match str
    question = /.*(?=\?$)/.match str
    
    if question
      !@values[question.to_s].nil?
    elsif assignment
      raise AssignToFrozenBlobjectException if @blobject_frozen
      @values[assignment.to_s] = args[0]
    else
      # return the value or a new blobject
      value = @values[str]
      
      return value unless value.nil?
      return nil if frozen?
      @values[str] = Blobject.new
      return @values[str]      
    end
  end
  
  def merge_hash hash
    raise "cannot populate a frozen blobject" if @blobject_frozen
    
    hash.each do |key, value|
      
      if value.class==Hash
        value = Blobject.new value
      end
      
      if value.class==Array
        value = Blobject.blobjectify_array value
      end
      
      @values[key.to_s] = value
    end 
    self
  end  
  
  def to_hash
    h = {}
    @values.each do |key, value|
      if value.class==Blobject
        h[key] = value.to_hash
      elsif value.class==Array
        h[key] = Blobject.deblobjectify_array value
      else
        h[key] = value
      end
    end
    h
  end
  
  # builds a hash for json conversion
  def as_json *ps
    to_hash
  end
  
  def self.from_json json, freeze=true
    h = ActiveSupport::JSON.decode(json)
    if h.class==Hash
      b = Blobject.new h 
      b.freeze if freeze
      return b
    elsif h.class==Array
      return blobjectify_array h
    else
      return h
    end
  end  
  
  def self.blobjectify_array array
    array.map do |e|
      if e.class==Hash
        Blobject.new(e) 
      elsif e.class==Array
        blobjectify_array(e)
      else
        e
      end
    end
  end
  
  def self.deblobjectify_array array
    array.map do |e|
      if e.class==Blobject
        e.to_hash 
      elsif e.class==Array
        deblobjectify_array(e)
      else
        e
      end
    end
  end
  
  def [] key
    @values[key]
  end
  
  def []= key, value
    @values[key] = value
  end
  
  def blank?
    empty?
  end
  
  def empty?
    @values.empty? || @values.values.empty? || !@values.values.any? do |v|
      # if the value is a Blobject, Hash or Array return
      # true if it is not empty.
      # else just return true, the value is regarded as not empty.
      if [Blobject, Array, Hash].include?(v.class) 
        !v.empty?
      else
        true
      end
    end
  end

end
