require 'contextify'

require 'spec_helper'
require 'helpers/book_context'
require 'helpers/book_review_context'

describe Contextify do
  before(:all) do
    @contexts_dir = File.expand_path(File.join(File.dirname(__FILE__),'helpers','contexts'))
    @snow_crash_path = File.join(@contexts_dir,'snow_crash.rb')
    @neuromancer_path = File.join(@contexts_dir,'neuromancer_review.rb')
  end

  it "should contain defined contexts" do
    Contextify.is_context?('book').should == true
  end

  it "should create a class-level context name" do
    Book.context_name.should == 'book'
  end

  it "should raise an UnknownContext exception when loading unknwon-contexts" do
    lambda {
      Contextify.load_context(:nothing, 'some_path.rb')
    }.should raise_error(Contextify::UnknownContext)
  end

  it "should raise a ContextNotFound exception when loading from non-existant files" do
    lambda {
      Contextify.load_context(:book, 'not_here.rb')
    }.should raise_error(Contextify::ContextNotFound)
  end

  it "should load a block by context-name from a file" do
    @block = Contextify.load_block(:book, @snow_crash_path)

    @block.should_not be_nil
  end

  it "should load contexts by context-name from a file" do
    @book = Contextify.load_context(:book, @snow_crash_path)
    @book.should_not be_nil
    @book.class.should == Book
  end

  it "should load a specific context from a file with multiple contexts" do
    @book = Contextify.load_context(:book, @neuromancer_path)
    @book.should_not be_nil
    @book.class.should == Book

    @review = Contextify.load_context(:book_review, @neuromancer_path)
    @review.should_not be_nil
    @review.class.should == BookReview
  end

  it "should provide class-level methods for loading a context block" do
    @block = Book.load_context_block(@snow_crash_path)

    @block.should_not be_nil
  end

  it "should provide class-level methods for loading a context" do
    @book = Book.load_context(@snow_crash_path)
    @book.should_not be_nil
    @book.class.should == Book
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
