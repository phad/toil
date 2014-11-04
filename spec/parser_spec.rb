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

  describe :roundtrips do
    # TODO: create a custom syntax for below so I just say
    # it_should_roundtrip("(())")
    it { subject.parse(@tokeniser.tokenise("")).should be_nil }
    it { subject.parse(@tokeniser.tokenise("()")).serialize.should eq "()" }
    it { subject.parse(@tokeniser.tokenise("(())")).serialize.should eq "(())" }
    it { subject.parse(@tokeniser.tokenise("(()())")).serialize.should eq "(()())" }
    it { subject.parse(@tokeniser.tokenise("(()(())())")).serialize.should eq "(()(())())" }
  end

  it "raise an exception for invalid sexpr_start/end token nestings" do
    expect(lambda { subject.parse(@tokeniser.tokenise("(")) }).to raise_error
    expect(lambda { subject.parse(@tokeniser.tokenise(")")) }).to raise_error
    expect(lambda { subject.parse(@tokeniser.tokenise("())")) }).to raise_error
    expect(lambda { subject.parse(@tokeniser.tokenise("()())")) }).to raise_error
    expect(lambda { subject.parse(@tokeniser.tokenise("(()")) }).to raise_error
  end

end
