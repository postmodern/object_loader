require 'contextify'

class Book

  include Contextify

  contextify :book

  # Title of the book
  attr_accessor :title

  # Author of the book
  attr_accessor :author

end
