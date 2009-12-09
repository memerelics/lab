#!/home/usr7/htakuya/bin/ruby

keiList = [ "Ch5", "Mut", "M1EQ", "M1MY" ]

kei = ARGV[0]
now = ARGV[1].to_i; old = now - 2; goal = now + 2
mpi = ARGV[2].to_i
#pl = ARGV[3]

### define names ###
case kei
when "Ch5"
    jobPrefix = "Ch5x"
    filePrefix = "Ch5_"
    mdPath = "11.5thChWT/"
    mdpFile = "mdpCh5.mdp"
    topFile = "1120.Ch5WT.top"
when "Mut"
    jobPrefix = "Mut"
    filePrefix = "ChMut_"
    mdPath = "11.Mut/4.MD/"
    mdpFile = "mdpMut.mdp"
    topFile = "11.Mut.top"
when "M1EQ"
    jobPrefix = "M1EQ"
    filePrefix = "Mut1E113Q_"
    mdPath = "11.Mut1E113Q/4.MD/"
    mdpFile = "mdpE113Q.mdp"
    topFile = "1124.E113Q.top"
when "M1MY"
    jobPrefix = "M1MY"
    filePrefix = ""
    mdPath = ""
    mdpFile = ""
    topFile = ""
end


unless File.exists?("#{mdPath}#{now}-#{goal}ns") 
%x(
mkdir #{mdPath}#{now}-#{goal}ns
    cp #{mdPath}#{old}-#{now}ns/*.itp #{mdPath}#{now}-#{goal}ns/
    cp #{mdPath}#{old}-#{now}ns/#{topFile} #{mdPath}#{now}-#{goal}ns/
    cp #{mdPath}#{old}-#{now}ns/#{mdpFile} #{mdPath}#{now}-#{goal}ns/
    cp #{mdPath}#{old}-#{now}ns/#{filePrefix}#{old}-#{now}ns.pdb #{mdPath}#{now}-#{goal}ns/
    cd #{mdPath}#{now}-#{goal}ns/

    grompp -f #{mdpFile} -c #{filePrefix}#{old}-#{now}ns.pdb -p #{topFile} -o #{filePrefix}#{now}-#{goal}ns.tpr -np #{mpi}
    n1ge -pl 2 -mpi #{mpi} -N #{jobPrefix}#{now}-#{goal} -q bes2 -g 4B090157 mdrun -s #{filePrefix}#{now}-#{goal}ns.tpr -o #{filePrefix}#{now}-#{goal}ns.trr -c #{filePrefix}#{now}-#{goal}ns.pdb
)
    #%x(mkdir #{mdPath}82-84ns)
else 
    puts "directory exists"
end
