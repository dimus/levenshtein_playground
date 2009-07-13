#!/usr/bin/env ruby1.9
# encoding UTF-8
require 'pp'
require 'set'

def distance(str1,str2, max_dist, transposition_limit = 2)
  sl1 = str1.size
  sl2 = str2.size
  return 0 if str1 == str2
  return sl1 if sl2 == 0
  return sl2 if sl1 == 0
  
  d = []
  d[0] = sl2.times.map {|i| i}
  sl1.times do |i|
    d[i] = [i] + [0] * (sl1 - 1) if i > 0
  end
  
  (1...sl1).each do |i|
    current_dist = 10000
    (1...sl2).each do |j|
      block = [transposition_limit, j, i].min
      #Standard Levenstein
      cost = (str1[i] == str2[j]) ? 0 : 1
      d[i][j] = [
        d[i-1][j-1] + cost, #subst
        d[i][j-1] + 1, #ins
        d[i-1][j] + 1 #del
      ].min
      #standard Damerau-Levenstein
      if ( (block == 2) && str1[i] == str2[j-1] && str2[j] == str1[i-1])
        d[i][j] = [d[i][j], d[i-2][j-2] + cost].min #trans
      end
      #find if letters in the block are the same
      if ( block > 2)
        set1 = str1[i - block, i].split('').sort
        set2 = str2[j - block, j].split('').sort
        d[i][j] = [d[i][j], d[i-block][j-block] + 1].min if set1==set2
      end
      if current_dist > d[i][j]
        current_dist = d[i][j]
      end
    end  
    return if current_dist > max_dist
  end
  
  pp d
  return d[sl2-1][sl1-1]
end

puts distance('Pmtoomusa saltarot', 'Pomatomus saltator', 60, 40)
