#!/usr/bin/env ruby

if ARGV[0] == nil || ARGV[1] == nil
  print "\n", "\n"
  puts "MY SYNTAX ERROR"
  puts "usage: runmd_gbsa.rb AA1 AA2"
  print "\n", "\n"
  exit
end

aa1 = ARGV[0]; aa2 = ARGV[1]
  %x{cp ../3eq/eq#{aa1}#{aa2}.rst .}

  %x{
    cat << EOF > md.in
    #Molecular Dynamics

    &cntrl
    imin=0, irest=1,
    dt=0.001, nstlim=2000000,
    ntp=0, taup=2, ntx=5,
    ntpr=200, ntwx=1000, ntwe=500,
    ntt=1, ntc=2, ntf=2,
    temp0=300, tautp=0.2,
    ntb=0, igb=1, gbsa=1,
    cut=999, 
    /
    EOF
  }

  if ARGV[2] == "2"
    %x{
      n1ge -mpi 16 -N AMB_md#{aa1}#{aa2} -g 1B070296 -q bes2 "sander -O -i md.in -o md#{aa1}#{aa2}.out -p #{aa1}-#{aa2}_no.top -c eq#{aa1}#{aa2}.rst -r md#{aa1}#{aa2}.rst -ref eq#{aa1}#{aa2}.rst -x md#{aa1}#{aa2}.mdcrd"
    }
  else
    %x{
      n1ge -mpi 32 -N AMB_md#{aa1}#{aa2} -g 1B070296 "sander -O -i md.in -o md#{aa1}#{aa2}.out -p #{aa1}-#{aa2}_no.top -c eq#{aa1}#{aa2}.rst -r md#{aa1}#{aa2}.rst -ref eq#{aa1}#{aa2}.rst -x md#{aa1}#{aa2}.mdcrd"
    }
  end
