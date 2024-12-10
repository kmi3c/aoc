require 'pry'
# https://adventofcode.com/2024/day/
#
# --- Day X:

@input = File.open('./input', 'rb').read
@test = ""

def part1(input)
end

test1 = part1(@test)
puts "Test 1: #{test1}"
if test1 == 18
  puts 'Pass.'
else
  puts 'Test failed.'
  return
end

puts "Part 1: #{part1(@input)}"
#
# --- Part Two ---

def part2(input)
end


test2 = part2(@test)
puts "Test 2: #{test2}"
if test2 == true # result
  puts 'Pass.'
else
  puts 'Test failed.'
  return
end


puts "Part 2: #{part2(@input)}"
