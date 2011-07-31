require 'spec_helper'

describe Square do
  describe "free?" do
    it "should be false if the square is water" do
      square = Square.new(true, false, nil, 0, 0, nil)
      square.should_not be_free
    end

    it "should be false if the square is land with a live ant" do
      ant = Ant.new(true, 0, nil, nil)
      square = Square.new(false, false, ant, 0, 0, nil)
      square.should_not be_free
    end

    it "should be false if the square is land with food" do
      square = Square.new(false, true, nil, 0, 0, nil)
      square.should_not be_free
    end

    it "should be false if the square is land with an inbound ant" do
      inbound_ant = Ant.new(true, 0, nil, nil)
      square = Square.new(false, false, nil, 0, 0, nil)
      square.inbound_ant = inbound_ant
      square.should_not be_free
    end

    it "should be true if the square is land and has no live ant or food" do
      square = Square.new(false, false, nil, 0, 0, nil)
      square.should be_free
    end
  end

  describe "height" do
    it "should be 0 when there are no heights" do
      square = Square.new(false, false, nil, 0, 0, nil)
      square.heights.should == []
      square.height.should == 0
    end

    it "should be the sum of heights when there are heights" do
      square = Square.new(false, false, nil, 0, 0, nil)

      square.heights = [1]
      square.height.should == 1

      square.heights = [1, 2]
      square.height.should == 3

      square.heights = [1, -1]
      square.height.should == 0

      square.heights = [-1, 2, -2]
      square.height.should == -1
    end
  end

  describe "flow_directions" do
    it "should return the directions ordered by lowest height to highest height" do
      ai = AI.new
      grid = Grid.new(3,3, ai)
      ai.grid = grid
      grid.square(1,0).heights << -1
      grid.square(1,2).heights << 1
      grid.square(0,1).heights << 2
      grid.square(2,1).heights << -2
      grid.square(1,1).flow_directions.should == %w[S W E N]
    end

    it "should not return directions that are blocked" do
      ai = AI.new
      grid = Grid.new(3,3, ai)
      ai.grid = grid
      grid.square(1,0).heights << -1
      grid.square(1,2).heights << 1
      grid.square(0,1).ant = Ant.new(true, 0, grid.square(0,1), ai)
      grid.square(2,1).water = true
      grid.square(1,1).flow_directions.should == %w[W E]
    end
  end
end
