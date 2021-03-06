require 'ast_node'

module Toil

class Parser
  def initialize()
  end

  def parse(tokens)
    states = []
    node = nil
    tokens.each_with_index do |tok, index|
      case tok[:type]
      when :sexpr_start
        states << {:state => :in_sexpr, :node => Toil::SExprNode.new}
      when :sexpr_end
        raise ("Token " + tok.to_s + " invalid if state stack empty") if states.size == 0
        state = states.pop
        if states.size > 0
          states.last[:node].add_child(state[:node])
        else
          node = state[:node]
          raise ("foo " + index.to_s + " of " + tokens.size.to_s) if index < tokens.size - 1
        end
      when :symbol
        if states.empty? or not states.last[:node].instance_of?(Toil::SExprNode)
          raise ("Encountered symbol token " + tok.to_s + "outside an sexpr")
        end
        states.last[:node].add_child(Toil::AtomNode.new(tok[:content]))
      end
    end
    raise ("No tokens remain yet state stack not empty") if states.size > 0
    node
  end
end

end