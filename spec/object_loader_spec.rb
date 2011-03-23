require 'spec_helper'
require 'helpers/objects'

require 'object_loader'

describe ObjectLoader do
  include Helpers::Objects

  let(:snow_crash_path) { object_path(:snow_crash) }
  let(:discrete_structures_path) { object_path(:discrete_structures) }
  let(:neuromancer_path) { object_path(:neuromancer_review) }

  let(:syntax_error_path) { object_path(:syntax_error) }
  let(:load_error_path) { object_path(:load_error) }
  let(:name_error_path) { object_path(:name_error) }
  let(:no_method_error_path) { object_path(:no_method_error) }

  it "should raise ObjectNotFound when loading from non-existant files" do
    lambda {
      Book.load_object('not_here.rb')
    }.should raise_error(ObjectLoader::ObjectNotFound)
  end

  it "should load arbitrary blocks from a file" do
    blocks = ObjectLoader.load_blocks(snow_crash_path)

    blocks.should_not be_empty
  end

  it "should recover from SyntaxError exceptions" do
    lambda {
      ObjectLoader.load_blocks(syntax_error_path)
    }.should raise_error(SyntaxError)

    ObjectLoader.loading(syntax_error_path).should be_nil
  end

  it "should recover from LoadError exceptions" do
    lambda {
      ObjectLoader.load_blocks(load_error_path)
    }.should raise_error(LoadError)

    ObjectLoader.loading(load_error_path).should be_nil
  end

  it "should recover from NameError exceptions" do
    lambda {
      ObjectLoader.load_blocks(name_error_path)
    }.should raise_error(NameError)

    ObjectLoader.loading(name_error_path).should be_nil
  end

  it "should recover from NoMethodError exceptions" do
    lambda {
      ObjectLoader.load_blocks(no_method_error_path)
    }.should raise_error(NoMethodError)

    ObjectLoader.loading(no_method_error_path).should be_nil
  end

  it "should load a block for a specific Class from a file" do
    block = Book.load_object_block(snow_crash_path)

    block.should_not be_nil
  end

  it "should provide class-level methods for loading an object" do
    book = Book.load_object(snow_crash_path)

    book.should_not be_nil
    book.class.should == Book
  end

  it "should load objects for a specific Class from a file" do
    book = Book.load_object(snow_crash_path)

    book.should_not be_nil
    book.class.should == Book
  end

  it "should load the object of a specific Class from a file with multiple objects" do
    review = BookReview.load_object(neuromancer_path)

    review.should_not be_nil
    review.class.should == BookReview
  end

  it "should not load objects if none are of a specific Class" do
    book = Book.load_object(neuromancer_path)

    book.should_not be_nil
    book.class.should == Book
  end

  it "should load the object which inherit from a specific Class" do
    book = Book.load_object(discrete_structures_path)

    book.should_not be_nil
    book.class.should == TextBook
  end

  it "should return nil when loading objects incompatible with the Class" do
    BookReview.load_object(snow_crash_path).should be_nil
  end

  describe "loaded objects" do
    before(:all) do
      @book = Book.load_object(snow_crash_path)
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
