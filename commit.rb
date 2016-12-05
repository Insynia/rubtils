#!/usr/bin/env ruby

##
#
# This script fetch the number of commits of each author passed as arg
# of the program
#
# TODO: Automatically retrieve the authors from a git log
#
##

require 'colorize'

c_h = Hash.new
ARGV.each do |av|
  c_h[av] = Integer(`git log | grep 'Author: #{av}' | wc -l`)
end

m_c = c_h.values.max
min_c = c_h.values.min
a_c = 0
c_h.each do |_, value|
  a_c += value
end
t_c = a_c
a_c /= c_h.count

puts "\n\n"
puts '-------------------------------------------------------------------------'
puts '------------------------------ General ----------------------------------'
puts '-------------------------------------------------------------------------'
puts

puts "Nombre total de commits: #{t_c}".yellow
print 'Moyenne de commit par personne : '.yellow
puts "#{a_c} (#{(t_c - m_c) / c_h.count} sans le 1er)".yellow
puts "Plus grand nombre de commits : #{m_c} (#{c_h.key(m_c)})".green
puts "Plus petit nombre de commits : #{min_c} (#{c_h.key(min_c)})".red

puts "\n\n"
puts '-------------------------------------------------------------------------'
puts '------------------------------ Personnal --------------------------------'
puts '-------------------------------------------------------------------------'
puts

i = 1
c_h2 = c_h.clone
while c_h2.count > 0
  max = c_h2.values.max
  print "#{i} - #{c_h2.key(max)} avec #{max} commits ("
  c_h2.delete(c_h2.key(max))
  percentage = max * 100 / t_c
  if percentage >= 15
    print "#{percentage}% du total".green
  elsif percentage >= 5
    print "#{percentage}% du total".yellow
  else
    print "#{percentage}% du total".red
  end
  if c_h2.count > 0
    diff = Float(max) / Float(c_h2.values.max)
    print diff >= 3 ? " soit #{diff.round(1)} fois plus que le suivant".green :
              " soit #{diff.round(1)} fois plus que le suivant"
  end
  puts ')'
  i += 1
end
