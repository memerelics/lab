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

                # if right SOL order... print 3 lines
                printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                       @aryRecord[i], @arySerial[i], @aryName[i], @aryResName[i], @aryResSeq[i],
                       @aryX[i], @aryY[i], @aryZ[i], @aryOccupancy[i], @aryTempFactor[i]) 
                printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                       @aryRecord[i+1], @arySerial[i+1], @aryName[i+1], @aryResName[i+1], @aryResSeq[i+1],
                       @aryX[i+1], @aryY[i+1], @aryZ[i+1], @aryOccupancy[i+1], @aryTempFactor[i+1]) 
                printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
                       @aryRecord[i+2], @arySerial[i+2], @aryName[i+2], @aryResName[i+2], @aryResSeq[i+2],
                       @aryX[i+2], @aryY[i+2], @aryZ[i+2], @aryOccupancy[i+2], @aryTempFactor[i+2])

            else # wrong SOL order...
                # nothing to print out
            end
        end #@aryResSeq[i] != @aryResSeq[i+1]
     
    else # NOT "SOL"
    printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
            @aryRecord[i], @arySerial[i], @aryName[i], @aryResName[i], @aryResSeq[i],
            @aryX[i], @aryY[i], @aryZ[i], @aryOccupancy[i], @aryTempFactor[i]) 
    end
}
puts @footer
