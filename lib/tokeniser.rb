#!/usr/bin/ruby

module Toil

class Tokeniser
  def tokenise(line)
    tokens = []
    token = nil
    line.each_char do |ch|
      done = false
      case ch
      when " ", "\t"
        if (token and (token[:type] != :whitespace))
          tokens << token
          token = nil
        end
        token = {:type => :whitespace, :content => ''} unless token
        token[:content] += ch
      when "("
        if token
          tokens << token
          token = nil
        end
        tokens << {:type => :sexpr_start}
      when ")"
        if token
          tokens << token
          token = nil
        end
        tokens << {:type => :sexpr_end}
      else
        if (token and (token[:type] != :symbol))
          tokens << token
          token = nil
        end
        token = {:type => :symbol, :content => ''} unless token
        token[:content] += ch
      end
    end
    tokens << token if token
    tokens
  end
end

end
