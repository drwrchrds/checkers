class Board

  def initialize(populated = true)
    @grid = build_starting_grid
  end

  def build_starting_grid
    Array.new(8) { Array.new(8) }
  end

  def dup
  end
end