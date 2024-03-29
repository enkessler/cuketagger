# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [Unreleased]

### Removed
 - Dropped support for Ruby 1.x. Currently supported Ruby versions are 2.x and 3.x.

### Changed
- No longer including every file in the Git repository as part of the gem. Only the files needed for using the 
  gem (and the informative ones like the README) will be packaged into the released gem.


## [1.6.0] - 2016-12-11

### Added
- Updated the dependencies used by the gem in order to be compatible with current
  libraries.

### Changed
- File modification has been minimized. Only the lines of a file that are affected
  by tagging are modified. Previously, the entire file was potentially reformatted.


## 1.5.0 - 2011-04-17

* The Great Before Times...


[Unreleased]: https://github.com/enkessler/cuketagger/compare/v1.6.0...HEAD
[1.6.0]: https://github.com/enkessler/cuketagger/compare/v1.5.0...v1.6.0
