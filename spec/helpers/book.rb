require 'objectify'

class Book

  include Objectify

  # Title of the book
  attr_accessor :title

  # Author of the book
  attr_accessor :author

end
