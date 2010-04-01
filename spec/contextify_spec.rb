require 'contextify'

require 'spec_helper'
require 'helpers/contexts'

describe Contextify do
  include Helpers::Contexts

  before(:all) do
    @snow_crash_path = context_path(:snow_crash)
    @neuromancer_path = context_path(:neuromancer_review)
  end

  it "should contain defined contexts" do
    Contextify.is_context?('book').should == true
  end

  it "should create a class-level context name" do
    Book.context_name.should == 'book'
  end

  it "should raise UnknownContext when loading unknwon-contexts" do
    lambda {
      Contextify.load_context(:nothing, 'some_path.rb')
    }.should raise_error(Contextify::UnknownContext)
  end

  it "should raise ContextNotFound when loading from non-existant files" do
    lambda {
      Contextify.load_context(:book, 'not_here.rb')
    }.should raise_error(Contextify::ContextNotFound)
  end

  it "should load arbitrary blocks from a file" do
    pending_context = Contextify.load_blocks(@snow_crash_path)

    pending_context.blocks.should have_key('book')
  end

  it "should recover from SyntaxError exceptions" do
    lambda {
      Contextify.load_blocks(context_path(:syntax_error))
    }.should raise_error(SyntaxError)

    Contextify.waiting.should be_empty
  end

  it "should recover from LoadError exceptions" do
    lambda {
      Contextify.load_blocks(context_path(:load_error))
    }.should raise_error(LoadError)

    Contextify.waiting.should be_empty
  end

  it "should load a block by context-name from a file" do
    block = Contextify.load_block(:book, @snow_crash_path)

    block.should_not be_nil
  end

  it "should load contexts by context-name from a file" do
    book = Contextify.load_context(:book, @snow_crash_path)
    book.should_not be_nil
    book.class.should == Book
  end

  it "should load a specific context from a file with multiple contexts" do
    book = Contextify.load_context(:book, @neuromancer_path)
    book.should_not be_nil
    book.class.should == Book

    review = Contextify.load_context(:book_review, @neuromancer_path)
    review.should_not be_nil
    review.class.should == BookReview
  end

  it "should provide class-level methods for loading a context block" do
    block = Book.load_context_block(@snow_crash_path)

    block.should_not be_nil
  end

  it "should provide class-level methods for loading a context" do
    book = Book.load_context(@snow_crash_path)
    book.should_not be_nil
    book.class.should == Book
  end

  it "should return nil when loading contexts incompatible with the class" do
    BookReview.load_context(@snow_crash_path).should be_nil
  end

  describe "loaded contexts" do
    before(:all) do
      @book = Book.load_context(@snow_crash_path)
    end

    it "should have attributes" do
      @book.title.should == 'Snow Crash'
      @book.author.should == 'Neal Stephenson'
    end

    it "should have instance methods" do
      @book.respond_to?(:rating).should == true
      @book.rating.should == 10
    end
  end
end
