#!/home/usr7/htakuya/bin/ruby

# 0-20 only

[ "G0-G1" ].each do |lpDomain|
[ "Ch5_", "ChMut_", "Mut1E113Q_", "Mut1M257Y_" ].each do |filePrefix|
        if filePrefix == "ChMut_"
            period = "05"; period_ns = "0.5"
        else
            period = period_ns = "1"
        end
        #{{{ if all files exist
        if (File.exists?("#{lpDomain}/dist#{filePrefix}#{lpDomain}_0-#{period}ns.xvg") && 
            File.exists?("#{lpDomain}/dist#{filePrefix}#{lpDomain}_#{period}-2ns.xvg") &&
                File.exists?("#{lpDomain}/dist#{filePrefix}#{lpDomain}_2-4ns.xvg") &&
                File.exists?("#{lpDomain}/dist#{filePrefix}#{lpDomain}_4-6ns.xvg") &&
                File.exists?("#{lpDomain}/dist#{filePrefix}#{lpDomain}_6-8ns.xvg") &&
                File.exists?("#{lpDomain}/dist#{filePrefix}#{lpDomain}_8-10ns.xvg") &&
                File.exists?("#{lpDomain}/dist#{filePrefix}#{lpDomain}_10-12ns.xvg") &&
                File.exists?("#{lpDomain}/dist#{filePrefix}#{lpDomain}_12-14ns.xvg") &&
                File.exists?("#{lpDomain}/dist#{filePrefix}#{lpDomain}_14-16ns.xvg") &&
                File.exists?("#{lpDomain}/dist#{filePrefix}#{lpDomain}_16-18ns.xvg") &&
                File.exists?("#{lpDomain}/dist#{filePrefix}#{lpDomain}_18-20ns.xvg")) 
            #}}}
            puts "process dist#{filePrefix}#{lpDomain}_0-#{period}/#{period}-2/2-20ns.xvg"
#           dist#{filePrefix}G#{groupA}-G#{groupB}_#{i}-#{i+2}ns.xvg
        %x(
        cd #{lpDomain}
        mv ../connectRMSDxvg.rb .

ruby connectRMSDxvg.rb dist#{filePrefix}#{lpDomain}_0-#{period}ns.xvg 0
ruby connectRMSDxvg.rb dist#{filePrefix}#{lpDomain}_#{period}-2ns.xvg #{period_ns}
ruby connectRMSDxvg.rb dist#{filePrefix}#{lpDomain}_

cat out_dist#{filePrefix}#{lpDomain}_0-#{period}ns.txt out_dist#{filePrefix}#{lpDomain}_#{period}-2ns.txt out_dist#{filePrefix}#{lpDomain}_2-20ns.txt > out_dist#{filePrefix}#{lpDomain}_0-20ns.txt

cp out_dist#{filePrefix}#{lpDomain}_0-20ns.txt ~/down/
rm out_dist#{filePrefix}#{lpDomain}_0-#{period}ns.txt out_dist#{filePrefix}#{lpDomain}_#{period}-2ns.txt out_dist#{filePrefix}#{lpDomain}_2-20ns.txt
        mv out_* ../stock_output
        mv connectRMSDxvg.rb ../
        )
        puts "created out_dist#{filePrefix}#{lpDomain}_0-20ns.txt and copied that to ~/down/"
        puts "... and original file was stocked to ../stock_output\n\n"
        else
            puts "#{lpDomain} of #{filePrefix} ...missing file(s)!!\n\n"
        end
    end
end


