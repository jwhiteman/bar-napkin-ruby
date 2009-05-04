a = Thread.new do
  sleep(2)
  STDOUT.puts "thread a done"
end

b = Thread.new do
  a.join
  sleep(3)
  STDOUT.puts "thread b done"
end

c = Thread.new do
  sleep(1)
  STDOUT.puts "thread c done"
end

d = Thread.new do
  sleep(10)
  def shout
    "APPLICATION COMPLETED!"
  end
end


b.join

begin
  STDOUT.puts shout
rescue Exception
  STDOUT.puts "waiting..."
  sleep(0.5)
  retry
end