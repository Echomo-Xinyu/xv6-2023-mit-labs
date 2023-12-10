
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0023a117          	auipc	sp,0x23a
    80000004:	c9010113          	add	sp,sp,-880 # 80239c90 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1c1050ef          	jal	800059d6 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000001c:	1101                	add	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000028:	00009517          	auipc	a0,0x9
    8000002c:	8d850513          	add	a0,a0,-1832 # 80008900 <kmem>
    80000030:	00006097          	auipc	ra,0x6
    80000034:	38e080e7          	jalr	910(ra) # 800063be <acquire>
  r = kmem.freelist;
    80000038:	00009497          	auipc	s1,0x9
    8000003c:	8e04b483          	ld	s1,-1824(s1) # 80008918 <kmem+0x18>
  if(r) {
    80000040:	c0b5                	beqz	s1,800000a4 <kalloc+0x88>
    kmem.freelist = r->next;
    80000042:	609c                	ld	a5,0(s1)
    80000044:	00009917          	auipc	s2,0x9
    80000048:	8bc90913          	add	s2,s2,-1860 # 80008900 <kmem>
    8000004c:	00f93c23          	sd	a5,24(s2)
    acquire(&kmem.reflock);
    80000050:	00009517          	auipc	a0,0x9
    80000054:	8d050513          	add	a0,a0,-1840 # 80008920 <kmem+0x20>
    80000058:	00006097          	auipc	ra,0x6
    8000005c:	366080e7          	jalr	870(ra) # 800063be <acquire>
    kmem.refcount[(uint64)r/PGSIZE] = 1;
    80000060:	00c4d793          	srl	a5,s1,0xc
    80000064:	07b1                	add	a5,a5,12
    80000066:	078a                	sll	a5,a5,0x2
    80000068:	97ca                	add	a5,a5,s2
    8000006a:	4705                	li	a4,1
    8000006c:	c798                	sw	a4,8(a5)
    release(&kmem.reflock);
    8000006e:	00009517          	auipc	a0,0x9
    80000072:	8b250513          	add	a0,a0,-1870 # 80008920 <kmem+0x20>
    80000076:	00006097          	auipc	ra,0x6
    8000007a:	3fc080e7          	jalr	1020(ra) # 80006472 <release>
  }
  release(&kmem.lock);
    8000007e:	854a                	mv	a0,s2
    80000080:	00006097          	auipc	ra,0x6
    80000084:	3f2080e7          	jalr	1010(ra) # 80006472 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000088:	6605                	lui	a2,0x1
    8000008a:	4595                	li	a1,5
    8000008c:	8526                	mv	a0,s1
    8000008e:	00000097          	auipc	ra,0x0
    80000092:	270080e7          	jalr	624(ra) # 800002fe <memset>
  return (void*)r;
}
    80000096:	8526                	mv	a0,s1
    80000098:	60e2                	ld	ra,24(sp)
    8000009a:	6442                	ld	s0,16(sp)
    8000009c:	64a2                	ld	s1,8(sp)
    8000009e:	6902                	ld	s2,0(sp)
    800000a0:	6105                	add	sp,sp,32
    800000a2:	8082                	ret
  release(&kmem.lock);
    800000a4:	00009517          	auipc	a0,0x9
    800000a8:	85c50513          	add	a0,a0,-1956 # 80008900 <kmem>
    800000ac:	00006097          	auipc	ra,0x6
    800000b0:	3c6080e7          	jalr	966(ra) # 80006472 <release>
  if(r)
    800000b4:	b7cd                	j	80000096 <kalloc+0x7a>

00000000800000b6 <kgetref>:

int
kgetref(void* pa)
{
    800000b6:	1101                	add	sp,sp,-32
    800000b8:	ec06                	sd	ra,24(sp)
    800000ba:	e822                	sd	s0,16(sp)
    800000bc:	e426                	sd	s1,8(sp)
    800000be:	1000                	add	s0,sp,32
    800000c0:	84aa                	mv	s1,a0
  acquire(&kmem.reflock);
    800000c2:	00009517          	auipc	a0,0x9
    800000c6:	85e50513          	add	a0,a0,-1954 # 80008920 <kmem+0x20>
    800000ca:	00006097          	auipc	ra,0x6
    800000ce:	2f4080e7          	jalr	756(ra) # 800063be <acquire>
  int refcnt = kmem.refcount[(uint64)pa / PGSIZE];
    800000d2:	80b1                	srl	s1,s1,0xc
    800000d4:	04b1                	add	s1,s1,12
    800000d6:	048a                	sll	s1,s1,0x2
    800000d8:	00009797          	auipc	a5,0x9
    800000dc:	82878793          	add	a5,a5,-2008 # 80008900 <kmem>
    800000e0:	97a6                	add	a5,a5,s1
    800000e2:	4784                	lw	s1,8(a5)
  release(&kmem.reflock);
    800000e4:	00009517          	auipc	a0,0x9
    800000e8:	83c50513          	add	a0,a0,-1988 # 80008920 <kmem+0x20>
    800000ec:	00006097          	auipc	ra,0x6
    800000f0:	386080e7          	jalr	902(ra) # 80006472 <release>
  return refcnt;
}
    800000f4:	8526                	mv	a0,s1
    800000f6:	60e2                	ld	ra,24(sp)
    800000f8:	6442                	ld	s0,16(sp)
    800000fa:	64a2                	ld	s1,8(sp)
    800000fc:	6105                	add	sp,sp,32
    800000fe:	8082                	ret

0000000080000100 <kaddref>:

void
kaddref(void* pa)
{
    80000100:	1101                	add	sp,sp,-32
    80000102:	ec06                	sd	ra,24(sp)
    80000104:	e822                	sd	s0,16(sp)
    80000106:	e426                	sd	s1,8(sp)
    80000108:	1000                	add	s0,sp,32
    8000010a:	84aa                	mv	s1,a0
  acquire(&kmem.reflock);
    8000010c:	00009517          	auipc	a0,0x9
    80000110:	81450513          	add	a0,a0,-2028 # 80008920 <kmem+0x20>
    80000114:	00006097          	auipc	ra,0x6
    80000118:	2aa080e7          	jalr	682(ra) # 800063be <acquire>
  kmem.refcount[(uint64)pa / PGSIZE] += 1;
    8000011c:	80b1                	srl	s1,s1,0xc
    8000011e:	04b1                	add	s1,s1,12
    80000120:	048a                	sll	s1,s1,0x2
    80000122:	00008797          	auipc	a5,0x8
    80000126:	7de78793          	add	a5,a5,2014 # 80008900 <kmem>
    8000012a:	97a6                	add	a5,a5,s1
    8000012c:	4798                	lw	a4,8(a5)
    8000012e:	2705                	addw	a4,a4,1
    80000130:	c798                	sw	a4,8(a5)
  release(&kmem.reflock);
    80000132:	00008517          	auipc	a0,0x8
    80000136:	7ee50513          	add	a0,a0,2030 # 80008920 <kmem+0x20>
    8000013a:	00006097          	auipc	ra,0x6
    8000013e:	338080e7          	jalr	824(ra) # 80006472 <release>
}
    80000142:	60e2                	ld	ra,24(sp)
    80000144:	6442                	ld	s0,16(sp)
    80000146:	64a2                	ld	s1,8(sp)
    80000148:	6105                	add	sp,sp,32
    8000014a:	8082                	ret

000000008000014c <ksubref>:

int
ksubref(void* pa)
{
    8000014c:	1101                	add	sp,sp,-32
    8000014e:	ec06                	sd	ra,24(sp)
    80000150:	e822                	sd	s0,16(sp)
    80000152:	e426                	sd	s1,8(sp)
    80000154:	1000                	add	s0,sp,32
    80000156:	84aa                	mv	s1,a0
  acquire(&kmem.reflock);
    80000158:	00008517          	auipc	a0,0x8
    8000015c:	7c850513          	add	a0,a0,1992 # 80008920 <kmem+0x20>
    80000160:	00006097          	auipc	ra,0x6
    80000164:	25e080e7          	jalr	606(ra) # 800063be <acquire>
  int refcnt = --kmem.refcount[(uint64)pa / PGSIZE];
    80000168:	80b1                	srl	s1,s1,0xc
    8000016a:	04b1                	add	s1,s1,12
    8000016c:	048a                	sll	s1,s1,0x2
    8000016e:	00008797          	auipc	a5,0x8
    80000172:	79278793          	add	a5,a5,1938 # 80008900 <kmem>
    80000176:	97a6                	add	a5,a5,s1
    80000178:	4798                	lw	a4,8(a5)
    8000017a:	377d                	addw	a4,a4,-1
    8000017c:	0007049b          	sext.w	s1,a4
    80000180:	c798                	sw	a4,8(a5)
  release(&kmem.reflock);
    80000182:	00008517          	auipc	a0,0x8
    80000186:	79e50513          	add	a0,a0,1950 # 80008920 <kmem+0x20>
    8000018a:	00006097          	auipc	ra,0x6
    8000018e:	2e8080e7          	jalr	744(ra) # 80006472 <release>
  return refcnt;
}
    80000192:	8526                	mv	a0,s1
    80000194:	60e2                	ld	ra,24(sp)
    80000196:	6442                	ld	s0,16(sp)
    80000198:	64a2                	ld	s1,8(sp)
    8000019a:	6105                	add	sp,sp,32
    8000019c:	8082                	ret

000000008000019e <kfree>:
{
    8000019e:	1101                	add	sp,sp,-32
    800001a0:	ec06                	sd	ra,24(sp)
    800001a2:	e822                	sd	s0,16(sp)
    800001a4:	e426                	sd	s1,8(sp)
    800001a6:	1000                	add	s0,sp,32
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800001a8:	03451793          	sll	a5,a0,0x34
    800001ac:	e79d                	bnez	a5,800001da <kfree+0x3c>
    800001ae:	84aa                	mv	s1,a0
    800001b0:	00242797          	auipc	a5,0x242
    800001b4:	be078793          	add	a5,a5,-1056 # 80241d90 <end>
    800001b8:	02f56163          	bltu	a0,a5,800001da <kfree+0x3c>
    800001bc:	47c5                	li	a5,17
    800001be:	07ee                	sll	a5,a5,0x1b
    800001c0:	00f57d63          	bgeu	a0,a5,800001da <kfree+0x3c>
  int refcnt = ksubref((void*)pa);
    800001c4:	00000097          	auipc	ra,0x0
    800001c8:	f88080e7          	jalr	-120(ra) # 8000014c <ksubref>
  if(refcnt >0)
    800001cc:	00a05f63          	blez	a0,800001ea <kfree+0x4c>
}
    800001d0:	60e2                	ld	ra,24(sp)
    800001d2:	6442                	ld	s0,16(sp)
    800001d4:	64a2                	ld	s1,8(sp)
    800001d6:	6105                	add	sp,sp,32
    800001d8:	8082                	ret
    panic("kfree");
    800001da:	00008517          	auipc	a0,0x8
    800001de:	e3650513          	add	a0,a0,-458 # 80008010 <etext+0x10>
    800001e2:	00006097          	auipc	ra,0x6
    800001e6:	ca4080e7          	jalr	-860(ra) # 80005e86 <panic>
  memset(pa, 1, PGSIZE);
    800001ea:	6605                	lui	a2,0x1
    800001ec:	4585                	li	a1,1
    800001ee:	8526                	mv	a0,s1
    800001f0:	00000097          	auipc	ra,0x0
    800001f4:	10e080e7          	jalr	270(ra) # 800002fe <memset>
  acquire(&kmem.lock);
    800001f8:	00008517          	auipc	a0,0x8
    800001fc:	70850513          	add	a0,a0,1800 # 80008900 <kmem>
    80000200:	00006097          	auipc	ra,0x6
    80000204:	1be080e7          	jalr	446(ra) # 800063be <acquire>
  r->next = kmem.freelist;
    80000208:	00008517          	auipc	a0,0x8
    8000020c:	6f850513          	add	a0,a0,1784 # 80008900 <kmem>
    80000210:	6d1c                	ld	a5,24(a0)
    80000212:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000214:	ed04                	sd	s1,24(a0)
  release(&kmem.lock);
    80000216:	00006097          	auipc	ra,0x6
    8000021a:	25c080e7          	jalr	604(ra) # 80006472 <release>
    8000021e:	bf4d                	j	800001d0 <kfree+0x32>

0000000080000220 <freerange>:
{
    80000220:	7139                	add	sp,sp,-64
    80000222:	fc06                	sd	ra,56(sp)
    80000224:	f822                	sd	s0,48(sp)
    80000226:	f426                	sd	s1,40(sp)
    80000228:	f04a                	sd	s2,32(sp)
    8000022a:	ec4e                	sd	s3,24(sp)
    8000022c:	e852                	sd	s4,16(sp)
    8000022e:	e456                	sd	s5,8(sp)
    80000230:	e05a                	sd	s6,0(sp)
    80000232:	0080                	add	s0,sp,64
    80000234:	892e                	mv	s2,a1
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000236:	6785                	lui	a5,0x1
    80000238:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000023a:	953e                	add	a0,a0,a5
    8000023c:	77fd                	lui	a5,0xfffff
    8000023e:	00f574b3          	and	s1,a0,a5
    80000242:	86a6                	mv	a3,s1
  for(i=0; i<(uint64)PHYSTOP/PGSIZE; ++i)
    80000244:	00008797          	auipc	a5,0x8
    80000248:	6f478793          	add	a5,a5,1780 # 80008938 <kmem+0x38>
    8000024c:	00228717          	auipc	a4,0x228
    80000250:	6ec70713          	add	a4,a4,1772 # 80228938 <pid_lock>
    kmem.refcount[i] = 0;
    80000254:	0007a023          	sw	zero,0(a5)
  for(i=0; i<(uint64)PHYSTOP/PGSIZE; ++i)
    80000258:	0791                	add	a5,a5,4
    8000025a:	fee79de3          	bne	a5,a4,80000254 <freerange+0x34>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    8000025e:	6785                	lui	a5,0x1
    80000260:	97b6                	add	a5,a5,a3
    80000262:	02f96a63          	bltu	s2,a5,80000296 <freerange+0x76>
    kmem.refcount[(uint64)p/PGSIZE] = 1;
    80000266:	00008b17          	auipc	s6,0x8
    8000026a:	69ab0b13          	add	s6,s6,1690 # 80008900 <kmem>
    8000026e:	4a85                	li	s5,1
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000270:	6a05                	lui	s4,0x1
    80000272:	6989                	lui	s3,0x2
    kmem.refcount[(uint64)p/PGSIZE] = 1;
    80000274:	00c4d793          	srl	a5,s1,0xc
    80000278:	07b1                	add	a5,a5,12 # 100c <_entry-0x7fffeff4>
    8000027a:	078a                	sll	a5,a5,0x2
    8000027c:	97da                	add	a5,a5,s6
    8000027e:	0157a423          	sw	s5,8(a5)
    kfree(p);
    80000282:	8526                	mv	a0,s1
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f1a080e7          	jalr	-230(ra) # 8000019e <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    8000028c:	87a6                	mv	a5,s1
    8000028e:	94d2                	add	s1,s1,s4
    80000290:	97ce                	add	a5,a5,s3
    80000292:	fef971e3          	bgeu	s2,a5,80000274 <freerange+0x54>
}
    80000296:	70e2                	ld	ra,56(sp)
    80000298:	7442                	ld	s0,48(sp)
    8000029a:	74a2                	ld	s1,40(sp)
    8000029c:	7902                	ld	s2,32(sp)
    8000029e:	69e2                	ld	s3,24(sp)
    800002a0:	6a42                	ld	s4,16(sp)
    800002a2:	6aa2                	ld	s5,8(sp)
    800002a4:	6b02                	ld	s6,0(sp)
    800002a6:	6121                	add	sp,sp,64
    800002a8:	8082                	ret

00000000800002aa <kinit>:
{
    800002aa:	1141                	add	sp,sp,-16
    800002ac:	e406                	sd	ra,8(sp)
    800002ae:	e022                	sd	s0,0(sp)
    800002b0:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800002b2:	00008597          	auipc	a1,0x8
    800002b6:	d6658593          	add	a1,a1,-666 # 80008018 <etext+0x18>
    800002ba:	00008517          	auipc	a0,0x8
    800002be:	64650513          	add	a0,a0,1606 # 80008900 <kmem>
    800002c2:	00006097          	auipc	ra,0x6
    800002c6:	06c080e7          	jalr	108(ra) # 8000632e <initlock>
  initlock(&kmem.reflock, "kmem-ref");
    800002ca:	00008597          	auipc	a1,0x8
    800002ce:	d5658593          	add	a1,a1,-682 # 80008020 <etext+0x20>
    800002d2:	00008517          	auipc	a0,0x8
    800002d6:	64e50513          	add	a0,a0,1614 # 80008920 <kmem+0x20>
    800002da:	00006097          	auipc	ra,0x6
    800002de:	054080e7          	jalr	84(ra) # 8000632e <initlock>
  freerange(end, (void*)PHYSTOP);
    800002e2:	45c5                	li	a1,17
    800002e4:	05ee                	sll	a1,a1,0x1b
    800002e6:	00242517          	auipc	a0,0x242
    800002ea:	aaa50513          	add	a0,a0,-1366 # 80241d90 <end>
    800002ee:	00000097          	auipc	ra,0x0
    800002f2:	f32080e7          	jalr	-206(ra) # 80000220 <freerange>
}
    800002f6:	60a2                	ld	ra,8(sp)
    800002f8:	6402                	ld	s0,0(sp)
    800002fa:	0141                	add	sp,sp,16
    800002fc:	8082                	ret

00000000800002fe <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002fe:	1141                	add	sp,sp,-16
    80000300:	e422                	sd	s0,8(sp)
    80000302:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000304:	ca19                	beqz	a2,8000031a <memset+0x1c>
    80000306:	87aa                	mv	a5,a0
    80000308:	1602                	sll	a2,a2,0x20
    8000030a:	9201                	srl	a2,a2,0x20
    8000030c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000310:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000314:	0785                	add	a5,a5,1
    80000316:	fee79de3          	bne	a5,a4,80000310 <memset+0x12>
  }
  return dst;
}
    8000031a:	6422                	ld	s0,8(sp)
    8000031c:	0141                	add	sp,sp,16
    8000031e:	8082                	ret

0000000080000320 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000320:	1141                	add	sp,sp,-16
    80000322:	e422                	sd	s0,8(sp)
    80000324:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000326:	ca05                	beqz	a2,80000356 <memcmp+0x36>
    80000328:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000032c:	1682                	sll	a3,a3,0x20
    8000032e:	9281                	srl	a3,a3,0x20
    80000330:	0685                	add	a3,a3,1
    80000332:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000334:	00054783          	lbu	a5,0(a0)
    80000338:	0005c703          	lbu	a4,0(a1)
    8000033c:	00e79863          	bne	a5,a4,8000034c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000340:	0505                	add	a0,a0,1
    80000342:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000344:	fed518e3          	bne	a0,a3,80000334 <memcmp+0x14>
  }

  return 0;
    80000348:	4501                	li	a0,0
    8000034a:	a019                	j	80000350 <memcmp+0x30>
      return *s1 - *s2;
    8000034c:	40e7853b          	subw	a0,a5,a4
}
    80000350:	6422                	ld	s0,8(sp)
    80000352:	0141                	add	sp,sp,16
    80000354:	8082                	ret
  return 0;
    80000356:	4501                	li	a0,0
    80000358:	bfe5                	j	80000350 <memcmp+0x30>

000000008000035a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000035a:	1141                	add	sp,sp,-16
    8000035c:	e422                	sd	s0,8(sp)
    8000035e:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000360:	c205                	beqz	a2,80000380 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000362:	02a5e263          	bltu	a1,a0,80000386 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000366:	1602                	sll	a2,a2,0x20
    80000368:	9201                	srl	a2,a2,0x20
    8000036a:	00c587b3          	add	a5,a1,a2
{
    8000036e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000370:	0585                	add	a1,a1,1
    80000372:	0705                	add	a4,a4,1
    80000374:	fff5c683          	lbu	a3,-1(a1)
    80000378:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000037c:	fef59ae3          	bne	a1,a5,80000370 <memmove+0x16>

  return dst;
}
    80000380:	6422                	ld	s0,8(sp)
    80000382:	0141                	add	sp,sp,16
    80000384:	8082                	ret
  if(s < d && s + n > d){
    80000386:	02061693          	sll	a3,a2,0x20
    8000038a:	9281                	srl	a3,a3,0x20
    8000038c:	00d58733          	add	a4,a1,a3
    80000390:	fce57be3          	bgeu	a0,a4,80000366 <memmove+0xc>
    d += n;
    80000394:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000396:	fff6079b          	addw	a5,a2,-1
    8000039a:	1782                	sll	a5,a5,0x20
    8000039c:	9381                	srl	a5,a5,0x20
    8000039e:	fff7c793          	not	a5,a5
    800003a2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800003a4:	177d                	add	a4,a4,-1
    800003a6:	16fd                	add	a3,a3,-1
    800003a8:	00074603          	lbu	a2,0(a4)
    800003ac:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800003b0:	fee79ae3          	bne	a5,a4,800003a4 <memmove+0x4a>
    800003b4:	b7f1                	j	80000380 <memmove+0x26>

00000000800003b6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800003b6:	1141                	add	sp,sp,-16
    800003b8:	e406                	sd	ra,8(sp)
    800003ba:	e022                	sd	s0,0(sp)
    800003bc:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	f9c080e7          	jalr	-100(ra) # 8000035a <memmove>
}
    800003c6:	60a2                	ld	ra,8(sp)
    800003c8:	6402                	ld	s0,0(sp)
    800003ca:	0141                	add	sp,sp,16
    800003cc:	8082                	ret

00000000800003ce <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800003ce:	1141                	add	sp,sp,-16
    800003d0:	e422                	sd	s0,8(sp)
    800003d2:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800003d4:	ce11                	beqz	a2,800003f0 <strncmp+0x22>
    800003d6:	00054783          	lbu	a5,0(a0)
    800003da:	cf89                	beqz	a5,800003f4 <strncmp+0x26>
    800003dc:	0005c703          	lbu	a4,0(a1)
    800003e0:	00f71a63          	bne	a4,a5,800003f4 <strncmp+0x26>
    n--, p++, q++;
    800003e4:	367d                	addw	a2,a2,-1
    800003e6:	0505                	add	a0,a0,1
    800003e8:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003ea:	f675                	bnez	a2,800003d6 <strncmp+0x8>
  if(n == 0)
    return 0;
    800003ec:	4501                	li	a0,0
    800003ee:	a809                	j	80000400 <strncmp+0x32>
    800003f0:	4501                	li	a0,0
    800003f2:	a039                	j	80000400 <strncmp+0x32>
  if(n == 0)
    800003f4:	ca09                	beqz	a2,80000406 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800003f6:	00054503          	lbu	a0,0(a0)
    800003fa:	0005c783          	lbu	a5,0(a1)
    800003fe:	9d1d                	subw	a0,a0,a5
}
    80000400:	6422                	ld	s0,8(sp)
    80000402:	0141                	add	sp,sp,16
    80000404:	8082                	ret
    return 0;
    80000406:	4501                	li	a0,0
    80000408:	bfe5                	j	80000400 <strncmp+0x32>

000000008000040a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000040a:	1141                	add	sp,sp,-16
    8000040c:	e422                	sd	s0,8(sp)
    8000040e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000410:	87aa                	mv	a5,a0
    80000412:	86b2                	mv	a3,a2
    80000414:	367d                	addw	a2,a2,-1
    80000416:	00d05963          	blez	a3,80000428 <strncpy+0x1e>
    8000041a:	0785                	add	a5,a5,1
    8000041c:	0005c703          	lbu	a4,0(a1)
    80000420:	fee78fa3          	sb	a4,-1(a5)
    80000424:	0585                	add	a1,a1,1
    80000426:	f775                	bnez	a4,80000412 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000428:	873e                	mv	a4,a5
    8000042a:	9fb5                	addw	a5,a5,a3
    8000042c:	37fd                	addw	a5,a5,-1
    8000042e:	00c05963          	blez	a2,80000440 <strncpy+0x36>
    *s++ = 0;
    80000432:	0705                	add	a4,a4,1
    80000434:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000438:	40e786bb          	subw	a3,a5,a4
    8000043c:	fed04be3          	bgtz	a3,80000432 <strncpy+0x28>
  return os;
}
    80000440:	6422                	ld	s0,8(sp)
    80000442:	0141                	add	sp,sp,16
    80000444:	8082                	ret

0000000080000446 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000446:	1141                	add	sp,sp,-16
    80000448:	e422                	sd	s0,8(sp)
    8000044a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000044c:	02c05363          	blez	a2,80000472 <safestrcpy+0x2c>
    80000450:	fff6069b          	addw	a3,a2,-1
    80000454:	1682                	sll	a3,a3,0x20
    80000456:	9281                	srl	a3,a3,0x20
    80000458:	96ae                	add	a3,a3,a1
    8000045a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000045c:	00d58963          	beq	a1,a3,8000046e <safestrcpy+0x28>
    80000460:	0585                	add	a1,a1,1
    80000462:	0785                	add	a5,a5,1
    80000464:	fff5c703          	lbu	a4,-1(a1)
    80000468:	fee78fa3          	sb	a4,-1(a5)
    8000046c:	fb65                	bnez	a4,8000045c <safestrcpy+0x16>
    ;
  *s = 0;
    8000046e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000472:	6422                	ld	s0,8(sp)
    80000474:	0141                	add	sp,sp,16
    80000476:	8082                	ret

0000000080000478 <strlen>:

int
strlen(const char *s)
{
    80000478:	1141                	add	sp,sp,-16
    8000047a:	e422                	sd	s0,8(sp)
    8000047c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000047e:	00054783          	lbu	a5,0(a0)
    80000482:	cf91                	beqz	a5,8000049e <strlen+0x26>
    80000484:	0505                	add	a0,a0,1
    80000486:	87aa                	mv	a5,a0
    80000488:	86be                	mv	a3,a5
    8000048a:	0785                	add	a5,a5,1
    8000048c:	fff7c703          	lbu	a4,-1(a5)
    80000490:	ff65                	bnez	a4,80000488 <strlen+0x10>
    80000492:	40a6853b          	subw	a0,a3,a0
    80000496:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000498:	6422                	ld	s0,8(sp)
    8000049a:	0141                	add	sp,sp,16
    8000049c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000049e:	4501                	li	a0,0
    800004a0:	bfe5                	j	80000498 <strlen+0x20>

00000000800004a2 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800004a2:	1141                	add	sp,sp,-16
    800004a4:	e406                	sd	ra,8(sp)
    800004a6:	e022                	sd	s0,0(sp)
    800004a8:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    800004aa:	00001097          	auipc	ra,0x1
    800004ae:	bbe080e7          	jalr	-1090(ra) # 80001068 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800004b2:	00008717          	auipc	a4,0x8
    800004b6:	41e70713          	add	a4,a4,1054 # 800088d0 <started>
  if(cpuid() == 0){
    800004ba:	c139                	beqz	a0,80000500 <main+0x5e>
    while(started == 0)
    800004bc:	431c                	lw	a5,0(a4)
    800004be:	2781                	sext.w	a5,a5
    800004c0:	dff5                	beqz	a5,800004bc <main+0x1a>
      ;
    __sync_synchronize();
    800004c2:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800004c6:	00001097          	auipc	ra,0x1
    800004ca:	ba2080e7          	jalr	-1118(ra) # 80001068 <cpuid>
    800004ce:	85aa                	mv	a1,a0
    800004d0:	00008517          	auipc	a0,0x8
    800004d4:	b7850513          	add	a0,a0,-1160 # 80008048 <etext+0x48>
    800004d8:	00006097          	auipc	ra,0x6
    800004dc:	9f8080e7          	jalr	-1544(ra) # 80005ed0 <printf>
    kvminithart();    // turn on paging
    800004e0:	00000097          	auipc	ra,0x0
    800004e4:	0d8080e7          	jalr	216(ra) # 800005b8 <kvminithart>
    trapinithart();   // install kernel trap vector
    800004e8:	00002097          	auipc	ra,0x2
    800004ec:	84e080e7          	jalr	-1970(ra) # 80001d36 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800004f0:	00005097          	auipc	ra,0x5
    800004f4:	ea0080e7          	jalr	-352(ra) # 80005390 <plicinithart>
  }

  scheduler();        
    800004f8:	00001097          	auipc	ra,0x1
    800004fc:	096080e7          	jalr	150(ra) # 8000158e <scheduler>
    consoleinit();
    80000500:	00006097          	auipc	ra,0x6
    80000504:	896080e7          	jalr	-1898(ra) # 80005d96 <consoleinit>
    printfinit();
    80000508:	00006097          	auipc	ra,0x6
    8000050c:	ba8080e7          	jalr	-1112(ra) # 800060b0 <printfinit>
    printf("\n");
    80000510:	00008517          	auipc	a0,0x8
    80000514:	b4850513          	add	a0,a0,-1208 # 80008058 <etext+0x58>
    80000518:	00006097          	auipc	ra,0x6
    8000051c:	9b8080e7          	jalr	-1608(ra) # 80005ed0 <printf>
    printf("xv6 kernel is booting\n");
    80000520:	00008517          	auipc	a0,0x8
    80000524:	b1050513          	add	a0,a0,-1264 # 80008030 <etext+0x30>
    80000528:	00006097          	auipc	ra,0x6
    8000052c:	9a8080e7          	jalr	-1624(ra) # 80005ed0 <printf>
    printf("\n");
    80000530:	00008517          	auipc	a0,0x8
    80000534:	b2850513          	add	a0,a0,-1240 # 80008058 <etext+0x58>
    80000538:	00006097          	auipc	ra,0x6
    8000053c:	998080e7          	jalr	-1640(ra) # 80005ed0 <printf>
    kinit();         // physical page allocator
    80000540:	00000097          	auipc	ra,0x0
    80000544:	d6a080e7          	jalr	-662(ra) # 800002aa <kinit>
    kvminit();       // create kernel page table
    80000548:	00000097          	auipc	ra,0x0
    8000054c:	334080e7          	jalr	820(ra) # 8000087c <kvminit>
    kvminithart();   // turn on paging
    80000550:	00000097          	auipc	ra,0x0
    80000554:	068080e7          	jalr	104(ra) # 800005b8 <kvminithart>
    procinit();      // process table
    80000558:	00001097          	auipc	ra,0x1
    8000055c:	a5c080e7          	jalr	-1444(ra) # 80000fb4 <procinit>
    trapinit();      // trap vectors
    80000560:	00001097          	auipc	ra,0x1
    80000564:	7ae080e7          	jalr	1966(ra) # 80001d0e <trapinit>
    trapinithart();  // install kernel trap vector
    80000568:	00001097          	auipc	ra,0x1
    8000056c:	7ce080e7          	jalr	1998(ra) # 80001d36 <trapinithart>
    plicinit();      // set up interrupt controller
    80000570:	00005097          	auipc	ra,0x5
    80000574:	e0a080e7          	jalr	-502(ra) # 8000537a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000578:	00005097          	auipc	ra,0x5
    8000057c:	e18080e7          	jalr	-488(ra) # 80005390 <plicinithart>
    binit();         // buffer cache
    80000580:	00002097          	auipc	ra,0x2
    80000584:	00e080e7          	jalr	14(ra) # 8000258e <binit>
    iinit();         // inode table
    80000588:	00002097          	auipc	ra,0x2
    8000058c:	6ac080e7          	jalr	1708(ra) # 80002c34 <iinit>
    fileinit();      // file table
    80000590:	00003097          	auipc	ra,0x3
    80000594:	622080e7          	jalr	1570(ra) # 80003bb2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000598:	00005097          	auipc	ra,0x5
    8000059c:	f00080e7          	jalr	-256(ra) # 80005498 <virtio_disk_init>
    userinit();      // first user process
    800005a0:	00001097          	auipc	ra,0x1
    800005a4:	dd0080e7          	jalr	-560(ra) # 80001370 <userinit>
    __sync_synchronize();
    800005a8:	0ff0000f          	fence
    started = 1;
    800005ac:	4785                	li	a5,1
    800005ae:	00008717          	auipc	a4,0x8
    800005b2:	32f72123          	sw	a5,802(a4) # 800088d0 <started>
    800005b6:	b789                	j	800004f8 <main+0x56>

00000000800005b8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800005b8:	1141                	add	sp,sp,-16
    800005ba:	e422                	sd	s0,8(sp)
    800005bc:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800005be:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800005c2:	00008797          	auipc	a5,0x8
    800005c6:	3167b783          	ld	a5,790(a5) # 800088d8 <kernel_pagetable>
    800005ca:	83b1                	srl	a5,a5,0xc
    800005cc:	577d                	li	a4,-1
    800005ce:	177e                	sll	a4,a4,0x3f
    800005d0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800005d2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800005d6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800005da:	6422                	ld	s0,8(sp)
    800005dc:	0141                	add	sp,sp,16
    800005de:	8082                	ret

00000000800005e0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005e0:	7139                	add	sp,sp,-64
    800005e2:	fc06                	sd	ra,56(sp)
    800005e4:	f822                	sd	s0,48(sp)
    800005e6:	f426                	sd	s1,40(sp)
    800005e8:	f04a                	sd	s2,32(sp)
    800005ea:	ec4e                	sd	s3,24(sp)
    800005ec:	e852                	sd	s4,16(sp)
    800005ee:	e456                	sd	s5,8(sp)
    800005f0:	e05a                	sd	s6,0(sp)
    800005f2:	0080                	add	s0,sp,64
    800005f4:	84aa                	mv	s1,a0
    800005f6:	89ae                	mv	s3,a1
    800005f8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800005fa:	57fd                	li	a5,-1
    800005fc:	83e9                	srl	a5,a5,0x1a
    800005fe:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000600:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000602:	04b7f263          	bgeu	a5,a1,80000646 <walk+0x66>
    panic("walk");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a5a50513          	add	a0,a0,-1446 # 80008060 <etext+0x60>
    8000060e:	00006097          	auipc	ra,0x6
    80000612:	878080e7          	jalr	-1928(ra) # 80005e86 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000616:	060a8663          	beqz	s5,80000682 <walk+0xa2>
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	a02080e7          	jalr	-1534(ra) # 8000001c <kalloc>
    80000622:	84aa                	mv	s1,a0
    80000624:	c529                	beqz	a0,8000066e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000626:	6605                	lui	a2,0x1
    80000628:	4581                	li	a1,0
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	cd4080e7          	jalr	-812(ra) # 800002fe <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000632:	00c4d793          	srl	a5,s1,0xc
    80000636:	07aa                	sll	a5,a5,0xa
    80000638:	0017e793          	or	a5,a5,1
    8000063c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000640:	3a5d                	addw	s4,s4,-9 # ff7 <_entry-0x7ffff009>
    80000642:	036a0063          	beq	s4,s6,80000662 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000646:	0149d933          	srl	s2,s3,s4
    8000064a:	1ff97913          	and	s2,s2,511
    8000064e:	090e                	sll	s2,s2,0x3
    80000650:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000652:	00093483          	ld	s1,0(s2)
    80000656:	0014f793          	and	a5,s1,1
    8000065a:	dfd5                	beqz	a5,80000616 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000065c:	80a9                	srl	s1,s1,0xa
    8000065e:	04b2                	sll	s1,s1,0xc
    80000660:	b7c5                	j	80000640 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000662:	00c9d513          	srl	a0,s3,0xc
    80000666:	1ff57513          	and	a0,a0,511
    8000066a:	050e                	sll	a0,a0,0x3
    8000066c:	9526                	add	a0,a0,s1
}
    8000066e:	70e2                	ld	ra,56(sp)
    80000670:	7442                	ld	s0,48(sp)
    80000672:	74a2                	ld	s1,40(sp)
    80000674:	7902                	ld	s2,32(sp)
    80000676:	69e2                	ld	s3,24(sp)
    80000678:	6a42                	ld	s4,16(sp)
    8000067a:	6aa2                	ld	s5,8(sp)
    8000067c:	6b02                	ld	s6,0(sp)
    8000067e:	6121                	add	sp,sp,64
    80000680:	8082                	ret
        return 0;
    80000682:	4501                	li	a0,0
    80000684:	b7ed                	j	8000066e <walk+0x8e>

0000000080000686 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000686:	57fd                	li	a5,-1
    80000688:	83e9                	srl	a5,a5,0x1a
    8000068a:	00b7f463          	bgeu	a5,a1,80000692 <walkaddr+0xc>
    return 0;
    8000068e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000690:	8082                	ret
{
    80000692:	1141                	add	sp,sp,-16
    80000694:	e406                	sd	ra,8(sp)
    80000696:	e022                	sd	s0,0(sp)
    80000698:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000069a:	4601                	li	a2,0
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	f44080e7          	jalr	-188(ra) # 800005e0 <walk>
  if(pte == 0)
    800006a4:	c105                	beqz	a0,800006c4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800006a6:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800006a8:	0117f693          	and	a3,a5,17
    800006ac:	4745                	li	a4,17
    return 0;
    800006ae:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800006b0:	00e68663          	beq	a3,a4,800006bc <walkaddr+0x36>
}
    800006b4:	60a2                	ld	ra,8(sp)
    800006b6:	6402                	ld	s0,0(sp)
    800006b8:	0141                	add	sp,sp,16
    800006ba:	8082                	ret
  pa = PTE2PA(*pte);
    800006bc:	83a9                	srl	a5,a5,0xa
    800006be:	00c79513          	sll	a0,a5,0xc
  return pa;
    800006c2:	bfcd                	j	800006b4 <walkaddr+0x2e>
    return 0;
    800006c4:	4501                	li	a0,0
    800006c6:	b7fd                	j	800006b4 <walkaddr+0x2e>

00000000800006c8 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800006c8:	715d                	add	sp,sp,-80
    800006ca:	e486                	sd	ra,72(sp)
    800006cc:	e0a2                	sd	s0,64(sp)
    800006ce:	fc26                	sd	s1,56(sp)
    800006d0:	f84a                	sd	s2,48(sp)
    800006d2:	f44e                	sd	s3,40(sp)
    800006d4:	f052                	sd	s4,32(sp)
    800006d6:	ec56                	sd	s5,24(sp)
    800006d8:	e85a                	sd	s6,16(sp)
    800006da:	e45e                	sd	s7,8(sp)
    800006dc:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800006de:	03459793          	sll	a5,a1,0x34
    800006e2:	e385                	bnez	a5,80000702 <mappages+0x3a>
    800006e4:	8aaa                	mv	s5,a0
    800006e6:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800006e8:	03461793          	sll	a5,a2,0x34
    800006ec:	e39d                	bnez	a5,80000712 <mappages+0x4a>
    panic("mappages: size not aligned");

  if(size == 0)
    800006ee:	ca15                	beqz	a2,80000722 <mappages+0x5a>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800006f0:	77fd                	lui	a5,0xfffff
    800006f2:	963e                	add	a2,a2,a5
    800006f4:	00b609b3          	add	s3,a2,a1
  a = va;
    800006f8:	892e                	mv	s2,a1
    800006fa:	40b68a33          	sub	s4,a3,a1
    // if(*pte & PTE_V)
    //   panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800006fe:	6b85                	lui	s7,0x1
    80000700:	a815                	j	80000734 <mappages+0x6c>
    panic("mappages: va not aligned");
    80000702:	00008517          	auipc	a0,0x8
    80000706:	96650513          	add	a0,a0,-1690 # 80008068 <etext+0x68>
    8000070a:	00005097          	auipc	ra,0x5
    8000070e:	77c080e7          	jalr	1916(ra) # 80005e86 <panic>
    panic("mappages: size not aligned");
    80000712:	00008517          	auipc	a0,0x8
    80000716:	97650513          	add	a0,a0,-1674 # 80008088 <etext+0x88>
    8000071a:	00005097          	auipc	ra,0x5
    8000071e:	76c080e7          	jalr	1900(ra) # 80005e86 <panic>
    panic("mappages: size");
    80000722:	00008517          	auipc	a0,0x8
    80000726:	98650513          	add	a0,a0,-1658 # 800080a8 <etext+0xa8>
    8000072a:	00005097          	auipc	ra,0x5
    8000072e:	75c080e7          	jalr	1884(ra) # 80005e86 <panic>
    a += PGSIZE;
    80000732:	995e                	add	s2,s2,s7
  for(;;){
    80000734:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000738:	4605                	li	a2,1
    8000073a:	85ca                	mv	a1,s2
    8000073c:	8556                	mv	a0,s5
    8000073e:	00000097          	auipc	ra,0x0
    80000742:	ea2080e7          	jalr	-350(ra) # 800005e0 <walk>
    80000746:	cd01                	beqz	a0,8000075e <mappages+0x96>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000748:	80b1                	srl	s1,s1,0xc
    8000074a:	04aa                	sll	s1,s1,0xa
    8000074c:	0164e4b3          	or	s1,s1,s6
    80000750:	0014e493          	or	s1,s1,1
    80000754:	e104                	sd	s1,0(a0)
    if(a == last)
    80000756:	fd391ee3          	bne	s2,s3,80000732 <mappages+0x6a>
    pa += PGSIZE;
  }
  return 0;
    8000075a:	4501                	li	a0,0
    8000075c:	a011                	j	80000760 <mappages+0x98>
      return -1;
    8000075e:	557d                	li	a0,-1
}
    80000760:	60a6                	ld	ra,72(sp)
    80000762:	6406                	ld	s0,64(sp)
    80000764:	74e2                	ld	s1,56(sp)
    80000766:	7942                	ld	s2,48(sp)
    80000768:	79a2                	ld	s3,40(sp)
    8000076a:	7a02                	ld	s4,32(sp)
    8000076c:	6ae2                	ld	s5,24(sp)
    8000076e:	6b42                	ld	s6,16(sp)
    80000770:	6ba2                	ld	s7,8(sp)
    80000772:	6161                	add	sp,sp,80
    80000774:	8082                	ret

0000000080000776 <kvmmap>:
{
    80000776:	1141                	add	sp,sp,-16
    80000778:	e406                	sd	ra,8(sp)
    8000077a:	e022                	sd	s0,0(sp)
    8000077c:	0800                	add	s0,sp,16
    8000077e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000780:	86b2                	mv	a3,a2
    80000782:	863e                	mv	a2,a5
    80000784:	00000097          	auipc	ra,0x0
    80000788:	f44080e7          	jalr	-188(ra) # 800006c8 <mappages>
    8000078c:	e509                	bnez	a0,80000796 <kvmmap+0x20>
}
    8000078e:	60a2                	ld	ra,8(sp)
    80000790:	6402                	ld	s0,0(sp)
    80000792:	0141                	add	sp,sp,16
    80000794:	8082                	ret
    panic("kvmmap");
    80000796:	00008517          	auipc	a0,0x8
    8000079a:	92250513          	add	a0,a0,-1758 # 800080b8 <etext+0xb8>
    8000079e:	00005097          	auipc	ra,0x5
    800007a2:	6e8080e7          	jalr	1768(ra) # 80005e86 <panic>

00000000800007a6 <kvmmake>:
{
    800007a6:	1101                	add	sp,sp,-32
    800007a8:	ec06                	sd	ra,24(sp)
    800007aa:	e822                	sd	s0,16(sp)
    800007ac:	e426                	sd	s1,8(sp)
    800007ae:	e04a                	sd	s2,0(sp)
    800007b0:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800007b2:	00000097          	auipc	ra,0x0
    800007b6:	86a080e7          	jalr	-1942(ra) # 8000001c <kalloc>
    800007ba:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800007bc:	6605                	lui	a2,0x1
    800007be:	4581                	li	a1,0
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	b3e080e7          	jalr	-1218(ra) # 800002fe <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800007c8:	4719                	li	a4,6
    800007ca:	6685                	lui	a3,0x1
    800007cc:	10000637          	lui	a2,0x10000
    800007d0:	100005b7          	lui	a1,0x10000
    800007d4:	8526                	mv	a0,s1
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	fa0080e7          	jalr	-96(ra) # 80000776 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800007de:	4719                	li	a4,6
    800007e0:	6685                	lui	a3,0x1
    800007e2:	10001637          	lui	a2,0x10001
    800007e6:	100015b7          	lui	a1,0x10001
    800007ea:	8526                	mv	a0,s1
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	f8a080e7          	jalr	-118(ra) # 80000776 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007f4:	4719                	li	a4,6
    800007f6:	004006b7          	lui	a3,0x400
    800007fa:	0c000637          	lui	a2,0xc000
    800007fe:	0c0005b7          	lui	a1,0xc000
    80000802:	8526                	mv	a0,s1
    80000804:	00000097          	auipc	ra,0x0
    80000808:	f72080e7          	jalr	-142(ra) # 80000776 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000080c:	00007917          	auipc	s2,0x7
    80000810:	7f490913          	add	s2,s2,2036 # 80008000 <etext>
    80000814:	4729                	li	a4,10
    80000816:	80007697          	auipc	a3,0x80007
    8000081a:	7ea68693          	add	a3,a3,2026 # 8000 <_entry-0x7fff8000>
    8000081e:	4605                	li	a2,1
    80000820:	067e                	sll	a2,a2,0x1f
    80000822:	85b2                	mv	a1,a2
    80000824:	8526                	mv	a0,s1
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	f50080e7          	jalr	-176(ra) # 80000776 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000082e:	4719                	li	a4,6
    80000830:	46c5                	li	a3,17
    80000832:	06ee                	sll	a3,a3,0x1b
    80000834:	412686b3          	sub	a3,a3,s2
    80000838:	864a                	mv	a2,s2
    8000083a:	85ca                	mv	a1,s2
    8000083c:	8526                	mv	a0,s1
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	f38080e7          	jalr	-200(ra) # 80000776 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000846:	4729                	li	a4,10
    80000848:	6685                	lui	a3,0x1
    8000084a:	00006617          	auipc	a2,0x6
    8000084e:	7b660613          	add	a2,a2,1974 # 80007000 <_trampoline>
    80000852:	040005b7          	lui	a1,0x4000
    80000856:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000858:	05b2                	sll	a1,a1,0xc
    8000085a:	8526                	mv	a0,s1
    8000085c:	00000097          	auipc	ra,0x0
    80000860:	f1a080e7          	jalr	-230(ra) # 80000776 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000864:	8526                	mv	a0,s1
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	6b8080e7          	jalr	1720(ra) # 80000f1e <proc_mapstacks>
}
    8000086e:	8526                	mv	a0,s1
    80000870:	60e2                	ld	ra,24(sp)
    80000872:	6442                	ld	s0,16(sp)
    80000874:	64a2                	ld	s1,8(sp)
    80000876:	6902                	ld	s2,0(sp)
    80000878:	6105                	add	sp,sp,32
    8000087a:	8082                	ret

000000008000087c <kvminit>:
{
    8000087c:	1141                	add	sp,sp,-16
    8000087e:	e406                	sd	ra,8(sp)
    80000880:	e022                	sd	s0,0(sp)
    80000882:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80000884:	00000097          	auipc	ra,0x0
    80000888:	f22080e7          	jalr	-222(ra) # 800007a6 <kvmmake>
    8000088c:	00008797          	auipc	a5,0x8
    80000890:	04a7b623          	sd	a0,76(a5) # 800088d8 <kernel_pagetable>
}
    80000894:	60a2                	ld	ra,8(sp)
    80000896:	6402                	ld	s0,0(sp)
    80000898:	0141                	add	sp,sp,16
    8000089a:	8082                	ret

000000008000089c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000089c:	715d                	add	sp,sp,-80
    8000089e:	e486                	sd	ra,72(sp)
    800008a0:	e0a2                	sd	s0,64(sp)
    800008a2:	fc26                	sd	s1,56(sp)
    800008a4:	f84a                	sd	s2,48(sp)
    800008a6:	f44e                	sd	s3,40(sp)
    800008a8:	f052                	sd	s4,32(sp)
    800008aa:	ec56                	sd	s5,24(sp)
    800008ac:	e85a                	sd	s6,16(sp)
    800008ae:	e45e                	sd	s7,8(sp)
    800008b0:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800008b2:	03459793          	sll	a5,a1,0x34
    800008b6:	e795                	bnez	a5,800008e2 <uvmunmap+0x46>
    800008b8:	8a2a                	mv	s4,a0
    800008ba:	892e                	mv	s2,a1
    800008bc:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008be:	0632                	sll	a2,a2,0xc
    800008c0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800008c4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008c6:	6b05                	lui	s6,0x1
    800008c8:	0735e263          	bltu	a1,s3,8000092c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800008cc:	60a6                	ld	ra,72(sp)
    800008ce:	6406                	ld	s0,64(sp)
    800008d0:	74e2                	ld	s1,56(sp)
    800008d2:	7942                	ld	s2,48(sp)
    800008d4:	79a2                	ld	s3,40(sp)
    800008d6:	7a02                	ld	s4,32(sp)
    800008d8:	6ae2                	ld	s5,24(sp)
    800008da:	6b42                	ld	s6,16(sp)
    800008dc:	6ba2                	ld	s7,8(sp)
    800008de:	6161                	add	sp,sp,80
    800008e0:	8082                	ret
    panic("uvmunmap: not aligned");
    800008e2:	00007517          	auipc	a0,0x7
    800008e6:	7de50513          	add	a0,a0,2014 # 800080c0 <etext+0xc0>
    800008ea:	00005097          	auipc	ra,0x5
    800008ee:	59c080e7          	jalr	1436(ra) # 80005e86 <panic>
      panic("uvmunmap: walk");
    800008f2:	00007517          	auipc	a0,0x7
    800008f6:	7e650513          	add	a0,a0,2022 # 800080d8 <etext+0xd8>
    800008fa:	00005097          	auipc	ra,0x5
    800008fe:	58c080e7          	jalr	1420(ra) # 80005e86 <panic>
      panic("uvmunmap: not mapped");
    80000902:	00007517          	auipc	a0,0x7
    80000906:	7e650513          	add	a0,a0,2022 # 800080e8 <etext+0xe8>
    8000090a:	00005097          	auipc	ra,0x5
    8000090e:	57c080e7          	jalr	1404(ra) # 80005e86 <panic>
      panic("uvmunmap: not a leaf");
    80000912:	00007517          	auipc	a0,0x7
    80000916:	7ee50513          	add	a0,a0,2030 # 80008100 <etext+0x100>
    8000091a:	00005097          	auipc	ra,0x5
    8000091e:	56c080e7          	jalr	1388(ra) # 80005e86 <panic>
    *pte = 0;
    80000922:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000926:	995a                	add	s2,s2,s6
    80000928:	fb3972e3          	bgeu	s2,s3,800008cc <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000092c:	4601                	li	a2,0
    8000092e:	85ca                	mv	a1,s2
    80000930:	8552                	mv	a0,s4
    80000932:	00000097          	auipc	ra,0x0
    80000936:	cae080e7          	jalr	-850(ra) # 800005e0 <walk>
    8000093a:	84aa                	mv	s1,a0
    8000093c:	d95d                	beqz	a0,800008f2 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000093e:	6108                	ld	a0,0(a0)
    80000940:	00157793          	and	a5,a0,1
    80000944:	dfdd                	beqz	a5,80000902 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000946:	3ff57793          	and	a5,a0,1023
    8000094a:	fd7784e3          	beq	a5,s7,80000912 <uvmunmap+0x76>
    if(do_free){
    8000094e:	fc0a8ae3          	beqz	s5,80000922 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000952:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80000954:	0532                	sll	a0,a0,0xc
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	848080e7          	jalr	-1976(ra) # 8000019e <kfree>
    8000095e:	b7d1                	j	80000922 <uvmunmap+0x86>

0000000080000960 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000960:	1101                	add	sp,sp,-32
    80000962:	ec06                	sd	ra,24(sp)
    80000964:	e822                	sd	s0,16(sp)
    80000966:	e426                	sd	s1,8(sp)
    80000968:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000096a:	fffff097          	auipc	ra,0xfffff
    8000096e:	6b2080e7          	jalr	1714(ra) # 8000001c <kalloc>
    80000972:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000974:	c519                	beqz	a0,80000982 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000976:	6605                	lui	a2,0x1
    80000978:	4581                	li	a1,0
    8000097a:	00000097          	auipc	ra,0x0
    8000097e:	984080e7          	jalr	-1660(ra) # 800002fe <memset>
  return pagetable;
}
    80000982:	8526                	mv	a0,s1
    80000984:	60e2                	ld	ra,24(sp)
    80000986:	6442                	ld	s0,16(sp)
    80000988:	64a2                	ld	s1,8(sp)
    8000098a:	6105                	add	sp,sp,32
    8000098c:	8082                	ret

000000008000098e <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000098e:	7179                	add	sp,sp,-48
    80000990:	f406                	sd	ra,40(sp)
    80000992:	f022                	sd	s0,32(sp)
    80000994:	ec26                	sd	s1,24(sp)
    80000996:	e84a                	sd	s2,16(sp)
    80000998:	e44e                	sd	s3,8(sp)
    8000099a:	e052                	sd	s4,0(sp)
    8000099c:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000099e:	6785                	lui	a5,0x1
    800009a0:	04f67863          	bgeu	a2,a5,800009f0 <uvmfirst+0x62>
    800009a4:	8a2a                	mv	s4,a0
    800009a6:	89ae                	mv	s3,a1
    800009a8:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800009aa:	fffff097          	auipc	ra,0xfffff
    800009ae:	672080e7          	jalr	1650(ra) # 8000001c <kalloc>
    800009b2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800009b4:	6605                	lui	a2,0x1
    800009b6:	4581                	li	a1,0
    800009b8:	00000097          	auipc	ra,0x0
    800009bc:	946080e7          	jalr	-1722(ra) # 800002fe <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800009c0:	4779                	li	a4,30
    800009c2:	86ca                	mv	a3,s2
    800009c4:	6605                	lui	a2,0x1
    800009c6:	4581                	li	a1,0
    800009c8:	8552                	mv	a0,s4
    800009ca:	00000097          	auipc	ra,0x0
    800009ce:	cfe080e7          	jalr	-770(ra) # 800006c8 <mappages>
  memmove(mem, src, sz);
    800009d2:	8626                	mv	a2,s1
    800009d4:	85ce                	mv	a1,s3
    800009d6:	854a                	mv	a0,s2
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	982080e7          	jalr	-1662(ra) # 8000035a <memmove>
}
    800009e0:	70a2                	ld	ra,40(sp)
    800009e2:	7402                	ld	s0,32(sp)
    800009e4:	64e2                	ld	s1,24(sp)
    800009e6:	6942                	ld	s2,16(sp)
    800009e8:	69a2                	ld	s3,8(sp)
    800009ea:	6a02                	ld	s4,0(sp)
    800009ec:	6145                	add	sp,sp,48
    800009ee:	8082                	ret
    panic("uvmfirst: more than a page");
    800009f0:	00007517          	auipc	a0,0x7
    800009f4:	72850513          	add	a0,a0,1832 # 80008118 <etext+0x118>
    800009f8:	00005097          	auipc	ra,0x5
    800009fc:	48e080e7          	jalr	1166(ra) # 80005e86 <panic>

0000000080000a00 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000a00:	1101                	add	sp,sp,-32
    80000a02:	ec06                	sd	ra,24(sp)
    80000a04:	e822                	sd	s0,16(sp)
    80000a06:	e426                	sd	s1,8(sp)
    80000a08:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000a0a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000a0c:	00b67d63          	bgeu	a2,a1,80000a26 <uvmdealloc+0x26>
    80000a10:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000a12:	6785                	lui	a5,0x1
    80000a14:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a16:	00f60733          	add	a4,a2,a5
    80000a1a:	76fd                	lui	a3,0xfffff
    80000a1c:	8f75                	and	a4,a4,a3
    80000a1e:	97ae                	add	a5,a5,a1
    80000a20:	8ff5                	and	a5,a5,a3
    80000a22:	00f76863          	bltu	a4,a5,80000a32 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a26:	8526                	mv	a0,s1
    80000a28:	60e2                	ld	ra,24(sp)
    80000a2a:	6442                	ld	s0,16(sp)
    80000a2c:	64a2                	ld	s1,8(sp)
    80000a2e:	6105                	add	sp,sp,32
    80000a30:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a32:	8f99                	sub	a5,a5,a4
    80000a34:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a36:	4685                	li	a3,1
    80000a38:	0007861b          	sext.w	a2,a5
    80000a3c:	85ba                	mv	a1,a4
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	e5e080e7          	jalr	-418(ra) # 8000089c <uvmunmap>
    80000a46:	b7c5                	j	80000a26 <uvmdealloc+0x26>

0000000080000a48 <uvmalloc>:
  if(newsz < oldsz)
    80000a48:	0ab66563          	bltu	a2,a1,80000af2 <uvmalloc+0xaa>
{
    80000a4c:	7139                	add	sp,sp,-64
    80000a4e:	fc06                	sd	ra,56(sp)
    80000a50:	f822                	sd	s0,48(sp)
    80000a52:	f426                	sd	s1,40(sp)
    80000a54:	f04a                	sd	s2,32(sp)
    80000a56:	ec4e                	sd	s3,24(sp)
    80000a58:	e852                	sd	s4,16(sp)
    80000a5a:	e456                	sd	s5,8(sp)
    80000a5c:	e05a                	sd	s6,0(sp)
    80000a5e:	0080                	add	s0,sp,64
    80000a60:	8aaa                	mv	s5,a0
    80000a62:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a64:	6785                	lui	a5,0x1
    80000a66:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a68:	95be                	add	a1,a1,a5
    80000a6a:	77fd                	lui	a5,0xfffff
    80000a6c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a70:	08c9f363          	bgeu	s3,a2,80000af6 <uvmalloc+0xae>
    80000a74:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000a76:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80000a7a:	fffff097          	auipc	ra,0xfffff
    80000a7e:	5a2080e7          	jalr	1442(ra) # 8000001c <kalloc>
    80000a82:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a84:	c51d                	beqz	a0,80000ab2 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000a86:	6605                	lui	a2,0x1
    80000a88:	4581                	li	a1,0
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	874080e7          	jalr	-1932(ra) # 800002fe <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000a92:	875a                	mv	a4,s6
    80000a94:	86a6                	mv	a3,s1
    80000a96:	6605                	lui	a2,0x1
    80000a98:	85ca                	mv	a1,s2
    80000a9a:	8556                	mv	a0,s5
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	c2c080e7          	jalr	-980(ra) # 800006c8 <mappages>
    80000aa4:	e90d                	bnez	a0,80000ad6 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000aa6:	6785                	lui	a5,0x1
    80000aa8:	993e                	add	s2,s2,a5
    80000aaa:	fd4968e3          	bltu	s2,s4,80000a7a <uvmalloc+0x32>
  return newsz;
    80000aae:	8552                	mv	a0,s4
    80000ab0:	a809                	j	80000ac2 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000ab2:	864e                	mv	a2,s3
    80000ab4:	85ca                	mv	a1,s2
    80000ab6:	8556                	mv	a0,s5
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	f48080e7          	jalr	-184(ra) # 80000a00 <uvmdealloc>
      return 0;
    80000ac0:	4501                	li	a0,0
}
    80000ac2:	70e2                	ld	ra,56(sp)
    80000ac4:	7442                	ld	s0,48(sp)
    80000ac6:	74a2                	ld	s1,40(sp)
    80000ac8:	7902                	ld	s2,32(sp)
    80000aca:	69e2                	ld	s3,24(sp)
    80000acc:	6a42                	ld	s4,16(sp)
    80000ace:	6aa2                	ld	s5,8(sp)
    80000ad0:	6b02                	ld	s6,0(sp)
    80000ad2:	6121                	add	sp,sp,64
    80000ad4:	8082                	ret
      kfree(mem);
    80000ad6:	8526                	mv	a0,s1
    80000ad8:	fffff097          	auipc	ra,0xfffff
    80000adc:	6c6080e7          	jalr	1734(ra) # 8000019e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000ae0:	864e                	mv	a2,s3
    80000ae2:	85ca                	mv	a1,s2
    80000ae4:	8556                	mv	a0,s5
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	f1a080e7          	jalr	-230(ra) # 80000a00 <uvmdealloc>
      return 0;
    80000aee:	4501                	li	a0,0
    80000af0:	bfc9                	j	80000ac2 <uvmalloc+0x7a>
    return oldsz;
    80000af2:	852e                	mv	a0,a1
}
    80000af4:	8082                	ret
  return newsz;
    80000af6:	8532                	mv	a0,a2
    80000af8:	b7e9                	j	80000ac2 <uvmalloc+0x7a>

0000000080000afa <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000afa:	7179                	add	sp,sp,-48
    80000afc:	f406                	sd	ra,40(sp)
    80000afe:	f022                	sd	s0,32(sp)
    80000b00:	ec26                	sd	s1,24(sp)
    80000b02:	e84a                	sd	s2,16(sp)
    80000b04:	e44e                	sd	s3,8(sp)
    80000b06:	e052                	sd	s4,0(sp)
    80000b08:	1800                	add	s0,sp,48
    80000b0a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000b0c:	84aa                	mv	s1,a0
    80000b0e:	6905                	lui	s2,0x1
    80000b10:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b12:	4985                	li	s3,1
    80000b14:	a829                	j	80000b2e <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000b16:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000b18:	00c79513          	sll	a0,a5,0xc
    80000b1c:	00000097          	auipc	ra,0x0
    80000b20:	fde080e7          	jalr	-34(ra) # 80000afa <freewalk>
      pagetable[i] = 0;
    80000b24:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b28:	04a1                	add	s1,s1,8
    80000b2a:	03248163          	beq	s1,s2,80000b4c <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000b2e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b30:	00f7f713          	and	a4,a5,15
    80000b34:	ff3701e3          	beq	a4,s3,80000b16 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b38:	8b85                	and	a5,a5,1
    80000b3a:	d7fd                	beqz	a5,80000b28 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000b3c:	00007517          	auipc	a0,0x7
    80000b40:	5fc50513          	add	a0,a0,1532 # 80008138 <etext+0x138>
    80000b44:	00005097          	auipc	ra,0x5
    80000b48:	342080e7          	jalr	834(ra) # 80005e86 <panic>
    }
  }
  kfree((void*)pagetable);
    80000b4c:	8552                	mv	a0,s4
    80000b4e:	fffff097          	auipc	ra,0xfffff
    80000b52:	650080e7          	jalr	1616(ra) # 8000019e <kfree>
}
    80000b56:	70a2                	ld	ra,40(sp)
    80000b58:	7402                	ld	s0,32(sp)
    80000b5a:	64e2                	ld	s1,24(sp)
    80000b5c:	6942                	ld	s2,16(sp)
    80000b5e:	69a2                	ld	s3,8(sp)
    80000b60:	6a02                	ld	s4,0(sp)
    80000b62:	6145                	add	sp,sp,48
    80000b64:	8082                	ret

0000000080000b66 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b66:	1101                	add	sp,sp,-32
    80000b68:	ec06                	sd	ra,24(sp)
    80000b6a:	e822                	sd	s0,16(sp)
    80000b6c:	e426                	sd	s1,8(sp)
    80000b6e:	1000                	add	s0,sp,32
    80000b70:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b72:	e999                	bnez	a1,80000b88 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b74:	8526                	mv	a0,s1
    80000b76:	00000097          	auipc	ra,0x0
    80000b7a:	f84080e7          	jalr	-124(ra) # 80000afa <freewalk>
}
    80000b7e:	60e2                	ld	ra,24(sp)
    80000b80:	6442                	ld	s0,16(sp)
    80000b82:	64a2                	ld	s1,8(sp)
    80000b84:	6105                	add	sp,sp,32
    80000b86:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b88:	6785                	lui	a5,0x1
    80000b8a:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b8c:	95be                	add	a1,a1,a5
    80000b8e:	4685                	li	a3,1
    80000b90:	00c5d613          	srl	a2,a1,0xc
    80000b94:	4581                	li	a1,0
    80000b96:	00000097          	auipc	ra,0x0
    80000b9a:	d06080e7          	jalr	-762(ra) # 8000089c <uvmunmap>
    80000b9e:	bfd9                	j	80000b74 <uvmfree+0xe>

0000000080000ba0 <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000ba0:	c661                	beqz	a2,80000c68 <uvmcopy+0xc8>
{
    80000ba2:	7139                	add	sp,sp,-64
    80000ba4:	fc06                	sd	ra,56(sp)
    80000ba6:	f822                	sd	s0,48(sp)
    80000ba8:	f426                	sd	s1,40(sp)
    80000baa:	f04a                	sd	s2,32(sp)
    80000bac:	ec4e                	sd	s3,24(sp)
    80000bae:	e852                	sd	s4,16(sp)
    80000bb0:	e456                	sd	s5,8(sp)
    80000bb2:	e05a                	sd	s6,0(sp)
    80000bb4:	0080                	add	s0,sp,64
    80000bb6:	8b2a                	mv	s6,a0
    80000bb8:	8aae                	mv	s5,a1
    80000bba:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000bbc:	4981                	li	s3,0
    80000bbe:	a899                	j	80000c14 <uvmcopy+0x74>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000bc0:	00007517          	auipc	a0,0x7
    80000bc4:	58850513          	add	a0,a0,1416 # 80008148 <etext+0x148>
    80000bc8:	00005097          	auipc	ra,0x5
    80000bcc:	2be080e7          	jalr	702(ra) # 80005e86 <panic>
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    80000bd0:	00007517          	auipc	a0,0x7
    80000bd4:	59850513          	add	a0,a0,1432 # 80008168 <etext+0x168>
    80000bd8:	00005097          	auipc	ra,0x5
    80000bdc:	2ae080e7          	jalr	686(ra) # 80005e86 <panic>
    
    if(*pte & PTE_W)
      *pte = (*pte | PTE_COW) & (~PTE_W);

    pa = PTE2PA(*pte);
    80000be0:	0004b903          	ld	s2,0(s1)
    80000be4:	00a95913          	srl	s2,s2,0xa
    80000be8:	0932                	sll	s2,s2,0xc
    kaddref((void*)pa);
    80000bea:	854a                	mv	a0,s2
    80000bec:	fffff097          	auipc	ra,0xfffff
    80000bf0:	514080e7          	jalr	1300(ra) # 80000100 <kaddref>
    flags = PTE_FLAGS(*pte);
    80000bf4:	6098                	ld	a4,0(s1)
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0)
    80000bf6:	3ff77713          	and	a4,a4,1023
    80000bfa:	86ca                	mv	a3,s2
    80000bfc:	6605                	lui	a2,0x1
    80000bfe:	85ce                	mv	a1,s3
    80000c00:	8556                	mv	a0,s5
    80000c02:	00000097          	auipc	ra,0x0
    80000c06:	ac6080e7          	jalr	-1338(ra) # 800006c8 <mappages>
    80000c0a:	e91d                	bnez	a0,80000c40 <uvmcopy+0xa0>
  for(i = 0; i < sz; i += PGSIZE){
    80000c0c:	6785                	lui	a5,0x1
    80000c0e:	99be                	add	s3,s3,a5
    80000c10:	0549f263          	bgeu	s3,s4,80000c54 <uvmcopy+0xb4>
    if((pte = walk(old, i, 0)) == 0)
    80000c14:	4601                	li	a2,0
    80000c16:	85ce                	mv	a1,s3
    80000c18:	855a                	mv	a0,s6
    80000c1a:	00000097          	auipc	ra,0x0
    80000c1e:	9c6080e7          	jalr	-1594(ra) # 800005e0 <walk>
    80000c22:	84aa                	mv	s1,a0
    80000c24:	dd51                	beqz	a0,80000bc0 <uvmcopy+0x20>
    if((*pte & PTE_V) == 0)
    80000c26:	611c                	ld	a5,0(a0)
    80000c28:	0017f713          	and	a4,a5,1
    80000c2c:	d355                	beqz	a4,80000bd0 <uvmcopy+0x30>
    if(*pte & PTE_W)
    80000c2e:	0047f713          	and	a4,a5,4
    80000c32:	d75d                	beqz	a4,80000be0 <uvmcopy+0x40>
      *pte = (*pte | PTE_COW) & (~PTE_W);
    80000c34:	efb7f793          	and	a5,a5,-261
    80000c38:	1007e793          	or	a5,a5,256
    80000c3c:	e11c                	sd	a5,0(a0)
    80000c3e:	b74d                	j	80000be0 <uvmcopy+0x40>
      goto err;
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c40:	4685                	li	a3,1
    80000c42:	00c9d613          	srl	a2,s3,0xc
    80000c46:	4581                	li	a1,0
    80000c48:	8556                	mv	a0,s5
    80000c4a:	00000097          	auipc	ra,0x0
    80000c4e:	c52080e7          	jalr	-942(ra) # 8000089c <uvmunmap>
  return -1;
    80000c52:	557d                	li	a0,-1
}
    80000c54:	70e2                	ld	ra,56(sp)
    80000c56:	7442                	ld	s0,48(sp)
    80000c58:	74a2                	ld	s1,40(sp)
    80000c5a:	7902                	ld	s2,32(sp)
    80000c5c:	69e2                	ld	s3,24(sp)
    80000c5e:	6a42                	ld	s4,16(sp)
    80000c60:	6aa2                	ld	s5,8(sp)
    80000c62:	6b02                	ld	s6,0(sp)
    80000c64:	6121                	add	sp,sp,64
    80000c66:	8082                	ret
  return 0;
    80000c68:	4501                	li	a0,0
}
    80000c6a:	8082                	ret

0000000080000c6c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c6c:	1141                	add	sp,sp,-16
    80000c6e:	e406                	sd	ra,8(sp)
    80000c70:	e022                	sd	s0,0(sp)
    80000c72:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c74:	4601                	li	a2,0
    80000c76:	00000097          	auipc	ra,0x0
    80000c7a:	96a080e7          	jalr	-1686(ra) # 800005e0 <walk>
  if(pte == 0)
    80000c7e:	c901                	beqz	a0,80000c8e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c80:	611c                	ld	a5,0(a0)
    80000c82:	9bbd                	and	a5,a5,-17
    80000c84:	e11c                	sd	a5,0(a0)
}
    80000c86:	60a2                	ld	ra,8(sp)
    80000c88:	6402                	ld	s0,0(sp)
    80000c8a:	0141                	add	sp,sp,16
    80000c8c:	8082                	ret
    panic("uvmclear");
    80000c8e:	00007517          	auipc	a0,0x7
    80000c92:	4fa50513          	add	a0,a0,1274 # 80008188 <etext+0x188>
    80000c96:	00005097          	auipc	ra,0x5
    80000c9a:	1f0080e7          	jalr	496(ra) # 80005e86 <panic>

0000000080000c9e <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000c9e:	10068763          	beqz	a3,80000dac <copyout+0x10e>
{
    80000ca2:	7159                	add	sp,sp,-112
    80000ca4:	f486                	sd	ra,104(sp)
    80000ca6:	f0a2                	sd	s0,96(sp)
    80000ca8:	eca6                	sd	s1,88(sp)
    80000caa:	e8ca                	sd	s2,80(sp)
    80000cac:	e4ce                	sd	s3,72(sp)
    80000cae:	e0d2                	sd	s4,64(sp)
    80000cb0:	fc56                	sd	s5,56(sp)
    80000cb2:	f85a                	sd	s6,48(sp)
    80000cb4:	f45e                	sd	s7,40(sp)
    80000cb6:	f062                	sd	s8,32(sp)
    80000cb8:	ec66                	sd	s9,24(sp)
    80000cba:	e86a                	sd	s10,16(sp)
    80000cbc:	e46e                	sd	s11,8(sp)
    80000cbe:	1880                	add	s0,sp,112
    80000cc0:	8c2a                	mv	s8,a0
    80000cc2:	84ae                	mv	s1,a1
    80000cc4:	8b32                	mv	s6,a2
    80000cc6:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000cc8:	7cfd                	lui	s9,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    if(va0 >= MAXVA || va0 < PGSIZE)
    80000cca:	fefffdb7          	lui	s11,0xfefff
    80000cce:	0dba                	sll	s11,s11,0xe
    80000cd0:	01addd93          	srl	s11,s11,0x1a
       (*pte & PTE_W) == 0){
      return -1;
    }

    int refcnt = kgetref((void*) pa0);
    if(refcnt == 1){
    80000cd4:	4d05                	li	s10,1
    80000cd6:	a0a9                	j	80000d20 <copyout+0x82>
      *pte = (*pte & (~PTE_COW)) | PTE_W; 
    80000cd8:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    80000cdc:	efb7f793          	and	a5,a5,-261
    80000ce0:	0047e793          	or	a5,a5,4
    80000ce4:	00f93023          	sd	a5,0(s2)
      uint flags = PTE_FLAGS(*pte);
      *pte = (PA2PTE(mem) | flags | PTE_W) & (~PTE_COW);
      pa0 = (uint64)mem;
    }
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    80000ce8:	40998a33          	sub	s4,s3,s1
    80000cec:	6785                	lui	a5,0x1
    80000cee:	9a3e                	add	s4,s4,a5
    80000cf0:	014af363          	bgeu	s5,s4,80000cf6 <copyout+0x58>
    80000cf4:	8a56                	mv	s4,s5
    pa0 = PTE2PA(*pte);
    80000cf6:	00093783          	ld	a5,0(s2)
    80000cfa:	83a9                	srl	a5,a5,0xa
    80000cfc:	07b2                	sll	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000cfe:	41348533          	sub	a0,s1,s3
    80000d02:	000a061b          	sext.w	a2,s4
    80000d06:	85da                	mv	a1,s6
    80000d08:	953e                	add	a0,a0,a5
    80000d0a:	fffff097          	auipc	ra,0xfffff
    80000d0e:	650080e7          	jalr	1616(ra) # 8000035a <memmove>

    len -= n;
    80000d12:	414a8ab3          	sub	s5,s5,s4
    src += n;
    80000d16:	9b52                	add	s6,s6,s4
    dstva = va0 + PGSIZE;
    80000d18:	6485                	lui	s1,0x1
    80000d1a:	94ce                	add	s1,s1,s3
  while(len > 0){
    80000d1c:	080a8663          	beqz	s5,80000da8 <copyout+0x10a>
    va0 = PGROUNDDOWN(dstva);
    80000d20:	0194f9b3          	and	s3,s1,s9
    pa0 = walkaddr(pagetable, va0);
    80000d24:	85ce                	mv	a1,s3
    80000d26:	8562                	mv	a0,s8
    80000d28:	00000097          	auipc	ra,0x0
    80000d2c:	95e080e7          	jalr	-1698(ra) # 80000686 <walkaddr>
    80000d30:	8a2a                	mv	s4,a0
    if(pa0 == 0)
    80000d32:	cd3d                	beqz	a0,80000db0 <copyout+0x112>
    if(va0 >= MAXVA || va0 < PGSIZE)
    80000d34:	019987b3          	add	a5,s3,s9
    80000d38:	08fdec63          	bltu	s11,a5,80000dd0 <copyout+0x132>
    pte = walk(pagetable, va0, 0);
    80000d3c:	4601                	li	a2,0
    80000d3e:	85ce                	mv	a1,s3
    80000d40:	8562                	mv	a0,s8
    80000d42:	00000097          	auipc	ra,0x0
    80000d46:	89e080e7          	jalr	-1890(ra) # 800005e0 <walk>
    80000d4a:	892a                	mv	s2,a0
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000d4c:	c541                	beqz	a0,80000dd4 <copyout+0x136>
    80000d4e:	611c                	ld	a5,0(a0)
    80000d50:	8bd5                	and	a5,a5,21
    80000d52:	4755                	li	a4,21
    80000d54:	08e79263          	bne	a5,a4,80000dd8 <copyout+0x13a>
    int refcnt = kgetref((void*) pa0);
    80000d58:	8552                	mv	a0,s4
    80000d5a:	fffff097          	auipc	ra,0xfffff
    80000d5e:	35c080e7          	jalr	860(ra) # 800000b6 <kgetref>
    if(refcnt == 1){
    80000d62:	f7a50be3          	beq	a0,s10,80000cd8 <copyout+0x3a>
    } else if (refcnt > 1) {
    80000d66:	f8ad51e3          	bge	s10,a0,80000ce8 <copyout+0x4a>
      kfree((void*) pa0);
    80000d6a:	8552                	mv	a0,s4
    80000d6c:	fffff097          	auipc	ra,0xfffff
    80000d70:	432080e7          	jalr	1074(ra) # 8000019e <kfree>
      if((mem=kalloc()) == 0){
    80000d74:	fffff097          	auipc	ra,0xfffff
    80000d78:	2a8080e7          	jalr	680(ra) # 8000001c <kalloc>
    80000d7c:	8baa                	mv	s7,a0
    80000d7e:	cd39                	beqz	a0,80000ddc <copyout+0x13e>
      memmove(mem, (char*)pa0, PGSIZE);
    80000d80:	6605                	lui	a2,0x1
    80000d82:	85d2                	mv	a1,s4
    80000d84:	fffff097          	auipc	ra,0xfffff
    80000d88:	5d6080e7          	jalr	1494(ra) # 8000035a <memmove>
      *pte = (PA2PTE(mem) | flags | PTE_W) & (~PTE_COW);
    80000d8c:	00cbdb93          	srl	s7,s7,0xc
    80000d90:	0baa                	sll	s7,s7,0xa
      uint flags = PTE_FLAGS(*pte);
    80000d92:	00093783          	ld	a5,0(s2)
      *pte = (PA2PTE(mem) | flags | PTE_W) & (~PTE_COW);
    80000d96:	2fb7f793          	and	a5,a5,763
    80000d9a:	0177e7b3          	or	a5,a5,s7
    80000d9e:	0047e793          	or	a5,a5,4
    80000da2:	00f93023          	sd	a5,0(s2)
      pa0 = (uint64)mem;
    80000da6:	b789                	j	80000ce8 <copyout+0x4a>
  }
  return 0;
    80000da8:	4501                	li	a0,0
    80000daa:	a021                	j	80000db2 <copyout+0x114>
    80000dac:	4501                	li	a0,0
}
    80000dae:	8082                	ret
      return -1;
    80000db0:	557d                	li	a0,-1
}
    80000db2:	70a6                	ld	ra,104(sp)
    80000db4:	7406                	ld	s0,96(sp)
    80000db6:	64e6                	ld	s1,88(sp)
    80000db8:	6946                	ld	s2,80(sp)
    80000dba:	69a6                	ld	s3,72(sp)
    80000dbc:	6a06                	ld	s4,64(sp)
    80000dbe:	7ae2                	ld	s5,56(sp)
    80000dc0:	7b42                	ld	s6,48(sp)
    80000dc2:	7ba2                	ld	s7,40(sp)
    80000dc4:	7c02                	ld	s8,32(sp)
    80000dc6:	6ce2                	ld	s9,24(sp)
    80000dc8:	6d42                	ld	s10,16(sp)
    80000dca:	6da2                	ld	s11,8(sp)
    80000dcc:	6165                	add	sp,sp,112
    80000dce:	8082                	ret
      return -1;
    80000dd0:	557d                	li	a0,-1
    80000dd2:	b7c5                	j	80000db2 <copyout+0x114>
      return -1;
    80000dd4:	557d                	li	a0,-1
    80000dd6:	bff1                	j	80000db2 <copyout+0x114>
    80000dd8:	557d                	li	a0,-1
    80000dda:	bfe1                	j	80000db2 <copyout+0x114>
        return -1;
    80000ddc:	557d                	li	a0,-1
    80000dde:	bfd1                	j	80000db2 <copyout+0x114>

0000000080000de0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000de0:	caa5                	beqz	a3,80000e50 <copyin+0x70>
{
    80000de2:	715d                	add	sp,sp,-80
    80000de4:	e486                	sd	ra,72(sp)
    80000de6:	e0a2                	sd	s0,64(sp)
    80000de8:	fc26                	sd	s1,56(sp)
    80000dea:	f84a                	sd	s2,48(sp)
    80000dec:	f44e                	sd	s3,40(sp)
    80000dee:	f052                	sd	s4,32(sp)
    80000df0:	ec56                	sd	s5,24(sp)
    80000df2:	e85a                	sd	s6,16(sp)
    80000df4:	e45e                	sd	s7,8(sp)
    80000df6:	e062                	sd	s8,0(sp)
    80000df8:	0880                	add	s0,sp,80
    80000dfa:	8b2a                	mv	s6,a0
    80000dfc:	8a2e                	mv	s4,a1
    80000dfe:	8c32                	mv	s8,a2
    80000e00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000e02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e04:	6a85                	lui	s5,0x1
    80000e06:	a01d                	j	80000e2c <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000e08:	018505b3          	add	a1,a0,s8
    80000e0c:	0004861b          	sext.w	a2,s1
    80000e10:	412585b3          	sub	a1,a1,s2
    80000e14:	8552                	mv	a0,s4
    80000e16:	fffff097          	auipc	ra,0xfffff
    80000e1a:	544080e7          	jalr	1348(ra) # 8000035a <memmove>

    len -= n;
    80000e1e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000e22:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000e24:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000e28:	02098263          	beqz	s3,80000e4c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000e2c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000e30:	85ca                	mv	a1,s2
    80000e32:	855a                	mv	a0,s6
    80000e34:	00000097          	auipc	ra,0x0
    80000e38:	852080e7          	jalr	-1966(ra) # 80000686 <walkaddr>
    if(pa0 == 0)
    80000e3c:	cd01                	beqz	a0,80000e54 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000e3e:	418904b3          	sub	s1,s2,s8
    80000e42:	94d6                	add	s1,s1,s5
    80000e44:	fc99f2e3          	bgeu	s3,s1,80000e08 <copyin+0x28>
    80000e48:	84ce                	mv	s1,s3
    80000e4a:	bf7d                	j	80000e08 <copyin+0x28>
  }
  return 0;
    80000e4c:	4501                	li	a0,0
    80000e4e:	a021                	j	80000e56 <copyin+0x76>
    80000e50:	4501                	li	a0,0
}
    80000e52:	8082                	ret
      return -1;
    80000e54:	557d                	li	a0,-1
}
    80000e56:	60a6                	ld	ra,72(sp)
    80000e58:	6406                	ld	s0,64(sp)
    80000e5a:	74e2                	ld	s1,56(sp)
    80000e5c:	7942                	ld	s2,48(sp)
    80000e5e:	79a2                	ld	s3,40(sp)
    80000e60:	7a02                	ld	s4,32(sp)
    80000e62:	6ae2                	ld	s5,24(sp)
    80000e64:	6b42                	ld	s6,16(sp)
    80000e66:	6ba2                	ld	s7,8(sp)
    80000e68:	6c02                	ld	s8,0(sp)
    80000e6a:	6161                	add	sp,sp,80
    80000e6c:	8082                	ret

0000000080000e6e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000e6e:	c2dd                	beqz	a3,80000f14 <copyinstr+0xa6>
{
    80000e70:	715d                	add	sp,sp,-80
    80000e72:	e486                	sd	ra,72(sp)
    80000e74:	e0a2                	sd	s0,64(sp)
    80000e76:	fc26                	sd	s1,56(sp)
    80000e78:	f84a                	sd	s2,48(sp)
    80000e7a:	f44e                	sd	s3,40(sp)
    80000e7c:	f052                	sd	s4,32(sp)
    80000e7e:	ec56                	sd	s5,24(sp)
    80000e80:	e85a                	sd	s6,16(sp)
    80000e82:	e45e                	sd	s7,8(sp)
    80000e84:	0880                	add	s0,sp,80
    80000e86:	8a2a                	mv	s4,a0
    80000e88:	8b2e                	mv	s6,a1
    80000e8a:	8bb2                	mv	s7,a2
    80000e8c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000e8e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e90:	6985                	lui	s3,0x1
    80000e92:	a02d                	j	80000ebc <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000e94:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000e98:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000e9a:	37fd                	addw	a5,a5,-1
    80000e9c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ea0:	60a6                	ld	ra,72(sp)
    80000ea2:	6406                	ld	s0,64(sp)
    80000ea4:	74e2                	ld	s1,56(sp)
    80000ea6:	7942                	ld	s2,48(sp)
    80000ea8:	79a2                	ld	s3,40(sp)
    80000eaa:	7a02                	ld	s4,32(sp)
    80000eac:	6ae2                	ld	s5,24(sp)
    80000eae:	6b42                	ld	s6,16(sp)
    80000eb0:	6ba2                	ld	s7,8(sp)
    80000eb2:	6161                	add	sp,sp,80
    80000eb4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000eb6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000eba:	c8a9                	beqz	s1,80000f0c <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000ebc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000ec0:	85ca                	mv	a1,s2
    80000ec2:	8552                	mv	a0,s4
    80000ec4:	fffff097          	auipc	ra,0xfffff
    80000ec8:	7c2080e7          	jalr	1986(ra) # 80000686 <walkaddr>
    if(pa0 == 0)
    80000ecc:	c131                	beqz	a0,80000f10 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000ece:	417906b3          	sub	a3,s2,s7
    80000ed2:	96ce                	add	a3,a3,s3
    80000ed4:	00d4f363          	bgeu	s1,a3,80000eda <copyinstr+0x6c>
    80000ed8:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000eda:	955e                	add	a0,a0,s7
    80000edc:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ee0:	daf9                	beqz	a3,80000eb6 <copyinstr+0x48>
    80000ee2:	87da                	mv	a5,s6
    80000ee4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ee6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000eea:	96da                	add	a3,a3,s6
    80000eec:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000eee:	00f60733          	add	a4,a2,a5
    80000ef2:	00074703          	lbu	a4,0(a4)
    80000ef6:	df59                	beqz	a4,80000e94 <copyinstr+0x26>
        *dst = *p;
    80000ef8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000efc:	0785                	add	a5,a5,1
    while(n > 0){
    80000efe:	fed797e3          	bne	a5,a3,80000eec <copyinstr+0x7e>
    80000f02:	14fd                	add	s1,s1,-1 # fff <_entry-0x7ffff001>
    80000f04:	94c2                	add	s1,s1,a6
      --max;
    80000f06:	8c8d                	sub	s1,s1,a1
      dst++;
    80000f08:	8b3e                	mv	s6,a5
    80000f0a:	b775                	j	80000eb6 <copyinstr+0x48>
    80000f0c:	4781                	li	a5,0
    80000f0e:	b771                	j	80000e9a <copyinstr+0x2c>
      return -1;
    80000f10:	557d                	li	a0,-1
    80000f12:	b779                	j	80000ea0 <copyinstr+0x32>
  int got_null = 0;
    80000f14:	4781                	li	a5,0
  if(got_null){
    80000f16:	37fd                	addw	a5,a5,-1
    80000f18:	0007851b          	sext.w	a0,a5
}
    80000f1c:	8082                	ret

0000000080000f1e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000f1e:	7139                	add	sp,sp,-64
    80000f20:	fc06                	sd	ra,56(sp)
    80000f22:	f822                	sd	s0,48(sp)
    80000f24:	f426                	sd	s1,40(sp)
    80000f26:	f04a                	sd	s2,32(sp)
    80000f28:	ec4e                	sd	s3,24(sp)
    80000f2a:	e852                	sd	s4,16(sp)
    80000f2c:	e456                	sd	s5,8(sp)
    80000f2e:	e05a                	sd	s6,0(sp)
    80000f30:	0080                	add	s0,sp,64
    80000f32:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f34:	00228497          	auipc	s1,0x228
    80000f38:	e3448493          	add	s1,s1,-460 # 80228d68 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f3c:	8b26                	mv	s6,s1
    80000f3e:	00007a97          	auipc	s5,0x7
    80000f42:	0c2a8a93          	add	s5,s5,194 # 80008000 <etext>
    80000f46:	04000937          	lui	s2,0x4000
    80000f4a:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000f4c:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f4e:	0022ea17          	auipc	s4,0x22e
    80000f52:	81aa0a13          	add	s4,s4,-2022 # 8022e768 <tickslock>
    char *pa = kalloc();
    80000f56:	fffff097          	auipc	ra,0xfffff
    80000f5a:	0c6080e7          	jalr	198(ra) # 8000001c <kalloc>
    80000f5e:	862a                	mv	a2,a0
    if(pa == 0)
    80000f60:	c131                	beqz	a0,80000fa4 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000f62:	416485b3          	sub	a1,s1,s6
    80000f66:	858d                	sra	a1,a1,0x3
    80000f68:	000ab783          	ld	a5,0(s5)
    80000f6c:	02f585b3          	mul	a1,a1,a5
    80000f70:	2585                	addw	a1,a1,1
    80000f72:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f76:	4719                	li	a4,6
    80000f78:	6685                	lui	a3,0x1
    80000f7a:	40b905b3          	sub	a1,s2,a1
    80000f7e:	854e                	mv	a0,s3
    80000f80:	fffff097          	auipc	ra,0xfffff
    80000f84:	7f6080e7          	jalr	2038(ra) # 80000776 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f88:	16848493          	add	s1,s1,360
    80000f8c:	fd4495e3          	bne	s1,s4,80000f56 <proc_mapstacks+0x38>
  }
}
    80000f90:	70e2                	ld	ra,56(sp)
    80000f92:	7442                	ld	s0,48(sp)
    80000f94:	74a2                	ld	s1,40(sp)
    80000f96:	7902                	ld	s2,32(sp)
    80000f98:	69e2                	ld	s3,24(sp)
    80000f9a:	6a42                	ld	s4,16(sp)
    80000f9c:	6aa2                	ld	s5,8(sp)
    80000f9e:	6b02                	ld	s6,0(sp)
    80000fa0:	6121                	add	sp,sp,64
    80000fa2:	8082                	ret
      panic("kalloc");
    80000fa4:	00007517          	auipc	a0,0x7
    80000fa8:	1f450513          	add	a0,a0,500 # 80008198 <etext+0x198>
    80000fac:	00005097          	auipc	ra,0x5
    80000fb0:	eda080e7          	jalr	-294(ra) # 80005e86 <panic>

0000000080000fb4 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000fb4:	7139                	add	sp,sp,-64
    80000fb6:	fc06                	sd	ra,56(sp)
    80000fb8:	f822                	sd	s0,48(sp)
    80000fba:	f426                	sd	s1,40(sp)
    80000fbc:	f04a                	sd	s2,32(sp)
    80000fbe:	ec4e                	sd	s3,24(sp)
    80000fc0:	e852                	sd	s4,16(sp)
    80000fc2:	e456                	sd	s5,8(sp)
    80000fc4:	e05a                	sd	s6,0(sp)
    80000fc6:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000fc8:	00007597          	auipc	a1,0x7
    80000fcc:	1d858593          	add	a1,a1,472 # 800081a0 <etext+0x1a0>
    80000fd0:	00228517          	auipc	a0,0x228
    80000fd4:	96850513          	add	a0,a0,-1688 # 80228938 <pid_lock>
    80000fd8:	00005097          	auipc	ra,0x5
    80000fdc:	356080e7          	jalr	854(ra) # 8000632e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000fe0:	00007597          	auipc	a1,0x7
    80000fe4:	1c858593          	add	a1,a1,456 # 800081a8 <etext+0x1a8>
    80000fe8:	00228517          	auipc	a0,0x228
    80000fec:	96850513          	add	a0,a0,-1688 # 80228950 <wait_lock>
    80000ff0:	00005097          	auipc	ra,0x5
    80000ff4:	33e080e7          	jalr	830(ra) # 8000632e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ff8:	00228497          	auipc	s1,0x228
    80000ffc:	d7048493          	add	s1,s1,-656 # 80228d68 <proc>
      initlock(&p->lock, "proc");
    80001000:	00007b17          	auipc	s6,0x7
    80001004:	1b8b0b13          	add	s6,s6,440 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001008:	8aa6                	mv	s5,s1
    8000100a:	00007a17          	auipc	s4,0x7
    8000100e:	ff6a0a13          	add	s4,s4,-10 # 80008000 <etext>
    80001012:	04000937          	lui	s2,0x4000
    80001016:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001018:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000101a:	0022d997          	auipc	s3,0x22d
    8000101e:	74e98993          	add	s3,s3,1870 # 8022e768 <tickslock>
      initlock(&p->lock, "proc");
    80001022:	85da                	mv	a1,s6
    80001024:	8526                	mv	a0,s1
    80001026:	00005097          	auipc	ra,0x5
    8000102a:	308080e7          	jalr	776(ra) # 8000632e <initlock>
      p->state = UNUSED;
    8000102e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001032:	415487b3          	sub	a5,s1,s5
    80001036:	878d                	sra	a5,a5,0x3
    80001038:	000a3703          	ld	a4,0(s4)
    8000103c:	02e787b3          	mul	a5,a5,a4
    80001040:	2785                	addw	a5,a5,1
    80001042:	00d7979b          	sllw	a5,a5,0xd
    80001046:	40f907b3          	sub	a5,s2,a5
    8000104a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000104c:	16848493          	add	s1,s1,360
    80001050:	fd3499e3          	bne	s1,s3,80001022 <procinit+0x6e>
  }
}
    80001054:	70e2                	ld	ra,56(sp)
    80001056:	7442                	ld	s0,48(sp)
    80001058:	74a2                	ld	s1,40(sp)
    8000105a:	7902                	ld	s2,32(sp)
    8000105c:	69e2                	ld	s3,24(sp)
    8000105e:	6a42                	ld	s4,16(sp)
    80001060:	6aa2                	ld	s5,8(sp)
    80001062:	6b02                	ld	s6,0(sp)
    80001064:	6121                	add	sp,sp,64
    80001066:	8082                	ret

0000000080001068 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001068:	1141                	add	sp,sp,-16
    8000106a:	e422                	sd	s0,8(sp)
    8000106c:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000106e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001070:	2501                	sext.w	a0,a0
    80001072:	6422                	ld	s0,8(sp)
    80001074:	0141                	add	sp,sp,16
    80001076:	8082                	ret

0000000080001078 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001078:	1141                	add	sp,sp,-16
    8000107a:	e422                	sd	s0,8(sp)
    8000107c:	0800                	add	s0,sp,16
    8000107e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001080:	2781                	sext.w	a5,a5
    80001082:	079e                	sll	a5,a5,0x7
  return c;
}
    80001084:	00228517          	auipc	a0,0x228
    80001088:	8e450513          	add	a0,a0,-1820 # 80228968 <cpus>
    8000108c:	953e                	add	a0,a0,a5
    8000108e:	6422                	ld	s0,8(sp)
    80001090:	0141                	add	sp,sp,16
    80001092:	8082                	ret

0000000080001094 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001094:	1101                	add	sp,sp,-32
    80001096:	ec06                	sd	ra,24(sp)
    80001098:	e822                	sd	s0,16(sp)
    8000109a:	e426                	sd	s1,8(sp)
    8000109c:	1000                	add	s0,sp,32
  push_off();
    8000109e:	00005097          	auipc	ra,0x5
    800010a2:	2d4080e7          	jalr	724(ra) # 80006372 <push_off>
    800010a6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800010a8:	2781                	sext.w	a5,a5
    800010aa:	079e                	sll	a5,a5,0x7
    800010ac:	00228717          	auipc	a4,0x228
    800010b0:	88c70713          	add	a4,a4,-1908 # 80228938 <pid_lock>
    800010b4:	97ba                	add	a5,a5,a4
    800010b6:	7b84                	ld	s1,48(a5)
  pop_off();
    800010b8:	00005097          	auipc	ra,0x5
    800010bc:	35a080e7          	jalr	858(ra) # 80006412 <pop_off>
  return p;
}
    800010c0:	8526                	mv	a0,s1
    800010c2:	60e2                	ld	ra,24(sp)
    800010c4:	6442                	ld	s0,16(sp)
    800010c6:	64a2                	ld	s1,8(sp)
    800010c8:	6105                	add	sp,sp,32
    800010ca:	8082                	ret

00000000800010cc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800010cc:	1141                	add	sp,sp,-16
    800010ce:	e406                	sd	ra,8(sp)
    800010d0:	e022                	sd	s0,0(sp)
    800010d2:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	fc0080e7          	jalr	-64(ra) # 80001094 <myproc>
    800010dc:	00005097          	auipc	ra,0x5
    800010e0:	396080e7          	jalr	918(ra) # 80006472 <release>

  if (first) {
    800010e4:	00007797          	auipc	a5,0x7
    800010e8:	79c7a783          	lw	a5,1948(a5) # 80008880 <first.1>
    800010ec:	eb89                	bnez	a5,800010fe <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    800010ee:	00001097          	auipc	ra,0x1
    800010f2:	d20080e7          	jalr	-736(ra) # 80001e0e <usertrapret>
}
    800010f6:	60a2                	ld	ra,8(sp)
    800010f8:	6402                	ld	s0,0(sp)
    800010fa:	0141                	add	sp,sp,16
    800010fc:	8082                	ret
    fsinit(ROOTDEV);
    800010fe:	4505                	li	a0,1
    80001100:	00002097          	auipc	ra,0x2
    80001104:	ab4080e7          	jalr	-1356(ra) # 80002bb4 <fsinit>
    first = 0;
    80001108:	00007797          	auipc	a5,0x7
    8000110c:	7607ac23          	sw	zero,1912(a5) # 80008880 <first.1>
    __sync_synchronize();
    80001110:	0ff0000f          	fence
    80001114:	bfe9                	j	800010ee <forkret+0x22>

0000000080001116 <allocpid>:
{
    80001116:	1101                	add	sp,sp,-32
    80001118:	ec06                	sd	ra,24(sp)
    8000111a:	e822                	sd	s0,16(sp)
    8000111c:	e426                	sd	s1,8(sp)
    8000111e:	e04a                	sd	s2,0(sp)
    80001120:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001122:	00228917          	auipc	s2,0x228
    80001126:	81690913          	add	s2,s2,-2026 # 80228938 <pid_lock>
    8000112a:	854a                	mv	a0,s2
    8000112c:	00005097          	auipc	ra,0x5
    80001130:	292080e7          	jalr	658(ra) # 800063be <acquire>
  pid = nextpid;
    80001134:	00007797          	auipc	a5,0x7
    80001138:	75078793          	add	a5,a5,1872 # 80008884 <nextpid>
    8000113c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000113e:	0014871b          	addw	a4,s1,1
    80001142:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001144:	854a                	mv	a0,s2
    80001146:	00005097          	auipc	ra,0x5
    8000114a:	32c080e7          	jalr	812(ra) # 80006472 <release>
}
    8000114e:	8526                	mv	a0,s1
    80001150:	60e2                	ld	ra,24(sp)
    80001152:	6442                	ld	s0,16(sp)
    80001154:	64a2                	ld	s1,8(sp)
    80001156:	6902                	ld	s2,0(sp)
    80001158:	6105                	add	sp,sp,32
    8000115a:	8082                	ret

000000008000115c <proc_pagetable>:
{
    8000115c:	1101                	add	sp,sp,-32
    8000115e:	ec06                	sd	ra,24(sp)
    80001160:	e822                	sd	s0,16(sp)
    80001162:	e426                	sd	s1,8(sp)
    80001164:	e04a                	sd	s2,0(sp)
    80001166:	1000                	add	s0,sp,32
    80001168:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	7f6080e7          	jalr	2038(ra) # 80000960 <uvmcreate>
    80001172:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001174:	c121                	beqz	a0,800011b4 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001176:	4729                	li	a4,10
    80001178:	00006697          	auipc	a3,0x6
    8000117c:	e8868693          	add	a3,a3,-376 # 80007000 <_trampoline>
    80001180:	6605                	lui	a2,0x1
    80001182:	040005b7          	lui	a1,0x4000
    80001186:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001188:	05b2                	sll	a1,a1,0xc
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	53e080e7          	jalr	1342(ra) # 800006c8 <mappages>
    80001192:	02054863          	bltz	a0,800011c2 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001196:	4719                	li	a4,6
    80001198:	05893683          	ld	a3,88(s2)
    8000119c:	6605                	lui	a2,0x1
    8000119e:	020005b7          	lui	a1,0x2000
    800011a2:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011a4:	05b6                	sll	a1,a1,0xd
    800011a6:	8526                	mv	a0,s1
    800011a8:	fffff097          	auipc	ra,0xfffff
    800011ac:	520080e7          	jalr	1312(ra) # 800006c8 <mappages>
    800011b0:	02054163          	bltz	a0,800011d2 <proc_pagetable+0x76>
}
    800011b4:	8526                	mv	a0,s1
    800011b6:	60e2                	ld	ra,24(sp)
    800011b8:	6442                	ld	s0,16(sp)
    800011ba:	64a2                	ld	s1,8(sp)
    800011bc:	6902                	ld	s2,0(sp)
    800011be:	6105                	add	sp,sp,32
    800011c0:	8082                	ret
    uvmfree(pagetable, 0);
    800011c2:	4581                	li	a1,0
    800011c4:	8526                	mv	a0,s1
    800011c6:	00000097          	auipc	ra,0x0
    800011ca:	9a0080e7          	jalr	-1632(ra) # 80000b66 <uvmfree>
    return 0;
    800011ce:	4481                	li	s1,0
    800011d0:	b7d5                	j	800011b4 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011d2:	4681                	li	a3,0
    800011d4:	4605                	li	a2,1
    800011d6:	040005b7          	lui	a1,0x4000
    800011da:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011dc:	05b2                	sll	a1,a1,0xc
    800011de:	8526                	mv	a0,s1
    800011e0:	fffff097          	auipc	ra,0xfffff
    800011e4:	6bc080e7          	jalr	1724(ra) # 8000089c <uvmunmap>
    uvmfree(pagetable, 0);
    800011e8:	4581                	li	a1,0
    800011ea:	8526                	mv	a0,s1
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	97a080e7          	jalr	-1670(ra) # 80000b66 <uvmfree>
    return 0;
    800011f4:	4481                	li	s1,0
    800011f6:	bf7d                	j	800011b4 <proc_pagetable+0x58>

00000000800011f8 <proc_freepagetable>:
{
    800011f8:	1101                	add	sp,sp,-32
    800011fa:	ec06                	sd	ra,24(sp)
    800011fc:	e822                	sd	s0,16(sp)
    800011fe:	e426                	sd	s1,8(sp)
    80001200:	e04a                	sd	s2,0(sp)
    80001202:	1000                	add	s0,sp,32
    80001204:	84aa                	mv	s1,a0
    80001206:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001208:	4681                	li	a3,0
    8000120a:	4605                	li	a2,1
    8000120c:	040005b7          	lui	a1,0x4000
    80001210:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001212:	05b2                	sll	a1,a1,0xc
    80001214:	fffff097          	auipc	ra,0xfffff
    80001218:	688080e7          	jalr	1672(ra) # 8000089c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000121c:	4681                	li	a3,0
    8000121e:	4605                	li	a2,1
    80001220:	020005b7          	lui	a1,0x2000
    80001224:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001226:	05b6                	sll	a1,a1,0xd
    80001228:	8526                	mv	a0,s1
    8000122a:	fffff097          	auipc	ra,0xfffff
    8000122e:	672080e7          	jalr	1650(ra) # 8000089c <uvmunmap>
  uvmfree(pagetable, sz);
    80001232:	85ca                	mv	a1,s2
    80001234:	8526                	mv	a0,s1
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	930080e7          	jalr	-1744(ra) # 80000b66 <uvmfree>
}
    8000123e:	60e2                	ld	ra,24(sp)
    80001240:	6442                	ld	s0,16(sp)
    80001242:	64a2                	ld	s1,8(sp)
    80001244:	6902                	ld	s2,0(sp)
    80001246:	6105                	add	sp,sp,32
    80001248:	8082                	ret

000000008000124a <freeproc>:
{
    8000124a:	1101                	add	sp,sp,-32
    8000124c:	ec06                	sd	ra,24(sp)
    8000124e:	e822                	sd	s0,16(sp)
    80001250:	e426                	sd	s1,8(sp)
    80001252:	1000                	add	s0,sp,32
    80001254:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001256:	6d28                	ld	a0,88(a0)
    80001258:	c509                	beqz	a0,80001262 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000125a:	fffff097          	auipc	ra,0xfffff
    8000125e:	f44080e7          	jalr	-188(ra) # 8000019e <kfree>
  p->trapframe = 0;
    80001262:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001266:	68a8                	ld	a0,80(s1)
    80001268:	c511                	beqz	a0,80001274 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000126a:	64ac                	ld	a1,72(s1)
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	f8c080e7          	jalr	-116(ra) # 800011f8 <proc_freepagetable>
  p->pagetable = 0;
    80001274:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001278:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000127c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001280:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001284:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001288:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000128c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001290:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001294:	0004ac23          	sw	zero,24(s1)
}
    80001298:	60e2                	ld	ra,24(sp)
    8000129a:	6442                	ld	s0,16(sp)
    8000129c:	64a2                	ld	s1,8(sp)
    8000129e:	6105                	add	sp,sp,32
    800012a0:	8082                	ret

00000000800012a2 <allocproc>:
{
    800012a2:	1101                	add	sp,sp,-32
    800012a4:	ec06                	sd	ra,24(sp)
    800012a6:	e822                	sd	s0,16(sp)
    800012a8:	e426                	sd	s1,8(sp)
    800012aa:	e04a                	sd	s2,0(sp)
    800012ac:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800012ae:	00228497          	auipc	s1,0x228
    800012b2:	aba48493          	add	s1,s1,-1350 # 80228d68 <proc>
    800012b6:	0022d917          	auipc	s2,0x22d
    800012ba:	4b290913          	add	s2,s2,1202 # 8022e768 <tickslock>
    acquire(&p->lock);
    800012be:	8526                	mv	a0,s1
    800012c0:	00005097          	auipc	ra,0x5
    800012c4:	0fe080e7          	jalr	254(ra) # 800063be <acquire>
    if(p->state == UNUSED) {
    800012c8:	4c9c                	lw	a5,24(s1)
    800012ca:	cf81                	beqz	a5,800012e2 <allocproc+0x40>
      release(&p->lock);
    800012cc:	8526                	mv	a0,s1
    800012ce:	00005097          	auipc	ra,0x5
    800012d2:	1a4080e7          	jalr	420(ra) # 80006472 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012d6:	16848493          	add	s1,s1,360
    800012da:	ff2492e3          	bne	s1,s2,800012be <allocproc+0x1c>
  return 0;
    800012de:	4481                	li	s1,0
    800012e0:	a889                	j	80001332 <allocproc+0x90>
  p->pid = allocpid();
    800012e2:	00000097          	auipc	ra,0x0
    800012e6:	e34080e7          	jalr	-460(ra) # 80001116 <allocpid>
    800012ea:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012ec:	4785                	li	a5,1
    800012ee:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012f0:	fffff097          	auipc	ra,0xfffff
    800012f4:	d2c080e7          	jalr	-724(ra) # 8000001c <kalloc>
    800012f8:	892a                	mv	s2,a0
    800012fa:	eca8                	sd	a0,88(s1)
    800012fc:	c131                	beqz	a0,80001340 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800012fe:	8526                	mv	a0,s1
    80001300:	00000097          	auipc	ra,0x0
    80001304:	e5c080e7          	jalr	-420(ra) # 8000115c <proc_pagetable>
    80001308:	892a                	mv	s2,a0
    8000130a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000130c:	c531                	beqz	a0,80001358 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000130e:	07000613          	li	a2,112
    80001312:	4581                	li	a1,0
    80001314:	06048513          	add	a0,s1,96
    80001318:	fffff097          	auipc	ra,0xfffff
    8000131c:	fe6080e7          	jalr	-26(ra) # 800002fe <memset>
  p->context.ra = (uint64)forkret;
    80001320:	00000797          	auipc	a5,0x0
    80001324:	dac78793          	add	a5,a5,-596 # 800010cc <forkret>
    80001328:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000132a:	60bc                	ld	a5,64(s1)
    8000132c:	6705                	lui	a4,0x1
    8000132e:	97ba                	add	a5,a5,a4
    80001330:	f4bc                	sd	a5,104(s1)
}
    80001332:	8526                	mv	a0,s1
    80001334:	60e2                	ld	ra,24(sp)
    80001336:	6442                	ld	s0,16(sp)
    80001338:	64a2                	ld	s1,8(sp)
    8000133a:	6902                	ld	s2,0(sp)
    8000133c:	6105                	add	sp,sp,32
    8000133e:	8082                	ret
    freeproc(p);
    80001340:	8526                	mv	a0,s1
    80001342:	00000097          	auipc	ra,0x0
    80001346:	f08080e7          	jalr	-248(ra) # 8000124a <freeproc>
    release(&p->lock);
    8000134a:	8526                	mv	a0,s1
    8000134c:	00005097          	auipc	ra,0x5
    80001350:	126080e7          	jalr	294(ra) # 80006472 <release>
    return 0;
    80001354:	84ca                	mv	s1,s2
    80001356:	bff1                	j	80001332 <allocproc+0x90>
    freeproc(p);
    80001358:	8526                	mv	a0,s1
    8000135a:	00000097          	auipc	ra,0x0
    8000135e:	ef0080e7          	jalr	-272(ra) # 8000124a <freeproc>
    release(&p->lock);
    80001362:	8526                	mv	a0,s1
    80001364:	00005097          	auipc	ra,0x5
    80001368:	10e080e7          	jalr	270(ra) # 80006472 <release>
    return 0;
    8000136c:	84ca                	mv	s1,s2
    8000136e:	b7d1                	j	80001332 <allocproc+0x90>

0000000080001370 <userinit>:
{
    80001370:	1101                	add	sp,sp,-32
    80001372:	ec06                	sd	ra,24(sp)
    80001374:	e822                	sd	s0,16(sp)
    80001376:	e426                	sd	s1,8(sp)
    80001378:	1000                	add	s0,sp,32
  p = allocproc();
    8000137a:	00000097          	auipc	ra,0x0
    8000137e:	f28080e7          	jalr	-216(ra) # 800012a2 <allocproc>
    80001382:	84aa                	mv	s1,a0
  initproc = p;
    80001384:	00007797          	auipc	a5,0x7
    80001388:	54a7be23          	sd	a0,1372(a5) # 800088e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000138c:	03400613          	li	a2,52
    80001390:	00007597          	auipc	a1,0x7
    80001394:	50058593          	add	a1,a1,1280 # 80008890 <initcode>
    80001398:	6928                	ld	a0,80(a0)
    8000139a:	fffff097          	auipc	ra,0xfffff
    8000139e:	5f4080e7          	jalr	1524(ra) # 8000098e <uvmfirst>
  p->sz = PGSIZE;
    800013a2:	6785                	lui	a5,0x1
    800013a4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800013a6:	6cb8                	ld	a4,88(s1)
    800013a8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800013ac:	6cb8                	ld	a4,88(s1)
    800013ae:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800013b0:	4641                	li	a2,16
    800013b2:	00007597          	auipc	a1,0x7
    800013b6:	e0e58593          	add	a1,a1,-498 # 800081c0 <etext+0x1c0>
    800013ba:	15848513          	add	a0,s1,344
    800013be:	fffff097          	auipc	ra,0xfffff
    800013c2:	088080e7          	jalr	136(ra) # 80000446 <safestrcpy>
  p->cwd = namei("/");
    800013c6:	00007517          	auipc	a0,0x7
    800013ca:	e0a50513          	add	a0,a0,-502 # 800081d0 <etext+0x1d0>
    800013ce:	00002097          	auipc	ra,0x2
    800013d2:	204080e7          	jalr	516(ra) # 800035d2 <namei>
    800013d6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013da:	478d                	li	a5,3
    800013dc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013de:	8526                	mv	a0,s1
    800013e0:	00005097          	auipc	ra,0x5
    800013e4:	092080e7          	jalr	146(ra) # 80006472 <release>
}
    800013e8:	60e2                	ld	ra,24(sp)
    800013ea:	6442                	ld	s0,16(sp)
    800013ec:	64a2                	ld	s1,8(sp)
    800013ee:	6105                	add	sp,sp,32
    800013f0:	8082                	ret

00000000800013f2 <growproc>:
{
    800013f2:	1101                	add	sp,sp,-32
    800013f4:	ec06                	sd	ra,24(sp)
    800013f6:	e822                	sd	s0,16(sp)
    800013f8:	e426                	sd	s1,8(sp)
    800013fa:	e04a                	sd	s2,0(sp)
    800013fc:	1000                	add	s0,sp,32
    800013fe:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001400:	00000097          	auipc	ra,0x0
    80001404:	c94080e7          	jalr	-876(ra) # 80001094 <myproc>
    80001408:	84aa                	mv	s1,a0
  sz = p->sz;
    8000140a:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000140c:	01204c63          	bgtz	s2,80001424 <growproc+0x32>
  } else if(n < 0){
    80001410:	02094663          	bltz	s2,8000143c <growproc+0x4a>
  p->sz = sz;
    80001414:	e4ac                	sd	a1,72(s1)
  return 0;
    80001416:	4501                	li	a0,0
}
    80001418:	60e2                	ld	ra,24(sp)
    8000141a:	6442                	ld	s0,16(sp)
    8000141c:	64a2                	ld	s1,8(sp)
    8000141e:	6902                	ld	s2,0(sp)
    80001420:	6105                	add	sp,sp,32
    80001422:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001424:	4691                	li	a3,4
    80001426:	00b90633          	add	a2,s2,a1
    8000142a:	6928                	ld	a0,80(a0)
    8000142c:	fffff097          	auipc	ra,0xfffff
    80001430:	61c080e7          	jalr	1564(ra) # 80000a48 <uvmalloc>
    80001434:	85aa                	mv	a1,a0
    80001436:	fd79                	bnez	a0,80001414 <growproc+0x22>
      return -1;
    80001438:	557d                	li	a0,-1
    8000143a:	bff9                	j	80001418 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000143c:	00b90633          	add	a2,s2,a1
    80001440:	6928                	ld	a0,80(a0)
    80001442:	fffff097          	auipc	ra,0xfffff
    80001446:	5be080e7          	jalr	1470(ra) # 80000a00 <uvmdealloc>
    8000144a:	85aa                	mv	a1,a0
    8000144c:	b7e1                	j	80001414 <growproc+0x22>

000000008000144e <fork>:
{
    8000144e:	7139                	add	sp,sp,-64
    80001450:	fc06                	sd	ra,56(sp)
    80001452:	f822                	sd	s0,48(sp)
    80001454:	f426                	sd	s1,40(sp)
    80001456:	f04a                	sd	s2,32(sp)
    80001458:	ec4e                	sd	s3,24(sp)
    8000145a:	e852                	sd	s4,16(sp)
    8000145c:	e456                	sd	s5,8(sp)
    8000145e:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001460:	00000097          	auipc	ra,0x0
    80001464:	c34080e7          	jalr	-972(ra) # 80001094 <myproc>
    80001468:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000146a:	00000097          	auipc	ra,0x0
    8000146e:	e38080e7          	jalr	-456(ra) # 800012a2 <allocproc>
    80001472:	10050c63          	beqz	a0,8000158a <fork+0x13c>
    80001476:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001478:	048ab603          	ld	a2,72(s5)
    8000147c:	692c                	ld	a1,80(a0)
    8000147e:	050ab503          	ld	a0,80(s5)
    80001482:	fffff097          	auipc	ra,0xfffff
    80001486:	71e080e7          	jalr	1822(ra) # 80000ba0 <uvmcopy>
    8000148a:	04054863          	bltz	a0,800014da <fork+0x8c>
  np->sz = p->sz;
    8000148e:	048ab783          	ld	a5,72(s5)
    80001492:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001496:	058ab683          	ld	a3,88(s5)
    8000149a:	87b6                	mv	a5,a3
    8000149c:	058a3703          	ld	a4,88(s4)
    800014a0:	12068693          	add	a3,a3,288
    800014a4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800014a8:	6788                	ld	a0,8(a5)
    800014aa:	6b8c                	ld	a1,16(a5)
    800014ac:	6f90                	ld	a2,24(a5)
    800014ae:	01073023          	sd	a6,0(a4)
    800014b2:	e708                	sd	a0,8(a4)
    800014b4:	eb0c                	sd	a1,16(a4)
    800014b6:	ef10                	sd	a2,24(a4)
    800014b8:	02078793          	add	a5,a5,32
    800014bc:	02070713          	add	a4,a4,32
    800014c0:	fed792e3          	bne	a5,a3,800014a4 <fork+0x56>
  np->trapframe->a0 = 0;
    800014c4:	058a3783          	ld	a5,88(s4)
    800014c8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800014cc:	0d0a8493          	add	s1,s5,208
    800014d0:	0d0a0913          	add	s2,s4,208
    800014d4:	150a8993          	add	s3,s5,336
    800014d8:	a00d                	j	800014fa <fork+0xac>
    freeproc(np);
    800014da:	8552                	mv	a0,s4
    800014dc:	00000097          	auipc	ra,0x0
    800014e0:	d6e080e7          	jalr	-658(ra) # 8000124a <freeproc>
    release(&np->lock);
    800014e4:	8552                	mv	a0,s4
    800014e6:	00005097          	auipc	ra,0x5
    800014ea:	f8c080e7          	jalr	-116(ra) # 80006472 <release>
    return -1;
    800014ee:	597d                	li	s2,-1
    800014f0:	a059                	j	80001576 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800014f2:	04a1                	add	s1,s1,8
    800014f4:	0921                	add	s2,s2,8
    800014f6:	01348b63          	beq	s1,s3,8000150c <fork+0xbe>
    if(p->ofile[i])
    800014fa:	6088                	ld	a0,0(s1)
    800014fc:	d97d                	beqz	a0,800014f2 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800014fe:	00002097          	auipc	ra,0x2
    80001502:	746080e7          	jalr	1862(ra) # 80003c44 <filedup>
    80001506:	00a93023          	sd	a0,0(s2)
    8000150a:	b7e5                	j	800014f2 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000150c:	150ab503          	ld	a0,336(s5)
    80001510:	00002097          	auipc	ra,0x2
    80001514:	8de080e7          	jalr	-1826(ra) # 80002dee <idup>
    80001518:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000151c:	4641                	li	a2,16
    8000151e:	158a8593          	add	a1,s5,344
    80001522:	158a0513          	add	a0,s4,344
    80001526:	fffff097          	auipc	ra,0xfffff
    8000152a:	f20080e7          	jalr	-224(ra) # 80000446 <safestrcpy>
  pid = np->pid;
    8000152e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001532:	8552                	mv	a0,s4
    80001534:	00005097          	auipc	ra,0x5
    80001538:	f3e080e7          	jalr	-194(ra) # 80006472 <release>
  acquire(&wait_lock);
    8000153c:	00227497          	auipc	s1,0x227
    80001540:	41448493          	add	s1,s1,1044 # 80228950 <wait_lock>
    80001544:	8526                	mv	a0,s1
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	e78080e7          	jalr	-392(ra) # 800063be <acquire>
  np->parent = p;
    8000154e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001552:	8526                	mv	a0,s1
    80001554:	00005097          	auipc	ra,0x5
    80001558:	f1e080e7          	jalr	-226(ra) # 80006472 <release>
  acquire(&np->lock);
    8000155c:	8552                	mv	a0,s4
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	e60080e7          	jalr	-416(ra) # 800063be <acquire>
  np->state = RUNNABLE;
    80001566:	478d                	li	a5,3
    80001568:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000156c:	8552                	mv	a0,s4
    8000156e:	00005097          	auipc	ra,0x5
    80001572:	f04080e7          	jalr	-252(ra) # 80006472 <release>
}
    80001576:	854a                	mv	a0,s2
    80001578:	70e2                	ld	ra,56(sp)
    8000157a:	7442                	ld	s0,48(sp)
    8000157c:	74a2                	ld	s1,40(sp)
    8000157e:	7902                	ld	s2,32(sp)
    80001580:	69e2                	ld	s3,24(sp)
    80001582:	6a42                	ld	s4,16(sp)
    80001584:	6aa2                	ld	s5,8(sp)
    80001586:	6121                	add	sp,sp,64
    80001588:	8082                	ret
    return -1;
    8000158a:	597d                	li	s2,-1
    8000158c:	b7ed                	j	80001576 <fork+0x128>

000000008000158e <scheduler>:
{
    8000158e:	7139                	add	sp,sp,-64
    80001590:	fc06                	sd	ra,56(sp)
    80001592:	f822                	sd	s0,48(sp)
    80001594:	f426                	sd	s1,40(sp)
    80001596:	f04a                	sd	s2,32(sp)
    80001598:	ec4e                	sd	s3,24(sp)
    8000159a:	e852                	sd	s4,16(sp)
    8000159c:	e456                	sd	s5,8(sp)
    8000159e:	e05a                	sd	s6,0(sp)
    800015a0:	0080                	add	s0,sp,64
    800015a2:	8792                	mv	a5,tp
  int id = r_tp();
    800015a4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015a6:	00779a93          	sll	s5,a5,0x7
    800015aa:	00227717          	auipc	a4,0x227
    800015ae:	38e70713          	add	a4,a4,910 # 80228938 <pid_lock>
    800015b2:	9756                	add	a4,a4,s5
    800015b4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015b8:	00227717          	auipc	a4,0x227
    800015bc:	3b870713          	add	a4,a4,952 # 80228970 <cpus+0x8>
    800015c0:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800015c2:	498d                	li	s3,3
        p->state = RUNNING;
    800015c4:	4b11                	li	s6,4
        c->proc = p;
    800015c6:	079e                	sll	a5,a5,0x7
    800015c8:	00227a17          	auipc	s4,0x227
    800015cc:	370a0a13          	add	s4,s4,880 # 80228938 <pid_lock>
    800015d0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015d2:	0022d917          	auipc	s2,0x22d
    800015d6:	19690913          	add	s2,s2,406 # 8022e768 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015de:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015e2:	10079073          	csrw	sstatus,a5
    800015e6:	00227497          	auipc	s1,0x227
    800015ea:	78248493          	add	s1,s1,1922 # 80228d68 <proc>
    800015ee:	a811                	j	80001602 <scheduler+0x74>
      release(&p->lock);
    800015f0:	8526                	mv	a0,s1
    800015f2:	00005097          	auipc	ra,0x5
    800015f6:	e80080e7          	jalr	-384(ra) # 80006472 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015fa:	16848493          	add	s1,s1,360
    800015fe:	fd248ee3          	beq	s1,s2,800015da <scheduler+0x4c>
      acquire(&p->lock);
    80001602:	8526                	mv	a0,s1
    80001604:	00005097          	auipc	ra,0x5
    80001608:	dba080e7          	jalr	-582(ra) # 800063be <acquire>
      if(p->state == RUNNABLE) {
    8000160c:	4c9c                	lw	a5,24(s1)
    8000160e:	ff3791e3          	bne	a5,s3,800015f0 <scheduler+0x62>
        p->state = RUNNING;
    80001612:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001616:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000161a:	06048593          	add	a1,s1,96
    8000161e:	8556                	mv	a0,s5
    80001620:	00000097          	auipc	ra,0x0
    80001624:	684080e7          	jalr	1668(ra) # 80001ca4 <swtch>
        c->proc = 0;
    80001628:	020a3823          	sd	zero,48(s4)
    8000162c:	b7d1                	j	800015f0 <scheduler+0x62>

000000008000162e <sched>:
{
    8000162e:	7179                	add	sp,sp,-48
    80001630:	f406                	sd	ra,40(sp)
    80001632:	f022                	sd	s0,32(sp)
    80001634:	ec26                	sd	s1,24(sp)
    80001636:	e84a                	sd	s2,16(sp)
    80001638:	e44e                	sd	s3,8(sp)
    8000163a:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    8000163c:	00000097          	auipc	ra,0x0
    80001640:	a58080e7          	jalr	-1448(ra) # 80001094 <myproc>
    80001644:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001646:	00005097          	auipc	ra,0x5
    8000164a:	cfe080e7          	jalr	-770(ra) # 80006344 <holding>
    8000164e:	c93d                	beqz	a0,800016c4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001650:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001652:	2781                	sext.w	a5,a5
    80001654:	079e                	sll	a5,a5,0x7
    80001656:	00227717          	auipc	a4,0x227
    8000165a:	2e270713          	add	a4,a4,738 # 80228938 <pid_lock>
    8000165e:	97ba                	add	a5,a5,a4
    80001660:	0a87a703          	lw	a4,168(a5)
    80001664:	4785                	li	a5,1
    80001666:	06f71763          	bne	a4,a5,800016d4 <sched+0xa6>
  if(p->state == RUNNING)
    8000166a:	4c98                	lw	a4,24(s1)
    8000166c:	4791                	li	a5,4
    8000166e:	06f70b63          	beq	a4,a5,800016e4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001672:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001676:	8b89                	and	a5,a5,2
  if(intr_get())
    80001678:	efb5                	bnez	a5,800016f4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000167a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000167c:	00227917          	auipc	s2,0x227
    80001680:	2bc90913          	add	s2,s2,700 # 80228938 <pid_lock>
    80001684:	2781                	sext.w	a5,a5
    80001686:	079e                	sll	a5,a5,0x7
    80001688:	97ca                	add	a5,a5,s2
    8000168a:	0ac7a983          	lw	s3,172(a5)
    8000168e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001690:	2781                	sext.w	a5,a5
    80001692:	079e                	sll	a5,a5,0x7
    80001694:	00227597          	auipc	a1,0x227
    80001698:	2dc58593          	add	a1,a1,732 # 80228970 <cpus+0x8>
    8000169c:	95be                	add	a1,a1,a5
    8000169e:	06048513          	add	a0,s1,96
    800016a2:	00000097          	auipc	ra,0x0
    800016a6:	602080e7          	jalr	1538(ra) # 80001ca4 <swtch>
    800016aa:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016ac:	2781                	sext.w	a5,a5
    800016ae:	079e                	sll	a5,a5,0x7
    800016b0:	993e                	add	s2,s2,a5
    800016b2:	0b392623          	sw	s3,172(s2)
}
    800016b6:	70a2                	ld	ra,40(sp)
    800016b8:	7402                	ld	s0,32(sp)
    800016ba:	64e2                	ld	s1,24(sp)
    800016bc:	6942                	ld	s2,16(sp)
    800016be:	69a2                	ld	s3,8(sp)
    800016c0:	6145                	add	sp,sp,48
    800016c2:	8082                	ret
    panic("sched p->lock");
    800016c4:	00007517          	auipc	a0,0x7
    800016c8:	b1450513          	add	a0,a0,-1260 # 800081d8 <etext+0x1d8>
    800016cc:	00004097          	auipc	ra,0x4
    800016d0:	7ba080e7          	jalr	1978(ra) # 80005e86 <panic>
    panic("sched locks");
    800016d4:	00007517          	auipc	a0,0x7
    800016d8:	b1450513          	add	a0,a0,-1260 # 800081e8 <etext+0x1e8>
    800016dc:	00004097          	auipc	ra,0x4
    800016e0:	7aa080e7          	jalr	1962(ra) # 80005e86 <panic>
    panic("sched running");
    800016e4:	00007517          	auipc	a0,0x7
    800016e8:	b1450513          	add	a0,a0,-1260 # 800081f8 <etext+0x1f8>
    800016ec:	00004097          	auipc	ra,0x4
    800016f0:	79a080e7          	jalr	1946(ra) # 80005e86 <panic>
    panic("sched interruptible");
    800016f4:	00007517          	auipc	a0,0x7
    800016f8:	b1450513          	add	a0,a0,-1260 # 80008208 <etext+0x208>
    800016fc:	00004097          	auipc	ra,0x4
    80001700:	78a080e7          	jalr	1930(ra) # 80005e86 <panic>

0000000080001704 <yield>:
{
    80001704:	1101                	add	sp,sp,-32
    80001706:	ec06                	sd	ra,24(sp)
    80001708:	e822                	sd	s0,16(sp)
    8000170a:	e426                	sd	s1,8(sp)
    8000170c:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    8000170e:	00000097          	auipc	ra,0x0
    80001712:	986080e7          	jalr	-1658(ra) # 80001094 <myproc>
    80001716:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001718:	00005097          	auipc	ra,0x5
    8000171c:	ca6080e7          	jalr	-858(ra) # 800063be <acquire>
  p->state = RUNNABLE;
    80001720:	478d                	li	a5,3
    80001722:	cc9c                	sw	a5,24(s1)
  sched();
    80001724:	00000097          	auipc	ra,0x0
    80001728:	f0a080e7          	jalr	-246(ra) # 8000162e <sched>
  release(&p->lock);
    8000172c:	8526                	mv	a0,s1
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	d44080e7          	jalr	-700(ra) # 80006472 <release>
}
    80001736:	60e2                	ld	ra,24(sp)
    80001738:	6442                	ld	s0,16(sp)
    8000173a:	64a2                	ld	s1,8(sp)
    8000173c:	6105                	add	sp,sp,32
    8000173e:	8082                	ret

0000000080001740 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001740:	7179                	add	sp,sp,-48
    80001742:	f406                	sd	ra,40(sp)
    80001744:	f022                	sd	s0,32(sp)
    80001746:	ec26                	sd	s1,24(sp)
    80001748:	e84a                	sd	s2,16(sp)
    8000174a:	e44e                	sd	s3,8(sp)
    8000174c:	1800                	add	s0,sp,48
    8000174e:	89aa                	mv	s3,a0
    80001750:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001752:	00000097          	auipc	ra,0x0
    80001756:	942080e7          	jalr	-1726(ra) # 80001094 <myproc>
    8000175a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000175c:	00005097          	auipc	ra,0x5
    80001760:	c62080e7          	jalr	-926(ra) # 800063be <acquire>
  release(lk);
    80001764:	854a                	mv	a0,s2
    80001766:	00005097          	auipc	ra,0x5
    8000176a:	d0c080e7          	jalr	-756(ra) # 80006472 <release>

  // Go to sleep.
  p->chan = chan;
    8000176e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001772:	4789                	li	a5,2
    80001774:	cc9c                	sw	a5,24(s1)

  sched();
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	eb8080e7          	jalr	-328(ra) # 8000162e <sched>

  // Tidy up.
  p->chan = 0;
    8000177e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001782:	8526                	mv	a0,s1
    80001784:	00005097          	auipc	ra,0x5
    80001788:	cee080e7          	jalr	-786(ra) # 80006472 <release>
  acquire(lk);
    8000178c:	854a                	mv	a0,s2
    8000178e:	00005097          	auipc	ra,0x5
    80001792:	c30080e7          	jalr	-976(ra) # 800063be <acquire>
}
    80001796:	70a2                	ld	ra,40(sp)
    80001798:	7402                	ld	s0,32(sp)
    8000179a:	64e2                	ld	s1,24(sp)
    8000179c:	6942                	ld	s2,16(sp)
    8000179e:	69a2                	ld	s3,8(sp)
    800017a0:	6145                	add	sp,sp,48
    800017a2:	8082                	ret

00000000800017a4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017a4:	7139                	add	sp,sp,-64
    800017a6:	fc06                	sd	ra,56(sp)
    800017a8:	f822                	sd	s0,48(sp)
    800017aa:	f426                	sd	s1,40(sp)
    800017ac:	f04a                	sd	s2,32(sp)
    800017ae:	ec4e                	sd	s3,24(sp)
    800017b0:	e852                	sd	s4,16(sp)
    800017b2:	e456                	sd	s5,8(sp)
    800017b4:	0080                	add	s0,sp,64
    800017b6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017b8:	00227497          	auipc	s1,0x227
    800017bc:	5b048493          	add	s1,s1,1456 # 80228d68 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017c0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017c2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017c4:	0022d917          	auipc	s2,0x22d
    800017c8:	fa490913          	add	s2,s2,-92 # 8022e768 <tickslock>
    800017cc:	a811                	j	800017e0 <wakeup+0x3c>
      }
      release(&p->lock);
    800017ce:	8526                	mv	a0,s1
    800017d0:	00005097          	auipc	ra,0x5
    800017d4:	ca2080e7          	jalr	-862(ra) # 80006472 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d8:	16848493          	add	s1,s1,360
    800017dc:	03248663          	beq	s1,s2,80001808 <wakeup+0x64>
    if(p != myproc()){
    800017e0:	00000097          	auipc	ra,0x0
    800017e4:	8b4080e7          	jalr	-1868(ra) # 80001094 <myproc>
    800017e8:	fea488e3          	beq	s1,a0,800017d8 <wakeup+0x34>
      acquire(&p->lock);
    800017ec:	8526                	mv	a0,s1
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	bd0080e7          	jalr	-1072(ra) # 800063be <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017f6:	4c9c                	lw	a5,24(s1)
    800017f8:	fd379be3          	bne	a5,s3,800017ce <wakeup+0x2a>
    800017fc:	709c                	ld	a5,32(s1)
    800017fe:	fd4798e3          	bne	a5,s4,800017ce <wakeup+0x2a>
        p->state = RUNNABLE;
    80001802:	0154ac23          	sw	s5,24(s1)
    80001806:	b7e1                	j	800017ce <wakeup+0x2a>
    }
  }
}
    80001808:	70e2                	ld	ra,56(sp)
    8000180a:	7442                	ld	s0,48(sp)
    8000180c:	74a2                	ld	s1,40(sp)
    8000180e:	7902                	ld	s2,32(sp)
    80001810:	69e2                	ld	s3,24(sp)
    80001812:	6a42                	ld	s4,16(sp)
    80001814:	6aa2                	ld	s5,8(sp)
    80001816:	6121                	add	sp,sp,64
    80001818:	8082                	ret

000000008000181a <reparent>:
{
    8000181a:	7179                	add	sp,sp,-48
    8000181c:	f406                	sd	ra,40(sp)
    8000181e:	f022                	sd	s0,32(sp)
    80001820:	ec26                	sd	s1,24(sp)
    80001822:	e84a                	sd	s2,16(sp)
    80001824:	e44e                	sd	s3,8(sp)
    80001826:	e052                	sd	s4,0(sp)
    80001828:	1800                	add	s0,sp,48
    8000182a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000182c:	00227497          	auipc	s1,0x227
    80001830:	53c48493          	add	s1,s1,1340 # 80228d68 <proc>
      pp->parent = initproc;
    80001834:	00007a17          	auipc	s4,0x7
    80001838:	0aca0a13          	add	s4,s4,172 # 800088e0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000183c:	0022d997          	auipc	s3,0x22d
    80001840:	f2c98993          	add	s3,s3,-212 # 8022e768 <tickslock>
    80001844:	a029                	j	8000184e <reparent+0x34>
    80001846:	16848493          	add	s1,s1,360
    8000184a:	01348d63          	beq	s1,s3,80001864 <reparent+0x4a>
    if(pp->parent == p){
    8000184e:	7c9c                	ld	a5,56(s1)
    80001850:	ff279be3          	bne	a5,s2,80001846 <reparent+0x2c>
      pp->parent = initproc;
    80001854:	000a3503          	ld	a0,0(s4)
    80001858:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000185a:	00000097          	auipc	ra,0x0
    8000185e:	f4a080e7          	jalr	-182(ra) # 800017a4 <wakeup>
    80001862:	b7d5                	j	80001846 <reparent+0x2c>
}
    80001864:	70a2                	ld	ra,40(sp)
    80001866:	7402                	ld	s0,32(sp)
    80001868:	64e2                	ld	s1,24(sp)
    8000186a:	6942                	ld	s2,16(sp)
    8000186c:	69a2                	ld	s3,8(sp)
    8000186e:	6a02                	ld	s4,0(sp)
    80001870:	6145                	add	sp,sp,48
    80001872:	8082                	ret

0000000080001874 <exit>:
{
    80001874:	7179                	add	sp,sp,-48
    80001876:	f406                	sd	ra,40(sp)
    80001878:	f022                	sd	s0,32(sp)
    8000187a:	ec26                	sd	s1,24(sp)
    8000187c:	e84a                	sd	s2,16(sp)
    8000187e:	e44e                	sd	s3,8(sp)
    80001880:	e052                	sd	s4,0(sp)
    80001882:	1800                	add	s0,sp,48
    80001884:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001886:	00000097          	auipc	ra,0x0
    8000188a:	80e080e7          	jalr	-2034(ra) # 80001094 <myproc>
    8000188e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001890:	00007797          	auipc	a5,0x7
    80001894:	0507b783          	ld	a5,80(a5) # 800088e0 <initproc>
    80001898:	0d050493          	add	s1,a0,208
    8000189c:	15050913          	add	s2,a0,336
    800018a0:	02a79363          	bne	a5,a0,800018c6 <exit+0x52>
    panic("init exiting");
    800018a4:	00007517          	auipc	a0,0x7
    800018a8:	97c50513          	add	a0,a0,-1668 # 80008220 <etext+0x220>
    800018ac:	00004097          	auipc	ra,0x4
    800018b0:	5da080e7          	jalr	1498(ra) # 80005e86 <panic>
      fileclose(f);
    800018b4:	00002097          	auipc	ra,0x2
    800018b8:	3e2080e7          	jalr	994(ra) # 80003c96 <fileclose>
      p->ofile[fd] = 0;
    800018bc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018c0:	04a1                	add	s1,s1,8
    800018c2:	01248563          	beq	s1,s2,800018cc <exit+0x58>
    if(p->ofile[fd]){
    800018c6:	6088                	ld	a0,0(s1)
    800018c8:	f575                	bnez	a0,800018b4 <exit+0x40>
    800018ca:	bfdd                	j	800018c0 <exit+0x4c>
  begin_op();
    800018cc:	00002097          	auipc	ra,0x2
    800018d0:	f06080e7          	jalr	-250(ra) # 800037d2 <begin_op>
  iput(p->cwd);
    800018d4:	1509b503          	ld	a0,336(s3)
    800018d8:	00001097          	auipc	ra,0x1
    800018dc:	70e080e7          	jalr	1806(ra) # 80002fe6 <iput>
  end_op();
    800018e0:	00002097          	auipc	ra,0x2
    800018e4:	f6c080e7          	jalr	-148(ra) # 8000384c <end_op>
  p->cwd = 0;
    800018e8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800018ec:	00227497          	auipc	s1,0x227
    800018f0:	06448493          	add	s1,s1,100 # 80228950 <wait_lock>
    800018f4:	8526                	mv	a0,s1
    800018f6:	00005097          	auipc	ra,0x5
    800018fa:	ac8080e7          	jalr	-1336(ra) # 800063be <acquire>
  reparent(p);
    800018fe:	854e                	mv	a0,s3
    80001900:	00000097          	auipc	ra,0x0
    80001904:	f1a080e7          	jalr	-230(ra) # 8000181a <reparent>
  wakeup(p->parent);
    80001908:	0389b503          	ld	a0,56(s3)
    8000190c:	00000097          	auipc	ra,0x0
    80001910:	e98080e7          	jalr	-360(ra) # 800017a4 <wakeup>
  acquire(&p->lock);
    80001914:	854e                	mv	a0,s3
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	aa8080e7          	jalr	-1368(ra) # 800063be <acquire>
  p->xstate = status;
    8000191e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001922:	4795                	li	a5,5
    80001924:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001928:	8526                	mv	a0,s1
    8000192a:	00005097          	auipc	ra,0x5
    8000192e:	b48080e7          	jalr	-1208(ra) # 80006472 <release>
  sched();
    80001932:	00000097          	auipc	ra,0x0
    80001936:	cfc080e7          	jalr	-772(ra) # 8000162e <sched>
  panic("zombie exit");
    8000193a:	00007517          	auipc	a0,0x7
    8000193e:	8f650513          	add	a0,a0,-1802 # 80008230 <etext+0x230>
    80001942:	00004097          	auipc	ra,0x4
    80001946:	544080e7          	jalr	1348(ra) # 80005e86 <panic>

000000008000194a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000194a:	7179                	add	sp,sp,-48
    8000194c:	f406                	sd	ra,40(sp)
    8000194e:	f022                	sd	s0,32(sp)
    80001950:	ec26                	sd	s1,24(sp)
    80001952:	e84a                	sd	s2,16(sp)
    80001954:	e44e                	sd	s3,8(sp)
    80001956:	1800                	add	s0,sp,48
    80001958:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000195a:	00227497          	auipc	s1,0x227
    8000195e:	40e48493          	add	s1,s1,1038 # 80228d68 <proc>
    80001962:	0022d997          	auipc	s3,0x22d
    80001966:	e0698993          	add	s3,s3,-506 # 8022e768 <tickslock>
    acquire(&p->lock);
    8000196a:	8526                	mv	a0,s1
    8000196c:	00005097          	auipc	ra,0x5
    80001970:	a52080e7          	jalr	-1454(ra) # 800063be <acquire>
    if(p->pid == pid){
    80001974:	589c                	lw	a5,48(s1)
    80001976:	01278d63          	beq	a5,s2,80001990 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000197a:	8526                	mv	a0,s1
    8000197c:	00005097          	auipc	ra,0x5
    80001980:	af6080e7          	jalr	-1290(ra) # 80006472 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001984:	16848493          	add	s1,s1,360
    80001988:	ff3491e3          	bne	s1,s3,8000196a <kill+0x20>
  }
  return -1;
    8000198c:	557d                	li	a0,-1
    8000198e:	a829                	j	800019a8 <kill+0x5e>
      p->killed = 1;
    80001990:	4785                	li	a5,1
    80001992:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001994:	4c98                	lw	a4,24(s1)
    80001996:	4789                	li	a5,2
    80001998:	00f70f63          	beq	a4,a5,800019b6 <kill+0x6c>
      release(&p->lock);
    8000199c:	8526                	mv	a0,s1
    8000199e:	00005097          	auipc	ra,0x5
    800019a2:	ad4080e7          	jalr	-1324(ra) # 80006472 <release>
      return 0;
    800019a6:	4501                	li	a0,0
}
    800019a8:	70a2                	ld	ra,40(sp)
    800019aa:	7402                	ld	s0,32(sp)
    800019ac:	64e2                	ld	s1,24(sp)
    800019ae:	6942                	ld	s2,16(sp)
    800019b0:	69a2                	ld	s3,8(sp)
    800019b2:	6145                	add	sp,sp,48
    800019b4:	8082                	ret
        p->state = RUNNABLE;
    800019b6:	478d                	li	a5,3
    800019b8:	cc9c                	sw	a5,24(s1)
    800019ba:	b7cd                	j	8000199c <kill+0x52>

00000000800019bc <setkilled>:

void
setkilled(struct proc *p)
{
    800019bc:	1101                	add	sp,sp,-32
    800019be:	ec06                	sd	ra,24(sp)
    800019c0:	e822                	sd	s0,16(sp)
    800019c2:	e426                	sd	s1,8(sp)
    800019c4:	1000                	add	s0,sp,32
    800019c6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800019c8:	00005097          	auipc	ra,0x5
    800019cc:	9f6080e7          	jalr	-1546(ra) # 800063be <acquire>
  p->killed = 1;
    800019d0:	4785                	li	a5,1
    800019d2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800019d4:	8526                	mv	a0,s1
    800019d6:	00005097          	auipc	ra,0x5
    800019da:	a9c080e7          	jalr	-1380(ra) # 80006472 <release>
}
    800019de:	60e2                	ld	ra,24(sp)
    800019e0:	6442                	ld	s0,16(sp)
    800019e2:	64a2                	ld	s1,8(sp)
    800019e4:	6105                	add	sp,sp,32
    800019e6:	8082                	ret

00000000800019e8 <killed>:

int
killed(struct proc *p)
{
    800019e8:	1101                	add	sp,sp,-32
    800019ea:	ec06                	sd	ra,24(sp)
    800019ec:	e822                	sd	s0,16(sp)
    800019ee:	e426                	sd	s1,8(sp)
    800019f0:	e04a                	sd	s2,0(sp)
    800019f2:	1000                	add	s0,sp,32
    800019f4:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800019f6:	00005097          	auipc	ra,0x5
    800019fa:	9c8080e7          	jalr	-1592(ra) # 800063be <acquire>
  k = p->killed;
    800019fe:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001a02:	8526                	mv	a0,s1
    80001a04:	00005097          	auipc	ra,0x5
    80001a08:	a6e080e7          	jalr	-1426(ra) # 80006472 <release>
  return k;
}
    80001a0c:	854a                	mv	a0,s2
    80001a0e:	60e2                	ld	ra,24(sp)
    80001a10:	6442                	ld	s0,16(sp)
    80001a12:	64a2                	ld	s1,8(sp)
    80001a14:	6902                	ld	s2,0(sp)
    80001a16:	6105                	add	sp,sp,32
    80001a18:	8082                	ret

0000000080001a1a <wait>:
{
    80001a1a:	715d                	add	sp,sp,-80
    80001a1c:	e486                	sd	ra,72(sp)
    80001a1e:	e0a2                	sd	s0,64(sp)
    80001a20:	fc26                	sd	s1,56(sp)
    80001a22:	f84a                	sd	s2,48(sp)
    80001a24:	f44e                	sd	s3,40(sp)
    80001a26:	f052                	sd	s4,32(sp)
    80001a28:	ec56                	sd	s5,24(sp)
    80001a2a:	e85a                	sd	s6,16(sp)
    80001a2c:	e45e                	sd	s7,8(sp)
    80001a2e:	e062                	sd	s8,0(sp)
    80001a30:	0880                	add	s0,sp,80
    80001a32:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001a34:	fffff097          	auipc	ra,0xfffff
    80001a38:	660080e7          	jalr	1632(ra) # 80001094 <myproc>
    80001a3c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a3e:	00227517          	auipc	a0,0x227
    80001a42:	f1250513          	add	a0,a0,-238 # 80228950 <wait_lock>
    80001a46:	00005097          	auipc	ra,0x5
    80001a4a:	978080e7          	jalr	-1672(ra) # 800063be <acquire>
    havekids = 0;
    80001a4e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001a50:	4a15                	li	s4,5
        havekids = 1;
    80001a52:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a54:	0022d997          	auipc	s3,0x22d
    80001a58:	d1498993          	add	s3,s3,-748 # 8022e768 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a5c:	00227c17          	auipc	s8,0x227
    80001a60:	ef4c0c13          	add	s8,s8,-268 # 80228950 <wait_lock>
    80001a64:	a0d1                	j	80001b28 <wait+0x10e>
          pid = pp->pid;
    80001a66:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a6a:	000b0e63          	beqz	s6,80001a86 <wait+0x6c>
    80001a6e:	4691                	li	a3,4
    80001a70:	02c48613          	add	a2,s1,44
    80001a74:	85da                	mv	a1,s6
    80001a76:	05093503          	ld	a0,80(s2)
    80001a7a:	fffff097          	auipc	ra,0xfffff
    80001a7e:	224080e7          	jalr	548(ra) # 80000c9e <copyout>
    80001a82:	04054163          	bltz	a0,80001ac4 <wait+0xaa>
          freeproc(pp);
    80001a86:	8526                	mv	a0,s1
    80001a88:	fffff097          	auipc	ra,0xfffff
    80001a8c:	7c2080e7          	jalr	1986(ra) # 8000124a <freeproc>
          release(&pp->lock);
    80001a90:	8526                	mv	a0,s1
    80001a92:	00005097          	auipc	ra,0x5
    80001a96:	9e0080e7          	jalr	-1568(ra) # 80006472 <release>
          release(&wait_lock);
    80001a9a:	00227517          	auipc	a0,0x227
    80001a9e:	eb650513          	add	a0,a0,-330 # 80228950 <wait_lock>
    80001aa2:	00005097          	auipc	ra,0x5
    80001aa6:	9d0080e7          	jalr	-1584(ra) # 80006472 <release>
}
    80001aaa:	854e                	mv	a0,s3
    80001aac:	60a6                	ld	ra,72(sp)
    80001aae:	6406                	ld	s0,64(sp)
    80001ab0:	74e2                	ld	s1,56(sp)
    80001ab2:	7942                	ld	s2,48(sp)
    80001ab4:	79a2                	ld	s3,40(sp)
    80001ab6:	7a02                	ld	s4,32(sp)
    80001ab8:	6ae2                	ld	s5,24(sp)
    80001aba:	6b42                	ld	s6,16(sp)
    80001abc:	6ba2                	ld	s7,8(sp)
    80001abe:	6c02                	ld	s8,0(sp)
    80001ac0:	6161                	add	sp,sp,80
    80001ac2:	8082                	ret
            release(&pp->lock);
    80001ac4:	8526                	mv	a0,s1
    80001ac6:	00005097          	auipc	ra,0x5
    80001aca:	9ac080e7          	jalr	-1620(ra) # 80006472 <release>
            release(&wait_lock);
    80001ace:	00227517          	auipc	a0,0x227
    80001ad2:	e8250513          	add	a0,a0,-382 # 80228950 <wait_lock>
    80001ad6:	00005097          	auipc	ra,0x5
    80001ada:	99c080e7          	jalr	-1636(ra) # 80006472 <release>
            return -1;
    80001ade:	59fd                	li	s3,-1
    80001ae0:	b7e9                	j	80001aaa <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ae2:	16848493          	add	s1,s1,360
    80001ae6:	03348463          	beq	s1,s3,80001b0e <wait+0xf4>
      if(pp->parent == p){
    80001aea:	7c9c                	ld	a5,56(s1)
    80001aec:	ff279be3          	bne	a5,s2,80001ae2 <wait+0xc8>
        acquire(&pp->lock);
    80001af0:	8526                	mv	a0,s1
    80001af2:	00005097          	auipc	ra,0x5
    80001af6:	8cc080e7          	jalr	-1844(ra) # 800063be <acquire>
        if(pp->state == ZOMBIE){
    80001afa:	4c9c                	lw	a5,24(s1)
    80001afc:	f74785e3          	beq	a5,s4,80001a66 <wait+0x4c>
        release(&pp->lock);
    80001b00:	8526                	mv	a0,s1
    80001b02:	00005097          	auipc	ra,0x5
    80001b06:	970080e7          	jalr	-1680(ra) # 80006472 <release>
        havekids = 1;
    80001b0a:	8756                	mv	a4,s5
    80001b0c:	bfd9                	j	80001ae2 <wait+0xc8>
    if(!havekids || killed(p)){
    80001b0e:	c31d                	beqz	a4,80001b34 <wait+0x11a>
    80001b10:	854a                	mv	a0,s2
    80001b12:	00000097          	auipc	ra,0x0
    80001b16:	ed6080e7          	jalr	-298(ra) # 800019e8 <killed>
    80001b1a:	ed09                	bnez	a0,80001b34 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001b1c:	85e2                	mv	a1,s8
    80001b1e:	854a                	mv	a0,s2
    80001b20:	00000097          	auipc	ra,0x0
    80001b24:	c20080e7          	jalr	-992(ra) # 80001740 <sleep>
    havekids = 0;
    80001b28:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001b2a:	00227497          	auipc	s1,0x227
    80001b2e:	23e48493          	add	s1,s1,574 # 80228d68 <proc>
    80001b32:	bf65                	j	80001aea <wait+0xd0>
      release(&wait_lock);
    80001b34:	00227517          	auipc	a0,0x227
    80001b38:	e1c50513          	add	a0,a0,-484 # 80228950 <wait_lock>
    80001b3c:	00005097          	auipc	ra,0x5
    80001b40:	936080e7          	jalr	-1738(ra) # 80006472 <release>
      return -1;
    80001b44:	59fd                	li	s3,-1
    80001b46:	b795                	j	80001aaa <wait+0x90>

0000000080001b48 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b48:	7179                	add	sp,sp,-48
    80001b4a:	f406                	sd	ra,40(sp)
    80001b4c:	f022                	sd	s0,32(sp)
    80001b4e:	ec26                	sd	s1,24(sp)
    80001b50:	e84a                	sd	s2,16(sp)
    80001b52:	e44e                	sd	s3,8(sp)
    80001b54:	e052                	sd	s4,0(sp)
    80001b56:	1800                	add	s0,sp,48
    80001b58:	84aa                	mv	s1,a0
    80001b5a:	892e                	mv	s2,a1
    80001b5c:	89b2                	mv	s3,a2
    80001b5e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b60:	fffff097          	auipc	ra,0xfffff
    80001b64:	534080e7          	jalr	1332(ra) # 80001094 <myproc>
  if(user_dst){
    80001b68:	c08d                	beqz	s1,80001b8a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b6a:	86d2                	mv	a3,s4
    80001b6c:	864e                	mv	a2,s3
    80001b6e:	85ca                	mv	a1,s2
    80001b70:	6928                	ld	a0,80(a0)
    80001b72:	fffff097          	auipc	ra,0xfffff
    80001b76:	12c080e7          	jalr	300(ra) # 80000c9e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b7a:	70a2                	ld	ra,40(sp)
    80001b7c:	7402                	ld	s0,32(sp)
    80001b7e:	64e2                	ld	s1,24(sp)
    80001b80:	6942                	ld	s2,16(sp)
    80001b82:	69a2                	ld	s3,8(sp)
    80001b84:	6a02                	ld	s4,0(sp)
    80001b86:	6145                	add	sp,sp,48
    80001b88:	8082                	ret
    memmove((char *)dst, src, len);
    80001b8a:	000a061b          	sext.w	a2,s4
    80001b8e:	85ce                	mv	a1,s3
    80001b90:	854a                	mv	a0,s2
    80001b92:	ffffe097          	auipc	ra,0xffffe
    80001b96:	7c8080e7          	jalr	1992(ra) # 8000035a <memmove>
    return 0;
    80001b9a:	8526                	mv	a0,s1
    80001b9c:	bff9                	j	80001b7a <either_copyout+0x32>

0000000080001b9e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b9e:	7179                	add	sp,sp,-48
    80001ba0:	f406                	sd	ra,40(sp)
    80001ba2:	f022                	sd	s0,32(sp)
    80001ba4:	ec26                	sd	s1,24(sp)
    80001ba6:	e84a                	sd	s2,16(sp)
    80001ba8:	e44e                	sd	s3,8(sp)
    80001baa:	e052                	sd	s4,0(sp)
    80001bac:	1800                	add	s0,sp,48
    80001bae:	892a                	mv	s2,a0
    80001bb0:	84ae                	mv	s1,a1
    80001bb2:	89b2                	mv	s3,a2
    80001bb4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001bb6:	fffff097          	auipc	ra,0xfffff
    80001bba:	4de080e7          	jalr	1246(ra) # 80001094 <myproc>
  if(user_src){
    80001bbe:	c08d                	beqz	s1,80001be0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001bc0:	86d2                	mv	a3,s4
    80001bc2:	864e                	mv	a2,s3
    80001bc4:	85ca                	mv	a1,s2
    80001bc6:	6928                	ld	a0,80(a0)
    80001bc8:	fffff097          	auipc	ra,0xfffff
    80001bcc:	218080e7          	jalr	536(ra) # 80000de0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001bd0:	70a2                	ld	ra,40(sp)
    80001bd2:	7402                	ld	s0,32(sp)
    80001bd4:	64e2                	ld	s1,24(sp)
    80001bd6:	6942                	ld	s2,16(sp)
    80001bd8:	69a2                	ld	s3,8(sp)
    80001bda:	6a02                	ld	s4,0(sp)
    80001bdc:	6145                	add	sp,sp,48
    80001bde:	8082                	ret
    memmove(dst, (char*)src, len);
    80001be0:	000a061b          	sext.w	a2,s4
    80001be4:	85ce                	mv	a1,s3
    80001be6:	854a                	mv	a0,s2
    80001be8:	ffffe097          	auipc	ra,0xffffe
    80001bec:	772080e7          	jalr	1906(ra) # 8000035a <memmove>
    return 0;
    80001bf0:	8526                	mv	a0,s1
    80001bf2:	bff9                	j	80001bd0 <either_copyin+0x32>

0000000080001bf4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001bf4:	715d                	add	sp,sp,-80
    80001bf6:	e486                	sd	ra,72(sp)
    80001bf8:	e0a2                	sd	s0,64(sp)
    80001bfa:	fc26                	sd	s1,56(sp)
    80001bfc:	f84a                	sd	s2,48(sp)
    80001bfe:	f44e                	sd	s3,40(sp)
    80001c00:	f052                	sd	s4,32(sp)
    80001c02:	ec56                	sd	s5,24(sp)
    80001c04:	e85a                	sd	s6,16(sp)
    80001c06:	e45e                	sd	s7,8(sp)
    80001c08:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001c0a:	00006517          	auipc	a0,0x6
    80001c0e:	44e50513          	add	a0,a0,1102 # 80008058 <etext+0x58>
    80001c12:	00004097          	auipc	ra,0x4
    80001c16:	2be080e7          	jalr	702(ra) # 80005ed0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c1a:	00227497          	auipc	s1,0x227
    80001c1e:	2a648493          	add	s1,s1,678 # 80228ec0 <proc+0x158>
    80001c22:	0022d917          	auipc	s2,0x22d
    80001c26:	c9e90913          	add	s2,s2,-866 # 8022e8c0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c2a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c2c:	00006997          	auipc	s3,0x6
    80001c30:	61498993          	add	s3,s3,1556 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001c34:	00006a97          	auipc	s5,0x6
    80001c38:	614a8a93          	add	s5,s5,1556 # 80008248 <etext+0x248>
    printf("\n");
    80001c3c:	00006a17          	auipc	s4,0x6
    80001c40:	41ca0a13          	add	s4,s4,1052 # 80008058 <etext+0x58>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c44:	00006b97          	auipc	s7,0x6
    80001c48:	644b8b93          	add	s7,s7,1604 # 80008288 <states.0>
    80001c4c:	a00d                	j	80001c6e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c4e:	ed86a583          	lw	a1,-296(a3)
    80001c52:	8556                	mv	a0,s5
    80001c54:	00004097          	auipc	ra,0x4
    80001c58:	27c080e7          	jalr	636(ra) # 80005ed0 <printf>
    printf("\n");
    80001c5c:	8552                	mv	a0,s4
    80001c5e:	00004097          	auipc	ra,0x4
    80001c62:	272080e7          	jalr	626(ra) # 80005ed0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c66:	16848493          	add	s1,s1,360
    80001c6a:	03248263          	beq	s1,s2,80001c8e <procdump+0x9a>
    if(p->state == UNUSED)
    80001c6e:	86a6                	mv	a3,s1
    80001c70:	ec04a783          	lw	a5,-320(s1)
    80001c74:	dbed                	beqz	a5,80001c66 <procdump+0x72>
      state = "???";
    80001c76:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c78:	fcfb6be3          	bltu	s6,a5,80001c4e <procdump+0x5a>
    80001c7c:	02079713          	sll	a4,a5,0x20
    80001c80:	01d75793          	srl	a5,a4,0x1d
    80001c84:	97de                	add	a5,a5,s7
    80001c86:	6390                	ld	a2,0(a5)
    80001c88:	f279                	bnez	a2,80001c4e <procdump+0x5a>
      state = "???";
    80001c8a:	864e                	mv	a2,s3
    80001c8c:	b7c9                	j	80001c4e <procdump+0x5a>
  }
}
    80001c8e:	60a6                	ld	ra,72(sp)
    80001c90:	6406                	ld	s0,64(sp)
    80001c92:	74e2                	ld	s1,56(sp)
    80001c94:	7942                	ld	s2,48(sp)
    80001c96:	79a2                	ld	s3,40(sp)
    80001c98:	7a02                	ld	s4,32(sp)
    80001c9a:	6ae2                	ld	s5,24(sp)
    80001c9c:	6b42                	ld	s6,16(sp)
    80001c9e:	6ba2                	ld	s7,8(sp)
    80001ca0:	6161                	add	sp,sp,80
    80001ca2:	8082                	ret

0000000080001ca4 <swtch>:
    80001ca4:	00153023          	sd	ra,0(a0)
    80001ca8:	00253423          	sd	sp,8(a0)
    80001cac:	e900                	sd	s0,16(a0)
    80001cae:	ed04                	sd	s1,24(a0)
    80001cb0:	03253023          	sd	s2,32(a0)
    80001cb4:	03353423          	sd	s3,40(a0)
    80001cb8:	03453823          	sd	s4,48(a0)
    80001cbc:	03553c23          	sd	s5,56(a0)
    80001cc0:	05653023          	sd	s6,64(a0)
    80001cc4:	05753423          	sd	s7,72(a0)
    80001cc8:	05853823          	sd	s8,80(a0)
    80001ccc:	05953c23          	sd	s9,88(a0)
    80001cd0:	07a53023          	sd	s10,96(a0)
    80001cd4:	07b53423          	sd	s11,104(a0)
    80001cd8:	0005b083          	ld	ra,0(a1)
    80001cdc:	0085b103          	ld	sp,8(a1)
    80001ce0:	6980                	ld	s0,16(a1)
    80001ce2:	6d84                	ld	s1,24(a1)
    80001ce4:	0205b903          	ld	s2,32(a1)
    80001ce8:	0285b983          	ld	s3,40(a1)
    80001cec:	0305ba03          	ld	s4,48(a1)
    80001cf0:	0385ba83          	ld	s5,56(a1)
    80001cf4:	0405bb03          	ld	s6,64(a1)
    80001cf8:	0485bb83          	ld	s7,72(a1)
    80001cfc:	0505bc03          	ld	s8,80(a1)
    80001d00:	0585bc83          	ld	s9,88(a1)
    80001d04:	0605bd03          	ld	s10,96(a1)
    80001d08:	0685bd83          	ld	s11,104(a1)
    80001d0c:	8082                	ret

0000000080001d0e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001d0e:	1141                	add	sp,sp,-16
    80001d10:	e406                	sd	ra,8(sp)
    80001d12:	e022                	sd	s0,0(sp)
    80001d14:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001d16:	00006597          	auipc	a1,0x6
    80001d1a:	5a258593          	add	a1,a1,1442 # 800082b8 <states.0+0x30>
    80001d1e:	0022d517          	auipc	a0,0x22d
    80001d22:	a4a50513          	add	a0,a0,-1462 # 8022e768 <tickslock>
    80001d26:	00004097          	auipc	ra,0x4
    80001d2a:	608080e7          	jalr	1544(ra) # 8000632e <initlock>
}
    80001d2e:	60a2                	ld	ra,8(sp)
    80001d30:	6402                	ld	s0,0(sp)
    80001d32:	0141                	add	sp,sp,16
    80001d34:	8082                	ret

0000000080001d36 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d36:	1141                	add	sp,sp,-16
    80001d38:	e422                	sd	s0,8(sp)
    80001d3a:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d3c:	00003797          	auipc	a5,0x3
    80001d40:	58478793          	add	a5,a5,1412 # 800052c0 <kernelvec>
    80001d44:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d48:	6422                	ld	s0,8(sp)
    80001d4a:	0141                	add	sp,sp,16
    80001d4c:	8082                	ret

0000000080001d4e <cowhandler>:

int
cowhandler(pagetable_t pagetable, uint64 va)
{
  char *mem;
  if (va >= MAXVA)
    80001d4e:	57fd                	li	a5,-1
    80001d50:	83e9                	srl	a5,a5,0x1a
    80001d52:	0ab7e463          	bltu	a5,a1,80001dfa <cowhandler+0xac>
{
    80001d56:	7179                	add	sp,sp,-48
    80001d58:	f406                	sd	ra,40(sp)
    80001d5a:	f022                	sd	s0,32(sp)
    80001d5c:	ec26                	sd	s1,24(sp)
    80001d5e:	e84a                	sd	s2,16(sp)
    80001d60:	e44e                	sd	s3,8(sp)
    80001d62:	1800                	add	s0,sp,48
    return -1;
  
  pte_t* pte = walk(pagetable, va, 0);
    80001d64:	4601                	li	a2,0
    80001d66:	fffff097          	auipc	ra,0xfffff
    80001d6a:	87a080e7          	jalr	-1926(ra) # 800005e0 <walk>
    80001d6e:	89aa                	mv	s3,a0
  if(pte==0)
    80001d70:	c559                	beqz	a0,80001dfe <cowhandler+0xb0>
    return -1;
  
  if((*pte & PTE_COW)==0 || (*pte & PTE_U)==0 || (*pte & PTE_V)==0)
    80001d72:	6104                	ld	s1,0(a0)
    80001d74:	1114f713          	and	a4,s1,273
    80001d78:	11100793          	li	a5,273
    80001d7c:	08f71363          	bne	a4,a5,80001e02 <cowhandler+0xb4>
    return -1;

  uint64 pa = PTE2PA(*pte);
    80001d80:	80a9                	srl	s1,s1,0xa
    80001d82:	04b2                	sll	s1,s1,0xc
  int refcnt = kgetref((void*)pa);
    80001d84:	8526                	mv	a0,s1
    80001d86:	ffffe097          	auipc	ra,0xffffe
    80001d8a:	330080e7          	jalr	816(ra) # 800000b6 <kgetref>
  if(refcnt == 1){
    80001d8e:	4785                	li	a5,1
    80001d90:	04f50b63          	beq	a0,a5,80001de6 <cowhandler+0x98>
    *pte = (*pte & (~PTE_COW)) | PTE_W;
    return 0;
  }

  if(refcnt > 1){
    80001d94:	4785                	li	a5,1
    80001d96:	06a7d863          	bge	a5,a0,80001e06 <cowhandler+0xb8>
    if((mem=kalloc()) == 0) {
    80001d9a:	ffffe097          	auipc	ra,0xffffe
    80001d9e:	282080e7          	jalr	642(ra) # 8000001c <kalloc>
    80001da2:	892a                	mv	s2,a0
    80001da4:	c13d                	beqz	a0,80001e0a <cowhandler+0xbc>
      return -1;
    }
    memmove((char*)mem, (char*)pa, PGSIZE);
    80001da6:	6605                	lui	a2,0x1
    80001da8:	85a6                	mv	a1,s1
    80001daa:	ffffe097          	auipc	ra,0xffffe
    80001dae:	5b0080e7          	jalr	1456(ra) # 8000035a <memmove>
    kfree((void*)pa);
    80001db2:	8526                	mv	a0,s1
    80001db4:	ffffe097          	auipc	ra,0xffffe
    80001db8:	3ea080e7          	jalr	1002(ra) # 8000019e <kfree>
    uint flags = PTE_FLAGS(*pte);
    *pte = (PA2PTE(mem) | flags | PTE_W) & (~PTE_COW);
    80001dbc:	00c95913          	srl	s2,s2,0xc
    80001dc0:	092a                	sll	s2,s2,0xa
    uint flags = PTE_FLAGS(*pte);
    80001dc2:	0009b783          	ld	a5,0(s3)
    *pte = (PA2PTE(mem) | flags | PTE_W) & (~PTE_COW);
    80001dc6:	2fb7f793          	and	a5,a5,763
    80001dca:	0127e7b3          	or	a5,a5,s2
    80001dce:	0047e793          	or	a5,a5,4
    80001dd2:	00f9b023          	sd	a5,0(s3)
    return 0;
    80001dd6:	4501                	li	a0,0
  }
  return -1;
}
    80001dd8:	70a2                	ld	ra,40(sp)
    80001dda:	7402                	ld	s0,32(sp)
    80001ddc:	64e2                	ld	s1,24(sp)
    80001dde:	6942                	ld	s2,16(sp)
    80001de0:	69a2                	ld	s3,8(sp)
    80001de2:	6145                	add	sp,sp,48
    80001de4:	8082                	ret
    *pte = (*pte & (~PTE_COW)) | PTE_W;
    80001de6:	0009b783          	ld	a5,0(s3)
    80001dea:	efb7f793          	and	a5,a5,-261
    80001dee:	0047e793          	or	a5,a5,4
    80001df2:	00f9b023          	sd	a5,0(s3)
    return 0;
    80001df6:	4501                	li	a0,0
    80001df8:	b7c5                	j	80001dd8 <cowhandler+0x8a>
    return -1;
    80001dfa:	557d                	li	a0,-1
}
    80001dfc:	8082                	ret
    return -1;
    80001dfe:	557d                	li	a0,-1
    80001e00:	bfe1                	j	80001dd8 <cowhandler+0x8a>
    return -1;
    80001e02:	557d                	li	a0,-1
    80001e04:	bfd1                	j	80001dd8 <cowhandler+0x8a>
  return -1;
    80001e06:	557d                	li	a0,-1
    80001e08:	bfc1                	j	80001dd8 <cowhandler+0x8a>
      return -1;
    80001e0a:	557d                	li	a0,-1
    80001e0c:	b7f1                	j	80001dd8 <cowhandler+0x8a>

0000000080001e0e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001e0e:	1141                	add	sp,sp,-16
    80001e10:	e406                	sd	ra,8(sp)
    80001e12:	e022                	sd	s0,0(sp)
    80001e14:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	27e080e7          	jalr	638(ra) # 80001094 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001e22:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e24:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001e28:	00005697          	auipc	a3,0x5
    80001e2c:	1d868693          	add	a3,a3,472 # 80007000 <_trampoline>
    80001e30:	00005717          	auipc	a4,0x5
    80001e34:	1d070713          	add	a4,a4,464 # 80007000 <_trampoline>
    80001e38:	8f15                	sub	a4,a4,a3
    80001e3a:	040007b7          	lui	a5,0x4000
    80001e3e:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001e40:	07b2                	sll	a5,a5,0xc
    80001e42:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e44:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001e48:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001e4a:	18002673          	csrr	a2,satp
    80001e4e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001e50:	6d30                	ld	a2,88(a0)
    80001e52:	6138                	ld	a4,64(a0)
    80001e54:	6585                	lui	a1,0x1
    80001e56:	972e                	add	a4,a4,a1
    80001e58:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001e5a:	6d38                	ld	a4,88(a0)
    80001e5c:	00000617          	auipc	a2,0x0
    80001e60:	13460613          	add	a2,a2,308 # 80001f90 <usertrap>
    80001e64:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001e66:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e68:	8612                	mv	a2,tp
    80001e6a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6c:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001e70:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001e74:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e78:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001e7c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e7e:	6f18                	ld	a4,24(a4)
    80001e80:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001e84:	6928                	ld	a0,80(a0)
    80001e86:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001e88:	00005717          	auipc	a4,0x5
    80001e8c:	21470713          	add	a4,a4,532 # 8000709c <userret>
    80001e90:	8f15                	sub	a4,a4,a3
    80001e92:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001e94:	577d                	li	a4,-1
    80001e96:	177e                	sll	a4,a4,0x3f
    80001e98:	8d59                	or	a0,a0,a4
    80001e9a:	9782                	jalr	a5
}
    80001e9c:	60a2                	ld	ra,8(sp)
    80001e9e:	6402                	ld	s0,0(sp)
    80001ea0:	0141                	add	sp,sp,16
    80001ea2:	8082                	ret

0000000080001ea4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ea4:	1101                	add	sp,sp,-32
    80001ea6:	ec06                	sd	ra,24(sp)
    80001ea8:	e822                	sd	s0,16(sp)
    80001eaa:	e426                	sd	s1,8(sp)
    80001eac:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001eae:	0022d497          	auipc	s1,0x22d
    80001eb2:	8ba48493          	add	s1,s1,-1862 # 8022e768 <tickslock>
    80001eb6:	8526                	mv	a0,s1
    80001eb8:	00004097          	auipc	ra,0x4
    80001ebc:	506080e7          	jalr	1286(ra) # 800063be <acquire>
  ticks++;
    80001ec0:	00007517          	auipc	a0,0x7
    80001ec4:	a2850513          	add	a0,a0,-1496 # 800088e8 <ticks>
    80001ec8:	411c                	lw	a5,0(a0)
    80001eca:	2785                	addw	a5,a5,1
    80001ecc:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ece:	00000097          	auipc	ra,0x0
    80001ed2:	8d6080e7          	jalr	-1834(ra) # 800017a4 <wakeup>
  release(&tickslock);
    80001ed6:	8526                	mv	a0,s1
    80001ed8:	00004097          	auipc	ra,0x4
    80001edc:	59a080e7          	jalr	1434(ra) # 80006472 <release>
}
    80001ee0:	60e2                	ld	ra,24(sp)
    80001ee2:	6442                	ld	s0,16(sp)
    80001ee4:	64a2                	ld	s1,8(sp)
    80001ee6:	6105                	add	sp,sp,32
    80001ee8:	8082                	ret

0000000080001eea <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eea:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001eee:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001ef0:	0807df63          	bgez	a5,80001f8e <devintr+0xa4>
{
    80001ef4:	1101                	add	sp,sp,-32
    80001ef6:	ec06                	sd	ra,24(sp)
    80001ef8:	e822                	sd	s0,16(sp)
    80001efa:	e426                	sd	s1,8(sp)
    80001efc:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001efe:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001f02:	46a5                	li	a3,9
    80001f04:	00d70d63          	beq	a4,a3,80001f1e <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001f08:	577d                	li	a4,-1
    80001f0a:	177e                	sll	a4,a4,0x3f
    80001f0c:	0705                	add	a4,a4,1
    return 0;
    80001f0e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001f10:	04e78e63          	beq	a5,a4,80001f6c <devintr+0x82>
  }
}
    80001f14:	60e2                	ld	ra,24(sp)
    80001f16:	6442                	ld	s0,16(sp)
    80001f18:	64a2                	ld	s1,8(sp)
    80001f1a:	6105                	add	sp,sp,32
    80001f1c:	8082                	ret
    int irq = plic_claim();
    80001f1e:	00003097          	auipc	ra,0x3
    80001f22:	4aa080e7          	jalr	1194(ra) # 800053c8 <plic_claim>
    80001f26:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001f28:	47a9                	li	a5,10
    80001f2a:	02f50763          	beq	a0,a5,80001f58 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001f2e:	4785                	li	a5,1
    80001f30:	02f50963          	beq	a0,a5,80001f62 <devintr+0x78>
    return 1;
    80001f34:	4505                	li	a0,1
    } else if(irq){
    80001f36:	dcf9                	beqz	s1,80001f14 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001f38:	85a6                	mv	a1,s1
    80001f3a:	00006517          	auipc	a0,0x6
    80001f3e:	38650513          	add	a0,a0,902 # 800082c0 <states.0+0x38>
    80001f42:	00004097          	auipc	ra,0x4
    80001f46:	f8e080e7          	jalr	-114(ra) # 80005ed0 <printf>
      plic_complete(irq);
    80001f4a:	8526                	mv	a0,s1
    80001f4c:	00003097          	auipc	ra,0x3
    80001f50:	4a0080e7          	jalr	1184(ra) # 800053ec <plic_complete>
    return 1;
    80001f54:	4505                	li	a0,1
    80001f56:	bf7d                	j	80001f14 <devintr+0x2a>
      uartintr();
    80001f58:	00004097          	auipc	ra,0x4
    80001f5c:	386080e7          	jalr	902(ra) # 800062de <uartintr>
    if(irq)
    80001f60:	b7ed                	j	80001f4a <devintr+0x60>
      virtio_disk_intr();
    80001f62:	00004097          	auipc	ra,0x4
    80001f66:	950080e7          	jalr	-1712(ra) # 800058b2 <virtio_disk_intr>
    if(irq)
    80001f6a:	b7c5                	j	80001f4a <devintr+0x60>
    if(cpuid() == 0){
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	0fc080e7          	jalr	252(ra) # 80001068 <cpuid>
    80001f74:	c901                	beqz	a0,80001f84 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001f76:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001f7a:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001f7c:	14479073          	csrw	sip,a5
    return 2;
    80001f80:	4509                	li	a0,2
    80001f82:	bf49                	j	80001f14 <devintr+0x2a>
      clockintr();
    80001f84:	00000097          	auipc	ra,0x0
    80001f88:	f20080e7          	jalr	-224(ra) # 80001ea4 <clockintr>
    80001f8c:	b7ed                	j	80001f76 <devintr+0x8c>
}
    80001f8e:	8082                	ret

0000000080001f90 <usertrap>:
{
    80001f90:	1101                	add	sp,sp,-32
    80001f92:	ec06                	sd	ra,24(sp)
    80001f94:	e822                	sd	s0,16(sp)
    80001f96:	e426                	sd	s1,8(sp)
    80001f98:	e04a                	sd	s2,0(sp)
    80001f9a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f9c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001fa0:	1007f793          	and	a5,a5,256
    80001fa4:	e3bd                	bnez	a5,8000200a <usertrap+0x7a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001fa6:	00003797          	auipc	a5,0x3
    80001faa:	31a78793          	add	a5,a5,794 # 800052c0 <kernelvec>
    80001fae:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001fb2:	fffff097          	auipc	ra,0xfffff
    80001fb6:	0e2080e7          	jalr	226(ra) # 80001094 <myproc>
    80001fba:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001fbc:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fbe:	14102773          	csrr	a4,sepc
    80001fc2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fc4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001fc8:	47a1                	li	a5,8
    80001fca:	04f70863          	beq	a4,a5,8000201a <usertrap+0x8a>
    80001fce:	14202773          	csrr	a4,scause
  } else if(r_scause() == 0xf) {
    80001fd2:	47bd                	li	a5,15
    80001fd4:	0af71363          	bne	a4,a5,8000207a <usertrap+0xea>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fd8:	14302973          	csrr	s2,stval
    if(va0 > p->sz) {
    80001fdc:	653c                	ld	a5,72(a0)
    80001fde:	0727f863          	bgeu	a5,s2,8000204e <usertrap+0xbe>
      setkilled(p);
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	9da080e7          	jalr	-1574(ra) # 800019bc <setkilled>
  if(killed(p))
    80001fea:	8526                	mv	a0,s1
    80001fec:	00000097          	auipc	ra,0x0
    80001ff0:	9fc080e7          	jalr	-1540(ra) # 800019e8 <killed>
    80001ff4:	ed69                	bnez	a0,800020ce <usertrap+0x13e>
  usertrapret();
    80001ff6:	00000097          	auipc	ra,0x0
    80001ffa:	e18080e7          	jalr	-488(ra) # 80001e0e <usertrapret>
}
    80001ffe:	60e2                	ld	ra,24(sp)
    80002000:	6442                	ld	s0,16(sp)
    80002002:	64a2                	ld	s1,8(sp)
    80002004:	6902                	ld	s2,0(sp)
    80002006:	6105                	add	sp,sp,32
    80002008:	8082                	ret
    panic("usertrap: not from user mode");
    8000200a:	00006517          	auipc	a0,0x6
    8000200e:	2d650513          	add	a0,a0,726 # 800082e0 <states.0+0x58>
    80002012:	00004097          	auipc	ra,0x4
    80002016:	e74080e7          	jalr	-396(ra) # 80005e86 <panic>
    if(killed(p))
    8000201a:	00000097          	auipc	ra,0x0
    8000201e:	9ce080e7          	jalr	-1586(ra) # 800019e8 <killed>
    80002022:	e105                	bnez	a0,80002042 <usertrap+0xb2>
    p->trapframe->epc += 4;
    80002024:	6cb8                	ld	a4,88(s1)
    80002026:	6f1c                	ld	a5,24(a4)
    80002028:	0791                	add	a5,a5,4
    8000202a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000202c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002030:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002034:	10079073          	csrw	sstatus,a5
    syscall();
    80002038:	00000097          	auipc	ra,0x0
    8000203c:	2fc080e7          	jalr	764(ra) # 80002334 <syscall>
    80002040:	b76d                	j	80001fea <usertrap+0x5a>
      exit(-1);
    80002042:	557d                	li	a0,-1
    80002044:	00000097          	auipc	ra,0x0
    80002048:	830080e7          	jalr	-2000(ra) # 80001874 <exit>
    8000204c:	bfe1                	j	80002024 <usertrap+0x94>
    } else if (cowhandler(p->pagetable, va0) != 0) {
    8000204e:	85ca                	mv	a1,s2
    80002050:	6928                	ld	a0,80(a0)
    80002052:	00000097          	auipc	ra,0x0
    80002056:	cfc080e7          	jalr	-772(ra) # 80001d4e <cowhandler>
    8000205a:	e911                	bnez	a0,8000206e <usertrap+0xde>
    } else if (va0 < PGSIZE) {
    8000205c:	6785                	lui	a5,0x1
    8000205e:	f8f976e3          	bgeu	s2,a5,80001fea <usertrap+0x5a>
      setkilled(p);
    80002062:	8526                	mv	a0,s1
    80002064:	00000097          	auipc	ra,0x0
    80002068:	958080e7          	jalr	-1704(ra) # 800019bc <setkilled>
    8000206c:	bfbd                	j	80001fea <usertrap+0x5a>
      setkilled(p);
    8000206e:	8526                	mv	a0,s1
    80002070:	00000097          	auipc	ra,0x0
    80002074:	94c080e7          	jalr	-1716(ra) # 800019bc <setkilled>
    80002078:	bf8d                	j	80001fea <usertrap+0x5a>
  } else if((which_dev = devintr()) != 0){
    8000207a:	00000097          	auipc	ra,0x0
    8000207e:	e70080e7          	jalr	-400(ra) # 80001eea <devintr>
    80002082:	892a                	mv	s2,a0
    80002084:	c901                	beqz	a0,80002094 <usertrap+0x104>
  if(killed(p))
    80002086:	8526                	mv	a0,s1
    80002088:	00000097          	auipc	ra,0x0
    8000208c:	960080e7          	jalr	-1696(ra) # 800019e8 <killed>
    80002090:	c529                	beqz	a0,800020da <usertrap+0x14a>
    80002092:	a83d                	j	800020d0 <usertrap+0x140>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002094:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002098:	5890                	lw	a2,48(s1)
    8000209a:	00006517          	auipc	a0,0x6
    8000209e:	26650513          	add	a0,a0,614 # 80008300 <states.0+0x78>
    800020a2:	00004097          	auipc	ra,0x4
    800020a6:	e2e080e7          	jalr	-466(ra) # 80005ed0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020aa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020ae:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020b2:	00006517          	auipc	a0,0x6
    800020b6:	27e50513          	add	a0,a0,638 # 80008330 <states.0+0xa8>
    800020ba:	00004097          	auipc	ra,0x4
    800020be:	e16080e7          	jalr	-490(ra) # 80005ed0 <printf>
    setkilled(p);
    800020c2:	8526                	mv	a0,s1
    800020c4:	00000097          	auipc	ra,0x0
    800020c8:	8f8080e7          	jalr	-1800(ra) # 800019bc <setkilled>
    800020cc:	bf39                	j	80001fea <usertrap+0x5a>
  if(killed(p))
    800020ce:	4901                	li	s2,0
    exit(-1);
    800020d0:	557d                	li	a0,-1
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	7a2080e7          	jalr	1954(ra) # 80001874 <exit>
  if(which_dev == 2)
    800020da:	4789                	li	a5,2
    800020dc:	f0f91de3          	bne	s2,a5,80001ff6 <usertrap+0x66>
    yield();
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	624080e7          	jalr	1572(ra) # 80001704 <yield>
    800020e8:	b739                	j	80001ff6 <usertrap+0x66>

00000000800020ea <kerneltrap>:
{
    800020ea:	7179                	add	sp,sp,-48
    800020ec:	f406                	sd	ra,40(sp)
    800020ee:	f022                	sd	s0,32(sp)
    800020f0:	ec26                	sd	s1,24(sp)
    800020f2:	e84a                	sd	s2,16(sp)
    800020f4:	e44e                	sd	s3,8(sp)
    800020f6:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020f8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020fc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002100:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002104:	1004f793          	and	a5,s1,256
    80002108:	cb85                	beqz	a5,80002138 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000210a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000210e:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002110:	ef85                	bnez	a5,80002148 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002112:	00000097          	auipc	ra,0x0
    80002116:	dd8080e7          	jalr	-552(ra) # 80001eea <devintr>
    8000211a:	cd1d                	beqz	a0,80002158 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000211c:	4789                	li	a5,2
    8000211e:	06f50a63          	beq	a0,a5,80002192 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002122:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002126:	10049073          	csrw	sstatus,s1
}
    8000212a:	70a2                	ld	ra,40(sp)
    8000212c:	7402                	ld	s0,32(sp)
    8000212e:	64e2                	ld	s1,24(sp)
    80002130:	6942                	ld	s2,16(sp)
    80002132:	69a2                	ld	s3,8(sp)
    80002134:	6145                	add	sp,sp,48
    80002136:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002138:	00006517          	auipc	a0,0x6
    8000213c:	21850513          	add	a0,a0,536 # 80008350 <states.0+0xc8>
    80002140:	00004097          	auipc	ra,0x4
    80002144:	d46080e7          	jalr	-698(ra) # 80005e86 <panic>
    panic("kerneltrap: interrupts enabled");
    80002148:	00006517          	auipc	a0,0x6
    8000214c:	23050513          	add	a0,a0,560 # 80008378 <states.0+0xf0>
    80002150:	00004097          	auipc	ra,0x4
    80002154:	d36080e7          	jalr	-714(ra) # 80005e86 <panic>
    printf("scause %p\n", scause);
    80002158:	85ce                	mv	a1,s3
    8000215a:	00006517          	auipc	a0,0x6
    8000215e:	23e50513          	add	a0,a0,574 # 80008398 <states.0+0x110>
    80002162:	00004097          	auipc	ra,0x4
    80002166:	d6e080e7          	jalr	-658(ra) # 80005ed0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000216a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000216e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002172:	00006517          	auipc	a0,0x6
    80002176:	23650513          	add	a0,a0,566 # 800083a8 <states.0+0x120>
    8000217a:	00004097          	auipc	ra,0x4
    8000217e:	d56080e7          	jalr	-682(ra) # 80005ed0 <printf>
    panic("kerneltrap");
    80002182:	00006517          	auipc	a0,0x6
    80002186:	23e50513          	add	a0,a0,574 # 800083c0 <states.0+0x138>
    8000218a:	00004097          	auipc	ra,0x4
    8000218e:	cfc080e7          	jalr	-772(ra) # 80005e86 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	f02080e7          	jalr	-254(ra) # 80001094 <myproc>
    8000219a:	d541                	beqz	a0,80002122 <kerneltrap+0x38>
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	ef8080e7          	jalr	-264(ra) # 80001094 <myproc>
    800021a4:	4d18                	lw	a4,24(a0)
    800021a6:	4791                	li	a5,4
    800021a8:	f6f71de3          	bne	a4,a5,80002122 <kerneltrap+0x38>
    yield();
    800021ac:	fffff097          	auipc	ra,0xfffff
    800021b0:	558080e7          	jalr	1368(ra) # 80001704 <yield>
    800021b4:	b7bd                	j	80002122 <kerneltrap+0x38>

00000000800021b6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800021b6:	1101                	add	sp,sp,-32
    800021b8:	ec06                	sd	ra,24(sp)
    800021ba:	e822                	sd	s0,16(sp)
    800021bc:	e426                	sd	s1,8(sp)
    800021be:	1000                	add	s0,sp,32
    800021c0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	ed2080e7          	jalr	-302(ra) # 80001094 <myproc>
  switch (n) {
    800021ca:	4795                	li	a5,5
    800021cc:	0497e163          	bltu	a5,s1,8000220e <argraw+0x58>
    800021d0:	048a                	sll	s1,s1,0x2
    800021d2:	00006717          	auipc	a4,0x6
    800021d6:	22670713          	add	a4,a4,550 # 800083f8 <states.0+0x170>
    800021da:	94ba                	add	s1,s1,a4
    800021dc:	409c                	lw	a5,0(s1)
    800021de:	97ba                	add	a5,a5,a4
    800021e0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800021e2:	6d3c                	ld	a5,88(a0)
    800021e4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800021e6:	60e2                	ld	ra,24(sp)
    800021e8:	6442                	ld	s0,16(sp)
    800021ea:	64a2                	ld	s1,8(sp)
    800021ec:	6105                	add	sp,sp,32
    800021ee:	8082                	ret
    return p->trapframe->a1;
    800021f0:	6d3c                	ld	a5,88(a0)
    800021f2:	7fa8                	ld	a0,120(a5)
    800021f4:	bfcd                	j	800021e6 <argraw+0x30>
    return p->trapframe->a2;
    800021f6:	6d3c                	ld	a5,88(a0)
    800021f8:	63c8                	ld	a0,128(a5)
    800021fa:	b7f5                	j	800021e6 <argraw+0x30>
    return p->trapframe->a3;
    800021fc:	6d3c                	ld	a5,88(a0)
    800021fe:	67c8                	ld	a0,136(a5)
    80002200:	b7dd                	j	800021e6 <argraw+0x30>
    return p->trapframe->a4;
    80002202:	6d3c                	ld	a5,88(a0)
    80002204:	6bc8                	ld	a0,144(a5)
    80002206:	b7c5                	j	800021e6 <argraw+0x30>
    return p->trapframe->a5;
    80002208:	6d3c                	ld	a5,88(a0)
    8000220a:	6fc8                	ld	a0,152(a5)
    8000220c:	bfe9                	j	800021e6 <argraw+0x30>
  panic("argraw");
    8000220e:	00006517          	auipc	a0,0x6
    80002212:	1c250513          	add	a0,a0,450 # 800083d0 <states.0+0x148>
    80002216:	00004097          	auipc	ra,0x4
    8000221a:	c70080e7          	jalr	-912(ra) # 80005e86 <panic>

000000008000221e <fetchaddr>:
{
    8000221e:	1101                	add	sp,sp,-32
    80002220:	ec06                	sd	ra,24(sp)
    80002222:	e822                	sd	s0,16(sp)
    80002224:	e426                	sd	s1,8(sp)
    80002226:	e04a                	sd	s2,0(sp)
    80002228:	1000                	add	s0,sp,32
    8000222a:	84aa                	mv	s1,a0
    8000222c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	e66080e7          	jalr	-410(ra) # 80001094 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002236:	653c                	ld	a5,72(a0)
    80002238:	02f4f863          	bgeu	s1,a5,80002268 <fetchaddr+0x4a>
    8000223c:	00848713          	add	a4,s1,8
    80002240:	02e7e663          	bltu	a5,a4,8000226c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002244:	46a1                	li	a3,8
    80002246:	8626                	mv	a2,s1
    80002248:	85ca                	mv	a1,s2
    8000224a:	6928                	ld	a0,80(a0)
    8000224c:	fffff097          	auipc	ra,0xfffff
    80002250:	b94080e7          	jalr	-1132(ra) # 80000de0 <copyin>
    80002254:	00a03533          	snez	a0,a0
    80002258:	40a00533          	neg	a0,a0
}
    8000225c:	60e2                	ld	ra,24(sp)
    8000225e:	6442                	ld	s0,16(sp)
    80002260:	64a2                	ld	s1,8(sp)
    80002262:	6902                	ld	s2,0(sp)
    80002264:	6105                	add	sp,sp,32
    80002266:	8082                	ret
    return -1;
    80002268:	557d                	li	a0,-1
    8000226a:	bfcd                	j	8000225c <fetchaddr+0x3e>
    8000226c:	557d                	li	a0,-1
    8000226e:	b7fd                	j	8000225c <fetchaddr+0x3e>

0000000080002270 <fetchstr>:
{
    80002270:	7179                	add	sp,sp,-48
    80002272:	f406                	sd	ra,40(sp)
    80002274:	f022                	sd	s0,32(sp)
    80002276:	ec26                	sd	s1,24(sp)
    80002278:	e84a                	sd	s2,16(sp)
    8000227a:	e44e                	sd	s3,8(sp)
    8000227c:	1800                	add	s0,sp,48
    8000227e:	892a                	mv	s2,a0
    80002280:	84ae                	mv	s1,a1
    80002282:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002284:	fffff097          	auipc	ra,0xfffff
    80002288:	e10080e7          	jalr	-496(ra) # 80001094 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000228c:	86ce                	mv	a3,s3
    8000228e:	864a                	mv	a2,s2
    80002290:	85a6                	mv	a1,s1
    80002292:	6928                	ld	a0,80(a0)
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	bda080e7          	jalr	-1062(ra) # 80000e6e <copyinstr>
    8000229c:	00054e63          	bltz	a0,800022b8 <fetchstr+0x48>
  return strlen(buf);
    800022a0:	8526                	mv	a0,s1
    800022a2:	ffffe097          	auipc	ra,0xffffe
    800022a6:	1d6080e7          	jalr	470(ra) # 80000478 <strlen>
}
    800022aa:	70a2                	ld	ra,40(sp)
    800022ac:	7402                	ld	s0,32(sp)
    800022ae:	64e2                	ld	s1,24(sp)
    800022b0:	6942                	ld	s2,16(sp)
    800022b2:	69a2                	ld	s3,8(sp)
    800022b4:	6145                	add	sp,sp,48
    800022b6:	8082                	ret
    return -1;
    800022b8:	557d                	li	a0,-1
    800022ba:	bfc5                	j	800022aa <fetchstr+0x3a>

00000000800022bc <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800022bc:	1101                	add	sp,sp,-32
    800022be:	ec06                	sd	ra,24(sp)
    800022c0:	e822                	sd	s0,16(sp)
    800022c2:	e426                	sd	s1,8(sp)
    800022c4:	1000                	add	s0,sp,32
    800022c6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800022c8:	00000097          	auipc	ra,0x0
    800022cc:	eee080e7          	jalr	-274(ra) # 800021b6 <argraw>
    800022d0:	c088                	sw	a0,0(s1)
}
    800022d2:	60e2                	ld	ra,24(sp)
    800022d4:	6442                	ld	s0,16(sp)
    800022d6:	64a2                	ld	s1,8(sp)
    800022d8:	6105                	add	sp,sp,32
    800022da:	8082                	ret

00000000800022dc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800022dc:	1101                	add	sp,sp,-32
    800022de:	ec06                	sd	ra,24(sp)
    800022e0:	e822                	sd	s0,16(sp)
    800022e2:	e426                	sd	s1,8(sp)
    800022e4:	1000                	add	s0,sp,32
    800022e6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800022e8:	00000097          	auipc	ra,0x0
    800022ec:	ece080e7          	jalr	-306(ra) # 800021b6 <argraw>
    800022f0:	e088                	sd	a0,0(s1)
}
    800022f2:	60e2                	ld	ra,24(sp)
    800022f4:	6442                	ld	s0,16(sp)
    800022f6:	64a2                	ld	s1,8(sp)
    800022f8:	6105                	add	sp,sp,32
    800022fa:	8082                	ret

00000000800022fc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800022fc:	7179                	add	sp,sp,-48
    800022fe:	f406                	sd	ra,40(sp)
    80002300:	f022                	sd	s0,32(sp)
    80002302:	ec26                	sd	s1,24(sp)
    80002304:	e84a                	sd	s2,16(sp)
    80002306:	1800                	add	s0,sp,48
    80002308:	84ae                	mv	s1,a1
    8000230a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000230c:	fd840593          	add	a1,s0,-40
    80002310:	00000097          	auipc	ra,0x0
    80002314:	fcc080e7          	jalr	-52(ra) # 800022dc <argaddr>
  return fetchstr(addr, buf, max);
    80002318:	864a                	mv	a2,s2
    8000231a:	85a6                	mv	a1,s1
    8000231c:	fd843503          	ld	a0,-40(s0)
    80002320:	00000097          	auipc	ra,0x0
    80002324:	f50080e7          	jalr	-176(ra) # 80002270 <fetchstr>
}
    80002328:	70a2                	ld	ra,40(sp)
    8000232a:	7402                	ld	s0,32(sp)
    8000232c:	64e2                	ld	s1,24(sp)
    8000232e:	6942                	ld	s2,16(sp)
    80002330:	6145                	add	sp,sp,48
    80002332:	8082                	ret

0000000080002334 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002334:	1101                	add	sp,sp,-32
    80002336:	ec06                	sd	ra,24(sp)
    80002338:	e822                	sd	s0,16(sp)
    8000233a:	e426                	sd	s1,8(sp)
    8000233c:	e04a                	sd	s2,0(sp)
    8000233e:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	d54080e7          	jalr	-684(ra) # 80001094 <myproc>
    80002348:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000234a:	05853903          	ld	s2,88(a0)
    8000234e:	0a893783          	ld	a5,168(s2)
    80002352:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002356:	37fd                	addw	a5,a5,-1 # fff <_entry-0x7ffff001>
    80002358:	4751                	li	a4,20
    8000235a:	00f76f63          	bltu	a4,a5,80002378 <syscall+0x44>
    8000235e:	00369713          	sll	a4,a3,0x3
    80002362:	00006797          	auipc	a5,0x6
    80002366:	0ae78793          	add	a5,a5,174 # 80008410 <syscalls>
    8000236a:	97ba                	add	a5,a5,a4
    8000236c:	639c                	ld	a5,0(a5)
    8000236e:	c789                	beqz	a5,80002378 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002370:	9782                	jalr	a5
    80002372:	06a93823          	sd	a0,112(s2)
    80002376:	a839                	j	80002394 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002378:	15848613          	add	a2,s1,344
    8000237c:	588c                	lw	a1,48(s1)
    8000237e:	00006517          	auipc	a0,0x6
    80002382:	05a50513          	add	a0,a0,90 # 800083d8 <states.0+0x150>
    80002386:	00004097          	auipc	ra,0x4
    8000238a:	b4a080e7          	jalr	-1206(ra) # 80005ed0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000238e:	6cbc                	ld	a5,88(s1)
    80002390:	577d                	li	a4,-1
    80002392:	fbb8                	sd	a4,112(a5)
  }
}
    80002394:	60e2                	ld	ra,24(sp)
    80002396:	6442                	ld	s0,16(sp)
    80002398:	64a2                	ld	s1,8(sp)
    8000239a:	6902                	ld	s2,0(sp)
    8000239c:	6105                	add	sp,sp,32
    8000239e:	8082                	ret

00000000800023a0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800023a0:	1101                	add	sp,sp,-32
    800023a2:	ec06                	sd	ra,24(sp)
    800023a4:	e822                	sd	s0,16(sp)
    800023a6:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    800023a8:	fec40593          	add	a1,s0,-20
    800023ac:	4501                	li	a0,0
    800023ae:	00000097          	auipc	ra,0x0
    800023b2:	f0e080e7          	jalr	-242(ra) # 800022bc <argint>
  exit(n);
    800023b6:	fec42503          	lw	a0,-20(s0)
    800023ba:	fffff097          	auipc	ra,0xfffff
    800023be:	4ba080e7          	jalr	1210(ra) # 80001874 <exit>
  return 0;  // not reached
}
    800023c2:	4501                	li	a0,0
    800023c4:	60e2                	ld	ra,24(sp)
    800023c6:	6442                	ld	s0,16(sp)
    800023c8:	6105                	add	sp,sp,32
    800023ca:	8082                	ret

00000000800023cc <sys_getpid>:

uint64
sys_getpid(void)
{
    800023cc:	1141                	add	sp,sp,-16
    800023ce:	e406                	sd	ra,8(sp)
    800023d0:	e022                	sd	s0,0(sp)
    800023d2:	0800                	add	s0,sp,16
  return myproc()->pid;
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	cc0080e7          	jalr	-832(ra) # 80001094 <myproc>
}
    800023dc:	5908                	lw	a0,48(a0)
    800023de:	60a2                	ld	ra,8(sp)
    800023e0:	6402                	ld	s0,0(sp)
    800023e2:	0141                	add	sp,sp,16
    800023e4:	8082                	ret

00000000800023e6 <sys_fork>:

uint64
sys_fork(void)
{
    800023e6:	1141                	add	sp,sp,-16
    800023e8:	e406                	sd	ra,8(sp)
    800023ea:	e022                	sd	s0,0(sp)
    800023ec:	0800                	add	s0,sp,16
  return fork();
    800023ee:	fffff097          	auipc	ra,0xfffff
    800023f2:	060080e7          	jalr	96(ra) # 8000144e <fork>
}
    800023f6:	60a2                	ld	ra,8(sp)
    800023f8:	6402                	ld	s0,0(sp)
    800023fa:	0141                	add	sp,sp,16
    800023fc:	8082                	ret

00000000800023fe <sys_wait>:

uint64
sys_wait(void)
{
    800023fe:	1101                	add	sp,sp,-32
    80002400:	ec06                	sd	ra,24(sp)
    80002402:	e822                	sd	s0,16(sp)
    80002404:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002406:	fe840593          	add	a1,s0,-24
    8000240a:	4501                	li	a0,0
    8000240c:	00000097          	auipc	ra,0x0
    80002410:	ed0080e7          	jalr	-304(ra) # 800022dc <argaddr>
  return wait(p);
    80002414:	fe843503          	ld	a0,-24(s0)
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	602080e7          	jalr	1538(ra) # 80001a1a <wait>
}
    80002420:	60e2                	ld	ra,24(sp)
    80002422:	6442                	ld	s0,16(sp)
    80002424:	6105                	add	sp,sp,32
    80002426:	8082                	ret

0000000080002428 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002428:	7179                	add	sp,sp,-48
    8000242a:	f406                	sd	ra,40(sp)
    8000242c:	f022                	sd	s0,32(sp)
    8000242e:	ec26                	sd	s1,24(sp)
    80002430:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002432:	fdc40593          	add	a1,s0,-36
    80002436:	4501                	li	a0,0
    80002438:	00000097          	auipc	ra,0x0
    8000243c:	e84080e7          	jalr	-380(ra) # 800022bc <argint>
  addr = myproc()->sz;
    80002440:	fffff097          	auipc	ra,0xfffff
    80002444:	c54080e7          	jalr	-940(ra) # 80001094 <myproc>
    80002448:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000244a:	fdc42503          	lw	a0,-36(s0)
    8000244e:	fffff097          	auipc	ra,0xfffff
    80002452:	fa4080e7          	jalr	-92(ra) # 800013f2 <growproc>
    80002456:	00054863          	bltz	a0,80002466 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000245a:	8526                	mv	a0,s1
    8000245c:	70a2                	ld	ra,40(sp)
    8000245e:	7402                	ld	s0,32(sp)
    80002460:	64e2                	ld	s1,24(sp)
    80002462:	6145                	add	sp,sp,48
    80002464:	8082                	ret
    return -1;
    80002466:	54fd                	li	s1,-1
    80002468:	bfcd                	j	8000245a <sys_sbrk+0x32>

000000008000246a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000246a:	7139                	add	sp,sp,-64
    8000246c:	fc06                	sd	ra,56(sp)
    8000246e:	f822                	sd	s0,48(sp)
    80002470:	f426                	sd	s1,40(sp)
    80002472:	f04a                	sd	s2,32(sp)
    80002474:	ec4e                	sd	s3,24(sp)
    80002476:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002478:	fcc40593          	add	a1,s0,-52
    8000247c:	4501                	li	a0,0
    8000247e:	00000097          	auipc	ra,0x0
    80002482:	e3e080e7          	jalr	-450(ra) # 800022bc <argint>
  if(n < 0)
    80002486:	fcc42783          	lw	a5,-52(s0)
    8000248a:	0607cf63          	bltz	a5,80002508 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000248e:	0022c517          	auipc	a0,0x22c
    80002492:	2da50513          	add	a0,a0,730 # 8022e768 <tickslock>
    80002496:	00004097          	auipc	ra,0x4
    8000249a:	f28080e7          	jalr	-216(ra) # 800063be <acquire>
  ticks0 = ticks;
    8000249e:	00006917          	auipc	s2,0x6
    800024a2:	44a92903          	lw	s2,1098(s2) # 800088e8 <ticks>
  while(ticks - ticks0 < n){
    800024a6:	fcc42783          	lw	a5,-52(s0)
    800024aa:	cf9d                	beqz	a5,800024e8 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800024ac:	0022c997          	auipc	s3,0x22c
    800024b0:	2bc98993          	add	s3,s3,700 # 8022e768 <tickslock>
    800024b4:	00006497          	auipc	s1,0x6
    800024b8:	43448493          	add	s1,s1,1076 # 800088e8 <ticks>
    if(killed(myproc())){
    800024bc:	fffff097          	auipc	ra,0xfffff
    800024c0:	bd8080e7          	jalr	-1064(ra) # 80001094 <myproc>
    800024c4:	fffff097          	auipc	ra,0xfffff
    800024c8:	524080e7          	jalr	1316(ra) # 800019e8 <killed>
    800024cc:	e129                	bnez	a0,8000250e <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800024ce:	85ce                	mv	a1,s3
    800024d0:	8526                	mv	a0,s1
    800024d2:	fffff097          	auipc	ra,0xfffff
    800024d6:	26e080e7          	jalr	622(ra) # 80001740 <sleep>
  while(ticks - ticks0 < n){
    800024da:	409c                	lw	a5,0(s1)
    800024dc:	412787bb          	subw	a5,a5,s2
    800024e0:	fcc42703          	lw	a4,-52(s0)
    800024e4:	fce7ece3          	bltu	a5,a4,800024bc <sys_sleep+0x52>
  }
  release(&tickslock);
    800024e8:	0022c517          	auipc	a0,0x22c
    800024ec:	28050513          	add	a0,a0,640 # 8022e768 <tickslock>
    800024f0:	00004097          	auipc	ra,0x4
    800024f4:	f82080e7          	jalr	-126(ra) # 80006472 <release>
  return 0;
    800024f8:	4501                	li	a0,0
}
    800024fa:	70e2                	ld	ra,56(sp)
    800024fc:	7442                	ld	s0,48(sp)
    800024fe:	74a2                	ld	s1,40(sp)
    80002500:	7902                	ld	s2,32(sp)
    80002502:	69e2                	ld	s3,24(sp)
    80002504:	6121                	add	sp,sp,64
    80002506:	8082                	ret
    n = 0;
    80002508:	fc042623          	sw	zero,-52(s0)
    8000250c:	b749                	j	8000248e <sys_sleep+0x24>
      release(&tickslock);
    8000250e:	0022c517          	auipc	a0,0x22c
    80002512:	25a50513          	add	a0,a0,602 # 8022e768 <tickslock>
    80002516:	00004097          	auipc	ra,0x4
    8000251a:	f5c080e7          	jalr	-164(ra) # 80006472 <release>
      return -1;
    8000251e:	557d                	li	a0,-1
    80002520:	bfe9                	j	800024fa <sys_sleep+0x90>

0000000080002522 <sys_kill>:

uint64
sys_kill(void)
{
    80002522:	1101                	add	sp,sp,-32
    80002524:	ec06                	sd	ra,24(sp)
    80002526:	e822                	sd	s0,16(sp)
    80002528:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    8000252a:	fec40593          	add	a1,s0,-20
    8000252e:	4501                	li	a0,0
    80002530:	00000097          	auipc	ra,0x0
    80002534:	d8c080e7          	jalr	-628(ra) # 800022bc <argint>
  return kill(pid);
    80002538:	fec42503          	lw	a0,-20(s0)
    8000253c:	fffff097          	auipc	ra,0xfffff
    80002540:	40e080e7          	jalr	1038(ra) # 8000194a <kill>
}
    80002544:	60e2                	ld	ra,24(sp)
    80002546:	6442                	ld	s0,16(sp)
    80002548:	6105                	add	sp,sp,32
    8000254a:	8082                	ret

000000008000254c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000254c:	1101                	add	sp,sp,-32
    8000254e:	ec06                	sd	ra,24(sp)
    80002550:	e822                	sd	s0,16(sp)
    80002552:	e426                	sd	s1,8(sp)
    80002554:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002556:	0022c517          	auipc	a0,0x22c
    8000255a:	21250513          	add	a0,a0,530 # 8022e768 <tickslock>
    8000255e:	00004097          	auipc	ra,0x4
    80002562:	e60080e7          	jalr	-416(ra) # 800063be <acquire>
  xticks = ticks;
    80002566:	00006497          	auipc	s1,0x6
    8000256a:	3824a483          	lw	s1,898(s1) # 800088e8 <ticks>
  release(&tickslock);
    8000256e:	0022c517          	auipc	a0,0x22c
    80002572:	1fa50513          	add	a0,a0,506 # 8022e768 <tickslock>
    80002576:	00004097          	auipc	ra,0x4
    8000257a:	efc080e7          	jalr	-260(ra) # 80006472 <release>
  return xticks;
}
    8000257e:	02049513          	sll	a0,s1,0x20
    80002582:	9101                	srl	a0,a0,0x20
    80002584:	60e2                	ld	ra,24(sp)
    80002586:	6442                	ld	s0,16(sp)
    80002588:	64a2                	ld	s1,8(sp)
    8000258a:	6105                	add	sp,sp,32
    8000258c:	8082                	ret

000000008000258e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000258e:	7179                	add	sp,sp,-48
    80002590:	f406                	sd	ra,40(sp)
    80002592:	f022                	sd	s0,32(sp)
    80002594:	ec26                	sd	s1,24(sp)
    80002596:	e84a                	sd	s2,16(sp)
    80002598:	e44e                	sd	s3,8(sp)
    8000259a:	e052                	sd	s4,0(sp)
    8000259c:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000259e:	00006597          	auipc	a1,0x6
    800025a2:	f2258593          	add	a1,a1,-222 # 800084c0 <syscalls+0xb0>
    800025a6:	0022c517          	auipc	a0,0x22c
    800025aa:	1da50513          	add	a0,a0,474 # 8022e780 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	d80080e7          	jalr	-640(ra) # 8000632e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800025b6:	00234797          	auipc	a5,0x234
    800025ba:	1ca78793          	add	a5,a5,458 # 80236780 <bcache+0x8000>
    800025be:	00234717          	auipc	a4,0x234
    800025c2:	42a70713          	add	a4,a4,1066 # 802369e8 <bcache+0x8268>
    800025c6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800025ca:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025ce:	0022c497          	auipc	s1,0x22c
    800025d2:	1ca48493          	add	s1,s1,458 # 8022e798 <bcache+0x18>
    b->next = bcache.head.next;
    800025d6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800025d8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800025da:	00006a17          	auipc	s4,0x6
    800025de:	eeea0a13          	add	s4,s4,-274 # 800084c8 <syscalls+0xb8>
    b->next = bcache.head.next;
    800025e2:	2b893783          	ld	a5,696(s2)
    800025e6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800025e8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800025ec:	85d2                	mv	a1,s4
    800025ee:	01048513          	add	a0,s1,16
    800025f2:	00001097          	auipc	ra,0x1
    800025f6:	496080e7          	jalr	1174(ra) # 80003a88 <initsleeplock>
    bcache.head.next->prev = b;
    800025fa:	2b893783          	ld	a5,696(s2)
    800025fe:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002600:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002604:	45848493          	add	s1,s1,1112
    80002608:	fd349de3          	bne	s1,s3,800025e2 <binit+0x54>
  }
}
    8000260c:	70a2                	ld	ra,40(sp)
    8000260e:	7402                	ld	s0,32(sp)
    80002610:	64e2                	ld	s1,24(sp)
    80002612:	6942                	ld	s2,16(sp)
    80002614:	69a2                	ld	s3,8(sp)
    80002616:	6a02                	ld	s4,0(sp)
    80002618:	6145                	add	sp,sp,48
    8000261a:	8082                	ret

000000008000261c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000261c:	7179                	add	sp,sp,-48
    8000261e:	f406                	sd	ra,40(sp)
    80002620:	f022                	sd	s0,32(sp)
    80002622:	ec26                	sd	s1,24(sp)
    80002624:	e84a                	sd	s2,16(sp)
    80002626:	e44e                	sd	s3,8(sp)
    80002628:	1800                	add	s0,sp,48
    8000262a:	892a                	mv	s2,a0
    8000262c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000262e:	0022c517          	auipc	a0,0x22c
    80002632:	15250513          	add	a0,a0,338 # 8022e780 <bcache>
    80002636:	00004097          	auipc	ra,0x4
    8000263a:	d88080e7          	jalr	-632(ra) # 800063be <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000263e:	00234497          	auipc	s1,0x234
    80002642:	3fa4b483          	ld	s1,1018(s1) # 80236a38 <bcache+0x82b8>
    80002646:	00234797          	auipc	a5,0x234
    8000264a:	3a278793          	add	a5,a5,930 # 802369e8 <bcache+0x8268>
    8000264e:	02f48f63          	beq	s1,a5,8000268c <bread+0x70>
    80002652:	873e                	mv	a4,a5
    80002654:	a021                	j	8000265c <bread+0x40>
    80002656:	68a4                	ld	s1,80(s1)
    80002658:	02e48a63          	beq	s1,a4,8000268c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000265c:	449c                	lw	a5,8(s1)
    8000265e:	ff279ce3          	bne	a5,s2,80002656 <bread+0x3a>
    80002662:	44dc                	lw	a5,12(s1)
    80002664:	ff3799e3          	bne	a5,s3,80002656 <bread+0x3a>
      b->refcnt++;
    80002668:	40bc                	lw	a5,64(s1)
    8000266a:	2785                	addw	a5,a5,1
    8000266c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000266e:	0022c517          	auipc	a0,0x22c
    80002672:	11250513          	add	a0,a0,274 # 8022e780 <bcache>
    80002676:	00004097          	auipc	ra,0x4
    8000267a:	dfc080e7          	jalr	-516(ra) # 80006472 <release>
      acquiresleep(&b->lock);
    8000267e:	01048513          	add	a0,s1,16
    80002682:	00001097          	auipc	ra,0x1
    80002686:	440080e7          	jalr	1088(ra) # 80003ac2 <acquiresleep>
      return b;
    8000268a:	a8b9                	j	800026e8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000268c:	00234497          	auipc	s1,0x234
    80002690:	3a44b483          	ld	s1,932(s1) # 80236a30 <bcache+0x82b0>
    80002694:	00234797          	auipc	a5,0x234
    80002698:	35478793          	add	a5,a5,852 # 802369e8 <bcache+0x8268>
    8000269c:	00f48863          	beq	s1,a5,800026ac <bread+0x90>
    800026a0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800026a2:	40bc                	lw	a5,64(s1)
    800026a4:	cf81                	beqz	a5,800026bc <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800026a6:	64a4                	ld	s1,72(s1)
    800026a8:	fee49de3          	bne	s1,a4,800026a2 <bread+0x86>
  panic("bget: no buffers");
    800026ac:	00006517          	auipc	a0,0x6
    800026b0:	e2450513          	add	a0,a0,-476 # 800084d0 <syscalls+0xc0>
    800026b4:	00003097          	auipc	ra,0x3
    800026b8:	7d2080e7          	jalr	2002(ra) # 80005e86 <panic>
      b->dev = dev;
    800026bc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800026c0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800026c4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800026c8:	4785                	li	a5,1
    800026ca:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026cc:	0022c517          	auipc	a0,0x22c
    800026d0:	0b450513          	add	a0,a0,180 # 8022e780 <bcache>
    800026d4:	00004097          	auipc	ra,0x4
    800026d8:	d9e080e7          	jalr	-610(ra) # 80006472 <release>
      acquiresleep(&b->lock);
    800026dc:	01048513          	add	a0,s1,16
    800026e0:	00001097          	auipc	ra,0x1
    800026e4:	3e2080e7          	jalr	994(ra) # 80003ac2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800026e8:	409c                	lw	a5,0(s1)
    800026ea:	cb89                	beqz	a5,800026fc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026ec:	8526                	mv	a0,s1
    800026ee:	70a2                	ld	ra,40(sp)
    800026f0:	7402                	ld	s0,32(sp)
    800026f2:	64e2                	ld	s1,24(sp)
    800026f4:	6942                	ld	s2,16(sp)
    800026f6:	69a2                	ld	s3,8(sp)
    800026f8:	6145                	add	sp,sp,48
    800026fa:	8082                	ret
    virtio_disk_rw(b, 0);
    800026fc:	4581                	li	a1,0
    800026fe:	8526                	mv	a0,s1
    80002700:	00003097          	auipc	ra,0x3
    80002704:	f82080e7          	jalr	-126(ra) # 80005682 <virtio_disk_rw>
    b->valid = 1;
    80002708:	4785                	li	a5,1
    8000270a:	c09c                	sw	a5,0(s1)
  return b;
    8000270c:	b7c5                	j	800026ec <bread+0xd0>

000000008000270e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000270e:	1101                	add	sp,sp,-32
    80002710:	ec06                	sd	ra,24(sp)
    80002712:	e822                	sd	s0,16(sp)
    80002714:	e426                	sd	s1,8(sp)
    80002716:	1000                	add	s0,sp,32
    80002718:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000271a:	0541                	add	a0,a0,16
    8000271c:	00001097          	auipc	ra,0x1
    80002720:	440080e7          	jalr	1088(ra) # 80003b5c <holdingsleep>
    80002724:	cd01                	beqz	a0,8000273c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002726:	4585                	li	a1,1
    80002728:	8526                	mv	a0,s1
    8000272a:	00003097          	auipc	ra,0x3
    8000272e:	f58080e7          	jalr	-168(ra) # 80005682 <virtio_disk_rw>
}
    80002732:	60e2                	ld	ra,24(sp)
    80002734:	6442                	ld	s0,16(sp)
    80002736:	64a2                	ld	s1,8(sp)
    80002738:	6105                	add	sp,sp,32
    8000273a:	8082                	ret
    panic("bwrite");
    8000273c:	00006517          	auipc	a0,0x6
    80002740:	dac50513          	add	a0,a0,-596 # 800084e8 <syscalls+0xd8>
    80002744:	00003097          	auipc	ra,0x3
    80002748:	742080e7          	jalr	1858(ra) # 80005e86 <panic>

000000008000274c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000274c:	1101                	add	sp,sp,-32
    8000274e:	ec06                	sd	ra,24(sp)
    80002750:	e822                	sd	s0,16(sp)
    80002752:	e426                	sd	s1,8(sp)
    80002754:	e04a                	sd	s2,0(sp)
    80002756:	1000                	add	s0,sp,32
    80002758:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000275a:	01050913          	add	s2,a0,16
    8000275e:	854a                	mv	a0,s2
    80002760:	00001097          	auipc	ra,0x1
    80002764:	3fc080e7          	jalr	1020(ra) # 80003b5c <holdingsleep>
    80002768:	c925                	beqz	a0,800027d8 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000276a:	854a                	mv	a0,s2
    8000276c:	00001097          	auipc	ra,0x1
    80002770:	3ac080e7          	jalr	940(ra) # 80003b18 <releasesleep>

  acquire(&bcache.lock);
    80002774:	0022c517          	auipc	a0,0x22c
    80002778:	00c50513          	add	a0,a0,12 # 8022e780 <bcache>
    8000277c:	00004097          	auipc	ra,0x4
    80002780:	c42080e7          	jalr	-958(ra) # 800063be <acquire>
  b->refcnt--;
    80002784:	40bc                	lw	a5,64(s1)
    80002786:	37fd                	addw	a5,a5,-1
    80002788:	0007871b          	sext.w	a4,a5
    8000278c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000278e:	e71d                	bnez	a4,800027bc <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002790:	68b8                	ld	a4,80(s1)
    80002792:	64bc                	ld	a5,72(s1)
    80002794:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002796:	68b8                	ld	a4,80(s1)
    80002798:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000279a:	00234797          	auipc	a5,0x234
    8000279e:	fe678793          	add	a5,a5,-26 # 80236780 <bcache+0x8000>
    800027a2:	2b87b703          	ld	a4,696(a5)
    800027a6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800027a8:	00234717          	auipc	a4,0x234
    800027ac:	24070713          	add	a4,a4,576 # 802369e8 <bcache+0x8268>
    800027b0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800027b2:	2b87b703          	ld	a4,696(a5)
    800027b6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800027b8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800027bc:	0022c517          	auipc	a0,0x22c
    800027c0:	fc450513          	add	a0,a0,-60 # 8022e780 <bcache>
    800027c4:	00004097          	auipc	ra,0x4
    800027c8:	cae080e7          	jalr	-850(ra) # 80006472 <release>
}
    800027cc:	60e2                	ld	ra,24(sp)
    800027ce:	6442                	ld	s0,16(sp)
    800027d0:	64a2                	ld	s1,8(sp)
    800027d2:	6902                	ld	s2,0(sp)
    800027d4:	6105                	add	sp,sp,32
    800027d6:	8082                	ret
    panic("brelse");
    800027d8:	00006517          	auipc	a0,0x6
    800027dc:	d1850513          	add	a0,a0,-744 # 800084f0 <syscalls+0xe0>
    800027e0:	00003097          	auipc	ra,0x3
    800027e4:	6a6080e7          	jalr	1702(ra) # 80005e86 <panic>

00000000800027e8 <bpin>:

void
bpin(struct buf *b) {
    800027e8:	1101                	add	sp,sp,-32
    800027ea:	ec06                	sd	ra,24(sp)
    800027ec:	e822                	sd	s0,16(sp)
    800027ee:	e426                	sd	s1,8(sp)
    800027f0:	1000                	add	s0,sp,32
    800027f2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027f4:	0022c517          	auipc	a0,0x22c
    800027f8:	f8c50513          	add	a0,a0,-116 # 8022e780 <bcache>
    800027fc:	00004097          	auipc	ra,0x4
    80002800:	bc2080e7          	jalr	-1086(ra) # 800063be <acquire>
  b->refcnt++;
    80002804:	40bc                	lw	a5,64(s1)
    80002806:	2785                	addw	a5,a5,1
    80002808:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000280a:	0022c517          	auipc	a0,0x22c
    8000280e:	f7650513          	add	a0,a0,-138 # 8022e780 <bcache>
    80002812:	00004097          	auipc	ra,0x4
    80002816:	c60080e7          	jalr	-928(ra) # 80006472 <release>
}
    8000281a:	60e2                	ld	ra,24(sp)
    8000281c:	6442                	ld	s0,16(sp)
    8000281e:	64a2                	ld	s1,8(sp)
    80002820:	6105                	add	sp,sp,32
    80002822:	8082                	ret

0000000080002824 <bunpin>:

void
bunpin(struct buf *b) {
    80002824:	1101                	add	sp,sp,-32
    80002826:	ec06                	sd	ra,24(sp)
    80002828:	e822                	sd	s0,16(sp)
    8000282a:	e426                	sd	s1,8(sp)
    8000282c:	1000                	add	s0,sp,32
    8000282e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002830:	0022c517          	auipc	a0,0x22c
    80002834:	f5050513          	add	a0,a0,-176 # 8022e780 <bcache>
    80002838:	00004097          	auipc	ra,0x4
    8000283c:	b86080e7          	jalr	-1146(ra) # 800063be <acquire>
  b->refcnt--;
    80002840:	40bc                	lw	a5,64(s1)
    80002842:	37fd                	addw	a5,a5,-1
    80002844:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002846:	0022c517          	auipc	a0,0x22c
    8000284a:	f3a50513          	add	a0,a0,-198 # 8022e780 <bcache>
    8000284e:	00004097          	auipc	ra,0x4
    80002852:	c24080e7          	jalr	-988(ra) # 80006472 <release>
}
    80002856:	60e2                	ld	ra,24(sp)
    80002858:	6442                	ld	s0,16(sp)
    8000285a:	64a2                	ld	s1,8(sp)
    8000285c:	6105                	add	sp,sp,32
    8000285e:	8082                	ret

0000000080002860 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002860:	1101                	add	sp,sp,-32
    80002862:	ec06                	sd	ra,24(sp)
    80002864:	e822                	sd	s0,16(sp)
    80002866:	e426                	sd	s1,8(sp)
    80002868:	e04a                	sd	s2,0(sp)
    8000286a:	1000                	add	s0,sp,32
    8000286c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000286e:	00d5d59b          	srlw	a1,a1,0xd
    80002872:	00234797          	auipc	a5,0x234
    80002876:	5ea7a783          	lw	a5,1514(a5) # 80236e5c <sb+0x1c>
    8000287a:	9dbd                	addw	a1,a1,a5
    8000287c:	00000097          	auipc	ra,0x0
    80002880:	da0080e7          	jalr	-608(ra) # 8000261c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002884:	0074f713          	and	a4,s1,7
    80002888:	4785                	li	a5,1
    8000288a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000288e:	14ce                	sll	s1,s1,0x33
    80002890:	90d9                	srl	s1,s1,0x36
    80002892:	00950733          	add	a4,a0,s1
    80002896:	05874703          	lbu	a4,88(a4)
    8000289a:	00e7f6b3          	and	a3,a5,a4
    8000289e:	c69d                	beqz	a3,800028cc <bfree+0x6c>
    800028a0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800028a2:	94aa                	add	s1,s1,a0
    800028a4:	fff7c793          	not	a5,a5
    800028a8:	8f7d                	and	a4,a4,a5
    800028aa:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800028ae:	00001097          	auipc	ra,0x1
    800028b2:	0f6080e7          	jalr	246(ra) # 800039a4 <log_write>
  brelse(bp);
    800028b6:	854a                	mv	a0,s2
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	e94080e7          	jalr	-364(ra) # 8000274c <brelse>
}
    800028c0:	60e2                	ld	ra,24(sp)
    800028c2:	6442                	ld	s0,16(sp)
    800028c4:	64a2                	ld	s1,8(sp)
    800028c6:	6902                	ld	s2,0(sp)
    800028c8:	6105                	add	sp,sp,32
    800028ca:	8082                	ret
    panic("freeing free block");
    800028cc:	00006517          	auipc	a0,0x6
    800028d0:	c2c50513          	add	a0,a0,-980 # 800084f8 <syscalls+0xe8>
    800028d4:	00003097          	auipc	ra,0x3
    800028d8:	5b2080e7          	jalr	1458(ra) # 80005e86 <panic>

00000000800028dc <balloc>:
{
    800028dc:	711d                	add	sp,sp,-96
    800028de:	ec86                	sd	ra,88(sp)
    800028e0:	e8a2                	sd	s0,80(sp)
    800028e2:	e4a6                	sd	s1,72(sp)
    800028e4:	e0ca                	sd	s2,64(sp)
    800028e6:	fc4e                	sd	s3,56(sp)
    800028e8:	f852                	sd	s4,48(sp)
    800028ea:	f456                	sd	s5,40(sp)
    800028ec:	f05a                	sd	s6,32(sp)
    800028ee:	ec5e                	sd	s7,24(sp)
    800028f0:	e862                	sd	s8,16(sp)
    800028f2:	e466                	sd	s9,8(sp)
    800028f4:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028f6:	00234797          	auipc	a5,0x234
    800028fa:	54e7a783          	lw	a5,1358(a5) # 80236e44 <sb+0x4>
    800028fe:	cff5                	beqz	a5,800029fa <balloc+0x11e>
    80002900:	8baa                	mv	s7,a0
    80002902:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002904:	00234b17          	auipc	s6,0x234
    80002908:	53cb0b13          	add	s6,s6,1340 # 80236e40 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000290c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000290e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002910:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002912:	6c89                	lui	s9,0x2
    80002914:	a061                	j	8000299c <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002916:	97ca                	add	a5,a5,s2
    80002918:	8e55                	or	a2,a2,a3
    8000291a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000291e:	854a                	mv	a0,s2
    80002920:	00001097          	auipc	ra,0x1
    80002924:	084080e7          	jalr	132(ra) # 800039a4 <log_write>
        brelse(bp);
    80002928:	854a                	mv	a0,s2
    8000292a:	00000097          	auipc	ra,0x0
    8000292e:	e22080e7          	jalr	-478(ra) # 8000274c <brelse>
  bp = bread(dev, bno);
    80002932:	85a6                	mv	a1,s1
    80002934:	855e                	mv	a0,s7
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	ce6080e7          	jalr	-794(ra) # 8000261c <bread>
    8000293e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002940:	40000613          	li	a2,1024
    80002944:	4581                	li	a1,0
    80002946:	05850513          	add	a0,a0,88
    8000294a:	ffffe097          	auipc	ra,0xffffe
    8000294e:	9b4080e7          	jalr	-1612(ra) # 800002fe <memset>
  log_write(bp);
    80002952:	854a                	mv	a0,s2
    80002954:	00001097          	auipc	ra,0x1
    80002958:	050080e7          	jalr	80(ra) # 800039a4 <log_write>
  brelse(bp);
    8000295c:	854a                	mv	a0,s2
    8000295e:	00000097          	auipc	ra,0x0
    80002962:	dee080e7          	jalr	-530(ra) # 8000274c <brelse>
}
    80002966:	8526                	mv	a0,s1
    80002968:	60e6                	ld	ra,88(sp)
    8000296a:	6446                	ld	s0,80(sp)
    8000296c:	64a6                	ld	s1,72(sp)
    8000296e:	6906                	ld	s2,64(sp)
    80002970:	79e2                	ld	s3,56(sp)
    80002972:	7a42                	ld	s4,48(sp)
    80002974:	7aa2                	ld	s5,40(sp)
    80002976:	7b02                	ld	s6,32(sp)
    80002978:	6be2                	ld	s7,24(sp)
    8000297a:	6c42                	ld	s8,16(sp)
    8000297c:	6ca2                	ld	s9,8(sp)
    8000297e:	6125                	add	sp,sp,96
    80002980:	8082                	ret
    brelse(bp);
    80002982:	854a                	mv	a0,s2
    80002984:	00000097          	auipc	ra,0x0
    80002988:	dc8080e7          	jalr	-568(ra) # 8000274c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000298c:	015c87bb          	addw	a5,s9,s5
    80002990:	00078a9b          	sext.w	s5,a5
    80002994:	004b2703          	lw	a4,4(s6)
    80002998:	06eaf163          	bgeu	s5,a4,800029fa <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000299c:	41fad79b          	sraw	a5,s5,0x1f
    800029a0:	0137d79b          	srlw	a5,a5,0x13
    800029a4:	015787bb          	addw	a5,a5,s5
    800029a8:	40d7d79b          	sraw	a5,a5,0xd
    800029ac:	01cb2583          	lw	a1,28(s6)
    800029b0:	9dbd                	addw	a1,a1,a5
    800029b2:	855e                	mv	a0,s7
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	c68080e7          	jalr	-920(ra) # 8000261c <bread>
    800029bc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029be:	004b2503          	lw	a0,4(s6)
    800029c2:	000a849b          	sext.w	s1,s5
    800029c6:	8762                	mv	a4,s8
    800029c8:	faa4fde3          	bgeu	s1,a0,80002982 <balloc+0xa6>
      m = 1 << (bi % 8);
    800029cc:	00777693          	and	a3,a4,7
    800029d0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800029d4:	41f7579b          	sraw	a5,a4,0x1f
    800029d8:	01d7d79b          	srlw	a5,a5,0x1d
    800029dc:	9fb9                	addw	a5,a5,a4
    800029de:	4037d79b          	sraw	a5,a5,0x3
    800029e2:	00f90633          	add	a2,s2,a5
    800029e6:	05864603          	lbu	a2,88(a2)
    800029ea:	00c6f5b3          	and	a1,a3,a2
    800029ee:	d585                	beqz	a1,80002916 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029f0:	2705                	addw	a4,a4,1
    800029f2:	2485                	addw	s1,s1,1
    800029f4:	fd471ae3          	bne	a4,s4,800029c8 <balloc+0xec>
    800029f8:	b769                	j	80002982 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800029fa:	00006517          	auipc	a0,0x6
    800029fe:	b1650513          	add	a0,a0,-1258 # 80008510 <syscalls+0x100>
    80002a02:	00003097          	auipc	ra,0x3
    80002a06:	4ce080e7          	jalr	1230(ra) # 80005ed0 <printf>
  return 0;
    80002a0a:	4481                	li	s1,0
    80002a0c:	bfa9                	j	80002966 <balloc+0x8a>

0000000080002a0e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a0e:	7179                	add	sp,sp,-48
    80002a10:	f406                	sd	ra,40(sp)
    80002a12:	f022                	sd	s0,32(sp)
    80002a14:	ec26                	sd	s1,24(sp)
    80002a16:	e84a                	sd	s2,16(sp)
    80002a18:	e44e                	sd	s3,8(sp)
    80002a1a:	e052                	sd	s4,0(sp)
    80002a1c:	1800                	add	s0,sp,48
    80002a1e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a20:	47ad                	li	a5,11
    80002a22:	02b7e863          	bltu	a5,a1,80002a52 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002a26:	02059793          	sll	a5,a1,0x20
    80002a2a:	01e7d593          	srl	a1,a5,0x1e
    80002a2e:	00b504b3          	add	s1,a0,a1
    80002a32:	0504a903          	lw	s2,80(s1)
    80002a36:	06091e63          	bnez	s2,80002ab2 <bmap+0xa4>
      addr = balloc(ip->dev);
    80002a3a:	4108                	lw	a0,0(a0)
    80002a3c:	00000097          	auipc	ra,0x0
    80002a40:	ea0080e7          	jalr	-352(ra) # 800028dc <balloc>
    80002a44:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a48:	06090563          	beqz	s2,80002ab2 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002a4c:	0524a823          	sw	s2,80(s1)
    80002a50:	a08d                	j	80002ab2 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002a52:	ff45849b          	addw	s1,a1,-12
    80002a56:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a5a:	0ff00793          	li	a5,255
    80002a5e:	08e7e563          	bltu	a5,a4,80002ae8 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002a62:	08052903          	lw	s2,128(a0)
    80002a66:	00091d63          	bnez	s2,80002a80 <bmap+0x72>
      addr = balloc(ip->dev);
    80002a6a:	4108                	lw	a0,0(a0)
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	e70080e7          	jalr	-400(ra) # 800028dc <balloc>
    80002a74:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a78:	02090d63          	beqz	s2,80002ab2 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002a7c:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002a80:	85ca                	mv	a1,s2
    80002a82:	0009a503          	lw	a0,0(s3)
    80002a86:	00000097          	auipc	ra,0x0
    80002a8a:	b96080e7          	jalr	-1130(ra) # 8000261c <bread>
    80002a8e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a90:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a94:	02049713          	sll	a4,s1,0x20
    80002a98:	01e75593          	srl	a1,a4,0x1e
    80002a9c:	00b784b3          	add	s1,a5,a1
    80002aa0:	0004a903          	lw	s2,0(s1)
    80002aa4:	02090063          	beqz	s2,80002ac4 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002aa8:	8552                	mv	a0,s4
    80002aaa:	00000097          	auipc	ra,0x0
    80002aae:	ca2080e7          	jalr	-862(ra) # 8000274c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002ab2:	854a                	mv	a0,s2
    80002ab4:	70a2                	ld	ra,40(sp)
    80002ab6:	7402                	ld	s0,32(sp)
    80002ab8:	64e2                	ld	s1,24(sp)
    80002aba:	6942                	ld	s2,16(sp)
    80002abc:	69a2                	ld	s3,8(sp)
    80002abe:	6a02                	ld	s4,0(sp)
    80002ac0:	6145                	add	sp,sp,48
    80002ac2:	8082                	ret
      addr = balloc(ip->dev);
    80002ac4:	0009a503          	lw	a0,0(s3)
    80002ac8:	00000097          	auipc	ra,0x0
    80002acc:	e14080e7          	jalr	-492(ra) # 800028dc <balloc>
    80002ad0:	0005091b          	sext.w	s2,a0
      if(addr){
    80002ad4:	fc090ae3          	beqz	s2,80002aa8 <bmap+0x9a>
        a[bn] = addr;
    80002ad8:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002adc:	8552                	mv	a0,s4
    80002ade:	00001097          	auipc	ra,0x1
    80002ae2:	ec6080e7          	jalr	-314(ra) # 800039a4 <log_write>
    80002ae6:	b7c9                	j	80002aa8 <bmap+0x9a>
  panic("bmap: out of range");
    80002ae8:	00006517          	auipc	a0,0x6
    80002aec:	a4050513          	add	a0,a0,-1472 # 80008528 <syscalls+0x118>
    80002af0:	00003097          	auipc	ra,0x3
    80002af4:	396080e7          	jalr	918(ra) # 80005e86 <panic>

0000000080002af8 <iget>:
{
    80002af8:	7179                	add	sp,sp,-48
    80002afa:	f406                	sd	ra,40(sp)
    80002afc:	f022                	sd	s0,32(sp)
    80002afe:	ec26                	sd	s1,24(sp)
    80002b00:	e84a                	sd	s2,16(sp)
    80002b02:	e44e                	sd	s3,8(sp)
    80002b04:	e052                	sd	s4,0(sp)
    80002b06:	1800                	add	s0,sp,48
    80002b08:	89aa                	mv	s3,a0
    80002b0a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b0c:	00234517          	auipc	a0,0x234
    80002b10:	35450513          	add	a0,a0,852 # 80236e60 <itable>
    80002b14:	00004097          	auipc	ra,0x4
    80002b18:	8aa080e7          	jalr	-1878(ra) # 800063be <acquire>
  empty = 0;
    80002b1c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b1e:	00234497          	auipc	s1,0x234
    80002b22:	35a48493          	add	s1,s1,858 # 80236e78 <itable+0x18>
    80002b26:	00236697          	auipc	a3,0x236
    80002b2a:	de268693          	add	a3,a3,-542 # 80238908 <log>
    80002b2e:	a039                	j	80002b3c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b30:	02090b63          	beqz	s2,80002b66 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b34:	08848493          	add	s1,s1,136
    80002b38:	02d48a63          	beq	s1,a3,80002b6c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b3c:	449c                	lw	a5,8(s1)
    80002b3e:	fef059e3          	blez	a5,80002b30 <iget+0x38>
    80002b42:	4098                	lw	a4,0(s1)
    80002b44:	ff3716e3          	bne	a4,s3,80002b30 <iget+0x38>
    80002b48:	40d8                	lw	a4,4(s1)
    80002b4a:	ff4713e3          	bne	a4,s4,80002b30 <iget+0x38>
      ip->ref++;
    80002b4e:	2785                	addw	a5,a5,1
    80002b50:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b52:	00234517          	auipc	a0,0x234
    80002b56:	30e50513          	add	a0,a0,782 # 80236e60 <itable>
    80002b5a:	00004097          	auipc	ra,0x4
    80002b5e:	918080e7          	jalr	-1768(ra) # 80006472 <release>
      return ip;
    80002b62:	8926                	mv	s2,s1
    80002b64:	a03d                	j	80002b92 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b66:	f7f9                	bnez	a5,80002b34 <iget+0x3c>
    80002b68:	8926                	mv	s2,s1
    80002b6a:	b7e9                	j	80002b34 <iget+0x3c>
  if(empty == 0)
    80002b6c:	02090c63          	beqz	s2,80002ba4 <iget+0xac>
  ip->dev = dev;
    80002b70:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b74:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b78:	4785                	li	a5,1
    80002b7a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b7e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b82:	00234517          	auipc	a0,0x234
    80002b86:	2de50513          	add	a0,a0,734 # 80236e60 <itable>
    80002b8a:	00004097          	auipc	ra,0x4
    80002b8e:	8e8080e7          	jalr	-1816(ra) # 80006472 <release>
}
    80002b92:	854a                	mv	a0,s2
    80002b94:	70a2                	ld	ra,40(sp)
    80002b96:	7402                	ld	s0,32(sp)
    80002b98:	64e2                	ld	s1,24(sp)
    80002b9a:	6942                	ld	s2,16(sp)
    80002b9c:	69a2                	ld	s3,8(sp)
    80002b9e:	6a02                	ld	s4,0(sp)
    80002ba0:	6145                	add	sp,sp,48
    80002ba2:	8082                	ret
    panic("iget: no inodes");
    80002ba4:	00006517          	auipc	a0,0x6
    80002ba8:	99c50513          	add	a0,a0,-1636 # 80008540 <syscalls+0x130>
    80002bac:	00003097          	auipc	ra,0x3
    80002bb0:	2da080e7          	jalr	730(ra) # 80005e86 <panic>

0000000080002bb4 <fsinit>:
fsinit(int dev) {
    80002bb4:	7179                	add	sp,sp,-48
    80002bb6:	f406                	sd	ra,40(sp)
    80002bb8:	f022                	sd	s0,32(sp)
    80002bba:	ec26                	sd	s1,24(sp)
    80002bbc:	e84a                	sd	s2,16(sp)
    80002bbe:	e44e                	sd	s3,8(sp)
    80002bc0:	1800                	add	s0,sp,48
    80002bc2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002bc4:	4585                	li	a1,1
    80002bc6:	00000097          	auipc	ra,0x0
    80002bca:	a56080e7          	jalr	-1450(ra) # 8000261c <bread>
    80002bce:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bd0:	00234997          	auipc	s3,0x234
    80002bd4:	27098993          	add	s3,s3,624 # 80236e40 <sb>
    80002bd8:	02000613          	li	a2,32
    80002bdc:	05850593          	add	a1,a0,88
    80002be0:	854e                	mv	a0,s3
    80002be2:	ffffd097          	auipc	ra,0xffffd
    80002be6:	778080e7          	jalr	1912(ra) # 8000035a <memmove>
  brelse(bp);
    80002bea:	8526                	mv	a0,s1
    80002bec:	00000097          	auipc	ra,0x0
    80002bf0:	b60080e7          	jalr	-1184(ra) # 8000274c <brelse>
  if(sb.magic != FSMAGIC)
    80002bf4:	0009a703          	lw	a4,0(s3)
    80002bf8:	102037b7          	lui	a5,0x10203
    80002bfc:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c00:	02f71263          	bne	a4,a5,80002c24 <fsinit+0x70>
  initlog(dev, &sb);
    80002c04:	00234597          	auipc	a1,0x234
    80002c08:	23c58593          	add	a1,a1,572 # 80236e40 <sb>
    80002c0c:	854a                	mv	a0,s2
    80002c0e:	00001097          	auipc	ra,0x1
    80002c12:	b2c080e7          	jalr	-1236(ra) # 8000373a <initlog>
}
    80002c16:	70a2                	ld	ra,40(sp)
    80002c18:	7402                	ld	s0,32(sp)
    80002c1a:	64e2                	ld	s1,24(sp)
    80002c1c:	6942                	ld	s2,16(sp)
    80002c1e:	69a2                	ld	s3,8(sp)
    80002c20:	6145                	add	sp,sp,48
    80002c22:	8082                	ret
    panic("invalid file system");
    80002c24:	00006517          	auipc	a0,0x6
    80002c28:	92c50513          	add	a0,a0,-1748 # 80008550 <syscalls+0x140>
    80002c2c:	00003097          	auipc	ra,0x3
    80002c30:	25a080e7          	jalr	602(ra) # 80005e86 <panic>

0000000080002c34 <iinit>:
{
    80002c34:	7179                	add	sp,sp,-48
    80002c36:	f406                	sd	ra,40(sp)
    80002c38:	f022                	sd	s0,32(sp)
    80002c3a:	ec26                	sd	s1,24(sp)
    80002c3c:	e84a                	sd	s2,16(sp)
    80002c3e:	e44e                	sd	s3,8(sp)
    80002c40:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c42:	00006597          	auipc	a1,0x6
    80002c46:	92658593          	add	a1,a1,-1754 # 80008568 <syscalls+0x158>
    80002c4a:	00234517          	auipc	a0,0x234
    80002c4e:	21650513          	add	a0,a0,534 # 80236e60 <itable>
    80002c52:	00003097          	auipc	ra,0x3
    80002c56:	6dc080e7          	jalr	1756(ra) # 8000632e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c5a:	00234497          	auipc	s1,0x234
    80002c5e:	22e48493          	add	s1,s1,558 # 80236e88 <itable+0x28>
    80002c62:	00236997          	auipc	s3,0x236
    80002c66:	cb698993          	add	s3,s3,-842 # 80238918 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c6a:	00006917          	auipc	s2,0x6
    80002c6e:	90690913          	add	s2,s2,-1786 # 80008570 <syscalls+0x160>
    80002c72:	85ca                	mv	a1,s2
    80002c74:	8526                	mv	a0,s1
    80002c76:	00001097          	auipc	ra,0x1
    80002c7a:	e12080e7          	jalr	-494(ra) # 80003a88 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c7e:	08848493          	add	s1,s1,136
    80002c82:	ff3498e3          	bne	s1,s3,80002c72 <iinit+0x3e>
}
    80002c86:	70a2                	ld	ra,40(sp)
    80002c88:	7402                	ld	s0,32(sp)
    80002c8a:	64e2                	ld	s1,24(sp)
    80002c8c:	6942                	ld	s2,16(sp)
    80002c8e:	69a2                	ld	s3,8(sp)
    80002c90:	6145                	add	sp,sp,48
    80002c92:	8082                	ret

0000000080002c94 <ialloc>:
{
    80002c94:	7139                	add	sp,sp,-64
    80002c96:	fc06                	sd	ra,56(sp)
    80002c98:	f822                	sd	s0,48(sp)
    80002c9a:	f426                	sd	s1,40(sp)
    80002c9c:	f04a                	sd	s2,32(sp)
    80002c9e:	ec4e                	sd	s3,24(sp)
    80002ca0:	e852                	sd	s4,16(sp)
    80002ca2:	e456                	sd	s5,8(sp)
    80002ca4:	e05a                	sd	s6,0(sp)
    80002ca6:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ca8:	00234717          	auipc	a4,0x234
    80002cac:	1a472703          	lw	a4,420(a4) # 80236e4c <sb+0xc>
    80002cb0:	4785                	li	a5,1
    80002cb2:	04e7f863          	bgeu	a5,a4,80002d02 <ialloc+0x6e>
    80002cb6:	8aaa                	mv	s5,a0
    80002cb8:	8b2e                	mv	s6,a1
    80002cba:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002cbc:	00234a17          	auipc	s4,0x234
    80002cc0:	184a0a13          	add	s4,s4,388 # 80236e40 <sb>
    80002cc4:	00495593          	srl	a1,s2,0x4
    80002cc8:	018a2783          	lw	a5,24(s4)
    80002ccc:	9dbd                	addw	a1,a1,a5
    80002cce:	8556                	mv	a0,s5
    80002cd0:	00000097          	auipc	ra,0x0
    80002cd4:	94c080e7          	jalr	-1716(ra) # 8000261c <bread>
    80002cd8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002cda:	05850993          	add	s3,a0,88
    80002cde:	00f97793          	and	a5,s2,15
    80002ce2:	079a                	sll	a5,a5,0x6
    80002ce4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ce6:	00099783          	lh	a5,0(s3)
    80002cea:	cf9d                	beqz	a5,80002d28 <ialloc+0x94>
    brelse(bp);
    80002cec:	00000097          	auipc	ra,0x0
    80002cf0:	a60080e7          	jalr	-1440(ra) # 8000274c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cf4:	0905                	add	s2,s2,1
    80002cf6:	00ca2703          	lw	a4,12(s4)
    80002cfa:	0009079b          	sext.w	a5,s2
    80002cfe:	fce7e3e3          	bltu	a5,a4,80002cc4 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002d02:	00006517          	auipc	a0,0x6
    80002d06:	87650513          	add	a0,a0,-1930 # 80008578 <syscalls+0x168>
    80002d0a:	00003097          	auipc	ra,0x3
    80002d0e:	1c6080e7          	jalr	454(ra) # 80005ed0 <printf>
  return 0;
    80002d12:	4501                	li	a0,0
}
    80002d14:	70e2                	ld	ra,56(sp)
    80002d16:	7442                	ld	s0,48(sp)
    80002d18:	74a2                	ld	s1,40(sp)
    80002d1a:	7902                	ld	s2,32(sp)
    80002d1c:	69e2                	ld	s3,24(sp)
    80002d1e:	6a42                	ld	s4,16(sp)
    80002d20:	6aa2                	ld	s5,8(sp)
    80002d22:	6b02                	ld	s6,0(sp)
    80002d24:	6121                	add	sp,sp,64
    80002d26:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002d28:	04000613          	li	a2,64
    80002d2c:	4581                	li	a1,0
    80002d2e:	854e                	mv	a0,s3
    80002d30:	ffffd097          	auipc	ra,0xffffd
    80002d34:	5ce080e7          	jalr	1486(ra) # 800002fe <memset>
      dip->type = type;
    80002d38:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d3c:	8526                	mv	a0,s1
    80002d3e:	00001097          	auipc	ra,0x1
    80002d42:	c66080e7          	jalr	-922(ra) # 800039a4 <log_write>
      brelse(bp);
    80002d46:	8526                	mv	a0,s1
    80002d48:	00000097          	auipc	ra,0x0
    80002d4c:	a04080e7          	jalr	-1532(ra) # 8000274c <brelse>
      return iget(dev, inum);
    80002d50:	0009059b          	sext.w	a1,s2
    80002d54:	8556                	mv	a0,s5
    80002d56:	00000097          	auipc	ra,0x0
    80002d5a:	da2080e7          	jalr	-606(ra) # 80002af8 <iget>
    80002d5e:	bf5d                	j	80002d14 <ialloc+0x80>

0000000080002d60 <iupdate>:
{
    80002d60:	1101                	add	sp,sp,-32
    80002d62:	ec06                	sd	ra,24(sp)
    80002d64:	e822                	sd	s0,16(sp)
    80002d66:	e426                	sd	s1,8(sp)
    80002d68:	e04a                	sd	s2,0(sp)
    80002d6a:	1000                	add	s0,sp,32
    80002d6c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d6e:	415c                	lw	a5,4(a0)
    80002d70:	0047d79b          	srlw	a5,a5,0x4
    80002d74:	00234597          	auipc	a1,0x234
    80002d78:	0e45a583          	lw	a1,228(a1) # 80236e58 <sb+0x18>
    80002d7c:	9dbd                	addw	a1,a1,a5
    80002d7e:	4108                	lw	a0,0(a0)
    80002d80:	00000097          	auipc	ra,0x0
    80002d84:	89c080e7          	jalr	-1892(ra) # 8000261c <bread>
    80002d88:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d8a:	05850793          	add	a5,a0,88
    80002d8e:	40d8                	lw	a4,4(s1)
    80002d90:	8b3d                	and	a4,a4,15
    80002d92:	071a                	sll	a4,a4,0x6
    80002d94:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d96:	04449703          	lh	a4,68(s1)
    80002d9a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d9e:	04649703          	lh	a4,70(s1)
    80002da2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002da6:	04849703          	lh	a4,72(s1)
    80002daa:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002dae:	04a49703          	lh	a4,74(s1)
    80002db2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002db6:	44f8                	lw	a4,76(s1)
    80002db8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002dba:	03400613          	li	a2,52
    80002dbe:	05048593          	add	a1,s1,80
    80002dc2:	00c78513          	add	a0,a5,12
    80002dc6:	ffffd097          	auipc	ra,0xffffd
    80002dca:	594080e7          	jalr	1428(ra) # 8000035a <memmove>
  log_write(bp);
    80002dce:	854a                	mv	a0,s2
    80002dd0:	00001097          	auipc	ra,0x1
    80002dd4:	bd4080e7          	jalr	-1068(ra) # 800039a4 <log_write>
  brelse(bp);
    80002dd8:	854a                	mv	a0,s2
    80002dda:	00000097          	auipc	ra,0x0
    80002dde:	972080e7          	jalr	-1678(ra) # 8000274c <brelse>
}
    80002de2:	60e2                	ld	ra,24(sp)
    80002de4:	6442                	ld	s0,16(sp)
    80002de6:	64a2                	ld	s1,8(sp)
    80002de8:	6902                	ld	s2,0(sp)
    80002dea:	6105                	add	sp,sp,32
    80002dec:	8082                	ret

0000000080002dee <idup>:
{
    80002dee:	1101                	add	sp,sp,-32
    80002df0:	ec06                	sd	ra,24(sp)
    80002df2:	e822                	sd	s0,16(sp)
    80002df4:	e426                	sd	s1,8(sp)
    80002df6:	1000                	add	s0,sp,32
    80002df8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dfa:	00234517          	auipc	a0,0x234
    80002dfe:	06650513          	add	a0,a0,102 # 80236e60 <itable>
    80002e02:	00003097          	auipc	ra,0x3
    80002e06:	5bc080e7          	jalr	1468(ra) # 800063be <acquire>
  ip->ref++;
    80002e0a:	449c                	lw	a5,8(s1)
    80002e0c:	2785                	addw	a5,a5,1
    80002e0e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e10:	00234517          	auipc	a0,0x234
    80002e14:	05050513          	add	a0,a0,80 # 80236e60 <itable>
    80002e18:	00003097          	auipc	ra,0x3
    80002e1c:	65a080e7          	jalr	1626(ra) # 80006472 <release>
}
    80002e20:	8526                	mv	a0,s1
    80002e22:	60e2                	ld	ra,24(sp)
    80002e24:	6442                	ld	s0,16(sp)
    80002e26:	64a2                	ld	s1,8(sp)
    80002e28:	6105                	add	sp,sp,32
    80002e2a:	8082                	ret

0000000080002e2c <ilock>:
{
    80002e2c:	1101                	add	sp,sp,-32
    80002e2e:	ec06                	sd	ra,24(sp)
    80002e30:	e822                	sd	s0,16(sp)
    80002e32:	e426                	sd	s1,8(sp)
    80002e34:	e04a                	sd	s2,0(sp)
    80002e36:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e38:	c115                	beqz	a0,80002e5c <ilock+0x30>
    80002e3a:	84aa                	mv	s1,a0
    80002e3c:	451c                	lw	a5,8(a0)
    80002e3e:	00f05f63          	blez	a5,80002e5c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002e42:	0541                	add	a0,a0,16
    80002e44:	00001097          	auipc	ra,0x1
    80002e48:	c7e080e7          	jalr	-898(ra) # 80003ac2 <acquiresleep>
  if(ip->valid == 0){
    80002e4c:	40bc                	lw	a5,64(s1)
    80002e4e:	cf99                	beqz	a5,80002e6c <ilock+0x40>
}
    80002e50:	60e2                	ld	ra,24(sp)
    80002e52:	6442                	ld	s0,16(sp)
    80002e54:	64a2                	ld	s1,8(sp)
    80002e56:	6902                	ld	s2,0(sp)
    80002e58:	6105                	add	sp,sp,32
    80002e5a:	8082                	ret
    panic("ilock");
    80002e5c:	00005517          	auipc	a0,0x5
    80002e60:	73450513          	add	a0,a0,1844 # 80008590 <syscalls+0x180>
    80002e64:	00003097          	auipc	ra,0x3
    80002e68:	022080e7          	jalr	34(ra) # 80005e86 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e6c:	40dc                	lw	a5,4(s1)
    80002e6e:	0047d79b          	srlw	a5,a5,0x4
    80002e72:	00234597          	auipc	a1,0x234
    80002e76:	fe65a583          	lw	a1,-26(a1) # 80236e58 <sb+0x18>
    80002e7a:	9dbd                	addw	a1,a1,a5
    80002e7c:	4088                	lw	a0,0(s1)
    80002e7e:	fffff097          	auipc	ra,0xfffff
    80002e82:	79e080e7          	jalr	1950(ra) # 8000261c <bread>
    80002e86:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e88:	05850593          	add	a1,a0,88
    80002e8c:	40dc                	lw	a5,4(s1)
    80002e8e:	8bbd                	and	a5,a5,15
    80002e90:	079a                	sll	a5,a5,0x6
    80002e92:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e94:	00059783          	lh	a5,0(a1)
    80002e98:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e9c:	00259783          	lh	a5,2(a1)
    80002ea0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ea4:	00459783          	lh	a5,4(a1)
    80002ea8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002eac:	00659783          	lh	a5,6(a1)
    80002eb0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002eb4:	459c                	lw	a5,8(a1)
    80002eb6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002eb8:	03400613          	li	a2,52
    80002ebc:	05b1                	add	a1,a1,12
    80002ebe:	05048513          	add	a0,s1,80
    80002ec2:	ffffd097          	auipc	ra,0xffffd
    80002ec6:	498080e7          	jalr	1176(ra) # 8000035a <memmove>
    brelse(bp);
    80002eca:	854a                	mv	a0,s2
    80002ecc:	00000097          	auipc	ra,0x0
    80002ed0:	880080e7          	jalr	-1920(ra) # 8000274c <brelse>
    ip->valid = 1;
    80002ed4:	4785                	li	a5,1
    80002ed6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ed8:	04449783          	lh	a5,68(s1)
    80002edc:	fbb5                	bnez	a5,80002e50 <ilock+0x24>
      panic("ilock: no type");
    80002ede:	00005517          	auipc	a0,0x5
    80002ee2:	6ba50513          	add	a0,a0,1722 # 80008598 <syscalls+0x188>
    80002ee6:	00003097          	auipc	ra,0x3
    80002eea:	fa0080e7          	jalr	-96(ra) # 80005e86 <panic>

0000000080002eee <iunlock>:
{
    80002eee:	1101                	add	sp,sp,-32
    80002ef0:	ec06                	sd	ra,24(sp)
    80002ef2:	e822                	sd	s0,16(sp)
    80002ef4:	e426                	sd	s1,8(sp)
    80002ef6:	e04a                	sd	s2,0(sp)
    80002ef8:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002efa:	c905                	beqz	a0,80002f2a <iunlock+0x3c>
    80002efc:	84aa                	mv	s1,a0
    80002efe:	01050913          	add	s2,a0,16
    80002f02:	854a                	mv	a0,s2
    80002f04:	00001097          	auipc	ra,0x1
    80002f08:	c58080e7          	jalr	-936(ra) # 80003b5c <holdingsleep>
    80002f0c:	cd19                	beqz	a0,80002f2a <iunlock+0x3c>
    80002f0e:	449c                	lw	a5,8(s1)
    80002f10:	00f05d63          	blez	a5,80002f2a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f14:	854a                	mv	a0,s2
    80002f16:	00001097          	auipc	ra,0x1
    80002f1a:	c02080e7          	jalr	-1022(ra) # 80003b18 <releasesleep>
}
    80002f1e:	60e2                	ld	ra,24(sp)
    80002f20:	6442                	ld	s0,16(sp)
    80002f22:	64a2                	ld	s1,8(sp)
    80002f24:	6902                	ld	s2,0(sp)
    80002f26:	6105                	add	sp,sp,32
    80002f28:	8082                	ret
    panic("iunlock");
    80002f2a:	00005517          	auipc	a0,0x5
    80002f2e:	67e50513          	add	a0,a0,1662 # 800085a8 <syscalls+0x198>
    80002f32:	00003097          	auipc	ra,0x3
    80002f36:	f54080e7          	jalr	-172(ra) # 80005e86 <panic>

0000000080002f3a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f3a:	7179                	add	sp,sp,-48
    80002f3c:	f406                	sd	ra,40(sp)
    80002f3e:	f022                	sd	s0,32(sp)
    80002f40:	ec26                	sd	s1,24(sp)
    80002f42:	e84a                	sd	s2,16(sp)
    80002f44:	e44e                	sd	s3,8(sp)
    80002f46:	e052                	sd	s4,0(sp)
    80002f48:	1800                	add	s0,sp,48
    80002f4a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f4c:	05050493          	add	s1,a0,80
    80002f50:	08050913          	add	s2,a0,128
    80002f54:	a021                	j	80002f5c <itrunc+0x22>
    80002f56:	0491                	add	s1,s1,4
    80002f58:	01248d63          	beq	s1,s2,80002f72 <itrunc+0x38>
    if(ip->addrs[i]){
    80002f5c:	408c                	lw	a1,0(s1)
    80002f5e:	dde5                	beqz	a1,80002f56 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f60:	0009a503          	lw	a0,0(s3)
    80002f64:	00000097          	auipc	ra,0x0
    80002f68:	8fc080e7          	jalr	-1796(ra) # 80002860 <bfree>
      ip->addrs[i] = 0;
    80002f6c:	0004a023          	sw	zero,0(s1)
    80002f70:	b7dd                	j	80002f56 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f72:	0809a583          	lw	a1,128(s3)
    80002f76:	e185                	bnez	a1,80002f96 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f78:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f7c:	854e                	mv	a0,s3
    80002f7e:	00000097          	auipc	ra,0x0
    80002f82:	de2080e7          	jalr	-542(ra) # 80002d60 <iupdate>
}
    80002f86:	70a2                	ld	ra,40(sp)
    80002f88:	7402                	ld	s0,32(sp)
    80002f8a:	64e2                	ld	s1,24(sp)
    80002f8c:	6942                	ld	s2,16(sp)
    80002f8e:	69a2                	ld	s3,8(sp)
    80002f90:	6a02                	ld	s4,0(sp)
    80002f92:	6145                	add	sp,sp,48
    80002f94:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f96:	0009a503          	lw	a0,0(s3)
    80002f9a:	fffff097          	auipc	ra,0xfffff
    80002f9e:	682080e7          	jalr	1666(ra) # 8000261c <bread>
    80002fa2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002fa4:	05850493          	add	s1,a0,88
    80002fa8:	45850913          	add	s2,a0,1112
    80002fac:	a021                	j	80002fb4 <itrunc+0x7a>
    80002fae:	0491                	add	s1,s1,4
    80002fb0:	01248b63          	beq	s1,s2,80002fc6 <itrunc+0x8c>
      if(a[j])
    80002fb4:	408c                	lw	a1,0(s1)
    80002fb6:	dde5                	beqz	a1,80002fae <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002fb8:	0009a503          	lw	a0,0(s3)
    80002fbc:	00000097          	auipc	ra,0x0
    80002fc0:	8a4080e7          	jalr	-1884(ra) # 80002860 <bfree>
    80002fc4:	b7ed                	j	80002fae <itrunc+0x74>
    brelse(bp);
    80002fc6:	8552                	mv	a0,s4
    80002fc8:	fffff097          	auipc	ra,0xfffff
    80002fcc:	784080e7          	jalr	1924(ra) # 8000274c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002fd0:	0809a583          	lw	a1,128(s3)
    80002fd4:	0009a503          	lw	a0,0(s3)
    80002fd8:	00000097          	auipc	ra,0x0
    80002fdc:	888080e7          	jalr	-1912(ra) # 80002860 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002fe0:	0809a023          	sw	zero,128(s3)
    80002fe4:	bf51                	j	80002f78 <itrunc+0x3e>

0000000080002fe6 <iput>:
{
    80002fe6:	1101                	add	sp,sp,-32
    80002fe8:	ec06                	sd	ra,24(sp)
    80002fea:	e822                	sd	s0,16(sp)
    80002fec:	e426                	sd	s1,8(sp)
    80002fee:	e04a                	sd	s2,0(sp)
    80002ff0:	1000                	add	s0,sp,32
    80002ff2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ff4:	00234517          	auipc	a0,0x234
    80002ff8:	e6c50513          	add	a0,a0,-404 # 80236e60 <itable>
    80002ffc:	00003097          	auipc	ra,0x3
    80003000:	3c2080e7          	jalr	962(ra) # 800063be <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003004:	4498                	lw	a4,8(s1)
    80003006:	4785                	li	a5,1
    80003008:	02f70363          	beq	a4,a5,8000302e <iput+0x48>
  ip->ref--;
    8000300c:	449c                	lw	a5,8(s1)
    8000300e:	37fd                	addw	a5,a5,-1
    80003010:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003012:	00234517          	auipc	a0,0x234
    80003016:	e4e50513          	add	a0,a0,-434 # 80236e60 <itable>
    8000301a:	00003097          	auipc	ra,0x3
    8000301e:	458080e7          	jalr	1112(ra) # 80006472 <release>
}
    80003022:	60e2                	ld	ra,24(sp)
    80003024:	6442                	ld	s0,16(sp)
    80003026:	64a2                	ld	s1,8(sp)
    80003028:	6902                	ld	s2,0(sp)
    8000302a:	6105                	add	sp,sp,32
    8000302c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000302e:	40bc                	lw	a5,64(s1)
    80003030:	dff1                	beqz	a5,8000300c <iput+0x26>
    80003032:	04a49783          	lh	a5,74(s1)
    80003036:	fbf9                	bnez	a5,8000300c <iput+0x26>
    acquiresleep(&ip->lock);
    80003038:	01048913          	add	s2,s1,16
    8000303c:	854a                	mv	a0,s2
    8000303e:	00001097          	auipc	ra,0x1
    80003042:	a84080e7          	jalr	-1404(ra) # 80003ac2 <acquiresleep>
    release(&itable.lock);
    80003046:	00234517          	auipc	a0,0x234
    8000304a:	e1a50513          	add	a0,a0,-486 # 80236e60 <itable>
    8000304e:	00003097          	auipc	ra,0x3
    80003052:	424080e7          	jalr	1060(ra) # 80006472 <release>
    itrunc(ip);
    80003056:	8526                	mv	a0,s1
    80003058:	00000097          	auipc	ra,0x0
    8000305c:	ee2080e7          	jalr	-286(ra) # 80002f3a <itrunc>
    ip->type = 0;
    80003060:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003064:	8526                	mv	a0,s1
    80003066:	00000097          	auipc	ra,0x0
    8000306a:	cfa080e7          	jalr	-774(ra) # 80002d60 <iupdate>
    ip->valid = 0;
    8000306e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003072:	854a                	mv	a0,s2
    80003074:	00001097          	auipc	ra,0x1
    80003078:	aa4080e7          	jalr	-1372(ra) # 80003b18 <releasesleep>
    acquire(&itable.lock);
    8000307c:	00234517          	auipc	a0,0x234
    80003080:	de450513          	add	a0,a0,-540 # 80236e60 <itable>
    80003084:	00003097          	auipc	ra,0x3
    80003088:	33a080e7          	jalr	826(ra) # 800063be <acquire>
    8000308c:	b741                	j	8000300c <iput+0x26>

000000008000308e <iunlockput>:
{
    8000308e:	1101                	add	sp,sp,-32
    80003090:	ec06                	sd	ra,24(sp)
    80003092:	e822                	sd	s0,16(sp)
    80003094:	e426                	sd	s1,8(sp)
    80003096:	1000                	add	s0,sp,32
    80003098:	84aa                	mv	s1,a0
  iunlock(ip);
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	e54080e7          	jalr	-428(ra) # 80002eee <iunlock>
  iput(ip);
    800030a2:	8526                	mv	a0,s1
    800030a4:	00000097          	auipc	ra,0x0
    800030a8:	f42080e7          	jalr	-190(ra) # 80002fe6 <iput>
}
    800030ac:	60e2                	ld	ra,24(sp)
    800030ae:	6442                	ld	s0,16(sp)
    800030b0:	64a2                	ld	s1,8(sp)
    800030b2:	6105                	add	sp,sp,32
    800030b4:	8082                	ret

00000000800030b6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800030b6:	1141                	add	sp,sp,-16
    800030b8:	e422                	sd	s0,8(sp)
    800030ba:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    800030bc:	411c                	lw	a5,0(a0)
    800030be:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030c0:	415c                	lw	a5,4(a0)
    800030c2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030c4:	04451783          	lh	a5,68(a0)
    800030c8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030cc:	04a51783          	lh	a5,74(a0)
    800030d0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030d4:	04c56783          	lwu	a5,76(a0)
    800030d8:	e99c                	sd	a5,16(a1)
}
    800030da:	6422                	ld	s0,8(sp)
    800030dc:	0141                	add	sp,sp,16
    800030de:	8082                	ret

00000000800030e0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030e0:	457c                	lw	a5,76(a0)
    800030e2:	0ed7e963          	bltu	a5,a3,800031d4 <readi+0xf4>
{
    800030e6:	7159                	add	sp,sp,-112
    800030e8:	f486                	sd	ra,104(sp)
    800030ea:	f0a2                	sd	s0,96(sp)
    800030ec:	eca6                	sd	s1,88(sp)
    800030ee:	e8ca                	sd	s2,80(sp)
    800030f0:	e4ce                	sd	s3,72(sp)
    800030f2:	e0d2                	sd	s4,64(sp)
    800030f4:	fc56                	sd	s5,56(sp)
    800030f6:	f85a                	sd	s6,48(sp)
    800030f8:	f45e                	sd	s7,40(sp)
    800030fa:	f062                	sd	s8,32(sp)
    800030fc:	ec66                	sd	s9,24(sp)
    800030fe:	e86a                	sd	s10,16(sp)
    80003100:	e46e                	sd	s11,8(sp)
    80003102:	1880                	add	s0,sp,112
    80003104:	8b2a                	mv	s6,a0
    80003106:	8bae                	mv	s7,a1
    80003108:	8a32                	mv	s4,a2
    8000310a:	84b6                	mv	s1,a3
    8000310c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000310e:	9f35                	addw	a4,a4,a3
    return 0;
    80003110:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003112:	0ad76063          	bltu	a4,a3,800031b2 <readi+0xd2>
  if(off + n > ip->size)
    80003116:	00e7f463          	bgeu	a5,a4,8000311e <readi+0x3e>
    n = ip->size - off;
    8000311a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000311e:	0a0a8963          	beqz	s5,800031d0 <readi+0xf0>
    80003122:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003124:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003128:	5c7d                	li	s8,-1
    8000312a:	a82d                	j	80003164 <readi+0x84>
    8000312c:	020d1d93          	sll	s11,s10,0x20
    80003130:	020ddd93          	srl	s11,s11,0x20
    80003134:	05890613          	add	a2,s2,88
    80003138:	86ee                	mv	a3,s11
    8000313a:	963a                	add	a2,a2,a4
    8000313c:	85d2                	mv	a1,s4
    8000313e:	855e                	mv	a0,s7
    80003140:	fffff097          	auipc	ra,0xfffff
    80003144:	a08080e7          	jalr	-1528(ra) # 80001b48 <either_copyout>
    80003148:	05850d63          	beq	a0,s8,800031a2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000314c:	854a                	mv	a0,s2
    8000314e:	fffff097          	auipc	ra,0xfffff
    80003152:	5fe080e7          	jalr	1534(ra) # 8000274c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003156:	013d09bb          	addw	s3,s10,s3
    8000315a:	009d04bb          	addw	s1,s10,s1
    8000315e:	9a6e                	add	s4,s4,s11
    80003160:	0559f763          	bgeu	s3,s5,800031ae <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003164:	00a4d59b          	srlw	a1,s1,0xa
    80003168:	855a                	mv	a0,s6
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	8a4080e7          	jalr	-1884(ra) # 80002a0e <bmap>
    80003172:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003176:	cd85                	beqz	a1,800031ae <readi+0xce>
    bp = bread(ip->dev, addr);
    80003178:	000b2503          	lw	a0,0(s6)
    8000317c:	fffff097          	auipc	ra,0xfffff
    80003180:	4a0080e7          	jalr	1184(ra) # 8000261c <bread>
    80003184:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003186:	3ff4f713          	and	a4,s1,1023
    8000318a:	40ec87bb          	subw	a5,s9,a4
    8000318e:	413a86bb          	subw	a3,s5,s3
    80003192:	8d3e                	mv	s10,a5
    80003194:	2781                	sext.w	a5,a5
    80003196:	0006861b          	sext.w	a2,a3
    8000319a:	f8f679e3          	bgeu	a2,a5,8000312c <readi+0x4c>
    8000319e:	8d36                	mv	s10,a3
    800031a0:	b771                	j	8000312c <readi+0x4c>
      brelse(bp);
    800031a2:	854a                	mv	a0,s2
    800031a4:	fffff097          	auipc	ra,0xfffff
    800031a8:	5a8080e7          	jalr	1448(ra) # 8000274c <brelse>
      tot = -1;
    800031ac:	59fd                	li	s3,-1
  }
  return tot;
    800031ae:	0009851b          	sext.w	a0,s3
}
    800031b2:	70a6                	ld	ra,104(sp)
    800031b4:	7406                	ld	s0,96(sp)
    800031b6:	64e6                	ld	s1,88(sp)
    800031b8:	6946                	ld	s2,80(sp)
    800031ba:	69a6                	ld	s3,72(sp)
    800031bc:	6a06                	ld	s4,64(sp)
    800031be:	7ae2                	ld	s5,56(sp)
    800031c0:	7b42                	ld	s6,48(sp)
    800031c2:	7ba2                	ld	s7,40(sp)
    800031c4:	7c02                	ld	s8,32(sp)
    800031c6:	6ce2                	ld	s9,24(sp)
    800031c8:	6d42                	ld	s10,16(sp)
    800031ca:	6da2                	ld	s11,8(sp)
    800031cc:	6165                	add	sp,sp,112
    800031ce:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031d0:	89d6                	mv	s3,s5
    800031d2:	bff1                	j	800031ae <readi+0xce>
    return 0;
    800031d4:	4501                	li	a0,0
}
    800031d6:	8082                	ret

00000000800031d8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800031d8:	457c                	lw	a5,76(a0)
    800031da:	10d7e863          	bltu	a5,a3,800032ea <writei+0x112>
{
    800031de:	7159                	add	sp,sp,-112
    800031e0:	f486                	sd	ra,104(sp)
    800031e2:	f0a2                	sd	s0,96(sp)
    800031e4:	eca6                	sd	s1,88(sp)
    800031e6:	e8ca                	sd	s2,80(sp)
    800031e8:	e4ce                	sd	s3,72(sp)
    800031ea:	e0d2                	sd	s4,64(sp)
    800031ec:	fc56                	sd	s5,56(sp)
    800031ee:	f85a                	sd	s6,48(sp)
    800031f0:	f45e                	sd	s7,40(sp)
    800031f2:	f062                	sd	s8,32(sp)
    800031f4:	ec66                	sd	s9,24(sp)
    800031f6:	e86a                	sd	s10,16(sp)
    800031f8:	e46e                	sd	s11,8(sp)
    800031fa:	1880                	add	s0,sp,112
    800031fc:	8aaa                	mv	s5,a0
    800031fe:	8bae                	mv	s7,a1
    80003200:	8a32                	mv	s4,a2
    80003202:	8936                	mv	s2,a3
    80003204:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003206:	00e687bb          	addw	a5,a3,a4
    8000320a:	0ed7e263          	bltu	a5,a3,800032ee <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000320e:	00043737          	lui	a4,0x43
    80003212:	0ef76063          	bltu	a4,a5,800032f2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003216:	0c0b0863          	beqz	s6,800032e6 <writei+0x10e>
    8000321a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000321c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003220:	5c7d                	li	s8,-1
    80003222:	a091                	j	80003266 <writei+0x8e>
    80003224:	020d1d93          	sll	s11,s10,0x20
    80003228:	020ddd93          	srl	s11,s11,0x20
    8000322c:	05848513          	add	a0,s1,88
    80003230:	86ee                	mv	a3,s11
    80003232:	8652                	mv	a2,s4
    80003234:	85de                	mv	a1,s7
    80003236:	953a                	add	a0,a0,a4
    80003238:	fffff097          	auipc	ra,0xfffff
    8000323c:	966080e7          	jalr	-1690(ra) # 80001b9e <either_copyin>
    80003240:	07850263          	beq	a0,s8,800032a4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003244:	8526                	mv	a0,s1
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	75e080e7          	jalr	1886(ra) # 800039a4 <log_write>
    brelse(bp);
    8000324e:	8526                	mv	a0,s1
    80003250:	fffff097          	auipc	ra,0xfffff
    80003254:	4fc080e7          	jalr	1276(ra) # 8000274c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003258:	013d09bb          	addw	s3,s10,s3
    8000325c:	012d093b          	addw	s2,s10,s2
    80003260:	9a6e                	add	s4,s4,s11
    80003262:	0569f663          	bgeu	s3,s6,800032ae <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003266:	00a9559b          	srlw	a1,s2,0xa
    8000326a:	8556                	mv	a0,s5
    8000326c:	fffff097          	auipc	ra,0xfffff
    80003270:	7a2080e7          	jalr	1954(ra) # 80002a0e <bmap>
    80003274:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003278:	c99d                	beqz	a1,800032ae <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000327a:	000aa503          	lw	a0,0(s5)
    8000327e:	fffff097          	auipc	ra,0xfffff
    80003282:	39e080e7          	jalr	926(ra) # 8000261c <bread>
    80003286:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003288:	3ff97713          	and	a4,s2,1023
    8000328c:	40ec87bb          	subw	a5,s9,a4
    80003290:	413b06bb          	subw	a3,s6,s3
    80003294:	8d3e                	mv	s10,a5
    80003296:	2781                	sext.w	a5,a5
    80003298:	0006861b          	sext.w	a2,a3
    8000329c:	f8f674e3          	bgeu	a2,a5,80003224 <writei+0x4c>
    800032a0:	8d36                	mv	s10,a3
    800032a2:	b749                	j	80003224 <writei+0x4c>
      brelse(bp);
    800032a4:	8526                	mv	a0,s1
    800032a6:	fffff097          	auipc	ra,0xfffff
    800032aa:	4a6080e7          	jalr	1190(ra) # 8000274c <brelse>
  }

  if(off > ip->size)
    800032ae:	04caa783          	lw	a5,76(s5)
    800032b2:	0127f463          	bgeu	a5,s2,800032ba <writei+0xe2>
    ip->size = off;
    800032b6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032ba:	8556                	mv	a0,s5
    800032bc:	00000097          	auipc	ra,0x0
    800032c0:	aa4080e7          	jalr	-1372(ra) # 80002d60 <iupdate>

  return tot;
    800032c4:	0009851b          	sext.w	a0,s3
}
    800032c8:	70a6                	ld	ra,104(sp)
    800032ca:	7406                	ld	s0,96(sp)
    800032cc:	64e6                	ld	s1,88(sp)
    800032ce:	6946                	ld	s2,80(sp)
    800032d0:	69a6                	ld	s3,72(sp)
    800032d2:	6a06                	ld	s4,64(sp)
    800032d4:	7ae2                	ld	s5,56(sp)
    800032d6:	7b42                	ld	s6,48(sp)
    800032d8:	7ba2                	ld	s7,40(sp)
    800032da:	7c02                	ld	s8,32(sp)
    800032dc:	6ce2                	ld	s9,24(sp)
    800032de:	6d42                	ld	s10,16(sp)
    800032e0:	6da2                	ld	s11,8(sp)
    800032e2:	6165                	add	sp,sp,112
    800032e4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032e6:	89da                	mv	s3,s6
    800032e8:	bfc9                	j	800032ba <writei+0xe2>
    return -1;
    800032ea:	557d                	li	a0,-1
}
    800032ec:	8082                	ret
    return -1;
    800032ee:	557d                	li	a0,-1
    800032f0:	bfe1                	j	800032c8 <writei+0xf0>
    return -1;
    800032f2:	557d                	li	a0,-1
    800032f4:	bfd1                	j	800032c8 <writei+0xf0>

00000000800032f6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800032f6:	1141                	add	sp,sp,-16
    800032f8:	e406                	sd	ra,8(sp)
    800032fa:	e022                	sd	s0,0(sp)
    800032fc:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800032fe:	4639                	li	a2,14
    80003300:	ffffd097          	auipc	ra,0xffffd
    80003304:	0ce080e7          	jalr	206(ra) # 800003ce <strncmp>
}
    80003308:	60a2                	ld	ra,8(sp)
    8000330a:	6402                	ld	s0,0(sp)
    8000330c:	0141                	add	sp,sp,16
    8000330e:	8082                	ret

0000000080003310 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003310:	7139                	add	sp,sp,-64
    80003312:	fc06                	sd	ra,56(sp)
    80003314:	f822                	sd	s0,48(sp)
    80003316:	f426                	sd	s1,40(sp)
    80003318:	f04a                	sd	s2,32(sp)
    8000331a:	ec4e                	sd	s3,24(sp)
    8000331c:	e852                	sd	s4,16(sp)
    8000331e:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003320:	04451703          	lh	a4,68(a0)
    80003324:	4785                	li	a5,1
    80003326:	00f71a63          	bne	a4,a5,8000333a <dirlookup+0x2a>
    8000332a:	892a                	mv	s2,a0
    8000332c:	89ae                	mv	s3,a1
    8000332e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003330:	457c                	lw	a5,76(a0)
    80003332:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003334:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003336:	e79d                	bnez	a5,80003364 <dirlookup+0x54>
    80003338:	a8a5                	j	800033b0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000333a:	00005517          	auipc	a0,0x5
    8000333e:	27650513          	add	a0,a0,630 # 800085b0 <syscalls+0x1a0>
    80003342:	00003097          	auipc	ra,0x3
    80003346:	b44080e7          	jalr	-1212(ra) # 80005e86 <panic>
      panic("dirlookup read");
    8000334a:	00005517          	auipc	a0,0x5
    8000334e:	27e50513          	add	a0,a0,638 # 800085c8 <syscalls+0x1b8>
    80003352:	00003097          	auipc	ra,0x3
    80003356:	b34080e7          	jalr	-1228(ra) # 80005e86 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000335a:	24c1                	addw	s1,s1,16
    8000335c:	04c92783          	lw	a5,76(s2)
    80003360:	04f4f763          	bgeu	s1,a5,800033ae <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003364:	4741                	li	a4,16
    80003366:	86a6                	mv	a3,s1
    80003368:	fc040613          	add	a2,s0,-64
    8000336c:	4581                	li	a1,0
    8000336e:	854a                	mv	a0,s2
    80003370:	00000097          	auipc	ra,0x0
    80003374:	d70080e7          	jalr	-656(ra) # 800030e0 <readi>
    80003378:	47c1                	li	a5,16
    8000337a:	fcf518e3          	bne	a0,a5,8000334a <dirlookup+0x3a>
    if(de.inum == 0)
    8000337e:	fc045783          	lhu	a5,-64(s0)
    80003382:	dfe1                	beqz	a5,8000335a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003384:	fc240593          	add	a1,s0,-62
    80003388:	854e                	mv	a0,s3
    8000338a:	00000097          	auipc	ra,0x0
    8000338e:	f6c080e7          	jalr	-148(ra) # 800032f6 <namecmp>
    80003392:	f561                	bnez	a0,8000335a <dirlookup+0x4a>
      if(poff)
    80003394:	000a0463          	beqz	s4,8000339c <dirlookup+0x8c>
        *poff = off;
    80003398:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000339c:	fc045583          	lhu	a1,-64(s0)
    800033a0:	00092503          	lw	a0,0(s2)
    800033a4:	fffff097          	auipc	ra,0xfffff
    800033a8:	754080e7          	jalr	1876(ra) # 80002af8 <iget>
    800033ac:	a011                	j	800033b0 <dirlookup+0xa0>
  return 0;
    800033ae:	4501                	li	a0,0
}
    800033b0:	70e2                	ld	ra,56(sp)
    800033b2:	7442                	ld	s0,48(sp)
    800033b4:	74a2                	ld	s1,40(sp)
    800033b6:	7902                	ld	s2,32(sp)
    800033b8:	69e2                	ld	s3,24(sp)
    800033ba:	6a42                	ld	s4,16(sp)
    800033bc:	6121                	add	sp,sp,64
    800033be:	8082                	ret

00000000800033c0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800033c0:	711d                	add	sp,sp,-96
    800033c2:	ec86                	sd	ra,88(sp)
    800033c4:	e8a2                	sd	s0,80(sp)
    800033c6:	e4a6                	sd	s1,72(sp)
    800033c8:	e0ca                	sd	s2,64(sp)
    800033ca:	fc4e                	sd	s3,56(sp)
    800033cc:	f852                	sd	s4,48(sp)
    800033ce:	f456                	sd	s5,40(sp)
    800033d0:	f05a                	sd	s6,32(sp)
    800033d2:	ec5e                	sd	s7,24(sp)
    800033d4:	e862                	sd	s8,16(sp)
    800033d6:	e466                	sd	s9,8(sp)
    800033d8:	1080                	add	s0,sp,96
    800033da:	84aa                	mv	s1,a0
    800033dc:	8b2e                	mv	s6,a1
    800033de:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800033e0:	00054703          	lbu	a4,0(a0)
    800033e4:	02f00793          	li	a5,47
    800033e8:	02f70263          	beq	a4,a5,8000340c <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800033ec:	ffffe097          	auipc	ra,0xffffe
    800033f0:	ca8080e7          	jalr	-856(ra) # 80001094 <myproc>
    800033f4:	15053503          	ld	a0,336(a0)
    800033f8:	00000097          	auipc	ra,0x0
    800033fc:	9f6080e7          	jalr	-1546(ra) # 80002dee <idup>
    80003400:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003402:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003406:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003408:	4b85                	li	s7,1
    8000340a:	a875                	j	800034c6 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000340c:	4585                	li	a1,1
    8000340e:	4505                	li	a0,1
    80003410:	fffff097          	auipc	ra,0xfffff
    80003414:	6e8080e7          	jalr	1768(ra) # 80002af8 <iget>
    80003418:	8a2a                	mv	s4,a0
    8000341a:	b7e5                	j	80003402 <namex+0x42>
      iunlockput(ip);
    8000341c:	8552                	mv	a0,s4
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	c70080e7          	jalr	-912(ra) # 8000308e <iunlockput>
      return 0;
    80003426:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003428:	8552                	mv	a0,s4
    8000342a:	60e6                	ld	ra,88(sp)
    8000342c:	6446                	ld	s0,80(sp)
    8000342e:	64a6                	ld	s1,72(sp)
    80003430:	6906                	ld	s2,64(sp)
    80003432:	79e2                	ld	s3,56(sp)
    80003434:	7a42                	ld	s4,48(sp)
    80003436:	7aa2                	ld	s5,40(sp)
    80003438:	7b02                	ld	s6,32(sp)
    8000343a:	6be2                	ld	s7,24(sp)
    8000343c:	6c42                	ld	s8,16(sp)
    8000343e:	6ca2                	ld	s9,8(sp)
    80003440:	6125                	add	sp,sp,96
    80003442:	8082                	ret
      iunlock(ip);
    80003444:	8552                	mv	a0,s4
    80003446:	00000097          	auipc	ra,0x0
    8000344a:	aa8080e7          	jalr	-1368(ra) # 80002eee <iunlock>
      return ip;
    8000344e:	bfe9                	j	80003428 <namex+0x68>
      iunlockput(ip);
    80003450:	8552                	mv	a0,s4
    80003452:	00000097          	auipc	ra,0x0
    80003456:	c3c080e7          	jalr	-964(ra) # 8000308e <iunlockput>
      return 0;
    8000345a:	8a4e                	mv	s4,s3
    8000345c:	b7f1                	j	80003428 <namex+0x68>
  len = path - s;
    8000345e:	40998633          	sub	a2,s3,s1
    80003462:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003466:	099c5863          	bge	s8,s9,800034f6 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000346a:	4639                	li	a2,14
    8000346c:	85a6                	mv	a1,s1
    8000346e:	8556                	mv	a0,s5
    80003470:	ffffd097          	auipc	ra,0xffffd
    80003474:	eea080e7          	jalr	-278(ra) # 8000035a <memmove>
    80003478:	84ce                	mv	s1,s3
  while(*path == '/')
    8000347a:	0004c783          	lbu	a5,0(s1)
    8000347e:	01279763          	bne	a5,s2,8000348c <namex+0xcc>
    path++;
    80003482:	0485                	add	s1,s1,1
  while(*path == '/')
    80003484:	0004c783          	lbu	a5,0(s1)
    80003488:	ff278de3          	beq	a5,s2,80003482 <namex+0xc2>
    ilock(ip);
    8000348c:	8552                	mv	a0,s4
    8000348e:	00000097          	auipc	ra,0x0
    80003492:	99e080e7          	jalr	-1634(ra) # 80002e2c <ilock>
    if(ip->type != T_DIR){
    80003496:	044a1783          	lh	a5,68(s4)
    8000349a:	f97791e3          	bne	a5,s7,8000341c <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000349e:	000b0563          	beqz	s6,800034a8 <namex+0xe8>
    800034a2:	0004c783          	lbu	a5,0(s1)
    800034a6:	dfd9                	beqz	a5,80003444 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034a8:	4601                	li	a2,0
    800034aa:	85d6                	mv	a1,s5
    800034ac:	8552                	mv	a0,s4
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	e62080e7          	jalr	-414(ra) # 80003310 <dirlookup>
    800034b6:	89aa                	mv	s3,a0
    800034b8:	dd41                	beqz	a0,80003450 <namex+0x90>
    iunlockput(ip);
    800034ba:	8552                	mv	a0,s4
    800034bc:	00000097          	auipc	ra,0x0
    800034c0:	bd2080e7          	jalr	-1070(ra) # 8000308e <iunlockput>
    ip = next;
    800034c4:	8a4e                	mv	s4,s3
  while(*path == '/')
    800034c6:	0004c783          	lbu	a5,0(s1)
    800034ca:	01279763          	bne	a5,s2,800034d8 <namex+0x118>
    path++;
    800034ce:	0485                	add	s1,s1,1
  while(*path == '/')
    800034d0:	0004c783          	lbu	a5,0(s1)
    800034d4:	ff278de3          	beq	a5,s2,800034ce <namex+0x10e>
  if(*path == 0)
    800034d8:	cb9d                	beqz	a5,8000350e <namex+0x14e>
  while(*path != '/' && *path != 0)
    800034da:	0004c783          	lbu	a5,0(s1)
    800034de:	89a6                	mv	s3,s1
  len = path - s;
    800034e0:	4c81                	li	s9,0
    800034e2:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800034e4:	01278963          	beq	a5,s2,800034f6 <namex+0x136>
    800034e8:	dbbd                	beqz	a5,8000345e <namex+0x9e>
    path++;
    800034ea:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    800034ec:	0009c783          	lbu	a5,0(s3)
    800034f0:	ff279ce3          	bne	a5,s2,800034e8 <namex+0x128>
    800034f4:	b7ad                	j	8000345e <namex+0x9e>
    memmove(name, s, len);
    800034f6:	2601                	sext.w	a2,a2
    800034f8:	85a6                	mv	a1,s1
    800034fa:	8556                	mv	a0,s5
    800034fc:	ffffd097          	auipc	ra,0xffffd
    80003500:	e5e080e7          	jalr	-418(ra) # 8000035a <memmove>
    name[len] = 0;
    80003504:	9cd6                	add	s9,s9,s5
    80003506:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000350a:	84ce                	mv	s1,s3
    8000350c:	b7bd                	j	8000347a <namex+0xba>
  if(nameiparent){
    8000350e:	f00b0de3          	beqz	s6,80003428 <namex+0x68>
    iput(ip);
    80003512:	8552                	mv	a0,s4
    80003514:	00000097          	auipc	ra,0x0
    80003518:	ad2080e7          	jalr	-1326(ra) # 80002fe6 <iput>
    return 0;
    8000351c:	4a01                	li	s4,0
    8000351e:	b729                	j	80003428 <namex+0x68>

0000000080003520 <dirlink>:
{
    80003520:	7139                	add	sp,sp,-64
    80003522:	fc06                	sd	ra,56(sp)
    80003524:	f822                	sd	s0,48(sp)
    80003526:	f426                	sd	s1,40(sp)
    80003528:	f04a                	sd	s2,32(sp)
    8000352a:	ec4e                	sd	s3,24(sp)
    8000352c:	e852                	sd	s4,16(sp)
    8000352e:	0080                	add	s0,sp,64
    80003530:	892a                	mv	s2,a0
    80003532:	8a2e                	mv	s4,a1
    80003534:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003536:	4601                	li	a2,0
    80003538:	00000097          	auipc	ra,0x0
    8000353c:	dd8080e7          	jalr	-552(ra) # 80003310 <dirlookup>
    80003540:	e93d                	bnez	a0,800035b6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003542:	04c92483          	lw	s1,76(s2)
    80003546:	c49d                	beqz	s1,80003574 <dirlink+0x54>
    80003548:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000354a:	4741                	li	a4,16
    8000354c:	86a6                	mv	a3,s1
    8000354e:	fc040613          	add	a2,s0,-64
    80003552:	4581                	li	a1,0
    80003554:	854a                	mv	a0,s2
    80003556:	00000097          	auipc	ra,0x0
    8000355a:	b8a080e7          	jalr	-1142(ra) # 800030e0 <readi>
    8000355e:	47c1                	li	a5,16
    80003560:	06f51163          	bne	a0,a5,800035c2 <dirlink+0xa2>
    if(de.inum == 0)
    80003564:	fc045783          	lhu	a5,-64(s0)
    80003568:	c791                	beqz	a5,80003574 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000356a:	24c1                	addw	s1,s1,16
    8000356c:	04c92783          	lw	a5,76(s2)
    80003570:	fcf4ede3          	bltu	s1,a5,8000354a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003574:	4639                	li	a2,14
    80003576:	85d2                	mv	a1,s4
    80003578:	fc240513          	add	a0,s0,-62
    8000357c:	ffffd097          	auipc	ra,0xffffd
    80003580:	e8e080e7          	jalr	-370(ra) # 8000040a <strncpy>
  de.inum = inum;
    80003584:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003588:	4741                	li	a4,16
    8000358a:	86a6                	mv	a3,s1
    8000358c:	fc040613          	add	a2,s0,-64
    80003590:	4581                	li	a1,0
    80003592:	854a                	mv	a0,s2
    80003594:	00000097          	auipc	ra,0x0
    80003598:	c44080e7          	jalr	-956(ra) # 800031d8 <writei>
    8000359c:	1541                	add	a0,a0,-16
    8000359e:	00a03533          	snez	a0,a0
    800035a2:	40a00533          	neg	a0,a0
}
    800035a6:	70e2                	ld	ra,56(sp)
    800035a8:	7442                	ld	s0,48(sp)
    800035aa:	74a2                	ld	s1,40(sp)
    800035ac:	7902                	ld	s2,32(sp)
    800035ae:	69e2                	ld	s3,24(sp)
    800035b0:	6a42                	ld	s4,16(sp)
    800035b2:	6121                	add	sp,sp,64
    800035b4:	8082                	ret
    iput(ip);
    800035b6:	00000097          	auipc	ra,0x0
    800035ba:	a30080e7          	jalr	-1488(ra) # 80002fe6 <iput>
    return -1;
    800035be:	557d                	li	a0,-1
    800035c0:	b7dd                	j	800035a6 <dirlink+0x86>
      panic("dirlink read");
    800035c2:	00005517          	auipc	a0,0x5
    800035c6:	01650513          	add	a0,a0,22 # 800085d8 <syscalls+0x1c8>
    800035ca:	00003097          	auipc	ra,0x3
    800035ce:	8bc080e7          	jalr	-1860(ra) # 80005e86 <panic>

00000000800035d2 <namei>:

struct inode*
namei(char *path)
{
    800035d2:	1101                	add	sp,sp,-32
    800035d4:	ec06                	sd	ra,24(sp)
    800035d6:	e822                	sd	s0,16(sp)
    800035d8:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800035da:	fe040613          	add	a2,s0,-32
    800035de:	4581                	li	a1,0
    800035e0:	00000097          	auipc	ra,0x0
    800035e4:	de0080e7          	jalr	-544(ra) # 800033c0 <namex>
}
    800035e8:	60e2                	ld	ra,24(sp)
    800035ea:	6442                	ld	s0,16(sp)
    800035ec:	6105                	add	sp,sp,32
    800035ee:	8082                	ret

00000000800035f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800035f0:	1141                	add	sp,sp,-16
    800035f2:	e406                	sd	ra,8(sp)
    800035f4:	e022                	sd	s0,0(sp)
    800035f6:	0800                	add	s0,sp,16
    800035f8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035fa:	4585                	li	a1,1
    800035fc:	00000097          	auipc	ra,0x0
    80003600:	dc4080e7          	jalr	-572(ra) # 800033c0 <namex>
}
    80003604:	60a2                	ld	ra,8(sp)
    80003606:	6402                	ld	s0,0(sp)
    80003608:	0141                	add	sp,sp,16
    8000360a:	8082                	ret

000000008000360c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000360c:	1101                	add	sp,sp,-32
    8000360e:	ec06                	sd	ra,24(sp)
    80003610:	e822                	sd	s0,16(sp)
    80003612:	e426                	sd	s1,8(sp)
    80003614:	e04a                	sd	s2,0(sp)
    80003616:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003618:	00235917          	auipc	s2,0x235
    8000361c:	2f090913          	add	s2,s2,752 # 80238908 <log>
    80003620:	01892583          	lw	a1,24(s2)
    80003624:	02892503          	lw	a0,40(s2)
    80003628:	fffff097          	auipc	ra,0xfffff
    8000362c:	ff4080e7          	jalr	-12(ra) # 8000261c <bread>
    80003630:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003632:	02c92603          	lw	a2,44(s2)
    80003636:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003638:	00c05f63          	blez	a2,80003656 <write_head+0x4a>
    8000363c:	00235717          	auipc	a4,0x235
    80003640:	2fc70713          	add	a4,a4,764 # 80238938 <log+0x30>
    80003644:	87aa                	mv	a5,a0
    80003646:	060a                	sll	a2,a2,0x2
    80003648:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000364a:	4314                	lw	a3,0(a4)
    8000364c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000364e:	0711                	add	a4,a4,4
    80003650:	0791                	add	a5,a5,4
    80003652:	fec79ce3          	bne	a5,a2,8000364a <write_head+0x3e>
  }
  bwrite(buf);
    80003656:	8526                	mv	a0,s1
    80003658:	fffff097          	auipc	ra,0xfffff
    8000365c:	0b6080e7          	jalr	182(ra) # 8000270e <bwrite>
  brelse(buf);
    80003660:	8526                	mv	a0,s1
    80003662:	fffff097          	auipc	ra,0xfffff
    80003666:	0ea080e7          	jalr	234(ra) # 8000274c <brelse>
}
    8000366a:	60e2                	ld	ra,24(sp)
    8000366c:	6442                	ld	s0,16(sp)
    8000366e:	64a2                	ld	s1,8(sp)
    80003670:	6902                	ld	s2,0(sp)
    80003672:	6105                	add	sp,sp,32
    80003674:	8082                	ret

0000000080003676 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003676:	00235797          	auipc	a5,0x235
    8000367a:	2be7a783          	lw	a5,702(a5) # 80238934 <log+0x2c>
    8000367e:	0af05d63          	blez	a5,80003738 <install_trans+0xc2>
{
    80003682:	7139                	add	sp,sp,-64
    80003684:	fc06                	sd	ra,56(sp)
    80003686:	f822                	sd	s0,48(sp)
    80003688:	f426                	sd	s1,40(sp)
    8000368a:	f04a                	sd	s2,32(sp)
    8000368c:	ec4e                	sd	s3,24(sp)
    8000368e:	e852                	sd	s4,16(sp)
    80003690:	e456                	sd	s5,8(sp)
    80003692:	e05a                	sd	s6,0(sp)
    80003694:	0080                	add	s0,sp,64
    80003696:	8b2a                	mv	s6,a0
    80003698:	00235a97          	auipc	s5,0x235
    8000369c:	2a0a8a93          	add	s5,s5,672 # 80238938 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036a2:	00235997          	auipc	s3,0x235
    800036a6:	26698993          	add	s3,s3,614 # 80238908 <log>
    800036aa:	a00d                	j	800036cc <install_trans+0x56>
    brelse(lbuf);
    800036ac:	854a                	mv	a0,s2
    800036ae:	fffff097          	auipc	ra,0xfffff
    800036b2:	09e080e7          	jalr	158(ra) # 8000274c <brelse>
    brelse(dbuf);
    800036b6:	8526                	mv	a0,s1
    800036b8:	fffff097          	auipc	ra,0xfffff
    800036bc:	094080e7          	jalr	148(ra) # 8000274c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036c0:	2a05                	addw	s4,s4,1
    800036c2:	0a91                	add	s5,s5,4
    800036c4:	02c9a783          	lw	a5,44(s3)
    800036c8:	04fa5e63          	bge	s4,a5,80003724 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036cc:	0189a583          	lw	a1,24(s3)
    800036d0:	014585bb          	addw	a1,a1,s4
    800036d4:	2585                	addw	a1,a1,1
    800036d6:	0289a503          	lw	a0,40(s3)
    800036da:	fffff097          	auipc	ra,0xfffff
    800036de:	f42080e7          	jalr	-190(ra) # 8000261c <bread>
    800036e2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800036e4:	000aa583          	lw	a1,0(s5)
    800036e8:	0289a503          	lw	a0,40(s3)
    800036ec:	fffff097          	auipc	ra,0xfffff
    800036f0:	f30080e7          	jalr	-208(ra) # 8000261c <bread>
    800036f4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800036f6:	40000613          	li	a2,1024
    800036fa:	05890593          	add	a1,s2,88
    800036fe:	05850513          	add	a0,a0,88
    80003702:	ffffd097          	auipc	ra,0xffffd
    80003706:	c58080e7          	jalr	-936(ra) # 8000035a <memmove>
    bwrite(dbuf);  // write dst to disk
    8000370a:	8526                	mv	a0,s1
    8000370c:	fffff097          	auipc	ra,0xfffff
    80003710:	002080e7          	jalr	2(ra) # 8000270e <bwrite>
    if(recovering == 0)
    80003714:	f80b1ce3          	bnez	s6,800036ac <install_trans+0x36>
      bunpin(dbuf);
    80003718:	8526                	mv	a0,s1
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	10a080e7          	jalr	266(ra) # 80002824 <bunpin>
    80003722:	b769                	j	800036ac <install_trans+0x36>
}
    80003724:	70e2                	ld	ra,56(sp)
    80003726:	7442                	ld	s0,48(sp)
    80003728:	74a2                	ld	s1,40(sp)
    8000372a:	7902                	ld	s2,32(sp)
    8000372c:	69e2                	ld	s3,24(sp)
    8000372e:	6a42                	ld	s4,16(sp)
    80003730:	6aa2                	ld	s5,8(sp)
    80003732:	6b02                	ld	s6,0(sp)
    80003734:	6121                	add	sp,sp,64
    80003736:	8082                	ret
    80003738:	8082                	ret

000000008000373a <initlog>:
{
    8000373a:	7179                	add	sp,sp,-48
    8000373c:	f406                	sd	ra,40(sp)
    8000373e:	f022                	sd	s0,32(sp)
    80003740:	ec26                	sd	s1,24(sp)
    80003742:	e84a                	sd	s2,16(sp)
    80003744:	e44e                	sd	s3,8(sp)
    80003746:	1800                	add	s0,sp,48
    80003748:	892a                	mv	s2,a0
    8000374a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000374c:	00235497          	auipc	s1,0x235
    80003750:	1bc48493          	add	s1,s1,444 # 80238908 <log>
    80003754:	00005597          	auipc	a1,0x5
    80003758:	e9458593          	add	a1,a1,-364 # 800085e8 <syscalls+0x1d8>
    8000375c:	8526                	mv	a0,s1
    8000375e:	00003097          	auipc	ra,0x3
    80003762:	bd0080e7          	jalr	-1072(ra) # 8000632e <initlock>
  log.start = sb->logstart;
    80003766:	0149a583          	lw	a1,20(s3)
    8000376a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000376c:	0109a783          	lw	a5,16(s3)
    80003770:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003772:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003776:	854a                	mv	a0,s2
    80003778:	fffff097          	auipc	ra,0xfffff
    8000377c:	ea4080e7          	jalr	-348(ra) # 8000261c <bread>
  log.lh.n = lh->n;
    80003780:	4d30                	lw	a2,88(a0)
    80003782:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003784:	00c05f63          	blez	a2,800037a2 <initlog+0x68>
    80003788:	87aa                	mv	a5,a0
    8000378a:	00235717          	auipc	a4,0x235
    8000378e:	1ae70713          	add	a4,a4,430 # 80238938 <log+0x30>
    80003792:	060a                	sll	a2,a2,0x2
    80003794:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003796:	4ff4                	lw	a3,92(a5)
    80003798:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000379a:	0791                	add	a5,a5,4
    8000379c:	0711                	add	a4,a4,4
    8000379e:	fec79ce3          	bne	a5,a2,80003796 <initlog+0x5c>
  brelse(buf);
    800037a2:	fffff097          	auipc	ra,0xfffff
    800037a6:	faa080e7          	jalr	-86(ra) # 8000274c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800037aa:	4505                	li	a0,1
    800037ac:	00000097          	auipc	ra,0x0
    800037b0:	eca080e7          	jalr	-310(ra) # 80003676 <install_trans>
  log.lh.n = 0;
    800037b4:	00235797          	auipc	a5,0x235
    800037b8:	1807a023          	sw	zero,384(a5) # 80238934 <log+0x2c>
  write_head(); // clear the log
    800037bc:	00000097          	auipc	ra,0x0
    800037c0:	e50080e7          	jalr	-432(ra) # 8000360c <write_head>
}
    800037c4:	70a2                	ld	ra,40(sp)
    800037c6:	7402                	ld	s0,32(sp)
    800037c8:	64e2                	ld	s1,24(sp)
    800037ca:	6942                	ld	s2,16(sp)
    800037cc:	69a2                	ld	s3,8(sp)
    800037ce:	6145                	add	sp,sp,48
    800037d0:	8082                	ret

00000000800037d2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800037d2:	1101                	add	sp,sp,-32
    800037d4:	ec06                	sd	ra,24(sp)
    800037d6:	e822                	sd	s0,16(sp)
    800037d8:	e426                	sd	s1,8(sp)
    800037da:	e04a                	sd	s2,0(sp)
    800037dc:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800037de:	00235517          	auipc	a0,0x235
    800037e2:	12a50513          	add	a0,a0,298 # 80238908 <log>
    800037e6:	00003097          	auipc	ra,0x3
    800037ea:	bd8080e7          	jalr	-1064(ra) # 800063be <acquire>
  while(1){
    if(log.committing){
    800037ee:	00235497          	auipc	s1,0x235
    800037f2:	11a48493          	add	s1,s1,282 # 80238908 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037f6:	4979                	li	s2,30
    800037f8:	a039                	j	80003806 <begin_op+0x34>
      sleep(&log, &log.lock);
    800037fa:	85a6                	mv	a1,s1
    800037fc:	8526                	mv	a0,s1
    800037fe:	ffffe097          	auipc	ra,0xffffe
    80003802:	f42080e7          	jalr	-190(ra) # 80001740 <sleep>
    if(log.committing){
    80003806:	50dc                	lw	a5,36(s1)
    80003808:	fbed                	bnez	a5,800037fa <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000380a:	5098                	lw	a4,32(s1)
    8000380c:	2705                	addw	a4,a4,1
    8000380e:	0027179b          	sllw	a5,a4,0x2
    80003812:	9fb9                	addw	a5,a5,a4
    80003814:	0017979b          	sllw	a5,a5,0x1
    80003818:	54d4                	lw	a3,44(s1)
    8000381a:	9fb5                	addw	a5,a5,a3
    8000381c:	00f95963          	bge	s2,a5,8000382e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003820:	85a6                	mv	a1,s1
    80003822:	8526                	mv	a0,s1
    80003824:	ffffe097          	auipc	ra,0xffffe
    80003828:	f1c080e7          	jalr	-228(ra) # 80001740 <sleep>
    8000382c:	bfe9                	j	80003806 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000382e:	00235517          	auipc	a0,0x235
    80003832:	0da50513          	add	a0,a0,218 # 80238908 <log>
    80003836:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003838:	00003097          	auipc	ra,0x3
    8000383c:	c3a080e7          	jalr	-966(ra) # 80006472 <release>
      break;
    }
  }
}
    80003840:	60e2                	ld	ra,24(sp)
    80003842:	6442                	ld	s0,16(sp)
    80003844:	64a2                	ld	s1,8(sp)
    80003846:	6902                	ld	s2,0(sp)
    80003848:	6105                	add	sp,sp,32
    8000384a:	8082                	ret

000000008000384c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000384c:	7139                	add	sp,sp,-64
    8000384e:	fc06                	sd	ra,56(sp)
    80003850:	f822                	sd	s0,48(sp)
    80003852:	f426                	sd	s1,40(sp)
    80003854:	f04a                	sd	s2,32(sp)
    80003856:	ec4e                	sd	s3,24(sp)
    80003858:	e852                	sd	s4,16(sp)
    8000385a:	e456                	sd	s5,8(sp)
    8000385c:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000385e:	00235497          	auipc	s1,0x235
    80003862:	0aa48493          	add	s1,s1,170 # 80238908 <log>
    80003866:	8526                	mv	a0,s1
    80003868:	00003097          	auipc	ra,0x3
    8000386c:	b56080e7          	jalr	-1194(ra) # 800063be <acquire>
  log.outstanding -= 1;
    80003870:	509c                	lw	a5,32(s1)
    80003872:	37fd                	addw	a5,a5,-1
    80003874:	0007891b          	sext.w	s2,a5
    80003878:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000387a:	50dc                	lw	a5,36(s1)
    8000387c:	e7b9                	bnez	a5,800038ca <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000387e:	04091e63          	bnez	s2,800038da <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003882:	00235497          	auipc	s1,0x235
    80003886:	08648493          	add	s1,s1,134 # 80238908 <log>
    8000388a:	4785                	li	a5,1
    8000388c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000388e:	8526                	mv	a0,s1
    80003890:	00003097          	auipc	ra,0x3
    80003894:	be2080e7          	jalr	-1054(ra) # 80006472 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003898:	54dc                	lw	a5,44(s1)
    8000389a:	06f04763          	bgtz	a5,80003908 <end_op+0xbc>
    acquire(&log.lock);
    8000389e:	00235497          	auipc	s1,0x235
    800038a2:	06a48493          	add	s1,s1,106 # 80238908 <log>
    800038a6:	8526                	mv	a0,s1
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	b16080e7          	jalr	-1258(ra) # 800063be <acquire>
    log.committing = 0;
    800038b0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800038b4:	8526                	mv	a0,s1
    800038b6:	ffffe097          	auipc	ra,0xffffe
    800038ba:	eee080e7          	jalr	-274(ra) # 800017a4 <wakeup>
    release(&log.lock);
    800038be:	8526                	mv	a0,s1
    800038c0:	00003097          	auipc	ra,0x3
    800038c4:	bb2080e7          	jalr	-1102(ra) # 80006472 <release>
}
    800038c8:	a03d                	j	800038f6 <end_op+0xaa>
    panic("log.committing");
    800038ca:	00005517          	auipc	a0,0x5
    800038ce:	d2650513          	add	a0,a0,-730 # 800085f0 <syscalls+0x1e0>
    800038d2:	00002097          	auipc	ra,0x2
    800038d6:	5b4080e7          	jalr	1460(ra) # 80005e86 <panic>
    wakeup(&log);
    800038da:	00235497          	auipc	s1,0x235
    800038de:	02e48493          	add	s1,s1,46 # 80238908 <log>
    800038e2:	8526                	mv	a0,s1
    800038e4:	ffffe097          	auipc	ra,0xffffe
    800038e8:	ec0080e7          	jalr	-320(ra) # 800017a4 <wakeup>
  release(&log.lock);
    800038ec:	8526                	mv	a0,s1
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	b84080e7          	jalr	-1148(ra) # 80006472 <release>
}
    800038f6:	70e2                	ld	ra,56(sp)
    800038f8:	7442                	ld	s0,48(sp)
    800038fa:	74a2                	ld	s1,40(sp)
    800038fc:	7902                	ld	s2,32(sp)
    800038fe:	69e2                	ld	s3,24(sp)
    80003900:	6a42                	ld	s4,16(sp)
    80003902:	6aa2                	ld	s5,8(sp)
    80003904:	6121                	add	sp,sp,64
    80003906:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003908:	00235a97          	auipc	s5,0x235
    8000390c:	030a8a93          	add	s5,s5,48 # 80238938 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003910:	00235a17          	auipc	s4,0x235
    80003914:	ff8a0a13          	add	s4,s4,-8 # 80238908 <log>
    80003918:	018a2583          	lw	a1,24(s4)
    8000391c:	012585bb          	addw	a1,a1,s2
    80003920:	2585                	addw	a1,a1,1
    80003922:	028a2503          	lw	a0,40(s4)
    80003926:	fffff097          	auipc	ra,0xfffff
    8000392a:	cf6080e7          	jalr	-778(ra) # 8000261c <bread>
    8000392e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003930:	000aa583          	lw	a1,0(s5)
    80003934:	028a2503          	lw	a0,40(s4)
    80003938:	fffff097          	auipc	ra,0xfffff
    8000393c:	ce4080e7          	jalr	-796(ra) # 8000261c <bread>
    80003940:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003942:	40000613          	li	a2,1024
    80003946:	05850593          	add	a1,a0,88
    8000394a:	05848513          	add	a0,s1,88
    8000394e:	ffffd097          	auipc	ra,0xffffd
    80003952:	a0c080e7          	jalr	-1524(ra) # 8000035a <memmove>
    bwrite(to);  // write the log
    80003956:	8526                	mv	a0,s1
    80003958:	fffff097          	auipc	ra,0xfffff
    8000395c:	db6080e7          	jalr	-586(ra) # 8000270e <bwrite>
    brelse(from);
    80003960:	854e                	mv	a0,s3
    80003962:	fffff097          	auipc	ra,0xfffff
    80003966:	dea080e7          	jalr	-534(ra) # 8000274c <brelse>
    brelse(to);
    8000396a:	8526                	mv	a0,s1
    8000396c:	fffff097          	auipc	ra,0xfffff
    80003970:	de0080e7          	jalr	-544(ra) # 8000274c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003974:	2905                	addw	s2,s2,1
    80003976:	0a91                	add	s5,s5,4
    80003978:	02ca2783          	lw	a5,44(s4)
    8000397c:	f8f94ee3          	blt	s2,a5,80003918 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003980:	00000097          	auipc	ra,0x0
    80003984:	c8c080e7          	jalr	-884(ra) # 8000360c <write_head>
    install_trans(0); // Now install writes to home locations
    80003988:	4501                	li	a0,0
    8000398a:	00000097          	auipc	ra,0x0
    8000398e:	cec080e7          	jalr	-788(ra) # 80003676 <install_trans>
    log.lh.n = 0;
    80003992:	00235797          	auipc	a5,0x235
    80003996:	fa07a123          	sw	zero,-94(a5) # 80238934 <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000399a:	00000097          	auipc	ra,0x0
    8000399e:	c72080e7          	jalr	-910(ra) # 8000360c <write_head>
    800039a2:	bdf5                	j	8000389e <end_op+0x52>

00000000800039a4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800039a4:	1101                	add	sp,sp,-32
    800039a6:	ec06                	sd	ra,24(sp)
    800039a8:	e822                	sd	s0,16(sp)
    800039aa:	e426                	sd	s1,8(sp)
    800039ac:	e04a                	sd	s2,0(sp)
    800039ae:	1000                	add	s0,sp,32
    800039b0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039b2:	00235917          	auipc	s2,0x235
    800039b6:	f5690913          	add	s2,s2,-170 # 80238908 <log>
    800039ba:	854a                	mv	a0,s2
    800039bc:	00003097          	auipc	ra,0x3
    800039c0:	a02080e7          	jalr	-1534(ra) # 800063be <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039c4:	02c92603          	lw	a2,44(s2)
    800039c8:	47f5                	li	a5,29
    800039ca:	06c7c563          	blt	a5,a2,80003a34 <log_write+0x90>
    800039ce:	00235797          	auipc	a5,0x235
    800039d2:	f567a783          	lw	a5,-170(a5) # 80238924 <log+0x1c>
    800039d6:	37fd                	addw	a5,a5,-1
    800039d8:	04f65e63          	bge	a2,a5,80003a34 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800039dc:	00235797          	auipc	a5,0x235
    800039e0:	f4c7a783          	lw	a5,-180(a5) # 80238928 <log+0x20>
    800039e4:	06f05063          	blez	a5,80003a44 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800039e8:	4781                	li	a5,0
    800039ea:	06c05563          	blez	a2,80003a54 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039ee:	44cc                	lw	a1,12(s1)
    800039f0:	00235717          	auipc	a4,0x235
    800039f4:	f4870713          	add	a4,a4,-184 # 80238938 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800039f8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039fa:	4314                	lw	a3,0(a4)
    800039fc:	04b68c63          	beq	a3,a1,80003a54 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a00:	2785                	addw	a5,a5,1
    80003a02:	0711                	add	a4,a4,4
    80003a04:	fef61be3          	bne	a2,a5,800039fa <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a08:	0621                	add	a2,a2,8
    80003a0a:	060a                	sll	a2,a2,0x2
    80003a0c:	00235797          	auipc	a5,0x235
    80003a10:	efc78793          	add	a5,a5,-260 # 80238908 <log>
    80003a14:	97b2                	add	a5,a5,a2
    80003a16:	44d8                	lw	a4,12(s1)
    80003a18:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a1a:	8526                	mv	a0,s1
    80003a1c:	fffff097          	auipc	ra,0xfffff
    80003a20:	dcc080e7          	jalr	-564(ra) # 800027e8 <bpin>
    log.lh.n++;
    80003a24:	00235717          	auipc	a4,0x235
    80003a28:	ee470713          	add	a4,a4,-284 # 80238908 <log>
    80003a2c:	575c                	lw	a5,44(a4)
    80003a2e:	2785                	addw	a5,a5,1
    80003a30:	d75c                	sw	a5,44(a4)
    80003a32:	a82d                	j	80003a6c <log_write+0xc8>
    panic("too big a transaction");
    80003a34:	00005517          	auipc	a0,0x5
    80003a38:	bcc50513          	add	a0,a0,-1076 # 80008600 <syscalls+0x1f0>
    80003a3c:	00002097          	auipc	ra,0x2
    80003a40:	44a080e7          	jalr	1098(ra) # 80005e86 <panic>
    panic("log_write outside of trans");
    80003a44:	00005517          	auipc	a0,0x5
    80003a48:	bd450513          	add	a0,a0,-1068 # 80008618 <syscalls+0x208>
    80003a4c:	00002097          	auipc	ra,0x2
    80003a50:	43a080e7          	jalr	1082(ra) # 80005e86 <panic>
  log.lh.block[i] = b->blockno;
    80003a54:	00878693          	add	a3,a5,8
    80003a58:	068a                	sll	a3,a3,0x2
    80003a5a:	00235717          	auipc	a4,0x235
    80003a5e:	eae70713          	add	a4,a4,-338 # 80238908 <log>
    80003a62:	9736                	add	a4,a4,a3
    80003a64:	44d4                	lw	a3,12(s1)
    80003a66:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a68:	faf609e3          	beq	a2,a5,80003a1a <log_write+0x76>
  }
  release(&log.lock);
    80003a6c:	00235517          	auipc	a0,0x235
    80003a70:	e9c50513          	add	a0,a0,-356 # 80238908 <log>
    80003a74:	00003097          	auipc	ra,0x3
    80003a78:	9fe080e7          	jalr	-1538(ra) # 80006472 <release>
}
    80003a7c:	60e2                	ld	ra,24(sp)
    80003a7e:	6442                	ld	s0,16(sp)
    80003a80:	64a2                	ld	s1,8(sp)
    80003a82:	6902                	ld	s2,0(sp)
    80003a84:	6105                	add	sp,sp,32
    80003a86:	8082                	ret

0000000080003a88 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a88:	1101                	add	sp,sp,-32
    80003a8a:	ec06                	sd	ra,24(sp)
    80003a8c:	e822                	sd	s0,16(sp)
    80003a8e:	e426                	sd	s1,8(sp)
    80003a90:	e04a                	sd	s2,0(sp)
    80003a92:	1000                	add	s0,sp,32
    80003a94:	84aa                	mv	s1,a0
    80003a96:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a98:	00005597          	auipc	a1,0x5
    80003a9c:	ba058593          	add	a1,a1,-1120 # 80008638 <syscalls+0x228>
    80003aa0:	0521                	add	a0,a0,8
    80003aa2:	00003097          	auipc	ra,0x3
    80003aa6:	88c080e7          	jalr	-1908(ra) # 8000632e <initlock>
  lk->name = name;
    80003aaa:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003aae:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ab2:	0204a423          	sw	zero,40(s1)
}
    80003ab6:	60e2                	ld	ra,24(sp)
    80003ab8:	6442                	ld	s0,16(sp)
    80003aba:	64a2                	ld	s1,8(sp)
    80003abc:	6902                	ld	s2,0(sp)
    80003abe:	6105                	add	sp,sp,32
    80003ac0:	8082                	ret

0000000080003ac2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ac2:	1101                	add	sp,sp,-32
    80003ac4:	ec06                	sd	ra,24(sp)
    80003ac6:	e822                	sd	s0,16(sp)
    80003ac8:	e426                	sd	s1,8(sp)
    80003aca:	e04a                	sd	s2,0(sp)
    80003acc:	1000                	add	s0,sp,32
    80003ace:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ad0:	00850913          	add	s2,a0,8
    80003ad4:	854a                	mv	a0,s2
    80003ad6:	00003097          	auipc	ra,0x3
    80003ada:	8e8080e7          	jalr	-1816(ra) # 800063be <acquire>
  while (lk->locked) {
    80003ade:	409c                	lw	a5,0(s1)
    80003ae0:	cb89                	beqz	a5,80003af2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003ae2:	85ca                	mv	a1,s2
    80003ae4:	8526                	mv	a0,s1
    80003ae6:	ffffe097          	auipc	ra,0xffffe
    80003aea:	c5a080e7          	jalr	-934(ra) # 80001740 <sleep>
  while (lk->locked) {
    80003aee:	409c                	lw	a5,0(s1)
    80003af0:	fbed                	bnez	a5,80003ae2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003af2:	4785                	li	a5,1
    80003af4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003af6:	ffffd097          	auipc	ra,0xffffd
    80003afa:	59e080e7          	jalr	1438(ra) # 80001094 <myproc>
    80003afe:	591c                	lw	a5,48(a0)
    80003b00:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b02:	854a                	mv	a0,s2
    80003b04:	00003097          	auipc	ra,0x3
    80003b08:	96e080e7          	jalr	-1682(ra) # 80006472 <release>
}
    80003b0c:	60e2                	ld	ra,24(sp)
    80003b0e:	6442                	ld	s0,16(sp)
    80003b10:	64a2                	ld	s1,8(sp)
    80003b12:	6902                	ld	s2,0(sp)
    80003b14:	6105                	add	sp,sp,32
    80003b16:	8082                	ret

0000000080003b18 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b18:	1101                	add	sp,sp,-32
    80003b1a:	ec06                	sd	ra,24(sp)
    80003b1c:	e822                	sd	s0,16(sp)
    80003b1e:	e426                	sd	s1,8(sp)
    80003b20:	e04a                	sd	s2,0(sp)
    80003b22:	1000                	add	s0,sp,32
    80003b24:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b26:	00850913          	add	s2,a0,8
    80003b2a:	854a                	mv	a0,s2
    80003b2c:	00003097          	auipc	ra,0x3
    80003b30:	892080e7          	jalr	-1902(ra) # 800063be <acquire>
  lk->locked = 0;
    80003b34:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b38:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b3c:	8526                	mv	a0,s1
    80003b3e:	ffffe097          	auipc	ra,0xffffe
    80003b42:	c66080e7          	jalr	-922(ra) # 800017a4 <wakeup>
  release(&lk->lk);
    80003b46:	854a                	mv	a0,s2
    80003b48:	00003097          	auipc	ra,0x3
    80003b4c:	92a080e7          	jalr	-1750(ra) # 80006472 <release>
}
    80003b50:	60e2                	ld	ra,24(sp)
    80003b52:	6442                	ld	s0,16(sp)
    80003b54:	64a2                	ld	s1,8(sp)
    80003b56:	6902                	ld	s2,0(sp)
    80003b58:	6105                	add	sp,sp,32
    80003b5a:	8082                	ret

0000000080003b5c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b5c:	7179                	add	sp,sp,-48
    80003b5e:	f406                	sd	ra,40(sp)
    80003b60:	f022                	sd	s0,32(sp)
    80003b62:	ec26                	sd	s1,24(sp)
    80003b64:	e84a                	sd	s2,16(sp)
    80003b66:	e44e                	sd	s3,8(sp)
    80003b68:	1800                	add	s0,sp,48
    80003b6a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b6c:	00850913          	add	s2,a0,8
    80003b70:	854a                	mv	a0,s2
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	84c080e7          	jalr	-1972(ra) # 800063be <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b7a:	409c                	lw	a5,0(s1)
    80003b7c:	ef99                	bnez	a5,80003b9a <holdingsleep+0x3e>
    80003b7e:	4481                	li	s1,0
  release(&lk->lk);
    80003b80:	854a                	mv	a0,s2
    80003b82:	00003097          	auipc	ra,0x3
    80003b86:	8f0080e7          	jalr	-1808(ra) # 80006472 <release>
  return r;
}
    80003b8a:	8526                	mv	a0,s1
    80003b8c:	70a2                	ld	ra,40(sp)
    80003b8e:	7402                	ld	s0,32(sp)
    80003b90:	64e2                	ld	s1,24(sp)
    80003b92:	6942                	ld	s2,16(sp)
    80003b94:	69a2                	ld	s3,8(sp)
    80003b96:	6145                	add	sp,sp,48
    80003b98:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b9a:	0284a983          	lw	s3,40(s1)
    80003b9e:	ffffd097          	auipc	ra,0xffffd
    80003ba2:	4f6080e7          	jalr	1270(ra) # 80001094 <myproc>
    80003ba6:	5904                	lw	s1,48(a0)
    80003ba8:	413484b3          	sub	s1,s1,s3
    80003bac:	0014b493          	seqz	s1,s1
    80003bb0:	bfc1                	j	80003b80 <holdingsleep+0x24>

0000000080003bb2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003bb2:	1141                	add	sp,sp,-16
    80003bb4:	e406                	sd	ra,8(sp)
    80003bb6:	e022                	sd	s0,0(sp)
    80003bb8:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003bba:	00005597          	auipc	a1,0x5
    80003bbe:	a8e58593          	add	a1,a1,-1394 # 80008648 <syscalls+0x238>
    80003bc2:	00235517          	auipc	a0,0x235
    80003bc6:	e8e50513          	add	a0,a0,-370 # 80238a50 <ftable>
    80003bca:	00002097          	auipc	ra,0x2
    80003bce:	764080e7          	jalr	1892(ra) # 8000632e <initlock>
}
    80003bd2:	60a2                	ld	ra,8(sp)
    80003bd4:	6402                	ld	s0,0(sp)
    80003bd6:	0141                	add	sp,sp,16
    80003bd8:	8082                	ret

0000000080003bda <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003bda:	1101                	add	sp,sp,-32
    80003bdc:	ec06                	sd	ra,24(sp)
    80003bde:	e822                	sd	s0,16(sp)
    80003be0:	e426                	sd	s1,8(sp)
    80003be2:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003be4:	00235517          	auipc	a0,0x235
    80003be8:	e6c50513          	add	a0,a0,-404 # 80238a50 <ftable>
    80003bec:	00002097          	auipc	ra,0x2
    80003bf0:	7d2080e7          	jalr	2002(ra) # 800063be <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bf4:	00235497          	auipc	s1,0x235
    80003bf8:	e7448493          	add	s1,s1,-396 # 80238a68 <ftable+0x18>
    80003bfc:	00236717          	auipc	a4,0x236
    80003c00:	e0c70713          	add	a4,a4,-500 # 80239a08 <disk>
    if(f->ref == 0){
    80003c04:	40dc                	lw	a5,4(s1)
    80003c06:	cf99                	beqz	a5,80003c24 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c08:	02848493          	add	s1,s1,40
    80003c0c:	fee49ce3          	bne	s1,a4,80003c04 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c10:	00235517          	auipc	a0,0x235
    80003c14:	e4050513          	add	a0,a0,-448 # 80238a50 <ftable>
    80003c18:	00003097          	auipc	ra,0x3
    80003c1c:	85a080e7          	jalr	-1958(ra) # 80006472 <release>
  return 0;
    80003c20:	4481                	li	s1,0
    80003c22:	a819                	j	80003c38 <filealloc+0x5e>
      f->ref = 1;
    80003c24:	4785                	li	a5,1
    80003c26:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c28:	00235517          	auipc	a0,0x235
    80003c2c:	e2850513          	add	a0,a0,-472 # 80238a50 <ftable>
    80003c30:	00003097          	auipc	ra,0x3
    80003c34:	842080e7          	jalr	-1982(ra) # 80006472 <release>
}
    80003c38:	8526                	mv	a0,s1
    80003c3a:	60e2                	ld	ra,24(sp)
    80003c3c:	6442                	ld	s0,16(sp)
    80003c3e:	64a2                	ld	s1,8(sp)
    80003c40:	6105                	add	sp,sp,32
    80003c42:	8082                	ret

0000000080003c44 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c44:	1101                	add	sp,sp,-32
    80003c46:	ec06                	sd	ra,24(sp)
    80003c48:	e822                	sd	s0,16(sp)
    80003c4a:	e426                	sd	s1,8(sp)
    80003c4c:	1000                	add	s0,sp,32
    80003c4e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c50:	00235517          	auipc	a0,0x235
    80003c54:	e0050513          	add	a0,a0,-512 # 80238a50 <ftable>
    80003c58:	00002097          	auipc	ra,0x2
    80003c5c:	766080e7          	jalr	1894(ra) # 800063be <acquire>
  if(f->ref < 1)
    80003c60:	40dc                	lw	a5,4(s1)
    80003c62:	02f05263          	blez	a5,80003c86 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c66:	2785                	addw	a5,a5,1
    80003c68:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c6a:	00235517          	auipc	a0,0x235
    80003c6e:	de650513          	add	a0,a0,-538 # 80238a50 <ftable>
    80003c72:	00003097          	auipc	ra,0x3
    80003c76:	800080e7          	jalr	-2048(ra) # 80006472 <release>
  return f;
}
    80003c7a:	8526                	mv	a0,s1
    80003c7c:	60e2                	ld	ra,24(sp)
    80003c7e:	6442                	ld	s0,16(sp)
    80003c80:	64a2                	ld	s1,8(sp)
    80003c82:	6105                	add	sp,sp,32
    80003c84:	8082                	ret
    panic("filedup");
    80003c86:	00005517          	auipc	a0,0x5
    80003c8a:	9ca50513          	add	a0,a0,-1590 # 80008650 <syscalls+0x240>
    80003c8e:	00002097          	auipc	ra,0x2
    80003c92:	1f8080e7          	jalr	504(ra) # 80005e86 <panic>

0000000080003c96 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c96:	7139                	add	sp,sp,-64
    80003c98:	fc06                	sd	ra,56(sp)
    80003c9a:	f822                	sd	s0,48(sp)
    80003c9c:	f426                	sd	s1,40(sp)
    80003c9e:	f04a                	sd	s2,32(sp)
    80003ca0:	ec4e                	sd	s3,24(sp)
    80003ca2:	e852                	sd	s4,16(sp)
    80003ca4:	e456                	sd	s5,8(sp)
    80003ca6:	0080                	add	s0,sp,64
    80003ca8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003caa:	00235517          	auipc	a0,0x235
    80003cae:	da650513          	add	a0,a0,-602 # 80238a50 <ftable>
    80003cb2:	00002097          	auipc	ra,0x2
    80003cb6:	70c080e7          	jalr	1804(ra) # 800063be <acquire>
  if(f->ref < 1)
    80003cba:	40dc                	lw	a5,4(s1)
    80003cbc:	06f05163          	blez	a5,80003d1e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003cc0:	37fd                	addw	a5,a5,-1
    80003cc2:	0007871b          	sext.w	a4,a5
    80003cc6:	c0dc                	sw	a5,4(s1)
    80003cc8:	06e04363          	bgtz	a4,80003d2e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ccc:	0004a903          	lw	s2,0(s1)
    80003cd0:	0094ca83          	lbu	s5,9(s1)
    80003cd4:	0104ba03          	ld	s4,16(s1)
    80003cd8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003cdc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ce0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ce4:	00235517          	auipc	a0,0x235
    80003ce8:	d6c50513          	add	a0,a0,-660 # 80238a50 <ftable>
    80003cec:	00002097          	auipc	ra,0x2
    80003cf0:	786080e7          	jalr	1926(ra) # 80006472 <release>

  if(ff.type == FD_PIPE){
    80003cf4:	4785                	li	a5,1
    80003cf6:	04f90d63          	beq	s2,a5,80003d50 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003cfa:	3979                	addw	s2,s2,-2
    80003cfc:	4785                	li	a5,1
    80003cfe:	0527e063          	bltu	a5,s2,80003d3e <fileclose+0xa8>
    begin_op();
    80003d02:	00000097          	auipc	ra,0x0
    80003d06:	ad0080e7          	jalr	-1328(ra) # 800037d2 <begin_op>
    iput(ff.ip);
    80003d0a:	854e                	mv	a0,s3
    80003d0c:	fffff097          	auipc	ra,0xfffff
    80003d10:	2da080e7          	jalr	730(ra) # 80002fe6 <iput>
    end_op();
    80003d14:	00000097          	auipc	ra,0x0
    80003d18:	b38080e7          	jalr	-1224(ra) # 8000384c <end_op>
    80003d1c:	a00d                	j	80003d3e <fileclose+0xa8>
    panic("fileclose");
    80003d1e:	00005517          	auipc	a0,0x5
    80003d22:	93a50513          	add	a0,a0,-1734 # 80008658 <syscalls+0x248>
    80003d26:	00002097          	auipc	ra,0x2
    80003d2a:	160080e7          	jalr	352(ra) # 80005e86 <panic>
    release(&ftable.lock);
    80003d2e:	00235517          	auipc	a0,0x235
    80003d32:	d2250513          	add	a0,a0,-734 # 80238a50 <ftable>
    80003d36:	00002097          	auipc	ra,0x2
    80003d3a:	73c080e7          	jalr	1852(ra) # 80006472 <release>
  }
}
    80003d3e:	70e2                	ld	ra,56(sp)
    80003d40:	7442                	ld	s0,48(sp)
    80003d42:	74a2                	ld	s1,40(sp)
    80003d44:	7902                	ld	s2,32(sp)
    80003d46:	69e2                	ld	s3,24(sp)
    80003d48:	6a42                	ld	s4,16(sp)
    80003d4a:	6aa2                	ld	s5,8(sp)
    80003d4c:	6121                	add	sp,sp,64
    80003d4e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d50:	85d6                	mv	a1,s5
    80003d52:	8552                	mv	a0,s4
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	348080e7          	jalr	840(ra) # 8000409c <pipeclose>
    80003d5c:	b7cd                	j	80003d3e <fileclose+0xa8>

0000000080003d5e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d5e:	715d                	add	sp,sp,-80
    80003d60:	e486                	sd	ra,72(sp)
    80003d62:	e0a2                	sd	s0,64(sp)
    80003d64:	fc26                	sd	s1,56(sp)
    80003d66:	f84a                	sd	s2,48(sp)
    80003d68:	f44e                	sd	s3,40(sp)
    80003d6a:	0880                	add	s0,sp,80
    80003d6c:	84aa                	mv	s1,a0
    80003d6e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d70:	ffffd097          	auipc	ra,0xffffd
    80003d74:	324080e7          	jalr	804(ra) # 80001094 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d78:	409c                	lw	a5,0(s1)
    80003d7a:	37f9                	addw	a5,a5,-2
    80003d7c:	4705                	li	a4,1
    80003d7e:	04f76763          	bltu	a4,a5,80003dcc <filestat+0x6e>
    80003d82:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d84:	6c88                	ld	a0,24(s1)
    80003d86:	fffff097          	auipc	ra,0xfffff
    80003d8a:	0a6080e7          	jalr	166(ra) # 80002e2c <ilock>
    stati(f->ip, &st);
    80003d8e:	fb840593          	add	a1,s0,-72
    80003d92:	6c88                	ld	a0,24(s1)
    80003d94:	fffff097          	auipc	ra,0xfffff
    80003d98:	322080e7          	jalr	802(ra) # 800030b6 <stati>
    iunlock(f->ip);
    80003d9c:	6c88                	ld	a0,24(s1)
    80003d9e:	fffff097          	auipc	ra,0xfffff
    80003da2:	150080e7          	jalr	336(ra) # 80002eee <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003da6:	46e1                	li	a3,24
    80003da8:	fb840613          	add	a2,s0,-72
    80003dac:	85ce                	mv	a1,s3
    80003dae:	05093503          	ld	a0,80(s2)
    80003db2:	ffffd097          	auipc	ra,0xffffd
    80003db6:	eec080e7          	jalr	-276(ra) # 80000c9e <copyout>
    80003dba:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003dbe:	60a6                	ld	ra,72(sp)
    80003dc0:	6406                	ld	s0,64(sp)
    80003dc2:	74e2                	ld	s1,56(sp)
    80003dc4:	7942                	ld	s2,48(sp)
    80003dc6:	79a2                	ld	s3,40(sp)
    80003dc8:	6161                	add	sp,sp,80
    80003dca:	8082                	ret
  return -1;
    80003dcc:	557d                	li	a0,-1
    80003dce:	bfc5                	j	80003dbe <filestat+0x60>

0000000080003dd0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003dd0:	7179                	add	sp,sp,-48
    80003dd2:	f406                	sd	ra,40(sp)
    80003dd4:	f022                	sd	s0,32(sp)
    80003dd6:	ec26                	sd	s1,24(sp)
    80003dd8:	e84a                	sd	s2,16(sp)
    80003dda:	e44e                	sd	s3,8(sp)
    80003ddc:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003dde:	00854783          	lbu	a5,8(a0)
    80003de2:	c3d5                	beqz	a5,80003e86 <fileread+0xb6>
    80003de4:	84aa                	mv	s1,a0
    80003de6:	89ae                	mv	s3,a1
    80003de8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dea:	411c                	lw	a5,0(a0)
    80003dec:	4705                	li	a4,1
    80003dee:	04e78963          	beq	a5,a4,80003e40 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003df2:	470d                	li	a4,3
    80003df4:	04e78d63          	beq	a5,a4,80003e4e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003df8:	4709                	li	a4,2
    80003dfa:	06e79e63          	bne	a5,a4,80003e76 <fileread+0xa6>
    ilock(f->ip);
    80003dfe:	6d08                	ld	a0,24(a0)
    80003e00:	fffff097          	auipc	ra,0xfffff
    80003e04:	02c080e7          	jalr	44(ra) # 80002e2c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e08:	874a                	mv	a4,s2
    80003e0a:	5094                	lw	a3,32(s1)
    80003e0c:	864e                	mv	a2,s3
    80003e0e:	4585                	li	a1,1
    80003e10:	6c88                	ld	a0,24(s1)
    80003e12:	fffff097          	auipc	ra,0xfffff
    80003e16:	2ce080e7          	jalr	718(ra) # 800030e0 <readi>
    80003e1a:	892a                	mv	s2,a0
    80003e1c:	00a05563          	blez	a0,80003e26 <fileread+0x56>
      f->off += r;
    80003e20:	509c                	lw	a5,32(s1)
    80003e22:	9fa9                	addw	a5,a5,a0
    80003e24:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e26:	6c88                	ld	a0,24(s1)
    80003e28:	fffff097          	auipc	ra,0xfffff
    80003e2c:	0c6080e7          	jalr	198(ra) # 80002eee <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e30:	854a                	mv	a0,s2
    80003e32:	70a2                	ld	ra,40(sp)
    80003e34:	7402                	ld	s0,32(sp)
    80003e36:	64e2                	ld	s1,24(sp)
    80003e38:	6942                	ld	s2,16(sp)
    80003e3a:	69a2                	ld	s3,8(sp)
    80003e3c:	6145                	add	sp,sp,48
    80003e3e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e40:	6908                	ld	a0,16(a0)
    80003e42:	00000097          	auipc	ra,0x0
    80003e46:	3c2080e7          	jalr	962(ra) # 80004204 <piperead>
    80003e4a:	892a                	mv	s2,a0
    80003e4c:	b7d5                	j	80003e30 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e4e:	02451783          	lh	a5,36(a0)
    80003e52:	03079693          	sll	a3,a5,0x30
    80003e56:	92c1                	srl	a3,a3,0x30
    80003e58:	4725                	li	a4,9
    80003e5a:	02d76863          	bltu	a4,a3,80003e8a <fileread+0xba>
    80003e5e:	0792                	sll	a5,a5,0x4
    80003e60:	00235717          	auipc	a4,0x235
    80003e64:	b5070713          	add	a4,a4,-1200 # 802389b0 <devsw>
    80003e68:	97ba                	add	a5,a5,a4
    80003e6a:	639c                	ld	a5,0(a5)
    80003e6c:	c38d                	beqz	a5,80003e8e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e6e:	4505                	li	a0,1
    80003e70:	9782                	jalr	a5
    80003e72:	892a                	mv	s2,a0
    80003e74:	bf75                	j	80003e30 <fileread+0x60>
    panic("fileread");
    80003e76:	00004517          	auipc	a0,0x4
    80003e7a:	7f250513          	add	a0,a0,2034 # 80008668 <syscalls+0x258>
    80003e7e:	00002097          	auipc	ra,0x2
    80003e82:	008080e7          	jalr	8(ra) # 80005e86 <panic>
    return -1;
    80003e86:	597d                	li	s2,-1
    80003e88:	b765                	j	80003e30 <fileread+0x60>
      return -1;
    80003e8a:	597d                	li	s2,-1
    80003e8c:	b755                	j	80003e30 <fileread+0x60>
    80003e8e:	597d                	li	s2,-1
    80003e90:	b745                	j	80003e30 <fileread+0x60>

0000000080003e92 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003e92:	00954783          	lbu	a5,9(a0)
    80003e96:	10078e63          	beqz	a5,80003fb2 <filewrite+0x120>
{
    80003e9a:	715d                	add	sp,sp,-80
    80003e9c:	e486                	sd	ra,72(sp)
    80003e9e:	e0a2                	sd	s0,64(sp)
    80003ea0:	fc26                	sd	s1,56(sp)
    80003ea2:	f84a                	sd	s2,48(sp)
    80003ea4:	f44e                	sd	s3,40(sp)
    80003ea6:	f052                	sd	s4,32(sp)
    80003ea8:	ec56                	sd	s5,24(sp)
    80003eaa:	e85a                	sd	s6,16(sp)
    80003eac:	e45e                	sd	s7,8(sp)
    80003eae:	e062                	sd	s8,0(sp)
    80003eb0:	0880                	add	s0,sp,80
    80003eb2:	892a                	mv	s2,a0
    80003eb4:	8b2e                	mv	s6,a1
    80003eb6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003eb8:	411c                	lw	a5,0(a0)
    80003eba:	4705                	li	a4,1
    80003ebc:	02e78263          	beq	a5,a4,80003ee0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ec0:	470d                	li	a4,3
    80003ec2:	02e78563          	beq	a5,a4,80003eec <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ec6:	4709                	li	a4,2
    80003ec8:	0ce79d63          	bne	a5,a4,80003fa2 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ecc:	0ac05b63          	blez	a2,80003f82 <filewrite+0xf0>
    int i = 0;
    80003ed0:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003ed2:	6b85                	lui	s7,0x1
    80003ed4:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ed8:	6c05                	lui	s8,0x1
    80003eda:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003ede:	a851                	j	80003f72 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003ee0:	6908                	ld	a0,16(a0)
    80003ee2:	00000097          	auipc	ra,0x0
    80003ee6:	22a080e7          	jalr	554(ra) # 8000410c <pipewrite>
    80003eea:	a045                	j	80003f8a <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003eec:	02451783          	lh	a5,36(a0)
    80003ef0:	03079693          	sll	a3,a5,0x30
    80003ef4:	92c1                	srl	a3,a3,0x30
    80003ef6:	4725                	li	a4,9
    80003ef8:	0ad76f63          	bltu	a4,a3,80003fb6 <filewrite+0x124>
    80003efc:	0792                	sll	a5,a5,0x4
    80003efe:	00235717          	auipc	a4,0x235
    80003f02:	ab270713          	add	a4,a4,-1358 # 802389b0 <devsw>
    80003f06:	97ba                	add	a5,a5,a4
    80003f08:	679c                	ld	a5,8(a5)
    80003f0a:	cbc5                	beqz	a5,80003fba <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003f0c:	4505                	li	a0,1
    80003f0e:	9782                	jalr	a5
    80003f10:	a8ad                	j	80003f8a <filewrite+0xf8>
      if(n1 > max)
    80003f12:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f16:	00000097          	auipc	ra,0x0
    80003f1a:	8bc080e7          	jalr	-1860(ra) # 800037d2 <begin_op>
      ilock(f->ip);
    80003f1e:	01893503          	ld	a0,24(s2)
    80003f22:	fffff097          	auipc	ra,0xfffff
    80003f26:	f0a080e7          	jalr	-246(ra) # 80002e2c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f2a:	8756                	mv	a4,s5
    80003f2c:	02092683          	lw	a3,32(s2)
    80003f30:	01698633          	add	a2,s3,s6
    80003f34:	4585                	li	a1,1
    80003f36:	01893503          	ld	a0,24(s2)
    80003f3a:	fffff097          	auipc	ra,0xfffff
    80003f3e:	29e080e7          	jalr	670(ra) # 800031d8 <writei>
    80003f42:	84aa                	mv	s1,a0
    80003f44:	00a05763          	blez	a0,80003f52 <filewrite+0xc0>
        f->off += r;
    80003f48:	02092783          	lw	a5,32(s2)
    80003f4c:	9fa9                	addw	a5,a5,a0
    80003f4e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f52:	01893503          	ld	a0,24(s2)
    80003f56:	fffff097          	auipc	ra,0xfffff
    80003f5a:	f98080e7          	jalr	-104(ra) # 80002eee <iunlock>
      end_op();
    80003f5e:	00000097          	auipc	ra,0x0
    80003f62:	8ee080e7          	jalr	-1810(ra) # 8000384c <end_op>

      if(r != n1){
    80003f66:	009a9f63          	bne	s5,s1,80003f84 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003f6a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f6e:	0149db63          	bge	s3,s4,80003f84 <filewrite+0xf2>
      int n1 = n - i;
    80003f72:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003f76:	0004879b          	sext.w	a5,s1
    80003f7a:	f8fbdce3          	bge	s7,a5,80003f12 <filewrite+0x80>
    80003f7e:	84e2                	mv	s1,s8
    80003f80:	bf49                	j	80003f12 <filewrite+0x80>
    int i = 0;
    80003f82:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f84:	033a1d63          	bne	s4,s3,80003fbe <filewrite+0x12c>
    80003f88:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f8a:	60a6                	ld	ra,72(sp)
    80003f8c:	6406                	ld	s0,64(sp)
    80003f8e:	74e2                	ld	s1,56(sp)
    80003f90:	7942                	ld	s2,48(sp)
    80003f92:	79a2                	ld	s3,40(sp)
    80003f94:	7a02                	ld	s4,32(sp)
    80003f96:	6ae2                	ld	s5,24(sp)
    80003f98:	6b42                	ld	s6,16(sp)
    80003f9a:	6ba2                	ld	s7,8(sp)
    80003f9c:	6c02                	ld	s8,0(sp)
    80003f9e:	6161                	add	sp,sp,80
    80003fa0:	8082                	ret
    panic("filewrite");
    80003fa2:	00004517          	auipc	a0,0x4
    80003fa6:	6d650513          	add	a0,a0,1750 # 80008678 <syscalls+0x268>
    80003faa:	00002097          	auipc	ra,0x2
    80003fae:	edc080e7          	jalr	-292(ra) # 80005e86 <panic>
    return -1;
    80003fb2:	557d                	li	a0,-1
}
    80003fb4:	8082                	ret
      return -1;
    80003fb6:	557d                	li	a0,-1
    80003fb8:	bfc9                	j	80003f8a <filewrite+0xf8>
    80003fba:	557d                	li	a0,-1
    80003fbc:	b7f9                	j	80003f8a <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003fbe:	557d                	li	a0,-1
    80003fc0:	b7e9                	j	80003f8a <filewrite+0xf8>

0000000080003fc2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fc2:	7179                	add	sp,sp,-48
    80003fc4:	f406                	sd	ra,40(sp)
    80003fc6:	f022                	sd	s0,32(sp)
    80003fc8:	ec26                	sd	s1,24(sp)
    80003fca:	e84a                	sd	s2,16(sp)
    80003fcc:	e44e                	sd	s3,8(sp)
    80003fce:	e052                	sd	s4,0(sp)
    80003fd0:	1800                	add	s0,sp,48
    80003fd2:	84aa                	mv	s1,a0
    80003fd4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fd6:	0005b023          	sd	zero,0(a1)
    80003fda:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fde:	00000097          	auipc	ra,0x0
    80003fe2:	bfc080e7          	jalr	-1028(ra) # 80003bda <filealloc>
    80003fe6:	e088                	sd	a0,0(s1)
    80003fe8:	c551                	beqz	a0,80004074 <pipealloc+0xb2>
    80003fea:	00000097          	auipc	ra,0x0
    80003fee:	bf0080e7          	jalr	-1040(ra) # 80003bda <filealloc>
    80003ff2:	00aa3023          	sd	a0,0(s4)
    80003ff6:	c92d                	beqz	a0,80004068 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ff8:	ffffc097          	auipc	ra,0xffffc
    80003ffc:	024080e7          	jalr	36(ra) # 8000001c <kalloc>
    80004000:	892a                	mv	s2,a0
    80004002:	c125                	beqz	a0,80004062 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004004:	4985                	li	s3,1
    80004006:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000400a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000400e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004012:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004016:	00004597          	auipc	a1,0x4
    8000401a:	67258593          	add	a1,a1,1650 # 80008688 <syscalls+0x278>
    8000401e:	00002097          	auipc	ra,0x2
    80004022:	310080e7          	jalr	784(ra) # 8000632e <initlock>
  (*f0)->type = FD_PIPE;
    80004026:	609c                	ld	a5,0(s1)
    80004028:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000402c:	609c                	ld	a5,0(s1)
    8000402e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004032:	609c                	ld	a5,0(s1)
    80004034:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004038:	609c                	ld	a5,0(s1)
    8000403a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000403e:	000a3783          	ld	a5,0(s4)
    80004042:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004046:	000a3783          	ld	a5,0(s4)
    8000404a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000404e:	000a3783          	ld	a5,0(s4)
    80004052:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004056:	000a3783          	ld	a5,0(s4)
    8000405a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000405e:	4501                	li	a0,0
    80004060:	a025                	j	80004088 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004062:	6088                	ld	a0,0(s1)
    80004064:	e501                	bnez	a0,8000406c <pipealloc+0xaa>
    80004066:	a039                	j	80004074 <pipealloc+0xb2>
    80004068:	6088                	ld	a0,0(s1)
    8000406a:	c51d                	beqz	a0,80004098 <pipealloc+0xd6>
    fileclose(*f0);
    8000406c:	00000097          	auipc	ra,0x0
    80004070:	c2a080e7          	jalr	-982(ra) # 80003c96 <fileclose>
  if(*f1)
    80004074:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004078:	557d                	li	a0,-1
  if(*f1)
    8000407a:	c799                	beqz	a5,80004088 <pipealloc+0xc6>
    fileclose(*f1);
    8000407c:	853e                	mv	a0,a5
    8000407e:	00000097          	auipc	ra,0x0
    80004082:	c18080e7          	jalr	-1000(ra) # 80003c96 <fileclose>
  return -1;
    80004086:	557d                	li	a0,-1
}
    80004088:	70a2                	ld	ra,40(sp)
    8000408a:	7402                	ld	s0,32(sp)
    8000408c:	64e2                	ld	s1,24(sp)
    8000408e:	6942                	ld	s2,16(sp)
    80004090:	69a2                	ld	s3,8(sp)
    80004092:	6a02                	ld	s4,0(sp)
    80004094:	6145                	add	sp,sp,48
    80004096:	8082                	ret
  return -1;
    80004098:	557d                	li	a0,-1
    8000409a:	b7fd                	j	80004088 <pipealloc+0xc6>

000000008000409c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000409c:	1101                	add	sp,sp,-32
    8000409e:	ec06                	sd	ra,24(sp)
    800040a0:	e822                	sd	s0,16(sp)
    800040a2:	e426                	sd	s1,8(sp)
    800040a4:	e04a                	sd	s2,0(sp)
    800040a6:	1000                	add	s0,sp,32
    800040a8:	84aa                	mv	s1,a0
    800040aa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800040ac:	00002097          	auipc	ra,0x2
    800040b0:	312080e7          	jalr	786(ra) # 800063be <acquire>
  if(writable){
    800040b4:	02090d63          	beqz	s2,800040ee <pipeclose+0x52>
    pi->writeopen = 0;
    800040b8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040bc:	21848513          	add	a0,s1,536
    800040c0:	ffffd097          	auipc	ra,0xffffd
    800040c4:	6e4080e7          	jalr	1764(ra) # 800017a4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040c8:	2204b783          	ld	a5,544(s1)
    800040cc:	eb95                	bnez	a5,80004100 <pipeclose+0x64>
    release(&pi->lock);
    800040ce:	8526                	mv	a0,s1
    800040d0:	00002097          	auipc	ra,0x2
    800040d4:	3a2080e7          	jalr	930(ra) # 80006472 <release>
    kfree((char*)pi);
    800040d8:	8526                	mv	a0,s1
    800040da:	ffffc097          	auipc	ra,0xffffc
    800040de:	0c4080e7          	jalr	196(ra) # 8000019e <kfree>
  } else
    release(&pi->lock);
}
    800040e2:	60e2                	ld	ra,24(sp)
    800040e4:	6442                	ld	s0,16(sp)
    800040e6:	64a2                	ld	s1,8(sp)
    800040e8:	6902                	ld	s2,0(sp)
    800040ea:	6105                	add	sp,sp,32
    800040ec:	8082                	ret
    pi->readopen = 0;
    800040ee:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040f2:	21c48513          	add	a0,s1,540
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	6ae080e7          	jalr	1710(ra) # 800017a4 <wakeup>
    800040fe:	b7e9                	j	800040c8 <pipeclose+0x2c>
    release(&pi->lock);
    80004100:	8526                	mv	a0,s1
    80004102:	00002097          	auipc	ra,0x2
    80004106:	370080e7          	jalr	880(ra) # 80006472 <release>
}
    8000410a:	bfe1                	j	800040e2 <pipeclose+0x46>

000000008000410c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000410c:	711d                	add	sp,sp,-96
    8000410e:	ec86                	sd	ra,88(sp)
    80004110:	e8a2                	sd	s0,80(sp)
    80004112:	e4a6                	sd	s1,72(sp)
    80004114:	e0ca                	sd	s2,64(sp)
    80004116:	fc4e                	sd	s3,56(sp)
    80004118:	f852                	sd	s4,48(sp)
    8000411a:	f456                	sd	s5,40(sp)
    8000411c:	f05a                	sd	s6,32(sp)
    8000411e:	ec5e                	sd	s7,24(sp)
    80004120:	e862                	sd	s8,16(sp)
    80004122:	1080                	add	s0,sp,96
    80004124:	84aa                	mv	s1,a0
    80004126:	8aae                	mv	s5,a1
    80004128:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000412a:	ffffd097          	auipc	ra,0xffffd
    8000412e:	f6a080e7          	jalr	-150(ra) # 80001094 <myproc>
    80004132:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004134:	8526                	mv	a0,s1
    80004136:	00002097          	auipc	ra,0x2
    8000413a:	288080e7          	jalr	648(ra) # 800063be <acquire>
  while(i < n){
    8000413e:	0b405663          	blez	s4,800041ea <pipewrite+0xde>
  int i = 0;
    80004142:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004144:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004146:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000414a:	21c48b93          	add	s7,s1,540
    8000414e:	a089                	j	80004190 <pipewrite+0x84>
      release(&pi->lock);
    80004150:	8526                	mv	a0,s1
    80004152:	00002097          	auipc	ra,0x2
    80004156:	320080e7          	jalr	800(ra) # 80006472 <release>
      return -1;
    8000415a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000415c:	854a                	mv	a0,s2
    8000415e:	60e6                	ld	ra,88(sp)
    80004160:	6446                	ld	s0,80(sp)
    80004162:	64a6                	ld	s1,72(sp)
    80004164:	6906                	ld	s2,64(sp)
    80004166:	79e2                	ld	s3,56(sp)
    80004168:	7a42                	ld	s4,48(sp)
    8000416a:	7aa2                	ld	s5,40(sp)
    8000416c:	7b02                	ld	s6,32(sp)
    8000416e:	6be2                	ld	s7,24(sp)
    80004170:	6c42                	ld	s8,16(sp)
    80004172:	6125                	add	sp,sp,96
    80004174:	8082                	ret
      wakeup(&pi->nread);
    80004176:	8562                	mv	a0,s8
    80004178:	ffffd097          	auipc	ra,0xffffd
    8000417c:	62c080e7          	jalr	1580(ra) # 800017a4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004180:	85a6                	mv	a1,s1
    80004182:	855e                	mv	a0,s7
    80004184:	ffffd097          	auipc	ra,0xffffd
    80004188:	5bc080e7          	jalr	1468(ra) # 80001740 <sleep>
  while(i < n){
    8000418c:	07495063          	bge	s2,s4,800041ec <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004190:	2204a783          	lw	a5,544(s1)
    80004194:	dfd5                	beqz	a5,80004150 <pipewrite+0x44>
    80004196:	854e                	mv	a0,s3
    80004198:	ffffe097          	auipc	ra,0xffffe
    8000419c:	850080e7          	jalr	-1968(ra) # 800019e8 <killed>
    800041a0:	f945                	bnez	a0,80004150 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800041a2:	2184a783          	lw	a5,536(s1)
    800041a6:	21c4a703          	lw	a4,540(s1)
    800041aa:	2007879b          	addw	a5,a5,512
    800041ae:	fcf704e3          	beq	a4,a5,80004176 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041b2:	4685                	li	a3,1
    800041b4:	01590633          	add	a2,s2,s5
    800041b8:	faf40593          	add	a1,s0,-81
    800041bc:	0509b503          	ld	a0,80(s3)
    800041c0:	ffffd097          	auipc	ra,0xffffd
    800041c4:	c20080e7          	jalr	-992(ra) # 80000de0 <copyin>
    800041c8:	03650263          	beq	a0,s6,800041ec <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041cc:	21c4a783          	lw	a5,540(s1)
    800041d0:	0017871b          	addw	a4,a5,1
    800041d4:	20e4ae23          	sw	a4,540(s1)
    800041d8:	1ff7f793          	and	a5,a5,511
    800041dc:	97a6                	add	a5,a5,s1
    800041de:	faf44703          	lbu	a4,-81(s0)
    800041e2:	00e78c23          	sb	a4,24(a5)
      i++;
    800041e6:	2905                	addw	s2,s2,1
    800041e8:	b755                	j	8000418c <pipewrite+0x80>
  int i = 0;
    800041ea:	4901                	li	s2,0
  wakeup(&pi->nread);
    800041ec:	21848513          	add	a0,s1,536
    800041f0:	ffffd097          	auipc	ra,0xffffd
    800041f4:	5b4080e7          	jalr	1460(ra) # 800017a4 <wakeup>
  release(&pi->lock);
    800041f8:	8526                	mv	a0,s1
    800041fa:	00002097          	auipc	ra,0x2
    800041fe:	278080e7          	jalr	632(ra) # 80006472 <release>
  return i;
    80004202:	bfa9                	j	8000415c <pipewrite+0x50>

0000000080004204 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004204:	715d                	add	sp,sp,-80
    80004206:	e486                	sd	ra,72(sp)
    80004208:	e0a2                	sd	s0,64(sp)
    8000420a:	fc26                	sd	s1,56(sp)
    8000420c:	f84a                	sd	s2,48(sp)
    8000420e:	f44e                	sd	s3,40(sp)
    80004210:	f052                	sd	s4,32(sp)
    80004212:	ec56                	sd	s5,24(sp)
    80004214:	e85a                	sd	s6,16(sp)
    80004216:	0880                	add	s0,sp,80
    80004218:	84aa                	mv	s1,a0
    8000421a:	892e                	mv	s2,a1
    8000421c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000421e:	ffffd097          	auipc	ra,0xffffd
    80004222:	e76080e7          	jalr	-394(ra) # 80001094 <myproc>
    80004226:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004228:	8526                	mv	a0,s1
    8000422a:	00002097          	auipc	ra,0x2
    8000422e:	194080e7          	jalr	404(ra) # 800063be <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004232:	2184a703          	lw	a4,536(s1)
    80004236:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000423a:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000423e:	02f71763          	bne	a4,a5,8000426c <piperead+0x68>
    80004242:	2244a783          	lw	a5,548(s1)
    80004246:	c39d                	beqz	a5,8000426c <piperead+0x68>
    if(killed(pr)){
    80004248:	8552                	mv	a0,s4
    8000424a:	ffffd097          	auipc	ra,0xffffd
    8000424e:	79e080e7          	jalr	1950(ra) # 800019e8 <killed>
    80004252:	e949                	bnez	a0,800042e4 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004254:	85a6                	mv	a1,s1
    80004256:	854e                	mv	a0,s3
    80004258:	ffffd097          	auipc	ra,0xffffd
    8000425c:	4e8080e7          	jalr	1256(ra) # 80001740 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004260:	2184a703          	lw	a4,536(s1)
    80004264:	21c4a783          	lw	a5,540(s1)
    80004268:	fcf70de3          	beq	a4,a5,80004242 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000426c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000426e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004270:	05505463          	blez	s5,800042b8 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004274:	2184a783          	lw	a5,536(s1)
    80004278:	21c4a703          	lw	a4,540(s1)
    8000427c:	02f70e63          	beq	a4,a5,800042b8 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004280:	0017871b          	addw	a4,a5,1
    80004284:	20e4ac23          	sw	a4,536(s1)
    80004288:	1ff7f793          	and	a5,a5,511
    8000428c:	97a6                	add	a5,a5,s1
    8000428e:	0187c783          	lbu	a5,24(a5)
    80004292:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004296:	4685                	li	a3,1
    80004298:	fbf40613          	add	a2,s0,-65
    8000429c:	85ca                	mv	a1,s2
    8000429e:	050a3503          	ld	a0,80(s4)
    800042a2:	ffffd097          	auipc	ra,0xffffd
    800042a6:	9fc080e7          	jalr	-1540(ra) # 80000c9e <copyout>
    800042aa:	01650763          	beq	a0,s6,800042b8 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042ae:	2985                	addw	s3,s3,1
    800042b0:	0905                	add	s2,s2,1
    800042b2:	fd3a91e3          	bne	s5,s3,80004274 <piperead+0x70>
    800042b6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042b8:	21c48513          	add	a0,s1,540
    800042bc:	ffffd097          	auipc	ra,0xffffd
    800042c0:	4e8080e7          	jalr	1256(ra) # 800017a4 <wakeup>
  release(&pi->lock);
    800042c4:	8526                	mv	a0,s1
    800042c6:	00002097          	auipc	ra,0x2
    800042ca:	1ac080e7          	jalr	428(ra) # 80006472 <release>
  return i;
}
    800042ce:	854e                	mv	a0,s3
    800042d0:	60a6                	ld	ra,72(sp)
    800042d2:	6406                	ld	s0,64(sp)
    800042d4:	74e2                	ld	s1,56(sp)
    800042d6:	7942                	ld	s2,48(sp)
    800042d8:	79a2                	ld	s3,40(sp)
    800042da:	7a02                	ld	s4,32(sp)
    800042dc:	6ae2                	ld	s5,24(sp)
    800042de:	6b42                	ld	s6,16(sp)
    800042e0:	6161                	add	sp,sp,80
    800042e2:	8082                	ret
      release(&pi->lock);
    800042e4:	8526                	mv	a0,s1
    800042e6:	00002097          	auipc	ra,0x2
    800042ea:	18c080e7          	jalr	396(ra) # 80006472 <release>
      return -1;
    800042ee:	59fd                	li	s3,-1
    800042f0:	bff9                	j	800042ce <piperead+0xca>

00000000800042f2 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800042f2:	1141                	add	sp,sp,-16
    800042f4:	e422                	sd	s0,8(sp)
    800042f6:	0800                	add	s0,sp,16
    800042f8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800042fa:	8905                	and	a0,a0,1
    800042fc:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800042fe:	8b89                	and	a5,a5,2
    80004300:	c399                	beqz	a5,80004306 <flags2perm+0x14>
      perm |= PTE_W;
    80004302:	00456513          	or	a0,a0,4
    return perm;
}
    80004306:	6422                	ld	s0,8(sp)
    80004308:	0141                	add	sp,sp,16
    8000430a:	8082                	ret

000000008000430c <exec>:

int
exec(char *path, char **argv)
{
    8000430c:	df010113          	add	sp,sp,-528
    80004310:	20113423          	sd	ra,520(sp)
    80004314:	20813023          	sd	s0,512(sp)
    80004318:	ffa6                	sd	s1,504(sp)
    8000431a:	fbca                	sd	s2,496(sp)
    8000431c:	f7ce                	sd	s3,488(sp)
    8000431e:	f3d2                	sd	s4,480(sp)
    80004320:	efd6                	sd	s5,472(sp)
    80004322:	ebda                	sd	s6,464(sp)
    80004324:	e7de                	sd	s7,456(sp)
    80004326:	e3e2                	sd	s8,448(sp)
    80004328:	ff66                	sd	s9,440(sp)
    8000432a:	fb6a                	sd	s10,432(sp)
    8000432c:	f76e                	sd	s11,424(sp)
    8000432e:	0c00                	add	s0,sp,528
    80004330:	892a                	mv	s2,a0
    80004332:	dea43c23          	sd	a0,-520(s0)
    80004336:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000433a:	ffffd097          	auipc	ra,0xffffd
    8000433e:	d5a080e7          	jalr	-678(ra) # 80001094 <myproc>
    80004342:	84aa                	mv	s1,a0

  begin_op();
    80004344:	fffff097          	auipc	ra,0xfffff
    80004348:	48e080e7          	jalr	1166(ra) # 800037d2 <begin_op>

  if((ip = namei(path)) == 0){
    8000434c:	854a                	mv	a0,s2
    8000434e:	fffff097          	auipc	ra,0xfffff
    80004352:	284080e7          	jalr	644(ra) # 800035d2 <namei>
    80004356:	c92d                	beqz	a0,800043c8 <exec+0xbc>
    80004358:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000435a:	fffff097          	auipc	ra,0xfffff
    8000435e:	ad2080e7          	jalr	-1326(ra) # 80002e2c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004362:	04000713          	li	a4,64
    80004366:	4681                	li	a3,0
    80004368:	e5040613          	add	a2,s0,-432
    8000436c:	4581                	li	a1,0
    8000436e:	8552                	mv	a0,s4
    80004370:	fffff097          	auipc	ra,0xfffff
    80004374:	d70080e7          	jalr	-656(ra) # 800030e0 <readi>
    80004378:	04000793          	li	a5,64
    8000437c:	00f51a63          	bne	a0,a5,80004390 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004380:	e5042703          	lw	a4,-432(s0)
    80004384:	464c47b7          	lui	a5,0x464c4
    80004388:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000438c:	04f70463          	beq	a4,a5,800043d4 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004390:	8552                	mv	a0,s4
    80004392:	fffff097          	auipc	ra,0xfffff
    80004396:	cfc080e7          	jalr	-772(ra) # 8000308e <iunlockput>
    end_op();
    8000439a:	fffff097          	auipc	ra,0xfffff
    8000439e:	4b2080e7          	jalr	1202(ra) # 8000384c <end_op>
  }
  return -1;
    800043a2:	557d                	li	a0,-1
}
    800043a4:	20813083          	ld	ra,520(sp)
    800043a8:	20013403          	ld	s0,512(sp)
    800043ac:	74fe                	ld	s1,504(sp)
    800043ae:	795e                	ld	s2,496(sp)
    800043b0:	79be                	ld	s3,488(sp)
    800043b2:	7a1e                	ld	s4,480(sp)
    800043b4:	6afe                	ld	s5,472(sp)
    800043b6:	6b5e                	ld	s6,464(sp)
    800043b8:	6bbe                	ld	s7,456(sp)
    800043ba:	6c1e                	ld	s8,448(sp)
    800043bc:	7cfa                	ld	s9,440(sp)
    800043be:	7d5a                	ld	s10,432(sp)
    800043c0:	7dba                	ld	s11,424(sp)
    800043c2:	21010113          	add	sp,sp,528
    800043c6:	8082                	ret
    end_op();
    800043c8:	fffff097          	auipc	ra,0xfffff
    800043cc:	484080e7          	jalr	1156(ra) # 8000384c <end_op>
    return -1;
    800043d0:	557d                	li	a0,-1
    800043d2:	bfc9                	j	800043a4 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800043d4:	8526                	mv	a0,s1
    800043d6:	ffffd097          	auipc	ra,0xffffd
    800043da:	d86080e7          	jalr	-634(ra) # 8000115c <proc_pagetable>
    800043de:	8b2a                	mv	s6,a0
    800043e0:	d945                	beqz	a0,80004390 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043e2:	e7042d03          	lw	s10,-400(s0)
    800043e6:	e8845783          	lhu	a5,-376(s0)
    800043ea:	10078463          	beqz	a5,800044f2 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043ee:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043f0:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800043f2:	6c85                	lui	s9,0x1
    800043f4:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043f8:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800043fc:	6a85                	lui	s5,0x1
    800043fe:	a0b5                	j	8000446a <exec+0x15e>
      panic("loadseg: address should exist");
    80004400:	00004517          	auipc	a0,0x4
    80004404:	29050513          	add	a0,a0,656 # 80008690 <syscalls+0x280>
    80004408:	00002097          	auipc	ra,0x2
    8000440c:	a7e080e7          	jalr	-1410(ra) # 80005e86 <panic>
    if(sz - i < PGSIZE)
    80004410:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004412:	8726                	mv	a4,s1
    80004414:	012c06bb          	addw	a3,s8,s2
    80004418:	4581                	li	a1,0
    8000441a:	8552                	mv	a0,s4
    8000441c:	fffff097          	auipc	ra,0xfffff
    80004420:	cc4080e7          	jalr	-828(ra) # 800030e0 <readi>
    80004424:	2501                	sext.w	a0,a0
    80004426:	24a49863          	bne	s1,a0,80004676 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    8000442a:	012a893b          	addw	s2,s5,s2
    8000442e:	03397563          	bgeu	s2,s3,80004458 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004432:	02091593          	sll	a1,s2,0x20
    80004436:	9181                	srl	a1,a1,0x20
    80004438:	95de                	add	a1,a1,s7
    8000443a:	855a                	mv	a0,s6
    8000443c:	ffffc097          	auipc	ra,0xffffc
    80004440:	24a080e7          	jalr	586(ra) # 80000686 <walkaddr>
    80004444:	862a                	mv	a2,a0
    if(pa == 0)
    80004446:	dd4d                	beqz	a0,80004400 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004448:	412984bb          	subw	s1,s3,s2
    8000444c:	0004879b          	sext.w	a5,s1
    80004450:	fcfcf0e3          	bgeu	s9,a5,80004410 <exec+0x104>
    80004454:	84d6                	mv	s1,s5
    80004456:	bf6d                	j	80004410 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004458:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000445c:	2d85                	addw	s11,s11,1 # fffffffffefff001 <end+0xffffffff7edbd271>
    8000445e:	038d0d1b          	addw	s10,s10,56
    80004462:	e8845783          	lhu	a5,-376(s0)
    80004466:	08fdd763          	bge	s11,a5,800044f4 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000446a:	2d01                	sext.w	s10,s10
    8000446c:	03800713          	li	a4,56
    80004470:	86ea                	mv	a3,s10
    80004472:	e1840613          	add	a2,s0,-488
    80004476:	4581                	li	a1,0
    80004478:	8552                	mv	a0,s4
    8000447a:	fffff097          	auipc	ra,0xfffff
    8000447e:	c66080e7          	jalr	-922(ra) # 800030e0 <readi>
    80004482:	03800793          	li	a5,56
    80004486:	1ef51663          	bne	a0,a5,80004672 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    8000448a:	e1842783          	lw	a5,-488(s0)
    8000448e:	4705                	li	a4,1
    80004490:	fce796e3          	bne	a5,a4,8000445c <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004494:	e4043483          	ld	s1,-448(s0)
    80004498:	e3843783          	ld	a5,-456(s0)
    8000449c:	1ef4e863          	bltu	s1,a5,8000468c <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044a0:	e2843783          	ld	a5,-472(s0)
    800044a4:	94be                	add	s1,s1,a5
    800044a6:	1ef4e663          	bltu	s1,a5,80004692 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    800044aa:	df043703          	ld	a4,-528(s0)
    800044ae:	8ff9                	and	a5,a5,a4
    800044b0:	1e079463          	bnez	a5,80004698 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044b4:	e1c42503          	lw	a0,-484(s0)
    800044b8:	00000097          	auipc	ra,0x0
    800044bc:	e3a080e7          	jalr	-454(ra) # 800042f2 <flags2perm>
    800044c0:	86aa                	mv	a3,a0
    800044c2:	8626                	mv	a2,s1
    800044c4:	85ca                	mv	a1,s2
    800044c6:	855a                	mv	a0,s6
    800044c8:	ffffc097          	auipc	ra,0xffffc
    800044cc:	580080e7          	jalr	1408(ra) # 80000a48 <uvmalloc>
    800044d0:	e0a43423          	sd	a0,-504(s0)
    800044d4:	1c050563          	beqz	a0,8000469e <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044d8:	e2843b83          	ld	s7,-472(s0)
    800044dc:	e2042c03          	lw	s8,-480(s0)
    800044e0:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044e4:	00098463          	beqz	s3,800044ec <exec+0x1e0>
    800044e8:	4901                	li	s2,0
    800044ea:	b7a1                	j	80004432 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044ec:	e0843903          	ld	s2,-504(s0)
    800044f0:	b7b5                	j	8000445c <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044f2:	4901                	li	s2,0
  iunlockput(ip);
    800044f4:	8552                	mv	a0,s4
    800044f6:	fffff097          	auipc	ra,0xfffff
    800044fa:	b98080e7          	jalr	-1128(ra) # 8000308e <iunlockput>
  end_op();
    800044fe:	fffff097          	auipc	ra,0xfffff
    80004502:	34e080e7          	jalr	846(ra) # 8000384c <end_op>
  p = myproc();
    80004506:	ffffd097          	auipc	ra,0xffffd
    8000450a:	b8e080e7          	jalr	-1138(ra) # 80001094 <myproc>
    8000450e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004510:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004514:	6985                	lui	s3,0x1
    80004516:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004518:	99ca                	add	s3,s3,s2
    8000451a:	77fd                	lui	a5,0xfffff
    8000451c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004520:	4691                	li	a3,4
    80004522:	6609                	lui	a2,0x2
    80004524:	964e                	add	a2,a2,s3
    80004526:	85ce                	mv	a1,s3
    80004528:	855a                	mv	a0,s6
    8000452a:	ffffc097          	auipc	ra,0xffffc
    8000452e:	51e080e7          	jalr	1310(ra) # 80000a48 <uvmalloc>
    80004532:	892a                	mv	s2,a0
    80004534:	e0a43423          	sd	a0,-504(s0)
    80004538:	e509                	bnez	a0,80004542 <exec+0x236>
  if(pagetable)
    8000453a:	e1343423          	sd	s3,-504(s0)
    8000453e:	4a01                	li	s4,0
    80004540:	aa1d                	j	80004676 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004542:	75f9                	lui	a1,0xffffe
    80004544:	95aa                	add	a1,a1,a0
    80004546:	855a                	mv	a0,s6
    80004548:	ffffc097          	auipc	ra,0xffffc
    8000454c:	724080e7          	jalr	1828(ra) # 80000c6c <uvmclear>
  stackbase = sp - PGSIZE;
    80004550:	7bfd                	lui	s7,0xfffff
    80004552:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004554:	e0043783          	ld	a5,-512(s0)
    80004558:	6388                	ld	a0,0(a5)
    8000455a:	c52d                	beqz	a0,800045c4 <exec+0x2b8>
    8000455c:	e9040993          	add	s3,s0,-368
    80004560:	f9040c13          	add	s8,s0,-112
    80004564:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004566:	ffffc097          	auipc	ra,0xffffc
    8000456a:	f12080e7          	jalr	-238(ra) # 80000478 <strlen>
    8000456e:	0015079b          	addw	a5,a0,1
    80004572:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004576:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    8000457a:	13796563          	bltu	s2,s7,800046a4 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000457e:	e0043d03          	ld	s10,-512(s0)
    80004582:	000d3a03          	ld	s4,0(s10)
    80004586:	8552                	mv	a0,s4
    80004588:	ffffc097          	auipc	ra,0xffffc
    8000458c:	ef0080e7          	jalr	-272(ra) # 80000478 <strlen>
    80004590:	0015069b          	addw	a3,a0,1
    80004594:	8652                	mv	a2,s4
    80004596:	85ca                	mv	a1,s2
    80004598:	855a                	mv	a0,s6
    8000459a:	ffffc097          	auipc	ra,0xffffc
    8000459e:	704080e7          	jalr	1796(ra) # 80000c9e <copyout>
    800045a2:	10054363          	bltz	a0,800046a8 <exec+0x39c>
    ustack[argc] = sp;
    800045a6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800045aa:	0485                	add	s1,s1,1
    800045ac:	008d0793          	add	a5,s10,8
    800045b0:	e0f43023          	sd	a5,-512(s0)
    800045b4:	008d3503          	ld	a0,8(s10)
    800045b8:	c909                	beqz	a0,800045ca <exec+0x2be>
    if(argc >= MAXARG)
    800045ba:	09a1                	add	s3,s3,8
    800045bc:	fb8995e3          	bne	s3,s8,80004566 <exec+0x25a>
  ip = 0;
    800045c0:	4a01                	li	s4,0
    800045c2:	a855                	j	80004676 <exec+0x36a>
  sp = sz;
    800045c4:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800045c8:	4481                	li	s1,0
  ustack[argc] = 0;
    800045ca:	00349793          	sll	a5,s1,0x3
    800045ce:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7fdbd200>
    800045d2:	97a2                	add	a5,a5,s0
    800045d4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800045d8:	00148693          	add	a3,s1,1
    800045dc:	068e                	sll	a3,a3,0x3
    800045de:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800045e2:	ff097913          	and	s2,s2,-16
  sz = sz1;
    800045e6:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800045ea:	f57968e3          	bltu	s2,s7,8000453a <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800045ee:	e9040613          	add	a2,s0,-368
    800045f2:	85ca                	mv	a1,s2
    800045f4:	855a                	mv	a0,s6
    800045f6:	ffffc097          	auipc	ra,0xffffc
    800045fa:	6a8080e7          	jalr	1704(ra) # 80000c9e <copyout>
    800045fe:	0a054763          	bltz	a0,800046ac <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004602:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004606:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000460a:	df843783          	ld	a5,-520(s0)
    8000460e:	0007c703          	lbu	a4,0(a5)
    80004612:	cf11                	beqz	a4,8000462e <exec+0x322>
    80004614:	0785                	add	a5,a5,1
    if(*s == '/')
    80004616:	02f00693          	li	a3,47
    8000461a:	a039                	j	80004628 <exec+0x31c>
      last = s+1;
    8000461c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004620:	0785                	add	a5,a5,1
    80004622:	fff7c703          	lbu	a4,-1(a5)
    80004626:	c701                	beqz	a4,8000462e <exec+0x322>
    if(*s == '/')
    80004628:	fed71ce3          	bne	a4,a3,80004620 <exec+0x314>
    8000462c:	bfc5                	j	8000461c <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    8000462e:	4641                	li	a2,16
    80004630:	df843583          	ld	a1,-520(s0)
    80004634:	158a8513          	add	a0,s5,344
    80004638:	ffffc097          	auipc	ra,0xffffc
    8000463c:	e0e080e7          	jalr	-498(ra) # 80000446 <safestrcpy>
  oldpagetable = p->pagetable;
    80004640:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004644:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004648:	e0843783          	ld	a5,-504(s0)
    8000464c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004650:	058ab783          	ld	a5,88(s5)
    80004654:	e6843703          	ld	a4,-408(s0)
    80004658:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000465a:	058ab783          	ld	a5,88(s5)
    8000465e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004662:	85e6                	mv	a1,s9
    80004664:	ffffd097          	auipc	ra,0xffffd
    80004668:	b94080e7          	jalr	-1132(ra) # 800011f8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000466c:	0004851b          	sext.w	a0,s1
    80004670:	bb15                	j	800043a4 <exec+0x98>
    80004672:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004676:	e0843583          	ld	a1,-504(s0)
    8000467a:	855a                	mv	a0,s6
    8000467c:	ffffd097          	auipc	ra,0xffffd
    80004680:	b7c080e7          	jalr	-1156(ra) # 800011f8 <proc_freepagetable>
  return -1;
    80004684:	557d                	li	a0,-1
  if(ip){
    80004686:	d00a0fe3          	beqz	s4,800043a4 <exec+0x98>
    8000468a:	b319                	j	80004390 <exec+0x84>
    8000468c:	e1243423          	sd	s2,-504(s0)
    80004690:	b7dd                	j	80004676 <exec+0x36a>
    80004692:	e1243423          	sd	s2,-504(s0)
    80004696:	b7c5                	j	80004676 <exec+0x36a>
    80004698:	e1243423          	sd	s2,-504(s0)
    8000469c:	bfe9                	j	80004676 <exec+0x36a>
    8000469e:	e1243423          	sd	s2,-504(s0)
    800046a2:	bfd1                	j	80004676 <exec+0x36a>
  ip = 0;
    800046a4:	4a01                	li	s4,0
    800046a6:	bfc1                	j	80004676 <exec+0x36a>
    800046a8:	4a01                	li	s4,0
  if(pagetable)
    800046aa:	b7f1                	j	80004676 <exec+0x36a>
  sz = sz1;
    800046ac:	e0843983          	ld	s3,-504(s0)
    800046b0:	b569                	j	8000453a <exec+0x22e>

00000000800046b2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800046b2:	7179                	add	sp,sp,-48
    800046b4:	f406                	sd	ra,40(sp)
    800046b6:	f022                	sd	s0,32(sp)
    800046b8:	ec26                	sd	s1,24(sp)
    800046ba:	e84a                	sd	s2,16(sp)
    800046bc:	1800                	add	s0,sp,48
    800046be:	892e                	mv	s2,a1
    800046c0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800046c2:	fdc40593          	add	a1,s0,-36
    800046c6:	ffffe097          	auipc	ra,0xffffe
    800046ca:	bf6080e7          	jalr	-1034(ra) # 800022bc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046ce:	fdc42703          	lw	a4,-36(s0)
    800046d2:	47bd                	li	a5,15
    800046d4:	02e7eb63          	bltu	a5,a4,8000470a <argfd+0x58>
    800046d8:	ffffd097          	auipc	ra,0xffffd
    800046dc:	9bc080e7          	jalr	-1604(ra) # 80001094 <myproc>
    800046e0:	fdc42703          	lw	a4,-36(s0)
    800046e4:	01a70793          	add	a5,a4,26
    800046e8:	078e                	sll	a5,a5,0x3
    800046ea:	953e                	add	a0,a0,a5
    800046ec:	611c                	ld	a5,0(a0)
    800046ee:	c385                	beqz	a5,8000470e <argfd+0x5c>
    return -1;
  if(pfd)
    800046f0:	00090463          	beqz	s2,800046f8 <argfd+0x46>
    *pfd = fd;
    800046f4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046f8:	4501                	li	a0,0
  if(pf)
    800046fa:	c091                	beqz	s1,800046fe <argfd+0x4c>
    *pf = f;
    800046fc:	e09c                	sd	a5,0(s1)
}
    800046fe:	70a2                	ld	ra,40(sp)
    80004700:	7402                	ld	s0,32(sp)
    80004702:	64e2                	ld	s1,24(sp)
    80004704:	6942                	ld	s2,16(sp)
    80004706:	6145                	add	sp,sp,48
    80004708:	8082                	ret
    return -1;
    8000470a:	557d                	li	a0,-1
    8000470c:	bfcd                	j	800046fe <argfd+0x4c>
    8000470e:	557d                	li	a0,-1
    80004710:	b7fd                	j	800046fe <argfd+0x4c>

0000000080004712 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004712:	1101                	add	sp,sp,-32
    80004714:	ec06                	sd	ra,24(sp)
    80004716:	e822                	sd	s0,16(sp)
    80004718:	e426                	sd	s1,8(sp)
    8000471a:	1000                	add	s0,sp,32
    8000471c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000471e:	ffffd097          	auipc	ra,0xffffd
    80004722:	976080e7          	jalr	-1674(ra) # 80001094 <myproc>
    80004726:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004728:	0d050793          	add	a5,a0,208
    8000472c:	4501                	li	a0,0
    8000472e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004730:	6398                	ld	a4,0(a5)
    80004732:	cb19                	beqz	a4,80004748 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004734:	2505                	addw	a0,a0,1
    80004736:	07a1                	add	a5,a5,8
    80004738:	fed51ce3          	bne	a0,a3,80004730 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000473c:	557d                	li	a0,-1
}
    8000473e:	60e2                	ld	ra,24(sp)
    80004740:	6442                	ld	s0,16(sp)
    80004742:	64a2                	ld	s1,8(sp)
    80004744:	6105                	add	sp,sp,32
    80004746:	8082                	ret
      p->ofile[fd] = f;
    80004748:	01a50793          	add	a5,a0,26
    8000474c:	078e                	sll	a5,a5,0x3
    8000474e:	963e                	add	a2,a2,a5
    80004750:	e204                	sd	s1,0(a2)
      return fd;
    80004752:	b7f5                	j	8000473e <fdalloc+0x2c>

0000000080004754 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004754:	715d                	add	sp,sp,-80
    80004756:	e486                	sd	ra,72(sp)
    80004758:	e0a2                	sd	s0,64(sp)
    8000475a:	fc26                	sd	s1,56(sp)
    8000475c:	f84a                	sd	s2,48(sp)
    8000475e:	f44e                	sd	s3,40(sp)
    80004760:	f052                	sd	s4,32(sp)
    80004762:	ec56                	sd	s5,24(sp)
    80004764:	e85a                	sd	s6,16(sp)
    80004766:	0880                	add	s0,sp,80
    80004768:	8b2e                	mv	s6,a1
    8000476a:	89b2                	mv	s3,a2
    8000476c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000476e:	fb040593          	add	a1,s0,-80
    80004772:	fffff097          	auipc	ra,0xfffff
    80004776:	e7e080e7          	jalr	-386(ra) # 800035f0 <nameiparent>
    8000477a:	84aa                	mv	s1,a0
    8000477c:	14050b63          	beqz	a0,800048d2 <create+0x17e>
    return 0;

  ilock(dp);
    80004780:	ffffe097          	auipc	ra,0xffffe
    80004784:	6ac080e7          	jalr	1708(ra) # 80002e2c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004788:	4601                	li	a2,0
    8000478a:	fb040593          	add	a1,s0,-80
    8000478e:	8526                	mv	a0,s1
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	b80080e7          	jalr	-1152(ra) # 80003310 <dirlookup>
    80004798:	8aaa                	mv	s5,a0
    8000479a:	c921                	beqz	a0,800047ea <create+0x96>
    iunlockput(dp);
    8000479c:	8526                	mv	a0,s1
    8000479e:	fffff097          	auipc	ra,0xfffff
    800047a2:	8f0080e7          	jalr	-1808(ra) # 8000308e <iunlockput>
    ilock(ip);
    800047a6:	8556                	mv	a0,s5
    800047a8:	ffffe097          	auipc	ra,0xffffe
    800047ac:	684080e7          	jalr	1668(ra) # 80002e2c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800047b0:	4789                	li	a5,2
    800047b2:	02fb1563          	bne	s6,a5,800047dc <create+0x88>
    800047b6:	044ad783          	lhu	a5,68(s5)
    800047ba:	37f9                	addw	a5,a5,-2
    800047bc:	17c2                	sll	a5,a5,0x30
    800047be:	93c1                	srl	a5,a5,0x30
    800047c0:	4705                	li	a4,1
    800047c2:	00f76d63          	bltu	a4,a5,800047dc <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800047c6:	8556                	mv	a0,s5
    800047c8:	60a6                	ld	ra,72(sp)
    800047ca:	6406                	ld	s0,64(sp)
    800047cc:	74e2                	ld	s1,56(sp)
    800047ce:	7942                	ld	s2,48(sp)
    800047d0:	79a2                	ld	s3,40(sp)
    800047d2:	7a02                	ld	s4,32(sp)
    800047d4:	6ae2                	ld	s5,24(sp)
    800047d6:	6b42                	ld	s6,16(sp)
    800047d8:	6161                	add	sp,sp,80
    800047da:	8082                	ret
    iunlockput(ip);
    800047dc:	8556                	mv	a0,s5
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	8b0080e7          	jalr	-1872(ra) # 8000308e <iunlockput>
    return 0;
    800047e6:	4a81                	li	s5,0
    800047e8:	bff9                	j	800047c6 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800047ea:	85da                	mv	a1,s6
    800047ec:	4088                	lw	a0,0(s1)
    800047ee:	ffffe097          	auipc	ra,0xffffe
    800047f2:	4a6080e7          	jalr	1190(ra) # 80002c94 <ialloc>
    800047f6:	8a2a                	mv	s4,a0
    800047f8:	c529                	beqz	a0,80004842 <create+0xee>
  ilock(ip);
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	632080e7          	jalr	1586(ra) # 80002e2c <ilock>
  ip->major = major;
    80004802:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004806:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000480a:	4905                	li	s2,1
    8000480c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004810:	8552                	mv	a0,s4
    80004812:	ffffe097          	auipc	ra,0xffffe
    80004816:	54e080e7          	jalr	1358(ra) # 80002d60 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000481a:	032b0b63          	beq	s6,s2,80004850 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000481e:	004a2603          	lw	a2,4(s4)
    80004822:	fb040593          	add	a1,s0,-80
    80004826:	8526                	mv	a0,s1
    80004828:	fffff097          	auipc	ra,0xfffff
    8000482c:	cf8080e7          	jalr	-776(ra) # 80003520 <dirlink>
    80004830:	06054f63          	bltz	a0,800048ae <create+0x15a>
  iunlockput(dp);
    80004834:	8526                	mv	a0,s1
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	858080e7          	jalr	-1960(ra) # 8000308e <iunlockput>
  return ip;
    8000483e:	8ad2                	mv	s5,s4
    80004840:	b759                	j	800047c6 <create+0x72>
    iunlockput(dp);
    80004842:	8526                	mv	a0,s1
    80004844:	fffff097          	auipc	ra,0xfffff
    80004848:	84a080e7          	jalr	-1974(ra) # 8000308e <iunlockput>
    return 0;
    8000484c:	8ad2                	mv	s5,s4
    8000484e:	bfa5                	j	800047c6 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004850:	004a2603          	lw	a2,4(s4)
    80004854:	00004597          	auipc	a1,0x4
    80004858:	e5c58593          	add	a1,a1,-420 # 800086b0 <syscalls+0x2a0>
    8000485c:	8552                	mv	a0,s4
    8000485e:	fffff097          	auipc	ra,0xfffff
    80004862:	cc2080e7          	jalr	-830(ra) # 80003520 <dirlink>
    80004866:	04054463          	bltz	a0,800048ae <create+0x15a>
    8000486a:	40d0                	lw	a2,4(s1)
    8000486c:	00004597          	auipc	a1,0x4
    80004870:	e4c58593          	add	a1,a1,-436 # 800086b8 <syscalls+0x2a8>
    80004874:	8552                	mv	a0,s4
    80004876:	fffff097          	auipc	ra,0xfffff
    8000487a:	caa080e7          	jalr	-854(ra) # 80003520 <dirlink>
    8000487e:	02054863          	bltz	a0,800048ae <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004882:	004a2603          	lw	a2,4(s4)
    80004886:	fb040593          	add	a1,s0,-80
    8000488a:	8526                	mv	a0,s1
    8000488c:	fffff097          	auipc	ra,0xfffff
    80004890:	c94080e7          	jalr	-876(ra) # 80003520 <dirlink>
    80004894:	00054d63          	bltz	a0,800048ae <create+0x15a>
    dp->nlink++;  // for ".."
    80004898:	04a4d783          	lhu	a5,74(s1)
    8000489c:	2785                	addw	a5,a5,1
    8000489e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800048a2:	8526                	mv	a0,s1
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	4bc080e7          	jalr	1212(ra) # 80002d60 <iupdate>
    800048ac:	b761                	j	80004834 <create+0xe0>
  ip->nlink = 0;
    800048ae:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800048b2:	8552                	mv	a0,s4
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	4ac080e7          	jalr	1196(ra) # 80002d60 <iupdate>
  iunlockput(ip);
    800048bc:	8552                	mv	a0,s4
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	7d0080e7          	jalr	2000(ra) # 8000308e <iunlockput>
  iunlockput(dp);
    800048c6:	8526                	mv	a0,s1
    800048c8:	ffffe097          	auipc	ra,0xffffe
    800048cc:	7c6080e7          	jalr	1990(ra) # 8000308e <iunlockput>
  return 0;
    800048d0:	bddd                	j	800047c6 <create+0x72>
    return 0;
    800048d2:	8aaa                	mv	s5,a0
    800048d4:	bdcd                	j	800047c6 <create+0x72>

00000000800048d6 <sys_dup>:
{
    800048d6:	7179                	add	sp,sp,-48
    800048d8:	f406                	sd	ra,40(sp)
    800048da:	f022                	sd	s0,32(sp)
    800048dc:	ec26                	sd	s1,24(sp)
    800048de:	e84a                	sd	s2,16(sp)
    800048e0:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048e2:	fd840613          	add	a2,s0,-40
    800048e6:	4581                	li	a1,0
    800048e8:	4501                	li	a0,0
    800048ea:	00000097          	auipc	ra,0x0
    800048ee:	dc8080e7          	jalr	-568(ra) # 800046b2 <argfd>
    return -1;
    800048f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048f4:	02054363          	bltz	a0,8000491a <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800048f8:	fd843903          	ld	s2,-40(s0)
    800048fc:	854a                	mv	a0,s2
    800048fe:	00000097          	auipc	ra,0x0
    80004902:	e14080e7          	jalr	-492(ra) # 80004712 <fdalloc>
    80004906:	84aa                	mv	s1,a0
    return -1;
    80004908:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000490a:	00054863          	bltz	a0,8000491a <sys_dup+0x44>
  filedup(f);
    8000490e:	854a                	mv	a0,s2
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	334080e7          	jalr	820(ra) # 80003c44 <filedup>
  return fd;
    80004918:	87a6                	mv	a5,s1
}
    8000491a:	853e                	mv	a0,a5
    8000491c:	70a2                	ld	ra,40(sp)
    8000491e:	7402                	ld	s0,32(sp)
    80004920:	64e2                	ld	s1,24(sp)
    80004922:	6942                	ld	s2,16(sp)
    80004924:	6145                	add	sp,sp,48
    80004926:	8082                	ret

0000000080004928 <sys_read>:
{
    80004928:	7179                	add	sp,sp,-48
    8000492a:	f406                	sd	ra,40(sp)
    8000492c:	f022                	sd	s0,32(sp)
    8000492e:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004930:	fd840593          	add	a1,s0,-40
    80004934:	4505                	li	a0,1
    80004936:	ffffe097          	auipc	ra,0xffffe
    8000493a:	9a6080e7          	jalr	-1626(ra) # 800022dc <argaddr>
  argint(2, &n);
    8000493e:	fe440593          	add	a1,s0,-28
    80004942:	4509                	li	a0,2
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	978080e7          	jalr	-1672(ra) # 800022bc <argint>
  if(argfd(0, 0, &f) < 0)
    8000494c:	fe840613          	add	a2,s0,-24
    80004950:	4581                	li	a1,0
    80004952:	4501                	li	a0,0
    80004954:	00000097          	auipc	ra,0x0
    80004958:	d5e080e7          	jalr	-674(ra) # 800046b2 <argfd>
    8000495c:	87aa                	mv	a5,a0
    return -1;
    8000495e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004960:	0007cc63          	bltz	a5,80004978 <sys_read+0x50>
  return fileread(f, p, n);
    80004964:	fe442603          	lw	a2,-28(s0)
    80004968:	fd843583          	ld	a1,-40(s0)
    8000496c:	fe843503          	ld	a0,-24(s0)
    80004970:	fffff097          	auipc	ra,0xfffff
    80004974:	460080e7          	jalr	1120(ra) # 80003dd0 <fileread>
}
    80004978:	70a2                	ld	ra,40(sp)
    8000497a:	7402                	ld	s0,32(sp)
    8000497c:	6145                	add	sp,sp,48
    8000497e:	8082                	ret

0000000080004980 <sys_write>:
{
    80004980:	7179                	add	sp,sp,-48
    80004982:	f406                	sd	ra,40(sp)
    80004984:	f022                	sd	s0,32(sp)
    80004986:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004988:	fd840593          	add	a1,s0,-40
    8000498c:	4505                	li	a0,1
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	94e080e7          	jalr	-1714(ra) # 800022dc <argaddr>
  argint(2, &n);
    80004996:	fe440593          	add	a1,s0,-28
    8000499a:	4509                	li	a0,2
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	920080e7          	jalr	-1760(ra) # 800022bc <argint>
  if(argfd(0, 0, &f) < 0)
    800049a4:	fe840613          	add	a2,s0,-24
    800049a8:	4581                	li	a1,0
    800049aa:	4501                	li	a0,0
    800049ac:	00000097          	auipc	ra,0x0
    800049b0:	d06080e7          	jalr	-762(ra) # 800046b2 <argfd>
    800049b4:	87aa                	mv	a5,a0
    return -1;
    800049b6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049b8:	0007cc63          	bltz	a5,800049d0 <sys_write+0x50>
  return filewrite(f, p, n);
    800049bc:	fe442603          	lw	a2,-28(s0)
    800049c0:	fd843583          	ld	a1,-40(s0)
    800049c4:	fe843503          	ld	a0,-24(s0)
    800049c8:	fffff097          	auipc	ra,0xfffff
    800049cc:	4ca080e7          	jalr	1226(ra) # 80003e92 <filewrite>
}
    800049d0:	70a2                	ld	ra,40(sp)
    800049d2:	7402                	ld	s0,32(sp)
    800049d4:	6145                	add	sp,sp,48
    800049d6:	8082                	ret

00000000800049d8 <sys_close>:
{
    800049d8:	1101                	add	sp,sp,-32
    800049da:	ec06                	sd	ra,24(sp)
    800049dc:	e822                	sd	s0,16(sp)
    800049de:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049e0:	fe040613          	add	a2,s0,-32
    800049e4:	fec40593          	add	a1,s0,-20
    800049e8:	4501                	li	a0,0
    800049ea:	00000097          	auipc	ra,0x0
    800049ee:	cc8080e7          	jalr	-824(ra) # 800046b2 <argfd>
    return -1;
    800049f2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049f4:	02054463          	bltz	a0,80004a1c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049f8:	ffffc097          	auipc	ra,0xffffc
    800049fc:	69c080e7          	jalr	1692(ra) # 80001094 <myproc>
    80004a00:	fec42783          	lw	a5,-20(s0)
    80004a04:	07e9                	add	a5,a5,26
    80004a06:	078e                	sll	a5,a5,0x3
    80004a08:	953e                	add	a0,a0,a5
    80004a0a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004a0e:	fe043503          	ld	a0,-32(s0)
    80004a12:	fffff097          	auipc	ra,0xfffff
    80004a16:	284080e7          	jalr	644(ra) # 80003c96 <fileclose>
  return 0;
    80004a1a:	4781                	li	a5,0
}
    80004a1c:	853e                	mv	a0,a5
    80004a1e:	60e2                	ld	ra,24(sp)
    80004a20:	6442                	ld	s0,16(sp)
    80004a22:	6105                	add	sp,sp,32
    80004a24:	8082                	ret

0000000080004a26 <sys_fstat>:
{
    80004a26:	1101                	add	sp,sp,-32
    80004a28:	ec06                	sd	ra,24(sp)
    80004a2a:	e822                	sd	s0,16(sp)
    80004a2c:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004a2e:	fe040593          	add	a1,s0,-32
    80004a32:	4505                	li	a0,1
    80004a34:	ffffe097          	auipc	ra,0xffffe
    80004a38:	8a8080e7          	jalr	-1880(ra) # 800022dc <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004a3c:	fe840613          	add	a2,s0,-24
    80004a40:	4581                	li	a1,0
    80004a42:	4501                	li	a0,0
    80004a44:	00000097          	auipc	ra,0x0
    80004a48:	c6e080e7          	jalr	-914(ra) # 800046b2 <argfd>
    80004a4c:	87aa                	mv	a5,a0
    return -1;
    80004a4e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a50:	0007ca63          	bltz	a5,80004a64 <sys_fstat+0x3e>
  return filestat(f, st);
    80004a54:	fe043583          	ld	a1,-32(s0)
    80004a58:	fe843503          	ld	a0,-24(s0)
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	302080e7          	jalr	770(ra) # 80003d5e <filestat>
}
    80004a64:	60e2                	ld	ra,24(sp)
    80004a66:	6442                	ld	s0,16(sp)
    80004a68:	6105                	add	sp,sp,32
    80004a6a:	8082                	ret

0000000080004a6c <sys_link>:
{
    80004a6c:	7169                	add	sp,sp,-304
    80004a6e:	f606                	sd	ra,296(sp)
    80004a70:	f222                	sd	s0,288(sp)
    80004a72:	ee26                	sd	s1,280(sp)
    80004a74:	ea4a                	sd	s2,272(sp)
    80004a76:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a78:	08000613          	li	a2,128
    80004a7c:	ed040593          	add	a1,s0,-304
    80004a80:	4501                	li	a0,0
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	87a080e7          	jalr	-1926(ra) # 800022fc <argstr>
    return -1;
    80004a8a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a8c:	10054e63          	bltz	a0,80004ba8 <sys_link+0x13c>
    80004a90:	08000613          	li	a2,128
    80004a94:	f5040593          	add	a1,s0,-176
    80004a98:	4505                	li	a0,1
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	862080e7          	jalr	-1950(ra) # 800022fc <argstr>
    return -1;
    80004aa2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004aa4:	10054263          	bltz	a0,80004ba8 <sys_link+0x13c>
  begin_op();
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	d2a080e7          	jalr	-726(ra) # 800037d2 <begin_op>
  if((ip = namei(old)) == 0){
    80004ab0:	ed040513          	add	a0,s0,-304
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	b1e080e7          	jalr	-1250(ra) # 800035d2 <namei>
    80004abc:	84aa                	mv	s1,a0
    80004abe:	c551                	beqz	a0,80004b4a <sys_link+0xde>
  ilock(ip);
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	36c080e7          	jalr	876(ra) # 80002e2c <ilock>
  if(ip->type == T_DIR){
    80004ac8:	04449703          	lh	a4,68(s1)
    80004acc:	4785                	li	a5,1
    80004ace:	08f70463          	beq	a4,a5,80004b56 <sys_link+0xea>
  ip->nlink++;
    80004ad2:	04a4d783          	lhu	a5,74(s1)
    80004ad6:	2785                	addw	a5,a5,1
    80004ad8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004adc:	8526                	mv	a0,s1
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	282080e7          	jalr	642(ra) # 80002d60 <iupdate>
  iunlock(ip);
    80004ae6:	8526                	mv	a0,s1
    80004ae8:	ffffe097          	auipc	ra,0xffffe
    80004aec:	406080e7          	jalr	1030(ra) # 80002eee <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004af0:	fd040593          	add	a1,s0,-48
    80004af4:	f5040513          	add	a0,s0,-176
    80004af8:	fffff097          	auipc	ra,0xfffff
    80004afc:	af8080e7          	jalr	-1288(ra) # 800035f0 <nameiparent>
    80004b00:	892a                	mv	s2,a0
    80004b02:	c935                	beqz	a0,80004b76 <sys_link+0x10a>
  ilock(dp);
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	328080e7          	jalr	808(ra) # 80002e2c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b0c:	00092703          	lw	a4,0(s2)
    80004b10:	409c                	lw	a5,0(s1)
    80004b12:	04f71d63          	bne	a4,a5,80004b6c <sys_link+0x100>
    80004b16:	40d0                	lw	a2,4(s1)
    80004b18:	fd040593          	add	a1,s0,-48
    80004b1c:	854a                	mv	a0,s2
    80004b1e:	fffff097          	auipc	ra,0xfffff
    80004b22:	a02080e7          	jalr	-1534(ra) # 80003520 <dirlink>
    80004b26:	04054363          	bltz	a0,80004b6c <sys_link+0x100>
  iunlockput(dp);
    80004b2a:	854a                	mv	a0,s2
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	562080e7          	jalr	1378(ra) # 8000308e <iunlockput>
  iput(ip);
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	4b0080e7          	jalr	1200(ra) # 80002fe6 <iput>
  end_op();
    80004b3e:	fffff097          	auipc	ra,0xfffff
    80004b42:	d0e080e7          	jalr	-754(ra) # 8000384c <end_op>
  return 0;
    80004b46:	4781                	li	a5,0
    80004b48:	a085                	j	80004ba8 <sys_link+0x13c>
    end_op();
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	d02080e7          	jalr	-766(ra) # 8000384c <end_op>
    return -1;
    80004b52:	57fd                	li	a5,-1
    80004b54:	a891                	j	80004ba8 <sys_link+0x13c>
    iunlockput(ip);
    80004b56:	8526                	mv	a0,s1
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	536080e7          	jalr	1334(ra) # 8000308e <iunlockput>
    end_op();
    80004b60:	fffff097          	auipc	ra,0xfffff
    80004b64:	cec080e7          	jalr	-788(ra) # 8000384c <end_op>
    return -1;
    80004b68:	57fd                	li	a5,-1
    80004b6a:	a83d                	j	80004ba8 <sys_link+0x13c>
    iunlockput(dp);
    80004b6c:	854a                	mv	a0,s2
    80004b6e:	ffffe097          	auipc	ra,0xffffe
    80004b72:	520080e7          	jalr	1312(ra) # 8000308e <iunlockput>
  ilock(ip);
    80004b76:	8526                	mv	a0,s1
    80004b78:	ffffe097          	auipc	ra,0xffffe
    80004b7c:	2b4080e7          	jalr	692(ra) # 80002e2c <ilock>
  ip->nlink--;
    80004b80:	04a4d783          	lhu	a5,74(s1)
    80004b84:	37fd                	addw	a5,a5,-1
    80004b86:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b8a:	8526                	mv	a0,s1
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	1d4080e7          	jalr	468(ra) # 80002d60 <iupdate>
  iunlockput(ip);
    80004b94:	8526                	mv	a0,s1
    80004b96:	ffffe097          	auipc	ra,0xffffe
    80004b9a:	4f8080e7          	jalr	1272(ra) # 8000308e <iunlockput>
  end_op();
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	cae080e7          	jalr	-850(ra) # 8000384c <end_op>
  return -1;
    80004ba6:	57fd                	li	a5,-1
}
    80004ba8:	853e                	mv	a0,a5
    80004baa:	70b2                	ld	ra,296(sp)
    80004bac:	7412                	ld	s0,288(sp)
    80004bae:	64f2                	ld	s1,280(sp)
    80004bb0:	6952                	ld	s2,272(sp)
    80004bb2:	6155                	add	sp,sp,304
    80004bb4:	8082                	ret

0000000080004bb6 <sys_unlink>:
{
    80004bb6:	7151                	add	sp,sp,-240
    80004bb8:	f586                	sd	ra,232(sp)
    80004bba:	f1a2                	sd	s0,224(sp)
    80004bbc:	eda6                	sd	s1,216(sp)
    80004bbe:	e9ca                	sd	s2,208(sp)
    80004bc0:	e5ce                	sd	s3,200(sp)
    80004bc2:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004bc4:	08000613          	li	a2,128
    80004bc8:	f3040593          	add	a1,s0,-208
    80004bcc:	4501                	li	a0,0
    80004bce:	ffffd097          	auipc	ra,0xffffd
    80004bd2:	72e080e7          	jalr	1838(ra) # 800022fc <argstr>
    80004bd6:	18054163          	bltz	a0,80004d58 <sys_unlink+0x1a2>
  begin_op();
    80004bda:	fffff097          	auipc	ra,0xfffff
    80004bde:	bf8080e7          	jalr	-1032(ra) # 800037d2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004be2:	fb040593          	add	a1,s0,-80
    80004be6:	f3040513          	add	a0,s0,-208
    80004bea:	fffff097          	auipc	ra,0xfffff
    80004bee:	a06080e7          	jalr	-1530(ra) # 800035f0 <nameiparent>
    80004bf2:	84aa                	mv	s1,a0
    80004bf4:	c979                	beqz	a0,80004cca <sys_unlink+0x114>
  ilock(dp);
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	236080e7          	jalr	566(ra) # 80002e2c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bfe:	00004597          	auipc	a1,0x4
    80004c02:	ab258593          	add	a1,a1,-1358 # 800086b0 <syscalls+0x2a0>
    80004c06:	fb040513          	add	a0,s0,-80
    80004c0a:	ffffe097          	auipc	ra,0xffffe
    80004c0e:	6ec080e7          	jalr	1772(ra) # 800032f6 <namecmp>
    80004c12:	14050a63          	beqz	a0,80004d66 <sys_unlink+0x1b0>
    80004c16:	00004597          	auipc	a1,0x4
    80004c1a:	aa258593          	add	a1,a1,-1374 # 800086b8 <syscalls+0x2a8>
    80004c1e:	fb040513          	add	a0,s0,-80
    80004c22:	ffffe097          	auipc	ra,0xffffe
    80004c26:	6d4080e7          	jalr	1748(ra) # 800032f6 <namecmp>
    80004c2a:	12050e63          	beqz	a0,80004d66 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c2e:	f2c40613          	add	a2,s0,-212
    80004c32:	fb040593          	add	a1,s0,-80
    80004c36:	8526                	mv	a0,s1
    80004c38:	ffffe097          	auipc	ra,0xffffe
    80004c3c:	6d8080e7          	jalr	1752(ra) # 80003310 <dirlookup>
    80004c40:	892a                	mv	s2,a0
    80004c42:	12050263          	beqz	a0,80004d66 <sys_unlink+0x1b0>
  ilock(ip);
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	1e6080e7          	jalr	486(ra) # 80002e2c <ilock>
  if(ip->nlink < 1)
    80004c4e:	04a91783          	lh	a5,74(s2)
    80004c52:	08f05263          	blez	a5,80004cd6 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c56:	04491703          	lh	a4,68(s2)
    80004c5a:	4785                	li	a5,1
    80004c5c:	08f70563          	beq	a4,a5,80004ce6 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c60:	4641                	li	a2,16
    80004c62:	4581                	li	a1,0
    80004c64:	fc040513          	add	a0,s0,-64
    80004c68:	ffffb097          	auipc	ra,0xffffb
    80004c6c:	696080e7          	jalr	1686(ra) # 800002fe <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c70:	4741                	li	a4,16
    80004c72:	f2c42683          	lw	a3,-212(s0)
    80004c76:	fc040613          	add	a2,s0,-64
    80004c7a:	4581                	li	a1,0
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	55a080e7          	jalr	1370(ra) # 800031d8 <writei>
    80004c86:	47c1                	li	a5,16
    80004c88:	0af51563          	bne	a0,a5,80004d32 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c8c:	04491703          	lh	a4,68(s2)
    80004c90:	4785                	li	a5,1
    80004c92:	0af70863          	beq	a4,a5,80004d42 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c96:	8526                	mv	a0,s1
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	3f6080e7          	jalr	1014(ra) # 8000308e <iunlockput>
  ip->nlink--;
    80004ca0:	04a95783          	lhu	a5,74(s2)
    80004ca4:	37fd                	addw	a5,a5,-1
    80004ca6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004caa:	854a                	mv	a0,s2
    80004cac:	ffffe097          	auipc	ra,0xffffe
    80004cb0:	0b4080e7          	jalr	180(ra) # 80002d60 <iupdate>
  iunlockput(ip);
    80004cb4:	854a                	mv	a0,s2
    80004cb6:	ffffe097          	auipc	ra,0xffffe
    80004cba:	3d8080e7          	jalr	984(ra) # 8000308e <iunlockput>
  end_op();
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	b8e080e7          	jalr	-1138(ra) # 8000384c <end_op>
  return 0;
    80004cc6:	4501                	li	a0,0
    80004cc8:	a84d                	j	80004d7a <sys_unlink+0x1c4>
    end_op();
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	b82080e7          	jalr	-1150(ra) # 8000384c <end_op>
    return -1;
    80004cd2:	557d                	li	a0,-1
    80004cd4:	a05d                	j	80004d7a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004cd6:	00004517          	auipc	a0,0x4
    80004cda:	9ea50513          	add	a0,a0,-1558 # 800086c0 <syscalls+0x2b0>
    80004cde:	00001097          	auipc	ra,0x1
    80004ce2:	1a8080e7          	jalr	424(ra) # 80005e86 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ce6:	04c92703          	lw	a4,76(s2)
    80004cea:	02000793          	li	a5,32
    80004cee:	f6e7f9e3          	bgeu	a5,a4,80004c60 <sys_unlink+0xaa>
    80004cf2:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cf6:	4741                	li	a4,16
    80004cf8:	86ce                	mv	a3,s3
    80004cfa:	f1840613          	add	a2,s0,-232
    80004cfe:	4581                	li	a1,0
    80004d00:	854a                	mv	a0,s2
    80004d02:	ffffe097          	auipc	ra,0xffffe
    80004d06:	3de080e7          	jalr	990(ra) # 800030e0 <readi>
    80004d0a:	47c1                	li	a5,16
    80004d0c:	00f51b63          	bne	a0,a5,80004d22 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004d10:	f1845783          	lhu	a5,-232(s0)
    80004d14:	e7a1                	bnez	a5,80004d5c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d16:	29c1                	addw	s3,s3,16
    80004d18:	04c92783          	lw	a5,76(s2)
    80004d1c:	fcf9ede3          	bltu	s3,a5,80004cf6 <sys_unlink+0x140>
    80004d20:	b781                	j	80004c60 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d22:	00004517          	auipc	a0,0x4
    80004d26:	9b650513          	add	a0,a0,-1610 # 800086d8 <syscalls+0x2c8>
    80004d2a:	00001097          	auipc	ra,0x1
    80004d2e:	15c080e7          	jalr	348(ra) # 80005e86 <panic>
    panic("unlink: writei");
    80004d32:	00004517          	auipc	a0,0x4
    80004d36:	9be50513          	add	a0,a0,-1602 # 800086f0 <syscalls+0x2e0>
    80004d3a:	00001097          	auipc	ra,0x1
    80004d3e:	14c080e7          	jalr	332(ra) # 80005e86 <panic>
    dp->nlink--;
    80004d42:	04a4d783          	lhu	a5,74(s1)
    80004d46:	37fd                	addw	a5,a5,-1
    80004d48:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d4c:	8526                	mv	a0,s1
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	012080e7          	jalr	18(ra) # 80002d60 <iupdate>
    80004d56:	b781                	j	80004c96 <sys_unlink+0xe0>
    return -1;
    80004d58:	557d                	li	a0,-1
    80004d5a:	a005                	j	80004d7a <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d5c:	854a                	mv	a0,s2
    80004d5e:	ffffe097          	auipc	ra,0xffffe
    80004d62:	330080e7          	jalr	816(ra) # 8000308e <iunlockput>
  iunlockput(dp);
    80004d66:	8526                	mv	a0,s1
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	326080e7          	jalr	806(ra) # 8000308e <iunlockput>
  end_op();
    80004d70:	fffff097          	auipc	ra,0xfffff
    80004d74:	adc080e7          	jalr	-1316(ra) # 8000384c <end_op>
  return -1;
    80004d78:	557d                	li	a0,-1
}
    80004d7a:	70ae                	ld	ra,232(sp)
    80004d7c:	740e                	ld	s0,224(sp)
    80004d7e:	64ee                	ld	s1,216(sp)
    80004d80:	694e                	ld	s2,208(sp)
    80004d82:	69ae                	ld	s3,200(sp)
    80004d84:	616d                	add	sp,sp,240
    80004d86:	8082                	ret

0000000080004d88 <sys_open>:

uint64
sys_open(void)
{
    80004d88:	7131                	add	sp,sp,-192
    80004d8a:	fd06                	sd	ra,184(sp)
    80004d8c:	f922                	sd	s0,176(sp)
    80004d8e:	f526                	sd	s1,168(sp)
    80004d90:	f14a                	sd	s2,160(sp)
    80004d92:	ed4e                	sd	s3,152(sp)
    80004d94:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d96:	f4c40593          	add	a1,s0,-180
    80004d9a:	4505                	li	a0,1
    80004d9c:	ffffd097          	auipc	ra,0xffffd
    80004da0:	520080e7          	jalr	1312(ra) # 800022bc <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004da4:	08000613          	li	a2,128
    80004da8:	f5040593          	add	a1,s0,-176
    80004dac:	4501                	li	a0,0
    80004dae:	ffffd097          	auipc	ra,0xffffd
    80004db2:	54e080e7          	jalr	1358(ra) # 800022fc <argstr>
    80004db6:	87aa                	mv	a5,a0
    return -1;
    80004db8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004dba:	0a07c863          	bltz	a5,80004e6a <sys_open+0xe2>

  begin_op();
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	a14080e7          	jalr	-1516(ra) # 800037d2 <begin_op>

  if(omode & O_CREATE){
    80004dc6:	f4c42783          	lw	a5,-180(s0)
    80004dca:	2007f793          	and	a5,a5,512
    80004dce:	cbdd                	beqz	a5,80004e84 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004dd0:	4681                	li	a3,0
    80004dd2:	4601                	li	a2,0
    80004dd4:	4589                	li	a1,2
    80004dd6:	f5040513          	add	a0,s0,-176
    80004dda:	00000097          	auipc	ra,0x0
    80004dde:	97a080e7          	jalr	-1670(ra) # 80004754 <create>
    80004de2:	84aa                	mv	s1,a0
    if(ip == 0){
    80004de4:	c951                	beqz	a0,80004e78 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004de6:	04449703          	lh	a4,68(s1)
    80004dea:	478d                	li	a5,3
    80004dec:	00f71763          	bne	a4,a5,80004dfa <sys_open+0x72>
    80004df0:	0464d703          	lhu	a4,70(s1)
    80004df4:	47a5                	li	a5,9
    80004df6:	0ce7ec63          	bltu	a5,a4,80004ece <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	de0080e7          	jalr	-544(ra) # 80003bda <filealloc>
    80004e02:	892a                	mv	s2,a0
    80004e04:	c56d                	beqz	a0,80004eee <sys_open+0x166>
    80004e06:	00000097          	auipc	ra,0x0
    80004e0a:	90c080e7          	jalr	-1780(ra) # 80004712 <fdalloc>
    80004e0e:	89aa                	mv	s3,a0
    80004e10:	0c054a63          	bltz	a0,80004ee4 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e14:	04449703          	lh	a4,68(s1)
    80004e18:	478d                	li	a5,3
    80004e1a:	0ef70563          	beq	a4,a5,80004f04 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e1e:	4789                	li	a5,2
    80004e20:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004e24:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004e28:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004e2c:	f4c42783          	lw	a5,-180(s0)
    80004e30:	0017c713          	xor	a4,a5,1
    80004e34:	8b05                	and	a4,a4,1
    80004e36:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e3a:	0037f713          	and	a4,a5,3
    80004e3e:	00e03733          	snez	a4,a4
    80004e42:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e46:	4007f793          	and	a5,a5,1024
    80004e4a:	c791                	beqz	a5,80004e56 <sys_open+0xce>
    80004e4c:	04449703          	lh	a4,68(s1)
    80004e50:	4789                	li	a5,2
    80004e52:	0cf70063          	beq	a4,a5,80004f12 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004e56:	8526                	mv	a0,s1
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	096080e7          	jalr	150(ra) # 80002eee <iunlock>
  end_op();
    80004e60:	fffff097          	auipc	ra,0xfffff
    80004e64:	9ec080e7          	jalr	-1556(ra) # 8000384c <end_op>

  return fd;
    80004e68:	854e                	mv	a0,s3
}
    80004e6a:	70ea                	ld	ra,184(sp)
    80004e6c:	744a                	ld	s0,176(sp)
    80004e6e:	74aa                	ld	s1,168(sp)
    80004e70:	790a                	ld	s2,160(sp)
    80004e72:	69ea                	ld	s3,152(sp)
    80004e74:	6129                	add	sp,sp,192
    80004e76:	8082                	ret
      end_op();
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	9d4080e7          	jalr	-1580(ra) # 8000384c <end_op>
      return -1;
    80004e80:	557d                	li	a0,-1
    80004e82:	b7e5                	j	80004e6a <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004e84:	f5040513          	add	a0,s0,-176
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	74a080e7          	jalr	1866(ra) # 800035d2 <namei>
    80004e90:	84aa                	mv	s1,a0
    80004e92:	c905                	beqz	a0,80004ec2 <sys_open+0x13a>
    ilock(ip);
    80004e94:	ffffe097          	auipc	ra,0xffffe
    80004e98:	f98080e7          	jalr	-104(ra) # 80002e2c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e9c:	04449703          	lh	a4,68(s1)
    80004ea0:	4785                	li	a5,1
    80004ea2:	f4f712e3          	bne	a4,a5,80004de6 <sys_open+0x5e>
    80004ea6:	f4c42783          	lw	a5,-180(s0)
    80004eaa:	dba1                	beqz	a5,80004dfa <sys_open+0x72>
      iunlockput(ip);
    80004eac:	8526                	mv	a0,s1
    80004eae:	ffffe097          	auipc	ra,0xffffe
    80004eb2:	1e0080e7          	jalr	480(ra) # 8000308e <iunlockput>
      end_op();
    80004eb6:	fffff097          	auipc	ra,0xfffff
    80004eba:	996080e7          	jalr	-1642(ra) # 8000384c <end_op>
      return -1;
    80004ebe:	557d                	li	a0,-1
    80004ec0:	b76d                	j	80004e6a <sys_open+0xe2>
      end_op();
    80004ec2:	fffff097          	auipc	ra,0xfffff
    80004ec6:	98a080e7          	jalr	-1654(ra) # 8000384c <end_op>
      return -1;
    80004eca:	557d                	li	a0,-1
    80004ecc:	bf79                	j	80004e6a <sys_open+0xe2>
    iunlockput(ip);
    80004ece:	8526                	mv	a0,s1
    80004ed0:	ffffe097          	auipc	ra,0xffffe
    80004ed4:	1be080e7          	jalr	446(ra) # 8000308e <iunlockput>
    end_op();
    80004ed8:	fffff097          	auipc	ra,0xfffff
    80004edc:	974080e7          	jalr	-1676(ra) # 8000384c <end_op>
    return -1;
    80004ee0:	557d                	li	a0,-1
    80004ee2:	b761                	j	80004e6a <sys_open+0xe2>
      fileclose(f);
    80004ee4:	854a                	mv	a0,s2
    80004ee6:	fffff097          	auipc	ra,0xfffff
    80004eea:	db0080e7          	jalr	-592(ra) # 80003c96 <fileclose>
    iunlockput(ip);
    80004eee:	8526                	mv	a0,s1
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	19e080e7          	jalr	414(ra) # 8000308e <iunlockput>
    end_op();
    80004ef8:	fffff097          	auipc	ra,0xfffff
    80004efc:	954080e7          	jalr	-1708(ra) # 8000384c <end_op>
    return -1;
    80004f00:	557d                	li	a0,-1
    80004f02:	b7a5                	j	80004e6a <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004f04:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004f08:	04649783          	lh	a5,70(s1)
    80004f0c:	02f91223          	sh	a5,36(s2)
    80004f10:	bf21                	j	80004e28 <sys_open+0xa0>
    itrunc(ip);
    80004f12:	8526                	mv	a0,s1
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	026080e7          	jalr	38(ra) # 80002f3a <itrunc>
    80004f1c:	bf2d                	j	80004e56 <sys_open+0xce>

0000000080004f1e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f1e:	7175                	add	sp,sp,-144
    80004f20:	e506                	sd	ra,136(sp)
    80004f22:	e122                	sd	s0,128(sp)
    80004f24:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	8ac080e7          	jalr	-1876(ra) # 800037d2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f2e:	08000613          	li	a2,128
    80004f32:	f7040593          	add	a1,s0,-144
    80004f36:	4501                	li	a0,0
    80004f38:	ffffd097          	auipc	ra,0xffffd
    80004f3c:	3c4080e7          	jalr	964(ra) # 800022fc <argstr>
    80004f40:	02054963          	bltz	a0,80004f72 <sys_mkdir+0x54>
    80004f44:	4681                	li	a3,0
    80004f46:	4601                	li	a2,0
    80004f48:	4585                	li	a1,1
    80004f4a:	f7040513          	add	a0,s0,-144
    80004f4e:	00000097          	auipc	ra,0x0
    80004f52:	806080e7          	jalr	-2042(ra) # 80004754 <create>
    80004f56:	cd11                	beqz	a0,80004f72 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f58:	ffffe097          	auipc	ra,0xffffe
    80004f5c:	136080e7          	jalr	310(ra) # 8000308e <iunlockput>
  end_op();
    80004f60:	fffff097          	auipc	ra,0xfffff
    80004f64:	8ec080e7          	jalr	-1812(ra) # 8000384c <end_op>
  return 0;
    80004f68:	4501                	li	a0,0
}
    80004f6a:	60aa                	ld	ra,136(sp)
    80004f6c:	640a                	ld	s0,128(sp)
    80004f6e:	6149                	add	sp,sp,144
    80004f70:	8082                	ret
    end_op();
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	8da080e7          	jalr	-1830(ra) # 8000384c <end_op>
    return -1;
    80004f7a:	557d                	li	a0,-1
    80004f7c:	b7fd                	j	80004f6a <sys_mkdir+0x4c>

0000000080004f7e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f7e:	7135                	add	sp,sp,-160
    80004f80:	ed06                	sd	ra,152(sp)
    80004f82:	e922                	sd	s0,144(sp)
    80004f84:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f86:	fffff097          	auipc	ra,0xfffff
    80004f8a:	84c080e7          	jalr	-1972(ra) # 800037d2 <begin_op>
  argint(1, &major);
    80004f8e:	f6c40593          	add	a1,s0,-148
    80004f92:	4505                	li	a0,1
    80004f94:	ffffd097          	auipc	ra,0xffffd
    80004f98:	328080e7          	jalr	808(ra) # 800022bc <argint>
  argint(2, &minor);
    80004f9c:	f6840593          	add	a1,s0,-152
    80004fa0:	4509                	li	a0,2
    80004fa2:	ffffd097          	auipc	ra,0xffffd
    80004fa6:	31a080e7          	jalr	794(ra) # 800022bc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004faa:	08000613          	li	a2,128
    80004fae:	f7040593          	add	a1,s0,-144
    80004fb2:	4501                	li	a0,0
    80004fb4:	ffffd097          	auipc	ra,0xffffd
    80004fb8:	348080e7          	jalr	840(ra) # 800022fc <argstr>
    80004fbc:	02054b63          	bltz	a0,80004ff2 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fc0:	f6841683          	lh	a3,-152(s0)
    80004fc4:	f6c41603          	lh	a2,-148(s0)
    80004fc8:	458d                	li	a1,3
    80004fca:	f7040513          	add	a0,s0,-144
    80004fce:	fffff097          	auipc	ra,0xfffff
    80004fd2:	786080e7          	jalr	1926(ra) # 80004754 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fd6:	cd11                	beqz	a0,80004ff2 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fd8:	ffffe097          	auipc	ra,0xffffe
    80004fdc:	0b6080e7          	jalr	182(ra) # 8000308e <iunlockput>
  end_op();
    80004fe0:	fffff097          	auipc	ra,0xfffff
    80004fe4:	86c080e7          	jalr	-1940(ra) # 8000384c <end_op>
  return 0;
    80004fe8:	4501                	li	a0,0
}
    80004fea:	60ea                	ld	ra,152(sp)
    80004fec:	644a                	ld	s0,144(sp)
    80004fee:	610d                	add	sp,sp,160
    80004ff0:	8082                	ret
    end_op();
    80004ff2:	fffff097          	auipc	ra,0xfffff
    80004ff6:	85a080e7          	jalr	-1958(ra) # 8000384c <end_op>
    return -1;
    80004ffa:	557d                	li	a0,-1
    80004ffc:	b7fd                	j	80004fea <sys_mknod+0x6c>

0000000080004ffe <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ffe:	7135                	add	sp,sp,-160
    80005000:	ed06                	sd	ra,152(sp)
    80005002:	e922                	sd	s0,144(sp)
    80005004:	e526                	sd	s1,136(sp)
    80005006:	e14a                	sd	s2,128(sp)
    80005008:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000500a:	ffffc097          	auipc	ra,0xffffc
    8000500e:	08a080e7          	jalr	138(ra) # 80001094 <myproc>
    80005012:	892a                	mv	s2,a0
  
  begin_op();
    80005014:	ffffe097          	auipc	ra,0xffffe
    80005018:	7be080e7          	jalr	1982(ra) # 800037d2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000501c:	08000613          	li	a2,128
    80005020:	f6040593          	add	a1,s0,-160
    80005024:	4501                	li	a0,0
    80005026:	ffffd097          	auipc	ra,0xffffd
    8000502a:	2d6080e7          	jalr	726(ra) # 800022fc <argstr>
    8000502e:	04054b63          	bltz	a0,80005084 <sys_chdir+0x86>
    80005032:	f6040513          	add	a0,s0,-160
    80005036:	ffffe097          	auipc	ra,0xffffe
    8000503a:	59c080e7          	jalr	1436(ra) # 800035d2 <namei>
    8000503e:	84aa                	mv	s1,a0
    80005040:	c131                	beqz	a0,80005084 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005042:	ffffe097          	auipc	ra,0xffffe
    80005046:	dea080e7          	jalr	-534(ra) # 80002e2c <ilock>
  if(ip->type != T_DIR){
    8000504a:	04449703          	lh	a4,68(s1)
    8000504e:	4785                	li	a5,1
    80005050:	04f71063          	bne	a4,a5,80005090 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005054:	8526                	mv	a0,s1
    80005056:	ffffe097          	auipc	ra,0xffffe
    8000505a:	e98080e7          	jalr	-360(ra) # 80002eee <iunlock>
  iput(p->cwd);
    8000505e:	15093503          	ld	a0,336(s2)
    80005062:	ffffe097          	auipc	ra,0xffffe
    80005066:	f84080e7          	jalr	-124(ra) # 80002fe6 <iput>
  end_op();
    8000506a:	ffffe097          	auipc	ra,0xffffe
    8000506e:	7e2080e7          	jalr	2018(ra) # 8000384c <end_op>
  p->cwd = ip;
    80005072:	14993823          	sd	s1,336(s2)
  return 0;
    80005076:	4501                	li	a0,0
}
    80005078:	60ea                	ld	ra,152(sp)
    8000507a:	644a                	ld	s0,144(sp)
    8000507c:	64aa                	ld	s1,136(sp)
    8000507e:	690a                	ld	s2,128(sp)
    80005080:	610d                	add	sp,sp,160
    80005082:	8082                	ret
    end_op();
    80005084:	ffffe097          	auipc	ra,0xffffe
    80005088:	7c8080e7          	jalr	1992(ra) # 8000384c <end_op>
    return -1;
    8000508c:	557d                	li	a0,-1
    8000508e:	b7ed                	j	80005078 <sys_chdir+0x7a>
    iunlockput(ip);
    80005090:	8526                	mv	a0,s1
    80005092:	ffffe097          	auipc	ra,0xffffe
    80005096:	ffc080e7          	jalr	-4(ra) # 8000308e <iunlockput>
    end_op();
    8000509a:	ffffe097          	auipc	ra,0xffffe
    8000509e:	7b2080e7          	jalr	1970(ra) # 8000384c <end_op>
    return -1;
    800050a2:	557d                	li	a0,-1
    800050a4:	bfd1                	j	80005078 <sys_chdir+0x7a>

00000000800050a6 <sys_exec>:

uint64
sys_exec(void)
{
    800050a6:	7121                	add	sp,sp,-448
    800050a8:	ff06                	sd	ra,440(sp)
    800050aa:	fb22                	sd	s0,432(sp)
    800050ac:	f726                	sd	s1,424(sp)
    800050ae:	f34a                	sd	s2,416(sp)
    800050b0:	ef4e                	sd	s3,408(sp)
    800050b2:	eb52                	sd	s4,400(sp)
    800050b4:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800050b6:	e4840593          	add	a1,s0,-440
    800050ba:	4505                	li	a0,1
    800050bc:	ffffd097          	auipc	ra,0xffffd
    800050c0:	220080e7          	jalr	544(ra) # 800022dc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800050c4:	08000613          	li	a2,128
    800050c8:	f5040593          	add	a1,s0,-176
    800050cc:	4501                	li	a0,0
    800050ce:	ffffd097          	auipc	ra,0xffffd
    800050d2:	22e080e7          	jalr	558(ra) # 800022fc <argstr>
    800050d6:	87aa                	mv	a5,a0
    return -1;
    800050d8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800050da:	0c07c263          	bltz	a5,8000519e <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    800050de:	10000613          	li	a2,256
    800050e2:	4581                	li	a1,0
    800050e4:	e5040513          	add	a0,s0,-432
    800050e8:	ffffb097          	auipc	ra,0xffffb
    800050ec:	216080e7          	jalr	534(ra) # 800002fe <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050f0:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800050f4:	89a6                	mv	s3,s1
    800050f6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050f8:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050fc:	00391513          	sll	a0,s2,0x3
    80005100:	e4040593          	add	a1,s0,-448
    80005104:	e4843783          	ld	a5,-440(s0)
    80005108:	953e                	add	a0,a0,a5
    8000510a:	ffffd097          	auipc	ra,0xffffd
    8000510e:	114080e7          	jalr	276(ra) # 8000221e <fetchaddr>
    80005112:	02054a63          	bltz	a0,80005146 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005116:	e4043783          	ld	a5,-448(s0)
    8000511a:	c3b9                	beqz	a5,80005160 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000511c:	ffffb097          	auipc	ra,0xffffb
    80005120:	f00080e7          	jalr	-256(ra) # 8000001c <kalloc>
    80005124:	85aa                	mv	a1,a0
    80005126:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000512a:	cd11                	beqz	a0,80005146 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000512c:	6605                	lui	a2,0x1
    8000512e:	e4043503          	ld	a0,-448(s0)
    80005132:	ffffd097          	auipc	ra,0xffffd
    80005136:	13e080e7          	jalr	318(ra) # 80002270 <fetchstr>
    8000513a:	00054663          	bltz	a0,80005146 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000513e:	0905                	add	s2,s2,1
    80005140:	09a1                	add	s3,s3,8
    80005142:	fb491de3          	bne	s2,s4,800050fc <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005146:	f5040913          	add	s2,s0,-176
    8000514a:	6088                	ld	a0,0(s1)
    8000514c:	c921                	beqz	a0,8000519c <sys_exec+0xf6>
    kfree(argv[i]);
    8000514e:	ffffb097          	auipc	ra,0xffffb
    80005152:	050080e7          	jalr	80(ra) # 8000019e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005156:	04a1                	add	s1,s1,8
    80005158:	ff2499e3          	bne	s1,s2,8000514a <sys_exec+0xa4>
  return -1;
    8000515c:	557d                	li	a0,-1
    8000515e:	a081                	j	8000519e <sys_exec+0xf8>
      argv[i] = 0;
    80005160:	0009079b          	sext.w	a5,s2
    80005164:	078e                	sll	a5,a5,0x3
    80005166:	fd078793          	add	a5,a5,-48
    8000516a:	97a2                	add	a5,a5,s0
    8000516c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005170:	e5040593          	add	a1,s0,-432
    80005174:	f5040513          	add	a0,s0,-176
    80005178:	fffff097          	auipc	ra,0xfffff
    8000517c:	194080e7          	jalr	404(ra) # 8000430c <exec>
    80005180:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005182:	f5040993          	add	s3,s0,-176
    80005186:	6088                	ld	a0,0(s1)
    80005188:	c901                	beqz	a0,80005198 <sys_exec+0xf2>
    kfree(argv[i]);
    8000518a:	ffffb097          	auipc	ra,0xffffb
    8000518e:	014080e7          	jalr	20(ra) # 8000019e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005192:	04a1                	add	s1,s1,8
    80005194:	ff3499e3          	bne	s1,s3,80005186 <sys_exec+0xe0>
  return ret;
    80005198:	854a                	mv	a0,s2
    8000519a:	a011                	j	8000519e <sys_exec+0xf8>
  return -1;
    8000519c:	557d                	li	a0,-1
}
    8000519e:	70fa                	ld	ra,440(sp)
    800051a0:	745a                	ld	s0,432(sp)
    800051a2:	74ba                	ld	s1,424(sp)
    800051a4:	791a                	ld	s2,416(sp)
    800051a6:	69fa                	ld	s3,408(sp)
    800051a8:	6a5a                	ld	s4,400(sp)
    800051aa:	6139                	add	sp,sp,448
    800051ac:	8082                	ret

00000000800051ae <sys_pipe>:

uint64
sys_pipe(void)
{
    800051ae:	7139                	add	sp,sp,-64
    800051b0:	fc06                	sd	ra,56(sp)
    800051b2:	f822                	sd	s0,48(sp)
    800051b4:	f426                	sd	s1,40(sp)
    800051b6:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051b8:	ffffc097          	auipc	ra,0xffffc
    800051bc:	edc080e7          	jalr	-292(ra) # 80001094 <myproc>
    800051c0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800051c2:	fd840593          	add	a1,s0,-40
    800051c6:	4501                	li	a0,0
    800051c8:	ffffd097          	auipc	ra,0xffffd
    800051cc:	114080e7          	jalr	276(ra) # 800022dc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800051d0:	fc840593          	add	a1,s0,-56
    800051d4:	fd040513          	add	a0,s0,-48
    800051d8:	fffff097          	auipc	ra,0xfffff
    800051dc:	dea080e7          	jalr	-534(ra) # 80003fc2 <pipealloc>
    return -1;
    800051e0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051e2:	0c054463          	bltz	a0,800052aa <sys_pipe+0xfc>
  fd0 = -1;
    800051e6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051ea:	fd043503          	ld	a0,-48(s0)
    800051ee:	fffff097          	auipc	ra,0xfffff
    800051f2:	524080e7          	jalr	1316(ra) # 80004712 <fdalloc>
    800051f6:	fca42223          	sw	a0,-60(s0)
    800051fa:	08054b63          	bltz	a0,80005290 <sys_pipe+0xe2>
    800051fe:	fc843503          	ld	a0,-56(s0)
    80005202:	fffff097          	auipc	ra,0xfffff
    80005206:	510080e7          	jalr	1296(ra) # 80004712 <fdalloc>
    8000520a:	fca42023          	sw	a0,-64(s0)
    8000520e:	06054863          	bltz	a0,8000527e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005212:	4691                	li	a3,4
    80005214:	fc440613          	add	a2,s0,-60
    80005218:	fd843583          	ld	a1,-40(s0)
    8000521c:	68a8                	ld	a0,80(s1)
    8000521e:	ffffc097          	auipc	ra,0xffffc
    80005222:	a80080e7          	jalr	-1408(ra) # 80000c9e <copyout>
    80005226:	02054063          	bltz	a0,80005246 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000522a:	4691                	li	a3,4
    8000522c:	fc040613          	add	a2,s0,-64
    80005230:	fd843583          	ld	a1,-40(s0)
    80005234:	0591                	add	a1,a1,4
    80005236:	68a8                	ld	a0,80(s1)
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	a66080e7          	jalr	-1434(ra) # 80000c9e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005240:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005242:	06055463          	bgez	a0,800052aa <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005246:	fc442783          	lw	a5,-60(s0)
    8000524a:	07e9                	add	a5,a5,26
    8000524c:	078e                	sll	a5,a5,0x3
    8000524e:	97a6                	add	a5,a5,s1
    80005250:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005254:	fc042783          	lw	a5,-64(s0)
    80005258:	07e9                	add	a5,a5,26
    8000525a:	078e                	sll	a5,a5,0x3
    8000525c:	94be                	add	s1,s1,a5
    8000525e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005262:	fd043503          	ld	a0,-48(s0)
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	a30080e7          	jalr	-1488(ra) # 80003c96 <fileclose>
    fileclose(wf);
    8000526e:	fc843503          	ld	a0,-56(s0)
    80005272:	fffff097          	auipc	ra,0xfffff
    80005276:	a24080e7          	jalr	-1500(ra) # 80003c96 <fileclose>
    return -1;
    8000527a:	57fd                	li	a5,-1
    8000527c:	a03d                	j	800052aa <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000527e:	fc442783          	lw	a5,-60(s0)
    80005282:	0007c763          	bltz	a5,80005290 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005286:	07e9                	add	a5,a5,26
    80005288:	078e                	sll	a5,a5,0x3
    8000528a:	97a6                	add	a5,a5,s1
    8000528c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005290:	fd043503          	ld	a0,-48(s0)
    80005294:	fffff097          	auipc	ra,0xfffff
    80005298:	a02080e7          	jalr	-1534(ra) # 80003c96 <fileclose>
    fileclose(wf);
    8000529c:	fc843503          	ld	a0,-56(s0)
    800052a0:	fffff097          	auipc	ra,0xfffff
    800052a4:	9f6080e7          	jalr	-1546(ra) # 80003c96 <fileclose>
    return -1;
    800052a8:	57fd                	li	a5,-1
}
    800052aa:	853e                	mv	a0,a5
    800052ac:	70e2                	ld	ra,56(sp)
    800052ae:	7442                	ld	s0,48(sp)
    800052b0:	74a2                	ld	s1,40(sp)
    800052b2:	6121                	add	sp,sp,64
    800052b4:	8082                	ret
	...

00000000800052c0 <kernelvec>:
    800052c0:	7111                	add	sp,sp,-256
    800052c2:	e006                	sd	ra,0(sp)
    800052c4:	e40a                	sd	sp,8(sp)
    800052c6:	e80e                	sd	gp,16(sp)
    800052c8:	ec12                	sd	tp,24(sp)
    800052ca:	f016                	sd	t0,32(sp)
    800052cc:	f41a                	sd	t1,40(sp)
    800052ce:	f81e                	sd	t2,48(sp)
    800052d0:	fc22                	sd	s0,56(sp)
    800052d2:	e0a6                	sd	s1,64(sp)
    800052d4:	e4aa                	sd	a0,72(sp)
    800052d6:	e8ae                	sd	a1,80(sp)
    800052d8:	ecb2                	sd	a2,88(sp)
    800052da:	f0b6                	sd	a3,96(sp)
    800052dc:	f4ba                	sd	a4,104(sp)
    800052de:	f8be                	sd	a5,112(sp)
    800052e0:	fcc2                	sd	a6,120(sp)
    800052e2:	e146                	sd	a7,128(sp)
    800052e4:	e54a                	sd	s2,136(sp)
    800052e6:	e94e                	sd	s3,144(sp)
    800052e8:	ed52                	sd	s4,152(sp)
    800052ea:	f156                	sd	s5,160(sp)
    800052ec:	f55a                	sd	s6,168(sp)
    800052ee:	f95e                	sd	s7,176(sp)
    800052f0:	fd62                	sd	s8,184(sp)
    800052f2:	e1e6                	sd	s9,192(sp)
    800052f4:	e5ea                	sd	s10,200(sp)
    800052f6:	e9ee                	sd	s11,208(sp)
    800052f8:	edf2                	sd	t3,216(sp)
    800052fa:	f1f6                	sd	t4,224(sp)
    800052fc:	f5fa                	sd	t5,232(sp)
    800052fe:	f9fe                	sd	t6,240(sp)
    80005300:	debfc0ef          	jal	800020ea <kerneltrap>
    80005304:	6082                	ld	ra,0(sp)
    80005306:	6122                	ld	sp,8(sp)
    80005308:	61c2                	ld	gp,16(sp)
    8000530a:	7282                	ld	t0,32(sp)
    8000530c:	7322                	ld	t1,40(sp)
    8000530e:	73c2                	ld	t2,48(sp)
    80005310:	7462                	ld	s0,56(sp)
    80005312:	6486                	ld	s1,64(sp)
    80005314:	6526                	ld	a0,72(sp)
    80005316:	65c6                	ld	a1,80(sp)
    80005318:	6666                	ld	a2,88(sp)
    8000531a:	7686                	ld	a3,96(sp)
    8000531c:	7726                	ld	a4,104(sp)
    8000531e:	77c6                	ld	a5,112(sp)
    80005320:	7866                	ld	a6,120(sp)
    80005322:	688a                	ld	a7,128(sp)
    80005324:	692a                	ld	s2,136(sp)
    80005326:	69ca                	ld	s3,144(sp)
    80005328:	6a6a                	ld	s4,152(sp)
    8000532a:	7a8a                	ld	s5,160(sp)
    8000532c:	7b2a                	ld	s6,168(sp)
    8000532e:	7bca                	ld	s7,176(sp)
    80005330:	7c6a                	ld	s8,184(sp)
    80005332:	6c8e                	ld	s9,192(sp)
    80005334:	6d2e                	ld	s10,200(sp)
    80005336:	6dce                	ld	s11,208(sp)
    80005338:	6e6e                	ld	t3,216(sp)
    8000533a:	7e8e                	ld	t4,224(sp)
    8000533c:	7f2e                	ld	t5,232(sp)
    8000533e:	7fce                	ld	t6,240(sp)
    80005340:	6111                	add	sp,sp,256
    80005342:	10200073          	sret
    80005346:	00000013          	nop
    8000534a:	00000013          	nop
    8000534e:	0001                	nop

0000000080005350 <timervec>:
    80005350:	34051573          	csrrw	a0,mscratch,a0
    80005354:	e10c                	sd	a1,0(a0)
    80005356:	e510                	sd	a2,8(a0)
    80005358:	e914                	sd	a3,16(a0)
    8000535a:	6d0c                	ld	a1,24(a0)
    8000535c:	7110                	ld	a2,32(a0)
    8000535e:	6194                	ld	a3,0(a1)
    80005360:	96b2                	add	a3,a3,a2
    80005362:	e194                	sd	a3,0(a1)
    80005364:	4589                	li	a1,2
    80005366:	14459073          	csrw	sip,a1
    8000536a:	6914                	ld	a3,16(a0)
    8000536c:	6510                	ld	a2,8(a0)
    8000536e:	610c                	ld	a1,0(a0)
    80005370:	34051573          	csrrw	a0,mscratch,a0
    80005374:	30200073          	mret
	...

000000008000537a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000537a:	1141                	add	sp,sp,-16
    8000537c:	e422                	sd	s0,8(sp)
    8000537e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005380:	0c0007b7          	lui	a5,0xc000
    80005384:	4705                	li	a4,1
    80005386:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005388:	c3d8                	sw	a4,4(a5)
}
    8000538a:	6422                	ld	s0,8(sp)
    8000538c:	0141                	add	sp,sp,16
    8000538e:	8082                	ret

0000000080005390 <plicinithart>:

void
plicinithart(void)
{
    80005390:	1141                	add	sp,sp,-16
    80005392:	e406                	sd	ra,8(sp)
    80005394:	e022                	sd	s0,0(sp)
    80005396:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005398:	ffffc097          	auipc	ra,0xffffc
    8000539c:	cd0080e7          	jalr	-816(ra) # 80001068 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053a0:	0085171b          	sllw	a4,a0,0x8
    800053a4:	0c0027b7          	lui	a5,0xc002
    800053a8:	97ba                	add	a5,a5,a4
    800053aa:	40200713          	li	a4,1026
    800053ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053b2:	00d5151b          	sllw	a0,a0,0xd
    800053b6:	0c2017b7          	lui	a5,0xc201
    800053ba:	97aa                	add	a5,a5,a0
    800053bc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053c0:	60a2                	ld	ra,8(sp)
    800053c2:	6402                	ld	s0,0(sp)
    800053c4:	0141                	add	sp,sp,16
    800053c6:	8082                	ret

00000000800053c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053c8:	1141                	add	sp,sp,-16
    800053ca:	e406                	sd	ra,8(sp)
    800053cc:	e022                	sd	s0,0(sp)
    800053ce:	0800                	add	s0,sp,16
  int hart = cpuid();
    800053d0:	ffffc097          	auipc	ra,0xffffc
    800053d4:	c98080e7          	jalr	-872(ra) # 80001068 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053d8:	00d5151b          	sllw	a0,a0,0xd
    800053dc:	0c2017b7          	lui	a5,0xc201
    800053e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800053e2:	43c8                	lw	a0,4(a5)
    800053e4:	60a2                	ld	ra,8(sp)
    800053e6:	6402                	ld	s0,0(sp)
    800053e8:	0141                	add	sp,sp,16
    800053ea:	8082                	ret

00000000800053ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053ec:	1101                	add	sp,sp,-32
    800053ee:	ec06                	sd	ra,24(sp)
    800053f0:	e822                	sd	s0,16(sp)
    800053f2:	e426                	sd	s1,8(sp)
    800053f4:	1000                	add	s0,sp,32
    800053f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053f8:	ffffc097          	auipc	ra,0xffffc
    800053fc:	c70080e7          	jalr	-912(ra) # 80001068 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005400:	00d5151b          	sllw	a0,a0,0xd
    80005404:	0c2017b7          	lui	a5,0xc201
    80005408:	97aa                	add	a5,a5,a0
    8000540a:	c3c4                	sw	s1,4(a5)
}
    8000540c:	60e2                	ld	ra,24(sp)
    8000540e:	6442                	ld	s0,16(sp)
    80005410:	64a2                	ld	s1,8(sp)
    80005412:	6105                	add	sp,sp,32
    80005414:	8082                	ret

0000000080005416 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005416:	1141                	add	sp,sp,-16
    80005418:	e406                	sd	ra,8(sp)
    8000541a:	e022                	sd	s0,0(sp)
    8000541c:	0800                	add	s0,sp,16
  if(i >= NUM)
    8000541e:	479d                	li	a5,7
    80005420:	04a7cc63          	blt	a5,a0,80005478 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005424:	00234797          	auipc	a5,0x234
    80005428:	5e478793          	add	a5,a5,1508 # 80239a08 <disk>
    8000542c:	97aa                	add	a5,a5,a0
    8000542e:	0187c783          	lbu	a5,24(a5)
    80005432:	ebb9                	bnez	a5,80005488 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005434:	00451693          	sll	a3,a0,0x4
    80005438:	00234797          	auipc	a5,0x234
    8000543c:	5d078793          	add	a5,a5,1488 # 80239a08 <disk>
    80005440:	6398                	ld	a4,0(a5)
    80005442:	9736                	add	a4,a4,a3
    80005444:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005448:	6398                	ld	a4,0(a5)
    8000544a:	9736                	add	a4,a4,a3
    8000544c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005450:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005454:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005458:	97aa                	add	a5,a5,a0
    8000545a:	4705                	li	a4,1
    8000545c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005460:	00234517          	auipc	a0,0x234
    80005464:	5c050513          	add	a0,a0,1472 # 80239a20 <disk+0x18>
    80005468:	ffffc097          	auipc	ra,0xffffc
    8000546c:	33c080e7          	jalr	828(ra) # 800017a4 <wakeup>
}
    80005470:	60a2                	ld	ra,8(sp)
    80005472:	6402                	ld	s0,0(sp)
    80005474:	0141                	add	sp,sp,16
    80005476:	8082                	ret
    panic("free_desc 1");
    80005478:	00003517          	auipc	a0,0x3
    8000547c:	28850513          	add	a0,a0,648 # 80008700 <syscalls+0x2f0>
    80005480:	00001097          	auipc	ra,0x1
    80005484:	a06080e7          	jalr	-1530(ra) # 80005e86 <panic>
    panic("free_desc 2");
    80005488:	00003517          	auipc	a0,0x3
    8000548c:	28850513          	add	a0,a0,648 # 80008710 <syscalls+0x300>
    80005490:	00001097          	auipc	ra,0x1
    80005494:	9f6080e7          	jalr	-1546(ra) # 80005e86 <panic>

0000000080005498 <virtio_disk_init>:
{
    80005498:	1101                	add	sp,sp,-32
    8000549a:	ec06                	sd	ra,24(sp)
    8000549c:	e822                	sd	s0,16(sp)
    8000549e:	e426                	sd	s1,8(sp)
    800054a0:	e04a                	sd	s2,0(sp)
    800054a2:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054a4:	00003597          	auipc	a1,0x3
    800054a8:	27c58593          	add	a1,a1,636 # 80008720 <syscalls+0x310>
    800054ac:	00234517          	auipc	a0,0x234
    800054b0:	68450513          	add	a0,a0,1668 # 80239b30 <disk+0x128>
    800054b4:	00001097          	auipc	ra,0x1
    800054b8:	e7a080e7          	jalr	-390(ra) # 8000632e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054bc:	100017b7          	lui	a5,0x10001
    800054c0:	4398                	lw	a4,0(a5)
    800054c2:	2701                	sext.w	a4,a4
    800054c4:	747277b7          	lui	a5,0x74727
    800054c8:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054cc:	14f71b63          	bne	a4,a5,80005622 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054d0:	100017b7          	lui	a5,0x10001
    800054d4:	43dc                	lw	a5,4(a5)
    800054d6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054d8:	4709                	li	a4,2
    800054da:	14e79463          	bne	a5,a4,80005622 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054de:	100017b7          	lui	a5,0x10001
    800054e2:	479c                	lw	a5,8(a5)
    800054e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054e6:	12e79e63          	bne	a5,a4,80005622 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054ea:	100017b7          	lui	a5,0x10001
    800054ee:	47d8                	lw	a4,12(a5)
    800054f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054f2:	554d47b7          	lui	a5,0x554d4
    800054f6:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054fa:	12f71463          	bne	a4,a5,80005622 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054fe:	100017b7          	lui	a5,0x10001
    80005502:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005506:	4705                	li	a4,1
    80005508:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000550a:	470d                	li	a4,3
    8000550c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000550e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005510:	c7ffe6b7          	lui	a3,0xc7ffe
    80005514:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47dbc9cf>
    80005518:	8f75                	and	a4,a4,a3
    8000551a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000551c:	472d                	li	a4,11
    8000551e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005520:	5bbc                	lw	a5,112(a5)
    80005522:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005526:	8ba1                	and	a5,a5,8
    80005528:	10078563          	beqz	a5,80005632 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000552c:	100017b7          	lui	a5,0x10001
    80005530:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005534:	43fc                	lw	a5,68(a5)
    80005536:	2781                	sext.w	a5,a5
    80005538:	10079563          	bnez	a5,80005642 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000553c:	100017b7          	lui	a5,0x10001
    80005540:	5bdc                	lw	a5,52(a5)
    80005542:	2781                	sext.w	a5,a5
  if(max == 0)
    80005544:	10078763          	beqz	a5,80005652 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005548:	471d                	li	a4,7
    8000554a:	10f77c63          	bgeu	a4,a5,80005662 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000554e:	ffffb097          	auipc	ra,0xffffb
    80005552:	ace080e7          	jalr	-1330(ra) # 8000001c <kalloc>
    80005556:	00234497          	auipc	s1,0x234
    8000555a:	4b248493          	add	s1,s1,1202 # 80239a08 <disk>
    8000555e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005560:	ffffb097          	auipc	ra,0xffffb
    80005564:	abc080e7          	jalr	-1348(ra) # 8000001c <kalloc>
    80005568:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000556a:	ffffb097          	auipc	ra,0xffffb
    8000556e:	ab2080e7          	jalr	-1358(ra) # 8000001c <kalloc>
    80005572:	87aa                	mv	a5,a0
    80005574:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005576:	6088                	ld	a0,0(s1)
    80005578:	cd6d                	beqz	a0,80005672 <virtio_disk_init+0x1da>
    8000557a:	00234717          	auipc	a4,0x234
    8000557e:	49673703          	ld	a4,1174(a4) # 80239a10 <disk+0x8>
    80005582:	cb65                	beqz	a4,80005672 <virtio_disk_init+0x1da>
    80005584:	c7fd                	beqz	a5,80005672 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005586:	6605                	lui	a2,0x1
    80005588:	4581                	li	a1,0
    8000558a:	ffffb097          	auipc	ra,0xffffb
    8000558e:	d74080e7          	jalr	-652(ra) # 800002fe <memset>
  memset(disk.avail, 0, PGSIZE);
    80005592:	00234497          	auipc	s1,0x234
    80005596:	47648493          	add	s1,s1,1142 # 80239a08 <disk>
    8000559a:	6605                	lui	a2,0x1
    8000559c:	4581                	li	a1,0
    8000559e:	6488                	ld	a0,8(s1)
    800055a0:	ffffb097          	auipc	ra,0xffffb
    800055a4:	d5e080e7          	jalr	-674(ra) # 800002fe <memset>
  memset(disk.used, 0, PGSIZE);
    800055a8:	6605                	lui	a2,0x1
    800055aa:	4581                	li	a1,0
    800055ac:	6888                	ld	a0,16(s1)
    800055ae:	ffffb097          	auipc	ra,0xffffb
    800055b2:	d50080e7          	jalr	-688(ra) # 800002fe <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055b6:	100017b7          	lui	a5,0x10001
    800055ba:	4721                	li	a4,8
    800055bc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800055be:	4098                	lw	a4,0(s1)
    800055c0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800055c4:	40d8                	lw	a4,4(s1)
    800055c6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800055ca:	6498                	ld	a4,8(s1)
    800055cc:	0007069b          	sext.w	a3,a4
    800055d0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800055d4:	9701                	sra	a4,a4,0x20
    800055d6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055da:	6898                	ld	a4,16(s1)
    800055dc:	0007069b          	sext.w	a3,a4
    800055e0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055e4:	9701                	sra	a4,a4,0x20
    800055e6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055ea:	4705                	li	a4,1
    800055ec:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800055ee:	00e48c23          	sb	a4,24(s1)
    800055f2:	00e48ca3          	sb	a4,25(s1)
    800055f6:	00e48d23          	sb	a4,26(s1)
    800055fa:	00e48da3          	sb	a4,27(s1)
    800055fe:	00e48e23          	sb	a4,28(s1)
    80005602:	00e48ea3          	sb	a4,29(s1)
    80005606:	00e48f23          	sb	a4,30(s1)
    8000560a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000560e:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005612:	0727a823          	sw	s2,112(a5)
}
    80005616:	60e2                	ld	ra,24(sp)
    80005618:	6442                	ld	s0,16(sp)
    8000561a:	64a2                	ld	s1,8(sp)
    8000561c:	6902                	ld	s2,0(sp)
    8000561e:	6105                	add	sp,sp,32
    80005620:	8082                	ret
    panic("could not find virtio disk");
    80005622:	00003517          	auipc	a0,0x3
    80005626:	10e50513          	add	a0,a0,270 # 80008730 <syscalls+0x320>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	85c080e7          	jalr	-1956(ra) # 80005e86 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005632:	00003517          	auipc	a0,0x3
    80005636:	11e50513          	add	a0,a0,286 # 80008750 <syscalls+0x340>
    8000563a:	00001097          	auipc	ra,0x1
    8000563e:	84c080e7          	jalr	-1972(ra) # 80005e86 <panic>
    panic("virtio disk should not be ready");
    80005642:	00003517          	auipc	a0,0x3
    80005646:	12e50513          	add	a0,a0,302 # 80008770 <syscalls+0x360>
    8000564a:	00001097          	auipc	ra,0x1
    8000564e:	83c080e7          	jalr	-1988(ra) # 80005e86 <panic>
    panic("virtio disk has no queue 0");
    80005652:	00003517          	auipc	a0,0x3
    80005656:	13e50513          	add	a0,a0,318 # 80008790 <syscalls+0x380>
    8000565a:	00001097          	auipc	ra,0x1
    8000565e:	82c080e7          	jalr	-2004(ra) # 80005e86 <panic>
    panic("virtio disk max queue too short");
    80005662:	00003517          	auipc	a0,0x3
    80005666:	14e50513          	add	a0,a0,334 # 800087b0 <syscalls+0x3a0>
    8000566a:	00001097          	auipc	ra,0x1
    8000566e:	81c080e7          	jalr	-2020(ra) # 80005e86 <panic>
    panic("virtio disk kalloc");
    80005672:	00003517          	auipc	a0,0x3
    80005676:	15e50513          	add	a0,a0,350 # 800087d0 <syscalls+0x3c0>
    8000567a:	00001097          	auipc	ra,0x1
    8000567e:	80c080e7          	jalr	-2036(ra) # 80005e86 <panic>

0000000080005682 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005682:	7159                	add	sp,sp,-112
    80005684:	f486                	sd	ra,104(sp)
    80005686:	f0a2                	sd	s0,96(sp)
    80005688:	eca6                	sd	s1,88(sp)
    8000568a:	e8ca                	sd	s2,80(sp)
    8000568c:	e4ce                	sd	s3,72(sp)
    8000568e:	e0d2                	sd	s4,64(sp)
    80005690:	fc56                	sd	s5,56(sp)
    80005692:	f85a                	sd	s6,48(sp)
    80005694:	f45e                	sd	s7,40(sp)
    80005696:	f062                	sd	s8,32(sp)
    80005698:	ec66                	sd	s9,24(sp)
    8000569a:	e86a                	sd	s10,16(sp)
    8000569c:	1880                	add	s0,sp,112
    8000569e:	8a2a                	mv	s4,a0
    800056a0:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056a2:	00c52c83          	lw	s9,12(a0)
    800056a6:	001c9c9b          	sllw	s9,s9,0x1
    800056aa:	1c82                	sll	s9,s9,0x20
    800056ac:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800056b0:	00234517          	auipc	a0,0x234
    800056b4:	48050513          	add	a0,a0,1152 # 80239b30 <disk+0x128>
    800056b8:	00001097          	auipc	ra,0x1
    800056bc:	d06080e7          	jalr	-762(ra) # 800063be <acquire>
  for(int i = 0; i < 3; i++){
    800056c0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800056c2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056c4:	00234b17          	auipc	s6,0x234
    800056c8:	344b0b13          	add	s6,s6,836 # 80239a08 <disk>
  for(int i = 0; i < 3; i++){
    800056cc:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056ce:	00234c17          	auipc	s8,0x234
    800056d2:	462c0c13          	add	s8,s8,1122 # 80239b30 <disk+0x128>
    800056d6:	a095                	j	8000573a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800056d8:	00fb0733          	add	a4,s6,a5
    800056dc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056e0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800056e2:	0207c563          	bltz	a5,8000570c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800056e6:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800056e8:	0591                	add	a1,a1,4
    800056ea:	05560d63          	beq	a2,s5,80005744 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800056ee:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800056f0:	00234717          	auipc	a4,0x234
    800056f4:	31870713          	add	a4,a4,792 # 80239a08 <disk>
    800056f8:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800056fa:	01874683          	lbu	a3,24(a4)
    800056fe:	fee9                	bnez	a3,800056d8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005700:	2785                	addw	a5,a5,1
    80005702:	0705                	add	a4,a4,1
    80005704:	fe979be3          	bne	a5,s1,800056fa <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005708:	57fd                	li	a5,-1
    8000570a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000570c:	00c05e63          	blez	a2,80005728 <virtio_disk_rw+0xa6>
    80005710:	060a                	sll	a2,a2,0x2
    80005712:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005716:	0009a503          	lw	a0,0(s3)
    8000571a:	00000097          	auipc	ra,0x0
    8000571e:	cfc080e7          	jalr	-772(ra) # 80005416 <free_desc>
      for(int j = 0; j < i; j++)
    80005722:	0991                	add	s3,s3,4
    80005724:	ffa999e3          	bne	s3,s10,80005716 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005728:	85e2                	mv	a1,s8
    8000572a:	00234517          	auipc	a0,0x234
    8000572e:	2f650513          	add	a0,a0,758 # 80239a20 <disk+0x18>
    80005732:	ffffc097          	auipc	ra,0xffffc
    80005736:	00e080e7          	jalr	14(ra) # 80001740 <sleep>
  for(int i = 0; i < 3; i++){
    8000573a:	f9040993          	add	s3,s0,-112
{
    8000573e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005740:	864a                	mv	a2,s2
    80005742:	b775                	j	800056ee <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005744:	f9042503          	lw	a0,-112(s0)
    80005748:	00a50713          	add	a4,a0,10
    8000574c:	0712                	sll	a4,a4,0x4

  if(write)
    8000574e:	00234797          	auipc	a5,0x234
    80005752:	2ba78793          	add	a5,a5,698 # 80239a08 <disk>
    80005756:	00e786b3          	add	a3,a5,a4
    8000575a:	01703633          	snez	a2,s7
    8000575e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005760:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005764:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005768:	f6070613          	add	a2,a4,-160
    8000576c:	6394                	ld	a3,0(a5)
    8000576e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005770:	00870593          	add	a1,a4,8
    80005774:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005776:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005778:	0007b803          	ld	a6,0(a5)
    8000577c:	9642                	add	a2,a2,a6
    8000577e:	46c1                	li	a3,16
    80005780:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005782:	4585                	li	a1,1
    80005784:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005788:	f9442683          	lw	a3,-108(s0)
    8000578c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005790:	0692                	sll	a3,a3,0x4
    80005792:	9836                	add	a6,a6,a3
    80005794:	058a0613          	add	a2,s4,88
    80005798:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000579c:	0007b803          	ld	a6,0(a5)
    800057a0:	96c2                	add	a3,a3,a6
    800057a2:	40000613          	li	a2,1024
    800057a6:	c690                	sw	a2,8(a3)
  if(write)
    800057a8:	001bb613          	seqz	a2,s7
    800057ac:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057b0:	00166613          	or	a2,a2,1
    800057b4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800057b8:	f9842603          	lw	a2,-104(s0)
    800057bc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800057c0:	00250693          	add	a3,a0,2
    800057c4:	0692                	sll	a3,a3,0x4
    800057c6:	96be                	add	a3,a3,a5
    800057c8:	58fd                	li	a7,-1
    800057ca:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057ce:	0612                	sll	a2,a2,0x4
    800057d0:	9832                	add	a6,a6,a2
    800057d2:	f9070713          	add	a4,a4,-112
    800057d6:	973e                	add	a4,a4,a5
    800057d8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800057dc:	6398                	ld	a4,0(a5)
    800057de:	9732                	add	a4,a4,a2
    800057e0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057e2:	4609                	li	a2,2
    800057e4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800057e8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057ec:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800057f0:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057f4:	6794                	ld	a3,8(a5)
    800057f6:	0026d703          	lhu	a4,2(a3)
    800057fa:	8b1d                	and	a4,a4,7
    800057fc:	0706                	sll	a4,a4,0x1
    800057fe:	96ba                	add	a3,a3,a4
    80005800:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005804:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005808:	6798                	ld	a4,8(a5)
    8000580a:	00275783          	lhu	a5,2(a4)
    8000580e:	2785                	addw	a5,a5,1
    80005810:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005814:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005818:	100017b7          	lui	a5,0x10001
    8000581c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005820:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005824:	00234917          	auipc	s2,0x234
    80005828:	30c90913          	add	s2,s2,780 # 80239b30 <disk+0x128>
  while(b->disk == 1) {
    8000582c:	4485                	li	s1,1
    8000582e:	00b79c63          	bne	a5,a1,80005846 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005832:	85ca                	mv	a1,s2
    80005834:	8552                	mv	a0,s4
    80005836:	ffffc097          	auipc	ra,0xffffc
    8000583a:	f0a080e7          	jalr	-246(ra) # 80001740 <sleep>
  while(b->disk == 1) {
    8000583e:	004a2783          	lw	a5,4(s4)
    80005842:	fe9788e3          	beq	a5,s1,80005832 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005846:	f9042903          	lw	s2,-112(s0)
    8000584a:	00290713          	add	a4,s2,2
    8000584e:	0712                	sll	a4,a4,0x4
    80005850:	00234797          	auipc	a5,0x234
    80005854:	1b878793          	add	a5,a5,440 # 80239a08 <disk>
    80005858:	97ba                	add	a5,a5,a4
    8000585a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000585e:	00234997          	auipc	s3,0x234
    80005862:	1aa98993          	add	s3,s3,426 # 80239a08 <disk>
    80005866:	00491713          	sll	a4,s2,0x4
    8000586a:	0009b783          	ld	a5,0(s3)
    8000586e:	97ba                	add	a5,a5,a4
    80005870:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005874:	854a                	mv	a0,s2
    80005876:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000587a:	00000097          	auipc	ra,0x0
    8000587e:	b9c080e7          	jalr	-1124(ra) # 80005416 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005882:	8885                	and	s1,s1,1
    80005884:	f0ed                	bnez	s1,80005866 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005886:	00234517          	auipc	a0,0x234
    8000588a:	2aa50513          	add	a0,a0,682 # 80239b30 <disk+0x128>
    8000588e:	00001097          	auipc	ra,0x1
    80005892:	be4080e7          	jalr	-1052(ra) # 80006472 <release>
}
    80005896:	70a6                	ld	ra,104(sp)
    80005898:	7406                	ld	s0,96(sp)
    8000589a:	64e6                	ld	s1,88(sp)
    8000589c:	6946                	ld	s2,80(sp)
    8000589e:	69a6                	ld	s3,72(sp)
    800058a0:	6a06                	ld	s4,64(sp)
    800058a2:	7ae2                	ld	s5,56(sp)
    800058a4:	7b42                	ld	s6,48(sp)
    800058a6:	7ba2                	ld	s7,40(sp)
    800058a8:	7c02                	ld	s8,32(sp)
    800058aa:	6ce2                	ld	s9,24(sp)
    800058ac:	6d42                	ld	s10,16(sp)
    800058ae:	6165                	add	sp,sp,112
    800058b0:	8082                	ret

00000000800058b2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058b2:	1101                	add	sp,sp,-32
    800058b4:	ec06                	sd	ra,24(sp)
    800058b6:	e822                	sd	s0,16(sp)
    800058b8:	e426                	sd	s1,8(sp)
    800058ba:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058bc:	00234497          	auipc	s1,0x234
    800058c0:	14c48493          	add	s1,s1,332 # 80239a08 <disk>
    800058c4:	00234517          	auipc	a0,0x234
    800058c8:	26c50513          	add	a0,a0,620 # 80239b30 <disk+0x128>
    800058cc:	00001097          	auipc	ra,0x1
    800058d0:	af2080e7          	jalr	-1294(ra) # 800063be <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058d4:	10001737          	lui	a4,0x10001
    800058d8:	533c                	lw	a5,96(a4)
    800058da:	8b8d                	and	a5,a5,3
    800058dc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058de:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058e2:	689c                	ld	a5,16(s1)
    800058e4:	0204d703          	lhu	a4,32(s1)
    800058e8:	0027d783          	lhu	a5,2(a5)
    800058ec:	04f70863          	beq	a4,a5,8000593c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800058f0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058f4:	6898                	ld	a4,16(s1)
    800058f6:	0204d783          	lhu	a5,32(s1)
    800058fa:	8b9d                	and	a5,a5,7
    800058fc:	078e                	sll	a5,a5,0x3
    800058fe:	97ba                	add	a5,a5,a4
    80005900:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005902:	00278713          	add	a4,a5,2
    80005906:	0712                	sll	a4,a4,0x4
    80005908:	9726                	add	a4,a4,s1
    8000590a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000590e:	e721                	bnez	a4,80005956 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005910:	0789                	add	a5,a5,2
    80005912:	0792                	sll	a5,a5,0x4
    80005914:	97a6                	add	a5,a5,s1
    80005916:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005918:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000591c:	ffffc097          	auipc	ra,0xffffc
    80005920:	e88080e7          	jalr	-376(ra) # 800017a4 <wakeup>

    disk.used_idx += 1;
    80005924:	0204d783          	lhu	a5,32(s1)
    80005928:	2785                	addw	a5,a5,1
    8000592a:	17c2                	sll	a5,a5,0x30
    8000592c:	93c1                	srl	a5,a5,0x30
    8000592e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005932:	6898                	ld	a4,16(s1)
    80005934:	00275703          	lhu	a4,2(a4)
    80005938:	faf71ce3          	bne	a4,a5,800058f0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000593c:	00234517          	auipc	a0,0x234
    80005940:	1f450513          	add	a0,a0,500 # 80239b30 <disk+0x128>
    80005944:	00001097          	auipc	ra,0x1
    80005948:	b2e080e7          	jalr	-1234(ra) # 80006472 <release>
}
    8000594c:	60e2                	ld	ra,24(sp)
    8000594e:	6442                	ld	s0,16(sp)
    80005950:	64a2                	ld	s1,8(sp)
    80005952:	6105                	add	sp,sp,32
    80005954:	8082                	ret
      panic("virtio_disk_intr status");
    80005956:	00003517          	auipc	a0,0x3
    8000595a:	e9250513          	add	a0,a0,-366 # 800087e8 <syscalls+0x3d8>
    8000595e:	00000097          	auipc	ra,0x0
    80005962:	528080e7          	jalr	1320(ra) # 80005e86 <panic>

0000000080005966 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005966:	1141                	add	sp,sp,-16
    80005968:	e422                	sd	s0,8(sp)
    8000596a:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000596c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005970:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005974:	0037979b          	sllw	a5,a5,0x3
    80005978:	02004737          	lui	a4,0x2004
    8000597c:	97ba                	add	a5,a5,a4
    8000597e:	0200c737          	lui	a4,0x200c
    80005982:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005986:	000f4637          	lui	a2,0xf4
    8000598a:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000598e:	9732                	add	a4,a4,a2
    80005990:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005992:	00259693          	sll	a3,a1,0x2
    80005996:	96ae                	add	a3,a3,a1
    80005998:	068e                	sll	a3,a3,0x3
    8000599a:	00234717          	auipc	a4,0x234
    8000599e:	1b670713          	add	a4,a4,438 # 80239b50 <timer_scratch>
    800059a2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059a4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059a6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059a8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059ac:	00000797          	auipc	a5,0x0
    800059b0:	9a478793          	add	a5,a5,-1628 # 80005350 <timervec>
    800059b4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059b8:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059bc:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059c0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059c4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059c8:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059cc:	30479073          	csrw	mie,a5
}
    800059d0:	6422                	ld	s0,8(sp)
    800059d2:	0141                	add	sp,sp,16
    800059d4:	8082                	ret

00000000800059d6 <start>:
{
    800059d6:	1141                	add	sp,sp,-16
    800059d8:	e406                	sd	ra,8(sp)
    800059da:	e022                	sd	s0,0(sp)
    800059dc:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059de:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059e2:	7779                	lui	a4,0xffffe
    800059e4:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbca6f>
    800059e8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059ea:	6705                	lui	a4,0x1
    800059ec:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059f0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059f2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059f6:	ffffb797          	auipc	a5,0xffffb
    800059fa:	aac78793          	add	a5,a5,-1364 # 800004a2 <main>
    800059fe:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a02:	4781                	li	a5,0
    80005a04:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a08:	67c1                	lui	a5,0x10
    80005a0a:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a0c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a10:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a14:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a18:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a1c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a20:	57fd                	li	a5,-1
    80005a22:	83a9                	srl	a5,a5,0xa
    80005a24:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a28:	47bd                	li	a5,15
    80005a2a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a2e:	00000097          	auipc	ra,0x0
    80005a32:	f38080e7          	jalr	-200(ra) # 80005966 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a36:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a3a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a3c:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a3e:	30200073          	mret
}
    80005a42:	60a2                	ld	ra,8(sp)
    80005a44:	6402                	ld	s0,0(sp)
    80005a46:	0141                	add	sp,sp,16
    80005a48:	8082                	ret

0000000080005a4a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a4a:	715d                	add	sp,sp,-80
    80005a4c:	e486                	sd	ra,72(sp)
    80005a4e:	e0a2                	sd	s0,64(sp)
    80005a50:	fc26                	sd	s1,56(sp)
    80005a52:	f84a                	sd	s2,48(sp)
    80005a54:	f44e                	sd	s3,40(sp)
    80005a56:	f052                	sd	s4,32(sp)
    80005a58:	ec56                	sd	s5,24(sp)
    80005a5a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a5c:	04c05763          	blez	a2,80005aaa <consolewrite+0x60>
    80005a60:	8a2a                	mv	s4,a0
    80005a62:	84ae                	mv	s1,a1
    80005a64:	89b2                	mv	s3,a2
    80005a66:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a68:	5afd                	li	s5,-1
    80005a6a:	4685                	li	a3,1
    80005a6c:	8626                	mv	a2,s1
    80005a6e:	85d2                	mv	a1,s4
    80005a70:	fbf40513          	add	a0,s0,-65
    80005a74:	ffffc097          	auipc	ra,0xffffc
    80005a78:	12a080e7          	jalr	298(ra) # 80001b9e <either_copyin>
    80005a7c:	01550d63          	beq	a0,s5,80005a96 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005a80:	fbf44503          	lbu	a0,-65(s0)
    80005a84:	00000097          	auipc	ra,0x0
    80005a88:	780080e7          	jalr	1920(ra) # 80006204 <uartputc>
  for(i = 0; i < n; i++){
    80005a8c:	2905                	addw	s2,s2,1
    80005a8e:	0485                	add	s1,s1,1
    80005a90:	fd299de3          	bne	s3,s2,80005a6a <consolewrite+0x20>
    80005a94:	894e                	mv	s2,s3
  }

  return i;
}
    80005a96:	854a                	mv	a0,s2
    80005a98:	60a6                	ld	ra,72(sp)
    80005a9a:	6406                	ld	s0,64(sp)
    80005a9c:	74e2                	ld	s1,56(sp)
    80005a9e:	7942                	ld	s2,48(sp)
    80005aa0:	79a2                	ld	s3,40(sp)
    80005aa2:	7a02                	ld	s4,32(sp)
    80005aa4:	6ae2                	ld	s5,24(sp)
    80005aa6:	6161                	add	sp,sp,80
    80005aa8:	8082                	ret
  for(i = 0; i < n; i++){
    80005aaa:	4901                	li	s2,0
    80005aac:	b7ed                	j	80005a96 <consolewrite+0x4c>

0000000080005aae <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005aae:	711d                	add	sp,sp,-96
    80005ab0:	ec86                	sd	ra,88(sp)
    80005ab2:	e8a2                	sd	s0,80(sp)
    80005ab4:	e4a6                	sd	s1,72(sp)
    80005ab6:	e0ca                	sd	s2,64(sp)
    80005ab8:	fc4e                	sd	s3,56(sp)
    80005aba:	f852                	sd	s4,48(sp)
    80005abc:	f456                	sd	s5,40(sp)
    80005abe:	f05a                	sd	s6,32(sp)
    80005ac0:	ec5e                	sd	s7,24(sp)
    80005ac2:	1080                	add	s0,sp,96
    80005ac4:	8aaa                	mv	s5,a0
    80005ac6:	8a2e                	mv	s4,a1
    80005ac8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005aca:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005ace:	0023c517          	auipc	a0,0x23c
    80005ad2:	1c250513          	add	a0,a0,450 # 80241c90 <cons>
    80005ad6:	00001097          	auipc	ra,0x1
    80005ada:	8e8080e7          	jalr	-1816(ra) # 800063be <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ade:	0023c497          	auipc	s1,0x23c
    80005ae2:	1b248493          	add	s1,s1,434 # 80241c90 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ae6:	0023c917          	auipc	s2,0x23c
    80005aea:	24290913          	add	s2,s2,578 # 80241d28 <cons+0x98>
  while(n > 0){
    80005aee:	09305263          	blez	s3,80005b72 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005af2:	0984a783          	lw	a5,152(s1)
    80005af6:	09c4a703          	lw	a4,156(s1)
    80005afa:	02f71763          	bne	a4,a5,80005b28 <consoleread+0x7a>
      if(killed(myproc())){
    80005afe:	ffffb097          	auipc	ra,0xffffb
    80005b02:	596080e7          	jalr	1430(ra) # 80001094 <myproc>
    80005b06:	ffffc097          	auipc	ra,0xffffc
    80005b0a:	ee2080e7          	jalr	-286(ra) # 800019e8 <killed>
    80005b0e:	ed2d                	bnez	a0,80005b88 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005b10:	85a6                	mv	a1,s1
    80005b12:	854a                	mv	a0,s2
    80005b14:	ffffc097          	auipc	ra,0xffffc
    80005b18:	c2c080e7          	jalr	-980(ra) # 80001740 <sleep>
    while(cons.r == cons.w){
    80005b1c:	0984a783          	lw	a5,152(s1)
    80005b20:	09c4a703          	lw	a4,156(s1)
    80005b24:	fcf70de3          	beq	a4,a5,80005afe <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b28:	0023c717          	auipc	a4,0x23c
    80005b2c:	16870713          	add	a4,a4,360 # 80241c90 <cons>
    80005b30:	0017869b          	addw	a3,a5,1
    80005b34:	08d72c23          	sw	a3,152(a4)
    80005b38:	07f7f693          	and	a3,a5,127
    80005b3c:	9736                	add	a4,a4,a3
    80005b3e:	01874703          	lbu	a4,24(a4)
    80005b42:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005b46:	4691                	li	a3,4
    80005b48:	06db8463          	beq	s7,a3,80005bb0 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005b4c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b50:	4685                	li	a3,1
    80005b52:	faf40613          	add	a2,s0,-81
    80005b56:	85d2                	mv	a1,s4
    80005b58:	8556                	mv	a0,s5
    80005b5a:	ffffc097          	auipc	ra,0xffffc
    80005b5e:	fee080e7          	jalr	-18(ra) # 80001b48 <either_copyout>
    80005b62:	57fd                	li	a5,-1
    80005b64:	00f50763          	beq	a0,a5,80005b72 <consoleread+0xc4>
      break;

    dst++;
    80005b68:	0a05                	add	s4,s4,1
    --n;
    80005b6a:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80005b6c:	47a9                	li	a5,10
    80005b6e:	f8fb90e3          	bne	s7,a5,80005aee <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b72:	0023c517          	auipc	a0,0x23c
    80005b76:	11e50513          	add	a0,a0,286 # 80241c90 <cons>
    80005b7a:	00001097          	auipc	ra,0x1
    80005b7e:	8f8080e7          	jalr	-1800(ra) # 80006472 <release>

  return target - n;
    80005b82:	413b053b          	subw	a0,s6,s3
    80005b86:	a811                	j	80005b9a <consoleread+0xec>
        release(&cons.lock);
    80005b88:	0023c517          	auipc	a0,0x23c
    80005b8c:	10850513          	add	a0,a0,264 # 80241c90 <cons>
    80005b90:	00001097          	auipc	ra,0x1
    80005b94:	8e2080e7          	jalr	-1822(ra) # 80006472 <release>
        return -1;
    80005b98:	557d                	li	a0,-1
}
    80005b9a:	60e6                	ld	ra,88(sp)
    80005b9c:	6446                	ld	s0,80(sp)
    80005b9e:	64a6                	ld	s1,72(sp)
    80005ba0:	6906                	ld	s2,64(sp)
    80005ba2:	79e2                	ld	s3,56(sp)
    80005ba4:	7a42                	ld	s4,48(sp)
    80005ba6:	7aa2                	ld	s5,40(sp)
    80005ba8:	7b02                	ld	s6,32(sp)
    80005baa:	6be2                	ld	s7,24(sp)
    80005bac:	6125                	add	sp,sp,96
    80005bae:	8082                	ret
      if(n < target){
    80005bb0:	0009871b          	sext.w	a4,s3
    80005bb4:	fb677fe3          	bgeu	a4,s6,80005b72 <consoleread+0xc4>
        cons.r--;
    80005bb8:	0023c717          	auipc	a4,0x23c
    80005bbc:	16f72823          	sw	a5,368(a4) # 80241d28 <cons+0x98>
    80005bc0:	bf4d                	j	80005b72 <consoleread+0xc4>

0000000080005bc2 <consputc>:
{
    80005bc2:	1141                	add	sp,sp,-16
    80005bc4:	e406                	sd	ra,8(sp)
    80005bc6:	e022                	sd	s0,0(sp)
    80005bc8:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80005bca:	10000793          	li	a5,256
    80005bce:	00f50a63          	beq	a0,a5,80005be2 <consputc+0x20>
    uartputc_sync(c);
    80005bd2:	00000097          	auipc	ra,0x0
    80005bd6:	560080e7          	jalr	1376(ra) # 80006132 <uartputc_sync>
}
    80005bda:	60a2                	ld	ra,8(sp)
    80005bdc:	6402                	ld	s0,0(sp)
    80005bde:	0141                	add	sp,sp,16
    80005be0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005be2:	4521                	li	a0,8
    80005be4:	00000097          	auipc	ra,0x0
    80005be8:	54e080e7          	jalr	1358(ra) # 80006132 <uartputc_sync>
    80005bec:	02000513          	li	a0,32
    80005bf0:	00000097          	auipc	ra,0x0
    80005bf4:	542080e7          	jalr	1346(ra) # 80006132 <uartputc_sync>
    80005bf8:	4521                	li	a0,8
    80005bfa:	00000097          	auipc	ra,0x0
    80005bfe:	538080e7          	jalr	1336(ra) # 80006132 <uartputc_sync>
    80005c02:	bfe1                	j	80005bda <consputc+0x18>

0000000080005c04 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c04:	1101                	add	sp,sp,-32
    80005c06:	ec06                	sd	ra,24(sp)
    80005c08:	e822                	sd	s0,16(sp)
    80005c0a:	e426                	sd	s1,8(sp)
    80005c0c:	e04a                	sd	s2,0(sp)
    80005c0e:	1000                	add	s0,sp,32
    80005c10:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c12:	0023c517          	auipc	a0,0x23c
    80005c16:	07e50513          	add	a0,a0,126 # 80241c90 <cons>
    80005c1a:	00000097          	auipc	ra,0x0
    80005c1e:	7a4080e7          	jalr	1956(ra) # 800063be <acquire>

  switch(c){
    80005c22:	47d5                	li	a5,21
    80005c24:	0af48663          	beq	s1,a5,80005cd0 <consoleintr+0xcc>
    80005c28:	0297ca63          	blt	a5,s1,80005c5c <consoleintr+0x58>
    80005c2c:	47a1                	li	a5,8
    80005c2e:	0ef48763          	beq	s1,a5,80005d1c <consoleintr+0x118>
    80005c32:	47c1                	li	a5,16
    80005c34:	10f49a63          	bne	s1,a5,80005d48 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c38:	ffffc097          	auipc	ra,0xffffc
    80005c3c:	fbc080e7          	jalr	-68(ra) # 80001bf4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c40:	0023c517          	auipc	a0,0x23c
    80005c44:	05050513          	add	a0,a0,80 # 80241c90 <cons>
    80005c48:	00001097          	auipc	ra,0x1
    80005c4c:	82a080e7          	jalr	-2006(ra) # 80006472 <release>
}
    80005c50:	60e2                	ld	ra,24(sp)
    80005c52:	6442                	ld	s0,16(sp)
    80005c54:	64a2                	ld	s1,8(sp)
    80005c56:	6902                	ld	s2,0(sp)
    80005c58:	6105                	add	sp,sp,32
    80005c5a:	8082                	ret
  switch(c){
    80005c5c:	07f00793          	li	a5,127
    80005c60:	0af48e63          	beq	s1,a5,80005d1c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c64:	0023c717          	auipc	a4,0x23c
    80005c68:	02c70713          	add	a4,a4,44 # 80241c90 <cons>
    80005c6c:	0a072783          	lw	a5,160(a4)
    80005c70:	09872703          	lw	a4,152(a4)
    80005c74:	9f99                	subw	a5,a5,a4
    80005c76:	07f00713          	li	a4,127
    80005c7a:	fcf763e3          	bltu	a4,a5,80005c40 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c7e:	47b5                	li	a5,13
    80005c80:	0cf48763          	beq	s1,a5,80005d4e <consoleintr+0x14a>
      consputc(c);
    80005c84:	8526                	mv	a0,s1
    80005c86:	00000097          	auipc	ra,0x0
    80005c8a:	f3c080e7          	jalr	-196(ra) # 80005bc2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c8e:	0023c797          	auipc	a5,0x23c
    80005c92:	00278793          	add	a5,a5,2 # 80241c90 <cons>
    80005c96:	0a07a683          	lw	a3,160(a5)
    80005c9a:	0016871b          	addw	a4,a3,1
    80005c9e:	0007061b          	sext.w	a2,a4
    80005ca2:	0ae7a023          	sw	a4,160(a5)
    80005ca6:	07f6f693          	and	a3,a3,127
    80005caa:	97b6                	add	a5,a5,a3
    80005cac:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005cb0:	47a9                	li	a5,10
    80005cb2:	0cf48563          	beq	s1,a5,80005d7c <consoleintr+0x178>
    80005cb6:	4791                	li	a5,4
    80005cb8:	0cf48263          	beq	s1,a5,80005d7c <consoleintr+0x178>
    80005cbc:	0023c797          	auipc	a5,0x23c
    80005cc0:	06c7a783          	lw	a5,108(a5) # 80241d28 <cons+0x98>
    80005cc4:	9f1d                	subw	a4,a4,a5
    80005cc6:	08000793          	li	a5,128
    80005cca:	f6f71be3          	bne	a4,a5,80005c40 <consoleintr+0x3c>
    80005cce:	a07d                	j	80005d7c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005cd0:	0023c717          	auipc	a4,0x23c
    80005cd4:	fc070713          	add	a4,a4,-64 # 80241c90 <cons>
    80005cd8:	0a072783          	lw	a5,160(a4)
    80005cdc:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ce0:	0023c497          	auipc	s1,0x23c
    80005ce4:	fb048493          	add	s1,s1,-80 # 80241c90 <cons>
    while(cons.e != cons.w &&
    80005ce8:	4929                	li	s2,10
    80005cea:	f4f70be3          	beq	a4,a5,80005c40 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cee:	37fd                	addw	a5,a5,-1
    80005cf0:	07f7f713          	and	a4,a5,127
    80005cf4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cf6:	01874703          	lbu	a4,24(a4)
    80005cfa:	f52703e3          	beq	a4,s2,80005c40 <consoleintr+0x3c>
      cons.e--;
    80005cfe:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d02:	10000513          	li	a0,256
    80005d06:	00000097          	auipc	ra,0x0
    80005d0a:	ebc080e7          	jalr	-324(ra) # 80005bc2 <consputc>
    while(cons.e != cons.w &&
    80005d0e:	0a04a783          	lw	a5,160(s1)
    80005d12:	09c4a703          	lw	a4,156(s1)
    80005d16:	fcf71ce3          	bne	a4,a5,80005cee <consoleintr+0xea>
    80005d1a:	b71d                	j	80005c40 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d1c:	0023c717          	auipc	a4,0x23c
    80005d20:	f7470713          	add	a4,a4,-140 # 80241c90 <cons>
    80005d24:	0a072783          	lw	a5,160(a4)
    80005d28:	09c72703          	lw	a4,156(a4)
    80005d2c:	f0f70ae3          	beq	a4,a5,80005c40 <consoleintr+0x3c>
      cons.e--;
    80005d30:	37fd                	addw	a5,a5,-1
    80005d32:	0023c717          	auipc	a4,0x23c
    80005d36:	fef72f23          	sw	a5,-2(a4) # 80241d30 <cons+0xa0>
      consputc(BACKSPACE);
    80005d3a:	10000513          	li	a0,256
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	e84080e7          	jalr	-380(ra) # 80005bc2 <consputc>
    80005d46:	bded                	j	80005c40 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d48:	ee048ce3          	beqz	s1,80005c40 <consoleintr+0x3c>
    80005d4c:	bf21                	j	80005c64 <consoleintr+0x60>
      consputc(c);
    80005d4e:	4529                	li	a0,10
    80005d50:	00000097          	auipc	ra,0x0
    80005d54:	e72080e7          	jalr	-398(ra) # 80005bc2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d58:	0023c797          	auipc	a5,0x23c
    80005d5c:	f3878793          	add	a5,a5,-200 # 80241c90 <cons>
    80005d60:	0a07a703          	lw	a4,160(a5)
    80005d64:	0017069b          	addw	a3,a4,1
    80005d68:	0006861b          	sext.w	a2,a3
    80005d6c:	0ad7a023          	sw	a3,160(a5)
    80005d70:	07f77713          	and	a4,a4,127
    80005d74:	97ba                	add	a5,a5,a4
    80005d76:	4729                	li	a4,10
    80005d78:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d7c:	0023c797          	auipc	a5,0x23c
    80005d80:	fac7a823          	sw	a2,-80(a5) # 80241d2c <cons+0x9c>
        wakeup(&cons.r);
    80005d84:	0023c517          	auipc	a0,0x23c
    80005d88:	fa450513          	add	a0,a0,-92 # 80241d28 <cons+0x98>
    80005d8c:	ffffc097          	auipc	ra,0xffffc
    80005d90:	a18080e7          	jalr	-1512(ra) # 800017a4 <wakeup>
    80005d94:	b575                	j	80005c40 <consoleintr+0x3c>

0000000080005d96 <consoleinit>:

void
consoleinit(void)
{
    80005d96:	1141                	add	sp,sp,-16
    80005d98:	e406                	sd	ra,8(sp)
    80005d9a:	e022                	sd	s0,0(sp)
    80005d9c:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d9e:	00003597          	auipc	a1,0x3
    80005da2:	a6258593          	add	a1,a1,-1438 # 80008800 <syscalls+0x3f0>
    80005da6:	0023c517          	auipc	a0,0x23c
    80005daa:	eea50513          	add	a0,a0,-278 # 80241c90 <cons>
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	580080e7          	jalr	1408(ra) # 8000632e <initlock>

  uartinit();
    80005db6:	00000097          	auipc	ra,0x0
    80005dba:	32c080e7          	jalr	812(ra) # 800060e2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dbe:	00233797          	auipc	a5,0x233
    80005dc2:	bf278793          	add	a5,a5,-1038 # 802389b0 <devsw>
    80005dc6:	00000717          	auipc	a4,0x0
    80005dca:	ce870713          	add	a4,a4,-792 # 80005aae <consoleread>
    80005dce:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005dd0:	00000717          	auipc	a4,0x0
    80005dd4:	c7a70713          	add	a4,a4,-902 # 80005a4a <consolewrite>
    80005dd8:	ef98                	sd	a4,24(a5)
}
    80005dda:	60a2                	ld	ra,8(sp)
    80005ddc:	6402                	ld	s0,0(sp)
    80005dde:	0141                	add	sp,sp,16
    80005de0:	8082                	ret

0000000080005de2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005de2:	7179                	add	sp,sp,-48
    80005de4:	f406                	sd	ra,40(sp)
    80005de6:	f022                	sd	s0,32(sp)
    80005de8:	ec26                	sd	s1,24(sp)
    80005dea:	e84a                	sd	s2,16(sp)
    80005dec:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005dee:	c219                	beqz	a2,80005df4 <printint+0x12>
    80005df0:	08054763          	bltz	a0,80005e7e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005df4:	2501                	sext.w	a0,a0
    80005df6:	4881                	li	a7,0
    80005df8:	fd040693          	add	a3,s0,-48

  i = 0;
    80005dfc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005dfe:	2581                	sext.w	a1,a1
    80005e00:	00003617          	auipc	a2,0x3
    80005e04:	a3060613          	add	a2,a2,-1488 # 80008830 <digits>
    80005e08:	883a                	mv	a6,a4
    80005e0a:	2705                	addw	a4,a4,1
    80005e0c:	02b577bb          	remuw	a5,a0,a1
    80005e10:	1782                	sll	a5,a5,0x20
    80005e12:	9381                	srl	a5,a5,0x20
    80005e14:	97b2                	add	a5,a5,a2
    80005e16:	0007c783          	lbu	a5,0(a5)
    80005e1a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e1e:	0005079b          	sext.w	a5,a0
    80005e22:	02b5553b          	divuw	a0,a0,a1
    80005e26:	0685                	add	a3,a3,1
    80005e28:	feb7f0e3          	bgeu	a5,a1,80005e08 <printint+0x26>

  if(sign)
    80005e2c:	00088c63          	beqz	a7,80005e44 <printint+0x62>
    buf[i++] = '-';
    80005e30:	fe070793          	add	a5,a4,-32
    80005e34:	00878733          	add	a4,a5,s0
    80005e38:	02d00793          	li	a5,45
    80005e3c:	fef70823          	sb	a5,-16(a4)
    80005e40:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005e44:	02e05763          	blez	a4,80005e72 <printint+0x90>
    80005e48:	fd040793          	add	a5,s0,-48
    80005e4c:	00e784b3          	add	s1,a5,a4
    80005e50:	fff78913          	add	s2,a5,-1
    80005e54:	993a                	add	s2,s2,a4
    80005e56:	377d                	addw	a4,a4,-1
    80005e58:	1702                	sll	a4,a4,0x20
    80005e5a:	9301                	srl	a4,a4,0x20
    80005e5c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e60:	fff4c503          	lbu	a0,-1(s1)
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	d5e080e7          	jalr	-674(ra) # 80005bc2 <consputc>
  while(--i >= 0)
    80005e6c:	14fd                	add	s1,s1,-1
    80005e6e:	ff2499e3          	bne	s1,s2,80005e60 <printint+0x7e>
}
    80005e72:	70a2                	ld	ra,40(sp)
    80005e74:	7402                	ld	s0,32(sp)
    80005e76:	64e2                	ld	s1,24(sp)
    80005e78:	6942                	ld	s2,16(sp)
    80005e7a:	6145                	add	sp,sp,48
    80005e7c:	8082                	ret
    x = -xx;
    80005e7e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e82:	4885                	li	a7,1
    x = -xx;
    80005e84:	bf95                	j	80005df8 <printint+0x16>

0000000080005e86 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e86:	1101                	add	sp,sp,-32
    80005e88:	ec06                	sd	ra,24(sp)
    80005e8a:	e822                	sd	s0,16(sp)
    80005e8c:	e426                	sd	s1,8(sp)
    80005e8e:	1000                	add	s0,sp,32
    80005e90:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e92:	0023c797          	auipc	a5,0x23c
    80005e96:	ea07af23          	sw	zero,-322(a5) # 80241d50 <pr+0x18>
  printf("panic: ");
    80005e9a:	00003517          	auipc	a0,0x3
    80005e9e:	96e50513          	add	a0,a0,-1682 # 80008808 <syscalls+0x3f8>
    80005ea2:	00000097          	auipc	ra,0x0
    80005ea6:	02e080e7          	jalr	46(ra) # 80005ed0 <printf>
  printf(s);
    80005eaa:	8526                	mv	a0,s1
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	024080e7          	jalr	36(ra) # 80005ed0 <printf>
  printf("\n");
    80005eb4:	00002517          	auipc	a0,0x2
    80005eb8:	1a450513          	add	a0,a0,420 # 80008058 <etext+0x58>
    80005ebc:	00000097          	auipc	ra,0x0
    80005ec0:	014080e7          	jalr	20(ra) # 80005ed0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ec4:	4785                	li	a5,1
    80005ec6:	00003717          	auipc	a4,0x3
    80005eca:	a2f72323          	sw	a5,-1498(a4) # 800088ec <panicked>
  for(;;)
    80005ece:	a001                	j	80005ece <panic+0x48>

0000000080005ed0 <printf>:
{
    80005ed0:	7131                	add	sp,sp,-192
    80005ed2:	fc86                	sd	ra,120(sp)
    80005ed4:	f8a2                	sd	s0,112(sp)
    80005ed6:	f4a6                	sd	s1,104(sp)
    80005ed8:	f0ca                	sd	s2,96(sp)
    80005eda:	ecce                	sd	s3,88(sp)
    80005edc:	e8d2                	sd	s4,80(sp)
    80005ede:	e4d6                	sd	s5,72(sp)
    80005ee0:	e0da                	sd	s6,64(sp)
    80005ee2:	fc5e                	sd	s7,56(sp)
    80005ee4:	f862                	sd	s8,48(sp)
    80005ee6:	f466                	sd	s9,40(sp)
    80005ee8:	f06a                	sd	s10,32(sp)
    80005eea:	ec6e                	sd	s11,24(sp)
    80005eec:	0100                	add	s0,sp,128
    80005eee:	8a2a                	mv	s4,a0
    80005ef0:	e40c                	sd	a1,8(s0)
    80005ef2:	e810                	sd	a2,16(s0)
    80005ef4:	ec14                	sd	a3,24(s0)
    80005ef6:	f018                	sd	a4,32(s0)
    80005ef8:	f41c                	sd	a5,40(s0)
    80005efa:	03043823          	sd	a6,48(s0)
    80005efe:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f02:	0023cd97          	auipc	s11,0x23c
    80005f06:	e4edad83          	lw	s11,-434(s11) # 80241d50 <pr+0x18>
  if(locking)
    80005f0a:	020d9b63          	bnez	s11,80005f40 <printf+0x70>
  if (fmt == 0)
    80005f0e:	040a0263          	beqz	s4,80005f52 <printf+0x82>
  va_start(ap, fmt);
    80005f12:	00840793          	add	a5,s0,8
    80005f16:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f1a:	000a4503          	lbu	a0,0(s4)
    80005f1e:	14050f63          	beqz	a0,8000607c <printf+0x1ac>
    80005f22:	4981                	li	s3,0
    if(c != '%'){
    80005f24:	02500a93          	li	s5,37
    switch(c){
    80005f28:	07000b93          	li	s7,112
  consputc('x');
    80005f2c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f2e:	00003b17          	auipc	s6,0x3
    80005f32:	902b0b13          	add	s6,s6,-1790 # 80008830 <digits>
    switch(c){
    80005f36:	07300c93          	li	s9,115
    80005f3a:	06400c13          	li	s8,100
    80005f3e:	a82d                	j	80005f78 <printf+0xa8>
    acquire(&pr.lock);
    80005f40:	0023c517          	auipc	a0,0x23c
    80005f44:	df850513          	add	a0,a0,-520 # 80241d38 <pr>
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	476080e7          	jalr	1142(ra) # 800063be <acquire>
    80005f50:	bf7d                	j	80005f0e <printf+0x3e>
    panic("null fmt");
    80005f52:	00003517          	auipc	a0,0x3
    80005f56:	8c650513          	add	a0,a0,-1850 # 80008818 <syscalls+0x408>
    80005f5a:	00000097          	auipc	ra,0x0
    80005f5e:	f2c080e7          	jalr	-212(ra) # 80005e86 <panic>
      consputc(c);
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	c60080e7          	jalr	-928(ra) # 80005bc2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f6a:	2985                	addw	s3,s3,1
    80005f6c:	013a07b3          	add	a5,s4,s3
    80005f70:	0007c503          	lbu	a0,0(a5)
    80005f74:	10050463          	beqz	a0,8000607c <printf+0x1ac>
    if(c != '%'){
    80005f78:	ff5515e3          	bne	a0,s5,80005f62 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f7c:	2985                	addw	s3,s3,1
    80005f7e:	013a07b3          	add	a5,s4,s3
    80005f82:	0007c783          	lbu	a5,0(a5)
    80005f86:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f8a:	cbed                	beqz	a5,8000607c <printf+0x1ac>
    switch(c){
    80005f8c:	05778a63          	beq	a5,s7,80005fe0 <printf+0x110>
    80005f90:	02fbf663          	bgeu	s7,a5,80005fbc <printf+0xec>
    80005f94:	09978863          	beq	a5,s9,80006024 <printf+0x154>
    80005f98:	07800713          	li	a4,120
    80005f9c:	0ce79563          	bne	a5,a4,80006066 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005fa0:	f8843783          	ld	a5,-120(s0)
    80005fa4:	00878713          	add	a4,a5,8
    80005fa8:	f8e43423          	sd	a4,-120(s0)
    80005fac:	4605                	li	a2,1
    80005fae:	85ea                	mv	a1,s10
    80005fb0:	4388                	lw	a0,0(a5)
    80005fb2:	00000097          	auipc	ra,0x0
    80005fb6:	e30080e7          	jalr	-464(ra) # 80005de2 <printint>
      break;
    80005fba:	bf45                	j	80005f6a <printf+0x9a>
    switch(c){
    80005fbc:	09578f63          	beq	a5,s5,8000605a <printf+0x18a>
    80005fc0:	0b879363          	bne	a5,s8,80006066 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005fc4:	f8843783          	ld	a5,-120(s0)
    80005fc8:	00878713          	add	a4,a5,8
    80005fcc:	f8e43423          	sd	a4,-120(s0)
    80005fd0:	4605                	li	a2,1
    80005fd2:	45a9                	li	a1,10
    80005fd4:	4388                	lw	a0,0(a5)
    80005fd6:	00000097          	auipc	ra,0x0
    80005fda:	e0c080e7          	jalr	-500(ra) # 80005de2 <printint>
      break;
    80005fde:	b771                	j	80005f6a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005fe0:	f8843783          	ld	a5,-120(s0)
    80005fe4:	00878713          	add	a4,a5,8
    80005fe8:	f8e43423          	sd	a4,-120(s0)
    80005fec:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005ff0:	03000513          	li	a0,48
    80005ff4:	00000097          	auipc	ra,0x0
    80005ff8:	bce080e7          	jalr	-1074(ra) # 80005bc2 <consputc>
  consputc('x');
    80005ffc:	07800513          	li	a0,120
    80006000:	00000097          	auipc	ra,0x0
    80006004:	bc2080e7          	jalr	-1086(ra) # 80005bc2 <consputc>
    80006008:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000600a:	03c95793          	srl	a5,s2,0x3c
    8000600e:	97da                	add	a5,a5,s6
    80006010:	0007c503          	lbu	a0,0(a5)
    80006014:	00000097          	auipc	ra,0x0
    80006018:	bae080e7          	jalr	-1106(ra) # 80005bc2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000601c:	0912                	sll	s2,s2,0x4
    8000601e:	34fd                	addw	s1,s1,-1
    80006020:	f4ed                	bnez	s1,8000600a <printf+0x13a>
    80006022:	b7a1                	j	80005f6a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006024:	f8843783          	ld	a5,-120(s0)
    80006028:	00878713          	add	a4,a5,8
    8000602c:	f8e43423          	sd	a4,-120(s0)
    80006030:	6384                	ld	s1,0(a5)
    80006032:	cc89                	beqz	s1,8000604c <printf+0x17c>
      for(; *s; s++)
    80006034:	0004c503          	lbu	a0,0(s1)
    80006038:	d90d                	beqz	a0,80005f6a <printf+0x9a>
        consputc(*s);
    8000603a:	00000097          	auipc	ra,0x0
    8000603e:	b88080e7          	jalr	-1144(ra) # 80005bc2 <consputc>
      for(; *s; s++)
    80006042:	0485                	add	s1,s1,1
    80006044:	0004c503          	lbu	a0,0(s1)
    80006048:	f96d                	bnez	a0,8000603a <printf+0x16a>
    8000604a:	b705                	j	80005f6a <printf+0x9a>
        s = "(null)";
    8000604c:	00002497          	auipc	s1,0x2
    80006050:	7c448493          	add	s1,s1,1988 # 80008810 <syscalls+0x400>
      for(; *s; s++)
    80006054:	02800513          	li	a0,40
    80006058:	b7cd                	j	8000603a <printf+0x16a>
      consputc('%');
    8000605a:	8556                	mv	a0,s5
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	b66080e7          	jalr	-1178(ra) # 80005bc2 <consputc>
      break;
    80006064:	b719                	j	80005f6a <printf+0x9a>
      consputc('%');
    80006066:	8556                	mv	a0,s5
    80006068:	00000097          	auipc	ra,0x0
    8000606c:	b5a080e7          	jalr	-1190(ra) # 80005bc2 <consputc>
      consputc(c);
    80006070:	8526                	mv	a0,s1
    80006072:	00000097          	auipc	ra,0x0
    80006076:	b50080e7          	jalr	-1200(ra) # 80005bc2 <consputc>
      break;
    8000607a:	bdc5                	j	80005f6a <printf+0x9a>
  if(locking)
    8000607c:	020d9163          	bnez	s11,8000609e <printf+0x1ce>
}
    80006080:	70e6                	ld	ra,120(sp)
    80006082:	7446                	ld	s0,112(sp)
    80006084:	74a6                	ld	s1,104(sp)
    80006086:	7906                	ld	s2,96(sp)
    80006088:	69e6                	ld	s3,88(sp)
    8000608a:	6a46                	ld	s4,80(sp)
    8000608c:	6aa6                	ld	s5,72(sp)
    8000608e:	6b06                	ld	s6,64(sp)
    80006090:	7be2                	ld	s7,56(sp)
    80006092:	7c42                	ld	s8,48(sp)
    80006094:	7ca2                	ld	s9,40(sp)
    80006096:	7d02                	ld	s10,32(sp)
    80006098:	6de2                	ld	s11,24(sp)
    8000609a:	6129                	add	sp,sp,192
    8000609c:	8082                	ret
    release(&pr.lock);
    8000609e:	0023c517          	auipc	a0,0x23c
    800060a2:	c9a50513          	add	a0,a0,-870 # 80241d38 <pr>
    800060a6:	00000097          	auipc	ra,0x0
    800060aa:	3cc080e7          	jalr	972(ra) # 80006472 <release>
}
    800060ae:	bfc9                	j	80006080 <printf+0x1b0>

00000000800060b0 <printfinit>:
    ;
}

void
printfinit(void)
{
    800060b0:	1101                	add	sp,sp,-32
    800060b2:	ec06                	sd	ra,24(sp)
    800060b4:	e822                	sd	s0,16(sp)
    800060b6:	e426                	sd	s1,8(sp)
    800060b8:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    800060ba:	0023c497          	auipc	s1,0x23c
    800060be:	c7e48493          	add	s1,s1,-898 # 80241d38 <pr>
    800060c2:	00002597          	auipc	a1,0x2
    800060c6:	76658593          	add	a1,a1,1894 # 80008828 <syscalls+0x418>
    800060ca:	8526                	mv	a0,s1
    800060cc:	00000097          	auipc	ra,0x0
    800060d0:	262080e7          	jalr	610(ra) # 8000632e <initlock>
  pr.locking = 1;
    800060d4:	4785                	li	a5,1
    800060d6:	cc9c                	sw	a5,24(s1)
}
    800060d8:	60e2                	ld	ra,24(sp)
    800060da:	6442                	ld	s0,16(sp)
    800060dc:	64a2                	ld	s1,8(sp)
    800060de:	6105                	add	sp,sp,32
    800060e0:	8082                	ret

00000000800060e2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060e2:	1141                	add	sp,sp,-16
    800060e4:	e406                	sd	ra,8(sp)
    800060e6:	e022                	sd	s0,0(sp)
    800060e8:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060ea:	100007b7          	lui	a5,0x10000
    800060ee:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060f2:	f8000713          	li	a4,-128
    800060f6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060fa:	470d                	li	a4,3
    800060fc:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006100:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006104:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006108:	469d                	li	a3,7
    8000610a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000610e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006112:	00002597          	auipc	a1,0x2
    80006116:	73658593          	add	a1,a1,1846 # 80008848 <digits+0x18>
    8000611a:	0023c517          	auipc	a0,0x23c
    8000611e:	c3e50513          	add	a0,a0,-962 # 80241d58 <uart_tx_lock>
    80006122:	00000097          	auipc	ra,0x0
    80006126:	20c080e7          	jalr	524(ra) # 8000632e <initlock>
}
    8000612a:	60a2                	ld	ra,8(sp)
    8000612c:	6402                	ld	s0,0(sp)
    8000612e:	0141                	add	sp,sp,16
    80006130:	8082                	ret

0000000080006132 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006132:	1101                	add	sp,sp,-32
    80006134:	ec06                	sd	ra,24(sp)
    80006136:	e822                	sd	s0,16(sp)
    80006138:	e426                	sd	s1,8(sp)
    8000613a:	1000                	add	s0,sp,32
    8000613c:	84aa                	mv	s1,a0
  push_off();
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	234080e7          	jalr	564(ra) # 80006372 <push_off>

  if(panicked){
    80006146:	00002797          	auipc	a5,0x2
    8000614a:	7a67a783          	lw	a5,1958(a5) # 800088ec <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000614e:	10000737          	lui	a4,0x10000
  if(panicked){
    80006152:	c391                	beqz	a5,80006156 <uartputc_sync+0x24>
    for(;;)
    80006154:	a001                	j	80006154 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006156:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000615a:	0207f793          	and	a5,a5,32
    8000615e:	dfe5                	beqz	a5,80006156 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006160:	0ff4f513          	zext.b	a0,s1
    80006164:	100007b7          	lui	a5,0x10000
    80006168:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000616c:	00000097          	auipc	ra,0x0
    80006170:	2a6080e7          	jalr	678(ra) # 80006412 <pop_off>
}
    80006174:	60e2                	ld	ra,24(sp)
    80006176:	6442                	ld	s0,16(sp)
    80006178:	64a2                	ld	s1,8(sp)
    8000617a:	6105                	add	sp,sp,32
    8000617c:	8082                	ret

000000008000617e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000617e:	00002797          	auipc	a5,0x2
    80006182:	7727b783          	ld	a5,1906(a5) # 800088f0 <uart_tx_r>
    80006186:	00002717          	auipc	a4,0x2
    8000618a:	77273703          	ld	a4,1906(a4) # 800088f8 <uart_tx_w>
    8000618e:	06f70a63          	beq	a4,a5,80006202 <uartstart+0x84>
{
    80006192:	7139                	add	sp,sp,-64
    80006194:	fc06                	sd	ra,56(sp)
    80006196:	f822                	sd	s0,48(sp)
    80006198:	f426                	sd	s1,40(sp)
    8000619a:	f04a                	sd	s2,32(sp)
    8000619c:	ec4e                	sd	s3,24(sp)
    8000619e:	e852                	sd	s4,16(sp)
    800061a0:	e456                	sd	s5,8(sp)
    800061a2:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061a4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061a8:	0023ca17          	auipc	s4,0x23c
    800061ac:	bb0a0a13          	add	s4,s4,-1104 # 80241d58 <uart_tx_lock>
    uart_tx_r += 1;
    800061b0:	00002497          	auipc	s1,0x2
    800061b4:	74048493          	add	s1,s1,1856 # 800088f0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061b8:	00002997          	auipc	s3,0x2
    800061bc:	74098993          	add	s3,s3,1856 # 800088f8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061c0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061c4:	02077713          	and	a4,a4,32
    800061c8:	c705                	beqz	a4,800061f0 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061ca:	01f7f713          	and	a4,a5,31
    800061ce:	9752                	add	a4,a4,s4
    800061d0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800061d4:	0785                	add	a5,a5,1
    800061d6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061d8:	8526                	mv	a0,s1
    800061da:	ffffb097          	auipc	ra,0xffffb
    800061de:	5ca080e7          	jalr	1482(ra) # 800017a4 <wakeup>
    
    WriteReg(THR, c);
    800061e2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061e6:	609c                	ld	a5,0(s1)
    800061e8:	0009b703          	ld	a4,0(s3)
    800061ec:	fcf71ae3          	bne	a4,a5,800061c0 <uartstart+0x42>
  }
}
    800061f0:	70e2                	ld	ra,56(sp)
    800061f2:	7442                	ld	s0,48(sp)
    800061f4:	74a2                	ld	s1,40(sp)
    800061f6:	7902                	ld	s2,32(sp)
    800061f8:	69e2                	ld	s3,24(sp)
    800061fa:	6a42                	ld	s4,16(sp)
    800061fc:	6aa2                	ld	s5,8(sp)
    800061fe:	6121                	add	sp,sp,64
    80006200:	8082                	ret
    80006202:	8082                	ret

0000000080006204 <uartputc>:
{
    80006204:	7179                	add	sp,sp,-48
    80006206:	f406                	sd	ra,40(sp)
    80006208:	f022                	sd	s0,32(sp)
    8000620a:	ec26                	sd	s1,24(sp)
    8000620c:	e84a                	sd	s2,16(sp)
    8000620e:	e44e                	sd	s3,8(sp)
    80006210:	e052                	sd	s4,0(sp)
    80006212:	1800                	add	s0,sp,48
    80006214:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006216:	0023c517          	auipc	a0,0x23c
    8000621a:	b4250513          	add	a0,a0,-1214 # 80241d58 <uart_tx_lock>
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	1a0080e7          	jalr	416(ra) # 800063be <acquire>
  if(panicked){
    80006226:	00002797          	auipc	a5,0x2
    8000622a:	6c67a783          	lw	a5,1734(a5) # 800088ec <panicked>
    8000622e:	e7c9                	bnez	a5,800062b8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006230:	00002717          	auipc	a4,0x2
    80006234:	6c873703          	ld	a4,1736(a4) # 800088f8 <uart_tx_w>
    80006238:	00002797          	auipc	a5,0x2
    8000623c:	6b87b783          	ld	a5,1720(a5) # 800088f0 <uart_tx_r>
    80006240:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006244:	0023c997          	auipc	s3,0x23c
    80006248:	b1498993          	add	s3,s3,-1260 # 80241d58 <uart_tx_lock>
    8000624c:	00002497          	auipc	s1,0x2
    80006250:	6a448493          	add	s1,s1,1700 # 800088f0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006254:	00002917          	auipc	s2,0x2
    80006258:	6a490913          	add	s2,s2,1700 # 800088f8 <uart_tx_w>
    8000625c:	00e79f63          	bne	a5,a4,8000627a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006260:	85ce                	mv	a1,s3
    80006262:	8526                	mv	a0,s1
    80006264:	ffffb097          	auipc	ra,0xffffb
    80006268:	4dc080e7          	jalr	1244(ra) # 80001740 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000626c:	00093703          	ld	a4,0(s2)
    80006270:	609c                	ld	a5,0(s1)
    80006272:	02078793          	add	a5,a5,32
    80006276:	fee785e3          	beq	a5,a4,80006260 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000627a:	0023c497          	auipc	s1,0x23c
    8000627e:	ade48493          	add	s1,s1,-1314 # 80241d58 <uart_tx_lock>
    80006282:	01f77793          	and	a5,a4,31
    80006286:	97a6                	add	a5,a5,s1
    80006288:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000628c:	0705                	add	a4,a4,1
    8000628e:	00002797          	auipc	a5,0x2
    80006292:	66e7b523          	sd	a4,1642(a5) # 800088f8 <uart_tx_w>
  uartstart();
    80006296:	00000097          	auipc	ra,0x0
    8000629a:	ee8080e7          	jalr	-280(ra) # 8000617e <uartstart>
  release(&uart_tx_lock);
    8000629e:	8526                	mv	a0,s1
    800062a0:	00000097          	auipc	ra,0x0
    800062a4:	1d2080e7          	jalr	466(ra) # 80006472 <release>
}
    800062a8:	70a2                	ld	ra,40(sp)
    800062aa:	7402                	ld	s0,32(sp)
    800062ac:	64e2                	ld	s1,24(sp)
    800062ae:	6942                	ld	s2,16(sp)
    800062b0:	69a2                	ld	s3,8(sp)
    800062b2:	6a02                	ld	s4,0(sp)
    800062b4:	6145                	add	sp,sp,48
    800062b6:	8082                	ret
    for(;;)
    800062b8:	a001                	j	800062b8 <uartputc+0xb4>

00000000800062ba <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062ba:	1141                	add	sp,sp,-16
    800062bc:	e422                	sd	s0,8(sp)
    800062be:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062c0:	100007b7          	lui	a5,0x10000
    800062c4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062c8:	8b85                	and	a5,a5,1
    800062ca:	cb81                	beqz	a5,800062da <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800062cc:	100007b7          	lui	a5,0x10000
    800062d0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800062d4:	6422                	ld	s0,8(sp)
    800062d6:	0141                	add	sp,sp,16
    800062d8:	8082                	ret
    return -1;
    800062da:	557d                	li	a0,-1
    800062dc:	bfe5                	j	800062d4 <uartgetc+0x1a>

00000000800062de <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062de:	1101                	add	sp,sp,-32
    800062e0:	ec06                	sd	ra,24(sp)
    800062e2:	e822                	sd	s0,16(sp)
    800062e4:	e426                	sd	s1,8(sp)
    800062e6:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062e8:	54fd                	li	s1,-1
    800062ea:	a029                	j	800062f4 <uartintr+0x16>
      break;
    consoleintr(c);
    800062ec:	00000097          	auipc	ra,0x0
    800062f0:	918080e7          	jalr	-1768(ra) # 80005c04 <consoleintr>
    int c = uartgetc();
    800062f4:	00000097          	auipc	ra,0x0
    800062f8:	fc6080e7          	jalr	-58(ra) # 800062ba <uartgetc>
    if(c == -1)
    800062fc:	fe9518e3          	bne	a0,s1,800062ec <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006300:	0023c497          	auipc	s1,0x23c
    80006304:	a5848493          	add	s1,s1,-1448 # 80241d58 <uart_tx_lock>
    80006308:	8526                	mv	a0,s1
    8000630a:	00000097          	auipc	ra,0x0
    8000630e:	0b4080e7          	jalr	180(ra) # 800063be <acquire>
  uartstart();
    80006312:	00000097          	auipc	ra,0x0
    80006316:	e6c080e7          	jalr	-404(ra) # 8000617e <uartstart>
  release(&uart_tx_lock);
    8000631a:	8526                	mv	a0,s1
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	156080e7          	jalr	342(ra) # 80006472 <release>
}
    80006324:	60e2                	ld	ra,24(sp)
    80006326:	6442                	ld	s0,16(sp)
    80006328:	64a2                	ld	s1,8(sp)
    8000632a:	6105                	add	sp,sp,32
    8000632c:	8082                	ret

000000008000632e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000632e:	1141                	add	sp,sp,-16
    80006330:	e422                	sd	s0,8(sp)
    80006332:	0800                	add	s0,sp,16
  lk->name = name;
    80006334:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006336:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000633a:	00053823          	sd	zero,16(a0)
}
    8000633e:	6422                	ld	s0,8(sp)
    80006340:	0141                	add	sp,sp,16
    80006342:	8082                	ret

0000000080006344 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006344:	411c                	lw	a5,0(a0)
    80006346:	e399                	bnez	a5,8000634c <holding+0x8>
    80006348:	4501                	li	a0,0
  return r;
}
    8000634a:	8082                	ret
{
    8000634c:	1101                	add	sp,sp,-32
    8000634e:	ec06                	sd	ra,24(sp)
    80006350:	e822                	sd	s0,16(sp)
    80006352:	e426                	sd	s1,8(sp)
    80006354:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006356:	6904                	ld	s1,16(a0)
    80006358:	ffffb097          	auipc	ra,0xffffb
    8000635c:	d20080e7          	jalr	-736(ra) # 80001078 <mycpu>
    80006360:	40a48533          	sub	a0,s1,a0
    80006364:	00153513          	seqz	a0,a0
}
    80006368:	60e2                	ld	ra,24(sp)
    8000636a:	6442                	ld	s0,16(sp)
    8000636c:	64a2                	ld	s1,8(sp)
    8000636e:	6105                	add	sp,sp,32
    80006370:	8082                	ret

0000000080006372 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006372:	1101                	add	sp,sp,-32
    80006374:	ec06                	sd	ra,24(sp)
    80006376:	e822                	sd	s0,16(sp)
    80006378:	e426                	sd	s1,8(sp)
    8000637a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000637c:	100024f3          	csrr	s1,sstatus
    80006380:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006384:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006386:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000638a:	ffffb097          	auipc	ra,0xffffb
    8000638e:	cee080e7          	jalr	-786(ra) # 80001078 <mycpu>
    80006392:	5d3c                	lw	a5,120(a0)
    80006394:	cf89                	beqz	a5,800063ae <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006396:	ffffb097          	auipc	ra,0xffffb
    8000639a:	ce2080e7          	jalr	-798(ra) # 80001078 <mycpu>
    8000639e:	5d3c                	lw	a5,120(a0)
    800063a0:	2785                	addw	a5,a5,1
    800063a2:	dd3c                	sw	a5,120(a0)
}
    800063a4:	60e2                	ld	ra,24(sp)
    800063a6:	6442                	ld	s0,16(sp)
    800063a8:	64a2                	ld	s1,8(sp)
    800063aa:	6105                	add	sp,sp,32
    800063ac:	8082                	ret
    mycpu()->intena = old;
    800063ae:	ffffb097          	auipc	ra,0xffffb
    800063b2:	cca080e7          	jalr	-822(ra) # 80001078 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063b6:	8085                	srl	s1,s1,0x1
    800063b8:	8885                	and	s1,s1,1
    800063ba:	dd64                	sw	s1,124(a0)
    800063bc:	bfe9                	j	80006396 <push_off+0x24>

00000000800063be <acquire>:
{
    800063be:	1101                	add	sp,sp,-32
    800063c0:	ec06                	sd	ra,24(sp)
    800063c2:	e822                	sd	s0,16(sp)
    800063c4:	e426                	sd	s1,8(sp)
    800063c6:	1000                	add	s0,sp,32
    800063c8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063ca:	00000097          	auipc	ra,0x0
    800063ce:	fa8080e7          	jalr	-88(ra) # 80006372 <push_off>
  if(holding(lk))
    800063d2:	8526                	mv	a0,s1
    800063d4:	00000097          	auipc	ra,0x0
    800063d8:	f70080e7          	jalr	-144(ra) # 80006344 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063dc:	4705                	li	a4,1
  if(holding(lk))
    800063de:	e115                	bnez	a0,80006402 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063e0:	87ba                	mv	a5,a4
    800063e2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063e6:	2781                	sext.w	a5,a5
    800063e8:	ffe5                	bnez	a5,800063e0 <acquire+0x22>
  __sync_synchronize();
    800063ea:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063ee:	ffffb097          	auipc	ra,0xffffb
    800063f2:	c8a080e7          	jalr	-886(ra) # 80001078 <mycpu>
    800063f6:	e888                	sd	a0,16(s1)
}
    800063f8:	60e2                	ld	ra,24(sp)
    800063fa:	6442                	ld	s0,16(sp)
    800063fc:	64a2                	ld	s1,8(sp)
    800063fe:	6105                	add	sp,sp,32
    80006400:	8082                	ret
    panic("acquire");
    80006402:	00002517          	auipc	a0,0x2
    80006406:	44e50513          	add	a0,a0,1102 # 80008850 <digits+0x20>
    8000640a:	00000097          	auipc	ra,0x0
    8000640e:	a7c080e7          	jalr	-1412(ra) # 80005e86 <panic>

0000000080006412 <pop_off>:

void
pop_off(void)
{
    80006412:	1141                	add	sp,sp,-16
    80006414:	e406                	sd	ra,8(sp)
    80006416:	e022                	sd	s0,0(sp)
    80006418:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    8000641a:	ffffb097          	auipc	ra,0xffffb
    8000641e:	c5e080e7          	jalr	-930(ra) # 80001078 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006422:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006426:	8b89                	and	a5,a5,2
  if(intr_get())
    80006428:	e78d                	bnez	a5,80006452 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000642a:	5d3c                	lw	a5,120(a0)
    8000642c:	02f05b63          	blez	a5,80006462 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006430:	37fd                	addw	a5,a5,-1
    80006432:	0007871b          	sext.w	a4,a5
    80006436:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006438:	eb09                	bnez	a4,8000644a <pop_off+0x38>
    8000643a:	5d7c                	lw	a5,124(a0)
    8000643c:	c799                	beqz	a5,8000644a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000643e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006442:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006446:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000644a:	60a2                	ld	ra,8(sp)
    8000644c:	6402                	ld	s0,0(sp)
    8000644e:	0141                	add	sp,sp,16
    80006450:	8082                	ret
    panic("pop_off - interruptible");
    80006452:	00002517          	auipc	a0,0x2
    80006456:	40650513          	add	a0,a0,1030 # 80008858 <digits+0x28>
    8000645a:	00000097          	auipc	ra,0x0
    8000645e:	a2c080e7          	jalr	-1492(ra) # 80005e86 <panic>
    panic("pop_off");
    80006462:	00002517          	auipc	a0,0x2
    80006466:	40e50513          	add	a0,a0,1038 # 80008870 <digits+0x40>
    8000646a:	00000097          	auipc	ra,0x0
    8000646e:	a1c080e7          	jalr	-1508(ra) # 80005e86 <panic>

0000000080006472 <release>:
{
    80006472:	1101                	add	sp,sp,-32
    80006474:	ec06                	sd	ra,24(sp)
    80006476:	e822                	sd	s0,16(sp)
    80006478:	e426                	sd	s1,8(sp)
    8000647a:	1000                	add	s0,sp,32
    8000647c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000647e:	00000097          	auipc	ra,0x0
    80006482:	ec6080e7          	jalr	-314(ra) # 80006344 <holding>
    80006486:	c115                	beqz	a0,800064aa <release+0x38>
  lk->cpu = 0;
    80006488:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000648c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006490:	0f50000f          	fence	iorw,ow
    80006494:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006498:	00000097          	auipc	ra,0x0
    8000649c:	f7a080e7          	jalr	-134(ra) # 80006412 <pop_off>
}
    800064a0:	60e2                	ld	ra,24(sp)
    800064a2:	6442                	ld	s0,16(sp)
    800064a4:	64a2                	ld	s1,8(sp)
    800064a6:	6105                	add	sp,sp,32
    800064a8:	8082                	ret
    panic("release");
    800064aa:	00002517          	auipc	a0,0x2
    800064ae:	3ce50513          	add	a0,a0,974 # 80008878 <digits+0x48>
    800064b2:	00000097          	auipc	ra,0x0
    800064b6:	9d4080e7          	jalr	-1580(ra) # 80005e86 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	sll	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	sll	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
