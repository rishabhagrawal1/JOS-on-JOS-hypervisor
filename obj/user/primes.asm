
obj/user/primes:     file format elf64-x86-64


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
  80003c:	e8 8d 01 00 00       	callq  8001ce <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
	int i, id, p;
	envid_t envid;
	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80004f:	ba 00 00 00 00       	mov    $0x0,%edx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
  800059:	48 89 c7             	mov    %rax,%rdi
  80005c:	48 b8 71 24 80 00 00 	movabs $0x802471,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d", thisenv->env_cpunum, p);
  80006b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800072:	00 00 00 
  800075:	48 8b 00             	mov    (%rax),%rax
  800078:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  80007e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf 80 40 80 00 00 	movabs $0x804080,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 c8 21 80 00 00 	movabs $0x8021c8,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba 8b 40 80 00 00 	movabs $0x80408b,%rdx
  8000bf:	00 00 00 
  8000c2:	be 19 00 00 00       	mov    $0x19,%esi
  8000c7:	48 bf 94 40 80 00 00 	movabs $0x804094,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8000dd:	00 00 00 
  8000e0:	41 ff d0             	callq  *%r8
	if (id == 0)
  8000e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e7:	75 05                	jne    8000ee <primeproc+0xab>
		goto top;
  8000e9:	e9 5d ff ff ff       	jmpq   80004b <primeproc+0x8>

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f7:	be 00 00 00 00       	mov    $0x0,%esi
  8000fc:	48 89 c7             	mov    %rax,%rdi
  8000ff:	48 b8 71 24 80 00 00 	movabs $0x802471,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax
  80010b:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (i % p)
  80010e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d fc             	idivl  -0x4(%rbp)
  800115:	89 d0                	mov    %edx,%eax
  800117:	85 c0                	test   %eax,%eax
  800119:	74 20                	je     80013b <primeproc+0xf8>
			ipc_send(id, i, 0, 0);
  80011b:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80011e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800121:	b9 00 00 00 00       	mov    $0x0,%ecx
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	89 c7                	mov    %eax,%edi
  80012d:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	}
  800139:	eb b3                	jmp    8000ee <primeproc+0xab>
  80013b:	eb b1                	jmp    8000ee <primeproc+0xab>

000000000080013d <umain>:
}

void
umain(int argc, char **argv)
{
  80013d:	55                   	push   %rbp
  80013e:	48 89 e5             	mov    %rsp,%rbp
  800141:	48 83 ec 20          	sub    $0x20,%rsp
  800145:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800148:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  80014c:	48 b8 c8 21 80 00 00 	movabs $0x8021c8,%rax
  800153:	00 00 00 
  800156:	ff d0                	callq  *%rax
  800158:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80015b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015f:	79 30                	jns    800191 <umain+0x54>
		panic("fork: %e", id);
  800161:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800164:	89 c1                	mov    %eax,%ecx
  800166:	48 ba 8b 40 80 00 00 	movabs $0x80408b,%rdx
  80016d:	00 00 00 
  800170:	be 2c 00 00 00       	mov    $0x2c,%esi
  800175:	48 bf 94 40 80 00 00 	movabs $0x804094,%rdi
  80017c:	00 00 00 
  80017f:	b8 00 00 00 00       	mov    $0x0,%eax
  800184:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  80018b:	00 00 00 
  80018e:	41 ff d0             	callq  *%r8
	if (id == 0)
  800191:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800195:	75 0c                	jne    8001a3 <umain+0x66>
		primeproc();
  800197:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i = 2; ; i++)
  8001a3:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001aa:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8001c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001cc:	eb dc                	jmp    8001aa <umain+0x6d>

00000000008001ce <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ce:	55                   	push   %rbp
  8001cf:	48 89 e5             	mov    %rsp,%rbp
  8001d2:	48 83 ec 10          	sub    $0x10,%rsp
  8001d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001dd:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ee:	48 98                	cltq   
  8001f0:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001f7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001fe:	00 00 00 
  800201:	48 01 c2             	add    %rax,%rdx
  800204:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80020b:	00 00 00 
  80020e:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800211:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800215:	7e 14                	jle    80022b <libmain+0x5d>
		binaryname = argv[0];
  800217:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021b:	48 8b 10             	mov    (%rax),%rdx
  80021e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800225:	00 00 00 
  800228:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80022b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80022f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800232:	48 89 d6             	mov    %rdx,%rsi
  800235:	89 c7                	mov    %eax,%edi
  800237:	48 b8 3d 01 80 00 00 	movabs $0x80013d,%rax
  80023e:	00 00 00 
  800241:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800243:	48 b8 51 02 80 00 00 	movabs $0x800251,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
}
  80024f:	c9                   	leaveq 
  800250:	c3                   	retq   

0000000000800251 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800251:	55                   	push   %rbp
  800252:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800255:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800261:	bf 00 00 00 00       	mov    $0x0,%edi
  800266:	48 b8 d1 18 80 00 00 	movabs $0x8018d1,%rax
  80026d:	00 00 00 
  800270:	ff d0                	callq  *%rax

}
  800272:	5d                   	pop    %rbp
  800273:	c3                   	retq   

0000000000800274 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800274:	55                   	push   %rbp
  800275:	48 89 e5             	mov    %rsp,%rbp
  800278:	53                   	push   %rbx
  800279:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800280:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800287:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80028d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800294:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80029b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002a2:	84 c0                	test   %al,%al
  8002a4:	74 23                	je     8002c9 <_panic+0x55>
  8002a6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002ad:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002b1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002b5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002b9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002bd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002c1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002c5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002c9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002d0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002d7:	00 00 00 
  8002da:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002e1:	00 00 00 
  8002e4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ef:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002f6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002fd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800304:	00 00 00 
  800307:	48 8b 18             	mov    (%rax),%rbx
  80030a:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  800311:	00 00 00 
  800314:	ff d0                	callq  *%rax
  800316:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80031c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800323:	41 89 c8             	mov    %ecx,%r8d
  800326:	48 89 d1             	mov    %rdx,%rcx
  800329:	48 89 da             	mov    %rbx,%rdx
  80032c:	89 c6                	mov    %eax,%esi
  80032e:	48 bf b0 40 80 00 00 	movabs $0x8040b0,%rdi
  800335:	00 00 00 
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
  80033d:	49 b9 ad 04 80 00 00 	movabs $0x8004ad,%r9
  800344:	00 00 00 
  800347:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80034a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800351:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800358:	48 89 d6             	mov    %rdx,%rsi
  80035b:	48 89 c7             	mov    %rax,%rdi
  80035e:	48 b8 01 04 80 00 00 	movabs $0x800401,%rax
  800365:	00 00 00 
  800368:	ff d0                	callq  *%rax
	cprintf("\n");
  80036a:	48 bf d3 40 80 00 00 	movabs $0x8040d3,%rdi
  800371:	00 00 00 
  800374:	b8 00 00 00 00       	mov    $0x0,%eax
  800379:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  800380:	00 00 00 
  800383:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800385:	cc                   	int3   
  800386:	eb fd                	jmp    800385 <_panic+0x111>

0000000000800388 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800388:	55                   	push   %rbp
  800389:	48 89 e5             	mov    %rsp,%rbp
  80038c:	48 83 ec 10          	sub    $0x10,%rsp
  800390:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800393:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039b:	8b 00                	mov    (%rax),%eax
  80039d:	8d 48 01             	lea    0x1(%rax),%ecx
  8003a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a4:	89 0a                	mov    %ecx,(%rdx)
  8003a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003a9:	89 d1                	mov    %edx,%ecx
  8003ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003af:	48 98                	cltq   
  8003b1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b9:	8b 00                	mov    (%rax),%eax
  8003bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c0:	75 2c                	jne    8003ee <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c6:	8b 00                	mov    (%rax),%eax
  8003c8:	48 98                	cltq   
  8003ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ce:	48 83 c2 08          	add    $0x8,%rdx
  8003d2:	48 89 c6             	mov    %rax,%rsi
  8003d5:	48 89 d7             	mov    %rdx,%rdi
  8003d8:	48 b8 49 18 80 00 00 	movabs $0x801849,%rax
  8003df:	00 00 00 
  8003e2:	ff d0                	callq  *%rax
        b->idx = 0;
  8003e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f2:	8b 40 04             	mov    0x4(%rax),%eax
  8003f5:	8d 50 01             	lea    0x1(%rax),%edx
  8003f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fc:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003ff:	c9                   	leaveq 
  800400:	c3                   	retq   

0000000000800401 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800401:	55                   	push   %rbp
  800402:	48 89 e5             	mov    %rsp,%rbp
  800405:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80040c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800413:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80041a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800421:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800428:	48 8b 0a             	mov    (%rdx),%rcx
  80042b:	48 89 08             	mov    %rcx,(%rax)
  80042e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800432:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800436:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80043a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80043e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800445:	00 00 00 
    b.cnt = 0;
  800448:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80044f:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800452:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800459:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800460:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800467:	48 89 c6             	mov    %rax,%rsi
  80046a:	48 bf 88 03 80 00 00 	movabs $0x800388,%rdi
  800471:	00 00 00 
  800474:	48 b8 60 08 80 00 00 	movabs $0x800860,%rax
  80047b:	00 00 00 
  80047e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800480:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800486:	48 98                	cltq   
  800488:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80048f:	48 83 c2 08          	add    $0x8,%rdx
  800493:	48 89 c6             	mov    %rax,%rsi
  800496:	48 89 d7             	mov    %rdx,%rdi
  800499:	48 b8 49 18 80 00 00 	movabs $0x801849,%rax
  8004a0:	00 00 00 
  8004a3:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004ab:	c9                   	leaveq 
  8004ac:	c3                   	retq   

00000000008004ad <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004ad:	55                   	push   %rbp
  8004ae:	48 89 e5             	mov    %rsp,%rbp
  8004b1:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004b8:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004bf:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004c6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004cd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004d4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004db:	84 c0                	test   %al,%al
  8004dd:	74 20                	je     8004ff <cprintf+0x52>
  8004df:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004e3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004e7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004eb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004ef:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004f3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004f7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004fb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004ff:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800506:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80050d:	00 00 00 
  800510:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800517:	00 00 00 
  80051a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80051e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800525:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80052c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800533:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80053a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800541:	48 8b 0a             	mov    (%rdx),%rcx
  800544:	48 89 08             	mov    %rcx,(%rax)
  800547:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80054b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80054f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800553:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800557:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80055e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800565:	48 89 d6             	mov    %rdx,%rsi
  800568:	48 89 c7             	mov    %rax,%rdi
  80056b:	48 b8 01 04 80 00 00 	movabs $0x800401,%rax
  800572:	00 00 00 
  800575:	ff d0                	callq  *%rax
  800577:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80057d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800583:	c9                   	leaveq 
  800584:	c3                   	retq   

0000000000800585 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800585:	55                   	push   %rbp
  800586:	48 89 e5             	mov    %rsp,%rbp
  800589:	53                   	push   %rbx
  80058a:	48 83 ec 38          	sub    $0x38,%rsp
  80058e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800592:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800596:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80059a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80059d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005a1:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005a8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005ac:	77 3b                	ja     8005e9 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ae:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005b1:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005b5:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c1:	48 f7 f3             	div    %rbx
  8005c4:	48 89 c2             	mov    %rax,%rdx
  8005c7:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005ca:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005cd:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d5:	41 89 f9             	mov    %edi,%r9d
  8005d8:	48 89 c7             	mov    %rax,%rdi
  8005db:	48 b8 85 05 80 00 00 	movabs $0x800585,%rax
  8005e2:	00 00 00 
  8005e5:	ff d0                	callq  *%rax
  8005e7:	eb 1e                	jmp    800607 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e9:	eb 12                	jmp    8005fd <printnum+0x78>
			putch(padc, putdat);
  8005eb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005ef:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f6:	48 89 ce             	mov    %rcx,%rsi
  8005f9:	89 d7                	mov    %edx,%edi
  8005fb:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fd:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800601:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800605:	7f e4                	jg     8005eb <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800607:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80060a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80060e:	ba 00 00 00 00       	mov    $0x0,%edx
  800613:	48 f7 f1             	div    %rcx
  800616:	48 89 d0             	mov    %rdx,%rax
  800619:	48 ba d0 42 80 00 00 	movabs $0x8042d0,%rdx
  800620:	00 00 00 
  800623:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800627:	0f be d0             	movsbl %al,%edx
  80062a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80062e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800632:	48 89 ce             	mov    %rcx,%rsi
  800635:	89 d7                	mov    %edx,%edi
  800637:	ff d0                	callq  *%rax
}
  800639:	48 83 c4 38          	add    $0x38,%rsp
  80063d:	5b                   	pop    %rbx
  80063e:	5d                   	pop    %rbp
  80063f:	c3                   	retq   

0000000000800640 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800640:	55                   	push   %rbp
  800641:	48 89 e5             	mov    %rsp,%rbp
  800644:	48 83 ec 1c          	sub    $0x1c,%rsp
  800648:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80064c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80064f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800653:	7e 52                	jle    8006a7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	8b 00                	mov    (%rax),%eax
  80065b:	83 f8 30             	cmp    $0x30,%eax
  80065e:	73 24                	jae    800684 <getuint+0x44>
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066c:	8b 00                	mov    (%rax),%eax
  80066e:	89 c0                	mov    %eax,%eax
  800670:	48 01 d0             	add    %rdx,%rax
  800673:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800677:	8b 12                	mov    (%rdx),%edx
  800679:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80067c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800680:	89 0a                	mov    %ecx,(%rdx)
  800682:	eb 17                	jmp    80069b <getuint+0x5b>
  800684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800688:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80068c:	48 89 d0             	mov    %rdx,%rax
  80068f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800697:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069b:	48 8b 00             	mov    (%rax),%rax
  80069e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006a2:	e9 a3 00 00 00       	jmpq   80074a <getuint+0x10a>
	else if (lflag)
  8006a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006ab:	74 4f                	je     8006fc <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b1:	8b 00                	mov    (%rax),%eax
  8006b3:	83 f8 30             	cmp    $0x30,%eax
  8006b6:	73 24                	jae    8006dc <getuint+0x9c>
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c4:	8b 00                	mov    (%rax),%eax
  8006c6:	89 c0                	mov    %eax,%eax
  8006c8:	48 01 d0             	add    %rdx,%rax
  8006cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cf:	8b 12                	mov    (%rdx),%edx
  8006d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d8:	89 0a                	mov    %ecx,(%rdx)
  8006da:	eb 17                	jmp    8006f3 <getuint+0xb3>
  8006dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006e4:	48 89 d0             	mov    %rdx,%rax
  8006e7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f3:	48 8b 00             	mov    (%rax),%rax
  8006f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006fa:	eb 4e                	jmp    80074a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	8b 00                	mov    (%rax),%eax
  800702:	83 f8 30             	cmp    $0x30,%eax
  800705:	73 24                	jae    80072b <getuint+0xeb>
  800707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80070f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800713:	8b 00                	mov    (%rax),%eax
  800715:	89 c0                	mov    %eax,%eax
  800717:	48 01 d0             	add    %rdx,%rax
  80071a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071e:	8b 12                	mov    (%rdx),%edx
  800720:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800723:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800727:	89 0a                	mov    %ecx,(%rdx)
  800729:	eb 17                	jmp    800742 <getuint+0x102>
  80072b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800733:	48 89 d0             	mov    %rdx,%rax
  800736:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80073a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800742:	8b 00                	mov    (%rax),%eax
  800744:	89 c0                	mov    %eax,%eax
  800746:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80074a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80074e:	c9                   	leaveq 
  80074f:	c3                   	retq   

0000000000800750 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800750:	55                   	push   %rbp
  800751:	48 89 e5             	mov    %rsp,%rbp
  800754:	48 83 ec 1c          	sub    $0x1c,%rsp
  800758:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80075f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800763:	7e 52                	jle    8007b7 <getint+0x67>
		x=va_arg(*ap, long long);
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	8b 00                	mov    (%rax),%eax
  80076b:	83 f8 30             	cmp    $0x30,%eax
  80076e:	73 24                	jae    800794 <getint+0x44>
  800770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800774:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077c:	8b 00                	mov    (%rax),%eax
  80077e:	89 c0                	mov    %eax,%eax
  800780:	48 01 d0             	add    %rdx,%rax
  800783:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800787:	8b 12                	mov    (%rdx),%edx
  800789:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80078c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800790:	89 0a                	mov    %ecx,(%rdx)
  800792:	eb 17                	jmp    8007ab <getint+0x5b>
  800794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800798:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80079c:	48 89 d0             	mov    %rdx,%rax
  80079f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ab:	48 8b 00             	mov    (%rax),%rax
  8007ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b2:	e9 a3 00 00 00       	jmpq   80085a <getint+0x10a>
	else if (lflag)
  8007b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007bb:	74 4f                	je     80080c <getint+0xbc>
		x=va_arg(*ap, long);
  8007bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c1:	8b 00                	mov    (%rax),%eax
  8007c3:	83 f8 30             	cmp    $0x30,%eax
  8007c6:	73 24                	jae    8007ec <getint+0x9c>
  8007c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d4:	8b 00                	mov    (%rax),%eax
  8007d6:	89 c0                	mov    %eax,%eax
  8007d8:	48 01 d0             	add    %rdx,%rax
  8007db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007df:	8b 12                	mov    (%rdx),%edx
  8007e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e8:	89 0a                	mov    %ecx,(%rdx)
  8007ea:	eb 17                	jmp    800803 <getint+0xb3>
  8007ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f4:	48 89 d0             	mov    %rdx,%rax
  8007f7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800803:	48 8b 00             	mov    (%rax),%rax
  800806:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080a:	eb 4e                	jmp    80085a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	8b 00                	mov    (%rax),%eax
  800812:	83 f8 30             	cmp    $0x30,%eax
  800815:	73 24                	jae    80083b <getint+0xeb>
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80081f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800823:	8b 00                	mov    (%rax),%eax
  800825:	89 c0                	mov    %eax,%eax
  800827:	48 01 d0             	add    %rdx,%rax
  80082a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082e:	8b 12                	mov    (%rdx),%edx
  800830:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800833:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800837:	89 0a                	mov    %ecx,(%rdx)
  800839:	eb 17                	jmp    800852 <getint+0x102>
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800843:	48 89 d0             	mov    %rdx,%rax
  800846:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800852:	8b 00                	mov    (%rax),%eax
  800854:	48 98                	cltq   
  800856:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80085a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80085e:	c9                   	leaveq 
  80085f:	c3                   	retq   

0000000000800860 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800860:	55                   	push   %rbp
  800861:	48 89 e5             	mov    %rsp,%rbp
  800864:	41 54                	push   %r12
  800866:	53                   	push   %rbx
  800867:	48 83 ec 60          	sub    $0x60,%rsp
  80086b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80086f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800873:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800877:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80087b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80087f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800883:	48 8b 0a             	mov    (%rdx),%rcx
  800886:	48 89 08             	mov    %rcx,(%rax)
  800889:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80088d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800891:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800895:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800899:	eb 17                	jmp    8008b2 <vprintfmt+0x52>
			if (ch == '\0')
  80089b:	85 db                	test   %ebx,%ebx
  80089d:	0f 84 cc 04 00 00    	je     800d6f <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8008a3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008a7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ab:	48 89 d6             	mov    %rdx,%rsi
  8008ae:	89 df                	mov    %ebx,%edi
  8008b0:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008b6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008ba:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008be:	0f b6 00             	movzbl (%rax),%eax
  8008c1:	0f b6 d8             	movzbl %al,%ebx
  8008c4:	83 fb 25             	cmp    $0x25,%ebx
  8008c7:	75 d2                	jne    80089b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c9:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008cd:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008d4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008e2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008f1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f5:	0f b6 00             	movzbl (%rax),%eax
  8008f8:	0f b6 d8             	movzbl %al,%ebx
  8008fb:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008fe:	83 f8 55             	cmp    $0x55,%eax
  800901:	0f 87 34 04 00 00    	ja     800d3b <vprintfmt+0x4db>
  800907:	89 c0                	mov    %eax,%eax
  800909:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800910:	00 
  800911:	48 b8 f8 42 80 00 00 	movabs $0x8042f8,%rax
  800918:	00 00 00 
  80091b:	48 01 d0             	add    %rdx,%rax
  80091e:	48 8b 00             	mov    (%rax),%rax
  800921:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800923:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800927:	eb c0                	jmp    8008e9 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800929:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80092d:	eb ba                	jmp    8008e9 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800936:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800939:	89 d0                	mov    %edx,%eax
  80093b:	c1 e0 02             	shl    $0x2,%eax
  80093e:	01 d0                	add    %edx,%eax
  800940:	01 c0                	add    %eax,%eax
  800942:	01 d8                	add    %ebx,%eax
  800944:	83 e8 30             	sub    $0x30,%eax
  800947:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80094a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80094e:	0f b6 00             	movzbl (%rax),%eax
  800951:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800954:	83 fb 2f             	cmp    $0x2f,%ebx
  800957:	7e 0c                	jle    800965 <vprintfmt+0x105>
  800959:	83 fb 39             	cmp    $0x39,%ebx
  80095c:	7f 07                	jg     800965 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80095e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800963:	eb d1                	jmp    800936 <vprintfmt+0xd6>
			goto process_precision;
  800965:	eb 58                	jmp    8009bf <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800967:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096a:	83 f8 30             	cmp    $0x30,%eax
  80096d:	73 17                	jae    800986 <vprintfmt+0x126>
  80096f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800973:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800976:	89 c0                	mov    %eax,%eax
  800978:	48 01 d0             	add    %rdx,%rax
  80097b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80097e:	83 c2 08             	add    $0x8,%edx
  800981:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800984:	eb 0f                	jmp    800995 <vprintfmt+0x135>
  800986:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098a:	48 89 d0             	mov    %rdx,%rax
  80098d:	48 83 c2 08          	add    $0x8,%rdx
  800991:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800995:	8b 00                	mov    (%rax),%eax
  800997:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80099a:	eb 23                	jmp    8009bf <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80099c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a0:	79 0c                	jns    8009ae <vprintfmt+0x14e>
				width = 0;
  8009a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009a9:	e9 3b ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>
  8009ae:	e9 36 ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009b3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009ba:	e9 2a ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c3:	79 12                	jns    8009d7 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009c5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009c8:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009cb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009d2:	e9 12 ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>
  8009d7:	e9 0d ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009dc:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009e0:	e9 04 ff ff ff       	jmpq   8008e9 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e8:	83 f8 30             	cmp    $0x30,%eax
  8009eb:	73 17                	jae    800a04 <vprintfmt+0x1a4>
  8009ed:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f4:	89 c0                	mov    %eax,%eax
  8009f6:	48 01 d0             	add    %rdx,%rax
  8009f9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009fc:	83 c2 08             	add    $0x8,%edx
  8009ff:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a02:	eb 0f                	jmp    800a13 <vprintfmt+0x1b3>
  800a04:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a08:	48 89 d0             	mov    %rdx,%rax
  800a0b:	48 83 c2 08          	add    $0x8,%rdx
  800a0f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a13:	8b 10                	mov    (%rax),%edx
  800a15:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1d:	48 89 ce             	mov    %rcx,%rsi
  800a20:	89 d7                	mov    %edx,%edi
  800a22:	ff d0                	callq  *%rax
			break;
  800a24:	e9 40 03 00 00       	jmpq   800d69 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2c:	83 f8 30             	cmp    $0x30,%eax
  800a2f:	73 17                	jae    800a48 <vprintfmt+0x1e8>
  800a31:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a38:	89 c0                	mov    %eax,%eax
  800a3a:	48 01 d0             	add    %rdx,%rax
  800a3d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a40:	83 c2 08             	add    $0x8,%edx
  800a43:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a46:	eb 0f                	jmp    800a57 <vprintfmt+0x1f7>
  800a48:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a4c:	48 89 d0             	mov    %rdx,%rax
  800a4f:	48 83 c2 08          	add    $0x8,%rdx
  800a53:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a57:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a59:	85 db                	test   %ebx,%ebx
  800a5b:	79 02                	jns    800a5f <vprintfmt+0x1ff>
				err = -err;
  800a5d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a5f:	83 fb 15             	cmp    $0x15,%ebx
  800a62:	7f 16                	jg     800a7a <vprintfmt+0x21a>
  800a64:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  800a6b:	00 00 00 
  800a6e:	48 63 d3             	movslq %ebx,%rdx
  800a71:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a75:	4d 85 e4             	test   %r12,%r12
  800a78:	75 2e                	jne    800aa8 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a7a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a82:	89 d9                	mov    %ebx,%ecx
  800a84:	48 ba e1 42 80 00 00 	movabs $0x8042e1,%rdx
  800a8b:	00 00 00 
  800a8e:	48 89 c7             	mov    %rax,%rdi
  800a91:	b8 00 00 00 00       	mov    $0x0,%eax
  800a96:	49 b8 78 0d 80 00 00 	movabs $0x800d78,%r8
  800a9d:	00 00 00 
  800aa0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa3:	e9 c1 02 00 00       	jmpq   800d69 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab0:	4c 89 e1             	mov    %r12,%rcx
  800ab3:	48 ba ea 42 80 00 00 	movabs $0x8042ea,%rdx
  800aba:	00 00 00 
  800abd:	48 89 c7             	mov    %rax,%rdi
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac5:	49 b8 78 0d 80 00 00 	movabs $0x800d78,%r8
  800acc:	00 00 00 
  800acf:	41 ff d0             	callq  *%r8
			break;
  800ad2:	e9 92 02 00 00       	jmpq   800d69 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ad7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ada:	83 f8 30             	cmp    $0x30,%eax
  800add:	73 17                	jae    800af6 <vprintfmt+0x296>
  800adf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae6:	89 c0                	mov    %eax,%eax
  800ae8:	48 01 d0             	add    %rdx,%rax
  800aeb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aee:	83 c2 08             	add    $0x8,%edx
  800af1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af4:	eb 0f                	jmp    800b05 <vprintfmt+0x2a5>
  800af6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800afa:	48 89 d0             	mov    %rdx,%rax
  800afd:	48 83 c2 08          	add    $0x8,%rdx
  800b01:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b05:	4c 8b 20             	mov    (%rax),%r12
  800b08:	4d 85 e4             	test   %r12,%r12
  800b0b:	75 0a                	jne    800b17 <vprintfmt+0x2b7>
				p = "(null)";
  800b0d:	49 bc ed 42 80 00 00 	movabs $0x8042ed,%r12
  800b14:	00 00 00 
			if (width > 0 && padc != '-')
  800b17:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1b:	7e 3f                	jle    800b5c <vprintfmt+0x2fc>
  800b1d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b21:	74 39                	je     800b5c <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b23:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b26:	48 98                	cltq   
  800b28:	48 89 c6             	mov    %rax,%rsi
  800b2b:	4c 89 e7             	mov    %r12,%rdi
  800b2e:	48 b8 24 10 80 00 00 	movabs $0x801024,%rax
  800b35:	00 00 00 
  800b38:	ff d0                	callq  *%rax
  800b3a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b3d:	eb 17                	jmp    800b56 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b3f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b43:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4b:	48 89 ce             	mov    %rcx,%rsi
  800b4e:	89 d7                	mov    %edx,%edi
  800b50:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b52:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b56:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5a:	7f e3                	jg     800b3f <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5c:	eb 37                	jmp    800b95 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b62:	74 1e                	je     800b82 <vprintfmt+0x322>
  800b64:	83 fb 1f             	cmp    $0x1f,%ebx
  800b67:	7e 05                	jle    800b6e <vprintfmt+0x30e>
  800b69:	83 fb 7e             	cmp    $0x7e,%ebx
  800b6c:	7e 14                	jle    800b82 <vprintfmt+0x322>
					putch('?', putdat);
  800b6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b76:	48 89 d6             	mov    %rdx,%rsi
  800b79:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b7e:	ff d0                	callq  *%rax
  800b80:	eb 0f                	jmp    800b91 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b82:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8a:	48 89 d6             	mov    %rdx,%rsi
  800b8d:	89 df                	mov    %ebx,%edi
  800b8f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b91:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b95:	4c 89 e0             	mov    %r12,%rax
  800b98:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b9c:	0f b6 00             	movzbl (%rax),%eax
  800b9f:	0f be d8             	movsbl %al,%ebx
  800ba2:	85 db                	test   %ebx,%ebx
  800ba4:	74 10                	je     800bb6 <vprintfmt+0x356>
  800ba6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800baa:	78 b2                	js     800b5e <vprintfmt+0x2fe>
  800bac:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bb0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb4:	79 a8                	jns    800b5e <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 16                	jmp    800bce <vprintfmt+0x36e>
				putch(' ', putdat);
  800bb8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bbc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc0:	48 89 d6             	mov    %rdx,%rsi
  800bc3:	bf 20 00 00 00       	mov    $0x20,%edi
  800bc8:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bca:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd2:	7f e4                	jg     800bb8 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bd4:	e9 90 01 00 00       	jmpq   800d69 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bd9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bdd:	be 03 00 00 00       	mov    $0x3,%esi
  800be2:	48 89 c7             	mov    %rax,%rdi
  800be5:	48 b8 50 07 80 00 00 	movabs $0x800750,%rax
  800bec:	00 00 00 
  800bef:	ff d0                	callq  *%rax
  800bf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf9:	48 85 c0             	test   %rax,%rax
  800bfc:	79 1d                	jns    800c1b <vprintfmt+0x3bb>
				putch('-', putdat);
  800bfe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c06:	48 89 d6             	mov    %rdx,%rsi
  800c09:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c0e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c14:	48 f7 d8             	neg    %rax
  800c17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c1b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c22:	e9 d5 00 00 00       	jmpq   800cfc <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c27:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c2b:	be 03 00 00 00       	mov    $0x3,%esi
  800c30:	48 89 c7             	mov    %rax,%rdi
  800c33:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  800c3a:	00 00 00 
  800c3d:	ff d0                	callq  *%rax
  800c3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c43:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c4a:	e9 ad 00 00 00       	jmpq   800cfc <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800c4f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800c52:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c56:	89 d6                	mov    %edx,%esi
  800c58:	48 89 c7             	mov    %rax,%rdi
  800c5b:	48 b8 50 07 80 00 00 	movabs $0x800750,%rax
  800c62:	00 00 00 
  800c65:	ff d0                	callq  *%rax
  800c67:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c6b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c72:	e9 85 00 00 00       	jmpq   800cfc <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800c77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7f:	48 89 d6             	mov    %rdx,%rsi
  800c82:	bf 30 00 00 00       	mov    $0x30,%edi
  800c87:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c91:	48 89 d6             	mov    %rdx,%rsi
  800c94:	bf 78 00 00 00       	mov    $0x78,%edi
  800c99:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9e:	83 f8 30             	cmp    $0x30,%eax
  800ca1:	73 17                	jae    800cba <vprintfmt+0x45a>
  800ca3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800caa:	89 c0                	mov    %eax,%eax
  800cac:	48 01 d0             	add    %rdx,%rax
  800caf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb2:	83 c2 08             	add    $0x8,%edx
  800cb5:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb8:	eb 0f                	jmp    800cc9 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800cba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cbe:	48 89 d0             	mov    %rdx,%rax
  800cc1:	48 83 c2 08          	add    $0x8,%rdx
  800cc5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc9:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ccc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cd0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cd7:	eb 23                	jmp    800cfc <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cd9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cdd:	be 03 00 00 00       	mov    $0x3,%esi
  800ce2:	48 89 c7             	mov    %rax,%rdi
  800ce5:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  800cec:	00 00 00 
  800cef:	ff d0                	callq  *%rax
  800cf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cf5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cfc:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d01:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d04:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d13:	45 89 c1             	mov    %r8d,%r9d
  800d16:	41 89 f8             	mov    %edi,%r8d
  800d19:	48 89 c7             	mov    %rax,%rdi
  800d1c:	48 b8 85 05 80 00 00 	movabs $0x800585,%rax
  800d23:	00 00 00 
  800d26:	ff d0                	callq  *%rax
			break;
  800d28:	eb 3f                	jmp    800d69 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d32:	48 89 d6             	mov    %rdx,%rsi
  800d35:	89 df                	mov    %ebx,%edi
  800d37:	ff d0                	callq  *%rax
			break;
  800d39:	eb 2e                	jmp    800d69 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d43:	48 89 d6             	mov    %rdx,%rsi
  800d46:	bf 25 00 00 00       	mov    $0x25,%edi
  800d4b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d4d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d52:	eb 05                	jmp    800d59 <vprintfmt+0x4f9>
  800d54:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d59:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d5d:	48 83 e8 01          	sub    $0x1,%rax
  800d61:	0f b6 00             	movzbl (%rax),%eax
  800d64:	3c 25                	cmp    $0x25,%al
  800d66:	75 ec                	jne    800d54 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d68:	90                   	nop
		}
	}
  800d69:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6a:	e9 43 fb ff ff       	jmpq   8008b2 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d6f:	48 83 c4 60          	add    $0x60,%rsp
  800d73:	5b                   	pop    %rbx
  800d74:	41 5c                	pop    %r12
  800d76:	5d                   	pop    %rbp
  800d77:	c3                   	retq   

0000000000800d78 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d78:	55                   	push   %rbp
  800d79:	48 89 e5             	mov    %rsp,%rbp
  800d7c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d83:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d8a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d91:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d98:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d9f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800da6:	84 c0                	test   %al,%al
  800da8:	74 20                	je     800dca <printfmt+0x52>
  800daa:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dae:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800db2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800db6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dba:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dbe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dc2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dc6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dca:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dd1:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dd8:	00 00 00 
  800ddb:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800de2:	00 00 00 
  800de5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800de9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800df0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800df7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dfe:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e05:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e0c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e13:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e1a:	48 89 c7             	mov    %rax,%rdi
  800e1d:	48 b8 60 08 80 00 00 	movabs $0x800860,%rax
  800e24:	00 00 00 
  800e27:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e29:	c9                   	leaveq 
  800e2a:	c3                   	retq   

0000000000800e2b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2b:	55                   	push   %rbp
  800e2c:	48 89 e5             	mov    %rsp,%rbp
  800e2f:	48 83 ec 10          	sub    $0x10,%rsp
  800e33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3e:	8b 40 10             	mov    0x10(%rax),%eax
  800e41:	8d 50 01             	lea    0x1(%rax),%edx
  800e44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e48:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4f:	48 8b 10             	mov    (%rax),%rdx
  800e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e56:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e5a:	48 39 c2             	cmp    %rax,%rdx
  800e5d:	73 17                	jae    800e76 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e63:	48 8b 00             	mov    (%rax),%rax
  800e66:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e6e:	48 89 0a             	mov    %rcx,(%rdx)
  800e71:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e74:	88 10                	mov    %dl,(%rax)
}
  800e76:	c9                   	leaveq 
  800e77:	c3                   	retq   

0000000000800e78 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e78:	55                   	push   %rbp
  800e79:	48 89 e5             	mov    %rsp,%rbp
  800e7c:	48 83 ec 50          	sub    $0x50,%rsp
  800e80:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e84:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e87:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e8b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e8f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e93:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e97:	48 8b 0a             	mov    (%rdx),%rcx
  800e9a:	48 89 08             	mov    %rcx,(%rax)
  800e9d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ea1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ea5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ea9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ead:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eb5:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eb8:	48 98                	cltq   
  800eba:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ebe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec2:	48 01 d0             	add    %rdx,%rax
  800ec5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ec9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ed0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ed5:	74 06                	je     800edd <vsnprintf+0x65>
  800ed7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800edb:	7f 07                	jg     800ee4 <vsnprintf+0x6c>
		return -E_INVAL;
  800edd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ee2:	eb 2f                	jmp    800f13 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ee4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ee8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800eec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ef0:	48 89 c6             	mov    %rax,%rsi
  800ef3:	48 bf 2b 0e 80 00 00 	movabs $0x800e2b,%rdi
  800efa:	00 00 00 
  800efd:	48 b8 60 08 80 00 00 	movabs $0x800860,%rax
  800f04:	00 00 00 
  800f07:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f0d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f10:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f13:	c9                   	leaveq 
  800f14:	c3                   	retq   

0000000000800f15 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f15:	55                   	push   %rbp
  800f16:	48 89 e5             	mov    %rsp,%rbp
  800f19:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f20:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f27:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f2d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f34:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f3b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f42:	84 c0                	test   %al,%al
  800f44:	74 20                	je     800f66 <snprintf+0x51>
  800f46:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f4a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f4e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f52:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f56:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f5a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f5e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f62:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f66:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f6d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f74:	00 00 00 
  800f77:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f7e:	00 00 00 
  800f81:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f85:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f8c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f93:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f9a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fa1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fa8:	48 8b 0a             	mov    (%rdx),%rcx
  800fab:	48 89 08             	mov    %rcx,(%rax)
  800fae:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fb2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fb6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fba:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fbe:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fc5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fcc:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fd2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fd9:	48 89 c7             	mov    %rax,%rdi
  800fdc:	48 b8 78 0e 80 00 00 	movabs $0x800e78,%rax
  800fe3:	00 00 00 
  800fe6:	ff d0                	callq  *%rax
  800fe8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fee:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ff4:	c9                   	leaveq 
  800ff5:	c3                   	retq   

0000000000800ff6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ff6:	55                   	push   %rbp
  800ff7:	48 89 e5             	mov    %rsp,%rbp
  800ffa:	48 83 ec 18          	sub    $0x18,%rsp
  800ffe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801002:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801009:	eb 09                	jmp    801014 <strlen+0x1e>
		n++;
  80100b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80100f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801014:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801018:	0f b6 00             	movzbl (%rax),%eax
  80101b:	84 c0                	test   %al,%al
  80101d:	75 ec                	jne    80100b <strlen+0x15>
		n++;
	return n;
  80101f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801022:	c9                   	leaveq 
  801023:	c3                   	retq   

0000000000801024 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801024:	55                   	push   %rbp
  801025:	48 89 e5             	mov    %rsp,%rbp
  801028:	48 83 ec 20          	sub    $0x20,%rsp
  80102c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801030:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801034:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80103b:	eb 0e                	jmp    80104b <strnlen+0x27>
		n++;
  80103d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801041:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801046:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80104b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801050:	74 0b                	je     80105d <strnlen+0x39>
  801052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801056:	0f b6 00             	movzbl (%rax),%eax
  801059:	84 c0                	test   %al,%al
  80105b:	75 e0                	jne    80103d <strnlen+0x19>
		n++;
	return n;
  80105d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801060:	c9                   	leaveq 
  801061:	c3                   	retq   

0000000000801062 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801062:	55                   	push   %rbp
  801063:	48 89 e5             	mov    %rsp,%rbp
  801066:	48 83 ec 20          	sub    $0x20,%rsp
  80106a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80106e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801076:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80107a:	90                   	nop
  80107b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801083:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801087:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80108b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80108f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801093:	0f b6 12             	movzbl (%rdx),%edx
  801096:	88 10                	mov    %dl,(%rax)
  801098:	0f b6 00             	movzbl (%rax),%eax
  80109b:	84 c0                	test   %al,%al
  80109d:	75 dc                	jne    80107b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80109f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010a3:	c9                   	leaveq 
  8010a4:	c3                   	retq   

00000000008010a5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010a5:	55                   	push   %rbp
  8010a6:	48 89 e5             	mov    %rsp,%rbp
  8010a9:	48 83 ec 20          	sub    $0x20,%rsp
  8010ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b9:	48 89 c7             	mov    %rax,%rdi
  8010bc:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  8010c3:	00 00 00 
  8010c6:	ff d0                	callq  *%rax
  8010c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ce:	48 63 d0             	movslq %eax,%rdx
  8010d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d5:	48 01 c2             	add    %rax,%rdx
  8010d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010dc:	48 89 c6             	mov    %rax,%rsi
  8010df:	48 89 d7             	mov    %rdx,%rdi
  8010e2:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  8010e9:	00 00 00 
  8010ec:	ff d0                	callq  *%rax
	return dst;
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010f2:	c9                   	leaveq 
  8010f3:	c3                   	retq   

00000000008010f4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010f4:	55                   	push   %rbp
  8010f5:	48 89 e5             	mov    %rsp,%rbp
  8010f8:	48 83 ec 28          	sub    $0x28,%rsp
  8010fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801100:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801104:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801110:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801117:	00 
  801118:	eb 2a                	jmp    801144 <strncpy+0x50>
		*dst++ = *src;
  80111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801122:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801126:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80112a:	0f b6 12             	movzbl (%rdx),%edx
  80112d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80112f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801133:	0f b6 00             	movzbl (%rax),%eax
  801136:	84 c0                	test   %al,%al
  801138:	74 05                	je     80113f <strncpy+0x4b>
			src++;
  80113a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801144:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801148:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80114c:	72 cc                	jb     80111a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80114e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801152:	c9                   	leaveq 
  801153:	c3                   	retq   

0000000000801154 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801154:	55                   	push   %rbp
  801155:	48 89 e5             	mov    %rsp,%rbp
  801158:	48 83 ec 28          	sub    $0x28,%rsp
  80115c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801160:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801164:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801170:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801175:	74 3d                	je     8011b4 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801177:	eb 1d                	jmp    801196 <strlcpy+0x42>
			*dst++ = *src++;
  801179:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801181:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801185:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801189:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80118d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801191:	0f b6 12             	movzbl (%rdx),%edx
  801194:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801196:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80119b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a0:	74 0b                	je     8011ad <strlcpy+0x59>
  8011a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a6:	0f b6 00             	movzbl (%rax),%eax
  8011a9:	84 c0                	test   %al,%al
  8011ab:	75 cc                	jne    801179 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bc:	48 29 c2             	sub    %rax,%rdx
  8011bf:	48 89 d0             	mov    %rdx,%rax
}
  8011c2:	c9                   	leaveq 
  8011c3:	c3                   	retq   

00000000008011c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011c4:	55                   	push   %rbp
  8011c5:	48 89 e5             	mov    %rsp,%rbp
  8011c8:	48 83 ec 10          	sub    $0x10,%rsp
  8011cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011d4:	eb 0a                	jmp    8011e0 <strcmp+0x1c>
		p++, q++;
  8011d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011db:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e4:	0f b6 00             	movzbl (%rax),%eax
  8011e7:	84 c0                	test   %al,%al
  8011e9:	74 12                	je     8011fd <strcmp+0x39>
  8011eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ef:	0f b6 10             	movzbl (%rax),%edx
  8011f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f6:	0f b6 00             	movzbl (%rax),%eax
  8011f9:	38 c2                	cmp    %al,%dl
  8011fb:	74 d9                	je     8011d6 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801201:	0f b6 00             	movzbl (%rax),%eax
  801204:	0f b6 d0             	movzbl %al,%edx
  801207:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120b:	0f b6 00             	movzbl (%rax),%eax
  80120e:	0f b6 c0             	movzbl %al,%eax
  801211:	29 c2                	sub    %eax,%edx
  801213:	89 d0                	mov    %edx,%eax
}
  801215:	c9                   	leaveq 
  801216:	c3                   	retq   

0000000000801217 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801217:	55                   	push   %rbp
  801218:	48 89 e5             	mov    %rsp,%rbp
  80121b:	48 83 ec 18          	sub    $0x18,%rsp
  80121f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801223:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801227:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80122b:	eb 0f                	jmp    80123c <strncmp+0x25>
		n--, p++, q++;
  80122d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801232:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801237:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80123c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801241:	74 1d                	je     801260 <strncmp+0x49>
  801243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801247:	0f b6 00             	movzbl (%rax),%eax
  80124a:	84 c0                	test   %al,%al
  80124c:	74 12                	je     801260 <strncmp+0x49>
  80124e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801252:	0f b6 10             	movzbl (%rax),%edx
  801255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801259:	0f b6 00             	movzbl (%rax),%eax
  80125c:	38 c2                	cmp    %al,%dl
  80125e:	74 cd                	je     80122d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801260:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801265:	75 07                	jne    80126e <strncmp+0x57>
		return 0;
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	eb 18                	jmp    801286 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80126e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801272:	0f b6 00             	movzbl (%rax),%eax
  801275:	0f b6 d0             	movzbl %al,%edx
  801278:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127c:	0f b6 00             	movzbl (%rax),%eax
  80127f:	0f b6 c0             	movzbl %al,%eax
  801282:	29 c2                	sub    %eax,%edx
  801284:	89 d0                	mov    %edx,%eax
}
  801286:	c9                   	leaveq 
  801287:	c3                   	retq   

0000000000801288 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801288:	55                   	push   %rbp
  801289:	48 89 e5             	mov    %rsp,%rbp
  80128c:	48 83 ec 0c          	sub    $0xc,%rsp
  801290:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801294:	89 f0                	mov    %esi,%eax
  801296:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801299:	eb 17                	jmp    8012b2 <strchr+0x2a>
		if (*s == c)
  80129b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129f:	0f b6 00             	movzbl (%rax),%eax
  8012a2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a5:	75 06                	jne    8012ad <strchr+0x25>
			return (char *) s;
  8012a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ab:	eb 15                	jmp    8012c2 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b6:	0f b6 00             	movzbl (%rax),%eax
  8012b9:	84 c0                	test   %al,%al
  8012bb:	75 de                	jne    80129b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c2:	c9                   	leaveq 
  8012c3:	c3                   	retq   

00000000008012c4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012c4:	55                   	push   %rbp
  8012c5:	48 89 e5             	mov    %rsp,%rbp
  8012c8:	48 83 ec 0c          	sub    $0xc,%rsp
  8012cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d0:	89 f0                	mov    %esi,%eax
  8012d2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d5:	eb 13                	jmp    8012ea <strfind+0x26>
		if (*s == c)
  8012d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012db:	0f b6 00             	movzbl (%rax),%eax
  8012de:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e1:	75 02                	jne    8012e5 <strfind+0x21>
			break;
  8012e3:	eb 10                	jmp    8012f5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ee:	0f b6 00             	movzbl (%rax),%eax
  8012f1:	84 c0                	test   %al,%al
  8012f3:	75 e2                	jne    8012d7 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012f9:	c9                   	leaveq 
  8012fa:	c3                   	retq   

00000000008012fb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012fb:	55                   	push   %rbp
  8012fc:	48 89 e5             	mov    %rsp,%rbp
  8012ff:	48 83 ec 18          	sub    $0x18,%rsp
  801303:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801307:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80130a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80130e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801313:	75 06                	jne    80131b <memset+0x20>
		return v;
  801315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801319:	eb 69                	jmp    801384 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80131b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131f:	83 e0 03             	and    $0x3,%eax
  801322:	48 85 c0             	test   %rax,%rax
  801325:	75 48                	jne    80136f <memset+0x74>
  801327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132b:	83 e0 03             	and    $0x3,%eax
  80132e:	48 85 c0             	test   %rax,%rax
  801331:	75 3c                	jne    80136f <memset+0x74>
		c &= 0xFF;
  801333:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80133a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133d:	c1 e0 18             	shl    $0x18,%eax
  801340:	89 c2                	mov    %eax,%edx
  801342:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801345:	c1 e0 10             	shl    $0x10,%eax
  801348:	09 c2                	or     %eax,%edx
  80134a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134d:	c1 e0 08             	shl    $0x8,%eax
  801350:	09 d0                	or     %edx,%eax
  801352:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801355:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801359:	48 c1 e8 02          	shr    $0x2,%rax
  80135d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801360:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801364:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801367:	48 89 d7             	mov    %rdx,%rdi
  80136a:	fc                   	cld    
  80136b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80136d:	eb 11                	jmp    801380 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80136f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801373:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801376:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80137a:	48 89 d7             	mov    %rdx,%rdi
  80137d:	fc                   	cld    
  80137e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801384:	c9                   	leaveq 
  801385:	c3                   	retq   

0000000000801386 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801386:	55                   	push   %rbp
  801387:	48 89 e5             	mov    %rsp,%rbp
  80138a:	48 83 ec 28          	sub    $0x28,%rsp
  80138e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801392:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801396:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80139a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80139e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ae:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013b2:	0f 83 88 00 00 00    	jae    801440 <memmove+0xba>
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c0:	48 01 d0             	add    %rdx,%rax
  8013c3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013c7:	76 77                	jbe    801440 <memmove+0xba>
		s += n;
  8013c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dd:	83 e0 03             	and    $0x3,%eax
  8013e0:	48 85 c0             	test   %rax,%rax
  8013e3:	75 3b                	jne    801420 <memmove+0x9a>
  8013e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e9:	83 e0 03             	and    $0x3,%eax
  8013ec:	48 85 c0             	test   %rax,%rax
  8013ef:	75 2f                	jne    801420 <memmove+0x9a>
  8013f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f5:	83 e0 03             	and    $0x3,%eax
  8013f8:	48 85 c0             	test   %rax,%rax
  8013fb:	75 23                	jne    801420 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801401:	48 83 e8 04          	sub    $0x4,%rax
  801405:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801409:	48 83 ea 04          	sub    $0x4,%rdx
  80140d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801411:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801415:	48 89 c7             	mov    %rax,%rdi
  801418:	48 89 d6             	mov    %rdx,%rsi
  80141b:	fd                   	std    
  80141c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80141e:	eb 1d                	jmp    80143d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801424:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801428:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801434:	48 89 d7             	mov    %rdx,%rdi
  801437:	48 89 c1             	mov    %rax,%rcx
  80143a:	fd                   	std    
  80143b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80143d:	fc                   	cld    
  80143e:	eb 57                	jmp    801497 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801440:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801444:	83 e0 03             	and    $0x3,%eax
  801447:	48 85 c0             	test   %rax,%rax
  80144a:	75 36                	jne    801482 <memmove+0xfc>
  80144c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801450:	83 e0 03             	and    $0x3,%eax
  801453:	48 85 c0             	test   %rax,%rax
  801456:	75 2a                	jne    801482 <memmove+0xfc>
  801458:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145c:	83 e0 03             	and    $0x3,%eax
  80145f:	48 85 c0             	test   %rax,%rax
  801462:	75 1e                	jne    801482 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801464:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801468:	48 c1 e8 02          	shr    $0x2,%rax
  80146c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80146f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801473:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801477:	48 89 c7             	mov    %rax,%rdi
  80147a:	48 89 d6             	mov    %rdx,%rsi
  80147d:	fc                   	cld    
  80147e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801480:	eb 15                	jmp    801497 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801486:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80148e:	48 89 c7             	mov    %rax,%rdi
  801491:	48 89 d6             	mov    %rdx,%rsi
  801494:	fc                   	cld    
  801495:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80149b:	c9                   	leaveq 
  80149c:	c3                   	retq   

000000000080149d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80149d:	55                   	push   %rbp
  80149e:	48 89 e5             	mov    %rsp,%rbp
  8014a1:	48 83 ec 18          	sub    $0x18,%rsp
  8014a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014b5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bd:	48 89 ce             	mov    %rcx,%rsi
  8014c0:	48 89 c7             	mov    %rax,%rdi
  8014c3:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  8014ca:	00 00 00 
  8014cd:	ff d0                	callq  *%rax
}
  8014cf:	c9                   	leaveq 
  8014d0:	c3                   	retq   

00000000008014d1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014d1:	55                   	push   %rbp
  8014d2:	48 89 e5             	mov    %rsp,%rbp
  8014d5:	48 83 ec 28          	sub    $0x28,%rsp
  8014d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014f5:	eb 36                	jmp    80152d <memcmp+0x5c>
		if (*s1 != *s2)
  8014f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fb:	0f b6 10             	movzbl (%rax),%edx
  8014fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801502:	0f b6 00             	movzbl (%rax),%eax
  801505:	38 c2                	cmp    %al,%dl
  801507:	74 1a                	je     801523 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801509:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150d:	0f b6 00             	movzbl (%rax),%eax
  801510:	0f b6 d0             	movzbl %al,%edx
  801513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801517:	0f b6 00             	movzbl (%rax),%eax
  80151a:	0f b6 c0             	movzbl %al,%eax
  80151d:	29 c2                	sub    %eax,%edx
  80151f:	89 d0                	mov    %edx,%eax
  801521:	eb 20                	jmp    801543 <memcmp+0x72>
		s1++, s2++;
  801523:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801528:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80152d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801531:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801535:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801539:	48 85 c0             	test   %rax,%rax
  80153c:	75 b9                	jne    8014f7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80153e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801543:	c9                   	leaveq 
  801544:	c3                   	retq   

0000000000801545 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801545:	55                   	push   %rbp
  801546:	48 89 e5             	mov    %rsp,%rbp
  801549:	48 83 ec 28          	sub    $0x28,%rsp
  80154d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801551:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801554:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801560:	48 01 d0             	add    %rdx,%rax
  801563:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801567:	eb 15                	jmp    80157e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156d:	0f b6 10             	movzbl (%rax),%edx
  801570:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801573:	38 c2                	cmp    %al,%dl
  801575:	75 02                	jne    801579 <memfind+0x34>
			break;
  801577:	eb 0f                	jmp    801588 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801579:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80157e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801582:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801586:	72 e1                	jb     801569 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80158c:	c9                   	leaveq 
  80158d:	c3                   	retq   

000000000080158e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80158e:	55                   	push   %rbp
  80158f:	48 89 e5             	mov    %rsp,%rbp
  801592:	48 83 ec 34          	sub    $0x34,%rsp
  801596:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80159a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80159e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015a8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015af:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b0:	eb 05                	jmp    8015b7 <strtol+0x29>
		s++;
  8015b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bb:	0f b6 00             	movzbl (%rax),%eax
  8015be:	3c 20                	cmp    $0x20,%al
  8015c0:	74 f0                	je     8015b2 <strtol+0x24>
  8015c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c6:	0f b6 00             	movzbl (%rax),%eax
  8015c9:	3c 09                	cmp    $0x9,%al
  8015cb:	74 e5                	je     8015b2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	3c 2b                	cmp    $0x2b,%al
  8015d6:	75 07                	jne    8015df <strtol+0x51>
		s++;
  8015d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015dd:	eb 17                	jmp    8015f6 <strtol+0x68>
	else if (*s == '-')
  8015df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e3:	0f b6 00             	movzbl (%rax),%eax
  8015e6:	3c 2d                	cmp    $0x2d,%al
  8015e8:	75 0c                	jne    8015f6 <strtol+0x68>
		s++, neg = 1;
  8015ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015ef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015fa:	74 06                	je     801602 <strtol+0x74>
  8015fc:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801600:	75 28                	jne    80162a <strtol+0x9c>
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	0f b6 00             	movzbl (%rax),%eax
  801609:	3c 30                	cmp    $0x30,%al
  80160b:	75 1d                	jne    80162a <strtol+0x9c>
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	48 83 c0 01          	add    $0x1,%rax
  801615:	0f b6 00             	movzbl (%rax),%eax
  801618:	3c 78                	cmp    $0x78,%al
  80161a:	75 0e                	jne    80162a <strtol+0x9c>
		s += 2, base = 16;
  80161c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801621:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801628:	eb 2c                	jmp    801656 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80162a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80162e:	75 19                	jne    801649 <strtol+0xbb>
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	0f b6 00             	movzbl (%rax),%eax
  801637:	3c 30                	cmp    $0x30,%al
  801639:	75 0e                	jne    801649 <strtol+0xbb>
		s++, base = 8;
  80163b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801640:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801647:	eb 0d                	jmp    801656 <strtol+0xc8>
	else if (base == 0)
  801649:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80164d:	75 07                	jne    801656 <strtol+0xc8>
		base = 10;
  80164f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801656:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165a:	0f b6 00             	movzbl (%rax),%eax
  80165d:	3c 2f                	cmp    $0x2f,%al
  80165f:	7e 1d                	jle    80167e <strtol+0xf0>
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	0f b6 00             	movzbl (%rax),%eax
  801668:	3c 39                	cmp    $0x39,%al
  80166a:	7f 12                	jg     80167e <strtol+0xf0>
			dig = *s - '0';
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	0f b6 00             	movzbl (%rax),%eax
  801673:	0f be c0             	movsbl %al,%eax
  801676:	83 e8 30             	sub    $0x30,%eax
  801679:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80167c:	eb 4e                	jmp    8016cc <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	3c 60                	cmp    $0x60,%al
  801687:	7e 1d                	jle    8016a6 <strtol+0x118>
  801689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	3c 7a                	cmp    $0x7a,%al
  801692:	7f 12                	jg     8016a6 <strtol+0x118>
			dig = *s - 'a' + 10;
  801694:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801698:	0f b6 00             	movzbl (%rax),%eax
  80169b:	0f be c0             	movsbl %al,%eax
  80169e:	83 e8 57             	sub    $0x57,%eax
  8016a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016a4:	eb 26                	jmp    8016cc <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016aa:	0f b6 00             	movzbl (%rax),%eax
  8016ad:	3c 40                	cmp    $0x40,%al
  8016af:	7e 48                	jle    8016f9 <strtol+0x16b>
  8016b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b5:	0f b6 00             	movzbl (%rax),%eax
  8016b8:	3c 5a                	cmp    $0x5a,%al
  8016ba:	7f 3d                	jg     8016f9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c0:	0f b6 00             	movzbl (%rax),%eax
  8016c3:	0f be c0             	movsbl %al,%eax
  8016c6:	83 e8 37             	sub    $0x37,%eax
  8016c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016cf:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016d2:	7c 02                	jl     8016d6 <strtol+0x148>
			break;
  8016d4:	eb 23                	jmp    8016f9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016d6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016db:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016de:	48 98                	cltq   
  8016e0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016e5:	48 89 c2             	mov    %rax,%rdx
  8016e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016eb:	48 98                	cltq   
  8016ed:	48 01 d0             	add    %rdx,%rax
  8016f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016f4:	e9 5d ff ff ff       	jmpq   801656 <strtol+0xc8>

	if (endptr)
  8016f9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016fe:	74 0b                	je     80170b <strtol+0x17d>
		*endptr = (char *) s;
  801700:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801704:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801708:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80170b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80170f:	74 09                	je     80171a <strtol+0x18c>
  801711:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801715:	48 f7 d8             	neg    %rax
  801718:	eb 04                	jmp    80171e <strtol+0x190>
  80171a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80171e:	c9                   	leaveq 
  80171f:	c3                   	retq   

0000000000801720 <strstr>:

char * strstr(const char *in, const char *str)
{
  801720:	55                   	push   %rbp
  801721:	48 89 e5             	mov    %rsp,%rbp
  801724:	48 83 ec 30          	sub    $0x30,%rsp
  801728:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80172c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801730:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801734:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801738:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80173c:	0f b6 00             	movzbl (%rax),%eax
  80173f:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801742:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801746:	75 06                	jne    80174e <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801748:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174c:	eb 6b                	jmp    8017b9 <strstr+0x99>

	len = strlen(str);
  80174e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801752:	48 89 c7             	mov    %rax,%rdi
  801755:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  80175c:	00 00 00 
  80175f:	ff d0                	callq  *%rax
  801761:	48 98                	cltq   
  801763:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80176f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801773:	0f b6 00             	movzbl (%rax),%eax
  801776:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801779:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80177d:	75 07                	jne    801786 <strstr+0x66>
				return (char *) 0;
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
  801784:	eb 33                	jmp    8017b9 <strstr+0x99>
		} while (sc != c);
  801786:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80178a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80178d:	75 d8                	jne    801767 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80178f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801793:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801797:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179b:	48 89 ce             	mov    %rcx,%rsi
  80179e:	48 89 c7             	mov    %rax,%rdi
  8017a1:	48 b8 17 12 80 00 00 	movabs $0x801217,%rax
  8017a8:	00 00 00 
  8017ab:	ff d0                	callq  *%rax
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	75 b6                	jne    801767 <strstr+0x47>

	return (char *) (in - 1);
  8017b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b5:	48 83 e8 01          	sub    $0x1,%rax
}
  8017b9:	c9                   	leaveq 
  8017ba:	c3                   	retq   

00000000008017bb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017bb:	55                   	push   %rbp
  8017bc:	48 89 e5             	mov    %rsp,%rbp
  8017bf:	53                   	push   %rbx
  8017c0:	48 83 ec 48          	sub    $0x48,%rsp
  8017c4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017c7:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017ca:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017ce:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017d2:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017d6:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017da:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017dd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017e1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017e5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017e9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017ed:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017f1:	4c 89 c3             	mov    %r8,%rbx
  8017f4:	cd 30                	int    $0x30
  8017f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017fe:	74 3e                	je     80183e <syscall+0x83>
  801800:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801805:	7e 37                	jle    80183e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801807:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80180e:	49 89 d0             	mov    %rdx,%r8
  801811:	89 c1                	mov    %eax,%ecx
  801813:	48 ba a8 45 80 00 00 	movabs $0x8045a8,%rdx
  80181a:	00 00 00 
  80181d:	be 23 00 00 00       	mov    $0x23,%esi
  801822:	48 bf c5 45 80 00 00 	movabs $0x8045c5,%rdi
  801829:	00 00 00 
  80182c:	b8 00 00 00 00       	mov    $0x0,%eax
  801831:	49 b9 74 02 80 00 00 	movabs $0x800274,%r9
  801838:	00 00 00 
  80183b:	41 ff d1             	callq  *%r9

	return ret;
  80183e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801842:	48 83 c4 48          	add    $0x48,%rsp
  801846:	5b                   	pop    %rbx
  801847:	5d                   	pop    %rbp
  801848:	c3                   	retq   

0000000000801849 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801849:	55                   	push   %rbp
  80184a:	48 89 e5             	mov    %rsp,%rbp
  80184d:	48 83 ec 20          	sub    $0x20,%rsp
  801851:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801855:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801859:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80185d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801861:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801868:	00 
  801869:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801875:	48 89 d1             	mov    %rdx,%rcx
  801878:	48 89 c2             	mov    %rax,%rdx
  80187b:	be 00 00 00 00       	mov    $0x0,%esi
  801880:	bf 00 00 00 00       	mov    $0x0,%edi
  801885:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  80188c:	00 00 00 
  80188f:	ff d0                	callq  *%rax
}
  801891:	c9                   	leaveq 
  801892:	c3                   	retq   

0000000000801893 <sys_cgetc>:

int
sys_cgetc(void)
{
  801893:	55                   	push   %rbp
  801894:	48 89 e5             	mov    %rsp,%rbp
  801897:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80189b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a2:	00 
  8018a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b9:	be 00 00 00 00       	mov    $0x0,%esi
  8018be:	bf 01 00 00 00       	mov    $0x1,%edi
  8018c3:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  8018ca:	00 00 00 
  8018cd:	ff d0                	callq  *%rax
}
  8018cf:	c9                   	leaveq 
  8018d0:	c3                   	retq   

00000000008018d1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018d1:	55                   	push   %rbp
  8018d2:	48 89 e5             	mov    %rsp,%rbp
  8018d5:	48 83 ec 10          	sub    $0x10,%rsp
  8018d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018df:	48 98                	cltq   
  8018e1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e8:	00 
  8018e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018fa:	48 89 c2             	mov    %rax,%rdx
  8018fd:	be 01 00 00 00       	mov    $0x1,%esi
  801902:	bf 03 00 00 00       	mov    $0x3,%edi
  801907:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  80190e:	00 00 00 
  801911:	ff d0                	callq  *%rax
}
  801913:	c9                   	leaveq 
  801914:	c3                   	retq   

0000000000801915 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801915:	55                   	push   %rbp
  801916:	48 89 e5             	mov    %rsp,%rbp
  801919:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80191d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801924:	00 
  801925:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801931:	b9 00 00 00 00       	mov    $0x0,%ecx
  801936:	ba 00 00 00 00       	mov    $0x0,%edx
  80193b:	be 00 00 00 00       	mov    $0x0,%esi
  801940:	bf 02 00 00 00       	mov    $0x2,%edi
  801945:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  80194c:	00 00 00 
  80194f:	ff d0                	callq  *%rax
}
  801951:	c9                   	leaveq 
  801952:	c3                   	retq   

0000000000801953 <sys_yield>:

void
sys_yield(void)
{
  801953:	55                   	push   %rbp
  801954:	48 89 e5             	mov    %rsp,%rbp
  801957:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80195b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801962:	00 
  801963:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801969:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801974:	ba 00 00 00 00       	mov    $0x0,%edx
  801979:	be 00 00 00 00       	mov    $0x0,%esi
  80197e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801983:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  80198a:	00 00 00 
  80198d:	ff d0                	callq  *%rax
}
  80198f:	c9                   	leaveq 
  801990:	c3                   	retq   

0000000000801991 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801991:	55                   	push   %rbp
  801992:	48 89 e5             	mov    %rsp,%rbp
  801995:	48 83 ec 20          	sub    $0x20,%rsp
  801999:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80199c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019a6:	48 63 c8             	movslq %eax,%rcx
  8019a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b0:	48 98                	cltq   
  8019b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b9:	00 
  8019ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c0:	49 89 c8             	mov    %rcx,%r8
  8019c3:	48 89 d1             	mov    %rdx,%rcx
  8019c6:	48 89 c2             	mov    %rax,%rdx
  8019c9:	be 01 00 00 00       	mov    $0x1,%esi
  8019ce:	bf 04 00 00 00       	mov    $0x4,%edi
  8019d3:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  8019da:	00 00 00 
  8019dd:	ff d0                	callq  *%rax
}
  8019df:	c9                   	leaveq 
  8019e0:	c3                   	retq   

00000000008019e1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019e1:	55                   	push   %rbp
  8019e2:	48 89 e5             	mov    %rsp,%rbp
  8019e5:	48 83 ec 30          	sub    $0x30,%rsp
  8019e9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019f0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019f3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019f7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019fb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019fe:	48 63 c8             	movslq %eax,%rcx
  801a01:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a08:	48 63 f0             	movslq %eax,%rsi
  801a0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a12:	48 98                	cltq   
  801a14:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a18:	49 89 f9             	mov    %rdi,%r9
  801a1b:	49 89 f0             	mov    %rsi,%r8
  801a1e:	48 89 d1             	mov    %rdx,%rcx
  801a21:	48 89 c2             	mov    %rax,%rdx
  801a24:	be 01 00 00 00       	mov    $0x1,%esi
  801a29:	bf 05 00 00 00       	mov    $0x5,%edi
  801a2e:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801a35:	00 00 00 
  801a38:	ff d0                	callq  *%rax
}
  801a3a:	c9                   	leaveq 
  801a3b:	c3                   	retq   

0000000000801a3c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a3c:	55                   	push   %rbp
  801a3d:	48 89 e5             	mov    %rsp,%rbp
  801a40:	48 83 ec 20          	sub    $0x20,%rsp
  801a44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a52:	48 98                	cltq   
  801a54:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5b:	00 
  801a5c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a62:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a68:	48 89 d1             	mov    %rdx,%rcx
  801a6b:	48 89 c2             	mov    %rax,%rdx
  801a6e:	be 01 00 00 00       	mov    $0x1,%esi
  801a73:	bf 06 00 00 00       	mov    $0x6,%edi
  801a78:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801a7f:	00 00 00 
  801a82:	ff d0                	callq  *%rax
}
  801a84:	c9                   	leaveq 
  801a85:	c3                   	retq   

0000000000801a86 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a86:	55                   	push   %rbp
  801a87:	48 89 e5             	mov    %rsp,%rbp
  801a8a:	48 83 ec 10          	sub    $0x10,%rsp
  801a8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a91:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a97:	48 63 d0             	movslq %eax,%rdx
  801a9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9d:	48 98                	cltq   
  801a9f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa6:	00 
  801aa7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab3:	48 89 d1             	mov    %rdx,%rcx
  801ab6:	48 89 c2             	mov    %rax,%rdx
  801ab9:	be 01 00 00 00       	mov    $0x1,%esi
  801abe:	bf 08 00 00 00       	mov    $0x8,%edi
  801ac3:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801aca:	00 00 00 
  801acd:	ff d0                	callq  *%rax
}
  801acf:	c9                   	leaveq 
  801ad0:	c3                   	retq   

0000000000801ad1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ad1:	55                   	push   %rbp
  801ad2:	48 89 e5             	mov    %rsp,%rbp
  801ad5:	48 83 ec 20          	sub    $0x20,%rsp
  801ad9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801adc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ae0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae7:	48 98                	cltq   
  801ae9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af0:	00 
  801af1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afd:	48 89 d1             	mov    %rdx,%rcx
  801b00:	48 89 c2             	mov    %rax,%rdx
  801b03:	be 01 00 00 00       	mov    $0x1,%esi
  801b08:	bf 09 00 00 00       	mov    $0x9,%edi
  801b0d:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	callq  *%rax
}
  801b19:	c9                   	leaveq 
  801b1a:	c3                   	retq   

0000000000801b1b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b1b:	55                   	push   %rbp
  801b1c:	48 89 e5             	mov    %rsp,%rbp
  801b1f:	48 83 ec 20          	sub    $0x20,%rsp
  801b23:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b31:	48 98                	cltq   
  801b33:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3a:	00 
  801b3b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b41:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b47:	48 89 d1             	mov    %rdx,%rcx
  801b4a:	48 89 c2             	mov    %rax,%rdx
  801b4d:	be 01 00 00 00       	mov    $0x1,%esi
  801b52:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b57:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801b5e:	00 00 00 
  801b61:	ff d0                	callq  *%rax
}
  801b63:	c9                   	leaveq 
  801b64:	c3                   	retq   

0000000000801b65 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b65:	55                   	push   %rbp
  801b66:	48 89 e5             	mov    %rsp,%rbp
  801b69:	48 83 ec 20          	sub    $0x20,%rsp
  801b6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b70:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b74:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b78:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b7e:	48 63 f0             	movslq %eax,%rsi
  801b81:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b88:	48 98                	cltq   
  801b8a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b95:	00 
  801b96:	49 89 f1             	mov    %rsi,%r9
  801b99:	49 89 c8             	mov    %rcx,%r8
  801b9c:	48 89 d1             	mov    %rdx,%rcx
  801b9f:	48 89 c2             	mov    %rax,%rdx
  801ba2:	be 00 00 00 00       	mov    $0x0,%esi
  801ba7:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bac:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801bb3:	00 00 00 
  801bb6:	ff d0                	callq  *%rax
}
  801bb8:	c9                   	leaveq 
  801bb9:	c3                   	retq   

0000000000801bba <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bba:	55                   	push   %rbp
  801bbb:	48 89 e5             	mov    %rsp,%rbp
  801bbe:	48 83 ec 10          	sub    $0x10,%rsp
  801bc2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd1:	00 
  801bd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bde:	b9 00 00 00 00       	mov    $0x0,%ecx
  801be3:	48 89 c2             	mov    %rax,%rdx
  801be6:	be 01 00 00 00       	mov    $0x1,%esi
  801beb:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bf0:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801bf7:	00 00 00 
  801bfa:	ff d0                	callq  *%rax
}
  801bfc:	c9                   	leaveq 
  801bfd:	c3                   	retq   

0000000000801bfe <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801bfe:	55                   	push   %rbp
  801bff:	48 89 e5             	mov    %rsp,%rbp
  801c02:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0d:	00 
  801c0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c24:	be 00 00 00 00       	mov    $0x0,%esi
  801c29:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c2e:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	callq  *%rax
}
  801c3a:	c9                   	leaveq 
  801c3b:	c3                   	retq   

0000000000801c3c <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801c3c:	55                   	push   %rbp
  801c3d:	48 89 e5             	mov    %rsp,%rbp
  801c40:	48 83 ec 30          	sub    $0x30,%rsp
  801c44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c4b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c4e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c52:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801c56:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c59:	48 63 c8             	movslq %eax,%rcx
  801c5c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c60:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c63:	48 63 f0             	movslq %eax,%rsi
  801c66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6d:	48 98                	cltq   
  801c6f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c73:	49 89 f9             	mov    %rdi,%r9
  801c76:	49 89 f0             	mov    %rsi,%r8
  801c79:	48 89 d1             	mov    %rdx,%rcx
  801c7c:	48 89 c2             	mov    %rax,%rdx
  801c7f:	be 00 00 00 00       	mov    $0x0,%esi
  801c84:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c89:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801c90:	00 00 00 
  801c93:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801c95:	c9                   	leaveq 
  801c96:	c3                   	retq   

0000000000801c97 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801c97:	55                   	push   %rbp
  801c98:	48 89 e5             	mov    %rsp,%rbp
  801c9b:	48 83 ec 20          	sub    $0x20,%rsp
  801c9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ca3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801ca7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801caf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb6:	00 
  801cb7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc3:	48 89 d1             	mov    %rdx,%rcx
  801cc6:	48 89 c2             	mov    %rax,%rdx
  801cc9:	be 00 00 00 00       	mov    $0x0,%esi
  801cce:	bf 10 00 00 00       	mov    $0x10,%edi
  801cd3:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801cda:	00 00 00 
  801cdd:	ff d0                	callq  *%rax
}
  801cdf:	c9                   	leaveq 
  801ce0:	c3                   	retq   

0000000000801ce1 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801ce1:	55                   	push   %rbp
  801ce2:	48 89 e5             	mov    %rsp,%rbp
  801ce5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801ce9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf0:	00 
  801cf1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d02:	ba 00 00 00 00       	mov    $0x0,%edx
  801d07:	be 00 00 00 00       	mov    $0x0,%esi
  801d0c:	bf 11 00 00 00       	mov    $0x11,%edi
  801d11:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801d1d:	c9                   	leaveq 
  801d1e:	c3                   	retq   

0000000000801d1f <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801d1f:	55                   	push   %rbp
  801d20:	48 89 e5             	mov    %rsp,%rbp
  801d23:	48 83 ec 10          	sub    $0x10,%rsp
  801d27:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2d:	48 98                	cltq   
  801d2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d36:	00 
  801d37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d43:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d48:	48 89 c2             	mov    %rax,%rdx
  801d4b:	be 00 00 00 00       	mov    $0x0,%esi
  801d50:	bf 12 00 00 00       	mov    $0x12,%edi
  801d55:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801d5c:	00 00 00 
  801d5f:	ff d0                	callq  *%rax
}
  801d61:	c9                   	leaveq 
  801d62:	c3                   	retq   

0000000000801d63 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801d63:	55                   	push   %rbp
  801d64:	48 89 e5             	mov    %rsp,%rbp
  801d67:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801d6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d72:	00 
  801d73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d84:	ba 00 00 00 00       	mov    $0x0,%edx
  801d89:	be 00 00 00 00       	mov    $0x0,%esi
  801d8e:	bf 13 00 00 00       	mov    $0x13,%edi
  801d93:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801d9a:	00 00 00 
  801d9d:	ff d0                	callq  *%rax
}
  801d9f:	c9                   	leaveq 
  801da0:	c3                   	retq   

0000000000801da1 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801da1:	55                   	push   %rbp
  801da2:	48 89 e5             	mov    %rsp,%rbp
  801da5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801da9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db0:	00 
  801db1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc7:	be 00 00 00 00       	mov    $0x0,%esi
  801dcc:	bf 14 00 00 00       	mov    $0x14,%edi
  801dd1:	48 b8 bb 17 80 00 00 	movabs $0x8017bb,%rax
  801dd8:	00 00 00 
  801ddb:	ff d0                	callq  *%rax
}
  801ddd:	c9                   	leaveq 
  801dde:	c3                   	retq   

0000000000801ddf <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801ddf:	55                   	push   %rbp
  801de0:	48 89 e5             	mov    %rsp,%rbp
  801de3:	48 83 ec 30          	sub    $0x30,%rsp
  801de7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801deb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801def:	48 8b 00             	mov    (%rax),%rax
  801df2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801df6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dfa:	48 8b 40 08          	mov    0x8(%rax),%rax
  801dfe:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801e01:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e04:	83 e0 02             	and    $0x2,%eax
  801e07:	85 c0                	test   %eax,%eax
  801e09:	75 4d                	jne    801e58 <pgfault+0x79>
  801e0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0f:	48 c1 e8 0c          	shr    $0xc,%rax
  801e13:	48 89 c2             	mov    %rax,%rdx
  801e16:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e1d:	01 00 00 
  801e20:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e24:	25 00 08 00 00       	and    $0x800,%eax
  801e29:	48 85 c0             	test   %rax,%rax
  801e2c:	74 2a                	je     801e58 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801e2e:	48 ba d8 45 80 00 00 	movabs $0x8045d8,%rdx
  801e35:	00 00 00 
  801e38:	be 23 00 00 00       	mov    $0x23,%esi
  801e3d:	48 bf 0d 46 80 00 00 	movabs $0x80460d,%rdi
  801e44:	00 00 00 
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4c:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  801e53:	00 00 00 
  801e56:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801e58:	ba 07 00 00 00       	mov    $0x7,%edx
  801e5d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e62:	bf 00 00 00 00       	mov    $0x0,%edi
  801e67:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  801e6e:	00 00 00 
  801e71:	ff d0                	callq  *%rax
  801e73:	85 c0                	test   %eax,%eax
  801e75:	0f 85 cd 00 00 00    	jne    801f48 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801e7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e87:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e8d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801e91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e95:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e9a:	48 89 c6             	mov    %rax,%rsi
  801e9d:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ea2:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  801ea9:	00 00 00 
  801eac:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801eae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb2:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801eb8:	48 89 c1             	mov    %rax,%rcx
  801ebb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec0:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ec5:	bf 00 00 00 00       	mov    $0x0,%edi
  801eca:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	callq  *%rax
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	79 2a                	jns    801f04 <pgfault+0x125>
				panic("Page map at temp address failed");
  801eda:	48 ba 18 46 80 00 00 	movabs $0x804618,%rdx
  801ee1:	00 00 00 
  801ee4:	be 30 00 00 00       	mov    $0x30,%esi
  801ee9:	48 bf 0d 46 80 00 00 	movabs $0x80460d,%rdi
  801ef0:	00 00 00 
  801ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef8:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  801eff:	00 00 00 
  801f02:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801f04:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f09:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0e:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  801f15:	00 00 00 
  801f18:	ff d0                	callq  *%rax
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	79 54                	jns    801f72 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801f1e:	48 ba 38 46 80 00 00 	movabs $0x804638,%rdx
  801f25:	00 00 00 
  801f28:	be 32 00 00 00       	mov    $0x32,%esi
  801f2d:	48 bf 0d 46 80 00 00 	movabs $0x80460d,%rdi
  801f34:	00 00 00 
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  801f43:	00 00 00 
  801f46:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801f48:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  801f4f:	00 00 00 
  801f52:	be 34 00 00 00       	mov    $0x34,%esi
  801f57:	48 bf 0d 46 80 00 00 	movabs $0x80460d,%rdi
  801f5e:	00 00 00 
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  801f6d:	00 00 00 
  801f70:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801f72:	c9                   	leaveq 
  801f73:	c3                   	retq   

0000000000801f74 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f74:	55                   	push   %rbp
  801f75:	48 89 e5             	mov    %rsp,%rbp
  801f78:	48 83 ec 20          	sub    $0x20,%rsp
  801f7c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f7f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801f82:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f89:	01 00 00 
  801f8c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f93:	25 07 0e 00 00       	and    $0xe07,%eax
  801f98:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801f9b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f9e:	48 c1 e0 0c          	shl    $0xc,%rax
  801fa2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa9:	25 00 04 00 00       	and    $0x400,%eax
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	74 57                	je     802009 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801fb2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fb5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fb9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc0:	41 89 f0             	mov    %esi,%r8d
  801fc3:	48 89 c6             	mov    %rax,%rsi
  801fc6:	bf 00 00 00 00       	mov    $0x0,%edi
  801fcb:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  801fd2:	00 00 00 
  801fd5:	ff d0                	callq  *%rax
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	0f 8e 52 01 00 00    	jle    802131 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801fdf:	48 ba 92 46 80 00 00 	movabs $0x804692,%rdx
  801fe6:	00 00 00 
  801fe9:	be 4e 00 00 00       	mov    $0x4e,%esi
  801fee:	48 bf 0d 46 80 00 00 	movabs $0x80460d,%rdi
  801ff5:	00 00 00 
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffd:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  802004:	00 00 00 
  802007:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802009:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200c:	83 e0 02             	and    $0x2,%eax
  80200f:	85 c0                	test   %eax,%eax
  802011:	75 10                	jne    802023 <duppage+0xaf>
  802013:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802016:	25 00 08 00 00       	and    $0x800,%eax
  80201b:	85 c0                	test   %eax,%eax
  80201d:	0f 84 bb 00 00 00    	je     8020de <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802023:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802026:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  80202b:	80 cc 08             	or     $0x8,%ah
  80202e:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802031:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802034:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802038:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80203b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80203f:	41 89 f0             	mov    %esi,%r8d
  802042:	48 89 c6             	mov    %rax,%rsi
  802045:	bf 00 00 00 00       	mov    $0x0,%edi
  80204a:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  802051:	00 00 00 
  802054:	ff d0                	callq  *%rax
  802056:	85 c0                	test   %eax,%eax
  802058:	7e 2a                	jle    802084 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  80205a:	48 ba 92 46 80 00 00 	movabs $0x804692,%rdx
  802061:	00 00 00 
  802064:	be 55 00 00 00       	mov    $0x55,%esi
  802069:	48 bf 0d 46 80 00 00 	movabs $0x80460d,%rdi
  802070:	00 00 00 
  802073:	b8 00 00 00 00       	mov    $0x0,%eax
  802078:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  80207f:	00 00 00 
  802082:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802084:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802087:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80208b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80208f:	41 89 c8             	mov    %ecx,%r8d
  802092:	48 89 d1             	mov    %rdx,%rcx
  802095:	ba 00 00 00 00       	mov    $0x0,%edx
  80209a:	48 89 c6             	mov    %rax,%rsi
  80209d:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a2:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  8020a9:	00 00 00 
  8020ac:	ff d0                	callq  *%rax
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	7e 2a                	jle    8020dc <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  8020b2:	48 ba 92 46 80 00 00 	movabs $0x804692,%rdx
  8020b9:	00 00 00 
  8020bc:	be 57 00 00 00       	mov    $0x57,%esi
  8020c1:	48 bf 0d 46 80 00 00 	movabs $0x80460d,%rdi
  8020c8:	00 00 00 
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d0:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  8020d7:	00 00 00 
  8020da:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020dc:	eb 53                	jmp    802131 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020de:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020e1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020e5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ec:	41 89 f0             	mov    %esi,%r8d
  8020ef:	48 89 c6             	mov    %rax,%rsi
  8020f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f7:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  8020fe:	00 00 00 
  802101:	ff d0                	callq  *%rax
  802103:	85 c0                	test   %eax,%eax
  802105:	7e 2a                	jle    802131 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802107:	48 ba 92 46 80 00 00 	movabs $0x804692,%rdx
  80210e:	00 00 00 
  802111:	be 5b 00 00 00       	mov    $0x5b,%esi
  802116:	48 bf 0d 46 80 00 00 	movabs $0x80460d,%rdi
  80211d:	00 00 00 
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
  802125:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  80212c:	00 00 00 
  80212f:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802131:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802136:	c9                   	leaveq 
  802137:	c3                   	retq   

0000000000802138 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802138:	55                   	push   %rbp
  802139:	48 89 e5             	mov    %rsp,%rbp
  80213c:	48 83 ec 18          	sub    $0x18,%rsp
  802140:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802148:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  80214c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802150:	48 c1 e8 27          	shr    $0x27,%rax
  802154:	48 89 c2             	mov    %rax,%rdx
  802157:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80215e:	01 00 00 
  802161:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802165:	83 e0 01             	and    $0x1,%eax
  802168:	48 85 c0             	test   %rax,%rax
  80216b:	74 51                	je     8021be <pt_is_mapped+0x86>
  80216d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802171:	48 c1 e0 0c          	shl    $0xc,%rax
  802175:	48 c1 e8 1e          	shr    $0x1e,%rax
  802179:	48 89 c2             	mov    %rax,%rdx
  80217c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802183:	01 00 00 
  802186:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80218a:	83 e0 01             	and    $0x1,%eax
  80218d:	48 85 c0             	test   %rax,%rax
  802190:	74 2c                	je     8021be <pt_is_mapped+0x86>
  802192:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802196:	48 c1 e0 0c          	shl    $0xc,%rax
  80219a:	48 c1 e8 15          	shr    $0x15,%rax
  80219e:	48 89 c2             	mov    %rax,%rdx
  8021a1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021a8:	01 00 00 
  8021ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021af:	83 e0 01             	and    $0x1,%eax
  8021b2:	48 85 c0             	test   %rax,%rax
  8021b5:	74 07                	je     8021be <pt_is_mapped+0x86>
  8021b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021bc:	eb 05                	jmp    8021c3 <pt_is_mapped+0x8b>
  8021be:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c3:	83 e0 01             	and    $0x1,%eax
}
  8021c6:	c9                   	leaveq 
  8021c7:	c3                   	retq   

00000000008021c8 <fork>:

envid_t
fork(void)
{
  8021c8:	55                   	push   %rbp
  8021c9:	48 89 e5             	mov    %rsp,%rbp
  8021cc:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8021d0:	48 bf df 1d 80 00 00 	movabs $0x801ddf,%rdi
  8021d7:	00 00 00 
  8021da:	48 b8 b6 3e 80 00 00 	movabs $0x803eb6,%rax
  8021e1:	00 00 00 
  8021e4:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8021e6:	b8 07 00 00 00       	mov    $0x7,%eax
  8021eb:	cd 30                	int    $0x30
  8021ed:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8021f0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8021f3:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8021f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021fa:	79 30                	jns    80222c <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8021fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021ff:	89 c1                	mov    %eax,%ecx
  802201:	48 ba b0 46 80 00 00 	movabs $0x8046b0,%rdx
  802208:	00 00 00 
  80220b:	be 86 00 00 00       	mov    $0x86,%esi
  802210:	48 bf 0d 46 80 00 00 	movabs $0x80460d,%rdi
  802217:	00 00 00 
  80221a:	b8 00 00 00 00       	mov    $0x0,%eax
  80221f:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  802226:	00 00 00 
  802229:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80222c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802230:	75 3e                	jne    802270 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802232:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  802239:	00 00 00 
  80223c:	ff d0                	callq  *%rax
  80223e:	25 ff 03 00 00       	and    $0x3ff,%eax
  802243:	48 98                	cltq   
  802245:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80224c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802253:	00 00 00 
  802256:	48 01 c2             	add    %rax,%rdx
  802259:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802260:	00 00 00 
  802263:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802266:	b8 00 00 00 00       	mov    $0x0,%eax
  80226b:	e9 d1 01 00 00       	jmpq   802441 <fork+0x279>
	}
	uint64_t ad = 0;
  802270:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802277:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802278:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80227d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802281:	e9 df 00 00 00       	jmpq   802365 <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80228a:	48 c1 e8 27          	shr    $0x27,%rax
  80228e:	48 89 c2             	mov    %rax,%rdx
  802291:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802298:	01 00 00 
  80229b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229f:	83 e0 01             	and    $0x1,%eax
  8022a2:	48 85 c0             	test   %rax,%rax
  8022a5:	0f 84 9e 00 00 00    	je     802349 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8022ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022af:	48 c1 e8 1e          	shr    $0x1e,%rax
  8022b3:	48 89 c2             	mov    %rax,%rdx
  8022b6:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022bd:	01 00 00 
  8022c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c4:	83 e0 01             	and    $0x1,%eax
  8022c7:	48 85 c0             	test   %rax,%rax
  8022ca:	74 73                	je     80233f <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  8022cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d0:	48 c1 e8 15          	shr    $0x15,%rax
  8022d4:	48 89 c2             	mov    %rax,%rdx
  8022d7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022de:	01 00 00 
  8022e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e5:	83 e0 01             	and    $0x1,%eax
  8022e8:	48 85 c0             	test   %rax,%rax
  8022eb:	74 48                	je     802335 <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8022ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f1:	48 c1 e8 0c          	shr    $0xc,%rax
  8022f5:	48 89 c2             	mov    %rax,%rdx
  8022f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ff:	01 00 00 
  802302:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802306:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80230a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230e:	83 e0 01             	and    $0x1,%eax
  802311:	48 85 c0             	test   %rax,%rax
  802314:	74 47                	je     80235d <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80231a:	48 c1 e8 0c          	shr    $0xc,%rax
  80231e:	89 c2                	mov    %eax,%edx
  802320:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802323:	89 d6                	mov    %edx,%esi
  802325:	89 c7                	mov    %eax,%edi
  802327:	48 b8 74 1f 80 00 00 	movabs $0x801f74,%rax
  80232e:	00 00 00 
  802331:	ff d0                	callq  *%rax
  802333:	eb 28                	jmp    80235d <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802335:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80233c:	00 
  80233d:	eb 1e                	jmp    80235d <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80233f:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802346:	40 
  802347:	eb 14                	jmp    80235d <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80234d:	48 c1 e8 27          	shr    $0x27,%rax
  802351:	48 83 c0 01          	add    $0x1,%rax
  802355:	48 c1 e0 27          	shl    $0x27,%rax
  802359:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80235d:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802364:	00 
  802365:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80236c:	00 
  80236d:	0f 87 13 ff ff ff    	ja     802286 <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802373:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802376:	ba 07 00 00 00       	mov    $0x7,%edx
  80237b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802380:	89 c7                	mov    %eax,%edi
  802382:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  802389:	00 00 00 
  80238c:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80238e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802391:	ba 07 00 00 00       	mov    $0x7,%edx
  802396:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80239b:	89 c7                	mov    %eax,%edi
  80239d:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  8023a4:	00 00 00 
  8023a7:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8023a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023ac:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8023b2:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8023b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8023bc:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023c1:	89 c7                	mov    %eax,%edi
  8023c3:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  8023ca:	00 00 00 
  8023cd:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8023cf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023d4:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023d9:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8023de:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  8023e5:	00 00 00 
  8023e8:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8023ea:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f4:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  8023fb:	00 00 00 
  8023fe:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802400:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802407:	00 00 00 
  80240a:	48 8b 00             	mov    (%rax),%rax
  80240d:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802414:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802417:	48 89 d6             	mov    %rdx,%rsi
  80241a:	89 c7                	mov    %eax,%edi
  80241c:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  802423:	00 00 00 
  802426:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802428:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80242b:	be 02 00 00 00       	mov    $0x2,%esi
  802430:	89 c7                	mov    %eax,%edi
  802432:	48 b8 86 1a 80 00 00 	movabs $0x801a86,%rax
  802439:	00 00 00 
  80243c:	ff d0                	callq  *%rax

	return envid;
  80243e:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802441:	c9                   	leaveq 
  802442:	c3                   	retq   

0000000000802443 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802443:	55                   	push   %rbp
  802444:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802447:	48 ba c8 46 80 00 00 	movabs $0x8046c8,%rdx
  80244e:	00 00 00 
  802451:	be bf 00 00 00       	mov    $0xbf,%esi
  802456:	48 bf 0d 46 80 00 00 	movabs $0x80460d,%rdi
  80245d:	00 00 00 
  802460:	b8 00 00 00 00       	mov    $0x0,%eax
  802465:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  80246c:	00 00 00 
  80246f:	ff d1                	callq  *%rcx

0000000000802471 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802471:	55                   	push   %rbp
  802472:	48 89 e5             	mov    %rsp,%rbp
  802475:	48 83 ec 30          	sub    $0x30,%rsp
  802479:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80247d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802481:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802485:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80248c:	00 00 00 
  80248f:	48 8b 00             	mov    (%rax),%rax
  802492:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	75 34                	jne    8024d0 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80249c:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  8024a3:	00 00 00 
  8024a6:	ff d0                	callq  *%rax
  8024a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8024ad:	48 98                	cltq   
  8024af:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8024b6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8024bd:	00 00 00 
  8024c0:	48 01 c2             	add    %rax,%rdx
  8024c3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024ca:	00 00 00 
  8024cd:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8024d0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8024d5:	75 0e                	jne    8024e5 <ipc_recv+0x74>
		pg = (void*) UTOP;
  8024d7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8024de:	00 00 00 
  8024e1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8024e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024e9:	48 89 c7             	mov    %rax,%rdi
  8024ec:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  8024f3:	00 00 00 
  8024f6:	ff d0                	callq  *%rax
  8024f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8024fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ff:	79 19                	jns    80251a <ipc_recv+0xa9>
		*from_env_store = 0;
  802501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802505:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80250b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80250f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  802515:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802518:	eb 53                	jmp    80256d <ipc_recv+0xfc>
	}
	if(from_env_store)
  80251a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80251f:	74 19                	je     80253a <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  802521:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802528:	00 00 00 
  80252b:	48 8b 00             	mov    (%rax),%rax
  80252e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802538:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80253a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80253f:	74 19                	je     80255a <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  802541:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802548:	00 00 00 
  80254b:	48 8b 00             	mov    (%rax),%rax
  80254e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802558:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80255a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802561:	00 00 00 
  802564:	48 8b 00             	mov    (%rax),%rax
  802567:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80256d:	c9                   	leaveq 
  80256e:	c3                   	retq   

000000000080256f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80256f:	55                   	push   %rbp
  802570:	48 89 e5             	mov    %rsp,%rbp
  802573:	48 83 ec 30          	sub    $0x30,%rsp
  802577:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80257a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80257d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802581:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  802584:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802589:	75 0e                	jne    802599 <ipc_send+0x2a>
		pg = (void*)UTOP;
  80258b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802592:	00 00 00 
  802595:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  802599:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80259c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80259f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025a6:	89 c7                	mov    %eax,%edi
  8025a8:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  8025af:	00 00 00 
  8025b2:	ff d0                	callq  *%rax
  8025b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8025b7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8025bb:	75 0c                	jne    8025c9 <ipc_send+0x5a>
			sys_yield();
  8025bd:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8025c4:	00 00 00 
  8025c7:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8025c9:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8025cd:	74 ca                	je     802599 <ipc_send+0x2a>
	if(result != 0)
  8025cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d3:	74 20                	je     8025f5 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  8025d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d8:	89 c6                	mov    %eax,%esi
  8025da:	48 bf de 46 80 00 00 	movabs $0x8046de,%rdi
  8025e1:	00 00 00 
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e9:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  8025f0:	00 00 00 
  8025f3:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  8025f5:	c9                   	leaveq 
  8025f6:	c3                   	retq   

00000000008025f7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025f7:	55                   	push   %rbp
  8025f8:	48 89 e5             	mov    %rsp,%rbp
  8025fb:	48 83 ec 14          	sub    $0x14,%rsp
  8025ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802602:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802609:	eb 4e                	jmp    802659 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80260b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802612:	00 00 00 
  802615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802618:	48 98                	cltq   
  80261a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802621:	48 01 d0             	add    %rdx,%rax
  802624:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80262a:	8b 00                	mov    (%rax),%eax
  80262c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80262f:	75 24                	jne    802655 <ipc_find_env+0x5e>
			return envs[i].env_id;
  802631:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802638:	00 00 00 
  80263b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263e:	48 98                	cltq   
  802640:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802647:	48 01 d0             	add    %rdx,%rax
  80264a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802650:	8b 40 08             	mov    0x8(%rax),%eax
  802653:	eb 12                	jmp    802667 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802655:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802659:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802660:	7e a9                	jle    80260b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802662:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802667:	c9                   	leaveq 
  802668:	c3                   	retq   

0000000000802669 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802669:	55                   	push   %rbp
  80266a:	48 89 e5             	mov    %rsp,%rbp
  80266d:	48 83 ec 08          	sub    $0x8,%rsp
  802671:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802675:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802679:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802680:	ff ff ff 
  802683:	48 01 d0             	add    %rdx,%rax
  802686:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80268a:	c9                   	leaveq 
  80268b:	c3                   	retq   

000000000080268c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80268c:	55                   	push   %rbp
  80268d:	48 89 e5             	mov    %rsp,%rbp
  802690:	48 83 ec 08          	sub    $0x8,%rsp
  802694:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802698:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80269c:	48 89 c7             	mov    %rax,%rdi
  80269f:	48 b8 69 26 80 00 00 	movabs $0x802669,%rax
  8026a6:	00 00 00 
  8026a9:	ff d0                	callq  *%rax
  8026ab:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8026b1:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8026b5:	c9                   	leaveq 
  8026b6:	c3                   	retq   

00000000008026b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8026b7:	55                   	push   %rbp
  8026b8:	48 89 e5             	mov    %rsp,%rbp
  8026bb:	48 83 ec 18          	sub    $0x18,%rsp
  8026bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026ca:	eb 6b                	jmp    802737 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8026cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026cf:	48 98                	cltq   
  8026d1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026d7:	48 c1 e0 0c          	shl    $0xc,%rax
  8026db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8026df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e3:	48 c1 e8 15          	shr    $0x15,%rax
  8026e7:	48 89 c2             	mov    %rax,%rdx
  8026ea:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026f1:	01 00 00 
  8026f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f8:	83 e0 01             	and    $0x1,%eax
  8026fb:	48 85 c0             	test   %rax,%rax
  8026fe:	74 21                	je     802721 <fd_alloc+0x6a>
  802700:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802704:	48 c1 e8 0c          	shr    $0xc,%rax
  802708:	48 89 c2             	mov    %rax,%rdx
  80270b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802712:	01 00 00 
  802715:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802719:	83 e0 01             	and    $0x1,%eax
  80271c:	48 85 c0             	test   %rax,%rax
  80271f:	75 12                	jne    802733 <fd_alloc+0x7c>
			*fd_store = fd;
  802721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802725:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802729:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
  802731:	eb 1a                	jmp    80274d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802733:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802737:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80273b:	7e 8f                	jle    8026cc <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80273d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802741:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802748:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80274d:	c9                   	leaveq 
  80274e:	c3                   	retq   

000000000080274f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80274f:	55                   	push   %rbp
  802750:	48 89 e5             	mov    %rsp,%rbp
  802753:	48 83 ec 20          	sub    $0x20,%rsp
  802757:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80275a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80275e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802762:	78 06                	js     80276a <fd_lookup+0x1b>
  802764:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802768:	7e 07                	jle    802771 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80276a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80276f:	eb 6c                	jmp    8027dd <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802771:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802774:	48 98                	cltq   
  802776:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80277c:	48 c1 e0 0c          	shl    $0xc,%rax
  802780:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802784:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802788:	48 c1 e8 15          	shr    $0x15,%rax
  80278c:	48 89 c2             	mov    %rax,%rdx
  80278f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802796:	01 00 00 
  802799:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80279d:	83 e0 01             	and    $0x1,%eax
  8027a0:	48 85 c0             	test   %rax,%rax
  8027a3:	74 21                	je     8027c6 <fd_lookup+0x77>
  8027a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8027ad:	48 89 c2             	mov    %rax,%rdx
  8027b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027b7:	01 00 00 
  8027ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027be:	83 e0 01             	and    $0x1,%eax
  8027c1:	48 85 c0             	test   %rax,%rax
  8027c4:	75 07                	jne    8027cd <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027cb:	eb 10                	jmp    8027dd <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8027cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027d5:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8027d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027dd:	c9                   	leaveq 
  8027de:	c3                   	retq   

00000000008027df <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8027df:	55                   	push   %rbp
  8027e0:	48 89 e5             	mov    %rsp,%rbp
  8027e3:	48 83 ec 30          	sub    $0x30,%rsp
  8027e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027eb:	89 f0                	mov    %esi,%eax
  8027ed:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8027f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f4:	48 89 c7             	mov    %rax,%rdi
  8027f7:	48 b8 69 26 80 00 00 	movabs $0x802669,%rax
  8027fe:	00 00 00 
  802801:	ff d0                	callq  *%rax
  802803:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802807:	48 89 d6             	mov    %rdx,%rsi
  80280a:	89 c7                	mov    %eax,%edi
  80280c:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802813:	00 00 00 
  802816:	ff d0                	callq  *%rax
  802818:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281f:	78 0a                	js     80282b <fd_close+0x4c>
	    || fd != fd2)
  802821:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802825:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802829:	74 12                	je     80283d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80282b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80282f:	74 05                	je     802836 <fd_close+0x57>
  802831:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802834:	eb 05                	jmp    80283b <fd_close+0x5c>
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
  80283b:	eb 69                	jmp    8028a6 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80283d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802841:	8b 00                	mov    (%rax),%eax
  802843:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802847:	48 89 d6             	mov    %rdx,%rsi
  80284a:	89 c7                	mov    %eax,%edi
  80284c:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  802853:	00 00 00 
  802856:	ff d0                	callq  *%rax
  802858:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285f:	78 2a                	js     80288b <fd_close+0xac>
		if (dev->dev_close)
  802861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802865:	48 8b 40 20          	mov    0x20(%rax),%rax
  802869:	48 85 c0             	test   %rax,%rax
  80286c:	74 16                	je     802884 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80286e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802872:	48 8b 40 20          	mov    0x20(%rax),%rax
  802876:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80287a:	48 89 d7             	mov    %rdx,%rdi
  80287d:	ff d0                	callq  *%rax
  80287f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802882:	eb 07                	jmp    80288b <fd_close+0xac>
		else
			r = 0;
  802884:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80288b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80288f:	48 89 c6             	mov    %rax,%rsi
  802892:	bf 00 00 00 00       	mov    $0x0,%edi
  802897:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  80289e:	00 00 00 
  8028a1:	ff d0                	callq  *%rax
	return r;
  8028a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028a6:	c9                   	leaveq 
  8028a7:	c3                   	retq   

00000000008028a8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8028a8:	55                   	push   %rbp
  8028a9:	48 89 e5             	mov    %rsp,%rbp
  8028ac:	48 83 ec 20          	sub    $0x20,%rsp
  8028b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8028b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028be:	eb 41                	jmp    802901 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8028c0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8028c7:	00 00 00 
  8028ca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028cd:	48 63 d2             	movslq %edx,%rdx
  8028d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028d4:	8b 00                	mov    (%rax),%eax
  8028d6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8028d9:	75 22                	jne    8028fd <dev_lookup+0x55>
			*dev = devtab[i];
  8028db:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8028e2:	00 00 00 
  8028e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028e8:	48 63 d2             	movslq %edx,%rdx
  8028eb:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8028ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8028f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fb:	eb 60                	jmp    80295d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8028fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802901:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802908:	00 00 00 
  80290b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80290e:	48 63 d2             	movslq %edx,%rdx
  802911:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802915:	48 85 c0             	test   %rax,%rax
  802918:	75 a6                	jne    8028c0 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80291a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802921:	00 00 00 
  802924:	48 8b 00             	mov    (%rax),%rax
  802927:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80292d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802930:	89 c6                	mov    %eax,%esi
  802932:	48 bf f8 46 80 00 00 	movabs $0x8046f8,%rdi
  802939:	00 00 00 
  80293c:	b8 00 00 00 00       	mov    $0x0,%eax
  802941:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  802948:	00 00 00 
  80294b:	ff d1                	callq  *%rcx
	*dev = 0;
  80294d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802951:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802958:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80295d:	c9                   	leaveq 
  80295e:	c3                   	retq   

000000000080295f <close>:

int
close(int fdnum)
{
  80295f:	55                   	push   %rbp
  802960:	48 89 e5             	mov    %rsp,%rbp
  802963:	48 83 ec 20          	sub    $0x20,%rsp
  802967:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80296a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80296e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802971:	48 89 d6             	mov    %rdx,%rsi
  802974:	89 c7                	mov    %eax,%edi
  802976:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  80297d:	00 00 00 
  802980:	ff d0                	callq  *%rax
  802982:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802985:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802989:	79 05                	jns    802990 <close+0x31>
		return r;
  80298b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80298e:	eb 18                	jmp    8029a8 <close+0x49>
	else
		return fd_close(fd, 1);
  802990:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802994:	be 01 00 00 00       	mov    $0x1,%esi
  802999:	48 89 c7             	mov    %rax,%rdi
  80299c:	48 b8 df 27 80 00 00 	movabs $0x8027df,%rax
  8029a3:	00 00 00 
  8029a6:	ff d0                	callq  *%rax
}
  8029a8:	c9                   	leaveq 
  8029a9:	c3                   	retq   

00000000008029aa <close_all>:

void
close_all(void)
{
  8029aa:	55                   	push   %rbp
  8029ab:	48 89 e5             	mov    %rsp,%rbp
  8029ae:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8029b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029b9:	eb 15                	jmp    8029d0 <close_all+0x26>
		close(i);
  8029bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029be:	89 c7                	mov    %eax,%edi
  8029c0:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  8029c7:	00 00 00 
  8029ca:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8029cc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029d0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8029d4:	7e e5                	jle    8029bb <close_all+0x11>
		close(i);
}
  8029d6:	c9                   	leaveq 
  8029d7:	c3                   	retq   

00000000008029d8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8029d8:	55                   	push   %rbp
  8029d9:	48 89 e5             	mov    %rsp,%rbp
  8029dc:	48 83 ec 40          	sub    $0x40,%rsp
  8029e0:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8029e3:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8029e6:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8029ea:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8029ed:	48 89 d6             	mov    %rdx,%rsi
  8029f0:	89 c7                	mov    %eax,%edi
  8029f2:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  8029f9:	00 00 00 
  8029fc:	ff d0                	callq  *%rax
  8029fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a05:	79 08                	jns    802a0f <dup+0x37>
		return r;
  802a07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0a:	e9 70 01 00 00       	jmpq   802b7f <dup+0x1a7>
	close(newfdnum);
  802a0f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a12:	89 c7                	mov    %eax,%edi
  802a14:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  802a1b:	00 00 00 
  802a1e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a20:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a23:	48 98                	cltq   
  802a25:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a2b:	48 c1 e0 0c          	shl    $0xc,%rax
  802a2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a37:	48 89 c7             	mov    %rax,%rdi
  802a3a:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  802a41:	00 00 00 
  802a44:	ff d0                	callq  *%rax
  802a46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802a4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4e:	48 89 c7             	mov    %rax,%rdi
  802a51:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  802a58:	00 00 00 
  802a5b:	ff d0                	callq  *%rax
  802a5d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a65:	48 c1 e8 15          	shr    $0x15,%rax
  802a69:	48 89 c2             	mov    %rax,%rdx
  802a6c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a73:	01 00 00 
  802a76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a7a:	83 e0 01             	and    $0x1,%eax
  802a7d:	48 85 c0             	test   %rax,%rax
  802a80:	74 73                	je     802af5 <dup+0x11d>
  802a82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a86:	48 c1 e8 0c          	shr    $0xc,%rax
  802a8a:	48 89 c2             	mov    %rax,%rdx
  802a8d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a94:	01 00 00 
  802a97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a9b:	83 e0 01             	and    $0x1,%eax
  802a9e:	48 85 c0             	test   %rax,%rax
  802aa1:	74 52                	je     802af5 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802aa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa7:	48 c1 e8 0c          	shr    $0xc,%rax
  802aab:	48 89 c2             	mov    %rax,%rdx
  802aae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ab5:	01 00 00 
  802ab8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802abc:	25 07 0e 00 00       	and    $0xe07,%eax
  802ac1:	89 c1                	mov    %eax,%ecx
  802ac3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ac7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acb:	41 89 c8             	mov    %ecx,%r8d
  802ace:	48 89 d1             	mov    %rdx,%rcx
  802ad1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad6:	48 89 c6             	mov    %rax,%rsi
  802ad9:	bf 00 00 00 00       	mov    $0x0,%edi
  802ade:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	callq  *%rax
  802aea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af1:	79 02                	jns    802af5 <dup+0x11d>
			goto err;
  802af3:	eb 57                	jmp    802b4c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802af9:	48 c1 e8 0c          	shr    $0xc,%rax
  802afd:	48 89 c2             	mov    %rax,%rdx
  802b00:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b07:	01 00 00 
  802b0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b0e:	25 07 0e 00 00       	and    $0xe07,%eax
  802b13:	89 c1                	mov    %eax,%ecx
  802b15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b19:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b1d:	41 89 c8             	mov    %ecx,%r8d
  802b20:	48 89 d1             	mov    %rdx,%rcx
  802b23:	ba 00 00 00 00       	mov    $0x0,%edx
  802b28:	48 89 c6             	mov    %rax,%rsi
  802b2b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b30:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  802b37:	00 00 00 
  802b3a:	ff d0                	callq  *%rax
  802b3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b43:	79 02                	jns    802b47 <dup+0x16f>
		goto err;
  802b45:	eb 05                	jmp    802b4c <dup+0x174>

	return newfdnum;
  802b47:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b4a:	eb 33                	jmp    802b7f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802b4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b50:	48 89 c6             	mov    %rax,%rsi
  802b53:	bf 00 00 00 00       	mov    $0x0,%edi
  802b58:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  802b5f:	00 00 00 
  802b62:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802b64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b68:	48 89 c6             	mov    %rax,%rsi
  802b6b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b70:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  802b77:	00 00 00 
  802b7a:	ff d0                	callq  *%rax
	return r;
  802b7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b7f:	c9                   	leaveq 
  802b80:	c3                   	retq   

0000000000802b81 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b81:	55                   	push   %rbp
  802b82:	48 89 e5             	mov    %rsp,%rbp
  802b85:	48 83 ec 40          	sub    $0x40,%rsp
  802b89:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b8c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b90:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b94:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b98:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b9b:	48 89 d6             	mov    %rdx,%rsi
  802b9e:	89 c7                	mov    %eax,%edi
  802ba0:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802ba7:	00 00 00 
  802baa:	ff d0                	callq  *%rax
  802bac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802baf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb3:	78 24                	js     802bd9 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb9:	8b 00                	mov    (%rax),%eax
  802bbb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bbf:	48 89 d6             	mov    %rdx,%rsi
  802bc2:	89 c7                	mov    %eax,%edi
  802bc4:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  802bcb:	00 00 00 
  802bce:	ff d0                	callq  *%rax
  802bd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd7:	79 05                	jns    802bde <read+0x5d>
		return r;
  802bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdc:	eb 76                	jmp    802c54 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802bde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be2:	8b 40 08             	mov    0x8(%rax),%eax
  802be5:	83 e0 03             	and    $0x3,%eax
  802be8:	83 f8 01             	cmp    $0x1,%eax
  802beb:	75 3a                	jne    802c27 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802bed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802bf4:	00 00 00 
  802bf7:	48 8b 00             	mov    (%rax),%rax
  802bfa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c00:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c03:	89 c6                	mov    %eax,%esi
  802c05:	48 bf 17 47 80 00 00 	movabs $0x804717,%rdi
  802c0c:	00 00 00 
  802c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c14:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  802c1b:	00 00 00 
  802c1e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c25:	eb 2d                	jmp    802c54 <read+0xd3>
	}
	if (!dev->dev_read)
  802c27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c2b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c2f:	48 85 c0             	test   %rax,%rax
  802c32:	75 07                	jne    802c3b <read+0xba>
		return -E_NOT_SUPP;
  802c34:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c39:	eb 19                	jmp    802c54 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c43:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c4b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c4f:	48 89 cf             	mov    %rcx,%rdi
  802c52:	ff d0                	callq  *%rax
}
  802c54:	c9                   	leaveq 
  802c55:	c3                   	retq   

0000000000802c56 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c56:	55                   	push   %rbp
  802c57:	48 89 e5             	mov    %rsp,%rbp
  802c5a:	48 83 ec 30          	sub    $0x30,%rsp
  802c5e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c65:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c70:	eb 49                	jmp    802cbb <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c75:	48 98                	cltq   
  802c77:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c7b:	48 29 c2             	sub    %rax,%rdx
  802c7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c81:	48 63 c8             	movslq %eax,%rcx
  802c84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c88:	48 01 c1             	add    %rax,%rcx
  802c8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c8e:	48 89 ce             	mov    %rcx,%rsi
  802c91:	89 c7                	mov    %eax,%edi
  802c93:	48 b8 81 2b 80 00 00 	movabs $0x802b81,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	callq  *%rax
  802c9f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ca2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ca6:	79 05                	jns    802cad <readn+0x57>
			return m;
  802ca8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cab:	eb 1c                	jmp    802cc9 <readn+0x73>
		if (m == 0)
  802cad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cb1:	75 02                	jne    802cb5 <readn+0x5f>
			break;
  802cb3:	eb 11                	jmp    802cc6 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cb5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cb8:	01 45 fc             	add    %eax,-0x4(%rbp)
  802cbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cbe:	48 98                	cltq   
  802cc0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802cc4:	72 ac                	jb     802c72 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802cc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cc9:	c9                   	leaveq 
  802cca:	c3                   	retq   

0000000000802ccb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ccb:	55                   	push   %rbp
  802ccc:	48 89 e5             	mov    %rsp,%rbp
  802ccf:	48 83 ec 40          	sub    $0x40,%rsp
  802cd3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cd6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cda:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cde:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ce2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ce5:	48 89 d6             	mov    %rdx,%rsi
  802ce8:	89 c7                	mov    %eax,%edi
  802cea:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802cf1:	00 00 00 
  802cf4:	ff d0                	callq  *%rax
  802cf6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cfd:	78 24                	js     802d23 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d03:	8b 00                	mov    (%rax),%eax
  802d05:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d09:	48 89 d6             	mov    %rdx,%rsi
  802d0c:	89 c7                	mov    %eax,%edi
  802d0e:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  802d15:	00 00 00 
  802d18:	ff d0                	callq  *%rax
  802d1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d21:	79 05                	jns    802d28 <write+0x5d>
		return r;
  802d23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d26:	eb 42                	jmp    802d6a <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2c:	8b 40 08             	mov    0x8(%rax),%eax
  802d2f:	83 e0 03             	and    $0x3,%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	75 07                	jne    802d3d <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802d36:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d3b:	eb 2d                	jmp    802d6a <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d41:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d45:	48 85 c0             	test   %rax,%rax
  802d48:	75 07                	jne    802d51 <write+0x86>
		return -E_NOT_SUPP;
  802d4a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d4f:	eb 19                	jmp    802d6a <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802d51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d55:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d59:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d5d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d61:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d65:	48 89 cf             	mov    %rcx,%rdi
  802d68:	ff d0                	callq  *%rax
}
  802d6a:	c9                   	leaveq 
  802d6b:	c3                   	retq   

0000000000802d6c <seek>:

int
seek(int fdnum, off_t offset)
{
  802d6c:	55                   	push   %rbp
  802d6d:	48 89 e5             	mov    %rsp,%rbp
  802d70:	48 83 ec 18          	sub    $0x18,%rsp
  802d74:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d77:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d7a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d81:	48 89 d6             	mov    %rdx,%rsi
  802d84:	89 c7                	mov    %eax,%edi
  802d86:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802d8d:	00 00 00 
  802d90:	ff d0                	callq  *%rax
  802d92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d99:	79 05                	jns    802da0 <seek+0x34>
		return r;
  802d9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9e:	eb 0f                	jmp    802daf <seek+0x43>
	fd->fd_offset = offset;
  802da0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802da7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802daa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802daf:	c9                   	leaveq 
  802db0:	c3                   	retq   

0000000000802db1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802db1:	55                   	push   %rbp
  802db2:	48 89 e5             	mov    %rsp,%rbp
  802db5:	48 83 ec 30          	sub    $0x30,%rsp
  802db9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dbc:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dbf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dc3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dc6:	48 89 d6             	mov    %rdx,%rsi
  802dc9:	89 c7                	mov    %eax,%edi
  802dcb:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802dd2:	00 00 00 
  802dd5:	ff d0                	callq  *%rax
  802dd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dde:	78 24                	js     802e04 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802de4:	8b 00                	mov    (%rax),%eax
  802de6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dea:	48 89 d6             	mov    %rdx,%rsi
  802ded:	89 c7                	mov    %eax,%edi
  802def:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  802df6:	00 00 00 
  802df9:	ff d0                	callq  *%rax
  802dfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e02:	79 05                	jns    802e09 <ftruncate+0x58>
		return r;
  802e04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e07:	eb 72                	jmp    802e7b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0d:	8b 40 08             	mov    0x8(%rax),%eax
  802e10:	83 e0 03             	and    $0x3,%eax
  802e13:	85 c0                	test   %eax,%eax
  802e15:	75 3a                	jne    802e51 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e17:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e1e:	00 00 00 
  802e21:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e24:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e2a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e2d:	89 c6                	mov    %eax,%esi
  802e2f:	48 bf 38 47 80 00 00 	movabs $0x804738,%rdi
  802e36:	00 00 00 
  802e39:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3e:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  802e45:	00 00 00 
  802e48:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e4f:	eb 2a                	jmp    802e7b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e55:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e59:	48 85 c0             	test   %rax,%rax
  802e5c:	75 07                	jne    802e65 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e5e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e63:	eb 16                	jmp    802e7b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e69:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e6d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e71:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e74:	89 ce                	mov    %ecx,%esi
  802e76:	48 89 d7             	mov    %rdx,%rdi
  802e79:	ff d0                	callq  *%rax
}
  802e7b:	c9                   	leaveq 
  802e7c:	c3                   	retq   

0000000000802e7d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e7d:	55                   	push   %rbp
  802e7e:	48 89 e5             	mov    %rsp,%rbp
  802e81:	48 83 ec 30          	sub    $0x30,%rsp
  802e85:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e88:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e8c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e90:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e93:	48 89 d6             	mov    %rdx,%rsi
  802e96:	89 c7                	mov    %eax,%edi
  802e98:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802e9f:	00 00 00 
  802ea2:	ff d0                	callq  *%rax
  802ea4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eab:	78 24                	js     802ed1 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ead:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb1:	8b 00                	mov    (%rax),%eax
  802eb3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802eb7:	48 89 d6             	mov    %rdx,%rsi
  802eba:	89 c7                	mov    %eax,%edi
  802ebc:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
  802ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ecb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ecf:	79 05                	jns    802ed6 <fstat+0x59>
		return r;
  802ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed4:	eb 5e                	jmp    802f34 <fstat+0xb7>
	if (!dev->dev_stat)
  802ed6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eda:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ede:	48 85 c0             	test   %rax,%rax
  802ee1:	75 07                	jne    802eea <fstat+0x6d>
		return -E_NOT_SUPP;
  802ee3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ee8:	eb 4a                	jmp    802f34 <fstat+0xb7>
	stat->st_name[0] = 0;
  802eea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eee:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802ef1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ef5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802efc:	00 00 00 
	stat->st_isdir = 0;
  802eff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f03:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f0a:	00 00 00 
	stat->st_dev = dev;
  802f0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f15:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f20:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f24:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f28:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f2c:	48 89 ce             	mov    %rcx,%rsi
  802f2f:	48 89 d7             	mov    %rdx,%rdi
  802f32:	ff d0                	callq  *%rax
}
  802f34:	c9                   	leaveq 
  802f35:	c3                   	retq   

0000000000802f36 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f36:	55                   	push   %rbp
  802f37:	48 89 e5             	mov    %rsp,%rbp
  802f3a:	48 83 ec 20          	sub    $0x20,%rsp
  802f3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4a:	be 00 00 00 00       	mov    $0x0,%esi
  802f4f:	48 89 c7             	mov    %rax,%rdi
  802f52:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  802f59:	00 00 00 
  802f5c:	ff d0                	callq  *%rax
  802f5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f65:	79 05                	jns    802f6c <stat+0x36>
		return fd;
  802f67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f6a:	eb 2f                	jmp    802f9b <stat+0x65>
	r = fstat(fd, stat);
  802f6c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f73:	48 89 d6             	mov    %rdx,%rsi
  802f76:	89 c7                	mov    %eax,%edi
  802f78:	48 b8 7d 2e 80 00 00 	movabs $0x802e7d,%rax
  802f7f:	00 00 00 
  802f82:	ff d0                	callq  *%rax
  802f84:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8a:	89 c7                	mov    %eax,%edi
  802f8c:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  802f93:	00 00 00 
  802f96:	ff d0                	callq  *%rax
	return r;
  802f98:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f9b:	c9                   	leaveq 
  802f9c:	c3                   	retq   

0000000000802f9d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f9d:	55                   	push   %rbp
  802f9e:	48 89 e5             	mov    %rsp,%rbp
  802fa1:	48 83 ec 10          	sub    $0x10,%rsp
  802fa5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fa8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802fac:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fb3:	00 00 00 
  802fb6:	8b 00                	mov    (%rax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	75 1d                	jne    802fd9 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802fbc:	bf 01 00 00 00       	mov    $0x1,%edi
  802fc1:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
  802fcd:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802fd4:	00 00 00 
  802fd7:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802fd9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fe0:	00 00 00 
  802fe3:	8b 00                	mov    (%rax),%eax
  802fe5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802fe8:	b9 07 00 00 00       	mov    $0x7,%ecx
  802fed:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802ff4:	00 00 00 
  802ff7:	89 c7                	mov    %eax,%edi
  802ff9:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  803000:	00 00 00 
  803003:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803005:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803009:	ba 00 00 00 00       	mov    $0x0,%edx
  80300e:	48 89 c6             	mov    %rax,%rsi
  803011:	bf 00 00 00 00       	mov    $0x0,%edi
  803016:	48 b8 71 24 80 00 00 	movabs $0x802471,%rax
  80301d:	00 00 00 
  803020:	ff d0                	callq  *%rax
}
  803022:	c9                   	leaveq 
  803023:	c3                   	retq   

0000000000803024 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803024:	55                   	push   %rbp
  803025:	48 89 e5             	mov    %rsp,%rbp
  803028:	48 83 ec 30          	sub    $0x30,%rsp
  80302c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803030:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  803033:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80303a:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  803041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  803048:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80304d:	75 08                	jne    803057 <open+0x33>
	{
		return r;
  80304f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803052:	e9 f2 00 00 00       	jmpq   803149 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  803057:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80305b:	48 89 c7             	mov    %rax,%rdi
  80305e:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  803065:	00 00 00 
  803068:	ff d0                	callq  *%rax
  80306a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80306d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  803074:	7e 0a                	jle    803080 <open+0x5c>
	{
		return -E_BAD_PATH;
  803076:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80307b:	e9 c9 00 00 00       	jmpq   803149 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  803080:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803087:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803088:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80308c:	48 89 c7             	mov    %rax,%rdi
  80308f:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  803096:	00 00 00 
  803099:	ff d0                	callq  *%rax
  80309b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80309e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a2:	78 09                	js     8030ad <open+0x89>
  8030a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a8:	48 85 c0             	test   %rax,%rax
  8030ab:	75 08                	jne    8030b5 <open+0x91>
		{
			return r;
  8030ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b0:	e9 94 00 00 00       	jmpq   803149 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8030b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b9:	ba 00 04 00 00       	mov    $0x400,%edx
  8030be:	48 89 c6             	mov    %rax,%rsi
  8030c1:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8030c8:	00 00 00 
  8030cb:	48 b8 f4 10 80 00 00 	movabs $0x8010f4,%rax
  8030d2:	00 00 00 
  8030d5:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8030d7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030de:	00 00 00 
  8030e1:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8030e4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8030ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ee:	48 89 c6             	mov    %rax,%rsi
  8030f1:	bf 01 00 00 00       	mov    $0x1,%edi
  8030f6:	48 b8 9d 2f 80 00 00 	movabs $0x802f9d,%rax
  8030fd:	00 00 00 
  803100:	ff d0                	callq  *%rax
  803102:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803105:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803109:	79 2b                	jns    803136 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80310b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310f:	be 00 00 00 00       	mov    $0x0,%esi
  803114:	48 89 c7             	mov    %rax,%rdi
  803117:	48 b8 df 27 80 00 00 	movabs $0x8027df,%rax
  80311e:	00 00 00 
  803121:	ff d0                	callq  *%rax
  803123:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803126:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80312a:	79 05                	jns    803131 <open+0x10d>
			{
				return d;
  80312c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80312f:	eb 18                	jmp    803149 <open+0x125>
			}
			return r;
  803131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803134:	eb 13                	jmp    803149 <open+0x125>
		}	
		return fd2num(fd_store);
  803136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313a:	48 89 c7             	mov    %rax,%rdi
  80313d:	48 b8 69 26 80 00 00 	movabs $0x802669,%rax
  803144:	00 00 00 
  803147:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803149:	c9                   	leaveq 
  80314a:	c3                   	retq   

000000000080314b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80314b:	55                   	push   %rbp
  80314c:	48 89 e5             	mov    %rsp,%rbp
  80314f:	48 83 ec 10          	sub    $0x10,%rsp
  803153:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803157:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80315b:	8b 50 0c             	mov    0xc(%rax),%edx
  80315e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803165:	00 00 00 
  803168:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80316a:	be 00 00 00 00       	mov    $0x0,%esi
  80316f:	bf 06 00 00 00       	mov    $0x6,%edi
  803174:	48 b8 9d 2f 80 00 00 	movabs $0x802f9d,%rax
  80317b:	00 00 00 
  80317e:	ff d0                	callq  *%rax
}
  803180:	c9                   	leaveq 
  803181:	c3                   	retq   

0000000000803182 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803182:	55                   	push   %rbp
  803183:	48 89 e5             	mov    %rsp,%rbp
  803186:	48 83 ec 30          	sub    $0x30,%rsp
  80318a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80318e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803192:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803196:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80319d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031a2:	74 07                	je     8031ab <devfile_read+0x29>
  8031a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031a9:	75 07                	jne    8031b2 <devfile_read+0x30>
		return -E_INVAL;
  8031ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031b0:	eb 77                	jmp    803229 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8031b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b6:	8b 50 0c             	mov    0xc(%rax),%edx
  8031b9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031c0:	00 00 00 
  8031c3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8031c5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031cc:	00 00 00 
  8031cf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031d3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8031d7:	be 00 00 00 00       	mov    $0x0,%esi
  8031dc:	bf 03 00 00 00       	mov    $0x3,%edi
  8031e1:	48 b8 9d 2f 80 00 00 	movabs $0x802f9d,%rax
  8031e8:	00 00 00 
  8031eb:	ff d0                	callq  *%rax
  8031ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f4:	7f 05                	jg     8031fb <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8031f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f9:	eb 2e                	jmp    803229 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8031fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fe:	48 63 d0             	movslq %eax,%rdx
  803201:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803205:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80320c:	00 00 00 
  80320f:	48 89 c7             	mov    %rax,%rdi
  803212:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  803219:	00 00 00 
  80321c:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80321e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803222:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803226:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803229:	c9                   	leaveq 
  80322a:	c3                   	retq   

000000000080322b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80322b:	55                   	push   %rbp
  80322c:	48 89 e5             	mov    %rsp,%rbp
  80322f:	48 83 ec 30          	sub    $0x30,%rsp
  803233:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803237:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80323b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80323f:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803246:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80324b:	74 07                	je     803254 <devfile_write+0x29>
  80324d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803252:	75 08                	jne    80325c <devfile_write+0x31>
		return r;
  803254:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803257:	e9 9a 00 00 00       	jmpq   8032f6 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80325c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803260:	8b 50 0c             	mov    0xc(%rax),%edx
  803263:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80326a:	00 00 00 
  80326d:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80326f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803276:	00 
  803277:	76 08                	jbe    803281 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803279:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803280:	00 
	}
	fsipcbuf.write.req_n = n;
  803281:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803288:	00 00 00 
  80328b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80328f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803293:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803297:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80329b:	48 89 c6             	mov    %rax,%rsi
  80329e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8032a5:	00 00 00 
  8032a8:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  8032af:	00 00 00 
  8032b2:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8032b4:	be 00 00 00 00       	mov    $0x0,%esi
  8032b9:	bf 04 00 00 00       	mov    $0x4,%edi
  8032be:	48 b8 9d 2f 80 00 00 	movabs $0x802f9d,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
  8032ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d1:	7f 20                	jg     8032f3 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8032d3:	48 bf 5e 47 80 00 00 	movabs $0x80475e,%rdi
  8032da:	00 00 00 
  8032dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e2:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  8032e9:	00 00 00 
  8032ec:	ff d2                	callq  *%rdx
		return r;
  8032ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f1:	eb 03                	jmp    8032f6 <devfile_write+0xcb>
	}
	return r;
  8032f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8032f6:	c9                   	leaveq 
  8032f7:	c3                   	retq   

00000000008032f8 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8032f8:	55                   	push   %rbp
  8032f9:	48 89 e5             	mov    %rsp,%rbp
  8032fc:	48 83 ec 20          	sub    $0x20,%rsp
  803300:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803304:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80330c:	8b 50 0c             	mov    0xc(%rax),%edx
  80330f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803316:	00 00 00 
  803319:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80331b:	be 00 00 00 00       	mov    $0x0,%esi
  803320:	bf 05 00 00 00       	mov    $0x5,%edi
  803325:	48 b8 9d 2f 80 00 00 	movabs $0x802f9d,%rax
  80332c:	00 00 00 
  80332f:	ff d0                	callq  *%rax
  803331:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803334:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803338:	79 05                	jns    80333f <devfile_stat+0x47>
		return r;
  80333a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333d:	eb 56                	jmp    803395 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80333f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803343:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80334a:	00 00 00 
  80334d:	48 89 c7             	mov    %rax,%rdi
  803350:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  803357:	00 00 00 
  80335a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80335c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803363:	00 00 00 
  803366:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80336c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803370:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803376:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80337d:	00 00 00 
  803380:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803386:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80338a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803390:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803395:	c9                   	leaveq 
  803396:	c3                   	retq   

0000000000803397 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803397:	55                   	push   %rbp
  803398:	48 89 e5             	mov    %rsp,%rbp
  80339b:	48 83 ec 10          	sub    $0x10,%rsp
  80339f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033a3:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033aa:	8b 50 0c             	mov    0xc(%rax),%edx
  8033ad:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033b4:	00 00 00 
  8033b7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8033b9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033c0:	00 00 00 
  8033c3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8033c6:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8033c9:	be 00 00 00 00       	mov    $0x0,%esi
  8033ce:	bf 02 00 00 00       	mov    $0x2,%edi
  8033d3:	48 b8 9d 2f 80 00 00 	movabs $0x802f9d,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
}
  8033df:	c9                   	leaveq 
  8033e0:	c3                   	retq   

00000000008033e1 <remove>:

// Delete a file
int
remove(const char *path)
{
  8033e1:	55                   	push   %rbp
  8033e2:	48 89 e5             	mov    %rsp,%rbp
  8033e5:	48 83 ec 10          	sub    $0x10,%rsp
  8033e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8033ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f1:	48 89 c7             	mov    %rax,%rdi
  8033f4:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  8033fb:	00 00 00 
  8033fe:	ff d0                	callq  *%rax
  803400:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803405:	7e 07                	jle    80340e <remove+0x2d>
		return -E_BAD_PATH;
  803407:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80340c:	eb 33                	jmp    803441 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80340e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803412:	48 89 c6             	mov    %rax,%rsi
  803415:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80341c:	00 00 00 
  80341f:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  803426:	00 00 00 
  803429:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80342b:	be 00 00 00 00       	mov    $0x0,%esi
  803430:	bf 07 00 00 00       	mov    $0x7,%edi
  803435:	48 b8 9d 2f 80 00 00 	movabs $0x802f9d,%rax
  80343c:	00 00 00 
  80343f:	ff d0                	callq  *%rax
}
  803441:	c9                   	leaveq 
  803442:	c3                   	retq   

0000000000803443 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803443:	55                   	push   %rbp
  803444:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803447:	be 00 00 00 00       	mov    $0x0,%esi
  80344c:	bf 08 00 00 00       	mov    $0x8,%edi
  803451:	48 b8 9d 2f 80 00 00 	movabs $0x802f9d,%rax
  803458:	00 00 00 
  80345b:	ff d0                	callq  *%rax
}
  80345d:	5d                   	pop    %rbp
  80345e:	c3                   	retq   

000000000080345f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80345f:	55                   	push   %rbp
  803460:	48 89 e5             	mov    %rsp,%rbp
  803463:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80346a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803471:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803478:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80347f:	be 00 00 00 00       	mov    $0x0,%esi
  803484:	48 89 c7             	mov    %rax,%rdi
  803487:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  80348e:	00 00 00 
  803491:	ff d0                	callq  *%rax
  803493:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803496:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80349a:	79 28                	jns    8034c4 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80349c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349f:	89 c6                	mov    %eax,%esi
  8034a1:	48 bf 7a 47 80 00 00 	movabs $0x80477a,%rdi
  8034a8:	00 00 00 
  8034ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b0:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  8034b7:	00 00 00 
  8034ba:	ff d2                	callq  *%rdx
		return fd_src;
  8034bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034bf:	e9 74 01 00 00       	jmpq   803638 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8034c4:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8034cb:	be 01 01 00 00       	mov    $0x101,%esi
  8034d0:	48 89 c7             	mov    %rax,%rdi
  8034d3:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
  8034df:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8034e2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034e6:	79 39                	jns    803521 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8034e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034eb:	89 c6                	mov    %eax,%esi
  8034ed:	48 bf 90 47 80 00 00 	movabs $0x804790,%rdi
  8034f4:	00 00 00 
  8034f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fc:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  803503:	00 00 00 
  803506:	ff d2                	callq  *%rdx
		close(fd_src);
  803508:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350b:	89 c7                	mov    %eax,%edi
  80350d:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  803514:	00 00 00 
  803517:	ff d0                	callq  *%rax
		return fd_dest;
  803519:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80351c:	e9 17 01 00 00       	jmpq   803638 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803521:	eb 74                	jmp    803597 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803523:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803526:	48 63 d0             	movslq %eax,%rdx
  803529:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803530:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803533:	48 89 ce             	mov    %rcx,%rsi
  803536:	89 c7                	mov    %eax,%edi
  803538:	48 b8 cb 2c 80 00 00 	movabs $0x802ccb,%rax
  80353f:	00 00 00 
  803542:	ff d0                	callq  *%rax
  803544:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803547:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80354b:	79 4a                	jns    803597 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80354d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803550:	89 c6                	mov    %eax,%esi
  803552:	48 bf aa 47 80 00 00 	movabs $0x8047aa,%rdi
  803559:	00 00 00 
  80355c:	b8 00 00 00 00       	mov    $0x0,%eax
  803561:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  803568:	00 00 00 
  80356b:	ff d2                	callq  *%rdx
			close(fd_src);
  80356d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803570:	89 c7                	mov    %eax,%edi
  803572:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  803579:	00 00 00 
  80357c:	ff d0                	callq  *%rax
			close(fd_dest);
  80357e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803581:	89 c7                	mov    %eax,%edi
  803583:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  80358a:	00 00 00 
  80358d:	ff d0                	callq  *%rax
			return write_size;
  80358f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803592:	e9 a1 00 00 00       	jmpq   803638 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803597:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80359e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a1:	ba 00 02 00 00       	mov    $0x200,%edx
  8035a6:	48 89 ce             	mov    %rcx,%rsi
  8035a9:	89 c7                	mov    %eax,%edi
  8035ab:	48 b8 81 2b 80 00 00 	movabs $0x802b81,%rax
  8035b2:	00 00 00 
  8035b5:	ff d0                	callq  *%rax
  8035b7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8035ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8035be:	0f 8f 5f ff ff ff    	jg     803523 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8035c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8035c8:	79 47                	jns    803611 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8035ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035cd:	89 c6                	mov    %eax,%esi
  8035cf:	48 bf bd 47 80 00 00 	movabs $0x8047bd,%rdi
  8035d6:	00 00 00 
  8035d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035de:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  8035e5:	00 00 00 
  8035e8:	ff d2                	callq  *%rdx
		close(fd_src);
  8035ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ed:	89 c7                	mov    %eax,%edi
  8035ef:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  8035f6:	00 00 00 
  8035f9:	ff d0                	callq  *%rax
		close(fd_dest);
  8035fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035fe:	89 c7                	mov    %eax,%edi
  803600:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  803607:	00 00 00 
  80360a:	ff d0                	callq  *%rax
		return read_size;
  80360c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80360f:	eb 27                	jmp    803638 <copy+0x1d9>
	}
	close(fd_src);
  803611:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803614:	89 c7                	mov    %eax,%edi
  803616:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  80361d:	00 00 00 
  803620:	ff d0                	callq  *%rax
	close(fd_dest);
  803622:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803625:	89 c7                	mov    %eax,%edi
  803627:	48 b8 5f 29 80 00 00 	movabs $0x80295f,%rax
  80362e:	00 00 00 
  803631:	ff d0                	callq  *%rax
	return 0;
  803633:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803638:	c9                   	leaveq 
  803639:	c3                   	retq   

000000000080363a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80363a:	55                   	push   %rbp
  80363b:	48 89 e5             	mov    %rsp,%rbp
  80363e:	53                   	push   %rbx
  80363f:	48 83 ec 38          	sub    $0x38,%rsp
  803643:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803647:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80364b:	48 89 c7             	mov    %rax,%rdi
  80364e:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  803655:	00 00 00 
  803658:	ff d0                	callq  *%rax
  80365a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80365d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803661:	0f 88 bf 01 00 00    	js     803826 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80366b:	ba 07 04 00 00       	mov    $0x407,%edx
  803670:	48 89 c6             	mov    %rax,%rsi
  803673:	bf 00 00 00 00       	mov    $0x0,%edi
  803678:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  80367f:	00 00 00 
  803682:	ff d0                	callq  *%rax
  803684:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803687:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80368b:	0f 88 95 01 00 00    	js     803826 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803691:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803695:	48 89 c7             	mov    %rax,%rdi
  803698:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  80369f:	00 00 00 
  8036a2:	ff d0                	callq  *%rax
  8036a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036ab:	0f 88 5d 01 00 00    	js     80380e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036b5:	ba 07 04 00 00       	mov    $0x407,%edx
  8036ba:	48 89 c6             	mov    %rax,%rsi
  8036bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c2:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  8036c9:	00 00 00 
  8036cc:	ff d0                	callq  *%rax
  8036ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036d5:	0f 88 33 01 00 00    	js     80380e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8036db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036df:	48 89 c7             	mov    %rax,%rdi
  8036e2:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  8036e9:	00 00 00 
  8036ec:	ff d0                	callq  *%rax
  8036ee:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036f6:	ba 07 04 00 00       	mov    $0x407,%edx
  8036fb:	48 89 c6             	mov    %rax,%rsi
  8036fe:	bf 00 00 00 00       	mov    $0x0,%edi
  803703:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  80370a:	00 00 00 
  80370d:	ff d0                	callq  *%rax
  80370f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803712:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803716:	79 05                	jns    80371d <pipe+0xe3>
		goto err2;
  803718:	e9 d9 00 00 00       	jmpq   8037f6 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80371d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803721:	48 89 c7             	mov    %rax,%rdi
  803724:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  80372b:	00 00 00 
  80372e:	ff d0                	callq  *%rax
  803730:	48 89 c2             	mov    %rax,%rdx
  803733:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803737:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80373d:	48 89 d1             	mov    %rdx,%rcx
  803740:	ba 00 00 00 00       	mov    $0x0,%edx
  803745:	48 89 c6             	mov    %rax,%rsi
  803748:	bf 00 00 00 00       	mov    $0x0,%edi
  80374d:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  803754:	00 00 00 
  803757:	ff d0                	callq  *%rax
  803759:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80375c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803760:	79 1b                	jns    80377d <pipe+0x143>
		goto err3;
  803762:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803763:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803767:	48 89 c6             	mov    %rax,%rsi
  80376a:	bf 00 00 00 00       	mov    $0x0,%edi
  80376f:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  803776:	00 00 00 
  803779:	ff d0                	callq  *%rax
  80377b:	eb 79                	jmp    8037f6 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80377d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803781:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803788:	00 00 00 
  80378b:	8b 12                	mov    (%rdx),%edx
  80378d:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80378f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803793:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80379a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80379e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037a5:	00 00 00 
  8037a8:	8b 12                	mov    (%rdx),%edx
  8037aa:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8037ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037b0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8037b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037bb:	48 89 c7             	mov    %rax,%rdi
  8037be:	48 b8 69 26 80 00 00 	movabs $0x802669,%rax
  8037c5:	00 00 00 
  8037c8:	ff d0                	callq  *%rax
  8037ca:	89 c2                	mov    %eax,%edx
  8037cc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037d0:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8037d2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037d6:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8037da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037de:	48 89 c7             	mov    %rax,%rdi
  8037e1:	48 b8 69 26 80 00 00 	movabs $0x802669,%rax
  8037e8:	00 00 00 
  8037eb:	ff d0                	callq  *%rax
  8037ed:	89 03                	mov    %eax,(%rbx)
	return 0;
  8037ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f4:	eb 33                	jmp    803829 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8037f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037fa:	48 89 c6             	mov    %rax,%rsi
  8037fd:	bf 00 00 00 00       	mov    $0x0,%edi
  803802:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  803809:	00 00 00 
  80380c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80380e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803812:	48 89 c6             	mov    %rax,%rsi
  803815:	bf 00 00 00 00       	mov    $0x0,%edi
  80381a:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  803821:	00 00 00 
  803824:	ff d0                	callq  *%rax
err:
	return r;
  803826:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803829:	48 83 c4 38          	add    $0x38,%rsp
  80382d:	5b                   	pop    %rbx
  80382e:	5d                   	pop    %rbp
  80382f:	c3                   	retq   

0000000000803830 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803830:	55                   	push   %rbp
  803831:	48 89 e5             	mov    %rsp,%rbp
  803834:	53                   	push   %rbx
  803835:	48 83 ec 28          	sub    $0x28,%rsp
  803839:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80383d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803841:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803848:	00 00 00 
  80384b:	48 8b 00             	mov    (%rax),%rax
  80384e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803854:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80385b:	48 89 c7             	mov    %rax,%rdi
  80385e:	48 b8 f6 3f 80 00 00 	movabs $0x803ff6,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
  80386a:	89 c3                	mov    %eax,%ebx
  80386c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803870:	48 89 c7             	mov    %rax,%rdi
  803873:	48 b8 f6 3f 80 00 00 	movabs $0x803ff6,%rax
  80387a:	00 00 00 
  80387d:	ff d0                	callq  *%rax
  80387f:	39 c3                	cmp    %eax,%ebx
  803881:	0f 94 c0             	sete   %al
  803884:	0f b6 c0             	movzbl %al,%eax
  803887:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80388a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803891:	00 00 00 
  803894:	48 8b 00             	mov    (%rax),%rax
  803897:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80389d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8038a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038a6:	75 05                	jne    8038ad <_pipeisclosed+0x7d>
			return ret;
  8038a8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8038ab:	eb 4f                	jmp    8038fc <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8038ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038b0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038b3:	74 42                	je     8038f7 <_pipeisclosed+0xc7>
  8038b5:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8038b9:	75 3c                	jne    8038f7 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8038bb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038c2:	00 00 00 
  8038c5:	48 8b 00             	mov    (%rax),%rax
  8038c8:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8038ce:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038d4:	89 c6                	mov    %eax,%esi
  8038d6:	48 bf dd 47 80 00 00 	movabs $0x8047dd,%rdi
  8038dd:	00 00 00 
  8038e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e5:	49 b8 ad 04 80 00 00 	movabs $0x8004ad,%r8
  8038ec:	00 00 00 
  8038ef:	41 ff d0             	callq  *%r8
	}
  8038f2:	e9 4a ff ff ff       	jmpq   803841 <_pipeisclosed+0x11>
  8038f7:	e9 45 ff ff ff       	jmpq   803841 <_pipeisclosed+0x11>
}
  8038fc:	48 83 c4 28          	add    $0x28,%rsp
  803900:	5b                   	pop    %rbx
  803901:	5d                   	pop    %rbp
  803902:	c3                   	retq   

0000000000803903 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803903:	55                   	push   %rbp
  803904:	48 89 e5             	mov    %rsp,%rbp
  803907:	48 83 ec 30          	sub    $0x30,%rsp
  80390b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80390e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803912:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803915:	48 89 d6             	mov    %rdx,%rsi
  803918:	89 c7                	mov    %eax,%edi
  80391a:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  803921:	00 00 00 
  803924:	ff d0                	callq  *%rax
  803926:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803929:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392d:	79 05                	jns    803934 <pipeisclosed+0x31>
		return r;
  80392f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803932:	eb 31                	jmp    803965 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803938:	48 89 c7             	mov    %rax,%rdi
  80393b:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  803942:	00 00 00 
  803945:	ff d0                	callq  *%rax
  803947:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80394b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803953:	48 89 d6             	mov    %rdx,%rsi
  803956:	48 89 c7             	mov    %rax,%rdi
  803959:	48 b8 30 38 80 00 00 	movabs $0x803830,%rax
  803960:	00 00 00 
  803963:	ff d0                	callq  *%rax
}
  803965:	c9                   	leaveq 
  803966:	c3                   	retq   

0000000000803967 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803967:	55                   	push   %rbp
  803968:	48 89 e5             	mov    %rsp,%rbp
  80396b:	48 83 ec 40          	sub    $0x40,%rsp
  80396f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803973:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803977:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80397b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80397f:	48 89 c7             	mov    %rax,%rdi
  803982:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  803989:	00 00 00 
  80398c:	ff d0                	callq  *%rax
  80398e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803992:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803996:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80399a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039a1:	00 
  8039a2:	e9 92 00 00 00       	jmpq   803a39 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8039a7:	eb 41                	jmp    8039ea <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8039a9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039ae:	74 09                	je     8039b9 <devpipe_read+0x52>
				return i;
  8039b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b4:	e9 92 00 00 00       	jmpq   803a4b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8039b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c1:	48 89 d6             	mov    %rdx,%rsi
  8039c4:	48 89 c7             	mov    %rax,%rdi
  8039c7:	48 b8 30 38 80 00 00 	movabs $0x803830,%rax
  8039ce:	00 00 00 
  8039d1:	ff d0                	callq  *%rax
  8039d3:	85 c0                	test   %eax,%eax
  8039d5:	74 07                	je     8039de <devpipe_read+0x77>
				return 0;
  8039d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039dc:	eb 6d                	jmp    803a4b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8039de:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8039e5:	00 00 00 
  8039e8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8039ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ee:	8b 10                	mov    (%rax),%edx
  8039f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f4:	8b 40 04             	mov    0x4(%rax),%eax
  8039f7:	39 c2                	cmp    %eax,%edx
  8039f9:	74 ae                	je     8039a9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a03:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0b:	8b 00                	mov    (%rax),%eax
  803a0d:	99                   	cltd   
  803a0e:	c1 ea 1b             	shr    $0x1b,%edx
  803a11:	01 d0                	add    %edx,%eax
  803a13:	83 e0 1f             	and    $0x1f,%eax
  803a16:	29 d0                	sub    %edx,%eax
  803a18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a1c:	48 98                	cltq   
  803a1e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a23:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a29:	8b 00                	mov    (%rax),%eax
  803a2b:	8d 50 01             	lea    0x1(%rax),%edx
  803a2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a32:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a34:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a3d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a41:	0f 82 60 ff ff ff    	jb     8039a7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a4b:	c9                   	leaveq 
  803a4c:	c3                   	retq   

0000000000803a4d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a4d:	55                   	push   %rbp
  803a4e:	48 89 e5             	mov    %rsp,%rbp
  803a51:	48 83 ec 40          	sub    $0x40,%rsp
  803a55:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a59:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a5d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a65:	48 89 c7             	mov    %rax,%rdi
  803a68:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  803a6f:	00 00 00 
  803a72:	ff d0                	callq  *%rax
  803a74:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a80:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a87:	00 
  803a88:	e9 8e 00 00 00       	jmpq   803b1b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a8d:	eb 31                	jmp    803ac0 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a97:	48 89 d6             	mov    %rdx,%rsi
  803a9a:	48 89 c7             	mov    %rax,%rdi
  803a9d:	48 b8 30 38 80 00 00 	movabs $0x803830,%rax
  803aa4:	00 00 00 
  803aa7:	ff d0                	callq  *%rax
  803aa9:	85 c0                	test   %eax,%eax
  803aab:	74 07                	je     803ab4 <devpipe_write+0x67>
				return 0;
  803aad:	b8 00 00 00 00       	mov    $0x0,%eax
  803ab2:	eb 79                	jmp    803b2d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803ab4:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  803abb:	00 00 00 
  803abe:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ac0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ac4:	8b 40 04             	mov    0x4(%rax),%eax
  803ac7:	48 63 d0             	movslq %eax,%rdx
  803aca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ace:	8b 00                	mov    (%rax),%eax
  803ad0:	48 98                	cltq   
  803ad2:	48 83 c0 20          	add    $0x20,%rax
  803ad6:	48 39 c2             	cmp    %rax,%rdx
  803ad9:	73 b4                	jae    803a8f <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803adb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803adf:	8b 40 04             	mov    0x4(%rax),%eax
  803ae2:	99                   	cltd   
  803ae3:	c1 ea 1b             	shr    $0x1b,%edx
  803ae6:	01 d0                	add    %edx,%eax
  803ae8:	83 e0 1f             	and    $0x1f,%eax
  803aeb:	29 d0                	sub    %edx,%eax
  803aed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803af1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803af5:	48 01 ca             	add    %rcx,%rdx
  803af8:	0f b6 0a             	movzbl (%rdx),%ecx
  803afb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803aff:	48 98                	cltq   
  803b01:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b09:	8b 40 04             	mov    0x4(%rax),%eax
  803b0c:	8d 50 01             	lea    0x1(%rax),%edx
  803b0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b13:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b16:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b1f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b23:	0f 82 64 ff ff ff    	jb     803a8d <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b2d:	c9                   	leaveq 
  803b2e:	c3                   	retq   

0000000000803b2f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b2f:	55                   	push   %rbp
  803b30:	48 89 e5             	mov    %rsp,%rbp
  803b33:	48 83 ec 20          	sub    $0x20,%rsp
  803b37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b43:	48 89 c7             	mov    %rax,%rdi
  803b46:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  803b4d:	00 00 00 
  803b50:	ff d0                	callq  *%rax
  803b52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b5a:	48 be f0 47 80 00 00 	movabs $0x8047f0,%rsi
  803b61:	00 00 00 
  803b64:	48 89 c7             	mov    %rax,%rdi
  803b67:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  803b6e:	00 00 00 
  803b71:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b77:	8b 50 04             	mov    0x4(%rax),%edx
  803b7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b7e:	8b 00                	mov    (%rax),%eax
  803b80:	29 c2                	sub    %eax,%edx
  803b82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b86:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b90:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b97:	00 00 00 
	stat->st_dev = &devpipe;
  803b9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b9e:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803ba5:	00 00 00 
  803ba8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803baf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bb4:	c9                   	leaveq 
  803bb5:	c3                   	retq   

0000000000803bb6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803bb6:	55                   	push   %rbp
  803bb7:	48 89 e5             	mov    %rsp,%rbp
  803bba:	48 83 ec 10          	sub    $0x10,%rsp
  803bbe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803bc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc6:	48 89 c6             	mov    %rax,%rsi
  803bc9:	bf 00 00 00 00       	mov    $0x0,%edi
  803bce:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  803bd5:	00 00 00 
  803bd8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803bda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bde:	48 89 c7             	mov    %rax,%rdi
  803be1:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  803be8:	00 00 00 
  803beb:	ff d0                	callq  *%rax
  803bed:	48 89 c6             	mov    %rax,%rsi
  803bf0:	bf 00 00 00 00       	mov    $0x0,%edi
  803bf5:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  803bfc:	00 00 00 
  803bff:	ff d0                	callq  *%rax
}
  803c01:	c9                   	leaveq 
  803c02:	c3                   	retq   

0000000000803c03 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c03:	55                   	push   %rbp
  803c04:	48 89 e5             	mov    %rsp,%rbp
  803c07:	48 83 ec 20          	sub    $0x20,%rsp
  803c0b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c11:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c14:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c18:	be 01 00 00 00       	mov    $0x1,%esi
  803c1d:	48 89 c7             	mov    %rax,%rdi
  803c20:	48 b8 49 18 80 00 00 	movabs $0x801849,%rax
  803c27:	00 00 00 
  803c2a:	ff d0                	callq  *%rax
}
  803c2c:	c9                   	leaveq 
  803c2d:	c3                   	retq   

0000000000803c2e <getchar>:

int
getchar(void)
{
  803c2e:	55                   	push   %rbp
  803c2f:	48 89 e5             	mov    %rsp,%rbp
  803c32:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c36:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c3a:	ba 01 00 00 00       	mov    $0x1,%edx
  803c3f:	48 89 c6             	mov    %rax,%rsi
  803c42:	bf 00 00 00 00       	mov    $0x0,%edi
  803c47:	48 b8 81 2b 80 00 00 	movabs $0x802b81,%rax
  803c4e:	00 00 00 
  803c51:	ff d0                	callq  *%rax
  803c53:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c5a:	79 05                	jns    803c61 <getchar+0x33>
		return r;
  803c5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c5f:	eb 14                	jmp    803c75 <getchar+0x47>
	if (r < 1)
  803c61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c65:	7f 07                	jg     803c6e <getchar+0x40>
		return -E_EOF;
  803c67:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c6c:	eb 07                	jmp    803c75 <getchar+0x47>
	return c;
  803c6e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c72:	0f b6 c0             	movzbl %al,%eax
}
  803c75:	c9                   	leaveq 
  803c76:	c3                   	retq   

0000000000803c77 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c77:	55                   	push   %rbp
  803c78:	48 89 e5             	mov    %rsp,%rbp
  803c7b:	48 83 ec 20          	sub    $0x20,%rsp
  803c7f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c82:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c86:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c89:	48 89 d6             	mov    %rdx,%rsi
  803c8c:	89 c7                	mov    %eax,%edi
  803c8e:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  803c95:	00 00 00 
  803c98:	ff d0                	callq  *%rax
  803c9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca1:	79 05                	jns    803ca8 <iscons+0x31>
		return r;
  803ca3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca6:	eb 1a                	jmp    803cc2 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cac:	8b 10                	mov    (%rax),%edx
  803cae:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803cb5:	00 00 00 
  803cb8:	8b 00                	mov    (%rax),%eax
  803cba:	39 c2                	cmp    %eax,%edx
  803cbc:	0f 94 c0             	sete   %al
  803cbf:	0f b6 c0             	movzbl %al,%eax
}
  803cc2:	c9                   	leaveq 
  803cc3:	c3                   	retq   

0000000000803cc4 <opencons>:

int
opencons(void)
{
  803cc4:	55                   	push   %rbp
  803cc5:	48 89 e5             	mov    %rsp,%rbp
  803cc8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ccc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803cd0:	48 89 c7             	mov    %rax,%rdi
  803cd3:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  803cda:	00 00 00 
  803cdd:	ff d0                	callq  *%rax
  803cdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ce2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce6:	79 05                	jns    803ced <opencons+0x29>
		return r;
  803ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ceb:	eb 5b                	jmp    803d48 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ced:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf1:	ba 07 04 00 00       	mov    $0x407,%edx
  803cf6:	48 89 c6             	mov    %rax,%rsi
  803cf9:	bf 00 00 00 00       	mov    $0x0,%edi
  803cfe:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  803d05:	00 00 00 
  803d08:	ff d0                	callq  *%rax
  803d0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d11:	79 05                	jns    803d18 <opencons+0x54>
		return r;
  803d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d16:	eb 30                	jmp    803d48 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1c:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d23:	00 00 00 
  803d26:	8b 12                	mov    (%rdx),%edx
  803d28:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d2e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d39:	48 89 c7             	mov    %rax,%rdi
  803d3c:	48 b8 69 26 80 00 00 	movabs $0x802669,%rax
  803d43:	00 00 00 
  803d46:	ff d0                	callq  *%rax
}
  803d48:	c9                   	leaveq 
  803d49:	c3                   	retq   

0000000000803d4a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d4a:	55                   	push   %rbp
  803d4b:	48 89 e5             	mov    %rsp,%rbp
  803d4e:	48 83 ec 30          	sub    $0x30,%rsp
  803d52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d5a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d5e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d63:	75 07                	jne    803d6c <devcons_read+0x22>
		return 0;
  803d65:	b8 00 00 00 00       	mov    $0x0,%eax
  803d6a:	eb 4b                	jmp    803db7 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d6c:	eb 0c                	jmp    803d7a <devcons_read+0x30>
		sys_yield();
  803d6e:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  803d75:	00 00 00 
  803d78:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d7a:	48 b8 93 18 80 00 00 	movabs $0x801893,%rax
  803d81:	00 00 00 
  803d84:	ff d0                	callq  *%rax
  803d86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d8d:	74 df                	je     803d6e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803d8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d93:	79 05                	jns    803d9a <devcons_read+0x50>
		return c;
  803d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d98:	eb 1d                	jmp    803db7 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d9a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d9e:	75 07                	jne    803da7 <devcons_read+0x5d>
		return 0;
  803da0:	b8 00 00 00 00       	mov    $0x0,%eax
  803da5:	eb 10                	jmp    803db7 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803da7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803daa:	89 c2                	mov    %eax,%edx
  803dac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803db0:	88 10                	mov    %dl,(%rax)
	return 1;
  803db2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803db7:	c9                   	leaveq 
  803db8:	c3                   	retq   

0000000000803db9 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803db9:	55                   	push   %rbp
  803dba:	48 89 e5             	mov    %rsp,%rbp
  803dbd:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803dc4:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803dcb:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803dd2:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803dd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803de0:	eb 76                	jmp    803e58 <devcons_write+0x9f>
		m = n - tot;
  803de2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803de9:	89 c2                	mov    %eax,%edx
  803deb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dee:	29 c2                	sub    %eax,%edx
  803df0:	89 d0                	mov    %edx,%eax
  803df2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803df5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803df8:	83 f8 7f             	cmp    $0x7f,%eax
  803dfb:	76 07                	jbe    803e04 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803dfd:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e04:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e07:	48 63 d0             	movslq %eax,%rdx
  803e0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e0d:	48 63 c8             	movslq %eax,%rcx
  803e10:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e17:	48 01 c1             	add    %rax,%rcx
  803e1a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e21:	48 89 ce             	mov    %rcx,%rsi
  803e24:	48 89 c7             	mov    %rax,%rdi
  803e27:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  803e2e:	00 00 00 
  803e31:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e33:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e36:	48 63 d0             	movslq %eax,%rdx
  803e39:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e40:	48 89 d6             	mov    %rdx,%rsi
  803e43:	48 89 c7             	mov    %rax,%rdi
  803e46:	48 b8 49 18 80 00 00 	movabs $0x801849,%rax
  803e4d:	00 00 00 
  803e50:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e55:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e5b:	48 98                	cltq   
  803e5d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e64:	0f 82 78 ff ff ff    	jb     803de2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e6d:	c9                   	leaveq 
  803e6e:	c3                   	retq   

0000000000803e6f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e6f:	55                   	push   %rbp
  803e70:	48 89 e5             	mov    %rsp,%rbp
  803e73:	48 83 ec 08          	sub    $0x8,%rsp
  803e77:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e80:	c9                   	leaveq 
  803e81:	c3                   	retq   

0000000000803e82 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e82:	55                   	push   %rbp
  803e83:	48 89 e5             	mov    %rsp,%rbp
  803e86:	48 83 ec 10          	sub    $0x10,%rsp
  803e8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e8e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e96:	48 be fc 47 80 00 00 	movabs $0x8047fc,%rsi
  803e9d:	00 00 00 
  803ea0:	48 89 c7             	mov    %rax,%rdi
  803ea3:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  803eaa:	00 00 00 
  803ead:	ff d0                	callq  *%rax
	return 0;
  803eaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803eb4:	c9                   	leaveq 
  803eb5:	c3                   	retq   

0000000000803eb6 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803eb6:	55                   	push   %rbp
  803eb7:	48 89 e5             	mov    %rsp,%rbp
  803eba:	48 83 ec 10          	sub    $0x10,%rsp
  803ebe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803ec2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803ec9:	00 00 00 
  803ecc:	48 8b 00             	mov    (%rax),%rax
  803ecf:	48 85 c0             	test   %rax,%rax
  803ed2:	0f 85 84 00 00 00    	jne    803f5c <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803ed8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803edf:	00 00 00 
  803ee2:	48 8b 00             	mov    (%rax),%rax
  803ee5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803eeb:	ba 07 00 00 00       	mov    $0x7,%edx
  803ef0:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803ef5:	89 c7                	mov    %eax,%edi
  803ef7:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  803efe:	00 00 00 
  803f01:	ff d0                	callq  *%rax
  803f03:	85 c0                	test   %eax,%eax
  803f05:	79 2a                	jns    803f31 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803f07:	48 ba 08 48 80 00 00 	movabs $0x804808,%rdx
  803f0e:	00 00 00 
  803f11:	be 23 00 00 00       	mov    $0x23,%esi
  803f16:	48 bf 2f 48 80 00 00 	movabs $0x80482f,%rdi
  803f1d:	00 00 00 
  803f20:	b8 00 00 00 00       	mov    $0x0,%eax
  803f25:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  803f2c:	00 00 00 
  803f2f:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803f31:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f38:	00 00 00 
  803f3b:	48 8b 00             	mov    (%rax),%rax
  803f3e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f44:	48 be 6f 3f 80 00 00 	movabs $0x803f6f,%rsi
  803f4b:	00 00 00 
  803f4e:	89 c7                	mov    %eax,%edi
  803f50:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  803f57:	00 00 00 
  803f5a:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803f5c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803f63:	00 00 00 
  803f66:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f6a:	48 89 10             	mov    %rdx,(%rax)
}
  803f6d:	c9                   	leaveq 
  803f6e:	c3                   	retq   

0000000000803f6f <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803f6f:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803f72:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803f79:	00 00 00 
call *%rax
  803f7c:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  803f7e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803f85:	00 
movq 152(%rsp), %rcx  //Load RSP
  803f86:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803f8d:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  803f8e:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  803f92:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  803f95:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803f9c:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  803f9d:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  803fa1:	4c 8b 3c 24          	mov    (%rsp),%r15
  803fa5:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803faa:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803faf:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803fb4:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803fb9:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803fbe:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803fc3:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803fc8:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803fcd:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803fd2:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803fd7:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803fdc:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803fe1:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803fe6:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803feb:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  803fef:	48 83 c4 08          	add    $0x8,%rsp
popfq
  803ff3:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  803ff4:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  803ff5:	c3                   	retq   

0000000000803ff6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ff6:	55                   	push   %rbp
  803ff7:	48 89 e5             	mov    %rsp,%rbp
  803ffa:	48 83 ec 18          	sub    $0x18,%rsp
  803ffe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804006:	48 c1 e8 15          	shr    $0x15,%rax
  80400a:	48 89 c2             	mov    %rax,%rdx
  80400d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804014:	01 00 00 
  804017:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80401b:	83 e0 01             	and    $0x1,%eax
  80401e:	48 85 c0             	test   %rax,%rax
  804021:	75 07                	jne    80402a <pageref+0x34>
		return 0;
  804023:	b8 00 00 00 00       	mov    $0x0,%eax
  804028:	eb 53                	jmp    80407d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80402a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80402e:	48 c1 e8 0c          	shr    $0xc,%rax
  804032:	48 89 c2             	mov    %rax,%rdx
  804035:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80403c:	01 00 00 
  80403f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804043:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804047:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80404b:	83 e0 01             	and    $0x1,%eax
  80404e:	48 85 c0             	test   %rax,%rax
  804051:	75 07                	jne    80405a <pageref+0x64>
		return 0;
  804053:	b8 00 00 00 00       	mov    $0x0,%eax
  804058:	eb 23                	jmp    80407d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80405a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80405e:	48 c1 e8 0c          	shr    $0xc,%rax
  804062:	48 89 c2             	mov    %rax,%rdx
  804065:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80406c:	00 00 00 
  80406f:	48 c1 e2 04          	shl    $0x4,%rdx
  804073:	48 01 d0             	add    %rdx,%rax
  804076:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80407a:	0f b7 c0             	movzwl %ax,%eax
}
  80407d:	c9                   	leaveq 
  80407e:	c3                   	retq   
