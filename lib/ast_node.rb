module Toil

class ASTNode
  attr_accessor :children

  def initialize
    # A child could be an atom or an s-expression
    @children = []
  end

  def add_child(node)
    @children << node
  end

  def serialize
    out = "("
    @children.each_with_index do |child, index|
      out += child.serialize
      out += " " unless (index == @children.size - 1)
    end
    out += ")"
    out
  end
end

class SExprNode < ASTNode
end

class AtomNode < ASTNode
  attr_accessor :atom

  def initialize(atom)
    @atom = atom
  end

  def serialize
    "#{atom}"
  end
end

end
