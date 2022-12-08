require 'pry'
# https://adventofcode.com/2022/day/6
#
# --- Part One ---
#
cases1 = {
  mjqjpqmgbljsphdztnvjfqwrcgsmlb: 7,
  bvwbjplbgvbhsrlpgdmjqwftvncz: 5,
  nppdvjthqldpwncqszvftbrmjlhg: 6,
  nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: 10,
  zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: 11
}
def find_start(buffer, size = 4)
  b = buffer.chars
  start = b.shift(size-1)
  b.find.with_index do |char, i|
    u = start.push(char).uniq.size == size
    start.shift unless u
    u
  end
  buffer.index(start.join) + size
end
cases1.each do |buffer, expected|
  result = find_start(buffer.to_s)
  raise "WRONG #{result} != #{expected}" if result != expected
  puts "#{buffer}: #{result}"
end

input = File.open("input", 'rb').read
puts "Part 1: #{
  find_start(input)
}"
#
# --- Part Two ---
#
cases2 = {
  mjqjpqmgbljsphdztnvjfqwrcgsmlb: 19,
  bvwbjplbgvbhsrlpgdmjqwftvncz: 23,
  nppdvjthqldpwncqszvftbrmjlhg: 23,
  nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: 29,
  zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw:  26
}
def find_message(buffer)
  find_start(buffer, 14)
end
cases2.each do |buffer, expected|
  result = find_message(buffer.to_s)
  raise "WRONG #{result} != #{expected}" if result != expected
  puts "#{buffer}: #{result}"
end

puts "Part 2: #{
  find_message(input)
}"
