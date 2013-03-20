require './chess.rb'

test_board = Board.new
#Testing Checkmate
puts "Testing Check Mate"
test_board.move_piece([6,4],[4,4])

test_board.move_piece([7,3],[3,7])

test_board.move_piece([7,5],[4,2])
puts test_board.game_over?(:B) ? "Game Over Bad" : "Correct, Game not over"

test_board.move_piece([3,7],[1,5])

puts test_board.game_over?(:B) ? "Correct, Game Over" : "Something Wrong"

test_board = Board.new
#Check
puts "Testing Check"

test_board.move_piece([6,4],[4,4])

test_board.move_piece([7,3],[3,7])

puts test_board.king_in_check?(:B) ? "Bad" : "Correct, King not in check"

test_board.move_piece([3,7],[1,5])

puts test_board.king_in_check?(:B) ? "Correct, King in check" : "Bad, King not in check"

puts test_board.game_over?(:B) ? "Bad,Game not over" : "Correct, game not over"

test_board = Board.new
puts "Test pawn block"
test_board.move_piece([6,4],[4,4])

test_board.move_piece([1,4],[3,4])
pawn = test_board.find_piece([3,4])
puts "pawn y:#{pawn.y} x:#{pawn.x} color:#{pawn.color}, should be B"
test_board.move_piece([4,4],[3,4])
pawn = test_board.find_piece([3,4])
puts "pawn y:#{pawn.y} x:#{pawn.x} color:#{pawn.color}, should be B"
pawn = test_board.find_piece([4,4])
puts "pawn y:#{pawn.y} x:#{pawn.x} color:#{pawn.color}, should be W"

puts "Test pawn attack"
test_board.move_piece([1,3],[3,3])
taken_pawn = test_board.find_piece([3,3])
p test_board.black.include?(taken_pawn)
test_board.move_piece([4,4],[3,3])
pawn = test_board.find_piece([3,3])
puts "pawn y:#{pawn.y} x:#{pawn.x} color:#{pawn.color}, should be W"
puts "#{test_board.black.include?(taken_pawn)} false = correct"

puts "Testing correct turn"

