#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char *
fmtname(char *path)
{
  static char buf[DIRSIZ + 1];
  char *p;

  // Find first character after last slash.
  for (p = path + strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if (strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf + strlen(p), '\0', DIRSIZ - strlen(p));
  return buf;
}

void
searchDir(char *path, char *name, char *buf, int fd, struct stat st)
{
  char *p;
  struct dirent de;
  struct stat st2;

  strcpy(buf, path);
  p = buf + strlen(buf);
  *p++ = '/';
  while(read(fd, &de, sizeof(de)) == sizeof(de)){
    if(de.inum == 0)
      continue;
    memmove(p, de.name, DIRSIZ);
    p[DIRSIZ] = 0;
    if(stat(buf, &st) < 0){
      printf("1 find: cannot stat %s\n", buf);
      continue;
    }
    
    if(st.type == T_DIR){
      if (strcmp(fmtname(buf), ".") != 0 && strcmp(fmtname(buf), "..") != 0) {
        int fd2 = open(buf, O_RDONLY);
        if(fstat(fd, &st2) < 0){
          fprintf(2, "2 find: cannot stat %s\n", path);
          close(fd);
          return;
        }
        searchDir(buf, name, buf, fd2, st2);
        close(fd2);
      }
    } else if (st.type == T_FILE && strcmp(fmtname(buf), name) == 0) {
      printf("%s\n", buf);
    }
  }
}

void
find(char *path, char *name)
{
  char buf[512];
  int fd;
  struct stat st;

  if((fd=open(path, O_RDONLY)) < 0){
    fprintf(2, "3 find: cannot open %s\n", path);
    close(fd);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "4 find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  if(st.type == T_DIR){
    searchDir(path, name, buf, fd, st);
  }
  close(fd);
}

int main(int argc, char *argv[])
{
  if (argc != 3)
  {
    fprintf(2, "find need two arguments");
    exit(-1);
  }
  find(argv[1], argv[2]);
  exit(0);
}
