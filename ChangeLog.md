### 1.0.1 / 2012-05-27

* Replaced ore-tasks with
  [rubygems-tasks](https://github.com/postmodern/rubygems-tasks#readme).

### 1.0.0 / 2011-03-22

* Renamed Contextify to {ObjectLoader}.
* Refactored the API.

### 0.2.0 / 2010-10-27

* Added `Contextify::ContextifiedClassMethods`.
* Fixed a block-variable shadowing bug in
  `Contextify::ClassMethods#contextify`.
* Removed the `metaid.rb` extension.

### 0.1.6 / 2010-05-23

* Moved the Contextify YARD handlers into the
  [yard-contextify](http://github.com/postmodern/yard-contextify) library.

### 0.1.5 / 2009-02-02

* Prevent exceptions from jamming the `Contextify.waiting` queue when
  loading context files with `Contextify.load_blocks`.
* Added specs for loading and recovering from erroneous context files.

### 0.1.4 / 2009-01-30

* Require RSpec >= 1.3.0.
* Require YARD >= 0.5.3.
* Added `Contextify::ClassMethods`.
* Added `Contextify::PendingContext#each_class`.
* Added `Contextify::PendingContext#each`.
* Fixed a bug in `Contextify::PendingContext#each_block`.
* Fixed a typo where `Contextify` methods where being defined within
  the `Contextify.included` method.

### 0.1.3 / 2009-09-21

* Require Hoe >= 2.3.3.
* Require YARD >= 0.2.3.5.
* Require RSpec >= 1.2.8.
* Use 'hoe/signing' for signed RubyGems.
* Moved to YARD based documentation.
* Added YARD handlers for documenting contextify method calls.
* Allow self.load_context to load objects that inherit from the contextified class.
* All specs pass on JRuby 1.3.1.

### 0.1.2 / 2009-02-06

* Added self.load_context_block to Contextify.
* Added specs for Contextify.load_block and self.load_context_block.

### 0.1.1 / 2009-01-17

* Include missing files in Manifest.
* All specs pass in Ruby 1.9.1-rc1.

### 0.1.0 / 2008-12-29

* Initial release.

