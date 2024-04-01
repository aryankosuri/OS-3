// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"

void freerange(void *vstart, void *vend);
uint page_framec[PHYSTOP >> PGSHIFT];
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
  
} kmem;

int free_frame_cnt = 0; // xv6 proj - cow

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
    page_framec[V2P(p) >> PGSHIFT] = 0;
    kfree(p);
  }
}
//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void icount(uint pa, int inc)
{
  if(PHYSTOP <= pa || (uint)V2P(end) > pa)
    panic("Increaseframes");  

  acquire(&kmem.lock);
   if(inc == 1){
    page_framec[pa >> PGSHIFT] = page_framec[pa >> PGSHIFT] + 1;
   }
   if(inc == 0){
     page_framec[pa >> PGSHIFT] = page_framec[pa >> PGSHIFT] - 1;
   }
  release(&kmem.lock);
}

uint fcount(uint pa)
{
  if(PHYSTOP <= pa || (uint)V2P(end) > pa)
    panic("Retriveframes"); 

  uint frame;
  acquire(&kmem.lock);
  frame = page_framec[pa >> PGSHIFT];
  release(&kmem.lock);

  return frame;
} 

void
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  if(page_framec[V2P(v) >> PGSHIFT] > 0)         
    page_framec[V2P(v) >> PGSHIFT] = page_framec[V2P(v) >> PGSHIFT] - 1;

  if(page_framec[V2P(v) >> PGSHIFT] == 0){      
  memset(v, 1, PGSIZE);
  r->next = kmem.freelist;
  kmem.freelist = r;
  free_frame_cnt++; // xv6 proj - cow
  }
  if(kmem.use_lock)
    release(&kmem.lock);
}

/*void dcount(uint pa)
{ 
  if(PHYSTOP <= pa || (uint)V2P(end) > pa)
    panic("ReduceFrames"); 

  acquire(&kmem.lock);
  page_framec[pa >> PGSHIFT] = page_framec[pa >> PGSHIFT] - 1;
  release(&kmem.lock);
}*/

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
  {
    page_framec[V2P((char*)r) >> PGSHIFT] = 1; 
    kmem.freelist = r->next;
	  free_frame_cnt--; // xv6 proj - cow
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
