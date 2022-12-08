require 'pry'
# https://adventofcode.com/2022/day/8
#
# --- Part One ---
#
test = false
input = File.open("input#{test ? '_test' : ''}", 'rb').read.split("\n").map{|a| a.chars.map(&:to_i)}
tmap = []
def distance(trees, tree)
  trees[0..trees.map{|t| t < tree }.find_index(false)].size
end
puts "Part 1: #{
  visible = 0
  last_row = input.length-1
  last_col = input.first.length-1
  input.each.with_index do |trees, row|
    tmap.push(trees.map{|t| { t => ' .', d: 0}})
    trees.each.with_index do |tree, col|
      if(row == 0 || col == 0 || row == last_row || col == last_col)
        visible += 1
        tmap[row][col][tree] = ' ^'
      else
        col_trees = input.map{|a| a[col]}
        dirs = [
          col_trees[..row-1], # N
          trees[..col-1], # W
          trees[col+1..], # E
          col_trees[row+1..], # S
        ]
        distances = [
          distance(dirs[0].reverse, tree), # N
          distance(dirs[1].reverse, tree), # W
          distance(dirs[2], tree), # E
          distance(dirs[3], tree), # S
        ]
        tmap[row][col][:d] = distances.reduce(:*)
        if dirs.any?{|a| a.max < tree }
          visible += 1
          tmap[row][col][tree] = ' ^'
        else
          tmap[row][col][tree] = ' X'
        end
      end
    end
  end
  visible
}"
tmap.each{|r| puts r.map(&:values).join()} if test

#
# --- Part Two ---
#
puts "Part 2: #{
  tmap.map{|r| r.map{|t| t[:d] }}.flatten.max
}"
