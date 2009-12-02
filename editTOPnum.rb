#!/usr/bin/ruby
require 'pp'

change = {}
open(ARGV[0]){|file| 
    ary = []
    while line = file.gets
        ary = line.split
        # thx Mr.@monjudou
        puts line.gsub(/[^\.]\d\d\d\d/){|s| s.to_i > 3034 ? s.to_i - 2 : s}
        #{$2.to_i > 3034 ? $1 + ($2.to_i - 2).to_s : $1+$2}
        #
  #      ary.each{|a|
  #          if a.to_i > 3034
  #              change["#{a}"] = (a.to_i - 2).to_s
  #          else
  #          end
  #      }
  #      change.each{|key, v|
  #      }
  #      puts line
  #      change = {}
    end
} 
