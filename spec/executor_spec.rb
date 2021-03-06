require 'spec_helper'
require 'executor'

describe Toil::Executor do

  before do
    @tokeniser = Toil::Tokeniser.new
    @parser = Toil::Parser.new
  end

  it "performs simple addition" do
    {"(+ 1 2)" => 3,
     "(+ 1 (+ 2 3) 4)" => 10}.each do |expr, val|
      ast = @parser.parse(@tokeniser.tokenise(expr))
      executor = Toil::Executor.new(ast)
      expect(executor.run).to eq val
    end
  end

  it "performs simple subtraction" do
    {"(- 5 2)" => 3,
     "(- 10 (- 8 6))" => 8}.each do |expr, val|
      ast = @parser.parse(@tokeniser.tokenise(expr))
      executor = Toil::Executor.new(ast)
      expect(executor.run).to eq val
    end
  end

  it "performs simple multiplication" do
    {"(* 2 3)" => 6,
     "(* 2 (* 3 4) 5)" => 120}.each do |expr, val|
      ast = @parser.parse(@tokeniser.tokenise(expr))
      executor = Toil::Executor.new(ast)
      expect(executor.run).to eq val
    end
  end

  it "performs simple division" do
    {"(/ 6 3)" => 2,
     "(/ 24 (/ 12 4))" => 8}.each do |expr, val|
      ast = @parser.parse(@tokeniser.tokenise(expr))
      executor = Toil::Executor.new(ast)
      expect(executor.run).to eq val
    end
  end

  it "performs mixed arithmetic" do
    {"(/ (+ 1 5) (- 7 4))" => 2,
     "(* 4 (/ 12 4) (+ 2 7))" => 108}.each do |expr, val|
      ast = @parser.parse(@tokeniser.tokenise(expr))
      executor = Toil::Executor.new(ast)
      expect(executor.run).to eq val
    end
  end

end
