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
        # widen up each row map
        @tmap.each{|row| row[col] = nil } if col+steps > @tmap[row].length
        @tmap[row][col] = '.' #unless @tmap[row][col] == '#'
        steps.times do |right|
          @tmap[row][col+right] = '#' if right > 0
          @tmap[row][col+right+1] = 'H' unless @tmap[row][col+right+1] = '#'
        end
        col += steps
      when 'L'
        # widen up each map and adjust current col
        if col - steps < 0
  # CHECK
          @tmap.each.with_index{|row,i| @tmap[i] = Array.new(steps) + row }
          col += steps
        end
        steps.times do |left|
          @tmap[row][col-left] = '#' if left > 0
          @tmap[row][col-(left+1)] = 'H' unless @tmap[row][col-(left+1)] == '#'
        end
        col -= steps
      when 'U'
        @tmap[row][col] = '.' #unless @tmap[row][col] == '#'
        steps.times do |up|
          if row-(up+1) < 0
            @tmap[row][col] = '#' if up > 0
            @tmap.prepend(Array.new(@tmap[row].size))
            @tmap[row][col] = 'H' unless @tmap[row][col] == '#'
          else
            @tmap[row][col] = '#' if up > 0
            @tmap[row-(up+1)][col] = 'H' unless @tmap[row-(up+1)][col] == '#'
            row -= up+1
          end
        end
      when 'D'
        @tmap[row][col] = '.' #unless @tmap[row][col] == '#'
        steps.times do |down|
          if @tmap[row+(down+1)].nil?
            @tmap.push(Array.new(@tmap[row].size))
          end
          @tmap[row][col] = '#' if down > 0
          row += 1
          @tmap[row][col] = 'H' unless @tmap[row][col] == '#'
        end
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
