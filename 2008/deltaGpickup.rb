#! /usr/bin/env ruby

require 'csv'

deltaGary = []
File.readlines("NN_gb_com.all.out").each{|line|
  egbmatch = /EGB/.match(line)
  if line =~ /EGB/
    deltaG = egbmatch.post_match.strip.sub!("=", "").strip
    deltaGary << deltaG.to_i
  end
}

  picosecond = 0
CSV.generate("output.csv", ?, ){|writer|
  deltaGary.each{|value|
  writer << [picosecond, value]
  picosecond = picosecond + 10
  }
}
