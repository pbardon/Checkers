##encoding: utf-8
require './piece'

class Board
  
  def initialize
    @board = Array.new(8) { Array.new(8) {nil} }
  end
  
  def render
    black = true
    @board.each_with_index do |row, y|
      row.each do |tile|
        if tile == nil
          print " ⬜ " if black == false
          print " ⬛ " if black == true
        elsif tile.is_a?(Piece)
          print " #{tile.inspect} "
        end
        black = !black
      end
      black = !black
      puts
    end
    
    puts
    puts
  end

  def set_board(color)
    (color == :black ? place = false : place = true )
    (0..7).each do |x|
      if color == :white
        (0..2).each do |y|
          Piece.new([x, y], self, :white) if place != true
          place = !place
        end
        place = !place
      elsif color == :black
        (5..7).each do |y|
          Piece.new([x, y], self, :black) if place != true
          place = !place
        end
        place = !place
      end
      place = !place
    end
  end
  
  
  def dup
    new_board = Board.new
    @board.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        next if tile.nil?
        new_board[[x,y]] = Piece.new([x,y], new_board, tile.color)
      end
    end
    new_board
  end  
  
  def valid_move_seq?(seq)
    duped_board = @board_obj.dup
    perform_moves!(seq) 
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
##  b1 = Piece.new([0,0], b, :black)
##  w1 = Piece.new([1,1], b, :white)
#  b.render
#  b.render
 ## b1.perform_jump([0,0], [2,2])
  #b.render
 # b1.perform_jump([0,0], [2, 2])
  b.set_board(:white)
  b.set_board(:black)
  b.render
 ## b1 = Piece.new([2,3], b, :black)
  p b[[4,5]].object_id
  b[[4,5]].perform_slide([5,4])
  
  b.render
  b[[2,5]].perform_slide([3,4])
  b[[5,2]].perform_slide([4,3])
  b[[3,4]].perform_slide([2,3])
  b[[3,6]].perform_slide([4,5])
  b[[1,6]].perform_slide([2,5])
  b.render
  b[[1,2]].perform_moves([[3,4], [1,6]])
  b.render
  
  ##b1 = Piece.new([0,0], b, :black)
 ## b.dup

  
end