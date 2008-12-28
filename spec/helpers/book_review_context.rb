require 'contextify'

class BookReview

  include Contextify

  contextify :book_review

  # Title of the book
  attr_accessor :book_title

  # Author of the book
  attr_accessor :book_author

  # Author of this review
  attr_accessor :author

  # Summary
  attr_accessor :summary

end
