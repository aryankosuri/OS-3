
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 10 e5 14 80       	mov    $0x8014e510,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 33 10 80       	mov    $0x80103300,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 77 10 80       	push   $0x80107700
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 35 46 00 00       	call   80104690 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 77 10 80       	push   $0x80107707
80100097:	50                   	push   %eax
80100098:	e8 e3 44 00 00       	call   80104580 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 b7 46 00 00       	call   801047a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 59 47 00 00       	call   801048c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 44 00 00       	call   801045c0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 7f 22 00 00       	call   80102410 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 77 10 80       	push   $0x8010770e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 9d 44 00 00       	call   80104660 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 37 22 00 00       	jmp    80102410 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 77 10 80       	push   $0x8010771f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 44 00 00       	call   80104660 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 0c 44 00 00       	call   80104620 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 80 45 00 00       	call   801047a0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 4f 46 00 00       	jmp    801048c0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 77 10 80       	push   $0x80107726
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	pushl  0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 f7 16 00 00       	call   80101990 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 fb 44 00 00       	call   801047a0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 4e 40 00 00       	call   80104320 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 39 39 00 00       	call   80103c20 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 c5 45 00 00       	call   801048c0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	pushl  0x8(%ebp)
801002ff:	e8 ac 15 00 00       	call   801018b0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 6f 45 00 00       	call   801048c0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	pushl  0x8(%ebp)
80100355:	e8 56 15 00 00       	call   801018b0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 f2 27 00 00       	call   80102b90 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 77 10 80       	push   $0x8010772d
801003a7:	e8 d4 02 00 00       	call   80100680 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	pushl  0x8(%ebp)
801003b0:	e8 cb 02 00 00       	call   80100680 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 b3 7c 10 80 	movl   $0x80107cb3,(%esp)
801003bc:	e8 bf 02 00 00       	call   80100680 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 e3 42 00 00       	call   801046b0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	pushl  (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 77 10 80       	push   $0x80107741
801003dd:	e8 9e 02 00 00       	call   80100680 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <cgaputc>:
{
80100400:	55                   	push   %ebp
80100401:	89 c1                	mov    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100403:	b8 0e 00 00 00       	mov    $0xe,%eax
80100408:	89 e5                	mov    %esp,%ebp
8010040a:	57                   	push   %edi
8010040b:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100410:	56                   	push   %esi
80100411:	89 fa                	mov    %edi,%edx
80100413:	53                   	push   %ebx
80100414:	83 ec 1c             	sub    $0x1c,%esp
80100417:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100418:	be d5 03 00 00       	mov    $0x3d5,%esi
8010041d:	89 f2                	mov    %esi,%edx
8010041f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100420:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100423:	89 fa                	mov    %edi,%edx
80100425:	c1 e0 08             	shl    $0x8,%eax
80100428:	89 c3                	mov    %eax,%ebx
8010042a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010042f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100430:	89 f2                	mov    %esi,%edx
80100432:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100433:	0f b6 c0             	movzbl %al,%eax
80100436:	09 d8                	or     %ebx,%eax
  if(c == '\n')
80100438:	83 f9 0a             	cmp    $0xa,%ecx
8010043b:	0f 84 97 00 00 00    	je     801004d8 <cgaputc+0xd8>
  else if(c == BACKSPACE){
80100441:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
80100447:	74 77                	je     801004c0 <cgaputc+0xc0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100449:	0f b6 c9             	movzbl %cl,%ecx
8010044c:	8d 58 01             	lea    0x1(%eax),%ebx
8010044f:	80 cd 07             	or     $0x7,%ch
80100452:	66 89 8c 00 00 80 0b 	mov    %cx,-0x7ff48000(%eax,%eax,1)
80100459:	80 
  if(pos < 0 || pos > 25*80)
8010045a:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100460:	0f 8f cc 00 00 00    	jg     80100532 <cgaputc+0x132>
  if((pos/80) >= 24){  // Scroll up.
80100466:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010046c:	0f 8f 7e 00 00 00    	jg     801004f0 <cgaputc+0xf0>
  outb(CRTPORT+1, pos>>8);
80100472:	0f b6 c7             	movzbl %bh,%eax
  outb(CRTPORT+1, pos);
80100475:	89 df                	mov    %ebx,%edi
  crt[pos] = ' ' | 0x0700;
80100477:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
  outb(CRTPORT+1, pos>>8);
8010047e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100481:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100486:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048b:	89 da                	mov    %ebx,%edx
8010048d:	ee                   	out    %al,(%dx)
8010048e:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100493:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80100497:	89 ca                	mov    %ecx,%edx
80100499:	ee                   	out    %al,(%dx)
8010049a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049f:	89 da                	mov    %ebx,%edx
801004a1:	ee                   	out    %al,(%dx)
801004a2:	89 f8                	mov    %edi,%eax
801004a4:	89 ca                	mov    %ecx,%edx
801004a6:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a7:	b8 20 07 00 00       	mov    $0x720,%eax
801004ac:	66 89 06             	mov    %ax,(%esi)
}
801004af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004b2:	5b                   	pop    %ebx
801004b3:	5e                   	pop    %esi
801004b4:	5f                   	pop    %edi
801004b5:	5d                   	pop    %ebp
801004b6:	c3                   	ret    
801004b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004be:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
801004c3:	85 c0                	test   %eax,%eax
801004c5:	75 93                	jne    8010045a <cgaputc+0x5a>
801004c7:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
801004cb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004d0:	31 ff                	xor    %edi,%edi
801004d2:	eb ad                	jmp    80100481 <cgaputc+0x81>
801004d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004d8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004dd:	f7 e2                	mul    %edx
801004df:	c1 ea 06             	shr    $0x6,%edx
801004e2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004e5:	c1 e0 04             	shl    $0x4,%eax
801004e8:	8d 58 50             	lea    0x50(%eax),%ebx
801004eb:	e9 6a ff ff ff       	jmp    8010045a <cgaputc+0x5a>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f0:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004f3:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004f6:	8d b4 1b 60 7f 0b 80 	lea    -0x7ff480a0(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fd:	68 60 0e 00 00       	push   $0xe60
80100502:	68 a0 80 0b 80       	push   $0x800b80a0
80100507:	68 00 80 0b 80       	push   $0x800b8000
8010050c:	e8 9f 44 00 00       	call   801049b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100511:	b8 80 07 00 00       	mov    $0x780,%eax
80100516:	83 c4 0c             	add    $0xc,%esp
80100519:	29 f8                	sub    %edi,%eax
8010051b:	01 c0                	add    %eax,%eax
8010051d:	50                   	push   %eax
8010051e:	6a 00                	push   $0x0
80100520:	56                   	push   %esi
80100521:	e8 ea 43 00 00       	call   80104910 <memset>
  outb(CRTPORT+1, pos);
80100526:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
8010052a:	83 c4 10             	add    $0x10,%esp
8010052d:	e9 4f ff ff ff       	jmp    80100481 <cgaputc+0x81>
    panic("pos under/overflow");
80100532:	83 ec 0c             	sub    $0xc,%esp
80100535:	68 45 77 10 80       	push   $0x80107745
8010053a:	e8 41 fe ff ff       	call   80100380 <panic>
8010053f:	90                   	nop

80100540 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100540:	55                   	push   %ebp
80100541:	89 e5                	mov    %esp,%ebp
80100543:	57                   	push   %edi
80100544:	56                   	push   %esi
80100545:	53                   	push   %ebx
80100546:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100549:	ff 75 08             	pushl  0x8(%ebp)
{
8010054c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010054f:	e8 3c 14 00 00       	call   80101990 <iunlock>
  acquire(&cons.lock);
80100554:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010055b:	e8 40 42 00 00       	call   801047a0 <acquire>
  for(i = 0; i < n; i++)
80100560:	83 c4 10             	add    $0x10,%esp
80100563:	85 f6                	test   %esi,%esi
80100565:	7e 3a                	jle    801005a1 <consolewrite+0x61>
80100567:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010056a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010056d:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100573:	85 d2                	test   %edx,%edx
80100575:	74 09                	je     80100580 <consolewrite+0x40>
  asm volatile("cli");
80100577:	fa                   	cli    
    for(;;)
80100578:	eb fe                	jmp    80100578 <consolewrite+0x38>
8010057a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100580:	0f b6 03             	movzbl (%ebx),%eax
    uartputc(c);
80100583:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < n; i++)
80100586:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100589:	50                   	push   %eax
8010058a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010058d:	e8 6e 5a 00 00       	call   80106000 <uartputc>
  cgaputc(c);
80100592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100595:	e8 66 fe ff ff       	call   80100400 <cgaputc>
  for(i = 0; i < n; i++)
8010059a:	83 c4 10             	add    $0x10,%esp
8010059d:	39 df                	cmp    %ebx,%edi
8010059f:	75 cc                	jne    8010056d <consolewrite+0x2d>
  release(&cons.lock);
801005a1:	83 ec 0c             	sub    $0xc,%esp
801005a4:	68 20 ff 10 80       	push   $0x8010ff20
801005a9:	e8 12 43 00 00       	call   801048c0 <release>
  ilock(ip);
801005ae:	58                   	pop    %eax
801005af:	ff 75 08             	pushl  0x8(%ebp)
801005b2:	e8 f9 12 00 00       	call   801018b0 <ilock>

  return n;
}
801005b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005ba:	89 f0                	mov    %esi,%eax
801005bc:	5b                   	pop    %ebx
801005bd:	5e                   	pop    %esi
801005be:	5f                   	pop    %edi
801005bf:	5d                   	pop    %ebp
801005c0:	c3                   	ret    
801005c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005cf:	90                   	nop

801005d0 <printint>:
{
801005d0:	55                   	push   %ebp
801005d1:	89 e5                	mov    %esp,%ebp
801005d3:	57                   	push   %edi
801005d4:	56                   	push   %esi
801005d5:	53                   	push   %ebx
801005d6:	83 ec 2c             	sub    $0x2c,%esp
801005d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801005dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
801005df:	85 c9                	test   %ecx,%ecx
801005e1:	74 04                	je     801005e7 <printint+0x17>
801005e3:	85 c0                	test   %eax,%eax
801005e5:	78 7e                	js     80100665 <printint+0x95>
    x = xx;
801005e7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
801005ee:	89 c1                	mov    %eax,%ecx
  i = 0;
801005f0:	31 db                	xor    %ebx,%ebx
801005f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
801005f8:	89 c8                	mov    %ecx,%eax
801005fa:	31 d2                	xor    %edx,%edx
801005fc:	89 de                	mov    %ebx,%esi
801005fe:	89 cf                	mov    %ecx,%edi
80100600:	f7 75 d4             	divl   -0x2c(%ebp)
80100603:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100606:	0f b6 92 70 77 10 80 	movzbl -0x7fef8890(%edx),%edx
  }while((x /= base) != 0);
8010060d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010060f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100613:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100616:	73 e0                	jae    801005f8 <printint+0x28>
  if(sign)
80100618:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010061b:	85 c9                	test   %ecx,%ecx
8010061d:	74 0c                	je     8010062b <printint+0x5b>
    buf[i++] = '-';
8010061f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100624:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100626:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010062b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  if(panicked){
8010062f:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100634:	85 c0                	test   %eax,%eax
80100636:	74 08                	je     80100640 <printint+0x70>
80100638:	fa                   	cli    
    for(;;)
80100639:	eb fe                	jmp    80100639 <printint+0x69>
8010063b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop
    consputc(buf[i]);
80100640:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
80100643:	83 ec 0c             	sub    $0xc,%esp
80100646:	56                   	push   %esi
80100647:	e8 b4 59 00 00       	call   80106000 <uartputc>
  cgaputc(c);
8010064c:	89 f0                	mov    %esi,%eax
8010064e:	e8 ad fd ff ff       	call   80100400 <cgaputc>
  while(--i >= 0)
80100653:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100656:	83 c4 10             	add    $0x10,%esp
80100659:	39 c3                	cmp    %eax,%ebx
8010065b:	74 0e                	je     8010066b <printint+0x9b>
    consputc(buf[i]);
8010065d:	0f b6 13             	movzbl (%ebx),%edx
80100660:	83 eb 01             	sub    $0x1,%ebx
80100663:	eb ca                	jmp    8010062f <printint+0x5f>
    x = -xx;
80100665:	f7 d8                	neg    %eax
80100667:	89 c1                	mov    %eax,%ecx
80100669:	eb 85                	jmp    801005f0 <printint+0x20>
}
8010066b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010066e:	5b                   	pop    %ebx
8010066f:	5e                   	pop    %esi
80100670:	5f                   	pop    %edi
80100671:	5d                   	pop    %ebp
80100672:	c3                   	ret    
80100673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010067a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100680 <cprintf>:
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100689:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
8010068e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100691:	85 c0                	test   %eax,%eax
80100693:	0f 85 37 01 00 00    	jne    801007d0 <cprintf+0x150>
  if (fmt == 0)
80100699:	8b 75 08             	mov    0x8(%ebp),%esi
8010069c:	85 f6                	test   %esi,%esi
8010069e:	0f 84 3f 02 00 00    	je     801008e3 <cprintf+0x263>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006a4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006a7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006aa:	31 db                	xor    %ebx,%ebx
801006ac:	85 c0                	test   %eax,%eax
801006ae:	74 56                	je     80100706 <cprintf+0x86>
    if(c != '%'){
801006b0:	83 f8 25             	cmp    $0x25,%eax
801006b3:	0f 85 d7 00 00 00    	jne    80100790 <cprintf+0x110>
    c = fmt[++i] & 0xff;
801006b9:	83 c3 01             	add    $0x1,%ebx
801006bc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006c0:	85 d2                	test   %edx,%edx
801006c2:	74 42                	je     80100706 <cprintf+0x86>
    switch(c){
801006c4:	83 fa 70             	cmp    $0x70,%edx
801006c7:	0f 84 94 00 00 00    	je     80100761 <cprintf+0xe1>
801006cd:	7f 51                	jg     80100720 <cprintf+0xa0>
801006cf:	83 fa 25             	cmp    $0x25,%edx
801006d2:	0f 84 48 01 00 00    	je     80100820 <cprintf+0x1a0>
801006d8:	83 fa 64             	cmp    $0x64,%edx
801006db:	0f 85 04 01 00 00    	jne    801007e5 <cprintf+0x165>
      printint(*argp++, 10, 1);
801006e1:	8d 47 04             	lea    0x4(%edi),%eax
801006e4:	b9 01 00 00 00       	mov    $0x1,%ecx
801006e9:	ba 0a 00 00 00       	mov    $0xa,%edx
801006ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801006f1:	8b 07                	mov    (%edi),%eax
801006f3:	e8 d8 fe ff ff       	call   801005d0 <printint>
801006f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fb:	83 c3 01             	add    $0x1,%ebx
801006fe:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100702:	85 c0                	test   %eax,%eax
80100704:	75 aa                	jne    801006b0 <cprintf+0x30>
  if(locking)
80100706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100709:	85 c0                	test   %eax,%eax
8010070b:	0f 85 b5 01 00 00    	jne    801008c6 <cprintf+0x246>
}
80100711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100714:	5b                   	pop    %ebx
80100715:	5e                   	pop    %esi
80100716:	5f                   	pop    %edi
80100717:	5d                   	pop    %ebp
80100718:	c3                   	ret    
80100719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	75 33                	jne    80100758 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100725:	8d 47 04             	lea    0x4(%edi),%eax
80100728:	8b 3f                	mov    (%edi),%edi
8010072a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010072d:	85 ff                	test   %edi,%edi
8010072f:	0f 85 33 01 00 00    	jne    80100868 <cprintf+0x1e8>
        s = "(null)";
80100735:	bf 58 77 10 80       	mov    $0x80107758,%edi
      for(; *s; s++)
8010073a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010073d:	b8 28 00 00 00       	mov    $0x28,%eax
80100742:	89 fb                	mov    %edi,%ebx
  if(panicked){
80100744:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010074a:	85 d2                	test   %edx,%edx
8010074c:	0f 84 27 01 00 00    	je     80100879 <cprintf+0x1f9>
80100752:	fa                   	cli    
    for(;;)
80100753:	eb fe                	jmp    80100753 <cprintf+0xd3>
80100755:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100758:	83 fa 78             	cmp    $0x78,%edx
8010075b:	0f 85 84 00 00 00    	jne    801007e5 <cprintf+0x165>
      printint(*argp++, 16, 0);
80100761:	8d 47 04             	lea    0x4(%edi),%eax
80100764:	31 c9                	xor    %ecx,%ecx
80100766:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010076b:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010076e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100771:	8b 07                	mov    (%edi),%eax
80100773:	e8 58 fe ff ff       	call   801005d0 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100778:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
8010077c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077f:	85 c0                	test   %eax,%eax
80100781:	0f 85 29 ff ff ff    	jne    801006b0 <cprintf+0x30>
80100787:	e9 7a ff ff ff       	jmp    80100706 <cprintf+0x86>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100790:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100796:	85 c9                	test   %ecx,%ecx
80100798:	74 06                	je     801007a0 <cprintf+0x120>
8010079a:	fa                   	cli    
    for(;;)
8010079b:	eb fe                	jmp    8010079b <cprintf+0x11b>
8010079d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
801007a0:	83 ec 0c             	sub    $0xc,%esp
801007a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a6:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801007a9:	50                   	push   %eax
801007aa:	e8 51 58 00 00       	call   80106000 <uartputc>
  cgaputc(c);
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	e8 49 fc ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b7:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
801007bb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007be:	85 c0                	test   %eax,%eax
801007c0:	0f 85 ea fe ff ff    	jne    801006b0 <cprintf+0x30>
801007c6:	e9 3b ff ff ff       	jmp    80100706 <cprintf+0x86>
801007cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007cf:	90                   	nop
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ff 10 80       	push   $0x8010ff20
801007d8:	e8 c3 3f 00 00       	call   801047a0 <acquire>
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	e9 b4 fe ff ff       	jmp    80100699 <cprintf+0x19>
  if(panicked){
801007e5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007eb:	85 c9                	test   %ecx,%ecx
801007ed:	75 71                	jne    80100860 <cprintf+0x1e0>
    uartputc(c);
801007ef:	83 ec 0c             	sub    $0xc,%esp
801007f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
801007f5:	6a 25                	push   $0x25
801007f7:	e8 04 58 00 00       	call   80106000 <uartputc>
  cgaputc(c);
801007fc:	b8 25 00 00 00       	mov    $0x25,%eax
80100801:	e8 fa fb ff ff       	call   80100400 <cgaputc>
  if(panicked){
80100806:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010080c:	83 c4 10             	add    $0x10,%esp
8010080f:	85 d2                	test   %edx,%edx
80100811:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100814:	0f 84 8e 00 00 00    	je     801008a8 <cprintf+0x228>
8010081a:	fa                   	cli    
    for(;;)
8010081b:	eb fe                	jmp    8010081b <cprintf+0x19b>
8010081d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100820:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100825:	85 c0                	test   %eax,%eax
80100827:	74 07                	je     80100830 <cprintf+0x1b0>
80100829:	fa                   	cli    
    for(;;)
8010082a:	eb fe                	jmp    8010082a <cprintf+0x1aa>
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc(c);
80100830:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100833:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100836:	6a 25                	push   $0x25
80100838:	e8 c3 57 00 00       	call   80106000 <uartputc>
  cgaputc(c);
8010083d:	b8 25 00 00 00       	mov    $0x25,%eax
80100842:	e8 b9 fb ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100847:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
}
8010084b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010084e:	85 c0                	test   %eax,%eax
80100850:	0f 85 5a fe ff ff    	jne    801006b0 <cprintf+0x30>
80100856:	e9 ab fe ff ff       	jmp    80100706 <cprintf+0x86>
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop
80100860:	fa                   	cli    
    for(;;)
80100861:	eb fe                	jmp    80100861 <cprintf+0x1e1>
80100863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100867:	90                   	nop
      for(; *s; s++)
80100868:	0f b6 07             	movzbl (%edi),%eax
8010086b:	84 c0                	test   %al,%al
8010086d:	74 6c                	je     801008db <cprintf+0x25b>
8010086f:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80100872:	89 fb                	mov    %edi,%ebx
80100874:	e9 cb fe ff ff       	jmp    80100744 <cprintf+0xc4>
    uartputc(c);
80100879:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
8010087c:	0f be f8             	movsbl %al,%edi
      for(; *s; s++)
8010087f:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100882:	57                   	push   %edi
80100883:	e8 78 57 00 00       	call   80106000 <uartputc>
  cgaputc(c);
80100888:	89 f8                	mov    %edi,%eax
8010088a:	e8 71 fb ff ff       	call   80100400 <cgaputc>
      for(; *s; s++)
8010088f:	0f b6 03             	movzbl (%ebx),%eax
80100892:	83 c4 10             	add    $0x10,%esp
80100895:	84 c0                	test   %al,%al
80100897:	0f 85 a7 fe ff ff    	jne    80100744 <cprintf+0xc4>
      if((s = (char*)*argp++) == 0)
8010089d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801008a0:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008a3:	e9 53 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    uartputc(c);
801008a8:	83 ec 0c             	sub    $0xc,%esp
801008ab:	89 55 e0             	mov    %edx,-0x20(%ebp)
801008ae:	52                   	push   %edx
801008af:	e8 4c 57 00 00       	call   80106000 <uartputc>
  cgaputc(c);
801008b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801008b7:	89 d0                	mov    %edx,%eax
801008b9:	e8 42 fb ff ff       	call   80100400 <cgaputc>
}
801008be:	83 c4 10             	add    $0x10,%esp
801008c1:	e9 35 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    release(&cons.lock);
801008c6:	83 ec 0c             	sub    $0xc,%esp
801008c9:	68 20 ff 10 80       	push   $0x8010ff20
801008ce:	e8 ed 3f 00 00       	call   801048c0 <release>
801008d3:	83 c4 10             	add    $0x10,%esp
}
801008d6:	e9 36 fe ff ff       	jmp    80100711 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008db:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008de:	e9 18 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    panic("null fmt");
801008e3:	83 ec 0c             	sub    $0xc,%esp
801008e6:	68 5f 77 10 80       	push   $0x8010775f
801008eb:	e8 90 fa ff ff       	call   80100380 <panic>

801008f0 <consoleintr>:
{
801008f0:	55                   	push   %ebp
801008f1:	89 e5                	mov    %esp,%ebp
801008f3:	57                   	push   %edi
801008f4:	56                   	push   %esi
801008f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801008f6:	31 db                	xor    %ebx,%ebx
{
801008f8:	83 ec 28             	sub    $0x28,%esp
801008fb:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008fe:	68 20 ff 10 80       	push   $0x8010ff20
80100903:	e8 98 3e 00 00       	call   801047a0 <acquire>
  while((c = getc()) >= 0){
80100908:	83 c4 10             	add    $0x10,%esp
8010090b:	eb 1a                	jmp    80100927 <consoleintr+0x37>
8010090d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100910:	83 f8 08             	cmp    $0x8,%eax
80100913:	0f 84 17 01 00 00    	je     80100a30 <consoleintr+0x140>
80100919:	83 f8 10             	cmp    $0x10,%eax
8010091c:	0f 85 9a 01 00 00    	jne    80100abc <consoleintr+0x1cc>
80100922:	bb 01 00 00 00       	mov    $0x1,%ebx
  while((c = getc()) >= 0){
80100927:	ff d6                	call   *%esi
80100929:	85 c0                	test   %eax,%eax
8010092b:	0f 88 6f 01 00 00    	js     80100aa0 <consoleintr+0x1b0>
    switch(c){
80100931:	83 f8 15             	cmp    $0x15,%eax
80100934:	0f 84 b6 00 00 00    	je     801009f0 <consoleintr+0x100>
8010093a:	7e d4                	jle    80100910 <consoleintr+0x20>
8010093c:	83 f8 7f             	cmp    $0x7f,%eax
8010093f:	0f 84 eb 00 00 00    	je     80100a30 <consoleintr+0x140>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100945:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
8010094b:	89 d1                	mov    %edx,%ecx
8010094d:	2b 0d 00 ff 10 80    	sub    0x8010ff00,%ecx
80100953:	83 f9 7f             	cmp    $0x7f,%ecx
80100956:	77 cf                	ja     80100927 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
80100958:	89 d1                	mov    %edx,%ecx
8010095a:	83 c2 01             	add    $0x1,%edx
  if(panicked){
8010095d:	8b 3d 58 ff 10 80    	mov    0x8010ff58,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100963:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100969:	83 e1 7f             	and    $0x7f,%ecx
        c = (c == '\r') ? '\n' : c;
8010096c:	83 f8 0d             	cmp    $0xd,%eax
8010096f:	0f 84 9b 01 00 00    	je     80100b10 <consoleintr+0x220>
        input.buf[input.e++ % INPUT_BUF] = c;
80100975:	88 81 80 fe 10 80    	mov    %al,-0x7fef0180(%ecx)
  if(panicked){
8010097b:	85 ff                	test   %edi,%edi
8010097d:	0f 85 98 01 00 00    	jne    80100b1b <consoleintr+0x22b>
  if(c == BACKSPACE){
80100983:	3d 00 01 00 00       	cmp    $0x100,%eax
80100988:	0f 85 b3 01 00 00    	jne    80100b41 <consoleintr+0x251>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010098e:	83 ec 0c             	sub    $0xc,%esp
80100991:	6a 08                	push   $0x8
80100993:	e8 68 56 00 00       	call   80106000 <uartputc>
80100998:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010099f:	e8 5c 56 00 00       	call   80106000 <uartputc>
801009a4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801009ab:	e8 50 56 00 00       	call   80106000 <uartputc>
  cgaputc(c);
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 46 fa ff ff       	call   80100400 <cgaputc>
801009ba:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009bd:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801009c2:	83 e8 80             	sub    $0xffffff80,%eax
801009c5:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
801009cb:	0f 85 56 ff ff ff    	jne    80100927 <consoleintr+0x37>
          wakeup(&input.r);
801009d1:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801009d4:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
801009d9:	68 00 ff 10 80       	push   $0x8010ff00
801009de:	e8 fd 39 00 00       	call   801043e0 <wakeup>
801009e3:	83 c4 10             	add    $0x10,%esp
801009e6:	e9 3c ff ff ff       	jmp    80100927 <consoleintr+0x37>
801009eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009ef:	90                   	nop
      while(input.e != input.w &&
801009f0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009f5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009fb:	0f 84 26 ff ff ff    	je     80100927 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a01:	83 e8 01             	sub    $0x1,%eax
80100a04:	89 c2                	mov    %eax,%edx
80100a06:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a09:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100a10:	0f 84 11 ff ff ff    	je     80100927 <consoleintr+0x37>
  if(panicked){
80100a16:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
80100a1c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100a21:	85 d2                	test   %edx,%edx
80100a23:	74 33                	je     80100a58 <consoleintr+0x168>
80100a25:	fa                   	cli    
    for(;;)
80100a26:	eb fe                	jmp    80100a26 <consoleintr+0x136>
80100a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2f:	90                   	nop
      if(input.e != input.w){
80100a30:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a35:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100a3b:	0f 84 e6 fe ff ff    	je     80100927 <consoleintr+0x37>
        input.e--;
80100a41:	83 e8 01             	sub    $0x1,%eax
80100a44:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100a49:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	74 7e                	je     80100ad0 <consoleintr+0x1e0>
80100a52:	fa                   	cli    
    for(;;)
80100a53:	eb fe                	jmp    80100a53 <consoleintr+0x163>
80100a55:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100a58:	83 ec 0c             	sub    $0xc,%esp
80100a5b:	6a 08                	push   $0x8
80100a5d:	e8 9e 55 00 00       	call   80106000 <uartputc>
80100a62:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100a69:	e8 92 55 00 00       	call   80106000 <uartputc>
80100a6e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100a75:	e8 86 55 00 00       	call   80106000 <uartputc>
  cgaputc(c);
80100a7a:	b8 00 01 00 00       	mov    $0x100,%eax
80100a7f:	e8 7c f9 ff ff       	call   80100400 <cgaputc>
      while(input.e != input.w &&
80100a84:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a89:	83 c4 10             	add    $0x10,%esp
80100a8c:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100a92:	0f 85 69 ff ff ff    	jne    80100a01 <consoleintr+0x111>
80100a98:	e9 8a fe ff ff       	jmp    80100927 <consoleintr+0x37>
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	68 20 ff 10 80       	push   $0x8010ff20
80100aa8:	e8 13 3e 00 00       	call   801048c0 <release>
  if(doprocdump) {
80100aad:	83 c4 10             	add    $0x10,%esp
80100ab0:	85 db                	test   %ebx,%ebx
80100ab2:	75 50                	jne    80100b04 <consoleintr+0x214>
}
80100ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ab7:	5b                   	pop    %ebx
80100ab8:	5e                   	pop    %esi
80100ab9:	5f                   	pop    %edi
80100aba:	5d                   	pop    %ebp
80100abb:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100abc:	85 c0                	test   %eax,%eax
80100abe:	0f 84 63 fe ff ff    	je     80100927 <consoleintr+0x37>
80100ac4:	e9 7c fe ff ff       	jmp    80100945 <consoleintr+0x55>
80100ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100ad0:	83 ec 0c             	sub    $0xc,%esp
80100ad3:	6a 08                	push   $0x8
80100ad5:	e8 26 55 00 00       	call   80106000 <uartputc>
80100ada:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100ae1:	e8 1a 55 00 00       	call   80106000 <uartputc>
80100ae6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100aed:	e8 0e 55 00 00       	call   80106000 <uartputc>
  cgaputc(c);
80100af2:	b8 00 01 00 00       	mov    $0x100,%eax
80100af7:	e8 04 f9 ff ff       	call   80100400 <cgaputc>
}
80100afc:	83 c4 10             	add    $0x10,%esp
80100aff:	e9 23 fe ff ff       	jmp    80100927 <consoleintr+0x37>
}
80100b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b07:	5b                   	pop    %ebx
80100b08:	5e                   	pop    %esi
80100b09:	5f                   	pop    %edi
80100b0a:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100b0b:	e9 b0 39 00 00       	jmp    801044c0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b10:	c6 81 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%ecx)
  if(panicked){
80100b17:	85 ff                	test   %edi,%edi
80100b19:	74 05                	je     80100b20 <consoleintr+0x230>
80100b1b:	fa                   	cli    
    for(;;)
80100b1c:	eb fe                	jmp    80100b1c <consoleintr+0x22c>
80100b1e:	66 90                	xchg   %ax,%ax
    uartputc(c);
80100b20:	83 ec 0c             	sub    $0xc,%esp
80100b23:	6a 0a                	push   $0xa
80100b25:	e8 d6 54 00 00       	call   80106000 <uartputc>
  cgaputc(c);
80100b2a:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b2f:	e8 cc f8 ff ff       	call   80100400 <cgaputc>
          input.w = input.e;
80100b34:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100b39:	83 c4 10             	add    $0x10,%esp
80100b3c:	e9 90 fe ff ff       	jmp    801009d1 <consoleintr+0xe1>
    uartputc(c);
80100b41:	83 ec 0c             	sub    $0xc,%esp
80100b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100b47:	50                   	push   %eax
80100b48:	e8 b3 54 00 00       	call   80106000 <uartputc>
  cgaputc(c);
80100b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b50:	e8 ab f8 ff ff       	call   80100400 <cgaputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b58:	83 c4 10             	add    $0x10,%esp
80100b5b:	83 f8 0a             	cmp    $0xa,%eax
80100b5e:	74 09                	je     80100b69 <consoleintr+0x279>
80100b60:	83 f8 04             	cmp    $0x4,%eax
80100b63:	0f 85 54 fe ff ff    	jne    801009bd <consoleintr+0xcd>
          input.w = input.e;
80100b69:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100b6e:	e9 5e fe ff ff       	jmp    801009d1 <consoleintr+0xe1>
80100b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b80 <consoleinit>:

void
consoleinit(void)
{
80100b80:	55                   	push   %ebp
80100b81:	89 e5                	mov    %esp,%ebp
80100b83:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b86:	68 68 77 10 80       	push   $0x80107768
80100b8b:	68 20 ff 10 80       	push   $0x8010ff20
80100b90:	e8 fb 3a 00 00       	call   80104690 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100b95:	58                   	pop    %eax
80100b96:	5a                   	pop    %edx
80100b97:	6a 00                	push   $0x0
80100b99:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100b9b:	c7 05 0c 09 11 80 40 	movl   $0x80100540,0x8011090c
80100ba2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ba5:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100bac:	02 10 80 
  cons.locking = 1;
80100baf:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100bb6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100bb9:	e8 f2 19 00 00       	call   801025b0 <ioapicenable>
}
80100bbe:	83 c4 10             	add    $0x10,%esp
80100bc1:	c9                   	leave  
80100bc2:	c3                   	ret    
80100bc3:	66 90                	xchg   %ax,%ax
80100bc5:	66 90                	xchg   %ax,%ax
80100bc7:	66 90                	xchg   %ax,%ax
80100bc9:	66 90                	xchg   %ax,%ax
80100bcb:	66 90                	xchg   %ax,%ax
80100bcd:	66 90                	xchg   %ax,%ax
80100bcf:	90                   	nop

80100bd0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bd0:	55                   	push   %ebp
80100bd1:	89 e5                	mov    %esp,%ebp
80100bd3:	57                   	push   %edi
80100bd4:	56                   	push   %esi
80100bd5:	53                   	push   %ebx
80100bd6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bdc:	e8 3f 30 00 00       	call   80103c20 <myproc>
80100be1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100be7:	e8 14 24 00 00       	call   80103000 <begin_op>

  if((ip = namei(path)) == 0){
80100bec:	83 ec 0c             	sub    $0xc,%esp
80100bef:	ff 75 08             	pushl  0x8(%ebp)
80100bf2:	e8 d9 15 00 00       	call   801021d0 <namei>
80100bf7:	83 c4 10             	add    $0x10,%esp
80100bfa:	85 c0                	test   %eax,%eax
80100bfc:	0f 84 02 03 00 00    	je     80100f04 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c02:	83 ec 0c             	sub    $0xc,%esp
80100c05:	89 c3                	mov    %eax,%ebx
80100c07:	50                   	push   %eax
80100c08:	e8 a3 0c 00 00       	call   801018b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c0d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c13:	6a 34                	push   $0x34
80100c15:	6a 00                	push   $0x0
80100c17:	50                   	push   %eax
80100c18:	53                   	push   %ebx
80100c19:	e8 a2 0f 00 00       	call   80101bc0 <readi>
80100c1e:	83 c4 20             	add    $0x20,%esp
80100c21:	83 f8 34             	cmp    $0x34,%eax
80100c24:	74 22                	je     80100c48 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c26:	83 ec 0c             	sub    $0xc,%esp
80100c29:	53                   	push   %ebx
80100c2a:	e8 11 0f 00 00       	call   80101b40 <iunlockput>
    end_op();
80100c2f:	e8 3c 24 00 00       	call   80103070 <end_op>
80100c34:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c3f:	5b                   	pop    %ebx
80100c40:	5e                   	pop    %esi
80100c41:	5f                   	pop    %edi
80100c42:	5d                   	pop    %ebp
80100c43:	c3                   	ret    
80100c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100c48:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c4f:	45 4c 46 
80100c52:	75 d2                	jne    80100c26 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100c54:	e8 37 65 00 00       	call   80107190 <setupkvm>
80100c59:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100c5f:	85 c0                	test   %eax,%eax
80100c61:	74 c3                	je     80100c26 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c63:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c6a:	00 
80100c6b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100c71:	0f 84 ac 02 00 00    	je     80100f23 <exec+0x353>
  sz = 0;
80100c77:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100c7e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c81:	31 ff                	xor    %edi,%edi
80100c83:	e9 8e 00 00 00       	jmp    80100d16 <exec+0x146>
80100c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c8f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100c90:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c97:	75 6c                	jne    80100d05 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100c99:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c9f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ca5:	0f 82 87 00 00 00    	jb     80100d32 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cab:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100cb1:	72 7f                	jb     80100d32 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cb3:	83 ec 04             	sub    $0x4,%esp
80100cb6:	50                   	push   %eax
80100cb7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cbd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cc3:	e8 e8 62 00 00       	call   80106fb0 <allocuvm>
80100cc8:	83 c4 10             	add    $0x10,%esp
80100ccb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100cd1:	85 c0                	test   %eax,%eax
80100cd3:	74 5d                	je     80100d32 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100cd5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100cdb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ce0:	75 50                	jne    80100d32 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ce2:	83 ec 0c             	sub    $0xc,%esp
80100ce5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100ceb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100cf1:	53                   	push   %ebx
80100cf2:	50                   	push   %eax
80100cf3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cf9:	e8 c2 61 00 00       	call   80106ec0 <loaduvm>
80100cfe:	83 c4 20             	add    $0x20,%esp
80100d01:	85 c0                	test   %eax,%eax
80100d03:	78 2d                	js     80100d32 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d05:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100d0c:	83 c7 01             	add    $0x1,%edi
80100d0f:	83 c6 20             	add    $0x20,%esi
80100d12:	39 f8                	cmp    %edi,%eax
80100d14:	7e 3a                	jle    80100d50 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d16:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d1c:	6a 20                	push   $0x20
80100d1e:	56                   	push   %esi
80100d1f:	50                   	push   %eax
80100d20:	53                   	push   %ebx
80100d21:	e8 9a 0e 00 00       	call   80101bc0 <readi>
80100d26:	83 c4 10             	add    $0x10,%esp
80100d29:	83 f8 20             	cmp    $0x20,%eax
80100d2c:	0f 84 5e ff ff ff    	je     80100c90 <exec+0xc0>
    freevm(pgdir);
80100d32:	83 ec 0c             	sub    $0xc,%esp
80100d35:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d3b:	e8 d0 63 00 00       	call   80107110 <freevm>
  if(ip){
80100d40:	83 c4 10             	add    $0x10,%esp
80100d43:	e9 de fe ff ff       	jmp    80100c26 <exec+0x56>
80100d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d4f:	90                   	nop
  sz = PGROUNDUP(sz);
80100d50:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d56:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100d5c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d62:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100d68:	83 ec 0c             	sub    $0xc,%esp
80100d6b:	53                   	push   %ebx
80100d6c:	e8 cf 0d 00 00       	call   80101b40 <iunlockput>
  end_op();
80100d71:	e8 fa 22 00 00       	call   80103070 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d76:	83 c4 0c             	add    $0xc,%esp
80100d79:	56                   	push   %esi
80100d7a:	57                   	push   %edi
80100d7b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d81:	57                   	push   %edi
80100d82:	e8 29 62 00 00       	call   80106fb0 <allocuvm>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	89 c6                	mov    %eax,%esi
80100d8c:	85 c0                	test   %eax,%eax
80100d8e:	0f 84 94 00 00 00    	je     80100e28 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d94:	83 ec 08             	sub    $0x8,%esp
80100d97:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100d9d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d9f:	50                   	push   %eax
80100da0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100da1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100da3:	e8 88 64 00 00       	call   80107230 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100da8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dab:	83 c4 10             	add    $0x10,%esp
80100dae:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100db4:	8b 00                	mov    (%eax),%eax
80100db6:	85 c0                	test   %eax,%eax
80100db8:	0f 84 8b 00 00 00    	je     80100e49 <exec+0x279>
80100dbe:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100dc4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100dca:	eb 23                	jmp    80100def <exec+0x21f>
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100dd3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100dda:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100ddd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100de3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100de6:	85 c0                	test   %eax,%eax
80100de8:	74 59                	je     80100e43 <exec+0x273>
    if(argc >= MAXARG)
80100dea:	83 ff 20             	cmp    $0x20,%edi
80100ded:	74 39                	je     80100e28 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100def:	83 ec 0c             	sub    $0xc,%esp
80100df2:	50                   	push   %eax
80100df3:	e8 18 3d 00 00       	call   80104b10 <strlen>
80100df8:	f7 d0                	not    %eax
80100dfa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dfc:	58                   	pop    %eax
80100dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e00:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e03:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e06:	e8 05 3d 00 00       	call   80104b10 <strlen>
80100e0b:	83 c0 01             	add    $0x1,%eax
80100e0e:	50                   	push   %eax
80100e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e12:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e15:	53                   	push   %ebx
80100e16:	56                   	push   %esi
80100e17:	e8 54 66 00 00       	call   80107470 <copyout>
80100e1c:	83 c4 20             	add    $0x20,%esp
80100e1f:	85 c0                	test   %eax,%eax
80100e21:	79 ad                	jns    80100dd0 <exec+0x200>
80100e23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e27:	90                   	nop
    freevm(pgdir);
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e31:	e8 da 62 00 00       	call   80107110 <freevm>
80100e36:	83 c4 10             	add    $0x10,%esp
  return -1;
80100e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e3e:	e9 f9 fd ff ff       	jmp    80100c3c <exec+0x6c>
80100e43:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e49:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100e50:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100e52:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100e59:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e5d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100e5f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100e62:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100e68:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e6a:	50                   	push   %eax
80100e6b:	52                   	push   %edx
80100e6c:	53                   	push   %ebx
80100e6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100e73:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e7a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e7d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e83:	e8 e8 65 00 00       	call   80107470 <copyout>
80100e88:	83 c4 10             	add    $0x10,%esp
80100e8b:	85 c0                	test   %eax,%eax
80100e8d:	78 99                	js     80100e28 <exec+0x258>
  for(last=s=path; *s; s++)
80100e8f:	8b 45 08             	mov    0x8(%ebp),%eax
80100e92:	8b 55 08             	mov    0x8(%ebp),%edx
80100e95:	0f b6 00             	movzbl (%eax),%eax
80100e98:	84 c0                	test   %al,%al
80100e9a:	74 13                	je     80100eaf <exec+0x2df>
80100e9c:	89 d1                	mov    %edx,%ecx
80100e9e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100ea0:	83 c1 01             	add    $0x1,%ecx
80100ea3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100ea5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100ea8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100eab:	84 c0                	test   %al,%al
80100ead:	75 f1                	jne    80100ea0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100eaf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100eb5:	83 ec 04             	sub    $0x4,%esp
80100eb8:	6a 10                	push   $0x10
80100eba:	89 f8                	mov    %edi,%eax
80100ebc:	52                   	push   %edx
80100ebd:	83 c0 6c             	add    $0x6c,%eax
80100ec0:	50                   	push   %eax
80100ec1:	e8 0a 3c 00 00       	call   80104ad0 <safestrcpy>
  curproc->pgdir = pgdir;
80100ec6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100ecc:	89 f8                	mov    %edi,%eax
80100ece:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100ed1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100ed3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100ed6:	89 c1                	mov    %eax,%ecx
80100ed8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100ede:	8b 40 18             	mov    0x18(%eax),%eax
80100ee1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ee4:	8b 41 18             	mov    0x18(%ecx),%eax
80100ee7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100eea:	89 0c 24             	mov    %ecx,(%esp)
80100eed:	e8 3e 5e 00 00       	call   80106d30 <switchuvm>
  freevm(oldpgdir);
80100ef2:	89 3c 24             	mov    %edi,(%esp)
80100ef5:	e8 16 62 00 00       	call   80107110 <freevm>
  return 0;
80100efa:	83 c4 10             	add    $0x10,%esp
80100efd:	31 c0                	xor    %eax,%eax
80100eff:	e9 38 fd ff ff       	jmp    80100c3c <exec+0x6c>
    end_op();
80100f04:	e8 67 21 00 00       	call   80103070 <end_op>
    cprintf("exec: fail\n");
80100f09:	83 ec 0c             	sub    $0xc,%esp
80100f0c:	68 81 77 10 80       	push   $0x80107781
80100f11:	e8 6a f7 ff ff       	call   80100680 <cprintf>
    return -1;
80100f16:	83 c4 10             	add    $0x10,%esp
80100f19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f1e:	e9 19 fd ff ff       	jmp    80100c3c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f23:	31 ff                	xor    %edi,%edi
80100f25:	be 00 20 00 00       	mov    $0x2000,%esi
80100f2a:	e9 39 fe ff ff       	jmp    80100d68 <exec+0x198>
80100f2f:	90                   	nop

80100f30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f36:	68 8d 77 10 80       	push   $0x8010778d
80100f3b:	68 60 ff 10 80       	push   $0x8010ff60
80100f40:	e8 4b 37 00 00       	call   80104690 <initlock>
}
80100f45:	83 c4 10             	add    $0x10,%esp
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f54:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100f59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f5c:	68 60 ff 10 80       	push   $0x8010ff60
80100f61:	e8 3a 38 00 00       	call   801047a0 <acquire>
80100f66:	83 c4 10             	add    $0x10,%esp
80100f69:	eb 10                	jmp    80100f7b <filealloc+0x2b>
80100f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f6f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f70:	83 c3 18             	add    $0x18,%ebx
80100f73:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100f79:	74 25                	je     80100fa0 <filealloc+0x50>
    if(f->ref == 0){
80100f7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f7e:	85 c0                	test   %eax,%eax
80100f80:	75 ee                	jne    80100f70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f8c:	68 60 ff 10 80       	push   $0x8010ff60
80100f91:	e8 2a 39 00 00       	call   801048c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f96:	89 d8                	mov    %ebx,%eax
      return f;
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f9e:	c9                   	leave  
80100f9f:	c3                   	ret    
  release(&ftable.lock);
80100fa0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100fa3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100fa5:	68 60 ff 10 80       	push   $0x8010ff60
80100faa:	e8 11 39 00 00       	call   801048c0 <release>
}
80100faf:	89 d8                	mov    %ebx,%eax
  return 0;
80100fb1:	83 c4 10             	add    $0x10,%esp
}
80100fb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fb7:	c9                   	leave  
80100fb8:	c3                   	ret    
80100fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	53                   	push   %ebx
80100fc4:	83 ec 10             	sub    $0x10,%esp
80100fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fca:	68 60 ff 10 80       	push   $0x8010ff60
80100fcf:	e8 cc 37 00 00       	call   801047a0 <acquire>
  if(f->ref < 1)
80100fd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	85 c0                	test   %eax,%eax
80100fdc:	7e 1a                	jle    80100ff8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100fde:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100fe1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100fe4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fe7:	68 60 ff 10 80       	push   $0x8010ff60
80100fec:	e8 cf 38 00 00       	call   801048c0 <release>
  return f;
}
80100ff1:	89 d8                	mov    %ebx,%eax
80100ff3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff6:	c9                   	leave  
80100ff7:	c3                   	ret    
    panic("filedup");
80100ff8:	83 ec 0c             	sub    $0xc,%esp
80100ffb:	68 94 77 10 80       	push   $0x80107794
80101000:	e8 7b f3 ff ff       	call   80100380 <panic>
80101005:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101010 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 28             	sub    $0x28,%esp
80101019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010101c:	68 60 ff 10 80       	push   $0x8010ff60
80101021:	e8 7a 37 00 00       	call   801047a0 <acquire>
  if(f->ref < 1)
80101026:	8b 53 04             	mov    0x4(%ebx),%edx
80101029:	83 c4 10             	add    $0x10,%esp
8010102c:	85 d2                	test   %edx,%edx
8010102e:	0f 8e a5 00 00 00    	jle    801010d9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101034:	83 ea 01             	sub    $0x1,%edx
80101037:	89 53 04             	mov    %edx,0x4(%ebx)
8010103a:	75 44                	jne    80101080 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010103c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101040:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101043:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101045:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010104b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010104e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101051:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101054:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80101059:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010105c:	e8 5f 38 00 00       	call   801048c0 <release>

  if(ff.type == FD_PIPE)
80101061:	83 c4 10             	add    $0x10,%esp
80101064:	83 ff 01             	cmp    $0x1,%edi
80101067:	74 57                	je     801010c0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101069:	83 ff 02             	cmp    $0x2,%edi
8010106c:	74 2a                	je     80101098 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
80101075:	c3                   	ret    
80101076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010107d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101080:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80101087:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010108a:	5b                   	pop    %ebx
8010108b:	5e                   	pop    %esi
8010108c:	5f                   	pop    %edi
8010108d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010108e:	e9 2d 38 00 00       	jmp    801048c0 <release>
80101093:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101097:	90                   	nop
    begin_op();
80101098:	e8 63 1f 00 00       	call   80103000 <begin_op>
    iput(ff.ip);
8010109d:	83 ec 0c             	sub    $0xc,%esp
801010a0:	ff 75 e0             	pushl  -0x20(%ebp)
801010a3:	e8 38 09 00 00       	call   801019e0 <iput>
    end_op();
801010a8:	83 c4 10             	add    $0x10,%esp
}
801010ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010ae:	5b                   	pop    %ebx
801010af:	5e                   	pop    %esi
801010b0:	5f                   	pop    %edi
801010b1:	5d                   	pop    %ebp
    end_op();
801010b2:	e9 b9 1f 00 00       	jmp    80103070 <end_op>
801010b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010be:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801010c0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010c4:	83 ec 08             	sub    $0x8,%esp
801010c7:	53                   	push   %ebx
801010c8:	56                   	push   %esi
801010c9:	e8 02 27 00 00       	call   801037d0 <pipeclose>
801010ce:	83 c4 10             	add    $0x10,%esp
}
801010d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d4:	5b                   	pop    %ebx
801010d5:	5e                   	pop    %esi
801010d6:	5f                   	pop    %edi
801010d7:	5d                   	pop    %ebp
801010d8:	c3                   	ret    
    panic("fileclose");
801010d9:	83 ec 0c             	sub    $0xc,%esp
801010dc:	68 9c 77 10 80       	push   $0x8010779c
801010e1:	e8 9a f2 ff ff       	call   80100380 <panic>
801010e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ed:	8d 76 00             	lea    0x0(%esi),%esi

801010f0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	53                   	push   %ebx
801010f4:	83 ec 04             	sub    $0x4,%esp
801010f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801010fa:	83 3b 02             	cmpl   $0x2,(%ebx)
801010fd:	75 31                	jne    80101130 <filestat+0x40>
    ilock(f->ip);
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	ff 73 10             	pushl  0x10(%ebx)
80101105:	e8 a6 07 00 00       	call   801018b0 <ilock>
    stati(f->ip, st);
8010110a:	58                   	pop    %eax
8010110b:	5a                   	pop    %edx
8010110c:	ff 75 0c             	pushl  0xc(%ebp)
8010110f:	ff 73 10             	pushl  0x10(%ebx)
80101112:	e8 79 0a 00 00       	call   80101b90 <stati>
    iunlock(f->ip);
80101117:	59                   	pop    %ecx
80101118:	ff 73 10             	pushl  0x10(%ebx)
8010111b:	e8 70 08 00 00       	call   80101990 <iunlock>
    return 0;
  }
  return -1;
}
80101120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101123:	83 c4 10             	add    $0x10,%esp
80101126:	31 c0                	xor    %eax,%eax
}
80101128:	c9                   	leave  
80101129:	c3                   	ret    
8010112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101133:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101138:	c9                   	leave  
80101139:	c3                   	ret    
8010113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101140 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 0c             	sub    $0xc,%esp
80101149:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010114c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010114f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101152:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101156:	74 60                	je     801011b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101158:	8b 03                	mov    (%ebx),%eax
8010115a:	83 f8 01             	cmp    $0x1,%eax
8010115d:	74 41                	je     801011a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010115f:	83 f8 02             	cmp    $0x2,%eax
80101162:	75 5b                	jne    801011bf <fileread+0x7f>
    ilock(f->ip);
80101164:	83 ec 0c             	sub    $0xc,%esp
80101167:	ff 73 10             	pushl  0x10(%ebx)
8010116a:	e8 41 07 00 00       	call   801018b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010116f:	57                   	push   %edi
80101170:	ff 73 14             	pushl  0x14(%ebx)
80101173:	56                   	push   %esi
80101174:	ff 73 10             	pushl  0x10(%ebx)
80101177:	e8 44 0a 00 00       	call   80101bc0 <readi>
8010117c:	83 c4 20             	add    $0x20,%esp
8010117f:	89 c6                	mov    %eax,%esi
80101181:	85 c0                	test   %eax,%eax
80101183:	7e 03                	jle    80101188 <fileread+0x48>
      f->off += r;
80101185:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101188:	83 ec 0c             	sub    $0xc,%esp
8010118b:	ff 73 10             	pushl  0x10(%ebx)
8010118e:	e8 fd 07 00 00       	call   80101990 <iunlock>
    return r;
80101193:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101199:	89 f0                	mov    %esi,%eax
8010119b:	5b                   	pop    %ebx
8010119c:	5e                   	pop    %esi
8010119d:	5f                   	pop    %edi
8010119e:	5d                   	pop    %ebp
8010119f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801011a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801011a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a9:	5b                   	pop    %ebx
801011aa:	5e                   	pop    %esi
801011ab:	5f                   	pop    %edi
801011ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801011ad:	e9 be 27 00 00       	jmp    80103970 <piperead>
801011b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011bd:	eb d7                	jmp    80101196 <fileread+0x56>
  panic("fileread");
801011bf:	83 ec 0c             	sub    $0xc,%esp
801011c2:	68 a6 77 10 80       	push   $0x801077a6
801011c7:	e8 b4 f1 ff ff       	call   80100380 <panic>
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011d0:	55                   	push   %ebp
801011d1:	89 e5                	mov    %esp,%ebp
801011d3:	57                   	push   %edi
801011d4:	56                   	push   %esi
801011d5:	53                   	push   %ebx
801011d6:	83 ec 1c             	sub    $0x1c,%esp
801011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801011dc:	8b 75 08             	mov    0x8(%ebp),%esi
801011df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801011e5:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801011e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011ec:	0f 84 bd 00 00 00    	je     801012af <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801011f2:	8b 06                	mov    (%esi),%eax
801011f4:	83 f8 01             	cmp    $0x1,%eax
801011f7:	0f 84 bf 00 00 00    	je     801012bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011fd:	83 f8 02             	cmp    $0x2,%eax
80101200:	0f 85 c8 00 00 00    	jne    801012ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101209:	31 ff                	xor    %edi,%edi
    while(i < n){
8010120b:	85 c0                	test   %eax,%eax
8010120d:	7f 30                	jg     8010123f <filewrite+0x6f>
8010120f:	e9 94 00 00 00       	jmp    801012a8 <filewrite+0xd8>
80101214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101218:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010121b:	83 ec 0c             	sub    $0xc,%esp
8010121e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101221:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101224:	e8 67 07 00 00       	call   80101990 <iunlock>
      end_op();
80101229:	e8 42 1e 00 00       	call   80103070 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010122e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101231:	83 c4 10             	add    $0x10,%esp
80101234:	39 c3                	cmp    %eax,%ebx
80101236:	75 60                	jne    80101298 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
80101238:	01 df                	add    %ebx,%edi
    while(i < n){
8010123a:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010123d:	7e 69                	jle    801012a8 <filewrite+0xd8>
      int n1 = n - i;
8010123f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101242:	b8 00 06 00 00       	mov    $0x600,%eax
80101247:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101249:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
8010124f:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101252:	e8 a9 1d 00 00       	call   80103000 <begin_op>
      ilock(f->ip);
80101257:	83 ec 0c             	sub    $0xc,%esp
8010125a:	ff 76 10             	pushl  0x10(%esi)
8010125d:	e8 4e 06 00 00       	call   801018b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101262:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101265:	53                   	push   %ebx
80101266:	ff 76 14             	pushl  0x14(%esi)
80101269:	01 f8                	add    %edi,%eax
8010126b:	50                   	push   %eax
8010126c:	ff 76 10             	pushl  0x10(%esi)
8010126f:	e8 4c 0a 00 00       	call   80101cc0 <writei>
80101274:	83 c4 20             	add    $0x20,%esp
80101277:	85 c0                	test   %eax,%eax
80101279:	7f 9d                	jg     80101218 <filewrite+0x48>
      iunlock(f->ip);
8010127b:	83 ec 0c             	sub    $0xc,%esp
8010127e:	ff 76 10             	pushl  0x10(%esi)
80101281:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101284:	e8 07 07 00 00       	call   80101990 <iunlock>
      end_op();
80101289:	e8 e2 1d 00 00       	call   80103070 <end_op>
      if(r < 0)
8010128e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101291:	83 c4 10             	add    $0x10,%esp
80101294:	85 c0                	test   %eax,%eax
80101296:	75 17                	jne    801012af <filewrite+0xdf>
        panic("short filewrite");
80101298:	83 ec 0c             	sub    $0xc,%esp
8010129b:	68 af 77 10 80       	push   $0x801077af
801012a0:	e8 db f0 ff ff       	call   80100380 <panic>
801012a5:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801012a8:	89 f8                	mov    %edi,%eax
801012aa:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801012ad:	74 05                	je     801012b4 <filewrite+0xe4>
801012af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801012b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b7:	5b                   	pop    %ebx
801012b8:	5e                   	pop    %esi
801012b9:	5f                   	pop    %edi
801012ba:	5d                   	pop    %ebp
801012bb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801012bc:	8b 46 0c             	mov    0xc(%esi),%eax
801012bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c5:	5b                   	pop    %ebx
801012c6:	5e                   	pop    %esi
801012c7:	5f                   	pop    %edi
801012c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012c9:	e9 a2 25 00 00       	jmp    80103870 <pipewrite>
  panic("filewrite");
801012ce:	83 ec 0c             	sub    $0xc,%esp
801012d1:	68 b5 77 10 80       	push   $0x801077b5
801012d6:	e8 a5 f0 ff ff       	call   80100380 <panic>
801012db:	66 90                	xchg   %ax,%ax
801012dd:	66 90                	xchg   %ax,%ax
801012df:	90                   	nop

801012e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801012e9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801012ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012f2:	85 c9                	test   %ecx,%ecx
801012f4:	0f 84 87 00 00 00    	je     80101381 <balloc+0xa1>
801012fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101301:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101304:	83 ec 08             	sub    $0x8,%esp
80101307:	89 f0                	mov    %esi,%eax
80101309:	c1 f8 0c             	sar    $0xc,%eax
8010130c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101312:	50                   	push   %eax
80101313:	ff 75 d8             	pushl  -0x28(%ebp)
80101316:	e8 b5 ed ff ff       	call   801000d0 <bread>
8010131b:	83 c4 10             	add    $0x10,%esp
8010131e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101321:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101326:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101329:	31 c0                	xor    %eax,%eax
8010132b:	eb 2f                	jmp    8010135c <balloc+0x7c>
8010132d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101330:	89 c1                	mov    %eax,%ecx
80101332:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101337:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010133a:	83 e1 07             	and    $0x7,%ecx
8010133d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010133f:	89 c1                	mov    %eax,%ecx
80101341:	c1 f9 03             	sar    $0x3,%ecx
80101344:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101349:	89 fa                	mov    %edi,%edx
8010134b:	85 df                	test   %ebx,%edi
8010134d:	74 41                	je     80101390 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010134f:	83 c0 01             	add    $0x1,%eax
80101352:	83 c6 01             	add    $0x1,%esi
80101355:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010135a:	74 05                	je     80101361 <balloc+0x81>
8010135c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010135f:	77 cf                	ja     80101330 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101361:	83 ec 0c             	sub    $0xc,%esp
80101364:	ff 75 e4             	pushl  -0x1c(%ebp)
80101367:	e8 84 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010136c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101373:	83 c4 10             	add    $0x10,%esp
80101376:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101379:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
8010137f:	77 80                	ja     80101301 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101381:	83 ec 0c             	sub    $0xc,%esp
80101384:	68 bf 77 10 80       	push   $0x801077bf
80101389:	e8 f2 ef ff ff       	call   80100380 <panic>
8010138e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101393:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101396:	09 da                	or     %ebx,%edx
80101398:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010139c:	57                   	push   %edi
8010139d:	e8 3e 1e 00 00       	call   801031e0 <log_write>
        brelse(bp);
801013a2:	89 3c 24             	mov    %edi,(%esp)
801013a5:	e8 46 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801013aa:	58                   	pop    %eax
801013ab:	5a                   	pop    %edx
801013ac:	56                   	push   %esi
801013ad:	ff 75 d8             	pushl  -0x28(%ebp)
801013b0:	e8 1b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801013b5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801013b8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801013ba:	8d 40 5c             	lea    0x5c(%eax),%eax
801013bd:	68 00 02 00 00       	push   $0x200
801013c2:	6a 00                	push   $0x0
801013c4:	50                   	push   %eax
801013c5:	e8 46 35 00 00       	call   80104910 <memset>
  log_write(bp);
801013ca:	89 1c 24             	mov    %ebx,(%esp)
801013cd:	e8 0e 1e 00 00       	call   801031e0 <log_write>
  brelse(bp);
801013d2:	89 1c 24             	mov    %ebx,(%esp)
801013d5:	e8 16 ee ff ff       	call   801001f0 <brelse>
}
801013da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013dd:	89 f0                	mov    %esi,%eax
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5f                   	pop    %edi
801013e2:	5d                   	pop    %ebp
801013e3:	c3                   	ret    
801013e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013ef:	90                   	nop

801013f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	89 c7                	mov    %eax,%edi
801013f6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013f7:	31 f6                	xor    %esi,%esi
{
801013f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013fa:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801013ff:	83 ec 28             	sub    $0x28,%esp
80101402:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101405:	68 60 09 11 80       	push   $0x80110960
8010140a:	e8 91 33 00 00       	call   801047a0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010140f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101412:	83 c4 10             	add    $0x10,%esp
80101415:	eb 1b                	jmp    80101432 <iget+0x42>
80101417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010141e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101420:	39 3b                	cmp    %edi,(%ebx)
80101422:	74 6c                	je     80101490 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101424:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010142a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101430:	73 26                	jae    80101458 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101432:	8b 43 08             	mov    0x8(%ebx),%eax
80101435:	85 c0                	test   %eax,%eax
80101437:	7f e7                	jg     80101420 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101439:	85 f6                	test   %esi,%esi
8010143b:	75 e7                	jne    80101424 <iget+0x34>
8010143d:	89 d9                	mov    %ebx,%ecx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010143f:	81 c3 90 00 00 00    	add    $0x90,%ebx
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101445:	85 c0                	test   %eax,%eax
80101447:	75 6e                	jne    801014b7 <iget+0xc7>
80101449:	89 ce                	mov    %ecx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010144b:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101451:	72 df                	jb     80101432 <iget+0x42>
80101453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101457:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101458:	85 f6                	test   %esi,%esi
8010145a:	74 73                	je     801014cf <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010145c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010145f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101461:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101464:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010146b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101472:	68 60 09 11 80       	push   $0x80110960
80101477:	e8 44 34 00 00       	call   801048c0 <release>

  return ip;
8010147c:	83 c4 10             	add    $0x10,%esp
}
8010147f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101482:	89 f0                	mov    %esi,%eax
80101484:	5b                   	pop    %ebx
80101485:	5e                   	pop    %esi
80101486:	5f                   	pop    %edi
80101487:	5d                   	pop    %ebp
80101488:	c3                   	ret    
80101489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101490:	39 53 04             	cmp    %edx,0x4(%ebx)
80101493:	75 8f                	jne    80101424 <iget+0x34>
      release(&icache.lock);
80101495:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101498:	83 c0 01             	add    $0x1,%eax
      return ip;
8010149b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010149d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
801014a2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801014a5:	e8 16 34 00 00       	call   801048c0 <release>
      return ip;
801014aa:	83 c4 10             	add    $0x10,%esp
}
801014ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b0:	89 f0                	mov    %esi,%eax
801014b2:	5b                   	pop    %ebx
801014b3:	5e                   	pop    %esi
801014b4:	5f                   	pop    %edi
801014b5:	5d                   	pop    %ebp
801014b6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014b7:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801014bd:	73 10                	jae    801014cf <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014bf:	8b 43 08             	mov    0x8(%ebx),%eax
801014c2:	85 c0                	test   %eax,%eax
801014c4:	0f 8f 56 ff ff ff    	jg     80101420 <iget+0x30>
801014ca:	e9 6e ff ff ff       	jmp    8010143d <iget+0x4d>
    panic("iget: no inodes");
801014cf:	83 ec 0c             	sub    $0xc,%esp
801014d2:	68 d5 77 10 80       	push   $0x801077d5
801014d7:	e8 a4 ee ff ff       	call   80100380 <panic>
801014dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	89 c6                	mov    %eax,%esi
801014e7:	53                   	push   %ebx
801014e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014eb:	83 fa 0b             	cmp    $0xb,%edx
801014ee:	0f 86 8c 00 00 00    	jbe    80101580 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014f4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014f7:	83 fb 7f             	cmp    $0x7f,%ebx
801014fa:	0f 87 a2 00 00 00    	ja     801015a2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101500:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
      ip->addrs[bn] = addr = balloc(ip->dev);
80101506:	8b 16                	mov    (%esi),%edx
    if((addr = ip->addrs[NDIRECT]) == 0)
80101508:	85 c0                	test   %eax,%eax
8010150a:	74 5c                	je     80101568 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	50                   	push   %eax
80101510:	52                   	push   %edx
80101511:	e8 ba eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101516:	83 c4 10             	add    $0x10,%esp
80101519:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010151d:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010151f:	8b 3b                	mov    (%ebx),%edi
80101521:	85 ff                	test   %edi,%edi
80101523:	74 1b                	je     80101540 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101525:	83 ec 0c             	sub    $0xc,%esp
80101528:	52                   	push   %edx
80101529:	e8 c2 ec ff ff       	call   801001f0 <brelse>
8010152e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101531:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101534:	89 f8                	mov    %edi,%eax
80101536:	5b                   	pop    %ebx
80101537:	5e                   	pop    %esi
80101538:	5f                   	pop    %edi
80101539:	5d                   	pop    %ebp
8010153a:	c3                   	ret    
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop
80101540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101543:	8b 06                	mov    (%esi),%eax
80101545:	e8 96 fd ff ff       	call   801012e0 <balloc>
      log_write(bp);
8010154a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010154d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101550:	89 03                	mov    %eax,(%ebx)
80101552:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101554:	52                   	push   %edx
80101555:	e8 86 1c 00 00       	call   801031e0 <log_write>
8010155a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010155d:	83 c4 10             	add    $0x10,%esp
80101560:	eb c3                	jmp    80101525 <bmap+0x45>
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101568:	89 d0                	mov    %edx,%eax
8010156a:	e8 71 fd ff ff       	call   801012e0 <balloc>
    bp = bread(ip->dev, addr);
8010156f:	8b 16                	mov    (%esi),%edx
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101571:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101577:	eb 93                	jmp    8010150c <bmap+0x2c>
80101579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101580:	8d 5a 14             	lea    0x14(%edx),%ebx
80101583:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101587:	85 ff                	test   %edi,%edi
80101589:	75 a6                	jne    80101531 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010158b:	8b 00                	mov    (%eax),%eax
8010158d:	e8 4e fd ff ff       	call   801012e0 <balloc>
80101592:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101596:	89 c7                	mov    %eax,%edi
}
80101598:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010159b:	5b                   	pop    %ebx
8010159c:	89 f8                	mov    %edi,%eax
8010159e:	5e                   	pop    %esi
8010159f:	5f                   	pop    %edi
801015a0:	5d                   	pop    %ebp
801015a1:	c3                   	ret    
  panic("bmap: out of range");
801015a2:	83 ec 0c             	sub    $0xc,%esp
801015a5:	68 e5 77 10 80       	push   $0x801077e5
801015aa:	e8 d1 ed ff ff       	call   80100380 <panic>
801015af:	90                   	nop

801015b0 <bfree>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	89 c6                	mov    %eax,%esi
801015b7:	53                   	push   %ebx
801015b8:	89 d3                	mov    %edx,%ebx
801015ba:	83 ec 14             	sub    $0x14,%esp
  bp = bread(dev, 1);
801015bd:	6a 01                	push   $0x1
801015bf:	50                   	push   %eax
801015c0:	e8 0b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015c5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015c8:	89 c7                	mov    %eax,%edi
  memmove(sb, bp->data, sizeof(*sb));
801015ca:	83 c0 5c             	add    $0x5c,%eax
801015cd:	6a 1c                	push   $0x1c
801015cf:	50                   	push   %eax
801015d0:	68 b4 25 11 80       	push   $0x801125b4
801015d5:	e8 d6 33 00 00       	call   801049b0 <memmove>
  brelse(bp);
801015da:	89 3c 24             	mov    %edi,(%esp)
801015dd:	e8 0e ec ff ff       	call   801001f0 <brelse>
  bp = bread(dev, BBLOCK(b, sb));
801015e2:	58                   	pop    %eax
801015e3:	89 d8                	mov    %ebx,%eax
801015e5:	5a                   	pop    %edx
801015e6:	c1 e8 0c             	shr    $0xc,%eax
801015e9:	03 05 cc 25 11 80    	add    0x801125cc,%eax
801015ef:	50                   	push   %eax
801015f0:	56                   	push   %esi
801015f1:	e8 da ea ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801015f6:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801015f8:	c1 fb 03             	sar    $0x3,%ebx
801015fb:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015fe:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101600:	83 e1 07             	and    $0x7,%ecx
80101603:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101608:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
8010160e:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101610:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
80101615:	85 c1                	test   %eax,%ecx
80101617:	74 24                	je     8010163d <bfree+0x8d>
  bp->data[bi/8] &= ~m;
80101619:	f7 d0                	not    %eax
  log_write(bp);
8010161b:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
8010161e:	21 c8                	and    %ecx,%eax
80101620:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101624:	56                   	push   %esi
80101625:	e8 b6 1b 00 00       	call   801031e0 <log_write>
  brelse(bp);
8010162a:	89 34 24             	mov    %esi,(%esp)
8010162d:	e8 be eb ff ff       	call   801001f0 <brelse>
}
80101632:	83 c4 10             	add    $0x10,%esp
80101635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101638:	5b                   	pop    %ebx
80101639:	5e                   	pop    %esi
8010163a:	5f                   	pop    %edi
8010163b:	5d                   	pop    %ebp
8010163c:	c3                   	ret    
    panic("freeing free block");
8010163d:	83 ec 0c             	sub    $0xc,%esp
80101640:	68 f8 77 10 80       	push   $0x801077f8
80101645:	e8 36 ed ff ff       	call   80100380 <panic>
8010164a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101650 <readsb>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	56                   	push   %esi
80101654:	53                   	push   %ebx
80101655:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101658:	83 ec 08             	sub    $0x8,%esp
8010165b:	6a 01                	push   $0x1
8010165d:	ff 75 08             	pushl  0x8(%ebp)
80101660:	e8 6b ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101665:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101668:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010166a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010166d:	6a 1c                	push   $0x1c
8010166f:	50                   	push   %eax
80101670:	56                   	push   %esi
80101671:	e8 3a 33 00 00       	call   801049b0 <memmove>
  brelse(bp);
80101676:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101679:	83 c4 10             	add    $0x10,%esp
}
8010167c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010167f:	5b                   	pop    %ebx
80101680:	5e                   	pop    %esi
80101681:	5d                   	pop    %ebp
  brelse(bp);
80101682:	e9 69 eb ff ff       	jmp    801001f0 <brelse>
80101687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010168e:	66 90                	xchg   %ax,%ax

80101690 <iinit>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101699:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010169c:	68 0b 78 10 80       	push   $0x8010780b
801016a1:	68 60 09 11 80       	push   $0x80110960
801016a6:	e8 e5 2f 00 00       	call   80104690 <initlock>
  for(i = 0; i < NINODE; i++) {
801016ab:	83 c4 10             	add    $0x10,%esp
801016ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801016b0:	83 ec 08             	sub    $0x8,%esp
801016b3:	68 12 78 10 80       	push   $0x80107812
801016b8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801016b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801016bf:	e8 bc 2e 00 00       	call   80104580 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016c4:	83 c4 10             	add    $0x10,%esp
801016c7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801016cd:	75 e1                	jne    801016b0 <iinit+0x20>
  bp = bread(dev, 1);
801016cf:	83 ec 08             	sub    $0x8,%esp
801016d2:	6a 01                	push   $0x1
801016d4:	ff 75 08             	pushl  0x8(%ebp)
801016d7:	e8 f4 e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801016dc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801016df:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016e1:	8d 40 5c             	lea    0x5c(%eax),%eax
801016e4:	6a 1c                	push   $0x1c
801016e6:	50                   	push   %eax
801016e7:	68 b4 25 11 80       	push   $0x801125b4
801016ec:	e8 bf 32 00 00       	call   801049b0 <memmove>
  brelse(bp);
801016f1:	89 1c 24             	mov    %ebx,(%esp)
801016f4:	e8 f7 ea ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016f9:	ff 35 cc 25 11 80    	pushl  0x801125cc
801016ff:	ff 35 c8 25 11 80    	pushl  0x801125c8
80101705:	ff 35 c4 25 11 80    	pushl  0x801125c4
8010170b:	ff 35 c0 25 11 80    	pushl  0x801125c0
80101711:	ff 35 bc 25 11 80    	pushl  0x801125bc
80101717:	ff 35 b8 25 11 80    	pushl  0x801125b8
8010171d:	ff 35 b4 25 11 80    	pushl  0x801125b4
80101723:	68 78 78 10 80       	push   $0x80107878
80101728:	e8 53 ef ff ff       	call   80100680 <cprintf>
}
8010172d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101730:	83 c4 30             	add    $0x30,%esp
80101733:	c9                   	leave  
80101734:	c3                   	ret    
80101735:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101740 <ialloc>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	57                   	push   %edi
80101744:	56                   	push   %esi
80101745:	53                   	push   %ebx
80101746:	83 ec 1c             	sub    $0x1c,%esp
80101749:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010174c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101753:	8b 75 08             	mov    0x8(%ebp),%esi
80101756:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101759:	0f 86 91 00 00 00    	jbe    801017f0 <ialloc+0xb0>
8010175f:	bf 01 00 00 00       	mov    $0x1,%edi
80101764:	eb 21                	jmp    80101787 <ialloc+0x47>
80101766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010176d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101770:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101773:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101776:	53                   	push   %ebx
80101777:	e8 74 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010177c:	83 c4 10             	add    $0x10,%esp
8010177f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101785:	73 69                	jae    801017f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101787:	89 f8                	mov    %edi,%eax
80101789:	83 ec 08             	sub    $0x8,%esp
8010178c:	c1 e8 03             	shr    $0x3,%eax
8010178f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101795:	50                   	push   %eax
80101796:	56                   	push   %esi
80101797:	e8 34 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010179c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010179f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801017a1:	89 f8                	mov    %edi,%eax
801017a3:	83 e0 07             	and    $0x7,%eax
801017a6:	c1 e0 06             	shl    $0x6,%eax
801017a9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017b1:	75 bd                	jne    80101770 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017b3:	83 ec 04             	sub    $0x4,%esp
801017b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017b9:	6a 40                	push   $0x40
801017bb:	6a 00                	push   $0x0
801017bd:	51                   	push   %ecx
801017be:	e8 4d 31 00 00       	call   80104910 <memset>
      dip->type = type;
801017c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017cd:	89 1c 24             	mov    %ebx,(%esp)
801017d0:	e8 0b 1a 00 00       	call   801031e0 <log_write>
      brelse(bp);
801017d5:	89 1c 24             	mov    %ebx,(%esp)
801017d8:	e8 13 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801017dd:	83 c4 10             	add    $0x10,%esp
}
801017e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017e3:	89 fa                	mov    %edi,%edx
}
801017e5:	5b                   	pop    %ebx
      return iget(dev, inum);
801017e6:	89 f0                	mov    %esi,%eax
}
801017e8:	5e                   	pop    %esi
801017e9:	5f                   	pop    %edi
801017ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801017eb:	e9 00 fc ff ff       	jmp    801013f0 <iget>
  panic("ialloc: no inodes");
801017f0:	83 ec 0c             	sub    $0xc,%esp
801017f3:	68 18 78 10 80       	push   $0x80107818
801017f8:	e8 83 eb ff ff       	call   80100380 <panic>
801017fd:	8d 76 00             	lea    0x0(%esi),%esi

80101800 <iupdate>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101808:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010180b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010180e:	83 ec 08             	sub    $0x8,%esp
80101811:	c1 e8 03             	shr    $0x3,%eax
80101814:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010181a:	50                   	push   %eax
8010181b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010181e:	e8 ad e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101823:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101827:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010182a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010182c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010182f:	83 e0 07             	and    $0x7,%eax
80101832:	c1 e0 06             	shl    $0x6,%eax
80101835:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101839:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010183c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101840:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101843:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101847:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010184b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010184f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101853:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101857:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010185a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010185d:	6a 34                	push   $0x34
8010185f:	53                   	push   %ebx
80101860:	50                   	push   %eax
80101861:	e8 4a 31 00 00       	call   801049b0 <memmove>
  log_write(bp);
80101866:	89 34 24             	mov    %esi,(%esp)
80101869:	e8 72 19 00 00       	call   801031e0 <log_write>
  brelse(bp);
8010186e:	89 75 08             	mov    %esi,0x8(%ebp)
80101871:	83 c4 10             	add    $0x10,%esp
}
80101874:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101877:	5b                   	pop    %ebx
80101878:	5e                   	pop    %esi
80101879:	5d                   	pop    %ebp
  brelse(bp);
8010187a:	e9 71 e9 ff ff       	jmp    801001f0 <brelse>
8010187f:	90                   	nop

80101880 <idup>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	53                   	push   %ebx
80101884:	83 ec 10             	sub    $0x10,%esp
80101887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010188a:	68 60 09 11 80       	push   $0x80110960
8010188f:	e8 0c 2f 00 00       	call   801047a0 <acquire>
  ip->ref++;
80101894:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101898:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010189f:	e8 1c 30 00 00       	call   801048c0 <release>
}
801018a4:	89 d8                	mov    %ebx,%eax
801018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018a9:	c9                   	leave  
801018aa:	c3                   	ret    
801018ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <ilock>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801018b8:	85 db                	test   %ebx,%ebx
801018ba:	0f 84 b7 00 00 00    	je     80101977 <ilock+0xc7>
801018c0:	8b 53 08             	mov    0x8(%ebx),%edx
801018c3:	85 d2                	test   %edx,%edx
801018c5:	0f 8e ac 00 00 00    	jle    80101977 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018cb:	83 ec 0c             	sub    $0xc,%esp
801018ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801018d1:	50                   	push   %eax
801018d2:	e8 e9 2c 00 00       	call   801045c0 <acquiresleep>
  if(ip->valid == 0){
801018d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018da:	83 c4 10             	add    $0x10,%esp
801018dd:	85 c0                	test   %eax,%eax
801018df:	74 0f                	je     801018f0 <ilock+0x40>
}
801018e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018e4:	5b                   	pop    %ebx
801018e5:	5e                   	pop    %esi
801018e6:	5d                   	pop    %ebp
801018e7:	c3                   	ret    
801018e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ef:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018f0:	8b 43 04             	mov    0x4(%ebx),%eax
801018f3:	83 ec 08             	sub    $0x8,%esp
801018f6:	c1 e8 03             	shr    $0x3,%eax
801018f9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801018ff:	50                   	push   %eax
80101900:	ff 33                	pushl  (%ebx)
80101902:	e8 c9 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101907:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010190a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010190c:	8b 43 04             	mov    0x4(%ebx),%eax
8010190f:	83 e0 07             	and    $0x7,%eax
80101912:	c1 e0 06             	shl    $0x6,%eax
80101915:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101919:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010191c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010191f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101923:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101927:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010192b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010192f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101933:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101937:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010193b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010193e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101941:	6a 34                	push   $0x34
80101943:	50                   	push   %eax
80101944:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101947:	50                   	push   %eax
80101948:	e8 63 30 00 00       	call   801049b0 <memmove>
    brelse(bp);
8010194d:	89 34 24             	mov    %esi,(%esp)
80101950:	e8 9b e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101955:	83 c4 10             	add    $0x10,%esp
80101958:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010195d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101964:	0f 85 77 ff ff ff    	jne    801018e1 <ilock+0x31>
      panic("ilock: no type");
8010196a:	83 ec 0c             	sub    $0xc,%esp
8010196d:	68 30 78 10 80       	push   $0x80107830
80101972:	e8 09 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101977:	83 ec 0c             	sub    $0xc,%esp
8010197a:	68 2a 78 10 80       	push   $0x8010782a
8010197f:	e8 fc e9 ff ff       	call   80100380 <panic>
80101984:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010198b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010198f:	90                   	nop

80101990 <iunlock>:
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	56                   	push   %esi
80101994:	53                   	push   %ebx
80101995:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101998:	85 db                	test   %ebx,%ebx
8010199a:	74 28                	je     801019c4 <iunlock+0x34>
8010199c:	83 ec 0c             	sub    $0xc,%esp
8010199f:	8d 73 0c             	lea    0xc(%ebx),%esi
801019a2:	56                   	push   %esi
801019a3:	e8 b8 2c 00 00       	call   80104660 <holdingsleep>
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	85 c0                	test   %eax,%eax
801019ad:	74 15                	je     801019c4 <iunlock+0x34>
801019af:	8b 43 08             	mov    0x8(%ebx),%eax
801019b2:	85 c0                	test   %eax,%eax
801019b4:	7e 0e                	jle    801019c4 <iunlock+0x34>
  releasesleep(&ip->lock);
801019b6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019bc:	5b                   	pop    %ebx
801019bd:	5e                   	pop    %esi
801019be:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801019bf:	e9 5c 2c 00 00       	jmp    80104620 <releasesleep>
    panic("iunlock");
801019c4:	83 ec 0c             	sub    $0xc,%esp
801019c7:	68 3f 78 10 80       	push   $0x8010783f
801019cc:	e8 af e9 ff ff       	call   80100380 <panic>
801019d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019df:	90                   	nop

801019e0 <iput>:
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 28             	sub    $0x28,%esp
801019e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019ec:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019ef:	57                   	push   %edi
801019f0:	e8 cb 2b 00 00       	call   801045c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019f5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019f8:	83 c4 10             	add    $0x10,%esp
801019fb:	85 d2                	test   %edx,%edx
801019fd:	74 07                	je     80101a06 <iput+0x26>
801019ff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a04:	74 32                	je     80101a38 <iput+0x58>
  releasesleep(&ip->lock);
80101a06:	83 ec 0c             	sub    $0xc,%esp
80101a09:	57                   	push   %edi
80101a0a:	e8 11 2c 00 00       	call   80104620 <releasesleep>
  acquire(&icache.lock);
80101a0f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a16:	e8 85 2d 00 00       	call   801047a0 <acquire>
  ip->ref--;
80101a1b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a1f:	83 c4 10             	add    $0x10,%esp
80101a22:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a2c:	5b                   	pop    %ebx
80101a2d:	5e                   	pop    %esi
80101a2e:	5f                   	pop    %edi
80101a2f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a30:	e9 8b 2e 00 00       	jmp    801048c0 <release>
80101a35:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a38:	83 ec 0c             	sub    $0xc,%esp
80101a3b:	68 60 09 11 80       	push   $0x80110960
80101a40:	e8 5b 2d 00 00       	call   801047a0 <acquire>
    int r = ip->ref;
80101a45:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a48:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a4f:	e8 6c 2e 00 00       	call   801048c0 <release>
    if(r == 1){
80101a54:	83 c4 10             	add    $0x10,%esp
80101a57:	83 fe 01             	cmp    $0x1,%esi
80101a5a:	75 aa                	jne    80101a06 <iput+0x26>
80101a5c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a62:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a65:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a68:	89 cf                	mov    %ecx,%edi
80101a6a:	eb 0b                	jmp    80101a77 <iput+0x97>
80101a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a70:	83 c6 04             	add    $0x4,%esi
80101a73:	39 fe                	cmp    %edi,%esi
80101a75:	74 19                	je     80101a90 <iput+0xb0>
    if(ip->addrs[i]){
80101a77:	8b 16                	mov    (%esi),%edx
80101a79:	85 d2                	test   %edx,%edx
80101a7b:	74 f3                	je     80101a70 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a7d:	8b 03                	mov    (%ebx),%eax
80101a7f:	e8 2c fb ff ff       	call   801015b0 <bfree>
      ip->addrs[i] = 0;
80101a84:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a8a:	eb e4                	jmp    80101a70 <iput+0x90>
80101a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a90:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a96:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a99:	85 c0                	test   %eax,%eax
80101a9b:	75 2d                	jne    80101aca <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a9d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101aa0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101aa7:	53                   	push   %ebx
80101aa8:	e8 53 fd ff ff       	call   80101800 <iupdate>
      ip->type = 0;
80101aad:	31 c0                	xor    %eax,%eax
80101aaf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101ab3:	89 1c 24             	mov    %ebx,(%esp)
80101ab6:	e8 45 fd ff ff       	call   80101800 <iupdate>
      ip->valid = 0;
80101abb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ac2:	83 c4 10             	add    $0x10,%esp
80101ac5:	e9 3c ff ff ff       	jmp    80101a06 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101aca:	83 ec 08             	sub    $0x8,%esp
80101acd:	50                   	push   %eax
80101ace:	ff 33                	pushl  (%ebx)
80101ad0:	e8 fb e5 ff ff       	call   801000d0 <bread>
80101ad5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ad8:	83 c4 10             	add    $0x10,%esp
80101adb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ae4:	8d 70 5c             	lea    0x5c(%eax),%esi
80101ae7:	89 cf                	mov    %ecx,%edi
80101ae9:	eb 0c                	jmp    80101af7 <iput+0x117>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
80101af0:	83 c6 04             	add    $0x4,%esi
80101af3:	39 f7                	cmp    %esi,%edi
80101af5:	74 0f                	je     80101b06 <iput+0x126>
      if(a[j])
80101af7:	8b 16                	mov    (%esi),%edx
80101af9:	85 d2                	test   %edx,%edx
80101afb:	74 f3                	je     80101af0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101afd:	8b 03                	mov    (%ebx),%eax
80101aff:	e8 ac fa ff ff       	call   801015b0 <bfree>
80101b04:	eb ea                	jmp    80101af0 <iput+0x110>
    brelse(bp);
80101b06:	83 ec 0c             	sub    $0xc,%esp
80101b09:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b0c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b0f:	e8 dc e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b14:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b1a:	8b 03                	mov    (%ebx),%eax
80101b1c:	e8 8f fa ff ff       	call   801015b0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b21:	83 c4 10             	add    $0x10,%esp
80101b24:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b2b:	00 00 00 
80101b2e:	e9 6a ff ff ff       	jmp    80101a9d <iput+0xbd>
80101b33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b40 <iunlockput>:
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	56                   	push   %esi
80101b44:	53                   	push   %ebx
80101b45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b48:	85 db                	test   %ebx,%ebx
80101b4a:	74 34                	je     80101b80 <iunlockput+0x40>
80101b4c:	83 ec 0c             	sub    $0xc,%esp
80101b4f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b52:	56                   	push   %esi
80101b53:	e8 08 2b 00 00       	call   80104660 <holdingsleep>
80101b58:	83 c4 10             	add    $0x10,%esp
80101b5b:	85 c0                	test   %eax,%eax
80101b5d:	74 21                	je     80101b80 <iunlockput+0x40>
80101b5f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b62:	85 c0                	test   %eax,%eax
80101b64:	7e 1a                	jle    80101b80 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b66:	83 ec 0c             	sub    $0xc,%esp
80101b69:	56                   	push   %esi
80101b6a:	e8 b1 2a 00 00       	call   80104620 <releasesleep>
  iput(ip);
80101b6f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b72:	83 c4 10             	add    $0x10,%esp
}
80101b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b78:	5b                   	pop    %ebx
80101b79:	5e                   	pop    %esi
80101b7a:	5d                   	pop    %ebp
  iput(ip);
80101b7b:	e9 60 fe ff ff       	jmp    801019e0 <iput>
    panic("iunlock");
80101b80:	83 ec 0c             	sub    $0xc,%esp
80101b83:	68 3f 78 10 80       	push   $0x8010783f
80101b88:	e8 f3 e7 ff ff       	call   80100380 <panic>
80101b8d:	8d 76 00             	lea    0x0(%esi),%esi

80101b90 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	8b 55 08             	mov    0x8(%ebp),%edx
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b99:	8b 0a                	mov    (%edx),%ecx
80101b9b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b9e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ba1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ba4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ba8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101bab:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101baf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101bb3:	8b 52 58             	mov    0x58(%edx),%edx
80101bb6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101bb9:	5d                   	pop    %ebp
80101bba:	c3                   	ret    
80101bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bbf:	90                   	nop

80101bc0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcf:	8b 75 10             	mov    0x10(%ebp),%esi
80101bd2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bd5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bd8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bdd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101be0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101be3:	0f 84 a7 00 00 00    	je     80101c90 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101be9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bec:	8b 40 58             	mov    0x58(%eax),%eax
80101bef:	39 c6                	cmp    %eax,%esi
80101bf1:	0f 87 ba 00 00 00    	ja     80101cb1 <readi+0xf1>
80101bf7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bfa:	31 c9                	xor    %ecx,%ecx
80101bfc:	89 da                	mov    %ebx,%edx
80101bfe:	01 f2                	add    %esi,%edx
80101c00:	0f 92 c1             	setb   %cl
80101c03:	89 cf                	mov    %ecx,%edi
80101c05:	0f 82 a6 00 00 00    	jb     80101cb1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c0b:	89 c1                	mov    %eax,%ecx
80101c0d:	29 f1                	sub    %esi,%ecx
80101c0f:	39 d0                	cmp    %edx,%eax
80101c11:	0f 43 cb             	cmovae %ebx,%ecx
80101c14:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c17:	85 c9                	test   %ecx,%ecx
80101c19:	74 67                	je     80101c82 <readi+0xc2>
80101c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c1f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c20:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c23:	89 f2                	mov    %esi,%edx
80101c25:	c1 ea 09             	shr    $0x9,%edx
80101c28:	89 d8                	mov    %ebx,%eax
80101c2a:	e8 b1 f8 ff ff       	call   801014e0 <bmap>
80101c2f:	83 ec 08             	sub    $0x8,%esp
80101c32:	50                   	push   %eax
80101c33:	ff 33                	pushl  (%ebx)
80101c35:	e8 96 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c3a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c3d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c42:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c45:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c47:	89 f0                	mov    %esi,%eax
80101c49:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c4e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c50:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c53:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c55:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c59:	39 d9                	cmp    %ebx,%ecx
80101c5b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c5e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c5f:	01 df                	add    %ebx,%edi
80101c61:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c63:	50                   	push   %eax
80101c64:	ff 75 e0             	pushl  -0x20(%ebp)
80101c67:	e8 44 2d 00 00       	call   801049b0 <memmove>
    brelse(bp);
80101c6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c6f:	89 14 24             	mov    %edx,(%esp)
80101c72:	e8 79 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c77:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c7a:	83 c4 10             	add    $0x10,%esp
80101c7d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c80:	77 9e                	ja     80101c20 <readi+0x60>
  }
  return n;
80101c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c88:	5b                   	pop    %ebx
80101c89:	5e                   	pop    %esi
80101c8a:	5f                   	pop    %edi
80101c8b:	5d                   	pop    %ebp
80101c8c:	c3                   	ret    
80101c8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 17                	ja     80101cb1 <readi+0xf1>
80101c9a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 0c                	je     80101cb1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ca5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101caf:	ff e0                	jmp    *%eax
      return -1;
80101cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb6:	eb cd                	jmp    80101c85 <readi+0xc5>
80101cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cbf:	90                   	nop

80101cc0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	57                   	push   %edi
80101cc4:	56                   	push   %esi
80101cc5:	53                   	push   %ebx
80101cc6:	83 ec 1c             	sub    $0x1c,%esp
80101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101ccf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cd2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cd7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cdd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ce0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ce3:	0f 84 b7 00 00 00    	je     80101da0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ce9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cec:	3b 70 58             	cmp    0x58(%eax),%esi
80101cef:	0f 87 e7 00 00 00    	ja     80101ddc <writei+0x11c>
80101cf5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cf8:	31 d2                	xor    %edx,%edx
80101cfa:	89 f8                	mov    %edi,%eax
80101cfc:	01 f0                	add    %esi,%eax
80101cfe:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d01:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d06:	0f 87 d0 00 00 00    	ja     80101ddc <writei+0x11c>
80101d0c:	85 d2                	test   %edx,%edx
80101d0e:	0f 85 c8 00 00 00    	jne    80101ddc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d14:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d1b:	85 ff                	test   %edi,%edi
80101d1d:	74 72                	je     80101d91 <writei+0xd1>
80101d1f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d20:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d23:	89 f2                	mov    %esi,%edx
80101d25:	c1 ea 09             	shr    $0x9,%edx
80101d28:	89 f8                	mov    %edi,%eax
80101d2a:	e8 b1 f7 ff ff       	call   801014e0 <bmap>
80101d2f:	83 ec 08             	sub    $0x8,%esp
80101d32:	50                   	push   %eax
80101d33:	ff 37                	pushl  (%edi)
80101d35:	e8 96 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d3a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d3f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d42:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d45:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d47:	89 f0                	mov    %esi,%eax
80101d49:	83 c4 0c             	add    $0xc,%esp
80101d4c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d51:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d53:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d57:	39 d9                	cmp    %ebx,%ecx
80101d59:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d5c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d5d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d5f:	ff 75 dc             	pushl  -0x24(%ebp)
80101d62:	50                   	push   %eax
80101d63:	e8 48 2c 00 00       	call   801049b0 <memmove>
    log_write(bp);
80101d68:	89 3c 24             	mov    %edi,(%esp)
80101d6b:	e8 70 14 00 00       	call   801031e0 <log_write>
    brelse(bp);
80101d70:	89 3c 24             	mov    %edi,(%esp)
80101d73:	e8 78 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d78:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d7b:	83 c4 10             	add    $0x10,%esp
80101d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d81:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d84:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d87:	77 97                	ja     80101d20 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d8c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d8f:	77 37                	ja     80101dc8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d91:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d97:	5b                   	pop    %ebx
80101d98:	5e                   	pop    %esi
80101d99:	5f                   	pop    %edi
80101d9a:	5d                   	pop    %ebp
80101d9b:	c3                   	ret    
80101d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101da0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101da4:	66 83 f8 09          	cmp    $0x9,%ax
80101da8:	77 32                	ja     80101ddc <writei+0x11c>
80101daa:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101db1:	85 c0                	test   %eax,%eax
80101db3:	74 27                	je     80101ddc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101db5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101dbf:	ff e0                	jmp    *%eax
80101dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101dc8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101dcb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dce:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101dd1:	50                   	push   %eax
80101dd2:	e8 29 fa ff ff       	call   80101800 <iupdate>
80101dd7:	83 c4 10             	add    $0x10,%esp
80101dda:	eb b5                	jmp    80101d91 <writei+0xd1>
      return -1;
80101ddc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101de1:	eb b1                	jmp    80101d94 <writei+0xd4>
80101de3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101df0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101df6:	6a 0e                	push   $0xe
80101df8:	ff 75 0c             	pushl  0xc(%ebp)
80101dfb:	ff 75 08             	pushl  0x8(%ebp)
80101dfe:	e8 1d 2c 00 00       	call   80104a20 <strncmp>
}
80101e03:	c9                   	leave  
80101e04:	c3                   	ret    
80101e05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 1c             	sub    $0x1c,%esp
80101e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e21:	0f 85 85 00 00 00    	jne    80101eac <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e27:	8b 53 58             	mov    0x58(%ebx),%edx
80101e2a:	31 ff                	xor    %edi,%edi
80101e2c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2f:	85 d2                	test   %edx,%edx
80101e31:	74 3e                	je     80101e71 <dirlookup+0x61>
80101e33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e37:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e38:	6a 10                	push   $0x10
80101e3a:	57                   	push   %edi
80101e3b:	56                   	push   %esi
80101e3c:	53                   	push   %ebx
80101e3d:	e8 7e fd ff ff       	call   80101bc0 <readi>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	83 f8 10             	cmp    $0x10,%eax
80101e48:	75 55                	jne    80101e9f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4f:	74 18                	je     80101e69 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e51:	83 ec 04             	sub    $0x4,%esp
80101e54:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e57:	6a 0e                	push   $0xe
80101e59:	50                   	push   %eax
80101e5a:	ff 75 0c             	pushl  0xc(%ebp)
80101e5d:	e8 be 2b 00 00       	call   80104a20 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	85 c0                	test   %eax,%eax
80101e67:	74 17                	je     80101e80 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e69:	83 c7 10             	add    $0x10,%edi
80101e6c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e6f:	72 c7                	jb     80101e38 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e74:	31 c0                	xor    %eax,%eax
}
80101e76:	5b                   	pop    %ebx
80101e77:	5e                   	pop    %esi
80101e78:	5f                   	pop    %edi
80101e79:	5d                   	pop    %ebp
80101e7a:	c3                   	ret    
80101e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e7f:	90                   	nop
      if(poff)
80101e80:	8b 45 10             	mov    0x10(%ebp),%eax
80101e83:	85 c0                	test   %eax,%eax
80101e85:	74 05                	je     80101e8c <dirlookup+0x7c>
        *poff = off;
80101e87:	8b 45 10             	mov    0x10(%ebp),%eax
80101e8a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e8c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e90:	8b 03                	mov    (%ebx),%eax
80101e92:	e8 59 f5 ff ff       	call   801013f0 <iget>
}
80101e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e9a:	5b                   	pop    %ebx
80101e9b:	5e                   	pop    %esi
80101e9c:	5f                   	pop    %edi
80101e9d:	5d                   	pop    %ebp
80101e9e:	c3                   	ret    
      panic("dirlookup read");
80101e9f:	83 ec 0c             	sub    $0xc,%esp
80101ea2:	68 59 78 10 80       	push   $0x80107859
80101ea7:	e8 d4 e4 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101eac:	83 ec 0c             	sub    $0xc,%esp
80101eaf:	68 47 78 10 80       	push   $0x80107847
80101eb4:	e8 c7 e4 ff ff       	call   80100380 <panic>
80101eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ec0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	57                   	push   %edi
80101ec4:	56                   	push   %esi
80101ec5:	53                   	push   %ebx
80101ec6:	89 c3                	mov    %eax,%ebx
80101ec8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ecb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ece:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ed1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101ed4:	0f 84 64 01 00 00    	je     8010203e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eda:	e8 41 1d 00 00       	call   80103c20 <myproc>
  acquire(&icache.lock);
80101edf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ee2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ee5:	68 60 09 11 80       	push   $0x80110960
80101eea:	e8 b1 28 00 00       	call   801047a0 <acquire>
  ip->ref++;
80101eef:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ef3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101efa:	e8 c1 29 00 00       	call   801048c0 <release>
80101eff:	83 c4 10             	add    $0x10,%esp
80101f02:	eb 07                	jmp    80101f0b <namex+0x4b>
80101f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f08:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f0b:	0f b6 03             	movzbl (%ebx),%eax
80101f0e:	3c 2f                	cmp    $0x2f,%al
80101f10:	74 f6                	je     80101f08 <namex+0x48>
  if(*path == 0)
80101f12:	84 c0                	test   %al,%al
80101f14:	0f 84 06 01 00 00    	je     80102020 <namex+0x160>
  while(*path != '/' && *path != 0)
80101f1a:	0f b6 03             	movzbl (%ebx),%eax
80101f1d:	84 c0                	test   %al,%al
80101f1f:	0f 84 10 01 00 00    	je     80102035 <namex+0x175>
80101f25:	89 df                	mov    %ebx,%edi
80101f27:	3c 2f                	cmp    $0x2f,%al
80101f29:	0f 84 06 01 00 00    	je     80102035 <namex+0x175>
80101f2f:	90                   	nop
80101f30:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f34:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f37:	3c 2f                	cmp    $0x2f,%al
80101f39:	74 04                	je     80101f3f <namex+0x7f>
80101f3b:	84 c0                	test   %al,%al
80101f3d:	75 f1                	jne    80101f30 <namex+0x70>
  len = path - s;
80101f3f:	89 f8                	mov    %edi,%eax
80101f41:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f43:	83 f8 0d             	cmp    $0xd,%eax
80101f46:	0f 8e ac 00 00 00    	jle    80101ff8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f4c:	83 ec 04             	sub    $0x4,%esp
80101f4f:	6a 0e                	push   $0xe
80101f51:	53                   	push   %ebx
    path++;
80101f52:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101f54:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f57:	e8 54 2a 00 00       	call   801049b0 <memmove>
80101f5c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f5f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f62:	75 0c                	jne    80101f70 <namex+0xb0>
80101f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f6b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f6e:	74 f8                	je     80101f68 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f70:	83 ec 0c             	sub    $0xc,%esp
80101f73:	56                   	push   %esi
80101f74:	e8 37 f9 ff ff       	call   801018b0 <ilock>
    if(ip->type != T_DIR){
80101f79:	83 c4 10             	add    $0x10,%esp
80101f7c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f81:	0f 85 cd 00 00 00    	jne    80102054 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f87:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f8a:	85 c0                	test   %eax,%eax
80101f8c:	74 09                	je     80101f97 <namex+0xd7>
80101f8e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f91:	0f 84 22 01 00 00    	je     801020b9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f97:	83 ec 04             	sub    $0x4,%esp
80101f9a:	6a 00                	push   $0x0
80101f9c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f9f:	56                   	push   %esi
80101fa0:	e8 6b fe ff ff       	call   80101e10 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fa5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	89 c7                	mov    %eax,%edi
80101fad:	85 c0                	test   %eax,%eax
80101faf:	0f 84 e1 00 00 00    	je     80102096 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fb5:	83 ec 0c             	sub    $0xc,%esp
80101fb8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101fbb:	52                   	push   %edx
80101fbc:	e8 9f 26 00 00       	call   80104660 <holdingsleep>
80101fc1:	83 c4 10             	add    $0x10,%esp
80101fc4:	85 c0                	test   %eax,%eax
80101fc6:	0f 84 30 01 00 00    	je     801020fc <namex+0x23c>
80101fcc:	8b 56 08             	mov    0x8(%esi),%edx
80101fcf:	85 d2                	test   %edx,%edx
80101fd1:	0f 8e 25 01 00 00    	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
80101fd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fda:	83 ec 0c             	sub    $0xc,%esp
80101fdd:	52                   	push   %edx
80101fde:	e8 3d 26 00 00       	call   80104620 <releasesleep>
  iput(ip);
80101fe3:	89 34 24             	mov    %esi,(%esp)
80101fe6:	89 fe                	mov    %edi,%esi
80101fe8:	e8 f3 f9 ff ff       	call   801019e0 <iput>
80101fed:	83 c4 10             	add    $0x10,%esp
80101ff0:	e9 16 ff ff ff       	jmp    80101f0b <namex+0x4b>
80101ff5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ff8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ffb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ffe:	83 ec 04             	sub    $0x4,%esp
80102001:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102004:	50                   	push   %eax
80102005:	53                   	push   %ebx
    name[len] = 0;
80102006:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102008:	ff 75 e4             	pushl  -0x1c(%ebp)
8010200b:	e8 a0 29 00 00       	call   801049b0 <memmove>
    name[len] = 0;
80102010:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102013:	83 c4 10             	add    $0x10,%esp
80102016:	c6 02 00             	movb   $0x0,(%edx)
80102019:	e9 41 ff ff ff       	jmp    80101f5f <namex+0x9f>
8010201e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102020:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102023:	85 c0                	test   %eax,%eax
80102025:	0f 85 be 00 00 00    	jne    801020e9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010202b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010202e:	89 f0                	mov    %esi,%eax
80102030:	5b                   	pop    %ebx
80102031:	5e                   	pop    %esi
80102032:	5f                   	pop    %edi
80102033:	5d                   	pop    %ebp
80102034:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102035:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102038:	89 df                	mov    %ebx,%edi
8010203a:	31 c0                	xor    %eax,%eax
8010203c:	eb c0                	jmp    80101ffe <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010203e:	ba 01 00 00 00       	mov    $0x1,%edx
80102043:	b8 01 00 00 00       	mov    $0x1,%eax
80102048:	e8 a3 f3 ff ff       	call   801013f0 <iget>
8010204d:	89 c6                	mov    %eax,%esi
8010204f:	e9 b7 fe ff ff       	jmp    80101f0b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102054:	83 ec 0c             	sub    $0xc,%esp
80102057:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010205a:	53                   	push   %ebx
8010205b:	e8 00 26 00 00       	call   80104660 <holdingsleep>
80102060:	83 c4 10             	add    $0x10,%esp
80102063:	85 c0                	test   %eax,%eax
80102065:	0f 84 91 00 00 00    	je     801020fc <namex+0x23c>
8010206b:	8b 46 08             	mov    0x8(%esi),%eax
8010206e:	85 c0                	test   %eax,%eax
80102070:	0f 8e 86 00 00 00    	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
80102076:	83 ec 0c             	sub    $0xc,%esp
80102079:	53                   	push   %ebx
8010207a:	e8 a1 25 00 00       	call   80104620 <releasesleep>
  iput(ip);
8010207f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102082:	31 f6                	xor    %esi,%esi
  iput(ip);
80102084:	e8 57 f9 ff ff       	call   801019e0 <iput>
      return 0;
80102089:	83 c4 10             	add    $0x10,%esp
}
8010208c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208f:	89 f0                	mov    %esi,%eax
80102091:	5b                   	pop    %ebx
80102092:	5e                   	pop    %esi
80102093:	5f                   	pop    %edi
80102094:	5d                   	pop    %ebp
80102095:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102096:	83 ec 0c             	sub    $0xc,%esp
80102099:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010209c:	52                   	push   %edx
8010209d:	e8 be 25 00 00       	call   80104660 <holdingsleep>
801020a2:	83 c4 10             	add    $0x10,%esp
801020a5:	85 c0                	test   %eax,%eax
801020a7:	74 53                	je     801020fc <namex+0x23c>
801020a9:	8b 4e 08             	mov    0x8(%esi),%ecx
801020ac:	85 c9                	test   %ecx,%ecx
801020ae:	7e 4c                	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
801020b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801020b3:	83 ec 0c             	sub    $0xc,%esp
801020b6:	52                   	push   %edx
801020b7:	eb c1                	jmp    8010207a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020b9:	83 ec 0c             	sub    $0xc,%esp
801020bc:	8d 5e 0c             	lea    0xc(%esi),%ebx
801020bf:	53                   	push   %ebx
801020c0:	e8 9b 25 00 00       	call   80104660 <holdingsleep>
801020c5:	83 c4 10             	add    $0x10,%esp
801020c8:	85 c0                	test   %eax,%eax
801020ca:	74 30                	je     801020fc <namex+0x23c>
801020cc:	8b 7e 08             	mov    0x8(%esi),%edi
801020cf:	85 ff                	test   %edi,%edi
801020d1:	7e 29                	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
801020d3:	83 ec 0c             	sub    $0xc,%esp
801020d6:	53                   	push   %ebx
801020d7:	e8 44 25 00 00       	call   80104620 <releasesleep>
}
801020dc:	83 c4 10             	add    $0x10,%esp
}
801020df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e2:	89 f0                	mov    %esi,%eax
801020e4:	5b                   	pop    %ebx
801020e5:	5e                   	pop    %esi
801020e6:	5f                   	pop    %edi
801020e7:	5d                   	pop    %ebp
801020e8:	c3                   	ret    
    iput(ip);
801020e9:	83 ec 0c             	sub    $0xc,%esp
801020ec:	56                   	push   %esi
    return 0;
801020ed:	31 f6                	xor    %esi,%esi
    iput(ip);
801020ef:	e8 ec f8 ff ff       	call   801019e0 <iput>
    return 0;
801020f4:	83 c4 10             	add    $0x10,%esp
801020f7:	e9 2f ff ff ff       	jmp    8010202b <namex+0x16b>
    panic("iunlock");
801020fc:	83 ec 0c             	sub    $0xc,%esp
801020ff:	68 3f 78 10 80       	push   $0x8010783f
80102104:	e8 77 e2 ff ff       	call   80100380 <panic>
80102109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102110 <dirlink>:
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	57                   	push   %edi
80102114:	56                   	push   %esi
80102115:	53                   	push   %ebx
80102116:	83 ec 20             	sub    $0x20,%esp
80102119:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010211c:	6a 00                	push   $0x0
8010211e:	ff 75 0c             	pushl  0xc(%ebp)
80102121:	53                   	push   %ebx
80102122:	e8 e9 fc ff ff       	call   80101e10 <dirlookup>
80102127:	83 c4 10             	add    $0x10,%esp
8010212a:	85 c0                	test   %eax,%eax
8010212c:	75 67                	jne    80102195 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010212e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102131:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102134:	85 ff                	test   %edi,%edi
80102136:	74 29                	je     80102161 <dirlink+0x51>
80102138:	31 ff                	xor    %edi,%edi
8010213a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010213d:	eb 09                	jmp    80102148 <dirlink+0x38>
8010213f:	90                   	nop
80102140:	83 c7 10             	add    $0x10,%edi
80102143:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102146:	73 19                	jae    80102161 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102148:	6a 10                	push   $0x10
8010214a:	57                   	push   %edi
8010214b:	56                   	push   %esi
8010214c:	53                   	push   %ebx
8010214d:	e8 6e fa ff ff       	call   80101bc0 <readi>
80102152:	83 c4 10             	add    $0x10,%esp
80102155:	83 f8 10             	cmp    $0x10,%eax
80102158:	75 4e                	jne    801021a8 <dirlink+0x98>
    if(de.inum == 0)
8010215a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010215f:	75 df                	jne    80102140 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102161:	83 ec 04             	sub    $0x4,%esp
80102164:	8d 45 da             	lea    -0x26(%ebp),%eax
80102167:	6a 0e                	push   $0xe
80102169:	ff 75 0c             	pushl  0xc(%ebp)
8010216c:	50                   	push   %eax
8010216d:	e8 fe 28 00 00       	call   80104a70 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102172:	6a 10                	push   $0x10
  de.inum = inum;
80102174:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102177:	57                   	push   %edi
80102178:	56                   	push   %esi
80102179:	53                   	push   %ebx
  de.inum = inum;
8010217a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010217e:	e8 3d fb ff ff       	call   80101cc0 <writei>
80102183:	83 c4 20             	add    $0x20,%esp
80102186:	83 f8 10             	cmp    $0x10,%eax
80102189:	75 2a                	jne    801021b5 <dirlink+0xa5>
  return 0;
8010218b:	31 c0                	xor    %eax,%eax
}
8010218d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102190:	5b                   	pop    %ebx
80102191:	5e                   	pop    %esi
80102192:	5f                   	pop    %edi
80102193:	5d                   	pop    %ebp
80102194:	c3                   	ret    
    iput(ip);
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	50                   	push   %eax
80102199:	e8 42 f8 ff ff       	call   801019e0 <iput>
    return -1;
8010219e:	83 c4 10             	add    $0x10,%esp
801021a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021a6:	eb e5                	jmp    8010218d <dirlink+0x7d>
      panic("dirlink read");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 68 78 10 80       	push   $0x80107868
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("dirlink");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 aa 7e 10 80       	push   $0x80107eaa
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <namei>:

struct inode*
namei(char *path)
{
801021d0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021d1:	31 d2                	xor    %edx,%edx
{
801021d3:	89 e5                	mov    %esp,%ebp
801021d5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021d8:	8b 45 08             	mov    0x8(%ebp),%eax
801021db:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021de:	e8 dd fc ff ff       	call   80101ec0 <namex>
}
801021e3:	c9                   	leave  
801021e4:	c3                   	ret    
801021e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021f0:	55                   	push   %ebp
  return namex(path, 1, name);
801021f1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021f6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021fe:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021ff:	e9 bc fc ff ff       	jmp    80101ec0 <namex>
80102204:	66 90                	xchg   %ax,%ax
80102206:	66 90                	xchg   %ax,%ax
80102208:	66 90                	xchg   %ax,%ax
8010220a:	66 90                	xchg   %ax,%ax
8010220c:	66 90                	xchg   %ax,%ax
8010220e:	66 90                	xchg   %ax,%ax

80102210 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	57                   	push   %edi
80102214:	56                   	push   %esi
80102215:	53                   	push   %ebx
80102216:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102219:	85 c0                	test   %eax,%eax
8010221b:	0f 84 b4 00 00 00    	je     801022d5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102221:	8b 70 08             	mov    0x8(%eax),%esi
80102224:	89 c3                	mov    %eax,%ebx
80102226:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010222c:	0f 87 96 00 00 00    	ja     801022c8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102232:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223e:	66 90                	xchg   %ax,%ax
80102240:	89 ca                	mov    %ecx,%edx
80102242:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102243:	83 e0 c0             	and    $0xffffffc0,%eax
80102246:	3c 40                	cmp    $0x40,%al
80102248:	75 f6                	jne    80102240 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010224a:	31 ff                	xor    %edi,%edi
8010224c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102251:	89 f8                	mov    %edi,%eax
80102253:	ee                   	out    %al,(%dx)
80102254:	b8 01 00 00 00       	mov    $0x1,%eax
80102259:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010225e:	ee                   	out    %al,(%dx)
8010225f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102264:	89 f0                	mov    %esi,%eax
80102266:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102267:	89 f0                	mov    %esi,%eax
80102269:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010226e:	c1 f8 08             	sar    $0x8,%eax
80102271:	ee                   	out    %al,(%dx)
80102272:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102277:	89 f8                	mov    %edi,%eax
80102279:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010227a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010227e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102283:	c1 e0 04             	shl    $0x4,%eax
80102286:	83 e0 10             	and    $0x10,%eax
80102289:	83 c8 e0             	or     $0xffffffe0,%eax
8010228c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010228d:	f6 03 04             	testb  $0x4,(%ebx)
80102290:	75 16                	jne    801022a8 <idestart+0x98>
80102292:	b8 20 00 00 00       	mov    $0x20,%eax
80102297:	89 ca                	mov    %ecx,%edx
80102299:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010229a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010229d:	5b                   	pop    %ebx
8010229e:	5e                   	pop    %esi
8010229f:	5f                   	pop    %edi
801022a0:	5d                   	pop    %ebp
801022a1:	c3                   	ret    
801022a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022a8:	b8 30 00 00 00       	mov    $0x30,%eax
801022ad:	89 ca                	mov    %ecx,%edx
801022af:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801022b0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801022b5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801022b8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022bd:	fc                   	cld    
801022be:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret    
    panic("incorrect blockno");
801022c8:	83 ec 0c             	sub    $0xc,%esp
801022cb:	68 d4 78 10 80       	push   $0x801078d4
801022d0:	e8 ab e0 ff ff       	call   80100380 <panic>
    panic("idestart");
801022d5:	83 ec 0c             	sub    $0xc,%esp
801022d8:	68 cb 78 10 80       	push   $0x801078cb
801022dd:	e8 9e e0 ff ff       	call   80100380 <panic>
801022e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022f0 <ideinit>:
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022f6:	68 e6 78 10 80       	push   $0x801078e6
801022fb:	68 00 26 11 80       	push   $0x80112600
80102300:	e8 8b 23 00 00       	call   80104690 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102305:	58                   	pop    %eax
80102306:	a1 a4 a7 14 80       	mov    0x8014a7a4,%eax
8010230b:	5a                   	pop    %edx
8010230c:	83 e8 01             	sub    $0x1,%eax
8010230f:	50                   	push   %eax
80102310:	6a 0e                	push   $0xe
80102312:	e8 99 02 00 00       	call   801025b0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102317:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010231a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010231f:	90                   	nop
80102320:	ec                   	in     (%dx),%al
80102321:	83 e0 c0             	and    $0xffffffc0,%eax
80102324:	3c 40                	cmp    $0x40,%al
80102326:	75 f8                	jne    80102320 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102328:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010232d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102332:	ee                   	out    %al,(%dx)
80102333:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102338:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010233d:	eb 06                	jmp    80102345 <ideinit+0x55>
8010233f:	90                   	nop
  for(i=0; i<1000; i++){
80102340:	83 e9 01             	sub    $0x1,%ecx
80102343:	74 0f                	je     80102354 <ideinit+0x64>
80102345:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102346:	84 c0                	test   %al,%al
80102348:	74 f6                	je     80102340 <ideinit+0x50>
      havedisk1 = 1;
8010234a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102351:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102354:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102359:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010235e:	ee                   	out    %al,(%dx)
}
8010235f:	c9                   	leave  
80102360:	c3                   	ret    
80102361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236f:	90                   	nop

80102370 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	57                   	push   %edi
80102374:	56                   	push   %esi
80102375:	53                   	push   %ebx
80102376:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102379:	68 00 26 11 80       	push   $0x80112600
8010237e:	e8 1d 24 00 00       	call   801047a0 <acquire>

  if((b = idequeue) == 0){
80102383:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102389:	83 c4 10             	add    $0x10,%esp
8010238c:	85 db                	test   %ebx,%ebx
8010238e:	74 63                	je     801023f3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102390:	8b 43 58             	mov    0x58(%ebx),%eax
80102393:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102398:	8b 33                	mov    (%ebx),%esi
8010239a:	f7 c6 04 00 00 00    	test   $0x4,%esi
801023a0:	75 2f                	jne    801023d1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023a2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ae:	66 90                	xchg   %ax,%ax
801023b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023b1:	89 c1                	mov    %eax,%ecx
801023b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801023b6:	80 f9 40             	cmp    $0x40,%cl
801023b9:	75 f5                	jne    801023b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801023bb:	a8 21                	test   $0x21,%al
801023bd:	75 12                	jne    801023d1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801023bf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801023c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801023c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023cc:	fc                   	cld    
801023cd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801023cf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801023d1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801023d4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801023d7:	83 ce 02             	or     $0x2,%esi
801023da:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801023dc:	53                   	push   %ebx
801023dd:	e8 fe 1f 00 00       	call   801043e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023e2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801023e7:	83 c4 10             	add    $0x10,%esp
801023ea:	85 c0                	test   %eax,%eax
801023ec:	74 05                	je     801023f3 <ideintr+0x83>
    idestart(idequeue);
801023ee:	e8 1d fe ff ff       	call   80102210 <idestart>
    release(&idelock);
801023f3:	83 ec 0c             	sub    $0xc,%esp
801023f6:	68 00 26 11 80       	push   $0x80112600
801023fb:	e8 c0 24 00 00       	call   801048c0 <release>

  release(&idelock);
}
80102400:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102403:	5b                   	pop    %ebx
80102404:	5e                   	pop    %esi
80102405:	5f                   	pop    %edi
80102406:	5d                   	pop    %ebp
80102407:	c3                   	ret    
80102408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010240f:	90                   	nop

80102410 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	53                   	push   %ebx
80102414:	83 ec 10             	sub    $0x10,%esp
80102417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010241a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010241d:	50                   	push   %eax
8010241e:	e8 3d 22 00 00       	call   80104660 <holdingsleep>
80102423:	83 c4 10             	add    $0x10,%esp
80102426:	85 c0                	test   %eax,%eax
80102428:	0f 84 c3 00 00 00    	je     801024f1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010242e:	8b 03                	mov    (%ebx),%eax
80102430:	83 e0 06             	and    $0x6,%eax
80102433:	83 f8 02             	cmp    $0x2,%eax
80102436:	0f 84 a8 00 00 00    	je     801024e4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010243c:	8b 53 04             	mov    0x4(%ebx),%edx
8010243f:	85 d2                	test   %edx,%edx
80102441:	74 0d                	je     80102450 <iderw+0x40>
80102443:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102448:	85 c0                	test   %eax,%eax
8010244a:	0f 84 87 00 00 00    	je     801024d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102450:	83 ec 0c             	sub    $0xc,%esp
80102453:	68 00 26 11 80       	push   $0x80112600
80102458:	e8 43 23 00 00       	call   801047a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010245d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102462:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102469:	83 c4 10             	add    $0x10,%esp
8010246c:	85 c0                	test   %eax,%eax
8010246e:	74 60                	je     801024d0 <iderw+0xc0>
80102470:	89 c2                	mov    %eax,%edx
80102472:	8b 40 58             	mov    0x58(%eax),%eax
80102475:	85 c0                	test   %eax,%eax
80102477:	75 f7                	jne    80102470 <iderw+0x60>
80102479:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010247c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010247e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102484:	74 3a                	je     801024c0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102486:	8b 03                	mov    (%ebx),%eax
80102488:	83 e0 06             	and    $0x6,%eax
8010248b:	83 f8 02             	cmp    $0x2,%eax
8010248e:	74 1b                	je     801024ab <iderw+0x9b>
    sleep(b, &idelock);
80102490:	83 ec 08             	sub    $0x8,%esp
80102493:	68 00 26 11 80       	push   $0x80112600
80102498:	53                   	push   %ebx
80102499:	e8 82 1e 00 00       	call   80104320 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010249e:	8b 03                	mov    (%ebx),%eax
801024a0:	83 c4 10             	add    $0x10,%esp
801024a3:	83 e0 06             	and    $0x6,%eax
801024a6:	83 f8 02             	cmp    $0x2,%eax
801024a9:	75 e5                	jne    80102490 <iderw+0x80>
  }


  release(&idelock);
801024ab:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
801024b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024b5:	c9                   	leave  
  release(&idelock);
801024b6:	e9 05 24 00 00       	jmp    801048c0 <release>
801024bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024bf:	90                   	nop
    idestart(b);
801024c0:	89 d8                	mov    %ebx,%eax
801024c2:	e8 49 fd ff ff       	call   80102210 <idestart>
801024c7:	eb bd                	jmp    80102486 <iderw+0x76>
801024c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024d0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801024d5:	eb a5                	jmp    8010247c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801024d7:	83 ec 0c             	sub    $0xc,%esp
801024da:	68 15 79 10 80       	push   $0x80107915
801024df:	e8 9c de ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801024e4:	83 ec 0c             	sub    $0xc,%esp
801024e7:	68 00 79 10 80       	push   $0x80107900
801024ec:	e8 8f de ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801024f1:	83 ec 0c             	sub    $0xc,%esp
801024f4:	68 ea 78 10 80       	push   $0x801078ea
801024f9:	e8 82 de ff ff       	call   80100380 <panic>
801024fe:	66 90                	xchg   %ax,%ax

80102500 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102500:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102501:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102508:	00 c0 fe 
{
8010250b:	89 e5                	mov    %esp,%ebp
8010250d:	56                   	push   %esi
8010250e:	53                   	push   %ebx
  ioapic->reg = reg;
8010250f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102516:	00 00 00 
  return ioapic->data;
80102519:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010251f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102522:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102528:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010252e:	0f b6 15 a0 a7 14 80 	movzbl 0x8014a7a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102535:	c1 ee 10             	shr    $0x10,%esi
80102538:	89 f0                	mov    %esi,%eax
8010253a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010253d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102540:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102543:	39 c2                	cmp    %eax,%edx
80102545:	74 16                	je     8010255d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102547:	83 ec 0c             	sub    $0xc,%esp
8010254a:	68 34 79 10 80       	push   $0x80107934
8010254f:	e8 2c e1 ff ff       	call   80100680 <cprintf>
  ioapic->reg = reg;
80102554:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010255a:	83 c4 10             	add    $0x10,%esp
8010255d:	83 c6 21             	add    $0x21,%esi
{
80102560:	ba 10 00 00 00       	mov    $0x10,%edx
80102565:	b8 20 00 00 00       	mov    $0x20,%eax
8010256a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102570:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102572:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102574:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010257a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010257d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102583:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102586:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102589:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010258c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010258e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102594:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010259b:	39 f0                	cmp    %esi,%eax
8010259d:	75 d1                	jne    80102570 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010259f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a2:	5b                   	pop    %ebx
801025a3:	5e                   	pop    %esi
801025a4:	5d                   	pop    %ebp
801025a5:	c3                   	ret    
801025a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ad:	8d 76 00             	lea    0x0(%esi),%esi

801025b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801025b0:	55                   	push   %ebp
  ioapic->reg = reg;
801025b1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801025b7:	89 e5                	mov    %esp,%ebp
801025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801025bc:	8d 50 20             	lea    0x20(%eax),%edx
801025bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801025c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025c5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025d6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025db:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025de:	89 50 10             	mov    %edx,0x10(%eax)
}
801025e1:	5d                   	pop    %ebp
801025e2:	c3                   	ret    
801025e3:	66 90                	xchg   %ax,%ax
801025e5:	66 90                	xchg   %ax,%ax
801025e7:	66 90                	xchg   %ax,%ax
801025e9:	66 90                	xchg   %ax,%ax
801025eb:	66 90                	xchg   %ax,%ax
801025ed:	66 90                	xchg   %ax,%ax
801025ef:	90                   	nop

801025f0 <icount>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void icount(uint pa, int inc)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
801025f4:	53                   	push   %ebx
801025f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801025f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(PHYSTOP <= pa || (uint)V2P(end) > pa)
801025fb:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102601:	77 52                	ja     80102655 <icount+0x65>
80102603:	81 fb 10 e5 14 00    	cmp    $0x14e510,%ebx
80102609:	72 4a                	jb     80102655 <icount+0x65>
    panic("Increaseframes");  

  acquire(&kmem.lock);
8010260b:	83 ec 0c             	sub    $0xc,%esp
8010260e:	68 60 26 11 80       	push   $0x80112660
80102613:	e8 88 21 00 00       	call   801047a0 <acquire>
   if(inc == 1){
80102618:	83 c4 10             	add    $0x10,%esp
8010261b:	83 fe 01             	cmp    $0x1,%esi
8010261e:	74 28                	je     80102648 <icount+0x58>
    page_framec[pa >> PGSHIFT] = page_framec[pa >> PGSHIFT] + 1;
   }
   if(inc == 0){
80102620:	85 f6                	test   %esi,%esi
80102622:	75 0b                	jne    8010262f <icount+0x3f>
     page_framec[pa >> PGSHIFT] = page_framec[pa >> PGSHIFT] - 1;
80102624:	c1 eb 0c             	shr    $0xc,%ebx
80102627:	83 2c 9d a0 26 11 80 	subl   $0x1,-0x7feed960(,%ebx,4)
8010262e:	01 
   }
  release(&kmem.lock);
8010262f:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102636:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102639:	5b                   	pop    %ebx
8010263a:	5e                   	pop    %esi
8010263b:	5d                   	pop    %ebp
  release(&kmem.lock);
8010263c:	e9 7f 22 00 00       	jmp    801048c0 <release>
80102641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    page_framec[pa >> PGSHIFT] = page_framec[pa >> PGSHIFT] + 1;
80102648:	c1 eb 0c             	shr    $0xc,%ebx
8010264b:	83 04 9d a0 26 11 80 	addl   $0x1,-0x7feed960(,%ebx,4)
80102652:	01 
   if(inc == 0){
80102653:	eb da                	jmp    8010262f <icount+0x3f>
    panic("Increaseframes");  
80102655:	83 ec 0c             	sub    $0xc,%esp
80102658:	68 66 79 10 80       	push   $0x80107966
8010265d:	e8 1e dd ff ff       	call   80100380 <panic>
80102662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102670 <fcount>:

uint fcount(uint pa)
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	53                   	push   %ebx
80102674:	83 ec 04             	sub    $0x4,%esp
80102677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(PHYSTOP <= pa || (uint)V2P(end) > pa)
8010267a:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102680:	77 32                	ja     801026b4 <fcount+0x44>
80102682:	81 fb 10 e5 14 00    	cmp    $0x14e510,%ebx
80102688:	72 2a                	jb     801026b4 <fcount+0x44>
    panic("Retriveframes"); 

  uint frame;
  acquire(&kmem.lock);
8010268a:	83 ec 0c             	sub    $0xc,%esp
  frame = page_framec[pa >> PGSHIFT];
8010268d:	c1 eb 0c             	shr    $0xc,%ebx
  acquire(&kmem.lock);
80102690:	68 60 26 11 80       	push   $0x80112660
80102695:	e8 06 21 00 00       	call   801047a0 <acquire>
  frame = page_framec[pa >> PGSHIFT];
8010269a:	8b 1c 9d a0 26 11 80 	mov    -0x7feed960(,%ebx,4),%ebx
  release(&kmem.lock);
801026a1:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801026a8:	e8 13 22 00 00       	call   801048c0 <release>

  return frame;
} 
801026ad:	89 d8                	mov    %ebx,%eax
801026af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026b2:	c9                   	leave  
801026b3:	c3                   	ret    
    panic("Retriveframes"); 
801026b4:	83 ec 0c             	sub    $0xc,%esp
801026b7:	68 75 79 10 80       	push   $0x80107975
801026bc:	e8 bf dc ff ff       	call   80100380 <panic>
801026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026cf:	90                   	nop

801026d0 <kfree>:

void
kfree(char *v)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	56                   	push   %esi
801026d4:	8b 75 08             	mov    0x8(%ebp),%esi
801026d7:	53                   	push   %ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026d8:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
801026de:	0f 85 b9 00 00 00    	jne    8010279d <kfree+0xcd>
801026e4:	81 fe 10 e5 14 80    	cmp    $0x8014e510,%esi
801026ea:	0f 82 ad 00 00 00    	jb     8010279d <kfree+0xcd>
801026f0:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
801026f6:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801026fc:	0f 87 9b 00 00 00    	ja     8010279d <kfree+0xcd>
    panic("kfree");

  if(kmem.use_lock)
80102702:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102708:	85 d2                	test   %edx,%edx
8010270a:	75 7c                	jne    80102788 <kfree+0xb8>
    acquire(&kmem.lock);
  r = (struct run*)v;
  if(page_framec[V2P(v) >> PGSHIFT] > 0)         
8010270c:	c1 eb 0c             	shr    $0xc,%ebx
8010270f:	8b 04 9d a0 26 11 80 	mov    -0x7feed960(,%ebx,4),%eax
80102716:	85 c0                	test   %eax,%eax
80102718:	74 26                	je     80102740 <kfree+0x70>
    page_framec[V2P(v) >> PGSHIFT] = page_framec[V2P(v) >> PGSHIFT] - 1;
8010271a:	83 e8 01             	sub    $0x1,%eax
8010271d:	89 04 9d a0 26 11 80 	mov    %eax,-0x7feed960(,%ebx,4)

  if(page_framec[V2P(v) >> PGSHIFT] == 0){      
80102724:	74 1a                	je     80102740 <kfree+0x70>
  memset(v, 1, PGSIZE);
  r->next = kmem.freelist;
  kmem.freelist = r;
  free_frame_cnt++; // xv6 proj - cow
  }
  if(kmem.use_lock)
80102726:	a1 94 26 11 80       	mov    0x80112694,%eax
8010272b:	85 c0                	test   %eax,%eax
8010272d:	75 41                	jne    80102770 <kfree+0xa0>
    release(&kmem.lock);
}
8010272f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102732:	5b                   	pop    %ebx
80102733:	5e                   	pop    %esi
80102734:	5d                   	pop    %ebp
80102735:	c3                   	ret    
80102736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273d:	8d 76 00             	lea    0x0(%esi),%esi
  memset(v, 1, PGSIZE);
80102740:	83 ec 04             	sub    $0x4,%esp
80102743:	68 00 10 00 00       	push   $0x1000
80102748:	6a 01                	push   $0x1
8010274a:	56                   	push   %esi
8010274b:	e8 c0 21 00 00       	call   80104910 <memset>
  r->next = kmem.freelist;
80102750:	a1 98 26 11 80       	mov    0x80112698,%eax
  free_frame_cnt++; // xv6 proj - cow
80102755:	83 c4 10             	add    $0x10,%esp
  r->next = kmem.freelist;
80102758:	89 06                	mov    %eax,(%esi)
  if(kmem.use_lock)
8010275a:	a1 94 26 11 80       	mov    0x80112694,%eax
  free_frame_cnt++; // xv6 proj - cow
8010275f:	83 05 40 26 11 80 01 	addl   $0x1,0x80112640
  kmem.freelist = r;
80102766:	89 35 98 26 11 80    	mov    %esi,0x80112698
  if(kmem.use_lock)
8010276c:	85 c0                	test   %eax,%eax
8010276e:	74 bf                	je     8010272f <kfree+0x5f>
    release(&kmem.lock);
80102770:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102777:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010277a:	5b                   	pop    %ebx
8010277b:	5e                   	pop    %esi
8010277c:	5d                   	pop    %ebp
    release(&kmem.lock);
8010277d:	e9 3e 21 00 00       	jmp    801048c0 <release>
80102782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102788:	83 ec 0c             	sub    $0xc,%esp
8010278b:	68 60 26 11 80       	push   $0x80112660
80102790:	e8 0b 20 00 00       	call   801047a0 <acquire>
80102795:	83 c4 10             	add    $0x10,%esp
80102798:	e9 6f ff ff ff       	jmp    8010270c <kfree+0x3c>
    panic("kfree");
8010279d:	83 ec 0c             	sub    $0xc,%esp
801027a0:	68 83 79 10 80       	push   $0x80107983
801027a5:	e8 d6 db ff ff       	call   80100380 <panic>
801027aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027b0 <freerange>:
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801027b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801027ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801027c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027cd:	39 de                	cmp    %ebx,%esi
801027cf:	72 37                	jb     80102808 <freerange+0x58>
801027d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    page_framec[V2P(p) >> PGSHIFT] = 0;
801027d8:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
801027de:	83 ec 0c             	sub    $0xc,%esp
    page_framec[V2P(p) >> PGSHIFT] = 0;
801027e1:	c1 e8 0c             	shr    $0xc,%eax
801027e4:	c7 04 85 a0 26 11 80 	movl   $0x0,-0x7feed960(,%eax,4)
801027eb:	00 00 00 00 
    kfree(p);
801027ef:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801027f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027fb:	50                   	push   %eax
801027fc:	e8 cf fe ff ff       	call   801026d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102801:	83 c4 10             	add    $0x10,%esp
80102804:	39 f3                	cmp    %esi,%ebx
80102806:	76 d0                	jbe    801027d8 <freerange+0x28>
}
80102808:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010280b:	5b                   	pop    %ebx
8010280c:	5e                   	pop    %esi
8010280d:	5d                   	pop    %ebp
8010280e:	c3                   	ret    
8010280f:	90                   	nop

80102810 <kinit2>:
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102814:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102817:	8b 75 0c             	mov    0xc(%ebp),%esi
8010281a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010281b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102821:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102827:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010282d:	39 de                	cmp    %ebx,%esi
8010282f:	72 37                	jb     80102868 <kinit2+0x58>
80102831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    page_framec[V2P(p) >> PGSHIFT] = 0;
80102838:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
8010283e:	83 ec 0c             	sub    $0xc,%esp
    page_framec[V2P(p) >> PGSHIFT] = 0;
80102841:	c1 e8 0c             	shr    $0xc,%eax
80102844:	c7 04 85 a0 26 11 80 	movl   $0x0,-0x7feed960(,%eax,4)
8010284b:	00 00 00 00 
    kfree(p);
8010284f:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102855:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010285b:	50                   	push   %eax
8010285c:	e8 6f fe ff ff       	call   801026d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102861:	83 c4 10             	add    $0x10,%esp
80102864:	39 de                	cmp    %ebx,%esi
80102866:	73 d0                	jae    80102838 <kinit2+0x28>
  kmem.use_lock = 1;
80102868:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010286f:	00 00 00 
}
80102872:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102875:	5b                   	pop    %ebx
80102876:	5e                   	pop    %esi
80102877:	5d                   	pop    %ebp
80102878:	c3                   	ret    
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102880 <kinit1>:
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	56                   	push   %esi
80102884:	53                   	push   %ebx
80102885:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102888:	83 ec 08             	sub    $0x8,%esp
8010288b:	68 89 79 10 80       	push   $0x80107989
80102890:	68 60 26 11 80       	push   $0x80112660
80102895:	e8 f6 1d 00 00       	call   80104690 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010289a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010289d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801028a0:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801028a7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801028aa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028bc:	39 de                	cmp    %ebx,%esi
801028be:	72 30                	jb     801028f0 <kinit1+0x70>
    page_framec[V2P(p) >> PGSHIFT] = 0;
801028c0:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
801028c6:	83 ec 0c             	sub    $0xc,%esp
    page_framec[V2P(p) >> PGSHIFT] = 0;
801028c9:	c1 e8 0c             	shr    $0xc,%eax
801028cc:	c7 04 85 a0 26 11 80 	movl   $0x0,-0x7feed960(,%eax,4)
801028d3:	00 00 00 00 
    kfree(p);
801028d7:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028e3:	50                   	push   %eax
801028e4:	e8 e7 fd ff ff       	call   801026d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028e9:	83 c4 10             	add    $0x10,%esp
801028ec:	39 de                	cmp    %ebx,%esi
801028ee:	73 d0                	jae    801028c0 <kinit1+0x40>
}
801028f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f3:	5b                   	pop    %ebx
801028f4:	5e                   	pop    %esi
801028f5:	5d                   	pop    %ebp
801028f6:	c3                   	ret    
801028f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fe:	66 90                	xchg   %ax,%ax

80102900 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102906:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010290c:	85 d2                	test   %edx,%edx
8010290e:	75 50                	jne    80102960 <kalloc+0x60>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102910:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
80102915:	85 c0                	test   %eax,%eax
80102917:	74 27                	je     80102940 <kalloc+0x40>
  {
    page_framec[V2P((char*)r) >> PGSHIFT] = 1; 
80102919:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010291f:	c1 e9 0c             	shr    $0xc,%ecx
80102922:	c7 04 8d a0 26 11 80 	movl   $0x1,-0x7feed960(,%ecx,4)
80102929:	01 00 00 00 
    kmem.freelist = r->next;
8010292d:	8b 08                	mov    (%eax),%ecx
	  free_frame_cnt--; // xv6 proj - cow
8010292f:	83 2d 40 26 11 80 01 	subl   $0x1,0x80112640
    kmem.freelist = r->next;
80102936:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  }
  if(kmem.use_lock)
8010293c:	85 d2                	test   %edx,%edx
8010293e:	75 08                	jne    80102948 <kalloc+0x48>
    release(&kmem.lock);
  return (char*)r;
}
80102940:	c9                   	leave  
80102941:	c3                   	ret    
80102942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102948:	83 ec 0c             	sub    $0xc,%esp
8010294b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010294e:	68 60 26 11 80       	push   $0x80112660
80102953:	e8 68 1f 00 00       	call   801048c0 <release>
  return (char*)r;
80102958:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
8010295b:	83 c4 10             	add    $0x10,%esp
}
8010295e:	c9                   	leave  
8010295f:	c3                   	ret    
    acquire(&kmem.lock);
80102960:	83 ec 0c             	sub    $0xc,%esp
80102963:	68 60 26 11 80       	push   $0x80112660
80102968:	e8 33 1e 00 00       	call   801047a0 <acquire>
  r = kmem.freelist;
8010296d:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(kmem.use_lock)
80102972:	8b 15 94 26 11 80    	mov    0x80112694,%edx
  if(r)
80102978:	83 c4 10             	add    $0x10,%esp
8010297b:	85 c0                	test   %eax,%eax
8010297d:	75 9a                	jne    80102919 <kalloc+0x19>
8010297f:	eb bb                	jmp    8010293c <kalloc+0x3c>
80102981:	66 90                	xchg   %ax,%ax
80102983:	66 90                	xchg   %ax,%ax
80102985:	66 90                	xchg   %ax,%ax
80102987:	66 90                	xchg   %ax,%ax
80102989:	66 90                	xchg   %ax,%ax
8010298b:	66 90                	xchg   %ax,%ax
8010298d:	66 90                	xchg   %ax,%ax
8010298f:	90                   	nop

80102990 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102990:	ba 64 00 00 00       	mov    $0x64,%edx
80102995:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102996:	a8 01                	test   $0x1,%al
80102998:	0f 84 ca 00 00 00    	je     80102a68 <kbdgetc+0xd8>
{
8010299e:	55                   	push   %ebp
8010299f:	ba 60 00 00 00       	mov    $0x60,%edx
801029a4:	89 e5                	mov    %esp,%ebp
801029a6:	53                   	push   %ebx
801029a7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801029a8:	8b 1d a0 a6 14 80    	mov    0x8014a6a0,%ebx
  data = inb(KBDATAP);
801029ae:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801029b1:	3c e0                	cmp    $0xe0,%al
801029b3:	74 5b                	je     80102a10 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801029b5:	89 da                	mov    %ebx,%edx
801029b7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801029ba:	84 c0                	test   %al,%al
801029bc:	78 62                	js     80102a20 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801029be:	85 d2                	test   %edx,%edx
801029c0:	74 09                	je     801029cb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801029c2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801029c5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801029c8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801029cb:	0f b6 91 c0 7a 10 80 	movzbl -0x7fef8540(%ecx),%edx
  shift ^= togglecode[data];
801029d2:	0f b6 81 c0 79 10 80 	movzbl -0x7fef8640(%ecx),%eax
  shift |= shiftcode[data];
801029d9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801029db:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801029dd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801029df:	89 15 a0 a6 14 80    	mov    %edx,0x8014a6a0
  c = charcode[shift & (CTL | SHIFT)][data];
801029e5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801029e8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801029eb:	8b 04 85 a0 79 10 80 	mov    -0x7fef8660(,%eax,4),%eax
801029f2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801029f6:	74 0b                	je     80102a03 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801029f8:	8d 50 9f             	lea    -0x61(%eax),%edx
801029fb:	83 fa 19             	cmp    $0x19,%edx
801029fe:	77 50                	ja     80102a50 <kbdgetc+0xc0>
      c += 'A' - 'a';
80102a00:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a06:	c9                   	leave  
80102a07:	c3                   	ret    
80102a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a0f:	90                   	nop
    shift |= E0ESC;
80102a10:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102a13:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a15:	89 1d a0 a6 14 80    	mov    %ebx,0x8014a6a0
}
80102a1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a1e:	c9                   	leave  
80102a1f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102a20:	83 e0 7f             	and    $0x7f,%eax
80102a23:	85 d2                	test   %edx,%edx
80102a25:	0f 44 c8             	cmove  %eax,%ecx
    return 0;
80102a28:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102a2a:	0f b6 91 c0 7a 10 80 	movzbl -0x7fef8540(%ecx),%edx
80102a31:	83 ca 40             	or     $0x40,%edx
80102a34:	0f b6 d2             	movzbl %dl,%edx
80102a37:	f7 d2                	not    %edx
80102a39:	21 da                	and    %ebx,%edx
}
80102a3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102a3e:	89 15 a0 a6 14 80    	mov    %edx,0x8014a6a0
}
80102a44:	c9                   	leave  
80102a45:	c3                   	ret    
80102a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a4d:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102a50:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102a53:	8d 50 20             	lea    0x20(%eax),%edx
}
80102a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a59:	c9                   	leave  
      c += 'a' - 'A';
80102a5a:	83 f9 1a             	cmp    $0x1a,%ecx
80102a5d:	0f 42 c2             	cmovb  %edx,%eax
}
80102a60:	c3                   	ret    
80102a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102a6d:	c3                   	ret    
80102a6e:	66 90                	xchg   %ax,%ax

80102a70 <kbdintr>:

void
kbdintr(void)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a76:	68 90 29 10 80       	push   $0x80102990
80102a7b:	e8 70 de ff ff       	call   801008f0 <consoleintr>
}
80102a80:	83 c4 10             	add    $0x10,%esp
80102a83:	c9                   	leave  
80102a84:	c3                   	ret    
80102a85:	66 90                	xchg   %ax,%ax
80102a87:	66 90                	xchg   %ax,%ax
80102a89:	66 90                	xchg   %ax,%ax
80102a8b:	66 90                	xchg   %ax,%ax
80102a8d:	66 90                	xchg   %ax,%ax
80102a8f:	90                   	nop

80102a90 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a90:	a1 a4 a6 14 80       	mov    0x8014a6a4,%eax
80102a95:	85 c0                	test   %eax,%eax
80102a97:	0f 84 cb 00 00 00    	je     80102b68 <lapicinit+0xd8>
  lapic[index] = value;
80102a9d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102aa4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aaa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ab1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ab7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102abe:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ac4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102acb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ace:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ad1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102ad8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102adb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ade:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ae5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102aeb:	8b 50 30             	mov    0x30(%eax),%edx
80102aee:	c1 ea 10             	shr    $0x10,%edx
80102af1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102af7:	75 77                	jne    80102b70 <lapicinit+0xe0>
  lapic[index] = value;
80102af9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b03:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b06:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b0d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b10:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b13:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b1a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b1d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b20:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b27:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b2a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b2d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b3a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b41:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102b44:	8b 50 20             	mov    0x20(%eax),%edx
80102b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b4e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102b50:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102b56:	80 e6 10             	and    $0x10,%dh
80102b59:	75 f5                	jne    80102b50 <lapicinit+0xc0>
  lapic[index] = value;
80102b5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b62:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b65:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102b68:	c3                   	ret    
80102b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102b70:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b77:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102b7d:	e9 77 ff ff ff       	jmp    80102af9 <lapicinit+0x69>
80102b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b90 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b90:	a1 a4 a6 14 80       	mov    0x8014a6a4,%eax
80102b95:	85 c0                	test   %eax,%eax
80102b97:	74 07                	je     80102ba0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102b99:	8b 40 20             	mov    0x20(%eax),%eax
80102b9c:	c1 e8 18             	shr    $0x18,%eax
80102b9f:	c3                   	ret    
    return 0;
80102ba0:	31 c0                	xor    %eax,%eax
}
80102ba2:	c3                   	ret    
80102ba3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102bb0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102bb0:	a1 a4 a6 14 80       	mov    0x8014a6a4,%eax
80102bb5:	85 c0                	test   %eax,%eax
80102bb7:	74 0d                	je     80102bc6 <lapiceoi+0x16>
  lapic[index] = value;
80102bb9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102bc0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102bc6:	c3                   	ret    
80102bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102bd0:	c3                   	ret    
80102bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bdf:	90                   	nop

80102be0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102be0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102be6:	ba 70 00 00 00       	mov    $0x70,%edx
80102beb:	89 e5                	mov    %esp,%ebp
80102bed:	53                   	push   %ebx
80102bee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102bf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102bf4:	ee                   	out    %al,(%dx)
80102bf5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bfa:	ba 71 00 00 00       	mov    $0x71,%edx
80102bff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c00:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c02:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c05:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c0b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c0d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102c10:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102c12:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c15:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c18:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c1e:	a1 a4 a6 14 80       	mov    0x8014a6a4,%eax
80102c23:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c29:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c2c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c33:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c36:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c39:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c40:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c43:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c46:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c4c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c4f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c55:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c58:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c61:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c67:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102c6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c6d:	c9                   	leave  
80102c6e:	c3                   	ret    
80102c6f:	90                   	nop

80102c70 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102c70:	55                   	push   %ebp
80102c71:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c76:	ba 70 00 00 00       	mov    $0x70,%edx
80102c7b:	89 e5                	mov    %esp,%ebp
80102c7d:	57                   	push   %edi
80102c7e:	56                   	push   %esi
80102c7f:	53                   	push   %ebx
80102c80:	83 ec 4c             	sub    $0x4c,%esp
80102c83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c84:	ba 71 00 00 00       	mov    $0x71,%edx
80102c89:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102c8a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c8d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c92:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c95:	8d 76 00             	lea    0x0(%esi),%esi
80102c98:	31 c0                	xor    %eax,%eax
80102c9a:	89 da                	mov    %ebx,%edx
80102c9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ca2:	89 ca                	mov    %ecx,%edx
80102ca4:	ec                   	in     (%dx),%al
80102ca5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca8:	89 da                	mov    %ebx,%edx
80102caa:	b8 02 00 00 00       	mov    $0x2,%eax
80102caf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb0:	89 ca                	mov    %ecx,%edx
80102cb2:	ec                   	in     (%dx),%al
80102cb3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb6:	89 da                	mov    %ebx,%edx
80102cb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbe:	89 ca                	mov    %ecx,%edx
80102cc0:	ec                   	in     (%dx),%al
80102cc1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc4:	89 da                	mov    %ebx,%edx
80102cc6:	b8 07 00 00 00       	mov    $0x7,%eax
80102ccb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccc:	89 ca                	mov    %ecx,%edx
80102cce:	ec                   	in     (%dx),%al
80102ccf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd2:	89 da                	mov    %ebx,%edx
80102cd4:	b8 08 00 00 00       	mov    $0x8,%eax
80102cd9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cda:	89 ca                	mov    %ecx,%edx
80102cdc:	ec                   	in     (%dx),%al
80102cdd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cdf:	89 da                	mov    %ebx,%edx
80102ce1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ce6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce7:	89 ca                	mov    %ecx,%edx
80102ce9:	ec                   	in     (%dx),%al
80102cea:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cec:	89 da                	mov    %ebx,%edx
80102cee:	b8 0a 00 00 00       	mov    $0xa,%eax
80102cf3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf4:	89 ca                	mov    %ecx,%edx
80102cf6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102cf7:	84 c0                	test   %al,%al
80102cf9:	78 9d                	js     80102c98 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102cfb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102cff:	89 fa                	mov    %edi,%edx
80102d01:	0f b6 fa             	movzbl %dl,%edi
80102d04:	89 f2                	mov    %esi,%edx
80102d06:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d09:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d0d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d10:	89 da                	mov    %ebx,%edx
80102d12:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102d15:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d18:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d1c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d1f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d22:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d26:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d29:	31 c0                	xor    %eax,%eax
80102d2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2c:	89 ca                	mov    %ecx,%edx
80102d2e:	ec                   	in     (%dx),%al
80102d2f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d32:	89 da                	mov    %ebx,%edx
80102d34:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102d37:	b8 02 00 00 00       	mov    $0x2,%eax
80102d3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d3d:	89 ca                	mov    %ecx,%edx
80102d3f:	ec                   	in     (%dx),%al
80102d40:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d43:	89 da                	mov    %ebx,%edx
80102d45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102d48:	b8 04 00 00 00       	mov    $0x4,%eax
80102d4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d4e:	89 ca                	mov    %ecx,%edx
80102d50:	ec                   	in     (%dx),%al
80102d51:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d54:	89 da                	mov    %ebx,%edx
80102d56:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102d59:	b8 07 00 00 00       	mov    $0x7,%eax
80102d5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d5f:	89 ca                	mov    %ecx,%edx
80102d61:	ec                   	in     (%dx),%al
80102d62:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d65:	89 da                	mov    %ebx,%edx
80102d67:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d6a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d70:	89 ca                	mov    %ecx,%edx
80102d72:	ec                   	in     (%dx),%al
80102d73:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d76:	89 da                	mov    %ebx,%edx
80102d78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d7b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d80:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d81:	89 ca                	mov    %ecx,%edx
80102d83:	ec                   	in     (%dx),%al
80102d84:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d87:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102d8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d8d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d90:	6a 18                	push   $0x18
80102d92:	50                   	push   %eax
80102d93:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d96:	50                   	push   %eax
80102d97:	e8 c4 1b 00 00       	call   80104960 <memcmp>
80102d9c:	83 c4 10             	add    $0x10,%esp
80102d9f:	85 c0                	test   %eax,%eax
80102da1:	0f 85 f1 fe ff ff    	jne    80102c98 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102da7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102dab:	75 78                	jne    80102e25 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102dad:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102db0:	89 c2                	mov    %eax,%edx
80102db2:	83 e0 0f             	and    $0xf,%eax
80102db5:	c1 ea 04             	shr    $0x4,%edx
80102db8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dbb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dbe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102dc1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102dc4:	89 c2                	mov    %eax,%edx
80102dc6:	83 e0 0f             	and    $0xf,%eax
80102dc9:	c1 ea 04             	shr    $0x4,%edx
80102dcc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dcf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dd2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102dd5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102dd8:	89 c2                	mov    %eax,%edx
80102dda:	83 e0 0f             	and    $0xf,%eax
80102ddd:	c1 ea 04             	shr    $0x4,%edx
80102de0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102de3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102de6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102de9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dec:	89 c2                	mov    %eax,%edx
80102dee:	83 e0 0f             	and    $0xf,%eax
80102df1:	c1 ea 04             	shr    $0x4,%edx
80102df4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102df7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dfa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102dfd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e00:	89 c2                	mov    %eax,%edx
80102e02:	83 e0 0f             	and    $0xf,%eax
80102e05:	c1 ea 04             	shr    $0x4,%edx
80102e08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e0e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e11:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e14:	89 c2                	mov    %eax,%edx
80102e16:	83 e0 0f             	and    $0xf,%eax
80102e19:	c1 ea 04             	shr    $0x4,%edx
80102e1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e22:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e25:	8b 75 08             	mov    0x8(%ebp),%esi
80102e28:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e2b:	89 06                	mov    %eax,(%esi)
80102e2d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e30:	89 46 04             	mov    %eax,0x4(%esi)
80102e33:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e36:	89 46 08             	mov    %eax,0x8(%esi)
80102e39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e3c:	89 46 0c             	mov    %eax,0xc(%esi)
80102e3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e42:	89 46 10             	mov    %eax,0x10(%esi)
80102e45:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e48:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102e4b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102e52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e55:	5b                   	pop    %ebx
80102e56:	5e                   	pop    %esi
80102e57:	5f                   	pop    %edi
80102e58:	5d                   	pop    %ebp
80102e59:	c3                   	ret    
80102e5a:	66 90                	xchg   %ax,%ax
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e60:	8b 0d 08 a7 14 80    	mov    0x8014a708,%ecx
80102e66:	85 c9                	test   %ecx,%ecx
80102e68:	0f 8e 8a 00 00 00    	jle    80102ef8 <install_trans+0x98>
{
80102e6e:	55                   	push   %ebp
80102e6f:	89 e5                	mov    %esp,%ebp
80102e71:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102e72:	31 ff                	xor    %edi,%edi
{
80102e74:	56                   	push   %esi
80102e75:	53                   	push   %ebx
80102e76:	83 ec 0c             	sub    $0xc,%esp
80102e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e80:	a1 f4 a6 14 80       	mov    0x8014a6f4,%eax
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	01 f8                	add    %edi,%eax
80102e8a:	83 c0 01             	add    $0x1,%eax
80102e8d:	50                   	push   %eax
80102e8e:	ff 35 04 a7 14 80    	pushl  0x8014a704
80102e94:	e8 37 d2 ff ff       	call   801000d0 <bread>
80102e99:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e9b:	58                   	pop    %eax
80102e9c:	5a                   	pop    %edx
80102e9d:	ff 34 bd 0c a7 14 80 	pushl  -0x7feb58f4(,%edi,4)
80102ea4:	ff 35 04 a7 14 80    	pushl  0x8014a704
  for (tail = 0; tail < log.lh.n; tail++) {
80102eaa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ead:	e8 1e d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102eb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102eb5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102eb7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eba:	68 00 02 00 00       	push   $0x200
80102ebf:	50                   	push   %eax
80102ec0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102ec3:	50                   	push   %eax
80102ec4:	e8 e7 1a 00 00       	call   801049b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ec9:	89 1c 24             	mov    %ebx,(%esp)
80102ecc:	e8 df d2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102ed1:	89 34 24             	mov    %esi,(%esp)
80102ed4:	e8 17 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102ed9:	89 1c 24             	mov    %ebx,(%esp)
80102edc:	e8 0f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	39 3d 08 a7 14 80    	cmp    %edi,0x8014a708
80102eea:	7f 94                	jg     80102e80 <install_trans+0x20>
  }
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret    
80102ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ef8:	c3                   	ret    
80102ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	53                   	push   %ebx
80102f04:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f07:	ff 35 f4 a6 14 80    	pushl  0x8014a6f4
80102f0d:	ff 35 04 a7 14 80    	pushl  0x8014a704
80102f13:	e8 b8 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102f18:	8b 0d 08 a7 14 80    	mov    0x8014a708,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f1e:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f21:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102f23:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102f26:	85 c9                	test   %ecx,%ecx
80102f28:	7e 18                	jle    80102f42 <write_head+0x42>
80102f2a:	31 c0                	xor    %eax,%eax
80102f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102f30:	8b 14 85 0c a7 14 80 	mov    -0x7feb58f4(,%eax,4),%edx
80102f37:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102f3b:	83 c0 01             	add    $0x1,%eax
80102f3e:	39 c1                	cmp    %eax,%ecx
80102f40:	75 ee                	jne    80102f30 <write_head+0x30>
  }
  bwrite(buf);
80102f42:	83 ec 0c             	sub    $0xc,%esp
80102f45:	53                   	push   %ebx
80102f46:	e8 65 d2 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102f4b:	89 1c 24             	mov    %ebx,(%esp)
80102f4e:	e8 9d d2 ff ff       	call   801001f0 <brelse>
}
80102f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f56:	83 c4 10             	add    $0x10,%esp
80102f59:	c9                   	leave  
80102f5a:	c3                   	ret    
80102f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f5f:	90                   	nop

80102f60 <initlog>:
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	53                   	push   %ebx
80102f64:	83 ec 2c             	sub    $0x2c,%esp
80102f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102f6a:	68 c0 7b 10 80       	push   $0x80107bc0
80102f6f:	68 c0 a6 14 80       	push   $0x8014a6c0
80102f74:	e8 17 17 00 00       	call   80104690 <initlock>
  readsb(dev, &sb);
80102f79:	58                   	pop    %eax
80102f7a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f7d:	5a                   	pop    %edx
80102f7e:	50                   	push   %eax
80102f7f:	53                   	push   %ebx
80102f80:	e8 cb e6 ff ff       	call   80101650 <readsb>
  log.start = sb.logstart;
80102f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102f88:	59                   	pop    %ecx
  log.dev = dev;
80102f89:	89 1d 04 a7 14 80    	mov    %ebx,0x8014a704
  log.size = sb.nlog;
80102f8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f92:	a3 f4 a6 14 80       	mov    %eax,0x8014a6f4
  log.size = sb.nlog;
80102f97:	89 15 f8 a6 14 80    	mov    %edx,0x8014a6f8
  struct buf *buf = bread(log.dev, log.start);
80102f9d:	5a                   	pop    %edx
80102f9e:	50                   	push   %eax
80102f9f:	53                   	push   %ebx
80102fa0:	e8 2b d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102fa5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102fa8:	8b 58 5c             	mov    0x5c(%eax),%ebx
  struct buf *buf = bread(log.dev, log.start);
80102fab:	89 c1                	mov    %eax,%ecx
  log.lh.n = lh->n;
80102fad:	89 1d 08 a7 14 80    	mov    %ebx,0x8014a708
  for (i = 0; i < log.lh.n; i++) {
80102fb3:	85 db                	test   %ebx,%ebx
80102fb5:	7e 1b                	jle    80102fd2 <initlog+0x72>
80102fb7:	31 c0                	xor    %eax,%eax
80102fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102fc0:	8b 54 81 60          	mov    0x60(%ecx,%eax,4),%edx
80102fc4:	89 14 85 0c a7 14 80 	mov    %edx,-0x7feb58f4(,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102fcb:	83 c0 01             	add    $0x1,%eax
80102fce:	39 c3                	cmp    %eax,%ebx
80102fd0:	75 ee                	jne    80102fc0 <initlog+0x60>
  brelse(buf);
80102fd2:	83 ec 0c             	sub    $0xc,%esp
80102fd5:	51                   	push   %ecx
80102fd6:	e8 15 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102fdb:	e8 80 fe ff ff       	call   80102e60 <install_trans>
  log.lh.n = 0;
80102fe0:	c7 05 08 a7 14 80 00 	movl   $0x0,0x8014a708
80102fe7:	00 00 00 
  write_head(); // clear the log
80102fea:	e8 11 ff ff ff       	call   80102f00 <write_head>
}
80102fef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ff2:	83 c4 10             	add    $0x10,%esp
80102ff5:	c9                   	leave  
80102ff6:	c3                   	ret    
80102ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103006:	68 c0 a6 14 80       	push   $0x8014a6c0
8010300b:	e8 90 17 00 00       	call   801047a0 <acquire>
80103010:	83 c4 10             	add    $0x10,%esp
80103013:	eb 18                	jmp    8010302d <begin_op+0x2d>
80103015:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103018:	83 ec 08             	sub    $0x8,%esp
8010301b:	68 c0 a6 14 80       	push   $0x8014a6c0
80103020:	68 c0 a6 14 80       	push   $0x8014a6c0
80103025:	e8 f6 12 00 00       	call   80104320 <sleep>
8010302a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010302d:	a1 00 a7 14 80       	mov    0x8014a700,%eax
80103032:	85 c0                	test   %eax,%eax
80103034:	75 e2                	jne    80103018 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103036:	a1 fc a6 14 80       	mov    0x8014a6fc,%eax
8010303b:	8b 15 08 a7 14 80    	mov    0x8014a708,%edx
80103041:	83 c0 01             	add    $0x1,%eax
80103044:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103047:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010304a:	83 fa 1e             	cmp    $0x1e,%edx
8010304d:	7f c9                	jg     80103018 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010304f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103052:	a3 fc a6 14 80       	mov    %eax,0x8014a6fc
      release(&log.lock);
80103057:	68 c0 a6 14 80       	push   $0x8014a6c0
8010305c:	e8 5f 18 00 00       	call   801048c0 <release>
      break;
    }
  }
}
80103061:	83 c4 10             	add    $0x10,%esp
80103064:	c9                   	leave  
80103065:	c3                   	ret    
80103066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010306d:	8d 76 00             	lea    0x0(%esi),%esi

80103070 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	57                   	push   %edi
80103074:	56                   	push   %esi
80103075:	53                   	push   %ebx
80103076:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103079:	68 c0 a6 14 80       	push   $0x8014a6c0
8010307e:	e8 1d 17 00 00       	call   801047a0 <acquire>
  log.outstanding -= 1;
80103083:	a1 fc a6 14 80       	mov    0x8014a6fc,%eax
  if(log.committing)
80103088:	8b 35 00 a7 14 80    	mov    0x8014a700,%esi
8010308e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103091:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103094:	89 1d fc a6 14 80    	mov    %ebx,0x8014a6fc
  if(log.committing)
8010309a:	85 f6                	test   %esi,%esi
8010309c:	0f 85 22 01 00 00    	jne    801031c4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801030a2:	85 db                	test   %ebx,%ebx
801030a4:	0f 85 f6 00 00 00    	jne    801031a0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801030aa:	c7 05 00 a7 14 80 01 	movl   $0x1,0x8014a700
801030b1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801030b4:	83 ec 0c             	sub    $0xc,%esp
801030b7:	68 c0 a6 14 80       	push   $0x8014a6c0
801030bc:	e8 ff 17 00 00       	call   801048c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801030c1:	8b 0d 08 a7 14 80    	mov    0x8014a708,%ecx
801030c7:	83 c4 10             	add    $0x10,%esp
801030ca:	85 c9                	test   %ecx,%ecx
801030cc:	7f 42                	jg     80103110 <end_op+0xa0>
    acquire(&log.lock);
801030ce:	83 ec 0c             	sub    $0xc,%esp
801030d1:	68 c0 a6 14 80       	push   $0x8014a6c0
801030d6:	e8 c5 16 00 00       	call   801047a0 <acquire>
    wakeup(&log);
801030db:	c7 04 24 c0 a6 14 80 	movl   $0x8014a6c0,(%esp)
    log.committing = 0;
801030e2:	c7 05 00 a7 14 80 00 	movl   $0x0,0x8014a700
801030e9:	00 00 00 
    wakeup(&log);
801030ec:	e8 ef 12 00 00       	call   801043e0 <wakeup>
    release(&log.lock);
801030f1:	c7 04 24 c0 a6 14 80 	movl   $0x8014a6c0,(%esp)
801030f8:	e8 c3 17 00 00       	call   801048c0 <release>
801030fd:	83 c4 10             	add    $0x10,%esp
}
80103100:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103103:	5b                   	pop    %ebx
80103104:	5e                   	pop    %esi
80103105:	5f                   	pop    %edi
80103106:	5d                   	pop    %ebp
80103107:	c3                   	ret    
80103108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010310f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103110:	a1 f4 a6 14 80       	mov    0x8014a6f4,%eax
80103115:	83 ec 08             	sub    $0x8,%esp
80103118:	01 d8                	add    %ebx,%eax
8010311a:	83 c0 01             	add    $0x1,%eax
8010311d:	50                   	push   %eax
8010311e:	ff 35 04 a7 14 80    	pushl  0x8014a704
80103124:	e8 a7 cf ff ff       	call   801000d0 <bread>
80103129:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010312b:	58                   	pop    %eax
8010312c:	5a                   	pop    %edx
8010312d:	ff 34 9d 0c a7 14 80 	pushl  -0x7feb58f4(,%ebx,4)
80103134:	ff 35 04 a7 14 80    	pushl  0x8014a704
  for (tail = 0; tail < log.lh.n; tail++) {
8010313a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010313d:	e8 8e cf ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103142:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103145:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103147:	8d 40 5c             	lea    0x5c(%eax),%eax
8010314a:	68 00 02 00 00       	push   $0x200
8010314f:	50                   	push   %eax
80103150:	8d 46 5c             	lea    0x5c(%esi),%eax
80103153:	50                   	push   %eax
80103154:	e8 57 18 00 00       	call   801049b0 <memmove>
    bwrite(to);  // write the log
80103159:	89 34 24             	mov    %esi,(%esp)
8010315c:	e8 4f d0 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103161:	89 3c 24             	mov    %edi,(%esp)
80103164:	e8 87 d0 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103169:	89 34 24             	mov    %esi,(%esp)
8010316c:	e8 7f d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103171:	83 c4 10             	add    $0x10,%esp
80103174:	3b 1d 08 a7 14 80    	cmp    0x8014a708,%ebx
8010317a:	7c 94                	jl     80103110 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010317c:	e8 7f fd ff ff       	call   80102f00 <write_head>
    install_trans(); // Now install writes to home locations
80103181:	e8 da fc ff ff       	call   80102e60 <install_trans>
    log.lh.n = 0;
80103186:	c7 05 08 a7 14 80 00 	movl   $0x0,0x8014a708
8010318d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103190:	e8 6b fd ff ff       	call   80102f00 <write_head>
80103195:	e9 34 ff ff ff       	jmp    801030ce <end_op+0x5e>
8010319a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801031a0:	83 ec 0c             	sub    $0xc,%esp
801031a3:	68 c0 a6 14 80       	push   $0x8014a6c0
801031a8:	e8 33 12 00 00       	call   801043e0 <wakeup>
  release(&log.lock);
801031ad:	c7 04 24 c0 a6 14 80 	movl   $0x8014a6c0,(%esp)
801031b4:	e8 07 17 00 00       	call   801048c0 <release>
801031b9:	83 c4 10             	add    $0x10,%esp
}
801031bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bf:	5b                   	pop    %ebx
801031c0:	5e                   	pop    %esi
801031c1:	5f                   	pop    %edi
801031c2:	5d                   	pop    %ebp
801031c3:	c3                   	ret    
    panic("log.committing");
801031c4:	83 ec 0c             	sub    $0xc,%esp
801031c7:	68 c4 7b 10 80       	push   $0x80107bc4
801031cc:	e8 af d1 ff ff       	call   80100380 <panic>
801031d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031df:	90                   	nop

801031e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	53                   	push   %ebx
801031e4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031e7:	8b 15 08 a7 14 80    	mov    0x8014a708,%edx
{
801031ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031f0:	83 fa 1d             	cmp    $0x1d,%edx
801031f3:	0f 8f 85 00 00 00    	jg     8010327e <log_write+0x9e>
801031f9:	a1 f8 a6 14 80       	mov    0x8014a6f8,%eax
801031fe:	83 e8 01             	sub    $0x1,%eax
80103201:	39 c2                	cmp    %eax,%edx
80103203:	7d 79                	jge    8010327e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103205:	a1 fc a6 14 80       	mov    0x8014a6fc,%eax
8010320a:	85 c0                	test   %eax,%eax
8010320c:	7e 7d                	jle    8010328b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010320e:	83 ec 0c             	sub    $0xc,%esp
80103211:	68 c0 a6 14 80       	push   $0x8014a6c0
80103216:	e8 85 15 00 00       	call   801047a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010321b:	8b 15 08 a7 14 80    	mov    0x8014a708,%edx
80103221:	83 c4 10             	add    $0x10,%esp
80103224:	85 d2                	test   %edx,%edx
80103226:	7e 4a                	jle    80103272 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103228:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010322b:	31 c0                	xor    %eax,%eax
8010322d:	eb 08                	jmp    80103237 <log_write+0x57>
8010322f:	90                   	nop
80103230:	83 c0 01             	add    $0x1,%eax
80103233:	39 c2                	cmp    %eax,%edx
80103235:	74 29                	je     80103260 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103237:	39 0c 85 0c a7 14 80 	cmp    %ecx,-0x7feb58f4(,%eax,4)
8010323e:	75 f0                	jne    80103230 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103240:	89 0c 85 0c a7 14 80 	mov    %ecx,-0x7feb58f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103247:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010324a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010324d:	c7 45 08 c0 a6 14 80 	movl   $0x8014a6c0,0x8(%ebp)
}
80103254:	c9                   	leave  
  release(&log.lock);
80103255:	e9 66 16 00 00       	jmp    801048c0 <release>
8010325a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103260:	89 0c 95 0c a7 14 80 	mov    %ecx,-0x7feb58f4(,%edx,4)
    log.lh.n++;
80103267:	83 c2 01             	add    $0x1,%edx
8010326a:	89 15 08 a7 14 80    	mov    %edx,0x8014a708
80103270:	eb d5                	jmp    80103247 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103272:	8b 43 08             	mov    0x8(%ebx),%eax
80103275:	a3 0c a7 14 80       	mov    %eax,0x8014a70c
  if (i == log.lh.n)
8010327a:	75 cb                	jne    80103247 <log_write+0x67>
8010327c:	eb e9                	jmp    80103267 <log_write+0x87>
    panic("too big a transaction");
8010327e:	83 ec 0c             	sub    $0xc,%esp
80103281:	68 d3 7b 10 80       	push   $0x80107bd3
80103286:	e8 f5 d0 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010328b:	83 ec 0c             	sub    $0xc,%esp
8010328e:	68 e9 7b 10 80       	push   $0x80107be9
80103293:	e8 e8 d0 ff ff       	call   80100380 <panic>
80103298:	66 90                	xchg   %ax,%ax
8010329a:	66 90                	xchg   %ax,%ax
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	53                   	push   %ebx
801032a4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801032a7:	e8 54 09 00 00       	call   80103c00 <cpuid>
801032ac:	89 c3                	mov    %eax,%ebx
801032ae:	e8 4d 09 00 00       	call   80103c00 <cpuid>
801032b3:	83 ec 04             	sub    $0x4,%esp
801032b6:	53                   	push   %ebx
801032b7:	50                   	push   %eax
801032b8:	68 04 7c 10 80       	push   $0x80107c04
801032bd:	e8 be d3 ff ff       	call   80100680 <cprintf>
  idtinit();       // load idt register
801032c2:	e8 29 29 00 00       	call   80105bf0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801032c7:	e8 c4 08 00 00       	call   80103b90 <mycpu>
801032cc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801032ce:	b8 01 00 00 00       	mov    $0x1,%eax
801032d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801032da:	e8 21 0c 00 00       	call   80103f00 <scheduler>
801032df:	90                   	nop

801032e0 <mpenter>:
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801032e6:	e8 35 3a 00 00       	call   80106d20 <switchkvm>
  seginit();
801032eb:	e8 a0 39 00 00       	call   80106c90 <seginit>
  lapicinit();
801032f0:	e8 9b f7 ff ff       	call   80102a90 <lapicinit>
  mpmain();
801032f5:	e8 a6 ff ff ff       	call   801032a0 <mpmain>
801032fa:	66 90                	xchg   %ax,%ax
801032fc:	66 90                	xchg   %ax,%ax
801032fe:	66 90                	xchg   %ax,%ax

80103300 <main>:
{
80103300:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103304:	83 e4 f0             	and    $0xfffffff0,%esp
80103307:	ff 71 fc             	pushl  -0x4(%ecx)
8010330a:	55                   	push   %ebp
8010330b:	89 e5                	mov    %esp,%ebp
8010330d:	53                   	push   %ebx
8010330e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010330f:	83 ec 08             	sub    $0x8,%esp
80103312:	68 00 00 40 80       	push   $0x80400000
80103317:	68 10 e5 14 80       	push   $0x8014e510
8010331c:	e8 5f f5 ff ff       	call   80102880 <kinit1>
  kvmalloc();      // kernel page table
80103321:	e8 ea 3e 00 00       	call   80107210 <kvmalloc>
  mpinit();        // detect other processors
80103326:	e8 85 01 00 00       	call   801034b0 <mpinit>
  lapicinit();     // interrupt controller
8010332b:	e8 60 f7 ff ff       	call   80102a90 <lapicinit>
  seginit();       // segment descriptors
80103330:	e8 5b 39 00 00       	call   80106c90 <seginit>
  picinit();       // disable pic
80103335:	e8 76 03 00 00       	call   801036b0 <picinit>
  ioapicinit();    // another interrupt controller
8010333a:	e8 c1 f1 ff ff       	call   80102500 <ioapicinit>
  consoleinit();   // console hardware
8010333f:	e8 3c d8 ff ff       	call   80100b80 <consoleinit>
  uartinit();      // serial port
80103344:	e8 b7 2b 00 00       	call   80105f00 <uartinit>
  pinit();         // process table
80103349:	e8 22 08 00 00       	call   80103b70 <pinit>
  tvinit();        // trap vectors
8010334e:	e8 1d 28 00 00       	call   80105b70 <tvinit>
  binit();         // buffer cache
80103353:	e8 e8 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103358:	e8 d3 db ff ff       	call   80100f30 <fileinit>
  ideinit();       // disk 
8010335d:	e8 8e ef ff ff       	call   801022f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103362:	83 c4 0c             	add    $0xc,%esp
80103365:	68 8a 00 00 00       	push   $0x8a
8010336a:	68 8c b4 10 80       	push   $0x8010b48c
8010336f:	68 00 70 00 80       	push   $0x80007000
80103374:	e8 37 16 00 00       	call   801049b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	69 05 a4 a7 14 80 b0 	imul   $0xb0,0x8014a7a4,%eax
80103383:	00 00 00 
80103386:	05 c0 a7 14 80       	add    $0x8014a7c0,%eax
8010338b:	3d c0 a7 14 80       	cmp    $0x8014a7c0,%eax
80103390:	76 7e                	jbe    80103410 <main+0x110>
80103392:	bb c0 a7 14 80       	mov    $0x8014a7c0,%ebx
80103397:	eb 20                	jmp    801033b9 <main+0xb9>
80103399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033a0:	69 05 a4 a7 14 80 b0 	imul   $0xb0,0x8014a7a4,%eax
801033a7:	00 00 00 
801033aa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801033b0:	05 c0 a7 14 80       	add    $0x8014a7c0,%eax
801033b5:	39 c3                	cmp    %eax,%ebx
801033b7:	73 57                	jae    80103410 <main+0x110>
    if(c == mycpu())  // We've started already.
801033b9:	e8 d2 07 00 00       	call   80103b90 <mycpu>
801033be:	39 c3                	cmp    %eax,%ebx
801033c0:	74 de                	je     801033a0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801033c2:	e8 39 f5 ff ff       	call   80102900 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801033c7:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
801033ca:	c7 05 f8 6f 00 80 e0 	movl   $0x801032e0,0x80006ff8
801033d1:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801033d4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801033db:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801033de:	05 00 10 00 00       	add    $0x1000,%eax
801033e3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801033e8:	0f b6 03             	movzbl (%ebx),%eax
801033eb:	68 00 70 00 00       	push   $0x7000
801033f0:	50                   	push   %eax
801033f1:	e8 ea f7 ff ff       	call   80102be0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801033f6:	83 c4 10             	add    $0x10,%esp
801033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103400:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103406:	85 c0                	test   %eax,%eax
80103408:	74 f6                	je     80103400 <main+0x100>
8010340a:	eb 94                	jmp    801033a0 <main+0xa0>
8010340c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103410:	83 ec 08             	sub    $0x8,%esp
80103413:	68 00 00 00 8e       	push   $0x8e000000
80103418:	68 00 00 40 80       	push   $0x80400000
8010341d:	e8 ee f3 ff ff       	call   80102810 <kinit2>
  userinit();      // first user process
80103422:	e8 29 08 00 00       	call   80103c50 <userinit>
  mpmain();        // finish this processor's setup
80103427:	e8 74 fe ff ff       	call   801032a0 <mpmain>
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103435:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010343b:	53                   	push   %ebx
  e = addr+len;
8010343c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010343f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103442:	39 de                	cmp    %ebx,%esi
80103444:	72 10                	jb     80103456 <mpsearch1+0x26>
80103446:	eb 50                	jmp    80103498 <mpsearch1+0x68>
80103448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010344f:	90                   	nop
80103450:	89 fe                	mov    %edi,%esi
80103452:	39 fb                	cmp    %edi,%ebx
80103454:	76 42                	jbe    80103498 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103456:	83 ec 04             	sub    $0x4,%esp
80103459:	8d 7e 10             	lea    0x10(%esi),%edi
8010345c:	6a 04                	push   $0x4
8010345e:	68 18 7c 10 80       	push   $0x80107c18
80103463:	56                   	push   %esi
80103464:	e8 f7 14 00 00       	call   80104960 <memcmp>
80103469:	83 c4 10             	add    $0x10,%esp
8010346c:	89 c2                	mov    %eax,%edx
8010346e:	85 c0                	test   %eax,%eax
80103470:	75 de                	jne    80103450 <mpsearch1+0x20>
80103472:	89 f0                	mov    %esi,%eax
80103474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103478:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
8010347b:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
8010347e:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103480:	39 f8                	cmp    %edi,%eax
80103482:	75 f4                	jne    80103478 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103484:	84 d2                	test   %dl,%dl
80103486:	75 c8                	jne    80103450 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103488:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010348b:	89 f0                	mov    %esi,%eax
8010348d:	5b                   	pop    %ebx
8010348e:	5e                   	pop    %esi
8010348f:	5f                   	pop    %edi
80103490:	5d                   	pop    %ebp
80103491:	c3                   	ret    
80103492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103498:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010349b:	31 f6                	xor    %esi,%esi
}
8010349d:	5b                   	pop    %ebx
8010349e:	89 f0                	mov    %esi,%eax
801034a0:	5e                   	pop    %esi
801034a1:	5f                   	pop    %edi
801034a2:	5d                   	pop    %ebp
801034a3:	c3                   	ret    
801034a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034af:	90                   	nop

801034b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	57                   	push   %edi
801034b4:	56                   	push   %esi
801034b5:	53                   	push   %ebx
801034b6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801034b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801034c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801034c7:	c1 e0 08             	shl    $0x8,%eax
801034ca:	09 d0                	or     %edx,%eax
801034cc:	c1 e0 04             	shl    $0x4,%eax
801034cf:	75 1b                	jne    801034ec <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801034d1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801034d8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801034df:	c1 e0 08             	shl    $0x8,%eax
801034e2:	09 d0                	or     %edx,%eax
801034e4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801034e7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801034ec:	ba 00 04 00 00       	mov    $0x400,%edx
801034f1:	e8 3a ff ff ff       	call   80103430 <mpsearch1>
801034f6:	89 c3                	mov    %eax,%ebx
801034f8:	85 c0                	test   %eax,%eax
801034fa:	0f 84 40 01 00 00    	je     80103640 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103500:	8b 73 04             	mov    0x4(%ebx),%esi
80103503:	85 f6                	test   %esi,%esi
80103505:	0f 84 25 01 00 00    	je     80103630 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010350b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010350e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103514:	6a 04                	push   $0x4
80103516:	68 1d 7c 10 80       	push   $0x80107c1d
8010351b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010351c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010351f:	e8 3c 14 00 00       	call   80104960 <memcmp>
80103524:	83 c4 10             	add    $0x10,%esp
80103527:	85 c0                	test   %eax,%eax
80103529:	0f 85 01 01 00 00    	jne    80103630 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010352f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103536:	3c 01                	cmp    $0x1,%al
80103538:	74 08                	je     80103542 <mpinit+0x92>
8010353a:	3c 04                	cmp    $0x4,%al
8010353c:	0f 85 ee 00 00 00    	jne    80103630 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103542:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103549:	66 85 d2             	test   %dx,%dx
8010354c:	74 22                	je     80103570 <mpinit+0xc0>
8010354e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103551:	89 f0                	mov    %esi,%eax
  sum = 0;
80103553:	31 d2                	xor    %edx,%edx
80103555:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103558:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010355f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103562:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103564:	39 f8                	cmp    %edi,%eax
80103566:	75 f0                	jne    80103558 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103568:	84 d2                	test   %dl,%dl
8010356a:	0f 85 c0 00 00 00    	jne    80103630 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103570:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103576:	a3 a4 a6 14 80       	mov    %eax,0x8014a6a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010357b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103582:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103588:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010358d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103590:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103597:	90                   	nop
80103598:	39 d0                	cmp    %edx,%eax
8010359a:	73 15                	jae    801035b1 <mpinit+0x101>
    switch(*p){
8010359c:	0f b6 08             	movzbl (%eax),%ecx
8010359f:	80 f9 02             	cmp    $0x2,%cl
801035a2:	74 4c                	je     801035f0 <mpinit+0x140>
801035a4:	77 3a                	ja     801035e0 <mpinit+0x130>
801035a6:	84 c9                	test   %cl,%cl
801035a8:	74 56                	je     80103600 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801035aa:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035ad:	39 d0                	cmp    %edx,%eax
801035af:	72 eb                	jb     8010359c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801035b1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801035b4:	85 f6                	test   %esi,%esi
801035b6:	0f 84 d9 00 00 00    	je     80103695 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801035bc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801035c0:	74 15                	je     801035d7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035c2:	b8 70 00 00 00       	mov    $0x70,%eax
801035c7:	ba 22 00 00 00       	mov    $0x22,%edx
801035cc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035cd:	ba 23 00 00 00       	mov    $0x23,%edx
801035d2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801035d3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035d6:	ee                   	out    %al,(%dx)
  }
}
801035d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035da:	5b                   	pop    %ebx
801035db:	5e                   	pop    %esi
801035dc:	5f                   	pop    %edi
801035dd:	5d                   	pop    %ebp
801035de:	c3                   	ret    
801035df:	90                   	nop
    switch(*p){
801035e0:	83 e9 03             	sub    $0x3,%ecx
801035e3:	80 f9 01             	cmp    $0x1,%cl
801035e6:	76 c2                	jbe    801035aa <mpinit+0xfa>
801035e8:	31 f6                	xor    %esi,%esi
801035ea:	eb ac                	jmp    80103598 <mpinit+0xe8>
801035ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801035f0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801035f4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801035f7:	88 0d a0 a7 14 80    	mov    %cl,0x8014a7a0
      continue;
801035fd:	eb 99                	jmp    80103598 <mpinit+0xe8>
801035ff:	90                   	nop
      if(ncpu < NCPU) {
80103600:	8b 0d a4 a7 14 80    	mov    0x8014a7a4,%ecx
80103606:	83 f9 07             	cmp    $0x7,%ecx
80103609:	7f 19                	jg     80103624 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010360b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103611:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103615:	83 c1 01             	add    $0x1,%ecx
80103618:	89 0d a4 a7 14 80    	mov    %ecx,0x8014a7a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010361e:	88 9f c0 a7 14 80    	mov    %bl,-0x7feb5840(%edi)
      p += sizeof(struct mpproc);
80103624:	83 c0 14             	add    $0x14,%eax
      continue;
80103627:	e9 6c ff ff ff       	jmp    80103598 <mpinit+0xe8>
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	68 22 7c 10 80       	push   $0x80107c22
80103638:	e8 43 cd ff ff       	call   80100380 <panic>
8010363d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103640:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103645:	eb 13                	jmp    8010365a <mpinit+0x1aa>
80103647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010364e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103650:	89 f3                	mov    %esi,%ebx
80103652:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103658:	74 d6                	je     80103630 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010365a:	83 ec 04             	sub    $0x4,%esp
8010365d:	8d 73 10             	lea    0x10(%ebx),%esi
80103660:	6a 04                	push   $0x4
80103662:	68 18 7c 10 80       	push   $0x80107c18
80103667:	53                   	push   %ebx
80103668:	e8 f3 12 00 00       	call   80104960 <memcmp>
8010366d:	83 c4 10             	add    $0x10,%esp
80103670:	89 c2                	mov    %eax,%edx
80103672:	85 c0                	test   %eax,%eax
80103674:	75 da                	jne    80103650 <mpinit+0x1a0>
80103676:	89 d8                	mov    %ebx,%eax
80103678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010367f:	90                   	nop
    sum += addr[i];
80103680:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
80103683:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103686:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103688:	39 f0                	cmp    %esi,%eax
8010368a:	75 f4                	jne    80103680 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010368c:	84 d2                	test   %dl,%dl
8010368e:	75 c0                	jne    80103650 <mpinit+0x1a0>
80103690:	e9 6b fe ff ff       	jmp    80103500 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103695:	83 ec 0c             	sub    $0xc,%esp
80103698:	68 3c 7c 10 80       	push   $0x80107c3c
8010369d:	e8 de cc ff ff       	call   80100380 <panic>
801036a2:	66 90                	xchg   %ax,%ax
801036a4:	66 90                	xchg   %ax,%ax
801036a6:	66 90                	xchg   %ax,%ax
801036a8:	66 90                	xchg   %ax,%ax
801036aa:	66 90                	xchg   %ax,%ax
801036ac:	66 90                	xchg   %ax,%ax
801036ae:	66 90                	xchg   %ax,%ax

801036b0 <picinit>:
801036b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036b5:	ba 21 00 00 00       	mov    $0x21,%edx
801036ba:	ee                   	out    %al,(%dx)
801036bb:	ba a1 00 00 00       	mov    $0xa1,%edx
801036c0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801036c1:	c3                   	ret    
801036c2:	66 90                	xchg   %ax,%ax
801036c4:	66 90                	xchg   %ax,%ax
801036c6:	66 90                	xchg   %ax,%ax
801036c8:	66 90                	xchg   %ax,%ax
801036ca:	66 90                	xchg   %ax,%ax
801036cc:	66 90                	xchg   %ax,%ax
801036ce:	66 90                	xchg   %ax,%ax

801036d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 0c             	sub    $0xc,%esp
801036d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801036df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801036e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801036eb:	e8 60 d8 ff ff       	call   80100f50 <filealloc>
801036f0:	89 03                	mov    %eax,(%ebx)
801036f2:	85 c0                	test   %eax,%eax
801036f4:	0f 84 a8 00 00 00    	je     801037a2 <pipealloc+0xd2>
801036fa:	e8 51 d8 ff ff       	call   80100f50 <filealloc>
801036ff:	89 06                	mov    %eax,(%esi)
80103701:	85 c0                	test   %eax,%eax
80103703:	0f 84 87 00 00 00    	je     80103790 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103709:	e8 f2 f1 ff ff       	call   80102900 <kalloc>
8010370e:	89 c7                	mov    %eax,%edi
80103710:	85 c0                	test   %eax,%eax
80103712:	0f 84 b0 00 00 00    	je     801037c8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103718:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010371f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103722:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103725:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010372c:	00 00 00 
  p->nwrite = 0;
8010372f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103736:	00 00 00 
  p->nread = 0;
80103739:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103740:	00 00 00 
  initlock(&p->lock, "pipe");
80103743:	68 5b 7c 10 80       	push   $0x80107c5b
80103748:	50                   	push   %eax
80103749:	e8 42 0f 00 00       	call   80104690 <initlock>
  (*f0)->type = FD_PIPE;
8010374e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103750:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103753:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103759:	8b 03                	mov    (%ebx),%eax
8010375b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010375f:	8b 03                	mov    (%ebx),%eax
80103761:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103765:	8b 03                	mov    (%ebx),%eax
80103767:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010376a:	8b 06                	mov    (%esi),%eax
8010376c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103772:	8b 06                	mov    (%esi),%eax
80103774:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103778:	8b 06                	mov    (%esi),%eax
8010377a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010377e:	8b 06                	mov    (%esi),%eax
80103780:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103783:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103786:	31 c0                	xor    %eax,%eax
}
80103788:	5b                   	pop    %ebx
80103789:	5e                   	pop    %esi
8010378a:	5f                   	pop    %edi
8010378b:	5d                   	pop    %ebp
8010378c:	c3                   	ret    
8010378d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103790:	8b 03                	mov    (%ebx),%eax
80103792:	85 c0                	test   %eax,%eax
80103794:	74 1e                	je     801037b4 <pipealloc+0xe4>
    fileclose(*f0);
80103796:	83 ec 0c             	sub    $0xc,%esp
80103799:	50                   	push   %eax
8010379a:	e8 71 d8 ff ff       	call   80101010 <fileclose>
8010379f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801037a2:	8b 06                	mov    (%esi),%eax
801037a4:	85 c0                	test   %eax,%eax
801037a6:	74 0c                	je     801037b4 <pipealloc+0xe4>
    fileclose(*f1);
801037a8:	83 ec 0c             	sub    $0xc,%esp
801037ab:	50                   	push   %eax
801037ac:	e8 5f d8 ff ff       	call   80101010 <fileclose>
801037b1:	83 c4 10             	add    $0x10,%esp
}
801037b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801037b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801037bc:	5b                   	pop    %ebx
801037bd:	5e                   	pop    %esi
801037be:	5f                   	pop    %edi
801037bf:	5d                   	pop    %ebp
801037c0:	c3                   	ret    
801037c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801037c8:	8b 03                	mov    (%ebx),%eax
801037ca:	85 c0                	test   %eax,%eax
801037cc:	75 c8                	jne    80103796 <pipealloc+0xc6>
801037ce:	eb d2                	jmp    801037a2 <pipealloc+0xd2>

801037d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	56                   	push   %esi
801037d4:	53                   	push   %ebx
801037d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801037db:	83 ec 0c             	sub    $0xc,%esp
801037de:	53                   	push   %ebx
801037df:	e8 bc 0f 00 00       	call   801047a0 <acquire>
  if(writable){
801037e4:	83 c4 10             	add    $0x10,%esp
801037e7:	85 f6                	test   %esi,%esi
801037e9:	74 65                	je     80103850 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801037eb:	83 ec 0c             	sub    $0xc,%esp
801037ee:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801037f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801037fb:	00 00 00 
    wakeup(&p->nread);
801037fe:	50                   	push   %eax
801037ff:	e8 dc 0b 00 00       	call   801043e0 <wakeup>
80103804:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103807:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010380d:	85 d2                	test   %edx,%edx
8010380f:	75 0a                	jne    8010381b <pipeclose+0x4b>
80103811:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103817:	85 c0                	test   %eax,%eax
80103819:	74 15                	je     80103830 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010381b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010381e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103821:	5b                   	pop    %ebx
80103822:	5e                   	pop    %esi
80103823:	5d                   	pop    %ebp
    release(&p->lock);
80103824:	e9 97 10 00 00       	jmp    801048c0 <release>
80103829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103830:	83 ec 0c             	sub    $0xc,%esp
80103833:	53                   	push   %ebx
80103834:	e8 87 10 00 00       	call   801048c0 <release>
    kfree((char*)p);
80103839:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010383c:	83 c4 10             	add    $0x10,%esp
}
8010383f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103842:	5b                   	pop    %ebx
80103843:	5e                   	pop    %esi
80103844:	5d                   	pop    %ebp
    kfree((char*)p);
80103845:	e9 86 ee ff ff       	jmp    801026d0 <kfree>
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103850:	83 ec 0c             	sub    $0xc,%esp
80103853:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103859:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103860:	00 00 00 
    wakeup(&p->nwrite);
80103863:	50                   	push   %eax
80103864:	e8 77 0b 00 00       	call   801043e0 <wakeup>
80103869:	83 c4 10             	add    $0x10,%esp
8010386c:	eb 99                	jmp    80103807 <pipeclose+0x37>
8010386e:	66 90                	xchg   %ax,%ax

80103870 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	57                   	push   %edi
80103874:	56                   	push   %esi
80103875:	53                   	push   %ebx
80103876:	83 ec 28             	sub    $0x28,%esp
80103879:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010387c:	53                   	push   %ebx
8010387d:	e8 1e 0f 00 00       	call   801047a0 <acquire>
  for(i = 0; i < n; i++){
80103882:	8b 45 10             	mov    0x10(%ebp),%eax
80103885:	83 c4 10             	add    $0x10,%esp
80103888:	85 c0                	test   %eax,%eax
8010388a:	0f 8e c0 00 00 00    	jle    80103950 <pipewrite+0xe0>
80103890:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103893:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103899:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010389f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038a2:	03 45 10             	add    0x10(%ebp),%eax
801038a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038a8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038ae:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038b4:	89 ca                	mov    %ecx,%edx
801038b6:	05 00 02 00 00       	add    $0x200,%eax
801038bb:	39 c1                	cmp    %eax,%ecx
801038bd:	74 3f                	je     801038fe <pipewrite+0x8e>
801038bf:	eb 67                	jmp    80103928 <pipewrite+0xb8>
801038c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801038c8:	e8 53 03 00 00       	call   80103c20 <myproc>
801038cd:	8b 48 24             	mov    0x24(%eax),%ecx
801038d0:	85 c9                	test   %ecx,%ecx
801038d2:	75 34                	jne    80103908 <pipewrite+0x98>
      wakeup(&p->nread);
801038d4:	83 ec 0c             	sub    $0xc,%esp
801038d7:	57                   	push   %edi
801038d8:	e8 03 0b 00 00       	call   801043e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038dd:	58                   	pop    %eax
801038de:	5a                   	pop    %edx
801038df:	53                   	push   %ebx
801038e0:	56                   	push   %esi
801038e1:	e8 3a 0a 00 00       	call   80104320 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038e6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038ec:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801038f2:	83 c4 10             	add    $0x10,%esp
801038f5:	05 00 02 00 00       	add    $0x200,%eax
801038fa:	39 c2                	cmp    %eax,%edx
801038fc:	75 2a                	jne    80103928 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801038fe:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103904:	85 c0                	test   %eax,%eax
80103906:	75 c0                	jne    801038c8 <pipewrite+0x58>
        release(&p->lock);
80103908:	83 ec 0c             	sub    $0xc,%esp
8010390b:	53                   	push   %ebx
8010390c:	e8 af 0f 00 00       	call   801048c0 <release>
        return -1;
80103911:	83 c4 10             	add    $0x10,%esp
80103914:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010391c:	5b                   	pop    %ebx
8010391d:	5e                   	pop    %esi
8010391e:	5f                   	pop    %edi
8010391f:	5d                   	pop    %ebp
80103920:	c3                   	ret    
80103921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103928:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010392b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010392e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103934:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010393a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010393d:	83 c6 01             	add    $0x1,%esi
80103940:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103943:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103947:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010394a:	0f 85 58 ff ff ff    	jne    801038a8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103950:	83 ec 0c             	sub    $0xc,%esp
80103953:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103959:	50                   	push   %eax
8010395a:	e8 81 0a 00 00       	call   801043e0 <wakeup>
  release(&p->lock);
8010395f:	89 1c 24             	mov    %ebx,(%esp)
80103962:	e8 59 0f 00 00       	call   801048c0 <release>
  return n;
80103967:	8b 45 10             	mov    0x10(%ebp),%eax
8010396a:	83 c4 10             	add    $0x10,%esp
8010396d:	eb aa                	jmp    80103919 <pipewrite+0xa9>
8010396f:	90                   	nop

80103970 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	57                   	push   %edi
80103974:	56                   	push   %esi
80103975:	53                   	push   %ebx
80103976:	83 ec 18             	sub    $0x18,%esp
80103979:	8b 75 08             	mov    0x8(%ebp),%esi
8010397c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010397f:	56                   	push   %esi
80103980:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103986:	e8 15 0e 00 00       	call   801047a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010398b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103991:	83 c4 10             	add    $0x10,%esp
80103994:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010399a:	74 2f                	je     801039cb <piperead+0x5b>
8010399c:	eb 37                	jmp    801039d5 <piperead+0x65>
8010399e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801039a0:	e8 7b 02 00 00       	call   80103c20 <myproc>
801039a5:	8b 48 24             	mov    0x24(%eax),%ecx
801039a8:	85 c9                	test   %ecx,%ecx
801039aa:	0f 85 80 00 00 00    	jne    80103a30 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801039b0:	83 ec 08             	sub    $0x8,%esp
801039b3:	56                   	push   %esi
801039b4:	53                   	push   %ebx
801039b5:	e8 66 09 00 00       	call   80104320 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039ba:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801039c0:	83 c4 10             	add    $0x10,%esp
801039c3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801039c9:	75 0a                	jne    801039d5 <piperead+0x65>
801039cb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801039d1:	85 c0                	test   %eax,%eax
801039d3:	75 cb                	jne    801039a0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039d5:	8b 55 10             	mov    0x10(%ebp),%edx
801039d8:	31 db                	xor    %ebx,%ebx
801039da:	85 d2                	test   %edx,%edx
801039dc:	7f 20                	jg     801039fe <piperead+0x8e>
801039de:	eb 2c                	jmp    80103a0c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801039e0:	8d 48 01             	lea    0x1(%eax),%ecx
801039e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801039e8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801039ee:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801039f3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039f6:	83 c3 01             	add    $0x1,%ebx
801039f9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801039fc:	74 0e                	je     80103a0c <piperead+0x9c>
    if(p->nread == p->nwrite)
801039fe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a04:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103a0a:	75 d4                	jne    801039e0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a0c:	83 ec 0c             	sub    $0xc,%esp
80103a0f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a15:	50                   	push   %eax
80103a16:	e8 c5 09 00 00       	call   801043e0 <wakeup>
  release(&p->lock);
80103a1b:	89 34 24             	mov    %esi,(%esp)
80103a1e:	e8 9d 0e 00 00       	call   801048c0 <release>
  return i;
80103a23:	83 c4 10             	add    $0x10,%esp
}
80103a26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a29:	89 d8                	mov    %ebx,%eax
80103a2b:	5b                   	pop    %ebx
80103a2c:	5e                   	pop    %esi
80103a2d:	5f                   	pop    %edi
80103a2e:	5d                   	pop    %ebp
80103a2f:	c3                   	ret    
      release(&p->lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103a33:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103a38:	56                   	push   %esi
80103a39:	e8 82 0e 00 00       	call   801048c0 <release>
      return -1;
80103a3e:	83 c4 10             	add    $0x10,%esp
}
80103a41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a44:	89 d8                	mov    %ebx,%eax
80103a46:	5b                   	pop    %ebx
80103a47:	5e                   	pop    %esi
80103a48:	5f                   	pop    %edi
80103a49:	5d                   	pop    %ebp
80103a4a:	c3                   	ret    
80103a4b:	66 90                	xchg   %ax,%ax
80103a4d:	66 90                	xchg   %ax,%ax
80103a4f:	90                   	nop

80103a50 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a54:	bb 94 ad 14 80       	mov    $0x8014ad94,%ebx
{
80103a59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103a5c:	68 60 ad 14 80       	push   $0x8014ad60
80103a61:	e8 3a 0d 00 00       	call   801047a0 <acquire>
80103a66:	83 c4 10             	add    $0x10,%esp
80103a69:	eb 10                	jmp    80103a7b <allocproc+0x2b>
80103a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a6f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a70:	83 c3 7c             	add    $0x7c,%ebx
80103a73:	81 fb 94 cc 14 80    	cmp    $0x8014cc94,%ebx
80103a79:	74 75                	je     80103af0 <allocproc+0xa0>
    if(p->state == UNUSED)
80103a7b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a7e:	85 c0                	test   %eax,%eax
80103a80:	75 ee                	jne    80103a70 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a82:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103a87:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103a8a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103a91:	89 43 10             	mov    %eax,0x10(%ebx)
80103a94:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103a97:	68 60 ad 14 80       	push   $0x8014ad60
  p->pid = nextpid++;
80103a9c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103aa2:	e8 19 0e 00 00       	call   801048c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103aa7:	e8 54 ee ff ff       	call   80102900 <kalloc>
80103aac:	83 c4 10             	add    $0x10,%esp
80103aaf:	89 43 08             	mov    %eax,0x8(%ebx)
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	74 53                	je     80103b09 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ab6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103abc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103abf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ac4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ac7:	c7 40 14 59 5b 10 80 	movl   $0x80105b59,0x14(%eax)
  p->context = (struct context*)sp;
80103ace:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ad1:	6a 14                	push   $0x14
80103ad3:	6a 00                	push   $0x0
80103ad5:	50                   	push   %eax
80103ad6:	e8 35 0e 00 00       	call   80104910 <memset>
  p->context->eip = (uint)forkret;
80103adb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103ade:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103ae1:	c7 40 10 20 3b 10 80 	movl   $0x80103b20,0x10(%eax)
}
80103ae8:	89 d8                	mov    %ebx,%eax
80103aea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aed:	c9                   	leave  
80103aee:	c3                   	ret    
80103aef:	90                   	nop
  release(&ptable.lock);
80103af0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103af3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103af5:	68 60 ad 14 80       	push   $0x8014ad60
80103afa:	e8 c1 0d 00 00       	call   801048c0 <release>
}
80103aff:	89 d8                	mov    %ebx,%eax
  return 0;
80103b01:	83 c4 10             	add    $0x10,%esp
}
80103b04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b07:	c9                   	leave  
80103b08:	c3                   	ret    
    p->state = UNUSED;
80103b09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103b10:	31 db                	xor    %ebx,%ebx
}
80103b12:	89 d8                	mov    %ebx,%eax
80103b14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b17:	c9                   	leave  
80103b18:	c3                   	ret    
80103b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103b26:	68 60 ad 14 80       	push   $0x8014ad60
80103b2b:	e8 90 0d 00 00       	call   801048c0 <release>

  if (first) {
80103b30:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103b35:	83 c4 10             	add    $0x10,%esp
80103b38:	85 c0                	test   %eax,%eax
80103b3a:	75 04                	jne    80103b40 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b3c:	c9                   	leave  
80103b3d:	c3                   	ret    
80103b3e:	66 90                	xchg   %ax,%ax
    first = 0;
80103b40:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103b47:	00 00 00 
    iinit(ROOTDEV);
80103b4a:	83 ec 0c             	sub    $0xc,%esp
80103b4d:	6a 01                	push   $0x1
80103b4f:	e8 3c db ff ff       	call   80101690 <iinit>
    initlog(ROOTDEV);
80103b54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b5b:	e8 00 f4 ff ff       	call   80102f60 <initlog>
}
80103b60:	83 c4 10             	add    $0x10,%esp
80103b63:	c9                   	leave  
80103b64:	c3                   	ret    
80103b65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b70 <pinit>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b76:	68 60 7c 10 80       	push   $0x80107c60
80103b7b:	68 60 ad 14 80       	push   $0x8014ad60
80103b80:	e8 0b 0b 00 00       	call   80104690 <initlock>
}
80103b85:	83 c4 10             	add    $0x10,%esp
80103b88:	c9                   	leave  
80103b89:	c3                   	ret    
80103b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b90 <mycpu>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	56                   	push   %esi
80103b94:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b95:	9c                   	pushf  
80103b96:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b97:	f6 c4 02             	test   $0x2,%ah
80103b9a:	75 4e                	jne    80103bea <mycpu+0x5a>
  apicid = lapicid();
80103b9c:	e8 ef ef ff ff       	call   80102b90 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ba1:	8b 35 a4 a7 14 80    	mov    0x8014a7a4,%esi
  apicid = lapicid();
80103ba7:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103ba9:	85 f6                	test   %esi,%esi
80103bab:	7e 30                	jle    80103bdd <mycpu+0x4d>
80103bad:	31 c0                	xor    %eax,%eax
80103baf:	eb 0e                	jmp    80103bbf <mycpu+0x2f>
80103bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bb8:	83 c0 01             	add    $0x1,%eax
80103bbb:	39 f0                	cmp    %esi,%eax
80103bbd:	74 1e                	je     80103bdd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103bbf:	69 d0 b0 00 00 00    	imul   $0xb0,%eax,%edx
80103bc5:	0f b6 8a c0 a7 14 80 	movzbl -0x7feb5840(%edx),%ecx
80103bcc:	39 d9                	cmp    %ebx,%ecx
80103bce:	75 e8                	jne    80103bb8 <mycpu+0x28>
}
80103bd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103bd3:	8d 82 c0 a7 14 80    	lea    -0x7feb5840(%edx),%eax
}
80103bd9:	5b                   	pop    %ebx
80103bda:	5e                   	pop    %esi
80103bdb:	5d                   	pop    %ebp
80103bdc:	c3                   	ret    
  panic("unknown apicid\n");
80103bdd:	83 ec 0c             	sub    $0xc,%esp
80103be0:	68 67 7c 10 80       	push   $0x80107c67
80103be5:	e8 96 c7 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103bea:	83 ec 0c             	sub    $0xc,%esp
80103bed:	68 78 7d 10 80       	push   $0x80107d78
80103bf2:	e8 89 c7 ff ff       	call   80100380 <panic>
80103bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bfe:	66 90                	xchg   %ax,%ax

80103c00 <cpuid>:
cpuid() {
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c06:	e8 85 ff ff ff       	call   80103b90 <mycpu>
}
80103c0b:	c9                   	leave  
  return mycpu()-cpus;
80103c0c:	2d c0 a7 14 80       	sub    $0x8014a7c0,%eax
80103c11:	c1 f8 04             	sar    $0x4,%eax
80103c14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c1a:	c3                   	ret    
80103c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c1f:	90                   	nop

80103c20 <myproc>:
myproc(void) {
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	53                   	push   %ebx
80103c24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c27:	e8 24 0b 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103c2c:	e8 5f ff ff ff       	call   80103b90 <mycpu>
  p = c->proc;
80103c31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c37:	e8 24 0c 00 00       	call   80104860 <popcli>
}
80103c3c:	89 d8                	mov    %ebx,%eax
80103c3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c41:	c9                   	leave  
80103c42:	c3                   	ret    
80103c43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c50 <userinit>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	53                   	push   %ebx
80103c54:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c57:	e8 f4 fd ff ff       	call   80103a50 <allocproc>
80103c5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c5e:	a3 94 cc 14 80       	mov    %eax,0x8014cc94
  if((p->pgdir = setupkvm()) == 0)
80103c63:	e8 28 35 00 00       	call   80107190 <setupkvm>
80103c68:	89 43 04             	mov    %eax,0x4(%ebx)
80103c6b:	85 c0                	test   %eax,%eax
80103c6d:	0f 84 bd 00 00 00    	je     80103d30 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c73:	83 ec 04             	sub    $0x4,%esp
80103c76:	68 2c 00 00 00       	push   $0x2c
80103c7b:	68 60 b4 10 80       	push   $0x8010b460
80103c80:	50                   	push   %eax
80103c81:	e8 ba 31 00 00       	call   80106e40 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c86:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c8f:	6a 4c                	push   $0x4c
80103c91:	6a 00                	push   $0x0
80103c93:	ff 73 18             	pushl  0x18(%ebx)
80103c96:	e8 75 0c 00 00       	call   80104910 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c9b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ca3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ca6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103caf:	8b 43 18             	mov    0x18(%ebx),%eax
80103cb2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103cb6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cb9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cbd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103cc1:	8b 43 18             	mov    0x18(%ebx),%eax
80103cc4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cc8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ccc:	8b 43 18             	mov    0x18(%ebx),%eax
80103ccf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103cd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cd9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ce0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ce3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cea:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ced:	6a 10                	push   $0x10
80103cef:	68 90 7c 10 80       	push   $0x80107c90
80103cf4:	50                   	push   %eax
80103cf5:	e8 d6 0d 00 00       	call   80104ad0 <safestrcpy>
  p->cwd = namei("/");
80103cfa:	c7 04 24 99 7c 10 80 	movl   $0x80107c99,(%esp)
80103d01:	e8 ca e4 ff ff       	call   801021d0 <namei>
80103d06:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d09:	c7 04 24 60 ad 14 80 	movl   $0x8014ad60,(%esp)
80103d10:	e8 8b 0a 00 00       	call   801047a0 <acquire>
  p->state = RUNNABLE;
80103d15:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103d1c:	c7 04 24 60 ad 14 80 	movl   $0x8014ad60,(%esp)
80103d23:	e8 98 0b 00 00       	call   801048c0 <release>
}
80103d28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d2b:	83 c4 10             	add    $0x10,%esp
80103d2e:	c9                   	leave  
80103d2f:	c3                   	ret    
    panic("userinit: out of memory?");
80103d30:	83 ec 0c             	sub    $0xc,%esp
80103d33:	68 77 7c 10 80       	push   $0x80107c77
80103d38:	e8 43 c6 ff ff       	call   80100380 <panic>
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi

80103d40 <growproc>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	56                   	push   %esi
80103d44:	53                   	push   %ebx
80103d45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d48:	e8 03 0a 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103d4d:	e8 3e fe ff ff       	call   80103b90 <mycpu>
  p = c->proc;
80103d52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d58:	e8 03 0b 00 00       	call   80104860 <popcli>
  sz = curproc->sz;
80103d5d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d5f:	85 f6                	test   %esi,%esi
80103d61:	7f 1d                	jg     80103d80 <growproc+0x40>
  } else if(n < 0){
80103d63:	75 4b                	jne    80103db0 <growproc+0x70>
  switchuvm(curproc);
80103d65:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d68:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d6a:	53                   	push   %ebx
80103d6b:	e8 c0 2f 00 00       	call   80106d30 <switchuvm>
  return 0;
80103d70:	83 c4 10             	add    $0x10,%esp
80103d73:	31 c0                	xor    %eax,%eax
}
80103d75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d78:	5b                   	pop    %ebx
80103d79:	5e                   	pop    %esi
80103d7a:	5d                   	pop    %ebp
80103d7b:	c3                   	ret    
80103d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d80:	83 ec 04             	sub    $0x4,%esp
80103d83:	01 c6                	add    %eax,%esi
80103d85:	56                   	push   %esi
80103d86:	50                   	push   %eax
80103d87:	ff 73 04             	pushl  0x4(%ebx)
80103d8a:	e8 21 32 00 00       	call   80106fb0 <allocuvm>
80103d8f:	83 c4 10             	add    $0x10,%esp
80103d92:	85 c0                	test   %eax,%eax
80103d94:	75 cf                	jne    80103d65 <growproc+0x25>
      cprintf("Allocating pages failed!\n"); // xv6 proj - cow	
80103d96:	83 ec 0c             	sub    $0xc,%esp
80103d99:	68 9b 7c 10 80       	push   $0x80107c9b
80103d9e:	e8 dd c8 ff ff       	call   80100680 <cprintf>
      return -1;
80103da3:	83 c4 10             	add    $0x10,%esp
80103da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dab:	eb c8                	jmp    80103d75 <growproc+0x35>
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103db0:	83 ec 04             	sub    $0x4,%esp
80103db3:	01 c6                	add    %eax,%esi
80103db5:	56                   	push   %esi
80103db6:	50                   	push   %eax
80103db7:	ff 73 04             	pushl  0x4(%ebx)
80103dba:	e8 21 33 00 00       	call   801070e0 <deallocuvm>
80103dbf:	83 c4 10             	add    $0x10,%esp
80103dc2:	85 c0                	test   %eax,%eax
80103dc4:	75 9f                	jne    80103d65 <growproc+0x25>
      cprintf("Deallocating pages failed!\n"); // xv6 proj - cow
80103dc6:	83 ec 0c             	sub    $0xc,%esp
80103dc9:	68 b5 7c 10 80       	push   $0x80107cb5
80103dce:	e8 ad c8 ff ff       	call   80100680 <cprintf>
      return -1;
80103dd3:	83 c4 10             	add    $0x10,%esp
80103dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ddb:	eb 98                	jmp    80103d75 <growproc+0x35>
80103ddd:	8d 76 00             	lea    0x0(%esi),%esi

80103de0 <fork>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103de9:	e8 62 09 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103dee:	e8 9d fd ff ff       	call   80103b90 <mycpu>
  p = c->proc;
80103df3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103df9:	e8 62 0a 00 00       	call   80104860 <popcli>
  if((np = allocproc()) == 0){
80103dfe:	e8 4d fc ff ff       	call   80103a50 <allocproc>
80103e03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e06:	85 c0                	test   %eax,%eax
80103e08:	0f 84 b7 00 00 00    	je     80103ec5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e0e:	83 ec 08             	sub    $0x8,%esp
80103e11:	ff 33                	pushl  (%ebx)
80103e13:	89 c7                	mov    %eax,%edi
80103e15:	ff 73 04             	pushl  0x4(%ebx)
80103e18:	e8 63 34 00 00       	call   80107280 <copyuvm>
80103e1d:	83 c4 10             	add    $0x10,%esp
80103e20:	89 47 04             	mov    %eax,0x4(%edi)
80103e23:	85 c0                	test   %eax,%eax
80103e25:	0f 84 a1 00 00 00    	je     80103ecc <fork+0xec>
  np->sz = curproc->sz;
80103e2b:	8b 03                	mov    (%ebx),%eax
80103e2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e30:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103e32:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103e35:	89 c8                	mov    %ecx,%eax
80103e37:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103e3a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e3f:	8b 73 18             	mov    0x18(%ebx),%esi
80103e42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e44:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e46:	8b 40 18             	mov    0x18(%eax),%eax
80103e49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103e50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e54:	85 c0                	test   %eax,%eax
80103e56:	74 13                	je     80103e6b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e58:	83 ec 0c             	sub    $0xc,%esp
80103e5b:	50                   	push   %eax
80103e5c:	e8 5f d1 ff ff       	call   80100fc0 <filedup>
80103e61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e64:	83 c4 10             	add    $0x10,%esp
80103e67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e6b:	83 c6 01             	add    $0x1,%esi
80103e6e:	83 fe 10             	cmp    $0x10,%esi
80103e71:	75 dd                	jne    80103e50 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e73:	83 ec 0c             	sub    $0xc,%esp
80103e76:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e79:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e7c:	e8 ff d9 ff ff       	call   80101880 <idup>
80103e81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e84:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e87:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e8d:	6a 10                	push   $0x10
80103e8f:	53                   	push   %ebx
80103e90:	50                   	push   %eax
80103e91:	e8 3a 0c 00 00       	call   80104ad0 <safestrcpy>
  pid = np->pid;
80103e96:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e99:	c7 04 24 60 ad 14 80 	movl   $0x8014ad60,(%esp)
80103ea0:	e8 fb 08 00 00       	call   801047a0 <acquire>
  np->state = RUNNABLE;
80103ea5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103eac:	c7 04 24 60 ad 14 80 	movl   $0x8014ad60,(%esp)
80103eb3:	e8 08 0a 00 00       	call   801048c0 <release>
  return pid;
80103eb8:	83 c4 10             	add    $0x10,%esp
}
80103ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ebe:	89 d8                	mov    %ebx,%eax
80103ec0:	5b                   	pop    %ebx
80103ec1:	5e                   	pop    %esi
80103ec2:	5f                   	pop    %edi
80103ec3:	5d                   	pop    %ebp
80103ec4:	c3                   	ret    
    return -1;
80103ec5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103eca:	eb ef                	jmp    80103ebb <fork+0xdb>
    kfree(np->kstack);
80103ecc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ecf:	83 ec 0c             	sub    $0xc,%esp
80103ed2:	ff 73 08             	pushl  0x8(%ebx)
80103ed5:	e8 f6 e7 ff ff       	call   801026d0 <kfree>
    np->kstack = 0;
80103eda:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103ee1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ee4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103eeb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ef0:	eb c9                	jmp    80103ebb <fork+0xdb>
80103ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f00 <scheduler>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	57                   	push   %edi
80103f04:	56                   	push   %esi
80103f05:	53                   	push   %ebx
80103f06:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103f09:	e8 82 fc ff ff       	call   80103b90 <mycpu>
  c->proc = 0;
80103f0e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f15:	00 00 00 
  struct cpu *c = mycpu();
80103f18:	89 c6                	mov    %eax,%esi
  int ran = 0; // CS 350/550: to solve the 100%-CPU-utilization-when-idling problem
80103f1a:	8d 78 04             	lea    0x4(%eax),%edi
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f20:	fb                   	sti    
    acquire(&ptable.lock);
80103f21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f24:	bb 94 ad 14 80       	mov    $0x8014ad94,%ebx
    acquire(&ptable.lock);
80103f29:	68 60 ad 14 80       	push   $0x8014ad60
80103f2e:	e8 6d 08 00 00       	call   801047a0 <acquire>
80103f33:	83 c4 10             	add    $0x10,%esp
    ran = 0;
80103f36:	31 c0                	xor    %eax,%eax
80103f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f3f:	90                   	nop
      if(p->state != RUNNABLE)
80103f40:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f44:	75 38                	jne    80103f7e <scheduler+0x7e>
      switchuvm(p);
80103f46:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f4f:	53                   	push   %ebx
80103f50:	e8 db 2d 00 00       	call   80106d30 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f55:	58                   	pop    %eax
80103f56:	5a                   	pop    %edx
80103f57:	ff 73 1c             	pushl  0x1c(%ebx)
80103f5a:	57                   	push   %edi
      p->state = RUNNING;
80103f5b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f62:	e8 c4 0b 00 00       	call   80104b2b <swtch>
      switchkvm();
80103f67:	e8 b4 2d 00 00       	call   80106d20 <switchkvm>
      c->proc = 0;
80103f6c:	83 c4 10             	add    $0x10,%esp
      ran = 1;
80103f6f:	b8 01 00 00 00       	mov    $0x1,%eax
      c->proc = 0;
80103f74:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f7b:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7e:	83 c3 7c             	add    $0x7c,%ebx
80103f81:	81 fb 94 cc 14 80    	cmp    $0x8014cc94,%ebx
80103f87:	75 b7                	jne    80103f40 <scheduler+0x40>
    release(&ptable.lock);
80103f89:	83 ec 0c             	sub    $0xc,%esp
80103f8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103f8f:	68 60 ad 14 80       	push   $0x8014ad60
80103f94:	e8 27 09 00 00       	call   801048c0 <release>
    if (ran == 0){
80103f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f9c:	83 c4 10             	add    $0x10,%esp
80103f9f:	85 c0                	test   %eax,%eax
80103fa1:	0f 85 79 ff ff ff    	jne    80103f20 <scheduler+0x20>

// CS 350/550: to solve the 100%-CPU-utilization-when-idling problem - "hlt" instruction puts CPU to sleep
static inline void
halt()
{
    asm volatile("hlt" : : :"memory");
80103fa7:	f4                   	hlt    
}
80103fa8:	e9 73 ff ff ff       	jmp    80103f20 <scheduler+0x20>
80103fad:	8d 76 00             	lea    0x0(%esi),%esi

80103fb0 <sched>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	56                   	push   %esi
80103fb4:	53                   	push   %ebx
  pushcli();
80103fb5:	e8 96 07 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103fba:	e8 d1 fb ff ff       	call   80103b90 <mycpu>
  p = c->proc;
80103fbf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fc5:	e8 96 08 00 00       	call   80104860 <popcli>
  if(!holding(&ptable.lock))
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 60 ad 14 80       	push   $0x8014ad60
80103fd2:	e8 39 07 00 00       	call   80104710 <holding>
80103fd7:	83 c4 10             	add    $0x10,%esp
80103fda:	85 c0                	test   %eax,%eax
80103fdc:	74 4f                	je     8010402d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103fde:	e8 ad fb ff ff       	call   80103b90 <mycpu>
80103fe3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fea:	75 68                	jne    80104054 <sched+0xa4>
  if(p->state == RUNNING)
80103fec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ff0:	74 55                	je     80104047 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ff2:	9c                   	pushf  
80103ff3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ff4:	f6 c4 02             	test   $0x2,%ah
80103ff7:	75 41                	jne    8010403a <sched+0x8a>
  intena = mycpu()->intena;
80103ff9:	e8 92 fb ff ff       	call   80103b90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ffe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104001:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104007:	e8 84 fb ff ff       	call   80103b90 <mycpu>
8010400c:	83 ec 08             	sub    $0x8,%esp
8010400f:	ff 70 04             	pushl  0x4(%eax)
80104012:	53                   	push   %ebx
80104013:	e8 13 0b 00 00       	call   80104b2b <swtch>
  mycpu()->intena = intena;
80104018:	e8 73 fb ff ff       	call   80103b90 <mycpu>
}
8010401d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104020:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104026:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104029:	5b                   	pop    %ebx
8010402a:	5e                   	pop    %esi
8010402b:	5d                   	pop    %ebp
8010402c:	c3                   	ret    
    panic("sched ptable.lock");
8010402d:	83 ec 0c             	sub    $0xc,%esp
80104030:	68 d1 7c 10 80       	push   $0x80107cd1
80104035:	e8 46 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	68 fd 7c 10 80       	push   $0x80107cfd
80104042:	e8 39 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80104047:	83 ec 0c             	sub    $0xc,%esp
8010404a:	68 ef 7c 10 80       	push   $0x80107cef
8010404f:	e8 2c c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	68 e3 7c 10 80       	push   $0x80107ce3
8010405c:	e8 1f c3 ff ff       	call   80100380 <panic>
80104061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406f:	90                   	nop

80104070 <exit>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104079:	e8 a2 fb ff ff       	call   80103c20 <myproc>
  if(curproc == initproc)
8010407e:	39 05 94 cc 14 80    	cmp    %eax,0x8014cc94
80104084:	0f 84 fd 00 00 00    	je     80104187 <exit+0x117>
8010408a:	89 c3                	mov    %eax,%ebx
8010408c:	8d 70 28             	lea    0x28(%eax),%esi
8010408f:	8d 78 68             	lea    0x68(%eax),%edi
80104092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104098:	8b 06                	mov    (%esi),%eax
8010409a:	85 c0                	test   %eax,%eax
8010409c:	74 12                	je     801040b0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010409e:	83 ec 0c             	sub    $0xc,%esp
801040a1:	50                   	push   %eax
801040a2:	e8 69 cf ff ff       	call   80101010 <fileclose>
      curproc->ofile[fd] = 0;
801040a7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801040ad:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801040b0:	83 c6 04             	add    $0x4,%esi
801040b3:	39 f7                	cmp    %esi,%edi
801040b5:	75 e1                	jne    80104098 <exit+0x28>
  begin_op();
801040b7:	e8 44 ef ff ff       	call   80103000 <begin_op>
  iput(curproc->cwd);
801040bc:	83 ec 0c             	sub    $0xc,%esp
801040bf:	ff 73 68             	pushl  0x68(%ebx)
801040c2:	e8 19 d9 ff ff       	call   801019e0 <iput>
  end_op();
801040c7:	e8 a4 ef ff ff       	call   80103070 <end_op>
  curproc->cwd = 0;
801040cc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801040d3:	c7 04 24 60 ad 14 80 	movl   $0x8014ad60,(%esp)
801040da:	e8 c1 06 00 00       	call   801047a0 <acquire>
  wakeup1(curproc->parent);
801040df:	8b 53 14             	mov    0x14(%ebx),%edx
801040e2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040e5:	b8 94 ad 14 80       	mov    $0x8014ad94,%eax
801040ea:	eb 0e                	jmp    801040fa <exit+0x8a>
801040ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040f0:	83 c0 7c             	add    $0x7c,%eax
801040f3:	3d 94 cc 14 80       	cmp    $0x8014cc94,%eax
801040f8:	74 1c                	je     80104116 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801040fa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040fe:	75 f0                	jne    801040f0 <exit+0x80>
80104100:	3b 50 20             	cmp    0x20(%eax),%edx
80104103:	75 eb                	jne    801040f0 <exit+0x80>
      p->state = RUNNABLE;
80104105:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010410c:	83 c0 7c             	add    $0x7c,%eax
8010410f:	3d 94 cc 14 80       	cmp    $0x8014cc94,%eax
80104114:	75 e4                	jne    801040fa <exit+0x8a>
      p->parent = initproc;
80104116:	8b 0d 94 cc 14 80    	mov    0x8014cc94,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411c:	ba 94 ad 14 80       	mov    $0x8014ad94,%edx
80104121:	eb 10                	jmp    80104133 <exit+0xc3>
80104123:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104127:	90                   	nop
80104128:	83 c2 7c             	add    $0x7c,%edx
8010412b:	81 fa 94 cc 14 80    	cmp    $0x8014cc94,%edx
80104131:	74 3b                	je     8010416e <exit+0xfe>
    if(p->parent == curproc){
80104133:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104136:	75 f0                	jne    80104128 <exit+0xb8>
      if(p->state == ZOMBIE)
80104138:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010413c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010413f:	75 e7                	jne    80104128 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104141:	b8 94 ad 14 80       	mov    $0x8014ad94,%eax
80104146:	eb 12                	jmp    8010415a <exit+0xea>
80104148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010414f:	90                   	nop
80104150:	83 c0 7c             	add    $0x7c,%eax
80104153:	3d 94 cc 14 80       	cmp    $0x8014cc94,%eax
80104158:	74 ce                	je     80104128 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010415a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010415e:	75 f0                	jne    80104150 <exit+0xe0>
80104160:	3b 48 20             	cmp    0x20(%eax),%ecx
80104163:	75 eb                	jne    80104150 <exit+0xe0>
      p->state = RUNNABLE;
80104165:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010416c:	eb e2                	jmp    80104150 <exit+0xe0>
  curproc->state = ZOMBIE;
8010416e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104175:	e8 36 fe ff ff       	call   80103fb0 <sched>
  panic("zombie exit");
8010417a:	83 ec 0c             	sub    $0xc,%esp
8010417d:	68 1e 7d 10 80       	push   $0x80107d1e
80104182:	e8 f9 c1 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104187:	83 ec 0c             	sub    $0xc,%esp
8010418a:	68 11 7d 10 80       	push   $0x80107d11
8010418f:	e8 ec c1 ff ff       	call   80100380 <panic>
80104194:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010419f:	90                   	nop

801041a0 <wait>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	56                   	push   %esi
801041a4:	53                   	push   %ebx
  pushcli();
801041a5:	e8 a6 05 00 00       	call   80104750 <pushcli>
  c = mycpu();
801041aa:	e8 e1 f9 ff ff       	call   80103b90 <mycpu>
  p = c->proc;
801041af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041b5:	e8 a6 06 00 00       	call   80104860 <popcli>
  acquire(&ptable.lock);
801041ba:	83 ec 0c             	sub    $0xc,%esp
801041bd:	68 60 ad 14 80       	push   $0x8014ad60
801041c2:	e8 d9 05 00 00       	call   801047a0 <acquire>
801041c7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041ca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041cc:	bb 94 ad 14 80       	mov    $0x8014ad94,%ebx
801041d1:	eb 10                	jmp    801041e3 <wait+0x43>
801041d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d7:	90                   	nop
801041d8:	83 c3 7c             	add    $0x7c,%ebx
801041db:	81 fb 94 cc 14 80    	cmp    $0x8014cc94,%ebx
801041e1:	74 1b                	je     801041fe <wait+0x5e>
      if(p->parent != curproc)
801041e3:	39 73 14             	cmp    %esi,0x14(%ebx)
801041e6:	75 f0                	jne    801041d8 <wait+0x38>
      if(p->state == ZOMBIE){
801041e8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801041ec:	74 62                	je     80104250 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ee:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801041f1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f6:	81 fb 94 cc 14 80    	cmp    $0x8014cc94,%ebx
801041fc:	75 e5                	jne    801041e3 <wait+0x43>
    if(!havekids || curproc->killed){
801041fe:	85 c0                	test   %eax,%eax
80104200:	0f 84 a0 00 00 00    	je     801042a6 <wait+0x106>
80104206:	8b 46 24             	mov    0x24(%esi),%eax
80104209:	85 c0                	test   %eax,%eax
8010420b:	0f 85 95 00 00 00    	jne    801042a6 <wait+0x106>
  pushcli();
80104211:	e8 3a 05 00 00       	call   80104750 <pushcli>
  c = mycpu();
80104216:	e8 75 f9 ff ff       	call   80103b90 <mycpu>
  p = c->proc;
8010421b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104221:	e8 3a 06 00 00       	call   80104860 <popcli>
  if(p == 0)
80104226:	85 db                	test   %ebx,%ebx
80104228:	0f 84 8f 00 00 00    	je     801042bd <wait+0x11d>
  p->chan = chan;
8010422e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104231:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104238:	e8 73 fd ff ff       	call   80103fb0 <sched>
  p->chan = 0;
8010423d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104244:	eb 84                	jmp    801041ca <wait+0x2a>
80104246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104250:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104253:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104256:	ff 73 08             	pushl  0x8(%ebx)
80104259:	e8 72 e4 ff ff       	call   801026d0 <kfree>
        p->kstack = 0;
8010425e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104265:	5a                   	pop    %edx
80104266:	ff 73 04             	pushl  0x4(%ebx)
80104269:	e8 a2 2e 00 00       	call   80107110 <freevm>
        p->pid = 0;
8010426e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104275:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010427c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104280:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104287:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010428e:	c7 04 24 60 ad 14 80 	movl   $0x8014ad60,(%esp)
80104295:	e8 26 06 00 00       	call   801048c0 <release>
        return pid;
8010429a:	83 c4 10             	add    $0x10,%esp
}
8010429d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042a0:	89 f0                	mov    %esi,%eax
801042a2:	5b                   	pop    %ebx
801042a3:	5e                   	pop    %esi
801042a4:	5d                   	pop    %ebp
801042a5:	c3                   	ret    
      release(&ptable.lock);
801042a6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042a9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042ae:	68 60 ad 14 80       	push   $0x8014ad60
801042b3:	e8 08 06 00 00       	call   801048c0 <release>
      return -1;
801042b8:	83 c4 10             	add    $0x10,%esp
801042bb:	eb e0                	jmp    8010429d <wait+0xfd>
    panic("sleep");
801042bd:	83 ec 0c             	sub    $0xc,%esp
801042c0:	68 2a 7d 10 80       	push   $0x80107d2a
801042c5:	e8 b6 c0 ff ff       	call   80100380 <panic>
801042ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042d0 <yield>:
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042d7:	68 60 ad 14 80       	push   $0x8014ad60
801042dc:	e8 bf 04 00 00       	call   801047a0 <acquire>
  pushcli();
801042e1:	e8 6a 04 00 00       	call   80104750 <pushcli>
  c = mycpu();
801042e6:	e8 a5 f8 ff ff       	call   80103b90 <mycpu>
  p = c->proc;
801042eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042f1:	e8 6a 05 00 00       	call   80104860 <popcli>
  myproc()->state = RUNNABLE;
801042f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801042fd:	e8 ae fc ff ff       	call   80103fb0 <sched>
  release(&ptable.lock);
80104302:	c7 04 24 60 ad 14 80 	movl   $0x8014ad60,(%esp)
80104309:	e8 b2 05 00 00       	call   801048c0 <release>
}
8010430e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104311:	83 c4 10             	add    $0x10,%esp
80104314:	c9                   	leave  
80104315:	c3                   	ret    
80104316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431d:	8d 76 00             	lea    0x0(%esi),%esi

80104320 <sleep>:
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	57                   	push   %edi
80104324:	56                   	push   %esi
80104325:	53                   	push   %ebx
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	8b 7d 08             	mov    0x8(%ebp),%edi
8010432c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010432f:	e8 1c 04 00 00       	call   80104750 <pushcli>
  c = mycpu();
80104334:	e8 57 f8 ff ff       	call   80103b90 <mycpu>
  p = c->proc;
80104339:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010433f:	e8 1c 05 00 00       	call   80104860 <popcli>
  if(p == 0)
80104344:	85 db                	test   %ebx,%ebx
80104346:	0f 84 87 00 00 00    	je     801043d3 <sleep+0xb3>
  if(lk == 0)
8010434c:	85 f6                	test   %esi,%esi
8010434e:	74 76                	je     801043c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104350:	81 fe 60 ad 14 80    	cmp    $0x8014ad60,%esi
80104356:	74 50                	je     801043a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	68 60 ad 14 80       	push   $0x8014ad60
80104360:	e8 3b 04 00 00       	call   801047a0 <acquire>
    release(lk);
80104365:	89 34 24             	mov    %esi,(%esp)
80104368:	e8 53 05 00 00       	call   801048c0 <release>
  p->chan = chan;
8010436d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104370:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104377:	e8 34 fc ff ff       	call   80103fb0 <sched>
  p->chan = 0;
8010437c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104383:	c7 04 24 60 ad 14 80 	movl   $0x8014ad60,(%esp)
8010438a:	e8 31 05 00 00       	call   801048c0 <release>
    acquire(lk);
8010438f:	89 75 08             	mov    %esi,0x8(%ebp)
80104392:	83 c4 10             	add    $0x10,%esp
}
80104395:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104398:	5b                   	pop    %ebx
80104399:	5e                   	pop    %esi
8010439a:	5f                   	pop    %edi
8010439b:	5d                   	pop    %ebp
    acquire(lk);
8010439c:	e9 ff 03 00 00       	jmp    801047a0 <acquire>
801043a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801043a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043b2:	e8 f9 fb ff ff       	call   80103fb0 <sched>
  p->chan = 0;
801043b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801043be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043c1:	5b                   	pop    %ebx
801043c2:	5e                   	pop    %esi
801043c3:	5f                   	pop    %edi
801043c4:	5d                   	pop    %ebp
801043c5:	c3                   	ret    
    panic("sleep without lk");
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	68 30 7d 10 80       	push   $0x80107d30
801043ce:	e8 ad bf ff ff       	call   80100380 <panic>
    panic("sleep");
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	68 2a 7d 10 80       	push   $0x80107d2a
801043db:	e8 a0 bf ff ff       	call   80100380 <panic>

801043e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 10             	sub    $0x10,%esp
801043e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043ea:	68 60 ad 14 80       	push   $0x8014ad60
801043ef:	e8 ac 03 00 00       	call   801047a0 <acquire>
801043f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043f7:	b8 94 ad 14 80       	mov    $0x8014ad94,%eax
801043fc:	eb 0c                	jmp    8010440a <wakeup+0x2a>
801043fe:	66 90                	xchg   %ax,%ax
80104400:	83 c0 7c             	add    $0x7c,%eax
80104403:	3d 94 cc 14 80       	cmp    $0x8014cc94,%eax
80104408:	74 1c                	je     80104426 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010440a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010440e:	75 f0                	jne    80104400 <wakeup+0x20>
80104410:	3b 58 20             	cmp    0x20(%eax),%ebx
80104413:	75 eb                	jne    80104400 <wakeup+0x20>
      p->state = RUNNABLE;
80104415:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010441c:	83 c0 7c             	add    $0x7c,%eax
8010441f:	3d 94 cc 14 80       	cmp    $0x8014cc94,%eax
80104424:	75 e4                	jne    8010440a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104426:	c7 45 08 60 ad 14 80 	movl   $0x8014ad60,0x8(%ebp)
}
8010442d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104430:	c9                   	leave  
  release(&ptable.lock);
80104431:	e9 8a 04 00 00       	jmp    801048c0 <release>
80104436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010443d:	8d 76 00             	lea    0x0(%esi),%esi

80104440 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 10             	sub    $0x10,%esp
80104447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010444a:	68 60 ad 14 80       	push   $0x8014ad60
8010444f:	e8 4c 03 00 00       	call   801047a0 <acquire>
80104454:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104457:	b8 94 ad 14 80       	mov    $0x8014ad94,%eax
8010445c:	eb 0c                	jmp    8010446a <kill+0x2a>
8010445e:	66 90                	xchg   %ax,%ax
80104460:	83 c0 7c             	add    $0x7c,%eax
80104463:	3d 94 cc 14 80       	cmp    $0x8014cc94,%eax
80104468:	74 36                	je     801044a0 <kill+0x60>
    if(p->pid == pid){
8010446a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010446d:	75 f1                	jne    80104460 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010446f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104473:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010447a:	75 07                	jne    80104483 <kill+0x43>
        p->state = RUNNABLE;
8010447c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104483:	83 ec 0c             	sub    $0xc,%esp
80104486:	68 60 ad 14 80       	push   $0x8014ad60
8010448b:	e8 30 04 00 00       	call   801048c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104490:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104493:	83 c4 10             	add    $0x10,%esp
80104496:	31 c0                	xor    %eax,%eax
}
80104498:	c9                   	leave  
80104499:	c3                   	ret    
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801044a0:	83 ec 0c             	sub    $0xc,%esp
801044a3:	68 60 ad 14 80       	push   $0x8014ad60
801044a8:	e8 13 04 00 00       	call   801048c0 <release>
}
801044ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801044b0:	83 c4 10             	add    $0x10,%esp
801044b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044b8:	c9                   	leave  
801044b9:	c3                   	ret    
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	56                   	push   %esi
801044c5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801044c8:	53                   	push   %ebx
801044c9:	bb 00 ae 14 80       	mov    $0x8014ae00,%ebx
801044ce:	83 ec 3c             	sub    $0x3c,%esp
801044d1:	eb 24                	jmp    801044f7 <procdump+0x37>
801044d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044d7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044d8:	83 ec 0c             	sub    $0xc,%esp
801044db:	68 b3 7c 10 80       	push   $0x80107cb3
801044e0:	e8 9b c1 ff ff       	call   80100680 <cprintf>
801044e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044e8:	83 c3 7c             	add    $0x7c,%ebx
801044eb:	81 fb 00 cd 14 80    	cmp    $0x8014cd00,%ebx
801044f1:	0f 84 81 00 00 00    	je     80104578 <procdump+0xb8>
    if(p->state == UNUSED)
801044f7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044fa:	85 c0                	test   %eax,%eax
801044fc:	74 ea                	je     801044e8 <procdump+0x28>
      state = "???";
801044fe:	ba 41 7d 10 80       	mov    $0x80107d41,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104503:	83 f8 05             	cmp    $0x5,%eax
80104506:	77 11                	ja     80104519 <procdump+0x59>
80104508:	8b 14 85 a0 7d 10 80 	mov    -0x7fef8260(,%eax,4),%edx
      state = "???";
8010450f:	b8 41 7d 10 80       	mov    $0x80107d41,%eax
80104514:	85 d2                	test   %edx,%edx
80104516:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104519:	53                   	push   %ebx
8010451a:	52                   	push   %edx
8010451b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010451e:	68 45 7d 10 80       	push   $0x80107d45
80104523:	e8 58 c1 ff ff       	call   80100680 <cprintf>
    if(p->state == SLEEPING){
80104528:	83 c4 10             	add    $0x10,%esp
8010452b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010452f:	75 a7                	jne    801044d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104531:	83 ec 08             	sub    $0x8,%esp
80104534:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104537:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010453a:	50                   	push   %eax
8010453b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010453e:	8b 40 0c             	mov    0xc(%eax),%eax
80104541:	83 c0 08             	add    $0x8,%eax
80104544:	50                   	push   %eax
80104545:	e8 66 01 00 00       	call   801046b0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010454a:	83 c4 10             	add    $0x10,%esp
8010454d:	8d 76 00             	lea    0x0(%esi),%esi
80104550:	8b 17                	mov    (%edi),%edx
80104552:	85 d2                	test   %edx,%edx
80104554:	74 82                	je     801044d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104556:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104559:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010455c:	52                   	push   %edx
8010455d:	68 41 77 10 80       	push   $0x80107741
80104562:	e8 19 c1 ff ff       	call   80100680 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104567:	83 c4 10             	add    $0x10,%esp
8010456a:	39 fe                	cmp    %edi,%esi
8010456c:	75 e2                	jne    80104550 <procdump+0x90>
8010456e:	e9 65 ff ff ff       	jmp    801044d8 <procdump+0x18>
80104573:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104577:	90                   	nop
  }
}
80104578:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010457b:	5b                   	pop    %ebx
8010457c:	5e                   	pop    %esi
8010457d:	5f                   	pop    %edi
8010457e:	5d                   	pop    %ebp
8010457f:	c3                   	ret    

80104580 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 0c             	sub    $0xc,%esp
80104587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010458a:	68 b8 7d 10 80       	push   $0x80107db8
8010458f:	8d 43 04             	lea    0x4(%ebx),%eax
80104592:	50                   	push   %eax
80104593:	e8 f8 00 00 00       	call   80104690 <initlock>
  lk->name = name;
80104598:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010459b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045a1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045a4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045ab:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045b1:	c9                   	leave  
801045b2:	c3                   	ret    
801045b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045c8:	8d 73 04             	lea    0x4(%ebx),%esi
801045cb:	83 ec 0c             	sub    $0xc,%esp
801045ce:	56                   	push   %esi
801045cf:	e8 cc 01 00 00       	call   801047a0 <acquire>
  while (lk->locked) {
801045d4:	8b 13                	mov    (%ebx),%edx
801045d6:	83 c4 10             	add    $0x10,%esp
801045d9:	85 d2                	test   %edx,%edx
801045db:	74 16                	je     801045f3 <acquiresleep+0x33>
801045dd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045e0:	83 ec 08             	sub    $0x8,%esp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	e8 36 fd ff ff       	call   80104320 <sleep>
  while (lk->locked) {
801045ea:	8b 03                	mov    (%ebx),%eax
801045ec:	83 c4 10             	add    $0x10,%esp
801045ef:	85 c0                	test   %eax,%eax
801045f1:	75 ed                	jne    801045e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801045f3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045f9:	e8 22 f6 ff ff       	call   80103c20 <myproc>
801045fe:	8b 40 10             	mov    0x10(%eax),%eax
80104601:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104604:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104607:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010460a:	5b                   	pop    %ebx
8010460b:	5e                   	pop    %esi
8010460c:	5d                   	pop    %ebp
  release(&lk->lk);
8010460d:	e9 ae 02 00 00       	jmp    801048c0 <release>
80104612:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104620 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104628:	8d 73 04             	lea    0x4(%ebx),%esi
8010462b:	83 ec 0c             	sub    $0xc,%esp
8010462e:	56                   	push   %esi
8010462f:	e8 6c 01 00 00       	call   801047a0 <acquire>
  lk->locked = 0;
80104634:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010463a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104641:	89 1c 24             	mov    %ebx,(%esp)
80104644:	e8 97 fd ff ff       	call   801043e0 <wakeup>
  release(&lk->lk);
80104649:	89 75 08             	mov    %esi,0x8(%ebp)
8010464c:	83 c4 10             	add    $0x10,%esp
}
8010464f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104652:	5b                   	pop    %ebx
80104653:	5e                   	pop    %esi
80104654:	5d                   	pop    %ebp
  release(&lk->lk);
80104655:	e9 66 02 00 00       	jmp    801048c0 <release>
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104660 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104668:	8d 5e 04             	lea    0x4(%esi),%ebx
8010466b:	83 ec 0c             	sub    $0xc,%esp
8010466e:	53                   	push   %ebx
8010466f:	e8 2c 01 00 00       	call   801047a0 <acquire>
  r = lk->locked;
80104674:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104676:	89 1c 24             	mov    %ebx,(%esp)
80104679:	e8 42 02 00 00       	call   801048c0 <release>
  return r;
}
8010467e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104681:	89 f0                	mov    %esi,%eax
80104683:	5b                   	pop    %ebx
80104684:	5e                   	pop    %esi
80104685:	5d                   	pop    %ebp
80104686:	c3                   	ret    
80104687:	66 90                	xchg   %ax,%ax
80104689:	66 90                	xchg   %ax,%ax
8010468b:	66 90                	xchg   %ax,%ax
8010468d:	66 90                	xchg   %ax,%ax
8010468f:	90                   	nop

80104690 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104696:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104699:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010469f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046a9:	5d                   	pop    %ebp
801046aa:	c3                   	ret    
801046ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046af:	90                   	nop

801046b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046b0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046b1:	31 d2                	xor    %edx,%edx
{
801046b3:	89 e5                	mov    %esp,%ebp
801046b5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046b6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046bc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801046bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046c0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046cc:	77 1a                	ja     801046e8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046ce:	8b 58 04             	mov    0x4(%eax),%ebx
801046d1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046d4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046d7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046d9:	83 fa 0a             	cmp    $0xa,%edx
801046dc:	75 e2                	jne    801046c0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046e1:	c9                   	leave  
801046e2:	c3                   	ret    
801046e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e7:	90                   	nop
  for(; i < 10; i++)
801046e8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046eb:	8d 51 28             	lea    0x28(%ecx),%edx
801046ee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046f6:	83 c0 04             	add    $0x4,%eax
801046f9:	39 d0                	cmp    %edx,%eax
801046fb:	75 f3                	jne    801046f0 <getcallerpcs+0x40>
}
801046fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104700:	c9                   	leave  
80104701:	c3                   	ret    
80104702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104710 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 04             	sub    $0x4,%esp
80104717:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010471a:	8b 02                	mov    (%edx),%eax
8010471c:	85 c0                	test   %eax,%eax
8010471e:	75 10                	jne    80104730 <holding+0x20>
}
80104720:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104723:	31 c0                	xor    %eax,%eax
80104725:	c9                   	leave  
80104726:	c3                   	ret    
80104727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472e:	66 90                	xchg   %ax,%ax
80104730:	8b 5a 08             	mov    0x8(%edx),%ebx
  return lock->locked && lock->cpu == mycpu();
80104733:	e8 58 f4 ff ff       	call   80103b90 <mycpu>
80104738:	39 c3                	cmp    %eax,%ebx
}
8010473a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010473d:	c9                   	leave  
  return lock->locked && lock->cpu == mycpu();
8010473e:	0f 94 c0             	sete   %al
80104741:	0f b6 c0             	movzbl %al,%eax
}
80104744:	c3                   	ret    
80104745:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104750 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 04             	sub    $0x4,%esp
80104757:	9c                   	pushf  
80104758:	5b                   	pop    %ebx
  asm volatile("cli");
80104759:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010475a:	e8 31 f4 ff ff       	call   80103b90 <mycpu>
8010475f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104765:	85 c0                	test   %eax,%eax
80104767:	74 17                	je     80104780 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104769:	e8 22 f4 ff ff       	call   80103b90 <mycpu>
8010476e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104775:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104778:	c9                   	leave  
80104779:	c3                   	ret    
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104780:	e8 0b f4 ff ff       	call   80103b90 <mycpu>
80104785:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010478b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104791:	eb d6                	jmp    80104769 <pushcli+0x19>
80104793:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <acquire>:
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801047a7:	e8 a4 ff ff ff       	call   80104750 <pushcli>
  if(holding(lk))
801047ac:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801047af:	8b 02                	mov    (%edx),%eax
801047b1:	85 c0                	test   %eax,%eax
801047b3:	0f 85 7f 00 00 00    	jne    80104838 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801047b9:	b9 01 00 00 00       	mov    $0x1,%ecx
801047be:	eb 03                	jmp    801047c3 <acquire+0x23>
  while(xchg(&lk->locked, 1) != 0)
801047c0:	8b 55 08             	mov    0x8(%ebp),%edx
801047c3:	89 c8                	mov    %ecx,%eax
801047c5:	f0 87 02             	lock xchg %eax,(%edx)
801047c8:	85 c0                	test   %eax,%eax
801047ca:	75 f4                	jne    801047c0 <acquire+0x20>
  __sync_synchronize();
801047cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047d4:	e8 b7 f3 ff ff       	call   80103b90 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801047dc:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801047de:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801047e1:	31 c0                	xor    %eax,%eax
801047e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047e7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047e8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801047ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047f4:	77 1a                	ja     80104810 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801047f6:	8b 5a 04             	mov    0x4(%edx),%ebx
801047f9:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801047fd:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104800:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104802:	83 f8 0a             	cmp    $0xa,%eax
80104805:	75 e1                	jne    801047e8 <acquire+0x48>
}
80104807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010480a:	c9                   	leave  
8010480b:	c3                   	ret    
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104810:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104814:	8d 51 34             	lea    0x34(%ecx),%edx
80104817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104826:	83 c0 04             	add    $0x4,%eax
80104829:	39 c2                	cmp    %eax,%edx
8010482b:	75 f3                	jne    80104820 <acquire+0x80>
}
8010482d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104830:	c9                   	leave  
80104831:	c3                   	ret    
80104832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104838:	8b 5a 08             	mov    0x8(%edx),%ebx
  return lock->locked && lock->cpu == mycpu();
8010483b:	e8 50 f3 ff ff       	call   80103b90 <mycpu>
80104840:	39 c3                	cmp    %eax,%ebx
80104842:	74 0c                	je     80104850 <acquire+0xb0>
  while(xchg(&lk->locked, 1) != 0)
80104844:	8b 55 08             	mov    0x8(%ebp),%edx
80104847:	e9 6d ff ff ff       	jmp    801047b9 <acquire+0x19>
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("acquire");
80104850:	83 ec 0c             	sub    $0xc,%esp
80104853:	68 c3 7d 10 80       	push   $0x80107dc3
80104858:	e8 23 bb ff ff       	call   80100380 <panic>
8010485d:	8d 76 00             	lea    0x0(%esi),%esi

80104860 <popcli>:

void
popcli(void)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104866:	9c                   	pushf  
80104867:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104868:	f6 c4 02             	test   $0x2,%ah
8010486b:	75 35                	jne    801048a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010486d:	e8 1e f3 ff ff       	call   80103b90 <mycpu>
80104872:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104879:	78 34                	js     801048af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010487b:	e8 10 f3 ff ff       	call   80103b90 <mycpu>
80104880:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104886:	85 d2                	test   %edx,%edx
80104888:	74 06                	je     80104890 <popcli+0x30>
    sti();
}
8010488a:	c9                   	leave  
8010488b:	c3                   	ret    
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104890:	e8 fb f2 ff ff       	call   80103b90 <mycpu>
80104895:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010489b:	85 c0                	test   %eax,%eax
8010489d:	74 eb                	je     8010488a <popcli+0x2a>
  asm volatile("sti");
8010489f:	fb                   	sti    
}
801048a0:	c9                   	leave  
801048a1:	c3                   	ret    
    panic("popcli - interruptible");
801048a2:	83 ec 0c             	sub    $0xc,%esp
801048a5:	68 cb 7d 10 80       	push   $0x80107dcb
801048aa:	e8 d1 ba ff ff       	call   80100380 <panic>
    panic("popcli");
801048af:	83 ec 0c             	sub    $0xc,%esp
801048b2:	68 e2 7d 10 80       	push   $0x80107de2
801048b7:	e8 c4 ba ff ff       	call   80100380 <panic>
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048c0 <release>:
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	53                   	push   %ebx
801048c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801048c8:	8b 03                	mov    (%ebx),%eax
801048ca:	85 c0                	test   %eax,%eax
801048cc:	75 12                	jne    801048e0 <release+0x20>
    panic("release");
801048ce:	83 ec 0c             	sub    $0xc,%esp
801048d1:	68 e9 7d 10 80       	push   $0x80107de9
801048d6:	e8 a5 ba ff ff       	call   80100380 <panic>
801048db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048df:	90                   	nop
801048e0:	8b 73 08             	mov    0x8(%ebx),%esi
  return lock->locked && lock->cpu == mycpu();
801048e3:	e8 a8 f2 ff ff       	call   80103b90 <mycpu>
801048e8:	39 c6                	cmp    %eax,%esi
801048ea:	75 e2                	jne    801048ce <release+0xe>
  lk->pcs[0] = 0;
801048ec:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048f3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048fa:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104905:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104908:	5b                   	pop    %ebx
80104909:	5e                   	pop    %esi
8010490a:	5d                   	pop    %ebp
  popcli();
8010490b:	e9 50 ff ff ff       	jmp    80104860 <popcli>

80104910 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	8b 55 08             	mov    0x8(%ebp),%edx
80104917:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010491a:	53                   	push   %ebx
8010491b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010491e:	89 d7                	mov    %edx,%edi
80104920:	09 cf                	or     %ecx,%edi
80104922:	83 e7 03             	and    $0x3,%edi
80104925:	75 29                	jne    80104950 <memset+0x40>
    c &= 0xFF;
80104927:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010492a:	c1 e0 18             	shl    $0x18,%eax
8010492d:	89 fb                	mov    %edi,%ebx
8010492f:	c1 e9 02             	shr    $0x2,%ecx
80104932:	c1 e3 10             	shl    $0x10,%ebx
80104935:	09 d8                	or     %ebx,%eax
80104937:	09 f8                	or     %edi,%eax
80104939:	c1 e7 08             	shl    $0x8,%edi
8010493c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010493e:	89 d7                	mov    %edx,%edi
80104940:	fc                   	cld    
80104941:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104943:	5b                   	pop    %ebx
80104944:	89 d0                	mov    %edx,%eax
80104946:	5f                   	pop    %edi
80104947:	5d                   	pop    %ebp
80104948:	c3                   	ret    
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104950:	89 d7                	mov    %edx,%edi
80104952:	fc                   	cld    
80104953:	f3 aa                	rep stos %al,%es:(%edi)
80104955:	5b                   	pop    %ebx
80104956:	89 d0                	mov    %edx,%eax
80104958:	5f                   	pop    %edi
80104959:	5d                   	pop    %ebp
8010495a:	c3                   	ret    
8010495b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010495f:	90                   	nop

80104960 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	8b 75 10             	mov    0x10(%ebp),%esi
80104967:	8b 55 08             	mov    0x8(%ebp),%edx
8010496a:	53                   	push   %ebx
8010496b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010496e:	85 f6                	test   %esi,%esi
80104970:	74 2e                	je     801049a0 <memcmp+0x40>
80104972:	01 c6                	add    %eax,%esi
80104974:	eb 14                	jmp    8010498a <memcmp+0x2a>
80104976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104980:	83 c0 01             	add    $0x1,%eax
80104983:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104986:	39 f0                	cmp    %esi,%eax
80104988:	74 16                	je     801049a0 <memcmp+0x40>
    if(*s1 != *s2)
8010498a:	0f b6 0a             	movzbl (%edx),%ecx
8010498d:	0f b6 18             	movzbl (%eax),%ebx
80104990:	38 d9                	cmp    %bl,%cl
80104992:	74 ec                	je     80104980 <memcmp+0x20>
      return *s1 - *s2;
80104994:	0f b6 c1             	movzbl %cl,%eax
80104997:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104999:	5b                   	pop    %ebx
8010499a:	5e                   	pop    %esi
8010499b:	5d                   	pop    %ebp
8010499c:	c3                   	ret    
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
801049a0:	5b                   	pop    %ebx
  return 0;
801049a1:	31 c0                	xor    %eax,%eax
}
801049a3:	5e                   	pop    %esi
801049a4:	5d                   	pop    %ebp
801049a5:	c3                   	ret    
801049a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ad:	8d 76 00             	lea    0x0(%esi),%esi

801049b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	8b 55 08             	mov    0x8(%ebp),%edx
801049b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049ba:	56                   	push   %esi
801049bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049be:	39 d6                	cmp    %edx,%esi
801049c0:	73 26                	jae    801049e8 <memmove+0x38>
801049c2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801049c5:	39 fa                	cmp    %edi,%edx
801049c7:	73 1f                	jae    801049e8 <memmove+0x38>
801049c9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801049cc:	85 c9                	test   %ecx,%ecx
801049ce:	74 0c                	je     801049dc <memmove+0x2c>
      *--d = *--s;
801049d0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801049d4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801049d7:	83 e8 01             	sub    $0x1,%eax
801049da:	73 f4                	jae    801049d0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049dc:	5e                   	pop    %esi
801049dd:	89 d0                	mov    %edx,%eax
801049df:	5f                   	pop    %edi
801049e0:	5d                   	pop    %ebp
801049e1:	c3                   	ret    
801049e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801049e8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801049eb:	89 d7                	mov    %edx,%edi
801049ed:	85 c9                	test   %ecx,%ecx
801049ef:	74 eb                	je     801049dc <memmove+0x2c>
801049f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801049f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801049f9:	39 f0                	cmp    %esi,%eax
801049fb:	75 fb                	jne    801049f8 <memmove+0x48>
}
801049fd:	5e                   	pop    %esi
801049fe:	89 d0                	mov    %edx,%eax
80104a00:	5f                   	pop    %edi
80104a01:	5d                   	pop    %ebp
80104a02:	c3                   	ret    
80104a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a10 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a10:	eb 9e                	jmp    801049b0 <memmove>
80104a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a20 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	8b 75 10             	mov    0x10(%ebp),%esi
80104a27:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a2a:	53                   	push   %ebx
80104a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104a2e:	85 f6                	test   %esi,%esi
80104a30:	74 36                	je     80104a68 <strncmp+0x48>
80104a32:	01 c6                	add    %eax,%esi
80104a34:	eb 18                	jmp    80104a4e <strncmp+0x2e>
80104a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	38 da                	cmp    %bl,%dl
80104a42:	75 14                	jne    80104a58 <strncmp+0x38>
    n--, p++, q++;
80104a44:	83 c0 01             	add    $0x1,%eax
80104a47:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a4a:	39 f0                	cmp    %esi,%eax
80104a4c:	74 1a                	je     80104a68 <strncmp+0x48>
80104a4e:	0f b6 11             	movzbl (%ecx),%edx
80104a51:	0f b6 18             	movzbl (%eax),%ebx
80104a54:	84 d2                	test   %dl,%dl
80104a56:	75 e8                	jne    80104a40 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a58:	0f b6 c2             	movzbl %dl,%eax
80104a5b:	29 d8                	sub    %ebx,%eax
}
80104a5d:	5b                   	pop    %ebx
80104a5e:	5e                   	pop    %esi
80104a5f:	5d                   	pop    %ebp
80104a60:	c3                   	ret    
80104a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a68:	5b                   	pop    %ebx
    return 0;
80104a69:	31 c0                	xor    %eax,%eax
}
80104a6b:	5e                   	pop    %esi
80104a6c:	5d                   	pop    %ebp
80104a6d:	c3                   	ret    
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	56                   	push   %esi
80104a75:	8b 75 08             	mov    0x8(%ebp),%esi
80104a78:	53                   	push   %ebx
80104a79:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a7c:	89 f2                	mov    %esi,%edx
80104a7e:	eb 17                	jmp    80104a97 <strncpy+0x27>
80104a80:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a84:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a87:	83 c2 01             	add    $0x1,%edx
80104a8a:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104a8e:	89 f9                	mov    %edi,%ecx
80104a90:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a93:	84 c9                	test   %cl,%cl
80104a95:	74 09                	je     80104aa0 <strncpy+0x30>
80104a97:	89 c3                	mov    %eax,%ebx
80104a99:	83 e8 01             	sub    $0x1,%eax
80104a9c:	85 db                	test   %ebx,%ebx
80104a9e:	7f e0                	jg     80104a80 <strncpy+0x10>
    ;
  while(n-- > 0)
80104aa0:	89 d1                	mov    %edx,%ecx
80104aa2:	85 c0                	test   %eax,%eax
80104aa4:	7e 1d                	jle    80104ac3 <strncpy+0x53>
80104aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
80104ab0:	83 c1 01             	add    $0x1,%ecx
80104ab3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104ab7:	89 c8                	mov    %ecx,%eax
80104ab9:	f7 d0                	not    %eax
80104abb:	01 d0                	add    %edx,%eax
80104abd:	01 d8                	add    %ebx,%eax
80104abf:	85 c0                	test   %eax,%eax
80104ac1:	7f ed                	jg     80104ab0 <strncpy+0x40>
  return os;
}
80104ac3:	5b                   	pop    %ebx
80104ac4:	89 f0                	mov    %esi,%eax
80104ac6:	5e                   	pop    %esi
80104ac7:	5f                   	pop    %edi
80104ac8:	5d                   	pop    %ebp
80104ac9:	c3                   	ret    
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ad0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	8b 55 10             	mov    0x10(%ebp),%edx
80104ad7:	8b 75 08             	mov    0x8(%ebp),%esi
80104ada:	53                   	push   %ebx
80104adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104ade:	85 d2                	test   %edx,%edx
80104ae0:	7e 25                	jle    80104b07 <safestrcpy+0x37>
80104ae2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ae6:	89 f2                	mov    %esi,%edx
80104ae8:	eb 16                	jmp    80104b00 <safestrcpy+0x30>
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104af0:	0f b6 08             	movzbl (%eax),%ecx
80104af3:	83 c0 01             	add    $0x1,%eax
80104af6:	83 c2 01             	add    $0x1,%edx
80104af9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104afc:	84 c9                	test   %cl,%cl
80104afe:	74 04                	je     80104b04 <safestrcpy+0x34>
80104b00:	39 d8                	cmp    %ebx,%eax
80104b02:	75 ec                	jne    80104af0 <safestrcpy+0x20>
    ;
  *s = 0;
80104b04:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b07:	89 f0                	mov    %esi,%eax
80104b09:	5b                   	pop    %ebx
80104b0a:	5e                   	pop    %esi
80104b0b:	5d                   	pop    %ebp
80104b0c:	c3                   	ret    
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi

80104b10 <strlen>:

int
strlen(const char *s)
{
80104b10:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b11:	31 c0                	xor    %eax,%eax
{
80104b13:	89 e5                	mov    %esp,%ebp
80104b15:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b18:	80 3a 00             	cmpb   $0x0,(%edx)
80104b1b:	74 0c                	je     80104b29 <strlen+0x19>
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi
80104b20:	83 c0 01             	add    $0x1,%eax
80104b23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b27:	75 f7                	jne    80104b20 <strlen+0x10>
    ;
  return n;
}
80104b29:	5d                   	pop    %ebp
80104b2a:	c3                   	ret    

80104b2b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b2f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104b33:	55                   	push   %ebp
  pushl %ebx
80104b34:	53                   	push   %ebx
  pushl %esi
80104b35:	56                   	push   %esi
  pushl %edi
80104b36:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b37:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b39:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104b3b:	5f                   	pop    %edi
  popl %esi
80104b3c:	5e                   	pop    %esi
  popl %ebx
80104b3d:	5b                   	pop    %ebx
  popl %ebp
80104b3e:	5d                   	pop    %ebp
  ret
80104b3f:	c3                   	ret    

80104b40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	53                   	push   %ebx
80104b44:	83 ec 04             	sub    $0x4,%esp
80104b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b4a:	e8 d1 f0 ff ff       	call   80103c20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b4f:	8b 00                	mov    (%eax),%eax
80104b51:	39 d8                	cmp    %ebx,%eax
80104b53:	76 1b                	jbe    80104b70 <fetchint+0x30>
80104b55:	8d 53 04             	lea    0x4(%ebx),%edx
80104b58:	39 d0                	cmp    %edx,%eax
80104b5a:	72 14                	jb     80104b70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5f:	8b 13                	mov    (%ebx),%edx
80104b61:	89 10                	mov    %edx,(%eax)
  return 0;
80104b63:	31 c0                	xor    %eax,%eax
}
80104b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b68:	c9                   	leave  
80104b69:	c3                   	ret    
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b75:	eb ee                	jmp    80104b65 <fetchint+0x25>
80104b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 04             	sub    $0x4,%esp
80104b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b8a:	e8 91 f0 ff ff       	call   80103c20 <myproc>

  if(addr >= curproc->sz)
80104b8f:	39 18                	cmp    %ebx,(%eax)
80104b91:	76 2d                	jbe    80104bc0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b93:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b96:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b98:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b9a:	39 d3                	cmp    %edx,%ebx
80104b9c:	73 22                	jae    80104bc0 <fetchstr+0x40>
80104b9e:	89 d8                	mov    %ebx,%eax
80104ba0:	eb 0d                	jmp    80104baf <fetchstr+0x2f>
80104ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ba8:	83 c0 01             	add    $0x1,%eax
80104bab:	39 c2                	cmp    %eax,%edx
80104bad:	76 11                	jbe    80104bc0 <fetchstr+0x40>
    if(*s == 0)
80104baf:	80 38 00             	cmpb   $0x0,(%eax)
80104bb2:	75 f4                	jne    80104ba8 <fetchstr+0x28>
      return s - *pp;
80104bb4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104bb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb9:	c9                   	leave  
80104bba:	c3                   	ret    
80104bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bbf:	90                   	nop
80104bc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bc8:	c9                   	leave  
80104bc9:	c3                   	ret    
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd5:	e8 46 f0 ff ff       	call   80103c20 <myproc>
80104bda:	8b 55 08             	mov    0x8(%ebp),%edx
80104bdd:	8b 40 18             	mov    0x18(%eax),%eax
80104be0:	8b 40 44             	mov    0x44(%eax),%eax
80104be3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104be6:	e8 35 f0 ff ff       	call   80103c20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104beb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bee:	8b 00                	mov    (%eax),%eax
80104bf0:	39 c6                	cmp    %eax,%esi
80104bf2:	73 1c                	jae    80104c10 <argint+0x40>
80104bf4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bf7:	39 d0                	cmp    %edx,%eax
80104bf9:	72 15                	jb     80104c10 <argint+0x40>
  *ip = *(int*)(addr);
80104bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bfe:	8b 53 04             	mov    0x4(%ebx),%edx
80104c01:	89 10                	mov    %edx,(%eax)
  return 0;
80104c03:	31 c0                	xor    %eax,%eax
}
80104c05:	5b                   	pop    %ebx
80104c06:	5e                   	pop    %esi
80104c07:	5d                   	pop    %ebp
80104c08:	c3                   	ret    
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c15:	eb ee                	jmp    80104c05 <argint+0x35>
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	56                   	push   %esi
80104c25:	53                   	push   %ebx
80104c26:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c29:	e8 f2 ef ff ff       	call   80103c20 <myproc>
80104c2e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c30:	e8 eb ef ff ff       	call   80103c20 <myproc>
80104c35:	8b 55 08             	mov    0x8(%ebp),%edx
80104c38:	8b 40 18             	mov    0x18(%eax),%eax
80104c3b:	8b 40 44             	mov    0x44(%eax),%eax
80104c3e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c41:	e8 da ef ff ff       	call   80103c20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c46:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c49:	8b 00                	mov    (%eax),%eax
80104c4b:	39 c7                	cmp    %eax,%edi
80104c4d:	73 31                	jae    80104c80 <argptr+0x60>
80104c4f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c52:	39 c8                	cmp    %ecx,%eax
80104c54:	72 2a                	jb     80104c80 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c56:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c59:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c5c:	85 d2                	test   %edx,%edx
80104c5e:	78 20                	js     80104c80 <argptr+0x60>
80104c60:	8b 16                	mov    (%esi),%edx
80104c62:	39 c2                	cmp    %eax,%edx
80104c64:	76 1a                	jbe    80104c80 <argptr+0x60>
80104c66:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c69:	01 c3                	add    %eax,%ebx
80104c6b:	39 da                	cmp    %ebx,%edx
80104c6d:	72 11                	jb     80104c80 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c72:	89 02                	mov    %eax,(%edx)
  return 0;
80104c74:	31 c0                	xor    %eax,%eax
}
80104c76:	83 c4 0c             	add    $0xc,%esp
80104c79:	5b                   	pop    %ebx
80104c7a:	5e                   	pop    %esi
80104c7b:	5f                   	pop    %edi
80104c7c:	5d                   	pop    %ebp
80104c7d:	c3                   	ret    
80104c7e:	66 90                	xchg   %ax,%ax
    return -1;
80104c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c85:	eb ef                	jmp    80104c76 <argptr+0x56>
80104c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8e:	66 90                	xchg   %ax,%ax

80104c90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c95:	e8 86 ef ff ff       	call   80103c20 <myproc>
80104c9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c9d:	8b 40 18             	mov    0x18(%eax),%eax
80104ca0:	8b 40 44             	mov    0x44(%eax),%eax
80104ca3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ca6:	e8 75 ef ff ff       	call   80103c20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cae:	8b 00                	mov    (%eax),%eax
80104cb0:	39 c6                	cmp    %eax,%esi
80104cb2:	73 44                	jae    80104cf8 <argstr+0x68>
80104cb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104cb7:	39 d0                	cmp    %edx,%eax
80104cb9:	72 3d                	jb     80104cf8 <argstr+0x68>
  *ip = *(int*)(addr);
80104cbb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104cbe:	e8 5d ef ff ff       	call   80103c20 <myproc>
  if(addr >= curproc->sz)
80104cc3:	3b 18                	cmp    (%eax),%ebx
80104cc5:	73 31                	jae    80104cf8 <argstr+0x68>
  *pp = (char*)addr;
80104cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ccc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104cce:	39 d3                	cmp    %edx,%ebx
80104cd0:	73 26                	jae    80104cf8 <argstr+0x68>
80104cd2:	89 d8                	mov    %ebx,%eax
80104cd4:	eb 11                	jmp    80104ce7 <argstr+0x57>
80104cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
80104ce0:	83 c0 01             	add    $0x1,%eax
80104ce3:	39 c2                	cmp    %eax,%edx
80104ce5:	76 11                	jbe    80104cf8 <argstr+0x68>
    if(*s == 0)
80104ce7:	80 38 00             	cmpb   $0x0,(%eax)
80104cea:	75 f4                	jne    80104ce0 <argstr+0x50>
      return s - *pp;
80104cec:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104cee:	5b                   	pop    %ebx
80104cef:	5e                   	pop    %esi
80104cf0:	5d                   	pop    %ebp
80104cf1:	c3                   	ret    
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cf8:	5b                   	pop    %ebx
    return -1;
80104cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cfe:	5e                   	pop    %esi
80104cff:	5d                   	pop    %ebp
80104d00:	c3                   	ret    
80104d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0f:	90                   	nop

80104d10 <syscall>:
[SYS_enable_cow] sys_enable_cow,
};

void
syscall(void)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	53                   	push   %ebx
80104d14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d17:	e8 04 ef ff ff       	call   80103c20 <myproc>
80104d1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d1e:	8b 40 18             	mov    0x18(%eax),%eax
80104d21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d27:	83 fa 17             	cmp    $0x17,%edx
80104d2a:	77 24                	ja     80104d50 <syscall+0x40>
80104d2c:	8b 14 85 20 7e 10 80 	mov    -0x7fef81e0(,%eax,4),%edx
80104d33:	85 d2                	test   %edx,%edx
80104d35:	74 19                	je     80104d50 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d37:	ff d2                	call   *%edx
80104d39:	89 c2                	mov    %eax,%edx
80104d3b:	8b 43 18             	mov    0x18(%ebx),%eax
80104d3e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d44:	c9                   	leave  
80104d45:	c3                   	ret    
80104d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d50:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d51:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d54:	50                   	push   %eax
80104d55:	ff 73 10             	pushl  0x10(%ebx)
80104d58:	68 f1 7d 10 80       	push   $0x80107df1
80104d5d:	e8 1e b9 ff ff       	call   80100680 <cprintf>
    curproc->tf->eax = -1;
80104d62:	8b 43 18             	mov    0x18(%ebx),%eax
80104d65:	83 c4 10             	add    $0x10,%esp
80104d68:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d72:	c9                   	leave  
80104d73:	c3                   	ret    
80104d74:	66 90                	xchg   %ax,%ax
80104d76:	66 90                	xchg   %ax,%ax
80104d78:	66 90                	xchg   %ax,%ax
80104d7a:	66 90                	xchg   %ax,%ax
80104d7c:	66 90                	xchg   %ax,%ax
80104d7e:	66 90                	xchg   %ax,%ax

80104d80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d85:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d88:	53                   	push   %ebx
80104d89:	83 ec 44             	sub    $0x44,%esp
80104d8c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104d8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d92:	57                   	push   %edi
80104d93:	50                   	push   %eax
{
80104d94:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104d97:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d9a:	e8 51 d4 ff ff       	call   801021f0 <nameiparent>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	0f 84 46 01 00 00    	je     80104ef0 <create+0x170>
    return 0;
  ilock(dp);
80104daa:	83 ec 0c             	sub    $0xc,%esp
80104dad:	89 c3                	mov    %eax,%ebx
80104daf:	50                   	push   %eax
80104db0:	e8 fb ca ff ff       	call   801018b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104db5:	83 c4 0c             	add    $0xc,%esp
80104db8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104dbb:	50                   	push   %eax
80104dbc:	57                   	push   %edi
80104dbd:	53                   	push   %ebx
80104dbe:	e8 4d d0 ff ff       	call   80101e10 <dirlookup>
80104dc3:	83 c4 10             	add    $0x10,%esp
80104dc6:	89 c6                	mov    %eax,%esi
80104dc8:	85 c0                	test   %eax,%eax
80104dca:	74 54                	je     80104e20 <create+0xa0>
    iunlockput(dp);
80104dcc:	83 ec 0c             	sub    $0xc,%esp
80104dcf:	53                   	push   %ebx
80104dd0:	e8 6b cd ff ff       	call   80101b40 <iunlockput>
    ilock(ip);
80104dd5:	89 34 24             	mov    %esi,(%esp)
80104dd8:	e8 d3 ca ff ff       	call   801018b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104de5:	75 19                	jne    80104e00 <create+0x80>
80104de7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104dec:	75 12                	jne    80104e00 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104df1:	89 f0                	mov    %esi,%eax
80104df3:	5b                   	pop    %ebx
80104df4:	5e                   	pop    %esi
80104df5:	5f                   	pop    %edi
80104df6:	5d                   	pop    %ebp
80104df7:	c3                   	ret    
80104df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dff:	90                   	nop
    iunlockput(ip);
80104e00:	83 ec 0c             	sub    $0xc,%esp
80104e03:	56                   	push   %esi
    return 0;
80104e04:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e06:	e8 35 cd ff ff       	call   80101b40 <iunlockput>
    return 0;
80104e0b:	83 c4 10             	add    $0x10,%esp
}
80104e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e11:	89 f0                	mov    %esi,%eax
80104e13:	5b                   	pop    %ebx
80104e14:	5e                   	pop    %esi
80104e15:	5f                   	pop    %edi
80104e16:	5d                   	pop    %ebp
80104e17:	c3                   	ret    
80104e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e20:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104e24:	83 ec 08             	sub    $0x8,%esp
80104e27:	50                   	push   %eax
80104e28:	ff 33                	pushl  (%ebx)
80104e2a:	e8 11 c9 ff ff       	call   80101740 <ialloc>
80104e2f:	83 c4 10             	add    $0x10,%esp
80104e32:	89 c6                	mov    %eax,%esi
80104e34:	85 c0                	test   %eax,%eax
80104e36:	0f 84 cd 00 00 00    	je     80104f09 <create+0x189>
  ilock(ip);
80104e3c:	83 ec 0c             	sub    $0xc,%esp
80104e3f:	50                   	push   %eax
80104e40:	e8 6b ca ff ff       	call   801018b0 <ilock>
  ip->major = major;
80104e45:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104e49:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e4d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104e51:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e55:	b8 01 00 00 00       	mov    $0x1,%eax
80104e5a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e5e:	89 34 24             	mov    %esi,(%esp)
80104e61:	e8 9a c9 ff ff       	call   80101800 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e66:	83 c4 10             	add    $0x10,%esp
80104e69:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104e6e:	74 30                	je     80104ea0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e70:	83 ec 04             	sub    $0x4,%esp
80104e73:	ff 76 04             	pushl  0x4(%esi)
80104e76:	57                   	push   %edi
80104e77:	53                   	push   %ebx
80104e78:	e8 93 d2 ff ff       	call   80102110 <dirlink>
80104e7d:	83 c4 10             	add    $0x10,%esp
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 78                	js     80104efc <create+0x17c>
  iunlockput(dp);
80104e84:	83 ec 0c             	sub    $0xc,%esp
80104e87:	53                   	push   %ebx
80104e88:	e8 b3 cc ff ff       	call   80101b40 <iunlockput>
  return ip;
80104e8d:	83 c4 10             	add    $0x10,%esp
}
80104e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e93:	89 f0                	mov    %esi,%eax
80104e95:	5b                   	pop    %ebx
80104e96:	5e                   	pop    %esi
80104e97:	5f                   	pop    %edi
80104e98:	5d                   	pop    %ebp
80104e99:	c3                   	ret    
80104e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ea0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ea3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ea8:	53                   	push   %ebx
80104ea9:	e8 52 c9 ff ff       	call   80101800 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104eae:	83 c4 0c             	add    $0xc,%esp
80104eb1:	ff 76 04             	pushl  0x4(%esi)
80104eb4:	68 a0 7e 10 80       	push   $0x80107ea0
80104eb9:	56                   	push   %esi
80104eba:	e8 51 d2 ff ff       	call   80102110 <dirlink>
80104ebf:	83 c4 10             	add    $0x10,%esp
80104ec2:	85 c0                	test   %eax,%eax
80104ec4:	78 18                	js     80104ede <create+0x15e>
80104ec6:	83 ec 04             	sub    $0x4,%esp
80104ec9:	ff 73 04             	pushl  0x4(%ebx)
80104ecc:	68 9f 7e 10 80       	push   $0x80107e9f
80104ed1:	56                   	push   %esi
80104ed2:	e8 39 d2 ff ff       	call   80102110 <dirlink>
80104ed7:	83 c4 10             	add    $0x10,%esp
80104eda:	85 c0                	test   %eax,%eax
80104edc:	79 92                	jns    80104e70 <create+0xf0>
      panic("create dots");
80104ede:	83 ec 0c             	sub    $0xc,%esp
80104ee1:	68 93 7e 10 80       	push   $0x80107e93
80104ee6:	e8 95 b4 ff ff       	call   80100380 <panic>
80104eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop
}
80104ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ef3:	31 f6                	xor    %esi,%esi
}
80104ef5:	5b                   	pop    %ebx
80104ef6:	89 f0                	mov    %esi,%eax
80104ef8:	5e                   	pop    %esi
80104ef9:	5f                   	pop    %edi
80104efa:	5d                   	pop    %ebp
80104efb:	c3                   	ret    
    panic("create: dirlink");
80104efc:	83 ec 0c             	sub    $0xc,%esp
80104eff:	68 a2 7e 10 80       	push   $0x80107ea2
80104f04:	e8 77 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	68 84 7e 10 80       	push   $0x80107e84
80104f11:	e8 6a b4 ff ff       	call   80100380 <panic>
80104f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi

80104f20 <sys_dup>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2b:	50                   	push   %eax
80104f2c:	6a 00                	push   $0x0
80104f2e:	e8 9d fc ff ff       	call   80104bd0 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 36                	js     80104f70 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f3e:	77 30                	ja     80104f70 <sys_dup+0x50>
80104f40:	e8 db ec ff ff       	call   80103c20 <myproc>
80104f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f4c:	85 f6                	test   %esi,%esi
80104f4e:	74 20                	je     80104f70 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f50:	e8 cb ec ff ff       	call   80103c20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f55:	31 db                	xor    %ebx,%ebx
80104f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104f60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f64:	85 d2                	test   %edx,%edx
80104f66:	74 18                	je     80104f80 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f68:	83 c3 01             	add    $0x1,%ebx
80104f6b:	83 fb 10             	cmp    $0x10,%ebx
80104f6e:	75 f0                	jne    80104f60 <sys_dup+0x40>
}
80104f70:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f78:	89 d8                	mov    %ebx,%eax
80104f7a:	5b                   	pop    %ebx
80104f7b:	5e                   	pop    %esi
80104f7c:	5d                   	pop    %ebp
80104f7d:	c3                   	ret    
80104f7e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f80:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f83:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f87:	56                   	push   %esi
80104f88:	e8 33 c0 ff ff       	call   80100fc0 <filedup>
  return fd;
80104f8d:	83 c4 10             	add    $0x10,%esp
}
80104f90:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f93:	89 d8                	mov    %ebx,%eax
80104f95:	5b                   	pop    %ebx
80104f96:	5e                   	pop    %esi
80104f97:	5d                   	pop    %ebp
80104f98:	c3                   	ret    
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fa0 <sys_read>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fa5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fab:	53                   	push   %ebx
80104fac:	6a 00                	push   $0x0
80104fae:	e8 1d fc ff ff       	call   80104bd0 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 5e                	js     80105018 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 58                	ja     80105018 <sys_read+0x78>
80104fc0:	e8 5b ec ff ff       	call   80103c20 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fcc:	85 f6                	test   %esi,%esi
80104fce:	74 48                	je     80105018 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd0:	83 ec 08             	sub    $0x8,%esp
80104fd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd6:	50                   	push   %eax
80104fd7:	6a 02                	push   $0x2
80104fd9:	e8 f2 fb ff ff       	call   80104bd0 <argint>
80104fde:	83 c4 10             	add    $0x10,%esp
80104fe1:	85 c0                	test   %eax,%eax
80104fe3:	78 33                	js     80105018 <sys_read+0x78>
80104fe5:	83 ec 04             	sub    $0x4,%esp
80104fe8:	ff 75 f0             	pushl  -0x10(%ebp)
80104feb:	53                   	push   %ebx
80104fec:	6a 01                	push   $0x1
80104fee:	e8 2d fc ff ff       	call   80104c20 <argptr>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 1e                	js     80105018 <sys_read+0x78>
  return fileread(f, p, n);
80104ffa:	83 ec 04             	sub    $0x4,%esp
80104ffd:	ff 75 f0             	pushl  -0x10(%ebp)
80105000:	ff 75 f4             	pushl  -0xc(%ebp)
80105003:	56                   	push   %esi
80105004:	e8 37 c1 ff ff       	call   80101140 <fileread>
80105009:	83 c4 10             	add    $0x10,%esp
}
8010500c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010500f:	5b                   	pop    %ebx
80105010:	5e                   	pop    %esi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret    
80105013:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105017:	90                   	nop
    return -1;
80105018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501d:	eb ed                	jmp    8010500c <sys_read+0x6c>
8010501f:	90                   	nop

80105020 <sys_write>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105025:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105028:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010502b:	53                   	push   %ebx
8010502c:	6a 00                	push   $0x0
8010502e:	e8 9d fb ff ff       	call   80104bd0 <argint>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 5e                	js     80105098 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010503a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010503e:	77 58                	ja     80105098 <sys_write+0x78>
80105040:	e8 db eb ff ff       	call   80103c20 <myproc>
80105045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105048:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010504c:	85 f6                	test   %esi,%esi
8010504e:	74 48                	je     80105098 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105050:	83 ec 08             	sub    $0x8,%esp
80105053:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105056:	50                   	push   %eax
80105057:	6a 02                	push   $0x2
80105059:	e8 72 fb ff ff       	call   80104bd0 <argint>
8010505e:	83 c4 10             	add    $0x10,%esp
80105061:	85 c0                	test   %eax,%eax
80105063:	78 33                	js     80105098 <sys_write+0x78>
80105065:	83 ec 04             	sub    $0x4,%esp
80105068:	ff 75 f0             	pushl  -0x10(%ebp)
8010506b:	53                   	push   %ebx
8010506c:	6a 01                	push   $0x1
8010506e:	e8 ad fb ff ff       	call   80104c20 <argptr>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 1e                	js     80105098 <sys_write+0x78>
  return filewrite(f, p, n);
8010507a:	83 ec 04             	sub    $0x4,%esp
8010507d:	ff 75 f0             	pushl  -0x10(%ebp)
80105080:	ff 75 f4             	pushl  -0xc(%ebp)
80105083:	56                   	push   %esi
80105084:	e8 47 c1 ff ff       	call   801011d0 <filewrite>
80105089:	83 c4 10             	add    $0x10,%esp
}
8010508c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010508f:	5b                   	pop    %ebx
80105090:	5e                   	pop    %esi
80105091:	5d                   	pop    %ebp
80105092:	c3                   	ret    
80105093:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105097:	90                   	nop
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb ed                	jmp    8010508c <sys_write+0x6c>
8010509f:	90                   	nop

801050a0 <sys_close>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050ab:	50                   	push   %eax
801050ac:	6a 00                	push   $0x0
801050ae:	e8 1d fb ff ff       	call   80104bd0 <argint>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	78 3e                	js     801050f8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050be:	77 38                	ja     801050f8 <sys_close+0x58>
801050c0:	e8 5b eb ff ff       	call   80103c20 <myproc>
801050c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050c8:	8d 5a 08             	lea    0x8(%edx),%ebx
801050cb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801050cf:	85 f6                	test   %esi,%esi
801050d1:	74 25                	je     801050f8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801050d3:	e8 48 eb ff ff       	call   80103c20 <myproc>
  fileclose(f);
801050d8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050db:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801050e2:	00 
  fileclose(f);
801050e3:	56                   	push   %esi
801050e4:	e8 27 bf ff ff       	call   80101010 <fileclose>
  return 0;
801050e9:	83 c4 10             	add    $0x10,%esp
801050ec:	31 c0                	xor    %eax,%eax
}
801050ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050f1:	5b                   	pop    %ebx
801050f2:	5e                   	pop    %esi
801050f3:	5d                   	pop    %ebp
801050f4:	c3                   	ret    
801050f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fd:	eb ef                	jmp    801050ee <sys_close+0x4e>
801050ff:	90                   	nop

80105100 <sys_fstat>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105105:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105108:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010510b:	53                   	push   %ebx
8010510c:	6a 00                	push   $0x0
8010510e:	e8 bd fa ff ff       	call   80104bd0 <argint>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	78 46                	js     80105160 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010511a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010511e:	77 40                	ja     80105160 <sys_fstat+0x60>
80105120:	e8 fb ea ff ff       	call   80103c20 <myproc>
80105125:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105128:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010512c:	85 f6                	test   %esi,%esi
8010512e:	74 30                	je     80105160 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105130:	83 ec 04             	sub    $0x4,%esp
80105133:	6a 14                	push   $0x14
80105135:	53                   	push   %ebx
80105136:	6a 01                	push   $0x1
80105138:	e8 e3 fa ff ff       	call   80104c20 <argptr>
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	85 c0                	test   %eax,%eax
80105142:	78 1c                	js     80105160 <sys_fstat+0x60>
  return filestat(f, st);
80105144:	83 ec 08             	sub    $0x8,%esp
80105147:	ff 75 f4             	pushl  -0xc(%ebp)
8010514a:	56                   	push   %esi
8010514b:	e8 a0 bf ff ff       	call   801010f0 <filestat>
80105150:	83 c4 10             	add    $0x10,%esp
}
80105153:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105156:	5b                   	pop    %ebx
80105157:	5e                   	pop    %esi
80105158:	5d                   	pop    %ebp
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105165:	eb ec                	jmp    80105153 <sys_fstat+0x53>
80105167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516e:	66 90                	xchg   %ax,%ax

80105170 <sys_link>:
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105175:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105178:	53                   	push   %ebx
80105179:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010517c:	50                   	push   %eax
8010517d:	6a 00                	push   $0x0
8010517f:	e8 0c fb ff ff       	call   80104c90 <argstr>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	85 c0                	test   %eax,%eax
80105189:	0f 88 fb 00 00 00    	js     8010528a <sys_link+0x11a>
8010518f:	83 ec 08             	sub    $0x8,%esp
80105192:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105195:	50                   	push   %eax
80105196:	6a 01                	push   $0x1
80105198:	e8 f3 fa ff ff       	call   80104c90 <argstr>
8010519d:	83 c4 10             	add    $0x10,%esp
801051a0:	85 c0                	test   %eax,%eax
801051a2:	0f 88 e2 00 00 00    	js     8010528a <sys_link+0x11a>
  begin_op();
801051a8:	e8 53 de ff ff       	call   80103000 <begin_op>
  if((ip = namei(old)) == 0){
801051ad:	83 ec 0c             	sub    $0xc,%esp
801051b0:	ff 75 d4             	pushl  -0x2c(%ebp)
801051b3:	e8 18 d0 ff ff       	call   801021d0 <namei>
801051b8:	83 c4 10             	add    $0x10,%esp
801051bb:	89 c3                	mov    %eax,%ebx
801051bd:	85 c0                	test   %eax,%eax
801051bf:	0f 84 e4 00 00 00    	je     801052a9 <sys_link+0x139>
  ilock(ip);
801051c5:	83 ec 0c             	sub    $0xc,%esp
801051c8:	50                   	push   %eax
801051c9:	e8 e2 c6 ff ff       	call   801018b0 <ilock>
  if(ip->type == T_DIR){
801051ce:	83 c4 10             	add    $0x10,%esp
801051d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051d6:	0f 84 b5 00 00 00    	je     80105291 <sys_link+0x121>
  iupdate(ip);
801051dc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801051df:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051e7:	53                   	push   %ebx
801051e8:	e8 13 c6 ff ff       	call   80101800 <iupdate>
  iunlock(ip);
801051ed:	89 1c 24             	mov    %ebx,(%esp)
801051f0:	e8 9b c7 ff ff       	call   80101990 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051f5:	58                   	pop    %eax
801051f6:	5a                   	pop    %edx
801051f7:	57                   	push   %edi
801051f8:	ff 75 d0             	pushl  -0x30(%ebp)
801051fb:	e8 f0 cf ff ff       	call   801021f0 <nameiparent>
80105200:	83 c4 10             	add    $0x10,%esp
80105203:	89 c6                	mov    %eax,%esi
80105205:	85 c0                	test   %eax,%eax
80105207:	74 5b                	je     80105264 <sys_link+0xf4>
  ilock(dp);
80105209:	83 ec 0c             	sub    $0xc,%esp
8010520c:	50                   	push   %eax
8010520d:	e8 9e c6 ff ff       	call   801018b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105212:	8b 03                	mov    (%ebx),%eax
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	39 06                	cmp    %eax,(%esi)
80105219:	75 3d                	jne    80105258 <sys_link+0xe8>
8010521b:	83 ec 04             	sub    $0x4,%esp
8010521e:	ff 73 04             	pushl  0x4(%ebx)
80105221:	57                   	push   %edi
80105222:	56                   	push   %esi
80105223:	e8 e8 ce ff ff       	call   80102110 <dirlink>
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	85 c0                	test   %eax,%eax
8010522d:	78 29                	js     80105258 <sys_link+0xe8>
  iunlockput(dp);
8010522f:	83 ec 0c             	sub    $0xc,%esp
80105232:	56                   	push   %esi
80105233:	e8 08 c9 ff ff       	call   80101b40 <iunlockput>
  iput(ip);
80105238:	89 1c 24             	mov    %ebx,(%esp)
8010523b:	e8 a0 c7 ff ff       	call   801019e0 <iput>
  end_op();
80105240:	e8 2b de ff ff       	call   80103070 <end_op>
  return 0;
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	31 c0                	xor    %eax,%eax
}
8010524a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010524d:	5b                   	pop    %ebx
8010524e:	5e                   	pop    %esi
8010524f:	5f                   	pop    %edi
80105250:	5d                   	pop    %ebp
80105251:	c3                   	ret    
80105252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105258:	83 ec 0c             	sub    $0xc,%esp
8010525b:	56                   	push   %esi
8010525c:	e8 df c8 ff ff       	call   80101b40 <iunlockput>
    goto bad;
80105261:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	53                   	push   %ebx
80105268:	e8 43 c6 ff ff       	call   801018b0 <ilock>
  ip->nlink--;
8010526d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105272:	89 1c 24             	mov    %ebx,(%esp)
80105275:	e8 86 c5 ff ff       	call   80101800 <iupdate>
  iunlockput(ip);
8010527a:	89 1c 24             	mov    %ebx,(%esp)
8010527d:	e8 be c8 ff ff       	call   80101b40 <iunlockput>
  end_op();
80105282:	e8 e9 dd ff ff       	call   80103070 <end_op>
  return -1;
80105287:	83 c4 10             	add    $0x10,%esp
8010528a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528f:	eb b9                	jmp    8010524a <sys_link+0xda>
    iunlockput(ip);
80105291:	83 ec 0c             	sub    $0xc,%esp
80105294:	53                   	push   %ebx
80105295:	e8 a6 c8 ff ff       	call   80101b40 <iunlockput>
    end_op();
8010529a:	e8 d1 dd ff ff       	call   80103070 <end_op>
    return -1;
8010529f:	83 c4 10             	add    $0x10,%esp
801052a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a7:	eb a1                	jmp    8010524a <sys_link+0xda>
    end_op();
801052a9:	e8 c2 dd ff ff       	call   80103070 <end_op>
    return -1;
801052ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b3:	eb 95                	jmp    8010524a <sys_link+0xda>
801052b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_unlink>:
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801052c5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052c8:	53                   	push   %ebx
801052c9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801052cc:	50                   	push   %eax
801052cd:	6a 00                	push   $0x0
801052cf:	e8 bc f9 ff ff       	call   80104c90 <argstr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	0f 88 7a 01 00 00    	js     80105459 <sys_unlink+0x199>
  begin_op();
801052df:	e8 1c dd ff ff       	call   80103000 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052e4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052e7:	83 ec 08             	sub    $0x8,%esp
801052ea:	53                   	push   %ebx
801052eb:	ff 75 c0             	pushl  -0x40(%ebp)
801052ee:	e8 fd ce ff ff       	call   801021f0 <nameiparent>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052f9:	85 c0                	test   %eax,%eax
801052fb:	0f 84 62 01 00 00    	je     80105463 <sys_unlink+0x1a3>
  ilock(dp);
80105301:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	57                   	push   %edi
80105308:	e8 a3 c5 ff ff       	call   801018b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010530d:	58                   	pop    %eax
8010530e:	5a                   	pop    %edx
8010530f:	68 a0 7e 10 80       	push   $0x80107ea0
80105314:	53                   	push   %ebx
80105315:	e8 d6 ca ff ff       	call   80101df0 <namecmp>
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	85 c0                	test   %eax,%eax
8010531f:	0f 84 fb 00 00 00    	je     80105420 <sys_unlink+0x160>
80105325:	83 ec 08             	sub    $0x8,%esp
80105328:	68 9f 7e 10 80       	push   $0x80107e9f
8010532d:	53                   	push   %ebx
8010532e:	e8 bd ca ff ff       	call   80101df0 <namecmp>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	0f 84 e2 00 00 00    	je     80105420 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010533e:	83 ec 04             	sub    $0x4,%esp
80105341:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105344:	50                   	push   %eax
80105345:	53                   	push   %ebx
80105346:	57                   	push   %edi
80105347:	e8 c4 ca ff ff       	call   80101e10 <dirlookup>
8010534c:	83 c4 10             	add    $0x10,%esp
8010534f:	89 c3                	mov    %eax,%ebx
80105351:	85 c0                	test   %eax,%eax
80105353:	0f 84 c7 00 00 00    	je     80105420 <sys_unlink+0x160>
  ilock(ip);
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	50                   	push   %eax
8010535d:	e8 4e c5 ff ff       	call   801018b0 <ilock>
  if(ip->nlink < 1)
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010536a:	0f 8e 1c 01 00 00    	jle    8010548c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105370:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105375:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105378:	74 66                	je     801053e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010537a:	83 ec 04             	sub    $0x4,%esp
8010537d:	6a 10                	push   $0x10
8010537f:	6a 00                	push   $0x0
80105381:	57                   	push   %edi
80105382:	e8 89 f5 ff ff       	call   80104910 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105387:	6a 10                	push   $0x10
80105389:	ff 75 c4             	pushl  -0x3c(%ebp)
8010538c:	57                   	push   %edi
8010538d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105390:	e8 2b c9 ff ff       	call   80101cc0 <writei>
80105395:	83 c4 20             	add    $0x20,%esp
80105398:	83 f8 10             	cmp    $0x10,%eax
8010539b:	0f 85 de 00 00 00    	jne    8010547f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801053a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053a6:	0f 84 94 00 00 00    	je     80105440 <sys_unlink+0x180>
  iunlockput(dp);
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	ff 75 b4             	pushl  -0x4c(%ebp)
801053b2:	e8 89 c7 ff ff       	call   80101b40 <iunlockput>
  ip->nlink--;
801053b7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053bc:	89 1c 24             	mov    %ebx,(%esp)
801053bf:	e8 3c c4 ff ff       	call   80101800 <iupdate>
  iunlockput(ip);
801053c4:	89 1c 24             	mov    %ebx,(%esp)
801053c7:	e8 74 c7 ff ff       	call   80101b40 <iunlockput>
  end_op();
801053cc:	e8 9f dc ff ff       	call   80103070 <end_op>
  return 0;
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	31 c0                	xor    %eax,%eax
}
801053d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d9:	5b                   	pop    %ebx
801053da:	5e                   	pop    %esi
801053db:	5f                   	pop    %edi
801053dc:	5d                   	pop    %ebp
801053dd:	c3                   	ret    
801053de:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053e4:	76 94                	jbe    8010537a <sys_unlink+0xba>
801053e6:	be 20 00 00 00       	mov    $0x20,%esi
801053eb:	eb 0b                	jmp    801053f8 <sys_unlink+0x138>
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
801053f0:	83 c6 10             	add    $0x10,%esi
801053f3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053f6:	73 82                	jae    8010537a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053f8:	6a 10                	push   $0x10
801053fa:	56                   	push   %esi
801053fb:	57                   	push   %edi
801053fc:	53                   	push   %ebx
801053fd:	e8 be c7 ff ff       	call   80101bc0 <readi>
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	83 f8 10             	cmp    $0x10,%eax
80105408:	75 68                	jne    80105472 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010540a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010540f:	74 df                	je     801053f0 <sys_unlink+0x130>
    iunlockput(ip);
80105411:	83 ec 0c             	sub    $0xc,%esp
80105414:	53                   	push   %ebx
80105415:	e8 26 c7 ff ff       	call   80101b40 <iunlockput>
    goto bad;
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	ff 75 b4             	pushl  -0x4c(%ebp)
80105426:	e8 15 c7 ff ff       	call   80101b40 <iunlockput>
  end_op();
8010542b:	e8 40 dc ff ff       	call   80103070 <end_op>
  return -1;
80105430:	83 c4 10             	add    $0x10,%esp
80105433:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105438:	eb 9c                	jmp    801053d6 <sys_unlink+0x116>
8010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105440:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105443:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105446:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010544b:	50                   	push   %eax
8010544c:	e8 af c3 ff ff       	call   80101800 <iupdate>
80105451:	83 c4 10             	add    $0x10,%esp
80105454:	e9 53 ff ff ff       	jmp    801053ac <sys_unlink+0xec>
    return -1;
80105459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545e:	e9 73 ff ff ff       	jmp    801053d6 <sys_unlink+0x116>
    end_op();
80105463:	e8 08 dc ff ff       	call   80103070 <end_op>
    return -1;
80105468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546d:	e9 64 ff ff ff       	jmp    801053d6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105472:	83 ec 0c             	sub    $0xc,%esp
80105475:	68 c4 7e 10 80       	push   $0x80107ec4
8010547a:	e8 01 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010547f:	83 ec 0c             	sub    $0xc,%esp
80105482:	68 d6 7e 10 80       	push   $0x80107ed6
80105487:	e8 f4 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	68 b2 7e 10 80       	push   $0x80107eb2
80105494:	e8 e7 ae ff ff       	call   80100380 <panic>
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_open>:

int
sys_open(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054a8:	53                   	push   %ebx
801054a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054ac:	50                   	push   %eax
801054ad:	6a 00                	push   $0x0
801054af:	e8 dc f7 ff ff       	call   80104c90 <argstr>
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	85 c0                	test   %eax,%eax
801054b9:	0f 88 8e 00 00 00    	js     8010554d <sys_open+0xad>
801054bf:	83 ec 08             	sub    $0x8,%esp
801054c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054c5:	50                   	push   %eax
801054c6:	6a 01                	push   $0x1
801054c8:	e8 03 f7 ff ff       	call   80104bd0 <argint>
801054cd:	83 c4 10             	add    $0x10,%esp
801054d0:	85 c0                	test   %eax,%eax
801054d2:	78 79                	js     8010554d <sys_open+0xad>
    return -1;

  begin_op();
801054d4:	e8 27 db ff ff       	call   80103000 <begin_op>

  if(omode & O_CREATE){
801054d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054dd:	75 79                	jne    80105558 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054df:	83 ec 0c             	sub    $0xc,%esp
801054e2:	ff 75 e0             	pushl  -0x20(%ebp)
801054e5:	e8 e6 cc ff ff       	call   801021d0 <namei>
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	89 c6                	mov    %eax,%esi
801054ef:	85 c0                	test   %eax,%eax
801054f1:	0f 84 7e 00 00 00    	je     80105575 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801054f7:	83 ec 0c             	sub    $0xc,%esp
801054fa:	50                   	push   %eax
801054fb:	e8 b0 c3 ff ff       	call   801018b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105500:	83 c4 10             	add    $0x10,%esp
80105503:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105508:	0f 84 c2 00 00 00    	je     801055d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010550e:	e8 3d ba ff ff       	call   80100f50 <filealloc>
80105513:	89 c7                	mov    %eax,%edi
80105515:	85 c0                	test   %eax,%eax
80105517:	74 23                	je     8010553c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105519:	e8 02 e7 ff ff       	call   80103c20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010551e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105520:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105524:	85 d2                	test   %edx,%edx
80105526:	74 60                	je     80105588 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105528:	83 c3 01             	add    $0x1,%ebx
8010552b:	83 fb 10             	cmp    $0x10,%ebx
8010552e:	75 f0                	jne    80105520 <sys_open+0x80>
    if(f)
      fileclose(f);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	57                   	push   %edi
80105534:	e8 d7 ba ff ff       	call   80101010 <fileclose>
80105539:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010553c:	83 ec 0c             	sub    $0xc,%esp
8010553f:	56                   	push   %esi
80105540:	e8 fb c5 ff ff       	call   80101b40 <iunlockput>
    end_op();
80105545:	e8 26 db ff ff       	call   80103070 <end_op>
    return -1;
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105552:	eb 6d                	jmp    801055c1 <sys_open+0x121>
80105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105558:	83 ec 0c             	sub    $0xc,%esp
8010555b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010555e:	31 c9                	xor    %ecx,%ecx
80105560:	ba 02 00 00 00       	mov    $0x2,%edx
80105565:	6a 00                	push   $0x0
80105567:	e8 14 f8 ff ff       	call   80104d80 <create>
    if(ip == 0){
8010556c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010556f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105571:	85 c0                	test   %eax,%eax
80105573:	75 99                	jne    8010550e <sys_open+0x6e>
      end_op();
80105575:	e8 f6 da ff ff       	call   80103070 <end_op>
      return -1;
8010557a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010557f:	eb 40                	jmp    801055c1 <sys_open+0x121>
80105581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105588:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010558b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010558f:	56                   	push   %esi
80105590:	e8 fb c3 ff ff       	call   80101990 <iunlock>
  end_op();
80105595:	e8 d6 da ff ff       	call   80103070 <end_op>

  f->type = FD_INODE;
8010559a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801055a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055b2:	f7 d0                	not    %eax
801055b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c4:	89 d8                	mov    %ebx,%eax
801055c6:	5b                   	pop    %ebx
801055c7:	5e                   	pop    %esi
801055c8:	5f                   	pop    %edi
801055c9:	5d                   	pop    %ebp
801055ca:	c3                   	ret    
801055cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801055d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055d3:	85 c9                	test   %ecx,%ecx
801055d5:	0f 84 33 ff ff ff    	je     8010550e <sys_open+0x6e>
801055db:	e9 5c ff ff ff       	jmp    8010553c <sys_open+0x9c>

801055e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055e6:	e8 15 da ff ff       	call   80103000 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055eb:	83 ec 08             	sub    $0x8,%esp
801055ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f1:	50                   	push   %eax
801055f2:	6a 00                	push   $0x0
801055f4:	e8 97 f6 ff ff       	call   80104c90 <argstr>
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	85 c0                	test   %eax,%eax
801055fe:	78 30                	js     80105630 <sys_mkdir+0x50>
80105600:	83 ec 0c             	sub    $0xc,%esp
80105603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105606:	31 c9                	xor    %ecx,%ecx
80105608:	ba 01 00 00 00       	mov    $0x1,%edx
8010560d:	6a 00                	push   $0x0
8010560f:	e8 6c f7 ff ff       	call   80104d80 <create>
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	85 c0                	test   %eax,%eax
80105619:	74 15                	je     80105630 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010561b:	83 ec 0c             	sub    $0xc,%esp
8010561e:	50                   	push   %eax
8010561f:	e8 1c c5 ff ff       	call   80101b40 <iunlockput>
  end_op();
80105624:	e8 47 da ff ff       	call   80103070 <end_op>
  return 0;
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	31 c0                	xor    %eax,%eax
}
8010562e:	c9                   	leave  
8010562f:	c3                   	ret    
    end_op();
80105630:	e8 3b da ff ff       	call   80103070 <end_op>
    return -1;
80105635:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010563a:	c9                   	leave  
8010563b:	c3                   	ret    
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_mknod>:

int
sys_mknod(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105646:	e8 b5 d9 ff ff       	call   80103000 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010564b:	83 ec 08             	sub    $0x8,%esp
8010564e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105651:	50                   	push   %eax
80105652:	6a 00                	push   $0x0
80105654:	e8 37 f6 ff ff       	call   80104c90 <argstr>
80105659:	83 c4 10             	add    $0x10,%esp
8010565c:	85 c0                	test   %eax,%eax
8010565e:	78 60                	js     801056c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105660:	83 ec 08             	sub    $0x8,%esp
80105663:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105666:	50                   	push   %eax
80105667:	6a 01                	push   $0x1
80105669:	e8 62 f5 ff ff       	call   80104bd0 <argint>
  if((argstr(0, &path)) < 0 ||
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	85 c0                	test   %eax,%eax
80105673:	78 4b                	js     801056c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105675:	83 ec 08             	sub    $0x8,%esp
80105678:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010567b:	50                   	push   %eax
8010567c:	6a 02                	push   $0x2
8010567e:	e8 4d f5 ff ff       	call   80104bd0 <argint>
     argint(1, &major) < 0 ||
80105683:	83 c4 10             	add    $0x10,%esp
80105686:	85 c0                	test   %eax,%eax
80105688:	78 36                	js     801056c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010568a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010568e:	83 ec 0c             	sub    $0xc,%esp
80105691:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105695:	ba 03 00 00 00       	mov    $0x3,%edx
8010569a:	50                   	push   %eax
8010569b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010569e:	e8 dd f6 ff ff       	call   80104d80 <create>
     argint(2, &minor) < 0 ||
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	74 16                	je     801056c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	50                   	push   %eax
801056ae:	e8 8d c4 ff ff       	call   80101b40 <iunlockput>
  end_op();
801056b3:	e8 b8 d9 ff ff       	call   80103070 <end_op>
  return 0;
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	31 c0                	xor    %eax,%eax
}
801056bd:	c9                   	leave  
801056be:	c3                   	ret    
801056bf:	90                   	nop
    end_op();
801056c0:	e8 ab d9 ff ff       	call   80103070 <end_op>
    return -1;
801056c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ca:	c9                   	leave  
801056cb:	c3                   	ret    
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_chdir>:

int
sys_chdir(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	56                   	push   %esi
801056d4:	53                   	push   %ebx
801056d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056d8:	e8 43 e5 ff ff       	call   80103c20 <myproc>
801056dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056df:	e8 1c d9 ff ff       	call   80103000 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056e4:	83 ec 08             	sub    $0x8,%esp
801056e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ea:	50                   	push   %eax
801056eb:	6a 00                	push   $0x0
801056ed:	e8 9e f5 ff ff       	call   80104c90 <argstr>
801056f2:	83 c4 10             	add    $0x10,%esp
801056f5:	85 c0                	test   %eax,%eax
801056f7:	78 77                	js     80105770 <sys_chdir+0xa0>
801056f9:	83 ec 0c             	sub    $0xc,%esp
801056fc:	ff 75 f4             	pushl  -0xc(%ebp)
801056ff:	e8 cc ca ff ff       	call   801021d0 <namei>
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	89 c3                	mov    %eax,%ebx
80105709:	85 c0                	test   %eax,%eax
8010570b:	74 63                	je     80105770 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010570d:	83 ec 0c             	sub    $0xc,%esp
80105710:	50                   	push   %eax
80105711:	e8 9a c1 ff ff       	call   801018b0 <ilock>
  if(ip->type != T_DIR){
80105716:	83 c4 10             	add    $0x10,%esp
80105719:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010571e:	75 30                	jne    80105750 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	53                   	push   %ebx
80105724:	e8 67 c2 ff ff       	call   80101990 <iunlock>
  iput(curproc->cwd);
80105729:	58                   	pop    %eax
8010572a:	ff 76 68             	pushl  0x68(%esi)
8010572d:	e8 ae c2 ff ff       	call   801019e0 <iput>
  end_op();
80105732:	e8 39 d9 ff ff       	call   80103070 <end_op>
  curproc->cwd = ip;
80105737:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	31 c0                	xor    %eax,%eax
}
8010573f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105742:	5b                   	pop    %ebx
80105743:	5e                   	pop    %esi
80105744:	5d                   	pop    %ebp
80105745:	c3                   	ret    
80105746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	53                   	push   %ebx
80105754:	e8 e7 c3 ff ff       	call   80101b40 <iunlockput>
    end_op();
80105759:	e8 12 d9 ff ff       	call   80103070 <end_op>
    return -1;
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105766:	eb d7                	jmp    8010573f <sys_chdir+0x6f>
80105768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576f:	90                   	nop
    end_op();
80105770:	e8 fb d8 ff ff       	call   80103070 <end_op>
    return -1;
80105775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577a:	eb c3                	jmp    8010573f <sys_chdir+0x6f>
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_exec>:

int
sys_exec(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105785:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010578b:	53                   	push   %ebx
8010578c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105792:	50                   	push   %eax
80105793:	6a 00                	push   $0x0
80105795:	e8 f6 f4 ff ff       	call   80104c90 <argstr>
8010579a:	83 c4 10             	add    $0x10,%esp
8010579d:	85 c0                	test   %eax,%eax
8010579f:	0f 88 87 00 00 00    	js     8010582c <sys_exec+0xac>
801057a5:	83 ec 08             	sub    $0x8,%esp
801057a8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057ae:	50                   	push   %eax
801057af:	6a 01                	push   $0x1
801057b1:	e8 1a f4 ff ff       	call   80104bd0 <argint>
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	85 c0                	test   %eax,%eax
801057bb:	78 6f                	js     8010582c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057bd:	83 ec 04             	sub    $0x4,%esp
801057c0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801057c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057c8:	68 80 00 00 00       	push   $0x80
801057cd:	6a 00                	push   $0x0
801057cf:	56                   	push   %esi
801057d0:	e8 3b f1 ff ff       	call   80104910 <memset>
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057df:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057e0:	83 ec 08             	sub    $0x8,%esp
801057e3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057e9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801057f0:	50                   	push   %eax
801057f1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057f7:	01 f8                	add    %edi,%eax
801057f9:	50                   	push   %eax
801057fa:	e8 41 f3 ff ff       	call   80104b40 <fetchint>
801057ff:	83 c4 10             	add    $0x10,%esp
80105802:	85 c0                	test   %eax,%eax
80105804:	78 26                	js     8010582c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105806:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010580c:	85 c0                	test   %eax,%eax
8010580e:	74 30                	je     80105840 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105810:	83 ec 08             	sub    $0x8,%esp
80105813:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105816:	52                   	push   %edx
80105817:	50                   	push   %eax
80105818:	e8 63 f3 ff ff       	call   80104b80 <fetchstr>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	78 08                	js     8010582c <sys_exec+0xac>
  for(i=0;; i++){
80105824:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105827:	83 fb 20             	cmp    $0x20,%ebx
8010582a:	75 b4                	jne    801057e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010582c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010582f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105834:	5b                   	pop    %ebx
80105835:	5e                   	pop    %esi
80105836:	5f                   	pop    %edi
80105837:	5d                   	pop    %ebp
80105838:	c3                   	ret    
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105840:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105847:	00 00 00 00 
  return exec(path, argv);
8010584b:	83 ec 08             	sub    $0x8,%esp
8010584e:	56                   	push   %esi
8010584f:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105855:	e8 76 b3 ff ff       	call   80100bd0 <exec>
8010585a:	83 c4 10             	add    $0x10,%esp
}
8010585d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105860:	5b                   	pop    %ebx
80105861:	5e                   	pop    %esi
80105862:	5f                   	pop    %edi
80105863:	5d                   	pop    %ebp
80105864:	c3                   	ret    
80105865:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105870 <sys_pipe>:

int
sys_pipe(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	57                   	push   %edi
80105874:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105875:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105878:	53                   	push   %ebx
80105879:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010587c:	6a 08                	push   $0x8
8010587e:	50                   	push   %eax
8010587f:	6a 00                	push   $0x0
80105881:	e8 9a f3 ff ff       	call   80104c20 <argptr>
80105886:	83 c4 10             	add    $0x10,%esp
80105889:	85 c0                	test   %eax,%eax
8010588b:	78 4a                	js     801058d7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010588d:	83 ec 08             	sub    $0x8,%esp
80105890:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105893:	50                   	push   %eax
80105894:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105897:	50                   	push   %eax
80105898:	e8 33 de ff ff       	call   801036d0 <pipealloc>
8010589d:	83 c4 10             	add    $0x10,%esp
801058a0:	85 c0                	test   %eax,%eax
801058a2:	78 33                	js     801058d7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058a7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058a9:	e8 72 e3 ff ff       	call   80103c20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801058b0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058b4:	85 f6                	test   %esi,%esi
801058b6:	74 28                	je     801058e0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801058b8:	83 c3 01             	add    $0x1,%ebx
801058bb:	83 fb 10             	cmp    $0x10,%ebx
801058be:	75 f0                	jne    801058b0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801058c0:	83 ec 0c             	sub    $0xc,%esp
801058c3:	ff 75 e0             	pushl  -0x20(%ebp)
801058c6:	e8 45 b7 ff ff       	call   80101010 <fileclose>
    fileclose(wf);
801058cb:	58                   	pop    %eax
801058cc:	ff 75 e4             	pushl  -0x1c(%ebp)
801058cf:	e8 3c b7 ff ff       	call   80101010 <fileclose>
    return -1;
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058dc:	eb 53                	jmp    80105931 <sys_pipe+0xc1>
801058de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058e0:	8d 73 08             	lea    0x8(%ebx),%esi
801058e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058ea:	e8 31 e3 ff ff       	call   80103c20 <myproc>
801058ef:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
801058f1:	31 c0                	xor    %eax,%eax
801058f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058f7:	90                   	nop
    if(curproc->ofile[fd] == 0){
801058f8:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
801058fc:	85 c9                	test   %ecx,%ecx
801058fe:	74 20                	je     80105920 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105900:	83 c0 01             	add    $0x1,%eax
80105903:	83 f8 10             	cmp    $0x10,%eax
80105906:	75 f0                	jne    801058f8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105908:	e8 13 e3 ff ff       	call   80103c20 <myproc>
8010590d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105914:	00 
80105915:	eb a9                	jmp    801058c0 <sys_pipe+0x50>
80105917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105920:	89 7c 82 28          	mov    %edi,0x28(%edx,%eax,4)
  }
  fd[0] = fd0;
80105924:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105927:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80105929:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010592c:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
8010592f:	31 c0                	xor    %eax,%eax
}
80105931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105934:	5b                   	pop    %ebx
80105935:	5e                   	pop    %esi
80105936:	5f                   	pop    %edi
80105937:	5d                   	pop    %ebp
80105938:	c3                   	ret    
80105939:	66 90                	xchg   %ax,%ax
8010593b:	66 90                	xchg   %ax,%ax
8010593d:	66 90                	xchg   %ax,%ax
8010593f:	90                   	nop

80105940 <sys_fork>:
extern int free_frame_cnt; // xv6 proj - cow

int
sys_fork(void)
{
  return fork();
80105940:	e9 9b e4 ff ff       	jmp    80103de0 <fork>
80105945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105950 <sys_exit>:
}

int
sys_exit(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 08             	sub    $0x8,%esp
  exit();
80105956:	e8 15 e7 ff ff       	call   80104070 <exit>
  return 0;  // not reached
}
8010595b:	31 c0                	xor    %eax,%eax
8010595d:	c9                   	leave  
8010595e:	c3                   	ret    
8010595f:	90                   	nop

80105960 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105960:	e9 3b e8 ff ff       	jmp    801041a0 <wait>
80105965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105970 <sys_kill>:
}

int
sys_kill(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105976:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105979:	50                   	push   %eax
8010597a:	6a 00                	push   $0x0
8010597c:	e8 4f f2 ff ff       	call   80104bd0 <argint>
80105981:	83 c4 10             	add    $0x10,%esp
80105984:	85 c0                	test   %eax,%eax
80105986:	78 18                	js     801059a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	ff 75 f4             	pushl  -0xc(%ebp)
8010598e:	e8 ad ea ff ff       	call   80104440 <kill>
80105993:	83 c4 10             	add    $0x10,%esp
}
80105996:	c9                   	leave  
80105997:	c3                   	ret    
80105998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599f:	90                   	nop
801059a0:	c9                   	leave  
    return -1;
801059a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059a6:	c3                   	ret    
801059a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <sys_getpid>:

int
sys_getpid(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059b6:	e8 65 e2 ff ff       	call   80103c20 <myproc>
801059bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801059be:	c9                   	leave  
801059bf:	c3                   	ret    

801059c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ca:	50                   	push   %eax
801059cb:	6a 00                	push   $0x0
801059cd:	e8 fe f1 ff ff       	call   80104bd0 <argint>
801059d2:	83 c4 10             	add    $0x10,%esp
801059d5:	85 c0                	test   %eax,%eax
801059d7:	78 27                	js     80105a00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059d9:	e8 42 e2 ff ff       	call   80103c20 <myproc>
  if(growproc(n) < 0)
801059de:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059e1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059e3:	ff 75 f4             	pushl  -0xc(%ebp)
801059e6:	e8 55 e3 ff ff       	call   80103d40 <growproc>
801059eb:	83 c4 10             	add    $0x10,%esp
801059ee:	85 c0                	test   %eax,%eax
801059f0:	78 0e                	js     80105a00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059f2:	89 d8                	mov    %ebx,%eax
801059f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059f7:	c9                   	leave  
801059f8:	c3                   	ret    
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a05:	eb eb                	jmp    801059f2 <sys_sbrk+0x32>
80105a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0e:	66 90                	xchg   %ax,%ax

80105a10 <sys_sleep>:

int
sys_sleep(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a1a:	50                   	push   %eax
80105a1b:	6a 00                	push   $0x0
80105a1d:	e8 ae f1 ff ff       	call   80104bd0 <argint>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	85 c0                	test   %eax,%eax
80105a27:	0f 88 8a 00 00 00    	js     80105ab7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a2d:	83 ec 0c             	sub    $0xc,%esp
80105a30:	68 c0 cc 14 80       	push   $0x8014ccc0
80105a35:	e8 66 ed ff ff       	call   801047a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a3d:	8b 1d a0 cc 14 80    	mov    0x8014cca0,%ebx
  while(ticks - ticks0 < n){
80105a43:	83 c4 10             	add    $0x10,%esp
80105a46:	85 d2                	test   %edx,%edx
80105a48:	75 27                	jne    80105a71 <sys_sleep+0x61>
80105a4a:	eb 54                	jmp    80105aa0 <sys_sleep+0x90>
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a50:	83 ec 08             	sub    $0x8,%esp
80105a53:	68 c0 cc 14 80       	push   $0x8014ccc0
80105a58:	68 a0 cc 14 80       	push   $0x8014cca0
80105a5d:	e8 be e8 ff ff       	call   80104320 <sleep>
  while(ticks - ticks0 < n){
80105a62:	a1 a0 cc 14 80       	mov    0x8014cca0,%eax
80105a67:	83 c4 10             	add    $0x10,%esp
80105a6a:	29 d8                	sub    %ebx,%eax
80105a6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a6f:	73 2f                	jae    80105aa0 <sys_sleep+0x90>
    if(myproc()->killed){
80105a71:	e8 aa e1 ff ff       	call   80103c20 <myproc>
80105a76:	8b 40 24             	mov    0x24(%eax),%eax
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	74 d3                	je     80105a50 <sys_sleep+0x40>
      release(&tickslock);
80105a7d:	83 ec 0c             	sub    $0xc,%esp
80105a80:	68 c0 cc 14 80       	push   $0x8014ccc0
80105a85:	e8 36 ee ff ff       	call   801048c0 <release>
  }
  release(&tickslock);
  return 0;
}
80105a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
80105a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105aa0:	83 ec 0c             	sub    $0xc,%esp
80105aa3:	68 c0 cc 14 80       	push   $0x8014ccc0
80105aa8:	e8 13 ee ff ff       	call   801048c0 <release>
  return 0;
80105aad:	83 c4 10             	add    $0x10,%esp
80105ab0:	31 c0                	xor    %eax,%eax
}
80105ab2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ab5:	c9                   	leave  
80105ab6:	c3                   	ret    
    return -1;
80105ab7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abc:	eb f4                	jmp    80105ab2 <sys_sleep+0xa2>
80105abe:	66 90                	xchg   %ax,%ax

80105ac0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
80105ac4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ac7:	68 c0 cc 14 80       	push   $0x8014ccc0
80105acc:	e8 cf ec ff ff       	call   801047a0 <acquire>
  xticks = ticks;
80105ad1:	8b 1d a0 cc 14 80    	mov    0x8014cca0,%ebx
  release(&tickslock);
80105ad7:	c7 04 24 c0 cc 14 80 	movl   $0x8014ccc0,(%esp)
80105ade:	e8 dd ed ff ff       	call   801048c0 <release>
  return xticks;
}
80105ae3:	89 d8                	mov    %ebx,%eax
80105ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ae8:	c9                   	leave  
80105ae9:	c3                   	ret    
80105aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105af0 <sys_shutdown>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105af0:	b8 00 20 00 00       	mov    $0x2000,%eax
80105af5:	ba 04 b0 ff ff       	mov    $0xffffb004,%edx
80105afa:	66 ef                	out    %ax,(%dx)
80105afc:	ba 04 06 00 00       	mov    $0x604,%edx
80105b01:	66 ef                	out    %ax,(%dx)
  outw(0xB004, 0x0|0x2000); // working for old qemu
  outw(0x604, 0x0|0x2000); // working for newer qemu
  
  return 0;
  
}
80105b03:	31 c0                	xor    %eax,%eax
80105b05:	c3                   	ret    
80105b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi

80105b10 <sys_get_free_frame_cnt>:

int sys_get_free_frame_cnt(void)
{
    return free_frame_cnt;
}
80105b10:	a1 40 26 11 80       	mov    0x80112640,%eax
80105b15:	c3                   	ret    
80105b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1d:	8d 76 00             	lea    0x0(%esi),%esi

80105b20 <sys_enable_cow>:


int sys_enable_cow(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 10             	sub    $0x10,%esp
  if(!argint(0,&type))
80105b26:	68 40 ad 14 80       	push   $0x8014ad40
80105b2b:	6a 00                	push   $0x0
80105b2d:	e8 9e f0 ff ff       	call   80104bd0 <argint>
80105b32:	83 c4 10             	add    $0x10,%esp
    return -1;
	return 0;
80105b35:	c9                   	leave  
  if(!argint(0,&type))
80105b36:	85 c0                	test   %eax,%eax
80105b38:	0f 94 c0             	sete   %al
80105b3b:	0f b6 c0             	movzbl %al,%eax
80105b3e:	f7 d8                	neg    %eax
80105b40:	c3                   	ret    

80105b41 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b41:	1e                   	push   %ds
  pushl %es
80105b42:	06                   	push   %es
  pushl %fs
80105b43:	0f a0                	push   %fs
  pushl %gs
80105b45:	0f a8                	push   %gs
  pushal
80105b47:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b48:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b4c:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b4e:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b50:	54                   	push   %esp
  call trap
80105b51:	e8 ca 00 00 00       	call   80105c20 <trap>
  addl $4, %esp
80105b56:	83 c4 04             	add    $0x4,%esp

80105b59 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b59:	61                   	popa   
  popl %gs
80105b5a:	0f a9                	pop    %gs
  popl %fs
80105b5c:	0f a1                	pop    %fs
  popl %es
80105b5e:	07                   	pop    %es
  popl %ds
80105b5f:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b60:	83 c4 08             	add    $0x8,%esp
  iret
80105b63:	cf                   	iret   

80105b64 <flush_tlb_all>:

# xv6 proj - cow
.globl flush_tlb_all
flush_tlb_all:
  movl %cr3,%eax
80105b64:	0f 20 d8             	mov    %cr3,%eax
  movl %eax, %cr3
80105b67:	0f 22 d8             	mov    %eax,%cr3
80105b6a:	c3                   	ret    
80105b6b:	66 90                	xchg   %ax,%ax
80105b6d:	66 90                	xchg   %ax,%ax
80105b6f:	90                   	nop

80105b70 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b70:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b71:	31 c0                	xor    %eax,%eax
{
80105b73:	89 e5                	mov    %esp,%ebp
80105b75:	83 ec 08             	sub    $0x8,%esp
80105b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b80:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105b87:	c7 04 c5 02 cd 14 80 	movl   $0x8e000008,-0x7feb32fe(,%eax,8)
80105b8e:	08 00 00 8e 
80105b92:	66 89 14 c5 00 cd 14 	mov    %dx,-0x7feb3300(,%eax,8)
80105b99:	80 
80105b9a:	c1 ea 10             	shr    $0x10,%edx
80105b9d:	66 89 14 c5 06 cd 14 	mov    %dx,-0x7feb32fa(,%eax,8)
80105ba4:	80 
  for(i = 0; i < 256; i++)
80105ba5:	83 c0 01             	add    $0x1,%eax
80105ba8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bad:	75 d1                	jne    80105b80 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105baf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bb2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105bb7:	c7 05 02 cf 14 80 08 	movl   $0xef000008,0x8014cf02
80105bbe:	00 00 ef 
  initlock(&tickslock, "time");
80105bc1:	68 e5 7e 10 80       	push   $0x80107ee5
80105bc6:	68 c0 cc 14 80       	push   $0x8014ccc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bcb:	66 a3 00 cf 14 80    	mov    %ax,0x8014cf00
80105bd1:	c1 e8 10             	shr    $0x10,%eax
80105bd4:	66 a3 06 cf 14 80    	mov    %ax,0x8014cf06
  initlock(&tickslock, "time");
80105bda:	e8 b1 ea ff ff       	call   80104690 <initlock>
}
80105bdf:	83 c4 10             	add    $0x10,%esp
80105be2:	c9                   	leave  
80105be3:	c3                   	ret    
80105be4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bef:	90                   	nop

80105bf0 <idtinit>:

void
idtinit(void)
{
80105bf0:	55                   	push   %ebp
  pd[0] = size-1;
80105bf1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105bf6:	89 e5                	mov    %esp,%ebp
80105bf8:	83 ec 10             	sub    $0x10,%esp
80105bfb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105bff:	b8 00 cd 14 80       	mov    $0x8014cd00,%eax
80105c04:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c08:	c1 e8 10             	shr    $0x10,%eax
80105c0b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c0f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c12:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c15:	c9                   	leave  
80105c16:	c3                   	ret    
80105c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	57                   	push   %edi
80105c24:	56                   	push   %esi
80105c25:	53                   	push   %ebx
80105c26:	83 ec 1c             	sub    $0x1c,%esp
80105c29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c2c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c2f:	83 f8 40             	cmp    $0x40,%eax
80105c32:	0f 84 30 01 00 00    	je     80105d68 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){	  
80105c38:	83 e8 0e             	sub    $0xe,%eax
80105c3b:	83 f8 31             	cmp    $0x31,%eax
80105c3e:	0f 87 8c 00 00 00    	ja     80105cd0 <trap+0xb0>
80105c44:	ff 24 85 8c 7f 10 80 	jmp    *-0x7fef8074(,%eax,4)
80105c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop
	case T_PGFLT:
    pg_fault(tf->err);
    break;
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105c50:	e8 ab df ff ff       	call   80103c00 <cpuid>
80105c55:	85 c0                	test   %eax,%eax
80105c57:	0f 84 13 02 00 00    	je     80105e70 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105c5d:	e8 4e cf ff ff       	call   80102bb0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c62:	e8 b9 df ff ff       	call   80103c20 <myproc>
80105c67:	85 c0                	test   %eax,%eax
80105c69:	74 1d                	je     80105c88 <trap+0x68>
80105c6b:	e8 b0 df ff ff       	call   80103c20 <myproc>
80105c70:	8b 50 24             	mov    0x24(%eax),%edx
80105c73:	85 d2                	test   %edx,%edx
80105c75:	74 11                	je     80105c88 <trap+0x68>
80105c77:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c7b:	83 e0 03             	and    $0x3,%eax
80105c7e:	66 83 f8 03          	cmp    $0x3,%ax
80105c82:	0f 84 c8 01 00 00    	je     80105e50 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c88:	e8 93 df ff ff       	call   80103c20 <myproc>
80105c8d:	85 c0                	test   %eax,%eax
80105c8f:	74 0f                	je     80105ca0 <trap+0x80>
80105c91:	e8 8a df ff ff       	call   80103c20 <myproc>
80105c96:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c9a:	0f 84 b0 00 00 00    	je     80105d50 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ca0:	e8 7b df ff ff       	call   80103c20 <myproc>
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	74 1d                	je     80105cc6 <trap+0xa6>
80105ca9:	e8 72 df ff ff       	call   80103c20 <myproc>
80105cae:	8b 40 24             	mov    0x24(%eax),%eax
80105cb1:	85 c0                	test   %eax,%eax
80105cb3:	74 11                	je     80105cc6 <trap+0xa6>
80105cb5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cb9:	83 e0 03             	and    $0x3,%eax
80105cbc:	66 83 f8 03          	cmp    $0x3,%ax
80105cc0:	0f 84 cf 00 00 00    	je     80105d95 <trap+0x175>
    exit();
}
80105cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cc9:	5b                   	pop    %ebx
80105cca:	5e                   	pop    %esi
80105ccb:	5f                   	pop    %edi
80105ccc:	5d                   	pop    %ebp
80105ccd:	c3                   	ret    
80105cce:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105cd0:	e8 4b df ff ff       	call   80103c20 <myproc>
80105cd5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cd8:	85 c0                	test   %eax,%eax
80105cda:	0f 84 c4 01 00 00    	je     80105ea4 <trap+0x284>
80105ce0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ce4:	0f 84 ba 01 00 00    	je     80105ea4 <trap+0x284>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105cea:	0f 20 d1             	mov    %cr2,%ecx
80105ced:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cf0:	e8 0b df ff ff       	call   80103c00 <cpuid>
80105cf5:	8b 73 30             	mov    0x30(%ebx),%esi
80105cf8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105cfb:	8b 43 34             	mov    0x34(%ebx),%eax
80105cfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105d01:	e8 1a df ff ff       	call   80103c20 <myproc>
80105d06:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d09:	e8 12 df ff ff       	call   80103c20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d0e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d11:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d14:	51                   	push   %ecx
80105d15:	57                   	push   %edi
80105d16:	52                   	push   %edx
80105d17:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d1a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d1b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d1e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d21:	56                   	push   %esi
80105d22:	ff 70 10             	pushl  0x10(%eax)
80105d25:	68 48 7f 10 80       	push   $0x80107f48
80105d2a:	e8 51 a9 ff ff       	call   80100680 <cprintf>
    myproc()->killed = 1;
80105d2f:	83 c4 20             	add    $0x20,%esp
80105d32:	e8 e9 de ff ff       	call   80103c20 <myproc>
80105d37:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d3e:	e8 dd de ff ff       	call   80103c20 <myproc>
80105d43:	85 c0                	test   %eax,%eax
80105d45:	0f 85 20 ff ff ff    	jne    80105c6b <trap+0x4b>
80105d4b:	e9 38 ff ff ff       	jmp    80105c88 <trap+0x68>
  if(myproc() && myproc()->state == RUNNING &&
80105d50:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d54:	0f 85 46 ff ff ff    	jne    80105ca0 <trap+0x80>
    yield();
80105d5a:	e8 71 e5 ff ff       	call   801042d0 <yield>
80105d5f:	e9 3c ff ff ff       	jmp    80105ca0 <trap+0x80>
80105d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d68:	e8 b3 de ff ff       	call   80103c20 <myproc>
80105d6d:	8b 70 24             	mov    0x24(%eax),%esi
80105d70:	85 f6                	test   %esi,%esi
80105d72:	0f 85 e8 00 00 00    	jne    80105e60 <trap+0x240>
    myproc()->tf = tf;
80105d78:	e8 a3 de ff ff       	call   80103c20 <myproc>
80105d7d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d80:	e8 8b ef ff ff       	call   80104d10 <syscall>
    if(myproc()->killed)
80105d85:	e8 96 de ff ff       	call   80103c20 <myproc>
80105d8a:	8b 48 24             	mov    0x24(%eax),%ecx
80105d8d:	85 c9                	test   %ecx,%ecx
80105d8f:	0f 84 31 ff ff ff    	je     80105cc6 <trap+0xa6>
}
80105d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d98:	5b                   	pop    %ebx
80105d99:	5e                   	pop    %esi
80105d9a:	5f                   	pop    %edi
80105d9b:	5d                   	pop    %ebp
      exit();
80105d9c:	e9 cf e2 ff ff       	jmp    80104070 <exit>
80105da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105da8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105dab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105daf:	e8 4c de ff ff       	call   80103c00 <cpuid>
80105db4:	57                   	push   %edi
80105db5:	56                   	push   %esi
80105db6:	50                   	push   %eax
80105db7:	68 f0 7e 10 80       	push   $0x80107ef0
80105dbc:	e8 bf a8 ff ff       	call   80100680 <cprintf>
    lapiceoi();
80105dc1:	e8 ea cd ff ff       	call   80102bb0 <lapiceoi>
    break;
80105dc6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dc9:	e8 52 de ff ff       	call   80103c20 <myproc>
80105dce:	85 c0                	test   %eax,%eax
80105dd0:	0f 85 95 fe ff ff    	jne    80105c6b <trap+0x4b>
80105dd6:	e9 ad fe ff ff       	jmp    80105c88 <trap+0x68>
80105ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ddf:	90                   	nop
    kbdintr();
80105de0:	e8 8b cc ff ff       	call   80102a70 <kbdintr>
    lapiceoi();
80105de5:	e8 c6 cd ff ff       	call   80102bb0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dea:	e8 31 de ff ff       	call   80103c20 <myproc>
80105def:	85 c0                	test   %eax,%eax
80105df1:	0f 85 74 fe ff ff    	jne    80105c6b <trap+0x4b>
80105df7:	e9 8c fe ff ff       	jmp    80105c88 <trap+0x68>
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e00:	e8 5b 02 00 00       	call   80106060 <uartintr>
    lapiceoi();
80105e05:	e8 a6 cd ff ff       	call   80102bb0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e0a:	e8 11 de ff ff       	call   80103c20 <myproc>
80105e0f:	85 c0                	test   %eax,%eax
80105e11:	0f 85 54 fe ff ff    	jne    80105c6b <trap+0x4b>
80105e17:	e9 6c fe ff ff       	jmp    80105c88 <trap+0x68>
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e20:	e8 4b c5 ff ff       	call   80102370 <ideintr>
80105e25:	e9 33 fe ff ff       	jmp    80105c5d <trap+0x3d>
80105e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pg_fault(tf->err);
80105e30:	83 ec 0c             	sub    $0xc,%esp
80105e33:	ff 73 34             	pushl  0x34(%ebx)
80105e36:	e8 05 17 00 00       	call   80107540 <pg_fault>
    break;
80105e3b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e3e:	e8 dd dd ff ff       	call   80103c20 <myproc>
80105e43:	85 c0                	test   %eax,%eax
80105e45:	0f 85 20 fe ff ff    	jne    80105c6b <trap+0x4b>
80105e4b:	e9 38 fe ff ff       	jmp    80105c88 <trap+0x68>
    exit();
80105e50:	e8 1b e2 ff ff       	call   80104070 <exit>
80105e55:	e9 2e fe ff ff       	jmp    80105c88 <trap+0x68>
80105e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e60:	e8 0b e2 ff ff       	call   80104070 <exit>
80105e65:	e9 0e ff ff ff       	jmp    80105d78 <trap+0x158>
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e70:	83 ec 0c             	sub    $0xc,%esp
80105e73:	68 c0 cc 14 80       	push   $0x8014ccc0
80105e78:	e8 23 e9 ff ff       	call   801047a0 <acquire>
      wakeup(&ticks);
80105e7d:	c7 04 24 a0 cc 14 80 	movl   $0x8014cca0,(%esp)
      ticks++;
80105e84:	83 05 a0 cc 14 80 01 	addl   $0x1,0x8014cca0
      wakeup(&ticks);
80105e8b:	e8 50 e5 ff ff       	call   801043e0 <wakeup>
      release(&tickslock);
80105e90:	c7 04 24 c0 cc 14 80 	movl   $0x8014ccc0,(%esp)
80105e97:	e8 24 ea ff ff       	call   801048c0 <release>
80105e9c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105e9f:	e9 b9 fd ff ff       	jmp    80105c5d <trap+0x3d>
80105ea4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ea7:	e8 54 dd ff ff       	call   80103c00 <cpuid>
80105eac:	83 ec 0c             	sub    $0xc,%esp
80105eaf:	56                   	push   %esi
80105eb0:	57                   	push   %edi
80105eb1:	50                   	push   %eax
80105eb2:	ff 73 30             	pushl  0x30(%ebx)
80105eb5:	68 14 7f 10 80       	push   $0x80107f14
80105eba:	e8 c1 a7 ff ff       	call   80100680 <cprintf>
      panic("trap");
80105ebf:	83 c4 14             	add    $0x14,%esp
80105ec2:	68 ea 7e 10 80       	push   $0x80107eea
80105ec7:	e8 b4 a4 ff ff       	call   80100380 <panic>
80105ecc:	66 90                	xchg   %ax,%ax
80105ece:	66 90                	xchg   %ax,%ax

80105ed0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ed0:	a1 00 d5 14 80       	mov    0x8014d500,%eax
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	74 17                	je     80105ef0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ed9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ede:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105edf:	a8 01                	test   $0x1,%al
80105ee1:	74 0d                	je     80105ef0 <uartgetc+0x20>
80105ee3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ee8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ee9:	0f b6 c0             	movzbl %al,%eax
80105eec:	c3                   	ret    
80105eed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ef5:	c3                   	ret    
80105ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efd:	8d 76 00             	lea    0x0(%esi),%esi

80105f00 <uartinit>:
{
80105f00:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f01:	31 c9                	xor    %ecx,%ecx
80105f03:	89 c8                	mov    %ecx,%eax
80105f05:	89 e5                	mov    %esp,%ebp
80105f07:	57                   	push   %edi
80105f08:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105f0d:	56                   	push   %esi
80105f0e:	89 fa                	mov    %edi,%edx
80105f10:	53                   	push   %ebx
80105f11:	83 ec 1c             	sub    $0x1c,%esp
80105f14:	ee                   	out    %al,(%dx)
80105f15:	be fb 03 00 00       	mov    $0x3fb,%esi
80105f1a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f1f:	89 f2                	mov    %esi,%edx
80105f21:	ee                   	out    %al,(%dx)
80105f22:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f27:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f2c:	ee                   	out    %al,(%dx)
80105f2d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105f32:	89 c8                	mov    %ecx,%eax
80105f34:	89 da                	mov    %ebx,%edx
80105f36:	ee                   	out    %al,(%dx)
80105f37:	b8 03 00 00 00       	mov    $0x3,%eax
80105f3c:	89 f2                	mov    %esi,%edx
80105f3e:	ee                   	out    %al,(%dx)
80105f3f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f44:	89 c8                	mov    %ecx,%eax
80105f46:	ee                   	out    %al,(%dx)
80105f47:	b8 01 00 00 00       	mov    $0x1,%eax
80105f4c:	89 da                	mov    %ebx,%edx
80105f4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f4f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f54:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f55:	3c ff                	cmp    $0xff,%al
80105f57:	0f 84 93 00 00 00    	je     80105ff0 <uartinit+0xf0>
  uart = 1;
80105f5d:	c7 05 00 d5 14 80 01 	movl   $0x1,0x8014d500
80105f64:	00 00 00 
80105f67:	89 fa                	mov    %edi,%edx
80105f69:	ec                   	in     (%dx),%al
80105f6a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f6f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f70:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f73:	bf 54 80 10 80       	mov    $0x80108054,%edi
80105f78:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105f7d:	6a 00                	push   $0x0
80105f7f:	6a 04                	push   $0x4
80105f81:	e8 2a c6 ff ff       	call   801025b0 <ioapicenable>
80105f86:	c6 45 e7 76          	movb   $0x76,-0x19(%ebp)
80105f8a:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105f8d:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
80105f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105f98:	a1 00 d5 14 80       	mov    0x8014d500,%eax
80105f9d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fa2:	85 c0                	test   %eax,%eax
80105fa4:	75 1c                	jne    80105fc2 <uartinit+0xc2>
80105fa6:	eb 2b                	jmp    80105fd3 <uartinit+0xd3>
80105fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105faf:	90                   	nop
    microdelay(10);
80105fb0:	83 ec 0c             	sub    $0xc,%esp
80105fb3:	6a 0a                	push   $0xa
80105fb5:	e8 16 cc ff ff       	call   80102bd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fba:	83 c4 10             	add    $0x10,%esp
80105fbd:	83 eb 01             	sub    $0x1,%ebx
80105fc0:	74 07                	je     80105fc9 <uartinit+0xc9>
80105fc2:	89 f2                	mov    %esi,%edx
80105fc4:	ec                   	in     (%dx),%al
80105fc5:	a8 20                	test   $0x20,%al
80105fc7:	74 e7                	je     80105fb0 <uartinit+0xb0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fc9:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
80105fcd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fd2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105fd3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105fd7:	83 c7 01             	add    $0x1,%edi
80105fda:	84 c0                	test   %al,%al
80105fdc:	74 12                	je     80105ff0 <uartinit+0xf0>
80105fde:	88 45 e6             	mov    %al,-0x1a(%ebp)
80105fe1:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105fe5:	88 45 e7             	mov    %al,-0x19(%ebp)
80105fe8:	eb ae                	jmp    80105f98 <uartinit+0x98>
80105fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80105ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff3:	5b                   	pop    %ebx
80105ff4:	5e                   	pop    %esi
80105ff5:	5f                   	pop    %edi
80105ff6:	5d                   	pop    %ebp
80105ff7:	c3                   	ret    
80105ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fff:	90                   	nop

80106000 <uartputc>:
  if(!uart)
80106000:	a1 00 d5 14 80       	mov    0x8014d500,%eax
80106005:	85 c0                	test   %eax,%eax
80106007:	74 47                	je     80106050 <uartputc+0x50>
{
80106009:	55                   	push   %ebp
8010600a:	89 e5                	mov    %esp,%ebp
8010600c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010600d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106012:	53                   	push   %ebx
80106013:	bb 80 00 00 00       	mov    $0x80,%ebx
80106018:	eb 18                	jmp    80106032 <uartputc+0x32>
8010601a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106020:	83 ec 0c             	sub    $0xc,%esp
80106023:	6a 0a                	push   $0xa
80106025:	e8 a6 cb ff ff       	call   80102bd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	83 eb 01             	sub    $0x1,%ebx
80106030:	74 07                	je     80106039 <uartputc+0x39>
80106032:	89 f2                	mov    %esi,%edx
80106034:	ec                   	in     (%dx),%al
80106035:	a8 20                	test   $0x20,%al
80106037:	74 e7                	je     80106020 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106039:	8b 45 08             	mov    0x8(%ebp),%eax
8010603c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106041:	ee                   	out    %al,(%dx)
}
80106042:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106045:	5b                   	pop    %ebx
80106046:	5e                   	pop    %esi
80106047:	5d                   	pop    %ebp
80106048:	c3                   	ret    
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106050:	c3                   	ret    
80106051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605f:	90                   	nop

80106060 <uartintr>:

void
uartintr(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106066:	68 d0 5e 10 80       	push   $0x80105ed0
8010606b:	e8 80 a8 ff ff       	call   801008f0 <consoleintr>
}
80106070:	83 c4 10             	add    $0x10,%esp
80106073:	c9                   	leave  
80106074:	c3                   	ret    

80106075 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106075:	6a 00                	push   $0x0
  pushl $0
80106077:	6a 00                	push   $0x0
  jmp alltraps
80106079:	e9 c3 fa ff ff       	jmp    80105b41 <alltraps>

8010607e <vector1>:
.globl vector1
vector1:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $1
80106080:	6a 01                	push   $0x1
  jmp alltraps
80106082:	e9 ba fa ff ff       	jmp    80105b41 <alltraps>

80106087 <vector2>:
.globl vector2
vector2:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $2
80106089:	6a 02                	push   $0x2
  jmp alltraps
8010608b:	e9 b1 fa ff ff       	jmp    80105b41 <alltraps>

80106090 <vector3>:
.globl vector3
vector3:
  pushl $0
80106090:	6a 00                	push   $0x0
  pushl $3
80106092:	6a 03                	push   $0x3
  jmp alltraps
80106094:	e9 a8 fa ff ff       	jmp    80105b41 <alltraps>

80106099 <vector4>:
.globl vector4
vector4:
  pushl $0
80106099:	6a 00                	push   $0x0
  pushl $4
8010609b:	6a 04                	push   $0x4
  jmp alltraps
8010609d:	e9 9f fa ff ff       	jmp    80105b41 <alltraps>

801060a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $5
801060a4:	6a 05                	push   $0x5
  jmp alltraps
801060a6:	e9 96 fa ff ff       	jmp    80105b41 <alltraps>

801060ab <vector6>:
.globl vector6
vector6:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $6
801060ad:	6a 06                	push   $0x6
  jmp alltraps
801060af:	e9 8d fa ff ff       	jmp    80105b41 <alltraps>

801060b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801060b4:	6a 00                	push   $0x0
  pushl $7
801060b6:	6a 07                	push   $0x7
  jmp alltraps
801060b8:	e9 84 fa ff ff       	jmp    80105b41 <alltraps>

801060bd <vector8>:
.globl vector8
vector8:
  pushl $8
801060bd:	6a 08                	push   $0x8
  jmp alltraps
801060bf:	e9 7d fa ff ff       	jmp    80105b41 <alltraps>

801060c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $9
801060c6:	6a 09                	push   $0x9
  jmp alltraps
801060c8:	e9 74 fa ff ff       	jmp    80105b41 <alltraps>

801060cd <vector10>:
.globl vector10
vector10:
  pushl $10
801060cd:	6a 0a                	push   $0xa
  jmp alltraps
801060cf:	e9 6d fa ff ff       	jmp    80105b41 <alltraps>

801060d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060d4:	6a 0b                	push   $0xb
  jmp alltraps
801060d6:	e9 66 fa ff ff       	jmp    80105b41 <alltraps>

801060db <vector12>:
.globl vector12
vector12:
  pushl $12
801060db:	6a 0c                	push   $0xc
  jmp alltraps
801060dd:	e9 5f fa ff ff       	jmp    80105b41 <alltraps>

801060e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060e2:	6a 0d                	push   $0xd
  jmp alltraps
801060e4:	e9 58 fa ff ff       	jmp    80105b41 <alltraps>

801060e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060e9:	6a 0e                	push   $0xe
  jmp alltraps
801060eb:	e9 51 fa ff ff       	jmp    80105b41 <alltraps>

801060f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $15
801060f2:	6a 0f                	push   $0xf
  jmp alltraps
801060f4:	e9 48 fa ff ff       	jmp    80105b41 <alltraps>

801060f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $16
801060fb:	6a 10                	push   $0x10
  jmp alltraps
801060fd:	e9 3f fa ff ff       	jmp    80105b41 <alltraps>

80106102 <vector17>:
.globl vector17
vector17:
  pushl $17
80106102:	6a 11                	push   $0x11
  jmp alltraps
80106104:	e9 38 fa ff ff       	jmp    80105b41 <alltraps>

80106109 <vector18>:
.globl vector18
vector18:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $18
8010610b:	6a 12                	push   $0x12
  jmp alltraps
8010610d:	e9 2f fa ff ff       	jmp    80105b41 <alltraps>

80106112 <vector19>:
.globl vector19
vector19:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $19
80106114:	6a 13                	push   $0x13
  jmp alltraps
80106116:	e9 26 fa ff ff       	jmp    80105b41 <alltraps>

8010611b <vector20>:
.globl vector20
vector20:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $20
8010611d:	6a 14                	push   $0x14
  jmp alltraps
8010611f:	e9 1d fa ff ff       	jmp    80105b41 <alltraps>

80106124 <vector21>:
.globl vector21
vector21:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $21
80106126:	6a 15                	push   $0x15
  jmp alltraps
80106128:	e9 14 fa ff ff       	jmp    80105b41 <alltraps>

8010612d <vector22>:
.globl vector22
vector22:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $22
8010612f:	6a 16                	push   $0x16
  jmp alltraps
80106131:	e9 0b fa ff ff       	jmp    80105b41 <alltraps>

80106136 <vector23>:
.globl vector23
vector23:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $23
80106138:	6a 17                	push   $0x17
  jmp alltraps
8010613a:	e9 02 fa ff ff       	jmp    80105b41 <alltraps>

8010613f <vector24>:
.globl vector24
vector24:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $24
80106141:	6a 18                	push   $0x18
  jmp alltraps
80106143:	e9 f9 f9 ff ff       	jmp    80105b41 <alltraps>

80106148 <vector25>:
.globl vector25
vector25:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $25
8010614a:	6a 19                	push   $0x19
  jmp alltraps
8010614c:	e9 f0 f9 ff ff       	jmp    80105b41 <alltraps>

80106151 <vector26>:
.globl vector26
vector26:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $26
80106153:	6a 1a                	push   $0x1a
  jmp alltraps
80106155:	e9 e7 f9 ff ff       	jmp    80105b41 <alltraps>

8010615a <vector27>:
.globl vector27
vector27:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $27
8010615c:	6a 1b                	push   $0x1b
  jmp alltraps
8010615e:	e9 de f9 ff ff       	jmp    80105b41 <alltraps>

80106163 <vector28>:
.globl vector28
vector28:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $28
80106165:	6a 1c                	push   $0x1c
  jmp alltraps
80106167:	e9 d5 f9 ff ff       	jmp    80105b41 <alltraps>

8010616c <vector29>:
.globl vector29
vector29:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $29
8010616e:	6a 1d                	push   $0x1d
  jmp alltraps
80106170:	e9 cc f9 ff ff       	jmp    80105b41 <alltraps>

80106175 <vector30>:
.globl vector30
vector30:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $30
80106177:	6a 1e                	push   $0x1e
  jmp alltraps
80106179:	e9 c3 f9 ff ff       	jmp    80105b41 <alltraps>

8010617e <vector31>:
.globl vector31
vector31:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $31
80106180:	6a 1f                	push   $0x1f
  jmp alltraps
80106182:	e9 ba f9 ff ff       	jmp    80105b41 <alltraps>

80106187 <vector32>:
.globl vector32
vector32:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $32
80106189:	6a 20                	push   $0x20
  jmp alltraps
8010618b:	e9 b1 f9 ff ff       	jmp    80105b41 <alltraps>

80106190 <vector33>:
.globl vector33
vector33:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $33
80106192:	6a 21                	push   $0x21
  jmp alltraps
80106194:	e9 a8 f9 ff ff       	jmp    80105b41 <alltraps>

80106199 <vector34>:
.globl vector34
vector34:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $34
8010619b:	6a 22                	push   $0x22
  jmp alltraps
8010619d:	e9 9f f9 ff ff       	jmp    80105b41 <alltraps>

801061a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $35
801061a4:	6a 23                	push   $0x23
  jmp alltraps
801061a6:	e9 96 f9 ff ff       	jmp    80105b41 <alltraps>

801061ab <vector36>:
.globl vector36
vector36:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $36
801061ad:	6a 24                	push   $0x24
  jmp alltraps
801061af:	e9 8d f9 ff ff       	jmp    80105b41 <alltraps>

801061b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $37
801061b6:	6a 25                	push   $0x25
  jmp alltraps
801061b8:	e9 84 f9 ff ff       	jmp    80105b41 <alltraps>

801061bd <vector38>:
.globl vector38
vector38:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $38
801061bf:	6a 26                	push   $0x26
  jmp alltraps
801061c1:	e9 7b f9 ff ff       	jmp    80105b41 <alltraps>

801061c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $39
801061c8:	6a 27                	push   $0x27
  jmp alltraps
801061ca:	e9 72 f9 ff ff       	jmp    80105b41 <alltraps>

801061cf <vector40>:
.globl vector40
vector40:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $40
801061d1:	6a 28                	push   $0x28
  jmp alltraps
801061d3:	e9 69 f9 ff ff       	jmp    80105b41 <alltraps>

801061d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $41
801061da:	6a 29                	push   $0x29
  jmp alltraps
801061dc:	e9 60 f9 ff ff       	jmp    80105b41 <alltraps>

801061e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $42
801061e3:	6a 2a                	push   $0x2a
  jmp alltraps
801061e5:	e9 57 f9 ff ff       	jmp    80105b41 <alltraps>

801061ea <vector43>:
.globl vector43
vector43:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $43
801061ec:	6a 2b                	push   $0x2b
  jmp alltraps
801061ee:	e9 4e f9 ff ff       	jmp    80105b41 <alltraps>

801061f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $44
801061f5:	6a 2c                	push   $0x2c
  jmp alltraps
801061f7:	e9 45 f9 ff ff       	jmp    80105b41 <alltraps>

801061fc <vector45>:
.globl vector45
vector45:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $45
801061fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106200:	e9 3c f9 ff ff       	jmp    80105b41 <alltraps>

80106205 <vector46>:
.globl vector46
vector46:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $46
80106207:	6a 2e                	push   $0x2e
  jmp alltraps
80106209:	e9 33 f9 ff ff       	jmp    80105b41 <alltraps>

8010620e <vector47>:
.globl vector47
vector47:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $47
80106210:	6a 2f                	push   $0x2f
  jmp alltraps
80106212:	e9 2a f9 ff ff       	jmp    80105b41 <alltraps>

80106217 <vector48>:
.globl vector48
vector48:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $48
80106219:	6a 30                	push   $0x30
  jmp alltraps
8010621b:	e9 21 f9 ff ff       	jmp    80105b41 <alltraps>

80106220 <vector49>:
.globl vector49
vector49:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $49
80106222:	6a 31                	push   $0x31
  jmp alltraps
80106224:	e9 18 f9 ff ff       	jmp    80105b41 <alltraps>

80106229 <vector50>:
.globl vector50
vector50:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $50
8010622b:	6a 32                	push   $0x32
  jmp alltraps
8010622d:	e9 0f f9 ff ff       	jmp    80105b41 <alltraps>

80106232 <vector51>:
.globl vector51
vector51:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $51
80106234:	6a 33                	push   $0x33
  jmp alltraps
80106236:	e9 06 f9 ff ff       	jmp    80105b41 <alltraps>

8010623b <vector52>:
.globl vector52
vector52:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $52
8010623d:	6a 34                	push   $0x34
  jmp alltraps
8010623f:	e9 fd f8 ff ff       	jmp    80105b41 <alltraps>

80106244 <vector53>:
.globl vector53
vector53:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $53
80106246:	6a 35                	push   $0x35
  jmp alltraps
80106248:	e9 f4 f8 ff ff       	jmp    80105b41 <alltraps>

8010624d <vector54>:
.globl vector54
vector54:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $54
8010624f:	6a 36                	push   $0x36
  jmp alltraps
80106251:	e9 eb f8 ff ff       	jmp    80105b41 <alltraps>

80106256 <vector55>:
.globl vector55
vector55:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $55
80106258:	6a 37                	push   $0x37
  jmp alltraps
8010625a:	e9 e2 f8 ff ff       	jmp    80105b41 <alltraps>

8010625f <vector56>:
.globl vector56
vector56:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $56
80106261:	6a 38                	push   $0x38
  jmp alltraps
80106263:	e9 d9 f8 ff ff       	jmp    80105b41 <alltraps>

80106268 <vector57>:
.globl vector57
vector57:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $57
8010626a:	6a 39                	push   $0x39
  jmp alltraps
8010626c:	e9 d0 f8 ff ff       	jmp    80105b41 <alltraps>

80106271 <vector58>:
.globl vector58
vector58:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $58
80106273:	6a 3a                	push   $0x3a
  jmp alltraps
80106275:	e9 c7 f8 ff ff       	jmp    80105b41 <alltraps>

8010627a <vector59>:
.globl vector59
vector59:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $59
8010627c:	6a 3b                	push   $0x3b
  jmp alltraps
8010627e:	e9 be f8 ff ff       	jmp    80105b41 <alltraps>

80106283 <vector60>:
.globl vector60
vector60:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $60
80106285:	6a 3c                	push   $0x3c
  jmp alltraps
80106287:	e9 b5 f8 ff ff       	jmp    80105b41 <alltraps>

8010628c <vector61>:
.globl vector61
vector61:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $61
8010628e:	6a 3d                	push   $0x3d
  jmp alltraps
80106290:	e9 ac f8 ff ff       	jmp    80105b41 <alltraps>

80106295 <vector62>:
.globl vector62
vector62:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $62
80106297:	6a 3e                	push   $0x3e
  jmp alltraps
80106299:	e9 a3 f8 ff ff       	jmp    80105b41 <alltraps>

8010629e <vector63>:
.globl vector63
vector63:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $63
801062a0:	6a 3f                	push   $0x3f
  jmp alltraps
801062a2:	e9 9a f8 ff ff       	jmp    80105b41 <alltraps>

801062a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $64
801062a9:	6a 40                	push   $0x40
  jmp alltraps
801062ab:	e9 91 f8 ff ff       	jmp    80105b41 <alltraps>

801062b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $65
801062b2:	6a 41                	push   $0x41
  jmp alltraps
801062b4:	e9 88 f8 ff ff       	jmp    80105b41 <alltraps>

801062b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $66
801062bb:	6a 42                	push   $0x42
  jmp alltraps
801062bd:	e9 7f f8 ff ff       	jmp    80105b41 <alltraps>

801062c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $67
801062c4:	6a 43                	push   $0x43
  jmp alltraps
801062c6:	e9 76 f8 ff ff       	jmp    80105b41 <alltraps>

801062cb <vector68>:
.globl vector68
vector68:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $68
801062cd:	6a 44                	push   $0x44
  jmp alltraps
801062cf:	e9 6d f8 ff ff       	jmp    80105b41 <alltraps>

801062d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $69
801062d6:	6a 45                	push   $0x45
  jmp alltraps
801062d8:	e9 64 f8 ff ff       	jmp    80105b41 <alltraps>

801062dd <vector70>:
.globl vector70
vector70:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $70
801062df:	6a 46                	push   $0x46
  jmp alltraps
801062e1:	e9 5b f8 ff ff       	jmp    80105b41 <alltraps>

801062e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $71
801062e8:	6a 47                	push   $0x47
  jmp alltraps
801062ea:	e9 52 f8 ff ff       	jmp    80105b41 <alltraps>

801062ef <vector72>:
.globl vector72
vector72:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $72
801062f1:	6a 48                	push   $0x48
  jmp alltraps
801062f3:	e9 49 f8 ff ff       	jmp    80105b41 <alltraps>

801062f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $73
801062fa:	6a 49                	push   $0x49
  jmp alltraps
801062fc:	e9 40 f8 ff ff       	jmp    80105b41 <alltraps>

80106301 <vector74>:
.globl vector74
vector74:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $74
80106303:	6a 4a                	push   $0x4a
  jmp alltraps
80106305:	e9 37 f8 ff ff       	jmp    80105b41 <alltraps>

8010630a <vector75>:
.globl vector75
vector75:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $75
8010630c:	6a 4b                	push   $0x4b
  jmp alltraps
8010630e:	e9 2e f8 ff ff       	jmp    80105b41 <alltraps>

80106313 <vector76>:
.globl vector76
vector76:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $76
80106315:	6a 4c                	push   $0x4c
  jmp alltraps
80106317:	e9 25 f8 ff ff       	jmp    80105b41 <alltraps>

8010631c <vector77>:
.globl vector77
vector77:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $77
8010631e:	6a 4d                	push   $0x4d
  jmp alltraps
80106320:	e9 1c f8 ff ff       	jmp    80105b41 <alltraps>

80106325 <vector78>:
.globl vector78
vector78:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $78
80106327:	6a 4e                	push   $0x4e
  jmp alltraps
80106329:	e9 13 f8 ff ff       	jmp    80105b41 <alltraps>

8010632e <vector79>:
.globl vector79
vector79:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $79
80106330:	6a 4f                	push   $0x4f
  jmp alltraps
80106332:	e9 0a f8 ff ff       	jmp    80105b41 <alltraps>

80106337 <vector80>:
.globl vector80
vector80:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $80
80106339:	6a 50                	push   $0x50
  jmp alltraps
8010633b:	e9 01 f8 ff ff       	jmp    80105b41 <alltraps>

80106340 <vector81>:
.globl vector81
vector81:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $81
80106342:	6a 51                	push   $0x51
  jmp alltraps
80106344:	e9 f8 f7 ff ff       	jmp    80105b41 <alltraps>

80106349 <vector82>:
.globl vector82
vector82:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $82
8010634b:	6a 52                	push   $0x52
  jmp alltraps
8010634d:	e9 ef f7 ff ff       	jmp    80105b41 <alltraps>

80106352 <vector83>:
.globl vector83
vector83:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $83
80106354:	6a 53                	push   $0x53
  jmp alltraps
80106356:	e9 e6 f7 ff ff       	jmp    80105b41 <alltraps>

8010635b <vector84>:
.globl vector84
vector84:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $84
8010635d:	6a 54                	push   $0x54
  jmp alltraps
8010635f:	e9 dd f7 ff ff       	jmp    80105b41 <alltraps>

80106364 <vector85>:
.globl vector85
vector85:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $85
80106366:	6a 55                	push   $0x55
  jmp alltraps
80106368:	e9 d4 f7 ff ff       	jmp    80105b41 <alltraps>

8010636d <vector86>:
.globl vector86
vector86:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $86
8010636f:	6a 56                	push   $0x56
  jmp alltraps
80106371:	e9 cb f7 ff ff       	jmp    80105b41 <alltraps>

80106376 <vector87>:
.globl vector87
vector87:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $87
80106378:	6a 57                	push   $0x57
  jmp alltraps
8010637a:	e9 c2 f7 ff ff       	jmp    80105b41 <alltraps>

8010637f <vector88>:
.globl vector88
vector88:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $88
80106381:	6a 58                	push   $0x58
  jmp alltraps
80106383:	e9 b9 f7 ff ff       	jmp    80105b41 <alltraps>

80106388 <vector89>:
.globl vector89
vector89:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $89
8010638a:	6a 59                	push   $0x59
  jmp alltraps
8010638c:	e9 b0 f7 ff ff       	jmp    80105b41 <alltraps>

80106391 <vector90>:
.globl vector90
vector90:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $90
80106393:	6a 5a                	push   $0x5a
  jmp alltraps
80106395:	e9 a7 f7 ff ff       	jmp    80105b41 <alltraps>

8010639a <vector91>:
.globl vector91
vector91:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $91
8010639c:	6a 5b                	push   $0x5b
  jmp alltraps
8010639e:	e9 9e f7 ff ff       	jmp    80105b41 <alltraps>

801063a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $92
801063a5:	6a 5c                	push   $0x5c
  jmp alltraps
801063a7:	e9 95 f7 ff ff       	jmp    80105b41 <alltraps>

801063ac <vector93>:
.globl vector93
vector93:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $93
801063ae:	6a 5d                	push   $0x5d
  jmp alltraps
801063b0:	e9 8c f7 ff ff       	jmp    80105b41 <alltraps>

801063b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $94
801063b7:	6a 5e                	push   $0x5e
  jmp alltraps
801063b9:	e9 83 f7 ff ff       	jmp    80105b41 <alltraps>

801063be <vector95>:
.globl vector95
vector95:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $95
801063c0:	6a 5f                	push   $0x5f
  jmp alltraps
801063c2:	e9 7a f7 ff ff       	jmp    80105b41 <alltraps>

801063c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $96
801063c9:	6a 60                	push   $0x60
  jmp alltraps
801063cb:	e9 71 f7 ff ff       	jmp    80105b41 <alltraps>

801063d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $97
801063d2:	6a 61                	push   $0x61
  jmp alltraps
801063d4:	e9 68 f7 ff ff       	jmp    80105b41 <alltraps>

801063d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $98
801063db:	6a 62                	push   $0x62
  jmp alltraps
801063dd:	e9 5f f7 ff ff       	jmp    80105b41 <alltraps>

801063e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $99
801063e4:	6a 63                	push   $0x63
  jmp alltraps
801063e6:	e9 56 f7 ff ff       	jmp    80105b41 <alltraps>

801063eb <vector100>:
.globl vector100
vector100:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $100
801063ed:	6a 64                	push   $0x64
  jmp alltraps
801063ef:	e9 4d f7 ff ff       	jmp    80105b41 <alltraps>

801063f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $101
801063f6:	6a 65                	push   $0x65
  jmp alltraps
801063f8:	e9 44 f7 ff ff       	jmp    80105b41 <alltraps>

801063fd <vector102>:
.globl vector102
vector102:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $102
801063ff:	6a 66                	push   $0x66
  jmp alltraps
80106401:	e9 3b f7 ff ff       	jmp    80105b41 <alltraps>

80106406 <vector103>:
.globl vector103
vector103:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $103
80106408:	6a 67                	push   $0x67
  jmp alltraps
8010640a:	e9 32 f7 ff ff       	jmp    80105b41 <alltraps>

8010640f <vector104>:
.globl vector104
vector104:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $104
80106411:	6a 68                	push   $0x68
  jmp alltraps
80106413:	e9 29 f7 ff ff       	jmp    80105b41 <alltraps>

80106418 <vector105>:
.globl vector105
vector105:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $105
8010641a:	6a 69                	push   $0x69
  jmp alltraps
8010641c:	e9 20 f7 ff ff       	jmp    80105b41 <alltraps>

80106421 <vector106>:
.globl vector106
vector106:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $106
80106423:	6a 6a                	push   $0x6a
  jmp alltraps
80106425:	e9 17 f7 ff ff       	jmp    80105b41 <alltraps>

8010642a <vector107>:
.globl vector107
vector107:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $107
8010642c:	6a 6b                	push   $0x6b
  jmp alltraps
8010642e:	e9 0e f7 ff ff       	jmp    80105b41 <alltraps>

80106433 <vector108>:
.globl vector108
vector108:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $108
80106435:	6a 6c                	push   $0x6c
  jmp alltraps
80106437:	e9 05 f7 ff ff       	jmp    80105b41 <alltraps>

8010643c <vector109>:
.globl vector109
vector109:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $109
8010643e:	6a 6d                	push   $0x6d
  jmp alltraps
80106440:	e9 fc f6 ff ff       	jmp    80105b41 <alltraps>

80106445 <vector110>:
.globl vector110
vector110:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $110
80106447:	6a 6e                	push   $0x6e
  jmp alltraps
80106449:	e9 f3 f6 ff ff       	jmp    80105b41 <alltraps>

8010644e <vector111>:
.globl vector111
vector111:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $111
80106450:	6a 6f                	push   $0x6f
  jmp alltraps
80106452:	e9 ea f6 ff ff       	jmp    80105b41 <alltraps>

80106457 <vector112>:
.globl vector112
vector112:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $112
80106459:	6a 70                	push   $0x70
  jmp alltraps
8010645b:	e9 e1 f6 ff ff       	jmp    80105b41 <alltraps>

80106460 <vector113>:
.globl vector113
vector113:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $113
80106462:	6a 71                	push   $0x71
  jmp alltraps
80106464:	e9 d8 f6 ff ff       	jmp    80105b41 <alltraps>

80106469 <vector114>:
.globl vector114
vector114:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $114
8010646b:	6a 72                	push   $0x72
  jmp alltraps
8010646d:	e9 cf f6 ff ff       	jmp    80105b41 <alltraps>

80106472 <vector115>:
.globl vector115
vector115:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $115
80106474:	6a 73                	push   $0x73
  jmp alltraps
80106476:	e9 c6 f6 ff ff       	jmp    80105b41 <alltraps>

8010647b <vector116>:
.globl vector116
vector116:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $116
8010647d:	6a 74                	push   $0x74
  jmp alltraps
8010647f:	e9 bd f6 ff ff       	jmp    80105b41 <alltraps>

80106484 <vector117>:
.globl vector117
vector117:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $117
80106486:	6a 75                	push   $0x75
  jmp alltraps
80106488:	e9 b4 f6 ff ff       	jmp    80105b41 <alltraps>

8010648d <vector118>:
.globl vector118
vector118:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $118
8010648f:	6a 76                	push   $0x76
  jmp alltraps
80106491:	e9 ab f6 ff ff       	jmp    80105b41 <alltraps>

80106496 <vector119>:
.globl vector119
vector119:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $119
80106498:	6a 77                	push   $0x77
  jmp alltraps
8010649a:	e9 a2 f6 ff ff       	jmp    80105b41 <alltraps>

8010649f <vector120>:
.globl vector120
vector120:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $120
801064a1:	6a 78                	push   $0x78
  jmp alltraps
801064a3:	e9 99 f6 ff ff       	jmp    80105b41 <alltraps>

801064a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $121
801064aa:	6a 79                	push   $0x79
  jmp alltraps
801064ac:	e9 90 f6 ff ff       	jmp    80105b41 <alltraps>

801064b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $122
801064b3:	6a 7a                	push   $0x7a
  jmp alltraps
801064b5:	e9 87 f6 ff ff       	jmp    80105b41 <alltraps>

801064ba <vector123>:
.globl vector123
vector123:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $123
801064bc:	6a 7b                	push   $0x7b
  jmp alltraps
801064be:	e9 7e f6 ff ff       	jmp    80105b41 <alltraps>

801064c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $124
801064c5:	6a 7c                	push   $0x7c
  jmp alltraps
801064c7:	e9 75 f6 ff ff       	jmp    80105b41 <alltraps>

801064cc <vector125>:
.globl vector125
vector125:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $125
801064ce:	6a 7d                	push   $0x7d
  jmp alltraps
801064d0:	e9 6c f6 ff ff       	jmp    80105b41 <alltraps>

801064d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $126
801064d7:	6a 7e                	push   $0x7e
  jmp alltraps
801064d9:	e9 63 f6 ff ff       	jmp    80105b41 <alltraps>

801064de <vector127>:
.globl vector127
vector127:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $127
801064e0:	6a 7f                	push   $0x7f
  jmp alltraps
801064e2:	e9 5a f6 ff ff       	jmp    80105b41 <alltraps>

801064e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $128
801064e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064ee:	e9 4e f6 ff ff       	jmp    80105b41 <alltraps>

801064f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $129
801064f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064fa:	e9 42 f6 ff ff       	jmp    80105b41 <alltraps>

801064ff <vector130>:
.globl vector130
vector130:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $130
80106501:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106506:	e9 36 f6 ff ff       	jmp    80105b41 <alltraps>

8010650b <vector131>:
.globl vector131
vector131:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $131
8010650d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106512:	e9 2a f6 ff ff       	jmp    80105b41 <alltraps>

80106517 <vector132>:
.globl vector132
vector132:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $132
80106519:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010651e:	e9 1e f6 ff ff       	jmp    80105b41 <alltraps>

80106523 <vector133>:
.globl vector133
vector133:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $133
80106525:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010652a:	e9 12 f6 ff ff       	jmp    80105b41 <alltraps>

8010652f <vector134>:
.globl vector134
vector134:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $134
80106531:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106536:	e9 06 f6 ff ff       	jmp    80105b41 <alltraps>

8010653b <vector135>:
.globl vector135
vector135:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $135
8010653d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106542:	e9 fa f5 ff ff       	jmp    80105b41 <alltraps>

80106547 <vector136>:
.globl vector136
vector136:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $136
80106549:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010654e:	e9 ee f5 ff ff       	jmp    80105b41 <alltraps>

80106553 <vector137>:
.globl vector137
vector137:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $137
80106555:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010655a:	e9 e2 f5 ff ff       	jmp    80105b41 <alltraps>

8010655f <vector138>:
.globl vector138
vector138:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $138
80106561:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106566:	e9 d6 f5 ff ff       	jmp    80105b41 <alltraps>

8010656b <vector139>:
.globl vector139
vector139:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $139
8010656d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106572:	e9 ca f5 ff ff       	jmp    80105b41 <alltraps>

80106577 <vector140>:
.globl vector140
vector140:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $140
80106579:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010657e:	e9 be f5 ff ff       	jmp    80105b41 <alltraps>

80106583 <vector141>:
.globl vector141
vector141:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $141
80106585:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010658a:	e9 b2 f5 ff ff       	jmp    80105b41 <alltraps>

8010658f <vector142>:
.globl vector142
vector142:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $142
80106591:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106596:	e9 a6 f5 ff ff       	jmp    80105b41 <alltraps>

8010659b <vector143>:
.globl vector143
vector143:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $143
8010659d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801065a2:	e9 9a f5 ff ff       	jmp    80105b41 <alltraps>

801065a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $144
801065a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801065ae:	e9 8e f5 ff ff       	jmp    80105b41 <alltraps>

801065b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $145
801065b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065ba:	e9 82 f5 ff ff       	jmp    80105b41 <alltraps>

801065bf <vector146>:
.globl vector146
vector146:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $146
801065c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065c6:	e9 76 f5 ff ff       	jmp    80105b41 <alltraps>

801065cb <vector147>:
.globl vector147
vector147:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $147
801065cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065d2:	e9 6a f5 ff ff       	jmp    80105b41 <alltraps>

801065d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $148
801065d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065de:	e9 5e f5 ff ff       	jmp    80105b41 <alltraps>

801065e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $149
801065e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065ea:	e9 52 f5 ff ff       	jmp    80105b41 <alltraps>

801065ef <vector150>:
.globl vector150
vector150:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $150
801065f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065f6:	e9 46 f5 ff ff       	jmp    80105b41 <alltraps>

801065fb <vector151>:
.globl vector151
vector151:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $151
801065fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106602:	e9 3a f5 ff ff       	jmp    80105b41 <alltraps>

80106607 <vector152>:
.globl vector152
vector152:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $152
80106609:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010660e:	e9 2e f5 ff ff       	jmp    80105b41 <alltraps>

80106613 <vector153>:
.globl vector153
vector153:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $153
80106615:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010661a:	e9 22 f5 ff ff       	jmp    80105b41 <alltraps>

8010661f <vector154>:
.globl vector154
vector154:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $154
80106621:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106626:	e9 16 f5 ff ff       	jmp    80105b41 <alltraps>

8010662b <vector155>:
.globl vector155
vector155:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $155
8010662d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106632:	e9 0a f5 ff ff       	jmp    80105b41 <alltraps>

80106637 <vector156>:
.globl vector156
vector156:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $156
80106639:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010663e:	e9 fe f4 ff ff       	jmp    80105b41 <alltraps>

80106643 <vector157>:
.globl vector157
vector157:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $157
80106645:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010664a:	e9 f2 f4 ff ff       	jmp    80105b41 <alltraps>

8010664f <vector158>:
.globl vector158
vector158:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $158
80106651:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106656:	e9 e6 f4 ff ff       	jmp    80105b41 <alltraps>

8010665b <vector159>:
.globl vector159
vector159:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $159
8010665d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106662:	e9 da f4 ff ff       	jmp    80105b41 <alltraps>

80106667 <vector160>:
.globl vector160
vector160:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $160
80106669:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010666e:	e9 ce f4 ff ff       	jmp    80105b41 <alltraps>

80106673 <vector161>:
.globl vector161
vector161:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $161
80106675:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010667a:	e9 c2 f4 ff ff       	jmp    80105b41 <alltraps>

8010667f <vector162>:
.globl vector162
vector162:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $162
80106681:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106686:	e9 b6 f4 ff ff       	jmp    80105b41 <alltraps>

8010668b <vector163>:
.globl vector163
vector163:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $163
8010668d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106692:	e9 aa f4 ff ff       	jmp    80105b41 <alltraps>

80106697 <vector164>:
.globl vector164
vector164:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $164
80106699:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010669e:	e9 9e f4 ff ff       	jmp    80105b41 <alltraps>

801066a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $165
801066a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801066aa:	e9 92 f4 ff ff       	jmp    80105b41 <alltraps>

801066af <vector166>:
.globl vector166
vector166:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $166
801066b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066b6:	e9 86 f4 ff ff       	jmp    80105b41 <alltraps>

801066bb <vector167>:
.globl vector167
vector167:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $167
801066bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066c2:	e9 7a f4 ff ff       	jmp    80105b41 <alltraps>

801066c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $168
801066c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066ce:	e9 6e f4 ff ff       	jmp    80105b41 <alltraps>

801066d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $169
801066d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066da:	e9 62 f4 ff ff       	jmp    80105b41 <alltraps>

801066df <vector170>:
.globl vector170
vector170:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $170
801066e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066e6:	e9 56 f4 ff ff       	jmp    80105b41 <alltraps>

801066eb <vector171>:
.globl vector171
vector171:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $171
801066ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066f2:	e9 4a f4 ff ff       	jmp    80105b41 <alltraps>

801066f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $172
801066f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066fe:	e9 3e f4 ff ff       	jmp    80105b41 <alltraps>

80106703 <vector173>:
.globl vector173
vector173:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $173
80106705:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010670a:	e9 32 f4 ff ff       	jmp    80105b41 <alltraps>

8010670f <vector174>:
.globl vector174
vector174:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $174
80106711:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106716:	e9 26 f4 ff ff       	jmp    80105b41 <alltraps>

8010671b <vector175>:
.globl vector175
vector175:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $175
8010671d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106722:	e9 1a f4 ff ff       	jmp    80105b41 <alltraps>

80106727 <vector176>:
.globl vector176
vector176:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $176
80106729:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010672e:	e9 0e f4 ff ff       	jmp    80105b41 <alltraps>

80106733 <vector177>:
.globl vector177
vector177:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $177
80106735:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010673a:	e9 02 f4 ff ff       	jmp    80105b41 <alltraps>

8010673f <vector178>:
.globl vector178
vector178:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $178
80106741:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106746:	e9 f6 f3 ff ff       	jmp    80105b41 <alltraps>

8010674b <vector179>:
.globl vector179
vector179:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $179
8010674d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106752:	e9 ea f3 ff ff       	jmp    80105b41 <alltraps>

80106757 <vector180>:
.globl vector180
vector180:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $180
80106759:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010675e:	e9 de f3 ff ff       	jmp    80105b41 <alltraps>

80106763 <vector181>:
.globl vector181
vector181:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $181
80106765:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010676a:	e9 d2 f3 ff ff       	jmp    80105b41 <alltraps>

8010676f <vector182>:
.globl vector182
vector182:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $182
80106771:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106776:	e9 c6 f3 ff ff       	jmp    80105b41 <alltraps>

8010677b <vector183>:
.globl vector183
vector183:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $183
8010677d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106782:	e9 ba f3 ff ff       	jmp    80105b41 <alltraps>

80106787 <vector184>:
.globl vector184
vector184:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $184
80106789:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010678e:	e9 ae f3 ff ff       	jmp    80105b41 <alltraps>

80106793 <vector185>:
.globl vector185
vector185:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $185
80106795:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010679a:	e9 a2 f3 ff ff       	jmp    80105b41 <alltraps>

8010679f <vector186>:
.globl vector186
vector186:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $186
801067a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801067a6:	e9 96 f3 ff ff       	jmp    80105b41 <alltraps>

801067ab <vector187>:
.globl vector187
vector187:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $187
801067ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067b2:	e9 8a f3 ff ff       	jmp    80105b41 <alltraps>

801067b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $188
801067b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067be:	e9 7e f3 ff ff       	jmp    80105b41 <alltraps>

801067c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $189
801067c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067ca:	e9 72 f3 ff ff       	jmp    80105b41 <alltraps>

801067cf <vector190>:
.globl vector190
vector190:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $190
801067d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067d6:	e9 66 f3 ff ff       	jmp    80105b41 <alltraps>

801067db <vector191>:
.globl vector191
vector191:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $191
801067dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067e2:	e9 5a f3 ff ff       	jmp    80105b41 <alltraps>

801067e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $192
801067e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067ee:	e9 4e f3 ff ff       	jmp    80105b41 <alltraps>

801067f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $193
801067f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067fa:	e9 42 f3 ff ff       	jmp    80105b41 <alltraps>

801067ff <vector194>:
.globl vector194
vector194:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $194
80106801:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106806:	e9 36 f3 ff ff       	jmp    80105b41 <alltraps>

8010680b <vector195>:
.globl vector195
vector195:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $195
8010680d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106812:	e9 2a f3 ff ff       	jmp    80105b41 <alltraps>

80106817 <vector196>:
.globl vector196
vector196:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $196
80106819:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010681e:	e9 1e f3 ff ff       	jmp    80105b41 <alltraps>

80106823 <vector197>:
.globl vector197
vector197:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $197
80106825:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010682a:	e9 12 f3 ff ff       	jmp    80105b41 <alltraps>

8010682f <vector198>:
.globl vector198
vector198:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $198
80106831:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106836:	e9 06 f3 ff ff       	jmp    80105b41 <alltraps>

8010683b <vector199>:
.globl vector199
vector199:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $199
8010683d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106842:	e9 fa f2 ff ff       	jmp    80105b41 <alltraps>

80106847 <vector200>:
.globl vector200
vector200:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $200
80106849:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010684e:	e9 ee f2 ff ff       	jmp    80105b41 <alltraps>

80106853 <vector201>:
.globl vector201
vector201:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $201
80106855:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010685a:	e9 e2 f2 ff ff       	jmp    80105b41 <alltraps>

8010685f <vector202>:
.globl vector202
vector202:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $202
80106861:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106866:	e9 d6 f2 ff ff       	jmp    80105b41 <alltraps>

8010686b <vector203>:
.globl vector203
vector203:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $203
8010686d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106872:	e9 ca f2 ff ff       	jmp    80105b41 <alltraps>

80106877 <vector204>:
.globl vector204
vector204:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $204
80106879:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010687e:	e9 be f2 ff ff       	jmp    80105b41 <alltraps>

80106883 <vector205>:
.globl vector205
vector205:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $205
80106885:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010688a:	e9 b2 f2 ff ff       	jmp    80105b41 <alltraps>

8010688f <vector206>:
.globl vector206
vector206:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $206
80106891:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106896:	e9 a6 f2 ff ff       	jmp    80105b41 <alltraps>

8010689b <vector207>:
.globl vector207
vector207:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $207
8010689d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801068a2:	e9 9a f2 ff ff       	jmp    80105b41 <alltraps>

801068a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $208
801068a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801068ae:	e9 8e f2 ff ff       	jmp    80105b41 <alltraps>

801068b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $209
801068b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068ba:	e9 82 f2 ff ff       	jmp    80105b41 <alltraps>

801068bf <vector210>:
.globl vector210
vector210:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $210
801068c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068c6:	e9 76 f2 ff ff       	jmp    80105b41 <alltraps>

801068cb <vector211>:
.globl vector211
vector211:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $211
801068cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068d2:	e9 6a f2 ff ff       	jmp    80105b41 <alltraps>

801068d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $212
801068d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068de:	e9 5e f2 ff ff       	jmp    80105b41 <alltraps>

801068e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $213
801068e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068ea:	e9 52 f2 ff ff       	jmp    80105b41 <alltraps>

801068ef <vector214>:
.globl vector214
vector214:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $214
801068f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068f6:	e9 46 f2 ff ff       	jmp    80105b41 <alltraps>

801068fb <vector215>:
.globl vector215
vector215:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $215
801068fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106902:	e9 3a f2 ff ff       	jmp    80105b41 <alltraps>

80106907 <vector216>:
.globl vector216
vector216:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $216
80106909:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010690e:	e9 2e f2 ff ff       	jmp    80105b41 <alltraps>

80106913 <vector217>:
.globl vector217
vector217:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $217
80106915:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010691a:	e9 22 f2 ff ff       	jmp    80105b41 <alltraps>

8010691f <vector218>:
.globl vector218
vector218:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $218
80106921:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106926:	e9 16 f2 ff ff       	jmp    80105b41 <alltraps>

8010692b <vector219>:
.globl vector219
vector219:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $219
8010692d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106932:	e9 0a f2 ff ff       	jmp    80105b41 <alltraps>

80106937 <vector220>:
.globl vector220
vector220:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $220
80106939:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010693e:	e9 fe f1 ff ff       	jmp    80105b41 <alltraps>

80106943 <vector221>:
.globl vector221
vector221:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $221
80106945:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010694a:	e9 f2 f1 ff ff       	jmp    80105b41 <alltraps>

8010694f <vector222>:
.globl vector222
vector222:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $222
80106951:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106956:	e9 e6 f1 ff ff       	jmp    80105b41 <alltraps>

8010695b <vector223>:
.globl vector223
vector223:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $223
8010695d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106962:	e9 da f1 ff ff       	jmp    80105b41 <alltraps>

80106967 <vector224>:
.globl vector224
vector224:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $224
80106969:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010696e:	e9 ce f1 ff ff       	jmp    80105b41 <alltraps>

80106973 <vector225>:
.globl vector225
vector225:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $225
80106975:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010697a:	e9 c2 f1 ff ff       	jmp    80105b41 <alltraps>

8010697f <vector226>:
.globl vector226
vector226:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $226
80106981:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106986:	e9 b6 f1 ff ff       	jmp    80105b41 <alltraps>

8010698b <vector227>:
.globl vector227
vector227:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $227
8010698d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106992:	e9 aa f1 ff ff       	jmp    80105b41 <alltraps>

80106997 <vector228>:
.globl vector228
vector228:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $228
80106999:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010699e:	e9 9e f1 ff ff       	jmp    80105b41 <alltraps>

801069a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $229
801069a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801069aa:	e9 92 f1 ff ff       	jmp    80105b41 <alltraps>

801069af <vector230>:
.globl vector230
vector230:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $230
801069b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069b6:	e9 86 f1 ff ff       	jmp    80105b41 <alltraps>

801069bb <vector231>:
.globl vector231
vector231:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $231
801069bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069c2:	e9 7a f1 ff ff       	jmp    80105b41 <alltraps>

801069c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $232
801069c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069ce:	e9 6e f1 ff ff       	jmp    80105b41 <alltraps>

801069d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $233
801069d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069da:	e9 62 f1 ff ff       	jmp    80105b41 <alltraps>

801069df <vector234>:
.globl vector234
vector234:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $234
801069e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069e6:	e9 56 f1 ff ff       	jmp    80105b41 <alltraps>

801069eb <vector235>:
.globl vector235
vector235:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $235
801069ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069f2:	e9 4a f1 ff ff       	jmp    80105b41 <alltraps>

801069f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $236
801069f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069fe:	e9 3e f1 ff ff       	jmp    80105b41 <alltraps>

80106a03 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $237
80106a05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a0a:	e9 32 f1 ff ff       	jmp    80105b41 <alltraps>

80106a0f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $238
80106a11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a16:	e9 26 f1 ff ff       	jmp    80105b41 <alltraps>

80106a1b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $239
80106a1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a22:	e9 1a f1 ff ff       	jmp    80105b41 <alltraps>

80106a27 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $240
80106a29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a2e:	e9 0e f1 ff ff       	jmp    80105b41 <alltraps>

80106a33 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $241
80106a35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a3a:	e9 02 f1 ff ff       	jmp    80105b41 <alltraps>

80106a3f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $242
80106a41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a46:	e9 f6 f0 ff ff       	jmp    80105b41 <alltraps>

80106a4b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $243
80106a4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a52:	e9 ea f0 ff ff       	jmp    80105b41 <alltraps>

80106a57 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $244
80106a59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a5e:	e9 de f0 ff ff       	jmp    80105b41 <alltraps>

80106a63 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $245
80106a65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a6a:	e9 d2 f0 ff ff       	jmp    80105b41 <alltraps>

80106a6f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $246
80106a71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a76:	e9 c6 f0 ff ff       	jmp    80105b41 <alltraps>

80106a7b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $247
80106a7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a82:	e9 ba f0 ff ff       	jmp    80105b41 <alltraps>

80106a87 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $248
80106a89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a8e:	e9 ae f0 ff ff       	jmp    80105b41 <alltraps>

80106a93 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $249
80106a95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a9a:	e9 a2 f0 ff ff       	jmp    80105b41 <alltraps>

80106a9f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $250
80106aa1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106aa6:	e9 96 f0 ff ff       	jmp    80105b41 <alltraps>

80106aab <vector251>:
.globl vector251
vector251:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $251
80106aad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ab2:	e9 8a f0 ff ff       	jmp    80105b41 <alltraps>

80106ab7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $252
80106ab9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106abe:	e9 7e f0 ff ff       	jmp    80105b41 <alltraps>

80106ac3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $253
80106ac5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106aca:	e9 72 f0 ff ff       	jmp    80105b41 <alltraps>

80106acf <vector254>:
.globl vector254
vector254:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $254
80106ad1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ad6:	e9 66 f0 ff ff       	jmp    80105b41 <alltraps>

80106adb <vector255>:
.globl vector255
vector255:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $255
80106add:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ae2:	e9 5a f0 ff ff       	jmp    80105b41 <alltraps>
80106ae7:	66 90                	xchg   %ax,%ax
80106ae9:	66 90                	xchg   %ax,%ax
80106aeb:	66 90                	xchg   %ax,%ax
80106aed:	66 90                	xchg   %ax,%ax
80106aef:	90                   	nop

80106af0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106af6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106afc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b02:	83 ec 1c             	sub    $0x1c,%esp
80106b05:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b08:	39 d3                	cmp    %edx,%ebx
80106b0a:	73 45                	jae    80106b51 <deallocuvm.part.0+0x61>
80106b0c:	89 c7                	mov    %eax,%edi
80106b0e:	eb 0a                	jmp    80106b1a <deallocuvm.part.0+0x2a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b10:	8d 59 01             	lea    0x1(%ecx),%ebx
80106b13:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b16:	39 da                	cmp    %ebx,%edx
80106b18:	76 37                	jbe    80106b51 <deallocuvm.part.0+0x61>
  pde = &pgdir[PDX(va)];
80106b1a:	89 d9                	mov    %ebx,%ecx
80106b1c:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106b1f:	8b 04 8f             	mov    (%edi,%ecx,4),%eax
80106b22:	a8 01                	test   $0x1,%al
80106b24:	74 ea                	je     80106b10 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106b26:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106b2d:	c1 ee 0a             	shr    $0xa,%esi
80106b30:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106b36:	8d b4 30 00 00 00 80 	lea    -0x80000000(%eax,%esi,1),%esi
    if(!pte)
80106b3d:	85 f6                	test   %esi,%esi
80106b3f:	74 cf                	je     80106b10 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106b41:	8b 06                	mov    (%esi),%eax
80106b43:	a8 01                	test   $0x1,%al
80106b45:	75 19                	jne    80106b60 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106b47:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b4d:	39 da                	cmp    %ebx,%edx
80106b4f:	77 c9                	ja     80106b1a <deallocuvm.part.0+0x2a>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b57:	5b                   	pop    %ebx
80106b58:	5e                   	pop    %esi
80106b59:	5f                   	pop    %edi
80106b5a:	5d                   	pop    %ebp
80106b5b:	c3                   	ret    
80106b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106b60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b65:	74 25                	je     80106b8c <deallocuvm.part.0+0x9c>
      kfree(v);
80106b67:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b6a:	05 00 00 00 80       	add    $0x80000000,%eax
80106b6f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b72:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106b78:	50                   	push   %eax
80106b79:	e8 52 bb ff ff       	call   801026d0 <kfree>
      *pte = 0;
80106b7e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106b84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b87:	83 c4 10             	add    $0x10,%esp
80106b8a:	eb 8a                	jmp    80106b16 <deallocuvm.part.0+0x26>
        panic("kfree");
80106b8c:	83 ec 0c             	sub    $0xc,%esp
80106b8f:	68 83 79 10 80       	push   $0x80107983
80106b94:	e8 e7 97 ff ff       	call   80100380 <panic>
80106b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ba0 <mappages>:
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ba6:	89 d3                	mov    %edx,%ebx
80106ba8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106bae:	83 ec 1c             	sub    $0x1c,%esp
80106bb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106bb4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106bb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bbd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bc3:	29 d8                	sub    %ebx,%eax
80106bc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106bc8:	eb 3d                	jmp    80106c07 <mappages+0x67>
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106bd0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106bd7:	c1 ea 0a             	shr    $0xa,%edx
80106bda:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106be0:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106be7:	85 d2                	test   %edx,%edx
80106be9:	74 75                	je     80106c60 <mappages+0xc0>
    if(*pte & PTE_P)
80106beb:	f6 02 01             	testb  $0x1,(%edx)
80106bee:	0f 85 86 00 00 00    	jne    80106c7a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106bf4:	0b 75 0c             	or     0xc(%ebp),%esi
80106bf7:	83 ce 01             	or     $0x1,%esi
80106bfa:	89 32                	mov    %esi,(%edx)
    if(a == last)
80106bfc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106bff:	74 6f                	je     80106c70 <mappages+0xd0>
    a += PGSIZE;
80106c01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106c0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c0d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c10:	89 d8                	mov    %ebx,%eax
80106c12:	c1 e8 16             	shr    $0x16,%eax
80106c15:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c18:	8b 07                	mov    (%edi),%eax
80106c1a:	a8 01                	test   $0x1,%al
80106c1c:	75 b2                	jne    80106bd0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c1e:	e8 dd bc ff ff       	call   80102900 <kalloc>
80106c23:	85 c0                	test   %eax,%eax
80106c25:	74 39                	je     80106c60 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c27:	83 ec 04             	sub    $0x4,%esp
80106c2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106c2d:	68 00 10 00 00       	push   $0x1000
80106c32:	6a 00                	push   $0x0
80106c34:	50                   	push   %eax
80106c35:	e8 d6 dc ff ff       	call   80104910 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106c3d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c40:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106c46:	83 c8 07             	or     $0x7,%eax
80106c49:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106c4b:	89 d8                	mov    %ebx,%eax
80106c4d:	c1 e8 0a             	shr    $0xa,%eax
80106c50:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c55:	01 c2                	add    %eax,%edx
80106c57:	eb 92                	jmp    80106beb <mappages+0x4b>
80106c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c68:	5b                   	pop    %ebx
80106c69:	5e                   	pop    %esi
80106c6a:	5f                   	pop    %edi
80106c6b:	5d                   	pop    %ebp
80106c6c:	c3                   	ret    
80106c6d:	8d 76 00             	lea    0x0(%esi),%esi
80106c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c73:	31 c0                	xor    %eax,%eax
}
80106c75:	5b                   	pop    %ebx
80106c76:	5e                   	pop    %esi
80106c77:	5f                   	pop    %edi
80106c78:	5d                   	pop    %ebp
80106c79:	c3                   	ret    
      panic("remap");
80106c7a:	83 ec 0c             	sub    $0xc,%esp
80106c7d:	68 5c 80 10 80       	push   $0x8010805c
80106c82:	e8 f9 96 ff ff       	call   80100380 <panic>
80106c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c8e:	66 90                	xchg   %ax,%ax

80106c90 <seginit>:
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c96:	e8 65 cf ff ff       	call   80103c00 <cpuid>
  pd[0] = size-1;
80106c9b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ca0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ca6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106caa:	c7 80 38 a8 14 80 ff 	movl   $0xffff,-0x7feb57c8(%eax)
80106cb1:	ff 00 00 
80106cb4:	c7 80 3c a8 14 80 00 	movl   $0xcf9a00,-0x7feb57c4(%eax)
80106cbb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cbe:	c7 80 40 a8 14 80 ff 	movl   $0xffff,-0x7feb57c0(%eax)
80106cc5:	ff 00 00 
80106cc8:	c7 80 44 a8 14 80 00 	movl   $0xcf9200,-0x7feb57bc(%eax)
80106ccf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cd2:	c7 80 48 a8 14 80 ff 	movl   $0xffff,-0x7feb57b8(%eax)
80106cd9:	ff 00 00 
80106cdc:	c7 80 4c a8 14 80 00 	movl   $0xcffa00,-0x7feb57b4(%eax)
80106ce3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ce6:	c7 80 50 a8 14 80 ff 	movl   $0xffff,-0x7feb57b0(%eax)
80106ced:	ff 00 00 
80106cf0:	c7 80 54 a8 14 80 00 	movl   $0xcff200,-0x7feb57ac(%eax)
80106cf7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106cfa:	05 30 a8 14 80       	add    $0x8014a830,%eax
  pd[1] = (uint)p;
80106cff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d03:	c1 e8 10             	shr    $0x10,%eax
80106d06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d0d:	0f 01 10             	lgdtl  (%eax)
}
80106d10:	c9                   	leave  
80106d11:	c3                   	ret    
80106d12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d20 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d20:	a1 04 d5 14 80       	mov    0x8014d504,%eax
80106d25:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d2a:	0f 22 d8             	mov    %eax,%cr3
}
80106d2d:	c3                   	ret    
80106d2e:	66 90                	xchg   %ax,%ax

80106d30 <switchuvm>:
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	57                   	push   %edi
80106d34:	56                   	push   %esi
80106d35:	53                   	push   %ebx
80106d36:	83 ec 1c             	sub    $0x1c,%esp
80106d39:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d3c:	85 f6                	test   %esi,%esi
80106d3e:	0f 84 cb 00 00 00    	je     80106e0f <switchuvm+0xdf>
  if(p->kstack == 0)
80106d44:	8b 46 08             	mov    0x8(%esi),%eax
80106d47:	85 c0                	test   %eax,%eax
80106d49:	0f 84 da 00 00 00    	je     80106e29 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d4f:	8b 46 04             	mov    0x4(%esi),%eax
80106d52:	85 c0                	test   %eax,%eax
80106d54:	0f 84 c2 00 00 00    	je     80106e1c <switchuvm+0xec>
  pushcli();
80106d5a:	e8 f1 d9 ff ff       	call   80104750 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d5f:	e8 2c ce ff ff       	call   80103b90 <mycpu>
80106d64:	89 c3                	mov    %eax,%ebx
80106d66:	e8 25 ce ff ff       	call   80103b90 <mycpu>
80106d6b:	89 c7                	mov    %eax,%edi
80106d6d:	e8 1e ce ff ff       	call   80103b90 <mycpu>
80106d72:	83 c7 08             	add    $0x8,%edi
80106d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d78:	e8 13 ce ff ff       	call   80103b90 <mycpu>
80106d7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d80:	ba 67 00 00 00       	mov    $0x67,%edx
80106d85:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d8c:	83 c0 08             	add    $0x8,%eax
80106d8f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d96:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d9b:	83 c1 08             	add    $0x8,%ecx
80106d9e:	c1 e8 18             	shr    $0x18,%eax
80106da1:	c1 e9 10             	shr    $0x10,%ecx
80106da4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106daa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106db0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106db5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dbc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106dc1:	e8 ca cd ff ff       	call   80103b90 <mycpu>
80106dc6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dcd:	e8 be cd ff ff       	call   80103b90 <mycpu>
80106dd2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106dd6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106dd9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ddf:	e8 ac cd ff ff       	call   80103b90 <mycpu>
80106de4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106de7:	e8 a4 cd ff ff       	call   80103b90 <mycpu>
80106dec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106df0:	b8 28 00 00 00       	mov    $0x28,%eax
80106df5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106df8:	8b 46 04             	mov    0x4(%esi),%eax
80106dfb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e00:	0f 22 d8             	mov    %eax,%cr3
}
80106e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e06:	5b                   	pop    %ebx
80106e07:	5e                   	pop    %esi
80106e08:	5f                   	pop    %edi
80106e09:	5d                   	pop    %ebp
  popcli();
80106e0a:	e9 51 da ff ff       	jmp    80104860 <popcli>
    panic("switchuvm: no process");
80106e0f:	83 ec 0c             	sub    $0xc,%esp
80106e12:	68 62 80 10 80       	push   $0x80108062
80106e17:	e8 64 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106e1c:	83 ec 0c             	sub    $0xc,%esp
80106e1f:	68 8d 80 10 80       	push   $0x8010808d
80106e24:	e8 57 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106e29:	83 ec 0c             	sub    $0xc,%esp
80106e2c:	68 78 80 10 80       	push   $0x80108078
80106e31:	e8 4a 95 ff ff       	call   80100380 <panic>
80106e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3d:	8d 76 00             	lea    0x0(%esi),%esi

80106e40 <inituvm>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
80106e49:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e4c:	8b 75 10             	mov    0x10(%ebp),%esi
80106e4f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e55:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e5b:	77 4b                	ja     80106ea8 <inituvm+0x68>
  mem = kalloc();
80106e5d:	e8 9e ba ff ff       	call   80102900 <kalloc>
  memset(mem, 0, PGSIZE);
80106e62:	83 ec 04             	sub    $0x4,%esp
80106e65:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e6a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e6c:	6a 00                	push   $0x0
80106e6e:	50                   	push   %eax
80106e6f:	e8 9c da ff ff       	call   80104910 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e74:	58                   	pop    %eax
80106e75:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e7b:	5a                   	pop    %edx
80106e7c:	6a 06                	push   $0x6
80106e7e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e83:	31 d2                	xor    %edx,%edx
80106e85:	50                   	push   %eax
80106e86:	89 f8                	mov    %edi,%eax
80106e88:	e8 13 fd ff ff       	call   80106ba0 <mappages>
  memmove(mem, init, sz);
80106e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e90:	89 75 10             	mov    %esi,0x10(%ebp)
80106e93:	83 c4 10             	add    $0x10,%esp
80106e96:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106e99:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e9f:	5b                   	pop    %ebx
80106ea0:	5e                   	pop    %esi
80106ea1:	5f                   	pop    %edi
80106ea2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ea3:	e9 08 db ff ff       	jmp    801049b0 <memmove>
    panic("inituvm: more than a page");
80106ea8:	83 ec 0c             	sub    $0xc,%esp
80106eab:	68 a1 80 10 80       	push   $0x801080a1
80106eb0:	e8 cb 94 ff ff       	call   80100380 <panic>
80106eb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <loaduvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 1c             	sub    $0x1c,%esp
80106ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ecc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106ecf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ed4:	0f 85 bb 00 00 00    	jne    80106f95 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106eda:	01 f0                	add    %esi,%eax
80106edc:	89 f3                	mov    %esi,%ebx
80106ede:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ee1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ee4:	01 f0                	add    %esi,%eax
80106ee6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ee9:	85 f6                	test   %esi,%esi
80106eeb:	0f 84 87 00 00 00    	je     80106f78 <loaduvm+0xb8>
80106ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106efb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106efe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106f00:	89 c2                	mov    %eax,%edx
80106f02:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106f05:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106f08:	f6 c2 01             	test   $0x1,%dl
80106f0b:	75 13                	jne    80106f20 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106f0d:	83 ec 0c             	sub    $0xc,%esp
80106f10:	68 bb 80 10 80       	push   $0x801080bb
80106f15:	e8 66 94 ff ff       	call   80100380 <panic>
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f20:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f23:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f29:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f2e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f35:	85 c0                	test   %eax,%eax
80106f37:	74 d4                	je     80106f0d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f39:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f3b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f3e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f48:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f4e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f51:	29 d9                	sub    %ebx,%ecx
80106f53:	05 00 00 00 80       	add    $0x80000000,%eax
80106f58:	57                   	push   %edi
80106f59:	51                   	push   %ecx
80106f5a:	50                   	push   %eax
80106f5b:	ff 75 10             	pushl  0x10(%ebp)
80106f5e:	e8 5d ac ff ff       	call   80101bc0 <readi>
80106f63:	83 c4 10             	add    $0x10,%esp
80106f66:	39 f8                	cmp    %edi,%eax
80106f68:	75 1e                	jne    80106f88 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f6a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106f70:	89 f0                	mov    %esi,%eax
80106f72:	29 d8                	sub    %ebx,%eax
80106f74:	39 c6                	cmp    %eax,%esi
80106f76:	77 80                	ja     80106ef8 <loaduvm+0x38>
}
80106f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f7b:	31 c0                	xor    %eax,%eax
}
80106f7d:	5b                   	pop    %ebx
80106f7e:	5e                   	pop    %esi
80106f7f:	5f                   	pop    %edi
80106f80:	5d                   	pop    %ebp
80106f81:	c3                   	ret    
80106f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f90:	5b                   	pop    %ebx
80106f91:	5e                   	pop    %esi
80106f92:	5f                   	pop    %edi
80106f93:	5d                   	pop    %ebp
80106f94:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106f95:	83 ec 0c             	sub    $0xc,%esp
80106f98:	68 84 81 10 80       	push   $0x80108184
80106f9d:	e8 de 93 ff ff       	call   80100380 <panic>
80106fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fb0 <allocuvm>:
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106fb9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106fbc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106fbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fc2:	85 c0                	test   %eax,%eax
80106fc4:	0f 88 b6 00 00 00    	js     80107080 <allocuvm+0xd0>
  if(newsz < oldsz)
80106fca:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106fd0:	0f 82 9a 00 00 00    	jb     80107070 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106fd6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106fdc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106fe2:	39 75 10             	cmp    %esi,0x10(%ebp)
80106fe5:	77 44                	ja     8010702b <allocuvm+0x7b>
80106fe7:	e9 87 00 00 00       	jmp    80107073 <allocuvm+0xc3>
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106ff0:	83 ec 04             	sub    $0x4,%esp
80106ff3:	68 00 10 00 00       	push   $0x1000
80106ff8:	6a 00                	push   $0x0
80106ffa:	50                   	push   %eax
80106ffb:	e8 10 d9 ff ff       	call   80104910 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107000:	58                   	pop    %eax
80107001:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107007:	5a                   	pop    %edx
80107008:	6a 06                	push   $0x6
8010700a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010700f:	89 f2                	mov    %esi,%edx
80107011:	50                   	push   %eax
80107012:	89 f8                	mov    %edi,%eax
80107014:	e8 87 fb ff ff       	call   80106ba0 <mappages>
80107019:	83 c4 10             	add    $0x10,%esp
8010701c:	85 c0                	test   %eax,%eax
8010701e:	78 78                	js     80107098 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107020:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107026:	39 75 10             	cmp    %esi,0x10(%ebp)
80107029:	76 48                	jbe    80107073 <allocuvm+0xc3>
    mem = kalloc();
8010702b:	e8 d0 b8 ff ff       	call   80102900 <kalloc>
80107030:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107032:	85 c0                	test   %eax,%eax
80107034:	75 ba                	jne    80106ff0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107036:	83 ec 0c             	sub    $0xc,%esp
80107039:	68 d9 80 10 80       	push   $0x801080d9
8010703e:	e8 3d 96 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
80107043:	8b 45 0c             	mov    0xc(%ebp),%eax
80107046:	83 c4 10             	add    $0x10,%esp
80107049:	39 45 10             	cmp    %eax,0x10(%ebp)
8010704c:	74 32                	je     80107080 <allocuvm+0xd0>
8010704e:	8b 55 10             	mov    0x10(%ebp),%edx
80107051:	89 c1                	mov    %eax,%ecx
80107053:	89 f8                	mov    %edi,%eax
80107055:	e8 96 fa ff ff       	call   80106af0 <deallocuvm.part.0>
      return 0;
8010705a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107064:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107067:	5b                   	pop    %ebx
80107068:	5e                   	pop    %esi
80107069:	5f                   	pop    %edi
8010706a:	5d                   	pop    %ebp
8010706b:	c3                   	ret    
8010706c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107070:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107079:	5b                   	pop    %ebx
8010707a:	5e                   	pop    %esi
8010707b:	5f                   	pop    %edi
8010707c:	5d                   	pop    %ebp
8010707d:	c3                   	ret    
8010707e:	66 90                	xchg   %ax,%ax
    return 0;
80107080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010708a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010708d:	5b                   	pop    %ebx
8010708e:	5e                   	pop    %esi
8010708f:	5f                   	pop    %edi
80107090:	5d                   	pop    %ebp
80107091:	c3                   	ret    
80107092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107098:	83 ec 0c             	sub    $0xc,%esp
8010709b:	68 f1 80 10 80       	push   $0x801080f1
801070a0:	e8 db 95 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
801070a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a8:	83 c4 10             	add    $0x10,%esp
801070ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801070ae:	74 0c                	je     801070bc <allocuvm+0x10c>
801070b0:	8b 55 10             	mov    0x10(%ebp),%edx
801070b3:	89 c1                	mov    %eax,%ecx
801070b5:	89 f8                	mov    %edi,%eax
801070b7:	e8 34 fa ff ff       	call   80106af0 <deallocuvm.part.0>
      kfree(mem);
801070bc:	83 ec 0c             	sub    $0xc,%esp
801070bf:	53                   	push   %ebx
801070c0:	e8 0b b6 ff ff       	call   801026d0 <kfree>
      return 0;
801070c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801070cc:	83 c4 10             	add    $0x10,%esp
}
801070cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070e0 <deallocuvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070ec:	39 d1                	cmp    %edx,%ecx
801070ee:	73 10                	jae    80107100 <deallocuvm+0x20>
}
801070f0:	5d                   	pop    %ebp
801070f1:	e9 fa f9 ff ff       	jmp    80106af0 <deallocuvm.part.0>
801070f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fd:	8d 76 00             	lea    0x0(%esi),%esi
80107100:	89 d0                	mov    %edx,%eax
80107102:	5d                   	pop    %ebp
80107103:	c3                   	ret    
80107104:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010710f:	90                   	nop

80107110 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	57                   	push   %edi
80107114:	56                   	push   %esi
80107115:	53                   	push   %ebx
80107116:	83 ec 0c             	sub    $0xc,%esp
80107119:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010711c:	85 f6                	test   %esi,%esi
8010711e:	74 59                	je     80107179 <freevm+0x69>
  if(newsz >= oldsz)
80107120:	31 c9                	xor    %ecx,%ecx
80107122:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107127:	89 f0                	mov    %esi,%eax
80107129:	89 f3                	mov    %esi,%ebx
8010712b:	e8 c0 f9 ff ff       	call   80106af0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107130:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107136:	eb 0f                	jmp    80107147 <freevm+0x37>
80107138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713f:	90                   	nop
80107140:	83 c3 04             	add    $0x4,%ebx
80107143:	39 df                	cmp    %ebx,%edi
80107145:	74 23                	je     8010716a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107147:	8b 03                	mov    (%ebx),%eax
80107149:	a8 01                	test   $0x1,%al
8010714b:	74 f3                	je     80107140 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010714d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107152:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107155:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107158:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010715d:	50                   	push   %eax
8010715e:	e8 6d b5 ff ff       	call   801026d0 <kfree>
80107163:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107166:	39 df                	cmp    %ebx,%edi
80107168:	75 dd                	jne    80107147 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010716a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010716d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107170:	5b                   	pop    %ebx
80107171:	5e                   	pop    %esi
80107172:	5f                   	pop    %edi
80107173:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107174:	e9 57 b5 ff ff       	jmp    801026d0 <kfree>
    panic("freevm: no pgdir");
80107179:	83 ec 0c             	sub    $0xc,%esp
8010717c:	68 0d 81 10 80       	push   $0x8010810d
80107181:	e8 fa 91 ff ff       	call   80100380 <panic>
80107186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718d:	8d 76 00             	lea    0x0(%esi),%esi

80107190 <setupkvm>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	56                   	push   %esi
80107194:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107195:	e8 66 b7 ff ff       	call   80102900 <kalloc>
8010719a:	89 c6                	mov    %eax,%esi
8010719c:	85 c0                	test   %eax,%eax
8010719e:	74 42                	je     801071e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801071a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071a3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801071a8:	68 00 10 00 00       	push   $0x1000
801071ad:	6a 00                	push   $0x0
801071af:	50                   	push   %eax
801071b0:	e8 5b d7 ff ff       	call   80104910 <memset>
801071b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071bb:	83 ec 08             	sub    $0x8,%esp
801071be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071c1:	ff 73 0c             	pushl  0xc(%ebx)
801071c4:	8b 13                	mov    (%ebx),%edx
801071c6:	50                   	push   %eax
801071c7:	29 c1                	sub    %eax,%ecx
801071c9:	89 f0                	mov    %esi,%eax
801071cb:	e8 d0 f9 ff ff       	call   80106ba0 <mappages>
801071d0:	83 c4 10             	add    $0x10,%esp
801071d3:	85 c0                	test   %eax,%eax
801071d5:	78 19                	js     801071f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071d7:	83 c3 10             	add    $0x10,%ebx
801071da:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801071e0:	75 d6                	jne    801071b8 <setupkvm+0x28>
}
801071e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071e5:	89 f0                	mov    %esi,%eax
801071e7:	5b                   	pop    %ebx
801071e8:	5e                   	pop    %esi
801071e9:	5d                   	pop    %ebp
801071ea:	c3                   	ret    
801071eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071ef:	90                   	nop
      freevm(pgdir);
801071f0:	83 ec 0c             	sub    $0xc,%esp
801071f3:	56                   	push   %esi
      return 0;
801071f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071f6:	e8 15 ff ff ff       	call   80107110 <freevm>
      return 0;
801071fb:	83 c4 10             	add    $0x10,%esp
}
801071fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107201:	89 f0                	mov    %esi,%eax
80107203:	5b                   	pop    %ebx
80107204:	5e                   	pop    %esi
80107205:	5d                   	pop    %ebp
80107206:	c3                   	ret    
80107207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010720e:	66 90                	xchg   %ax,%ax

80107210 <kvmalloc>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107216:	e8 75 ff ff ff       	call   80107190 <setupkvm>
8010721b:	a3 04 d5 14 80       	mov    %eax,0x8014d504
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107220:	05 00 00 00 80       	add    $0x80000000,%eax
80107225:	0f 22 d8             	mov    %eax,%cr3
}
80107228:	c9                   	leave  
80107229:	c3                   	ret    
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107230 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	83 ec 08             	sub    $0x8,%esp
80107236:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107239:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010723c:	89 c1                	mov    %eax,%ecx
8010723e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107241:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107244:	f6 c2 01             	test   $0x1,%dl
80107247:	75 17                	jne    80107260 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107249:	83 ec 0c             	sub    $0xc,%esp
8010724c:	68 1e 81 10 80       	push   $0x8010811e
80107251:	e8 2a 91 ff ff       	call   80100380 <panic>
80107256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107260:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107263:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107269:	25 fc 0f 00 00       	and    $0xffc,%eax
8010726e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107275:	85 c0                	test   %eax,%eax
80107277:	74 d0                	je     80107249 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107279:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010727c:	c9                   	leave  
8010727d:	c3                   	ret    
8010727e:	66 90                	xchg   %ax,%ax

80107280 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	57                   	push   %edi
80107284:	56                   	push   %esi
80107285:	53                   	push   %ebx
80107286:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte;
  uint pa, i, flags;
  
  char *mem;
  
  if((d = setupkvm()) == 0)
80107289:	e8 02 ff ff ff       	call   80107190 <setupkvm>
8010728e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107291:	85 c0                	test   %eax,%eax
80107293:	0f 84 4e 01 00 00    	je     801073e7 <copyuvm+0x167>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107299:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010729c:	85 c9                	test   %ecx,%ecx
8010729e:	74 75                	je     80107315 <copyuvm+0x95>
801072a0:	31 ff                	xor    %edi,%edi
801072a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801072a8:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801072ab:	89 f8                	mov    %edi,%eax
801072ad:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801072b0:	8b 04 82             	mov    (%edx,%eax,4),%eax
801072b3:	a8 01                	test   $0x1,%al
801072b5:	75 11                	jne    801072c8 <copyuvm+0x48>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801072b7:	83 ec 0c             	sub    $0xc,%esp
801072ba:	68 28 81 10 80       	push   $0x80108128
801072bf:	e8 bc 90 ff ff       	call   80100380 <panic>
801072c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801072c8:	89 f9                	mov    %edi,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801072cf:	c1 e9 0a             	shr    $0xa,%ecx
801072d2:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801072d8:	8d 8c 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%ecx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072df:	85 c9                	test   %ecx,%ecx
801072e1:	74 d4                	je     801072b7 <copyuvm+0x37>
    if(!(*pte & PTE_P))
801072e3:	8b 19                	mov    (%ecx),%ebx
801072e5:	f6 c3 01             	test   $0x1,%bl
801072e8:	0f 84 1c 01 00 00    	je     8010740a <copyuvm+0x18a>
      panic("copyuvm: page not present");

    if(type == 1){
801072ee:	a1 40 ad 14 80       	mov    0x8014ad40,%eax
801072f3:	83 f8 01             	cmp    $0x1,%eax
801072f6:	74 38                	je     80107330 <copyuvm+0xb0>
      *pte = (~ PTE_W) & *pte;
    }
    pa = PTE_ADDR(*pte);
801072f8:	89 de                	mov    %ebx,%esi
    flags = PTE_FLAGS(*pte);
801072fa:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107300:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi



    if(type == 0){
80107306:	85 c0                	test   %eax,%eax
80107308:	74 76                	je     80107380 <copyuvm+0x100>
  for(i = 0; i < sz; i += PGSIZE){
8010730a:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107310:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107313:	77 93                	ja     801072a8 <copyuvm+0x28>
      icount(pa,1);
    }
    

  }
  if(type == 1){
80107315:	83 3d 40 ad 14 80 01 	cmpl   $0x1,0x8014ad40
8010731c:	0f 84 de 00 00 00    	je     80107400 <copyuvm+0x180>
  freevm(d);
  if(type == 1){
    flush_tlb_all();
  }
  return 0;
}
80107322:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107325:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107328:	5b                   	pop    %ebx
80107329:	5e                   	pop    %esi
8010732a:	5f                   	pop    %edi
8010732b:	5d                   	pop    %ebp
8010732c:	c3                   	ret    
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
      *pte = (~ PTE_W) & *pte;
80107330:	89 d8                	mov    %ebx,%eax
    pa = PTE_ADDR(*pte);
80107332:	89 de                	mov    %ebx,%esi
    flags = PTE_FLAGS(*pte);
80107334:	81 e3 fd 0f 00 00    	and    $0xffd,%ebx
      *pte = (~ PTE_W) & *pte;
8010733a:	83 e0 fd             	and    $0xfffffffd,%eax
    pa = PTE_ADDR(*pte);
8010733d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      *pte = (~ PTE_W) & *pte;
80107343:	89 01                	mov    %eax,(%ecx)
    if(type == 0){
80107345:	a1 40 ad 14 80       	mov    0x8014ad40,%eax
8010734a:	85 c0                	test   %eax,%eax
8010734c:	74 32                	je     80107380 <copyuvm+0x100>
    if(type == 1){
8010734e:	83 f8 01             	cmp    $0x1,%eax
80107351:	75 b7                	jne    8010730a <copyuvm+0x8a>
      if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107353:	83 ec 08             	sub    $0x8,%esp
80107356:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107359:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010735e:	89 fa                	mov    %edi,%edx
80107360:	53                   	push   %ebx
80107361:	56                   	push   %esi
80107362:	e8 39 f8 ff ff       	call   80106ba0 <mappages>
80107367:	83 c4 10             	add    $0x10,%esp
8010736a:	85 c0                	test   %eax,%eax
8010736c:	78 62                	js     801073d0 <copyuvm+0x150>
      icount(pa,1);
8010736e:	83 ec 08             	sub    $0x8,%esp
80107371:	6a 01                	push   $0x1
80107373:	56                   	push   %esi
80107374:	e8 77 b2 ff ff       	call   801025f0 <icount>
80107379:	83 c4 10             	add    $0x10,%esp
8010737c:	eb 8c                	jmp    8010730a <copyuvm+0x8a>
8010737e:	66 90                	xchg   %ax,%ax
    if((mem = kalloc()) == 0)
80107380:	e8 7b b5 ff ff       	call   80102900 <kalloc>
80107385:	89 c1                	mov    %eax,%ecx
80107387:	85 c0                	test   %eax,%eax
80107389:	74 45                	je     801073d0 <copyuvm+0x150>
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010738b:	83 ec 04             	sub    $0x4,%esp
8010738e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107394:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107397:	68 00 10 00 00       	push   $0x1000
8010739c:	50                   	push   %eax
8010739d:	51                   	push   %ecx
8010739e:	e8 0d d6 ff ff       	call   801049b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801073a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801073a6:	58                   	pop    %eax
801073a7:	5a                   	pop    %edx
801073a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ab:	53                   	push   %ebx
801073ac:	89 fa                	mov    %edi,%edx
801073ae:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
801073b4:	51                   	push   %ecx
801073b5:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073ba:	e8 e1 f7 ff ff       	call   80106ba0 <mappages>
801073bf:	83 c4 10             	add    $0x10,%esp
801073c2:	85 c0                	test   %eax,%eax
801073c4:	78 0a                	js     801073d0 <copyuvm+0x150>
    if(type == 1){
801073c6:	a1 40 ad 14 80       	mov    0x8014ad40,%eax
801073cb:	eb 81                	jmp    8010734e <copyuvm+0xce>
801073cd:	8d 76 00             	lea    0x0(%esi),%esi
  freevm(d);
801073d0:	83 ec 0c             	sub    $0xc,%esp
801073d3:	ff 75 e0             	pushl  -0x20(%ebp)
801073d6:	e8 35 fd ff ff       	call   80107110 <freevm>
  if(type == 1){
801073db:	83 c4 10             	add    $0x10,%esp
801073de:	83 3d 40 ad 14 80 01 	cmpl   $0x1,0x8014ad40
801073e5:	74 12                	je     801073f9 <copyuvm+0x179>
  return 0;
801073e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801073ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073f4:	5b                   	pop    %ebx
801073f5:	5e                   	pop    %esi
801073f6:	5f                   	pop    %edi
801073f7:	5d                   	pop    %ebp
801073f8:	c3                   	ret    
    flush_tlb_all();
801073f9:	e8 66 e7 ff ff       	call   80105b64 <flush_tlb_all>
801073fe:	eb e7                	jmp    801073e7 <copyuvm+0x167>
    flush_tlb_all();
80107400:	e8 5f e7 ff ff       	call   80105b64 <flush_tlb_all>
80107405:	e9 18 ff ff ff       	jmp    80107322 <copyuvm+0xa2>
      panic("copyuvm: page not present");
8010740a:	83 ec 0c             	sub    $0xc,%esp
8010740d:	68 42 81 10 80       	push   $0x80108142
80107412:	e8 69 8f ff ff       	call   80100380 <panic>
80107417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010741e:	66 90                	xchg   %ax,%ax

80107420 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107426:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107429:	89 c1                	mov    %eax,%ecx
8010742b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010742e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107431:	f6 c2 01             	test   $0x1,%dl
80107434:	0f 84 a2 02 00 00    	je     801076dc <uva2ka.cold>
  return &pgtab[PTX(va)];
8010743a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010743d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107443:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107444:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107449:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107450:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107452:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107457:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010745a:	05 00 00 00 80       	add    $0x80000000,%eax
8010745f:	83 fa 05             	cmp    $0x5,%edx
80107462:	ba 00 00 00 00       	mov    $0x0,%edx
80107467:	0f 45 c2             	cmovne %edx,%eax
}
8010746a:	c3                   	ret    
8010746b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010746f:	90                   	nop

80107470 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	57                   	push   %edi
80107474:	56                   	push   %esi
80107475:	53                   	push   %ebx
80107476:	83 ec 0c             	sub    $0xc,%esp
80107479:	8b 75 14             	mov    0x14(%ebp),%esi
8010747c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010747f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107482:	85 f6                	test   %esi,%esi
80107484:	75 51                	jne    801074d7 <copyout+0x67>
80107486:	e9 a5 00 00 00       	jmp    80107530 <copyout+0xc0>
8010748b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010748f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107490:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107496:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010749c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801074a2:	74 75                	je     80107519 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801074a4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801074a6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801074a9:	29 c3                	sub    %eax,%ebx
801074ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801074b1:	39 f3                	cmp    %esi,%ebx
801074b3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801074b6:	29 f8                	sub    %edi,%eax
801074b8:	83 ec 04             	sub    $0x4,%esp
801074bb:	01 c8                	add    %ecx,%eax
801074bd:	53                   	push   %ebx
801074be:	52                   	push   %edx
801074bf:	50                   	push   %eax
801074c0:	e8 eb d4 ff ff       	call   801049b0 <memmove>
    len -= n;
    buf += n;
801074c5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801074c8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801074ce:	83 c4 10             	add    $0x10,%esp
    buf += n;
801074d1:	01 da                	add    %ebx,%edx
  while(len > 0){
801074d3:	29 de                	sub    %ebx,%esi
801074d5:	74 59                	je     80107530 <copyout+0xc0>
  if(*pde & PTE_P){
801074d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801074da:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074dc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801074de:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074e1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801074e7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801074ea:	f6 c1 01             	test   $0x1,%cl
801074ed:	0f 84 f0 01 00 00    	je     801076e3 <copyout.cold>
  return &pgtab[PTX(va)];
801074f3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074f5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801074fb:	c1 eb 0c             	shr    $0xc,%ebx
801074fe:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107504:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010750b:	89 d9                	mov    %ebx,%ecx
8010750d:	83 e1 05             	and    $0x5,%ecx
80107510:	83 f9 05             	cmp    $0x5,%ecx
80107513:	0f 84 77 ff ff ff    	je     80107490 <copyout+0x20>
  }
  return 0;
}
80107519:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010751c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107521:	5b                   	pop    %ebx
80107522:	5e                   	pop    %esi
80107523:	5f                   	pop    %edi
80107524:	5d                   	pop    %ebp
80107525:	c3                   	ret    
80107526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010752d:	8d 76 00             	lea    0x0(%esi),%esi
80107530:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107533:	31 c0                	xor    %eax,%eax
}
80107535:	5b                   	pop    %ebx
80107536:	5e                   	pop    %esi
80107537:	5f                   	pop    %edi
80107538:	5d                   	pop    %ebp
80107539:	c3                   	ret    
8010753a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107540 <pg_fault>:


void pg_fault(uint err_code)
{ 
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	57                   	push   %edi
80107544:	56                   	push   %esi
80107545:	53                   	push   %ebx
80107546:	83 ec 0c             	sub    $0xc,%esp
80107549:	8b 5d 08             	mov    0x8(%ebp),%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010754c:	0f 20 d6             	mov    %cr2,%esi
  uint va = rcr2();       
  if(myproc() == 0)  
8010754f:	e8 cc c6 ff ff       	call   80103c20 <myproc>
80107554:	85 c0                	test   %eax,%eax
80107556:	0f 84 55 01 00 00    	je     801076b1 <pg_fault+0x171>
  { 
      cprintf("Error pg_fault: No user process from cpu %d, cr2=0x%x\n", cpuid(), va); 
      panic("Page_Fault");
  }
  pte_t *pte;
  pte = walkpgdir(myproc()->pgdir, (void*)va, 0);
8010755c:	e8 bf c6 ff ff       	call   80103c20 <myproc>
  pde = &pgdir[PDX(va)];
80107561:	89 f2                	mov    %esi,%edx
  if(*pde & PTE_P){
80107563:	8b 40 04             	mov    0x4(%eax),%eax
  pde = &pgdir[PDX(va)];
80107566:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107569:	8b 04 90             	mov    (%eax,%edx,4),%eax
8010756c:	a8 01                	test   $0x1,%al
8010756e:	0f 84 76 01 00 00    	je     801076ea <pg_fault.cold>
  return &pgtab[PTX(va)];
80107574:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107576:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
8010757b:	c1 ea 0a             	shr    $0xa,%edx
8010757e:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107584:	8d bc 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edi
   if(*pte & PTE_W)
8010758b:	8b 07                	mov    (%edi),%eax
8010758d:	a8 02                	test   $0x2,%al
8010758f:	0f 85 03 01 00 00    	jne    80107698 <pg_fault+0x158>
    {
        cprintf("error code: %x, addr 0x%x\n", err_code, va);
        panic("Error pg_fault: Already writeable");
    }

  if( pte == 0  || !(*pte) || va >= KERNBASE || !PTE_U || ! PTE_P )
80107595:	85 c0                	test   %eax,%eax
80107597:	74 77                	je     80107610 <pg_fault+0xd0>
80107599:	85 f6                	test   %esi,%esi
8010759b:	78 73                	js     80107610 <pg_fault+0xd0>
      cprintf("Error pg_fault: Illegal (virtual) addr on cpu %d address 0x%x, killing proc %s id (pid) %d\n", cpuid(), va, myproc()->name, myproc()->pid);

      return;
  }

    uint pa = PTE_ADDR(*pte);                   
8010759d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    uint frameC = fcount(pa);  
801075a2:	83 ec 0c             	sub    $0xc,%esp
801075a5:	50                   	push   %eax
    uint pa = PTE_ADDR(*pte);                   
801075a6:	89 c3                	mov    %eax,%ebx
    uint frameC = fcount(pa);  
801075a8:	e8 c3 b0 ff ff       	call   80102670 <fcount>

    if(frameC == 1)
801075ad:	83 c4 10             	add    $0x10,%esp
801075b0:	83 f8 01             	cmp    $0x1,%eax
801075b3:	0f 84 d7 00 00 00    	je     80107690 <pg_fault+0x150>
        //flush tlb because PTEs changed
        flush_tlb_all();
        return;
    }              

    if(frameC < 1)
801075b9:	85 c0                	test   %eax,%eax
801075bb:	0f 84 0e 01 00 00    	je     801076cf <pg_fault+0x18f>
        panic("Error pg_fault: wrong frame Count");
    }

    if(frameC > 1)                       
    {
        char* mem = kalloc();
801075c1:	e8 3a b3 ff ff       	call   80102900 <kalloc>
801075c6:	89 c6                	mov    %eax,%esi

        if(mem != 0)  // page available
801075c8:	85 c0                	test   %eax,%eax
801075ca:	0f 84 80 00 00 00    	je     80107650 <pg_fault+0x110>
        {   
          memmove(mem, (char*)P2V(pa), PGSIZE); 
801075d0:	83 ec 04             	sub    $0x4,%esp
801075d3:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075d9:	68 00 10 00 00       	push   $0x1000
801075de:	50                   	push   %eax
801075df:	56                   	push   %esi
          // new PTE to new page
          *pte =  PTE_U | PTE_W | PTE_P | V2P(mem);
801075e0:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801075e6:	83 ce 07             	or     $0x7,%esi
          memmove(mem, (char*)P2V(pa), PGSIZE); 
801075e9:	e8 c2 d3 ff ff       	call   801049b0 <memmove>
          *pte =  PTE_U | PTE_W | PTE_P | V2P(mem);
801075ee:	89 37                	mov    %esi,(%edi)
          icount(pa,0);
801075f0:	58                   	pop    %eax
801075f1:	5a                   	pop    %edx
801075f2:	6a 00                	push   $0x0
801075f4:	53                   	push   %ebx
801075f5:	e8 f6 af ff ff       	call   801025f0 <icount>
          //flush tlb because PTEs changed
          flush_tlb_all();
801075fa:	83 c4 10             	add    $0x10,%esp

    }

    //flush tlb because PTEs changed
    flush_tlb_all();
801075fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107600:	5b                   	pop    %ebx
80107601:	5e                   	pop    %esi
80107602:	5f                   	pop    %edi
80107603:	5d                   	pop    %ebp
          flush_tlb_all();
80107604:	e9 5b e5 ff ff       	jmp    80105b64 <flush_tlb_all>
80107609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->killed = 1;
80107610:	e8 0b c6 ff ff       	call   80103c20 <myproc>
80107615:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      cprintf("Error pg_fault: Illegal (virtual) addr on cpu %d address 0x%x, killing proc %s id (pid) %d\n", cpuid(), va, myproc()->name, myproc()->pid);
8010761c:	e8 ff c5 ff ff       	call   80103c20 <myproc>
80107621:	8b 78 10             	mov    0x10(%eax),%edi
80107624:	e8 f7 c5 ff ff       	call   80103c20 <myproc>
80107629:	89 c3                	mov    %eax,%ebx
8010762b:	e8 d0 c5 ff ff       	call   80103c00 <cpuid>
80107630:	83 c3 6c             	add    $0x6c,%ebx
80107633:	83 ec 0c             	sub    $0xc,%esp
80107636:	57                   	push   %edi
80107637:	53                   	push   %ebx
80107638:	56                   	push   %esi
80107639:	50                   	push   %eax
8010763a:	68 04 82 10 80       	push   $0x80108204
8010763f:	e8 3c 90 ff ff       	call   80100680 <cprintf>
      return;
80107644:	83 c4 20             	add    $0x20,%esp
80107647:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010764a:	5b                   	pop    %ebx
8010764b:	5e                   	pop    %esi
8010764c:	5f                   	pop    %edi
8010764d:	5d                   	pop    %ebp
8010764e:	c3                   	ret    
8010764f:	90                   	nop
        myproc()->killed = 1;
80107650:	e8 cb c5 ff ff       	call   80103c20 <myproc>
80107655:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        cprintf("Error pg_fault: Out of memory, kill proc %s with pid %d\n", myproc()->name, myproc()->pid);          
8010765c:	e8 bf c5 ff ff       	call   80103c20 <myproc>
80107661:	8b 58 10             	mov    0x10(%eax),%ebx
80107664:	e8 b7 c5 ff ff       	call   80103c20 <myproc>
80107669:	83 ec 04             	sub    $0x4,%esp
8010766c:	83 c0 6c             	add    $0x6c,%eax
8010766f:	53                   	push   %ebx
80107670:	50                   	push   %eax
80107671:	68 84 82 10 80       	push   $0x80108284
80107676:	e8 05 90 ff ff       	call   80100680 <cprintf>
        return;
8010767b:	83 c4 10             	add    $0x10,%esp
8010767e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107681:	5b                   	pop    %ebx
80107682:	5e                   	pop    %esi
80107683:	5f                   	pop    %edi
80107684:	5d                   	pop    %ebp
80107685:	c3                   	ret    
80107686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768d:	8d 76 00             	lea    0x0(%esi),%esi
        *pte = PTE_W | *pte;  
80107690:	83 0f 02             	orl    $0x2,(%edi)
        flush_tlb_all();
80107693:	e9 65 ff ff ff       	jmp    801075fd <pg_fault+0xbd>
        cprintf("error code: %x, addr 0x%x\n", err_code, va);
80107698:	51                   	push   %ecx
80107699:	56                   	push   %esi
8010769a:	53                   	push   %ebx
8010769b:	68 67 81 10 80       	push   $0x80108167
801076a0:	e8 db 8f ff ff       	call   80100680 <cprintf>
        panic("Error pg_fault: Already writeable");
801076a5:	c7 04 24 e0 81 10 80 	movl   $0x801081e0,(%esp)
801076ac:	e8 cf 8c ff ff       	call   80100380 <panic>
      cprintf("Error pg_fault: No user process from cpu %d, cr2=0x%x\n", cpuid(), va); 
801076b1:	e8 4a c5 ff ff       	call   80103c00 <cpuid>
801076b6:	53                   	push   %ebx
801076b7:	56                   	push   %esi
801076b8:	50                   	push   %eax
801076b9:	68 a8 81 10 80       	push   $0x801081a8
801076be:	e8 bd 8f ff ff       	call   80100680 <cprintf>
      panic("Page_Fault");
801076c3:	c7 04 24 5c 81 10 80 	movl   $0x8010815c,(%esp)
801076ca:	e8 b1 8c ff ff       	call   80100380 <panic>
        panic("Error pg_fault: wrong frame Count");
801076cf:	83 ec 0c             	sub    $0xc,%esp
801076d2:	68 60 82 10 80       	push   $0x80108260
801076d7:	e8 a4 8c ff ff       	call   80100380 <panic>

801076dc <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801076dc:	a1 00 00 00 00       	mov    0x0,%eax
801076e1:	0f 0b                	ud2    

801076e3 <copyout.cold>:
801076e3:	a1 00 00 00 00       	mov    0x0,%eax
801076e8:	0f 0b                	ud2    

801076ea <pg_fault.cold>:
   if(*pte & PTE_W)
801076ea:	a1 00 00 00 00       	mov    0x0,%eax
801076ef:	0f 0b                	ud2    
