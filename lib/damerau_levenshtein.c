#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

main()
{
  int res;
  int ar1[] = {1,2};
  int ar2[] = {1,2,3,5,4,6};
  res = distance_utf(ar1, ar2, 1, 10);
  printf("%d\n", res);
  return 0;
}


int distance_utf(int *_s, int *_t, int block_size, int max_distance){
  int min, i, j, start, sl, sl_orig, tl, tl_orig, cost, *d, distance, del, ins, subs, transp, block, current_distance;

  int stop_execution = 0;
  
  sl = sl_orig = sizeof _s;
  tl = tl_orig = sizeof _t;
  printf("%d, %d\n\n", sizeof &_s, sizeof _s);

  if (sl == 0) return tl;
  if (tl == 0) return sl;
  if (sl == 1 && tl == 1 && _s[0] != _t[0]) return 1;

  //find where elements of arrays start to differ
  for (i=0; (i < sl && i < tl); i++) {
    if (_s[i] != _t[i]){
      start = i;
      break;
    }
  }
  if (start == -1) start = i;
  printf("%d, %d, %d\n", start, sl, tl); 
  sl -= start;
  tl -= start;
  
  //return shortcut values
  if (sl == 0 && tl == 0) return 0;
  if (sl == 0) return tl;
  if (tl == 0) return sl;
  if (sl == 1 && tl == 1 && _s[0] != _t[0]) return 1;
  
  int s[sl];
  int t[tl];
  for (i = start; i < sl; i++) {
    printf("%d, %d\n", i, start);
    s[i - start] = _s[i];
  }
  for (i = start; i < tl; i++) t[i-start] = _t[i];
  
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
