[![Gem Version](https://badge.fury.io/rb/cuketagger.svg)](https://rubygems.org/gems/cuketagger)
[![Build Status](https://travis-ci.org/enkessler/cuketagger.svg?branch=dev)](https://travis-ci.org/enkessler/cuketagger)
[![Dependency Status](https://gemnasium.com/enkessler/cuketagger.svg)](https://gemnasium.com/enkessler/cuketagger)


# Cuketagger

This gem provides the ability to manipulate, in bulk, the tags in a Cucumber test 
suite. 


## Installation

Add this line to your application's Gemfile:

    gem 'cuketagger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cuketagger


## Usage

Tags can be added,

    $ cuketagger add:foo path/to/some.feature

removed,

    $ cuketagger remove:foo path/to/some.feature

or replaced.

    $ cuketagger replace:old_tag:new_tag path/to/some.feature

Multiple tags and files can be manipulated at the same time

    $ cuketagger remove:wip add:release5 replace:qa:prod features/foo.feature:6 features/bar.feature

and the modified file content will be output to the console. To modify the files 
themselves, add the explicit `force` tag.

    $ cuketagger --force remove:wip add:release5 replace:qa:prod features/foo.feature:6 features/bar.feature


## Contributing

1. Fork it
2. Create your feature branch (off of the development branch)
   `git checkout -b my-new-feature`
3. Commit your changes
   `git commit -am 'Add some feature'`
4. Push to the branch
   `git push origin my-new-feature`
5. Create new Pull Request
