#! /usr/bin/ruby
#
#   ---usage---
#
# > pdbmutator.rb PDBFILENAME TARGET_RSD MUTATION
#
#  <todo>
#    - when raw pdb is loaded, strip header and footer...

Names = { 'ALA' => 'A', 'CYS' => 'C', 'ASP' => 'D', 'GLU' => 'E',
          'PHE' => 'F', 'GLY' => 'G', 'HIS' => 'H', 'ILE' => 'I',
          'LYS' => 'K', 'LEU' => 'L', 'MET' => 'M', 'ASN' => 'N', 
          'PRO' => 'P', 'GLN' => 'Q', 'ARG' => 'R', 'SER' => 'S', 
          'THR' => 'T', 'VAL' => 'V', 'TRP' => 'W', 'TYR' => 'Y' }

if ARGV[0] == nil || ARGV[1] == nil || ARGV[2] == nil
	print("usage:"+"\n"+ 	
	"> pdbmutator.rb PDBFILENAME TARGET_RSD MUTATION")
	exit
end

require 'fileutils.rb'

filename = ARGV[0]
workfile = filename + "_tmp"
FileUtils.cp(filename, workfile)

target_rsd = ARGV[1].to_i
mutation = ARGV[2]

open(workfile){|a|

    residno = -1
    prev_residno = -2
    uni = File.open("#{filename}_#{target_rsd}to#{Names[mutation]}", "w")

########################    line loop start    ########################

    while line = a.gets
        column = line.split(/\s+/)

           ### a sample of read "column" ####
           ### ["ATOM", "12", "N", "MET", "A", "2", 
           ### "37.447", "16.947", "15.901", "1.00", "33.89", "N"]

        ### unless line is "TER" or "END"#
        if column[0] == "ATOM" then 
        
            ### Terminal resid names may be joined w/ the atom name.#
            ### In such a case, you need to fix it. #
            if column[2].length > 4 then
                tmpatom = column[2][0..2]
                tmpresidue = column[2][3..column[2].length]

                ### insert the "atom" in column[2] # 
                ###  and replace column[3] to the real resid.#
                column[2,0] = tmpatom 
                column[3] = tmpresidue
            end

        ### just a output ajustment.#
        ### inform the sequence now processing.#
        residno = column[5].to_i
        if residno != prev_residno
            print "#{residno}: #{column[3]}  "
            if (residno % 5 == 0) || residno == target_rsd
               print "\n" 
            end
        end
#######################################################################
######################## when target resid No. ########################
#######################################################################
        if residno == target_rsd 
             resid0 = column[3]
             line = line.sub(/#{resid0}/, "#{mutation}")
             puts "ATOM No. #{column[1]}: #{resid0} has been mutated to #{mutation}"
        end
#######################################################################
        end  # unless line is "TER" or "END"

        uni.puts <<-"EOB"
#{line.strip}
        EOB
        prev_residno = residno
    end
########################    line loop end     ########################
}
