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
      #raise 'Invalid Move for king'
      return true
    end
    return false
  end
end

class Queen < Piece
  def valid_move?(start,finish)
    if ((start[0] - finish[0]).abs == (start[1] - finish[1]).abs ||
        (start[0] - finish[0]).abs == 0 ||
        (start[1] - finish[1]).abs == 0)
      return true
    end
    #raise 'invalid move for queen'
    false
  end
end

class Bishop < Piece
  def valid_move?(start,finish)
    if ((start[0] - finish[0]).abs == (start[1] - finish[1]).abs)
      return true
    end
    #raise 'Invalid move for Bishop'
    false
  end
end

class Knight < Piece
  def valid_move?(start,finish)
    if ((start[0] - finish[0]).abs == 1 && (start[1] - finish[1]).abs == 2) ||
      ((start[0] - finish[0]).abs == 2 && (start[1] - finish[1]).abs == 1)
      return true
    end
    #raise "Invalid move for Knight"
    false
  end
end

class Rook < Piece
  def valid_move?(start,finish)
    if (start[0] - finish[0]).abs == 0 || (start[1] - finish[1]).abs == 0
      return true
    end
    #raise "Invalid move for Rook"
    false
  end
end

class Pawn < Piece
  def valid_move?(start,finish)
    distance = start[0]==1 || start[0] == 6 ? 2 : 1

    if self.color == :B
      if (finish[0] - start[0]) == distance && (finish[1] == start[1])
        return true
      else
        #raise "Invalid move for Pawn"
        false
      end
    elsif self.color == :W
      if (finish[0] - start[0]) == -1 * distance && (finish[1] == start[1])
        return true
      else
        #raise "Invalid move for Pawn"
        false
      end
    end
  end
end
