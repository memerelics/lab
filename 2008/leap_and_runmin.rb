#!/usr/bin/env ruby
# for the sake of production of 3 top files (A, B, AB) and one crd file (AB)
# use this script in 1st folder. e.g. "$LL/N-X/n-n/1leap"

if ARGV[0] == nil || ARGV[1] == nil
  print "\n", "\n"
  puts "MY SYNTAX ERROR"
  puts "usage: analruby.rb AA1 AA2"
  print "\n", "\n"
  exit
end

aa1 = ARGV[0]; aa2 = ARGV[1]


%x{ 
  cp /work/thashimo/Next/leap_separate.rb .
  ruby leap_separate.rb #{aa1} #{aa2}
} unless File.exists?("#{aa1}#{aa2}a.pdb")


%x{
cat << EOF > leap.in
source leaprc.ff99
com = loadpdb #{aa1}-#{aa2}_no.pdb
saveamberparm com #{aa1}-#{aa2}_no.top #{aa1}-#{aa2}_no.crd
a = loadpdb #{aa1}#{aa2}a.pdb
saveamberparm a #{aa1}#{aa2}a.top #{aa1}#{aa2}a.crd
b = loadpdb #{aa1}#{aa2}b.pdb
saveamberparm b #{aa1}#{aa2}b.top #{aa1}#{aa2}b.crd
quit
EOF

tleap -f leap.in
}
%x{mkdir PDB} unless File.exists?("PDB")
%x{
  mv *.pdb PDB/
rm #{aa1}#{aa2}a.crd
rm #{aa1}#{aa2}b.crd
rm leap_separate.rb

cp #{aa1}-#{aa2}_no.crd ../2min/
cp #{aa1}-#{aa2}_no.top ../2min/
cp #{aa1}-#{aa2}_no.top ../3eq/
cp #{aa1}-#{aa2}_no.top ../4md/
cp *.top ../5mmpbsa/

echo "to 2min:    TOP and first CRD has been copied"
echo "to 3eq:     TOP has been copied"
echo "to 4md:     TOP has been copied"
echo "to 5mmpbsa: 3 TOPs has been copied"
}


%x{
  cd ../2min

cat << EOF > min.in
Minimization

&cntrl
 imin=1,
 maxcyc=15000,
 ncyc=1000,
 drms=0.001,
 cut=999,
 nsnb=25,
 ntpr=10,
 ntb=0, igb=1, gbsa=1,
 /

EOF
}
# change X-X according to input argments
if ARGV[2] == "2"
%x{
  cd ../2min
n1ge -mpi 2 -N AMB_min#{aa1}#{aa2} -g 1B070296 -q bes2 "sander -O -i min.in -o min#{aa1}#{aa2}.out -p #{aa1}-#{aa2}_no.top -c #{aa1}-#{aa2}_no.crd -r min#{aa1}#{aa2}.rst"
}
else
%x{
  cd ../2min
n1ge -mpi 4 -N AMB_min#{aa1}#{aa2} -g 1B070296 "sander -O -i min.in -o min#{aa1}#{aa2}.out -p #{aa1}-#{aa2}_no.top -c #{aa1}-#{aa2}_no.crd -r min#{aa1}#{aa2}.rst"
}
end
