#!/usr/bin/env ruby1.9
# encoding UTF-8
require 'pp'

def distance(str1, str2, max_dist, transposition_limit = 2)
  sl1 = str1.size
  sl2 = str2.size
  return 0 if str1 == str2
  return sl1 if sl2 == 0
  return sl2 if sl1 == 0
  
  d = []
  d[0] = (sl2 + 1).times.map {|i| i}
  (sl1 + 1).times do |i|
    d[i] = [i] + [0] * (sl1 - 1) if i > 0
  end
  
  (1..sl1).each do |i|
    current_dist = 10000
    (1..sl2).each do |j|
      block = [transposition_limit, j-1, i-1].min
      #Standard Levenstein
      cost = (str1[i-1] == str2[j-1]) ? 0 : 1
      d[i][j] = [
        d[i-1][j-1] + cost, #subst
        d[i][j-1] + 1, #ins
        d[i-1][j] + 1 #del
      ].min
      #standard Damerau-Levenstein
      if ( (block == 2) && str1[i-1] == str2[j-2] && str2[j-1] == str1[i-2])
        d[i][j] = [d[i][j], d[i-2][j-2] + cost].min #trans
      end
      #find if letters in the block are the same
      if ( block > 2)
        puts block
        set1 = str1[i - block - 1, i - 1].split('').sort
        set2 = str2[j - block - 1, j - 1].split('').sort
        d[i][j] = [d[i][j], d[i-block][j-block] + 1].min if set1==set2
      end
      if current_dist > d[i][j]
        current_dist = d[i][j]
      end
    end  
    return if current_dist > max_dist
  end
  
  pp d
  return d[sl2][sl1]
end

puts distance('rPotozoa', 'Protoozo', 10, 1)
