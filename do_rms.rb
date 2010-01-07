#!/home/usr7/htakuya/bin/ruby
# use in /work_01/htakuya/rmsdWork/
# -- how to use --
# ARGV[0]:kei, ARGV[1]:domainNum, ARGV[2]:tick
# e.g. >ruby do_rms.rb Ch5 21

require 'pp'
require "../selectKei.rb"

## set vars ##{{{
@domain = "All" #default
@domainList = [ "Nter", "TM1", "IC1", "TM2", "EC1", "TM3", "IC2", "TM4", "EC2", "TM5", "IC3", "TM6", "EC3", "TM7", "H8", "Cter", "H8+Cter", "C-alpha", "RET", "All-TMs", "Exterior", "Interior" ]
#           0:Nter, 1:TM1, 2:IC1, 3:TM2, 4:EC1, 5:TM3, 6:IC2, 7:TM4, 8:EC2, 9:TM5, 10:IC3, 11:TM6, 12:EC3, 13:TM7, 14:H8, 15:Cter, 16:H8+Cter, 17:C-alpha, 18:RET, 19:All-TMs, 20:Exterior, 21:Interior
@groupA = @groupB = ARGV[1].to_i
@domain = @domainList[ARGV[1].to_i] 
#tick = ARGV[2].to_i
#}}}

$stdout = File.open("log_do_rms#{@filePrefix}#{@domain}.txt", "w") 

## IO out ## {{{
puts "arg0: "+ "#{ARGV[0]}" + "...should be in"
pp @keiList
puts "\narg1: "+ "#{ARGV[1]}" + "...should be in 0-21 or all domain"
puts "0:Nter, 1:TM1, 2:IC1, 3:TM2, 4:EC1, 5:TM3, 6:IC2, 7:TM4, 8:EC2, 9:TM5, 10:IC2, 11:TM6, 12:EC3, 13:TM7, 14:H8, 15:Cter, 16:H8+Cter, 17:C-alpha, 18:RET, 19:All-TMs, 20:Exterior, 21:Interior"
puts "\n kei: " + @jobPrefix + ", domain: "+ @domain + "\n\n"
#}}}

### def autoSelectGRMS ### {{{
def autoSelectGRMS(auto_filePrefix, auto_mdPath, auto_emStructue, auto_domain, start, limit, group)
                %x(
                expect -c '
            set timeout 60
            spawn g_rms -n regionIndex_#{auto_filePrefix}.ndx -f ../#{auto_mdPath}#{start}-#{limit}ns/#{auto_filePrefix}#{start}-#{limit}ns.trr -s ../#{auto_mdPath}#{@emStructue} -o rmsd#{auto_filePrefix}#{@domain}_#{start}-#{limit}ns.xvg
            expect "Select a group:"
            send "#{group}\n"
            expect "Selected #{group}:"
            expect "Select a group:"
            send "#{group}\n"
            expect "Selected #{group}:"
            interact
                '
                )
end #}}}

def calcrmsd(start_ns, lim_ns, tick)
    i = start_ns
    while (i+tick <= lim_ns)
        if  File.exists?("../#{@mdPath}#{i}-#{i+tick}ns/#{@filePrefix}#{i}-#{i+tick}ns.trr") 
            puts "#{@filePrefix}#{i}-#{i+tick}ns.trr is exist"
            puts "domain: #{@domain}"
            autoSelectGRMS(@filePrefix, @mdPath, @emStructue, @domain, i, i+tick, @groupA)
        elsif @jobPrefix == "Mut" #{{{1
            case i
            when 0 #{{{2
                if  File.exists?("../#{@mdPath}0-05ns/#{@filePrefix}0-05ns.trr") 
                    puts "#{@filePrefix}0-05ns.trr is exist"
                    puts "domain: #{@domain}"
                    autoSelectGRMS(@filePrefix, @mdPath, @emStructue, @domain, "0", "05", @groupA)
                else
                    puts "missing #{@fileprefix}0-05ns.trr ..."
                end #}}}2
            when 1 #{{{2
                if  File.exists?("../#{@mdPath}05-2ns/#{@filePrefix}05-2ns.trr") 
                    puts "#{@filePrefix}05-2ns.trr is exist"
                    puts "domain: #{@domain}"
                    autoSelectGRMS(@filePrefix, @mdPath, @emStructue, @domain, "05", "2", @groupA)
                else
                    puts "missing #{@fileprefix}05-2ns.trr ..."
                end #}}}2
            end 
            #}}}1
        else # .trr doesn't exist
            puts "missing #{@fileprefix}#{i}-#{i+tick}ns.trr ..."
        end
        i = i+tick
    end
end

calcrmsd(0,2,1)
calcrmsd(2,20,2)




=begin {{{
while (i+2 <= lim_ns)
    if  File.exists?("../#{@mdPath}#{i}-#{i+2}ns/#{@filePrefix}#{i}-#{i+2}ns.trr") 
        puts "#{@filePrefix}#{i}-#{i+2}ns.trr is exist"
        puts "domain: #{domain}"
#    %x(
#    expect -c '
#set timeout 60
#spawn g_rms -n regionIndex_#{@filePrefix}.ndx -f ../#{@mdPath}#{i}-#{i+2}ns/#{@filePrefix}#{i}-#{i+2}ns.trr -s ../#{@mdPath}#{@emStructue} -o rmsd#{@filePrefix}#{domain}_#{i}-#{i+2}ns.xvg
#expect "Select a group:"
#send "#{groupA}\n"
#expect "Selected #{groupA}:"
#expect "Select a group:"
#send "#{groupB}\n"
#expect "Selected #{groupB}:"
#interact
#    '
#    )
    else # .trr doesn't exist
        puts "missing #{@filePrefix}#{i}-#{i+2}ns.trr ..."
    end
    i = i+2
end




save

                %x(
                expect -c '
            set timeout 60
            spawn g_rms -n regionIndex_#{@filePrefix}.ndx -f ../#{@mdPath}#{i}-#{i+tick}ns/#{@filePrefix}#{i}-#{i+tick}ns.trr -s ../#{@mdPath}#{@emStructue} -o rmsd#{@filePrefix}#{@domain}_#{i}-#{i+tick}ns.xvg
            expect "Select a group:"
            send "#{@groupA}\n"
            expect "Selected #{@groupA}:"
            expect "Select a group:"
            send "#{@groupB}\n"
            expect "Selected #{@groupB}:"
            interact
                '
                )


=end
#}}}
