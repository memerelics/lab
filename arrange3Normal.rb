#!/usr/bin/env ruby

inputFileName = ARGV[0]
inputFile = File.open(inputFileName)

outputFile = File.open("ad_"+inputFileName, "w")

counter = 0
skip = "on"

while line = inputFile.gets
    if line.split[0] == "time/ns"
        outputFile.puts line
    elsif line.split[0].to_f < 2.0
        outputFile.printf("%12.7f  %10.7f\n", line.split[0].to_f, line.split[1].to_f)
    elsif skip == "on"
        #don't write line
        skip = "off"
    else #skip == "off"
        outputFile.printf("%12.7f  %10.7f\n", line.split[0].to_f, line.split[1].to_f)
        skip = "on"
    end
end

inputFile.close
outputFile.close
