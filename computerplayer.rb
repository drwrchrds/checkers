class ComputerPlayer < Player
  def initialize(name)
    super
  end

  def play_turn
    start_pos, move_sequence = best_move

    @board[start_pos].perform_moves(move_sequence)
  end

  def best_move
    my_pieces = self.pieces

    jumping_moves = []
    my_pieces.each do |piece|
      piece.jump_vectors.each do |vector|
        start_pos = piece.pos
        target_pos = [vector[0] + start_pos[0], vector[1] + start_pos[1]]
        if piece.valid_jump?(target_pos)
          jumping_moves << [start_pos, [target_pos]]
        end
      end
    end

    sliding_moves = []
    my_pieces.each do |piece|
      piece.slide_vectors.each do |vector|
        start_pos = piece.pos
        target_pos = [vector[0] + start_pos[0], vector[1] + start_pos[1]]
        if piece.valid_slide?(target_pos)
          sliding_moves << [start_pos, [target_pos]]
        end
      end
    end

    jumping_moves.sample() || sliding_moves.sample()
  end
end
