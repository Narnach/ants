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
    # Don't double-move an ant
    next if ant.moved?

    # Check which way we can actually move
    possible_directions = %w[N E S W].select {|direction| ant.square.neighbor(direction).free?}.shuffle

    # If there's food next to an adjecent square, move there
    direction = possible_directions.find{|direction| ant.square.neighbor(direction).food_neighbor?}

    # If there's food two tiles away, go there if we don't already have a direction
    direction ||= possible_directions.find do |direction|
      base = ant.square.neighbor(direction)
      %w[N E S W].find do |direction2|
        base2 = base.neighbor(direction2)
        base2.free? && base2.food_neighbor?
      end
    end

    # Fall back to pick a random valid direction
    direction ||= possible_directions.first

    ant.order(direction) if direction
  end
end