
obj/fs/fs:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 d5 31 00 00       	callq  803216 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 14          	sub    $0x14,%rsp
  80004b:	89 f8                	mov    %edi,%eax
  80004d:	88 45 ec             	mov    %al,-0x14(%rbp)
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800050:	90                   	nop
  800051:	c7 45 f8 f7 01 00 00 	movl   $0x1f7,-0x8(%rbp)

    static __inline uint8_t
inb(int port)
{
    uint8_t data;
    __asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800058:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80005b:	89 c2                	mov    %eax,%edx
  80005d:	ec                   	in     (%dx),%al
  80005e:	88 45 f7             	mov    %al,-0x9(%rbp)
    return data;
  800061:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800065:	0f b6 c0             	movzbl %al,%eax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006e:	25 c0 00 00 00       	and    $0xc0,%eax
  800073:	83 f8 40             	cmp    $0x40,%eax
  800076:	75 d9                	jne    800051 <ide_wait_ready+0xe>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800078:	80 7d ec 00          	cmpb   $0x0,-0x14(%rbp)
  80007c:	74 11                	je     80008f <ide_wait_ready+0x4c>
  80007e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800081:	83 e0 21             	and    $0x21,%eax
  800084:	85 c0                	test   %eax,%eax
  800086:	74 07                	je     80008f <ide_wait_ready+0x4c>
		return -1;
  800088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80008d:	eb 05                	jmp    800094 <ide_wait_ready+0x51>
	return 0;
  80008f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800094:	c9                   	leaveq 
  800095:	c3                   	retq   

0000000000800096 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800096:	55                   	push   %rbp
  800097:	48 89 e5             	mov    %rsp,%rbp
  80009a:	48 83 ec 20          	sub    $0x20,%rsp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80009e:	bf 00 00 00 00       	mov    $0x0,%edi
  8000a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	c7 45 f4 f6 01 00 00 	movl   $0x1f6,-0xc(%rbp)
  8000b6:	c6 45 f3 f0          	movb   $0xf0,-0xd(%rbp)
}

    static __inline void
outb(int port, uint8_t data)
{
    __asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000ba:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  8000be:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000c1:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000c9:	eb 04                	jmp    8000cf <ide_probe_disk1+0x39>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000cf:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  8000d6:	7f 26                	jg     8000fe <ide_probe_disk1+0x68>
  8000d8:	c7 45 ec f7 01 00 00 	movl   $0x1f7,-0x14(%rbp)

    static __inline uint8_t
inb(int port)
{
    uint8_t data;
    __asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e2:	89 c2                	mov    %eax,%edx
  8000e4:	ec                   	in     (%dx),%al
  8000e5:	88 45 eb             	mov    %al,-0x15(%rbp)
    return data;
  8000e8:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000ec:	0f b6 c0             	movzbl %al,%eax
  8000ef:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000f5:	25 a1 00 00 00       	and    $0xa1,%eax
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	75 cd                	jne    8000cb <ide_probe_disk1+0x35>
  8000fe:	c7 45 e4 f6 01 00 00 	movl   $0x1f6,-0x1c(%rbp)
  800105:	c6 45 e3 e0          	movb   $0xe0,-0x1d(%rbp)
}

    static __inline void
outb(int port, uint8_t data)
{
    __asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800109:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  80010d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800110:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800111:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800118:	0f 9e c0             	setle  %al
  80011b:	0f b6 c0             	movzbl %al,%eax
  80011e:	89 c6                	mov    %eax,%esi
  800120:	48 bf 40 6d 80 00 00 	movabs $0x806d40,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  800136:	00 00 00 
  800139:	ff d2                	callq  *%rdx
	return (x < 1000);
  80013b:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800142:	0f 9e c0             	setle  %al
}
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <ide_set_disk>:

void
ide_set_disk(int d)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (d != 0 && d != 1)
  800152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800156:	74 30                	je     800188 <ide_set_disk+0x41>
  800158:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  80015c:	74 2a                	je     800188 <ide_set_disk+0x41>
		panic("bad disk number");
  80015e:	48 ba 57 6d 80 00 00 	movabs $0x806d57,%rdx
  800165:	00 00 00 
  800168:	be 3a 00 00 00       	mov    $0x3a,%esi
  80016d:	48 bf 67 6d 80 00 00 	movabs $0x806d67,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 bc 32 80 00 00 	movabs $0x8032bc,%rcx
  800183:	00 00 00 
  800186:	ff d1                	callq  *%rcx
	diskno = d;
  800188:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80018f:	00 00 00 
  800192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800195:	89 10                	mov    %edx,(%rax)
}
  800197:	c9                   	leaveq 
  800198:	c3                   	retq   

0000000000800199 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800199:	55                   	push   %rbp
  80019a:	48 89 e5             	mov    %rsp,%rbp
  80019d:	48 83 ec 70          	sub    $0x70,%rsp
  8001a1:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8001a4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8001a8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  8001ac:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  8001b3:	00 
  8001b4:	76 35                	jbe    8001eb <ide_read+0x52>
  8001b6:	48 b9 70 6d 80 00 00 	movabs $0x806d70,%rcx
  8001bd:	00 00 00 
  8001c0:	48 ba 7d 6d 80 00 00 	movabs $0x806d7d,%rdx
  8001c7:	00 00 00 
  8001ca:	be 43 00 00 00       	mov    $0x43,%esi
  8001cf:	48 bf 67 6d 80 00 00 	movabs $0x806d67,%rdi
  8001d6:	00 00 00 
  8001d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001de:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  8001e5:	00 00 00 
  8001e8:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  8001eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  8001fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800200:	0f b6 c0             	movzbl %al,%eax
  800203:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  80020a:	88 45 f7             	mov    %al,-0x9(%rbp)
  80020d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800211:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800214:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800215:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800218:	0f b6 c0             	movzbl %al,%eax
  80021b:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  800222:	88 45 ef             	mov    %al,-0x11(%rbp)
  800225:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800229:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80022c:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  80022d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800230:	c1 e8 08             	shr    $0x8,%eax
  800233:	0f b6 c0             	movzbl %al,%eax
  800236:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  80023d:	88 45 e7             	mov    %al,-0x19(%rbp)
  800240:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  800244:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800247:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800248:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80024b:	c1 e8 10             	shr    $0x10,%eax
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  800258:	88 45 df             	mov    %al,-0x21(%rbp)
  80025b:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80025f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800262:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800263:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	83 e0 01             	and    $0x1,%eax
  800272:	c1 e0 04             	shl    $0x4,%eax
  800275:	89 c2                	mov    %eax,%edx
  800277:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80027a:	c1 e8 18             	shr    $0x18,%eax
  80027d:	83 e0 0f             	and    $0xf,%eax
  800280:	09 d0                	or     %edx,%eax
  800282:	83 c8 e0             	or     $0xffffffe0,%eax
  800285:	0f b6 c0             	movzbl %al,%eax
  800288:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  80028f:	88 45 d7             	mov    %al,-0x29(%rbp)
  800292:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  800296:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800299:	ee                   	out    %al,(%dx)
  80029a:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  8002a1:	c6 45 cf 20          	movb   $0x20,-0x31(%rbp)
  8002a5:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  8002a9:	8b 55 d0             	mov    -0x30(%rbp),%edx
  8002ac:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002ad:	eb 64                	jmp    800313 <ide_read+0x17a>
		if ((r = ide_wait_ready(1)) < 0)
  8002af:	bf 01 00 00 00       	mov    $0x1,%edi
  8002b4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c7:	79 05                	jns    8002ce <ide_read+0x135>
			return r;
  8002c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cc:	eb 51                	jmp    80031f <ide_read+0x186>
  8002ce:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  8002d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8002d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002dd:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

    static __inline void
insw(int port, void *addr, int cnt)
{
    __asm __volatile("cld\n\trepne\n\tinsw"			:
  8002e4:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8002e7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8002eb:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8002ee:	48 89 ce             	mov    %rcx,%rsi
  8002f1:	48 89 f7             	mov    %rsi,%rdi
  8002f4:	89 c1                	mov    %eax,%ecx
  8002f6:	fc                   	cld    
  8002f7:	f2 66 6d             	repnz insw (%dx),%es:(%rdi)
  8002fa:	89 c8                	mov    %ecx,%eax
  8002fc:	48 89 fe             	mov    %rdi,%rsi
  8002ff:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800303:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800306:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80030b:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800312:	00 
  800313:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  800318:	75 95                	jne    8002af <ide_read+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insw(0x1F0, dst, SECTSIZE/2);
	}

	return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031f:	c9                   	leaveq 
  800320:	c3                   	retq   

0000000000800321 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800321:	55                   	push   %rbp
  800322:	48 89 e5             	mov    %rsp,%rbp
  800325:	48 83 ec 70          	sub    $0x70,%rsp
  800329:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80032c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800330:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  800334:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  80033b:	00 
  80033c:	76 35                	jbe    800373 <ide_write+0x52>
  80033e:	48 b9 70 6d 80 00 00 	movabs $0x806d70,%rcx
  800345:	00 00 00 
  800348:	48 ba 7d 6d 80 00 00 	movabs $0x806d7d,%rdx
  80034f:	00 00 00 
  800352:	be 5c 00 00 00       	mov    $0x5c,%esi
  800357:	48 bf 67 6d 80 00 00 	movabs $0x806d67,%rdi
  80035e:	00 00 00 
  800361:	b8 00 00 00 00       	mov    $0x0,%eax
  800366:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  80036d:	00 00 00 
  800370:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  800373:	bf 00 00 00 00       	mov    $0x0,%edi
  800378:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80037f:	00 00 00 
  800382:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800384:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800388:	0f b6 c0             	movzbl %al,%eax
  80038b:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  800392:	88 45 f7             	mov    %al,-0x9(%rbp)
}

    static __inline void
outb(int port, uint8_t data)
{
    __asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800395:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800399:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80039c:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  80039d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003a0:	0f b6 c0             	movzbl %al,%eax
  8003a3:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  8003aa:	88 45 ef             	mov    %al,-0x11(%rbp)
  8003ad:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8003b1:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8003b4:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003b5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003b8:	c1 e8 08             	shr    $0x8,%eax
  8003bb:	0f b6 c0             	movzbl %al,%eax
  8003be:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  8003c5:	88 45 e7             	mov    %al,-0x19(%rbp)
  8003c8:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8003cc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8003cf:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003d0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003d3:	c1 e8 10             	shr    $0x10,%eax
  8003d6:	0f b6 c0             	movzbl %al,%eax
  8003d9:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  8003e0:	88 45 df             	mov    %al,-0x21(%rbp)
  8003e3:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8003e7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8003ea:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  8003eb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8003f2:	00 00 00 
  8003f5:	8b 00                	mov    (%rax),%eax
  8003f7:	83 e0 01             	and    $0x1,%eax
  8003fa:	c1 e0 04             	shl    $0x4,%eax
  8003fd:	89 c2                	mov    %eax,%edx
  8003ff:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800402:	c1 e8 18             	shr    $0x18,%eax
  800405:	83 e0 0f             	and    $0xf,%eax
  800408:	09 d0                	or     %edx,%eax
  80040a:	83 c8 e0             	or     $0xffffffe0,%eax
  80040d:	0f b6 c0             	movzbl %al,%eax
  800410:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  800417:	88 45 d7             	mov    %al,-0x29(%rbp)
  80041a:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  80041e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800421:	ee                   	out    %al,(%dx)
  800422:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  800429:	c6 45 cf 30          	movb   $0x30,-0x31(%rbp)
  80042d:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  800431:	8b 55 d0             	mov    -0x30(%rbp),%edx
  800434:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800435:	eb 5e                	jmp    800495 <ide_write+0x174>
		if ((r = ide_wait_ready(1)) < 0)
  800437:	bf 01 00 00 00       	mov    $0x1,%edi
  80043c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800443:	00 00 00 
  800446:	ff d0                	callq  *%rax
  800448:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80044b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044f:	79 05                	jns    800456 <ide_write+0x135>
			return r;
  800451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800454:	eb 4b                	jmp    8004a1 <ide_write+0x180>
  800456:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  80045d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800461:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800465:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

    static __inline void
outsw(int port, const void *addr, int cnt)
{
    __asm __volatile("cld\n\trepne\n\toutsw"		:
  80046c:	8b 55 c8             	mov    -0x38(%rbp),%edx
  80046f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800473:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800476:	48 89 ce             	mov    %rcx,%rsi
  800479:	89 c1                	mov    %eax,%ecx
  80047b:	fc                   	cld    
  80047c:	f2 66 6f             	repnz outsw %ds:(%rsi),(%dx)
  80047f:	89 c8                	mov    %ecx,%eax
  800481:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800485:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800488:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80048d:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800494:	00 
  800495:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  80049a:	75 9b                	jne    800437 <ide_write+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsw(0x1F0, src, SECTSIZE/2);
	}

	return 0;
  80049c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 10          	sub    $0x10,%rsp
  8004ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004af:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004b4:	74 2a                	je     8004e0 <diskaddr+0x3d>
  8004b6:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8004bd:	00 00 00 
  8004c0:	48 8b 00             	mov    (%rax),%rax
  8004c3:	48 85 c0             	test   %rax,%rax
  8004c6:	74 4a                	je     800512 <diskaddr+0x6f>
  8004c8:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8004cf:	00 00 00 
  8004d2:	48 8b 00             	mov    (%rax),%rax
  8004d5:	8b 40 04             	mov    0x4(%rax),%eax
  8004d8:	89 c0                	mov    %eax,%eax
  8004da:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004de:	77 32                	ja     800512 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e4:	48 89 c1             	mov    %rax,%rcx
  8004e7:	48 ba 98 6d 80 00 00 	movabs $0x806d98,%rdx
  8004ee:	00 00 00 
  8004f1:	be 09 00 00 00       	mov    $0x9,%esi
  8004f6:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  8004fd:	00 00 00 
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  80050c:	00 00 00 
  80050f:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800516:	48 05 00 00 01 00    	add    $0x10000,%rax
  80051c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800520:	c9                   	leaveq 
  800521:	c3                   	retq   

0000000000800522 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800522:	55                   	push   %rbp
  800523:	48 89 e5             	mov    %rsp,%rbp
  800526:	48 83 ec 08          	sub    $0x8,%rsp
  80052a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80052e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800532:	48 c1 e8 27          	shr    $0x27,%rax
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  800540:	01 00 00 
  800543:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800547:	83 e0 01             	and    $0x1,%eax
  80054a:	48 85 c0             	test   %rax,%rax
  80054d:	74 6a                	je     8005b9 <va_is_mapped+0x97>
  80054f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800553:	48 c1 e8 1e          	shr    $0x1e,%rax
  800557:	48 89 c2             	mov    %rax,%rdx
  80055a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  800561:	01 00 00 
  800564:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800568:	83 e0 01             	and    $0x1,%eax
  80056b:	48 85 c0             	test   %rax,%rax
  80056e:	74 49                	je     8005b9 <va_is_mapped+0x97>
  800570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800574:	48 c1 e8 15          	shr    $0x15,%rax
  800578:	48 89 c2             	mov    %rax,%rdx
  80057b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800582:	01 00 00 
  800585:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800589:	83 e0 01             	and    $0x1,%eax
  80058c:	48 85 c0             	test   %rax,%rax
  80058f:	74 28                	je     8005b9 <va_is_mapped+0x97>
  800591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800595:	48 c1 e8 0c          	shr    $0xc,%rax
  800599:	48 89 c2             	mov    %rax,%rdx
  80059c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005a3:	01 00 00 
  8005a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005aa:	83 e0 01             	and    $0x1,%eax
  8005ad:	48 85 c0             	test   %rax,%rax
  8005b0:	74 07                	je     8005b9 <va_is_mapped+0x97>
  8005b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8005b7:	eb 05                	jmp    8005be <va_is_mapped+0x9c>
  8005b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005be:	83 e0 01             	and    $0x1,%eax
}
  8005c1:	c9                   	leaveq 
  8005c2:	c3                   	retq   

00000000008005c3 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8005c3:	55                   	push   %rbp
  8005c4:	48 89 e5             	mov    %rsp,%rbp
  8005c7:	48 83 ec 08          	sub    $0x8,%rsp
  8005cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8005cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8005d7:	48 89 c2             	mov    %rax,%rdx
  8005da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005e1:	01 00 00 
  8005e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e8:	83 e0 40             	and    $0x40,%eax
  8005eb:	48 85 c0             	test   %rax,%rax
  8005ee:	0f 95 c0             	setne  %al
}
  8005f1:	c9                   	leaveq 
  8005f2:	c3                   	retq   

00000000008005f3 <bc_pgfault>:
// Fault any disk block that is read in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
  8005f3:	55                   	push   %rbp
  8005f4:	48 89 e5             	mov    %rsp,%rbp
  8005f7:	48 83 ec 30          	sub    $0x30,%rsp
  8005fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8005ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800603:	48 8b 00             	mov    (%rax),%rax
  800606:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80060a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060e:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800614:	48 c1 e8 0c          	shr    $0xc,%rax
  800618:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80061c:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800623:	0f 
  800624:	76 0b                	jbe    800631 <bc_pgfault+0x3e>
  800626:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  80062b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80062f:	76 4b                	jbe    80067c <bc_pgfault+0x89>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800635:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063d:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800644:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800648:	49 89 c9             	mov    %rcx,%r9
  80064b:	49 89 d0             	mov    %rdx,%r8
  80064e:	48 89 c1             	mov    %rax,%rcx
  800651:	48 ba c8 6d 80 00 00 	movabs $0x806dc8,%rdx
  800658:	00 00 00 
  80065b:	be 28 00 00 00       	mov    $0x28,%esi
  800660:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  800667:	00 00 00 
  80066a:	b8 00 00 00 00       	mov    $0x0,%eax
  80066f:	49 ba bc 32 80 00 00 	movabs $0x8032bc,%r10
  800676:	00 00 00 
  800679:	41 ff d2             	callq  *%r10
			  utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80067c:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800683:	00 00 00 
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 85 c0             	test   %rax,%rax
  80068c:	74 4a                	je     8006d8 <bc_pgfault+0xe5>
  80068e:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800695:	00 00 00 
  800698:	48 8b 00             	mov    (%rax),%rax
  80069b:	8b 40 04             	mov    0x4(%rax),%eax
  80069e:	89 c0                	mov    %eax,%eax
  8006a0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a4:	77 32                	ja     8006d8 <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006aa:	48 89 c1             	mov    %rax,%rcx
  8006ad:	48 ba f8 6d 80 00 00 	movabs $0x806df8,%rdx
  8006b4:	00 00 00 
  8006b7:	be 2c 00 00 00       	mov    $0x2c,%esi
  8006bc:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  8006c3:	00 00 00 
  8006c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cb:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  8006d2:	00 00 00 
  8006d5:	41 ff d0             	callq  *%r8
	// Allocate a page in the disk map region, read the contents
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//
	// LAB 5: your code here:
	addr = ROUNDDOWN(addr, PGSIZE);
  8006d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8006e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8006ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if(0 != sys_page_alloc(0, (void*)addr, PTE_SYSCALL)){
  8006ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006f2:	ba 07 0e 00 00       	mov    $0xe07,%edx
  8006f7:	48 89 c6             	mov    %rax,%rsi
  8006fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8006ff:	48 b8 d9 49 80 00 00 	movabs $0x8049d9,%rax
  800706:	00 00 00 
  800709:	ff d0                	callq  *%rax
  80070b:	85 c0                	test   %eax,%eax
  80070d:	74 2a                	je     800739 <bc_pgfault+0x146>
		panic("Page Allocation Failed during handling page fault in FS");
  80070f:	48 ba 20 6e 80 00 00 	movabs $0x806e20,%rdx
  800716:	00 00 00 
  800719:	be 35 00 00 00       	mov    $0x35,%esi
  80071e:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  800725:	00 00 00 
  800728:	b8 00 00 00 00       	mov    $0x0,%eax
  80072d:	48 b9 bc 32 80 00 00 	movabs $0x8032bc,%rcx
  800734:	00 00 00 
  800737:	ff d1                	callq  *%rcx
	if(0 != host_read((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
	{
		panic("ide read failed in Page Fault Handling");		
	}
#else
	if(0 != ide_read((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
  800739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80073d:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800748:	ba 08 00 00 00       	mov    $0x8,%edx
  80074d:	48 89 c6             	mov    %rax,%rsi
  800750:	89 cf                	mov    %ecx,%edi
  800752:	48 b8 99 01 80 00 00 	movabs $0x800199,%rax
  800759:	00 00 00 
  80075c:	ff d0                	callq  *%rax
  80075e:	85 c0                	test   %eax,%eax
  800760:	74 2a                	je     80078c <bc_pgfault+0x199>
	{
		panic("ide read failed in Page Fault Handling");		
  800762:	48 ba 58 6e 80 00 00 	movabs $0x806e58,%rdx
  800769:	00 00 00 
  80076c:	be 3f 00 00 00       	mov    $0x3f,%esi
  800771:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  800778:	00 00 00 
  80077b:	b8 00 00 00 00       	mov    $0x0,%eax
  800780:	48 b9 bc 32 80 00 00 	movabs $0x8032bc,%rcx
  800787:	00 00 00 
  80078a:	ff d1                	callq  *%rcx
	}
#endif	
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  80078c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800790:	48 c1 e8 0c          	shr    $0xc,%rax
  800794:	48 89 c2             	mov    %rax,%rdx
  800797:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80079e:	01 00 00 
  8007a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007a5:	25 07 0e 00 00       	and    $0xe07,%eax
  8007aa:	89 c1                	mov    %eax,%ecx
  8007ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007b4:	41 89 c8             	mov    %ecx,%r8d
  8007b7:	48 89 d1             	mov    %rdx,%rcx
  8007ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bf:	48 89 c6             	mov    %rax,%rsi
  8007c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8007c7:	48 b8 29 4a 80 00 00 	movabs $0x804a29,%rax
  8007ce:	00 00 00 
  8007d1:	ff d0                	callq  *%rax
  8007d3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8007d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007da:	79 30                	jns    80080c <bc_pgfault+0x219>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8007dc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007df:	89 c1                	mov    %eax,%ecx
  8007e1:	48 ba 80 6e 80 00 00 	movabs $0x806e80,%rdx
  8007e8:	00 00 00 
  8007eb:	be 43 00 00 00       	mov    $0x43,%esi
  8007f0:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  8007f7:	00 00 00 
  8007fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ff:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  800806:	00 00 00 
  800809:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  80080c:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800813:	00 00 00 
  800816:	48 8b 00             	mov    (%rax),%rax
  800819:	48 85 c0             	test   %rax,%rax
  80081c:	74 48                	je     800866 <bc_pgfault+0x273>
  80081e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800822:	89 c7                	mov    %eax,%edi
  800824:	48 b8 60 0d 80 00 00 	movabs $0x800d60,%rax
  80082b:	00 00 00 
  80082e:	ff d0                	callq  *%rax
  800830:	84 c0                	test   %al,%al
  800832:	74 32                	je     800866 <bc_pgfault+0x273>
		panic("reading free block %08x\n", blockno);
  800834:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800838:	48 89 c1             	mov    %rax,%rcx
  80083b:	48 ba a0 6e 80 00 00 	movabs $0x806ea0,%rdx
  800842:	00 00 00 
  800845:	be 49 00 00 00       	mov    $0x49,%esi
  80084a:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  800851:	00 00 00 
  800854:	b8 00 00 00 00       	mov    $0x0,%eax
  800859:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  800860:	00 00 00 
  800863:	41 ff d0             	callq  *%r8
}
  800866:	c9                   	leaveq 
  800867:	c3                   	retq   

0000000000800868 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
	{
  800868:	55                   	push   %rbp
  800869:	48 89 e5             	mov    %rsp,%rbp
  80086c:	48 83 ec 30          	sub    $0x30,%rsp
  800870:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
		uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  800874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800878:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  80087e:	48 c1 e8 0c          	shr    $0xc,%rax
  800882:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		int r;
		
		if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800886:	48 81 7d d8 ff ff ff 	cmpq   $0xfffffff,-0x28(%rbp)
  80088d:	0f 
  80088e:	76 0b                	jbe    80089b <flush_block+0x33>
  800890:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  800895:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800899:	76 32                	jbe    8008cd <flush_block+0x65>
			panic("flush_block of bad va %08x", addr);
  80089b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089f:	48 89 c1             	mov    %rax,%rcx
  8008a2:	48 ba b9 6e 80 00 00 	movabs $0x806eb9,%rdx
  8008a9:	00 00 00 
  8008ac:	be 5b 00 00 00       	mov    $0x5b,%esi
  8008b1:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  8008b8:	00 00 00 
  8008bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c0:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  8008c7:	00 00 00 
  8008ca:	41 ff d0             	callq  *%r8
	
		// LAB 5: Your code here.
		//panic("flush_block not implemented");
		if(va_is_mapped(addr) == false || va_is_dirty(addr) == false)
  8008cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008d1:	48 89 c7             	mov    %rax,%rdi
  8008d4:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  8008db:	00 00 00 
  8008de:	ff d0                	callq  *%rax
  8008e0:	83 f0 01             	xor    $0x1,%eax
  8008e3:	84 c0                	test   %al,%al
  8008e5:	75 1a                	jne    800901 <flush_block+0x99>
  8008e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008eb:	48 89 c7             	mov    %rax,%rdi
  8008ee:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  8008f5:	00 00 00 
  8008f8:	ff d0                	callq  *%rax
  8008fa:	83 f0 01             	xor    $0x1,%eax
  8008fd:	84 c0                	test   %al,%al
  8008ff:	74 05                	je     800906 <flush_block+0x9e>
		{
			return;
  800901:	e9 cc 00 00 00       	jmpq   8009d2 <flush_block+0x16a>
		}
		addr = ROUNDDOWN(addr, PGSIZE);
  800906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80090a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80090e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800912:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800918:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
		if(0 != host_write((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
		{
			panic("ide read failed in Page Fault Handling");		
		}
#else
		if(0 != ide_write((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
  80091c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800920:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800927:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80092b:	ba 08 00 00 00       	mov    $0x8,%edx
  800930:	48 89 c6             	mov    %rax,%rsi
  800933:	89 cf                	mov    %ecx,%edi
  800935:	48 b8 21 03 80 00 00 	movabs $0x800321,%rax
  80093c:	00 00 00 
  80093f:	ff d0                	callq  *%rax
  800941:	85 c0                	test   %eax,%eax
  800943:	74 2a                	je     80096f <flush_block+0x107>
		{
			panic("ide write failed in Flush Block");	
  800945:	48 ba d8 6e 80 00 00 	movabs $0x806ed8,%rdx
  80094c:	00 00 00 
  80094f:	be 6c 00 00 00       	mov    $0x6c,%esi
  800954:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  80095b:	00 00 00 
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
  800963:	48 b9 bc 32 80 00 00 	movabs $0x8032bc,%rcx
  80096a:	00 00 00 
  80096d:	ff d1                	callq  *%rcx
		}
#endif	
		if ((r = sys_page_map(0, addr, 0, addr, PTE_SYSCALL)) < 0)
  80096f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800973:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800977:	41 b8 07 0e 00 00    	mov    $0xe07,%r8d
  80097d:	48 89 d1             	mov    %rdx,%rcx
  800980:	ba 00 00 00 00       	mov    $0x0,%edx
  800985:	48 89 c6             	mov    %rax,%rsi
  800988:	bf 00 00 00 00       	mov    $0x0,%edi
  80098d:	48 b8 29 4a 80 00 00 	movabs $0x804a29,%rax
  800994:	00 00 00 
  800997:	ff d0                	callq  *%rax
  800999:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80099c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8009a0:	79 30                	jns    8009d2 <flush_block+0x16a>
		{
			panic("in flush_block, sys_page_map: %e", r);
  8009a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8009a5:	89 c1                	mov    %eax,%ecx
  8009a7:	48 ba f8 6e 80 00 00 	movabs $0x806ef8,%rdx
  8009ae:	00 00 00 
  8009b1:	be 71 00 00 00       	mov    $0x71,%esi
  8009b6:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  8009bd:	00 00 00 
  8009c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c5:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  8009cc:	00 00 00 
  8009cf:	41 ff d0             	callq  *%r8
		}
	}
  8009d2:	c9                   	leaveq 
  8009d3:	c3                   	retq   

00000000008009d4 <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  8009d4:	55                   	push   %rbp
  8009d5:	48 89 e5             	mov    %rsp,%rbp
  8009d8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8009df:	bf 01 00 00 00       	mov    $0x1,%edi
  8009e4:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8009eb:	00 00 00 
  8009ee:	ff d0                	callq  *%rax
  8009f0:	48 89 c1             	mov    %rax,%rcx
  8009f3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8009fa:	ba 08 01 00 00       	mov    $0x108,%edx
  8009ff:	48 89 ce             	mov    %rcx,%rsi
  800a02:	48 89 c7             	mov    %rax,%rdi
  800a05:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  800a0c:	00 00 00 
  800a0f:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  800a11:	bf 01 00 00 00       	mov    $0x1,%edi
  800a16:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a1d:	00 00 00 
  800a20:	ff d0                	callq  *%rax
  800a22:	48 be 19 6f 80 00 00 	movabs $0x806f19,%rsi
  800a29:	00 00 00 
  800a2c:	48 89 c7             	mov    %rax,%rdi
  800a2f:	48 b8 aa 40 80 00 00 	movabs $0x8040aa,%rax
  800a36:	00 00 00 
  800a39:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800a3b:	bf 01 00 00 00       	mov    $0x1,%edi
  800a40:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a47:	00 00 00 
  800a4a:	ff d0                	callq  *%rax
  800a4c:	48 89 c7             	mov    %rax,%rdi
  800a4f:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  800a56:	00 00 00 
  800a59:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  800a5b:	bf 01 00 00 00       	mov    $0x1,%edi
  800a60:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a67:	00 00 00 
  800a6a:	ff d0                	callq  *%rax
  800a6c:	48 89 c7             	mov    %rax,%rdi
  800a6f:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800a76:	00 00 00 
  800a79:	ff d0                	callq  *%rax
  800a7b:	83 f0 01             	xor    $0x1,%eax
  800a7e:	84 c0                	test   %al,%al
  800a80:	74 35                	je     800ab7 <check_bc+0xe3>
  800a82:	48 b9 20 6f 80 00 00 	movabs $0x806f20,%rcx
  800a89:	00 00 00 
  800a8c:	48 ba 3a 6f 80 00 00 	movabs $0x806f3a,%rdx
  800a93:	00 00 00 
  800a96:	be 83 00 00 00       	mov    $0x83,%esi
  800a9b:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  800aa2:	00 00 00 
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaa:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  800ab1:	00 00 00 
  800ab4:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  800ab7:	bf 01 00 00 00       	mov    $0x1,%edi
  800abc:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800ac3:	00 00 00 
  800ac6:	ff d0                	callq  *%rax
  800ac8:	48 89 c7             	mov    %rax,%rdi
  800acb:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800ad2:	00 00 00 
  800ad5:	ff d0                	callq  *%rax
  800ad7:	84 c0                	test   %al,%al
  800ad9:	74 35                	je     800b10 <check_bc+0x13c>
  800adb:	48 b9 4f 6f 80 00 00 	movabs $0x806f4f,%rcx
  800ae2:	00 00 00 
  800ae5:	48 ba 3a 6f 80 00 00 	movabs $0x806f3a,%rdx
  800aec:	00 00 00 
  800aef:	be 84 00 00 00       	mov    $0x84,%esi
  800af4:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  800afb:	00 00 00 
  800afe:	b8 00 00 00 00       	mov    $0x0,%eax
  800b03:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  800b0a:	00 00 00 
  800b0d:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800b10:	bf 01 00 00 00       	mov    $0x1,%edi
  800b15:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b1c:	00 00 00 
  800b1f:	ff d0                	callq  *%rax
  800b21:	48 89 c6             	mov    %rax,%rsi
  800b24:	bf 00 00 00 00       	mov    $0x0,%edi
  800b29:	48 b8 84 4a 80 00 00 	movabs $0x804a84,%rax
  800b30:	00 00 00 
  800b33:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  800b35:	bf 01 00 00 00       	mov    $0x1,%edi
  800b3a:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b41:	00 00 00 
  800b44:	ff d0                	callq  *%rax
  800b46:	48 89 c7             	mov    %rax,%rdi
  800b49:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800b50:	00 00 00 
  800b53:	ff d0                	callq  *%rax
  800b55:	84 c0                	test   %al,%al
  800b57:	74 35                	je     800b8e <check_bc+0x1ba>
  800b59:	48 b9 69 6f 80 00 00 	movabs $0x806f69,%rcx
  800b60:	00 00 00 
  800b63:	48 ba 3a 6f 80 00 00 	movabs $0x806f3a,%rdx
  800b6a:	00 00 00 
  800b6d:	be 88 00 00 00       	mov    $0x88,%esi
  800b72:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  800b79:	00 00 00 
  800b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b81:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  800b88:	00 00 00 
  800b8b:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800b8e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b93:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b9a:	00 00 00 
  800b9d:	ff d0                	callq  *%rax
  800b9f:	48 be 19 6f 80 00 00 	movabs $0x806f19,%rsi
  800ba6:	00 00 00 
  800ba9:	48 89 c7             	mov    %rax,%rdi
  800bac:	48 b8 0c 42 80 00 00 	movabs $0x80420c,%rax
  800bb3:	00 00 00 
  800bb6:	ff d0                	callq  *%rax
  800bb8:	85 c0                	test   %eax,%eax
  800bba:	74 35                	je     800bf1 <check_bc+0x21d>
  800bbc:	48 b9 88 6f 80 00 00 	movabs $0x806f88,%rcx
  800bc3:	00 00 00 
  800bc6:	48 ba 3a 6f 80 00 00 	movabs $0x806f3a,%rdx
  800bcd:	00 00 00 
  800bd0:	be 8b 00 00 00       	mov    $0x8b,%esi
  800bd5:	48 bf ba 6d 80 00 00 	movabs $0x806dba,%rdi
  800bdc:	00 00 00 
  800bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800be4:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  800beb:	00 00 00 
  800bee:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800bf1:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf6:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800bfd:	00 00 00 
  800c00:	ff d0                	callq  *%rax
  800c02:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800c09:	ba 08 01 00 00       	mov    $0x108,%edx
  800c0e:	48 89 ce             	mov    %rcx,%rsi
  800c11:	48 89 c7             	mov    %rax,%rdi
  800c14:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  800c1b:	00 00 00 
  800c1e:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800c20:	bf 01 00 00 00       	mov    $0x1,%edi
  800c25:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800c2c:	00 00 00 
  800c2f:	ff d0                	callq  *%rax
  800c31:	48 89 c7             	mov    %rax,%rdi
  800c34:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  800c3b:	00 00 00 
  800c3e:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800c40:	48 bf ac 6f 80 00 00 	movabs $0x806fac,%rdi
  800c47:	00 00 00 
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4f:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  800c56:	00 00 00 
  800c59:	ff d2                	callq  *%rdx
}
  800c5b:	c9                   	leaveq 
  800c5c:	c3                   	retq   

0000000000800c5d <bc_init>:

void
bc_init(void)
{
  800c5d:	55                   	push   %rbp
  800c5e:	48 89 e5             	mov    %rsp,%rbp
  800c61:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800c68:	48 bf f3 05 80 00 00 	movabs $0x8005f3,%rdi
  800c6f:	00 00 00 
  800c72:	48 b8 27 4e 80 00 00 	movabs $0x804e27,%rax
  800c79:	00 00 00 
  800c7c:	ff d0                	callq  *%rax
	check_bc();
  800c7e:	48 b8 d4 09 80 00 00 	movabs $0x8009d4,%rax
  800c85:	00 00 00 
  800c88:	ff d0                	callq  *%rax

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800c8a:	bf 01 00 00 00       	mov    $0x1,%edi
  800c8f:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800c96:	00 00 00 
  800c99:	ff d0                	callq  *%rax
  800c9b:	48 89 c1             	mov    %rax,%rcx
  800c9e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ca5:	ba 08 01 00 00       	mov    $0x108,%edx
  800caa:	48 89 ce             	mov    %rcx,%rsi
  800cad:	48 89 c7             	mov    %rax,%rdi
  800cb0:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  800cb7:	00 00 00 
  800cba:	ff d0                	callq  *%rax
}
  800cbc:	c9                   	leaveq 
  800cbd:	c3                   	retq   

0000000000800cbe <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800cbe:	55                   	push   %rbp
  800cbf:	48 89 e5             	mov    %rsp,%rbp
	if (super->s_magic != FS_MAGIC)
  800cc2:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800cc9:	00 00 00 
  800ccc:	48 8b 00             	mov    (%rax),%rax
  800ccf:	8b 00                	mov    (%rax),%eax
  800cd1:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800cd6:	74 2a                	je     800d02 <check_super+0x44>
		panic("bad file system magic number");
  800cd8:	48 ba c8 6f 80 00 00 	movabs $0x806fc8,%rdx
  800cdf:	00 00 00 
  800ce2:	be 0e 00 00 00       	mov    $0xe,%esi
  800ce7:	48 bf e5 6f 80 00 00 	movabs $0x806fe5,%rdi
  800cee:	00 00 00 
  800cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf6:	48 b9 bc 32 80 00 00 	movabs $0x8032bc,%rcx
  800cfd:	00 00 00 
  800d00:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800d02:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d09:	00 00 00 
  800d0c:	48 8b 00             	mov    (%rax),%rax
  800d0f:	8b 40 04             	mov    0x4(%rax),%eax
  800d12:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800d17:	76 2a                	jbe    800d43 <check_super+0x85>
		panic("file system is too large");
  800d19:	48 ba ed 6f 80 00 00 	movabs $0x806fed,%rdx
  800d20:	00 00 00 
  800d23:	be 11 00 00 00       	mov    $0x11,%esi
  800d28:	48 bf e5 6f 80 00 00 	movabs $0x806fe5,%rdi
  800d2f:	00 00 00 
  800d32:	b8 00 00 00 00       	mov    $0x0,%eax
  800d37:	48 b9 bc 32 80 00 00 	movabs $0x8032bc,%rcx
  800d3e:	00 00 00 
  800d41:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800d43:	48 bf 06 70 80 00 00 	movabs $0x807006,%rdi
  800d4a:	00 00 00 
  800d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d52:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  800d59:	00 00 00 
  800d5c:	ff d2                	callq  *%rdx
}
  800d5e:	5d                   	pop    %rbp
  800d5f:	c3                   	retq   

0000000000800d60 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800d60:	55                   	push   %rbp
  800d61:	48 89 e5             	mov    %rsp,%rbp
  800d64:	48 83 ec 04          	sub    $0x4,%rsp
  800d68:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  800d6b:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d72:	00 00 00 
  800d75:	48 8b 00             	mov    (%rax),%rax
  800d78:	48 85 c0             	test   %rax,%rax
  800d7b:	74 15                	je     800d92 <block_is_free+0x32>
  800d7d:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d84:	00 00 00 
  800d87:	48 8b 00             	mov    (%rax),%rax
  800d8a:	8b 40 04             	mov    0x4(%rax),%eax
  800d8d:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800d90:	77 07                	ja     800d99 <block_is_free+0x39>
		return 0;
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
  800d97:	eb 41                	jmp    800dda <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800d99:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800da0:	00 00 00 
  800da3:	48 8b 00             	mov    (%rax),%rax
  800da6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800da9:	c1 ea 05             	shr    $0x5,%edx
  800dac:	89 d2                	mov    %edx,%edx
  800dae:	48 c1 e2 02          	shl    $0x2,%rdx
  800db2:	48 01 d0             	add    %rdx,%rax
  800db5:	8b 10                	mov    (%rax),%edx
  800db7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dba:	83 e0 1f             	and    $0x1f,%eax
  800dbd:	be 01 00 00 00       	mov    $0x1,%esi
  800dc2:	89 c1                	mov    %eax,%ecx
  800dc4:	d3 e6                	shl    %cl,%esi
  800dc6:	89 f0                	mov    %esi,%eax
  800dc8:	21 d0                	and    %edx,%eax
  800dca:	85 c0                	test   %eax,%eax
  800dcc:	74 07                	je     800dd5 <block_is_free+0x75>
		return 1;
  800dce:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd3:	eb 05                	jmp    800dda <block_is_free+0x7a>
	return 0;
  800dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dda:	c9                   	leaveq 
  800ddb:	c3                   	retq   

0000000000800ddc <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800ddc:	55                   	push   %rbp
  800ddd:	48 89 e5             	mov    %rsp,%rbp
  800de0:	48 83 ec 10          	sub    $0x10,%rsp
  800de4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800de7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800deb:	75 2a                	jne    800e17 <free_block+0x3b>
		panic("attempt to free zero block");
  800ded:	48 ba 1a 70 80 00 00 	movabs $0x80701a,%rdx
  800df4:	00 00 00 
  800df7:	be 2c 00 00 00       	mov    $0x2c,%esi
  800dfc:	48 bf e5 6f 80 00 00 	movabs $0x806fe5,%rdi
  800e03:	00 00 00 
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0b:	48 b9 bc 32 80 00 00 	movabs $0x8032bc,%rcx
  800e12:	00 00 00 
  800e15:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800e17:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800e1e:	00 00 00 
  800e21:	48 8b 10             	mov    (%rax),%rdx
  800e24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e27:	c1 e8 05             	shr    $0x5,%eax
  800e2a:	89 c1                	mov    %eax,%ecx
  800e2c:	48 c1 e1 02          	shl    $0x2,%rcx
  800e30:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800e34:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  800e3b:	00 00 00 
  800e3e:	48 8b 12             	mov    (%rdx),%rdx
  800e41:	89 c0                	mov    %eax,%eax
  800e43:	48 c1 e0 02          	shl    $0x2,%rax
  800e47:	48 01 d0             	add    %rdx,%rax
  800e4a:	8b 10                	mov    (%rax),%edx
  800e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e4f:	83 e0 1f             	and    $0x1f,%eax
  800e52:	bf 01 00 00 00       	mov    $0x1,%edi
  800e57:	89 c1                	mov    %eax,%ecx
  800e59:	d3 e7                	shl    %cl,%edi
  800e5b:	89 f8                	mov    %edi,%eax
  800e5d:	09 d0                	or     %edx,%eax
  800e5f:	89 06                	mov    %eax,(%rsi)
	//cprintf("free_block is freeing block # [%d]\n", blockno);
}
  800e61:	c9                   	leaveq 
  800e62:	c3                   	retq   

0000000000800e63 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
	{
  800e63:	55                   	push   %rbp
  800e64:	48 89 e5             	mov    %rsp,%rbp
  800e67:	48 83 ec 10          	sub    $0x10,%rsp
		// contains the in-use bits for BLKBITSIZE blocks.	There are
		// super->s_nblocks blocks in the disk altogether.
	
		// LAB 5: Your code here.
		//panic("alloc_block not implemented");
		uint32_t blockno = 2;
  800e6b:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		static int blocks_allocated = 0;
		for(; blockno < super->s_nblocks; blockno++)
  800e72:	e9 a5 00 00 00       	jmpq   800f1c <alloc_block+0xb9>
		{
			if(block_is_free(blockno))
  800e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e7a:	89 c7                	mov    %eax,%edi
  800e7c:	48 b8 60 0d 80 00 00 	movabs $0x800d60,%rax
  800e83:	00 00 00 
  800e86:	ff d0                	callq  *%rax
  800e88:	84 c0                	test   %al,%al
  800e8a:	0f 84 88 00 00 00    	je     800f18 <alloc_block+0xb5>
			{
				bitmap[blockno/32] &= ~(1<<(blockno%32));
  800e90:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800e97:	00 00 00 
  800e9a:	48 8b 10             	mov    (%rax),%rdx
  800e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea0:	c1 e8 05             	shr    $0x5,%eax
  800ea3:	89 c1                	mov    %eax,%ecx
  800ea5:	48 c1 e1 02          	shl    $0x2,%rcx
  800ea9:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800ead:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  800eb4:	00 00 00 
  800eb7:	48 8b 12             	mov    (%rdx),%rdx
  800eba:	89 c0                	mov    %eax,%eax
  800ebc:	48 c1 e0 02          	shl    $0x2,%rax
  800ec0:	48 01 d0             	add    %rdx,%rax
  800ec3:	8b 10                	mov    (%rax),%edx
  800ec5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ec8:	83 e0 1f             	and    $0x1f,%eax
  800ecb:	bf 01 00 00 00       	mov    $0x1,%edi
  800ed0:	89 c1                	mov    %eax,%ecx
  800ed2:	d3 e7                	shl    %cl,%edi
  800ed4:	89 f8                	mov    %edi,%eax
  800ed6:	f7 d0                	not    %eax
  800ed8:	21 d0                	and    %edx,%eax
  800eda:	89 06                	mov    %eax,(%rsi)
				flush_block((void*)bitmap);
  800edc:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800ee3:	00 00 00 
  800ee6:	48 8b 00             	mov    (%rax),%rax
  800ee9:	48 89 c7             	mov    %rax,%rdi
  800eec:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  800ef3:	00 00 00 
  800ef6:	ff d0                	callq  *%rax
				//cprintf("alloc_block_retrning block # [%d]\n", blockno);
				blocks_allocated++;
  800ef8:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  800eff:	00 00 00 
  800f02:	8b 00                	mov    (%rax),%eax
  800f04:	8d 50 01             	lea    0x1(%rax),%edx
  800f07:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  800f0e:	00 00 00 
  800f11:	89 10                	mov    %edx,(%rax)
				return blockno; 
  800f13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f16:	eb 4b                	jmp    800f63 <alloc_block+0x100>
	
		// LAB 5: Your code here.
		//panic("alloc_block not implemented");
		uint32_t blockno = 2;
		static int blocks_allocated = 0;
		for(; blockno < super->s_nblocks; blockno++)
  800f18:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800f1c:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800f23:	00 00 00 
  800f26:	48 8b 00             	mov    (%rax),%rax
  800f29:	8b 40 04             	mov    0x4(%rax),%eax
  800f2c:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800f2f:	0f 87 42 ff ff ff    	ja     800e77 <alloc_block+0x14>
				//cprintf("alloc_block_retrning block # [%d]\n", blockno);
				blocks_allocated++;
				return blockno; 
			}
		}
		cprintf("alloc_block_failed and retrning block # [%d]\n", blocks_allocated);
  800f35:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  800f3c:	00 00 00 
  800f3f:	8b 00                	mov    (%rax),%eax
  800f41:	89 c6                	mov    %eax,%esi
  800f43:	48 bf 38 70 80 00 00 	movabs $0x807038,%rdi
  800f4a:	00 00 00 
  800f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f52:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  800f59:	00 00 00 
  800f5c:	ff d2                	callq  *%rdx
		return -E_NO_DISK;
  800f5e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	}
  800f63:	c9                   	leaveq 
  800f64:	c3                   	retq   

0000000000800f65 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800f65:	55                   	push   %rbp
  800f66:	48 89 e5             	mov    %rsp,%rbp
  800f69:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800f6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f74:	eb 51                	jmp    800fc7 <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  800f76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f79:	83 c0 02             	add    $0x2,%eax
  800f7c:	89 c7                	mov    %eax,%edi
  800f7e:	48 b8 60 0d 80 00 00 	movabs $0x800d60,%rax
  800f85:	00 00 00 
  800f88:	ff d0                	callq  *%rax
  800f8a:	84 c0                	test   %al,%al
  800f8c:	74 35                	je     800fc3 <check_bitmap+0x5e>
  800f8e:	48 b9 66 70 80 00 00 	movabs $0x807066,%rcx
  800f95:	00 00 00 
  800f98:	48 ba 7a 70 80 00 00 	movabs $0x80707a,%rdx
  800f9f:	00 00 00 
  800fa2:	be 5f 00 00 00       	mov    $0x5f,%esi
  800fa7:	48 bf e5 6f 80 00 00 	movabs $0x806fe5,%rdi
  800fae:	00 00 00 
  800fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb6:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  800fbd:	00 00 00 
  800fc0:	41 ff d0             	callq  *%r8
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800fc3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fca:	c1 e0 0f             	shl    $0xf,%eax
  800fcd:	89 c2                	mov    %eax,%edx
  800fcf:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800fd6:	00 00 00 
  800fd9:	48 8b 00             	mov    (%rax),%rax
  800fdc:	8b 40 04             	mov    0x4(%rax),%eax
  800fdf:	39 c2                	cmp    %eax,%edx
  800fe1:	72 93                	jb     800f76 <check_bitmap+0x11>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800fe3:	bf 00 00 00 00       	mov    $0x0,%edi
  800fe8:	48 b8 60 0d 80 00 00 	movabs $0x800d60,%rax
  800fef:	00 00 00 
  800ff2:	ff d0                	callq  *%rax
  800ff4:	84 c0                	test   %al,%al
  800ff6:	74 35                	je     80102d <check_bitmap+0xc8>
  800ff8:	48 b9 8f 70 80 00 00 	movabs $0x80708f,%rcx
  800fff:	00 00 00 
  801002:	48 ba 7a 70 80 00 00 	movabs $0x80707a,%rdx
  801009:	00 00 00 
  80100c:	be 62 00 00 00       	mov    $0x62,%esi
  801011:	48 bf e5 6f 80 00 00 	movabs $0x806fe5,%rdi
  801018:	00 00 00 
  80101b:	b8 00 00 00 00       	mov    $0x0,%eax
  801020:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  801027:	00 00 00 
  80102a:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  80102d:	bf 01 00 00 00       	mov    $0x1,%edi
  801032:	48 b8 60 0d 80 00 00 	movabs $0x800d60,%rax
  801039:	00 00 00 
  80103c:	ff d0                	callq  *%rax
  80103e:	84 c0                	test   %al,%al
  801040:	74 35                	je     801077 <check_bitmap+0x112>
  801042:	48 b9 a1 70 80 00 00 	movabs $0x8070a1,%rcx
  801049:	00 00 00 
  80104c:	48 ba 7a 70 80 00 00 	movabs $0x80707a,%rdx
  801053:	00 00 00 
  801056:	be 63 00 00 00       	mov    $0x63,%esi
  80105b:	48 bf e5 6f 80 00 00 	movabs $0x806fe5,%rdi
  801062:	00 00 00 
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
  80106a:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  801071:	00 00 00 
  801074:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  801077:	48 bf b3 70 80 00 00 	movabs $0x8070b3,%rdi
  80107e:	00 00 00 
  801081:	b8 00 00 00 00       	mov    $0x0,%eax
  801086:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  80108d:	00 00 00 
  801090:	ff d2                	callq  *%rdx
}
  801092:	c9                   	leaveq 
  801093:	c3                   	retq   

0000000000801094 <fs_init>:
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
  801094:	55                   	push   %rbp
  801095:	48 89 e5             	mov    %rsp,%rbp
	static_assert(sizeof(struct File) == 256);

#ifndef VMM_GUEST
	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  801098:	48 b8 96 00 80 00 00 	movabs $0x800096,%rax
  80109f:	00 00 00 
  8010a2:	ff d0                	callq  *%rax
  8010a4:	84 c0                	test   %al,%al
  8010a6:	74 13                	je     8010bb <fs_init+0x27>
		ide_set_disk(1);
  8010a8:	bf 01 00 00 00       	mov    $0x1,%edi
  8010ad:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  8010b4:	00 00 00 
  8010b7:	ff d0                	callq  *%rax
  8010b9:	eb 11                	jmp    8010cc <fs_init+0x38>
	else
		ide_set_disk(0);
  8010bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c0:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  8010c7:	00 00 00 
  8010ca:	ff d0                	callq  *%rax
#else
	host_ipc_init();
#endif
	bc_init();
  8010cc:	48 b8 5d 0c 80 00 00 	movabs $0x800c5d,%rax
  8010d3:	00 00 00 
  8010d6:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  8010d8:	bf 01 00 00 00       	mov    $0x1,%edi
  8010dd:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8010e4:	00 00 00 
  8010e7:	ff d0                	callq  *%rax
  8010e9:	48 ba 10 20 81 00 00 	movabs $0x812010,%rdx
  8010f0:	00 00 00 
  8010f3:	48 89 02             	mov    %rax,(%rdx)
	check_super();
  8010f6:	48 b8 be 0c 80 00 00 	movabs $0x800cbe,%rax
  8010fd:	00 00 00 
  801100:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  801102:	bf 02 00 00 00       	mov    $0x2,%edi
  801107:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80110e:	00 00 00 
  801111:	ff d0                	callq  *%rax
  801113:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  80111a:	00 00 00 
  80111d:	48 89 02             	mov    %rax,(%rdx)
	check_bitmap();
  801120:	48 b8 65 0f 80 00 00 	movabs $0x800f65,%rax
  801127:	00 00 00 
  80112a:	ff d0                	callq  *%rax
}
  80112c:	5d                   	pop    %rbp
  80112d:	c3                   	retq   

000000000080112e <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
	{
  80112e:	55                   	push   %rbp
  80112f:	48 89 e5             	mov    %rsp,%rbp
  801132:	48 83 ec 30          	sub    $0x30,%rsp
  801136:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80113d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801141:	89 c8                	mov    %ecx,%eax
  801143:	88 45 e0             	mov    %al,-0x20(%rbp)
		// LAB 5: Your code here.
		//if filebno is out of range
		//panic("file_block_walk not implemented");
		uint32_t* indirect = 0;
  801146:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80114d:	00 
		uint32_t nblock = 0;
  80114e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
		int freeBlock = 0;
  801155:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)

		if(filebno >= NDIRECT + NINDIRECT)
  80115c:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  801163:	76 0a                	jbe    80116f <file_block_walk+0x41>
		{
			return -E_INVAL;
  801165:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116a:	e9 6a 01 00 00       	jmpq   8012d9 <file_block_walk+0x1ab>
		}
		nblock = f->f_size / BLKSIZE;
  80116f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801173:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801179:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80117f:	85 c0                	test   %eax,%eax
  801181:	0f 48 c2             	cmovs  %edx,%eax
  801184:	c1 f8 0c             	sar    $0xc,%eax
  801187:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (filebno > nblock) {
  80118a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80118d:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801190:	76 0a                	jbe    80119c <file_block_walk+0x6e>
			return -E_NOT_FOUND;
  801192:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801197:	e9 3d 01 00 00       	jmpq   8012d9 <file_block_walk+0x1ab>
		}		
		if(filebno >= 0 && filebno < 10)
  80119c:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  8011a0:	77 26                	ja     8011c8 <file_block_walk+0x9a>
		{
			*ppdiskbno = (uint32_t *)(f->f_direct + filebno);
  8011a2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8011a5:	48 83 c0 20          	add    $0x20,%rax
  8011a9:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  8011b0:	00 
  8011b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b5:	48 01 d0             	add    %rdx,%rax
  8011b8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8011bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011c0:	48 89 10             	mov    %rdx,(%rax)
  8011c3:	e9 0c 01 00 00       	jmpq   8012d4 <file_block_walk+0x1a6>
		}
		else if(filebno >= 10)
  8011c8:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  8011cc:	0f 86 02 01 00 00    	jbe    8012d4 <file_block_walk+0x1a6>
		{
			filebno = filebno - 10;
  8011d2:	83 6d e4 0a          	subl   $0xa,-0x1c(%rbp)
			
			if(f->f_indirect != 0)
  8011d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011da:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	74 3d                	je     801221 <file_block_walk+0xf3>
			{
			
				//cprintf("called from file_block_walk1\n");
				indirect = (uint32_t*)diskaddr(f->f_indirect);
  8011e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e8:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8011ee:	89 c0                	mov    %eax,%eax
  8011f0:	48 89 c7             	mov    %rax,%rdi
  8011f3:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8011fa:	00 00 00 
  8011fd:	ff d0                	callq  *%rax
  8011ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
				*ppdiskbno = indirect + filebno;
  801203:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801206:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  80120d:	00 
  80120e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801212:	48 01 c2             	add    %rax,%rdx
  801215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801219:	48 89 10             	mov    %rdx,(%rax)
  80121c:	e9 b3 00 00 00       	jmpq   8012d4 <file_block_walk+0x1a6>
			}
			else if(f->f_indirect == 0 && alloc)
  801221:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801225:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  80122b:	85 c0                	test   %eax,%eax
  80122d:	0f 85 9a 00 00 00    	jne    8012cd <file_block_walk+0x19f>
  801233:	80 7d e0 00          	cmpb   $0x0,-0x20(%rbp)
  801237:	0f 84 90 00 00 00    	je     8012cd <file_block_walk+0x19f>
			{
				freeBlock = alloc_block();
  80123d:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  801244:	00 00 00 
  801247:	ff d0                	callq  *%rax
  801249:	89 45 f0             	mov    %eax,-0x10(%rbp)
				
				if(freeBlock == -E_NO_DISK)
  80124c:	83 7d f0 f6          	cmpl   $0xfffffff6,-0x10(%rbp)
  801250:	75 27                	jne    801279 <file_block_walk+0x14b>
				{
					//f->f_indirect = freeBlock;
					fprintf(1,"returning from here with -E_NO_DISK");
  801252:	48 be c8 70 80 00 00 	movabs $0x8070c8,%rsi
  801259:	00 00 00 
  80125c:	bf 01 00 00 00       	mov    $0x1,%edi
  801261:	b8 00 00 00 00       	mov    $0x0,%eax
  801266:	48 ba c6 62 80 00 00 	movabs $0x8062c6,%rdx
  80126d:	00 00 00 
  801270:	ff d2                	callq  *%rdx
					return -E_NO_DISK;
  801272:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801277:	eb 60                	jmp    8012d9 <file_block_walk+0x1ab>
				}
				f->f_indirect = freeBlock;
  801279:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801280:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)
				
				fprintf(1,"called from file_block_walk2\n");
  801286:	48 be ec 70 80 00 00 	movabs $0x8070ec,%rsi
  80128d:	00 00 00 
  801290:	bf 01 00 00 00       	mov    $0x1,%edi
  801295:	b8 00 00 00 00       	mov    $0x0,%eax
  80129a:	48 ba c6 62 80 00 00 	movabs $0x8062c6,%rdx
  8012a1:	00 00 00 
  8012a4:	ff d2                	callq  *%rdx
				*ppdiskbno = (uint32_t*)diskaddr(freeBlock) + filebno;
  8012a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8012a9:	48 98                	cltq   
  8012ab:	48 89 c7             	mov    %rax,%rdi
  8012ae:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8012b5:	00 00 00 
  8012b8:	ff d0                	callq  *%rax
  8012ba:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8012bd:	48 c1 e2 02          	shl    $0x2,%rdx
  8012c1:	48 01 c2             	add    %rax,%rdx
  8012c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c8:	48 89 10             	mov    %rdx,(%rax)
  8012cb:	eb 07                	jmp    8012d4 <file_block_walk+0x1a6>
			}
			else
			{
				return -E_NOT_FOUND;
  8012cd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8012d2:	eb 05                	jmp    8012d9 <file_block_walk+0x1ab>
			}
		}
		return 0;
  8012d4:	b8 00 00 00 00       	mov    $0x0,%eax
		//panic("file_block_walk not implemented");
	}
  8012d9:	c9                   	leaveq 
  8012da:	c3                   	retq   

00000000008012db <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  8012db:	55                   	push   %rbp
  8012dc:	48 89 e5             	mov    %rsp,%rbp
  8012df:	48 83 ec 30          	sub    $0x30,%rsp
  8012e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 5: Your code here.
	//panic("file_get_block not implemented");
	//cprintf("called from file_get_walk\n");
	if(filebno >= NDIRECT + NINDIRECT || !f || !blk)
  8012ee:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  8012f5:	77 0e                	ja     801305 <file_get_block+0x2a>
  8012f7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012fc:	74 07                	je     801305 <file_get_block+0x2a>
  8012fe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801303:	75 0a                	jne    80130f <file_get_block+0x34>
	{
		return -E_INVAL;
  801305:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130a:	e9 e4 00 00 00       	jmpq   8013f3 <file_get_block+0x118>
	}
	uint32_t * pdiskbno;
	if(file_block_walk(f, filebno, &pdiskbno, true) < 0)
  80130f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801313:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80131f:	48 89 c7             	mov    %rax,%rdi
  801322:	48 b8 2e 11 80 00 00 	movabs $0x80112e,%rax
  801329:	00 00 00 
  80132c:	ff d0                	callq  *%rax
  80132e:	85 c0                	test   %eax,%eax
  801330:	79 0a                	jns    80133c <file_get_block+0x61>
	{
		return -E_NO_DISK;
  801332:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801337:	e9 b7 00 00 00       	jmpq   8013f3 <file_get_block+0x118>
	}
	if(*pdiskbno != 0)
  80133c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801340:	8b 00                	mov    (%rax),%eax
  801342:	85 c0                	test   %eax,%eax
  801344:	74 23                	je     801369 <file_get_block+0x8e>
	{
		*blk = (char*)diskaddr(*pdiskbno);
  801346:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134a:	8b 00                	mov    (%rax),%eax
  80134c:	89 c0                	mov    %eax,%eax
  80134e:	48 89 c7             	mov    %rax,%rdi
  801351:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801358:	00 00 00 
  80135b:	ff d0                	callq  *%rax
  80135d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801361:	48 89 02             	mov    %rax,(%rdx)
  801364:	e9 85 00 00 00       	jmpq   8013ee <file_get_block+0x113>
	}
	else
	{
		uint32_t freeBlock = -1;
  801369:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
		freeBlock = alloc_block();
  801370:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  801377:	00 00 00 
  80137a:	ff d0                	callq  *%rax
  80137c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		
		if(freeBlock == -E_NO_DISK)
  80137f:	83 7d fc f6          	cmpl   $0xfffffff6,-0x4(%rbp)
  801383:	75 27                	jne    8013ac <file_get_block+0xd1>
		{
			//f->f_indirect = freeBlock;
			fprintf(1,"file get blockreturning from here with -E_NO_DISK");
  801385:	48 be 10 71 80 00 00 	movabs $0x807110,%rsi
  80138c:	00 00 00 
  80138f:	bf 01 00 00 00       	mov    $0x1,%edi
  801394:	b8 00 00 00 00       	mov    $0x0,%eax
  801399:	48 ba c6 62 80 00 00 	movabs $0x8062c6,%rdx
  8013a0:	00 00 00 
  8013a3:	ff d2                	callq  *%rdx
			return -E_NO_DISK;
  8013a5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013aa:	eb 47                	jmp    8013f3 <file_get_block+0x118>
		}
		
		fprintf(1,"file get blockcalled from file_block_walk2\n");
  8013ac:	48 be 48 71 80 00 00 	movabs $0x807148,%rsi
  8013b3:	00 00 00 
  8013b6:	bf 01 00 00 00       	mov    $0x1,%edi
  8013bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c0:	48 ba c6 62 80 00 00 	movabs $0x8062c6,%rdx
  8013c7:	00 00 00 
  8013ca:	ff d2                	callq  *%rdx
		*pdiskbno = freeBlock;
  8013cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8013d3:	89 10                	mov    %edx,(%rax)
		*blk = (char*)diskaddr(freeBlock);
  8013d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013d8:	48 89 c7             	mov    %rax,%rdi
  8013db:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8013e2:	00 00 00 
  8013e5:	ff d0                	callq  *%rax
  8013e7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013eb:	48 89 02             	mov    %rax,(%rdx)
	}
	return 0;
  8013ee:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("file_block_walk not implemented");
}
  8013f3:	c9                   	leaveq 
  8013f4:	c3                   	retq   

00000000008013f5 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  8013f5:	55                   	push   %rbp
  8013f6:	48 89 e5             	mov    %rsp,%rbp
  8013f9:	48 83 ec 40          	sub    $0x40,%rsp
  8013fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801401:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801405:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  801409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140d:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801413:	25 ff 0f 00 00       	and    $0xfff,%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 35                	je     801451 <dir_lookup+0x5c>
  80141c:	48 b9 74 71 80 00 00 	movabs $0x807174,%rcx
  801423:	00 00 00 
  801426:	48 ba 7a 70 80 00 00 	movabs $0x80707a,%rdx
  80142d:	00 00 00 
  801430:	be 0f 01 00 00       	mov    $0x10f,%esi
  801435:	48 bf e5 6f 80 00 00 	movabs $0x806fe5,%rdi
  80143c:	00 00 00 
  80143f:	b8 00 00 00 00       	mov    $0x0,%eax
  801444:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  80144b:	00 00 00 
  80144e:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801455:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80145b:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801461:	85 c0                	test   %eax,%eax
  801463:	0f 48 c2             	cmovs  %edx,%eax
  801466:	c1 f8 0c             	sar    $0xc,%eax
  801469:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  80146c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801473:	e9 93 00 00 00       	jmpq   80150b <dir_lookup+0x116>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801478:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80147c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80147f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801483:	89 ce                	mov    %ecx,%esi
  801485:	48 89 c7             	mov    %rax,%rdi
  801488:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  80148f:	00 00 00 
  801492:	ff d0                	callq  *%rax
  801494:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801497:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80149b:	79 05                	jns    8014a2 <dir_lookup+0xad>
			return r;
  80149d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014a0:	eb 7a                	jmp    80151c <dir_lookup+0x127>
		f = (struct File*) blk;
  8014a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  8014aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8014b1:	eb 4e                	jmp    801501 <dir_lookup+0x10c>
			if (strcmp(f[j].f_name, name) == 0) {
  8014b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014b6:	48 c1 e0 08          	shl    $0x8,%rax
  8014ba:	48 89 c2             	mov    %rax,%rdx
  8014bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c1:	48 01 d0             	add    %rdx,%rax
  8014c4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8014c8:	48 89 d6             	mov    %rdx,%rsi
  8014cb:	48 89 c7             	mov    %rax,%rdi
  8014ce:	48 b8 0c 42 80 00 00 	movabs $0x80420c,%rax
  8014d5:	00 00 00 
  8014d8:	ff d0                	callq  *%rax
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	75 1f                	jne    8014fd <dir_lookup+0x108>
				*file = &f[j];
  8014de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014e1:	48 c1 e0 08          	shl    $0x8,%rax
  8014e5:	48 89 c2             	mov    %rax,%rdx
  8014e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ec:	48 01 c2             	add    %rax,%rdx
  8014ef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8014f3:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	eb 1f                	jmp    80151c <dir_lookup+0x127>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8014fd:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801501:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801505:	76 ac                	jbe    8014b3 <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801507:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80150b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80150e:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801511:	0f 82 61 ff ff ff    	jb     801478 <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  801517:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 30          	sub    $0x30,%rsp
  801526:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80152a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  80152e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801532:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801538:	25 ff 0f 00 00       	and    $0xfff,%eax
  80153d:	85 c0                	test   %eax,%eax
  80153f:	74 35                	je     801576 <dir_alloc_file+0x58>
  801541:	48 b9 74 71 80 00 00 	movabs $0x807174,%rcx
  801548:	00 00 00 
  80154b:	48 ba 7a 70 80 00 00 	movabs $0x80707a,%rdx
  801552:	00 00 00 
  801555:	be 28 01 00 00       	mov    $0x128,%esi
  80155a:	48 bf e5 6f 80 00 00 	movabs $0x806fe5,%rdi
  801561:	00 00 00 
  801564:	b8 00 00 00 00       	mov    $0x0,%eax
  801569:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  801570:	00 00 00 
  801573:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801576:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157a:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801580:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801586:	85 c0                	test   %eax,%eax
  801588:	0f 48 c2             	cmovs  %edx,%eax
  80158b:	c1 f8 0c             	sar    $0xc,%eax
  80158e:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  801591:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801598:	e9 83 00 00 00       	jmpq   801620 <dir_alloc_file+0x102>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  80159d:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8015a1:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8015a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a8:	89 ce                	mov    %ecx,%esi
  8015aa:	48 89 c7             	mov    %rax,%rdi
  8015ad:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  8015b4:	00 00 00 
  8015b7:	ff d0                	callq  *%rax
  8015b9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8015bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8015c0:	79 08                	jns    8015ca <dir_alloc_file+0xac>
			return r;
  8015c2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8015c5:	e9 be 00 00 00       	jmpq   801688 <dir_alloc_file+0x16a>
		f = (struct File*) blk;
  8015ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  8015d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8015d9:	eb 3b                	jmp    801616 <dir_alloc_file+0xf8>
			if (f[j].f_name[0] == '\0') {
  8015db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015de:	48 c1 e0 08          	shl    $0x8,%rax
  8015e2:	48 89 c2             	mov    %rax,%rdx
  8015e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e9:	48 01 d0             	add    %rdx,%rax
  8015ec:	0f b6 00             	movzbl (%rax),%eax
  8015ef:	84 c0                	test   %al,%al
  8015f1:	75 1f                	jne    801612 <dir_alloc_file+0xf4>
				*file = &f[j];
  8015f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015f6:	48 c1 e0 08          	shl    $0x8,%rax
  8015fa:	48 89 c2             	mov    %rax,%rdx
  8015fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801601:	48 01 c2             	add    %rax,%rdx
  801604:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801608:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
  801610:	eb 76                	jmp    801688 <dir_alloc_file+0x16a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  801612:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801616:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  80161a:	76 bf                	jbe    8015db <dir_alloc_file+0xbd>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  80161c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801620:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801623:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801626:	0f 82 71 ff ff ff    	jb     80159d <dir_alloc_file+0x7f>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  80162c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801630:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801636:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  80163c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801640:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801646:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80164a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80164d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801651:	89 ce                	mov    %ecx,%esi
  801653:	48 89 c7             	mov    %rax,%rdi
  801656:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  80165d:	00 00 00 
  801660:	ff d0                	callq  *%rax
  801662:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801665:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801669:	79 05                	jns    801670 <dir_alloc_file+0x152>
		return r;
  80166b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80166e:	eb 18                	jmp    801688 <dir_alloc_file+0x16a>
	f = (struct File*) blk;
  801670:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801674:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  801678:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80167c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801680:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801688:	c9                   	leaveq 
  801689:	c3                   	retq   

000000000080168a <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  80168a:	55                   	push   %rbp
  80168b:	48 89 e5             	mov    %rsp,%rbp
  80168e:	48 83 ec 08          	sub    $0x8,%rsp
  801692:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  801696:	eb 05                	jmp    80169d <skip_slash+0x13>
		p++;
  801698:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  80169d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a1:	0f b6 00             	movzbl (%rax),%eax
  8016a4:	3c 2f                	cmp    $0x2f,%al
  8016a6:	74 f0                	je     801698 <skip_slash+0xe>
		p++;
	return p;
  8016a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016ac:	c9                   	leaveq 
  8016ad:	c3                   	retq   

00000000008016ae <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  8016ae:	55                   	push   %rbp
  8016af:	48 89 e5             	mov    %rsp,%rbp
  8016b2:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8016b9:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  8016c0:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  8016c7:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  8016ce:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  8016d5:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8016dc:	48 89 c7             	mov    %rax,%rdi
  8016df:	48 b8 8a 16 80 00 00 	movabs $0x80168a,%rax
  8016e6:	00 00 00 
  8016e9:	ff d0                	callq  *%rax
  8016eb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  8016f2:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8016f9:	00 00 00 
  8016fc:	48 8b 00             	mov    (%rax),%rax
  8016ff:	48 83 c0 08          	add    $0x8,%rax
  801703:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  80170a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801711:	00 
	name[0] = 0;
  801712:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  801719:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801720:	00 
  801721:	74 0e                	je     801731 <walk_path+0x83>
		*pdir = 0;
  801723:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  80172a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  801731:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801738:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  80173f:	e9 73 01 00 00       	jmpq   8018b7 <walk_path+0x209>
		dir = f;
  801744:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80174b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  80174f:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801756:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  80175a:	eb 08                	jmp    801764 <walk_path+0xb6>
			path++;
  80175c:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  801763:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  801764:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80176b:	0f b6 00             	movzbl (%rax),%eax
  80176e:	3c 2f                	cmp    $0x2f,%al
  801770:	74 0e                	je     801780 <walk_path+0xd2>
  801772:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801779:	0f b6 00             	movzbl (%rax),%eax
  80177c:	84 c0                	test   %al,%al
  80177e:	75 dc                	jne    80175c <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  801780:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801787:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80178b:	48 29 c2             	sub    %rax,%rdx
  80178e:	48 89 d0             	mov    %rdx,%rax
  801791:	48 83 f8 7f          	cmp    $0x7f,%rax
  801795:	7e 0a                	jle    8017a1 <walk_path+0xf3>
			return -E_BAD_PATH;
  801797:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80179c:	e9 56 01 00 00       	jmpq   8018f7 <walk_path+0x249>
		memmove(name, p, path - p);
  8017a1:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8017a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ac:	48 29 c2             	sub    %rax,%rdx
  8017af:	48 89 d0             	mov    %rdx,%rax
  8017b2:	48 89 c2             	mov    %rax,%rdx
  8017b5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017b9:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  8017c0:	48 89 ce             	mov    %rcx,%rsi
  8017c3:	48 89 c7             	mov    %rax,%rdi
  8017c6:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  8017cd:	00 00 00 
  8017d0:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  8017d2:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8017d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017dd:	48 29 c2             	sub    %rax,%rdx
  8017e0:	48 89 d0             	mov    %rdx,%rax
  8017e3:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  8017ea:	00 
		path = skip_slash(path);
  8017eb:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8017f2:	48 89 c7             	mov    %rax,%rdi
  8017f5:	48 b8 8a 16 80 00 00 	movabs $0x80168a,%rax
  8017fc:	00 00 00 
  8017ff:	ff d0                	callq  *%rax
  801801:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  801808:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80180c:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801812:	83 f8 01             	cmp    $0x1,%eax
  801815:	74 0a                	je     801821 <walk_path+0x173>
			return -E_NOT_FOUND;
  801817:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80181c:	e9 d6 00 00 00       	jmpq   8018f7 <walk_path+0x249>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  801821:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  801828:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  80182f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801833:	48 89 ce             	mov    %rcx,%rsi
  801836:	48 89 c7             	mov    %rax,%rdi
  801839:	48 b8 f5 13 80 00 00 	movabs $0x8013f5,%rax
  801840:	00 00 00 
  801843:	ff d0                	callq  *%rax
  801845:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801848:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80184c:	79 69                	jns    8018b7 <walk_path+0x209>
			if (r == -E_NOT_FOUND && *path == '\0') {
  80184e:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  801852:	75 5e                	jne    8018b2 <walk_path+0x204>
  801854:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80185b:	0f b6 00             	movzbl (%rax),%eax
  80185e:	84 c0                	test   %al,%al
  801860:	75 50                	jne    8018b2 <walk_path+0x204>
				if (pdir)
  801862:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801869:	00 
  80186a:	74 0e                	je     80187a <walk_path+0x1cc>
					*pdir = dir;
  80186c:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801873:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801877:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  80187a:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  801881:	00 
  801882:	74 20                	je     8018a4 <walk_path+0x1f6>
					strcpy(lastelem, name);
  801884:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80188b:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  801892:	48 89 d6             	mov    %rdx,%rsi
  801895:	48 89 c7             	mov    %rax,%rdi
  801898:	48 b8 aa 40 80 00 00 	movabs $0x8040aa,%rax
  80189f:	00 00 00 
  8018a2:	ff d0                	callq  *%rax
				*pf = 0;
  8018a4:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8018ab:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  8018b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018b5:	eb 40                	jmp    8018f7 <walk_path+0x249>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  8018b7:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8018be:	0f b6 00             	movzbl (%rax),%eax
  8018c1:	84 c0                	test   %al,%al
  8018c3:	0f 85 7b fe ff ff    	jne    801744 <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  8018c9:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8018d0:	00 
  8018d1:	74 0e                	je     8018e1 <walk_path+0x233>
		*pdir = dir;
  8018d3:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8018da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018de:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  8018e1:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8018e8:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8018ef:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8018f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f7:	c9                   	leaveq 
  8018f8:	c3                   	retq   

00000000008018f9 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  8018f9:	55                   	push   %rbp
  8018fa:	48 89 e5             	mov    %rsp,%rbp
  8018fd:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801904:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  80190b:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801912:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  801919:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801920:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  801927:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80192e:	48 89 c7             	mov    %rax,%rdi
  801931:	48 b8 ae 16 80 00 00 	movabs $0x8016ae,%rax
  801938:	00 00 00 
  80193b:	ff d0                	callq  *%rax
  80193d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801940:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801944:	75 0a                	jne    801950 <file_create+0x57>
		return -E_FILE_EXISTS;
  801946:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80194b:	e9 91 00 00 00       	jmpq   8019e1 <file_create+0xe8>
	if (r != -E_NOT_FOUND || dir == 0)
  801950:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  801954:	75 0c                	jne    801962 <file_create+0x69>
  801956:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80195d:	48 85 c0             	test   %rax,%rax
  801960:	75 05                	jne    801967 <file_create+0x6e>
		return r;
  801962:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801965:	eb 7a                	jmp    8019e1 <file_create+0xe8>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  801967:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80196e:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801975:	48 89 d6             	mov    %rdx,%rsi
  801978:	48 89 c7             	mov    %rax,%rdi
  80197b:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  801982:	00 00 00 
  801985:	ff d0                	callq  *%rax
  801987:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80198a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80198e:	79 05                	jns    801995 <file_create+0x9c>
		return r;
  801990:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801993:	eb 4c                	jmp    8019e1 <file_create+0xe8>
	strcpy(f->f_name, name);
  801995:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80199c:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  8019a3:	48 89 d6             	mov    %rdx,%rsi
  8019a6:	48 89 c7             	mov    %rax,%rdi
  8019a9:	48 b8 aa 40 80 00 00 	movabs $0x8040aa,%rax
  8019b0:	00 00 00 
  8019b3:	ff d0                	callq  *%rax
	*pf = f;
  8019b5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8019bc:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8019c3:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  8019c6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8019cd:	48 89 c7             	mov    %rax,%rdi
  8019d0:	48 b8 6f 1e 80 00 00 	movabs $0x801e6f,%rax
  8019d7:	00 00 00 
  8019da:	ff d0                	callq  *%rax
	return 0;
  8019dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e1:	c9                   	leaveq 
  8019e2:	c3                   	retq   

00000000008019e3 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  8019e3:	55                   	push   %rbp
  8019e4:	48 89 e5             	mov    %rsp,%rbp
  8019e7:	48 83 ec 10          	sub    $0x10,%rsp
  8019eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  8019f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a00:	be 00 00 00 00       	mov    $0x0,%esi
  801a05:	48 89 c7             	mov    %rax,%rdi
  801a08:	48 b8 ae 16 80 00 00 	movabs $0x8016ae,%rax
  801a0f:	00 00 00 
  801a12:	ff d0                	callq  *%rax
}
  801a14:	c9                   	leaveq 
  801a15:	c3                   	retq   

0000000000801a16 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  801a16:	55                   	push   %rbp
  801a17:	48 89 e5             	mov    %rsp,%rbp
  801a1a:	48 83 ec 60          	sub    $0x60,%rsp
  801a1e:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  801a22:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  801a26:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  801a2a:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  801a2d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a31:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a37:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  801a3a:	7f 0a                	jg     801a46 <file_read+0x30>
		return 0;
  801a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a41:	e9 24 01 00 00       	jmpq   801b6a <file_read+0x154>

	count = MIN(count, f->f_size - offset);
  801a46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a4a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801a4e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a52:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a58:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  801a5b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a61:	48 63 d0             	movslq %eax,%rdx
  801a64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a68:	48 39 c2             	cmp    %rax,%rdx
  801a6b:	48 0f 46 c2          	cmovbe %rdx,%rax
  801a6f:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  801a73:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801a76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a79:	e9 cd 00 00 00       	jmpq   801b4b <file_read+0x135>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801a7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a81:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801a87:	85 c0                	test   %eax,%eax
  801a89:	0f 48 c2             	cmovs  %edx,%eax
  801a8c:	c1 f8 0c             	sar    $0xc,%eax
  801a8f:	89 c1                	mov    %eax,%ecx
  801a91:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801a95:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a99:	89 ce                	mov    %ecx,%esi
  801a9b:	48 89 c7             	mov    %rax,%rdi
  801a9e:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  801aa5:	00 00 00 
  801aa8:	ff d0                	callq  *%rax
  801aaa:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801aad:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801ab1:	79 08                	jns    801abb <file_read+0xa5>
			return r;
  801ab3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801ab6:	e9 af 00 00 00       	jmpq   801b6a <file_read+0x154>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801abe:	99                   	cltd   
  801abf:	c1 ea 14             	shr    $0x14,%edx
  801ac2:	01 d0                	add    %edx,%eax
  801ac4:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ac9:	29 d0                	sub    %edx,%eax
  801acb:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ad0:	29 c2                	sub    %eax,%edx
  801ad2:	89 d0                	mov    %edx,%eax
  801ad4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801ad7:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801ada:	48 63 d0             	movslq %eax,%rdx
  801add:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ae1:	48 01 c2             	add    %rax,%rdx
  801ae4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae7:	48 98                	cltq   
  801ae9:	48 29 c2             	sub    %rax,%rdx
  801aec:	48 89 d0             	mov    %rdx,%rax
  801aef:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801af3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801af6:	48 63 d0             	movslq %eax,%rdx
  801af9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afd:	48 39 c2             	cmp    %rax,%rdx
  801b00:	48 0f 46 c2          	cmovbe %rdx,%rax
  801b04:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  801b07:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b0a:	48 63 c8             	movslq %eax,%rcx
  801b0d:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801b11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b14:	99                   	cltd   
  801b15:	c1 ea 14             	shr    $0x14,%edx
  801b18:	01 d0                	add    %edx,%eax
  801b1a:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b1f:	29 d0                	sub    %edx,%eax
  801b21:	48 98                	cltq   
  801b23:	48 01 c6             	add    %rax,%rsi
  801b26:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801b2a:	48 89 ca             	mov    %rcx,%rdx
  801b2d:	48 89 c7             	mov    %rax,%rdi
  801b30:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  801b37:	00 00 00 
  801b3a:	ff d0                	callq  *%rax
		pos += bn;
  801b3c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b3f:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801b42:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b45:	48 98                	cltq   
  801b47:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  801b4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4e:	48 98                	cltq   
  801b50:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  801b53:	48 63 ca             	movslq %edx,%rcx
  801b56:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801b5a:	48 01 ca             	add    %rcx,%rdx
  801b5d:	48 39 d0             	cmp    %rdx,%rax
  801b60:	0f 82 18 ff ff ff    	jb     801a7e <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801b66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  801b6a:	c9                   	leaveq 
  801b6b:	c3                   	retq   

0000000000801b6c <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801b6c:	55                   	push   %rbp
  801b6d:	48 89 e5             	mov    %rsp,%rbp
  801b70:	48 83 ec 50          	sub    $0x50,%rsp
  801b74:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801b78:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801b7c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801b80:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801b83:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801b86:	48 63 d0             	movslq %eax,%rdx
  801b89:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b8d:	48 01 c2             	add    %rax,%rdx
  801b90:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b94:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801b9a:	48 98                	cltq   
  801b9c:	48 39 c2             	cmp    %rax,%rdx
  801b9f:	76 33                	jbe    801bd4 <file_write+0x68>
		if ((r = file_set_size(f, offset + count)) < 0)
  801ba1:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801ba5:	89 c2                	mov    %eax,%edx
  801ba7:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801baa:	01 d0                	add    %edx,%eax
  801bac:	89 c2                	mov    %eax,%edx
  801bae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bb2:	89 d6                	mov    %edx,%esi
  801bb4:	48 89 c7             	mov    %rax,%rdi
  801bb7:	48 b8 12 1e 80 00 00 	movabs $0x801e12,%rax
  801bbe:	00 00 00 
  801bc1:	ff d0                	callq  *%rax
  801bc3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801bc6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801bca:	79 08                	jns    801bd4 <file_write+0x68>
			return r;
  801bcc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bcf:	e9 f8 00 00 00       	jmpq   801ccc <file_write+0x160>

	for (pos = offset; pos < offset + count; ) {
  801bd4:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801bd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bda:	e9 ce 00 00 00       	jmpq   801cad <file_write+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801bdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be2:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801be8:	85 c0                	test   %eax,%eax
  801bea:	0f 48 c2             	cmovs  %edx,%eax
  801bed:	c1 f8 0c             	sar    $0xc,%eax
  801bf0:	89 c1                	mov    %eax,%ecx
  801bf2:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801bf6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bfa:	89 ce                	mov    %ecx,%esi
  801bfc:	48 89 c7             	mov    %rax,%rdi
  801bff:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  801c06:	00 00 00 
  801c09:	ff d0                	callq  *%rax
  801c0b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801c0e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801c12:	79 08                	jns    801c1c <file_write+0xb0>
			return r;
  801c14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c17:	e9 b0 00 00 00       	jmpq   801ccc <file_write+0x160>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801c1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1f:	99                   	cltd   
  801c20:	c1 ea 14             	shr    $0x14,%edx
  801c23:	01 d0                	add    %edx,%eax
  801c25:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c2a:	29 d0                	sub    %edx,%eax
  801c2c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c31:	29 c2                	sub    %eax,%edx
  801c33:	89 d0                	mov    %edx,%eax
  801c35:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801c38:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801c3b:	48 63 d0             	movslq %eax,%rdx
  801c3e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801c42:	48 01 c2             	add    %rax,%rdx
  801c45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c48:	48 98                	cltq   
  801c4a:	48 29 c2             	sub    %rax,%rdx
  801c4d:	48 89 d0             	mov    %rdx,%rax
  801c50:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c54:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c57:	48 63 d0             	movslq %eax,%rdx
  801c5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c5e:	48 39 c2             	cmp    %rax,%rdx
  801c61:	48 0f 46 c2          	cmovbe %rdx,%rax
  801c65:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  801c68:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c6b:	48 63 c8             	movslq %eax,%rcx
  801c6e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801c72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c75:	99                   	cltd   
  801c76:	c1 ea 14             	shr    $0x14,%edx
  801c79:	01 d0                	add    %edx,%eax
  801c7b:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c80:	29 d0                	sub    %edx,%eax
  801c82:	48 98                	cltq   
  801c84:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801c88:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801c8c:	48 89 ca             	mov    %rcx,%rdx
  801c8f:	48 89 c6             	mov    %rax,%rsi
  801c92:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  801c99:	00 00 00 
  801c9c:	ff d0                	callq  *%rax
		pos += bn;
  801c9e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ca1:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801ca4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ca7:	48 98                	cltq   
  801ca9:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  801cad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb0:	48 98                	cltq   
  801cb2:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  801cb5:	48 63 ca             	movslq %edx,%rcx
  801cb8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801cbc:	48 01 ca             	add    %rcx,%rdx
  801cbf:	48 39 d0             	cmp    %rdx,%rax
  801cc2:	0f 82 17 ff ff ff    	jb     801bdf <file_write+0x73>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801cc8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801ccc:	c9                   	leaveq 
  801ccd:	c3                   	retq   

0000000000801cce <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  801cce:	55                   	push   %rbp
  801ccf:	48 89 e5             	mov    %rsp,%rbp
  801cd2:	48 83 ec 20          	sub    $0x20,%rsp
  801cd6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cda:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801cdd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ce1:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ced:	48 89 c7             	mov    %rax,%rdi
  801cf0:	48 b8 2e 11 80 00 00 	movabs $0x80112e,%rax
  801cf7:	00 00 00 
  801cfa:	ff d0                	callq  *%rax
  801cfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d03:	79 05                	jns    801d0a <file_free_block+0x3c>
		return r;
  801d05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d08:	eb 2d                	jmp    801d37 <file_free_block+0x69>
	if (*ptr) {
  801d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d0e:	8b 00                	mov    (%rax),%eax
  801d10:	85 c0                	test   %eax,%eax
  801d12:	74 1e                	je     801d32 <file_free_block+0x64>
		free_block(*ptr);
  801d14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d18:	8b 00                	mov    (%rax),%eax
  801d1a:	89 c7                	mov    %eax,%edi
  801d1c:	48 b8 dc 0d 80 00 00 	movabs $0x800ddc,%rax
  801d23:	00 00 00 
  801d26:	ff d0                	callq  *%rax
		*ptr = 0;
  801d28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d2c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d37:	c9                   	leaveq 
  801d38:	c3                   	retq   

0000000000801d39 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  801d39:	55                   	push   %rbp
  801d3a:	48 89 e5             	mov    %rsp,%rbp
  801d3d:	48 83 ec 20          	sub    $0x20,%rsp
  801d41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d45:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801d48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d4c:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801d52:	05 ff 0f 00 00       	add    $0xfff,%eax
  801d57:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	0f 48 c2             	cmovs  %edx,%eax
  801d62:	c1 f8 0c             	sar    $0xc,%eax
  801d65:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801d68:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d6b:	05 ff 0f 00 00       	add    $0xfff,%eax
  801d70:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801d76:	85 c0                	test   %eax,%eax
  801d78:	0f 48 c2             	cmovs  %edx,%eax
  801d7b:	c1 f8 0c             	sar    $0xc,%eax
  801d7e:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801d81:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d87:	eb 45                	jmp    801dce <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  801d89:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d90:	89 d6                	mov    %edx,%esi
  801d92:	48 89 c7             	mov    %rax,%rdi
  801d95:	48 b8 ce 1c 80 00 00 	movabs $0x801cce,%rax
  801d9c:	00 00 00 
  801d9f:	ff d0                	callq  *%rax
  801da1:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801da4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801da8:	79 20                	jns    801dca <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  801daa:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801dad:	89 c6                	mov    %eax,%esi
  801daf:	48 bf 91 71 80 00 00 	movabs $0x807191,%rdi
  801db6:	00 00 00 
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbe:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  801dc5:	00 00 00 
  801dc8:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801dca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd1:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801dd4:	72 b3                	jb     801d89 <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801dd6:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801dda:	77 34                	ja     801e10 <file_truncate_blocks+0xd7>
  801ddc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de0:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801de6:	85 c0                	test   %eax,%eax
  801de8:	74 26                	je     801e10 <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801dea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dee:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801df4:	89 c7                	mov    %eax,%edi
  801df6:	48 b8 dc 0d 80 00 00 	movabs $0x800ddc,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801e02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e06:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801e0d:	00 00 00 
	}
}
  801e10:	c9                   	leaveq 
  801e11:	c3                   	retq   

0000000000801e12 <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801e12:	55                   	push   %rbp
  801e13:	48 89 e5             	mov    %rsp,%rbp
  801e16:	48 83 ec 10          	sub    $0x10,%rsp
  801e1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e1e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801e21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e25:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801e2b:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801e2e:	7e 18                	jle    801e48 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801e30:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e37:	89 d6                	mov    %edx,%esi
  801e39:	48 89 c7             	mov    %rax,%rdi
  801e3c:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  801e43:	00 00 00 
  801e46:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801e48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e4f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801e55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e59:	48 89 c7             	mov    %rax,%rdi
  801e5c:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  801e63:	00 00 00 
  801e66:	ff d0                	callq  *%rax
	return 0;
  801e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6d:	c9                   	leaveq 
  801e6e:	c3                   	retq   

0000000000801e6f <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801e6f:	55                   	push   %rbp
  801e70:	48 89 e5             	mov    %rsp,%rbp
  801e73:	48 83 ec 20          	sub    $0x20,%rsp
  801e77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;
	//cprintf("called from file_flush\n");
	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801e7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e82:	eb 62                	jmp    801ee6 <file_flush+0x77>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801e84:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e87:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e94:	48 89 c7             	mov    %rax,%rdi
  801e97:	48 b8 2e 11 80 00 00 	movabs $0x80112e,%rax
  801e9e:	00 00 00 
  801ea1:	ff d0                	callq  *%rax
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	78 13                	js     801eba <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;
	//cprintf("called from file_flush\n");
	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801eab:	48 85 c0             	test   %rax,%rax
  801eae:	74 0a                	je     801eba <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb4:	8b 00                	mov    (%rax),%eax
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	75 02                	jne    801ebc <file_flush+0x4d>
			continue;
  801eba:	eb 26                	jmp    801ee2 <file_flush+0x73>
		flush_block(diskaddr(*pdiskbno));
  801ebc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec0:	8b 00                	mov    (%rax),%eax
  801ec2:	89 c0                	mov    %eax,%eax
  801ec4:	48 89 c7             	mov    %rax,%rdi
  801ec7:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801ece:	00 00 00 
  801ed1:	ff d0                	callq  *%rax
  801ed3:	48 89 c7             	mov    %rax,%rdi
  801ed6:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  801edd:	00 00 00 
  801ee0:	ff d0                	callq  *%rax
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;
	//cprintf("called from file_flush\n");
	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801ee2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eea:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801ef0:	05 ff 0f 00 00       	add    $0xfff,%eax
  801ef5:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801efb:	85 c0                	test   %eax,%eax
  801efd:	0f 48 c2             	cmovs  %edx,%eax
  801f00:	c1 f8 0c             	sar    $0xc,%eax
  801f03:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801f06:	0f 8f 78 ff ff ff    	jg     801e84 <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f10:	48 89 c7             	mov    %rax,%rdi
  801f13:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  801f1a:	00 00 00 
  801f1d:	ff d0                	callq  *%rax
	if (f->f_indirect)
  801f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f23:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	74 2a                	je     801f57 <file_flush+0xe8>
		flush_block(diskaddr(f->f_indirect));
  801f2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f31:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801f37:	89 c0                	mov    %eax,%eax
  801f39:	48 89 c7             	mov    %rax,%rdi
  801f3c:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801f43:	00 00 00 
  801f46:	ff d0                	callq  *%rax
  801f48:	48 89 c7             	mov    %rax,%rdi
  801f4b:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  801f52:	00 00 00 
  801f55:	ff d0                	callq  *%rax
}
  801f57:	c9                   	leaveq 
  801f58:	c3                   	retq   

0000000000801f59 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801f59:	55                   	push   %rbp
  801f5a:	48 89 e5             	mov    %rsp,%rbp
  801f5d:	48 83 ec 20          	sub    $0x20,%rsp
  801f61:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801f65:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f72:	be 00 00 00 00       	mov    $0x0,%esi
  801f77:	48 89 c7             	mov    %rax,%rdi
  801f7a:	48 b8 ae 16 80 00 00 	movabs $0x8016ae,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
  801f86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f8d:	79 05                	jns    801f94 <file_remove+0x3b>
		return r;
  801f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f92:	eb 45                	jmp    801fd9 <file_remove+0x80>

	file_truncate_blocks(f, 0);
  801f94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f98:	be 00 00 00 00       	mov    $0x0,%esi
  801f9d:	48 89 c7             	mov    %rax,%rdi
  801fa0:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  801fa7:	00 00 00 
  801faa:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  801fac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb0:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  801fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801fbe:	00 00 00 
	flush_block(f);
  801fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc5:	48 89 c7             	mov    %rax,%rdi
  801fc8:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  801fcf:	00 00 00 
  801fd2:	ff d0                	callq  *%rax

	return 0;
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd9:	c9                   	leaveq 
  801fda:	c3                   	retq   

0000000000801fdb <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801fdb:	55                   	push   %rbp
  801fdc:	48 89 e5             	mov    %rsp,%rbp
  801fdf:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801fe3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801fea:	eb 27                	jmp    802013 <fs_sync+0x38>
		flush_block(diskaddr(i));
  801fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fef:	48 98                	cltq   
  801ff1:	48 89 c7             	mov    %rax,%rdi
  801ff4:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801ffb:	00 00 00 
  801ffe:	ff d0                	callq  *%rax
  802000:	48 89 c7             	mov    %rax,%rdi
  802003:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  80200f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802013:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802016:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  80201d:	00 00 00 
  802020:	48 8b 00             	mov    (%rax),%rax
  802023:	8b 40 04             	mov    0x4(%rax),%eax
  802026:	39 c2                	cmp    %eax,%edx
  802028:	72 c2                	jb     801fec <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  80202a:	c9                   	leaveq 
  80202b:	c3                   	retq   

000000000080202c <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  80202c:	55                   	push   %rbp
  80202d:	48 89 e5             	mov    %rsp,%rbp
  802030:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  802034:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  802039:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  80203d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802044:	eb 4b                	jmp    802091 <serve_init+0x65>
		opentab[i].o_fileid = i;
  802046:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802049:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  802050:	00 00 00 
  802053:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802056:	48 63 c9             	movslq %ecx,%rcx
  802059:	48 c1 e1 05          	shl    $0x5,%rcx
  80205d:	48 01 ca             	add    %rcx,%rdx
  802060:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  802062:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802066:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  80206d:	00 00 00 
  802070:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802073:	48 63 c9             	movslq %ecx,%rcx
  802076:	48 c1 e1 05          	shl    $0x5,%rcx
  80207a:	48 01 ca             	add    %rcx,%rdx
  80207d:	48 83 c2 10          	add    $0x10,%rdx
  802081:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  802085:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  80208c:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  80208d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802091:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802098:	7e ac                	jle    802046 <serve_init+0x1a>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  80209a:	c9                   	leaveq 
  80209b:	c3                   	retq   

000000000080209c <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  80209c:	55                   	push   %rbp
  80209d:	48 89 e5             	mov    %rsp,%rbp
  8020a0:	48 83 ec 20          	sub    $0x20,%rsp
  8020a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8020a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020af:	e9 24 01 00 00       	jmpq   8021d8 <openfile_alloc+0x13c>
		switch (pageref(opentab[i].o_fd)) {
  8020b4:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020bb:	00 00 00 
  8020be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020c1:	48 63 d2             	movslq %edx,%rdx
  8020c4:	48 c1 e2 05          	shl    $0x5,%rdx
  8020c8:	48 01 d0             	add    %rdx,%rax
  8020cb:	48 83 c0 10          	add    $0x10,%rax
  8020cf:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020d3:	48 89 c7             	mov    %rax,%rdi
  8020d6:	48 b8 34 64 80 00 00 	movabs $0x806434,%rax
  8020dd:	00 00 00 
  8020e0:	ff d0                	callq  *%rax
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	74 0a                	je     8020f0 <openfile_alloc+0x54>
  8020e6:	83 f8 01             	cmp    $0x1,%eax
  8020e9:	74 4e                	je     802139 <openfile_alloc+0x9d>
  8020eb:	e9 e4 00 00 00       	jmpq   8021d4 <openfile_alloc+0x138>
		#ifndef VMM_GUEST	
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  8020f0:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020f7:	00 00 00 
  8020fa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020fd:	48 63 d2             	movslq %edx,%rdx
  802100:	48 c1 e2 05          	shl    $0x5,%rdx
  802104:	48 01 d0             	add    %rdx,%rax
  802107:	48 83 c0 10          	add    $0x10,%rax
  80210b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80210f:	ba 07 00 00 00       	mov    $0x7,%edx
  802114:	48 89 c6             	mov    %rax,%rsi
  802117:	bf 00 00 00 00       	mov    $0x0,%edi
  80211c:	48 b8 d9 49 80 00 00 	movabs $0x8049d9,%rax
  802123:	00 00 00 
  802126:	ff d0                	callq  *%rax
  802128:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80212b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80212f:	79 08                	jns    802139 <openfile_alloc+0x9d>
				return r;
  802131:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802134:	e9 b1 00 00 00       	jmpq   8021ea <openfile_alloc+0x14e>
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  802139:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802140:	00 00 00 
  802143:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802146:	48 63 d2             	movslq %edx,%rdx
  802149:	48 c1 e2 05          	shl    $0x5,%rdx
  80214d:	48 01 d0             	add    %rdx,%rax
  802150:	8b 00                	mov    (%rax),%eax
  802152:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  802158:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80215f:	00 00 00 
  802162:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802165:	48 63 c9             	movslq %ecx,%rcx
  802168:	48 c1 e1 05          	shl    $0x5,%rcx
  80216c:	48 01 c8             	add    %rcx,%rax
  80216f:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  802171:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802174:	48 98                	cltq   
  802176:	48 c1 e0 05          	shl    $0x5,%rax
  80217a:	48 89 c2             	mov    %rax,%rdx
  80217d:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802184:	00 00 00 
  802187:	48 01 c2             	add    %rax,%rdx
  80218a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218e:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  802191:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802198:	00 00 00 
  80219b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80219e:	48 63 d2             	movslq %edx,%rdx
  8021a1:	48 c1 e2 05          	shl    $0x5,%rdx
  8021a5:	48 01 d0             	add    %rdx,%rax
  8021a8:	48 83 c0 10          	add    $0x10,%rax
  8021ac:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021b0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021b5:	be 00 00 00 00       	mov    $0x0,%esi
  8021ba:	48 89 c7             	mov    %rax,%rdi
  8021bd:	48 b8 43 43 80 00 00 	movabs $0x804343,%rax
  8021c4:	00 00 00 
  8021c7:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  8021c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cd:	48 8b 00             	mov    (%rax),%rax
  8021d0:	8b 00                	mov    (%rax),%eax
  8021d2:	eb 16                	jmp    8021ea <openfile_alloc+0x14e>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8021d4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021d8:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8021df:	0f 8e cf fe ff ff    	jle    8020b4 <openfile_alloc+0x18>
			}
		#endif
		}
	}
	//cprintf("am I returning from here ????");
	return -E_MAX_OPEN;
  8021e5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021ea:	c9                   	leaveq 
  8021eb:	c3                   	retq   

00000000008021ec <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8021ec:	55                   	push   %rbp
  8021ed:	48 89 e5             	mov    %rsp,%rbp
  8021f0:	48 83 ec 20          	sub    $0x20,%rsp
  8021f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021f7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8021fa:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8021fe:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802201:	25 ff 03 00 00       	and    $0x3ff,%eax
  802206:	89 c0                	mov    %eax,%eax
  802208:	48 c1 e0 05          	shl    $0x5,%rax
  80220c:	48 89 c2             	mov    %rax,%rdx
  80220f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802216:	00 00 00 
  802219:	48 01 d0             	add    %rdx,%rax
  80221c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  802220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802224:	48 8b 40 18          	mov    0x18(%rax),%rax
  802228:	48 89 c7             	mov    %rax,%rdi
  80222b:	48 b8 34 64 80 00 00 	movabs $0x806434,%rax
  802232:	00 00 00 
  802235:	ff d0                	callq  *%rax
  802237:	83 f8 01             	cmp    $0x1,%eax
  80223a:	74 0b                	je     802247 <openfile_lookup+0x5b>
  80223c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802240:	8b 00                	mov    (%rax),%eax
  802242:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802245:	74 07                	je     80224e <openfile_lookup+0x62>
		return -E_INVAL;
  802247:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80224c:	eb 10                	jmp    80225e <openfile_lookup+0x72>
	*po = o;
  80224e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802252:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802256:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802259:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225e:	c9                   	leaveq 
  80225f:	c3                   	retq   

0000000000802260 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  802260:	55                   	push   %rbp
  802261:	48 89 e5             	mov    %rsp,%rbp
  802264:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  80226b:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  802271:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  802278:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  80227f:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802286:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  80228d:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802294:	ba 00 04 00 00       	mov    $0x400,%edx
  802299:	48 89 ce             	mov    %rcx,%rsi
  80229c:	48 89 c7             	mov    %rax,%rdi
  80229f:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  8022a6:	00 00 00 
  8022a9:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8022ab:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  8022af:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  8022b6:	48 89 c7             	mov    %rax,%rdi
  8022b9:	48 b8 9c 20 80 00 00 	movabs $0x80209c,%rax
  8022c0:	00 00 00 
  8022c3:	ff d0                	callq  *%rax
  8022c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022cc:	79 08                	jns    8022d6 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  8022ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d1:	e9 7c 01 00 00       	jmpq   802452 <serve_open+0x1f2>
	}
	fileid = r;
  8022d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d9:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  8022dc:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8022e3:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8022e9:	25 00 01 00 00       	and    $0x100,%eax
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	74 4f                	je     802341 <serve_open+0xe1>
		if ((r = file_create(path, &f)) < 0) {
  8022f2:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  8022f9:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802300:	48 89 d6             	mov    %rdx,%rsi
  802303:	48 89 c7             	mov    %rax,%rdi
  802306:	48 b8 f9 18 80 00 00 	movabs $0x8018f9,%rax
  80230d:	00 00 00 
  802310:	ff d0                	callq  *%rax
  802312:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802315:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802319:	79 57                	jns    802372 <serve_open+0x112>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  80231b:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802322:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  802328:	25 00 04 00 00       	and    $0x400,%eax
  80232d:	85 c0                	test   %eax,%eax
  80232f:	75 08                	jne    802339 <serve_open+0xd9>
  802331:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  802335:	75 02                	jne    802339 <serve_open+0xd9>
				goto try_open;
  802337:	eb 08                	jmp    802341 <serve_open+0xe1>
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  802339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233c:	e9 11 01 00 00       	jmpq   802452 <serve_open+0x1f2>
		}
	} else {
	try_open:
		if ((r = file_open(path, &f)) < 0) {
  802341:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  802348:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  80234f:	48 89 d6             	mov    %rdx,%rsi
  802352:	48 89 c7             	mov    %rax,%rdi
  802355:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  80235c:	00 00 00 
  80235f:	ff d0                	callq  *%rax
  802361:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802364:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802368:	79 08                	jns    802372 <serve_open+0x112>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  80236a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236d:	e9 e0 00 00 00       	jmpq   802452 <serve_open+0x1f2>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  802372:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802379:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  80237f:	25 00 02 00 00       	and    $0x200,%eax
  802384:	85 c0                	test   %eax,%eax
  802386:	74 2c                	je     8023b4 <serve_open+0x154>
		if ((r = file_set_size(f, 0)) < 0) {
  802388:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  80238f:	be 00 00 00 00       	mov    $0x0,%esi
  802394:	48 89 c7             	mov    %rax,%rdi
  802397:	48 b8 12 1e 80 00 00 	movabs $0x801e12,%rax
  80239e:	00 00 00 
  8023a1:	ff d0                	callq  *%rax
  8023a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023aa:	79 08                	jns    8023b4 <serve_open+0x154>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  8023ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023af:	e9 9e 00 00 00       	jmpq   802452 <serve_open+0x1f2>
		}
	}

	// Save the file pointer
	o->o_file = f;
  8023b4:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023bb:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  8023c2:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  8023c6:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023cd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023d1:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  8023d8:	8b 12                	mov    (%rdx),%edx
  8023da:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  8023dd:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023e4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023e8:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8023ef:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8023f5:	83 e2 03             	and    $0x3,%edx
  8023f8:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  8023fb:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802402:	48 8b 40 18          	mov    0x18(%rax),%rax
  802406:	48 ba e0 10 81 00 00 	movabs $0x8110e0,%rdx
  80240d:	00 00 00 
  802410:	8b 12                	mov    (%rdx),%edx
  802412:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  802414:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80241b:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  802422:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  802428:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  80242b:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802432:	48 8b 50 18          	mov    0x18(%rax),%rdx
  802436:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  80243d:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  802440:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  802447:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802452:	c9                   	leaveq 
  802453:	c3                   	retq   

0000000000802454 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  802454:	55                   	push   %rbp
  802455:	48 89 e5             	mov    %rsp,%rbp
  802458:	48 83 ec 20          	sub    $0x20,%rsp
  80245c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80245f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802463:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802467:	8b 00                	mov    (%rax),%eax
  802469:	89 c1                	mov    %eax,%ecx
  80246b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80246f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802472:	89 ce                	mov    %ecx,%esi
  802474:	89 c7                	mov    %eax,%edi
  802476:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  80247d:	00 00 00 
  802480:	ff d0                	callq  *%rax
  802482:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802485:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802489:	79 05                	jns    802490 <serve_set_size+0x3c>
		return r;
  80248b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248e:	eb 20                	jmp    8024b0 <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  802490:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802494:	8b 50 04             	mov    0x4(%rax),%edx
  802497:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80249b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80249f:	89 d6                	mov    %edx,%esi
  8024a1:	48 89 c7             	mov    %rax,%rdi
  8024a4:	48 b8 12 1e 80 00 00 	movabs $0x801e12,%rax
  8024ab:	00 00 00 
  8024ae:	ff d0                	callq  *%rax
}
  8024b0:	c9                   	leaveq 
  8024b1:	c3                   	retq   

00000000008024b2 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  8024b2:	55                   	push   %rbp
  8024b3:	48 89 e5             	mov    %rsp,%rbp
  8024b6:	48 83 ec 30          	sub    $0x30,%rsp
  8024ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r = -1;
  8024c1:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!ipc)
  8024c8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8024cd:	75 08                	jne    8024d7 <serve_read+0x25>
		return r; 
  8024cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d2:	e9 e0 00 00 00       	jmpq   8025b7 <serve_read+0x105>
	struct Fsreq_read *req = &ipc->read;
  8024d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  8024df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// (remember that read is always allowed to return fewer bytes
	// than requested).  Also, be careful because ipc is a union,
	// so filling in ret will overwrite req.
	//
	// LAB 5: Your code here
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8024e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024eb:	8b 00                	mov    (%rax),%eax
  8024ed:	89 c1                	mov    %eax,%ecx
  8024ef:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8024f3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f6:	89 ce                	mov    %ecx,%esi
  8024f8:	89 c7                	mov    %eax,%edi
  8024fa:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  802501:	00 00 00 
  802504:	ff d0                	callq  *%rax
  802506:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802509:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250d:	79 08                	jns    802517 <serve_read+0x65>
		return r;
  80250f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802512:	e9 a0 00 00 00       	jmpq   8025b7 <serve_read+0x105>

	if(!o || !o->o_file || !o->o_fd)
  802517:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80251b:	48 85 c0             	test   %rax,%rax
  80251e:	74 1a                	je     80253a <serve_read+0x88>
  802520:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802524:	48 8b 40 08          	mov    0x8(%rax),%rax
  802528:	48 85 c0             	test   %rax,%rax
  80252b:	74 0d                	je     80253a <serve_read+0x88>
  80252d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802531:	48 8b 40 18          	mov    0x18(%rax),%rax
  802535:	48 85 c0             	test   %rax,%rax
  802538:	75 07                	jne    802541 <serve_read+0x8f>
	{
		return -1;
  80253a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80253f:	eb 76                	jmp    8025b7 <serve_read+0x105>
	}
	if(req->req_n > PGSIZE)
  802541:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802545:	48 8b 40 08          	mov    0x8(%rax),%rax
  802549:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
  80254f:	76 0c                	jbe    80255d <serve_read+0xab>
	{
		req->req_n = PGSIZE;
  802551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802555:	48 c7 40 08 00 10 00 	movq   $0x1000,0x8(%rax)
  80255c:	00 
	}
	
	if ((r = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset)) <= 0) {
  80255d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802561:	48 8b 40 18          	mov    0x18(%rax),%rax
  802565:	8b 48 04             	mov    0x4(%rax),%ecx
  802568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802570:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  802574:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802578:	48 8b 40 08          	mov    0x8(%rax),%rax
  80257c:	48 89 c7             	mov    %rax,%rdi
  80257f:	48 b8 16 1a 80 00 00 	movabs $0x801a16,%rax
  802586:	00 00 00 
  802589:	ff d0                	callq  *%rax
  80258b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802592:	7f 05                	jg     802599 <serve_read+0xe7>
		if (debug)
		cprintf("file_read failed: %e", r);
		return r;
  802594:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802597:	eb 1e                	jmp    8025b7 <serve_read+0x105>
	}
	//cprintf("server in serve_read()  is [%d]  %x %x %x %x\n",r,ret->ret_buf[0], ret->ret_buf[1], ret->ret_buf[2], ret->ret_buf[3]);
	o->o_fd->fd_offset += r;
  802599:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80259d:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025a1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025a5:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8025a9:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8025ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025af:	01 ca                	add    %ecx,%edx
  8025b1:	89 50 04             	mov    %edx,0x4(%rax)
	
	return r;
  8025b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("serve_read not implemented");
}
  8025b7:	c9                   	leaveq 
  8025b8:	c3                   	retq   

00000000008025b9 <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  8025b9:	55                   	push   %rbp
  8025ba:	48 89 e5             	mov    %rsp,%rbp
  8025bd:	48 83 ec 20          	sub    $0x20,%rsp
  8025c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r = -1;
  8025c8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!req)
  8025cf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8025d4:	75 08                	jne    8025de <serve_write+0x25>
		return r;
  8025d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d9:	e9 d8 00 00 00       	jmpq   8026b6 <serve_write+0xfd>

	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8025de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025e2:	8b 00                	mov    (%rax),%eax
  8025e4:	89 c1                	mov    %eax,%ecx
  8025e6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025ed:	89 ce                	mov    %ecx,%esi
  8025ef:	89 c7                	mov    %eax,%edi
  8025f1:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  8025f8:	00 00 00 
  8025fb:	ff d0                	callq  *%rax
  8025fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802600:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802604:	79 08                	jns    80260e <serve_write+0x55>
		return r;
  802606:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802609:	e9 a8 00 00 00       	jmpq   8026b6 <serve_write+0xfd>

	if(!o || !o->o_file || !o->o_fd)
  80260e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802612:	48 85 c0             	test   %rax,%rax
  802615:	74 1a                	je     802631 <serve_write+0x78>
  802617:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80261f:	48 85 c0             	test   %rax,%rax
  802622:	74 0d                	je     802631 <serve_write+0x78>
  802624:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802628:	48 8b 40 18          	mov    0x18(%rax),%rax
  80262c:	48 85 c0             	test   %rax,%rax
  80262f:	75 07                	jne    802638 <serve_write+0x7f>
		return -1;
  802631:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802636:	eb 7e                	jmp    8026b6 <serve_write+0xfd>
	
	if ((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0) {
  802638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802640:	8b 48 04             	mov    0x4(%rax),%ecx
  802643:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802647:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80264b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80264f:	48 8d 70 10          	lea    0x10(%rax),%rsi
  802653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802657:	48 8b 40 08          	mov    0x8(%rax),%rax
  80265b:	48 89 c7             	mov    %rax,%rdi
  80265e:	48 b8 6c 1b 80 00 00 	movabs $0x801b6c,%rax
  802665:	00 00 00 
  802668:	ff d0                	callq  *%rax
  80266a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80266d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802671:	79 25                	jns    802698 <serve_write+0xdf>
		cprintf("file_write failed: %e", r);
  802673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802676:	89 c6                	mov    %eax,%esi
  802678:	48 bf b0 71 80 00 00 	movabs $0x8071b0,%rdi
  80267f:	00 00 00 
  802682:	b8 00 00 00 00       	mov    $0x0,%eax
  802687:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  80268e:	00 00 00 
  802691:	ff d2                	callq  *%rdx
		return r;
  802693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802696:	eb 1e                	jmp    8026b6 <serve_write+0xfd>
	}
	o->o_fd->fd_offset += r;
  802698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269c:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026a4:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8026a8:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8026ab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026ae:	01 ca                	add    %ecx,%edx
  8026b0:	89 50 04             	mov    %edx,0x4(%rax)
	
	return r;
  8026b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("serve_write not implemented");
}
  8026b6:	c9                   	leaveq 
  8026b7:	c3                   	retq   

00000000008026b8 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  8026b8:	55                   	push   %rbp
  8026b9:	48 89 e5             	mov    %rsp,%rbp
  8026bc:	48 83 ec 30          	sub    $0x30,%rsp
  8026c0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  8026c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  8026cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8026d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026db:	8b 00                	mov    (%rax),%eax
  8026dd:	89 c1                	mov    %eax,%ecx
  8026df:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8026e3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026e6:	89 ce                	mov    %ecx,%esi
  8026e8:	89 c7                	mov    %eax,%edi
  8026ea:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  8026f1:	00 00 00 
  8026f4:	ff d0                	callq  *%rax
  8026f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8026f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026fd:	79 05                	jns    802704 <serve_stat+0x4c>
		return r;
  8026ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802702:	eb 5f                	jmp    802763 <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  802704:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802708:	48 8b 40 08          	mov    0x8(%rax),%rax
  80270c:	48 89 c2             	mov    %rax,%rdx
  80270f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802713:	48 89 d6             	mov    %rdx,%rsi
  802716:	48 89 c7             	mov    %rax,%rdi
  802719:	48 b8 aa 40 80 00 00 	movabs $0x8040aa,%rax
  802720:	00 00 00 
  802723:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  802725:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802729:	48 8b 40 08          	mov    0x8(%rax),%rax
  80272d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802737:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  80273d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802741:	48 8b 40 08          	mov    0x8(%rax),%rax
  802745:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80274b:	83 f8 01             	cmp    $0x1,%eax
  80274e:	0f 94 c0             	sete   %al
  802751:	0f b6 d0             	movzbl %al,%edx
  802754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802758:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80275e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802763:	c9                   	leaveq 
  802764:	c3                   	retq   

0000000000802765 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  802765:	55                   	push   %rbp
  802766:	48 89 e5             	mov    %rsp,%rbp
  802769:	48 83 ec 20          	sub    $0x20,%rsp
  80276d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802770:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802774:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802778:	8b 00                	mov    (%rax),%eax
  80277a:	89 c1                	mov    %eax,%ecx
  80277c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802780:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802783:	89 ce                	mov    %ecx,%esi
  802785:	89 c7                	mov    %eax,%edi
  802787:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  80278e:	00 00 00 
  802791:	ff d0                	callq  *%rax
  802793:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802796:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279a:	79 05                	jns    8027a1 <serve_flush+0x3c>
		return r;
  80279c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279f:	eb 1c                	jmp    8027bd <serve_flush+0x58>
	file_flush(o->o_file);
  8027a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8027a9:	48 89 c7             	mov    %rax,%rdi
  8027ac:	48 b8 6f 1e 80 00 00 	movabs $0x801e6f,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	callq  *%rax
	return 0;
  8027b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bd:	c9                   	leaveq 
  8027be:	c3                   	retq   

00000000008027bf <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  8027bf:	55                   	push   %rbp
  8027c0:	48 89 e5             	mov    %rsp,%rbp
  8027c3:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  8027ca:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  8027d0:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  8027d7:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  8027de:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  8027e5:	ba 00 04 00 00       	mov    $0x400,%edx
  8027ea:	48 89 ce             	mov    %rcx,%rsi
  8027ed:	48 89 c7             	mov    %rax,%rdi
  8027f0:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  8027f7:	00 00 00 
  8027fa:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8027fc:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  802800:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802807:	48 89 c7             	mov    %rax,%rdi
  80280a:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  802811:	00 00 00 
  802814:	ff d0                	callq  *%rax
}
  802816:	c9                   	leaveq 
  802817:	c3                   	retq   

0000000000802818 <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  802818:	55                   	push   %rbp
  802819:	48 89 e5             	mov    %rsp,%rbp
  80281c:	48 83 ec 10          	sub    $0x10,%rsp
  802820:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802823:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  802827:	48 b8 db 1f 80 00 00 	movabs $0x801fdb,%rax
  80282e:	00 00 00 
  802831:	ff d0                	callq  *%rax
	return 0;
  802833:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802838:	c9                   	leaveq 
  802839:	c3                   	retq   

000000000080283a <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  80283a:	55                   	push   %rbp
  80283b:	48 89 e5             	mov    %rsp,%rbp
  80283e:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  802842:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  802849:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  802850:	00 00 00 
  802853:	48 8b 08             	mov    (%rax),%rcx
  802856:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80285a:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  80285e:	48 89 ce             	mov    %rcx,%rsi
  802861:	48 89 c7             	mov    %rax,%rdi
  802864:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  80286b:	00 00 00 
  80286e:	ff d0                	callq  *%rax
  802870:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  802873:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802876:	83 e0 01             	and    $0x1,%eax
  802879:	85 c0                	test   %eax,%eax
  80287b:	75 23                	jne    8028a0 <serve+0x66>
			cprintf("Invalid request from %08x: no argument page\n",
  80287d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802880:	89 c6                	mov    %eax,%esi
  802882:	48 bf c8 71 80 00 00 	movabs $0x8071c8,%rdi
  802889:	00 00 00 
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax
  802891:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  802898:	00 00 00 
  80289b:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  80289d:	90                   	nop
		}
		ipc_send(whom, r, pg, perm);
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
	}
  80289e:	eb a2                	jmp    802842 <serve+0x8>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  8028a0:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8028a7:	00 
		if (req == FSREQ_OPEN) {
  8028a8:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  8028ac:	75 2b                	jne    8028d9 <serve+0x9f>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8028ae:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  8028b5:	00 00 00 
  8028b8:	48 8b 30             	mov    (%rax),%rsi
  8028bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028be:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8028c2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028c6:	89 c7                	mov    %eax,%edi
  8028c8:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  8028cf:	00 00 00 
  8028d2:	ff d0                	callq  *%rax
  8028d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d7:	eb 73                	jmp    80294c <serve+0x112>
		} else if (req < NHANDLERS && handlers[req]) {
  8028d9:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  8028dd:	77 43                	ja     802922 <serve+0xe8>
  8028df:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  8028e6:	00 00 00 
  8028e9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8028ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f0:	48 85 c0             	test   %rax,%rax
  8028f3:	74 2d                	je     802922 <serve+0xe8>
			r = handlers[req](whom, fsreq);
  8028f5:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  8028fc:	00 00 00 
  8028ff:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802902:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802906:	48 ba 20 10 81 00 00 	movabs $0x811020,%rdx
  80290d:	00 00 00 
  802910:	48 8b 0a             	mov    (%rdx),%rcx
  802913:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802916:	48 89 ce             	mov    %rcx,%rsi
  802919:	89 d7                	mov    %edx,%edi
  80291b:	ff d0                	callq  *%rax
  80291d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802920:	eb 2a                	jmp    80294c <serve+0x112>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  802922:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802925:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802928:	89 c6                	mov    %eax,%esi
  80292a:	48 bf f8 71 80 00 00 	movabs $0x8071f8,%rdi
  802931:	00 00 00 
  802934:	b8 00 00 00 00       	mov    $0x0,%eax
  802939:	48 b9 f5 34 80 00 00 	movabs $0x8034f5,%rcx
  802940:	00 00 00 
  802943:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  802945:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  80294c:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  80294f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802953:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802956:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802959:	89 c7                	mov    %eax,%edi
  80295b:	48 b8 65 50 80 00 00 	movabs $0x805065,%rax
  802962:	00 00 00 
  802965:	ff d0                	callq  *%rax
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
  802967:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  80296e:	00 00 00 
  802971:	48 8b 00             	mov    (%rax),%rax
  802974:	48 89 c6             	mov    %rax,%rsi
  802977:	bf 00 00 00 00       	mov    $0x0,%edi
  80297c:	48 b8 84 4a 80 00 00 	movabs $0x804a84,%rax
  802983:	00 00 00 
  802986:	ff d0                	callq  *%rax
	}
  802988:	e9 b5 fe ff ff       	jmpq   802842 <serve+0x8>

000000000080298d <umain>:
}

void
umain(int argc, char **argv)
{
  80298d:	55                   	push   %rbp
  80298e:	48 89 e5             	mov    %rsp,%rbp
  802991:	48 83 ec 20          	sub    $0x20,%rsp
  802995:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802998:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  80299c:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  8029a3:	00 00 00 
  8029a6:	48 b9 1b 72 80 00 00 	movabs $0x80721b,%rcx
  8029ad:	00 00 00 
  8029b0:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  8029b3:	48 bf 1e 72 80 00 00 	movabs $0x80721e,%rdi
  8029ba:	00 00 00 
  8029bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c2:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  8029c9:	00 00 00 
  8029cc:	ff d2                	callq  *%rdx
  8029ce:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  8029d5:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

    static __inline void
outw(int port, uint16_t data)
{
    __asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8029db:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  8029df:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029e2:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8029e4:	48 bf 2d 72 80 00 00 	movabs $0x80722d,%rdi
  8029eb:	00 00 00 
  8029ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f3:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  8029fa:	00 00 00 
  8029fd:	ff d2                	callq  *%rdx

	serve_init();
  8029ff:	48 b8 2c 20 80 00 00 	movabs $0x80202c,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
	fs_init();
  802a0b:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  802a12:	00 00 00 
  802a15:	ff d0                	callq  *%rax
	serve();
  802a17:	48 b8 3a 28 80 00 00 	movabs $0x80283a,%rax
  802a1e:	00 00 00 
  802a21:	ff d0                	callq  *%rax
}
  802a23:	c9                   	leaveq 
  802a24:	c3                   	retq   

0000000000802a25 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  802a25:	55                   	push   %rbp
  802a26:	48 89 e5             	mov    %rsp,%rbp
  802a29:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802a2d:	ba 07 00 00 00       	mov    $0x7,%edx
  802a32:	be 00 10 00 00       	mov    $0x1000,%esi
  802a37:	bf 00 00 00 00       	mov    $0x0,%edi
  802a3c:	48 b8 d9 49 80 00 00 	movabs $0x8049d9,%rax
  802a43:	00 00 00 
  802a46:	ff d0                	callq  *%rax
  802a48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4f:	79 30                	jns    802a81 <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  802a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a54:	89 c1                	mov    %eax,%ecx
  802a56:	48 ba 66 72 80 00 00 	movabs $0x807266,%rdx
  802a5d:	00 00 00 
  802a60:	be 13 00 00 00       	mov    $0x13,%esi
  802a65:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802a6c:	00 00 00 
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a74:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802a7b:	00 00 00 
  802a7e:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  802a81:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  802a88:	00 
	memmove(bits, bitmap, PGSIZE);
  802a89:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  802a90:	00 00 00 
  802a93:	48 8b 08             	mov    (%rax),%rcx
  802a96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a9f:	48 89 ce             	mov    %rcx,%rsi
  802aa2:	48 89 c7             	mov    %rax,%rdi
  802aa5:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  802aac:	00 00 00 
  802aaf:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  802ab1:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  802ab8:	00 00 00 
  802abb:	ff d0                	callq  *%rax
  802abd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac4:	79 30                	jns    802af6 <fs_test+0xd1>
		panic("alloc_block: %e", r);
  802ac6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac9:	89 c1                	mov    %eax,%ecx
  802acb:	48 ba 83 72 80 00 00 	movabs $0x807283,%rdx
  802ad2:	00 00 00 
  802ad5:	be 18 00 00 00       	mov    $0x18,%esi
  802ada:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802ae1:	00 00 00 
  802ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae9:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802af0:	00 00 00 
  802af3:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  802af6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af9:	8d 50 1f             	lea    0x1f(%rax),%edx
  802afc:	85 c0                	test   %eax,%eax
  802afe:	0f 48 c2             	cmovs  %edx,%eax
  802b01:	c1 f8 05             	sar    $0x5,%eax
  802b04:	48 98                	cltq   
  802b06:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  802b0d:	00 
  802b0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b12:	48 01 d0             	add    %rdx,%rax
  802b15:	8b 30                	mov    (%rax),%esi
  802b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1a:	99                   	cltd   
  802b1b:	c1 ea 1b             	shr    $0x1b,%edx
  802b1e:	01 d0                	add    %edx,%eax
  802b20:	83 e0 1f             	and    $0x1f,%eax
  802b23:	29 d0                	sub    %edx,%eax
  802b25:	ba 01 00 00 00       	mov    $0x1,%edx
  802b2a:	89 c1                	mov    %eax,%ecx
  802b2c:	d3 e2                	shl    %cl,%edx
  802b2e:	89 d0                	mov    %edx,%eax
  802b30:	21 f0                	and    %esi,%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	75 35                	jne    802b6b <fs_test+0x146>
  802b36:	48 b9 93 72 80 00 00 	movabs $0x807293,%rcx
  802b3d:	00 00 00 
  802b40:	48 ba ae 72 80 00 00 	movabs $0x8072ae,%rdx
  802b47:	00 00 00 
  802b4a:	be 1a 00 00 00       	mov    $0x1a,%esi
  802b4f:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802b56:	00 00 00 
  802b59:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5e:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802b65:	00 00 00 
  802b68:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  802b6b:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  802b72:	00 00 00 
  802b75:	48 8b 10             	mov    (%rax),%rdx
  802b78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7b:	8d 48 1f             	lea    0x1f(%rax),%ecx
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	0f 48 c1             	cmovs  %ecx,%eax
  802b83:	c1 f8 05             	sar    $0x5,%eax
  802b86:	48 98                	cltq   
  802b88:	48 c1 e0 02          	shl    $0x2,%rax
  802b8c:	48 01 d0             	add    %rdx,%rax
  802b8f:	8b 30                	mov    (%rax),%esi
  802b91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b94:	99                   	cltd   
  802b95:	c1 ea 1b             	shr    $0x1b,%edx
  802b98:	01 d0                	add    %edx,%eax
  802b9a:	83 e0 1f             	and    $0x1f,%eax
  802b9d:	29 d0                	sub    %edx,%eax
  802b9f:	ba 01 00 00 00       	mov    $0x1,%edx
  802ba4:	89 c1                	mov    %eax,%ecx
  802ba6:	d3 e2                	shl    %cl,%edx
  802ba8:	89 d0                	mov    %edx,%eax
  802baa:	21 f0                	and    %esi,%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 35                	je     802be5 <fs_test+0x1c0>
  802bb0:	48 b9 c8 72 80 00 00 	movabs $0x8072c8,%rcx
  802bb7:	00 00 00 
  802bba:	48 ba ae 72 80 00 00 	movabs $0x8072ae,%rdx
  802bc1:	00 00 00 
  802bc4:	be 1c 00 00 00       	mov    $0x1c,%esi
  802bc9:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802bd0:	00 00 00 
  802bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd8:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802bdf:	00 00 00 
  802be2:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  802be5:	48 bf e8 72 80 00 00 	movabs $0x8072e8,%rdi
  802bec:	00 00 00 
  802bef:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf4:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  802bfb:	00 00 00 
  802bfe:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802c00:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802c04:	48 89 c6             	mov    %rax,%rsi
  802c07:	48 bf fd 72 80 00 00 	movabs $0x8072fd,%rdi
  802c0e:	00 00 00 
  802c11:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  802c18:	00 00 00 
  802c1b:	ff d0                	callq  *%rax
  802c1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c24:	79 36                	jns    802c5c <fs_test+0x237>
  802c26:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  802c2a:	74 30                	je     802c5c <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  802c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2f:	89 c1                	mov    %eax,%ecx
  802c31:	48 ba 08 73 80 00 00 	movabs $0x807308,%rdx
  802c38:	00 00 00 
  802c3b:	be 20 00 00 00       	mov    $0x20,%esi
  802c40:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802c47:	00 00 00 
  802c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4f:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802c56:	00 00 00 
  802c59:	41 ff d0             	callq  *%r8
	else if (r == 0)
  802c5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c60:	75 2a                	jne    802c8c <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802c62:	48 ba 28 73 80 00 00 	movabs $0x807328,%rdx
  802c69:	00 00 00 
  802c6c:	be 22 00 00 00       	mov    $0x22,%esi
  802c71:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802c78:	00 00 00 
  802c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c80:	48 b9 bc 32 80 00 00 	movabs $0x8032bc,%rcx
  802c87:	00 00 00 
  802c8a:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  802c8c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802c90:	48 89 c6             	mov    %rax,%rsi
  802c93:	48 bf 48 73 80 00 00 	movabs $0x807348,%rdi
  802c9a:	00 00 00 
  802c9d:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  802ca4:	00 00 00 
  802ca7:	ff d0                	callq  *%rax
  802ca9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb0:	79 30                	jns    802ce2 <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  802cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb5:	89 c1                	mov    %eax,%ecx
  802cb7:	48 ba 51 73 80 00 00 	movabs $0x807351,%rdx
  802cbe:	00 00 00 
  802cc1:	be 24 00 00 00       	mov    $0x24,%esi
  802cc6:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802ccd:	00 00 00 
  802cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd5:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802cdc:	00 00 00 
  802cdf:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  802ce2:	48 bf 68 73 80 00 00 	movabs $0x807368,%rdi
  802ce9:	00 00 00 
  802cec:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf1:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  802cf8:	00 00 00 
  802cfb:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802cfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d01:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802d05:	be 00 00 00 00       	mov    $0x0,%esi
  802d0a:	48 89 c7             	mov    %rax,%rdi
  802d0d:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  802d14:	00 00 00 
  802d17:	ff d0                	callq  *%rax
  802d19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d20:	79 30                	jns    802d52 <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802d22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d25:	89 c1                	mov    %eax,%ecx
  802d27:	48 ba 7b 73 80 00 00 	movabs $0x80737b,%rdx
  802d2e:	00 00 00 
  802d31:	be 28 00 00 00       	mov    $0x28,%esi
  802d36:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802d3d:	00 00 00 
  802d40:	b8 00 00 00 00       	mov    $0x0,%eax
  802d45:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802d4c:	00 00 00 
  802d4f:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802d52:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802d59:	00 00 00 
  802d5c:	48 8b 10             	mov    (%rax),%rdx
  802d5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d63:	48 89 d6             	mov    %rdx,%rsi
  802d66:	48 89 c7             	mov    %rax,%rdi
  802d69:	48 b8 0c 42 80 00 00 	movabs $0x80420c,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
  802d75:	85 c0                	test   %eax,%eax
  802d77:	74 2a                	je     802da3 <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  802d79:	48 ba 90 73 80 00 00 	movabs $0x807390,%rdx
  802d80:	00 00 00 
  802d83:	be 2a 00 00 00       	mov    $0x2a,%esi
  802d88:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802d8f:	00 00 00 
  802d92:	b8 00 00 00 00       	mov    $0x0,%eax
  802d97:	48 b9 bc 32 80 00 00 	movabs $0x8032bc,%rcx
  802d9e:	00 00 00 
  802da1:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  802da3:	48 bf b3 73 80 00 00 	movabs $0x8073b3,%rdi
  802daa:	00 00 00 
  802dad:	b8 00 00 00 00       	mov    $0x0,%eax
  802db2:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  802db9:	00 00 00 
  802dbc:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802dbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dc2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802dc6:	0f b6 12             	movzbl (%rdx),%edx
  802dc9:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802dcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dcf:	48 c1 e8 0c          	shr    $0xc,%rax
  802dd3:	48 89 c2             	mov    %rax,%rdx
  802dd6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ddd:	01 00 00 
  802de0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802de4:	83 e0 40             	and    $0x40,%eax
  802de7:	48 85 c0             	test   %rax,%rax
  802dea:	75 35                	jne    802e21 <fs_test+0x3fc>
  802dec:	48 b9 cb 73 80 00 00 	movabs $0x8073cb,%rcx
  802df3:	00 00 00 
  802df6:	48 ba ae 72 80 00 00 	movabs $0x8072ae,%rdx
  802dfd:	00 00 00 
  802e00:	be 2e 00 00 00       	mov    $0x2e,%esi
  802e05:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802e0c:	00 00 00 
  802e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e14:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802e1b:	00 00 00 
  802e1e:	41 ff d0             	callq  *%r8
	file_flush(f);
  802e21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e25:	48 89 c7             	mov    %rax,%rdi
  802e28:	48 b8 6f 1e 80 00 00 	movabs $0x801e6f,%rax
  802e2f:	00 00 00 
  802e32:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802e34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e38:	48 c1 e8 0c          	shr    $0xc,%rax
  802e3c:	48 89 c2             	mov    %rax,%rdx
  802e3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e46:	01 00 00 
  802e49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e4d:	83 e0 40             	and    $0x40,%eax
  802e50:	48 85 c0             	test   %rax,%rax
  802e53:	74 35                	je     802e8a <fs_test+0x465>
  802e55:	48 b9 e6 73 80 00 00 	movabs $0x8073e6,%rcx
  802e5c:	00 00 00 
  802e5f:	48 ba ae 72 80 00 00 	movabs $0x8072ae,%rdx
  802e66:	00 00 00 
  802e69:	be 30 00 00 00       	mov    $0x30,%esi
  802e6e:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802e75:	00 00 00 
  802e78:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7d:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802e84:	00 00 00 
  802e87:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802e8a:	48 bf 02 74 80 00 00 	movabs $0x807402,%rdi
  802e91:	00 00 00 
  802e94:	b8 00 00 00 00       	mov    $0x0,%eax
  802e99:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  802ea0:	00 00 00 
  802ea3:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802ea5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea9:	be 00 00 00 00       	mov    $0x0,%esi
  802eae:	48 89 c7             	mov    %rax,%rdi
  802eb1:	48 b8 12 1e 80 00 00 	movabs $0x801e12,%rax
  802eb8:	00 00 00 
  802ebb:	ff d0                	callq  *%rax
  802ebd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec4:	79 30                	jns    802ef6 <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802ec6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec9:	89 c1                	mov    %eax,%ecx
  802ecb:	48 ba 16 74 80 00 00 	movabs $0x807416,%rdx
  802ed2:	00 00 00 
  802ed5:	be 34 00 00 00       	mov    $0x34,%esi
  802eda:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802ee1:	00 00 00 
  802ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee9:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802ef0:	00 00 00 
  802ef3:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efa:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802f00:	85 c0                	test   %eax,%eax
  802f02:	74 35                	je     802f39 <fs_test+0x514>
  802f04:	48 b9 28 74 80 00 00 	movabs $0x807428,%rcx
  802f0b:	00 00 00 
  802f0e:	48 ba ae 72 80 00 00 	movabs $0x8072ae,%rdx
  802f15:	00 00 00 
  802f18:	be 35 00 00 00       	mov    $0x35,%esi
  802f1d:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802f24:	00 00 00 
  802f27:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2c:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802f33:	00 00 00 
  802f36:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802f39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3d:	48 c1 e8 0c          	shr    $0xc,%rax
  802f41:	48 89 c2             	mov    %rax,%rdx
  802f44:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f4b:	01 00 00 
  802f4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f52:	83 e0 40             	and    $0x40,%eax
  802f55:	48 85 c0             	test   %rax,%rax
  802f58:	74 35                	je     802f8f <fs_test+0x56a>
  802f5a:	48 b9 3c 74 80 00 00 	movabs $0x80743c,%rcx
  802f61:	00 00 00 
  802f64:	48 ba ae 72 80 00 00 	movabs $0x8072ae,%rdx
  802f6b:	00 00 00 
  802f6e:	be 36 00 00 00       	mov    $0x36,%esi
  802f73:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  802f7a:	00 00 00 
  802f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f82:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  802f89:	00 00 00 
  802f8c:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  802f8f:	48 bf 56 74 80 00 00 	movabs $0x807456,%rdi
  802f96:	00 00 00 
  802f99:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9e:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  802fa5:	00 00 00 
  802fa8:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802faa:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802fb1:	00 00 00 
  802fb4:	48 8b 00             	mov    (%rax),%rax
  802fb7:	48 89 c7             	mov    %rax,%rdi
  802fba:	48 b8 3e 40 80 00 00 	movabs $0x80403e,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
  802fc6:	89 c2                	mov    %eax,%edx
  802fc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fcc:	89 d6                	mov    %edx,%esi
  802fce:	48 89 c7             	mov    %rax,%rdi
  802fd1:	48 b8 12 1e 80 00 00 	movabs $0x801e12,%rax
  802fd8:	00 00 00 
  802fdb:	ff d0                	callq  *%rax
  802fdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe4:	79 30                	jns    803016 <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  802fe6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe9:	89 c1                	mov    %eax,%ecx
  802feb:	48 ba 6d 74 80 00 00 	movabs $0x80746d,%rdx
  802ff2:	00 00 00 
  802ff5:	be 3a 00 00 00       	mov    $0x3a,%esi
  802ffa:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  803001:	00 00 00 
  803004:	b8 00 00 00 00       	mov    $0x0,%eax
  803009:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  803010:	00 00 00 
  803013:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  803016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301a:	48 c1 e8 0c          	shr    $0xc,%rax
  80301e:	48 89 c2             	mov    %rax,%rdx
  803021:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803028:	01 00 00 
  80302b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80302f:	83 e0 40             	and    $0x40,%eax
  803032:	48 85 c0             	test   %rax,%rax
  803035:	74 35                	je     80306c <fs_test+0x647>
  803037:	48 b9 3c 74 80 00 00 	movabs $0x80743c,%rcx
  80303e:	00 00 00 
  803041:	48 ba ae 72 80 00 00 	movabs $0x8072ae,%rdx
  803048:	00 00 00 
  80304b:	be 3b 00 00 00       	mov    $0x3b,%esi
  803050:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  803057:	00 00 00 
  80305a:	b8 00 00 00 00       	mov    $0x0,%eax
  80305f:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  803066:	00 00 00 
  803069:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  80306c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803070:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  803074:	be 00 00 00 00       	mov    $0x0,%esi
  803079:	48 89 c7             	mov    %rax,%rdi
  80307c:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  803083:	00 00 00 
  803086:	ff d0                	callq  *%rax
  803088:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80308b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308f:	79 30                	jns    8030c1 <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  803091:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803094:	89 c1                	mov    %eax,%ecx
  803096:	48 ba 81 74 80 00 00 	movabs $0x807481,%rdx
  80309d:	00 00 00 
  8030a0:	be 3d 00 00 00       	mov    $0x3d,%esi
  8030a5:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  8030ac:	00 00 00 
  8030af:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b4:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  8030bb:	00 00 00 
  8030be:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  8030c1:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  8030c8:	00 00 00 
  8030cb:	48 8b 10             	mov    (%rax),%rdx
  8030ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d2:	48 89 d6             	mov    %rdx,%rsi
  8030d5:	48 89 c7             	mov    %rax,%rdi
  8030d8:	48 b8 aa 40 80 00 00 	movabs $0x8040aa,%rax
  8030df:	00 00 00 
  8030e2:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8030e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030e8:	48 c1 e8 0c          	shr    $0xc,%rax
  8030ec:	48 89 c2             	mov    %rax,%rdx
  8030ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030f6:	01 00 00 
  8030f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030fd:	83 e0 40             	and    $0x40,%eax
  803100:	48 85 c0             	test   %rax,%rax
  803103:	75 35                	jne    80313a <fs_test+0x715>
  803105:	48 b9 cb 73 80 00 00 	movabs $0x8073cb,%rcx
  80310c:	00 00 00 
  80310f:	48 ba ae 72 80 00 00 	movabs $0x8072ae,%rdx
  803116:	00 00 00 
  803119:	be 3f 00 00 00       	mov    $0x3f,%esi
  80311e:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  803125:	00 00 00 
  803128:	b8 00 00 00 00       	mov    $0x0,%eax
  80312d:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  803134:	00 00 00 
  803137:	41 ff d0             	callq  *%r8
	file_flush(f);
  80313a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313e:	48 89 c7             	mov    %rax,%rdi
  803141:	48 b8 6f 1e 80 00 00 	movabs $0x801e6f,%rax
  803148:	00 00 00 
  80314b:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80314d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803151:	48 c1 e8 0c          	shr    $0xc,%rax
  803155:	48 89 c2             	mov    %rax,%rdx
  803158:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80315f:	01 00 00 
  803162:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803166:	83 e0 40             	and    $0x40,%eax
  803169:	48 85 c0             	test   %rax,%rax
  80316c:	74 35                	je     8031a3 <fs_test+0x77e>
  80316e:	48 b9 e6 73 80 00 00 	movabs $0x8073e6,%rcx
  803175:	00 00 00 
  803178:	48 ba ae 72 80 00 00 	movabs $0x8072ae,%rdx
  80317f:	00 00 00 
  803182:	be 41 00 00 00       	mov    $0x41,%esi
  803187:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  80318e:	00 00 00 
  803191:	b8 00 00 00 00       	mov    $0x0,%eax
  803196:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  80319d:	00 00 00 
  8031a0:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8031a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a7:	48 c1 e8 0c          	shr    $0xc,%rax
  8031ab:	48 89 c2             	mov    %rax,%rdx
  8031ae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8031b5:	01 00 00 
  8031b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031bc:	83 e0 40             	and    $0x40,%eax
  8031bf:	48 85 c0             	test   %rax,%rax
  8031c2:	74 35                	je     8031f9 <fs_test+0x7d4>
  8031c4:	48 b9 3c 74 80 00 00 	movabs $0x80743c,%rcx
  8031cb:	00 00 00 
  8031ce:	48 ba ae 72 80 00 00 	movabs $0x8072ae,%rdx
  8031d5:	00 00 00 
  8031d8:	be 42 00 00 00       	mov    $0x42,%esi
  8031dd:	48 bf 79 72 80 00 00 	movabs $0x807279,%rdi
  8031e4:	00 00 00 
  8031e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ec:	49 b8 bc 32 80 00 00 	movabs $0x8032bc,%r8
  8031f3:	00 00 00 
  8031f6:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  8031f9:	48 bf 96 74 80 00 00 	movabs $0x807496,%rdi
  803200:	00 00 00 
  803203:	b8 00 00 00 00       	mov    $0x0,%eax
  803208:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  80320f:	00 00 00 
  803212:	ff d2                	callq  *%rdx
}
  803214:	c9                   	leaveq 
  803215:	c3                   	retq   

0000000000803216 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  803216:	55                   	push   %rbp
  803217:	48 89 e5             	mov    %rsp,%rbp
  80321a:	48 83 ec 10          	sub    $0x10,%rsp
  80321e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803221:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  803225:	48 b8 5d 49 80 00 00 	movabs $0x80495d,%rax
  80322c:	00 00 00 
  80322f:	ff d0                	callq  *%rax
  803231:	25 ff 03 00 00       	and    $0x3ff,%eax
  803236:	48 98                	cltq   
  803238:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80323f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803246:	00 00 00 
  803249:	48 01 c2             	add    %rax,%rdx
  80324c:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  803253:	00 00 00 
  803256:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  803259:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80325d:	7e 14                	jle    803273 <libmain+0x5d>
		binaryname = argv[0];
  80325f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803263:	48 8b 10             	mov    (%rax),%rdx
  803266:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  80326d:	00 00 00 
  803270:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  803273:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803277:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80327a:	48 89 d6             	mov    %rdx,%rsi
  80327d:	89 c7                	mov    %eax,%edi
  80327f:	48 b8 8d 29 80 00 00 	movabs $0x80298d,%rax
  803286:	00 00 00 
  803289:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80328b:	48 b8 99 32 80 00 00 	movabs $0x803299,%rax
  803292:	00 00 00 
  803295:	ff d0                	callq  *%rax
}
  803297:	c9                   	leaveq 
  803298:	c3                   	retq   

0000000000803299 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  803299:	55                   	push   %rbp
  80329a:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80329d:	48 b8 a0 54 80 00 00 	movabs $0x8054a0,%rax
  8032a4:	00 00 00 
  8032a7:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8032a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ae:	48 b8 19 49 80 00 00 	movabs $0x804919,%rax
  8032b5:	00 00 00 
  8032b8:	ff d0                	callq  *%rax

}
  8032ba:	5d                   	pop    %rbp
  8032bb:	c3                   	retq   

00000000008032bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8032bc:	55                   	push   %rbp
  8032bd:	48 89 e5             	mov    %rsp,%rbp
  8032c0:	53                   	push   %rbx
  8032c1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8032c8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8032cf:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8032d5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8032dc:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8032e3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8032ea:	84 c0                	test   %al,%al
  8032ec:	74 23                	je     803311 <_panic+0x55>
  8032ee:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8032f5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8032f9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8032fd:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803301:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803305:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803309:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80330d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803311:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803318:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80331f:	00 00 00 
  803322:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803329:	00 00 00 
  80332c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803330:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803337:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80333e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803345:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  80334c:	00 00 00 
  80334f:	48 8b 18             	mov    (%rax),%rbx
  803352:	48 b8 5d 49 80 00 00 	movabs $0x80495d,%rax
  803359:	00 00 00 
  80335c:	ff d0                	callq  *%rax
  80335e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803364:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80336b:	41 89 c8             	mov    %ecx,%r8d
  80336e:	48 89 d1             	mov    %rdx,%rcx
  803371:	48 89 da             	mov    %rbx,%rdx
  803374:	89 c6                	mov    %eax,%esi
  803376:	48 bf b8 74 80 00 00 	movabs $0x8074b8,%rdi
  80337d:	00 00 00 
  803380:	b8 00 00 00 00       	mov    $0x0,%eax
  803385:	49 b9 f5 34 80 00 00 	movabs $0x8034f5,%r9
  80338c:	00 00 00 
  80338f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803392:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803399:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8033a0:	48 89 d6             	mov    %rdx,%rsi
  8033a3:	48 89 c7             	mov    %rax,%rdi
  8033a6:	48 b8 49 34 80 00 00 	movabs $0x803449,%rax
  8033ad:	00 00 00 
  8033b0:	ff d0                	callq  *%rax
	cprintf("\n");
  8033b2:	48 bf db 74 80 00 00 	movabs $0x8074db,%rdi
  8033b9:	00 00 00 
  8033bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c1:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  8033c8:	00 00 00 
  8033cb:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8033cd:	cc                   	int3   
  8033ce:	eb fd                	jmp    8033cd <_panic+0x111>

00000000008033d0 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8033d0:	55                   	push   %rbp
  8033d1:	48 89 e5             	mov    %rsp,%rbp
  8033d4:	48 83 ec 10          	sub    $0x10,%rsp
  8033d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8033df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e3:	8b 00                	mov    (%rax),%eax
  8033e5:	8d 48 01             	lea    0x1(%rax),%ecx
  8033e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033ec:	89 0a                	mov    %ecx,(%rdx)
  8033ee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033f1:	89 d1                	mov    %edx,%ecx
  8033f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033f7:	48 98                	cltq   
  8033f9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8033fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803401:	8b 00                	mov    (%rax),%eax
  803403:	3d ff 00 00 00       	cmp    $0xff,%eax
  803408:	75 2c                	jne    803436 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80340a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80340e:	8b 00                	mov    (%rax),%eax
  803410:	48 98                	cltq   
  803412:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803416:	48 83 c2 08          	add    $0x8,%rdx
  80341a:	48 89 c6             	mov    %rax,%rsi
  80341d:	48 89 d7             	mov    %rdx,%rdi
  803420:	48 b8 91 48 80 00 00 	movabs $0x804891,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
        b->idx = 0;
  80342c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803430:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  803436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80343a:	8b 40 04             	mov    0x4(%rax),%eax
  80343d:	8d 50 01             	lea    0x1(%rax),%edx
  803440:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803444:	89 50 04             	mov    %edx,0x4(%rax)
}
  803447:	c9                   	leaveq 
  803448:	c3                   	retq   

0000000000803449 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  803449:	55                   	push   %rbp
  80344a:	48 89 e5             	mov    %rsp,%rbp
  80344d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  803454:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80345b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  803462:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  803469:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  803470:	48 8b 0a             	mov    (%rdx),%rcx
  803473:	48 89 08             	mov    %rcx,(%rax)
  803476:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80347a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80347e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803482:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  803486:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80348d:	00 00 00 
    b.cnt = 0;
  803490:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  803497:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80349a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8034a1:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8034a8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8034af:	48 89 c6             	mov    %rax,%rsi
  8034b2:	48 bf d0 33 80 00 00 	movabs $0x8033d0,%rdi
  8034b9:	00 00 00 
  8034bc:	48 b8 a8 38 80 00 00 	movabs $0x8038a8,%rax
  8034c3:	00 00 00 
  8034c6:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8034c8:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8034ce:	48 98                	cltq   
  8034d0:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8034d7:	48 83 c2 08          	add    $0x8,%rdx
  8034db:	48 89 c6             	mov    %rax,%rsi
  8034de:	48 89 d7             	mov    %rdx,%rdi
  8034e1:	48 b8 91 48 80 00 00 	movabs $0x804891,%rax
  8034e8:	00 00 00 
  8034eb:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8034ed:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8034f3:	c9                   	leaveq 
  8034f4:	c3                   	retq   

00000000008034f5 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8034f5:	55                   	push   %rbp
  8034f6:	48 89 e5             	mov    %rsp,%rbp
  8034f9:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  803500:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803507:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80350e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803515:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80351c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803523:	84 c0                	test   %al,%al
  803525:	74 20                	je     803547 <cprintf+0x52>
  803527:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80352b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80352f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803533:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803537:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80353b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80353f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803543:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803547:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80354e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803555:	00 00 00 
  803558:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80355f:	00 00 00 
  803562:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803566:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80356d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803574:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80357b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803582:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803589:	48 8b 0a             	mov    (%rdx),%rcx
  80358c:	48 89 08             	mov    %rcx,(%rax)
  80358f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803593:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803597:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80359b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80359f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8035a6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8035ad:	48 89 d6             	mov    %rdx,%rsi
  8035b0:	48 89 c7             	mov    %rax,%rdi
  8035b3:	48 b8 49 34 80 00 00 	movabs $0x803449,%rax
  8035ba:	00 00 00 
  8035bd:	ff d0                	callq  *%rax
  8035bf:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8035c5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8035cb:	c9                   	leaveq 
  8035cc:	c3                   	retq   

00000000008035cd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8035cd:	55                   	push   %rbp
  8035ce:	48 89 e5             	mov    %rsp,%rbp
  8035d1:	53                   	push   %rbx
  8035d2:	48 83 ec 38          	sub    $0x38,%rsp
  8035d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8035e2:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8035e5:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8035e9:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8035ed:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8035f0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8035f4:	77 3b                	ja     803631 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8035f6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8035f9:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8035fd:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  803600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803604:	ba 00 00 00 00       	mov    $0x0,%edx
  803609:	48 f7 f3             	div    %rbx
  80360c:	48 89 c2             	mov    %rax,%rdx
  80360f:	8b 7d cc             	mov    -0x34(%rbp),%edi
  803612:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  803615:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  803619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361d:	41 89 f9             	mov    %edi,%r9d
  803620:	48 89 c7             	mov    %rax,%rdi
  803623:	48 b8 cd 35 80 00 00 	movabs $0x8035cd,%rax
  80362a:	00 00 00 
  80362d:	ff d0                	callq  *%rax
  80362f:	eb 1e                	jmp    80364f <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  803631:	eb 12                	jmp    803645 <printnum+0x78>
			putch(padc, putdat);
  803633:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803637:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80363a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80363e:	48 89 ce             	mov    %rcx,%rsi
  803641:	89 d7                	mov    %edx,%edi
  803643:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  803645:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  803649:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80364d:	7f e4                	jg     803633 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80364f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  803652:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803656:	ba 00 00 00 00       	mov    $0x0,%edx
  80365b:	48 f7 f1             	div    %rcx
  80365e:	48 89 d0             	mov    %rdx,%rax
  803661:	48 ba d0 76 80 00 00 	movabs $0x8076d0,%rdx
  803668:	00 00 00 
  80366b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80366f:	0f be d0             	movsbl %al,%edx
  803672:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80367a:	48 89 ce             	mov    %rcx,%rsi
  80367d:	89 d7                	mov    %edx,%edi
  80367f:	ff d0                	callq  *%rax
}
  803681:	48 83 c4 38          	add    $0x38,%rsp
  803685:	5b                   	pop    %rbx
  803686:	5d                   	pop    %rbp
  803687:	c3                   	retq   

0000000000803688 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  803688:	55                   	push   %rbp
  803689:	48 89 e5             	mov    %rsp,%rbp
  80368c:	48 83 ec 1c          	sub    $0x1c,%rsp
  803690:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803694:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  803697:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80369b:	7e 52                	jle    8036ef <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80369d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a1:	8b 00                	mov    (%rax),%eax
  8036a3:	83 f8 30             	cmp    $0x30,%eax
  8036a6:	73 24                	jae    8036cc <getuint+0x44>
  8036a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8036b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b4:	8b 00                	mov    (%rax),%eax
  8036b6:	89 c0                	mov    %eax,%eax
  8036b8:	48 01 d0             	add    %rdx,%rax
  8036bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036bf:	8b 12                	mov    (%rdx),%edx
  8036c1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8036c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036c8:	89 0a                	mov    %ecx,(%rdx)
  8036ca:	eb 17                	jmp    8036e3 <getuint+0x5b>
  8036cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8036d4:	48 89 d0             	mov    %rdx,%rax
  8036d7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8036db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036df:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8036e3:	48 8b 00             	mov    (%rax),%rax
  8036e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8036ea:	e9 a3 00 00 00       	jmpq   803792 <getuint+0x10a>
	else if (lflag)
  8036ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8036f3:	74 4f                	je     803744 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8036f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f9:	8b 00                	mov    (%rax),%eax
  8036fb:	83 f8 30             	cmp    $0x30,%eax
  8036fe:	73 24                	jae    803724 <getuint+0x9c>
  803700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803704:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80370c:	8b 00                	mov    (%rax),%eax
  80370e:	89 c0                	mov    %eax,%eax
  803710:	48 01 d0             	add    %rdx,%rax
  803713:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803717:	8b 12                	mov    (%rdx),%edx
  803719:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80371c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803720:	89 0a                	mov    %ecx,(%rdx)
  803722:	eb 17                	jmp    80373b <getuint+0xb3>
  803724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803728:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80372c:	48 89 d0             	mov    %rdx,%rax
  80372f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803733:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803737:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80373b:	48 8b 00             	mov    (%rax),%rax
  80373e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803742:	eb 4e                	jmp    803792 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  803744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803748:	8b 00                	mov    (%rax),%eax
  80374a:	83 f8 30             	cmp    $0x30,%eax
  80374d:	73 24                	jae    803773 <getuint+0xeb>
  80374f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803753:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80375b:	8b 00                	mov    (%rax),%eax
  80375d:	89 c0                	mov    %eax,%eax
  80375f:	48 01 d0             	add    %rdx,%rax
  803762:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803766:	8b 12                	mov    (%rdx),%edx
  803768:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80376b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80376f:	89 0a                	mov    %ecx,(%rdx)
  803771:	eb 17                	jmp    80378a <getuint+0x102>
  803773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803777:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80377b:	48 89 d0             	mov    %rdx,%rax
  80377e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803782:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803786:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80378a:	8b 00                	mov    (%rax),%eax
  80378c:	89 c0                	mov    %eax,%eax
  80378e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803792:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803796:	c9                   	leaveq 
  803797:	c3                   	retq   

0000000000803798 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  803798:	55                   	push   %rbp
  803799:	48 89 e5             	mov    %rsp,%rbp
  80379c:	48 83 ec 1c          	sub    $0x1c,%rsp
  8037a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037a4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8037a7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8037ab:	7e 52                	jle    8037ff <getint+0x67>
		x=va_arg(*ap, long long);
  8037ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b1:	8b 00                	mov    (%rax),%eax
  8037b3:	83 f8 30             	cmp    $0x30,%eax
  8037b6:	73 24                	jae    8037dc <getint+0x44>
  8037b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8037c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c4:	8b 00                	mov    (%rax),%eax
  8037c6:	89 c0                	mov    %eax,%eax
  8037c8:	48 01 d0             	add    %rdx,%rax
  8037cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037cf:	8b 12                	mov    (%rdx),%edx
  8037d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8037d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037d8:	89 0a                	mov    %ecx,(%rdx)
  8037da:	eb 17                	jmp    8037f3 <getint+0x5b>
  8037dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037e0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8037e4:	48 89 d0             	mov    %rdx,%rax
  8037e7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8037eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8037f3:	48 8b 00             	mov    (%rax),%rax
  8037f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8037fa:	e9 a3 00 00 00       	jmpq   8038a2 <getint+0x10a>
	else if (lflag)
  8037ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803803:	74 4f                	je     803854 <getint+0xbc>
		x=va_arg(*ap, long);
  803805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803809:	8b 00                	mov    (%rax),%eax
  80380b:	83 f8 30             	cmp    $0x30,%eax
  80380e:	73 24                	jae    803834 <getint+0x9c>
  803810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803814:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80381c:	8b 00                	mov    (%rax),%eax
  80381e:	89 c0                	mov    %eax,%eax
  803820:	48 01 d0             	add    %rdx,%rax
  803823:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803827:	8b 12                	mov    (%rdx),%edx
  803829:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80382c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803830:	89 0a                	mov    %ecx,(%rdx)
  803832:	eb 17                	jmp    80384b <getint+0xb3>
  803834:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803838:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80383c:	48 89 d0             	mov    %rdx,%rax
  80383f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803843:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803847:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80384b:	48 8b 00             	mov    (%rax),%rax
  80384e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803852:	eb 4e                	jmp    8038a2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  803854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803858:	8b 00                	mov    (%rax),%eax
  80385a:	83 f8 30             	cmp    $0x30,%eax
  80385d:	73 24                	jae    803883 <getint+0xeb>
  80385f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803863:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80386b:	8b 00                	mov    (%rax),%eax
  80386d:	89 c0                	mov    %eax,%eax
  80386f:	48 01 d0             	add    %rdx,%rax
  803872:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803876:	8b 12                	mov    (%rdx),%edx
  803878:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80387b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80387f:	89 0a                	mov    %ecx,(%rdx)
  803881:	eb 17                	jmp    80389a <getint+0x102>
  803883:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803887:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80388b:	48 89 d0             	mov    %rdx,%rax
  80388e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803892:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803896:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80389a:	8b 00                	mov    (%rax),%eax
  80389c:	48 98                	cltq   
  80389e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8038a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038a6:	c9                   	leaveq 
  8038a7:	c3                   	retq   

00000000008038a8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8038a8:	55                   	push   %rbp
  8038a9:	48 89 e5             	mov    %rsp,%rbp
  8038ac:	41 54                	push   %r12
  8038ae:	53                   	push   %rbx
  8038af:	48 83 ec 60          	sub    $0x60,%rsp
  8038b3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8038b7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8038bb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8038bf:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8038c3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8038c7:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8038cb:	48 8b 0a             	mov    (%rdx),%rcx
  8038ce:	48 89 08             	mov    %rcx,(%rax)
  8038d1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8038d5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8038d9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8038dd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8038e1:	eb 17                	jmp    8038fa <vprintfmt+0x52>
			if (ch == '\0')
  8038e3:	85 db                	test   %ebx,%ebx
  8038e5:	0f 84 cc 04 00 00    	je     803db7 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8038eb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8038ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8038f3:	48 89 d6             	mov    %rdx,%rsi
  8038f6:	89 df                	mov    %ebx,%edi
  8038f8:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8038fa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8038fe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803902:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803906:	0f b6 00             	movzbl (%rax),%eax
  803909:	0f b6 d8             	movzbl %al,%ebx
  80390c:	83 fb 25             	cmp    $0x25,%ebx
  80390f:	75 d2                	jne    8038e3 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803911:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803915:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80391c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803923:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80392a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803931:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803935:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803939:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80393d:	0f b6 00             	movzbl (%rax),%eax
  803940:	0f b6 d8             	movzbl %al,%ebx
  803943:	8d 43 dd             	lea    -0x23(%rbx),%eax
  803946:	83 f8 55             	cmp    $0x55,%eax
  803949:	0f 87 34 04 00 00    	ja     803d83 <vprintfmt+0x4db>
  80394f:	89 c0                	mov    %eax,%eax
  803951:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803958:	00 
  803959:	48 b8 f8 76 80 00 00 	movabs $0x8076f8,%rax
  803960:	00 00 00 
  803963:	48 01 d0             	add    %rdx,%rax
  803966:	48 8b 00             	mov    (%rax),%rax
  803969:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80396b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80396f:	eb c0                	jmp    803931 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  803971:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803975:	eb ba                	jmp    803931 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803977:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80397e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803981:	89 d0                	mov    %edx,%eax
  803983:	c1 e0 02             	shl    $0x2,%eax
  803986:	01 d0                	add    %edx,%eax
  803988:	01 c0                	add    %eax,%eax
  80398a:	01 d8                	add    %ebx,%eax
  80398c:	83 e8 30             	sub    $0x30,%eax
  80398f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803992:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803996:	0f b6 00             	movzbl (%rax),%eax
  803999:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80399c:	83 fb 2f             	cmp    $0x2f,%ebx
  80399f:	7e 0c                	jle    8039ad <vprintfmt+0x105>
  8039a1:	83 fb 39             	cmp    $0x39,%ebx
  8039a4:	7f 07                	jg     8039ad <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8039a6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8039ab:	eb d1                	jmp    80397e <vprintfmt+0xd6>
			goto process_precision;
  8039ad:	eb 58                	jmp    803a07 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8039af:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8039b2:	83 f8 30             	cmp    $0x30,%eax
  8039b5:	73 17                	jae    8039ce <vprintfmt+0x126>
  8039b7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8039bb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8039be:	89 c0                	mov    %eax,%eax
  8039c0:	48 01 d0             	add    %rdx,%rax
  8039c3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8039c6:	83 c2 08             	add    $0x8,%edx
  8039c9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8039cc:	eb 0f                	jmp    8039dd <vprintfmt+0x135>
  8039ce:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8039d2:	48 89 d0             	mov    %rdx,%rax
  8039d5:	48 83 c2 08          	add    $0x8,%rdx
  8039d9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8039dd:	8b 00                	mov    (%rax),%eax
  8039df:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8039e2:	eb 23                	jmp    803a07 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8039e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8039e8:	79 0c                	jns    8039f6 <vprintfmt+0x14e>
				width = 0;
  8039ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8039f1:	e9 3b ff ff ff       	jmpq   803931 <vprintfmt+0x89>
  8039f6:	e9 36 ff ff ff       	jmpq   803931 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8039fb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  803a02:	e9 2a ff ff ff       	jmpq   803931 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  803a07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803a0b:	79 12                	jns    803a1f <vprintfmt+0x177>
				width = precision, precision = -1;
  803a0d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803a10:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803a13:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  803a1a:	e9 12 ff ff ff       	jmpq   803931 <vprintfmt+0x89>
  803a1f:	e9 0d ff ff ff       	jmpq   803931 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  803a24:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  803a28:	e9 04 ff ff ff       	jmpq   803931 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  803a2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a30:	83 f8 30             	cmp    $0x30,%eax
  803a33:	73 17                	jae    803a4c <vprintfmt+0x1a4>
  803a35:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803a39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a3c:	89 c0                	mov    %eax,%eax
  803a3e:	48 01 d0             	add    %rdx,%rax
  803a41:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803a44:	83 c2 08             	add    $0x8,%edx
  803a47:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803a4a:	eb 0f                	jmp    803a5b <vprintfmt+0x1b3>
  803a4c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803a50:	48 89 d0             	mov    %rdx,%rax
  803a53:	48 83 c2 08          	add    $0x8,%rdx
  803a57:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803a5b:	8b 10                	mov    (%rax),%edx
  803a5d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803a61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a65:	48 89 ce             	mov    %rcx,%rsi
  803a68:	89 d7                	mov    %edx,%edi
  803a6a:	ff d0                	callq  *%rax
			break;
  803a6c:	e9 40 03 00 00       	jmpq   803db1 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  803a71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a74:	83 f8 30             	cmp    $0x30,%eax
  803a77:	73 17                	jae    803a90 <vprintfmt+0x1e8>
  803a79:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803a7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a80:	89 c0                	mov    %eax,%eax
  803a82:	48 01 d0             	add    %rdx,%rax
  803a85:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803a88:	83 c2 08             	add    $0x8,%edx
  803a8b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803a8e:	eb 0f                	jmp    803a9f <vprintfmt+0x1f7>
  803a90:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803a94:	48 89 d0             	mov    %rdx,%rax
  803a97:	48 83 c2 08          	add    $0x8,%rdx
  803a9b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803a9f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803aa1:	85 db                	test   %ebx,%ebx
  803aa3:	79 02                	jns    803aa7 <vprintfmt+0x1ff>
				err = -err;
  803aa5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803aa7:	83 fb 15             	cmp    $0x15,%ebx
  803aaa:	7f 16                	jg     803ac2 <vprintfmt+0x21a>
  803aac:	48 b8 20 76 80 00 00 	movabs $0x807620,%rax
  803ab3:	00 00 00 
  803ab6:	48 63 d3             	movslq %ebx,%rdx
  803ab9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803abd:	4d 85 e4             	test   %r12,%r12
  803ac0:	75 2e                	jne    803af0 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  803ac2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803ac6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803aca:	89 d9                	mov    %ebx,%ecx
  803acc:	48 ba e1 76 80 00 00 	movabs $0x8076e1,%rdx
  803ad3:	00 00 00 
  803ad6:	48 89 c7             	mov    %rax,%rdi
  803ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  803ade:	49 b8 c0 3d 80 00 00 	movabs $0x803dc0,%r8
  803ae5:	00 00 00 
  803ae8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803aeb:	e9 c1 02 00 00       	jmpq   803db1 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803af0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803af4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803af8:	4c 89 e1             	mov    %r12,%rcx
  803afb:	48 ba ea 76 80 00 00 	movabs $0x8076ea,%rdx
  803b02:	00 00 00 
  803b05:	48 89 c7             	mov    %rax,%rdi
  803b08:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0d:	49 b8 c0 3d 80 00 00 	movabs $0x803dc0,%r8
  803b14:	00 00 00 
  803b17:	41 ff d0             	callq  *%r8
			break;
  803b1a:	e9 92 02 00 00       	jmpq   803db1 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803b1f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803b22:	83 f8 30             	cmp    $0x30,%eax
  803b25:	73 17                	jae    803b3e <vprintfmt+0x296>
  803b27:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803b2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803b2e:	89 c0                	mov    %eax,%eax
  803b30:	48 01 d0             	add    %rdx,%rax
  803b33:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803b36:	83 c2 08             	add    $0x8,%edx
  803b39:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803b3c:	eb 0f                	jmp    803b4d <vprintfmt+0x2a5>
  803b3e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803b42:	48 89 d0             	mov    %rdx,%rax
  803b45:	48 83 c2 08          	add    $0x8,%rdx
  803b49:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803b4d:	4c 8b 20             	mov    (%rax),%r12
  803b50:	4d 85 e4             	test   %r12,%r12
  803b53:	75 0a                	jne    803b5f <vprintfmt+0x2b7>
				p = "(null)";
  803b55:	49 bc ed 76 80 00 00 	movabs $0x8076ed,%r12
  803b5c:	00 00 00 
			if (width > 0 && padc != '-')
  803b5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803b63:	7e 3f                	jle    803ba4 <vprintfmt+0x2fc>
  803b65:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803b69:	74 39                	je     803ba4 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  803b6b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803b6e:	48 98                	cltq   
  803b70:	48 89 c6             	mov    %rax,%rsi
  803b73:	4c 89 e7             	mov    %r12,%rdi
  803b76:	48 b8 6c 40 80 00 00 	movabs $0x80406c,%rax
  803b7d:	00 00 00 
  803b80:	ff d0                	callq  *%rax
  803b82:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803b85:	eb 17                	jmp    803b9e <vprintfmt+0x2f6>
					putch(padc, putdat);
  803b87:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803b8b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803b8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b93:	48 89 ce             	mov    %rcx,%rsi
  803b96:	89 d7                	mov    %edx,%edi
  803b98:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803b9a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803b9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803ba2:	7f e3                	jg     803b87 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803ba4:	eb 37                	jmp    803bdd <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  803ba6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803baa:	74 1e                	je     803bca <vprintfmt+0x322>
  803bac:	83 fb 1f             	cmp    $0x1f,%ebx
  803baf:	7e 05                	jle    803bb6 <vprintfmt+0x30e>
  803bb1:	83 fb 7e             	cmp    $0x7e,%ebx
  803bb4:	7e 14                	jle    803bca <vprintfmt+0x322>
					putch('?', putdat);
  803bb6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bbe:	48 89 d6             	mov    %rdx,%rsi
  803bc1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803bc6:	ff d0                	callq  *%rax
  803bc8:	eb 0f                	jmp    803bd9 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  803bca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bd2:	48 89 d6             	mov    %rdx,%rsi
  803bd5:	89 df                	mov    %ebx,%edi
  803bd7:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803bd9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803bdd:	4c 89 e0             	mov    %r12,%rax
  803be0:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803be4:	0f b6 00             	movzbl (%rax),%eax
  803be7:	0f be d8             	movsbl %al,%ebx
  803bea:	85 db                	test   %ebx,%ebx
  803bec:	74 10                	je     803bfe <vprintfmt+0x356>
  803bee:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803bf2:	78 b2                	js     803ba6 <vprintfmt+0x2fe>
  803bf4:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803bf8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803bfc:	79 a8                	jns    803ba6 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803bfe:	eb 16                	jmp    803c16 <vprintfmt+0x36e>
				putch(' ', putdat);
  803c00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c08:	48 89 d6             	mov    %rdx,%rsi
  803c0b:	bf 20 00 00 00       	mov    $0x20,%edi
  803c10:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803c12:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803c16:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803c1a:	7f e4                	jg     803c00 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  803c1c:	e9 90 01 00 00       	jmpq   803db1 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803c21:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803c25:	be 03 00 00 00       	mov    $0x3,%esi
  803c2a:	48 89 c7             	mov    %rax,%rdi
  803c2d:	48 b8 98 37 80 00 00 	movabs $0x803798,%rax
  803c34:	00 00 00 
  803c37:	ff d0                	callq  *%rax
  803c39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803c3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c41:	48 85 c0             	test   %rax,%rax
  803c44:	79 1d                	jns    803c63 <vprintfmt+0x3bb>
				putch('-', putdat);
  803c46:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c4e:	48 89 d6             	mov    %rdx,%rsi
  803c51:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803c56:	ff d0                	callq  *%rax
				num = -(long long) num;
  803c58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c5c:	48 f7 d8             	neg    %rax
  803c5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803c63:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803c6a:	e9 d5 00 00 00       	jmpq   803d44 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803c6f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803c73:	be 03 00 00 00       	mov    $0x3,%esi
  803c78:	48 89 c7             	mov    %rax,%rdi
  803c7b:	48 b8 88 36 80 00 00 	movabs $0x803688,%rax
  803c82:	00 00 00 
  803c85:	ff d0                	callq  *%rax
  803c87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803c8b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803c92:	e9 ad 00 00 00       	jmpq   803d44 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  803c97:	8b 55 e0             	mov    -0x20(%rbp),%edx
  803c9a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803c9e:	89 d6                	mov    %edx,%esi
  803ca0:	48 89 c7             	mov    %rax,%rdi
  803ca3:	48 b8 98 37 80 00 00 	movabs $0x803798,%rax
  803caa:	00 00 00 
  803cad:	ff d0                	callq  *%rax
  803caf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803cb3:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803cba:	e9 85 00 00 00       	jmpq   803d44 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  803cbf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803cc3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803cc7:	48 89 d6             	mov    %rdx,%rsi
  803cca:	bf 30 00 00 00       	mov    $0x30,%edi
  803ccf:	ff d0                	callq  *%rax
			putch('x', putdat);
  803cd1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803cd5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803cd9:	48 89 d6             	mov    %rdx,%rsi
  803cdc:	bf 78 00 00 00       	mov    $0x78,%edi
  803ce1:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803ce3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803ce6:	83 f8 30             	cmp    $0x30,%eax
  803ce9:	73 17                	jae    803d02 <vprintfmt+0x45a>
  803ceb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803cef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803cf2:	89 c0                	mov    %eax,%eax
  803cf4:	48 01 d0             	add    %rdx,%rax
  803cf7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803cfa:	83 c2 08             	add    $0x8,%edx
  803cfd:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803d00:	eb 0f                	jmp    803d11 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  803d02:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803d06:	48 89 d0             	mov    %rdx,%rax
  803d09:	48 83 c2 08          	add    $0x8,%rdx
  803d0d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803d11:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803d14:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803d18:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803d1f:	eb 23                	jmp    803d44 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803d21:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803d25:	be 03 00 00 00       	mov    $0x3,%esi
  803d2a:	48 89 c7             	mov    %rax,%rdi
  803d2d:	48 b8 88 36 80 00 00 	movabs $0x803688,%rax
  803d34:	00 00 00 
  803d37:	ff d0                	callq  *%rax
  803d39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803d3d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803d44:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803d49:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803d4c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803d4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d53:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803d57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d5b:	45 89 c1             	mov    %r8d,%r9d
  803d5e:	41 89 f8             	mov    %edi,%r8d
  803d61:	48 89 c7             	mov    %rax,%rdi
  803d64:	48 b8 cd 35 80 00 00 	movabs $0x8035cd,%rax
  803d6b:	00 00 00 
  803d6e:	ff d0                	callq  *%rax
			break;
  803d70:	eb 3f                	jmp    803db1 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803d72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803d76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d7a:	48 89 d6             	mov    %rdx,%rsi
  803d7d:	89 df                	mov    %ebx,%edi
  803d7f:	ff d0                	callq  *%rax
			break;
  803d81:	eb 2e                	jmp    803db1 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803d83:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803d87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d8b:	48 89 d6             	mov    %rdx,%rsi
  803d8e:	bf 25 00 00 00       	mov    $0x25,%edi
  803d93:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803d95:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803d9a:	eb 05                	jmp    803da1 <vprintfmt+0x4f9>
  803d9c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803da1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803da5:	48 83 e8 01          	sub    $0x1,%rax
  803da9:	0f b6 00             	movzbl (%rax),%eax
  803dac:	3c 25                	cmp    $0x25,%al
  803dae:	75 ec                	jne    803d9c <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  803db0:	90                   	nop
		}
	}
  803db1:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803db2:	e9 43 fb ff ff       	jmpq   8038fa <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803db7:	48 83 c4 60          	add    $0x60,%rsp
  803dbb:	5b                   	pop    %rbx
  803dbc:	41 5c                	pop    %r12
  803dbe:	5d                   	pop    %rbp
  803dbf:	c3                   	retq   

0000000000803dc0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803dc0:	55                   	push   %rbp
  803dc1:	48 89 e5             	mov    %rsp,%rbp
  803dc4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803dcb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803dd2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803dd9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803de0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803de7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803dee:	84 c0                	test   %al,%al
  803df0:	74 20                	je     803e12 <printfmt+0x52>
  803df2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803df6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803dfa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803dfe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803e02:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803e06:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803e0a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803e0e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803e12:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803e19:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803e20:	00 00 00 
  803e23:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803e2a:	00 00 00 
  803e2d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803e31:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803e38:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803e3f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803e46:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803e4d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803e54:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803e5b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803e62:	48 89 c7             	mov    %rax,%rdi
  803e65:	48 b8 a8 38 80 00 00 	movabs $0x8038a8,%rax
  803e6c:	00 00 00 
  803e6f:	ff d0                	callq  *%rax
	va_end(ap);
}
  803e71:	c9                   	leaveq 
  803e72:	c3                   	retq   

0000000000803e73 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803e73:	55                   	push   %rbp
  803e74:	48 89 e5             	mov    %rsp,%rbp
  803e77:	48 83 ec 10          	sub    $0x10,%rsp
  803e7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e86:	8b 40 10             	mov    0x10(%rax),%eax
  803e89:	8d 50 01             	lea    0x1(%rax),%edx
  803e8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e90:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803e93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e97:	48 8b 10             	mov    (%rax),%rdx
  803e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e9e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803ea2:	48 39 c2             	cmp    %rax,%rdx
  803ea5:	73 17                	jae    803ebe <sprintputch+0x4b>
		*b->buf++ = ch;
  803ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eab:	48 8b 00             	mov    (%rax),%rax
  803eae:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803eb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803eb6:	48 89 0a             	mov    %rcx,(%rdx)
  803eb9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ebc:	88 10                	mov    %dl,(%rax)
}
  803ebe:	c9                   	leaveq 
  803ebf:	c3                   	retq   

0000000000803ec0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803ec0:	55                   	push   %rbp
  803ec1:	48 89 e5             	mov    %rsp,%rbp
  803ec4:	48 83 ec 50          	sub    $0x50,%rsp
  803ec8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803ecc:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803ecf:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803ed3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803ed7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803edb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803edf:	48 8b 0a             	mov    (%rdx),%rcx
  803ee2:	48 89 08             	mov    %rcx,(%rax)
  803ee5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803ee9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803eed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803ef1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803ef5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ef9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803efd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803f00:	48 98                	cltq   
  803f02:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803f06:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f0a:	48 01 d0             	add    %rdx,%rax
  803f0d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803f11:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803f18:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803f1d:	74 06                	je     803f25 <vsnprintf+0x65>
  803f1f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803f23:	7f 07                	jg     803f2c <vsnprintf+0x6c>
		return -E_INVAL;
  803f25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803f2a:	eb 2f                	jmp    803f5b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803f2c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803f30:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803f34:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803f38:	48 89 c6             	mov    %rax,%rsi
  803f3b:	48 bf 73 3e 80 00 00 	movabs $0x803e73,%rdi
  803f42:	00 00 00 
  803f45:	48 b8 a8 38 80 00 00 	movabs $0x8038a8,%rax
  803f4c:	00 00 00 
  803f4f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803f51:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f55:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803f58:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803f5b:	c9                   	leaveq 
  803f5c:	c3                   	retq   

0000000000803f5d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803f5d:	55                   	push   %rbp
  803f5e:	48 89 e5             	mov    %rsp,%rbp
  803f61:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803f68:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803f6f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803f75:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803f7c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803f83:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803f8a:	84 c0                	test   %al,%al
  803f8c:	74 20                	je     803fae <snprintf+0x51>
  803f8e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803f92:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803f96:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803f9a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803f9e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803fa2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803fa6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803faa:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803fae:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803fb5:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803fbc:	00 00 00 
  803fbf:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803fc6:	00 00 00 
  803fc9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803fcd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803fd4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803fdb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803fe2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803fe9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803ff0:	48 8b 0a             	mov    (%rdx),%rcx
  803ff3:	48 89 08             	mov    %rcx,(%rax)
  803ff6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803ffa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803ffe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  804002:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  804006:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80400d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  804014:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80401a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804021:	48 89 c7             	mov    %rax,%rdi
  804024:	48 b8 c0 3e 80 00 00 	movabs $0x803ec0,%rax
  80402b:	00 00 00 
  80402e:	ff d0                	callq  *%rax
  804030:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  804036:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80403c:	c9                   	leaveq 
  80403d:	c3                   	retq   

000000000080403e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80403e:	55                   	push   %rbp
  80403f:	48 89 e5             	mov    %rsp,%rbp
  804042:	48 83 ec 18          	sub    $0x18,%rsp
  804046:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80404a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804051:	eb 09                	jmp    80405c <strlen+0x1e>
		n++;
  804053:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  804057:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80405c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804060:	0f b6 00             	movzbl (%rax),%eax
  804063:	84 c0                	test   %al,%al
  804065:	75 ec                	jne    804053 <strlen+0x15>
		n++;
	return n;
  804067:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80406a:	c9                   	leaveq 
  80406b:	c3                   	retq   

000000000080406c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80406c:	55                   	push   %rbp
  80406d:	48 89 e5             	mov    %rsp,%rbp
  804070:	48 83 ec 20          	sub    $0x20,%rsp
  804074:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804078:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80407c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804083:	eb 0e                	jmp    804093 <strnlen+0x27>
		n++;
  804085:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  804089:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80408e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  804093:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804098:	74 0b                	je     8040a5 <strnlen+0x39>
  80409a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80409e:	0f b6 00             	movzbl (%rax),%eax
  8040a1:	84 c0                	test   %al,%al
  8040a3:	75 e0                	jne    804085 <strnlen+0x19>
		n++;
	return n;
  8040a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8040a8:	c9                   	leaveq 
  8040a9:	c3                   	retq   

00000000008040aa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8040aa:	55                   	push   %rbp
  8040ab:	48 89 e5             	mov    %rsp,%rbp
  8040ae:	48 83 ec 20          	sub    $0x20,%rsp
  8040b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8040ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8040c2:	90                   	nop
  8040c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8040cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8040cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8040d3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8040d7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8040db:	0f b6 12             	movzbl (%rdx),%edx
  8040de:	88 10                	mov    %dl,(%rax)
  8040e0:	0f b6 00             	movzbl (%rax),%eax
  8040e3:	84 c0                	test   %al,%al
  8040e5:	75 dc                	jne    8040c3 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8040e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040eb:	c9                   	leaveq 
  8040ec:	c3                   	retq   

00000000008040ed <strcat>:

char *
strcat(char *dst, const char *src)
{
  8040ed:	55                   	push   %rbp
  8040ee:	48 89 e5             	mov    %rsp,%rbp
  8040f1:	48 83 ec 20          	sub    $0x20,%rsp
  8040f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8040fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804101:	48 89 c7             	mov    %rax,%rdi
  804104:	48 b8 3e 40 80 00 00 	movabs $0x80403e,%rax
  80410b:	00 00 00 
  80410e:	ff d0                	callq  *%rax
  804110:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  804113:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804116:	48 63 d0             	movslq %eax,%rdx
  804119:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80411d:	48 01 c2             	add    %rax,%rdx
  804120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804124:	48 89 c6             	mov    %rax,%rsi
  804127:	48 89 d7             	mov    %rdx,%rdi
  80412a:	48 b8 aa 40 80 00 00 	movabs $0x8040aa,%rax
  804131:	00 00 00 
  804134:	ff d0                	callq  *%rax
	return dst;
  804136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80413a:	c9                   	leaveq 
  80413b:	c3                   	retq   

000000000080413c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80413c:	55                   	push   %rbp
  80413d:	48 89 e5             	mov    %rsp,%rbp
  804140:	48 83 ec 28          	sub    $0x28,%rsp
  804144:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804148:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80414c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  804150:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804154:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  804158:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80415f:	00 
  804160:	eb 2a                	jmp    80418c <strncpy+0x50>
		*dst++ = *src;
  804162:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804166:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80416a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80416e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804172:	0f b6 12             	movzbl (%rdx),%edx
  804175:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  804177:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80417b:	0f b6 00             	movzbl (%rax),%eax
  80417e:	84 c0                	test   %al,%al
  804180:	74 05                	je     804187 <strncpy+0x4b>
			src++;
  804182:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  804187:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80418c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804190:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  804194:	72 cc                	jb     804162 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  804196:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80419a:	c9                   	leaveq 
  80419b:	c3                   	retq   

000000000080419c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80419c:	55                   	push   %rbp
  80419d:	48 89 e5             	mov    %rsp,%rbp
  8041a0:	48 83 ec 28          	sub    $0x28,%rsp
  8041a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8041b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8041b8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8041bd:	74 3d                	je     8041fc <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8041bf:	eb 1d                	jmp    8041de <strlcpy+0x42>
			*dst++ = *src++;
  8041c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041c5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8041c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8041cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041d1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8041d5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8041d9:	0f b6 12             	movzbl (%rdx),%edx
  8041dc:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8041de:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8041e3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8041e8:	74 0b                	je     8041f5 <strlcpy+0x59>
  8041ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041ee:	0f b6 00             	movzbl (%rax),%eax
  8041f1:	84 c0                	test   %al,%al
  8041f3:	75 cc                	jne    8041c1 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8041f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041f9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8041fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804204:	48 29 c2             	sub    %rax,%rdx
  804207:	48 89 d0             	mov    %rdx,%rax
}
  80420a:	c9                   	leaveq 
  80420b:	c3                   	retq   

000000000080420c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80420c:	55                   	push   %rbp
  80420d:	48 89 e5             	mov    %rsp,%rbp
  804210:	48 83 ec 10          	sub    $0x10,%rsp
  804214:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804218:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80421c:	eb 0a                	jmp    804228 <strcmp+0x1c>
		p++, q++;
  80421e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804223:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  804228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80422c:	0f b6 00             	movzbl (%rax),%eax
  80422f:	84 c0                	test   %al,%al
  804231:	74 12                	je     804245 <strcmp+0x39>
  804233:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804237:	0f b6 10             	movzbl (%rax),%edx
  80423a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423e:	0f b6 00             	movzbl (%rax),%eax
  804241:	38 c2                	cmp    %al,%dl
  804243:	74 d9                	je     80421e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  804245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804249:	0f b6 00             	movzbl (%rax),%eax
  80424c:	0f b6 d0             	movzbl %al,%edx
  80424f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804253:	0f b6 00             	movzbl (%rax),%eax
  804256:	0f b6 c0             	movzbl %al,%eax
  804259:	29 c2                	sub    %eax,%edx
  80425b:	89 d0                	mov    %edx,%eax
}
  80425d:	c9                   	leaveq 
  80425e:	c3                   	retq   

000000000080425f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80425f:	55                   	push   %rbp
  804260:	48 89 e5             	mov    %rsp,%rbp
  804263:	48 83 ec 18          	sub    $0x18,%rsp
  804267:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80426b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80426f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  804273:	eb 0f                	jmp    804284 <strncmp+0x25>
		n--, p++, q++;
  804275:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80427a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80427f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  804284:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804289:	74 1d                	je     8042a8 <strncmp+0x49>
  80428b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80428f:	0f b6 00             	movzbl (%rax),%eax
  804292:	84 c0                	test   %al,%al
  804294:	74 12                	je     8042a8 <strncmp+0x49>
  804296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80429a:	0f b6 10             	movzbl (%rax),%edx
  80429d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042a1:	0f b6 00             	movzbl (%rax),%eax
  8042a4:	38 c2                	cmp    %al,%dl
  8042a6:	74 cd                	je     804275 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8042a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042ad:	75 07                	jne    8042b6 <strncmp+0x57>
		return 0;
  8042af:	b8 00 00 00 00       	mov    $0x0,%eax
  8042b4:	eb 18                	jmp    8042ce <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8042b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ba:	0f b6 00             	movzbl (%rax),%eax
  8042bd:	0f b6 d0             	movzbl %al,%edx
  8042c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042c4:	0f b6 00             	movzbl (%rax),%eax
  8042c7:	0f b6 c0             	movzbl %al,%eax
  8042ca:	29 c2                	sub    %eax,%edx
  8042cc:	89 d0                	mov    %edx,%eax
}
  8042ce:	c9                   	leaveq 
  8042cf:	c3                   	retq   

00000000008042d0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8042d0:	55                   	push   %rbp
  8042d1:	48 89 e5             	mov    %rsp,%rbp
  8042d4:	48 83 ec 0c          	sub    $0xc,%rsp
  8042d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042dc:	89 f0                	mov    %esi,%eax
  8042de:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8042e1:	eb 17                	jmp    8042fa <strchr+0x2a>
		if (*s == c)
  8042e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042e7:	0f b6 00             	movzbl (%rax),%eax
  8042ea:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8042ed:	75 06                	jne    8042f5 <strchr+0x25>
			return (char *) s;
  8042ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042f3:	eb 15                	jmp    80430a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8042f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042fe:	0f b6 00             	movzbl (%rax),%eax
  804301:	84 c0                	test   %al,%al
  804303:	75 de                	jne    8042e3 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  804305:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80430a:	c9                   	leaveq 
  80430b:	c3                   	retq   

000000000080430c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80430c:	55                   	push   %rbp
  80430d:	48 89 e5             	mov    %rsp,%rbp
  804310:	48 83 ec 0c          	sub    $0xc,%rsp
  804314:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804318:	89 f0                	mov    %esi,%eax
  80431a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80431d:	eb 13                	jmp    804332 <strfind+0x26>
		if (*s == c)
  80431f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804323:	0f b6 00             	movzbl (%rax),%eax
  804326:	3a 45 f4             	cmp    -0xc(%rbp),%al
  804329:	75 02                	jne    80432d <strfind+0x21>
			break;
  80432b:	eb 10                	jmp    80433d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80432d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804336:	0f b6 00             	movzbl (%rax),%eax
  804339:	84 c0                	test   %al,%al
  80433b:	75 e2                	jne    80431f <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80433d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804341:	c9                   	leaveq 
  804342:	c3                   	retq   

0000000000804343 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  804343:	55                   	push   %rbp
  804344:	48 89 e5             	mov    %rsp,%rbp
  804347:	48 83 ec 18          	sub    $0x18,%rsp
  80434b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80434f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  804352:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  804356:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80435b:	75 06                	jne    804363 <memset+0x20>
		return v;
  80435d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804361:	eb 69                	jmp    8043cc <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  804363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804367:	83 e0 03             	and    $0x3,%eax
  80436a:	48 85 c0             	test   %rax,%rax
  80436d:	75 48                	jne    8043b7 <memset+0x74>
  80436f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804373:	83 e0 03             	and    $0x3,%eax
  804376:	48 85 c0             	test   %rax,%rax
  804379:	75 3c                	jne    8043b7 <memset+0x74>
		c &= 0xFF;
  80437b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  804382:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804385:	c1 e0 18             	shl    $0x18,%eax
  804388:	89 c2                	mov    %eax,%edx
  80438a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80438d:	c1 e0 10             	shl    $0x10,%eax
  804390:	09 c2                	or     %eax,%edx
  804392:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804395:	c1 e0 08             	shl    $0x8,%eax
  804398:	09 d0                	or     %edx,%eax
  80439a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80439d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043a1:	48 c1 e8 02          	shr    $0x2,%rax
  8043a5:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8043a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8043ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043af:	48 89 d7             	mov    %rdx,%rdi
  8043b2:	fc                   	cld    
  8043b3:	f3 ab                	rep stos %eax,%es:(%rdi)
  8043b5:	eb 11                	jmp    8043c8 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8043b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8043bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043be:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8043c2:	48 89 d7             	mov    %rdx,%rdi
  8043c5:	fc                   	cld    
  8043c6:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8043c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8043cc:	c9                   	leaveq 
  8043cd:	c3                   	retq   

00000000008043ce <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8043ce:	55                   	push   %rbp
  8043cf:	48 89 e5             	mov    %rsp,%rbp
  8043d2:	48 83 ec 28          	sub    $0x28,%rsp
  8043d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8043e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8043ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8043f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043f6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8043fa:	0f 83 88 00 00 00    	jae    804488 <memmove+0xba>
  804400:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804404:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804408:	48 01 d0             	add    %rdx,%rax
  80440b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80440f:	76 77                	jbe    804488 <memmove+0xba>
		s += n;
  804411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804415:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  804419:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80441d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  804421:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804425:	83 e0 03             	and    $0x3,%eax
  804428:	48 85 c0             	test   %rax,%rax
  80442b:	75 3b                	jne    804468 <memmove+0x9a>
  80442d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804431:	83 e0 03             	and    $0x3,%eax
  804434:	48 85 c0             	test   %rax,%rax
  804437:	75 2f                	jne    804468 <memmove+0x9a>
  804439:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80443d:	83 e0 03             	and    $0x3,%eax
  804440:	48 85 c0             	test   %rax,%rax
  804443:	75 23                	jne    804468 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  804445:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804449:	48 83 e8 04          	sub    $0x4,%rax
  80444d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804451:	48 83 ea 04          	sub    $0x4,%rdx
  804455:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804459:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80445d:	48 89 c7             	mov    %rax,%rdi
  804460:	48 89 d6             	mov    %rdx,%rsi
  804463:	fd                   	std    
  804464:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804466:	eb 1d                	jmp    804485 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  804468:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80446c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  804470:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804474:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  804478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80447c:	48 89 d7             	mov    %rdx,%rdi
  80447f:	48 89 c1             	mov    %rax,%rcx
  804482:	fd                   	std    
  804483:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  804485:	fc                   	cld    
  804486:	eb 57                	jmp    8044df <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  804488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80448c:	83 e0 03             	and    $0x3,%eax
  80448f:	48 85 c0             	test   %rax,%rax
  804492:	75 36                	jne    8044ca <memmove+0xfc>
  804494:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804498:	83 e0 03             	and    $0x3,%eax
  80449b:	48 85 c0             	test   %rax,%rax
  80449e:	75 2a                	jne    8044ca <memmove+0xfc>
  8044a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044a4:	83 e0 03             	and    $0x3,%eax
  8044a7:	48 85 c0             	test   %rax,%rax
  8044aa:	75 1e                	jne    8044ca <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8044ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044b0:	48 c1 e8 02          	shr    $0x2,%rax
  8044b4:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8044b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8044bf:	48 89 c7             	mov    %rax,%rdi
  8044c2:	48 89 d6             	mov    %rdx,%rsi
  8044c5:	fc                   	cld    
  8044c6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8044c8:	eb 15                	jmp    8044df <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8044ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8044d2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8044d6:	48 89 c7             	mov    %rax,%rdi
  8044d9:	48 89 d6             	mov    %rdx,%rsi
  8044dc:	fc                   	cld    
  8044dd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8044df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8044e3:	c9                   	leaveq 
  8044e4:	c3                   	retq   

00000000008044e5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8044e5:	55                   	push   %rbp
  8044e6:	48 89 e5             	mov    %rsp,%rbp
  8044e9:	48 83 ec 18          	sub    $0x18,%rsp
  8044ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8044f5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8044f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8044fd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804501:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804505:	48 89 ce             	mov    %rcx,%rsi
  804508:	48 89 c7             	mov    %rax,%rdi
  80450b:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  804512:	00 00 00 
  804515:	ff d0                	callq  *%rax
}
  804517:	c9                   	leaveq 
  804518:	c3                   	retq   

0000000000804519 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  804519:	55                   	push   %rbp
  80451a:	48 89 e5             	mov    %rsp,%rbp
  80451d:	48 83 ec 28          	sub    $0x28,%rsp
  804521:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804525:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804529:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80452d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804531:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  804535:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804539:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80453d:	eb 36                	jmp    804575 <memcmp+0x5c>
		if (*s1 != *s2)
  80453f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804543:	0f b6 10             	movzbl (%rax),%edx
  804546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80454a:	0f b6 00             	movzbl (%rax),%eax
  80454d:	38 c2                	cmp    %al,%dl
  80454f:	74 1a                	je     80456b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  804551:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804555:	0f b6 00             	movzbl (%rax),%eax
  804558:	0f b6 d0             	movzbl %al,%edx
  80455b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80455f:	0f b6 00             	movzbl (%rax),%eax
  804562:	0f b6 c0             	movzbl %al,%eax
  804565:	29 c2                	sub    %eax,%edx
  804567:	89 d0                	mov    %edx,%eax
  804569:	eb 20                	jmp    80458b <memcmp+0x72>
		s1++, s2++;
  80456b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804570:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  804575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804579:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80457d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  804581:	48 85 c0             	test   %rax,%rax
  804584:	75 b9                	jne    80453f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  804586:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80458b:	c9                   	leaveq 
  80458c:	c3                   	retq   

000000000080458d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80458d:	55                   	push   %rbp
  80458e:	48 89 e5             	mov    %rsp,%rbp
  804591:	48 83 ec 28          	sub    $0x28,%rsp
  804595:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804599:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80459c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8045a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8045a8:	48 01 d0             	add    %rdx,%rax
  8045ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8045af:	eb 15                	jmp    8045c6 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8045b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045b5:	0f b6 10             	movzbl (%rax),%edx
  8045b8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8045bb:	38 c2                	cmp    %al,%dl
  8045bd:	75 02                	jne    8045c1 <memfind+0x34>
			break;
  8045bf:	eb 0f                	jmp    8045d0 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8045c1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8045c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045ca:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8045ce:	72 e1                	jb     8045b1 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8045d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8045d4:	c9                   	leaveq 
  8045d5:	c3                   	retq   

00000000008045d6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8045d6:	55                   	push   %rbp
  8045d7:	48 89 e5             	mov    %rsp,%rbp
  8045da:	48 83 ec 34          	sub    $0x34,%rsp
  8045de:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8045e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8045e6:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8045e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8045f0:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8045f7:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8045f8:	eb 05                	jmp    8045ff <strtol+0x29>
		s++;
  8045fa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8045ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804603:	0f b6 00             	movzbl (%rax),%eax
  804606:	3c 20                	cmp    $0x20,%al
  804608:	74 f0                	je     8045fa <strtol+0x24>
  80460a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80460e:	0f b6 00             	movzbl (%rax),%eax
  804611:	3c 09                	cmp    $0x9,%al
  804613:	74 e5                	je     8045fa <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  804615:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804619:	0f b6 00             	movzbl (%rax),%eax
  80461c:	3c 2b                	cmp    $0x2b,%al
  80461e:	75 07                	jne    804627 <strtol+0x51>
		s++;
  804620:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804625:	eb 17                	jmp    80463e <strtol+0x68>
	else if (*s == '-')
  804627:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80462b:	0f b6 00             	movzbl (%rax),%eax
  80462e:	3c 2d                	cmp    $0x2d,%al
  804630:	75 0c                	jne    80463e <strtol+0x68>
		s++, neg = 1;
  804632:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804637:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80463e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804642:	74 06                	je     80464a <strtol+0x74>
  804644:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  804648:	75 28                	jne    804672 <strtol+0x9c>
  80464a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80464e:	0f b6 00             	movzbl (%rax),%eax
  804651:	3c 30                	cmp    $0x30,%al
  804653:	75 1d                	jne    804672 <strtol+0x9c>
  804655:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804659:	48 83 c0 01          	add    $0x1,%rax
  80465d:	0f b6 00             	movzbl (%rax),%eax
  804660:	3c 78                	cmp    $0x78,%al
  804662:	75 0e                	jne    804672 <strtol+0x9c>
		s += 2, base = 16;
  804664:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  804669:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  804670:	eb 2c                	jmp    80469e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  804672:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804676:	75 19                	jne    804691 <strtol+0xbb>
  804678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80467c:	0f b6 00             	movzbl (%rax),%eax
  80467f:	3c 30                	cmp    $0x30,%al
  804681:	75 0e                	jne    804691 <strtol+0xbb>
		s++, base = 8;
  804683:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804688:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80468f:	eb 0d                	jmp    80469e <strtol+0xc8>
	else if (base == 0)
  804691:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804695:	75 07                	jne    80469e <strtol+0xc8>
		base = 10;
  804697:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80469e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046a2:	0f b6 00             	movzbl (%rax),%eax
  8046a5:	3c 2f                	cmp    $0x2f,%al
  8046a7:	7e 1d                	jle    8046c6 <strtol+0xf0>
  8046a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046ad:	0f b6 00             	movzbl (%rax),%eax
  8046b0:	3c 39                	cmp    $0x39,%al
  8046b2:	7f 12                	jg     8046c6 <strtol+0xf0>
			dig = *s - '0';
  8046b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046b8:	0f b6 00             	movzbl (%rax),%eax
  8046bb:	0f be c0             	movsbl %al,%eax
  8046be:	83 e8 30             	sub    $0x30,%eax
  8046c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8046c4:	eb 4e                	jmp    804714 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8046c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046ca:	0f b6 00             	movzbl (%rax),%eax
  8046cd:	3c 60                	cmp    $0x60,%al
  8046cf:	7e 1d                	jle    8046ee <strtol+0x118>
  8046d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046d5:	0f b6 00             	movzbl (%rax),%eax
  8046d8:	3c 7a                	cmp    $0x7a,%al
  8046da:	7f 12                	jg     8046ee <strtol+0x118>
			dig = *s - 'a' + 10;
  8046dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046e0:	0f b6 00             	movzbl (%rax),%eax
  8046e3:	0f be c0             	movsbl %al,%eax
  8046e6:	83 e8 57             	sub    $0x57,%eax
  8046e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8046ec:	eb 26                	jmp    804714 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8046ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046f2:	0f b6 00             	movzbl (%rax),%eax
  8046f5:	3c 40                	cmp    $0x40,%al
  8046f7:	7e 48                	jle    804741 <strtol+0x16b>
  8046f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046fd:	0f b6 00             	movzbl (%rax),%eax
  804700:	3c 5a                	cmp    $0x5a,%al
  804702:	7f 3d                	jg     804741 <strtol+0x16b>
			dig = *s - 'A' + 10;
  804704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804708:	0f b6 00             	movzbl (%rax),%eax
  80470b:	0f be c0             	movsbl %al,%eax
  80470e:	83 e8 37             	sub    $0x37,%eax
  804711:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  804714:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804717:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80471a:	7c 02                	jl     80471e <strtol+0x148>
			break;
  80471c:	eb 23                	jmp    804741 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80471e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804723:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804726:	48 98                	cltq   
  804728:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80472d:	48 89 c2             	mov    %rax,%rdx
  804730:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804733:	48 98                	cltq   
  804735:	48 01 d0             	add    %rdx,%rax
  804738:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80473c:	e9 5d ff ff ff       	jmpq   80469e <strtol+0xc8>

	if (endptr)
  804741:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804746:	74 0b                	je     804753 <strtol+0x17d>
		*endptr = (char *) s;
  804748:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80474c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804750:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  804753:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804757:	74 09                	je     804762 <strtol+0x18c>
  804759:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80475d:	48 f7 d8             	neg    %rax
  804760:	eb 04                	jmp    804766 <strtol+0x190>
  804762:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  804766:	c9                   	leaveq 
  804767:	c3                   	retq   

0000000000804768 <strstr>:

char * strstr(const char *in, const char *str)
{
  804768:	55                   	push   %rbp
  804769:	48 89 e5             	mov    %rsp,%rbp
  80476c:	48 83 ec 30          	sub    $0x30,%rsp
  804770:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804774:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  804778:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80477c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804780:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804784:	0f b6 00             	movzbl (%rax),%eax
  804787:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80478a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80478e:	75 06                	jne    804796 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  804790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804794:	eb 6b                	jmp    804801 <strstr+0x99>

	len = strlen(str);
  804796:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80479a:	48 89 c7             	mov    %rax,%rdi
  80479d:	48 b8 3e 40 80 00 00 	movabs $0x80403e,%rax
  8047a4:	00 00 00 
  8047a7:	ff d0                	callq  *%rax
  8047a9:	48 98                	cltq   
  8047ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8047af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8047b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8047bb:	0f b6 00             	movzbl (%rax),%eax
  8047be:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8047c1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8047c5:	75 07                	jne    8047ce <strstr+0x66>
				return (char *) 0;
  8047c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8047cc:	eb 33                	jmp    804801 <strstr+0x99>
		} while (sc != c);
  8047ce:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8047d2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8047d5:	75 d8                	jne    8047af <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8047d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047db:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8047df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047e3:	48 89 ce             	mov    %rcx,%rsi
  8047e6:	48 89 c7             	mov    %rax,%rdi
  8047e9:	48 b8 5f 42 80 00 00 	movabs $0x80425f,%rax
  8047f0:	00 00 00 
  8047f3:	ff d0                	callq  *%rax
  8047f5:	85 c0                	test   %eax,%eax
  8047f7:	75 b6                	jne    8047af <strstr+0x47>

	return (char *) (in - 1);
  8047f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047fd:	48 83 e8 01          	sub    $0x1,%rax
}
  804801:	c9                   	leaveq 
  804802:	c3                   	retq   

0000000000804803 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  804803:	55                   	push   %rbp
  804804:	48 89 e5             	mov    %rsp,%rbp
  804807:	53                   	push   %rbx
  804808:	48 83 ec 48          	sub    $0x48,%rsp
  80480c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80480f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804812:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804816:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80481a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80481e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  804822:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804825:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804829:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80482d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  804831:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  804835:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  804839:	4c 89 c3             	mov    %r8,%rbx
  80483c:	cd 30                	int    $0x30
  80483e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  804842:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804846:	74 3e                	je     804886 <syscall+0x83>
  804848:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80484d:	7e 37                	jle    804886 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80484f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804853:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804856:	49 89 d0             	mov    %rdx,%r8
  804859:	89 c1                	mov    %eax,%ecx
  80485b:	48 ba a8 79 80 00 00 	movabs $0x8079a8,%rdx
  804862:	00 00 00 
  804865:	be 23 00 00 00       	mov    $0x23,%esi
  80486a:	48 bf c5 79 80 00 00 	movabs $0x8079c5,%rdi
  804871:	00 00 00 
  804874:	b8 00 00 00 00       	mov    $0x0,%eax
  804879:	49 b9 bc 32 80 00 00 	movabs $0x8032bc,%r9
  804880:	00 00 00 
  804883:	41 ff d1             	callq  *%r9

	return ret;
  804886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80488a:	48 83 c4 48          	add    $0x48,%rsp
  80488e:	5b                   	pop    %rbx
  80488f:	5d                   	pop    %rbp
  804890:	c3                   	retq   

0000000000804891 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  804891:	55                   	push   %rbp
  804892:	48 89 e5             	mov    %rsp,%rbp
  804895:	48 83 ec 20          	sub    $0x20,%rsp
  804899:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80489d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8048a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048a9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8048b0:	00 
  8048b1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8048b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8048bd:	48 89 d1             	mov    %rdx,%rcx
  8048c0:	48 89 c2             	mov    %rax,%rdx
  8048c3:	be 00 00 00 00       	mov    $0x0,%esi
  8048c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8048cd:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  8048d4:	00 00 00 
  8048d7:	ff d0                	callq  *%rax
}
  8048d9:	c9                   	leaveq 
  8048da:	c3                   	retq   

00000000008048db <sys_cgetc>:

int
sys_cgetc(void)
{
  8048db:	55                   	push   %rbp
  8048dc:	48 89 e5             	mov    %rsp,%rbp
  8048df:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8048e3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8048ea:	00 
  8048eb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8048f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8048f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8048fc:	ba 00 00 00 00       	mov    $0x0,%edx
  804901:	be 00 00 00 00       	mov    $0x0,%esi
  804906:	bf 01 00 00 00       	mov    $0x1,%edi
  80490b:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804912:	00 00 00 
  804915:	ff d0                	callq  *%rax
}
  804917:	c9                   	leaveq 
  804918:	c3                   	retq   

0000000000804919 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  804919:	55                   	push   %rbp
  80491a:	48 89 e5             	mov    %rsp,%rbp
  80491d:	48 83 ec 10          	sub    $0x10,%rsp
  804921:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  804924:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804927:	48 98                	cltq   
  804929:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804930:	00 
  804931:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804937:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80493d:	b9 00 00 00 00       	mov    $0x0,%ecx
  804942:	48 89 c2             	mov    %rax,%rdx
  804945:	be 01 00 00 00       	mov    $0x1,%esi
  80494a:	bf 03 00 00 00       	mov    $0x3,%edi
  80494f:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804956:	00 00 00 
  804959:	ff d0                	callq  *%rax
}
  80495b:	c9                   	leaveq 
  80495c:	c3                   	retq   

000000000080495d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80495d:	55                   	push   %rbp
  80495e:	48 89 e5             	mov    %rsp,%rbp
  804961:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  804965:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80496c:	00 
  80496d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804973:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804979:	b9 00 00 00 00       	mov    $0x0,%ecx
  80497e:	ba 00 00 00 00       	mov    $0x0,%edx
  804983:	be 00 00 00 00       	mov    $0x0,%esi
  804988:	bf 02 00 00 00       	mov    $0x2,%edi
  80498d:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804994:	00 00 00 
  804997:	ff d0                	callq  *%rax
}
  804999:	c9                   	leaveq 
  80499a:	c3                   	retq   

000000000080499b <sys_yield>:

void
sys_yield(void)
{
  80499b:	55                   	push   %rbp
  80499c:	48 89 e5             	mov    %rsp,%rbp
  80499f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8049a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8049aa:	00 
  8049ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8049b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8049b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8049bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8049c1:	be 00 00 00 00       	mov    $0x0,%esi
  8049c6:	bf 0b 00 00 00       	mov    $0xb,%edi
  8049cb:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  8049d2:	00 00 00 
  8049d5:	ff d0                	callq  *%rax
}
  8049d7:	c9                   	leaveq 
  8049d8:	c3                   	retq   

00000000008049d9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8049d9:	55                   	push   %rbp
  8049da:	48 89 e5             	mov    %rsp,%rbp
  8049dd:	48 83 ec 20          	sub    $0x20,%rsp
  8049e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8049e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8049e8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8049eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8049ee:	48 63 c8             	movslq %eax,%rcx
  8049f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049f8:	48 98                	cltq   
  8049fa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a01:	00 
  804a02:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a08:	49 89 c8             	mov    %rcx,%r8
  804a0b:	48 89 d1             	mov    %rdx,%rcx
  804a0e:	48 89 c2             	mov    %rax,%rdx
  804a11:	be 01 00 00 00       	mov    $0x1,%esi
  804a16:	bf 04 00 00 00       	mov    $0x4,%edi
  804a1b:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804a22:	00 00 00 
  804a25:	ff d0                	callq  *%rax
}
  804a27:	c9                   	leaveq 
  804a28:	c3                   	retq   

0000000000804a29 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  804a29:	55                   	push   %rbp
  804a2a:	48 89 e5             	mov    %rsp,%rbp
  804a2d:	48 83 ec 30          	sub    $0x30,%rsp
  804a31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a34:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804a38:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804a3b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804a3f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  804a43:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804a46:	48 63 c8             	movslq %eax,%rcx
  804a49:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804a4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a50:	48 63 f0             	movslq %eax,%rsi
  804a53:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a5a:	48 98                	cltq   
  804a5c:	48 89 0c 24          	mov    %rcx,(%rsp)
  804a60:	49 89 f9             	mov    %rdi,%r9
  804a63:	49 89 f0             	mov    %rsi,%r8
  804a66:	48 89 d1             	mov    %rdx,%rcx
  804a69:	48 89 c2             	mov    %rax,%rdx
  804a6c:	be 01 00 00 00       	mov    $0x1,%esi
  804a71:	bf 05 00 00 00       	mov    $0x5,%edi
  804a76:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804a7d:	00 00 00 
  804a80:	ff d0                	callq  *%rax
}
  804a82:	c9                   	leaveq 
  804a83:	c3                   	retq   

0000000000804a84 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  804a84:	55                   	push   %rbp
  804a85:	48 89 e5             	mov    %rsp,%rbp
  804a88:	48 83 ec 20          	sub    $0x20,%rsp
  804a8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  804a93:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a9a:	48 98                	cltq   
  804a9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804aa3:	00 
  804aa4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804aaa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804ab0:	48 89 d1             	mov    %rdx,%rcx
  804ab3:	48 89 c2             	mov    %rax,%rdx
  804ab6:	be 01 00 00 00       	mov    $0x1,%esi
  804abb:	bf 06 00 00 00       	mov    $0x6,%edi
  804ac0:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804ac7:	00 00 00 
  804aca:	ff d0                	callq  *%rax
}
  804acc:	c9                   	leaveq 
  804acd:	c3                   	retq   

0000000000804ace <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  804ace:	55                   	push   %rbp
  804acf:	48 89 e5             	mov    %rsp,%rbp
  804ad2:	48 83 ec 10          	sub    $0x10,%rsp
  804ad6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804ad9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  804adc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804adf:	48 63 d0             	movslq %eax,%rdx
  804ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ae5:	48 98                	cltq   
  804ae7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804aee:	00 
  804aef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804af5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804afb:	48 89 d1             	mov    %rdx,%rcx
  804afe:	48 89 c2             	mov    %rax,%rdx
  804b01:	be 01 00 00 00       	mov    $0x1,%esi
  804b06:	bf 08 00 00 00       	mov    $0x8,%edi
  804b0b:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804b12:	00 00 00 
  804b15:	ff d0                	callq  *%rax
}
  804b17:	c9                   	leaveq 
  804b18:	c3                   	retq   

0000000000804b19 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  804b19:	55                   	push   %rbp
  804b1a:	48 89 e5             	mov    %rsp,%rbp
  804b1d:	48 83 ec 20          	sub    $0x20,%rsp
  804b21:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  804b28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b2f:	48 98                	cltq   
  804b31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b38:	00 
  804b39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b45:	48 89 d1             	mov    %rdx,%rcx
  804b48:	48 89 c2             	mov    %rax,%rdx
  804b4b:	be 01 00 00 00       	mov    $0x1,%esi
  804b50:	bf 09 00 00 00       	mov    $0x9,%edi
  804b55:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804b5c:	00 00 00 
  804b5f:	ff d0                	callq  *%rax
}
  804b61:	c9                   	leaveq 
  804b62:	c3                   	retq   

0000000000804b63 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  804b63:	55                   	push   %rbp
  804b64:	48 89 e5             	mov    %rsp,%rbp
  804b67:	48 83 ec 20          	sub    $0x20,%rsp
  804b6b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  804b72:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b79:	48 98                	cltq   
  804b7b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b82:	00 
  804b83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b8f:	48 89 d1             	mov    %rdx,%rcx
  804b92:	48 89 c2             	mov    %rax,%rdx
  804b95:	be 01 00 00 00       	mov    $0x1,%esi
  804b9a:	bf 0a 00 00 00       	mov    $0xa,%edi
  804b9f:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804ba6:	00 00 00 
  804ba9:	ff d0                	callq  *%rax
}
  804bab:	c9                   	leaveq 
  804bac:	c3                   	retq   

0000000000804bad <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804bad:	55                   	push   %rbp
  804bae:	48 89 e5             	mov    %rsp,%rbp
  804bb1:	48 83 ec 20          	sub    $0x20,%rsp
  804bb5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804bb8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804bbc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804bc0:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804bc3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804bc6:	48 63 f0             	movslq %eax,%rsi
  804bc9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804bcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bd0:	48 98                	cltq   
  804bd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804bd6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804bdd:	00 
  804bde:	49 89 f1             	mov    %rsi,%r9
  804be1:	49 89 c8             	mov    %rcx,%r8
  804be4:	48 89 d1             	mov    %rdx,%rcx
  804be7:	48 89 c2             	mov    %rax,%rdx
  804bea:	be 00 00 00 00       	mov    $0x0,%esi
  804bef:	bf 0c 00 00 00       	mov    $0xc,%edi
  804bf4:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804bfb:	00 00 00 
  804bfe:	ff d0                	callq  *%rax
}
  804c00:	c9                   	leaveq 
  804c01:	c3                   	retq   

0000000000804c02 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  804c02:	55                   	push   %rbp
  804c03:	48 89 e5             	mov    %rsp,%rbp
  804c06:	48 83 ec 10          	sub    $0x10,%rsp
  804c0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  804c0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c12:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804c19:	00 
  804c1a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c20:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c26:	b9 00 00 00 00       	mov    $0x0,%ecx
  804c2b:	48 89 c2             	mov    %rax,%rdx
  804c2e:	be 01 00 00 00       	mov    $0x1,%esi
  804c33:	bf 0d 00 00 00       	mov    $0xd,%edi
  804c38:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804c3f:	00 00 00 
  804c42:	ff d0                	callq  *%rax
}
  804c44:	c9                   	leaveq 
  804c45:	c3                   	retq   

0000000000804c46 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  804c46:	55                   	push   %rbp
  804c47:	48 89 e5             	mov    %rsp,%rbp
  804c4a:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  804c4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804c55:	00 
  804c56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c62:	b9 00 00 00 00       	mov    $0x0,%ecx
  804c67:	ba 00 00 00 00       	mov    $0x0,%edx
  804c6c:	be 00 00 00 00       	mov    $0x0,%esi
  804c71:	bf 0e 00 00 00       	mov    $0xe,%edi
  804c76:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804c7d:	00 00 00 
  804c80:	ff d0                	callq  *%rax
}
  804c82:	c9                   	leaveq 
  804c83:	c3                   	retq   

0000000000804c84 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  804c84:	55                   	push   %rbp
  804c85:	48 89 e5             	mov    %rsp,%rbp
  804c88:	48 83 ec 30          	sub    $0x30,%rsp
  804c8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804c93:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804c96:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804c9a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  804c9e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ca1:	48 63 c8             	movslq %eax,%rcx
  804ca4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804ca8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804cab:	48 63 f0             	movslq %eax,%rsi
  804cae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cb5:	48 98                	cltq   
  804cb7:	48 89 0c 24          	mov    %rcx,(%rsp)
  804cbb:	49 89 f9             	mov    %rdi,%r9
  804cbe:	49 89 f0             	mov    %rsi,%r8
  804cc1:	48 89 d1             	mov    %rdx,%rcx
  804cc4:	48 89 c2             	mov    %rax,%rdx
  804cc7:	be 00 00 00 00       	mov    $0x0,%esi
  804ccc:	bf 0f 00 00 00       	mov    $0xf,%edi
  804cd1:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804cd8:	00 00 00 
  804cdb:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  804cdd:	c9                   	leaveq 
  804cde:	c3                   	retq   

0000000000804cdf <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  804cdf:	55                   	push   %rbp
  804ce0:	48 89 e5             	mov    %rsp,%rbp
  804ce3:	48 83 ec 20          	sub    $0x20,%rsp
  804ce7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804ceb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  804cef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804cf3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cf7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804cfe:	00 
  804cff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d0b:	48 89 d1             	mov    %rdx,%rcx
  804d0e:	48 89 c2             	mov    %rax,%rdx
  804d11:	be 00 00 00 00       	mov    $0x0,%esi
  804d16:	bf 10 00 00 00       	mov    $0x10,%edi
  804d1b:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804d22:	00 00 00 
  804d25:	ff d0                	callq  *%rax
}
  804d27:	c9                   	leaveq 
  804d28:	c3                   	retq   

0000000000804d29 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  804d29:	55                   	push   %rbp
  804d2a:	48 89 e5             	mov    %rsp,%rbp
  804d2d:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  804d31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804d38:	00 
  804d39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d45:	b9 00 00 00 00       	mov    $0x0,%ecx
  804d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  804d4f:	be 00 00 00 00       	mov    $0x0,%esi
  804d54:	bf 11 00 00 00       	mov    $0x11,%edi
  804d59:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804d60:	00 00 00 
  804d63:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  804d65:	c9                   	leaveq 
  804d66:	c3                   	retq   

0000000000804d67 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  804d67:	55                   	push   %rbp
  804d68:	48 89 e5             	mov    %rsp,%rbp
  804d6b:	48 83 ec 10          	sub    $0x10,%rsp
  804d6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  804d72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d75:	48 98                	cltq   
  804d77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804d7e:	00 
  804d7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  804d90:	48 89 c2             	mov    %rax,%rdx
  804d93:	be 00 00 00 00       	mov    $0x0,%esi
  804d98:	bf 12 00 00 00       	mov    $0x12,%edi
  804d9d:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804da4:	00 00 00 
  804da7:	ff d0                	callq  *%rax
}
  804da9:	c9                   	leaveq 
  804daa:	c3                   	retq   

0000000000804dab <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  804dab:	55                   	push   %rbp
  804dac:	48 89 e5             	mov    %rsp,%rbp
  804daf:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  804db3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804dba:	00 
  804dbb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804dc1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804dc7:	b9 00 00 00 00       	mov    $0x0,%ecx
  804dcc:	ba 00 00 00 00       	mov    $0x0,%edx
  804dd1:	be 00 00 00 00       	mov    $0x0,%esi
  804dd6:	bf 13 00 00 00       	mov    $0x13,%edi
  804ddb:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804de2:	00 00 00 
  804de5:	ff d0                	callq  *%rax
}
  804de7:	c9                   	leaveq 
  804de8:	c3                   	retq   

0000000000804de9 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  804de9:	55                   	push   %rbp
  804dea:	48 89 e5             	mov    %rsp,%rbp
  804ded:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  804df1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804df8:	00 
  804df9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804dff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804e05:	b9 00 00 00 00       	mov    $0x0,%ecx
  804e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  804e0f:	be 00 00 00 00       	mov    $0x0,%esi
  804e14:	bf 14 00 00 00       	mov    $0x14,%edi
  804e19:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  804e20:	00 00 00 
  804e23:	ff d0                	callq  *%rax
}
  804e25:	c9                   	leaveq 
  804e26:	c3                   	retq   

0000000000804e27 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804e27:	55                   	push   %rbp
  804e28:	48 89 e5             	mov    %rsp,%rbp
  804e2b:	48 83 ec 10          	sub    $0x10,%rsp
  804e2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804e33:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  804e3a:	00 00 00 
  804e3d:	48 8b 00             	mov    (%rax),%rax
  804e40:	48 85 c0             	test   %rax,%rax
  804e43:	0f 85 84 00 00 00    	jne    804ecd <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804e49:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804e50:	00 00 00 
  804e53:	48 8b 00             	mov    (%rax),%rax
  804e56:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804e5c:	ba 07 00 00 00       	mov    $0x7,%edx
  804e61:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804e66:	89 c7                	mov    %eax,%edi
  804e68:	48 b8 d9 49 80 00 00 	movabs $0x8049d9,%rax
  804e6f:	00 00 00 
  804e72:	ff d0                	callq  *%rax
  804e74:	85 c0                	test   %eax,%eax
  804e76:	79 2a                	jns    804ea2 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804e78:	48 ba d8 79 80 00 00 	movabs $0x8079d8,%rdx
  804e7f:	00 00 00 
  804e82:	be 23 00 00 00       	mov    $0x23,%esi
  804e87:	48 bf ff 79 80 00 00 	movabs $0x8079ff,%rdi
  804e8e:	00 00 00 
  804e91:	b8 00 00 00 00       	mov    $0x0,%eax
  804e96:	48 b9 bc 32 80 00 00 	movabs $0x8032bc,%rcx
  804e9d:	00 00 00 
  804ea0:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804ea2:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804ea9:	00 00 00 
  804eac:	48 8b 00             	mov    (%rax),%rax
  804eaf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804eb5:	48 be e0 4e 80 00 00 	movabs $0x804ee0,%rsi
  804ebc:	00 00 00 
  804ebf:	89 c7                	mov    %eax,%edi
  804ec1:	48 b8 63 4b 80 00 00 	movabs $0x804b63,%rax
  804ec8:	00 00 00 
  804ecb:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804ecd:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  804ed4:	00 00 00 
  804ed7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804edb:	48 89 10             	mov    %rdx,(%rax)
}
  804ede:	c9                   	leaveq 
  804edf:	c3                   	retq   

0000000000804ee0 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804ee0:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804ee3:	48 a1 20 20 81 00 00 	movabs 0x812020,%rax
  804eea:	00 00 00 
call *%rax
  804eed:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  804eef:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804ef6:	00 
movq 152(%rsp), %rcx  //Load RSP
  804ef7:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804efe:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  804eff:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  804f03:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  804f06:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804f0d:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  804f0e:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  804f12:	4c 8b 3c 24          	mov    (%rsp),%r15
  804f16:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804f1b:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804f20:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804f25:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804f2a:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804f2f:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804f34:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804f39:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804f3e:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804f43:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804f48:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804f4d:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804f52:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804f57:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804f5c:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  804f60:	48 83 c4 08          	add    $0x8,%rsp
popfq
  804f64:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  804f65:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  804f66:	c3                   	retq   

0000000000804f67 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804f67:	55                   	push   %rbp
  804f68:	48 89 e5             	mov    %rsp,%rbp
  804f6b:	48 83 ec 30          	sub    $0x30,%rsp
  804f6f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804f73:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804f77:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804f7b:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804f82:	00 00 00 
  804f85:	48 8b 00             	mov    (%rax),%rax
  804f88:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804f8e:	85 c0                	test   %eax,%eax
  804f90:	75 34                	jne    804fc6 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  804f92:	48 b8 5d 49 80 00 00 	movabs $0x80495d,%rax
  804f99:	00 00 00 
  804f9c:	ff d0                	callq  *%rax
  804f9e:	25 ff 03 00 00       	and    $0x3ff,%eax
  804fa3:	48 98                	cltq   
  804fa5:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804fac:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804fb3:	00 00 00 
  804fb6:	48 01 c2             	add    %rax,%rdx
  804fb9:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804fc0:	00 00 00 
  804fc3:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804fc6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804fcb:	75 0e                	jne    804fdb <ipc_recv+0x74>
		pg = (void*) UTOP;
  804fcd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804fd4:	00 00 00 
  804fd7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804fdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804fdf:	48 89 c7             	mov    %rax,%rdi
  804fe2:	48 b8 02 4c 80 00 00 	movabs $0x804c02,%rax
  804fe9:	00 00 00 
  804fec:	ff d0                	callq  *%rax
  804fee:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804ff1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ff5:	79 19                	jns    805010 <ipc_recv+0xa9>
		*from_env_store = 0;
  804ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ffb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  805001:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805005:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80500b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80500e:	eb 53                	jmp    805063 <ipc_recv+0xfc>
	}
	if(from_env_store)
  805010:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805015:	74 19                	je     805030 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  805017:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  80501e:	00 00 00 
  805021:	48 8b 00             	mov    (%rax),%rax
  805024:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80502a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80502e:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  805030:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805035:	74 19                	je     805050 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  805037:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  80503e:	00 00 00 
  805041:	48 8b 00             	mov    (%rax),%rax
  805044:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80504a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80504e:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  805050:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805057:	00 00 00 
  80505a:	48 8b 00             	mov    (%rax),%rax
  80505d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  805063:	c9                   	leaveq 
  805064:	c3                   	retq   

0000000000805065 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805065:	55                   	push   %rbp
  805066:	48 89 e5             	mov    %rsp,%rbp
  805069:	48 83 ec 30          	sub    $0x30,%rsp
  80506d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805070:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805073:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805077:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80507a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80507f:	75 0e                	jne    80508f <ipc_send+0x2a>
		pg = (void*)UTOP;
  805081:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805088:	00 00 00 
  80508b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80508f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805092:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805095:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805099:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80509c:	89 c7                	mov    %eax,%edi
  80509e:	48 b8 ad 4b 80 00 00 	movabs $0x804bad,%rax
  8050a5:	00 00 00 
  8050a8:	ff d0                	callq  *%rax
  8050aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8050ad:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8050b1:	75 0c                	jne    8050bf <ipc_send+0x5a>
			sys_yield();
  8050b3:	48 b8 9b 49 80 00 00 	movabs $0x80499b,%rax
  8050ba:	00 00 00 
  8050bd:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8050bf:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8050c3:	74 ca                	je     80508f <ipc_send+0x2a>
	if(result != 0)
  8050c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8050c9:	74 20                	je     8050eb <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  8050cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050ce:	89 c6                	mov    %eax,%esi
  8050d0:	48 bf 0d 7a 80 00 00 	movabs $0x807a0d,%rdi
  8050d7:	00 00 00 
  8050da:	b8 00 00 00 00       	mov    $0x0,%eax
  8050df:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  8050e6:	00 00 00 
  8050e9:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  8050eb:	c9                   	leaveq 
  8050ec:	c3                   	retq   

00000000008050ed <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8050ed:	55                   	push   %rbp
  8050ee:	48 89 e5             	mov    %rsp,%rbp
  8050f1:	48 83 ec 14          	sub    $0x14,%rsp
  8050f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8050f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8050ff:	eb 4e                	jmp    80514f <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  805101:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805108:	00 00 00 
  80510b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80510e:	48 98                	cltq   
  805110:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805117:	48 01 d0             	add    %rdx,%rax
  80511a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805120:	8b 00                	mov    (%rax),%eax
  805122:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805125:	75 24                	jne    80514b <ipc_find_env+0x5e>
			return envs[i].env_id;
  805127:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80512e:	00 00 00 
  805131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805134:	48 98                	cltq   
  805136:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80513d:	48 01 d0             	add    %rdx,%rax
  805140:	48 05 c0 00 00 00    	add    $0xc0,%rax
  805146:	8b 40 08             	mov    0x8(%rax),%eax
  805149:	eb 12                	jmp    80515d <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80514b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80514f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805156:	7e a9                	jle    805101 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  805158:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80515d:	c9                   	leaveq 
  80515e:	c3                   	retq   

000000000080515f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80515f:	55                   	push   %rbp
  805160:	48 89 e5             	mov    %rsp,%rbp
  805163:	48 83 ec 08          	sub    $0x8,%rsp
  805167:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80516b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80516f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  805176:	ff ff ff 
  805179:	48 01 d0             	add    %rdx,%rax
  80517c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  805180:	c9                   	leaveq 
  805181:	c3                   	retq   

0000000000805182 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  805182:	55                   	push   %rbp
  805183:	48 89 e5             	mov    %rsp,%rbp
  805186:	48 83 ec 08          	sub    $0x8,%rsp
  80518a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80518e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805192:	48 89 c7             	mov    %rax,%rdi
  805195:	48 b8 5f 51 80 00 00 	movabs $0x80515f,%rax
  80519c:	00 00 00 
  80519f:	ff d0                	callq  *%rax
  8051a1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8051a7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8051ab:	c9                   	leaveq 
  8051ac:	c3                   	retq   

00000000008051ad <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8051ad:	55                   	push   %rbp
  8051ae:	48 89 e5             	mov    %rsp,%rbp
  8051b1:	48 83 ec 18          	sub    $0x18,%rsp
  8051b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8051b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8051c0:	eb 6b                	jmp    80522d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8051c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051c5:	48 98                	cltq   
  8051c7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8051cd:	48 c1 e0 0c          	shl    $0xc,%rax
  8051d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8051d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051d9:	48 c1 e8 15          	shr    $0x15,%rax
  8051dd:	48 89 c2             	mov    %rax,%rdx
  8051e0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8051e7:	01 00 00 
  8051ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8051ee:	83 e0 01             	and    $0x1,%eax
  8051f1:	48 85 c0             	test   %rax,%rax
  8051f4:	74 21                	je     805217 <fd_alloc+0x6a>
  8051f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051fa:	48 c1 e8 0c          	shr    $0xc,%rax
  8051fe:	48 89 c2             	mov    %rax,%rdx
  805201:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805208:	01 00 00 
  80520b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80520f:	83 e0 01             	and    $0x1,%eax
  805212:	48 85 c0             	test   %rax,%rax
  805215:	75 12                	jne    805229 <fd_alloc+0x7c>
			*fd_store = fd;
  805217:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80521b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80521f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  805222:	b8 00 00 00 00       	mov    $0x0,%eax
  805227:	eb 1a                	jmp    805243 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  805229:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80522d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  805231:	7e 8f                	jle    8051c2 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  805233:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805237:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80523e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  805243:	c9                   	leaveq 
  805244:	c3                   	retq   

0000000000805245 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  805245:	55                   	push   %rbp
  805246:	48 89 e5             	mov    %rsp,%rbp
  805249:	48 83 ec 20          	sub    $0x20,%rsp
  80524d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805250:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  805254:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805258:	78 06                	js     805260 <fd_lookup+0x1b>
  80525a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80525e:	7e 07                	jle    805267 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  805260:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805265:	eb 6c                	jmp    8052d3 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  805267:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80526a:	48 98                	cltq   
  80526c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  805272:	48 c1 e0 0c          	shl    $0xc,%rax
  805276:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80527a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80527e:	48 c1 e8 15          	shr    $0x15,%rax
  805282:	48 89 c2             	mov    %rax,%rdx
  805285:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80528c:	01 00 00 
  80528f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805293:	83 e0 01             	and    $0x1,%eax
  805296:	48 85 c0             	test   %rax,%rax
  805299:	74 21                	je     8052bc <fd_lookup+0x77>
  80529b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80529f:	48 c1 e8 0c          	shr    $0xc,%rax
  8052a3:	48 89 c2             	mov    %rax,%rdx
  8052a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8052ad:	01 00 00 
  8052b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8052b4:	83 e0 01             	and    $0x1,%eax
  8052b7:	48 85 c0             	test   %rax,%rax
  8052ba:	75 07                	jne    8052c3 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8052bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8052c1:	eb 10                	jmp    8052d3 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8052c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052c7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8052cb:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8052ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8052d3:	c9                   	leaveq 
  8052d4:	c3                   	retq   

00000000008052d5 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8052d5:	55                   	push   %rbp
  8052d6:	48 89 e5             	mov    %rsp,%rbp
  8052d9:	48 83 ec 30          	sub    $0x30,%rsp
  8052dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8052e1:	89 f0                	mov    %esi,%eax
  8052e3:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8052e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052ea:	48 89 c7             	mov    %rax,%rdi
  8052ed:	48 b8 5f 51 80 00 00 	movabs $0x80515f,%rax
  8052f4:	00 00 00 
  8052f7:	ff d0                	callq  *%rax
  8052f9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8052fd:	48 89 d6             	mov    %rdx,%rsi
  805300:	89 c7                	mov    %eax,%edi
  805302:	48 b8 45 52 80 00 00 	movabs $0x805245,%rax
  805309:	00 00 00 
  80530c:	ff d0                	callq  *%rax
  80530e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805311:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805315:	78 0a                	js     805321 <fd_close+0x4c>
	    || fd != fd2)
  805317:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80531b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80531f:	74 12                	je     805333 <fd_close+0x5e>
		return (must_exist ? r : 0);
  805321:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  805325:	74 05                	je     80532c <fd_close+0x57>
  805327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80532a:	eb 05                	jmp    805331 <fd_close+0x5c>
  80532c:	b8 00 00 00 00       	mov    $0x0,%eax
  805331:	eb 69                	jmp    80539c <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  805333:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805337:	8b 00                	mov    (%rax),%eax
  805339:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80533d:	48 89 d6             	mov    %rdx,%rsi
  805340:	89 c7                	mov    %eax,%edi
  805342:	48 b8 9e 53 80 00 00 	movabs $0x80539e,%rax
  805349:	00 00 00 
  80534c:	ff d0                	callq  *%rax
  80534e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805351:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805355:	78 2a                	js     805381 <fd_close+0xac>
		if (dev->dev_close)
  805357:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80535b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80535f:	48 85 c0             	test   %rax,%rax
  805362:	74 16                	je     80537a <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  805364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805368:	48 8b 40 20          	mov    0x20(%rax),%rax
  80536c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805370:	48 89 d7             	mov    %rdx,%rdi
  805373:	ff d0                	callq  *%rax
  805375:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805378:	eb 07                	jmp    805381 <fd_close+0xac>
		else
			r = 0;
  80537a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  805381:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805385:	48 89 c6             	mov    %rax,%rsi
  805388:	bf 00 00 00 00       	mov    $0x0,%edi
  80538d:	48 b8 84 4a 80 00 00 	movabs $0x804a84,%rax
  805394:	00 00 00 
  805397:	ff d0                	callq  *%rax
	return r;
  805399:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80539c:	c9                   	leaveq 
  80539d:	c3                   	retq   

000000000080539e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80539e:	55                   	push   %rbp
  80539f:	48 89 e5             	mov    %rsp,%rbp
  8053a2:	48 83 ec 20          	sub    $0x20,%rsp
  8053a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8053a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8053ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8053b4:	eb 41                	jmp    8053f7 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8053b6:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  8053bd:	00 00 00 
  8053c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8053c3:	48 63 d2             	movslq %edx,%rdx
  8053c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8053ca:	8b 00                	mov    (%rax),%eax
  8053cc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8053cf:	75 22                	jne    8053f3 <dev_lookup+0x55>
			*dev = devtab[i];
  8053d1:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  8053d8:	00 00 00 
  8053db:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8053de:	48 63 d2             	movslq %edx,%rdx
  8053e1:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8053e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8053e9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8053ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8053f1:	eb 60                	jmp    805453 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8053f3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8053f7:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  8053fe:	00 00 00 
  805401:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805404:	48 63 d2             	movslq %edx,%rdx
  805407:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80540b:	48 85 c0             	test   %rax,%rax
  80540e:	75 a6                	jne    8053b6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  805410:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805417:	00 00 00 
  80541a:	48 8b 00             	mov    (%rax),%rax
  80541d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805423:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805426:	89 c6                	mov    %eax,%esi
  805428:	48 bf 28 7a 80 00 00 	movabs $0x807a28,%rdi
  80542f:	00 00 00 
  805432:	b8 00 00 00 00       	mov    $0x0,%eax
  805437:	48 b9 f5 34 80 00 00 	movabs $0x8034f5,%rcx
  80543e:	00 00 00 
  805441:	ff d1                	callq  *%rcx
	*dev = 0;
  805443:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805447:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80544e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  805453:	c9                   	leaveq 
  805454:	c3                   	retq   

0000000000805455 <close>:

int
close(int fdnum)
{
  805455:	55                   	push   %rbp
  805456:	48 89 e5             	mov    %rsp,%rbp
  805459:	48 83 ec 20          	sub    $0x20,%rsp
  80545d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805460:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805464:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805467:	48 89 d6             	mov    %rdx,%rsi
  80546a:	89 c7                	mov    %eax,%edi
  80546c:	48 b8 45 52 80 00 00 	movabs $0x805245,%rax
  805473:	00 00 00 
  805476:	ff d0                	callq  *%rax
  805478:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80547b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80547f:	79 05                	jns    805486 <close+0x31>
		return r;
  805481:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805484:	eb 18                	jmp    80549e <close+0x49>
	else
		return fd_close(fd, 1);
  805486:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80548a:	be 01 00 00 00       	mov    $0x1,%esi
  80548f:	48 89 c7             	mov    %rax,%rdi
  805492:	48 b8 d5 52 80 00 00 	movabs $0x8052d5,%rax
  805499:	00 00 00 
  80549c:	ff d0                	callq  *%rax
}
  80549e:	c9                   	leaveq 
  80549f:	c3                   	retq   

00000000008054a0 <close_all>:

void
close_all(void)
{
  8054a0:	55                   	push   %rbp
  8054a1:	48 89 e5             	mov    %rsp,%rbp
  8054a4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8054a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8054af:	eb 15                	jmp    8054c6 <close_all+0x26>
		close(i);
  8054b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054b4:	89 c7                	mov    %eax,%edi
  8054b6:	48 b8 55 54 80 00 00 	movabs $0x805455,%rax
  8054bd:	00 00 00 
  8054c0:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8054c2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8054c6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8054ca:	7e e5                	jle    8054b1 <close_all+0x11>
		close(i);
}
  8054cc:	c9                   	leaveq 
  8054cd:	c3                   	retq   

00000000008054ce <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8054ce:	55                   	push   %rbp
  8054cf:	48 89 e5             	mov    %rsp,%rbp
  8054d2:	48 83 ec 40          	sub    $0x40,%rsp
  8054d6:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8054d9:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8054dc:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8054e0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8054e3:	48 89 d6             	mov    %rdx,%rsi
  8054e6:	89 c7                	mov    %eax,%edi
  8054e8:	48 b8 45 52 80 00 00 	movabs $0x805245,%rax
  8054ef:	00 00 00 
  8054f2:	ff d0                	callq  *%rax
  8054f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054fb:	79 08                	jns    805505 <dup+0x37>
		return r;
  8054fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805500:	e9 70 01 00 00       	jmpq   805675 <dup+0x1a7>
	close(newfdnum);
  805505:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805508:	89 c7                	mov    %eax,%edi
  80550a:	48 b8 55 54 80 00 00 	movabs $0x805455,%rax
  805511:	00 00 00 
  805514:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  805516:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805519:	48 98                	cltq   
  80551b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  805521:	48 c1 e0 0c          	shl    $0xc,%rax
  805525:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  805529:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80552d:	48 89 c7             	mov    %rax,%rdi
  805530:	48 b8 82 51 80 00 00 	movabs $0x805182,%rax
  805537:	00 00 00 
  80553a:	ff d0                	callq  *%rax
  80553c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  805540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805544:	48 89 c7             	mov    %rax,%rdi
  805547:	48 b8 82 51 80 00 00 	movabs $0x805182,%rax
  80554e:	00 00 00 
  805551:	ff d0                	callq  *%rax
  805553:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  805557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80555b:	48 c1 e8 15          	shr    $0x15,%rax
  80555f:	48 89 c2             	mov    %rax,%rdx
  805562:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805569:	01 00 00 
  80556c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805570:	83 e0 01             	and    $0x1,%eax
  805573:	48 85 c0             	test   %rax,%rax
  805576:	74 73                	je     8055eb <dup+0x11d>
  805578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80557c:	48 c1 e8 0c          	shr    $0xc,%rax
  805580:	48 89 c2             	mov    %rax,%rdx
  805583:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80558a:	01 00 00 
  80558d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805591:	83 e0 01             	and    $0x1,%eax
  805594:	48 85 c0             	test   %rax,%rax
  805597:	74 52                	je     8055eb <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  805599:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80559d:	48 c1 e8 0c          	shr    $0xc,%rax
  8055a1:	48 89 c2             	mov    %rax,%rdx
  8055a4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8055ab:	01 00 00 
  8055ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8055b7:	89 c1                	mov    %eax,%ecx
  8055b9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8055bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055c1:	41 89 c8             	mov    %ecx,%r8d
  8055c4:	48 89 d1             	mov    %rdx,%rcx
  8055c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8055cc:	48 89 c6             	mov    %rax,%rsi
  8055cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8055d4:	48 b8 29 4a 80 00 00 	movabs $0x804a29,%rax
  8055db:	00 00 00 
  8055de:	ff d0                	callq  *%rax
  8055e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8055e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8055e7:	79 02                	jns    8055eb <dup+0x11d>
			goto err;
  8055e9:	eb 57                	jmp    805642 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8055eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8055ef:	48 c1 e8 0c          	shr    $0xc,%rax
  8055f3:	48 89 c2             	mov    %rax,%rdx
  8055f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8055fd:	01 00 00 
  805600:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805604:	25 07 0e 00 00       	and    $0xe07,%eax
  805609:	89 c1                	mov    %eax,%ecx
  80560b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80560f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805613:	41 89 c8             	mov    %ecx,%r8d
  805616:	48 89 d1             	mov    %rdx,%rcx
  805619:	ba 00 00 00 00       	mov    $0x0,%edx
  80561e:	48 89 c6             	mov    %rax,%rsi
  805621:	bf 00 00 00 00       	mov    $0x0,%edi
  805626:	48 b8 29 4a 80 00 00 	movabs $0x804a29,%rax
  80562d:	00 00 00 
  805630:	ff d0                	callq  *%rax
  805632:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805635:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805639:	79 02                	jns    80563d <dup+0x16f>
		goto err;
  80563b:	eb 05                	jmp    805642 <dup+0x174>

	return newfdnum;
  80563d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805640:	eb 33                	jmp    805675 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  805642:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805646:	48 89 c6             	mov    %rax,%rsi
  805649:	bf 00 00 00 00       	mov    $0x0,%edi
  80564e:	48 b8 84 4a 80 00 00 	movabs $0x804a84,%rax
  805655:	00 00 00 
  805658:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80565a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80565e:	48 89 c6             	mov    %rax,%rsi
  805661:	bf 00 00 00 00       	mov    $0x0,%edi
  805666:	48 b8 84 4a 80 00 00 	movabs $0x804a84,%rax
  80566d:	00 00 00 
  805670:	ff d0                	callq  *%rax
	return r;
  805672:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805675:	c9                   	leaveq 
  805676:	c3                   	retq   

0000000000805677 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  805677:	55                   	push   %rbp
  805678:	48 89 e5             	mov    %rsp,%rbp
  80567b:	48 83 ec 40          	sub    $0x40,%rsp
  80567f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805682:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805686:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80568a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80568e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805691:	48 89 d6             	mov    %rdx,%rsi
  805694:	89 c7                	mov    %eax,%edi
  805696:	48 b8 45 52 80 00 00 	movabs $0x805245,%rax
  80569d:	00 00 00 
  8056a0:	ff d0                	callq  *%rax
  8056a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056a9:	78 24                	js     8056cf <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8056ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056af:	8b 00                	mov    (%rax),%eax
  8056b1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8056b5:	48 89 d6             	mov    %rdx,%rsi
  8056b8:	89 c7                	mov    %eax,%edi
  8056ba:	48 b8 9e 53 80 00 00 	movabs $0x80539e,%rax
  8056c1:	00 00 00 
  8056c4:	ff d0                	callq  *%rax
  8056c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056cd:	79 05                	jns    8056d4 <read+0x5d>
		return r;
  8056cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056d2:	eb 76                	jmp    80574a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8056d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056d8:	8b 40 08             	mov    0x8(%rax),%eax
  8056db:	83 e0 03             	and    $0x3,%eax
  8056de:	83 f8 01             	cmp    $0x1,%eax
  8056e1:	75 3a                	jne    80571d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8056e3:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8056ea:	00 00 00 
  8056ed:	48 8b 00             	mov    (%rax),%rax
  8056f0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8056f6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8056f9:	89 c6                	mov    %eax,%esi
  8056fb:	48 bf 47 7a 80 00 00 	movabs $0x807a47,%rdi
  805702:	00 00 00 
  805705:	b8 00 00 00 00       	mov    $0x0,%eax
  80570a:	48 b9 f5 34 80 00 00 	movabs $0x8034f5,%rcx
  805711:	00 00 00 
  805714:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805716:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80571b:	eb 2d                	jmp    80574a <read+0xd3>
	}
	if (!dev->dev_read)
  80571d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805721:	48 8b 40 10          	mov    0x10(%rax),%rax
  805725:	48 85 c0             	test   %rax,%rax
  805728:	75 07                	jne    805731 <read+0xba>
		return -E_NOT_SUPP;
  80572a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80572f:	eb 19                	jmp    80574a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  805731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805735:	48 8b 40 10          	mov    0x10(%rax),%rax
  805739:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80573d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805741:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805745:	48 89 cf             	mov    %rcx,%rdi
  805748:	ff d0                	callq  *%rax
}
  80574a:	c9                   	leaveq 
  80574b:	c3                   	retq   

000000000080574c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80574c:	55                   	push   %rbp
  80574d:	48 89 e5             	mov    %rsp,%rbp
  805750:	48 83 ec 30          	sub    $0x30,%rsp
  805754:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805757:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80575b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80575f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805766:	eb 49                	jmp    8057b1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  805768:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80576b:	48 98                	cltq   
  80576d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805771:	48 29 c2             	sub    %rax,%rdx
  805774:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805777:	48 63 c8             	movslq %eax,%rcx
  80577a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80577e:	48 01 c1             	add    %rax,%rcx
  805781:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805784:	48 89 ce             	mov    %rcx,%rsi
  805787:	89 c7                	mov    %eax,%edi
  805789:	48 b8 77 56 80 00 00 	movabs $0x805677,%rax
  805790:	00 00 00 
  805793:	ff d0                	callq  *%rax
  805795:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  805798:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80579c:	79 05                	jns    8057a3 <readn+0x57>
			return m;
  80579e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8057a1:	eb 1c                	jmp    8057bf <readn+0x73>
		if (m == 0)
  8057a3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8057a7:	75 02                	jne    8057ab <readn+0x5f>
			break;
  8057a9:	eb 11                	jmp    8057bc <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8057ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8057ae:	01 45 fc             	add    %eax,-0x4(%rbp)
  8057b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057b4:	48 98                	cltq   
  8057b6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8057ba:	72 ac                	jb     805768 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8057bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8057bf:	c9                   	leaveq 
  8057c0:	c3                   	retq   

00000000008057c1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8057c1:	55                   	push   %rbp
  8057c2:	48 89 e5             	mov    %rsp,%rbp
  8057c5:	48 83 ec 40          	sub    $0x40,%rsp
  8057c9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8057cc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8057d0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8057d4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8057d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8057db:	48 89 d6             	mov    %rdx,%rsi
  8057de:	89 c7                	mov    %eax,%edi
  8057e0:	48 b8 45 52 80 00 00 	movabs $0x805245,%rax
  8057e7:	00 00 00 
  8057ea:	ff d0                	callq  *%rax
  8057ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057f3:	78 24                	js     805819 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8057f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8057f9:	8b 00                	mov    (%rax),%eax
  8057fb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8057ff:	48 89 d6             	mov    %rdx,%rsi
  805802:	89 c7                	mov    %eax,%edi
  805804:	48 b8 9e 53 80 00 00 	movabs $0x80539e,%rax
  80580b:	00 00 00 
  80580e:	ff d0                	callq  *%rax
  805810:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805813:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805817:	79 05                	jns    80581e <write+0x5d>
		return r;
  805819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80581c:	eb 42                	jmp    805860 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80581e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805822:	8b 40 08             	mov    0x8(%rax),%eax
  805825:	83 e0 03             	and    $0x3,%eax
  805828:	85 c0                	test   %eax,%eax
  80582a:	75 07                	jne    805833 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80582c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805831:	eb 2d                	jmp    805860 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  805833:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805837:	48 8b 40 18          	mov    0x18(%rax),%rax
  80583b:	48 85 c0             	test   %rax,%rax
  80583e:	75 07                	jne    805847 <write+0x86>
		return -E_NOT_SUPP;
  805840:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805845:	eb 19                	jmp    805860 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  805847:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80584b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80584f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805853:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805857:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80585b:	48 89 cf             	mov    %rcx,%rdi
  80585e:	ff d0                	callq  *%rax
}
  805860:	c9                   	leaveq 
  805861:	c3                   	retq   

0000000000805862 <seek>:

int
seek(int fdnum, off_t offset)
{
  805862:	55                   	push   %rbp
  805863:	48 89 e5             	mov    %rsp,%rbp
  805866:	48 83 ec 18          	sub    $0x18,%rsp
  80586a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80586d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805870:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805874:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805877:	48 89 d6             	mov    %rdx,%rsi
  80587a:	89 c7                	mov    %eax,%edi
  80587c:	48 b8 45 52 80 00 00 	movabs $0x805245,%rax
  805883:	00 00 00 
  805886:	ff d0                	callq  *%rax
  805888:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80588b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80588f:	79 05                	jns    805896 <seek+0x34>
		return r;
  805891:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805894:	eb 0f                	jmp    8058a5 <seek+0x43>
	fd->fd_offset = offset;
  805896:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80589a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80589d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8058a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8058a5:	c9                   	leaveq 
  8058a6:	c3                   	retq   

00000000008058a7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8058a7:	55                   	push   %rbp
  8058a8:	48 89 e5             	mov    %rsp,%rbp
  8058ab:	48 83 ec 30          	sub    $0x30,%rsp
  8058af:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8058b2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8058b5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8058b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8058bc:	48 89 d6             	mov    %rdx,%rsi
  8058bf:	89 c7                	mov    %eax,%edi
  8058c1:	48 b8 45 52 80 00 00 	movabs $0x805245,%rax
  8058c8:	00 00 00 
  8058cb:	ff d0                	callq  *%rax
  8058cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058d4:	78 24                	js     8058fa <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8058d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058da:	8b 00                	mov    (%rax),%eax
  8058dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8058e0:	48 89 d6             	mov    %rdx,%rsi
  8058e3:	89 c7                	mov    %eax,%edi
  8058e5:	48 b8 9e 53 80 00 00 	movabs $0x80539e,%rax
  8058ec:	00 00 00 
  8058ef:	ff d0                	callq  *%rax
  8058f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058f8:	79 05                	jns    8058ff <ftruncate+0x58>
		return r;
  8058fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058fd:	eb 72                	jmp    805971 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8058ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805903:	8b 40 08             	mov    0x8(%rax),%eax
  805906:	83 e0 03             	and    $0x3,%eax
  805909:	85 c0                	test   %eax,%eax
  80590b:	75 3a                	jne    805947 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80590d:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805914:	00 00 00 
  805917:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80591a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805920:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805923:	89 c6                	mov    %eax,%esi
  805925:	48 bf 68 7a 80 00 00 	movabs $0x807a68,%rdi
  80592c:	00 00 00 
  80592f:	b8 00 00 00 00       	mov    $0x0,%eax
  805934:	48 b9 f5 34 80 00 00 	movabs $0x8034f5,%rcx
  80593b:	00 00 00 
  80593e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  805940:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805945:	eb 2a                	jmp    805971 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  805947:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80594b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80594f:	48 85 c0             	test   %rax,%rax
  805952:	75 07                	jne    80595b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  805954:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805959:	eb 16                	jmp    805971 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80595b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80595f:	48 8b 40 30          	mov    0x30(%rax),%rax
  805963:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805967:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80596a:	89 ce                	mov    %ecx,%esi
  80596c:	48 89 d7             	mov    %rdx,%rdi
  80596f:	ff d0                	callq  *%rax
}
  805971:	c9                   	leaveq 
  805972:	c3                   	retq   

0000000000805973 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  805973:	55                   	push   %rbp
  805974:	48 89 e5             	mov    %rsp,%rbp
  805977:	48 83 ec 30          	sub    $0x30,%rsp
  80597b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80597e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805982:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805986:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805989:	48 89 d6             	mov    %rdx,%rsi
  80598c:	89 c7                	mov    %eax,%edi
  80598e:	48 b8 45 52 80 00 00 	movabs $0x805245,%rax
  805995:	00 00 00 
  805998:	ff d0                	callq  *%rax
  80599a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80599d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059a1:	78 24                	js     8059c7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8059a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8059a7:	8b 00                	mov    (%rax),%eax
  8059a9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8059ad:	48 89 d6             	mov    %rdx,%rsi
  8059b0:	89 c7                	mov    %eax,%edi
  8059b2:	48 b8 9e 53 80 00 00 	movabs $0x80539e,%rax
  8059b9:	00 00 00 
  8059bc:	ff d0                	callq  *%rax
  8059be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059c5:	79 05                	jns    8059cc <fstat+0x59>
		return r;
  8059c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059ca:	eb 5e                	jmp    805a2a <fstat+0xb7>
	if (!dev->dev_stat)
  8059cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8059d0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8059d4:	48 85 c0             	test   %rax,%rax
  8059d7:	75 07                	jne    8059e0 <fstat+0x6d>
		return -E_NOT_SUPP;
  8059d9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8059de:	eb 4a                	jmp    805a2a <fstat+0xb7>
	stat->st_name[0] = 0;
  8059e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8059e4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8059e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8059eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8059f2:	00 00 00 
	stat->st_isdir = 0;
  8059f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8059f9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805a00:	00 00 00 
	stat->st_dev = dev;
  805a03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805a07:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805a0b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  805a12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a16:	48 8b 40 28          	mov    0x28(%rax),%rax
  805a1a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805a1e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  805a22:	48 89 ce             	mov    %rcx,%rsi
  805a25:	48 89 d7             	mov    %rdx,%rdi
  805a28:	ff d0                	callq  *%rax
}
  805a2a:	c9                   	leaveq 
  805a2b:	c3                   	retq   

0000000000805a2c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  805a2c:	55                   	push   %rbp
  805a2d:	48 89 e5             	mov    %rsp,%rbp
  805a30:	48 83 ec 20          	sub    $0x20,%rsp
  805a34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805a38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  805a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a40:	be 00 00 00 00       	mov    $0x0,%esi
  805a45:	48 89 c7             	mov    %rax,%rdi
  805a48:	48 b8 1a 5b 80 00 00 	movabs $0x805b1a,%rax
  805a4f:	00 00 00 
  805a52:	ff d0                	callq  *%rax
  805a54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a5b:	79 05                	jns    805a62 <stat+0x36>
		return fd;
  805a5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a60:	eb 2f                	jmp    805a91 <stat+0x65>
	r = fstat(fd, stat);
  805a62:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805a66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a69:	48 89 d6             	mov    %rdx,%rsi
  805a6c:	89 c7                	mov    %eax,%edi
  805a6e:	48 b8 73 59 80 00 00 	movabs $0x805973,%rax
  805a75:	00 00 00 
  805a78:	ff d0                	callq  *%rax
  805a7a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  805a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a80:	89 c7                	mov    %eax,%edi
  805a82:	48 b8 55 54 80 00 00 	movabs $0x805455,%rax
  805a89:	00 00 00 
  805a8c:	ff d0                	callq  *%rax
	return r;
  805a8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  805a91:	c9                   	leaveq 
  805a92:	c3                   	retq   

0000000000805a93 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  805a93:	55                   	push   %rbp
  805a94:	48 89 e5             	mov    %rsp,%rbp
  805a97:	48 83 ec 10          	sub    $0x10,%rsp
  805a9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805a9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  805aa2:	48 b8 04 20 81 00 00 	movabs $0x812004,%rax
  805aa9:	00 00 00 
  805aac:	8b 00                	mov    (%rax),%eax
  805aae:	85 c0                	test   %eax,%eax
  805ab0:	75 1d                	jne    805acf <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  805ab2:	bf 01 00 00 00       	mov    $0x1,%edi
  805ab7:	48 b8 ed 50 80 00 00 	movabs $0x8050ed,%rax
  805abe:	00 00 00 
  805ac1:	ff d0                	callq  *%rax
  805ac3:	48 ba 04 20 81 00 00 	movabs $0x812004,%rdx
  805aca:	00 00 00 
  805acd:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  805acf:	48 b8 04 20 81 00 00 	movabs $0x812004,%rax
  805ad6:	00 00 00 
  805ad9:	8b 00                	mov    (%rax),%eax
  805adb:	8b 75 fc             	mov    -0x4(%rbp),%esi
  805ade:	b9 07 00 00 00       	mov    $0x7,%ecx
  805ae3:	48 ba 00 30 81 00 00 	movabs $0x813000,%rdx
  805aea:	00 00 00 
  805aed:	89 c7                	mov    %eax,%edi
  805aef:	48 b8 65 50 80 00 00 	movabs $0x805065,%rax
  805af6:	00 00 00 
  805af9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  805afb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805aff:	ba 00 00 00 00       	mov    $0x0,%edx
  805b04:	48 89 c6             	mov    %rax,%rsi
  805b07:	bf 00 00 00 00       	mov    $0x0,%edi
  805b0c:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  805b13:	00 00 00 
  805b16:	ff d0                	callq  *%rax
}
  805b18:	c9                   	leaveq 
  805b19:	c3                   	retq   

0000000000805b1a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  805b1a:	55                   	push   %rbp
  805b1b:	48 89 e5             	mov    %rsp,%rbp
  805b1e:	48 83 ec 30          	sub    $0x30,%rsp
  805b22:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805b26:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  805b29:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  805b30:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  805b37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  805b3e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805b43:	75 08                	jne    805b4d <open+0x33>
	{
		return r;
  805b45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b48:	e9 f2 00 00 00       	jmpq   805c3f <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  805b4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805b51:	48 89 c7             	mov    %rax,%rdi
  805b54:	48 b8 3e 40 80 00 00 	movabs $0x80403e,%rax
  805b5b:	00 00 00 
  805b5e:	ff d0                	callq  *%rax
  805b60:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805b63:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  805b6a:	7e 0a                	jle    805b76 <open+0x5c>
	{
		return -E_BAD_PATH;
  805b6c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805b71:	e9 c9 00 00 00       	jmpq   805c3f <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  805b76:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  805b7d:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  805b7e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  805b82:	48 89 c7             	mov    %rax,%rdi
  805b85:	48 b8 ad 51 80 00 00 	movabs $0x8051ad,%rax
  805b8c:	00 00 00 
  805b8f:	ff d0                	callq  *%rax
  805b91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b98:	78 09                	js     805ba3 <open+0x89>
  805b9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b9e:	48 85 c0             	test   %rax,%rax
  805ba1:	75 08                	jne    805bab <open+0x91>
		{
			return r;
  805ba3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ba6:	e9 94 00 00 00       	jmpq   805c3f <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  805bab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805baf:	ba 00 04 00 00       	mov    $0x400,%edx
  805bb4:	48 89 c6             	mov    %rax,%rsi
  805bb7:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  805bbe:	00 00 00 
  805bc1:	48 b8 3c 41 80 00 00 	movabs $0x80413c,%rax
  805bc8:	00 00 00 
  805bcb:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  805bcd:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805bd4:	00 00 00 
  805bd7:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  805bda:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  805be0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805be4:	48 89 c6             	mov    %rax,%rsi
  805be7:	bf 01 00 00 00       	mov    $0x1,%edi
  805bec:	48 b8 93 5a 80 00 00 	movabs $0x805a93,%rax
  805bf3:	00 00 00 
  805bf6:	ff d0                	callq  *%rax
  805bf8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805bfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805bff:	79 2b                	jns    805c2c <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  805c01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c05:	be 00 00 00 00       	mov    $0x0,%esi
  805c0a:	48 89 c7             	mov    %rax,%rdi
  805c0d:	48 b8 d5 52 80 00 00 	movabs $0x8052d5,%rax
  805c14:	00 00 00 
  805c17:	ff d0                	callq  *%rax
  805c19:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805c1c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805c20:	79 05                	jns    805c27 <open+0x10d>
			{
				return d;
  805c22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805c25:	eb 18                	jmp    805c3f <open+0x125>
			}
			return r;
  805c27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c2a:	eb 13                	jmp    805c3f <open+0x125>
		}	
		return fd2num(fd_store);
  805c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c30:	48 89 c7             	mov    %rax,%rdi
  805c33:	48 b8 5f 51 80 00 00 	movabs $0x80515f,%rax
  805c3a:	00 00 00 
  805c3d:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  805c3f:	c9                   	leaveq 
  805c40:	c3                   	retq   

0000000000805c41 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  805c41:	55                   	push   %rbp
  805c42:	48 89 e5             	mov    %rsp,%rbp
  805c45:	48 83 ec 10          	sub    $0x10,%rsp
  805c49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  805c4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805c51:	8b 50 0c             	mov    0xc(%rax),%edx
  805c54:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805c5b:	00 00 00 
  805c5e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  805c60:	be 00 00 00 00       	mov    $0x0,%esi
  805c65:	bf 06 00 00 00       	mov    $0x6,%edi
  805c6a:	48 b8 93 5a 80 00 00 	movabs $0x805a93,%rax
  805c71:	00 00 00 
  805c74:	ff d0                	callq  *%rax
}
  805c76:	c9                   	leaveq 
  805c77:	c3                   	retq   

0000000000805c78 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  805c78:	55                   	push   %rbp
  805c79:	48 89 e5             	mov    %rsp,%rbp
  805c7c:	48 83 ec 30          	sub    $0x30,%rsp
  805c80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805c84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805c88:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  805c8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  805c93:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805c98:	74 07                	je     805ca1 <devfile_read+0x29>
  805c9a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805c9f:	75 07                	jne    805ca8 <devfile_read+0x30>
		return -E_INVAL;
  805ca1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805ca6:	eb 77                	jmp    805d1f <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  805ca8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805cac:	8b 50 0c             	mov    0xc(%rax),%edx
  805caf:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805cb6:	00 00 00 
  805cb9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  805cbb:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805cc2:	00 00 00 
  805cc5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805cc9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  805ccd:	be 00 00 00 00       	mov    $0x0,%esi
  805cd2:	bf 03 00 00 00       	mov    $0x3,%edi
  805cd7:	48 b8 93 5a 80 00 00 	movabs $0x805a93,%rax
  805cde:	00 00 00 
  805ce1:	ff d0                	callq  *%rax
  805ce3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805ce6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805cea:	7f 05                	jg     805cf1 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  805cec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805cef:	eb 2e                	jmp    805d1f <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  805cf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805cf4:	48 63 d0             	movslq %eax,%rdx
  805cf7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805cfb:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  805d02:	00 00 00 
  805d05:	48 89 c7             	mov    %rax,%rdi
  805d08:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  805d0f:	00 00 00 
  805d12:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  805d14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805d18:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  805d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  805d1f:	c9                   	leaveq 
  805d20:	c3                   	retq   

0000000000805d21 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  805d21:	55                   	push   %rbp
  805d22:	48 89 e5             	mov    %rsp,%rbp
  805d25:	48 83 ec 30          	sub    $0x30,%rsp
  805d29:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805d2d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805d31:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  805d35:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  805d3c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805d41:	74 07                	je     805d4a <devfile_write+0x29>
  805d43:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805d48:	75 08                	jne    805d52 <devfile_write+0x31>
		return r;
  805d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d4d:	e9 9a 00 00 00       	jmpq   805dec <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  805d52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d56:	8b 50 0c             	mov    0xc(%rax),%edx
  805d59:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805d60:	00 00 00 
  805d63:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  805d65:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  805d6c:	00 
  805d6d:	76 08                	jbe    805d77 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  805d6f:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  805d76:	00 
	}
	fsipcbuf.write.req_n = n;
  805d77:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805d7e:	00 00 00 
  805d81:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805d85:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  805d89:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805d8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805d91:	48 89 c6             	mov    %rax,%rsi
  805d94:	48 bf 10 30 81 00 00 	movabs $0x813010,%rdi
  805d9b:	00 00 00 
  805d9e:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  805da5:	00 00 00 
  805da8:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  805daa:	be 00 00 00 00       	mov    $0x0,%esi
  805daf:	bf 04 00 00 00       	mov    $0x4,%edi
  805db4:	48 b8 93 5a 80 00 00 	movabs $0x805a93,%rax
  805dbb:	00 00 00 
  805dbe:	ff d0                	callq  *%rax
  805dc0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805dc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805dc7:	7f 20                	jg     805de9 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  805dc9:	48 bf 8e 7a 80 00 00 	movabs $0x807a8e,%rdi
  805dd0:	00 00 00 
  805dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  805dd8:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  805ddf:	00 00 00 
  805de2:	ff d2                	callq  *%rdx
		return r;
  805de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805de7:	eb 03                	jmp    805dec <devfile_write+0xcb>
	}
	return r;
  805de9:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  805dec:	c9                   	leaveq 
  805ded:	c3                   	retq   

0000000000805dee <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  805dee:	55                   	push   %rbp
  805def:	48 89 e5             	mov    %rsp,%rbp
  805df2:	48 83 ec 20          	sub    $0x20,%rsp
  805df6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805dfa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  805dfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805e02:	8b 50 0c             	mov    0xc(%rax),%edx
  805e05:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805e0c:	00 00 00 
  805e0f:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  805e11:	be 00 00 00 00       	mov    $0x0,%esi
  805e16:	bf 05 00 00 00       	mov    $0x5,%edi
  805e1b:	48 b8 93 5a 80 00 00 	movabs $0x805a93,%rax
  805e22:	00 00 00 
  805e25:	ff d0                	callq  *%rax
  805e27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805e2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805e2e:	79 05                	jns    805e35 <devfile_stat+0x47>
		return r;
  805e30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e33:	eb 56                	jmp    805e8b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  805e35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805e39:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  805e40:	00 00 00 
  805e43:	48 89 c7             	mov    %rax,%rdi
  805e46:	48 b8 aa 40 80 00 00 	movabs $0x8040aa,%rax
  805e4d:	00 00 00 
  805e50:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  805e52:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805e59:	00 00 00 
  805e5c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  805e62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805e66:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  805e6c:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805e73:	00 00 00 
  805e76:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  805e7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805e80:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  805e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805e8b:	c9                   	leaveq 
  805e8c:	c3                   	retq   

0000000000805e8d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  805e8d:	55                   	push   %rbp
  805e8e:	48 89 e5             	mov    %rsp,%rbp
  805e91:	48 83 ec 10          	sub    $0x10,%rsp
  805e95:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805e99:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  805e9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ea0:	8b 50 0c             	mov    0xc(%rax),%edx
  805ea3:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805eaa:	00 00 00 
  805ead:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  805eaf:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805eb6:	00 00 00 
  805eb9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805ebc:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  805ebf:	be 00 00 00 00       	mov    $0x0,%esi
  805ec4:	bf 02 00 00 00       	mov    $0x2,%edi
  805ec9:	48 b8 93 5a 80 00 00 	movabs $0x805a93,%rax
  805ed0:	00 00 00 
  805ed3:	ff d0                	callq  *%rax
}
  805ed5:	c9                   	leaveq 
  805ed6:	c3                   	retq   

0000000000805ed7 <remove>:

// Delete a file
int
remove(const char *path)
{
  805ed7:	55                   	push   %rbp
  805ed8:	48 89 e5             	mov    %rsp,%rbp
  805edb:	48 83 ec 10          	sub    $0x10,%rsp
  805edf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  805ee3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ee7:	48 89 c7             	mov    %rax,%rdi
  805eea:	48 b8 3e 40 80 00 00 	movabs $0x80403e,%rax
  805ef1:	00 00 00 
  805ef4:	ff d0                	callq  *%rax
  805ef6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805efb:	7e 07                	jle    805f04 <remove+0x2d>
		return -E_BAD_PATH;
  805efd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805f02:	eb 33                	jmp    805f37 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  805f04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f08:	48 89 c6             	mov    %rax,%rsi
  805f0b:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  805f12:	00 00 00 
  805f15:	48 b8 aa 40 80 00 00 	movabs $0x8040aa,%rax
  805f1c:	00 00 00 
  805f1f:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  805f21:	be 00 00 00 00       	mov    $0x0,%esi
  805f26:	bf 07 00 00 00       	mov    $0x7,%edi
  805f2b:	48 b8 93 5a 80 00 00 	movabs $0x805a93,%rax
  805f32:	00 00 00 
  805f35:	ff d0                	callq  *%rax
}
  805f37:	c9                   	leaveq 
  805f38:	c3                   	retq   

0000000000805f39 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  805f39:	55                   	push   %rbp
  805f3a:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  805f3d:	be 00 00 00 00       	mov    $0x0,%esi
  805f42:	bf 08 00 00 00       	mov    $0x8,%edi
  805f47:	48 b8 93 5a 80 00 00 	movabs $0x805a93,%rax
  805f4e:	00 00 00 
  805f51:	ff d0                	callq  *%rax
}
  805f53:	5d                   	pop    %rbp
  805f54:	c3                   	retq   

0000000000805f55 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  805f55:	55                   	push   %rbp
  805f56:	48 89 e5             	mov    %rsp,%rbp
  805f59:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  805f60:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  805f67:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  805f6e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  805f75:	be 00 00 00 00       	mov    $0x0,%esi
  805f7a:	48 89 c7             	mov    %rax,%rdi
  805f7d:	48 b8 1a 5b 80 00 00 	movabs $0x805b1a,%rax
  805f84:	00 00 00 
  805f87:	ff d0                	callq  *%rax
  805f89:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  805f8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f90:	79 28                	jns    805fba <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  805f92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f95:	89 c6                	mov    %eax,%esi
  805f97:	48 bf aa 7a 80 00 00 	movabs $0x807aaa,%rdi
  805f9e:	00 00 00 
  805fa1:	b8 00 00 00 00       	mov    $0x0,%eax
  805fa6:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  805fad:	00 00 00 
  805fb0:	ff d2                	callq  *%rdx
		return fd_src;
  805fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805fb5:	e9 74 01 00 00       	jmpq   80612e <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  805fba:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  805fc1:	be 01 01 00 00       	mov    $0x101,%esi
  805fc6:	48 89 c7             	mov    %rax,%rdi
  805fc9:	48 b8 1a 5b 80 00 00 	movabs $0x805b1a,%rax
  805fd0:	00 00 00 
  805fd3:	ff d0                	callq  *%rax
  805fd5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  805fd8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805fdc:	79 39                	jns    806017 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  805fde:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805fe1:	89 c6                	mov    %eax,%esi
  805fe3:	48 bf c0 7a 80 00 00 	movabs $0x807ac0,%rdi
  805fea:	00 00 00 
  805fed:	b8 00 00 00 00       	mov    $0x0,%eax
  805ff2:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  805ff9:	00 00 00 
  805ffc:	ff d2                	callq  *%rdx
		close(fd_src);
  805ffe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806001:	89 c7                	mov    %eax,%edi
  806003:	48 b8 55 54 80 00 00 	movabs $0x805455,%rax
  80600a:	00 00 00 
  80600d:	ff d0                	callq  *%rax
		return fd_dest;
  80600f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806012:	e9 17 01 00 00       	jmpq   80612e <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  806017:	eb 74                	jmp    80608d <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  806019:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80601c:	48 63 d0             	movslq %eax,%rdx
  80601f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  806026:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806029:	48 89 ce             	mov    %rcx,%rsi
  80602c:	89 c7                	mov    %eax,%edi
  80602e:	48 b8 c1 57 80 00 00 	movabs $0x8057c1,%rax
  806035:	00 00 00 
  806038:	ff d0                	callq  *%rax
  80603a:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80603d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  806041:	79 4a                	jns    80608d <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  806043:	8b 45 f0             	mov    -0x10(%rbp),%eax
  806046:	89 c6                	mov    %eax,%esi
  806048:	48 bf da 7a 80 00 00 	movabs $0x807ada,%rdi
  80604f:	00 00 00 
  806052:	b8 00 00 00 00       	mov    $0x0,%eax
  806057:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  80605e:	00 00 00 
  806061:	ff d2                	callq  *%rdx
			close(fd_src);
  806063:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806066:	89 c7                	mov    %eax,%edi
  806068:	48 b8 55 54 80 00 00 	movabs $0x805455,%rax
  80606f:	00 00 00 
  806072:	ff d0                	callq  *%rax
			close(fd_dest);
  806074:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806077:	89 c7                	mov    %eax,%edi
  806079:	48 b8 55 54 80 00 00 	movabs $0x805455,%rax
  806080:	00 00 00 
  806083:	ff d0                	callq  *%rax
			return write_size;
  806085:	8b 45 f0             	mov    -0x10(%rbp),%eax
  806088:	e9 a1 00 00 00       	jmpq   80612e <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80608d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  806094:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806097:	ba 00 02 00 00       	mov    $0x200,%edx
  80609c:	48 89 ce             	mov    %rcx,%rsi
  80609f:	89 c7                	mov    %eax,%edi
  8060a1:	48 b8 77 56 80 00 00 	movabs $0x805677,%rax
  8060a8:	00 00 00 
  8060ab:	ff d0                	callq  *%rax
  8060ad:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8060b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8060b4:	0f 8f 5f ff ff ff    	jg     806019 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8060ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8060be:	79 47                	jns    806107 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8060c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8060c3:	89 c6                	mov    %eax,%esi
  8060c5:	48 bf ed 7a 80 00 00 	movabs $0x807aed,%rdi
  8060cc:	00 00 00 
  8060cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8060d4:	48 ba f5 34 80 00 00 	movabs $0x8034f5,%rdx
  8060db:	00 00 00 
  8060de:	ff d2                	callq  *%rdx
		close(fd_src);
  8060e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8060e3:	89 c7                	mov    %eax,%edi
  8060e5:	48 b8 55 54 80 00 00 	movabs $0x805455,%rax
  8060ec:	00 00 00 
  8060ef:	ff d0                	callq  *%rax
		close(fd_dest);
  8060f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8060f4:	89 c7                	mov    %eax,%edi
  8060f6:	48 b8 55 54 80 00 00 	movabs $0x805455,%rax
  8060fd:	00 00 00 
  806100:	ff d0                	callq  *%rax
		return read_size;
  806102:	8b 45 f4             	mov    -0xc(%rbp),%eax
  806105:	eb 27                	jmp    80612e <copy+0x1d9>
	}
	close(fd_src);
  806107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80610a:	89 c7                	mov    %eax,%edi
  80610c:	48 b8 55 54 80 00 00 	movabs $0x805455,%rax
  806113:	00 00 00 
  806116:	ff d0                	callq  *%rax
	close(fd_dest);
  806118:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80611b:	89 c7                	mov    %eax,%edi
  80611d:	48 b8 55 54 80 00 00 	movabs $0x805455,%rax
  806124:	00 00 00 
  806127:	ff d0                	callq  *%rax
	return 0;
  806129:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80612e:	c9                   	leaveq 
  80612f:	c3                   	retq   

0000000000806130 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  806130:	55                   	push   %rbp
  806131:	48 89 e5             	mov    %rsp,%rbp
  806134:	48 83 ec 20          	sub    $0x20,%rsp
  806138:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  80613c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806140:	8b 40 0c             	mov    0xc(%rax),%eax
  806143:	85 c0                	test   %eax,%eax
  806145:	7e 67                	jle    8061ae <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  806147:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80614b:	8b 40 04             	mov    0x4(%rax),%eax
  80614e:	48 63 d0             	movslq %eax,%rdx
  806151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806155:	48 8d 48 10          	lea    0x10(%rax),%rcx
  806159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80615d:	8b 00                	mov    (%rax),%eax
  80615f:	48 89 ce             	mov    %rcx,%rsi
  806162:	89 c7                	mov    %eax,%edi
  806164:	48 b8 c1 57 80 00 00 	movabs $0x8057c1,%rax
  80616b:	00 00 00 
  80616e:	ff d0                	callq  *%rax
  806170:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  806173:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806177:	7e 13                	jle    80618c <writebuf+0x5c>
			b->result += result;
  806179:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80617d:	8b 50 08             	mov    0x8(%rax),%edx
  806180:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806183:	01 c2                	add    %eax,%edx
  806185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806189:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  80618c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806190:	8b 40 04             	mov    0x4(%rax),%eax
  806193:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  806196:	74 16                	je     8061ae <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  806198:	b8 00 00 00 00       	mov    $0x0,%eax
  80619d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8061a1:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8061a5:	89 c2                	mov    %eax,%edx
  8061a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8061ab:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  8061ae:	c9                   	leaveq 
  8061af:	c3                   	retq   

00000000008061b0 <putch>:

static void
putch(int ch, void *thunk)
{
  8061b0:	55                   	push   %rbp
  8061b1:	48 89 e5             	mov    %rsp,%rbp
  8061b4:	48 83 ec 20          	sub    $0x20,%rsp
  8061b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8061bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  8061bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8061c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  8061c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8061cb:	8b 40 04             	mov    0x4(%rax),%eax
  8061ce:	8d 48 01             	lea    0x1(%rax),%ecx
  8061d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8061d5:	89 4a 04             	mov    %ecx,0x4(%rdx)
  8061d8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8061db:	89 d1                	mov    %edx,%ecx
  8061dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8061e1:	48 98                	cltq   
  8061e3:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  8061e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8061eb:	8b 40 04             	mov    0x4(%rax),%eax
  8061ee:	3d 00 01 00 00       	cmp    $0x100,%eax
  8061f3:	75 1e                	jne    806213 <putch+0x63>
		writebuf(b);
  8061f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8061f9:	48 89 c7             	mov    %rax,%rdi
  8061fc:	48 b8 30 61 80 00 00 	movabs $0x806130,%rax
  806203:	00 00 00 
  806206:	ff d0                	callq  *%rax
		b->idx = 0;
  806208:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80620c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  806213:	c9                   	leaveq 
  806214:	c3                   	retq   

0000000000806215 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  806215:	55                   	push   %rbp
  806216:	48 89 e5             	mov    %rsp,%rbp
  806219:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  806220:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  806226:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  80622d:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  806234:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  80623a:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  806240:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  806247:	00 00 00 
	b.result = 0;
  80624a:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  806251:	00 00 00 
	b.error = 1;
  806254:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  80625b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80625e:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  806265:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  80626c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  806273:	48 89 c6             	mov    %rax,%rsi
  806276:	48 bf b0 61 80 00 00 	movabs $0x8061b0,%rdi
  80627d:	00 00 00 
  806280:	48 b8 a8 38 80 00 00 	movabs $0x8038a8,%rax
  806287:	00 00 00 
  80628a:	ff d0                	callq  *%rax
	if (b.idx > 0)
  80628c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  806292:	85 c0                	test   %eax,%eax
  806294:	7e 16                	jle    8062ac <vfprintf+0x97>
		writebuf(&b);
  806296:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80629d:	48 89 c7             	mov    %rax,%rdi
  8062a0:	48 b8 30 61 80 00 00 	movabs $0x806130,%rax
  8062a7:	00 00 00 
  8062aa:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8062ac:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8062b2:	85 c0                	test   %eax,%eax
  8062b4:	74 08                	je     8062be <vfprintf+0xa9>
  8062b6:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8062bc:	eb 06                	jmp    8062c4 <vfprintf+0xaf>
  8062be:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8062c4:	c9                   	leaveq 
  8062c5:	c3                   	retq   

00000000008062c6 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8062c6:	55                   	push   %rbp
  8062c7:	48 89 e5             	mov    %rsp,%rbp
  8062ca:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8062d1:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8062d7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8062de:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8062e5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8062ec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8062f3:	84 c0                	test   %al,%al
  8062f5:	74 20                	je     806317 <fprintf+0x51>
  8062f7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8062fb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8062ff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  806303:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  806307:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80630b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80630f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  806313:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  806317:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80631e:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  806325:	00 00 00 
  806328:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80632f:	00 00 00 
  806332:	48 8d 45 10          	lea    0x10(%rbp),%rax
  806336:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80633d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  806344:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80634b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  806352:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  806359:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80635f:	48 89 ce             	mov    %rcx,%rsi
  806362:	89 c7                	mov    %eax,%edi
  806364:	48 b8 15 62 80 00 00 	movabs $0x806215,%rax
  80636b:	00 00 00 
  80636e:	ff d0                	callq  *%rax
  806370:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  806376:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80637c:	c9                   	leaveq 
  80637d:	c3                   	retq   

000000000080637e <printf>:

int
printf(const char *fmt, ...)
{
  80637e:	55                   	push   %rbp
  80637f:	48 89 e5             	mov    %rsp,%rbp
  806382:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  806389:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  806390:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  806397:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80639e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8063a5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8063ac:	84 c0                	test   %al,%al
  8063ae:	74 20                	je     8063d0 <printf+0x52>
  8063b0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8063b4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8063b8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8063bc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8063c0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8063c4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8063c8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8063cc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8063d0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8063d7:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8063de:	00 00 00 
  8063e1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8063e8:	00 00 00 
  8063eb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8063ef:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8063f6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8063fd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  806404:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80640b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  806412:	48 89 c6             	mov    %rax,%rsi
  806415:	bf 01 00 00 00       	mov    $0x1,%edi
  80641a:	48 b8 15 62 80 00 00 	movabs $0x806215,%rax
  806421:	00 00 00 
  806424:	ff d0                	callq  *%rax
  806426:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80642c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  806432:	c9                   	leaveq 
  806433:	c3                   	retq   

0000000000806434 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  806434:	55                   	push   %rbp
  806435:	48 89 e5             	mov    %rsp,%rbp
  806438:	48 83 ec 18          	sub    $0x18,%rsp
  80643c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  806440:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806444:	48 c1 e8 15          	shr    $0x15,%rax
  806448:	48 89 c2             	mov    %rax,%rdx
  80644b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  806452:	01 00 00 
  806455:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806459:	83 e0 01             	and    $0x1,%eax
  80645c:	48 85 c0             	test   %rax,%rax
  80645f:	75 07                	jne    806468 <pageref+0x34>
		return 0;
  806461:	b8 00 00 00 00       	mov    $0x0,%eax
  806466:	eb 53                	jmp    8064bb <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  806468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80646c:	48 c1 e8 0c          	shr    $0xc,%rax
  806470:	48 89 c2             	mov    %rax,%rdx
  806473:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80647a:	01 00 00 
  80647d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806481:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  806485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806489:	83 e0 01             	and    $0x1,%eax
  80648c:	48 85 c0             	test   %rax,%rax
  80648f:	75 07                	jne    806498 <pageref+0x64>
		return 0;
  806491:	b8 00 00 00 00       	mov    $0x0,%eax
  806496:	eb 23                	jmp    8064bb <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  806498:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80649c:	48 c1 e8 0c          	shr    $0xc,%rax
  8064a0:	48 89 c2             	mov    %rax,%rdx
  8064a3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8064aa:	00 00 00 
  8064ad:	48 c1 e2 04          	shl    $0x4,%rdx
  8064b1:	48 01 d0             	add    %rdx,%rax
  8064b4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8064b8:	0f b7 c0             	movzwl %ax,%eax
}
  8064bb:	c9                   	leaveq 
  8064bc:	c3                   	retq   

00000000008064bd <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8064bd:	55                   	push   %rbp
  8064be:	48 89 e5             	mov    %rsp,%rbp
  8064c1:	53                   	push   %rbx
  8064c2:	48 83 ec 38          	sub    $0x38,%rsp
  8064c6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8064ca:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8064ce:	48 89 c7             	mov    %rax,%rdi
  8064d1:	48 b8 ad 51 80 00 00 	movabs $0x8051ad,%rax
  8064d8:	00 00 00 
  8064db:	ff d0                	callq  *%rax
  8064dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8064e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8064e4:	0f 88 bf 01 00 00    	js     8066a9 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8064ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8064ee:	ba 07 04 00 00       	mov    $0x407,%edx
  8064f3:	48 89 c6             	mov    %rax,%rsi
  8064f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8064fb:	48 b8 d9 49 80 00 00 	movabs $0x8049d9,%rax
  806502:	00 00 00 
  806505:	ff d0                	callq  *%rax
  806507:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80650a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80650e:	0f 88 95 01 00 00    	js     8066a9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  806514:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  806518:	48 89 c7             	mov    %rax,%rdi
  80651b:	48 b8 ad 51 80 00 00 	movabs $0x8051ad,%rax
  806522:	00 00 00 
  806525:	ff d0                	callq  *%rax
  806527:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80652a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80652e:	0f 88 5d 01 00 00    	js     806691 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806534:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806538:	ba 07 04 00 00       	mov    $0x407,%edx
  80653d:	48 89 c6             	mov    %rax,%rsi
  806540:	bf 00 00 00 00       	mov    $0x0,%edi
  806545:	48 b8 d9 49 80 00 00 	movabs $0x8049d9,%rax
  80654c:	00 00 00 
  80654f:	ff d0                	callq  *%rax
  806551:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806554:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806558:	0f 88 33 01 00 00    	js     806691 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80655e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806562:	48 89 c7             	mov    %rax,%rdi
  806565:	48 b8 82 51 80 00 00 	movabs $0x805182,%rax
  80656c:	00 00 00 
  80656f:	ff d0                	callq  *%rax
  806571:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806575:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806579:	ba 07 04 00 00       	mov    $0x407,%edx
  80657e:	48 89 c6             	mov    %rax,%rsi
  806581:	bf 00 00 00 00       	mov    $0x0,%edi
  806586:	48 b8 d9 49 80 00 00 	movabs $0x8049d9,%rax
  80658d:	00 00 00 
  806590:	ff d0                	callq  *%rax
  806592:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806595:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806599:	79 05                	jns    8065a0 <pipe+0xe3>
		goto err2;
  80659b:	e9 d9 00 00 00       	jmpq   806679 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8065a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8065a4:	48 89 c7             	mov    %rax,%rdi
  8065a7:	48 b8 82 51 80 00 00 	movabs $0x805182,%rax
  8065ae:	00 00 00 
  8065b1:	ff d0                	callq  *%rax
  8065b3:	48 89 c2             	mov    %rax,%rdx
  8065b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8065ba:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8065c0:	48 89 d1             	mov    %rdx,%rcx
  8065c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8065c8:	48 89 c6             	mov    %rax,%rsi
  8065cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8065d0:	48 b8 29 4a 80 00 00 	movabs $0x804a29,%rax
  8065d7:	00 00 00 
  8065da:	ff d0                	callq  *%rax
  8065dc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8065df:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8065e3:	79 1b                	jns    806600 <pipe+0x143>
		goto err3;
  8065e5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8065e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8065ea:	48 89 c6             	mov    %rax,%rsi
  8065ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8065f2:	48 b8 84 4a 80 00 00 	movabs $0x804a84,%rax
  8065f9:	00 00 00 
  8065fc:	ff d0                	callq  *%rax
  8065fe:	eb 79                	jmp    806679 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  806600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806604:	48 ba 60 11 81 00 00 	movabs $0x811160,%rdx
  80660b:	00 00 00 
  80660e:	8b 12                	mov    (%rdx),%edx
  806610:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  806612:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806616:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80661d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806621:	48 ba 60 11 81 00 00 	movabs $0x811160,%rdx
  806628:	00 00 00 
  80662b:	8b 12                	mov    (%rdx),%edx
  80662d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80662f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806633:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80663a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80663e:	48 89 c7             	mov    %rax,%rdi
  806641:	48 b8 5f 51 80 00 00 	movabs $0x80515f,%rax
  806648:	00 00 00 
  80664b:	ff d0                	callq  *%rax
  80664d:	89 c2                	mov    %eax,%edx
  80664f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806653:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  806655:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806659:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80665d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806661:	48 89 c7             	mov    %rax,%rdi
  806664:	48 b8 5f 51 80 00 00 	movabs $0x80515f,%rax
  80666b:	00 00 00 
  80666e:	ff d0                	callq  *%rax
  806670:	89 03                	mov    %eax,(%rbx)
	return 0;
  806672:	b8 00 00 00 00       	mov    $0x0,%eax
  806677:	eb 33                	jmp    8066ac <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  806679:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80667d:	48 89 c6             	mov    %rax,%rsi
  806680:	bf 00 00 00 00       	mov    $0x0,%edi
  806685:	48 b8 84 4a 80 00 00 	movabs $0x804a84,%rax
  80668c:	00 00 00 
  80668f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  806691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806695:	48 89 c6             	mov    %rax,%rsi
  806698:	bf 00 00 00 00       	mov    $0x0,%edi
  80669d:	48 b8 84 4a 80 00 00 	movabs $0x804a84,%rax
  8066a4:	00 00 00 
  8066a7:	ff d0                	callq  *%rax
err:
	return r;
  8066a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8066ac:	48 83 c4 38          	add    $0x38,%rsp
  8066b0:	5b                   	pop    %rbx
  8066b1:	5d                   	pop    %rbp
  8066b2:	c3                   	retq   

00000000008066b3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8066b3:	55                   	push   %rbp
  8066b4:	48 89 e5             	mov    %rsp,%rbp
  8066b7:	53                   	push   %rbx
  8066b8:	48 83 ec 28          	sub    $0x28,%rsp
  8066bc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8066c0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8066c4:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8066cb:	00 00 00 
  8066ce:	48 8b 00             	mov    (%rax),%rax
  8066d1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8066d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8066da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8066de:	48 89 c7             	mov    %rax,%rdi
  8066e1:	48 b8 34 64 80 00 00 	movabs $0x806434,%rax
  8066e8:	00 00 00 
  8066eb:	ff d0                	callq  *%rax
  8066ed:	89 c3                	mov    %eax,%ebx
  8066ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8066f3:	48 89 c7             	mov    %rax,%rdi
  8066f6:	48 b8 34 64 80 00 00 	movabs $0x806434,%rax
  8066fd:	00 00 00 
  806700:	ff d0                	callq  *%rax
  806702:	39 c3                	cmp    %eax,%ebx
  806704:	0f 94 c0             	sete   %al
  806707:	0f b6 c0             	movzbl %al,%eax
  80670a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80670d:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  806714:	00 00 00 
  806717:	48 8b 00             	mov    (%rax),%rax
  80671a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806720:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  806723:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806726:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806729:	75 05                	jne    806730 <_pipeisclosed+0x7d>
			return ret;
  80672b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80672e:	eb 4f                	jmp    80677f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  806730:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806733:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806736:	74 42                	je     80677a <_pipeisclosed+0xc7>
  806738:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80673c:	75 3c                	jne    80677a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80673e:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  806745:	00 00 00 
  806748:	48 8b 00             	mov    (%rax),%rax
  80674b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  806751:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806754:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806757:	89 c6                	mov    %eax,%esi
  806759:	48 bf 0d 7b 80 00 00 	movabs $0x807b0d,%rdi
  806760:	00 00 00 
  806763:	b8 00 00 00 00       	mov    $0x0,%eax
  806768:	49 b8 f5 34 80 00 00 	movabs $0x8034f5,%r8
  80676f:	00 00 00 
  806772:	41 ff d0             	callq  *%r8
	}
  806775:	e9 4a ff ff ff       	jmpq   8066c4 <_pipeisclosed+0x11>
  80677a:	e9 45 ff ff ff       	jmpq   8066c4 <_pipeisclosed+0x11>
}
  80677f:	48 83 c4 28          	add    $0x28,%rsp
  806783:	5b                   	pop    %rbx
  806784:	5d                   	pop    %rbp
  806785:	c3                   	retq   

0000000000806786 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  806786:	55                   	push   %rbp
  806787:	48 89 e5             	mov    %rsp,%rbp
  80678a:	48 83 ec 30          	sub    $0x30,%rsp
  80678e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806791:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  806795:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806798:	48 89 d6             	mov    %rdx,%rsi
  80679b:	89 c7                	mov    %eax,%edi
  80679d:	48 b8 45 52 80 00 00 	movabs $0x805245,%rax
  8067a4:	00 00 00 
  8067a7:	ff d0                	callq  *%rax
  8067a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8067ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8067b0:	79 05                	jns    8067b7 <pipeisclosed+0x31>
		return r;
  8067b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8067b5:	eb 31                	jmp    8067e8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8067b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8067bb:	48 89 c7             	mov    %rax,%rdi
  8067be:	48 b8 82 51 80 00 00 	movabs $0x805182,%rax
  8067c5:	00 00 00 
  8067c8:	ff d0                	callq  *%rax
  8067ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8067ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8067d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8067d6:	48 89 d6             	mov    %rdx,%rsi
  8067d9:	48 89 c7             	mov    %rax,%rdi
  8067dc:	48 b8 b3 66 80 00 00 	movabs $0x8066b3,%rax
  8067e3:	00 00 00 
  8067e6:	ff d0                	callq  *%rax
}
  8067e8:	c9                   	leaveq 
  8067e9:	c3                   	retq   

00000000008067ea <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8067ea:	55                   	push   %rbp
  8067eb:	48 89 e5             	mov    %rsp,%rbp
  8067ee:	48 83 ec 40          	sub    $0x40,%rsp
  8067f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8067f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8067fa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8067fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806802:	48 89 c7             	mov    %rax,%rdi
  806805:	48 b8 82 51 80 00 00 	movabs $0x805182,%rax
  80680c:	00 00 00 
  80680f:	ff d0                	callq  *%rax
  806811:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806815:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806819:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80681d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806824:	00 
  806825:	e9 92 00 00 00       	jmpq   8068bc <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80682a:	eb 41                	jmp    80686d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80682c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  806831:	74 09                	je     80683c <devpipe_read+0x52>
				return i;
  806833:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806837:	e9 92 00 00 00       	jmpq   8068ce <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80683c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806844:	48 89 d6             	mov    %rdx,%rsi
  806847:	48 89 c7             	mov    %rax,%rdi
  80684a:	48 b8 b3 66 80 00 00 	movabs $0x8066b3,%rax
  806851:	00 00 00 
  806854:	ff d0                	callq  *%rax
  806856:	85 c0                	test   %eax,%eax
  806858:	74 07                	je     806861 <devpipe_read+0x77>
				return 0;
  80685a:	b8 00 00 00 00       	mov    $0x0,%eax
  80685f:	eb 6d                	jmp    8068ce <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  806861:	48 b8 9b 49 80 00 00 	movabs $0x80499b,%rax
  806868:	00 00 00 
  80686b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80686d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806871:	8b 10                	mov    (%rax),%edx
  806873:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806877:	8b 40 04             	mov    0x4(%rax),%eax
  80687a:	39 c2                	cmp    %eax,%edx
  80687c:	74 ae                	je     80682c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80687e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806882:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806886:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80688a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80688e:	8b 00                	mov    (%rax),%eax
  806890:	99                   	cltd   
  806891:	c1 ea 1b             	shr    $0x1b,%edx
  806894:	01 d0                	add    %edx,%eax
  806896:	83 e0 1f             	and    $0x1f,%eax
  806899:	29 d0                	sub    %edx,%eax
  80689b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80689f:	48 98                	cltq   
  8068a1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8068a6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8068a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8068ac:	8b 00                	mov    (%rax),%eax
  8068ae:	8d 50 01             	lea    0x1(%rax),%edx
  8068b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8068b5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8068b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8068bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8068c0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8068c4:	0f 82 60 ff ff ff    	jb     80682a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8068ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8068ce:	c9                   	leaveq 
  8068cf:	c3                   	retq   

00000000008068d0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8068d0:	55                   	push   %rbp
  8068d1:	48 89 e5             	mov    %rsp,%rbp
  8068d4:	48 83 ec 40          	sub    $0x40,%rsp
  8068d8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8068dc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8068e0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8068e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8068e8:	48 89 c7             	mov    %rax,%rdi
  8068eb:	48 b8 82 51 80 00 00 	movabs $0x805182,%rax
  8068f2:	00 00 00 
  8068f5:	ff d0                	callq  *%rax
  8068f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8068fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8068ff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806903:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80690a:	00 
  80690b:	e9 8e 00 00 00       	jmpq   80699e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806910:	eb 31                	jmp    806943 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  806912:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80691a:	48 89 d6             	mov    %rdx,%rsi
  80691d:	48 89 c7             	mov    %rax,%rdi
  806920:	48 b8 b3 66 80 00 00 	movabs $0x8066b3,%rax
  806927:	00 00 00 
  80692a:	ff d0                	callq  *%rax
  80692c:	85 c0                	test   %eax,%eax
  80692e:	74 07                	je     806937 <devpipe_write+0x67>
				return 0;
  806930:	b8 00 00 00 00       	mov    $0x0,%eax
  806935:	eb 79                	jmp    8069b0 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806937:	48 b8 9b 49 80 00 00 	movabs $0x80499b,%rax
  80693e:	00 00 00 
  806941:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806943:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806947:	8b 40 04             	mov    0x4(%rax),%eax
  80694a:	48 63 d0             	movslq %eax,%rdx
  80694d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806951:	8b 00                	mov    (%rax),%eax
  806953:	48 98                	cltq   
  806955:	48 83 c0 20          	add    $0x20,%rax
  806959:	48 39 c2             	cmp    %rax,%rdx
  80695c:	73 b4                	jae    806912 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80695e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806962:	8b 40 04             	mov    0x4(%rax),%eax
  806965:	99                   	cltd   
  806966:	c1 ea 1b             	shr    $0x1b,%edx
  806969:	01 d0                	add    %edx,%eax
  80696b:	83 e0 1f             	and    $0x1f,%eax
  80696e:	29 d0                	sub    %edx,%eax
  806970:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806974:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  806978:	48 01 ca             	add    %rcx,%rdx
  80697b:	0f b6 0a             	movzbl (%rdx),%ecx
  80697e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806982:	48 98                	cltq   
  806984:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  806988:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80698c:	8b 40 04             	mov    0x4(%rax),%eax
  80698f:	8d 50 01             	lea    0x1(%rax),%edx
  806992:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806996:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806999:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80699e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8069a2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8069a6:	0f 82 64 ff ff ff    	jb     806910 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8069ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8069b0:	c9                   	leaveq 
  8069b1:	c3                   	retq   

00000000008069b2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8069b2:	55                   	push   %rbp
  8069b3:	48 89 e5             	mov    %rsp,%rbp
  8069b6:	48 83 ec 20          	sub    $0x20,%rsp
  8069ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8069be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8069c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8069c6:	48 89 c7             	mov    %rax,%rdi
  8069c9:	48 b8 82 51 80 00 00 	movabs $0x805182,%rax
  8069d0:	00 00 00 
  8069d3:	ff d0                	callq  *%rax
  8069d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8069d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8069dd:	48 be 20 7b 80 00 00 	movabs $0x807b20,%rsi
  8069e4:	00 00 00 
  8069e7:	48 89 c7             	mov    %rax,%rdi
  8069ea:	48 b8 aa 40 80 00 00 	movabs $0x8040aa,%rax
  8069f1:	00 00 00 
  8069f4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8069f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8069fa:	8b 50 04             	mov    0x4(%rax),%edx
  8069fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806a01:	8b 00                	mov    (%rax),%eax
  806a03:	29 c2                	sub    %eax,%edx
  806a05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806a09:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  806a0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806a13:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806a1a:	00 00 00 
	stat->st_dev = &devpipe;
  806a1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806a21:	48 b9 60 11 81 00 00 	movabs $0x811160,%rcx
  806a28:	00 00 00 
  806a2b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  806a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806a37:	c9                   	leaveq 
  806a38:	c3                   	retq   

0000000000806a39 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  806a39:	55                   	push   %rbp
  806a3a:	48 89 e5             	mov    %rsp,%rbp
  806a3d:	48 83 ec 10          	sub    $0x10,%rsp
  806a41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  806a45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806a49:	48 89 c6             	mov    %rax,%rsi
  806a4c:	bf 00 00 00 00       	mov    $0x0,%edi
  806a51:	48 b8 84 4a 80 00 00 	movabs $0x804a84,%rax
  806a58:	00 00 00 
  806a5b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  806a5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806a61:	48 89 c7             	mov    %rax,%rdi
  806a64:	48 b8 82 51 80 00 00 	movabs $0x805182,%rax
  806a6b:	00 00 00 
  806a6e:	ff d0                	callq  *%rax
  806a70:	48 89 c6             	mov    %rax,%rsi
  806a73:	bf 00 00 00 00       	mov    $0x0,%edi
  806a78:	48 b8 84 4a 80 00 00 	movabs $0x804a84,%rax
  806a7f:	00 00 00 
  806a82:	ff d0                	callq  *%rax
}
  806a84:	c9                   	leaveq 
  806a85:	c3                   	retq   

0000000000806a86 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  806a86:	55                   	push   %rbp
  806a87:	48 89 e5             	mov    %rsp,%rbp
  806a8a:	48 83 ec 20          	sub    $0x20,%rsp
  806a8e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  806a91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806a94:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  806a97:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  806a9b:	be 01 00 00 00       	mov    $0x1,%esi
  806aa0:	48 89 c7             	mov    %rax,%rdi
  806aa3:	48 b8 91 48 80 00 00 	movabs $0x804891,%rax
  806aaa:	00 00 00 
  806aad:	ff d0                	callq  *%rax
}
  806aaf:	c9                   	leaveq 
  806ab0:	c3                   	retq   

0000000000806ab1 <getchar>:

int
getchar(void)
{
  806ab1:	55                   	push   %rbp
  806ab2:	48 89 e5             	mov    %rsp,%rbp
  806ab5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  806ab9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  806abd:	ba 01 00 00 00       	mov    $0x1,%edx
  806ac2:	48 89 c6             	mov    %rax,%rsi
  806ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  806aca:	48 b8 77 56 80 00 00 	movabs $0x805677,%rax
  806ad1:	00 00 00 
  806ad4:	ff d0                	callq  *%rax
  806ad6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  806ad9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806add:	79 05                	jns    806ae4 <getchar+0x33>
		return r;
  806adf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806ae2:	eb 14                	jmp    806af8 <getchar+0x47>
	if (r < 1)
  806ae4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806ae8:	7f 07                	jg     806af1 <getchar+0x40>
		return -E_EOF;
  806aea:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  806aef:	eb 07                	jmp    806af8 <getchar+0x47>
	return c;
  806af1:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  806af5:	0f b6 c0             	movzbl %al,%eax
}
  806af8:	c9                   	leaveq 
  806af9:	c3                   	retq   

0000000000806afa <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  806afa:	55                   	push   %rbp
  806afb:	48 89 e5             	mov    %rsp,%rbp
  806afe:	48 83 ec 20          	sub    $0x20,%rsp
  806b02:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806b05:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  806b09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806b0c:	48 89 d6             	mov    %rdx,%rsi
  806b0f:	89 c7                	mov    %eax,%edi
  806b11:	48 b8 45 52 80 00 00 	movabs $0x805245,%rax
  806b18:	00 00 00 
  806b1b:	ff d0                	callq  *%rax
  806b1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806b20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806b24:	79 05                	jns    806b2b <iscons+0x31>
		return r;
  806b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806b29:	eb 1a                	jmp    806b45 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  806b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806b2f:	8b 10                	mov    (%rax),%edx
  806b31:	48 b8 a0 11 81 00 00 	movabs $0x8111a0,%rax
  806b38:	00 00 00 
  806b3b:	8b 00                	mov    (%rax),%eax
  806b3d:	39 c2                	cmp    %eax,%edx
  806b3f:	0f 94 c0             	sete   %al
  806b42:	0f b6 c0             	movzbl %al,%eax
}
  806b45:	c9                   	leaveq 
  806b46:	c3                   	retq   

0000000000806b47 <opencons>:

int
opencons(void)
{
  806b47:	55                   	push   %rbp
  806b48:	48 89 e5             	mov    %rsp,%rbp
  806b4b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  806b4f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  806b53:	48 89 c7             	mov    %rax,%rdi
  806b56:	48 b8 ad 51 80 00 00 	movabs $0x8051ad,%rax
  806b5d:	00 00 00 
  806b60:	ff d0                	callq  *%rax
  806b62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806b65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806b69:	79 05                	jns    806b70 <opencons+0x29>
		return r;
  806b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806b6e:	eb 5b                	jmp    806bcb <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  806b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806b74:	ba 07 04 00 00       	mov    $0x407,%edx
  806b79:	48 89 c6             	mov    %rax,%rsi
  806b7c:	bf 00 00 00 00       	mov    $0x0,%edi
  806b81:	48 b8 d9 49 80 00 00 	movabs $0x8049d9,%rax
  806b88:	00 00 00 
  806b8b:	ff d0                	callq  *%rax
  806b8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806b90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806b94:	79 05                	jns    806b9b <opencons+0x54>
		return r;
  806b96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806b99:	eb 30                	jmp    806bcb <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  806b9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806b9f:	48 ba a0 11 81 00 00 	movabs $0x8111a0,%rdx
  806ba6:	00 00 00 
  806ba9:	8b 12                	mov    (%rdx),%edx
  806bab:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  806bad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806bb1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  806bb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806bbc:	48 89 c7             	mov    %rax,%rdi
  806bbf:	48 b8 5f 51 80 00 00 	movabs $0x80515f,%rax
  806bc6:	00 00 00 
  806bc9:	ff d0                	callq  *%rax
}
  806bcb:	c9                   	leaveq 
  806bcc:	c3                   	retq   

0000000000806bcd <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  806bcd:	55                   	push   %rbp
  806bce:	48 89 e5             	mov    %rsp,%rbp
  806bd1:	48 83 ec 30          	sub    $0x30,%rsp
  806bd5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806bd9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806bdd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  806be1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  806be6:	75 07                	jne    806bef <devcons_read+0x22>
		return 0;
  806be8:	b8 00 00 00 00       	mov    $0x0,%eax
  806bed:	eb 4b                	jmp    806c3a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  806bef:	eb 0c                	jmp    806bfd <devcons_read+0x30>
		sys_yield();
  806bf1:	48 b8 9b 49 80 00 00 	movabs $0x80499b,%rax
  806bf8:	00 00 00 
  806bfb:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  806bfd:	48 b8 db 48 80 00 00 	movabs $0x8048db,%rax
  806c04:	00 00 00 
  806c07:	ff d0                	callq  *%rax
  806c09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806c0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806c10:	74 df                	je     806bf1 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  806c12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806c16:	79 05                	jns    806c1d <devcons_read+0x50>
		return c;
  806c18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c1b:	eb 1d                	jmp    806c3a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  806c1d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  806c21:	75 07                	jne    806c2a <devcons_read+0x5d>
		return 0;
  806c23:	b8 00 00 00 00       	mov    $0x0,%eax
  806c28:	eb 10                	jmp    806c3a <devcons_read+0x6d>
	*(char*)vbuf = c;
  806c2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c2d:	89 c2                	mov    %eax,%edx
  806c2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806c33:	88 10                	mov    %dl,(%rax)
	return 1;
  806c35:	b8 01 00 00 00       	mov    $0x1,%eax
}
  806c3a:	c9                   	leaveq 
  806c3b:	c3                   	retq   

0000000000806c3c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  806c3c:	55                   	push   %rbp
  806c3d:	48 89 e5             	mov    %rsp,%rbp
  806c40:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  806c47:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  806c4e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  806c55:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  806c5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  806c63:	eb 76                	jmp    806cdb <devcons_write+0x9f>
		m = n - tot;
  806c65:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  806c6c:	89 c2                	mov    %eax,%edx
  806c6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c71:	29 c2                	sub    %eax,%edx
  806c73:	89 d0                	mov    %edx,%eax
  806c75:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  806c78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806c7b:	83 f8 7f             	cmp    $0x7f,%eax
  806c7e:	76 07                	jbe    806c87 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  806c80:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  806c87:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806c8a:	48 63 d0             	movslq %eax,%rdx
  806c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c90:	48 63 c8             	movslq %eax,%rcx
  806c93:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  806c9a:	48 01 c1             	add    %rax,%rcx
  806c9d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  806ca4:	48 89 ce             	mov    %rcx,%rsi
  806ca7:	48 89 c7             	mov    %rax,%rdi
  806caa:	48 b8 ce 43 80 00 00 	movabs $0x8043ce,%rax
  806cb1:	00 00 00 
  806cb4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  806cb6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806cb9:	48 63 d0             	movslq %eax,%rdx
  806cbc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  806cc3:	48 89 d6             	mov    %rdx,%rsi
  806cc6:	48 89 c7             	mov    %rax,%rdi
  806cc9:	48 b8 91 48 80 00 00 	movabs $0x804891,%rax
  806cd0:	00 00 00 
  806cd3:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  806cd5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806cd8:	01 45 fc             	add    %eax,-0x4(%rbp)
  806cdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806cde:	48 98                	cltq   
  806ce0:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  806ce7:	0f 82 78 ff ff ff    	jb     806c65 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  806ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806cf0:	c9                   	leaveq 
  806cf1:	c3                   	retq   

0000000000806cf2 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  806cf2:	55                   	push   %rbp
  806cf3:	48 89 e5             	mov    %rsp,%rbp
  806cf6:	48 83 ec 08          	sub    $0x8,%rsp
  806cfa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  806cfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806d03:	c9                   	leaveq 
  806d04:	c3                   	retq   

0000000000806d05 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  806d05:	55                   	push   %rbp
  806d06:	48 89 e5             	mov    %rsp,%rbp
  806d09:	48 83 ec 10          	sub    $0x10,%rsp
  806d0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806d11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  806d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806d19:	48 be 2c 7b 80 00 00 	movabs $0x807b2c,%rsi
  806d20:	00 00 00 
  806d23:	48 89 c7             	mov    %rax,%rdi
  806d26:	48 b8 aa 40 80 00 00 	movabs $0x8040aa,%rax
  806d2d:	00 00 00 
  806d30:	ff d0                	callq  *%rax
	return 0;
  806d32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806d37:	c9                   	leaveq 
  806d38:	c3                   	retq   
