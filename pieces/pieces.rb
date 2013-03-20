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
      return self.color == :W ? "\u2654 " : "\u265A "
    when Queen
      return self.color == :W ? "\u2655 " : "\u265B "
    when Bishop
      return self.color == :W ? "\u2657 " : "\u265D "
    when Knight
      return self.color == :W ? "\u2658 " : "\u265E "
    when Rook
      return self.color == :W ? "\u2656 " : "\u265C "
    when Pawn
      return self.color == :W ? "\u2659 " : "\u265F "
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
      y_array = custom_range(start[0], final[0])
      x_array = custom_range(start[1], final[1])
      y_array.each_with_index {|y, i| path << [y, x_array[i]]}
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












