class Knight < Piece
  def valid_move?(finish)
    start = [self.y, self.x]
    if ((start[0] - finish[0]).abs == 1 && (start[1] - finish[1]).abs == 2) ||
      ((start[0] - finish[0]).abs == 2 && (start[1] - finish[1]).abs == 1)
      return true
    end
    false
  end

  def no_piece_in_the_way?(finish,board)
    true
  end
end