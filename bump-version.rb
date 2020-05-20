#!/usr/bin/env ruby

if ARGV.length != 2
    STDERR.puts "Usage: #{$0} <old_version> <new_version>"
    STDERR.puts "Example: #{$0} 4.10 4.12"
    exit 1
end

old_version, new_version = ARGV

Dir.chdir File.dirname(__FILE__)+"/source"

Dir['**/*'].each do |file|
    next unless File.file? file

    skip = false
    %w(_ conf.py release_notes/ locale/ images/ ext/ toc.html opennebula-white.png).each do |d|
        if file.start_with?(d)
            skip = true
            break
        end
    end
    next if skip

    text = File.read(file)
    text_original = text.clone

    text.gsub!(old_version, new_version)

    if text != text_original
        puts "* Changing: #{file}"
        File.open(file,'w'){|f| f.write(text)}
    end
end

puts
puts "*** Remember to update conf.py***"
puts
