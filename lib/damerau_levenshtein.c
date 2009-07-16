#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

main()
{
  int res;
  int ar1[] = {2,1,3,4};
  int ar2[] = {1,2,3,5};
  res = distance_utf(ar1, ar2, 1, 10);
  printf("%d\n", res);
  return 0;
}


int distance_utf(int *s, int *t, int block_size, int max_distance){
  int min, i,j, sl, tl, cost, *d, distance, del, ins, subs, transp, block, current_distance;
  
  int stop_execution = 0;
  
  sl = sizeof(s);
  tl = sizeof(t);
  
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
  return distance;
}
