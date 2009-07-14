#!/usr/bin/env ruby
# encoding: UTF-8
require 'rubygems'
require 'inline'
require 'time'

class DamerauLevenshtein
  def distance(str1, str2, block_size=2, max_distance=10)
    res = distance_utf(str1.unpack("U*"), str2.unpack("U*"), block_size, max_distance)
    (res > max_distance) ? nil : res
  end

  inline do |builder|
    builder.c "
    static VALUE distance_utf(VALUE _s, VALUE _t, int block_size, int max_distance){
      int min, i,j, sl, tl, cost, *d, distance, del, ins, subs, transp, block, current_distance;
      
      int stop_execution = 0;
      
      VALUE *sv = RARRAY(_s)->ptr;
      VALUE *tv = RARRAY(_t)->ptr;
      
      sl = RARRAY(_s)->len;
      tl = RARRAY(_t)->len;
      
      int s[sl];
      int t[tl];
      
      for (i=0; i < sl; i++) s[i] = NUM2INT(sv[i]);
      for (i=0; i < tl; i++) t[i] = NUM2INT(tv[i]);
      
      sl++;
      tl++;
      
      //one-dimentional representation of 2 dimentional array len(s)+1 * len(t)+1
      d = malloc((sizeof(int))*(sl)*(tl));
      //populate 'horisonal' row
      for(i = 0; i < sl; i++){
        d[i] = i;
      }
      //populate 'vertical' row starting from the 2nd position (first one is filled already)
      for(i = 1; i < tl; i++){
        d[i*sl] = i;
      }
      
      //fill up array with scores
      for(i = 1; i<sl; i++){
        if (stop_execution == 1) break;
        current_distance = 10000;
        for(j = 1; j<tl; j++){
          
          block = block_size < i ? block_size : i;
          if (j < block) block = j;
            
          cost = 1;
          if(s[i-1] == t[j-1]) cost = 0;
          
          del = d[j*sl + i - 1] + 1; 
          ins = d[(j-1)*sl + i] + 1;
          subs = d[(j-1)*sl + i - 1] + cost;
          
          min = del;
          if (ins < min) min = ins;
          if (subs < min) min = subs;
          
          if(block > 1 && i > 1 && j > 1 && s[i-1] == t[j-2] && s[i-2] == t[j-1]){
            transp = d[(j-2)*sl + i - 2] + cost;
            if(transp < min) min = transp;
          }
          
          if (current_distance > d[j*sl+i]) current_distance = d[j*sl+i];
          d[j*sl+i]=min;          
        }
        if (current_distance > max_distance) {
          stop_execution = 1;
        }
      }
      distance=d[sl * tl - 1];
      if (stop_execution == 1) distance = current_distance;
      
      free(d);
      return INT2NUM(distance);
    }
   "
  end
end

if __FILE__ == $0
  a=DamerauLevenshtein.new
  s = 'Cedarinia scabra Sjöstedt 1921'.unpack('U*')
  t = 'Cedarinia scabra Söjstedt 1921'.unpack('U*')

  start = Time.now
  (1..100000).each do
    a.distance('Cedarinia scabra Sjöstedt 1921', 'Cedarinia scabra Söjstedt 1921')
  end
  puts "with unpack time: " + (Time.now - start).to_s + ' sec'

  start = Time.now
  (1..100000).each do
    a.distance_utf(s, t, 2, 10)
  end
  puts 'utf time: ' + (Time.now - start).to_s + ' sec'

  puts a.distance('Cedarinia scabra Sjöstedt 1921','Cedarinia scabra Söjstedt 1921')
  puts a.distance_utf(s, t, 2, 10) 
end
