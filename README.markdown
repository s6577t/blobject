![](https://github.com/sjltaylor/blobject/raw/master/blobject.png)

![](https://github.com/sjltaylor/blobject/raw/master/blob_defn.png)

## Motivation

-> Blobject. So natural it could only have been done in Ruby
-> Blobject learns what you data structure looks like and defines the shape of objects on the fly
-> definition of 'Blob'

-> use it instead of hashie, jbuilder or open struct


-> tagline
-> tweet




-> good practice to freeze after an initialize yield if possible


# Performance

The runtime performance something as low level as blobject deserves consideration

-> readme
  -> yaml config example
    -> with overriding 
  -> JSON api example
  
-> benchmark how long to method calls take?
-> compare it to hashie! and open struct

LIMITATIONS:
 will not work with basic objects unless #class and #freeze are implemented
 cannot handle cyclic blobject graphs
 only tested on mri-1.9.2-p180
 if Blobject is subclassed and private instance methods are defined, these will be overriden when attribute accessors are automatically declared is there is a naming collision