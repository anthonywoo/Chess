class Pawn < Piece
  def valid_move?(finish)
    start = [self.y, self.x]
    distance = start[0]==1 || start[0] == 6 ? 2 : 1
    if self.color == :B
      if (finish[0] - start[0]).abs <= distance && (finish[1] == start[1])
        return true
      else
        false
      end
    elsif self.color == :W
      if (finish[0] - start[0]).abs <= distance && (finish[1] == start[1])
        return true
      else
        false
      end
    end
  end

  def pawn_blocked(finish, board)
    enemy = board.find_piece(finish);
    return false if enemy.nil?
    if (self.y-finish[0]).abs == 1 && self.x == finish[1]
      return true
    end
    return false
  end

  def valid_pawn_attack(finish, board)
    enemy = board.find_piece(finish);
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