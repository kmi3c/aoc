require 'pry'
# Part 1
input = File.open('input', 'rb').read
input_array = input.split("\n")
# Sample array:
# input_array = %w(abcdef bababc abbcde abcccd aabcdd abcdee ababab )
twos = 0
threes = 0
input_array.each do |fabric|
  two = true
  three = true
  fa = fabric.chars
  fa.uniq.each do |char|
    count = fa.count(char)
    if count == 2 && two
      twos += 1
      two = false
    end
    if count == 3 && three
      threes += 1
      three = false
    end
  end
end
puts "Part 1: #{twos * threes}"

# Part 2
# input_array =
# %w(abcde fghij klmno pqrst fguij axcye wvxyz)
# input_matrix = input_array.map(&:chars).transpose
match = nil
input_array.detect do |id|
  input_array.detect do |c_id|
    if (id.chars - c_id.chars).size == 1
      if id.chars.size - [id.chars, c_id.chars].transpose.select { |diff| diff.uniq.size == 1 }.size == 1
        match = [id, c_id]
        true
      else
        false
      end
    else
      false
    end
  end
end

puts "Part 2: #{match}"
