#!/home/usr7/htakuya/bin/ruby
# usage:
# put this script in the folder
# and using complement function define file prefix as a ARGV[0]
# ./connectRMSDxvg.rb rmsdCh5_TM1_
#  or 
# ./connectRMSDxvg.rb rmsdCh5_TM1_0-1ns.xvg -> edit format


if ARGV[0] =~ /\.xvg/ 
    fullFileName = ARGV[0]

    puts "convert format of " + fullFileName

    outputfile = File.open("out_#{fullFileName.sub(".xvg", "")}.txt", "w") 

    outputfile.puts "Time/ns Distance/Angstrom"

    if File.exists?(fullFileName) 
        twons = File.open(fullFileName) 
        while line = twons.gets
            unless line =~ /^(#|@)/
                outputfile.printf("%12.7f  %10.7f\n", (line.split[0].to_f)/1000, line.split[1].to_f * 10)
                # time(ps->ns) & dist(nm->Angstrom)
            end
        end
    else
        puts "no input file..."
        exit
    end
else 
    puts "not xvg file..."
    exit
end
