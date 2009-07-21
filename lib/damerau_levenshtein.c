#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

main()
{
  int res;
  int ar1[] = {1,2};
  int ar2[] = {2,1};
  int ar1len = sizeof ar1/sizeof *ar1;
  int ar2len = sizeof ar2/sizeof *ar2;
  printf("lengths: %d, %d\n", ar1len, ar2len);
  res = distance_utf(ar1, ar2, ar1len, ar2len, 1, 10);
  printf("res: %d\n", res);
  return 0;
}


int distance_utf(int *_s, int *_t, int _slen, int _tlen, int block_size, int max_distance){
  int min, i, i1, j, j1, k, start, sl, half_sl, sl_orig, tl, half_tl, tl_orig, cost, *d, distance, del, ins, subs, transp, block, current_distance;

  int stop_execution = 0;
  
  sl = sl_orig = _slen;
  tl = tl_orig = _tlen;
  
  int *s = _s;
  int *t = _t;

  if (sl == 0) return tl;
  if (tl == 0) return sl;
  if (sl == 1 && tl == 1 && _s[0] != _t[0]) return 1;


  //find where elements of arrays start to differ
  //for (i=0; (i < sl && i < tl); i++) {
  //  if (_s[i] != _t[i]){
  //    start = i;
  //    break;
  //  }
  //}
  //if (start == -1) start = i;
  //sl -= start;
  //tl -= start;
  //
  ////return shortcut values
  //if (sl == 0 && tl == 0) return 0;
  //if (sl == 0) return tl;
  //if (tl == 0) return sl;
  //if (sl == 1 && tl == 1 && _s[0] != _t[0]) return 1;
  //
  //int s[sl];
  //int t[tl];
  //for (i = start; i < sl; i++) {
  //  s[i - start] = _s[i];
  //}
  //for (i = start; i < tl; i++) t[i-start] = _t[i];
  
  sl++;
  tl++;
  
  //one-dimentional representation of 2 dimentional array len(s)+1 * len(t)+1
  d = malloc((sizeof(int))*(sl)*(tl));
  //populate 'vertical' row starting from the 2nd position (first one is filled already)
  for(i = 1; i < tl; i++){
    d[i*sl] = i;
  }
  
  //fill up array with scores
  for(i = 1; i<sl; i++){
    d[i] = i;
    if (stop_execution == 1) break;
    current_distance = 10000;
    for(j = 1; j<tl; j++){
      printf("ints: %d, %d\n", s[i-1], t[j-1]);
      cost = 1;
      if(s[i-1] == t[j-1]) cost = 0;
      
      half_sl = (sl - 1)/2;
      half_tl = (tl - 1)/2;
      
      block = block_size < half_sl ? block_size : half_sl;
      block = block < half_tl ? block : half_tl;
      printf("  block: %d\n", block);
      while (block >= 1){   
        long swap1 = 1;
        long swap2 = 1;
        i1 = i - (block * 2);
        j1 = j - (block * 2);
        printf("  i1,j1: %d, %d\n", i1,j1);
        for (k = i1; k < i1 + block; k++) {
          if (s[k] != t[k + block]){
            swap1 = 0;
            break;
          }
        }
        for (k = j1; k < j1 + block; k++) {
          if (t[k] != s[k + block]){
            swap2 = 0;
            break;
          }
        }
        
        del = d[j*sl + i - 1] + 1; 
        ins = d[(j-1)*sl + i] + 1;
        min = del;
        if (ins < min) min = ins;
        if (i >= block && j >= block) printf("  swaps 1,2: %d, %d\n", swap1, swap2); 
        if (i >= block && j >= block && swap1 == 1 && swap2 == 1){
          transp = d[(j - block * 2) * sl + i - block * 2] + cost + block -1; 
          if (transp < min) min = transp;
          block = 0;
        } else if (block == 1) {
          subs = d[(j-1)*sl + i - 1] + cost;
          if (subs < min) min = subs;
        }
        block--;
      } 
        d[j*sl+i]=min;          
        if (current_distance > d[j*sl+i]) current_distance = d[j*sl+i];
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
