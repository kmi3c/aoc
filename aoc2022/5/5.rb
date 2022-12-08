require 'pry'
# https://adventofcode.com/2022/day/5
#
# --- Part One ---
#
# --- Day 5: Supply Stacks ---
#
# The expedition can depart as soon as the final supplies have been unloaded from the ships.
# Supplies are stored in stacks of marked crates, but because the needed supplies are buried under many other
# crates, the crates need to be rearranged.
#
# The ship has a giant cargo crane capable of moving crates between stacks.
# To ensure none of the crates get crushed or fall over, the crane operator will rearrange them in a
# series of carefully-planned steps. After the crates are rearranged, the desired crates will be at the
# top of each stack.
#
# The Elves don't want to interrupt the crane operator during this delicate procedure, but they forgot
# to ask her which crate will end up where, and they want to be ready to unload them as soon as possible
# so they can embark.
#
# They do, however, have a drawing of the starting stacks of crates and the rearrangement procedure
# (your puzzle input). For example:
#
#     [D]    
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 
#
# move 1 from 2 to 1
# move 3 from 1 to 3
# move 2 from 2 to 1
# move 1 from 1 to 2
#
# In this example, there are three stacks of crates.
# Stack 1 contains two crates:
# crate Z is on the bottom, and crate N is on top.
# Stack 2 contains three crates;
# from bottom to top, they are crates M, C, and D.
# Finally, stack 3 contains a single crate, P.
#
# Then, the rearrangement procedure is given. In each step of the procedure,
# a quantity of crates is moved from one stack to a different stack.
#In the first step of the above rearrangement procedure, one crate is moved from stack 2 to stack 1,
# resulting in this configuration:
#
# [D]        
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 
#
# In the second step, three crates are moved from stack 1 to stack 3.
#Crates are moved one at a time, so the first crate to be moved (D) ends up below the second and third crates:
#
#         [Z]
#         [N]
#     [C] [D]
#     [M] [P]
#  1   2   3
#
# Then, both crates are moved from stack 2 to stack 1. Again, because crates are moved one at a time,
# crate C ends up below crate M:
#
#         [Z]
#         [N]
# [M]     [D]
# [C]     [P]
#  1   2   3
#
# Finally, one crate is moved from stack 1 to stack 2:
#
#         [Z]
#         [N]
#         [D]
# [C] [M] [P]
#  1   2   3
#
# The Elves just need to know which crate will end up on top of each stack;
# in this example, the top crates are C in stack 1, M in stack 2, and Z in stack 3,
# so you should combine these together and give the Elves the message CMZ.
#
# After the rearrangement procedure completes, what crate ends up on top of each stack?
#
def draw_magazine(magazine, racks)
  rack_height = magazine.map(&:length).max
  m = magazine.map(&:dup)
  m.map{|r|
    r[rack_height-1] = nil if r.length != rack_height
    r
  }.map(&:reverse).transpose.each{|racks_level| puts racks_level.map{|package| package.nil? ? '   ' : "[#{package}]" }.join(' ')}
  puts racks.times.map{|t| " #{t+1} " }.join(' ')
end

def prepare_magazine_and_input
  test = false
  input = File.open("input#{test ? '_test' : ''}", 'rb').readlines
  divide = input.find_index("\n")
  magazine = input.shift(divide)
  racks = magazine.pop.strip.split(' ').map(&:to_i).max
  inc = 0
  rack_level_map = racks.times.map{|r| a = [inc, inc+2]; inc +=4; a}
  magazine.map!{|racks_level|
    rack_level_map.map{|r|
      v = racks_level[r[0]..r[1]].gsub(/(\[|\])/,'').strip
      v.empty? ? nil: v
    }
  }
  magazine = magazine.reduce(&:zip).map(&:flatten).map(&:reverse).map{|r| r.delete_if(&:nil?)}
  input.shift(1) # empty line
  draw_magazine(magazine, racks)
  return [magazine, racks, input]
end

magazine, racks, input = prepare_magazine_and_input
input.each do |move|
  puts move
  hmany, from, to = move.strip.split(' ').map(&:to_i).delete_if{|e| e.zero?}
  hmany.times do |m|
    package = magazine[from-1].pop
    puts " * (#{m+1}) move #{package} to #{to}"
    magazine[to-1].push(package)
    draw_magazine(magazine, racks)
  end
end
puts "Part 1: #{
 magazine.map(&:reverse).map(&:join).map{|a| a[0]}.join()
}"
#
# --- Part Two ---
#
# As you watch the crane operator expertly rearrange the crates, you notice the process isn't following
# your prediction.
#
# Some mud was covering the writing on the side of the crane, and you quickly wipe it away.
# The crane isn't a CrateMover 9000 - it's a CrateMover 9001.
#
# The CrateMover 9001 is notable for many new and exciting features: air conditioning, leather seats, an extra
# cup holder, and the ability to pick up and move multiple crates at once.
#
# Again considering the example above, the crates begin in the same configuration:
#
#     [D]    
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 
# 
# Moving a single crate from stack 2 to stack 1 behaves the same as before:
#
# [D]        
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 
#
# However, the action of moving three crates from stack 1 to stack 3 means that those three moved crates stay 
#in the same order, resulting in this new configuration:
#
#         [D]
#         [N]
#     [C] [Z]
#     [M] [P]
#  1   2   3
#
# Next, as both crates are moved from stack 2 to stack 1, they retain their order as well:
#
#         [D]
#         [N]
# [C]     [Z]
# [M]     [P]
#  1   2   3
#
# Finally, a single crate is still moved from stack 1 to stack 2, but now it's crate C that gets moved:
#
#         [D]
#         [N]
#         [Z]
# [M] [C] [P]
#  1   2   3
#
# In this example, the CrateMover 9001 has put the crates in a totally different order: MCD.
#
# Before the rearrangement process finishes, update your simulation so that the Elves know where they should
# stand to be ready to unload the final supplies.
# After the rearrangement procedure completes, what crate ends up on top of each stack?
#
magazine, racks, input = prepare_magazine_and_input
input.each do |move|
  hmany, from, to = move.strip.split(' ').map(&:to_i).delete_if{|e| e.zero?}
  package = magazine[from-1].pop(hmany)
  puts " * move (#{hmany})#{package} to #{to}"
  magazine[to-1].concat(package)
  draw_magazine(magazine, racks)
end

puts "Part 2: #{
  magazine.map(&:reverse).map(&:join).map{|a| a[0]}.join()
}"
