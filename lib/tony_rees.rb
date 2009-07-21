#!/usr/bin/env ruby
# encoding UTF-8
require 'pp'


class TonyRees

  def distance(str1, str2, block_size=1, max_distance=10)
    mdld(str1.unpack("U*"), str2.unpack("U*"), block_size, max_distance)
  end

  def mdld(p_str1, p_str2, p_block_limit=1, max_distance=10)
    stop_execution = false;
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
    (0..v_str1_length).each do |s|
      v_my_columns[s] = [0] * (v_str2_length + 1) 
    end
    # enter values in first (leftmost) column (first row in our case)
    (0..v_str2_length).each do |t|
      v_my_columns[0][t] = t
    end
  
    # populate remaining columns (rows in our case)
    (1..v_str1_length).each do |s|
      current_distance = 10000;
      v_my_columns[s][0] = s 
      # populate each cell of one column:
      (1..v_str2_length).each do |t|
        # calculate cost
        v_this_cost = (v_temp_str1[s-1] == v_temp_str2[t-1]) ? 0 : 1
        # extension to cover multiple single, double, triple, etc character transpositions
        # that includes caculation of original Levenshtein distance when no transposition found
        v_temp_block_length = [v_str1_length/2, v_str2_length/2, p_block_limit].min
        # puts [s,t,v_temp_block_length].join(':')
        while v_temp_block_length >= 1
          s1 = s - (v_temp_block_length * 2)
          t1 = t - v_temp_block_length
          s2 = s - v_temp_block_length
          t2 = t - (v_temp_block_length * 2)
          if s >= (v_temp_block_length * 2) && t >= (v_temp_block_length * 2) && v_temp_str1[s1, v_temp_block_length] == v_temp_str2[t1, v_temp_block_length] && v_temp_str1[s2, v_temp_block_length] == v_temp_str2[t2, v_temp_block_length]
            # puts 'tr'
            # puts [s,t].join ","
            # puts [v_temp_str1[s1, v_temp_block_length],v_temp_str2[t1, v_temp_block_length], v_temp_str1[s2, v_temp_block_length],v_temp_str2[t2, v_temp_block_length]].join(",")
            v_my_columns[s][t] = [
              v_my_columns[s][t - 1] + 1,
              v_my_columns[s - 1][t] + 1,
              (v_my_columns[s - (v_temp_block_length * 2)][t - (v_temp_block_length * 2)] + v_this_cost + (v_temp_block_length - 1))
            ].min
            v_temp_block_length = 0
          
          elsif v_temp_block_length == 1
            # puts 'lev'
            # puts [s,t].join ','
            v_my_columns[s][t] = [
              v_my_columns[s][t - 1] + 1,
              v_my_columns[s - 1][t] + 1,
              v_my_columns[s - 1][t - 1] + v_this_cost
            ].min
          end
          v_temp_block_length -= 1
        end
        current_distance = v_my_columns[s][t] if current_distance > v_my_columns[s][t]
      end
      return nil if current_distance > max_distance
    end

   # pp v_my_columns
   v_my_columns[v_str1_length][v_str2_length]
  end
end

if __FILE__ == $0
  a = TonyRees.new
  puts a.distance('Potamomus','Pomatomsu',1, 10)
end

