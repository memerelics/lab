#!/home/usr7/htakuya/bin/ruby

[ "Ch5", "Mut", "M1EQ", "M1MY" ].each do |kei|
    for i in [ 17 ] do #select domains in region Index
                                   #15:Cter already exist
    %x(
    ruby do_rms.rb #{kei} #{i}
    )
    ###OPTIONAL###
    #%x(ruby metaConnectRMSD.rb)
    end
end
