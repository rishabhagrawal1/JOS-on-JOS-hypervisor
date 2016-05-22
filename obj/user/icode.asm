
obj/user/icode:     file format elf64-x86-64


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
  80003c:	e8 21 02 00 00       	callq  800262 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#define MOTD "/motd"
#endif

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 28 02 00 00 	sub    $0x228,%rsp
  80004f:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
  800055:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80005c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800063:	00 00 00 
  800066:	48 bb a0 44 80 00 00 	movabs $0x8044a0,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	cprintf("icode startup\n");
  800073:	48 bf a6 44 80 00 00 	movabs $0x8044a6,%rdi
  80007a:	00 00 00 
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800089:	00 00 00 
  80008c:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008e:	48 bf b5 44 80 00 00 	movabs $0x8044b5,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  8000a4:	00 00 00 
  8000a7:	ff d2                	callq  *%rdx
	if ((fd = open(MOTD, O_RDONLY)) < 0)
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	48 bf c8 44 80 00 00 	movabs $0x8044c8,%rdi
  8000b5:	00 00 00 
  8000b8:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("icode: open /motd: %e", fd);
  8000cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba ce 44 80 00 00 	movabs $0x8044ce,%rdx
  8000d9:	00 00 00 
  8000dc:	be 15 00 00 00       	mov    $0x15,%esi
  8000e1:	48 bf e4 44 80 00 00 	movabs $0x8044e4,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fd:	48 bf f1 44 80 00 00 	movabs $0x8044f1,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800113:	00 00 00 
  800116:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800118:	eb 3a                	jmp    800154 <umain+0x111>
		cprintf("Writing MOTD\n");
  80011a:	48 bf 04 45 80 00 00 	movabs $0x804504,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
		sys_cputs(buf, n);
  800135:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800138:	48 63 d0             	movslq %eax,%rdx
  80013b:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
  800142:	48 89 d6             	mov    %rdx,%rsi
  800145:	48 89 c7             	mov    %rax,%rdi
  800148:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
	cprintf("icode: open /motd\n");
	if ((fd = open(MOTD, O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800154:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
  80015b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80015e:	ba 00 02 00 00       	mov    $0x200,%edx
  800163:	48 89 ce             	mov    %rcx,%rsi
  800166:	89 c7                	mov    %eax,%edi
  800168:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  80016f:	00 00 00 
  800172:	ff d0                	callq  *%rax
  800174:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800177:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80017b:	7f 9d                	jg     80011a <umain+0xd7>
		cprintf("Writing MOTD\n");
		sys_cputs(buf, n);
	}

	cprintf("icode: close /motd\n");
  80017d:	48 bf 12 45 80 00 00 	movabs $0x804512,%rdi
  800184:	00 00 00 
  800187:	b8 00 00 00 00       	mov    $0x0,%eax
  80018c:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800193:	00 00 00 
  800196:	ff d2                	callq  *%rdx
	close(fd);
  800198:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80019b:	89 c7                	mov    %eax,%edi
  80019d:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  8001a4:	00 00 00 
  8001a7:	ff d0                	callq  *%rax

	cprintf("icode: spawn /sbin/init\n");
  8001a9:	48 bf 26 45 80 00 00 	movabs $0x804526,%rdi
  8001b0:	00 00 00 
  8001b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b8:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  8001bf:	00 00 00 
  8001c2:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ca:	48 b9 3f 45 80 00 00 	movabs $0x80453f,%rcx
  8001d1:	00 00 00 
  8001d4:	48 ba 48 45 80 00 00 	movabs $0x804548,%rdx
  8001db:	00 00 00 
  8001de:	48 be 51 45 80 00 00 	movabs $0x804551,%rsi
  8001e5:	00 00 00 
  8001e8:	48 bf 56 45 80 00 00 	movabs $0x804556,%rdi
  8001ef:	00 00 00 
  8001f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f7:	49 b9 97 31 80 00 00 	movabs $0x803197,%r9
  8001fe:	00 00 00 
  800201:	41 ff d1             	callq  *%r9
  800204:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800207:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("icode: spawn /sbin/init: %e", r);
  80020d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 61 45 80 00 00 	movabs $0x804561,%rdx
  800219:	00 00 00 
  80021c:	be 22 00 00 00       	mov    $0x22,%esi
  800221:	48 bf e4 44 80 00 00 	movabs $0x8044e4,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8
	cprintf("icode: exiting\n");
  80023d:	48 bf 7d 45 80 00 00 	movabs $0x80457d,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
}
  800258:	48 81 c4 28 02 00 00 	add    $0x228,%rsp
  80025f:	5b                   	pop    %rbx
  800260:	5d                   	pop    %rbp
  800261:	c3                   	retq   

0000000000800262 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800262:	55                   	push   %rbp
  800263:	48 89 e5             	mov    %rsp,%rbp
  800266:	48 83 ec 10          	sub    $0x10,%rsp
  80026a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80026d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800271:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
  80027d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800282:	48 98                	cltq   
  800284:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80028b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800292:	00 00 00 
  800295:	48 01 c2             	add    %rax,%rdx
  800298:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80029f:	00 00 00 
  8002a2:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002a9:	7e 14                	jle    8002bf <libmain+0x5d>
		binaryname = argv[0];
  8002ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002af:	48 8b 10             	mov    (%rax),%rdx
  8002b2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002b9:	00 00 00 
  8002bc:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002c6:	48 89 d6             	mov    %rdx,%rsi
  8002c9:	89 c7                	mov    %eax,%edi
  8002cb:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002d2:	00 00 00 
  8002d5:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8002d7:	48 b8 e5 02 80 00 00 	movabs $0x8002e5,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
}
  8002e3:	c9                   	leaveq 
  8002e4:	c3                   	retq   

00000000008002e5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002e5:	55                   	push   %rbp
  8002e6:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002e9:	48 b8 b4 21 80 00 00 	movabs $0x8021b4,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8002fa:	48 b8 65 19 80 00 00 	movabs $0x801965,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax

}
  800306:	5d                   	pop    %rbp
  800307:	c3                   	retq   

0000000000800308 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800308:	55                   	push   %rbp
  800309:	48 89 e5             	mov    %rsp,%rbp
  80030c:	53                   	push   %rbx
  80030d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800314:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80031b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800321:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800328:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80032f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800336:	84 c0                	test   %al,%al
  800338:	74 23                	je     80035d <_panic+0x55>
  80033a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800341:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800345:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800349:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80034d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800351:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800355:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800359:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80035d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800364:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80036b:	00 00 00 
  80036e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800375:	00 00 00 
  800378:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80037c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800383:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80038a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800391:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800398:	00 00 00 
  80039b:	48 8b 18             	mov    (%rax),%rbx
  80039e:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  8003a5:	00 00 00 
  8003a8:	ff d0                	callq  *%rax
  8003aa:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003b0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003b7:	41 89 c8             	mov    %ecx,%r8d
  8003ba:	48 89 d1             	mov    %rdx,%rcx
  8003bd:	48 89 da             	mov    %rbx,%rdx
  8003c0:	89 c6                	mov    %eax,%esi
  8003c2:	48 bf 98 45 80 00 00 	movabs $0x804598,%rdi
  8003c9:	00 00 00 
  8003cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d1:	49 b9 41 05 80 00 00 	movabs $0x800541,%r9
  8003d8:	00 00 00 
  8003db:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003de:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003e5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003ec:	48 89 d6             	mov    %rdx,%rsi
  8003ef:	48 89 c7             	mov    %rax,%rdi
  8003f2:	48 b8 95 04 80 00 00 	movabs $0x800495,%rax
  8003f9:	00 00 00 
  8003fc:	ff d0                	callq  *%rax
	cprintf("\n");
  8003fe:	48 bf bb 45 80 00 00 	movabs $0x8045bb,%rdi
  800405:	00 00 00 
  800408:	b8 00 00 00 00       	mov    $0x0,%eax
  80040d:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800414:	00 00 00 
  800417:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800419:	cc                   	int3   
  80041a:	eb fd                	jmp    800419 <_panic+0x111>

000000000080041c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80041c:	55                   	push   %rbp
  80041d:	48 89 e5             	mov    %rsp,%rbp
  800420:	48 83 ec 10          	sub    $0x10,%rsp
  800424:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800427:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80042b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042f:	8b 00                	mov    (%rax),%eax
  800431:	8d 48 01             	lea    0x1(%rax),%ecx
  800434:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800438:	89 0a                	mov    %ecx,(%rdx)
  80043a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80043d:	89 d1                	mov    %edx,%ecx
  80043f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800443:	48 98                	cltq   
  800445:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044d:	8b 00                	mov    (%rax),%eax
  80044f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800454:	75 2c                	jne    800482 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800456:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045a:	8b 00                	mov    (%rax),%eax
  80045c:	48 98                	cltq   
  80045e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800462:	48 83 c2 08          	add    $0x8,%rdx
  800466:	48 89 c6             	mov    %rax,%rsi
  800469:	48 89 d7             	mov    %rdx,%rdi
  80046c:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  800473:	00 00 00 
  800476:	ff d0                	callq  *%rax
        b->idx = 0;
  800478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800486:	8b 40 04             	mov    0x4(%rax),%eax
  800489:	8d 50 01             	lea    0x1(%rax),%edx
  80048c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800490:	89 50 04             	mov    %edx,0x4(%rax)
}
  800493:	c9                   	leaveq 
  800494:	c3                   	retq   

0000000000800495 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800495:	55                   	push   %rbp
  800496:	48 89 e5             	mov    %rsp,%rbp
  800499:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004a0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004a7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004ae:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004b5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004bc:	48 8b 0a             	mov    (%rdx),%rcx
  8004bf:	48 89 08             	mov    %rcx,(%rax)
  8004c2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004c6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004ca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004ce:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004d9:	00 00 00 
    b.cnt = 0;
  8004dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004e3:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004e6:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004ed:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004f4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004fb:	48 89 c6             	mov    %rax,%rsi
  8004fe:	48 bf 1c 04 80 00 00 	movabs $0x80041c,%rdi
  800505:	00 00 00 
  800508:	48 b8 f4 08 80 00 00 	movabs $0x8008f4,%rax
  80050f:	00 00 00 
  800512:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800514:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80051a:	48 98                	cltq   
  80051c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800523:	48 83 c2 08          	add    $0x8,%rdx
  800527:	48 89 c6             	mov    %rax,%rsi
  80052a:	48 89 d7             	mov    %rdx,%rdi
  80052d:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  800534:	00 00 00 
  800537:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800539:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80053f:	c9                   	leaveq 
  800540:	c3                   	retq   

0000000000800541 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800541:	55                   	push   %rbp
  800542:	48 89 e5             	mov    %rsp,%rbp
  800545:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80054c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800553:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80055a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800561:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800568:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80056f:	84 c0                	test   %al,%al
  800571:	74 20                	je     800593 <cprintf+0x52>
  800573:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800577:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80057b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80057f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800583:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800587:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80058b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80058f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800593:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80059a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005a1:	00 00 00 
  8005a4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005ab:	00 00 00 
  8005ae:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005b2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005b9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005c0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005c7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005ce:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005d5:	48 8b 0a             	mov    (%rdx),%rcx
  8005d8:	48 89 08             	mov    %rcx,(%rax)
  8005db:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005df:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005e3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005e7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005eb:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005f2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005f9:	48 89 d6             	mov    %rdx,%rsi
  8005fc:	48 89 c7             	mov    %rax,%rdi
  8005ff:	48 b8 95 04 80 00 00 	movabs $0x800495,%rax
  800606:	00 00 00 
  800609:	ff d0                	callq  *%rax
  80060b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800611:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800617:	c9                   	leaveq 
  800618:	c3                   	retq   

0000000000800619 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800619:	55                   	push   %rbp
  80061a:	48 89 e5             	mov    %rsp,%rbp
  80061d:	53                   	push   %rbx
  80061e:	48 83 ec 38          	sub    $0x38,%rsp
  800622:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800626:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80062a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80062e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800631:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800635:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800639:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80063c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800640:	77 3b                	ja     80067d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800642:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800645:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800649:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80064c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800650:	ba 00 00 00 00       	mov    $0x0,%edx
  800655:	48 f7 f3             	div    %rbx
  800658:	48 89 c2             	mov    %rax,%rdx
  80065b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80065e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800661:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800669:	41 89 f9             	mov    %edi,%r9d
  80066c:	48 89 c7             	mov    %rax,%rdi
  80066f:	48 b8 19 06 80 00 00 	movabs $0x800619,%rax
  800676:	00 00 00 
  800679:	ff d0                	callq  *%rax
  80067b:	eb 1e                	jmp    80069b <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80067d:	eb 12                	jmp    800691 <printnum+0x78>
			putch(padc, putdat);
  80067f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800683:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068a:	48 89 ce             	mov    %rcx,%rsi
  80068d:	89 d7                	mov    %edx,%edi
  80068f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800691:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800695:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800699:	7f e4                	jg     80067f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80069b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80069e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a7:	48 f7 f1             	div    %rcx
  8006aa:	48 89 d0             	mov    %rdx,%rax
  8006ad:	48 ba b0 47 80 00 00 	movabs $0x8047b0,%rdx
  8006b4:	00 00 00 
  8006b7:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006bb:	0f be d0             	movsbl %al,%edx
  8006be:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c6:	48 89 ce             	mov    %rcx,%rsi
  8006c9:	89 d7                	mov    %edx,%edi
  8006cb:	ff d0                	callq  *%rax
}
  8006cd:	48 83 c4 38          	add    $0x38,%rsp
  8006d1:	5b                   	pop    %rbx
  8006d2:	5d                   	pop    %rbp
  8006d3:	c3                   	retq   

00000000008006d4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006d4:	55                   	push   %rbp
  8006d5:	48 89 e5             	mov    %rsp,%rbp
  8006d8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006e0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006e3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006e7:	7e 52                	jle    80073b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	8b 00                	mov    (%rax),%eax
  8006ef:	83 f8 30             	cmp    $0x30,%eax
  8006f2:	73 24                	jae    800718 <getuint+0x44>
  8006f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	8b 00                	mov    (%rax),%eax
  800702:	89 c0                	mov    %eax,%eax
  800704:	48 01 d0             	add    %rdx,%rax
  800707:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070b:	8b 12                	mov    (%rdx),%edx
  80070d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800710:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800714:	89 0a                	mov    %ecx,(%rdx)
  800716:	eb 17                	jmp    80072f <getuint+0x5b>
  800718:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800720:	48 89 d0             	mov    %rdx,%rax
  800723:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80072f:	48 8b 00             	mov    (%rax),%rax
  800732:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800736:	e9 a3 00 00 00       	jmpq   8007de <getuint+0x10a>
	else if (lflag)
  80073b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80073f:	74 4f                	je     800790 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800745:	8b 00                	mov    (%rax),%eax
  800747:	83 f8 30             	cmp    $0x30,%eax
  80074a:	73 24                	jae    800770 <getuint+0x9c>
  80074c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800750:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	8b 00                	mov    (%rax),%eax
  80075a:	89 c0                	mov    %eax,%eax
  80075c:	48 01 d0             	add    %rdx,%rax
  80075f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800763:	8b 12                	mov    (%rdx),%edx
  800765:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800768:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076c:	89 0a                	mov    %ecx,(%rdx)
  80076e:	eb 17                	jmp    800787 <getuint+0xb3>
  800770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800774:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800778:	48 89 d0             	mov    %rdx,%rax
  80077b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80077f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800783:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800787:	48 8b 00             	mov    (%rax),%rax
  80078a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80078e:	eb 4e                	jmp    8007de <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	8b 00                	mov    (%rax),%eax
  800796:	83 f8 30             	cmp    $0x30,%eax
  800799:	73 24                	jae    8007bf <getuint+0xeb>
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a7:	8b 00                	mov    (%rax),%eax
  8007a9:	89 c0                	mov    %eax,%eax
  8007ab:	48 01 d0             	add    %rdx,%rax
  8007ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b2:	8b 12                	mov    (%rdx),%edx
  8007b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bb:	89 0a                	mov    %ecx,(%rdx)
  8007bd:	eb 17                	jmp    8007d6 <getuint+0x102>
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c7:	48 89 d0             	mov    %rdx,%rax
  8007ca:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	89 c0                	mov    %eax,%eax
  8007da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007e2:	c9                   	leaveq 
  8007e3:	c3                   	retq   

00000000008007e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007e4:	55                   	push   %rbp
  8007e5:	48 89 e5             	mov    %rsp,%rbp
  8007e8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007f0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007f3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007f7:	7e 52                	jle    80084b <getint+0x67>
		x=va_arg(*ap, long long);
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	8b 00                	mov    (%rax),%eax
  8007ff:	83 f8 30             	cmp    $0x30,%eax
  800802:	73 24                	jae    800828 <getint+0x44>
  800804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800808:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	8b 00                	mov    (%rax),%eax
  800812:	89 c0                	mov    %eax,%eax
  800814:	48 01 d0             	add    %rdx,%rax
  800817:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081b:	8b 12                	mov    (%rdx),%edx
  80081d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800820:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800824:	89 0a                	mov    %ecx,(%rdx)
  800826:	eb 17                	jmp    80083f <getint+0x5b>
  800828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800830:	48 89 d0             	mov    %rdx,%rax
  800833:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80083f:	48 8b 00             	mov    (%rax),%rax
  800842:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800846:	e9 a3 00 00 00       	jmpq   8008ee <getint+0x10a>
	else if (lflag)
  80084b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80084f:	74 4f                	je     8008a0 <getint+0xbc>
		x=va_arg(*ap, long);
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	8b 00                	mov    (%rax),%eax
  800857:	83 f8 30             	cmp    $0x30,%eax
  80085a:	73 24                	jae    800880 <getint+0x9c>
  80085c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800860:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	8b 00                	mov    (%rax),%eax
  80086a:	89 c0                	mov    %eax,%eax
  80086c:	48 01 d0             	add    %rdx,%rax
  80086f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800873:	8b 12                	mov    (%rdx),%edx
  800875:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800878:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087c:	89 0a                	mov    %ecx,(%rdx)
  80087e:	eb 17                	jmp    800897 <getint+0xb3>
  800880:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800884:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800888:	48 89 d0             	mov    %rdx,%rax
  80088b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80088f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800893:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800897:	48 8b 00             	mov    (%rax),%rax
  80089a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80089e:	eb 4e                	jmp    8008ee <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	8b 00                	mov    (%rax),%eax
  8008a6:	83 f8 30             	cmp    $0x30,%eax
  8008a9:	73 24                	jae    8008cf <getint+0xeb>
  8008ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008af:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	89 c0                	mov    %eax,%eax
  8008bb:	48 01 d0             	add    %rdx,%rax
  8008be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c2:	8b 12                	mov    (%rdx),%edx
  8008c4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cb:	89 0a                	mov    %ecx,(%rdx)
  8008cd:	eb 17                	jmp    8008e6 <getint+0x102>
  8008cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008d7:	48 89 d0             	mov    %rdx,%rax
  8008da:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e6:	8b 00                	mov    (%rax),%eax
  8008e8:	48 98                	cltq   
  8008ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008f2:	c9                   	leaveq 
  8008f3:	c3                   	retq   

00000000008008f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008f4:	55                   	push   %rbp
  8008f5:	48 89 e5             	mov    %rsp,%rbp
  8008f8:	41 54                	push   %r12
  8008fa:	53                   	push   %rbx
  8008fb:	48 83 ec 60          	sub    $0x60,%rsp
  8008ff:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800903:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800907:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80090b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80090f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800913:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800917:	48 8b 0a             	mov    (%rdx),%rcx
  80091a:	48 89 08             	mov    %rcx,(%rax)
  80091d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800921:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800925:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800929:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092d:	eb 17                	jmp    800946 <vprintfmt+0x52>
			if (ch == '\0')
  80092f:	85 db                	test   %ebx,%ebx
  800931:	0f 84 cc 04 00 00    	je     800e03 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800937:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80093b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093f:	48 89 d6             	mov    %rdx,%rsi
  800942:	89 df                	mov    %ebx,%edi
  800944:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800946:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80094a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80094e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800952:	0f b6 00             	movzbl (%rax),%eax
  800955:	0f b6 d8             	movzbl %al,%ebx
  800958:	83 fb 25             	cmp    $0x25,%ebx
  80095b:	75 d2                	jne    80092f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800961:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800968:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80096f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800976:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800981:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800985:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800989:	0f b6 00             	movzbl (%rax),%eax
  80098c:	0f b6 d8             	movzbl %al,%ebx
  80098f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800992:	83 f8 55             	cmp    $0x55,%eax
  800995:	0f 87 34 04 00 00    	ja     800dcf <vprintfmt+0x4db>
  80099b:	89 c0                	mov    %eax,%eax
  80099d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009a4:	00 
  8009a5:	48 b8 d8 47 80 00 00 	movabs $0x8047d8,%rax
  8009ac:	00 00 00 
  8009af:	48 01 d0             	add    %rdx,%rax
  8009b2:	48 8b 00             	mov    (%rax),%rax
  8009b5:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009b7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009bb:	eb c0                	jmp    80097d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009bd:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009c1:	eb ba                	jmp    80097d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009ca:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009cd:	89 d0                	mov    %edx,%eax
  8009cf:	c1 e0 02             	shl    $0x2,%eax
  8009d2:	01 d0                	add    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d8                	add    %ebx,%eax
  8009d8:	83 e8 30             	sub    $0x30,%eax
  8009db:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009de:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009e2:	0f b6 00             	movzbl (%rax),%eax
  8009e5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009e8:	83 fb 2f             	cmp    $0x2f,%ebx
  8009eb:	7e 0c                	jle    8009f9 <vprintfmt+0x105>
  8009ed:	83 fb 39             	cmp    $0x39,%ebx
  8009f0:	7f 07                	jg     8009f9 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009f7:	eb d1                	jmp    8009ca <vprintfmt+0xd6>
			goto process_precision;
  8009f9:	eb 58                	jmp    800a53 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fe:	83 f8 30             	cmp    $0x30,%eax
  800a01:	73 17                	jae    800a1a <vprintfmt+0x126>
  800a03:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0a:	89 c0                	mov    %eax,%eax
  800a0c:	48 01 d0             	add    %rdx,%rax
  800a0f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a12:	83 c2 08             	add    $0x8,%edx
  800a15:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a18:	eb 0f                	jmp    800a29 <vprintfmt+0x135>
  800a1a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a1e:	48 89 d0             	mov    %rdx,%rax
  800a21:	48 83 c2 08          	add    $0x8,%rdx
  800a25:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a29:	8b 00                	mov    (%rax),%eax
  800a2b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a2e:	eb 23                	jmp    800a53 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a30:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a34:	79 0c                	jns    800a42 <vprintfmt+0x14e>
				width = 0;
  800a36:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a3d:	e9 3b ff ff ff       	jmpq   80097d <vprintfmt+0x89>
  800a42:	e9 36 ff ff ff       	jmpq   80097d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a47:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a4e:	e9 2a ff ff ff       	jmpq   80097d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a53:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a57:	79 12                	jns    800a6b <vprintfmt+0x177>
				width = precision, precision = -1;
  800a59:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a5c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a5f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a66:	e9 12 ff ff ff       	jmpq   80097d <vprintfmt+0x89>
  800a6b:	e9 0d ff ff ff       	jmpq   80097d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a70:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a74:	e9 04 ff ff ff       	jmpq   80097d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7c:	83 f8 30             	cmp    $0x30,%eax
  800a7f:	73 17                	jae    800a98 <vprintfmt+0x1a4>
  800a81:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a88:	89 c0                	mov    %eax,%eax
  800a8a:	48 01 d0             	add    %rdx,%rax
  800a8d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a90:	83 c2 08             	add    $0x8,%edx
  800a93:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a96:	eb 0f                	jmp    800aa7 <vprintfmt+0x1b3>
  800a98:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a9c:	48 89 d0             	mov    %rdx,%rax
  800a9f:	48 83 c2 08          	add    $0x8,%rdx
  800aa3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aa7:	8b 10                	mov    (%rax),%edx
  800aa9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800aad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab1:	48 89 ce             	mov    %rcx,%rsi
  800ab4:	89 d7                	mov    %edx,%edi
  800ab6:	ff d0                	callq  *%rax
			break;
  800ab8:	e9 40 03 00 00       	jmpq   800dfd <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800abd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac0:	83 f8 30             	cmp    $0x30,%eax
  800ac3:	73 17                	jae    800adc <vprintfmt+0x1e8>
  800ac5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ac9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acc:	89 c0                	mov    %eax,%eax
  800ace:	48 01 d0             	add    %rdx,%rax
  800ad1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad4:	83 c2 08             	add    $0x8,%edx
  800ad7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ada:	eb 0f                	jmp    800aeb <vprintfmt+0x1f7>
  800adc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae0:	48 89 d0             	mov    %rdx,%rax
  800ae3:	48 83 c2 08          	add    $0x8,%rdx
  800ae7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aeb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800aed:	85 db                	test   %ebx,%ebx
  800aef:	79 02                	jns    800af3 <vprintfmt+0x1ff>
				err = -err;
  800af1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800af3:	83 fb 15             	cmp    $0x15,%ebx
  800af6:	7f 16                	jg     800b0e <vprintfmt+0x21a>
  800af8:	48 b8 00 47 80 00 00 	movabs $0x804700,%rax
  800aff:	00 00 00 
  800b02:	48 63 d3             	movslq %ebx,%rdx
  800b05:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b09:	4d 85 e4             	test   %r12,%r12
  800b0c:	75 2e                	jne    800b3c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b0e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b16:	89 d9                	mov    %ebx,%ecx
  800b18:	48 ba c1 47 80 00 00 	movabs $0x8047c1,%rdx
  800b1f:	00 00 00 
  800b22:	48 89 c7             	mov    %rax,%rdi
  800b25:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2a:	49 b8 0c 0e 80 00 00 	movabs $0x800e0c,%r8
  800b31:	00 00 00 
  800b34:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b37:	e9 c1 02 00 00       	jmpq   800dfd <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b3c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b44:	4c 89 e1             	mov    %r12,%rcx
  800b47:	48 ba ca 47 80 00 00 	movabs $0x8047ca,%rdx
  800b4e:	00 00 00 
  800b51:	48 89 c7             	mov    %rax,%rdi
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
  800b59:	49 b8 0c 0e 80 00 00 	movabs $0x800e0c,%r8
  800b60:	00 00 00 
  800b63:	41 ff d0             	callq  *%r8
			break;
  800b66:	e9 92 02 00 00       	jmpq   800dfd <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b6b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b6e:	83 f8 30             	cmp    $0x30,%eax
  800b71:	73 17                	jae    800b8a <vprintfmt+0x296>
  800b73:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7a:	89 c0                	mov    %eax,%eax
  800b7c:	48 01 d0             	add    %rdx,%rax
  800b7f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b82:	83 c2 08             	add    $0x8,%edx
  800b85:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b88:	eb 0f                	jmp    800b99 <vprintfmt+0x2a5>
  800b8a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b8e:	48 89 d0             	mov    %rdx,%rax
  800b91:	48 83 c2 08          	add    $0x8,%rdx
  800b95:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b99:	4c 8b 20             	mov    (%rax),%r12
  800b9c:	4d 85 e4             	test   %r12,%r12
  800b9f:	75 0a                	jne    800bab <vprintfmt+0x2b7>
				p = "(null)";
  800ba1:	49 bc cd 47 80 00 00 	movabs $0x8047cd,%r12
  800ba8:	00 00 00 
			if (width > 0 && padc != '-')
  800bab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800baf:	7e 3f                	jle    800bf0 <vprintfmt+0x2fc>
  800bb1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bb5:	74 39                	je     800bf0 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bba:	48 98                	cltq   
  800bbc:	48 89 c6             	mov    %rax,%rsi
  800bbf:	4c 89 e7             	mov    %r12,%rdi
  800bc2:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  800bc9:	00 00 00 
  800bcc:	ff d0                	callq  *%rax
  800bce:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bd1:	eb 17                	jmp    800bea <vprintfmt+0x2f6>
					putch(padc, putdat);
  800bd3:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bd7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bdb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bdf:	48 89 ce             	mov    %rcx,%rsi
  800be2:	89 d7                	mov    %edx,%edi
  800be4:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800be6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bee:	7f e3                	jg     800bd3 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf0:	eb 37                	jmp    800c29 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800bf2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bf6:	74 1e                	je     800c16 <vprintfmt+0x322>
  800bf8:	83 fb 1f             	cmp    $0x1f,%ebx
  800bfb:	7e 05                	jle    800c02 <vprintfmt+0x30e>
  800bfd:	83 fb 7e             	cmp    $0x7e,%ebx
  800c00:	7e 14                	jle    800c16 <vprintfmt+0x322>
					putch('?', putdat);
  800c02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0a:	48 89 d6             	mov    %rdx,%rsi
  800c0d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c12:	ff d0                	callq  *%rax
  800c14:	eb 0f                	jmp    800c25 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1e:	48 89 d6             	mov    %rdx,%rsi
  800c21:	89 df                	mov    %ebx,%edi
  800c23:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c25:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c29:	4c 89 e0             	mov    %r12,%rax
  800c2c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c30:	0f b6 00             	movzbl (%rax),%eax
  800c33:	0f be d8             	movsbl %al,%ebx
  800c36:	85 db                	test   %ebx,%ebx
  800c38:	74 10                	je     800c4a <vprintfmt+0x356>
  800c3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c3e:	78 b2                	js     800bf2 <vprintfmt+0x2fe>
  800c40:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c44:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c48:	79 a8                	jns    800bf2 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c4a:	eb 16                	jmp    800c62 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c4c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c54:	48 89 d6             	mov    %rdx,%rsi
  800c57:	bf 20 00 00 00       	mov    $0x20,%edi
  800c5c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c5e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c62:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c66:	7f e4                	jg     800c4c <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c68:	e9 90 01 00 00       	jmpq   800dfd <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c6d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c71:	be 03 00 00 00       	mov    $0x3,%esi
  800c76:	48 89 c7             	mov    %rax,%rdi
  800c79:	48 b8 e4 07 80 00 00 	movabs $0x8007e4,%rax
  800c80:	00 00 00 
  800c83:	ff d0                	callq  *%rax
  800c85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c8d:	48 85 c0             	test   %rax,%rax
  800c90:	79 1d                	jns    800caf <vprintfmt+0x3bb>
				putch('-', putdat);
  800c92:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9a:	48 89 d6             	mov    %rdx,%rsi
  800c9d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ca2:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca8:	48 f7 d8             	neg    %rax
  800cab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800caf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cb6:	e9 d5 00 00 00       	jmpq   800d90 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cbb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cbf:	be 03 00 00 00       	mov    $0x3,%esi
  800cc4:	48 89 c7             	mov    %rax,%rdi
  800cc7:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  800cce:	00 00 00 
  800cd1:	ff d0                	callq  *%rax
  800cd3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cd7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cde:	e9 ad 00 00 00       	jmpq   800d90 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800ce3:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800ce6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cea:	89 d6                	mov    %edx,%esi
  800cec:	48 89 c7             	mov    %rax,%rdi
  800cef:	48 b8 e4 07 80 00 00 	movabs $0x8007e4,%rax
  800cf6:	00 00 00 
  800cf9:	ff d0                	callq  *%rax
  800cfb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800cff:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d06:	e9 85 00 00 00       	jmpq   800d90 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800d0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d13:	48 89 d6             	mov    %rdx,%rsi
  800d16:	bf 30 00 00 00       	mov    $0x30,%edi
  800d1b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d25:	48 89 d6             	mov    %rdx,%rsi
  800d28:	bf 78 00 00 00       	mov    $0x78,%edi
  800d2d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d32:	83 f8 30             	cmp    $0x30,%eax
  800d35:	73 17                	jae    800d4e <vprintfmt+0x45a>
  800d37:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3e:	89 c0                	mov    %eax,%eax
  800d40:	48 01 d0             	add    %rdx,%rax
  800d43:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d46:	83 c2 08             	add    $0x8,%edx
  800d49:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d4c:	eb 0f                	jmp    800d5d <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d4e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d52:	48 89 d0             	mov    %rdx,%rax
  800d55:	48 83 c2 08          	add    $0x8,%rdx
  800d59:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d5d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d64:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d6b:	eb 23                	jmp    800d90 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d6d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d71:	be 03 00 00 00       	mov    $0x3,%esi
  800d76:	48 89 c7             	mov    %rax,%rdi
  800d79:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  800d80:	00 00 00 
  800d83:	ff d0                	callq  *%rax
  800d85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d89:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d90:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d95:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d98:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d9f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800da3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da7:	45 89 c1             	mov    %r8d,%r9d
  800daa:	41 89 f8             	mov    %edi,%r8d
  800dad:	48 89 c7             	mov    %rax,%rdi
  800db0:	48 b8 19 06 80 00 00 	movabs $0x800619,%rax
  800db7:	00 00 00 
  800dba:	ff d0                	callq  *%rax
			break;
  800dbc:	eb 3f                	jmp    800dfd <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc6:	48 89 d6             	mov    %rdx,%rsi
  800dc9:	89 df                	mov    %ebx,%edi
  800dcb:	ff d0                	callq  *%rax
			break;
  800dcd:	eb 2e                	jmp    800dfd <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dcf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd7:	48 89 d6             	mov    %rdx,%rsi
  800dda:	bf 25 00 00 00       	mov    $0x25,%edi
  800ddf:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800de6:	eb 05                	jmp    800ded <vprintfmt+0x4f9>
  800de8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ded:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800df1:	48 83 e8 01          	sub    $0x1,%rax
  800df5:	0f b6 00             	movzbl (%rax),%eax
  800df8:	3c 25                	cmp    $0x25,%al
  800dfa:	75 ec                	jne    800de8 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800dfc:	90                   	nop
		}
	}
  800dfd:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dfe:	e9 43 fb ff ff       	jmpq   800946 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e03:	48 83 c4 60          	add    $0x60,%rsp
  800e07:	5b                   	pop    %rbx
  800e08:	41 5c                	pop    %r12
  800e0a:	5d                   	pop    %rbp
  800e0b:	c3                   	retq   

0000000000800e0c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e0c:	55                   	push   %rbp
  800e0d:	48 89 e5             	mov    %rsp,%rbp
  800e10:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e17:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e1e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e25:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e2c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e33:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e3a:	84 c0                	test   %al,%al
  800e3c:	74 20                	je     800e5e <printfmt+0x52>
  800e3e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e42:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e46:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e4a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e4e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e52:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e56:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e5a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e5e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e65:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e6c:	00 00 00 
  800e6f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e76:	00 00 00 
  800e79:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e7d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e84:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e8b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e92:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e99:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ea0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ea7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800eae:	48 89 c7             	mov    %rax,%rdi
  800eb1:	48 b8 f4 08 80 00 00 	movabs $0x8008f4,%rax
  800eb8:	00 00 00 
  800ebb:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ebd:	c9                   	leaveq 
  800ebe:	c3                   	retq   

0000000000800ebf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ebf:	55                   	push   %rbp
  800ec0:	48 89 e5             	mov    %rsp,%rbp
  800ec3:	48 83 ec 10          	sub    $0x10,%rsp
  800ec7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ece:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed2:	8b 40 10             	mov    0x10(%rax),%eax
  800ed5:	8d 50 01             	lea    0x1(%rax),%edx
  800ed8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800edc:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800edf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee3:	48 8b 10             	mov    (%rax),%rdx
  800ee6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eea:	48 8b 40 08          	mov    0x8(%rax),%rax
  800eee:	48 39 c2             	cmp    %rax,%rdx
  800ef1:	73 17                	jae    800f0a <sprintputch+0x4b>
		*b->buf++ = ch;
  800ef3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef7:	48 8b 00             	mov    (%rax),%rax
  800efa:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800efe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f02:	48 89 0a             	mov    %rcx,(%rdx)
  800f05:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f08:	88 10                	mov    %dl,(%rax)
}
  800f0a:	c9                   	leaveq 
  800f0b:	c3                   	retq   

0000000000800f0c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f0c:	55                   	push   %rbp
  800f0d:	48 89 e5             	mov    %rsp,%rbp
  800f10:	48 83 ec 50          	sub    $0x50,%rsp
  800f14:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f18:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f1b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f1f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f23:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f27:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f2b:	48 8b 0a             	mov    (%rdx),%rcx
  800f2e:	48 89 08             	mov    %rcx,(%rax)
  800f31:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f35:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f39:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f3d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f41:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f45:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f49:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f4c:	48 98                	cltq   
  800f4e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f52:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f56:	48 01 d0             	add    %rdx,%rax
  800f59:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f5d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f64:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f69:	74 06                	je     800f71 <vsnprintf+0x65>
  800f6b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f6f:	7f 07                	jg     800f78 <vsnprintf+0x6c>
		return -E_INVAL;
  800f71:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f76:	eb 2f                	jmp    800fa7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f78:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f7c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f80:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f84:	48 89 c6             	mov    %rax,%rsi
  800f87:	48 bf bf 0e 80 00 00 	movabs $0x800ebf,%rdi
  800f8e:	00 00 00 
  800f91:	48 b8 f4 08 80 00 00 	movabs $0x8008f4,%rax
  800f98:	00 00 00 
  800f9b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fa1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fa4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fa7:	c9                   	leaveq 
  800fa8:	c3                   	retq   

0000000000800fa9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fa9:	55                   	push   %rbp
  800faa:	48 89 e5             	mov    %rsp,%rbp
  800fad:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fb4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fbb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fc1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fc8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fcf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fd6:	84 c0                	test   %al,%al
  800fd8:	74 20                	je     800ffa <snprintf+0x51>
  800fda:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fde:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fe2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fe6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fea:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fee:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ff2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ff6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ffa:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801001:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801008:	00 00 00 
  80100b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801012:	00 00 00 
  801015:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801019:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801020:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801027:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80102e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801035:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80103c:	48 8b 0a             	mov    (%rdx),%rcx
  80103f:	48 89 08             	mov    %rcx,(%rax)
  801042:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801046:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80104a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80104e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801052:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801059:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801060:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801066:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80106d:	48 89 c7             	mov    %rax,%rdi
  801070:	48 b8 0c 0f 80 00 00 	movabs $0x800f0c,%rax
  801077:	00 00 00 
  80107a:	ff d0                	callq  *%rax
  80107c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801082:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801088:	c9                   	leaveq 
  801089:	c3                   	retq   

000000000080108a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 83 ec 18          	sub    $0x18,%rsp
  801092:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80109d:	eb 09                	jmp    8010a8 <strlen+0x1e>
		n++;
  80109f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ac:	0f b6 00             	movzbl (%rax),%eax
  8010af:	84 c0                	test   %al,%al
  8010b1:	75 ec                	jne    80109f <strlen+0x15>
		n++;
	return n;
  8010b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010b6:	c9                   	leaveq 
  8010b7:	c3                   	retq   

00000000008010b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010b8:	55                   	push   %rbp
  8010b9:	48 89 e5             	mov    %rsp,%rbp
  8010bc:	48 83 ec 20          	sub    $0x20,%rsp
  8010c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010cf:	eb 0e                	jmp    8010df <strnlen+0x27>
		n++;
  8010d1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010da:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010df:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010e4:	74 0b                	je     8010f1 <strnlen+0x39>
  8010e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ea:	0f b6 00             	movzbl (%rax),%eax
  8010ed:	84 c0                	test   %al,%al
  8010ef:	75 e0                	jne    8010d1 <strnlen+0x19>
		n++;
	return n;
  8010f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010f4:	c9                   	leaveq 
  8010f5:	c3                   	retq   

00000000008010f6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010f6:	55                   	push   %rbp
  8010f7:	48 89 e5             	mov    %rsp,%rbp
  8010fa:	48 83 ec 20          	sub    $0x20,%rsp
  8010fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801102:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801106:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80110e:	90                   	nop
  80110f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801113:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801117:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80111b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80111f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801123:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801127:	0f b6 12             	movzbl (%rdx),%edx
  80112a:	88 10                	mov    %dl,(%rax)
  80112c:	0f b6 00             	movzbl (%rax),%eax
  80112f:	84 c0                	test   %al,%al
  801131:	75 dc                	jne    80110f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801137:	c9                   	leaveq 
  801138:	c3                   	retq   

0000000000801139 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801139:	55                   	push   %rbp
  80113a:	48 89 e5             	mov    %rsp,%rbp
  80113d:	48 83 ec 20          	sub    $0x20,%rsp
  801141:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801145:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801149:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114d:	48 89 c7             	mov    %rax,%rdi
  801150:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  801157:	00 00 00 
  80115a:	ff d0                	callq  *%rax
  80115c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80115f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801162:	48 63 d0             	movslq %eax,%rdx
  801165:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801169:	48 01 c2             	add    %rax,%rdx
  80116c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801170:	48 89 c6             	mov    %rax,%rsi
  801173:	48 89 d7             	mov    %rdx,%rdi
  801176:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  80117d:	00 00 00 
  801180:	ff d0                	callq  *%rax
	return dst;
  801182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801186:	c9                   	leaveq 
  801187:	c3                   	retq   

0000000000801188 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801188:	55                   	push   %rbp
  801189:	48 89 e5             	mov    %rsp,%rbp
  80118c:	48 83 ec 28          	sub    $0x28,%rsp
  801190:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801194:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801198:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80119c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011a4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011ab:	00 
  8011ac:	eb 2a                	jmp    8011d8 <strncpy+0x50>
		*dst++ = *src;
  8011ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011b6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011ba:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011be:	0f b6 12             	movzbl (%rdx),%edx
  8011c1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c7:	0f b6 00             	movzbl (%rax),%eax
  8011ca:	84 c0                	test   %al,%al
  8011cc:	74 05                	je     8011d3 <strncpy+0x4b>
			src++;
  8011ce:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011e0:	72 cc                	jb     8011ae <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011e6:	c9                   	leaveq 
  8011e7:	c3                   	retq   

00000000008011e8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011e8:	55                   	push   %rbp
  8011e9:	48 89 e5             	mov    %rsp,%rbp
  8011ec:	48 83 ec 28          	sub    $0x28,%rsp
  8011f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801200:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801204:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801209:	74 3d                	je     801248 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80120b:	eb 1d                	jmp    80122a <strlcpy+0x42>
			*dst++ = *src++;
  80120d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801211:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801215:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801219:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80121d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801221:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801225:	0f b6 12             	movzbl (%rdx),%edx
  801228:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80122a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80122f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801234:	74 0b                	je     801241 <strlcpy+0x59>
  801236:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80123a:	0f b6 00             	movzbl (%rax),%eax
  80123d:	84 c0                	test   %al,%al
  80123f:	75 cc                	jne    80120d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801241:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801245:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801248:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80124c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801250:	48 29 c2             	sub    %rax,%rdx
  801253:	48 89 d0             	mov    %rdx,%rax
}
  801256:	c9                   	leaveq 
  801257:	c3                   	retq   

0000000000801258 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801258:	55                   	push   %rbp
  801259:	48 89 e5             	mov    %rsp,%rbp
  80125c:	48 83 ec 10          	sub    $0x10,%rsp
  801260:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801264:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801268:	eb 0a                	jmp    801274 <strcmp+0x1c>
		p++, q++;
  80126a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80126f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801278:	0f b6 00             	movzbl (%rax),%eax
  80127b:	84 c0                	test   %al,%al
  80127d:	74 12                	je     801291 <strcmp+0x39>
  80127f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801283:	0f b6 10             	movzbl (%rax),%edx
  801286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128a:	0f b6 00             	movzbl (%rax),%eax
  80128d:	38 c2                	cmp    %al,%dl
  80128f:	74 d9                	je     80126a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801295:	0f b6 00             	movzbl (%rax),%eax
  801298:	0f b6 d0             	movzbl %al,%edx
  80129b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129f:	0f b6 00             	movzbl (%rax),%eax
  8012a2:	0f b6 c0             	movzbl %al,%eax
  8012a5:	29 c2                	sub    %eax,%edx
  8012a7:	89 d0                	mov    %edx,%eax
}
  8012a9:	c9                   	leaveq 
  8012aa:	c3                   	retq   

00000000008012ab <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012ab:	55                   	push   %rbp
  8012ac:	48 89 e5             	mov    %rsp,%rbp
  8012af:	48 83 ec 18          	sub    $0x18,%rsp
  8012b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012bb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012bf:	eb 0f                	jmp    8012d0 <strncmp+0x25>
		n--, p++, q++;
  8012c1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012c6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012cb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012d0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012d5:	74 1d                	je     8012f4 <strncmp+0x49>
  8012d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012db:	0f b6 00             	movzbl (%rax),%eax
  8012de:	84 c0                	test   %al,%al
  8012e0:	74 12                	je     8012f4 <strncmp+0x49>
  8012e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e6:	0f b6 10             	movzbl (%rax),%edx
  8012e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ed:	0f b6 00             	movzbl (%rax),%eax
  8012f0:	38 c2                	cmp    %al,%dl
  8012f2:	74 cd                	je     8012c1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012f4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012f9:	75 07                	jne    801302 <strncmp+0x57>
		return 0;
  8012fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801300:	eb 18                	jmp    80131a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801306:	0f b6 00             	movzbl (%rax),%eax
  801309:	0f b6 d0             	movzbl %al,%edx
  80130c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801310:	0f b6 00             	movzbl (%rax),%eax
  801313:	0f b6 c0             	movzbl %al,%eax
  801316:	29 c2                	sub    %eax,%edx
  801318:	89 d0                	mov    %edx,%eax
}
  80131a:	c9                   	leaveq 
  80131b:	c3                   	retq   

000000000080131c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80131c:	55                   	push   %rbp
  80131d:	48 89 e5             	mov    %rsp,%rbp
  801320:	48 83 ec 0c          	sub    $0xc,%rsp
  801324:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801328:	89 f0                	mov    %esi,%eax
  80132a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80132d:	eb 17                	jmp    801346 <strchr+0x2a>
		if (*s == c)
  80132f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801333:	0f b6 00             	movzbl (%rax),%eax
  801336:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801339:	75 06                	jne    801341 <strchr+0x25>
			return (char *) s;
  80133b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133f:	eb 15                	jmp    801356 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801341:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801346:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134a:	0f b6 00             	movzbl (%rax),%eax
  80134d:	84 c0                	test   %al,%al
  80134f:	75 de                	jne    80132f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801351:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801356:	c9                   	leaveq 
  801357:	c3                   	retq   

0000000000801358 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801358:	55                   	push   %rbp
  801359:	48 89 e5             	mov    %rsp,%rbp
  80135c:	48 83 ec 0c          	sub    $0xc,%rsp
  801360:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801364:	89 f0                	mov    %esi,%eax
  801366:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801369:	eb 13                	jmp    80137e <strfind+0x26>
		if (*s == c)
  80136b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136f:	0f b6 00             	movzbl (%rax),%eax
  801372:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801375:	75 02                	jne    801379 <strfind+0x21>
			break;
  801377:	eb 10                	jmp    801389 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801379:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80137e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801382:	0f b6 00             	movzbl (%rax),%eax
  801385:	84 c0                	test   %al,%al
  801387:	75 e2                	jne    80136b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80138d:	c9                   	leaveq 
  80138e:	c3                   	retq   

000000000080138f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80138f:	55                   	push   %rbp
  801390:	48 89 e5             	mov    %rsp,%rbp
  801393:	48 83 ec 18          	sub    $0x18,%rsp
  801397:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80139b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80139e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013a2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013a7:	75 06                	jne    8013af <memset+0x20>
		return v;
  8013a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ad:	eb 69                	jmp    801418 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b3:	83 e0 03             	and    $0x3,%eax
  8013b6:	48 85 c0             	test   %rax,%rax
  8013b9:	75 48                	jne    801403 <memset+0x74>
  8013bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bf:	83 e0 03             	and    $0x3,%eax
  8013c2:	48 85 c0             	test   %rax,%rax
  8013c5:	75 3c                	jne    801403 <memset+0x74>
		c &= 0xFF;
  8013c7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d1:	c1 e0 18             	shl    $0x18,%eax
  8013d4:	89 c2                	mov    %eax,%edx
  8013d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d9:	c1 e0 10             	shl    $0x10,%eax
  8013dc:	09 c2                	or     %eax,%edx
  8013de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e1:	c1 e0 08             	shl    $0x8,%eax
  8013e4:	09 d0                	or     %edx,%eax
  8013e6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ed:	48 c1 e8 02          	shr    $0x2,%rax
  8013f1:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013fb:	48 89 d7             	mov    %rdx,%rdi
  8013fe:	fc                   	cld    
  8013ff:	f3 ab                	rep stos %eax,%es:(%rdi)
  801401:	eb 11                	jmp    801414 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801403:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801407:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80140a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80140e:	48 89 d7             	mov    %rdx,%rdi
  801411:	fc                   	cld    
  801412:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801418:	c9                   	leaveq 
  801419:	c3                   	retq   

000000000080141a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80141a:	55                   	push   %rbp
  80141b:	48 89 e5             	mov    %rsp,%rbp
  80141e:	48 83 ec 28          	sub    $0x28,%rsp
  801422:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801426:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80142a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80142e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801432:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80143e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801442:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801446:	0f 83 88 00 00 00    	jae    8014d4 <memmove+0xba>
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801454:	48 01 d0             	add    %rdx,%rax
  801457:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80145b:	76 77                	jbe    8014d4 <memmove+0xba>
		s += n;
  80145d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801461:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80146d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801471:	83 e0 03             	and    $0x3,%eax
  801474:	48 85 c0             	test   %rax,%rax
  801477:	75 3b                	jne    8014b4 <memmove+0x9a>
  801479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147d:	83 e0 03             	and    $0x3,%eax
  801480:	48 85 c0             	test   %rax,%rax
  801483:	75 2f                	jne    8014b4 <memmove+0x9a>
  801485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801489:	83 e0 03             	and    $0x3,%eax
  80148c:	48 85 c0             	test   %rax,%rax
  80148f:	75 23                	jne    8014b4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801491:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801495:	48 83 e8 04          	sub    $0x4,%rax
  801499:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80149d:	48 83 ea 04          	sub    $0x4,%rdx
  8014a1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014a5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014a9:	48 89 c7             	mov    %rax,%rdi
  8014ac:	48 89 d6             	mov    %rdx,%rsi
  8014af:	fd                   	std    
  8014b0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014b2:	eb 1d                	jmp    8014d1 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c8:	48 89 d7             	mov    %rdx,%rdi
  8014cb:	48 89 c1             	mov    %rax,%rcx
  8014ce:	fd                   	std    
  8014cf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014d1:	fc                   	cld    
  8014d2:	eb 57                	jmp    80152b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d8:	83 e0 03             	and    $0x3,%eax
  8014db:	48 85 c0             	test   %rax,%rax
  8014de:	75 36                	jne    801516 <memmove+0xfc>
  8014e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e4:	83 e0 03             	and    $0x3,%eax
  8014e7:	48 85 c0             	test   %rax,%rax
  8014ea:	75 2a                	jne    801516 <memmove+0xfc>
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	83 e0 03             	and    $0x3,%eax
  8014f3:	48 85 c0             	test   %rax,%rax
  8014f6:	75 1e                	jne    801516 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fc:	48 c1 e8 02          	shr    $0x2,%rax
  801500:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801503:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801507:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150b:	48 89 c7             	mov    %rax,%rdi
  80150e:	48 89 d6             	mov    %rdx,%rsi
  801511:	fc                   	cld    
  801512:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801514:	eb 15                	jmp    80152b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801516:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80151e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801522:	48 89 c7             	mov    %rax,%rdi
  801525:	48 89 d6             	mov    %rdx,%rsi
  801528:	fc                   	cld    
  801529:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80152b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80152f:	c9                   	leaveq 
  801530:	c3                   	retq   

0000000000801531 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801531:	55                   	push   %rbp
  801532:	48 89 e5             	mov    %rsp,%rbp
  801535:	48 83 ec 18          	sub    $0x18,%rsp
  801539:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80153d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801541:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801545:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801549:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80154d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801551:	48 89 ce             	mov    %rcx,%rsi
  801554:	48 89 c7             	mov    %rax,%rdi
  801557:	48 b8 1a 14 80 00 00 	movabs $0x80141a,%rax
  80155e:	00 00 00 
  801561:	ff d0                	callq  *%rax
}
  801563:	c9                   	leaveq 
  801564:	c3                   	retq   

0000000000801565 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801565:	55                   	push   %rbp
  801566:	48 89 e5             	mov    %rsp,%rbp
  801569:	48 83 ec 28          	sub    $0x28,%rsp
  80156d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801571:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801575:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801581:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801585:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801589:	eb 36                	jmp    8015c1 <memcmp+0x5c>
		if (*s1 != *s2)
  80158b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158f:	0f b6 10             	movzbl (%rax),%edx
  801592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801596:	0f b6 00             	movzbl (%rax),%eax
  801599:	38 c2                	cmp    %al,%dl
  80159b:	74 1a                	je     8015b7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80159d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a1:	0f b6 00             	movzbl (%rax),%eax
  8015a4:	0f b6 d0             	movzbl %al,%edx
  8015a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ab:	0f b6 00             	movzbl (%rax),%eax
  8015ae:	0f b6 c0             	movzbl %al,%eax
  8015b1:	29 c2                	sub    %eax,%edx
  8015b3:	89 d0                	mov    %edx,%eax
  8015b5:	eb 20                	jmp    8015d7 <memcmp+0x72>
		s1++, s2++;
  8015b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015bc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015cd:	48 85 c0             	test   %rax,%rax
  8015d0:	75 b9                	jne    80158b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d7:	c9                   	leaveq 
  8015d8:	c3                   	retq   

00000000008015d9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015d9:	55                   	push   %rbp
  8015da:	48 89 e5             	mov    %rsp,%rbp
  8015dd:	48 83 ec 28          	sub    $0x28,%rsp
  8015e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015e5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015f4:	48 01 d0             	add    %rdx,%rax
  8015f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015fb:	eb 15                	jmp    801612 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801601:	0f b6 10             	movzbl (%rax),%edx
  801604:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801607:	38 c2                	cmp    %al,%dl
  801609:	75 02                	jne    80160d <memfind+0x34>
			break;
  80160b:	eb 0f                	jmp    80161c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80160d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801612:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801616:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80161a:	72 e1                	jb     8015fd <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80161c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801620:	c9                   	leaveq 
  801621:	c3                   	retq   

0000000000801622 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801622:	55                   	push   %rbp
  801623:	48 89 e5             	mov    %rsp,%rbp
  801626:	48 83 ec 34          	sub    $0x34,%rsp
  80162a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80162e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801632:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801635:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80163c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801643:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801644:	eb 05                	jmp    80164b <strtol+0x29>
		s++;
  801646:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80164b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164f:	0f b6 00             	movzbl (%rax),%eax
  801652:	3c 20                	cmp    $0x20,%al
  801654:	74 f0                	je     801646 <strtol+0x24>
  801656:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165a:	0f b6 00             	movzbl (%rax),%eax
  80165d:	3c 09                	cmp    $0x9,%al
  80165f:	74 e5                	je     801646 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	0f b6 00             	movzbl (%rax),%eax
  801668:	3c 2b                	cmp    $0x2b,%al
  80166a:	75 07                	jne    801673 <strtol+0x51>
		s++;
  80166c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801671:	eb 17                	jmp    80168a <strtol+0x68>
	else if (*s == '-')
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	3c 2d                	cmp    $0x2d,%al
  80167c:	75 0c                	jne    80168a <strtol+0x68>
		s++, neg = 1;
  80167e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801683:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80168a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80168e:	74 06                	je     801696 <strtol+0x74>
  801690:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801694:	75 28                	jne    8016be <strtol+0x9c>
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	3c 30                	cmp    $0x30,%al
  80169f:	75 1d                	jne    8016be <strtol+0x9c>
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	48 83 c0 01          	add    $0x1,%rax
  8016a9:	0f b6 00             	movzbl (%rax),%eax
  8016ac:	3c 78                	cmp    $0x78,%al
  8016ae:	75 0e                	jne    8016be <strtol+0x9c>
		s += 2, base = 16;
  8016b0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016b5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016bc:	eb 2c                	jmp    8016ea <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016be:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016c2:	75 19                	jne    8016dd <strtol+0xbb>
  8016c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c8:	0f b6 00             	movzbl (%rax),%eax
  8016cb:	3c 30                	cmp    $0x30,%al
  8016cd:	75 0e                	jne    8016dd <strtol+0xbb>
		s++, base = 8;
  8016cf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016d4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016db:	eb 0d                	jmp    8016ea <strtol+0xc8>
	else if (base == 0)
  8016dd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016e1:	75 07                	jne    8016ea <strtol+0xc8>
		base = 10;
  8016e3:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ee:	0f b6 00             	movzbl (%rax),%eax
  8016f1:	3c 2f                	cmp    $0x2f,%al
  8016f3:	7e 1d                	jle    801712 <strtol+0xf0>
  8016f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f9:	0f b6 00             	movzbl (%rax),%eax
  8016fc:	3c 39                	cmp    $0x39,%al
  8016fe:	7f 12                	jg     801712 <strtol+0xf0>
			dig = *s - '0';
  801700:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801704:	0f b6 00             	movzbl (%rax),%eax
  801707:	0f be c0             	movsbl %al,%eax
  80170a:	83 e8 30             	sub    $0x30,%eax
  80170d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801710:	eb 4e                	jmp    801760 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801712:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801716:	0f b6 00             	movzbl (%rax),%eax
  801719:	3c 60                	cmp    $0x60,%al
  80171b:	7e 1d                	jle    80173a <strtol+0x118>
  80171d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801721:	0f b6 00             	movzbl (%rax),%eax
  801724:	3c 7a                	cmp    $0x7a,%al
  801726:	7f 12                	jg     80173a <strtol+0x118>
			dig = *s - 'a' + 10;
  801728:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172c:	0f b6 00             	movzbl (%rax),%eax
  80172f:	0f be c0             	movsbl %al,%eax
  801732:	83 e8 57             	sub    $0x57,%eax
  801735:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801738:	eb 26                	jmp    801760 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80173a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173e:	0f b6 00             	movzbl (%rax),%eax
  801741:	3c 40                	cmp    $0x40,%al
  801743:	7e 48                	jle    80178d <strtol+0x16b>
  801745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801749:	0f b6 00             	movzbl (%rax),%eax
  80174c:	3c 5a                	cmp    $0x5a,%al
  80174e:	7f 3d                	jg     80178d <strtol+0x16b>
			dig = *s - 'A' + 10;
  801750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801754:	0f b6 00             	movzbl (%rax),%eax
  801757:	0f be c0             	movsbl %al,%eax
  80175a:	83 e8 37             	sub    $0x37,%eax
  80175d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801760:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801763:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801766:	7c 02                	jl     80176a <strtol+0x148>
			break;
  801768:	eb 23                	jmp    80178d <strtol+0x16b>
		s++, val = (val * base) + dig;
  80176a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80176f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801772:	48 98                	cltq   
  801774:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801779:	48 89 c2             	mov    %rax,%rdx
  80177c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80177f:	48 98                	cltq   
  801781:	48 01 d0             	add    %rdx,%rax
  801784:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801788:	e9 5d ff ff ff       	jmpq   8016ea <strtol+0xc8>

	if (endptr)
  80178d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801792:	74 0b                	je     80179f <strtol+0x17d>
		*endptr = (char *) s;
  801794:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801798:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80179c:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80179f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017a3:	74 09                	je     8017ae <strtol+0x18c>
  8017a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a9:	48 f7 d8             	neg    %rax
  8017ac:	eb 04                	jmp    8017b2 <strtol+0x190>
  8017ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017b2:	c9                   	leaveq 
  8017b3:	c3                   	retq   

00000000008017b4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017b4:	55                   	push   %rbp
  8017b5:	48 89 e5             	mov    %rsp,%rbp
  8017b8:	48 83 ec 30          	sub    $0x30,%rsp
  8017bc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017c0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017c8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017cc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017d0:	0f b6 00             	movzbl (%rax),%eax
  8017d3:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017d6:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017da:	75 06                	jne    8017e2 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e0:	eb 6b                	jmp    80184d <strstr+0x99>

	len = strlen(str);
  8017e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017e6:	48 89 c7             	mov    %rax,%rdi
  8017e9:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  8017f0:	00 00 00 
  8017f3:	ff d0                	callq  *%rax
  8017f5:	48 98                	cltq   
  8017f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ff:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801803:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801807:	0f b6 00             	movzbl (%rax),%eax
  80180a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80180d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801811:	75 07                	jne    80181a <strstr+0x66>
				return (char *) 0;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	eb 33                	jmp    80184d <strstr+0x99>
		} while (sc != c);
  80181a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80181e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801821:	75 d8                	jne    8017fb <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801823:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801827:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80182b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182f:	48 89 ce             	mov    %rcx,%rsi
  801832:	48 89 c7             	mov    %rax,%rdi
  801835:	48 b8 ab 12 80 00 00 	movabs $0x8012ab,%rax
  80183c:	00 00 00 
  80183f:	ff d0                	callq  *%rax
  801841:	85 c0                	test   %eax,%eax
  801843:	75 b6                	jne    8017fb <strstr+0x47>

	return (char *) (in - 1);
  801845:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801849:	48 83 e8 01          	sub    $0x1,%rax
}
  80184d:	c9                   	leaveq 
  80184e:	c3                   	retq   

000000000080184f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80184f:	55                   	push   %rbp
  801850:	48 89 e5             	mov    %rsp,%rbp
  801853:	53                   	push   %rbx
  801854:	48 83 ec 48          	sub    $0x48,%rsp
  801858:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80185b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80185e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801862:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801866:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80186a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80186e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801871:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801875:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801879:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80187d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801881:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801885:	4c 89 c3             	mov    %r8,%rbx
  801888:	cd 30                	int    $0x30
  80188a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80188e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801892:	74 3e                	je     8018d2 <syscall+0x83>
  801894:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801899:	7e 37                	jle    8018d2 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80189b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80189f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018a2:	49 89 d0             	mov    %rdx,%r8
  8018a5:	89 c1                	mov    %eax,%ecx
  8018a7:	48 ba 88 4a 80 00 00 	movabs $0x804a88,%rdx
  8018ae:	00 00 00 
  8018b1:	be 23 00 00 00       	mov    $0x23,%esi
  8018b6:	48 bf a5 4a 80 00 00 	movabs $0x804aa5,%rdi
  8018bd:	00 00 00 
  8018c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c5:	49 b9 08 03 80 00 00 	movabs $0x800308,%r9
  8018cc:	00 00 00 
  8018cf:	41 ff d1             	callq  *%r9

	return ret;
  8018d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018d6:	48 83 c4 48          	add    $0x48,%rsp
  8018da:	5b                   	pop    %rbx
  8018db:	5d                   	pop    %rbp
  8018dc:	c3                   	retq   

00000000008018dd <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018dd:	55                   	push   %rbp
  8018de:	48 89 e5             	mov    %rsp,%rbp
  8018e1:	48 83 ec 20          	sub    $0x20,%rsp
  8018e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018fc:	00 
  8018fd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801903:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801909:	48 89 d1             	mov    %rdx,%rcx
  80190c:	48 89 c2             	mov    %rax,%rdx
  80190f:	be 00 00 00 00       	mov    $0x0,%esi
  801914:	bf 00 00 00 00       	mov    $0x0,%edi
  801919:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801920:	00 00 00 
  801923:	ff d0                	callq  *%rax
}
  801925:	c9                   	leaveq 
  801926:	c3                   	retq   

0000000000801927 <sys_cgetc>:

int
sys_cgetc(void)
{
  801927:	55                   	push   %rbp
  801928:	48 89 e5             	mov    %rsp,%rbp
  80192b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80192f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801936:	00 
  801937:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801943:	b9 00 00 00 00       	mov    $0x0,%ecx
  801948:	ba 00 00 00 00       	mov    $0x0,%edx
  80194d:	be 00 00 00 00       	mov    $0x0,%esi
  801952:	bf 01 00 00 00       	mov    $0x1,%edi
  801957:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  80195e:	00 00 00 
  801961:	ff d0                	callq  *%rax
}
  801963:	c9                   	leaveq 
  801964:	c3                   	retq   

0000000000801965 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801965:	55                   	push   %rbp
  801966:	48 89 e5             	mov    %rsp,%rbp
  801969:	48 83 ec 10          	sub    $0x10,%rsp
  80196d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801970:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801973:	48 98                	cltq   
  801975:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197c:	00 
  80197d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801983:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801989:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198e:	48 89 c2             	mov    %rax,%rdx
  801991:	be 01 00 00 00       	mov    $0x1,%esi
  801996:	bf 03 00 00 00       	mov    $0x3,%edi
  80199b:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  8019a2:	00 00 00 
  8019a5:	ff d0                	callq  *%rax
}
  8019a7:	c9                   	leaveq 
  8019a8:	c3                   	retq   

00000000008019a9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019a9:	55                   	push   %rbp
  8019aa:	48 89 e5             	mov    %rsp,%rbp
  8019ad:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019b1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b8:	00 
  8019b9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cf:	be 00 00 00 00       	mov    $0x0,%esi
  8019d4:	bf 02 00 00 00       	mov    $0x2,%edi
  8019d9:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  8019e0:	00 00 00 
  8019e3:	ff d0                	callq  *%rax
}
  8019e5:	c9                   	leaveq 
  8019e6:	c3                   	retq   

00000000008019e7 <sys_yield>:

void
sys_yield(void)
{
  8019e7:	55                   	push   %rbp
  8019e8:	48 89 e5             	mov    %rsp,%rbp
  8019eb:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019ef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f6:	00 
  8019f7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a03:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a08:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0d:	be 00 00 00 00       	mov    $0x0,%esi
  801a12:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a17:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801a1e:	00 00 00 
  801a21:	ff d0                	callq  *%rax
}
  801a23:	c9                   	leaveq 
  801a24:	c3                   	retq   

0000000000801a25 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a25:	55                   	push   %rbp
  801a26:	48 89 e5             	mov    %rsp,%rbp
  801a29:	48 83 ec 20          	sub    $0x20,%rsp
  801a2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a34:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a3a:	48 63 c8             	movslq %eax,%rcx
  801a3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a44:	48 98                	cltq   
  801a46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4d:	00 
  801a4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a54:	49 89 c8             	mov    %rcx,%r8
  801a57:	48 89 d1             	mov    %rdx,%rcx
  801a5a:	48 89 c2             	mov    %rax,%rdx
  801a5d:	be 01 00 00 00       	mov    $0x1,%esi
  801a62:	bf 04 00 00 00       	mov    $0x4,%edi
  801a67:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801a6e:	00 00 00 
  801a71:	ff d0                	callq  *%rax
}
  801a73:	c9                   	leaveq 
  801a74:	c3                   	retq   

0000000000801a75 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a75:	55                   	push   %rbp
  801a76:	48 89 e5             	mov    %rsp,%rbp
  801a79:	48 83 ec 30          	sub    $0x30,%rsp
  801a7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a80:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a84:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a87:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a8b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a8f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a92:	48 63 c8             	movslq %eax,%rcx
  801a95:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a9c:	48 63 f0             	movslq %eax,%rsi
  801a9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa6:	48 98                	cltq   
  801aa8:	48 89 0c 24          	mov    %rcx,(%rsp)
  801aac:	49 89 f9             	mov    %rdi,%r9
  801aaf:	49 89 f0             	mov    %rsi,%r8
  801ab2:	48 89 d1             	mov    %rdx,%rcx
  801ab5:	48 89 c2             	mov    %rax,%rdx
  801ab8:	be 01 00 00 00       	mov    $0x1,%esi
  801abd:	bf 05 00 00 00       	mov    $0x5,%edi
  801ac2:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801ac9:	00 00 00 
  801acc:	ff d0                	callq  *%rax
}
  801ace:	c9                   	leaveq 
  801acf:	c3                   	retq   

0000000000801ad0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ad0:	55                   	push   %rbp
  801ad1:	48 89 e5             	mov    %rsp,%rbp
  801ad4:	48 83 ec 20          	sub    $0x20,%rsp
  801ad8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801adb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801adf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae6:	48 98                	cltq   
  801ae8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aef:	00 
  801af0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afc:	48 89 d1             	mov    %rdx,%rcx
  801aff:	48 89 c2             	mov    %rax,%rdx
  801b02:	be 01 00 00 00       	mov    $0x1,%esi
  801b07:	bf 06 00 00 00       	mov    $0x6,%edi
  801b0c:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	callq  *%rax
}
  801b18:	c9                   	leaveq 
  801b19:	c3                   	retq   

0000000000801b1a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b1a:	55                   	push   %rbp
  801b1b:	48 89 e5             	mov    %rsp,%rbp
  801b1e:	48 83 ec 10          	sub    $0x10,%rsp
  801b22:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b25:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b28:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b2b:	48 63 d0             	movslq %eax,%rdx
  801b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b31:	48 98                	cltq   
  801b33:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3a:	00 
  801b3b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b41:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b47:	48 89 d1             	mov    %rdx,%rcx
  801b4a:	48 89 c2             	mov    %rax,%rdx
  801b4d:	be 01 00 00 00       	mov    $0x1,%esi
  801b52:	bf 08 00 00 00       	mov    $0x8,%edi
  801b57:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801b5e:	00 00 00 
  801b61:	ff d0                	callq  *%rax
}
  801b63:	c9                   	leaveq 
  801b64:	c3                   	retq   

0000000000801b65 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b65:	55                   	push   %rbp
  801b66:	48 89 e5             	mov    %rsp,%rbp
  801b69:	48 83 ec 20          	sub    $0x20,%rsp
  801b6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b70:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7b:	48 98                	cltq   
  801b7d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b84:	00 
  801b85:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b91:	48 89 d1             	mov    %rdx,%rcx
  801b94:	48 89 c2             	mov    %rax,%rdx
  801b97:	be 01 00 00 00       	mov    $0x1,%esi
  801b9c:	bf 09 00 00 00       	mov    $0x9,%edi
  801ba1:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801ba8:	00 00 00 
  801bab:	ff d0                	callq  *%rax
}
  801bad:	c9                   	leaveq 
  801bae:	c3                   	retq   

0000000000801baf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801baf:	55                   	push   %rbp
  801bb0:	48 89 e5             	mov    %rsp,%rbp
  801bb3:	48 83 ec 20          	sub    $0x20,%rsp
  801bb7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bbe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc5:	48 98                	cltq   
  801bc7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bce:	00 
  801bcf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bdb:	48 89 d1             	mov    %rdx,%rcx
  801bde:	48 89 c2             	mov    %rax,%rdx
  801be1:	be 01 00 00 00       	mov    $0x1,%esi
  801be6:	bf 0a 00 00 00       	mov    $0xa,%edi
  801beb:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801bf2:	00 00 00 
  801bf5:	ff d0                	callq  *%rax
}
  801bf7:	c9                   	leaveq 
  801bf8:	c3                   	retq   

0000000000801bf9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bf9:	55                   	push   %rbp
  801bfa:	48 89 e5             	mov    %rsp,%rbp
  801bfd:	48 83 ec 20          	sub    $0x20,%rsp
  801c01:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c04:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c08:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c0c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c12:	48 63 f0             	movslq %eax,%rsi
  801c15:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1c:	48 98                	cltq   
  801c1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c29:	00 
  801c2a:	49 89 f1             	mov    %rsi,%r9
  801c2d:	49 89 c8             	mov    %rcx,%r8
  801c30:	48 89 d1             	mov    %rdx,%rcx
  801c33:	48 89 c2             	mov    %rax,%rdx
  801c36:	be 00 00 00 00       	mov    $0x0,%esi
  801c3b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c40:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801c47:	00 00 00 
  801c4a:	ff d0                	callq  *%rax
}
  801c4c:	c9                   	leaveq 
  801c4d:	c3                   	retq   

0000000000801c4e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c4e:	55                   	push   %rbp
  801c4f:	48 89 e5             	mov    %rsp,%rbp
  801c52:	48 83 ec 10          	sub    $0x10,%rsp
  801c56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c65:	00 
  801c66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c72:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c77:	48 89 c2             	mov    %rax,%rdx
  801c7a:	be 01 00 00 00       	mov    $0x1,%esi
  801c7f:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c84:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801c8b:	00 00 00 
  801c8e:	ff d0                	callq  *%rax
}
  801c90:	c9                   	leaveq 
  801c91:	c3                   	retq   

0000000000801c92 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c92:	55                   	push   %rbp
  801c93:	48 89 e5             	mov    %rsp,%rbp
  801c96:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca1:	00 
  801ca2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cae:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb3:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb8:	be 00 00 00 00       	mov    $0x0,%esi
  801cbd:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cc2:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801cc9:	00 00 00 
  801ccc:	ff d0                	callq  *%rax
}
  801cce:	c9                   	leaveq 
  801ccf:	c3                   	retq   

0000000000801cd0 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801cd0:	55                   	push   %rbp
  801cd1:	48 89 e5             	mov    %rsp,%rbp
  801cd4:	48 83 ec 30          	sub    $0x30,%rsp
  801cd8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cdb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cdf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ce2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ce6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801cea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ced:	48 63 c8             	movslq %eax,%rcx
  801cf0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cf4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cf7:	48 63 f0             	movslq %eax,%rsi
  801cfa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d01:	48 98                	cltq   
  801d03:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d07:	49 89 f9             	mov    %rdi,%r9
  801d0a:	49 89 f0             	mov    %rsi,%r8
  801d0d:	48 89 d1             	mov    %rdx,%rcx
  801d10:	48 89 c2             	mov    %rax,%rdx
  801d13:	be 00 00 00 00       	mov    $0x0,%esi
  801d18:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d1d:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801d24:	00 00 00 
  801d27:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d29:	c9                   	leaveq 
  801d2a:	c3                   	retq   

0000000000801d2b <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d2b:	55                   	push   %rbp
  801d2c:	48 89 e5             	mov    %rsp,%rbp
  801d2f:	48 83 ec 20          	sub    $0x20,%rsp
  801d33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d37:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4a:	00 
  801d4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d57:	48 89 d1             	mov    %rdx,%rcx
  801d5a:	48 89 c2             	mov    %rax,%rdx
  801d5d:	be 00 00 00 00       	mov    $0x0,%esi
  801d62:	bf 10 00 00 00       	mov    $0x10,%edi
  801d67:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801d6e:	00 00 00 
  801d71:	ff d0                	callq  *%rax
}
  801d73:	c9                   	leaveq 
  801d74:	c3                   	retq   

0000000000801d75 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801d75:	55                   	push   %rbp
  801d76:	48 89 e5             	mov    %rsp,%rbp
  801d79:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801d7d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d84:	00 
  801d85:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d91:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d96:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9b:	be 00 00 00 00       	mov    $0x0,%esi
  801da0:	bf 11 00 00 00       	mov    $0x11,%edi
  801da5:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801dac:	00 00 00 
  801daf:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801db1:	c9                   	leaveq 
  801db2:	c3                   	retq   

0000000000801db3 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801db3:	55                   	push   %rbp
  801db4:	48 89 e5             	mov    %rsp,%rbp
  801db7:	48 83 ec 10          	sub    $0x10,%rsp
  801dbb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801dbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc1:	48 98                	cltq   
  801dc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dca:	00 
  801dcb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ddc:	48 89 c2             	mov    %rax,%rdx
  801ddf:	be 00 00 00 00       	mov    $0x0,%esi
  801de4:	bf 12 00 00 00       	mov    $0x12,%edi
  801de9:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801df0:	00 00 00 
  801df3:	ff d0                	callq  *%rax
}
  801df5:	c9                   	leaveq 
  801df6:	c3                   	retq   

0000000000801df7 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801df7:	55                   	push   %rbp
  801df8:	48 89 e5             	mov    %rsp,%rbp
  801dfb:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801dff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e06:	00 
  801e07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e13:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e18:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1d:	be 00 00 00 00       	mov    $0x0,%esi
  801e22:	bf 13 00 00 00       	mov    $0x13,%edi
  801e27:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801e2e:	00 00 00 
  801e31:	ff d0                	callq  *%rax
}
  801e33:	c9                   	leaveq 
  801e34:	c3                   	retq   

0000000000801e35 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801e35:	55                   	push   %rbp
  801e36:	48 89 e5             	mov    %rsp,%rbp
  801e39:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e44:	00 
  801e45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e51:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e56:	ba 00 00 00 00       	mov    $0x0,%edx
  801e5b:	be 00 00 00 00       	mov    $0x0,%esi
  801e60:	bf 14 00 00 00       	mov    $0x14,%edi
  801e65:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801e6c:	00 00 00 
  801e6f:	ff d0                	callq  *%rax
}
  801e71:	c9                   	leaveq 
  801e72:	c3                   	retq   

0000000000801e73 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e73:	55                   	push   %rbp
  801e74:	48 89 e5             	mov    %rsp,%rbp
  801e77:	48 83 ec 08          	sub    $0x8,%rsp
  801e7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e7f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e83:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e8a:	ff ff ff 
  801e8d:	48 01 d0             	add    %rdx,%rax
  801e90:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e94:	c9                   	leaveq 
  801e95:	c3                   	retq   

0000000000801e96 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e96:	55                   	push   %rbp
  801e97:	48 89 e5             	mov    %rsp,%rbp
  801e9a:	48 83 ec 08          	sub    $0x8,%rsp
  801e9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ea2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea6:	48 89 c7             	mov    %rax,%rdi
  801ea9:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  801eb0:	00 00 00 
  801eb3:	ff d0                	callq  *%rax
  801eb5:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ebb:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ebf:	c9                   	leaveq 
  801ec0:	c3                   	retq   

0000000000801ec1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ec1:	55                   	push   %rbp
  801ec2:	48 89 e5             	mov    %rsp,%rbp
  801ec5:	48 83 ec 18          	sub    $0x18,%rsp
  801ec9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ecd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ed4:	eb 6b                	jmp    801f41 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ed6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed9:	48 98                	cltq   
  801edb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee1:	48 c1 e0 0c          	shl    $0xc,%rax
  801ee5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ee9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eed:	48 c1 e8 15          	shr    $0x15,%rax
  801ef1:	48 89 c2             	mov    %rax,%rdx
  801ef4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801efb:	01 00 00 
  801efe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f02:	83 e0 01             	and    $0x1,%eax
  801f05:	48 85 c0             	test   %rax,%rax
  801f08:	74 21                	je     801f2b <fd_alloc+0x6a>
  801f0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0e:	48 c1 e8 0c          	shr    $0xc,%rax
  801f12:	48 89 c2             	mov    %rax,%rdx
  801f15:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f1c:	01 00 00 
  801f1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f23:	83 e0 01             	and    $0x1,%eax
  801f26:	48 85 c0             	test   %rax,%rax
  801f29:	75 12                	jne    801f3d <fd_alloc+0x7c>
			*fd_store = fd;
  801f2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f33:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3b:	eb 1a                	jmp    801f57 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f3d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f41:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f45:	7e 8f                	jle    801ed6 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f52:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f57:	c9                   	leaveq 
  801f58:	c3                   	retq   

0000000000801f59 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f59:	55                   	push   %rbp
  801f5a:	48 89 e5             	mov    %rsp,%rbp
  801f5d:	48 83 ec 20          	sub    $0x20,%rsp
  801f61:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f64:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f68:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f6c:	78 06                	js     801f74 <fd_lookup+0x1b>
  801f6e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f72:	7e 07                	jle    801f7b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f79:	eb 6c                	jmp    801fe7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f7e:	48 98                	cltq   
  801f80:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f86:	48 c1 e0 0c          	shl    $0xc,%rax
  801f8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f92:	48 c1 e8 15          	shr    $0x15,%rax
  801f96:	48 89 c2             	mov    %rax,%rdx
  801f99:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa0:	01 00 00 
  801fa3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fa7:	83 e0 01             	and    $0x1,%eax
  801faa:	48 85 c0             	test   %rax,%rax
  801fad:	74 21                	je     801fd0 <fd_lookup+0x77>
  801faf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb3:	48 c1 e8 0c          	shr    $0xc,%rax
  801fb7:	48 89 c2             	mov    %rax,%rdx
  801fba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc1:	01 00 00 
  801fc4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc8:	83 e0 01             	and    $0x1,%eax
  801fcb:	48 85 c0             	test   %rax,%rax
  801fce:	75 07                	jne    801fd7 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fd5:	eb 10                	jmp    801fe7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fd7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fdb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fdf:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe7:	c9                   	leaveq 
  801fe8:	c3                   	retq   

0000000000801fe9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fe9:	55                   	push   %rbp
  801fea:	48 89 e5             	mov    %rsp,%rbp
  801fed:	48 83 ec 30          	sub    $0x30,%rsp
  801ff1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ff5:	89 f0                	mov    %esi,%eax
  801ff7:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ffa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ffe:	48 89 c7             	mov    %rax,%rdi
  802001:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  802008:	00 00 00 
  80200b:	ff d0                	callq  *%rax
  80200d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802011:	48 89 d6             	mov    %rdx,%rsi
  802014:	89 c7                	mov    %eax,%edi
  802016:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  80201d:	00 00 00 
  802020:	ff d0                	callq  *%rax
  802022:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802025:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802029:	78 0a                	js     802035 <fd_close+0x4c>
	    || fd != fd2)
  80202b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80202f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802033:	74 12                	je     802047 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802035:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802039:	74 05                	je     802040 <fd_close+0x57>
  80203b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80203e:	eb 05                	jmp    802045 <fd_close+0x5c>
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	eb 69                	jmp    8020b0 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802047:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204b:	8b 00                	mov    (%rax),%eax
  80204d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802051:	48 89 d6             	mov    %rdx,%rsi
  802054:	89 c7                	mov    %eax,%edi
  802056:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  80205d:	00 00 00 
  802060:	ff d0                	callq  *%rax
  802062:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802065:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802069:	78 2a                	js     802095 <fd_close+0xac>
		if (dev->dev_close)
  80206b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802073:	48 85 c0             	test   %rax,%rax
  802076:	74 16                	je     80208e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802078:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802080:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802084:	48 89 d7             	mov    %rdx,%rdi
  802087:	ff d0                	callq  *%rax
  802089:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80208c:	eb 07                	jmp    802095 <fd_close+0xac>
		else
			r = 0;
  80208e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802095:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802099:	48 89 c6             	mov    %rax,%rsi
  80209c:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a1:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  8020a8:	00 00 00 
  8020ab:	ff d0                	callq  *%rax
	return r;
  8020ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b0:	c9                   	leaveq 
  8020b1:	c3                   	retq   

00000000008020b2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020b2:	55                   	push   %rbp
  8020b3:	48 89 e5             	mov    %rsp,%rbp
  8020b6:	48 83 ec 20          	sub    $0x20,%rsp
  8020ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020c8:	eb 41                	jmp    80210b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020ca:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020d1:	00 00 00 
  8020d4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020d7:	48 63 d2             	movslq %edx,%rdx
  8020da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020de:	8b 00                	mov    (%rax),%eax
  8020e0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020e3:	75 22                	jne    802107 <dev_lookup+0x55>
			*dev = devtab[i];
  8020e5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020ec:	00 00 00 
  8020ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020f2:	48 63 d2             	movslq %edx,%rdx
  8020f5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020fd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802100:	b8 00 00 00 00       	mov    $0x0,%eax
  802105:	eb 60                	jmp    802167 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802107:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80210b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802112:	00 00 00 
  802115:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802118:	48 63 d2             	movslq %edx,%rdx
  80211b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80211f:	48 85 c0             	test   %rax,%rax
  802122:	75 a6                	jne    8020ca <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802124:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80212b:	00 00 00 
  80212e:	48 8b 00             	mov    (%rax),%rax
  802131:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802137:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80213a:	89 c6                	mov    %eax,%esi
  80213c:	48 bf b8 4a 80 00 00 	movabs $0x804ab8,%rdi
  802143:	00 00 00 
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
  80214b:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  802152:	00 00 00 
  802155:	ff d1                	callq  *%rcx
	*dev = 0;
  802157:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80215b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802162:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802167:	c9                   	leaveq 
  802168:	c3                   	retq   

0000000000802169 <close>:

int
close(int fdnum)
{
  802169:	55                   	push   %rbp
  80216a:	48 89 e5             	mov    %rsp,%rbp
  80216d:	48 83 ec 20          	sub    $0x20,%rsp
  802171:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802174:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802178:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80217b:	48 89 d6             	mov    %rdx,%rsi
  80217e:	89 c7                	mov    %eax,%edi
  802180:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  802187:	00 00 00 
  80218a:	ff d0                	callq  *%rax
  80218c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802193:	79 05                	jns    80219a <close+0x31>
		return r;
  802195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802198:	eb 18                	jmp    8021b2 <close+0x49>
	else
		return fd_close(fd, 1);
  80219a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80219e:	be 01 00 00 00       	mov    $0x1,%esi
  8021a3:	48 89 c7             	mov    %rax,%rdi
  8021a6:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  8021ad:	00 00 00 
  8021b0:	ff d0                	callq  *%rax
}
  8021b2:	c9                   	leaveq 
  8021b3:	c3                   	retq   

00000000008021b4 <close_all>:

void
close_all(void)
{
  8021b4:	55                   	push   %rbp
  8021b5:	48 89 e5             	mov    %rsp,%rbp
  8021b8:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021c3:	eb 15                	jmp    8021da <close_all+0x26>
		close(i);
  8021c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c8:	89 c7                	mov    %eax,%edi
  8021ca:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  8021d1:	00 00 00 
  8021d4:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021d6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021da:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021de:	7e e5                	jle    8021c5 <close_all+0x11>
		close(i);
}
  8021e0:	c9                   	leaveq 
  8021e1:	c3                   	retq   

00000000008021e2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021e2:	55                   	push   %rbp
  8021e3:	48 89 e5             	mov    %rsp,%rbp
  8021e6:	48 83 ec 40          	sub    $0x40,%rsp
  8021ea:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021ed:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021f0:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021f4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021f7:	48 89 d6             	mov    %rdx,%rsi
  8021fa:	89 c7                	mov    %eax,%edi
  8021fc:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  802203:	00 00 00 
  802206:	ff d0                	callq  *%rax
  802208:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80220f:	79 08                	jns    802219 <dup+0x37>
		return r;
  802211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802214:	e9 70 01 00 00       	jmpq   802389 <dup+0x1a7>
	close(newfdnum);
  802219:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80221c:	89 c7                	mov    %eax,%edi
  80221e:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  802225:	00 00 00 
  802228:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80222a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80222d:	48 98                	cltq   
  80222f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802235:	48 c1 e0 0c          	shl    $0xc,%rax
  802239:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80223d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802241:	48 89 c7             	mov    %rax,%rdi
  802244:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  80224b:	00 00 00 
  80224e:	ff d0                	callq  *%rax
  802250:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802258:	48 89 c7             	mov    %rax,%rdi
  80225b:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  802262:	00 00 00 
  802265:	ff d0                	callq  *%rax
  802267:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80226b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226f:	48 c1 e8 15          	shr    $0x15,%rax
  802273:	48 89 c2             	mov    %rax,%rdx
  802276:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80227d:	01 00 00 
  802280:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802284:	83 e0 01             	and    $0x1,%eax
  802287:	48 85 c0             	test   %rax,%rax
  80228a:	74 73                	je     8022ff <dup+0x11d>
  80228c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802290:	48 c1 e8 0c          	shr    $0xc,%rax
  802294:	48 89 c2             	mov    %rax,%rdx
  802297:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80229e:	01 00 00 
  8022a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a5:	83 e0 01             	and    $0x1,%eax
  8022a8:	48 85 c0             	test   %rax,%rax
  8022ab:	74 52                	je     8022ff <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b1:	48 c1 e8 0c          	shr    $0xc,%rax
  8022b5:	48 89 c2             	mov    %rax,%rdx
  8022b8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022bf:	01 00 00 
  8022c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c6:	25 07 0e 00 00       	and    $0xe07,%eax
  8022cb:	89 c1                	mov    %eax,%ecx
  8022cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d5:	41 89 c8             	mov    %ecx,%r8d
  8022d8:	48 89 d1             	mov    %rdx,%rcx
  8022db:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e0:	48 89 c6             	mov    %rax,%rsi
  8022e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e8:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  8022ef:	00 00 00 
  8022f2:	ff d0                	callq  *%rax
  8022f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022fb:	79 02                	jns    8022ff <dup+0x11d>
			goto err;
  8022fd:	eb 57                	jmp    802356 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8022ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802303:	48 c1 e8 0c          	shr    $0xc,%rax
  802307:	48 89 c2             	mov    %rax,%rdx
  80230a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802311:	01 00 00 
  802314:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802318:	25 07 0e 00 00       	and    $0xe07,%eax
  80231d:	89 c1                	mov    %eax,%ecx
  80231f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802323:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802327:	41 89 c8             	mov    %ecx,%r8d
  80232a:	48 89 d1             	mov    %rdx,%rcx
  80232d:	ba 00 00 00 00       	mov    $0x0,%edx
  802332:	48 89 c6             	mov    %rax,%rsi
  802335:	bf 00 00 00 00       	mov    $0x0,%edi
  80233a:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  802341:	00 00 00 
  802344:	ff d0                	callq  *%rax
  802346:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802349:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234d:	79 02                	jns    802351 <dup+0x16f>
		goto err;
  80234f:	eb 05                	jmp    802356 <dup+0x174>

	return newfdnum;
  802351:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802354:	eb 33                	jmp    802389 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802356:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235a:	48 89 c6             	mov    %rax,%rsi
  80235d:	bf 00 00 00 00       	mov    $0x0,%edi
  802362:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  802369:	00 00 00 
  80236c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80236e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802372:	48 89 c6             	mov    %rax,%rsi
  802375:	bf 00 00 00 00       	mov    $0x0,%edi
  80237a:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  802381:	00 00 00 
  802384:	ff d0                	callq  *%rax
	return r;
  802386:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802389:	c9                   	leaveq 
  80238a:	c3                   	retq   

000000000080238b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80238b:	55                   	push   %rbp
  80238c:	48 89 e5             	mov    %rsp,%rbp
  80238f:	48 83 ec 40          	sub    $0x40,%rsp
  802393:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802396:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80239a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80239e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023a5:	48 89 d6             	mov    %rdx,%rsi
  8023a8:	89 c7                	mov    %eax,%edi
  8023aa:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  8023b1:	00 00 00 
  8023b4:	ff d0                	callq  *%rax
  8023b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023bd:	78 24                	js     8023e3 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c3:	8b 00                	mov    (%rax),%eax
  8023c5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023c9:	48 89 d6             	mov    %rdx,%rsi
  8023cc:	89 c7                	mov    %eax,%edi
  8023ce:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  8023d5:	00 00 00 
  8023d8:	ff d0                	callq  *%rax
  8023da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e1:	79 05                	jns    8023e8 <read+0x5d>
		return r;
  8023e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e6:	eb 76                	jmp    80245e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ec:	8b 40 08             	mov    0x8(%rax),%eax
  8023ef:	83 e0 03             	and    $0x3,%eax
  8023f2:	83 f8 01             	cmp    $0x1,%eax
  8023f5:	75 3a                	jne    802431 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023f7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023fe:	00 00 00 
  802401:	48 8b 00             	mov    (%rax),%rax
  802404:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80240a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80240d:	89 c6                	mov    %eax,%esi
  80240f:	48 bf d7 4a 80 00 00 	movabs $0x804ad7,%rdi
  802416:	00 00 00 
  802419:	b8 00 00 00 00       	mov    $0x0,%eax
  80241e:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  802425:	00 00 00 
  802428:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80242a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80242f:	eb 2d                	jmp    80245e <read+0xd3>
	}
	if (!dev->dev_read)
  802431:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802435:	48 8b 40 10          	mov    0x10(%rax),%rax
  802439:	48 85 c0             	test   %rax,%rax
  80243c:	75 07                	jne    802445 <read+0xba>
		return -E_NOT_SUPP;
  80243e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802443:	eb 19                	jmp    80245e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802445:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802449:	48 8b 40 10          	mov    0x10(%rax),%rax
  80244d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802451:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802455:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802459:	48 89 cf             	mov    %rcx,%rdi
  80245c:	ff d0                	callq  *%rax
}
  80245e:	c9                   	leaveq 
  80245f:	c3                   	retq   

0000000000802460 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802460:	55                   	push   %rbp
  802461:	48 89 e5             	mov    %rsp,%rbp
  802464:	48 83 ec 30          	sub    $0x30,%rsp
  802468:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80246b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80246f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802473:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80247a:	eb 49                	jmp    8024c5 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80247c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247f:	48 98                	cltq   
  802481:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802485:	48 29 c2             	sub    %rax,%rdx
  802488:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248b:	48 63 c8             	movslq %eax,%rcx
  80248e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802492:	48 01 c1             	add    %rax,%rcx
  802495:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802498:	48 89 ce             	mov    %rcx,%rsi
  80249b:	89 c7                	mov    %eax,%edi
  80249d:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  8024a4:	00 00 00 
  8024a7:	ff d0                	callq  *%rax
  8024a9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024ac:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024b0:	79 05                	jns    8024b7 <readn+0x57>
			return m;
  8024b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024b5:	eb 1c                	jmp    8024d3 <readn+0x73>
		if (m == 0)
  8024b7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024bb:	75 02                	jne    8024bf <readn+0x5f>
			break;
  8024bd:	eb 11                	jmp    8024d0 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024c2:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c8:	48 98                	cltq   
  8024ca:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024ce:	72 ac                	jb     80247c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024d3:	c9                   	leaveq 
  8024d4:	c3                   	retq   

00000000008024d5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024d5:	55                   	push   %rbp
  8024d6:	48 89 e5             	mov    %rsp,%rbp
  8024d9:	48 83 ec 40          	sub    $0x40,%rsp
  8024dd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024e4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024e8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024ef:	48 89 d6             	mov    %rdx,%rsi
  8024f2:	89 c7                	mov    %eax,%edi
  8024f4:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  8024fb:	00 00 00 
  8024fe:	ff d0                	callq  *%rax
  802500:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802507:	78 24                	js     80252d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250d:	8b 00                	mov    (%rax),%eax
  80250f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802513:	48 89 d6             	mov    %rdx,%rsi
  802516:	89 c7                	mov    %eax,%edi
  802518:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  80251f:	00 00 00 
  802522:	ff d0                	callq  *%rax
  802524:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802527:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252b:	79 05                	jns    802532 <write+0x5d>
		return r;
  80252d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802530:	eb 42                	jmp    802574 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802536:	8b 40 08             	mov    0x8(%rax),%eax
  802539:	83 e0 03             	and    $0x3,%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	75 07                	jne    802547 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802540:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802545:	eb 2d                	jmp    802574 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802547:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80254f:	48 85 c0             	test   %rax,%rax
  802552:	75 07                	jne    80255b <write+0x86>
		return -E_NOT_SUPP;
  802554:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802559:	eb 19                	jmp    802574 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  80255b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802563:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802567:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80256b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80256f:	48 89 cf             	mov    %rcx,%rdi
  802572:	ff d0                	callq  *%rax
}
  802574:	c9                   	leaveq 
  802575:	c3                   	retq   

0000000000802576 <seek>:

int
seek(int fdnum, off_t offset)
{
  802576:	55                   	push   %rbp
  802577:	48 89 e5             	mov    %rsp,%rbp
  80257a:	48 83 ec 18          	sub    $0x18,%rsp
  80257e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802581:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802584:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802588:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80258b:	48 89 d6             	mov    %rdx,%rsi
  80258e:	89 c7                	mov    %eax,%edi
  802590:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  802597:	00 00 00 
  80259a:	ff d0                	callq  *%rax
  80259c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a3:	79 05                	jns    8025aa <seek+0x34>
		return r;
  8025a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a8:	eb 0f                	jmp    8025b9 <seek+0x43>
	fd->fd_offset = offset;
  8025aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ae:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025b1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b9:	c9                   	leaveq 
  8025ba:	c3                   	retq   

00000000008025bb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025bb:	55                   	push   %rbp
  8025bc:	48 89 e5             	mov    %rsp,%rbp
  8025bf:	48 83 ec 30          	sub    $0x30,%rsp
  8025c3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025c6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025c9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025cd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025d0:	48 89 d6             	mov    %rdx,%rsi
  8025d3:	89 c7                	mov    %eax,%edi
  8025d5:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  8025dc:	00 00 00 
  8025df:	ff d0                	callq  *%rax
  8025e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e8:	78 24                	js     80260e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ee:	8b 00                	mov    (%rax),%eax
  8025f0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025f4:	48 89 d6             	mov    %rdx,%rsi
  8025f7:	89 c7                	mov    %eax,%edi
  8025f9:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  802600:	00 00 00 
  802603:	ff d0                	callq  *%rax
  802605:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802608:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260c:	79 05                	jns    802613 <ftruncate+0x58>
		return r;
  80260e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802611:	eb 72                	jmp    802685 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802617:	8b 40 08             	mov    0x8(%rax),%eax
  80261a:	83 e0 03             	and    $0x3,%eax
  80261d:	85 c0                	test   %eax,%eax
  80261f:	75 3a                	jne    80265b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802621:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802628:	00 00 00 
  80262b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80262e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802634:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802637:	89 c6                	mov    %eax,%esi
  802639:	48 bf f8 4a 80 00 00 	movabs $0x804af8,%rdi
  802640:	00 00 00 
  802643:	b8 00 00 00 00       	mov    $0x0,%eax
  802648:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  80264f:	00 00 00 
  802652:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802654:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802659:	eb 2a                	jmp    802685 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80265b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80265f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802663:	48 85 c0             	test   %rax,%rax
  802666:	75 07                	jne    80266f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802668:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80266d:	eb 16                	jmp    802685 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80266f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802673:	48 8b 40 30          	mov    0x30(%rax),%rax
  802677:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80267b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80267e:	89 ce                	mov    %ecx,%esi
  802680:	48 89 d7             	mov    %rdx,%rdi
  802683:	ff d0                	callq  *%rax
}
  802685:	c9                   	leaveq 
  802686:	c3                   	retq   

0000000000802687 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802687:	55                   	push   %rbp
  802688:	48 89 e5             	mov    %rsp,%rbp
  80268b:	48 83 ec 30          	sub    $0x30,%rsp
  80268f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802692:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802696:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80269a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80269d:	48 89 d6             	mov    %rdx,%rsi
  8026a0:	89 c7                	mov    %eax,%edi
  8026a2:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  8026a9:	00 00 00 
  8026ac:	ff d0                	callq  *%rax
  8026ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b5:	78 24                	js     8026db <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026bb:	8b 00                	mov    (%rax),%eax
  8026bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026c1:	48 89 d6             	mov    %rdx,%rsi
  8026c4:	89 c7                	mov    %eax,%edi
  8026c6:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	callq  *%rax
  8026d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d9:	79 05                	jns    8026e0 <fstat+0x59>
		return r;
  8026db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026de:	eb 5e                	jmp    80273e <fstat+0xb7>
	if (!dev->dev_stat)
  8026e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026e8:	48 85 c0             	test   %rax,%rax
  8026eb:	75 07                	jne    8026f4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8026ed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026f2:	eb 4a                	jmp    80273e <fstat+0xb7>
	stat->st_name[0] = 0;
  8026f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026f8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026ff:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802706:	00 00 00 
	stat->st_isdir = 0;
  802709:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80270d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802714:	00 00 00 
	stat->st_dev = dev;
  802717:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80271b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80271f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80272e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802732:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802736:	48 89 ce             	mov    %rcx,%rsi
  802739:	48 89 d7             	mov    %rdx,%rdi
  80273c:	ff d0                	callq  *%rax
}
  80273e:	c9                   	leaveq 
  80273f:	c3                   	retq   

0000000000802740 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802740:	55                   	push   %rbp
  802741:	48 89 e5             	mov    %rsp,%rbp
  802744:	48 83 ec 20          	sub    $0x20,%rsp
  802748:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80274c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802754:	be 00 00 00 00       	mov    $0x0,%esi
  802759:	48 89 c7             	mov    %rax,%rdi
  80275c:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  802763:	00 00 00 
  802766:	ff d0                	callq  *%rax
  802768:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80276b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80276f:	79 05                	jns    802776 <stat+0x36>
		return fd;
  802771:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802774:	eb 2f                	jmp    8027a5 <stat+0x65>
	r = fstat(fd, stat);
  802776:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80277a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277d:	48 89 d6             	mov    %rdx,%rsi
  802780:	89 c7                	mov    %eax,%edi
  802782:	48 b8 87 26 80 00 00 	movabs $0x802687,%rax
  802789:	00 00 00 
  80278c:	ff d0                	callq  *%rax
  80278e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802794:	89 c7                	mov    %eax,%edi
  802796:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  80279d:	00 00 00 
  8027a0:	ff d0                	callq  *%rax
	return r;
  8027a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027a5:	c9                   	leaveq 
  8027a6:	c3                   	retq   

00000000008027a7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027a7:	55                   	push   %rbp
  8027a8:	48 89 e5             	mov    %rsp,%rbp
  8027ab:	48 83 ec 10          	sub    $0x10,%rsp
  8027af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027b6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027bd:	00 00 00 
  8027c0:	8b 00                	mov    (%rax),%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	75 1d                	jne    8027e3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027c6:	bf 01 00 00 00       	mov    $0x1,%edi
  8027cb:	48 b8 92 43 80 00 00 	movabs $0x804392,%rax
  8027d2:	00 00 00 
  8027d5:	ff d0                	callq  *%rax
  8027d7:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8027de:	00 00 00 
  8027e1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8027e3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027ea:	00 00 00 
  8027ed:	8b 00                	mov    (%rax),%eax
  8027ef:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8027f2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8027f7:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8027fe:	00 00 00 
  802801:	89 c7                	mov    %eax,%edi
  802803:	48 b8 0a 43 80 00 00 	movabs $0x80430a,%rax
  80280a:	00 00 00 
  80280d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80280f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802813:	ba 00 00 00 00       	mov    $0x0,%edx
  802818:	48 89 c6             	mov    %rax,%rsi
  80281b:	bf 00 00 00 00       	mov    $0x0,%edi
  802820:	48 b8 0c 42 80 00 00 	movabs $0x80420c,%rax
  802827:	00 00 00 
  80282a:	ff d0                	callq  *%rax
}
  80282c:	c9                   	leaveq 
  80282d:	c3                   	retq   

000000000080282e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80282e:	55                   	push   %rbp
  80282f:	48 89 e5             	mov    %rsp,%rbp
  802832:	48 83 ec 30          	sub    $0x30,%rsp
  802836:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80283a:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80283d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802844:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80284b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802852:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802857:	75 08                	jne    802861 <open+0x33>
	{
		return r;
  802859:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285c:	e9 f2 00 00 00       	jmpq   802953 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802865:	48 89 c7             	mov    %rax,%rdi
  802868:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  80286f:	00 00 00 
  802872:	ff d0                	callq  *%rax
  802874:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802877:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80287e:	7e 0a                	jle    80288a <open+0x5c>
	{
		return -E_BAD_PATH;
  802880:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802885:	e9 c9 00 00 00       	jmpq   802953 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80288a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802891:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802892:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802896:	48 89 c7             	mov    %rax,%rdi
  802899:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  8028a0:	00 00 00 
  8028a3:	ff d0                	callq  *%rax
  8028a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ac:	78 09                	js     8028b7 <open+0x89>
  8028ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b2:	48 85 c0             	test   %rax,%rax
  8028b5:	75 08                	jne    8028bf <open+0x91>
		{
			return r;
  8028b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ba:	e9 94 00 00 00       	jmpq   802953 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8028bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028c3:	ba 00 04 00 00       	mov    $0x400,%edx
  8028c8:	48 89 c6             	mov    %rax,%rsi
  8028cb:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8028d2:	00 00 00 
  8028d5:	48 b8 88 11 80 00 00 	movabs $0x801188,%rax
  8028dc:	00 00 00 
  8028df:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8028e1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028e8:	00 00 00 
  8028eb:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8028ee:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8028f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f8:	48 89 c6             	mov    %rax,%rsi
  8028fb:	bf 01 00 00 00       	mov    $0x1,%edi
  802900:	48 b8 a7 27 80 00 00 	movabs $0x8027a7,%rax
  802907:	00 00 00 
  80290a:	ff d0                	callq  *%rax
  80290c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802913:	79 2b                	jns    802940 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802915:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802919:	be 00 00 00 00       	mov    $0x0,%esi
  80291e:	48 89 c7             	mov    %rax,%rdi
  802921:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  802928:	00 00 00 
  80292b:	ff d0                	callq  *%rax
  80292d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802930:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802934:	79 05                	jns    80293b <open+0x10d>
			{
				return d;
  802936:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802939:	eb 18                	jmp    802953 <open+0x125>
			}
			return r;
  80293b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293e:	eb 13                	jmp    802953 <open+0x125>
		}	
		return fd2num(fd_store);
  802940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802944:	48 89 c7             	mov    %rax,%rdi
  802947:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  80294e:	00 00 00 
  802951:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802953:	c9                   	leaveq 
  802954:	c3                   	retq   

0000000000802955 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802955:	55                   	push   %rbp
  802956:	48 89 e5             	mov    %rsp,%rbp
  802959:	48 83 ec 10          	sub    $0x10,%rsp
  80295d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802961:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802965:	8b 50 0c             	mov    0xc(%rax),%edx
  802968:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80296f:	00 00 00 
  802972:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802974:	be 00 00 00 00       	mov    $0x0,%esi
  802979:	bf 06 00 00 00       	mov    $0x6,%edi
  80297e:	48 b8 a7 27 80 00 00 	movabs $0x8027a7,%rax
  802985:	00 00 00 
  802988:	ff d0                	callq  *%rax
}
  80298a:	c9                   	leaveq 
  80298b:	c3                   	retq   

000000000080298c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80298c:	55                   	push   %rbp
  80298d:	48 89 e5             	mov    %rsp,%rbp
  802990:	48 83 ec 30          	sub    $0x30,%rsp
  802994:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802998:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80299c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8029a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8029a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029ac:	74 07                	je     8029b5 <devfile_read+0x29>
  8029ae:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029b3:	75 07                	jne    8029bc <devfile_read+0x30>
		return -E_INVAL;
  8029b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029ba:	eb 77                	jmp    802a33 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c0:	8b 50 0c             	mov    0xc(%rax),%edx
  8029c3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ca:	00 00 00 
  8029cd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029cf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029d6:	00 00 00 
  8029d9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029dd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8029e1:	be 00 00 00 00       	mov    $0x0,%esi
  8029e6:	bf 03 00 00 00       	mov    $0x3,%edi
  8029eb:	48 b8 a7 27 80 00 00 	movabs $0x8027a7,%rax
  8029f2:	00 00 00 
  8029f5:	ff d0                	callq  *%rax
  8029f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fe:	7f 05                	jg     802a05 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802a00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a03:	eb 2e                	jmp    802a33 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802a05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a08:	48 63 d0             	movslq %eax,%rdx
  802a0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a0f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a16:	00 00 00 
  802a19:	48 89 c7             	mov    %rax,%rdi
  802a1c:	48 b8 1a 14 80 00 00 	movabs $0x80141a,%rax
  802a23:	00 00 00 
  802a26:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802a28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a2c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802a30:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a33:	c9                   	leaveq 
  802a34:	c3                   	retq   

0000000000802a35 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a35:	55                   	push   %rbp
  802a36:	48 89 e5             	mov    %rsp,%rbp
  802a39:	48 83 ec 30          	sub    $0x30,%rsp
  802a3d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a41:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a45:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802a49:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802a50:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a55:	74 07                	je     802a5e <devfile_write+0x29>
  802a57:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a5c:	75 08                	jne    802a66 <devfile_write+0x31>
		return r;
  802a5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a61:	e9 9a 00 00 00       	jmpq   802b00 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6a:	8b 50 0c             	mov    0xc(%rax),%edx
  802a6d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a74:	00 00 00 
  802a77:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802a79:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a80:	00 
  802a81:	76 08                	jbe    802a8b <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802a83:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a8a:	00 
	}
	fsipcbuf.write.req_n = n;
  802a8b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a92:	00 00 00 
  802a95:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a99:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802a9d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802aa1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa5:	48 89 c6             	mov    %rax,%rsi
  802aa8:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802aaf:	00 00 00 
  802ab2:	48 b8 1a 14 80 00 00 	movabs $0x80141a,%rax
  802ab9:	00 00 00 
  802abc:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802abe:	be 00 00 00 00       	mov    $0x0,%esi
  802ac3:	bf 04 00 00 00       	mov    $0x4,%edi
  802ac8:	48 b8 a7 27 80 00 00 	movabs $0x8027a7,%rax
  802acf:	00 00 00 
  802ad2:	ff d0                	callq  *%rax
  802ad4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802adb:	7f 20                	jg     802afd <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802add:	48 bf 1e 4b 80 00 00 	movabs $0x804b1e,%rdi
  802ae4:	00 00 00 
  802ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aec:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802af3:	00 00 00 
  802af6:	ff d2                	callq  *%rdx
		return r;
  802af8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afb:	eb 03                	jmp    802b00 <devfile_write+0xcb>
	}
	return r;
  802afd:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802b00:	c9                   	leaveq 
  802b01:	c3                   	retq   

0000000000802b02 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b02:	55                   	push   %rbp
  802b03:	48 89 e5             	mov    %rsp,%rbp
  802b06:	48 83 ec 20          	sub    $0x20,%rsp
  802b0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b16:	8b 50 0c             	mov    0xc(%rax),%edx
  802b19:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b20:	00 00 00 
  802b23:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b25:	be 00 00 00 00       	mov    $0x0,%esi
  802b2a:	bf 05 00 00 00       	mov    $0x5,%edi
  802b2f:	48 b8 a7 27 80 00 00 	movabs $0x8027a7,%rax
  802b36:	00 00 00 
  802b39:	ff d0                	callq  *%rax
  802b3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b42:	79 05                	jns    802b49 <devfile_stat+0x47>
		return r;
  802b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b47:	eb 56                	jmp    802b9f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b4d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b54:	00 00 00 
  802b57:	48 89 c7             	mov    %rax,%rdi
  802b5a:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  802b61:	00 00 00 
  802b64:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b66:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b6d:	00 00 00 
  802b70:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b7a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b80:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b87:	00 00 00 
  802b8a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b94:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b9f:	c9                   	leaveq 
  802ba0:	c3                   	retq   

0000000000802ba1 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ba1:	55                   	push   %rbp
  802ba2:	48 89 e5             	mov    %rsp,%rbp
  802ba5:	48 83 ec 10          	sub    $0x10,%rsp
  802ba9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bad:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802bb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb4:	8b 50 0c             	mov    0xc(%rax),%edx
  802bb7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bbe:	00 00 00 
  802bc1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802bc3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bca:	00 00 00 
  802bcd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802bd0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802bd3:	be 00 00 00 00       	mov    $0x0,%esi
  802bd8:	bf 02 00 00 00       	mov    $0x2,%edi
  802bdd:	48 b8 a7 27 80 00 00 	movabs $0x8027a7,%rax
  802be4:	00 00 00 
  802be7:	ff d0                	callq  *%rax
}
  802be9:	c9                   	leaveq 
  802bea:	c3                   	retq   

0000000000802beb <remove>:

// Delete a file
int
remove(const char *path)
{
  802beb:	55                   	push   %rbp
  802bec:	48 89 e5             	mov    %rsp,%rbp
  802bef:	48 83 ec 10          	sub    $0x10,%rsp
  802bf3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802bf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bfb:	48 89 c7             	mov    %rax,%rdi
  802bfe:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  802c05:	00 00 00 
  802c08:	ff d0                	callq  *%rax
  802c0a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c0f:	7e 07                	jle    802c18 <remove+0x2d>
		return -E_BAD_PATH;
  802c11:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c16:	eb 33                	jmp    802c4b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c1c:	48 89 c6             	mov    %rax,%rsi
  802c1f:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c26:	00 00 00 
  802c29:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  802c30:	00 00 00 
  802c33:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c35:	be 00 00 00 00       	mov    $0x0,%esi
  802c3a:	bf 07 00 00 00       	mov    $0x7,%edi
  802c3f:	48 b8 a7 27 80 00 00 	movabs $0x8027a7,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	callq  *%rax
}
  802c4b:	c9                   	leaveq 
  802c4c:	c3                   	retq   

0000000000802c4d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c4d:	55                   	push   %rbp
  802c4e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c51:	be 00 00 00 00       	mov    $0x0,%esi
  802c56:	bf 08 00 00 00       	mov    $0x8,%edi
  802c5b:	48 b8 a7 27 80 00 00 	movabs $0x8027a7,%rax
  802c62:	00 00 00 
  802c65:	ff d0                	callq  *%rax
}
  802c67:	5d                   	pop    %rbp
  802c68:	c3                   	retq   

0000000000802c69 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c69:	55                   	push   %rbp
  802c6a:	48 89 e5             	mov    %rsp,%rbp
  802c6d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c74:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c7b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c82:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c89:	be 00 00 00 00       	mov    $0x0,%esi
  802c8e:	48 89 c7             	mov    %rax,%rdi
  802c91:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
  802c9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ca0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca4:	79 28                	jns    802cce <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ca6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca9:	89 c6                	mov    %eax,%esi
  802cab:	48 bf 3a 4b 80 00 00 	movabs $0x804b3a,%rdi
  802cb2:	00 00 00 
  802cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cba:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802cc1:	00 00 00 
  802cc4:	ff d2                	callq  *%rdx
		return fd_src;
  802cc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc9:	e9 74 01 00 00       	jmpq   802e42 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802cce:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802cd5:	be 01 01 00 00       	mov    $0x101,%esi
  802cda:	48 89 c7             	mov    %rax,%rdi
  802cdd:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  802ce4:	00 00 00 
  802ce7:	ff d0                	callq  *%rax
  802ce9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802cec:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cf0:	79 39                	jns    802d2b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802cf2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf5:	89 c6                	mov    %eax,%esi
  802cf7:	48 bf 50 4b 80 00 00 	movabs $0x804b50,%rdi
  802cfe:	00 00 00 
  802d01:	b8 00 00 00 00       	mov    $0x0,%eax
  802d06:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802d0d:	00 00 00 
  802d10:	ff d2                	callq  *%rdx
		close(fd_src);
  802d12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d15:	89 c7                	mov    %eax,%edi
  802d17:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
		return fd_dest;
  802d23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d26:	e9 17 01 00 00       	jmpq   802e42 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d2b:	eb 74                	jmp    802da1 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d2d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d30:	48 63 d0             	movslq %eax,%rdx
  802d33:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d3d:	48 89 ce             	mov    %rcx,%rsi
  802d40:	89 c7                	mov    %eax,%edi
  802d42:	48 b8 d5 24 80 00 00 	movabs $0x8024d5,%rax
  802d49:	00 00 00 
  802d4c:	ff d0                	callq  *%rax
  802d4e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d51:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d55:	79 4a                	jns    802da1 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d57:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d5a:	89 c6                	mov    %eax,%esi
  802d5c:	48 bf 6a 4b 80 00 00 	movabs $0x804b6a,%rdi
  802d63:	00 00 00 
  802d66:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6b:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802d72:	00 00 00 
  802d75:	ff d2                	callq  *%rdx
			close(fd_src);
  802d77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7a:	89 c7                	mov    %eax,%edi
  802d7c:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  802d83:	00 00 00 
  802d86:	ff d0                	callq  *%rax
			close(fd_dest);
  802d88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d8b:	89 c7                	mov    %eax,%edi
  802d8d:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  802d94:	00 00 00 
  802d97:	ff d0                	callq  *%rax
			return write_size;
  802d99:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d9c:	e9 a1 00 00 00       	jmpq   802e42 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802da1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dab:	ba 00 02 00 00       	mov    $0x200,%edx
  802db0:	48 89 ce             	mov    %rcx,%rsi
  802db3:	89 c7                	mov    %eax,%edi
  802db5:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  802dbc:	00 00 00 
  802dbf:	ff d0                	callq  *%rax
  802dc1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802dc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802dc8:	0f 8f 5f ff ff ff    	jg     802d2d <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802dce:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802dd2:	79 47                	jns    802e1b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802dd4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dd7:	89 c6                	mov    %eax,%esi
  802dd9:	48 bf 7d 4b 80 00 00 	movabs $0x804b7d,%rdi
  802de0:	00 00 00 
  802de3:	b8 00 00 00 00       	mov    $0x0,%eax
  802de8:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802def:	00 00 00 
  802df2:	ff d2                	callq  *%rdx
		close(fd_src);
  802df4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df7:	89 c7                	mov    %eax,%edi
  802df9:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  802e00:	00 00 00 
  802e03:	ff d0                	callq  *%rax
		close(fd_dest);
  802e05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e08:	89 c7                	mov    %eax,%edi
  802e0a:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  802e11:	00 00 00 
  802e14:	ff d0                	callq  *%rax
		return read_size;
  802e16:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e19:	eb 27                	jmp    802e42 <copy+0x1d9>
	}
	close(fd_src);
  802e1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1e:	89 c7                	mov    %eax,%edi
  802e20:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  802e27:	00 00 00 
  802e2a:	ff d0                	callq  *%rax
	close(fd_dest);
  802e2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e2f:	89 c7                	mov    %eax,%edi
  802e31:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	callq  *%rax
	return 0;
  802e3d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e42:	c9                   	leaveq 
  802e43:	c3                   	retq   

0000000000802e44 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802e44:	55                   	push   %rbp
  802e45:	48 89 e5             	mov    %rsp,%rbp
  802e48:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802e4f:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802e56:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802e5d:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802e64:	be 00 00 00 00       	mov    $0x0,%esi
  802e69:	48 89 c7             	mov    %rax,%rdi
  802e6c:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
  802e78:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e7f:	79 08                	jns    802e89 <spawn+0x45>
		return r;
  802e81:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e84:	e9 0c 03 00 00       	jmpq   803195 <spawn+0x351>
	fd = r;
  802e89:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e8c:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802e8f:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802e96:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802e9a:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802ea1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802ea4:	ba 00 02 00 00       	mov    $0x200,%edx
  802ea9:	48 89 ce             	mov    %rcx,%rsi
  802eac:	89 c7                	mov    %eax,%edi
  802eae:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
  802eba:	3d 00 02 00 00       	cmp    $0x200,%eax
  802ebf:	75 0d                	jne    802ece <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802ec1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ec5:	8b 00                	mov    (%rax),%eax
  802ec7:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802ecc:	74 43                	je     802f11 <spawn+0xcd>
		close(fd);
  802ece:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802ed1:	89 c7                	mov    %eax,%edi
  802ed3:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  802eda:	00 00 00 
  802edd:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802edf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee3:	8b 00                	mov    (%rax),%eax
  802ee5:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802eea:	89 c6                	mov    %eax,%esi
  802eec:	48 bf 98 4b 80 00 00 	movabs $0x804b98,%rdi
  802ef3:	00 00 00 
  802ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  802efb:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  802f02:	00 00 00 
  802f05:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802f07:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802f0c:	e9 84 02 00 00       	jmpq   803195 <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802f11:	b8 07 00 00 00       	mov    $0x7,%eax
  802f16:	cd 30                	int    $0x30
  802f18:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802f1b:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802f1e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f21:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f25:	79 08                	jns    802f2f <spawn+0xeb>
		return r;
  802f27:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f2a:	e9 66 02 00 00       	jmpq   803195 <spawn+0x351>
	child = r;
  802f2f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f32:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802f35:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f38:	25 ff 03 00 00       	and    $0x3ff,%eax
  802f3d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802f44:	00 00 00 
  802f47:	48 98                	cltq   
  802f49:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802f50:	48 01 d0             	add    %rdx,%rax
  802f53:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802f5a:	48 89 c6             	mov    %rax,%rsi
  802f5d:	b8 18 00 00 00       	mov    $0x18,%eax
  802f62:	48 89 d7             	mov    %rdx,%rdi
  802f65:	48 89 c1             	mov    %rax,%rcx
  802f68:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802f6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f6f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f73:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802f7a:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802f81:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802f88:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802f8f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f92:	48 89 ce             	mov    %rcx,%rsi
  802f95:	89 c7                	mov    %eax,%edi
  802f97:	48 b8 ff 33 80 00 00 	movabs $0x8033ff,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
  802fa3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802fa6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802faa:	79 08                	jns    802fb4 <spawn+0x170>
		return r;
  802fac:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802faf:	e9 e1 01 00 00       	jmpq   803195 <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802fb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fb8:	48 8b 40 20          	mov    0x20(%rax),%rax
  802fbc:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802fc3:	48 01 d0             	add    %rdx,%rax
  802fc6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802fca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802fd1:	e9 a3 00 00 00       	jmpq   803079 <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  802fd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fda:	8b 00                	mov    (%rax),%eax
  802fdc:	83 f8 01             	cmp    $0x1,%eax
  802fdf:	74 05                	je     802fe6 <spawn+0x1a2>
			continue;
  802fe1:	e9 8a 00 00 00       	jmpq   803070 <spawn+0x22c>
		perm = PTE_P | PTE_U;
  802fe6:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802fed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff1:	8b 40 04             	mov    0x4(%rax),%eax
  802ff4:	83 e0 02             	and    $0x2,%eax
  802ff7:	85 c0                	test   %eax,%eax
  802ff9:	74 04                	je     802fff <spawn+0x1bb>
			perm |= PTE_W;
  802ffb:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802fff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803003:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803007:	41 89 c1             	mov    %eax,%r9d
  80300a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300e:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803012:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803016:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80301a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301e:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803022:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803025:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803028:	8b 7d ec             	mov    -0x14(%rbp),%edi
  80302b:	89 3c 24             	mov    %edi,(%rsp)
  80302e:	89 c7                	mov    %eax,%edi
  803030:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  803037:	00 00 00 
  80303a:	ff d0                	callq  *%rax
  80303c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80303f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803043:	79 2b                	jns    803070 <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803045:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803046:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803049:	89 c7                	mov    %eax,%edi
  80304b:	48 b8 65 19 80 00 00 	movabs $0x801965,%rax
  803052:	00 00 00 
  803055:	ff d0                	callq  *%rax
	close(fd);
  803057:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80305a:	89 c7                	mov    %eax,%edi
  80305c:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  803063:	00 00 00 
  803066:	ff d0                	callq  *%rax
	return r;
  803068:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80306b:	e9 25 01 00 00       	jmpq   803195 <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803070:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803074:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803079:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80307d:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803081:	0f b7 c0             	movzwl %ax,%eax
  803084:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803087:	0f 8f 49 ff ff ff    	jg     802fd6 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  80308d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803090:	89 c7                	mov    %eax,%edi
  803092:	48 b8 69 21 80 00 00 	movabs $0x802169,%rax
  803099:	00 00 00 
  80309c:	ff d0                	callq  *%rax
	fd = -1;
  80309e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8030a5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8030a8:	89 c7                	mov    %eax,%edi
  8030aa:	48 b8 94 38 80 00 00 	movabs $0x803894,%rax
  8030b1:	00 00 00 
  8030b4:	ff d0                	callq  *%rax
  8030b6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8030b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8030bd:	79 30                	jns    8030ef <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  8030bf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8030c2:	89 c1                	mov    %eax,%ecx
  8030c4:	48 ba b2 4b 80 00 00 	movabs $0x804bb2,%rdx
  8030cb:	00 00 00 
  8030ce:	be 82 00 00 00       	mov    $0x82,%esi
  8030d3:	48 bf c8 4b 80 00 00 	movabs $0x804bc8,%rdi
  8030da:	00 00 00 
  8030dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e2:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  8030e9:	00 00 00 
  8030ec:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8030ef:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8030f6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8030f9:	48 89 d6             	mov    %rdx,%rsi
  8030fc:	89 c7                	mov    %eax,%edi
  8030fe:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
  80310a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80310d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803111:	79 30                	jns    803143 <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  803113:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803116:	89 c1                	mov    %eax,%ecx
  803118:	48 ba d4 4b 80 00 00 	movabs $0x804bd4,%rdx
  80311f:	00 00 00 
  803122:	be 85 00 00 00       	mov    $0x85,%esi
  803127:	48 bf c8 4b 80 00 00 	movabs $0x804bc8,%rdi
  80312e:	00 00 00 
  803131:	b8 00 00 00 00       	mov    $0x0,%eax
  803136:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  80313d:	00 00 00 
  803140:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803143:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803146:	be 02 00 00 00       	mov    $0x2,%esi
  80314b:	89 c7                	mov    %eax,%edi
  80314d:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  803154:	00 00 00 
  803157:	ff d0                	callq  *%rax
  803159:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80315c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803160:	79 30                	jns    803192 <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  803162:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803165:	89 c1                	mov    %eax,%ecx
  803167:	48 ba ee 4b 80 00 00 	movabs $0x804bee,%rdx
  80316e:	00 00 00 
  803171:	be 88 00 00 00       	mov    $0x88,%esi
  803176:	48 bf c8 4b 80 00 00 	movabs $0x804bc8,%rdi
  80317d:	00 00 00 
  803180:	b8 00 00 00 00       	mov    $0x0,%eax
  803185:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  80318c:	00 00 00 
  80318f:	41 ff d0             	callq  *%r8

	return child;
  803192:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803195:	c9                   	leaveq 
  803196:	c3                   	retq   

0000000000803197 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803197:	55                   	push   %rbp
  803198:	48 89 e5             	mov    %rsp,%rbp
  80319b:	41 55                	push   %r13
  80319d:	41 54                	push   %r12
  80319f:	53                   	push   %rbx
  8031a0:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8031a7:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8031ae:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8031b5:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8031bc:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8031c3:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8031ca:	84 c0                	test   %al,%al
  8031cc:	74 26                	je     8031f4 <spawnl+0x5d>
  8031ce:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8031d5:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8031dc:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8031e0:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8031e4:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8031e8:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8031ec:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8031f0:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  8031f4:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8031fb:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803202:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803205:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80320c:	00 00 00 
  80320f:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803216:	00 00 00 
  803219:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80321d:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803224:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80322b:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803232:	eb 07                	jmp    80323b <spawnl+0xa4>
		argc++;
  803234:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80323b:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803241:	83 f8 30             	cmp    $0x30,%eax
  803244:	73 23                	jae    803269 <spawnl+0xd2>
  803246:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80324d:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803253:	89 c0                	mov    %eax,%eax
  803255:	48 01 d0             	add    %rdx,%rax
  803258:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80325e:	83 c2 08             	add    $0x8,%edx
  803261:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803267:	eb 15                	jmp    80327e <spawnl+0xe7>
  803269:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803270:	48 89 d0             	mov    %rdx,%rax
  803273:	48 83 c2 08          	add    $0x8,%rdx
  803277:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80327e:	48 8b 00             	mov    (%rax),%rax
  803281:	48 85 c0             	test   %rax,%rax
  803284:	75 ae                	jne    803234 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803286:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80328c:	83 c0 02             	add    $0x2,%eax
  80328f:	48 89 e2             	mov    %rsp,%rdx
  803292:	48 89 d3             	mov    %rdx,%rbx
  803295:	48 63 d0             	movslq %eax,%rdx
  803298:	48 83 ea 01          	sub    $0x1,%rdx
  80329c:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8032a3:	48 63 d0             	movslq %eax,%rdx
  8032a6:	49 89 d4             	mov    %rdx,%r12
  8032a9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8032af:	48 63 d0             	movslq %eax,%rdx
  8032b2:	49 89 d2             	mov    %rdx,%r10
  8032b5:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8032bb:	48 98                	cltq   
  8032bd:	48 c1 e0 03          	shl    $0x3,%rax
  8032c1:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8032c5:	b8 10 00 00 00       	mov    $0x10,%eax
  8032ca:	48 83 e8 01          	sub    $0x1,%rax
  8032ce:	48 01 d0             	add    %rdx,%rax
  8032d1:	bf 10 00 00 00       	mov    $0x10,%edi
  8032d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8032db:	48 f7 f7             	div    %rdi
  8032de:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8032e2:	48 29 c4             	sub    %rax,%rsp
  8032e5:	48 89 e0             	mov    %rsp,%rax
  8032e8:	48 83 c0 07          	add    $0x7,%rax
  8032ec:	48 c1 e8 03          	shr    $0x3,%rax
  8032f0:	48 c1 e0 03          	shl    $0x3,%rax
  8032f4:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8032fb:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803302:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803309:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80330c:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803312:	8d 50 01             	lea    0x1(%rax),%edx
  803315:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80331c:	48 63 d2             	movslq %edx,%rdx
  80331f:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803326:	00 

	va_start(vl, arg0);
  803327:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80332e:	00 00 00 
  803331:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803338:	00 00 00 
  80333b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80333f:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803346:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80334d:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803354:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80335b:	00 00 00 
  80335e:	eb 63                	jmp    8033c3 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803360:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803366:	8d 70 01             	lea    0x1(%rax),%esi
  803369:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80336f:	83 f8 30             	cmp    $0x30,%eax
  803372:	73 23                	jae    803397 <spawnl+0x200>
  803374:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80337b:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803381:	89 c0                	mov    %eax,%eax
  803383:	48 01 d0             	add    %rdx,%rax
  803386:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80338c:	83 c2 08             	add    $0x8,%edx
  80338f:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803395:	eb 15                	jmp    8033ac <spawnl+0x215>
  803397:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80339e:	48 89 d0             	mov    %rdx,%rax
  8033a1:	48 83 c2 08          	add    $0x8,%rdx
  8033a5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8033ac:	48 8b 08             	mov    (%rax),%rcx
  8033af:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8033b6:	89 f2                	mov    %esi,%edx
  8033b8:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8033bc:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8033c3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8033c9:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8033cf:	77 8f                	ja     803360 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8033d1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8033d8:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8033df:	48 89 d6             	mov    %rdx,%rsi
  8033e2:	48 89 c7             	mov    %rax,%rdi
  8033e5:	48 b8 44 2e 80 00 00 	movabs $0x802e44,%rax
  8033ec:	00 00 00 
  8033ef:	ff d0                	callq  *%rax
  8033f1:	48 89 dc             	mov    %rbx,%rsp
}
  8033f4:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8033f8:	5b                   	pop    %rbx
  8033f9:	41 5c                	pop    %r12
  8033fb:	41 5d                	pop    %r13
  8033fd:	5d                   	pop    %rbp
  8033fe:	c3                   	retq   

00000000008033ff <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8033ff:	55                   	push   %rbp
  803400:	48 89 e5             	mov    %rsp,%rbp
  803403:	48 83 ec 50          	sub    $0x50,%rsp
  803407:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80340a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80340e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803412:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803419:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  80341a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803421:	eb 33                	jmp    803456 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803423:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803426:	48 98                	cltq   
  803428:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80342f:	00 
  803430:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803434:	48 01 d0             	add    %rdx,%rax
  803437:	48 8b 00             	mov    (%rax),%rax
  80343a:	48 89 c7             	mov    %rax,%rdi
  80343d:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  803444:	00 00 00 
  803447:	ff d0                	callq  *%rax
  803449:	83 c0 01             	add    $0x1,%eax
  80344c:	48 98                	cltq   
  80344e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803452:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803456:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803459:	48 98                	cltq   
  80345b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803462:	00 
  803463:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803467:	48 01 d0             	add    %rdx,%rax
  80346a:	48 8b 00             	mov    (%rax),%rax
  80346d:	48 85 c0             	test   %rax,%rax
  803470:	75 b1                	jne    803423 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803472:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803476:	48 f7 d8             	neg    %rax
  803479:	48 05 00 10 40 00    	add    $0x401000,%rax
  80347f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803483:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803487:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80348b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80348f:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803493:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803496:	83 c2 01             	add    $0x1,%edx
  803499:	c1 e2 03             	shl    $0x3,%edx
  80349c:	48 63 d2             	movslq %edx,%rdx
  80349f:	48 f7 da             	neg    %rdx
  8034a2:	48 01 d0             	add    %rdx,%rax
  8034a5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8034a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034ad:	48 83 e8 10          	sub    $0x10,%rax
  8034b1:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8034b7:	77 0a                	ja     8034c3 <init_stack+0xc4>
		return -E_NO_MEM;
  8034b9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8034be:	e9 e3 01 00 00       	jmpq   8036a6 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8034c3:	ba 07 00 00 00       	mov    $0x7,%edx
  8034c8:	be 00 00 40 00       	mov    $0x400000,%esi
  8034cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d2:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  8034d9:	00 00 00 
  8034dc:	ff d0                	callq  *%rax
  8034de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034e5:	79 08                	jns    8034ef <init_stack+0xf0>
		return r;
  8034e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ea:	e9 b7 01 00 00       	jmpq   8036a6 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8034ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8034f6:	e9 8a 00 00 00       	jmpq   803585 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8034fb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034fe:	48 98                	cltq   
  803500:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803507:	00 
  803508:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80350c:	48 01 c2             	add    %rax,%rdx
  80350f:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803514:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803518:	48 01 c8             	add    %rcx,%rax
  80351b:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803521:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803524:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803527:	48 98                	cltq   
  803529:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803530:	00 
  803531:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803535:	48 01 d0             	add    %rdx,%rax
  803538:	48 8b 10             	mov    (%rax),%rdx
  80353b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80353f:	48 89 d6             	mov    %rdx,%rsi
  803542:	48 89 c7             	mov    %rax,%rdi
  803545:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  80354c:	00 00 00 
  80354f:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803551:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803554:	48 98                	cltq   
  803556:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80355d:	00 
  80355e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803562:	48 01 d0             	add    %rdx,%rax
  803565:	48 8b 00             	mov    (%rax),%rax
  803568:	48 89 c7             	mov    %rax,%rdi
  80356b:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
  803577:	48 98                	cltq   
  803579:	48 83 c0 01          	add    $0x1,%rax
  80357d:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803581:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803585:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803588:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80358b:	0f 8c 6a ff ff ff    	jl     8034fb <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803591:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803594:	48 98                	cltq   
  803596:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80359d:	00 
  80359e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035a2:	48 01 d0             	add    %rdx,%rax
  8035a5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8035ac:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8035b3:	00 
  8035b4:	74 35                	je     8035eb <init_stack+0x1ec>
  8035b6:	48 b9 08 4c 80 00 00 	movabs $0x804c08,%rcx
  8035bd:	00 00 00 
  8035c0:	48 ba 2e 4c 80 00 00 	movabs $0x804c2e,%rdx
  8035c7:	00 00 00 
  8035ca:	be f1 00 00 00       	mov    $0xf1,%esi
  8035cf:	48 bf c8 4b 80 00 00 	movabs $0x804bc8,%rdi
  8035d6:	00 00 00 
  8035d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035de:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  8035e5:	00 00 00 
  8035e8:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8035eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035ef:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8035f3:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8035f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035fc:	48 01 c8             	add    %rcx,%rax
  8035ff:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803605:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803608:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80360c:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803610:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803613:	48 98                	cltq   
  803615:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803618:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80361d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803621:	48 01 d0             	add    %rdx,%rax
  803624:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80362a:	48 89 c2             	mov    %rax,%rdx
  80362d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803631:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803634:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803637:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80363d:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803642:	89 c2                	mov    %eax,%edx
  803644:	be 00 00 40 00       	mov    $0x400000,%esi
  803649:	bf 00 00 00 00       	mov    $0x0,%edi
  80364e:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  803655:	00 00 00 
  803658:	ff d0                	callq  *%rax
  80365a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80365d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803661:	79 02                	jns    803665 <init_stack+0x266>
		goto error;
  803663:	eb 28                	jmp    80368d <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803665:	be 00 00 40 00       	mov    $0x400000,%esi
  80366a:	bf 00 00 00 00       	mov    $0x0,%edi
  80366f:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803676:	00 00 00 
  803679:	ff d0                	callq  *%rax
  80367b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80367e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803682:	79 02                	jns    803686 <init_stack+0x287>
		goto error;
  803684:	eb 07                	jmp    80368d <init_stack+0x28e>

	return 0;
  803686:	b8 00 00 00 00       	mov    $0x0,%eax
  80368b:	eb 19                	jmp    8036a6 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  80368d:	be 00 00 40 00       	mov    $0x400000,%esi
  803692:	bf 00 00 00 00       	mov    $0x0,%edi
  803697:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  80369e:	00 00 00 
  8036a1:	ff d0                	callq  *%rax
	return r;
  8036a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036a6:	c9                   	leaveq 
  8036a7:	c3                   	retq   

00000000008036a8 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8036a8:	55                   	push   %rbp
  8036a9:	48 89 e5             	mov    %rsp,%rbp
  8036ac:	48 83 ec 50          	sub    $0x50,%rsp
  8036b0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8036b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036b7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8036bb:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8036be:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8036c2:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8036c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ca:	25 ff 0f 00 00       	and    $0xfff,%eax
  8036cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036d6:	74 21                	je     8036f9 <map_segment+0x51>
		va -= i;
  8036d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036db:	48 98                	cltq   
  8036dd:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8036e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e4:	48 98                	cltq   
  8036e6:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8036ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ed:	48 98                	cltq   
  8036ef:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8036f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f6:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8036f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803700:	e9 79 01 00 00       	jmpq   80387e <map_segment+0x1d6>
		if (i >= filesz) {
  803705:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803708:	48 98                	cltq   
  80370a:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80370e:	72 3c                	jb     80374c <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803710:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803713:	48 63 d0             	movslq %eax,%rdx
  803716:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80371a:	48 01 d0             	add    %rdx,%rax
  80371d:	48 89 c1             	mov    %rax,%rcx
  803720:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803723:	8b 55 10             	mov    0x10(%rbp),%edx
  803726:	48 89 ce             	mov    %rcx,%rsi
  803729:	89 c7                	mov    %eax,%edi
  80372b:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  803732:	00 00 00 
  803735:	ff d0                	callq  *%rax
  803737:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80373a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80373e:	0f 89 33 01 00 00    	jns    803877 <map_segment+0x1cf>
				return r;
  803744:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803747:	e9 46 01 00 00       	jmpq   803892 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80374c:	ba 07 00 00 00       	mov    $0x7,%edx
  803751:	be 00 00 40 00       	mov    $0x400000,%esi
  803756:	bf 00 00 00 00       	mov    $0x0,%edi
  80375b:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  803762:	00 00 00 
  803765:	ff d0                	callq  *%rax
  803767:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80376a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80376e:	79 08                	jns    803778 <map_segment+0xd0>
				return r;
  803770:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803773:	e9 1a 01 00 00       	jmpq   803892 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803778:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377b:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80377e:	01 c2                	add    %eax,%edx
  803780:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803783:	89 d6                	mov    %edx,%esi
  803785:	89 c7                	mov    %eax,%edi
  803787:	48 b8 76 25 80 00 00 	movabs $0x802576,%rax
  80378e:	00 00 00 
  803791:	ff d0                	callq  *%rax
  803793:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803796:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80379a:	79 08                	jns    8037a4 <map_segment+0xfc>
				return r;
  80379c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80379f:	e9 ee 00 00 00       	jmpq   803892 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8037a4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8037ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ae:	48 98                	cltq   
  8037b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8037b4:	48 29 c2             	sub    %rax,%rdx
  8037b7:	48 89 d0             	mov    %rdx,%rax
  8037ba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8037be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037c1:	48 63 d0             	movslq %eax,%rdx
  8037c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c8:	48 39 c2             	cmp    %rax,%rdx
  8037cb:	48 0f 47 d0          	cmova  %rax,%rdx
  8037cf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8037d2:	be 00 00 40 00       	mov    $0x400000,%esi
  8037d7:	89 c7                	mov    %eax,%edi
  8037d9:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  8037e0:	00 00 00 
  8037e3:	ff d0                	callq  *%rax
  8037e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8037e8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8037ec:	79 08                	jns    8037f6 <map_segment+0x14e>
				return r;
  8037ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037f1:	e9 9c 00 00 00       	jmpq   803892 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8037f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f9:	48 63 d0             	movslq %eax,%rdx
  8037fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803800:	48 01 d0             	add    %rdx,%rax
  803803:	48 89 c2             	mov    %rax,%rdx
  803806:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803809:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80380d:	48 89 d1             	mov    %rdx,%rcx
  803810:	89 c2                	mov    %eax,%edx
  803812:	be 00 00 40 00       	mov    $0x400000,%esi
  803817:	bf 00 00 00 00       	mov    $0x0,%edi
  80381c:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  803823:	00 00 00 
  803826:	ff d0                	callq  *%rax
  803828:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80382b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80382f:	79 30                	jns    803861 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803831:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803834:	89 c1                	mov    %eax,%ecx
  803836:	48 ba 43 4c 80 00 00 	movabs $0x804c43,%rdx
  80383d:	00 00 00 
  803840:	be 24 01 00 00       	mov    $0x124,%esi
  803845:	48 bf c8 4b 80 00 00 	movabs $0x804bc8,%rdi
  80384c:	00 00 00 
  80384f:	b8 00 00 00 00       	mov    $0x0,%eax
  803854:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  80385b:	00 00 00 
  80385e:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803861:	be 00 00 40 00       	mov    $0x400000,%esi
  803866:	bf 00 00 00 00       	mov    $0x0,%edi
  80386b:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803872:	00 00 00 
  803875:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803877:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80387e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803881:	48 98                	cltq   
  803883:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803887:	0f 82 78 fe ff ff    	jb     803705 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  80388d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803892:	c9                   	leaveq 
  803893:	c3                   	retq   

0000000000803894 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803894:	55                   	push   %rbp
  803895:	48 89 e5             	mov    %rsp,%rbp
  803898:	48 83 ec 20          	sub    $0x20,%rsp
  80389c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  80389f:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8038a6:	00 
  8038a7:	e9 c9 00 00 00       	jmpq   803975 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  8038ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b0:	48 c1 e8 27          	shr    $0x27,%rax
  8038b4:	48 89 c2             	mov    %rax,%rdx
  8038b7:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8038be:	01 00 00 
  8038c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038c5:	48 85 c0             	test   %rax,%rax
  8038c8:	74 3c                	je     803906 <copy_shared_pages+0x72>
  8038ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ce:	48 c1 e8 1e          	shr    $0x1e,%rax
  8038d2:	48 89 c2             	mov    %rax,%rdx
  8038d5:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8038dc:	01 00 00 
  8038df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038e3:	48 85 c0             	test   %rax,%rax
  8038e6:	74 1e                	je     803906 <copy_shared_pages+0x72>
  8038e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ec:	48 c1 e8 15          	shr    $0x15,%rax
  8038f0:	48 89 c2             	mov    %rax,%rdx
  8038f3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8038fa:	01 00 00 
  8038fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803901:	48 85 c0             	test   %rax,%rax
  803904:	75 02                	jne    803908 <copy_shared_pages+0x74>
                continue;
  803906:	eb 65                	jmp    80396d <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803908:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80390c:	48 c1 e8 0c          	shr    $0xc,%rax
  803910:	48 89 c2             	mov    %rax,%rdx
  803913:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80391a:	01 00 00 
  80391d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803921:	25 00 04 00 00       	and    $0x400,%eax
  803926:	48 85 c0             	test   %rax,%rax
  803929:	74 42                	je     80396d <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  80392b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80392f:	48 c1 e8 0c          	shr    $0xc,%rax
  803933:	48 89 c2             	mov    %rax,%rdx
  803936:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80393d:	01 00 00 
  803940:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803944:	25 07 0e 00 00       	and    $0xe07,%eax
  803949:	89 c6                	mov    %eax,%esi
  80394b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80394f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803953:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803956:	41 89 f0             	mov    %esi,%r8d
  803959:	48 89 c6             	mov    %rax,%rsi
  80395c:	bf 00 00 00 00       	mov    $0x0,%edi
  803961:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  803968:	00 00 00 
  80396b:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  80396d:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803974:	00 
  803975:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  80397c:	00 00 00 
  80397f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803983:	0f 86 23 ff ff ff    	jbe    8038ac <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  803989:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  80398e:	c9                   	leaveq 
  80398f:	c3                   	retq   

0000000000803990 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803990:	55                   	push   %rbp
  803991:	48 89 e5             	mov    %rsp,%rbp
  803994:	53                   	push   %rbx
  803995:	48 83 ec 38          	sub    $0x38,%rsp
  803999:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80399d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8039a1:	48 89 c7             	mov    %rax,%rdi
  8039a4:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  8039ab:	00 00 00 
  8039ae:	ff d0                	callq  *%rax
  8039b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039b7:	0f 88 bf 01 00 00    	js     803b7c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c1:	ba 07 04 00 00       	mov    $0x407,%edx
  8039c6:	48 89 c6             	mov    %rax,%rsi
  8039c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8039ce:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  8039d5:	00 00 00 
  8039d8:	ff d0                	callq  *%rax
  8039da:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039e1:	0f 88 95 01 00 00    	js     803b7c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8039e7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8039eb:	48 89 c7             	mov    %rax,%rdi
  8039ee:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  8039f5:	00 00 00 
  8039f8:	ff d0                	callq  *%rax
  8039fa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a01:	0f 88 5d 01 00 00    	js     803b64 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a07:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a0b:	ba 07 04 00 00       	mov    $0x407,%edx
  803a10:	48 89 c6             	mov    %rax,%rsi
  803a13:	bf 00 00 00 00       	mov    $0x0,%edi
  803a18:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  803a1f:	00 00 00 
  803a22:	ff d0                	callq  *%rax
  803a24:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a27:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a2b:	0f 88 33 01 00 00    	js     803b64 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a35:	48 89 c7             	mov    %rax,%rdi
  803a38:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  803a3f:	00 00 00 
  803a42:	ff d0                	callq  *%rax
  803a44:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a4c:	ba 07 04 00 00       	mov    $0x407,%edx
  803a51:	48 89 c6             	mov    %rax,%rsi
  803a54:	bf 00 00 00 00       	mov    $0x0,%edi
  803a59:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  803a60:	00 00 00 
  803a63:	ff d0                	callq  *%rax
  803a65:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a68:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a6c:	79 05                	jns    803a73 <pipe+0xe3>
		goto err2;
  803a6e:	e9 d9 00 00 00       	jmpq   803b4c <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a77:	48 89 c7             	mov    %rax,%rdi
  803a7a:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  803a81:	00 00 00 
  803a84:	ff d0                	callq  *%rax
  803a86:	48 89 c2             	mov    %rax,%rdx
  803a89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a8d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803a93:	48 89 d1             	mov    %rdx,%rcx
  803a96:	ba 00 00 00 00       	mov    $0x0,%edx
  803a9b:	48 89 c6             	mov    %rax,%rsi
  803a9e:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa3:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  803aaa:	00 00 00 
  803aad:	ff d0                	callq  *%rax
  803aaf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ab2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ab6:	79 1b                	jns    803ad3 <pipe+0x143>
		goto err3;
  803ab8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803ab9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803abd:	48 89 c6             	mov    %rax,%rsi
  803ac0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac5:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803acc:	00 00 00 
  803acf:	ff d0                	callq  *%rax
  803ad1:	eb 79                	jmp    803b4c <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803ad3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803ade:	00 00 00 
  803ae1:	8b 12                	mov    (%rdx),%edx
  803ae3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803ae5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803af0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803af4:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803afb:	00 00 00 
  803afe:	8b 12                	mov    (%rdx),%edx
  803b00:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b06:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b11:	48 89 c7             	mov    %rax,%rdi
  803b14:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  803b1b:	00 00 00 
  803b1e:	ff d0                	callq  *%rax
  803b20:	89 c2                	mov    %eax,%edx
  803b22:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b26:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b28:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b2c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b34:	48 89 c7             	mov    %rax,%rdi
  803b37:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  803b3e:	00 00 00 
  803b41:	ff d0                	callq  *%rax
  803b43:	89 03                	mov    %eax,(%rbx)
	return 0;
  803b45:	b8 00 00 00 00       	mov    $0x0,%eax
  803b4a:	eb 33                	jmp    803b7f <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803b4c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b50:	48 89 c6             	mov    %rax,%rsi
  803b53:	bf 00 00 00 00       	mov    $0x0,%edi
  803b58:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803b5f:	00 00 00 
  803b62:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803b64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b68:	48 89 c6             	mov    %rax,%rsi
  803b6b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b70:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803b77:	00 00 00 
  803b7a:	ff d0                	callq  *%rax
err:
	return r;
  803b7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803b7f:	48 83 c4 38          	add    $0x38,%rsp
  803b83:	5b                   	pop    %rbx
  803b84:	5d                   	pop    %rbp
  803b85:	c3                   	retq   

0000000000803b86 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803b86:	55                   	push   %rbp
  803b87:	48 89 e5             	mov    %rsp,%rbp
  803b8a:	53                   	push   %rbx
  803b8b:	48 83 ec 28          	sub    $0x28,%rsp
  803b8f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b93:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803b97:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b9e:	00 00 00 
  803ba1:	48 8b 00             	mov    (%rax),%rax
  803ba4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803baa:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803bad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bb1:	48 89 c7             	mov    %rax,%rdi
  803bb4:	48 b8 04 44 80 00 00 	movabs $0x804404,%rax
  803bbb:	00 00 00 
  803bbe:	ff d0                	callq  *%rax
  803bc0:	89 c3                	mov    %eax,%ebx
  803bc2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bc6:	48 89 c7             	mov    %rax,%rdi
  803bc9:	48 b8 04 44 80 00 00 	movabs $0x804404,%rax
  803bd0:	00 00 00 
  803bd3:	ff d0                	callq  *%rax
  803bd5:	39 c3                	cmp    %eax,%ebx
  803bd7:	0f 94 c0             	sete   %al
  803bda:	0f b6 c0             	movzbl %al,%eax
  803bdd:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803be0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803be7:	00 00 00 
  803bea:	48 8b 00             	mov    (%rax),%rax
  803bed:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803bf3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803bf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bf9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803bfc:	75 05                	jne    803c03 <_pipeisclosed+0x7d>
			return ret;
  803bfe:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c01:	eb 4f                	jmp    803c52 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803c03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c06:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c09:	74 42                	je     803c4d <_pipeisclosed+0xc7>
  803c0b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803c0f:	75 3c                	jne    803c4d <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c11:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c18:	00 00 00 
  803c1b:	48 8b 00             	mov    (%rax),%rax
  803c1e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c24:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c2a:	89 c6                	mov    %eax,%esi
  803c2c:	48 bf 6a 4c 80 00 00 	movabs $0x804c6a,%rdi
  803c33:	00 00 00 
  803c36:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3b:	49 b8 41 05 80 00 00 	movabs $0x800541,%r8
  803c42:	00 00 00 
  803c45:	41 ff d0             	callq  *%r8
	}
  803c48:	e9 4a ff ff ff       	jmpq   803b97 <_pipeisclosed+0x11>
  803c4d:	e9 45 ff ff ff       	jmpq   803b97 <_pipeisclosed+0x11>
}
  803c52:	48 83 c4 28          	add    $0x28,%rsp
  803c56:	5b                   	pop    %rbx
  803c57:	5d                   	pop    %rbp
  803c58:	c3                   	retq   

0000000000803c59 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803c59:	55                   	push   %rbp
  803c5a:	48 89 e5             	mov    %rsp,%rbp
  803c5d:	48 83 ec 30          	sub    $0x30,%rsp
  803c61:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c64:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803c68:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c6b:	48 89 d6             	mov    %rdx,%rsi
  803c6e:	89 c7                	mov    %eax,%edi
  803c70:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  803c77:	00 00 00 
  803c7a:	ff d0                	callq  *%rax
  803c7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c83:	79 05                	jns    803c8a <pipeisclosed+0x31>
		return r;
  803c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c88:	eb 31                	jmp    803cbb <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803c8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c8e:	48 89 c7             	mov    %rax,%rdi
  803c91:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  803c98:	00 00 00 
  803c9b:	ff d0                	callq  *%rax
  803c9d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803ca1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ca9:	48 89 d6             	mov    %rdx,%rsi
  803cac:	48 89 c7             	mov    %rax,%rdi
  803caf:	48 b8 86 3b 80 00 00 	movabs $0x803b86,%rax
  803cb6:	00 00 00 
  803cb9:	ff d0                	callq  *%rax
}
  803cbb:	c9                   	leaveq 
  803cbc:	c3                   	retq   

0000000000803cbd <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cbd:	55                   	push   %rbp
  803cbe:	48 89 e5             	mov    %rsp,%rbp
  803cc1:	48 83 ec 40          	sub    $0x40,%rsp
  803cc5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803cc9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ccd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803cd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd5:	48 89 c7             	mov    %rax,%rdi
  803cd8:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  803cdf:	00 00 00 
  803ce2:	ff d0                	callq  *%rax
  803ce4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ce8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803cf0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cf7:	00 
  803cf8:	e9 92 00 00 00       	jmpq   803d8f <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803cfd:	eb 41                	jmp    803d40 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803cff:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d04:	74 09                	je     803d0f <devpipe_read+0x52>
				return i;
  803d06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d0a:	e9 92 00 00 00       	jmpq   803da1 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d17:	48 89 d6             	mov    %rdx,%rsi
  803d1a:	48 89 c7             	mov    %rax,%rdi
  803d1d:	48 b8 86 3b 80 00 00 	movabs $0x803b86,%rax
  803d24:	00 00 00 
  803d27:	ff d0                	callq  *%rax
  803d29:	85 c0                	test   %eax,%eax
  803d2b:	74 07                	je     803d34 <devpipe_read+0x77>
				return 0;
  803d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d32:	eb 6d                	jmp    803da1 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803d34:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  803d3b:	00 00 00 
  803d3e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803d40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d44:	8b 10                	mov    (%rax),%edx
  803d46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d4a:	8b 40 04             	mov    0x4(%rax),%eax
  803d4d:	39 c2                	cmp    %eax,%edx
  803d4f:	74 ae                	je     803cff <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803d51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d59:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803d5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d61:	8b 00                	mov    (%rax),%eax
  803d63:	99                   	cltd   
  803d64:	c1 ea 1b             	shr    $0x1b,%edx
  803d67:	01 d0                	add    %edx,%eax
  803d69:	83 e0 1f             	and    $0x1f,%eax
  803d6c:	29 d0                	sub    %edx,%eax
  803d6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d72:	48 98                	cltq   
  803d74:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803d79:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d7f:	8b 00                	mov    (%rax),%eax
  803d81:	8d 50 01             	lea    0x1(%rax),%edx
  803d84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d88:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d8a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d93:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d97:	0f 82 60 ff ff ff    	jb     803cfd <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803d9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803da1:	c9                   	leaveq 
  803da2:	c3                   	retq   

0000000000803da3 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803da3:	55                   	push   %rbp
  803da4:	48 89 e5             	mov    %rsp,%rbp
  803da7:	48 83 ec 40          	sub    $0x40,%rsp
  803dab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803daf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803db3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803db7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dbb:	48 89 c7             	mov    %rax,%rdi
  803dbe:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  803dc5:	00 00 00 
  803dc8:	ff d0                	callq  *%rax
  803dca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803dce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dd2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803dd6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ddd:	00 
  803dde:	e9 8e 00 00 00       	jmpq   803e71 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803de3:	eb 31                	jmp    803e16 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803de5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803de9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ded:	48 89 d6             	mov    %rdx,%rsi
  803df0:	48 89 c7             	mov    %rax,%rdi
  803df3:	48 b8 86 3b 80 00 00 	movabs $0x803b86,%rax
  803dfa:	00 00 00 
  803dfd:	ff d0                	callq  *%rax
  803dff:	85 c0                	test   %eax,%eax
  803e01:	74 07                	je     803e0a <devpipe_write+0x67>
				return 0;
  803e03:	b8 00 00 00 00       	mov    $0x0,%eax
  803e08:	eb 79                	jmp    803e83 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e0a:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  803e11:	00 00 00 
  803e14:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e1a:	8b 40 04             	mov    0x4(%rax),%eax
  803e1d:	48 63 d0             	movslq %eax,%rdx
  803e20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e24:	8b 00                	mov    (%rax),%eax
  803e26:	48 98                	cltq   
  803e28:	48 83 c0 20          	add    $0x20,%rax
  803e2c:	48 39 c2             	cmp    %rax,%rdx
  803e2f:	73 b4                	jae    803de5 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e35:	8b 40 04             	mov    0x4(%rax),%eax
  803e38:	99                   	cltd   
  803e39:	c1 ea 1b             	shr    $0x1b,%edx
  803e3c:	01 d0                	add    %edx,%eax
  803e3e:	83 e0 1f             	and    $0x1f,%eax
  803e41:	29 d0                	sub    %edx,%eax
  803e43:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e47:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e4b:	48 01 ca             	add    %rcx,%rdx
  803e4e:	0f b6 0a             	movzbl (%rdx),%ecx
  803e51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e55:	48 98                	cltq   
  803e57:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803e5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5f:	8b 40 04             	mov    0x4(%rax),%eax
  803e62:	8d 50 01             	lea    0x1(%rax),%edx
  803e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e69:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e6c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e75:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e79:	0f 82 64 ff ff ff    	jb     803de3 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803e7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e83:	c9                   	leaveq 
  803e84:	c3                   	retq   

0000000000803e85 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803e85:	55                   	push   %rbp
  803e86:	48 89 e5             	mov    %rsp,%rbp
  803e89:	48 83 ec 20          	sub    $0x20,%rsp
  803e8d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e91:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803e95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e99:	48 89 c7             	mov    %rax,%rdi
  803e9c:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  803ea3:	00 00 00 
  803ea6:	ff d0                	callq  *%rax
  803ea8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803eac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eb0:	48 be 7d 4c 80 00 00 	movabs $0x804c7d,%rsi
  803eb7:	00 00 00 
  803eba:	48 89 c7             	mov    %rax,%rdi
  803ebd:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  803ec4:	00 00 00 
  803ec7:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ec9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ecd:	8b 50 04             	mov    0x4(%rax),%edx
  803ed0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ed4:	8b 00                	mov    (%rax),%eax
  803ed6:	29 c2                	sub    %eax,%edx
  803ed8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803edc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ee2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ee6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803eed:	00 00 00 
	stat->st_dev = &devpipe;
  803ef0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ef4:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803efb:	00 00 00 
  803efe:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f0a:	c9                   	leaveq 
  803f0b:	c3                   	retq   

0000000000803f0c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f0c:	55                   	push   %rbp
  803f0d:	48 89 e5             	mov    %rsp,%rbp
  803f10:	48 83 ec 10          	sub    $0x10,%rsp
  803f14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f1c:	48 89 c6             	mov    %rax,%rsi
  803f1f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f24:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803f2b:	00 00 00 
  803f2e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803f30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f34:	48 89 c7             	mov    %rax,%rdi
  803f37:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  803f3e:	00 00 00 
  803f41:	ff d0                	callq  *%rax
  803f43:	48 89 c6             	mov    %rax,%rsi
  803f46:	bf 00 00 00 00       	mov    $0x0,%edi
  803f4b:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803f52:	00 00 00 
  803f55:	ff d0                	callq  *%rax
}
  803f57:	c9                   	leaveq 
  803f58:	c3                   	retq   

0000000000803f59 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803f59:	55                   	push   %rbp
  803f5a:	48 89 e5             	mov    %rsp,%rbp
  803f5d:	48 83 ec 20          	sub    $0x20,%rsp
  803f61:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803f64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f67:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803f6a:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803f6e:	be 01 00 00 00       	mov    $0x1,%esi
  803f73:	48 89 c7             	mov    %rax,%rdi
  803f76:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  803f7d:	00 00 00 
  803f80:	ff d0                	callq  *%rax
}
  803f82:	c9                   	leaveq 
  803f83:	c3                   	retq   

0000000000803f84 <getchar>:

int
getchar(void)
{
  803f84:	55                   	push   %rbp
  803f85:	48 89 e5             	mov    %rsp,%rbp
  803f88:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803f8c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803f90:	ba 01 00 00 00       	mov    $0x1,%edx
  803f95:	48 89 c6             	mov    %rax,%rsi
  803f98:	bf 00 00 00 00       	mov    $0x0,%edi
  803f9d:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  803fa4:	00 00 00 
  803fa7:	ff d0                	callq  *%rax
  803fa9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803fac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fb0:	79 05                	jns    803fb7 <getchar+0x33>
		return r;
  803fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb5:	eb 14                	jmp    803fcb <getchar+0x47>
	if (r < 1)
  803fb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fbb:	7f 07                	jg     803fc4 <getchar+0x40>
		return -E_EOF;
  803fbd:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803fc2:	eb 07                	jmp    803fcb <getchar+0x47>
	return c;
  803fc4:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803fc8:	0f b6 c0             	movzbl %al,%eax
}
  803fcb:	c9                   	leaveq 
  803fcc:	c3                   	retq   

0000000000803fcd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803fcd:	55                   	push   %rbp
  803fce:	48 89 e5             	mov    %rsp,%rbp
  803fd1:	48 83 ec 20          	sub    $0x20,%rsp
  803fd5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fd8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803fdc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fdf:	48 89 d6             	mov    %rdx,%rsi
  803fe2:	89 c7                	mov    %eax,%edi
  803fe4:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  803feb:	00 00 00 
  803fee:	ff d0                	callq  *%rax
  803ff0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ff3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ff7:	79 05                	jns    803ffe <iscons+0x31>
		return r;
  803ff9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ffc:	eb 1a                	jmp    804018 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803ffe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804002:	8b 10                	mov    (%rax),%edx
  804004:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80400b:	00 00 00 
  80400e:	8b 00                	mov    (%rax),%eax
  804010:	39 c2                	cmp    %eax,%edx
  804012:	0f 94 c0             	sete   %al
  804015:	0f b6 c0             	movzbl %al,%eax
}
  804018:	c9                   	leaveq 
  804019:	c3                   	retq   

000000000080401a <opencons>:

int
opencons(void)
{
  80401a:	55                   	push   %rbp
  80401b:	48 89 e5             	mov    %rsp,%rbp
  80401e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804022:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804026:	48 89 c7             	mov    %rax,%rdi
  804029:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  804030:	00 00 00 
  804033:	ff d0                	callq  *%rax
  804035:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804038:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80403c:	79 05                	jns    804043 <opencons+0x29>
		return r;
  80403e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804041:	eb 5b                	jmp    80409e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804043:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804047:	ba 07 04 00 00       	mov    $0x407,%edx
  80404c:	48 89 c6             	mov    %rax,%rsi
  80404f:	bf 00 00 00 00       	mov    $0x0,%edi
  804054:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  80405b:	00 00 00 
  80405e:	ff d0                	callq  *%rax
  804060:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804063:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804067:	79 05                	jns    80406e <opencons+0x54>
		return r;
  804069:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80406c:	eb 30                	jmp    80409e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80406e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804072:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804079:	00 00 00 
  80407c:	8b 12                	mov    (%rdx),%edx
  80407e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804080:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804084:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80408b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408f:	48 89 c7             	mov    %rax,%rdi
  804092:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  804099:	00 00 00 
  80409c:	ff d0                	callq  *%rax
}
  80409e:	c9                   	leaveq 
  80409f:	c3                   	retq   

00000000008040a0 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040a0:	55                   	push   %rbp
  8040a1:	48 89 e5             	mov    %rsp,%rbp
  8040a4:	48 83 ec 30          	sub    $0x30,%rsp
  8040a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8040b4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040b9:	75 07                	jne    8040c2 <devcons_read+0x22>
		return 0;
  8040bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c0:	eb 4b                	jmp    80410d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8040c2:	eb 0c                	jmp    8040d0 <devcons_read+0x30>
		sys_yield();
  8040c4:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  8040cb:	00 00 00 
  8040ce:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8040d0:	48 b8 27 19 80 00 00 	movabs $0x801927,%rax
  8040d7:	00 00 00 
  8040da:	ff d0                	callq  *%rax
  8040dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040e3:	74 df                	je     8040c4 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8040e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040e9:	79 05                	jns    8040f0 <devcons_read+0x50>
		return c;
  8040eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ee:	eb 1d                	jmp    80410d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8040f0:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8040f4:	75 07                	jne    8040fd <devcons_read+0x5d>
		return 0;
  8040f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8040fb:	eb 10                	jmp    80410d <devcons_read+0x6d>
	*(char*)vbuf = c;
  8040fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804100:	89 c2                	mov    %eax,%edx
  804102:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804106:	88 10                	mov    %dl,(%rax)
	return 1;
  804108:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80410d:	c9                   	leaveq 
  80410e:	c3                   	retq   

000000000080410f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80410f:	55                   	push   %rbp
  804110:	48 89 e5             	mov    %rsp,%rbp
  804113:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80411a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804121:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804128:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80412f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804136:	eb 76                	jmp    8041ae <devcons_write+0x9f>
		m = n - tot;
  804138:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80413f:	89 c2                	mov    %eax,%edx
  804141:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804144:	29 c2                	sub    %eax,%edx
  804146:	89 d0                	mov    %edx,%eax
  804148:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80414b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80414e:	83 f8 7f             	cmp    $0x7f,%eax
  804151:	76 07                	jbe    80415a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804153:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80415a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80415d:	48 63 d0             	movslq %eax,%rdx
  804160:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804163:	48 63 c8             	movslq %eax,%rcx
  804166:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80416d:	48 01 c1             	add    %rax,%rcx
  804170:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804177:	48 89 ce             	mov    %rcx,%rsi
  80417a:	48 89 c7             	mov    %rax,%rdi
  80417d:	48 b8 1a 14 80 00 00 	movabs $0x80141a,%rax
  804184:	00 00 00 
  804187:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804189:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80418c:	48 63 d0             	movslq %eax,%rdx
  80418f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804196:	48 89 d6             	mov    %rdx,%rsi
  804199:	48 89 c7             	mov    %rax,%rdi
  80419c:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  8041a3:	00 00 00 
  8041a6:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041ab:	01 45 fc             	add    %eax,-0x4(%rbp)
  8041ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b1:	48 98                	cltq   
  8041b3:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8041ba:	0f 82 78 ff ff ff    	jb     804138 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8041c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8041c3:	c9                   	leaveq 
  8041c4:	c3                   	retq   

00000000008041c5 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8041c5:	55                   	push   %rbp
  8041c6:	48 89 e5             	mov    %rsp,%rbp
  8041c9:	48 83 ec 08          	sub    $0x8,%rsp
  8041cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8041d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041d6:	c9                   	leaveq 
  8041d7:	c3                   	retq   

00000000008041d8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8041d8:	55                   	push   %rbp
  8041d9:	48 89 e5             	mov    %rsp,%rbp
  8041dc:	48 83 ec 10          	sub    $0x10,%rsp
  8041e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8041e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ec:	48 be 89 4c 80 00 00 	movabs $0x804c89,%rsi
  8041f3:	00 00 00 
  8041f6:	48 89 c7             	mov    %rax,%rdi
  8041f9:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  804200:	00 00 00 
  804203:	ff d0                	callq  *%rax
	return 0;
  804205:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80420a:	c9                   	leaveq 
  80420b:	c3                   	retq   

000000000080420c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80420c:	55                   	push   %rbp
  80420d:	48 89 e5             	mov    %rsp,%rbp
  804210:	48 83 ec 30          	sub    $0x30,%rsp
  804214:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804218:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80421c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804220:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804227:	00 00 00 
  80422a:	48 8b 00             	mov    (%rax),%rax
  80422d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804233:	85 c0                	test   %eax,%eax
  804235:	75 34                	jne    80426b <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  804237:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  80423e:	00 00 00 
  804241:	ff d0                	callq  *%rax
  804243:	25 ff 03 00 00       	and    $0x3ff,%eax
  804248:	48 98                	cltq   
  80424a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804251:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804258:	00 00 00 
  80425b:	48 01 c2             	add    %rax,%rdx
  80425e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804265:	00 00 00 
  804268:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80426b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804270:	75 0e                	jne    804280 <ipc_recv+0x74>
		pg = (void*) UTOP;
  804272:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804279:	00 00 00 
  80427c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804280:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804284:	48 89 c7             	mov    %rax,%rdi
  804287:	48 b8 4e 1c 80 00 00 	movabs $0x801c4e,%rax
  80428e:	00 00 00 
  804291:	ff d0                	callq  *%rax
  804293:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804296:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80429a:	79 19                	jns    8042b5 <ipc_recv+0xa9>
		*from_env_store = 0;
  80429c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042a0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8042a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042aa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8042b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b3:	eb 53                	jmp    804308 <ipc_recv+0xfc>
	}
	if(from_env_store)
  8042b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042ba:	74 19                	je     8042d5 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8042bc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8042c3:	00 00 00 
  8042c6:	48 8b 00             	mov    (%rax),%rax
  8042c9:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8042cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042d3:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8042d5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042da:	74 19                	je     8042f5 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8042dc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8042e3:	00 00 00 
  8042e6:	48 8b 00             	mov    (%rax),%rax
  8042e9:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8042ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042f3:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8042f5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8042fc:	00 00 00 
  8042ff:	48 8b 00             	mov    (%rax),%rax
  804302:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804308:	c9                   	leaveq 
  804309:	c3                   	retq   

000000000080430a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80430a:	55                   	push   %rbp
  80430b:	48 89 e5             	mov    %rsp,%rbp
  80430e:	48 83 ec 30          	sub    $0x30,%rsp
  804312:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804315:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804318:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80431c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80431f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804324:	75 0e                	jne    804334 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804326:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80432d:	00 00 00 
  804330:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804334:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804337:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80433a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80433e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804341:	89 c7                	mov    %eax,%edi
  804343:	48 b8 f9 1b 80 00 00 	movabs $0x801bf9,%rax
  80434a:	00 00 00 
  80434d:	ff d0                	callq  *%rax
  80434f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804352:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804356:	75 0c                	jne    804364 <ipc_send+0x5a>
			sys_yield();
  804358:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  80435f:	00 00 00 
  804362:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804364:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804368:	74 ca                	je     804334 <ipc_send+0x2a>
	if(result != 0)
  80436a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80436e:	74 20                	je     804390 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  804370:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804373:	89 c6                	mov    %eax,%esi
  804375:	48 bf 90 4c 80 00 00 	movabs $0x804c90,%rdi
  80437c:	00 00 00 
  80437f:	b8 00 00 00 00       	mov    $0x0,%eax
  804384:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  80438b:	00 00 00 
  80438e:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  804390:	c9                   	leaveq 
  804391:	c3                   	retq   

0000000000804392 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804392:	55                   	push   %rbp
  804393:	48 89 e5             	mov    %rsp,%rbp
  804396:	48 83 ec 14          	sub    $0x14,%rsp
  80439a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80439d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8043a4:	eb 4e                	jmp    8043f4 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8043a6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8043ad:	00 00 00 
  8043b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043b3:	48 98                	cltq   
  8043b5:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8043bc:	48 01 d0             	add    %rdx,%rax
  8043bf:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8043c5:	8b 00                	mov    (%rax),%eax
  8043c7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8043ca:	75 24                	jne    8043f0 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8043cc:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8043d3:	00 00 00 
  8043d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043d9:	48 98                	cltq   
  8043db:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8043e2:	48 01 d0             	add    %rdx,%rax
  8043e5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8043eb:	8b 40 08             	mov    0x8(%rax),%eax
  8043ee:	eb 12                	jmp    804402 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8043f0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8043f4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8043fb:	7e a9                	jle    8043a6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8043fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804402:	c9                   	leaveq 
  804403:	c3                   	retq   

0000000000804404 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804404:	55                   	push   %rbp
  804405:	48 89 e5             	mov    %rsp,%rbp
  804408:	48 83 ec 18          	sub    $0x18,%rsp
  80440c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804414:	48 c1 e8 15          	shr    $0x15,%rax
  804418:	48 89 c2             	mov    %rax,%rdx
  80441b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804422:	01 00 00 
  804425:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804429:	83 e0 01             	and    $0x1,%eax
  80442c:	48 85 c0             	test   %rax,%rax
  80442f:	75 07                	jne    804438 <pageref+0x34>
		return 0;
  804431:	b8 00 00 00 00       	mov    $0x0,%eax
  804436:	eb 53                	jmp    80448b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804438:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80443c:	48 c1 e8 0c          	shr    $0xc,%rax
  804440:	48 89 c2             	mov    %rax,%rdx
  804443:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80444a:	01 00 00 
  80444d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804451:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804459:	83 e0 01             	and    $0x1,%eax
  80445c:	48 85 c0             	test   %rax,%rax
  80445f:	75 07                	jne    804468 <pageref+0x64>
		return 0;
  804461:	b8 00 00 00 00       	mov    $0x0,%eax
  804466:	eb 23                	jmp    80448b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80446c:	48 c1 e8 0c          	shr    $0xc,%rax
  804470:	48 89 c2             	mov    %rax,%rdx
  804473:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80447a:	00 00 00 
  80447d:	48 c1 e2 04          	shl    $0x4,%rdx
  804481:	48 01 d0             	add    %rdx,%rax
  804484:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804488:	0f b7 c0             	movzwl %ax,%eax
}
  80448b:	c9                   	leaveq 
  80448c:	c3                   	retq   
