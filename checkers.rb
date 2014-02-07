# -*- coding: utf-8 -*-s

require_relative 'board'
require_relative 'player'
require_relative 'computerplayer'
require_relative 'errors'

class Game
  def initialize(player1, player2)
    @board = Board.new(populated = true)
    @player1, @player2 = player1, player2
    self.associate_players
    @current_player = @player1
  end

  def associate_players
    @player1.color = :black
    @player2.color = :red
    @player1.board = @board
    @player2.board = @board
  end

  def play
    until over?
      @current_player.play_turn
      @current_player = ( @current_player == @player1 ? @player2 : @player1 )
    end
    puts @board
    puts "#{@current_player.color} loses!"
  end

  def over?
    @current_player.pieces.empty?
  end

end

if __FILE__ == $PROGRAM_NAME
  p1 = Player.new("Thor")
  p2 = ComputerPlayer.new("Sam Sung")
  g = Game.new(p1, p2)

  g.play
end