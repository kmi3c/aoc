require 'pry'
# https://adventofcode.com/2022/day/7
#
# --- Part One ---
#
# ---------------------------------------------------------------
test = false
input = File.open("input#{test ? '_test' : ''}", 'rb').read.split('$')
input.shift

def create_reference_dir(current, dir_name)
  current[dir_name] = {}
  current[dir_name]['.'] = dir_name # leave self name up!
  current[dir_name]['..'] = current # leave reference up!
  current[dir_name]['size'] = 0
end

def gather_dir_tree(input)
  tree = {}
  current = tree #reference
  input.each do |io|
    command, *output = io.split("\n")
    puts "$#{command}"
    command_type, arg = command.split(' ')
    case command_type
      when 'cd'
        if arg != '..'
          create_reference_dir(current, arg)
          current = current[arg] # change reference
        else
          current = current[arg] # change reference
        end
      when 'ls'
    end
    if output.any?
      output.map{|o| o.split(' ')}.each do |dir_or_file_size, name|
        puts "#{dir_or_file_size} #{name}"
        if(dir_or_file_size == 'dir')
          create_reference_dir(current, name)
        else
          current[name] = dir_or_file_size.to_i
          add_size_to_branch(current, dir_or_file_size.to_i)
        end
      end
    end
  end
  tree
end

def add_size_to_branch(current, size)
  return if current.nil? || current['size'].nil?
  current['size'] += size
  add_size_to_branch(current['..'], size)
end

def calculate_size(tree, sizes = [])
  (tree.keys - ['..', '.']).each do |dir_or_file| # omit reference
    if(tree[dir_or_file].is_a?(Hash)) # Dir
      sizes.push(tree[dir_or_file]['size'])
      calculate_size(tree[dir_or_file], sizes)
    end
  end
  sizes
end

tree = gather_dir_tree(input)
sizes = calculate_size(tree)

puts "Part 1: #{
  sizes.filter{|s| s <= 100000 }.sum
}"
#
# --- Part Two ---
#
disk_size = 70000000
required_size = 30000000
free = required_size - (disk_size - tree['/']['size'])
puts "Part 2: #{
   sizes.filter {|s| s >= free }.min
}"
