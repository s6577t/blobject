require 'blobject/version'
require 'json'

def blobject *parameters, &block
  Blobject.new *parameters, &block
end

class Blobject
  
  def initialize hash = {}, &block
    @hash = {}
    merge hash
    
    @modifying = false
    self.modify &block if block_given?
  end
  
  def modify &block
    
    __r_modify_set__ true
    
    exception = nil
    
    begin
      self.instance_eval &block
    rescue Exception => e
      exception = e
    end
    
    __r_modify_set__ false
    
    raise exception unless exception.nil?
    return self
  end
  
  def method_missing sym, *params, &block
    
    if match = /^has_(.+)\?/.match(sym)
      return @hash.has_key? match[1].to_sym
    end
    
    if @modifying
      
      case params.length
      when 0 # get
        return @hash[sym] if @hash.has_key? sym
        
        child = Blobject.new
        parent = self
        
        child.__r_modify_set__ true
        
        store_in_parent = lambda {
          
          parent_hash = parent.instance_variable_get '@hash'
          parent_hash[sym] = child

          parent_store_in_parent = parent.instance_variable_get :@__store_in_parent__
          parent_store_in_parent.call unless parent_store_in_parent.nil?
          
          child.method(:remove_instance_variable).call(:@__store_in_parent__)
        }
        
        child.instance_variable_set :@__store_in_parent__, store_in_parent
        
        return block_given? ? child.modify(&block) : child
      when 1 # set
        @hash[sym] = params[0]
        
        store_in_parent = @__store_in_parent__
        store_in_parent.call unless store_in_parent.nil?
        
        return self
      end 
    else
      return @hash[sym] if @hash.has_key? sym
    end
    
    super
  end
  
  def merge hash
    
    hash.each do |key, value|
      @hash[key.to_s.to_sym] = self.class.__blobjectify__ value
    end 
    
    self
  end
  
  def empty?
    @hash.empty?
  end
  
  def [] key
    @hash[key.to_s.to_sym]
  end
  
  def keys
    @hash.keys
  end
  
  def values
    @hash.values
  end
  
  def each &block
    return @hash.each &block
  end
  
  def []= key, value
    send key, value
  end
  
  def dup
    Marshal.load(Marshal.dump(self))
  end
  
  def to_hash
    hash = @hash
    
    hash.each do |key, value|
      hash[key] = value.to_hash if (value.instance_of? Blobject)
      
      if value.instance_of? Array
        hash[key] = value.map do |v|
          v.instance_of?(Blobject) ? v.to_hash : v
        end
      end
    end
    
    hash
  end
  
  def from_hash hash
    Blobject.new hash
  end
  
  def to_yaml *params
    to_hash.to_yaml *params
  end
  
  def self.from_yaml yaml
    __blobjectify__ YAML.load(yaml)
  end
  
  def to_json *params
    @hash.to_json *params
  end
  
  def self.from_json json
    __blobjectify__ JSON.load(json)
  end
  
  def self.read path
    case File.extname(path).downcase
    when /\.y(a)?ml$/
      from_yaml File.read(path)
    when /\.js(on)?$/
      from_json File.read(path)
    else
      raise "Cannot handle file format of #{path}"
    end
  end
  
  def dup
    Blobject.new to_hash
  end
  
  def inspect
    @hash.inspect
  end

protected
  
  def self.__blobjectify__ obj
    
    if obj.instance_of?(Hash)
      
      obj.each do |key, value|
        obj[key] = __blobjectify__ value
      end
      
      return self.new obj
    end
    
    if obj.instance_of?(Array)
      return obj.map do |e|
        __blobjectify__ e
      end
    end
    
    obj
  end 
  
  def __r_modify_set__ v
    @modifying = v
    @hash.values.each do |child|
      if child.class <= Blobject
        child.__r_modify_set__ v
      end
    end
  end
end