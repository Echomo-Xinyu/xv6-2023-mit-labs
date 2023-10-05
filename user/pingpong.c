#include "kernel/types.h"
#include "user/user.h"
#define MSGSIZE 20

int
main(int argc, char *argv[])
{
    char buffer[MSGSIZE];
    int p[2];
    if (pipe(p) < 0){
        fprintf(2, "error creating pipe");
        exit(-1);
    }

    if (fork() == 0){
        read(p[0], buffer, MSGSIZE);
        fprintf(1, "%d: received %s\n", getpid(), buffer);
        write(p[1], "pong", MSGSIZE);
    } else {
        write(p[1], "ping", MSGSIZE);
        read(p[0], buffer, MSGSIZE);
        fprintf(1, "%d: received %s\n", getpid(), buffer);
    }
    exit(0);
}
