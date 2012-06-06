require 'json'
require 'yaml'
require_relative 'blobject/version'

class Blobject
  
  # filter :to_ary else Blobject#to_ary returns a
  # blobject which is not cool, especially if you are puts.
  ProhibitedNames = [:to_ary]

  module Error; end

  def initialize hash = {}

    @hash = hash

    @hash.keys.each do |key|
      unless key.class <= Symbol
        value = @hash.delete key
        key = key.to_sym
        @hash[key] = value
      end
    end

    __visit_subtree__ do |name, node|
      if node.class <= Hash
        @hash[name] = Blobject.new node
      end
    end

    yield self if block_given?
  end

  def inspect
    
    @hash.inspect
  end

  def hash
    
    @hash
  end

  def to_hash
    
    h = hash.dup
    __visit_subtree__ do |name, node|
      h[name] = node.to_hash if node.respond_to? :to_hash
    end
    h
  end

  # method_missing is only called the first time an attribute is used. successive calls use
  # memoized getters, setters and checkers
  def method_missing method, *params, &block

    __tag_and_raise__ NoMethodError.new(method) if ProhibitedNames.include?(method)

    case
    # assignment in conditionals is usually a bad smell, here it helps minimize regex matching
    when (name = method[/^\w+$/, 0]) && params.length == 0
      # the call is an attribute reader
      return nil if frozen? and not @hash.has_key?(method)

      self.class.send :__define_attribute__, name

      return send(method) if @hash.has_key? method

      parent          = self
      nested_blobject = self.class.new

      store_in_parent = lambda do
        parent.send "#{name}=", nested_blobject
        nested_blobject.send :remove_instance_variable, :@store_in_parent
      end

      nested_blobject.instance_variable_set :@store_in_parent, store_in_parent

      return nested_blobject

    when (name = method[/^(\w+)=$/, 1]) && params.length == 1
      # the call is an attribute writer

      self.class.send :__define_attribute__, name
      return send method, params.first

    when (name = method[/^(\w+)\?$/, 1]) && params.length == 0
      # the call is an attribute checker

      self.class.send :__define_attribute__, name
      return send method
    end

    super
  end

  def respond_to? method
    
    return true  if self.methods.include?(method)
    return false if ProhibitedNames.include?(method)

    method = method.to_s

    [/^(\w+)=$/, /^(\w+)\?$/, /^\w+$/].any? do |r|
      r.match(method)
    end
  end

  def == other
    return @hash == other.hash if other.class <= Blobject
    return @hash == other      if other.class <= Hash
    super
  end

  def [] name
    
    send name
  end

  def []= name, value
    
    send "#{name.to_s}=", value
  end
  
  def freeze
    __visit_subtree__ { |name, node| node.freeze }
    @hash.freeze
    super
  end

  def as_json *args
    return hash.as_json(*args) if hash.respond_to? :as_json
    to_hash
  end

  def to_json *args
    as_json.to_json *args
  end

  def as_yaml
    
    to_hash
  end

  def to_yaml
    
    as_yaml.to_yaml
  end

  def self.from_json json
    
    from_json!(json).freeze
  end

  def self.from_json! json
    
    __from_hash_or_array__(JSON.parse(json))
  end

  def self.from_yaml yaml
    
    from_yaml!(yaml).freeze
  end

  def self.from_yaml! yaml
    
    __from_hash_or_array__(YAML.load(yaml))
  end

private
# to avoid naming collisions private method names are prefixed and suffix with double unerscores (__)

  def __visit_subtree__ &block
    
    @hash.each do |name, node|

      if node.class <= Array
        node.flatten.each do |node_node|
          block.call(nil, node_node, &block)
        end
      end

      block.call name, node, &block
    end
  end

  # errors from this library can be handled with rescue Blobject::Error
  def __tag_and_raise__ e
    raise e
  rescue
    e.extend Blobject::Error
    raise e
  end

  class << self

  private

    def __from_hash_or_array__ hash_or_array

      if hash_or_array.class <= Array
        return hash_or_array.map do |e|
          if e.class <= Hash
             Blobject.new e
          else
            e
          end
        end
      end

      Blobject.new hash_or_array
    end

    def __define_attribute__ name

      __tag_and_raise__ NameError.new("invalid attribute name #{name}") unless name =~ /^\w+$/
      name = name.to_sym

      methods = self.instance_methods

      setter_name = (name.to_s + '=').to_sym
      unless methods.include? setter_name
        self.send :define_method, setter_name do |value|
          begin
            value = self.class.new(value) if value.class <= Hash
            @hash[name] = value
          rescue  ex
            __tag_and_raise__(ex)
          end
          @store_in_parent.call unless @store_in_parent.nil?
        end
      end

      unless methods.include? name
        self.send :define_method, name do

          value = @hash[name]

          if value.nil? && !frozen?
            value = self.class.new
            @hash[name] = value
          end

          value
        end
      end

      checker_name = (name.to_s + '?').to_sym
      unless methods.include? checker_name
        self.send :define_method, checker_name do
          @hash.key?(name)
        end
      end

      name
    end
  end
end