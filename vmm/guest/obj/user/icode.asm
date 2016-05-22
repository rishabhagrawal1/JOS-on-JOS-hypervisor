
vmm/guest/obj/user/icode:     file format elf64-x86-64


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
  800066:	48 bb e0 46 80 00 00 	movabs $0x8046e0,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	cprintf("icode startup\n");
  800073:	48 bf e6 46 80 00 00 	movabs $0x8046e6,%rdi
  80007a:	00 00 00 
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800089:	00 00 00 
  80008c:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008e:	48 bf f5 46 80 00 00 	movabs $0x8046f5,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  8000a4:	00 00 00 
  8000a7:	ff d2                	callq  *%rdx
	if ((fd = open(MOTD, O_RDONLY)) < 0)
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	48 bf 08 47 80 00 00 	movabs $0x804708,%rdi
  8000b5:	00 00 00 
  8000b8:	48 b8 30 27 80 00 00 	movabs $0x802730,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("icode: open /motd: %e", fd);
  8000cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 14 47 80 00 00 	movabs $0x804714,%rdx
  8000d9:	00 00 00 
  8000dc:	be 15 00 00 00       	mov    $0x15,%esi
  8000e1:	48 bf 2a 47 80 00 00 	movabs $0x80472a,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fd:	48 bf 37 47 80 00 00 	movabs $0x804737,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800113:	00 00 00 
  800116:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800118:	eb 3a                	jmp    800154 <umain+0x111>
		cprintf("Writing MOTD\n");
  80011a:	48 bf 4a 47 80 00 00 	movabs $0x80474a,%rdi
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
  800168:	48 b8 8d 22 80 00 00 	movabs $0x80228d,%rax
  80016f:	00 00 00 
  800172:	ff d0                	callq  *%rax
  800174:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800177:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80017b:	7f 9d                	jg     80011a <umain+0xd7>
		cprintf("Writing MOTD\n");
		sys_cputs(buf, n);
	}

	cprintf("icode: close /motd\n");
  80017d:	48 bf 58 47 80 00 00 	movabs $0x804758,%rdi
  800184:	00 00 00 
  800187:	b8 00 00 00 00       	mov    $0x0,%eax
  80018c:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800193:	00 00 00 
  800196:	ff d2                	callq  *%rdx
	close(fd);
  800198:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80019b:	89 c7                	mov    %eax,%edi
  80019d:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  8001a4:	00 00 00 
  8001a7:	ff d0                	callq  *%rax

	cprintf("icode: spawn /sbin/init\n");
  8001a9:	48 bf 6c 47 80 00 00 	movabs $0x80476c,%rdi
  8001b0:	00 00 00 
  8001b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b8:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  8001bf:	00 00 00 
  8001c2:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ca:	48 b9 85 47 80 00 00 	movabs $0x804785,%rcx
  8001d1:	00 00 00 
  8001d4:	48 ba 8e 47 80 00 00 	movabs $0x80478e,%rdx
  8001db:	00 00 00 
  8001de:	48 be 97 47 80 00 00 	movabs $0x804797,%rsi
  8001e5:	00 00 00 
  8001e8:	48 bf 9c 47 80 00 00 	movabs $0x80479c,%rdi
  8001ef:	00 00 00 
  8001f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f7:	49 b9 99 30 80 00 00 	movabs $0x803099,%r9
  8001fe:	00 00 00 
  800201:	41 ff d1             	callq  *%r9
  800204:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800207:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("icode: spawn /sbin/init: %e", r);
  80020d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba a7 47 80 00 00 	movabs $0x8047a7,%rdx
  800219:	00 00 00 
  80021c:	be 22 00 00 00       	mov    $0x22,%esi
  800221:	48 bf 2a 47 80 00 00 	movabs $0x80472a,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8
	cprintf("icode: exiting\n");
  80023d:	48 bf c3 47 80 00 00 	movabs $0x8047c3,%rdi
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
  8002e9:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
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
  8003c2:	48 bf e0 47 80 00 00 	movabs $0x8047e0,%rdi
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
  8003fe:	48 bf 03 48 80 00 00 	movabs $0x804803,%rdi
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
  8006ad:	48 ba 10 4a 80 00 00 	movabs $0x804a10,%rdx
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
  8009a5:	48 b8 38 4a 80 00 00 	movabs $0x804a38,%rax
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
  800af8:	48 b8 60 49 80 00 00 	movabs $0x804960,%rax
  800aff:	00 00 00 
  800b02:	48 63 d3             	movslq %ebx,%rdx
  800b05:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b09:	4d 85 e4             	test   %r12,%r12
  800b0c:	75 2e                	jne    800b3c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b0e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b16:	89 d9                	mov    %ebx,%ecx
  800b18:	48 ba 21 4a 80 00 00 	movabs $0x804a21,%rdx
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
  800b47:	48 ba 2a 4a 80 00 00 	movabs $0x804a2a,%rdx
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
  800ba1:	49 bc 2d 4a 80 00 00 	movabs $0x804a2d,%r12
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
  8018a7:	48 ba e8 4c 80 00 00 	movabs $0x804ce8,%rdx
  8018ae:	00 00 00 
  8018b1:	be 23 00 00 00       	mov    $0x23,%esi
  8018b6:	48 bf 05 4d 80 00 00 	movabs $0x804d05,%rdi
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

0000000000801d75 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d75:	55                   	push   %rbp
  801d76:	48 89 e5             	mov    %rsp,%rbp
  801d79:	48 83 ec 08          	sub    $0x8,%rsp
  801d7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d81:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d85:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d8c:	ff ff ff 
  801d8f:	48 01 d0             	add    %rdx,%rax
  801d92:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d96:	c9                   	leaveq 
  801d97:	c3                   	retq   

0000000000801d98 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d98:	55                   	push   %rbp
  801d99:	48 89 e5             	mov    %rsp,%rbp
  801d9c:	48 83 ec 08          	sub    $0x8,%rsp
  801da0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801da4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da8:	48 89 c7             	mov    %rax,%rdi
  801dab:	48 b8 75 1d 80 00 00 	movabs $0x801d75,%rax
  801db2:	00 00 00 
  801db5:	ff d0                	callq  *%rax
  801db7:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801dbd:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801dc1:	c9                   	leaveq 
  801dc2:	c3                   	retq   

0000000000801dc3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dc3:	55                   	push   %rbp
  801dc4:	48 89 e5             	mov    %rsp,%rbp
  801dc7:	48 83 ec 18          	sub    $0x18,%rsp
  801dcb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dd6:	eb 6b                	jmp    801e43 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ddb:	48 98                	cltq   
  801ddd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801de3:	48 c1 e0 0c          	shl    $0xc,%rax
  801de7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801deb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801def:	48 c1 e8 15          	shr    $0x15,%rax
  801df3:	48 89 c2             	mov    %rax,%rdx
  801df6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dfd:	01 00 00 
  801e00:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e04:	83 e0 01             	and    $0x1,%eax
  801e07:	48 85 c0             	test   %rax,%rax
  801e0a:	74 21                	je     801e2d <fd_alloc+0x6a>
  801e0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e10:	48 c1 e8 0c          	shr    $0xc,%rax
  801e14:	48 89 c2             	mov    %rax,%rdx
  801e17:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e1e:	01 00 00 
  801e21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e25:	83 e0 01             	and    $0x1,%eax
  801e28:	48 85 c0             	test   %rax,%rax
  801e2b:	75 12                	jne    801e3f <fd_alloc+0x7c>
			*fd_store = fd;
  801e2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e35:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e38:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3d:	eb 1a                	jmp    801e59 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e3f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e43:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e47:	7e 8f                	jle    801dd8 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e4d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e54:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e59:	c9                   	leaveq 
  801e5a:	c3                   	retq   

0000000000801e5b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e5b:	55                   	push   %rbp
  801e5c:	48 89 e5             	mov    %rsp,%rbp
  801e5f:	48 83 ec 20          	sub    $0x20,%rsp
  801e63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e6e:	78 06                	js     801e76 <fd_lookup+0x1b>
  801e70:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e74:	7e 07                	jle    801e7d <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e7b:	eb 6c                	jmp    801ee9 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e7d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e80:	48 98                	cltq   
  801e82:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e88:	48 c1 e0 0c          	shl    $0xc,%rax
  801e8c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e94:	48 c1 e8 15          	shr    $0x15,%rax
  801e98:	48 89 c2             	mov    %rax,%rdx
  801e9b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ea2:	01 00 00 
  801ea5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ea9:	83 e0 01             	and    $0x1,%eax
  801eac:	48 85 c0             	test   %rax,%rax
  801eaf:	74 21                	je     801ed2 <fd_lookup+0x77>
  801eb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb5:	48 c1 e8 0c          	shr    $0xc,%rax
  801eb9:	48 89 c2             	mov    %rax,%rdx
  801ebc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec3:	01 00 00 
  801ec6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eca:	83 e0 01             	and    $0x1,%eax
  801ecd:	48 85 c0             	test   %rax,%rax
  801ed0:	75 07                	jne    801ed9 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ed2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ed7:	eb 10                	jmp    801ee9 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ed9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801edd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ee1:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee9:	c9                   	leaveq 
  801eea:	c3                   	retq   

0000000000801eeb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801eeb:	55                   	push   %rbp
  801eec:	48 89 e5             	mov    %rsp,%rbp
  801eef:	48 83 ec 30          	sub    $0x30,%rsp
  801ef3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ef7:	89 f0                	mov    %esi,%eax
  801ef9:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801efc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f00:	48 89 c7             	mov    %rax,%rdi
  801f03:	48 b8 75 1d 80 00 00 	movabs $0x801d75,%rax
  801f0a:	00 00 00 
  801f0d:	ff d0                	callq  *%rax
  801f0f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f13:	48 89 d6             	mov    %rdx,%rsi
  801f16:	89 c7                	mov    %eax,%edi
  801f18:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  801f1f:	00 00 00 
  801f22:	ff d0                	callq  *%rax
  801f24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f2b:	78 0a                	js     801f37 <fd_close+0x4c>
	    || fd != fd2)
  801f2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f31:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f35:	74 12                	je     801f49 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f37:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f3b:	74 05                	je     801f42 <fd_close+0x57>
  801f3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f40:	eb 05                	jmp    801f47 <fd_close+0x5c>
  801f42:	b8 00 00 00 00       	mov    $0x0,%eax
  801f47:	eb 69                	jmp    801fb2 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f4d:	8b 00                	mov    (%rax),%eax
  801f4f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f53:	48 89 d6             	mov    %rdx,%rsi
  801f56:	89 c7                	mov    %eax,%edi
  801f58:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  801f5f:	00 00 00 
  801f62:	ff d0                	callq  *%rax
  801f64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f6b:	78 2a                	js     801f97 <fd_close+0xac>
		if (dev->dev_close)
  801f6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f71:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f75:	48 85 c0             	test   %rax,%rax
  801f78:	74 16                	je     801f90 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f7e:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f82:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f86:	48 89 d7             	mov    %rdx,%rdi
  801f89:	ff d0                	callq  *%rax
  801f8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f8e:	eb 07                	jmp    801f97 <fd_close+0xac>
		else
			r = 0;
  801f90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9b:	48 89 c6             	mov    %rax,%rsi
  801f9e:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa3:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  801faa:	00 00 00 
  801fad:	ff d0                	callq  *%rax
	return r;
  801faf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fb2:	c9                   	leaveq 
  801fb3:	c3                   	retq   

0000000000801fb4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fb4:	55                   	push   %rbp
  801fb5:	48 89 e5             	mov    %rsp,%rbp
  801fb8:	48 83 ec 20          	sub    $0x20,%rsp
  801fbc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fbf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fca:	eb 41                	jmp    80200d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fcc:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fd3:	00 00 00 
  801fd6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fd9:	48 63 d2             	movslq %edx,%rdx
  801fdc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe0:	8b 00                	mov    (%rax),%eax
  801fe2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fe5:	75 22                	jne    802009 <dev_lookup+0x55>
			*dev = devtab[i];
  801fe7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fee:	00 00 00 
  801ff1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff4:	48 63 d2             	movslq %edx,%rdx
  801ff7:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ffb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fff:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802002:	b8 00 00 00 00       	mov    $0x0,%eax
  802007:	eb 60                	jmp    802069 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802009:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80200d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802014:	00 00 00 
  802017:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80201a:	48 63 d2             	movslq %edx,%rdx
  80201d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802021:	48 85 c0             	test   %rax,%rax
  802024:	75 a6                	jne    801fcc <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802026:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80202d:	00 00 00 
  802030:	48 8b 00             	mov    (%rax),%rax
  802033:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802039:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80203c:	89 c6                	mov    %eax,%esi
  80203e:	48 bf 18 4d 80 00 00 	movabs $0x804d18,%rdi
  802045:	00 00 00 
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  802054:	00 00 00 
  802057:	ff d1                	callq  *%rcx
	*dev = 0;
  802059:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80205d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802064:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802069:	c9                   	leaveq 
  80206a:	c3                   	retq   

000000000080206b <close>:

int
close(int fdnum)
{
  80206b:	55                   	push   %rbp
  80206c:	48 89 e5             	mov    %rsp,%rbp
  80206f:	48 83 ec 20          	sub    $0x20,%rsp
  802073:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802076:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80207a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80207d:	48 89 d6             	mov    %rdx,%rsi
  802080:	89 c7                	mov    %eax,%edi
  802082:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  802089:	00 00 00 
  80208c:	ff d0                	callq  *%rax
  80208e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802091:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802095:	79 05                	jns    80209c <close+0x31>
		return r;
  802097:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209a:	eb 18                	jmp    8020b4 <close+0x49>
	else
		return fd_close(fd, 1);
  80209c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020a0:	be 01 00 00 00       	mov    $0x1,%esi
  8020a5:	48 89 c7             	mov    %rax,%rdi
  8020a8:	48 b8 eb 1e 80 00 00 	movabs $0x801eeb,%rax
  8020af:	00 00 00 
  8020b2:	ff d0                	callq  *%rax
}
  8020b4:	c9                   	leaveq 
  8020b5:	c3                   	retq   

00000000008020b6 <close_all>:

void
close_all(void)
{
  8020b6:	55                   	push   %rbp
  8020b7:	48 89 e5             	mov    %rsp,%rbp
  8020ba:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020c5:	eb 15                	jmp    8020dc <close_all+0x26>
		close(i);
  8020c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ca:	89 c7                	mov    %eax,%edi
  8020cc:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  8020d3:	00 00 00 
  8020d6:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020d8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020dc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020e0:	7e e5                	jle    8020c7 <close_all+0x11>
		close(i);
}
  8020e2:	c9                   	leaveq 
  8020e3:	c3                   	retq   

00000000008020e4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020e4:	55                   	push   %rbp
  8020e5:	48 89 e5             	mov    %rsp,%rbp
  8020e8:	48 83 ec 40          	sub    $0x40,%rsp
  8020ec:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020ef:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020f2:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020f6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020f9:	48 89 d6             	mov    %rdx,%rsi
  8020fc:	89 c7                	mov    %eax,%edi
  8020fe:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  802105:	00 00 00 
  802108:	ff d0                	callq  *%rax
  80210a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80210d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802111:	79 08                	jns    80211b <dup+0x37>
		return r;
  802113:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802116:	e9 70 01 00 00       	jmpq   80228b <dup+0x1a7>
	close(newfdnum);
  80211b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80211e:	89 c7                	mov    %eax,%edi
  802120:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802127:	00 00 00 
  80212a:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80212c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80212f:	48 98                	cltq   
  802131:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802137:	48 c1 e0 0c          	shl    $0xc,%rax
  80213b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80213f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802143:	48 89 c7             	mov    %rax,%rdi
  802146:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  80214d:	00 00 00 
  802150:	ff d0                	callq  *%rax
  802152:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802156:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80215a:	48 89 c7             	mov    %rax,%rdi
  80215d:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  802164:	00 00 00 
  802167:	ff d0                	callq  *%rax
  802169:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80216d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802171:	48 c1 e8 15          	shr    $0x15,%rax
  802175:	48 89 c2             	mov    %rax,%rdx
  802178:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80217f:	01 00 00 
  802182:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802186:	83 e0 01             	and    $0x1,%eax
  802189:	48 85 c0             	test   %rax,%rax
  80218c:	74 73                	je     802201 <dup+0x11d>
  80218e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802192:	48 c1 e8 0c          	shr    $0xc,%rax
  802196:	48 89 c2             	mov    %rax,%rdx
  802199:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021a0:	01 00 00 
  8021a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a7:	83 e0 01             	and    $0x1,%eax
  8021aa:	48 85 c0             	test   %rax,%rax
  8021ad:	74 52                	je     802201 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8021b7:	48 89 c2             	mov    %rax,%rdx
  8021ba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021c1:	01 00 00 
  8021c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c8:	25 07 0e 00 00       	and    $0xe07,%eax
  8021cd:	89 c1                	mov    %eax,%ecx
  8021cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d7:	41 89 c8             	mov    %ecx,%r8d
  8021da:	48 89 d1             	mov    %rdx,%rcx
  8021dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e2:	48 89 c6             	mov    %rax,%rsi
  8021e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ea:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  8021f1:	00 00 00 
  8021f4:	ff d0                	callq  *%rax
  8021f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021fd:	79 02                	jns    802201 <dup+0x11d>
			goto err;
  8021ff:	eb 57                	jmp    802258 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802201:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802205:	48 c1 e8 0c          	shr    $0xc,%rax
  802209:	48 89 c2             	mov    %rax,%rdx
  80220c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802213:	01 00 00 
  802216:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221a:	25 07 0e 00 00       	and    $0xe07,%eax
  80221f:	89 c1                	mov    %eax,%ecx
  802221:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802225:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802229:	41 89 c8             	mov    %ecx,%r8d
  80222c:	48 89 d1             	mov    %rdx,%rcx
  80222f:	ba 00 00 00 00       	mov    $0x0,%edx
  802234:	48 89 c6             	mov    %rax,%rsi
  802237:	bf 00 00 00 00       	mov    $0x0,%edi
  80223c:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  802243:	00 00 00 
  802246:	ff d0                	callq  *%rax
  802248:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80224f:	79 02                	jns    802253 <dup+0x16f>
		goto err;
  802251:	eb 05                	jmp    802258 <dup+0x174>

	return newfdnum;
  802253:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802256:	eb 33                	jmp    80228b <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225c:	48 89 c6             	mov    %rax,%rsi
  80225f:	bf 00 00 00 00       	mov    $0x0,%edi
  802264:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  80226b:	00 00 00 
  80226e:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802270:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802274:	48 89 c6             	mov    %rax,%rsi
  802277:	bf 00 00 00 00       	mov    $0x0,%edi
  80227c:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  802283:	00 00 00 
  802286:	ff d0                	callq  *%rax
	return r;
  802288:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80228b:	c9                   	leaveq 
  80228c:	c3                   	retq   

000000000080228d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80228d:	55                   	push   %rbp
  80228e:	48 89 e5             	mov    %rsp,%rbp
  802291:	48 83 ec 40          	sub    $0x40,%rsp
  802295:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802298:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80229c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022a0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022a7:	48 89 d6             	mov    %rdx,%rsi
  8022aa:	89 c7                	mov    %eax,%edi
  8022ac:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  8022b3:	00 00 00 
  8022b6:	ff d0                	callq  *%rax
  8022b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022bf:	78 24                	js     8022e5 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c5:	8b 00                	mov    (%rax),%eax
  8022c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022cb:	48 89 d6             	mov    %rdx,%rsi
  8022ce:	89 c7                	mov    %eax,%edi
  8022d0:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  8022d7:	00 00 00 
  8022da:	ff d0                	callq  *%rax
  8022dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e3:	79 05                	jns    8022ea <read+0x5d>
		return r;
  8022e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e8:	eb 76                	jmp    802360 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ee:	8b 40 08             	mov    0x8(%rax),%eax
  8022f1:	83 e0 03             	and    $0x3,%eax
  8022f4:	83 f8 01             	cmp    $0x1,%eax
  8022f7:	75 3a                	jne    802333 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022f9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802300:	00 00 00 
  802303:	48 8b 00             	mov    (%rax),%rax
  802306:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80230c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80230f:	89 c6                	mov    %eax,%esi
  802311:	48 bf 37 4d 80 00 00 	movabs $0x804d37,%rdi
  802318:	00 00 00 
  80231b:	b8 00 00 00 00       	mov    $0x0,%eax
  802320:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  802327:	00 00 00 
  80232a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80232c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802331:	eb 2d                	jmp    802360 <read+0xd3>
	}
	if (!dev->dev_read)
  802333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802337:	48 8b 40 10          	mov    0x10(%rax),%rax
  80233b:	48 85 c0             	test   %rax,%rax
  80233e:	75 07                	jne    802347 <read+0xba>
		return -E_NOT_SUPP;
  802340:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802345:	eb 19                	jmp    802360 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80234f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802353:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802357:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80235b:	48 89 cf             	mov    %rcx,%rdi
  80235e:	ff d0                	callq  *%rax
}
  802360:	c9                   	leaveq 
  802361:	c3                   	retq   

0000000000802362 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802362:	55                   	push   %rbp
  802363:	48 89 e5             	mov    %rsp,%rbp
  802366:	48 83 ec 30          	sub    $0x30,%rsp
  80236a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80236d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802371:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802375:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80237c:	eb 49                	jmp    8023c7 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80237e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802381:	48 98                	cltq   
  802383:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802387:	48 29 c2             	sub    %rax,%rdx
  80238a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80238d:	48 63 c8             	movslq %eax,%rcx
  802390:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802394:	48 01 c1             	add    %rax,%rcx
  802397:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80239a:	48 89 ce             	mov    %rcx,%rsi
  80239d:	89 c7                	mov    %eax,%edi
  80239f:	48 b8 8d 22 80 00 00 	movabs $0x80228d,%rax
  8023a6:	00 00 00 
  8023a9:	ff d0                	callq  *%rax
  8023ab:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023ae:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023b2:	79 05                	jns    8023b9 <readn+0x57>
			return m;
  8023b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023b7:	eb 1c                	jmp    8023d5 <readn+0x73>
		if (m == 0)
  8023b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023bd:	75 02                	jne    8023c1 <readn+0x5f>
			break;
  8023bf:	eb 11                	jmp    8023d2 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023c4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ca:	48 98                	cltq   
  8023cc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023d0:	72 ac                	jb     80237e <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8023d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023d5:	c9                   	leaveq 
  8023d6:	c3                   	retq   

00000000008023d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023d7:	55                   	push   %rbp
  8023d8:	48 89 e5             	mov    %rsp,%rbp
  8023db:	48 83 ec 40          	sub    $0x40,%rsp
  8023df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023e6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023ea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023f1:	48 89 d6             	mov    %rdx,%rsi
  8023f4:	89 c7                	mov    %eax,%edi
  8023f6:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  8023fd:	00 00 00 
  802400:	ff d0                	callq  *%rax
  802402:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802405:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802409:	78 24                	js     80242f <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80240b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240f:	8b 00                	mov    (%rax),%eax
  802411:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802415:	48 89 d6             	mov    %rdx,%rsi
  802418:	89 c7                	mov    %eax,%edi
  80241a:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  802421:	00 00 00 
  802424:	ff d0                	callq  *%rax
  802426:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802429:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242d:	79 05                	jns    802434 <write+0x5d>
		return r;
  80242f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802432:	eb 42                	jmp    802476 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802438:	8b 40 08             	mov    0x8(%rax),%eax
  80243b:	83 e0 03             	and    $0x3,%eax
  80243e:	85 c0                	test   %eax,%eax
  802440:	75 07                	jne    802449 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802442:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802447:	eb 2d                	jmp    802476 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802451:	48 85 c0             	test   %rax,%rax
  802454:	75 07                	jne    80245d <write+0x86>
		return -E_NOT_SUPP;
  802456:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80245b:	eb 19                	jmp    802476 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  80245d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802461:	48 8b 40 18          	mov    0x18(%rax),%rax
  802465:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802469:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80246d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802471:	48 89 cf             	mov    %rcx,%rdi
  802474:	ff d0                	callq  *%rax
}
  802476:	c9                   	leaveq 
  802477:	c3                   	retq   

0000000000802478 <seek>:

int
seek(int fdnum, off_t offset)
{
  802478:	55                   	push   %rbp
  802479:	48 89 e5             	mov    %rsp,%rbp
  80247c:	48 83 ec 18          	sub    $0x18,%rsp
  802480:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802483:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802486:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80248a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80248d:	48 89 d6             	mov    %rdx,%rsi
  802490:	89 c7                	mov    %eax,%edi
  802492:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  802499:	00 00 00 
  80249c:	ff d0                	callq  *%rax
  80249e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a5:	79 05                	jns    8024ac <seek+0x34>
		return r;
  8024a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024aa:	eb 0f                	jmp    8024bb <seek+0x43>
	fd->fd_offset = offset;
  8024ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024b3:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bb:	c9                   	leaveq 
  8024bc:	c3                   	retq   

00000000008024bd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024bd:	55                   	push   %rbp
  8024be:	48 89 e5             	mov    %rsp,%rbp
  8024c1:	48 83 ec 30          	sub    $0x30,%rsp
  8024c5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024c8:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024cb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024cf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024d2:	48 89 d6             	mov    %rdx,%rsi
  8024d5:	89 c7                	mov    %eax,%edi
  8024d7:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  8024de:	00 00 00 
  8024e1:	ff d0                	callq  *%rax
  8024e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ea:	78 24                	js     802510 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f0:	8b 00                	mov    (%rax),%eax
  8024f2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024f6:	48 89 d6             	mov    %rdx,%rsi
  8024f9:	89 c7                	mov    %eax,%edi
  8024fb:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  802502:	00 00 00 
  802505:	ff d0                	callq  *%rax
  802507:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250e:	79 05                	jns    802515 <ftruncate+0x58>
		return r;
  802510:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802513:	eb 72                	jmp    802587 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802515:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802519:	8b 40 08             	mov    0x8(%rax),%eax
  80251c:	83 e0 03             	and    $0x3,%eax
  80251f:	85 c0                	test   %eax,%eax
  802521:	75 3a                	jne    80255d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802523:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80252a:	00 00 00 
  80252d:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802530:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802536:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802539:	89 c6                	mov    %eax,%esi
  80253b:	48 bf 58 4d 80 00 00 	movabs $0x804d58,%rdi
  802542:	00 00 00 
  802545:	b8 00 00 00 00       	mov    $0x0,%eax
  80254a:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  802551:	00 00 00 
  802554:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802556:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80255b:	eb 2a                	jmp    802587 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80255d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802561:	48 8b 40 30          	mov    0x30(%rax),%rax
  802565:	48 85 c0             	test   %rax,%rax
  802568:	75 07                	jne    802571 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80256a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80256f:	eb 16                	jmp    802587 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802571:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802575:	48 8b 40 30          	mov    0x30(%rax),%rax
  802579:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80257d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802580:	89 ce                	mov    %ecx,%esi
  802582:	48 89 d7             	mov    %rdx,%rdi
  802585:	ff d0                	callq  *%rax
}
  802587:	c9                   	leaveq 
  802588:	c3                   	retq   

0000000000802589 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802589:	55                   	push   %rbp
  80258a:	48 89 e5             	mov    %rsp,%rbp
  80258d:	48 83 ec 30          	sub    $0x30,%rsp
  802591:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802594:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802598:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80259c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80259f:	48 89 d6             	mov    %rdx,%rsi
  8025a2:	89 c7                	mov    %eax,%edi
  8025a4:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  8025ab:	00 00 00 
  8025ae:	ff d0                	callq  *%rax
  8025b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b7:	78 24                	js     8025dd <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025bd:	8b 00                	mov    (%rax),%eax
  8025bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c3:	48 89 d6             	mov    %rdx,%rsi
  8025c6:	89 c7                	mov    %eax,%edi
  8025c8:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  8025cf:	00 00 00 
  8025d2:	ff d0                	callq  *%rax
  8025d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025db:	79 05                	jns    8025e2 <fstat+0x59>
		return r;
  8025dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e0:	eb 5e                	jmp    802640 <fstat+0xb7>
	if (!dev->dev_stat)
  8025e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025ea:	48 85 c0             	test   %rax,%rax
  8025ed:	75 07                	jne    8025f6 <fstat+0x6d>
		return -E_NOT_SUPP;
  8025ef:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025f4:	eb 4a                	jmp    802640 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025fa:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802601:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802608:	00 00 00 
	stat->st_isdir = 0;
  80260b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80260f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802616:	00 00 00 
	stat->st_dev = dev;
  802619:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80261d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802621:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802630:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802634:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802638:	48 89 ce             	mov    %rcx,%rsi
  80263b:	48 89 d7             	mov    %rdx,%rdi
  80263e:	ff d0                	callq  *%rax
}
  802640:	c9                   	leaveq 
  802641:	c3                   	retq   

0000000000802642 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802642:	55                   	push   %rbp
  802643:	48 89 e5             	mov    %rsp,%rbp
  802646:	48 83 ec 20          	sub    $0x20,%rsp
  80264a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80264e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802656:	be 00 00 00 00       	mov    $0x0,%esi
  80265b:	48 89 c7             	mov    %rax,%rdi
  80265e:	48 b8 30 27 80 00 00 	movabs $0x802730,%rax
  802665:	00 00 00 
  802668:	ff d0                	callq  *%rax
  80266a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80266d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802671:	79 05                	jns    802678 <stat+0x36>
		return fd;
  802673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802676:	eb 2f                	jmp    8026a7 <stat+0x65>
	r = fstat(fd, stat);
  802678:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80267c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267f:	48 89 d6             	mov    %rdx,%rsi
  802682:	89 c7                	mov    %eax,%edi
  802684:	48 b8 89 25 80 00 00 	movabs $0x802589,%rax
  80268b:	00 00 00 
  80268e:	ff d0                	callq  *%rax
  802690:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802696:	89 c7                	mov    %eax,%edi
  802698:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  80269f:	00 00 00 
  8026a2:	ff d0                	callq  *%rax
	return r;
  8026a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026a7:	c9                   	leaveq 
  8026a8:	c3                   	retq   

00000000008026a9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026a9:	55                   	push   %rbp
  8026aa:	48 89 e5             	mov    %rsp,%rbp
  8026ad:	48 83 ec 10          	sub    $0x10,%rsp
  8026b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026b8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026bf:	00 00 00 
  8026c2:	8b 00                	mov    (%rax),%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	75 1d                	jne    8026e5 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8026cd:	48 b8 d9 45 80 00 00 	movabs $0x8045d9,%rax
  8026d4:	00 00 00 
  8026d7:	ff d0                	callq  *%rax
  8026d9:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026e0:	00 00 00 
  8026e3:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026e5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026ec:	00 00 00 
  8026ef:	8b 00                	mov    (%rax),%eax
  8026f1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026f4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026f9:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802700:	00 00 00 
  802703:	89 c7                	mov    %eax,%edi
  802705:	48 b8 0c 42 80 00 00 	movabs $0x80420c,%rax
  80270c:	00 00 00 
  80270f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802711:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802715:	ba 00 00 00 00       	mov    $0x0,%edx
  80271a:	48 89 c6             	mov    %rax,%rsi
  80271d:	bf 00 00 00 00       	mov    $0x0,%edi
  802722:	48 b8 0e 41 80 00 00 	movabs $0x80410e,%rax
  802729:	00 00 00 
  80272c:	ff d0                	callq  *%rax
}
  80272e:	c9                   	leaveq 
  80272f:	c3                   	retq   

0000000000802730 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802730:	55                   	push   %rbp
  802731:	48 89 e5             	mov    %rsp,%rbp
  802734:	48 83 ec 30          	sub    $0x30,%rsp
  802738:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80273c:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80273f:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802746:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80274d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802754:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802759:	75 08                	jne    802763 <open+0x33>
	{
		return r;
  80275b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275e:	e9 f2 00 00 00       	jmpq   802855 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802763:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802767:	48 89 c7             	mov    %rax,%rdi
  80276a:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
  802776:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802779:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802780:	7e 0a                	jle    80278c <open+0x5c>
	{
		return -E_BAD_PATH;
  802782:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802787:	e9 c9 00 00 00       	jmpq   802855 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80278c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802793:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802794:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802798:	48 89 c7             	mov    %rax,%rdi
  80279b:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  8027a2:	00 00 00 
  8027a5:	ff d0                	callq  *%rax
  8027a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ae:	78 09                	js     8027b9 <open+0x89>
  8027b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b4:	48 85 c0             	test   %rax,%rax
  8027b7:	75 08                	jne    8027c1 <open+0x91>
		{
			return r;
  8027b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027bc:	e9 94 00 00 00       	jmpq   802855 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8027c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c5:	ba 00 04 00 00       	mov    $0x400,%edx
  8027ca:	48 89 c6             	mov    %rax,%rsi
  8027cd:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8027d4:	00 00 00 
  8027d7:	48 b8 88 11 80 00 00 	movabs $0x801188,%rax
  8027de:	00 00 00 
  8027e1:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8027e3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027ea:	00 00 00 
  8027ed:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027f0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8027f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027fa:	48 89 c6             	mov    %rax,%rsi
  8027fd:	bf 01 00 00 00       	mov    $0x1,%edi
  802802:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
  80280e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802811:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802815:	79 2b                	jns    802842 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281b:	be 00 00 00 00       	mov    $0x0,%esi
  802820:	48 89 c7             	mov    %rax,%rdi
  802823:	48 b8 eb 1e 80 00 00 	movabs $0x801eeb,%rax
  80282a:	00 00 00 
  80282d:	ff d0                	callq  *%rax
  80282f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802832:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802836:	79 05                	jns    80283d <open+0x10d>
			{
				return d;
  802838:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80283b:	eb 18                	jmp    802855 <open+0x125>
			}
			return r;
  80283d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802840:	eb 13                	jmp    802855 <open+0x125>
		}	
		return fd2num(fd_store);
  802842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802846:	48 89 c7             	mov    %rax,%rdi
  802849:	48 b8 75 1d 80 00 00 	movabs $0x801d75,%rax
  802850:	00 00 00 
  802853:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802855:	c9                   	leaveq 
  802856:	c3                   	retq   

0000000000802857 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802857:	55                   	push   %rbp
  802858:	48 89 e5             	mov    %rsp,%rbp
  80285b:	48 83 ec 10          	sub    $0x10,%rsp
  80285f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802863:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802867:	8b 50 0c             	mov    0xc(%rax),%edx
  80286a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802871:	00 00 00 
  802874:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802876:	be 00 00 00 00       	mov    $0x0,%esi
  80287b:	bf 06 00 00 00       	mov    $0x6,%edi
  802880:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802887:	00 00 00 
  80288a:	ff d0                	callq  *%rax
}
  80288c:	c9                   	leaveq 
  80288d:	c3                   	retq   

000000000080288e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80288e:	55                   	push   %rbp
  80288f:	48 89 e5             	mov    %rsp,%rbp
  802892:	48 83 ec 30          	sub    $0x30,%rsp
  802896:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80289a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80289e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8028a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8028a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028ae:	74 07                	je     8028b7 <devfile_read+0x29>
  8028b0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028b5:	75 07                	jne    8028be <devfile_read+0x30>
		return -E_INVAL;
  8028b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028bc:	eb 77                	jmp    802935 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c2:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028cc:	00 00 00 
  8028cf:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028d1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028d8:	00 00 00 
  8028db:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028df:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8028e3:	be 00 00 00 00       	mov    $0x0,%esi
  8028e8:	bf 03 00 00 00       	mov    $0x3,%edi
  8028ed:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  8028f4:	00 00 00 
  8028f7:	ff d0                	callq  *%rax
  8028f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802900:	7f 05                	jg     802907 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802902:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802905:	eb 2e                	jmp    802935 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802907:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290a:	48 63 d0             	movslq %eax,%rdx
  80290d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802911:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802918:	00 00 00 
  80291b:	48 89 c7             	mov    %rax,%rdi
  80291e:	48 b8 1a 14 80 00 00 	movabs $0x80141a,%rax
  802925:	00 00 00 
  802928:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80292a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80292e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802932:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802935:	c9                   	leaveq 
  802936:	c3                   	retq   

0000000000802937 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802937:	55                   	push   %rbp
  802938:	48 89 e5             	mov    %rsp,%rbp
  80293b:	48 83 ec 30          	sub    $0x30,%rsp
  80293f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802943:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802947:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80294b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802952:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802957:	74 07                	je     802960 <devfile_write+0x29>
  802959:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80295e:	75 08                	jne    802968 <devfile_write+0x31>
		return r;
  802960:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802963:	e9 9a 00 00 00       	jmpq   802a02 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296c:	8b 50 0c             	mov    0xc(%rax),%edx
  80296f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802976:	00 00 00 
  802979:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80297b:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802982:	00 
  802983:	76 08                	jbe    80298d <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802985:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80298c:	00 
	}
	fsipcbuf.write.req_n = n;
  80298d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802994:	00 00 00 
  802997:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80299b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80299f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a7:	48 89 c6             	mov    %rax,%rsi
  8029aa:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8029b1:	00 00 00 
  8029b4:	48 b8 1a 14 80 00 00 	movabs $0x80141a,%rax
  8029bb:	00 00 00 
  8029be:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8029c0:	be 00 00 00 00       	mov    $0x0,%esi
  8029c5:	bf 04 00 00 00       	mov    $0x4,%edi
  8029ca:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  8029d1:	00 00 00 
  8029d4:	ff d0                	callq  *%rax
  8029d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029dd:	7f 20                	jg     8029ff <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8029df:	48 bf 7e 4d 80 00 00 	movabs $0x804d7e,%rdi
  8029e6:	00 00 00 
  8029e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ee:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  8029f5:	00 00 00 
  8029f8:	ff d2                	callq  *%rdx
		return r;
  8029fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fd:	eb 03                	jmp    802a02 <devfile_write+0xcb>
	}
	return r;
  8029ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a02:	c9                   	leaveq 
  802a03:	c3                   	retq   

0000000000802a04 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a04:	55                   	push   %rbp
  802a05:	48 89 e5             	mov    %rsp,%rbp
  802a08:	48 83 ec 20          	sub    $0x20,%rsp
  802a0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a18:	8b 50 0c             	mov    0xc(%rax),%edx
  802a1b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a22:	00 00 00 
  802a25:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a27:	be 00 00 00 00       	mov    $0x0,%esi
  802a2c:	bf 05 00 00 00       	mov    $0x5,%edi
  802a31:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802a38:	00 00 00 
  802a3b:	ff d0                	callq  *%rax
  802a3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a44:	79 05                	jns    802a4b <devfile_stat+0x47>
		return r;
  802a46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a49:	eb 56                	jmp    802aa1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a56:	00 00 00 
  802a59:	48 89 c7             	mov    %rax,%rdi
  802a5c:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a68:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a6f:	00 00 00 
  802a72:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a82:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a89:	00 00 00 
  802a8c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a96:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aa1:	c9                   	leaveq 
  802aa2:	c3                   	retq   

0000000000802aa3 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802aa3:	55                   	push   %rbp
  802aa4:	48 89 e5             	mov    %rsp,%rbp
  802aa7:	48 83 ec 10          	sub    $0x10,%rsp
  802aab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802aaf:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ab2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ab6:	8b 50 0c             	mov    0xc(%rax),%edx
  802ab9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ac0:	00 00 00 
  802ac3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ac5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802acc:	00 00 00 
  802acf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ad2:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ad5:	be 00 00 00 00       	mov    $0x0,%esi
  802ada:	bf 02 00 00 00       	mov    $0x2,%edi
  802adf:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802ae6:	00 00 00 
  802ae9:	ff d0                	callq  *%rax
}
  802aeb:	c9                   	leaveq 
  802aec:	c3                   	retq   

0000000000802aed <remove>:

// Delete a file
int
remove(const char *path)
{
  802aed:	55                   	push   %rbp
  802aee:	48 89 e5             	mov    %rsp,%rbp
  802af1:	48 83 ec 10          	sub    $0x10,%rsp
  802af5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802af9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802afd:	48 89 c7             	mov    %rax,%rdi
  802b00:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  802b07:	00 00 00 
  802b0a:	ff d0                	callq  *%rax
  802b0c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b11:	7e 07                	jle    802b1a <remove+0x2d>
		return -E_BAD_PATH;
  802b13:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b18:	eb 33                	jmp    802b4d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b1e:	48 89 c6             	mov    %rax,%rsi
  802b21:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b28:	00 00 00 
  802b2b:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  802b32:	00 00 00 
  802b35:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b37:	be 00 00 00 00       	mov    $0x0,%esi
  802b3c:	bf 07 00 00 00       	mov    $0x7,%edi
  802b41:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802b48:	00 00 00 
  802b4b:	ff d0                	callq  *%rax
}
  802b4d:	c9                   	leaveq 
  802b4e:	c3                   	retq   

0000000000802b4f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b4f:	55                   	push   %rbp
  802b50:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b53:	be 00 00 00 00       	mov    $0x0,%esi
  802b58:	bf 08 00 00 00       	mov    $0x8,%edi
  802b5d:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802b64:	00 00 00 
  802b67:	ff d0                	callq  *%rax
}
  802b69:	5d                   	pop    %rbp
  802b6a:	c3                   	retq   

0000000000802b6b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b6b:	55                   	push   %rbp
  802b6c:	48 89 e5             	mov    %rsp,%rbp
  802b6f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b76:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b7d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b84:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b8b:	be 00 00 00 00       	mov    $0x0,%esi
  802b90:	48 89 c7             	mov    %rax,%rdi
  802b93:	48 b8 30 27 80 00 00 	movabs $0x802730,%rax
  802b9a:	00 00 00 
  802b9d:	ff d0                	callq  *%rax
  802b9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ba2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba6:	79 28                	jns    802bd0 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ba8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bab:	89 c6                	mov    %eax,%esi
  802bad:	48 bf 9a 4d 80 00 00 	movabs $0x804d9a,%rdi
  802bb4:	00 00 00 
  802bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbc:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802bc3:	00 00 00 
  802bc6:	ff d2                	callq  *%rdx
		return fd_src;
  802bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcb:	e9 74 01 00 00       	jmpq   802d44 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bd0:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802bd7:	be 01 01 00 00       	mov    $0x101,%esi
  802bdc:	48 89 c7             	mov    %rax,%rdi
  802bdf:	48 b8 30 27 80 00 00 	movabs $0x802730,%rax
  802be6:	00 00 00 
  802be9:	ff d0                	callq  *%rax
  802beb:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bee:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bf2:	79 39                	jns    802c2d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bf4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf7:	89 c6                	mov    %eax,%esi
  802bf9:	48 bf b0 4d 80 00 00 	movabs $0x804db0,%rdi
  802c00:	00 00 00 
  802c03:	b8 00 00 00 00       	mov    $0x0,%eax
  802c08:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802c0f:	00 00 00 
  802c12:	ff d2                	callq  *%rdx
		close(fd_src);
  802c14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c17:	89 c7                	mov    %eax,%edi
  802c19:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802c20:	00 00 00 
  802c23:	ff d0                	callq  *%rax
		return fd_dest;
  802c25:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c28:	e9 17 01 00 00       	jmpq   802d44 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c2d:	eb 74                	jmp    802ca3 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c2f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c32:	48 63 d0             	movslq %eax,%rdx
  802c35:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c3c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c3f:	48 89 ce             	mov    %rcx,%rsi
  802c42:	89 c7                	mov    %eax,%edi
  802c44:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  802c4b:	00 00 00 
  802c4e:	ff d0                	callq  *%rax
  802c50:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c53:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c57:	79 4a                	jns    802ca3 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c59:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c5c:	89 c6                	mov    %eax,%esi
  802c5e:	48 bf ca 4d 80 00 00 	movabs $0x804dca,%rdi
  802c65:	00 00 00 
  802c68:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6d:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802c74:	00 00 00 
  802c77:	ff d2                	callq  *%rdx
			close(fd_src);
  802c79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7c:	89 c7                	mov    %eax,%edi
  802c7e:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802c85:	00 00 00 
  802c88:	ff d0                	callq  *%rax
			close(fd_dest);
  802c8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c8d:	89 c7                	mov    %eax,%edi
  802c8f:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802c96:	00 00 00 
  802c99:	ff d0                	callq  *%rax
			return write_size;
  802c9b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c9e:	e9 a1 00 00 00       	jmpq   802d44 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ca3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cad:	ba 00 02 00 00       	mov    $0x200,%edx
  802cb2:	48 89 ce             	mov    %rcx,%rsi
  802cb5:	89 c7                	mov    %eax,%edi
  802cb7:	48 b8 8d 22 80 00 00 	movabs $0x80228d,%rax
  802cbe:	00 00 00 
  802cc1:	ff d0                	callq  *%rax
  802cc3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cca:	0f 8f 5f ff ff ff    	jg     802c2f <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cd4:	79 47                	jns    802d1d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802cd6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cd9:	89 c6                	mov    %eax,%esi
  802cdb:	48 bf dd 4d 80 00 00 	movabs $0x804ddd,%rdi
  802ce2:	00 00 00 
  802ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cea:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802cf1:	00 00 00 
  802cf4:	ff d2                	callq  *%rdx
		close(fd_src);
  802cf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf9:	89 c7                	mov    %eax,%edi
  802cfb:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
		close(fd_dest);
  802d07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d0a:	89 c7                	mov    %eax,%edi
  802d0c:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802d13:	00 00 00 
  802d16:	ff d0                	callq  *%rax
		return read_size;
  802d18:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d1b:	eb 27                	jmp    802d44 <copy+0x1d9>
	}
	close(fd_src);
  802d1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d20:	89 c7                	mov    %eax,%edi
  802d22:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802d29:	00 00 00 
  802d2c:	ff d0                	callq  *%rax
	close(fd_dest);
  802d2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d31:	89 c7                	mov    %eax,%edi
  802d33:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802d3a:	00 00 00 
  802d3d:	ff d0                	callq  *%rax
	return 0;
  802d3f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d44:	c9                   	leaveq 
  802d45:	c3                   	retq   

0000000000802d46 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802d46:	55                   	push   %rbp
  802d47:	48 89 e5             	mov    %rsp,%rbp
  802d4a:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802d51:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802d58:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802d5f:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802d66:	be 00 00 00 00       	mov    $0x0,%esi
  802d6b:	48 89 c7             	mov    %rax,%rdi
  802d6e:	48 b8 30 27 80 00 00 	movabs $0x802730,%rax
  802d75:	00 00 00 
  802d78:	ff d0                	callq  *%rax
  802d7a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d7d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d81:	79 08                	jns    802d8b <spawn+0x45>
		return r;
  802d83:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d86:	e9 0c 03 00 00       	jmpq   803097 <spawn+0x351>
	fd = r;
  802d8b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d8e:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802d91:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802d98:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802d9c:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802da3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802da6:	ba 00 02 00 00       	mov    $0x200,%edx
  802dab:	48 89 ce             	mov    %rcx,%rsi
  802dae:	89 c7                	mov    %eax,%edi
  802db0:	48 b8 62 23 80 00 00 	movabs $0x802362,%rax
  802db7:	00 00 00 
  802dba:	ff d0                	callq  *%rax
  802dbc:	3d 00 02 00 00       	cmp    $0x200,%eax
  802dc1:	75 0d                	jne    802dd0 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802dc3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dc7:	8b 00                	mov    (%rax),%eax
  802dc9:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802dce:	74 43                	je     802e13 <spawn+0xcd>
		close(fd);
  802dd0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802dd3:	89 c7                	mov    %eax,%edi
  802dd5:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802ddc:	00 00 00 
  802ddf:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802de1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802de5:	8b 00                	mov    (%rax),%eax
  802de7:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802dec:	89 c6                	mov    %eax,%esi
  802dee:	48 bf f8 4d 80 00 00 	movabs $0x804df8,%rdi
  802df5:	00 00 00 
  802df8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfd:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  802e04:	00 00 00 
  802e07:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802e09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e0e:	e9 84 02 00 00       	jmpq   803097 <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802e13:	b8 07 00 00 00       	mov    $0x7,%eax
  802e18:	cd 30                	int    $0x30
  802e1a:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802e1d:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802e20:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e23:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e27:	79 08                	jns    802e31 <spawn+0xeb>
		return r;
  802e29:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e2c:	e9 66 02 00 00       	jmpq   803097 <spawn+0x351>
	child = r;
  802e31:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e34:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802e37:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e3a:	25 ff 03 00 00       	and    $0x3ff,%eax
  802e3f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802e46:	00 00 00 
  802e49:	48 98                	cltq   
  802e4b:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802e52:	48 01 d0             	add    %rdx,%rax
  802e55:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802e5c:	48 89 c6             	mov    %rax,%rsi
  802e5f:	b8 18 00 00 00       	mov    $0x18,%eax
  802e64:	48 89 d7             	mov    %rdx,%rdi
  802e67:	48 89 c1             	mov    %rax,%rcx
  802e6a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802e6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e71:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e75:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802e7c:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802e83:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802e8a:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802e91:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e94:	48 89 ce             	mov    %rcx,%rsi
  802e97:	89 c7                	mov    %eax,%edi
  802e99:	48 b8 01 33 80 00 00 	movabs $0x803301,%rax
  802ea0:	00 00 00 
  802ea3:	ff d0                	callq  *%rax
  802ea5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ea8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802eac:	79 08                	jns    802eb6 <spawn+0x170>
		return r;
  802eae:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802eb1:	e9 e1 01 00 00       	jmpq   803097 <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802eb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eba:	48 8b 40 20          	mov    0x20(%rax),%rax
  802ebe:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802ec5:	48 01 d0             	add    %rdx,%rax
  802ec8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ecc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ed3:	e9 a3 00 00 00       	jmpq   802f7b <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  802ed8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802edc:	8b 00                	mov    (%rax),%eax
  802ede:	83 f8 01             	cmp    $0x1,%eax
  802ee1:	74 05                	je     802ee8 <spawn+0x1a2>
			continue;
  802ee3:	e9 8a 00 00 00       	jmpq   802f72 <spawn+0x22c>
		perm = PTE_P | PTE_U;
  802ee8:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef3:	8b 40 04             	mov    0x4(%rax),%eax
  802ef6:	83 e0 02             	and    $0x2,%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	74 04                	je     802f01 <spawn+0x1bb>
			perm |= PTE_W;
  802efd:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802f01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f05:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802f09:	41 89 c1             	mov    %eax,%r9d
  802f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f10:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802f14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f18:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f20:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802f24:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802f27:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f2a:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802f2d:	89 3c 24             	mov    %edi,(%rsp)
  802f30:	89 c7                	mov    %eax,%edi
  802f32:	48 b8 aa 35 80 00 00 	movabs $0x8035aa,%rax
  802f39:	00 00 00 
  802f3c:	ff d0                	callq  *%rax
  802f3e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f41:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f45:	79 2b                	jns    802f72 <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802f47:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802f48:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f4b:	89 c7                	mov    %eax,%edi
  802f4d:	48 b8 65 19 80 00 00 	movabs $0x801965,%rax
  802f54:	00 00 00 
  802f57:	ff d0                	callq  *%rax
	close(fd);
  802f59:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f5c:	89 c7                	mov    %eax,%edi
  802f5e:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802f65:	00 00 00 
  802f68:	ff d0                	callq  *%rax
	return r;
  802f6a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f6d:	e9 25 01 00 00       	jmpq   803097 <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802f72:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802f76:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802f7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f7f:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802f83:	0f b7 c0             	movzwl %ax,%eax
  802f86:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802f89:	0f 8f 49 ff ff ff    	jg     802ed8 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802f8f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f92:	89 c7                	mov    %eax,%edi
  802f94:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802f9b:	00 00 00 
  802f9e:	ff d0                	callq  *%rax
	fd = -1;
  802fa0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802fa7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802faa:	89 c7                	mov    %eax,%edi
  802fac:	48 b8 96 37 80 00 00 	movabs $0x803796,%rax
  802fb3:	00 00 00 
  802fb6:	ff d0                	callq  *%rax
  802fb8:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802fbb:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802fbf:	79 30                	jns    802ff1 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  802fc1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802fc4:	89 c1                	mov    %eax,%ecx
  802fc6:	48 ba 12 4e 80 00 00 	movabs $0x804e12,%rdx
  802fcd:	00 00 00 
  802fd0:	be 82 00 00 00       	mov    $0x82,%esi
  802fd5:	48 bf 28 4e 80 00 00 	movabs $0x804e28,%rdi
  802fdc:	00 00 00 
  802fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe4:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  802feb:	00 00 00 
  802fee:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802ff1:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802ff8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ffb:	48 89 d6             	mov    %rdx,%rsi
  802ffe:	89 c7                	mov    %eax,%edi
  803000:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  803007:	00 00 00 
  80300a:	ff d0                	callq  *%rax
  80300c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80300f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803013:	79 30                	jns    803045 <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  803015:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803018:	89 c1                	mov    %eax,%ecx
  80301a:	48 ba 34 4e 80 00 00 	movabs $0x804e34,%rdx
  803021:	00 00 00 
  803024:	be 85 00 00 00       	mov    $0x85,%esi
  803029:	48 bf 28 4e 80 00 00 	movabs $0x804e28,%rdi
  803030:	00 00 00 
  803033:	b8 00 00 00 00       	mov    $0x0,%eax
  803038:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  80303f:	00 00 00 
  803042:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803045:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803048:	be 02 00 00 00       	mov    $0x2,%esi
  80304d:	89 c7                	mov    %eax,%edi
  80304f:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  803056:	00 00 00 
  803059:	ff d0                	callq  *%rax
  80305b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80305e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803062:	79 30                	jns    803094 <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  803064:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803067:	89 c1                	mov    %eax,%ecx
  803069:	48 ba 4e 4e 80 00 00 	movabs $0x804e4e,%rdx
  803070:	00 00 00 
  803073:	be 88 00 00 00       	mov    $0x88,%esi
  803078:	48 bf 28 4e 80 00 00 	movabs $0x804e28,%rdi
  80307f:	00 00 00 
  803082:	b8 00 00 00 00       	mov    $0x0,%eax
  803087:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  80308e:	00 00 00 
  803091:	41 ff d0             	callq  *%r8

	return child;
  803094:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803097:	c9                   	leaveq 
  803098:	c3                   	retq   

0000000000803099 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803099:	55                   	push   %rbp
  80309a:	48 89 e5             	mov    %rsp,%rbp
  80309d:	41 55                	push   %r13
  80309f:	41 54                	push   %r12
  8030a1:	53                   	push   %rbx
  8030a2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8030a9:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8030b0:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8030b7:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8030be:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8030c5:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8030cc:	84 c0                	test   %al,%al
  8030ce:	74 26                	je     8030f6 <spawnl+0x5d>
  8030d0:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8030d7:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8030de:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8030e2:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8030e6:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8030ea:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8030ee:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8030f2:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  8030f6:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8030fd:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803104:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803107:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80310e:	00 00 00 
  803111:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803118:	00 00 00 
  80311b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80311f:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803126:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80312d:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803134:	eb 07                	jmp    80313d <spawnl+0xa4>
		argc++;
  803136:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80313d:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803143:	83 f8 30             	cmp    $0x30,%eax
  803146:	73 23                	jae    80316b <spawnl+0xd2>
  803148:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80314f:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803155:	89 c0                	mov    %eax,%eax
  803157:	48 01 d0             	add    %rdx,%rax
  80315a:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803160:	83 c2 08             	add    $0x8,%edx
  803163:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803169:	eb 15                	jmp    803180 <spawnl+0xe7>
  80316b:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803172:	48 89 d0             	mov    %rdx,%rax
  803175:	48 83 c2 08          	add    $0x8,%rdx
  803179:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803180:	48 8b 00             	mov    (%rax),%rax
  803183:	48 85 c0             	test   %rax,%rax
  803186:	75 ae                	jne    803136 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803188:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80318e:	83 c0 02             	add    $0x2,%eax
  803191:	48 89 e2             	mov    %rsp,%rdx
  803194:	48 89 d3             	mov    %rdx,%rbx
  803197:	48 63 d0             	movslq %eax,%rdx
  80319a:	48 83 ea 01          	sub    $0x1,%rdx
  80319e:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8031a5:	48 63 d0             	movslq %eax,%rdx
  8031a8:	49 89 d4             	mov    %rdx,%r12
  8031ab:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8031b1:	48 63 d0             	movslq %eax,%rdx
  8031b4:	49 89 d2             	mov    %rdx,%r10
  8031b7:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8031bd:	48 98                	cltq   
  8031bf:	48 c1 e0 03          	shl    $0x3,%rax
  8031c3:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8031c7:	b8 10 00 00 00       	mov    $0x10,%eax
  8031cc:	48 83 e8 01          	sub    $0x1,%rax
  8031d0:	48 01 d0             	add    %rdx,%rax
  8031d3:	bf 10 00 00 00       	mov    $0x10,%edi
  8031d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8031dd:	48 f7 f7             	div    %rdi
  8031e0:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8031e4:	48 29 c4             	sub    %rax,%rsp
  8031e7:	48 89 e0             	mov    %rsp,%rax
  8031ea:	48 83 c0 07          	add    $0x7,%rax
  8031ee:	48 c1 e8 03          	shr    $0x3,%rax
  8031f2:	48 c1 e0 03          	shl    $0x3,%rax
  8031f6:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8031fd:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803204:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  80320b:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80320e:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803214:	8d 50 01             	lea    0x1(%rax),%edx
  803217:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80321e:	48 63 d2             	movslq %edx,%rdx
  803221:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803228:	00 

	va_start(vl, arg0);
  803229:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803230:	00 00 00 
  803233:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80323a:	00 00 00 
  80323d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803241:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803248:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80324f:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803256:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80325d:	00 00 00 
  803260:	eb 63                	jmp    8032c5 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803262:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803268:	8d 70 01             	lea    0x1(%rax),%esi
  80326b:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803271:	83 f8 30             	cmp    $0x30,%eax
  803274:	73 23                	jae    803299 <spawnl+0x200>
  803276:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80327d:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803283:	89 c0                	mov    %eax,%eax
  803285:	48 01 d0             	add    %rdx,%rax
  803288:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80328e:	83 c2 08             	add    $0x8,%edx
  803291:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803297:	eb 15                	jmp    8032ae <spawnl+0x215>
  803299:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8032a0:	48 89 d0             	mov    %rdx,%rax
  8032a3:	48 83 c2 08          	add    $0x8,%rdx
  8032a7:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8032ae:	48 8b 08             	mov    (%rax),%rcx
  8032b1:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8032b8:	89 f2                	mov    %esi,%edx
  8032ba:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8032be:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8032c5:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8032cb:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8032d1:	77 8f                	ja     803262 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8032d3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8032da:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8032e1:	48 89 d6             	mov    %rdx,%rsi
  8032e4:	48 89 c7             	mov    %rax,%rdi
  8032e7:	48 b8 46 2d 80 00 00 	movabs $0x802d46,%rax
  8032ee:	00 00 00 
  8032f1:	ff d0                	callq  *%rax
  8032f3:	48 89 dc             	mov    %rbx,%rsp
}
  8032f6:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8032fa:	5b                   	pop    %rbx
  8032fb:	41 5c                	pop    %r12
  8032fd:	41 5d                	pop    %r13
  8032ff:	5d                   	pop    %rbp
  803300:	c3                   	retq   

0000000000803301 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803301:	55                   	push   %rbp
  803302:	48 89 e5             	mov    %rsp,%rbp
  803305:	48 83 ec 50          	sub    $0x50,%rsp
  803309:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80330c:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803310:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803314:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80331b:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  80331c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803323:	eb 33                	jmp    803358 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803328:	48 98                	cltq   
  80332a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803331:	00 
  803332:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803336:	48 01 d0             	add    %rdx,%rax
  803339:	48 8b 00             	mov    (%rax),%rax
  80333c:	48 89 c7             	mov    %rax,%rdi
  80333f:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  803346:	00 00 00 
  803349:	ff d0                	callq  *%rax
  80334b:	83 c0 01             	add    $0x1,%eax
  80334e:	48 98                	cltq   
  803350:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803354:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803358:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80335b:	48 98                	cltq   
  80335d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803364:	00 
  803365:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803369:	48 01 d0             	add    %rdx,%rax
  80336c:	48 8b 00             	mov    (%rax),%rax
  80336f:	48 85 c0             	test   %rax,%rax
  803372:	75 b1                	jne    803325 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803374:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803378:	48 f7 d8             	neg    %rax
  80337b:	48 05 00 10 40 00    	add    $0x401000,%rax
  803381:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803385:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803389:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80338d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803391:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803395:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803398:	83 c2 01             	add    $0x1,%edx
  80339b:	c1 e2 03             	shl    $0x3,%edx
  80339e:	48 63 d2             	movslq %edx,%rdx
  8033a1:	48 f7 da             	neg    %rdx
  8033a4:	48 01 d0             	add    %rdx,%rax
  8033a7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8033ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033af:	48 83 e8 10          	sub    $0x10,%rax
  8033b3:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8033b9:	77 0a                	ja     8033c5 <init_stack+0xc4>
		return -E_NO_MEM;
  8033bb:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8033c0:	e9 e3 01 00 00       	jmpq   8035a8 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8033c5:	ba 07 00 00 00       	mov    $0x7,%edx
  8033ca:	be 00 00 40 00       	mov    $0x400000,%esi
  8033cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d4:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  8033db:	00 00 00 
  8033de:	ff d0                	callq  *%rax
  8033e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033e7:	79 08                	jns    8033f1 <init_stack+0xf0>
		return r;
  8033e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033ec:	e9 b7 01 00 00       	jmpq   8035a8 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8033f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8033f8:	e9 8a 00 00 00       	jmpq   803487 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8033fd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803400:	48 98                	cltq   
  803402:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803409:	00 
  80340a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80340e:	48 01 c2             	add    %rax,%rdx
  803411:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803416:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80341a:	48 01 c8             	add    %rcx,%rax
  80341d:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803423:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803426:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803429:	48 98                	cltq   
  80342b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803432:	00 
  803433:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803437:	48 01 d0             	add    %rdx,%rax
  80343a:	48 8b 10             	mov    (%rax),%rdx
  80343d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803441:	48 89 d6             	mov    %rdx,%rsi
  803444:	48 89 c7             	mov    %rax,%rdi
  803447:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  80344e:	00 00 00 
  803451:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803453:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803456:	48 98                	cltq   
  803458:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80345f:	00 
  803460:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803464:	48 01 d0             	add    %rdx,%rax
  803467:	48 8b 00             	mov    (%rax),%rax
  80346a:	48 89 c7             	mov    %rax,%rdi
  80346d:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  803474:	00 00 00 
  803477:	ff d0                	callq  *%rax
  803479:	48 98                	cltq   
  80347b:	48 83 c0 01          	add    $0x1,%rax
  80347f:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803483:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803487:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80348a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80348d:	0f 8c 6a ff ff ff    	jl     8033fd <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803493:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803496:	48 98                	cltq   
  803498:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80349f:	00 
  8034a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034a4:	48 01 d0             	add    %rdx,%rax
  8034a7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8034ae:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8034b5:	00 
  8034b6:	74 35                	je     8034ed <init_stack+0x1ec>
  8034b8:	48 b9 68 4e 80 00 00 	movabs $0x804e68,%rcx
  8034bf:	00 00 00 
  8034c2:	48 ba 8e 4e 80 00 00 	movabs $0x804e8e,%rdx
  8034c9:	00 00 00 
  8034cc:	be f1 00 00 00       	mov    $0xf1,%esi
  8034d1:	48 bf 28 4e 80 00 00 	movabs $0x804e28,%rdi
  8034d8:	00 00 00 
  8034db:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e0:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  8034e7:	00 00 00 
  8034ea:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8034ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034f1:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8034f5:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8034fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034fe:	48 01 c8             	add    %rcx,%rax
  803501:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803507:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  80350a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80350e:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803512:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803515:	48 98                	cltq   
  803517:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80351a:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80351f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803523:	48 01 d0             	add    %rdx,%rax
  803526:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80352c:	48 89 c2             	mov    %rax,%rdx
  80352f:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803533:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803536:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803539:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80353f:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803544:	89 c2                	mov    %eax,%edx
  803546:	be 00 00 40 00       	mov    $0x400000,%esi
  80354b:	bf 00 00 00 00       	mov    $0x0,%edi
  803550:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  803557:	00 00 00 
  80355a:	ff d0                	callq  *%rax
  80355c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80355f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803563:	79 02                	jns    803567 <init_stack+0x266>
		goto error;
  803565:	eb 28                	jmp    80358f <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803567:	be 00 00 40 00       	mov    $0x400000,%esi
  80356c:	bf 00 00 00 00       	mov    $0x0,%edi
  803571:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803578:	00 00 00 
  80357b:	ff d0                	callq  *%rax
  80357d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803580:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803584:	79 02                	jns    803588 <init_stack+0x287>
		goto error;
  803586:	eb 07                	jmp    80358f <init_stack+0x28e>

	return 0;
  803588:	b8 00 00 00 00       	mov    $0x0,%eax
  80358d:	eb 19                	jmp    8035a8 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  80358f:	be 00 00 40 00       	mov    $0x400000,%esi
  803594:	bf 00 00 00 00       	mov    $0x0,%edi
  803599:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  8035a0:	00 00 00 
  8035a3:	ff d0                	callq  *%rax
	return r;
  8035a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8035a8:	c9                   	leaveq 
  8035a9:	c3                   	retq   

00000000008035aa <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8035aa:	55                   	push   %rbp
  8035ab:	48 89 e5             	mov    %rsp,%rbp
  8035ae:	48 83 ec 50          	sub    $0x50,%rsp
  8035b2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8035b5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035b9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8035bd:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8035c0:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8035c4:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8035c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035cc:	25 ff 0f 00 00       	and    $0xfff,%eax
  8035d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d8:	74 21                	je     8035fb <map_segment+0x51>
		va -= i;
  8035da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035dd:	48 98                	cltq   
  8035df:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8035e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e6:	48 98                	cltq   
  8035e8:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8035ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ef:	48 98                	cltq   
  8035f1:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8035f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f8:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8035fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803602:	e9 79 01 00 00       	jmpq   803780 <map_segment+0x1d6>
		if (i >= filesz) {
  803607:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360a:	48 98                	cltq   
  80360c:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803610:	72 3c                	jb     80364e <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803612:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803615:	48 63 d0             	movslq %eax,%rdx
  803618:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80361c:	48 01 d0             	add    %rdx,%rax
  80361f:	48 89 c1             	mov    %rax,%rcx
  803622:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803625:	8b 55 10             	mov    0x10(%rbp),%edx
  803628:	48 89 ce             	mov    %rcx,%rsi
  80362b:	89 c7                	mov    %eax,%edi
  80362d:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  803634:	00 00 00 
  803637:	ff d0                	callq  *%rax
  803639:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80363c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803640:	0f 89 33 01 00 00    	jns    803779 <map_segment+0x1cf>
				return r;
  803646:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803649:	e9 46 01 00 00       	jmpq   803794 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80364e:	ba 07 00 00 00       	mov    $0x7,%edx
  803653:	be 00 00 40 00       	mov    $0x400000,%esi
  803658:	bf 00 00 00 00       	mov    $0x0,%edi
  80365d:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  803664:	00 00 00 
  803667:	ff d0                	callq  *%rax
  803669:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80366c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803670:	79 08                	jns    80367a <map_segment+0xd0>
				return r;
  803672:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803675:	e9 1a 01 00 00       	jmpq   803794 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80367a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367d:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803680:	01 c2                	add    %eax,%edx
  803682:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803685:	89 d6                	mov    %edx,%esi
  803687:	89 c7                	mov    %eax,%edi
  803689:	48 b8 78 24 80 00 00 	movabs $0x802478,%rax
  803690:	00 00 00 
  803693:	ff d0                	callq  *%rax
  803695:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803698:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80369c:	79 08                	jns    8036a6 <map_segment+0xfc>
				return r;
  80369e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036a1:	e9 ee 00 00 00       	jmpq   803794 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8036a6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8036ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b0:	48 98                	cltq   
  8036b2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8036b6:	48 29 c2             	sub    %rax,%rdx
  8036b9:	48 89 d0             	mov    %rdx,%rax
  8036bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8036c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036c3:	48 63 d0             	movslq %eax,%rdx
  8036c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ca:	48 39 c2             	cmp    %rax,%rdx
  8036cd:	48 0f 47 d0          	cmova  %rax,%rdx
  8036d1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8036d4:	be 00 00 40 00       	mov    $0x400000,%esi
  8036d9:	89 c7                	mov    %eax,%edi
  8036db:	48 b8 62 23 80 00 00 	movabs $0x802362,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
  8036e7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8036ea:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036ee:	79 08                	jns    8036f8 <map_segment+0x14e>
				return r;
  8036f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036f3:	e9 9c 00 00 00       	jmpq   803794 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8036f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fb:	48 63 d0             	movslq %eax,%rdx
  8036fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803702:	48 01 d0             	add    %rdx,%rax
  803705:	48 89 c2             	mov    %rax,%rdx
  803708:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80370b:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80370f:	48 89 d1             	mov    %rdx,%rcx
  803712:	89 c2                	mov    %eax,%edx
  803714:	be 00 00 40 00       	mov    $0x400000,%esi
  803719:	bf 00 00 00 00       	mov    $0x0,%edi
  80371e:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  803725:	00 00 00 
  803728:	ff d0                	callq  *%rax
  80372a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80372d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803731:	79 30                	jns    803763 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803733:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803736:	89 c1                	mov    %eax,%ecx
  803738:	48 ba a3 4e 80 00 00 	movabs $0x804ea3,%rdx
  80373f:	00 00 00 
  803742:	be 24 01 00 00       	mov    $0x124,%esi
  803747:	48 bf 28 4e 80 00 00 	movabs $0x804e28,%rdi
  80374e:	00 00 00 
  803751:	b8 00 00 00 00       	mov    $0x0,%eax
  803756:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  80375d:	00 00 00 
  803760:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803763:	be 00 00 40 00       	mov    $0x400000,%esi
  803768:	bf 00 00 00 00       	mov    $0x0,%edi
  80376d:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803774:	00 00 00 
  803777:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803779:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803780:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803783:	48 98                	cltq   
  803785:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803789:	0f 82 78 fe ff ff    	jb     803607 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  80378f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803794:	c9                   	leaveq 
  803795:	c3                   	retq   

0000000000803796 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803796:	55                   	push   %rbp
  803797:	48 89 e5             	mov    %rsp,%rbp
  80379a:	48 83 ec 20          	sub    $0x20,%rsp
  80379e:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  8037a1:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8037a8:	00 
  8037a9:	e9 c9 00 00 00       	jmpq   803877 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  8037ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b2:	48 c1 e8 27          	shr    $0x27,%rax
  8037b6:	48 89 c2             	mov    %rax,%rdx
  8037b9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8037c0:	01 00 00 
  8037c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037c7:	48 85 c0             	test   %rax,%rax
  8037ca:	74 3c                	je     803808 <copy_shared_pages+0x72>
  8037cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d0:	48 c1 e8 1e          	shr    $0x1e,%rax
  8037d4:	48 89 c2             	mov    %rax,%rdx
  8037d7:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8037de:	01 00 00 
  8037e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037e5:	48 85 c0             	test   %rax,%rax
  8037e8:	74 1e                	je     803808 <copy_shared_pages+0x72>
  8037ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ee:	48 c1 e8 15          	shr    $0x15,%rax
  8037f2:	48 89 c2             	mov    %rax,%rdx
  8037f5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8037fc:	01 00 00 
  8037ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803803:	48 85 c0             	test   %rax,%rax
  803806:	75 02                	jne    80380a <copy_shared_pages+0x74>
                continue;
  803808:	eb 65                	jmp    80386f <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  80380a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80380e:	48 c1 e8 0c          	shr    $0xc,%rax
  803812:	48 89 c2             	mov    %rax,%rdx
  803815:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80381c:	01 00 00 
  80381f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803823:	25 00 04 00 00       	and    $0x400,%eax
  803828:	48 85 c0             	test   %rax,%rax
  80382b:	74 42                	je     80386f <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  80382d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803831:	48 c1 e8 0c          	shr    $0xc,%rax
  803835:	48 89 c2             	mov    %rax,%rdx
  803838:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80383f:	01 00 00 
  803842:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803846:	25 07 0e 00 00       	and    $0xe07,%eax
  80384b:	89 c6                	mov    %eax,%esi
  80384d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803851:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803855:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803858:	41 89 f0             	mov    %esi,%r8d
  80385b:	48 89 c6             	mov    %rax,%rsi
  80385e:	bf 00 00 00 00       	mov    $0x0,%edi
  803863:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  80386a:	00 00 00 
  80386d:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  80386f:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803876:	00 
  803877:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  80387e:	00 00 00 
  803881:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803885:	0f 86 23 ff ff ff    	jbe    8037ae <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  80388b:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  803890:	c9                   	leaveq 
  803891:	c3                   	retq   

0000000000803892 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803892:	55                   	push   %rbp
  803893:	48 89 e5             	mov    %rsp,%rbp
  803896:	53                   	push   %rbx
  803897:	48 83 ec 38          	sub    $0x38,%rsp
  80389b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80389f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8038a3:	48 89 c7             	mov    %rax,%rdi
  8038a6:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  8038ad:	00 00 00 
  8038b0:	ff d0                	callq  *%rax
  8038b2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038b9:	0f 88 bf 01 00 00    	js     803a7e <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c3:	ba 07 04 00 00       	mov    $0x407,%edx
  8038c8:	48 89 c6             	mov    %rax,%rsi
  8038cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d0:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  8038d7:	00 00 00 
  8038da:	ff d0                	callq  *%rax
  8038dc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038df:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038e3:	0f 88 95 01 00 00    	js     803a7e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8038e9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8038ed:	48 89 c7             	mov    %rax,%rdi
  8038f0:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  8038f7:	00 00 00 
  8038fa:	ff d0                	callq  *%rax
  8038fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803903:	0f 88 5d 01 00 00    	js     803a66 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803909:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80390d:	ba 07 04 00 00       	mov    $0x407,%edx
  803912:	48 89 c6             	mov    %rax,%rsi
  803915:	bf 00 00 00 00       	mov    $0x0,%edi
  80391a:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  803921:	00 00 00 
  803924:	ff d0                	callq  *%rax
  803926:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803929:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80392d:	0f 88 33 01 00 00    	js     803a66 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803933:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803937:	48 89 c7             	mov    %rax,%rdi
  80393a:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  803941:	00 00 00 
  803944:	ff d0                	callq  *%rax
  803946:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80394a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80394e:	ba 07 04 00 00       	mov    $0x407,%edx
  803953:	48 89 c6             	mov    %rax,%rsi
  803956:	bf 00 00 00 00       	mov    $0x0,%edi
  80395b:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  803962:	00 00 00 
  803965:	ff d0                	callq  *%rax
  803967:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80396a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80396e:	79 05                	jns    803975 <pipe+0xe3>
		goto err2;
  803970:	e9 d9 00 00 00       	jmpq   803a4e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803975:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803979:	48 89 c7             	mov    %rax,%rdi
  80397c:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  803983:	00 00 00 
  803986:	ff d0                	callq  *%rax
  803988:	48 89 c2             	mov    %rax,%rdx
  80398b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80398f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803995:	48 89 d1             	mov    %rdx,%rcx
  803998:	ba 00 00 00 00       	mov    $0x0,%edx
  80399d:	48 89 c6             	mov    %rax,%rsi
  8039a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8039a5:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  8039ac:	00 00 00 
  8039af:	ff d0                	callq  *%rax
  8039b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039b8:	79 1b                	jns    8039d5 <pipe+0x143>
		goto err3;
  8039ba:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8039bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039bf:	48 89 c6             	mov    %rax,%rsi
  8039c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8039c7:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  8039ce:	00 00 00 
  8039d1:	ff d0                	callq  *%rax
  8039d3:	eb 79                	jmp    803a4e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8039d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d9:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039e0:	00 00 00 
  8039e3:	8b 12                	mov    (%rdx),%edx
  8039e5:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8039e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8039f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039f6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039fd:	00 00 00 
  803a00:	8b 12                	mov    (%rdx),%edx
  803a02:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803a04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a08:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803a0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a13:	48 89 c7             	mov    %rax,%rdi
  803a16:	48 b8 75 1d 80 00 00 	movabs $0x801d75,%rax
  803a1d:	00 00 00 
  803a20:	ff d0                	callq  *%rax
  803a22:	89 c2                	mov    %eax,%edx
  803a24:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a28:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803a2a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a2e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803a32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a36:	48 89 c7             	mov    %rax,%rdi
  803a39:	48 b8 75 1d 80 00 00 	movabs $0x801d75,%rax
  803a40:	00 00 00 
  803a43:	ff d0                	callq  *%rax
  803a45:	89 03                	mov    %eax,(%rbx)
	return 0;
  803a47:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4c:	eb 33                	jmp    803a81 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803a4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a52:	48 89 c6             	mov    %rax,%rsi
  803a55:	bf 00 00 00 00       	mov    $0x0,%edi
  803a5a:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803a61:	00 00 00 
  803a64:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803a66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a6a:	48 89 c6             	mov    %rax,%rsi
  803a6d:	bf 00 00 00 00       	mov    $0x0,%edi
  803a72:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803a79:	00 00 00 
  803a7c:	ff d0                	callq  *%rax
err:
	return r;
  803a7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a81:	48 83 c4 38          	add    $0x38,%rsp
  803a85:	5b                   	pop    %rbx
  803a86:	5d                   	pop    %rbp
  803a87:	c3                   	retq   

0000000000803a88 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a88:	55                   	push   %rbp
  803a89:	48 89 e5             	mov    %rsp,%rbp
  803a8c:	53                   	push   %rbx
  803a8d:	48 83 ec 28          	sub    $0x28,%rsp
  803a91:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a95:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a99:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803aa0:	00 00 00 
  803aa3:	48 8b 00             	mov    (%rax),%rax
  803aa6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803aac:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803aaf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ab3:	48 89 c7             	mov    %rax,%rdi
  803ab6:	48 b8 4b 46 80 00 00 	movabs $0x80464b,%rax
  803abd:	00 00 00 
  803ac0:	ff d0                	callq  *%rax
  803ac2:	89 c3                	mov    %eax,%ebx
  803ac4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac8:	48 89 c7             	mov    %rax,%rdi
  803acb:	48 b8 4b 46 80 00 00 	movabs $0x80464b,%rax
  803ad2:	00 00 00 
  803ad5:	ff d0                	callq  *%rax
  803ad7:	39 c3                	cmp    %eax,%ebx
  803ad9:	0f 94 c0             	sete   %al
  803adc:	0f b6 c0             	movzbl %al,%eax
  803adf:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803ae2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ae9:	00 00 00 
  803aec:	48 8b 00             	mov    (%rax),%rax
  803aef:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803af5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803af8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803afb:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803afe:	75 05                	jne    803b05 <_pipeisclosed+0x7d>
			return ret;
  803b00:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b03:	eb 4f                	jmp    803b54 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803b05:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b08:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b0b:	74 42                	je     803b4f <_pipeisclosed+0xc7>
  803b0d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803b11:	75 3c                	jne    803b4f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803b13:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b1a:	00 00 00 
  803b1d:	48 8b 00             	mov    (%rax),%rax
  803b20:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803b26:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b2c:	89 c6                	mov    %eax,%esi
  803b2e:	48 bf ca 4e 80 00 00 	movabs $0x804eca,%rdi
  803b35:	00 00 00 
  803b38:	b8 00 00 00 00       	mov    $0x0,%eax
  803b3d:	49 b8 41 05 80 00 00 	movabs $0x800541,%r8
  803b44:	00 00 00 
  803b47:	41 ff d0             	callq  *%r8
	}
  803b4a:	e9 4a ff ff ff       	jmpq   803a99 <_pipeisclosed+0x11>
  803b4f:	e9 45 ff ff ff       	jmpq   803a99 <_pipeisclosed+0x11>
}
  803b54:	48 83 c4 28          	add    $0x28,%rsp
  803b58:	5b                   	pop    %rbx
  803b59:	5d                   	pop    %rbp
  803b5a:	c3                   	retq   

0000000000803b5b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803b5b:	55                   	push   %rbp
  803b5c:	48 89 e5             	mov    %rsp,%rbp
  803b5f:	48 83 ec 30          	sub    $0x30,%rsp
  803b63:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b66:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b6a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b6d:	48 89 d6             	mov    %rdx,%rsi
  803b70:	89 c7                	mov    %eax,%edi
  803b72:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  803b79:	00 00 00 
  803b7c:	ff d0                	callq  *%rax
  803b7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b85:	79 05                	jns    803b8c <pipeisclosed+0x31>
		return r;
  803b87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b8a:	eb 31                	jmp    803bbd <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803b8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b90:	48 89 c7             	mov    %rax,%rdi
  803b93:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  803b9a:	00 00 00 
  803b9d:	ff d0                	callq  *%rax
  803b9f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ba7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bab:	48 89 d6             	mov    %rdx,%rsi
  803bae:	48 89 c7             	mov    %rax,%rdi
  803bb1:	48 b8 88 3a 80 00 00 	movabs $0x803a88,%rax
  803bb8:	00 00 00 
  803bbb:	ff d0                	callq  *%rax
}
  803bbd:	c9                   	leaveq 
  803bbe:	c3                   	retq   

0000000000803bbf <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bbf:	55                   	push   %rbp
  803bc0:	48 89 e5             	mov    %rsp,%rbp
  803bc3:	48 83 ec 40          	sub    $0x40,%rsp
  803bc7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803bcb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803bcf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803bd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd7:	48 89 c7             	mov    %rax,%rdi
  803bda:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  803be1:	00 00 00 
  803be4:	ff d0                	callq  *%rax
  803be6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803bea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bf2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bf9:	00 
  803bfa:	e9 92 00 00 00       	jmpq   803c91 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803bff:	eb 41                	jmp    803c42 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803c01:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c06:	74 09                	je     803c11 <devpipe_read+0x52>
				return i;
  803c08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c0c:	e9 92 00 00 00       	jmpq   803ca3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803c11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c19:	48 89 d6             	mov    %rdx,%rsi
  803c1c:	48 89 c7             	mov    %rax,%rdi
  803c1f:	48 b8 88 3a 80 00 00 	movabs $0x803a88,%rax
  803c26:	00 00 00 
  803c29:	ff d0                	callq  *%rax
  803c2b:	85 c0                	test   %eax,%eax
  803c2d:	74 07                	je     803c36 <devpipe_read+0x77>
				return 0;
  803c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c34:	eb 6d                	jmp    803ca3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803c36:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  803c3d:	00 00 00 
  803c40:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803c42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c46:	8b 10                	mov    (%rax),%edx
  803c48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4c:	8b 40 04             	mov    0x4(%rax),%eax
  803c4f:	39 c2                	cmp    %eax,%edx
  803c51:	74 ae                	je     803c01 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c5b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803c5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c63:	8b 00                	mov    (%rax),%eax
  803c65:	99                   	cltd   
  803c66:	c1 ea 1b             	shr    $0x1b,%edx
  803c69:	01 d0                	add    %edx,%eax
  803c6b:	83 e0 1f             	and    $0x1f,%eax
  803c6e:	29 d0                	sub    %edx,%eax
  803c70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c74:	48 98                	cltq   
  803c76:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803c7b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c81:	8b 00                	mov    (%rax),%eax
  803c83:	8d 50 01             	lea    0x1(%rax),%edx
  803c86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c8a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c8c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c95:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c99:	0f 82 60 ff ff ff    	jb     803bff <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803c9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ca3:	c9                   	leaveq 
  803ca4:	c3                   	retq   

0000000000803ca5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ca5:	55                   	push   %rbp
  803ca6:	48 89 e5             	mov    %rsp,%rbp
  803ca9:	48 83 ec 40          	sub    $0x40,%rsp
  803cad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803cb1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803cb5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803cb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cbd:	48 89 c7             	mov    %rax,%rdi
  803cc0:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
  803ccc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803cd0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803cd8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cdf:	00 
  803ce0:	e9 8e 00 00 00       	jmpq   803d73 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ce5:	eb 31                	jmp    803d18 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ce7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ceb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cef:	48 89 d6             	mov    %rdx,%rsi
  803cf2:	48 89 c7             	mov    %rax,%rdi
  803cf5:	48 b8 88 3a 80 00 00 	movabs $0x803a88,%rax
  803cfc:	00 00 00 
  803cff:	ff d0                	callq  *%rax
  803d01:	85 c0                	test   %eax,%eax
  803d03:	74 07                	je     803d0c <devpipe_write+0x67>
				return 0;
  803d05:	b8 00 00 00 00       	mov    $0x0,%eax
  803d0a:	eb 79                	jmp    803d85 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803d0c:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  803d13:	00 00 00 
  803d16:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1c:	8b 40 04             	mov    0x4(%rax),%eax
  803d1f:	48 63 d0             	movslq %eax,%rdx
  803d22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d26:	8b 00                	mov    (%rax),%eax
  803d28:	48 98                	cltq   
  803d2a:	48 83 c0 20          	add    $0x20,%rax
  803d2e:	48 39 c2             	cmp    %rax,%rdx
  803d31:	73 b4                	jae    803ce7 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803d33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d37:	8b 40 04             	mov    0x4(%rax),%eax
  803d3a:	99                   	cltd   
  803d3b:	c1 ea 1b             	shr    $0x1b,%edx
  803d3e:	01 d0                	add    %edx,%eax
  803d40:	83 e0 1f             	and    $0x1f,%eax
  803d43:	29 d0                	sub    %edx,%eax
  803d45:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d49:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d4d:	48 01 ca             	add    %rcx,%rdx
  803d50:	0f b6 0a             	movzbl (%rdx),%ecx
  803d53:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d57:	48 98                	cltq   
  803d59:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803d5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d61:	8b 40 04             	mov    0x4(%rax),%eax
  803d64:	8d 50 01             	lea    0x1(%rax),%edx
  803d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d6e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d77:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d7b:	0f 82 64 ff ff ff    	jb     803ce5 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803d81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d85:	c9                   	leaveq 
  803d86:	c3                   	retq   

0000000000803d87 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803d87:	55                   	push   %rbp
  803d88:	48 89 e5             	mov    %rsp,%rbp
  803d8b:	48 83 ec 20          	sub    $0x20,%rsp
  803d8f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d93:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803d97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d9b:	48 89 c7             	mov    %rax,%rdi
  803d9e:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  803da5:	00 00 00 
  803da8:	ff d0                	callq  *%rax
  803daa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803dae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803db2:	48 be dd 4e 80 00 00 	movabs $0x804edd,%rsi
  803db9:	00 00 00 
  803dbc:	48 89 c7             	mov    %rax,%rdi
  803dbf:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  803dc6:	00 00 00 
  803dc9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803dcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dcf:	8b 50 04             	mov    0x4(%rax),%edx
  803dd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dd6:	8b 00                	mov    (%rax),%eax
  803dd8:	29 c2                	sub    %eax,%edx
  803dda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dde:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803de4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803def:	00 00 00 
	stat->st_dev = &devpipe;
  803df2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803df6:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803dfd:	00 00 00 
  803e00:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e0c:	c9                   	leaveq 
  803e0d:	c3                   	retq   

0000000000803e0e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803e0e:	55                   	push   %rbp
  803e0f:	48 89 e5             	mov    %rsp,%rbp
  803e12:	48 83 ec 10          	sub    $0x10,%rsp
  803e16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803e1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e1e:	48 89 c6             	mov    %rax,%rsi
  803e21:	bf 00 00 00 00       	mov    $0x0,%edi
  803e26:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803e2d:	00 00 00 
  803e30:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803e32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e36:	48 89 c7             	mov    %rax,%rdi
  803e39:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  803e40:	00 00 00 
  803e43:	ff d0                	callq  *%rax
  803e45:	48 89 c6             	mov    %rax,%rsi
  803e48:	bf 00 00 00 00       	mov    $0x0,%edi
  803e4d:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803e54:	00 00 00 
  803e57:	ff d0                	callq  *%rax
}
  803e59:	c9                   	leaveq 
  803e5a:	c3                   	retq   

0000000000803e5b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803e5b:	55                   	push   %rbp
  803e5c:	48 89 e5             	mov    %rsp,%rbp
  803e5f:	48 83 ec 20          	sub    $0x20,%rsp
  803e63:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803e66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e69:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803e6c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803e70:	be 01 00 00 00       	mov    $0x1,%esi
  803e75:	48 89 c7             	mov    %rax,%rdi
  803e78:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  803e7f:	00 00 00 
  803e82:	ff d0                	callq  *%rax
}
  803e84:	c9                   	leaveq 
  803e85:	c3                   	retq   

0000000000803e86 <getchar>:

int
getchar(void)
{
  803e86:	55                   	push   %rbp
  803e87:	48 89 e5             	mov    %rsp,%rbp
  803e8a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e8e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803e92:	ba 01 00 00 00       	mov    $0x1,%edx
  803e97:	48 89 c6             	mov    %rax,%rsi
  803e9a:	bf 00 00 00 00       	mov    $0x0,%edi
  803e9f:	48 b8 8d 22 80 00 00 	movabs $0x80228d,%rax
  803ea6:	00 00 00 
  803ea9:	ff d0                	callq  *%rax
  803eab:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803eae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb2:	79 05                	jns    803eb9 <getchar+0x33>
		return r;
  803eb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eb7:	eb 14                	jmp    803ecd <getchar+0x47>
	if (r < 1)
  803eb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ebd:	7f 07                	jg     803ec6 <getchar+0x40>
		return -E_EOF;
  803ebf:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803ec4:	eb 07                	jmp    803ecd <getchar+0x47>
	return c;
  803ec6:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803eca:	0f b6 c0             	movzbl %al,%eax
}
  803ecd:	c9                   	leaveq 
  803ece:	c3                   	retq   

0000000000803ecf <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803ecf:	55                   	push   %rbp
  803ed0:	48 89 e5             	mov    %rsp,%rbp
  803ed3:	48 83 ec 20          	sub    $0x20,%rsp
  803ed7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803eda:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ede:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ee1:	48 89 d6             	mov    %rdx,%rsi
  803ee4:	89 c7                	mov    %eax,%edi
  803ee6:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  803eed:	00 00 00 
  803ef0:	ff d0                	callq  *%rax
  803ef2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ef5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ef9:	79 05                	jns    803f00 <iscons+0x31>
		return r;
  803efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803efe:	eb 1a                	jmp    803f1a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f04:	8b 10                	mov    (%rax),%edx
  803f06:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803f0d:	00 00 00 
  803f10:	8b 00                	mov    (%rax),%eax
  803f12:	39 c2                	cmp    %eax,%edx
  803f14:	0f 94 c0             	sete   %al
  803f17:	0f b6 c0             	movzbl %al,%eax
}
  803f1a:	c9                   	leaveq 
  803f1b:	c3                   	retq   

0000000000803f1c <opencons>:

int
opencons(void)
{
  803f1c:	55                   	push   %rbp
  803f1d:	48 89 e5             	mov    %rsp,%rbp
  803f20:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803f24:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f28:	48 89 c7             	mov    %rax,%rdi
  803f2b:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  803f32:	00 00 00 
  803f35:	ff d0                	callq  *%rax
  803f37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f3e:	79 05                	jns    803f45 <opencons+0x29>
		return r;
  803f40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f43:	eb 5b                	jmp    803fa0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803f45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f49:	ba 07 04 00 00       	mov    $0x407,%edx
  803f4e:	48 89 c6             	mov    %rax,%rsi
  803f51:	bf 00 00 00 00       	mov    $0x0,%edi
  803f56:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  803f5d:	00 00 00 
  803f60:	ff d0                	callq  *%rax
  803f62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f69:	79 05                	jns    803f70 <opencons+0x54>
		return r;
  803f6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f6e:	eb 30                	jmp    803fa0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803f70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f74:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803f7b:	00 00 00 
  803f7e:	8b 12                	mov    (%rdx),%edx
  803f80:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803f82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f86:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803f8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f91:	48 89 c7             	mov    %rax,%rdi
  803f94:	48 b8 75 1d 80 00 00 	movabs $0x801d75,%rax
  803f9b:	00 00 00 
  803f9e:	ff d0                	callq  *%rax
}
  803fa0:	c9                   	leaveq 
  803fa1:	c3                   	retq   

0000000000803fa2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fa2:	55                   	push   %rbp
  803fa3:	48 89 e5             	mov    %rsp,%rbp
  803fa6:	48 83 ec 30          	sub    $0x30,%rsp
  803faa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fb2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803fb6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fbb:	75 07                	jne    803fc4 <devcons_read+0x22>
		return 0;
  803fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  803fc2:	eb 4b                	jmp    80400f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803fc4:	eb 0c                	jmp    803fd2 <devcons_read+0x30>
		sys_yield();
  803fc6:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  803fcd:	00 00 00 
  803fd0:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803fd2:	48 b8 27 19 80 00 00 	movabs $0x801927,%rax
  803fd9:	00 00 00 
  803fdc:	ff d0                	callq  *%rax
  803fde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fe1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fe5:	74 df                	je     803fc6 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803fe7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803feb:	79 05                	jns    803ff2 <devcons_read+0x50>
		return c;
  803fed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ff0:	eb 1d                	jmp    80400f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803ff2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ff6:	75 07                	jne    803fff <devcons_read+0x5d>
		return 0;
  803ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ffd:	eb 10                	jmp    80400f <devcons_read+0x6d>
	*(char*)vbuf = c;
  803fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804002:	89 c2                	mov    %eax,%edx
  804004:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804008:	88 10                	mov    %dl,(%rax)
	return 1;
  80400a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80400f:	c9                   	leaveq 
  804010:	c3                   	retq   

0000000000804011 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804011:	55                   	push   %rbp
  804012:	48 89 e5             	mov    %rsp,%rbp
  804015:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80401c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804023:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80402a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804031:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804038:	eb 76                	jmp    8040b0 <devcons_write+0x9f>
		m = n - tot;
  80403a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804041:	89 c2                	mov    %eax,%edx
  804043:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804046:	29 c2                	sub    %eax,%edx
  804048:	89 d0                	mov    %edx,%eax
  80404a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80404d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804050:	83 f8 7f             	cmp    $0x7f,%eax
  804053:	76 07                	jbe    80405c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804055:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80405c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80405f:	48 63 d0             	movslq %eax,%rdx
  804062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804065:	48 63 c8             	movslq %eax,%rcx
  804068:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80406f:	48 01 c1             	add    %rax,%rcx
  804072:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804079:	48 89 ce             	mov    %rcx,%rsi
  80407c:	48 89 c7             	mov    %rax,%rdi
  80407f:	48 b8 1a 14 80 00 00 	movabs $0x80141a,%rax
  804086:	00 00 00 
  804089:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80408b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80408e:	48 63 d0             	movslq %eax,%rdx
  804091:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804098:	48 89 d6             	mov    %rdx,%rsi
  80409b:	48 89 c7             	mov    %rax,%rdi
  80409e:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  8040a5:	00 00 00 
  8040a8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040ad:	01 45 fc             	add    %eax,-0x4(%rbp)
  8040b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b3:	48 98                	cltq   
  8040b5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8040bc:	0f 82 78 ff ff ff    	jb     80403a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8040c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8040c5:	c9                   	leaveq 
  8040c6:	c3                   	retq   

00000000008040c7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8040c7:	55                   	push   %rbp
  8040c8:	48 89 e5             	mov    %rsp,%rbp
  8040cb:	48 83 ec 08          	sub    $0x8,%rsp
  8040cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8040d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040d8:	c9                   	leaveq 
  8040d9:	c3                   	retq   

00000000008040da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8040da:	55                   	push   %rbp
  8040db:	48 89 e5             	mov    %rsp,%rbp
  8040de:	48 83 ec 10          	sub    $0x10,%rsp
  8040e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8040e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8040ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ee:	48 be e9 4e 80 00 00 	movabs $0x804ee9,%rsi
  8040f5:	00 00 00 
  8040f8:	48 89 c7             	mov    %rax,%rdi
  8040fb:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  804102:	00 00 00 
  804105:	ff d0                	callq  *%rax
	return 0;
  804107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80410c:	c9                   	leaveq 
  80410d:	c3                   	retq   

000000000080410e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80410e:	55                   	push   %rbp
  80410f:	48 89 e5             	mov    %rsp,%rbp
  804112:	48 83 ec 30          	sub    $0x30,%rsp
  804116:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80411a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80411e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804122:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804129:	00 00 00 
  80412c:	48 8b 00             	mov    (%rax),%rax
  80412f:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804135:	85 c0                	test   %eax,%eax
  804137:	75 34                	jne    80416d <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  804139:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  804140:	00 00 00 
  804143:	ff d0                	callq  *%rax
  804145:	25 ff 03 00 00       	and    $0x3ff,%eax
  80414a:	48 98                	cltq   
  80414c:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804153:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80415a:	00 00 00 
  80415d:	48 01 c2             	add    %rax,%rdx
  804160:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804167:	00 00 00 
  80416a:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80416d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804172:	75 0e                	jne    804182 <ipc_recv+0x74>
		pg = (void*) UTOP;
  804174:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80417b:	00 00 00 
  80417e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804182:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804186:	48 89 c7             	mov    %rax,%rdi
  804189:	48 b8 4e 1c 80 00 00 	movabs $0x801c4e,%rax
  804190:	00 00 00 
  804193:	ff d0                	callq  *%rax
  804195:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804198:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80419c:	79 19                	jns    8041b7 <ipc_recv+0xa9>
		*from_env_store = 0;
  80419e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041a2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8041a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041ac:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8041b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b5:	eb 53                	jmp    80420a <ipc_recv+0xfc>
	}
	if(from_env_store)
  8041b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8041bc:	74 19                	je     8041d7 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8041be:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8041c5:	00 00 00 
  8041c8:	48 8b 00             	mov    (%rax),%rax
  8041cb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8041d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041d5:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8041d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8041dc:	74 19                	je     8041f7 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8041de:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8041e5:	00 00 00 
  8041e8:	48 8b 00             	mov    (%rax),%rax
  8041eb:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8041f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041f5:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8041f7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8041fe:	00 00 00 
  804201:	48 8b 00             	mov    (%rax),%rax
  804204:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80420a:	c9                   	leaveq 
  80420b:	c3                   	retq   

000000000080420c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80420c:	55                   	push   %rbp
  80420d:	48 89 e5             	mov    %rsp,%rbp
  804210:	48 83 ec 30          	sub    $0x30,%rsp
  804214:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804217:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80421a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80421e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804221:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804226:	75 0e                	jne    804236 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804228:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80422f:	00 00 00 
  804232:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804236:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804239:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80423c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804240:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804243:	89 c7                	mov    %eax,%edi
  804245:	48 b8 f9 1b 80 00 00 	movabs $0x801bf9,%rax
  80424c:	00 00 00 
  80424f:	ff d0                	callq  *%rax
  804251:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804254:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804258:	75 0c                	jne    804266 <ipc_send+0x5a>
			sys_yield();
  80425a:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  804261:	00 00 00 
  804264:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804266:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80426a:	74 ca                	je     804236 <ipc_send+0x2a>
	if(result != 0)
  80426c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804270:	74 20                	je     804292 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  804272:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804275:	89 c6                	mov    %eax,%esi
  804277:	48 bf f0 4e 80 00 00 	movabs $0x804ef0,%rdi
  80427e:	00 00 00 
  804281:	b8 00 00 00 00       	mov    $0x0,%eax
  804286:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  80428d:	00 00 00 
  804290:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  804292:	c9                   	leaveq 
  804293:	c3                   	retq   

0000000000804294 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804294:	55                   	push   %rbp
  804295:	48 89 e5             	mov    %rsp,%rbp
  804298:	53                   	push   %rbx
  804299:	48 83 ec 58          	sub    $0x58,%rsp
  80429d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  8042a1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8042a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  8042a9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  8042b0:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8042b7:	00 
  8042b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042bc:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8042c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042c4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8042c8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042cc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8042d0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8042d4:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8042d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042dc:	48 c1 e8 27          	shr    $0x27,%rax
  8042e0:	48 89 c2             	mov    %rax,%rdx
  8042e3:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8042ea:	01 00 00 
  8042ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042f1:	83 e0 01             	and    $0x1,%eax
  8042f4:	48 85 c0             	test   %rax,%rax
  8042f7:	0f 85 91 00 00 00    	jne    80438e <ipc_host_recv+0xfa>
  8042fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804301:	48 c1 e8 1e          	shr    $0x1e,%rax
  804305:	48 89 c2             	mov    %rax,%rdx
  804308:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80430f:	01 00 00 
  804312:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804316:	83 e0 01             	and    $0x1,%eax
  804319:	48 85 c0             	test   %rax,%rax
  80431c:	74 70                	je     80438e <ipc_host_recv+0xfa>
  80431e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804322:	48 c1 e8 15          	shr    $0x15,%rax
  804326:	48 89 c2             	mov    %rax,%rdx
  804329:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804330:	01 00 00 
  804333:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804337:	83 e0 01             	and    $0x1,%eax
  80433a:	48 85 c0             	test   %rax,%rax
  80433d:	74 4f                	je     80438e <ipc_host_recv+0xfa>
  80433f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804343:	48 c1 e8 0c          	shr    $0xc,%rax
  804347:	48 89 c2             	mov    %rax,%rdx
  80434a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804351:	01 00 00 
  804354:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804358:	83 e0 01             	and    $0x1,%eax
  80435b:	48 85 c0             	test   %rax,%rax
  80435e:	74 2e                	je     80438e <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804364:	ba 07 04 00 00       	mov    $0x407,%edx
  804369:	48 89 c6             	mov    %rax,%rsi
  80436c:	bf 00 00 00 00       	mov    $0x0,%edi
  804371:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  804378:	00 00 00 
  80437b:	ff d0                	callq  *%rax
  80437d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  804380:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804384:	79 08                	jns    80438e <ipc_host_recv+0xfa>
	    	return result;
  804386:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804389:	e9 84 00 00 00       	jmpq   804412 <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  80438e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804392:	48 c1 e8 0c          	shr    $0xc,%rax
  804396:	48 89 c2             	mov    %rax,%rdx
  804399:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8043a0:	01 00 00 
  8043a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043a7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8043ad:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  8043b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8043b6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8043ba:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8043be:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8043c2:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8043c6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8043ca:	4c 89 c3             	mov    %r8,%rbx
  8043cd:	0f 01 c1             	vmcall 
  8043d0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  8043d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8043d7:	7e 36                	jle    80440f <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  8043d9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8043dc:	41 89 c0             	mov    %eax,%r8d
  8043df:	b9 03 00 00 00       	mov    $0x3,%ecx
  8043e4:	48 ba 08 4f 80 00 00 	movabs $0x804f08,%rdx
  8043eb:	00 00 00 
  8043ee:	be 67 00 00 00       	mov    $0x67,%esi
  8043f3:	48 bf 35 4f 80 00 00 	movabs $0x804f35,%rdi
  8043fa:	00 00 00 
  8043fd:	b8 00 00 00 00       	mov    $0x0,%eax
  804402:	49 b9 08 03 80 00 00 	movabs $0x800308,%r9
  804409:	00 00 00 
  80440c:	41 ff d1             	callq  *%r9
	return result;
  80440f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  804412:	48 83 c4 58          	add    $0x58,%rsp
  804416:	5b                   	pop    %rbx
  804417:	5d                   	pop    %rbp
  804418:	c3                   	retq   

0000000000804419 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804419:	55                   	push   %rbp
  80441a:	48 89 e5             	mov    %rsp,%rbp
  80441d:	53                   	push   %rbx
  80441e:	48 83 ec 68          	sub    $0x68,%rsp
  804422:	89 7d ac             	mov    %edi,-0x54(%rbp)
  804425:	89 75 a8             	mov    %esi,-0x58(%rbp)
  804428:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  80442c:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  80442f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804433:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  804437:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  80443e:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  804445:	00 
  804446:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80444a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80444e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804452:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80445a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80445e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804462:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  804466:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80446a:	48 c1 e8 27          	shr    $0x27,%rax
  80446e:	48 89 c2             	mov    %rax,%rdx
  804471:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804478:	01 00 00 
  80447b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80447f:	83 e0 01             	and    $0x1,%eax
  804482:	48 85 c0             	test   %rax,%rax
  804485:	0f 85 88 00 00 00    	jne    804513 <ipc_host_send+0xfa>
  80448b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80448f:	48 c1 e8 1e          	shr    $0x1e,%rax
  804493:	48 89 c2             	mov    %rax,%rdx
  804496:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80449d:	01 00 00 
  8044a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044a4:	83 e0 01             	and    $0x1,%eax
  8044a7:	48 85 c0             	test   %rax,%rax
  8044aa:	74 67                	je     804513 <ipc_host_send+0xfa>
  8044ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044b0:	48 c1 e8 15          	shr    $0x15,%rax
  8044b4:	48 89 c2             	mov    %rax,%rdx
  8044b7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8044be:	01 00 00 
  8044c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044c5:	83 e0 01             	and    $0x1,%eax
  8044c8:	48 85 c0             	test   %rax,%rax
  8044cb:	74 46                	je     804513 <ipc_host_send+0xfa>
  8044cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044d1:	48 c1 e8 0c          	shr    $0xc,%rax
  8044d5:	48 89 c2             	mov    %rax,%rdx
  8044d8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044df:	01 00 00 
  8044e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044e6:	83 e0 01             	and    $0x1,%eax
  8044e9:	48 85 c0             	test   %rax,%rax
  8044ec:	74 25                	je     804513 <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8044ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044f2:	48 c1 e8 0c          	shr    $0xc,%rax
  8044f6:	48 89 c2             	mov    %rax,%rdx
  8044f9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804500:	01 00 00 
  804503:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804507:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80450d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804511:	eb 0e                	jmp    804521 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  804513:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80451a:	00 00 00 
  80451d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  804521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804525:	48 89 c6             	mov    %rax,%rsi
  804528:	48 bf 3f 4f 80 00 00 	movabs $0x804f3f,%rdi
  80452f:	00 00 00 
  804532:	b8 00 00 00 00       	mov    $0x0,%eax
  804537:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  80453e:	00 00 00 
  804541:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  804543:	8b 45 ac             	mov    -0x54(%rbp),%eax
  804546:	48 98                	cltq   
  804548:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  80454c:	8b 45 a8             	mov    -0x58(%rbp),%eax
  80454f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  804553:	8b 45 9c             	mov    -0x64(%rbp),%eax
  804556:	48 98                	cltq   
  804558:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  80455c:	b8 02 00 00 00       	mov    $0x2,%eax
  804561:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  804565:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  804569:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  80456d:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804571:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  804575:	4c 89 c3             	mov    %r8,%rbx
  804578:	0f 01 c1             	vmcall 
  80457b:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  80457e:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  804582:	75 0c                	jne    804590 <ipc_host_send+0x177>
			sys_yield();
  804584:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  80458b:	00 00 00 
  80458e:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  804590:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  804594:	74 c6                	je     80455c <ipc_host_send+0x143>
	
	if(result !=0)
  804596:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80459a:	74 36                	je     8045d2 <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  80459c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80459f:	41 89 c0             	mov    %eax,%r8d
  8045a2:	b9 02 00 00 00       	mov    $0x2,%ecx
  8045a7:	48 ba 08 4f 80 00 00 	movabs $0x804f08,%rdx
  8045ae:	00 00 00 
  8045b1:	be 94 00 00 00       	mov    $0x94,%esi
  8045b6:	48 bf 35 4f 80 00 00 	movabs $0x804f35,%rdi
  8045bd:	00 00 00 
  8045c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c5:	49 b9 08 03 80 00 00 	movabs $0x800308,%r9
  8045cc:	00 00 00 
  8045cf:	41 ff d1             	callq  *%r9
}
  8045d2:	48 83 c4 68          	add    $0x68,%rsp
  8045d6:	5b                   	pop    %rbx
  8045d7:	5d                   	pop    %rbp
  8045d8:	c3                   	retq   

00000000008045d9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8045d9:	55                   	push   %rbp
  8045da:	48 89 e5             	mov    %rsp,%rbp
  8045dd:	48 83 ec 14          	sub    $0x14,%rsp
  8045e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8045e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045eb:	eb 4e                	jmp    80463b <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8045ed:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8045f4:	00 00 00 
  8045f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045fa:	48 98                	cltq   
  8045fc:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804603:	48 01 d0             	add    %rdx,%rax
  804606:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80460c:	8b 00                	mov    (%rax),%eax
  80460e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804611:	75 24                	jne    804637 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804613:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80461a:	00 00 00 
  80461d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804620:	48 98                	cltq   
  804622:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804629:	48 01 d0             	add    %rdx,%rax
  80462c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804632:	8b 40 08             	mov    0x8(%rax),%eax
  804635:	eb 12                	jmp    804649 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804637:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80463b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804642:	7e a9                	jle    8045ed <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804644:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804649:	c9                   	leaveq 
  80464a:	c3                   	retq   

000000000080464b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80464b:	55                   	push   %rbp
  80464c:	48 89 e5             	mov    %rsp,%rbp
  80464f:	48 83 ec 18          	sub    $0x18,%rsp
  804653:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80465b:	48 c1 e8 15          	shr    $0x15,%rax
  80465f:	48 89 c2             	mov    %rax,%rdx
  804662:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804669:	01 00 00 
  80466c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804670:	83 e0 01             	and    $0x1,%eax
  804673:	48 85 c0             	test   %rax,%rax
  804676:	75 07                	jne    80467f <pageref+0x34>
		return 0;
  804678:	b8 00 00 00 00       	mov    $0x0,%eax
  80467d:	eb 53                	jmp    8046d2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80467f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804683:	48 c1 e8 0c          	shr    $0xc,%rax
  804687:	48 89 c2             	mov    %rax,%rdx
  80468a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804691:	01 00 00 
  804694:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804698:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80469c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046a0:	83 e0 01             	and    $0x1,%eax
  8046a3:	48 85 c0             	test   %rax,%rax
  8046a6:	75 07                	jne    8046af <pageref+0x64>
		return 0;
  8046a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ad:	eb 23                	jmp    8046d2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8046af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8046b7:	48 89 c2             	mov    %rax,%rdx
  8046ba:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8046c1:	00 00 00 
  8046c4:	48 c1 e2 04          	shl    $0x4,%rdx
  8046c8:	48 01 d0             	add    %rdx,%rax
  8046cb:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8046cf:	0f b7 c0             	movzwl %ax,%eax
}
  8046d2:	c9                   	leaveq 
  8046d3:	c3                   	retq   
