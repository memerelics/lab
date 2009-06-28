#!/usr/bin/env ruby

gcn4 = "rmkqledkveellsknyhlenevarlkklvg" 
gcn4_rv = gcn4.reverse 
linker = "gsaggsggggsggggssggg"

backbone = gcn4.sub(/n/, "X")
aminoacids = [ "a", "c", "d", "e", "f", "g", "h", "i", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "y" ]

h = Hash.new

aminoacids.each{|aa| peptideX_name = "peptide_#{aa.upcase}"
		     peptideX = backbone.sub(/X/, aa)	
print peptideX_name, " : ", peptideX, "\n"
}

#p gcn4 + linker + gcn4_rv
