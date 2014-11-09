require 'ast_node'

module Toil

class Executor
  attr_accessor :ast_node

  def initialize(ast_node)
    @ast_node = ast_node
  end

  def run
    operator = ast_node.children.first.atom
    operation = make_operation(operator)
    evaluated_children = ast_node.children[1..-1].map do |ch|
      if ch.instance_of? Toil::AtomNode
        ch.atom
      elsif ch.instance_of? Toil::SExprNode
        Executor.new(ch).run
      end
    end
    operation.perform(evaluated_children)
  end

  private

  def make_operation(operator)
    if operator == '+'
      AdditionOperation.new
    elsif operator == '-'
      SubtractionOperation.new
    elsif operator == '*'
      MultiplicationOperation.new
    else
      raise "Unknown operation #{operator}"
    end
  end
end

class AdditionOperation
  def perform(operands)
    operands.inject(0) {|a, v| a + v.to_i}
  end
end

class SubtractionOperation
  def perform(operands)
    raise "Subtraction requires exactly 2 operands" unless operands.size == 2
    operands[0].to_i - operands[1].to_i
  end
end

class MultiplicationOperation
  def perform(operands)
    operands.inject(1) {|a, v| a * v.to_i}
  end
end

end
