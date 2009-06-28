#!/usr/bin/env ruby
# this script allow you to search folders and copy "statistics.out" to here if it exists and yet to be collected.

aa_ary = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L',
'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y' ] 
aa_ary2 = aa_ary

aa_ary.each{|first|
  aa_ary2.each{|second|
    if first <= second
      if File.exists?("/work/thashimo/Next/#{first}-X/#{first.downcase}-#{second.downcase}/")
        if File.exists?("#{first}#{second}_gbNext_statistics.out") == false && File.exists?("/work/thashimo/Next/#{first}-X/#{first.downcase}-#{second.downcase}/5mmpbsa/#{first}#{second}_gbNext_statistics.out")
          %x{ cp /work/thashimo/Next/#{first}-X/#{first.downcase}-#{second.downcase}/5mmpbsa/#{first}#{second}_gbNext_statistics.out .}
        end
      end
    end
  }
}

