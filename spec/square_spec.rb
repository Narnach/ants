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
end
