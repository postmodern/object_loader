require 'helpers/book'
require 'helpers/text_book'
require 'helpers/book_review'

module Helpers
  module Objects
    DIR = File.expand_path(File.join(File.dirname(__FILE__),'objects'))

    def object_path(name)
      File.join(Helpers::Objects::DIR,"#{name}.rb")
    end
  end
end
