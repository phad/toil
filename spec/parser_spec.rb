require 'spec_helper'
require 'tokeniser'

describe Toil::Parser do

  subject(:parser) { Toil::Parser.new }

  before do
    @tokeniser = Toil::Tokeniser.new
  end

  it "builds an empty s-expr tree with empty input" do
    ast = subject.parse(@tokeniser.tokenise(""))

    expect(ast).to eq nil
  end

  it "builds a single AST node s-expr tree with an empty list" do
    ast = subject.parse(@tokeniser.tokenise("()"))

    expect(ast).to be_a Toil::ASTNode
    expect(ast.children).to be_empty
  end

  it "builds a 2-deep AST node s-expr tree with a single nested list" do
    ast = subject.parse(@tokeniser.tokenise("(())"))

    expect(ast).to be_a Toil::ASTNode
    expect(ast.children.size).to eq 1
    expect(ast.children.first).to be_a Toil::ASTNode
    expect(ast.children.first.children).to be_empty
  end

  describe "parse-serialize roundtrips for nested s-expr" do
    it { subject.parse(@tokeniser.tokenise("")).should be_nil }
    ["()", "(())", "(() ())", "(() (()) ())"].each do |src|
      it { subject.parse(@tokeniser.tokenise(src)).serialize.should eq src }
    end
  end

  describe "parse-serialize roundtrips for nested s-expr with atoms" do
    it { subject.parse(@tokeniser.tokenise("")).should be_nil }
    ["(a)", "(a (b))", "(a (b c) (d) e)", "((a b) (c (d e f) g) h (i j) k l)"].each do |src|
      it { subject.parse(@tokeniser.tokenise(src)).serialize.should eq src }
    end
  end

  it "raise an exception for invalid sexpr_start/end token nestings" do
    expect(lambda { subject.parse(@tokeniser.tokenise("(")) }).to raise_error
    expect(lambda { subject.parse(@tokeniser.tokenise(")")) }).to raise_error
    expect(lambda { subject.parse(@tokeniser.tokenise("())")) }).to raise_error
    expect(lambda { subject.parse(@tokeniser.tokenise("()())")) }).to raise_error
    expect(lambda { subject.parse(@tokeniser.tokenise("(()")) }).to raise_error
  end

  it "raise an exception if atom token found outside an s-expr" do
    expect(lambda { subject.parse(@tokeniser.tokenise("foo ()")) }).to raise_error
    expect(lambda { subject.parse(@tokeniser.tokenise("() bar")) }).to raise_error
  end

end
