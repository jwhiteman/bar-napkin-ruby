# [8, 4, 9, 9, 5]

def insertion_sort(a)
  (1...a.size).each do |i|
    (i+1).downto(2) do |j|
      if a[j] < a[j-1]
        a[j], a[j-1] = a[j-1], a[j]
      end
    end
  end
end


# how i'm guessing it should go...
# [8 4 9 9 5]
# [4 8 9 9 5]
# [4 8 9 5 9]
# [4 8 5 9 9]
# [4 5 8 9 9]




def insertion_sort(a)
  (0..a.size-2).each do |i|
    (i+1).downto(1) do |j|
      if a[j] < a[j-1]
        a[j], a[j-1] = a[j-1], a[j]
      end
    end
  end 
end

insertion_sort [8, 4, 9, 9, 5]


def quicksort(l)
  if l.empty?
    []
  else
    car, *cdr = l
    quicksort(cdr.select { |e| e <= car }) +
      [car] +
      quicksort(cdr.select { |e| e > car})
  end
end

K = Array.new(5000) { rand(10_000) }

bm(12) do |r|
  r.report('insertion_sort') do
    10.times do
      insertion_sort K.dup
    end
  end
  
  r.report('quicksort') do
    10.times do
      quicksort K.dup
    end
  end
end

quicksort Array.new(20) { rand 1_000 }


# write select* && quicksort*


def insertion_sort!(l)
  def test?(a, n)
    a[n] < a[n-1]
  end
  
  def swap(a, n)
    a[n], a[n-1] = a[n-1], a[n]
  end
  
  (0..l.size-2).each do |i|
    (i+1).downto(1) do |j|
      swap(l, j) if test?(l, j)
    end
  end
  
  Object.send(:remove_method, :test?)
  Object.send(:remove_method, :swap)
  
  l
end

insertion_sort! Array.new(rand(10)) { rand(1_000) } 

# star_select([1, 2, [3], 4, [5]]) { |n| n > 2 }
#  => [3, 4, 5]
def star_select(l)
  r = []
  
  s = lambda do |t|
    if t.empty?
      nil
    elsif t.first.is_a? Fixnum
      r << t.first if yield(t.first)
      s.call t[1..-1]
    else
      s.call t.first
      s.call t[1..-1]
    end
  end
  
  s.call(l)
  r
end

star_select([1, 2, [3], 4, [5]]) { |n| n > 2 }
star_select([[1], [2, [5]], [3], 4, [5]]) { |n| n > 3}


def yComb
  lambda { |f| f[f] }.call(
    lambda do |f|
      yield lambda { |x| f[f][x] }
    end
  )
end

class Array
  def cdr
    self[1..-1]
  end
end

def deep_select(l)
  r = []
  
  yComb do |s|
    lambda do |t|
      if t.empty?
        nil
      elsif t.first.is_a? Fixnum
        r << t.first if yield(t.first)
        s[t.cdr]
      else
        s[t.first]
        s[t.cdr]
      end
    end
  end.call(l)
  
  r
end

           

         

def deep_select_cc(l)
  r = []
  
  s = lambda do |t, c|
    if t.empty?
      c[:quit]
    elsif t.first.is_a? Fixnum
      r << t.first if yield(t.first)
      s[t.cdr, c]
    else
      callcc { |x| s[t.first, x] }
      s[t.cdr, c]
    end
  end
  
  callcc { |c|  s[l, c] }
  r
end

deep_select_cc([1, 2, [3], 4, [5]]) { |n| n > 2 }
deep_select_cc([[1], [2, [5]], [3], 4, [5]]) { |n| n > 3 }

def deep_select_tc(l)
  r = []
  
  s = lambda do |t|
    if t.empty?
      throw :done!
    elsif t.first.is_a? Fixnum
      r << t.first if yield(t.first)
      s.call t[1..-1]
    else
      catch(:done!) { s.call t.first }
      s.call t[1..-1]
    end
  end
  
  catch(:done!) { s.call(l) }
  
  r
end

def deep_select_tc(l)
  r = []
  
  catch(:done!) do
    yComb do |s|
      lambda do |t|
        if t.empty?
          throw :done!
        elsif t.first.is_a? Fixnum
          r << t.first if yield(t.first)
          s[t.cdr]
        else
          catch(:done!) { s[t.first] }
          s[t.cdr]
        end
      end
    end.call(l)
  end
  
  r
end

# ruby 1.9
def deep_select_tc(l)
  r = []
  
  catch(:done!) do
    yComb do |s|
      ->(t) {
        if t.empty?
          throw :done!
        elsif t.first.is_a? Fixnum
          r << t.first if yield(t.first)
          s.(t.cdr)
        else
          catch(:done!) { s.(t.first) }
          s.(t.cdr)
        end
      end
      }
    end.(l)
  end
  
  r
end

deep_select_tc([1, 2, [3], 4, [5]]) { |n| n > 2 }
deep_select_tc([[1], [2, [5]], [3], 4, [5]]) { |n| n > 3 }



def report
  bm(12) do |r|
    r.report('regular') do
      10_000.times do
        deep_select([[1], [2, [5]], [3], 4, [5]]) { |n| n > 3 }
      end
    end

    # deep_select_tc([[1], [2, [5]], [3], 4, [5]]) { |n| n > 3 }
    r.report('callcc') do
      10_000.times do
        deep_select_cc([[1], [2, [5]], [3], 4, [5]]) { |n| n > 3 }
      end 
    end

    r.report('try catch') do
      10_000.times do
        deep_select_tc([[1], [2, [5]], [3], 4, [5]]) { |n| n > 3 }
      end
    end
  end
end


