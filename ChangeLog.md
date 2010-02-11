### 0.1.4 / 2009-01-30

* Require RSpec >= 1.3.0.
* Require YARD >= 0.5.3.
* Added {Contextify::ClassMethods}.
* Added {Contextify::PendingContext#each_class}.
* Added {Contextify::PendingContext#each}.
* Fixed a bug in {Contextify::PendingContext#each_block}.
* Fixed a typo where {Contextify} methods where being defined within
  the {Contextify.included} method.

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

