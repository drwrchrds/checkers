class Piece
  attr_accessor :king
  def initialize
    @king = false
  end

  def perform_slide
    # return true or false if valid
  end

  def perform_jump
    # return true or false if valid
    # remove jumped piece from the board
  end

  def maybe_promote
    # is promotable?
    # if true, self.king == true
  end

  def perform_moves(move_sequence)
    # this method checks to see if move sequence is valid
    # dup board for each move in sequence and raise an error if any returns invalid

    # if doesn't return invalid, call perform_moves!(move_sequence)
  end

  def perform_moves!(move_sequence)
  end

end