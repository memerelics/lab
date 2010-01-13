#!/home/usr7/htakuya/bin/ruby
# use in /work_01/htakuya/....workfolder...
# -- how to use --

require 'pp'
require "../selectKei.rb"

## define ##
start_ns = 18; lim_ns = 20
groupA = 0 #Shiff Base
groupB = 3

puts "arg0: "+ "#{ARGV[0]}" + "...should be in"
pp @keiList

# 2ns production phase #
i = start_ns
while (i+2 <= lim_ns)
    if  File.exists?("../#{@mdPath}#{i}-#{i+2}ns/#{@filePrefix}#{i}-#{i+2}ns.trr") 
        # check already ...#
        puts "#{@filePrefix}#{i}-#{i+2}ns.trr is exist"
        puts "calculating distance of group[#{groupA}]-group[#{groupB}]"

#    %x(
#    expect -c '
#set timeout 60
#spawn g_dist -n distIndex_#{@filePrefix}.ndx -f ../#{@mdPath}#{i}-#{i+2}ns/#{@filePrefix}#{i}-#{i+2}ns.trr -s ../#{@mdPath}#{i}-#{i+2}ns/#{@filePrefix}#{i}-#{i+2}ns.tpr -o dist#{@filePrefix}G#{groupA}-G#{groupB}_#{i}-#{i+2}ns.xvg
#expect "Select a group:"
#send "#{groupA}\n"
#expect "Selected #{groupA}:"
#expect "Select a group:"
#send "#{groupB}\n"
#expect "Selected #{groupB}:"
#interact
#    '
#    )
    puts "expect command done."
    else
        puts "missing #{@filePrefix}#{i}-#{i+2}ns.trr ..."
    end

#    puts "executing connectDISTxvg.rb..."
#%x(
#    ruby connectDISTxvg.rb dist#{@filePrefix}#{groupA}-#{groupB}_#{i}-#{i+2}ns.xvg #{i}
#)

    i = i+2
    puts "next step."
end

