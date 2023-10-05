#include "kernel/types.h"
#include "user/user.h"

#define INT_SIZE 4

void exec_pipe(int fd)
{
    int num;
    read(fd, &num, INT_SIZE);
    printf("prime %d\n", num);

    int p[2];
    pipe(p);
    int curr = -1;
    while (1) {
        if (read(fd, &curr, INT_SIZE) <= 0) {
            break;
        }
        if (curr % num != 0) {
            write(p[1], &curr, INT_SIZE);
        }
    }
    if (curr == -1) {
        close(fd);
        close(p[0]);
        close(p[1]);
        exit(0);
    }

    if (fork() == 0){
        close(fd);
        close(p[1]);
        exec_pipe(p[0]);
        close(p[0]);
    } else {
        close(fd);
        close(p[0]);
        close(p[1]);
        wait(0);
    }
}

int
main(int argc, char *argv[])
{
    int p[2];
    pipe(p);

    for (int i=2; i<35; i++){
        int n=i;
        write(p[1], &n, INT_SIZE);
    }
    close(p[1]);
    
    exec_pipe(p[0]);
    close(p[0]);
    exit(0);
}
