require 'pry'
distance = 0
require '../lib/computer.rb'
input = File.open('input', 'rb').read
wires = []
input.each_line { |line| wires << line.split(',') }
binding.pry
puts "Part 1: #{distance}"
puts 'Part 2: TODO'
