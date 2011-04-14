# blobject

Blobject provides a free flowing syntax for creating blobs of data.

## Examples

### creating a blobject

#### basic usage 
	b = Blobject.new
	
	b.name.first = 'Rick'
	b.name.last = 'Astley'
	
	b.url = 'http://www.youtube.com/watch?v=dQw4w9WgXcQ'
	
#### with a block
	b = Blobject.new do |b|

		b.name.first = 'Rick'
		b.name.last = 'Astley'

		b.url = 'http://www.youtube.com/watch?v=dQw4w9WgXcQ'
	end

#### with a hash
	b = Blobject.new :name => {:first => 'Rick', :last => 'Astley'}, :url => 'http://www.youtube.com/watch?v=dQw4w9WgXcQ'
	
#### with selected members of an existing object
	b = Blobject.new existing_object, [:name, :url]

#### with the global shortcut method
	b = blobject do |b|
 		b.name.first = 'Rick'
		b.name.last = 'Astley'

		b.url = 'http://www.youtube.com/watch?v=dQw4w9WgXcQ'
	end

all of the above initialisation methods can be used in this way too.	    

### object graph can be as complex as necessary
 b = blobject
 b.very.deep.nesting.of.objects = 2

The intermediary blobjects are created automagically

### check for the existence of a member
	b = blobject
	b.name = 'Rick'
	b.url?
	=> false
	b.name?
	=> true
	
### overrides ruby freeze and unfreeze
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

Blobjects are intended for de/serialization and there for the cycles in the object graph will lead to a non terminating thread.


## Contributing to blobject
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Sam Taylor. See LICENSE.txt for
further details.

