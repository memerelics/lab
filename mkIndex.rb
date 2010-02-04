#!/home/usr7/htakuya/bin/ruby
#use at /work/htakuya/

@keiList = ["Ch5", "Mut", "M1EQ", "M1MY" ]

rList = ARGV

@keiList.each do |kei|
    #{{{select kei variables
    case kei
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
    end
    #}}}

    counter = 0; once = 0
    if File.exists?("/work/htakuya/#{@mdPath}#{@emStructue}") 
        puts ARGV.join(' ')
        twons = File.open("/work/htakuya/#{@mdPath}#{@emStructue}") 
        outputfile = File.open("_#{kei}_r#{ARGV.join('')}.ndx", "w") 
        outputfile.puts "[ " + "r#{ARGV.join('')}" + " ]"

        while line = twons.gets
            if  line.split[0] == "ATOM"
                unless line.split[3] =~ /(SOL|POP|Na|Cl)/
                    if  rList.include?(line.split[5])
                            print(line.split[3] + " ") if once = 0
                            once = 1
                        if counter <= 14
                            counter = counter + 1
                            outputfile.printf("%4d ", line.split[1].to_i) 
                        elsif counter == 15
                            counter = 0
                            outputfile.printf("%4d\n", line.split[1].to_i) 
                        end
                    end
            once = 0
                end
            end
        end


    else
        puts "no em file..."
        exit
    end
end
