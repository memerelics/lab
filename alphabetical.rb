#!/usr/bin/env ruby

ary = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L',
         'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y' ] 

ary.each{|a|
  ary.each{|b|
      if a <= b
          print "#{a}-#{b}", ", "
      end

  }
  print "\n"
}
