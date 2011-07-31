# Represent a single field of the map.
class Square
  # Ant which sits on this square, or nil. The ant may be dead.
  attr_accessor :ant, :inbound_ant
  # Which row this square belongs to.
  attr_accessor :row
  # Which column this square belongs to.
  attr_accessor :col

  attr_accessor :water, :food, :ai

  # Influences for a height map
  attr_accessor :heights

  def initialize(water, food, ant, row, col, ai)
    @water, @food, @ant, @row, @col, @ai = water, food, ant, row, col, ai
    @heights = Array.new
  end

  # Returns true if this square is not water. Square is passable if it's not water, it doesn't contain alive ants and it doesn't contain food.
  def land?; !@water; end
  # Returns true if this square is water.
  def water?; @water; end
  # Returns true if this square contains food.
  def food?; @food; end
  # Returns true if an ant is moving to this square
  def inbound_ant?; @inbound_ant; end

  # Is the square non-occupied land?
  def free?
    return false if water?
    return false if ant?
    return false if food?
    return false if inbound_ant?
    return true
  end

  def food_neighbor?
    %w[N E S W].any? {|direction| neighbor(direction).food?}
  end

  # Returns true if this square has an alive ant.
  def ant?; @ant and @ant.alive?; end;

  # Returns a square neighboring this one in given direction.
  def neighbor(direction)
    direction=direction.to_s.upcase.to_sym # canonical: :N, :E, :S, :W
    row, col = self.row, self.col

    case direction
    when :N
      row-=1
    when :E
      col+=1
    when :S
      row+=1
    when :W
      col-=1
    else
      raise 'incorrect direction'
    end

    return @ai.grid.square(row, col)
  end

  def reset
    self.food=false
    self.ant=nil
    self.inbound_ant=nil
    self.heights.clear
  end

  def height
    self.heights.sum.to_i
  end

  def flow_directions
    %w[N E S W].select{|direction| neighbor(direction).free?}.sort_by {|direction| neighbor(direction).height}
  end
end
