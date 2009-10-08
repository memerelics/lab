#!/usr/bin/ruby
require 'pp'
@header = []; @footer = []
@aryRecord = []; @arySerial = []     ; @aryName = []  ; @aryAltLoc = []
@aryResName = [] ; @aryChainID = []   ; @aryResSeq = []; @aryiCode = []
@aryX = []          ; @aryY = []     ; @aryZ = []       ; @aryOccupancy = [] ; 
@aryTempFactor = [] ; @arySegID = []
@aryElement = []; @aryCharge = []

open(ARGV[0]){|file| # INPUT {{{

    @parse_status = 0
    while line = file.gets
        if line[0..5].strip == "ATOM"
            @parse_status = 1
            @aryRecord     << line[0..5].strip
            @arySerial     << line[6..10].to_i # under 9999 atoms
            @aryName       << line[12..15]
            @aryAltLoc     << line[16..16]
            @aryResName    << line[17..19].rstrip
            @aryChainID    << line[21..21]
            @aryResSeq     << line[22..25].to_i
            @aryX          << line[30..37].to_f
            @aryY          << line[38..45].to_f
            @aryZ          << line[46..53].to_f
            @aryOccupancy  << line[54..59].to_f
            @aryTempFactor << line[60..65].to_f
        elsif @parse_status == 1
            @footer << line
        else @header << line
        end # if ATOM 
    end # while
} #}}}

wrongSOLs = []

puts @header
@aryRecord.each_with_index {|a, i|
    
    if @aryResName[i] == "SOL"
        if @aryResSeq[i] != @aryResSeq[i-1]
            if @aryName[i].strip == "OW" && @aryName[i+1].strip == "HW1" && @aryName[i+2].strip == "HW2"

                # if right SOL order... print 3 lines {{{
                printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                       @aryRecord[i], @arySerial[i], @aryName[i], @aryResName[i], @aryResSeq[i],
                       @aryX[i], @aryY[i], @aryZ[i], @aryOccupancy[i], @aryTempFactor[i]) 
                printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                       @aryRecord[i+1], @arySerial[i+1], @aryName[i+1], @aryResName[i+1], @aryResSeq[i+1],
                       @aryX[i+1], @aryY[i+1], @aryZ[i+1], @aryOccupancy[i+1], @aryTempFactor[i+1]) 
                printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                       @aryRecord[i+2], @arySerial[i+2], @aryName[i+2], @aryResName[i+2], @aryResSeq[i+2],
                       @aryX[i+2], @aryY[i+2], @aryZ[i+2], @aryOccupancy[i+2], @aryTempFactor[i+2]) #}}}

            else # wrong SOL order...

                # if SOL has only 1 or 2 atoms {{{1
                if @aryResSeq[i] != @aryResSeq[i+2] && @aryResSeq[i] != @aryResSeq[i+1] 
                    puts "1 atom in SOL"
                elsif @aryResSeq[i] != @aryResSeq[i+2]
                    puts "2atoms in SOL"
                    puts "2atoms in SOL"
                end
#}}}1
                # save position for additional information
                # TODO: save "wrong way types"
                wrongSOLs << "res" + @aryResSeq[i].to_s   + "atom" + @arySerial[i].to_s 
                wrongSOLs << "res" + @aryResSeq[i+1].to_s + "atom" + @arySerial[i+1].to_s 
                wrongSOLs << "res" + @aryResSeq[i+2].to_s + "atom" + @arySerial[i+2].to_s 
               
                # find HW1 and HW2 and print line 2/3 and 3/3
               
                # HW,OW,HW {{{1
                if @aryName[i+1].strip == "OW"
                    # print OW in line 1/3
                    printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                           @aryRecord[i+1], @arySerial[i],  # correct Serial No is not i+1 but i
                           @aryName[i+1], @aryResName[i+1], @aryResSeq[i+1],
                           @aryX[i+1], @aryY[i+1], @aryZ[i+1], @aryOccupancy[i+1], @aryTempFactor[i+1]) 

                    #  HW1,OW,HW2 {{{2
                    if @aryName[i].strip == "HW1" && @aryName[i+2].strip == "HW2"
                        printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                               @aryRecord[i], @arySerial[i+1],# correct Serial No is not i but i+1
                               @aryName[i], @aryResName[i], @aryResSeq[i],
                               @aryX[i], @aryY[i], @aryZ[i], @aryOccupancy[i], @aryTempFactor[i]) 
                        printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                               @aryRecord[i+2], @arySerial[i+2], # i+2 is the correct Serial No.
                               @aryName[i+2], @aryResName[i+2], @aryResSeq[i+2],
                               @aryX[i+2], @aryY[i+2], @aryZ[i+2], @aryOccupancy[i+2], @aryTempFactor[i+2]) 
                        #}}}2
                        #  HW2,OW,HW1 {{{2
                    elsif @aryName[i+2].strip == "HW1" && @aryName[i].strip == "HW2"
                        printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                               @aryRecord[i+2], @arySerial[i+1], # correct Serial No is not i+2 but i+1
                               @aryName[i+2], @aryResName[i+2], @aryResSeq[i+2],
                               @aryX[i+2], @aryY[i+2], @aryZ[i+2], @aryOccupancy[i+2], @aryTempFactor[i+2]) 
                        printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                               @aryRecord[i], @arySerial[i+2], # correct Serial No is not i but i+2
                               @aryName[i], @aryResName[i], @aryResSeq[i],
                               @aryX[i], @aryY[i], @aryZ[i], @aryOccupancy[i], @aryTempFactor[i]) 
                        #}}}2
                    else
                        puts "ERROR... 3atoms but not HWs"
                        puts "ERROR... 3atoms but not HWs"
                    end

#}}}1
                # HW,HW,OW  {{{1
                elsif @aryName[i+2].strip == "OW"
                    # print OW in line 1/3
                    printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                           @aryRecord[i+2], @arySerial[i],  # correct Serial No is not i+2 but i
                           @aryName[i+2], @aryResName[i+2], @aryResSeq[i+2],
                           @aryX[i+2], @aryY[i+2], @aryZ[i+2], @aryOccupancy[i+2], @aryTempFactor[i+2]) 

                    # find HW1 and HW2 and print line 2/3 and 3/3
                    #  HW1,HW2,OW {{{2
                    if @aryName[i].strip == "HW1" && @aryName[i+1].strip == "HW2"
                        printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                               @aryRecord[i], @arySerial[i+1],# correct Serial No is not i but i+1
                               @aryName[i], @aryResName[i], @aryResSeq[i],
                               @aryX[i], @aryY[i], @aryZ[i], @aryOccupancy[i], @aryTempFactor[i]) 
                        printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                               @aryRecord[i+1], @arySerial[i+2], # correct Serial No is not i+1 but i+2
                               @aryName[i+1], @aryResName[i+1], @aryResSeq[i+1],
                               @aryX[i+1], @aryY[i+1], @aryZ[i+1], @aryOccupancy[i+1], @aryTempFactor[i+1]) 
#}}}2
                    #  HW2,HW1,OW {{{2
                    elsif @aryName[i+1].strip == "HW1" && @aryName[i].strip == "HW2"
                        printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                               @aryRecord[i+1], @arySerial[i+1], # i+1 is the correct Serial No.
                               @aryName[i+1], @aryResName[i+1], @aryResSeq[i+1],
                               @aryX[i+1], @aryY[i+1], @aryZ[i+1], @aryOccupancy[i+1], @aryTempFactor[i+1]) 
                        printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                               @aryRecord[i], @arySerial[i+2], # correct Serial No is not i but i+2
                               @aryName[i], @aryResName[i], @aryResSeq[i],
                               @aryX[i], @aryY[i], @aryZ[i], @aryOccupancy[i], @aryTempFactor[i]) 
#}}}2
                    else
                        puts "ERROR... 3atoms but not HWs"
                        puts "ERROR... 3atoms but not HWs"
                    end
#}}}1
                else
                    puts "ERROR...(OW,HW2,HW1) ?"
                end
            end
        end #@aryResSeq[i] != @aryResSeq[i+1]
     
    else # NOT "SOL"
    printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
            @aryRecord[i], @arySerial[i], @aryName[i], @aryResName[i], @aryResSeq[i],
            @aryX[i], @aryY[i], @aryZ[i], @aryOccupancy[i], @aryTempFactor[i]) 
    end
}
puts @footer

puts "", "", "edit" + wrongSOLs.count.to_s + "atoms"
puts wrongSOLs
