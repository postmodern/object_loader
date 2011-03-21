# Objectify

* [Source](http://github.com/postmodern/objectify)
* [Issues](http://github.com/postmodern/objectify/issues)
* [Documentation](http://rubydoc.info/gems/objectify)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

Objectify can load Ruby Objects containing methods and procs from
Ruby files without having to use YAML or define classes named like the file.

## Examples

    # file: controller.rb
    class Controller
  
      include Objectify
    
      # ...
    
    end

    # file: my_controller.rb
    Controller.objectify do
  
      def test1
        'This is the first test'
      end
  
      def test2(mesg)
        "Hello #{mesg}"
      end

    end

    # load a Controller object from a file.
    controller = Controller.load_object('my_controller.rb')
    # => #<Controller: ...>

    controller.test1
    # => "This is the first test"
    controller.test2('one two three')
    # => "Hello one two three"

## Install

    $ sudo gem install objectify

## Copyright

Copyright (c) 2010 Hal Brodigan

See {file:LICENSE.txt} for license information.
