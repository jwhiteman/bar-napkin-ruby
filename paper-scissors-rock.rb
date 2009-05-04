# this makes me happy :)

class Piece
  class << self
    def beats(*args)
      class_eval do
        define_method(:beats) do
          args.map { |s| Object.const_get(s.to_s.capitalize) }
        end
      end
    end
  end
  
  def beats?(opp)
    beats.include? opp.class
  end
end

class Rock < Piece
  beats :scissors
end

class Scissors < Piece
  beats :paper
end

class Paper < Piece
  beats :rock
end

paper, scissors, rock = Paper.new, Scissors.new, Rock.new

paper.beats? rock
rock.beats? scissors
scissors.beats? paper


# double dispatch, the Java way...this sucks (and doesn't work...I don't understand the pattern, I guess)
class Rock
  def beats?(obj)
    obj.loses_to_rock?
  end
  
  def loses_to_rock?; false; end
  def loses_to_paper?; true; end
  def loses_to_scissors?; false; end
end

class Paper
  def beats?(obj)
    obj.loses_to_paper?
  end
  
  def loses_to_rock?; false; end
  def loses_to_paper?; false; end
  def loses_to_scissors?; true; end
end

class Scissors
  def beats?(obj)
    obj.loses_to_scissors?
  end
  
  def loses_to_rock?; true; end
  def loses_to_paper?; false; end
  def loses_to_scissors?; false; end
end

paper, scissors, rock = Paper.new, Scissors.new, Rock.new

rock.beats? scissors
paper.beats? rock
scissors.beats? paper
