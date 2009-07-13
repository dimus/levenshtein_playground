#!/usr/bin/env ruby1.9
# encoding UTF-8
require 'pp'

def mdld(p_str1, p_str2, p_block_limit=1)
  v_str1_length = p_str1.size rescue 0
  v_str2_length = p_str2.size rescue 0
  v_temp_str1 = ''
  v_temp_str2 = ''

  v_my_columns = []
  v_empty_column = nil
  v_this_cost = 0
  v_temp_block_length = nil

  return 0 if p_str1 == p_str2
  return [v_str1_length, v_str2_length].max if (v_str1_length == 0 || v_str2_length == 0)
  return 1 if v_str1_length == 1 && v_str2_length == 1 && p_str1 != p_str2

  v_temp_str1 = p_str1
  v_temp_str2 = p_str2

  # first trim common leading characters
  while v_temp_str1[0] == v_temp_str2[0]
    v_temp_str1 = v_temp_str1[1..-1]
    v_temp_str2 = v_temp_str2[1..-1]
  end
  
  # then trim common trailing characters
  while v_temp_str1[-1] == v_temp_str2[-1]
    v_temp_str1 = v_temp_str1[0..-2]
    v_temp_str2 = v_temp_str2[0..-2]
  end

  v_str1_length = v_temp_str1.size
  v_str2_length = v_temp_str2.size

  # then calculate standard Levenshtein Distance
  return [v_str1_length, v_str2_length].max if (v_str1_length == 0 || v_str2_length == 0)
  return 1 if (v_str1_length == 1 && v_str2_length == 1 && p_str1 != p_str2)

  # create columns (rows in our case)
  v_str1_length.times do |s|
    v_my_columns[s] = [0] * v_str2_length
  end
  # enter values in first (leftmost) column (first row in our case)
  v_str2_length.times do |t|
    v_my_columns[0][t] = t
  end
  # populate remaining columns (rows in our case)
  (1...v_str1_length).each do |s|
    puts s
    v_my_columns[s][0] = s 
    # populate each cell of one column:
    (1...v_str2_length).each do |t|
      # calculate cost
      v_this_cost = (v_temp_str1[s] == v_temp_str2[t]) ? 0 : 1
      # extension to cover multiple single, double, triple, etc character transpositions
      # that includes caculation of original Levenshtein distance when no transposition found
      v_temp_block_length = [v_str1_length/2, v_str2_length/2, p_block_limit].min
      while v_temp_block_length >= 1
        s1 = s - ((v_temp_block_length * 2) - 1)
        t1 = t - (v_temp_block_length - 1)
        s2 = s - (v_temp_block_length - 1)
        t2 = t - ((v_temp_block_length * 2) - 1)
        if s >= (v_temp_block_length * 2) && t >= (v_temp_block_length * 2) && v_temp_str1[s1, s1 + v_temp_block_length] == v_temp_str2[t1, t1 + v_temp_block_length] &&
          v_temp_str1[s2, s2 + v_temp_block_length] == v_temp_str2[t2, t2 + v_temp_block_length]
          v_my_columns[s][t] = [
            v_my_columns[s][t - 1] + 1,
            v_my_columns[s - 1][t] + 1,
            (v_my_columns[s - (v_temp_block_length * 2)][t - (v_temp_block_length * 2)] + v_this_cost + (v_temp_block_length -1))
          ].min
          v_temp_block_length = 0
        elsif v_temp_block_length == 1
          puts 'here'
          v_my_columns[s][t] = [
            v_my_columns[s][t - 1] + 1,
            v_my_columns[s - 1][t] + 1,
            v_my_columns[s - 1][t - 1] + v_this_cost
          ].min
        end
        v_temp_block_length -= 1
      end
    end
  end

 pp v_my_columns  
 v_my_columns[v_str1_length-1][v_str2_length-1]
end

puts mdld('Pomatomus','oPmaotmus',1)


