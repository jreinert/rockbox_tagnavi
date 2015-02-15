regex = /(?<head>->.*?)\s*(?<mid>\?\s+(?<condition>.*?(?=->|$))|->|$)(?<tail>.*$)/
active_filters = []
$stdin.each do |line|
  if line =~ /^\s*#\s*PATHFILTER:\s*"(.*?)"/
    active_filters = $1.split('|')
  end
  puts line.chomp.sub(regex) {|string|
    match = Regexp.last_match
    modified_line = string
    mid = match[:mid]
    condition = match[:condition]
    if line !~ /# PATHFILTER APPLIED$/
      mid_replacement = "? "
      if condition
        ors = condition.split(/\s+\|\s+/).map { |part| part.split(/\s+&\s+/) }
        mid_replacement << active_filters.map { |filter|
          ors.map { |ands|
            [%Q(filename ^ "#{filter}"), *ands].join(' & ')
          }.join(' | ')
        }.join(' | ')
      else
        mid_replacement << active_filters.map { |filter|
          %Q(filename ^ "#{filter}")
        }.join(' | ')
      end

      modified_line.sub!(mid, mid_replacement)
      modified_line << " # PATHFILTER APPLIED"
    end
    modified_line
  }
end
