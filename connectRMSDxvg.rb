#!/home/usr7/htakuya/bin/ruby

start_ns = ARGV[0].to_i unless ARGV[0] == nil
lim_ns = ARGV[1].to_i unless ARGV[1] == nil

file = File.open("out#{start_ns}-#{lim_ns}ns.txt", "w") 
#file = File.open("out05-2ns.txt", "w") 
file.puts "time/ns rmsd/Angstrom"

for i in start_ns..(lim_ns-2)
    ####### optional #########
#   if File.exists?("rmsd05-2ns.xvg") 
#       twons = File.open("rmsd05-2ns.xvg") 
    ####### par 2ns #########
     if File.exists?("rmsd#{i}-#{i+2}ns.xvg") 
         twons = File.open("rmsd#{i}-#{i+2}ns.xvg") 
        #########################

        while line = twons.gets
            unless line =~ /^(#|@)/
               # file.printf("%12.7f  %10.7f\n", (line.split[0].to_f + 500)/1000, line.split[1].to_f * 10)
                file.printf("%12.7f  %10.7f\n", (line.split[0].to_f + i*1000)/1000, line.split[1].to_f * 10)
            end
        end
        twons.close
    end
end

file.close
