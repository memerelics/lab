#!/usr/bin/env ruby

aa1 = ARGV[0]; aa2 = ARGV[1]

monoA = File.open("#{aa1}#{aa2}a.pdb", "w")
monoB = File.open("#{aa1}#{aa2}b.pdb", "w")

flag = 0
File.open("#{aa1}-#{aa2}_no.pdb"){|dimerfile|
  while line = dimerfile.gets
    if flag == 0
      unless /TER/ =~ line
        monoA.puts line
      else
        monoA.puts "TER"
        monoA.puts "END"
        flag = 1
      end
    elsif flag == 1
      monoB.puts line
    end
  end
}
