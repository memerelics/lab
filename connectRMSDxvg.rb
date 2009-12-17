#!/home/usr7/htakuya/bin/ruby
# usage:
# put this script in the folder
# and using complement function define file prefix as a ARGV[0]
# ./connectRMSDxvg.rb rmsdCh5_TM1_
#  or 
# ./connectRMSDxvg.rb rmsdCh5_TM1_0-1ns.xvg -> edit format


start_ns = 2; lim_ns = 14


if ARGV[0] =~ /\.xvg/
    #for i in 1..7
    fullFileName = ARGV[0]
    convert_start_time_ns = ARGV[1].to_f
    #fullFileName = "rmsdMut1E113Q_TM"+i.to_s+"_14-16ns.xvg"
    #convert_start_time_ns = 14

    puts "convert format of " + fullFileName
    puts "start time is " + convert_start_time_ns.to_s + " ns(" + (convert_start_time_ns*1000).to_s + "ps)"

    file = File.open("out_#{fullFileName.sub(".xvg", "")}.txt", "w") 
    file.puts "time/ns rmsd/Angstrom" if convert_start_time_ns == 0
    if File.exists?(fullFileName) 
        twons = File.open(fullFileName) 
        while line = twons.gets
            unless line =~ /^(#|@)/
                file.printf("%12.7f  %10.7f\n", (line.split[0].to_f + (convert_start_time_ns*1000))/1000, line.split[1].to_f * 10)
            end
        end
    end
    #end

else

    rmsdFileName = ARGV[0] #.sub("rmsd", "")
    puts rmsdFileName + ": " + start_ns.to_s + " - " + lim_ns.to_s

    file = File.open("out_#{rmsdFileName}#{start_ns}-#{lim_ns}ns.txt", "w") 
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

end
