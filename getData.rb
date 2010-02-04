#!/usr/bin/ruby 


#@domainList = ["EC1", "EC2", "EC3", "Nter", "IC1", "IC2", "IC3", "Cter"]
@runList = [
"Glu247CD-Arg135NE",
"Glu247CD-Arg135NH1",
"Glu247CD-Arg135NH2",
"Thr251OG1-Arg135NE",
"Thr251OG1-Arg135NH1",
"Thr251OG1-Arg135NH2"
]
#@domainList.each do |domain|
#    ["Ch5", "ChMut", "Mut1E113Q", "Mut1M257Y"].each do |kei|
    ["Ch5", "Mut", "M1EQ", "M1MY"].each do |kei|
@runList.each do |run|
fileName = "out_dist#{kei}_#{run}.txt"
puts "get " + fileName

%x(
scp htakuya@login.cc.titech.ac.jp:down/#{fileName} .
)
    end
end
#end #domain loop


# %x( mkdir #{domain}) unless File.exists?("#{domain}")
# %x( mv out_*#{domain}* #{domain}/)
