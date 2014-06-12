#encoding: utf-8

require './board'

class Piece
  
  attr_reader :color, :pos
  
  def initialize(pos, board, color)
    @board_obj = board
    @position = pos
    @color = color
    @king = false
    set_position(@position)
  end
  
  def inspect
    if @color == :black
      "◯"
    else
      "⬤"
    end
  end
  
  def perform_slide(from_pos, to_pos)
    if !valid_moves?(from_pos) || !valid_moves?(to_pos)
      raise "Those are invalid moves"
    elsif (to_pos.last - from_pos.last).abs > 1 || @position.first != to_pos.first
      raise "That's an illegal move"
    else
      @board_obj[from_pos] = nil
      set_position(to_pos)
    end
  end
  
  def perform_jump(from_pos, to_pos)
    raise "Those are invalid moves" if !valid_moves?(from_pos) || !valid_moves?(to_pos)
    
    jumpable_tiles = []
    
    move_diffs.each do |diffs|
      pos = [(from_pos.first + diffs.first) , (from_pos.last + diffs.last)]
      jumpable_tiles << pos
    end  
    
    jumped_piece_pos = nil
    
    jump_pieces = jumpable_tiles.select{ |pos| @board_obj[pos].is_a?(Piece) && @board_obj[pos].color != @color }
    
    if (from_pos.first - to_pos.first).abs != 2 && (from_pos.last - to_pos.last).abs != 2
      raise "That's an illegal jump"
    elsif !jump_pieces.empty?
      @board_obj[from_pos] = nil
      dx = (to_pos.first - from_pos.first) / 2
      dy = (to_pos.last - from_pos.last) / 2
      jumped_piece_pos = [(from_pos.first + dx), (from_pos.last + dy)]
      @board_obj[jumped_piece_pos] = nil
      set_position(to_pos)
    else
      raise "Can't jump! No piece there"
    end
  end
  
  def perform_moves!(move_seq)
    if move_seq.length < 2
      begin
        perform_slide(move_seq[0].first,  move_seq[0].last )
        perform_jump( move_seq[0].first,  move_seq[0].last )
      rescue
        raise InvalidMoveError.new
      end
    else
      until move_seq.empty?
        begin
          current_move = move_seq.shift
          perform_jump(current_move.first,  current_move.last)
        rescue
          raise InvalidMoveError.new
        end
      end
    end
  end
  
  private
  
  def set_position(pos)
    x, y = pos
    @board_obj[[x, y]] = self
  end
  
  def move_diffs
    diffs = [[ 1,  1],
             [-1,  1],
             [-1, -1],
             [ 1, -1]]
  end
  

  
  def valid_moves?(pos)
    pos.first.between?(0, 9) && pos.last.between?(0,9)
  end
end

class InvalidMoveError < StandardError
  def message
    puts "That move was invalid"
  end
end