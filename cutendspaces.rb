#!/usr/bin/ruby

open(ARGV[0]){|file|
    while line = file.gets
        puts line.sub(/\s+\n$/,"\n")
    end
}
