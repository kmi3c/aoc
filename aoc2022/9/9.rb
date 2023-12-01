require 'pry'
# https://adventofcode.com/2022/day/9
#
# --- Part One ---
#
@test = true
input = File.open("input#{@test ? '_test' : ''}", 'rb').read.split("\n")
# init state
@tmap = [Array.new(6)]
row, col = [0,0]
@tmap[row][col] = '#'


def drawmap
  @tmap.each{|r| puts r.map{|s| s.nil? ? ' . ' : " #{s} "}.join()}
  ''
end

drawmap
input.each.with_index do |move,i|
  puts move
  dir, steps = move.split(' ')
  steps = steps.to_i
  steps.times do |step|
    case dir
      when 'R'
      when 'L'
      when 'U'
      when 'D'
    end
  end
puts drawmap if @test
end

puts "Part 1: #{
  @tmap.flatten.select{|v| v == '#'}.length
}"
#drawmap if @test
#
# --- Part Two ---
#
puts "Part 2: #{
  'TBD'
}"
