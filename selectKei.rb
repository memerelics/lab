#!/usr/bin/ruby 

@keiList = [ "Ch5", "Mut", "M1EQ", "M1MY" ]
kei = ARGV[0]

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
