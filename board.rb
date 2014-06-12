##encoding: utf-8
require './piece'
class Board
  def initialize
    @board = Array.new(10) { Array.new(10) {nil} }
  end
  
  def render
    black = true
    @board.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        if tile == nil
          print " ⬜ " if black == false
          print " ⬛ " if black == true
        elsif tile.is_a?(Piece)
          print " #{tile.inspect} "
        end
        black = !black
      end
      puts
    end
    
    puts
    puts
  end
  
  def valid_move_seq?(seq)
  
  
  def dup
    new_board = Board.new
    @board.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        new_board[x,y] = @board[x,y]
      end
    end
  end  
  
  def [](pos)
    x, y = pos
    @board[y][x]
  end


  def []=(pos, value)
    x, y = pos
    @board[y][x] = value
  end
end
  
if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.render
  b1 = Piece.new([0,0], b, :black)
  w1 = Piece.new([1,2], b, :white)
  b.render
  b1.perform_slide([0,0], [0, 1])
  b.render
  b1.perform_jump([0,1], [2,3])
  #b.render
  #w1.perform_slide([1,2], [1, 1])
  b.render
  b.dup
end