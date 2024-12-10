require 'pry'
# https://adventofcode.com/2024/day/
#
# --- Day 4: Ceres Search ---
#
# "Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it.
#  After a brief flash, you recognize the interior of the Ceres monitoring station!
#
# As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt;
# she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.
#
# This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words.
# It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them.
# Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:
#
# ..X...
# .SAMX.
# .A..A.
# XMAS.S
# .X....
#
# The actual word search will be full of letters instead. For example:
#
# MMMSXXMASM
# MSAMXMSMSA
# AMXSXMAAMM
# MSAMASMSMX
# XMASAMXAMM
# XXAMMXXAMA
# SMSMSASXSS
# SAXAMASAAA
# MAMMMXMMMM
# MXMXAXMASX
#
# In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS
# have been replaced with .:
#
# ....XXMAS.
# .SAMXMS...
# ...S..A...
# ..A.A.MS.X
# XMASAMX.MM
# X.....XA.A
# S.S.S.S.SS
# .A.A.A.A.A
# ..M.M.M.MM
# .X.X.XMASX
#
# Take a look at the little Elf's word search. How many times does XMAS appear?

@input = File.open('./input', 'rb').read
@test = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

def word
  %w(X M A S)
end

def print_found(found)
  puts "===\n"
  found.each do |row|
    puts row.join
  end
  puts "===\n"
end

def build_matrix(input)
  input.split("\n").map(&:chars)
end

def check_left(matrix,y,x,found)
  from = x - (word.size-1)
  return false if from < 0

  f = matrix[y][from..x] == word.reverse
  if f
    found[y][from..x] = word.reverse
  end
  f
end

def check_right(matrix,y,x,found)
  to = x + (word.size-1)
  return false if to > matrix[y].size - 1

  f = matrix[y][x..to] == word
  if f
    found[y][x..to] = word
  end
  f
end

def check_up(matrix,y,x,found)
  from = y - (word.size-1)
  return false if from < 0
  f = matrix[from..y].map{|r| r[x]} == word.reverse
  if f
    found[from..y].each.with_index{|r,i| r[x] = word.reverse[i]}
  end
  f
end

def check_down(matrix,y,x,found)
  to = y + (word.size-1)
  return false if to > (matrix.size - 1)
  f = matrix[y..to].map{|r| r[x]} == word
  if f
    found[y..to].each.with_index{|r,i| r[x] = word[i]}
  end
  f
end

def check_up_left(matrix,y,x,found)
  from_y = y - (word.size-1)
  return false if from_y < 0
  from_x = x - (word.size-1)
  return false if from_x < 0
  f = matrix[from_y..y].map.with_index{|r,i| r[from_x + i]} == word.reverse
  if f
    found[from_y..y].map.with_index{|r,i| r[from_x + i] = word.reverse[i] }
  end
  f
end

def check_down_left(matrix,y,x,found)
  to_y = y + (word.size-1)
  return false if to_y > (matrix.size - 1)
  from_x = x - (word.size-1)
  return false if from_x < 0
  f = matrix[y..to_y].map.with_index{|r,i| r[x - i]} == word
  if f
    found[y..to_y].map.with_index{|r,i| r[x - i] = word[i] }
  end
  f
end

def check_up_right(matrix,y,x,found)
  to_x = x + (word.size-1)
  return false if to_x > matrix[y].size - 1
  from_y = y - (word.size-1)
  return false if from_y < 0

  f = matrix[from_y..y].map.with_index{|r,i| r[to_x - i]} == word.reverse
  if f
    found[from_y..y].map.with_index{|r,i| r[to_x - i] = word.reverse[i] }
  end
end

def check_down_right(matrix,y,x,found)
  to_y = y + (word.size-1)
  return false if to_y > (matrix.size - 1)
  to_x = x + (word.size-1)
  return false if to_x > matrix[y].size - 1

  f = matrix[y..to_y].map.with_index{|r,i| r[x + i]} == word
  if f
    found[y..to_y].map.with_index{|r,i| r[x + i] = word[i] }
  end
end



def part1(input)
  matrix = build_matrix(input)
  print_found(matrix)
  count = 0
  width = matrix.first.size - 1
  height = matrix.size - 1
  x,y = 0,0
  found = Array.new(width + 1) { Array.new(height + 1, '.') }
  matrix.each do |row|
    row.each do |char|
      if char == word.first
        # check all directions
        count +=1 if check_left(matrix,y,x,found)
        count +=1 if check_right(matrix,y,x,found)
        count +=1 if check_up(matrix,y,x,found)
        count +=1 if check_down(matrix,y,x,found)
        count +=1 if check_up_left(matrix,y,x,found)
        count +=1 if check_down_left(matrix,y,x,found)
        count +=1 if check_up_right(matrix,y,x,found)
        count +=1 if check_down_right(matrix,y,x,found)
      end
      # end of row?
      if x == width
        x = 0
        y += 1
      else
        x += 1
      end
    end
  end
  print_found(found)
  count
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
