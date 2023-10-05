#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
    int sec;

    if (argc < 2){
        fprintf(2, "usage: sleep seconds\n");
        exit(0);
    }
    sec = atoi(argv[1]);
    if (sec > 0){
        sleep(sec);
    } else {
        fprintf(2, "Invalid interval %s\n", &argv[1]);
    }
    exit(0);
}
