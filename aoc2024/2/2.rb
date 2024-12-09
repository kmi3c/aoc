require 'pry'
# https://adventofcode.com/2024/day/2
#
# --- Day 2:  Red-Nosed Reports ---
#
# Fortunately, the first location The Historians want to search isn't a long walk from the Chief Historian's
# office.
#
# While the Red-Nosed Reindeer nuclear fusion/fission plant appears to contain no sign of the Chief Historian,
# the engineers there run up to you as soon as they see you. Apparently, they still talk about the time Rudolph
# was saved through molecular synthesis from a single electron.
#
# They're quick to add that - since you're already here - they'd really appreciate your help analyzing some
# unusual data from the Red-Nosed reactor. You turn to check if The Historians are waiting for you, but they
# seem to have already divided into groups that are currently searching every corner of the facility.
# You offer to help with the unusual data.
#
# The unusual data (your puzzle input) consists of many reports, one report per line. Each report is a list of
# numbers called levels that are separated by spaces. For example:
#
# 7 6 4 2 1
# 1 2 7 8 9
# 9 7 6 2 1
# 1 3 2 4 5
# 8 6 4 4 1
# 1 3 6 7 9
#
# This example data contains six reports each containing five levels.
#
# The engineers are trying to figure out which reports are safe. The Red-Nosed reactor safety systems can only
# tolerate levels that are either gradually increasing or gradually decreasing. So, a report only counts as 
# safe if both of the following are true:
#
#     The levels are either all increasing or all decreasing.
#     Any two adjacent levels differ by at least one and at most three.
#
# In the example above, the reports can be found safe or unsafe by checking those rules:
#
#     7 6 4 2 1: Safe because the levels are all decreasing by 1 or 2.
#     1 2 7 8 9: Unsafe because 2 7 is an increase of 5.
#     9 7 6 2 1: Unsafe because 6 2 is a decrease of 4.
#     1 3 2 4 5: Unsafe because 1 3 is increasing but 3 2 is decreasing.
#     8 6 4 4 1: Unsafe because 4 4 is neither an increase or a decrease.
#     1 3 6 7 9: Safe because the levels are all increasing by 1, 2, or 3.
#
# So, in this example, 2 reports are safe.
#
# Analyze the unusual data from the engineers. How many reports are safe?
# --- Part 1 ---
@input = File.open('./input', 'rb').read
@test = "7 6 4 2 1\n1 2 7 8 9\n9 7 6 2 1\n1 3 2 4 5\n8 6 4 4 1\n1 3 6 7 9"

def read_input(input)
  input.split("\n").map{|lr| lr.split(' ').map(&:to_i)}
end

def report_increasing_or_decreasing(report)
  inc, dec = [],[]
  report.each.with_index do |n, i|
    next unless report[i+1]

    inc.push  n < report[i+1] && [1,2,3].include?(report[i+1] - n)
    dec.push  n > report[i+1] && [1,2,3].include?(n - report[i+1])
  end
  inc.compact!
  inc.uniq!
  inc = inc.size == 1 ? inc.first : false

  dec.compact!
  dec.uniq!
  dec = dec.size == 1 ? dec.first : false

  puts "#{report.to_s}, #{inc}, #{dec}"
  inc || dec
end

def find_safe_reports(input)
  reports = read_input(input)

  reports.select do |r|
    report_increasing_or_decreasing(r)
  end.size
end

test1 = find_safe_reports(@test) # 2
puts "Test 1: #{test1}"
if test1 == 2
  puts 'Pass.'
else
  puts 'Test failed.'
  return
end

puts "Part 1: #{find_safe_reports(@input)}"
#
# --- Part Two ---
#
# The engineers are surprised by the low number of safe reports until they realize they forgot to tell you
# about the Problem Dampener.
#
# The Problem Dampener is a reactor-mounted module that lets the reactor safety systems tolerate a single bad
# level in what would otherwise be a safe report. It's like the bad level never happened!
#
# Now, the same rules apply as before, except if removing a single level from an unsafe report would make it
# safe, the report instead counts as safe.
#
# More of the above example's reports are now safe:
#
#     7 6 4 2 1: Safe without removing any level.
#     1 2 7 8 9: Unsafe regardless of which level is removed.
#     9 7 6 2 1: Unsafe regardless of which level is removed.
#     1 3 2 4 5: Safe by removing the second level, 3.
#     8 6 4 4 1: Safe by removing the third level, 4.
#     1 3 6 7 9: Safe without removing any level.
#
# Thanks to the Problem Dampener, 4 reports are actually safe!
#
# Update your analysis by handling situations where the Problem Dampener can remove a single level from unsafe
# reports. How many reports are now safe?
def find_safe_reports_with_dampener(input)
  reports = read_input(input)

  reports.select do |r|
    report_increasing_or_decreasing(r) || (
      r.map.with_index{|_n,i| a = r.dup; a.delete_at(i); report_increasing_or_decreasing(a)}.include?(true)
    )
  end.size
end

test2 = find_safe_reports_with_dampener(@test)
puts "Test 2: #{test2}"
if test2 == 4
  puts 'Pass.'
else
  puts 'Test failed.'
  return
end


puts "Part 2: #{find_safe_reports_with_dampener(@input)}"
