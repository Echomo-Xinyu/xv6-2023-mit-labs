# xv6-2023-mit-labs

This repository stores my solutions to labs in [MIT 6.S081 Operating System Engineering 2023](https://pdos.csail.mit.edu/6.S081/2023/).

By now I have successfully scored full marks for all the labs and you may refer to different branches for specific implementations.

In summary, I have augmented the [Xv6, a simple Unix-like teaching operating system](https://pdos.csail.mit.edu/6.828/2023/xv6.html)
by adding numerous features as below. You may refer to [6.S081 Home Page](https://pdos.csail.mit.edu/6.S081/2023/) for detailed
instructions of each lab.

- `Lab Utilities` at branch `util`
  - user-level `sleep` program to sleep for specified ticks
  - user-level `pingpong` program to achieve inter-process communication
  - user-level `prime sieve` program with `pipes` and `fork`
  - simple version of UNIX `find` program
  - simple version of UNIX `xargs` program
- `Lab System Call` at branch `syscall`
  - add a system-call tracing feature via new `trace` system call
  - add a system-info collection feature via new `sysinfo` system call
- `Lab Page Tables` at branch `pgtbl`
  - add read-only page to eliminate need for context switch during `getpid` system call
  - add function to print a page table
  - add system call `pgaccess` to report which pages have been accessed (read or write)
- `Lab Traps` at branch `trap`
  - add `backtrace` to trace stack-frame pointers to return to in the caller stack
  - add a system call `alarm` to periodically run specified function after specified ticks
- `Lab Copy-on-Write Fork` at branch `cow`
  - implement copy-on-write fork
- `Lab Multithreading` at branch `thread`
  - implement context switch for threads
  - fix `ph.c` program with mutex
  - achieve correct barrier behaviour
- `Lab Networking` at branch `net`
  - implement transmit and receive function on provided E1000 network driver
- `Lab Locks` at branch `lock`
  - implement per-CPU freelist (each with locks) and stealing mechanism to reduce kmem lock contention
  - modify buffer cache with hash-table search and lock for each bucket to reduce bcache lock contention
- `Lab File System` at branch `fs`
  - add double-indirect block in inode to support big files
  - add `symlink` system call to create a soft link
- `Lab Memory Mapping` at branch `mmap`
  - implement `mmap` and `munmap` to allow detailed control over address spaces via memory mapping
