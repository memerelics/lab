#!/usr/bin/env ruby

inputFileName = ARGV[0]
unless inputFileName =~ /M257Y/
    puts "this isn't data file of M257Y!"
    exit
end
inputFile = File.open(inputFileName)
#inputFile = File.open("asdf")


outputFile = File.open("ad_"+inputFileName, "w")
#outputFile = File.open("hjkl", "w")

counter = 0

while line = inputFile.gets
    if line.split[0] == "time/ns"
        outputFile.puts line
    elsif line.split[0].to_f < 2.0
        #counter = counter +1
        outputFile.printf("%12.7f  %10.7f\n", line.split[0].to_f, line.split[1].to_f)
    else
        outputFile.printf("%12.7f  %10.7f\n", 2.0 + (0.0004 * counter), line.split[1].to_f)
        counter = counter +1
    end
end

inputFile.close
outputFile.close
