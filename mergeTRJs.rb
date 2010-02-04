#!/home/usr7/htakuya/bin/ruby
require 'selectKei.rb'
#ARGV[0]=kei in selectKei.rb


$stdout = File.open("log_mergeTRJs#{@filePrefix}0-10ns.txt", "w") 

def mergeTRJs(start_ns, lim_ns, tick)
i = start_ns
inputTRRstr = ""
while (i+tick <= lim_ns)
    if  File.exists?("#{@mdPath}#{i}-#{i+tick}ns/#{@filePrefix}#{i}-#{i+tick}ns.trr") 
        inputTRRstr = inputTRRstr + " #{@mdPath}#{i}-#{i+tick}ns/#{@filePrefix}#{i}-#{i+tick}ns.trr"
    elsif @jobPrefix == "Mut" #{{{
        case i
        when 0 
            if  File.exists?("#{@mdPath}0-05ns/#{@filePrefix}0-05ns.trr") 
                puts "#{@filePrefix}0-05ns.trr is exist"
            else
                puts "missing #{@fileprefix}0-05ns.trr ..."
            end
        when 1
            if  File.exists?("#{@mdPath}05-2ns/#{@filePrefix}05-2ns.trr") 
                puts "#{@filePrefix}05-2ns.trr is exist"
            else
                puts "missing #{@fileprefix}05-2ns.trr ..."
            end
        end 
        #}}}
        ##################
        inputTRRstr = inputTRRstr + " #{@mdPath}#{i}-#{i+tick}ns/#{@filePrefix}#{i}-#{i+tick}ns.trr"
        ##################
    else 
        puts "missing #{@fileprefix}#{i}-#{i+tick}ns.trr ..."
    end
    i = i+tick
end
        puts inputTRRstr
                %x(
                expect -c '
            set timeout 60
                spawn trjcat -settime -o /work2/htakuya/fullTRJ/#{@jobPrefix}/merged#{@filePrefix}#{start_ns}-#{lim_ns}ns.trr -f#{inputTRRstr}
            expect "0.000 ps"
            send "c"
            interact
                '
                )
end

@keiList = [ "Ch5", "Mut", "M1EQ", "M1MY" ].each do |kei|
case kei#{{{
when "Ch5"
    @jobPrefix = "Ch5x"
    @filePrefix = "Ch5_"
    @mdPath = "11.5thChWT/"
    @mdpFile = "mdpCh5.mdp"
    @emStructue = "Ch5_EM.pdb"  # put under mdPath
    @topFile = "1120.Ch5WT.top"
when "Mut"
    @jobPrefix = "Mut"
    @filePrefix = "ChMut_"
    @mdPath = "11.Mut/4.MD/"
    @emStructue = "ChMut_EMdone.pdb"
    @mdpFile = "mdpMut.mdp"
    @topFile = "11.Mut.top"
when "M1EQ"
    @jobPrefix = "M1EQ"
    @filePrefix = "Mut1E113Q_"
    @mdPath = "11.Mut1E113Q/4.MD/"
    @emStructue = "Mut1E113Q_EM.pdb"
    @mdpFile = "mdpE113Q.mdp"
    @topFile = "1124.E113Q.top"
when "M1MY"
    @jobPrefix = "M1MY"
    @filePrefix = "Mut1M257Y_"
    @mdPath = "11.Mut1M257Y/4.MD/"
    @emStructue = "M257Ystate1_EM.pdb"
    @mdpFile = "mdpM257Ys1.mdp"
    @topFile = "12.M1MYs1.top"
end#}}}

mergeTRJs(2,10,2)
mergeTRJs(10,20,2)
mergeTRJs(20,30,2)
mergeTRJs(0,2,1)

end

#                %x(
#                expect -c '
#            set timeout 60
#                trjcat -settime -o merged#{filePrefix}#{start}-#{limit}ns.trr -f 
#            expect "0.000 ps"
#            send "c"
#            interact
#                '
#                )
