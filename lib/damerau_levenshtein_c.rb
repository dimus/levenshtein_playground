#!/usr/bin/env ruby
# encoding: UTF-8
require 'rubygems'
require 'inline'
require 'time'

class DamerauLevenshtein


 inline do |builder|
   builder.c "
   static VALUE distance_utf(VALUE _s, VALUE _t){
     int min, i,j, sl, tl, cost, *d, distance, del, ins, subs, transp;
     
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
       for(j = 1; j<tl; j++){
         cost = 1;
         if(s[i-1] == t[j-1]) cost = 0;
         del = d[j*sl + i - 1] + 1; 
         ins = d[(j-1)*sl + i] + 1;
         subs = d[(j-1)*sl + i - 1] + cost;
         min = del;
         if (ins < min) min = ins;
         if (subs < min) min = subs;
         if(i > 2 && j > 2 && s[i-2] == t[j-3] && s[i-3] == t[j-2]){
           transp = d[(j-2)*sl + i - 2] + cost;
           if(transp < min) min = transp;
         }
         d[j*sl+i]=min;
       }
     }
     distance=d[sl * tl - 1];
     
     
     free(d);
     return INT2NUM(distance);
   }
  "
 end
  
  inline do |builder|
    builder.c "
    static int distance(char *s, char *t){
      int min, i,j, sl, tl, cost, *d, distance, del, ins, subs, transp;
      
      sl=strlen(s);
      tl=strlen(t);
      if (sl == 0) return tl;
      if (tl == 0) return sl;
      sl++;
      tl++;
      //one-dimentional representation of 2 dimentional array len(s)+1 * len(t)+1
      d = malloc((sizeof(int))*(sl)*(tl));
      //populate 'horisonal' row
      for(i = 0; i < sl ;i++){
        d[i] = i;
      }
      //populate 'vertical' row starting from the 2nd position (first one is filled already)
      for(i = 1; i < tl; i++){
        d[i*sl] = i;
      }
      //fill up array with scores
      for(i = 1; i<sl; i++){
        for(j = 1; j<tl; j++){
          cost = 1;
          if(s[i-1] == t[j-1]) cost = 0;
          del = d[j*sl + i - 1] + 1; 
          ins = d[(j-1)*sl + i] + 1;
          subs = d[(j-1)*sl + i - 1] + cost;
          min = del;
          if (ins < min) min = ins;
          if (subs < min) min = subs;
          if(i > 2 && j > 2 && s[i-2] == t[j-3] && s[i-3] == t[j-2]){
            transp = d[(j-2)*sl + i - 2] + cost;
            if(transp < min) min = transp;
          }
          d[j*sl+i]=min;
        }
      }
      distance=d[sl * tl - 1];
      free(d);
      return distance;
    }
  	"
	end
end


a=DamerauLevenshtein.new
s = 'Cedarinia scabra Sjöstedt 1921'.unpack('U*')
t = 'Cedarinia scabra Söjstedt 1921'.unpack('U*')

start = Time.now
(1..100000).each do
  a.distance('Cedarinia scabra Sjöstedt 1921', 'Cedarinia scabra Söjstedt 1921')
end
puts "ascii time: " + (Time.now - start).to_s + ' sec'

start = Time.now
(1..100000).each do
  a.distance_utf(s, t)
end
puts 'utf time: ' + (Time.now - start).to_s + ' sec'

puts a.distance('Cedarinia scabra Sjöstedt 1921','Cedarinia scabra Söjstedt 1921') #miscalculates distance by 1
puts a.distance_utf(s, t) #calculates it right
