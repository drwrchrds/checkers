class ComputerPlayer < Player
  def initialize(name)
    super
  end

  def play_turn
    puts @board
    gets
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

    # jumping_moves.each do |move|
 #      p "#{move[1]} - valid jumps: #{@board[move[1]].valid_jumps}"
 #    end

    # sequences = []
#     jumping_moves.each do |move|
#       start_pos = move[0]
#       sequence = move[1]
#
#       sequences << [start_pos + @board[start_pos].valid_move_sequences(sequence)]
#     end
#     sequences


    sliding_moves = []
    my_pieces.each do |piece|
      sliding_moves.concat(get_sliding_moves(piece))
    end


    jumping_moves.sample() || sliding_moves.sample()
  end

  # def get_jumping_moves(piece)
  #   return [piece.pos] if piece.valid_jumps.empty?
  #
  #   duped_board = piece.board.dup
  #   duped_piece = duped_board[piece.pos]
  #
  #   longest_sequence = "f"
  #   # [piece.pos] += get_jumping_moves(duped_piece) # .unshift()
  # end

  def get_sliding_moves(piece)
    sliding_moves = []
    piece.slide_vectors.each do |vector|
      start_pos = piece.pos
      target_pos = [vector[0] + start_pos[0], vector[1] + start_pos[1]]
      if piece.valid_slide?(target_pos)
        sliding_moves << [start_pos, [target_pos]]
      end
    end
    sliding_moves
  end

end
