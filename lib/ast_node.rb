module Toil

class ASTNode
  attr_accessor :children

  def initialize
    @children = []
  end

  def add_child(node)
    @children << node
  end

  def serialize
    out = "("
    @children.each do |child|
      out += child.serialize
    end
    out += ")"
    out
  end
end

end
