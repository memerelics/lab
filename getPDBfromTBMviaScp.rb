#!/usr/bin/ruby 

require 'selectKei.rb'

start_ns = 20
lim_ns = 26
i = start_ns

while (i+2 <= lim_ns)

%x(
scp htakuya@login-gw.cc.titech.ac.jp:/work/htakuya/#{@mdPath}#{i}-#{i+2}ns/#{@filePrefix}#{i}-#{i+2}ns.pdb .
)
    i = i + 2
end
