require_relative 'board'

# b = Board.new
#
# puts b
#
# red = b[[5, 1]]
#
# b.add_piece(:black, [4, 2])
# puts b
# puts nil
# p red.perform_slide?([4, 2])
# p red.perform_slide?([5, 2])
# p red.perform_jump?([3, 3])
# puts b


c = Board.new
red2 = c[[5, 1]]
c.add_piece(:black, [4, 2])
c[[1, 1]] = nil
puts c
# red2.perform_moves!([[3, 3],[1, 1]])

p red2.valid_move_sequence?([[3, 3], [1, 1]])
puts c

p red2.valid_move_sequence?([[3, 3], [2, 2]])