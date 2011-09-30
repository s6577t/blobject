![](https://github.com/sjltaylor/blobject/raw/master/blobject.png)


## Usage

This is how you could use blobject to present a model for a JSON api call

    def present(model)
    	  blobject do
    	    name.first model.first_name
    	    name.last model.last_name
    	    url 'http://www.youtube.com/watch?v=dQw4w9WgXcQ'
    	  end
    end

If the were more calls in the 'name' namespace it might be more convenient to do

    def present(model)
      blobject do
        name do
          first model.first_name
          middle model.middle_name if model.has_middle_name?
          last model.last_name
        end
        url 'http://www.youtube.com/watch?v=dQw4w9WgXcQ'
      end
    end

In each case, a blobject is returned that can be used like a normal object, or a hash

    b = present(model)
    b.name.first
      => 'Barry'
    b.name.has_middle?
      => true
    b[:url] # could also pass a string, blobject isn't a key fascist
      => "http://www.youtube.com/watch?v=dQw4w9WgXcQ"

blobjects can be modified as follows

    b.modify do
      number 172367
    end

They can be as complex/deep as required

    b = blobject do
      deep.nested.member.ofa.very.complex.thing 'HELLO WORLD'
    end
    
    b.deep.nested.member.ofa.very.complex.thing
      => 'HELLO WORLD'
      


	
## Creation options

You can call blobject or Blobject.new with a hash to prefill it with data

    b = blobject :name => {:first => 'Barry'}
    b.name.first
      => 'Barry'
    
    b.modify { name.last 'McDoogle' }
    b.name.last
      => 'McDoogle'

`blobject *params` is simply an alias for `Blobject.new *params`

## Checking for members

to find out if a blobject already has a member:

    b = blobject
    
    b.has_name?
      => false
    
    b.modify do
      has_name?
        => false
      name 'Jim'
      has_name?
        => true
    end
    
    b.has_name?
      => true

## Behaves like a hash

* `#keys` returns all of the available keys
* `#values` returns all of the available keys
* `#each` enumerator of key, value pairs
* `#[]` can be used for access to members, similarly `#[]=` can be used for assignment inside or outside of the modify block
* `#dup` performs `Marshal.load(Marshal.dump(self))` for a deep copy
* `#empty?` returns true if there are no members, false otherwise
* `#to_yaml` and `#to_json`

## Load JSON and YAML from a file

  `blobject_file = Blobject.read('path/to/file.json')`
  
  
Supported extensions: `yml`, `yaml`, `json`, `js`
  

## Limitations

Blobjects are intended for de/serialization; cyclic object graphs will cause havoc


## Contributing to blobject
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## License

(The MIT License)

Copyright © 2011 [Sam Taylor](http://sjltaylor.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Copyright (c) 2011 Sam Taylor. See LICENSE.txt for
further details.

