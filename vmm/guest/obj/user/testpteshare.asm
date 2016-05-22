
vmm/guest/obj/user/testpteshare:     file format elf64-x86-64


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
  80003c:	e8 67 02 00 00       	callq  8002a8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800052:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800056:	74 0c                	je     800064 <umain+0x21>
		childofspawn();
  800058:	48 b8 75 02 80 00 00 	movabs $0x800275,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	ba 07 04 00 00       	mov    $0x407,%edx
  800069:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006e:	bf 00 00 00 00       	mov    $0x0,%edi
  800073:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800086:	79 30                	jns    8000b8 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008b:	89 c1                	mov    %eax,%ecx
  80008d:	48 ba be 4f 80 00 00 	movabs $0x804fbe,%rdx
  800094:	00 00 00 
  800097:	be 13 00 00 00       	mov    $0x13,%esi
  80009c:	48 bf d1 4f 80 00 00 	movabs $0x804fd1,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 a4 21 80 00 00 	movabs $0x8021a4,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba e5 4f 80 00 00 	movabs $0x804fe5,%rdx
  8000d9:	00 00 00 
  8000dc:	be 17 00 00 00       	mov    $0x17,%esi
  8000e1:	48 bf d1 4f 80 00 00 	movabs $0x804fd1,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800101:	75 2d                	jne    800130 <umain+0xed>
		strcpy(VA, msg);
  800103:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80010a:	00 00 00 
  80010d:	48 8b 00             	mov    (%rax),%rax
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800118:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
		exit();
  800124:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	}
	wait(r);
  800130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800133:	89 c7                	mov    %eax,%edi
  800135:	48 b8 33 45 80 00 00 	movabs $0x804533,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800141:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800148:	00 00 00 
  80014b:	48 8b 00             	mov    (%rax),%rax
  80014e:	48 89 c6             	mov    %rax,%rsi
  800151:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800156:	48 b8 9e 12 80 00 00 	movabs $0x80129e,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	85 c0                	test   %eax,%eax
  800164:	75 0c                	jne    800172 <umain+0x12f>
  800166:	48 b8 ee 4f 80 00 00 	movabs $0x804fee,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 f4 4f 80 00 00 	movabs $0x804ff4,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf fa 4f 80 00 00 	movabs $0x804ffa,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba 15 50 80 00 00 	movabs $0x805015,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be 19 50 80 00 00 	movabs $0x805019,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf 26 50 80 00 00 	movabs $0x805026,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 71 37 80 00 00 	movabs $0x803771,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba 38 50 80 00 00 	movabs $0x805038,%rdx
  8001e4:	00 00 00 
  8001e7:	be 21 00 00 00       	mov    $0x21,%esi
  8001ec:	48 bf d1 4f 80 00 00 	movabs $0x804fd1,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 33 45 80 00 00 	movabs $0x804533,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800219:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022e:	48 b8 9e 12 80 00 00 	movabs $0x80129e,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 0c                	jne    80024a <umain+0x207>
  80023e:	48 b8 ee 4f 80 00 00 	movabs $0x804fee,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 f4 4f 80 00 00 	movabs $0x804ff4,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf 42 50 80 00 00 	movabs $0x805042,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx


    static __inline void
breakpoint(void)
{
    __asm __volatile("int3");
  800272:	cc                   	int3   

	breakpoint();
}
  800273:	c9                   	leaveq 
  800274:	c3                   	retq   

0000000000800275 <childofspawn>:

void
childofspawn(void)
{
  800275:	55                   	push   %rbp
  800276:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  800279:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800280:	00 00 00 
  800283:	48 8b 00             	mov    (%rax),%rax
  800286:	48 89 c6             	mov    %rax,%rsi
  800289:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028e:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	exit();
  80029a:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
}
  8002a6:	5d                   	pop    %rbp
  8002a7:	c3                   	retq   

00000000008002a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 10          	sub    $0x10,%rsp
  8002b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002b7:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
  8002c3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002c8:	48 98                	cltq   
  8002ca:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8002d1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8002d8:	00 00 00 
  8002db:	48 01 c2             	add    %rax,%rdx
  8002de:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002e5:	00 00 00 
  8002e8:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002ef:	7e 14                	jle    800305 <libmain+0x5d>
		binaryname = argv[0];
  8002f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f5:	48 8b 10             	mov    (%rax),%rdx
  8002f8:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8002ff:	00 00 00 
  800302:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800305:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030c:	48 89 d6             	mov    %rdx,%rsi
  80030f:	89 c7                	mov    %eax,%edi
  800311:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800318:	00 00 00 
  80031b:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80031d:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  800324:	00 00 00 
  800327:	ff d0                	callq  *%rax
}
  800329:	c9                   	leaveq 
  80032a:	c3                   	retq   

000000000080032b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80032f:	48 b8 8e 27 80 00 00 	movabs $0x80278e,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80033b:	bf 00 00 00 00       	mov    $0x0,%edi
  800340:	48 b8 ab 19 80 00 00 	movabs $0x8019ab,%rax
  800347:	00 00 00 
  80034a:	ff d0                	callq  *%rax

}
  80034c:	5d                   	pop    %rbp
  80034d:	c3                   	retq   

000000000080034e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80034e:	55                   	push   %rbp
  80034f:	48 89 e5             	mov    %rsp,%rbp
  800352:	53                   	push   %rbx
  800353:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80035a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800361:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800367:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80036e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800375:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80037c:	84 c0                	test   %al,%al
  80037e:	74 23                	je     8003a3 <_panic+0x55>
  800380:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800387:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80038b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80038f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800393:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800397:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80039b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80039f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003a3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003aa:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003b1:	00 00 00 
  8003b4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003bb:	00 00 00 
  8003be:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003c2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003c9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003d0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003d7:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8003de:	00 00 00 
  8003e1:	48 8b 18             	mov    (%rax),%rbx
  8003e4:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  8003eb:	00 00 00 
  8003ee:	ff d0                	callq  *%rax
  8003f0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003f6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003fd:	41 89 c8             	mov    %ecx,%r8d
  800400:	48 89 d1             	mov    %rdx,%rcx
  800403:	48 89 da             	mov    %rbx,%rdx
  800406:	89 c6                	mov    %eax,%esi
  800408:	48 bf 68 50 80 00 00 	movabs $0x805068,%rdi
  80040f:	00 00 00 
  800412:	b8 00 00 00 00       	mov    $0x0,%eax
  800417:	49 b9 87 05 80 00 00 	movabs $0x800587,%r9
  80041e:	00 00 00 
  800421:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800424:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80042b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800432:	48 89 d6             	mov    %rdx,%rsi
  800435:	48 89 c7             	mov    %rax,%rdi
  800438:	48 b8 db 04 80 00 00 	movabs $0x8004db,%rax
  80043f:	00 00 00 
  800442:	ff d0                	callq  *%rax
	cprintf("\n");
  800444:	48 bf 8b 50 80 00 00 	movabs $0x80508b,%rdi
  80044b:	00 00 00 
  80044e:	b8 00 00 00 00       	mov    $0x0,%eax
  800453:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  80045a:	00 00 00 
  80045d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80045f:	cc                   	int3   
  800460:	eb fd                	jmp    80045f <_panic+0x111>

0000000000800462 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800462:	55                   	push   %rbp
  800463:	48 89 e5             	mov    %rsp,%rbp
  800466:	48 83 ec 10          	sub    $0x10,%rsp
  80046a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80046d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800475:	8b 00                	mov    (%rax),%eax
  800477:	8d 48 01             	lea    0x1(%rax),%ecx
  80047a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80047e:	89 0a                	mov    %ecx,(%rdx)
  800480:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800483:	89 d1                	mov    %edx,%ecx
  800485:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800489:	48 98                	cltq   
  80048b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80048f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800493:	8b 00                	mov    (%rax),%eax
  800495:	3d ff 00 00 00       	cmp    $0xff,%eax
  80049a:	75 2c                	jne    8004c8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80049c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a0:	8b 00                	mov    (%rax),%eax
  8004a2:	48 98                	cltq   
  8004a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a8:	48 83 c2 08          	add    $0x8,%rdx
  8004ac:	48 89 c6             	mov    %rax,%rsi
  8004af:	48 89 d7             	mov    %rdx,%rdi
  8004b2:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax
        b->idx = 0;
  8004be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cc:	8b 40 04             	mov    0x4(%rax),%eax
  8004cf:	8d 50 01             	lea    0x1(%rax),%edx
  8004d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004d9:	c9                   	leaveq 
  8004da:	c3                   	retq   

00000000008004db <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004db:	55                   	push   %rbp
  8004dc:	48 89 e5             	mov    %rsp,%rbp
  8004df:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004e6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004ed:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004f4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004fb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800502:	48 8b 0a             	mov    (%rdx),%rcx
  800505:	48 89 08             	mov    %rcx,(%rax)
  800508:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80050c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800510:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800514:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800518:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80051f:	00 00 00 
    b.cnt = 0;
  800522:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800529:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80052c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800533:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80053a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800541:	48 89 c6             	mov    %rax,%rsi
  800544:	48 bf 62 04 80 00 00 	movabs $0x800462,%rdi
  80054b:	00 00 00 
  80054e:	48 b8 3a 09 80 00 00 	movabs $0x80093a,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80055a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800560:	48 98                	cltq   
  800562:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800569:	48 83 c2 08          	add    $0x8,%rdx
  80056d:	48 89 c6             	mov    %rax,%rsi
  800570:	48 89 d7             	mov    %rdx,%rdi
  800573:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  80057a:	00 00 00 
  80057d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80057f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800585:	c9                   	leaveq 
  800586:	c3                   	retq   

0000000000800587 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800587:	55                   	push   %rbp
  800588:	48 89 e5             	mov    %rsp,%rbp
  80058b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800592:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800599:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005a0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005a7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005ae:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005b5:	84 c0                	test   %al,%al
  8005b7:	74 20                	je     8005d9 <cprintf+0x52>
  8005b9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005bd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005c1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005c5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005c9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005cd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005d1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005d5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005d9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005e0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005e7:	00 00 00 
  8005ea:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005f1:	00 00 00 
  8005f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005f8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005ff:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800606:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80060d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800614:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80061b:	48 8b 0a             	mov    (%rdx),%rcx
  80061e:	48 89 08             	mov    %rcx,(%rax)
  800621:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800625:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800629:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80062d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800631:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800638:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80063f:	48 89 d6             	mov    %rdx,%rsi
  800642:	48 89 c7             	mov    %rax,%rdi
  800645:	48 b8 db 04 80 00 00 	movabs $0x8004db,%rax
  80064c:	00 00 00 
  80064f:	ff d0                	callq  *%rax
  800651:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800657:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80065d:	c9                   	leaveq 
  80065e:	c3                   	retq   

000000000080065f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80065f:	55                   	push   %rbp
  800660:	48 89 e5             	mov    %rsp,%rbp
  800663:	53                   	push   %rbx
  800664:	48 83 ec 38          	sub    $0x38,%rsp
  800668:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80066c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800670:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800674:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800677:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80067b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80067f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800682:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800686:	77 3b                	ja     8006c3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800688:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80068b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80068f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800696:	ba 00 00 00 00       	mov    $0x0,%edx
  80069b:	48 f7 f3             	div    %rbx
  80069e:	48 89 c2             	mov    %rax,%rdx
  8006a1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006a4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006a7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006af:	41 89 f9             	mov    %edi,%r9d
  8006b2:	48 89 c7             	mov    %rax,%rdi
  8006b5:	48 b8 5f 06 80 00 00 	movabs $0x80065f,%rax
  8006bc:	00 00 00 
  8006bf:	ff d0                	callq  *%rax
  8006c1:	eb 1e                	jmp    8006e1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006c3:	eb 12                	jmp    8006d7 <printnum+0x78>
			putch(padc, putdat);
  8006c5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006c9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8006cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d0:	48 89 ce             	mov    %rcx,%rsi
  8006d3:	89 d7                	mov    %edx,%edi
  8006d5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8006db:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8006df:	7f e4                	jg     8006c5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006e1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ed:	48 f7 f1             	div    %rcx
  8006f0:	48 89 d0             	mov    %rdx,%rax
  8006f3:	48 ba 90 52 80 00 00 	movabs $0x805290,%rdx
  8006fa:	00 00 00 
  8006fd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800701:	0f be d0             	movsbl %al,%edx
  800704:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	48 89 ce             	mov    %rcx,%rsi
  80070f:	89 d7                	mov    %edx,%edi
  800711:	ff d0                	callq  *%rax
}
  800713:	48 83 c4 38          	add    $0x38,%rsp
  800717:	5b                   	pop    %rbx
  800718:	5d                   	pop    %rbp
  800719:	c3                   	retq   

000000000080071a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80071a:	55                   	push   %rbp
  80071b:	48 89 e5             	mov    %rsp,%rbp
  80071e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800722:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800726:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800729:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80072d:	7e 52                	jle    800781 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80072f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800733:	8b 00                	mov    (%rax),%eax
  800735:	83 f8 30             	cmp    $0x30,%eax
  800738:	73 24                	jae    80075e <getuint+0x44>
  80073a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800746:	8b 00                	mov    (%rax),%eax
  800748:	89 c0                	mov    %eax,%eax
  80074a:	48 01 d0             	add    %rdx,%rax
  80074d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800751:	8b 12                	mov    (%rdx),%edx
  800753:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800756:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075a:	89 0a                	mov    %ecx,(%rdx)
  80075c:	eb 17                	jmp    800775 <getuint+0x5b>
  80075e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800762:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800766:	48 89 d0             	mov    %rdx,%rax
  800769:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800771:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800775:	48 8b 00             	mov    (%rax),%rax
  800778:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077c:	e9 a3 00 00 00       	jmpq   800824 <getuint+0x10a>
	else if (lflag)
  800781:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800785:	74 4f                	je     8007d6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078b:	8b 00                	mov    (%rax),%eax
  80078d:	83 f8 30             	cmp    $0x30,%eax
  800790:	73 24                	jae    8007b6 <getuint+0x9c>
  800792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800796:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80079a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079e:	8b 00                	mov    (%rax),%eax
  8007a0:	89 c0                	mov    %eax,%eax
  8007a2:	48 01 d0             	add    %rdx,%rax
  8007a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a9:	8b 12                	mov    (%rdx),%edx
  8007ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b2:	89 0a                	mov    %ecx,(%rdx)
  8007b4:	eb 17                	jmp    8007cd <getuint+0xb3>
  8007b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007be:	48 89 d0             	mov    %rdx,%rax
  8007c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007cd:	48 8b 00             	mov    (%rax),%rax
  8007d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d4:	eb 4e                	jmp    800824 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8007d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007da:	8b 00                	mov    (%rax),%eax
  8007dc:	83 f8 30             	cmp    $0x30,%eax
  8007df:	73 24                	jae    800805 <getuint+0xeb>
  8007e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	8b 00                	mov    (%rax),%eax
  8007ef:	89 c0                	mov    %eax,%eax
  8007f1:	48 01 d0             	add    %rdx,%rax
  8007f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f8:	8b 12                	mov    (%rdx),%edx
  8007fa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800801:	89 0a                	mov    %ecx,(%rdx)
  800803:	eb 17                	jmp    80081c <getuint+0x102>
  800805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800809:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80080d:	48 89 d0             	mov    %rdx,%rax
  800810:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800814:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800818:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80081c:	8b 00                	mov    (%rax),%eax
  80081e:	89 c0                	mov    %eax,%eax
  800820:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800824:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800828:	c9                   	leaveq 
  800829:	c3                   	retq   

000000000080082a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082a:	55                   	push   %rbp
  80082b:	48 89 e5             	mov    %rsp,%rbp
  80082e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800832:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800836:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800839:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80083d:	7e 52                	jle    800891 <getint+0x67>
		x=va_arg(*ap, long long);
  80083f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800843:	8b 00                	mov    (%rax),%eax
  800845:	83 f8 30             	cmp    $0x30,%eax
  800848:	73 24                	jae    80086e <getint+0x44>
  80084a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800856:	8b 00                	mov    (%rax),%eax
  800858:	89 c0                	mov    %eax,%eax
  80085a:	48 01 d0             	add    %rdx,%rax
  80085d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800861:	8b 12                	mov    (%rdx),%edx
  800863:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800866:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086a:	89 0a                	mov    %ecx,(%rdx)
  80086c:	eb 17                	jmp    800885 <getint+0x5b>
  80086e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800872:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800876:	48 89 d0             	mov    %rdx,%rax
  800879:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800881:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800885:	48 8b 00             	mov    (%rax),%rax
  800888:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088c:	e9 a3 00 00 00       	jmpq   800934 <getint+0x10a>
	else if (lflag)
  800891:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800895:	74 4f                	je     8008e6 <getint+0xbc>
		x=va_arg(*ap, long);
  800897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089b:	8b 00                	mov    (%rax),%eax
  80089d:	83 f8 30             	cmp    $0x30,%eax
  8008a0:	73 24                	jae    8008c6 <getint+0x9c>
  8008a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ae:	8b 00                	mov    (%rax),%eax
  8008b0:	89 c0                	mov    %eax,%eax
  8008b2:	48 01 d0             	add    %rdx,%rax
  8008b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b9:	8b 12                	mov    (%rdx),%edx
  8008bb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c2:	89 0a                	mov    %ecx,(%rdx)
  8008c4:	eb 17                	jmp    8008dd <getint+0xb3>
  8008c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ca:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ce:	48 89 d0             	mov    %rdx,%rax
  8008d1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008dd:	48 8b 00             	mov    (%rax),%rax
  8008e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008e4:	eb 4e                	jmp    800934 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ea:	8b 00                	mov    (%rax),%eax
  8008ec:	83 f8 30             	cmp    $0x30,%eax
  8008ef:	73 24                	jae    800915 <getint+0xeb>
  8008f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	8b 00                	mov    (%rax),%eax
  8008ff:	89 c0                	mov    %eax,%eax
  800901:	48 01 d0             	add    %rdx,%rax
  800904:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800908:	8b 12                	mov    (%rdx),%edx
  80090a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80090d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800911:	89 0a                	mov    %ecx,(%rdx)
  800913:	eb 17                	jmp    80092c <getint+0x102>
  800915:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800919:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80091d:	48 89 d0             	mov    %rdx,%rax
  800920:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800924:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800928:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80092c:	8b 00                	mov    (%rax),%eax
  80092e:	48 98                	cltq   
  800930:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800934:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800938:	c9                   	leaveq 
  800939:	c3                   	retq   

000000000080093a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80093a:	55                   	push   %rbp
  80093b:	48 89 e5             	mov    %rsp,%rbp
  80093e:	41 54                	push   %r12
  800940:	53                   	push   %rbx
  800941:	48 83 ec 60          	sub    $0x60,%rsp
  800945:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800949:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80094d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800951:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800955:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800959:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80095d:	48 8b 0a             	mov    (%rdx),%rcx
  800960:	48 89 08             	mov    %rcx,(%rax)
  800963:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800967:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80096b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80096f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800973:	eb 17                	jmp    80098c <vprintfmt+0x52>
			if (ch == '\0')
  800975:	85 db                	test   %ebx,%ebx
  800977:	0f 84 cc 04 00 00    	je     800e49 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80097d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800981:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800985:	48 89 d6             	mov    %rdx,%rsi
  800988:	89 df                	mov    %ebx,%edi
  80098a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80098c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800990:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800994:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800998:	0f b6 00             	movzbl (%rax),%eax
  80099b:	0f b6 d8             	movzbl %al,%ebx
  80099e:	83 fb 25             	cmp    $0x25,%ebx
  8009a1:	75 d2                	jne    800975 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009a3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009a7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009bc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009c3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009cb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009cf:	0f b6 00             	movzbl (%rax),%eax
  8009d2:	0f b6 d8             	movzbl %al,%ebx
  8009d5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009d8:	83 f8 55             	cmp    $0x55,%eax
  8009db:	0f 87 34 04 00 00    	ja     800e15 <vprintfmt+0x4db>
  8009e1:	89 c0                	mov    %eax,%eax
  8009e3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009ea:	00 
  8009eb:	48 b8 b8 52 80 00 00 	movabs $0x8052b8,%rax
  8009f2:	00 00 00 
  8009f5:	48 01 d0             	add    %rdx,%rax
  8009f8:	48 8b 00             	mov    (%rax),%rax
  8009fb:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009fd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a01:	eb c0                	jmp    8009c3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a03:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a07:	eb ba                	jmp    8009c3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a09:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a10:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a13:	89 d0                	mov    %edx,%eax
  800a15:	c1 e0 02             	shl    $0x2,%eax
  800a18:	01 d0                	add    %edx,%eax
  800a1a:	01 c0                	add    %eax,%eax
  800a1c:	01 d8                	add    %ebx,%eax
  800a1e:	83 e8 30             	sub    $0x30,%eax
  800a21:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a24:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a28:	0f b6 00             	movzbl (%rax),%eax
  800a2b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a2e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a31:	7e 0c                	jle    800a3f <vprintfmt+0x105>
  800a33:	83 fb 39             	cmp    $0x39,%ebx
  800a36:	7f 07                	jg     800a3f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a38:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3d:	eb d1                	jmp    800a10 <vprintfmt+0xd6>
			goto process_precision;
  800a3f:	eb 58                	jmp    800a99 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a44:	83 f8 30             	cmp    $0x30,%eax
  800a47:	73 17                	jae    800a60 <vprintfmt+0x126>
  800a49:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a50:	89 c0                	mov    %eax,%eax
  800a52:	48 01 d0             	add    %rdx,%rax
  800a55:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a58:	83 c2 08             	add    $0x8,%edx
  800a5b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a5e:	eb 0f                	jmp    800a6f <vprintfmt+0x135>
  800a60:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a64:	48 89 d0             	mov    %rdx,%rax
  800a67:	48 83 c2 08          	add    $0x8,%rdx
  800a6b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a6f:	8b 00                	mov    (%rax),%eax
  800a71:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a74:	eb 23                	jmp    800a99 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a76:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a7a:	79 0c                	jns    800a88 <vprintfmt+0x14e>
				width = 0;
  800a7c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a83:	e9 3b ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>
  800a88:	e9 36 ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a8d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a94:	e9 2a ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a99:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a9d:	79 12                	jns    800ab1 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a9f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800aa2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800aa5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800aac:	e9 12 ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>
  800ab1:	e9 0d ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ab6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800aba:	e9 04 ff ff ff       	jmpq   8009c3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800abf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac2:	83 f8 30             	cmp    $0x30,%eax
  800ac5:	73 17                	jae    800ade <vprintfmt+0x1a4>
  800ac7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800acb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ace:	89 c0                	mov    %eax,%eax
  800ad0:	48 01 d0             	add    %rdx,%rax
  800ad3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad6:	83 c2 08             	add    $0x8,%edx
  800ad9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800adc:	eb 0f                	jmp    800aed <vprintfmt+0x1b3>
  800ade:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae2:	48 89 d0             	mov    %rdx,%rax
  800ae5:	48 83 c2 08          	add    $0x8,%rdx
  800ae9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aed:	8b 10                	mov    (%rax),%edx
  800aef:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800af3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af7:	48 89 ce             	mov    %rcx,%rsi
  800afa:	89 d7                	mov    %edx,%edi
  800afc:	ff d0                	callq  *%rax
			break;
  800afe:	e9 40 03 00 00       	jmpq   800e43 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b06:	83 f8 30             	cmp    $0x30,%eax
  800b09:	73 17                	jae    800b22 <vprintfmt+0x1e8>
  800b0b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b12:	89 c0                	mov    %eax,%eax
  800b14:	48 01 d0             	add    %rdx,%rax
  800b17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1a:	83 c2 08             	add    $0x8,%edx
  800b1d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b20:	eb 0f                	jmp    800b31 <vprintfmt+0x1f7>
  800b22:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b26:	48 89 d0             	mov    %rdx,%rax
  800b29:	48 83 c2 08          	add    $0x8,%rdx
  800b2d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b31:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b33:	85 db                	test   %ebx,%ebx
  800b35:	79 02                	jns    800b39 <vprintfmt+0x1ff>
				err = -err;
  800b37:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b39:	83 fb 15             	cmp    $0x15,%ebx
  800b3c:	7f 16                	jg     800b54 <vprintfmt+0x21a>
  800b3e:	48 b8 e0 51 80 00 00 	movabs $0x8051e0,%rax
  800b45:	00 00 00 
  800b48:	48 63 d3             	movslq %ebx,%rdx
  800b4b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b4f:	4d 85 e4             	test   %r12,%r12
  800b52:	75 2e                	jne    800b82 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b54:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5c:	89 d9                	mov    %ebx,%ecx
  800b5e:	48 ba a1 52 80 00 00 	movabs $0x8052a1,%rdx
  800b65:	00 00 00 
  800b68:	48 89 c7             	mov    %rax,%rdi
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b70:	49 b8 52 0e 80 00 00 	movabs $0x800e52,%r8
  800b77:	00 00 00 
  800b7a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b7d:	e9 c1 02 00 00       	jmpq   800e43 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b82:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8a:	4c 89 e1             	mov    %r12,%rcx
  800b8d:	48 ba aa 52 80 00 00 	movabs $0x8052aa,%rdx
  800b94:	00 00 00 
  800b97:	48 89 c7             	mov    %rax,%rdi
  800b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9f:	49 b8 52 0e 80 00 00 	movabs $0x800e52,%r8
  800ba6:	00 00 00 
  800ba9:	41 ff d0             	callq  *%r8
			break;
  800bac:	e9 92 02 00 00       	jmpq   800e43 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb4:	83 f8 30             	cmp    $0x30,%eax
  800bb7:	73 17                	jae    800bd0 <vprintfmt+0x296>
  800bb9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc0:	89 c0                	mov    %eax,%eax
  800bc2:	48 01 d0             	add    %rdx,%rax
  800bc5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bc8:	83 c2 08             	add    $0x8,%edx
  800bcb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bce:	eb 0f                	jmp    800bdf <vprintfmt+0x2a5>
  800bd0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd4:	48 89 d0             	mov    %rdx,%rax
  800bd7:	48 83 c2 08          	add    $0x8,%rdx
  800bdb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bdf:	4c 8b 20             	mov    (%rax),%r12
  800be2:	4d 85 e4             	test   %r12,%r12
  800be5:	75 0a                	jne    800bf1 <vprintfmt+0x2b7>
				p = "(null)";
  800be7:	49 bc ad 52 80 00 00 	movabs $0x8052ad,%r12
  800bee:	00 00 00 
			if (width > 0 && padc != '-')
  800bf1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf5:	7e 3f                	jle    800c36 <vprintfmt+0x2fc>
  800bf7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bfb:	74 39                	je     800c36 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bfd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c00:	48 98                	cltq   
  800c02:	48 89 c6             	mov    %rax,%rsi
  800c05:	4c 89 e7             	mov    %r12,%rdi
  800c08:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  800c0f:	00 00 00 
  800c12:	ff d0                	callq  *%rax
  800c14:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c17:	eb 17                	jmp    800c30 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c19:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c1d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c25:	48 89 ce             	mov    %rcx,%rsi
  800c28:	89 d7                	mov    %edx,%edi
  800c2a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c2c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c30:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c34:	7f e3                	jg     800c19 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c36:	eb 37                	jmp    800c6f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c38:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c3c:	74 1e                	je     800c5c <vprintfmt+0x322>
  800c3e:	83 fb 1f             	cmp    $0x1f,%ebx
  800c41:	7e 05                	jle    800c48 <vprintfmt+0x30e>
  800c43:	83 fb 7e             	cmp    $0x7e,%ebx
  800c46:	7e 14                	jle    800c5c <vprintfmt+0x322>
					putch('?', putdat);
  800c48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c50:	48 89 d6             	mov    %rdx,%rsi
  800c53:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c58:	ff d0                	callq  *%rax
  800c5a:	eb 0f                	jmp    800c6b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c64:	48 89 d6             	mov    %rdx,%rsi
  800c67:	89 df                	mov    %ebx,%edi
  800c69:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c6b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c6f:	4c 89 e0             	mov    %r12,%rax
  800c72:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c76:	0f b6 00             	movzbl (%rax),%eax
  800c79:	0f be d8             	movsbl %al,%ebx
  800c7c:	85 db                	test   %ebx,%ebx
  800c7e:	74 10                	je     800c90 <vprintfmt+0x356>
  800c80:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c84:	78 b2                	js     800c38 <vprintfmt+0x2fe>
  800c86:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c8a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c8e:	79 a8                	jns    800c38 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c90:	eb 16                	jmp    800ca8 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c92:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9a:	48 89 d6             	mov    %rdx,%rsi
  800c9d:	bf 20 00 00 00       	mov    $0x20,%edi
  800ca2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ca4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ca8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cac:	7f e4                	jg     800c92 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800cae:	e9 90 01 00 00       	jmpq   800e43 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cb3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb7:	be 03 00 00 00       	mov    $0x3,%esi
  800cbc:	48 89 c7             	mov    %rax,%rdi
  800cbf:	48 b8 2a 08 80 00 00 	movabs $0x80082a,%rax
  800cc6:	00 00 00 
  800cc9:	ff d0                	callq  *%rax
  800ccb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ccf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd3:	48 85 c0             	test   %rax,%rax
  800cd6:	79 1d                	jns    800cf5 <vprintfmt+0x3bb>
				putch('-', putdat);
  800cd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce0:	48 89 d6             	mov    %rdx,%rsi
  800ce3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ce8:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cee:	48 f7 d8             	neg    %rax
  800cf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cf5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cfc:	e9 d5 00 00 00       	jmpq   800dd6 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d01:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d05:	be 03 00 00 00       	mov    $0x3,%esi
  800d0a:	48 89 c7             	mov    %rax,%rdi
  800d0d:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800d14:	00 00 00 
  800d17:	ff d0                	callq  *%rax
  800d19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d1d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d24:	e9 ad 00 00 00       	jmpq   800dd6 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800d29:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800d2c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d30:	89 d6                	mov    %edx,%esi
  800d32:	48 89 c7             	mov    %rax,%rdi
  800d35:	48 b8 2a 08 80 00 00 	movabs $0x80082a,%rax
  800d3c:	00 00 00 
  800d3f:	ff d0                	callq  *%rax
  800d41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d45:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d4c:	e9 85 00 00 00       	jmpq   800dd6 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800d51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d59:	48 89 d6             	mov    %rdx,%rsi
  800d5c:	bf 30 00 00 00       	mov    $0x30,%edi
  800d61:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6b:	48 89 d6             	mov    %rdx,%rsi
  800d6e:	bf 78 00 00 00       	mov    $0x78,%edi
  800d73:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d78:	83 f8 30             	cmp    $0x30,%eax
  800d7b:	73 17                	jae    800d94 <vprintfmt+0x45a>
  800d7d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d84:	89 c0                	mov    %eax,%eax
  800d86:	48 01 d0             	add    %rdx,%rax
  800d89:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d8c:	83 c2 08             	add    $0x8,%edx
  800d8f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d92:	eb 0f                	jmp    800da3 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d94:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d98:	48 89 d0             	mov    %rdx,%rax
  800d9b:	48 83 c2 08          	add    $0x8,%rdx
  800d9f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800da3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800da6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800daa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800db1:	eb 23                	jmp    800dd6 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800db3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800db7:	be 03 00 00 00       	mov    $0x3,%esi
  800dbc:	48 89 c7             	mov    %rax,%rdi
  800dbf:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800dc6:	00 00 00 
  800dc9:	ff d0                	callq  *%rax
  800dcb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800dcf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dd6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ddb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800dde:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800de1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800de5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800de9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ded:	45 89 c1             	mov    %r8d,%r9d
  800df0:	41 89 f8             	mov    %edi,%r8d
  800df3:	48 89 c7             	mov    %rax,%rdi
  800df6:	48 b8 5f 06 80 00 00 	movabs $0x80065f,%rax
  800dfd:	00 00 00 
  800e00:	ff d0                	callq  *%rax
			break;
  800e02:	eb 3f                	jmp    800e43 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0c:	48 89 d6             	mov    %rdx,%rsi
  800e0f:	89 df                	mov    %ebx,%edi
  800e11:	ff d0                	callq  *%rax
			break;
  800e13:	eb 2e                	jmp    800e43 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1d:	48 89 d6             	mov    %rdx,%rsi
  800e20:	bf 25 00 00 00       	mov    $0x25,%edi
  800e25:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e27:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e2c:	eb 05                	jmp    800e33 <vprintfmt+0x4f9>
  800e2e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e33:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e37:	48 83 e8 01          	sub    $0x1,%rax
  800e3b:	0f b6 00             	movzbl (%rax),%eax
  800e3e:	3c 25                	cmp    $0x25,%al
  800e40:	75 ec                	jne    800e2e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e42:	90                   	nop
		}
	}
  800e43:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e44:	e9 43 fb ff ff       	jmpq   80098c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e49:	48 83 c4 60          	add    $0x60,%rsp
  800e4d:	5b                   	pop    %rbx
  800e4e:	41 5c                	pop    %r12
  800e50:	5d                   	pop    %rbp
  800e51:	c3                   	retq   

0000000000800e52 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e52:	55                   	push   %rbp
  800e53:	48 89 e5             	mov    %rsp,%rbp
  800e56:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e5d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e64:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e6b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e72:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e79:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e80:	84 c0                	test   %al,%al
  800e82:	74 20                	je     800ea4 <printfmt+0x52>
  800e84:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e88:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e8c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e90:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e94:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e98:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e9c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ea0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ea4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800eab:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eb2:	00 00 00 
  800eb5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ebc:	00 00 00 
  800ebf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ec3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800eca:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ed1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ed8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800edf:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ee6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800eed:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ef4:	48 89 c7             	mov    %rax,%rdi
  800ef7:	48 b8 3a 09 80 00 00 	movabs $0x80093a,%rax
  800efe:	00 00 00 
  800f01:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f03:	c9                   	leaveq 
  800f04:	c3                   	retq   

0000000000800f05 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f05:	55                   	push   %rbp
  800f06:	48 89 e5             	mov    %rsp,%rbp
  800f09:	48 83 ec 10          	sub    $0x10,%rsp
  800f0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f18:	8b 40 10             	mov    0x10(%rax),%eax
  800f1b:	8d 50 01             	lea    0x1(%rax),%edx
  800f1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f22:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f29:	48 8b 10             	mov    (%rax),%rdx
  800f2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f30:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f34:	48 39 c2             	cmp    %rax,%rdx
  800f37:	73 17                	jae    800f50 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f3d:	48 8b 00             	mov    (%rax),%rax
  800f40:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f48:	48 89 0a             	mov    %rcx,(%rdx)
  800f4b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f4e:	88 10                	mov    %dl,(%rax)
}
  800f50:	c9                   	leaveq 
  800f51:	c3                   	retq   

0000000000800f52 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f52:	55                   	push   %rbp
  800f53:	48 89 e5             	mov    %rsp,%rbp
  800f56:	48 83 ec 50          	sub    $0x50,%rsp
  800f5a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f5e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f61:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f65:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f69:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f6d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f71:	48 8b 0a             	mov    (%rdx),%rcx
  800f74:	48 89 08             	mov    %rcx,(%rax)
  800f77:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f7b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f7f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f83:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f87:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f8b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f8f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f92:	48 98                	cltq   
  800f94:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f98:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f9c:	48 01 d0             	add    %rdx,%rax
  800f9f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fa3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800faa:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800faf:	74 06                	je     800fb7 <vsnprintf+0x65>
  800fb1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fb5:	7f 07                	jg     800fbe <vsnprintf+0x6c>
		return -E_INVAL;
  800fb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fbc:	eb 2f                	jmp    800fed <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fbe:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fc2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fc6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fca:	48 89 c6             	mov    %rax,%rsi
  800fcd:	48 bf 05 0f 80 00 00 	movabs $0x800f05,%rdi
  800fd4:	00 00 00 
  800fd7:	48 b8 3a 09 80 00 00 	movabs $0x80093a,%rax
  800fde:	00 00 00 
  800fe1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fe3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fe7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fea:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fed:	c9                   	leaveq 
  800fee:	c3                   	retq   

0000000000800fef <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fef:	55                   	push   %rbp
  800ff0:	48 89 e5             	mov    %rsp,%rbp
  800ff3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ffa:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801001:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801007:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80100e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801015:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80101c:	84 c0                	test   %al,%al
  80101e:	74 20                	je     801040 <snprintf+0x51>
  801020:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801024:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801028:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80102c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801030:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801034:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801038:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80103c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801040:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801047:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80104e:	00 00 00 
  801051:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801058:	00 00 00 
  80105b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80105f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801066:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80106d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801074:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80107b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801082:	48 8b 0a             	mov    (%rdx),%rcx
  801085:	48 89 08             	mov    %rcx,(%rax)
  801088:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80108c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801090:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801094:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801098:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80109f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010a6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010ac:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010b3:	48 89 c7             	mov    %rax,%rdi
  8010b6:	48 b8 52 0f 80 00 00 	movabs $0x800f52,%rax
  8010bd:	00 00 00 
  8010c0:	ff d0                	callq  *%rax
  8010c2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010c8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010ce:	c9                   	leaveq 
  8010cf:	c3                   	retq   

00000000008010d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010d0:	55                   	push   %rbp
  8010d1:	48 89 e5             	mov    %rsp,%rbp
  8010d4:	48 83 ec 18          	sub    $0x18,%rsp
  8010d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010e3:	eb 09                	jmp    8010ee <strlen+0x1e>
		n++;
  8010e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	0f b6 00             	movzbl (%rax),%eax
  8010f5:	84 c0                	test   %al,%al
  8010f7:	75 ec                	jne    8010e5 <strlen+0x15>
		n++;
	return n;
  8010f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010fc:	c9                   	leaveq 
  8010fd:	c3                   	retq   

00000000008010fe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	48 83 ec 20          	sub    $0x20,%rsp
  801106:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80110e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801115:	eb 0e                	jmp    801125 <strnlen+0x27>
		n++;
  801117:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801120:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801125:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80112a:	74 0b                	je     801137 <strnlen+0x39>
  80112c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801130:	0f b6 00             	movzbl (%rax),%eax
  801133:	84 c0                	test   %al,%al
  801135:	75 e0                	jne    801117 <strnlen+0x19>
		n++;
	return n;
  801137:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80113a:	c9                   	leaveq 
  80113b:	c3                   	retq   

000000000080113c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80113c:	55                   	push   %rbp
  80113d:	48 89 e5             	mov    %rsp,%rbp
  801140:	48 83 ec 20          	sub    $0x20,%rsp
  801144:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801148:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80114c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801154:	90                   	nop
  801155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801159:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80115d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801161:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801165:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801169:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80116d:	0f b6 12             	movzbl (%rdx),%edx
  801170:	88 10                	mov    %dl,(%rax)
  801172:	0f b6 00             	movzbl (%rax),%eax
  801175:	84 c0                	test   %al,%al
  801177:	75 dc                	jne    801155 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801179:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80117d:	c9                   	leaveq 
  80117e:	c3                   	retq   

000000000080117f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80117f:	55                   	push   %rbp
  801180:	48 89 e5             	mov    %rsp,%rbp
  801183:	48 83 ec 20          	sub    $0x20,%rsp
  801187:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80118f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801193:	48 89 c7             	mov    %rax,%rdi
  801196:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  80119d:	00 00 00 
  8011a0:	ff d0                	callq  *%rax
  8011a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011a8:	48 63 d0             	movslq %eax,%rdx
  8011ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011af:	48 01 c2             	add    %rax,%rdx
  8011b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b6:	48 89 c6             	mov    %rax,%rsi
  8011b9:	48 89 d7             	mov    %rdx,%rdi
  8011bc:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  8011c3:	00 00 00 
  8011c6:	ff d0                	callq  *%rax
	return dst;
  8011c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011cc:	c9                   	leaveq 
  8011cd:	c3                   	retq   

00000000008011ce <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011ce:	55                   	push   %rbp
  8011cf:	48 89 e5             	mov    %rsp,%rbp
  8011d2:	48 83 ec 28          	sub    $0x28,%rsp
  8011d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011ea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011f1:	00 
  8011f2:	eb 2a                	jmp    80121e <strncpy+0x50>
		*dst++ = *src;
  8011f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801200:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801204:	0f b6 12             	movzbl (%rdx),%edx
  801207:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801209:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120d:	0f b6 00             	movzbl (%rax),%eax
  801210:	84 c0                	test   %al,%al
  801212:	74 05                	je     801219 <strncpy+0x4b>
			src++;
  801214:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801219:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80121e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801222:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801226:	72 cc                	jb     8011f4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80122c:	c9                   	leaveq 
  80122d:	c3                   	retq   

000000000080122e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80122e:	55                   	push   %rbp
  80122f:	48 89 e5             	mov    %rsp,%rbp
  801232:	48 83 ec 28          	sub    $0x28,%rsp
  801236:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80123a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80123e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801246:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80124a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80124f:	74 3d                	je     80128e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801251:	eb 1d                	jmp    801270 <strlcpy+0x42>
			*dst++ = *src++;
  801253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801257:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80125b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80125f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801263:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801267:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80126b:	0f b6 12             	movzbl (%rdx),%edx
  80126e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801270:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801275:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80127a:	74 0b                	je     801287 <strlcpy+0x59>
  80127c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801280:	0f b6 00             	movzbl (%rax),%eax
  801283:	84 c0                	test   %al,%al
  801285:	75 cc                	jne    801253 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80128e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801292:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801296:	48 29 c2             	sub    %rax,%rdx
  801299:	48 89 d0             	mov    %rdx,%rax
}
  80129c:	c9                   	leaveq 
  80129d:	c3                   	retq   

000000000080129e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80129e:	55                   	push   %rbp
  80129f:	48 89 e5             	mov    %rsp,%rbp
  8012a2:	48 83 ec 10          	sub    $0x10,%rsp
  8012a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012ae:	eb 0a                	jmp    8012ba <strcmp+0x1c>
		p++, q++;
  8012b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012be:	0f b6 00             	movzbl (%rax),%eax
  8012c1:	84 c0                	test   %al,%al
  8012c3:	74 12                	je     8012d7 <strcmp+0x39>
  8012c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c9:	0f b6 10             	movzbl (%rax),%edx
  8012cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d0:	0f b6 00             	movzbl (%rax),%eax
  8012d3:	38 c2                	cmp    %al,%dl
  8012d5:	74 d9                	je     8012b0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012db:	0f b6 00             	movzbl (%rax),%eax
  8012de:	0f b6 d0             	movzbl %al,%edx
  8012e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e5:	0f b6 00             	movzbl (%rax),%eax
  8012e8:	0f b6 c0             	movzbl %al,%eax
  8012eb:	29 c2                	sub    %eax,%edx
  8012ed:	89 d0                	mov    %edx,%eax
}
  8012ef:	c9                   	leaveq 
  8012f0:	c3                   	retq   

00000000008012f1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012f1:	55                   	push   %rbp
  8012f2:	48 89 e5             	mov    %rsp,%rbp
  8012f5:	48 83 ec 18          	sub    $0x18,%rsp
  8012f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801301:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801305:	eb 0f                	jmp    801316 <strncmp+0x25>
		n--, p++, q++;
  801307:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80130c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801311:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801316:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80131b:	74 1d                	je     80133a <strncmp+0x49>
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801321:	0f b6 00             	movzbl (%rax),%eax
  801324:	84 c0                	test   %al,%al
  801326:	74 12                	je     80133a <strncmp+0x49>
  801328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132c:	0f b6 10             	movzbl (%rax),%edx
  80132f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801333:	0f b6 00             	movzbl (%rax),%eax
  801336:	38 c2                	cmp    %al,%dl
  801338:	74 cd                	je     801307 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80133a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80133f:	75 07                	jne    801348 <strncmp+0x57>
		return 0;
  801341:	b8 00 00 00 00       	mov    $0x0,%eax
  801346:	eb 18                	jmp    801360 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	0f b6 00             	movzbl (%rax),%eax
  80134f:	0f b6 d0             	movzbl %al,%edx
  801352:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	29 c2                	sub    %eax,%edx
  80135e:	89 d0                	mov    %edx,%eax
}
  801360:	c9                   	leaveq 
  801361:	c3                   	retq   

0000000000801362 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801362:	55                   	push   %rbp
  801363:	48 89 e5             	mov    %rsp,%rbp
  801366:	48 83 ec 0c          	sub    $0xc,%rsp
  80136a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136e:	89 f0                	mov    %esi,%eax
  801370:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801373:	eb 17                	jmp    80138c <strchr+0x2a>
		if (*s == c)
  801375:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801379:	0f b6 00             	movzbl (%rax),%eax
  80137c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80137f:	75 06                	jne    801387 <strchr+0x25>
			return (char *) s;
  801381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801385:	eb 15                	jmp    80139c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801387:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80138c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801390:	0f b6 00             	movzbl (%rax),%eax
  801393:	84 c0                	test   %al,%al
  801395:	75 de                	jne    801375 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801397:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80139c:	c9                   	leaveq 
  80139d:	c3                   	retq   

000000000080139e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80139e:	55                   	push   %rbp
  80139f:	48 89 e5             	mov    %rsp,%rbp
  8013a2:	48 83 ec 0c          	sub    $0xc,%rsp
  8013a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013aa:	89 f0                	mov    %esi,%eax
  8013ac:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013af:	eb 13                	jmp    8013c4 <strfind+0x26>
		if (*s == c)
  8013b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b5:	0f b6 00             	movzbl (%rax),%eax
  8013b8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013bb:	75 02                	jne    8013bf <strfind+0x21>
			break;
  8013bd:	eb 10                	jmp    8013cf <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c8:	0f b6 00             	movzbl (%rax),%eax
  8013cb:	84 c0                	test   %al,%al
  8013cd:	75 e2                	jne    8013b1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013d3:	c9                   	leaveq 
  8013d4:	c3                   	retq   

00000000008013d5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013d5:	55                   	push   %rbp
  8013d6:	48 89 e5             	mov    %rsp,%rbp
  8013d9:	48 83 ec 18          	sub    $0x18,%rsp
  8013dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ed:	75 06                	jne    8013f5 <memset+0x20>
		return v;
  8013ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f3:	eb 69                	jmp    80145e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f9:	83 e0 03             	and    $0x3,%eax
  8013fc:	48 85 c0             	test   %rax,%rax
  8013ff:	75 48                	jne    801449 <memset+0x74>
  801401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801405:	83 e0 03             	and    $0x3,%eax
  801408:	48 85 c0             	test   %rax,%rax
  80140b:	75 3c                	jne    801449 <memset+0x74>
		c &= 0xFF;
  80140d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801414:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801417:	c1 e0 18             	shl    $0x18,%eax
  80141a:	89 c2                	mov    %eax,%edx
  80141c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80141f:	c1 e0 10             	shl    $0x10,%eax
  801422:	09 c2                	or     %eax,%edx
  801424:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801427:	c1 e0 08             	shl    $0x8,%eax
  80142a:	09 d0                	or     %edx,%eax
  80142c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80142f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801433:	48 c1 e8 02          	shr    $0x2,%rax
  801437:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80143a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80143e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801441:	48 89 d7             	mov    %rdx,%rdi
  801444:	fc                   	cld    
  801445:	f3 ab                	rep stos %eax,%es:(%rdi)
  801447:	eb 11                	jmp    80145a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801449:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80144d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801450:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801454:	48 89 d7             	mov    %rdx,%rdi
  801457:	fc                   	cld    
  801458:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80145a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80145e:	c9                   	leaveq 
  80145f:	c3                   	retq   

0000000000801460 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801460:	55                   	push   %rbp
  801461:	48 89 e5             	mov    %rsp,%rbp
  801464:	48 83 ec 28          	sub    $0x28,%rsp
  801468:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801470:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801474:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801478:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80147c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801480:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801484:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801488:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80148c:	0f 83 88 00 00 00    	jae    80151a <memmove+0xba>
  801492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801496:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80149a:	48 01 d0             	add    %rdx,%rax
  80149d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014a1:	76 77                	jbe    80151a <memmove+0xba>
		s += n;
  8014a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014af:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b7:	83 e0 03             	and    $0x3,%eax
  8014ba:	48 85 c0             	test   %rax,%rax
  8014bd:	75 3b                	jne    8014fa <memmove+0x9a>
  8014bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c3:	83 e0 03             	and    $0x3,%eax
  8014c6:	48 85 c0             	test   %rax,%rax
  8014c9:	75 2f                	jne    8014fa <memmove+0x9a>
  8014cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cf:	83 e0 03             	and    $0x3,%eax
  8014d2:	48 85 c0             	test   %rax,%rax
  8014d5:	75 23                	jne    8014fa <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014db:	48 83 e8 04          	sub    $0x4,%rax
  8014df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e3:	48 83 ea 04          	sub    $0x4,%rdx
  8014e7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014eb:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014ef:	48 89 c7             	mov    %rax,%rdi
  8014f2:	48 89 d6             	mov    %rdx,%rsi
  8014f5:	fd                   	std    
  8014f6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014f8:	eb 1d                	jmp    801517 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801502:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801506:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80150a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150e:	48 89 d7             	mov    %rdx,%rdi
  801511:	48 89 c1             	mov    %rax,%rcx
  801514:	fd                   	std    
  801515:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801517:	fc                   	cld    
  801518:	eb 57                	jmp    801571 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80151a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151e:	83 e0 03             	and    $0x3,%eax
  801521:	48 85 c0             	test   %rax,%rax
  801524:	75 36                	jne    80155c <memmove+0xfc>
  801526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152a:	83 e0 03             	and    $0x3,%eax
  80152d:	48 85 c0             	test   %rax,%rax
  801530:	75 2a                	jne    80155c <memmove+0xfc>
  801532:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801536:	83 e0 03             	and    $0x3,%eax
  801539:	48 85 c0             	test   %rax,%rax
  80153c:	75 1e                	jne    80155c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80153e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801542:	48 c1 e8 02          	shr    $0x2,%rax
  801546:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801551:	48 89 c7             	mov    %rax,%rdi
  801554:	48 89 d6             	mov    %rdx,%rsi
  801557:	fc                   	cld    
  801558:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80155a:	eb 15                	jmp    801571 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80155c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801560:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801564:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801568:	48 89 c7             	mov    %rax,%rdi
  80156b:	48 89 d6             	mov    %rdx,%rsi
  80156e:	fc                   	cld    
  80156f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801571:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801575:	c9                   	leaveq 
  801576:	c3                   	retq   

0000000000801577 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801577:	55                   	push   %rbp
  801578:	48 89 e5             	mov    %rsp,%rbp
  80157b:	48 83 ec 18          	sub    $0x18,%rsp
  80157f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801583:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801587:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80158b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80158f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801597:	48 89 ce             	mov    %rcx,%rsi
  80159a:	48 89 c7             	mov    %rax,%rdi
  80159d:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8015a4:	00 00 00 
  8015a7:	ff d0                	callq  *%rax
}
  8015a9:	c9                   	leaveq 
  8015aa:	c3                   	retq   

00000000008015ab <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015ab:	55                   	push   %rbp
  8015ac:	48 89 e5             	mov    %rsp,%rbp
  8015af:	48 83 ec 28          	sub    $0x28,%rsp
  8015b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015cf:	eb 36                	jmp    801607 <memcmp+0x5c>
		if (*s1 != *s2)
  8015d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d5:	0f b6 10             	movzbl (%rax),%edx
  8015d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	38 c2                	cmp    %al,%dl
  8015e1:	74 1a                	je     8015fd <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	0f b6 d0             	movzbl %al,%edx
  8015ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f1:	0f b6 00             	movzbl (%rax),%eax
  8015f4:	0f b6 c0             	movzbl %al,%eax
  8015f7:	29 c2                	sub    %eax,%edx
  8015f9:	89 d0                	mov    %edx,%eax
  8015fb:	eb 20                	jmp    80161d <memcmp+0x72>
		s1++, s2++;
  8015fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801602:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801607:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80160f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801613:	48 85 c0             	test   %rax,%rax
  801616:	75 b9                	jne    8015d1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801618:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161d:	c9                   	leaveq 
  80161e:	c3                   	retq   

000000000080161f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80161f:	55                   	push   %rbp
  801620:	48 89 e5             	mov    %rsp,%rbp
  801623:	48 83 ec 28          	sub    $0x28,%rsp
  801627:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80162b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80162e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801636:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80163a:	48 01 d0             	add    %rdx,%rax
  80163d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801641:	eb 15                	jmp    801658 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801647:	0f b6 10             	movzbl (%rax),%edx
  80164a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80164d:	38 c2                	cmp    %al,%dl
  80164f:	75 02                	jne    801653 <memfind+0x34>
			break;
  801651:	eb 0f                	jmp    801662 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801653:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80165c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801660:	72 e1                	jb     801643 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801666:	c9                   	leaveq 
  801667:	c3                   	retq   

0000000000801668 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801668:	55                   	push   %rbp
  801669:	48 89 e5             	mov    %rsp,%rbp
  80166c:	48 83 ec 34          	sub    $0x34,%rsp
  801670:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801674:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801678:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80167b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801682:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801689:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80168a:	eb 05                	jmp    801691 <strtol+0x29>
		s++;
  80168c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801695:	0f b6 00             	movzbl (%rax),%eax
  801698:	3c 20                	cmp    $0x20,%al
  80169a:	74 f0                	je     80168c <strtol+0x24>
  80169c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a0:	0f b6 00             	movzbl (%rax),%eax
  8016a3:	3c 09                	cmp    $0x9,%al
  8016a5:	74 e5                	je     80168c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ab:	0f b6 00             	movzbl (%rax),%eax
  8016ae:	3c 2b                	cmp    $0x2b,%al
  8016b0:	75 07                	jne    8016b9 <strtol+0x51>
		s++;
  8016b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b7:	eb 17                	jmp    8016d0 <strtol+0x68>
	else if (*s == '-')
  8016b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bd:	0f b6 00             	movzbl (%rax),%eax
  8016c0:	3c 2d                	cmp    $0x2d,%al
  8016c2:	75 0c                	jne    8016d0 <strtol+0x68>
		s++, neg = 1;
  8016c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016d4:	74 06                	je     8016dc <strtol+0x74>
  8016d6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016da:	75 28                	jne    801704 <strtol+0x9c>
  8016dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e0:	0f b6 00             	movzbl (%rax),%eax
  8016e3:	3c 30                	cmp    $0x30,%al
  8016e5:	75 1d                	jne    801704 <strtol+0x9c>
  8016e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016eb:	48 83 c0 01          	add    $0x1,%rax
  8016ef:	0f b6 00             	movzbl (%rax),%eax
  8016f2:	3c 78                	cmp    $0x78,%al
  8016f4:	75 0e                	jne    801704 <strtol+0x9c>
		s += 2, base = 16;
  8016f6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016fb:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801702:	eb 2c                	jmp    801730 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801704:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801708:	75 19                	jne    801723 <strtol+0xbb>
  80170a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170e:	0f b6 00             	movzbl (%rax),%eax
  801711:	3c 30                	cmp    $0x30,%al
  801713:	75 0e                	jne    801723 <strtol+0xbb>
		s++, base = 8;
  801715:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80171a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801721:	eb 0d                	jmp    801730 <strtol+0xc8>
	else if (base == 0)
  801723:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801727:	75 07                	jne    801730 <strtol+0xc8>
		base = 10;
  801729:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801734:	0f b6 00             	movzbl (%rax),%eax
  801737:	3c 2f                	cmp    $0x2f,%al
  801739:	7e 1d                	jle    801758 <strtol+0xf0>
  80173b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173f:	0f b6 00             	movzbl (%rax),%eax
  801742:	3c 39                	cmp    $0x39,%al
  801744:	7f 12                	jg     801758 <strtol+0xf0>
			dig = *s - '0';
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	0f b6 00             	movzbl (%rax),%eax
  80174d:	0f be c0             	movsbl %al,%eax
  801750:	83 e8 30             	sub    $0x30,%eax
  801753:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801756:	eb 4e                	jmp    8017a6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	0f b6 00             	movzbl (%rax),%eax
  80175f:	3c 60                	cmp    $0x60,%al
  801761:	7e 1d                	jle    801780 <strtol+0x118>
  801763:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801767:	0f b6 00             	movzbl (%rax),%eax
  80176a:	3c 7a                	cmp    $0x7a,%al
  80176c:	7f 12                	jg     801780 <strtol+0x118>
			dig = *s - 'a' + 10;
  80176e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801772:	0f b6 00             	movzbl (%rax),%eax
  801775:	0f be c0             	movsbl %al,%eax
  801778:	83 e8 57             	sub    $0x57,%eax
  80177b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80177e:	eb 26                	jmp    8017a6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801784:	0f b6 00             	movzbl (%rax),%eax
  801787:	3c 40                	cmp    $0x40,%al
  801789:	7e 48                	jle    8017d3 <strtol+0x16b>
  80178b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178f:	0f b6 00             	movzbl (%rax),%eax
  801792:	3c 5a                	cmp    $0x5a,%al
  801794:	7f 3d                	jg     8017d3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801796:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179a:	0f b6 00             	movzbl (%rax),%eax
  80179d:	0f be c0             	movsbl %al,%eax
  8017a0:	83 e8 37             	sub    $0x37,%eax
  8017a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017a9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017ac:	7c 02                	jl     8017b0 <strtol+0x148>
			break;
  8017ae:	eb 23                	jmp    8017d3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017b8:	48 98                	cltq   
  8017ba:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017bf:	48 89 c2             	mov    %rax,%rdx
  8017c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017c5:	48 98                	cltq   
  8017c7:	48 01 d0             	add    %rdx,%rax
  8017ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017ce:	e9 5d ff ff ff       	jmpq   801730 <strtol+0xc8>

	if (endptr)
  8017d3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017d8:	74 0b                	je     8017e5 <strtol+0x17d>
		*endptr = (char *) s;
  8017da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017e2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017e9:	74 09                	je     8017f4 <strtol+0x18c>
  8017eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ef:	48 f7 d8             	neg    %rax
  8017f2:	eb 04                	jmp    8017f8 <strtol+0x190>
  8017f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017f8:	c9                   	leaveq 
  8017f9:	c3                   	retq   

00000000008017fa <strstr>:

char * strstr(const char *in, const char *str)
{
  8017fa:	55                   	push   %rbp
  8017fb:	48 89 e5             	mov    %rsp,%rbp
  8017fe:	48 83 ec 30          	sub    $0x30,%rsp
  801802:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801806:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80180a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80180e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801812:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801816:	0f b6 00             	movzbl (%rax),%eax
  801819:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80181c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801820:	75 06                	jne    801828 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801826:	eb 6b                	jmp    801893 <strstr+0x99>

	len = strlen(str);
  801828:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80182c:	48 89 c7             	mov    %rax,%rdi
  80182f:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  801836:	00 00 00 
  801839:	ff d0                	callq  *%rax
  80183b:	48 98                	cltq   
  80183d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801845:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801849:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80184d:	0f b6 00             	movzbl (%rax),%eax
  801850:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801853:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801857:	75 07                	jne    801860 <strstr+0x66>
				return (char *) 0;
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
  80185e:	eb 33                	jmp    801893 <strstr+0x99>
		} while (sc != c);
  801860:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801864:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801867:	75 d8                	jne    801841 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801869:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80186d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	48 89 ce             	mov    %rcx,%rsi
  801878:	48 89 c7             	mov    %rax,%rdi
  80187b:	48 b8 f1 12 80 00 00 	movabs $0x8012f1,%rax
  801882:	00 00 00 
  801885:	ff d0                	callq  *%rax
  801887:	85 c0                	test   %eax,%eax
  801889:	75 b6                	jne    801841 <strstr+0x47>

	return (char *) (in - 1);
  80188b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188f:	48 83 e8 01          	sub    $0x1,%rax
}
  801893:	c9                   	leaveq 
  801894:	c3                   	retq   

0000000000801895 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801895:	55                   	push   %rbp
  801896:	48 89 e5             	mov    %rsp,%rbp
  801899:	53                   	push   %rbx
  80189a:	48 83 ec 48          	sub    $0x48,%rsp
  80189e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018a1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018a4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018a8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018ac:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018b0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018b7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018bb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018bf:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018c3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018c7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018cb:	4c 89 c3             	mov    %r8,%rbx
  8018ce:	cd 30                	int    $0x30
  8018d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018d4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018d8:	74 3e                	je     801918 <syscall+0x83>
  8018da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018df:	7e 37                	jle    801918 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018e8:	49 89 d0             	mov    %rdx,%r8
  8018eb:	89 c1                	mov    %eax,%ecx
  8018ed:	48 ba 68 55 80 00 00 	movabs $0x805568,%rdx
  8018f4:	00 00 00 
  8018f7:	be 23 00 00 00       	mov    $0x23,%esi
  8018fc:	48 bf 85 55 80 00 00 	movabs $0x805585,%rdi
  801903:	00 00 00 
  801906:	b8 00 00 00 00       	mov    $0x0,%eax
  80190b:	49 b9 4e 03 80 00 00 	movabs $0x80034e,%r9
  801912:	00 00 00 
  801915:	41 ff d1             	callq  *%r9

	return ret;
  801918:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80191c:	48 83 c4 48          	add    $0x48,%rsp
  801920:	5b                   	pop    %rbx
  801921:	5d                   	pop    %rbp
  801922:	c3                   	retq   

0000000000801923 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801923:	55                   	push   %rbp
  801924:	48 89 e5             	mov    %rsp,%rbp
  801927:	48 83 ec 20          	sub    $0x20,%rsp
  80192b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80192f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801933:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801937:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801942:	00 
  801943:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801949:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194f:	48 89 d1             	mov    %rdx,%rcx
  801952:	48 89 c2             	mov    %rax,%rdx
  801955:	be 00 00 00 00       	mov    $0x0,%esi
  80195a:	bf 00 00 00 00       	mov    $0x0,%edi
  80195f:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801966:	00 00 00 
  801969:	ff d0                	callq  *%rax
}
  80196b:	c9                   	leaveq 
  80196c:	c3                   	retq   

000000000080196d <sys_cgetc>:

int
sys_cgetc(void)
{
  80196d:	55                   	push   %rbp
  80196e:	48 89 e5             	mov    %rsp,%rbp
  801971:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801975:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197c:	00 
  80197d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801983:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801989:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198e:	ba 00 00 00 00       	mov    $0x0,%edx
  801993:	be 00 00 00 00       	mov    $0x0,%esi
  801998:	bf 01 00 00 00       	mov    $0x1,%edi
  80199d:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  8019a4:	00 00 00 
  8019a7:	ff d0                	callq  *%rax
}
  8019a9:	c9                   	leaveq 
  8019aa:	c3                   	retq   

00000000008019ab <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019ab:	55                   	push   %rbp
  8019ac:	48 89 e5             	mov    %rsp,%rbp
  8019af:	48 83 ec 10          	sub    $0x10,%rsp
  8019b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b9:	48 98                	cltq   
  8019bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c2:	00 
  8019c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d4:	48 89 c2             	mov    %rax,%rdx
  8019d7:	be 01 00 00 00       	mov    $0x1,%esi
  8019dc:	bf 03 00 00 00       	mov    $0x3,%edi
  8019e1:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  8019e8:	00 00 00 
  8019eb:	ff d0                	callq  *%rax
}
  8019ed:	c9                   	leaveq 
  8019ee:	c3                   	retq   

00000000008019ef <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019ef:	55                   	push   %rbp
  8019f0:	48 89 e5             	mov    %rsp,%rbp
  8019f3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fe:	00 
  8019ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a10:	ba 00 00 00 00       	mov    $0x0,%edx
  801a15:	be 00 00 00 00       	mov    $0x0,%esi
  801a1a:	bf 02 00 00 00       	mov    $0x2,%edi
  801a1f:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801a26:	00 00 00 
  801a29:	ff d0                	callq  *%rax
}
  801a2b:	c9                   	leaveq 
  801a2c:	c3                   	retq   

0000000000801a2d <sys_yield>:

void
sys_yield(void)
{
  801a2d:	55                   	push   %rbp
  801a2e:	48 89 e5             	mov    %rsp,%rbp
  801a31:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3c:	00 
  801a3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a53:	be 00 00 00 00       	mov    $0x0,%esi
  801a58:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a5d:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801a64:	00 00 00 
  801a67:	ff d0                	callq  *%rax
}
  801a69:	c9                   	leaveq 
  801a6a:	c3                   	retq   

0000000000801a6b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a6b:	55                   	push   %rbp
  801a6c:	48 89 e5             	mov    %rsp,%rbp
  801a6f:	48 83 ec 20          	sub    $0x20,%rsp
  801a73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a7a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a80:	48 63 c8             	movslq %eax,%rcx
  801a83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8a:	48 98                	cltq   
  801a8c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a93:	00 
  801a94:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9a:	49 89 c8             	mov    %rcx,%r8
  801a9d:	48 89 d1             	mov    %rdx,%rcx
  801aa0:	48 89 c2             	mov    %rax,%rdx
  801aa3:	be 01 00 00 00       	mov    $0x1,%esi
  801aa8:	bf 04 00 00 00       	mov    $0x4,%edi
  801aad:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801ab4:	00 00 00 
  801ab7:	ff d0                	callq  *%rax
}
  801ab9:	c9                   	leaveq 
  801aba:	c3                   	retq   

0000000000801abb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801abb:	55                   	push   %rbp
  801abc:	48 89 e5             	mov    %rsp,%rbp
  801abf:	48 83 ec 30          	sub    $0x30,%rsp
  801ac3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aca:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801acd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ad1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ad5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ad8:	48 63 c8             	movslq %eax,%rcx
  801adb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801adf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ae2:	48 63 f0             	movslq %eax,%rsi
  801ae5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aec:	48 98                	cltq   
  801aee:	48 89 0c 24          	mov    %rcx,(%rsp)
  801af2:	49 89 f9             	mov    %rdi,%r9
  801af5:	49 89 f0             	mov    %rsi,%r8
  801af8:	48 89 d1             	mov    %rdx,%rcx
  801afb:	48 89 c2             	mov    %rax,%rdx
  801afe:	be 01 00 00 00       	mov    $0x1,%esi
  801b03:	bf 05 00 00 00       	mov    $0x5,%edi
  801b08:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801b0f:	00 00 00 
  801b12:	ff d0                	callq  *%rax
}
  801b14:	c9                   	leaveq 
  801b15:	c3                   	retq   

0000000000801b16 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b16:	55                   	push   %rbp
  801b17:	48 89 e5             	mov    %rsp,%rbp
  801b1a:	48 83 ec 20          	sub    $0x20,%rsp
  801b1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2c:	48 98                	cltq   
  801b2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b35:	00 
  801b36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b42:	48 89 d1             	mov    %rdx,%rcx
  801b45:	48 89 c2             	mov    %rax,%rdx
  801b48:	be 01 00 00 00       	mov    $0x1,%esi
  801b4d:	bf 06 00 00 00       	mov    $0x6,%edi
  801b52:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801b59:	00 00 00 
  801b5c:	ff d0                	callq  *%rax
}
  801b5e:	c9                   	leaveq 
  801b5f:	c3                   	retq   

0000000000801b60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b60:	55                   	push   %rbp
  801b61:	48 89 e5             	mov    %rsp,%rbp
  801b64:	48 83 ec 10          	sub    $0x10,%rsp
  801b68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b6b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b71:	48 63 d0             	movslq %eax,%rdx
  801b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b77:	48 98                	cltq   
  801b79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b80:	00 
  801b81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8d:	48 89 d1             	mov    %rdx,%rcx
  801b90:	48 89 c2             	mov    %rax,%rdx
  801b93:	be 01 00 00 00       	mov    $0x1,%esi
  801b98:	bf 08 00 00 00       	mov    $0x8,%edi
  801b9d:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801ba4:	00 00 00 
  801ba7:	ff d0                	callq  *%rax
}
  801ba9:	c9                   	leaveq 
  801baa:	c3                   	retq   

0000000000801bab <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bab:	55                   	push   %rbp
  801bac:	48 89 e5             	mov    %rsp,%rbp
  801baf:	48 83 ec 20          	sub    $0x20,%rsp
  801bb3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc1:	48 98                	cltq   
  801bc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bca:	00 
  801bcb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd7:	48 89 d1             	mov    %rdx,%rcx
  801bda:	48 89 c2             	mov    %rax,%rdx
  801bdd:	be 01 00 00 00       	mov    $0x1,%esi
  801be2:	bf 09 00 00 00       	mov    $0x9,%edi
  801be7:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801bee:	00 00 00 
  801bf1:	ff d0                	callq  *%rax
}
  801bf3:	c9                   	leaveq 
  801bf4:	c3                   	retq   

0000000000801bf5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bf5:	55                   	push   %rbp
  801bf6:	48 89 e5             	mov    %rsp,%rbp
  801bf9:	48 83 ec 20          	sub    $0x20,%rsp
  801bfd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0b:	48 98                	cltq   
  801c0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c14:	00 
  801c15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c21:	48 89 d1             	mov    %rdx,%rcx
  801c24:	48 89 c2             	mov    %rax,%rdx
  801c27:	be 01 00 00 00       	mov    $0x1,%esi
  801c2c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c31:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801c38:	00 00 00 
  801c3b:	ff d0                	callq  *%rax
}
  801c3d:	c9                   	leaveq 
  801c3e:	c3                   	retq   

0000000000801c3f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c3f:	55                   	push   %rbp
  801c40:	48 89 e5             	mov    %rsp,%rbp
  801c43:	48 83 ec 20          	sub    $0x20,%rsp
  801c47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c4e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c52:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c58:	48 63 f0             	movslq %eax,%rsi
  801c5b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c62:	48 98                	cltq   
  801c64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c68:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6f:	00 
  801c70:	49 89 f1             	mov    %rsi,%r9
  801c73:	49 89 c8             	mov    %rcx,%r8
  801c76:	48 89 d1             	mov    %rdx,%rcx
  801c79:	48 89 c2             	mov    %rax,%rdx
  801c7c:	be 00 00 00 00       	mov    $0x0,%esi
  801c81:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c86:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801c8d:	00 00 00 
  801c90:	ff d0                	callq  *%rax
}
  801c92:	c9                   	leaveq 
  801c93:	c3                   	retq   

0000000000801c94 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c94:	55                   	push   %rbp
  801c95:	48 89 e5             	mov    %rsp,%rbp
  801c98:	48 83 ec 10          	sub    $0x10,%rsp
  801c9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ca0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cab:	00 
  801cac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cbd:	48 89 c2             	mov    %rax,%rdx
  801cc0:	be 01 00 00 00       	mov    $0x1,%esi
  801cc5:	bf 0d 00 00 00       	mov    $0xd,%edi
  801cca:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801cd1:	00 00 00 
  801cd4:	ff d0                	callq  *%rax
}
  801cd6:	c9                   	leaveq 
  801cd7:	c3                   	retq   

0000000000801cd8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801cd8:	55                   	push   %rbp
  801cd9:	48 89 e5             	mov    %rsp,%rbp
  801cdc:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ce0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce7:	00 
  801ce8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cfe:	be 00 00 00 00       	mov    $0x0,%esi
  801d03:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d08:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801d0f:	00 00 00 
  801d12:	ff d0                	callq  *%rax
}
  801d14:	c9                   	leaveq 
  801d15:	c3                   	retq   

0000000000801d16 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d16:	55                   	push   %rbp
  801d17:	48 89 e5             	mov    %rsp,%rbp
  801d1a:	48 83 ec 30          	sub    $0x30,%rsp
  801d1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d25:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d28:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d2c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d30:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d33:	48 63 c8             	movslq %eax,%rcx
  801d36:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d3d:	48 63 f0             	movslq %eax,%rsi
  801d40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d47:	48 98                	cltq   
  801d49:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d4d:	49 89 f9             	mov    %rdi,%r9
  801d50:	49 89 f0             	mov    %rsi,%r8
  801d53:	48 89 d1             	mov    %rdx,%rcx
  801d56:	48 89 c2             	mov    %rax,%rdx
  801d59:	be 00 00 00 00       	mov    $0x0,%esi
  801d5e:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d63:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801d6a:	00 00 00 
  801d6d:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d6f:	c9                   	leaveq 
  801d70:	c3                   	retq   

0000000000801d71 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d71:	55                   	push   %rbp
  801d72:	48 89 e5             	mov    %rsp,%rbp
  801d75:	48 83 ec 20          	sub    $0x20,%rsp
  801d79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d90:	00 
  801d91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d9d:	48 89 d1             	mov    %rdx,%rcx
  801da0:	48 89 c2             	mov    %rax,%rdx
  801da3:	be 00 00 00 00       	mov    $0x0,%esi
  801da8:	bf 10 00 00 00       	mov    $0x10,%edi
  801dad:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801db4:	00 00 00 
  801db7:	ff d0                	callq  *%rax
}
  801db9:	c9                   	leaveq 
  801dba:	c3                   	retq   

0000000000801dbb <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801dbb:	55                   	push   %rbp
  801dbc:	48 89 e5             	mov    %rsp,%rbp
  801dbf:	48 83 ec 30          	sub    $0x30,%rsp
  801dc3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801dc7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dcb:	48 8b 00             	mov    (%rax),%rax
  801dce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801dd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd6:	48 8b 40 08          	mov    0x8(%rax),%rax
  801dda:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801ddd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801de0:	83 e0 02             	and    $0x2,%eax
  801de3:	85 c0                	test   %eax,%eax
  801de5:	75 4d                	jne    801e34 <pgfault+0x79>
  801de7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801deb:	48 c1 e8 0c          	shr    $0xc,%rax
  801def:	48 89 c2             	mov    %rax,%rdx
  801df2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801df9:	01 00 00 
  801dfc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e00:	25 00 08 00 00       	and    $0x800,%eax
  801e05:	48 85 c0             	test   %rax,%rax
  801e08:	74 2a                	je     801e34 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801e0a:	48 ba 98 55 80 00 00 	movabs $0x805598,%rdx
  801e11:	00 00 00 
  801e14:	be 23 00 00 00       	mov    $0x23,%esi
  801e19:	48 bf cd 55 80 00 00 	movabs $0x8055cd,%rdi
  801e20:	00 00 00 
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801e2f:	00 00 00 
  801e32:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801e34:	ba 07 00 00 00       	mov    $0x7,%edx
  801e39:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e3e:	bf 00 00 00 00       	mov    $0x0,%edi
  801e43:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  801e4a:	00 00 00 
  801e4d:	ff d0                	callq  *%rax
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	0f 85 cd 00 00 00    	jne    801f24 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801e57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e63:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e69:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801e6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e71:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e76:	48 89 c6             	mov    %rax,%rsi
  801e79:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e7e:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  801e85:	00 00 00 
  801e88:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801e8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e8e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e94:	48 89 c1             	mov    %rax,%rcx
  801e97:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ea1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea6:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  801ead:	00 00 00 
  801eb0:	ff d0                	callq  *%rax
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	79 2a                	jns    801ee0 <pgfault+0x125>
				panic("Page map at temp address failed");
  801eb6:	48 ba d8 55 80 00 00 	movabs $0x8055d8,%rdx
  801ebd:	00 00 00 
  801ec0:	be 30 00 00 00       	mov    $0x30,%esi
  801ec5:	48 bf cd 55 80 00 00 	movabs $0x8055cd,%rdi
  801ecc:	00 00 00 
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed4:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801edb:	00 00 00 
  801ede:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801ee0:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ee5:	bf 00 00 00 00       	mov    $0x0,%edi
  801eea:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  801ef1:	00 00 00 
  801ef4:	ff d0                	callq  *%rax
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	79 54                	jns    801f4e <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801efa:	48 ba f8 55 80 00 00 	movabs $0x8055f8,%rdx
  801f01:	00 00 00 
  801f04:	be 32 00 00 00       	mov    $0x32,%esi
  801f09:	48 bf cd 55 80 00 00 	movabs $0x8055cd,%rdi
  801f10:	00 00 00 
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801f1f:	00 00 00 
  801f22:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801f24:	48 ba 20 56 80 00 00 	movabs $0x805620,%rdx
  801f2b:	00 00 00 
  801f2e:	be 34 00 00 00       	mov    $0x34,%esi
  801f33:	48 bf cd 55 80 00 00 	movabs $0x8055cd,%rdi
  801f3a:	00 00 00 
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f42:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801f49:	00 00 00 
  801f4c:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801f4e:	c9                   	leaveq 
  801f4f:	c3                   	retq   

0000000000801f50 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f50:	55                   	push   %rbp
  801f51:	48 89 e5             	mov    %rsp,%rbp
  801f54:	48 83 ec 20          	sub    $0x20,%rsp
  801f58:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f5b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801f5e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f65:	01 00 00 
  801f68:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f6b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f6f:	25 07 0e 00 00       	and    $0xe07,%eax
  801f74:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801f77:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f7a:	48 c1 e0 0c          	shl    $0xc,%rax
  801f7e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801f82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f85:	25 00 04 00 00       	and    $0x400,%eax
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	74 57                	je     801fe5 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f8e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f91:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f95:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9c:	41 89 f0             	mov    %esi,%r8d
  801f9f:	48 89 c6             	mov    %rax,%rsi
  801fa2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa7:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  801fae:	00 00 00 
  801fb1:	ff d0                	callq  *%rax
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	0f 8e 52 01 00 00    	jle    80210d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801fbb:	48 ba 52 56 80 00 00 	movabs $0x805652,%rdx
  801fc2:	00 00 00 
  801fc5:	be 4e 00 00 00       	mov    $0x4e,%esi
  801fca:	48 bf cd 55 80 00 00 	movabs $0x8055cd,%rdi
  801fd1:	00 00 00 
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd9:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801fe0:	00 00 00 
  801fe3:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801fe5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe8:	83 e0 02             	and    $0x2,%eax
  801feb:	85 c0                	test   %eax,%eax
  801fed:	75 10                	jne    801fff <duppage+0xaf>
  801fef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff2:	25 00 08 00 00       	and    $0x800,%eax
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	0f 84 bb 00 00 00    	je     8020ba <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802002:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802007:	80 cc 08             	or     $0x8,%ah
  80200a:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80200d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802010:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802014:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802017:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80201b:	41 89 f0             	mov    %esi,%r8d
  80201e:	48 89 c6             	mov    %rax,%rsi
  802021:	bf 00 00 00 00       	mov    $0x0,%edi
  802026:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  80202d:	00 00 00 
  802030:	ff d0                	callq  *%rax
  802032:	85 c0                	test   %eax,%eax
  802034:	7e 2a                	jle    802060 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802036:	48 ba 52 56 80 00 00 	movabs $0x805652,%rdx
  80203d:	00 00 00 
  802040:	be 55 00 00 00       	mov    $0x55,%esi
  802045:	48 bf cd 55 80 00 00 	movabs $0x8055cd,%rdi
  80204c:	00 00 00 
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
  802054:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  80205b:	00 00 00 
  80205e:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802060:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802063:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80206b:	41 89 c8             	mov    %ecx,%r8d
  80206e:	48 89 d1             	mov    %rdx,%rcx
  802071:	ba 00 00 00 00       	mov    $0x0,%edx
  802076:	48 89 c6             	mov    %rax,%rsi
  802079:	bf 00 00 00 00       	mov    $0x0,%edi
  80207e:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  802085:	00 00 00 
  802088:	ff d0                	callq  *%rax
  80208a:	85 c0                	test   %eax,%eax
  80208c:	7e 2a                	jle    8020b8 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80208e:	48 ba 52 56 80 00 00 	movabs $0x805652,%rdx
  802095:	00 00 00 
  802098:	be 57 00 00 00       	mov    $0x57,%esi
  80209d:	48 bf cd 55 80 00 00 	movabs $0x8055cd,%rdi
  8020a4:	00 00 00 
  8020a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ac:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  8020b3:	00 00 00 
  8020b6:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020b8:	eb 53                	jmp    80210d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020ba:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020bd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020c1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c8:	41 89 f0             	mov    %esi,%r8d
  8020cb:	48 89 c6             	mov    %rax,%rsi
  8020ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d3:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8020da:	00 00 00 
  8020dd:	ff d0                	callq  *%rax
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	7e 2a                	jle    80210d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8020e3:	48 ba 52 56 80 00 00 	movabs $0x805652,%rdx
  8020ea:	00 00 00 
  8020ed:	be 5b 00 00 00       	mov    $0x5b,%esi
  8020f2:	48 bf cd 55 80 00 00 	movabs $0x8055cd,%rdi
  8020f9:	00 00 00 
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  802108:	00 00 00 
  80210b:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802112:	c9                   	leaveq 
  802113:	c3                   	retq   

0000000000802114 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802114:	55                   	push   %rbp
  802115:	48 89 e5             	mov    %rsp,%rbp
  802118:	48 83 ec 18          	sub    $0x18,%rsp
  80211c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802124:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802128:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80212c:	48 c1 e8 27          	shr    $0x27,%rax
  802130:	48 89 c2             	mov    %rax,%rdx
  802133:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80213a:	01 00 00 
  80213d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802141:	83 e0 01             	and    $0x1,%eax
  802144:	48 85 c0             	test   %rax,%rax
  802147:	74 51                	je     80219a <pt_is_mapped+0x86>
  802149:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80214d:	48 c1 e0 0c          	shl    $0xc,%rax
  802151:	48 c1 e8 1e          	shr    $0x1e,%rax
  802155:	48 89 c2             	mov    %rax,%rdx
  802158:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80215f:	01 00 00 
  802162:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802166:	83 e0 01             	and    $0x1,%eax
  802169:	48 85 c0             	test   %rax,%rax
  80216c:	74 2c                	je     80219a <pt_is_mapped+0x86>
  80216e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802172:	48 c1 e0 0c          	shl    $0xc,%rax
  802176:	48 c1 e8 15          	shr    $0x15,%rax
  80217a:	48 89 c2             	mov    %rax,%rdx
  80217d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802184:	01 00 00 
  802187:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80218b:	83 e0 01             	and    $0x1,%eax
  80218e:	48 85 c0             	test   %rax,%rax
  802191:	74 07                	je     80219a <pt_is_mapped+0x86>
  802193:	b8 01 00 00 00       	mov    $0x1,%eax
  802198:	eb 05                	jmp    80219f <pt_is_mapped+0x8b>
  80219a:	b8 00 00 00 00       	mov    $0x0,%eax
  80219f:	83 e0 01             	and    $0x1,%eax
}
  8021a2:	c9                   	leaveq 
  8021a3:	c3                   	retq   

00000000008021a4 <fork>:

envid_t
fork(void)
{
  8021a4:	55                   	push   %rbp
  8021a5:	48 89 e5             	mov    %rsp,%rbp
  8021a8:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8021ac:	48 bf bb 1d 80 00 00 	movabs $0x801dbb,%rdi
  8021b3:	00 00 00 
  8021b6:	48 b8 7b 48 80 00 00 	movabs $0x80487b,%rax
  8021bd:	00 00 00 
  8021c0:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8021c2:	b8 07 00 00 00       	mov    $0x7,%eax
  8021c7:	cd 30                	int    $0x30
  8021c9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8021cc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8021cf:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8021d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021d6:	79 30                	jns    802208 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8021d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021db:	89 c1                	mov    %eax,%ecx
  8021dd:	48 ba 70 56 80 00 00 	movabs $0x805670,%rdx
  8021e4:	00 00 00 
  8021e7:	be 86 00 00 00       	mov    $0x86,%esi
  8021ec:	48 bf cd 55 80 00 00 	movabs $0x8055cd,%rdi
  8021f3:	00 00 00 
  8021f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fb:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  802202:	00 00 00 
  802205:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802208:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80220c:	75 3e                	jne    80224c <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80220e:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  802215:	00 00 00 
  802218:	ff d0                	callq  *%rax
  80221a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80221f:	48 98                	cltq   
  802221:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802228:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80222f:	00 00 00 
  802232:	48 01 c2             	add    %rax,%rdx
  802235:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80223c:	00 00 00 
  80223f:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802242:	b8 00 00 00 00       	mov    $0x0,%eax
  802247:	e9 d1 01 00 00       	jmpq   80241d <fork+0x279>
	}
	uint64_t ad = 0;
  80224c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802253:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802254:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802259:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80225d:	e9 df 00 00 00       	jmpq   802341 <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802266:	48 c1 e8 27          	shr    $0x27,%rax
  80226a:	48 89 c2             	mov    %rax,%rdx
  80226d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802274:	01 00 00 
  802277:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80227b:	83 e0 01             	and    $0x1,%eax
  80227e:	48 85 c0             	test   %rax,%rax
  802281:	0f 84 9e 00 00 00    	je     802325 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80228b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80228f:	48 89 c2             	mov    %rax,%rdx
  802292:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802299:	01 00 00 
  80229c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a0:	83 e0 01             	and    $0x1,%eax
  8022a3:	48 85 c0             	test   %rax,%rax
  8022a6:	74 73                	je     80231b <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  8022a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ac:	48 c1 e8 15          	shr    $0x15,%rax
  8022b0:	48 89 c2             	mov    %rax,%rdx
  8022b3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022ba:	01 00 00 
  8022bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c1:	83 e0 01             	and    $0x1,%eax
  8022c4:	48 85 c0             	test   %rax,%rax
  8022c7:	74 48                	je     802311 <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8022c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8022d1:	48 89 c2             	mov    %rax,%rdx
  8022d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022db:	01 00 00 
  8022de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8022e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ea:	83 e0 01             	and    $0x1,%eax
  8022ed:	48 85 c0             	test   %rax,%rax
  8022f0:	74 47                	je     802339 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8022f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f6:	48 c1 e8 0c          	shr    $0xc,%rax
  8022fa:	89 c2                	mov    %eax,%edx
  8022fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022ff:	89 d6                	mov    %edx,%esi
  802301:	89 c7                	mov    %eax,%edi
  802303:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  80230a:	00 00 00 
  80230d:	ff d0                	callq  *%rax
  80230f:	eb 28                	jmp    802339 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802311:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802318:	00 
  802319:	eb 1e                	jmp    802339 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80231b:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802322:	40 
  802323:	eb 14                	jmp    802339 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802325:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802329:	48 c1 e8 27          	shr    $0x27,%rax
  80232d:	48 83 c0 01          	add    $0x1,%rax
  802331:	48 c1 e0 27          	shl    $0x27,%rax
  802335:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802339:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802340:	00 
  802341:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802348:	00 
  802349:	0f 87 13 ff ff ff    	ja     802262 <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80234f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802352:	ba 07 00 00 00       	mov    $0x7,%edx
  802357:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80235c:	89 c7                	mov    %eax,%edi
  80235e:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  802365:	00 00 00 
  802368:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80236a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80236d:	ba 07 00 00 00       	mov    $0x7,%edx
  802372:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802377:	89 c7                	mov    %eax,%edi
  802379:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  802380:	00 00 00 
  802383:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802385:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802388:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80238e:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802393:	ba 00 00 00 00       	mov    $0x0,%edx
  802398:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80239d:	89 c7                	mov    %eax,%edi
  80239f:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8023a6:	00 00 00 
  8023a9:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8023ab:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023b0:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023b5:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8023ba:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8023c1:	00 00 00 
  8023c4:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8023c6:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d0:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  8023d7:	00 00 00 
  8023da:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8023dc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023e3:	00 00 00 
  8023e6:	48 8b 00             	mov    (%rax),%rax
  8023e9:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8023f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023f3:	48 89 d6             	mov    %rdx,%rsi
  8023f6:	89 c7                	mov    %eax,%edi
  8023f8:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  8023ff:	00 00 00 
  802402:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802404:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802407:	be 02 00 00 00       	mov    $0x2,%esi
  80240c:	89 c7                	mov    %eax,%edi
  80240e:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  802415:	00 00 00 
  802418:	ff d0                	callq  *%rax

	return envid;
  80241a:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  80241d:	c9                   	leaveq 
  80241e:	c3                   	retq   

000000000080241f <sfork>:

	
// Challenge!
int
sfork(void)
{
  80241f:	55                   	push   %rbp
  802420:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802423:	48 ba 88 56 80 00 00 	movabs $0x805688,%rdx
  80242a:	00 00 00 
  80242d:	be bf 00 00 00       	mov    $0xbf,%esi
  802432:	48 bf cd 55 80 00 00 	movabs $0x8055cd,%rdi
  802439:	00 00 00 
  80243c:	b8 00 00 00 00       	mov    $0x0,%eax
  802441:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  802448:	00 00 00 
  80244b:	ff d1                	callq  *%rcx

000000000080244d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80244d:	55                   	push   %rbp
  80244e:	48 89 e5             	mov    %rsp,%rbp
  802451:	48 83 ec 08          	sub    $0x8,%rsp
  802455:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802459:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80245d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802464:	ff ff ff 
  802467:	48 01 d0             	add    %rdx,%rax
  80246a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80246e:	c9                   	leaveq 
  80246f:	c3                   	retq   

0000000000802470 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802470:	55                   	push   %rbp
  802471:	48 89 e5             	mov    %rsp,%rbp
  802474:	48 83 ec 08          	sub    $0x8,%rsp
  802478:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80247c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802480:	48 89 c7             	mov    %rax,%rdi
  802483:	48 b8 4d 24 80 00 00 	movabs $0x80244d,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	callq  *%rax
  80248f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802495:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802499:	c9                   	leaveq 
  80249a:	c3                   	retq   

000000000080249b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80249b:	55                   	push   %rbp
  80249c:	48 89 e5             	mov    %rsp,%rbp
  80249f:	48 83 ec 18          	sub    $0x18,%rsp
  8024a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024ae:	eb 6b                	jmp    80251b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b3:	48 98                	cltq   
  8024b5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024bb:	48 c1 e0 0c          	shl    $0xc,%rax
  8024bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c7:	48 c1 e8 15          	shr    $0x15,%rax
  8024cb:	48 89 c2             	mov    %rax,%rdx
  8024ce:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024d5:	01 00 00 
  8024d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024dc:	83 e0 01             	and    $0x1,%eax
  8024df:	48 85 c0             	test   %rax,%rax
  8024e2:	74 21                	je     802505 <fd_alloc+0x6a>
  8024e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e8:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ec:	48 89 c2             	mov    %rax,%rdx
  8024ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024f6:	01 00 00 
  8024f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fd:	83 e0 01             	and    $0x1,%eax
  802500:	48 85 c0             	test   %rax,%rax
  802503:	75 12                	jne    802517 <fd_alloc+0x7c>
			*fd_store = fd;
  802505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802509:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80250d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802510:	b8 00 00 00 00       	mov    $0x0,%eax
  802515:	eb 1a                	jmp    802531 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802517:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80251b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80251f:	7e 8f                	jle    8024b0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802525:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80252c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802531:	c9                   	leaveq 
  802532:	c3                   	retq   

0000000000802533 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802533:	55                   	push   %rbp
  802534:	48 89 e5             	mov    %rsp,%rbp
  802537:	48 83 ec 20          	sub    $0x20,%rsp
  80253b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80253e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802542:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802546:	78 06                	js     80254e <fd_lookup+0x1b>
  802548:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80254c:	7e 07                	jle    802555 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80254e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802553:	eb 6c                	jmp    8025c1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802555:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802558:	48 98                	cltq   
  80255a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802560:	48 c1 e0 0c          	shl    $0xc,%rax
  802564:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802568:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80256c:	48 c1 e8 15          	shr    $0x15,%rax
  802570:	48 89 c2             	mov    %rax,%rdx
  802573:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80257a:	01 00 00 
  80257d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802581:	83 e0 01             	and    $0x1,%eax
  802584:	48 85 c0             	test   %rax,%rax
  802587:	74 21                	je     8025aa <fd_lookup+0x77>
  802589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80258d:	48 c1 e8 0c          	shr    $0xc,%rax
  802591:	48 89 c2             	mov    %rax,%rdx
  802594:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80259b:	01 00 00 
  80259e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a2:	83 e0 01             	and    $0x1,%eax
  8025a5:	48 85 c0             	test   %rax,%rax
  8025a8:	75 07                	jne    8025b1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025af:	eb 10                	jmp    8025c1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025b9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c1:	c9                   	leaveq 
  8025c2:	c3                   	retq   

00000000008025c3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025c3:	55                   	push   %rbp
  8025c4:	48 89 e5             	mov    %rsp,%rbp
  8025c7:	48 83 ec 30          	sub    $0x30,%rsp
  8025cb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025cf:	89 f0                	mov    %esi,%eax
  8025d1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025d8:	48 89 c7             	mov    %rax,%rdi
  8025db:	48 b8 4d 24 80 00 00 	movabs $0x80244d,%rax
  8025e2:	00 00 00 
  8025e5:	ff d0                	callq  *%rax
  8025e7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025eb:	48 89 d6             	mov    %rdx,%rsi
  8025ee:	89 c7                	mov    %eax,%edi
  8025f0:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  8025f7:	00 00 00 
  8025fa:	ff d0                	callq  *%rax
  8025fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802603:	78 0a                	js     80260f <fd_close+0x4c>
	    || fd != fd2)
  802605:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802609:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80260d:	74 12                	je     802621 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80260f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802613:	74 05                	je     80261a <fd_close+0x57>
  802615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802618:	eb 05                	jmp    80261f <fd_close+0x5c>
  80261a:	b8 00 00 00 00       	mov    $0x0,%eax
  80261f:	eb 69                	jmp    80268a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802621:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802625:	8b 00                	mov    (%rax),%eax
  802627:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80262b:	48 89 d6             	mov    %rdx,%rsi
  80262e:	89 c7                	mov    %eax,%edi
  802630:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  802637:	00 00 00 
  80263a:	ff d0                	callq  *%rax
  80263c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802643:	78 2a                	js     80266f <fd_close+0xac>
		if (dev->dev_close)
  802645:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802649:	48 8b 40 20          	mov    0x20(%rax),%rax
  80264d:	48 85 c0             	test   %rax,%rax
  802650:	74 16                	je     802668 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802656:	48 8b 40 20          	mov    0x20(%rax),%rax
  80265a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80265e:	48 89 d7             	mov    %rdx,%rdi
  802661:	ff d0                	callq  *%rax
  802663:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802666:	eb 07                	jmp    80266f <fd_close+0xac>
		else
			r = 0;
  802668:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80266f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802673:	48 89 c6             	mov    %rax,%rsi
  802676:	bf 00 00 00 00       	mov    $0x0,%edi
  80267b:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  802682:	00 00 00 
  802685:	ff d0                	callq  *%rax
	return r;
  802687:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80268a:	c9                   	leaveq 
  80268b:	c3                   	retq   

000000000080268c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80268c:	55                   	push   %rbp
  80268d:	48 89 e5             	mov    %rsp,%rbp
  802690:	48 83 ec 20          	sub    $0x20,%rsp
  802694:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802697:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80269b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026a2:	eb 41                	jmp    8026e5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026a4:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026ab:	00 00 00 
  8026ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026b1:	48 63 d2             	movslq %edx,%rdx
  8026b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026b8:	8b 00                	mov    (%rax),%eax
  8026ba:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026bd:	75 22                	jne    8026e1 <dev_lookup+0x55>
			*dev = devtab[i];
  8026bf:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026c6:	00 00 00 
  8026c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026cc:	48 63 d2             	movslq %edx,%rdx
  8026cf:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026da:	b8 00 00 00 00       	mov    $0x0,%eax
  8026df:	eb 60                	jmp    802741 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026e5:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026ec:	00 00 00 
  8026ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026f2:	48 63 d2             	movslq %edx,%rdx
  8026f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f9:	48 85 c0             	test   %rax,%rax
  8026fc:	75 a6                	jne    8026a4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026fe:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802705:	00 00 00 
  802708:	48 8b 00             	mov    (%rax),%rax
  80270b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802711:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802714:	89 c6                	mov    %eax,%esi
  802716:	48 bf a0 56 80 00 00 	movabs $0x8056a0,%rdi
  80271d:	00 00 00 
  802720:	b8 00 00 00 00       	mov    $0x0,%eax
  802725:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  80272c:	00 00 00 
  80272f:	ff d1                	callq  *%rcx
	*dev = 0;
  802731:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802735:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80273c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802741:	c9                   	leaveq 
  802742:	c3                   	retq   

0000000000802743 <close>:

int
close(int fdnum)
{
  802743:	55                   	push   %rbp
  802744:	48 89 e5             	mov    %rsp,%rbp
  802747:	48 83 ec 20          	sub    $0x20,%rsp
  80274b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80274e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802752:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802755:	48 89 d6             	mov    %rdx,%rsi
  802758:	89 c7                	mov    %eax,%edi
  80275a:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  802761:	00 00 00 
  802764:	ff d0                	callq  *%rax
  802766:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802769:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80276d:	79 05                	jns    802774 <close+0x31>
		return r;
  80276f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802772:	eb 18                	jmp    80278c <close+0x49>
	else
		return fd_close(fd, 1);
  802774:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802778:	be 01 00 00 00       	mov    $0x1,%esi
  80277d:	48 89 c7             	mov    %rax,%rdi
  802780:	48 b8 c3 25 80 00 00 	movabs $0x8025c3,%rax
  802787:	00 00 00 
  80278a:	ff d0                	callq  *%rax
}
  80278c:	c9                   	leaveq 
  80278d:	c3                   	retq   

000000000080278e <close_all>:

void
close_all(void)
{
  80278e:	55                   	push   %rbp
  80278f:	48 89 e5             	mov    %rsp,%rbp
  802792:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802796:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80279d:	eb 15                	jmp    8027b4 <close_all+0x26>
		close(i);
  80279f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a2:	89 c7                	mov    %eax,%edi
  8027a4:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  8027ab:	00 00 00 
  8027ae:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027b4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027b8:	7e e5                	jle    80279f <close_all+0x11>
		close(i);
}
  8027ba:	c9                   	leaveq 
  8027bb:	c3                   	retq   

00000000008027bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027bc:	55                   	push   %rbp
  8027bd:	48 89 e5             	mov    %rsp,%rbp
  8027c0:	48 83 ec 40          	sub    $0x40,%rsp
  8027c4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027c7:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027ca:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027ce:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027d1:	48 89 d6             	mov    %rdx,%rsi
  8027d4:	89 c7                	mov    %eax,%edi
  8027d6:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  8027dd:	00 00 00 
  8027e0:	ff d0                	callq  *%rax
  8027e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e9:	79 08                	jns    8027f3 <dup+0x37>
		return r;
  8027eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ee:	e9 70 01 00 00       	jmpq   802963 <dup+0x1a7>
	close(newfdnum);
  8027f3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027f6:	89 c7                	mov    %eax,%edi
  8027f8:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  8027ff:	00 00 00 
  802802:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802804:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802807:	48 98                	cltq   
  802809:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80280f:	48 c1 e0 0c          	shl    $0xc,%rax
  802813:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80281b:	48 89 c7             	mov    %rax,%rdi
  80281e:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  802825:	00 00 00 
  802828:	ff d0                	callq  *%rax
  80282a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80282e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802832:	48 89 c7             	mov    %rax,%rdi
  802835:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  80283c:	00 00 00 
  80283f:	ff d0                	callq  *%rax
  802841:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802849:	48 c1 e8 15          	shr    $0x15,%rax
  80284d:	48 89 c2             	mov    %rax,%rdx
  802850:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802857:	01 00 00 
  80285a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80285e:	83 e0 01             	and    $0x1,%eax
  802861:	48 85 c0             	test   %rax,%rax
  802864:	74 73                	je     8028d9 <dup+0x11d>
  802866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286a:	48 c1 e8 0c          	shr    $0xc,%rax
  80286e:	48 89 c2             	mov    %rax,%rdx
  802871:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802878:	01 00 00 
  80287b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80287f:	83 e0 01             	and    $0x1,%eax
  802882:	48 85 c0             	test   %rax,%rax
  802885:	74 52                	je     8028d9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288b:	48 c1 e8 0c          	shr    $0xc,%rax
  80288f:	48 89 c2             	mov    %rax,%rdx
  802892:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802899:	01 00 00 
  80289c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028a0:	25 07 0e 00 00       	and    $0xe07,%eax
  8028a5:	89 c1                	mov    %eax,%ecx
  8028a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028af:	41 89 c8             	mov    %ecx,%r8d
  8028b2:	48 89 d1             	mov    %rdx,%rcx
  8028b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ba:	48 89 c6             	mov    %rax,%rsi
  8028bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8028c2:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8028c9:	00 00 00 
  8028cc:	ff d0                	callq  *%rax
  8028ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d5:	79 02                	jns    8028d9 <dup+0x11d>
			goto err;
  8028d7:	eb 57                	jmp    802930 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028dd:	48 c1 e8 0c          	shr    $0xc,%rax
  8028e1:	48 89 c2             	mov    %rax,%rdx
  8028e4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028eb:	01 00 00 
  8028ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8028f7:	89 c1                	mov    %eax,%ecx
  8028f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802901:	41 89 c8             	mov    %ecx,%r8d
  802904:	48 89 d1             	mov    %rdx,%rcx
  802907:	ba 00 00 00 00       	mov    $0x0,%edx
  80290c:	48 89 c6             	mov    %rax,%rsi
  80290f:	bf 00 00 00 00       	mov    $0x0,%edi
  802914:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  80291b:	00 00 00 
  80291e:	ff d0                	callq  *%rax
  802920:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802923:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802927:	79 02                	jns    80292b <dup+0x16f>
		goto err;
  802929:	eb 05                	jmp    802930 <dup+0x174>

	return newfdnum;
  80292b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80292e:	eb 33                	jmp    802963 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802930:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802934:	48 89 c6             	mov    %rax,%rsi
  802937:	bf 00 00 00 00       	mov    $0x0,%edi
  80293c:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  802943:	00 00 00 
  802946:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802948:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80294c:	48 89 c6             	mov    %rax,%rsi
  80294f:	bf 00 00 00 00       	mov    $0x0,%edi
  802954:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  80295b:	00 00 00 
  80295e:	ff d0                	callq  *%rax
	return r;
  802960:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802963:	c9                   	leaveq 
  802964:	c3                   	retq   

0000000000802965 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802965:	55                   	push   %rbp
  802966:	48 89 e5             	mov    %rsp,%rbp
  802969:	48 83 ec 40          	sub    $0x40,%rsp
  80296d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802970:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802974:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802978:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80297c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80297f:	48 89 d6             	mov    %rdx,%rsi
  802982:	89 c7                	mov    %eax,%edi
  802984:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  80298b:	00 00 00 
  80298e:	ff d0                	callq  *%rax
  802990:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802993:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802997:	78 24                	js     8029bd <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299d:	8b 00                	mov    (%rax),%eax
  80299f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a3:	48 89 d6             	mov    %rdx,%rsi
  8029a6:	89 c7                	mov    %eax,%edi
  8029a8:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  8029af:	00 00 00 
  8029b2:	ff d0                	callq  *%rax
  8029b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bb:	79 05                	jns    8029c2 <read+0x5d>
		return r;
  8029bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c0:	eb 76                	jmp    802a38 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c6:	8b 40 08             	mov    0x8(%rax),%eax
  8029c9:	83 e0 03             	and    $0x3,%eax
  8029cc:	83 f8 01             	cmp    $0x1,%eax
  8029cf:	75 3a                	jne    802a0b <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029d1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8029d8:	00 00 00 
  8029db:	48 8b 00             	mov    (%rax),%rax
  8029de:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029e4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029e7:	89 c6                	mov    %eax,%esi
  8029e9:	48 bf bf 56 80 00 00 	movabs $0x8056bf,%rdi
  8029f0:	00 00 00 
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  8029ff:	00 00 00 
  802a02:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a09:	eb 2d                	jmp    802a38 <read+0xd3>
	}
	if (!dev->dev_read)
  802a0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a13:	48 85 c0             	test   %rax,%rax
  802a16:	75 07                	jne    802a1f <read+0xba>
		return -E_NOT_SUPP;
  802a18:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a1d:	eb 19                	jmp    802a38 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a23:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a27:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a2b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a2f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a33:	48 89 cf             	mov    %rcx,%rdi
  802a36:	ff d0                	callq  *%rax
}
  802a38:	c9                   	leaveq 
  802a39:	c3                   	retq   

0000000000802a3a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a3a:	55                   	push   %rbp
  802a3b:	48 89 e5             	mov    %rsp,%rbp
  802a3e:	48 83 ec 30          	sub    $0x30,%rsp
  802a42:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a49:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a54:	eb 49                	jmp    802a9f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a59:	48 98                	cltq   
  802a5b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a5f:	48 29 c2             	sub    %rax,%rdx
  802a62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a65:	48 63 c8             	movslq %eax,%rcx
  802a68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a6c:	48 01 c1             	add    %rax,%rcx
  802a6f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a72:	48 89 ce             	mov    %rcx,%rsi
  802a75:	89 c7                	mov    %eax,%edi
  802a77:	48 b8 65 29 80 00 00 	movabs $0x802965,%rax
  802a7e:	00 00 00 
  802a81:	ff d0                	callq  *%rax
  802a83:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a86:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a8a:	79 05                	jns    802a91 <readn+0x57>
			return m;
  802a8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a8f:	eb 1c                	jmp    802aad <readn+0x73>
		if (m == 0)
  802a91:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a95:	75 02                	jne    802a99 <readn+0x5f>
			break;
  802a97:	eb 11                	jmp    802aaa <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a9c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa2:	48 98                	cltq   
  802aa4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802aa8:	72 ac                	jb     802a56 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802aaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aad:	c9                   	leaveq 
  802aae:	c3                   	retq   

0000000000802aaf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802aaf:	55                   	push   %rbp
  802ab0:	48 89 e5             	mov    %rsp,%rbp
  802ab3:	48 83 ec 40          	sub    $0x40,%rsp
  802ab7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802aba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802abe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ac2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ac6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ac9:	48 89 d6             	mov    %rdx,%rsi
  802acc:	89 c7                	mov    %eax,%edi
  802ace:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  802ad5:	00 00 00 
  802ad8:	ff d0                	callq  *%rax
  802ada:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802add:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae1:	78 24                	js     802b07 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae7:	8b 00                	mov    (%rax),%eax
  802ae9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aed:	48 89 d6             	mov    %rdx,%rsi
  802af0:	89 c7                	mov    %eax,%edi
  802af2:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  802af9:	00 00 00 
  802afc:	ff d0                	callq  *%rax
  802afe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b05:	79 05                	jns    802b0c <write+0x5d>
		return r;
  802b07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0a:	eb 42                	jmp    802b4e <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b10:	8b 40 08             	mov    0x8(%rax),%eax
  802b13:	83 e0 03             	and    $0x3,%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	75 07                	jne    802b21 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b1a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b1f:	eb 2d                	jmp    802b4e <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b25:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b29:	48 85 c0             	test   %rax,%rax
  802b2c:	75 07                	jne    802b35 <write+0x86>
		return -E_NOT_SUPP;
  802b2e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b33:	eb 19                	jmp    802b4e <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802b35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b39:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b3d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b41:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b45:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b49:	48 89 cf             	mov    %rcx,%rdi
  802b4c:	ff d0                	callq  *%rax
}
  802b4e:	c9                   	leaveq 
  802b4f:	c3                   	retq   

0000000000802b50 <seek>:

int
seek(int fdnum, off_t offset)
{
  802b50:	55                   	push   %rbp
  802b51:	48 89 e5             	mov    %rsp,%rbp
  802b54:	48 83 ec 18          	sub    $0x18,%rsp
  802b58:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b5b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b5e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b62:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b65:	48 89 d6             	mov    %rdx,%rsi
  802b68:	89 c7                	mov    %eax,%edi
  802b6a:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  802b71:	00 00 00 
  802b74:	ff d0                	callq  *%rax
  802b76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7d:	79 05                	jns    802b84 <seek+0x34>
		return r;
  802b7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b82:	eb 0f                	jmp    802b93 <seek+0x43>
	fd->fd_offset = offset;
  802b84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b88:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b8b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b93:	c9                   	leaveq 
  802b94:	c3                   	retq   

0000000000802b95 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b95:	55                   	push   %rbp
  802b96:	48 89 e5             	mov    %rsp,%rbp
  802b99:	48 83 ec 30          	sub    $0x30,%rsp
  802b9d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ba0:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ba3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ba7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802baa:	48 89 d6             	mov    %rdx,%rsi
  802bad:	89 c7                	mov    %eax,%edi
  802baf:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  802bb6:	00 00 00 
  802bb9:	ff d0                	callq  *%rax
  802bbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc2:	78 24                	js     802be8 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc8:	8b 00                	mov    (%rax),%eax
  802bca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bce:	48 89 d6             	mov    %rdx,%rsi
  802bd1:	89 c7                	mov    %eax,%edi
  802bd3:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  802bda:	00 00 00 
  802bdd:	ff d0                	callq  *%rax
  802bdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be6:	79 05                	jns    802bed <ftruncate+0x58>
		return r;
  802be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802beb:	eb 72                	jmp    802c5f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf1:	8b 40 08             	mov    0x8(%rax),%eax
  802bf4:	83 e0 03             	and    $0x3,%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	75 3a                	jne    802c35 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802bfb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c02:	00 00 00 
  802c05:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c08:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c0e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c11:	89 c6                	mov    %eax,%esi
  802c13:	48 bf e0 56 80 00 00 	movabs $0x8056e0,%rdi
  802c1a:	00 00 00 
  802c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c22:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  802c29:	00 00 00 
  802c2c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c33:	eb 2a                	jmp    802c5f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c39:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c3d:	48 85 c0             	test   %rax,%rax
  802c40:	75 07                	jne    802c49 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c42:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c47:	eb 16                	jmp    802c5f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c4d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c51:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c55:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c58:	89 ce                	mov    %ecx,%esi
  802c5a:	48 89 d7             	mov    %rdx,%rdi
  802c5d:	ff d0                	callq  *%rax
}
  802c5f:	c9                   	leaveq 
  802c60:	c3                   	retq   

0000000000802c61 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c61:	55                   	push   %rbp
  802c62:	48 89 e5             	mov    %rsp,%rbp
  802c65:	48 83 ec 30          	sub    $0x30,%rsp
  802c69:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c6c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c70:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c74:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c77:	48 89 d6             	mov    %rdx,%rsi
  802c7a:	89 c7                	mov    %eax,%edi
  802c7c:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  802c83:	00 00 00 
  802c86:	ff d0                	callq  *%rax
  802c88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8f:	78 24                	js     802cb5 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c95:	8b 00                	mov    (%rax),%eax
  802c97:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c9b:	48 89 d6             	mov    %rdx,%rsi
  802c9e:	89 c7                	mov    %eax,%edi
  802ca0:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  802ca7:	00 00 00 
  802caa:	ff d0                	callq  *%rax
  802cac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802caf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb3:	79 05                	jns    802cba <fstat+0x59>
		return r;
  802cb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb8:	eb 5e                	jmp    802d18 <fstat+0xb7>
	if (!dev->dev_stat)
  802cba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbe:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cc2:	48 85 c0             	test   %rax,%rax
  802cc5:	75 07                	jne    802cce <fstat+0x6d>
		return -E_NOT_SUPP;
  802cc7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ccc:	eb 4a                	jmp    802d18 <fstat+0xb7>
	stat->st_name[0] = 0;
  802cce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cd2:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802cd5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cd9:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ce0:	00 00 00 
	stat->st_isdir = 0;
  802ce3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ce7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802cee:	00 00 00 
	stat->st_dev = dev;
  802cf1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cf5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cf9:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d04:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d0c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d10:	48 89 ce             	mov    %rcx,%rsi
  802d13:	48 89 d7             	mov    %rdx,%rdi
  802d16:	ff d0                	callq  *%rax
}
  802d18:	c9                   	leaveq 
  802d19:	c3                   	retq   

0000000000802d1a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d1a:	55                   	push   %rbp
  802d1b:	48 89 e5             	mov    %rsp,%rbp
  802d1e:	48 83 ec 20          	sub    $0x20,%rsp
  802d22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d26:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2e:	be 00 00 00 00       	mov    $0x0,%esi
  802d33:	48 89 c7             	mov    %rax,%rdi
  802d36:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  802d3d:	00 00 00 
  802d40:	ff d0                	callq  *%rax
  802d42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d49:	79 05                	jns    802d50 <stat+0x36>
		return fd;
  802d4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4e:	eb 2f                	jmp    802d7f <stat+0x65>
	r = fstat(fd, stat);
  802d50:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d57:	48 89 d6             	mov    %rdx,%rsi
  802d5a:	89 c7                	mov    %eax,%edi
  802d5c:	48 b8 61 2c 80 00 00 	movabs $0x802c61,%rax
  802d63:	00 00 00 
  802d66:	ff d0                	callq  *%rax
  802d68:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6e:	89 c7                	mov    %eax,%edi
  802d70:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  802d77:	00 00 00 
  802d7a:	ff d0                	callq  *%rax
	return r;
  802d7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d7f:	c9                   	leaveq 
  802d80:	c3                   	retq   

0000000000802d81 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d81:	55                   	push   %rbp
  802d82:	48 89 e5             	mov    %rsp,%rbp
  802d85:	48 83 ec 10          	sub    $0x10,%rsp
  802d89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d90:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d97:	00 00 00 
  802d9a:	8b 00                	mov    (%rax),%eax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	75 1d                	jne    802dbd <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802da0:	bf 01 00 00 00       	mov    $0x1,%edi
  802da5:	48 b8 86 4e 80 00 00 	movabs $0x804e86,%rax
  802dac:	00 00 00 
  802daf:	ff d0                	callq  *%rax
  802db1:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802db8:	00 00 00 
  802dbb:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802dbd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dc4:	00 00 00 
  802dc7:	8b 00                	mov    (%rax),%eax
  802dc9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802dcc:	b9 07 00 00 00       	mov    $0x7,%ecx
  802dd1:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802dd8:	00 00 00 
  802ddb:	89 c7                	mov    %eax,%edi
  802ddd:	48 b8 b9 4a 80 00 00 	movabs $0x804ab9,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802de9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ded:	ba 00 00 00 00       	mov    $0x0,%edx
  802df2:	48 89 c6             	mov    %rax,%rsi
  802df5:	bf 00 00 00 00       	mov    $0x0,%edi
  802dfa:	48 b8 bb 49 80 00 00 	movabs $0x8049bb,%rax
  802e01:	00 00 00 
  802e04:	ff d0                	callq  *%rax
}
  802e06:	c9                   	leaveq 
  802e07:	c3                   	retq   

0000000000802e08 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e08:	55                   	push   %rbp
  802e09:	48 89 e5             	mov    %rsp,%rbp
  802e0c:	48 83 ec 30          	sub    $0x30,%rsp
  802e10:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e14:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802e17:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802e1e:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802e25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802e2c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e31:	75 08                	jne    802e3b <open+0x33>
	{
		return r;
  802e33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e36:	e9 f2 00 00 00       	jmpq   802f2d <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802e3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e3f:	48 89 c7             	mov    %rax,%rdi
  802e42:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	callq  *%rax
  802e4e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e51:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802e58:	7e 0a                	jle    802e64 <open+0x5c>
	{
		return -E_BAD_PATH;
  802e5a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e5f:	e9 c9 00 00 00       	jmpq   802f2d <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802e64:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802e6b:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802e6c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802e70:	48 89 c7             	mov    %rax,%rdi
  802e73:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
  802e7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e86:	78 09                	js     802e91 <open+0x89>
  802e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8c:	48 85 c0             	test   %rax,%rax
  802e8f:	75 08                	jne    802e99 <open+0x91>
		{
			return r;
  802e91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e94:	e9 94 00 00 00       	jmpq   802f2d <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802e99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e9d:	ba 00 04 00 00       	mov    $0x400,%edx
  802ea2:	48 89 c6             	mov    %rax,%rsi
  802ea5:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802eac:	00 00 00 
  802eaf:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  802eb6:	00 00 00 
  802eb9:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802ebb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ec2:	00 00 00 
  802ec5:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802ec8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802ece:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed2:	48 89 c6             	mov    %rax,%rsi
  802ed5:	bf 01 00 00 00       	mov    $0x1,%edi
  802eda:	48 b8 81 2d 80 00 00 	movabs $0x802d81,%rax
  802ee1:	00 00 00 
  802ee4:	ff d0                	callq  *%rax
  802ee6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eed:	79 2b                	jns    802f1a <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef3:	be 00 00 00 00       	mov    $0x0,%esi
  802ef8:	48 89 c7             	mov    %rax,%rdi
  802efb:	48 b8 c3 25 80 00 00 	movabs $0x8025c3,%rax
  802f02:	00 00 00 
  802f05:	ff d0                	callq  *%rax
  802f07:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802f0a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f0e:	79 05                	jns    802f15 <open+0x10d>
			{
				return d;
  802f10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f13:	eb 18                	jmp    802f2d <open+0x125>
			}
			return r;
  802f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f18:	eb 13                	jmp    802f2d <open+0x125>
		}	
		return fd2num(fd_store);
  802f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1e:	48 89 c7             	mov    %rax,%rdi
  802f21:	48 b8 4d 24 80 00 00 	movabs $0x80244d,%rax
  802f28:	00 00 00 
  802f2b:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802f2d:	c9                   	leaveq 
  802f2e:	c3                   	retq   

0000000000802f2f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f2f:	55                   	push   %rbp
  802f30:	48 89 e5             	mov    %rsp,%rbp
  802f33:	48 83 ec 10          	sub    $0x10,%rsp
  802f37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f3f:	8b 50 0c             	mov    0xc(%rax),%edx
  802f42:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f49:	00 00 00 
  802f4c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f4e:	be 00 00 00 00       	mov    $0x0,%esi
  802f53:	bf 06 00 00 00       	mov    $0x6,%edi
  802f58:	48 b8 81 2d 80 00 00 	movabs $0x802d81,%rax
  802f5f:	00 00 00 
  802f62:	ff d0                	callq  *%rax
}
  802f64:	c9                   	leaveq 
  802f65:	c3                   	retq   

0000000000802f66 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f66:	55                   	push   %rbp
  802f67:	48 89 e5             	mov    %rsp,%rbp
  802f6a:	48 83 ec 30          	sub    $0x30,%rsp
  802f6e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f76:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802f7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802f81:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f86:	74 07                	je     802f8f <devfile_read+0x29>
  802f88:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802f8d:	75 07                	jne    802f96 <devfile_read+0x30>
		return -E_INVAL;
  802f8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f94:	eb 77                	jmp    80300d <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f9a:	8b 50 0c             	mov    0xc(%rax),%edx
  802f9d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fa4:	00 00 00 
  802fa7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802fa9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fb0:	00 00 00 
  802fb3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fb7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802fbb:	be 00 00 00 00       	mov    $0x0,%esi
  802fc0:	bf 03 00 00 00       	mov    $0x3,%edi
  802fc5:	48 b8 81 2d 80 00 00 	movabs $0x802d81,%rax
  802fcc:	00 00 00 
  802fcf:	ff d0                	callq  *%rax
  802fd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd8:	7f 05                	jg     802fdf <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802fda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fdd:	eb 2e                	jmp    80300d <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802fdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe2:	48 63 d0             	movslq %eax,%rdx
  802fe5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fe9:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802ff0:	00 00 00 
  802ff3:	48 89 c7             	mov    %rax,%rdi
  802ff6:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  802ffd:	00 00 00 
  803000:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803002:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803006:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80300a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80300d:	c9                   	leaveq 
  80300e:	c3                   	retq   

000000000080300f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80300f:	55                   	push   %rbp
  803010:	48 89 e5             	mov    %rsp,%rbp
  803013:	48 83 ec 30          	sub    $0x30,%rsp
  803017:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80301b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80301f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803023:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80302a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80302f:	74 07                	je     803038 <devfile_write+0x29>
  803031:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803036:	75 08                	jne    803040 <devfile_write+0x31>
		return r;
  803038:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303b:	e9 9a 00 00 00       	jmpq   8030da <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803040:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803044:	8b 50 0c             	mov    0xc(%rax),%edx
  803047:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80304e:	00 00 00 
  803051:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803053:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80305a:	00 
  80305b:	76 08                	jbe    803065 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80305d:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803064:	00 
	}
	fsipcbuf.write.req_n = n;
  803065:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80306c:	00 00 00 
  80306f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803073:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803077:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80307b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80307f:	48 89 c6             	mov    %rax,%rsi
  803082:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803089:	00 00 00 
  80308c:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  803093:	00 00 00 
  803096:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803098:	be 00 00 00 00       	mov    $0x0,%esi
  80309d:	bf 04 00 00 00       	mov    $0x4,%edi
  8030a2:	48 b8 81 2d 80 00 00 	movabs $0x802d81,%rax
  8030a9:	00 00 00 
  8030ac:	ff d0                	callq  *%rax
  8030ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b5:	7f 20                	jg     8030d7 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8030b7:	48 bf 06 57 80 00 00 	movabs $0x805706,%rdi
  8030be:	00 00 00 
  8030c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c6:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  8030cd:	00 00 00 
  8030d0:	ff d2                	callq  *%rdx
		return r;
  8030d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d5:	eb 03                	jmp    8030da <devfile_write+0xcb>
	}
	return r;
  8030d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8030da:	c9                   	leaveq 
  8030db:	c3                   	retq   

00000000008030dc <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8030dc:	55                   	push   %rbp
  8030dd:	48 89 e5             	mov    %rsp,%rbp
  8030e0:	48 83 ec 20          	sub    $0x20,%rsp
  8030e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8030ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f0:	8b 50 0c             	mov    0xc(%rax),%edx
  8030f3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030fa:	00 00 00 
  8030fd:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030ff:	be 00 00 00 00       	mov    $0x0,%esi
  803104:	bf 05 00 00 00       	mov    $0x5,%edi
  803109:	48 b8 81 2d 80 00 00 	movabs $0x802d81,%rax
  803110:	00 00 00 
  803113:	ff d0                	callq  *%rax
  803115:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803118:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311c:	79 05                	jns    803123 <devfile_stat+0x47>
		return r;
  80311e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803121:	eb 56                	jmp    803179 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803123:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803127:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80312e:	00 00 00 
  803131:	48 89 c7             	mov    %rax,%rdi
  803134:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  80313b:	00 00 00 
  80313e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803140:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803147:	00 00 00 
  80314a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803150:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803154:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80315a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803161:	00 00 00 
  803164:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80316a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80316e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803174:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803179:	c9                   	leaveq 
  80317a:	c3                   	retq   

000000000080317b <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80317b:	55                   	push   %rbp
  80317c:	48 89 e5             	mov    %rsp,%rbp
  80317f:	48 83 ec 10          	sub    $0x10,%rsp
  803183:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803187:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80318a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80318e:	8b 50 0c             	mov    0xc(%rax),%edx
  803191:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803198:	00 00 00 
  80319b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80319d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031a4:	00 00 00 
  8031a7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031aa:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031ad:	be 00 00 00 00       	mov    $0x0,%esi
  8031b2:	bf 02 00 00 00       	mov    $0x2,%edi
  8031b7:	48 b8 81 2d 80 00 00 	movabs $0x802d81,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
}
  8031c3:	c9                   	leaveq 
  8031c4:	c3                   	retq   

00000000008031c5 <remove>:

// Delete a file
int
remove(const char *path)
{
  8031c5:	55                   	push   %rbp
  8031c6:	48 89 e5             	mov    %rsp,%rbp
  8031c9:	48 83 ec 10          	sub    $0x10,%rsp
  8031cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8031d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031d5:	48 89 c7             	mov    %rax,%rdi
  8031d8:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  8031df:	00 00 00 
  8031e2:	ff d0                	callq  *%rax
  8031e4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031e9:	7e 07                	jle    8031f2 <remove+0x2d>
		return -E_BAD_PATH;
  8031eb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031f0:	eb 33                	jmp    803225 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8031f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031f6:	48 89 c6             	mov    %rax,%rsi
  8031f9:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803200:	00 00 00 
  803203:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  80320a:	00 00 00 
  80320d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80320f:	be 00 00 00 00       	mov    $0x0,%esi
  803214:	bf 07 00 00 00       	mov    $0x7,%edi
  803219:	48 b8 81 2d 80 00 00 	movabs $0x802d81,%rax
  803220:	00 00 00 
  803223:	ff d0                	callq  *%rax
}
  803225:	c9                   	leaveq 
  803226:	c3                   	retq   

0000000000803227 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803227:	55                   	push   %rbp
  803228:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80322b:	be 00 00 00 00       	mov    $0x0,%esi
  803230:	bf 08 00 00 00       	mov    $0x8,%edi
  803235:	48 b8 81 2d 80 00 00 	movabs $0x802d81,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
}
  803241:	5d                   	pop    %rbp
  803242:	c3                   	retq   

0000000000803243 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803243:	55                   	push   %rbp
  803244:	48 89 e5             	mov    %rsp,%rbp
  803247:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80324e:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803255:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80325c:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803263:	be 00 00 00 00       	mov    $0x0,%esi
  803268:	48 89 c7             	mov    %rax,%rdi
  80326b:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
  803277:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80327a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80327e:	79 28                	jns    8032a8 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803280:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803283:	89 c6                	mov    %eax,%esi
  803285:	48 bf 22 57 80 00 00 	movabs $0x805722,%rdi
  80328c:	00 00 00 
  80328f:	b8 00 00 00 00       	mov    $0x0,%eax
  803294:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  80329b:	00 00 00 
  80329e:	ff d2                	callq  *%rdx
		return fd_src;
  8032a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a3:	e9 74 01 00 00       	jmpq   80341c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8032a8:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8032af:	be 01 01 00 00       	mov    $0x101,%esi
  8032b4:	48 89 c7             	mov    %rax,%rdi
  8032b7:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
  8032c3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8032c6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032ca:	79 39                	jns    803305 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8032cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032cf:	89 c6                	mov    %eax,%esi
  8032d1:	48 bf 38 57 80 00 00 	movabs $0x805738,%rdi
  8032d8:	00 00 00 
  8032db:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e0:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  8032e7:	00 00 00 
  8032ea:	ff d2                	callq  *%rdx
		close(fd_src);
  8032ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ef:	89 c7                	mov    %eax,%edi
  8032f1:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  8032f8:	00 00 00 
  8032fb:	ff d0                	callq  *%rax
		return fd_dest;
  8032fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803300:	e9 17 01 00 00       	jmpq   80341c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803305:	eb 74                	jmp    80337b <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803307:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80330a:	48 63 d0             	movslq %eax,%rdx
  80330d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803314:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803317:	48 89 ce             	mov    %rcx,%rsi
  80331a:	89 c7                	mov    %eax,%edi
  80331c:	48 b8 af 2a 80 00 00 	movabs $0x802aaf,%rax
  803323:	00 00 00 
  803326:	ff d0                	callq  *%rax
  803328:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80332b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80332f:	79 4a                	jns    80337b <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803331:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803334:	89 c6                	mov    %eax,%esi
  803336:	48 bf 52 57 80 00 00 	movabs $0x805752,%rdi
  80333d:	00 00 00 
  803340:	b8 00 00 00 00       	mov    $0x0,%eax
  803345:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  80334c:	00 00 00 
  80334f:	ff d2                	callq  *%rdx
			close(fd_src);
  803351:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803354:	89 c7                	mov    %eax,%edi
  803356:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  80335d:	00 00 00 
  803360:	ff d0                	callq  *%rax
			close(fd_dest);
  803362:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803365:	89 c7                	mov    %eax,%edi
  803367:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
			return write_size;
  803373:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803376:	e9 a1 00 00 00       	jmpq   80341c <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80337b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803382:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803385:	ba 00 02 00 00       	mov    $0x200,%edx
  80338a:	48 89 ce             	mov    %rcx,%rsi
  80338d:	89 c7                	mov    %eax,%edi
  80338f:	48 b8 65 29 80 00 00 	movabs $0x802965,%rax
  803396:	00 00 00 
  803399:	ff d0                	callq  *%rax
  80339b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80339e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033a2:	0f 8f 5f ff ff ff    	jg     803307 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8033a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033ac:	79 47                	jns    8033f5 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8033ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033b1:	89 c6                	mov    %eax,%esi
  8033b3:	48 bf 65 57 80 00 00 	movabs $0x805765,%rdi
  8033ba:	00 00 00 
  8033bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c2:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  8033c9:	00 00 00 
  8033cc:	ff d2                	callq  *%rdx
		close(fd_src);
  8033ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d1:	89 c7                	mov    %eax,%edi
  8033d3:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
		close(fd_dest);
  8033df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033e2:	89 c7                	mov    %eax,%edi
  8033e4:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  8033eb:	00 00 00 
  8033ee:	ff d0                	callq  *%rax
		return read_size;
  8033f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033f3:	eb 27                	jmp    80341c <copy+0x1d9>
	}
	close(fd_src);
  8033f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f8:	89 c7                	mov    %eax,%edi
  8033fa:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  803401:	00 00 00 
  803404:	ff d0                	callq  *%rax
	close(fd_dest);
  803406:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803409:	89 c7                	mov    %eax,%edi
  80340b:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  803412:	00 00 00 
  803415:	ff d0                	callq  *%rax
	return 0;
  803417:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80341c:	c9                   	leaveq 
  80341d:	c3                   	retq   

000000000080341e <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80341e:	55                   	push   %rbp
  80341f:	48 89 e5             	mov    %rsp,%rbp
  803422:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803429:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803430:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803437:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  80343e:	be 00 00 00 00       	mov    $0x0,%esi
  803443:	48 89 c7             	mov    %rax,%rdi
  803446:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  80344d:	00 00 00 
  803450:	ff d0                	callq  *%rax
  803452:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803455:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803459:	79 08                	jns    803463 <spawn+0x45>
		return r;
  80345b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80345e:	e9 0c 03 00 00       	jmpq   80376f <spawn+0x351>
	fd = r;
  803463:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803466:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803469:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803470:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803474:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  80347b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80347e:	ba 00 02 00 00       	mov    $0x200,%edx
  803483:	48 89 ce             	mov    %rcx,%rsi
  803486:	89 c7                	mov    %eax,%edi
  803488:	48 b8 3a 2a 80 00 00 	movabs $0x802a3a,%rax
  80348f:	00 00 00 
  803492:	ff d0                	callq  *%rax
  803494:	3d 00 02 00 00       	cmp    $0x200,%eax
  803499:	75 0d                	jne    8034a8 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  80349b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80349f:	8b 00                	mov    (%rax),%eax
  8034a1:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8034a6:	74 43                	je     8034eb <spawn+0xcd>
		close(fd);
  8034a8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8034ab:	89 c7                	mov    %eax,%edi
  8034ad:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  8034b4:	00 00 00 
  8034b7:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8034b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034bd:	8b 00                	mov    (%rax),%eax
  8034bf:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8034c4:	89 c6                	mov    %eax,%esi
  8034c6:	48 bf 80 57 80 00 00 	movabs $0x805780,%rdi
  8034cd:	00 00 00 
  8034d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d5:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  8034dc:	00 00 00 
  8034df:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  8034e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8034e6:	e9 84 02 00 00       	jmpq   80376f <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8034eb:	b8 07 00 00 00       	mov    $0x7,%eax
  8034f0:	cd 30                	int    $0x30
  8034f2:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8034f5:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8034f8:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8034fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034ff:	79 08                	jns    803509 <spawn+0xeb>
		return r;
  803501:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803504:	e9 66 02 00 00       	jmpq   80376f <spawn+0x351>
	child = r;
  803509:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80350c:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80350f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803512:	25 ff 03 00 00       	and    $0x3ff,%eax
  803517:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80351e:	00 00 00 
  803521:	48 98                	cltq   
  803523:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80352a:	48 01 d0             	add    %rdx,%rax
  80352d:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803534:	48 89 c6             	mov    %rax,%rsi
  803537:	b8 18 00 00 00       	mov    $0x18,%eax
  80353c:	48 89 d7             	mov    %rdx,%rdi
  80353f:	48 89 c1             	mov    %rax,%rcx
  803542:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803545:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803549:	48 8b 40 18          	mov    0x18(%rax),%rax
  80354d:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803554:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  80355b:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803562:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803569:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80356c:	48 89 ce             	mov    %rcx,%rsi
  80356f:	89 c7                	mov    %eax,%edi
  803571:	48 b8 d9 39 80 00 00 	movabs $0x8039d9,%rax
  803578:	00 00 00 
  80357b:	ff d0                	callq  *%rax
  80357d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803580:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803584:	79 08                	jns    80358e <spawn+0x170>
		return r;
  803586:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803589:	e9 e1 01 00 00       	jmpq   80376f <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80358e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803592:	48 8b 40 20          	mov    0x20(%rax),%rax
  803596:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80359d:	48 01 d0             	add    %rdx,%rax
  8035a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8035a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035ab:	e9 a3 00 00 00       	jmpq   803653 <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  8035b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b4:	8b 00                	mov    (%rax),%eax
  8035b6:	83 f8 01             	cmp    $0x1,%eax
  8035b9:	74 05                	je     8035c0 <spawn+0x1a2>
			continue;
  8035bb:	e9 8a 00 00 00       	jmpq   80364a <spawn+0x22c>
		perm = PTE_P | PTE_U;
  8035c0:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8035c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035cb:	8b 40 04             	mov    0x4(%rax),%eax
  8035ce:	83 e0 02             	and    $0x2,%eax
  8035d1:	85 c0                	test   %eax,%eax
  8035d3:	74 04                	je     8035d9 <spawn+0x1bb>
			perm |= PTE_W;
  8035d5:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8035d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035dd:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8035e1:	41 89 c1             	mov    %eax,%r9d
  8035e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e8:	4c 8b 40 20          	mov    0x20(%rax),%r8
  8035ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f0:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8035f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f8:	48 8b 70 10          	mov    0x10(%rax),%rsi
  8035fc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8035ff:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803602:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803605:	89 3c 24             	mov    %edi,(%rsp)
  803608:	89 c7                	mov    %eax,%edi
  80360a:	48 b8 82 3c 80 00 00 	movabs $0x803c82,%rax
  803611:	00 00 00 
  803614:	ff d0                	callq  *%rax
  803616:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803619:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80361d:	79 2b                	jns    80364a <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  80361f:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803620:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803623:	89 c7                	mov    %eax,%edi
  803625:	48 b8 ab 19 80 00 00 	movabs $0x8019ab,%rax
  80362c:	00 00 00 
  80362f:	ff d0                	callq  *%rax
	close(fd);
  803631:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803634:	89 c7                	mov    %eax,%edi
  803636:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  80363d:	00 00 00 
  803640:	ff d0                	callq  *%rax
	return r;
  803642:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803645:	e9 25 01 00 00       	jmpq   80376f <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80364a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80364e:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803657:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  80365b:	0f b7 c0             	movzwl %ax,%eax
  80365e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803661:	0f 8f 49 ff ff ff    	jg     8035b0 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803667:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80366a:	89 c7                	mov    %eax,%edi
  80366c:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  803673:	00 00 00 
  803676:	ff d0                	callq  *%rax
	fd = -1;
  803678:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  80367f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803682:	89 c7                	mov    %eax,%edi
  803684:	48 b8 6e 3e 80 00 00 	movabs $0x803e6e,%rax
  80368b:	00 00 00 
  80368e:	ff d0                	callq  *%rax
  803690:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803693:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803697:	79 30                	jns    8036c9 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  803699:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80369c:	89 c1                	mov    %eax,%ecx
  80369e:	48 ba 9a 57 80 00 00 	movabs $0x80579a,%rdx
  8036a5:	00 00 00 
  8036a8:	be 82 00 00 00       	mov    $0x82,%esi
  8036ad:	48 bf b0 57 80 00 00 	movabs $0x8057b0,%rdi
  8036b4:	00 00 00 
  8036b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bc:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8036c3:	00 00 00 
  8036c6:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8036c9:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8036d0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8036d3:	48 89 d6             	mov    %rdx,%rsi
  8036d6:	89 c7                	mov    %eax,%edi
  8036d8:	48 b8 ab 1b 80 00 00 	movabs $0x801bab,%rax
  8036df:	00 00 00 
  8036e2:	ff d0                	callq  *%rax
  8036e4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8036e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8036eb:	79 30                	jns    80371d <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  8036ed:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8036f0:	89 c1                	mov    %eax,%ecx
  8036f2:	48 ba bc 57 80 00 00 	movabs $0x8057bc,%rdx
  8036f9:	00 00 00 
  8036fc:	be 85 00 00 00       	mov    $0x85,%esi
  803701:	48 bf b0 57 80 00 00 	movabs $0x8057b0,%rdi
  803708:	00 00 00 
  80370b:	b8 00 00 00 00       	mov    $0x0,%eax
  803710:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803717:	00 00 00 
  80371a:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80371d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803720:	be 02 00 00 00       	mov    $0x2,%esi
  803725:	89 c7                	mov    %eax,%edi
  803727:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  80372e:	00 00 00 
  803731:	ff d0                	callq  *%rax
  803733:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803736:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80373a:	79 30                	jns    80376c <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  80373c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80373f:	89 c1                	mov    %eax,%ecx
  803741:	48 ba d6 57 80 00 00 	movabs $0x8057d6,%rdx
  803748:	00 00 00 
  80374b:	be 88 00 00 00       	mov    $0x88,%esi
  803750:	48 bf b0 57 80 00 00 	movabs $0x8057b0,%rdi
  803757:	00 00 00 
  80375a:	b8 00 00 00 00       	mov    $0x0,%eax
  80375f:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803766:	00 00 00 
  803769:	41 ff d0             	callq  *%r8

	return child;
  80376c:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80376f:	c9                   	leaveq 
  803770:	c3                   	retq   

0000000000803771 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803771:	55                   	push   %rbp
  803772:	48 89 e5             	mov    %rsp,%rbp
  803775:	41 55                	push   %r13
  803777:	41 54                	push   %r12
  803779:	53                   	push   %rbx
  80377a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803781:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803788:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  80378f:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803796:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  80379d:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8037a4:	84 c0                	test   %al,%al
  8037a6:	74 26                	je     8037ce <spawnl+0x5d>
  8037a8:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8037af:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8037b6:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8037ba:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8037be:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8037c2:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8037c6:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8037ca:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  8037ce:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8037d5:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  8037dc:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  8037df:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8037e6:	00 00 00 
  8037e9:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8037f0:	00 00 00 
  8037f3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8037f7:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8037fe:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803805:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  80380c:	eb 07                	jmp    803815 <spawnl+0xa4>
		argc++;
  80380e:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803815:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80381b:	83 f8 30             	cmp    $0x30,%eax
  80381e:	73 23                	jae    803843 <spawnl+0xd2>
  803820:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803827:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80382d:	89 c0                	mov    %eax,%eax
  80382f:	48 01 d0             	add    %rdx,%rax
  803832:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803838:	83 c2 08             	add    $0x8,%edx
  80383b:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803841:	eb 15                	jmp    803858 <spawnl+0xe7>
  803843:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80384a:	48 89 d0             	mov    %rdx,%rax
  80384d:	48 83 c2 08          	add    $0x8,%rdx
  803851:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803858:	48 8b 00             	mov    (%rax),%rax
  80385b:	48 85 c0             	test   %rax,%rax
  80385e:	75 ae                	jne    80380e <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803860:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803866:	83 c0 02             	add    $0x2,%eax
  803869:	48 89 e2             	mov    %rsp,%rdx
  80386c:	48 89 d3             	mov    %rdx,%rbx
  80386f:	48 63 d0             	movslq %eax,%rdx
  803872:	48 83 ea 01          	sub    $0x1,%rdx
  803876:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  80387d:	48 63 d0             	movslq %eax,%rdx
  803880:	49 89 d4             	mov    %rdx,%r12
  803883:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803889:	48 63 d0             	movslq %eax,%rdx
  80388c:	49 89 d2             	mov    %rdx,%r10
  80388f:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803895:	48 98                	cltq   
  803897:	48 c1 e0 03          	shl    $0x3,%rax
  80389b:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80389f:	b8 10 00 00 00       	mov    $0x10,%eax
  8038a4:	48 83 e8 01          	sub    $0x1,%rax
  8038a8:	48 01 d0             	add    %rdx,%rax
  8038ab:	bf 10 00 00 00       	mov    $0x10,%edi
  8038b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8038b5:	48 f7 f7             	div    %rdi
  8038b8:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8038bc:	48 29 c4             	sub    %rax,%rsp
  8038bf:	48 89 e0             	mov    %rsp,%rax
  8038c2:	48 83 c0 07          	add    $0x7,%rax
  8038c6:	48 c1 e8 03          	shr    $0x3,%rax
  8038ca:	48 c1 e0 03          	shl    $0x3,%rax
  8038ce:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8038d5:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8038dc:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8038e3:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8038e6:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8038ec:	8d 50 01             	lea    0x1(%rax),%edx
  8038ef:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8038f6:	48 63 d2             	movslq %edx,%rdx
  8038f9:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803900:	00 

	va_start(vl, arg0);
  803901:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803908:	00 00 00 
  80390b:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803912:	00 00 00 
  803915:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803919:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803920:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803927:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  80392e:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803935:	00 00 00 
  803938:	eb 63                	jmp    80399d <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  80393a:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803940:	8d 70 01             	lea    0x1(%rax),%esi
  803943:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803949:	83 f8 30             	cmp    $0x30,%eax
  80394c:	73 23                	jae    803971 <spawnl+0x200>
  80394e:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803955:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80395b:	89 c0                	mov    %eax,%eax
  80395d:	48 01 d0             	add    %rdx,%rax
  803960:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803966:	83 c2 08             	add    $0x8,%edx
  803969:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80396f:	eb 15                	jmp    803986 <spawnl+0x215>
  803971:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803978:	48 89 d0             	mov    %rdx,%rax
  80397b:	48 83 c2 08          	add    $0x8,%rdx
  80397f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803986:	48 8b 08             	mov    (%rax),%rcx
  803989:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803990:	89 f2                	mov    %esi,%edx
  803992:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803996:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80399d:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8039a3:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8039a9:	77 8f                	ja     80393a <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8039ab:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8039b2:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8039b9:	48 89 d6             	mov    %rdx,%rsi
  8039bc:	48 89 c7             	mov    %rax,%rdi
  8039bf:	48 b8 1e 34 80 00 00 	movabs $0x80341e,%rax
  8039c6:	00 00 00 
  8039c9:	ff d0                	callq  *%rax
  8039cb:	48 89 dc             	mov    %rbx,%rsp
}
  8039ce:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8039d2:	5b                   	pop    %rbx
  8039d3:	41 5c                	pop    %r12
  8039d5:	41 5d                	pop    %r13
  8039d7:	5d                   	pop    %rbp
  8039d8:	c3                   	retq   

00000000008039d9 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8039d9:	55                   	push   %rbp
  8039da:	48 89 e5             	mov    %rsp,%rbp
  8039dd:	48 83 ec 50          	sub    $0x50,%rsp
  8039e1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8039e4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8039e8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8039ec:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039f3:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8039f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8039fb:	eb 33                	jmp    803a30 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8039fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a00:	48 98                	cltq   
  803a02:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a09:	00 
  803a0a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a0e:	48 01 d0             	add    %rdx,%rax
  803a11:	48 8b 00             	mov    (%rax),%rax
  803a14:	48 89 c7             	mov    %rax,%rdi
  803a17:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  803a1e:	00 00 00 
  803a21:	ff d0                	callq  *%rax
  803a23:	83 c0 01             	add    $0x1,%eax
  803a26:	48 98                	cltq   
  803a28:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803a2c:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803a30:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a33:	48 98                	cltq   
  803a35:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a3c:	00 
  803a3d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a41:	48 01 d0             	add    %rdx,%rax
  803a44:	48 8b 00             	mov    (%rax),%rax
  803a47:	48 85 c0             	test   %rax,%rax
  803a4a:	75 b1                	jne    8039fd <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803a4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a50:	48 f7 d8             	neg    %rax
  803a53:	48 05 00 10 40 00    	add    $0x401000,%rax
  803a59:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803a5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a61:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a69:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803a6d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a70:	83 c2 01             	add    $0x1,%edx
  803a73:	c1 e2 03             	shl    $0x3,%edx
  803a76:	48 63 d2             	movslq %edx,%rdx
  803a79:	48 f7 da             	neg    %rdx
  803a7c:	48 01 d0             	add    %rdx,%rax
  803a7f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803a83:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a87:	48 83 e8 10          	sub    $0x10,%rax
  803a8b:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803a91:	77 0a                	ja     803a9d <init_stack+0xc4>
		return -E_NO_MEM;
  803a93:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803a98:	e9 e3 01 00 00       	jmpq   803c80 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803a9d:	ba 07 00 00 00       	mov    $0x7,%edx
  803aa2:	be 00 00 40 00       	mov    $0x400000,%esi
  803aa7:	bf 00 00 00 00       	mov    $0x0,%edi
  803aac:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  803ab3:	00 00 00 
  803ab6:	ff d0                	callq  *%rax
  803ab8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803abb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803abf:	79 08                	jns    803ac9 <init_stack+0xf0>
		return r;
  803ac1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ac4:	e9 b7 01 00 00       	jmpq   803c80 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803ac9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803ad0:	e9 8a 00 00 00       	jmpq   803b5f <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803ad5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ad8:	48 98                	cltq   
  803ada:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803ae1:	00 
  803ae2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ae6:	48 01 c2             	add    %rax,%rdx
  803ae9:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803aee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803af2:	48 01 c8             	add    %rcx,%rax
  803af5:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803afb:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803afe:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b01:	48 98                	cltq   
  803b03:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b0a:	00 
  803b0b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b0f:	48 01 d0             	add    %rdx,%rax
  803b12:	48 8b 10             	mov    (%rax),%rdx
  803b15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b19:	48 89 d6             	mov    %rdx,%rsi
  803b1c:	48 89 c7             	mov    %rax,%rdi
  803b1f:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  803b26:	00 00 00 
  803b29:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803b2b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b2e:	48 98                	cltq   
  803b30:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b37:	00 
  803b38:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b3c:	48 01 d0             	add    %rdx,%rax
  803b3f:	48 8b 00             	mov    (%rax),%rax
  803b42:	48 89 c7             	mov    %rax,%rdi
  803b45:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  803b4c:	00 00 00 
  803b4f:	ff d0                	callq  *%rax
  803b51:	48 98                	cltq   
  803b53:	48 83 c0 01          	add    $0x1,%rax
  803b57:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803b5b:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803b5f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b62:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803b65:	0f 8c 6a ff ff ff    	jl     803ad5 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803b6b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b6e:	48 98                	cltq   
  803b70:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b77:	00 
  803b78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b7c:	48 01 d0             	add    %rdx,%rax
  803b7f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803b86:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803b8d:	00 
  803b8e:	74 35                	je     803bc5 <init_stack+0x1ec>
  803b90:	48 b9 f0 57 80 00 00 	movabs $0x8057f0,%rcx
  803b97:	00 00 00 
  803b9a:	48 ba 16 58 80 00 00 	movabs $0x805816,%rdx
  803ba1:	00 00 00 
  803ba4:	be f1 00 00 00       	mov    $0xf1,%esi
  803ba9:	48 bf b0 57 80 00 00 	movabs $0x8057b0,%rdi
  803bb0:	00 00 00 
  803bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb8:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803bbf:	00 00 00 
  803bc2:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803bc5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bc9:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803bcd:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803bd2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bd6:	48 01 c8             	add    %rcx,%rax
  803bd9:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803bdf:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803be2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803be6:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803bea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803bed:	48 98                	cltq   
  803bef:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803bf2:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803bf7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bfb:	48 01 d0             	add    %rdx,%rax
  803bfe:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803c04:	48 89 c2             	mov    %rax,%rdx
  803c07:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803c0b:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803c0e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803c11:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803c17:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803c1c:	89 c2                	mov    %eax,%edx
  803c1e:	be 00 00 40 00       	mov    $0x400000,%esi
  803c23:	bf 00 00 00 00       	mov    $0x0,%edi
  803c28:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  803c2f:	00 00 00 
  803c32:	ff d0                	callq  *%rax
  803c34:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c37:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c3b:	79 02                	jns    803c3f <init_stack+0x266>
		goto error;
  803c3d:	eb 28                	jmp    803c67 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803c3f:	be 00 00 40 00       	mov    $0x400000,%esi
  803c44:	bf 00 00 00 00       	mov    $0x0,%edi
  803c49:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  803c50:	00 00 00 
  803c53:	ff d0                	callq  *%rax
  803c55:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c58:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c5c:	79 02                	jns    803c60 <init_stack+0x287>
		goto error;
  803c5e:	eb 07                	jmp    803c67 <init_stack+0x28e>

	return 0;
  803c60:	b8 00 00 00 00       	mov    $0x0,%eax
  803c65:	eb 19                	jmp    803c80 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803c67:	be 00 00 40 00       	mov    $0x400000,%esi
  803c6c:	bf 00 00 00 00       	mov    $0x0,%edi
  803c71:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  803c78:	00 00 00 
  803c7b:	ff d0                	callq  *%rax
	return r;
  803c7d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c80:	c9                   	leaveq 
  803c81:	c3                   	retq   

0000000000803c82 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803c82:	55                   	push   %rbp
  803c83:	48 89 e5             	mov    %rsp,%rbp
  803c86:	48 83 ec 50          	sub    $0x50,%rsp
  803c8a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803c8d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c91:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803c95:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803c98:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803c9c:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803ca0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ca4:	25 ff 0f 00 00       	and    $0xfff,%eax
  803ca9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb0:	74 21                	je     803cd3 <map_segment+0x51>
		va -= i;
  803cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb5:	48 98                	cltq   
  803cb7:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803cbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cbe:	48 98                	cltq   
  803cc0:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803cc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc7:	48 98                	cltq   
  803cc9:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803ccd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd0:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803cd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cda:	e9 79 01 00 00       	jmpq   803e58 <map_segment+0x1d6>
		if (i >= filesz) {
  803cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce2:	48 98                	cltq   
  803ce4:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803ce8:	72 3c                	jb     803d26 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803cea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ced:	48 63 d0             	movslq %eax,%rdx
  803cf0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cf4:	48 01 d0             	add    %rdx,%rax
  803cf7:	48 89 c1             	mov    %rax,%rcx
  803cfa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803cfd:	8b 55 10             	mov    0x10(%rbp),%edx
  803d00:	48 89 ce             	mov    %rcx,%rsi
  803d03:	89 c7                	mov    %eax,%edi
  803d05:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  803d0c:	00 00 00 
  803d0f:	ff d0                	callq  *%rax
  803d11:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d14:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d18:	0f 89 33 01 00 00    	jns    803e51 <map_segment+0x1cf>
				return r;
  803d1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d21:	e9 46 01 00 00       	jmpq   803e6c <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803d26:	ba 07 00 00 00       	mov    $0x7,%edx
  803d2b:	be 00 00 40 00       	mov    $0x400000,%esi
  803d30:	bf 00 00 00 00       	mov    $0x0,%edi
  803d35:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  803d3c:	00 00 00 
  803d3f:	ff d0                	callq  *%rax
  803d41:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d44:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d48:	79 08                	jns    803d52 <map_segment+0xd0>
				return r;
  803d4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d4d:	e9 1a 01 00 00       	jmpq   803e6c <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803d52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d55:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803d58:	01 c2                	add    %eax,%edx
  803d5a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803d5d:	89 d6                	mov    %edx,%esi
  803d5f:	89 c7                	mov    %eax,%edi
  803d61:	48 b8 50 2b 80 00 00 	movabs $0x802b50,%rax
  803d68:	00 00 00 
  803d6b:	ff d0                	callq  *%rax
  803d6d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d70:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d74:	79 08                	jns    803d7e <map_segment+0xfc>
				return r;
  803d76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d79:	e9 ee 00 00 00       	jmpq   803e6c <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803d7e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803d85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d88:	48 98                	cltq   
  803d8a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803d8e:	48 29 c2             	sub    %rax,%rdx
  803d91:	48 89 d0             	mov    %rdx,%rax
  803d94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803d98:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803d9b:	48 63 d0             	movslq %eax,%rdx
  803d9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803da2:	48 39 c2             	cmp    %rax,%rdx
  803da5:	48 0f 47 d0          	cmova  %rax,%rdx
  803da9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803dac:	be 00 00 40 00       	mov    $0x400000,%esi
  803db1:	89 c7                	mov    %eax,%edi
  803db3:	48 b8 3a 2a 80 00 00 	movabs $0x802a3a,%rax
  803dba:	00 00 00 
  803dbd:	ff d0                	callq  *%rax
  803dbf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803dc2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803dc6:	79 08                	jns    803dd0 <map_segment+0x14e>
				return r;
  803dc8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dcb:	e9 9c 00 00 00       	jmpq   803e6c <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803dd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd3:	48 63 d0             	movslq %eax,%rdx
  803dd6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dda:	48 01 d0             	add    %rdx,%rax
  803ddd:	48 89 c2             	mov    %rax,%rdx
  803de0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803de3:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803de7:	48 89 d1             	mov    %rdx,%rcx
  803dea:	89 c2                	mov    %eax,%edx
  803dec:	be 00 00 40 00       	mov    $0x400000,%esi
  803df1:	bf 00 00 00 00       	mov    $0x0,%edi
  803df6:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  803dfd:	00 00 00 
  803e00:	ff d0                	callq  *%rax
  803e02:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803e05:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e09:	79 30                	jns    803e3b <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803e0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e0e:	89 c1                	mov    %eax,%ecx
  803e10:	48 ba 2b 58 80 00 00 	movabs $0x80582b,%rdx
  803e17:	00 00 00 
  803e1a:	be 24 01 00 00       	mov    $0x124,%esi
  803e1f:	48 bf b0 57 80 00 00 	movabs $0x8057b0,%rdi
  803e26:	00 00 00 
  803e29:	b8 00 00 00 00       	mov    $0x0,%eax
  803e2e:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803e35:	00 00 00 
  803e38:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803e3b:	be 00 00 40 00       	mov    $0x400000,%esi
  803e40:	bf 00 00 00 00       	mov    $0x0,%edi
  803e45:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  803e4c:	00 00 00 
  803e4f:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803e51:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803e58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e5b:	48 98                	cltq   
  803e5d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e61:	0f 82 78 fe ff ff    	jb     803cdf <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e6c:	c9                   	leaveq 
  803e6d:	c3                   	retq   

0000000000803e6e <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803e6e:	55                   	push   %rbp
  803e6f:	48 89 e5             	mov    %rsp,%rbp
  803e72:	48 83 ec 20          	sub    $0x20,%rsp
  803e76:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803e79:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  803e80:	00 
  803e81:	e9 c9 00 00 00       	jmpq   803f4f <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  803e86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e8a:	48 c1 e8 27          	shr    $0x27,%rax
  803e8e:	48 89 c2             	mov    %rax,%rdx
  803e91:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803e98:	01 00 00 
  803e9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e9f:	48 85 c0             	test   %rax,%rax
  803ea2:	74 3c                	je     803ee0 <copy_shared_pages+0x72>
  803ea4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ea8:	48 c1 e8 1e          	shr    $0x1e,%rax
  803eac:	48 89 c2             	mov    %rax,%rdx
  803eaf:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803eb6:	01 00 00 
  803eb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ebd:	48 85 c0             	test   %rax,%rax
  803ec0:	74 1e                	je     803ee0 <copy_shared_pages+0x72>
  803ec2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ec6:	48 c1 e8 15          	shr    $0x15,%rax
  803eca:	48 89 c2             	mov    %rax,%rdx
  803ecd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803ed4:	01 00 00 
  803ed7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803edb:	48 85 c0             	test   %rax,%rax
  803ede:	75 02                	jne    803ee2 <copy_shared_pages+0x74>
                continue;
  803ee0:	eb 65                	jmp    803f47 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803ee2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee6:	48 c1 e8 0c          	shr    $0xc,%rax
  803eea:	48 89 c2             	mov    %rax,%rdx
  803eed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ef4:	01 00 00 
  803ef7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803efb:	25 00 04 00 00       	and    $0x400,%eax
  803f00:	48 85 c0             	test   %rax,%rax
  803f03:	74 42                	je     803f47 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  803f05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f09:	48 c1 e8 0c          	shr    $0xc,%rax
  803f0d:	48 89 c2             	mov    %rax,%rdx
  803f10:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f17:	01 00 00 
  803f1a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f1e:	25 07 0e 00 00       	and    $0xe07,%eax
  803f23:	89 c6                	mov    %eax,%esi
  803f25:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803f29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f2d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f30:	41 89 f0             	mov    %esi,%r8d
  803f33:	48 89 c6             	mov    %rax,%rsi
  803f36:	bf 00 00 00 00       	mov    $0x0,%edi
  803f3b:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  803f42:	00 00 00 
  803f45:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803f47:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803f4e:	00 
  803f4f:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  803f56:	00 00 00 
  803f59:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803f5d:	0f 86 23 ff ff ff    	jbe    803e86 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  803f63:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  803f68:	c9                   	leaveq 
  803f69:	c3                   	retq   

0000000000803f6a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803f6a:	55                   	push   %rbp
  803f6b:	48 89 e5             	mov    %rsp,%rbp
  803f6e:	53                   	push   %rbx
  803f6f:	48 83 ec 38          	sub    $0x38,%rsp
  803f73:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f77:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803f7b:	48 89 c7             	mov    %rax,%rdi
  803f7e:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  803f85:	00 00 00 
  803f88:	ff d0                	callq  *%rax
  803f8a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f91:	0f 88 bf 01 00 00    	js     804156 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f9b:	ba 07 04 00 00       	mov    $0x407,%edx
  803fa0:	48 89 c6             	mov    %rax,%rsi
  803fa3:	bf 00 00 00 00       	mov    $0x0,%edi
  803fa8:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  803faf:	00 00 00 
  803fb2:	ff d0                	callq  *%rax
  803fb4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fbb:	0f 88 95 01 00 00    	js     804156 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803fc1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803fc5:	48 89 c7             	mov    %rax,%rdi
  803fc8:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  803fcf:	00 00 00 
  803fd2:	ff d0                	callq  *%rax
  803fd4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fdb:	0f 88 5d 01 00 00    	js     80413e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fe1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fe5:	ba 07 04 00 00       	mov    $0x407,%edx
  803fea:	48 89 c6             	mov    %rax,%rsi
  803fed:	bf 00 00 00 00       	mov    $0x0,%edi
  803ff2:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  803ff9:	00 00 00 
  803ffc:	ff d0                	callq  *%rax
  803ffe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804001:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804005:	0f 88 33 01 00 00    	js     80413e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80400b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80400f:	48 89 c7             	mov    %rax,%rdi
  804012:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  804019:	00 00 00 
  80401c:	ff d0                	callq  *%rax
  80401e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804022:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804026:	ba 07 04 00 00       	mov    $0x407,%edx
  80402b:	48 89 c6             	mov    %rax,%rsi
  80402e:	bf 00 00 00 00       	mov    $0x0,%edi
  804033:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  80403a:	00 00 00 
  80403d:	ff d0                	callq  *%rax
  80403f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804042:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804046:	79 05                	jns    80404d <pipe+0xe3>
		goto err2;
  804048:	e9 d9 00 00 00       	jmpq   804126 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80404d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804051:	48 89 c7             	mov    %rax,%rdi
  804054:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  80405b:	00 00 00 
  80405e:	ff d0                	callq  *%rax
  804060:	48 89 c2             	mov    %rax,%rdx
  804063:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804067:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80406d:	48 89 d1             	mov    %rdx,%rcx
  804070:	ba 00 00 00 00       	mov    $0x0,%edx
  804075:	48 89 c6             	mov    %rax,%rsi
  804078:	bf 00 00 00 00       	mov    $0x0,%edi
  80407d:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  804084:	00 00 00 
  804087:	ff d0                	callq  *%rax
  804089:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80408c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804090:	79 1b                	jns    8040ad <pipe+0x143>
		goto err3;
  804092:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804093:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804097:	48 89 c6             	mov    %rax,%rsi
  80409a:	bf 00 00 00 00       	mov    $0x0,%edi
  80409f:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  8040a6:	00 00 00 
  8040a9:	ff d0                	callq  *%rax
  8040ab:	eb 79                	jmp    804126 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8040ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040b1:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8040b8:	00 00 00 
  8040bb:	8b 12                	mov    (%rdx),%edx
  8040bd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8040bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8040ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040ce:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8040d5:	00 00 00 
  8040d8:	8b 12                	mov    (%rdx),%edx
  8040da:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8040dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040e0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8040e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040eb:	48 89 c7             	mov    %rax,%rdi
  8040ee:	48 b8 4d 24 80 00 00 	movabs $0x80244d,%rax
  8040f5:	00 00 00 
  8040f8:	ff d0                	callq  *%rax
  8040fa:	89 c2                	mov    %eax,%edx
  8040fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804100:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804102:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804106:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80410a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80410e:	48 89 c7             	mov    %rax,%rdi
  804111:	48 b8 4d 24 80 00 00 	movabs $0x80244d,%rax
  804118:	00 00 00 
  80411b:	ff d0                	callq  *%rax
  80411d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80411f:	b8 00 00 00 00       	mov    $0x0,%eax
  804124:	eb 33                	jmp    804159 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804126:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80412a:	48 89 c6             	mov    %rax,%rsi
  80412d:	bf 00 00 00 00       	mov    $0x0,%edi
  804132:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  804139:	00 00 00 
  80413c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80413e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804142:	48 89 c6             	mov    %rax,%rsi
  804145:	bf 00 00 00 00       	mov    $0x0,%edi
  80414a:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  804151:	00 00 00 
  804154:	ff d0                	callq  *%rax
err:
	return r;
  804156:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804159:	48 83 c4 38          	add    $0x38,%rsp
  80415d:	5b                   	pop    %rbx
  80415e:	5d                   	pop    %rbp
  80415f:	c3                   	retq   

0000000000804160 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804160:	55                   	push   %rbp
  804161:	48 89 e5             	mov    %rsp,%rbp
  804164:	53                   	push   %rbx
  804165:	48 83 ec 28          	sub    $0x28,%rsp
  804169:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80416d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804171:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804178:	00 00 00 
  80417b:	48 8b 00             	mov    (%rax),%rax
  80417e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804184:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804187:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80418b:	48 89 c7             	mov    %rax,%rdi
  80418e:	48 b8 f8 4e 80 00 00 	movabs $0x804ef8,%rax
  804195:	00 00 00 
  804198:	ff d0                	callq  *%rax
  80419a:	89 c3                	mov    %eax,%ebx
  80419c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041a0:	48 89 c7             	mov    %rax,%rdi
  8041a3:	48 b8 f8 4e 80 00 00 	movabs $0x804ef8,%rax
  8041aa:	00 00 00 
  8041ad:	ff d0                	callq  *%rax
  8041af:	39 c3                	cmp    %eax,%ebx
  8041b1:	0f 94 c0             	sete   %al
  8041b4:	0f b6 c0             	movzbl %al,%eax
  8041b7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8041ba:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8041c1:	00 00 00 
  8041c4:	48 8b 00             	mov    (%rax),%rax
  8041c7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8041cd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8041d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041d3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8041d6:	75 05                	jne    8041dd <_pipeisclosed+0x7d>
			return ret;
  8041d8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8041db:	eb 4f                	jmp    80422c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8041dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041e0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8041e3:	74 42                	je     804227 <_pipeisclosed+0xc7>
  8041e5:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8041e9:	75 3c                	jne    804227 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8041eb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8041f2:	00 00 00 
  8041f5:	48 8b 00             	mov    (%rax),%rax
  8041f8:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8041fe:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804201:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804204:	89 c6                	mov    %eax,%esi
  804206:	48 bf 52 58 80 00 00 	movabs $0x805852,%rdi
  80420d:	00 00 00 
  804210:	b8 00 00 00 00       	mov    $0x0,%eax
  804215:	49 b8 87 05 80 00 00 	movabs $0x800587,%r8
  80421c:	00 00 00 
  80421f:	41 ff d0             	callq  *%r8
	}
  804222:	e9 4a ff ff ff       	jmpq   804171 <_pipeisclosed+0x11>
  804227:	e9 45 ff ff ff       	jmpq   804171 <_pipeisclosed+0x11>
}
  80422c:	48 83 c4 28          	add    $0x28,%rsp
  804230:	5b                   	pop    %rbx
  804231:	5d                   	pop    %rbp
  804232:	c3                   	retq   

0000000000804233 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804233:	55                   	push   %rbp
  804234:	48 89 e5             	mov    %rsp,%rbp
  804237:	48 83 ec 30          	sub    $0x30,%rsp
  80423b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80423e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804242:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804245:	48 89 d6             	mov    %rdx,%rsi
  804248:	89 c7                	mov    %eax,%edi
  80424a:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  804251:	00 00 00 
  804254:	ff d0                	callq  *%rax
  804256:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804259:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80425d:	79 05                	jns    804264 <pipeisclosed+0x31>
		return r;
  80425f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804262:	eb 31                	jmp    804295 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804268:	48 89 c7             	mov    %rax,%rdi
  80426b:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  804272:	00 00 00 
  804275:	ff d0                	callq  *%rax
  804277:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80427b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80427f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804283:	48 89 d6             	mov    %rdx,%rsi
  804286:	48 89 c7             	mov    %rax,%rdi
  804289:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  804290:	00 00 00 
  804293:	ff d0                	callq  *%rax
}
  804295:	c9                   	leaveq 
  804296:	c3                   	retq   

0000000000804297 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804297:	55                   	push   %rbp
  804298:	48 89 e5             	mov    %rsp,%rbp
  80429b:	48 83 ec 40          	sub    $0x40,%rsp
  80429f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042a3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8042a7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8042ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042af:	48 89 c7             	mov    %rax,%rdi
  8042b2:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  8042b9:	00 00 00 
  8042bc:	ff d0                	callq  *%rax
  8042be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8042c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042c6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8042ca:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8042d1:	00 
  8042d2:	e9 92 00 00 00       	jmpq   804369 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8042d7:	eb 41                	jmp    80431a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8042d9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8042de:	74 09                	je     8042e9 <devpipe_read+0x52>
				return i;
  8042e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042e4:	e9 92 00 00 00       	jmpq   80437b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8042e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042f1:	48 89 d6             	mov    %rdx,%rsi
  8042f4:	48 89 c7             	mov    %rax,%rdi
  8042f7:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  8042fe:	00 00 00 
  804301:	ff d0                	callq  *%rax
  804303:	85 c0                	test   %eax,%eax
  804305:	74 07                	je     80430e <devpipe_read+0x77>
				return 0;
  804307:	b8 00 00 00 00       	mov    $0x0,%eax
  80430c:	eb 6d                	jmp    80437b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80430e:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804315:	00 00 00 
  804318:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80431a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431e:	8b 10                	mov    (%rax),%edx
  804320:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804324:	8b 40 04             	mov    0x4(%rax),%eax
  804327:	39 c2                	cmp    %eax,%edx
  804329:	74 ae                	je     8042d9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80432b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80432f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804333:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80433b:	8b 00                	mov    (%rax),%eax
  80433d:	99                   	cltd   
  80433e:	c1 ea 1b             	shr    $0x1b,%edx
  804341:	01 d0                	add    %edx,%eax
  804343:	83 e0 1f             	and    $0x1f,%eax
  804346:	29 d0                	sub    %edx,%eax
  804348:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80434c:	48 98                	cltq   
  80434e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804353:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804359:	8b 00                	mov    (%rax),%eax
  80435b:	8d 50 01             	lea    0x1(%rax),%edx
  80435e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804362:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804364:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80436d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804371:	0f 82 60 ff ff ff    	jb     8042d7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80437b:	c9                   	leaveq 
  80437c:	c3                   	retq   

000000000080437d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80437d:	55                   	push   %rbp
  80437e:	48 89 e5             	mov    %rsp,%rbp
  804381:	48 83 ec 40          	sub    $0x40,%rsp
  804385:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804389:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80438d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804395:	48 89 c7             	mov    %rax,%rdi
  804398:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  80439f:	00 00 00 
  8043a2:	ff d0                	callq  *%rax
  8043a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8043a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8043b0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8043b7:	00 
  8043b8:	e9 8e 00 00 00       	jmpq   80444b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8043bd:	eb 31                	jmp    8043f0 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8043bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043c7:	48 89 d6             	mov    %rdx,%rsi
  8043ca:	48 89 c7             	mov    %rax,%rdi
  8043cd:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  8043d4:	00 00 00 
  8043d7:	ff d0                	callq  *%rax
  8043d9:	85 c0                	test   %eax,%eax
  8043db:	74 07                	je     8043e4 <devpipe_write+0x67>
				return 0;
  8043dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8043e2:	eb 79                	jmp    80445d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8043e4:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  8043eb:	00 00 00 
  8043ee:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8043f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043f4:	8b 40 04             	mov    0x4(%rax),%eax
  8043f7:	48 63 d0             	movslq %eax,%rdx
  8043fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043fe:	8b 00                	mov    (%rax),%eax
  804400:	48 98                	cltq   
  804402:	48 83 c0 20          	add    $0x20,%rax
  804406:	48 39 c2             	cmp    %rax,%rdx
  804409:	73 b4                	jae    8043bf <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80440b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80440f:	8b 40 04             	mov    0x4(%rax),%eax
  804412:	99                   	cltd   
  804413:	c1 ea 1b             	shr    $0x1b,%edx
  804416:	01 d0                	add    %edx,%eax
  804418:	83 e0 1f             	and    $0x1f,%eax
  80441b:	29 d0                	sub    %edx,%eax
  80441d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804421:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804425:	48 01 ca             	add    %rcx,%rdx
  804428:	0f b6 0a             	movzbl (%rdx),%ecx
  80442b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80442f:	48 98                	cltq   
  804431:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804439:	8b 40 04             	mov    0x4(%rax),%eax
  80443c:	8d 50 01             	lea    0x1(%rax),%edx
  80443f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804443:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804446:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80444b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80444f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804453:	0f 82 64 ff ff ff    	jb     8043bd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804459:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80445d:	c9                   	leaveq 
  80445e:	c3                   	retq   

000000000080445f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80445f:	55                   	push   %rbp
  804460:	48 89 e5             	mov    %rsp,%rbp
  804463:	48 83 ec 20          	sub    $0x20,%rsp
  804467:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80446b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80446f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804473:	48 89 c7             	mov    %rax,%rdi
  804476:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  80447d:	00 00 00 
  804480:	ff d0                	callq  *%rax
  804482:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804486:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80448a:	48 be 65 58 80 00 00 	movabs $0x805865,%rsi
  804491:	00 00 00 
  804494:	48 89 c7             	mov    %rax,%rdi
  804497:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  80449e:	00 00 00 
  8044a1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8044a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a7:	8b 50 04             	mov    0x4(%rax),%edx
  8044aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044ae:	8b 00                	mov    (%rax),%eax
  8044b0:	29 c2                	sub    %eax,%edx
  8044b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044b6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8044bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044c0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8044c7:	00 00 00 
	stat->st_dev = &devpipe;
  8044ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044ce:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8044d5:	00 00 00 
  8044d8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8044df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044e4:	c9                   	leaveq 
  8044e5:	c3                   	retq   

00000000008044e6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8044e6:	55                   	push   %rbp
  8044e7:	48 89 e5             	mov    %rsp,%rbp
  8044ea:	48 83 ec 10          	sub    $0x10,%rsp
  8044ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8044f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f6:	48 89 c6             	mov    %rax,%rsi
  8044f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8044fe:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  804505:	00 00 00 
  804508:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80450a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80450e:	48 89 c7             	mov    %rax,%rdi
  804511:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  804518:	00 00 00 
  80451b:	ff d0                	callq  *%rax
  80451d:	48 89 c6             	mov    %rax,%rsi
  804520:	bf 00 00 00 00       	mov    $0x0,%edi
  804525:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  80452c:	00 00 00 
  80452f:	ff d0                	callq  *%rax
}
  804531:	c9                   	leaveq 
  804532:	c3                   	retq   

0000000000804533 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804533:	55                   	push   %rbp
  804534:	48 89 e5             	mov    %rsp,%rbp
  804537:	48 83 ec 20          	sub    $0x20,%rsp
  80453b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80453e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804542:	75 35                	jne    804579 <wait+0x46>
  804544:	48 b9 6c 58 80 00 00 	movabs $0x80586c,%rcx
  80454b:	00 00 00 
  80454e:	48 ba 77 58 80 00 00 	movabs $0x805877,%rdx
  804555:	00 00 00 
  804558:	be 09 00 00 00       	mov    $0x9,%esi
  80455d:	48 bf 8c 58 80 00 00 	movabs $0x80588c,%rdi
  804564:	00 00 00 
  804567:	b8 00 00 00 00       	mov    $0x0,%eax
  80456c:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  804573:	00 00 00 
  804576:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804579:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80457c:	25 ff 03 00 00       	and    $0x3ff,%eax
  804581:	48 98                	cltq   
  804583:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80458a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804591:	00 00 00 
  804594:	48 01 d0             	add    %rdx,%rax
  804597:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80459b:	eb 0c                	jmp    8045a9 <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  80459d:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  8045a4:	00 00 00 
  8045a7:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  8045a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045ad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8045b3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8045b6:	75 0e                	jne    8045c6 <wait+0x93>
  8045b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045bc:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8045c2:	85 c0                	test   %eax,%eax
  8045c4:	75 d7                	jne    80459d <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  8045c6:	c9                   	leaveq 
  8045c7:	c3                   	retq   

00000000008045c8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8045c8:	55                   	push   %rbp
  8045c9:	48 89 e5             	mov    %rsp,%rbp
  8045cc:	48 83 ec 20          	sub    $0x20,%rsp
  8045d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8045d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045d6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8045d9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8045dd:	be 01 00 00 00       	mov    $0x1,%esi
  8045e2:	48 89 c7             	mov    %rax,%rdi
  8045e5:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  8045ec:	00 00 00 
  8045ef:	ff d0                	callq  *%rax
}
  8045f1:	c9                   	leaveq 
  8045f2:	c3                   	retq   

00000000008045f3 <getchar>:

int
getchar(void)
{
  8045f3:	55                   	push   %rbp
  8045f4:	48 89 e5             	mov    %rsp,%rbp
  8045f7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8045fb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8045ff:	ba 01 00 00 00       	mov    $0x1,%edx
  804604:	48 89 c6             	mov    %rax,%rsi
  804607:	bf 00 00 00 00       	mov    $0x0,%edi
  80460c:	48 b8 65 29 80 00 00 	movabs $0x802965,%rax
  804613:	00 00 00 
  804616:	ff d0                	callq  *%rax
  804618:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80461b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80461f:	79 05                	jns    804626 <getchar+0x33>
		return r;
  804621:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804624:	eb 14                	jmp    80463a <getchar+0x47>
	if (r < 1)
  804626:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80462a:	7f 07                	jg     804633 <getchar+0x40>
		return -E_EOF;
  80462c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804631:	eb 07                	jmp    80463a <getchar+0x47>
	return c;
  804633:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804637:	0f b6 c0             	movzbl %al,%eax
}
  80463a:	c9                   	leaveq 
  80463b:	c3                   	retq   

000000000080463c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80463c:	55                   	push   %rbp
  80463d:	48 89 e5             	mov    %rsp,%rbp
  804640:	48 83 ec 20          	sub    $0x20,%rsp
  804644:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804647:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80464b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80464e:	48 89 d6             	mov    %rdx,%rsi
  804651:	89 c7                	mov    %eax,%edi
  804653:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  80465a:	00 00 00 
  80465d:	ff d0                	callq  *%rax
  80465f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804662:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804666:	79 05                	jns    80466d <iscons+0x31>
		return r;
  804668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80466b:	eb 1a                	jmp    804687 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80466d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804671:	8b 10                	mov    (%rax),%edx
  804673:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80467a:	00 00 00 
  80467d:	8b 00                	mov    (%rax),%eax
  80467f:	39 c2                	cmp    %eax,%edx
  804681:	0f 94 c0             	sete   %al
  804684:	0f b6 c0             	movzbl %al,%eax
}
  804687:	c9                   	leaveq 
  804688:	c3                   	retq   

0000000000804689 <opencons>:

int
opencons(void)
{
  804689:	55                   	push   %rbp
  80468a:	48 89 e5             	mov    %rsp,%rbp
  80468d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804691:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804695:	48 89 c7             	mov    %rax,%rdi
  804698:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  80469f:	00 00 00 
  8046a2:	ff d0                	callq  *%rax
  8046a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046ab:	79 05                	jns    8046b2 <opencons+0x29>
		return r;
  8046ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046b0:	eb 5b                	jmp    80470d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8046b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046b6:	ba 07 04 00 00       	mov    $0x407,%edx
  8046bb:	48 89 c6             	mov    %rax,%rsi
  8046be:	bf 00 00 00 00       	mov    $0x0,%edi
  8046c3:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  8046ca:	00 00 00 
  8046cd:	ff d0                	callq  *%rax
  8046cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046d6:	79 05                	jns    8046dd <opencons+0x54>
		return r;
  8046d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046db:	eb 30                	jmp    80470d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8046dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046e1:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8046e8:	00 00 00 
  8046eb:	8b 12                	mov    (%rdx),%edx
  8046ed:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8046ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8046fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046fe:	48 89 c7             	mov    %rax,%rdi
  804701:	48 b8 4d 24 80 00 00 	movabs $0x80244d,%rax
  804708:	00 00 00 
  80470b:	ff d0                	callq  *%rax
}
  80470d:	c9                   	leaveq 
  80470e:	c3                   	retq   

000000000080470f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80470f:	55                   	push   %rbp
  804710:	48 89 e5             	mov    %rsp,%rbp
  804713:	48 83 ec 30          	sub    $0x30,%rsp
  804717:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80471b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80471f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804723:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804728:	75 07                	jne    804731 <devcons_read+0x22>
		return 0;
  80472a:	b8 00 00 00 00       	mov    $0x0,%eax
  80472f:	eb 4b                	jmp    80477c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804731:	eb 0c                	jmp    80473f <devcons_read+0x30>
		sys_yield();
  804733:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  80473a:	00 00 00 
  80473d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80473f:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  804746:	00 00 00 
  804749:	ff d0                	callq  *%rax
  80474b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80474e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804752:	74 df                	je     804733 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804754:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804758:	79 05                	jns    80475f <devcons_read+0x50>
		return c;
  80475a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80475d:	eb 1d                	jmp    80477c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80475f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804763:	75 07                	jne    80476c <devcons_read+0x5d>
		return 0;
  804765:	b8 00 00 00 00       	mov    $0x0,%eax
  80476a:	eb 10                	jmp    80477c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80476c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80476f:	89 c2                	mov    %eax,%edx
  804771:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804775:	88 10                	mov    %dl,(%rax)
	return 1;
  804777:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80477c:	c9                   	leaveq 
  80477d:	c3                   	retq   

000000000080477e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80477e:	55                   	push   %rbp
  80477f:	48 89 e5             	mov    %rsp,%rbp
  804782:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804789:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804790:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804797:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80479e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8047a5:	eb 76                	jmp    80481d <devcons_write+0x9f>
		m = n - tot;
  8047a7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8047ae:	89 c2                	mov    %eax,%edx
  8047b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047b3:	29 c2                	sub    %eax,%edx
  8047b5:	89 d0                	mov    %edx,%eax
  8047b7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8047ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047bd:	83 f8 7f             	cmp    $0x7f,%eax
  8047c0:	76 07                	jbe    8047c9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8047c2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8047c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047cc:	48 63 d0             	movslq %eax,%rdx
  8047cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047d2:	48 63 c8             	movslq %eax,%rcx
  8047d5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8047dc:	48 01 c1             	add    %rax,%rcx
  8047df:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8047e6:	48 89 ce             	mov    %rcx,%rsi
  8047e9:	48 89 c7             	mov    %rax,%rdi
  8047ec:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8047f3:	00 00 00 
  8047f6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8047f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047fb:	48 63 d0             	movslq %eax,%rdx
  8047fe:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804805:	48 89 d6             	mov    %rdx,%rsi
  804808:	48 89 c7             	mov    %rax,%rdi
  80480b:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  804812:	00 00 00 
  804815:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804817:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80481a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80481d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804820:	48 98                	cltq   
  804822:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804829:	0f 82 78 ff ff ff    	jb     8047a7 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80482f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804832:	c9                   	leaveq 
  804833:	c3                   	retq   

0000000000804834 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804834:	55                   	push   %rbp
  804835:	48 89 e5             	mov    %rsp,%rbp
  804838:	48 83 ec 08          	sub    $0x8,%rsp
  80483c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804840:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804845:	c9                   	leaveq 
  804846:	c3                   	retq   

0000000000804847 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804847:	55                   	push   %rbp
  804848:	48 89 e5             	mov    %rsp,%rbp
  80484b:	48 83 ec 10          	sub    $0x10,%rsp
  80484f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804853:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804857:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80485b:	48 be 9c 58 80 00 00 	movabs $0x80589c,%rsi
  804862:	00 00 00 
  804865:	48 89 c7             	mov    %rax,%rdi
  804868:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  80486f:	00 00 00 
  804872:	ff d0                	callq  *%rax
	return 0;
  804874:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804879:	c9                   	leaveq 
  80487a:	c3                   	retq   

000000000080487b <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80487b:	55                   	push   %rbp
  80487c:	48 89 e5             	mov    %rsp,%rbp
  80487f:	48 83 ec 10          	sub    $0x10,%rsp
  804883:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804887:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  80488e:	00 00 00 
  804891:	48 8b 00             	mov    (%rax),%rax
  804894:	48 85 c0             	test   %rax,%rax
  804897:	0f 85 84 00 00 00    	jne    804921 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80489d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8048a4:	00 00 00 
  8048a7:	48 8b 00             	mov    (%rax),%rax
  8048aa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8048b0:	ba 07 00 00 00       	mov    $0x7,%edx
  8048b5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8048ba:	89 c7                	mov    %eax,%edi
  8048bc:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  8048c3:	00 00 00 
  8048c6:	ff d0                	callq  *%rax
  8048c8:	85 c0                	test   %eax,%eax
  8048ca:	79 2a                	jns    8048f6 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8048cc:	48 ba a8 58 80 00 00 	movabs $0x8058a8,%rdx
  8048d3:	00 00 00 
  8048d6:	be 23 00 00 00       	mov    $0x23,%esi
  8048db:	48 bf cf 58 80 00 00 	movabs $0x8058cf,%rdi
  8048e2:	00 00 00 
  8048e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8048ea:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  8048f1:	00 00 00 
  8048f4:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8048f6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8048fd:	00 00 00 
  804900:	48 8b 00             	mov    (%rax),%rax
  804903:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804909:	48 be 34 49 80 00 00 	movabs $0x804934,%rsi
  804910:	00 00 00 
  804913:	89 c7                	mov    %eax,%edi
  804915:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  80491c:	00 00 00 
  80491f:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804921:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804928:	00 00 00 
  80492b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80492f:	48 89 10             	mov    %rdx,(%rax)
}
  804932:	c9                   	leaveq 
  804933:	c3                   	retq   

0000000000804934 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804934:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804937:	48 a1 08 a0 80 00 00 	movabs 0x80a008,%rax
  80493e:	00 00 00 
call *%rax
  804941:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  804943:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80494a:	00 
movq 152(%rsp), %rcx  //Load RSP
  80494b:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804952:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  804953:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  804957:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  80495a:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804961:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  804962:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  804966:	4c 8b 3c 24          	mov    (%rsp),%r15
  80496a:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80496f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804974:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804979:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80497e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804983:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804988:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80498d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804992:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804997:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80499c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8049a1:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8049a6:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8049ab:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8049b0:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  8049b4:	48 83 c4 08          	add    $0x8,%rsp
popfq
  8049b8:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  8049b9:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  8049ba:	c3                   	retq   

00000000008049bb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8049bb:	55                   	push   %rbp
  8049bc:	48 89 e5             	mov    %rsp,%rbp
  8049bf:	48 83 ec 30          	sub    $0x30,%rsp
  8049c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8049c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8049cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8049cf:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8049d6:	00 00 00 
  8049d9:	48 8b 00             	mov    (%rax),%rax
  8049dc:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8049e2:	85 c0                	test   %eax,%eax
  8049e4:	75 34                	jne    804a1a <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8049e6:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  8049ed:	00 00 00 
  8049f0:	ff d0                	callq  *%rax
  8049f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8049f7:	48 98                	cltq   
  8049f9:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804a00:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804a07:	00 00 00 
  804a0a:	48 01 c2             	add    %rax,%rdx
  804a0d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a14:	00 00 00 
  804a17:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804a1a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a1f:	75 0e                	jne    804a2f <ipc_recv+0x74>
		pg = (void*) UTOP;
  804a21:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804a28:	00 00 00 
  804a2b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804a2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a33:	48 89 c7             	mov    %rax,%rdi
  804a36:	48 b8 94 1c 80 00 00 	movabs $0x801c94,%rax
  804a3d:	00 00 00 
  804a40:	ff d0                	callq  *%rax
  804a42:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804a45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a49:	79 19                	jns    804a64 <ipc_recv+0xa9>
		*from_env_store = 0;
  804a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a4f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a59:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804a5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a62:	eb 53                	jmp    804ab7 <ipc_recv+0xfc>
	}
	if(from_env_store)
  804a64:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804a69:	74 19                	je     804a84 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  804a6b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a72:	00 00 00 
  804a75:	48 8b 00             	mov    (%rax),%rax
  804a78:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804a7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a82:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804a84:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a89:	74 19                	je     804aa4 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  804a8b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a92:	00 00 00 
  804a95:	48 8b 00             	mov    (%rax),%rax
  804a98:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804aa2:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804aa4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804aab:	00 00 00 
  804aae:	48 8b 00             	mov    (%rax),%rax
  804ab1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804ab7:	c9                   	leaveq 
  804ab8:	c3                   	retq   

0000000000804ab9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804ab9:	55                   	push   %rbp
  804aba:	48 89 e5             	mov    %rsp,%rbp
  804abd:	48 83 ec 30          	sub    $0x30,%rsp
  804ac1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804ac4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804ac7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804acb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804ace:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804ad3:	75 0e                	jne    804ae3 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804ad5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804adc:	00 00 00 
  804adf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804ae3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804ae6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804ae9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804aed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804af0:	89 c7                	mov    %eax,%edi
  804af2:	48 b8 3f 1c 80 00 00 	movabs $0x801c3f,%rax
  804af9:	00 00 00 
  804afc:	ff d0                	callq  *%rax
  804afe:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804b01:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804b05:	75 0c                	jne    804b13 <ipc_send+0x5a>
			sys_yield();
  804b07:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804b0e:	00 00 00 
  804b11:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804b13:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804b17:	74 ca                	je     804ae3 <ipc_send+0x2a>
	if(result != 0)
  804b19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b1d:	74 20                	je     804b3f <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  804b1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b22:	89 c6                	mov    %eax,%esi
  804b24:	48 bf e0 58 80 00 00 	movabs $0x8058e0,%rdi
  804b2b:	00 00 00 
  804b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  804b33:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  804b3a:	00 00 00 
  804b3d:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  804b3f:	c9                   	leaveq 
  804b40:	c3                   	retq   

0000000000804b41 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804b41:	55                   	push   %rbp
  804b42:	48 89 e5             	mov    %rsp,%rbp
  804b45:	53                   	push   %rbx
  804b46:	48 83 ec 58          	sub    $0x58,%rsp
  804b4a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  804b4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804b52:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  804b56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  804b5d:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  804b64:	00 
  804b65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b69:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  804b6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b71:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  804b75:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804b79:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804b7d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804b81:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  804b85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b89:	48 c1 e8 27          	shr    $0x27,%rax
  804b8d:	48 89 c2             	mov    %rax,%rdx
  804b90:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804b97:	01 00 00 
  804b9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b9e:	83 e0 01             	and    $0x1,%eax
  804ba1:	48 85 c0             	test   %rax,%rax
  804ba4:	0f 85 91 00 00 00    	jne    804c3b <ipc_host_recv+0xfa>
  804baa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804bae:	48 c1 e8 1e          	shr    $0x1e,%rax
  804bb2:	48 89 c2             	mov    %rax,%rdx
  804bb5:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804bbc:	01 00 00 
  804bbf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804bc3:	83 e0 01             	and    $0x1,%eax
  804bc6:	48 85 c0             	test   %rax,%rax
  804bc9:	74 70                	je     804c3b <ipc_host_recv+0xfa>
  804bcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804bcf:	48 c1 e8 15          	shr    $0x15,%rax
  804bd3:	48 89 c2             	mov    %rax,%rdx
  804bd6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804bdd:	01 00 00 
  804be0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804be4:	83 e0 01             	and    $0x1,%eax
  804be7:	48 85 c0             	test   %rax,%rax
  804bea:	74 4f                	je     804c3b <ipc_host_recv+0xfa>
  804bec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804bf0:	48 c1 e8 0c          	shr    $0xc,%rax
  804bf4:	48 89 c2             	mov    %rax,%rdx
  804bf7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804bfe:	01 00 00 
  804c01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c05:	83 e0 01             	and    $0x1,%eax
  804c08:	48 85 c0             	test   %rax,%rax
  804c0b:	74 2e                	je     804c3b <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804c0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c11:	ba 07 04 00 00       	mov    $0x407,%edx
  804c16:	48 89 c6             	mov    %rax,%rsi
  804c19:	bf 00 00 00 00       	mov    $0x0,%edi
  804c1e:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  804c25:	00 00 00 
  804c28:	ff d0                	callq  *%rax
  804c2a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  804c2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804c31:	79 08                	jns    804c3b <ipc_host_recv+0xfa>
	    	return result;
  804c33:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804c36:	e9 84 00 00 00       	jmpq   804cbf <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  804c3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c3f:	48 c1 e8 0c          	shr    $0xc,%rax
  804c43:	48 89 c2             	mov    %rax,%rdx
  804c46:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804c4d:	01 00 00 
  804c50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c54:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804c5a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  804c5e:	b8 03 00 00 00       	mov    $0x3,%eax
  804c63:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  804c67:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  804c6b:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  804c6f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804c73:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  804c77:	4c 89 c3             	mov    %r8,%rbx
  804c7a:	0f 01 c1             	vmcall 
  804c7d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  804c80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804c84:	7e 36                	jle    804cbc <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  804c86:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804c89:	41 89 c0             	mov    %eax,%r8d
  804c8c:	b9 03 00 00 00       	mov    $0x3,%ecx
  804c91:	48 ba f8 58 80 00 00 	movabs $0x8058f8,%rdx
  804c98:	00 00 00 
  804c9b:	be 67 00 00 00       	mov    $0x67,%esi
  804ca0:	48 bf 25 59 80 00 00 	movabs $0x805925,%rdi
  804ca7:	00 00 00 
  804caa:	b8 00 00 00 00       	mov    $0x0,%eax
  804caf:	49 b9 4e 03 80 00 00 	movabs $0x80034e,%r9
  804cb6:	00 00 00 
  804cb9:	41 ff d1             	callq  *%r9
	return result;
  804cbc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  804cbf:	48 83 c4 58          	add    $0x58,%rsp
  804cc3:	5b                   	pop    %rbx
  804cc4:	5d                   	pop    %rbp
  804cc5:	c3                   	retq   

0000000000804cc6 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804cc6:	55                   	push   %rbp
  804cc7:	48 89 e5             	mov    %rsp,%rbp
  804cca:	53                   	push   %rbx
  804ccb:	48 83 ec 68          	sub    $0x68,%rsp
  804ccf:	89 7d ac             	mov    %edi,-0x54(%rbp)
  804cd2:	89 75 a8             	mov    %esi,-0x58(%rbp)
  804cd5:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  804cd9:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  804cdc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804ce0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  804ce4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  804ceb:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  804cf2:	00 
  804cf3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804cf7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  804cfb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804cff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804d03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d07:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804d0b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804d0f:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  804d13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d17:	48 c1 e8 27          	shr    $0x27,%rax
  804d1b:	48 89 c2             	mov    %rax,%rdx
  804d1e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804d25:	01 00 00 
  804d28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d2c:	83 e0 01             	and    $0x1,%eax
  804d2f:	48 85 c0             	test   %rax,%rax
  804d32:	0f 85 88 00 00 00    	jne    804dc0 <ipc_host_send+0xfa>
  804d38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d3c:	48 c1 e8 1e          	shr    $0x1e,%rax
  804d40:	48 89 c2             	mov    %rax,%rdx
  804d43:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804d4a:	01 00 00 
  804d4d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d51:	83 e0 01             	and    $0x1,%eax
  804d54:	48 85 c0             	test   %rax,%rax
  804d57:	74 67                	je     804dc0 <ipc_host_send+0xfa>
  804d59:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d5d:	48 c1 e8 15          	shr    $0x15,%rax
  804d61:	48 89 c2             	mov    %rax,%rdx
  804d64:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804d6b:	01 00 00 
  804d6e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d72:	83 e0 01             	and    $0x1,%eax
  804d75:	48 85 c0             	test   %rax,%rax
  804d78:	74 46                	je     804dc0 <ipc_host_send+0xfa>
  804d7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d7e:	48 c1 e8 0c          	shr    $0xc,%rax
  804d82:	48 89 c2             	mov    %rax,%rdx
  804d85:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804d8c:	01 00 00 
  804d8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d93:	83 e0 01             	and    $0x1,%eax
  804d96:	48 85 c0             	test   %rax,%rax
  804d99:	74 25                	je     804dc0 <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  804d9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d9f:	48 c1 e8 0c          	shr    $0xc,%rax
  804da3:	48 89 c2             	mov    %rax,%rdx
  804da6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804dad:	01 00 00 
  804db0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804db4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804dba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804dbe:	eb 0e                	jmp    804dce <ipc_host_send+0x108>
	else
		a3 = UTOP;
  804dc0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804dc7:	00 00 00 
  804dca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  804dce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804dd2:	48 89 c6             	mov    %rax,%rsi
  804dd5:	48 bf 2f 59 80 00 00 	movabs $0x80592f,%rdi
  804ddc:	00 00 00 
  804ddf:	b8 00 00 00 00       	mov    $0x0,%eax
  804de4:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  804deb:	00 00 00 
  804dee:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  804df0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  804df3:	48 98                	cltq   
  804df5:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  804df9:	8b 45 a8             	mov    -0x58(%rbp),%eax
  804dfc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  804e00:	8b 45 9c             	mov    -0x64(%rbp),%eax
  804e03:	48 98                	cltq   
  804e05:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  804e09:	b8 02 00 00 00       	mov    $0x2,%eax
  804e0e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  804e12:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  804e16:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  804e1a:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804e1e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  804e22:	4c 89 c3             	mov    %r8,%rbx
  804e25:	0f 01 c1             	vmcall 
  804e28:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  804e2b:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  804e2f:	75 0c                	jne    804e3d <ipc_host_send+0x177>
			sys_yield();
  804e31:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804e38:	00 00 00 
  804e3b:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  804e3d:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  804e41:	74 c6                	je     804e09 <ipc_host_send+0x143>
	
	if(result !=0)
  804e43:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  804e47:	74 36                	je     804e7f <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  804e49:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804e4c:	41 89 c0             	mov    %eax,%r8d
  804e4f:	b9 02 00 00 00       	mov    $0x2,%ecx
  804e54:	48 ba f8 58 80 00 00 	movabs $0x8058f8,%rdx
  804e5b:	00 00 00 
  804e5e:	be 94 00 00 00       	mov    $0x94,%esi
  804e63:	48 bf 25 59 80 00 00 	movabs $0x805925,%rdi
  804e6a:	00 00 00 
  804e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  804e72:	49 b9 4e 03 80 00 00 	movabs $0x80034e,%r9
  804e79:	00 00 00 
  804e7c:	41 ff d1             	callq  *%r9
}
  804e7f:	48 83 c4 68          	add    $0x68,%rsp
  804e83:	5b                   	pop    %rbx
  804e84:	5d                   	pop    %rbp
  804e85:	c3                   	retq   

0000000000804e86 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804e86:	55                   	push   %rbp
  804e87:	48 89 e5             	mov    %rsp,%rbp
  804e8a:	48 83 ec 14          	sub    $0x14,%rsp
  804e8e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804e98:	eb 4e                	jmp    804ee8 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804e9a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804ea1:	00 00 00 
  804ea4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ea7:	48 98                	cltq   
  804ea9:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804eb0:	48 01 d0             	add    %rdx,%rax
  804eb3:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804eb9:	8b 00                	mov    (%rax),%eax
  804ebb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804ebe:	75 24                	jne    804ee4 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804ec0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804ec7:	00 00 00 
  804eca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ecd:	48 98                	cltq   
  804ecf:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804ed6:	48 01 d0             	add    %rdx,%rax
  804ed9:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804edf:	8b 40 08             	mov    0x8(%rax),%eax
  804ee2:	eb 12                	jmp    804ef6 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804ee4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804ee8:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804eef:	7e a9                	jle    804e9a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804ef1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ef6:	c9                   	leaveq 
  804ef7:	c3                   	retq   

0000000000804ef8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804ef8:	55                   	push   %rbp
  804ef9:	48 89 e5             	mov    %rsp,%rbp
  804efc:	48 83 ec 18          	sub    $0x18,%rsp
  804f00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f08:	48 c1 e8 15          	shr    $0x15,%rax
  804f0c:	48 89 c2             	mov    %rax,%rdx
  804f0f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804f16:	01 00 00 
  804f19:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f1d:	83 e0 01             	and    $0x1,%eax
  804f20:	48 85 c0             	test   %rax,%rax
  804f23:	75 07                	jne    804f2c <pageref+0x34>
		return 0;
  804f25:	b8 00 00 00 00       	mov    $0x0,%eax
  804f2a:	eb 53                	jmp    804f7f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804f2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f30:	48 c1 e8 0c          	shr    $0xc,%rax
  804f34:	48 89 c2             	mov    %rax,%rdx
  804f37:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804f3e:	01 00 00 
  804f41:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f45:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804f49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f4d:	83 e0 01             	and    $0x1,%eax
  804f50:	48 85 c0             	test   %rax,%rax
  804f53:	75 07                	jne    804f5c <pageref+0x64>
		return 0;
  804f55:	b8 00 00 00 00       	mov    $0x0,%eax
  804f5a:	eb 23                	jmp    804f7f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804f5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f60:	48 c1 e8 0c          	shr    $0xc,%rax
  804f64:	48 89 c2             	mov    %rax,%rdx
  804f67:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804f6e:	00 00 00 
  804f71:	48 c1 e2 04          	shl    $0x4,%rdx
  804f75:	48 01 d0             	add    %rdx,%rax
  804f78:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804f7c:	0f b7 c0             	movzwl %ax,%eax
}
  804f7f:	c9                   	leaveq 
  804f80:	c3                   	retq   
