// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

struct bucket {
  struct spinlock lock;
  struct buf head;
};

struct {
  struct buf buf[NBUF];
  struct bucket bucket[NBUCKET];
} bcache;

void
binit(void)
{
  struct buf *b;
  struct bucket *bkt;

  for(int i=0; i<NBUCKET; ++i){
    bkt = &bcache.bucket[i];
    initlock(&bkt->lock, "bcache");

    // Create linked list of buffers
    bkt->head.prev = &bkt->head;
    bkt->head.next = &bkt->head;
  }

  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    int idx = hash(b->blockno);
    bkt=&bcache.bucket[idx];

    b->next = bkt->head.next;
    b->prev = &bkt->head;
    initsleeplock(&b->lock, "buffer");
    bkt->head.next->prev = b;
    bkt->head.next = b;
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;
  int idx = hash(blockno);
  struct bucket *bkt = &bcache.bucket[idx];

  acquire(&bkt->lock);

  // Is the block already cached?
  for(b = bkt->head.next; b != &bkt->head; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bkt->lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  release(&bkt->lock);

  // Not cached.
  // serial search for an unused buffer.
  for(int i=idx; i<idx+NBUCKET; ++i){
    int j = hash(i);
    struct bucket *nbkt=&bcache.bucket[j];
    acquire(&nbkt->lock);
    for(b = nbkt->head.prev; b != &nbkt->head; b = b->prev){
      if(b->refcnt == 0) {
        b->dev = dev;
        b->blockno = blockno;
        b->valid = 0;
        b->refcnt = 1;
        if(j==idx){
          release(&nbkt->lock);
        } else {
          //remove from table[j]
          b->next->prev = b->prev;
          b->prev->next = b->next;

          //release current
          release(&nbkt->lock);

          //insert to table[idx]
          acquire(&bkt->lock);

          b->next = bkt->head.next;
          b->prev = &bkt->head;
          bkt->head.next->prev = b;
          bkt->head.next = b;

          release(&bkt->lock);
        }

        acquiresleep(&b->lock);
        return b;
      }
    }
    release(&nbkt->lock);
  }

  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  struct bucket *bkt=&bcache.bucket[hash(b->blockno)];

  acquire(&bkt->lock);
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bkt->head.next;
    b->prev = &bkt->head;
    bkt->head.next->prev = b;
    bkt->head.next = b;
  }
  
  release(&bkt->lock);
}

void
bpin(struct buf *b) {
  struct bucket *bkt=&bcache.bucket[hash(b->blockno)];
  acquire(&bkt->lock);
  b->refcnt++;
  release(&bkt->lock);
}

void
bunpin(struct buf *b) {
  struct bucket *bkt=&bcache.bucket[hash(b->blockno)];
  acquire(&bkt->lock);
  b->refcnt--;
  release(&bkt->lock);
}


