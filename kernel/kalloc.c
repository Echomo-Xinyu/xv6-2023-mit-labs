// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

struct {
  struct spinlock reflock;
  char refcount[PHYSTOP/PGSIZE];
} ref;


void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&ref.reflock, "kmemref");
  freerange(end, (void*)PHYSTOP);
  memset(&ref.refcount, 0, PHYSTOP/PGSIZE);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);

  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    ref.refcount[(uint64)p/PGSIZE] = 1;
    kfree(p);
  }
}

void
incref(uint64 pa)
{
  int pn = pa / PGSIZE;
  acquire(&ref.reflock);
  if(pa >= PHYSTOP || ref.refcount[pn] < 1)
    panic("incref");
  ref.refcount[pn] += 1;
  release(&ref.reflock);
}

int
getref(uint64 pa)
{
  int pn = pa / PGSIZE;
  acquire(&ref.reflock);
  int refcnt = ref.refcount[pn];
  release(&ref.reflock);
  return refcnt;
}

void
decref(uint64 pa)
{
  int pn = pa / PGSIZE;
  acquire(&ref.reflock);
  if(pa >= PHYSTOP || ref.refcount[pn] < 1)
    panic("decref");
  ref.refcount[pn] -= 1;
  release(&ref.reflock);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  if(getref((uint64)pa) < 1)
    panic("kfree ref");
  
  decref((uint64)pa);
  int temp = getref((uint64)pa);

  // only free the page when no ref to page
  if(temp > 0)
    return;

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r){
    kmem.freelist = r->next;
    uint pn = (uint64)r / PGSIZE;
    if(ref.refcount[pn] != 0)
      panic("kalloc ref non zero!");
    ref.refcount[pn] = 1;
  }
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
