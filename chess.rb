require './pieces.rb'
class Game

end

class Player
  attr_accessor :board
  def initialize(board)
    @board = board
  end
end

class Board
  attr_accessor :black, :white, :black_taken, :white_taken
  def initialize
    @black = build_all_black_pieces
    @white = build_all_white_pieces
    @black_taken = []
    @white_taken = []
  end

  def display
    display_array = []
    (0..7).each do |i|
      display_array << ["**","**","**","**","**","**","**","**"]
    end
    self.black.each do |piece|
      x,y = piece.x, piece.y
      display_array[y][x] = piece.getName
    end
    self.white.each do |piece|
      x,y = piece.x, piece.y
      display_array[y][x] = piece.getName
    end
    display_array
  end

  #start [y,x]
  #end   [y,x]
  def move_piece(start,final)

    on_board(start,final)
    piece = find_piece(start)

    piece.move(final)

    if king_in_check?(piece.color)
      piece.move(start)
      raise "You King is in Check"
    end
    piece.move(start)

    raise 'Pawn blocked' if pawn_blocked(start,final)
    check_path(build_path(start,final))

    if valid_pawn_attack(start,final) || piece.valid_move?(start,final)
      check_and_clear_final_pos(final, piece.color)
      piece.move(final)
    end

  end

  private

  def king_in_check?(color)
    king = find_king(color)
    all_opposite_pieces(color).each do |piece|
      if piece.valid_move([piece.y, piece.x], [king.y, king.x])
        return true
      end
    end
    return false
  end

  def all_opposite_pieces(color)
    if color == :B
      white
    else
      black
    end
  end

  def find_king(color)
    king = nil
    (black+white).each do |piece|
      if piece.class == King && piece.color == color
        return piece
      end
    end
  end


  def pawn_blocked(start,finish)
    pawn = find_piece(start)
    return false unless pawn.class == Pawn
    enemy = find_piece(finish);
    return false if enemy.nil?
    if (start[0]-finish[0]).abs == 1 && start[1] == finish[1]
      return true
    end
    return false
  end

  def valid_pawn_attack(start,finish)
    pawn = find_piece(start)
    enemy = find_piece(finish);
    return false unless pawn.class == Pawn
    return false unless enemy != nil && enemy.color != pawn.color
    if (start[0] - finish[0]).abs == 1 &&
       (start[1] - finish[1]).abs == 1

       return true
     end
     return false

  end





  def build_all_black_pieces
    black = []
    black << Rook.new(:B,0,0)
    black << Knight.new(:B,0,1)
    black << Bishop.new(:B,0,2)
    black << Queen.new(:B,0,3)
    black << King.new(:B,0,4)
    black << Bishop.new(:B,0,5)
    black << Knight.new(:B,0,6)
    black << Rook.new(:B,0,7)

    0.upto(7){|col| black << Pawn.new(:B,1,col)}
    black
  end

  def build_all_white_pieces
    white = []
    white << Rook.new(:W,7,0)
    white << Knight.new(:W,7,1)
    white << Bishop.new(:W,7,2)
    white << Queen.new(:W,7,3)
    white << King.new(:W,7,4)
    white << Bishop.new(:W,7,5)
    white << Knight.new(:W,7,6)
    white << Rook.new(:W,7,7)

    0.upto(7){|col| white << Pawn.new(:W,6,col)}
    white
  end


  def check_path(path)
    return if path.nil?
    path.each do |pos|
      raise "Obstacle in the way" if find_piece(pos)
    end
  end

  def build_path(start,final)
    piece = find_piece(start)
    return if piece.class == Knight
    path = []
    #is diag, horiz, vertical
    if start[0] == final[0] #horiz
      custom_range(start[1], final[1]).each {|x| path << [start[0],x]}
    elsif start[1] == final[1] #vertical
      custom_range(start[0], final[0]).each {|y| path << [y,start[1]]}
    else #diag
      x_array = []
      y_array = []
      custom_range(start[0], final[0]).each {|x| x_array << x}
      custom_range(start[1], final[1]).each {|y| y_array << y}
      y_array.each_with_index do |y, i|
        path << [y, x_array[i]]
      end
    end

     path.delete(start) unless path.nil?
     path.delete(final) unless path.nil?
     path
  end

  def custom_range(start, final)
    a = start < final ? start : final
    b = start < final ? final : start
    result = []
    (a..b).each do |i|
      result << i
    end
    result
  end

  def check_and_clear_final_pos(final,color)
    piece = find_piece(final)
    return true if piece.nil?
    raise "Can't move on top of your own" if piece.color == color
    remove_from_board(piece)
    true
  end

  def remove_from_board(piece)
    if piece.color == :B
      self.white_taken << piece
      self.black.delete(piece)
    else
      self.black_taken << piece
      self.white.delete(piece)
    end
  end

  def on_board(start,final)
    if bounds_check(start)
      raise 'Starting position outside board'
    elsif bounds_check(final)
      raise 'Finish position outside board'
    end
  end

  def bounds_check(pos)
    return false if 0 <= pos[0] && pos[0] <= 7
    return false if 0 <= pos[1] && pos[1] <= 7
    true
  end

  def find_piece(pos)
    (black+white).each do |piece|
      x,y = piece.x, piece.y
      if [y,x] == pos
        return piece
      end
    end
    nil
  end

end

