#!/usr/local/bin/ruby

require 'fileutils'

$data = []

Dir['/Users/jimtron/Desktop/live-evil/*'].map do |p|
  Thread.new(p) do |p|
    FileUtils.cd(p)
    $data << File.basename(p) + ": " + `git pull`
  end
end.each { |t| t.join }

max_width = $data.max { |a,b| a.length <=> b.length }.size

STDOUT.puts $data.map { |l| l.rjust(max_width) }