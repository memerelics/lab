#!/usr/bin/ruby

if ARGV[0] =~ /\.tex/
    fileBaseName = ARGV[0].sub(".tex", "") 
else
    fileBaseName = ARGV[0]
end

%x(
platex #{fileBaseName}
bibtex #{fileBaseName}
platex #{fileBaseName}
platex #{fileBaseName}
dvipdfmx #{fileBaseName}.dvi
rm -rf #{fileBaseName}.aux
rm -rf #{fileBaseName}.dvi
rm -rf #{fileBaseName}.blg
rm -rf #{fileBaseName}.bbl
rm -rf #{fileBaseName}.log
rm -rf #{fileBaseName}.toc
open -a Skim.app #{fileBaseName}.pdf
)
