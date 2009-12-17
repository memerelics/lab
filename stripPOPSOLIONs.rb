#!/usr/bin/ruby

outFileName = ARGV[0].sub("\.pdb", "") + "_bare.pdb"
outFile = File.open(outFileName, "w")

pdbFull = File.open(ARGV[0])
while line = pdbFull.gets
    unless line =~ /(POP|SOL|Cl|Na)/ 
        outFile.puts(line)
    end
end
pdbFull.close
outFile.close

#puts ARGV[0].sub("\.pdb", "") + "_bare.pdb"
