#!/usr/bin/env ruby

if ARGV[0] == nil || ARGV[1] == nil
  print "\n", "\n"
  puts "MY SYNTAX ERROR"
  puts "usage: analruby.rb AA1 AA2"
  print "\n", "\n"
  exit
end

aa1 = ARGV[0]; aa2 = ARGV[1]

%x{cp ../2min/min#{aa1}#{aa2}.rst .} if File.exists?("min#{aa1}#{aa2}.rst") == false 

# use the same name for min.in cuz they have same parms
%x{
cat << EOF > eq.in
Equilibraion

 &cntrl
  ntf = 2, ntc = 2, 
  ntp = 0, taup = 0.5,
  ntb = 1,
  cut = 999,
  nstlim = 30000, dt = 0.001,
  ntpr = 100, ntwx = 1000,
  nmropt = 1,
  nsnb = 10,
  imin = 0,
  ntr = 1,
  tempi = 50.0,
  temp0 = 300.0,
  ntt=3, gamma_ln=5,
  restraint_wt=1.0,
  restraintmask=':1-62', 
  ntb=0, igb=1, gbsa=1,
 /

 &wt
  type = 'TEMP0', istep1 = 0, istep2 = 25000,
                  value1 = 50.0, value2 = 300.0,
  type = 'END',
 /
 &wt
  type = 'TEMP0', istep1 = 25000, istep2 = 50000,
                 value1 = 300.0, value2 = 300.0,
  type = 'END',
 /

 &rst
  IAT(1)=0,
 /
EOF
}

# change X-X according to input argments
if ARGV[2] == "2"
%x{
n1ge -mpi 4 -N AMB_eq#{aa1}#{aa2} -g 1B070296 -q bes2 "sander -O -i eq.in -o eq#{aa1}#{aa2}.out -p #{aa1}-#{aa2}_no.top -c min#{aa1}#{aa2}.rst -r eq#{aa1}#{aa2}.rst -ref min#{aa1}#{aa2}.rst -x eq#{aa1}#{aa2}.mdcrd"
}
else
%x{
n1ge -mpi 8 -N AMB_eq#{aa1}#{aa2} -g 1B070296  "sander -O -i eq.in -o eq#{aa1}#{aa2}.out -p #{aa1}-#{aa2}_no.top -c min#{aa1}#{aa2}.rst -r eq#{aa1}#{aa2}.rst -ref min#{aa1}#{aa2}.rst -x eq#{aa1}#{aa2}.mdcrd"
}
end
