Basic stuff:
[![Gem Version](https://badge.fury.io/rb/cuketagger.svg)](https://rubygems.org/gems/cuketagger)
[![Project License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/mit-license.php)
[![Downloads](https://img.shields.io/gem/dt/cuketagger.svg)](https://rubygems.org/gems/cuketagger)

User stuff:
[![Yard Docs](http://img.shields.io/badge/Documentation-API-blue.svg)](https://www.rubydoc.info/gems/cuketagger)

Developer stuff:
[![Build Status](https://github.com/enkessler/cuketagger/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/enkessler/cuketagger/actions/workflows/ci.yml?query=branch%3Amaster)
[![Coverage Status](https://coveralls.io/repos/github/enkessler/cuketagger/badge.svg?branch=master)](https://coveralls.io/github/enkessler/cuketagger?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/82a45e63ba89aaa3c760/maintainability)](https://codeclimate.com/github/enkessler/cuketagger/maintainability)

---


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
