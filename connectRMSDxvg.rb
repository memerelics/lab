#!/home/usr7/htakuya/bin/ruby
# usage:
# put this script in the folder
# and using complement function define file prefix as a ARGV[0]
# ./connectRMSDxvg.rb rmsdCh5_TM1_


start_ns = 2; lim_ns = 20

rmsdFileName = ARGV[0] #.sub("rmsd", "")
puts rmsdFileName

file = File.open("out_#{rmsdFileName}#{start_ns}-#{lim_ns}ns.txt", "w") 
#file = File.open("out_#{rmsdFileName}05-2ns.txt", "w") 
file.puts "time/ns rmsd/Angstrom"

####### par 2ns #########
i = start_ns
while (i+2 <= lim_ns)
     if File.exists?("#{rmsdFileName}#{i}-#{i+2}ns.xvg") 
         twons = File.open("#{rmsdFileName}#{i}-#{i+2}ns.xvg") 

        while line = twons.gets
            unless line =~ /^(#|@)/
                file.printf("%12.7f  %10.7f\n", (line.split[0].to_f + i*1000)/1000, line.split[1].to_f * 10)
            end
        end
        twons.close
     else 
         puts "#{rmsdFileName}#{i}-#{i+2}ns.xvg doesn't exist"
    end
     i = i+2
end

file.close

#   if File.exists?("#{rmsdFileName}05-2ns.xvg") 
#       twons = File.open("#{rmsdFileName}05-2ns.xvg") 
#        while line = twons.gets
#            unless line =~ /^(#|@)/
               # file.printf("%12.7f  %10.7f\n", (line.split[0].to_f + 500)/1000, line.split[1].to_f * 10)
#            end
#        end
