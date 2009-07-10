#!/usr/bin/ruby
@residueAtomNo = 3
@startNo = 796

@header = []; @footer = []
@aryRecord = []; @arySerial = []     ; @aryName = []  ; @aryAltLoc = []
@aryResName = [] ; @aryChainID = []   ; @aryResSeq = []; @aryiCode = []
@aryX = []          ; @aryY = []     ; @aryZ = []       ; @aryOccupancy = [] ; 
@aryTempFactor = [] ; @arySegID = []
@aryElement = []; @aryCharge = []

open(ARGV[1]){|file|

    @parse_status = 0
    while line = file.gets
        if line[0..5].strip == "ATOM" #{{{
            @parse_status = 1
            @aryRecord     << line[0..5].strip
            @arySerial     << line[6..10].to_i
            @aryName       << line[12..15]
            @aryAltLoc     << line[16..16]
            @aryResName    << line[17..19].rstrip
            @aryChainID    << line[21..21]
           # @aryResSeq     << line[22..25].to_i
            @aryResSeq     << line[22..26].to_i
           # @aryiCode      << line[26..26]
            @aryX          << line[30..37].to_f
            @aryY          << line[38..45].to_f
            @aryZ          << line[46..53].to_f
            @aryOccupancy  << line[54..59].to_f
            @aryTempFactor << line[60..65].to_f
            @arySegID      << line[72..75]
            @aryElement    << line[76..77]
            @aryCharge     << line[78..79]
        elsif @parse_status == 1
            @footer << line
        else @header << line
        end # if ATOM }}}
    end # while
}

if ARGV[0] == "-residNo"
puts @header
@aryRecord.each_with_index {|a, i|

    # old expression
    # "%-6s%5d %-4s%-1s%3s %-1s%4d%-1s   %8.3f%8.3f%8.3f%6.2f%6.2f      %-4s%2s%-2s\n"
    printf("%-6s%5d %-4s%-1s%3s %-1s%5d   %8.3f%8.3f%8.3f%6.2f%6.2f      %-4s%2s%-2s\n",
            @aryRecord[i],
            @arySerial[i],
            @aryName[i],
            @aryAltLoc[i],
            @aryResName[i],
            @aryChainID[i],
            (@startNo + i/@residueAtomNo), #@aryResSeq[i],
           # @aryiCode[i],
            @aryX[i],
            @aryY[i],
            @aryZ[i],
            @aryOccupancy[i],
            @aryTempFactor[i],
            @arySegID[i],
            @aryElement[i],
            @aryCharge[i] 
           ) 
}
puts @footer
end

if ARGV[0] == "-serial"
puts @header
@aryRecord.each_with_index {|a, i|

    # old expression
    # "%-6s%5d %-4s%-1s%3s %-1s%4d%-1s   %8.3f%8.3f%8.3f%6.2f%6.2f      %-4s%2s%-2s\n"
    printf("%-6s%5d %-4s%-1s%3s %-1s%5d   %8.3f%8.3f%8.3f%6.2f%6.2f      %-4s%2s%-2s\n",
            @aryRecord[i],
            i+1,  # @arySerial[i]
            @aryName[i],
            @aryAltLoc[i],
            @aryResName[i],
            @aryChainID[i],
            @aryResSeq[i],
           # @aryiCode[i],
            @aryX[i],
            @aryY[i],
            @aryZ[i],
            @aryOccupancy[i],
            @aryTempFactor[i],
            @arySegID[i],
            @aryElement[i],
            @aryCharge[i] 
           ) 
}
puts @footer
end
