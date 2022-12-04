require 'pry'
# Part 1
input = File.open('input', 'rb').read
input_array = input.split("\n").map(&:to_f)
puts "Part 1: #{input_array.reduce(:+)}"

# Part 2
frequencies = [0]
current_freq = 0
match = nil
it = 0
# input_array =
# [1,-1]
# [3, 3, 4, -2, -4 ]#  first reaches 10 twice.
# [-6, 3, 8, 5, -6 ]#  first reaches 5 twice.
# [7, 7, -2, -7, -4]#  first reaches 14 twice.
while match.nil?
  input_array.collect do |freq_change|
    current_freq += freq_change
    if frequencies.include?(current_freq)
      match = current_freq
      break
    else
      frequencies << current_freq
    end
  end
  it += 1
  puts "#{it}: #{frequencies.size}"
end
puts "Part 2: #{match}"
