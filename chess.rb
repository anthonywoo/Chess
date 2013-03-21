require './piece_header.rb'
require 'colorize'
#REV: Love the organization of your code btw
class Game
  def initialize
    @board = Board.new
    @player1 = Player.new(@board, :W) #W
    @player2 = Player.new(@board, :B) #B
  end
  def start_game

    @turn  = :W
    take_turn
  end
  def next_turn
    @turn = @turn == :W ? :B : :W
  end

  def take_turn
    succuss = false
    @board.display
    puts @turn
    if @board.game_over?(@turn)
      puts "You Lose!"
      exit
    elsif @board.king_in_check?(@turn)
      puts "Yo king be in check"
    end
    until succuss
      @board.display
      puts "Turn for #{@turn}"
      begin
        if @turn == :W
          @player1.take_move
        else
          @player2.take_move
        end
        succuss = true unless @board.king_in_check?(@turn)
        puts ""
      rescue Exception => e
        puts e.message
        puts "Try again!"
      end
    end
    if @board.king_in_check?(@turn)
      puts "CHECK!"
    end
    next_turn
    puts "I Ran!"
    take_turn
  end

end

class Player
  attr_accessor :board, :color
  def initialize(board, color)
    @board = board
    @color = color
  end

  #a8 = [0,0]
  def translate_chess_notation(notation)
    chess_coords = notation.split('')
    y =  (chess_coords[1].to_i - 8).abs
    x =   chess_coords[0].ord - 97
    [y,x]
  end

  def take_move
    puts "enter a8 e6"
    user_input = gets.chomp
    chess_coords = user_input.split(" ")
    start = translate_chess_notation(chess_coords[0])
    final = translate_chess_notation(chess_coords[1])
    coords = start + final

    coords.map! {|str| str.to_i}
    raise "Not yo peace" unless @board.is_my_piece?([coords[0],coords[1]], self.color)
    @board.move_piece([coords[0],coords[1]],[coords[2],coords[3]])
  end

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
    system("clear")
    display_array = []
    (0..7).each do |i|
      display_array << []
      (0..7).each do |j|
        display_array[i][j] = "  ".colorize(:background=>black_white(i,j))
      end
    end
    self.black.each do |piece|
      x,y = piece.x, piece.y
      display_array[y][x] = piece.getName.colorize(:color=>:black, :background=>black_white(x,y))
    end
    self.white.each do |piece|
      x,y = piece.x, piece.y
      display_array[y][x] = piece.getName.colorize(:color=>:white, :background=>black_white(x,y))
    end
    pretty_print(display_array)
  end

  def black_white(x,y)
    if (x+y).even?
      return :yellow
    else
      return :blue
    end
  end


  def pretty_print(chess_board)

    puts "________________________________________________________________"
    print " a b c d e f g h"
    chess_board.each_with_index do |row,index|
      print "\n#{8-index}"
      row.each do |cell|
        print"#{cell}"
      end
    end
    puts "\n________________________________________________________________"
  end

  #start [y,x]
  #end   [y,x]
  def is_my_piece?(pos, color)
    find_piece(pos).color == color
  end

  def get_all_coordinates(pieces)
    all_coords = []
    (0..7).each do |i|
      (0..7).each do |j|
        all_coords << [i,j]
      end
    end
    pieces.each do |piece|
      all_coords.delete([piece.y, piece.x])
    end
    all_coords
  end

  def game_over?(color)
    return false unless king_in_check?(color) #am i currently in check?
    pieces = color == :B ? black : white

    all_coords = get_all_coordinates(pieces)

    escape = true
    pieces.each do |piece| #checkmate
      start = [piece.y, piece.x]
      all_coords.each do |final|
        if piece.can_move?(final, self)
          escape = check_if_king_in_check(piece, start, final)
        end
      end
      break unless escape
    end

    return escape
  end

  def undo_taken_piece(piece)
    if piece.color == :B
      self.black << self.black_taken.pop
    else
      self.white << self.white_taken.pop
    end
  end

  def check_if_king_in_check(piece, start, final)
    taken_piece = check_and_clear_final_pos(final,piece.color)
    piece.move(final)
    escape = king_in_check?(piece.color)
    piece.move(start)
    undo_taken_piece(taken_piece) if taken_piece
    return escape
  end



  def move_piece(start,final)
    move_on_board?(start,final)
    piece = find_piece(start)
    raise "You did not select a piece" unless piece
    raise "King is in Check" if check_if_king_in_check(piece, start, final)

    if piece.can_move?(final, self)
      check_and_clear_final_pos(final, piece.color)
      piece.move(final)
    else
      raise "Illegal move, man"
    end
  end

  #private
  def king_in_check?(color)
    king = find_king(color)
    king.in_check?(self)
  end

  def all_opposite_pieces(color)
    if color == :B
      white
    else
      black
    end
  end
#REV: would it be easier to store a reference to the king so that you don't have to search for it each time?
#REV: I'm going back and forth on that. Can't decide which is better
  def find_king(color)
    king = nil
    (black+white).each do |piece|
      if piece.class == King && piece.color == color
        return piece
      end
    end
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

  def check_and_clear_final_pos(final,color)
    piece = find_piece(final)
    return nil if piece.nil?
    raise "Can't move on top of your own" if piece.color == color
    remove_from_board(piece)
  end

  def remove_from_board(piece)
    if piece.color == :B
      self.black_taken << piece
      self.black.delete(piece)
    else
      self.white_taken << piece
      self.white.delete(piece)
    end
    piece
  end

  def move_on_board?(start,final)
    if bounds_check(start)
      raise 'Starting position outside board'
    elsif bounds_check(final)
      raise 'Finish position outside board'
    end
    true
  end

  def bounds_check(pos)
    return false if 0 <= pos[0] && pos[0] <= 7
    return false if 0 <= pos[1] && pos[1] <= 7
    true
  end

  def find_piece(pos)
    (black+white).each do |piece|
      unless piece.nil?
        return piece if [piece.y,piece.x] == pos
      end
    end
    nil
  end

end

