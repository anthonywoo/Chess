class Rook < Piece
  def valid_move?(finish)
    start = [self.y, self.x]
    if (start[0] - finish[0]).abs == 0 || (start[1] - finish[1]).abs == 0
      return true
    end
    false
  end
end