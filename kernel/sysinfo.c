#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"
#include "stat.h"
#include "proc.h"
#include "sysinfo.h"

int
systeminfo(uint64 addr) {
  struct proc *p = myproc();
  struct sysinfo si;

  si.freemem = freemem();
  si.nproc = nproc();
  if(copyout(p->pagetable, addr, (char* )&si, sizeof(si)) < 0)
    return -1;
  return 0;
}
