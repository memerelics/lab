#!/bin/bash
# for the sake of production of 3 top files (A, B, AB) and one crd file (AB)
# use this script in 1st folder. e.g. "$LL/N-X/n-n/1leap"

if [ $# -lt 2 ];then
echo "usage: this.sh firstAA secondAA"
exit 1
fi

cat << EOF > leap_separate.rb
#!/usr/bin/env ruby

aa1 = "$1"
aa2 = "$2"

monoA = File.open("$1$2a.pdb", "w")
monoB = File.open("$1$2b.pdb", "w")

flag = 0
File.open("$1-$2_no.pdb"){|dimerfile|
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
EOF

ruby leap_separate.rb $1 $2



cat << EOF > leap.in
source leaprc.ff99
com = loadpdb $1-$2_no.pdb
saveamberparm com $1-$2_no.top $1-$2_no.crd
a = loadpdb $1$2a.pdb
saveamberparm a $1$2a.top $1$2a.crd
b = loadpdb $1$2b.pdb
saveamberparm b $1$2b.top $1$2b.crd
quit
EOF

tleap -f leap.in

mkdir PDB
mv *.pdb PDB/
rm $1$2a.crd
rm $1$2b.crd
rm leap_separate.rb

cp $1-$2_no.crd ../2min/
cp $1-$2_no.top ../2min/
cp $1-$2_no.top ../3eq/
cp $1-$2_no.top ../4md/
cp *.top ../5mmpbsa/

echo "to 2min:    TOP and first CRD has been copied"
echo "to 3eq:     TOP has been copied"
echo "to 4md:     TOP has been copied"
echo "to 5mmpbsa: 3 TOPs has been copied"



cd ../2min

cat << EOF > min.in
Minimization

&cntrl
 imin=1,
 maxcyc=15000,
 ncyc=1000,
 cut=999,
 nsnb=25,
 ntpr=10,
 ntb=0, igb=1, gbsa=1,
 /

EOF

# change X-X according to input argments
n1ge -mpi 4 -N AMB_min"$1""$2" -g 1B070296 "sander -O -i min.in -o min"$1""$2".out -p "$1"-"$2"_no.top -c "$1"-"$2"_no.crd -r min"$1""$2".rst"
