#!/home/usr7/htakuya/bin/ruby

start_ns = ARGV[0].to_i unless ARGV[0] == nil
lim_ns = ARGV[1].to_i unless ARGV[1] == nil

file = File.open("out#{start_ns}-#{lim_ns}ns.txt", "w") 
file.puts "time/ps rmsd/Angstrom"

for i in start_ns..lim_ns
    ####### optional #########
    if File.exists?("rmsd#{i}-#{i+1}ns.xvg") 
        twons = File.open("rmsd#{i}-#{i+1}ns.xvg") 
        ####### par 2ns #########
        # if File.exists?("rmsd#{i}-#{i+2}ns.xvg") 
        #     twons = File.open("rmsd#{i}-#{i+2}ns.xvg") 
        #########################

        while line = twons.gets
            unless line =~ /^(#|@)/
            file.printf("%12.7f  %10.7f\n", line.split[0].to_f + i*1000, line.split[1].to_f)
            end
        end
        twons.close
    end
end

file.close
