require 'pry'
# https://adventofcode.com/2023/day/3
# --- Day 3: Gear Ratios ---
#
# You and the Elf eventually reach a gondola lift station; he says the gondola lift
# will take you up to the water source, but this is as far as he can bring you.
# You go inside.
#
# It doesn't take long to find the gondolas, but there seems to be a problem:
# they're not moving.
#
# "Aaah!"
#
# You turn around to see a slightly-greasy Elf with a wrench and a look of
# surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working right
# now; it'll still be a while before I can fix it." You offer to help.
#
# The engineer explains that an engine part seems to be missing from the engine,
# but nobody can figure out which one. If you can add up all the part numbers in
# the engine schematic, it should be easy to work out which part is missing.
#
# The engine schematic (your puzzle input) consists of a visual representation of
# the engine. There are lots of numbers and symbols you don't really understand,
# but apparently any number adjacent to a symbol, even diagonally, is
# a "part number" and should be included in your sum. 
#(Periods (.) do not count as a symbol.)
#
# Here is an example engine schematic:
#
# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..
#
# In this schematic, two numbers are not part numbers because they are not adjacent
# to a symbol: 114 (top right) and 58 (middle right). Every other number is 
# adjacent to a symbol and so is a part number; their sum is 4361.
#
# Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine schematic?
#
#
# Part 1
@input = File.open("#{__dir__}/input", 'rb').read
#@input = "467..114..\n...*......\n..35..633.\n......#...\n617*......\n.....+.58.\n..592.....\n......755.\n...$.*....\n.664.598.."
def draw_dmatrix(name = 'index')
  d = File.open("#{__dir__}/#{name}.html", 'wb')
  d.write "<style> a,i { background-color: grey; }\n .active{ background-color: blue }\nd { background-color: darkred; }\n r { background-color: salmon; }\nu { background-color: red; }\n l { background-color: deeppink; }\ntd { padding: 0; font-size: 1em; }</style>\n<table><tbody>"
  @dmatrix.each do |row|
    d.write "<tr><td>#{row.join('</td><td>')}</td></tr>"
  end
  d.write "</table></tbody>"
  d.close
end

def matrix
  @matrix ||= @input.split().map!(&:chars)
end

@dmatrix = @input.split().map!(&:chars)

def find_parts(reg)
  x,y = 0,0
  n = []
  matrix.each do |row|
    row.join.scan(reg) do |number|
      x = $~.offset(0)[0]
      no = yield(number, x, y)
      n << no
    end
    y +=1
  end
  n.flatten.sum
end

def adjacent(number, x, y)
  symbols = []
  # up
  if y > 0
    symbols << matrix[y-1][[x-1,0].max .. x+number.size]
    @dmatrix[y-1][[x-1,0].max .. x+number.size] = @dmatrix[y-1][[x-1,0].max .. x+number.size].map{|i| "<u>#{i}</u>"}
  end
  # left
  if x > 0
    symbols << matrix[y][x-1]
    @dmatrix[y][x-1] = "<l>#{@dmatrix[y][x-1]}</l>"
  end
  # right
  if x < matrix[y].size
    symbols << matrix[y][x+number.size]
    @dmatrix[y][x+number.size] = "<r>#{@dmatrix[y][x+number.size]}</r>"
  end
  # down
  if y < matrix.size - 1
    symbols << matrix[y+1][[x-1,0].max .. x+number.size]
    @dmatrix[y+1][[x-1,0].max .. x+number.size] = @dmatrix[y+1][[x-1,0].max .. x+number.size].map{|i| "<d>#{i}</d>"}
  end
  symbols
end

def adjacent_part(number, x, y)
  symbols = adjacent(number, x, y)
  a = symbols.flatten.join.scan(/[^a-zA-Z0-9.]/).any?
  @dmatrix[y][x .. x+number.size-1] = @dmatrix[y][x .. x+number.size-1].map{|i| "<i class=\"#{a ? 'active' : ''}\">#{i}</i>"}
  a ? number.to_i : 0
end
puts "Part 1: #{find_parts(/\d+/){ |n,x,y| adjacent_part(n,x,y) }}"# 4361 # 546563
draw_dmatrix('parts')
#
# --- Part Two ---
# The engineer finds the missing part and installs it in the engine! As the engine springs to life, you jump in the closest gondola, finally ready to ascend to the water source.
#
# You don't seem to be going very fast, though. Maybe something is still wrong? Fortunately, the gondola has a phone labeled "help", so you pick it up and the engineer answers.
#
# Before you can explain the situation, she suggests that you look out the window. There stands the engineer, holding a phone in one hand and waving with the other. You're going so slowly that you haven't even left the station. You exit the gondola.
#
# The missing part wasn't the only issue - one of the gears in the engine is wrong. A gear is any * symbol that is adjacent to exactly two part numbers. Its gear ratio is the result of multiplying those two numbers together.
#
# This time, you need to find the gear ratio of every gear and add them all up so that the engineer can figure out which gear needs to be replaced.
#
# Consider the same engine schematic again:
#
# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..
#
# In this schematic, there are two gears. The first is in the top left; it has part numbers 467 and 35, so its gear ratio is 16345. The second gear is in the lower right; its gear ratio is 451490. (The * adjacent to 617 is not a gear because it is only adjacent to one part number.) Adding up all of the gear ratios produces 467835.
#
def digits?(string)
  string.scan(/\d+/).any?
end

def left_d(x,y, el = 'l')
  l = matrix[y][0..[x,0].max].join.scan(/\d+/).last || ''
  @dmatrix[y][x-[l.size-1,1].max..x] = @dmatrix[y][x-[l.size-1,1].max..x].map{|i| "<#{el}>#{i}</#{el}>"}
  [l]
end

def right_d(x,y, el = 'r')
  r = matrix[y][x .. -1].join.scan(/\d+/).first || ''
  @dmatrix[y][x .. x+[r.size-1,1].max] = @dmatrix[y][x..x+[r.size-1,1].max].map{|i| "<#{el}>#{i}</#{el}>"}
  [r]
end

def adjacent_gear(g, x, y)
  up, left, right, down = adjacent(g, x, y)
  symbols = []
  # up
  if digits?(up.join)
    symbols << (
      (digits?(up.first) ? left_d(x-1,y-1, 'u') : []) +
      [matrix[y-1][x]] +
      (digits?(up.last) ? right_d(x+1,y-1, 'u') : [])
    )
  end
  # left
  if digits?(left)
    symbols << left_d(x-1,y)
  end
  # right
  if digits?(right)
    symbols << right_d(x+1,y)
  end
  # down
  if digits?(down.join)
    symbols << (
      (digits?(down.first) ? left_d(x-1,y+1, 'd') : []) +
      [matrix[y+1][x]] +
      (digits?(down.last) ? right_d(x+1,y+1, 'd') : [])
    )
  end

  ratios = symbols.map do |s|
    s.is_a?(Array) ? s.join.scan(/\d+/) : s.scan(/\d+/).last
  end
  ratios.flatten!.delete_if{|r| r.nil? || r.empty? }.map!(&:to_i)

  a = ratios.size == 2
  @dmatrix[y][x] = "<a class=\"#{a ? 'active' : ''}\" title=\"#{ratios.to_s}\">#{@dmatrix[y][x]}</a>"
  a ? ratios.reduce(&:*) : 0
end

@dmatrix = @input.split().map!(&:chars)
puts "Part 2: #{find_parts(/\*/){ |n,x,y| adjacent_gear(n,x,y) }}"# 467835 # 91031374
draw_dmatrix('gears')
