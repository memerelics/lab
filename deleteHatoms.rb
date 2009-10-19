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

listH = ["H", "H1", "H2", "H3",
         "HD", "HD1", "HD2","HD3",
         "HE", "HE1", "HE2", "HE3",
         "HH", "HH1", "HH2", "HH3",
         "HZ", "HZ1","HZ2","HZ3",
         "HG", "HG1", "HG2", "HG3"
         ]

puts @header
@aryRecord.each_with_index {|a, i|
    
   unless listH.include?("#{@aryName[i].split}") 
    printf("%-6s%5d %-4s %3s  %4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n",
            @aryRecord[i],
            @arySerial[i],
            @aryName[i],
            @aryResName[i],
            @aryResSeq[i],
            @aryX[i],
            @aryY[i],
            @aryZ[i],
            @aryOccupancy[i],
            @aryTempFactor[i]
          ) 
   end
}
puts @footer
