# -*- coding: utf-8 -*-
require 'debugger'


class Player

  attr_accessor :color, :board

  def initialize(name)
    @name = name
  end

  def pieces
    self.board.all_pieces.select do |piece|
      piece.color == color
    end
  end

  def play_turn
    puts @board

    begin
      begin
        start_pos = get_input(true)
        move_sequence = get_input(false)
      rescue InvalidInputError => e
        puts e
        retry
      end

      @board[start_pos[0]].perform_moves(move_sequence)
    rescue InvalidMoveError => e
      puts e
      retry
    end
  end

  private

    def get_input(start_pos = true)
      if start_pos
        puts "#{self.color.to_s.capitalize} - What piece would you like to move (x y):"
      else
        puts "#{self.color.to_s.capitalize} - Where would you like to move it to (x y, x y, etc.):"
      end

      moves = gets.chomp.split(',').map { |coords| coords.split.map { |n| n.to_i - 1 }.reverse }

      moves.each do |pos|
        if !pos.is_a?(Array) || pos.length != 2
          raise InvalidInputError.new("Error - That input is not valid (please input coords separated by a space, e.g.: '3 3')")
        end

        if start_pos
          validate_starting_pos(pos)
        else
          validate_target_pos(pos)
        end
      end
      moves
    end

    def validate_starting_pos(pos)
      if !@board.on_board?(pos) || @board.empty?(pos)
        raise InvalidInputError.new("Error - That is not a valid position.")
      end
      raise InvalidInputError.new("Error - That is not your piece.") if @board[pos].color != self.color
    end

    def validate_target_pos(pos)
      if !@board.on_board?(pos) || !@board.empty?(pos)
        raise InvalidInputError.new("Error - That is not a valid position.")
      end
    end
end