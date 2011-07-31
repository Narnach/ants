#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'ai'

ai=AI.new

ai.setup do |ai|
  # your setup code here, if any
end

ai.run do |ai|
  # your turn code here

  ai.my_ants.each do |ant|
    next if ant.moved?
    # Try to move to all directions in a random order
    # Randomizing the order prevents getting stuck in a corner
    possible_directions = %w[N E S W].select {|direction| ant.square.neighbor(direction).free?}
    adjecent_to_food = possible_directions.select{|direction| ant.square.neighbor(direction).food_neighbor?}
    direction = [adjecent_to_food.shuffle, possible_directions.shuffle].flatten.first
    ant.order(direction) if direction
  end
end