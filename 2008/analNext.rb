#!/usr/bin/env ruby

if ARGV[0] == nil || ARGV[1] == nil
  print "\n", "\n"
  puts "MY SYNTAX ERROR"
  puts "usage: analruby.rb AA1 AA2"
  print "\n", "\n"
  exit
end

aa1 = ARGV[0]; aa2 = ARGV[1]

# declear total atoms of each monomers.
h = {
  "numA" => 522, "numC" => 524, "numD" => 526, "numE" => 532, "numF" => 542, "numG" => 516, "numH" => 536, "numI" => 540, 
  "numK" => 546, 
  "numL" => 540, "numM" => 536, "numN" => 530, "numP" => 530, "numQ" => 536, "numR" => 550, "numS" => 524, "numT" => 530, "numV" => 534, "numW" => 550, "numY" => 544
}

numATOMS1 = h["num#{aa1}"]
numATOMS2 = h["num#{aa2}"]
numTOTAL = h["num#{aa1}"] + h["num#{aa2}"]


if File.exist?("#{aa1}-#{aa2}_no.top") == false || File.exist?("#{aa1}#{aa2}a.top") == false || File.exist?("#{aa1}#{aa2}b.top") == false 
  puts "MY SYNTAX ERROR"
  puts "there aren't top files for ptraj"
  exit
end

if File.exists?("md#{aa1}#{aa2}.mdcrd")  == false && File.exists?("md#{aa1}#{aa2}.mdcrd.gz") == false
  %x{mv ../4md/md#{aa1}#{aa2}.mdcrd .}
end
%x{gunzip md#{aa1}#{aa2}.mdcrd.gz} if File.exists?("md#{aa1}#{aa2}.mdcrd.gz")

%x{
  cat << EOF > ptraj#{aa1}#{aa2}.in
  trajin md#{aa1}#{aa2}.mdcrd 1 2000
  average md#{aa1}#{aa2}-AvStruc.pdb pdb

  rms first out CA_md#{aa1}#{aa2}.rmsd @CA
  rms previous out CA_prev_md#{aa1}#{aa2}.rmsd @CA
  rms first out CACN_md#{aa1}#{aa2}.rmsd @CA,C,N


  distance hoge :1-31 :32-62 out distMonomer_md#{aa1}#{aa2}.dat
  distance hogehoge :16@CA :47@CA out distcoreCA_md#{aa1}#{aa2}.dat
  distance hogehogehoge :16 :47 out distcoreRESID_md#{aa1}#{aa2}.dat
  go
  EOF
}
%x{
  cat << EOF > rmsdAv#{aa1}#{aa2}.in
  trajin md#{aa1}#{aa2}.mdcrd 1 2000
  reference md#{aa1}#{aa2}-AvStruc.pdb
  rms reference out fromAvCA_md#{aa1}#{aa2}.rmsd @CA
  go
  EOF
}
%x{mkdir output_ptraj} unless File.exists?("output_ptraj")

%x{
  ptraj #{aa1}-#{aa2}_no.top < ptraj#{aa1}#{aa2}.in > ptraj#{aa1}#{aa2}.log

  ptraj #{aa1}-#{aa2}_no.top < rmsdAv#{aa1}#{aa2}.in > ptraj_rmsdAv#{aa1}#{aa2}.log

  mv *AvStruc.pdb output_ptraj
  mv *.rmsd output_ptraj
  mv *.dat output_ptraj
  cp output_ptraj/* /work/thashimo/Next/ptraj/
}


%x{ mkdir snapshots } unless File.exists?("snapshots/") 

puts "","", "Executing MM-PB/GBSA calc using imp9 parm...", "","" 

%x{ cp /work/thashimo/Next/mm_pbsa.gbsaNext.in.proto .  } unless File.exists?("mm_pbsa.gbsaNext.in.proto")

%x{gunzip md#{aa1}#{aa2}.mdcrd.gz} if File.exists?("md#{aa1}#{aa2}.mdcrd.gz")

# edit the prototype file and create new input file by substituting mutatnt names and the number of atoms
open("mm_pbsa.gbsaNext.in.proto"){|inputfile|

  newfile = File.open("mm_pbsa.gbsaNext.in" , "w")

  while line = inputfile.gets

    line = line.gsub(/XAA1/, "#{aa1}")
    line = line.gsub(/XAA2/, "#{aa2}")

    line = line.gsub(/XnumATOMS10/, (numATOMS1+1).to_s)
    line = line.gsub(/XnumATOMS1/, numATOMS1.to_s)
    line = line.gsub(/XnumATOMS2/, numATOMS2.to_s)
    line = line.gsub(/XnumTOTAL/, numTOTAL.to_s)

    newfile.puts line

  end
}

# run "mm_pbsa.pl" as a background job, allowing it to be continued after the log out.
%x{
  nohup mm_pbsa.pl mm_pbsa.gbsaNext.in > mm_pbsaNext.log &
  rm mm_pbsa.gbsaNext.in.proto
}
