#!/home/usr7/htakuya/bin/ruby
# use in /work_01/htakuya/rmsdWork/
# -- how to use --
# select "kei" and dmain 0 to 15

require 'pp'

## define ##
start_ns = 14; lim_ns = 16

keiList = [ "Ch5", "Mut", "M1EQ", "M1MY" ]
kei = ARGV[0]

domain = "All"
domainList = [ "Nter", "TM1", "IC1", "TM2", "EC1", "TM3", "IC2", "TM4", "EC2", "TM5", "IC2", "TM6", "EC3", "TM7", "H8", "Cter" ]
#           0:Nter, 1:TM1, 2:IC1, 3:TM2, 4:EC1, 5:TM3, 6:IC2, 7:TM4, 8:EC2, 9:TM5, 10:IC2, 11:TM6, 12:EC3, 13:TM7, 14:H8, 15:Cter
domain = domainList[ARGV[1].to_i] 

### define names ### {{{
case kei
when "Ch5"
    jobPrefix = "Ch5x"
    filePrefix = "Ch5_"
    mdPath = "11.5thChWT/"
    mdpFile = "mdpCh5.mdp"
    emStructue = "Ch5_EM.pdb"  # put under mdPath
    topFile = "1120.Ch5WT.top"
when "Mut"
    jobPrefix = "Mut"
    filePrefix = "ChMut_"
    mdPath = "11.Mut/4.MD/"
    emStructue = "ChMut_EMdone.pdb"
    mdpFile = "mdpMut.mdp"
    topFile = "11.Mut.top"
when "M1EQ"
    jobPrefix = "M1EQ"
    filePrefix = "Mut1E113Q_"
    mdPath = "11.Mut1E113Q/4.MD/"
    emStructue = "Mut1E113Q_EM.pdb"
    mdpFile = "mdpE113Q.mdp"
    topFile = "1124.E113Q.top"
when "M1MY"
    jobPrefix = "M1MY"
    filePrefix = ""
    mdPath = ""
    emStructue = ""
    mdpFile = ""
    topFile = ""
end # }}}

puts "arg0: "+ "#{ARGV[0]}" + "...should be in"
pp keiList
puts "\narg1: "+ "#{ARGV[1]}" + "...should be in 0-15 or all domain"
puts "0:Nter, 1:TM1, 2:IC1, 3:TM2, 4:EC1, 5:TM3, 6:IC2, 7:TM4, 8:EC2, 9:TM5, 10:IC2, 11:TM6, 12:EC3, 13:TM7, 14:H8, 15:Cter"
puts "\n kei: " + jobPrefix + ", domain: "+ domain + "\n\n"

#start_ns = ARGV[0].to_i unless ARGV[0] == nil
#lim_ns = ARGV[1].to_i unless ARGV[1] == nil

 # 2ns production phase #
#for i in start_ns..lim_ns
i = start_ns
while (i+2 <= lim_ns)
    if  File.exists?("../#{mdPath}#{i}-#{i+2}ns/#{filePrefix}#{i}-#{i+2}ns.trr") 
        # check already ...#
       
        puts "#{filePrefix}#{i}-#{i+2}ns.trr is exist"
        puts "domain: #{domain}"
    %x(
    g_rms -n regionIndex_#{filePrefix}.ndx -f ../#{mdPath}#{i}-#{i+2}ns/#{filePrefix}#{i}-#{i+2}ns.trr -s ../#{mdPath}#{emStructue} -o rmsd#{filePrefix}#{domain}_#{i}-#{i+2}ns.xvg
    )
    else
        puts "missing #{filePrefix}#{i}-#{i+2}ns.trr ..."
    end
    i = i+2
end
