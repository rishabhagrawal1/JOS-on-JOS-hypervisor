
obj/user/testpteshare:     file format elf64-x86-64


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
  80008d:	48 ba 5e 4d 80 00 00 	movabs $0x804d5e,%rdx
  800094:	00 00 00 
  800097:	be 13 00 00 00       	mov    $0x13,%esi
  80009c:	48 bf 71 4d 80 00 00 	movabs $0x804d71,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 a2 22 80 00 00 	movabs $0x8022a2,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 85 4d 80 00 00 	movabs $0x804d85,%rdx
  8000d9:	00 00 00 
  8000dc:	be 17 00 00 00       	mov    $0x17,%esi
  8000e1:	48 bf 71 4d 80 00 00 	movabs $0x804d71,%rdi
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
  800135:	48 b8 31 46 80 00 00 	movabs $0x804631,%rax
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
  800166:	48 b8 8e 4d 80 00 00 	movabs $0x804d8e,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 94 4d 80 00 00 	movabs $0x804d94,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf 9a 4d 80 00 00 	movabs $0x804d9a,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba b5 4d 80 00 00 	movabs $0x804db5,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be b9 4d 80 00 00 	movabs $0x804db9,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf c6 4d 80 00 00 	movabs $0x804dc6,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 6f 38 80 00 00 	movabs $0x80386f,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba d8 4d 80 00 00 	movabs $0x804dd8,%rdx
  8001e4:	00 00 00 
  8001e7:	be 21 00 00 00       	mov    $0x21,%esi
  8001ec:	48 bf 71 4d 80 00 00 	movabs $0x804d71,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 31 46 80 00 00 	movabs $0x804631,%rax
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
  80023e:	48 b8 8e 4d 80 00 00 	movabs $0x804d8e,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 94 4d 80 00 00 	movabs $0x804d94,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf e2 4d 80 00 00 	movabs $0x804de2,%rdi
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
  80032f:	48 b8 8c 28 80 00 00 	movabs $0x80288c,%rax
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
  800408:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
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
  800444:	48 bf 2b 4e 80 00 00 	movabs $0x804e2b,%rdi
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
  8006f3:	48 ba 30 50 80 00 00 	movabs $0x805030,%rdx
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
  8009eb:	48 b8 58 50 80 00 00 	movabs $0x805058,%rax
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
  800b3e:	48 b8 80 4f 80 00 00 	movabs $0x804f80,%rax
  800b45:	00 00 00 
  800b48:	48 63 d3             	movslq %ebx,%rdx
  800b4b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b4f:	4d 85 e4             	test   %r12,%r12
  800b52:	75 2e                	jne    800b82 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b54:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5c:	89 d9                	mov    %ebx,%ecx
  800b5e:	48 ba 41 50 80 00 00 	movabs $0x805041,%rdx
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
  800b8d:	48 ba 4a 50 80 00 00 	movabs $0x80504a,%rdx
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
  800be7:	49 bc 4d 50 80 00 00 	movabs $0x80504d,%r12
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
  8018ed:	48 ba 08 53 80 00 00 	movabs $0x805308,%rdx
  8018f4:	00 00 00 
  8018f7:	be 23 00 00 00       	mov    $0x23,%esi
  8018fc:	48 bf 25 53 80 00 00 	movabs $0x805325,%rdi
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

0000000000801dbb <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801dbb:	55                   	push   %rbp
  801dbc:	48 89 e5             	mov    %rsp,%rbp
  801dbf:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801dc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dca:	00 
  801dcb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  801de1:	be 00 00 00 00       	mov    $0x0,%esi
  801de6:	bf 11 00 00 00       	mov    $0x11,%edi
  801deb:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801df2:	00 00 00 
  801df5:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801df7:	c9                   	leaveq 
  801df8:	c3                   	retq   

0000000000801df9 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801df9:	55                   	push   %rbp
  801dfa:	48 89 e5             	mov    %rsp,%rbp
  801dfd:	48 83 ec 10          	sub    $0x10,%rsp
  801e01:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801e04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e07:	48 98                	cltq   
  801e09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e10:	00 
  801e11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e22:	48 89 c2             	mov    %rax,%rdx
  801e25:	be 00 00 00 00       	mov    $0x0,%esi
  801e2a:	bf 12 00 00 00       	mov    $0x12,%edi
  801e2f:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801e36:	00 00 00 
  801e39:	ff d0                	callq  *%rax
}
  801e3b:	c9                   	leaveq 
  801e3c:	c3                   	retq   

0000000000801e3d <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801e3d:	55                   	push   %rbp
  801e3e:	48 89 e5             	mov    %rsp,%rbp
  801e41:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e4c:	00 
  801e4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e59:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e63:	be 00 00 00 00       	mov    $0x0,%esi
  801e68:	bf 13 00 00 00       	mov    $0x13,%edi
  801e6d:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	callq  *%rax
}
  801e79:	c9                   	leaveq 
  801e7a:	c3                   	retq   

0000000000801e7b <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801e7b:	55                   	push   %rbp
  801e7c:	48 89 e5             	mov    %rsp,%rbp
  801e7f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e83:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e8a:	00 
  801e8b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e91:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e97:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea1:	be 00 00 00 00       	mov    $0x0,%esi
  801ea6:	bf 14 00 00 00       	mov    $0x14,%edi
  801eab:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801eb2:	00 00 00 
  801eb5:	ff d0                	callq  *%rax
}
  801eb7:	c9                   	leaveq 
  801eb8:	c3                   	retq   

0000000000801eb9 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801eb9:	55                   	push   %rbp
  801eba:	48 89 e5             	mov    %rsp,%rbp
  801ebd:	48 83 ec 30          	sub    $0x30,%rsp
  801ec1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801ec5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec9:	48 8b 00             	mov    (%rax),%rax
  801ecc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801ed0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed4:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ed8:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801edb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ede:	83 e0 02             	and    $0x2,%eax
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	75 4d                	jne    801f32 <pgfault+0x79>
  801ee5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee9:	48 c1 e8 0c          	shr    $0xc,%rax
  801eed:	48 89 c2             	mov    %rax,%rdx
  801ef0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ef7:	01 00 00 
  801efa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801efe:	25 00 08 00 00       	and    $0x800,%eax
  801f03:	48 85 c0             	test   %rax,%rax
  801f06:	74 2a                	je     801f32 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801f08:	48 ba 38 53 80 00 00 	movabs $0x805338,%rdx
  801f0f:	00 00 00 
  801f12:	be 23 00 00 00       	mov    $0x23,%esi
  801f17:	48 bf 6d 53 80 00 00 	movabs $0x80536d,%rdi
  801f1e:	00 00 00 
  801f21:	b8 00 00 00 00       	mov    $0x0,%eax
  801f26:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801f2d:	00 00 00 
  801f30:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801f32:	ba 07 00 00 00       	mov    $0x7,%edx
  801f37:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f3c:	bf 00 00 00 00       	mov    $0x0,%edi
  801f41:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  801f48:	00 00 00 
  801f4b:	ff d0                	callq  *%rax
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	0f 85 cd 00 00 00    	jne    802022 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801f55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f61:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f67:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801f6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f6f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f74:	48 89 c6             	mov    %rax,%rsi
  801f77:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f7c:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  801f83:	00 00 00 
  801f86:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801f88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f8c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f92:	48 89 c1             	mov    %rax,%rcx
  801f95:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f9f:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa4:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  801fab:	00 00 00 
  801fae:	ff d0                	callq  *%rax
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	79 2a                	jns    801fde <pgfault+0x125>
				panic("Page map at temp address failed");
  801fb4:	48 ba 78 53 80 00 00 	movabs $0x805378,%rdx
  801fbb:	00 00 00 
  801fbe:	be 30 00 00 00       	mov    $0x30,%esi
  801fc3:	48 bf 6d 53 80 00 00 	movabs $0x80536d,%rdi
  801fca:	00 00 00 
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd2:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801fd9:	00 00 00 
  801fdc:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801fde:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fe3:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe8:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  801fef:	00 00 00 
  801ff2:	ff d0                	callq  *%rax
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	79 54                	jns    80204c <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801ff8:	48 ba 98 53 80 00 00 	movabs $0x805398,%rdx
  801fff:	00 00 00 
  802002:	be 32 00 00 00       	mov    $0x32,%esi
  802007:	48 bf 6d 53 80 00 00 	movabs $0x80536d,%rdi
  80200e:	00 00 00 
  802011:	b8 00 00 00 00       	mov    $0x0,%eax
  802016:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  80201d:	00 00 00 
  802020:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  802022:	48 ba c0 53 80 00 00 	movabs $0x8053c0,%rdx
  802029:	00 00 00 
  80202c:	be 34 00 00 00       	mov    $0x34,%esi
  802031:	48 bf 6d 53 80 00 00 	movabs $0x80536d,%rdi
  802038:	00 00 00 
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  802047:	00 00 00 
  80204a:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  80204c:	c9                   	leaveq 
  80204d:	c3                   	retq   

000000000080204e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80204e:	55                   	push   %rbp
  80204f:	48 89 e5             	mov    %rsp,%rbp
  802052:	48 83 ec 20          	sub    $0x20,%rsp
  802056:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802059:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  80205c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802063:	01 00 00 
  802066:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802069:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206d:	25 07 0e 00 00       	and    $0xe07,%eax
  802072:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802075:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802078:	48 c1 e0 0c          	shl    $0xc,%rax
  80207c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802083:	25 00 04 00 00       	and    $0x400,%eax
  802088:	85 c0                	test   %eax,%eax
  80208a:	74 57                	je     8020e3 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80208c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80208f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802093:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802096:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80209a:	41 89 f0             	mov    %esi,%r8d
  80209d:	48 89 c6             	mov    %rax,%rsi
  8020a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a5:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8020ac:	00 00 00 
  8020af:	ff d0                	callq  *%rax
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	0f 8e 52 01 00 00    	jle    80220b <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8020b9:	48 ba f2 53 80 00 00 	movabs $0x8053f2,%rdx
  8020c0:	00 00 00 
  8020c3:	be 4e 00 00 00       	mov    $0x4e,%esi
  8020c8:	48 bf 6d 53 80 00 00 	movabs $0x80536d,%rdi
  8020cf:	00 00 00 
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d7:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  8020de:	00 00 00 
  8020e1:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  8020e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e6:	83 e0 02             	and    $0x2,%eax
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	75 10                	jne    8020fd <duppage+0xaf>
  8020ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f0:	25 00 08 00 00       	and    $0x800,%eax
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	0f 84 bb 00 00 00    	je     8021b8 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  8020fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802100:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802105:	80 cc 08             	or     $0x8,%ah
  802108:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80210b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80210e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802112:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802115:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802119:	41 89 f0             	mov    %esi,%r8d
  80211c:	48 89 c6             	mov    %rax,%rsi
  80211f:	bf 00 00 00 00       	mov    $0x0,%edi
  802124:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  80212b:	00 00 00 
  80212e:	ff d0                	callq  *%rax
  802130:	85 c0                	test   %eax,%eax
  802132:	7e 2a                	jle    80215e <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802134:	48 ba f2 53 80 00 00 	movabs $0x8053f2,%rdx
  80213b:	00 00 00 
  80213e:	be 55 00 00 00       	mov    $0x55,%esi
  802143:	48 bf 6d 53 80 00 00 	movabs $0x80536d,%rdi
  80214a:	00 00 00 
  80214d:	b8 00 00 00 00       	mov    $0x0,%eax
  802152:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  802159:	00 00 00 
  80215c:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80215e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802161:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802165:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802169:	41 89 c8             	mov    %ecx,%r8d
  80216c:	48 89 d1             	mov    %rdx,%rcx
  80216f:	ba 00 00 00 00       	mov    $0x0,%edx
  802174:	48 89 c6             	mov    %rax,%rsi
  802177:	bf 00 00 00 00       	mov    $0x0,%edi
  80217c:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  802183:	00 00 00 
  802186:	ff d0                	callq  *%rax
  802188:	85 c0                	test   %eax,%eax
  80218a:	7e 2a                	jle    8021b6 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80218c:	48 ba f2 53 80 00 00 	movabs $0x8053f2,%rdx
  802193:	00 00 00 
  802196:	be 57 00 00 00       	mov    $0x57,%esi
  80219b:	48 bf 6d 53 80 00 00 	movabs $0x80536d,%rdi
  8021a2:	00 00 00 
  8021a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021aa:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  8021b1:	00 00 00 
  8021b4:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8021b6:	eb 53                	jmp    80220b <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8021b8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8021bb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8021bf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c6:	41 89 f0             	mov    %esi,%r8d
  8021c9:	48 89 c6             	mov    %rax,%rsi
  8021cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d1:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	7e 2a                	jle    80220b <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8021e1:	48 ba f2 53 80 00 00 	movabs $0x8053f2,%rdx
  8021e8:	00 00 00 
  8021eb:	be 5b 00 00 00       	mov    $0x5b,%esi
  8021f0:	48 bf 6d 53 80 00 00 	movabs $0x80536d,%rdi
  8021f7:	00 00 00 
  8021fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ff:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  802206:	00 00 00 
  802209:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80220b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802210:	c9                   	leaveq 
  802211:	c3                   	retq   

0000000000802212 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802212:	55                   	push   %rbp
  802213:	48 89 e5             	mov    %rsp,%rbp
  802216:	48 83 ec 18          	sub    $0x18,%rsp
  80221a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80221e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802222:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802226:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80222a:	48 c1 e8 27          	shr    $0x27,%rax
  80222e:	48 89 c2             	mov    %rax,%rdx
  802231:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802238:	01 00 00 
  80223b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223f:	83 e0 01             	and    $0x1,%eax
  802242:	48 85 c0             	test   %rax,%rax
  802245:	74 51                	je     802298 <pt_is_mapped+0x86>
  802247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80224b:	48 c1 e0 0c          	shl    $0xc,%rax
  80224f:	48 c1 e8 1e          	shr    $0x1e,%rax
  802253:	48 89 c2             	mov    %rax,%rdx
  802256:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80225d:	01 00 00 
  802260:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802264:	83 e0 01             	and    $0x1,%eax
  802267:	48 85 c0             	test   %rax,%rax
  80226a:	74 2c                	je     802298 <pt_is_mapped+0x86>
  80226c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802270:	48 c1 e0 0c          	shl    $0xc,%rax
  802274:	48 c1 e8 15          	shr    $0x15,%rax
  802278:	48 89 c2             	mov    %rax,%rdx
  80227b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802282:	01 00 00 
  802285:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802289:	83 e0 01             	and    $0x1,%eax
  80228c:	48 85 c0             	test   %rax,%rax
  80228f:	74 07                	je     802298 <pt_is_mapped+0x86>
  802291:	b8 01 00 00 00       	mov    $0x1,%eax
  802296:	eb 05                	jmp    80229d <pt_is_mapped+0x8b>
  802298:	b8 00 00 00 00       	mov    $0x0,%eax
  80229d:	83 e0 01             	and    $0x1,%eax
}
  8022a0:	c9                   	leaveq 
  8022a1:	c3                   	retq   

00000000008022a2 <fork>:

envid_t
fork(void)
{
  8022a2:	55                   	push   %rbp
  8022a3:	48 89 e5             	mov    %rsp,%rbp
  8022a6:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8022aa:	48 bf b9 1e 80 00 00 	movabs $0x801eb9,%rdi
  8022b1:	00 00 00 
  8022b4:	48 b8 79 49 80 00 00 	movabs $0x804979,%rax
  8022bb:	00 00 00 
  8022be:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8022c0:	b8 07 00 00 00       	mov    $0x7,%eax
  8022c5:	cd 30                	int    $0x30
  8022c7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8022ca:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8022cd:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8022d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8022d4:	79 30                	jns    802306 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8022d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022d9:	89 c1                	mov    %eax,%ecx
  8022db:	48 ba 10 54 80 00 00 	movabs $0x805410,%rdx
  8022e2:	00 00 00 
  8022e5:	be 86 00 00 00       	mov    $0x86,%esi
  8022ea:	48 bf 6d 53 80 00 00 	movabs $0x80536d,%rdi
  8022f1:	00 00 00 
  8022f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f9:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  802300:	00 00 00 
  802303:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802306:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80230a:	75 3e                	jne    80234a <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80230c:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  802313:	00 00 00 
  802316:	ff d0                	callq  *%rax
  802318:	25 ff 03 00 00       	and    $0x3ff,%eax
  80231d:	48 98                	cltq   
  80231f:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802326:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80232d:	00 00 00 
  802330:	48 01 c2             	add    %rax,%rdx
  802333:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80233a:	00 00 00 
  80233d:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802340:	b8 00 00 00 00       	mov    $0x0,%eax
  802345:	e9 d1 01 00 00       	jmpq   80251b <fork+0x279>
	}
	uint64_t ad = 0;
  80234a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802351:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802352:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802357:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80235b:	e9 df 00 00 00       	jmpq   80243f <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802364:	48 c1 e8 27          	shr    $0x27,%rax
  802368:	48 89 c2             	mov    %rax,%rdx
  80236b:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802372:	01 00 00 
  802375:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802379:	83 e0 01             	and    $0x1,%eax
  80237c:	48 85 c0             	test   %rax,%rax
  80237f:	0f 84 9e 00 00 00    	je     802423 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802389:	48 c1 e8 1e          	shr    $0x1e,%rax
  80238d:	48 89 c2             	mov    %rax,%rdx
  802390:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802397:	01 00 00 
  80239a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80239e:	83 e0 01             	and    $0x1,%eax
  8023a1:	48 85 c0             	test   %rax,%rax
  8023a4:	74 73                	je     802419 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  8023a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023aa:	48 c1 e8 15          	shr    $0x15,%rax
  8023ae:	48 89 c2             	mov    %rax,%rdx
  8023b1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023b8:	01 00 00 
  8023bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023bf:	83 e0 01             	and    $0x1,%eax
  8023c2:	48 85 c0             	test   %rax,%rax
  8023c5:	74 48                	je     80240f <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8023c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023cb:	48 c1 e8 0c          	shr    $0xc,%rax
  8023cf:	48 89 c2             	mov    %rax,%rdx
  8023d2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023d9:	01 00 00 
  8023dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8023e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e8:	83 e0 01             	and    $0x1,%eax
  8023eb:	48 85 c0             	test   %rax,%rax
  8023ee:	74 47                	je     802437 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8023f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f4:	48 c1 e8 0c          	shr    $0xc,%rax
  8023f8:	89 c2                	mov    %eax,%edx
  8023fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023fd:	89 d6                	mov    %edx,%esi
  8023ff:	89 c7                	mov    %eax,%edi
  802401:	48 b8 4e 20 80 00 00 	movabs $0x80204e,%rax
  802408:	00 00 00 
  80240b:	ff d0                	callq  *%rax
  80240d:	eb 28                	jmp    802437 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80240f:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802416:	00 
  802417:	eb 1e                	jmp    802437 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802419:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802420:	40 
  802421:	eb 14                	jmp    802437 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802427:	48 c1 e8 27          	shr    $0x27,%rax
  80242b:	48 83 c0 01          	add    $0x1,%rax
  80242f:	48 c1 e0 27          	shl    $0x27,%rax
  802433:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802437:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80243e:	00 
  80243f:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802446:	00 
  802447:	0f 87 13 ff ff ff    	ja     802360 <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80244d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802450:	ba 07 00 00 00       	mov    $0x7,%edx
  802455:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80245a:	89 c7                	mov    %eax,%edi
  80245c:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  802463:	00 00 00 
  802466:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802468:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80246b:	ba 07 00 00 00       	mov    $0x7,%edx
  802470:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802475:	89 c7                	mov    %eax,%edi
  802477:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  80247e:	00 00 00 
  802481:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802483:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802486:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80248c:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802491:	ba 00 00 00 00       	mov    $0x0,%edx
  802496:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80249b:	89 c7                	mov    %eax,%edi
  80249d:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8024a4:	00 00 00 
  8024a7:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8024a9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024ae:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8024b3:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8024b8:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8024bf:	00 00 00 
  8024c2:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8024c4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ce:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  8024d5:	00 00 00 
  8024d8:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8024da:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024e1:	00 00 00 
  8024e4:	48 8b 00             	mov    (%rax),%rax
  8024e7:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8024ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024f1:	48 89 d6             	mov    %rdx,%rsi
  8024f4:	89 c7                	mov    %eax,%edi
  8024f6:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  8024fd:	00 00 00 
  802500:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802502:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802505:	be 02 00 00 00       	mov    $0x2,%esi
  80250a:	89 c7                	mov    %eax,%edi
  80250c:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  802513:	00 00 00 
  802516:	ff d0                	callq  *%rax

	return envid;
  802518:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  80251b:	c9                   	leaveq 
  80251c:	c3                   	retq   

000000000080251d <sfork>:

	
// Challenge!
int
sfork(void)
{
  80251d:	55                   	push   %rbp
  80251e:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802521:	48 ba 28 54 80 00 00 	movabs $0x805428,%rdx
  802528:	00 00 00 
  80252b:	be bf 00 00 00       	mov    $0xbf,%esi
  802530:	48 bf 6d 53 80 00 00 	movabs $0x80536d,%rdi
  802537:	00 00 00 
  80253a:	b8 00 00 00 00       	mov    $0x0,%eax
  80253f:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  802546:	00 00 00 
  802549:	ff d1                	callq  *%rcx

000000000080254b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80254b:	55                   	push   %rbp
  80254c:	48 89 e5             	mov    %rsp,%rbp
  80254f:	48 83 ec 08          	sub    $0x8,%rsp
  802553:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802557:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80255b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802562:	ff ff ff 
  802565:	48 01 d0             	add    %rdx,%rax
  802568:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80256c:	c9                   	leaveq 
  80256d:	c3                   	retq   

000000000080256e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80256e:	55                   	push   %rbp
  80256f:	48 89 e5             	mov    %rsp,%rbp
  802572:	48 83 ec 08          	sub    $0x8,%rsp
  802576:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80257a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80257e:	48 89 c7             	mov    %rax,%rdi
  802581:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  802588:	00 00 00 
  80258b:	ff d0                	callq  *%rax
  80258d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802593:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802597:	c9                   	leaveq 
  802598:	c3                   	retq   

0000000000802599 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802599:	55                   	push   %rbp
  80259a:	48 89 e5             	mov    %rsp,%rbp
  80259d:	48 83 ec 18          	sub    $0x18,%rsp
  8025a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025ac:	eb 6b                	jmp    802619 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8025ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b1:	48 98                	cltq   
  8025b3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025b9:	48 c1 e0 0c          	shl    $0xc,%rax
  8025bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8025c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c5:	48 c1 e8 15          	shr    $0x15,%rax
  8025c9:	48 89 c2             	mov    %rax,%rdx
  8025cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025d3:	01 00 00 
  8025d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025da:	83 e0 01             	and    $0x1,%eax
  8025dd:	48 85 c0             	test   %rax,%rax
  8025e0:	74 21                	je     802603 <fd_alloc+0x6a>
  8025e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8025ea:	48 89 c2             	mov    %rax,%rdx
  8025ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025f4:	01 00 00 
  8025f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025fb:	83 e0 01             	and    $0x1,%eax
  8025fe:	48 85 c0             	test   %rax,%rax
  802601:	75 12                	jne    802615 <fd_alloc+0x7c>
			*fd_store = fd;
  802603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802607:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80260b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
  802613:	eb 1a                	jmp    80262f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802615:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802619:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80261d:	7e 8f                	jle    8025ae <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80261f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802623:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80262a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80262f:	c9                   	leaveq 
  802630:	c3                   	retq   

0000000000802631 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802631:	55                   	push   %rbp
  802632:	48 89 e5             	mov    %rsp,%rbp
  802635:	48 83 ec 20          	sub    $0x20,%rsp
  802639:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80263c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802640:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802644:	78 06                	js     80264c <fd_lookup+0x1b>
  802646:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80264a:	7e 07                	jle    802653 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80264c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802651:	eb 6c                	jmp    8026bf <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802653:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802656:	48 98                	cltq   
  802658:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80265e:	48 c1 e0 0c          	shl    $0xc,%rax
  802662:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802666:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80266a:	48 c1 e8 15          	shr    $0x15,%rax
  80266e:	48 89 c2             	mov    %rax,%rdx
  802671:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802678:	01 00 00 
  80267b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80267f:	83 e0 01             	and    $0x1,%eax
  802682:	48 85 c0             	test   %rax,%rax
  802685:	74 21                	je     8026a8 <fd_lookup+0x77>
  802687:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80268b:	48 c1 e8 0c          	shr    $0xc,%rax
  80268f:	48 89 c2             	mov    %rax,%rdx
  802692:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802699:	01 00 00 
  80269c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a0:	83 e0 01             	and    $0x1,%eax
  8026a3:	48 85 c0             	test   %rax,%rax
  8026a6:	75 07                	jne    8026af <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026ad:	eb 10                	jmp    8026bf <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8026af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026b7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8026ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026bf:	c9                   	leaveq 
  8026c0:	c3                   	retq   

00000000008026c1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8026c1:	55                   	push   %rbp
  8026c2:	48 89 e5             	mov    %rsp,%rbp
  8026c5:	48 83 ec 30          	sub    $0x30,%rsp
  8026c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026cd:	89 f0                	mov    %esi,%eax
  8026cf:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8026d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d6:	48 89 c7             	mov    %rax,%rdi
  8026d9:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	callq  *%rax
  8026e5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026e9:	48 89 d6             	mov    %rdx,%rsi
  8026ec:	89 c7                	mov    %eax,%edi
  8026ee:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  8026f5:	00 00 00 
  8026f8:	ff d0                	callq  *%rax
  8026fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802701:	78 0a                	js     80270d <fd_close+0x4c>
	    || fd != fd2)
  802703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802707:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80270b:	74 12                	je     80271f <fd_close+0x5e>
		return (must_exist ? r : 0);
  80270d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802711:	74 05                	je     802718 <fd_close+0x57>
  802713:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802716:	eb 05                	jmp    80271d <fd_close+0x5c>
  802718:	b8 00 00 00 00       	mov    $0x0,%eax
  80271d:	eb 69                	jmp    802788 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80271f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802723:	8b 00                	mov    (%rax),%eax
  802725:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802729:	48 89 d6             	mov    %rdx,%rsi
  80272c:	89 c7                	mov    %eax,%edi
  80272e:	48 b8 8a 27 80 00 00 	movabs $0x80278a,%rax
  802735:	00 00 00 
  802738:	ff d0                	callq  *%rax
  80273a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802741:	78 2a                	js     80276d <fd_close+0xac>
		if (dev->dev_close)
  802743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802747:	48 8b 40 20          	mov    0x20(%rax),%rax
  80274b:	48 85 c0             	test   %rax,%rax
  80274e:	74 16                	je     802766 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802754:	48 8b 40 20          	mov    0x20(%rax),%rax
  802758:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80275c:	48 89 d7             	mov    %rdx,%rdi
  80275f:	ff d0                	callq  *%rax
  802761:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802764:	eb 07                	jmp    80276d <fd_close+0xac>
		else
			r = 0;
  802766:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80276d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802771:	48 89 c6             	mov    %rax,%rsi
  802774:	bf 00 00 00 00       	mov    $0x0,%edi
  802779:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  802780:	00 00 00 
  802783:	ff d0                	callq  *%rax
	return r;
  802785:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802788:	c9                   	leaveq 
  802789:	c3                   	retq   

000000000080278a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80278a:	55                   	push   %rbp
  80278b:	48 89 e5             	mov    %rsp,%rbp
  80278e:	48 83 ec 20          	sub    $0x20,%rsp
  802792:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802795:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802799:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027a0:	eb 41                	jmp    8027e3 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8027a2:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8027a9:	00 00 00 
  8027ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027af:	48 63 d2             	movslq %edx,%rdx
  8027b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027b6:	8b 00                	mov    (%rax),%eax
  8027b8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8027bb:	75 22                	jne    8027df <dev_lookup+0x55>
			*dev = devtab[i];
  8027bd:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8027c4:	00 00 00 
  8027c7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027ca:	48 63 d2             	movslq %edx,%rdx
  8027cd:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8027d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027d5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027dd:	eb 60                	jmp    80283f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8027df:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027e3:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8027ea:	00 00 00 
  8027ed:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027f0:	48 63 d2             	movslq %edx,%rdx
  8027f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f7:	48 85 c0             	test   %rax,%rax
  8027fa:	75 a6                	jne    8027a2 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8027fc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802803:	00 00 00 
  802806:	48 8b 00             	mov    (%rax),%rax
  802809:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80280f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802812:	89 c6                	mov    %eax,%esi
  802814:	48 bf 40 54 80 00 00 	movabs $0x805440,%rdi
  80281b:	00 00 00 
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
  802823:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  80282a:	00 00 00 
  80282d:	ff d1                	callq  *%rcx
	*dev = 0;
  80282f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802833:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80283a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80283f:	c9                   	leaveq 
  802840:	c3                   	retq   

0000000000802841 <close>:

int
close(int fdnum)
{
  802841:	55                   	push   %rbp
  802842:	48 89 e5             	mov    %rsp,%rbp
  802845:	48 83 ec 20          	sub    $0x20,%rsp
  802849:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80284c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802850:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802853:	48 89 d6             	mov    %rdx,%rsi
  802856:	89 c7                	mov    %eax,%edi
  802858:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  80285f:	00 00 00 
  802862:	ff d0                	callq  *%rax
  802864:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802867:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286b:	79 05                	jns    802872 <close+0x31>
		return r;
  80286d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802870:	eb 18                	jmp    80288a <close+0x49>
	else
		return fd_close(fd, 1);
  802872:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802876:	be 01 00 00 00       	mov    $0x1,%esi
  80287b:	48 89 c7             	mov    %rax,%rdi
  80287e:	48 b8 c1 26 80 00 00 	movabs $0x8026c1,%rax
  802885:	00 00 00 
  802888:	ff d0                	callq  *%rax
}
  80288a:	c9                   	leaveq 
  80288b:	c3                   	retq   

000000000080288c <close_all>:

void
close_all(void)
{
  80288c:	55                   	push   %rbp
  80288d:	48 89 e5             	mov    %rsp,%rbp
  802890:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80289b:	eb 15                	jmp    8028b2 <close_all+0x26>
		close(i);
  80289d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a0:	89 c7                	mov    %eax,%edi
  8028a2:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  8028a9:	00 00 00 
  8028ac:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8028ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028b2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028b6:	7e e5                	jle    80289d <close_all+0x11>
		close(i);
}
  8028b8:	c9                   	leaveq 
  8028b9:	c3                   	retq   

00000000008028ba <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8028ba:	55                   	push   %rbp
  8028bb:	48 89 e5             	mov    %rsp,%rbp
  8028be:	48 83 ec 40          	sub    $0x40,%rsp
  8028c2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8028c5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8028c8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8028cc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8028cf:	48 89 d6             	mov    %rdx,%rsi
  8028d2:	89 c7                	mov    %eax,%edi
  8028d4:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  8028db:	00 00 00 
  8028de:	ff d0                	callq  *%rax
  8028e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e7:	79 08                	jns    8028f1 <dup+0x37>
		return r;
  8028e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ec:	e9 70 01 00 00       	jmpq   802a61 <dup+0x1a7>
	close(newfdnum);
  8028f1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028f4:	89 c7                	mov    %eax,%edi
  8028f6:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802902:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802905:	48 98                	cltq   
  802907:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80290d:	48 c1 e0 0c          	shl    $0xc,%rax
  802911:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802915:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802919:	48 89 c7             	mov    %rax,%rdi
  80291c:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  802923:	00 00 00 
  802926:	ff d0                	callq  *%rax
  802928:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80292c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802930:	48 89 c7             	mov    %rax,%rdi
  802933:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  80293a:	00 00 00 
  80293d:	ff d0                	callq  *%rax
  80293f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802943:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802947:	48 c1 e8 15          	shr    $0x15,%rax
  80294b:	48 89 c2             	mov    %rax,%rdx
  80294e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802955:	01 00 00 
  802958:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80295c:	83 e0 01             	and    $0x1,%eax
  80295f:	48 85 c0             	test   %rax,%rax
  802962:	74 73                	je     8029d7 <dup+0x11d>
  802964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802968:	48 c1 e8 0c          	shr    $0xc,%rax
  80296c:	48 89 c2             	mov    %rax,%rdx
  80296f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802976:	01 00 00 
  802979:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80297d:	83 e0 01             	and    $0x1,%eax
  802980:	48 85 c0             	test   %rax,%rax
  802983:	74 52                	je     8029d7 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802989:	48 c1 e8 0c          	shr    $0xc,%rax
  80298d:	48 89 c2             	mov    %rax,%rdx
  802990:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802997:	01 00 00 
  80299a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80299e:	25 07 0e 00 00       	and    $0xe07,%eax
  8029a3:	89 c1                	mov    %eax,%ecx
  8029a5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ad:	41 89 c8             	mov    %ecx,%r8d
  8029b0:	48 89 d1             	mov    %rdx,%rcx
  8029b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b8:	48 89 c6             	mov    %rax,%rsi
  8029bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c0:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8029c7:	00 00 00 
  8029ca:	ff d0                	callq  *%rax
  8029cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d3:	79 02                	jns    8029d7 <dup+0x11d>
			goto err;
  8029d5:	eb 57                	jmp    802a2e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8029d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029db:	48 c1 e8 0c          	shr    $0xc,%rax
  8029df:	48 89 c2             	mov    %rax,%rdx
  8029e2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029e9:	01 00 00 
  8029ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f0:	25 07 0e 00 00       	and    $0xe07,%eax
  8029f5:	89 c1                	mov    %eax,%ecx
  8029f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029ff:	41 89 c8             	mov    %ecx,%r8d
  802a02:	48 89 d1             	mov    %rdx,%rcx
  802a05:	ba 00 00 00 00       	mov    $0x0,%edx
  802a0a:	48 89 c6             	mov    %rax,%rsi
  802a0d:	bf 00 00 00 00       	mov    $0x0,%edi
  802a12:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  802a19:	00 00 00 
  802a1c:	ff d0                	callq  *%rax
  802a1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a25:	79 02                	jns    802a29 <dup+0x16f>
		goto err;
  802a27:	eb 05                	jmp    802a2e <dup+0x174>

	return newfdnum;
  802a29:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a2c:	eb 33                	jmp    802a61 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802a2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a32:	48 89 c6             	mov    %rax,%rsi
  802a35:	bf 00 00 00 00       	mov    $0x0,%edi
  802a3a:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  802a41:	00 00 00 
  802a44:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4a:	48 89 c6             	mov    %rax,%rsi
  802a4d:	bf 00 00 00 00       	mov    $0x0,%edi
  802a52:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
	return r;
  802a5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a61:	c9                   	leaveq 
  802a62:	c3                   	retq   

0000000000802a63 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a63:	55                   	push   %rbp
  802a64:	48 89 e5             	mov    %rsp,%rbp
  802a67:	48 83 ec 40          	sub    $0x40,%rsp
  802a6b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a6e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a72:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a76:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a7a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a7d:	48 89 d6             	mov    %rdx,%rsi
  802a80:	89 c7                	mov    %eax,%edi
  802a82:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  802a89:	00 00 00 
  802a8c:	ff d0                	callq  *%rax
  802a8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a95:	78 24                	js     802abb <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a9b:	8b 00                	mov    (%rax),%eax
  802a9d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aa1:	48 89 d6             	mov    %rdx,%rsi
  802aa4:	89 c7                	mov    %eax,%edi
  802aa6:	48 b8 8a 27 80 00 00 	movabs $0x80278a,%rax
  802aad:	00 00 00 
  802ab0:	ff d0                	callq  *%rax
  802ab2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab9:	79 05                	jns    802ac0 <read+0x5d>
		return r;
  802abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abe:	eb 76                	jmp    802b36 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802ac0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac4:	8b 40 08             	mov    0x8(%rax),%eax
  802ac7:	83 e0 03             	and    $0x3,%eax
  802aca:	83 f8 01             	cmp    $0x1,%eax
  802acd:	75 3a                	jne    802b09 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802acf:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802ad6:	00 00 00 
  802ad9:	48 8b 00             	mov    (%rax),%rax
  802adc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ae2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ae5:	89 c6                	mov    %eax,%esi
  802ae7:	48 bf 5f 54 80 00 00 	movabs $0x80545f,%rdi
  802aee:	00 00 00 
  802af1:	b8 00 00 00 00       	mov    $0x0,%eax
  802af6:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  802afd:	00 00 00 
  802b00:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b07:	eb 2d                	jmp    802b36 <read+0xd3>
	}
	if (!dev->dev_read)
  802b09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b11:	48 85 c0             	test   %rax,%rax
  802b14:	75 07                	jne    802b1d <read+0xba>
		return -E_NOT_SUPP;
  802b16:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b1b:	eb 19                	jmp    802b36 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b21:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b25:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b29:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b2d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b31:	48 89 cf             	mov    %rcx,%rdi
  802b34:	ff d0                	callq  *%rax
}
  802b36:	c9                   	leaveq 
  802b37:	c3                   	retq   

0000000000802b38 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b38:	55                   	push   %rbp
  802b39:	48 89 e5             	mov    %rsp,%rbp
  802b3c:	48 83 ec 30          	sub    $0x30,%rsp
  802b40:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b43:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b47:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b52:	eb 49                	jmp    802b9d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b57:	48 98                	cltq   
  802b59:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b5d:	48 29 c2             	sub    %rax,%rdx
  802b60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b63:	48 63 c8             	movslq %eax,%rcx
  802b66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b6a:	48 01 c1             	add    %rax,%rcx
  802b6d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b70:	48 89 ce             	mov    %rcx,%rsi
  802b73:	89 c7                	mov    %eax,%edi
  802b75:	48 b8 63 2a 80 00 00 	movabs $0x802a63,%rax
  802b7c:	00 00 00 
  802b7f:	ff d0                	callq  *%rax
  802b81:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b84:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b88:	79 05                	jns    802b8f <readn+0x57>
			return m;
  802b8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b8d:	eb 1c                	jmp    802bab <readn+0x73>
		if (m == 0)
  802b8f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b93:	75 02                	jne    802b97 <readn+0x5f>
			break;
  802b95:	eb 11                	jmp    802ba8 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b9a:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba0:	48 98                	cltq   
  802ba2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ba6:	72 ac                	jb     802b54 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802ba8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bab:	c9                   	leaveq 
  802bac:	c3                   	retq   

0000000000802bad <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802bad:	55                   	push   %rbp
  802bae:	48 89 e5             	mov    %rsp,%rbp
  802bb1:	48 83 ec 40          	sub    $0x40,%rsp
  802bb5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bb8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802bbc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bc0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bc4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bc7:	48 89 d6             	mov    %rdx,%rsi
  802bca:	89 c7                	mov    %eax,%edi
  802bcc:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  802bd3:	00 00 00 
  802bd6:	ff d0                	callq  *%rax
  802bd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bdf:	78 24                	js     802c05 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802be1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be5:	8b 00                	mov    (%rax),%eax
  802be7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802beb:	48 89 d6             	mov    %rdx,%rsi
  802bee:	89 c7                	mov    %eax,%edi
  802bf0:	48 b8 8a 27 80 00 00 	movabs $0x80278a,%rax
  802bf7:	00 00 00 
  802bfa:	ff d0                	callq  *%rax
  802bfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c03:	79 05                	jns    802c0a <write+0x5d>
		return r;
  802c05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c08:	eb 42                	jmp    802c4c <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0e:	8b 40 08             	mov    0x8(%rax),%eax
  802c11:	83 e0 03             	and    $0x3,%eax
  802c14:	85 c0                	test   %eax,%eax
  802c16:	75 07                	jne    802c1f <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802c18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c1d:	eb 2d                	jmp    802c4c <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c23:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c27:	48 85 c0             	test   %rax,%rax
  802c2a:	75 07                	jne    802c33 <write+0x86>
		return -E_NOT_SUPP;
  802c2c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c31:	eb 19                	jmp    802c4c <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802c33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c37:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c3b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c43:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c47:	48 89 cf             	mov    %rcx,%rdi
  802c4a:	ff d0                	callq  *%rax
}
  802c4c:	c9                   	leaveq 
  802c4d:	c3                   	retq   

0000000000802c4e <seek>:

int
seek(int fdnum, off_t offset)
{
  802c4e:	55                   	push   %rbp
  802c4f:	48 89 e5             	mov    %rsp,%rbp
  802c52:	48 83 ec 18          	sub    $0x18,%rsp
  802c56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c59:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c5c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c63:	48 89 d6             	mov    %rdx,%rsi
  802c66:	89 c7                	mov    %eax,%edi
  802c68:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  802c6f:	00 00 00 
  802c72:	ff d0                	callq  *%rax
  802c74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c7b:	79 05                	jns    802c82 <seek+0x34>
		return r;
  802c7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c80:	eb 0f                	jmp    802c91 <seek+0x43>
	fd->fd_offset = offset;
  802c82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c86:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c89:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c91:	c9                   	leaveq 
  802c92:	c3                   	retq   

0000000000802c93 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c93:	55                   	push   %rbp
  802c94:	48 89 e5             	mov    %rsp,%rbp
  802c97:	48 83 ec 30          	sub    $0x30,%rsp
  802c9b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c9e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ca1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ca5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ca8:	48 89 d6             	mov    %rdx,%rsi
  802cab:	89 c7                	mov    %eax,%edi
  802cad:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  802cb4:	00 00 00 
  802cb7:	ff d0                	callq  *%rax
  802cb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc0:	78 24                	js     802ce6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc6:	8b 00                	mov    (%rax),%eax
  802cc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ccc:	48 89 d6             	mov    %rdx,%rsi
  802ccf:	89 c7                	mov    %eax,%edi
  802cd1:	48 b8 8a 27 80 00 00 	movabs $0x80278a,%rax
  802cd8:	00 00 00 
  802cdb:	ff d0                	callq  *%rax
  802cdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce4:	79 05                	jns    802ceb <ftruncate+0x58>
		return r;
  802ce6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce9:	eb 72                	jmp    802d5d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ceb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cef:	8b 40 08             	mov    0x8(%rax),%eax
  802cf2:	83 e0 03             	and    $0x3,%eax
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	75 3a                	jne    802d33 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802cf9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d00:	00 00 00 
  802d03:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d06:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d0c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d0f:	89 c6                	mov    %eax,%esi
  802d11:	48 bf 80 54 80 00 00 	movabs $0x805480,%rdi
  802d18:	00 00 00 
  802d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d20:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  802d27:	00 00 00 
  802d2a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d31:	eb 2a                	jmp    802d5d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d37:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d3b:	48 85 c0             	test   %rax,%rax
  802d3e:	75 07                	jne    802d47 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d40:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d45:	eb 16                	jmp    802d5d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d53:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d56:	89 ce                	mov    %ecx,%esi
  802d58:	48 89 d7             	mov    %rdx,%rdi
  802d5b:	ff d0                	callq  *%rax
}
  802d5d:	c9                   	leaveq 
  802d5e:	c3                   	retq   

0000000000802d5f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d5f:	55                   	push   %rbp
  802d60:	48 89 e5             	mov    %rsp,%rbp
  802d63:	48 83 ec 30          	sub    $0x30,%rsp
  802d67:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d6a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d6e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d72:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d75:	48 89 d6             	mov    %rdx,%rsi
  802d78:	89 c7                	mov    %eax,%edi
  802d7a:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  802d81:	00 00 00 
  802d84:	ff d0                	callq  *%rax
  802d86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8d:	78 24                	js     802db3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d93:	8b 00                	mov    (%rax),%eax
  802d95:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d99:	48 89 d6             	mov    %rdx,%rsi
  802d9c:	89 c7                	mov    %eax,%edi
  802d9e:	48 b8 8a 27 80 00 00 	movabs $0x80278a,%rax
  802da5:	00 00 00 
  802da8:	ff d0                	callq  *%rax
  802daa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db1:	79 05                	jns    802db8 <fstat+0x59>
		return r;
  802db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db6:	eb 5e                	jmp    802e16 <fstat+0xb7>
	if (!dev->dev_stat)
  802db8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbc:	48 8b 40 28          	mov    0x28(%rax),%rax
  802dc0:	48 85 c0             	test   %rax,%rax
  802dc3:	75 07                	jne    802dcc <fstat+0x6d>
		return -E_NOT_SUPP;
  802dc5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dca:	eb 4a                	jmp    802e16 <fstat+0xb7>
	stat->st_name[0] = 0;
  802dcc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802dd3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802dde:	00 00 00 
	stat->st_isdir = 0;
  802de1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802de5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802dec:	00 00 00 
	stat->st_dev = dev;
  802def:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802df3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802df7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802dfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e02:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e0a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e0e:	48 89 ce             	mov    %rcx,%rsi
  802e11:	48 89 d7             	mov    %rdx,%rdi
  802e14:	ff d0                	callq  *%rax
}
  802e16:	c9                   	leaveq 
  802e17:	c3                   	retq   

0000000000802e18 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e18:	55                   	push   %rbp
  802e19:	48 89 e5             	mov    %rsp,%rbp
  802e1c:	48 83 ec 20          	sub    $0x20,%rsp
  802e20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2c:	be 00 00 00 00       	mov    $0x0,%esi
  802e31:	48 89 c7             	mov    %rax,%rdi
  802e34:	48 b8 06 2f 80 00 00 	movabs $0x802f06,%rax
  802e3b:	00 00 00 
  802e3e:	ff d0                	callq  *%rax
  802e40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e47:	79 05                	jns    802e4e <stat+0x36>
		return fd;
  802e49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4c:	eb 2f                	jmp    802e7d <stat+0x65>
	r = fstat(fd, stat);
  802e4e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e55:	48 89 d6             	mov    %rdx,%rsi
  802e58:	89 c7                	mov    %eax,%edi
  802e5a:	48 b8 5f 2d 80 00 00 	movabs $0x802d5f,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	callq  *%rax
  802e66:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6c:	89 c7                	mov    %eax,%edi
  802e6e:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802e75:	00 00 00 
  802e78:	ff d0                	callq  *%rax
	return r;
  802e7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e7d:	c9                   	leaveq 
  802e7e:	c3                   	retq   

0000000000802e7f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e7f:	55                   	push   %rbp
  802e80:	48 89 e5             	mov    %rsp,%rbp
  802e83:	48 83 ec 10          	sub    $0x10,%rsp
  802e87:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e8a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e8e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e95:	00 00 00 
  802e98:	8b 00                	mov    (%rax),%eax
  802e9a:	85 c0                	test   %eax,%eax
  802e9c:	75 1d                	jne    802ebb <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e9e:	bf 01 00 00 00       	mov    $0x1,%edi
  802ea3:	48 b8 3f 4c 80 00 00 	movabs $0x804c3f,%rax
  802eaa:	00 00 00 
  802ead:	ff d0                	callq  *%rax
  802eaf:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802eb6:	00 00 00 
  802eb9:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ebb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ec2:	00 00 00 
  802ec5:	8b 00                	mov    (%rax),%eax
  802ec7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802eca:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ecf:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802ed6:	00 00 00 
  802ed9:	89 c7                	mov    %eax,%edi
  802edb:	48 b8 b7 4b 80 00 00 	movabs $0x804bb7,%rax
  802ee2:	00 00 00 
  802ee5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ee7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eeb:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef0:	48 89 c6             	mov    %rax,%rsi
  802ef3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ef8:	48 b8 b9 4a 80 00 00 	movabs $0x804ab9,%rax
  802eff:	00 00 00 
  802f02:	ff d0                	callq  *%rax
}
  802f04:	c9                   	leaveq 
  802f05:	c3                   	retq   

0000000000802f06 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f06:	55                   	push   %rbp
  802f07:	48 89 e5             	mov    %rsp,%rbp
  802f0a:	48 83 ec 30          	sub    $0x30,%rsp
  802f0e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f12:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802f15:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802f1c:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802f23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802f2a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802f2f:	75 08                	jne    802f39 <open+0x33>
	{
		return r;
  802f31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f34:	e9 f2 00 00 00       	jmpq   80302b <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802f39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f3d:	48 89 c7             	mov    %rax,%rdi
  802f40:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  802f47:	00 00 00 
  802f4a:	ff d0                	callq  *%rax
  802f4c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802f4f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802f56:	7e 0a                	jle    802f62 <open+0x5c>
	{
		return -E_BAD_PATH;
  802f58:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f5d:	e9 c9 00 00 00       	jmpq   80302b <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802f62:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802f69:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802f6a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802f6e:	48 89 c7             	mov    %rax,%rdi
  802f71:	48 b8 99 25 80 00 00 	movabs $0x802599,%rax
  802f78:	00 00 00 
  802f7b:	ff d0                	callq  *%rax
  802f7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f84:	78 09                	js     802f8f <open+0x89>
  802f86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8a:	48 85 c0             	test   %rax,%rax
  802f8d:	75 08                	jne    802f97 <open+0x91>
		{
			return r;
  802f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f92:	e9 94 00 00 00       	jmpq   80302b <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802f97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9b:	ba 00 04 00 00       	mov    $0x400,%edx
  802fa0:	48 89 c6             	mov    %rax,%rsi
  802fa3:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802faa:	00 00 00 
  802fad:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  802fb4:	00 00 00 
  802fb7:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802fb9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fc0:	00 00 00 
  802fc3:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802fc6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802fcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd0:	48 89 c6             	mov    %rax,%rsi
  802fd3:	bf 01 00 00 00       	mov    $0x1,%edi
  802fd8:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  802fdf:	00 00 00 
  802fe2:	ff d0                	callq  *%rax
  802fe4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802feb:	79 2b                	jns    803018 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff1:	be 00 00 00 00       	mov    $0x0,%esi
  802ff6:	48 89 c7             	mov    %rax,%rdi
  802ff9:	48 b8 c1 26 80 00 00 	movabs $0x8026c1,%rax
  803000:	00 00 00 
  803003:	ff d0                	callq  *%rax
  803005:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803008:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80300c:	79 05                	jns    803013 <open+0x10d>
			{
				return d;
  80300e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803011:	eb 18                	jmp    80302b <open+0x125>
			}
			return r;
  803013:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803016:	eb 13                	jmp    80302b <open+0x125>
		}	
		return fd2num(fd_store);
  803018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301c:	48 89 c7             	mov    %rax,%rdi
  80301f:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  803026:	00 00 00 
  803029:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80302b:	c9                   	leaveq 
  80302c:	c3                   	retq   

000000000080302d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80302d:	55                   	push   %rbp
  80302e:	48 89 e5             	mov    %rsp,%rbp
  803031:	48 83 ec 10          	sub    $0x10,%rsp
  803035:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803039:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80303d:	8b 50 0c             	mov    0xc(%rax),%edx
  803040:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803047:	00 00 00 
  80304a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80304c:	be 00 00 00 00       	mov    $0x0,%esi
  803051:	bf 06 00 00 00       	mov    $0x6,%edi
  803056:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  80305d:	00 00 00 
  803060:	ff d0                	callq  *%rax
}
  803062:	c9                   	leaveq 
  803063:	c3                   	retq   

0000000000803064 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803064:	55                   	push   %rbp
  803065:	48 89 e5             	mov    %rsp,%rbp
  803068:	48 83 ec 30          	sub    $0x30,%rsp
  80306c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803070:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803074:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80307f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803084:	74 07                	je     80308d <devfile_read+0x29>
  803086:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80308b:	75 07                	jne    803094 <devfile_read+0x30>
		return -E_INVAL;
  80308d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803092:	eb 77                	jmp    80310b <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803098:	8b 50 0c             	mov    0xc(%rax),%edx
  80309b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030a2:	00 00 00 
  8030a5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8030a7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030ae:	00 00 00 
  8030b1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030b5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8030b9:	be 00 00 00 00       	mov    $0x0,%esi
  8030be:	bf 03 00 00 00       	mov    $0x3,%edi
  8030c3:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  8030ca:	00 00 00 
  8030cd:	ff d0                	callq  *%rax
  8030cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d6:	7f 05                	jg     8030dd <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8030d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030db:	eb 2e                	jmp    80310b <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8030dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e0:	48 63 d0             	movslq %eax,%rdx
  8030e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030e7:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8030ee:	00 00 00 
  8030f1:	48 89 c7             	mov    %rax,%rdi
  8030f4:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8030fb:	00 00 00 
  8030fe:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803100:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803104:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803108:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80310b:	c9                   	leaveq 
  80310c:	c3                   	retq   

000000000080310d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80310d:	55                   	push   %rbp
  80310e:	48 89 e5             	mov    %rsp,%rbp
  803111:	48 83 ec 30          	sub    $0x30,%rsp
  803115:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803119:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80311d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803121:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803128:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80312d:	74 07                	je     803136 <devfile_write+0x29>
  80312f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803134:	75 08                	jne    80313e <devfile_write+0x31>
		return r;
  803136:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803139:	e9 9a 00 00 00       	jmpq   8031d8 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80313e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803142:	8b 50 0c             	mov    0xc(%rax),%edx
  803145:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80314c:	00 00 00 
  80314f:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803151:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803158:	00 
  803159:	76 08                	jbe    803163 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80315b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803162:	00 
	}
	fsipcbuf.write.req_n = n;
  803163:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80316a:	00 00 00 
  80316d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803171:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803175:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803179:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317d:	48 89 c6             	mov    %rax,%rsi
  803180:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803187:	00 00 00 
  80318a:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  803191:	00 00 00 
  803194:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803196:	be 00 00 00 00       	mov    $0x0,%esi
  80319b:	bf 04 00 00 00       	mov    $0x4,%edi
  8031a0:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  8031a7:	00 00 00 
  8031aa:	ff d0                	callq  *%rax
  8031ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b3:	7f 20                	jg     8031d5 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8031b5:	48 bf a6 54 80 00 00 	movabs $0x8054a6,%rdi
  8031bc:	00 00 00 
  8031bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c4:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  8031cb:	00 00 00 
  8031ce:	ff d2                	callq  *%rdx
		return r;
  8031d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d3:	eb 03                	jmp    8031d8 <devfile_write+0xcb>
	}
	return r;
  8031d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8031d8:	c9                   	leaveq 
  8031d9:	c3                   	retq   

00000000008031da <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8031da:	55                   	push   %rbp
  8031db:	48 89 e5             	mov    %rsp,%rbp
  8031de:	48 83 ec 20          	sub    $0x20,%rsp
  8031e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8031ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ee:	8b 50 0c             	mov    0xc(%rax),%edx
  8031f1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031f8:	00 00 00 
  8031fb:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031fd:	be 00 00 00 00       	mov    $0x0,%esi
  803202:	bf 05 00 00 00       	mov    $0x5,%edi
  803207:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  80320e:	00 00 00 
  803211:	ff d0                	callq  *%rax
  803213:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321a:	79 05                	jns    803221 <devfile_stat+0x47>
		return r;
  80321c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80321f:	eb 56                	jmp    803277 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803221:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803225:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80322c:	00 00 00 
  80322f:	48 89 c7             	mov    %rax,%rdi
  803232:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  803239:	00 00 00 
  80323c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80323e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803245:	00 00 00 
  803248:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80324e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803252:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803258:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80325f:	00 00 00 
  803262:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803268:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80326c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803272:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803277:	c9                   	leaveq 
  803278:	c3                   	retq   

0000000000803279 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803279:	55                   	push   %rbp
  80327a:	48 89 e5             	mov    %rsp,%rbp
  80327d:	48 83 ec 10          	sub    $0x10,%rsp
  803281:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803285:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803288:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80328c:	8b 50 0c             	mov    0xc(%rax),%edx
  80328f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803296:	00 00 00 
  803299:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80329b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032a2:	00 00 00 
  8032a5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8032a8:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8032ab:	be 00 00 00 00       	mov    $0x0,%esi
  8032b0:	bf 02 00 00 00       	mov    $0x2,%edi
  8032b5:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  8032bc:	00 00 00 
  8032bf:	ff d0                	callq  *%rax
}
  8032c1:	c9                   	leaveq 
  8032c2:	c3                   	retq   

00000000008032c3 <remove>:

// Delete a file
int
remove(const char *path)
{
  8032c3:	55                   	push   %rbp
  8032c4:	48 89 e5             	mov    %rsp,%rbp
  8032c7:	48 83 ec 10          	sub    $0x10,%rsp
  8032cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8032cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032d3:	48 89 c7             	mov    %rax,%rdi
  8032d6:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  8032dd:	00 00 00 
  8032e0:	ff d0                	callq  *%rax
  8032e2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032e7:	7e 07                	jle    8032f0 <remove+0x2d>
		return -E_BAD_PATH;
  8032e9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032ee:	eb 33                	jmp    803323 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8032f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032f4:	48 89 c6             	mov    %rax,%rsi
  8032f7:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8032fe:	00 00 00 
  803301:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80330d:	be 00 00 00 00       	mov    $0x0,%esi
  803312:	bf 07 00 00 00       	mov    $0x7,%edi
  803317:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  80331e:	00 00 00 
  803321:	ff d0                	callq  *%rax
}
  803323:	c9                   	leaveq 
  803324:	c3                   	retq   

0000000000803325 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803325:	55                   	push   %rbp
  803326:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803329:	be 00 00 00 00       	mov    $0x0,%esi
  80332e:	bf 08 00 00 00       	mov    $0x8,%edi
  803333:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
}
  80333f:	5d                   	pop    %rbp
  803340:	c3                   	retq   

0000000000803341 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803341:	55                   	push   %rbp
  803342:	48 89 e5             	mov    %rsp,%rbp
  803345:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80334c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803353:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80335a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803361:	be 00 00 00 00       	mov    $0x0,%esi
  803366:	48 89 c7             	mov    %rax,%rdi
  803369:	48 b8 06 2f 80 00 00 	movabs $0x802f06,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
  803375:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803378:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337c:	79 28                	jns    8033a6 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80337e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803381:	89 c6                	mov    %eax,%esi
  803383:	48 bf c2 54 80 00 00 	movabs $0x8054c2,%rdi
  80338a:	00 00 00 
  80338d:	b8 00 00 00 00       	mov    $0x0,%eax
  803392:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  803399:	00 00 00 
  80339c:	ff d2                	callq  *%rdx
		return fd_src;
  80339e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a1:	e9 74 01 00 00       	jmpq   80351a <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8033a6:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8033ad:	be 01 01 00 00       	mov    $0x101,%esi
  8033b2:	48 89 c7             	mov    %rax,%rdi
  8033b5:	48 b8 06 2f 80 00 00 	movabs $0x802f06,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
  8033c1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8033c4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033c8:	79 39                	jns    803403 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8033ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033cd:	89 c6                	mov    %eax,%esi
  8033cf:	48 bf d8 54 80 00 00 	movabs $0x8054d8,%rdi
  8033d6:	00 00 00 
  8033d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033de:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  8033e5:	00 00 00 
  8033e8:	ff d2                	callq  *%rdx
		close(fd_src);
  8033ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ed:	89 c7                	mov    %eax,%edi
  8033ef:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  8033f6:	00 00 00 
  8033f9:	ff d0                	callq  *%rax
		return fd_dest;
  8033fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033fe:	e9 17 01 00 00       	jmpq   80351a <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803403:	eb 74                	jmp    803479 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803405:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803408:	48 63 d0             	movslq %eax,%rdx
  80340b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803412:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803415:	48 89 ce             	mov    %rcx,%rsi
  803418:	89 c7                	mov    %eax,%edi
  80341a:	48 b8 ad 2b 80 00 00 	movabs $0x802bad,%rax
  803421:	00 00 00 
  803424:	ff d0                	callq  *%rax
  803426:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803429:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80342d:	79 4a                	jns    803479 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80342f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803432:	89 c6                	mov    %eax,%esi
  803434:	48 bf f2 54 80 00 00 	movabs $0x8054f2,%rdi
  80343b:	00 00 00 
  80343e:	b8 00 00 00 00       	mov    $0x0,%eax
  803443:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  80344a:	00 00 00 
  80344d:	ff d2                	callq  *%rdx
			close(fd_src);
  80344f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803452:	89 c7                	mov    %eax,%edi
  803454:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax
			close(fd_dest);
  803460:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803463:	89 c7                	mov    %eax,%edi
  803465:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
			return write_size;
  803471:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803474:	e9 a1 00 00 00       	jmpq   80351a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803479:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803483:	ba 00 02 00 00       	mov    $0x200,%edx
  803488:	48 89 ce             	mov    %rcx,%rsi
  80348b:	89 c7                	mov    %eax,%edi
  80348d:	48 b8 63 2a 80 00 00 	movabs $0x802a63,%rax
  803494:	00 00 00 
  803497:	ff d0                	callq  *%rax
  803499:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80349c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034a0:	0f 8f 5f ff ff ff    	jg     803405 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8034a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034aa:	79 47                	jns    8034f3 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8034ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034af:	89 c6                	mov    %eax,%esi
  8034b1:	48 bf 05 55 80 00 00 	movabs $0x805505,%rdi
  8034b8:	00 00 00 
  8034bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c0:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  8034c7:	00 00 00 
  8034ca:	ff d2                	callq  *%rdx
		close(fd_src);
  8034cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cf:	89 c7                	mov    %eax,%edi
  8034d1:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  8034d8:	00 00 00 
  8034db:	ff d0                	callq  *%rax
		close(fd_dest);
  8034dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034e0:	89 c7                	mov    %eax,%edi
  8034e2:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  8034e9:	00 00 00 
  8034ec:	ff d0                	callq  *%rax
		return read_size;
  8034ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034f1:	eb 27                	jmp    80351a <copy+0x1d9>
	}
	close(fd_src);
  8034f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f6:	89 c7                	mov    %eax,%edi
  8034f8:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  8034ff:	00 00 00 
  803502:	ff d0                	callq  *%rax
	close(fd_dest);
  803504:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803507:	89 c7                	mov    %eax,%edi
  803509:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  803510:	00 00 00 
  803513:	ff d0                	callq  *%rax
	return 0;
  803515:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80351a:	c9                   	leaveq 
  80351b:	c3                   	retq   

000000000080351c <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80351c:	55                   	push   %rbp
  80351d:	48 89 e5             	mov    %rsp,%rbp
  803520:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803527:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  80352e:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803535:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  80353c:	be 00 00 00 00       	mov    $0x0,%esi
  803541:	48 89 c7             	mov    %rax,%rdi
  803544:	48 b8 06 2f 80 00 00 	movabs $0x802f06,%rax
  80354b:	00 00 00 
  80354e:	ff d0                	callq  *%rax
  803550:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803553:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803557:	79 08                	jns    803561 <spawn+0x45>
		return r;
  803559:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80355c:	e9 0c 03 00 00       	jmpq   80386d <spawn+0x351>
	fd = r;
  803561:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803564:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803567:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  80356e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803572:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803579:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80357c:	ba 00 02 00 00       	mov    $0x200,%edx
  803581:	48 89 ce             	mov    %rcx,%rsi
  803584:	89 c7                	mov    %eax,%edi
  803586:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
  803592:	3d 00 02 00 00       	cmp    $0x200,%eax
  803597:	75 0d                	jne    8035a6 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803599:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80359d:	8b 00                	mov    (%rax),%eax
  80359f:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8035a4:	74 43                	je     8035e9 <spawn+0xcd>
		close(fd);
  8035a6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8035a9:	89 c7                	mov    %eax,%edi
  8035ab:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  8035b2:	00 00 00 
  8035b5:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8035b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035bb:	8b 00                	mov    (%rax),%eax
  8035bd:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8035c2:	89 c6                	mov    %eax,%esi
  8035c4:	48 bf 20 55 80 00 00 	movabs $0x805520,%rdi
  8035cb:	00 00 00 
  8035ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d3:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  8035da:	00 00 00 
  8035dd:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  8035df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8035e4:	e9 84 02 00 00       	jmpq   80386d <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8035e9:	b8 07 00 00 00       	mov    $0x7,%eax
  8035ee:	cd 30                	int    $0x30
  8035f0:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8035f3:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8035f6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8035f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8035fd:	79 08                	jns    803607 <spawn+0xeb>
		return r;
  8035ff:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803602:	e9 66 02 00 00       	jmpq   80386d <spawn+0x351>
	child = r;
  803607:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80360a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80360d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803610:	25 ff 03 00 00       	and    $0x3ff,%eax
  803615:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80361c:	00 00 00 
  80361f:	48 98                	cltq   
  803621:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803628:	48 01 d0             	add    %rdx,%rax
  80362b:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803632:	48 89 c6             	mov    %rax,%rsi
  803635:	b8 18 00 00 00       	mov    $0x18,%eax
  80363a:	48 89 d7             	mov    %rdx,%rdi
  80363d:	48 89 c1             	mov    %rax,%rcx
  803640:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803647:	48 8b 40 18          	mov    0x18(%rax),%rax
  80364b:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803652:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803659:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803660:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803667:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80366a:	48 89 ce             	mov    %rcx,%rsi
  80366d:	89 c7                	mov    %eax,%edi
  80366f:	48 b8 d7 3a 80 00 00 	movabs $0x803ad7,%rax
  803676:	00 00 00 
  803679:	ff d0                	callq  *%rax
  80367b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80367e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803682:	79 08                	jns    80368c <spawn+0x170>
		return r;
  803684:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803687:	e9 e1 01 00 00       	jmpq   80386d <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80368c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803690:	48 8b 40 20          	mov    0x20(%rax),%rax
  803694:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80369b:	48 01 d0             	add    %rdx,%rax
  80369e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8036a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036a9:	e9 a3 00 00 00       	jmpq   803751 <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  8036ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b2:	8b 00                	mov    (%rax),%eax
  8036b4:	83 f8 01             	cmp    $0x1,%eax
  8036b7:	74 05                	je     8036be <spawn+0x1a2>
			continue;
  8036b9:	e9 8a 00 00 00       	jmpq   803748 <spawn+0x22c>
		perm = PTE_P | PTE_U;
  8036be:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8036c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c9:	8b 40 04             	mov    0x4(%rax),%eax
  8036cc:	83 e0 02             	and    $0x2,%eax
  8036cf:	85 c0                	test   %eax,%eax
  8036d1:	74 04                	je     8036d7 <spawn+0x1bb>
			perm |= PTE_W;
  8036d3:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8036d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036db:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8036df:	41 89 c1             	mov    %eax,%r9d
  8036e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e6:	4c 8b 40 20          	mov    0x20(%rax),%r8
  8036ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ee:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8036f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f6:	48 8b 70 10          	mov    0x10(%rax),%rsi
  8036fa:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8036fd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803700:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803703:	89 3c 24             	mov    %edi,(%rsp)
  803706:	89 c7                	mov    %eax,%edi
  803708:	48 b8 80 3d 80 00 00 	movabs $0x803d80,%rax
  80370f:	00 00 00 
  803712:	ff d0                	callq  *%rax
  803714:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803717:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80371b:	79 2b                	jns    803748 <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  80371d:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  80371e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803721:	89 c7                	mov    %eax,%edi
  803723:	48 b8 ab 19 80 00 00 	movabs $0x8019ab,%rax
  80372a:	00 00 00 
  80372d:	ff d0                	callq  *%rax
	close(fd);
  80372f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803732:	89 c7                	mov    %eax,%edi
  803734:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  80373b:	00 00 00 
  80373e:	ff d0                	callq  *%rax
	return r;
  803740:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803743:	e9 25 01 00 00       	jmpq   80386d <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803748:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80374c:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803755:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803759:	0f b7 c0             	movzwl %ax,%eax
  80375c:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80375f:	0f 8f 49 ff ff ff    	jg     8036ae <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803765:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803768:	89 c7                	mov    %eax,%edi
  80376a:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  803771:	00 00 00 
  803774:	ff d0                	callq  *%rax
	fd = -1;
  803776:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  80377d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803780:	89 c7                	mov    %eax,%edi
  803782:	48 b8 6c 3f 80 00 00 	movabs $0x803f6c,%rax
  803789:	00 00 00 
  80378c:	ff d0                	callq  *%rax
  80378e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803791:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803795:	79 30                	jns    8037c7 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  803797:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80379a:	89 c1                	mov    %eax,%ecx
  80379c:	48 ba 3a 55 80 00 00 	movabs $0x80553a,%rdx
  8037a3:	00 00 00 
  8037a6:	be 82 00 00 00       	mov    $0x82,%esi
  8037ab:	48 bf 50 55 80 00 00 	movabs $0x805550,%rdi
  8037b2:	00 00 00 
  8037b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ba:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8037c1:	00 00 00 
  8037c4:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8037c7:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8037ce:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8037d1:	48 89 d6             	mov    %rdx,%rsi
  8037d4:	89 c7                	mov    %eax,%edi
  8037d6:	48 b8 ab 1b 80 00 00 	movabs $0x801bab,%rax
  8037dd:	00 00 00 
  8037e0:	ff d0                	callq  *%rax
  8037e2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8037e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8037e9:	79 30                	jns    80381b <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  8037eb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037ee:	89 c1                	mov    %eax,%ecx
  8037f0:	48 ba 5c 55 80 00 00 	movabs $0x80555c,%rdx
  8037f7:	00 00 00 
  8037fa:	be 85 00 00 00       	mov    $0x85,%esi
  8037ff:	48 bf 50 55 80 00 00 	movabs $0x805550,%rdi
  803806:	00 00 00 
  803809:	b8 00 00 00 00       	mov    $0x0,%eax
  80380e:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803815:	00 00 00 
  803818:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80381b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80381e:	be 02 00 00 00       	mov    $0x2,%esi
  803823:	89 c7                	mov    %eax,%edi
  803825:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  80382c:	00 00 00 
  80382f:	ff d0                	callq  *%rax
  803831:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803834:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803838:	79 30                	jns    80386a <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  80383a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80383d:	89 c1                	mov    %eax,%ecx
  80383f:	48 ba 76 55 80 00 00 	movabs $0x805576,%rdx
  803846:	00 00 00 
  803849:	be 88 00 00 00       	mov    $0x88,%esi
  80384e:	48 bf 50 55 80 00 00 	movabs $0x805550,%rdi
  803855:	00 00 00 
  803858:	b8 00 00 00 00       	mov    $0x0,%eax
  80385d:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803864:	00 00 00 
  803867:	41 ff d0             	callq  *%r8

	return child;
  80386a:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80386d:	c9                   	leaveq 
  80386e:	c3                   	retq   

000000000080386f <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80386f:	55                   	push   %rbp
  803870:	48 89 e5             	mov    %rsp,%rbp
  803873:	41 55                	push   %r13
  803875:	41 54                	push   %r12
  803877:	53                   	push   %rbx
  803878:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80387f:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803886:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  80388d:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803894:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  80389b:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8038a2:	84 c0                	test   %al,%al
  8038a4:	74 26                	je     8038cc <spawnl+0x5d>
  8038a6:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8038ad:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8038b4:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8038b8:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8038bc:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8038c0:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8038c4:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8038c8:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  8038cc:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8038d3:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  8038da:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  8038dd:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8038e4:	00 00 00 
  8038e7:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8038ee:	00 00 00 
  8038f1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8038f5:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8038fc:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803903:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  80390a:	eb 07                	jmp    803913 <spawnl+0xa4>
		argc++;
  80390c:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803913:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803919:	83 f8 30             	cmp    $0x30,%eax
  80391c:	73 23                	jae    803941 <spawnl+0xd2>
  80391e:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803925:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80392b:	89 c0                	mov    %eax,%eax
  80392d:	48 01 d0             	add    %rdx,%rax
  803930:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803936:	83 c2 08             	add    $0x8,%edx
  803939:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80393f:	eb 15                	jmp    803956 <spawnl+0xe7>
  803941:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803948:	48 89 d0             	mov    %rdx,%rax
  80394b:	48 83 c2 08          	add    $0x8,%rdx
  80394f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803956:	48 8b 00             	mov    (%rax),%rax
  803959:	48 85 c0             	test   %rax,%rax
  80395c:	75 ae                	jne    80390c <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  80395e:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803964:	83 c0 02             	add    $0x2,%eax
  803967:	48 89 e2             	mov    %rsp,%rdx
  80396a:	48 89 d3             	mov    %rdx,%rbx
  80396d:	48 63 d0             	movslq %eax,%rdx
  803970:	48 83 ea 01          	sub    $0x1,%rdx
  803974:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  80397b:	48 63 d0             	movslq %eax,%rdx
  80397e:	49 89 d4             	mov    %rdx,%r12
  803981:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803987:	48 63 d0             	movslq %eax,%rdx
  80398a:	49 89 d2             	mov    %rdx,%r10
  80398d:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803993:	48 98                	cltq   
  803995:	48 c1 e0 03          	shl    $0x3,%rax
  803999:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80399d:	b8 10 00 00 00       	mov    $0x10,%eax
  8039a2:	48 83 e8 01          	sub    $0x1,%rax
  8039a6:	48 01 d0             	add    %rdx,%rax
  8039a9:	bf 10 00 00 00       	mov    $0x10,%edi
  8039ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8039b3:	48 f7 f7             	div    %rdi
  8039b6:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8039ba:	48 29 c4             	sub    %rax,%rsp
  8039bd:	48 89 e0             	mov    %rsp,%rax
  8039c0:	48 83 c0 07          	add    $0x7,%rax
  8039c4:	48 c1 e8 03          	shr    $0x3,%rax
  8039c8:	48 c1 e0 03          	shl    $0x3,%rax
  8039cc:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8039d3:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8039da:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8039e1:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8039e4:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8039ea:	8d 50 01             	lea    0x1(%rax),%edx
  8039ed:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8039f4:	48 63 d2             	movslq %edx,%rdx
  8039f7:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8039fe:	00 

	va_start(vl, arg0);
  8039ff:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803a06:	00 00 00 
  803a09:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803a10:	00 00 00 
  803a13:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803a17:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803a1e:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803a25:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803a2c:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803a33:	00 00 00 
  803a36:	eb 63                	jmp    803a9b <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803a38:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803a3e:	8d 70 01             	lea    0x1(%rax),%esi
  803a41:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803a47:	83 f8 30             	cmp    $0x30,%eax
  803a4a:	73 23                	jae    803a6f <spawnl+0x200>
  803a4c:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803a53:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803a59:	89 c0                	mov    %eax,%eax
  803a5b:	48 01 d0             	add    %rdx,%rax
  803a5e:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803a64:	83 c2 08             	add    $0x8,%edx
  803a67:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803a6d:	eb 15                	jmp    803a84 <spawnl+0x215>
  803a6f:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803a76:	48 89 d0             	mov    %rdx,%rax
  803a79:	48 83 c2 08          	add    $0x8,%rdx
  803a7d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803a84:	48 8b 08             	mov    (%rax),%rcx
  803a87:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803a8e:	89 f2                	mov    %esi,%edx
  803a90:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803a94:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803a9b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803aa1:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803aa7:	77 8f                	ja     803a38 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803aa9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803ab0:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803ab7:	48 89 d6             	mov    %rdx,%rsi
  803aba:	48 89 c7             	mov    %rax,%rdi
  803abd:	48 b8 1c 35 80 00 00 	movabs $0x80351c,%rax
  803ac4:	00 00 00 
  803ac7:	ff d0                	callq  *%rax
  803ac9:	48 89 dc             	mov    %rbx,%rsp
}
  803acc:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803ad0:	5b                   	pop    %rbx
  803ad1:	41 5c                	pop    %r12
  803ad3:	41 5d                	pop    %r13
  803ad5:	5d                   	pop    %rbp
  803ad6:	c3                   	retq   

0000000000803ad7 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803ad7:	55                   	push   %rbp
  803ad8:	48 89 e5             	mov    %rsp,%rbp
  803adb:	48 83 ec 50          	sub    $0x50,%rsp
  803adf:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803ae2:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803ae6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803aea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803af1:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803af2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803af9:	eb 33                	jmp    803b2e <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803afb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803afe:	48 98                	cltq   
  803b00:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b07:	00 
  803b08:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b0c:	48 01 d0             	add    %rdx,%rax
  803b0f:	48 8b 00             	mov    (%rax),%rax
  803b12:	48 89 c7             	mov    %rax,%rdi
  803b15:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  803b1c:	00 00 00 
  803b1f:	ff d0                	callq  *%rax
  803b21:	83 c0 01             	add    $0x1,%eax
  803b24:	48 98                	cltq   
  803b26:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803b2a:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803b2e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b31:	48 98                	cltq   
  803b33:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b3a:	00 
  803b3b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b3f:	48 01 d0             	add    %rdx,%rax
  803b42:	48 8b 00             	mov    (%rax),%rax
  803b45:	48 85 c0             	test   %rax,%rax
  803b48:	75 b1                	jne    803afb <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803b4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b4e:	48 f7 d8             	neg    %rax
  803b51:	48 05 00 10 40 00    	add    $0x401000,%rax
  803b57:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803b5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b5f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803b63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b67:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803b6b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803b6e:	83 c2 01             	add    $0x1,%edx
  803b71:	c1 e2 03             	shl    $0x3,%edx
  803b74:	48 63 d2             	movslq %edx,%rdx
  803b77:	48 f7 da             	neg    %rdx
  803b7a:	48 01 d0             	add    %rdx,%rax
  803b7d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803b81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b85:	48 83 e8 10          	sub    $0x10,%rax
  803b89:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803b8f:	77 0a                	ja     803b9b <init_stack+0xc4>
		return -E_NO_MEM;
  803b91:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803b96:	e9 e3 01 00 00       	jmpq   803d7e <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803b9b:	ba 07 00 00 00       	mov    $0x7,%edx
  803ba0:	be 00 00 40 00       	mov    $0x400000,%esi
  803ba5:	bf 00 00 00 00       	mov    $0x0,%edi
  803baa:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  803bb1:	00 00 00 
  803bb4:	ff d0                	callq  *%rax
  803bb6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bbd:	79 08                	jns    803bc7 <init_stack+0xf0>
		return r;
  803bbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bc2:	e9 b7 01 00 00       	jmpq   803d7e <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803bc7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803bce:	e9 8a 00 00 00       	jmpq   803c5d <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803bd3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803bd6:	48 98                	cltq   
  803bd8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803bdf:	00 
  803be0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803be4:	48 01 c2             	add    %rax,%rdx
  803be7:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803bec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bf0:	48 01 c8             	add    %rcx,%rax
  803bf3:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803bf9:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803bfc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803bff:	48 98                	cltq   
  803c01:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803c08:	00 
  803c09:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803c0d:	48 01 d0             	add    %rdx,%rax
  803c10:	48 8b 10             	mov    (%rax),%rdx
  803c13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c17:	48 89 d6             	mov    %rdx,%rsi
  803c1a:	48 89 c7             	mov    %rax,%rdi
  803c1d:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  803c24:	00 00 00 
  803c27:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803c29:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803c2c:	48 98                	cltq   
  803c2e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803c35:	00 
  803c36:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803c3a:	48 01 d0             	add    %rdx,%rax
  803c3d:	48 8b 00             	mov    (%rax),%rax
  803c40:	48 89 c7             	mov    %rax,%rdi
  803c43:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  803c4a:	00 00 00 
  803c4d:	ff d0                	callq  *%rax
  803c4f:	48 98                	cltq   
  803c51:	48 83 c0 01          	add    $0x1,%rax
  803c55:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803c59:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803c5d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803c60:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803c63:	0f 8c 6a ff ff ff    	jl     803bd3 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803c69:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c6c:	48 98                	cltq   
  803c6e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803c75:	00 
  803c76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c7a:	48 01 d0             	add    %rdx,%rax
  803c7d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803c84:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803c8b:	00 
  803c8c:	74 35                	je     803cc3 <init_stack+0x1ec>
  803c8e:	48 b9 90 55 80 00 00 	movabs $0x805590,%rcx
  803c95:	00 00 00 
  803c98:	48 ba b6 55 80 00 00 	movabs $0x8055b6,%rdx
  803c9f:	00 00 00 
  803ca2:	be f1 00 00 00       	mov    $0xf1,%esi
  803ca7:	48 bf 50 55 80 00 00 	movabs $0x805550,%rdi
  803cae:	00 00 00 
  803cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb6:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803cbd:	00 00 00 
  803cc0:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803cc3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cc7:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803ccb:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803cd0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cd4:	48 01 c8             	add    %rcx,%rax
  803cd7:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803cdd:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803ce0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ce4:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803ce8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ceb:	48 98                	cltq   
  803ced:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803cf0:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803cf5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cf9:	48 01 d0             	add    %rdx,%rax
  803cfc:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803d02:	48 89 c2             	mov    %rax,%rdx
  803d05:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803d09:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803d0c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803d0f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803d15:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803d1a:	89 c2                	mov    %eax,%edx
  803d1c:	be 00 00 40 00       	mov    $0x400000,%esi
  803d21:	bf 00 00 00 00       	mov    $0x0,%edi
  803d26:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  803d2d:	00 00 00 
  803d30:	ff d0                	callq  *%rax
  803d32:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d35:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d39:	79 02                	jns    803d3d <init_stack+0x266>
		goto error;
  803d3b:	eb 28                	jmp    803d65 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803d3d:	be 00 00 40 00       	mov    $0x400000,%esi
  803d42:	bf 00 00 00 00       	mov    $0x0,%edi
  803d47:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  803d4e:	00 00 00 
  803d51:	ff d0                	callq  *%rax
  803d53:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d56:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d5a:	79 02                	jns    803d5e <init_stack+0x287>
		goto error;
  803d5c:	eb 07                	jmp    803d65 <init_stack+0x28e>

	return 0;
  803d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d63:	eb 19                	jmp    803d7e <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803d65:	be 00 00 40 00       	mov    $0x400000,%esi
  803d6a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d6f:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  803d76:	00 00 00 
  803d79:	ff d0                	callq  *%rax
	return r;
  803d7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803d7e:	c9                   	leaveq 
  803d7f:	c3                   	retq   

0000000000803d80 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803d80:	55                   	push   %rbp
  803d81:	48 89 e5             	mov    %rsp,%rbp
  803d84:	48 83 ec 50          	sub    $0x50,%rsp
  803d88:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803d8b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d8f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803d93:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803d96:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803d9a:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803d9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803da2:	25 ff 0f 00 00       	and    $0xfff,%eax
  803da7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803daa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dae:	74 21                	je     803dd1 <map_segment+0x51>
		va -= i;
  803db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db3:	48 98                	cltq   
  803db5:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803db9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbc:	48 98                	cltq   
  803dbe:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc5:	48 98                	cltq   
  803dc7:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dce:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803dd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dd8:	e9 79 01 00 00       	jmpq   803f56 <map_segment+0x1d6>
		if (i >= filesz) {
  803ddd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de0:	48 98                	cltq   
  803de2:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803de6:	72 3c                	jb     803e24 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803de8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803deb:	48 63 d0             	movslq %eax,%rdx
  803dee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803df2:	48 01 d0             	add    %rdx,%rax
  803df5:	48 89 c1             	mov    %rax,%rcx
  803df8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803dfb:	8b 55 10             	mov    0x10(%rbp),%edx
  803dfe:	48 89 ce             	mov    %rcx,%rsi
  803e01:	89 c7                	mov    %eax,%edi
  803e03:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  803e0a:	00 00 00 
  803e0d:	ff d0                	callq  *%rax
  803e0f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803e12:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e16:	0f 89 33 01 00 00    	jns    803f4f <map_segment+0x1cf>
				return r;
  803e1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e1f:	e9 46 01 00 00       	jmpq   803f6a <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803e24:	ba 07 00 00 00       	mov    $0x7,%edx
  803e29:	be 00 00 40 00       	mov    $0x400000,%esi
  803e2e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e33:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  803e3a:	00 00 00 
  803e3d:	ff d0                	callq  *%rax
  803e3f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803e42:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e46:	79 08                	jns    803e50 <map_segment+0xd0>
				return r;
  803e48:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e4b:	e9 1a 01 00 00       	jmpq   803f6a <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803e50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e53:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803e56:	01 c2                	add    %eax,%edx
  803e58:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803e5b:	89 d6                	mov    %edx,%esi
  803e5d:	89 c7                	mov    %eax,%edi
  803e5f:	48 b8 4e 2c 80 00 00 	movabs $0x802c4e,%rax
  803e66:	00 00 00 
  803e69:	ff d0                	callq  *%rax
  803e6b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803e6e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e72:	79 08                	jns    803e7c <map_segment+0xfc>
				return r;
  803e74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e77:	e9 ee 00 00 00       	jmpq   803f6a <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803e7c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803e83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e86:	48 98                	cltq   
  803e88:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803e8c:	48 29 c2             	sub    %rax,%rdx
  803e8f:	48 89 d0             	mov    %rdx,%rax
  803e92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803e96:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e99:	48 63 d0             	movslq %eax,%rdx
  803e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ea0:	48 39 c2             	cmp    %rax,%rdx
  803ea3:	48 0f 47 d0          	cmova  %rax,%rdx
  803ea7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803eaa:	be 00 00 40 00       	mov    $0x400000,%esi
  803eaf:	89 c7                	mov    %eax,%edi
  803eb1:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  803eb8:	00 00 00 
  803ebb:	ff d0                	callq  *%rax
  803ebd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ec0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ec4:	79 08                	jns    803ece <map_segment+0x14e>
				return r;
  803ec6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ec9:	e9 9c 00 00 00       	jmpq   803f6a <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803ece:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed1:	48 63 d0             	movslq %eax,%rdx
  803ed4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ed8:	48 01 d0             	add    %rdx,%rax
  803edb:	48 89 c2             	mov    %rax,%rdx
  803ede:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ee1:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803ee5:	48 89 d1             	mov    %rdx,%rcx
  803ee8:	89 c2                	mov    %eax,%edx
  803eea:	be 00 00 40 00       	mov    $0x400000,%esi
  803eef:	bf 00 00 00 00       	mov    $0x0,%edi
  803ef4:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  803efb:	00 00 00 
  803efe:	ff d0                	callq  *%rax
  803f00:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803f03:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803f07:	79 30                	jns    803f39 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803f09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f0c:	89 c1                	mov    %eax,%ecx
  803f0e:	48 ba cb 55 80 00 00 	movabs $0x8055cb,%rdx
  803f15:	00 00 00 
  803f18:	be 24 01 00 00       	mov    $0x124,%esi
  803f1d:	48 bf 50 55 80 00 00 	movabs $0x805550,%rdi
  803f24:	00 00 00 
  803f27:	b8 00 00 00 00       	mov    $0x0,%eax
  803f2c:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803f33:	00 00 00 
  803f36:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803f39:	be 00 00 40 00       	mov    $0x400000,%esi
  803f3e:	bf 00 00 00 00       	mov    $0x0,%edi
  803f43:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  803f4a:	00 00 00 
  803f4d:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803f4f:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f59:	48 98                	cltq   
  803f5b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f5f:	0f 82 78 fe ff ff    	jb     803ddd <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803f65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f6a:	c9                   	leaveq 
  803f6b:	c3                   	retq   

0000000000803f6c <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803f6c:	55                   	push   %rbp
  803f6d:	48 89 e5             	mov    %rsp,%rbp
  803f70:	48 83 ec 20          	sub    $0x20,%rsp
  803f74:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803f77:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  803f7e:	00 
  803f7f:	e9 c9 00 00 00       	jmpq   80404d <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  803f84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f88:	48 c1 e8 27          	shr    $0x27,%rax
  803f8c:	48 89 c2             	mov    %rax,%rdx
  803f8f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803f96:	01 00 00 
  803f99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f9d:	48 85 c0             	test   %rax,%rax
  803fa0:	74 3c                	je     803fde <copy_shared_pages+0x72>
  803fa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa6:	48 c1 e8 1e          	shr    $0x1e,%rax
  803faa:	48 89 c2             	mov    %rax,%rdx
  803fad:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803fb4:	01 00 00 
  803fb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fbb:	48 85 c0             	test   %rax,%rax
  803fbe:	74 1e                	je     803fde <copy_shared_pages+0x72>
  803fc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fc4:	48 c1 e8 15          	shr    $0x15,%rax
  803fc8:	48 89 c2             	mov    %rax,%rdx
  803fcb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803fd2:	01 00 00 
  803fd5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fd9:	48 85 c0             	test   %rax,%rax
  803fdc:	75 02                	jne    803fe0 <copy_shared_pages+0x74>
                continue;
  803fde:	eb 65                	jmp    804045 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803fe0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe4:	48 c1 e8 0c          	shr    $0xc,%rax
  803fe8:	48 89 c2             	mov    %rax,%rdx
  803feb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ff2:	01 00 00 
  803ff5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ff9:	25 00 04 00 00       	and    $0x400,%eax
  803ffe:	48 85 c0             	test   %rax,%rax
  804001:	74 42                	je     804045 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  804003:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804007:	48 c1 e8 0c          	shr    $0xc,%rax
  80400b:	48 89 c2             	mov    %rax,%rdx
  80400e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804015:	01 00 00 
  804018:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80401c:	25 07 0e 00 00       	and    $0xe07,%eax
  804021:	89 c6                	mov    %eax,%esi
  804023:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  804027:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80402b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80402e:	41 89 f0             	mov    %esi,%r8d
  804031:	48 89 c6             	mov    %rax,%rsi
  804034:	bf 00 00 00 00       	mov    $0x0,%edi
  804039:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  804040:	00 00 00 
  804043:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  804045:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  80404c:	00 
  80404d:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  804054:	00 00 00 
  804057:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80405b:	0f 86 23 ff ff ff    	jbe    803f84 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  804061:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  804066:	c9                   	leaveq 
  804067:	c3                   	retq   

0000000000804068 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804068:	55                   	push   %rbp
  804069:	48 89 e5             	mov    %rsp,%rbp
  80406c:	53                   	push   %rbx
  80406d:	48 83 ec 38          	sub    $0x38,%rsp
  804071:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804075:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804079:	48 89 c7             	mov    %rax,%rdi
  80407c:	48 b8 99 25 80 00 00 	movabs $0x802599,%rax
  804083:	00 00 00 
  804086:	ff d0                	callq  *%rax
  804088:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80408b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80408f:	0f 88 bf 01 00 00    	js     804254 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804095:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804099:	ba 07 04 00 00       	mov    $0x407,%edx
  80409e:	48 89 c6             	mov    %rax,%rsi
  8040a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8040a6:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  8040ad:	00 00 00 
  8040b0:	ff d0                	callq  *%rax
  8040b2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040b9:	0f 88 95 01 00 00    	js     804254 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8040bf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8040c3:	48 89 c7             	mov    %rax,%rdi
  8040c6:	48 b8 99 25 80 00 00 	movabs $0x802599,%rax
  8040cd:	00 00 00 
  8040d0:	ff d0                	callq  *%rax
  8040d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040d9:	0f 88 5d 01 00 00    	js     80423c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040e3:	ba 07 04 00 00       	mov    $0x407,%edx
  8040e8:	48 89 c6             	mov    %rax,%rsi
  8040eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8040f0:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  8040f7:	00 00 00 
  8040fa:	ff d0                	callq  *%rax
  8040fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804103:	0f 88 33 01 00 00    	js     80423c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804109:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80410d:	48 89 c7             	mov    %rax,%rdi
  804110:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  804117:	00 00 00 
  80411a:	ff d0                	callq  *%rax
  80411c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804124:	ba 07 04 00 00       	mov    $0x407,%edx
  804129:	48 89 c6             	mov    %rax,%rsi
  80412c:	bf 00 00 00 00       	mov    $0x0,%edi
  804131:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  804138:	00 00 00 
  80413b:	ff d0                	callq  *%rax
  80413d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804140:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804144:	79 05                	jns    80414b <pipe+0xe3>
		goto err2;
  804146:	e9 d9 00 00 00       	jmpq   804224 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80414b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80414f:	48 89 c7             	mov    %rax,%rdi
  804152:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  804159:	00 00 00 
  80415c:	ff d0                	callq  *%rax
  80415e:	48 89 c2             	mov    %rax,%rdx
  804161:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804165:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80416b:	48 89 d1             	mov    %rdx,%rcx
  80416e:	ba 00 00 00 00       	mov    $0x0,%edx
  804173:	48 89 c6             	mov    %rax,%rsi
  804176:	bf 00 00 00 00       	mov    $0x0,%edi
  80417b:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  804182:	00 00 00 
  804185:	ff d0                	callq  *%rax
  804187:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80418a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80418e:	79 1b                	jns    8041ab <pipe+0x143>
		goto err3;
  804190:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804191:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804195:	48 89 c6             	mov    %rax,%rsi
  804198:	bf 00 00 00 00       	mov    $0x0,%edi
  80419d:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  8041a4:	00 00 00 
  8041a7:	ff d0                	callq  *%rax
  8041a9:	eb 79                	jmp    804224 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8041ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041af:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8041b6:	00 00 00 
  8041b9:	8b 12                	mov    (%rdx),%edx
  8041bb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8041bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8041c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041cc:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8041d3:	00 00 00 
  8041d6:	8b 12                	mov    (%rdx),%edx
  8041d8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8041da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041de:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8041e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041e9:	48 89 c7             	mov    %rax,%rdi
  8041ec:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  8041f3:	00 00 00 
  8041f6:	ff d0                	callq  *%rax
  8041f8:	89 c2                	mov    %eax,%edx
  8041fa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041fe:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804200:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804204:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804208:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80420c:	48 89 c7             	mov    %rax,%rdi
  80420f:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  804216:	00 00 00 
  804219:	ff d0                	callq  *%rax
  80421b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80421d:	b8 00 00 00 00       	mov    $0x0,%eax
  804222:	eb 33                	jmp    804257 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804224:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804228:	48 89 c6             	mov    %rax,%rsi
  80422b:	bf 00 00 00 00       	mov    $0x0,%edi
  804230:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  804237:	00 00 00 
  80423a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80423c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804240:	48 89 c6             	mov    %rax,%rsi
  804243:	bf 00 00 00 00       	mov    $0x0,%edi
  804248:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  80424f:	00 00 00 
  804252:	ff d0                	callq  *%rax
err:
	return r;
  804254:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804257:	48 83 c4 38          	add    $0x38,%rsp
  80425b:	5b                   	pop    %rbx
  80425c:	5d                   	pop    %rbp
  80425d:	c3                   	retq   

000000000080425e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80425e:	55                   	push   %rbp
  80425f:	48 89 e5             	mov    %rsp,%rbp
  804262:	53                   	push   %rbx
  804263:	48 83 ec 28          	sub    $0x28,%rsp
  804267:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80426b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80426f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804276:	00 00 00 
  804279:	48 8b 00             	mov    (%rax),%rax
  80427c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804282:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804285:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804289:	48 89 c7             	mov    %rax,%rdi
  80428c:	48 b8 b1 4c 80 00 00 	movabs $0x804cb1,%rax
  804293:	00 00 00 
  804296:	ff d0                	callq  *%rax
  804298:	89 c3                	mov    %eax,%ebx
  80429a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80429e:	48 89 c7             	mov    %rax,%rdi
  8042a1:	48 b8 b1 4c 80 00 00 	movabs $0x804cb1,%rax
  8042a8:	00 00 00 
  8042ab:	ff d0                	callq  *%rax
  8042ad:	39 c3                	cmp    %eax,%ebx
  8042af:	0f 94 c0             	sete   %al
  8042b2:	0f b6 c0             	movzbl %al,%eax
  8042b5:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8042b8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8042bf:	00 00 00 
  8042c2:	48 8b 00             	mov    (%rax),%rax
  8042c5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8042cb:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8042ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042d1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8042d4:	75 05                	jne    8042db <_pipeisclosed+0x7d>
			return ret;
  8042d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8042d9:	eb 4f                	jmp    80432a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8042db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042de:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8042e1:	74 42                	je     804325 <_pipeisclosed+0xc7>
  8042e3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8042e7:	75 3c                	jne    804325 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8042e9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8042f0:	00 00 00 
  8042f3:	48 8b 00             	mov    (%rax),%rax
  8042f6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8042fc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8042ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804302:	89 c6                	mov    %eax,%esi
  804304:	48 bf f2 55 80 00 00 	movabs $0x8055f2,%rdi
  80430b:	00 00 00 
  80430e:	b8 00 00 00 00       	mov    $0x0,%eax
  804313:	49 b8 87 05 80 00 00 	movabs $0x800587,%r8
  80431a:	00 00 00 
  80431d:	41 ff d0             	callq  *%r8
	}
  804320:	e9 4a ff ff ff       	jmpq   80426f <_pipeisclosed+0x11>
  804325:	e9 45 ff ff ff       	jmpq   80426f <_pipeisclosed+0x11>
}
  80432a:	48 83 c4 28          	add    $0x28,%rsp
  80432e:	5b                   	pop    %rbx
  80432f:	5d                   	pop    %rbp
  804330:	c3                   	retq   

0000000000804331 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804331:	55                   	push   %rbp
  804332:	48 89 e5             	mov    %rsp,%rbp
  804335:	48 83 ec 30          	sub    $0x30,%rsp
  804339:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80433c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804340:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804343:	48 89 d6             	mov    %rdx,%rsi
  804346:	89 c7                	mov    %eax,%edi
  804348:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  80434f:	00 00 00 
  804352:	ff d0                	callq  *%rax
  804354:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804357:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80435b:	79 05                	jns    804362 <pipeisclosed+0x31>
		return r;
  80435d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804360:	eb 31                	jmp    804393 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804366:	48 89 c7             	mov    %rax,%rdi
  804369:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  804370:	00 00 00 
  804373:	ff d0                	callq  *%rax
  804375:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80437d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804381:	48 89 d6             	mov    %rdx,%rsi
  804384:	48 89 c7             	mov    %rax,%rdi
  804387:	48 b8 5e 42 80 00 00 	movabs $0x80425e,%rax
  80438e:	00 00 00 
  804391:	ff d0                	callq  *%rax
}
  804393:	c9                   	leaveq 
  804394:	c3                   	retq   

0000000000804395 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804395:	55                   	push   %rbp
  804396:	48 89 e5             	mov    %rsp,%rbp
  804399:	48 83 ec 40          	sub    $0x40,%rsp
  80439d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8043a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8043a5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8043a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043ad:	48 89 c7             	mov    %rax,%rdi
  8043b0:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  8043b7:	00 00 00 
  8043ba:	ff d0                	callq  *%rax
  8043bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8043c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043c4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8043c8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8043cf:	00 
  8043d0:	e9 92 00 00 00       	jmpq   804467 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8043d5:	eb 41                	jmp    804418 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8043d7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8043dc:	74 09                	je     8043e7 <devpipe_read+0x52>
				return i;
  8043de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e2:	e9 92 00 00 00       	jmpq   804479 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8043e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043ef:	48 89 d6             	mov    %rdx,%rsi
  8043f2:	48 89 c7             	mov    %rax,%rdi
  8043f5:	48 b8 5e 42 80 00 00 	movabs $0x80425e,%rax
  8043fc:	00 00 00 
  8043ff:	ff d0                	callq  *%rax
  804401:	85 c0                	test   %eax,%eax
  804403:	74 07                	je     80440c <devpipe_read+0x77>
				return 0;
  804405:	b8 00 00 00 00       	mov    $0x0,%eax
  80440a:	eb 6d                	jmp    804479 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80440c:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804413:	00 00 00 
  804416:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80441c:	8b 10                	mov    (%rax),%edx
  80441e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804422:	8b 40 04             	mov    0x4(%rax),%eax
  804425:	39 c2                	cmp    %eax,%edx
  804427:	74 ae                	je     8043d7 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80442d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804431:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804439:	8b 00                	mov    (%rax),%eax
  80443b:	99                   	cltd   
  80443c:	c1 ea 1b             	shr    $0x1b,%edx
  80443f:	01 d0                	add    %edx,%eax
  804441:	83 e0 1f             	and    $0x1f,%eax
  804444:	29 d0                	sub    %edx,%eax
  804446:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80444a:	48 98                	cltq   
  80444c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804451:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804453:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804457:	8b 00                	mov    (%rax),%eax
  804459:	8d 50 01             	lea    0x1(%rax),%edx
  80445c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804460:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804462:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80446b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80446f:	0f 82 60 ff ff ff    	jb     8043d5 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804479:	c9                   	leaveq 
  80447a:	c3                   	retq   

000000000080447b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80447b:	55                   	push   %rbp
  80447c:	48 89 e5             	mov    %rsp,%rbp
  80447f:	48 83 ec 40          	sub    $0x40,%rsp
  804483:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804487:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80448b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80448f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804493:	48 89 c7             	mov    %rax,%rdi
  804496:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  80449d:	00 00 00 
  8044a0:	ff d0                	callq  *%rax
  8044a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8044a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8044ae:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8044b5:	00 
  8044b6:	e9 8e 00 00 00       	jmpq   804549 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8044bb:	eb 31                	jmp    8044ee <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8044bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044c5:	48 89 d6             	mov    %rdx,%rsi
  8044c8:	48 89 c7             	mov    %rax,%rdi
  8044cb:	48 b8 5e 42 80 00 00 	movabs $0x80425e,%rax
  8044d2:	00 00 00 
  8044d5:	ff d0                	callq  *%rax
  8044d7:	85 c0                	test   %eax,%eax
  8044d9:	74 07                	je     8044e2 <devpipe_write+0x67>
				return 0;
  8044db:	b8 00 00 00 00       	mov    $0x0,%eax
  8044e0:	eb 79                	jmp    80455b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8044e2:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  8044e9:	00 00 00 
  8044ec:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8044ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f2:	8b 40 04             	mov    0x4(%rax),%eax
  8044f5:	48 63 d0             	movslq %eax,%rdx
  8044f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044fc:	8b 00                	mov    (%rax),%eax
  8044fe:	48 98                	cltq   
  804500:	48 83 c0 20          	add    $0x20,%rax
  804504:	48 39 c2             	cmp    %rax,%rdx
  804507:	73 b4                	jae    8044bd <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80450d:	8b 40 04             	mov    0x4(%rax),%eax
  804510:	99                   	cltd   
  804511:	c1 ea 1b             	shr    $0x1b,%edx
  804514:	01 d0                	add    %edx,%eax
  804516:	83 e0 1f             	and    $0x1f,%eax
  804519:	29 d0                	sub    %edx,%eax
  80451b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80451f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804523:	48 01 ca             	add    %rcx,%rdx
  804526:	0f b6 0a             	movzbl (%rdx),%ecx
  804529:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80452d:	48 98                	cltq   
  80452f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804537:	8b 40 04             	mov    0x4(%rax),%eax
  80453a:	8d 50 01             	lea    0x1(%rax),%edx
  80453d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804541:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804544:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80454d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804551:	0f 82 64 ff ff ff    	jb     8044bb <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80455b:	c9                   	leaveq 
  80455c:	c3                   	retq   

000000000080455d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80455d:	55                   	push   %rbp
  80455e:	48 89 e5             	mov    %rsp,%rbp
  804561:	48 83 ec 20          	sub    $0x20,%rsp
  804565:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804569:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80456d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804571:	48 89 c7             	mov    %rax,%rdi
  804574:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  80457b:	00 00 00 
  80457e:	ff d0                	callq  *%rax
  804580:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804584:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804588:	48 be 05 56 80 00 00 	movabs $0x805605,%rsi
  80458f:	00 00 00 
  804592:	48 89 c7             	mov    %rax,%rdi
  804595:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  80459c:	00 00 00 
  80459f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8045a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045a5:	8b 50 04             	mov    0x4(%rax),%edx
  8045a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045ac:	8b 00                	mov    (%rax),%eax
  8045ae:	29 c2                	sub    %eax,%edx
  8045b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045b4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8045ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045be:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8045c5:	00 00 00 
	stat->st_dev = &devpipe;
  8045c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045cc:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8045d3:	00 00 00 
  8045d6:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8045dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045e2:	c9                   	leaveq 
  8045e3:	c3                   	retq   

00000000008045e4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8045e4:	55                   	push   %rbp
  8045e5:	48 89 e5             	mov    %rsp,%rbp
  8045e8:	48 83 ec 10          	sub    $0x10,%rsp
  8045ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8045f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045f4:	48 89 c6             	mov    %rax,%rsi
  8045f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8045fc:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  804603:	00 00 00 
  804606:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804608:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80460c:	48 89 c7             	mov    %rax,%rdi
  80460f:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  804616:	00 00 00 
  804619:	ff d0                	callq  *%rax
  80461b:	48 89 c6             	mov    %rax,%rsi
  80461e:	bf 00 00 00 00       	mov    $0x0,%edi
  804623:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  80462a:	00 00 00 
  80462d:	ff d0                	callq  *%rax
}
  80462f:	c9                   	leaveq 
  804630:	c3                   	retq   

0000000000804631 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804631:	55                   	push   %rbp
  804632:	48 89 e5             	mov    %rsp,%rbp
  804635:	48 83 ec 20          	sub    $0x20,%rsp
  804639:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80463c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804640:	75 35                	jne    804677 <wait+0x46>
  804642:	48 b9 0c 56 80 00 00 	movabs $0x80560c,%rcx
  804649:	00 00 00 
  80464c:	48 ba 17 56 80 00 00 	movabs $0x805617,%rdx
  804653:	00 00 00 
  804656:	be 09 00 00 00       	mov    $0x9,%esi
  80465b:	48 bf 2c 56 80 00 00 	movabs $0x80562c,%rdi
  804662:	00 00 00 
  804665:	b8 00 00 00 00       	mov    $0x0,%eax
  80466a:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  804671:	00 00 00 
  804674:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804677:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80467a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80467f:	48 98                	cltq   
  804681:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804688:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80468f:	00 00 00 
  804692:	48 01 d0             	add    %rdx,%rax
  804695:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804699:	eb 0c                	jmp    8046a7 <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  80469b:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  8046a2:	00 00 00 
  8046a5:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  8046a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046ab:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8046b1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8046b4:	75 0e                	jne    8046c4 <wait+0x93>
  8046b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046ba:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8046c0:	85 c0                	test   %eax,%eax
  8046c2:	75 d7                	jne    80469b <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  8046c4:	c9                   	leaveq 
  8046c5:	c3                   	retq   

00000000008046c6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8046c6:	55                   	push   %rbp
  8046c7:	48 89 e5             	mov    %rsp,%rbp
  8046ca:	48 83 ec 20          	sub    $0x20,%rsp
  8046ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8046d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046d4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8046d7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8046db:	be 01 00 00 00       	mov    $0x1,%esi
  8046e0:	48 89 c7             	mov    %rax,%rdi
  8046e3:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  8046ea:	00 00 00 
  8046ed:	ff d0                	callq  *%rax
}
  8046ef:	c9                   	leaveq 
  8046f0:	c3                   	retq   

00000000008046f1 <getchar>:

int
getchar(void)
{
  8046f1:	55                   	push   %rbp
  8046f2:	48 89 e5             	mov    %rsp,%rbp
  8046f5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8046f9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8046fd:	ba 01 00 00 00       	mov    $0x1,%edx
  804702:	48 89 c6             	mov    %rax,%rsi
  804705:	bf 00 00 00 00       	mov    $0x0,%edi
  80470a:	48 b8 63 2a 80 00 00 	movabs $0x802a63,%rax
  804711:	00 00 00 
  804714:	ff d0                	callq  *%rax
  804716:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804719:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80471d:	79 05                	jns    804724 <getchar+0x33>
		return r;
  80471f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804722:	eb 14                	jmp    804738 <getchar+0x47>
	if (r < 1)
  804724:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804728:	7f 07                	jg     804731 <getchar+0x40>
		return -E_EOF;
  80472a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80472f:	eb 07                	jmp    804738 <getchar+0x47>
	return c;
  804731:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804735:	0f b6 c0             	movzbl %al,%eax
}
  804738:	c9                   	leaveq 
  804739:	c3                   	retq   

000000000080473a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80473a:	55                   	push   %rbp
  80473b:	48 89 e5             	mov    %rsp,%rbp
  80473e:	48 83 ec 20          	sub    $0x20,%rsp
  804742:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804745:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804749:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80474c:	48 89 d6             	mov    %rdx,%rsi
  80474f:	89 c7                	mov    %eax,%edi
  804751:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  804758:	00 00 00 
  80475b:	ff d0                	callq  *%rax
  80475d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804764:	79 05                	jns    80476b <iscons+0x31>
		return r;
  804766:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804769:	eb 1a                	jmp    804785 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80476b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80476f:	8b 10                	mov    (%rax),%edx
  804771:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804778:	00 00 00 
  80477b:	8b 00                	mov    (%rax),%eax
  80477d:	39 c2                	cmp    %eax,%edx
  80477f:	0f 94 c0             	sete   %al
  804782:	0f b6 c0             	movzbl %al,%eax
}
  804785:	c9                   	leaveq 
  804786:	c3                   	retq   

0000000000804787 <opencons>:

int
opencons(void)
{
  804787:	55                   	push   %rbp
  804788:	48 89 e5             	mov    %rsp,%rbp
  80478b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80478f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804793:	48 89 c7             	mov    %rax,%rdi
  804796:	48 b8 99 25 80 00 00 	movabs $0x802599,%rax
  80479d:	00 00 00 
  8047a0:	ff d0                	callq  *%rax
  8047a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047a9:	79 05                	jns    8047b0 <opencons+0x29>
		return r;
  8047ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047ae:	eb 5b                	jmp    80480b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8047b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047b4:	ba 07 04 00 00       	mov    $0x407,%edx
  8047b9:	48 89 c6             	mov    %rax,%rsi
  8047bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8047c1:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  8047c8:	00 00 00 
  8047cb:	ff d0                	callq  *%rax
  8047cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047d4:	79 05                	jns    8047db <opencons+0x54>
		return r;
  8047d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047d9:	eb 30                	jmp    80480b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8047db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047df:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8047e6:	00 00 00 
  8047e9:	8b 12                	mov    (%rdx),%edx
  8047eb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8047ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8047f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047fc:	48 89 c7             	mov    %rax,%rdi
  8047ff:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  804806:	00 00 00 
  804809:	ff d0                	callq  *%rax
}
  80480b:	c9                   	leaveq 
  80480c:	c3                   	retq   

000000000080480d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80480d:	55                   	push   %rbp
  80480e:	48 89 e5             	mov    %rsp,%rbp
  804811:	48 83 ec 30          	sub    $0x30,%rsp
  804815:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804819:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80481d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804821:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804826:	75 07                	jne    80482f <devcons_read+0x22>
		return 0;
  804828:	b8 00 00 00 00       	mov    $0x0,%eax
  80482d:	eb 4b                	jmp    80487a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80482f:	eb 0c                	jmp    80483d <devcons_read+0x30>
		sys_yield();
  804831:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804838:	00 00 00 
  80483b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80483d:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  804844:	00 00 00 
  804847:	ff d0                	callq  *%rax
  804849:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80484c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804850:	74 df                	je     804831 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804852:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804856:	79 05                	jns    80485d <devcons_read+0x50>
		return c;
  804858:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80485b:	eb 1d                	jmp    80487a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80485d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804861:	75 07                	jne    80486a <devcons_read+0x5d>
		return 0;
  804863:	b8 00 00 00 00       	mov    $0x0,%eax
  804868:	eb 10                	jmp    80487a <devcons_read+0x6d>
	*(char*)vbuf = c;
  80486a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80486d:	89 c2                	mov    %eax,%edx
  80486f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804873:	88 10                	mov    %dl,(%rax)
	return 1;
  804875:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80487a:	c9                   	leaveq 
  80487b:	c3                   	retq   

000000000080487c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80487c:	55                   	push   %rbp
  80487d:	48 89 e5             	mov    %rsp,%rbp
  804880:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804887:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80488e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804895:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80489c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8048a3:	eb 76                	jmp    80491b <devcons_write+0x9f>
		m = n - tot;
  8048a5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8048ac:	89 c2                	mov    %eax,%edx
  8048ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048b1:	29 c2                	sub    %eax,%edx
  8048b3:	89 d0                	mov    %edx,%eax
  8048b5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8048b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048bb:	83 f8 7f             	cmp    $0x7f,%eax
  8048be:	76 07                	jbe    8048c7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8048c0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8048c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048ca:	48 63 d0             	movslq %eax,%rdx
  8048cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048d0:	48 63 c8             	movslq %eax,%rcx
  8048d3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8048da:	48 01 c1             	add    %rax,%rcx
  8048dd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8048e4:	48 89 ce             	mov    %rcx,%rsi
  8048e7:	48 89 c7             	mov    %rax,%rdi
  8048ea:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8048f1:	00 00 00 
  8048f4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8048f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048f9:	48 63 d0             	movslq %eax,%rdx
  8048fc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804903:	48 89 d6             	mov    %rdx,%rsi
  804906:	48 89 c7             	mov    %rax,%rdi
  804909:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  804910:	00 00 00 
  804913:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804915:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804918:	01 45 fc             	add    %eax,-0x4(%rbp)
  80491b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80491e:	48 98                	cltq   
  804920:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804927:	0f 82 78 ff ff ff    	jb     8048a5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80492d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804930:	c9                   	leaveq 
  804931:	c3                   	retq   

0000000000804932 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804932:	55                   	push   %rbp
  804933:	48 89 e5             	mov    %rsp,%rbp
  804936:	48 83 ec 08          	sub    $0x8,%rsp
  80493a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80493e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804943:	c9                   	leaveq 
  804944:	c3                   	retq   

0000000000804945 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804945:	55                   	push   %rbp
  804946:	48 89 e5             	mov    %rsp,%rbp
  804949:	48 83 ec 10          	sub    $0x10,%rsp
  80494d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804951:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804955:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804959:	48 be 3c 56 80 00 00 	movabs $0x80563c,%rsi
  804960:	00 00 00 
  804963:	48 89 c7             	mov    %rax,%rdi
  804966:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  80496d:	00 00 00 
  804970:	ff d0                	callq  *%rax
	return 0;
  804972:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804977:	c9                   	leaveq 
  804978:	c3                   	retq   

0000000000804979 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804979:	55                   	push   %rbp
  80497a:	48 89 e5             	mov    %rsp,%rbp
  80497d:	48 83 ec 10          	sub    $0x10,%rsp
  804981:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804985:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  80498c:	00 00 00 
  80498f:	48 8b 00             	mov    (%rax),%rax
  804992:	48 85 c0             	test   %rax,%rax
  804995:	0f 85 84 00 00 00    	jne    804a1f <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80499b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8049a2:	00 00 00 
  8049a5:	48 8b 00             	mov    (%rax),%rax
  8049a8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8049ae:	ba 07 00 00 00       	mov    $0x7,%edx
  8049b3:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8049b8:	89 c7                	mov    %eax,%edi
  8049ba:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  8049c1:	00 00 00 
  8049c4:	ff d0                	callq  *%rax
  8049c6:	85 c0                	test   %eax,%eax
  8049c8:	79 2a                	jns    8049f4 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8049ca:	48 ba 48 56 80 00 00 	movabs $0x805648,%rdx
  8049d1:	00 00 00 
  8049d4:	be 23 00 00 00       	mov    $0x23,%esi
  8049d9:	48 bf 6f 56 80 00 00 	movabs $0x80566f,%rdi
  8049e0:	00 00 00 
  8049e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8049e8:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  8049ef:	00 00 00 
  8049f2:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8049f4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8049fb:	00 00 00 
  8049fe:	48 8b 00             	mov    (%rax),%rax
  804a01:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804a07:	48 be 32 4a 80 00 00 	movabs $0x804a32,%rsi
  804a0e:	00 00 00 
  804a11:	89 c7                	mov    %eax,%edi
  804a13:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  804a1a:	00 00 00 
  804a1d:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804a1f:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804a26:	00 00 00 
  804a29:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804a2d:	48 89 10             	mov    %rdx,(%rax)
}
  804a30:	c9                   	leaveq 
  804a31:	c3                   	retq   

0000000000804a32 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804a32:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804a35:	48 a1 08 a0 80 00 00 	movabs 0x80a008,%rax
  804a3c:	00 00 00 
call *%rax
  804a3f:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  804a41:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804a48:	00 
movq 152(%rsp), %rcx  //Load RSP
  804a49:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804a50:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  804a51:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  804a55:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  804a58:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804a5f:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  804a60:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  804a64:	4c 8b 3c 24          	mov    (%rsp),%r15
  804a68:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804a6d:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804a72:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804a77:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804a7c:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804a81:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804a86:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804a8b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804a90:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804a95:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804a9a:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804a9f:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804aa4:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804aa9:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804aae:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  804ab2:	48 83 c4 08          	add    $0x8,%rsp
popfq
  804ab6:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  804ab7:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  804ab8:	c3                   	retq   

0000000000804ab9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804ab9:	55                   	push   %rbp
  804aba:	48 89 e5             	mov    %rsp,%rbp
  804abd:	48 83 ec 30          	sub    $0x30,%rsp
  804ac1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804ac5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804ac9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804acd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804ad4:	00 00 00 
  804ad7:	48 8b 00             	mov    (%rax),%rax
  804ada:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804ae0:	85 c0                	test   %eax,%eax
  804ae2:	75 34                	jne    804b18 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  804ae4:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  804aeb:	00 00 00 
  804aee:	ff d0                	callq  *%rax
  804af0:	25 ff 03 00 00       	and    $0x3ff,%eax
  804af5:	48 98                	cltq   
  804af7:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804afe:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804b05:	00 00 00 
  804b08:	48 01 c2             	add    %rax,%rdx
  804b0b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804b12:	00 00 00 
  804b15:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804b18:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804b1d:	75 0e                	jne    804b2d <ipc_recv+0x74>
		pg = (void*) UTOP;
  804b1f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804b26:	00 00 00 
  804b29:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804b2d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b31:	48 89 c7             	mov    %rax,%rdi
  804b34:	48 b8 94 1c 80 00 00 	movabs $0x801c94,%rax
  804b3b:	00 00 00 
  804b3e:	ff d0                	callq  *%rax
  804b40:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804b43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b47:	79 19                	jns    804b62 <ipc_recv+0xa9>
		*from_env_store = 0;
  804b49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b4d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804b53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b57:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804b5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b60:	eb 53                	jmp    804bb5 <ipc_recv+0xfc>
	}
	if(from_env_store)
  804b62:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804b67:	74 19                	je     804b82 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  804b69:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804b70:	00 00 00 
  804b73:	48 8b 00             	mov    (%rax),%rax
  804b76:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804b7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b80:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804b82:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804b87:	74 19                	je     804ba2 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  804b89:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804b90:	00 00 00 
  804b93:	48 8b 00             	mov    (%rax),%rax
  804b96:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804b9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ba0:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804ba2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804ba9:	00 00 00 
  804bac:	48 8b 00             	mov    (%rax),%rax
  804baf:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804bb5:	c9                   	leaveq 
  804bb6:	c3                   	retq   

0000000000804bb7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804bb7:	55                   	push   %rbp
  804bb8:	48 89 e5             	mov    %rsp,%rbp
  804bbb:	48 83 ec 30          	sub    $0x30,%rsp
  804bbf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804bc2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804bc5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804bc9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804bcc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804bd1:	75 0e                	jne    804be1 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804bd3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804bda:	00 00 00 
  804bdd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804be1:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804be4:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804be7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804beb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804bee:	89 c7                	mov    %eax,%edi
  804bf0:	48 b8 3f 1c 80 00 00 	movabs $0x801c3f,%rax
  804bf7:	00 00 00 
  804bfa:	ff d0                	callq  *%rax
  804bfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804bff:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804c03:	75 0c                	jne    804c11 <ipc_send+0x5a>
			sys_yield();
  804c05:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804c0c:	00 00 00 
  804c0f:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804c11:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804c15:	74 ca                	je     804be1 <ipc_send+0x2a>
	if(result != 0)
  804c17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c1b:	74 20                	je     804c3d <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  804c1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c20:	89 c6                	mov    %eax,%esi
  804c22:	48 bf 7d 56 80 00 00 	movabs $0x80567d,%rdi
  804c29:	00 00 00 
  804c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  804c31:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  804c38:	00 00 00 
  804c3b:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  804c3d:	c9                   	leaveq 
  804c3e:	c3                   	retq   

0000000000804c3f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804c3f:	55                   	push   %rbp
  804c40:	48 89 e5             	mov    %rsp,%rbp
  804c43:	48 83 ec 14          	sub    $0x14,%rsp
  804c47:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804c4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804c51:	eb 4e                	jmp    804ca1 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804c53:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804c5a:	00 00 00 
  804c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c60:	48 98                	cltq   
  804c62:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804c69:	48 01 d0             	add    %rdx,%rax
  804c6c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804c72:	8b 00                	mov    (%rax),%eax
  804c74:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804c77:	75 24                	jne    804c9d <ipc_find_env+0x5e>
			return envs[i].env_id;
  804c79:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804c80:	00 00 00 
  804c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c86:	48 98                	cltq   
  804c88:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804c8f:	48 01 d0             	add    %rdx,%rax
  804c92:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804c98:	8b 40 08             	mov    0x8(%rax),%eax
  804c9b:	eb 12                	jmp    804caf <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804c9d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804ca1:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804ca8:	7e a9                	jle    804c53 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804caf:	c9                   	leaveq 
  804cb0:	c3                   	retq   

0000000000804cb1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804cb1:	55                   	push   %rbp
  804cb2:	48 89 e5             	mov    %rsp,%rbp
  804cb5:	48 83 ec 18          	sub    $0x18,%rsp
  804cb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cc1:	48 c1 e8 15          	shr    $0x15,%rax
  804cc5:	48 89 c2             	mov    %rax,%rdx
  804cc8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804ccf:	01 00 00 
  804cd2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804cd6:	83 e0 01             	and    $0x1,%eax
  804cd9:	48 85 c0             	test   %rax,%rax
  804cdc:	75 07                	jne    804ce5 <pageref+0x34>
		return 0;
  804cde:	b8 00 00 00 00       	mov    $0x0,%eax
  804ce3:	eb 53                	jmp    804d38 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804ce5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ce9:	48 c1 e8 0c          	shr    $0xc,%rax
  804ced:	48 89 c2             	mov    %rax,%rdx
  804cf0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804cf7:	01 00 00 
  804cfa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804cfe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804d02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d06:	83 e0 01             	and    $0x1,%eax
  804d09:	48 85 c0             	test   %rax,%rax
  804d0c:	75 07                	jne    804d15 <pageref+0x64>
		return 0;
  804d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  804d13:	eb 23                	jmp    804d38 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804d15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d19:	48 c1 e8 0c          	shr    $0xc,%rax
  804d1d:	48 89 c2             	mov    %rax,%rdx
  804d20:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804d27:	00 00 00 
  804d2a:	48 c1 e2 04          	shl    $0x4,%rdx
  804d2e:	48 01 d0             	add    %rdx,%rax
  804d31:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804d35:	0f b7 c0             	movzwl %ax,%eax
}
  804d38:	c9                   	leaveq 
  804d39:	c3                   	retq   
