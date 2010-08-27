require 'helpers/book_context'
require 'helpers/text_book_context'
require 'helpers/book_review_context'

module Helpers
  module Contexts
    CONTEXTS_DIR = File.expand_path(File.join(File.dirname(__FILE__),'contexts'))

    def context_path(name)
      File.join(Helpers::Contexts::CONTEXTS_DIR,"#{name}.rb")
    end
  end
end
