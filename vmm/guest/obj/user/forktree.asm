
vmm/guest/obj/user/forktree:     file format elf64-x86-64


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
  80003c:	e8 24 01 00 00       	callq  800165 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 f0                	mov    %esi,%eax
  800051:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800058:	48 89 c7             	mov    %rax,%rdi
  80005b:	48 b8 79 0e 80 00 00 	movabs $0x800e79,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
  800067:	83 f8 02             	cmp    $0x2,%eax
  80006a:	7f 65                	jg     8000d1 <forkchild+0x8e>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006c:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800078:	41 89 c8             	mov    %ecx,%r8d
  80007b:	48 89 d1             	mov    %rdx,%rcx
  80007e:	48 ba 60 42 80 00 00 	movabs $0x804260,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 98 0d 80 00 00 	movabs $0x800d98,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 4d 1f 80 00 00 	movabs $0x801f4d,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 1f                	jne    8000d1 <forkchild+0x8e>
		forktree(nxt);
  8000b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b6:	48 89 c7             	mov    %rax,%rdi
  8000b9:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
		exit();
  8000c5:	48 b8 e8 01 80 00 00 	movabs $0x8001e8,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
	}
}
  8000d1:	c9                   	leaveq 
  8000d2:	c3                   	retq   

00000000008000d3 <forktree>:

void
forktree(const char *cur)
{
  8000d3:	55                   	push   %rbp
  8000d4:	48 89 e5             	mov    %rsp,%rbp
  8000d7:	48 83 ec 10          	sub    $0x10,%rsp
  8000db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000df:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	callq  *%rax
  8000eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  8000f8:	00 00 00 
  8000fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800100:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  800107:	00 00 00 
  80010a:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  80010c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800110:	be 30 00 00 00       	mov    $0x30,%esi
  800115:	48 89 c7             	mov    %rax,%rdi
  800118:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  800124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800128:	be 31 00 00 00       	mov    $0x31,%esi
  80012d:	48 89 c7             	mov    %rax,%rdi
  800130:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800137:	00 00 00 
  80013a:	ff d0                	callq  *%rax
}
  80013c:	c9                   	leaveq 
  80013d:	c3                   	retq   

000000000080013e <umain>:

void
umain(int argc, char **argv)
{
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	48 83 ec 10          	sub    $0x10,%rsp
  800146:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800149:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  80014d:	48 bf 76 42 80 00 00 	movabs $0x804276,%rdi
  800154:	00 00 00 
  800157:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
}
  800163:	c9                   	leaveq 
  800164:	c3                   	retq   

0000000000800165 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800165:	55                   	push   %rbp
  800166:	48 89 e5             	mov    %rsp,%rbp
  800169:	48 83 ec 10          	sub    $0x10,%rsp
  80016d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800170:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800174:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	25 ff 03 00 00       	and    $0x3ff,%eax
  800185:	48 98                	cltq   
  800187:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80018e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800195:	00 00 00 
  800198:	48 01 c2             	add    %rax,%rdx
  80019b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001a2:	00 00 00 
  8001a5:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001ac:	7e 14                	jle    8001c2 <libmain+0x5d>
		binaryname = argv[0];
  8001ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b2:	48 8b 10             	mov    (%rax),%rdx
  8001b5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001bc:	00 00 00 
  8001bf:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001c9:	48 89 d6             	mov    %rdx,%rsi
  8001cc:	89 c7                	mov    %eax,%edi
  8001ce:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8001d5:	00 00 00 
  8001d8:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001da:	48 b8 e8 01 80 00 00 	movabs $0x8001e8,%rax
  8001e1:	00 00 00 
  8001e4:	ff d0                	callq  *%rax
}
  8001e6:	c9                   	leaveq 
  8001e7:	c3                   	retq   

00000000008001e8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e8:	55                   	push   %rbp
  8001e9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001ec:	48 b8 37 25 80 00 00 	movabs $0x802537,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fd:	48 b8 54 17 80 00 00 	movabs $0x801754,%rax
  800204:	00 00 00 
  800207:	ff d0                	callq  *%rax

}
  800209:	5d                   	pop    %rbp
  80020a:	c3                   	retq   

000000000080020b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80020b:	55                   	push   %rbp
  80020c:	48 89 e5             	mov    %rsp,%rbp
  80020f:	48 83 ec 10          	sub    $0x10,%rsp
  800213:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800216:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80021a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021e:	8b 00                	mov    (%rax),%eax
  800220:	8d 48 01             	lea    0x1(%rax),%ecx
  800223:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800227:	89 0a                	mov    %ecx,(%rdx)
  800229:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80022c:	89 d1                	mov    %edx,%ecx
  80022e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800232:	48 98                	cltq   
  800234:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023c:	8b 00                	mov    (%rax),%eax
  80023e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800243:	75 2c                	jne    800271 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800249:	8b 00                	mov    (%rax),%eax
  80024b:	48 98                	cltq   
  80024d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800251:	48 83 c2 08          	add    $0x8,%rdx
  800255:	48 89 c6             	mov    %rax,%rsi
  800258:	48 89 d7             	mov    %rdx,%rdi
  80025b:	48 b8 cc 16 80 00 00 	movabs $0x8016cc,%rax
  800262:	00 00 00 
  800265:	ff d0                	callq  *%rax
        b->idx = 0;
  800267:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800275:	8b 40 04             	mov    0x4(%rax),%eax
  800278:	8d 50 01             	lea    0x1(%rax),%edx
  80027b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80027f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800282:	c9                   	leaveq 
  800283:	c3                   	retq   

0000000000800284 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800284:	55                   	push   %rbp
  800285:	48 89 e5             	mov    %rsp,%rbp
  800288:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80028f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800296:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80029d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002a4:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002ab:	48 8b 0a             	mov    (%rdx),%rcx
  8002ae:	48 89 08             	mov    %rcx,(%rax)
  8002b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002c8:	00 00 00 
    b.cnt = 0;
  8002cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002d2:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002d5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002dc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002e3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002ea:	48 89 c6             	mov    %rax,%rsi
  8002ed:	48 bf 0b 02 80 00 00 	movabs $0x80020b,%rdi
  8002f4:	00 00 00 
  8002f7:	48 b8 e3 06 80 00 00 	movabs $0x8006e3,%rax
  8002fe:	00 00 00 
  800301:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800303:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800309:	48 98                	cltq   
  80030b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800312:	48 83 c2 08          	add    $0x8,%rdx
  800316:	48 89 c6             	mov    %rax,%rsi
  800319:	48 89 d7             	mov    %rdx,%rdi
  80031c:	48 b8 cc 16 80 00 00 	movabs $0x8016cc,%rax
  800323:	00 00 00 
  800326:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800328:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80032e:	c9                   	leaveq 
  80032f:	c3                   	retq   

0000000000800330 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800330:	55                   	push   %rbp
  800331:	48 89 e5             	mov    %rsp,%rbp
  800334:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80033b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800342:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800349:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800350:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800357:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80035e:	84 c0                	test   %al,%al
  800360:	74 20                	je     800382 <cprintf+0x52>
  800362:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800366:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80036a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80036e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800372:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800376:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80037a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80037e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800382:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800389:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800390:	00 00 00 
  800393:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80039a:	00 00 00 
  80039d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003a1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003a8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003af:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003b6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003bd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003c4:	48 8b 0a             	mov    (%rdx),%rcx
  8003c7:	48 89 08             	mov    %rcx,(%rax)
  8003ca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003ce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003d2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003d6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003da:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003e8:	48 89 d6             	mov    %rdx,%rsi
  8003eb:	48 89 c7             	mov    %rax,%rdi
  8003ee:	48 b8 84 02 80 00 00 	movabs $0x800284,%rax
  8003f5:	00 00 00 
  8003f8:	ff d0                	callq  *%rax
  8003fa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800400:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800406:	c9                   	leaveq 
  800407:	c3                   	retq   

0000000000800408 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800408:	55                   	push   %rbp
  800409:	48 89 e5             	mov    %rsp,%rbp
  80040c:	53                   	push   %rbx
  80040d:	48 83 ec 38          	sub    $0x38,%rsp
  800411:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800415:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800419:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80041d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800420:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800424:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800428:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80042b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80042f:	77 3b                	ja     80046c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800431:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800434:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800438:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80043b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80043f:	ba 00 00 00 00       	mov    $0x0,%edx
  800444:	48 f7 f3             	div    %rbx
  800447:	48 89 c2             	mov    %rax,%rdx
  80044a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80044d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800450:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800458:	41 89 f9             	mov    %edi,%r9d
  80045b:	48 89 c7             	mov    %rax,%rdi
  80045e:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800465:	00 00 00 
  800468:	ff d0                	callq  *%rax
  80046a:	eb 1e                	jmp    80048a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80046c:	eb 12                	jmp    800480 <printnum+0x78>
			putch(padc, putdat);
  80046e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800472:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800479:	48 89 ce             	mov    %rcx,%rsi
  80047c:	89 d7                	mov    %edx,%edi
  80047e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800480:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800484:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800488:	7f e4                	jg     80046e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80048a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80048d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800491:	ba 00 00 00 00       	mov    $0x0,%edx
  800496:	48 f7 f1             	div    %rcx
  800499:	48 89 d0             	mov    %rdx,%rax
  80049c:	48 ba 90 44 80 00 00 	movabs $0x804490,%rdx
  8004a3:	00 00 00 
  8004a6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004aa:	0f be d0             	movsbl %al,%edx
  8004ad:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b5:	48 89 ce             	mov    %rcx,%rsi
  8004b8:	89 d7                	mov    %edx,%edi
  8004ba:	ff d0                	callq  *%rax
}
  8004bc:	48 83 c4 38          	add    $0x38,%rsp
  8004c0:	5b                   	pop    %rbx
  8004c1:	5d                   	pop    %rbp
  8004c2:	c3                   	retq   

00000000008004c3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004c3:	55                   	push   %rbp
  8004c4:	48 89 e5             	mov    %rsp,%rbp
  8004c7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004d2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004d6:	7e 52                	jle    80052a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004dc:	8b 00                	mov    (%rax),%eax
  8004de:	83 f8 30             	cmp    $0x30,%eax
  8004e1:	73 24                	jae    800507 <getuint+0x44>
  8004e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ef:	8b 00                	mov    (%rax),%eax
  8004f1:	89 c0                	mov    %eax,%eax
  8004f3:	48 01 d0             	add    %rdx,%rax
  8004f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fa:	8b 12                	mov    (%rdx),%edx
  8004fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800503:	89 0a                	mov    %ecx,(%rdx)
  800505:	eb 17                	jmp    80051e <getuint+0x5b>
  800507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80050f:	48 89 d0             	mov    %rdx,%rax
  800512:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800516:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80051e:	48 8b 00             	mov    (%rax),%rax
  800521:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800525:	e9 a3 00 00 00       	jmpq   8005cd <getuint+0x10a>
	else if (lflag)
  80052a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80052e:	74 4f                	je     80057f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800534:	8b 00                	mov    (%rax),%eax
  800536:	83 f8 30             	cmp    $0x30,%eax
  800539:	73 24                	jae    80055f <getuint+0x9c>
  80053b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800547:	8b 00                	mov    (%rax),%eax
  800549:	89 c0                	mov    %eax,%eax
  80054b:	48 01 d0             	add    %rdx,%rax
  80054e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800552:	8b 12                	mov    (%rdx),%edx
  800554:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800557:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055b:	89 0a                	mov    %ecx,(%rdx)
  80055d:	eb 17                	jmp    800576 <getuint+0xb3>
  80055f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800563:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800567:	48 89 d0             	mov    %rdx,%rax
  80056a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80056e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800572:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800576:	48 8b 00             	mov    (%rax),%rax
  800579:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80057d:	eb 4e                	jmp    8005cd <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80057f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800583:	8b 00                	mov    (%rax),%eax
  800585:	83 f8 30             	cmp    $0x30,%eax
  800588:	73 24                	jae    8005ae <getuint+0xeb>
  80058a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800596:	8b 00                	mov    (%rax),%eax
  800598:	89 c0                	mov    %eax,%eax
  80059a:	48 01 d0             	add    %rdx,%rax
  80059d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a1:	8b 12                	mov    (%rdx),%edx
  8005a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	89 0a                	mov    %ecx,(%rdx)
  8005ac:	eb 17                	jmp    8005c5 <getuint+0x102>
  8005ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b6:	48 89 d0             	mov    %rdx,%rax
  8005b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c5:	8b 00                	mov    (%rax),%eax
  8005c7:	89 c0                	mov    %eax,%eax
  8005c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005d1:	c9                   	leaveq 
  8005d2:	c3                   	retq   

00000000008005d3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d3:	55                   	push   %rbp
  8005d4:	48 89 e5             	mov    %rsp,%rbp
  8005d7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005e2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005e6:	7e 52                	jle    80063a <getint+0x67>
		x=va_arg(*ap, long long);
  8005e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ec:	8b 00                	mov    (%rax),%eax
  8005ee:	83 f8 30             	cmp    $0x30,%eax
  8005f1:	73 24                	jae    800617 <getint+0x44>
  8005f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ff:	8b 00                	mov    (%rax),%eax
  800601:	89 c0                	mov    %eax,%eax
  800603:	48 01 d0             	add    %rdx,%rax
  800606:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060a:	8b 12                	mov    (%rdx),%edx
  80060c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80060f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800613:	89 0a                	mov    %ecx,(%rdx)
  800615:	eb 17                	jmp    80062e <getint+0x5b>
  800617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80061f:	48 89 d0             	mov    %rdx,%rax
  800622:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800626:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062e:	48 8b 00             	mov    (%rax),%rax
  800631:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800635:	e9 a3 00 00 00       	jmpq   8006dd <getint+0x10a>
	else if (lflag)
  80063a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80063e:	74 4f                	je     80068f <getint+0xbc>
		x=va_arg(*ap, long);
  800640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800644:	8b 00                	mov    (%rax),%eax
  800646:	83 f8 30             	cmp    $0x30,%eax
  800649:	73 24                	jae    80066f <getint+0x9c>
  80064b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800657:	8b 00                	mov    (%rax),%eax
  800659:	89 c0                	mov    %eax,%eax
  80065b:	48 01 d0             	add    %rdx,%rax
  80065e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800662:	8b 12                	mov    (%rdx),%edx
  800664:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800667:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066b:	89 0a                	mov    %ecx,(%rdx)
  80066d:	eb 17                	jmp    800686 <getint+0xb3>
  80066f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800673:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800677:	48 89 d0             	mov    %rdx,%rax
  80067a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800682:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80068d:	eb 4e                	jmp    8006dd <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	8b 00                	mov    (%rax),%eax
  800695:	83 f8 30             	cmp    $0x30,%eax
  800698:	73 24                	jae    8006be <getint+0xeb>
  80069a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a6:	8b 00                	mov    (%rax),%eax
  8006a8:	89 c0                	mov    %eax,%eax
  8006aa:	48 01 d0             	add    %rdx,%rax
  8006ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b1:	8b 12                	mov    (%rdx),%edx
  8006b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ba:	89 0a                	mov    %ecx,(%rdx)
  8006bc:	eb 17                	jmp    8006d5 <getint+0x102>
  8006be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c6:	48 89 d0             	mov    %rdx,%rax
  8006c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d5:	8b 00                	mov    (%rax),%eax
  8006d7:	48 98                	cltq   
  8006d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006e1:	c9                   	leaveq 
  8006e2:	c3                   	retq   

00000000008006e3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e3:	55                   	push   %rbp
  8006e4:	48 89 e5             	mov    %rsp,%rbp
  8006e7:	41 54                	push   %r12
  8006e9:	53                   	push   %rbx
  8006ea:	48 83 ec 60          	sub    $0x60,%rsp
  8006ee:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006f2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006f6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006fa:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006fe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800702:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800706:	48 8b 0a             	mov    (%rdx),%rcx
  800709:	48 89 08             	mov    %rcx,(%rax)
  80070c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800710:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800714:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800718:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071c:	eb 17                	jmp    800735 <vprintfmt+0x52>
			if (ch == '\0')
  80071e:	85 db                	test   %ebx,%ebx
  800720:	0f 84 cc 04 00 00    	je     800bf2 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800726:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80072a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80072e:	48 89 d6             	mov    %rdx,%rsi
  800731:	89 df                	mov    %ebx,%edi
  800733:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800735:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800739:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80073d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800741:	0f b6 00             	movzbl (%rax),%eax
  800744:	0f b6 d8             	movzbl %al,%ebx
  800747:	83 fb 25             	cmp    $0x25,%ebx
  80074a:	75 d2                	jne    80071e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80074c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800750:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800757:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80075e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800765:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800770:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800774:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800778:	0f b6 00             	movzbl (%rax),%eax
  80077b:	0f b6 d8             	movzbl %al,%ebx
  80077e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800781:	83 f8 55             	cmp    $0x55,%eax
  800784:	0f 87 34 04 00 00    	ja     800bbe <vprintfmt+0x4db>
  80078a:	89 c0                	mov    %eax,%eax
  80078c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800793:	00 
  800794:	48 b8 b8 44 80 00 00 	movabs $0x8044b8,%rax
  80079b:	00 00 00 
  80079e:	48 01 d0             	add    %rdx,%rax
  8007a1:	48 8b 00             	mov    (%rax),%rax
  8007a4:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8007a6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007aa:	eb c0                	jmp    80076c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ac:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007b0:	eb ba                	jmp    80076c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007b9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	c1 e0 02             	shl    $0x2,%eax
  8007c1:	01 d0                	add    %edx,%eax
  8007c3:	01 c0                	add    %eax,%eax
  8007c5:	01 d8                	add    %ebx,%eax
  8007c7:	83 e8 30             	sub    $0x30,%eax
  8007ca:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007cd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d1:	0f b6 00             	movzbl (%rax),%eax
  8007d4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007d7:	83 fb 2f             	cmp    $0x2f,%ebx
  8007da:	7e 0c                	jle    8007e8 <vprintfmt+0x105>
  8007dc:	83 fb 39             	cmp    $0x39,%ebx
  8007df:	7f 07                	jg     8007e8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007e6:	eb d1                	jmp    8007b9 <vprintfmt+0xd6>
			goto process_precision;
  8007e8:	eb 58                	jmp    800842 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007ea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ed:	83 f8 30             	cmp    $0x30,%eax
  8007f0:	73 17                	jae    800809 <vprintfmt+0x126>
  8007f2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f9:	89 c0                	mov    %eax,%eax
  8007fb:	48 01 d0             	add    %rdx,%rax
  8007fe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800801:	83 c2 08             	add    $0x8,%edx
  800804:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800807:	eb 0f                	jmp    800818 <vprintfmt+0x135>
  800809:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80080d:	48 89 d0             	mov    %rdx,%rax
  800810:	48 83 c2 08          	add    $0x8,%rdx
  800814:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800818:	8b 00                	mov    (%rax),%eax
  80081a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80081d:	eb 23                	jmp    800842 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80081f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800823:	79 0c                	jns    800831 <vprintfmt+0x14e>
				width = 0;
  800825:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80082c:	e9 3b ff ff ff       	jmpq   80076c <vprintfmt+0x89>
  800831:	e9 36 ff ff ff       	jmpq   80076c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800836:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80083d:	e9 2a ff ff ff       	jmpq   80076c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800842:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800846:	79 12                	jns    80085a <vprintfmt+0x177>
				width = precision, precision = -1;
  800848:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80084b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80084e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800855:	e9 12 ff ff ff       	jmpq   80076c <vprintfmt+0x89>
  80085a:	e9 0d ff ff ff       	jmpq   80076c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80085f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800863:	e9 04 ff ff ff       	jmpq   80076c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800868:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086b:	83 f8 30             	cmp    $0x30,%eax
  80086e:	73 17                	jae    800887 <vprintfmt+0x1a4>
  800870:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800874:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800877:	89 c0                	mov    %eax,%eax
  800879:	48 01 d0             	add    %rdx,%rax
  80087c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80087f:	83 c2 08             	add    $0x8,%edx
  800882:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800885:	eb 0f                	jmp    800896 <vprintfmt+0x1b3>
  800887:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80088b:	48 89 d0             	mov    %rdx,%rax
  80088e:	48 83 c2 08          	add    $0x8,%rdx
  800892:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800896:	8b 10                	mov    (%rax),%edx
  800898:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80089c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008a0:	48 89 ce             	mov    %rcx,%rsi
  8008a3:	89 d7                	mov    %edx,%edi
  8008a5:	ff d0                	callq  *%rax
			break;
  8008a7:	e9 40 03 00 00       	jmpq   800bec <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8008ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008af:	83 f8 30             	cmp    $0x30,%eax
  8008b2:	73 17                	jae    8008cb <vprintfmt+0x1e8>
  8008b4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008b8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008bb:	89 c0                	mov    %eax,%eax
  8008bd:	48 01 d0             	add    %rdx,%rax
  8008c0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008c3:	83 c2 08             	add    $0x8,%edx
  8008c6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008c9:	eb 0f                	jmp    8008da <vprintfmt+0x1f7>
  8008cb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008cf:	48 89 d0             	mov    %rdx,%rax
  8008d2:	48 83 c2 08          	add    $0x8,%rdx
  8008d6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008da:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008dc:	85 db                	test   %ebx,%ebx
  8008de:	79 02                	jns    8008e2 <vprintfmt+0x1ff>
				err = -err;
  8008e0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008e2:	83 fb 15             	cmp    $0x15,%ebx
  8008e5:	7f 16                	jg     8008fd <vprintfmt+0x21a>
  8008e7:	48 b8 e0 43 80 00 00 	movabs $0x8043e0,%rax
  8008ee:	00 00 00 
  8008f1:	48 63 d3             	movslq %ebx,%rdx
  8008f4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008f8:	4d 85 e4             	test   %r12,%r12
  8008fb:	75 2e                	jne    80092b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800901:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800905:	89 d9                	mov    %ebx,%ecx
  800907:	48 ba a1 44 80 00 00 	movabs $0x8044a1,%rdx
  80090e:	00 00 00 
  800911:	48 89 c7             	mov    %rax,%rdi
  800914:	b8 00 00 00 00       	mov    $0x0,%eax
  800919:	49 b8 fb 0b 80 00 00 	movabs $0x800bfb,%r8
  800920:	00 00 00 
  800923:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800926:	e9 c1 02 00 00       	jmpq   800bec <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80092b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80092f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800933:	4c 89 e1             	mov    %r12,%rcx
  800936:	48 ba aa 44 80 00 00 	movabs $0x8044aa,%rdx
  80093d:	00 00 00 
  800940:	48 89 c7             	mov    %rax,%rdi
  800943:	b8 00 00 00 00       	mov    $0x0,%eax
  800948:	49 b8 fb 0b 80 00 00 	movabs $0x800bfb,%r8
  80094f:	00 00 00 
  800952:	41 ff d0             	callq  *%r8
			break;
  800955:	e9 92 02 00 00       	jmpq   800bec <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80095a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095d:	83 f8 30             	cmp    $0x30,%eax
  800960:	73 17                	jae    800979 <vprintfmt+0x296>
  800962:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800966:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800969:	89 c0                	mov    %eax,%eax
  80096b:	48 01 d0             	add    %rdx,%rax
  80096e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800971:	83 c2 08             	add    $0x8,%edx
  800974:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800977:	eb 0f                	jmp    800988 <vprintfmt+0x2a5>
  800979:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80097d:	48 89 d0             	mov    %rdx,%rax
  800980:	48 83 c2 08          	add    $0x8,%rdx
  800984:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800988:	4c 8b 20             	mov    (%rax),%r12
  80098b:	4d 85 e4             	test   %r12,%r12
  80098e:	75 0a                	jne    80099a <vprintfmt+0x2b7>
				p = "(null)";
  800990:	49 bc ad 44 80 00 00 	movabs $0x8044ad,%r12
  800997:	00 00 00 
			if (width > 0 && padc != '-')
  80099a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099e:	7e 3f                	jle    8009df <vprintfmt+0x2fc>
  8009a0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009a4:	74 39                	je     8009df <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009a9:	48 98                	cltq   
  8009ab:	48 89 c6             	mov    %rax,%rsi
  8009ae:	4c 89 e7             	mov    %r12,%rdi
  8009b1:	48 b8 a7 0e 80 00 00 	movabs $0x800ea7,%rax
  8009b8:	00 00 00 
  8009bb:	ff d0                	callq  *%rax
  8009bd:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009c0:	eb 17                	jmp    8009d9 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009c2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009c6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ce:	48 89 ce             	mov    %rcx,%rsi
  8009d1:	89 d7                	mov    %edx,%edi
  8009d3:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009dd:	7f e3                	jg     8009c2 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009df:	eb 37                	jmp    800a18 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009e5:	74 1e                	je     800a05 <vprintfmt+0x322>
  8009e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ea:	7e 05                	jle    8009f1 <vprintfmt+0x30e>
  8009ec:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ef:	7e 14                	jle    800a05 <vprintfmt+0x322>
					putch('?', putdat);
  8009f1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f9:	48 89 d6             	mov    %rdx,%rsi
  8009fc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a01:	ff d0                	callq  *%rax
  800a03:	eb 0f                	jmp    800a14 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0d:	48 89 d6             	mov    %rdx,%rsi
  800a10:	89 df                	mov    %ebx,%edi
  800a12:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a14:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a18:	4c 89 e0             	mov    %r12,%rax
  800a1b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a1f:	0f b6 00             	movzbl (%rax),%eax
  800a22:	0f be d8             	movsbl %al,%ebx
  800a25:	85 db                	test   %ebx,%ebx
  800a27:	74 10                	je     800a39 <vprintfmt+0x356>
  800a29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a2d:	78 b2                	js     8009e1 <vprintfmt+0x2fe>
  800a2f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a33:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a37:	79 a8                	jns    8009e1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a39:	eb 16                	jmp    800a51 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a43:	48 89 d6             	mov    %rdx,%rsi
  800a46:	bf 20 00 00 00       	mov    $0x20,%edi
  800a4b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a4d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a51:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a55:	7f e4                	jg     800a3b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a57:	e9 90 01 00 00       	jmpq   800bec <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a60:	be 03 00 00 00       	mov    $0x3,%esi
  800a65:	48 89 c7             	mov    %rax,%rdi
  800a68:	48 b8 d3 05 80 00 00 	movabs $0x8005d3,%rax
  800a6f:	00 00 00 
  800a72:	ff d0                	callq  *%rax
  800a74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	48 85 c0             	test   %rax,%rax
  800a7f:	79 1d                	jns    800a9e <vprintfmt+0x3bb>
				putch('-', putdat);
  800a81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a89:	48 89 d6             	mov    %rdx,%rsi
  800a8c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a91:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a97:	48 f7 d8             	neg    %rax
  800a9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a9e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800aa5:	e9 d5 00 00 00       	jmpq   800b7f <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800aaa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aae:	be 03 00 00 00       	mov    $0x3,%esi
  800ab3:	48 89 c7             	mov    %rax,%rdi
  800ab6:	48 b8 c3 04 80 00 00 	movabs $0x8004c3,%rax
  800abd:	00 00 00 
  800ac0:	ff d0                	callq  *%rax
  800ac2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ac6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800acd:	e9 ad 00 00 00       	jmpq   800b7f <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800ad2:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800ad5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ad9:	89 d6                	mov    %edx,%esi
  800adb:	48 89 c7             	mov    %rax,%rdi
  800ade:	48 b8 d3 05 80 00 00 	movabs $0x8005d3,%rax
  800ae5:	00 00 00 
  800ae8:	ff d0                	callq  *%rax
  800aea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800aee:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800af5:	e9 85 00 00 00       	jmpq   800b7f <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800afa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b02:	48 89 d6             	mov    %rdx,%rsi
  800b05:	bf 30 00 00 00       	mov    $0x30,%edi
  800b0a:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b14:	48 89 d6             	mov    %rdx,%rsi
  800b17:	bf 78 00 00 00       	mov    $0x78,%edi
  800b1c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b21:	83 f8 30             	cmp    $0x30,%eax
  800b24:	73 17                	jae    800b3d <vprintfmt+0x45a>
  800b26:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b2d:	89 c0                	mov    %eax,%eax
  800b2f:	48 01 d0             	add    %rdx,%rax
  800b32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b35:	83 c2 08             	add    $0x8,%edx
  800b38:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3b:	eb 0f                	jmp    800b4c <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b41:	48 89 d0             	mov    %rdx,%rax
  800b44:	48 83 c2 08          	add    $0x8,%rdx
  800b48:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b4c:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b53:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b5a:	eb 23                	jmp    800b7f <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b60:	be 03 00 00 00       	mov    $0x3,%esi
  800b65:	48 89 c7             	mov    %rax,%rdi
  800b68:	48 b8 c3 04 80 00 00 	movabs $0x8004c3,%rax
  800b6f:	00 00 00 
  800b72:	ff d0                	callq  *%rax
  800b74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b78:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b7f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b84:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b87:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b8e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b96:	45 89 c1             	mov    %r8d,%r9d
  800b99:	41 89 f8             	mov    %edi,%r8d
  800b9c:	48 89 c7             	mov    %rax,%rdi
  800b9f:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800ba6:	00 00 00 
  800ba9:	ff d0                	callq  *%rax
			break;
  800bab:	eb 3f                	jmp    800bec <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb5:	48 89 d6             	mov    %rdx,%rsi
  800bb8:	89 df                	mov    %ebx,%edi
  800bba:	ff d0                	callq  *%rax
			break;
  800bbc:	eb 2e                	jmp    800bec <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc6:	48 89 d6             	mov    %rdx,%rsi
  800bc9:	bf 25 00 00 00       	mov    $0x25,%edi
  800bce:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bd5:	eb 05                	jmp    800bdc <vprintfmt+0x4f9>
  800bd7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bdc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800be0:	48 83 e8 01          	sub    $0x1,%rax
  800be4:	0f b6 00             	movzbl (%rax),%eax
  800be7:	3c 25                	cmp    $0x25,%al
  800be9:	75 ec                	jne    800bd7 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800beb:	90                   	nop
		}
	}
  800bec:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bed:	e9 43 fb ff ff       	jmpq   800735 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bf2:	48 83 c4 60          	add    $0x60,%rsp
  800bf6:	5b                   	pop    %rbx
  800bf7:	41 5c                	pop    %r12
  800bf9:	5d                   	pop    %rbp
  800bfa:	c3                   	retq   

0000000000800bfb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bfb:	55                   	push   %rbp
  800bfc:	48 89 e5             	mov    %rsp,%rbp
  800bff:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c06:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c0d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c14:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c1b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c22:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 20                	je     800c4d <printfmt+0x52>
  800c2d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c31:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c35:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c39:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c3d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c41:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c45:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c49:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c4d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c54:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c5b:	00 00 00 
  800c5e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c65:	00 00 00 
  800c68:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c6c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c73:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c7a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c81:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c88:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c8f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c96:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c9d:	48 89 c7             	mov    %rax,%rdi
  800ca0:	48 b8 e3 06 80 00 00 	movabs $0x8006e3,%rax
  800ca7:	00 00 00 
  800caa:	ff d0                	callq  *%rax
	va_end(ap);
}
  800cac:	c9                   	leaveq 
  800cad:	c3                   	retq   

0000000000800cae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cae:	55                   	push   %rbp
  800caf:	48 89 e5             	mov    %rsp,%rbp
  800cb2:	48 83 ec 10          	sub    $0x10,%rsp
  800cb6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc1:	8b 40 10             	mov    0x10(%rax),%eax
  800cc4:	8d 50 01             	lea    0x1(%rax),%edx
  800cc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ccb:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd2:	48 8b 10             	mov    (%rax),%rdx
  800cd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd9:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cdd:	48 39 c2             	cmp    %rax,%rdx
  800ce0:	73 17                	jae    800cf9 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ce6:	48 8b 00             	mov    (%rax),%rax
  800ce9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ced:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cf1:	48 89 0a             	mov    %rcx,(%rdx)
  800cf4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cf7:	88 10                	mov    %dl,(%rax)
}
  800cf9:	c9                   	leaveq 
  800cfa:	c3                   	retq   

0000000000800cfb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cfb:	55                   	push   %rbp
  800cfc:	48 89 e5             	mov    %rsp,%rbp
  800cff:	48 83 ec 50          	sub    $0x50,%rsp
  800d03:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d07:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d0a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d0e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d12:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d16:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d1a:	48 8b 0a             	mov    (%rdx),%rcx
  800d1d:	48 89 08             	mov    %rcx,(%rax)
  800d20:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d24:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d28:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d2c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d30:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d34:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d38:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d3b:	48 98                	cltq   
  800d3d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d41:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d45:	48 01 d0             	add    %rdx,%rax
  800d48:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d4c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d53:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d58:	74 06                	je     800d60 <vsnprintf+0x65>
  800d5a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d5e:	7f 07                	jg     800d67 <vsnprintf+0x6c>
		return -E_INVAL;
  800d60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d65:	eb 2f                	jmp    800d96 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d67:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d6b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d6f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d73:	48 89 c6             	mov    %rax,%rsi
  800d76:	48 bf ae 0c 80 00 00 	movabs $0x800cae,%rdi
  800d7d:	00 00 00 
  800d80:	48 b8 e3 06 80 00 00 	movabs $0x8006e3,%rax
  800d87:	00 00 00 
  800d8a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d90:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d93:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d96:	c9                   	leaveq 
  800d97:	c3                   	retq   

0000000000800d98 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d98:	55                   	push   %rbp
  800d99:	48 89 e5             	mov    %rsp,%rbp
  800d9c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800da3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800daa:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800db0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800db7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dbe:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dc5:	84 c0                	test   %al,%al
  800dc7:	74 20                	je     800de9 <snprintf+0x51>
  800dc9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dcd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dd1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dd5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dd9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ddd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800de1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800de5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800de9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800df0:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800df7:	00 00 00 
  800dfa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e01:	00 00 00 
  800e04:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e08:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e0f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e16:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e1d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e24:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e2b:	48 8b 0a             	mov    (%rdx),%rcx
  800e2e:	48 89 08             	mov    %rcx,(%rax)
  800e31:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e35:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e39:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e3d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e41:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e48:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e4f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e55:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e5c:	48 89 c7             	mov    %rax,%rdi
  800e5f:	48 b8 fb 0c 80 00 00 	movabs $0x800cfb,%rax
  800e66:	00 00 00 
  800e69:	ff d0                	callq  *%rax
  800e6b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e71:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e77:	c9                   	leaveq 
  800e78:	c3                   	retq   

0000000000800e79 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e79:	55                   	push   %rbp
  800e7a:	48 89 e5             	mov    %rsp,%rbp
  800e7d:	48 83 ec 18          	sub    $0x18,%rsp
  800e81:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e8c:	eb 09                	jmp    800e97 <strlen+0x1e>
		n++;
  800e8e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e92:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9b:	0f b6 00             	movzbl (%rax),%eax
  800e9e:	84 c0                	test   %al,%al
  800ea0:	75 ec                	jne    800e8e <strlen+0x15>
		n++;
	return n;
  800ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ea5:	c9                   	leaveq 
  800ea6:	c3                   	retq   

0000000000800ea7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ea7:	55                   	push   %rbp
  800ea8:	48 89 e5             	mov    %rsp,%rbp
  800eab:	48 83 ec 20          	sub    $0x20,%rsp
  800eaf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ebe:	eb 0e                	jmp    800ece <strnlen+0x27>
		n++;
  800ec0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ec9:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ece:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ed3:	74 0b                	je     800ee0 <strnlen+0x39>
  800ed5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed9:	0f b6 00             	movzbl (%rax),%eax
  800edc:	84 c0                	test   %al,%al
  800ede:	75 e0                	jne    800ec0 <strnlen+0x19>
		n++;
	return n;
  800ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ee3:	c9                   	leaveq 
  800ee4:	c3                   	retq   

0000000000800ee5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ee5:	55                   	push   %rbp
  800ee6:	48 89 e5             	mov    %rsp,%rbp
  800ee9:	48 83 ec 20          	sub    $0x20,%rsp
  800eed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ef5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800efd:	90                   	nop
  800efe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f02:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f06:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f0a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f0e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f12:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f16:	0f b6 12             	movzbl (%rdx),%edx
  800f19:	88 10                	mov    %dl,(%rax)
  800f1b:	0f b6 00             	movzbl (%rax),%eax
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 dc                	jne    800efe <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f26:	c9                   	leaveq 
  800f27:	c3                   	retq   

0000000000800f28 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f28:	55                   	push   %rbp
  800f29:	48 89 e5             	mov    %rsp,%rbp
  800f2c:	48 83 ec 20          	sub    $0x20,%rsp
  800f30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3c:	48 89 c7             	mov    %rax,%rdi
  800f3f:	48 b8 79 0e 80 00 00 	movabs $0x800e79,%rax
  800f46:	00 00 00 
  800f49:	ff d0                	callq  *%rax
  800f4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f51:	48 63 d0             	movslq %eax,%rdx
  800f54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f58:	48 01 c2             	add    %rax,%rdx
  800f5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f5f:	48 89 c6             	mov    %rax,%rsi
  800f62:	48 89 d7             	mov    %rdx,%rdi
  800f65:	48 b8 e5 0e 80 00 00 	movabs $0x800ee5,%rax
  800f6c:	00 00 00 
  800f6f:	ff d0                	callq  *%rax
	return dst;
  800f71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f75:	c9                   	leaveq 
  800f76:	c3                   	retq   

0000000000800f77 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f77:	55                   	push   %rbp
  800f78:	48 89 e5             	mov    %rsp,%rbp
  800f7b:	48 83 ec 28          	sub    $0x28,%rsp
  800f7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f87:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f93:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f9a:	00 
  800f9b:	eb 2a                	jmp    800fc7 <strncpy+0x50>
		*dst++ = *src;
  800f9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fa5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fad:	0f b6 12             	movzbl (%rdx),%edx
  800fb0:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fb6:	0f b6 00             	movzbl (%rax),%eax
  800fb9:	84 c0                	test   %al,%al
  800fbb:	74 05                	je     800fc2 <strncpy+0x4b>
			src++;
  800fbd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fc2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fcb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fcf:	72 cc                	jb     800f9d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fd5:	c9                   	leaveq 
  800fd6:	c3                   	retq   

0000000000800fd7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fd7:	55                   	push   %rbp
  800fd8:	48 89 e5             	mov    %rsp,%rbp
  800fdb:	48 83 ec 28          	sub    $0x28,%rsp
  800fdf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fe3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fe7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800ff3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ff8:	74 3d                	je     801037 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800ffa:	eb 1d                	jmp    801019 <strlcpy+0x42>
			*dst++ = *src++;
  800ffc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801000:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801004:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801008:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80100c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801010:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801014:	0f b6 12             	movzbl (%rdx),%edx
  801017:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801019:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80101e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801023:	74 0b                	je     801030 <strlcpy+0x59>
  801025:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801029:	0f b6 00             	movzbl (%rax),%eax
  80102c:	84 c0                	test   %al,%al
  80102e:	75 cc                	jne    800ffc <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801030:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801034:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801037:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80103b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80103f:	48 29 c2             	sub    %rax,%rdx
  801042:	48 89 d0             	mov    %rdx,%rax
}
  801045:	c9                   	leaveq 
  801046:	c3                   	retq   

0000000000801047 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801047:	55                   	push   %rbp
  801048:	48 89 e5             	mov    %rsp,%rbp
  80104b:	48 83 ec 10          	sub    $0x10,%rsp
  80104f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801053:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801057:	eb 0a                	jmp    801063 <strcmp+0x1c>
		p++, q++;
  801059:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80105e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801063:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801067:	0f b6 00             	movzbl (%rax),%eax
  80106a:	84 c0                	test   %al,%al
  80106c:	74 12                	je     801080 <strcmp+0x39>
  80106e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801072:	0f b6 10             	movzbl (%rax),%edx
  801075:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801079:	0f b6 00             	movzbl (%rax),%eax
  80107c:	38 c2                	cmp    %al,%dl
  80107e:	74 d9                	je     801059 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801080:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801084:	0f b6 00             	movzbl (%rax),%eax
  801087:	0f b6 d0             	movzbl %al,%edx
  80108a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108e:	0f b6 00             	movzbl (%rax),%eax
  801091:	0f b6 c0             	movzbl %al,%eax
  801094:	29 c2                	sub    %eax,%edx
  801096:	89 d0                	mov    %edx,%eax
}
  801098:	c9                   	leaveq 
  801099:	c3                   	retq   

000000000080109a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80109a:	55                   	push   %rbp
  80109b:	48 89 e5             	mov    %rsp,%rbp
  80109e:	48 83 ec 18          	sub    $0x18,%rsp
  8010a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010aa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010ae:	eb 0f                	jmp    8010bf <strncmp+0x25>
		n--, p++, q++;
  8010b0:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010ba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010c4:	74 1d                	je     8010e3 <strncmp+0x49>
  8010c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ca:	0f b6 00             	movzbl (%rax),%eax
  8010cd:	84 c0                	test   %al,%al
  8010cf:	74 12                	je     8010e3 <strncmp+0x49>
  8010d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d5:	0f b6 10             	movzbl (%rax),%edx
  8010d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010dc:	0f b6 00             	movzbl (%rax),%eax
  8010df:	38 c2                	cmp    %al,%dl
  8010e1:	74 cd                	je     8010b0 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010e8:	75 07                	jne    8010f1 <strncmp+0x57>
		return 0;
  8010ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ef:	eb 18                	jmp    801109 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f5:	0f b6 00             	movzbl (%rax),%eax
  8010f8:	0f b6 d0             	movzbl %al,%edx
  8010fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ff:	0f b6 00             	movzbl (%rax),%eax
  801102:	0f b6 c0             	movzbl %al,%eax
  801105:	29 c2                	sub    %eax,%edx
  801107:	89 d0                	mov    %edx,%eax
}
  801109:	c9                   	leaveq 
  80110a:	c3                   	retq   

000000000080110b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80110b:	55                   	push   %rbp
  80110c:	48 89 e5             	mov    %rsp,%rbp
  80110f:	48 83 ec 0c          	sub    $0xc,%rsp
  801113:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801117:	89 f0                	mov    %esi,%eax
  801119:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80111c:	eb 17                	jmp    801135 <strchr+0x2a>
		if (*s == c)
  80111e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801128:	75 06                	jne    801130 <strchr+0x25>
			return (char *) s;
  80112a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112e:	eb 15                	jmp    801145 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801130:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801135:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801139:	0f b6 00             	movzbl (%rax),%eax
  80113c:	84 c0                	test   %al,%al
  80113e:	75 de                	jne    80111e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801145:	c9                   	leaveq 
  801146:	c3                   	retq   

0000000000801147 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801147:	55                   	push   %rbp
  801148:	48 89 e5             	mov    %rsp,%rbp
  80114b:	48 83 ec 0c          	sub    $0xc,%rsp
  80114f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801153:	89 f0                	mov    %esi,%eax
  801155:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801158:	eb 13                	jmp    80116d <strfind+0x26>
		if (*s == c)
  80115a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115e:	0f b6 00             	movzbl (%rax),%eax
  801161:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801164:	75 02                	jne    801168 <strfind+0x21>
			break;
  801166:	eb 10                	jmp    801178 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801168:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80116d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801171:	0f b6 00             	movzbl (%rax),%eax
  801174:	84 c0                	test   %al,%al
  801176:	75 e2                	jne    80115a <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80117c:	c9                   	leaveq 
  80117d:	c3                   	retq   

000000000080117e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80117e:	55                   	push   %rbp
  80117f:	48 89 e5             	mov    %rsp,%rbp
  801182:	48 83 ec 18          	sub    $0x18,%rsp
  801186:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80118a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80118d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801191:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801196:	75 06                	jne    80119e <memset+0x20>
		return v;
  801198:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119c:	eb 69                	jmp    801207 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80119e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a2:	83 e0 03             	and    $0x3,%eax
  8011a5:	48 85 c0             	test   %rax,%rax
  8011a8:	75 48                	jne    8011f2 <memset+0x74>
  8011aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ae:	83 e0 03             	and    $0x3,%eax
  8011b1:	48 85 c0             	test   %rax,%rax
  8011b4:	75 3c                	jne    8011f2 <memset+0x74>
		c &= 0xFF;
  8011b6:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c0:	c1 e0 18             	shl    $0x18,%eax
  8011c3:	89 c2                	mov    %eax,%edx
  8011c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c8:	c1 e0 10             	shl    $0x10,%eax
  8011cb:	09 c2                	or     %eax,%edx
  8011cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d0:	c1 e0 08             	shl    $0x8,%eax
  8011d3:	09 d0                	or     %edx,%eax
  8011d5:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011dc:	48 c1 e8 02          	shr    $0x2,%rax
  8011e0:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011e3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ea:	48 89 d7             	mov    %rdx,%rdi
  8011ed:	fc                   	cld    
  8011ee:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011f0:	eb 11                	jmp    801203 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011fd:	48 89 d7             	mov    %rdx,%rdi
  801200:	fc                   	cld    
  801201:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801207:	c9                   	leaveq 
  801208:	c3                   	retq   

0000000000801209 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801209:	55                   	push   %rbp
  80120a:	48 89 e5             	mov    %rsp,%rbp
  80120d:	48 83 ec 28          	sub    $0x28,%rsp
  801211:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801215:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801219:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80121d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801221:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801225:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801229:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801231:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801235:	0f 83 88 00 00 00    	jae    8012c3 <memmove+0xba>
  80123b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801243:	48 01 d0             	add    %rdx,%rax
  801246:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80124a:	76 77                	jbe    8012c3 <memmove+0xba>
		s += n;
  80124c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801250:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801254:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801258:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80125c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801260:	83 e0 03             	and    $0x3,%eax
  801263:	48 85 c0             	test   %rax,%rax
  801266:	75 3b                	jne    8012a3 <memmove+0x9a>
  801268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126c:	83 e0 03             	and    $0x3,%eax
  80126f:	48 85 c0             	test   %rax,%rax
  801272:	75 2f                	jne    8012a3 <memmove+0x9a>
  801274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801278:	83 e0 03             	and    $0x3,%eax
  80127b:	48 85 c0             	test   %rax,%rax
  80127e:	75 23                	jne    8012a3 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801284:	48 83 e8 04          	sub    $0x4,%rax
  801288:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128c:	48 83 ea 04          	sub    $0x4,%rdx
  801290:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801294:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801298:	48 89 c7             	mov    %rax,%rdi
  80129b:	48 89 d6             	mov    %rdx,%rsi
  80129e:	fd                   	std    
  80129f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012a1:	eb 1d                	jmp    8012c0 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012af:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b7:	48 89 d7             	mov    %rdx,%rdi
  8012ba:	48 89 c1             	mov    %rax,%rcx
  8012bd:	fd                   	std    
  8012be:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012c0:	fc                   	cld    
  8012c1:	eb 57                	jmp    80131a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c7:	83 e0 03             	and    $0x3,%eax
  8012ca:	48 85 c0             	test   %rax,%rax
  8012cd:	75 36                	jne    801305 <memmove+0xfc>
  8012cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d3:	83 e0 03             	and    $0x3,%eax
  8012d6:	48 85 c0             	test   %rax,%rax
  8012d9:	75 2a                	jne    801305 <memmove+0xfc>
  8012db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012df:	83 e0 03             	and    $0x3,%eax
  8012e2:	48 85 c0             	test   %rax,%rax
  8012e5:	75 1e                	jne    801305 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012eb:	48 c1 e8 02          	shr    $0x2,%rax
  8012ef:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012fa:	48 89 c7             	mov    %rax,%rdi
  8012fd:	48 89 d6             	mov    %rdx,%rsi
  801300:	fc                   	cld    
  801301:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801303:	eb 15                	jmp    80131a <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801309:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80130d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801311:	48 89 c7             	mov    %rax,%rdi
  801314:	48 89 d6             	mov    %rdx,%rsi
  801317:	fc                   	cld    
  801318:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80131a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80131e:	c9                   	leaveq 
  80131f:	c3                   	retq   

0000000000801320 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801320:	55                   	push   %rbp
  801321:	48 89 e5             	mov    %rsp,%rbp
  801324:	48 83 ec 18          	sub    $0x18,%rsp
  801328:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80132c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801330:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801334:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801338:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801340:	48 89 ce             	mov    %rcx,%rsi
  801343:	48 89 c7             	mov    %rax,%rdi
  801346:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  80134d:	00 00 00 
  801350:	ff d0                	callq  *%rax
}
  801352:	c9                   	leaveq 
  801353:	c3                   	retq   

0000000000801354 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801354:	55                   	push   %rbp
  801355:	48 89 e5             	mov    %rsp,%rbp
  801358:	48 83 ec 28          	sub    $0x28,%rsp
  80135c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801360:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801364:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801368:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801370:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801374:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801378:	eb 36                	jmp    8013b0 <memcmp+0x5c>
		if (*s1 != *s2)
  80137a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137e:	0f b6 10             	movzbl (%rax),%edx
  801381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801385:	0f b6 00             	movzbl (%rax),%eax
  801388:	38 c2                	cmp    %al,%dl
  80138a:	74 1a                	je     8013a6 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80138c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801390:	0f b6 00             	movzbl (%rax),%eax
  801393:	0f b6 d0             	movzbl %al,%edx
  801396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	0f b6 c0             	movzbl %al,%eax
  8013a0:	29 c2                	sub    %eax,%edx
  8013a2:	89 d0                	mov    %edx,%eax
  8013a4:	eb 20                	jmp    8013c6 <memcmp+0x72>
		s1++, s2++;
  8013a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ab:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013bc:	48 85 c0             	test   %rax,%rax
  8013bf:	75 b9                	jne    80137a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c6:	c9                   	leaveq 
  8013c7:	c3                   	retq   

00000000008013c8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013c8:	55                   	push   %rbp
  8013c9:	48 89 e5             	mov    %rsp,%rbp
  8013cc:	48 83 ec 28          	sub    $0x28,%rsp
  8013d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013e3:	48 01 d0             	add    %rdx,%rax
  8013e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013ea:	eb 15                	jmp    801401 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f0:	0f b6 10             	movzbl (%rax),%edx
  8013f3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013f6:	38 c2                	cmp    %al,%dl
  8013f8:	75 02                	jne    8013fc <memfind+0x34>
			break;
  8013fa:	eb 0f                	jmp    80140b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013fc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801405:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801409:	72 e1                	jb     8013ec <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80140b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80140f:	c9                   	leaveq 
  801410:	c3                   	retq   

0000000000801411 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801411:	55                   	push   %rbp
  801412:	48 89 e5             	mov    %rsp,%rbp
  801415:	48 83 ec 34          	sub    $0x34,%rsp
  801419:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80141d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801421:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801424:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80142b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801432:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801433:	eb 05                	jmp    80143a <strtol+0x29>
		s++;
  801435:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80143a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143e:	0f b6 00             	movzbl (%rax),%eax
  801441:	3c 20                	cmp    $0x20,%al
  801443:	74 f0                	je     801435 <strtol+0x24>
  801445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801449:	0f b6 00             	movzbl (%rax),%eax
  80144c:	3c 09                	cmp    $0x9,%al
  80144e:	74 e5                	je     801435 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801450:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801454:	0f b6 00             	movzbl (%rax),%eax
  801457:	3c 2b                	cmp    $0x2b,%al
  801459:	75 07                	jne    801462 <strtol+0x51>
		s++;
  80145b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801460:	eb 17                	jmp    801479 <strtol+0x68>
	else if (*s == '-')
  801462:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801466:	0f b6 00             	movzbl (%rax),%eax
  801469:	3c 2d                	cmp    $0x2d,%al
  80146b:	75 0c                	jne    801479 <strtol+0x68>
		s++, neg = 1;
  80146d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801472:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801479:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80147d:	74 06                	je     801485 <strtol+0x74>
  80147f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801483:	75 28                	jne    8014ad <strtol+0x9c>
  801485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801489:	0f b6 00             	movzbl (%rax),%eax
  80148c:	3c 30                	cmp    $0x30,%al
  80148e:	75 1d                	jne    8014ad <strtol+0x9c>
  801490:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801494:	48 83 c0 01          	add    $0x1,%rax
  801498:	0f b6 00             	movzbl (%rax),%eax
  80149b:	3c 78                	cmp    $0x78,%al
  80149d:	75 0e                	jne    8014ad <strtol+0x9c>
		s += 2, base = 16;
  80149f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014a4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014ab:	eb 2c                	jmp    8014d9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014b1:	75 19                	jne    8014cc <strtol+0xbb>
  8014b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b7:	0f b6 00             	movzbl (%rax),%eax
  8014ba:	3c 30                	cmp    $0x30,%al
  8014bc:	75 0e                	jne    8014cc <strtol+0xbb>
		s++, base = 8;
  8014be:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014c3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014ca:	eb 0d                	jmp    8014d9 <strtol+0xc8>
	else if (base == 0)
  8014cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014d0:	75 07                	jne    8014d9 <strtol+0xc8>
		base = 10;
  8014d2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dd:	0f b6 00             	movzbl (%rax),%eax
  8014e0:	3c 2f                	cmp    $0x2f,%al
  8014e2:	7e 1d                	jle    801501 <strtol+0xf0>
  8014e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e8:	0f b6 00             	movzbl (%rax),%eax
  8014eb:	3c 39                	cmp    $0x39,%al
  8014ed:	7f 12                	jg     801501 <strtol+0xf0>
			dig = *s - '0';
  8014ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f3:	0f b6 00             	movzbl (%rax),%eax
  8014f6:	0f be c0             	movsbl %al,%eax
  8014f9:	83 e8 30             	sub    $0x30,%eax
  8014fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ff:	eb 4e                	jmp    80154f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801501:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801505:	0f b6 00             	movzbl (%rax),%eax
  801508:	3c 60                	cmp    $0x60,%al
  80150a:	7e 1d                	jle    801529 <strtol+0x118>
  80150c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801510:	0f b6 00             	movzbl (%rax),%eax
  801513:	3c 7a                	cmp    $0x7a,%al
  801515:	7f 12                	jg     801529 <strtol+0x118>
			dig = *s - 'a' + 10;
  801517:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151b:	0f b6 00             	movzbl (%rax),%eax
  80151e:	0f be c0             	movsbl %al,%eax
  801521:	83 e8 57             	sub    $0x57,%eax
  801524:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801527:	eb 26                	jmp    80154f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801529:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152d:	0f b6 00             	movzbl (%rax),%eax
  801530:	3c 40                	cmp    $0x40,%al
  801532:	7e 48                	jle    80157c <strtol+0x16b>
  801534:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801538:	0f b6 00             	movzbl (%rax),%eax
  80153b:	3c 5a                	cmp    $0x5a,%al
  80153d:	7f 3d                	jg     80157c <strtol+0x16b>
			dig = *s - 'A' + 10;
  80153f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801543:	0f b6 00             	movzbl (%rax),%eax
  801546:	0f be c0             	movsbl %al,%eax
  801549:	83 e8 37             	sub    $0x37,%eax
  80154c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80154f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801552:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801555:	7c 02                	jl     801559 <strtol+0x148>
			break;
  801557:	eb 23                	jmp    80157c <strtol+0x16b>
		s++, val = (val * base) + dig;
  801559:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80155e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801561:	48 98                	cltq   
  801563:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801568:	48 89 c2             	mov    %rax,%rdx
  80156b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80156e:	48 98                	cltq   
  801570:	48 01 d0             	add    %rdx,%rax
  801573:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801577:	e9 5d ff ff ff       	jmpq   8014d9 <strtol+0xc8>

	if (endptr)
  80157c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801581:	74 0b                	je     80158e <strtol+0x17d>
		*endptr = (char *) s;
  801583:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801587:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80158b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80158e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801592:	74 09                	je     80159d <strtol+0x18c>
  801594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801598:	48 f7 d8             	neg    %rax
  80159b:	eb 04                	jmp    8015a1 <strtol+0x190>
  80159d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015a1:	c9                   	leaveq 
  8015a2:	c3                   	retq   

00000000008015a3 <strstr>:

char * strstr(const char *in, const char *str)
{
  8015a3:	55                   	push   %rbp
  8015a4:	48 89 e5             	mov    %rsp,%rbp
  8015a7:	48 83 ec 30          	sub    $0x30,%rsp
  8015ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015b7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015bb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015bf:	0f b6 00             	movzbl (%rax),%eax
  8015c2:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015c5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015c9:	75 06                	jne    8015d1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cf:	eb 6b                	jmp    80163c <strstr+0x99>

	len = strlen(str);
  8015d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015d5:	48 89 c7             	mov    %rax,%rdi
  8015d8:	48 b8 79 0e 80 00 00 	movabs $0x800e79,%rax
  8015df:	00 00 00 
  8015e2:	ff d0                	callq  *%rax
  8015e4:	48 98                	cltq   
  8015e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015f6:	0f b6 00             	movzbl (%rax),%eax
  8015f9:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015fc:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801600:	75 07                	jne    801609 <strstr+0x66>
				return (char *) 0;
  801602:	b8 00 00 00 00       	mov    $0x0,%eax
  801607:	eb 33                	jmp    80163c <strstr+0x99>
		} while (sc != c);
  801609:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80160d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801610:	75 d8                	jne    8015ea <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801612:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801616:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	48 89 ce             	mov    %rcx,%rsi
  801621:	48 89 c7             	mov    %rax,%rdi
  801624:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  80162b:	00 00 00 
  80162e:	ff d0                	callq  *%rax
  801630:	85 c0                	test   %eax,%eax
  801632:	75 b6                	jne    8015ea <strstr+0x47>

	return (char *) (in - 1);
  801634:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801638:	48 83 e8 01          	sub    $0x1,%rax
}
  80163c:	c9                   	leaveq 
  80163d:	c3                   	retq   

000000000080163e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80163e:	55                   	push   %rbp
  80163f:	48 89 e5             	mov    %rsp,%rbp
  801642:	53                   	push   %rbx
  801643:	48 83 ec 48          	sub    $0x48,%rsp
  801647:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80164a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80164d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801651:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801655:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801659:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80165d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801660:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801664:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801668:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80166c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801670:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801674:	4c 89 c3             	mov    %r8,%rbx
  801677:	cd 30                	int    $0x30
  801679:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80167d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801681:	74 3e                	je     8016c1 <syscall+0x83>
  801683:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801688:	7e 37                	jle    8016c1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80168a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80168e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801691:	49 89 d0             	mov    %rdx,%r8
  801694:	89 c1                	mov    %eax,%ecx
  801696:	48 ba 68 47 80 00 00 	movabs $0x804768,%rdx
  80169d:	00 00 00 
  8016a0:	be 23 00 00 00       	mov    $0x23,%esi
  8016a5:	48 bf 85 47 80 00 00 	movabs $0x804785,%rdi
  8016ac:	00 00 00 
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	49 b9 43 3a 80 00 00 	movabs $0x803a43,%r9
  8016bb:	00 00 00 
  8016be:	41 ff d1             	callq  *%r9

	return ret;
  8016c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016c5:	48 83 c4 48          	add    $0x48,%rsp
  8016c9:	5b                   	pop    %rbx
  8016ca:	5d                   	pop    %rbp
  8016cb:	c3                   	retq   

00000000008016cc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016cc:	55                   	push   %rbp
  8016cd:	48 89 e5             	mov    %rsp,%rbp
  8016d0:	48 83 ec 20          	sub    $0x20,%rsp
  8016d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016eb:	00 
  8016ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f8:	48 89 d1             	mov    %rdx,%rcx
  8016fb:	48 89 c2             	mov    %rax,%rdx
  8016fe:	be 00 00 00 00       	mov    $0x0,%esi
  801703:	bf 00 00 00 00       	mov    $0x0,%edi
  801708:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  80170f:	00 00 00 
  801712:	ff d0                	callq  *%rax
}
  801714:	c9                   	leaveq 
  801715:	c3                   	retq   

0000000000801716 <sys_cgetc>:

int
sys_cgetc(void)
{
  801716:	55                   	push   %rbp
  801717:	48 89 e5             	mov    %rsp,%rbp
  80171a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80171e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801725:	00 
  801726:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80172c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801732:	b9 00 00 00 00       	mov    $0x0,%ecx
  801737:	ba 00 00 00 00       	mov    $0x0,%edx
  80173c:	be 00 00 00 00       	mov    $0x0,%esi
  801741:	bf 01 00 00 00       	mov    $0x1,%edi
  801746:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  80174d:	00 00 00 
  801750:	ff d0                	callq  *%rax
}
  801752:	c9                   	leaveq 
  801753:	c3                   	retq   

0000000000801754 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801754:	55                   	push   %rbp
  801755:	48 89 e5             	mov    %rsp,%rbp
  801758:	48 83 ec 10          	sub    $0x10,%rsp
  80175c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80175f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801762:	48 98                	cltq   
  801764:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80176b:	00 
  80176c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801772:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801778:	b9 00 00 00 00       	mov    $0x0,%ecx
  80177d:	48 89 c2             	mov    %rax,%rdx
  801780:	be 01 00 00 00       	mov    $0x1,%esi
  801785:	bf 03 00 00 00       	mov    $0x3,%edi
  80178a:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801791:	00 00 00 
  801794:	ff d0                	callq  *%rax
}
  801796:	c9                   	leaveq 
  801797:	c3                   	retq   

0000000000801798 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801798:	55                   	push   %rbp
  801799:	48 89 e5             	mov    %rsp,%rbp
  80179c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017a7:	00 
  8017a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017be:	be 00 00 00 00       	mov    $0x0,%esi
  8017c3:	bf 02 00 00 00       	mov    $0x2,%edi
  8017c8:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  8017cf:	00 00 00 
  8017d2:	ff d0                	callq  *%rax
}
  8017d4:	c9                   	leaveq 
  8017d5:	c3                   	retq   

00000000008017d6 <sys_yield>:

void
sys_yield(void)
{
  8017d6:	55                   	push   %rbp
  8017d7:	48 89 e5             	mov    %rsp,%rbp
  8017da:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017e5:	00 
  8017e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fc:	be 00 00 00 00       	mov    $0x0,%esi
  801801:	bf 0b 00 00 00       	mov    $0xb,%edi
  801806:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  80180d:	00 00 00 
  801810:	ff d0                	callq  *%rax
}
  801812:	c9                   	leaveq 
  801813:	c3                   	retq   

0000000000801814 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801814:	55                   	push   %rbp
  801815:	48 89 e5             	mov    %rsp,%rbp
  801818:	48 83 ec 20          	sub    $0x20,%rsp
  80181c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80181f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801823:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801826:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801829:	48 63 c8             	movslq %eax,%rcx
  80182c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801830:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801833:	48 98                	cltq   
  801835:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80183c:	00 
  80183d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801843:	49 89 c8             	mov    %rcx,%r8
  801846:	48 89 d1             	mov    %rdx,%rcx
  801849:	48 89 c2             	mov    %rax,%rdx
  80184c:	be 01 00 00 00       	mov    $0x1,%esi
  801851:	bf 04 00 00 00       	mov    $0x4,%edi
  801856:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  80185d:	00 00 00 
  801860:	ff d0                	callq  *%rax
}
  801862:	c9                   	leaveq 
  801863:	c3                   	retq   

0000000000801864 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801864:	55                   	push   %rbp
  801865:	48 89 e5             	mov    %rsp,%rbp
  801868:	48 83 ec 30          	sub    $0x30,%rsp
  80186c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80186f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801873:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801876:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80187a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80187e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801881:	48 63 c8             	movslq %eax,%rcx
  801884:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801888:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80188b:	48 63 f0             	movslq %eax,%rsi
  80188e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801892:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801895:	48 98                	cltq   
  801897:	48 89 0c 24          	mov    %rcx,(%rsp)
  80189b:	49 89 f9             	mov    %rdi,%r9
  80189e:	49 89 f0             	mov    %rsi,%r8
  8018a1:	48 89 d1             	mov    %rdx,%rcx
  8018a4:	48 89 c2             	mov    %rax,%rdx
  8018a7:	be 01 00 00 00       	mov    $0x1,%esi
  8018ac:	bf 05 00 00 00       	mov    $0x5,%edi
  8018b1:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  8018b8:	00 00 00 
  8018bb:	ff d0                	callq  *%rax
}
  8018bd:	c9                   	leaveq 
  8018be:	c3                   	retq   

00000000008018bf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018bf:	55                   	push   %rbp
  8018c0:	48 89 e5             	mov    %rsp,%rbp
  8018c3:	48 83 ec 20          	sub    $0x20,%rsp
  8018c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d5:	48 98                	cltq   
  8018d7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018de:	00 
  8018df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018eb:	48 89 d1             	mov    %rdx,%rcx
  8018ee:	48 89 c2             	mov    %rax,%rdx
  8018f1:	be 01 00 00 00       	mov    $0x1,%esi
  8018f6:	bf 06 00 00 00       	mov    $0x6,%edi
  8018fb:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801902:	00 00 00 
  801905:	ff d0                	callq  *%rax
}
  801907:	c9                   	leaveq 
  801908:	c3                   	retq   

0000000000801909 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801909:	55                   	push   %rbp
  80190a:	48 89 e5             	mov    %rsp,%rbp
  80190d:	48 83 ec 10          	sub    $0x10,%rsp
  801911:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801914:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801917:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80191a:	48 63 d0             	movslq %eax,%rdx
  80191d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801920:	48 98                	cltq   
  801922:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801929:	00 
  80192a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801930:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801936:	48 89 d1             	mov    %rdx,%rcx
  801939:	48 89 c2             	mov    %rax,%rdx
  80193c:	be 01 00 00 00       	mov    $0x1,%esi
  801941:	bf 08 00 00 00       	mov    $0x8,%edi
  801946:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  80194d:	00 00 00 
  801950:	ff d0                	callq  *%rax
}
  801952:	c9                   	leaveq 
  801953:	c3                   	retq   

0000000000801954 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801954:	55                   	push   %rbp
  801955:	48 89 e5             	mov    %rsp,%rbp
  801958:	48 83 ec 20          	sub    $0x20,%rsp
  80195c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80195f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801963:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801967:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196a:	48 98                	cltq   
  80196c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801973:	00 
  801974:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801980:	48 89 d1             	mov    %rdx,%rcx
  801983:	48 89 c2             	mov    %rax,%rdx
  801986:	be 01 00 00 00       	mov    $0x1,%esi
  80198b:	bf 09 00 00 00       	mov    $0x9,%edi
  801990:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801997:	00 00 00 
  80199a:	ff d0                	callq  *%rax
}
  80199c:	c9                   	leaveq 
  80199d:	c3                   	retq   

000000000080199e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80199e:	55                   	push   %rbp
  80199f:	48 89 e5             	mov    %rsp,%rbp
  8019a2:	48 83 ec 20          	sub    $0x20,%rsp
  8019a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b4:	48 98                	cltq   
  8019b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019bd:	00 
  8019be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ca:	48 89 d1             	mov    %rdx,%rcx
  8019cd:	48 89 c2             	mov    %rax,%rdx
  8019d0:	be 01 00 00 00       	mov    $0x1,%esi
  8019d5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019da:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  8019e1:	00 00 00 
  8019e4:	ff d0                	callq  *%rax
}
  8019e6:	c9                   	leaveq 
  8019e7:	c3                   	retq   

00000000008019e8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019e8:	55                   	push   %rbp
  8019e9:	48 89 e5             	mov    %rsp,%rbp
  8019ec:	48 83 ec 20          	sub    $0x20,%rsp
  8019f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019f7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019fb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a01:	48 63 f0             	movslq %eax,%rsi
  801a04:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0b:	48 98                	cltq   
  801a0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a11:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a18:	00 
  801a19:	49 89 f1             	mov    %rsi,%r9
  801a1c:	49 89 c8             	mov    %rcx,%r8
  801a1f:	48 89 d1             	mov    %rdx,%rcx
  801a22:	48 89 c2             	mov    %rax,%rdx
  801a25:	be 00 00 00 00       	mov    $0x0,%esi
  801a2a:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a2f:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801a36:	00 00 00 
  801a39:	ff d0                	callq  *%rax
}
  801a3b:	c9                   	leaveq 
  801a3c:	c3                   	retq   

0000000000801a3d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a3d:	55                   	push   %rbp
  801a3e:	48 89 e5             	mov    %rsp,%rbp
  801a41:	48 83 ec 10          	sub    $0x10,%rsp
  801a45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a54:	00 
  801a55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a61:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a66:	48 89 c2             	mov    %rax,%rdx
  801a69:	be 01 00 00 00       	mov    $0x1,%esi
  801a6e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a73:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801a7a:	00 00 00 
  801a7d:	ff d0                	callq  *%rax
}
  801a7f:	c9                   	leaveq 
  801a80:	c3                   	retq   

0000000000801a81 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a81:	55                   	push   %rbp
  801a82:	48 89 e5             	mov    %rsp,%rbp
  801a85:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801a89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a90:	00 
  801a91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa7:	be 00 00 00 00       	mov    $0x0,%esi
  801aac:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ab1:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801ab8:	00 00 00 
  801abb:	ff d0                	callq  *%rax
}
  801abd:	c9                   	leaveq 
  801abe:	c3                   	retq   

0000000000801abf <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801abf:	55                   	push   %rbp
  801ac0:	48 89 e5             	mov    %rsp,%rbp
  801ac3:	48 83 ec 30          	sub    $0x30,%rsp
  801ac7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ace:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ad1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ad5:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801ad9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801adc:	48 63 c8             	movslq %eax,%rcx
  801adf:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ae3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ae6:	48 63 f0             	movslq %eax,%rsi
  801ae9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af0:	48 98                	cltq   
  801af2:	48 89 0c 24          	mov    %rcx,(%rsp)
  801af6:	49 89 f9             	mov    %rdi,%r9
  801af9:	49 89 f0             	mov    %rsi,%r8
  801afc:	48 89 d1             	mov    %rdx,%rcx
  801aff:	48 89 c2             	mov    %rax,%rdx
  801b02:	be 00 00 00 00       	mov    $0x0,%esi
  801b07:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b0c:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801b18:	c9                   	leaveq 
  801b19:	c3                   	retq   

0000000000801b1a <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801b1a:	55                   	push   %rbp
  801b1b:	48 89 e5             	mov    %rsp,%rbp
  801b1e:	48 83 ec 20          	sub    $0x20,%rsp
  801b22:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801b2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b32:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b39:	00 
  801b3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b40:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b46:	48 89 d1             	mov    %rdx,%rcx
  801b49:	48 89 c2             	mov    %rax,%rdx
  801b4c:	be 00 00 00 00       	mov    $0x0,%esi
  801b51:	bf 10 00 00 00       	mov    $0x10,%edi
  801b56:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801b5d:	00 00 00 
  801b60:	ff d0                	callq  *%rax
}
  801b62:	c9                   	leaveq 
  801b63:	c3                   	retq   

0000000000801b64 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801b64:	55                   	push   %rbp
  801b65:	48 89 e5             	mov    %rsp,%rbp
  801b68:	48 83 ec 30          	sub    $0x30,%rsp
  801b6c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b74:	48 8b 00             	mov    (%rax),%rax
  801b77:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801b7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b7f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b83:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801b86:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b89:	83 e0 02             	and    $0x2,%eax
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	75 4d                	jne    801bdd <pgfault+0x79>
  801b90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b94:	48 c1 e8 0c          	shr    $0xc,%rax
  801b98:	48 89 c2             	mov    %rax,%rdx
  801b9b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ba2:	01 00 00 
  801ba5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ba9:	25 00 08 00 00       	and    $0x800,%eax
  801bae:	48 85 c0             	test   %rax,%rax
  801bb1:	74 2a                	je     801bdd <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801bb3:	48 ba 98 47 80 00 00 	movabs $0x804798,%rdx
  801bba:	00 00 00 
  801bbd:	be 23 00 00 00       	mov    $0x23,%esi
  801bc2:	48 bf cd 47 80 00 00 	movabs $0x8047cd,%rdi
  801bc9:	00 00 00 
  801bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd1:	48 b9 43 3a 80 00 00 	movabs $0x803a43,%rcx
  801bd8:	00 00 00 
  801bdb:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801bdd:	ba 07 00 00 00       	mov    $0x7,%edx
  801be2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801be7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bec:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  801bf3:	00 00 00 
  801bf6:	ff d0                	callq  *%rax
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	0f 85 cd 00 00 00    	jne    801ccd <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801c00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c04:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c0c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c12:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801c16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c1a:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c1f:	48 89 c6             	mov    %rax,%rsi
  801c22:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c27:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  801c2e:	00 00 00 
  801c31:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801c33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c37:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c3d:	48 89 c1             	mov    %rax,%rcx
  801c40:	ba 00 00 00 00       	mov    $0x0,%edx
  801c45:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c4a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c4f:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  801c56:	00 00 00 
  801c59:	ff d0                	callq  *%rax
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	79 2a                	jns    801c89 <pgfault+0x125>
				panic("Page map at temp address failed");
  801c5f:	48 ba d8 47 80 00 00 	movabs $0x8047d8,%rdx
  801c66:	00 00 00 
  801c69:	be 30 00 00 00       	mov    $0x30,%esi
  801c6e:	48 bf cd 47 80 00 00 	movabs $0x8047cd,%rdi
  801c75:	00 00 00 
  801c78:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7d:	48 b9 43 3a 80 00 00 	movabs $0x803a43,%rcx
  801c84:	00 00 00 
  801c87:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801c89:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c8e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c93:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801c9a:	00 00 00 
  801c9d:	ff d0                	callq  *%rax
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	79 54                	jns    801cf7 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801ca3:	48 ba f8 47 80 00 00 	movabs $0x8047f8,%rdx
  801caa:	00 00 00 
  801cad:	be 32 00 00 00       	mov    $0x32,%esi
  801cb2:	48 bf cd 47 80 00 00 	movabs $0x8047cd,%rdi
  801cb9:	00 00 00 
  801cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc1:	48 b9 43 3a 80 00 00 	movabs $0x803a43,%rcx
  801cc8:	00 00 00 
  801ccb:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801ccd:	48 ba 20 48 80 00 00 	movabs $0x804820,%rdx
  801cd4:	00 00 00 
  801cd7:	be 34 00 00 00       	mov    $0x34,%esi
  801cdc:	48 bf cd 47 80 00 00 	movabs $0x8047cd,%rdi
  801ce3:	00 00 00 
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ceb:	48 b9 43 3a 80 00 00 	movabs $0x803a43,%rcx
  801cf2:	00 00 00 
  801cf5:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801cf7:	c9                   	leaveq 
  801cf8:	c3                   	retq   

0000000000801cf9 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801cf9:	55                   	push   %rbp
  801cfa:	48 89 e5             	mov    %rsp,%rbp
  801cfd:	48 83 ec 20          	sub    $0x20,%rsp
  801d01:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d04:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801d07:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d0e:	01 00 00 
  801d11:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d18:	25 07 0e 00 00       	and    $0xe07,%eax
  801d1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801d20:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801d23:	48 c1 e0 0c          	shl    $0xc,%rax
  801d27:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801d2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2e:	25 00 04 00 00       	and    $0x400,%eax
  801d33:	85 c0                	test   %eax,%eax
  801d35:	74 57                	je     801d8e <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d37:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d3a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d3e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d45:	41 89 f0             	mov    %esi,%r8d
  801d48:	48 89 c6             	mov    %rax,%rsi
  801d4b:	bf 00 00 00 00       	mov    $0x0,%edi
  801d50:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  801d57:	00 00 00 
  801d5a:	ff d0                	callq  *%rax
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	0f 8e 52 01 00 00    	jle    801eb6 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801d64:	48 ba 52 48 80 00 00 	movabs $0x804852,%rdx
  801d6b:	00 00 00 
  801d6e:	be 4e 00 00 00       	mov    $0x4e,%esi
  801d73:	48 bf cd 47 80 00 00 	movabs $0x8047cd,%rdi
  801d7a:	00 00 00 
  801d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d82:	48 b9 43 3a 80 00 00 	movabs $0x803a43,%rcx
  801d89:	00 00 00 
  801d8c:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d91:	83 e0 02             	and    $0x2,%eax
  801d94:	85 c0                	test   %eax,%eax
  801d96:	75 10                	jne    801da8 <duppage+0xaf>
  801d98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9b:	25 00 08 00 00       	and    $0x800,%eax
  801da0:	85 c0                	test   %eax,%eax
  801da2:	0f 84 bb 00 00 00    	je     801e63 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dab:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801db0:	80 cc 08             	or     $0x8,%ah
  801db3:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801db6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801db9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801dbd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc4:	41 89 f0             	mov    %esi,%r8d
  801dc7:	48 89 c6             	mov    %rax,%rsi
  801dca:	bf 00 00 00 00       	mov    $0x0,%edi
  801dcf:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  801dd6:	00 00 00 
  801dd9:	ff d0                	callq  *%rax
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	7e 2a                	jle    801e09 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801ddf:	48 ba 52 48 80 00 00 	movabs $0x804852,%rdx
  801de6:	00 00 00 
  801de9:	be 55 00 00 00       	mov    $0x55,%esi
  801dee:	48 bf cd 47 80 00 00 	movabs $0x8047cd,%rdi
  801df5:	00 00 00 
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfd:	48 b9 43 3a 80 00 00 	movabs $0x803a43,%rcx
  801e04:	00 00 00 
  801e07:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e09:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801e0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e14:	41 89 c8             	mov    %ecx,%r8d
  801e17:	48 89 d1             	mov    %rdx,%rcx
  801e1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1f:	48 89 c6             	mov    %rax,%rsi
  801e22:	bf 00 00 00 00       	mov    $0x0,%edi
  801e27:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  801e2e:	00 00 00 
  801e31:	ff d0                	callq  *%rax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	7e 2a                	jle    801e61 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801e37:	48 ba 52 48 80 00 00 	movabs $0x804852,%rdx
  801e3e:	00 00 00 
  801e41:	be 57 00 00 00       	mov    $0x57,%esi
  801e46:	48 bf cd 47 80 00 00 	movabs $0x8047cd,%rdi
  801e4d:	00 00 00 
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax
  801e55:	48 b9 43 3a 80 00 00 	movabs $0x803a43,%rcx
  801e5c:	00 00 00 
  801e5f:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e61:	eb 53                	jmp    801eb6 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e63:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e66:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e6a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e71:	41 89 f0             	mov    %esi,%r8d
  801e74:	48 89 c6             	mov    %rax,%rsi
  801e77:	bf 00 00 00 00       	mov    $0x0,%edi
  801e7c:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  801e83:	00 00 00 
  801e86:	ff d0                	callq  *%rax
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	7e 2a                	jle    801eb6 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801e8c:	48 ba 52 48 80 00 00 	movabs $0x804852,%rdx
  801e93:	00 00 00 
  801e96:	be 5b 00 00 00       	mov    $0x5b,%esi
  801e9b:	48 bf cd 47 80 00 00 	movabs $0x8047cd,%rdi
  801ea2:	00 00 00 
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaa:	48 b9 43 3a 80 00 00 	movabs $0x803a43,%rcx
  801eb1:	00 00 00 
  801eb4:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebb:	c9                   	leaveq 
  801ebc:	c3                   	retq   

0000000000801ebd <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801ebd:	55                   	push   %rbp
  801ebe:	48 89 e5             	mov    %rsp,%rbp
  801ec1:	48 83 ec 18          	sub    $0x18,%rsp
  801ec5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801ec9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ecd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801ed1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed5:	48 c1 e8 27          	shr    $0x27,%rax
  801ed9:	48 89 c2             	mov    %rax,%rdx
  801edc:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801ee3:	01 00 00 
  801ee6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eea:	83 e0 01             	and    $0x1,%eax
  801eed:	48 85 c0             	test   %rax,%rax
  801ef0:	74 51                	je     801f43 <pt_is_mapped+0x86>
  801ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef6:	48 c1 e0 0c          	shl    $0xc,%rax
  801efa:	48 c1 e8 1e          	shr    $0x1e,%rax
  801efe:	48 89 c2             	mov    %rax,%rdx
  801f01:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f08:	01 00 00 
  801f0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f0f:	83 e0 01             	and    $0x1,%eax
  801f12:	48 85 c0             	test   %rax,%rax
  801f15:	74 2c                	je     801f43 <pt_is_mapped+0x86>
  801f17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1b:	48 c1 e0 0c          	shl    $0xc,%rax
  801f1f:	48 c1 e8 15          	shr    $0x15,%rax
  801f23:	48 89 c2             	mov    %rax,%rdx
  801f26:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f2d:	01 00 00 
  801f30:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f34:	83 e0 01             	and    $0x1,%eax
  801f37:	48 85 c0             	test   %rax,%rax
  801f3a:	74 07                	je     801f43 <pt_is_mapped+0x86>
  801f3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f41:	eb 05                	jmp    801f48 <pt_is_mapped+0x8b>
  801f43:	b8 00 00 00 00       	mov    $0x0,%eax
  801f48:	83 e0 01             	and    $0x1,%eax
}
  801f4b:	c9                   	leaveq 
  801f4c:	c3                   	retq   

0000000000801f4d <fork>:

envid_t
fork(void)
{
  801f4d:	55                   	push   %rbp
  801f4e:	48 89 e5             	mov    %rsp,%rbp
  801f51:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801f55:	48 bf 64 1b 80 00 00 	movabs $0x801b64,%rdi
  801f5c:	00 00 00 
  801f5f:	48 b8 57 3b 80 00 00 	movabs $0x803b57,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f6b:	b8 07 00 00 00       	mov    $0x7,%eax
  801f70:	cd 30                	int    $0x30
  801f72:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f75:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f78:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801f7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f7f:	79 30                	jns    801fb1 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f81:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f84:	89 c1                	mov    %eax,%ecx
  801f86:	48 ba 70 48 80 00 00 	movabs $0x804870,%rdx
  801f8d:	00 00 00 
  801f90:	be 86 00 00 00       	mov    $0x86,%esi
  801f95:	48 bf cd 47 80 00 00 	movabs $0x8047cd,%rdi
  801f9c:	00 00 00 
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa4:	49 b8 43 3a 80 00 00 	movabs $0x803a43,%r8
  801fab:	00 00 00 
  801fae:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  801fb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801fb5:	75 3e                	jne    801ff5 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801fb7:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801fbe:	00 00 00 
  801fc1:	ff d0                	callq  *%rax
  801fc3:	25 ff 03 00 00       	and    $0x3ff,%eax
  801fc8:	48 98                	cltq   
  801fca:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  801fd1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801fd8:	00 00 00 
  801fdb:	48 01 c2             	add    %rax,%rdx
  801fde:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fe5:	00 00 00 
  801fe8:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801feb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff0:	e9 d1 01 00 00       	jmpq   8021c6 <fork+0x279>
	}
	uint64_t ad = 0;
  801ff5:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801ffc:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801ffd:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802002:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802006:	e9 df 00 00 00       	jmpq   8020ea <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80200b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80200f:	48 c1 e8 27          	shr    $0x27,%rax
  802013:	48 89 c2             	mov    %rax,%rdx
  802016:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80201d:	01 00 00 
  802020:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802024:	83 e0 01             	and    $0x1,%eax
  802027:	48 85 c0             	test   %rax,%rax
  80202a:	0f 84 9e 00 00 00    	je     8020ce <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802030:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802034:	48 c1 e8 1e          	shr    $0x1e,%rax
  802038:	48 89 c2             	mov    %rax,%rdx
  80203b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802042:	01 00 00 
  802045:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802049:	83 e0 01             	and    $0x1,%eax
  80204c:	48 85 c0             	test   %rax,%rax
  80204f:	74 73                	je     8020c4 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  802051:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802055:	48 c1 e8 15          	shr    $0x15,%rax
  802059:	48 89 c2             	mov    %rax,%rdx
  80205c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802063:	01 00 00 
  802066:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206a:	83 e0 01             	and    $0x1,%eax
  80206d:	48 85 c0             	test   %rax,%rax
  802070:	74 48                	je     8020ba <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802072:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802076:	48 c1 e8 0c          	shr    $0xc,%rax
  80207a:	48 89 c2             	mov    %rax,%rdx
  80207d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802084:	01 00 00 
  802087:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80208b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80208f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802093:	83 e0 01             	and    $0x1,%eax
  802096:	48 85 c0             	test   %rax,%rax
  802099:	74 47                	je     8020e2 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80209b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80209f:	48 c1 e8 0c          	shr    $0xc,%rax
  8020a3:	89 c2                	mov    %eax,%edx
  8020a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020a8:	89 d6                	mov    %edx,%esi
  8020aa:	89 c7                	mov    %eax,%edi
  8020ac:	48 b8 f9 1c 80 00 00 	movabs $0x801cf9,%rax
  8020b3:	00 00 00 
  8020b6:	ff d0                	callq  *%rax
  8020b8:	eb 28                	jmp    8020e2 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8020ba:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8020c1:	00 
  8020c2:	eb 1e                	jmp    8020e2 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8020c4:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8020cb:	40 
  8020cc:	eb 14                	jmp    8020e2 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8020ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020d2:	48 c1 e8 27          	shr    $0x27,%rax
  8020d6:	48 83 c0 01          	add    $0x1,%rax
  8020da:	48 c1 e0 27          	shl    $0x27,%rax
  8020de:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8020e2:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8020e9:	00 
  8020ea:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8020f1:	00 
  8020f2:	0f 87 13 ff ff ff    	ja     80200b <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8020f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020fb:	ba 07 00 00 00       	mov    $0x7,%edx
  802100:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802105:	89 c7                	mov    %eax,%edi
  802107:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  80210e:	00 00 00 
  802111:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802113:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802116:	ba 07 00 00 00       	mov    $0x7,%edx
  80211b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802120:	89 c7                	mov    %eax,%edi
  802122:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  802129:	00 00 00 
  80212c:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80212e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802131:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802137:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80213c:	ba 00 00 00 00       	mov    $0x0,%edx
  802141:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802146:	89 c7                	mov    %eax,%edi
  802148:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  80214f:	00 00 00 
  802152:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802154:	ba 00 10 00 00       	mov    $0x1000,%edx
  802159:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80215e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802163:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  80216a:	00 00 00 
  80216d:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80216f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802174:	bf 00 00 00 00       	mov    $0x0,%edi
  802179:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  802180:	00 00 00 
  802183:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802185:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80218c:	00 00 00 
  80218f:	48 8b 00             	mov    (%rax),%rax
  802192:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802199:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80219c:	48 89 d6             	mov    %rdx,%rsi
  80219f:	89 c7                	mov    %eax,%edi
  8021a1:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  8021a8:	00 00 00 
  8021ab:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8021ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021b0:	be 02 00 00 00       	mov    $0x2,%esi
  8021b5:	89 c7                	mov    %eax,%edi
  8021b7:	48 b8 09 19 80 00 00 	movabs $0x801909,%rax
  8021be:	00 00 00 
  8021c1:	ff d0                	callq  *%rax

	return envid;
  8021c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8021c6:	c9                   	leaveq 
  8021c7:	c3                   	retq   

00000000008021c8 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8021c8:	55                   	push   %rbp
  8021c9:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021cc:	48 ba 88 48 80 00 00 	movabs $0x804888,%rdx
  8021d3:	00 00 00 
  8021d6:	be bf 00 00 00       	mov    $0xbf,%esi
  8021db:	48 bf cd 47 80 00 00 	movabs $0x8047cd,%rdi
  8021e2:	00 00 00 
  8021e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ea:	48 b9 43 3a 80 00 00 	movabs $0x803a43,%rcx
  8021f1:	00 00 00 
  8021f4:	ff d1                	callq  *%rcx

00000000008021f6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021f6:	55                   	push   %rbp
  8021f7:	48 89 e5             	mov    %rsp,%rbp
  8021fa:	48 83 ec 08          	sub    $0x8,%rsp
  8021fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802202:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802206:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80220d:	ff ff ff 
  802210:	48 01 d0             	add    %rdx,%rax
  802213:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802217:	c9                   	leaveq 
  802218:	c3                   	retq   

0000000000802219 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802219:	55                   	push   %rbp
  80221a:	48 89 e5             	mov    %rsp,%rbp
  80221d:	48 83 ec 08          	sub    $0x8,%rsp
  802221:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802225:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802229:	48 89 c7             	mov    %rax,%rdi
  80222c:	48 b8 f6 21 80 00 00 	movabs $0x8021f6,%rax
  802233:	00 00 00 
  802236:	ff d0                	callq  *%rax
  802238:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80223e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802242:	c9                   	leaveq 
  802243:	c3                   	retq   

0000000000802244 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802244:	55                   	push   %rbp
  802245:	48 89 e5             	mov    %rsp,%rbp
  802248:	48 83 ec 18          	sub    $0x18,%rsp
  80224c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802250:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802257:	eb 6b                	jmp    8022c4 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225c:	48 98                	cltq   
  80225e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802264:	48 c1 e0 0c          	shl    $0xc,%rax
  802268:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80226c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802270:	48 c1 e8 15          	shr    $0x15,%rax
  802274:	48 89 c2             	mov    %rax,%rdx
  802277:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80227e:	01 00 00 
  802281:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802285:	83 e0 01             	and    $0x1,%eax
  802288:	48 85 c0             	test   %rax,%rax
  80228b:	74 21                	je     8022ae <fd_alloc+0x6a>
  80228d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802291:	48 c1 e8 0c          	shr    $0xc,%rax
  802295:	48 89 c2             	mov    %rax,%rdx
  802298:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80229f:	01 00 00 
  8022a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a6:	83 e0 01             	and    $0x1,%eax
  8022a9:	48 85 c0             	test   %rax,%rax
  8022ac:	75 12                	jne    8022c0 <fd_alloc+0x7c>
			*fd_store = fd;
  8022ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022b6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022be:	eb 1a                	jmp    8022da <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022c4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022c8:	7e 8f                	jle    802259 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8022ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ce:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8022d5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022da:	c9                   	leaveq 
  8022db:	c3                   	retq   

00000000008022dc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022dc:	55                   	push   %rbp
  8022dd:	48 89 e5             	mov    %rsp,%rbp
  8022e0:	48 83 ec 20          	sub    $0x20,%rsp
  8022e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022ef:	78 06                	js     8022f7 <fd_lookup+0x1b>
  8022f1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022f5:	7e 07                	jle    8022fe <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022fc:	eb 6c                	jmp    80236a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802301:	48 98                	cltq   
  802303:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802309:	48 c1 e0 0c          	shl    $0xc,%rax
  80230d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802311:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802315:	48 c1 e8 15          	shr    $0x15,%rax
  802319:	48 89 c2             	mov    %rax,%rdx
  80231c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802323:	01 00 00 
  802326:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80232a:	83 e0 01             	and    $0x1,%eax
  80232d:	48 85 c0             	test   %rax,%rax
  802330:	74 21                	je     802353 <fd_lookup+0x77>
  802332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802336:	48 c1 e8 0c          	shr    $0xc,%rax
  80233a:	48 89 c2             	mov    %rax,%rdx
  80233d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802344:	01 00 00 
  802347:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80234b:	83 e0 01             	and    $0x1,%eax
  80234e:	48 85 c0             	test   %rax,%rax
  802351:	75 07                	jne    80235a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802353:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802358:	eb 10                	jmp    80236a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80235a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80235e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802362:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802365:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80236a:	c9                   	leaveq 
  80236b:	c3                   	retq   

000000000080236c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80236c:	55                   	push   %rbp
  80236d:	48 89 e5             	mov    %rsp,%rbp
  802370:	48 83 ec 30          	sub    $0x30,%rsp
  802374:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802378:	89 f0                	mov    %esi,%eax
  80237a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80237d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802381:	48 89 c7             	mov    %rax,%rdi
  802384:	48 b8 f6 21 80 00 00 	movabs $0x8021f6,%rax
  80238b:	00 00 00 
  80238e:	ff d0                	callq  *%rax
  802390:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802394:	48 89 d6             	mov    %rdx,%rsi
  802397:	89 c7                	mov    %eax,%edi
  802399:	48 b8 dc 22 80 00 00 	movabs $0x8022dc,%rax
  8023a0:	00 00 00 
  8023a3:	ff d0                	callq  *%rax
  8023a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ac:	78 0a                	js     8023b8 <fd_close+0x4c>
	    || fd != fd2)
  8023ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8023b6:	74 12                	je     8023ca <fd_close+0x5e>
		return (must_exist ? r : 0);
  8023b8:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8023bc:	74 05                	je     8023c3 <fd_close+0x57>
  8023be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c1:	eb 05                	jmp    8023c8 <fd_close+0x5c>
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c8:	eb 69                	jmp    802433 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8023ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023ce:	8b 00                	mov    (%rax),%eax
  8023d0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023d4:	48 89 d6             	mov    %rdx,%rsi
  8023d7:	89 c7                	mov    %eax,%edi
  8023d9:	48 b8 35 24 80 00 00 	movabs $0x802435,%rax
  8023e0:	00 00 00 
  8023e3:	ff d0                	callq  *%rax
  8023e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ec:	78 2a                	js     802418 <fd_close+0xac>
		if (dev->dev_close)
  8023ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023f6:	48 85 c0             	test   %rax,%rax
  8023f9:	74 16                	je     802411 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8023fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ff:	48 8b 40 20          	mov    0x20(%rax),%rax
  802403:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802407:	48 89 d7             	mov    %rdx,%rdi
  80240a:	ff d0                	callq  *%rax
  80240c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80240f:	eb 07                	jmp    802418 <fd_close+0xac>
		else
			r = 0;
  802411:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802418:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80241c:	48 89 c6             	mov    %rax,%rsi
  80241f:	bf 00 00 00 00       	mov    $0x0,%edi
  802424:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  80242b:	00 00 00 
  80242e:	ff d0                	callq  *%rax
	return r;
  802430:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802433:	c9                   	leaveq 
  802434:	c3                   	retq   

0000000000802435 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802435:	55                   	push   %rbp
  802436:	48 89 e5             	mov    %rsp,%rbp
  802439:	48 83 ec 20          	sub    $0x20,%rsp
  80243d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802440:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802444:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80244b:	eb 41                	jmp    80248e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80244d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802454:	00 00 00 
  802457:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80245a:	48 63 d2             	movslq %edx,%rdx
  80245d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802461:	8b 00                	mov    (%rax),%eax
  802463:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802466:	75 22                	jne    80248a <dev_lookup+0x55>
			*dev = devtab[i];
  802468:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80246f:	00 00 00 
  802472:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802475:	48 63 d2             	movslq %edx,%rdx
  802478:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80247c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802480:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
  802488:	eb 60                	jmp    8024ea <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80248a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80248e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802495:	00 00 00 
  802498:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80249b:	48 63 d2             	movslq %edx,%rdx
  80249e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a2:	48 85 c0             	test   %rax,%rax
  8024a5:	75 a6                	jne    80244d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8024a7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024ae:	00 00 00 
  8024b1:	48 8b 00             	mov    (%rax),%rax
  8024b4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024ba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024bd:	89 c6                	mov    %eax,%esi
  8024bf:	48 bf a0 48 80 00 00 	movabs $0x8048a0,%rdi
  8024c6:	00 00 00 
  8024c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ce:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  8024d5:	00 00 00 
  8024d8:	ff d1                	callq  *%rcx
	*dev = 0;
  8024da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024de:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024ea:	c9                   	leaveq 
  8024eb:	c3                   	retq   

00000000008024ec <close>:

int
close(int fdnum)
{
  8024ec:	55                   	push   %rbp
  8024ed:	48 89 e5             	mov    %rsp,%rbp
  8024f0:	48 83 ec 20          	sub    $0x20,%rsp
  8024f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024f7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024fe:	48 89 d6             	mov    %rdx,%rsi
  802501:	89 c7                	mov    %eax,%edi
  802503:	48 b8 dc 22 80 00 00 	movabs $0x8022dc,%rax
  80250a:	00 00 00 
  80250d:	ff d0                	callq  *%rax
  80250f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802512:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802516:	79 05                	jns    80251d <close+0x31>
		return r;
  802518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251b:	eb 18                	jmp    802535 <close+0x49>
	else
		return fd_close(fd, 1);
  80251d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802521:	be 01 00 00 00       	mov    $0x1,%esi
  802526:	48 89 c7             	mov    %rax,%rdi
  802529:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  802530:	00 00 00 
  802533:	ff d0                	callq  *%rax
}
  802535:	c9                   	leaveq 
  802536:	c3                   	retq   

0000000000802537 <close_all>:

void
close_all(void)
{
  802537:	55                   	push   %rbp
  802538:	48 89 e5             	mov    %rsp,%rbp
  80253b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80253f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802546:	eb 15                	jmp    80255d <close_all+0x26>
		close(i);
  802548:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254b:	89 c7                	mov    %eax,%edi
  80254d:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  802554:	00 00 00 
  802557:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802559:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80255d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802561:	7e e5                	jle    802548 <close_all+0x11>
		close(i);
}
  802563:	c9                   	leaveq 
  802564:	c3                   	retq   

0000000000802565 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802565:	55                   	push   %rbp
  802566:	48 89 e5             	mov    %rsp,%rbp
  802569:	48 83 ec 40          	sub    $0x40,%rsp
  80256d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802570:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802573:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802577:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80257a:	48 89 d6             	mov    %rdx,%rsi
  80257d:	89 c7                	mov    %eax,%edi
  80257f:	48 b8 dc 22 80 00 00 	movabs $0x8022dc,%rax
  802586:	00 00 00 
  802589:	ff d0                	callq  *%rax
  80258b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802592:	79 08                	jns    80259c <dup+0x37>
		return r;
  802594:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802597:	e9 70 01 00 00       	jmpq   80270c <dup+0x1a7>
	close(newfdnum);
  80259c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80259f:	89 c7                	mov    %eax,%edi
  8025a1:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  8025a8:	00 00 00 
  8025ab:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8025ad:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025b0:	48 98                	cltq   
  8025b2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025b8:	48 c1 e0 0c          	shl    $0xc,%rax
  8025bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8025c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c4:	48 89 c7             	mov    %rax,%rdi
  8025c7:	48 b8 19 22 80 00 00 	movabs $0x802219,%rax
  8025ce:	00 00 00 
  8025d1:	ff d0                	callq  *%rax
  8025d3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8025d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025db:	48 89 c7             	mov    %rax,%rdi
  8025de:	48 b8 19 22 80 00 00 	movabs $0x802219,%rax
  8025e5:	00 00 00 
  8025e8:	ff d0                	callq  *%rax
  8025ea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f2:	48 c1 e8 15          	shr    $0x15,%rax
  8025f6:	48 89 c2             	mov    %rax,%rdx
  8025f9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802600:	01 00 00 
  802603:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802607:	83 e0 01             	and    $0x1,%eax
  80260a:	48 85 c0             	test   %rax,%rax
  80260d:	74 73                	je     802682 <dup+0x11d>
  80260f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802613:	48 c1 e8 0c          	shr    $0xc,%rax
  802617:	48 89 c2             	mov    %rax,%rdx
  80261a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802621:	01 00 00 
  802624:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802628:	83 e0 01             	and    $0x1,%eax
  80262b:	48 85 c0             	test   %rax,%rax
  80262e:	74 52                	je     802682 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802634:	48 c1 e8 0c          	shr    $0xc,%rax
  802638:	48 89 c2             	mov    %rax,%rdx
  80263b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802642:	01 00 00 
  802645:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802649:	25 07 0e 00 00       	and    $0xe07,%eax
  80264e:	89 c1                	mov    %eax,%ecx
  802650:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802658:	41 89 c8             	mov    %ecx,%r8d
  80265b:	48 89 d1             	mov    %rdx,%rcx
  80265e:	ba 00 00 00 00       	mov    $0x0,%edx
  802663:	48 89 c6             	mov    %rax,%rsi
  802666:	bf 00 00 00 00       	mov    $0x0,%edi
  80266b:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  802672:	00 00 00 
  802675:	ff d0                	callq  *%rax
  802677:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267e:	79 02                	jns    802682 <dup+0x11d>
			goto err;
  802680:	eb 57                	jmp    8026d9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802682:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802686:	48 c1 e8 0c          	shr    $0xc,%rax
  80268a:	48 89 c2             	mov    %rax,%rdx
  80268d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802694:	01 00 00 
  802697:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80269b:	25 07 0e 00 00       	and    $0xe07,%eax
  8026a0:	89 c1                	mov    %eax,%ecx
  8026a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026aa:	41 89 c8             	mov    %ecx,%r8d
  8026ad:	48 89 d1             	mov    %rdx,%rcx
  8026b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b5:	48 89 c6             	mov    %rax,%rsi
  8026b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8026bd:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  8026c4:	00 00 00 
  8026c7:	ff d0                	callq  *%rax
  8026c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d0:	79 02                	jns    8026d4 <dup+0x16f>
		goto err;
  8026d2:	eb 05                	jmp    8026d9 <dup+0x174>

	return newfdnum;
  8026d4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026d7:	eb 33                	jmp    80270c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8026d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026dd:	48 89 c6             	mov    %rax,%rsi
  8026e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e5:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  8026ec:	00 00 00 
  8026ef:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f5:	48 89 c6             	mov    %rax,%rsi
  8026f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8026fd:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  802704:	00 00 00 
  802707:	ff d0                	callq  *%rax
	return r;
  802709:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80270c:	c9                   	leaveq 
  80270d:	c3                   	retq   

000000000080270e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80270e:	55                   	push   %rbp
  80270f:	48 89 e5             	mov    %rsp,%rbp
  802712:	48 83 ec 40          	sub    $0x40,%rsp
  802716:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802719:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80271d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802721:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802725:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802728:	48 89 d6             	mov    %rdx,%rsi
  80272b:	89 c7                	mov    %eax,%edi
  80272d:	48 b8 dc 22 80 00 00 	movabs $0x8022dc,%rax
  802734:	00 00 00 
  802737:	ff d0                	callq  *%rax
  802739:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802740:	78 24                	js     802766 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802746:	8b 00                	mov    (%rax),%eax
  802748:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80274c:	48 89 d6             	mov    %rdx,%rsi
  80274f:	89 c7                	mov    %eax,%edi
  802751:	48 b8 35 24 80 00 00 	movabs $0x802435,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
  80275d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802764:	79 05                	jns    80276b <read+0x5d>
		return r;
  802766:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802769:	eb 76                	jmp    8027e1 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80276b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276f:	8b 40 08             	mov    0x8(%rax),%eax
  802772:	83 e0 03             	and    $0x3,%eax
  802775:	83 f8 01             	cmp    $0x1,%eax
  802778:	75 3a                	jne    8027b4 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80277a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802781:	00 00 00 
  802784:	48 8b 00             	mov    (%rax),%rax
  802787:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80278d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802790:	89 c6                	mov    %eax,%esi
  802792:	48 bf bf 48 80 00 00 	movabs $0x8048bf,%rdi
  802799:	00 00 00 
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a1:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  8027a8:	00 00 00 
  8027ab:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027b2:	eb 2d                	jmp    8027e1 <read+0xd3>
	}
	if (!dev->dev_read)
  8027b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027bc:	48 85 c0             	test   %rax,%rax
  8027bf:	75 07                	jne    8027c8 <read+0xba>
		return -E_NOT_SUPP;
  8027c1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027c6:	eb 19                	jmp    8027e1 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8027c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027cc:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027d0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027d4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027d8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027dc:	48 89 cf             	mov    %rcx,%rdi
  8027df:	ff d0                	callq  *%rax
}
  8027e1:	c9                   	leaveq 
  8027e2:	c3                   	retq   

00000000008027e3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027e3:	55                   	push   %rbp
  8027e4:	48 89 e5             	mov    %rsp,%rbp
  8027e7:	48 83 ec 30          	sub    $0x30,%rsp
  8027eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027fd:	eb 49                	jmp    802848 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802802:	48 98                	cltq   
  802804:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802808:	48 29 c2             	sub    %rax,%rdx
  80280b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280e:	48 63 c8             	movslq %eax,%rcx
  802811:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802815:	48 01 c1             	add    %rax,%rcx
  802818:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80281b:	48 89 ce             	mov    %rcx,%rsi
  80281e:	89 c7                	mov    %eax,%edi
  802820:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  802827:	00 00 00 
  80282a:	ff d0                	callq  *%rax
  80282c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80282f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802833:	79 05                	jns    80283a <readn+0x57>
			return m;
  802835:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802838:	eb 1c                	jmp    802856 <readn+0x73>
		if (m == 0)
  80283a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80283e:	75 02                	jne    802842 <readn+0x5f>
			break;
  802840:	eb 11                	jmp    802853 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802842:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802845:	01 45 fc             	add    %eax,-0x4(%rbp)
  802848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284b:	48 98                	cltq   
  80284d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802851:	72 ac                	jb     8027ff <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802853:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802856:	c9                   	leaveq 
  802857:	c3                   	retq   

0000000000802858 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802858:	55                   	push   %rbp
  802859:	48 89 e5             	mov    %rsp,%rbp
  80285c:	48 83 ec 40          	sub    $0x40,%rsp
  802860:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802863:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802867:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80286b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80286f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802872:	48 89 d6             	mov    %rdx,%rsi
  802875:	89 c7                	mov    %eax,%edi
  802877:	48 b8 dc 22 80 00 00 	movabs $0x8022dc,%rax
  80287e:	00 00 00 
  802881:	ff d0                	callq  *%rax
  802883:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802886:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80288a:	78 24                	js     8028b0 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80288c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802890:	8b 00                	mov    (%rax),%eax
  802892:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802896:	48 89 d6             	mov    %rdx,%rsi
  802899:	89 c7                	mov    %eax,%edi
  80289b:	48 b8 35 24 80 00 00 	movabs $0x802435,%rax
  8028a2:	00 00 00 
  8028a5:	ff d0                	callq  *%rax
  8028a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ae:	79 05                	jns    8028b5 <write+0x5d>
		return r;
  8028b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b3:	eb 42                	jmp    8028f7 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b9:	8b 40 08             	mov    0x8(%rax),%eax
  8028bc:	83 e0 03             	and    $0x3,%eax
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	75 07                	jne    8028ca <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028c8:	eb 2d                	jmp    8028f7 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8028ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ce:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028d2:	48 85 c0             	test   %rax,%rax
  8028d5:	75 07                	jne    8028de <write+0x86>
		return -E_NOT_SUPP;
  8028d7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028dc:	eb 19                	jmp    8028f7 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8028de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028e6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028ee:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028f2:	48 89 cf             	mov    %rcx,%rdi
  8028f5:	ff d0                	callq  *%rax
}
  8028f7:	c9                   	leaveq 
  8028f8:	c3                   	retq   

00000000008028f9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8028f9:	55                   	push   %rbp
  8028fa:	48 89 e5             	mov    %rsp,%rbp
  8028fd:	48 83 ec 18          	sub    $0x18,%rsp
  802901:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802904:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802907:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80290b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80290e:	48 89 d6             	mov    %rdx,%rsi
  802911:	89 c7                	mov    %eax,%edi
  802913:	48 b8 dc 22 80 00 00 	movabs $0x8022dc,%rax
  80291a:	00 00 00 
  80291d:	ff d0                	callq  *%rax
  80291f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802922:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802926:	79 05                	jns    80292d <seek+0x34>
		return r;
  802928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292b:	eb 0f                	jmp    80293c <seek+0x43>
	fd->fd_offset = offset;
  80292d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802931:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802934:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802937:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80293c:	c9                   	leaveq 
  80293d:	c3                   	retq   

000000000080293e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80293e:	55                   	push   %rbp
  80293f:	48 89 e5             	mov    %rsp,%rbp
  802942:	48 83 ec 30          	sub    $0x30,%rsp
  802946:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802949:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80294c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802950:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802953:	48 89 d6             	mov    %rdx,%rsi
  802956:	89 c7                	mov    %eax,%edi
  802958:	48 b8 dc 22 80 00 00 	movabs $0x8022dc,%rax
  80295f:	00 00 00 
  802962:	ff d0                	callq  *%rax
  802964:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802967:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296b:	78 24                	js     802991 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80296d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802971:	8b 00                	mov    (%rax),%eax
  802973:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802977:	48 89 d6             	mov    %rdx,%rsi
  80297a:	89 c7                	mov    %eax,%edi
  80297c:	48 b8 35 24 80 00 00 	movabs $0x802435,%rax
  802983:	00 00 00 
  802986:	ff d0                	callq  *%rax
  802988:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80298f:	79 05                	jns    802996 <ftruncate+0x58>
		return r;
  802991:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802994:	eb 72                	jmp    802a08 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802996:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299a:	8b 40 08             	mov    0x8(%rax),%eax
  80299d:	83 e0 03             	and    $0x3,%eax
  8029a0:	85 c0                	test   %eax,%eax
  8029a2:	75 3a                	jne    8029de <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8029a4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029ab:	00 00 00 
  8029ae:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8029b1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029ba:	89 c6                	mov    %eax,%esi
  8029bc:	48 bf e0 48 80 00 00 	movabs $0x8048e0,%rdi
  8029c3:	00 00 00 
  8029c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029cb:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  8029d2:	00 00 00 
  8029d5:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8029d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029dc:	eb 2a                	jmp    802a08 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029e6:	48 85 c0             	test   %rax,%rax
  8029e9:	75 07                	jne    8029f2 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029eb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029f0:	eb 16                	jmp    802a08 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f6:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029fe:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a01:	89 ce                	mov    %ecx,%esi
  802a03:	48 89 d7             	mov    %rdx,%rdi
  802a06:	ff d0                	callq  *%rax
}
  802a08:	c9                   	leaveq 
  802a09:	c3                   	retq   

0000000000802a0a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a0a:	55                   	push   %rbp
  802a0b:	48 89 e5             	mov    %rsp,%rbp
  802a0e:	48 83 ec 30          	sub    $0x30,%rsp
  802a12:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a15:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a19:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a1d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a20:	48 89 d6             	mov    %rdx,%rsi
  802a23:	89 c7                	mov    %eax,%edi
  802a25:	48 b8 dc 22 80 00 00 	movabs $0x8022dc,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	callq  *%rax
  802a31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a38:	78 24                	js     802a5e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3e:	8b 00                	mov    (%rax),%eax
  802a40:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a44:	48 89 d6             	mov    %rdx,%rsi
  802a47:	89 c7                	mov    %eax,%edi
  802a49:	48 b8 35 24 80 00 00 	movabs $0x802435,%rax
  802a50:	00 00 00 
  802a53:	ff d0                	callq  *%rax
  802a55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5c:	79 05                	jns    802a63 <fstat+0x59>
		return r;
  802a5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a61:	eb 5e                	jmp    802ac1 <fstat+0xb7>
	if (!dev->dev_stat)
  802a63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a67:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a6b:	48 85 c0             	test   %rax,%rax
  802a6e:	75 07                	jne    802a77 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a70:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a75:	eb 4a                	jmp    802ac1 <fstat+0xb7>
	stat->st_name[0] = 0;
  802a77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a7b:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a82:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a89:	00 00 00 
	stat->st_isdir = 0;
  802a8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a90:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a97:	00 00 00 
	stat->st_dev = dev;
  802a9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aa2:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aad:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ab1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ab5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ab9:	48 89 ce             	mov    %rcx,%rsi
  802abc:	48 89 d7             	mov    %rdx,%rdi
  802abf:	ff d0                	callq  *%rax
}
  802ac1:	c9                   	leaveq 
  802ac2:	c3                   	retq   

0000000000802ac3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ac3:	55                   	push   %rbp
  802ac4:	48 89 e5             	mov    %rsp,%rbp
  802ac7:	48 83 ec 20          	sub    $0x20,%rsp
  802acb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802acf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad7:	be 00 00 00 00       	mov    $0x0,%esi
  802adc:	48 89 c7             	mov    %rax,%rdi
  802adf:	48 b8 b1 2b 80 00 00 	movabs $0x802bb1,%rax
  802ae6:	00 00 00 
  802ae9:	ff d0                	callq  *%rax
  802aeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af2:	79 05                	jns    802af9 <stat+0x36>
		return fd;
  802af4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af7:	eb 2f                	jmp    802b28 <stat+0x65>
	r = fstat(fd, stat);
  802af9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802afd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b00:	48 89 d6             	mov    %rdx,%rsi
  802b03:	89 c7                	mov    %eax,%edi
  802b05:	48 b8 0a 2a 80 00 00 	movabs $0x802a0a,%rax
  802b0c:	00 00 00 
  802b0f:	ff d0                	callq  *%rax
  802b11:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b17:	89 c7                	mov    %eax,%edi
  802b19:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  802b20:	00 00 00 
  802b23:	ff d0                	callq  *%rax
	return r;
  802b25:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b28:	c9                   	leaveq 
  802b29:	c3                   	retq   

0000000000802b2a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b2a:	55                   	push   %rbp
  802b2b:	48 89 e5             	mov    %rsp,%rbp
  802b2e:	48 83 ec 10          	sub    $0x10,%rsp
  802b32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b39:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b40:	00 00 00 
  802b43:	8b 00                	mov    (%rax),%eax
  802b45:	85 c0                	test   %eax,%eax
  802b47:	75 1d                	jne    802b66 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b49:	bf 01 00 00 00       	mov    $0x1,%edi
  802b4e:	48 b8 62 41 80 00 00 	movabs $0x804162,%rax
  802b55:	00 00 00 
  802b58:	ff d0                	callq  *%rax
  802b5a:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802b61:	00 00 00 
  802b64:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b66:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b6d:	00 00 00 
  802b70:	8b 00                	mov    (%rax),%eax
  802b72:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b75:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b7a:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802b81:	00 00 00 
  802b84:	89 c7                	mov    %eax,%edi
  802b86:	48 b8 95 3d 80 00 00 	movabs $0x803d95,%rax
  802b8d:	00 00 00 
  802b90:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b96:	ba 00 00 00 00       	mov    $0x0,%edx
  802b9b:	48 89 c6             	mov    %rax,%rsi
  802b9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba3:	48 b8 97 3c 80 00 00 	movabs $0x803c97,%rax
  802baa:	00 00 00 
  802bad:	ff d0                	callq  *%rax
}
  802baf:	c9                   	leaveq 
  802bb0:	c3                   	retq   

0000000000802bb1 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802bb1:	55                   	push   %rbp
  802bb2:	48 89 e5             	mov    %rsp,%rbp
  802bb5:	48 83 ec 30          	sub    $0x30,%rsp
  802bb9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802bbd:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802bc0:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802bc7:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802bce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802bd5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802bda:	75 08                	jne    802be4 <open+0x33>
	{
		return r;
  802bdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdf:	e9 f2 00 00 00       	jmpq   802cd6 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802be4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802be8:	48 89 c7             	mov    %rax,%rdi
  802beb:	48 b8 79 0e 80 00 00 	movabs $0x800e79,%rax
  802bf2:	00 00 00 
  802bf5:	ff d0                	callq  *%rax
  802bf7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802bfa:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802c01:	7e 0a                	jle    802c0d <open+0x5c>
	{
		return -E_BAD_PATH;
  802c03:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c08:	e9 c9 00 00 00       	jmpq   802cd6 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802c0d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802c14:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802c15:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802c19:	48 89 c7             	mov    %rax,%rdi
  802c1c:	48 b8 44 22 80 00 00 	movabs $0x802244,%rax
  802c23:	00 00 00 
  802c26:	ff d0                	callq  *%rax
  802c28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2f:	78 09                	js     802c3a <open+0x89>
  802c31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c35:	48 85 c0             	test   %rax,%rax
  802c38:	75 08                	jne    802c42 <open+0x91>
		{
			return r;
  802c3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3d:	e9 94 00 00 00       	jmpq   802cd6 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802c42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c46:	ba 00 04 00 00       	mov    $0x400,%edx
  802c4b:	48 89 c6             	mov    %rax,%rsi
  802c4e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c55:	00 00 00 
  802c58:	48 b8 77 0f 80 00 00 	movabs $0x800f77,%rax
  802c5f:	00 00 00 
  802c62:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802c64:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c6b:	00 00 00 
  802c6e:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802c71:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802c77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7b:	48 89 c6             	mov    %rax,%rsi
  802c7e:	bf 01 00 00 00       	mov    $0x1,%edi
  802c83:	48 b8 2a 2b 80 00 00 	movabs $0x802b2a,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
  802c8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c96:	79 2b                	jns    802cc3 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802c98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9c:	be 00 00 00 00       	mov    $0x0,%esi
  802ca1:	48 89 c7             	mov    %rax,%rdi
  802ca4:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  802cab:	00 00 00 
  802cae:	ff d0                	callq  *%rax
  802cb0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802cb3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cb7:	79 05                	jns    802cbe <open+0x10d>
			{
				return d;
  802cb9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cbc:	eb 18                	jmp    802cd6 <open+0x125>
			}
			return r;
  802cbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc1:	eb 13                	jmp    802cd6 <open+0x125>
		}	
		return fd2num(fd_store);
  802cc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc7:	48 89 c7             	mov    %rax,%rdi
  802cca:	48 b8 f6 21 80 00 00 	movabs $0x8021f6,%rax
  802cd1:	00 00 00 
  802cd4:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802cd6:	c9                   	leaveq 
  802cd7:	c3                   	retq   

0000000000802cd8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802cd8:	55                   	push   %rbp
  802cd9:	48 89 e5             	mov    %rsp,%rbp
  802cdc:	48 83 ec 10          	sub    $0x10,%rsp
  802ce0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802ce4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce8:	8b 50 0c             	mov    0xc(%rax),%edx
  802ceb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cf2:	00 00 00 
  802cf5:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802cf7:	be 00 00 00 00       	mov    $0x0,%esi
  802cfc:	bf 06 00 00 00       	mov    $0x6,%edi
  802d01:	48 b8 2a 2b 80 00 00 	movabs $0x802b2a,%rax
  802d08:	00 00 00 
  802d0b:	ff d0                	callq  *%rax
}
  802d0d:	c9                   	leaveq 
  802d0e:	c3                   	retq   

0000000000802d0f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d0f:	55                   	push   %rbp
  802d10:	48 89 e5             	mov    %rsp,%rbp
  802d13:	48 83 ec 30          	sub    $0x30,%rsp
  802d17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d1f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802d23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802d2a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d2f:	74 07                	je     802d38 <devfile_read+0x29>
  802d31:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d36:	75 07                	jne    802d3f <devfile_read+0x30>
		return -E_INVAL;
  802d38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d3d:	eb 77                	jmp    802db6 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d43:	8b 50 0c             	mov    0xc(%rax),%edx
  802d46:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d4d:	00 00 00 
  802d50:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d52:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d59:	00 00 00 
  802d5c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d60:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802d64:	be 00 00 00 00       	mov    $0x0,%esi
  802d69:	bf 03 00 00 00       	mov    $0x3,%edi
  802d6e:	48 b8 2a 2b 80 00 00 	movabs $0x802b2a,%rax
  802d75:	00 00 00 
  802d78:	ff d0                	callq  *%rax
  802d7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d81:	7f 05                	jg     802d88 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d86:	eb 2e                	jmp    802db6 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802d88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8b:	48 63 d0             	movslq %eax,%rdx
  802d8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d92:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802d99:	00 00 00 
  802d9c:	48 89 c7             	mov    %rax,%rdi
  802d9f:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  802da6:	00 00 00 
  802da9:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802dab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802daf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802db6:	c9                   	leaveq 
  802db7:	c3                   	retq   

0000000000802db8 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802db8:	55                   	push   %rbp
  802db9:	48 89 e5             	mov    %rsp,%rbp
  802dbc:	48 83 ec 30          	sub    $0x30,%rsp
  802dc0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dc4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dc8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802dcc:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802dd3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802dd8:	74 07                	je     802de1 <devfile_write+0x29>
  802dda:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ddf:	75 08                	jne    802de9 <devfile_write+0x31>
		return r;
  802de1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de4:	e9 9a 00 00 00       	jmpq   802e83 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802de9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ded:	8b 50 0c             	mov    0xc(%rax),%edx
  802df0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802df7:	00 00 00 
  802dfa:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802dfc:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802e03:	00 
  802e04:	76 08                	jbe    802e0e <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802e06:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802e0d:	00 
	}
	fsipcbuf.write.req_n = n;
  802e0e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e15:	00 00 00 
  802e18:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e1c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802e20:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e28:	48 89 c6             	mov    %rax,%rsi
  802e2b:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e32:	00 00 00 
  802e35:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  802e3c:	00 00 00 
  802e3f:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802e41:	be 00 00 00 00       	mov    $0x0,%esi
  802e46:	bf 04 00 00 00       	mov    $0x4,%edi
  802e4b:	48 b8 2a 2b 80 00 00 	movabs $0x802b2a,%rax
  802e52:	00 00 00 
  802e55:	ff d0                	callq  *%rax
  802e57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5e:	7f 20                	jg     802e80 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802e60:	48 bf 06 49 80 00 00 	movabs $0x804906,%rdi
  802e67:	00 00 00 
  802e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6f:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  802e76:	00 00 00 
  802e79:	ff d2                	callq  *%rdx
		return r;
  802e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7e:	eb 03                	jmp    802e83 <devfile_write+0xcb>
	}
	return r;
  802e80:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802e83:	c9                   	leaveq 
  802e84:	c3                   	retq   

0000000000802e85 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e85:	55                   	push   %rbp
  802e86:	48 89 e5             	mov    %rsp,%rbp
  802e89:	48 83 ec 20          	sub    $0x20,%rsp
  802e8d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e91:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e99:	8b 50 0c             	mov    0xc(%rax),%edx
  802e9c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ea3:	00 00 00 
  802ea6:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ea8:	be 00 00 00 00       	mov    $0x0,%esi
  802ead:	bf 05 00 00 00       	mov    $0x5,%edi
  802eb2:	48 b8 2a 2b 80 00 00 	movabs $0x802b2a,%rax
  802eb9:	00 00 00 
  802ebc:	ff d0                	callq  *%rax
  802ebe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec5:	79 05                	jns    802ecc <devfile_stat+0x47>
		return r;
  802ec7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eca:	eb 56                	jmp    802f22 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ecc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed0:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ed7:	00 00 00 
  802eda:	48 89 c7             	mov    %rax,%rdi
  802edd:	48 b8 e5 0e 80 00 00 	movabs $0x800ee5,%rax
  802ee4:	00 00 00 
  802ee7:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ee9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ef0:	00 00 00 
  802ef3:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ef9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802efd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f03:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f0a:	00 00 00 
  802f0d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f17:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f22:	c9                   	leaveq 
  802f23:	c3                   	retq   

0000000000802f24 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f24:	55                   	push   %rbp
  802f25:	48 89 e5             	mov    %rsp,%rbp
  802f28:	48 83 ec 10          	sub    $0x10,%rsp
  802f2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f30:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f37:	8b 50 0c             	mov    0xc(%rax),%edx
  802f3a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f41:	00 00 00 
  802f44:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f46:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f4d:	00 00 00 
  802f50:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f53:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f56:	be 00 00 00 00       	mov    $0x0,%esi
  802f5b:	bf 02 00 00 00       	mov    $0x2,%edi
  802f60:	48 b8 2a 2b 80 00 00 	movabs $0x802b2a,%rax
  802f67:	00 00 00 
  802f6a:	ff d0                	callq  *%rax
}
  802f6c:	c9                   	leaveq 
  802f6d:	c3                   	retq   

0000000000802f6e <remove>:

// Delete a file
int
remove(const char *path)
{
  802f6e:	55                   	push   %rbp
  802f6f:	48 89 e5             	mov    %rsp,%rbp
  802f72:	48 83 ec 10          	sub    $0x10,%rsp
  802f76:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802f7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f7e:	48 89 c7             	mov    %rax,%rdi
  802f81:	48 b8 79 0e 80 00 00 	movabs $0x800e79,%rax
  802f88:	00 00 00 
  802f8b:	ff d0                	callq  *%rax
  802f8d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f92:	7e 07                	jle    802f9b <remove+0x2d>
		return -E_BAD_PATH;
  802f94:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f99:	eb 33                	jmp    802fce <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802f9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f9f:	48 89 c6             	mov    %rax,%rsi
  802fa2:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802fa9:	00 00 00 
  802fac:	48 b8 e5 0e 80 00 00 	movabs $0x800ee5,%rax
  802fb3:	00 00 00 
  802fb6:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802fb8:	be 00 00 00 00       	mov    $0x0,%esi
  802fbd:	bf 07 00 00 00       	mov    $0x7,%edi
  802fc2:	48 b8 2a 2b 80 00 00 	movabs $0x802b2a,%rax
  802fc9:	00 00 00 
  802fcc:	ff d0                	callq  *%rax
}
  802fce:	c9                   	leaveq 
  802fcf:	c3                   	retq   

0000000000802fd0 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802fd0:	55                   	push   %rbp
  802fd1:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802fd4:	be 00 00 00 00       	mov    $0x0,%esi
  802fd9:	bf 08 00 00 00       	mov    $0x8,%edi
  802fde:	48 b8 2a 2b 80 00 00 	movabs $0x802b2a,%rax
  802fe5:	00 00 00 
  802fe8:	ff d0                	callq  *%rax
}
  802fea:	5d                   	pop    %rbp
  802feb:	c3                   	retq   

0000000000802fec <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802fec:	55                   	push   %rbp
  802fed:	48 89 e5             	mov    %rsp,%rbp
  802ff0:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ff7:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802ffe:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803005:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80300c:	be 00 00 00 00       	mov    $0x0,%esi
  803011:	48 89 c7             	mov    %rax,%rdi
  803014:	48 b8 b1 2b 80 00 00 	movabs $0x802bb1,%rax
  80301b:	00 00 00 
  80301e:	ff d0                	callq  *%rax
  803020:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803023:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803027:	79 28                	jns    803051 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803029:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302c:	89 c6                	mov    %eax,%esi
  80302e:	48 bf 22 49 80 00 00 	movabs $0x804922,%rdi
  803035:	00 00 00 
  803038:	b8 00 00 00 00       	mov    $0x0,%eax
  80303d:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  803044:	00 00 00 
  803047:	ff d2                	callq  *%rdx
		return fd_src;
  803049:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304c:	e9 74 01 00 00       	jmpq   8031c5 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803051:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803058:	be 01 01 00 00       	mov    $0x101,%esi
  80305d:	48 89 c7             	mov    %rax,%rdi
  803060:	48 b8 b1 2b 80 00 00 	movabs $0x802bb1,%rax
  803067:	00 00 00 
  80306a:	ff d0                	callq  *%rax
  80306c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80306f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803073:	79 39                	jns    8030ae <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803075:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803078:	89 c6                	mov    %eax,%esi
  80307a:	48 bf 38 49 80 00 00 	movabs $0x804938,%rdi
  803081:	00 00 00 
  803084:	b8 00 00 00 00       	mov    $0x0,%eax
  803089:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  803090:	00 00 00 
  803093:	ff d2                	callq  *%rdx
		close(fd_src);
  803095:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803098:	89 c7                	mov    %eax,%edi
  80309a:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  8030a1:	00 00 00 
  8030a4:	ff d0                	callq  *%rax
		return fd_dest;
  8030a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030a9:	e9 17 01 00 00       	jmpq   8031c5 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030ae:	eb 74                	jmp    803124 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8030b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030b3:	48 63 d0             	movslq %eax,%rdx
  8030b6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8030bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030c0:	48 89 ce             	mov    %rcx,%rsi
  8030c3:	89 c7                	mov    %eax,%edi
  8030c5:	48 b8 58 28 80 00 00 	movabs $0x802858,%rax
  8030cc:	00 00 00 
  8030cf:	ff d0                	callq  *%rax
  8030d1:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8030d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8030d8:	79 4a                	jns    803124 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8030da:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030dd:	89 c6                	mov    %eax,%esi
  8030df:	48 bf 52 49 80 00 00 	movabs $0x804952,%rdi
  8030e6:	00 00 00 
  8030e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ee:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  8030f5:	00 00 00 
  8030f8:	ff d2                	callq  *%rdx
			close(fd_src);
  8030fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fd:	89 c7                	mov    %eax,%edi
  8030ff:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  803106:	00 00 00 
  803109:	ff d0                	callq  *%rax
			close(fd_dest);
  80310b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80310e:	89 c7                	mov    %eax,%edi
  803110:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  803117:	00 00 00 
  80311a:	ff d0                	callq  *%rax
			return write_size;
  80311c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80311f:	e9 a1 00 00 00       	jmpq   8031c5 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803124:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80312b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312e:	ba 00 02 00 00       	mov    $0x200,%edx
  803133:	48 89 ce             	mov    %rcx,%rsi
  803136:	89 c7                	mov    %eax,%edi
  803138:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  80313f:	00 00 00 
  803142:	ff d0                	callq  *%rax
  803144:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803147:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80314b:	0f 8f 5f ff ff ff    	jg     8030b0 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803151:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803155:	79 47                	jns    80319e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803157:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80315a:	89 c6                	mov    %eax,%esi
  80315c:	48 bf 65 49 80 00 00 	movabs $0x804965,%rdi
  803163:	00 00 00 
  803166:	b8 00 00 00 00       	mov    $0x0,%eax
  80316b:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  803172:	00 00 00 
  803175:	ff d2                	callq  *%rdx
		close(fd_src);
  803177:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317a:	89 c7                	mov    %eax,%edi
  80317c:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  803183:	00 00 00 
  803186:	ff d0                	callq  *%rax
		close(fd_dest);
  803188:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80318b:	89 c7                	mov    %eax,%edi
  80318d:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
		return read_size;
  803199:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80319c:	eb 27                	jmp    8031c5 <copy+0x1d9>
	}
	close(fd_src);
  80319e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a1:	89 c7                	mov    %eax,%edi
  8031a3:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  8031aa:	00 00 00 
  8031ad:	ff d0                	callq  *%rax
	close(fd_dest);
  8031af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031b2:	89 c7                	mov    %eax,%edi
  8031b4:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  8031bb:	00 00 00 
  8031be:	ff d0                	callq  *%rax
	return 0;
  8031c0:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8031c5:	c9                   	leaveq 
  8031c6:	c3                   	retq   

00000000008031c7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8031c7:	55                   	push   %rbp
  8031c8:	48 89 e5             	mov    %rsp,%rbp
  8031cb:	53                   	push   %rbx
  8031cc:	48 83 ec 38          	sub    $0x38,%rsp
  8031d0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031d4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8031d8:	48 89 c7             	mov    %rax,%rdi
  8031db:	48 b8 44 22 80 00 00 	movabs $0x802244,%rax
  8031e2:	00 00 00 
  8031e5:	ff d0                	callq  *%rax
  8031e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031ee:	0f 88 bf 01 00 00    	js     8033b3 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f8:	ba 07 04 00 00       	mov    $0x407,%edx
  8031fd:	48 89 c6             	mov    %rax,%rsi
  803200:	bf 00 00 00 00       	mov    $0x0,%edi
  803205:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  80320c:	00 00 00 
  80320f:	ff d0                	callq  *%rax
  803211:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803214:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803218:	0f 88 95 01 00 00    	js     8033b3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80321e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803222:	48 89 c7             	mov    %rax,%rdi
  803225:	48 b8 44 22 80 00 00 	movabs $0x802244,%rax
  80322c:	00 00 00 
  80322f:	ff d0                	callq  *%rax
  803231:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803234:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803238:	0f 88 5d 01 00 00    	js     80339b <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80323e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803242:	ba 07 04 00 00       	mov    $0x407,%edx
  803247:	48 89 c6             	mov    %rax,%rsi
  80324a:	bf 00 00 00 00       	mov    $0x0,%edi
  80324f:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  803256:	00 00 00 
  803259:	ff d0                	callq  *%rax
  80325b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80325e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803262:	0f 88 33 01 00 00    	js     80339b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803268:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326c:	48 89 c7             	mov    %rax,%rdi
  80326f:	48 b8 19 22 80 00 00 	movabs $0x802219,%rax
  803276:	00 00 00 
  803279:	ff d0                	callq  *%rax
  80327b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80327f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803283:	ba 07 04 00 00       	mov    $0x407,%edx
  803288:	48 89 c6             	mov    %rax,%rsi
  80328b:	bf 00 00 00 00       	mov    $0x0,%edi
  803290:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  803297:	00 00 00 
  80329a:	ff d0                	callq  *%rax
  80329c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80329f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032a3:	79 05                	jns    8032aa <pipe+0xe3>
		goto err2;
  8032a5:	e9 d9 00 00 00       	jmpq   803383 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ae:	48 89 c7             	mov    %rax,%rdi
  8032b1:	48 b8 19 22 80 00 00 	movabs $0x802219,%rax
  8032b8:	00 00 00 
  8032bb:	ff d0                	callq  *%rax
  8032bd:	48 89 c2             	mov    %rax,%rdx
  8032c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8032ca:	48 89 d1             	mov    %rdx,%rcx
  8032cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8032d2:	48 89 c6             	mov    %rax,%rsi
  8032d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8032da:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  8032e1:	00 00 00 
  8032e4:	ff d0                	callq  *%rax
  8032e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ed:	79 1b                	jns    80330a <pipe+0x143>
		goto err3;
  8032ef:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8032f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032f4:	48 89 c6             	mov    %rax,%rsi
  8032f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8032fc:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  803303:	00 00 00 
  803306:	ff d0                	callq  *%rax
  803308:	eb 79                	jmp    803383 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80330a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80330e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803315:	00 00 00 
  803318:	8b 12                	mov    (%rdx),%edx
  80331a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80331c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803320:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803327:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80332b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803332:	00 00 00 
  803335:	8b 12                	mov    (%rdx),%edx
  803337:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803339:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80333d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803344:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803348:	48 89 c7             	mov    %rax,%rdi
  80334b:	48 b8 f6 21 80 00 00 	movabs $0x8021f6,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
  803357:	89 c2                	mov    %eax,%edx
  803359:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80335d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80335f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803363:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803367:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80336b:	48 89 c7             	mov    %rax,%rdi
  80336e:	48 b8 f6 21 80 00 00 	movabs $0x8021f6,%rax
  803375:	00 00 00 
  803378:	ff d0                	callq  *%rax
  80337a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80337c:	b8 00 00 00 00       	mov    $0x0,%eax
  803381:	eb 33                	jmp    8033b6 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803383:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803387:	48 89 c6             	mov    %rax,%rsi
  80338a:	bf 00 00 00 00       	mov    $0x0,%edi
  80338f:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  803396:	00 00 00 
  803399:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80339b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80339f:	48 89 c6             	mov    %rax,%rsi
  8033a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a7:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  8033ae:	00 00 00 
  8033b1:	ff d0                	callq  *%rax
err:
	return r;
  8033b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8033b6:	48 83 c4 38          	add    $0x38,%rsp
  8033ba:	5b                   	pop    %rbx
  8033bb:	5d                   	pop    %rbp
  8033bc:	c3                   	retq   

00000000008033bd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8033bd:	55                   	push   %rbp
  8033be:	48 89 e5             	mov    %rsp,%rbp
  8033c1:	53                   	push   %rbx
  8033c2:	48 83 ec 28          	sub    $0x28,%rsp
  8033c6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033ca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8033ce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033d5:	00 00 00 
  8033d8:	48 8b 00             	mov    (%rax),%rax
  8033db:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8033e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e8:	48 89 c7             	mov    %rax,%rdi
  8033eb:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  8033f2:	00 00 00 
  8033f5:	ff d0                	callq  *%rax
  8033f7:	89 c3                	mov    %eax,%ebx
  8033f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033fd:	48 89 c7             	mov    %rax,%rdi
  803400:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
  80340c:	39 c3                	cmp    %eax,%ebx
  80340e:	0f 94 c0             	sete   %al
  803411:	0f b6 c0             	movzbl %al,%eax
  803414:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803417:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80341e:	00 00 00 
  803421:	48 8b 00             	mov    (%rax),%rax
  803424:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80342a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80342d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803430:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803433:	75 05                	jne    80343a <_pipeisclosed+0x7d>
			return ret;
  803435:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803438:	eb 4f                	jmp    803489 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80343a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80343d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803440:	74 42                	je     803484 <_pipeisclosed+0xc7>
  803442:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803446:	75 3c                	jne    803484 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803448:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80344f:	00 00 00 
  803452:	48 8b 00             	mov    (%rax),%rax
  803455:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80345b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80345e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803461:	89 c6                	mov    %eax,%esi
  803463:	48 bf 85 49 80 00 00 	movabs $0x804985,%rdi
  80346a:	00 00 00 
  80346d:	b8 00 00 00 00       	mov    $0x0,%eax
  803472:	49 b8 30 03 80 00 00 	movabs $0x800330,%r8
  803479:	00 00 00 
  80347c:	41 ff d0             	callq  *%r8
	}
  80347f:	e9 4a ff ff ff       	jmpq   8033ce <_pipeisclosed+0x11>
  803484:	e9 45 ff ff ff       	jmpq   8033ce <_pipeisclosed+0x11>
}
  803489:	48 83 c4 28          	add    $0x28,%rsp
  80348d:	5b                   	pop    %rbx
  80348e:	5d                   	pop    %rbp
  80348f:	c3                   	retq   

0000000000803490 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803490:	55                   	push   %rbp
  803491:	48 89 e5             	mov    %rsp,%rbp
  803494:	48 83 ec 30          	sub    $0x30,%rsp
  803498:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80349b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80349f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034a2:	48 89 d6             	mov    %rdx,%rsi
  8034a5:	89 c7                	mov    %eax,%edi
  8034a7:	48 b8 dc 22 80 00 00 	movabs $0x8022dc,%rax
  8034ae:	00 00 00 
  8034b1:	ff d0                	callq  *%rax
  8034b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ba:	79 05                	jns    8034c1 <pipeisclosed+0x31>
		return r;
  8034bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034bf:	eb 31                	jmp    8034f2 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8034c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c5:	48 89 c7             	mov    %rax,%rdi
  8034c8:	48 b8 19 22 80 00 00 	movabs $0x802219,%rax
  8034cf:	00 00 00 
  8034d2:	ff d0                	callq  *%rax
  8034d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8034d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034e0:	48 89 d6             	mov    %rdx,%rsi
  8034e3:	48 89 c7             	mov    %rax,%rdi
  8034e6:	48 b8 bd 33 80 00 00 	movabs $0x8033bd,%rax
  8034ed:	00 00 00 
  8034f0:	ff d0                	callq  *%rax
}
  8034f2:	c9                   	leaveq 
  8034f3:	c3                   	retq   

00000000008034f4 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034f4:	55                   	push   %rbp
  8034f5:	48 89 e5             	mov    %rsp,%rbp
  8034f8:	48 83 ec 40          	sub    $0x40,%rsp
  8034fc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803500:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803504:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803508:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80350c:	48 89 c7             	mov    %rax,%rdi
  80350f:	48 b8 19 22 80 00 00 	movabs $0x802219,%rax
  803516:	00 00 00 
  803519:	ff d0                	callq  *%rax
  80351b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80351f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803523:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803527:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80352e:	00 
  80352f:	e9 92 00 00 00       	jmpq   8035c6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803534:	eb 41                	jmp    803577 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803536:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80353b:	74 09                	je     803546 <devpipe_read+0x52>
				return i;
  80353d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803541:	e9 92 00 00 00       	jmpq   8035d8 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803546:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80354a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80354e:	48 89 d6             	mov    %rdx,%rsi
  803551:	48 89 c7             	mov    %rax,%rdi
  803554:	48 b8 bd 33 80 00 00 	movabs $0x8033bd,%rax
  80355b:	00 00 00 
  80355e:	ff d0                	callq  *%rax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 07                	je     80356b <devpipe_read+0x77>
				return 0;
  803564:	b8 00 00 00 00       	mov    $0x0,%eax
  803569:	eb 6d                	jmp    8035d8 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80356b:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357b:	8b 10                	mov    (%rax),%edx
  80357d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803581:	8b 40 04             	mov    0x4(%rax),%eax
  803584:	39 c2                	cmp    %eax,%edx
  803586:	74 ae                	je     803536 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803588:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80358c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803590:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803598:	8b 00                	mov    (%rax),%eax
  80359a:	99                   	cltd   
  80359b:	c1 ea 1b             	shr    $0x1b,%edx
  80359e:	01 d0                	add    %edx,%eax
  8035a0:	83 e0 1f             	and    $0x1f,%eax
  8035a3:	29 d0                	sub    %edx,%eax
  8035a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035a9:	48 98                	cltq   
  8035ab:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8035b0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8035b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b6:	8b 00                	mov    (%rax),%eax
  8035b8:	8d 50 01             	lea    0x1(%rax),%edx
  8035bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035bf:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ca:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035ce:	0f 82 60 ff ff ff    	jb     803534 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8035d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035d8:	c9                   	leaveq 
  8035d9:	c3                   	retq   

00000000008035da <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035da:	55                   	push   %rbp
  8035db:	48 89 e5             	mov    %rsp,%rbp
  8035de:	48 83 ec 40          	sub    $0x40,%rsp
  8035e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8035ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f2:	48 89 c7             	mov    %rax,%rdi
  8035f5:	48 b8 19 22 80 00 00 	movabs $0x802219,%rax
  8035fc:	00 00 00 
  8035ff:	ff d0                	callq  *%rax
  803601:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803605:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803609:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80360d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803614:	00 
  803615:	e9 8e 00 00 00       	jmpq   8036a8 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80361a:	eb 31                	jmp    80364d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80361c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803620:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803624:	48 89 d6             	mov    %rdx,%rsi
  803627:	48 89 c7             	mov    %rax,%rdi
  80362a:	48 b8 bd 33 80 00 00 	movabs $0x8033bd,%rax
  803631:	00 00 00 
  803634:	ff d0                	callq  *%rax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 07                	je     803641 <devpipe_write+0x67>
				return 0;
  80363a:	b8 00 00 00 00       	mov    $0x0,%eax
  80363f:	eb 79                	jmp    8036ba <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803641:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  803648:	00 00 00 
  80364b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80364d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803651:	8b 40 04             	mov    0x4(%rax),%eax
  803654:	48 63 d0             	movslq %eax,%rdx
  803657:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365b:	8b 00                	mov    (%rax),%eax
  80365d:	48 98                	cltq   
  80365f:	48 83 c0 20          	add    $0x20,%rax
  803663:	48 39 c2             	cmp    %rax,%rdx
  803666:	73 b4                	jae    80361c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366c:	8b 40 04             	mov    0x4(%rax),%eax
  80366f:	99                   	cltd   
  803670:	c1 ea 1b             	shr    $0x1b,%edx
  803673:	01 d0                	add    %edx,%eax
  803675:	83 e0 1f             	and    $0x1f,%eax
  803678:	29 d0                	sub    %edx,%eax
  80367a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80367e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803682:	48 01 ca             	add    %rcx,%rdx
  803685:	0f b6 0a             	movzbl (%rdx),%ecx
  803688:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80368c:	48 98                	cltq   
  80368e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803696:	8b 40 04             	mov    0x4(%rax),%eax
  803699:	8d 50 01             	lea    0x1(%rax),%edx
  80369c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ac:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036b0:	0f 82 64 ff ff ff    	jb     80361a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8036b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036ba:	c9                   	leaveq 
  8036bb:	c3                   	retq   

00000000008036bc <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8036bc:	55                   	push   %rbp
  8036bd:	48 89 e5             	mov    %rsp,%rbp
  8036c0:	48 83 ec 20          	sub    $0x20,%rsp
  8036c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8036cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d0:	48 89 c7             	mov    %rax,%rdi
  8036d3:	48 b8 19 22 80 00 00 	movabs $0x802219,%rax
  8036da:	00 00 00 
  8036dd:	ff d0                	callq  *%rax
  8036df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8036e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e7:	48 be 98 49 80 00 00 	movabs $0x804998,%rsi
  8036ee:	00 00 00 
  8036f1:	48 89 c7             	mov    %rax,%rdi
  8036f4:	48 b8 e5 0e 80 00 00 	movabs $0x800ee5,%rax
  8036fb:	00 00 00 
  8036fe:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803700:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803704:	8b 50 04             	mov    0x4(%rax),%edx
  803707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80370b:	8b 00                	mov    (%rax),%eax
  80370d:	29 c2                	sub    %eax,%edx
  80370f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803713:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803719:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80371d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803724:	00 00 00 
	stat->st_dev = &devpipe;
  803727:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80372b:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803732:	00 00 00 
  803735:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80373c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803741:	c9                   	leaveq 
  803742:	c3                   	retq   

0000000000803743 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803743:	55                   	push   %rbp
  803744:	48 89 e5             	mov    %rsp,%rbp
  803747:	48 83 ec 10          	sub    $0x10,%rsp
  80374b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80374f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803753:	48 89 c6             	mov    %rax,%rsi
  803756:	bf 00 00 00 00       	mov    $0x0,%edi
  80375b:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  803762:	00 00 00 
  803765:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803767:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376b:	48 89 c7             	mov    %rax,%rdi
  80376e:	48 b8 19 22 80 00 00 	movabs $0x802219,%rax
  803775:	00 00 00 
  803778:	ff d0                	callq  *%rax
  80377a:	48 89 c6             	mov    %rax,%rsi
  80377d:	bf 00 00 00 00       	mov    $0x0,%edi
  803782:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  803789:	00 00 00 
  80378c:	ff d0                	callq  *%rax
}
  80378e:	c9                   	leaveq 
  80378f:	c3                   	retq   

0000000000803790 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803790:	55                   	push   %rbp
  803791:	48 89 e5             	mov    %rsp,%rbp
  803794:	48 83 ec 20          	sub    $0x20,%rsp
  803798:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80379b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80379e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8037a1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8037a5:	be 01 00 00 00       	mov    $0x1,%esi
  8037aa:	48 89 c7             	mov    %rax,%rdi
  8037ad:	48 b8 cc 16 80 00 00 	movabs $0x8016cc,%rax
  8037b4:	00 00 00 
  8037b7:	ff d0                	callq  *%rax
}
  8037b9:	c9                   	leaveq 
  8037ba:	c3                   	retq   

00000000008037bb <getchar>:

int
getchar(void)
{
  8037bb:	55                   	push   %rbp
  8037bc:	48 89 e5             	mov    %rsp,%rbp
  8037bf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8037c3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8037c7:	ba 01 00 00 00       	mov    $0x1,%edx
  8037cc:	48 89 c6             	mov    %rax,%rsi
  8037cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8037d4:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  8037db:	00 00 00 
  8037de:	ff d0                	callq  *%rax
  8037e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8037e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e7:	79 05                	jns    8037ee <getchar+0x33>
		return r;
  8037e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ec:	eb 14                	jmp    803802 <getchar+0x47>
	if (r < 1)
  8037ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037f2:	7f 07                	jg     8037fb <getchar+0x40>
		return -E_EOF;
  8037f4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8037f9:	eb 07                	jmp    803802 <getchar+0x47>
	return c;
  8037fb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8037ff:	0f b6 c0             	movzbl %al,%eax
}
  803802:	c9                   	leaveq 
  803803:	c3                   	retq   

0000000000803804 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803804:	55                   	push   %rbp
  803805:	48 89 e5             	mov    %rsp,%rbp
  803808:	48 83 ec 20          	sub    $0x20,%rsp
  80380c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80380f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803813:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803816:	48 89 d6             	mov    %rdx,%rsi
  803819:	89 c7                	mov    %eax,%edi
  80381b:	48 b8 dc 22 80 00 00 	movabs $0x8022dc,%rax
  803822:	00 00 00 
  803825:	ff d0                	callq  *%rax
  803827:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80382a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80382e:	79 05                	jns    803835 <iscons+0x31>
		return r;
  803830:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803833:	eb 1a                	jmp    80384f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803835:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803839:	8b 10                	mov    (%rax),%edx
  80383b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803842:	00 00 00 
  803845:	8b 00                	mov    (%rax),%eax
  803847:	39 c2                	cmp    %eax,%edx
  803849:	0f 94 c0             	sete   %al
  80384c:	0f b6 c0             	movzbl %al,%eax
}
  80384f:	c9                   	leaveq 
  803850:	c3                   	retq   

0000000000803851 <opencons>:

int
opencons(void)
{
  803851:	55                   	push   %rbp
  803852:	48 89 e5             	mov    %rsp,%rbp
  803855:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803859:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80385d:	48 89 c7             	mov    %rax,%rdi
  803860:	48 b8 44 22 80 00 00 	movabs $0x802244,%rax
  803867:	00 00 00 
  80386a:	ff d0                	callq  *%rax
  80386c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803873:	79 05                	jns    80387a <opencons+0x29>
		return r;
  803875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803878:	eb 5b                	jmp    8038d5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80387a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387e:	ba 07 04 00 00       	mov    $0x407,%edx
  803883:	48 89 c6             	mov    %rax,%rsi
  803886:	bf 00 00 00 00       	mov    $0x0,%edi
  80388b:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  803892:	00 00 00 
  803895:	ff d0                	callq  *%rax
  803897:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80389a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80389e:	79 05                	jns    8038a5 <opencons+0x54>
		return r;
  8038a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a3:	eb 30                	jmp    8038d5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8038a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a9:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8038b0:	00 00 00 
  8038b3:	8b 12                	mov    (%rdx),%edx
  8038b5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8038b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8038c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c6:	48 89 c7             	mov    %rax,%rdi
  8038c9:	48 b8 f6 21 80 00 00 	movabs $0x8021f6,%rax
  8038d0:	00 00 00 
  8038d3:	ff d0                	callq  *%rax
}
  8038d5:	c9                   	leaveq 
  8038d6:	c3                   	retq   

00000000008038d7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038d7:	55                   	push   %rbp
  8038d8:	48 89 e5             	mov    %rsp,%rbp
  8038db:	48 83 ec 30          	sub    $0x30,%rsp
  8038df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8038eb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038f0:	75 07                	jne    8038f9 <devcons_read+0x22>
		return 0;
  8038f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8038f7:	eb 4b                	jmp    803944 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8038f9:	eb 0c                	jmp    803907 <devcons_read+0x30>
		sys_yield();
  8038fb:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  803902:	00 00 00 
  803905:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803907:	48 b8 16 17 80 00 00 	movabs $0x801716,%rax
  80390e:	00 00 00 
  803911:	ff d0                	callq  *%rax
  803913:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803916:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80391a:	74 df                	je     8038fb <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80391c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803920:	79 05                	jns    803927 <devcons_read+0x50>
		return c;
  803922:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803925:	eb 1d                	jmp    803944 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803927:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80392b:	75 07                	jne    803934 <devcons_read+0x5d>
		return 0;
  80392d:	b8 00 00 00 00       	mov    $0x0,%eax
  803932:	eb 10                	jmp    803944 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803934:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803937:	89 c2                	mov    %eax,%edx
  803939:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80393d:	88 10                	mov    %dl,(%rax)
	return 1;
  80393f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803944:	c9                   	leaveq 
  803945:	c3                   	retq   

0000000000803946 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803946:	55                   	push   %rbp
  803947:	48 89 e5             	mov    %rsp,%rbp
  80394a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803951:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803958:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80395f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803966:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80396d:	eb 76                	jmp    8039e5 <devcons_write+0x9f>
		m = n - tot;
  80396f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803976:	89 c2                	mov    %eax,%edx
  803978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397b:	29 c2                	sub    %eax,%edx
  80397d:	89 d0                	mov    %edx,%eax
  80397f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803982:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803985:	83 f8 7f             	cmp    $0x7f,%eax
  803988:	76 07                	jbe    803991 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80398a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803991:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803994:	48 63 d0             	movslq %eax,%rdx
  803997:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399a:	48 63 c8             	movslq %eax,%rcx
  80399d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8039a4:	48 01 c1             	add    %rax,%rcx
  8039a7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039ae:	48 89 ce             	mov    %rcx,%rsi
  8039b1:	48 89 c7             	mov    %rax,%rdi
  8039b4:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  8039bb:	00 00 00 
  8039be:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8039c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039c3:	48 63 d0             	movslq %eax,%rdx
  8039c6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039cd:	48 89 d6             	mov    %rdx,%rsi
  8039d0:	48 89 c7             	mov    %rax,%rdi
  8039d3:	48 b8 cc 16 80 00 00 	movabs $0x8016cc,%rax
  8039da:	00 00 00 
  8039dd:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039e2:	01 45 fc             	add    %eax,-0x4(%rbp)
  8039e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e8:	48 98                	cltq   
  8039ea:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8039f1:	0f 82 78 ff ff ff    	jb     80396f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8039f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039fa:	c9                   	leaveq 
  8039fb:	c3                   	retq   

00000000008039fc <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8039fc:	55                   	push   %rbp
  8039fd:	48 89 e5             	mov    %rsp,%rbp
  803a00:	48 83 ec 08          	sub    $0x8,%rsp
  803a04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a0d:	c9                   	leaveq 
  803a0e:	c3                   	retq   

0000000000803a0f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a0f:	55                   	push   %rbp
  803a10:	48 89 e5             	mov    %rsp,%rbp
  803a13:	48 83 ec 10          	sub    $0x10,%rsp
  803a17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a1b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803a1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a23:	48 be a4 49 80 00 00 	movabs $0x8049a4,%rsi
  803a2a:	00 00 00 
  803a2d:	48 89 c7             	mov    %rax,%rdi
  803a30:	48 b8 e5 0e 80 00 00 	movabs $0x800ee5,%rax
  803a37:	00 00 00 
  803a3a:	ff d0                	callq  *%rax
	return 0;
  803a3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a41:	c9                   	leaveq 
  803a42:	c3                   	retq   

0000000000803a43 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803a43:	55                   	push   %rbp
  803a44:	48 89 e5             	mov    %rsp,%rbp
  803a47:	53                   	push   %rbx
  803a48:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803a4f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803a56:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803a5c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803a63:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803a6a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803a71:	84 c0                	test   %al,%al
  803a73:	74 23                	je     803a98 <_panic+0x55>
  803a75:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803a7c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803a80:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803a84:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803a88:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803a8c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803a90:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803a94:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803a98:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803a9f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803aa6:	00 00 00 
  803aa9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803ab0:	00 00 00 
  803ab3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ab7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803abe:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803ac5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803acc:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803ad3:	00 00 00 
  803ad6:	48 8b 18             	mov    (%rax),%rbx
  803ad9:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  803ae0:	00 00 00 
  803ae3:	ff d0                	callq  *%rax
  803ae5:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803aeb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803af2:	41 89 c8             	mov    %ecx,%r8d
  803af5:	48 89 d1             	mov    %rdx,%rcx
  803af8:	48 89 da             	mov    %rbx,%rdx
  803afb:	89 c6                	mov    %eax,%esi
  803afd:	48 bf b0 49 80 00 00 	movabs $0x8049b0,%rdi
  803b04:	00 00 00 
  803b07:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0c:	49 b9 30 03 80 00 00 	movabs $0x800330,%r9
  803b13:	00 00 00 
  803b16:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803b19:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803b20:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803b27:	48 89 d6             	mov    %rdx,%rsi
  803b2a:	48 89 c7             	mov    %rax,%rdi
  803b2d:	48 b8 84 02 80 00 00 	movabs $0x800284,%rax
  803b34:	00 00 00 
  803b37:	ff d0                	callq  *%rax
	cprintf("\n");
  803b39:	48 bf d3 49 80 00 00 	movabs $0x8049d3,%rdi
  803b40:	00 00 00 
  803b43:	b8 00 00 00 00       	mov    $0x0,%eax
  803b48:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  803b4f:	00 00 00 
  803b52:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803b54:	cc                   	int3   
  803b55:	eb fd                	jmp    803b54 <_panic+0x111>

0000000000803b57 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b57:	55                   	push   %rbp
  803b58:	48 89 e5             	mov    %rsp,%rbp
  803b5b:	48 83 ec 10          	sub    $0x10,%rsp
  803b5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803b63:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b6a:	00 00 00 
  803b6d:	48 8b 00             	mov    (%rax),%rax
  803b70:	48 85 c0             	test   %rax,%rax
  803b73:	0f 85 84 00 00 00    	jne    803bfd <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803b79:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b80:	00 00 00 
  803b83:	48 8b 00             	mov    (%rax),%rax
  803b86:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803b8c:	ba 07 00 00 00       	mov    $0x7,%edx
  803b91:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b96:	89 c7                	mov    %eax,%edi
  803b98:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  803b9f:	00 00 00 
  803ba2:	ff d0                	callq  *%rax
  803ba4:	85 c0                	test   %eax,%eax
  803ba6:	79 2a                	jns    803bd2 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803ba8:	48 ba d8 49 80 00 00 	movabs $0x8049d8,%rdx
  803baf:	00 00 00 
  803bb2:	be 23 00 00 00       	mov    $0x23,%esi
  803bb7:	48 bf ff 49 80 00 00 	movabs $0x8049ff,%rdi
  803bbe:	00 00 00 
  803bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc6:	48 b9 43 3a 80 00 00 	movabs $0x803a43,%rcx
  803bcd:	00 00 00 
  803bd0:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803bd2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bd9:	00 00 00 
  803bdc:	48 8b 00             	mov    (%rax),%rax
  803bdf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803be5:	48 be 10 3c 80 00 00 	movabs $0x803c10,%rsi
  803bec:	00 00 00 
  803bef:	89 c7                	mov    %eax,%edi
  803bf1:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  803bf8:	00 00 00 
  803bfb:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803bfd:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803c04:	00 00 00 
  803c07:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c0b:	48 89 10             	mov    %rdx,(%rax)
}
  803c0e:	c9                   	leaveq 
  803c0f:	c3                   	retq   

0000000000803c10 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803c10:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803c13:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803c1a:	00 00 00 
call *%rax
  803c1d:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  803c1f:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803c26:	00 
movq 152(%rsp), %rcx  //Load RSP
  803c27:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803c2e:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  803c2f:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  803c33:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  803c36:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803c3d:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  803c3e:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  803c42:	4c 8b 3c 24          	mov    (%rsp),%r15
  803c46:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803c4b:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803c50:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803c55:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803c5a:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803c5f:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803c64:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803c69:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803c6e:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803c73:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803c78:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803c7d:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803c82:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803c87:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803c8c:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  803c90:	48 83 c4 08          	add    $0x8,%rsp
popfq
  803c94:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  803c95:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  803c96:	c3                   	retq   

0000000000803c97 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c97:	55                   	push   %rbp
  803c98:	48 89 e5             	mov    %rsp,%rbp
  803c9b:	48 83 ec 30          	sub    $0x30,%rsp
  803c9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ca3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ca7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803cab:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cb2:	00 00 00 
  803cb5:	48 8b 00             	mov    (%rax),%rax
  803cb8:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803cbe:	85 c0                	test   %eax,%eax
  803cc0:	75 34                	jne    803cf6 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803cc2:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  803cc9:	00 00 00 
  803ccc:	ff d0                	callq  *%rax
  803cce:	25 ff 03 00 00       	and    $0x3ff,%eax
  803cd3:	48 98                	cltq   
  803cd5:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803cdc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ce3:	00 00 00 
  803ce6:	48 01 c2             	add    %rax,%rdx
  803ce9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cf0:	00 00 00 
  803cf3:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803cf6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803cfb:	75 0e                	jne    803d0b <ipc_recv+0x74>
		pg = (void*) UTOP;
  803cfd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d04:	00 00 00 
  803d07:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803d0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d0f:	48 89 c7             	mov    %rax,%rdi
  803d12:	48 b8 3d 1a 80 00 00 	movabs $0x801a3d,%rax
  803d19:	00 00 00 
  803d1c:	ff d0                	callq  *%rax
  803d1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803d21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d25:	79 19                	jns    803d40 <ipc_recv+0xa9>
		*from_env_store = 0;
  803d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d2b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803d31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d35:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3e:	eb 53                	jmp    803d93 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803d40:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803d45:	74 19                	je     803d60 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803d47:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d4e:	00 00 00 
  803d51:	48 8b 00             	mov    (%rax),%rax
  803d54:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d5e:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803d60:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d65:	74 19                	je     803d80 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803d67:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d6e:	00 00 00 
  803d71:	48 8b 00             	mov    (%rax),%rax
  803d74:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803d7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d7e:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803d80:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d87:	00 00 00 
  803d8a:	48 8b 00             	mov    (%rax),%rax
  803d8d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803d93:	c9                   	leaveq 
  803d94:	c3                   	retq   

0000000000803d95 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d95:	55                   	push   %rbp
  803d96:	48 89 e5             	mov    %rsp,%rbp
  803d99:	48 83 ec 30          	sub    $0x30,%rsp
  803d9d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803da0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803da3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803da7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803daa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803daf:	75 0e                	jne    803dbf <ipc_send+0x2a>
		pg = (void*)UTOP;
  803db1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803db8:	00 00 00 
  803dbb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803dbf:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803dc2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803dc5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803dc9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dcc:	89 c7                	mov    %eax,%edi
  803dce:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  803dd5:	00 00 00 
  803dd8:	ff d0                	callq  *%rax
  803dda:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803ddd:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803de1:	75 0c                	jne    803def <ipc_send+0x5a>
			sys_yield();
  803de3:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  803dea:	00 00 00 
  803ded:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803def:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803df3:	74 ca                	je     803dbf <ipc_send+0x2a>
	if(result != 0)
  803df5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803df9:	74 20                	je     803e1b <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803dfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dfe:	89 c6                	mov    %eax,%esi
  803e00:	48 bf 10 4a 80 00 00 	movabs $0x804a10,%rdi
  803e07:	00 00 00 
  803e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0f:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  803e16:	00 00 00 
  803e19:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803e1b:	c9                   	leaveq 
  803e1c:	c3                   	retq   

0000000000803e1d <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803e1d:	55                   	push   %rbp
  803e1e:	48 89 e5             	mov    %rsp,%rbp
  803e21:	53                   	push   %rbx
  803e22:	48 83 ec 58          	sub    $0x58,%rsp
  803e26:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  803e2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  803e32:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803e39:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803e40:	00 
  803e41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e45:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803e49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e4d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803e51:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e55:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803e59:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803e5d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  803e61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e65:	48 c1 e8 27          	shr    $0x27,%rax
  803e69:	48 89 c2             	mov    %rax,%rdx
  803e6c:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803e73:	01 00 00 
  803e76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e7a:	83 e0 01             	and    $0x1,%eax
  803e7d:	48 85 c0             	test   %rax,%rax
  803e80:	0f 85 91 00 00 00    	jne    803f17 <ipc_host_recv+0xfa>
  803e86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e8a:	48 c1 e8 1e          	shr    $0x1e,%rax
  803e8e:	48 89 c2             	mov    %rax,%rdx
  803e91:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803e98:	01 00 00 
  803e9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e9f:	83 e0 01             	and    $0x1,%eax
  803ea2:	48 85 c0             	test   %rax,%rax
  803ea5:	74 70                	je     803f17 <ipc_host_recv+0xfa>
  803ea7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eab:	48 c1 e8 15          	shr    $0x15,%rax
  803eaf:	48 89 c2             	mov    %rax,%rdx
  803eb2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803eb9:	01 00 00 
  803ebc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ec0:	83 e0 01             	and    $0x1,%eax
  803ec3:	48 85 c0             	test   %rax,%rax
  803ec6:	74 4f                	je     803f17 <ipc_host_recv+0xfa>
  803ec8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ecc:	48 c1 e8 0c          	shr    $0xc,%rax
  803ed0:	48 89 c2             	mov    %rax,%rdx
  803ed3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803eda:	01 00 00 
  803edd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ee1:	83 e0 01             	and    $0x1,%eax
  803ee4:	48 85 c0             	test   %rax,%rax
  803ee7:	74 2e                	je     803f17 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eed:	ba 07 04 00 00       	mov    $0x407,%edx
  803ef2:	48 89 c6             	mov    %rax,%rsi
  803ef5:	bf 00 00 00 00       	mov    $0x0,%edi
  803efa:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  803f01:	00 00 00 
  803f04:	ff d0                	callq  *%rax
  803f06:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803f09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803f0d:	79 08                	jns    803f17 <ipc_host_recv+0xfa>
	    	return result;
  803f0f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f12:	e9 84 00 00 00       	jmpq   803f9b <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803f17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f1b:	48 c1 e8 0c          	shr    $0xc,%rax
  803f1f:	48 89 c2             	mov    %rax,%rdx
  803f22:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f29:	01 00 00 
  803f2c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f30:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803f36:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  803f3a:	b8 03 00 00 00       	mov    $0x3,%eax
  803f3f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803f43:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803f47:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  803f4b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803f4f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803f53:	4c 89 c3             	mov    %r8,%rbx
  803f56:	0f 01 c1             	vmcall 
  803f59:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  803f5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803f60:	7e 36                	jle    803f98 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  803f62:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f65:	41 89 c0             	mov    %eax,%r8d
  803f68:	b9 03 00 00 00       	mov    $0x3,%ecx
  803f6d:	48 ba 28 4a 80 00 00 	movabs $0x804a28,%rdx
  803f74:	00 00 00 
  803f77:	be 67 00 00 00       	mov    $0x67,%esi
  803f7c:	48 bf 55 4a 80 00 00 	movabs $0x804a55,%rdi
  803f83:	00 00 00 
  803f86:	b8 00 00 00 00       	mov    $0x0,%eax
  803f8b:	49 b9 43 3a 80 00 00 	movabs $0x803a43,%r9
  803f92:	00 00 00 
  803f95:	41 ff d1             	callq  *%r9
	return result;
  803f98:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  803f9b:	48 83 c4 58          	add    $0x58,%rsp
  803f9f:	5b                   	pop    %rbx
  803fa0:	5d                   	pop    %rbp
  803fa1:	c3                   	retq   

0000000000803fa2 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fa2:	55                   	push   %rbp
  803fa3:	48 89 e5             	mov    %rsp,%rbp
  803fa6:	53                   	push   %rbx
  803fa7:	48 83 ec 68          	sub    $0x68,%rsp
  803fab:	89 7d ac             	mov    %edi,-0x54(%rbp)
  803fae:	89 75 a8             	mov    %esi,-0x58(%rbp)
  803fb1:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  803fb5:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  803fb8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803fbc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  803fc0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803fc7:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803fce:	00 
  803fcf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803fd7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fdb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803fdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fe3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803fe7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803feb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  803fef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ff3:	48 c1 e8 27          	shr    $0x27,%rax
  803ff7:	48 89 c2             	mov    %rax,%rdx
  803ffa:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804001:	01 00 00 
  804004:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804008:	83 e0 01             	and    $0x1,%eax
  80400b:	48 85 c0             	test   %rax,%rax
  80400e:	0f 85 88 00 00 00    	jne    80409c <ipc_host_send+0xfa>
  804014:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804018:	48 c1 e8 1e          	shr    $0x1e,%rax
  80401c:	48 89 c2             	mov    %rax,%rdx
  80401f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804026:	01 00 00 
  804029:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80402d:	83 e0 01             	and    $0x1,%eax
  804030:	48 85 c0             	test   %rax,%rax
  804033:	74 67                	je     80409c <ipc_host_send+0xfa>
  804035:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804039:	48 c1 e8 15          	shr    $0x15,%rax
  80403d:	48 89 c2             	mov    %rax,%rdx
  804040:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804047:	01 00 00 
  80404a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80404e:	83 e0 01             	and    $0x1,%eax
  804051:	48 85 c0             	test   %rax,%rax
  804054:	74 46                	je     80409c <ipc_host_send+0xfa>
  804056:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80405a:	48 c1 e8 0c          	shr    $0xc,%rax
  80405e:	48 89 c2             	mov    %rax,%rdx
  804061:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804068:	01 00 00 
  80406b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80406f:	83 e0 01             	and    $0x1,%eax
  804072:	48 85 c0             	test   %rax,%rax
  804075:	74 25                	je     80409c <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  804077:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80407b:	48 c1 e8 0c          	shr    $0xc,%rax
  80407f:	48 89 c2             	mov    %rax,%rdx
  804082:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804089:	01 00 00 
  80408c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804090:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804096:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80409a:	eb 0e                	jmp    8040aa <ipc_host_send+0x108>
	else
		a3 = UTOP;
  80409c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8040a3:	00 00 00 
  8040a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  8040aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ae:	48 89 c6             	mov    %rax,%rsi
  8040b1:	48 bf 5f 4a 80 00 00 	movabs $0x804a5f,%rdi
  8040b8:	00 00 00 
  8040bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c0:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  8040c7:	00 00 00 
  8040ca:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  8040cc:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8040cf:	48 98                	cltq   
  8040d1:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  8040d5:	8b 45 a8             	mov    -0x58(%rbp),%eax
  8040d8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  8040dc:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8040df:	48 98                	cltq   
  8040e1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  8040e5:	b8 02 00 00 00       	mov    $0x2,%eax
  8040ea:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8040ee:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8040f2:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  8040f6:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8040fa:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8040fe:	4c 89 c3             	mov    %r8,%rbx
  804101:	0f 01 c1             	vmcall 
  804104:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  804107:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  80410b:	75 0c                	jne    804119 <ipc_host_send+0x177>
			sys_yield();
  80410d:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  804114:	00 00 00 
  804117:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  804119:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  80411d:	74 c6                	je     8040e5 <ipc_host_send+0x143>
	
	if(result !=0)
  80411f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  804123:	74 36                	je     80415b <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  804125:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804128:	41 89 c0             	mov    %eax,%r8d
  80412b:	b9 02 00 00 00       	mov    $0x2,%ecx
  804130:	48 ba 28 4a 80 00 00 	movabs $0x804a28,%rdx
  804137:	00 00 00 
  80413a:	be 94 00 00 00       	mov    $0x94,%esi
  80413f:	48 bf 55 4a 80 00 00 	movabs $0x804a55,%rdi
  804146:	00 00 00 
  804149:	b8 00 00 00 00       	mov    $0x0,%eax
  80414e:	49 b9 43 3a 80 00 00 	movabs $0x803a43,%r9
  804155:	00 00 00 
  804158:	41 ff d1             	callq  *%r9
}
  80415b:	48 83 c4 68          	add    $0x68,%rsp
  80415f:	5b                   	pop    %rbx
  804160:	5d                   	pop    %rbp
  804161:	c3                   	retq   

0000000000804162 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804162:	55                   	push   %rbp
  804163:	48 89 e5             	mov    %rsp,%rbp
  804166:	48 83 ec 14          	sub    $0x14,%rsp
  80416a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80416d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804174:	eb 4e                	jmp    8041c4 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804176:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80417d:	00 00 00 
  804180:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804183:	48 98                	cltq   
  804185:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80418c:	48 01 d0             	add    %rdx,%rax
  80418f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804195:	8b 00                	mov    (%rax),%eax
  804197:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80419a:	75 24                	jne    8041c0 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80419c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041a3:	00 00 00 
  8041a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041a9:	48 98                	cltq   
  8041ab:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8041b2:	48 01 d0             	add    %rdx,%rax
  8041b5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8041bb:	8b 40 08             	mov    0x8(%rax),%eax
  8041be:	eb 12                	jmp    8041d2 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8041c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8041c4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8041cb:	7e a9                	jle    804176 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8041cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041d2:	c9                   	leaveq 
  8041d3:	c3                   	retq   

00000000008041d4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8041d4:	55                   	push   %rbp
  8041d5:	48 89 e5             	mov    %rsp,%rbp
  8041d8:	48 83 ec 18          	sub    $0x18,%rsp
  8041dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8041e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041e4:	48 c1 e8 15          	shr    $0x15,%rax
  8041e8:	48 89 c2             	mov    %rax,%rdx
  8041eb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8041f2:	01 00 00 
  8041f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041f9:	83 e0 01             	and    $0x1,%eax
  8041fc:	48 85 c0             	test   %rax,%rax
  8041ff:	75 07                	jne    804208 <pageref+0x34>
		return 0;
  804201:	b8 00 00 00 00       	mov    $0x0,%eax
  804206:	eb 53                	jmp    80425b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80420c:	48 c1 e8 0c          	shr    $0xc,%rax
  804210:	48 89 c2             	mov    %rax,%rdx
  804213:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80421a:	01 00 00 
  80421d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804221:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804225:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804229:	83 e0 01             	and    $0x1,%eax
  80422c:	48 85 c0             	test   %rax,%rax
  80422f:	75 07                	jne    804238 <pageref+0x64>
		return 0;
  804231:	b8 00 00 00 00       	mov    $0x0,%eax
  804236:	eb 23                	jmp    80425b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80423c:	48 c1 e8 0c          	shr    $0xc,%rax
  804240:	48 89 c2             	mov    %rax,%rdx
  804243:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80424a:	00 00 00 
  80424d:	48 c1 e2 04          	shl    $0x4,%rdx
  804251:	48 01 d0             	add    %rdx,%rax
  804254:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804258:	0f b7 c0             	movzwl %ax,%eax
}
  80425b:	c9                   	leaveq 
  80425c:	c3                   	retq   
