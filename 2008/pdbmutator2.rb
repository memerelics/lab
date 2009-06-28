#!/usr/bin/env ruby

ary = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L',
  'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y' ] 

ary.each{|a|
  %[
  cp mono.pdb mono#{a}.pdb
  ./pdbmutator.rb mono#{a}.pdb 15 "#{a}"
  ./pdbmutator.rb mono#{a}.pdb 16 "#{a}"

]
}


  i = 1
  aa_ary.each{|first|
    %x[
    mkdir #{first}-X
    ]
    aa_ary2.each{|second|

      %x[
      mkdir #{first}-X/#{first.downcase}-#{second.downcase}
      mkdir #{first}-X/#{first.downcase}-#{second.downcase}/1leap
      mkdir #{first}-X/#{first.downcase}-#{second.downcase}/2min
      mkdir #{first}-X/#{first.downcase}-#{second.downcase}/3eq
      mkdir #{first}-X/#{first.downcase}-#{second.downcase}/4md
      mkdir #{first}-X/#{first.downcase}-#{second.downcase}/5mmpbsa
      
      ]
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

