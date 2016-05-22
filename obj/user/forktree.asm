
obj/user/forktree:     file format elf64-x86-64


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
  80007e:	48 ba 20 40 80 00 00 	movabs $0x804020,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 98 0d 80 00 00 	movabs $0x800d98,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
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
  8000f1:	48 bf 25 40 80 00 00 	movabs $0x804025,%rdi
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
  80014d:	48 bf 36 40 80 00 00 	movabs $0x804036,%rdi
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
  8001ec:	48 b8 35 26 80 00 00 	movabs $0x802635,%rax
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
  80049c:	48 ba 50 42 80 00 00 	movabs $0x804250,%rdx
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
  800794:	48 b8 78 42 80 00 00 	movabs $0x804278,%rax
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
  8008e7:	48 b8 a0 41 80 00 00 	movabs $0x8041a0,%rax
  8008ee:	00 00 00 
  8008f1:	48 63 d3             	movslq %ebx,%rdx
  8008f4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008f8:	4d 85 e4             	test   %r12,%r12
  8008fb:	75 2e                	jne    80092b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800901:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800905:	89 d9                	mov    %ebx,%ecx
  800907:	48 ba 61 42 80 00 00 	movabs $0x804261,%rdx
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
  800936:	48 ba 6a 42 80 00 00 	movabs $0x80426a,%rdx
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
  800990:	49 bc 6d 42 80 00 00 	movabs $0x80426d,%r12
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
  801696:	48 ba 28 45 80 00 00 	movabs $0x804528,%rdx
  80169d:	00 00 00 
  8016a0:	be 23 00 00 00       	mov    $0x23,%esi
  8016a5:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  8016ac:	00 00 00 
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	49 b9 41 3b 80 00 00 	movabs $0x803b41,%r9
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

0000000000801b64 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801b64:	55                   	push   %rbp
  801b65:	48 89 e5             	mov    %rsp,%rbp
  801b68:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801b6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b73:	00 
  801b74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b80:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b85:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8a:	be 00 00 00 00       	mov    $0x0,%esi
  801b8f:	bf 11 00 00 00       	mov    $0x11,%edi
  801b94:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801b9b:	00 00 00 
  801b9e:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801ba0:	c9                   	leaveq 
  801ba1:	c3                   	retq   

0000000000801ba2 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801ba2:	55                   	push   %rbp
  801ba3:	48 89 e5             	mov    %rsp,%rbp
  801ba6:	48 83 ec 10          	sub    $0x10,%rsp
  801baa:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801bad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb0:	48 98                	cltq   
  801bb2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb9:	00 
  801bba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bcb:	48 89 c2             	mov    %rax,%rdx
  801bce:	be 00 00 00 00       	mov    $0x0,%esi
  801bd3:	bf 12 00 00 00       	mov    $0x12,%edi
  801bd8:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801bdf:	00 00 00 
  801be2:	ff d0                	callq  *%rax
}
  801be4:	c9                   	leaveq 
  801be5:	c3                   	retq   

0000000000801be6 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801be6:	55                   	push   %rbp
  801be7:	48 89 e5             	mov    %rsp,%rbp
  801bea:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801bee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf5:	00 
  801bf6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c02:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c07:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0c:	be 00 00 00 00       	mov    $0x0,%esi
  801c11:	bf 13 00 00 00       	mov    $0x13,%edi
  801c16:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801c1d:	00 00 00 
  801c20:	ff d0                	callq  *%rax
}
  801c22:	c9                   	leaveq 
  801c23:	c3                   	retq   

0000000000801c24 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801c24:	55                   	push   %rbp
  801c25:	48 89 e5             	mov    %rsp,%rbp
  801c28:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801c2c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c33:	00 
  801c34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c40:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c45:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4a:	be 00 00 00 00       	mov    $0x0,%esi
  801c4f:	bf 14 00 00 00       	mov    $0x14,%edi
  801c54:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  801c5b:	00 00 00 
  801c5e:	ff d0                	callq  *%rax
}
  801c60:	c9                   	leaveq 
  801c61:	c3                   	retq   

0000000000801c62 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801c62:	55                   	push   %rbp
  801c63:	48 89 e5             	mov    %rsp,%rbp
  801c66:	48 83 ec 30          	sub    $0x30,%rsp
  801c6a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801c6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c72:	48 8b 00             	mov    (%rax),%rax
  801c75:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801c79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c81:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801c84:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c87:	83 e0 02             	and    $0x2,%eax
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	75 4d                	jne    801cdb <pgfault+0x79>
  801c8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c92:	48 c1 e8 0c          	shr    $0xc,%rax
  801c96:	48 89 c2             	mov    %rax,%rdx
  801c99:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ca0:	01 00 00 
  801ca3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ca7:	25 00 08 00 00       	and    $0x800,%eax
  801cac:	48 85 c0             	test   %rax,%rax
  801caf:	74 2a                	je     801cdb <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801cb1:	48 ba 58 45 80 00 00 	movabs $0x804558,%rdx
  801cb8:	00 00 00 
  801cbb:	be 23 00 00 00       	mov    $0x23,%esi
  801cc0:	48 bf 8d 45 80 00 00 	movabs $0x80458d,%rdi
  801cc7:	00 00 00 
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccf:	48 b9 41 3b 80 00 00 	movabs $0x803b41,%rcx
  801cd6:	00 00 00 
  801cd9:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801cdb:	ba 07 00 00 00       	mov    $0x7,%edx
  801ce0:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ce5:	bf 00 00 00 00       	mov    $0x0,%edi
  801cea:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  801cf1:	00 00 00 
  801cf4:	ff d0                	callq  *%rax
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	0f 85 cd 00 00 00    	jne    801dcb <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801cfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d0a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d10:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801d14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d18:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d1d:	48 89 c6             	mov    %rax,%rsi
  801d20:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d25:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  801d2c:	00 00 00 
  801d2f:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801d31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d35:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d3b:	48 89 c1             	mov    %rax,%rcx
  801d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d43:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d48:	bf 00 00 00 00       	mov    $0x0,%edi
  801d4d:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  801d54:	00 00 00 
  801d57:	ff d0                	callq  *%rax
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	79 2a                	jns    801d87 <pgfault+0x125>
				panic("Page map at temp address failed");
  801d5d:	48 ba 98 45 80 00 00 	movabs $0x804598,%rdx
  801d64:	00 00 00 
  801d67:	be 30 00 00 00       	mov    $0x30,%esi
  801d6c:	48 bf 8d 45 80 00 00 	movabs $0x80458d,%rdi
  801d73:	00 00 00 
  801d76:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7b:	48 b9 41 3b 80 00 00 	movabs $0x803b41,%rcx
  801d82:	00 00 00 
  801d85:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801d87:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d8c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d91:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801d98:	00 00 00 
  801d9b:	ff d0                	callq  *%rax
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	79 54                	jns    801df5 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801da1:	48 ba b8 45 80 00 00 	movabs $0x8045b8,%rdx
  801da8:	00 00 00 
  801dab:	be 32 00 00 00       	mov    $0x32,%esi
  801db0:	48 bf 8d 45 80 00 00 	movabs $0x80458d,%rdi
  801db7:	00 00 00 
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbf:	48 b9 41 3b 80 00 00 	movabs $0x803b41,%rcx
  801dc6:	00 00 00 
  801dc9:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801dcb:	48 ba e0 45 80 00 00 	movabs $0x8045e0,%rdx
  801dd2:	00 00 00 
  801dd5:	be 34 00 00 00       	mov    $0x34,%esi
  801dda:	48 bf 8d 45 80 00 00 	movabs $0x80458d,%rdi
  801de1:	00 00 00 
  801de4:	b8 00 00 00 00       	mov    $0x0,%eax
  801de9:	48 b9 41 3b 80 00 00 	movabs $0x803b41,%rcx
  801df0:	00 00 00 
  801df3:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801df5:	c9                   	leaveq 
  801df6:	c3                   	retq   

0000000000801df7 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801df7:	55                   	push   %rbp
  801df8:	48 89 e5             	mov    %rsp,%rbp
  801dfb:	48 83 ec 20          	sub    $0x20,%rsp
  801dff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e02:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801e05:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e0c:	01 00 00 
  801e0f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e12:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e16:	25 07 0e 00 00       	and    $0xe07,%eax
  801e1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801e1e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e21:	48 c1 e0 0c          	shl    $0xc,%rax
  801e25:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801e29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2c:	25 00 04 00 00       	and    $0x400,%eax
  801e31:	85 c0                	test   %eax,%eax
  801e33:	74 57                	je     801e8c <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e35:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e38:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e3c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e43:	41 89 f0             	mov    %esi,%r8d
  801e46:	48 89 c6             	mov    %rax,%rsi
  801e49:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4e:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  801e55:	00 00 00 
  801e58:	ff d0                	callq  *%rax
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	0f 8e 52 01 00 00    	jle    801fb4 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801e62:	48 ba 12 46 80 00 00 	movabs $0x804612,%rdx
  801e69:	00 00 00 
  801e6c:	be 4e 00 00 00       	mov    $0x4e,%esi
  801e71:	48 bf 8d 45 80 00 00 	movabs $0x80458d,%rdi
  801e78:	00 00 00 
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e80:	48 b9 41 3b 80 00 00 	movabs $0x803b41,%rcx
  801e87:	00 00 00 
  801e8a:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8f:	83 e0 02             	and    $0x2,%eax
  801e92:	85 c0                	test   %eax,%eax
  801e94:	75 10                	jne    801ea6 <duppage+0xaf>
  801e96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e99:	25 00 08 00 00       	and    $0x800,%eax
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	0f 84 bb 00 00 00    	je     801f61 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801ea6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea9:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801eae:	80 cc 08             	or     $0x8,%ah
  801eb1:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801eb4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801eb7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ebb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec2:	41 89 f0             	mov    %esi,%r8d
  801ec5:	48 89 c6             	mov    %rax,%rsi
  801ec8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ecd:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  801ed4:	00 00 00 
  801ed7:	ff d0                	callq  *%rax
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	7e 2a                	jle    801f07 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801edd:	48 ba 12 46 80 00 00 	movabs $0x804612,%rdx
  801ee4:	00 00 00 
  801ee7:	be 55 00 00 00       	mov    $0x55,%esi
  801eec:	48 bf 8d 45 80 00 00 	movabs $0x80458d,%rdi
  801ef3:	00 00 00 
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  801efb:	48 b9 41 3b 80 00 00 	movabs $0x803b41,%rcx
  801f02:	00 00 00 
  801f05:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f07:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f12:	41 89 c8             	mov    %ecx,%r8d
  801f15:	48 89 d1             	mov    %rdx,%rcx
  801f18:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1d:	48 89 c6             	mov    %rax,%rsi
  801f20:	bf 00 00 00 00       	mov    $0x0,%edi
  801f25:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  801f2c:	00 00 00 
  801f2f:	ff d0                	callq  *%rax
  801f31:	85 c0                	test   %eax,%eax
  801f33:	7e 2a                	jle    801f5f <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801f35:	48 ba 12 46 80 00 00 	movabs $0x804612,%rdx
  801f3c:	00 00 00 
  801f3f:	be 57 00 00 00       	mov    $0x57,%esi
  801f44:	48 bf 8d 45 80 00 00 	movabs $0x80458d,%rdi
  801f4b:	00 00 00 
  801f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f53:	48 b9 41 3b 80 00 00 	movabs $0x803b41,%rcx
  801f5a:	00 00 00 
  801f5d:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f5f:	eb 53                	jmp    801fb4 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f61:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f64:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f68:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f6f:	41 89 f0             	mov    %esi,%r8d
  801f72:	48 89 c6             	mov    %rax,%rsi
  801f75:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7a:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
  801f86:	85 c0                	test   %eax,%eax
  801f88:	7e 2a                	jle    801fb4 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801f8a:	48 ba 12 46 80 00 00 	movabs $0x804612,%rdx
  801f91:	00 00 00 
  801f94:	be 5b 00 00 00       	mov    $0x5b,%esi
  801f99:	48 bf 8d 45 80 00 00 	movabs $0x80458d,%rdi
  801fa0:	00 00 00 
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa8:	48 b9 41 3b 80 00 00 	movabs $0x803b41,%rcx
  801faf:	00 00 00 
  801fb2:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801fb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb9:	c9                   	leaveq 
  801fba:	c3                   	retq   

0000000000801fbb <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801fbb:	55                   	push   %rbp
  801fbc:	48 89 e5             	mov    %rsp,%rbp
  801fbf:	48 83 ec 18          	sub    $0x18,%rsp
  801fc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801fc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fcb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801fcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd3:	48 c1 e8 27          	shr    $0x27,%rax
  801fd7:	48 89 c2             	mov    %rax,%rdx
  801fda:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801fe1:	01 00 00 
  801fe4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe8:	83 e0 01             	and    $0x1,%eax
  801feb:	48 85 c0             	test   %rax,%rax
  801fee:	74 51                	je     802041 <pt_is_mapped+0x86>
  801ff0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ff4:	48 c1 e0 0c          	shl    $0xc,%rax
  801ff8:	48 c1 e8 1e          	shr    $0x1e,%rax
  801ffc:	48 89 c2             	mov    %rax,%rdx
  801fff:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802006:	01 00 00 
  802009:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80200d:	83 e0 01             	and    $0x1,%eax
  802010:	48 85 c0             	test   %rax,%rax
  802013:	74 2c                	je     802041 <pt_is_mapped+0x86>
  802015:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802019:	48 c1 e0 0c          	shl    $0xc,%rax
  80201d:	48 c1 e8 15          	shr    $0x15,%rax
  802021:	48 89 c2             	mov    %rax,%rdx
  802024:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80202b:	01 00 00 
  80202e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802032:	83 e0 01             	and    $0x1,%eax
  802035:	48 85 c0             	test   %rax,%rax
  802038:	74 07                	je     802041 <pt_is_mapped+0x86>
  80203a:	b8 01 00 00 00       	mov    $0x1,%eax
  80203f:	eb 05                	jmp    802046 <pt_is_mapped+0x8b>
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	83 e0 01             	and    $0x1,%eax
}
  802049:	c9                   	leaveq 
  80204a:	c3                   	retq   

000000000080204b <fork>:

envid_t
fork(void)
{
  80204b:	55                   	push   %rbp
  80204c:	48 89 e5             	mov    %rsp,%rbp
  80204f:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802053:	48 bf 62 1c 80 00 00 	movabs $0x801c62,%rdi
  80205a:	00 00 00 
  80205d:	48 b8 55 3c 80 00 00 	movabs $0x803c55,%rax
  802064:	00 00 00 
  802067:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802069:	b8 07 00 00 00       	mov    $0x7,%eax
  80206e:	cd 30                	int    $0x30
  802070:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802073:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802076:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802079:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80207d:	79 30                	jns    8020af <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80207f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802082:	89 c1                	mov    %eax,%ecx
  802084:	48 ba 30 46 80 00 00 	movabs $0x804630,%rdx
  80208b:	00 00 00 
  80208e:	be 86 00 00 00       	mov    $0x86,%esi
  802093:	48 bf 8d 45 80 00 00 	movabs $0x80458d,%rdi
  80209a:	00 00 00 
  80209d:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a2:	49 b8 41 3b 80 00 00 	movabs $0x803b41,%r8
  8020a9:	00 00 00 
  8020ac:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8020af:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020b3:	75 3e                	jne    8020f3 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8020b5:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  8020bc:	00 00 00 
  8020bf:	ff d0                	callq  *%rax
  8020c1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8020c6:	48 98                	cltq   
  8020c8:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8020cf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8020d6:	00 00 00 
  8020d9:	48 01 c2             	add    %rax,%rdx
  8020dc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020e3:	00 00 00 
  8020e6:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8020e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ee:	e9 d1 01 00 00       	jmpq   8022c4 <fork+0x279>
	}
	uint64_t ad = 0;
  8020f3:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8020fa:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8020fb:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802100:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802104:	e9 df 00 00 00       	jmpq   8021e8 <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802109:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80210d:	48 c1 e8 27          	shr    $0x27,%rax
  802111:	48 89 c2             	mov    %rax,%rdx
  802114:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80211b:	01 00 00 
  80211e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802122:	83 e0 01             	and    $0x1,%eax
  802125:	48 85 c0             	test   %rax,%rax
  802128:	0f 84 9e 00 00 00    	je     8021cc <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80212e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802132:	48 c1 e8 1e          	shr    $0x1e,%rax
  802136:	48 89 c2             	mov    %rax,%rdx
  802139:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802140:	01 00 00 
  802143:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802147:	83 e0 01             	and    $0x1,%eax
  80214a:	48 85 c0             	test   %rax,%rax
  80214d:	74 73                	je     8021c2 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  80214f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802153:	48 c1 e8 15          	shr    $0x15,%rax
  802157:	48 89 c2             	mov    %rax,%rdx
  80215a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802161:	01 00 00 
  802164:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802168:	83 e0 01             	and    $0x1,%eax
  80216b:	48 85 c0             	test   %rax,%rax
  80216e:	74 48                	je     8021b8 <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802174:	48 c1 e8 0c          	shr    $0xc,%rax
  802178:	48 89 c2             	mov    %rax,%rdx
  80217b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802182:	01 00 00 
  802185:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802189:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80218d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802191:	83 e0 01             	and    $0x1,%eax
  802194:	48 85 c0             	test   %rax,%rax
  802197:	74 47                	je     8021e0 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80219d:	48 c1 e8 0c          	shr    $0xc,%rax
  8021a1:	89 c2                	mov    %eax,%edx
  8021a3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021a6:	89 d6                	mov    %edx,%esi
  8021a8:	89 c7                	mov    %eax,%edi
  8021aa:	48 b8 f7 1d 80 00 00 	movabs $0x801df7,%rax
  8021b1:	00 00 00 
  8021b4:	ff d0                	callq  *%rax
  8021b6:	eb 28                	jmp    8021e0 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8021b8:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8021bf:	00 
  8021c0:	eb 1e                	jmp    8021e0 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8021c2:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8021c9:	40 
  8021ca:	eb 14                	jmp    8021e0 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8021cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d0:	48 c1 e8 27          	shr    $0x27,%rax
  8021d4:	48 83 c0 01          	add    $0x1,%rax
  8021d8:	48 c1 e0 27          	shl    $0x27,%rax
  8021dc:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8021e0:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8021e7:	00 
  8021e8:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8021ef:	00 
  8021f0:	0f 87 13 ff ff ff    	ja     802109 <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8021f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021f9:	ba 07 00 00 00       	mov    $0x7,%edx
  8021fe:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802203:	89 c7                	mov    %eax,%edi
  802205:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  80220c:	00 00 00 
  80220f:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802211:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802214:	ba 07 00 00 00       	mov    $0x7,%edx
  802219:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80221e:	89 c7                	mov    %eax,%edi
  802220:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  802227:	00 00 00 
  80222a:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80222c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80222f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802235:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80223a:	ba 00 00 00 00       	mov    $0x0,%edx
  80223f:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802244:	89 c7                	mov    %eax,%edi
  802246:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  80224d:	00 00 00 
  802250:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802252:	ba 00 10 00 00       	mov    $0x1000,%edx
  802257:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80225c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802261:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  802268:	00 00 00 
  80226b:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80226d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802272:	bf 00 00 00 00       	mov    $0x0,%edi
  802277:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  80227e:	00 00 00 
  802281:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802283:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80228a:	00 00 00 
  80228d:	48 8b 00             	mov    (%rax),%rax
  802290:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80229a:	48 89 d6             	mov    %rdx,%rsi
  80229d:	89 c7                	mov    %eax,%edi
  80229f:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  8022a6:	00 00 00 
  8022a9:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8022ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022ae:	be 02 00 00 00       	mov    $0x2,%esi
  8022b3:	89 c7                	mov    %eax,%edi
  8022b5:	48 b8 09 19 80 00 00 	movabs $0x801909,%rax
  8022bc:	00 00 00 
  8022bf:	ff d0                	callq  *%rax

	return envid;
  8022c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8022c4:	c9                   	leaveq 
  8022c5:	c3                   	retq   

00000000008022c6 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8022c6:	55                   	push   %rbp
  8022c7:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8022ca:	48 ba 48 46 80 00 00 	movabs $0x804648,%rdx
  8022d1:	00 00 00 
  8022d4:	be bf 00 00 00       	mov    $0xbf,%esi
  8022d9:	48 bf 8d 45 80 00 00 	movabs $0x80458d,%rdi
  8022e0:	00 00 00 
  8022e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e8:	48 b9 41 3b 80 00 00 	movabs $0x803b41,%rcx
  8022ef:	00 00 00 
  8022f2:	ff d1                	callq  *%rcx

00000000008022f4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8022f4:	55                   	push   %rbp
  8022f5:	48 89 e5             	mov    %rsp,%rbp
  8022f8:	48 83 ec 08          	sub    $0x8,%rsp
  8022fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802300:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802304:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80230b:	ff ff ff 
  80230e:	48 01 d0             	add    %rdx,%rax
  802311:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802315:	c9                   	leaveq 
  802316:	c3                   	retq   

0000000000802317 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802317:	55                   	push   %rbp
  802318:	48 89 e5             	mov    %rsp,%rbp
  80231b:	48 83 ec 08          	sub    $0x8,%rsp
  80231f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802327:	48 89 c7             	mov    %rax,%rdi
  80232a:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  802331:	00 00 00 
  802334:	ff d0                	callq  *%rax
  802336:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80233c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802340:	c9                   	leaveq 
  802341:	c3                   	retq   

0000000000802342 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802342:	55                   	push   %rbp
  802343:	48 89 e5             	mov    %rsp,%rbp
  802346:	48 83 ec 18          	sub    $0x18,%rsp
  80234a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80234e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802355:	eb 6b                	jmp    8023c2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802357:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235a:	48 98                	cltq   
  80235c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802362:	48 c1 e0 0c          	shl    $0xc,%rax
  802366:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80236a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80236e:	48 c1 e8 15          	shr    $0x15,%rax
  802372:	48 89 c2             	mov    %rax,%rdx
  802375:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80237c:	01 00 00 
  80237f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802383:	83 e0 01             	and    $0x1,%eax
  802386:	48 85 c0             	test   %rax,%rax
  802389:	74 21                	je     8023ac <fd_alloc+0x6a>
  80238b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238f:	48 c1 e8 0c          	shr    $0xc,%rax
  802393:	48 89 c2             	mov    %rax,%rdx
  802396:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80239d:	01 00 00 
  8023a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a4:	83 e0 01             	and    $0x1,%eax
  8023a7:	48 85 c0             	test   %rax,%rax
  8023aa:	75 12                	jne    8023be <fd_alloc+0x7c>
			*fd_store = fd;
  8023ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023b4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bc:	eb 1a                	jmp    8023d8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023be:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023c2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023c6:	7e 8f                	jle    802357 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8023c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023d3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023d8:	c9                   	leaveq 
  8023d9:	c3                   	retq   

00000000008023da <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023da:	55                   	push   %rbp
  8023db:	48 89 e5             	mov    %rsp,%rbp
  8023de:	48 83 ec 20          	sub    $0x20,%rsp
  8023e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023ed:	78 06                	js     8023f5 <fd_lookup+0x1b>
  8023ef:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8023f3:	7e 07                	jle    8023fc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023fa:	eb 6c                	jmp    802468 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8023fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ff:	48 98                	cltq   
  802401:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802407:	48 c1 e0 0c          	shl    $0xc,%rax
  80240b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80240f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802413:	48 c1 e8 15          	shr    $0x15,%rax
  802417:	48 89 c2             	mov    %rax,%rdx
  80241a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802421:	01 00 00 
  802424:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802428:	83 e0 01             	and    $0x1,%eax
  80242b:	48 85 c0             	test   %rax,%rax
  80242e:	74 21                	je     802451 <fd_lookup+0x77>
  802430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802434:	48 c1 e8 0c          	shr    $0xc,%rax
  802438:	48 89 c2             	mov    %rax,%rdx
  80243b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802442:	01 00 00 
  802445:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802449:	83 e0 01             	and    $0x1,%eax
  80244c:	48 85 c0             	test   %rax,%rax
  80244f:	75 07                	jne    802458 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802451:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802456:	eb 10                	jmp    802468 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802458:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80245c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802460:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802463:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802468:	c9                   	leaveq 
  802469:	c3                   	retq   

000000000080246a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80246a:	55                   	push   %rbp
  80246b:	48 89 e5             	mov    %rsp,%rbp
  80246e:	48 83 ec 30          	sub    $0x30,%rsp
  802472:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802476:	89 f0                	mov    %esi,%eax
  802478:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80247b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80247f:	48 89 c7             	mov    %rax,%rdi
  802482:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  802489:	00 00 00 
  80248c:	ff d0                	callq  *%rax
  80248e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802492:	48 89 d6             	mov    %rdx,%rsi
  802495:	89 c7                	mov    %eax,%edi
  802497:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  80249e:	00 00 00 
  8024a1:	ff d0                	callq  *%rax
  8024a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024aa:	78 0a                	js     8024b6 <fd_close+0x4c>
	    || fd != fd2)
  8024ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024b4:	74 12                	je     8024c8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024b6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024ba:	74 05                	je     8024c1 <fd_close+0x57>
  8024bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bf:	eb 05                	jmp    8024c6 <fd_close+0x5c>
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c6:	eb 69                	jmp    802531 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024cc:	8b 00                	mov    (%rax),%eax
  8024ce:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024d2:	48 89 d6             	mov    %rdx,%rsi
  8024d5:	89 c7                	mov    %eax,%edi
  8024d7:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  8024de:	00 00 00 
  8024e1:	ff d0                	callq  *%rax
  8024e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ea:	78 2a                	js     802516 <fd_close+0xac>
		if (dev->dev_close)
  8024ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024f4:	48 85 c0             	test   %rax,%rax
  8024f7:	74 16                	je     80250f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8024f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fd:	48 8b 40 20          	mov    0x20(%rax),%rax
  802501:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802505:	48 89 d7             	mov    %rdx,%rdi
  802508:	ff d0                	callq  *%rax
  80250a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250d:	eb 07                	jmp    802516 <fd_close+0xac>
		else
			r = 0;
  80250f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802516:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80251a:	48 89 c6             	mov    %rax,%rsi
  80251d:	bf 00 00 00 00       	mov    $0x0,%edi
  802522:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  802529:	00 00 00 
  80252c:	ff d0                	callq  *%rax
	return r;
  80252e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802531:	c9                   	leaveq 
  802532:	c3                   	retq   

0000000000802533 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802533:	55                   	push   %rbp
  802534:	48 89 e5             	mov    %rsp,%rbp
  802537:	48 83 ec 20          	sub    $0x20,%rsp
  80253b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80253e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802542:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802549:	eb 41                	jmp    80258c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80254b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802552:	00 00 00 
  802555:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802558:	48 63 d2             	movslq %edx,%rdx
  80255b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80255f:	8b 00                	mov    (%rax),%eax
  802561:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802564:	75 22                	jne    802588 <dev_lookup+0x55>
			*dev = devtab[i];
  802566:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80256d:	00 00 00 
  802570:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802573:	48 63 d2             	movslq %edx,%rdx
  802576:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80257a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80257e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
  802586:	eb 60                	jmp    8025e8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802588:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80258c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802593:	00 00 00 
  802596:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802599:	48 63 d2             	movslq %edx,%rdx
  80259c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a0:	48 85 c0             	test   %rax,%rax
  8025a3:	75 a6                	jne    80254b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025a5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025ac:	00 00 00 
  8025af:	48 8b 00             	mov    (%rax),%rax
  8025b2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025b8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025bb:	89 c6                	mov    %eax,%esi
  8025bd:	48 bf 60 46 80 00 00 	movabs $0x804660,%rdi
  8025c4:	00 00 00 
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cc:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  8025d3:	00 00 00 
  8025d6:	ff d1                	callq  *%rcx
	*dev = 0;
  8025d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025dc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025e8:	c9                   	leaveq 
  8025e9:	c3                   	retq   

00000000008025ea <close>:

int
close(int fdnum)
{
  8025ea:	55                   	push   %rbp
  8025eb:	48 89 e5             	mov    %rsp,%rbp
  8025ee:	48 83 ec 20          	sub    $0x20,%rsp
  8025f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025f5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025fc:	48 89 d6             	mov    %rdx,%rsi
  8025ff:	89 c7                	mov    %eax,%edi
  802601:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  802608:	00 00 00 
  80260b:	ff d0                	callq  *%rax
  80260d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802610:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802614:	79 05                	jns    80261b <close+0x31>
		return r;
  802616:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802619:	eb 18                	jmp    802633 <close+0x49>
	else
		return fd_close(fd, 1);
  80261b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261f:	be 01 00 00 00       	mov    $0x1,%esi
  802624:	48 89 c7             	mov    %rax,%rdi
  802627:	48 b8 6a 24 80 00 00 	movabs $0x80246a,%rax
  80262e:	00 00 00 
  802631:	ff d0                	callq  *%rax
}
  802633:	c9                   	leaveq 
  802634:	c3                   	retq   

0000000000802635 <close_all>:

void
close_all(void)
{
  802635:	55                   	push   %rbp
  802636:	48 89 e5             	mov    %rsp,%rbp
  802639:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80263d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802644:	eb 15                	jmp    80265b <close_all+0x26>
		close(i);
  802646:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802649:	89 c7                	mov    %eax,%edi
  80264b:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  802652:	00 00 00 
  802655:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802657:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80265b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80265f:	7e e5                	jle    802646 <close_all+0x11>
		close(i);
}
  802661:	c9                   	leaveq 
  802662:	c3                   	retq   

0000000000802663 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802663:	55                   	push   %rbp
  802664:	48 89 e5             	mov    %rsp,%rbp
  802667:	48 83 ec 40          	sub    $0x40,%rsp
  80266b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80266e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802671:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802675:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802678:	48 89 d6             	mov    %rdx,%rsi
  80267b:	89 c7                	mov    %eax,%edi
  80267d:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  802684:	00 00 00 
  802687:	ff d0                	callq  *%rax
  802689:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80268c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802690:	79 08                	jns    80269a <dup+0x37>
		return r;
  802692:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802695:	e9 70 01 00 00       	jmpq   80280a <dup+0x1a7>
	close(newfdnum);
  80269a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80269d:	89 c7                	mov    %eax,%edi
  80269f:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  8026a6:	00 00 00 
  8026a9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026ab:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026ae:	48 98                	cltq   
  8026b0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026b6:	48 c1 e0 0c          	shl    $0xc,%rax
  8026ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c2:	48 89 c7             	mov    %rax,%rdi
  8026c5:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  8026cc:	00 00 00 
  8026cf:	ff d0                	callq  *%rax
  8026d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d9:	48 89 c7             	mov    %rax,%rdi
  8026dc:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  8026e3:	00 00 00 
  8026e6:	ff d0                	callq  *%rax
  8026e8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f0:	48 c1 e8 15          	shr    $0x15,%rax
  8026f4:	48 89 c2             	mov    %rax,%rdx
  8026f7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026fe:	01 00 00 
  802701:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802705:	83 e0 01             	and    $0x1,%eax
  802708:	48 85 c0             	test   %rax,%rax
  80270b:	74 73                	je     802780 <dup+0x11d>
  80270d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802711:	48 c1 e8 0c          	shr    $0xc,%rax
  802715:	48 89 c2             	mov    %rax,%rdx
  802718:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80271f:	01 00 00 
  802722:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802726:	83 e0 01             	and    $0x1,%eax
  802729:	48 85 c0             	test   %rax,%rax
  80272c:	74 52                	je     802780 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80272e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802732:	48 c1 e8 0c          	shr    $0xc,%rax
  802736:	48 89 c2             	mov    %rax,%rdx
  802739:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802740:	01 00 00 
  802743:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802747:	25 07 0e 00 00       	and    $0xe07,%eax
  80274c:	89 c1                	mov    %eax,%ecx
  80274e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802756:	41 89 c8             	mov    %ecx,%r8d
  802759:	48 89 d1             	mov    %rdx,%rcx
  80275c:	ba 00 00 00 00       	mov    $0x0,%edx
  802761:	48 89 c6             	mov    %rax,%rsi
  802764:	bf 00 00 00 00       	mov    $0x0,%edi
  802769:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  802770:	00 00 00 
  802773:	ff d0                	callq  *%rax
  802775:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802778:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277c:	79 02                	jns    802780 <dup+0x11d>
			goto err;
  80277e:	eb 57                	jmp    8027d7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802784:	48 c1 e8 0c          	shr    $0xc,%rax
  802788:	48 89 c2             	mov    %rax,%rdx
  80278b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802792:	01 00 00 
  802795:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802799:	25 07 0e 00 00       	and    $0xe07,%eax
  80279e:	89 c1                	mov    %eax,%ecx
  8027a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027a8:	41 89 c8             	mov    %ecx,%r8d
  8027ab:	48 89 d1             	mov    %rdx,%rcx
  8027ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b3:	48 89 c6             	mov    %rax,%rsi
  8027b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8027bb:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  8027c2:	00 00 00 
  8027c5:	ff d0                	callq  *%rax
  8027c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ce:	79 02                	jns    8027d2 <dup+0x16f>
		goto err;
  8027d0:	eb 05                	jmp    8027d7 <dup+0x174>

	return newfdnum;
  8027d2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027d5:	eb 33                	jmp    80280a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027db:	48 89 c6             	mov    %rax,%rsi
  8027de:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e3:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  8027ea:	00 00 00 
  8027ed:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027f3:	48 89 c6             	mov    %rax,%rsi
  8027f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8027fb:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  802802:	00 00 00 
  802805:	ff d0                	callq  *%rax
	return r;
  802807:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80280a:	c9                   	leaveq 
  80280b:	c3                   	retq   

000000000080280c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80280c:	55                   	push   %rbp
  80280d:	48 89 e5             	mov    %rsp,%rbp
  802810:	48 83 ec 40          	sub    $0x40,%rsp
  802814:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802817:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80281b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80281f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802823:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802826:	48 89 d6             	mov    %rdx,%rsi
  802829:	89 c7                	mov    %eax,%edi
  80282b:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  802832:	00 00 00 
  802835:	ff d0                	callq  *%rax
  802837:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283e:	78 24                	js     802864 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802844:	8b 00                	mov    (%rax),%eax
  802846:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80284a:	48 89 d6             	mov    %rdx,%rsi
  80284d:	89 c7                	mov    %eax,%edi
  80284f:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  802856:	00 00 00 
  802859:	ff d0                	callq  *%rax
  80285b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802862:	79 05                	jns    802869 <read+0x5d>
		return r;
  802864:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802867:	eb 76                	jmp    8028df <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286d:	8b 40 08             	mov    0x8(%rax),%eax
  802870:	83 e0 03             	and    $0x3,%eax
  802873:	83 f8 01             	cmp    $0x1,%eax
  802876:	75 3a                	jne    8028b2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802878:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80287f:	00 00 00 
  802882:	48 8b 00             	mov    (%rax),%rax
  802885:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80288b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80288e:	89 c6                	mov    %eax,%esi
  802890:	48 bf 7f 46 80 00 00 	movabs $0x80467f,%rdi
  802897:	00 00 00 
  80289a:	b8 00 00 00 00       	mov    $0x0,%eax
  80289f:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  8028a6:	00 00 00 
  8028a9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028b0:	eb 2d                	jmp    8028df <read+0xd3>
	}
	if (!dev->dev_read)
  8028b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028ba:	48 85 c0             	test   %rax,%rax
  8028bd:	75 07                	jne    8028c6 <read+0xba>
		return -E_NOT_SUPP;
  8028bf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028c4:	eb 19                	jmp    8028df <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8028c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ca:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028ce:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028d2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028d6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028da:	48 89 cf             	mov    %rcx,%rdi
  8028dd:	ff d0                	callq  *%rax
}
  8028df:	c9                   	leaveq 
  8028e0:	c3                   	retq   

00000000008028e1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028e1:	55                   	push   %rbp
  8028e2:	48 89 e5             	mov    %rsp,%rbp
  8028e5:	48 83 ec 30          	sub    $0x30,%rsp
  8028e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028fb:	eb 49                	jmp    802946 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8028fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802900:	48 98                	cltq   
  802902:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802906:	48 29 c2             	sub    %rax,%rdx
  802909:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290c:	48 63 c8             	movslq %eax,%rcx
  80290f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802913:	48 01 c1             	add    %rax,%rcx
  802916:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802919:	48 89 ce             	mov    %rcx,%rsi
  80291c:	89 c7                	mov    %eax,%edi
  80291e:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  802925:	00 00 00 
  802928:	ff d0                	callq  *%rax
  80292a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80292d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802931:	79 05                	jns    802938 <readn+0x57>
			return m;
  802933:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802936:	eb 1c                	jmp    802954 <readn+0x73>
		if (m == 0)
  802938:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80293c:	75 02                	jne    802940 <readn+0x5f>
			break;
  80293e:	eb 11                	jmp    802951 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802940:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802943:	01 45 fc             	add    %eax,-0x4(%rbp)
  802946:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802949:	48 98                	cltq   
  80294b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80294f:	72 ac                	jb     8028fd <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802951:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802954:	c9                   	leaveq 
  802955:	c3                   	retq   

0000000000802956 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802956:	55                   	push   %rbp
  802957:	48 89 e5             	mov    %rsp,%rbp
  80295a:	48 83 ec 40          	sub    $0x40,%rsp
  80295e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802961:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802965:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802969:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80296d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802970:	48 89 d6             	mov    %rdx,%rsi
  802973:	89 c7                	mov    %eax,%edi
  802975:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  80297c:	00 00 00 
  80297f:	ff d0                	callq  *%rax
  802981:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802984:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802988:	78 24                	js     8029ae <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80298a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298e:	8b 00                	mov    (%rax),%eax
  802990:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802994:	48 89 d6             	mov    %rdx,%rsi
  802997:	89 c7                	mov    %eax,%edi
  802999:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  8029a0:	00 00 00 
  8029a3:	ff d0                	callq  *%rax
  8029a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ac:	79 05                	jns    8029b3 <write+0x5d>
		return r;
  8029ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b1:	eb 42                	jmp    8029f5 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b7:	8b 40 08             	mov    0x8(%rax),%eax
  8029ba:	83 e0 03             	and    $0x3,%eax
  8029bd:	85 c0                	test   %eax,%eax
  8029bf:	75 07                	jne    8029c8 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029c6:	eb 2d                	jmp    8029f5 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8029c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029cc:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029d0:	48 85 c0             	test   %rax,%rax
  8029d3:	75 07                	jne    8029dc <write+0x86>
		return -E_NOT_SUPP;
  8029d5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029da:	eb 19                	jmp    8029f5 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8029dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029e8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029ec:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029f0:	48 89 cf             	mov    %rcx,%rdi
  8029f3:	ff d0                	callq  *%rax
}
  8029f5:	c9                   	leaveq 
  8029f6:	c3                   	retq   

00000000008029f7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8029f7:	55                   	push   %rbp
  8029f8:	48 89 e5             	mov    %rsp,%rbp
  8029fb:	48 83 ec 18          	sub    $0x18,%rsp
  8029ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a02:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a05:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a0c:	48 89 d6             	mov    %rdx,%rsi
  802a0f:	89 c7                	mov    %eax,%edi
  802a11:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  802a18:	00 00 00 
  802a1b:	ff d0                	callq  *%rax
  802a1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a24:	79 05                	jns    802a2b <seek+0x34>
		return r;
  802a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a29:	eb 0f                	jmp    802a3a <seek+0x43>
	fd->fd_offset = offset;
  802a2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a32:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3a:	c9                   	leaveq 
  802a3b:	c3                   	retq   

0000000000802a3c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a3c:	55                   	push   %rbp
  802a3d:	48 89 e5             	mov    %rsp,%rbp
  802a40:	48 83 ec 30          	sub    $0x30,%rsp
  802a44:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a47:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a4a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a4e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a51:	48 89 d6             	mov    %rdx,%rsi
  802a54:	89 c7                	mov    %eax,%edi
  802a56:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  802a5d:	00 00 00 
  802a60:	ff d0                	callq  *%rax
  802a62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a69:	78 24                	js     802a8f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6f:	8b 00                	mov    (%rax),%eax
  802a71:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a75:	48 89 d6             	mov    %rdx,%rsi
  802a78:	89 c7                	mov    %eax,%edi
  802a7a:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  802a81:	00 00 00 
  802a84:	ff d0                	callq  *%rax
  802a86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8d:	79 05                	jns    802a94 <ftruncate+0x58>
		return r;
  802a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a92:	eb 72                	jmp    802b06 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a98:	8b 40 08             	mov    0x8(%rax),%eax
  802a9b:	83 e0 03             	and    $0x3,%eax
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	75 3a                	jne    802adc <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802aa2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802aa9:	00 00 00 
  802aac:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802aaf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ab5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ab8:	89 c6                	mov    %eax,%esi
  802aba:	48 bf a0 46 80 00 00 	movabs $0x8046a0,%rdi
  802ac1:	00 00 00 
  802ac4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac9:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  802ad0:	00 00 00 
  802ad3:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ad5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ada:	eb 2a                	jmp    802b06 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802adc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae0:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ae4:	48 85 c0             	test   %rax,%rax
  802ae7:	75 07                	jne    802af0 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802ae9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aee:	eb 16                	jmp    802b06 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802af0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af4:	48 8b 40 30          	mov    0x30(%rax),%rax
  802af8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802afc:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802aff:	89 ce                	mov    %ecx,%esi
  802b01:	48 89 d7             	mov    %rdx,%rdi
  802b04:	ff d0                	callq  *%rax
}
  802b06:	c9                   	leaveq 
  802b07:	c3                   	retq   

0000000000802b08 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b08:	55                   	push   %rbp
  802b09:	48 89 e5             	mov    %rsp,%rbp
  802b0c:	48 83 ec 30          	sub    $0x30,%rsp
  802b10:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b13:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b17:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b1b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b1e:	48 89 d6             	mov    %rdx,%rsi
  802b21:	89 c7                	mov    %eax,%edi
  802b23:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  802b2a:	00 00 00 
  802b2d:	ff d0                	callq  *%rax
  802b2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b36:	78 24                	js     802b5c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3c:	8b 00                	mov    (%rax),%eax
  802b3e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b42:	48 89 d6             	mov    %rdx,%rsi
  802b45:	89 c7                	mov    %eax,%edi
  802b47:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
  802b53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5a:	79 05                	jns    802b61 <fstat+0x59>
		return r;
  802b5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5f:	eb 5e                	jmp    802bbf <fstat+0xb7>
	if (!dev->dev_stat)
  802b61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b65:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b69:	48 85 c0             	test   %rax,%rax
  802b6c:	75 07                	jne    802b75 <fstat+0x6d>
		return -E_NOT_SUPP;
  802b6e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b73:	eb 4a                	jmp    802bbf <fstat+0xb7>
	stat->st_name[0] = 0;
  802b75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b79:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b80:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b87:	00 00 00 
	stat->st_isdir = 0;
  802b8a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b8e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b95:	00 00 00 
	stat->st_dev = dev;
  802b98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ba0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ba7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bab:	48 8b 40 28          	mov    0x28(%rax),%rax
  802baf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bb3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bb7:	48 89 ce             	mov    %rcx,%rsi
  802bba:	48 89 d7             	mov    %rdx,%rdi
  802bbd:	ff d0                	callq  *%rax
}
  802bbf:	c9                   	leaveq 
  802bc0:	c3                   	retq   

0000000000802bc1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802bc1:	55                   	push   %rbp
  802bc2:	48 89 e5             	mov    %rsp,%rbp
  802bc5:	48 83 ec 20          	sub    $0x20,%rsp
  802bc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802bd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd5:	be 00 00 00 00       	mov    $0x0,%esi
  802bda:	48 89 c7             	mov    %rax,%rdi
  802bdd:	48 b8 af 2c 80 00 00 	movabs $0x802caf,%rax
  802be4:	00 00 00 
  802be7:	ff d0                	callq  *%rax
  802be9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf0:	79 05                	jns    802bf7 <stat+0x36>
		return fd;
  802bf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf5:	eb 2f                	jmp    802c26 <stat+0x65>
	r = fstat(fd, stat);
  802bf7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bfe:	48 89 d6             	mov    %rdx,%rsi
  802c01:	89 c7                	mov    %eax,%edi
  802c03:	48 b8 08 2b 80 00 00 	movabs $0x802b08,%rax
  802c0a:	00 00 00 
  802c0d:	ff d0                	callq  *%rax
  802c0f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c15:	89 c7                	mov    %eax,%edi
  802c17:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
	return r;
  802c23:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c26:	c9                   	leaveq 
  802c27:	c3                   	retq   

0000000000802c28 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c28:	55                   	push   %rbp
  802c29:	48 89 e5             	mov    %rsp,%rbp
  802c2c:	48 83 ec 10          	sub    $0x10,%rsp
  802c30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c37:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c3e:	00 00 00 
  802c41:	8b 00                	mov    (%rax),%eax
  802c43:	85 c0                	test   %eax,%eax
  802c45:	75 1d                	jne    802c64 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c47:	bf 01 00 00 00       	mov    $0x1,%edi
  802c4c:	48 b8 1b 3f 80 00 00 	movabs $0x803f1b,%rax
  802c53:	00 00 00 
  802c56:	ff d0                	callq  *%rax
  802c58:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802c5f:	00 00 00 
  802c62:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c64:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c6b:	00 00 00 
  802c6e:	8b 00                	mov    (%rax),%eax
  802c70:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c73:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c78:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802c7f:	00 00 00 
  802c82:	89 c7                	mov    %eax,%edi
  802c84:	48 b8 93 3e 80 00 00 	movabs $0x803e93,%rax
  802c8b:	00 00 00 
  802c8e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c94:	ba 00 00 00 00       	mov    $0x0,%edx
  802c99:	48 89 c6             	mov    %rax,%rsi
  802c9c:	bf 00 00 00 00       	mov    $0x0,%edi
  802ca1:	48 b8 95 3d 80 00 00 	movabs $0x803d95,%rax
  802ca8:	00 00 00 
  802cab:	ff d0                	callq  *%rax
}
  802cad:	c9                   	leaveq 
  802cae:	c3                   	retq   

0000000000802caf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802caf:	55                   	push   %rbp
  802cb0:	48 89 e5             	mov    %rsp,%rbp
  802cb3:	48 83 ec 30          	sub    $0x30,%rsp
  802cb7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802cbb:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802cbe:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802cc5:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ccc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802cd3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802cd8:	75 08                	jne    802ce2 <open+0x33>
	{
		return r;
  802cda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdd:	e9 f2 00 00 00       	jmpq   802dd4 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802ce2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ce6:	48 89 c7             	mov    %rax,%rdi
  802ce9:	48 b8 79 0e 80 00 00 	movabs $0x800e79,%rax
  802cf0:	00 00 00 
  802cf3:	ff d0                	callq  *%rax
  802cf5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802cf8:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802cff:	7e 0a                	jle    802d0b <open+0x5c>
	{
		return -E_BAD_PATH;
  802d01:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d06:	e9 c9 00 00 00       	jmpq   802dd4 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802d0b:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802d12:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802d13:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802d17:	48 89 c7             	mov    %rax,%rdi
  802d1a:	48 b8 42 23 80 00 00 	movabs $0x802342,%rax
  802d21:	00 00 00 
  802d24:	ff d0                	callq  *%rax
  802d26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2d:	78 09                	js     802d38 <open+0x89>
  802d2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d33:	48 85 c0             	test   %rax,%rax
  802d36:	75 08                	jne    802d40 <open+0x91>
		{
			return r;
  802d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3b:	e9 94 00 00 00       	jmpq   802dd4 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802d40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d44:	ba 00 04 00 00       	mov    $0x400,%edx
  802d49:	48 89 c6             	mov    %rax,%rsi
  802d4c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d53:	00 00 00 
  802d56:	48 b8 77 0f 80 00 00 	movabs $0x800f77,%rax
  802d5d:	00 00 00 
  802d60:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802d62:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d69:	00 00 00 
  802d6c:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802d6f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802d75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d79:	48 89 c6             	mov    %rax,%rsi
  802d7c:	bf 01 00 00 00       	mov    $0x1,%edi
  802d81:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  802d88:	00 00 00 
  802d8b:	ff d0                	callq  *%rax
  802d8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d94:	79 2b                	jns    802dc1 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802d96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9a:	be 00 00 00 00       	mov    $0x0,%esi
  802d9f:	48 89 c7             	mov    %rax,%rdi
  802da2:	48 b8 6a 24 80 00 00 	movabs $0x80246a,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	callq  *%rax
  802dae:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802db1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802db5:	79 05                	jns    802dbc <open+0x10d>
			{
				return d;
  802db7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dba:	eb 18                	jmp    802dd4 <open+0x125>
			}
			return r;
  802dbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbf:	eb 13                	jmp    802dd4 <open+0x125>
		}	
		return fd2num(fd_store);
  802dc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc5:	48 89 c7             	mov    %rax,%rdi
  802dc8:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  802dcf:	00 00 00 
  802dd2:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802dd4:	c9                   	leaveq 
  802dd5:	c3                   	retq   

0000000000802dd6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802dd6:	55                   	push   %rbp
  802dd7:	48 89 e5             	mov    %rsp,%rbp
  802dda:	48 83 ec 10          	sub    $0x10,%rsp
  802dde:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802de2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de6:	8b 50 0c             	mov    0xc(%rax),%edx
  802de9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802df0:	00 00 00 
  802df3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802df5:	be 00 00 00 00       	mov    $0x0,%esi
  802dfa:	bf 06 00 00 00       	mov    $0x6,%edi
  802dff:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  802e06:	00 00 00 
  802e09:	ff d0                	callq  *%rax
}
  802e0b:	c9                   	leaveq 
  802e0c:	c3                   	retq   

0000000000802e0d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e0d:	55                   	push   %rbp
  802e0e:	48 89 e5             	mov    %rsp,%rbp
  802e11:	48 83 ec 30          	sub    $0x30,%rsp
  802e15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e19:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e1d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802e21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802e28:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e2d:	74 07                	je     802e36 <devfile_read+0x29>
  802e2f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802e34:	75 07                	jne    802e3d <devfile_read+0x30>
		return -E_INVAL;
  802e36:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e3b:	eb 77                	jmp    802eb4 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e41:	8b 50 0c             	mov    0xc(%rax),%edx
  802e44:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e4b:	00 00 00 
  802e4e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e50:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e57:	00 00 00 
  802e5a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e5e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802e62:	be 00 00 00 00       	mov    $0x0,%esi
  802e67:	bf 03 00 00 00       	mov    $0x3,%edi
  802e6c:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
  802e78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7f:	7f 05                	jg     802e86 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802e81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e84:	eb 2e                	jmp    802eb4 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802e86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e89:	48 63 d0             	movslq %eax,%rdx
  802e8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e90:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e97:	00 00 00 
  802e9a:	48 89 c7             	mov    %rax,%rdi
  802e9d:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  802ea4:	00 00 00 
  802ea7:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802ea9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ead:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802eb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802eb4:	c9                   	leaveq 
  802eb5:	c3                   	retq   

0000000000802eb6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802eb6:	55                   	push   %rbp
  802eb7:	48 89 e5             	mov    %rsp,%rbp
  802eba:	48 83 ec 30          	sub    $0x30,%rsp
  802ebe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ec2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ec6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802eca:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802ed1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ed6:	74 07                	je     802edf <devfile_write+0x29>
  802ed8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802edd:	75 08                	jne    802ee7 <devfile_write+0x31>
		return r;
  802edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee2:	e9 9a 00 00 00       	jmpq   802f81 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ee7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eeb:	8b 50 0c             	mov    0xc(%rax),%edx
  802eee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ef5:	00 00 00 
  802ef8:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802efa:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f01:	00 
  802f02:	76 08                	jbe    802f0c <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802f04:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802f0b:	00 
	}
	fsipcbuf.write.req_n = n;
  802f0c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f13:	00 00 00 
  802f16:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f1a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802f1e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f26:	48 89 c6             	mov    %rax,%rsi
  802f29:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802f30:	00 00 00 
  802f33:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  802f3a:	00 00 00 
  802f3d:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802f3f:	be 00 00 00 00       	mov    $0x0,%esi
  802f44:	bf 04 00 00 00       	mov    $0x4,%edi
  802f49:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  802f50:	00 00 00 
  802f53:	ff d0                	callq  *%rax
  802f55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5c:	7f 20                	jg     802f7e <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802f5e:	48 bf c6 46 80 00 00 	movabs $0x8046c6,%rdi
  802f65:	00 00 00 
  802f68:	b8 00 00 00 00       	mov    $0x0,%eax
  802f6d:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  802f74:	00 00 00 
  802f77:	ff d2                	callq  *%rdx
		return r;
  802f79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7c:	eb 03                	jmp    802f81 <devfile_write+0xcb>
	}
	return r;
  802f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802f81:	c9                   	leaveq 
  802f82:	c3                   	retq   

0000000000802f83 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f83:	55                   	push   %rbp
  802f84:	48 89 e5             	mov    %rsp,%rbp
  802f87:	48 83 ec 20          	sub    $0x20,%rsp
  802f8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f97:	8b 50 0c             	mov    0xc(%rax),%edx
  802f9a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fa1:	00 00 00 
  802fa4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802fa6:	be 00 00 00 00       	mov    $0x0,%esi
  802fab:	bf 05 00 00 00       	mov    $0x5,%edi
  802fb0:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  802fb7:	00 00 00 
  802fba:	ff d0                	callq  *%rax
  802fbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc3:	79 05                	jns    802fca <devfile_stat+0x47>
		return r;
  802fc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc8:	eb 56                	jmp    803020 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802fca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fce:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802fd5:	00 00 00 
  802fd8:	48 89 c7             	mov    %rax,%rdi
  802fdb:	48 b8 e5 0e 80 00 00 	movabs $0x800ee5,%rax
  802fe2:	00 00 00 
  802fe5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802fe7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fee:	00 00 00 
  802ff1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ff7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ffb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803001:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803008:	00 00 00 
  80300b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803011:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803015:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80301b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803020:	c9                   	leaveq 
  803021:	c3                   	retq   

0000000000803022 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803022:	55                   	push   %rbp
  803023:	48 89 e5             	mov    %rsp,%rbp
  803026:	48 83 ec 10          	sub    $0x10,%rsp
  80302a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80302e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803031:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803035:	8b 50 0c             	mov    0xc(%rax),%edx
  803038:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80303f:	00 00 00 
  803042:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803044:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80304b:	00 00 00 
  80304e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803051:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803054:	be 00 00 00 00       	mov    $0x0,%esi
  803059:	bf 02 00 00 00       	mov    $0x2,%edi
  80305e:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  803065:	00 00 00 
  803068:	ff d0                	callq  *%rax
}
  80306a:	c9                   	leaveq 
  80306b:	c3                   	retq   

000000000080306c <remove>:

// Delete a file
int
remove(const char *path)
{
  80306c:	55                   	push   %rbp
  80306d:	48 89 e5             	mov    %rsp,%rbp
  803070:	48 83 ec 10          	sub    $0x10,%rsp
  803074:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80307c:	48 89 c7             	mov    %rax,%rdi
  80307f:	48 b8 79 0e 80 00 00 	movabs $0x800e79,%rax
  803086:	00 00 00 
  803089:	ff d0                	callq  *%rax
  80308b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803090:	7e 07                	jle    803099 <remove+0x2d>
		return -E_BAD_PATH;
  803092:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803097:	eb 33                	jmp    8030cc <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803099:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80309d:	48 89 c6             	mov    %rax,%rsi
  8030a0:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8030a7:	00 00 00 
  8030aa:	48 b8 e5 0e 80 00 00 	movabs $0x800ee5,%rax
  8030b1:	00 00 00 
  8030b4:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8030b6:	be 00 00 00 00       	mov    $0x0,%esi
  8030bb:	bf 07 00 00 00       	mov    $0x7,%edi
  8030c0:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
}
  8030cc:	c9                   	leaveq 
  8030cd:	c3                   	retq   

00000000008030ce <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8030ce:	55                   	push   %rbp
  8030cf:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8030d2:	be 00 00 00 00       	mov    $0x0,%esi
  8030d7:	bf 08 00 00 00       	mov    $0x8,%edi
  8030dc:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  8030e3:	00 00 00 
  8030e6:	ff d0                	callq  *%rax
}
  8030e8:	5d                   	pop    %rbp
  8030e9:	c3                   	retq   

00000000008030ea <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8030ea:	55                   	push   %rbp
  8030eb:	48 89 e5             	mov    %rsp,%rbp
  8030ee:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8030f5:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8030fc:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803103:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80310a:	be 00 00 00 00       	mov    $0x0,%esi
  80310f:	48 89 c7             	mov    %rax,%rdi
  803112:	48 b8 af 2c 80 00 00 	movabs $0x802caf,%rax
  803119:	00 00 00 
  80311c:	ff d0                	callq  *%rax
  80311e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803121:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803125:	79 28                	jns    80314f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803127:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312a:	89 c6                	mov    %eax,%esi
  80312c:	48 bf e2 46 80 00 00 	movabs $0x8046e2,%rdi
  803133:	00 00 00 
  803136:	b8 00 00 00 00       	mov    $0x0,%eax
  80313b:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  803142:	00 00 00 
  803145:	ff d2                	callq  *%rdx
		return fd_src;
  803147:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314a:	e9 74 01 00 00       	jmpq   8032c3 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80314f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803156:	be 01 01 00 00       	mov    $0x101,%esi
  80315b:	48 89 c7             	mov    %rax,%rdi
  80315e:	48 b8 af 2c 80 00 00 	movabs $0x802caf,%rax
  803165:	00 00 00 
  803168:	ff d0                	callq  *%rax
  80316a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80316d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803171:	79 39                	jns    8031ac <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803173:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803176:	89 c6                	mov    %eax,%esi
  803178:	48 bf f8 46 80 00 00 	movabs $0x8046f8,%rdi
  80317f:	00 00 00 
  803182:	b8 00 00 00 00       	mov    $0x0,%eax
  803187:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  80318e:	00 00 00 
  803191:	ff d2                	callq  *%rdx
		close(fd_src);
  803193:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803196:	89 c7                	mov    %eax,%edi
  803198:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  80319f:	00 00 00 
  8031a2:	ff d0                	callq  *%rax
		return fd_dest;
  8031a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031a7:	e9 17 01 00 00       	jmpq   8032c3 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031ac:	eb 74                	jmp    803222 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8031ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031b1:	48 63 d0             	movslq %eax,%rdx
  8031b4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031be:	48 89 ce             	mov    %rcx,%rsi
  8031c1:	89 c7                	mov    %eax,%edi
  8031c3:	48 b8 56 29 80 00 00 	movabs $0x802956,%rax
  8031ca:	00 00 00 
  8031cd:	ff d0                	callq  *%rax
  8031cf:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8031d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8031d6:	79 4a                	jns    803222 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8031d8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031db:	89 c6                	mov    %eax,%esi
  8031dd:	48 bf 12 47 80 00 00 	movabs $0x804712,%rdi
  8031e4:	00 00 00 
  8031e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ec:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  8031f3:	00 00 00 
  8031f6:	ff d2                	callq  *%rdx
			close(fd_src);
  8031f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fb:	89 c7                	mov    %eax,%edi
  8031fd:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  803204:	00 00 00 
  803207:	ff d0                	callq  *%rax
			close(fd_dest);
  803209:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80320c:	89 c7                	mov    %eax,%edi
  80320e:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  803215:	00 00 00 
  803218:	ff d0                	callq  *%rax
			return write_size;
  80321a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80321d:	e9 a1 00 00 00       	jmpq   8032c3 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803222:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803229:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322c:	ba 00 02 00 00       	mov    $0x200,%edx
  803231:	48 89 ce             	mov    %rcx,%rsi
  803234:	89 c7                	mov    %eax,%edi
  803236:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  80323d:	00 00 00 
  803240:	ff d0                	callq  *%rax
  803242:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803245:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803249:	0f 8f 5f ff ff ff    	jg     8031ae <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80324f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803253:	79 47                	jns    80329c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803255:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803258:	89 c6                	mov    %eax,%esi
  80325a:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  803261:	00 00 00 
  803264:	b8 00 00 00 00       	mov    $0x0,%eax
  803269:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  803270:	00 00 00 
  803273:	ff d2                	callq  *%rdx
		close(fd_src);
  803275:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803278:	89 c7                	mov    %eax,%edi
  80327a:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  803281:	00 00 00 
  803284:	ff d0                	callq  *%rax
		close(fd_dest);
  803286:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803289:	89 c7                	mov    %eax,%edi
  80328b:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  803292:	00 00 00 
  803295:	ff d0                	callq  *%rax
		return read_size;
  803297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80329a:	eb 27                	jmp    8032c3 <copy+0x1d9>
	}
	close(fd_src);
  80329c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329f:	89 c7                	mov    %eax,%edi
  8032a1:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax
	close(fd_dest);
  8032ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032b0:	89 c7                	mov    %eax,%edi
  8032b2:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
	return 0;
  8032be:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8032c3:	c9                   	leaveq 
  8032c4:	c3                   	retq   

00000000008032c5 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8032c5:	55                   	push   %rbp
  8032c6:	48 89 e5             	mov    %rsp,%rbp
  8032c9:	53                   	push   %rbx
  8032ca:	48 83 ec 38          	sub    $0x38,%rsp
  8032ce:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8032d2:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8032d6:	48 89 c7             	mov    %rax,%rdi
  8032d9:	48 b8 42 23 80 00 00 	movabs $0x802342,%rax
  8032e0:	00 00 00 
  8032e3:	ff d0                	callq  *%rax
  8032e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ec:	0f 88 bf 01 00 00    	js     8034b1 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f6:	ba 07 04 00 00       	mov    $0x407,%edx
  8032fb:	48 89 c6             	mov    %rax,%rsi
  8032fe:	bf 00 00 00 00       	mov    $0x0,%edi
  803303:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  80330a:	00 00 00 
  80330d:	ff d0                	callq  *%rax
  80330f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803312:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803316:	0f 88 95 01 00 00    	js     8034b1 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80331c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803320:	48 89 c7             	mov    %rax,%rdi
  803323:	48 b8 42 23 80 00 00 	movabs $0x802342,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
  80332f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803332:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803336:	0f 88 5d 01 00 00    	js     803499 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80333c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803340:	ba 07 04 00 00       	mov    $0x407,%edx
  803345:	48 89 c6             	mov    %rax,%rsi
  803348:	bf 00 00 00 00       	mov    $0x0,%edi
  80334d:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  803354:	00 00 00 
  803357:	ff d0                	callq  *%rax
  803359:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80335c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803360:	0f 88 33 01 00 00    	js     803499 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336a:	48 89 c7             	mov    %rax,%rdi
  80336d:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  803374:	00 00 00 
  803377:	ff d0                	callq  *%rax
  803379:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80337d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803381:	ba 07 04 00 00       	mov    $0x407,%edx
  803386:	48 89 c6             	mov    %rax,%rsi
  803389:	bf 00 00 00 00       	mov    $0x0,%edi
  80338e:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  803395:	00 00 00 
  803398:	ff d0                	callq  *%rax
  80339a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80339d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033a1:	79 05                	jns    8033a8 <pipe+0xe3>
		goto err2;
  8033a3:	e9 d9 00 00 00       	jmpq   803481 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ac:	48 89 c7             	mov    %rax,%rdi
  8033af:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  8033b6:	00 00 00 
  8033b9:	ff d0                	callq  *%rax
  8033bb:	48 89 c2             	mov    %rax,%rdx
  8033be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033c2:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8033c8:	48 89 d1             	mov    %rdx,%rcx
  8033cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8033d0:	48 89 c6             	mov    %rax,%rsi
  8033d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d8:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  8033df:	00 00 00 
  8033e2:	ff d0                	callq  *%rax
  8033e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033eb:	79 1b                	jns    803408 <pipe+0x143>
		goto err3;
  8033ed:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8033ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f2:	48 89 c6             	mov    %rax,%rsi
  8033f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8033fa:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  803401:	00 00 00 
  803404:	ff d0                	callq  *%rax
  803406:	eb 79                	jmp    803481 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803413:	00 00 00 
  803416:	8b 12                	mov    (%rdx),%edx
  803418:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80341a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80341e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803425:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803429:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803430:	00 00 00 
  803433:	8b 12                	mov    (%rdx),%edx
  803435:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803437:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80343b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803442:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803446:	48 89 c7             	mov    %rax,%rdi
  803449:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  803450:	00 00 00 
  803453:	ff d0                	callq  *%rax
  803455:	89 c2                	mov    %eax,%edx
  803457:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80345b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80345d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803461:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803465:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803469:	48 89 c7             	mov    %rax,%rdi
  80346c:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  803473:	00 00 00 
  803476:	ff d0                	callq  *%rax
  803478:	89 03                	mov    %eax,(%rbx)
	return 0;
  80347a:	b8 00 00 00 00       	mov    $0x0,%eax
  80347f:	eb 33                	jmp    8034b4 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803481:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803485:	48 89 c6             	mov    %rax,%rsi
  803488:	bf 00 00 00 00       	mov    $0x0,%edi
  80348d:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  803494:	00 00 00 
  803497:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803499:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80349d:	48 89 c6             	mov    %rax,%rsi
  8034a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a5:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  8034ac:	00 00 00 
  8034af:	ff d0                	callq  *%rax
err:
	return r;
  8034b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8034b4:	48 83 c4 38          	add    $0x38,%rsp
  8034b8:	5b                   	pop    %rbx
  8034b9:	5d                   	pop    %rbp
  8034ba:	c3                   	retq   

00000000008034bb <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8034bb:	55                   	push   %rbp
  8034bc:	48 89 e5             	mov    %rsp,%rbp
  8034bf:	53                   	push   %rbx
  8034c0:	48 83 ec 28          	sub    $0x28,%rsp
  8034c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8034cc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034d3:	00 00 00 
  8034d6:	48 8b 00             	mov    (%rax),%rax
  8034d9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034df:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8034e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e6:	48 89 c7             	mov    %rax,%rdi
  8034e9:	48 b8 8d 3f 80 00 00 	movabs $0x803f8d,%rax
  8034f0:	00 00 00 
  8034f3:	ff d0                	callq  *%rax
  8034f5:	89 c3                	mov    %eax,%ebx
  8034f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034fb:	48 89 c7             	mov    %rax,%rdi
  8034fe:	48 b8 8d 3f 80 00 00 	movabs $0x803f8d,%rax
  803505:	00 00 00 
  803508:	ff d0                	callq  *%rax
  80350a:	39 c3                	cmp    %eax,%ebx
  80350c:	0f 94 c0             	sete   %al
  80350f:	0f b6 c0             	movzbl %al,%eax
  803512:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803515:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80351c:	00 00 00 
  80351f:	48 8b 00             	mov    (%rax),%rax
  803522:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803528:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80352b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80352e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803531:	75 05                	jne    803538 <_pipeisclosed+0x7d>
			return ret;
  803533:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803536:	eb 4f                	jmp    803587 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803538:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80353b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80353e:	74 42                	je     803582 <_pipeisclosed+0xc7>
  803540:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803544:	75 3c                	jne    803582 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803546:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80354d:	00 00 00 
  803550:	48 8b 00             	mov    (%rax),%rax
  803553:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803559:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80355c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80355f:	89 c6                	mov    %eax,%esi
  803561:	48 bf 45 47 80 00 00 	movabs $0x804745,%rdi
  803568:	00 00 00 
  80356b:	b8 00 00 00 00       	mov    $0x0,%eax
  803570:	49 b8 30 03 80 00 00 	movabs $0x800330,%r8
  803577:	00 00 00 
  80357a:	41 ff d0             	callq  *%r8
	}
  80357d:	e9 4a ff ff ff       	jmpq   8034cc <_pipeisclosed+0x11>
  803582:	e9 45 ff ff ff       	jmpq   8034cc <_pipeisclosed+0x11>
}
  803587:	48 83 c4 28          	add    $0x28,%rsp
  80358b:	5b                   	pop    %rbx
  80358c:	5d                   	pop    %rbp
  80358d:	c3                   	retq   

000000000080358e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80358e:	55                   	push   %rbp
  80358f:	48 89 e5             	mov    %rsp,%rbp
  803592:	48 83 ec 30          	sub    $0x30,%rsp
  803596:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803599:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80359d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035a0:	48 89 d6             	mov    %rdx,%rsi
  8035a3:	89 c7                	mov    %eax,%edi
  8035a5:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  8035ac:	00 00 00 
  8035af:	ff d0                	callq  *%rax
  8035b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b8:	79 05                	jns    8035bf <pipeisclosed+0x31>
		return r;
  8035ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035bd:	eb 31                	jmp    8035f0 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8035bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c3:	48 89 c7             	mov    %rax,%rdi
  8035c6:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  8035cd:	00 00 00 
  8035d0:	ff d0                	callq  *%rax
  8035d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8035d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035de:	48 89 d6             	mov    %rdx,%rsi
  8035e1:	48 89 c7             	mov    %rax,%rdi
  8035e4:	48 b8 bb 34 80 00 00 	movabs $0x8034bb,%rax
  8035eb:	00 00 00 
  8035ee:	ff d0                	callq  *%rax
}
  8035f0:	c9                   	leaveq 
  8035f1:	c3                   	retq   

00000000008035f2 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035f2:	55                   	push   %rbp
  8035f3:	48 89 e5             	mov    %rsp,%rbp
  8035f6:	48 83 ec 40          	sub    $0x40,%rsp
  8035fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803602:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803606:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80360a:	48 89 c7             	mov    %rax,%rdi
  80360d:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  803614:	00 00 00 
  803617:	ff d0                	callq  *%rax
  803619:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80361d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803621:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803625:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80362c:	00 
  80362d:	e9 92 00 00 00       	jmpq   8036c4 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803632:	eb 41                	jmp    803675 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803634:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803639:	74 09                	je     803644 <devpipe_read+0x52>
				return i;
  80363b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80363f:	e9 92 00 00 00       	jmpq   8036d6 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803644:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80364c:	48 89 d6             	mov    %rdx,%rsi
  80364f:	48 89 c7             	mov    %rax,%rdi
  803652:	48 b8 bb 34 80 00 00 	movabs $0x8034bb,%rax
  803659:	00 00 00 
  80365c:	ff d0                	callq  *%rax
  80365e:	85 c0                	test   %eax,%eax
  803660:	74 07                	je     803669 <devpipe_read+0x77>
				return 0;
  803662:	b8 00 00 00 00       	mov    $0x0,%eax
  803667:	eb 6d                	jmp    8036d6 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803669:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  803670:	00 00 00 
  803673:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803679:	8b 10                	mov    (%rax),%edx
  80367b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80367f:	8b 40 04             	mov    0x4(%rax),%eax
  803682:	39 c2                	cmp    %eax,%edx
  803684:	74 ae                	je     803634 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80368a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80368e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803696:	8b 00                	mov    (%rax),%eax
  803698:	99                   	cltd   
  803699:	c1 ea 1b             	shr    $0x1b,%edx
  80369c:	01 d0                	add    %edx,%eax
  80369e:	83 e0 1f             	and    $0x1f,%eax
  8036a1:	29 d0                	sub    %edx,%eax
  8036a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036a7:	48 98                	cltq   
  8036a9:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8036ae:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8036b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b4:	8b 00                	mov    (%rax),%eax
  8036b6:	8d 50 01             	lea    0x1(%rax),%edx
  8036b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036bd:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036cc:	0f 82 60 ff ff ff    	jb     803632 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8036d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036d6:	c9                   	leaveq 
  8036d7:	c3                   	retq   

00000000008036d8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8036d8:	55                   	push   %rbp
  8036d9:	48 89 e5             	mov    %rsp,%rbp
  8036dc:	48 83 ec 40          	sub    $0x40,%rsp
  8036e0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036e4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036e8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8036ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f0:	48 89 c7             	mov    %rax,%rdi
  8036f3:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  8036fa:	00 00 00 
  8036fd:	ff d0                	callq  *%rax
  8036ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803703:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803707:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80370b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803712:	00 
  803713:	e9 8e 00 00 00       	jmpq   8037a6 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803718:	eb 31                	jmp    80374b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80371a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80371e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803722:	48 89 d6             	mov    %rdx,%rsi
  803725:	48 89 c7             	mov    %rax,%rdi
  803728:	48 b8 bb 34 80 00 00 	movabs $0x8034bb,%rax
  80372f:	00 00 00 
  803732:	ff d0                	callq  *%rax
  803734:	85 c0                	test   %eax,%eax
  803736:	74 07                	je     80373f <devpipe_write+0x67>
				return 0;
  803738:	b8 00 00 00 00       	mov    $0x0,%eax
  80373d:	eb 79                	jmp    8037b8 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80373f:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  803746:	00 00 00 
  803749:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80374b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374f:	8b 40 04             	mov    0x4(%rax),%eax
  803752:	48 63 d0             	movslq %eax,%rdx
  803755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803759:	8b 00                	mov    (%rax),%eax
  80375b:	48 98                	cltq   
  80375d:	48 83 c0 20          	add    $0x20,%rax
  803761:	48 39 c2             	cmp    %rax,%rdx
  803764:	73 b4                	jae    80371a <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803766:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80376a:	8b 40 04             	mov    0x4(%rax),%eax
  80376d:	99                   	cltd   
  80376e:	c1 ea 1b             	shr    $0x1b,%edx
  803771:	01 d0                	add    %edx,%eax
  803773:	83 e0 1f             	and    $0x1f,%eax
  803776:	29 d0                	sub    %edx,%eax
  803778:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80377c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803780:	48 01 ca             	add    %rcx,%rdx
  803783:	0f b6 0a             	movzbl (%rdx),%ecx
  803786:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80378a:	48 98                	cltq   
  80378c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803790:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803794:	8b 40 04             	mov    0x4(%rax),%eax
  803797:	8d 50 01             	lea    0x1(%rax),%edx
  80379a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80379e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037aa:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037ae:	0f 82 64 ff ff ff    	jb     803718 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8037b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037b8:	c9                   	leaveq 
  8037b9:	c3                   	retq   

00000000008037ba <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8037ba:	55                   	push   %rbp
  8037bb:	48 89 e5             	mov    %rsp,%rbp
  8037be:	48 83 ec 20          	sub    $0x20,%rsp
  8037c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8037ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037ce:	48 89 c7             	mov    %rax,%rdi
  8037d1:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  8037d8:	00 00 00 
  8037db:	ff d0                	callq  *%rax
  8037dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8037e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e5:	48 be 58 47 80 00 00 	movabs $0x804758,%rsi
  8037ec:	00 00 00 
  8037ef:	48 89 c7             	mov    %rax,%rdi
  8037f2:	48 b8 e5 0e 80 00 00 	movabs $0x800ee5,%rax
  8037f9:	00 00 00 
  8037fc:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8037fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803802:	8b 50 04             	mov    0x4(%rax),%edx
  803805:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803809:	8b 00                	mov    (%rax),%eax
  80380b:	29 c2                	sub    %eax,%edx
  80380d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803811:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803817:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80381b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803822:	00 00 00 
	stat->st_dev = &devpipe;
  803825:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803829:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803830:	00 00 00 
  803833:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80383a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80383f:	c9                   	leaveq 
  803840:	c3                   	retq   

0000000000803841 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803841:	55                   	push   %rbp
  803842:	48 89 e5             	mov    %rsp,%rbp
  803845:	48 83 ec 10          	sub    $0x10,%rsp
  803849:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80384d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803851:	48 89 c6             	mov    %rax,%rsi
  803854:	bf 00 00 00 00       	mov    $0x0,%edi
  803859:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  803860:	00 00 00 
  803863:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803869:	48 89 c7             	mov    %rax,%rdi
  80386c:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  803873:	00 00 00 
  803876:	ff d0                	callq  *%rax
  803878:	48 89 c6             	mov    %rax,%rsi
  80387b:	bf 00 00 00 00       	mov    $0x0,%edi
  803880:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  803887:	00 00 00 
  80388a:	ff d0                	callq  *%rax
}
  80388c:	c9                   	leaveq 
  80388d:	c3                   	retq   

000000000080388e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80388e:	55                   	push   %rbp
  80388f:	48 89 e5             	mov    %rsp,%rbp
  803892:	48 83 ec 20          	sub    $0x20,%rsp
  803896:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803899:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80389c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80389f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8038a3:	be 01 00 00 00       	mov    $0x1,%esi
  8038a8:	48 89 c7             	mov    %rax,%rdi
  8038ab:	48 b8 cc 16 80 00 00 	movabs $0x8016cc,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
}
  8038b7:	c9                   	leaveq 
  8038b8:	c3                   	retq   

00000000008038b9 <getchar>:

int
getchar(void)
{
  8038b9:	55                   	push   %rbp
  8038ba:	48 89 e5             	mov    %rsp,%rbp
  8038bd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8038c1:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8038c5:	ba 01 00 00 00       	mov    $0x1,%edx
  8038ca:	48 89 c6             	mov    %rax,%rsi
  8038cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d2:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  8038d9:	00 00 00 
  8038dc:	ff d0                	callq  *%rax
  8038de:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8038e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038e5:	79 05                	jns    8038ec <getchar+0x33>
		return r;
  8038e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ea:	eb 14                	jmp    803900 <getchar+0x47>
	if (r < 1)
  8038ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f0:	7f 07                	jg     8038f9 <getchar+0x40>
		return -E_EOF;
  8038f2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038f7:	eb 07                	jmp    803900 <getchar+0x47>
	return c;
  8038f9:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038fd:	0f b6 c0             	movzbl %al,%eax
}
  803900:	c9                   	leaveq 
  803901:	c3                   	retq   

0000000000803902 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803902:	55                   	push   %rbp
  803903:	48 89 e5             	mov    %rsp,%rbp
  803906:	48 83 ec 20          	sub    $0x20,%rsp
  80390a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80390d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803911:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803914:	48 89 d6             	mov    %rdx,%rsi
  803917:	89 c7                	mov    %eax,%edi
  803919:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  803920:	00 00 00 
  803923:	ff d0                	callq  *%rax
  803925:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803928:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392c:	79 05                	jns    803933 <iscons+0x31>
		return r;
  80392e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803931:	eb 1a                	jmp    80394d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803933:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803937:	8b 10                	mov    (%rax),%edx
  803939:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803940:	00 00 00 
  803943:	8b 00                	mov    (%rax),%eax
  803945:	39 c2                	cmp    %eax,%edx
  803947:	0f 94 c0             	sete   %al
  80394a:	0f b6 c0             	movzbl %al,%eax
}
  80394d:	c9                   	leaveq 
  80394e:	c3                   	retq   

000000000080394f <opencons>:

int
opencons(void)
{
  80394f:	55                   	push   %rbp
  803950:	48 89 e5             	mov    %rsp,%rbp
  803953:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803957:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80395b:	48 89 c7             	mov    %rax,%rdi
  80395e:	48 b8 42 23 80 00 00 	movabs $0x802342,%rax
  803965:	00 00 00 
  803968:	ff d0                	callq  *%rax
  80396a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80396d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803971:	79 05                	jns    803978 <opencons+0x29>
		return r;
  803973:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803976:	eb 5b                	jmp    8039d3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803978:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397c:	ba 07 04 00 00       	mov    $0x407,%edx
  803981:	48 89 c6             	mov    %rax,%rsi
  803984:	bf 00 00 00 00       	mov    $0x0,%edi
  803989:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  803990:	00 00 00 
  803993:	ff d0                	callq  *%rax
  803995:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803998:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80399c:	79 05                	jns    8039a3 <opencons+0x54>
		return r;
  80399e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a1:	eb 30                	jmp    8039d3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8039a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a7:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8039ae:	00 00 00 
  8039b1:	8b 12                	mov    (%rdx),%edx
  8039b3:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8039b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8039c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c4:	48 89 c7             	mov    %rax,%rdi
  8039c7:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  8039ce:	00 00 00 
  8039d1:	ff d0                	callq  *%rax
}
  8039d3:	c9                   	leaveq 
  8039d4:	c3                   	retq   

00000000008039d5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039d5:	55                   	push   %rbp
  8039d6:	48 89 e5             	mov    %rsp,%rbp
  8039d9:	48 83 ec 30          	sub    $0x30,%rsp
  8039dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8039e9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039ee:	75 07                	jne    8039f7 <devcons_read+0x22>
		return 0;
  8039f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f5:	eb 4b                	jmp    803a42 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8039f7:	eb 0c                	jmp    803a05 <devcons_read+0x30>
		sys_yield();
  8039f9:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  803a00:	00 00 00 
  803a03:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803a05:	48 b8 16 17 80 00 00 	movabs $0x801716,%rax
  803a0c:	00 00 00 
  803a0f:	ff d0                	callq  *%rax
  803a11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a18:	74 df                	je     8039f9 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803a1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a1e:	79 05                	jns    803a25 <devcons_read+0x50>
		return c;
  803a20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a23:	eb 1d                	jmp    803a42 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a25:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a29:	75 07                	jne    803a32 <devcons_read+0x5d>
		return 0;
  803a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a30:	eb 10                	jmp    803a42 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a35:	89 c2                	mov    %eax,%edx
  803a37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a3b:	88 10                	mov    %dl,(%rax)
	return 1;
  803a3d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a42:	c9                   	leaveq 
  803a43:	c3                   	retq   

0000000000803a44 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a44:	55                   	push   %rbp
  803a45:	48 89 e5             	mov    %rsp,%rbp
  803a48:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a4f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a56:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a5d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a6b:	eb 76                	jmp    803ae3 <devcons_write+0x9f>
		m = n - tot;
  803a6d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a74:	89 c2                	mov    %eax,%edx
  803a76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a79:	29 c2                	sub    %eax,%edx
  803a7b:	89 d0                	mov    %edx,%eax
  803a7d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a83:	83 f8 7f             	cmp    $0x7f,%eax
  803a86:	76 07                	jbe    803a8f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a88:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a92:	48 63 d0             	movslq %eax,%rdx
  803a95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a98:	48 63 c8             	movslq %eax,%rcx
  803a9b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803aa2:	48 01 c1             	add    %rax,%rcx
  803aa5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803aac:	48 89 ce             	mov    %rcx,%rsi
  803aaf:	48 89 c7             	mov    %rax,%rdi
  803ab2:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  803ab9:	00 00 00 
  803abc:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803abe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ac1:	48 63 d0             	movslq %eax,%rdx
  803ac4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803acb:	48 89 d6             	mov    %rdx,%rsi
  803ace:	48 89 c7             	mov    %rax,%rdi
  803ad1:	48 b8 cc 16 80 00 00 	movabs $0x8016cc,%rax
  803ad8:	00 00 00 
  803adb:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803add:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ae0:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ae3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae6:	48 98                	cltq   
  803ae8:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803aef:	0f 82 78 ff ff ff    	jb     803a6d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803af5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803af8:	c9                   	leaveq 
  803af9:	c3                   	retq   

0000000000803afa <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803afa:	55                   	push   %rbp
  803afb:	48 89 e5             	mov    %rsp,%rbp
  803afe:	48 83 ec 08          	sub    $0x8,%rsp
  803b02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803b06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b0b:	c9                   	leaveq 
  803b0c:	c3                   	retq   

0000000000803b0d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b0d:	55                   	push   %rbp
  803b0e:	48 89 e5             	mov    %rsp,%rbp
  803b11:	48 83 ec 10          	sub    $0x10,%rsp
  803b15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b21:	48 be 64 47 80 00 00 	movabs $0x804764,%rsi
  803b28:	00 00 00 
  803b2b:	48 89 c7             	mov    %rax,%rdi
  803b2e:	48 b8 e5 0e 80 00 00 	movabs $0x800ee5,%rax
  803b35:	00 00 00 
  803b38:	ff d0                	callq  *%rax
	return 0;
  803b3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b3f:	c9                   	leaveq 
  803b40:	c3                   	retq   

0000000000803b41 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803b41:	55                   	push   %rbp
  803b42:	48 89 e5             	mov    %rsp,%rbp
  803b45:	53                   	push   %rbx
  803b46:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803b4d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803b54:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803b5a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803b61:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803b68:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803b6f:	84 c0                	test   %al,%al
  803b71:	74 23                	je     803b96 <_panic+0x55>
  803b73:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803b7a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803b7e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803b82:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803b86:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803b8a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803b8e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803b92:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803b96:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b9d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803ba4:	00 00 00 
  803ba7:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803bae:	00 00 00 
  803bb1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803bb5:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803bbc:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803bc3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803bca:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803bd1:	00 00 00 
  803bd4:	48 8b 18             	mov    (%rax),%rbx
  803bd7:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  803bde:	00 00 00 
  803be1:	ff d0                	callq  *%rax
  803be3:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803be9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803bf0:	41 89 c8             	mov    %ecx,%r8d
  803bf3:	48 89 d1             	mov    %rdx,%rcx
  803bf6:	48 89 da             	mov    %rbx,%rdx
  803bf9:	89 c6                	mov    %eax,%esi
  803bfb:	48 bf 70 47 80 00 00 	movabs $0x804770,%rdi
  803c02:	00 00 00 
  803c05:	b8 00 00 00 00       	mov    $0x0,%eax
  803c0a:	49 b9 30 03 80 00 00 	movabs $0x800330,%r9
  803c11:	00 00 00 
  803c14:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803c17:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803c1e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803c25:	48 89 d6             	mov    %rdx,%rsi
  803c28:	48 89 c7             	mov    %rax,%rdi
  803c2b:	48 b8 84 02 80 00 00 	movabs $0x800284,%rax
  803c32:	00 00 00 
  803c35:	ff d0                	callq  *%rax
	cprintf("\n");
  803c37:	48 bf 93 47 80 00 00 	movabs $0x804793,%rdi
  803c3e:	00 00 00 
  803c41:	b8 00 00 00 00       	mov    $0x0,%eax
  803c46:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  803c4d:	00 00 00 
  803c50:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803c52:	cc                   	int3   
  803c53:	eb fd                	jmp    803c52 <_panic+0x111>

0000000000803c55 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803c55:	55                   	push   %rbp
  803c56:	48 89 e5             	mov    %rsp,%rbp
  803c59:	48 83 ec 10          	sub    $0x10,%rsp
  803c5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803c61:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803c68:	00 00 00 
  803c6b:	48 8b 00             	mov    (%rax),%rax
  803c6e:	48 85 c0             	test   %rax,%rax
  803c71:	0f 85 84 00 00 00    	jne    803cfb <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803c77:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c7e:	00 00 00 
  803c81:	48 8b 00             	mov    (%rax),%rax
  803c84:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803c8a:	ba 07 00 00 00       	mov    $0x7,%edx
  803c8f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803c94:	89 c7                	mov    %eax,%edi
  803c96:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  803c9d:	00 00 00 
  803ca0:	ff d0                	callq  *%rax
  803ca2:	85 c0                	test   %eax,%eax
  803ca4:	79 2a                	jns    803cd0 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803ca6:	48 ba 98 47 80 00 00 	movabs $0x804798,%rdx
  803cad:	00 00 00 
  803cb0:	be 23 00 00 00       	mov    $0x23,%esi
  803cb5:	48 bf bf 47 80 00 00 	movabs $0x8047bf,%rdi
  803cbc:	00 00 00 
  803cbf:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc4:	48 b9 41 3b 80 00 00 	movabs $0x803b41,%rcx
  803ccb:	00 00 00 
  803cce:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803cd0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cd7:	00 00 00 
  803cda:	48 8b 00             	mov    (%rax),%rax
  803cdd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803ce3:	48 be 0e 3d 80 00 00 	movabs $0x803d0e,%rsi
  803cea:	00 00 00 
  803ced:	89 c7                	mov    %eax,%edi
  803cef:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  803cf6:	00 00 00 
  803cf9:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803cfb:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d02:	00 00 00 
  803d05:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d09:	48 89 10             	mov    %rdx,(%rax)
}
  803d0c:	c9                   	leaveq 
  803d0d:	c3                   	retq   

0000000000803d0e <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803d0e:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803d11:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803d18:	00 00 00 
call *%rax
  803d1b:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  803d1d:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803d24:	00 
movq 152(%rsp), %rcx  //Load RSP
  803d25:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803d2c:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  803d2d:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  803d31:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  803d34:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803d3b:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  803d3c:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  803d40:	4c 8b 3c 24          	mov    (%rsp),%r15
  803d44:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803d49:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803d4e:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803d53:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803d58:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803d5d:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803d62:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803d67:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803d6c:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803d71:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803d76:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803d7b:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803d80:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803d85:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803d8a:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  803d8e:	48 83 c4 08          	add    $0x8,%rsp
popfq
  803d92:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  803d93:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  803d94:	c3                   	retq   

0000000000803d95 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d95:	55                   	push   %rbp
  803d96:	48 89 e5             	mov    %rsp,%rbp
  803d99:	48 83 ec 30          	sub    $0x30,%rsp
  803d9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803da1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803da5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803da9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803db0:	00 00 00 
  803db3:	48 8b 00             	mov    (%rax),%rax
  803db6:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803dbc:	85 c0                	test   %eax,%eax
  803dbe:	75 34                	jne    803df4 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803dc0:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  803dc7:	00 00 00 
  803dca:	ff d0                	callq  *%rax
  803dcc:	25 ff 03 00 00       	and    $0x3ff,%eax
  803dd1:	48 98                	cltq   
  803dd3:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803dda:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803de1:	00 00 00 
  803de4:	48 01 c2             	add    %rax,%rdx
  803de7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dee:	00 00 00 
  803df1:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803df4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803df9:	75 0e                	jne    803e09 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803dfb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e02:	00 00 00 
  803e05:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803e09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e0d:	48 89 c7             	mov    %rax,%rdi
  803e10:	48 b8 3d 1a 80 00 00 	movabs $0x801a3d,%rax
  803e17:	00 00 00 
  803e1a:	ff d0                	callq  *%rax
  803e1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803e1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e23:	79 19                	jns    803e3e <ipc_recv+0xa9>
		*from_env_store = 0;
  803e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e29:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803e2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e33:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803e39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3c:	eb 53                	jmp    803e91 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803e3e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e43:	74 19                	je     803e5e <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803e45:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e4c:	00 00 00 
  803e4f:	48 8b 00             	mov    (%rax),%rax
  803e52:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e5c:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803e5e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e63:	74 19                	je     803e7e <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803e65:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e6c:	00 00 00 
  803e6f:	48 8b 00             	mov    (%rax),%rax
  803e72:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e7c:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803e7e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e85:	00 00 00 
  803e88:	48 8b 00             	mov    (%rax),%rax
  803e8b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803e91:	c9                   	leaveq 
  803e92:	c3                   	retq   

0000000000803e93 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e93:	55                   	push   %rbp
  803e94:	48 89 e5             	mov    %rsp,%rbp
  803e97:	48 83 ec 30          	sub    $0x30,%rsp
  803e9b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e9e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ea1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ea5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803ea8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ead:	75 0e                	jne    803ebd <ipc_send+0x2a>
		pg = (void*)UTOP;
  803eaf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803eb6:	00 00 00 
  803eb9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803ebd:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ec0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ec3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ec7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803eca:	89 c7                	mov    %eax,%edi
  803ecc:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  803ed3:	00 00 00 
  803ed6:	ff d0                	callq  *%rax
  803ed8:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803edb:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803edf:	75 0c                	jne    803eed <ipc_send+0x5a>
			sys_yield();
  803ee1:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  803ee8:	00 00 00 
  803eeb:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803eed:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ef1:	74 ca                	je     803ebd <ipc_send+0x2a>
	if(result != 0)
  803ef3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ef7:	74 20                	je     803f19 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803ef9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803efc:	89 c6                	mov    %eax,%esi
  803efe:	48 bf cd 47 80 00 00 	movabs $0x8047cd,%rdi
  803f05:	00 00 00 
  803f08:	b8 00 00 00 00       	mov    $0x0,%eax
  803f0d:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  803f14:	00 00 00 
  803f17:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803f19:	c9                   	leaveq 
  803f1a:	c3                   	retq   

0000000000803f1b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f1b:	55                   	push   %rbp
  803f1c:	48 89 e5             	mov    %rsp,%rbp
  803f1f:	48 83 ec 14          	sub    $0x14,%rsp
  803f23:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803f26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f2d:	eb 4e                	jmp    803f7d <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803f2f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f36:	00 00 00 
  803f39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f3c:	48 98                	cltq   
  803f3e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803f45:	48 01 d0             	add    %rdx,%rax
  803f48:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803f4e:	8b 00                	mov    (%rax),%eax
  803f50:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803f53:	75 24                	jne    803f79 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803f55:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f5c:	00 00 00 
  803f5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f62:	48 98                	cltq   
  803f64:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803f6b:	48 01 d0             	add    %rdx,%rax
  803f6e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f74:	8b 40 08             	mov    0x8(%rax),%eax
  803f77:	eb 12                	jmp    803f8b <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803f79:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f7d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f84:	7e a9                	jle    803f2f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803f86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f8b:	c9                   	leaveq 
  803f8c:	c3                   	retq   

0000000000803f8d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f8d:	55                   	push   %rbp
  803f8e:	48 89 e5             	mov    %rsp,%rbp
  803f91:	48 83 ec 18          	sub    $0x18,%rsp
  803f95:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f9d:	48 c1 e8 15          	shr    $0x15,%rax
  803fa1:	48 89 c2             	mov    %rax,%rdx
  803fa4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803fab:	01 00 00 
  803fae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fb2:	83 e0 01             	and    $0x1,%eax
  803fb5:	48 85 c0             	test   %rax,%rax
  803fb8:	75 07                	jne    803fc1 <pageref+0x34>
		return 0;
  803fba:	b8 00 00 00 00       	mov    $0x0,%eax
  803fbf:	eb 53                	jmp    804014 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803fc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fc5:	48 c1 e8 0c          	shr    $0xc,%rax
  803fc9:	48 89 c2             	mov    %rax,%rdx
  803fcc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803fd3:	01 00 00 
  803fd6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fda:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803fde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe2:	83 e0 01             	and    $0x1,%eax
  803fe5:	48 85 c0             	test   %rax,%rax
  803fe8:	75 07                	jne    803ff1 <pageref+0x64>
		return 0;
  803fea:	b8 00 00 00 00       	mov    $0x0,%eax
  803fef:	eb 23                	jmp    804014 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff5:	48 c1 e8 0c          	shr    $0xc,%rax
  803ff9:	48 89 c2             	mov    %rax,%rdx
  803ffc:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804003:	00 00 00 
  804006:	48 c1 e2 04          	shl    $0x4,%rdx
  80400a:	48 01 d0             	add    %rdx,%rax
  80400d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804011:	0f b7 c0             	movzwl %ax,%eax
}
  804014:	c9                   	leaveq 
  804015:	c3                   	retq   
