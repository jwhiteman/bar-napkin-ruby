def reverse(s)
  if s.midpoint?
    s
  else
    s.last + reverse(s.middle) + s.first
  end
end

def midpoint?
  self.size == 0 or
    self.size == 1
end

def first; self[0].chr end

def middle; self[1...-1] end

def last; self[-1].chr end


###

# 0,-1  1,-2  2,-3
class String
  
  def reverse_i!
    (0...midpoint).each do |i| 
      self[i], self[-(i+1)] = self[-(i+1)], self[i] 
    end 
    
    self
  end
  
  private 
  
  def midpoint
    self.size / 2
  end
  
end


require 'benchmark'
include Benchmark

STRING = 'x' * 1_000

bmbm(12) do |r|
  r.report("recursive") do
    1_000.times do
      reverse(STRING.dup)
    end
  end
  
  r.report("iterative") do
    1_000.times do
      STRING.dup.reverse_i!
    end
  end
  
  r.report("MRI reverse") do
    1_000.times do
      STRING.dup.reverse
    end
  end
  
  r.report("MRI reverse!") do
    1_000.times do
      STRING.dup.reverse!
    end
  end
end


# 
class String
  
  def reverse
    k = lambda do |s|
      if s.midpoint?
        s
      else
        s.last + k[s.middle] + s.first
      end
    end
    
    k.call(self)
  end
  
  # or
  def reverse
    yComb do |f|
      lambda do |s|
        if s.midpoint?
          s
        else
          s.last + f.call(s.middle) + s.first
        end
      end
    end.call(self)
  end
  
  def midpoint?
    self.size == 0 or
      self.size == 1
  end
  
  def first; self[0].chr end
  
  def middle; self[1...-1] end
  
  def last; self[-1].chr end
end