regex = /(?<head>->.*?)\s*(?<mid>\?\s+(?<condition>.*?(?=->|$))|->|$)(?<tail>.*$)/
active_filters = []

io = $stdin
if ARGV[0]
  io = File.open(ARGV[0])
end

io.each do |line|
  if line =~ /^\s*#\s*PATHFILTER:\s*"(.*?)"/
    active_filters = $1.split('|')
  end

  if (active_filters - ['NONE']).empty?
    puts line
    next
  end

  puts line.chomp.sub(regex) {|string|
    match = Regexp.last_match
    modified_line = string
    head = match[:head]
    mid = match[:mid]
    condition = match[:condition]
    if line !~ /# PATHFILTER APPLIED$/
      replacement = "? "
      if condition
        ors = condition.split(/\s+\|\s+/).map { |part| part.split(/\s+&\s+/) }
        replacement << active_filters.map { |filter|
          ors.map { |ands|
            [%Q(filename ^ "#{filter}"), *ands].join(' & ')
          }.join(' | ')
        }.join(' | ')
      else
        replacement << active_filters.map { |filter|
          %Q(filename ^ "#{filter}")
        }.join(' | ')
      end

      if condition
        modified_line.sub!(mid, replacement) unless condition =~ /[~\^]\s+""/
      else
        modified_line.sub!(head, head + " #{replacement}")
      end
      modified_line << " # PATHFILTER APPLIED"
    end
    modified_line
  }
end

io.close
