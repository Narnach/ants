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

