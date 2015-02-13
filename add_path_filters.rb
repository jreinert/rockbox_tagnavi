active_filter = nil
$stdin.each do |line|
  if line =~ /^\s*#\s*PATHFILTER:\s*"(.*?)"/
    active_filter = $1
  end
  puts line.chomp.sub(/(->.*?)\s*(\?|->|$)/) {|match|
    modified_line = match
    head = $1
    tail = $2
    if line !~ /filename \^ "/
      modified_line = %Q(#{head} ? filename ^ "#{active_filter}")
      case(tail)
      when '?' then modified_line << ' &'
      when '->' then modified_line << ' ->'
      else ''
      end
    end
    modified_line
  }
end
