# blobject

Blobject is for building untyped blobs of data.

An ActiveRecord is not usually enough for view data. The required view data could be more than on ActiveRecords and/or the resultant calculations of some business logic. 

= Features

* call a chain of methods and build an object graph automagically
* check the existence of a value with 'method?'
* overrides ruby freeze
* recursively loads data from JSON strings
* empty? recursive

* init with an object and list of accessors to copy
* init with hash
* init with block (frozen)


= Example Usage



= Limitations

Blobjects are intended for de/serialization and there for the cycles in the object graph will lead to a non terminating thread.


== Contributing to blobject
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2011 Sam Taylor. See LICENSE.txt for
further details.

