require 'object_loader'

class Book

  include ObjectLoader

  # Title of the book
  attr_accessor :title

  # Author of the book
  attr_accessor :author

end
