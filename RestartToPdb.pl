#!/usr/bin/perl
# copied from thayashi/morita_backup/ATTACHMENT

# open input and output file
open(IN,"restart_MUT.dat");
open(OUT,">restart_MUT.pdb");

# get number of atoms
for ($i = 0; $i < 3; $i++) {
  $line = <IN>;
  chomp $line;
}
$natom = $line;

# convert file format (restart --> pdb)
for ($i = 0; $i < $natom; $i++) {
  $line1 = <IN>;
  $line2 = <IN>;
  $num = substr($line1, 0, 5);
  $resinum = substr($line1, 5, 5);
  $resi = substr($line1, 11, 4);
  $atom = substr($line1, 16, 4);
  $codx = substr($line2, 0, 24);
  $cody = substr($line2, 24, 24);
  $codz = substr($line2, 48, 24);
  chomp $atom;

  printf OUT "ATOM  %5d  %-4s%-4s %5d    %8.3f%8.3f%8.3f  0.00  0.00          %1s\n",
             $num, $atom, $resi, $resinum, $codx, $cody, $codz, substr($atom,0,1);
}

# close files
close(IN);
close(OUT);
