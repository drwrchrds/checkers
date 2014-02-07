# -*- coding: utf-8 -*-

require_relative 'piece'
require_relative 'errors'

class Board

  def initialize(populated = true)
    @grid = populated ? build_starting_grid : build_empty_grid
  end

  def build_empty_grid
    Array.new(8) { Array.new(8) }
  end

  def [](pos)
    y, x = pos
    @grid[y][x]
  end

  def []=(pos, arg)
    y, x = pos
    @grid[y][x] = arg
  end

  def build_starting_grid
    board = build_empty_grid
    odd = true
    board.each_with_index do |row, ridx|
      next if ridx == 3
      next if ridx == 4
      color = ( ridx > 4 ? :red : :black )
      row.each_with_index do |tile, tidx|
        next if tidx.odd? == odd
        board[ridx][tidx] = Piece.new(self, color, [ridx, tidx])
      end
      odd = ( odd == true ? false : true )
    end
    board
  end

  def on_board?(pos)
    pos.all? {|coord| coord >= 0 && coord < 8}
  end

  def empty?(pos)
    self[pos].nil?
  end

  def add_piece(color, pos)
    self[pos] = Piece.new(self, color, pos)
  end

  def all_pieces
    all_pieces = []
    @grid.each do |row|
      row.each do |tile|
        all_pieces << tile if tile
      end
    end
    all_pieces
  end

  def to_s
    puts nil
    string = ""
    string += "   1  2  3  4  5  6  7  8\n\n"
    @grid.each_with_index do |row, ridx|
      string += (ridx + 1).to_s + " "
      row.each do |tile|
        if tile.nil?
          string += " - "
        else
          string += " " + tile.to_s + " "
        end
      end
      string += " " + (ridx + 1).to_s
      string += "\n"
    end
    string += "\n   1  2  3  4  5  6  7  8\n"
    string
  end

  def dup
    duped_board = Board.new(populated = false)
    @grid.each_with_index do |row, ridx|
      row.each_with_index do |tile, tidx|
        unless tile.nil?
          duped_board.add_piece(tile.color, [ridx, tidx])
          if tile.king
            duped_board[[ridx, tidx]].king = true
          end
        end
      end
    end
    duped_board
  end
end