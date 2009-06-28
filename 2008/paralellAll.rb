#! /usr/bin/env ruby

@ary = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y' ] 
@ary1 = ['T', 'V', 'W', 'Y'] 
@ary2 = ['T', 'V', 'W', 'Y'] 

case ARGV[0]
when nil
  puts "     To use this script, select 1leap / 3eq / 4md / 5mmpbsa as an argument."
  puts "     You can also use 2nd ARG \"bes2\", if you want run calc in the bes2 queue."
when "1leap"
  @ary.each{|first|
    @ary.each{|second|
      if first <= second
        if File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/1leap/#{first}-#{second}_no.pdb") == false \
          && File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/2min/min#{first}#{second}.rst") == false
          print "you're running #{ARGV[0]} for  #{first}-#{second}","\n"
          %x(
          cd #{first}-X/#{first.downcase}-#{second.downcase}/1leap
          cp /work/thashimo/Next/leap_and_runmin.rb .
          mv ../../#{first}-#{second}_no.pdb .
          )
          if ARGV[1] == "bes2"
            %x(
            cd #{first}-X/#{first.downcase}-#{second.downcase}/1leap
            ruby leap_and_runmin.rb #{first} #{second} 2
            )
            #{first}-#{second}: has been submitted.
          else
            %x[
            cd #{first}-X/#{first.downcase}-#{second.downcase}/1leap
            ruby leap_and_runmin.rb #{first} #{second}
            ]
            #{first}-#{second}: has been submitted.
          end
        end
      end
    }
  }

when "2min"
  puts "2min is connected with 1leap"

when "3eq"
  @ary.each{|first|
    @ary.each{|second|
      if first <= second
        if File.readlines("#{first}-X/#{first.downcase}-#{second.downcase}/2min/min#{first}#{second}.out").pop =~ /wallclock/ \
          && File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/3eq/eq#{first}#{second}.rst") == false

          print "you're running #{ARGV[0]} for  #{first}-#{second}","\n"
          %x{
            cd #{first}-X/#{first.downcase}-#{second.downcase}/3eq
            cp /work/thashimo/Next/eqrun_gbsa.rb .
          }
          if ARGV[1] == "bes2"
            %x{
              cd #{first}-X/#{first.downcase}-#{second.downcase}/3eq
              ruby eqrun_gbsa.rb #{first} #{second} 2
            }
            #{first}-#{second}: has been submitted.
          else
            %x{
              cd #{first}-X/#{first.downcase}-#{second.downcase}/3eq
              ruby eqrun_gbsa.rb #{first} #{second}
            } 
            #{first}-#{second}: has been submitted.
          end
        end
      end
    }
  }

when "4md"
  @ary.each{|first|
    @ary.each{|second|
      if first <= second
        if File.readlines("#{first}-X/#{first.downcase}-#{second.downcase}/3eq/eq#{first}#{second}.out").pop =~ /wallclock/
          if File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/4md/md#{first}#{second}.rst")
            puts "you already run #{first}-#{second} 4md" 
          else
            print "you're running #{ARGV[0]} for  #{first}-#{second}","\n"
            %x{
              cd #{first}-X/#{first.downcase}-#{second.downcase}/4md
              cp /work/thashimo/Next/mdrun_gbsa.rb .
            }
            if ARGV[1] == "bes2"
              %x{
                cd #{first}-X/#{first.downcase}-#{second.downcase}/4md
                ruby mdrun_gbsa.rb #{first} #{second} 2
              }
            #{first}-#{second}: has been submitted.
            else
              %x{
                cd #{first}-X/#{first.downcase}-#{second.downcase}/4md
                ruby mdrun_gbsa.rb #{first} #{second}
              } 
            #{first}-#{second}: has been submitted.
            end
          end
        end
      end
    }
  }

when "5mmpbsa"
  @ary1.each{|first|
    @ary2.each{|second|
      if first <= second
        if File.readlines("#{first}-X/#{first.downcase}-#{second.downcase}/4md/md#{first}#{second}.out").pop =~ /wallclock/ 
          if File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/5mmpbsa/#{first}#{second}_gbNext_statistics.out") 
            puts "already analyzed #{first}-#{second}"
          else
            print "you're running #{ARGV[0]} for  #{first}-#{second}","\n"
            %x{
              cd #{first}-X/#{first.downcase}-#{second.downcase}/5mmpbsa
              cp /work/thashimo/Next/analNext.rb .
              ruby analNext.rb #{first} #{second}
            } 
          end
        else
          puts "md#{first}#{second} isn't yet finished"
        end
      end
    }
  }

when "allzip"
  # need to make a reverse pattern, allunzip
  lostmdcrd = []
  @ary.each{|first|
    @ary.each{|second|
      if first <= second
          if File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/4md/md#{first}#{second}.mdcrd.gz") 
            puts "#{first}-#{second} is already zipped. "
          elsif File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/4md/md#{first}#{second}.mdcrd") 
            print "zipping  #{first}-#{second}... ","\n"
            %x{
              cd #{first}-X/#{first.downcase}-#{second.downcase}/4md
              gzip md#{first}#{second}.mdcrd
            } 
          elsif File.exists?("#{first}-X/#{first.downcase}-#{second.downcase}/5mmpbsa/md#{first}#{second}.mdcrd") 
            print "zipping  #{first}-#{second}... ","\n"
            %x{
              cd #{first}-X/#{first.downcase}-#{second.downcase}/5mmpbsa
              gzip md#{first}#{second}.mdcrd
            } 
          end
        else
          puts "md#{first}#{second}.mdcrd isn't exist in 4md or 5mmpbsa."
          lostmdcrd << "md#{first}#{second}.mdcrd"
        end
    }
  }
  print "these files are lost."
  p lostmdcrd

end
