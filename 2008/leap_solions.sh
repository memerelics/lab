#! /bin/bash

aa_ary=("A" "C" "D" "E" "F" "G" "H" "I" "K" "L" "M" "N" "P" "Q" "R" "S" "T" "V" "W" "Y")


#
#tleap -s -f leaprc.ff99
#a = loadpdb "#{aa}-X/#{aa}-#{bb}_no.pdb"
#saveamberparm a "#{aa}-#{bb}_no.top" "#{aa}-#{bb}_no.crd"
#addions a Cl- 0
#solvatebox a TIP3PBOX 10.0
#saveamberparm a "#{aa}-#{bb}_solions.top" "#{aa}-#{bb}_solions.crd"
#savepdb a #{aa}-#{bb}_solions.pdb

for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19; do
	for k in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19; do
#		mkdir "./${aa_ary[i]-X/${aa_ary[i]}-${aa_ary[k]}"
#		mv "./${aa_ary[i]-X/${aa_ary[i]-*" "./${aa_ary[i]-X/${aa_ary[i]}-${aa_ary[k]}"

cat <<EOF > leap${aa_ary[i]}-${aa_ary[k]}.in
this is ${aa_ary[i]}-${aa_ary[k]} complex !
EOF
	done
done


#aa_ary=("A" "C" "D" "E" "F" "G" "H" "I" "K" "L" "M" "N" "P" "Q" "R" "S" "T" "V" "W" "Y")
#echo ${aa_ary}
#let aa_num="${aa_ary[@]}-1"
#echo $aa_num
#while[$aa_num -ge 0]; do
#	echo ${aa_num}
#done
#
#
##cat <<-"EOF" > log?in?
##
#tleap -s -f leaprc.ff99
#a = loadpdb 
#
#
#EOF
