#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

main()
{
  int res;
  char *str1 = "kukun";
  char *str2 = "kukuk";
  res = distance(str1, str2);
  printf("%d\n", res);
  return 0;
}


int distance(char *s, char *t){
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
  for(i = 1; i<=sl; i++){
    for(j = 1; j<=tl; j++){
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
