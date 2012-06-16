![](https://github.com/sjltaylor/blobject/raw/master/assets/blobject.png)
![](https://github.com/sjltaylor/blobject/raw/master/assets/blob_defn.png)

Getting started: `http://sjltaylor.com/blobject'

## About

Blobjects are *freeform* which means you can do this...

    data = Blobject.new

    data.name   = "Johnny"
    data.number = 316

like an `OpenStruct`, the members are not predefined attributes

unlike `OpenStruct`, `Blobject`s can be arbitrarily *complex* which means you can do this...

    data = Blobject.new
      => {}

    data.name.first   = "Johnny"
    data.name.surname = "Begood"
      => {:name=>{:first=>"Johnny", :surname=>"Begood"}}

    data.my.object.with.deep.nested.members = "happy place"
      => {:name=>{:first=>"Johnny", :surname=>"Begood"}, :my=>{:object=>{:with=>{:deep=>{:nested=>{:members=>"happy place"}}}}}}

You can assign hashes which become nested blobjects

  data.details = { code: 41239, ref: "#22322" }

  data.details.code
    => 41239
  data.details.code = 11322
  data.details.code
    => 11322
  data.details.ref
    => "#22322"


You can test to see if a member is defined:

    data.something_here?
      => false
    data.name?
      => true

You can use it like a hash

    data[:name]
      => {:first=>"Johnny", :surname=>"Begood"}

    data[:name][:first] = "Jimmy"; data[:name]
      => {:first=>"Jimmy", :surname=>"Begood"}

    data.empty?
      => false

    data.name == {:first=>"Jimmy", :surname=>"Begood"}
      => true

You can get access to the internal hash with `Blobject#hash` or a de-blobjectified copy with `Blobject#to_hash`

You can call `Blobject#freeze` to prevent the data being modified. This still allows chained calls: `blobject.data.nested.is_something_here?` but assignments will raise `RuntimeError: can't modify frozen Hash`

You can work with JSON data using `Blobject.from_json` and `Blobject#to_json`, in Rails, you can use `Blobject#as_json` as you would with a hash.

You can work with YAML data using `Blobject.from_yaml` and `Blobject#to_yaml`.


## Used for Configuration

Consider a configuration object which contains credentials for a third-party api.

    third_party_api:
      secret_key: 'S3CR3T'
      endpoint: 'http://services.thirdparty.net/api'

With a hash, usage looks like this:
    
    CONFIG[:third_party_api][:endpoint]

With a Blobject, usage looks like this:

    CONFIG.third_party_api.endpoint

References to the endpoint are scattered throughout the codebase, then one day the endpoint is separated into its constituent parts to aide in testing and staging.

    third_party_api:
      secret_key: 'S3CR3T'
      protocol: 'http'
      hostname: 'services.thirdparty.net'
      path: '/api'

Using a blobject we can easily avoid having to refactor our code...

    CONFIG = Blobject.from_yaml(File.read('./config.yml'))

    CONFIG.third_party_api.instance_eval do
      def endpoint
        "#{protocol}://#{hostname}#{path}"
      end
    end


## Serializing & Deserializing

Blobjects can be used to easily build complex payloads.

    person = Blobject.new

    person.name = first: 'David', last: 'Platt'
    
    person.address.tap do |address|
      address.street = "..."
      address.city   = "..."
    end

    person.next_of_kin.address.city = '...'

    # after the payload is constructed it can be frozen to prevent modification
    person.freeze

A nice pattern in most cases is to use an initialization block...

    Blobject.new optional_hash_of_initial_data do |b|
      b.name = ...
    end.freeze


Suppose you receive a payload from an api which may or may not contain an address and city...

    payload = Blobject.from_json request[:payload]

    # if the payload does have an address...
    city = payload.address.city
      => 'Liverpool'

    # if the payload does not have an address or city
    city = payload.address.city
      => nil
    # rather than request[:payload][:address][:city] which would raise
    # NoMethodError: undefined method `[]' for nil:NilClass


Also, you don't need to concern yourself whether hash keys are symbols or strings.



## Performance

The runtime performance of something as low level as blobject deserves consideration.

see `/benchmarks`

    ITERATIONS: 1000000


    BENCHMARK: assign

                user       system     total       real
    Object:     0.190000   0.000000   0.190000 (  0.229685)
    Hash:       0.220000   0.000000   0.220000 (  0.230500)
    OpenStruct: 0.520000   0.000000   0.520000 (  0.529861)
    Blobject:   0.790000   0.000000   0.790000 (  0.808610)
    Hashie:     8.270000   0.030000   8.300000 (  9.291184)


    BENCHMARK: read

                user       system     total       real
    Hash:       0.160000   0.000000   0.160000 (  0.165141)
    Object:     0.170000   0.000000   0.170000 (  0.170228)
    OpenStruct: 0.340000   0.000000   0.340000 (  0.342430)
    Blobject:   0.410000   0.000000   0.410000 (  0.410574)
    Hashie:     1.880000   0.000000   1.880000 (  1.921718)

Host CPU: 2.13GHz Core2

A Blobject is three-four times slower than an equivalent Object.


## Limitations

* will not work with basic objects unless #class and #freeze are implemented
* cyclic blobject graphs result in infinite recursion StackOverflow
* Ruby 1.8.7 is not supported. Testing rubies...
  * mri 1.9.3-p194
  * mri 1.9.2-p290


## Disclaimer

Blobject provides a convenient way to create large freeform data structures; With great power comes great blah blah blah blah...


## License

(The MIT License)

Copyright © 2012 [Sam Taylor](http://sjltaylor.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Copyright (c) 2012 Sam Taylor. See LICENSE.txt for
further details.
