
vmm/guest/obj/fs/fs:     file format elf64-x86-64


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
  80003c:	e8 10 36 00 00       	callq  803651 <libmain>
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
  800120:	48 bf c0 73 80 00 00 	movabs $0x8073c0,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
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
  80015e:	48 ba d7 73 80 00 00 	movabs $0x8073d7,%rdx
  800165:	00 00 00 
  800168:	be 3a 00 00 00       	mov    $0x3a,%esi
  80016d:	48 bf e7 73 80 00 00 	movabs $0x8073e7,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  800183:	00 00 00 
  800186:	ff d1                	callq  *%rcx
	diskno = d;
  800188:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
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
  8001b6:	48 b9 f0 73 80 00 00 	movabs $0x8073f0,%rcx
  8001bd:	00 00 00 
  8001c0:	48 ba fd 73 80 00 00 	movabs $0x8073fd,%rdx
  8001c7:	00 00 00 
  8001ca:	be 43 00 00 00       	mov    $0x43,%esi
  8001cf:	48 bf e7 73 80 00 00 	movabs $0x8073e7,%rdi
  8001d6:	00 00 00 
  8001d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001de:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
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
  800263:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
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
  80033e:	48 b9 f0 73 80 00 00 	movabs $0x8073f0,%rcx
  800345:	00 00 00 
  800348:	48 ba fd 73 80 00 00 	movabs $0x8073fd,%rdx
  80034f:	00 00 00 
  800352:	be 5c 00 00 00       	mov    $0x5c,%esi
  800357:	48 bf e7 73 80 00 00 	movabs $0x8073e7,%rdi
  80035e:	00 00 00 
  800361:	b8 00 00 00 00       	mov    $0x0,%eax
  800366:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
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
  8003eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
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
  8004b6:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  8004bd:	00 00 00 
  8004c0:	48 8b 00             	mov    (%rax),%rax
  8004c3:	48 85 c0             	test   %rax,%rax
  8004c6:	74 4a                	je     800512 <diskaddr+0x6f>
  8004c8:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  8004cf:	00 00 00 
  8004d2:	48 8b 00             	mov    (%rax),%rax
  8004d5:	8b 40 04             	mov    0x4(%rax),%eax
  8004d8:	89 c0                	mov    %eax,%eax
  8004da:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004de:	77 32                	ja     800512 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e4:	48 89 c1             	mov    %rax,%rcx
  8004e7:	48 ba 18 74 80 00 00 	movabs $0x807418,%rdx
  8004ee:	00 00 00 
  8004f1:	be 09 00 00 00       	mov    $0x9,%esi
  8004f6:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  8004fd:	00 00 00 
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
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
  800651:	48 ba 48 74 80 00 00 	movabs $0x807448,%rdx
  800658:	00 00 00 
  80065b:	be 28 00 00 00       	mov    $0x28,%esi
  800660:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  800667:	00 00 00 
  80066a:	b8 00 00 00 00       	mov    $0x0,%eax
  80066f:	49 ba f7 36 80 00 00 	movabs $0x8036f7,%r10
  800676:	00 00 00 
  800679:	41 ff d2             	callq  *%r10
			  utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80067c:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800683:	00 00 00 
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 85 c0             	test   %rax,%rax
  80068c:	74 4a                	je     8006d8 <bc_pgfault+0xe5>
  80068e:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800695:	00 00 00 
  800698:	48 8b 00             	mov    (%rax),%rax
  80069b:	8b 40 04             	mov    0x4(%rax),%eax
  80069e:	89 c0                	mov    %eax,%eax
  8006a0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a4:	77 32                	ja     8006d8 <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006aa:	48 89 c1             	mov    %rax,%rcx
  8006ad:	48 ba 78 74 80 00 00 	movabs $0x807478,%rdx
  8006b4:	00 00 00 
  8006b7:	be 2c 00 00 00       	mov    $0x2c,%esi
  8006bc:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  8006c3:	00 00 00 
  8006c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cb:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
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
  8006ff:	48 b8 14 4e 80 00 00 	movabs $0x804e14,%rax
  800706:	00 00 00 
  800709:	ff d0                	callq  *%rax
  80070b:	85 c0                	test   %eax,%eax
  80070d:	74 2a                	je     800739 <bc_pgfault+0x146>
		panic("Page Allocation Failed during handling page fault in FS");
  80070f:	48 ba a0 74 80 00 00 	movabs $0x8074a0,%rdx
  800716:	00 00 00 
  800719:	be 35 00 00 00       	mov    $0x35,%esi
  80071e:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  800725:	00 00 00 
  800728:	b8 00 00 00 00       	mov    $0x0,%eax
  80072d:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  800734:	00 00 00 
  800737:	ff d1                	callq  *%rcx
	}
#ifdef VMM_GUEST
	if(0 != host_read((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
  800739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80073d:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800748:	ba 08 00 00 00       	mov    $0x8,%edx
  80074d:	48 89 c6             	mov    %rax,%rsi
  800750:	89 cf                	mov    %ecx,%edi
  800752:	48 b8 33 33 80 00 00 	movabs $0x803333,%rax
  800759:	00 00 00 
  80075c:	ff d0                	callq  *%rax
  80075e:	85 c0                	test   %eax,%eax
  800760:	74 2a                	je     80078c <bc_pgfault+0x199>
	{
		panic("ide read failed in Page Fault Handling");		
  800762:	48 ba d8 74 80 00 00 	movabs $0x8074d8,%rdx
  800769:	00 00 00 
  80076c:	be 3a 00 00 00       	mov    $0x3a,%esi
  800771:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  800778:	00 00 00 
  80077b:	b8 00 00 00 00       	mov    $0x0,%eax
  800780:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  800787:	00 00 00 
  80078a:	ff d1                	callq  *%rcx
	if(0 != ide_read((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
	{
		panic("ide read failed in Page Fault Handling");		
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
  8007c7:	48 b8 64 4e 80 00 00 	movabs $0x804e64,%rax
  8007ce:	00 00 00 
  8007d1:	ff d0                	callq  *%rax
  8007d3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8007d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007da:	79 30                	jns    80080c <bc_pgfault+0x219>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8007dc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007df:	89 c1                	mov    %eax,%ecx
  8007e1:	48 ba 00 75 80 00 00 	movabs $0x807500,%rdx
  8007e8:	00 00 00 
  8007eb:	be 43 00 00 00       	mov    $0x43,%esi
  8007f0:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  8007f7:	00 00 00 
  8007fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ff:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  800806:	00 00 00 
  800809:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  80080c:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
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
  80083b:	48 ba 20 75 80 00 00 	movabs $0x807520,%rdx
  800842:	00 00 00 
  800845:	be 49 00 00 00       	mov    $0x49,%esi
  80084a:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  800851:	00 00 00 
  800854:	b8 00 00 00 00       	mov    $0x0,%eax
  800859:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
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
  8008a2:	48 ba 39 75 80 00 00 	movabs $0x807539,%rdx
  8008a9:	00 00 00 
  8008ac:	be 5b 00 00 00       	mov    $0x5b,%esi
  8008b1:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  8008b8:	00 00 00 
  8008bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c0:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
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
#ifdef VMM_GUEST
		if(0 != host_write((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
  80091c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800920:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800927:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80092b:	ba 08 00 00 00       	mov    $0x8,%edx
  800930:	48 89 c6             	mov    %rax,%rsi
  800933:	89 cf                	mov    %ecx,%edi
  800935:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  80093c:	00 00 00 
  80093f:	ff d0                	callq  *%rax
  800941:	85 c0                	test   %eax,%eax
  800943:	74 2a                	je     80096f <flush_block+0x107>
		{
			panic("ide read failed in Page Fault Handling");		
  800945:	48 ba d8 74 80 00 00 	movabs $0x8074d8,%rdx
  80094c:	00 00 00 
  80094f:	be 67 00 00 00       	mov    $0x67,%esi
  800954:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  80095b:	00 00 00 
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
  800963:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  80096a:	00 00 00 
  80096d:	ff d1                	callq  *%rcx
		if(0 != ide_write((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
		{
			panic("ide write failed in Flush Block");	
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
  80098d:	48 b8 64 4e 80 00 00 	movabs $0x804e64,%rax
  800994:	00 00 00 
  800997:	ff d0                	callq  *%rax
  800999:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80099c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8009a0:	79 30                	jns    8009d2 <flush_block+0x16a>
		{
			panic("in flush_block, sys_page_map: %e", r);
  8009a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8009a5:	89 c1                	mov    %eax,%ecx
  8009a7:	48 ba 58 75 80 00 00 	movabs $0x807558,%rdx
  8009ae:	00 00 00 
  8009b1:	be 71 00 00 00       	mov    $0x71,%esi
  8009b6:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  8009bd:	00 00 00 
  8009c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c5:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
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
  800a05:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  800a0c:	00 00 00 
  800a0f:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  800a11:	bf 01 00 00 00       	mov    $0x1,%edi
  800a16:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a1d:	00 00 00 
  800a20:	ff d0                	callq  *%rax
  800a22:	48 be 79 75 80 00 00 	movabs $0x807579,%rsi
  800a29:	00 00 00 
  800a2c:	48 89 c7             	mov    %rax,%rdi
  800a2f:	48 b8 e5 44 80 00 00 	movabs $0x8044e5,%rax
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
  800a82:	48 b9 80 75 80 00 00 	movabs $0x807580,%rcx
  800a89:	00 00 00 
  800a8c:	48 ba 9a 75 80 00 00 	movabs $0x80759a,%rdx
  800a93:	00 00 00 
  800a96:	be 83 00 00 00       	mov    $0x83,%esi
  800a9b:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  800aa2:	00 00 00 
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaa:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
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
  800adb:	48 b9 af 75 80 00 00 	movabs $0x8075af,%rcx
  800ae2:	00 00 00 
  800ae5:	48 ba 9a 75 80 00 00 	movabs $0x80759a,%rdx
  800aec:	00 00 00 
  800aef:	be 84 00 00 00       	mov    $0x84,%esi
  800af4:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  800afb:	00 00 00 
  800afe:	b8 00 00 00 00       	mov    $0x0,%eax
  800b03:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
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
  800b29:	48 b8 bf 4e 80 00 00 	movabs $0x804ebf,%rax
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
  800b59:	48 b9 c9 75 80 00 00 	movabs $0x8075c9,%rcx
  800b60:	00 00 00 
  800b63:	48 ba 9a 75 80 00 00 	movabs $0x80759a,%rdx
  800b6a:	00 00 00 
  800b6d:	be 88 00 00 00       	mov    $0x88,%esi
  800b72:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  800b79:	00 00 00 
  800b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b81:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  800b88:	00 00 00 
  800b8b:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800b8e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b93:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b9a:	00 00 00 
  800b9d:	ff d0                	callq  *%rax
  800b9f:	48 be 79 75 80 00 00 	movabs $0x807579,%rsi
  800ba6:	00 00 00 
  800ba9:	48 89 c7             	mov    %rax,%rdi
  800bac:	48 b8 47 46 80 00 00 	movabs $0x804647,%rax
  800bb3:	00 00 00 
  800bb6:	ff d0                	callq  *%rax
  800bb8:	85 c0                	test   %eax,%eax
  800bba:	74 35                	je     800bf1 <check_bc+0x21d>
  800bbc:	48 b9 e8 75 80 00 00 	movabs $0x8075e8,%rcx
  800bc3:	00 00 00 
  800bc6:	48 ba 9a 75 80 00 00 	movabs $0x80759a,%rdx
  800bcd:	00 00 00 
  800bd0:	be 8b 00 00 00       	mov    $0x8b,%esi
  800bd5:	48 bf 3a 74 80 00 00 	movabs $0x80743a,%rdi
  800bdc:	00 00 00 
  800bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800be4:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
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
  800c14:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
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
  800c40:	48 bf 0c 76 80 00 00 	movabs $0x80760c,%rdi
  800c47:	00 00 00 
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4f:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
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
  800c72:	48 b8 64 51 80 00 00 	movabs $0x805164,%rax
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
  800cb0:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
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
  800cc2:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800cc9:	00 00 00 
  800ccc:	48 8b 00             	mov    (%rax),%rax
  800ccf:	8b 00                	mov    (%rax),%eax
  800cd1:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800cd6:	74 2a                	je     800d02 <check_super+0x44>
		panic("bad file system magic number");
  800cd8:	48 ba 28 76 80 00 00 	movabs $0x807628,%rdx
  800cdf:	00 00 00 
  800ce2:	be 0e 00 00 00       	mov    $0xe,%esi
  800ce7:	48 bf 45 76 80 00 00 	movabs $0x807645,%rdi
  800cee:	00 00 00 
  800cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf6:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  800cfd:	00 00 00 
  800d00:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800d02:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800d09:	00 00 00 
  800d0c:	48 8b 00             	mov    (%rax),%rax
  800d0f:	8b 40 04             	mov    0x4(%rax),%eax
  800d12:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800d17:	76 2a                	jbe    800d43 <check_super+0x85>
		panic("file system is too large");
  800d19:	48 ba 4d 76 80 00 00 	movabs $0x80764d,%rdx
  800d20:	00 00 00 
  800d23:	be 11 00 00 00       	mov    $0x11,%esi
  800d28:	48 bf 45 76 80 00 00 	movabs $0x807645,%rdi
  800d2f:	00 00 00 
  800d32:	b8 00 00 00 00       	mov    $0x0,%eax
  800d37:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  800d3e:	00 00 00 
  800d41:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800d43:	48 bf 66 76 80 00 00 	movabs $0x807666,%rdi
  800d4a:	00 00 00 
  800d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d52:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
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
  800d6b:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800d72:	00 00 00 
  800d75:	48 8b 00             	mov    (%rax),%rax
  800d78:	48 85 c0             	test   %rax,%rax
  800d7b:	74 15                	je     800d92 <block_is_free+0x32>
  800d7d:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800d84:	00 00 00 
  800d87:	48 8b 00             	mov    (%rax),%rax
  800d8a:	8b 40 04             	mov    0x4(%rax),%eax
  800d8d:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800d90:	77 07                	ja     800d99 <block_is_free+0x39>
		return 0;
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
  800d97:	eb 41                	jmp    800dda <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800d99:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
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
  800ded:	48 ba 7a 76 80 00 00 	movabs $0x80767a,%rdx
  800df4:	00 00 00 
  800df7:	be 2c 00 00 00       	mov    $0x2c,%esi
  800dfc:	48 bf 45 76 80 00 00 	movabs $0x807645,%rdi
  800e03:	00 00 00 
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0b:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  800e12:	00 00 00 
  800e15:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800e17:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  800e1e:	00 00 00 
  800e21:	48 8b 10             	mov    (%rax),%rdx
  800e24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e27:	c1 e8 05             	shr    $0x5,%eax
  800e2a:	89 c1                	mov    %eax,%ecx
  800e2c:	48 c1 e1 02          	shl    $0x2,%rcx
  800e30:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800e34:	48 ba 10 60 81 00 00 	movabs $0x816010,%rdx
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
  800e90:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  800e97:	00 00 00 
  800e9a:	48 8b 10             	mov    (%rax),%rdx
  800e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea0:	c1 e8 05             	shr    $0x5,%eax
  800ea3:	89 c1                	mov    %eax,%ecx
  800ea5:	48 c1 e1 02          	shl    $0x2,%rcx
  800ea9:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800ead:	48 ba 10 60 81 00 00 	movabs $0x816010,%rdx
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
  800edc:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  800ee3:	00 00 00 
  800ee6:	48 8b 00             	mov    (%rax),%rax
  800ee9:	48 89 c7             	mov    %rax,%rdi
  800eec:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  800ef3:	00 00 00 
  800ef6:	ff d0                	callq  *%rax
				//cprintf("alloc_block_retrning block # [%d]\n", blockno);
				blocks_allocated++;
  800ef8:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  800eff:	00 00 00 
  800f02:	8b 00                	mov    (%rax),%eax
  800f04:	8d 50 01             	lea    0x1(%rax),%edx
  800f07:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
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
  800f1c:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
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
  800f35:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  800f3c:	00 00 00 
  800f3f:	8b 00                	mov    (%rax),%eax
  800f41:	89 c6                	mov    %eax,%esi
  800f43:	48 bf 98 76 80 00 00 	movabs $0x807698,%rdi
  800f4a:	00 00 00 
  800f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f52:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
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
  800f8e:	48 b9 c6 76 80 00 00 	movabs $0x8076c6,%rcx
  800f95:	00 00 00 
  800f98:	48 ba da 76 80 00 00 	movabs $0x8076da,%rdx
  800f9f:	00 00 00 
  800fa2:	be 5f 00 00 00       	mov    $0x5f,%esi
  800fa7:	48 bf 45 76 80 00 00 	movabs $0x807645,%rdi
  800fae:	00 00 00 
  800fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb6:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
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
  800fcf:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
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
  800ff8:	48 b9 ef 76 80 00 00 	movabs $0x8076ef,%rcx
  800fff:	00 00 00 
  801002:	48 ba da 76 80 00 00 	movabs $0x8076da,%rdx
  801009:	00 00 00 
  80100c:	be 62 00 00 00       	mov    $0x62,%esi
  801011:	48 bf 45 76 80 00 00 	movabs $0x807645,%rdi
  801018:	00 00 00 
  80101b:	b8 00 00 00 00       	mov    $0x0,%eax
  801020:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  801027:	00 00 00 
  80102a:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  80102d:	bf 01 00 00 00       	mov    $0x1,%edi
  801032:	48 b8 60 0d 80 00 00 	movabs $0x800d60,%rax
  801039:	00 00 00 
  80103c:	ff d0                	callq  *%rax
  80103e:	84 c0                	test   %al,%al
  801040:	74 35                	je     801077 <check_bitmap+0x112>
  801042:	48 b9 01 77 80 00 00 	movabs $0x807701,%rcx
  801049:	00 00 00 
  80104c:	48 ba da 76 80 00 00 	movabs $0x8076da,%rdx
  801053:	00 00 00 
  801056:	be 63 00 00 00       	mov    $0x63,%esi
  80105b:	48 bf 45 76 80 00 00 	movabs $0x807645,%rdi
  801062:	00 00 00 
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
  80106a:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  801071:	00 00 00 
  801074:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  801077:	48 bf 13 77 80 00 00 	movabs $0x807713,%rdi
  80107e:	00 00 00 
  801081:	b8 00 00 00 00       	mov    $0x0,%eax
  801086:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
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
	if (ide_probe_disk1())
		ide_set_disk(1);
	else
		ide_set_disk(0);
#else
	host_ipc_init();
  801098:	b8 00 00 00 00       	mov    $0x0,%eax
  80109d:	48 ba 20 35 80 00 00 	movabs $0x803520,%rdx
  8010a4:	00 00 00 
  8010a7:	ff d2                	callq  *%rdx
#endif
	bc_init();
  8010a9:	48 b8 5d 0c 80 00 00 	movabs $0x800c5d,%rax
  8010b0:	00 00 00 
  8010b3:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  8010b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8010ba:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8010c1:	00 00 00 
  8010c4:	ff d0                	callq  *%rax
  8010c6:	48 ba 18 60 81 00 00 	movabs $0x816018,%rdx
  8010cd:	00 00 00 
  8010d0:	48 89 02             	mov    %rax,(%rdx)
	check_super();
  8010d3:	48 b8 be 0c 80 00 00 	movabs $0x800cbe,%rax
  8010da:	00 00 00 
  8010dd:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  8010df:	bf 02 00 00 00       	mov    $0x2,%edi
  8010e4:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8010eb:	00 00 00 
  8010ee:	ff d0                	callq  *%rax
  8010f0:	48 ba 10 60 81 00 00 	movabs $0x816010,%rdx
  8010f7:	00 00 00 
  8010fa:	48 89 02             	mov    %rax,(%rdx)
	check_bitmap();
  8010fd:	48 b8 65 0f 80 00 00 	movabs $0x800f65,%rax
  801104:	00 00 00 
  801107:	ff d0                	callq  *%rax
}
  801109:	5d                   	pop    %rbp
  80110a:	c3                   	retq   

000000000080110b <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
	{
  80110b:	55                   	push   %rbp
  80110c:	48 89 e5             	mov    %rsp,%rbp
  80110f:	48 83 ec 30          	sub    $0x30,%rsp
  801113:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801117:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80111a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80111e:	89 c8                	mov    %ecx,%eax
  801120:	88 45 e0             	mov    %al,-0x20(%rbp)
		// LAB 5: Your code here.
		//if filebno is out of range
		//panic("file_block_walk not implemented");
		uint32_t* indirect = 0;
  801123:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80112a:	00 
		uint32_t nblock = 0;
  80112b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
		int freeBlock = 0;
  801132:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)

		if(filebno >= NDIRECT + NINDIRECT)
  801139:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  801140:	76 0a                	jbe    80114c <file_block_walk+0x41>
		{
			return -E_INVAL;
  801142:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801147:	e9 6a 01 00 00       	jmpq   8012b6 <file_block_walk+0x1ab>
		}
		nblock = f->f_size / BLKSIZE;
  80114c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801150:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801156:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80115c:	85 c0                	test   %eax,%eax
  80115e:	0f 48 c2             	cmovs  %edx,%eax
  801161:	c1 f8 0c             	sar    $0xc,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (filebno > nblock) {
  801167:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80116a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80116d:	76 0a                	jbe    801179 <file_block_walk+0x6e>
			return -E_NOT_FOUND;
  80116f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801174:	e9 3d 01 00 00       	jmpq   8012b6 <file_block_walk+0x1ab>
		}		
		if(filebno >= 0 && filebno < 10)
  801179:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  80117d:	77 26                	ja     8011a5 <file_block_walk+0x9a>
		{
			*ppdiskbno = (uint32_t *)(f->f_direct + filebno);
  80117f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801182:	48 83 c0 20          	add    $0x20,%rax
  801186:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  80118d:	00 
  80118e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801192:	48 01 d0             	add    %rdx,%rax
  801195:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801199:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80119d:	48 89 10             	mov    %rdx,(%rax)
  8011a0:	e9 0c 01 00 00       	jmpq   8012b1 <file_block_walk+0x1a6>
		}
		else if(filebno >= 10)
  8011a5:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  8011a9:	0f 86 02 01 00 00    	jbe    8012b1 <file_block_walk+0x1a6>
		{
			filebno = filebno - 10;
  8011af:	83 6d e4 0a          	subl   $0xa,-0x1c(%rbp)
			
			if(f->f_indirect != 0)
  8011b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b7:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	74 3d                	je     8011fe <file_block_walk+0xf3>
			{
			
				//cprintf("called from file_block_walk1\n");
				indirect = (uint32_t*)diskaddr(f->f_indirect);
  8011c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c5:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8011cb:	89 c0                	mov    %eax,%eax
  8011cd:	48 89 c7             	mov    %rax,%rdi
  8011d0:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8011d7:	00 00 00 
  8011da:	ff d0                	callq  *%rax
  8011dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
				*ppdiskbno = indirect + filebno;
  8011e0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8011e3:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  8011ea:	00 
  8011eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ef:	48 01 c2             	add    %rax,%rdx
  8011f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f6:	48 89 10             	mov    %rdx,(%rax)
  8011f9:	e9 b3 00 00 00       	jmpq   8012b1 <file_block_walk+0x1a6>
			}
			else if(f->f_indirect == 0 && alloc)
  8011fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801202:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801208:	85 c0                	test   %eax,%eax
  80120a:	0f 85 9a 00 00 00    	jne    8012aa <file_block_walk+0x19f>
  801210:	80 7d e0 00          	cmpb   $0x0,-0x20(%rbp)
  801214:	0f 84 90 00 00 00    	je     8012aa <file_block_walk+0x19f>
			{
				freeBlock = alloc_block();
  80121a:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  801221:	00 00 00 
  801224:	ff d0                	callq  *%rax
  801226:	89 45 f0             	mov    %eax,-0x10(%rbp)
				
				if(freeBlock == -E_NO_DISK)
  801229:	83 7d f0 f6          	cmpl   $0xfffffff6,-0x10(%rbp)
  80122d:	75 27                	jne    801256 <file_block_walk+0x14b>
				{
					//f->f_indirect = freeBlock;
					fprintf(1,"returning from here with -E_NO_DISK");
  80122f:	48 be 28 77 80 00 00 	movabs $0x807728,%rsi
  801236:	00 00 00 
  801239:	bf 01 00 00 00       	mov    $0x1,%edi
  80123e:	b8 00 00 00 00       	mov    $0x0,%eax
  801243:	48 ba 48 69 80 00 00 	movabs $0x806948,%rdx
  80124a:	00 00 00 
  80124d:	ff d2                	callq  *%rdx
					return -E_NO_DISK;
  80124f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801254:	eb 60                	jmp    8012b6 <file_block_walk+0x1ab>
				}
				f->f_indirect = freeBlock;
  801256:	8b 55 f0             	mov    -0x10(%rbp),%edx
  801259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125d:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)
				
				fprintf(1,"called from file_block_walk2\n");
  801263:	48 be 4c 77 80 00 00 	movabs $0x80774c,%rsi
  80126a:	00 00 00 
  80126d:	bf 01 00 00 00       	mov    $0x1,%edi
  801272:	b8 00 00 00 00       	mov    $0x0,%eax
  801277:	48 ba 48 69 80 00 00 	movabs $0x806948,%rdx
  80127e:	00 00 00 
  801281:	ff d2                	callq  *%rdx
				*ppdiskbno = (uint32_t*)diskaddr(freeBlock) + filebno;
  801283:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801286:	48 98                	cltq   
  801288:	48 89 c7             	mov    %rax,%rdi
  80128b:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801292:	00 00 00 
  801295:	ff d0                	callq  *%rax
  801297:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80129a:	48 c1 e2 02          	shl    $0x2,%rdx
  80129e:	48 01 c2             	add    %rax,%rdx
  8012a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a5:	48 89 10             	mov    %rdx,(%rax)
  8012a8:	eb 07                	jmp    8012b1 <file_block_walk+0x1a6>
			}
			else
			{
				return -E_NOT_FOUND;
  8012aa:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8012af:	eb 05                	jmp    8012b6 <file_block_walk+0x1ab>
			}
		}
		return 0;
  8012b1:	b8 00 00 00 00       	mov    $0x0,%eax
		//panic("file_block_walk not implemented");
	}
  8012b6:	c9                   	leaveq 
  8012b7:	c3                   	retq   

00000000008012b8 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  8012b8:	55                   	push   %rbp
  8012b9:	48 89 e5             	mov    %rsp,%rbp
  8012bc:	48 83 ec 30          	sub    $0x30,%rsp
  8012c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 5: Your code here.
	//panic("file_get_block not implemented");
	//cprintf("called from file_get_walk\n");
	if(filebno >= NDIRECT + NINDIRECT || !f || !blk)
  8012cb:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  8012d2:	77 0e                	ja     8012e2 <file_get_block+0x2a>
  8012d4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012d9:	74 07                	je     8012e2 <file_get_block+0x2a>
  8012db:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012e0:	75 0a                	jne    8012ec <file_get_block+0x34>
	{
		return -E_INVAL;
  8012e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e7:	e9 e4 00 00 00       	jmpq   8013d0 <file_get_block+0x118>
	}
	uint32_t * pdiskbno;
	if(file_block_walk(f, filebno, &pdiskbno, true) < 0)
  8012ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8012f0:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8012f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f7:	b9 01 00 00 00       	mov    $0x1,%ecx
  8012fc:	48 89 c7             	mov    %rax,%rdi
  8012ff:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  801306:	00 00 00 
  801309:	ff d0                	callq  *%rax
  80130b:	85 c0                	test   %eax,%eax
  80130d:	79 0a                	jns    801319 <file_get_block+0x61>
	{
		return -E_NO_DISK;
  80130f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801314:	e9 b7 00 00 00       	jmpq   8013d0 <file_get_block+0x118>
	}
	if(*pdiskbno != 0)
  801319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131d:	8b 00                	mov    (%rax),%eax
  80131f:	85 c0                	test   %eax,%eax
  801321:	74 23                	je     801346 <file_get_block+0x8e>
	{
		*blk = (char*)diskaddr(*pdiskbno);
  801323:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801327:	8b 00                	mov    (%rax),%eax
  801329:	89 c0                	mov    %eax,%eax
  80132b:	48 89 c7             	mov    %rax,%rdi
  80132e:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801335:	00 00 00 
  801338:	ff d0                	callq  *%rax
  80133a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80133e:	48 89 02             	mov    %rax,(%rdx)
  801341:	e9 85 00 00 00       	jmpq   8013cb <file_get_block+0x113>
	}
	else
	{
		uint32_t freeBlock = -1;
  801346:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
		freeBlock = alloc_block();
  80134d:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  801354:	00 00 00 
  801357:	ff d0                	callq  *%rax
  801359:	89 45 fc             	mov    %eax,-0x4(%rbp)
		
		if(freeBlock == -E_NO_DISK)
  80135c:	83 7d fc f6          	cmpl   $0xfffffff6,-0x4(%rbp)
  801360:	75 27                	jne    801389 <file_get_block+0xd1>
		{
			//f->f_indirect = freeBlock;
			fprintf(1,"file get blockreturning from here with -E_NO_DISK");
  801362:	48 be 70 77 80 00 00 	movabs $0x807770,%rsi
  801369:	00 00 00 
  80136c:	bf 01 00 00 00       	mov    $0x1,%edi
  801371:	b8 00 00 00 00       	mov    $0x0,%eax
  801376:	48 ba 48 69 80 00 00 	movabs $0x806948,%rdx
  80137d:	00 00 00 
  801380:	ff d2                	callq  *%rdx
			return -E_NO_DISK;
  801382:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801387:	eb 47                	jmp    8013d0 <file_get_block+0x118>
		}
		
		fprintf(1,"file get blockcalled from file_block_walk2\n");
  801389:	48 be a8 77 80 00 00 	movabs $0x8077a8,%rsi
  801390:	00 00 00 
  801393:	bf 01 00 00 00       	mov    $0x1,%edi
  801398:	b8 00 00 00 00       	mov    $0x0,%eax
  80139d:	48 ba 48 69 80 00 00 	movabs $0x806948,%rdx
  8013a4:	00 00 00 
  8013a7:	ff d2                	callq  *%rdx
		*pdiskbno = freeBlock;
  8013a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8013b0:	89 10                	mov    %edx,(%rax)
		*blk = (char*)diskaddr(freeBlock);
  8013b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013b5:	48 89 c7             	mov    %rax,%rdi
  8013b8:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8013bf:	00 00 00 
  8013c2:	ff d0                	callq  *%rax
  8013c4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013c8:	48 89 02             	mov    %rax,(%rdx)
	}
	return 0;
  8013cb:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("file_block_walk not implemented");
}
  8013d0:	c9                   	leaveq 
  8013d1:	c3                   	retq   

00000000008013d2 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  8013d2:	55                   	push   %rbp
  8013d3:	48 89 e5             	mov    %rsp,%rbp
  8013d6:	48 83 ec 40          	sub    $0x40,%rsp
  8013da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013e2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  8013e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ea:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8013f0:	25 ff 0f 00 00       	and    $0xfff,%eax
  8013f5:	85 c0                	test   %eax,%eax
  8013f7:	74 35                	je     80142e <dir_lookup+0x5c>
  8013f9:	48 b9 d4 77 80 00 00 	movabs $0x8077d4,%rcx
  801400:	00 00 00 
  801403:	48 ba da 76 80 00 00 	movabs $0x8076da,%rdx
  80140a:	00 00 00 
  80140d:	be 0f 01 00 00       	mov    $0x10f,%esi
  801412:	48 bf 45 76 80 00 00 	movabs $0x807645,%rdi
  801419:	00 00 00 
  80141c:	b8 00 00 00 00       	mov    $0x0,%eax
  801421:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  801428:	00 00 00 
  80142b:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  80142e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801432:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801438:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80143e:	85 c0                	test   %eax,%eax
  801440:	0f 48 c2             	cmovs  %edx,%eax
  801443:	c1 f8 0c             	sar    $0xc,%eax
  801446:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  801449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801450:	e9 93 00 00 00       	jmpq   8014e8 <dir_lookup+0x116>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801455:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801459:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80145c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801460:	89 ce                	mov    %ecx,%esi
  801462:	48 89 c7             	mov    %rax,%rdi
  801465:	48 b8 b8 12 80 00 00 	movabs $0x8012b8,%rax
  80146c:	00 00 00 
  80146f:	ff d0                	callq  *%rax
  801471:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801474:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801478:	79 05                	jns    80147f <dir_lookup+0xad>
			return r;
  80147a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80147d:	eb 7a                	jmp    8014f9 <dir_lookup+0x127>
		f = (struct File*) blk;
  80147f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801483:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  801487:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  80148e:	eb 4e                	jmp    8014de <dir_lookup+0x10c>
			if (strcmp(f[j].f_name, name) == 0) {
  801490:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801493:	48 c1 e0 08          	shl    $0x8,%rax
  801497:	48 89 c2             	mov    %rax,%rdx
  80149a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149e:	48 01 d0             	add    %rdx,%rax
  8014a1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8014a5:	48 89 d6             	mov    %rdx,%rsi
  8014a8:	48 89 c7             	mov    %rax,%rdi
  8014ab:	48 b8 47 46 80 00 00 	movabs $0x804647,%rax
  8014b2:	00 00 00 
  8014b5:	ff d0                	callq  *%rax
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	75 1f                	jne    8014da <dir_lookup+0x108>
				*file = &f[j];
  8014bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014be:	48 c1 e0 08          	shl    $0x8,%rax
  8014c2:	48 89 c2             	mov    %rax,%rdx
  8014c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c9:	48 01 c2             	add    %rax,%rdx
  8014cc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8014d0:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8014d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d8:	eb 1f                	jmp    8014f9 <dir_lookup+0x127>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8014da:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8014de:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8014e2:	76 ac                	jbe    801490 <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8014e4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8014e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014eb:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8014ee:	0f 82 61 ff ff ff    	jb     801455 <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  8014f4:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  8014f9:	c9                   	leaveq 
  8014fa:	c3                   	retq   

00000000008014fb <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  8014fb:	55                   	push   %rbp
  8014fc:	48 89 e5             	mov    %rsp,%rbp
  8014ff:	48 83 ec 30          	sub    $0x30,%rsp
  801503:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801507:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  80150b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150f:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801515:	25 ff 0f 00 00       	and    $0xfff,%eax
  80151a:	85 c0                	test   %eax,%eax
  80151c:	74 35                	je     801553 <dir_alloc_file+0x58>
  80151e:	48 b9 d4 77 80 00 00 	movabs $0x8077d4,%rcx
  801525:	00 00 00 
  801528:	48 ba da 76 80 00 00 	movabs $0x8076da,%rdx
  80152f:	00 00 00 
  801532:	be 28 01 00 00       	mov    $0x128,%esi
  801537:	48 bf 45 76 80 00 00 	movabs $0x807645,%rdi
  80153e:	00 00 00 
  801541:	b8 00 00 00 00       	mov    $0x0,%eax
  801546:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  80154d:	00 00 00 
  801550:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801557:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80155d:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801563:	85 c0                	test   %eax,%eax
  801565:	0f 48 c2             	cmovs  %edx,%eax
  801568:	c1 f8 0c             	sar    $0xc,%eax
  80156b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  80156e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801575:	e9 83 00 00 00       	jmpq   8015fd <dir_alloc_file+0x102>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  80157a:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80157e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801585:	89 ce                	mov    %ecx,%esi
  801587:	48 89 c7             	mov    %rax,%rdi
  80158a:	48 b8 b8 12 80 00 00 	movabs $0x8012b8,%rax
  801591:	00 00 00 
  801594:	ff d0                	callq  *%rax
  801596:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801599:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80159d:	79 08                	jns    8015a7 <dir_alloc_file+0xac>
			return r;
  80159f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8015a2:	e9 be 00 00 00       	jmpq   801665 <dir_alloc_file+0x16a>
		f = (struct File*) blk;
  8015a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  8015af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8015b6:	eb 3b                	jmp    8015f3 <dir_alloc_file+0xf8>
			if (f[j].f_name[0] == '\0') {
  8015b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015bb:	48 c1 e0 08          	shl    $0x8,%rax
  8015bf:	48 89 c2             	mov    %rax,%rdx
  8015c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c6:	48 01 d0             	add    %rdx,%rax
  8015c9:	0f b6 00             	movzbl (%rax),%eax
  8015cc:	84 c0                	test   %al,%al
  8015ce:	75 1f                	jne    8015ef <dir_alloc_file+0xf4>
				*file = &f[j];
  8015d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015d3:	48 c1 e0 08          	shl    $0x8,%rax
  8015d7:	48 89 c2             	mov    %rax,%rdx
  8015da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015de:	48 01 c2             	add    %rax,%rdx
  8015e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015e5:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8015e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ed:	eb 76                	jmp    801665 <dir_alloc_file+0x16a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8015ef:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8015f3:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8015f7:	76 bf                	jbe    8015b8 <dir_alloc_file+0xbd>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8015f9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8015fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801600:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801603:	0f 82 71 ff ff ff    	jb     80157a <dir_alloc_file+0x7f>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801613:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  801619:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801623:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801627:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80162a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162e:	89 ce                	mov    %ecx,%esi
  801630:	48 89 c7             	mov    %rax,%rdi
  801633:	48 b8 b8 12 80 00 00 	movabs $0x8012b8,%rax
  80163a:	00 00 00 
  80163d:	ff d0                	callq  *%rax
  80163f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801642:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801646:	79 05                	jns    80164d <dir_alloc_file+0x152>
		return r;
  801648:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80164b:	eb 18                	jmp    801665 <dir_alloc_file+0x16a>
	f = (struct File*) blk;
  80164d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801651:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  801655:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801659:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80165d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801660:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801665:	c9                   	leaveq 
  801666:	c3                   	retq   

0000000000801667 <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  801667:	55                   	push   %rbp
  801668:	48 89 e5             	mov    %rsp,%rbp
  80166b:	48 83 ec 08          	sub    $0x8,%rsp
  80166f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  801673:	eb 05                	jmp    80167a <skip_slash+0x13>
		p++;
  801675:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  80167a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167e:	0f b6 00             	movzbl (%rax),%eax
  801681:	3c 2f                	cmp    $0x2f,%al
  801683:	74 f0                	je     801675 <skip_slash+0xe>
		p++;
	return p;
  801685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801689:	c9                   	leaveq 
  80168a:	c3                   	retq   

000000000080168b <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  80168b:	55                   	push   %rbp
  80168c:	48 89 e5             	mov    %rsp,%rbp
  80168f:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  801696:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  80169d:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  8016a4:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  8016ab:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  8016b2:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8016b9:	48 89 c7             	mov    %rax,%rdi
  8016bc:	48 b8 67 16 80 00 00 	movabs $0x801667,%rax
  8016c3:	00 00 00 
  8016c6:	ff d0                	callq  *%rax
  8016c8:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  8016cf:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  8016d6:	00 00 00 
  8016d9:	48 8b 00             	mov    (%rax),%rax
  8016dc:	48 83 c0 08          	add    $0x8,%rax
  8016e0:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  8016e7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8016ee:	00 
	name[0] = 0;
  8016ef:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  8016f6:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8016fd:	00 
  8016fe:	74 0e                	je     80170e <walk_path+0x83>
		*pdir = 0;
  801700:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801707:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  80170e:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801715:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  80171c:	e9 73 01 00 00       	jmpq   801894 <walk_path+0x209>
		dir = f;
  801721:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801728:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  80172c:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801733:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  801737:	eb 08                	jmp    801741 <walk_path+0xb6>
			path++;
  801739:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  801740:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  801741:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801748:	0f b6 00             	movzbl (%rax),%eax
  80174b:	3c 2f                	cmp    $0x2f,%al
  80174d:	74 0e                	je     80175d <walk_path+0xd2>
  80174f:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801756:	0f b6 00             	movzbl (%rax),%eax
  801759:	84 c0                	test   %al,%al
  80175b:	75 dc                	jne    801739 <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  80175d:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801764:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801768:	48 29 c2             	sub    %rax,%rdx
  80176b:	48 89 d0             	mov    %rdx,%rax
  80176e:	48 83 f8 7f          	cmp    $0x7f,%rax
  801772:	7e 0a                	jle    80177e <walk_path+0xf3>
			return -E_BAD_PATH;
  801774:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801779:	e9 56 01 00 00       	jmpq   8018d4 <walk_path+0x249>
		memmove(name, p, path - p);
  80177e:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801785:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801789:	48 29 c2             	sub    %rax,%rdx
  80178c:	48 89 d0             	mov    %rdx,%rax
  80178f:	48 89 c2             	mov    %rax,%rdx
  801792:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801796:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  80179d:	48 89 ce             	mov    %rcx,%rsi
  8017a0:	48 89 c7             	mov    %rax,%rdi
  8017a3:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  8017aa:	00 00 00 
  8017ad:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  8017af:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8017b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ba:	48 29 c2             	sub    %rax,%rdx
  8017bd:	48 89 d0             	mov    %rdx,%rax
  8017c0:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  8017c7:	00 
		path = skip_slash(path);
  8017c8:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8017cf:	48 89 c7             	mov    %rax,%rdi
  8017d2:	48 b8 67 16 80 00 00 	movabs $0x801667,%rax
  8017d9:	00 00 00 
  8017dc:	ff d0                	callq  *%rax
  8017de:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  8017e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e9:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8017ef:	83 f8 01             	cmp    $0x1,%eax
  8017f2:	74 0a                	je     8017fe <walk_path+0x173>
			return -E_NOT_FOUND;
  8017f4:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8017f9:	e9 d6 00 00 00       	jmpq   8018d4 <walk_path+0x249>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  8017fe:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  801805:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  80180c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801810:	48 89 ce             	mov    %rcx,%rsi
  801813:	48 89 c7             	mov    %rax,%rdi
  801816:	48 b8 d2 13 80 00 00 	movabs $0x8013d2,%rax
  80181d:	00 00 00 
  801820:	ff d0                	callq  *%rax
  801822:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801825:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801829:	79 69                	jns    801894 <walk_path+0x209>
			if (r == -E_NOT_FOUND && *path == '\0') {
  80182b:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  80182f:	75 5e                	jne    80188f <walk_path+0x204>
  801831:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801838:	0f b6 00             	movzbl (%rax),%eax
  80183b:	84 c0                	test   %al,%al
  80183d:	75 50                	jne    80188f <walk_path+0x204>
				if (pdir)
  80183f:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801846:	00 
  801847:	74 0e                	je     801857 <walk_path+0x1cc>
					*pdir = dir;
  801849:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801850:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801854:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  801857:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  80185e:	00 
  80185f:	74 20                	je     801881 <walk_path+0x1f6>
					strcpy(lastelem, name);
  801861:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801868:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  80186f:	48 89 d6             	mov    %rdx,%rsi
  801872:	48 89 c7             	mov    %rax,%rdi
  801875:	48 b8 e5 44 80 00 00 	movabs $0x8044e5,%rax
  80187c:	00 00 00 
  80187f:	ff d0                	callq  *%rax
				*pf = 0;
  801881:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801888:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  80188f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801892:	eb 40                	jmp    8018d4 <walk_path+0x249>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  801894:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80189b:	0f b6 00             	movzbl (%rax),%eax
  80189e:	84 c0                	test   %al,%al
  8018a0:	0f 85 7b fe ff ff    	jne    801721 <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  8018a6:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8018ad:	00 
  8018ae:	74 0e                	je     8018be <walk_path+0x233>
		*pdir = dir;
  8018b0:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8018b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018bb:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  8018be:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8018c5:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8018cc:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8018cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d4:	c9                   	leaveq 
  8018d5:	c3                   	retq   

00000000008018d6 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  8018d6:	55                   	push   %rbp
  8018d7:	48 89 e5             	mov    %rsp,%rbp
  8018da:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8018e1:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  8018e8:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  8018ef:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  8018f6:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8018fd:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  801904:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80190b:	48 89 c7             	mov    %rax,%rdi
  80190e:	48 b8 8b 16 80 00 00 	movabs $0x80168b,%rax
  801915:	00 00 00 
  801918:	ff d0                	callq  *%rax
  80191a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80191d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801921:	75 0a                	jne    80192d <file_create+0x57>
		return -E_FILE_EXISTS;
  801923:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801928:	e9 91 00 00 00       	jmpq   8019be <file_create+0xe8>
	if (r != -E_NOT_FOUND || dir == 0)
  80192d:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  801931:	75 0c                	jne    80193f <file_create+0x69>
  801933:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80193a:	48 85 c0             	test   %rax,%rax
  80193d:	75 05                	jne    801944 <file_create+0x6e>
		return r;
  80193f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801942:	eb 7a                	jmp    8019be <file_create+0xe8>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  801944:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80194b:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801952:	48 89 d6             	mov    %rdx,%rsi
  801955:	48 89 c7             	mov    %rax,%rdi
  801958:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  80195f:	00 00 00 
  801962:	ff d0                	callq  *%rax
  801964:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801967:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80196b:	79 05                	jns    801972 <file_create+0x9c>
		return r;
  80196d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801970:	eb 4c                	jmp    8019be <file_create+0xe8>
	strcpy(f->f_name, name);
  801972:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801979:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  801980:	48 89 d6             	mov    %rdx,%rsi
  801983:	48 89 c7             	mov    %rax,%rdi
  801986:	48 b8 e5 44 80 00 00 	movabs $0x8044e5,%rax
  80198d:	00 00 00 
  801990:	ff d0                	callq  *%rax
	*pf = f;
  801992:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  801999:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8019a0:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  8019a3:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8019aa:	48 89 c7             	mov    %rax,%rdi
  8019ad:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  8019b4:	00 00 00 
  8019b7:	ff d0                	callq  *%rax
	return 0;
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019be:	c9                   	leaveq 
  8019bf:	c3                   	retq   

00000000008019c0 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  8019c0:	55                   	push   %rbp
  8019c1:	48 89 e5             	mov    %rsp,%rbp
  8019c4:	48 83 ec 10          	sub    $0x10,%rsp
  8019c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  8019d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019dd:	be 00 00 00 00       	mov    $0x0,%esi
  8019e2:	48 89 c7             	mov    %rax,%rdi
  8019e5:	48 b8 8b 16 80 00 00 	movabs $0x80168b,%rax
  8019ec:	00 00 00 
  8019ef:	ff d0                	callq  *%rax
}
  8019f1:	c9                   	leaveq 
  8019f2:	c3                   	retq   

00000000008019f3 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  8019f3:	55                   	push   %rbp
  8019f4:	48 89 e5             	mov    %rsp,%rbp
  8019f7:	48 83 ec 60          	sub    $0x60,%rsp
  8019fb:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  8019ff:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  801a03:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  801a07:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  801a0a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a0e:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a14:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  801a17:	7f 0a                	jg     801a23 <file_read+0x30>
		return 0;
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1e:	e9 24 01 00 00       	jmpq   801b47 <file_read+0x154>

	count = MIN(count, f->f_size - offset);
  801a23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a27:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801a2b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a2f:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a35:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  801a38:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a3e:	48 63 d0             	movslq %eax,%rdx
  801a41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a45:	48 39 c2             	cmp    %rax,%rdx
  801a48:	48 0f 46 c2          	cmovbe %rdx,%rax
  801a4c:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  801a50:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801a53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a56:	e9 cd 00 00 00       	jmpq   801b28 <file_read+0x135>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801a5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5e:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801a64:	85 c0                	test   %eax,%eax
  801a66:	0f 48 c2             	cmovs  %edx,%eax
  801a69:	c1 f8 0c             	sar    $0xc,%eax
  801a6c:	89 c1                	mov    %eax,%ecx
  801a6e:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801a72:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a76:	89 ce                	mov    %ecx,%esi
  801a78:	48 89 c7             	mov    %rax,%rdi
  801a7b:	48 b8 b8 12 80 00 00 	movabs $0x8012b8,%rax
  801a82:	00 00 00 
  801a85:	ff d0                	callq  *%rax
  801a87:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801a8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801a8e:	79 08                	jns    801a98 <file_read+0xa5>
			return r;
  801a90:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801a93:	e9 af 00 00 00       	jmpq   801b47 <file_read+0x154>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9b:	99                   	cltd   
  801a9c:	c1 ea 14             	shr    $0x14,%edx
  801a9f:	01 d0                	add    %edx,%eax
  801aa1:	25 ff 0f 00 00       	and    $0xfff,%eax
  801aa6:	29 d0                	sub    %edx,%eax
  801aa8:	ba 00 10 00 00       	mov    $0x1000,%edx
  801aad:	29 c2                	sub    %eax,%edx
  801aaf:	89 d0                	mov    %edx,%eax
  801ab1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801ab4:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801ab7:	48 63 d0             	movslq %eax,%rdx
  801aba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801abe:	48 01 c2             	add    %rax,%rdx
  801ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac4:	48 98                	cltq   
  801ac6:	48 29 c2             	sub    %rax,%rdx
  801ac9:	48 89 d0             	mov    %rdx,%rax
  801acc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801ad0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ad3:	48 63 d0             	movslq %eax,%rdx
  801ad6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ada:	48 39 c2             	cmp    %rax,%rdx
  801add:	48 0f 46 c2          	cmovbe %rdx,%rax
  801ae1:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  801ae4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801ae7:	48 63 c8             	movslq %eax,%rcx
  801aea:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801aee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af1:	99                   	cltd   
  801af2:	c1 ea 14             	shr    $0x14,%edx
  801af5:	01 d0                	add    %edx,%eax
  801af7:	25 ff 0f 00 00       	and    $0xfff,%eax
  801afc:	29 d0                	sub    %edx,%eax
  801afe:	48 98                	cltq   
  801b00:	48 01 c6             	add    %rax,%rsi
  801b03:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801b07:	48 89 ca             	mov    %rcx,%rdx
  801b0a:	48 89 c7             	mov    %rax,%rdi
  801b0d:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	callq  *%rax
		pos += bn;
  801b19:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b1c:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801b1f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b22:	48 98                	cltq   
  801b24:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  801b28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2b:	48 98                	cltq   
  801b2d:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  801b30:	48 63 ca             	movslq %edx,%rcx
  801b33:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801b37:	48 01 ca             	add    %rcx,%rdx
  801b3a:	48 39 d0             	cmp    %rdx,%rax
  801b3d:	0f 82 18 ff ff ff    	jb     801a5b <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801b43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  801b47:	c9                   	leaveq 
  801b48:	c3                   	retq   

0000000000801b49 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801b49:	55                   	push   %rbp
  801b4a:	48 89 e5             	mov    %rsp,%rbp
  801b4d:	48 83 ec 50          	sub    $0x50,%rsp
  801b51:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801b55:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801b59:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801b5d:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801b60:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801b63:	48 63 d0             	movslq %eax,%rdx
  801b66:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b6a:	48 01 c2             	add    %rax,%rdx
  801b6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b71:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801b77:	48 98                	cltq   
  801b79:	48 39 c2             	cmp    %rax,%rdx
  801b7c:	76 33                	jbe    801bb1 <file_write+0x68>
		if ((r = file_set_size(f, offset + count)) < 0)
  801b7e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b82:	89 c2                	mov    %eax,%edx
  801b84:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801b87:	01 d0                	add    %edx,%eax
  801b89:	89 c2                	mov    %eax,%edx
  801b8b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b8f:	89 d6                	mov    %edx,%esi
  801b91:	48 89 c7             	mov    %rax,%rdi
  801b94:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  801b9b:	00 00 00 
  801b9e:	ff d0                	callq  *%rax
  801ba0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801ba3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ba7:	79 08                	jns    801bb1 <file_write+0x68>
			return r;
  801ba9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bac:	e9 f8 00 00 00       	jmpq   801ca9 <file_write+0x160>

	for (pos = offset; pos < offset + count; ) {
  801bb1:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801bb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bb7:	e9 ce 00 00 00       	jmpq   801c8a <file_write+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbf:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	0f 48 c2             	cmovs  %edx,%eax
  801bca:	c1 f8 0c             	sar    $0xc,%eax
  801bcd:	89 c1                	mov    %eax,%ecx
  801bcf:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801bd3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bd7:	89 ce                	mov    %ecx,%esi
  801bd9:	48 89 c7             	mov    %rax,%rdi
  801bdc:	48 b8 b8 12 80 00 00 	movabs $0x8012b8,%rax
  801be3:	00 00 00 
  801be6:	ff d0                	callq  *%rax
  801be8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801beb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801bef:	79 08                	jns    801bf9 <file_write+0xb0>
			return r;
  801bf1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bf4:	e9 b0 00 00 00       	jmpq   801ca9 <file_write+0x160>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801bf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfc:	99                   	cltd   
  801bfd:	c1 ea 14             	shr    $0x14,%edx
  801c00:	01 d0                	add    %edx,%eax
  801c02:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c07:	29 d0                	sub    %edx,%eax
  801c09:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c0e:	29 c2                	sub    %eax,%edx
  801c10:	89 d0                	mov    %edx,%eax
  801c12:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801c15:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801c18:	48 63 d0             	movslq %eax,%rdx
  801c1b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801c1f:	48 01 c2             	add    %rax,%rdx
  801c22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c25:	48 98                	cltq   
  801c27:	48 29 c2             	sub    %rax,%rdx
  801c2a:	48 89 d0             	mov    %rdx,%rax
  801c2d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c31:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c34:	48 63 d0             	movslq %eax,%rdx
  801c37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c3b:	48 39 c2             	cmp    %rax,%rdx
  801c3e:	48 0f 46 c2          	cmovbe %rdx,%rax
  801c42:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  801c45:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c48:	48 63 c8             	movslq %eax,%rcx
  801c4b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801c4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c52:	99                   	cltd   
  801c53:	c1 ea 14             	shr    $0x14,%edx
  801c56:	01 d0                	add    %edx,%eax
  801c58:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c5d:	29 d0                	sub    %edx,%eax
  801c5f:	48 98                	cltq   
  801c61:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801c65:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801c69:	48 89 ca             	mov    %rcx,%rdx
  801c6c:	48 89 c6             	mov    %rax,%rsi
  801c6f:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  801c76:	00 00 00 
  801c79:	ff d0                	callq  *%rax
		pos += bn;
  801c7b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c7e:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801c81:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c84:	48 98                	cltq   
  801c86:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  801c8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8d:	48 98                	cltq   
  801c8f:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  801c92:	48 63 ca             	movslq %edx,%rcx
  801c95:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801c99:	48 01 ca             	add    %rcx,%rdx
  801c9c:	48 39 d0             	cmp    %rdx,%rax
  801c9f:	0f 82 17 ff ff ff    	jb     801bbc <file_write+0x73>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801ca5:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801ca9:	c9                   	leaveq 
  801caa:	c3                   	retq   

0000000000801cab <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  801cab:	55                   	push   %rbp
  801cac:	48 89 e5             	mov    %rsp,%rbp
  801caf:	48 83 ec 20          	sub    $0x20,%rsp
  801cb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cb7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801cba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cbe:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801cc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cca:	48 89 c7             	mov    %rax,%rdi
  801ccd:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  801cd4:	00 00 00 
  801cd7:	ff d0                	callq  *%rax
  801cd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ce0:	79 05                	jns    801ce7 <file_free_block+0x3c>
		return r;
  801ce2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce5:	eb 2d                	jmp    801d14 <file_free_block+0x69>
	if (*ptr) {
  801ce7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ceb:	8b 00                	mov    (%rax),%eax
  801ced:	85 c0                	test   %eax,%eax
  801cef:	74 1e                	je     801d0f <file_free_block+0x64>
		free_block(*ptr);
  801cf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf5:	8b 00                	mov    (%rax),%eax
  801cf7:	89 c7                	mov    %eax,%edi
  801cf9:	48 b8 dc 0d 80 00 00 	movabs $0x800ddc,%rax
  801d00:	00 00 00 
  801d03:	ff d0                	callq  *%rax
		*ptr = 0;
  801d05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d09:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d14:	c9                   	leaveq 
  801d15:	c3                   	retq   

0000000000801d16 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  801d16:	55                   	push   %rbp
  801d17:	48 89 e5             	mov    %rsp,%rbp
  801d1a:	48 83 ec 20          	sub    $0x20,%rsp
  801d1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d22:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801d25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d29:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801d2f:	05 ff 0f 00 00       	add    $0xfff,%eax
  801d34:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	0f 48 c2             	cmovs  %edx,%eax
  801d3f:	c1 f8 0c             	sar    $0xc,%eax
  801d42:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801d45:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d48:	05 ff 0f 00 00       	add    $0xfff,%eax
  801d4d:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801d53:	85 c0                	test   %eax,%eax
  801d55:	0f 48 c2             	cmovs  %edx,%eax
  801d58:	c1 f8 0c             	sar    $0xc,%eax
  801d5b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801d5e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d64:	eb 45                	jmp    801dab <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  801d66:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d6d:	89 d6                	mov    %edx,%esi
  801d6f:	48 89 c7             	mov    %rax,%rdi
  801d72:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  801d79:	00 00 00 
  801d7c:	ff d0                	callq  *%rax
  801d7e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801d81:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801d85:	79 20                	jns    801da7 <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  801d87:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801d8a:	89 c6                	mov    %eax,%esi
  801d8c:	48 bf f1 77 80 00 00 	movabs $0x8077f1,%rdi
  801d93:	00 00 00 
  801d96:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9b:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  801da2:	00 00 00 
  801da5:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801da7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dae:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801db1:	72 b3                	jb     801d66 <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801db3:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801db7:	77 34                	ja     801ded <file_truncate_blocks+0xd7>
  801db9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dbd:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	74 26                	je     801ded <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801dc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dcb:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801dd1:	89 c7                	mov    %eax,%edi
  801dd3:	48 b8 dc 0d 80 00 00 	movabs $0x800ddc,%rax
  801dda:	00 00 00 
  801ddd:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801ddf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de3:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801dea:	00 00 00 
	}
}
  801ded:	c9                   	leaveq 
  801dee:	c3                   	retq   

0000000000801def <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801def:	55                   	push   %rbp
  801df0:	48 89 e5             	mov    %rsp,%rbp
  801df3:	48 83 ec 10          	sub    $0x10,%rsp
  801df7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dfb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801dfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e02:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801e08:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801e0b:	7e 18                	jle    801e25 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801e0d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e14:	89 d6                	mov    %edx,%esi
  801e16:	48 89 c7             	mov    %rax,%rdi
  801e19:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  801e20:	00 00 00 
  801e23:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801e25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e29:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e2c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801e32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e36:	48 89 c7             	mov    %rax,%rdi
  801e39:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  801e40:	00 00 00 
  801e43:	ff d0                	callq  *%rax
	return 0;
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4a:	c9                   	leaveq 
  801e4b:	c3                   	retq   

0000000000801e4c <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
  801e50:	48 83 ec 20          	sub    $0x20,%rsp
  801e54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;
	//cprintf("called from file_flush\n");
	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801e58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e5f:	eb 62                	jmp    801ec3 <file_flush+0x77>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801e61:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e64:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e71:	48 89 c7             	mov    %rax,%rdi
  801e74:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  801e7b:	00 00 00 
  801e7e:	ff d0                	callq  *%rax
  801e80:	85 c0                	test   %eax,%eax
  801e82:	78 13                	js     801e97 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801e84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;
	//cprintf("called from file_flush\n");
	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801e88:	48 85 c0             	test   %rax,%rax
  801e8b:	74 0a                	je     801e97 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801e8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e91:	8b 00                	mov    (%rax),%eax
  801e93:	85 c0                	test   %eax,%eax
  801e95:	75 02                	jne    801e99 <file_flush+0x4d>
			continue;
  801e97:	eb 26                	jmp    801ebf <file_flush+0x73>
		flush_block(diskaddr(*pdiskbno));
  801e99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9d:	8b 00                	mov    (%rax),%eax
  801e9f:	89 c0                	mov    %eax,%eax
  801ea1:	48 89 c7             	mov    %rax,%rdi
  801ea4:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801eab:	00 00 00 
  801eae:	ff d0                	callq  *%rax
  801eb0:	48 89 c7             	mov    %rax,%rdi
  801eb3:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  801eba:	00 00 00 
  801ebd:	ff d0                	callq  *%rax
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;
	//cprintf("called from file_flush\n");
	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801ebf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ec3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ec7:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801ecd:	05 ff 0f 00 00       	add    $0xfff,%eax
  801ed2:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	0f 48 c2             	cmovs  %edx,%eax
  801edd:	c1 f8 0c             	sar    $0xc,%eax
  801ee0:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801ee3:	0f 8f 78 ff ff ff    	jg     801e61 <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eed:	48 89 c7             	mov    %rax,%rdi
  801ef0:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  801ef7:	00 00 00 
  801efa:	ff d0                	callq  *%rax
	if (f->f_indirect)
  801efc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f00:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801f06:	85 c0                	test   %eax,%eax
  801f08:	74 2a                	je     801f34 <file_flush+0xe8>
		flush_block(diskaddr(f->f_indirect));
  801f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f0e:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801f14:	89 c0                	mov    %eax,%eax
  801f16:	48 89 c7             	mov    %rax,%rdi
  801f19:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801f20:	00 00 00 
  801f23:	ff d0                	callq  *%rax
  801f25:	48 89 c7             	mov    %rax,%rdi
  801f28:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  801f2f:	00 00 00 
  801f32:	ff d0                	callq  *%rax
}
  801f34:	c9                   	leaveq 
  801f35:	c3                   	retq   

0000000000801f36 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801f36:	55                   	push   %rbp
  801f37:	48 89 e5             	mov    %rsp,%rbp
  801f3a:	48 83 ec 20          	sub    $0x20,%rsp
  801f3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801f42:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f4f:	be 00 00 00 00       	mov    $0x0,%esi
  801f54:	48 89 c7             	mov    %rax,%rdi
  801f57:	48 b8 8b 16 80 00 00 	movabs $0x80168b,%rax
  801f5e:	00 00 00 
  801f61:	ff d0                	callq  *%rax
  801f63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f6a:	79 05                	jns    801f71 <file_remove+0x3b>
		return r;
  801f6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f6f:	eb 45                	jmp    801fb6 <file_remove+0x80>

	file_truncate_blocks(f, 0);
  801f71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f75:	be 00 00 00 00       	mov    $0x0,%esi
  801f7a:	48 89 c7             	mov    %rax,%rdi
  801f7d:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  801f84:	00 00 00 
  801f87:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  801f89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8d:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  801f90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f94:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801f9b:	00 00 00 
	flush_block(f);
  801f9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa2:	48 89 c7             	mov    %rax,%rdi
  801fa5:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  801fac:	00 00 00 
  801faf:	ff d0                	callq  *%rax

	return 0;
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb6:	c9                   	leaveq 
  801fb7:	c3                   	retq   

0000000000801fb8 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801fb8:	55                   	push   %rbp
  801fb9:	48 89 e5             	mov    %rsp,%rbp
  801fbc:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801fc0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801fc7:	eb 27                	jmp    801ff0 <fs_sync+0x38>
		flush_block(diskaddr(i));
  801fc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fcc:	48 98                	cltq   
  801fce:	48 89 c7             	mov    %rax,%rdi
  801fd1:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801fd8:	00 00 00 
  801fdb:	ff d0                	callq  *%rax
  801fdd:	48 89 c7             	mov    %rax,%rdi
  801fe0:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  801fe7:	00 00 00 
  801fea:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801fec:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ff0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff3:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  801ffa:	00 00 00 
  801ffd:	48 8b 00             	mov    (%rax),%rax
  802000:	8b 40 04             	mov    0x4(%rax),%eax
  802003:	39 c2                	cmp    %eax,%edx
  802005:	72 c2                	jb     801fc9 <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  802007:	c9                   	leaveq 
  802008:	c3                   	retq   

0000000000802009 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  802009:	55                   	push   %rbp
  80200a:	48 89 e5             	mov    %rsp,%rbp
  80200d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  802011:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  802016:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  80201a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802021:	eb 4b                	jmp    80206e <serve_init+0x65>
		opentab[i].o_fileid = i;
  802023:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802026:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  80202d:	00 00 00 
  802030:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802033:	48 63 c9             	movslq %ecx,%rcx
  802036:	48 c1 e1 05          	shl    $0x5,%rcx
  80203a:	48 01 ca             	add    %rcx,%rdx
  80203d:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  80203f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802043:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  80204a:	00 00 00 
  80204d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802050:	48 63 c9             	movslq %ecx,%rcx
  802053:	48 c1 e1 05          	shl    $0x5,%rcx
  802057:	48 01 ca             	add    %rcx,%rdx
  80205a:	48 83 c2 10          	add    $0x10,%rdx
  80205e:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  802062:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  802069:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  80206a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80206e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802075:	7e ac                	jle    802023 <serve_init+0x1a>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  802077:	c9                   	leaveq 
  802078:	c3                   	retq   

0000000000802079 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  802079:	55                   	push   %rbp
  80207a:	48 89 e5             	mov    %rsp,%rbp
  80207d:	53                   	push   %rbx
  80207e:	48 83 ec 28          	sub    $0x28,%rsp
  802082:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  802086:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80208d:	e9 02 02 00 00       	jmpq   802294 <openfile_alloc+0x21b>
		switch (pageref(opentab[i].o_fd)) {
  802092:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802099:	00 00 00 
  80209c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80209f:	48 63 d2             	movslq %edx,%rdx
  8020a2:	48 c1 e2 05          	shl    $0x5,%rdx
  8020a6:	48 01 d0             	add    %rdx,%rax
  8020a9:	48 83 c0 10          	add    $0x10,%rax
  8020ad:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020b1:	48 89 c7             	mov    %rax,%rdi
  8020b4:	48 b8 b6 6a 80 00 00 	movabs $0x806ab6,%rax
  8020bb:	00 00 00 
  8020be:	ff d0                	callq  *%rax
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	74 0e                	je     8020d2 <openfile_alloc+0x59>
  8020c4:	83 f8 01             	cmp    $0x1,%eax
  8020c7:	0f 84 ec 00 00 00    	je     8021b9 <openfile_alloc+0x140>
  8020cd:	e9 be 01 00 00       	jmpq   802290 <openfile_alloc+0x217>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		#else
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  8020d2:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8020d9:	00 00 00 
  8020dc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020df:	48 63 d2             	movslq %edx,%rdx
  8020e2:	48 c1 e2 05          	shl    $0x5,%rdx
  8020e6:	48 01 d0             	add    %rdx,%rax
  8020e9:	48 83 c0 10          	add    $0x10,%rax
  8020ed:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020f1:	ba 07 00 00 00       	mov    $0x7,%edx
  8020f6:	48 89 c6             	mov    %rax,%rsi
  8020f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8020fe:	48 b8 14 4e 80 00 00 	movabs $0x804e14,%rax
  802105:	00 00 00 
  802108:	ff d0                	callq  *%rax
  80210a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80210d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802111:	79 08                	jns    80211b <openfile_alloc+0xa2>
				return r;
  802113:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802116:	e9 8b 01 00 00       	jmpq   8022a6 <openfile_alloc+0x22d>
			opentab[i].o_fileid += MAXOPEN;
  80211b:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802122:	00 00 00 
  802125:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802128:	48 63 d2             	movslq %edx,%rdx
  80212b:	48 c1 e2 05          	shl    $0x5,%rdx
  80212f:	48 01 d0             	add    %rdx,%rax
  802132:	8b 00                	mov    (%rax),%eax
  802134:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  80213a:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802141:	00 00 00 
  802144:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  802147:	48 63 c9             	movslq %ecx,%rcx
  80214a:	48 c1 e1 05          	shl    $0x5,%rcx
  80214e:	48 01 c8             	add    %rcx,%rax
  802151:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  802153:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802156:	48 98                	cltq   
  802158:	48 c1 e0 05          	shl    $0x5,%rax
  80215c:	48 89 c2             	mov    %rax,%rdx
  80215f:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802166:	00 00 00 
  802169:	48 01 c2             	add    %rax,%rdx
  80216c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802170:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  802173:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  80217a:	00 00 00 
  80217d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802180:	48 63 d2             	movslq %edx,%rdx
  802183:	48 c1 e2 05          	shl    $0x5,%rdx
  802187:	48 01 d0             	add    %rdx,%rax
  80218a:	48 83 c0 10          	add    $0x10,%rax
  80218e:	48 8b 40 08          	mov    0x8(%rax),%rax
  802192:	ba 00 10 00 00       	mov    $0x1000,%edx
  802197:	be 00 00 00 00       	mov    $0x0,%esi
  80219c:	48 89 c7             	mov    %rax,%rdi
  80219f:	48 b8 7e 47 80 00 00 	movabs $0x80477e,%rax
  8021a6:	00 00 00 
  8021a9:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  8021ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021af:	48 8b 00             	mov    (%rax),%rax
  8021b2:	8b 00                	mov    (%rax),%eax
  8021b4:	e9 ed 00 00 00       	jmpq   8022a6 <openfile_alloc+0x22d>
			break;
		case 1:
			if ((uint64_t) opentab[i].o_fd != get_host_fd()) {				
  8021b9:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8021c0:	00 00 00 
  8021c3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021c6:	48 63 d2             	movslq %edx,%rdx
  8021c9:	48 c1 e2 05          	shl    $0x5,%rdx
  8021cd:	48 01 d0             	add    %rdx,%rax
  8021d0:	48 83 c0 10          	add    $0x10,%rax
  8021d4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021d8:	48 89 c3             	mov    %rax,%rbx
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e0:	48 ba 20 33 80 00 00 	movabs $0x803320,%rdx
  8021e7:	00 00 00 
  8021ea:	ff d2                	callq  *%rdx
  8021ec:	48 39 c3             	cmp    %rax,%rbx
  8021ef:	0f 84 9b 00 00 00    	je     802290 <openfile_alloc+0x217>
				opentab[i].o_fileid += MAXOPEN;
  8021f5:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8021fc:	00 00 00 
  8021ff:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802202:	48 63 d2             	movslq %edx,%rdx
  802205:	48 c1 e2 05          	shl    $0x5,%rdx
  802209:	48 01 d0             	add    %rdx,%rax
  80220c:	8b 00                	mov    (%rax),%eax
  80220e:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  802214:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  80221b:	00 00 00 
  80221e:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  802221:	48 63 c9             	movslq %ecx,%rcx
  802224:	48 c1 e1 05          	shl    $0x5,%rcx
  802228:	48 01 c8             	add    %rcx,%rax
  80222b:	89 10                	mov    %edx,(%rax)
				*o = &opentab[i];
  80222d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802230:	48 98                	cltq   
  802232:	48 c1 e0 05          	shl    $0x5,%rax
  802236:	48 89 c2             	mov    %rax,%rdx
  802239:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802240:	00 00 00 
  802243:	48 01 c2             	add    %rax,%rdx
  802246:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80224a:	48 89 10             	mov    %rdx,(%rax)
				memset(opentab[i].o_fd, 0, PGSIZE);
  80224d:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802254:	00 00 00 
  802257:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80225a:	48 63 d2             	movslq %edx,%rdx
  80225d:	48 c1 e2 05          	shl    $0x5,%rdx
  802261:	48 01 d0             	add    %rdx,%rax
  802264:	48 83 c0 10          	add    $0x10,%rax
  802268:	48 8b 40 08          	mov    0x8(%rax),%rax
  80226c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802271:	be 00 00 00 00       	mov    $0x0,%esi
  802276:	48 89 c7             	mov    %rax,%rdi
  802279:	48 b8 7e 47 80 00 00 	movabs $0x80477e,%rax
  802280:	00 00 00 
  802283:	ff d0                	callq  *%rax
				return (*o)->o_fileid;
  802285:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802289:	48 8b 00             	mov    (%rax),%rax
  80228c:	8b 00                	mov    (%rax),%eax
  80228e:	eb 16                	jmp    8022a6 <openfile_alloc+0x22d>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  802290:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  802294:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%rbp)
  80229b:	0f 8e f1 fd ff ff    	jle    802092 <openfile_alloc+0x19>
			}
		#endif
		}
	}
	//cprintf("am I returning from here ????");
	return -E_MAX_OPEN;
  8022a1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022a6:	48 83 c4 28          	add    $0x28,%rsp
  8022aa:	5b                   	pop    %rbx
  8022ab:	5d                   	pop    %rbp
  8022ac:	c3                   	retq   

00000000008022ad <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8022ad:	55                   	push   %rbp
  8022ae:	48 89 e5             	mov    %rsp,%rbp
  8022b1:	48 83 ec 20          	sub    $0x20,%rsp
  8022b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022b8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8022bb:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8022bf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022c7:	89 c0                	mov    %eax,%eax
  8022c9:	48 c1 e0 05          	shl    $0x5,%rax
  8022cd:	48 89 c2             	mov    %rax,%rdx
  8022d0:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8022d7:	00 00 00 
  8022da:	48 01 d0             	add    %rdx,%rax
  8022dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  8022e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022e9:	48 89 c7             	mov    %rax,%rdi
  8022ec:	48 b8 b6 6a 80 00 00 	movabs $0x806ab6,%rax
  8022f3:	00 00 00 
  8022f6:	ff d0                	callq  *%rax
  8022f8:	83 f8 01             	cmp    $0x1,%eax
  8022fb:	74 0b                	je     802308 <openfile_lookup+0x5b>
  8022fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802301:	8b 00                	mov    (%rax),%eax
  802303:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802306:	74 07                	je     80230f <openfile_lookup+0x62>
		return -E_INVAL;
  802308:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80230d:	eb 10                	jmp    80231f <openfile_lookup+0x72>
	*po = o;
  80230f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802313:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802317:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80231a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80231f:	c9                   	leaveq 
  802320:	c3                   	retq   

0000000000802321 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  802321:	55                   	push   %rbp
  802322:	48 89 e5             	mov    %rsp,%rbp
  802325:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  80232c:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  802332:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  802339:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  802340:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802347:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  80234e:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802355:	ba 00 04 00 00       	mov    $0x400,%edx
  80235a:	48 89 ce             	mov    %rcx,%rsi
  80235d:	48 89 c7             	mov    %rax,%rdi
  802360:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  802367:	00 00 00 
  80236a:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  80236c:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  802370:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  802377:	48 89 c7             	mov    %rax,%rdi
  80237a:	48 b8 79 20 80 00 00 	movabs $0x802079,%rax
  802381:	00 00 00 
  802384:	ff d0                	callq  *%rax
  802386:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802389:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238d:	79 08                	jns    802397 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  80238f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802392:	e9 7c 01 00 00       	jmpq   802513 <serve_open+0x1f2>
	}
	fileid = r;
  802397:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80239a:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  80239d:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8023a4:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8023aa:	25 00 01 00 00       	and    $0x100,%eax
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	74 4f                	je     802402 <serve_open+0xe1>
		if ((r = file_create(path, &f)) < 0) {
  8023b3:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  8023ba:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8023c1:	48 89 d6             	mov    %rdx,%rsi
  8023c4:	48 89 c7             	mov    %rax,%rdi
  8023c7:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  8023ce:	00 00 00 
  8023d1:	ff d0                	callq  *%rax
  8023d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023da:	79 57                	jns    802433 <serve_open+0x112>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8023dc:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8023e3:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8023e9:	25 00 04 00 00       	and    $0x400,%eax
  8023ee:	85 c0                	test   %eax,%eax
  8023f0:	75 08                	jne    8023fa <serve_open+0xd9>
  8023f2:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  8023f6:	75 02                	jne    8023fa <serve_open+0xd9>
				goto try_open;
  8023f8:	eb 08                	jmp    802402 <serve_open+0xe1>
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  8023fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fd:	e9 11 01 00 00       	jmpq   802513 <serve_open+0x1f2>
		}
	} else {
	try_open:
		if ((r = file_open(path, &f)) < 0) {
  802402:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  802409:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802410:	48 89 d6             	mov    %rdx,%rsi
  802413:	48 89 c7             	mov    %rax,%rdi
  802416:	48 b8 c0 19 80 00 00 	movabs $0x8019c0,%rax
  80241d:	00 00 00 
  802420:	ff d0                	callq  *%rax
  802422:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802425:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802429:	79 08                	jns    802433 <serve_open+0x112>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  80242b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80242e:	e9 e0 00 00 00       	jmpq   802513 <serve_open+0x1f2>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  802433:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  80243a:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  802440:	25 00 02 00 00       	and    $0x200,%eax
  802445:	85 c0                	test   %eax,%eax
  802447:	74 2c                	je     802475 <serve_open+0x154>
		if ((r = file_set_size(f, 0)) < 0) {
  802449:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  802450:	be 00 00 00 00       	mov    $0x0,%esi
  802455:	48 89 c7             	mov    %rax,%rdi
  802458:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  80245f:	00 00 00 
  802462:	ff d0                	callq  *%rax
  802464:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802467:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246b:	79 08                	jns    802475 <serve_open+0x154>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  80246d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802470:	e9 9e 00 00 00       	jmpq   802513 <serve_open+0x1f2>
		}
	}

	// Save the file pointer
	o->o_file = f;
  802475:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80247c:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  802483:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  802487:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80248e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802492:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  802499:	8b 12                	mov    (%rdx),%edx
  80249b:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80249e:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8024a5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024a9:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8024b0:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8024b6:	83 e2 03             	and    $0x3,%edx
  8024b9:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  8024bc:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8024c3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024c7:	48 ba e0 20 81 00 00 	movabs $0x8120e0,%rdx
  8024ce:	00 00 00 
  8024d1:	8b 12                	mov    (%rdx),%edx
  8024d3:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  8024d5:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8024dc:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8024e3:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8024e9:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  8024ec:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8024f3:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8024f7:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  8024fe:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  802501:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  802508:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802513:	c9                   	leaveq 
  802514:	c3                   	retq   

0000000000802515 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  802515:	55                   	push   %rbp
  802516:	48 89 e5             	mov    %rsp,%rbp
  802519:	48 83 ec 20          	sub    $0x20,%rsp
  80251d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802520:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802524:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802528:	8b 00                	mov    (%rax),%eax
  80252a:	89 c1                	mov    %eax,%ecx
  80252c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802530:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802533:	89 ce                	mov    %ecx,%esi
  802535:	89 c7                	mov    %eax,%edi
  802537:	48 b8 ad 22 80 00 00 	movabs $0x8022ad,%rax
  80253e:	00 00 00 
  802541:	ff d0                	callq  *%rax
  802543:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802546:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254a:	79 05                	jns    802551 <serve_set_size+0x3c>
		return r;
  80254c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254f:	eb 20                	jmp    802571 <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  802551:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802555:	8b 50 04             	mov    0x4(%rax),%edx
  802558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802560:	89 d6                	mov    %edx,%esi
  802562:	48 89 c7             	mov    %rax,%rdi
  802565:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  80256c:	00 00 00 
  80256f:	ff d0                	callq  *%rax
}
  802571:	c9                   	leaveq 
  802572:	c3                   	retq   

0000000000802573 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  802573:	55                   	push   %rbp
  802574:	48 89 e5             	mov    %rsp,%rbp
  802577:	48 83 ec 30          	sub    $0x30,%rsp
  80257b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80257e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r = -1;
  802582:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!ipc)
  802589:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80258e:	75 08                	jne    802598 <serve_read+0x25>
		return r; 
  802590:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802593:	e9 e0 00 00 00       	jmpq   802678 <serve_read+0x105>
	struct Fsreq_read *req = &ipc->read;
  802598:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80259c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  8025a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025a4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// (remember that read is always allowed to return fewer bytes
	// than requested).  Also, be careful because ipc is a union,
	// so filling in ret will overwrite req.
	//
	// LAB 5: Your code here
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8025a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ac:	8b 00                	mov    (%rax),%eax
  8025ae:	89 c1                	mov    %eax,%ecx
  8025b0:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8025b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025b7:	89 ce                	mov    %ecx,%esi
  8025b9:	89 c7                	mov    %eax,%edi
  8025bb:	48 b8 ad 22 80 00 00 	movabs $0x8022ad,%rax
  8025c2:	00 00 00 
  8025c5:	ff d0                	callq  *%rax
  8025c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ce:	79 08                	jns    8025d8 <serve_read+0x65>
		return r;
  8025d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d3:	e9 a0 00 00 00       	jmpq   802678 <serve_read+0x105>

	if(!o || !o->o_file || !o->o_fd)
  8025d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025dc:	48 85 c0             	test   %rax,%rax
  8025df:	74 1a                	je     8025fb <serve_read+0x88>
  8025e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025e5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025e9:	48 85 c0             	test   %rax,%rax
  8025ec:	74 0d                	je     8025fb <serve_read+0x88>
  8025ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025f2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025f6:	48 85 c0             	test   %rax,%rax
  8025f9:	75 07                	jne    802602 <serve_read+0x8f>
	{
		return -1;
  8025fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802600:	eb 76                	jmp    802678 <serve_read+0x105>
	}
	if(req->req_n > PGSIZE)
  802602:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802606:	48 8b 40 08          	mov    0x8(%rax),%rax
  80260a:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
  802610:	76 0c                	jbe    80261e <serve_read+0xab>
	{
		req->req_n = PGSIZE;
  802612:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802616:	48 c7 40 08 00 10 00 	movq   $0x1000,0x8(%rax)
  80261d:	00 
	}
	
	if ((r = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset)) <= 0) {
  80261e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802622:	48 8b 40 18          	mov    0x18(%rax),%rax
  802626:	8b 48 04             	mov    0x4(%rax),%ecx
  802629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802631:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  802635:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802639:	48 8b 40 08          	mov    0x8(%rax),%rax
  80263d:	48 89 c7             	mov    %rax,%rdi
  802640:	48 b8 f3 19 80 00 00 	movabs $0x8019f3,%rax
  802647:	00 00 00 
  80264a:	ff d0                	callq  *%rax
  80264c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802653:	7f 05                	jg     80265a <serve_read+0xe7>
		if (debug)
		cprintf("file_read failed: %e", r);
		return r;
  802655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802658:	eb 1e                	jmp    802678 <serve_read+0x105>
	}
	//cprintf("server in serve_read()  is [%d]  %x %x %x %x\n",r,ret->ret_buf[0], ret->ret_buf[1], ret->ret_buf[2], ret->ret_buf[3]);
	o->o_fd->fd_offset += r;
  80265a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80265e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802662:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802666:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  80266a:	8b 4a 04             	mov    0x4(%rdx),%ecx
  80266d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802670:	01 ca                	add    %ecx,%edx
  802672:	89 50 04             	mov    %edx,0x4(%rax)
	
	return r;
  802675:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("serve_read not implemented");
}
  802678:	c9                   	leaveq 
  802679:	c3                   	retq   

000000000080267a <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  80267a:	55                   	push   %rbp
  80267b:	48 89 e5             	mov    %rsp,%rbp
  80267e:	48 83 ec 20          	sub    $0x20,%rsp
  802682:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802685:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r = -1;
  802689:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!req)
  802690:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802695:	75 08                	jne    80269f <serve_write+0x25>
		return r;
  802697:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269a:	e9 d8 00 00 00       	jmpq   802777 <serve_write+0xfd>

	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80269f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026a3:	8b 00                	mov    (%rax),%eax
  8026a5:	89 c1                	mov    %eax,%ecx
  8026a7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026ae:	89 ce                	mov    %ecx,%esi
  8026b0:	89 c7                	mov    %eax,%edi
  8026b2:	48 b8 ad 22 80 00 00 	movabs $0x8022ad,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	callq  *%rax
  8026be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c5:	79 08                	jns    8026cf <serve_write+0x55>
		return r;
  8026c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ca:	e9 a8 00 00 00       	jmpq   802777 <serve_write+0xfd>

	if(!o || !o->o_file || !o->o_fd)
  8026cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d3:	48 85 c0             	test   %rax,%rax
  8026d6:	74 1a                	je     8026f2 <serve_write+0x78>
  8026d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026dc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8026e0:	48 85 c0             	test   %rax,%rax
  8026e3:	74 0d                	je     8026f2 <serve_write+0x78>
  8026e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026ed:	48 85 c0             	test   %rax,%rax
  8026f0:	75 07                	jne    8026f9 <serve_write+0x7f>
		return -1;
  8026f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8026f7:	eb 7e                	jmp    802777 <serve_write+0xfd>
	
	if ((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0) {
  8026f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026fd:	48 8b 40 18          	mov    0x18(%rax),%rax
  802701:	8b 48 04             	mov    0x4(%rax),%ecx
  802704:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802708:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80270c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802710:	48 8d 70 10          	lea    0x10(%rax),%rsi
  802714:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802718:	48 8b 40 08          	mov    0x8(%rax),%rax
  80271c:	48 89 c7             	mov    %rax,%rdi
  80271f:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  802726:	00 00 00 
  802729:	ff d0                	callq  *%rax
  80272b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80272e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802732:	79 25                	jns    802759 <serve_write+0xdf>
		cprintf("file_write failed: %e", r);
  802734:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802737:	89 c6                	mov    %eax,%esi
  802739:	48 bf 10 78 80 00 00 	movabs $0x807810,%rdi
  802740:	00 00 00 
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
  802748:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  80274f:	00 00 00 
  802752:	ff d2                	callq  *%rdx
		return r;
  802754:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802757:	eb 1e                	jmp    802777 <serve_write+0xfd>
	}
	o->o_fd->fd_offset += r;
  802759:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802761:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802765:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  802769:	8b 4a 04             	mov    0x4(%rdx),%ecx
  80276c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80276f:	01 ca                	add    %ecx,%edx
  802771:	89 50 04             	mov    %edx,0x4(%rax)
	
	return r;
  802774:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("serve_write not implemented");
}
  802777:	c9                   	leaveq 
  802778:	c3                   	retq   

0000000000802779 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  802779:	55                   	push   %rbp
  80277a:	48 89 e5             	mov    %rsp,%rbp
  80277d:	48 83 ec 30          	sub    $0x30,%rsp
  802781:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802784:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  802788:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80278c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  802790:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802794:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802798:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80279c:	8b 00                	mov    (%rax),%eax
  80279e:	89 c1                	mov    %eax,%ecx
  8027a0:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8027a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027a7:	89 ce                	mov    %ecx,%esi
  8027a9:	89 c7                	mov    %eax,%edi
  8027ab:	48 b8 ad 22 80 00 00 	movabs $0x8022ad,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	callq  *%rax
  8027b7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027be:	79 05                	jns    8027c5 <serve_stat+0x4c>
		return r;
  8027c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027c3:	eb 5f                	jmp    802824 <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  8027c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8027cd:	48 89 c2             	mov    %rax,%rdx
  8027d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d4:	48 89 d6             	mov    %rdx,%rsi
  8027d7:	48 89 c7             	mov    %rax,%rdi
  8027da:	48 b8 e5 44 80 00 00 	movabs $0x8044e5,%rax
  8027e1:	00 00 00 
  8027e4:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  8027e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ea:	48 8b 40 08          	mov    0x8(%rax),%rax
  8027ee:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8027f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8027fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802802:	48 8b 40 08          	mov    0x8(%rax),%rax
  802806:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80280c:	83 f8 01             	cmp    $0x1,%eax
  80280f:	0f 94 c0             	sete   %al
  802812:	0f b6 d0             	movzbl %al,%edx
  802815:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802819:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80281f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802824:	c9                   	leaveq 
  802825:	c3                   	retq   

0000000000802826 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  802826:	55                   	push   %rbp
  802827:	48 89 e5             	mov    %rsp,%rbp
  80282a:	48 83 ec 20          	sub    $0x20,%rsp
  80282e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802831:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802835:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802839:	8b 00                	mov    (%rax),%eax
  80283b:	89 c1                	mov    %eax,%ecx
  80283d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802841:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802844:	89 ce                	mov    %ecx,%esi
  802846:	89 c7                	mov    %eax,%edi
  802848:	48 b8 ad 22 80 00 00 	movabs $0x8022ad,%rax
  80284f:	00 00 00 
  802852:	ff d0                	callq  *%rax
  802854:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802857:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285b:	79 05                	jns    802862 <serve_flush+0x3c>
		return r;
  80285d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802860:	eb 1c                	jmp    80287e <serve_flush+0x58>
	file_flush(o->o_file);
  802862:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802866:	48 8b 40 08          	mov    0x8(%rax),%rax
  80286a:	48 89 c7             	mov    %rax,%rdi
  80286d:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802874:	00 00 00 
  802877:	ff d0                	callq  *%rax
	return 0;
  802879:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80287e:	c9                   	leaveq 
  80287f:	c3                   	retq   

0000000000802880 <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  802880:	55                   	push   %rbp
  802881:	48 89 e5             	mov    %rsp,%rbp
  802884:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  80288b:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  802891:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802898:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  80289f:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  8028a6:	ba 00 04 00 00       	mov    $0x400,%edx
  8028ab:	48 89 ce             	mov    %rcx,%rsi
  8028ae:	48 89 c7             	mov    %rax,%rdi
  8028b1:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  8028b8:	00 00 00 
  8028bb:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8028bd:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  8028c1:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  8028c8:	48 89 c7             	mov    %rax,%rdi
  8028cb:	48 b8 36 1f 80 00 00 	movabs $0x801f36,%rax
  8028d2:	00 00 00 
  8028d5:	ff d0                	callq  *%rax
}
  8028d7:	c9                   	leaveq 
  8028d8:	c3                   	retq   

00000000008028d9 <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  8028d9:	55                   	push   %rbp
  8028da:	48 89 e5             	mov    %rsp,%rbp
  8028dd:	48 83 ec 10          	sub    $0x10,%rsp
  8028e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8028e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  8028e8:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  8028ef:	00 00 00 
  8028f2:	ff d0                	callq  *%rax
	return 0;
  8028f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f9:	c9                   	leaveq 
  8028fa:	c3                   	retq   

00000000008028fb <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  8028fb:	55                   	push   %rbp
  8028fc:	48 89 e5             	mov    %rsp,%rbp
  8028ff:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  802903:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80290a:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  802911:	00 00 00 
  802914:	48 8b 08             	mov    (%rax),%rcx
  802917:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80291b:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  80291f:	48 89 ce             	mov    %rcx,%rsi
  802922:	48 89 c7             	mov    %rax,%rdi
  802925:	48 b8 a4 52 80 00 00 	movabs $0x8052a4,%rax
  80292c:	00 00 00 
  80292f:	ff d0                	callq  *%rax
  802931:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  802934:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802937:	83 e0 01             	and    $0x1,%eax
  80293a:	85 c0                	test   %eax,%eax
  80293c:	75 23                	jne    802961 <serve+0x66>
			cprintf("Invalid request from %08x: no argument page\n",
  80293e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802941:	89 c6                	mov    %eax,%esi
  802943:	48 bf 28 78 80 00 00 	movabs $0x807828,%rdi
  80294a:	00 00 00 
  80294d:	b8 00 00 00 00       	mov    $0x0,%eax
  802952:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  802959:	00 00 00 
  80295c:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  80295e:	90                   	nop
		}
		ipc_send(whom, r, pg, perm);
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
	}
  80295f:	eb a2                	jmp    802903 <serve+0x8>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  802961:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802968:	00 
		if (req == FSREQ_OPEN) {
  802969:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  80296d:	75 2b                	jne    80299a <serve+0x9f>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  80296f:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  802976:	00 00 00 
  802979:	48 8b 30             	mov    (%rax),%rsi
  80297c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80297f:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  802983:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802987:	89 c7                	mov    %eax,%edi
  802989:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  802990:	00 00 00 
  802993:	ff d0                	callq  *%rax
  802995:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802998:	eb 73                	jmp    802a0d <serve+0x112>
		} else if (req < NHANDLERS && handlers[req]) {
  80299a:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  80299e:	77 43                	ja     8029e3 <serve+0xe8>
  8029a0:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  8029a7:	00 00 00 
  8029aa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8029ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029b1:	48 85 c0             	test   %rax,%rax
  8029b4:	74 2d                	je     8029e3 <serve+0xe8>
			r = handlers[req](whom, fsreq);
  8029b6:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  8029bd:	00 00 00 
  8029c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8029c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029c7:	48 ba 20 20 81 00 00 	movabs $0x812020,%rdx
  8029ce:	00 00 00 
  8029d1:	48 8b 0a             	mov    (%rdx),%rcx
  8029d4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029d7:	48 89 ce             	mov    %rcx,%rsi
  8029da:	89 d7                	mov    %edx,%edi
  8029dc:	ff d0                	callq  *%rax
  8029de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e1:	eb 2a                	jmp    802a0d <serve+0x112>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8029e3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029e9:	89 c6                	mov    %eax,%esi
  8029eb:	48 bf 58 78 80 00 00 	movabs $0x807858,%rdi
  8029f2:	00 00 00 
  8029f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fa:	48 b9 30 39 80 00 00 	movabs $0x803930,%rcx
  802a01:	00 00 00 
  802a04:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  802a06:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  802a0d:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  802a10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a14:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a17:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a1a:	89 c7                	mov    %eax,%edi
  802a1c:	48 b8 a2 53 80 00 00 	movabs $0x8053a2,%rax
  802a23:	00 00 00 
  802a26:	ff d0                	callq  *%rax
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
  802a28:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  802a2f:	00 00 00 
  802a32:	48 8b 00             	mov    (%rax),%rax
  802a35:	48 89 c6             	mov    %rax,%rsi
  802a38:	bf 00 00 00 00       	mov    $0x0,%edi
  802a3d:	48 b8 bf 4e 80 00 00 	movabs $0x804ebf,%rax
  802a44:	00 00 00 
  802a47:	ff d0                	callq  *%rax
	}
  802a49:	e9 b5 fe ff ff       	jmpq   802903 <serve+0x8>

0000000000802a4e <umain>:
}

void
umain(int argc, char **argv)
{
  802a4e:	55                   	push   %rbp
  802a4f:	48 89 e5             	mov    %rsp,%rbp
  802a52:	48 83 ec 20          	sub    $0x20,%rsp
  802a56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  802a5d:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  802a64:	00 00 00 
  802a67:	48 b9 7b 78 80 00 00 	movabs $0x80787b,%rcx
  802a6e:	00 00 00 
  802a71:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  802a74:	48 bf 7e 78 80 00 00 	movabs $0x80787e,%rdi
  802a7b:	00 00 00 
  802a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a83:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  802a8a:	00 00 00 
  802a8d:	ff d2                	callq  *%rdx
  802a8f:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  802a96:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

    static __inline void
outw(int port, uint16_t data)
{
    __asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  802a9c:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  802aa0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802aa3:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  802aa5:	48 bf 8d 78 80 00 00 	movabs $0x80788d,%rdi
  802aac:	00 00 00 
  802aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab4:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  802abb:	00 00 00 
  802abe:	ff d2                	callq  *%rdx

	serve_init();
  802ac0:	48 b8 09 20 80 00 00 	movabs $0x802009,%rax
  802ac7:	00 00 00 
  802aca:	ff d0                	callq  *%rax
	fs_init();
  802acc:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
	serve();
  802ad8:	48 b8 fb 28 80 00 00 	movabs $0x8028fb,%rax
  802adf:	00 00 00 
  802ae2:	ff d0                	callq  *%rax
}
  802ae4:	c9                   	leaveq 
  802ae5:	c3                   	retq   

0000000000802ae6 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  802ae6:	55                   	push   %rbp
  802ae7:	48 89 e5             	mov    %rsp,%rbp
  802aea:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802aee:	ba 07 00 00 00       	mov    $0x7,%edx
  802af3:	be 00 10 00 00       	mov    $0x1000,%esi
  802af8:	bf 00 00 00 00       	mov    $0x0,%edi
  802afd:	48 b8 14 4e 80 00 00 	movabs $0x804e14,%rax
  802b04:	00 00 00 
  802b07:	ff d0                	callq  *%rax
  802b09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b10:	79 30                	jns    802b42 <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  802b12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b15:	89 c1                	mov    %eax,%ecx
  802b17:	48 ba c6 78 80 00 00 	movabs $0x8078c6,%rdx
  802b1e:	00 00 00 
  802b21:	be 13 00 00 00       	mov    $0x13,%esi
  802b26:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802b2d:	00 00 00 
  802b30:	b8 00 00 00 00       	mov    $0x0,%eax
  802b35:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  802b3c:	00 00 00 
  802b3f:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  802b42:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  802b49:	00 
	memmove(bits, bitmap, PGSIZE);
  802b4a:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  802b51:	00 00 00 
  802b54:	48 8b 08             	mov    (%rax),%rcx
  802b57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b5b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b60:	48 89 ce             	mov    %rcx,%rsi
  802b63:	48 89 c7             	mov    %rax,%rdi
  802b66:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  802b6d:	00 00 00 
  802b70:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  802b72:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  802b79:	00 00 00 
  802b7c:	ff d0                	callq  *%rax
  802b7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b85:	79 30                	jns    802bb7 <fs_test+0xd1>
		panic("alloc_block: %e", r);
  802b87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8a:	89 c1                	mov    %eax,%ecx
  802b8c:	48 ba e3 78 80 00 00 	movabs $0x8078e3,%rdx
  802b93:	00 00 00 
  802b96:	be 18 00 00 00       	mov    $0x18,%esi
  802b9b:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802ba2:	00 00 00 
  802ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  802baa:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  802bb1:	00 00 00 
  802bb4:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  802bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bba:	8d 50 1f             	lea    0x1f(%rax),%edx
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	0f 48 c2             	cmovs  %edx,%eax
  802bc2:	c1 f8 05             	sar    $0x5,%eax
  802bc5:	48 98                	cltq   
  802bc7:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  802bce:	00 
  802bcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd3:	48 01 d0             	add    %rdx,%rax
  802bd6:	8b 30                	mov    (%rax),%esi
  802bd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdb:	99                   	cltd   
  802bdc:	c1 ea 1b             	shr    $0x1b,%edx
  802bdf:	01 d0                	add    %edx,%eax
  802be1:	83 e0 1f             	and    $0x1f,%eax
  802be4:	29 d0                	sub    %edx,%eax
  802be6:	ba 01 00 00 00       	mov    $0x1,%edx
  802beb:	89 c1                	mov    %eax,%ecx
  802bed:	d3 e2                	shl    %cl,%edx
  802bef:	89 d0                	mov    %edx,%eax
  802bf1:	21 f0                	and    %esi,%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	75 35                	jne    802c2c <fs_test+0x146>
  802bf7:	48 b9 f3 78 80 00 00 	movabs $0x8078f3,%rcx
  802bfe:	00 00 00 
  802c01:	48 ba 0e 79 80 00 00 	movabs $0x80790e,%rdx
  802c08:	00 00 00 
  802c0b:	be 1a 00 00 00       	mov    $0x1a,%esi
  802c10:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802c17:	00 00 00 
  802c1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1f:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  802c26:	00 00 00 
  802c29:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  802c2c:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  802c33:	00 00 00 
  802c36:	48 8b 10             	mov    (%rax),%rdx
  802c39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3c:	8d 48 1f             	lea    0x1f(%rax),%ecx
  802c3f:	85 c0                	test   %eax,%eax
  802c41:	0f 48 c1             	cmovs  %ecx,%eax
  802c44:	c1 f8 05             	sar    $0x5,%eax
  802c47:	48 98                	cltq   
  802c49:	48 c1 e0 02          	shl    $0x2,%rax
  802c4d:	48 01 d0             	add    %rdx,%rax
  802c50:	8b 30                	mov    (%rax),%esi
  802c52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c55:	99                   	cltd   
  802c56:	c1 ea 1b             	shr    $0x1b,%edx
  802c59:	01 d0                	add    %edx,%eax
  802c5b:	83 e0 1f             	and    $0x1f,%eax
  802c5e:	29 d0                	sub    %edx,%eax
  802c60:	ba 01 00 00 00       	mov    $0x1,%edx
  802c65:	89 c1                	mov    %eax,%ecx
  802c67:	d3 e2                	shl    %cl,%edx
  802c69:	89 d0                	mov    %edx,%eax
  802c6b:	21 f0                	and    %esi,%eax
  802c6d:	85 c0                	test   %eax,%eax
  802c6f:	74 35                	je     802ca6 <fs_test+0x1c0>
  802c71:	48 b9 28 79 80 00 00 	movabs $0x807928,%rcx
  802c78:	00 00 00 
  802c7b:	48 ba 0e 79 80 00 00 	movabs $0x80790e,%rdx
  802c82:	00 00 00 
  802c85:	be 1c 00 00 00       	mov    $0x1c,%esi
  802c8a:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802c91:	00 00 00 
  802c94:	b8 00 00 00 00       	mov    $0x0,%eax
  802c99:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  802ca0:	00 00 00 
  802ca3:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  802ca6:	48 bf 48 79 80 00 00 	movabs $0x807948,%rdi
  802cad:	00 00 00 
  802cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb5:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  802cbc:	00 00 00 
  802cbf:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802cc1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802cc5:	48 89 c6             	mov    %rax,%rsi
  802cc8:	48 bf 5d 79 80 00 00 	movabs $0x80795d,%rdi
  802ccf:	00 00 00 
  802cd2:	48 b8 c0 19 80 00 00 	movabs $0x8019c0,%rax
  802cd9:	00 00 00 
  802cdc:	ff d0                	callq  *%rax
  802cde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce5:	79 36                	jns    802d1d <fs_test+0x237>
  802ce7:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  802ceb:	74 30                	je     802d1d <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  802ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf0:	89 c1                	mov    %eax,%ecx
  802cf2:	48 ba 68 79 80 00 00 	movabs $0x807968,%rdx
  802cf9:	00 00 00 
  802cfc:	be 20 00 00 00       	mov    $0x20,%esi
  802d01:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802d08:	00 00 00 
  802d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d10:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  802d17:	00 00 00 
  802d1a:	41 ff d0             	callq  *%r8
	else if (r == 0)
  802d1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d21:	75 2a                	jne    802d4d <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802d23:	48 ba 88 79 80 00 00 	movabs $0x807988,%rdx
  802d2a:	00 00 00 
  802d2d:	be 22 00 00 00       	mov    $0x22,%esi
  802d32:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802d39:	00 00 00 
  802d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d41:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  802d48:	00 00 00 
  802d4b:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  802d4d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802d51:	48 89 c6             	mov    %rax,%rsi
  802d54:	48 bf a8 79 80 00 00 	movabs $0x8079a8,%rdi
  802d5b:	00 00 00 
  802d5e:	48 b8 c0 19 80 00 00 	movabs $0x8019c0,%rax
  802d65:	00 00 00 
  802d68:	ff d0                	callq  *%rax
  802d6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d71:	79 30                	jns    802da3 <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  802d73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d76:	89 c1                	mov    %eax,%ecx
  802d78:	48 ba b1 79 80 00 00 	movabs $0x8079b1,%rdx
  802d7f:	00 00 00 
  802d82:	be 24 00 00 00       	mov    $0x24,%esi
  802d87:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802d8e:	00 00 00 
  802d91:	b8 00 00 00 00       	mov    $0x0,%eax
  802d96:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  802d9d:	00 00 00 
  802da0:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  802da3:	48 bf c8 79 80 00 00 	movabs $0x8079c8,%rdi
  802daa:	00 00 00 
  802dad:	b8 00 00 00 00       	mov    $0x0,%eax
  802db2:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  802db9:	00 00 00 
  802dbc:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802dbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc2:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802dc6:	be 00 00 00 00       	mov    $0x0,%esi
  802dcb:	48 89 c7             	mov    %rax,%rdi
  802dce:	48 b8 b8 12 80 00 00 	movabs $0x8012b8,%rax
  802dd5:	00 00 00 
  802dd8:	ff d0                	callq  *%rax
  802dda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ddd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de1:	79 30                	jns    802e13 <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802de3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de6:	89 c1                	mov    %eax,%ecx
  802de8:	48 ba db 79 80 00 00 	movabs $0x8079db,%rdx
  802def:	00 00 00 
  802df2:	be 28 00 00 00       	mov    $0x28,%esi
  802df7:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802dfe:	00 00 00 
  802e01:	b8 00 00 00 00       	mov    $0x0,%eax
  802e06:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  802e0d:	00 00 00 
  802e10:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802e13:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  802e1a:	00 00 00 
  802e1d:	48 8b 10             	mov    (%rax),%rdx
  802e20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e24:	48 89 d6             	mov    %rdx,%rsi
  802e27:	48 89 c7             	mov    %rax,%rdi
  802e2a:	48 b8 47 46 80 00 00 	movabs $0x804647,%rax
  802e31:	00 00 00 
  802e34:	ff d0                	callq  *%rax
  802e36:	85 c0                	test   %eax,%eax
  802e38:	74 2a                	je     802e64 <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  802e3a:	48 ba f0 79 80 00 00 	movabs $0x8079f0,%rdx
  802e41:	00 00 00 
  802e44:	be 2a 00 00 00       	mov    $0x2a,%esi
  802e49:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802e50:	00 00 00 
  802e53:	b8 00 00 00 00       	mov    $0x0,%eax
  802e58:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  802e5f:	00 00 00 
  802e62:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  802e64:	48 bf 13 7a 80 00 00 	movabs $0x807a13,%rdi
  802e6b:	00 00 00 
  802e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e73:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  802e7a:	00 00 00 
  802e7d:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802e7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e83:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e87:	0f b6 12             	movzbl (%rdx),%edx
  802e8a:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802e8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e90:	48 c1 e8 0c          	shr    $0xc,%rax
  802e94:	48 89 c2             	mov    %rax,%rdx
  802e97:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e9e:	01 00 00 
  802ea1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ea5:	83 e0 40             	and    $0x40,%eax
  802ea8:	48 85 c0             	test   %rax,%rax
  802eab:	75 35                	jne    802ee2 <fs_test+0x3fc>
  802ead:	48 b9 2b 7a 80 00 00 	movabs $0x807a2b,%rcx
  802eb4:	00 00 00 
  802eb7:	48 ba 0e 79 80 00 00 	movabs $0x80790e,%rdx
  802ebe:	00 00 00 
  802ec1:	be 2e 00 00 00       	mov    $0x2e,%esi
  802ec6:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802ecd:	00 00 00 
  802ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed5:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  802edc:	00 00 00 
  802edf:	41 ff d0             	callq  *%r8
	file_flush(f);
  802ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee6:	48 89 c7             	mov    %rax,%rdi
  802ee9:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802ef0:	00 00 00 
  802ef3:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802ef5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef9:	48 c1 e8 0c          	shr    $0xc,%rax
  802efd:	48 89 c2             	mov    %rax,%rdx
  802f00:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f07:	01 00 00 
  802f0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f0e:	83 e0 40             	and    $0x40,%eax
  802f11:	48 85 c0             	test   %rax,%rax
  802f14:	74 35                	je     802f4b <fs_test+0x465>
  802f16:	48 b9 46 7a 80 00 00 	movabs $0x807a46,%rcx
  802f1d:	00 00 00 
  802f20:	48 ba 0e 79 80 00 00 	movabs $0x80790e,%rdx
  802f27:	00 00 00 
  802f2a:	be 30 00 00 00       	mov    $0x30,%esi
  802f2f:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802f36:	00 00 00 
  802f39:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3e:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  802f45:	00 00 00 
  802f48:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802f4b:	48 bf 62 7a 80 00 00 	movabs $0x807a62,%rdi
  802f52:	00 00 00 
  802f55:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5a:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  802f61:	00 00 00 
  802f64:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802f66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6a:	be 00 00 00 00       	mov    $0x0,%esi
  802f6f:	48 89 c7             	mov    %rax,%rdi
  802f72:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
  802f7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f85:	79 30                	jns    802fb7 <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802f87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8a:	89 c1                	mov    %eax,%ecx
  802f8c:	48 ba 76 7a 80 00 00 	movabs $0x807a76,%rdx
  802f93:	00 00 00 
  802f96:	be 34 00 00 00       	mov    $0x34,%esi
  802f9b:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802fa2:	00 00 00 
  802fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  802faa:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  802fb1:	00 00 00 
  802fb4:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802fb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fbb:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802fc1:	85 c0                	test   %eax,%eax
  802fc3:	74 35                	je     802ffa <fs_test+0x514>
  802fc5:	48 b9 88 7a 80 00 00 	movabs $0x807a88,%rcx
  802fcc:	00 00 00 
  802fcf:	48 ba 0e 79 80 00 00 	movabs $0x80790e,%rdx
  802fd6:	00 00 00 
  802fd9:	be 35 00 00 00       	mov    $0x35,%esi
  802fde:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  802fe5:	00 00 00 
  802fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fed:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  802ff4:	00 00 00 
  802ff7:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802ffa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ffe:	48 c1 e8 0c          	shr    $0xc,%rax
  803002:	48 89 c2             	mov    %rax,%rdx
  803005:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80300c:	01 00 00 
  80300f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803013:	83 e0 40             	and    $0x40,%eax
  803016:	48 85 c0             	test   %rax,%rax
  803019:	74 35                	je     803050 <fs_test+0x56a>
  80301b:	48 b9 9c 7a 80 00 00 	movabs $0x807a9c,%rcx
  803022:	00 00 00 
  803025:	48 ba 0e 79 80 00 00 	movabs $0x80790e,%rdx
  80302c:	00 00 00 
  80302f:	be 36 00 00 00       	mov    $0x36,%esi
  803034:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  80303b:	00 00 00 
  80303e:	b8 00 00 00 00       	mov    $0x0,%eax
  803043:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  80304a:	00 00 00 
  80304d:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  803050:	48 bf b6 7a 80 00 00 	movabs $0x807ab6,%rdi
  803057:	00 00 00 
  80305a:	b8 00 00 00 00       	mov    $0x0,%eax
  80305f:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  803066:	00 00 00 
  803069:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  80306b:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  803072:	00 00 00 
  803075:	48 8b 00             	mov    (%rax),%rax
  803078:	48 89 c7             	mov    %rax,%rdi
  80307b:	48 b8 79 44 80 00 00 	movabs $0x804479,%rax
  803082:	00 00 00 
  803085:	ff d0                	callq  *%rax
  803087:	89 c2                	mov    %eax,%edx
  803089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80308d:	89 d6                	mov    %edx,%esi
  80308f:	48 89 c7             	mov    %rax,%rdi
  803092:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  803099:	00 00 00 
  80309c:	ff d0                	callq  *%rax
  80309e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a5:	79 30                	jns    8030d7 <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  8030a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030aa:	89 c1                	mov    %eax,%ecx
  8030ac:	48 ba cd 7a 80 00 00 	movabs $0x807acd,%rdx
  8030b3:	00 00 00 
  8030b6:	be 3a 00 00 00       	mov    $0x3a,%esi
  8030bb:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  8030c2:	00 00 00 
  8030c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ca:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  8030d1:	00 00 00 
  8030d4:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8030d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030db:	48 c1 e8 0c          	shr    $0xc,%rax
  8030df:	48 89 c2             	mov    %rax,%rdx
  8030e2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030e9:	01 00 00 
  8030ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030f0:	83 e0 40             	and    $0x40,%eax
  8030f3:	48 85 c0             	test   %rax,%rax
  8030f6:	74 35                	je     80312d <fs_test+0x647>
  8030f8:	48 b9 9c 7a 80 00 00 	movabs $0x807a9c,%rcx
  8030ff:	00 00 00 
  803102:	48 ba 0e 79 80 00 00 	movabs $0x80790e,%rdx
  803109:	00 00 00 
  80310c:	be 3b 00 00 00       	mov    $0x3b,%esi
  803111:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  803118:	00 00 00 
  80311b:	b8 00 00 00 00       	mov    $0x0,%eax
  803120:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  803127:	00 00 00 
  80312a:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  80312d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803131:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  803135:	be 00 00 00 00       	mov    $0x0,%esi
  80313a:	48 89 c7             	mov    %rax,%rdi
  80313d:	48 b8 b8 12 80 00 00 	movabs $0x8012b8,%rax
  803144:	00 00 00 
  803147:	ff d0                	callq  *%rax
  803149:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803150:	79 30                	jns    803182 <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  803152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803155:	89 c1                	mov    %eax,%ecx
  803157:	48 ba e1 7a 80 00 00 	movabs $0x807ae1,%rdx
  80315e:	00 00 00 
  803161:	be 3d 00 00 00       	mov    $0x3d,%esi
  803166:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  80316d:	00 00 00 
  803170:	b8 00 00 00 00       	mov    $0x0,%eax
  803175:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  80317c:	00 00 00 
  80317f:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  803182:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  803189:	00 00 00 
  80318c:	48 8b 10             	mov    (%rax),%rdx
  80318f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803193:	48 89 d6             	mov    %rdx,%rsi
  803196:	48 89 c7             	mov    %rax,%rdi
  803199:	48 b8 e5 44 80 00 00 	movabs $0x8044e5,%rax
  8031a0:	00 00 00 
  8031a3:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8031a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8031ad:	48 89 c2             	mov    %rax,%rdx
  8031b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8031b7:	01 00 00 
  8031ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031be:	83 e0 40             	and    $0x40,%eax
  8031c1:	48 85 c0             	test   %rax,%rax
  8031c4:	75 35                	jne    8031fb <fs_test+0x715>
  8031c6:	48 b9 2b 7a 80 00 00 	movabs $0x807a2b,%rcx
  8031cd:	00 00 00 
  8031d0:	48 ba 0e 79 80 00 00 	movabs $0x80790e,%rdx
  8031d7:	00 00 00 
  8031da:	be 3f 00 00 00       	mov    $0x3f,%esi
  8031df:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  8031e6:	00 00 00 
  8031e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ee:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  8031f5:	00 00 00 
  8031f8:	41 ff d0             	callq  *%r8
	file_flush(f);
  8031fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ff:	48 89 c7             	mov    %rax,%rdi
  803202:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  803209:	00 00 00 
  80320c:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80320e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803212:	48 c1 e8 0c          	shr    $0xc,%rax
  803216:	48 89 c2             	mov    %rax,%rdx
  803219:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803220:	01 00 00 
  803223:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803227:	83 e0 40             	and    $0x40,%eax
  80322a:	48 85 c0             	test   %rax,%rax
  80322d:	74 35                	je     803264 <fs_test+0x77e>
  80322f:	48 b9 46 7a 80 00 00 	movabs $0x807a46,%rcx
  803236:	00 00 00 
  803239:	48 ba 0e 79 80 00 00 	movabs $0x80790e,%rdx
  803240:	00 00 00 
  803243:	be 41 00 00 00       	mov    $0x41,%esi
  803248:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  80324f:	00 00 00 
  803252:	b8 00 00 00 00       	mov    $0x0,%eax
  803257:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  80325e:	00 00 00 
  803261:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  803264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803268:	48 c1 e8 0c          	shr    $0xc,%rax
  80326c:	48 89 c2             	mov    %rax,%rdx
  80326f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803276:	01 00 00 
  803279:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80327d:	83 e0 40             	and    $0x40,%eax
  803280:	48 85 c0             	test   %rax,%rax
  803283:	74 35                	je     8032ba <fs_test+0x7d4>
  803285:	48 b9 9c 7a 80 00 00 	movabs $0x807a9c,%rcx
  80328c:	00 00 00 
  80328f:	48 ba 0e 79 80 00 00 	movabs $0x80790e,%rdx
  803296:	00 00 00 
  803299:	be 42 00 00 00       	mov    $0x42,%esi
  80329e:	48 bf d9 78 80 00 00 	movabs $0x8078d9,%rdi
  8032a5:	00 00 00 
  8032a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ad:	49 b8 f7 36 80 00 00 	movabs $0x8036f7,%r8
  8032b4:	00 00 00 
  8032b7:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  8032ba:	48 bf f6 7a 80 00 00 	movabs $0x807af6,%rdi
  8032c1:	00 00 00 
  8032c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c9:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  8032d0:	00 00 00 
  8032d3:	ff d2                	callq  *%rdx
}
  8032d5:	c9                   	leaveq 
  8032d6:	c3                   	retq   

00000000008032d7 <host_fsipc>:
static struct Fd *host_fd;
static union Fsipc host_fsipcbuf __attribute__((aligned(PGSIZE)));

static int
host_fsipc(unsigned type, void *dstva)
{
  8032d7:	55                   	push   %rbp
  8032d8:	48 89 e5             	mov    %rsp,%rbp
  8032db:	48 83 ec 10          	sub    $0x10,%rsp
  8032df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	ipc_host_send(VMX_HOST_FS_ENV, type, &host_fsipcbuf, PTE_P | PTE_W | PTE_U);
  8032e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e9:	b9 07 00 00 00       	mov    $0x7,%ecx
  8032ee:	48 ba 00 50 81 00 00 	movabs $0x815000,%rdx
  8032f5:	00 00 00 
  8032f8:	89 c6                	mov    %eax,%esi
  8032fa:	bf 01 00 00 00       	mov    $0x1,%edi
  8032ff:	48 b8 af 55 80 00 00 	movabs $0x8055af,%rax
  803306:	00 00 00 
  803309:	ff d0                	callq  *%rax
	return ipc_host_recv(dstva);
  80330b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330f:	48 89 c7             	mov    %rax,%rdi
  803312:	48 b8 2a 54 80 00 00 	movabs $0x80542a,%rax
  803319:	00 00 00 
  80331c:	ff d0                	callq  *%rax
}
  80331e:	c9                   	leaveq 
  80331f:	c3                   	retq   

0000000000803320 <get_host_fd>:


uint64_t
get_host_fd() 
{
  803320:	55                   	push   %rbp
  803321:	48 89 e5             	mov    %rsp,%rbp
	return (uint64_t) host_fd;
  803324:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  80332b:	00 00 00 
  80332e:	48 8b 00             	mov    (%rax),%rax
}
  803331:	5d                   	pop    %rbp
  803332:	c3                   	retq   

0000000000803333 <host_read>:

int
host_read(uint32_t secno, void *dst, size_t nsecs)
{
  803333:	55                   	push   %rbp
  803334:	48 89 e5             	mov    %rsp,%rbp
  803337:	48 83 ec 30          	sub    $0x30,%rsp
  80333b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80333e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803342:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r, read = 0;
  803346:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	if(host_fd->fd_file.id == 0) {
  80334d:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  803354:	00 00 00 
  803357:	48 8b 00             	mov    (%rax),%rax
  80335a:	8b 40 0c             	mov    0xc(%rax),%eax
  80335d:	85 c0                	test   %eax,%eax
  80335f:	75 11                	jne    803372 <host_read+0x3f>
		host_ipc_init();
  803361:	b8 00 00 00 00       	mov    $0x0,%eax
  803366:	48 ba 20 35 80 00 00 	movabs $0x803520,%rdx
  80336d:	00 00 00 
  803370:	ff d2                	callq  *%rdx
	}

	host_fd->fd_offset = secno * SECTSIZE;
  803372:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  803379:	00 00 00 
  80337c:	48 8b 00             	mov    (%rax),%rax
  80337f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803382:	c1 e2 09             	shl    $0x9,%edx
  803385:	89 50 04             	mov    %edx,0x4(%rax)
	// read from the host, 2 sectors at a time.
	for(; nsecs > 0; nsecs-=2) {
  803388:	e9 8c 00 00 00       	jmpq   803419 <host_read+0xe6>

		host_fsipcbuf.read.req_fileid = host_fd->fd_file.id;
  80338d:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  803394:	00 00 00 
  803397:	48 8b 00             	mov    (%rax),%rax
  80339a:	8b 50 0c             	mov    0xc(%rax),%edx
  80339d:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  8033a4:	00 00 00 
  8033a7:	89 10                	mov    %edx,(%rax)
		host_fsipcbuf.read.req_n = SECTSIZE * 2;
  8033a9:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  8033b0:	00 00 00 
  8033b3:	48 c7 40 08 00 04 00 	movq   $0x400,0x8(%rax)
  8033ba:	00 
		if ((r = host_fsipc(FSREQ_READ, NULL)) < 0)
  8033bb:	be 00 00 00 00       	mov    $0x0,%esi
  8033c0:	bf 03 00 00 00       	mov    $0x3,%edi
  8033c5:	48 b8 d7 32 80 00 00 	movabs $0x8032d7,%rax
  8033cc:	00 00 00 
  8033cf:	ff d0                	callq  *%rax
  8033d1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8033d4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033d8:	79 05                	jns    8033df <host_read+0xac>
			return r;
  8033da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033dd:	eb 4a                	jmp    803429 <host_read+0xf6>
		// FIXME: Handle case where r < SECTSIZE * 2;
		memmove(dst+read, &host_fsipcbuf, r);
  8033df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033e2:	48 98                	cltq   
  8033e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033e7:	48 63 ca             	movslq %edx,%rcx
  8033ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033ee:	48 01 d1             	add    %rdx,%rcx
  8033f1:	48 89 c2             	mov    %rax,%rdx
  8033f4:	48 be 00 50 81 00 00 	movabs $0x815000,%rsi
  8033fb:	00 00 00 
  8033fe:	48 89 cf             	mov    %rcx,%rdi
  803401:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  803408:	00 00 00 
  80340b:	ff d0                	callq  *%rax
		read += SECTSIZE * 2;
  80340d:	81 45 fc 00 04 00 00 	addl   $0x400,-0x4(%rbp)
		host_ipc_init();
	}

	host_fd->fd_offset = secno * SECTSIZE;
	// read from the host, 2 sectors at a time.
	for(; nsecs > 0; nsecs-=2) {
  803414:	48 83 6d d8 02       	subq   $0x2,-0x28(%rbp)
  803419:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80341e:	0f 85 69 ff ff ff    	jne    80338d <host_read+0x5a>
		// FIXME: Handle case where r < SECTSIZE * 2;
		memmove(dst+read, &host_fsipcbuf, r);
		read += SECTSIZE * 2;
	}

	return 0;
  803424:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803429:	c9                   	leaveq 
  80342a:	c3                   	retq   

000000000080342b <host_write>:

int
host_write(uint32_t secno, const void *src, size_t nsecs)
{
  80342b:	55                   	push   %rbp
  80342c:	48 89 e5             	mov    %rsp,%rbp
  80342f:	48 83 ec 30          	sub    $0x30,%rsp
  803433:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803436:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80343a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r, written = 0;
  80343e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    
	if(host_fd->fd_file.id == 0) {
  803445:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  80344c:	00 00 00 
  80344f:	48 8b 00             	mov    (%rax),%rax
  803452:	8b 40 0c             	mov    0xc(%rax),%eax
  803455:	85 c0                	test   %eax,%eax
  803457:	75 11                	jne    80346a <host_write+0x3f>
		host_ipc_init();
  803459:	b8 00 00 00 00       	mov    $0x0,%eax
  80345e:	48 ba 20 35 80 00 00 	movabs $0x803520,%rdx
  803465:	00 00 00 
  803468:	ff d2                	callq  *%rdx
	}

	host_fd->fd_offset = secno * SECTSIZE;
  80346a:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  803471:	00 00 00 
  803474:	48 8b 00             	mov    (%rax),%rax
  803477:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80347a:	c1 e2 09             	shl    $0x9,%edx
  80347d:	89 50 04             	mov    %edx,0x4(%rax)
	for(; nsecs > 0; nsecs-=2) {
  803480:	e9 89 00 00 00       	jmpq   80350e <host_write+0xe3>
		host_fsipcbuf.write.req_fileid = host_fd->fd_file.id;
  803485:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  80348c:	00 00 00 
  80348f:	48 8b 00             	mov    (%rax),%rax
  803492:	8b 50 0c             	mov    0xc(%rax),%edx
  803495:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  80349c:	00 00 00 
  80349f:	89 10                	mov    %edx,(%rax)
		host_fsipcbuf.write.req_n = SECTSIZE * 2;
  8034a1:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  8034a8:	00 00 00 
  8034ab:	48 c7 40 08 00 04 00 	movq   $0x400,0x8(%rax)
  8034b2:	00 
		memmove(host_fsipcbuf.write.req_buf, src+written, SECTSIZE * 2);
  8034b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b6:	48 63 d0             	movslq %eax,%rdx
  8034b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034bd:	48 01 d0             	add    %rdx,%rax
  8034c0:	ba 00 04 00 00       	mov    $0x400,%edx
  8034c5:	48 89 c6             	mov    %rax,%rsi
  8034c8:	48 bf 10 50 81 00 00 	movabs $0x815010,%rdi
  8034cf:	00 00 00 
  8034d2:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  8034d9:	00 00 00 
  8034dc:	ff d0                	callq  *%rax
		if ((r = host_fsipc(FSREQ_WRITE, NULL)) < 0)
  8034de:	be 00 00 00 00       	mov    $0x0,%esi
  8034e3:	bf 04 00 00 00       	mov    $0x4,%edi
  8034e8:	48 b8 d7 32 80 00 00 	movabs $0x8032d7,%rax
  8034ef:	00 00 00 
  8034f2:	ff d0                	callq  *%rax
  8034f4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8034f7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034fb:	79 05                	jns    803502 <host_write+0xd7>
			return r;
  8034fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803500:	eb 1c                	jmp    80351e <host_write+0xf3>
		written += SECTSIZE * 2;
  803502:	81 45 fc 00 04 00 00 	addl   $0x400,-0x4(%rbp)
	if(host_fd->fd_file.id == 0) {
		host_ipc_init();
	}

	host_fd->fd_offset = secno * SECTSIZE;
	for(; nsecs > 0; nsecs-=2) {
  803509:	48 83 6d d8 02       	subq   $0x2,-0x28(%rbp)
  80350e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803513:	0f 85 6c ff ff ff    	jne    803485 <host_write+0x5a>
		memmove(host_fsipcbuf.write.req_buf, src+written, SECTSIZE * 2);
		if ((r = host_fsipc(FSREQ_WRITE, NULL)) < 0)
			return r;
		written += SECTSIZE * 2;
	}
	return 0;
  803519:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80351e:	c9                   	leaveq 
  80351f:	c3                   	retq   

0000000000803520 <host_ipc_init>:

void
host_ipc_init()
{
  803520:	55                   	push   %rbp
  803521:	48 89 e5             	mov    %rsp,%rbp
  803524:	48 83 ec 40          	sub    $0x40,%rsp
	int r;
	int vmdisk_number;
	char path_string[50];
	if ((r = fd_alloc(&host_fd)) < 0)
  803528:	48 bf 00 40 81 00 00 	movabs $0x814000,%rdi
  80352f:	00 00 00 
  803532:	48 b8 2f 58 80 00 00 	movabs $0x80582f,%rax
  803539:	00 00 00 
  80353c:	ff d0                	callq  *%rax
  80353e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803541:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803545:	79 2a                	jns    803571 <host_ipc_init+0x51>
		panic("Couldn't allocate an fd!");
  803547:	48 ba 0c 7b 80 00 00 	movabs $0x807b0c,%rdx
  80354e:	00 00 00 
  803551:	be 52 00 00 00       	mov    $0x52,%esi
  803556:	48 bf 25 7b 80 00 00 	movabs $0x807b25,%rdi
  80355d:	00 00 00 
  803560:	b8 00 00 00 00       	mov    $0x0,%eax
  803565:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  80356c:	00 00 00 
  80356f:	ff d1                	callq  *%rcx
	//cprintf("Umesh : host ipc init: fd is [%d] ", host_fd);
	asm("vmcall":"=a"(vmdisk_number): "0"(VMX_VMCALL_GETDISKIMGNUM));
  803571:	b8 06 00 00 00       	mov    $0x6,%eax
  803576:	0f 01 c1             	vmcall 
  803579:	89 45 f8             	mov    %eax,-0x8(%rbp)
	snprintf(path_string, 50, "/vmm/fs%d.img", vmdisk_number);
  80357c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80357f:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  803583:	89 d1                	mov    %edx,%ecx
  803585:	48 ba 33 7b 80 00 00 	movabs $0x807b33,%rdx
  80358c:	00 00 00 
  80358f:	be 32 00 00 00       	mov    $0x32,%esi
  803594:	48 89 c7             	mov    %rax,%rdi
  803597:	b8 00 00 00 00       	mov    $0x0,%eax
  80359c:	49 b8 98 43 80 00 00 	movabs $0x804398,%r8
  8035a3:	00 00 00 
  8035a6:	41 ff d0             	callq  *%r8
	strcpy(host_fsipcbuf.open.req_path, path_string);
  8035a9:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8035ad:	48 89 c6             	mov    %rax,%rsi
  8035b0:	48 bf 00 50 81 00 00 	movabs $0x815000,%rdi
  8035b7:	00 00 00 
  8035ba:	48 b8 e5 44 80 00 00 	movabs $0x8044e5,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
	host_fsipcbuf.open.req_omode = O_RDWR;
  8035c6:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  8035cd:	00 00 00 
  8035d0:	c7 80 00 04 00 00 02 	movl   $0x2,0x400(%rax)
  8035d7:	00 00 00 

	if ((r = host_fsipc(FSREQ_OPEN, host_fd)) < 0) {
  8035da:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  8035e1:	00 00 00 
  8035e4:	48 8b 00             	mov    (%rax),%rax
  8035e7:	48 89 c6             	mov    %rax,%rsi
  8035ea:	bf 01 00 00 00       	mov    $0x1,%edi
  8035ef:	48 b8 d7 32 80 00 00 	movabs $0x8032d7,%rax
  8035f6:	00 00 00 
  8035f9:	ff d0                	callq  *%rax
  8035fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803602:	79 4b                	jns    80364f <host_ipc_init+0x12f>
		fd_close(host_fd, 0);
  803604:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  80360b:	00 00 00 
  80360e:	48 8b 00             	mov    (%rax),%rax
  803611:	be 00 00 00 00       	mov    $0x0,%esi
  803616:	48 89 c7             	mov    %rax,%rdi
  803619:	48 b8 57 59 80 00 00 	movabs $0x805957,%rax
  803620:	00 00 00 
  803623:	ff d0                	callq  *%rax
		panic("Couldn't open host file!");
  803625:	48 ba 41 7b 80 00 00 	movabs $0x807b41,%rdx
  80362c:	00 00 00 
  80362f:	be 5b 00 00 00       	mov    $0x5b,%esi
  803634:	48 bf 25 7b 80 00 00 	movabs $0x807b25,%rdi
  80363b:	00 00 00 
  80363e:	b8 00 00 00 00       	mov    $0x0,%eax
  803643:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  80364a:	00 00 00 
  80364d:	ff d1                	callq  *%rcx
	}

}
  80364f:	c9                   	leaveq 
  803650:	c3                   	retq   

0000000000803651 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  803651:	55                   	push   %rbp
  803652:	48 89 e5             	mov    %rsp,%rbp
  803655:	48 83 ec 10          	sub    $0x10,%rsp
  803659:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80365c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  803660:	48 b8 98 4d 80 00 00 	movabs $0x804d98,%rax
  803667:	00 00 00 
  80366a:	ff d0                	callq  *%rax
  80366c:	25 ff 03 00 00       	and    $0x3ff,%eax
  803671:	48 98                	cltq   
  803673:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80367a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803681:	00 00 00 
  803684:	48 01 c2             	add    %rax,%rdx
  803687:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  80368e:	00 00 00 
  803691:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  803694:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803698:	7e 14                	jle    8036ae <libmain+0x5d>
		binaryname = argv[0];
  80369a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369e:	48 8b 10             	mov    (%rax),%rdx
  8036a1:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  8036a8:	00 00 00 
  8036ab:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8036ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b5:	48 89 d6             	mov    %rdx,%rsi
  8036b8:	89 c7                	mov    %eax,%edi
  8036ba:	48 b8 4e 2a 80 00 00 	movabs $0x802a4e,%rax
  8036c1:	00 00 00 
  8036c4:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8036c6:	48 b8 d4 36 80 00 00 	movabs $0x8036d4,%rax
  8036cd:	00 00 00 
  8036d0:	ff d0                	callq  *%rax
}
  8036d2:	c9                   	leaveq 
  8036d3:	c3                   	retq   

00000000008036d4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8036d4:	55                   	push   %rbp
  8036d5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8036d8:	48 b8 22 5b 80 00 00 	movabs $0x805b22,%rax
  8036df:	00 00 00 
  8036e2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8036e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e9:	48 b8 54 4d 80 00 00 	movabs $0x804d54,%rax
  8036f0:	00 00 00 
  8036f3:	ff d0                	callq  *%rax

}
  8036f5:	5d                   	pop    %rbp
  8036f6:	c3                   	retq   

00000000008036f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8036f7:	55                   	push   %rbp
  8036f8:	48 89 e5             	mov    %rsp,%rbp
  8036fb:	53                   	push   %rbx
  8036fc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803703:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80370a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803710:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803717:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80371e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803725:	84 c0                	test   %al,%al
  803727:	74 23                	je     80374c <_panic+0x55>
  803729:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803730:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803734:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803738:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80373c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803740:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803744:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803748:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80374c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803753:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80375a:	00 00 00 
  80375d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803764:	00 00 00 
  803767:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80376b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803772:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803779:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803780:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  803787:	00 00 00 
  80378a:	48 8b 18             	mov    (%rax),%rbx
  80378d:	48 b8 98 4d 80 00 00 	movabs $0x804d98,%rax
  803794:	00 00 00 
  803797:	ff d0                	callq  *%rax
  803799:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80379f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8037a6:	41 89 c8             	mov    %ecx,%r8d
  8037a9:	48 89 d1             	mov    %rdx,%rcx
  8037ac:	48 89 da             	mov    %rbx,%rdx
  8037af:	89 c6                	mov    %eax,%esi
  8037b1:	48 bf 68 7b 80 00 00 	movabs $0x807b68,%rdi
  8037b8:	00 00 00 
  8037bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c0:	49 b9 30 39 80 00 00 	movabs $0x803930,%r9
  8037c7:	00 00 00 
  8037ca:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8037cd:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8037d4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8037db:	48 89 d6             	mov    %rdx,%rsi
  8037de:	48 89 c7             	mov    %rax,%rdi
  8037e1:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  8037e8:	00 00 00 
  8037eb:	ff d0                	callq  *%rax
	cprintf("\n");
  8037ed:	48 bf 8b 7b 80 00 00 	movabs $0x807b8b,%rdi
  8037f4:	00 00 00 
  8037f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037fc:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  803803:	00 00 00 
  803806:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803808:	cc                   	int3   
  803809:	eb fd                	jmp    803808 <_panic+0x111>

000000000080380b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80380b:	55                   	push   %rbp
  80380c:	48 89 e5             	mov    %rsp,%rbp
  80380f:	48 83 ec 10          	sub    $0x10,%rsp
  803813:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803816:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80381a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80381e:	8b 00                	mov    (%rax),%eax
  803820:	8d 48 01             	lea    0x1(%rax),%ecx
  803823:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803827:	89 0a                	mov    %ecx,(%rdx)
  803829:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80382c:	89 d1                	mov    %edx,%ecx
  80382e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803832:	48 98                	cltq   
  803834:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  803838:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80383c:	8b 00                	mov    (%rax),%eax
  80383e:	3d ff 00 00 00       	cmp    $0xff,%eax
  803843:	75 2c                	jne    803871 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  803845:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803849:	8b 00                	mov    (%rax),%eax
  80384b:	48 98                	cltq   
  80384d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803851:	48 83 c2 08          	add    $0x8,%rdx
  803855:	48 89 c6             	mov    %rax,%rsi
  803858:	48 89 d7             	mov    %rdx,%rdi
  80385b:	48 b8 cc 4c 80 00 00 	movabs $0x804ccc,%rax
  803862:	00 00 00 
  803865:	ff d0                	callq  *%rax
        b->idx = 0;
  803867:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  803871:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803875:	8b 40 04             	mov    0x4(%rax),%eax
  803878:	8d 50 01             	lea    0x1(%rax),%edx
  80387b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387f:	89 50 04             	mov    %edx,0x4(%rax)
}
  803882:	c9                   	leaveq 
  803883:	c3                   	retq   

0000000000803884 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  803884:	55                   	push   %rbp
  803885:	48 89 e5             	mov    %rsp,%rbp
  803888:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80388f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  803896:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80389d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8038a4:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8038ab:	48 8b 0a             	mov    (%rdx),%rcx
  8038ae:	48 89 08             	mov    %rcx,(%rax)
  8038b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8038b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8038b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8038bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8038c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8038c8:	00 00 00 
    b.cnt = 0;
  8038cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8038d2:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8038d5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8038dc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8038e3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8038ea:	48 89 c6             	mov    %rax,%rsi
  8038ed:	48 bf 0b 38 80 00 00 	movabs $0x80380b,%rdi
  8038f4:	00 00 00 
  8038f7:	48 b8 e3 3c 80 00 00 	movabs $0x803ce3,%rax
  8038fe:	00 00 00 
  803901:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  803903:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  803909:	48 98                	cltq   
  80390b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  803912:	48 83 c2 08          	add    $0x8,%rdx
  803916:	48 89 c6             	mov    %rax,%rsi
  803919:	48 89 d7             	mov    %rdx,%rdi
  80391c:	48 b8 cc 4c 80 00 00 	movabs $0x804ccc,%rax
  803923:	00 00 00 
  803926:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  803928:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80392e:	c9                   	leaveq 
  80392f:	c3                   	retq   

0000000000803930 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  803930:	55                   	push   %rbp
  803931:	48 89 e5             	mov    %rsp,%rbp
  803934:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80393b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803942:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803949:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803950:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803957:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80395e:	84 c0                	test   %al,%al
  803960:	74 20                	je     803982 <cprintf+0x52>
  803962:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803966:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80396a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80396e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803972:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803976:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80397a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80397e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803982:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  803989:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803990:	00 00 00 
  803993:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80399a:	00 00 00 
  80399d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8039a1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8039a8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8039af:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8039b6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8039bd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8039c4:	48 8b 0a             	mov    (%rdx),%rcx
  8039c7:	48 89 08             	mov    %rcx,(%rax)
  8039ca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8039ce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8039d2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8039d6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8039da:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8039e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8039e8:	48 89 d6             	mov    %rdx,%rsi
  8039eb:	48 89 c7             	mov    %rax,%rdi
  8039ee:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  8039f5:	00 00 00 
  8039f8:	ff d0                	callq  *%rax
  8039fa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  803a00:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803a06:	c9                   	leaveq 
  803a07:	c3                   	retq   

0000000000803a08 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  803a08:	55                   	push   %rbp
  803a09:	48 89 e5             	mov    %rsp,%rbp
  803a0c:	53                   	push   %rbx
  803a0d:	48 83 ec 38          	sub    $0x38,%rsp
  803a11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a15:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a19:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803a1d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  803a20:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  803a24:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  803a28:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803a2b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803a2f:	77 3b                	ja     803a6c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  803a31:	8b 45 d0             	mov    -0x30(%rbp),%eax
  803a34:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  803a38:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  803a3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a3f:	ba 00 00 00 00       	mov    $0x0,%edx
  803a44:	48 f7 f3             	div    %rbx
  803a47:	48 89 c2             	mov    %rax,%rdx
  803a4a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  803a4d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  803a50:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  803a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a58:	41 89 f9             	mov    %edi,%r9d
  803a5b:	48 89 c7             	mov    %rax,%rdi
  803a5e:	48 b8 08 3a 80 00 00 	movabs $0x803a08,%rax
  803a65:	00 00 00 
  803a68:	ff d0                	callq  *%rax
  803a6a:	eb 1e                	jmp    803a8a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  803a6c:	eb 12                	jmp    803a80 <printnum+0x78>
			putch(padc, putdat);
  803a6e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a72:	8b 55 cc             	mov    -0x34(%rbp),%edx
  803a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a79:	48 89 ce             	mov    %rcx,%rsi
  803a7c:	89 d7                	mov    %edx,%edi
  803a7e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  803a80:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  803a84:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  803a88:	7f e4                	jg     803a6e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  803a8a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  803a8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a91:	ba 00 00 00 00       	mov    $0x0,%edx
  803a96:	48 f7 f1             	div    %rcx
  803a99:	48 89 d0             	mov    %rdx,%rax
  803a9c:	48 ba 90 7d 80 00 00 	movabs $0x807d90,%rdx
  803aa3:	00 00 00 
  803aa6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  803aaa:	0f be d0             	movsbl %al,%edx
  803aad:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803ab1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ab5:	48 89 ce             	mov    %rcx,%rsi
  803ab8:	89 d7                	mov    %edx,%edi
  803aba:	ff d0                	callq  *%rax
}
  803abc:	48 83 c4 38          	add    $0x38,%rsp
  803ac0:	5b                   	pop    %rbx
  803ac1:	5d                   	pop    %rbp
  803ac2:	c3                   	retq   

0000000000803ac3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  803ac3:	55                   	push   %rbp
  803ac4:	48 89 e5             	mov    %rsp,%rbp
  803ac7:	48 83 ec 1c          	sub    $0x1c,%rsp
  803acb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803acf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  803ad2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803ad6:	7e 52                	jle    803b2a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  803ad8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803adc:	8b 00                	mov    (%rax),%eax
  803ade:	83 f8 30             	cmp    $0x30,%eax
  803ae1:	73 24                	jae    803b07 <getuint+0x44>
  803ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ae7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803aeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aef:	8b 00                	mov    (%rax),%eax
  803af1:	89 c0                	mov    %eax,%eax
  803af3:	48 01 d0             	add    %rdx,%rax
  803af6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803afa:	8b 12                	mov    (%rdx),%edx
  803afc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803aff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b03:	89 0a                	mov    %ecx,(%rdx)
  803b05:	eb 17                	jmp    803b1e <getuint+0x5b>
  803b07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b0b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803b0f:	48 89 d0             	mov    %rdx,%rax
  803b12:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803b16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b1a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803b1e:	48 8b 00             	mov    (%rax),%rax
  803b21:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803b25:	e9 a3 00 00 00       	jmpq   803bcd <getuint+0x10a>
	else if (lflag)
  803b2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803b2e:	74 4f                	je     803b7f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  803b30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b34:	8b 00                	mov    (%rax),%eax
  803b36:	83 f8 30             	cmp    $0x30,%eax
  803b39:	73 24                	jae    803b5f <getuint+0x9c>
  803b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b3f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803b43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b47:	8b 00                	mov    (%rax),%eax
  803b49:	89 c0                	mov    %eax,%eax
  803b4b:	48 01 d0             	add    %rdx,%rax
  803b4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b52:	8b 12                	mov    (%rdx),%edx
  803b54:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803b57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b5b:	89 0a                	mov    %ecx,(%rdx)
  803b5d:	eb 17                	jmp    803b76 <getuint+0xb3>
  803b5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b63:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803b67:	48 89 d0             	mov    %rdx,%rax
  803b6a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803b6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b72:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803b76:	48 8b 00             	mov    (%rax),%rax
  803b79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803b7d:	eb 4e                	jmp    803bcd <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  803b7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b83:	8b 00                	mov    (%rax),%eax
  803b85:	83 f8 30             	cmp    $0x30,%eax
  803b88:	73 24                	jae    803bae <getuint+0xeb>
  803b8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b8e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803b92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b96:	8b 00                	mov    (%rax),%eax
  803b98:	89 c0                	mov    %eax,%eax
  803b9a:	48 01 d0             	add    %rdx,%rax
  803b9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ba1:	8b 12                	mov    (%rdx),%edx
  803ba3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803ba6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803baa:	89 0a                	mov    %ecx,(%rdx)
  803bac:	eb 17                	jmp    803bc5 <getuint+0x102>
  803bae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bb2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803bb6:	48 89 d0             	mov    %rdx,%rax
  803bb9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803bbd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bc1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803bc5:	8b 00                	mov    (%rax),%eax
  803bc7:	89 c0                	mov    %eax,%eax
  803bc9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803bcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803bd1:	c9                   	leaveq 
  803bd2:	c3                   	retq   

0000000000803bd3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  803bd3:	55                   	push   %rbp
  803bd4:	48 89 e5             	mov    %rsp,%rbp
  803bd7:	48 83 ec 1c          	sub    $0x1c,%rsp
  803bdb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bdf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  803be2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803be6:	7e 52                	jle    803c3a <getint+0x67>
		x=va_arg(*ap, long long);
  803be8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bec:	8b 00                	mov    (%rax),%eax
  803bee:	83 f8 30             	cmp    $0x30,%eax
  803bf1:	73 24                	jae    803c17 <getint+0x44>
  803bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803bfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bff:	8b 00                	mov    (%rax),%eax
  803c01:	89 c0                	mov    %eax,%eax
  803c03:	48 01 d0             	add    %rdx,%rax
  803c06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c0a:	8b 12                	mov    (%rdx),%edx
  803c0c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803c0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c13:	89 0a                	mov    %ecx,(%rdx)
  803c15:	eb 17                	jmp    803c2e <getint+0x5b>
  803c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c1b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803c1f:	48 89 d0             	mov    %rdx,%rax
  803c22:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803c26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c2a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803c2e:	48 8b 00             	mov    (%rax),%rax
  803c31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803c35:	e9 a3 00 00 00       	jmpq   803cdd <getint+0x10a>
	else if (lflag)
  803c3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803c3e:	74 4f                	je     803c8f <getint+0xbc>
		x=va_arg(*ap, long);
  803c40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c44:	8b 00                	mov    (%rax),%eax
  803c46:	83 f8 30             	cmp    $0x30,%eax
  803c49:	73 24                	jae    803c6f <getint+0x9c>
  803c4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c4f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803c53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c57:	8b 00                	mov    (%rax),%eax
  803c59:	89 c0                	mov    %eax,%eax
  803c5b:	48 01 d0             	add    %rdx,%rax
  803c5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c62:	8b 12                	mov    (%rdx),%edx
  803c64:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803c67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c6b:	89 0a                	mov    %ecx,(%rdx)
  803c6d:	eb 17                	jmp    803c86 <getint+0xb3>
  803c6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c73:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803c77:	48 89 d0             	mov    %rdx,%rax
  803c7a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803c7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c82:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803c86:	48 8b 00             	mov    (%rax),%rax
  803c89:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803c8d:	eb 4e                	jmp    803cdd <getint+0x10a>
	else
		x=va_arg(*ap, int);
  803c8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c93:	8b 00                	mov    (%rax),%eax
  803c95:	83 f8 30             	cmp    $0x30,%eax
  803c98:	73 24                	jae    803cbe <getint+0xeb>
  803c9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c9e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803ca2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca6:	8b 00                	mov    (%rax),%eax
  803ca8:	89 c0                	mov    %eax,%eax
  803caa:	48 01 d0             	add    %rdx,%rax
  803cad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cb1:	8b 12                	mov    (%rdx),%edx
  803cb3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803cb6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cba:	89 0a                	mov    %ecx,(%rdx)
  803cbc:	eb 17                	jmp    803cd5 <getint+0x102>
  803cbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cc2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803cc6:	48 89 d0             	mov    %rdx,%rax
  803cc9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803ccd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cd1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803cd5:	8b 00                	mov    (%rax),%eax
  803cd7:	48 98                	cltq   
  803cd9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803cdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ce1:	c9                   	leaveq 
  803ce2:	c3                   	retq   

0000000000803ce3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  803ce3:	55                   	push   %rbp
  803ce4:	48 89 e5             	mov    %rsp,%rbp
  803ce7:	41 54                	push   %r12
  803ce9:	53                   	push   %rbx
  803cea:	48 83 ec 60          	sub    $0x60,%rsp
  803cee:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  803cf2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  803cf6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803cfa:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803cfe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803d02:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  803d06:	48 8b 0a             	mov    (%rdx),%rcx
  803d09:	48 89 08             	mov    %rcx,(%rax)
  803d0c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803d10:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803d14:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803d18:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803d1c:	eb 17                	jmp    803d35 <vprintfmt+0x52>
			if (ch == '\0')
  803d1e:	85 db                	test   %ebx,%ebx
  803d20:	0f 84 cc 04 00 00    	je     8041f2 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  803d26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803d2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d2e:	48 89 d6             	mov    %rdx,%rsi
  803d31:	89 df                	mov    %ebx,%edi
  803d33:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803d35:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803d39:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803d3d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803d41:	0f b6 00             	movzbl (%rax),%eax
  803d44:	0f b6 d8             	movzbl %al,%ebx
  803d47:	83 fb 25             	cmp    $0x25,%ebx
  803d4a:	75 d2                	jne    803d1e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803d4c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803d50:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  803d57:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803d5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  803d65:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803d6c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803d70:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803d74:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803d78:	0f b6 00             	movzbl (%rax),%eax
  803d7b:	0f b6 d8             	movzbl %al,%ebx
  803d7e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  803d81:	83 f8 55             	cmp    $0x55,%eax
  803d84:	0f 87 34 04 00 00    	ja     8041be <vprintfmt+0x4db>
  803d8a:	89 c0                	mov    %eax,%eax
  803d8c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803d93:	00 
  803d94:	48 b8 b8 7d 80 00 00 	movabs $0x807db8,%rax
  803d9b:	00 00 00 
  803d9e:	48 01 d0             	add    %rdx,%rax
  803da1:	48 8b 00             	mov    (%rax),%rax
  803da4:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  803da6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  803daa:	eb c0                	jmp    803d6c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  803dac:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803db0:	eb ba                	jmp    803d6c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803db2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  803db9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803dbc:	89 d0                	mov    %edx,%eax
  803dbe:	c1 e0 02             	shl    $0x2,%eax
  803dc1:	01 d0                	add    %edx,%eax
  803dc3:	01 c0                	add    %eax,%eax
  803dc5:	01 d8                	add    %ebx,%eax
  803dc7:	83 e8 30             	sub    $0x30,%eax
  803dca:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803dcd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803dd1:	0f b6 00             	movzbl (%rax),%eax
  803dd4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  803dd7:	83 fb 2f             	cmp    $0x2f,%ebx
  803dda:	7e 0c                	jle    803de8 <vprintfmt+0x105>
  803ddc:	83 fb 39             	cmp    $0x39,%ebx
  803ddf:	7f 07                	jg     803de8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803de1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  803de6:	eb d1                	jmp    803db9 <vprintfmt+0xd6>
			goto process_precision;
  803de8:	eb 58                	jmp    803e42 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  803dea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803ded:	83 f8 30             	cmp    $0x30,%eax
  803df0:	73 17                	jae    803e09 <vprintfmt+0x126>
  803df2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803df6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803df9:	89 c0                	mov    %eax,%eax
  803dfb:	48 01 d0             	add    %rdx,%rax
  803dfe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803e01:	83 c2 08             	add    $0x8,%edx
  803e04:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803e07:	eb 0f                	jmp    803e18 <vprintfmt+0x135>
  803e09:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803e0d:	48 89 d0             	mov    %rdx,%rax
  803e10:	48 83 c2 08          	add    $0x8,%rdx
  803e14:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803e18:	8b 00                	mov    (%rax),%eax
  803e1a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803e1d:	eb 23                	jmp    803e42 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  803e1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803e23:	79 0c                	jns    803e31 <vprintfmt+0x14e>
				width = 0;
  803e25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803e2c:	e9 3b ff ff ff       	jmpq   803d6c <vprintfmt+0x89>
  803e31:	e9 36 ff ff ff       	jmpq   803d6c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  803e36:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  803e3d:	e9 2a ff ff ff       	jmpq   803d6c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  803e42:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803e46:	79 12                	jns    803e5a <vprintfmt+0x177>
				width = precision, precision = -1;
  803e48:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803e4b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803e4e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  803e55:	e9 12 ff ff ff       	jmpq   803d6c <vprintfmt+0x89>
  803e5a:	e9 0d ff ff ff       	jmpq   803d6c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  803e5f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  803e63:	e9 04 ff ff ff       	jmpq   803d6c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  803e68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803e6b:	83 f8 30             	cmp    $0x30,%eax
  803e6e:	73 17                	jae    803e87 <vprintfmt+0x1a4>
  803e70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803e74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803e77:	89 c0                	mov    %eax,%eax
  803e79:	48 01 d0             	add    %rdx,%rax
  803e7c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803e7f:	83 c2 08             	add    $0x8,%edx
  803e82:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803e85:	eb 0f                	jmp    803e96 <vprintfmt+0x1b3>
  803e87:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803e8b:	48 89 d0             	mov    %rdx,%rax
  803e8e:	48 83 c2 08          	add    $0x8,%rdx
  803e92:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803e96:	8b 10                	mov    (%rax),%edx
  803e98:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803e9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ea0:	48 89 ce             	mov    %rcx,%rsi
  803ea3:	89 d7                	mov    %edx,%edi
  803ea5:	ff d0                	callq  *%rax
			break;
  803ea7:	e9 40 03 00 00       	jmpq   8041ec <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  803eac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803eaf:	83 f8 30             	cmp    $0x30,%eax
  803eb2:	73 17                	jae    803ecb <vprintfmt+0x1e8>
  803eb4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803eb8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803ebb:	89 c0                	mov    %eax,%eax
  803ebd:	48 01 d0             	add    %rdx,%rax
  803ec0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803ec3:	83 c2 08             	add    $0x8,%edx
  803ec6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803ec9:	eb 0f                	jmp    803eda <vprintfmt+0x1f7>
  803ecb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803ecf:	48 89 d0             	mov    %rdx,%rax
  803ed2:	48 83 c2 08          	add    $0x8,%rdx
  803ed6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803eda:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803edc:	85 db                	test   %ebx,%ebx
  803ede:	79 02                	jns    803ee2 <vprintfmt+0x1ff>
				err = -err;
  803ee0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803ee2:	83 fb 15             	cmp    $0x15,%ebx
  803ee5:	7f 16                	jg     803efd <vprintfmt+0x21a>
  803ee7:	48 b8 e0 7c 80 00 00 	movabs $0x807ce0,%rax
  803eee:	00 00 00 
  803ef1:	48 63 d3             	movslq %ebx,%rdx
  803ef4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803ef8:	4d 85 e4             	test   %r12,%r12
  803efb:	75 2e                	jne    803f2b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  803efd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803f01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803f05:	89 d9                	mov    %ebx,%ecx
  803f07:	48 ba a1 7d 80 00 00 	movabs $0x807da1,%rdx
  803f0e:	00 00 00 
  803f11:	48 89 c7             	mov    %rax,%rdi
  803f14:	b8 00 00 00 00       	mov    $0x0,%eax
  803f19:	49 b8 fb 41 80 00 00 	movabs $0x8041fb,%r8
  803f20:	00 00 00 
  803f23:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803f26:	e9 c1 02 00 00       	jmpq   8041ec <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803f2b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803f2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803f33:	4c 89 e1             	mov    %r12,%rcx
  803f36:	48 ba aa 7d 80 00 00 	movabs $0x807daa,%rdx
  803f3d:	00 00 00 
  803f40:	48 89 c7             	mov    %rax,%rdi
  803f43:	b8 00 00 00 00       	mov    $0x0,%eax
  803f48:	49 b8 fb 41 80 00 00 	movabs $0x8041fb,%r8
  803f4f:	00 00 00 
  803f52:	41 ff d0             	callq  *%r8
			break;
  803f55:	e9 92 02 00 00       	jmpq   8041ec <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803f5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803f5d:	83 f8 30             	cmp    $0x30,%eax
  803f60:	73 17                	jae    803f79 <vprintfmt+0x296>
  803f62:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803f66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803f69:	89 c0                	mov    %eax,%eax
  803f6b:	48 01 d0             	add    %rdx,%rax
  803f6e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803f71:	83 c2 08             	add    $0x8,%edx
  803f74:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803f77:	eb 0f                	jmp    803f88 <vprintfmt+0x2a5>
  803f79:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803f7d:	48 89 d0             	mov    %rdx,%rax
  803f80:	48 83 c2 08          	add    $0x8,%rdx
  803f84:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803f88:	4c 8b 20             	mov    (%rax),%r12
  803f8b:	4d 85 e4             	test   %r12,%r12
  803f8e:	75 0a                	jne    803f9a <vprintfmt+0x2b7>
				p = "(null)";
  803f90:	49 bc ad 7d 80 00 00 	movabs $0x807dad,%r12
  803f97:	00 00 00 
			if (width > 0 && padc != '-')
  803f9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803f9e:	7e 3f                	jle    803fdf <vprintfmt+0x2fc>
  803fa0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803fa4:	74 39                	je     803fdf <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  803fa6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803fa9:	48 98                	cltq   
  803fab:	48 89 c6             	mov    %rax,%rsi
  803fae:	4c 89 e7             	mov    %r12,%rdi
  803fb1:	48 b8 a7 44 80 00 00 	movabs $0x8044a7,%rax
  803fb8:	00 00 00 
  803fbb:	ff d0                	callq  *%rax
  803fbd:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803fc0:	eb 17                	jmp    803fd9 <vprintfmt+0x2f6>
					putch(padc, putdat);
  803fc2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803fc6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803fca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803fce:	48 89 ce             	mov    %rcx,%rsi
  803fd1:	89 d7                	mov    %edx,%edi
  803fd3:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803fd5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803fd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803fdd:	7f e3                	jg     803fc2 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803fdf:	eb 37                	jmp    804018 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  803fe1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803fe5:	74 1e                	je     804005 <vprintfmt+0x322>
  803fe7:	83 fb 1f             	cmp    $0x1f,%ebx
  803fea:	7e 05                	jle    803ff1 <vprintfmt+0x30e>
  803fec:	83 fb 7e             	cmp    $0x7e,%ebx
  803fef:	7e 14                	jle    804005 <vprintfmt+0x322>
					putch('?', putdat);
  803ff1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ff5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ff9:	48 89 d6             	mov    %rdx,%rsi
  803ffc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  804001:	ff d0                	callq  *%rax
  804003:	eb 0f                	jmp    804014 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  804005:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  804009:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80400d:	48 89 d6             	mov    %rdx,%rsi
  804010:	89 df                	mov    %ebx,%edi
  804012:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  804014:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  804018:	4c 89 e0             	mov    %r12,%rax
  80401b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80401f:	0f b6 00             	movzbl (%rax),%eax
  804022:	0f be d8             	movsbl %al,%ebx
  804025:	85 db                	test   %ebx,%ebx
  804027:	74 10                	je     804039 <vprintfmt+0x356>
  804029:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80402d:	78 b2                	js     803fe1 <vprintfmt+0x2fe>
  80402f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  804033:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804037:	79 a8                	jns    803fe1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  804039:	eb 16                	jmp    804051 <vprintfmt+0x36e>
				putch(' ', putdat);
  80403b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80403f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804043:	48 89 d6             	mov    %rdx,%rsi
  804046:	bf 20 00 00 00       	mov    $0x20,%edi
  80404b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80404d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  804051:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  804055:	7f e4                	jg     80403b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  804057:	e9 90 01 00 00       	jmpq   8041ec <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80405c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  804060:	be 03 00 00 00       	mov    $0x3,%esi
  804065:	48 89 c7             	mov    %rax,%rdi
  804068:	48 b8 d3 3b 80 00 00 	movabs $0x803bd3,%rax
  80406f:	00 00 00 
  804072:	ff d0                	callq  *%rax
  804074:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  804078:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80407c:	48 85 c0             	test   %rax,%rax
  80407f:	79 1d                	jns    80409e <vprintfmt+0x3bb>
				putch('-', putdat);
  804081:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  804085:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804089:	48 89 d6             	mov    %rdx,%rsi
  80408c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  804091:	ff d0                	callq  *%rax
				num = -(long long) num;
  804093:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804097:	48 f7 d8             	neg    %rax
  80409a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80409e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8040a5:	e9 d5 00 00 00       	jmpq   80417f <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8040aa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8040ae:	be 03 00 00 00       	mov    $0x3,%esi
  8040b3:	48 89 c7             	mov    %rax,%rdi
  8040b6:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  8040bd:	00 00 00 
  8040c0:	ff d0                	callq  *%rax
  8040c2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8040c6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8040cd:	e9 ad 00 00 00       	jmpq   80417f <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8040d2:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8040d5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8040d9:	89 d6                	mov    %edx,%esi
  8040db:	48 89 c7             	mov    %rax,%rdi
  8040de:	48 b8 d3 3b 80 00 00 	movabs $0x803bd3,%rax
  8040e5:	00 00 00 
  8040e8:	ff d0                	callq  *%rax
  8040ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8040ee:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8040f5:	e9 85 00 00 00       	jmpq   80417f <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8040fa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8040fe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804102:	48 89 d6             	mov    %rdx,%rsi
  804105:	bf 30 00 00 00       	mov    $0x30,%edi
  80410a:	ff d0                	callq  *%rax
			putch('x', putdat);
  80410c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  804110:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804114:	48 89 d6             	mov    %rdx,%rsi
  804117:	bf 78 00 00 00       	mov    $0x78,%edi
  80411c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80411e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804121:	83 f8 30             	cmp    $0x30,%eax
  804124:	73 17                	jae    80413d <vprintfmt+0x45a>
  804126:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80412a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80412d:	89 c0                	mov    %eax,%eax
  80412f:	48 01 d0             	add    %rdx,%rax
  804132:	8b 55 b8             	mov    -0x48(%rbp),%edx
  804135:	83 c2 08             	add    $0x8,%edx
  804138:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80413b:	eb 0f                	jmp    80414c <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80413d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804141:	48 89 d0             	mov    %rdx,%rax
  804144:	48 83 c2 08          	add    $0x8,%rdx
  804148:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80414c:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80414f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  804153:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80415a:	eb 23                	jmp    80417f <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80415c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  804160:	be 03 00 00 00       	mov    $0x3,%esi
  804165:	48 89 c7             	mov    %rax,%rdi
  804168:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  80416f:	00 00 00 
  804172:	ff d0                	callq  *%rax
  804174:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  804178:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80417f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  804184:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  804187:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80418a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80418e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  804192:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804196:	45 89 c1             	mov    %r8d,%r9d
  804199:	41 89 f8             	mov    %edi,%r8d
  80419c:	48 89 c7             	mov    %rax,%rdi
  80419f:	48 b8 08 3a 80 00 00 	movabs $0x803a08,%rax
  8041a6:	00 00 00 
  8041a9:	ff d0                	callq  *%rax
			break;
  8041ab:	eb 3f                	jmp    8041ec <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8041ad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8041b1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041b5:	48 89 d6             	mov    %rdx,%rsi
  8041b8:	89 df                	mov    %ebx,%edi
  8041ba:	ff d0                	callq  *%rax
			break;
  8041bc:	eb 2e                	jmp    8041ec <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8041be:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8041c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041c6:	48 89 d6             	mov    %rdx,%rsi
  8041c9:	bf 25 00 00 00       	mov    $0x25,%edi
  8041ce:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8041d0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8041d5:	eb 05                	jmp    8041dc <vprintfmt+0x4f9>
  8041d7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8041dc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8041e0:	48 83 e8 01          	sub    $0x1,%rax
  8041e4:	0f b6 00             	movzbl (%rax),%eax
  8041e7:	3c 25                	cmp    $0x25,%al
  8041e9:	75 ec                	jne    8041d7 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8041eb:	90                   	nop
		}
	}
  8041ec:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8041ed:	e9 43 fb ff ff       	jmpq   803d35 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8041f2:	48 83 c4 60          	add    $0x60,%rsp
  8041f6:	5b                   	pop    %rbx
  8041f7:	41 5c                	pop    %r12
  8041f9:	5d                   	pop    %rbp
  8041fa:	c3                   	retq   

00000000008041fb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8041fb:	55                   	push   %rbp
  8041fc:	48 89 e5             	mov    %rsp,%rbp
  8041ff:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  804206:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80420d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  804214:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80421b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804222:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804229:	84 c0                	test   %al,%al
  80422b:	74 20                	je     80424d <printfmt+0x52>
  80422d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804231:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804235:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804239:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80423d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804241:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804245:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804249:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80424d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804254:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80425b:	00 00 00 
  80425e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  804265:	00 00 00 
  804268:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80426c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  804273:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80427a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  804281:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  804288:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80428f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  804296:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80429d:	48 89 c7             	mov    %rax,%rdi
  8042a0:	48 b8 e3 3c 80 00 00 	movabs $0x803ce3,%rax
  8042a7:	00 00 00 
  8042aa:	ff d0                	callq  *%rax
	va_end(ap);
}
  8042ac:	c9                   	leaveq 
  8042ad:	c3                   	retq   

00000000008042ae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8042ae:	55                   	push   %rbp
  8042af:	48 89 e5             	mov    %rsp,%rbp
  8042b2:	48 83 ec 10          	sub    $0x10,%rsp
  8042b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8042b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8042bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042c1:	8b 40 10             	mov    0x10(%rax),%eax
  8042c4:	8d 50 01             	lea    0x1(%rax),%edx
  8042c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042cb:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8042ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042d2:	48 8b 10             	mov    (%rax),%rdx
  8042d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042d9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8042dd:	48 39 c2             	cmp    %rax,%rdx
  8042e0:	73 17                	jae    8042f9 <sprintputch+0x4b>
		*b->buf++ = ch;
  8042e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e6:	48 8b 00             	mov    (%rax),%rax
  8042e9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8042ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042f1:	48 89 0a             	mov    %rcx,(%rdx)
  8042f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042f7:	88 10                	mov    %dl,(%rax)
}
  8042f9:	c9                   	leaveq 
  8042fa:	c3                   	retq   

00000000008042fb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8042fb:	55                   	push   %rbp
  8042fc:	48 89 e5             	mov    %rsp,%rbp
  8042ff:	48 83 ec 50          	sub    $0x50,%rsp
  804303:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  804307:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80430a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80430e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  804312:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804316:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80431a:	48 8b 0a             	mov    (%rdx),%rcx
  80431d:	48 89 08             	mov    %rcx,(%rax)
  804320:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804324:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804328:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80432c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  804330:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804334:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  804338:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80433b:	48 98                	cltq   
  80433d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  804341:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804345:	48 01 d0             	add    %rdx,%rax
  804348:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80434c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  804353:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  804358:	74 06                	je     804360 <vsnprintf+0x65>
  80435a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80435e:	7f 07                	jg     804367 <vsnprintf+0x6c>
		return -E_INVAL;
  804360:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804365:	eb 2f                	jmp    804396 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  804367:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80436b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80436f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804373:	48 89 c6             	mov    %rax,%rsi
  804376:	48 bf ae 42 80 00 00 	movabs $0x8042ae,%rdi
  80437d:	00 00 00 
  804380:	48 b8 e3 3c 80 00 00 	movabs $0x803ce3,%rax
  804387:	00 00 00 
  80438a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80438c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804390:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  804393:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  804396:	c9                   	leaveq 
  804397:	c3                   	retq   

0000000000804398 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  804398:	55                   	push   %rbp
  804399:	48 89 e5             	mov    %rsp,%rbp
  80439c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8043a3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8043aa:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8043b0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8043b7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8043be:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8043c5:	84 c0                	test   %al,%al
  8043c7:	74 20                	je     8043e9 <snprintf+0x51>
  8043c9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8043cd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8043d1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8043d5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8043d9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8043dd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8043e1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8043e5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8043e9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8043f0:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8043f7:	00 00 00 
  8043fa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804401:	00 00 00 
  804404:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804408:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80440f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804416:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80441d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  804424:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80442b:	48 8b 0a             	mov    (%rdx),%rcx
  80442e:	48 89 08             	mov    %rcx,(%rax)
  804431:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804435:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804439:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80443d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  804441:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  804448:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80444f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  804455:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80445c:	48 89 c7             	mov    %rax,%rdi
  80445f:	48 b8 fb 42 80 00 00 	movabs $0x8042fb,%rax
  804466:	00 00 00 
  804469:	ff d0                	callq  *%rax
  80446b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  804471:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804477:	c9                   	leaveq 
  804478:	c3                   	retq   

0000000000804479 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  804479:	55                   	push   %rbp
  80447a:	48 89 e5             	mov    %rsp,%rbp
  80447d:	48 83 ec 18          	sub    $0x18,%rsp
  804481:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  804485:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80448c:	eb 09                	jmp    804497 <strlen+0x1e>
		n++;
  80448e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  804492:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  804497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80449b:	0f b6 00             	movzbl (%rax),%eax
  80449e:	84 c0                	test   %al,%al
  8044a0:	75 ec                	jne    80448e <strlen+0x15>
		n++;
	return n;
  8044a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044a5:	c9                   	leaveq 
  8044a6:	c3                   	retq   

00000000008044a7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8044a7:	55                   	push   %rbp
  8044a8:	48 89 e5             	mov    %rsp,%rbp
  8044ab:	48 83 ec 20          	sub    $0x20,%rsp
  8044af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8044b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8044be:	eb 0e                	jmp    8044ce <strnlen+0x27>
		n++;
  8044c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8044c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8044c9:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8044ce:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8044d3:	74 0b                	je     8044e0 <strnlen+0x39>
  8044d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044d9:	0f b6 00             	movzbl (%rax),%eax
  8044dc:	84 c0                	test   %al,%al
  8044de:	75 e0                	jne    8044c0 <strnlen+0x19>
		n++;
	return n;
  8044e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044e3:	c9                   	leaveq 
  8044e4:	c3                   	retq   

00000000008044e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8044e5:	55                   	push   %rbp
  8044e6:	48 89 e5             	mov    %rsp,%rbp
  8044e9:	48 83 ec 20          	sub    $0x20,%rsp
  8044ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8044f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8044fd:	90                   	nop
  8044fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804502:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804506:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80450a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80450e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804512:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804516:	0f b6 12             	movzbl (%rdx),%edx
  804519:	88 10                	mov    %dl,(%rax)
  80451b:	0f b6 00             	movzbl (%rax),%eax
  80451e:	84 c0                	test   %al,%al
  804520:	75 dc                	jne    8044fe <strcpy+0x19>
		/* do nothing */;
	return ret;
  804522:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804526:	c9                   	leaveq 
  804527:	c3                   	retq   

0000000000804528 <strcat>:

char *
strcat(char *dst, const char *src)
{
  804528:	55                   	push   %rbp
  804529:	48 89 e5             	mov    %rsp,%rbp
  80452c:	48 83 ec 20          	sub    $0x20,%rsp
  804530:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804534:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  804538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80453c:	48 89 c7             	mov    %rax,%rdi
  80453f:	48 b8 79 44 80 00 00 	movabs $0x804479,%rax
  804546:	00 00 00 
  804549:	ff d0                	callq  *%rax
  80454b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80454e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804551:	48 63 d0             	movslq %eax,%rdx
  804554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804558:	48 01 c2             	add    %rax,%rdx
  80455b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80455f:	48 89 c6             	mov    %rax,%rsi
  804562:	48 89 d7             	mov    %rdx,%rdi
  804565:	48 b8 e5 44 80 00 00 	movabs $0x8044e5,%rax
  80456c:	00 00 00 
  80456f:	ff d0                	callq  *%rax
	return dst;
  804571:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804575:	c9                   	leaveq 
  804576:	c3                   	retq   

0000000000804577 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  804577:	55                   	push   %rbp
  804578:	48 89 e5             	mov    %rsp,%rbp
  80457b:	48 83 ec 28          	sub    $0x28,%rsp
  80457f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804583:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804587:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80458b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80458f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  804593:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80459a:	00 
  80459b:	eb 2a                	jmp    8045c7 <strncpy+0x50>
		*dst++ = *src;
  80459d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8045a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8045a9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8045ad:	0f b6 12             	movzbl (%rdx),%edx
  8045b0:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8045b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045b6:	0f b6 00             	movzbl (%rax),%eax
  8045b9:	84 c0                	test   %al,%al
  8045bb:	74 05                	je     8045c2 <strncpy+0x4b>
			src++;
  8045bd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8045c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8045c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045cb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8045cf:	72 cc                	jb     80459d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8045d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8045d5:	c9                   	leaveq 
  8045d6:	c3                   	retq   

00000000008045d7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8045d7:	55                   	push   %rbp
  8045d8:	48 89 e5             	mov    %rsp,%rbp
  8045db:	48 83 ec 28          	sub    $0x28,%rsp
  8045df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8045e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8045eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8045f3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045f8:	74 3d                	je     804637 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8045fa:	eb 1d                	jmp    804619 <strlcpy+0x42>
			*dst++ = *src++;
  8045fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804600:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804604:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804608:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80460c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804610:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804614:	0f b6 12             	movzbl (%rdx),%edx
  804617:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  804619:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80461e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804623:	74 0b                	je     804630 <strlcpy+0x59>
  804625:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804629:	0f b6 00             	movzbl (%rax),%eax
  80462c:	84 c0                	test   %al,%al
  80462e:	75 cc                	jne    8045fc <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  804630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804634:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  804637:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80463b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80463f:	48 29 c2             	sub    %rax,%rdx
  804642:	48 89 d0             	mov    %rdx,%rax
}
  804645:	c9                   	leaveq 
  804646:	c3                   	retq   

0000000000804647 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  804647:	55                   	push   %rbp
  804648:	48 89 e5             	mov    %rsp,%rbp
  80464b:	48 83 ec 10          	sub    $0x10,%rsp
  80464f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804653:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  804657:	eb 0a                	jmp    804663 <strcmp+0x1c>
		p++, q++;
  804659:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80465e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  804663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804667:	0f b6 00             	movzbl (%rax),%eax
  80466a:	84 c0                	test   %al,%al
  80466c:	74 12                	je     804680 <strcmp+0x39>
  80466e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804672:	0f b6 10             	movzbl (%rax),%edx
  804675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804679:	0f b6 00             	movzbl (%rax),%eax
  80467c:	38 c2                	cmp    %al,%dl
  80467e:	74 d9                	je     804659 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  804680:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804684:	0f b6 00             	movzbl (%rax),%eax
  804687:	0f b6 d0             	movzbl %al,%edx
  80468a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80468e:	0f b6 00             	movzbl (%rax),%eax
  804691:	0f b6 c0             	movzbl %al,%eax
  804694:	29 c2                	sub    %eax,%edx
  804696:	89 d0                	mov    %edx,%eax
}
  804698:	c9                   	leaveq 
  804699:	c3                   	retq   

000000000080469a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80469a:	55                   	push   %rbp
  80469b:	48 89 e5             	mov    %rsp,%rbp
  80469e:	48 83 ec 18          	sub    $0x18,%rsp
  8046a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8046a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8046aa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8046ae:	eb 0f                	jmp    8046bf <strncmp+0x25>
		n--, p++, q++;
  8046b0:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8046b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8046ba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8046bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8046c4:	74 1d                	je     8046e3 <strncmp+0x49>
  8046c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046ca:	0f b6 00             	movzbl (%rax),%eax
  8046cd:	84 c0                	test   %al,%al
  8046cf:	74 12                	je     8046e3 <strncmp+0x49>
  8046d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046d5:	0f b6 10             	movzbl (%rax),%edx
  8046d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046dc:	0f b6 00             	movzbl (%rax),%eax
  8046df:	38 c2                	cmp    %al,%dl
  8046e1:	74 cd                	je     8046b0 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8046e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8046e8:	75 07                	jne    8046f1 <strncmp+0x57>
		return 0;
  8046ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ef:	eb 18                	jmp    804709 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8046f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046f5:	0f b6 00             	movzbl (%rax),%eax
  8046f8:	0f b6 d0             	movzbl %al,%edx
  8046fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ff:	0f b6 00             	movzbl (%rax),%eax
  804702:	0f b6 c0             	movzbl %al,%eax
  804705:	29 c2                	sub    %eax,%edx
  804707:	89 d0                	mov    %edx,%eax
}
  804709:	c9                   	leaveq 
  80470a:	c3                   	retq   

000000000080470b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80470b:	55                   	push   %rbp
  80470c:	48 89 e5             	mov    %rsp,%rbp
  80470f:	48 83 ec 0c          	sub    $0xc,%rsp
  804713:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804717:	89 f0                	mov    %esi,%eax
  804719:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80471c:	eb 17                	jmp    804735 <strchr+0x2a>
		if (*s == c)
  80471e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804722:	0f b6 00             	movzbl (%rax),%eax
  804725:	3a 45 f4             	cmp    -0xc(%rbp),%al
  804728:	75 06                	jne    804730 <strchr+0x25>
			return (char *) s;
  80472a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80472e:	eb 15                	jmp    804745 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  804730:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804739:	0f b6 00             	movzbl (%rax),%eax
  80473c:	84 c0                	test   %al,%al
  80473e:	75 de                	jne    80471e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  804740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804745:	c9                   	leaveq 
  804746:	c3                   	retq   

0000000000804747 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  804747:	55                   	push   %rbp
  804748:	48 89 e5             	mov    %rsp,%rbp
  80474b:	48 83 ec 0c          	sub    $0xc,%rsp
  80474f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804753:	89 f0                	mov    %esi,%eax
  804755:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  804758:	eb 13                	jmp    80476d <strfind+0x26>
		if (*s == c)
  80475a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80475e:	0f b6 00             	movzbl (%rax),%eax
  804761:	3a 45 f4             	cmp    -0xc(%rbp),%al
  804764:	75 02                	jne    804768 <strfind+0x21>
			break;
  804766:	eb 10                	jmp    804778 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  804768:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80476d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804771:	0f b6 00             	movzbl (%rax),%eax
  804774:	84 c0                	test   %al,%al
  804776:	75 e2                	jne    80475a <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  804778:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80477c:	c9                   	leaveq 
  80477d:	c3                   	retq   

000000000080477e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80477e:	55                   	push   %rbp
  80477f:	48 89 e5             	mov    %rsp,%rbp
  804782:	48 83 ec 18          	sub    $0x18,%rsp
  804786:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80478a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80478d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  804791:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804796:	75 06                	jne    80479e <memset+0x20>
		return v;
  804798:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80479c:	eb 69                	jmp    804807 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80479e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047a2:	83 e0 03             	and    $0x3,%eax
  8047a5:	48 85 c0             	test   %rax,%rax
  8047a8:	75 48                	jne    8047f2 <memset+0x74>
  8047aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047ae:	83 e0 03             	and    $0x3,%eax
  8047b1:	48 85 c0             	test   %rax,%rax
  8047b4:	75 3c                	jne    8047f2 <memset+0x74>
		c &= 0xFF;
  8047b6:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8047bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8047c0:	c1 e0 18             	shl    $0x18,%eax
  8047c3:	89 c2                	mov    %eax,%edx
  8047c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8047c8:	c1 e0 10             	shl    $0x10,%eax
  8047cb:	09 c2                	or     %eax,%edx
  8047cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8047d0:	c1 e0 08             	shl    $0x8,%eax
  8047d3:	09 d0                	or     %edx,%eax
  8047d5:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8047d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047dc:	48 c1 e8 02          	shr    $0x2,%rax
  8047e0:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8047e3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8047e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8047ea:	48 89 d7             	mov    %rdx,%rdi
  8047ed:	fc                   	cld    
  8047ee:	f3 ab                	rep stos %eax,%es:(%rdi)
  8047f0:	eb 11                	jmp    804803 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8047f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8047f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8047f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8047fd:	48 89 d7             	mov    %rdx,%rdi
  804800:	fc                   	cld    
  804801:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  804803:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804807:	c9                   	leaveq 
  804808:	c3                   	retq   

0000000000804809 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  804809:	55                   	push   %rbp
  80480a:	48 89 e5             	mov    %rsp,%rbp
  80480d:	48 83 ec 28          	sub    $0x28,%rsp
  804811:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804815:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804819:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80481d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804821:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  804825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804829:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80482d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804831:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804835:	0f 83 88 00 00 00    	jae    8048c3 <memmove+0xba>
  80483b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80483f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804843:	48 01 d0             	add    %rdx,%rax
  804846:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80484a:	76 77                	jbe    8048c3 <memmove+0xba>
		s += n;
  80484c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804850:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  804854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804858:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80485c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804860:	83 e0 03             	and    $0x3,%eax
  804863:	48 85 c0             	test   %rax,%rax
  804866:	75 3b                	jne    8048a3 <memmove+0x9a>
  804868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80486c:	83 e0 03             	and    $0x3,%eax
  80486f:	48 85 c0             	test   %rax,%rax
  804872:	75 2f                	jne    8048a3 <memmove+0x9a>
  804874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804878:	83 e0 03             	and    $0x3,%eax
  80487b:	48 85 c0             	test   %rax,%rax
  80487e:	75 23                	jne    8048a3 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  804880:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804884:	48 83 e8 04          	sub    $0x4,%rax
  804888:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80488c:	48 83 ea 04          	sub    $0x4,%rdx
  804890:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804894:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  804898:	48 89 c7             	mov    %rax,%rdi
  80489b:	48 89 d6             	mov    %rdx,%rsi
  80489e:	fd                   	std    
  80489f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8048a1:	eb 1d                	jmp    8048c0 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8048a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048a7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8048ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048af:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8048b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048b7:	48 89 d7             	mov    %rdx,%rdi
  8048ba:	48 89 c1             	mov    %rax,%rcx
  8048bd:	fd                   	std    
  8048be:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8048c0:	fc                   	cld    
  8048c1:	eb 57                	jmp    80491a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8048c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048c7:	83 e0 03             	and    $0x3,%eax
  8048ca:	48 85 c0             	test   %rax,%rax
  8048cd:	75 36                	jne    804905 <memmove+0xfc>
  8048cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048d3:	83 e0 03             	and    $0x3,%eax
  8048d6:	48 85 c0             	test   %rax,%rax
  8048d9:	75 2a                	jne    804905 <memmove+0xfc>
  8048db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048df:	83 e0 03             	and    $0x3,%eax
  8048e2:	48 85 c0             	test   %rax,%rax
  8048e5:	75 1e                	jne    804905 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8048e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048eb:	48 c1 e8 02          	shr    $0x2,%rax
  8048ef:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8048f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8048fa:	48 89 c7             	mov    %rax,%rdi
  8048fd:	48 89 d6             	mov    %rdx,%rsi
  804900:	fc                   	cld    
  804901:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804903:	eb 15                	jmp    80491a <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  804905:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804909:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80490d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804911:	48 89 c7             	mov    %rax,%rdi
  804914:	48 89 d6             	mov    %rdx,%rsi
  804917:	fc                   	cld    
  804918:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80491a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80491e:	c9                   	leaveq 
  80491f:	c3                   	retq   

0000000000804920 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  804920:	55                   	push   %rbp
  804921:	48 89 e5             	mov    %rsp,%rbp
  804924:	48 83 ec 18          	sub    $0x18,%rsp
  804928:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80492c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804930:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  804934:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804938:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80493c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804940:	48 89 ce             	mov    %rcx,%rsi
  804943:	48 89 c7             	mov    %rax,%rdi
  804946:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  80494d:	00 00 00 
  804950:	ff d0                	callq  *%rax
}
  804952:	c9                   	leaveq 
  804953:	c3                   	retq   

0000000000804954 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  804954:	55                   	push   %rbp
  804955:	48 89 e5             	mov    %rsp,%rbp
  804958:	48 83 ec 28          	sub    $0x28,%rsp
  80495c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804960:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804964:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  804968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80496c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  804970:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804974:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  804978:	eb 36                	jmp    8049b0 <memcmp+0x5c>
		if (*s1 != *s2)
  80497a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80497e:	0f b6 10             	movzbl (%rax),%edx
  804981:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804985:	0f b6 00             	movzbl (%rax),%eax
  804988:	38 c2                	cmp    %al,%dl
  80498a:	74 1a                	je     8049a6 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80498c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804990:	0f b6 00             	movzbl (%rax),%eax
  804993:	0f b6 d0             	movzbl %al,%edx
  804996:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80499a:	0f b6 00             	movzbl (%rax),%eax
  80499d:	0f b6 c0             	movzbl %al,%eax
  8049a0:	29 c2                	sub    %eax,%edx
  8049a2:	89 d0                	mov    %edx,%eax
  8049a4:	eb 20                	jmp    8049c6 <memcmp+0x72>
		s1++, s2++;
  8049a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8049ab:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8049b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049b4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8049b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8049bc:	48 85 c0             	test   %rax,%rax
  8049bf:	75 b9                	jne    80497a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8049c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049c6:	c9                   	leaveq 
  8049c7:	c3                   	retq   

00000000008049c8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8049c8:	55                   	push   %rbp
  8049c9:	48 89 e5             	mov    %rsp,%rbp
  8049cc:	48 83 ec 28          	sub    $0x28,%rsp
  8049d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8049d4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8049d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8049db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8049e3:	48 01 d0             	add    %rdx,%rax
  8049e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8049ea:	eb 15                	jmp    804a01 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8049ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049f0:	0f b6 10             	movzbl (%rax),%edx
  8049f3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8049f6:	38 c2                	cmp    %al,%dl
  8049f8:	75 02                	jne    8049fc <memfind+0x34>
			break;
  8049fa:	eb 0f                	jmp    804a0b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8049fc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  804a01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a05:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  804a09:	72 e1                	jb     8049ec <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  804a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804a0f:	c9                   	leaveq 
  804a10:	c3                   	retq   

0000000000804a11 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  804a11:	55                   	push   %rbp
  804a12:	48 89 e5             	mov    %rsp,%rbp
  804a15:	48 83 ec 34          	sub    $0x34,%rsp
  804a19:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804a1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804a21:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  804a24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  804a2b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  804a32:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804a33:	eb 05                	jmp    804a3a <strtol+0x29>
		s++;
  804a35:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804a3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a3e:	0f b6 00             	movzbl (%rax),%eax
  804a41:	3c 20                	cmp    $0x20,%al
  804a43:	74 f0                	je     804a35 <strtol+0x24>
  804a45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a49:	0f b6 00             	movzbl (%rax),%eax
  804a4c:	3c 09                	cmp    $0x9,%al
  804a4e:	74 e5                	je     804a35 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  804a50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a54:	0f b6 00             	movzbl (%rax),%eax
  804a57:	3c 2b                	cmp    $0x2b,%al
  804a59:	75 07                	jne    804a62 <strtol+0x51>
		s++;
  804a5b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804a60:	eb 17                	jmp    804a79 <strtol+0x68>
	else if (*s == '-')
  804a62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a66:	0f b6 00             	movzbl (%rax),%eax
  804a69:	3c 2d                	cmp    $0x2d,%al
  804a6b:	75 0c                	jne    804a79 <strtol+0x68>
		s++, neg = 1;
  804a6d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804a72:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  804a79:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804a7d:	74 06                	je     804a85 <strtol+0x74>
  804a7f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  804a83:	75 28                	jne    804aad <strtol+0x9c>
  804a85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a89:	0f b6 00             	movzbl (%rax),%eax
  804a8c:	3c 30                	cmp    $0x30,%al
  804a8e:	75 1d                	jne    804aad <strtol+0x9c>
  804a90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a94:	48 83 c0 01          	add    $0x1,%rax
  804a98:	0f b6 00             	movzbl (%rax),%eax
  804a9b:	3c 78                	cmp    $0x78,%al
  804a9d:	75 0e                	jne    804aad <strtol+0x9c>
		s += 2, base = 16;
  804a9f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  804aa4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  804aab:	eb 2c                	jmp    804ad9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  804aad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804ab1:	75 19                	jne    804acc <strtol+0xbb>
  804ab3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ab7:	0f b6 00             	movzbl (%rax),%eax
  804aba:	3c 30                	cmp    $0x30,%al
  804abc:	75 0e                	jne    804acc <strtol+0xbb>
		s++, base = 8;
  804abe:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804ac3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  804aca:	eb 0d                	jmp    804ad9 <strtol+0xc8>
	else if (base == 0)
  804acc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804ad0:	75 07                	jne    804ad9 <strtol+0xc8>
		base = 10;
  804ad2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  804ad9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804add:	0f b6 00             	movzbl (%rax),%eax
  804ae0:	3c 2f                	cmp    $0x2f,%al
  804ae2:	7e 1d                	jle    804b01 <strtol+0xf0>
  804ae4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ae8:	0f b6 00             	movzbl (%rax),%eax
  804aeb:	3c 39                	cmp    $0x39,%al
  804aed:	7f 12                	jg     804b01 <strtol+0xf0>
			dig = *s - '0';
  804aef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804af3:	0f b6 00             	movzbl (%rax),%eax
  804af6:	0f be c0             	movsbl %al,%eax
  804af9:	83 e8 30             	sub    $0x30,%eax
  804afc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804aff:	eb 4e                	jmp    804b4f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  804b01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b05:	0f b6 00             	movzbl (%rax),%eax
  804b08:	3c 60                	cmp    $0x60,%al
  804b0a:	7e 1d                	jle    804b29 <strtol+0x118>
  804b0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b10:	0f b6 00             	movzbl (%rax),%eax
  804b13:	3c 7a                	cmp    $0x7a,%al
  804b15:	7f 12                	jg     804b29 <strtol+0x118>
			dig = *s - 'a' + 10;
  804b17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b1b:	0f b6 00             	movzbl (%rax),%eax
  804b1e:	0f be c0             	movsbl %al,%eax
  804b21:	83 e8 57             	sub    $0x57,%eax
  804b24:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804b27:	eb 26                	jmp    804b4f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  804b29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b2d:	0f b6 00             	movzbl (%rax),%eax
  804b30:	3c 40                	cmp    $0x40,%al
  804b32:	7e 48                	jle    804b7c <strtol+0x16b>
  804b34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b38:	0f b6 00             	movzbl (%rax),%eax
  804b3b:	3c 5a                	cmp    $0x5a,%al
  804b3d:	7f 3d                	jg     804b7c <strtol+0x16b>
			dig = *s - 'A' + 10;
  804b3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b43:	0f b6 00             	movzbl (%rax),%eax
  804b46:	0f be c0             	movsbl %al,%eax
  804b49:	83 e8 37             	sub    $0x37,%eax
  804b4c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  804b4f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b52:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  804b55:	7c 02                	jl     804b59 <strtol+0x148>
			break;
  804b57:	eb 23                	jmp    804b7c <strtol+0x16b>
		s++, val = (val * base) + dig;
  804b59:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804b5e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804b61:	48 98                	cltq   
  804b63:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  804b68:	48 89 c2             	mov    %rax,%rdx
  804b6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b6e:	48 98                	cltq   
  804b70:	48 01 d0             	add    %rdx,%rax
  804b73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  804b77:	e9 5d ff ff ff       	jmpq   804ad9 <strtol+0xc8>

	if (endptr)
  804b7c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804b81:	74 0b                	je     804b8e <strtol+0x17d>
		*endptr = (char *) s;
  804b83:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b87:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804b8b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  804b8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b92:	74 09                	je     804b9d <strtol+0x18c>
  804b94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b98:	48 f7 d8             	neg    %rax
  804b9b:	eb 04                	jmp    804ba1 <strtol+0x190>
  804b9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  804ba1:	c9                   	leaveq 
  804ba2:	c3                   	retq   

0000000000804ba3 <strstr>:

char * strstr(const char *in, const char *str)
{
  804ba3:	55                   	push   %rbp
  804ba4:	48 89 e5             	mov    %rsp,%rbp
  804ba7:	48 83 ec 30          	sub    $0x30,%rsp
  804bab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804baf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  804bb3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804bb7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804bbb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804bbf:	0f b6 00             	movzbl (%rax),%eax
  804bc2:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  804bc5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  804bc9:	75 06                	jne    804bd1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  804bcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bcf:	eb 6b                	jmp    804c3c <strstr+0x99>

	len = strlen(str);
  804bd1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804bd5:	48 89 c7             	mov    %rax,%rdi
  804bd8:	48 b8 79 44 80 00 00 	movabs $0x804479,%rax
  804bdf:	00 00 00 
  804be2:	ff d0                	callq  *%rax
  804be4:	48 98                	cltq   
  804be6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  804bea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804bf2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  804bf6:	0f b6 00             	movzbl (%rax),%eax
  804bf9:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  804bfc:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  804c00:	75 07                	jne    804c09 <strstr+0x66>
				return (char *) 0;
  804c02:	b8 00 00 00 00       	mov    $0x0,%eax
  804c07:	eb 33                	jmp    804c3c <strstr+0x99>
		} while (sc != c);
  804c09:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804c0d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  804c10:	75 d8                	jne    804bea <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  804c12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c16:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  804c1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c1e:	48 89 ce             	mov    %rcx,%rsi
  804c21:	48 89 c7             	mov    %rax,%rdi
  804c24:	48 b8 9a 46 80 00 00 	movabs $0x80469a,%rax
  804c2b:	00 00 00 
  804c2e:	ff d0                	callq  *%rax
  804c30:	85 c0                	test   %eax,%eax
  804c32:	75 b6                	jne    804bea <strstr+0x47>

	return (char *) (in - 1);
  804c34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c38:	48 83 e8 01          	sub    $0x1,%rax
}
  804c3c:	c9                   	leaveq 
  804c3d:	c3                   	retq   

0000000000804c3e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  804c3e:	55                   	push   %rbp
  804c3f:	48 89 e5             	mov    %rsp,%rbp
  804c42:	53                   	push   %rbx
  804c43:	48 83 ec 48          	sub    $0x48,%rsp
  804c47:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804c4a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804c4d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804c51:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  804c55:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804c59:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  804c5d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804c60:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804c64:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  804c68:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  804c6c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  804c70:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  804c74:	4c 89 c3             	mov    %r8,%rbx
  804c77:	cd 30                	int    $0x30
  804c79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  804c7d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804c81:	74 3e                	je     804cc1 <syscall+0x83>
  804c83:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804c88:	7e 37                	jle    804cc1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  804c8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804c8e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804c91:	49 89 d0             	mov    %rdx,%r8
  804c94:	89 c1                	mov    %eax,%ecx
  804c96:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  804c9d:	00 00 00 
  804ca0:	be 23 00 00 00       	mov    $0x23,%esi
  804ca5:	48 bf 85 80 80 00 00 	movabs $0x808085,%rdi
  804cac:	00 00 00 
  804caf:	b8 00 00 00 00       	mov    $0x0,%eax
  804cb4:	49 b9 f7 36 80 00 00 	movabs $0x8036f7,%r9
  804cbb:	00 00 00 
  804cbe:	41 ff d1             	callq  *%r9

	return ret;
  804cc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804cc5:	48 83 c4 48          	add    $0x48,%rsp
  804cc9:	5b                   	pop    %rbx
  804cca:	5d                   	pop    %rbp
  804ccb:	c3                   	retq   

0000000000804ccc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  804ccc:	55                   	push   %rbp
  804ccd:	48 89 e5             	mov    %rsp,%rbp
  804cd0:	48 83 ec 20          	sub    $0x20,%rsp
  804cd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804cd8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  804cdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ce0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ce4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804ceb:	00 
  804cec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804cf2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804cf8:	48 89 d1             	mov    %rdx,%rcx
  804cfb:	48 89 c2             	mov    %rax,%rdx
  804cfe:	be 00 00 00 00       	mov    $0x0,%esi
  804d03:	bf 00 00 00 00       	mov    $0x0,%edi
  804d08:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  804d0f:	00 00 00 
  804d12:	ff d0                	callq  *%rax
}
  804d14:	c9                   	leaveq 
  804d15:	c3                   	retq   

0000000000804d16 <sys_cgetc>:

int
sys_cgetc(void)
{
  804d16:	55                   	push   %rbp
  804d17:	48 89 e5             	mov    %rsp,%rbp
  804d1a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  804d1e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804d25:	00 
  804d26:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d2c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d32:	b9 00 00 00 00       	mov    $0x0,%ecx
  804d37:	ba 00 00 00 00       	mov    $0x0,%edx
  804d3c:	be 00 00 00 00       	mov    $0x0,%esi
  804d41:	bf 01 00 00 00       	mov    $0x1,%edi
  804d46:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  804d4d:	00 00 00 
  804d50:	ff d0                	callq  *%rax
}
  804d52:	c9                   	leaveq 
  804d53:	c3                   	retq   

0000000000804d54 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  804d54:	55                   	push   %rbp
  804d55:	48 89 e5             	mov    %rsp,%rbp
  804d58:	48 83 ec 10          	sub    $0x10,%rsp
  804d5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  804d5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d62:	48 98                	cltq   
  804d64:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804d6b:	00 
  804d6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d78:	b9 00 00 00 00       	mov    $0x0,%ecx
  804d7d:	48 89 c2             	mov    %rax,%rdx
  804d80:	be 01 00 00 00       	mov    $0x1,%esi
  804d85:	bf 03 00 00 00       	mov    $0x3,%edi
  804d8a:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  804d91:	00 00 00 
  804d94:	ff d0                	callq  *%rax
}
  804d96:	c9                   	leaveq 
  804d97:	c3                   	retq   

0000000000804d98 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  804d98:	55                   	push   %rbp
  804d99:	48 89 e5             	mov    %rsp,%rbp
  804d9c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  804da0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804da7:	00 
  804da8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804dae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804db4:	b9 00 00 00 00       	mov    $0x0,%ecx
  804db9:	ba 00 00 00 00       	mov    $0x0,%edx
  804dbe:	be 00 00 00 00       	mov    $0x0,%esi
  804dc3:	bf 02 00 00 00       	mov    $0x2,%edi
  804dc8:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  804dcf:	00 00 00 
  804dd2:	ff d0                	callq  *%rax
}
  804dd4:	c9                   	leaveq 
  804dd5:	c3                   	retq   

0000000000804dd6 <sys_yield>:

void
sys_yield(void)
{
  804dd6:	55                   	push   %rbp
  804dd7:	48 89 e5             	mov    %rsp,%rbp
  804dda:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  804dde:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804de5:	00 
  804de6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804dec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804df2:	b9 00 00 00 00       	mov    $0x0,%ecx
  804df7:	ba 00 00 00 00       	mov    $0x0,%edx
  804dfc:	be 00 00 00 00       	mov    $0x0,%esi
  804e01:	bf 0b 00 00 00       	mov    $0xb,%edi
  804e06:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  804e0d:	00 00 00 
  804e10:	ff d0                	callq  *%rax
}
  804e12:	c9                   	leaveq 
  804e13:	c3                   	retq   

0000000000804e14 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  804e14:	55                   	push   %rbp
  804e15:	48 89 e5             	mov    %rsp,%rbp
  804e18:	48 83 ec 20          	sub    $0x20,%rsp
  804e1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804e1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804e23:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  804e26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e29:	48 63 c8             	movslq %eax,%rcx
  804e2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804e30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e33:	48 98                	cltq   
  804e35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804e3c:	00 
  804e3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804e43:	49 89 c8             	mov    %rcx,%r8
  804e46:	48 89 d1             	mov    %rdx,%rcx
  804e49:	48 89 c2             	mov    %rax,%rdx
  804e4c:	be 01 00 00 00       	mov    $0x1,%esi
  804e51:	bf 04 00 00 00       	mov    $0x4,%edi
  804e56:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  804e5d:	00 00 00 
  804e60:	ff d0                	callq  *%rax
}
  804e62:	c9                   	leaveq 
  804e63:	c3                   	retq   

0000000000804e64 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  804e64:	55                   	push   %rbp
  804e65:	48 89 e5             	mov    %rsp,%rbp
  804e68:	48 83 ec 30          	sub    $0x30,%rsp
  804e6c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804e6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804e73:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804e76:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804e7a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  804e7e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e81:	48 63 c8             	movslq %eax,%rcx
  804e84:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804e88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e8b:	48 63 f0             	movslq %eax,%rsi
  804e8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804e92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e95:	48 98                	cltq   
  804e97:	48 89 0c 24          	mov    %rcx,(%rsp)
  804e9b:	49 89 f9             	mov    %rdi,%r9
  804e9e:	49 89 f0             	mov    %rsi,%r8
  804ea1:	48 89 d1             	mov    %rdx,%rcx
  804ea4:	48 89 c2             	mov    %rax,%rdx
  804ea7:	be 01 00 00 00       	mov    $0x1,%esi
  804eac:	bf 05 00 00 00       	mov    $0x5,%edi
  804eb1:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  804eb8:	00 00 00 
  804ebb:	ff d0                	callq  *%rax
}
  804ebd:	c9                   	leaveq 
  804ebe:	c3                   	retq   

0000000000804ebf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  804ebf:	55                   	push   %rbp
  804ec0:	48 89 e5             	mov    %rsp,%rbp
  804ec3:	48 83 ec 20          	sub    $0x20,%rsp
  804ec7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804eca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  804ece:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ed5:	48 98                	cltq   
  804ed7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804ede:	00 
  804edf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804ee5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804eeb:	48 89 d1             	mov    %rdx,%rcx
  804eee:	48 89 c2             	mov    %rax,%rdx
  804ef1:	be 01 00 00 00       	mov    $0x1,%esi
  804ef6:	bf 06 00 00 00       	mov    $0x6,%edi
  804efb:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  804f02:	00 00 00 
  804f05:	ff d0                	callq  *%rax
}
  804f07:	c9                   	leaveq 
  804f08:	c3                   	retq   

0000000000804f09 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  804f09:	55                   	push   %rbp
  804f0a:	48 89 e5             	mov    %rsp,%rbp
  804f0d:	48 83 ec 10          	sub    $0x10,%rsp
  804f11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804f14:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  804f17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f1a:	48 63 d0             	movslq %eax,%rdx
  804f1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f20:	48 98                	cltq   
  804f22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804f29:	00 
  804f2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804f30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804f36:	48 89 d1             	mov    %rdx,%rcx
  804f39:	48 89 c2             	mov    %rax,%rdx
  804f3c:	be 01 00 00 00       	mov    $0x1,%esi
  804f41:	bf 08 00 00 00       	mov    $0x8,%edi
  804f46:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  804f4d:	00 00 00 
  804f50:	ff d0                	callq  *%rax
}
  804f52:	c9                   	leaveq 
  804f53:	c3                   	retq   

0000000000804f54 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  804f54:	55                   	push   %rbp
  804f55:	48 89 e5             	mov    %rsp,%rbp
  804f58:	48 83 ec 20          	sub    $0x20,%rsp
  804f5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804f5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  804f63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804f67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f6a:	48 98                	cltq   
  804f6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804f73:	00 
  804f74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804f7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804f80:	48 89 d1             	mov    %rdx,%rcx
  804f83:	48 89 c2             	mov    %rax,%rdx
  804f86:	be 01 00 00 00       	mov    $0x1,%esi
  804f8b:	bf 09 00 00 00       	mov    $0x9,%edi
  804f90:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  804f97:	00 00 00 
  804f9a:	ff d0                	callq  *%rax
}
  804f9c:	c9                   	leaveq 
  804f9d:	c3                   	retq   

0000000000804f9e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  804f9e:	55                   	push   %rbp
  804f9f:	48 89 e5             	mov    %rsp,%rbp
  804fa2:	48 83 ec 20          	sub    $0x20,%rsp
  804fa6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804fa9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  804fad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804fb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fb4:	48 98                	cltq   
  804fb6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804fbd:	00 
  804fbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804fc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804fca:	48 89 d1             	mov    %rdx,%rcx
  804fcd:	48 89 c2             	mov    %rax,%rdx
  804fd0:	be 01 00 00 00       	mov    $0x1,%esi
  804fd5:	bf 0a 00 00 00       	mov    $0xa,%edi
  804fda:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  804fe1:	00 00 00 
  804fe4:	ff d0                	callq  *%rax
}
  804fe6:	c9                   	leaveq 
  804fe7:	c3                   	retq   

0000000000804fe8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804fe8:	55                   	push   %rbp
  804fe9:	48 89 e5             	mov    %rsp,%rbp
  804fec:	48 83 ec 20          	sub    $0x20,%rsp
  804ff0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804ff3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804ff7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804ffb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804ffe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805001:	48 63 f0             	movslq %eax,%rsi
  805004:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805008:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80500b:	48 98                	cltq   
  80500d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805011:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805018:	00 
  805019:	49 89 f1             	mov    %rsi,%r9
  80501c:	49 89 c8             	mov    %rcx,%r8
  80501f:	48 89 d1             	mov    %rdx,%rcx
  805022:	48 89 c2             	mov    %rax,%rdx
  805025:	be 00 00 00 00       	mov    $0x0,%esi
  80502a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80502f:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  805036:	00 00 00 
  805039:	ff d0                	callq  *%rax
}
  80503b:	c9                   	leaveq 
  80503c:	c3                   	retq   

000000000080503d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80503d:	55                   	push   %rbp
  80503e:	48 89 e5             	mov    %rsp,%rbp
  805041:	48 83 ec 10          	sub    $0x10,%rsp
  805045:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  805049:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80504d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805054:	00 
  805055:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80505b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805061:	b9 00 00 00 00       	mov    $0x0,%ecx
  805066:	48 89 c2             	mov    %rax,%rdx
  805069:	be 01 00 00 00       	mov    $0x1,%esi
  80506e:	bf 0d 00 00 00       	mov    $0xd,%edi
  805073:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  80507a:	00 00 00 
  80507d:	ff d0                	callq  *%rax
}
  80507f:	c9                   	leaveq 
  805080:	c3                   	retq   

0000000000805081 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  805081:	55                   	push   %rbp
  805082:	48 89 e5             	mov    %rsp,%rbp
  805085:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  805089:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805090:	00 
  805091:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805097:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80509d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8050a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8050a7:	be 00 00 00 00       	mov    $0x0,%esi
  8050ac:	bf 0e 00 00 00       	mov    $0xe,%edi
  8050b1:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  8050b8:	00 00 00 
  8050bb:	ff d0                	callq  *%rax
}
  8050bd:	c9                   	leaveq 
  8050be:	c3                   	retq   

00000000008050bf <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8050bf:	55                   	push   %rbp
  8050c0:	48 89 e5             	mov    %rsp,%rbp
  8050c3:	48 83 ec 30          	sub    $0x30,%rsp
  8050c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8050ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8050ce:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8050d1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8050d5:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8050d9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8050dc:	48 63 c8             	movslq %eax,%rcx
  8050df:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8050e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050e6:	48 63 f0             	movslq %eax,%rsi
  8050e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8050ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050f0:	48 98                	cltq   
  8050f2:	48 89 0c 24          	mov    %rcx,(%rsp)
  8050f6:	49 89 f9             	mov    %rdi,%r9
  8050f9:	49 89 f0             	mov    %rsi,%r8
  8050fc:	48 89 d1             	mov    %rdx,%rcx
  8050ff:	48 89 c2             	mov    %rax,%rdx
  805102:	be 00 00 00 00       	mov    $0x0,%esi
  805107:	bf 0f 00 00 00       	mov    $0xf,%edi
  80510c:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  805113:	00 00 00 
  805116:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  805118:	c9                   	leaveq 
  805119:	c3                   	retq   

000000000080511a <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80511a:	55                   	push   %rbp
  80511b:	48 89 e5             	mov    %rsp,%rbp
  80511e:	48 83 ec 20          	sub    $0x20,%rsp
  805122:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805126:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80512a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80512e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805132:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805139:	00 
  80513a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805140:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805146:	48 89 d1             	mov    %rdx,%rcx
  805149:	48 89 c2             	mov    %rax,%rdx
  80514c:	be 00 00 00 00       	mov    $0x0,%esi
  805151:	bf 10 00 00 00       	mov    $0x10,%edi
  805156:	48 b8 3e 4c 80 00 00 	movabs $0x804c3e,%rax
  80515d:	00 00 00 
  805160:	ff d0                	callq  *%rax
}
  805162:	c9                   	leaveq 
  805163:	c3                   	retq   

0000000000805164 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805164:	55                   	push   %rbp
  805165:	48 89 e5             	mov    %rsp,%rbp
  805168:	48 83 ec 10          	sub    $0x10,%rsp
  80516c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  805170:	48 b8 28 60 81 00 00 	movabs $0x816028,%rax
  805177:	00 00 00 
  80517a:	48 8b 00             	mov    (%rax),%rax
  80517d:	48 85 c0             	test   %rax,%rax
  805180:	0f 85 84 00 00 00    	jne    80520a <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  805186:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  80518d:	00 00 00 
  805190:	48 8b 00             	mov    (%rax),%rax
  805193:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805199:	ba 07 00 00 00       	mov    $0x7,%edx
  80519e:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8051a3:	89 c7                	mov    %eax,%edi
  8051a5:	48 b8 14 4e 80 00 00 	movabs $0x804e14,%rax
  8051ac:	00 00 00 
  8051af:	ff d0                	callq  *%rax
  8051b1:	85 c0                	test   %eax,%eax
  8051b3:	79 2a                	jns    8051df <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8051b5:	48 ba 98 80 80 00 00 	movabs $0x808098,%rdx
  8051bc:	00 00 00 
  8051bf:	be 23 00 00 00       	mov    $0x23,%esi
  8051c4:	48 bf bf 80 80 00 00 	movabs $0x8080bf,%rdi
  8051cb:	00 00 00 
  8051ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8051d3:	48 b9 f7 36 80 00 00 	movabs $0x8036f7,%rcx
  8051da:	00 00 00 
  8051dd:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8051df:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  8051e6:	00 00 00 
  8051e9:	48 8b 00             	mov    (%rax),%rax
  8051ec:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8051f2:	48 be 1d 52 80 00 00 	movabs $0x80521d,%rsi
  8051f9:	00 00 00 
  8051fc:	89 c7                	mov    %eax,%edi
  8051fe:	48 b8 9e 4f 80 00 00 	movabs $0x804f9e,%rax
  805205:	00 00 00 
  805208:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  80520a:	48 b8 28 60 81 00 00 	movabs $0x816028,%rax
  805211:	00 00 00 
  805214:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805218:	48 89 10             	mov    %rdx,(%rax)
}
  80521b:	c9                   	leaveq 
  80521c:	c3                   	retq   

000000000080521d <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80521d:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  805220:	48 a1 28 60 81 00 00 	movabs 0x816028,%rax
  805227:	00 00 00 
call *%rax
  80522a:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  80522c:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  805233:	00 
movq 152(%rsp), %rcx  //Load RSP
  805234:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80523b:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  80523c:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  805240:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  805243:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  80524a:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  80524b:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  80524f:	4c 8b 3c 24          	mov    (%rsp),%r15
  805253:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  805258:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80525d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  805262:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  805267:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80526c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805271:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  805276:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80527b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805280:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805285:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80528a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80528f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805294:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805299:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  80529d:	48 83 c4 08          	add    $0x8,%rsp
popfq
  8052a1:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  8052a2:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  8052a3:	c3                   	retq   

00000000008052a4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8052a4:	55                   	push   %rbp
  8052a5:	48 89 e5             	mov    %rsp,%rbp
  8052a8:	48 83 ec 30          	sub    $0x30,%rsp
  8052ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8052b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8052b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8052b8:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  8052bf:	00 00 00 
  8052c2:	48 8b 00             	mov    (%rax),%rax
  8052c5:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8052cb:	85 c0                	test   %eax,%eax
  8052cd:	75 34                	jne    805303 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8052cf:	48 b8 98 4d 80 00 00 	movabs $0x804d98,%rax
  8052d6:	00 00 00 
  8052d9:	ff d0                	callq  *%rax
  8052db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8052e0:	48 98                	cltq   
  8052e2:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8052e9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8052f0:	00 00 00 
  8052f3:	48 01 c2             	add    %rax,%rdx
  8052f6:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  8052fd:	00 00 00 
  805300:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  805303:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805308:	75 0e                	jne    805318 <ipc_recv+0x74>
		pg = (void*) UTOP;
  80530a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805311:	00 00 00 
  805314:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  805318:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80531c:	48 89 c7             	mov    %rax,%rdi
  80531f:	48 b8 3d 50 80 00 00 	movabs $0x80503d,%rax
  805326:	00 00 00 
  805329:	ff d0                	callq  *%rax
  80532b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80532e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805332:	79 19                	jns    80534d <ipc_recv+0xa9>
		*from_env_store = 0;
  805334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805338:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80533e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805342:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  805348:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80534b:	eb 53                	jmp    8053a0 <ipc_recv+0xfc>
	}
	if(from_env_store)
  80534d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805352:	74 19                	je     80536d <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  805354:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  80535b:	00 00 00 
  80535e:	48 8b 00             	mov    (%rax),%rax
  805361:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  805367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80536b:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80536d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805372:	74 19                	je     80538d <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  805374:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  80537b:	00 00 00 
  80537e:	48 8b 00             	mov    (%rax),%rax
  805381:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  805387:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80538b:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80538d:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805394:	00 00 00 
  805397:	48 8b 00             	mov    (%rax),%rax
  80539a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8053a0:	c9                   	leaveq 
  8053a1:	c3                   	retq   

00000000008053a2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8053a2:	55                   	push   %rbp
  8053a3:	48 89 e5             	mov    %rsp,%rbp
  8053a6:	48 83 ec 30          	sub    $0x30,%rsp
  8053aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8053ad:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8053b0:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8053b4:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8053b7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8053bc:	75 0e                	jne    8053cc <ipc_send+0x2a>
		pg = (void*)UTOP;
  8053be:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8053c5:	00 00 00 
  8053c8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8053cc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8053cf:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8053d2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8053d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8053d9:	89 c7                	mov    %eax,%edi
  8053db:	48 b8 e8 4f 80 00 00 	movabs $0x804fe8,%rax
  8053e2:	00 00 00 
  8053e5:	ff d0                	callq  *%rax
  8053e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8053ea:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8053ee:	75 0c                	jne    8053fc <ipc_send+0x5a>
			sys_yield();
  8053f0:	48 b8 d6 4d 80 00 00 	movabs $0x804dd6,%rax
  8053f7:	00 00 00 
  8053fa:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8053fc:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805400:	74 ca                	je     8053cc <ipc_send+0x2a>
	if(result != 0)
  805402:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805406:	74 20                	je     805428 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  805408:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80540b:	89 c6                	mov    %eax,%esi
  80540d:	48 bf d0 80 80 00 00 	movabs $0x8080d0,%rdi
  805414:	00 00 00 
  805417:	b8 00 00 00 00       	mov    $0x0,%eax
  80541c:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  805423:	00 00 00 
  805426:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  805428:	c9                   	leaveq 
  805429:	c3                   	retq   

000000000080542a <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80542a:	55                   	push   %rbp
  80542b:	48 89 e5             	mov    %rsp,%rbp
  80542e:	53                   	push   %rbx
  80542f:	48 83 ec 58          	sub    $0x58,%rsp
  805433:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  805437:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80543b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  80543f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  805446:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80544d:	00 
  80544e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805452:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  805456:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80545a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80545e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805462:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  805466:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80546a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80546e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805472:	48 c1 e8 27          	shr    $0x27,%rax
  805476:	48 89 c2             	mov    %rax,%rdx
  805479:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  805480:	01 00 00 
  805483:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805487:	83 e0 01             	and    $0x1,%eax
  80548a:	48 85 c0             	test   %rax,%rax
  80548d:	0f 85 91 00 00 00    	jne    805524 <ipc_host_recv+0xfa>
  805493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805497:	48 c1 e8 1e          	shr    $0x1e,%rax
  80549b:	48 89 c2             	mov    %rax,%rdx
  80549e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8054a5:	01 00 00 
  8054a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8054ac:	83 e0 01             	and    $0x1,%eax
  8054af:	48 85 c0             	test   %rax,%rax
  8054b2:	74 70                	je     805524 <ipc_host_recv+0xfa>
  8054b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8054b8:	48 c1 e8 15          	shr    $0x15,%rax
  8054bc:	48 89 c2             	mov    %rax,%rdx
  8054bf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8054c6:	01 00 00 
  8054c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8054cd:	83 e0 01             	and    $0x1,%eax
  8054d0:	48 85 c0             	test   %rax,%rax
  8054d3:	74 4f                	je     805524 <ipc_host_recv+0xfa>
  8054d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8054d9:	48 c1 e8 0c          	shr    $0xc,%rax
  8054dd:	48 89 c2             	mov    %rax,%rdx
  8054e0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8054e7:	01 00 00 
  8054ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8054ee:	83 e0 01             	and    $0x1,%eax
  8054f1:	48 85 c0             	test   %rax,%rax
  8054f4:	74 2e                	je     805524 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8054f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8054fa:	ba 07 04 00 00       	mov    $0x407,%edx
  8054ff:	48 89 c6             	mov    %rax,%rsi
  805502:	bf 00 00 00 00       	mov    $0x0,%edi
  805507:	48 b8 14 4e 80 00 00 	movabs $0x804e14,%rax
  80550e:	00 00 00 
  805511:	ff d0                	callq  *%rax
  805513:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  805516:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80551a:	79 08                	jns    805524 <ipc_host_recv+0xfa>
	    	return result;
  80551c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80551f:	e9 84 00 00 00       	jmpq   8055a8 <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  805524:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805528:	48 c1 e8 0c          	shr    $0xc,%rax
  80552c:	48 89 c2             	mov    %rax,%rdx
  80552f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805536:	01 00 00 
  805539:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80553d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  805543:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  805547:	b8 03 00 00 00       	mov    $0x3,%eax
  80554c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  805550:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  805554:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  805558:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80555c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  805560:	4c 89 c3             	mov    %r8,%rbx
  805563:	0f 01 c1             	vmcall 
  805566:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  805569:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80556d:	7e 36                	jle    8055a5 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  80556f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  805572:	41 89 c0             	mov    %eax,%r8d
  805575:	b9 03 00 00 00       	mov    $0x3,%ecx
  80557a:	48 ba e8 80 80 00 00 	movabs $0x8080e8,%rdx
  805581:	00 00 00 
  805584:	be 67 00 00 00       	mov    $0x67,%esi
  805589:	48 bf 15 81 80 00 00 	movabs $0x808115,%rdi
  805590:	00 00 00 
  805593:	b8 00 00 00 00       	mov    $0x0,%eax
  805598:	49 b9 f7 36 80 00 00 	movabs $0x8036f7,%r9
  80559f:	00 00 00 
  8055a2:	41 ff d1             	callq  *%r9
	return result;
  8055a5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  8055a8:	48 83 c4 58          	add    $0x58,%rsp
  8055ac:	5b                   	pop    %rbx
  8055ad:	5d                   	pop    %rbp
  8055ae:	c3                   	retq   

00000000008055af <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8055af:	55                   	push   %rbp
  8055b0:	48 89 e5             	mov    %rsp,%rbp
  8055b3:	53                   	push   %rbx
  8055b4:	48 83 ec 68          	sub    $0x68,%rsp
  8055b8:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8055bb:	89 75 a8             	mov    %esi,-0x58(%rbp)
  8055be:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  8055c2:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  8055c5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8055c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  8055cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  8055d4:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8055db:	00 
  8055dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8055e0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8055e4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8055e8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8055ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055f0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8055f4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8055f8:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8055fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805600:	48 c1 e8 27          	shr    $0x27,%rax
  805604:	48 89 c2             	mov    %rax,%rdx
  805607:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80560e:	01 00 00 
  805611:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805615:	83 e0 01             	and    $0x1,%eax
  805618:	48 85 c0             	test   %rax,%rax
  80561b:	0f 85 88 00 00 00    	jne    8056a9 <ipc_host_send+0xfa>
  805621:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805625:	48 c1 e8 1e          	shr    $0x1e,%rax
  805629:	48 89 c2             	mov    %rax,%rdx
  80562c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  805633:	01 00 00 
  805636:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80563a:	83 e0 01             	and    $0x1,%eax
  80563d:	48 85 c0             	test   %rax,%rax
  805640:	74 67                	je     8056a9 <ipc_host_send+0xfa>
  805642:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805646:	48 c1 e8 15          	shr    $0x15,%rax
  80564a:	48 89 c2             	mov    %rax,%rdx
  80564d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805654:	01 00 00 
  805657:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80565b:	83 e0 01             	and    $0x1,%eax
  80565e:	48 85 c0             	test   %rax,%rax
  805661:	74 46                	je     8056a9 <ipc_host_send+0xfa>
  805663:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805667:	48 c1 e8 0c          	shr    $0xc,%rax
  80566b:	48 89 c2             	mov    %rax,%rdx
  80566e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805675:	01 00 00 
  805678:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80567c:	83 e0 01             	and    $0x1,%eax
  80567f:	48 85 c0             	test   %rax,%rax
  805682:	74 25                	je     8056a9 <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  805684:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805688:	48 c1 e8 0c          	shr    $0xc,%rax
  80568c:	48 89 c2             	mov    %rax,%rdx
  80568f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805696:	01 00 00 
  805699:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80569d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8056a3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8056a7:	eb 0e                	jmp    8056b7 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  8056a9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8056b0:	00 00 00 
  8056b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  8056b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056bb:	48 89 c6             	mov    %rax,%rsi
  8056be:	48 bf 1f 81 80 00 00 	movabs $0x80811f,%rdi
  8056c5:	00 00 00 
  8056c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8056cd:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  8056d4:	00 00 00 
  8056d7:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  8056d9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8056dc:	48 98                	cltq   
  8056de:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  8056e2:	8b 45 a8             	mov    -0x58(%rbp),%eax
  8056e5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  8056e9:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8056ec:	48 98                	cltq   
  8056ee:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  8056f2:	b8 02 00 00 00       	mov    $0x2,%eax
  8056f7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8056fb:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8056ff:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  805703:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  805707:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80570b:	4c 89 c3             	mov    %r8,%rbx
  80570e:	0f 01 c1             	vmcall 
  805711:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  805714:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  805718:	75 0c                	jne    805726 <ipc_host_send+0x177>
			sys_yield();
  80571a:	48 b8 d6 4d 80 00 00 	movabs $0x804dd6,%rax
  805721:	00 00 00 
  805724:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  805726:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  80572a:	74 c6                	je     8056f2 <ipc_host_send+0x143>
	
	if(result !=0)
  80572c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  805730:	74 36                	je     805768 <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  805732:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805735:	41 89 c0             	mov    %eax,%r8d
  805738:	b9 02 00 00 00       	mov    $0x2,%ecx
  80573d:	48 ba e8 80 80 00 00 	movabs $0x8080e8,%rdx
  805744:	00 00 00 
  805747:	be 94 00 00 00       	mov    $0x94,%esi
  80574c:	48 bf 15 81 80 00 00 	movabs $0x808115,%rdi
  805753:	00 00 00 
  805756:	b8 00 00 00 00       	mov    $0x0,%eax
  80575b:	49 b9 f7 36 80 00 00 	movabs $0x8036f7,%r9
  805762:	00 00 00 
  805765:	41 ff d1             	callq  *%r9
}
  805768:	48 83 c4 68          	add    $0x68,%rsp
  80576c:	5b                   	pop    %rbx
  80576d:	5d                   	pop    %rbp
  80576e:	c3                   	retq   

000000000080576f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80576f:	55                   	push   %rbp
  805770:	48 89 e5             	mov    %rsp,%rbp
  805773:	48 83 ec 14          	sub    $0x14,%rsp
  805777:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80577a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805781:	eb 4e                	jmp    8057d1 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  805783:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80578a:	00 00 00 
  80578d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805790:	48 98                	cltq   
  805792:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805799:	48 01 d0             	add    %rdx,%rax
  80579c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8057a2:	8b 00                	mov    (%rax),%eax
  8057a4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8057a7:	75 24                	jne    8057cd <ipc_find_env+0x5e>
			return envs[i].env_id;
  8057a9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8057b0:	00 00 00 
  8057b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057b6:	48 98                	cltq   
  8057b8:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8057bf:	48 01 d0             	add    %rdx,%rax
  8057c2:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8057c8:	8b 40 08             	mov    0x8(%rax),%eax
  8057cb:	eb 12                	jmp    8057df <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8057cd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8057d1:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8057d8:	7e a9                	jle    805783 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8057da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8057df:	c9                   	leaveq 
  8057e0:	c3                   	retq   

00000000008057e1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8057e1:	55                   	push   %rbp
  8057e2:	48 89 e5             	mov    %rsp,%rbp
  8057e5:	48 83 ec 08          	sub    $0x8,%rsp
  8057e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8057ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8057f1:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8057f8:	ff ff ff 
  8057fb:	48 01 d0             	add    %rdx,%rax
  8057fe:	48 c1 e8 0c          	shr    $0xc,%rax
}
  805802:	c9                   	leaveq 
  805803:	c3                   	retq   

0000000000805804 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  805804:	55                   	push   %rbp
  805805:	48 89 e5             	mov    %rsp,%rbp
  805808:	48 83 ec 08          	sub    $0x8,%rsp
  80580c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  805810:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805814:	48 89 c7             	mov    %rax,%rdi
  805817:	48 b8 e1 57 80 00 00 	movabs $0x8057e1,%rax
  80581e:	00 00 00 
  805821:	ff d0                	callq  *%rax
  805823:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  805829:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80582d:	c9                   	leaveq 
  80582e:	c3                   	retq   

000000000080582f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80582f:	55                   	push   %rbp
  805830:	48 89 e5             	mov    %rsp,%rbp
  805833:	48 83 ec 18          	sub    $0x18,%rsp
  805837:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80583b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805842:	eb 6b                	jmp    8058af <fd_alloc+0x80>
		fd = INDEX2FD(i);
  805844:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805847:	48 98                	cltq   
  805849:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80584f:	48 c1 e0 0c          	shl    $0xc,%rax
  805853:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  805857:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80585b:	48 c1 e8 15          	shr    $0x15,%rax
  80585f:	48 89 c2             	mov    %rax,%rdx
  805862:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805869:	01 00 00 
  80586c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805870:	83 e0 01             	and    $0x1,%eax
  805873:	48 85 c0             	test   %rax,%rax
  805876:	74 21                	je     805899 <fd_alloc+0x6a>
  805878:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80587c:	48 c1 e8 0c          	shr    $0xc,%rax
  805880:	48 89 c2             	mov    %rax,%rdx
  805883:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80588a:	01 00 00 
  80588d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805891:	83 e0 01             	and    $0x1,%eax
  805894:	48 85 c0             	test   %rax,%rax
  805897:	75 12                	jne    8058ab <fd_alloc+0x7c>
			*fd_store = fd;
  805899:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80589d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8058a1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8058a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8058a9:	eb 1a                	jmp    8058c5 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8058ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8058af:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8058b3:	7e 8f                	jle    805844 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8058b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058b9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8058c0:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8058c5:	c9                   	leaveq 
  8058c6:	c3                   	retq   

00000000008058c7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8058c7:	55                   	push   %rbp
  8058c8:	48 89 e5             	mov    %rsp,%rbp
  8058cb:	48 83 ec 20          	sub    $0x20,%rsp
  8058cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8058d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8058d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8058da:	78 06                	js     8058e2 <fd_lookup+0x1b>
  8058dc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8058e0:	7e 07                	jle    8058e9 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8058e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8058e7:	eb 6c                	jmp    805955 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8058e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8058ec:	48 98                	cltq   
  8058ee:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8058f4:	48 c1 e0 0c          	shl    $0xc,%rax
  8058f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8058fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805900:	48 c1 e8 15          	shr    $0x15,%rax
  805904:	48 89 c2             	mov    %rax,%rdx
  805907:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80590e:	01 00 00 
  805911:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805915:	83 e0 01             	and    $0x1,%eax
  805918:	48 85 c0             	test   %rax,%rax
  80591b:	74 21                	je     80593e <fd_lookup+0x77>
  80591d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805921:	48 c1 e8 0c          	shr    $0xc,%rax
  805925:	48 89 c2             	mov    %rax,%rdx
  805928:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80592f:	01 00 00 
  805932:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805936:	83 e0 01             	and    $0x1,%eax
  805939:	48 85 c0             	test   %rax,%rax
  80593c:	75 07                	jne    805945 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80593e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805943:	eb 10                	jmp    805955 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  805945:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805949:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80594d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  805950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805955:	c9                   	leaveq 
  805956:	c3                   	retq   

0000000000805957 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  805957:	55                   	push   %rbp
  805958:	48 89 e5             	mov    %rsp,%rbp
  80595b:	48 83 ec 30          	sub    $0x30,%rsp
  80595f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805963:	89 f0                	mov    %esi,%eax
  805965:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  805968:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80596c:	48 89 c7             	mov    %rax,%rdi
  80596f:	48 b8 e1 57 80 00 00 	movabs $0x8057e1,%rax
  805976:	00 00 00 
  805979:	ff d0                	callq  *%rax
  80597b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80597f:	48 89 d6             	mov    %rdx,%rsi
  805982:	89 c7                	mov    %eax,%edi
  805984:	48 b8 c7 58 80 00 00 	movabs $0x8058c7,%rax
  80598b:	00 00 00 
  80598e:	ff d0                	callq  *%rax
  805990:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805993:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805997:	78 0a                	js     8059a3 <fd_close+0x4c>
	    || fd != fd2)
  805999:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80599d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8059a1:	74 12                	je     8059b5 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8059a3:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8059a7:	74 05                	je     8059ae <fd_close+0x57>
  8059a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059ac:	eb 05                	jmp    8059b3 <fd_close+0x5c>
  8059ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8059b3:	eb 69                	jmp    805a1e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8059b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8059b9:	8b 00                	mov    (%rax),%eax
  8059bb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8059bf:	48 89 d6             	mov    %rdx,%rsi
  8059c2:	89 c7                	mov    %eax,%edi
  8059c4:	48 b8 20 5a 80 00 00 	movabs $0x805a20,%rax
  8059cb:	00 00 00 
  8059ce:	ff d0                	callq  *%rax
  8059d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059d7:	78 2a                	js     805a03 <fd_close+0xac>
		if (dev->dev_close)
  8059d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8059dd:	48 8b 40 20          	mov    0x20(%rax),%rax
  8059e1:	48 85 c0             	test   %rax,%rax
  8059e4:	74 16                	je     8059fc <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8059e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8059ea:	48 8b 40 20          	mov    0x20(%rax),%rax
  8059ee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8059f2:	48 89 d7             	mov    %rdx,%rdi
  8059f5:	ff d0                	callq  *%rax
  8059f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059fa:	eb 07                	jmp    805a03 <fd_close+0xac>
		else
			r = 0;
  8059fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  805a03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805a07:	48 89 c6             	mov    %rax,%rsi
  805a0a:	bf 00 00 00 00       	mov    $0x0,%edi
  805a0f:	48 b8 bf 4e 80 00 00 	movabs $0x804ebf,%rax
  805a16:	00 00 00 
  805a19:	ff d0                	callq  *%rax
	return r;
  805a1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805a1e:	c9                   	leaveq 
  805a1f:	c3                   	retq   

0000000000805a20 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  805a20:	55                   	push   %rbp
  805a21:	48 89 e5             	mov    %rsp,%rbp
  805a24:	48 83 ec 20          	sub    $0x20,%rsp
  805a28:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805a2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  805a2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805a36:	eb 41                	jmp    805a79 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  805a38:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  805a3f:	00 00 00 
  805a42:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805a45:	48 63 d2             	movslq %edx,%rdx
  805a48:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805a4c:	8b 00                	mov    (%rax),%eax
  805a4e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805a51:	75 22                	jne    805a75 <dev_lookup+0x55>
			*dev = devtab[i];
  805a53:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  805a5a:	00 00 00 
  805a5d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805a60:	48 63 d2             	movslq %edx,%rdx
  805a63:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  805a67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a6b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  805a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  805a73:	eb 60                	jmp    805ad5 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  805a75:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805a79:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  805a80:	00 00 00 
  805a83:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805a86:	48 63 d2             	movslq %edx,%rdx
  805a89:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805a8d:	48 85 c0             	test   %rax,%rax
  805a90:	75 a6                	jne    805a38 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  805a92:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805a99:	00 00 00 
  805a9c:	48 8b 00             	mov    (%rax),%rax
  805a9f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805aa5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805aa8:	89 c6                	mov    %eax,%esi
  805aaa:	48 bf 30 81 80 00 00 	movabs $0x808130,%rdi
  805ab1:	00 00 00 
  805ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  805ab9:	48 b9 30 39 80 00 00 	movabs $0x803930,%rcx
  805ac0:	00 00 00 
  805ac3:	ff d1                	callq  *%rcx
	*dev = 0;
  805ac5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805ac9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  805ad0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  805ad5:	c9                   	leaveq 
  805ad6:	c3                   	retq   

0000000000805ad7 <close>:

int
close(int fdnum)
{
  805ad7:	55                   	push   %rbp
  805ad8:	48 89 e5             	mov    %rsp,%rbp
  805adb:	48 83 ec 20          	sub    $0x20,%rsp
  805adf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805ae2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805ae6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805ae9:	48 89 d6             	mov    %rdx,%rsi
  805aec:	89 c7                	mov    %eax,%edi
  805aee:	48 b8 c7 58 80 00 00 	movabs $0x8058c7,%rax
  805af5:	00 00 00 
  805af8:	ff d0                	callq  *%rax
  805afa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805afd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b01:	79 05                	jns    805b08 <close+0x31>
		return r;
  805b03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b06:	eb 18                	jmp    805b20 <close+0x49>
	else
		return fd_close(fd, 1);
  805b08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b0c:	be 01 00 00 00       	mov    $0x1,%esi
  805b11:	48 89 c7             	mov    %rax,%rdi
  805b14:	48 b8 57 59 80 00 00 	movabs $0x805957,%rax
  805b1b:	00 00 00 
  805b1e:	ff d0                	callq  *%rax
}
  805b20:	c9                   	leaveq 
  805b21:	c3                   	retq   

0000000000805b22 <close_all>:

void
close_all(void)
{
  805b22:	55                   	push   %rbp
  805b23:	48 89 e5             	mov    %rsp,%rbp
  805b26:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  805b2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805b31:	eb 15                	jmp    805b48 <close_all+0x26>
		close(i);
  805b33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b36:	89 c7                	mov    %eax,%edi
  805b38:	48 b8 d7 5a 80 00 00 	movabs $0x805ad7,%rax
  805b3f:	00 00 00 
  805b42:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  805b44:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805b48:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  805b4c:	7e e5                	jle    805b33 <close_all+0x11>
		close(i);
}
  805b4e:	c9                   	leaveq 
  805b4f:	c3                   	retq   

0000000000805b50 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  805b50:	55                   	push   %rbp
  805b51:	48 89 e5             	mov    %rsp,%rbp
  805b54:	48 83 ec 40          	sub    $0x40,%rsp
  805b58:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805b5b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  805b5e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  805b62:	8b 45 cc             	mov    -0x34(%rbp),%eax
  805b65:	48 89 d6             	mov    %rdx,%rsi
  805b68:	89 c7                	mov    %eax,%edi
  805b6a:	48 b8 c7 58 80 00 00 	movabs $0x8058c7,%rax
  805b71:	00 00 00 
  805b74:	ff d0                	callq  *%rax
  805b76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b7d:	79 08                	jns    805b87 <dup+0x37>
		return r;
  805b7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b82:	e9 70 01 00 00       	jmpq   805cf7 <dup+0x1a7>
	close(newfdnum);
  805b87:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805b8a:	89 c7                	mov    %eax,%edi
  805b8c:	48 b8 d7 5a 80 00 00 	movabs $0x805ad7,%rax
  805b93:	00 00 00 
  805b96:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  805b98:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805b9b:	48 98                	cltq   
  805b9d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  805ba3:	48 c1 e0 0c          	shl    $0xc,%rax
  805ba7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  805bab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805baf:	48 89 c7             	mov    %rax,%rdi
  805bb2:	48 b8 04 58 80 00 00 	movabs $0x805804,%rax
  805bb9:	00 00 00 
  805bbc:	ff d0                	callq  *%rax
  805bbe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  805bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805bc6:	48 89 c7             	mov    %rax,%rdi
  805bc9:	48 b8 04 58 80 00 00 	movabs $0x805804,%rax
  805bd0:	00 00 00 
  805bd3:	ff d0                	callq  *%rax
  805bd5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  805bd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805bdd:	48 c1 e8 15          	shr    $0x15,%rax
  805be1:	48 89 c2             	mov    %rax,%rdx
  805be4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805beb:	01 00 00 
  805bee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805bf2:	83 e0 01             	and    $0x1,%eax
  805bf5:	48 85 c0             	test   %rax,%rax
  805bf8:	74 73                	je     805c6d <dup+0x11d>
  805bfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805bfe:	48 c1 e8 0c          	shr    $0xc,%rax
  805c02:	48 89 c2             	mov    %rax,%rdx
  805c05:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805c0c:	01 00 00 
  805c0f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805c13:	83 e0 01             	and    $0x1,%eax
  805c16:	48 85 c0             	test   %rax,%rax
  805c19:	74 52                	je     805c6d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  805c1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c1f:	48 c1 e8 0c          	shr    $0xc,%rax
  805c23:	48 89 c2             	mov    %rax,%rdx
  805c26:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805c2d:	01 00 00 
  805c30:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805c34:	25 07 0e 00 00       	and    $0xe07,%eax
  805c39:	89 c1                	mov    %eax,%ecx
  805c3b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805c3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c43:	41 89 c8             	mov    %ecx,%r8d
  805c46:	48 89 d1             	mov    %rdx,%rcx
  805c49:	ba 00 00 00 00       	mov    $0x0,%edx
  805c4e:	48 89 c6             	mov    %rax,%rsi
  805c51:	bf 00 00 00 00       	mov    $0x0,%edi
  805c56:	48 b8 64 4e 80 00 00 	movabs $0x804e64,%rax
  805c5d:	00 00 00 
  805c60:	ff d0                	callq  *%rax
  805c62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805c65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c69:	79 02                	jns    805c6d <dup+0x11d>
			goto err;
  805c6b:	eb 57                	jmp    805cc4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  805c6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805c71:	48 c1 e8 0c          	shr    $0xc,%rax
  805c75:	48 89 c2             	mov    %rax,%rdx
  805c78:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805c7f:	01 00 00 
  805c82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805c86:	25 07 0e 00 00       	and    $0xe07,%eax
  805c8b:	89 c1                	mov    %eax,%ecx
  805c8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805c91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805c95:	41 89 c8             	mov    %ecx,%r8d
  805c98:	48 89 d1             	mov    %rdx,%rcx
  805c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  805ca0:	48 89 c6             	mov    %rax,%rsi
  805ca3:	bf 00 00 00 00       	mov    $0x0,%edi
  805ca8:	48 b8 64 4e 80 00 00 	movabs $0x804e64,%rax
  805caf:	00 00 00 
  805cb2:	ff d0                	callq  *%rax
  805cb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805cb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805cbb:	79 02                	jns    805cbf <dup+0x16f>
		goto err;
  805cbd:	eb 05                	jmp    805cc4 <dup+0x174>

	return newfdnum;
  805cbf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805cc2:	eb 33                	jmp    805cf7 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  805cc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805cc8:	48 89 c6             	mov    %rax,%rsi
  805ccb:	bf 00 00 00 00       	mov    $0x0,%edi
  805cd0:	48 b8 bf 4e 80 00 00 	movabs $0x804ebf,%rax
  805cd7:	00 00 00 
  805cda:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  805cdc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805ce0:	48 89 c6             	mov    %rax,%rsi
  805ce3:	bf 00 00 00 00       	mov    $0x0,%edi
  805ce8:	48 b8 bf 4e 80 00 00 	movabs $0x804ebf,%rax
  805cef:	00 00 00 
  805cf2:	ff d0                	callq  *%rax
	return r;
  805cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805cf7:	c9                   	leaveq 
  805cf8:	c3                   	retq   

0000000000805cf9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  805cf9:	55                   	push   %rbp
  805cfa:	48 89 e5             	mov    %rsp,%rbp
  805cfd:	48 83 ec 40          	sub    $0x40,%rsp
  805d01:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805d04:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805d08:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805d0c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805d10:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805d13:	48 89 d6             	mov    %rdx,%rsi
  805d16:	89 c7                	mov    %eax,%edi
  805d18:	48 b8 c7 58 80 00 00 	movabs $0x8058c7,%rax
  805d1f:	00 00 00 
  805d22:	ff d0                	callq  *%rax
  805d24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805d27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805d2b:	78 24                	js     805d51 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d31:	8b 00                	mov    (%rax),%eax
  805d33:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805d37:	48 89 d6             	mov    %rdx,%rsi
  805d3a:	89 c7                	mov    %eax,%edi
  805d3c:	48 b8 20 5a 80 00 00 	movabs $0x805a20,%rax
  805d43:	00 00 00 
  805d46:	ff d0                	callq  *%rax
  805d48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805d4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805d4f:	79 05                	jns    805d56 <read+0x5d>
		return r;
  805d51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d54:	eb 76                	jmp    805dcc <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  805d56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d5a:	8b 40 08             	mov    0x8(%rax),%eax
  805d5d:	83 e0 03             	and    $0x3,%eax
  805d60:	83 f8 01             	cmp    $0x1,%eax
  805d63:	75 3a                	jne    805d9f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  805d65:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805d6c:	00 00 00 
  805d6f:	48 8b 00             	mov    (%rax),%rax
  805d72:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805d78:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805d7b:	89 c6                	mov    %eax,%esi
  805d7d:	48 bf 4f 81 80 00 00 	movabs $0x80814f,%rdi
  805d84:	00 00 00 
  805d87:	b8 00 00 00 00       	mov    $0x0,%eax
  805d8c:	48 b9 30 39 80 00 00 	movabs $0x803930,%rcx
  805d93:	00 00 00 
  805d96:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805d98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805d9d:	eb 2d                	jmp    805dcc <read+0xd3>
	}
	if (!dev->dev_read)
  805d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805da3:	48 8b 40 10          	mov    0x10(%rax),%rax
  805da7:	48 85 c0             	test   %rax,%rax
  805daa:	75 07                	jne    805db3 <read+0xba>
		return -E_NOT_SUPP;
  805dac:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805db1:	eb 19                	jmp    805dcc <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  805db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805db7:	48 8b 40 10          	mov    0x10(%rax),%rax
  805dbb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805dbf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805dc3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805dc7:	48 89 cf             	mov    %rcx,%rdi
  805dca:	ff d0                	callq  *%rax
}
  805dcc:	c9                   	leaveq 
  805dcd:	c3                   	retq   

0000000000805dce <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  805dce:	55                   	push   %rbp
  805dcf:	48 89 e5             	mov    %rsp,%rbp
  805dd2:	48 83 ec 30          	sub    $0x30,%rsp
  805dd6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805dd9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805ddd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805de1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805de8:	eb 49                	jmp    805e33 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  805dea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ded:	48 98                	cltq   
  805def:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805df3:	48 29 c2             	sub    %rax,%rdx
  805df6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805df9:	48 63 c8             	movslq %eax,%rcx
  805dfc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805e00:	48 01 c1             	add    %rax,%rcx
  805e03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805e06:	48 89 ce             	mov    %rcx,%rsi
  805e09:	89 c7                	mov    %eax,%edi
  805e0b:	48 b8 f9 5c 80 00 00 	movabs $0x805cf9,%rax
  805e12:	00 00 00 
  805e15:	ff d0                	callq  *%rax
  805e17:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  805e1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805e1e:	79 05                	jns    805e25 <readn+0x57>
			return m;
  805e20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805e23:	eb 1c                	jmp    805e41 <readn+0x73>
		if (m == 0)
  805e25:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805e29:	75 02                	jne    805e2d <readn+0x5f>
			break;
  805e2b:	eb 11                	jmp    805e3e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805e2d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805e30:	01 45 fc             	add    %eax,-0x4(%rbp)
  805e33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e36:	48 98                	cltq   
  805e38:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  805e3c:	72 ac                	jb     805dea <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  805e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805e41:	c9                   	leaveq 
  805e42:	c3                   	retq   

0000000000805e43 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  805e43:	55                   	push   %rbp
  805e44:	48 89 e5             	mov    %rsp,%rbp
  805e47:	48 83 ec 40          	sub    $0x40,%rsp
  805e4b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805e4e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805e52:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805e56:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805e5a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805e5d:	48 89 d6             	mov    %rdx,%rsi
  805e60:	89 c7                	mov    %eax,%edi
  805e62:	48 b8 c7 58 80 00 00 	movabs $0x8058c7,%rax
  805e69:	00 00 00 
  805e6c:	ff d0                	callq  *%rax
  805e6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805e71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805e75:	78 24                	js     805e9b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805e77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805e7b:	8b 00                	mov    (%rax),%eax
  805e7d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805e81:	48 89 d6             	mov    %rdx,%rsi
  805e84:	89 c7                	mov    %eax,%edi
  805e86:	48 b8 20 5a 80 00 00 	movabs $0x805a20,%rax
  805e8d:	00 00 00 
  805e90:	ff d0                	callq  *%rax
  805e92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805e95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805e99:	79 05                	jns    805ea0 <write+0x5d>
		return r;
  805e9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e9e:	eb 42                	jmp    805ee2 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805ea0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ea4:	8b 40 08             	mov    0x8(%rax),%eax
  805ea7:	83 e0 03             	and    $0x3,%eax
  805eaa:	85 c0                	test   %eax,%eax
  805eac:	75 07                	jne    805eb5 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  805eae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805eb3:	eb 2d                	jmp    805ee2 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  805eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805eb9:	48 8b 40 18          	mov    0x18(%rax),%rax
  805ebd:	48 85 c0             	test   %rax,%rax
  805ec0:	75 07                	jne    805ec9 <write+0x86>
		return -E_NOT_SUPP;
  805ec2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805ec7:	eb 19                	jmp    805ee2 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  805ec9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805ecd:	48 8b 40 18          	mov    0x18(%rax),%rax
  805ed1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805ed5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805ed9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805edd:	48 89 cf             	mov    %rcx,%rdi
  805ee0:	ff d0                	callq  *%rax
}
  805ee2:	c9                   	leaveq 
  805ee3:	c3                   	retq   

0000000000805ee4 <seek>:

int
seek(int fdnum, off_t offset)
{
  805ee4:	55                   	push   %rbp
  805ee5:	48 89 e5             	mov    %rsp,%rbp
  805ee8:	48 83 ec 18          	sub    $0x18,%rsp
  805eec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805eef:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805ef2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805ef6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805ef9:	48 89 d6             	mov    %rdx,%rsi
  805efc:	89 c7                	mov    %eax,%edi
  805efe:	48 b8 c7 58 80 00 00 	movabs $0x8058c7,%rax
  805f05:	00 00 00 
  805f08:	ff d0                	callq  *%rax
  805f0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f11:	79 05                	jns    805f18 <seek+0x34>
		return r;
  805f13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f16:	eb 0f                	jmp    805f27 <seek+0x43>
	fd->fd_offset = offset;
  805f18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f1c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805f1f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  805f22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805f27:	c9                   	leaveq 
  805f28:	c3                   	retq   

0000000000805f29 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  805f29:	55                   	push   %rbp
  805f2a:	48 89 e5             	mov    %rsp,%rbp
  805f2d:	48 83 ec 30          	sub    $0x30,%rsp
  805f31:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805f34:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  805f37:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805f3b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805f3e:	48 89 d6             	mov    %rdx,%rsi
  805f41:	89 c7                	mov    %eax,%edi
  805f43:	48 b8 c7 58 80 00 00 	movabs $0x8058c7,%rax
  805f4a:	00 00 00 
  805f4d:	ff d0                	callq  *%rax
  805f4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f56:	78 24                	js     805f7c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805f5c:	8b 00                	mov    (%rax),%eax
  805f5e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805f62:	48 89 d6             	mov    %rdx,%rsi
  805f65:	89 c7                	mov    %eax,%edi
  805f67:	48 b8 20 5a 80 00 00 	movabs $0x805a20,%rax
  805f6e:	00 00 00 
  805f71:	ff d0                	callq  *%rax
  805f73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f7a:	79 05                	jns    805f81 <ftruncate+0x58>
		return r;
  805f7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f7f:	eb 72                	jmp    805ff3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805f85:	8b 40 08             	mov    0x8(%rax),%eax
  805f88:	83 e0 03             	and    $0x3,%eax
  805f8b:	85 c0                	test   %eax,%eax
  805f8d:	75 3a                	jne    805fc9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  805f8f:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805f96:	00 00 00 
  805f99:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  805f9c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805fa2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805fa5:	89 c6                	mov    %eax,%esi
  805fa7:	48 bf 70 81 80 00 00 	movabs $0x808170,%rdi
  805fae:	00 00 00 
  805fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  805fb6:	48 b9 30 39 80 00 00 	movabs $0x803930,%rcx
  805fbd:	00 00 00 
  805fc0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  805fc2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805fc7:	eb 2a                	jmp    805ff3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  805fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805fcd:	48 8b 40 30          	mov    0x30(%rax),%rax
  805fd1:	48 85 c0             	test   %rax,%rax
  805fd4:	75 07                	jne    805fdd <ftruncate+0xb4>
		return -E_NOT_SUPP;
  805fd6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805fdb:	eb 16                	jmp    805ff3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  805fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805fe1:	48 8b 40 30          	mov    0x30(%rax),%rax
  805fe5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805fe9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  805fec:	89 ce                	mov    %ecx,%esi
  805fee:	48 89 d7             	mov    %rdx,%rdi
  805ff1:	ff d0                	callq  *%rax
}
  805ff3:	c9                   	leaveq 
  805ff4:	c3                   	retq   

0000000000805ff5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  805ff5:	55                   	push   %rbp
  805ff6:	48 89 e5             	mov    %rsp,%rbp
  805ff9:	48 83 ec 30          	sub    $0x30,%rsp
  805ffd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  806000:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  806004:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  806008:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80600b:	48 89 d6             	mov    %rdx,%rsi
  80600e:	89 c7                	mov    %eax,%edi
  806010:	48 b8 c7 58 80 00 00 	movabs $0x8058c7,%rax
  806017:	00 00 00 
  80601a:	ff d0                	callq  *%rax
  80601c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80601f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806023:	78 24                	js     806049 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  806025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806029:	8b 00                	mov    (%rax),%eax
  80602b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80602f:	48 89 d6             	mov    %rdx,%rsi
  806032:	89 c7                	mov    %eax,%edi
  806034:	48 b8 20 5a 80 00 00 	movabs $0x805a20,%rax
  80603b:	00 00 00 
  80603e:	ff d0                	callq  *%rax
  806040:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806043:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806047:	79 05                	jns    80604e <fstat+0x59>
		return r;
  806049:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80604c:	eb 5e                	jmp    8060ac <fstat+0xb7>
	if (!dev->dev_stat)
  80604e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806052:	48 8b 40 28          	mov    0x28(%rax),%rax
  806056:	48 85 c0             	test   %rax,%rax
  806059:	75 07                	jne    806062 <fstat+0x6d>
		return -E_NOT_SUPP;
  80605b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  806060:	eb 4a                	jmp    8060ac <fstat+0xb7>
	stat->st_name[0] = 0;
  806062:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806066:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  806069:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80606d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  806074:	00 00 00 
	stat->st_isdir = 0;
  806077:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80607b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806082:	00 00 00 
	stat->st_dev = dev;
  806085:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806089:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80608d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  806094:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806098:	48 8b 40 28          	mov    0x28(%rax),%rax
  80609c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8060a0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8060a4:	48 89 ce             	mov    %rcx,%rsi
  8060a7:	48 89 d7             	mov    %rdx,%rdi
  8060aa:	ff d0                	callq  *%rax
}
  8060ac:	c9                   	leaveq 
  8060ad:	c3                   	retq   

00000000008060ae <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8060ae:	55                   	push   %rbp
  8060af:	48 89 e5             	mov    %rsp,%rbp
  8060b2:	48 83 ec 20          	sub    $0x20,%rsp
  8060b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8060ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8060be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8060c2:	be 00 00 00 00       	mov    $0x0,%esi
  8060c7:	48 89 c7             	mov    %rax,%rdi
  8060ca:	48 b8 9c 61 80 00 00 	movabs $0x80619c,%rax
  8060d1:	00 00 00 
  8060d4:	ff d0                	callq  *%rax
  8060d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8060d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8060dd:	79 05                	jns    8060e4 <stat+0x36>
		return fd;
  8060df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8060e2:	eb 2f                	jmp    806113 <stat+0x65>
	r = fstat(fd, stat);
  8060e4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8060e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8060eb:	48 89 d6             	mov    %rdx,%rsi
  8060ee:	89 c7                	mov    %eax,%edi
  8060f0:	48 b8 f5 5f 80 00 00 	movabs $0x805ff5,%rax
  8060f7:	00 00 00 
  8060fa:	ff d0                	callq  *%rax
  8060fc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8060ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806102:	89 c7                	mov    %eax,%edi
  806104:	48 b8 d7 5a 80 00 00 	movabs $0x805ad7,%rax
  80610b:	00 00 00 
  80610e:	ff d0                	callq  *%rax
	return r;
  806110:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  806113:	c9                   	leaveq 
  806114:	c3                   	retq   

0000000000806115 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  806115:	55                   	push   %rbp
  806116:	48 89 e5             	mov    %rsp,%rbp
  806119:	48 83 ec 10          	sub    $0x10,%rsp
  80611d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806120:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  806124:	48 b8 08 60 81 00 00 	movabs $0x816008,%rax
  80612b:	00 00 00 
  80612e:	8b 00                	mov    (%rax),%eax
  806130:	85 c0                	test   %eax,%eax
  806132:	75 1d                	jne    806151 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  806134:	bf 01 00 00 00       	mov    $0x1,%edi
  806139:	48 b8 6f 57 80 00 00 	movabs $0x80576f,%rax
  806140:	00 00 00 
  806143:	ff d0                	callq  *%rax
  806145:	48 ba 08 60 81 00 00 	movabs $0x816008,%rdx
  80614c:	00 00 00 
  80614f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  806151:	48 b8 08 60 81 00 00 	movabs $0x816008,%rax
  806158:	00 00 00 
  80615b:	8b 00                	mov    (%rax),%eax
  80615d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  806160:	b9 07 00 00 00       	mov    $0x7,%ecx
  806165:	48 ba 00 70 81 00 00 	movabs $0x817000,%rdx
  80616c:	00 00 00 
  80616f:	89 c7                	mov    %eax,%edi
  806171:	48 b8 a2 53 80 00 00 	movabs $0x8053a2,%rax
  806178:	00 00 00 
  80617b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80617d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806181:	ba 00 00 00 00       	mov    $0x0,%edx
  806186:	48 89 c6             	mov    %rax,%rsi
  806189:	bf 00 00 00 00       	mov    $0x0,%edi
  80618e:	48 b8 a4 52 80 00 00 	movabs $0x8052a4,%rax
  806195:	00 00 00 
  806198:	ff d0                	callq  *%rax
}
  80619a:	c9                   	leaveq 
  80619b:	c3                   	retq   

000000000080619c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80619c:	55                   	push   %rbp
  80619d:	48 89 e5             	mov    %rsp,%rbp
  8061a0:	48 83 ec 30          	sub    $0x30,%rsp
  8061a4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8061a8:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8061ab:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8061b2:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8061b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8061c0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8061c5:	75 08                	jne    8061cf <open+0x33>
	{
		return r;
  8061c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8061ca:	e9 f2 00 00 00       	jmpq   8062c1 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8061cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8061d3:	48 89 c7             	mov    %rax,%rdi
  8061d6:	48 b8 79 44 80 00 00 	movabs $0x804479,%rax
  8061dd:	00 00 00 
  8061e0:	ff d0                	callq  *%rax
  8061e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8061e5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8061ec:	7e 0a                	jle    8061f8 <open+0x5c>
	{
		return -E_BAD_PATH;
  8061ee:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8061f3:	e9 c9 00 00 00       	jmpq   8062c1 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8061f8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8061ff:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  806200:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  806204:	48 89 c7             	mov    %rax,%rdi
  806207:	48 b8 2f 58 80 00 00 	movabs $0x80582f,%rax
  80620e:	00 00 00 
  806211:	ff d0                	callq  *%rax
  806213:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80621a:	78 09                	js     806225 <open+0x89>
  80621c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806220:	48 85 c0             	test   %rax,%rax
  806223:	75 08                	jne    80622d <open+0x91>
		{
			return r;
  806225:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806228:	e9 94 00 00 00       	jmpq   8062c1 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80622d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806231:	ba 00 04 00 00       	mov    $0x400,%edx
  806236:	48 89 c6             	mov    %rax,%rsi
  806239:	48 bf 00 70 81 00 00 	movabs $0x817000,%rdi
  806240:	00 00 00 
  806243:	48 b8 77 45 80 00 00 	movabs $0x804577,%rax
  80624a:	00 00 00 
  80624d:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80624f:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806256:	00 00 00 
  806259:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80625c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  806262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806266:	48 89 c6             	mov    %rax,%rsi
  806269:	bf 01 00 00 00       	mov    $0x1,%edi
  80626e:	48 b8 15 61 80 00 00 	movabs $0x806115,%rax
  806275:	00 00 00 
  806278:	ff d0                	callq  *%rax
  80627a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80627d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806281:	79 2b                	jns    8062ae <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  806283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806287:	be 00 00 00 00       	mov    $0x0,%esi
  80628c:	48 89 c7             	mov    %rax,%rdi
  80628f:	48 b8 57 59 80 00 00 	movabs $0x805957,%rax
  806296:	00 00 00 
  806299:	ff d0                	callq  *%rax
  80629b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80629e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8062a2:	79 05                	jns    8062a9 <open+0x10d>
			{
				return d;
  8062a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8062a7:	eb 18                	jmp    8062c1 <open+0x125>
			}
			return r;
  8062a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8062ac:	eb 13                	jmp    8062c1 <open+0x125>
		}	
		return fd2num(fd_store);
  8062ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8062b2:	48 89 c7             	mov    %rax,%rdi
  8062b5:	48 b8 e1 57 80 00 00 	movabs $0x8057e1,%rax
  8062bc:	00 00 00 
  8062bf:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8062c1:	c9                   	leaveq 
  8062c2:	c3                   	retq   

00000000008062c3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8062c3:	55                   	push   %rbp
  8062c4:	48 89 e5             	mov    %rsp,%rbp
  8062c7:	48 83 ec 10          	sub    $0x10,%rsp
  8062cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8062cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062d3:	8b 50 0c             	mov    0xc(%rax),%edx
  8062d6:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8062dd:	00 00 00 
  8062e0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8062e2:	be 00 00 00 00       	mov    $0x0,%esi
  8062e7:	bf 06 00 00 00       	mov    $0x6,%edi
  8062ec:	48 b8 15 61 80 00 00 	movabs $0x806115,%rax
  8062f3:	00 00 00 
  8062f6:	ff d0                	callq  *%rax
}
  8062f8:	c9                   	leaveq 
  8062f9:	c3                   	retq   

00000000008062fa <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8062fa:	55                   	push   %rbp
  8062fb:	48 89 e5             	mov    %rsp,%rbp
  8062fe:	48 83 ec 30          	sub    $0x30,%rsp
  806302:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806306:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80630a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80630e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  806315:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80631a:	74 07                	je     806323 <devfile_read+0x29>
  80631c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  806321:	75 07                	jne    80632a <devfile_read+0x30>
		return -E_INVAL;
  806323:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  806328:	eb 77                	jmp    8063a1 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80632a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80632e:	8b 50 0c             	mov    0xc(%rax),%edx
  806331:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806338:	00 00 00 
  80633b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80633d:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806344:	00 00 00 
  806347:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80634b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80634f:	be 00 00 00 00       	mov    $0x0,%esi
  806354:	bf 03 00 00 00       	mov    $0x3,%edi
  806359:	48 b8 15 61 80 00 00 	movabs $0x806115,%rax
  806360:	00 00 00 
  806363:	ff d0                	callq  *%rax
  806365:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806368:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80636c:	7f 05                	jg     806373 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80636e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806371:	eb 2e                	jmp    8063a1 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  806373:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806376:	48 63 d0             	movslq %eax,%rdx
  806379:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80637d:	48 be 00 70 81 00 00 	movabs $0x817000,%rsi
  806384:	00 00 00 
  806387:	48 89 c7             	mov    %rax,%rdi
  80638a:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  806391:	00 00 00 
  806394:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  806396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80639a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80639e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8063a1:	c9                   	leaveq 
  8063a2:	c3                   	retq   

00000000008063a3 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8063a3:	55                   	push   %rbp
  8063a4:	48 89 e5             	mov    %rsp,%rbp
  8063a7:	48 83 ec 30          	sub    $0x30,%rsp
  8063ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8063af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8063b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8063b7:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8063be:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8063c3:	74 07                	je     8063cc <devfile_write+0x29>
  8063c5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8063ca:	75 08                	jne    8063d4 <devfile_write+0x31>
		return r;
  8063cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8063cf:	e9 9a 00 00 00       	jmpq   80646e <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8063d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8063d8:	8b 50 0c             	mov    0xc(%rax),%edx
  8063db:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8063e2:	00 00 00 
  8063e5:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8063e7:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8063ee:	00 
  8063ef:	76 08                	jbe    8063f9 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8063f1:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8063f8:	00 
	}
	fsipcbuf.write.req_n = n;
  8063f9:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806400:	00 00 00 
  806403:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  806407:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80640b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80640f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806413:	48 89 c6             	mov    %rax,%rsi
  806416:	48 bf 10 70 81 00 00 	movabs $0x817010,%rdi
  80641d:	00 00 00 
  806420:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  806427:	00 00 00 
  80642a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80642c:	be 00 00 00 00       	mov    $0x0,%esi
  806431:	bf 04 00 00 00       	mov    $0x4,%edi
  806436:	48 b8 15 61 80 00 00 	movabs $0x806115,%rax
  80643d:	00 00 00 
  806440:	ff d0                	callq  *%rax
  806442:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806445:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806449:	7f 20                	jg     80646b <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80644b:	48 bf 96 81 80 00 00 	movabs $0x808196,%rdi
  806452:	00 00 00 
  806455:	b8 00 00 00 00       	mov    $0x0,%eax
  80645a:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  806461:	00 00 00 
  806464:	ff d2                	callq  *%rdx
		return r;
  806466:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806469:	eb 03                	jmp    80646e <devfile_write+0xcb>
	}
	return r;
  80646b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80646e:	c9                   	leaveq 
  80646f:	c3                   	retq   

0000000000806470 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  806470:	55                   	push   %rbp
  806471:	48 89 e5             	mov    %rsp,%rbp
  806474:	48 83 ec 20          	sub    $0x20,%rsp
  806478:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80647c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  806480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806484:	8b 50 0c             	mov    0xc(%rax),%edx
  806487:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  80648e:	00 00 00 
  806491:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  806493:	be 00 00 00 00       	mov    $0x0,%esi
  806498:	bf 05 00 00 00       	mov    $0x5,%edi
  80649d:	48 b8 15 61 80 00 00 	movabs $0x806115,%rax
  8064a4:	00 00 00 
  8064a7:	ff d0                	callq  *%rax
  8064a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8064ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8064b0:	79 05                	jns    8064b7 <devfile_stat+0x47>
		return r;
  8064b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8064b5:	eb 56                	jmp    80650d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8064b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8064bb:	48 be 00 70 81 00 00 	movabs $0x817000,%rsi
  8064c2:	00 00 00 
  8064c5:	48 89 c7             	mov    %rax,%rdi
  8064c8:	48 b8 e5 44 80 00 00 	movabs $0x8044e5,%rax
  8064cf:	00 00 00 
  8064d2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8064d4:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8064db:	00 00 00 
  8064de:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8064e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8064e8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8064ee:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8064f5:	00 00 00 
  8064f8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8064fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806502:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  806508:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80650d:	c9                   	leaveq 
  80650e:	c3                   	retq   

000000000080650f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80650f:	55                   	push   %rbp
  806510:	48 89 e5             	mov    %rsp,%rbp
  806513:	48 83 ec 10          	sub    $0x10,%rsp
  806517:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80651b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80651e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806522:	8b 50 0c             	mov    0xc(%rax),%edx
  806525:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  80652c:	00 00 00 
  80652f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  806531:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806538:	00 00 00 
  80653b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80653e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  806541:	be 00 00 00 00       	mov    $0x0,%esi
  806546:	bf 02 00 00 00       	mov    $0x2,%edi
  80654b:	48 b8 15 61 80 00 00 	movabs $0x806115,%rax
  806552:	00 00 00 
  806555:	ff d0                	callq  *%rax
}
  806557:	c9                   	leaveq 
  806558:	c3                   	retq   

0000000000806559 <remove>:

// Delete a file
int
remove(const char *path)
{
  806559:	55                   	push   %rbp
  80655a:	48 89 e5             	mov    %rsp,%rbp
  80655d:	48 83 ec 10          	sub    $0x10,%rsp
  806561:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  806565:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806569:	48 89 c7             	mov    %rax,%rdi
  80656c:	48 b8 79 44 80 00 00 	movabs $0x804479,%rax
  806573:	00 00 00 
  806576:	ff d0                	callq  *%rax
  806578:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80657d:	7e 07                	jle    806586 <remove+0x2d>
		return -E_BAD_PATH;
  80657f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  806584:	eb 33                	jmp    8065b9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  806586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80658a:	48 89 c6             	mov    %rax,%rsi
  80658d:	48 bf 00 70 81 00 00 	movabs $0x817000,%rdi
  806594:	00 00 00 
  806597:	48 b8 e5 44 80 00 00 	movabs $0x8044e5,%rax
  80659e:	00 00 00 
  8065a1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8065a3:	be 00 00 00 00       	mov    $0x0,%esi
  8065a8:	bf 07 00 00 00       	mov    $0x7,%edi
  8065ad:	48 b8 15 61 80 00 00 	movabs $0x806115,%rax
  8065b4:	00 00 00 
  8065b7:	ff d0                	callq  *%rax
}
  8065b9:	c9                   	leaveq 
  8065ba:	c3                   	retq   

00000000008065bb <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8065bb:	55                   	push   %rbp
  8065bc:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8065bf:	be 00 00 00 00       	mov    $0x0,%esi
  8065c4:	bf 08 00 00 00       	mov    $0x8,%edi
  8065c9:	48 b8 15 61 80 00 00 	movabs $0x806115,%rax
  8065d0:	00 00 00 
  8065d3:	ff d0                	callq  *%rax
}
  8065d5:	5d                   	pop    %rbp
  8065d6:	c3                   	retq   

00000000008065d7 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8065d7:	55                   	push   %rbp
  8065d8:	48 89 e5             	mov    %rsp,%rbp
  8065db:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8065e2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8065e9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8065f0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8065f7:	be 00 00 00 00       	mov    $0x0,%esi
  8065fc:	48 89 c7             	mov    %rax,%rdi
  8065ff:	48 b8 9c 61 80 00 00 	movabs $0x80619c,%rax
  806606:	00 00 00 
  806609:	ff d0                	callq  *%rax
  80660b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80660e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806612:	79 28                	jns    80663c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  806614:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806617:	89 c6                	mov    %eax,%esi
  806619:	48 bf b2 81 80 00 00 	movabs $0x8081b2,%rdi
  806620:	00 00 00 
  806623:	b8 00 00 00 00       	mov    $0x0,%eax
  806628:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  80662f:	00 00 00 
  806632:	ff d2                	callq  *%rdx
		return fd_src;
  806634:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806637:	e9 74 01 00 00       	jmpq   8067b0 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80663c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  806643:	be 01 01 00 00       	mov    $0x101,%esi
  806648:	48 89 c7             	mov    %rax,%rdi
  80664b:	48 b8 9c 61 80 00 00 	movabs $0x80619c,%rax
  806652:	00 00 00 
  806655:	ff d0                	callq  *%rax
  806657:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80665a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80665e:	79 39                	jns    806699 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  806660:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806663:	89 c6                	mov    %eax,%esi
  806665:	48 bf c8 81 80 00 00 	movabs $0x8081c8,%rdi
  80666c:	00 00 00 
  80666f:	b8 00 00 00 00       	mov    $0x0,%eax
  806674:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  80667b:	00 00 00 
  80667e:	ff d2                	callq  *%rdx
		close(fd_src);
  806680:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806683:	89 c7                	mov    %eax,%edi
  806685:	48 b8 d7 5a 80 00 00 	movabs $0x805ad7,%rax
  80668c:	00 00 00 
  80668f:	ff d0                	callq  *%rax
		return fd_dest;
  806691:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806694:	e9 17 01 00 00       	jmpq   8067b0 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  806699:	eb 74                	jmp    80670f <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80669b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80669e:	48 63 d0             	movslq %eax,%rdx
  8066a1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8066a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8066ab:	48 89 ce             	mov    %rcx,%rsi
  8066ae:	89 c7                	mov    %eax,%edi
  8066b0:	48 b8 43 5e 80 00 00 	movabs $0x805e43,%rax
  8066b7:	00 00 00 
  8066ba:	ff d0                	callq  *%rax
  8066bc:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8066bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8066c3:	79 4a                	jns    80670f <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8066c5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8066c8:	89 c6                	mov    %eax,%esi
  8066ca:	48 bf e2 81 80 00 00 	movabs $0x8081e2,%rdi
  8066d1:	00 00 00 
  8066d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8066d9:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  8066e0:	00 00 00 
  8066e3:	ff d2                	callq  *%rdx
			close(fd_src);
  8066e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066e8:	89 c7                	mov    %eax,%edi
  8066ea:	48 b8 d7 5a 80 00 00 	movabs $0x805ad7,%rax
  8066f1:	00 00 00 
  8066f4:	ff d0                	callq  *%rax
			close(fd_dest);
  8066f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8066f9:	89 c7                	mov    %eax,%edi
  8066fb:	48 b8 d7 5a 80 00 00 	movabs $0x805ad7,%rax
  806702:	00 00 00 
  806705:	ff d0                	callq  *%rax
			return write_size;
  806707:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80670a:	e9 a1 00 00 00       	jmpq   8067b0 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80670f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  806716:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806719:	ba 00 02 00 00       	mov    $0x200,%edx
  80671e:	48 89 ce             	mov    %rcx,%rsi
  806721:	89 c7                	mov    %eax,%edi
  806723:	48 b8 f9 5c 80 00 00 	movabs $0x805cf9,%rax
  80672a:	00 00 00 
  80672d:	ff d0                	callq  *%rax
  80672f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  806732:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  806736:	0f 8f 5f ff ff ff    	jg     80669b <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80673c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  806740:	79 47                	jns    806789 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  806742:	8b 45 f4             	mov    -0xc(%rbp),%eax
  806745:	89 c6                	mov    %eax,%esi
  806747:	48 bf f5 81 80 00 00 	movabs $0x8081f5,%rdi
  80674e:	00 00 00 
  806751:	b8 00 00 00 00       	mov    $0x0,%eax
  806756:	48 ba 30 39 80 00 00 	movabs $0x803930,%rdx
  80675d:	00 00 00 
  806760:	ff d2                	callq  *%rdx
		close(fd_src);
  806762:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806765:	89 c7                	mov    %eax,%edi
  806767:	48 b8 d7 5a 80 00 00 	movabs $0x805ad7,%rax
  80676e:	00 00 00 
  806771:	ff d0                	callq  *%rax
		close(fd_dest);
  806773:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806776:	89 c7                	mov    %eax,%edi
  806778:	48 b8 d7 5a 80 00 00 	movabs $0x805ad7,%rax
  80677f:	00 00 00 
  806782:	ff d0                	callq  *%rax
		return read_size;
  806784:	8b 45 f4             	mov    -0xc(%rbp),%eax
  806787:	eb 27                	jmp    8067b0 <copy+0x1d9>
	}
	close(fd_src);
  806789:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80678c:	89 c7                	mov    %eax,%edi
  80678e:	48 b8 d7 5a 80 00 00 	movabs $0x805ad7,%rax
  806795:	00 00 00 
  806798:	ff d0                	callq  *%rax
	close(fd_dest);
  80679a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80679d:	89 c7                	mov    %eax,%edi
  80679f:	48 b8 d7 5a 80 00 00 	movabs $0x805ad7,%rax
  8067a6:	00 00 00 
  8067a9:	ff d0                	callq  *%rax
	return 0;
  8067ab:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8067b0:	c9                   	leaveq 
  8067b1:	c3                   	retq   

00000000008067b2 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8067b2:	55                   	push   %rbp
  8067b3:	48 89 e5             	mov    %rsp,%rbp
  8067b6:	48 83 ec 20          	sub    $0x20,%rsp
  8067ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8067be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8067c2:	8b 40 0c             	mov    0xc(%rax),%eax
  8067c5:	85 c0                	test   %eax,%eax
  8067c7:	7e 67                	jle    806830 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8067c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8067cd:	8b 40 04             	mov    0x4(%rax),%eax
  8067d0:	48 63 d0             	movslq %eax,%rdx
  8067d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8067d7:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8067db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8067df:	8b 00                	mov    (%rax),%eax
  8067e1:	48 89 ce             	mov    %rcx,%rsi
  8067e4:	89 c7                	mov    %eax,%edi
  8067e6:	48 b8 43 5e 80 00 00 	movabs $0x805e43,%rax
  8067ed:	00 00 00 
  8067f0:	ff d0                	callq  *%rax
  8067f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8067f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8067f9:	7e 13                	jle    80680e <writebuf+0x5c>
			b->result += result;
  8067fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8067ff:	8b 50 08             	mov    0x8(%rax),%edx
  806802:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806805:	01 c2                	add    %eax,%edx
  806807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80680b:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  80680e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806812:	8b 40 04             	mov    0x4(%rax),%eax
  806815:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  806818:	74 16                	je     806830 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  80681a:	b8 00 00 00 00       	mov    $0x0,%eax
  80681f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806823:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  806827:	89 c2                	mov    %eax,%edx
  806829:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80682d:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  806830:	c9                   	leaveq 
  806831:	c3                   	retq   

0000000000806832 <putch>:

static void
putch(int ch, void *thunk)
{
  806832:	55                   	push   %rbp
  806833:	48 89 e5             	mov    %rsp,%rbp
  806836:	48 83 ec 20          	sub    $0x20,%rsp
  80683a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80683d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  806841:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806845:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  806849:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80684d:	8b 40 04             	mov    0x4(%rax),%eax
  806850:	8d 48 01             	lea    0x1(%rax),%ecx
  806853:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806857:	89 4a 04             	mov    %ecx,0x4(%rdx)
  80685a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80685d:	89 d1                	mov    %edx,%ecx
  80685f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806863:	48 98                	cltq   
  806865:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  806869:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80686d:	8b 40 04             	mov    0x4(%rax),%eax
  806870:	3d 00 01 00 00       	cmp    $0x100,%eax
  806875:	75 1e                	jne    806895 <putch+0x63>
		writebuf(b);
  806877:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80687b:	48 89 c7             	mov    %rax,%rdi
  80687e:	48 b8 b2 67 80 00 00 	movabs $0x8067b2,%rax
  806885:	00 00 00 
  806888:	ff d0                	callq  *%rax
		b->idx = 0;
  80688a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80688e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  806895:	c9                   	leaveq 
  806896:	c3                   	retq   

0000000000806897 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  806897:	55                   	push   %rbp
  806898:	48 89 e5             	mov    %rsp,%rbp
  80689b:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8068a2:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8068a8:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8068af:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8068b6:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8068bc:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8068c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8068c9:	00 00 00 
	b.result = 0;
  8068cc:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8068d3:	00 00 00 
	b.error = 1;
  8068d6:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8068dd:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8068e0:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8068e7:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8068ee:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8068f5:	48 89 c6             	mov    %rax,%rsi
  8068f8:	48 bf 32 68 80 00 00 	movabs $0x806832,%rdi
  8068ff:	00 00 00 
  806902:	48 b8 e3 3c 80 00 00 	movabs $0x803ce3,%rax
  806909:	00 00 00 
  80690c:	ff d0                	callq  *%rax
	if (b.idx > 0)
  80690e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  806914:	85 c0                	test   %eax,%eax
  806916:	7e 16                	jle    80692e <vfprintf+0x97>
		writebuf(&b);
  806918:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80691f:	48 89 c7             	mov    %rax,%rdi
  806922:	48 b8 b2 67 80 00 00 	movabs $0x8067b2,%rax
  806929:	00 00 00 
  80692c:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80692e:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  806934:	85 c0                	test   %eax,%eax
  806936:	74 08                	je     806940 <vfprintf+0xa9>
  806938:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80693e:	eb 06                	jmp    806946 <vfprintf+0xaf>
  806940:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  806946:	c9                   	leaveq 
  806947:	c3                   	retq   

0000000000806948 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  806948:	55                   	push   %rbp
  806949:	48 89 e5             	mov    %rsp,%rbp
  80694c:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  806953:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  806959:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  806960:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  806967:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80696e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  806975:	84 c0                	test   %al,%al
  806977:	74 20                	je     806999 <fprintf+0x51>
  806979:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80697d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  806981:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  806985:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  806989:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80698d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  806991:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  806995:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  806999:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8069a0:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8069a7:	00 00 00 
  8069aa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8069b1:	00 00 00 
  8069b4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8069b8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8069bf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8069c6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8069cd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8069d4:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8069db:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8069e1:	48 89 ce             	mov    %rcx,%rsi
  8069e4:	89 c7                	mov    %eax,%edi
  8069e6:	48 b8 97 68 80 00 00 	movabs $0x806897,%rax
  8069ed:	00 00 00 
  8069f0:	ff d0                	callq  *%rax
  8069f2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8069f8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8069fe:	c9                   	leaveq 
  8069ff:	c3                   	retq   

0000000000806a00 <printf>:

int
printf(const char *fmt, ...)
{
  806a00:	55                   	push   %rbp
  806a01:	48 89 e5             	mov    %rsp,%rbp
  806a04:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  806a0b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  806a12:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  806a19:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  806a20:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  806a27:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  806a2e:	84 c0                	test   %al,%al
  806a30:	74 20                	je     806a52 <printf+0x52>
  806a32:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  806a36:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  806a3a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  806a3e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  806a42:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  806a46:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  806a4a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  806a4e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  806a52:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  806a59:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  806a60:	00 00 00 
  806a63:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  806a6a:	00 00 00 
  806a6d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  806a71:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  806a78:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  806a7f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  806a86:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  806a8d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  806a94:	48 89 c6             	mov    %rax,%rsi
  806a97:	bf 01 00 00 00       	mov    $0x1,%edi
  806a9c:	48 b8 97 68 80 00 00 	movabs $0x806897,%rax
  806aa3:	00 00 00 
  806aa6:	ff d0                	callq  *%rax
  806aa8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  806aae:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  806ab4:	c9                   	leaveq 
  806ab5:	c3                   	retq   

0000000000806ab6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  806ab6:	55                   	push   %rbp
  806ab7:	48 89 e5             	mov    %rsp,%rbp
  806aba:	48 83 ec 18          	sub    $0x18,%rsp
  806abe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  806ac2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806ac6:	48 c1 e8 15          	shr    $0x15,%rax
  806aca:	48 89 c2             	mov    %rax,%rdx
  806acd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  806ad4:	01 00 00 
  806ad7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806adb:	83 e0 01             	and    $0x1,%eax
  806ade:	48 85 c0             	test   %rax,%rax
  806ae1:	75 07                	jne    806aea <pageref+0x34>
		return 0;
  806ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  806ae8:	eb 53                	jmp    806b3d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  806aea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806aee:	48 c1 e8 0c          	shr    $0xc,%rax
  806af2:	48 89 c2             	mov    %rax,%rdx
  806af5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  806afc:	01 00 00 
  806aff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806b03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  806b07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806b0b:	83 e0 01             	and    $0x1,%eax
  806b0e:	48 85 c0             	test   %rax,%rax
  806b11:	75 07                	jne    806b1a <pageref+0x64>
		return 0;
  806b13:	b8 00 00 00 00       	mov    $0x0,%eax
  806b18:	eb 23                	jmp    806b3d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  806b1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806b1e:	48 c1 e8 0c          	shr    $0xc,%rax
  806b22:	48 89 c2             	mov    %rax,%rdx
  806b25:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  806b2c:	00 00 00 
  806b2f:	48 c1 e2 04          	shl    $0x4,%rdx
  806b33:	48 01 d0             	add    %rdx,%rax
  806b36:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  806b3a:	0f b7 c0             	movzwl %ax,%eax
}
  806b3d:	c9                   	leaveq 
  806b3e:	c3                   	retq   

0000000000806b3f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  806b3f:	55                   	push   %rbp
  806b40:	48 89 e5             	mov    %rsp,%rbp
  806b43:	53                   	push   %rbx
  806b44:	48 83 ec 38          	sub    $0x38,%rsp
  806b48:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  806b4c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  806b50:	48 89 c7             	mov    %rax,%rdi
  806b53:	48 b8 2f 58 80 00 00 	movabs $0x80582f,%rax
  806b5a:	00 00 00 
  806b5d:	ff d0                	callq  *%rax
  806b5f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806b62:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806b66:	0f 88 bf 01 00 00    	js     806d2b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806b6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806b70:	ba 07 04 00 00       	mov    $0x407,%edx
  806b75:	48 89 c6             	mov    %rax,%rsi
  806b78:	bf 00 00 00 00       	mov    $0x0,%edi
  806b7d:	48 b8 14 4e 80 00 00 	movabs $0x804e14,%rax
  806b84:	00 00 00 
  806b87:	ff d0                	callq  *%rax
  806b89:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806b8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806b90:	0f 88 95 01 00 00    	js     806d2b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  806b96:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  806b9a:	48 89 c7             	mov    %rax,%rdi
  806b9d:	48 b8 2f 58 80 00 00 	movabs $0x80582f,%rax
  806ba4:	00 00 00 
  806ba7:	ff d0                	callq  *%rax
  806ba9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806bac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806bb0:	0f 88 5d 01 00 00    	js     806d13 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806bb6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806bba:	ba 07 04 00 00       	mov    $0x407,%edx
  806bbf:	48 89 c6             	mov    %rax,%rsi
  806bc2:	bf 00 00 00 00       	mov    $0x0,%edi
  806bc7:	48 b8 14 4e 80 00 00 	movabs $0x804e14,%rax
  806bce:	00 00 00 
  806bd1:	ff d0                	callq  *%rax
  806bd3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806bd6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806bda:	0f 88 33 01 00 00    	js     806d13 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  806be0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806be4:	48 89 c7             	mov    %rax,%rdi
  806be7:	48 b8 04 58 80 00 00 	movabs $0x805804,%rax
  806bee:	00 00 00 
  806bf1:	ff d0                	callq  *%rax
  806bf3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806bf7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806bfb:	ba 07 04 00 00       	mov    $0x407,%edx
  806c00:	48 89 c6             	mov    %rax,%rsi
  806c03:	bf 00 00 00 00       	mov    $0x0,%edi
  806c08:	48 b8 14 4e 80 00 00 	movabs $0x804e14,%rax
  806c0f:	00 00 00 
  806c12:	ff d0                	callq  *%rax
  806c14:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806c17:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806c1b:	79 05                	jns    806c22 <pipe+0xe3>
		goto err2;
  806c1d:	e9 d9 00 00 00       	jmpq   806cfb <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806c22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806c26:	48 89 c7             	mov    %rax,%rdi
  806c29:	48 b8 04 58 80 00 00 	movabs $0x805804,%rax
  806c30:	00 00 00 
  806c33:	ff d0                	callq  *%rax
  806c35:	48 89 c2             	mov    %rax,%rdx
  806c38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806c3c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  806c42:	48 89 d1             	mov    %rdx,%rcx
  806c45:	ba 00 00 00 00       	mov    $0x0,%edx
  806c4a:	48 89 c6             	mov    %rax,%rsi
  806c4d:	bf 00 00 00 00       	mov    $0x0,%edi
  806c52:	48 b8 64 4e 80 00 00 	movabs $0x804e64,%rax
  806c59:	00 00 00 
  806c5c:	ff d0                	callq  *%rax
  806c5e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806c61:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806c65:	79 1b                	jns    806c82 <pipe+0x143>
		goto err3;
  806c67:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  806c68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806c6c:	48 89 c6             	mov    %rax,%rsi
  806c6f:	bf 00 00 00 00       	mov    $0x0,%edi
  806c74:	48 b8 bf 4e 80 00 00 	movabs $0x804ebf,%rax
  806c7b:	00 00 00 
  806c7e:	ff d0                	callq  *%rax
  806c80:	eb 79                	jmp    806cfb <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  806c82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806c86:	48 ba 60 21 81 00 00 	movabs $0x812160,%rdx
  806c8d:	00 00 00 
  806c90:	8b 12                	mov    (%rdx),%edx
  806c92:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  806c94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806c98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  806c9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806ca3:	48 ba 60 21 81 00 00 	movabs $0x812160,%rdx
  806caa:	00 00 00 
  806cad:	8b 12                	mov    (%rdx),%edx
  806caf:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  806cb1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806cb5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  806cbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806cc0:	48 89 c7             	mov    %rax,%rdi
  806cc3:	48 b8 e1 57 80 00 00 	movabs $0x8057e1,%rax
  806cca:	00 00 00 
  806ccd:	ff d0                	callq  *%rax
  806ccf:	89 c2                	mov    %eax,%edx
  806cd1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806cd5:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  806cd7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806cdb:	48 8d 58 04          	lea    0x4(%rax),%rbx
  806cdf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806ce3:	48 89 c7             	mov    %rax,%rdi
  806ce6:	48 b8 e1 57 80 00 00 	movabs $0x8057e1,%rax
  806ced:	00 00 00 
  806cf0:	ff d0                	callq  *%rax
  806cf2:	89 03                	mov    %eax,(%rbx)
	return 0;
  806cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  806cf9:	eb 33                	jmp    806d2e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  806cfb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806cff:	48 89 c6             	mov    %rax,%rsi
  806d02:	bf 00 00 00 00       	mov    $0x0,%edi
  806d07:	48 b8 bf 4e 80 00 00 	movabs $0x804ebf,%rax
  806d0e:	00 00 00 
  806d11:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  806d13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806d17:	48 89 c6             	mov    %rax,%rsi
  806d1a:	bf 00 00 00 00       	mov    $0x0,%edi
  806d1f:	48 b8 bf 4e 80 00 00 	movabs $0x804ebf,%rax
  806d26:	00 00 00 
  806d29:	ff d0                	callq  *%rax
err:
	return r;
  806d2b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  806d2e:	48 83 c4 38          	add    $0x38,%rsp
  806d32:	5b                   	pop    %rbx
  806d33:	5d                   	pop    %rbp
  806d34:	c3                   	retq   

0000000000806d35 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  806d35:	55                   	push   %rbp
  806d36:	48 89 e5             	mov    %rsp,%rbp
  806d39:	53                   	push   %rbx
  806d3a:	48 83 ec 28          	sub    $0x28,%rsp
  806d3e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806d42:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  806d46:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  806d4d:	00 00 00 
  806d50:	48 8b 00             	mov    (%rax),%rax
  806d53:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806d59:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  806d5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806d60:	48 89 c7             	mov    %rax,%rdi
  806d63:	48 b8 b6 6a 80 00 00 	movabs $0x806ab6,%rax
  806d6a:	00 00 00 
  806d6d:	ff d0                	callq  *%rax
  806d6f:	89 c3                	mov    %eax,%ebx
  806d71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806d75:	48 89 c7             	mov    %rax,%rdi
  806d78:	48 b8 b6 6a 80 00 00 	movabs $0x806ab6,%rax
  806d7f:	00 00 00 
  806d82:	ff d0                	callq  *%rax
  806d84:	39 c3                	cmp    %eax,%ebx
  806d86:	0f 94 c0             	sete   %al
  806d89:	0f b6 c0             	movzbl %al,%eax
  806d8c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  806d8f:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  806d96:	00 00 00 
  806d99:	48 8b 00             	mov    (%rax),%rax
  806d9c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806da2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  806da5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806da8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806dab:	75 05                	jne    806db2 <_pipeisclosed+0x7d>
			return ret;
  806dad:	8b 45 e8             	mov    -0x18(%rbp),%eax
  806db0:	eb 4f                	jmp    806e01 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  806db2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806db5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806db8:	74 42                	je     806dfc <_pipeisclosed+0xc7>
  806dba:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  806dbe:	75 3c                	jne    806dfc <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  806dc0:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  806dc7:	00 00 00 
  806dca:	48 8b 00             	mov    (%rax),%rax
  806dcd:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  806dd3:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806dd6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806dd9:	89 c6                	mov    %eax,%esi
  806ddb:	48 bf 15 82 80 00 00 	movabs $0x808215,%rdi
  806de2:	00 00 00 
  806de5:	b8 00 00 00 00       	mov    $0x0,%eax
  806dea:	49 b8 30 39 80 00 00 	movabs $0x803930,%r8
  806df1:	00 00 00 
  806df4:	41 ff d0             	callq  *%r8
	}
  806df7:	e9 4a ff ff ff       	jmpq   806d46 <_pipeisclosed+0x11>
  806dfc:	e9 45 ff ff ff       	jmpq   806d46 <_pipeisclosed+0x11>
}
  806e01:	48 83 c4 28          	add    $0x28,%rsp
  806e05:	5b                   	pop    %rbx
  806e06:	5d                   	pop    %rbp
  806e07:	c3                   	retq   

0000000000806e08 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  806e08:	55                   	push   %rbp
  806e09:	48 89 e5             	mov    %rsp,%rbp
  806e0c:	48 83 ec 30          	sub    $0x30,%rsp
  806e10:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806e13:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  806e17:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806e1a:	48 89 d6             	mov    %rdx,%rsi
  806e1d:	89 c7                	mov    %eax,%edi
  806e1f:	48 b8 c7 58 80 00 00 	movabs $0x8058c7,%rax
  806e26:	00 00 00 
  806e29:	ff d0                	callq  *%rax
  806e2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806e2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806e32:	79 05                	jns    806e39 <pipeisclosed+0x31>
		return r;
  806e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806e37:	eb 31                	jmp    806e6a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  806e39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806e3d:	48 89 c7             	mov    %rax,%rdi
  806e40:	48 b8 04 58 80 00 00 	movabs $0x805804,%rax
  806e47:	00 00 00 
  806e4a:	ff d0                	callq  *%rax
  806e4c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  806e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806e54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806e58:	48 89 d6             	mov    %rdx,%rsi
  806e5b:	48 89 c7             	mov    %rax,%rdi
  806e5e:	48 b8 35 6d 80 00 00 	movabs $0x806d35,%rax
  806e65:	00 00 00 
  806e68:	ff d0                	callq  *%rax
}
  806e6a:	c9                   	leaveq 
  806e6b:	c3                   	retq   

0000000000806e6c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  806e6c:	55                   	push   %rbp
  806e6d:	48 89 e5             	mov    %rsp,%rbp
  806e70:	48 83 ec 40          	sub    $0x40,%rsp
  806e74:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806e78:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  806e7c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  806e80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806e84:	48 89 c7             	mov    %rax,%rdi
  806e87:	48 b8 04 58 80 00 00 	movabs $0x805804,%rax
  806e8e:	00 00 00 
  806e91:	ff d0                	callq  *%rax
  806e93:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806e97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806e9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806e9f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806ea6:	00 
  806ea7:	e9 92 00 00 00       	jmpq   806f3e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  806eac:	eb 41                	jmp    806eef <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  806eae:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  806eb3:	74 09                	je     806ebe <devpipe_read+0x52>
				return i;
  806eb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806eb9:	e9 92 00 00 00       	jmpq   806f50 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  806ebe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806ec2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806ec6:	48 89 d6             	mov    %rdx,%rsi
  806ec9:	48 89 c7             	mov    %rax,%rdi
  806ecc:	48 b8 35 6d 80 00 00 	movabs $0x806d35,%rax
  806ed3:	00 00 00 
  806ed6:	ff d0                	callq  *%rax
  806ed8:	85 c0                	test   %eax,%eax
  806eda:	74 07                	je     806ee3 <devpipe_read+0x77>
				return 0;
  806edc:	b8 00 00 00 00       	mov    $0x0,%eax
  806ee1:	eb 6d                	jmp    806f50 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  806ee3:	48 b8 d6 4d 80 00 00 	movabs $0x804dd6,%rax
  806eea:	00 00 00 
  806eed:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  806eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806ef3:	8b 10                	mov    (%rax),%edx
  806ef5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806ef9:	8b 40 04             	mov    0x4(%rax),%eax
  806efc:	39 c2                	cmp    %eax,%edx
  806efe:	74 ae                	je     806eae <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  806f00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806f04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806f08:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  806f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806f10:	8b 00                	mov    (%rax),%eax
  806f12:	99                   	cltd   
  806f13:	c1 ea 1b             	shr    $0x1b,%edx
  806f16:	01 d0                	add    %edx,%eax
  806f18:	83 e0 1f             	and    $0x1f,%eax
  806f1b:	29 d0                	sub    %edx,%eax
  806f1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806f21:	48 98                	cltq   
  806f23:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  806f28:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  806f2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806f2e:	8b 00                	mov    (%rax),%eax
  806f30:	8d 50 01             	lea    0x1(%rax),%edx
  806f33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806f37:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806f39:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806f3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806f42:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806f46:	0f 82 60 ff ff ff    	jb     806eac <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  806f4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  806f50:	c9                   	leaveq 
  806f51:	c3                   	retq   

0000000000806f52 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  806f52:	55                   	push   %rbp
  806f53:	48 89 e5             	mov    %rsp,%rbp
  806f56:	48 83 ec 40          	sub    $0x40,%rsp
  806f5a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806f5e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  806f62:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  806f66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806f6a:	48 89 c7             	mov    %rax,%rdi
  806f6d:	48 b8 04 58 80 00 00 	movabs $0x805804,%rax
  806f74:	00 00 00 
  806f77:	ff d0                	callq  *%rax
  806f79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806f7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806f81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806f85:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806f8c:	00 
  806f8d:	e9 8e 00 00 00       	jmpq   807020 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806f92:	eb 31                	jmp    806fc5 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  806f94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806f98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806f9c:	48 89 d6             	mov    %rdx,%rsi
  806f9f:	48 89 c7             	mov    %rax,%rdi
  806fa2:	48 b8 35 6d 80 00 00 	movabs $0x806d35,%rax
  806fa9:	00 00 00 
  806fac:	ff d0                	callq  *%rax
  806fae:	85 c0                	test   %eax,%eax
  806fb0:	74 07                	je     806fb9 <devpipe_write+0x67>
				return 0;
  806fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  806fb7:	eb 79                	jmp    807032 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806fb9:	48 b8 d6 4d 80 00 00 	movabs $0x804dd6,%rax
  806fc0:	00 00 00 
  806fc3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806fc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806fc9:	8b 40 04             	mov    0x4(%rax),%eax
  806fcc:	48 63 d0             	movslq %eax,%rdx
  806fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806fd3:	8b 00                	mov    (%rax),%eax
  806fd5:	48 98                	cltq   
  806fd7:	48 83 c0 20          	add    $0x20,%rax
  806fdb:	48 39 c2             	cmp    %rax,%rdx
  806fde:	73 b4                	jae    806f94 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  806fe0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806fe4:	8b 40 04             	mov    0x4(%rax),%eax
  806fe7:	99                   	cltd   
  806fe8:	c1 ea 1b             	shr    $0x1b,%edx
  806feb:	01 d0                	add    %edx,%eax
  806fed:	83 e0 1f             	and    $0x1f,%eax
  806ff0:	29 d0                	sub    %edx,%eax
  806ff2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806ff6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  806ffa:	48 01 ca             	add    %rcx,%rdx
  806ffd:	0f b6 0a             	movzbl (%rdx),%ecx
  807000:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  807004:	48 98                	cltq   
  807006:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80700a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80700e:	8b 40 04             	mov    0x4(%rax),%eax
  807011:	8d 50 01             	lea    0x1(%rax),%edx
  807014:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807018:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80701b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  807020:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807024:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  807028:	0f 82 64 ff ff ff    	jb     806f92 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80702e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  807032:	c9                   	leaveq 
  807033:	c3                   	retq   

0000000000807034 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  807034:	55                   	push   %rbp
  807035:	48 89 e5             	mov    %rsp,%rbp
  807038:	48 83 ec 20          	sub    $0x20,%rsp
  80703c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  807040:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  807044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  807048:	48 89 c7             	mov    %rax,%rdi
  80704b:	48 b8 04 58 80 00 00 	movabs $0x805804,%rax
  807052:	00 00 00 
  807055:	ff d0                	callq  *%rax
  807057:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80705b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80705f:	48 be 28 82 80 00 00 	movabs $0x808228,%rsi
  807066:	00 00 00 
  807069:	48 89 c7             	mov    %rax,%rdi
  80706c:	48 b8 e5 44 80 00 00 	movabs $0x8044e5,%rax
  807073:	00 00 00 
  807076:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  807078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80707c:	8b 50 04             	mov    0x4(%rax),%edx
  80707f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807083:	8b 00                	mov    (%rax),%eax
  807085:	29 c2                	sub    %eax,%edx
  807087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80708b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  807091:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  807095:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80709c:	00 00 00 
	stat->st_dev = &devpipe;
  80709f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8070a3:	48 b9 60 21 81 00 00 	movabs $0x812160,%rcx
  8070aa:	00 00 00 
  8070ad:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8070b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8070b9:	c9                   	leaveq 
  8070ba:	c3                   	retq   

00000000008070bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8070bb:	55                   	push   %rbp
  8070bc:	48 89 e5             	mov    %rsp,%rbp
  8070bf:	48 83 ec 10          	sub    $0x10,%rsp
  8070c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8070c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8070cb:	48 89 c6             	mov    %rax,%rsi
  8070ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8070d3:	48 b8 bf 4e 80 00 00 	movabs $0x804ebf,%rax
  8070da:	00 00 00 
  8070dd:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8070df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8070e3:	48 89 c7             	mov    %rax,%rdi
  8070e6:	48 b8 04 58 80 00 00 	movabs $0x805804,%rax
  8070ed:	00 00 00 
  8070f0:	ff d0                	callq  *%rax
  8070f2:	48 89 c6             	mov    %rax,%rsi
  8070f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8070fa:	48 b8 bf 4e 80 00 00 	movabs $0x804ebf,%rax
  807101:	00 00 00 
  807104:	ff d0                	callq  *%rax
}
  807106:	c9                   	leaveq 
  807107:	c3                   	retq   

0000000000807108 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  807108:	55                   	push   %rbp
  807109:	48 89 e5             	mov    %rsp,%rbp
  80710c:	48 83 ec 20          	sub    $0x20,%rsp
  807110:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  807113:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807116:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  807119:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80711d:	be 01 00 00 00       	mov    $0x1,%esi
  807122:	48 89 c7             	mov    %rax,%rdi
  807125:	48 b8 cc 4c 80 00 00 	movabs $0x804ccc,%rax
  80712c:	00 00 00 
  80712f:	ff d0                	callq  *%rax
}
  807131:	c9                   	leaveq 
  807132:	c3                   	retq   

0000000000807133 <getchar>:

int
getchar(void)
{
  807133:	55                   	push   %rbp
  807134:	48 89 e5             	mov    %rsp,%rbp
  807137:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80713b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80713f:	ba 01 00 00 00       	mov    $0x1,%edx
  807144:	48 89 c6             	mov    %rax,%rsi
  807147:	bf 00 00 00 00       	mov    $0x0,%edi
  80714c:	48 b8 f9 5c 80 00 00 	movabs $0x805cf9,%rax
  807153:	00 00 00 
  807156:	ff d0                	callq  *%rax
  807158:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80715b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80715f:	79 05                	jns    807166 <getchar+0x33>
		return r;
  807161:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807164:	eb 14                	jmp    80717a <getchar+0x47>
	if (r < 1)
  807166:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80716a:	7f 07                	jg     807173 <getchar+0x40>
		return -E_EOF;
  80716c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  807171:	eb 07                	jmp    80717a <getchar+0x47>
	return c;
  807173:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  807177:	0f b6 c0             	movzbl %al,%eax
}
  80717a:	c9                   	leaveq 
  80717b:	c3                   	retq   

000000000080717c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80717c:	55                   	push   %rbp
  80717d:	48 89 e5             	mov    %rsp,%rbp
  807180:	48 83 ec 20          	sub    $0x20,%rsp
  807184:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  807187:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80718b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80718e:	48 89 d6             	mov    %rdx,%rsi
  807191:	89 c7                	mov    %eax,%edi
  807193:	48 b8 c7 58 80 00 00 	movabs $0x8058c7,%rax
  80719a:	00 00 00 
  80719d:	ff d0                	callq  *%rax
  80719f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8071a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8071a6:	79 05                	jns    8071ad <iscons+0x31>
		return r;
  8071a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8071ab:	eb 1a                	jmp    8071c7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8071ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8071b1:	8b 10                	mov    (%rax),%edx
  8071b3:	48 b8 a0 21 81 00 00 	movabs $0x8121a0,%rax
  8071ba:	00 00 00 
  8071bd:	8b 00                	mov    (%rax),%eax
  8071bf:	39 c2                	cmp    %eax,%edx
  8071c1:	0f 94 c0             	sete   %al
  8071c4:	0f b6 c0             	movzbl %al,%eax
}
  8071c7:	c9                   	leaveq 
  8071c8:	c3                   	retq   

00000000008071c9 <opencons>:

int
opencons(void)
{
  8071c9:	55                   	push   %rbp
  8071ca:	48 89 e5             	mov    %rsp,%rbp
  8071cd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8071d1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8071d5:	48 89 c7             	mov    %rax,%rdi
  8071d8:	48 b8 2f 58 80 00 00 	movabs $0x80582f,%rax
  8071df:	00 00 00 
  8071e2:	ff d0                	callq  *%rax
  8071e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8071e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8071eb:	79 05                	jns    8071f2 <opencons+0x29>
		return r;
  8071ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8071f0:	eb 5b                	jmp    80724d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8071f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8071f6:	ba 07 04 00 00       	mov    $0x407,%edx
  8071fb:	48 89 c6             	mov    %rax,%rsi
  8071fe:	bf 00 00 00 00       	mov    $0x0,%edi
  807203:	48 b8 14 4e 80 00 00 	movabs $0x804e14,%rax
  80720a:	00 00 00 
  80720d:	ff d0                	callq  *%rax
  80720f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807212:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807216:	79 05                	jns    80721d <opencons+0x54>
		return r;
  807218:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80721b:	eb 30                	jmp    80724d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80721d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807221:	48 ba a0 21 81 00 00 	movabs $0x8121a0,%rdx
  807228:	00 00 00 
  80722b:	8b 12                	mov    (%rdx),%edx
  80722d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80722f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807233:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80723a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80723e:	48 89 c7             	mov    %rax,%rdi
  807241:	48 b8 e1 57 80 00 00 	movabs $0x8057e1,%rax
  807248:	00 00 00 
  80724b:	ff d0                	callq  *%rax
}
  80724d:	c9                   	leaveq 
  80724e:	c3                   	retq   

000000000080724f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80724f:	55                   	push   %rbp
  807250:	48 89 e5             	mov    %rsp,%rbp
  807253:	48 83 ec 30          	sub    $0x30,%rsp
  807257:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80725b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80725f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  807263:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  807268:	75 07                	jne    807271 <devcons_read+0x22>
		return 0;
  80726a:	b8 00 00 00 00       	mov    $0x0,%eax
  80726f:	eb 4b                	jmp    8072bc <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  807271:	eb 0c                	jmp    80727f <devcons_read+0x30>
		sys_yield();
  807273:	48 b8 d6 4d 80 00 00 	movabs $0x804dd6,%rax
  80727a:	00 00 00 
  80727d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80727f:	48 b8 16 4d 80 00 00 	movabs $0x804d16,%rax
  807286:	00 00 00 
  807289:	ff d0                	callq  *%rax
  80728b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80728e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807292:	74 df                	je     807273 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  807294:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807298:	79 05                	jns    80729f <devcons_read+0x50>
		return c;
  80729a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80729d:	eb 1d                	jmp    8072bc <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80729f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8072a3:	75 07                	jne    8072ac <devcons_read+0x5d>
		return 0;
  8072a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8072aa:	eb 10                	jmp    8072bc <devcons_read+0x6d>
	*(char*)vbuf = c;
  8072ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8072af:	89 c2                	mov    %eax,%edx
  8072b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8072b5:	88 10                	mov    %dl,(%rax)
	return 1;
  8072b7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8072bc:	c9                   	leaveq 
  8072bd:	c3                   	retq   

00000000008072be <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8072be:	55                   	push   %rbp
  8072bf:	48 89 e5             	mov    %rsp,%rbp
  8072c2:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8072c9:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8072d0:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8072d7:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8072de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8072e5:	eb 76                	jmp    80735d <devcons_write+0x9f>
		m = n - tot;
  8072e7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8072ee:	89 c2                	mov    %eax,%edx
  8072f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8072f3:	29 c2                	sub    %eax,%edx
  8072f5:	89 d0                	mov    %edx,%eax
  8072f7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8072fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8072fd:	83 f8 7f             	cmp    $0x7f,%eax
  807300:	76 07                	jbe    807309 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  807302:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  807309:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80730c:	48 63 d0             	movslq %eax,%rdx
  80730f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807312:	48 63 c8             	movslq %eax,%rcx
  807315:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80731c:	48 01 c1             	add    %rax,%rcx
  80731f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  807326:	48 89 ce             	mov    %rcx,%rsi
  807329:	48 89 c7             	mov    %rax,%rdi
  80732c:	48 b8 09 48 80 00 00 	movabs $0x804809,%rax
  807333:	00 00 00 
  807336:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  807338:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80733b:	48 63 d0             	movslq %eax,%rdx
  80733e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  807345:	48 89 d6             	mov    %rdx,%rsi
  807348:	48 89 c7             	mov    %rax,%rdi
  80734b:	48 b8 cc 4c 80 00 00 	movabs $0x804ccc,%rax
  807352:	00 00 00 
  807355:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  807357:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80735a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80735d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807360:	48 98                	cltq   
  807362:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  807369:	0f 82 78 ff ff ff    	jb     8072e7 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80736f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  807372:	c9                   	leaveq 
  807373:	c3                   	retq   

0000000000807374 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  807374:	55                   	push   %rbp
  807375:	48 89 e5             	mov    %rsp,%rbp
  807378:	48 83 ec 08          	sub    $0x8,%rsp
  80737c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  807380:	b8 00 00 00 00       	mov    $0x0,%eax
}
  807385:	c9                   	leaveq 
  807386:	c3                   	retq   

0000000000807387 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  807387:	55                   	push   %rbp
  807388:	48 89 e5             	mov    %rsp,%rbp
  80738b:	48 83 ec 10          	sub    $0x10,%rsp
  80738f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  807393:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  807397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80739b:	48 be 34 82 80 00 00 	movabs $0x808234,%rsi
  8073a2:	00 00 00 
  8073a5:	48 89 c7             	mov    %rax,%rdi
  8073a8:	48 b8 e5 44 80 00 00 	movabs $0x8044e5,%rax
  8073af:	00 00 00 
  8073b2:	ff d0                	callq  *%rax
	return 0;
  8073b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8073b9:	c9                   	leaveq 
  8073ba:	c3                   	retq   
