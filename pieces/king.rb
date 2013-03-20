class King < Piece

  def valid_move?(finish)
    start = [self.y, self.x]
    if (start[0] - finish[0]).abs < 2 &&  (start[1] - finish[1]).abs < 2
      return true
    end
    return false
  end

  def in_check?(board)
    board.all_opposite_pieces(self.color).each do |piece|
      begin
        return true if piece.can_move?([self.y, self.x], board)
      rescue Exception => e
        puts e
      end
    end
    return false
  end

end