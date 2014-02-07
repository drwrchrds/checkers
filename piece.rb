# -*- coding: utf-8 -*-
require 'colorize'
require 'debugger'

class Piece
  attr_reader :color, :board, :pos
  attr_accessor :king

  RED = [[-1, -1], [-1, 1]]
  BLACK = [[1, -1], [1, 1]]

  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos
    @king = false
  end

  def to_s
    render(color)
  end

  def render(color)
    if king
      "♛"
    else
      "◉"
    end
  end

  def slide_vectors
    if king
      RED + BLACK
    else
      (color == :red ? RED : BLACK)
    end
  end

  def jump_vectors
    jump_vectors = slide_vectors
    jump_vectors.map do |y, x|
      [y * 2, x * 2]
    end
  end

  def valid_spot?(pos)
    @board.on_board?(pos) && @board.empty?(pos)
  end

  def move_to!(pos)
    @board[self.pos], @board[pos] = nil, self
    @pos = pos
  end

  def valid_slide?(pos)
    return false unless valid_spot?(pos)

    start_pos = self.pos

    possible_moves = []
    slide_vectors.each do |vector|
      possible_moves << [vector[0] + start_pos[0], vector[1] + start_pos[1]]
    end

    possible_moves.include?(pos)
  end

  def slide!(pos)
    self.move_to!(pos)
  end

  def valid_jump?(pos)
    return false unless valid_spot?(pos)

    start_pos = self.pos
    jumped_pos = [(pos[0] + start_pos[0]) / 2, (pos[1] + start_pos[1]) / 2]

    return false if @board.empty?(jumped_pos)
    return false if @board[jumped_pos].color == self.color

    possible_moves = []
    jump_vectors.each do |vector|
      possible_moves << [vector[0] + start_pos[0], vector[1] + start_pos[1]]
    end

    return false unless possible_moves.include?(pos)
    true
  end

  def valid_jumps # for ComputerPlayer to generate move sequences
    start_pos = self.pos

    possible_moves = []
    jump_vectors.each do |vector|
      possible_moves << [vector[0] + start_pos[0], vector[1] + start_pos[1]]
    end
    p "potential jump moves - #{possible_moves}"
    possible_moves.select! do |target_pos|

      jumped_pos = [(target_pos[0] + start_pos[0]) / 2, (target_pos[1] + start_pos[1]) / 2]

      valid_spot?(target_pos) && !@board.empty?(jumped_pos) && !@board[jumped_pos].color == self.color
    end
    p "available jump moves - #{possible_moves}"
    possible_moves
  end

  # def valid_move_sequences(move_sequence)
  #   sequences = []
  #   # p move_sequence
  #   duped_board = @board.dup
  #   duped_piece = duped_board[self.pos]
  #
  #   # p "valid jumps - #{duped_piece.valid_jumps}"
  #   duped_piece.valid_jumps.each do |jump_pos|
  #     new_sequence = move_sequence + [jump_pos]
  #     #p new_sequence
  #     sequences << new_sequence
  #     sequences.concat(valid_move_sequences(new_sequence))
  #   end
  #
  #   sequences
  # end

  def jump!(pos)
    jumped_pos = [(pos[0] + self.pos[0]) / 2, (pos[1] + self.pos[1]) / 2]
    self.move_to!(pos)
    @board[jumped_pos] = nil
  end

  def perform_moves(move_sequence)
    if valid_move_sequence?(move_sequence)
      perform_moves!(move_sequence, real_time = true)
    else
      raise InvalidMoveError.new("Error - that is not a valid move.")
    end
  end

  protected

    def maybe_promote
      if (self.color == :red && self.pos[0] == 0) ||
        (self.color == :blue && self.pos[0] == 7)
        # puts "King me!"
        self.king = true
      end
    end

    def perform_moves!(move_sequence, real_time = false)
      if move_sequence.count == 1
        target_pos = move_sequence.first

        if valid_slide?(target_pos)
          self.slide!(target_pos)
        elsif valid_jump?(target_pos)
          self.jump!(target_pos)
        else
          raise InvalidMoveError.new("Error - that is not a valid single move.")
        end
        self.maybe_promote unless king
      else
        move_sequence.each do |move|
          # debugger

          target_pos = move

          if valid_slide?(target_pos)
            raise InvalidMoveError.new("Error - cannot slide in a combo.")
          elsif valid_jump?(target_pos)
            self.jump!(target_pos)
          else
            raise InvalidMoveError.new("Error - that is not a valid combo move.")
          end
          self.maybe_promote unless king
          if real_time
            sleep(0.5)
            puts @board
          end
        end
      end
    end

    def valid_move_sequence?(move_sequence)
      duped_board = @board.dup
      piece = duped_board[self.pos]
      begin
        piece.perform_moves!(move_sequence)
      rescue InvalidMoveError => e
        puts e
        return false
      end
      true
    end

end