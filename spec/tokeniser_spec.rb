require 'spec_helper'

describe ToyLisp::Tokeniser do

  before do
    @subject = ToyLisp::Tokeniser.new
  end

  describe :tokenise do
    it 'emits an empty token list for an empty line' do
      expect(@subject.tokenise('')).to eq []
    end

    it 'emits a single sexpr_start token for "("' do
      expect(@subject.tokenise('(')).to eq [{:type => :sexpr_start}]
    end

    it 'emits a single sexpr_end token for ")"' do
      expect(@subject.tokenise(')')).to eq [{:type => :sexpr_end}]
    end

    it 'emits a single whitespace token for " "' do
      expect(@subject.tokenise(' ')).to eq [{:type => :whitespace, :content => " "}]
    end

    it 'emits a single whitespace token for "\t"' do
      expect(@subject.tokenise("\t")).to eq [{:type => :whitespace, :content => "\t"}]
    end

    it 'emits a single whitespace token for multiple " "' do
      expect(@subject.tokenise('   ')).to eq [{:type => :whitespace, :content => "   "}]
    end

    it 'emits a single symbol token for "a"' do
      expect(@subject.tokenise('a')).to eq [{:type => :symbol, :content => "a"}]
    end

    it 'emits a single symbol token for "ab"' do
      expect(@subject.tokenise('ab')).to eq [{:type => :symbol, :content => "ab"}]
    end

    it 'emits two sexpr tokens for "()"' do
      expect(@subject.tokenise('()')).to eq [{:type => :sexpr_start}, {:type => :sexpr_end}]
    end

    it 'emits five tokens for " ( ) "' do
      types = @subject.tokenise(' ( ) ').map{|tok| tok[:type]} 
      expect(types).to eq [:whitespace, :sexpr_start, :whitespace, :sexpr_end, :whitespace]
    end

    it 'emits five tokens for "(a b)"' do
      tokens = @subject.tokenise('(a b)') 
      types = tokens.map{|tok| tok[:type]} 
      contents = tokens.map{|tok| tok[:content]} 
      expect(types).to eq [:sexpr_start, :symbol, :whitespace, :symbol, :sexpr_end]
      expect(contents).to eq [nil, 'a', ' ', 'b', nil]
    end

    it 'emits seven tokens for "(foo bar baz)"' do
      tokens = @subject.tokenise('(foo bar baz)')
      types = tokens.map{|tok| tok[:type]} 
      contents = tokens.map{|tok| tok[:content]} 
      expect(types).to eq [:sexpr_start, :symbol, :whitespace, :symbol, :whitespace, :symbol, :sexpr_end]
      expect(contents).to eq [nil, 'foo', ' ', 'bar', ' ', 'baz', nil]
    end
  end

end
