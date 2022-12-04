require 'pry'
# Part 1
input = File.open('input', 'rb').read
input_array = input.split("\n")
# Sample array:
# input_array = [
# '#1 @ 1,3: 4x4',
# '#2 @ 3,1: 4x4',
# '#3 @ 5,5: 2x2'
# ]
input_array.map! do |row|
  row.match(/#(\d+) @ (\d+,\d+): (\d+x\d+)/)[1..3]
end.map do |data|
  data[0] = data[0].to_i
  data[1] = data[1].split(',').map(&:to_i)
  data[2] = data[2].split('x').map(&:to_i)
end
size = 1000
fabric_taken = Array.new(size, Array.new(size, 0))
conflicted = 0
input_array.each do |claim|
  row_range = (claim[1][0]..(claim[1][0] + claim[2][0] - 1))
  rows_to_take = (claim[1][1]..(claim[1][1] + claim[2][1] - 1)).to_a
  # check rows if are taken
  rows_to_take.each do |row_number|
    fabric_taken[row_number] = fabric_taken[row_number].map.with_index { |cell, i| row_range.include?(i) ? cell += 1 : cell }
  end
end
conflicted = fabric_taken.collect { |row| row.select { |v| v >= 2 }.size }.reduce(:+)
puts "Part 1: #{conflicted}"

# Part 2
# input_array =
#
match = nil
input_array.detect do |id|
end
puts "Part 2: #{match}"
