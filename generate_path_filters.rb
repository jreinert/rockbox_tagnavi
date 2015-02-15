#!/usr/bin/env ruby

puts "Generating path filter(s). Use `|` as separator for multiple paths (unquoted). Type in `NONE` for no filter (unquoted)"

last_filter = nil
files = ARGV.empty? ? Dir['**/menu.config'] : ARGV

files.each do |menu|
  print "Path filter for #{menu}"
  print " (#{last_filter})" if last_filter
  print ": "
  filter = STDIN.gets.strip
  filter = last_filter if filter.empty?
  last_filter = filter
  filename = File.join(File.dirname(menu), '.pathfilter')
  File.write(filename, %Q(# PATHFILTER: "#{filter}"\n))
end
