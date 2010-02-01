# Contextify

* [contextify.rubyforge.org](http://contextify.rubyforge.org/)
* [github.com/postmodern/contextify](http://github.com/postmodern/contextify/)
* Postmodern (postmodern.mod3 at gmail.com)

## DESCRIPTION:

Load Objects from Ruby files without having to use YAML or define
classes named like the file.

## EXAMPLES:

    # file: controller.rb
    class Controller
  
      include Contextify
    
      contextify :controller
    
      # ...
    
    end

    # file: my_controller.rb
    controller do
  
      def test1
        'This is the first test'
      end
  
      def test2(mesg)
        "Hello #{mesg}"
      end

    end

    # load a Controller object from a file.
    controller = Controller.load_context('my_controller.rb')
    # => #<Controller: ...>

    controller.test1
    # => "This is the first test"
    controller.test2('one two three')
    # => "Hello one two three"

## INSTALL:

    $ sudo gem install contextify

## LICENSE:

The MIT License

Copyright (c) 2008-2010 Hal Brodigan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
