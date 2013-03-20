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

  def custom_range(start, final)
    a = start < final ? start : final
    b = start < final ? final : start
    result = []
    (a..b).each do |i|
      result << i
    end
    result = result.reverse if final < start
    result
  end

  def build_path(start,final) #path the piece will take
    piece = self
    path = []

    if start[0] == final[0] #horiz
      custom_range(start[1], final[1]).each {|x| path << [start[0],x]}
    elsif start[1] == final[1] #vertical
      custom_range(start[0], final[0]).each {|y| path << [y,start[1]]}
    else #diag
      x_array = []
      y_array = []

      y_array = custom_range(start[0], final[0])
      x_array = custom_range(start[1], final[1])
      y_array.each_with_index do |y, i|
        path << [y, x_array[i]]
      end
    end

     path.delete(start) unless path.nil?
     path.delete(final) unless path.nil?
     path
  end

  def check_path(path, board)
    return true if path.nil?
    path.each do |pos|
      return false if board.find_piece(pos) #found obstacle in the way
    end
    true
  end

  def no_piece_in_the_way?(finish, board)
    start = [self.y, self.x]
    path = build_path(start,finish)
    check_path(path, board)
  end

  def can_move?(end_location, board)
    valid_move?(end_location) && no_piece_in_the_way?(end_location, board)
  end
end

class King < Piece

  def valid_move?(finish)
    start = [self.y, self.x]
    if (start[0] - finish[0]).abs < 2 &&  (start[1] - finish[1]).abs < 2
      return true
    end
    return false
  end

  def in_check?(board)
    #king = find_king(color)
    board.all_opposite_pieces(self.color).each do |piece|
      begin
        final = [self.y, self.x]
        if piece.can_move?(final, board)
          return true
        end
      rescue Exception => e
        puts e
      end
    end
    return false
  end

end

class Queen < Piece
  def valid_move?(finish)
    start = [self.y, self.x]
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
  def valid_move?(finish)
    start = [self.y, self.x]
    if ((start[0] - finish[0]).abs == (start[1] - finish[1]).abs)
      return true
    end
    #raise 'Invalid move for Bishop'
    false
  end

end

class Knight < Piece
  def valid_move?(finish)
    start = [self.y, self.x]
    if ((start[0] - finish[0]).abs == 1 && (start[1] - finish[1]).abs == 2) ||
      ((start[0] - finish[0]).abs == 2 && (start[1] - finish[1]).abs == 1)
      return true
    end
    #raise "Invalid move for Knight"
    false
  end

  def no_piece_in_the_way?(finish,board)
    true
  end
end

class Rook < Piece
  def valid_move?(finish)
    start = [self.y, self.x]
    if (start[0] - finish[0]).abs == 0 || (start[1] - finish[1]).abs == 0
      return true
    end
    #raise "Invalid move for Rook"
    false
  end

end

class Pawn < Piece
  def valid_move?(finish)
    start = [self.y, self.x]
    distance = start[0]==1 || start[0] == 6 ? 2 : 1
    if self.color == :B
      if (finish[0] - start[0]).abs <= distance && (finish[1] == start[1])
        return true
      else
        #raise "Invalid move for Pawn"
        false
      end
    elsif self.color == :W
      if (finish[0] - start[0]).abs <= distance && (finish[1] == start[1])
        return true
      else
        #raise "Invalid move for Pawn"
        false
      end
    end
  end

  def pawn_blocked(finish, board)
    #pawn = board.find_piece(start)
    #return false unless pawn.class == Pawn
    enemy = board.find_piece(finish);
    return false if enemy.nil?
    if (self.y-finish[0]).abs == 1 && self.x == finish[1]
      return true
    end
    return false
  end

  def valid_pawn_attack(finish, board)
   # pawn = board.find_piece(start)
    enemy = board.find_piece(finish);
   # return false unless pawn.class == Pawn
    return false unless enemy != nil && enemy.color != self.color
    if (self.y - finish[0]).abs == 1 &&
       (self.x - finish[1]).abs == 1
      return true
    end
      return false
   end
   def can_move?(end_location, board)
     (valid_move?(end_location) && !pawn_blocked(end_location,board)) ||
      valid_pawn_attack(end_location,board)
   end
end
