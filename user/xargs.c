#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char *argv[])
{
  if (argc < 2){
    fprintf(2, "usage: xargs <command> [argv..]\n");
    exit(-1);
  }

  char buf[MAXARG];
  char *p = buf, *v[MAXARG], ch;
  int c, blanks = 0, offset = 0;

  for (c=1; c<argc; c++){
    v[c-1] = argv[c];
  }
  c--;

  while (read(0, &ch, 1) > 0){
    if (ch == ' ' || ch == '\t'){
      blanks++;
      continue;
    }

    if (blanks){
      buf[offset++] = 0;

      v[c++] = p;
      p = buf + offset;

      blanks = 0;
    }

    if (ch != '\n'){
      buf[offset++] = ch;
    } else{
      v[c++] = p;
      p = buf + offset;

      if (!fork()){
        exit(exec(v[0], v));
      }
      wait(0);

      c = argc - 1;
    }
  }

  exit(0);
}
