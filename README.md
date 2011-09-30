![](https://github.com/sjltaylor/blobject/raw/master/blobject.png)

## Takes the pain out of 

## Examples

### Creating a Blobject

#### Basic usage 
	b = Blobject.new
	
	b.name.first = 'Rick'
	b.name.last = 'Astley'
	
	b.url = 'http://www.youtube.com/watch?v=dQw4w9WgXcQ'
	
#### With a block
	b = Blobject.new do |b|

		b.name.first = 'Rick'
		b.name.last = 'Astley'

		b.url = 'http://www.youtube.com/watch?v=dQw4w9WgXcQ'
	end

#### With a hash
	b = Blobject.new :name => {:first => 'Rick', :last => 'Astley'}, :url => 'http://www.youtube.com/watch?v=dQw4w9WgXcQ'
	
#### With selected members of an existing object
	b = Blobject.new existing_object, [:name, :url]

#### With the global shortcut method
	b = blobject do |b|
 		b.name.first = 'Rick'
		b.name.last = 'Astley'

		b.url = 'http://www.youtube.com/watch?v=dQw4w9WgXcQ'
	end

all of the above initialisation methods can be used in this way too.	    

### Object graphs can be as complex as necessary
  
	b = blobject
	b.very.deep.nesting.of.objects = 2

The intermediary blobjects are created automagically

### Check for the existence of a member
	b = blobject
	b.name = 'Rick'
	b.url?
	=> false
	b.name?
	=> true
	
### Overrides ruby freeze and unfreeze
The freeze method prevents the blobject from being extended or changed. 
	
	b = blobject do |b|
 		b.name.first = 'Rick'
		b.name.last = 'Astley'

		b.url = 'http://www.youtube.com/watch?v=dQw4w9WgXcQ'
	end.freeze
	b.frozen?
	=> true
	b.am_i_here 
	=> nil
	b.name?
	=> true
	b.name = 'hello'
	=> Exception!
	
### empty? and blank? 
  
	b = blobject
	b.empty? && b.blank?
	=> true
	b.number = 123
	b.empty? || b.blank?
	=> false
	          
## Feature summary

* call a chain of methods and build an object graph automagically
* check the existence of a member with 'method?'
* overrides ruby freeze
* recursively parses blobjects from json strings
* can be initialized with...
** an object and list of accessors to copy
** a hash
** a block

## Intended usage and limitations

Intended for use to create view models which can be encoded to JSON with ActiveSupport::JSON.encode
JSON can be unmarshalled into a blobject (recursively) with `Blobject.from_json json_string`

Blobjects are intended for de/serialization, therefore cycles in the object graph will lead to a non terminating thread.


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

