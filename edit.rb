#!/usr/bin/env ruby


File.open(ARGV[0]){|input|
	File.open(ARGV[1], "w"){|output|
		i = 1
		while line = input.gets
			if line =~ /^ATOM/
				space = (" "*(7-i.to_s.length)) 
				line = line.sub(/^ATOM(\s+)(\d+)/, "ATOM" + space + i.to_s)
				output.puts(line)
				i += 1
			else
				output.puts(line)
			end
		end
	}
}
