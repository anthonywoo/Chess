class Bishop < Piece
  def valid_move?(finish)
    start = [self.y, self.x]
    if ((start[0] - finish[0]).abs == (start[1] - finish[1]).abs)
      return true
    end
    false
  end
end