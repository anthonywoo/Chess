class Game

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

  #start [y,x]
  #end   [y,x]
  def move_piece(start,final)

    on_board(start,final)
    piece = find_piece(start)

    if piece.valid_move?(start,final)
      check_and_clear_final_pos(final, piece.color)
      piece.move(final)
    end
  end

  def check_and_clear_final_pos(final,color)
    piece = find_piece(final)
    return true if piece.nil?
    raise "Can't ,over on top of your own" if piece.color == color
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

class Piece

  attr_accessor :x, :y
  attr_reader :color
  def initialize(color,y,x)
    @color = color
    @x = x
    @y = y
  end

  def move(pos)
    self.x,self.y = pos[1],pos[0]
  end

  def getName
    case self
    when King
      return "#{color}K"
    when Queen
      return "#{color}Q"
    when Bishop
      return "#{color}B"
    when Knight
      return "#{color}H"
    when Rook
      return "#{color}R"
    when Pawn
      return "#{color}P"
    end
  end
end

class King < Piece

  #def initialize(color,y,x)
  #  super(color,y,x)
  #  self.:valid_move = [[1,0],[0,1],[1,1],[-1,0],[0,-1],[-1,-1],[-1,1],[1,-1]]
  #end
  def valid_move?(start,finish)
    if (start[0] - finish[0]).abs < 2 &&  (start[1] - finish[1]).abs < 2
      raise 'Invalid Move for king'
    end
    return true
  end
end

class Queen < Piece
  def valid_move?(start,finish)
    if ((start[0] - finish[0]).abs == (start[1] - finish[1]).abs ||
        (start[0] - finish[0]).abs == 0 ||
        (start[1] - finish[1]).abs == 0)
      return true
    end
    raise 'invalid move for queen'
  end
end

class Bishop < Piece
  def valid_move?(start,finish)
    if ((start[0] - finish[0]).abs == (start[1] - finish[1]).abs)
      return true
    end
    raise 'Invalid move for #{self.class}'
  end
end

class Knight < Piece
  def valid_move?(start,finish)
    if ((start[0] - finish[0]).abs == 1 && (start[1] - finish[1]).abs == 2) ||
      ((start[0] - finish[0]).abs == 2 && (start[1] - finish[1]).abs == 1)
      return true
    end
    raise "Invalid move for #{self.class}"
  end
end

class Rook < Piece
  def valid_move?(start,finish)
    if (start[0] - finish[0]).abs == 0 || (start[1] - finish[1]).abs == 0
      return true
    else
      raise "Invalid move for #{self.class}"
    end
  end
end

class Pawn < Piece
  def valid_move?(start,finish)
    if self.color == :B
      if (finish[0] - start[0]) == 1 && (finish[1] == start[1])
        return true
      else
        raise "Invalid move for #{self.class}"
      end
    elsif self.color == :W
      if (finish[0] - start[0]) == -1 && (finish[1] == start[1])
        return true
      else
        raise "Invalid move for #{self.class}"
      end
    end
  end
end

class Blank
end
