#!/usr/bin/env ruby

class Array
  def shuffle
    shuffled = self.dup
    self.size.times do |index|
      replacement_index = rand(self.size)
      shuffled[index], shuffled[replacement_index] = shuffled[replacement_index], shuffled[index]
    end
    shuffled
  end
end

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'ai'

ai=AI.new

ai.setup do |ai|
	# your setup code here, if any
end

ai.run do |ai|
	# your turn code here

	ai.my_ants.each do |ant|
		# try to go north, if possible; otherwise try east, south, west.
		[:N, :E, :S, :W].shuffle.each do |dir|
			if ant.square.neighbor(dir).free?
				ant.order dir
				break
			end
		end
	end
end