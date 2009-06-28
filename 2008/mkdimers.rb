#! /usr/bin/env ruby
#
#  create a new pdb file from two files.
#  20 * 20 = 400 types

aa_ary = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L',
       'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y' ] 
aa_ary2 = aa_ary
i = 1
aa_ary.each{|first|
	aa_ary2.each{|second|

		first_file = "./1leap#{first}/Aa_no.pdb_16to#{first}"
		second_file = "./1leap#{second}/AB_no.pdb_16to#{second}"

		dimer = File.open("./dimers/#{first}-#{second}_no.pdb", "w")

		File.open(first_file) {|aa1|
			File.open(second_file){|aa2|
				while line1 = aa1.gets 
					unless /END/ =~ line1
						dimer.puts line1
					end 
				end 
				while line2 = aa2.gets 
					dimer.puts line2 
				end 
				puts "Loop #{i}/400: #{first}-#{second}" 
				i = i +1
			} 
		}
	}
}
