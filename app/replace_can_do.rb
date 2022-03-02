# frozen_string_literal: true

require 'rubocop'
require 'rubocop/ast'

# Replaces call sites of `can_do` with `grants_any_right?`
#   This is due to the fact that can_do doesn't do anything
#   but delegate anymore. Only the arguments order changes
class ReplaceCanDo < Parser::TreeRewriter
  include RuboCop::AST::Traversal

  def on_send(node)
    return unless node.method_name == :can_do

    receiver_arg, user_arg, * = node.arguments
    replace node.loc.selector, "#{receiver_arg.loc.expression.source}&.grants_any_right?"
    replace receiver_arg.loc.expression, user_arg.children.first
    replace user_arg.loc.expression, 'session'
  end
end

# TODO: Make it so I can use ruby-rewrite with this
# TODO: BONUS: Make grants_any_right addable via ast, not magic strings
