
vmm/guest/obj/user/primes:     file format elf64-x86-64


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
  80005c:	48 b8 73 23 80 00 00 	movabs $0x802373,%rax
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
  800083:	48 bf e0 42 80 00 00 	movabs $0x8042e0,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 ca 20 80 00 00 	movabs $0x8020ca,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba eb 42 80 00 00 	movabs $0x8042eb,%rdx
  8000bf:	00 00 00 
  8000c2:	be 19 00 00 00       	mov    $0x19,%esi
  8000c7:	48 bf f4 42 80 00 00 	movabs $0x8042f4,%rdi
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
  8000ff:	48 b8 73 23 80 00 00 	movabs $0x802373,%rax
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
  80012d:	48 b8 71 24 80 00 00 	movabs $0x802471,%rax
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
  80014c:	48 b8 ca 20 80 00 00 	movabs $0x8020ca,%rax
  800153:	00 00 00 
  800156:	ff d0                	callq  *%rax
  800158:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80015b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015f:	79 30                	jns    800191 <umain+0x54>
		panic("fork: %e", id);
  800161:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800164:	89 c1                	mov    %eax,%ecx
  800166:	48 ba eb 42 80 00 00 	movabs $0x8042eb,%rdx
  80016d:	00 00 00 
  800170:	be 2c 00 00 00       	mov    $0x2c,%esi
  800175:	48 bf f4 42 80 00 00 	movabs $0x8042f4,%rdi
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
  8001bc:	48 b8 71 24 80 00 00 	movabs $0x802471,%rax
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
  800255:	48 b8 f1 2b 80 00 00 	movabs $0x802bf1,%rax
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
  80032e:	48 bf 10 43 80 00 00 	movabs $0x804310,%rdi
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
  80036a:	48 bf 33 43 80 00 00 	movabs $0x804333,%rdi
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
  800619:	48 ba 30 45 80 00 00 	movabs $0x804530,%rdx
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
  800911:	48 b8 58 45 80 00 00 	movabs $0x804558,%rax
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
  800a64:	48 b8 80 44 80 00 00 	movabs $0x804480,%rax
  800a6b:	00 00 00 
  800a6e:	48 63 d3             	movslq %ebx,%rdx
  800a71:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a75:	4d 85 e4             	test   %r12,%r12
  800a78:	75 2e                	jne    800aa8 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a7a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a82:	89 d9                	mov    %ebx,%ecx
  800a84:	48 ba 41 45 80 00 00 	movabs $0x804541,%rdx
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
  800ab3:	48 ba 4a 45 80 00 00 	movabs $0x80454a,%rdx
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
  800b0d:	49 bc 4d 45 80 00 00 	movabs $0x80454d,%r12
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
  801813:	48 ba 08 48 80 00 00 	movabs $0x804808,%rdx
  80181a:	00 00 00 
  80181d:	be 23 00 00 00       	mov    $0x23,%esi
  801822:	48 bf 25 48 80 00 00 	movabs $0x804825,%rdi
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

0000000000801ce1 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801ce1:	55                   	push   %rbp
  801ce2:	48 89 e5             	mov    %rsp,%rbp
  801ce5:	48 83 ec 30          	sub    $0x30,%rsp
  801ce9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801ced:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf1:	48 8b 00             	mov    (%rax),%rax
  801cf4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801cf8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cfc:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d00:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801d03:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d06:	83 e0 02             	and    $0x2,%eax
  801d09:	85 c0                	test   %eax,%eax
  801d0b:	75 4d                	jne    801d5a <pgfault+0x79>
  801d0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d11:	48 c1 e8 0c          	shr    $0xc,%rax
  801d15:	48 89 c2             	mov    %rax,%rdx
  801d18:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d1f:	01 00 00 
  801d22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d26:	25 00 08 00 00       	and    $0x800,%eax
  801d2b:	48 85 c0             	test   %rax,%rax
  801d2e:	74 2a                	je     801d5a <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801d30:	48 ba 38 48 80 00 00 	movabs $0x804838,%rdx
  801d37:	00 00 00 
  801d3a:	be 23 00 00 00       	mov    $0x23,%esi
  801d3f:	48 bf 6d 48 80 00 00 	movabs $0x80486d,%rdi
  801d46:	00 00 00 
  801d49:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4e:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  801d55:	00 00 00 
  801d58:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801d5a:	ba 07 00 00 00       	mov    $0x7,%edx
  801d5f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d64:	bf 00 00 00 00       	mov    $0x0,%edi
  801d69:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  801d70:	00 00 00 
  801d73:	ff d0                	callq  *%rax
  801d75:	85 c0                	test   %eax,%eax
  801d77:	0f 85 cd 00 00 00    	jne    801e4a <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d89:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d8f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801d93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d97:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d9c:	48 89 c6             	mov    %rax,%rsi
  801d9f:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801da4:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  801dab:	00 00 00 
  801dae:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801db0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801db4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801dba:	48 89 c1             	mov    %rax,%rcx
  801dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801dc7:	bf 00 00 00 00       	mov    $0x0,%edi
  801dcc:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  801dd3:	00 00 00 
  801dd6:	ff d0                	callq  *%rax
  801dd8:	85 c0                	test   %eax,%eax
  801dda:	79 2a                	jns    801e06 <pgfault+0x125>
				panic("Page map at temp address failed");
  801ddc:	48 ba 78 48 80 00 00 	movabs $0x804878,%rdx
  801de3:	00 00 00 
  801de6:	be 30 00 00 00       	mov    $0x30,%esi
  801deb:	48 bf 6d 48 80 00 00 	movabs $0x80486d,%rdi
  801df2:	00 00 00 
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfa:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  801e01:	00 00 00 
  801e04:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801e06:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e0b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e10:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  801e17:	00 00 00 
  801e1a:	ff d0                	callq  *%rax
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	79 54                	jns    801e74 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801e20:	48 ba 98 48 80 00 00 	movabs $0x804898,%rdx
  801e27:	00 00 00 
  801e2a:	be 32 00 00 00       	mov    $0x32,%esi
  801e2f:	48 bf 6d 48 80 00 00 	movabs $0x80486d,%rdi
  801e36:	00 00 00 
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3e:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  801e45:	00 00 00 
  801e48:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801e4a:	48 ba c0 48 80 00 00 	movabs $0x8048c0,%rdx
  801e51:	00 00 00 
  801e54:	be 34 00 00 00       	mov    $0x34,%esi
  801e59:	48 bf 6d 48 80 00 00 	movabs $0x80486d,%rdi
  801e60:	00 00 00 
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
  801e68:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  801e6f:	00 00 00 
  801e72:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801e74:	c9                   	leaveq 
  801e75:	c3                   	retq   

0000000000801e76 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e76:	55                   	push   %rbp
  801e77:	48 89 e5             	mov    %rsp,%rbp
  801e7a:	48 83 ec 20          	sub    $0x20,%rsp
  801e7e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e81:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801e84:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e8b:	01 00 00 
  801e8e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e95:	25 07 0e 00 00       	and    $0xe07,%eax
  801e9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801e9d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801ea0:	48 c1 e0 0c          	shl    $0xc,%rax
  801ea4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801ea8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eab:	25 00 04 00 00       	and    $0x400,%eax
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	74 57                	je     801f0b <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801eb4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801eb7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ebb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec2:	41 89 f0             	mov    %esi,%r8d
  801ec5:	48 89 c6             	mov    %rax,%rsi
  801ec8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ecd:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  801ed4:	00 00 00 
  801ed7:	ff d0                	callq  *%rax
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	0f 8e 52 01 00 00    	jle    802033 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801ee1:	48 ba f2 48 80 00 00 	movabs $0x8048f2,%rdx
  801ee8:	00 00 00 
  801eeb:	be 4e 00 00 00       	mov    $0x4e,%esi
  801ef0:	48 bf 6d 48 80 00 00 	movabs $0x80486d,%rdi
  801ef7:	00 00 00 
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eff:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  801f06:	00 00 00 
  801f09:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801f0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0e:	83 e0 02             	and    $0x2,%eax
  801f11:	85 c0                	test   %eax,%eax
  801f13:	75 10                	jne    801f25 <duppage+0xaf>
  801f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f18:	25 00 08 00 00       	and    $0x800,%eax
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	0f 84 bb 00 00 00    	je     801fe0 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801f25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f28:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801f2d:	80 cc 08             	or     $0x8,%ah
  801f30:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f33:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f36:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f3a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f41:	41 89 f0             	mov    %esi,%r8d
  801f44:	48 89 c6             	mov    %rax,%rsi
  801f47:	bf 00 00 00 00       	mov    $0x0,%edi
  801f4c:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  801f53:	00 00 00 
  801f56:	ff d0                	callq  *%rax
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	7e 2a                	jle    801f86 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801f5c:	48 ba f2 48 80 00 00 	movabs $0x8048f2,%rdx
  801f63:	00 00 00 
  801f66:	be 55 00 00 00       	mov    $0x55,%esi
  801f6b:	48 bf 6d 48 80 00 00 	movabs $0x80486d,%rdi
  801f72:	00 00 00 
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7a:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  801f81:	00 00 00 
  801f84:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f86:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f91:	41 89 c8             	mov    %ecx,%r8d
  801f94:	48 89 d1             	mov    %rdx,%rcx
  801f97:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9c:	48 89 c6             	mov    %rax,%rsi
  801f9f:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa4:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  801fab:	00 00 00 
  801fae:	ff d0                	callq  *%rax
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	7e 2a                	jle    801fde <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801fb4:	48 ba f2 48 80 00 00 	movabs $0x8048f2,%rdx
  801fbb:	00 00 00 
  801fbe:	be 57 00 00 00       	mov    $0x57,%esi
  801fc3:	48 bf 6d 48 80 00 00 	movabs $0x80486d,%rdi
  801fca:	00 00 00 
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd2:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  801fd9:	00 00 00 
  801fdc:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801fde:	eb 53                	jmp    802033 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801fe0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fe3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fe7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fee:	41 89 f0             	mov    %esi,%r8d
  801ff1:	48 89 c6             	mov    %rax,%rsi
  801ff4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff9:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  802000:	00 00 00 
  802003:	ff d0                	callq  *%rax
  802005:	85 c0                	test   %eax,%eax
  802007:	7e 2a                	jle    802033 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802009:	48 ba f2 48 80 00 00 	movabs $0x8048f2,%rdx
  802010:	00 00 00 
  802013:	be 5b 00 00 00       	mov    $0x5b,%esi
  802018:	48 bf 6d 48 80 00 00 	movabs $0x80486d,%rdi
  80201f:	00 00 00 
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  80202e:	00 00 00 
  802031:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802038:	c9                   	leaveq 
  802039:	c3                   	retq   

000000000080203a <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  80203a:	55                   	push   %rbp
  80203b:	48 89 e5             	mov    %rsp,%rbp
  80203e:	48 83 ec 18          	sub    $0x18,%rsp
  802042:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802046:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  80204e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802052:	48 c1 e8 27          	shr    $0x27,%rax
  802056:	48 89 c2             	mov    %rax,%rdx
  802059:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802060:	01 00 00 
  802063:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802067:	83 e0 01             	and    $0x1,%eax
  80206a:	48 85 c0             	test   %rax,%rax
  80206d:	74 51                	je     8020c0 <pt_is_mapped+0x86>
  80206f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802073:	48 c1 e0 0c          	shl    $0xc,%rax
  802077:	48 c1 e8 1e          	shr    $0x1e,%rax
  80207b:	48 89 c2             	mov    %rax,%rdx
  80207e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802085:	01 00 00 
  802088:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80208c:	83 e0 01             	and    $0x1,%eax
  80208f:	48 85 c0             	test   %rax,%rax
  802092:	74 2c                	je     8020c0 <pt_is_mapped+0x86>
  802094:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802098:	48 c1 e0 0c          	shl    $0xc,%rax
  80209c:	48 c1 e8 15          	shr    $0x15,%rax
  8020a0:	48 89 c2             	mov    %rax,%rdx
  8020a3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020aa:	01 00 00 
  8020ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b1:	83 e0 01             	and    $0x1,%eax
  8020b4:	48 85 c0             	test   %rax,%rax
  8020b7:	74 07                	je     8020c0 <pt_is_mapped+0x86>
  8020b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020be:	eb 05                	jmp    8020c5 <pt_is_mapped+0x8b>
  8020c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c5:	83 e0 01             	and    $0x1,%eax
}
  8020c8:	c9                   	leaveq 
  8020c9:	c3                   	retq   

00000000008020ca <fork>:

envid_t
fork(void)
{
  8020ca:	55                   	push   %rbp
  8020cb:	48 89 e5             	mov    %rsp,%rbp
  8020ce:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8020d2:	48 bf e1 1c 80 00 00 	movabs $0x801ce1,%rdi
  8020d9:	00 00 00 
  8020dc:	48 b8 fd 40 80 00 00 	movabs $0x8040fd,%rax
  8020e3:	00 00 00 
  8020e6:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8020e8:	b8 07 00 00 00       	mov    $0x7,%eax
  8020ed:	cd 30                	int    $0x30
  8020ef:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8020f2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8020f5:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8020f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020fc:	79 30                	jns    80212e <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8020fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802101:	89 c1                	mov    %eax,%ecx
  802103:	48 ba 10 49 80 00 00 	movabs $0x804910,%rdx
  80210a:	00 00 00 
  80210d:	be 86 00 00 00       	mov    $0x86,%esi
  802112:	48 bf 6d 48 80 00 00 	movabs $0x80486d,%rdi
  802119:	00 00 00 
  80211c:	b8 00 00 00 00       	mov    $0x0,%eax
  802121:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  802128:	00 00 00 
  80212b:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80212e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802132:	75 3e                	jne    802172 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802134:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  80213b:	00 00 00 
  80213e:	ff d0                	callq  *%rax
  802140:	25 ff 03 00 00       	and    $0x3ff,%eax
  802145:	48 98                	cltq   
  802147:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80214e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802155:	00 00 00 
  802158:	48 01 c2             	add    %rax,%rdx
  80215b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802162:	00 00 00 
  802165:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802168:	b8 00 00 00 00       	mov    $0x0,%eax
  80216d:	e9 d1 01 00 00       	jmpq   802343 <fork+0x279>
	}
	uint64_t ad = 0;
  802172:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802179:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80217a:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80217f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802183:	e9 df 00 00 00       	jmpq   802267 <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802188:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80218c:	48 c1 e8 27          	shr    $0x27,%rax
  802190:	48 89 c2             	mov    %rax,%rdx
  802193:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80219a:	01 00 00 
  80219d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a1:	83 e0 01             	and    $0x1,%eax
  8021a4:	48 85 c0             	test   %rax,%rax
  8021a7:	0f 84 9e 00 00 00    	je     80224b <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8021ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021b1:	48 c1 e8 1e          	shr    $0x1e,%rax
  8021b5:	48 89 c2             	mov    %rax,%rdx
  8021b8:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021bf:	01 00 00 
  8021c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c6:	83 e0 01             	and    $0x1,%eax
  8021c9:	48 85 c0             	test   %rax,%rax
  8021cc:	74 73                	je     802241 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  8021ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d2:	48 c1 e8 15          	shr    $0x15,%rax
  8021d6:	48 89 c2             	mov    %rax,%rdx
  8021d9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021e0:	01 00 00 
  8021e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e7:	83 e0 01             	and    $0x1,%eax
  8021ea:	48 85 c0             	test   %rax,%rax
  8021ed:	74 48                	je     802237 <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8021ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f3:	48 c1 e8 0c          	shr    $0xc,%rax
  8021f7:	48 89 c2             	mov    %rax,%rdx
  8021fa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802201:	01 00 00 
  802204:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802208:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80220c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802210:	83 e0 01             	and    $0x1,%eax
  802213:	48 85 c0             	test   %rax,%rax
  802216:	74 47                	je     80225f <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80221c:	48 c1 e8 0c          	shr    $0xc,%rax
  802220:	89 c2                	mov    %eax,%edx
  802222:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802225:	89 d6                	mov    %edx,%esi
  802227:	89 c7                	mov    %eax,%edi
  802229:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  802230:	00 00 00 
  802233:	ff d0                	callq  *%rax
  802235:	eb 28                	jmp    80225f <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802237:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80223e:	00 
  80223f:	eb 1e                	jmp    80225f <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802241:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802248:	40 
  802249:	eb 14                	jmp    80225f <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80224b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80224f:	48 c1 e8 27          	shr    $0x27,%rax
  802253:	48 83 c0 01          	add    $0x1,%rax
  802257:	48 c1 e0 27          	shl    $0x27,%rax
  80225b:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80225f:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802266:	00 
  802267:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80226e:	00 
  80226f:	0f 87 13 ff ff ff    	ja     802188 <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802275:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802278:	ba 07 00 00 00       	mov    $0x7,%edx
  80227d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802282:	89 c7                	mov    %eax,%edi
  802284:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  80228b:	00 00 00 
  80228e:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802290:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802293:	ba 07 00 00 00       	mov    $0x7,%edx
  802298:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80229d:	89 c7                	mov    %eax,%edi
  80229f:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  8022a6:	00 00 00 
  8022a9:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8022ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022ae:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8022b4:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8022b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8022be:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022c3:	89 c7                	mov    %eax,%edi
  8022c5:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  8022cc:	00 00 00 
  8022cf:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8022d1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022d6:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022db:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8022e0:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  8022e7:	00 00 00 
  8022ea:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8022ec:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8022f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f6:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  8022fd:	00 00 00 
  802300:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802302:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802309:	00 00 00 
  80230c:	48 8b 00             	mov    (%rax),%rax
  80230f:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802316:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802319:	48 89 d6             	mov    %rdx,%rsi
  80231c:	89 c7                	mov    %eax,%edi
  80231e:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  802325:	00 00 00 
  802328:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80232a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80232d:	be 02 00 00 00       	mov    $0x2,%esi
  802332:	89 c7                	mov    %eax,%edi
  802334:	48 b8 86 1a 80 00 00 	movabs $0x801a86,%rax
  80233b:	00 00 00 
  80233e:	ff d0                	callq  *%rax

	return envid;
  802340:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802343:	c9                   	leaveq 
  802344:	c3                   	retq   

0000000000802345 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802345:	55                   	push   %rbp
  802346:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802349:	48 ba 28 49 80 00 00 	movabs $0x804928,%rdx
  802350:	00 00 00 
  802353:	be bf 00 00 00       	mov    $0xbf,%esi
  802358:	48 bf 6d 48 80 00 00 	movabs $0x80486d,%rdi
  80235f:	00 00 00 
  802362:	b8 00 00 00 00       	mov    $0x0,%eax
  802367:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  80236e:	00 00 00 
  802371:	ff d1                	callq  *%rcx

0000000000802373 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802373:	55                   	push   %rbp
  802374:	48 89 e5             	mov    %rsp,%rbp
  802377:	48 83 ec 30          	sub    $0x30,%rsp
  80237b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80237f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802383:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802387:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80238e:	00 00 00 
  802391:	48 8b 00             	mov    (%rax),%rax
  802394:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80239a:	85 c0                	test   %eax,%eax
  80239c:	75 34                	jne    8023d2 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80239e:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  8023a5:	00 00 00 
  8023a8:	ff d0                	callq  *%rax
  8023aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8023af:	48 98                	cltq   
  8023b1:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8023b8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023bf:	00 00 00 
  8023c2:	48 01 c2             	add    %rax,%rdx
  8023c5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023cc:	00 00 00 
  8023cf:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8023d2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8023d7:	75 0e                	jne    8023e7 <ipc_recv+0x74>
		pg = (void*) UTOP;
  8023d9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023e0:	00 00 00 
  8023e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8023e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023eb:	48 89 c7             	mov    %rax,%rdi
  8023ee:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  8023f5:	00 00 00 
  8023f8:	ff d0                	callq  *%rax
  8023fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8023fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802401:	79 19                	jns    80241c <ipc_recv+0xa9>
		*from_env_store = 0;
  802403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802407:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80240d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802411:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  802417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241a:	eb 53                	jmp    80246f <ipc_recv+0xfc>
	}
	if(from_env_store)
  80241c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802421:	74 19                	je     80243c <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  802423:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80242a:	00 00 00 
  80242d:	48 8b 00             	mov    (%rax),%rax
  802430:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243a:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80243c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802441:	74 19                	je     80245c <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  802443:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80244a:	00 00 00 
  80244d:	48 8b 00             	mov    (%rax),%rax
  802450:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802456:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80245a:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80245c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802463:	00 00 00 
  802466:	48 8b 00             	mov    (%rax),%rax
  802469:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80246f:	c9                   	leaveq 
  802470:	c3                   	retq   

0000000000802471 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802471:	55                   	push   %rbp
  802472:	48 89 e5             	mov    %rsp,%rbp
  802475:	48 83 ec 30          	sub    $0x30,%rsp
  802479:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80247c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80247f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802483:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  802486:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80248b:	75 0e                	jne    80249b <ipc_send+0x2a>
		pg = (void*)UTOP;
  80248d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802494:	00 00 00 
  802497:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80249b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80249e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8024a1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8024a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a8:	89 c7                	mov    %eax,%edi
  8024aa:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  8024b1:	00 00 00 
  8024b4:	ff d0                	callq  *%rax
  8024b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8024b9:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8024bd:	75 0c                	jne    8024cb <ipc_send+0x5a>
			sys_yield();
  8024bf:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8024c6:	00 00 00 
  8024c9:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8024cb:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8024cf:	74 ca                	je     80249b <ipc_send+0x2a>
	if(result != 0)
  8024d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d5:	74 20                	je     8024f7 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  8024d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024da:	89 c6                	mov    %eax,%esi
  8024dc:	48 bf 40 49 80 00 00 	movabs $0x804940,%rdi
  8024e3:	00 00 00 
  8024e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024eb:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  8024f2:	00 00 00 
  8024f5:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  8024f7:	c9                   	leaveq 
  8024f8:	c3                   	retq   

00000000008024f9 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8024f9:	55                   	push   %rbp
  8024fa:	48 89 e5             	mov    %rsp,%rbp
  8024fd:	53                   	push   %rbx
  8024fe:	48 83 ec 58          	sub    $0x58,%rsp
  802502:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  802506:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80250a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  80250e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  802515:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80251c:	00 
  80251d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802521:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802525:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802529:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80252d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802531:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802535:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802539:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80253d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802541:	48 c1 e8 27          	shr    $0x27,%rax
  802545:	48 89 c2             	mov    %rax,%rdx
  802548:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80254f:	01 00 00 
  802552:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802556:	83 e0 01             	and    $0x1,%eax
  802559:	48 85 c0             	test   %rax,%rax
  80255c:	0f 85 91 00 00 00    	jne    8025f3 <ipc_host_recv+0xfa>
  802562:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802566:	48 c1 e8 1e          	shr    $0x1e,%rax
  80256a:	48 89 c2             	mov    %rax,%rdx
  80256d:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802574:	01 00 00 
  802577:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80257b:	83 e0 01             	and    $0x1,%eax
  80257e:	48 85 c0             	test   %rax,%rax
  802581:	74 70                	je     8025f3 <ipc_host_recv+0xfa>
  802583:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802587:	48 c1 e8 15          	shr    $0x15,%rax
  80258b:	48 89 c2             	mov    %rax,%rdx
  80258e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802595:	01 00 00 
  802598:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80259c:	83 e0 01             	and    $0x1,%eax
  80259f:	48 85 c0             	test   %rax,%rax
  8025a2:	74 4f                	je     8025f3 <ipc_host_recv+0xfa>
  8025a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a8:	48 c1 e8 0c          	shr    $0xc,%rax
  8025ac:	48 89 c2             	mov    %rax,%rdx
  8025af:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025b6:	01 00 00 
  8025b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025bd:	83 e0 01             	and    $0x1,%eax
  8025c0:	48 85 c0             	test   %rax,%rax
  8025c3:	74 2e                	je     8025f3 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c9:	ba 07 04 00 00       	mov    $0x407,%edx
  8025ce:	48 89 c6             	mov    %rax,%rsi
  8025d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8025d6:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  8025dd:	00 00 00 
  8025e0:	ff d0                	callq  *%rax
  8025e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8025e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8025e9:	79 08                	jns    8025f3 <ipc_host_recv+0xfa>
	    	return result;
  8025eb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8025ee:	e9 84 00 00 00       	jmpq   802677 <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8025f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f7:	48 c1 e8 0c          	shr    $0xc,%rax
  8025fb:	48 89 c2             	mov    %rax,%rdx
  8025fe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802605:	01 00 00 
  802608:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80260c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802612:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  802616:	b8 03 00 00 00       	mov    $0x3,%eax
  80261b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80261f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802623:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  802627:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80262b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80262f:	4c 89 c3             	mov    %r8,%rbx
  802632:	0f 01 c1             	vmcall 
  802635:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  802638:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80263c:	7e 36                	jle    802674 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  80263e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802641:	41 89 c0             	mov    %eax,%r8d
  802644:	b9 03 00 00 00       	mov    $0x3,%ecx
  802649:	48 ba 58 49 80 00 00 	movabs $0x804958,%rdx
  802650:	00 00 00 
  802653:	be 67 00 00 00       	mov    $0x67,%esi
  802658:	48 bf 85 49 80 00 00 	movabs $0x804985,%rdi
  80265f:	00 00 00 
  802662:	b8 00 00 00 00       	mov    $0x0,%eax
  802667:	49 b9 74 02 80 00 00 	movabs $0x800274,%r9
  80266e:	00 00 00 
  802671:	41 ff d1             	callq  *%r9
	return result;
  802674:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  802677:	48 83 c4 58          	add    $0x58,%rsp
  80267b:	5b                   	pop    %rbx
  80267c:	5d                   	pop    %rbp
  80267d:	c3                   	retq   

000000000080267e <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80267e:	55                   	push   %rbp
  80267f:	48 89 e5             	mov    %rsp,%rbp
  802682:	53                   	push   %rbx
  802683:	48 83 ec 68          	sub    $0x68,%rsp
  802687:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80268a:	89 75 a8             	mov    %esi,-0x58(%rbp)
  80268d:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  802691:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  802694:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802698:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  80269c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  8026a3:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8026aa:	00 
  8026ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026af:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8026b3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8026b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8026bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8026c3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8026c7:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8026cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026cf:	48 c1 e8 27          	shr    $0x27,%rax
  8026d3:	48 89 c2             	mov    %rax,%rdx
  8026d6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8026dd:	01 00 00 
  8026e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e4:	83 e0 01             	and    $0x1,%eax
  8026e7:	48 85 c0             	test   %rax,%rax
  8026ea:	0f 85 88 00 00 00    	jne    802778 <ipc_host_send+0xfa>
  8026f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f4:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026f8:	48 89 c2             	mov    %rax,%rdx
  8026fb:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802702:	01 00 00 
  802705:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802709:	83 e0 01             	and    $0x1,%eax
  80270c:	48 85 c0             	test   %rax,%rax
  80270f:	74 67                	je     802778 <ipc_host_send+0xfa>
  802711:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802715:	48 c1 e8 15          	shr    $0x15,%rax
  802719:	48 89 c2             	mov    %rax,%rdx
  80271c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802723:	01 00 00 
  802726:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80272a:	83 e0 01             	and    $0x1,%eax
  80272d:	48 85 c0             	test   %rax,%rax
  802730:	74 46                	je     802778 <ipc_host_send+0xfa>
  802732:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802736:	48 c1 e8 0c          	shr    $0xc,%rax
  80273a:	48 89 c2             	mov    %rax,%rdx
  80273d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802744:	01 00 00 
  802747:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80274b:	83 e0 01             	and    $0x1,%eax
  80274e:	48 85 c0             	test   %rax,%rax
  802751:	74 25                	je     802778 <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  802753:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802757:	48 c1 e8 0c          	shr    $0xc,%rax
  80275b:	48 89 c2             	mov    %rax,%rdx
  80275e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802765:	01 00 00 
  802768:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80276c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802772:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802776:	eb 0e                	jmp    802786 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  802778:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80277f:	00 00 00 
  802782:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  802786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278a:	48 89 c6             	mov    %rax,%rsi
  80278d:	48 bf 8f 49 80 00 00 	movabs $0x80498f,%rdi
  802794:	00 00 00 
  802797:	b8 00 00 00 00       	mov    $0x0,%eax
  80279c:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  8027a3:	00 00 00 
  8027a6:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  8027a8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8027ab:	48 98                	cltq   
  8027ad:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  8027b1:	8b 45 a8             	mov    -0x58(%rbp),%eax
  8027b4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  8027b8:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8027bb:	48 98                	cltq   
  8027bd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  8027c1:	b8 02 00 00 00       	mov    $0x2,%eax
  8027c6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8027ca:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8027ce:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  8027d2:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8027d6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027da:	4c 89 c3             	mov    %r8,%rbx
  8027dd:	0f 01 c1             	vmcall 
  8027e0:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  8027e3:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  8027e7:	75 0c                	jne    8027f5 <ipc_host_send+0x177>
			sys_yield();
  8027e9:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8027f0:	00 00 00 
  8027f3:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  8027f5:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  8027f9:	74 c6                	je     8027c1 <ipc_host_send+0x143>
	
	if(result !=0)
  8027fb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8027ff:	74 36                	je     802837 <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  802801:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802804:	41 89 c0             	mov    %eax,%r8d
  802807:	b9 02 00 00 00       	mov    $0x2,%ecx
  80280c:	48 ba 58 49 80 00 00 	movabs $0x804958,%rdx
  802813:	00 00 00 
  802816:	be 94 00 00 00       	mov    $0x94,%esi
  80281b:	48 bf 85 49 80 00 00 	movabs $0x804985,%rdi
  802822:	00 00 00 
  802825:	b8 00 00 00 00       	mov    $0x0,%eax
  80282a:	49 b9 74 02 80 00 00 	movabs $0x800274,%r9
  802831:	00 00 00 
  802834:	41 ff d1             	callq  *%r9
}
  802837:	48 83 c4 68          	add    $0x68,%rsp
  80283b:	5b                   	pop    %rbx
  80283c:	5d                   	pop    %rbp
  80283d:	c3                   	retq   

000000000080283e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80283e:	55                   	push   %rbp
  80283f:	48 89 e5             	mov    %rsp,%rbp
  802842:	48 83 ec 14          	sub    $0x14,%rsp
  802846:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802849:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802850:	eb 4e                	jmp    8028a0 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  802852:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802859:	00 00 00 
  80285c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285f:	48 98                	cltq   
  802861:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802868:	48 01 d0             	add    %rdx,%rax
  80286b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802871:	8b 00                	mov    (%rax),%eax
  802873:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802876:	75 24                	jne    80289c <ipc_find_env+0x5e>
			return envs[i].env_id;
  802878:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80287f:	00 00 00 
  802882:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802885:	48 98                	cltq   
  802887:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80288e:	48 01 d0             	add    %rdx,%rax
  802891:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802897:	8b 40 08             	mov    0x8(%rax),%eax
  80289a:	eb 12                	jmp    8028ae <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80289c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028a0:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8028a7:	7e a9                	jle    802852 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ae:	c9                   	leaveq 
  8028af:	c3                   	retq   

00000000008028b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8028b0:	55                   	push   %rbp
  8028b1:	48 89 e5             	mov    %rsp,%rbp
  8028b4:	48 83 ec 08          	sub    $0x8,%rsp
  8028b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8028bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8028c0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8028c7:	ff ff ff 
  8028ca:	48 01 d0             	add    %rdx,%rax
  8028cd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8028d1:	c9                   	leaveq 
  8028d2:	c3                   	retq   

00000000008028d3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8028d3:	55                   	push   %rbp
  8028d4:	48 89 e5             	mov    %rsp,%rbp
  8028d7:	48 83 ec 08          	sub    $0x8,%rsp
  8028db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8028df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028e3:	48 89 c7             	mov    %rax,%rdi
  8028e6:	48 b8 b0 28 80 00 00 	movabs $0x8028b0,%rax
  8028ed:	00 00 00 
  8028f0:	ff d0                	callq  *%rax
  8028f2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8028f8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8028fc:	c9                   	leaveq 
  8028fd:	c3                   	retq   

00000000008028fe <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8028fe:	55                   	push   %rbp
  8028ff:	48 89 e5             	mov    %rsp,%rbp
  802902:	48 83 ec 18          	sub    $0x18,%rsp
  802906:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80290a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802911:	eb 6b                	jmp    80297e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802913:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802916:	48 98                	cltq   
  802918:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80291e:	48 c1 e0 0c          	shl    $0xc,%rax
  802922:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802926:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292a:	48 c1 e8 15          	shr    $0x15,%rax
  80292e:	48 89 c2             	mov    %rax,%rdx
  802931:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802938:	01 00 00 
  80293b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80293f:	83 e0 01             	and    $0x1,%eax
  802942:	48 85 c0             	test   %rax,%rax
  802945:	74 21                	je     802968 <fd_alloc+0x6a>
  802947:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80294b:	48 c1 e8 0c          	shr    $0xc,%rax
  80294f:	48 89 c2             	mov    %rax,%rdx
  802952:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802959:	01 00 00 
  80295c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802960:	83 e0 01             	and    $0x1,%eax
  802963:	48 85 c0             	test   %rax,%rax
  802966:	75 12                	jne    80297a <fd_alloc+0x7c>
			*fd_store = fd;
  802968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802970:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
  802978:	eb 1a                	jmp    802994 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80297a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80297e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802982:	7e 8f                	jle    802913 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802988:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80298f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802994:	c9                   	leaveq 
  802995:	c3                   	retq   

0000000000802996 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802996:	55                   	push   %rbp
  802997:	48 89 e5             	mov    %rsp,%rbp
  80299a:	48 83 ec 20          	sub    $0x20,%rsp
  80299e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8029a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029a9:	78 06                	js     8029b1 <fd_lookup+0x1b>
  8029ab:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8029af:	7e 07                	jle    8029b8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029b6:	eb 6c                	jmp    802a24 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8029b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029bb:	48 98                	cltq   
  8029bd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029c3:	48 c1 e0 0c          	shl    $0xc,%rax
  8029c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8029cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029cf:	48 c1 e8 15          	shr    $0x15,%rax
  8029d3:	48 89 c2             	mov    %rax,%rdx
  8029d6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029dd:	01 00 00 
  8029e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029e4:	83 e0 01             	and    $0x1,%eax
  8029e7:	48 85 c0             	test   %rax,%rax
  8029ea:	74 21                	je     802a0d <fd_lookup+0x77>
  8029ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029f0:	48 c1 e8 0c          	shr    $0xc,%rax
  8029f4:	48 89 c2             	mov    %rax,%rdx
  8029f7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029fe:	01 00 00 
  802a01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a05:	83 e0 01             	and    $0x1,%eax
  802a08:	48 85 c0             	test   %rax,%rax
  802a0b:	75 07                	jne    802a14 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802a0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a12:	eb 10                	jmp    802a24 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802a14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a18:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a1c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a24:	c9                   	leaveq 
  802a25:	c3                   	retq   

0000000000802a26 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802a26:	55                   	push   %rbp
  802a27:	48 89 e5             	mov    %rsp,%rbp
  802a2a:	48 83 ec 30          	sub    $0x30,%rsp
  802a2e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a32:	89 f0                	mov    %esi,%eax
  802a34:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a3b:	48 89 c7             	mov    %rax,%rdi
  802a3e:	48 b8 b0 28 80 00 00 	movabs $0x8028b0,%rax
  802a45:	00 00 00 
  802a48:	ff d0                	callq  *%rax
  802a4a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a4e:	48 89 d6             	mov    %rdx,%rsi
  802a51:	89 c7                	mov    %eax,%edi
  802a53:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  802a5a:	00 00 00 
  802a5d:	ff d0                	callq  *%rax
  802a5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a66:	78 0a                	js     802a72 <fd_close+0x4c>
	    || fd != fd2)
  802a68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802a70:	74 12                	je     802a84 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802a72:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802a76:	74 05                	je     802a7d <fd_close+0x57>
  802a78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7b:	eb 05                	jmp    802a82 <fd_close+0x5c>
  802a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a82:	eb 69                	jmp    802aed <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802a84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a88:	8b 00                	mov    (%rax),%eax
  802a8a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a8e:	48 89 d6             	mov    %rdx,%rsi
  802a91:	89 c7                	mov    %eax,%edi
  802a93:	48 b8 ef 2a 80 00 00 	movabs $0x802aef,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
  802a9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa6:	78 2a                	js     802ad2 <fd_close+0xac>
		if (dev->dev_close)
  802aa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aac:	48 8b 40 20          	mov    0x20(%rax),%rax
  802ab0:	48 85 c0             	test   %rax,%rax
  802ab3:	74 16                	je     802acb <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802ab5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab9:	48 8b 40 20          	mov    0x20(%rax),%rax
  802abd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ac1:	48 89 d7             	mov    %rdx,%rdi
  802ac4:	ff d0                	callq  *%rax
  802ac6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac9:	eb 07                	jmp    802ad2 <fd_close+0xac>
		else
			r = 0;
  802acb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802ad2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ad6:	48 89 c6             	mov    %rax,%rsi
  802ad9:	bf 00 00 00 00       	mov    $0x0,%edi
  802ade:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	callq  *%rax
	return r;
  802aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aed:	c9                   	leaveq 
  802aee:	c3                   	retq   

0000000000802aef <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802aef:	55                   	push   %rbp
  802af0:	48 89 e5             	mov    %rsp,%rbp
  802af3:	48 83 ec 20          	sub    $0x20,%rsp
  802af7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802afa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802afe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b05:	eb 41                	jmp    802b48 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802b07:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b0e:	00 00 00 
  802b11:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b14:	48 63 d2             	movslq %edx,%rdx
  802b17:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b1b:	8b 00                	mov    (%rax),%eax
  802b1d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802b20:	75 22                	jne    802b44 <dev_lookup+0x55>
			*dev = devtab[i];
  802b22:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b29:	00 00 00 
  802b2c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b2f:	48 63 d2             	movslq %edx,%rdx
  802b32:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802b36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b3a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b42:	eb 60                	jmp    802ba4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802b44:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b48:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b4f:	00 00 00 
  802b52:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b55:	48 63 d2             	movslq %edx,%rdx
  802b58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b5c:	48 85 c0             	test   %rax,%rax
  802b5f:	75 a6                	jne    802b07 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802b61:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b68:	00 00 00 
  802b6b:	48 8b 00             	mov    (%rax),%rax
  802b6e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b74:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b77:	89 c6                	mov    %eax,%esi
  802b79:	48 bf a0 49 80 00 00 	movabs $0x8049a0,%rdi
  802b80:	00 00 00 
  802b83:	b8 00 00 00 00       	mov    $0x0,%eax
  802b88:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  802b8f:	00 00 00 
  802b92:	ff d1                	callq  *%rcx
	*dev = 0;
  802b94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b98:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802b9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ba4:	c9                   	leaveq 
  802ba5:	c3                   	retq   

0000000000802ba6 <close>:

int
close(int fdnum)
{
  802ba6:	55                   	push   %rbp
  802ba7:	48 89 e5             	mov    %rsp,%rbp
  802baa:	48 83 ec 20          	sub    $0x20,%rsp
  802bae:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bb1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bb5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bb8:	48 89 d6             	mov    %rdx,%rsi
  802bbb:	89 c7                	mov    %eax,%edi
  802bbd:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	callq  *%rax
  802bc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd0:	79 05                	jns    802bd7 <close+0x31>
		return r;
  802bd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd5:	eb 18                	jmp    802bef <close+0x49>
	else
		return fd_close(fd, 1);
  802bd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bdb:	be 01 00 00 00       	mov    $0x1,%esi
  802be0:	48 89 c7             	mov    %rax,%rdi
  802be3:	48 b8 26 2a 80 00 00 	movabs $0x802a26,%rax
  802bea:	00 00 00 
  802bed:	ff d0                	callq  *%rax
}
  802bef:	c9                   	leaveq 
  802bf0:	c3                   	retq   

0000000000802bf1 <close_all>:

void
close_all(void)
{
  802bf1:	55                   	push   %rbp
  802bf2:	48 89 e5             	mov    %rsp,%rbp
  802bf5:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c00:	eb 15                	jmp    802c17 <close_all+0x26>
		close(i);
  802c02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c05:	89 c7                	mov    %eax,%edi
  802c07:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  802c0e:	00 00 00 
  802c11:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802c13:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c17:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802c1b:	7e e5                	jle    802c02 <close_all+0x11>
		close(i);
}
  802c1d:	c9                   	leaveq 
  802c1e:	c3                   	retq   

0000000000802c1f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802c1f:	55                   	push   %rbp
  802c20:	48 89 e5             	mov    %rsp,%rbp
  802c23:	48 83 ec 40          	sub    $0x40,%rsp
  802c27:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802c2a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802c2d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802c31:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802c34:	48 89 d6             	mov    %rdx,%rsi
  802c37:	89 c7                	mov    %eax,%edi
  802c39:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  802c40:	00 00 00 
  802c43:	ff d0                	callq  *%rax
  802c45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c4c:	79 08                	jns    802c56 <dup+0x37>
		return r;
  802c4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c51:	e9 70 01 00 00       	jmpq   802dc6 <dup+0x1a7>
	close(newfdnum);
  802c56:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c59:	89 c7                	mov    %eax,%edi
  802c5b:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  802c62:	00 00 00 
  802c65:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802c67:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c6a:	48 98                	cltq   
  802c6c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c72:	48 c1 e0 0c          	shl    $0xc,%rax
  802c76:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802c7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c7e:	48 89 c7             	mov    %rax,%rdi
  802c81:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  802c88:	00 00 00 
  802c8b:	ff d0                	callq  *%rax
  802c8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802c91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c95:	48 89 c7             	mov    %rax,%rdi
  802c98:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  802c9f:	00 00 00 
  802ca2:	ff d0                	callq  *%rax
  802ca4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802ca8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cac:	48 c1 e8 15          	shr    $0x15,%rax
  802cb0:	48 89 c2             	mov    %rax,%rdx
  802cb3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802cba:	01 00 00 
  802cbd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cc1:	83 e0 01             	and    $0x1,%eax
  802cc4:	48 85 c0             	test   %rax,%rax
  802cc7:	74 73                	je     802d3c <dup+0x11d>
  802cc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccd:	48 c1 e8 0c          	shr    $0xc,%rax
  802cd1:	48 89 c2             	mov    %rax,%rdx
  802cd4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cdb:	01 00 00 
  802cde:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ce2:	83 e0 01             	and    $0x1,%eax
  802ce5:	48 85 c0             	test   %rax,%rax
  802ce8:	74 52                	je     802d3c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802cea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cee:	48 c1 e8 0c          	shr    $0xc,%rax
  802cf2:	48 89 c2             	mov    %rax,%rdx
  802cf5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cfc:	01 00 00 
  802cff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d03:	25 07 0e 00 00       	and    $0xe07,%eax
  802d08:	89 c1                	mov    %eax,%ecx
  802d0a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d12:	41 89 c8             	mov    %ecx,%r8d
  802d15:	48 89 d1             	mov    %rdx,%rcx
  802d18:	ba 00 00 00 00       	mov    $0x0,%edx
  802d1d:	48 89 c6             	mov    %rax,%rsi
  802d20:	bf 00 00 00 00       	mov    $0x0,%edi
  802d25:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  802d2c:	00 00 00 
  802d2f:	ff d0                	callq  *%rax
  802d31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d38:	79 02                	jns    802d3c <dup+0x11d>
			goto err;
  802d3a:	eb 57                	jmp    802d93 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d40:	48 c1 e8 0c          	shr    $0xc,%rax
  802d44:	48 89 c2             	mov    %rax,%rdx
  802d47:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d4e:	01 00 00 
  802d51:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d55:	25 07 0e 00 00       	and    $0xe07,%eax
  802d5a:	89 c1                	mov    %eax,%ecx
  802d5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d64:	41 89 c8             	mov    %ecx,%r8d
  802d67:	48 89 d1             	mov    %rdx,%rcx
  802d6a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d6f:	48 89 c6             	mov    %rax,%rsi
  802d72:	bf 00 00 00 00       	mov    $0x0,%edi
  802d77:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  802d7e:	00 00 00 
  802d81:	ff d0                	callq  *%rax
  802d83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8a:	79 02                	jns    802d8e <dup+0x16f>
		goto err;
  802d8c:	eb 05                	jmp    802d93 <dup+0x174>

	return newfdnum;
  802d8e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d91:	eb 33                	jmp    802dc6 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d97:	48 89 c6             	mov    %rax,%rsi
  802d9a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d9f:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  802da6:	00 00 00 
  802da9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802dab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802daf:	48 89 c6             	mov    %rax,%rsi
  802db2:	bf 00 00 00 00       	mov    $0x0,%edi
  802db7:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  802dbe:	00 00 00 
  802dc1:	ff d0                	callq  *%rax
	return r;
  802dc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802dc6:	c9                   	leaveq 
  802dc7:	c3                   	retq   

0000000000802dc8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802dc8:	55                   	push   %rbp
  802dc9:	48 89 e5             	mov    %rsp,%rbp
  802dcc:	48 83 ec 40          	sub    $0x40,%rsp
  802dd0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dd3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802dd7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ddb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ddf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802de2:	48 89 d6             	mov    %rdx,%rsi
  802de5:	89 c7                	mov    %eax,%edi
  802de7:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  802dee:	00 00 00 
  802df1:	ff d0                	callq  *%rax
  802df3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dfa:	78 24                	js     802e20 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e00:	8b 00                	mov    (%rax),%eax
  802e02:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e06:	48 89 d6             	mov    %rdx,%rsi
  802e09:	89 c7                	mov    %eax,%edi
  802e0b:	48 b8 ef 2a 80 00 00 	movabs $0x802aef,%rax
  802e12:	00 00 00 
  802e15:	ff d0                	callq  *%rax
  802e17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1e:	79 05                	jns    802e25 <read+0x5d>
		return r;
  802e20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e23:	eb 76                	jmp    802e9b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e29:	8b 40 08             	mov    0x8(%rax),%eax
  802e2c:	83 e0 03             	and    $0x3,%eax
  802e2f:	83 f8 01             	cmp    $0x1,%eax
  802e32:	75 3a                	jne    802e6e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e34:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e3b:	00 00 00 
  802e3e:	48 8b 00             	mov    (%rax),%rax
  802e41:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e47:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e4a:	89 c6                	mov    %eax,%esi
  802e4c:	48 bf bf 49 80 00 00 	movabs $0x8049bf,%rdi
  802e53:	00 00 00 
  802e56:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5b:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  802e62:	00 00 00 
  802e65:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e6c:	eb 2d                	jmp    802e9b <read+0xd3>
	}
	if (!dev->dev_read)
  802e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e72:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e76:	48 85 c0             	test   %rax,%rax
  802e79:	75 07                	jne    802e82 <read+0xba>
		return -E_NOT_SUPP;
  802e7b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e80:	eb 19                	jmp    802e9b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e86:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e8a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e8e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e92:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e96:	48 89 cf             	mov    %rcx,%rdi
  802e99:	ff d0                	callq  *%rax
}
  802e9b:	c9                   	leaveq 
  802e9c:	c3                   	retq   

0000000000802e9d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e9d:	55                   	push   %rbp
  802e9e:	48 89 e5             	mov    %rsp,%rbp
  802ea1:	48 83 ec 30          	sub    $0x30,%rsp
  802ea5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ea8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802eac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802eb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802eb7:	eb 49                	jmp    802f02 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802eb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ebc:	48 98                	cltq   
  802ebe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ec2:	48 29 c2             	sub    %rax,%rdx
  802ec5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec8:	48 63 c8             	movslq %eax,%rcx
  802ecb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ecf:	48 01 c1             	add    %rax,%rcx
  802ed2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ed5:	48 89 ce             	mov    %rcx,%rsi
  802ed8:	89 c7                	mov    %eax,%edi
  802eda:	48 b8 c8 2d 80 00 00 	movabs $0x802dc8,%rax
  802ee1:	00 00 00 
  802ee4:	ff d0                	callq  *%rax
  802ee6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ee9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802eed:	79 05                	jns    802ef4 <readn+0x57>
			return m;
  802eef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ef2:	eb 1c                	jmp    802f10 <readn+0x73>
		if (m == 0)
  802ef4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ef8:	75 02                	jne    802efc <readn+0x5f>
			break;
  802efa:	eb 11                	jmp    802f0d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802efc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eff:	01 45 fc             	add    %eax,-0x4(%rbp)
  802f02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f05:	48 98                	cltq   
  802f07:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802f0b:	72 ac                	jb     802eb9 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802f0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f10:	c9                   	leaveq 
  802f11:	c3                   	retq   

0000000000802f12 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802f12:	55                   	push   %rbp
  802f13:	48 89 e5             	mov    %rsp,%rbp
  802f16:	48 83 ec 40          	sub    $0x40,%rsp
  802f1a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f21:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f25:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f29:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f2c:	48 89 d6             	mov    %rdx,%rsi
  802f2f:	89 c7                	mov    %eax,%edi
  802f31:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  802f38:	00 00 00 
  802f3b:	ff d0                	callq  *%rax
  802f3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f44:	78 24                	js     802f6a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4a:	8b 00                	mov    (%rax),%eax
  802f4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f50:	48 89 d6             	mov    %rdx,%rsi
  802f53:	89 c7                	mov    %eax,%edi
  802f55:	48 b8 ef 2a 80 00 00 	movabs $0x802aef,%rax
  802f5c:	00 00 00 
  802f5f:	ff d0                	callq  *%rax
  802f61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f68:	79 05                	jns    802f6f <write+0x5d>
		return r;
  802f6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f6d:	eb 42                	jmp    802fb1 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f73:	8b 40 08             	mov    0x8(%rax),%eax
  802f76:	83 e0 03             	and    $0x3,%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	75 07                	jne    802f84 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802f7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f82:	eb 2d                	jmp    802fb1 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802f84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f88:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f8c:	48 85 c0             	test   %rax,%rax
  802f8f:	75 07                	jne    802f98 <write+0x86>
		return -E_NOT_SUPP;
  802f91:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f96:	eb 19                	jmp    802fb1 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802f98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802fa0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fa4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fa8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fac:	48 89 cf             	mov    %rcx,%rdi
  802faf:	ff d0                	callq  *%rax
}
  802fb1:	c9                   	leaveq 
  802fb2:	c3                   	retq   

0000000000802fb3 <seek>:

int
seek(int fdnum, off_t offset)
{
  802fb3:	55                   	push   %rbp
  802fb4:	48 89 e5             	mov    %rsp,%rbp
  802fb7:	48 83 ec 18          	sub    $0x18,%rsp
  802fbb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fbe:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fc1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fc5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fc8:	48 89 d6             	mov    %rdx,%rsi
  802fcb:	89 c7                	mov    %eax,%edi
  802fcd:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  802fd4:	00 00 00 
  802fd7:	ff d0                	callq  *%rax
  802fd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe0:	79 05                	jns    802fe7 <seek+0x34>
		return r;
  802fe2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe5:	eb 0f                	jmp    802ff6 <seek+0x43>
	fd->fd_offset = offset;
  802fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802feb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fee:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ff1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff6:	c9                   	leaveq 
  802ff7:	c3                   	retq   

0000000000802ff8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ff8:	55                   	push   %rbp
  802ff9:	48 89 e5             	mov    %rsp,%rbp
  802ffc:	48 83 ec 30          	sub    $0x30,%rsp
  803000:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803003:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803006:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80300a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80300d:	48 89 d6             	mov    %rdx,%rsi
  803010:	89 c7                	mov    %eax,%edi
  803012:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  803019:	00 00 00 
  80301c:	ff d0                	callq  *%rax
  80301e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803021:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803025:	78 24                	js     80304b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803027:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302b:	8b 00                	mov    (%rax),%eax
  80302d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803031:	48 89 d6             	mov    %rdx,%rsi
  803034:	89 c7                	mov    %eax,%edi
  803036:	48 b8 ef 2a 80 00 00 	movabs $0x802aef,%rax
  80303d:	00 00 00 
  803040:	ff d0                	callq  *%rax
  803042:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803045:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803049:	79 05                	jns    803050 <ftruncate+0x58>
		return r;
  80304b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304e:	eb 72                	jmp    8030c2 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803054:	8b 40 08             	mov    0x8(%rax),%eax
  803057:	83 e0 03             	and    $0x3,%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	75 3a                	jne    803098 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80305e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803065:	00 00 00 
  803068:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80306b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803071:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803074:	89 c6                	mov    %eax,%esi
  803076:	48 bf e0 49 80 00 00 	movabs $0x8049e0,%rdi
  80307d:	00 00 00 
  803080:	b8 00 00 00 00       	mov    $0x0,%eax
  803085:	48 b9 ad 04 80 00 00 	movabs $0x8004ad,%rcx
  80308c:	00 00 00 
  80308f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803091:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803096:	eb 2a                	jmp    8030c2 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803098:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309c:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030a0:	48 85 c0             	test   %rax,%rax
  8030a3:	75 07                	jne    8030ac <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8030a5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030aa:	eb 16                	jmp    8030c2 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8030ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b0:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030b8:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8030bb:	89 ce                	mov    %ecx,%esi
  8030bd:	48 89 d7             	mov    %rdx,%rdi
  8030c0:	ff d0                	callq  *%rax
}
  8030c2:	c9                   	leaveq 
  8030c3:	c3                   	retq   

00000000008030c4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8030c4:	55                   	push   %rbp
  8030c5:	48 89 e5             	mov    %rsp,%rbp
  8030c8:	48 83 ec 30          	sub    $0x30,%rsp
  8030cc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030cf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030d3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030d7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030da:	48 89 d6             	mov    %rdx,%rsi
  8030dd:	89 c7                	mov    %eax,%edi
  8030df:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
  8030eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f2:	78 24                	js     803118 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f8:	8b 00                	mov    (%rax),%eax
  8030fa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030fe:	48 89 d6             	mov    %rdx,%rsi
  803101:	89 c7                	mov    %eax,%edi
  803103:	48 b8 ef 2a 80 00 00 	movabs $0x802aef,%rax
  80310a:	00 00 00 
  80310d:	ff d0                	callq  *%rax
  80310f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803112:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803116:	79 05                	jns    80311d <fstat+0x59>
		return r;
  803118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311b:	eb 5e                	jmp    80317b <fstat+0xb7>
	if (!dev->dev_stat)
  80311d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803121:	48 8b 40 28          	mov    0x28(%rax),%rax
  803125:	48 85 c0             	test   %rax,%rax
  803128:	75 07                	jne    803131 <fstat+0x6d>
		return -E_NOT_SUPP;
  80312a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80312f:	eb 4a                	jmp    80317b <fstat+0xb7>
	stat->st_name[0] = 0;
  803131:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803135:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803138:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80313c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803143:	00 00 00 
	stat->st_isdir = 0;
  803146:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80314a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803151:	00 00 00 
	stat->st_dev = dev;
  803154:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803158:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803163:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803167:	48 8b 40 28          	mov    0x28(%rax),%rax
  80316b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80316f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803173:	48 89 ce             	mov    %rcx,%rsi
  803176:	48 89 d7             	mov    %rdx,%rdi
  803179:	ff d0                	callq  *%rax
}
  80317b:	c9                   	leaveq 
  80317c:	c3                   	retq   

000000000080317d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80317d:	55                   	push   %rbp
  80317e:	48 89 e5             	mov    %rsp,%rbp
  803181:	48 83 ec 20          	sub    $0x20,%rsp
  803185:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803189:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80318d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803191:	be 00 00 00 00       	mov    $0x0,%esi
  803196:	48 89 c7             	mov    %rax,%rdi
  803199:	48 b8 6b 32 80 00 00 	movabs $0x80326b,%rax
  8031a0:	00 00 00 
  8031a3:	ff d0                	callq  *%rax
  8031a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ac:	79 05                	jns    8031b3 <stat+0x36>
		return fd;
  8031ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b1:	eb 2f                	jmp    8031e2 <stat+0x65>
	r = fstat(fd, stat);
  8031b3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ba:	48 89 d6             	mov    %rdx,%rsi
  8031bd:	89 c7                	mov    %eax,%edi
  8031bf:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  8031c6:	00 00 00 
  8031c9:	ff d0                	callq  *%rax
  8031cb:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8031ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d1:	89 c7                	mov    %eax,%edi
  8031d3:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  8031da:	00 00 00 
  8031dd:	ff d0                	callq  *%rax
	return r;
  8031df:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8031e2:	c9                   	leaveq 
  8031e3:	c3                   	retq   

00000000008031e4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8031e4:	55                   	push   %rbp
  8031e5:	48 89 e5             	mov    %rsp,%rbp
  8031e8:	48 83 ec 10          	sub    $0x10,%rsp
  8031ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8031f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8031fa:	00 00 00 
  8031fd:	8b 00                	mov    (%rax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	75 1d                	jne    803220 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803203:	bf 01 00 00 00       	mov    $0x1,%edi
  803208:	48 b8 3e 28 80 00 00 	movabs $0x80283e,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
  803214:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80321b:	00 00 00 
  80321e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803220:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803227:	00 00 00 
  80322a:	8b 00                	mov    (%rax),%eax
  80322c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80322f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803234:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80323b:	00 00 00 
  80323e:	89 c7                	mov    %eax,%edi
  803240:	48 b8 71 24 80 00 00 	movabs $0x802471,%rax
  803247:	00 00 00 
  80324a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80324c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803250:	ba 00 00 00 00       	mov    $0x0,%edx
  803255:	48 89 c6             	mov    %rax,%rsi
  803258:	bf 00 00 00 00       	mov    $0x0,%edi
  80325d:	48 b8 73 23 80 00 00 	movabs $0x802373,%rax
  803264:	00 00 00 
  803267:	ff d0                	callq  *%rax
}
  803269:	c9                   	leaveq 
  80326a:	c3                   	retq   

000000000080326b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80326b:	55                   	push   %rbp
  80326c:	48 89 e5             	mov    %rsp,%rbp
  80326f:	48 83 ec 30          	sub    $0x30,%rsp
  803273:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803277:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80327a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  803281:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  803288:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80328f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803294:	75 08                	jne    80329e <open+0x33>
	{
		return r;
  803296:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803299:	e9 f2 00 00 00       	jmpq   803390 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80329e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a2:	48 89 c7             	mov    %rax,%rdi
  8032a5:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  8032ac:	00 00 00 
  8032af:	ff d0                	callq  *%rax
  8032b1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8032b4:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8032bb:	7e 0a                	jle    8032c7 <open+0x5c>
	{
		return -E_BAD_PATH;
  8032bd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032c2:	e9 c9 00 00 00       	jmpq   803390 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8032c7:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8032ce:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8032cf:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8032d3:	48 89 c7             	mov    %rax,%rdi
  8032d6:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  8032dd:	00 00 00 
  8032e0:	ff d0                	callq  *%rax
  8032e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e9:	78 09                	js     8032f4 <open+0x89>
  8032eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ef:	48 85 c0             	test   %rax,%rax
  8032f2:	75 08                	jne    8032fc <open+0x91>
		{
			return r;
  8032f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f7:	e9 94 00 00 00       	jmpq   803390 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8032fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803300:	ba 00 04 00 00       	mov    $0x400,%edx
  803305:	48 89 c6             	mov    %rax,%rsi
  803308:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80330f:	00 00 00 
  803312:	48 b8 f4 10 80 00 00 	movabs $0x8010f4,%rax
  803319:	00 00 00 
  80331c:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80331e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803325:	00 00 00 
  803328:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80332b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803335:	48 89 c6             	mov    %rax,%rsi
  803338:	bf 01 00 00 00       	mov    $0x1,%edi
  80333d:	48 b8 e4 31 80 00 00 	movabs $0x8031e4,%rax
  803344:	00 00 00 
  803347:	ff d0                	callq  *%rax
  803349:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80334c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803350:	79 2b                	jns    80337d <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803352:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803356:	be 00 00 00 00       	mov    $0x0,%esi
  80335b:	48 89 c7             	mov    %rax,%rdi
  80335e:	48 b8 26 2a 80 00 00 	movabs $0x802a26,%rax
  803365:	00 00 00 
  803368:	ff d0                	callq  *%rax
  80336a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80336d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803371:	79 05                	jns    803378 <open+0x10d>
			{
				return d;
  803373:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803376:	eb 18                	jmp    803390 <open+0x125>
			}
			return r;
  803378:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337b:	eb 13                	jmp    803390 <open+0x125>
		}	
		return fd2num(fd_store);
  80337d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803381:	48 89 c7             	mov    %rax,%rdi
  803384:	48 b8 b0 28 80 00 00 	movabs $0x8028b0,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803390:	c9                   	leaveq 
  803391:	c3                   	retq   

0000000000803392 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803392:	55                   	push   %rbp
  803393:	48 89 e5             	mov    %rsp,%rbp
  803396:	48 83 ec 10          	sub    $0x10,%rsp
  80339a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80339e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a2:	8b 50 0c             	mov    0xc(%rax),%edx
  8033a5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033ac:	00 00 00 
  8033af:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8033b1:	be 00 00 00 00       	mov    $0x0,%esi
  8033b6:	bf 06 00 00 00       	mov    $0x6,%edi
  8033bb:	48 b8 e4 31 80 00 00 	movabs $0x8031e4,%rax
  8033c2:	00 00 00 
  8033c5:	ff d0                	callq  *%rax
}
  8033c7:	c9                   	leaveq 
  8033c8:	c3                   	retq   

00000000008033c9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8033c9:	55                   	push   %rbp
  8033ca:	48 89 e5             	mov    %rsp,%rbp
  8033cd:	48 83 ec 30          	sub    $0x30,%rsp
  8033d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8033dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8033e4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033e9:	74 07                	je     8033f2 <devfile_read+0x29>
  8033eb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033f0:	75 07                	jne    8033f9 <devfile_read+0x30>
		return -E_INVAL;
  8033f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8033f7:	eb 77                	jmp    803470 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8033f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033fd:	8b 50 0c             	mov    0xc(%rax),%edx
  803400:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803407:	00 00 00 
  80340a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80340c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803413:	00 00 00 
  803416:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80341a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80341e:	be 00 00 00 00       	mov    $0x0,%esi
  803423:	bf 03 00 00 00       	mov    $0x3,%edi
  803428:	48 b8 e4 31 80 00 00 	movabs $0x8031e4,%rax
  80342f:	00 00 00 
  803432:	ff d0                	callq  *%rax
  803434:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803437:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343b:	7f 05                	jg     803442 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80343d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803440:	eb 2e                	jmp    803470 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803442:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803445:	48 63 d0             	movslq %eax,%rdx
  803448:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80344c:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803453:	00 00 00 
  803456:	48 89 c7             	mov    %rax,%rdi
  803459:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  803460:	00 00 00 
  803463:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803465:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803469:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80346d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803470:	c9                   	leaveq 
  803471:	c3                   	retq   

0000000000803472 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803472:	55                   	push   %rbp
  803473:	48 89 e5             	mov    %rsp,%rbp
  803476:	48 83 ec 30          	sub    $0x30,%rsp
  80347a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80347e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803482:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803486:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80348d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803492:	74 07                	je     80349b <devfile_write+0x29>
  803494:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803499:	75 08                	jne    8034a3 <devfile_write+0x31>
		return r;
  80349b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349e:	e9 9a 00 00 00       	jmpq   80353d <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8034a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034a7:	8b 50 0c             	mov    0xc(%rax),%edx
  8034aa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034b1:	00 00 00 
  8034b4:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8034b6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8034bd:	00 
  8034be:	76 08                	jbe    8034c8 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8034c0:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8034c7:	00 
	}
	fsipcbuf.write.req_n = n;
  8034c8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034cf:	00 00 00 
  8034d2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034d6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8034da:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034e2:	48 89 c6             	mov    %rax,%rsi
  8034e5:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8034ec:	00 00 00 
  8034ef:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8034fb:	be 00 00 00 00       	mov    $0x0,%esi
  803500:	bf 04 00 00 00       	mov    $0x4,%edi
  803505:	48 b8 e4 31 80 00 00 	movabs $0x8031e4,%rax
  80350c:	00 00 00 
  80350f:	ff d0                	callq  *%rax
  803511:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803514:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803518:	7f 20                	jg     80353a <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80351a:	48 bf 06 4a 80 00 00 	movabs $0x804a06,%rdi
  803521:	00 00 00 
  803524:	b8 00 00 00 00       	mov    $0x0,%eax
  803529:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  803530:	00 00 00 
  803533:	ff d2                	callq  *%rdx
		return r;
  803535:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803538:	eb 03                	jmp    80353d <devfile_write+0xcb>
	}
	return r;
  80353a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80353d:	c9                   	leaveq 
  80353e:	c3                   	retq   

000000000080353f <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80353f:	55                   	push   %rbp
  803540:	48 89 e5             	mov    %rsp,%rbp
  803543:	48 83 ec 20          	sub    $0x20,%rsp
  803547:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80354b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80354f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803553:	8b 50 0c             	mov    0xc(%rax),%edx
  803556:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80355d:	00 00 00 
  803560:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803562:	be 00 00 00 00       	mov    $0x0,%esi
  803567:	bf 05 00 00 00       	mov    $0x5,%edi
  80356c:	48 b8 e4 31 80 00 00 	movabs $0x8031e4,%rax
  803573:	00 00 00 
  803576:	ff d0                	callq  *%rax
  803578:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80357b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80357f:	79 05                	jns    803586 <devfile_stat+0x47>
		return r;
  803581:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803584:	eb 56                	jmp    8035dc <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803586:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80358a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803591:	00 00 00 
  803594:	48 89 c7             	mov    %rax,%rdi
  803597:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  80359e:	00 00 00 
  8035a1:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8035a3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035aa:	00 00 00 
  8035ad:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8035b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8035bd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035c4:	00 00 00 
  8035c7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8035cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8035d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035dc:	c9                   	leaveq 
  8035dd:	c3                   	retq   

00000000008035de <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8035de:	55                   	push   %rbp
  8035df:	48 89 e5             	mov    %rsp,%rbp
  8035e2:	48 83 ec 10          	sub    $0x10,%rsp
  8035e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035ea:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8035ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f1:	8b 50 0c             	mov    0xc(%rax),%edx
  8035f4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035fb:	00 00 00 
  8035fe:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803600:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803607:	00 00 00 
  80360a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80360d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803610:	be 00 00 00 00       	mov    $0x0,%esi
  803615:	bf 02 00 00 00       	mov    $0x2,%edi
  80361a:	48 b8 e4 31 80 00 00 	movabs $0x8031e4,%rax
  803621:	00 00 00 
  803624:	ff d0                	callq  *%rax
}
  803626:	c9                   	leaveq 
  803627:	c3                   	retq   

0000000000803628 <remove>:

// Delete a file
int
remove(const char *path)
{
  803628:	55                   	push   %rbp
  803629:	48 89 e5             	mov    %rsp,%rbp
  80362c:	48 83 ec 10          	sub    $0x10,%rsp
  803630:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803638:	48 89 c7             	mov    %rax,%rdi
  80363b:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  803642:	00 00 00 
  803645:	ff d0                	callq  *%rax
  803647:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80364c:	7e 07                	jle    803655 <remove+0x2d>
		return -E_BAD_PATH;
  80364e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803653:	eb 33                	jmp    803688 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803659:	48 89 c6             	mov    %rax,%rsi
  80365c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803663:	00 00 00 
  803666:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  80366d:	00 00 00 
  803670:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803672:	be 00 00 00 00       	mov    $0x0,%esi
  803677:	bf 07 00 00 00       	mov    $0x7,%edi
  80367c:	48 b8 e4 31 80 00 00 	movabs $0x8031e4,%rax
  803683:	00 00 00 
  803686:	ff d0                	callq  *%rax
}
  803688:	c9                   	leaveq 
  803689:	c3                   	retq   

000000000080368a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80368a:	55                   	push   %rbp
  80368b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80368e:	be 00 00 00 00       	mov    $0x0,%esi
  803693:	bf 08 00 00 00       	mov    $0x8,%edi
  803698:	48 b8 e4 31 80 00 00 	movabs $0x8031e4,%rax
  80369f:	00 00 00 
  8036a2:	ff d0                	callq  *%rax
}
  8036a4:	5d                   	pop    %rbp
  8036a5:	c3                   	retq   

00000000008036a6 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8036a6:	55                   	push   %rbp
  8036a7:	48 89 e5             	mov    %rsp,%rbp
  8036aa:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8036b1:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8036b8:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8036bf:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8036c6:	be 00 00 00 00       	mov    $0x0,%esi
  8036cb:	48 89 c7             	mov    %rax,%rdi
  8036ce:	48 b8 6b 32 80 00 00 	movabs $0x80326b,%rax
  8036d5:	00 00 00 
  8036d8:	ff d0                	callq  *%rax
  8036da:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8036dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036e1:	79 28                	jns    80370b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8036e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e6:	89 c6                	mov    %eax,%esi
  8036e8:	48 bf 22 4a 80 00 00 	movabs $0x804a22,%rdi
  8036ef:	00 00 00 
  8036f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f7:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  8036fe:	00 00 00 
  803701:	ff d2                	callq  *%rdx
		return fd_src;
  803703:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803706:	e9 74 01 00 00       	jmpq   80387f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80370b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803712:	be 01 01 00 00       	mov    $0x101,%esi
  803717:	48 89 c7             	mov    %rax,%rdi
  80371a:	48 b8 6b 32 80 00 00 	movabs $0x80326b,%rax
  803721:	00 00 00 
  803724:	ff d0                	callq  *%rax
  803726:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803729:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80372d:	79 39                	jns    803768 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80372f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803732:	89 c6                	mov    %eax,%esi
  803734:	48 bf 38 4a 80 00 00 	movabs $0x804a38,%rdi
  80373b:	00 00 00 
  80373e:	b8 00 00 00 00       	mov    $0x0,%eax
  803743:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  80374a:	00 00 00 
  80374d:	ff d2                	callq  *%rdx
		close(fd_src);
  80374f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803752:	89 c7                	mov    %eax,%edi
  803754:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  80375b:	00 00 00 
  80375e:	ff d0                	callq  *%rax
		return fd_dest;
  803760:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803763:	e9 17 01 00 00       	jmpq   80387f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803768:	eb 74                	jmp    8037de <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80376a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80376d:	48 63 d0             	movslq %eax,%rdx
  803770:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803777:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80377a:	48 89 ce             	mov    %rcx,%rsi
  80377d:	89 c7                	mov    %eax,%edi
  80377f:	48 b8 12 2f 80 00 00 	movabs $0x802f12,%rax
  803786:	00 00 00 
  803789:	ff d0                	callq  *%rax
  80378b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80378e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803792:	79 4a                	jns    8037de <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803794:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803797:	89 c6                	mov    %eax,%esi
  803799:	48 bf 52 4a 80 00 00 	movabs $0x804a52,%rdi
  8037a0:	00 00 00 
  8037a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a8:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  8037af:	00 00 00 
  8037b2:	ff d2                	callq  *%rdx
			close(fd_src);
  8037b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b7:	89 c7                	mov    %eax,%edi
  8037b9:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  8037c0:	00 00 00 
  8037c3:	ff d0                	callq  *%rax
			close(fd_dest);
  8037c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037c8:	89 c7                	mov    %eax,%edi
  8037ca:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  8037d1:	00 00 00 
  8037d4:	ff d0                	callq  *%rax
			return write_size;
  8037d6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8037d9:	e9 a1 00 00 00       	jmpq   80387f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8037de:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8037e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e8:	ba 00 02 00 00       	mov    $0x200,%edx
  8037ed:	48 89 ce             	mov    %rcx,%rsi
  8037f0:	89 c7                	mov    %eax,%edi
  8037f2:	48 b8 c8 2d 80 00 00 	movabs $0x802dc8,%rax
  8037f9:	00 00 00 
  8037fc:	ff d0                	callq  *%rax
  8037fe:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803801:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803805:	0f 8f 5f ff ff ff    	jg     80376a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80380b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80380f:	79 47                	jns    803858 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803811:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803814:	89 c6                	mov    %eax,%esi
  803816:	48 bf 65 4a 80 00 00 	movabs $0x804a65,%rdi
  80381d:	00 00 00 
  803820:	b8 00 00 00 00       	mov    $0x0,%eax
  803825:	48 ba ad 04 80 00 00 	movabs $0x8004ad,%rdx
  80382c:	00 00 00 
  80382f:	ff d2                	callq  *%rdx
		close(fd_src);
  803831:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803834:	89 c7                	mov    %eax,%edi
  803836:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  80383d:	00 00 00 
  803840:	ff d0                	callq  *%rax
		close(fd_dest);
  803842:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803845:	89 c7                	mov    %eax,%edi
  803847:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  80384e:	00 00 00 
  803851:	ff d0                	callq  *%rax
		return read_size;
  803853:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803856:	eb 27                	jmp    80387f <copy+0x1d9>
	}
	close(fd_src);
  803858:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385b:	89 c7                	mov    %eax,%edi
  80385d:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  803864:	00 00 00 
  803867:	ff d0                	callq  *%rax
	close(fd_dest);
  803869:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80386c:	89 c7                	mov    %eax,%edi
  80386e:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  803875:	00 00 00 
  803878:	ff d0                	callq  *%rax
	return 0;
  80387a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80387f:	c9                   	leaveq 
  803880:	c3                   	retq   

0000000000803881 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803881:	55                   	push   %rbp
  803882:	48 89 e5             	mov    %rsp,%rbp
  803885:	53                   	push   %rbx
  803886:	48 83 ec 38          	sub    $0x38,%rsp
  80388a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80388e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803892:	48 89 c7             	mov    %rax,%rdi
  803895:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
  8038a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038a8:	0f 88 bf 01 00 00    	js     803a6d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b2:	ba 07 04 00 00       	mov    $0x407,%edx
  8038b7:	48 89 c6             	mov    %rax,%rsi
  8038ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8038bf:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  8038c6:	00 00 00 
  8038c9:	ff d0                	callq  *%rax
  8038cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038d2:	0f 88 95 01 00 00    	js     803a6d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8038d8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8038dc:	48 89 c7             	mov    %rax,%rdi
  8038df:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  8038e6:	00 00 00 
  8038e9:	ff d0                	callq  *%rax
  8038eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038f2:	0f 88 5d 01 00 00    	js     803a55 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038fc:	ba 07 04 00 00       	mov    $0x407,%edx
  803901:	48 89 c6             	mov    %rax,%rsi
  803904:	bf 00 00 00 00       	mov    $0x0,%edi
  803909:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  803910:	00 00 00 
  803913:	ff d0                	callq  *%rax
  803915:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803918:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80391c:	0f 88 33 01 00 00    	js     803a55 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803922:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803926:	48 89 c7             	mov    %rax,%rdi
  803929:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  803930:	00 00 00 
  803933:	ff d0                	callq  *%rax
  803935:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803939:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80393d:	ba 07 04 00 00       	mov    $0x407,%edx
  803942:	48 89 c6             	mov    %rax,%rsi
  803945:	bf 00 00 00 00       	mov    $0x0,%edi
  80394a:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  803951:	00 00 00 
  803954:	ff d0                	callq  *%rax
  803956:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803959:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80395d:	79 05                	jns    803964 <pipe+0xe3>
		goto err2;
  80395f:	e9 d9 00 00 00       	jmpq   803a3d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803964:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803968:	48 89 c7             	mov    %rax,%rdi
  80396b:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  803972:	00 00 00 
  803975:	ff d0                	callq  *%rax
  803977:	48 89 c2             	mov    %rax,%rdx
  80397a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80397e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803984:	48 89 d1             	mov    %rdx,%rcx
  803987:	ba 00 00 00 00       	mov    $0x0,%edx
  80398c:	48 89 c6             	mov    %rax,%rsi
  80398f:	bf 00 00 00 00       	mov    $0x0,%edi
  803994:	48 b8 e1 19 80 00 00 	movabs $0x8019e1,%rax
  80399b:	00 00 00 
  80399e:	ff d0                	callq  *%rax
  8039a0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039a7:	79 1b                	jns    8039c4 <pipe+0x143>
		goto err3;
  8039a9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8039aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ae:	48 89 c6             	mov    %rax,%rsi
  8039b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b6:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  8039bd:	00 00 00 
  8039c0:	ff d0                	callq  *%rax
  8039c2:	eb 79                	jmp    803a3d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8039c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039cf:	00 00 00 
  8039d2:	8b 12                	mov    (%rdx),%edx
  8039d4:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8039d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8039e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e5:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039ec:	00 00 00 
  8039ef:	8b 12                	mov    (%rdx),%edx
  8039f1:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8039f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8039fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a02:	48 89 c7             	mov    %rax,%rdi
  803a05:	48 b8 b0 28 80 00 00 	movabs $0x8028b0,%rax
  803a0c:	00 00 00 
  803a0f:	ff d0                	callq  *%rax
  803a11:	89 c2                	mov    %eax,%edx
  803a13:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a17:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803a19:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a1d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803a21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a25:	48 89 c7             	mov    %rax,%rdi
  803a28:	48 b8 b0 28 80 00 00 	movabs $0x8028b0,%rax
  803a2f:	00 00 00 
  803a32:	ff d0                	callq  *%rax
  803a34:	89 03                	mov    %eax,(%rbx)
	return 0;
  803a36:	b8 00 00 00 00       	mov    $0x0,%eax
  803a3b:	eb 33                	jmp    803a70 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803a3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a41:	48 89 c6             	mov    %rax,%rsi
  803a44:	bf 00 00 00 00       	mov    $0x0,%edi
  803a49:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  803a50:	00 00 00 
  803a53:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a59:	48 89 c6             	mov    %rax,%rsi
  803a5c:	bf 00 00 00 00       	mov    $0x0,%edi
  803a61:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  803a68:	00 00 00 
  803a6b:	ff d0                	callq  *%rax
err:
	return r;
  803a6d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a70:	48 83 c4 38          	add    $0x38,%rsp
  803a74:	5b                   	pop    %rbx
  803a75:	5d                   	pop    %rbp
  803a76:	c3                   	retq   

0000000000803a77 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a77:	55                   	push   %rbp
  803a78:	48 89 e5             	mov    %rsp,%rbp
  803a7b:	53                   	push   %rbx
  803a7c:	48 83 ec 28          	sub    $0x28,%rsp
  803a80:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a84:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a88:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a8f:	00 00 00 
  803a92:	48 8b 00             	mov    (%rax),%rax
  803a95:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a9b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa2:	48 89 c7             	mov    %rax,%rdi
  803aa5:	48 b8 3d 42 80 00 00 	movabs $0x80423d,%rax
  803aac:	00 00 00 
  803aaf:	ff d0                	callq  *%rax
  803ab1:	89 c3                	mov    %eax,%ebx
  803ab3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ab7:	48 89 c7             	mov    %rax,%rdi
  803aba:	48 b8 3d 42 80 00 00 	movabs $0x80423d,%rax
  803ac1:	00 00 00 
  803ac4:	ff d0                	callq  *%rax
  803ac6:	39 c3                	cmp    %eax,%ebx
  803ac8:	0f 94 c0             	sete   %al
  803acb:	0f b6 c0             	movzbl %al,%eax
  803ace:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803ad1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ad8:	00 00 00 
  803adb:	48 8b 00             	mov    (%rax),%rax
  803ade:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ae4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803ae7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aea:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803aed:	75 05                	jne    803af4 <_pipeisclosed+0x7d>
			return ret;
  803aef:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803af2:	eb 4f                	jmp    803b43 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803af4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803afa:	74 42                	je     803b3e <_pipeisclosed+0xc7>
  803afc:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803b00:	75 3c                	jne    803b3e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803b02:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b09:	00 00 00 
  803b0c:	48 8b 00             	mov    (%rax),%rax
  803b0f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803b15:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b18:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b1b:	89 c6                	mov    %eax,%esi
  803b1d:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  803b24:	00 00 00 
  803b27:	b8 00 00 00 00       	mov    $0x0,%eax
  803b2c:	49 b8 ad 04 80 00 00 	movabs $0x8004ad,%r8
  803b33:	00 00 00 
  803b36:	41 ff d0             	callq  *%r8
	}
  803b39:	e9 4a ff ff ff       	jmpq   803a88 <_pipeisclosed+0x11>
  803b3e:	e9 45 ff ff ff       	jmpq   803a88 <_pipeisclosed+0x11>
}
  803b43:	48 83 c4 28          	add    $0x28,%rsp
  803b47:	5b                   	pop    %rbx
  803b48:	5d                   	pop    %rbp
  803b49:	c3                   	retq   

0000000000803b4a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803b4a:	55                   	push   %rbp
  803b4b:	48 89 e5             	mov    %rsp,%rbp
  803b4e:	48 83 ec 30          	sub    $0x30,%rsp
  803b52:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b55:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b59:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b5c:	48 89 d6             	mov    %rdx,%rsi
  803b5f:	89 c7                	mov    %eax,%edi
  803b61:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  803b68:	00 00 00 
  803b6b:	ff d0                	callq  *%rax
  803b6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b74:	79 05                	jns    803b7b <pipeisclosed+0x31>
		return r;
  803b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b79:	eb 31                	jmp    803bac <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803b7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b7f:	48 89 c7             	mov    %rax,%rdi
  803b82:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  803b89:	00 00 00 
  803b8c:	ff d0                	callq  *%rax
  803b8e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803b92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b96:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b9a:	48 89 d6             	mov    %rdx,%rsi
  803b9d:	48 89 c7             	mov    %rax,%rdi
  803ba0:	48 b8 77 3a 80 00 00 	movabs $0x803a77,%rax
  803ba7:	00 00 00 
  803baa:	ff d0                	callq  *%rax
}
  803bac:	c9                   	leaveq 
  803bad:	c3                   	retq   

0000000000803bae <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bae:	55                   	push   %rbp
  803baf:	48 89 e5             	mov    %rsp,%rbp
  803bb2:	48 83 ec 40          	sub    $0x40,%rsp
  803bb6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803bba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803bbe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803bc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc6:	48 89 c7             	mov    %rax,%rdi
  803bc9:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  803bd0:	00 00 00 
  803bd3:	ff d0                	callq  *%rax
  803bd5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803bd9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bdd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803be1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803be8:	00 
  803be9:	e9 92 00 00 00       	jmpq   803c80 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803bee:	eb 41                	jmp    803c31 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803bf0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803bf5:	74 09                	je     803c00 <devpipe_read+0x52>
				return i;
  803bf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bfb:	e9 92 00 00 00       	jmpq   803c92 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803c00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c08:	48 89 d6             	mov    %rdx,%rsi
  803c0b:	48 89 c7             	mov    %rax,%rdi
  803c0e:	48 b8 77 3a 80 00 00 	movabs $0x803a77,%rax
  803c15:	00 00 00 
  803c18:	ff d0                	callq  *%rax
  803c1a:	85 c0                	test   %eax,%eax
  803c1c:	74 07                	je     803c25 <devpipe_read+0x77>
				return 0;
  803c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c23:	eb 6d                	jmp    803c92 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803c25:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  803c2c:	00 00 00 
  803c2f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c35:	8b 10                	mov    (%rax),%edx
  803c37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3b:	8b 40 04             	mov    0x4(%rax),%eax
  803c3e:	39 c2                	cmp    %eax,%edx
  803c40:	74 ae                	je     803bf0 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c46:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c4a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c52:	8b 00                	mov    (%rax),%eax
  803c54:	99                   	cltd   
  803c55:	c1 ea 1b             	shr    $0x1b,%edx
  803c58:	01 d0                	add    %edx,%eax
  803c5a:	83 e0 1f             	and    $0x1f,%eax
  803c5d:	29 d0                	sub    %edx,%eax
  803c5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c63:	48 98                	cltq   
  803c65:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803c6a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803c6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c70:	8b 00                	mov    (%rax),%eax
  803c72:	8d 50 01             	lea    0x1(%rax),%edx
  803c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c79:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c7b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c84:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c88:	0f 82 60 ff ff ff    	jb     803bee <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803c8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c92:	c9                   	leaveq 
  803c93:	c3                   	retq   

0000000000803c94 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c94:	55                   	push   %rbp
  803c95:	48 89 e5             	mov    %rsp,%rbp
  803c98:	48 83 ec 40          	sub    $0x40,%rsp
  803c9c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ca0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ca4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803ca8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cac:	48 89 c7             	mov    %rax,%rdi
  803caf:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  803cb6:	00 00 00 
  803cb9:	ff d0                	callq  *%rax
  803cbb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803cbf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cc3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803cc7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cce:	00 
  803ccf:	e9 8e 00 00 00       	jmpq   803d62 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803cd4:	eb 31                	jmp    803d07 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803cd6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cde:	48 89 d6             	mov    %rdx,%rsi
  803ce1:	48 89 c7             	mov    %rax,%rdi
  803ce4:	48 b8 77 3a 80 00 00 	movabs $0x803a77,%rax
  803ceb:	00 00 00 
  803cee:	ff d0                	callq  *%rax
  803cf0:	85 c0                	test   %eax,%eax
  803cf2:	74 07                	je     803cfb <devpipe_write+0x67>
				return 0;
  803cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf9:	eb 79                	jmp    803d74 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803cfb:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  803d02:	00 00 00 
  803d05:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d0b:	8b 40 04             	mov    0x4(%rax),%eax
  803d0e:	48 63 d0             	movslq %eax,%rdx
  803d11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d15:	8b 00                	mov    (%rax),%eax
  803d17:	48 98                	cltq   
  803d19:	48 83 c0 20          	add    $0x20,%rax
  803d1d:	48 39 c2             	cmp    %rax,%rdx
  803d20:	73 b4                	jae    803cd6 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803d22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d26:	8b 40 04             	mov    0x4(%rax),%eax
  803d29:	99                   	cltd   
  803d2a:	c1 ea 1b             	shr    $0x1b,%edx
  803d2d:	01 d0                	add    %edx,%eax
  803d2f:	83 e0 1f             	and    $0x1f,%eax
  803d32:	29 d0                	sub    %edx,%eax
  803d34:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d38:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d3c:	48 01 ca             	add    %rcx,%rdx
  803d3f:	0f b6 0a             	movzbl (%rdx),%ecx
  803d42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d46:	48 98                	cltq   
  803d48:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803d4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d50:	8b 40 04             	mov    0x4(%rax),%eax
  803d53:	8d 50 01             	lea    0x1(%rax),%edx
  803d56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d5d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d66:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d6a:	0f 82 64 ff ff ff    	jb     803cd4 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803d70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d74:	c9                   	leaveq 
  803d75:	c3                   	retq   

0000000000803d76 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803d76:	55                   	push   %rbp
  803d77:	48 89 e5             	mov    %rsp,%rbp
  803d7a:	48 83 ec 20          	sub    $0x20,%rsp
  803d7e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d82:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803d86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d8a:	48 89 c7             	mov    %rax,%rdi
  803d8d:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  803d94:	00 00 00 
  803d97:	ff d0                	callq  *%rax
  803d99:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803da1:	48 be 98 4a 80 00 00 	movabs $0x804a98,%rsi
  803da8:	00 00 00 
  803dab:	48 89 c7             	mov    %rax,%rdi
  803dae:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  803db5:	00 00 00 
  803db8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803dba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dbe:	8b 50 04             	mov    0x4(%rax),%edx
  803dc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dc5:	8b 00                	mov    (%rax),%eax
  803dc7:	29 c2                	sub    %eax,%edx
  803dc9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dcd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803dd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dd7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803dde:	00 00 00 
	stat->st_dev = &devpipe;
  803de1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de5:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803dec:	00 00 00 
  803def:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803df6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dfb:	c9                   	leaveq 
  803dfc:	c3                   	retq   

0000000000803dfd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803dfd:	55                   	push   %rbp
  803dfe:	48 89 e5             	mov    %rsp,%rbp
  803e01:	48 83 ec 10          	sub    $0x10,%rsp
  803e05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803e09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e0d:	48 89 c6             	mov    %rax,%rsi
  803e10:	bf 00 00 00 00       	mov    $0x0,%edi
  803e15:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  803e1c:	00 00 00 
  803e1f:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803e21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e25:	48 89 c7             	mov    %rax,%rdi
  803e28:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  803e2f:	00 00 00 
  803e32:	ff d0                	callq  *%rax
  803e34:	48 89 c6             	mov    %rax,%rsi
  803e37:	bf 00 00 00 00       	mov    $0x0,%edi
  803e3c:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  803e43:	00 00 00 
  803e46:	ff d0                	callq  *%rax
}
  803e48:	c9                   	leaveq 
  803e49:	c3                   	retq   

0000000000803e4a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803e4a:	55                   	push   %rbp
  803e4b:	48 89 e5             	mov    %rsp,%rbp
  803e4e:	48 83 ec 20          	sub    $0x20,%rsp
  803e52:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803e55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e58:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803e5b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803e5f:	be 01 00 00 00       	mov    $0x1,%esi
  803e64:	48 89 c7             	mov    %rax,%rdi
  803e67:	48 b8 49 18 80 00 00 	movabs $0x801849,%rax
  803e6e:	00 00 00 
  803e71:	ff d0                	callq  *%rax
}
  803e73:	c9                   	leaveq 
  803e74:	c3                   	retq   

0000000000803e75 <getchar>:

int
getchar(void)
{
  803e75:	55                   	push   %rbp
  803e76:	48 89 e5             	mov    %rsp,%rbp
  803e79:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e7d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803e81:	ba 01 00 00 00       	mov    $0x1,%edx
  803e86:	48 89 c6             	mov    %rax,%rsi
  803e89:	bf 00 00 00 00       	mov    $0x0,%edi
  803e8e:	48 b8 c8 2d 80 00 00 	movabs $0x802dc8,%rax
  803e95:	00 00 00 
  803e98:	ff d0                	callq  *%rax
  803e9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea1:	79 05                	jns    803ea8 <getchar+0x33>
		return r;
  803ea3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea6:	eb 14                	jmp    803ebc <getchar+0x47>
	if (r < 1)
  803ea8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eac:	7f 07                	jg     803eb5 <getchar+0x40>
		return -E_EOF;
  803eae:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803eb3:	eb 07                	jmp    803ebc <getchar+0x47>
	return c;
  803eb5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803eb9:	0f b6 c0             	movzbl %al,%eax
}
  803ebc:	c9                   	leaveq 
  803ebd:	c3                   	retq   

0000000000803ebe <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803ebe:	55                   	push   %rbp
  803ebf:	48 89 e5             	mov    %rsp,%rbp
  803ec2:	48 83 ec 20          	sub    $0x20,%rsp
  803ec6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ec9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ecd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ed0:	48 89 d6             	mov    %rdx,%rsi
  803ed3:	89 c7                	mov    %eax,%edi
  803ed5:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  803edc:	00 00 00 
  803edf:	ff d0                	callq  *%rax
  803ee1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ee4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee8:	79 05                	jns    803eef <iscons+0x31>
		return r;
  803eea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eed:	eb 1a                	jmp    803f09 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ef3:	8b 10                	mov    (%rax),%edx
  803ef5:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803efc:	00 00 00 
  803eff:	8b 00                	mov    (%rax),%eax
  803f01:	39 c2                	cmp    %eax,%edx
  803f03:	0f 94 c0             	sete   %al
  803f06:	0f b6 c0             	movzbl %al,%eax
}
  803f09:	c9                   	leaveq 
  803f0a:	c3                   	retq   

0000000000803f0b <opencons>:

int
opencons(void)
{
  803f0b:	55                   	push   %rbp
  803f0c:	48 89 e5             	mov    %rsp,%rbp
  803f0f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803f13:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f17:	48 89 c7             	mov    %rax,%rdi
  803f1a:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  803f21:	00 00 00 
  803f24:	ff d0                	callq  *%rax
  803f26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f2d:	79 05                	jns    803f34 <opencons+0x29>
		return r;
  803f2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f32:	eb 5b                	jmp    803f8f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803f34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f38:	ba 07 04 00 00       	mov    $0x407,%edx
  803f3d:	48 89 c6             	mov    %rax,%rsi
  803f40:	bf 00 00 00 00       	mov    $0x0,%edi
  803f45:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  803f4c:	00 00 00 
  803f4f:	ff d0                	callq  *%rax
  803f51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f58:	79 05                	jns    803f5f <opencons+0x54>
		return r;
  803f5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5d:	eb 30                	jmp    803f8f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803f5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f63:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803f6a:	00 00 00 
  803f6d:	8b 12                	mov    (%rdx),%edx
  803f6f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803f71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f75:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803f7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f80:	48 89 c7             	mov    %rax,%rdi
  803f83:	48 b8 b0 28 80 00 00 	movabs $0x8028b0,%rax
  803f8a:	00 00 00 
  803f8d:	ff d0                	callq  *%rax
}
  803f8f:	c9                   	leaveq 
  803f90:	c3                   	retq   

0000000000803f91 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f91:	55                   	push   %rbp
  803f92:	48 89 e5             	mov    %rsp,%rbp
  803f95:	48 83 ec 30          	sub    $0x30,%rsp
  803f99:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f9d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fa1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803fa5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803faa:	75 07                	jne    803fb3 <devcons_read+0x22>
		return 0;
  803fac:	b8 00 00 00 00       	mov    $0x0,%eax
  803fb1:	eb 4b                	jmp    803ffe <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803fb3:	eb 0c                	jmp    803fc1 <devcons_read+0x30>
		sys_yield();
  803fb5:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  803fbc:	00 00 00 
  803fbf:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803fc1:	48 b8 93 18 80 00 00 	movabs $0x801893,%rax
  803fc8:	00 00 00 
  803fcb:	ff d0                	callq  *%rax
  803fcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd4:	74 df                	je     803fb5 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803fd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fda:	79 05                	jns    803fe1 <devcons_read+0x50>
		return c;
  803fdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fdf:	eb 1d                	jmp    803ffe <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803fe1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803fe5:	75 07                	jne    803fee <devcons_read+0x5d>
		return 0;
  803fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fec:	eb 10                	jmp    803ffe <devcons_read+0x6d>
	*(char*)vbuf = c;
  803fee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ff1:	89 c2                	mov    %eax,%edx
  803ff3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ff7:	88 10                	mov    %dl,(%rax)
	return 1;
  803ff9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ffe:	c9                   	leaveq 
  803fff:	c3                   	retq   

0000000000804000 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804000:	55                   	push   %rbp
  804001:	48 89 e5             	mov    %rsp,%rbp
  804004:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80400b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804012:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804019:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804020:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804027:	eb 76                	jmp    80409f <devcons_write+0x9f>
		m = n - tot;
  804029:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804030:	89 c2                	mov    %eax,%edx
  804032:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804035:	29 c2                	sub    %eax,%edx
  804037:	89 d0                	mov    %edx,%eax
  804039:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80403c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80403f:	83 f8 7f             	cmp    $0x7f,%eax
  804042:	76 07                	jbe    80404b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804044:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80404b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80404e:	48 63 d0             	movslq %eax,%rdx
  804051:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804054:	48 63 c8             	movslq %eax,%rcx
  804057:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80405e:	48 01 c1             	add    %rax,%rcx
  804061:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804068:	48 89 ce             	mov    %rcx,%rsi
  80406b:	48 89 c7             	mov    %rax,%rdi
  80406e:	48 b8 86 13 80 00 00 	movabs $0x801386,%rax
  804075:	00 00 00 
  804078:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80407a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80407d:	48 63 d0             	movslq %eax,%rdx
  804080:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804087:	48 89 d6             	mov    %rdx,%rsi
  80408a:	48 89 c7             	mov    %rax,%rdi
  80408d:	48 b8 49 18 80 00 00 	movabs $0x801849,%rax
  804094:	00 00 00 
  804097:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804099:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80409c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80409f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a2:	48 98                	cltq   
  8040a4:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8040ab:	0f 82 78 ff ff ff    	jb     804029 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8040b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8040b4:	c9                   	leaveq 
  8040b5:	c3                   	retq   

00000000008040b6 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8040b6:	55                   	push   %rbp
  8040b7:	48 89 e5             	mov    %rsp,%rbp
  8040ba:	48 83 ec 08          	sub    $0x8,%rsp
  8040be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8040c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040c7:	c9                   	leaveq 
  8040c8:	c3                   	retq   

00000000008040c9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8040c9:	55                   	push   %rbp
  8040ca:	48 89 e5             	mov    %rsp,%rbp
  8040cd:	48 83 ec 10          	sub    $0x10,%rsp
  8040d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8040d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8040d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040dd:	48 be a4 4a 80 00 00 	movabs $0x804aa4,%rsi
  8040e4:	00 00 00 
  8040e7:	48 89 c7             	mov    %rax,%rdi
  8040ea:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  8040f1:	00 00 00 
  8040f4:	ff d0                	callq  *%rax
	return 0;
  8040f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040fb:	c9                   	leaveq 
  8040fc:	c3                   	retq   

00000000008040fd <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8040fd:	55                   	push   %rbp
  8040fe:	48 89 e5             	mov    %rsp,%rbp
  804101:	48 83 ec 10          	sub    $0x10,%rsp
  804105:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804109:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804110:	00 00 00 
  804113:	48 8b 00             	mov    (%rax),%rax
  804116:	48 85 c0             	test   %rax,%rax
  804119:	0f 85 84 00 00 00    	jne    8041a3 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80411f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804126:	00 00 00 
  804129:	48 8b 00             	mov    (%rax),%rax
  80412c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804132:	ba 07 00 00 00       	mov    $0x7,%edx
  804137:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80413c:	89 c7                	mov    %eax,%edi
  80413e:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  804145:	00 00 00 
  804148:	ff d0                	callq  *%rax
  80414a:	85 c0                	test   %eax,%eax
  80414c:	79 2a                	jns    804178 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80414e:	48 ba b0 4a 80 00 00 	movabs $0x804ab0,%rdx
  804155:	00 00 00 
  804158:	be 23 00 00 00       	mov    $0x23,%esi
  80415d:	48 bf d7 4a 80 00 00 	movabs $0x804ad7,%rdi
  804164:	00 00 00 
  804167:	b8 00 00 00 00       	mov    $0x0,%eax
  80416c:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  804173:	00 00 00 
  804176:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804178:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80417f:	00 00 00 
  804182:	48 8b 00             	mov    (%rax),%rax
  804185:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80418b:	48 be b6 41 80 00 00 	movabs $0x8041b6,%rsi
  804192:	00 00 00 
  804195:	89 c7                	mov    %eax,%edi
  804197:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  80419e:	00 00 00 
  8041a1:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8041a3:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8041aa:	00 00 00 
  8041ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8041b1:	48 89 10             	mov    %rdx,(%rax)
}
  8041b4:	c9                   	leaveq 
  8041b5:	c3                   	retq   

00000000008041b6 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8041b6:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8041b9:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  8041c0:	00 00 00 
call *%rax
  8041c3:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  8041c5:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8041cc:	00 
movq 152(%rsp), %rcx  //Load RSP
  8041cd:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8041d4:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  8041d5:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  8041d9:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  8041dc:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8041e3:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  8041e4:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  8041e8:	4c 8b 3c 24          	mov    (%rsp),%r15
  8041ec:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8041f1:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8041f6:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8041fb:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804200:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804205:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80420a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80420f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804214:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804219:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80421e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804223:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804228:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80422d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804232:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  804236:	48 83 c4 08          	add    $0x8,%rsp
popfq
  80423a:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  80423b:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  80423c:	c3                   	retq   

000000000080423d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80423d:	55                   	push   %rbp
  80423e:	48 89 e5             	mov    %rsp,%rbp
  804241:	48 83 ec 18          	sub    $0x18,%rsp
  804245:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80424d:	48 c1 e8 15          	shr    $0x15,%rax
  804251:	48 89 c2             	mov    %rax,%rdx
  804254:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80425b:	01 00 00 
  80425e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804262:	83 e0 01             	and    $0x1,%eax
  804265:	48 85 c0             	test   %rax,%rax
  804268:	75 07                	jne    804271 <pageref+0x34>
		return 0;
  80426a:	b8 00 00 00 00       	mov    $0x0,%eax
  80426f:	eb 53                	jmp    8042c4 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804271:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804275:	48 c1 e8 0c          	shr    $0xc,%rax
  804279:	48 89 c2             	mov    %rax,%rdx
  80427c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804283:	01 00 00 
  804286:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80428a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80428e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804292:	83 e0 01             	and    $0x1,%eax
  804295:	48 85 c0             	test   %rax,%rax
  804298:	75 07                	jne    8042a1 <pageref+0x64>
		return 0;
  80429a:	b8 00 00 00 00       	mov    $0x0,%eax
  80429f:	eb 23                	jmp    8042c4 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8042a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042a5:	48 c1 e8 0c          	shr    $0xc,%rax
  8042a9:	48 89 c2             	mov    %rax,%rdx
  8042ac:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8042b3:	00 00 00 
  8042b6:	48 c1 e2 04          	shl    $0x4,%rdx
  8042ba:	48 01 d0             	add    %rdx,%rax
  8042bd:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8042c1:	0f b7 c0             	movzwl %ax,%eax
}
  8042c4:	c9                   	leaveq 
  8042c5:	c3                   	retq   
