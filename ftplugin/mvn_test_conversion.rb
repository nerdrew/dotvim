#!/usr/bin/env ruby
# frozen_string_literal: true

paths = {}
failures = false
done = false

while (line = gets)
  if done
    puts line
    next
  end

  if failures
    if (match = line.match(/^  (\w+)\.([^:]*):(\d+)(.*)$/))
      puts "  #{paths[match[1]]}:#{match[3]} (#{match[2]})#{match[4]}"
    elsif line.match?(/^\s*$/)
      failures = false
      puts
    else
      puts line
    end
    next
  end

  if (match = line.match(/<<< FAILURE! - in ([\.\w]+?)([^\.\s]+)$/))
    path = 'src/test/java/' + match[1].gsub('.', '/')
    file = match[2]
    paths[file] = path + file + '.java'
  elsif (match = line.match(/^(Failed tests)|(Tests in error):$/))
    failures = true
    puts line
  else
    puts line
  end
end
