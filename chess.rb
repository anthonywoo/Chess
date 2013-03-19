class Game

end


class Board
  attr_accessor :black, :white
  def initialize
    @black = build_all_black_pieces
    @white = build_all_white_pieces
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
    p display_array
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

end

class Piece

  attr_accessor :x, :y
  attr_reader :color

  def initialize(color,y,x)
    @color = color
    @x = x
    @y = y
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

end

class Queen < Piece
end

class Bishop < Piece
end

class Knight < Piece
end

class Rook < Piece
end

class Pawn < Piece
end

class Blank
end
