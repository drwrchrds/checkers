require 'colorize'

class InvalidMoveError < RuntimeError
  def to_s
    super.red
  end
end

class InvalidInputError < RuntimeError
  def to_s
    super.red
  end
end