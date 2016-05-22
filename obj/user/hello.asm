
obj/user/hello:     file format elf64-x86-64


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
  80003c:	e8 5e 00 00 00       	callq  80009f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800052:	48 bf 80 37 80 00 00 	movabs $0x803780,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf 8e 37 80 00 00 	movabs $0x80378e,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
}
  80009d:	c9                   	leaveq 
  80009e:	c3                   	retq   

000000000080009f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009f:	55                   	push   %rbp
  8000a0:	48 89 e5             	mov    %rsp,%rbp
  8000a3:	48 83 ec 10          	sub    $0x10,%rsp
  8000a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ae:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
  8000ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000bf:	48 98                	cltq   
  8000c1:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8000c8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000cf:	00 00 00 
  8000d2:	48 01 c2             	add    %rax,%rdx
  8000d5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000dc:	00 00 00 
  8000df:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000e6:	7e 14                	jle    8000fc <libmain+0x5d>
		binaryname = argv[0];
  8000e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000ec:	48 8b 10             	mov    (%rax),%rdx
  8000ef:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000f6:	00 00 00 
  8000f9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800100:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800103:	48 89 d6             	mov    %rdx,%rsi
  800106:	89 c7                	mov    %eax,%edi
  800108:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80010f:	00 00 00 
  800112:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800114:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
}
  800120:	c9                   	leaveq 
  800121:	c3                   	retq   

0000000000800122 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800122:	55                   	push   %rbp
  800123:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800126:	48 b8 dd 1e 80 00 00 	movabs $0x801edd,%rax
  80012d:	00 00 00 
  800130:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800132:	bf 00 00 00 00       	mov    $0x0,%edi
  800137:	48 b8 8e 16 80 00 00 	movabs $0x80168e,%rax
  80013e:	00 00 00 
  800141:	ff d0                	callq  *%rax

}
  800143:	5d                   	pop    %rbp
  800144:	c3                   	retq   

0000000000800145 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800145:	55                   	push   %rbp
  800146:	48 89 e5             	mov    %rsp,%rbp
  800149:	48 83 ec 10          	sub    $0x10,%rsp
  80014d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800150:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800154:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800158:	8b 00                	mov    (%rax),%eax
  80015a:	8d 48 01             	lea    0x1(%rax),%ecx
  80015d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800161:	89 0a                	mov    %ecx,(%rdx)
  800163:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800166:	89 d1                	mov    %edx,%ecx
  800168:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016c:	48 98                	cltq   
  80016e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800176:	8b 00                	mov    (%rax),%eax
  800178:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017d:	75 2c                	jne    8001ab <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80017f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800183:	8b 00                	mov    (%rax),%eax
  800185:	48 98                	cltq   
  800187:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018b:	48 83 c2 08          	add    $0x8,%rdx
  80018f:	48 89 c6             	mov    %rax,%rsi
  800192:	48 89 d7             	mov    %rdx,%rdi
  800195:	48 b8 06 16 80 00 00 	movabs $0x801606,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax
        b->idx = 0;
  8001a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001af:	8b 40 04             	mov    0x4(%rax),%eax
  8001b2:	8d 50 01             	lea    0x1(%rax),%edx
  8001b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b9:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001bc:	c9                   	leaveq 
  8001bd:	c3                   	retq   

00000000008001be <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001be:	55                   	push   %rbp
  8001bf:	48 89 e5             	mov    %rsp,%rbp
  8001c2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001c9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001d0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001d7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001de:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001e5:	48 8b 0a             	mov    (%rdx),%rcx
  8001e8:	48 89 08             	mov    %rcx,(%rax)
  8001eb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001ef:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001f3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001f7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800202:	00 00 00 
    b.cnt = 0;
  800205:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80020c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80020f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800216:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80021d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800224:	48 89 c6             	mov    %rax,%rsi
  800227:	48 bf 45 01 80 00 00 	movabs $0x800145,%rdi
  80022e:	00 00 00 
  800231:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  800238:	00 00 00 
  80023b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80023d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800243:	48 98                	cltq   
  800245:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80024c:	48 83 c2 08          	add    $0x8,%rdx
  800250:	48 89 c6             	mov    %rax,%rsi
  800253:	48 89 d7             	mov    %rdx,%rdi
  800256:	48 b8 06 16 80 00 00 	movabs $0x801606,%rax
  80025d:	00 00 00 
  800260:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800268:	c9                   	leaveq 
  800269:	c3                   	retq   

000000000080026a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80026a:	55                   	push   %rbp
  80026b:	48 89 e5             	mov    %rsp,%rbp
  80026e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800275:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80027c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800283:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80028a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800291:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800298:	84 c0                	test   %al,%al
  80029a:	74 20                	je     8002bc <cprintf+0x52>
  80029c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002a0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002a4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002a8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002ac:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002b0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002b4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002b8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002bc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002c3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002ca:	00 00 00 
  8002cd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002d4:	00 00 00 
  8002d7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002db:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002e2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002e9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002f0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002f7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002fe:	48 8b 0a             	mov    (%rdx),%rcx
  800301:	48 89 08             	mov    %rcx,(%rax)
  800304:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800308:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80030c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800310:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800314:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80031b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800322:	48 89 d6             	mov    %rdx,%rsi
  800325:	48 89 c7             	mov    %rax,%rdi
  800328:	48 b8 be 01 80 00 00 	movabs $0x8001be,%rax
  80032f:	00 00 00 
  800332:	ff d0                	callq  *%rax
  800334:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80033a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800340:	c9                   	leaveq 
  800341:	c3                   	retq   

0000000000800342 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800342:	55                   	push   %rbp
  800343:	48 89 e5             	mov    %rsp,%rbp
  800346:	53                   	push   %rbx
  800347:	48 83 ec 38          	sub    $0x38,%rsp
  80034b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80034f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800353:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800357:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80035a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80035e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800362:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800365:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800369:	77 3b                	ja     8003a6 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80036e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800372:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800379:	ba 00 00 00 00       	mov    $0x0,%edx
  80037e:	48 f7 f3             	div    %rbx
  800381:	48 89 c2             	mov    %rax,%rdx
  800384:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800387:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80038a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80038e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800392:	41 89 f9             	mov    %edi,%r9d
  800395:	48 89 c7             	mov    %rax,%rdi
  800398:	48 b8 42 03 80 00 00 	movabs $0x800342,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax
  8003a4:	eb 1e                	jmp    8003c4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a6:	eb 12                	jmp    8003ba <printnum+0x78>
			putch(padc, putdat);
  8003a8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003ac:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003b3:	48 89 ce             	mov    %rcx,%rsi
  8003b6:	89 d7                	mov    %edx,%edi
  8003b8:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ba:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003be:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003c2:	7f e4                	jg     8003a8 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d0:	48 f7 f1             	div    %rcx
  8003d3:	48 89 d0             	mov    %rdx,%rax
  8003d6:	48 ba b0 39 80 00 00 	movabs $0x8039b0,%rdx
  8003dd:	00 00 00 
  8003e0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003e4:	0f be d0             	movsbl %al,%edx
  8003e7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ef:	48 89 ce             	mov    %rcx,%rsi
  8003f2:	89 d7                	mov    %edx,%edi
  8003f4:	ff d0                	callq  *%rax
}
  8003f6:	48 83 c4 38          	add    $0x38,%rsp
  8003fa:	5b                   	pop    %rbx
  8003fb:	5d                   	pop    %rbp
  8003fc:	c3                   	retq   

00000000008003fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003fd:	55                   	push   %rbp
  8003fe:	48 89 e5             	mov    %rsp,%rbp
  800401:	48 83 ec 1c          	sub    $0x1c,%rsp
  800405:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800409:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80040c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800410:	7e 52                	jle    800464 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800416:	8b 00                	mov    (%rax),%eax
  800418:	83 f8 30             	cmp    $0x30,%eax
  80041b:	73 24                	jae    800441 <getuint+0x44>
  80041d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800421:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800429:	8b 00                	mov    (%rax),%eax
  80042b:	89 c0                	mov    %eax,%eax
  80042d:	48 01 d0             	add    %rdx,%rax
  800430:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800434:	8b 12                	mov    (%rdx),%edx
  800436:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800439:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80043d:	89 0a                	mov    %ecx,(%rdx)
  80043f:	eb 17                	jmp    800458 <getuint+0x5b>
  800441:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800445:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800449:	48 89 d0             	mov    %rdx,%rax
  80044c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800450:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800454:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800458:	48 8b 00             	mov    (%rax),%rax
  80045b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80045f:	e9 a3 00 00 00       	jmpq   800507 <getuint+0x10a>
	else if (lflag)
  800464:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800468:	74 4f                	je     8004b9 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80046a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046e:	8b 00                	mov    (%rax),%eax
  800470:	83 f8 30             	cmp    $0x30,%eax
  800473:	73 24                	jae    800499 <getuint+0x9c>
  800475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800479:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80047d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800481:	8b 00                	mov    (%rax),%eax
  800483:	89 c0                	mov    %eax,%eax
  800485:	48 01 d0             	add    %rdx,%rax
  800488:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80048c:	8b 12                	mov    (%rdx),%edx
  80048e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800491:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800495:	89 0a                	mov    %ecx,(%rdx)
  800497:	eb 17                	jmp    8004b0 <getuint+0xb3>
  800499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004a1:	48 89 d0             	mov    %rdx,%rax
  8004a4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ac:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004b0:	48 8b 00             	mov    (%rax),%rax
  8004b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004b7:	eb 4e                	jmp    800507 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bd:	8b 00                	mov    (%rax),%eax
  8004bf:	83 f8 30             	cmp    $0x30,%eax
  8004c2:	73 24                	jae    8004e8 <getuint+0xeb>
  8004c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d0:	8b 00                	mov    (%rax),%eax
  8004d2:	89 c0                	mov    %eax,%eax
  8004d4:	48 01 d0             	add    %rdx,%rax
  8004d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004db:	8b 12                	mov    (%rdx),%edx
  8004dd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e4:	89 0a                	mov    %ecx,(%rdx)
  8004e6:	eb 17                	jmp    8004ff <getuint+0x102>
  8004e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ec:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004f0:	48 89 d0             	mov    %rdx,%rax
  8004f3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004ff:	8b 00                	mov    (%rax),%eax
  800501:	89 c0                	mov    %eax,%eax
  800503:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800507:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80050b:	c9                   	leaveq 
  80050c:	c3                   	retq   

000000000080050d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80050d:	55                   	push   %rbp
  80050e:	48 89 e5             	mov    %rsp,%rbp
  800511:	48 83 ec 1c          	sub    $0x1c,%rsp
  800515:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800519:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80051c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800520:	7e 52                	jle    800574 <getint+0x67>
		x=va_arg(*ap, long long);
  800522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800526:	8b 00                	mov    (%rax),%eax
  800528:	83 f8 30             	cmp    $0x30,%eax
  80052b:	73 24                	jae    800551 <getint+0x44>
  80052d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800531:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800539:	8b 00                	mov    (%rax),%eax
  80053b:	89 c0                	mov    %eax,%eax
  80053d:	48 01 d0             	add    %rdx,%rax
  800540:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800544:	8b 12                	mov    (%rdx),%edx
  800546:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800549:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054d:	89 0a                	mov    %ecx,(%rdx)
  80054f:	eb 17                	jmp    800568 <getint+0x5b>
  800551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800555:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800559:	48 89 d0             	mov    %rdx,%rax
  80055c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800560:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800564:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800568:	48 8b 00             	mov    (%rax),%rax
  80056b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80056f:	e9 a3 00 00 00       	jmpq   800617 <getint+0x10a>
	else if (lflag)
  800574:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800578:	74 4f                	je     8005c9 <getint+0xbc>
		x=va_arg(*ap, long);
  80057a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057e:	8b 00                	mov    (%rax),%eax
  800580:	83 f8 30             	cmp    $0x30,%eax
  800583:	73 24                	jae    8005a9 <getint+0x9c>
  800585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800589:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80058d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800591:	8b 00                	mov    (%rax),%eax
  800593:	89 c0                	mov    %eax,%eax
  800595:	48 01 d0             	add    %rdx,%rax
  800598:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059c:	8b 12                	mov    (%rdx),%edx
  80059e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a5:	89 0a                	mov    %ecx,(%rdx)
  8005a7:	eb 17                	jmp    8005c0 <getint+0xb3>
  8005a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b1:	48 89 d0             	mov    %rdx,%rax
  8005b4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c0:	48 8b 00             	mov    (%rax),%rax
  8005c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c7:	eb 4e                	jmp    800617 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cd:	8b 00                	mov    (%rax),%eax
  8005cf:	83 f8 30             	cmp    $0x30,%eax
  8005d2:	73 24                	jae    8005f8 <getint+0xeb>
  8005d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e0:	8b 00                	mov    (%rax),%eax
  8005e2:	89 c0                	mov    %eax,%eax
  8005e4:	48 01 d0             	add    %rdx,%rax
  8005e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005eb:	8b 12                	mov    (%rdx),%edx
  8005ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f4:	89 0a                	mov    %ecx,(%rdx)
  8005f6:	eb 17                	jmp    80060f <getint+0x102>
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800600:	48 89 d0             	mov    %rdx,%rax
  800603:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800607:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80060f:	8b 00                	mov    (%rax),%eax
  800611:	48 98                	cltq   
  800613:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800617:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80061b:	c9                   	leaveq 
  80061c:	c3                   	retq   

000000000080061d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80061d:	55                   	push   %rbp
  80061e:	48 89 e5             	mov    %rsp,%rbp
  800621:	41 54                	push   %r12
  800623:	53                   	push   %rbx
  800624:	48 83 ec 60          	sub    $0x60,%rsp
  800628:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80062c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800630:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800634:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800638:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80063c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800640:	48 8b 0a             	mov    (%rdx),%rcx
  800643:	48 89 08             	mov    %rcx,(%rax)
  800646:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80064a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80064e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800652:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800656:	eb 17                	jmp    80066f <vprintfmt+0x52>
			if (ch == '\0')
  800658:	85 db                	test   %ebx,%ebx
  80065a:	0f 84 cc 04 00 00    	je     800b2c <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800660:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800664:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800668:	48 89 d6             	mov    %rdx,%rsi
  80066b:	89 df                	mov    %ebx,%edi
  80066d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800673:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800677:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80067b:	0f b6 00             	movzbl (%rax),%eax
  80067e:	0f b6 d8             	movzbl %al,%ebx
  800681:	83 fb 25             	cmp    $0x25,%ebx
  800684:	75 d2                	jne    800658 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800686:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80068a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800691:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800698:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80069f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006aa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006ae:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006b2:	0f b6 00             	movzbl (%rax),%eax
  8006b5:	0f b6 d8             	movzbl %al,%ebx
  8006b8:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006bb:	83 f8 55             	cmp    $0x55,%eax
  8006be:	0f 87 34 04 00 00    	ja     800af8 <vprintfmt+0x4db>
  8006c4:	89 c0                	mov    %eax,%eax
  8006c6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006cd:	00 
  8006ce:	48 b8 d8 39 80 00 00 	movabs $0x8039d8,%rax
  8006d5:	00 00 00 
  8006d8:	48 01 d0             	add    %rdx,%rax
  8006db:	48 8b 00             	mov    (%rax),%rax
  8006de:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006e0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006e4:	eb c0                	jmp    8006a6 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006e6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006ea:	eb ba                	jmp    8006a6 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006f3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006f6:	89 d0                	mov    %edx,%eax
  8006f8:	c1 e0 02             	shl    $0x2,%eax
  8006fb:	01 d0                	add    %edx,%eax
  8006fd:	01 c0                	add    %eax,%eax
  8006ff:	01 d8                	add    %ebx,%eax
  800701:	83 e8 30             	sub    $0x30,%eax
  800704:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800707:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80070b:	0f b6 00             	movzbl (%rax),%eax
  80070e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800711:	83 fb 2f             	cmp    $0x2f,%ebx
  800714:	7e 0c                	jle    800722 <vprintfmt+0x105>
  800716:	83 fb 39             	cmp    $0x39,%ebx
  800719:	7f 07                	jg     800722 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80071b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800720:	eb d1                	jmp    8006f3 <vprintfmt+0xd6>
			goto process_precision;
  800722:	eb 58                	jmp    80077c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800724:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800727:	83 f8 30             	cmp    $0x30,%eax
  80072a:	73 17                	jae    800743 <vprintfmt+0x126>
  80072c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800730:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800733:	89 c0                	mov    %eax,%eax
  800735:	48 01 d0             	add    %rdx,%rax
  800738:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80073b:	83 c2 08             	add    $0x8,%edx
  80073e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800741:	eb 0f                	jmp    800752 <vprintfmt+0x135>
  800743:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800747:	48 89 d0             	mov    %rdx,%rax
  80074a:	48 83 c2 08          	add    $0x8,%rdx
  80074e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800752:	8b 00                	mov    (%rax),%eax
  800754:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800757:	eb 23                	jmp    80077c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800759:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80075d:	79 0c                	jns    80076b <vprintfmt+0x14e>
				width = 0;
  80075f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800766:	e9 3b ff ff ff       	jmpq   8006a6 <vprintfmt+0x89>
  80076b:	e9 36 ff ff ff       	jmpq   8006a6 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800770:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800777:	e9 2a ff ff ff       	jmpq   8006a6 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80077c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800780:	79 12                	jns    800794 <vprintfmt+0x177>
				width = precision, precision = -1;
  800782:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800785:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800788:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80078f:	e9 12 ff ff ff       	jmpq   8006a6 <vprintfmt+0x89>
  800794:	e9 0d ff ff ff       	jmpq   8006a6 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800799:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80079d:	e9 04 ff ff ff       	jmpq   8006a6 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a5:	83 f8 30             	cmp    $0x30,%eax
  8007a8:	73 17                	jae    8007c1 <vprintfmt+0x1a4>
  8007aa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b1:	89 c0                	mov    %eax,%eax
  8007b3:	48 01 d0             	add    %rdx,%rax
  8007b6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007b9:	83 c2 08             	add    $0x8,%edx
  8007bc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007bf:	eb 0f                	jmp    8007d0 <vprintfmt+0x1b3>
  8007c1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007c5:	48 89 d0             	mov    %rdx,%rax
  8007c8:	48 83 c2 08          	add    $0x8,%rdx
  8007cc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007d0:	8b 10                	mov    (%rax),%edx
  8007d2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007da:	48 89 ce             	mov    %rcx,%rsi
  8007dd:	89 d7                	mov    %edx,%edi
  8007df:	ff d0                	callq  *%rax
			break;
  8007e1:	e9 40 03 00 00       	jmpq   800b26 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e9:	83 f8 30             	cmp    $0x30,%eax
  8007ec:	73 17                	jae    800805 <vprintfmt+0x1e8>
  8007ee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007f2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f5:	89 c0                	mov    %eax,%eax
  8007f7:	48 01 d0             	add    %rdx,%rax
  8007fa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007fd:	83 c2 08             	add    $0x8,%edx
  800800:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800803:	eb 0f                	jmp    800814 <vprintfmt+0x1f7>
  800805:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800809:	48 89 d0             	mov    %rdx,%rax
  80080c:	48 83 c2 08          	add    $0x8,%rdx
  800810:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800814:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800816:	85 db                	test   %ebx,%ebx
  800818:	79 02                	jns    80081c <vprintfmt+0x1ff>
				err = -err;
  80081a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80081c:	83 fb 15             	cmp    $0x15,%ebx
  80081f:	7f 16                	jg     800837 <vprintfmt+0x21a>
  800821:	48 b8 00 39 80 00 00 	movabs $0x803900,%rax
  800828:	00 00 00 
  80082b:	48 63 d3             	movslq %ebx,%rdx
  80082e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800832:	4d 85 e4             	test   %r12,%r12
  800835:	75 2e                	jne    800865 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800837:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80083b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80083f:	89 d9                	mov    %ebx,%ecx
  800841:	48 ba c1 39 80 00 00 	movabs $0x8039c1,%rdx
  800848:	00 00 00 
  80084b:	48 89 c7             	mov    %rax,%rdi
  80084e:	b8 00 00 00 00       	mov    $0x0,%eax
  800853:	49 b8 35 0b 80 00 00 	movabs $0x800b35,%r8
  80085a:	00 00 00 
  80085d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800860:	e9 c1 02 00 00       	jmpq   800b26 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800865:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800869:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80086d:	4c 89 e1             	mov    %r12,%rcx
  800870:	48 ba ca 39 80 00 00 	movabs $0x8039ca,%rdx
  800877:	00 00 00 
  80087a:	48 89 c7             	mov    %rax,%rdi
  80087d:	b8 00 00 00 00       	mov    $0x0,%eax
  800882:	49 b8 35 0b 80 00 00 	movabs $0x800b35,%r8
  800889:	00 00 00 
  80088c:	41 ff d0             	callq  *%r8
			break;
  80088f:	e9 92 02 00 00       	jmpq   800b26 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800894:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800897:	83 f8 30             	cmp    $0x30,%eax
  80089a:	73 17                	jae    8008b3 <vprintfmt+0x296>
  80089c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a3:	89 c0                	mov    %eax,%eax
  8008a5:	48 01 d0             	add    %rdx,%rax
  8008a8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008ab:	83 c2 08             	add    $0x8,%edx
  8008ae:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b1:	eb 0f                	jmp    8008c2 <vprintfmt+0x2a5>
  8008b3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b7:	48 89 d0             	mov    %rdx,%rax
  8008ba:	48 83 c2 08          	add    $0x8,%rdx
  8008be:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c2:	4c 8b 20             	mov    (%rax),%r12
  8008c5:	4d 85 e4             	test   %r12,%r12
  8008c8:	75 0a                	jne    8008d4 <vprintfmt+0x2b7>
				p = "(null)";
  8008ca:	49 bc cd 39 80 00 00 	movabs $0x8039cd,%r12
  8008d1:	00 00 00 
			if (width > 0 && padc != '-')
  8008d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008d8:	7e 3f                	jle    800919 <vprintfmt+0x2fc>
  8008da:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008de:	74 39                	je     800919 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008e3:	48 98                	cltq   
  8008e5:	48 89 c6             	mov    %rax,%rsi
  8008e8:	4c 89 e7             	mov    %r12,%rdi
  8008eb:	48 b8 e1 0d 80 00 00 	movabs $0x800de1,%rax
  8008f2:	00 00 00 
  8008f5:	ff d0                	callq  *%rax
  8008f7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008fa:	eb 17                	jmp    800913 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008fc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800900:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800904:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800908:	48 89 ce             	mov    %rcx,%rsi
  80090b:	89 d7                	mov    %edx,%edi
  80090d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80090f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800913:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800917:	7f e3                	jg     8008fc <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800919:	eb 37                	jmp    800952 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80091b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80091f:	74 1e                	je     80093f <vprintfmt+0x322>
  800921:	83 fb 1f             	cmp    $0x1f,%ebx
  800924:	7e 05                	jle    80092b <vprintfmt+0x30e>
  800926:	83 fb 7e             	cmp    $0x7e,%ebx
  800929:	7e 14                	jle    80093f <vprintfmt+0x322>
					putch('?', putdat);
  80092b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80092f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800933:	48 89 d6             	mov    %rdx,%rsi
  800936:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80093b:	ff d0                	callq  *%rax
  80093d:	eb 0f                	jmp    80094e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80093f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800943:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800947:	48 89 d6             	mov    %rdx,%rsi
  80094a:	89 df                	mov    %ebx,%edi
  80094c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80094e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800952:	4c 89 e0             	mov    %r12,%rax
  800955:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800959:	0f b6 00             	movzbl (%rax),%eax
  80095c:	0f be d8             	movsbl %al,%ebx
  80095f:	85 db                	test   %ebx,%ebx
  800961:	74 10                	je     800973 <vprintfmt+0x356>
  800963:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800967:	78 b2                	js     80091b <vprintfmt+0x2fe>
  800969:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80096d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800971:	79 a8                	jns    80091b <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800973:	eb 16                	jmp    80098b <vprintfmt+0x36e>
				putch(' ', putdat);
  800975:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800979:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80097d:	48 89 d6             	mov    %rdx,%rsi
  800980:	bf 20 00 00 00       	mov    $0x20,%edi
  800985:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800987:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80098b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098f:	7f e4                	jg     800975 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800991:	e9 90 01 00 00       	jmpq   800b26 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800996:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80099a:	be 03 00 00 00       	mov    $0x3,%esi
  80099f:	48 89 c7             	mov    %rax,%rdi
  8009a2:	48 b8 0d 05 80 00 00 	movabs $0x80050d,%rax
  8009a9:	00 00 00 
  8009ac:	ff d0                	callq  *%rax
  8009ae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b6:	48 85 c0             	test   %rax,%rax
  8009b9:	79 1d                	jns    8009d8 <vprintfmt+0x3bb>
				putch('-', putdat);
  8009bb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009bf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c3:	48 89 d6             	mov    %rdx,%rsi
  8009c6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009cb:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d1:	48 f7 d8             	neg    %rax
  8009d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009d8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009df:	e9 d5 00 00 00       	jmpq   800ab9 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009e4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009e8:	be 03 00 00 00       	mov    $0x3,%esi
  8009ed:	48 89 c7             	mov    %rax,%rdi
  8009f0:	48 b8 fd 03 80 00 00 	movabs $0x8003fd,%rax
  8009f7:	00 00 00 
  8009fa:	ff d0                	callq  *%rax
  8009fc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a00:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a07:	e9 ad 00 00 00       	jmpq   800ab9 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800a0c:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800a0f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a13:	89 d6                	mov    %edx,%esi
  800a15:	48 89 c7             	mov    %rax,%rdi
  800a18:	48 b8 0d 05 80 00 00 	movabs $0x80050d,%rax
  800a1f:	00 00 00 
  800a22:	ff d0                	callq  *%rax
  800a24:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a28:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a2f:	e9 85 00 00 00       	jmpq   800ab9 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800a34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3c:	48 89 d6             	mov    %rdx,%rsi
  800a3f:	bf 30 00 00 00       	mov    $0x30,%edi
  800a44:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a46:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4e:	48 89 d6             	mov    %rdx,%rsi
  800a51:	bf 78 00 00 00       	mov    $0x78,%edi
  800a56:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5b:	83 f8 30             	cmp    $0x30,%eax
  800a5e:	73 17                	jae    800a77 <vprintfmt+0x45a>
  800a60:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a67:	89 c0                	mov    %eax,%eax
  800a69:	48 01 d0             	add    %rdx,%rax
  800a6c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a6f:	83 c2 08             	add    $0x8,%edx
  800a72:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a75:	eb 0f                	jmp    800a86 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800a77:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a7b:	48 89 d0             	mov    %rdx,%rax
  800a7e:	48 83 c2 08          	add    $0x8,%rdx
  800a82:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a86:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a8d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a94:	eb 23                	jmp    800ab9 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a96:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a9a:	be 03 00 00 00       	mov    $0x3,%esi
  800a9f:	48 89 c7             	mov    %rax,%rdi
  800aa2:	48 b8 fd 03 80 00 00 	movabs $0x8003fd,%rax
  800aa9:	00 00 00 
  800aac:	ff d0                	callq  *%rax
  800aae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ab2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ab9:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800abe:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ac1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ac4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800acc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad0:	45 89 c1             	mov    %r8d,%r9d
  800ad3:	41 89 f8             	mov    %edi,%r8d
  800ad6:	48 89 c7             	mov    %rax,%rdi
  800ad9:	48 b8 42 03 80 00 00 	movabs $0x800342,%rax
  800ae0:	00 00 00 
  800ae3:	ff d0                	callq  *%rax
			break;
  800ae5:	eb 3f                	jmp    800b26 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aeb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aef:	48 89 d6             	mov    %rdx,%rsi
  800af2:	89 df                	mov    %ebx,%edi
  800af4:	ff d0                	callq  *%rax
			break;
  800af6:	eb 2e                	jmp    800b26 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b00:	48 89 d6             	mov    %rdx,%rsi
  800b03:	bf 25 00 00 00       	mov    $0x25,%edi
  800b08:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b0a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b0f:	eb 05                	jmp    800b16 <vprintfmt+0x4f9>
  800b11:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b16:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b1a:	48 83 e8 01          	sub    $0x1,%rax
  800b1e:	0f b6 00             	movzbl (%rax),%eax
  800b21:	3c 25                	cmp    $0x25,%al
  800b23:	75 ec                	jne    800b11 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b25:	90                   	nop
		}
	}
  800b26:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b27:	e9 43 fb ff ff       	jmpq   80066f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b2c:	48 83 c4 60          	add    $0x60,%rsp
  800b30:	5b                   	pop    %rbx
  800b31:	41 5c                	pop    %r12
  800b33:	5d                   	pop    %rbp
  800b34:	c3                   	retq   

0000000000800b35 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b35:	55                   	push   %rbp
  800b36:	48 89 e5             	mov    %rsp,%rbp
  800b39:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b40:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b47:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b4e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b55:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b5c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b63:	84 c0                	test   %al,%al
  800b65:	74 20                	je     800b87 <printfmt+0x52>
  800b67:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b6b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b6f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b73:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b77:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b7b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b7f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b83:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b87:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b8e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b95:	00 00 00 
  800b98:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b9f:	00 00 00 
  800ba2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ba6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bad:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bb4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bbb:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bc2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bc9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bd0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bd7:	48 89 c7             	mov    %rax,%rdi
  800bda:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  800be1:	00 00 00 
  800be4:	ff d0                	callq  *%rax
	va_end(ap);
}
  800be6:	c9                   	leaveq 
  800be7:	c3                   	retq   

0000000000800be8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be8:	55                   	push   %rbp
  800be9:	48 89 e5             	mov    %rsp,%rbp
  800bec:	48 83 ec 10          	sub    $0x10,%rsp
  800bf0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bf3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bfb:	8b 40 10             	mov    0x10(%rax),%eax
  800bfe:	8d 50 01             	lea    0x1(%rax),%edx
  800c01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c05:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0c:	48 8b 10             	mov    (%rax),%rdx
  800c0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c13:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c17:	48 39 c2             	cmp    %rax,%rdx
  800c1a:	73 17                	jae    800c33 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c20:	48 8b 00             	mov    (%rax),%rax
  800c23:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c2b:	48 89 0a             	mov    %rcx,(%rdx)
  800c2e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c31:	88 10                	mov    %dl,(%rax)
}
  800c33:	c9                   	leaveq 
  800c34:	c3                   	retq   

0000000000800c35 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c35:	55                   	push   %rbp
  800c36:	48 89 e5             	mov    %rsp,%rbp
  800c39:	48 83 ec 50          	sub    $0x50,%rsp
  800c3d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c41:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c44:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c48:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c4c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c50:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c54:	48 8b 0a             	mov    (%rdx),%rcx
  800c57:	48 89 08             	mov    %rcx,(%rax)
  800c5a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c5e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c62:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c66:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c6a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c6e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c72:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c75:	48 98                	cltq   
  800c77:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c7b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c7f:	48 01 d0             	add    %rdx,%rax
  800c82:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c8d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c92:	74 06                	je     800c9a <vsnprintf+0x65>
  800c94:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c98:	7f 07                	jg     800ca1 <vsnprintf+0x6c>
		return -E_INVAL;
  800c9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c9f:	eb 2f                	jmp    800cd0 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ca1:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ca5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ca9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cad:	48 89 c6             	mov    %rax,%rsi
  800cb0:	48 bf e8 0b 80 00 00 	movabs $0x800be8,%rdi
  800cb7:	00 00 00 
  800cba:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  800cc1:	00 00 00 
  800cc4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cc6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cca:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ccd:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cd0:	c9                   	leaveq 
  800cd1:	c3                   	retq   

0000000000800cd2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd2:	55                   	push   %rbp
  800cd3:	48 89 e5             	mov    %rsp,%rbp
  800cd6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cdd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ce4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cea:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cf1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cf8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cff:	84 c0                	test   %al,%al
  800d01:	74 20                	je     800d23 <snprintf+0x51>
  800d03:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d07:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d0b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d0f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d13:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d17:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d1b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d1f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d23:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d2a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d31:	00 00 00 
  800d34:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d3b:	00 00 00 
  800d3e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d42:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d49:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d50:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d57:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d5e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d65:	48 8b 0a             	mov    (%rdx),%rcx
  800d68:	48 89 08             	mov    %rcx,(%rax)
  800d6b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d6f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d73:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d77:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d7b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d82:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d89:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d8f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d96:	48 89 c7             	mov    %rax,%rdi
  800d99:	48 b8 35 0c 80 00 00 	movabs $0x800c35,%rax
  800da0:	00 00 00 
  800da3:	ff d0                	callq  *%rax
  800da5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800dab:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800db1:	c9                   	leaveq 
  800db2:	c3                   	retq   

0000000000800db3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800db3:	55                   	push   %rbp
  800db4:	48 89 e5             	mov    %rsp,%rbp
  800db7:	48 83 ec 18          	sub    $0x18,%rsp
  800dbb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dc6:	eb 09                	jmp    800dd1 <strlen+0x1e>
		n++;
  800dc8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dcc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd5:	0f b6 00             	movzbl (%rax),%eax
  800dd8:	84 c0                	test   %al,%al
  800dda:	75 ec                	jne    800dc8 <strlen+0x15>
		n++;
	return n;
  800ddc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ddf:	c9                   	leaveq 
  800de0:	c3                   	retq   

0000000000800de1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800de1:	55                   	push   %rbp
  800de2:	48 89 e5             	mov    %rsp,%rbp
  800de5:	48 83 ec 20          	sub    $0x20,%rsp
  800de9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ded:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800df8:	eb 0e                	jmp    800e08 <strnlen+0x27>
		n++;
  800dfa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfe:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e03:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e08:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e0d:	74 0b                	je     800e1a <strnlen+0x39>
  800e0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e13:	0f b6 00             	movzbl (%rax),%eax
  800e16:	84 c0                	test   %al,%al
  800e18:	75 e0                	jne    800dfa <strnlen+0x19>
		n++;
	return n;
  800e1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e1d:	c9                   	leaveq 
  800e1e:	c3                   	retq   

0000000000800e1f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e1f:	55                   	push   %rbp
  800e20:	48 89 e5             	mov    %rsp,%rbp
  800e23:	48 83 ec 20          	sub    $0x20,%rsp
  800e27:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e33:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e37:	90                   	nop
  800e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e40:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e44:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e48:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e4c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e50:	0f b6 12             	movzbl (%rdx),%edx
  800e53:	88 10                	mov    %dl,(%rax)
  800e55:	0f b6 00             	movzbl (%rax),%eax
  800e58:	84 c0                	test   %al,%al
  800e5a:	75 dc                	jne    800e38 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e60:	c9                   	leaveq 
  800e61:	c3                   	retq   

0000000000800e62 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e62:	55                   	push   %rbp
  800e63:	48 89 e5             	mov    %rsp,%rbp
  800e66:	48 83 ec 20          	sub    $0x20,%rsp
  800e6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e76:	48 89 c7             	mov    %rax,%rdi
  800e79:	48 b8 b3 0d 80 00 00 	movabs $0x800db3,%rax
  800e80:	00 00 00 
  800e83:	ff d0                	callq  *%rax
  800e85:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e8b:	48 63 d0             	movslq %eax,%rdx
  800e8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e92:	48 01 c2             	add    %rax,%rdx
  800e95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e99:	48 89 c6             	mov    %rax,%rsi
  800e9c:	48 89 d7             	mov    %rdx,%rdi
  800e9f:	48 b8 1f 0e 80 00 00 	movabs $0x800e1f,%rax
  800ea6:	00 00 00 
  800ea9:	ff d0                	callq  *%rax
	return dst;
  800eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800eaf:	c9                   	leaveq 
  800eb0:	c3                   	retq   

0000000000800eb1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800eb1:	55                   	push   %rbp
  800eb2:	48 89 e5             	mov    %rsp,%rbp
  800eb5:	48 83 ec 28          	sub    $0x28,%rsp
  800eb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ebd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ec1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ecd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ed4:	00 
  800ed5:	eb 2a                	jmp    800f01 <strncpy+0x50>
		*dst++ = *src;
  800ed7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800edf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ee3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ee7:	0f b6 12             	movzbl (%rdx),%edx
  800eea:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ef0:	0f b6 00             	movzbl (%rax),%eax
  800ef3:	84 c0                	test   %al,%al
  800ef5:	74 05                	je     800efc <strncpy+0x4b>
			src++;
  800ef7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800efc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f05:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f09:	72 cc                	jb     800ed7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f0f:	c9                   	leaveq 
  800f10:	c3                   	retq   

0000000000800f11 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f11:	55                   	push   %rbp
  800f12:	48 89 e5             	mov    %rsp,%rbp
  800f15:	48 83 ec 28          	sub    $0x28,%rsp
  800f19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f21:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f29:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f2d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f32:	74 3d                	je     800f71 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f34:	eb 1d                	jmp    800f53 <strlcpy+0x42>
			*dst++ = *src++;
  800f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f3e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f42:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f46:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f4a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f4e:	0f b6 12             	movzbl (%rdx),%edx
  800f51:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f53:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f58:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f5d:	74 0b                	je     800f6a <strlcpy+0x59>
  800f5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f63:	0f b6 00             	movzbl (%rax),%eax
  800f66:	84 c0                	test   %al,%al
  800f68:	75 cc                	jne    800f36 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f71:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f79:	48 29 c2             	sub    %rax,%rdx
  800f7c:	48 89 d0             	mov    %rdx,%rax
}
  800f7f:	c9                   	leaveq 
  800f80:	c3                   	retq   

0000000000800f81 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f81:	55                   	push   %rbp
  800f82:	48 89 e5             	mov    %rsp,%rbp
  800f85:	48 83 ec 10          	sub    $0x10,%rsp
  800f89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f91:	eb 0a                	jmp    800f9d <strcmp+0x1c>
		p++, q++;
  800f93:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f98:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fa1:	0f b6 00             	movzbl (%rax),%eax
  800fa4:	84 c0                	test   %al,%al
  800fa6:	74 12                	je     800fba <strcmp+0x39>
  800fa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fac:	0f b6 10             	movzbl (%rax),%edx
  800faf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb3:	0f b6 00             	movzbl (%rax),%eax
  800fb6:	38 c2                	cmp    %al,%dl
  800fb8:	74 d9                	je     800f93 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fbe:	0f b6 00             	movzbl (%rax),%eax
  800fc1:	0f b6 d0             	movzbl %al,%edx
  800fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc8:	0f b6 00             	movzbl (%rax),%eax
  800fcb:	0f b6 c0             	movzbl %al,%eax
  800fce:	29 c2                	sub    %eax,%edx
  800fd0:	89 d0                	mov    %edx,%eax
}
  800fd2:	c9                   	leaveq 
  800fd3:	c3                   	retq   

0000000000800fd4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fd4:	55                   	push   %rbp
  800fd5:	48 89 e5             	mov    %rsp,%rbp
  800fd8:	48 83 ec 18          	sub    $0x18,%rsp
  800fdc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fe0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fe4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fe8:	eb 0f                	jmp    800ff9 <strncmp+0x25>
		n--, p++, q++;
  800fea:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ff4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ff9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800ffe:	74 1d                	je     80101d <strncmp+0x49>
  801000:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801004:	0f b6 00             	movzbl (%rax),%eax
  801007:	84 c0                	test   %al,%al
  801009:	74 12                	je     80101d <strncmp+0x49>
  80100b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80100f:	0f b6 10             	movzbl (%rax),%edx
  801012:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801016:	0f b6 00             	movzbl (%rax),%eax
  801019:	38 c2                	cmp    %al,%dl
  80101b:	74 cd                	je     800fea <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80101d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801022:	75 07                	jne    80102b <strncmp+0x57>
		return 0;
  801024:	b8 00 00 00 00       	mov    $0x0,%eax
  801029:	eb 18                	jmp    801043 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80102b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102f:	0f b6 00             	movzbl (%rax),%eax
  801032:	0f b6 d0             	movzbl %al,%edx
  801035:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801039:	0f b6 00             	movzbl (%rax),%eax
  80103c:	0f b6 c0             	movzbl %al,%eax
  80103f:	29 c2                	sub    %eax,%edx
  801041:	89 d0                	mov    %edx,%eax
}
  801043:	c9                   	leaveq 
  801044:	c3                   	retq   

0000000000801045 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801045:	55                   	push   %rbp
  801046:	48 89 e5             	mov    %rsp,%rbp
  801049:	48 83 ec 0c          	sub    $0xc,%rsp
  80104d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801051:	89 f0                	mov    %esi,%eax
  801053:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801056:	eb 17                	jmp    80106f <strchr+0x2a>
		if (*s == c)
  801058:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105c:	0f b6 00             	movzbl (%rax),%eax
  80105f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801062:	75 06                	jne    80106a <strchr+0x25>
			return (char *) s;
  801064:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801068:	eb 15                	jmp    80107f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80106a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80106f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801073:	0f b6 00             	movzbl (%rax),%eax
  801076:	84 c0                	test   %al,%al
  801078:	75 de                	jne    801058 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80107a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107f:	c9                   	leaveq 
  801080:	c3                   	retq   

0000000000801081 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801081:	55                   	push   %rbp
  801082:	48 89 e5             	mov    %rsp,%rbp
  801085:	48 83 ec 0c          	sub    $0xc,%rsp
  801089:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80108d:	89 f0                	mov    %esi,%eax
  80108f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801092:	eb 13                	jmp    8010a7 <strfind+0x26>
		if (*s == c)
  801094:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801098:	0f b6 00             	movzbl (%rax),%eax
  80109b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80109e:	75 02                	jne    8010a2 <strfind+0x21>
			break;
  8010a0:	eb 10                	jmp    8010b2 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ab:	0f b6 00             	movzbl (%rax),%eax
  8010ae:	84 c0                	test   %al,%al
  8010b0:	75 e2                	jne    801094 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b6:	c9                   	leaveq 
  8010b7:	c3                   	retq   

00000000008010b8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010b8:	55                   	push   %rbp
  8010b9:	48 89 e5             	mov    %rsp,%rbp
  8010bc:	48 83 ec 18          	sub    $0x18,%rsp
  8010c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010c4:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010c7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d0:	75 06                	jne    8010d8 <memset+0x20>
		return v;
  8010d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d6:	eb 69                	jmp    801141 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dc:	83 e0 03             	and    $0x3,%eax
  8010df:	48 85 c0             	test   %rax,%rax
  8010e2:	75 48                	jne    80112c <memset+0x74>
  8010e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e8:	83 e0 03             	and    $0x3,%eax
  8010eb:	48 85 c0             	test   %rax,%rax
  8010ee:	75 3c                	jne    80112c <memset+0x74>
		c &= 0xFF;
  8010f0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010fa:	c1 e0 18             	shl    $0x18,%eax
  8010fd:	89 c2                	mov    %eax,%edx
  8010ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801102:	c1 e0 10             	shl    $0x10,%eax
  801105:	09 c2                	or     %eax,%edx
  801107:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80110a:	c1 e0 08             	shl    $0x8,%eax
  80110d:	09 d0                	or     %edx,%eax
  80110f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801112:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801116:	48 c1 e8 02          	shr    $0x2,%rax
  80111a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80111d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801121:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801124:	48 89 d7             	mov    %rdx,%rdi
  801127:	fc                   	cld    
  801128:	f3 ab                	rep stos %eax,%es:(%rdi)
  80112a:	eb 11                	jmp    80113d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80112c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801130:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801133:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801137:	48 89 d7             	mov    %rdx,%rdi
  80113a:	fc                   	cld    
  80113b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80113d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801141:	c9                   	leaveq 
  801142:	c3                   	retq   

0000000000801143 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801143:	55                   	push   %rbp
  801144:	48 89 e5             	mov    %rsp,%rbp
  801147:	48 83 ec 28          	sub    $0x28,%rsp
  80114b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801153:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801157:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80115f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801163:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80116f:	0f 83 88 00 00 00    	jae    8011fd <memmove+0xba>
  801175:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801179:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80117d:	48 01 d0             	add    %rdx,%rax
  801180:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801184:	76 77                	jbe    8011fd <memmove+0xba>
		s += n;
  801186:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80118a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80118e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801192:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801196:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119a:	83 e0 03             	and    $0x3,%eax
  80119d:	48 85 c0             	test   %rax,%rax
  8011a0:	75 3b                	jne    8011dd <memmove+0x9a>
  8011a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a6:	83 e0 03             	and    $0x3,%eax
  8011a9:	48 85 c0             	test   %rax,%rax
  8011ac:	75 2f                	jne    8011dd <memmove+0x9a>
  8011ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011b2:	83 e0 03             	and    $0x3,%eax
  8011b5:	48 85 c0             	test   %rax,%rax
  8011b8:	75 23                	jne    8011dd <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011be:	48 83 e8 04          	sub    $0x4,%rax
  8011c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011c6:	48 83 ea 04          	sub    $0x4,%rdx
  8011ca:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011ce:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011d2:	48 89 c7             	mov    %rax,%rdi
  8011d5:	48 89 d6             	mov    %rdx,%rsi
  8011d8:	fd                   	std    
  8011d9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011db:	eb 1d                	jmp    8011fa <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e9:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f1:	48 89 d7             	mov    %rdx,%rdi
  8011f4:	48 89 c1             	mov    %rax,%rcx
  8011f7:	fd                   	std    
  8011f8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011fa:	fc                   	cld    
  8011fb:	eb 57                	jmp    801254 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801201:	83 e0 03             	and    $0x3,%eax
  801204:	48 85 c0             	test   %rax,%rax
  801207:	75 36                	jne    80123f <memmove+0xfc>
  801209:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120d:	83 e0 03             	and    $0x3,%eax
  801210:	48 85 c0             	test   %rax,%rax
  801213:	75 2a                	jne    80123f <memmove+0xfc>
  801215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801219:	83 e0 03             	and    $0x3,%eax
  80121c:	48 85 c0             	test   %rax,%rax
  80121f:	75 1e                	jne    80123f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801221:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801225:	48 c1 e8 02          	shr    $0x2,%rax
  801229:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80122c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801230:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801234:	48 89 c7             	mov    %rax,%rdi
  801237:	48 89 d6             	mov    %rdx,%rsi
  80123a:	fc                   	cld    
  80123b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80123d:	eb 15                	jmp    801254 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80123f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801243:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801247:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80124b:	48 89 c7             	mov    %rax,%rdi
  80124e:	48 89 d6             	mov    %rdx,%rsi
  801251:	fc                   	cld    
  801252:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801258:	c9                   	leaveq 
  801259:	c3                   	retq   

000000000080125a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80125a:	55                   	push   %rbp
  80125b:	48 89 e5             	mov    %rsp,%rbp
  80125e:	48 83 ec 18          	sub    $0x18,%rsp
  801262:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801266:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80126a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80126e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801272:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127a:	48 89 ce             	mov    %rcx,%rsi
  80127d:	48 89 c7             	mov    %rax,%rdi
  801280:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  801287:	00 00 00 
  80128a:	ff d0                	callq  *%rax
}
  80128c:	c9                   	leaveq 
  80128d:	c3                   	retq   

000000000080128e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80128e:	55                   	push   %rbp
  80128f:	48 89 e5             	mov    %rsp,%rbp
  801292:	48 83 ec 28          	sub    $0x28,%rsp
  801296:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80129a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80129e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012b2:	eb 36                	jmp    8012ea <memcmp+0x5c>
		if (*s1 != *s2)
  8012b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b8:	0f b6 10             	movzbl (%rax),%edx
  8012bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bf:	0f b6 00             	movzbl (%rax),%eax
  8012c2:	38 c2                	cmp    %al,%dl
  8012c4:	74 1a                	je     8012e0 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	0f b6 d0             	movzbl %al,%edx
  8012d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d4:	0f b6 00             	movzbl (%rax),%eax
  8012d7:	0f b6 c0             	movzbl %al,%eax
  8012da:	29 c2                	sub    %eax,%edx
  8012dc:	89 d0                	mov    %edx,%eax
  8012de:	eb 20                	jmp    801300 <memcmp+0x72>
		s1++, s2++;
  8012e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ee:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012f6:	48 85 c0             	test   %rax,%rax
  8012f9:	75 b9                	jne    8012b4 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801300:	c9                   	leaveq 
  801301:	c3                   	retq   

0000000000801302 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801302:	55                   	push   %rbp
  801303:	48 89 e5             	mov    %rsp,%rbp
  801306:	48 83 ec 28          	sub    $0x28,%rsp
  80130a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80130e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801311:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801315:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801319:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80131d:	48 01 d0             	add    %rdx,%rax
  801320:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801324:	eb 15                	jmp    80133b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801326:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132a:	0f b6 10             	movzbl (%rax),%edx
  80132d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801330:	38 c2                	cmp    %al,%dl
  801332:	75 02                	jne    801336 <memfind+0x34>
			break;
  801334:	eb 0f                	jmp    801345 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801336:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80133b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801343:	72 e1                	jb     801326 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801345:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801349:	c9                   	leaveq 
  80134a:	c3                   	retq   

000000000080134b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80134b:	55                   	push   %rbp
  80134c:	48 89 e5             	mov    %rsp,%rbp
  80134f:	48 83 ec 34          	sub    $0x34,%rsp
  801353:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801357:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80135b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80135e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801365:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80136c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80136d:	eb 05                	jmp    801374 <strtol+0x29>
		s++;
  80136f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801374:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801378:	0f b6 00             	movzbl (%rax),%eax
  80137b:	3c 20                	cmp    $0x20,%al
  80137d:	74 f0                	je     80136f <strtol+0x24>
  80137f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801383:	0f b6 00             	movzbl (%rax),%eax
  801386:	3c 09                	cmp    $0x9,%al
  801388:	74 e5                	je     80136f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80138a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138e:	0f b6 00             	movzbl (%rax),%eax
  801391:	3c 2b                	cmp    $0x2b,%al
  801393:	75 07                	jne    80139c <strtol+0x51>
		s++;
  801395:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80139a:	eb 17                	jmp    8013b3 <strtol+0x68>
	else if (*s == '-')
  80139c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a0:	0f b6 00             	movzbl (%rax),%eax
  8013a3:	3c 2d                	cmp    $0x2d,%al
  8013a5:	75 0c                	jne    8013b3 <strtol+0x68>
		s++, neg = 1;
  8013a7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013b3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013b7:	74 06                	je     8013bf <strtol+0x74>
  8013b9:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013bd:	75 28                	jne    8013e7 <strtol+0x9c>
  8013bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c3:	0f b6 00             	movzbl (%rax),%eax
  8013c6:	3c 30                	cmp    $0x30,%al
  8013c8:	75 1d                	jne    8013e7 <strtol+0x9c>
  8013ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ce:	48 83 c0 01          	add    $0x1,%rax
  8013d2:	0f b6 00             	movzbl (%rax),%eax
  8013d5:	3c 78                	cmp    $0x78,%al
  8013d7:	75 0e                	jne    8013e7 <strtol+0x9c>
		s += 2, base = 16;
  8013d9:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013de:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013e5:	eb 2c                	jmp    801413 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013e7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013eb:	75 19                	jne    801406 <strtol+0xbb>
  8013ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f1:	0f b6 00             	movzbl (%rax),%eax
  8013f4:	3c 30                	cmp    $0x30,%al
  8013f6:	75 0e                	jne    801406 <strtol+0xbb>
		s++, base = 8;
  8013f8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013fd:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801404:	eb 0d                	jmp    801413 <strtol+0xc8>
	else if (base == 0)
  801406:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80140a:	75 07                	jne    801413 <strtol+0xc8>
		base = 10;
  80140c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801413:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801417:	0f b6 00             	movzbl (%rax),%eax
  80141a:	3c 2f                	cmp    $0x2f,%al
  80141c:	7e 1d                	jle    80143b <strtol+0xf0>
  80141e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801422:	0f b6 00             	movzbl (%rax),%eax
  801425:	3c 39                	cmp    $0x39,%al
  801427:	7f 12                	jg     80143b <strtol+0xf0>
			dig = *s - '0';
  801429:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	0f be c0             	movsbl %al,%eax
  801433:	83 e8 30             	sub    $0x30,%eax
  801436:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801439:	eb 4e                	jmp    801489 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80143b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143f:	0f b6 00             	movzbl (%rax),%eax
  801442:	3c 60                	cmp    $0x60,%al
  801444:	7e 1d                	jle    801463 <strtol+0x118>
  801446:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144a:	0f b6 00             	movzbl (%rax),%eax
  80144d:	3c 7a                	cmp    $0x7a,%al
  80144f:	7f 12                	jg     801463 <strtol+0x118>
			dig = *s - 'a' + 10;
  801451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	0f be c0             	movsbl %al,%eax
  80145b:	83 e8 57             	sub    $0x57,%eax
  80145e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801461:	eb 26                	jmp    801489 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801463:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801467:	0f b6 00             	movzbl (%rax),%eax
  80146a:	3c 40                	cmp    $0x40,%al
  80146c:	7e 48                	jle    8014b6 <strtol+0x16b>
  80146e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801472:	0f b6 00             	movzbl (%rax),%eax
  801475:	3c 5a                	cmp    $0x5a,%al
  801477:	7f 3d                	jg     8014b6 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147d:	0f b6 00             	movzbl (%rax),%eax
  801480:	0f be c0             	movsbl %al,%eax
  801483:	83 e8 37             	sub    $0x37,%eax
  801486:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801489:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80148c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80148f:	7c 02                	jl     801493 <strtol+0x148>
			break;
  801491:	eb 23                	jmp    8014b6 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801493:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801498:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80149b:	48 98                	cltq   
  80149d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014a2:	48 89 c2             	mov    %rax,%rdx
  8014a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014a8:	48 98                	cltq   
  8014aa:	48 01 d0             	add    %rdx,%rax
  8014ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014b1:	e9 5d ff ff ff       	jmpq   801413 <strtol+0xc8>

	if (endptr)
  8014b6:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014bb:	74 0b                	je     8014c8 <strtol+0x17d>
		*endptr = (char *) s;
  8014bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014c5:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014cc:	74 09                	je     8014d7 <strtol+0x18c>
  8014ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d2:	48 f7 d8             	neg    %rax
  8014d5:	eb 04                	jmp    8014db <strtol+0x190>
  8014d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014db:	c9                   	leaveq 
  8014dc:	c3                   	retq   

00000000008014dd <strstr>:

char * strstr(const char *in, const char *str)
{
  8014dd:	55                   	push   %rbp
  8014de:	48 89 e5             	mov    %rsp,%rbp
  8014e1:	48 83 ec 30          	sub    $0x30,%rsp
  8014e5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014f1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014f5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014f9:	0f b6 00             	movzbl (%rax),%eax
  8014fc:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014ff:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801503:	75 06                	jne    80150b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801505:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801509:	eb 6b                	jmp    801576 <strstr+0x99>

	len = strlen(str);
  80150b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80150f:	48 89 c7             	mov    %rax,%rdi
  801512:	48 b8 b3 0d 80 00 00 	movabs $0x800db3,%rax
  801519:	00 00 00 
  80151c:	ff d0                	callq  *%rax
  80151e:	48 98                	cltq   
  801520:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801524:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801528:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80152c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801536:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80153a:	75 07                	jne    801543 <strstr+0x66>
				return (char *) 0;
  80153c:	b8 00 00 00 00       	mov    $0x0,%eax
  801541:	eb 33                	jmp    801576 <strstr+0x99>
		} while (sc != c);
  801543:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801547:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80154a:	75 d8                	jne    801524 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80154c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801550:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801558:	48 89 ce             	mov    %rcx,%rsi
  80155b:	48 89 c7             	mov    %rax,%rdi
  80155e:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  801565:	00 00 00 
  801568:	ff d0                	callq  *%rax
  80156a:	85 c0                	test   %eax,%eax
  80156c:	75 b6                	jne    801524 <strstr+0x47>

	return (char *) (in - 1);
  80156e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801572:	48 83 e8 01          	sub    $0x1,%rax
}
  801576:	c9                   	leaveq 
  801577:	c3                   	retq   

0000000000801578 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801578:	55                   	push   %rbp
  801579:	48 89 e5             	mov    %rsp,%rbp
  80157c:	53                   	push   %rbx
  80157d:	48 83 ec 48          	sub    $0x48,%rsp
  801581:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801584:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801587:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80158b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80158f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801593:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801597:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80159a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80159e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015a2:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015a6:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015aa:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015ae:	4c 89 c3             	mov    %r8,%rbx
  8015b1:	cd 30                	int    $0x30
  8015b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015b7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015bb:	74 3e                	je     8015fb <syscall+0x83>
  8015bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015c2:	7e 37                	jle    8015fb <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015c8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015cb:	49 89 d0             	mov    %rdx,%r8
  8015ce:	89 c1                	mov    %eax,%ecx
  8015d0:	48 ba 88 3c 80 00 00 	movabs $0x803c88,%rdx
  8015d7:	00 00 00 
  8015da:	be 23 00 00 00       	mov    $0x23,%esi
  8015df:	48 bf a5 3c 80 00 00 	movabs $0x803ca5,%rdi
  8015e6:	00 00 00 
  8015e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ee:	49 b9 e9 33 80 00 00 	movabs $0x8033e9,%r9
  8015f5:	00 00 00 
  8015f8:	41 ff d1             	callq  *%r9

	return ret;
  8015fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ff:	48 83 c4 48          	add    $0x48,%rsp
  801603:	5b                   	pop    %rbx
  801604:	5d                   	pop    %rbp
  801605:	c3                   	retq   

0000000000801606 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801606:	55                   	push   %rbp
  801607:	48 89 e5             	mov    %rsp,%rbp
  80160a:	48 83 ec 20          	sub    $0x20,%rsp
  80160e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801612:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801616:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80161e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801625:	00 
  801626:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80162c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801632:	48 89 d1             	mov    %rdx,%rcx
  801635:	48 89 c2             	mov    %rax,%rdx
  801638:	be 00 00 00 00       	mov    $0x0,%esi
  80163d:	bf 00 00 00 00       	mov    $0x0,%edi
  801642:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801649:	00 00 00 
  80164c:	ff d0                	callq  *%rax
}
  80164e:	c9                   	leaveq 
  80164f:	c3                   	retq   

0000000000801650 <sys_cgetc>:

int
sys_cgetc(void)
{
  801650:	55                   	push   %rbp
  801651:	48 89 e5             	mov    %rsp,%rbp
  801654:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801658:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80165f:	00 
  801660:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801666:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80166c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801671:	ba 00 00 00 00       	mov    $0x0,%edx
  801676:	be 00 00 00 00       	mov    $0x0,%esi
  80167b:	bf 01 00 00 00       	mov    $0x1,%edi
  801680:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801687:	00 00 00 
  80168a:	ff d0                	callq  *%rax
}
  80168c:	c9                   	leaveq 
  80168d:	c3                   	retq   

000000000080168e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80168e:	55                   	push   %rbp
  80168f:	48 89 e5             	mov    %rsp,%rbp
  801692:	48 83 ec 10          	sub    $0x10,%rsp
  801696:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801699:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80169c:	48 98                	cltq   
  80169e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016a5:	00 
  8016a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b7:	48 89 c2             	mov    %rax,%rdx
  8016ba:	be 01 00 00 00       	mov    $0x1,%esi
  8016bf:	bf 03 00 00 00       	mov    $0x3,%edi
  8016c4:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  8016cb:	00 00 00 
  8016ce:	ff d0                	callq  *%rax
}
  8016d0:	c9                   	leaveq 
  8016d1:	c3                   	retq   

00000000008016d2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016d2:	55                   	push   %rbp
  8016d3:	48 89 e5             	mov    %rsp,%rbp
  8016d6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016da:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e1:	00 
  8016e2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f8:	be 00 00 00 00       	mov    $0x0,%esi
  8016fd:	bf 02 00 00 00       	mov    $0x2,%edi
  801702:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801709:	00 00 00 
  80170c:	ff d0                	callq  *%rax
}
  80170e:	c9                   	leaveq 
  80170f:	c3                   	retq   

0000000000801710 <sys_yield>:

void
sys_yield(void)
{
  801710:	55                   	push   %rbp
  801711:	48 89 e5             	mov    %rsp,%rbp
  801714:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801718:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80171f:	00 
  801720:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801726:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80172c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801731:	ba 00 00 00 00       	mov    $0x0,%edx
  801736:	be 00 00 00 00       	mov    $0x0,%esi
  80173b:	bf 0b 00 00 00       	mov    $0xb,%edi
  801740:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801747:	00 00 00 
  80174a:	ff d0                	callq  *%rax
}
  80174c:	c9                   	leaveq 
  80174d:	c3                   	retq   

000000000080174e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80174e:	55                   	push   %rbp
  80174f:	48 89 e5             	mov    %rsp,%rbp
  801752:	48 83 ec 20          	sub    $0x20,%rsp
  801756:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801759:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80175d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801760:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801763:	48 63 c8             	movslq %eax,%rcx
  801766:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80176a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80176d:	48 98                	cltq   
  80176f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801776:	00 
  801777:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80177d:	49 89 c8             	mov    %rcx,%r8
  801780:	48 89 d1             	mov    %rdx,%rcx
  801783:	48 89 c2             	mov    %rax,%rdx
  801786:	be 01 00 00 00       	mov    $0x1,%esi
  80178b:	bf 04 00 00 00       	mov    $0x4,%edi
  801790:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801797:	00 00 00 
  80179a:	ff d0                	callq  *%rax
}
  80179c:	c9                   	leaveq 
  80179d:	c3                   	retq   

000000000080179e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80179e:	55                   	push   %rbp
  80179f:	48 89 e5             	mov    %rsp,%rbp
  8017a2:	48 83 ec 30          	sub    $0x30,%rsp
  8017a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017ad:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017b0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017b4:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017b8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017bb:	48 63 c8             	movslq %eax,%rcx
  8017be:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017c5:	48 63 f0             	movslq %eax,%rsi
  8017c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017cf:	48 98                	cltq   
  8017d1:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017d5:	49 89 f9             	mov    %rdi,%r9
  8017d8:	49 89 f0             	mov    %rsi,%r8
  8017db:	48 89 d1             	mov    %rdx,%rcx
  8017de:	48 89 c2             	mov    %rax,%rdx
  8017e1:	be 01 00 00 00       	mov    $0x1,%esi
  8017e6:	bf 05 00 00 00       	mov    $0x5,%edi
  8017eb:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  8017f2:	00 00 00 
  8017f5:	ff d0                	callq  *%rax
}
  8017f7:	c9                   	leaveq 
  8017f8:	c3                   	retq   

00000000008017f9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017f9:	55                   	push   %rbp
  8017fa:	48 89 e5             	mov    %rsp,%rbp
  8017fd:	48 83 ec 20          	sub    $0x20,%rsp
  801801:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801804:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801808:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80180c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80180f:	48 98                	cltq   
  801811:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801818:	00 
  801819:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80181f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801825:	48 89 d1             	mov    %rdx,%rcx
  801828:	48 89 c2             	mov    %rax,%rdx
  80182b:	be 01 00 00 00       	mov    $0x1,%esi
  801830:	bf 06 00 00 00       	mov    $0x6,%edi
  801835:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  80183c:	00 00 00 
  80183f:	ff d0                	callq  *%rax
}
  801841:	c9                   	leaveq 
  801842:	c3                   	retq   

0000000000801843 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801843:	55                   	push   %rbp
  801844:	48 89 e5             	mov    %rsp,%rbp
  801847:	48 83 ec 10          	sub    $0x10,%rsp
  80184b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80184e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801851:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801854:	48 63 d0             	movslq %eax,%rdx
  801857:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80185a:	48 98                	cltq   
  80185c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801863:	00 
  801864:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801870:	48 89 d1             	mov    %rdx,%rcx
  801873:	48 89 c2             	mov    %rax,%rdx
  801876:	be 01 00 00 00       	mov    $0x1,%esi
  80187b:	bf 08 00 00 00       	mov    $0x8,%edi
  801880:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801887:	00 00 00 
  80188a:	ff d0                	callq  *%rax
}
  80188c:	c9                   	leaveq 
  80188d:	c3                   	retq   

000000000080188e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80188e:	55                   	push   %rbp
  80188f:	48 89 e5             	mov    %rsp,%rbp
  801892:	48 83 ec 20          	sub    $0x20,%rsp
  801896:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801899:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80189d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a4:	48 98                	cltq   
  8018a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ad:	00 
  8018ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ba:	48 89 d1             	mov    %rdx,%rcx
  8018bd:	48 89 c2             	mov    %rax,%rdx
  8018c0:	be 01 00 00 00       	mov    $0x1,%esi
  8018c5:	bf 09 00 00 00       	mov    $0x9,%edi
  8018ca:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  8018d1:	00 00 00 
  8018d4:	ff d0                	callq  *%rax
}
  8018d6:	c9                   	leaveq 
  8018d7:	c3                   	retq   

00000000008018d8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018d8:	55                   	push   %rbp
  8018d9:	48 89 e5             	mov    %rsp,%rbp
  8018dc:	48 83 ec 20          	sub    $0x20,%rsp
  8018e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ee:	48 98                	cltq   
  8018f0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f7:	00 
  8018f8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801904:	48 89 d1             	mov    %rdx,%rcx
  801907:	48 89 c2             	mov    %rax,%rdx
  80190a:	be 01 00 00 00       	mov    $0x1,%esi
  80190f:	bf 0a 00 00 00       	mov    $0xa,%edi
  801914:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  80191b:	00 00 00 
  80191e:	ff d0                	callq  *%rax
}
  801920:	c9                   	leaveq 
  801921:	c3                   	retq   

0000000000801922 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801922:	55                   	push   %rbp
  801923:	48 89 e5             	mov    %rsp,%rbp
  801926:	48 83 ec 20          	sub    $0x20,%rsp
  80192a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801931:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801935:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801938:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80193b:	48 63 f0             	movslq %eax,%rsi
  80193e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801942:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801945:	48 98                	cltq   
  801947:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80194b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801952:	00 
  801953:	49 89 f1             	mov    %rsi,%r9
  801956:	49 89 c8             	mov    %rcx,%r8
  801959:	48 89 d1             	mov    %rdx,%rcx
  80195c:	48 89 c2             	mov    %rax,%rdx
  80195f:	be 00 00 00 00       	mov    $0x0,%esi
  801964:	bf 0c 00 00 00       	mov    $0xc,%edi
  801969:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801970:	00 00 00 
  801973:	ff d0                	callq  *%rax
}
  801975:	c9                   	leaveq 
  801976:	c3                   	retq   

0000000000801977 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801977:	55                   	push   %rbp
  801978:	48 89 e5             	mov    %rsp,%rbp
  80197b:	48 83 ec 10          	sub    $0x10,%rsp
  80197f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801983:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801987:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80198e:	00 
  80198f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801995:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80199b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a0:	48 89 c2             	mov    %rax,%rdx
  8019a3:	be 01 00 00 00       	mov    $0x1,%esi
  8019a8:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019ad:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  8019b4:	00 00 00 
  8019b7:	ff d0                	callq  *%rax
}
  8019b9:	c9                   	leaveq 
  8019ba:	c3                   	retq   

00000000008019bb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8019bb:	55                   	push   %rbp
  8019bc:	48 89 e5             	mov    %rsp,%rbp
  8019bf:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8019c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ca:	00 
  8019cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e1:	be 00 00 00 00       	mov    $0x0,%esi
  8019e6:	bf 0e 00 00 00       	mov    $0xe,%edi
  8019eb:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  8019f2:	00 00 00 
  8019f5:	ff d0                	callq  *%rax
}
  8019f7:	c9                   	leaveq 
  8019f8:	c3                   	retq   

00000000008019f9 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8019f9:	55                   	push   %rbp
  8019fa:	48 89 e5             	mov    %rsp,%rbp
  8019fd:	48 83 ec 30          	sub    $0x30,%rsp
  801a01:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a04:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a08:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a0b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a0f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801a13:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a16:	48 63 c8             	movslq %eax,%rcx
  801a19:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a20:	48 63 f0             	movslq %eax,%rsi
  801a23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2a:	48 98                	cltq   
  801a2c:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a30:	49 89 f9             	mov    %rdi,%r9
  801a33:	49 89 f0             	mov    %rsi,%r8
  801a36:	48 89 d1             	mov    %rdx,%rcx
  801a39:	48 89 c2             	mov    %rax,%rdx
  801a3c:	be 00 00 00 00       	mov    $0x0,%esi
  801a41:	bf 0f 00 00 00       	mov    $0xf,%edi
  801a46:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801a4d:	00 00 00 
  801a50:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801a52:	c9                   	leaveq 
  801a53:	c3                   	retq   

0000000000801a54 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801a54:	55                   	push   %rbp
  801a55:	48 89 e5             	mov    %rsp,%rbp
  801a58:	48 83 ec 20          	sub    $0x20,%rsp
  801a5c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801a64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a73:	00 
  801a74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a80:	48 89 d1             	mov    %rdx,%rcx
  801a83:	48 89 c2             	mov    %rax,%rdx
  801a86:	be 00 00 00 00       	mov    $0x0,%esi
  801a8b:	bf 10 00 00 00       	mov    $0x10,%edi
  801a90:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801a97:	00 00 00 
  801a9a:	ff d0                	callq  *%rax
}
  801a9c:	c9                   	leaveq 
  801a9d:	c3                   	retq   

0000000000801a9e <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801a9e:	55                   	push   %rbp
  801a9f:	48 89 e5             	mov    %rsp,%rbp
  801aa2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801aa6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aad:	00 
  801aae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aba:	b9 00 00 00 00       	mov    $0x0,%ecx
  801abf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac4:	be 00 00 00 00       	mov    $0x0,%esi
  801ac9:	bf 11 00 00 00       	mov    $0x11,%edi
  801ace:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801ad5:	00 00 00 
  801ad8:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801ada:	c9                   	leaveq 
  801adb:	c3                   	retq   

0000000000801adc <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801adc:	55                   	push   %rbp
  801add:	48 89 e5             	mov    %rsp,%rbp
  801ae0:	48 83 ec 10          	sub    $0x10,%rsp
  801ae4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801ae7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aea:	48 98                	cltq   
  801aec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af3:	00 
  801af4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801afa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b00:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b05:	48 89 c2             	mov    %rax,%rdx
  801b08:	be 00 00 00 00       	mov    $0x0,%esi
  801b0d:	bf 12 00 00 00       	mov    $0x12,%edi
  801b12:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801b19:	00 00 00 
  801b1c:	ff d0                	callq  *%rax
}
  801b1e:	c9                   	leaveq 
  801b1f:	c3                   	retq   

0000000000801b20 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801b20:	55                   	push   %rbp
  801b21:	48 89 e5             	mov    %rsp,%rbp
  801b24:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801b28:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2f:	00 
  801b30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b41:	ba 00 00 00 00       	mov    $0x0,%edx
  801b46:	be 00 00 00 00       	mov    $0x0,%esi
  801b4b:	bf 13 00 00 00       	mov    $0x13,%edi
  801b50:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801b57:	00 00 00 
  801b5a:	ff d0                	callq  *%rax
}
  801b5c:	c9                   	leaveq 
  801b5d:	c3                   	retq   

0000000000801b5e <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801b5e:	55                   	push   %rbp
  801b5f:	48 89 e5             	mov    %rsp,%rbp
  801b62:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801b66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6d:	00 
  801b6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b84:	be 00 00 00 00       	mov    $0x0,%esi
  801b89:	bf 14 00 00 00       	mov    $0x14,%edi
  801b8e:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  801b95:	00 00 00 
  801b98:	ff d0                	callq  *%rax
}
  801b9a:	c9                   	leaveq 
  801b9b:	c3                   	retq   

0000000000801b9c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801b9c:	55                   	push   %rbp
  801b9d:	48 89 e5             	mov    %rsp,%rbp
  801ba0:	48 83 ec 08          	sub    $0x8,%rsp
  801ba4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ba8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bac:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801bb3:	ff ff ff 
  801bb6:	48 01 d0             	add    %rdx,%rax
  801bb9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801bbd:	c9                   	leaveq 
  801bbe:	c3                   	retq   

0000000000801bbf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801bbf:	55                   	push   %rbp
  801bc0:	48 89 e5             	mov    %rsp,%rbp
  801bc3:	48 83 ec 08          	sub    $0x8,%rsp
  801bc7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801bcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bcf:	48 89 c7             	mov    %rax,%rdi
  801bd2:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	callq  *%rax
  801bde:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801be4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801be8:	c9                   	leaveq 
  801be9:	c3                   	retq   

0000000000801bea <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801bea:	55                   	push   %rbp
  801beb:	48 89 e5             	mov    %rsp,%rbp
  801bee:	48 83 ec 18          	sub    $0x18,%rsp
  801bf2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801bf6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801bfd:	eb 6b                	jmp    801c6a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801bff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c02:	48 98                	cltq   
  801c04:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c0a:	48 c1 e0 0c          	shl    $0xc,%rax
  801c0e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c16:	48 c1 e8 15          	shr    $0x15,%rax
  801c1a:	48 89 c2             	mov    %rax,%rdx
  801c1d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c24:	01 00 00 
  801c27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c2b:	83 e0 01             	and    $0x1,%eax
  801c2e:	48 85 c0             	test   %rax,%rax
  801c31:	74 21                	je     801c54 <fd_alloc+0x6a>
  801c33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c37:	48 c1 e8 0c          	shr    $0xc,%rax
  801c3b:	48 89 c2             	mov    %rax,%rdx
  801c3e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c45:	01 00 00 
  801c48:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c4c:	83 e0 01             	and    $0x1,%eax
  801c4f:	48 85 c0             	test   %rax,%rax
  801c52:	75 12                	jne    801c66 <fd_alloc+0x7c>
			*fd_store = fd;
  801c54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c5c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c64:	eb 1a                	jmp    801c80 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c66:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c6a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801c6e:	7e 8f                	jle    801bff <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c74:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801c7b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c80:	c9                   	leaveq 
  801c81:	c3                   	retq   

0000000000801c82 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c82:	55                   	push   %rbp
  801c83:	48 89 e5             	mov    %rsp,%rbp
  801c86:	48 83 ec 20          	sub    $0x20,%rsp
  801c8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c91:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c95:	78 06                	js     801c9d <fd_lookup+0x1b>
  801c97:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801c9b:	7e 07                	jle    801ca4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ca2:	eb 6c                	jmp    801d10 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ca4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ca7:	48 98                	cltq   
  801ca9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801caf:	48 c1 e0 0c          	shl    $0xc,%rax
  801cb3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801cb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbb:	48 c1 e8 15          	shr    $0x15,%rax
  801cbf:	48 89 c2             	mov    %rax,%rdx
  801cc2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801cc9:	01 00 00 
  801ccc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cd0:	83 e0 01             	and    $0x1,%eax
  801cd3:	48 85 c0             	test   %rax,%rax
  801cd6:	74 21                	je     801cf9 <fd_lookup+0x77>
  801cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cdc:	48 c1 e8 0c          	shr    $0xc,%rax
  801ce0:	48 89 c2             	mov    %rax,%rdx
  801ce3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cea:	01 00 00 
  801ced:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cf1:	83 e0 01             	and    $0x1,%eax
  801cf4:	48 85 c0             	test   %rax,%rax
  801cf7:	75 07                	jne    801d00 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801cf9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cfe:	eb 10                	jmp    801d10 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d04:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d08:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d10:	c9                   	leaveq 
  801d11:	c3                   	retq   

0000000000801d12 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d12:	55                   	push   %rbp
  801d13:	48 89 e5             	mov    %rsp,%rbp
  801d16:	48 83 ec 30          	sub    $0x30,%rsp
  801d1a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d1e:	89 f0                	mov    %esi,%eax
  801d20:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801d23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d27:	48 89 c7             	mov    %rax,%rdi
  801d2a:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  801d31:	00 00 00 
  801d34:	ff d0                	callq  *%rax
  801d36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d3a:	48 89 d6             	mov    %rdx,%rsi
  801d3d:	89 c7                	mov    %eax,%edi
  801d3f:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  801d46:	00 00 00 
  801d49:	ff d0                	callq  *%rax
  801d4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d52:	78 0a                	js     801d5e <fd_close+0x4c>
	    || fd != fd2)
  801d54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d58:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801d5c:	74 12                	je     801d70 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801d5e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801d62:	74 05                	je     801d69 <fd_close+0x57>
  801d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d67:	eb 05                	jmp    801d6e <fd_close+0x5c>
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6e:	eb 69                	jmp    801dd9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d74:	8b 00                	mov    (%rax),%eax
  801d76:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d7a:	48 89 d6             	mov    %rdx,%rsi
  801d7d:	89 c7                	mov    %eax,%edi
  801d7f:	48 b8 db 1d 80 00 00 	movabs $0x801ddb,%rax
  801d86:	00 00 00 
  801d89:	ff d0                	callq  *%rax
  801d8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d92:	78 2a                	js     801dbe <fd_close+0xac>
		if (dev->dev_close)
  801d94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d98:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d9c:	48 85 c0             	test   %rax,%rax
  801d9f:	74 16                	je     801db7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801da1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801da5:	48 8b 40 20          	mov    0x20(%rax),%rax
  801da9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801dad:	48 89 d7             	mov    %rdx,%rdi
  801db0:	ff d0                	callq  *%rax
  801db2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801db5:	eb 07                	jmp    801dbe <fd_close+0xac>
		else
			r = 0;
  801db7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801dbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc2:	48 89 c6             	mov    %rax,%rsi
  801dc5:	bf 00 00 00 00       	mov    $0x0,%edi
  801dca:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  801dd1:	00 00 00 
  801dd4:	ff d0                	callq  *%rax
	return r;
  801dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801dd9:	c9                   	leaveq 
  801dda:	c3                   	retq   

0000000000801ddb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ddb:	55                   	push   %rbp
  801ddc:	48 89 e5             	mov    %rsp,%rbp
  801ddf:	48 83 ec 20          	sub    $0x20,%rsp
  801de3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801de6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801dea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801df1:	eb 41                	jmp    801e34 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801df3:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801dfa:	00 00 00 
  801dfd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e00:	48 63 d2             	movslq %edx,%rdx
  801e03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e07:	8b 00                	mov    (%rax),%eax
  801e09:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e0c:	75 22                	jne    801e30 <dev_lookup+0x55>
			*dev = devtab[i];
  801e0e:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e15:	00 00 00 
  801e18:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e1b:	48 63 d2             	movslq %edx,%rdx
  801e1e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801e22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e26:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2e:	eb 60                	jmp    801e90 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801e30:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e34:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e3b:	00 00 00 
  801e3e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e41:	48 63 d2             	movslq %edx,%rdx
  801e44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e48:	48 85 c0             	test   %rax,%rax
  801e4b:	75 a6                	jne    801df3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e4d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801e54:	00 00 00 
  801e57:	48 8b 00             	mov    (%rax),%rax
  801e5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801e60:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e63:	89 c6                	mov    %eax,%esi
  801e65:	48 bf b8 3c 80 00 00 	movabs $0x803cb8,%rdi
  801e6c:	00 00 00 
  801e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e74:	48 b9 6a 02 80 00 00 	movabs $0x80026a,%rcx
  801e7b:	00 00 00 
  801e7e:	ff d1                	callq  *%rcx
	*dev = 0;
  801e80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e84:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801e8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e90:	c9                   	leaveq 
  801e91:	c3                   	retq   

0000000000801e92 <close>:

int
close(int fdnum)
{
  801e92:	55                   	push   %rbp
  801e93:	48 89 e5             	mov    %rsp,%rbp
  801e96:	48 83 ec 20          	sub    $0x20,%rsp
  801e9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e9d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ea1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ea4:	48 89 d6             	mov    %rdx,%rsi
  801ea7:	89 c7                	mov    %eax,%edi
  801ea9:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  801eb0:	00 00 00 
  801eb3:	ff d0                	callq  *%rax
  801eb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ebc:	79 05                	jns    801ec3 <close+0x31>
		return r;
  801ebe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec1:	eb 18                	jmp    801edb <close+0x49>
	else
		return fd_close(fd, 1);
  801ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec7:	be 01 00 00 00       	mov    $0x1,%esi
  801ecc:	48 89 c7             	mov    %rax,%rdi
  801ecf:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801ed6:	00 00 00 
  801ed9:	ff d0                	callq  *%rax
}
  801edb:	c9                   	leaveq 
  801edc:	c3                   	retq   

0000000000801edd <close_all>:

void
close_all(void)
{
  801edd:	55                   	push   %rbp
  801ede:	48 89 e5             	mov    %rsp,%rbp
  801ee1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ee5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801eec:	eb 15                	jmp    801f03 <close_all+0x26>
		close(i);
  801eee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef1:	89 c7                	mov    %eax,%edi
  801ef3:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  801efa:	00 00 00 
  801efd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801eff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f03:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f07:	7e e5                	jle    801eee <close_all+0x11>
		close(i);
}
  801f09:	c9                   	leaveq 
  801f0a:	c3                   	retq   

0000000000801f0b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f0b:	55                   	push   %rbp
  801f0c:	48 89 e5             	mov    %rsp,%rbp
  801f0f:	48 83 ec 40          	sub    $0x40,%rsp
  801f13:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f16:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f19:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801f1d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f20:	48 89 d6             	mov    %rdx,%rsi
  801f23:	89 c7                	mov    %eax,%edi
  801f25:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  801f2c:	00 00 00 
  801f2f:	ff d0                	callq  *%rax
  801f31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f38:	79 08                	jns    801f42 <dup+0x37>
		return r;
  801f3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f3d:	e9 70 01 00 00       	jmpq   8020b2 <dup+0x1a7>
	close(newfdnum);
  801f42:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f45:	89 c7                	mov    %eax,%edi
  801f47:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  801f4e:	00 00 00 
  801f51:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801f53:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f56:	48 98                	cltq   
  801f58:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f5e:	48 c1 e0 0c          	shl    $0xc,%rax
  801f62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801f66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f6a:	48 89 c7             	mov    %rax,%rdi
  801f6d:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801f74:	00 00 00 
  801f77:	ff d0                	callq  *%rax
  801f79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801f7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f81:	48 89 c7             	mov    %rax,%rdi
  801f84:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801f8b:	00 00 00 
  801f8e:	ff d0                	callq  *%rax
  801f90:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f98:	48 c1 e8 15          	shr    $0x15,%rax
  801f9c:	48 89 c2             	mov    %rax,%rdx
  801f9f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa6:	01 00 00 
  801fa9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fad:	83 e0 01             	and    $0x1,%eax
  801fb0:	48 85 c0             	test   %rax,%rax
  801fb3:	74 73                	je     802028 <dup+0x11d>
  801fb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb9:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbd:	48 89 c2             	mov    %rax,%rdx
  801fc0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc7:	01 00 00 
  801fca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fce:	83 e0 01             	and    $0x1,%eax
  801fd1:	48 85 c0             	test   %rax,%rax
  801fd4:	74 52                	je     802028 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fda:	48 c1 e8 0c          	shr    $0xc,%rax
  801fde:	48 89 c2             	mov    %rax,%rdx
  801fe1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fe8:	01 00 00 
  801feb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fef:	25 07 0e 00 00       	and    $0xe07,%eax
  801ff4:	89 c1                	mov    %eax,%ecx
  801ff6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801ffa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ffe:	41 89 c8             	mov    %ecx,%r8d
  802001:	48 89 d1             	mov    %rdx,%rcx
  802004:	ba 00 00 00 00       	mov    $0x0,%edx
  802009:	48 89 c6             	mov    %rax,%rsi
  80200c:	bf 00 00 00 00       	mov    $0x0,%edi
  802011:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  802018:	00 00 00 
  80201b:	ff d0                	callq  *%rax
  80201d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802020:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802024:	79 02                	jns    802028 <dup+0x11d>
			goto err;
  802026:	eb 57                	jmp    80207f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802028:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80202c:	48 c1 e8 0c          	shr    $0xc,%rax
  802030:	48 89 c2             	mov    %rax,%rdx
  802033:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80203a:	01 00 00 
  80203d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802041:	25 07 0e 00 00       	and    $0xe07,%eax
  802046:	89 c1                	mov    %eax,%ecx
  802048:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802050:	41 89 c8             	mov    %ecx,%r8d
  802053:	48 89 d1             	mov    %rdx,%rcx
  802056:	ba 00 00 00 00       	mov    $0x0,%edx
  80205b:	48 89 c6             	mov    %rax,%rsi
  80205e:	bf 00 00 00 00       	mov    $0x0,%edi
  802063:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  80206a:	00 00 00 
  80206d:	ff d0                	callq  *%rax
  80206f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802072:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802076:	79 02                	jns    80207a <dup+0x16f>
		goto err;
  802078:	eb 05                	jmp    80207f <dup+0x174>

	return newfdnum;
  80207a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80207d:	eb 33                	jmp    8020b2 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80207f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802083:	48 89 c6             	mov    %rax,%rsi
  802086:	bf 00 00 00 00       	mov    $0x0,%edi
  80208b:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  802092:	00 00 00 
  802095:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802097:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80209b:	48 89 c6             	mov    %rax,%rsi
  80209e:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a3:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	callq  *%rax
	return r;
  8020af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b2:	c9                   	leaveq 
  8020b3:	c3                   	retq   

00000000008020b4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8020b4:	55                   	push   %rbp
  8020b5:	48 89 e5             	mov    %rsp,%rbp
  8020b8:	48 83 ec 40          	sub    $0x40,%rsp
  8020bc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8020bf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8020c3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020c7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020cb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020ce:	48 89 d6             	mov    %rdx,%rsi
  8020d1:	89 c7                	mov    %eax,%edi
  8020d3:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  8020da:	00 00 00 
  8020dd:	ff d0                	callq  *%rax
  8020df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e6:	78 24                	js     80210c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ec:	8b 00                	mov    (%rax),%eax
  8020ee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020f2:	48 89 d6             	mov    %rdx,%rsi
  8020f5:	89 c7                	mov    %eax,%edi
  8020f7:	48 b8 db 1d 80 00 00 	movabs $0x801ddb,%rax
  8020fe:	00 00 00 
  802101:	ff d0                	callq  *%rax
  802103:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802106:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80210a:	79 05                	jns    802111 <read+0x5d>
		return r;
  80210c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80210f:	eb 76                	jmp    802187 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802115:	8b 40 08             	mov    0x8(%rax),%eax
  802118:	83 e0 03             	and    $0x3,%eax
  80211b:	83 f8 01             	cmp    $0x1,%eax
  80211e:	75 3a                	jne    80215a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802120:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802127:	00 00 00 
  80212a:	48 8b 00             	mov    (%rax),%rax
  80212d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802133:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802136:	89 c6                	mov    %eax,%esi
  802138:	48 bf d7 3c 80 00 00 	movabs $0x803cd7,%rdi
  80213f:	00 00 00 
  802142:	b8 00 00 00 00       	mov    $0x0,%eax
  802147:	48 b9 6a 02 80 00 00 	movabs $0x80026a,%rcx
  80214e:	00 00 00 
  802151:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802153:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802158:	eb 2d                	jmp    802187 <read+0xd3>
	}
	if (!dev->dev_read)
  80215a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80215e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802162:	48 85 c0             	test   %rax,%rax
  802165:	75 07                	jne    80216e <read+0xba>
		return -E_NOT_SUPP;
  802167:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80216c:	eb 19                	jmp    802187 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80216e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802172:	48 8b 40 10          	mov    0x10(%rax),%rax
  802176:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80217a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80217e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802182:	48 89 cf             	mov    %rcx,%rdi
  802185:	ff d0                	callq  *%rax
}
  802187:	c9                   	leaveq 
  802188:	c3                   	retq   

0000000000802189 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802189:	55                   	push   %rbp
  80218a:	48 89 e5             	mov    %rsp,%rbp
  80218d:	48 83 ec 30          	sub    $0x30,%rsp
  802191:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802194:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802198:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80219c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021a3:	eb 49                	jmp    8021ee <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8021a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a8:	48 98                	cltq   
  8021aa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021ae:	48 29 c2             	sub    %rax,%rdx
  8021b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b4:	48 63 c8             	movslq %eax,%rcx
  8021b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021bb:	48 01 c1             	add    %rax,%rcx
  8021be:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021c1:	48 89 ce             	mov    %rcx,%rsi
  8021c4:	89 c7                	mov    %eax,%edi
  8021c6:	48 b8 b4 20 80 00 00 	movabs $0x8020b4,%rax
  8021cd:	00 00 00 
  8021d0:	ff d0                	callq  *%rax
  8021d2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8021d5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021d9:	79 05                	jns    8021e0 <readn+0x57>
			return m;
  8021db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021de:	eb 1c                	jmp    8021fc <readn+0x73>
		if (m == 0)
  8021e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021e4:	75 02                	jne    8021e8 <readn+0x5f>
			break;
  8021e6:	eb 11                	jmp    8021f9 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8021e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021eb:	01 45 fc             	add    %eax,-0x4(%rbp)
  8021ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f1:	48 98                	cltq   
  8021f3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8021f7:	72 ac                	jb     8021a5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8021f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021fc:	c9                   	leaveq 
  8021fd:	c3                   	retq   

00000000008021fe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8021fe:	55                   	push   %rbp
  8021ff:	48 89 e5             	mov    %rsp,%rbp
  802202:	48 83 ec 40          	sub    $0x40,%rsp
  802206:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802209:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80220d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802211:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802215:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802218:	48 89 d6             	mov    %rdx,%rsi
  80221b:	89 c7                	mov    %eax,%edi
  80221d:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  802224:	00 00 00 
  802227:	ff d0                	callq  *%rax
  802229:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80222c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802230:	78 24                	js     802256 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802232:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802236:	8b 00                	mov    (%rax),%eax
  802238:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80223c:	48 89 d6             	mov    %rdx,%rsi
  80223f:	89 c7                	mov    %eax,%edi
  802241:	48 b8 db 1d 80 00 00 	movabs $0x801ddb,%rax
  802248:	00 00 00 
  80224b:	ff d0                	callq  *%rax
  80224d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802250:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802254:	79 05                	jns    80225b <write+0x5d>
		return r;
  802256:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802259:	eb 42                	jmp    80229d <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80225b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225f:	8b 40 08             	mov    0x8(%rax),%eax
  802262:	83 e0 03             	and    $0x3,%eax
  802265:	85 c0                	test   %eax,%eax
  802267:	75 07                	jne    802270 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802269:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80226e:	eb 2d                	jmp    80229d <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802274:	48 8b 40 18          	mov    0x18(%rax),%rax
  802278:	48 85 c0             	test   %rax,%rax
  80227b:	75 07                	jne    802284 <write+0x86>
		return -E_NOT_SUPP;
  80227d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802282:	eb 19                	jmp    80229d <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802284:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802288:	48 8b 40 18          	mov    0x18(%rax),%rax
  80228c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802290:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802294:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802298:	48 89 cf             	mov    %rcx,%rdi
  80229b:	ff d0                	callq  *%rax
}
  80229d:	c9                   	leaveq 
  80229e:	c3                   	retq   

000000000080229f <seek>:

int
seek(int fdnum, off_t offset)
{
  80229f:	55                   	push   %rbp
  8022a0:	48 89 e5             	mov    %rsp,%rbp
  8022a3:	48 83 ec 18          	sub    $0x18,%rsp
  8022a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022aa:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022b4:	48 89 d6             	mov    %rdx,%rsi
  8022b7:	89 c7                	mov    %eax,%edi
  8022b9:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  8022c0:	00 00 00 
  8022c3:	ff d0                	callq  *%rax
  8022c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022cc:	79 05                	jns    8022d3 <seek+0x34>
		return r;
  8022ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d1:	eb 0f                	jmp    8022e2 <seek+0x43>
	fd->fd_offset = offset;
  8022d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8022da:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8022dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e2:	c9                   	leaveq 
  8022e3:	c3                   	retq   

00000000008022e4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022e4:	55                   	push   %rbp
  8022e5:	48 89 e5             	mov    %rsp,%rbp
  8022e8:	48 83 ec 30          	sub    $0x30,%rsp
  8022ec:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ef:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022f2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022f9:	48 89 d6             	mov    %rdx,%rsi
  8022fc:	89 c7                	mov    %eax,%edi
  8022fe:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  802305:	00 00 00 
  802308:	ff d0                	callq  *%rax
  80230a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80230d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802311:	78 24                	js     802337 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802317:	8b 00                	mov    (%rax),%eax
  802319:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80231d:	48 89 d6             	mov    %rdx,%rsi
  802320:	89 c7                	mov    %eax,%edi
  802322:	48 b8 db 1d 80 00 00 	movabs $0x801ddb,%rax
  802329:	00 00 00 
  80232c:	ff d0                	callq  *%rax
  80232e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802331:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802335:	79 05                	jns    80233c <ftruncate+0x58>
		return r;
  802337:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233a:	eb 72                	jmp    8023ae <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80233c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802340:	8b 40 08             	mov    0x8(%rax),%eax
  802343:	83 e0 03             	and    $0x3,%eax
  802346:	85 c0                	test   %eax,%eax
  802348:	75 3a                	jne    802384 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80234a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802351:	00 00 00 
  802354:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802357:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80235d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802360:	89 c6                	mov    %eax,%esi
  802362:	48 bf f8 3c 80 00 00 	movabs $0x803cf8,%rdi
  802369:	00 00 00 
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
  802371:	48 b9 6a 02 80 00 00 	movabs $0x80026a,%rcx
  802378:	00 00 00 
  80237b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80237d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802382:	eb 2a                	jmp    8023ae <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802388:	48 8b 40 30          	mov    0x30(%rax),%rax
  80238c:	48 85 c0             	test   %rax,%rax
  80238f:	75 07                	jne    802398 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802391:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802396:	eb 16                	jmp    8023ae <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802398:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239c:	48 8b 40 30          	mov    0x30(%rax),%rax
  8023a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023a4:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8023a7:	89 ce                	mov    %ecx,%esi
  8023a9:	48 89 d7             	mov    %rdx,%rdi
  8023ac:	ff d0                	callq  *%rax
}
  8023ae:	c9                   	leaveq 
  8023af:	c3                   	retq   

00000000008023b0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8023b0:	55                   	push   %rbp
  8023b1:	48 89 e5             	mov    %rsp,%rbp
  8023b4:	48 83 ec 30          	sub    $0x30,%rsp
  8023b8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023bf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023c3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023c6:	48 89 d6             	mov    %rdx,%rsi
  8023c9:	89 c7                	mov    %eax,%edi
  8023cb:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	callq  *%rax
  8023d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023de:	78 24                	js     802404 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e4:	8b 00                	mov    (%rax),%eax
  8023e6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ea:	48 89 d6             	mov    %rdx,%rsi
  8023ed:	89 c7                	mov    %eax,%edi
  8023ef:	48 b8 db 1d 80 00 00 	movabs $0x801ddb,%rax
  8023f6:	00 00 00 
  8023f9:	ff d0                	callq  *%rax
  8023fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802402:	79 05                	jns    802409 <fstat+0x59>
		return r;
  802404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802407:	eb 5e                	jmp    802467 <fstat+0xb7>
	if (!dev->dev_stat)
  802409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80240d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802411:	48 85 c0             	test   %rax,%rax
  802414:	75 07                	jne    80241d <fstat+0x6d>
		return -E_NOT_SUPP;
  802416:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80241b:	eb 4a                	jmp    802467 <fstat+0xb7>
	stat->st_name[0] = 0;
  80241d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802421:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802424:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802428:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80242f:	00 00 00 
	stat->st_isdir = 0;
  802432:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802436:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80243d:	00 00 00 
	stat->st_dev = dev;
  802440:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802444:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802448:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80244f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802453:	48 8b 40 28          	mov    0x28(%rax),%rax
  802457:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80245b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80245f:	48 89 ce             	mov    %rcx,%rsi
  802462:	48 89 d7             	mov    %rdx,%rdi
  802465:	ff d0                	callq  *%rax
}
  802467:	c9                   	leaveq 
  802468:	c3                   	retq   

0000000000802469 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802469:	55                   	push   %rbp
  80246a:	48 89 e5             	mov    %rsp,%rbp
  80246d:	48 83 ec 20          	sub    $0x20,%rsp
  802471:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802475:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80247d:	be 00 00 00 00       	mov    $0x0,%esi
  802482:	48 89 c7             	mov    %rax,%rdi
  802485:	48 b8 57 25 80 00 00 	movabs $0x802557,%rax
  80248c:	00 00 00 
  80248f:	ff d0                	callq  *%rax
  802491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802498:	79 05                	jns    80249f <stat+0x36>
		return fd;
  80249a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80249d:	eb 2f                	jmp    8024ce <stat+0x65>
	r = fstat(fd, stat);
  80249f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8024a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a6:	48 89 d6             	mov    %rdx,%rsi
  8024a9:	89 c7                	mov    %eax,%edi
  8024ab:	48 b8 b0 23 80 00 00 	movabs $0x8023b0,%rax
  8024b2:	00 00 00 
  8024b5:	ff d0                	callq  *%rax
  8024b7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8024ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bd:	89 c7                	mov    %eax,%edi
  8024bf:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  8024c6:	00 00 00 
  8024c9:	ff d0                	callq  *%rax
	return r;
  8024cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8024ce:	c9                   	leaveq 
  8024cf:	c3                   	retq   

00000000008024d0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8024d0:	55                   	push   %rbp
  8024d1:	48 89 e5             	mov    %rsp,%rbp
  8024d4:	48 83 ec 10          	sub    $0x10,%rsp
  8024d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8024df:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8024e6:	00 00 00 
  8024e9:	8b 00                	mov    (%rax),%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	75 1d                	jne    80250c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8024ef:	bf 01 00 00 00       	mov    $0x1,%edi
  8024f4:	48 b8 83 36 80 00 00 	movabs $0x803683,%rax
  8024fb:	00 00 00 
  8024fe:	ff d0                	callq  *%rax
  802500:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802507:	00 00 00 
  80250a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80250c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802513:	00 00 00 
  802516:	8b 00                	mov    (%rax),%eax
  802518:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80251b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802520:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802527:	00 00 00 
  80252a:	89 c7                	mov    %eax,%edi
  80252c:	48 b8 fb 35 80 00 00 	movabs $0x8035fb,%rax
  802533:	00 00 00 
  802536:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802538:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253c:	ba 00 00 00 00       	mov    $0x0,%edx
  802541:	48 89 c6             	mov    %rax,%rsi
  802544:	bf 00 00 00 00       	mov    $0x0,%edi
  802549:	48 b8 fd 34 80 00 00 	movabs $0x8034fd,%rax
  802550:	00 00 00 
  802553:	ff d0                	callq  *%rax
}
  802555:	c9                   	leaveq 
  802556:	c3                   	retq   

0000000000802557 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802557:	55                   	push   %rbp
  802558:	48 89 e5             	mov    %rsp,%rbp
  80255b:	48 83 ec 30          	sub    $0x30,%rsp
  80255f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802563:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802566:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80256d:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802574:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80257b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802580:	75 08                	jne    80258a <open+0x33>
	{
		return r;
  802582:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802585:	e9 f2 00 00 00       	jmpq   80267c <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80258a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80258e:	48 89 c7             	mov    %rax,%rdi
  802591:	48 b8 b3 0d 80 00 00 	movabs $0x800db3,%rax
  802598:	00 00 00 
  80259b:	ff d0                	callq  *%rax
  80259d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8025a0:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8025a7:	7e 0a                	jle    8025b3 <open+0x5c>
	{
		return -E_BAD_PATH;
  8025a9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8025ae:	e9 c9 00 00 00       	jmpq   80267c <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8025b3:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8025ba:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8025bb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8025bf:	48 89 c7             	mov    %rax,%rdi
  8025c2:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  8025c9:	00 00 00 
  8025cc:	ff d0                	callq  *%rax
  8025ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d5:	78 09                	js     8025e0 <open+0x89>
  8025d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025db:	48 85 c0             	test   %rax,%rax
  8025de:	75 08                	jne    8025e8 <open+0x91>
		{
			return r;
  8025e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e3:	e9 94 00 00 00       	jmpq   80267c <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8025e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025ec:	ba 00 04 00 00       	mov    $0x400,%edx
  8025f1:	48 89 c6             	mov    %rax,%rsi
  8025f4:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8025fb:	00 00 00 
  8025fe:	48 b8 b1 0e 80 00 00 	movabs $0x800eb1,%rax
  802605:	00 00 00 
  802608:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80260a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802611:	00 00 00 
  802614:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802617:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80261d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802621:	48 89 c6             	mov    %rax,%rsi
  802624:	bf 01 00 00 00       	mov    $0x1,%edi
  802629:	48 b8 d0 24 80 00 00 	movabs $0x8024d0,%rax
  802630:	00 00 00 
  802633:	ff d0                	callq  *%rax
  802635:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802638:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263c:	79 2b                	jns    802669 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80263e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802642:	be 00 00 00 00       	mov    $0x0,%esi
  802647:	48 89 c7             	mov    %rax,%rdi
  80264a:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  802651:	00 00 00 
  802654:	ff d0                	callq  *%rax
  802656:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802659:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80265d:	79 05                	jns    802664 <open+0x10d>
			{
				return d;
  80265f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802662:	eb 18                	jmp    80267c <open+0x125>
			}
			return r;
  802664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802667:	eb 13                	jmp    80267c <open+0x125>
		}	
		return fd2num(fd_store);
  802669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266d:	48 89 c7             	mov    %rax,%rdi
  802670:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  802677:	00 00 00 
  80267a:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80267c:	c9                   	leaveq 
  80267d:	c3                   	retq   

000000000080267e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80267e:	55                   	push   %rbp
  80267f:	48 89 e5             	mov    %rsp,%rbp
  802682:	48 83 ec 10          	sub    $0x10,%rsp
  802686:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80268a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80268e:	8b 50 0c             	mov    0xc(%rax),%edx
  802691:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802698:	00 00 00 
  80269b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80269d:	be 00 00 00 00       	mov    $0x0,%esi
  8026a2:	bf 06 00 00 00       	mov    $0x6,%edi
  8026a7:	48 b8 d0 24 80 00 00 	movabs $0x8024d0,%rax
  8026ae:	00 00 00 
  8026b1:	ff d0                	callq  *%rax
}
  8026b3:	c9                   	leaveq 
  8026b4:	c3                   	retq   

00000000008026b5 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8026b5:	55                   	push   %rbp
  8026b6:	48 89 e5             	mov    %rsp,%rbp
  8026b9:	48 83 ec 30          	sub    $0x30,%rsp
  8026bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8026c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8026d0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8026d5:	74 07                	je     8026de <devfile_read+0x29>
  8026d7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8026dc:	75 07                	jne    8026e5 <devfile_read+0x30>
		return -E_INVAL;
  8026de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026e3:	eb 77                	jmp    80275c <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8026e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e9:	8b 50 0c             	mov    0xc(%rax),%edx
  8026ec:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026f3:	00 00 00 
  8026f6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8026f8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026ff:	00 00 00 
  802702:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802706:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80270a:	be 00 00 00 00       	mov    $0x0,%esi
  80270f:	bf 03 00 00 00       	mov    $0x3,%edi
  802714:	48 b8 d0 24 80 00 00 	movabs $0x8024d0,%rax
  80271b:	00 00 00 
  80271e:	ff d0                	callq  *%rax
  802720:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802723:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802727:	7f 05                	jg     80272e <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802729:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272c:	eb 2e                	jmp    80275c <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80272e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802731:	48 63 d0             	movslq %eax,%rdx
  802734:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802738:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80273f:	00 00 00 
  802742:	48 89 c7             	mov    %rax,%rdi
  802745:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  80274c:	00 00 00 
  80274f:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802751:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802755:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802759:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80275c:	c9                   	leaveq 
  80275d:	c3                   	retq   

000000000080275e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80275e:	55                   	push   %rbp
  80275f:	48 89 e5             	mov    %rsp,%rbp
  802762:	48 83 ec 30          	sub    $0x30,%rsp
  802766:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80276a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80276e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802772:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802779:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80277e:	74 07                	je     802787 <devfile_write+0x29>
  802780:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802785:	75 08                	jne    80278f <devfile_write+0x31>
		return r;
  802787:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278a:	e9 9a 00 00 00       	jmpq   802829 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80278f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802793:	8b 50 0c             	mov    0xc(%rax),%edx
  802796:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80279d:	00 00 00 
  8027a0:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8027a2:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8027a9:	00 
  8027aa:	76 08                	jbe    8027b4 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8027ac:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8027b3:	00 
	}
	fsipcbuf.write.req_n = n;
  8027b4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027bb:	00 00 00 
  8027be:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027c2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8027c6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ce:	48 89 c6             	mov    %rax,%rsi
  8027d1:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8027d8:	00 00 00 
  8027db:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  8027e2:	00 00 00 
  8027e5:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8027e7:	be 00 00 00 00       	mov    $0x0,%esi
  8027ec:	bf 04 00 00 00       	mov    $0x4,%edi
  8027f1:	48 b8 d0 24 80 00 00 	movabs $0x8024d0,%rax
  8027f8:	00 00 00 
  8027fb:	ff d0                	callq  *%rax
  8027fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802800:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802804:	7f 20                	jg     802826 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802806:	48 bf 1e 3d 80 00 00 	movabs $0x803d1e,%rdi
  80280d:	00 00 00 
  802810:	b8 00 00 00 00       	mov    $0x0,%eax
  802815:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  80281c:	00 00 00 
  80281f:	ff d2                	callq  *%rdx
		return r;
  802821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802824:	eb 03                	jmp    802829 <devfile_write+0xcb>
	}
	return r;
  802826:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802829:	c9                   	leaveq 
  80282a:	c3                   	retq   

000000000080282b <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80282b:	55                   	push   %rbp
  80282c:	48 89 e5             	mov    %rsp,%rbp
  80282f:	48 83 ec 20          	sub    $0x20,%rsp
  802833:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802837:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80283b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283f:	8b 50 0c             	mov    0xc(%rax),%edx
  802842:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802849:	00 00 00 
  80284c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80284e:	be 00 00 00 00       	mov    $0x0,%esi
  802853:	bf 05 00 00 00       	mov    $0x5,%edi
  802858:	48 b8 d0 24 80 00 00 	movabs $0x8024d0,%rax
  80285f:	00 00 00 
  802862:	ff d0                	callq  *%rax
  802864:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802867:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286b:	79 05                	jns    802872 <devfile_stat+0x47>
		return r;
  80286d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802870:	eb 56                	jmp    8028c8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802872:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802876:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80287d:	00 00 00 
  802880:	48 89 c7             	mov    %rax,%rdi
  802883:	48 b8 1f 0e 80 00 00 	movabs $0x800e1f,%rax
  80288a:	00 00 00 
  80288d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80288f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802896:	00 00 00 
  802899:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80289f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028a3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8028a9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028b0:	00 00 00 
  8028b3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8028b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028bd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8028c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028c8:	c9                   	leaveq 
  8028c9:	c3                   	retq   

00000000008028ca <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8028ca:	55                   	push   %rbp
  8028cb:	48 89 e5             	mov    %rsp,%rbp
  8028ce:	48 83 ec 10          	sub    $0x10,%rsp
  8028d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028d6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8028d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028dd:	8b 50 0c             	mov    0xc(%rax),%edx
  8028e0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028e7:	00 00 00 
  8028ea:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8028ec:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028f3:	00 00 00 
  8028f6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8028f9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8028fc:	be 00 00 00 00       	mov    $0x0,%esi
  802901:	bf 02 00 00 00       	mov    $0x2,%edi
  802906:	48 b8 d0 24 80 00 00 	movabs $0x8024d0,%rax
  80290d:	00 00 00 
  802910:	ff d0                	callq  *%rax
}
  802912:	c9                   	leaveq 
  802913:	c3                   	retq   

0000000000802914 <remove>:

// Delete a file
int
remove(const char *path)
{
  802914:	55                   	push   %rbp
  802915:	48 89 e5             	mov    %rsp,%rbp
  802918:	48 83 ec 10          	sub    $0x10,%rsp
  80291c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802920:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802924:	48 89 c7             	mov    %rax,%rdi
  802927:	48 b8 b3 0d 80 00 00 	movabs $0x800db3,%rax
  80292e:	00 00 00 
  802931:	ff d0                	callq  *%rax
  802933:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802938:	7e 07                	jle    802941 <remove+0x2d>
		return -E_BAD_PATH;
  80293a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80293f:	eb 33                	jmp    802974 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802941:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802945:	48 89 c6             	mov    %rax,%rsi
  802948:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80294f:	00 00 00 
  802952:	48 b8 1f 0e 80 00 00 	movabs $0x800e1f,%rax
  802959:	00 00 00 
  80295c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80295e:	be 00 00 00 00       	mov    $0x0,%esi
  802963:	bf 07 00 00 00       	mov    $0x7,%edi
  802968:	48 b8 d0 24 80 00 00 	movabs $0x8024d0,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
}
  802974:	c9                   	leaveq 
  802975:	c3                   	retq   

0000000000802976 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802976:	55                   	push   %rbp
  802977:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80297a:	be 00 00 00 00       	mov    $0x0,%esi
  80297f:	bf 08 00 00 00       	mov    $0x8,%edi
  802984:	48 b8 d0 24 80 00 00 	movabs $0x8024d0,%rax
  80298b:	00 00 00 
  80298e:	ff d0                	callq  *%rax
}
  802990:	5d                   	pop    %rbp
  802991:	c3                   	retq   

0000000000802992 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802992:	55                   	push   %rbp
  802993:	48 89 e5             	mov    %rsp,%rbp
  802996:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80299d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8029a4:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8029ab:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8029b2:	be 00 00 00 00       	mov    $0x0,%esi
  8029b7:	48 89 c7             	mov    %rax,%rdi
  8029ba:	48 b8 57 25 80 00 00 	movabs $0x802557,%rax
  8029c1:	00 00 00 
  8029c4:	ff d0                	callq  *%rax
  8029c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8029c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029cd:	79 28                	jns    8029f7 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8029cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d2:	89 c6                	mov    %eax,%esi
  8029d4:	48 bf 3a 3d 80 00 00 	movabs $0x803d3a,%rdi
  8029db:	00 00 00 
  8029de:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e3:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  8029ea:	00 00 00 
  8029ed:	ff d2                	callq  *%rdx
		return fd_src;
  8029ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f2:	e9 74 01 00 00       	jmpq   802b6b <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8029f7:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8029fe:	be 01 01 00 00       	mov    $0x101,%esi
  802a03:	48 89 c7             	mov    %rax,%rdi
  802a06:	48 b8 57 25 80 00 00 	movabs $0x802557,%rax
  802a0d:	00 00 00 
  802a10:	ff d0                	callq  *%rax
  802a12:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a15:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a19:	79 39                	jns    802a54 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a1e:	89 c6                	mov    %eax,%esi
  802a20:	48 bf 50 3d 80 00 00 	movabs $0x803d50,%rdi
  802a27:	00 00 00 
  802a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2f:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  802a36:	00 00 00 
  802a39:	ff d2                	callq  *%rdx
		close(fd_src);
  802a3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3e:	89 c7                	mov    %eax,%edi
  802a40:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802a47:	00 00 00 
  802a4a:	ff d0                	callq  *%rax
		return fd_dest;
  802a4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a4f:	e9 17 01 00 00       	jmpq   802b6b <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802a54:	eb 74                	jmp    802aca <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802a56:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a59:	48 63 d0             	movslq %eax,%rdx
  802a5c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a66:	48 89 ce             	mov    %rcx,%rsi
  802a69:	89 c7                	mov    %eax,%edi
  802a6b:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802a72:	00 00 00 
  802a75:	ff d0                	callq  *%rax
  802a77:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802a7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802a7e:	79 4a                	jns    802aca <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802a80:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a83:	89 c6                	mov    %eax,%esi
  802a85:	48 bf 6a 3d 80 00 00 	movabs $0x803d6a,%rdi
  802a8c:	00 00 00 
  802a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a94:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  802a9b:	00 00 00 
  802a9e:	ff d2                	callq  *%rdx
			close(fd_src);
  802aa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa3:	89 c7                	mov    %eax,%edi
  802aa5:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802aac:	00 00 00 
  802aaf:	ff d0                	callq  *%rax
			close(fd_dest);
  802ab1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ab4:	89 c7                	mov    %eax,%edi
  802ab6:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802abd:	00 00 00 
  802ac0:	ff d0                	callq  *%rax
			return write_size;
  802ac2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ac5:	e9 a1 00 00 00       	jmpq   802b6b <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802aca:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad4:	ba 00 02 00 00       	mov    $0x200,%edx
  802ad9:	48 89 ce             	mov    %rcx,%rsi
  802adc:	89 c7                	mov    %eax,%edi
  802ade:	48 b8 b4 20 80 00 00 	movabs $0x8020b4,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	callq  *%rax
  802aea:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802af1:	0f 8f 5f ff ff ff    	jg     802a56 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802afb:	79 47                	jns    802b44 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802afd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b00:	89 c6                	mov    %eax,%esi
  802b02:	48 bf 7d 3d 80 00 00 	movabs $0x803d7d,%rdi
  802b09:	00 00 00 
  802b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b11:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  802b18:	00 00 00 
  802b1b:	ff d2                	callq  *%rdx
		close(fd_src);
  802b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b20:	89 c7                	mov    %eax,%edi
  802b22:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802b29:	00 00 00 
  802b2c:	ff d0                	callq  *%rax
		close(fd_dest);
  802b2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b31:	89 c7                	mov    %eax,%edi
  802b33:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802b3a:	00 00 00 
  802b3d:	ff d0                	callq  *%rax
		return read_size;
  802b3f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b42:	eb 27                	jmp    802b6b <copy+0x1d9>
	}
	close(fd_src);
  802b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b47:	89 c7                	mov    %eax,%edi
  802b49:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	callq  *%rax
	close(fd_dest);
  802b55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b58:	89 c7                	mov    %eax,%edi
  802b5a:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802b61:	00 00 00 
  802b64:	ff d0                	callq  *%rax
	return 0;
  802b66:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802b6b:	c9                   	leaveq 
  802b6c:	c3                   	retq   

0000000000802b6d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802b6d:	55                   	push   %rbp
  802b6e:	48 89 e5             	mov    %rsp,%rbp
  802b71:	53                   	push   %rbx
  802b72:	48 83 ec 38          	sub    $0x38,%rsp
  802b76:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b7a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802b7e:	48 89 c7             	mov    %rax,%rdi
  802b81:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  802b88:	00 00 00 
  802b8b:	ff d0                	callq  *%rax
  802b8d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b90:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b94:	0f 88 bf 01 00 00    	js     802d59 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b9e:	ba 07 04 00 00       	mov    $0x407,%edx
  802ba3:	48 89 c6             	mov    %rax,%rsi
  802ba6:	bf 00 00 00 00       	mov    $0x0,%edi
  802bab:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  802bb2:	00 00 00 
  802bb5:	ff d0                	callq  *%rax
  802bb7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bbe:	0f 88 95 01 00 00    	js     802d59 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802bc4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802bc8:	48 89 c7             	mov    %rax,%rdi
  802bcb:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  802bd2:	00 00 00 
  802bd5:	ff d0                	callq  *%rax
  802bd7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bda:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bde:	0f 88 5d 01 00 00    	js     802d41 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802be4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802be8:	ba 07 04 00 00       	mov    $0x407,%edx
  802bed:	48 89 c6             	mov    %rax,%rsi
  802bf0:	bf 00 00 00 00       	mov    $0x0,%edi
  802bf5:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  802bfc:	00 00 00 
  802bff:	ff d0                	callq  *%rax
  802c01:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c04:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c08:	0f 88 33 01 00 00    	js     802d41 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802c0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c12:	48 89 c7             	mov    %rax,%rdi
  802c15:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  802c1c:	00 00 00 
  802c1f:	ff d0                	callq  *%rax
  802c21:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c29:	ba 07 04 00 00       	mov    $0x407,%edx
  802c2e:	48 89 c6             	mov    %rax,%rsi
  802c31:	bf 00 00 00 00       	mov    $0x0,%edi
  802c36:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  802c3d:	00 00 00 
  802c40:	ff d0                	callq  *%rax
  802c42:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c45:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c49:	79 05                	jns    802c50 <pipe+0xe3>
		goto err2;
  802c4b:	e9 d9 00 00 00       	jmpq   802d29 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c54:	48 89 c7             	mov    %rax,%rdi
  802c57:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  802c5e:	00 00 00 
  802c61:	ff d0                	callq  *%rax
  802c63:	48 89 c2             	mov    %rax,%rdx
  802c66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c6a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802c70:	48 89 d1             	mov    %rdx,%rcx
  802c73:	ba 00 00 00 00       	mov    $0x0,%edx
  802c78:	48 89 c6             	mov    %rax,%rsi
  802c7b:	bf 00 00 00 00       	mov    $0x0,%edi
  802c80:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  802c87:	00 00 00 
  802c8a:	ff d0                	callq  *%rax
  802c8c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c93:	79 1b                	jns    802cb0 <pipe+0x143>
		goto err3;
  802c95:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802c96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c9a:	48 89 c6             	mov    %rax,%rsi
  802c9d:	bf 00 00 00 00       	mov    $0x0,%edi
  802ca2:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  802ca9:	00 00 00 
  802cac:	ff d0                	callq  *%rax
  802cae:	eb 79                	jmp    802d29 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802cb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb4:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  802cbb:	00 00 00 
  802cbe:	8b 12                	mov    (%rdx),%edx
  802cc0:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802cc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802ccd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cd1:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  802cd8:	00 00 00 
  802cdb:	8b 12                	mov    (%rdx),%edx
  802cdd:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802cdf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ce3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802cea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cee:	48 89 c7             	mov    %rax,%rdi
  802cf1:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  802cf8:	00 00 00 
  802cfb:	ff d0                	callq  *%rax
  802cfd:	89 c2                	mov    %eax,%edx
  802cff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d03:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802d05:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d09:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802d0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d11:	48 89 c7             	mov    %rax,%rdi
  802d14:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  802d1b:	00 00 00 
  802d1e:	ff d0                	callq  *%rax
  802d20:	89 03                	mov    %eax,(%rbx)
	return 0;
  802d22:	b8 00 00 00 00       	mov    $0x0,%eax
  802d27:	eb 33                	jmp    802d5c <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802d29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d2d:	48 89 c6             	mov    %rax,%rsi
  802d30:	bf 00 00 00 00       	mov    $0x0,%edi
  802d35:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  802d3c:	00 00 00 
  802d3f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802d41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d45:	48 89 c6             	mov    %rax,%rsi
  802d48:	bf 00 00 00 00       	mov    $0x0,%edi
  802d4d:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
err:
	return r;
  802d59:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802d5c:	48 83 c4 38          	add    $0x38,%rsp
  802d60:	5b                   	pop    %rbx
  802d61:	5d                   	pop    %rbp
  802d62:	c3                   	retq   

0000000000802d63 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802d63:	55                   	push   %rbp
  802d64:	48 89 e5             	mov    %rsp,%rbp
  802d67:	53                   	push   %rbx
  802d68:	48 83 ec 28          	sub    $0x28,%rsp
  802d6c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d70:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802d74:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802d7b:	00 00 00 
  802d7e:	48 8b 00             	mov    (%rax),%rax
  802d81:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802d87:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802d8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d8e:	48 89 c7             	mov    %rax,%rdi
  802d91:	48 b8 f5 36 80 00 00 	movabs $0x8036f5,%rax
  802d98:	00 00 00 
  802d9b:	ff d0                	callq  *%rax
  802d9d:	89 c3                	mov    %eax,%ebx
  802d9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802da3:	48 89 c7             	mov    %rax,%rdi
  802da6:	48 b8 f5 36 80 00 00 	movabs $0x8036f5,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
  802db2:	39 c3                	cmp    %eax,%ebx
  802db4:	0f 94 c0             	sete   %al
  802db7:	0f b6 c0             	movzbl %al,%eax
  802dba:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802dbd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802dc4:	00 00 00 
  802dc7:	48 8b 00             	mov    (%rax),%rax
  802dca:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802dd0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802dd3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dd6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802dd9:	75 05                	jne    802de0 <_pipeisclosed+0x7d>
			return ret;
  802ddb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802dde:	eb 4f                	jmp    802e2f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802de0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802de3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802de6:	74 42                	je     802e2a <_pipeisclosed+0xc7>
  802de8:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802dec:	75 3c                	jne    802e2a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802dee:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802df5:	00 00 00 
  802df8:	48 8b 00             	mov    (%rax),%rax
  802dfb:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802e01:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e04:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e07:	89 c6                	mov    %eax,%esi
  802e09:	48 bf 9d 3d 80 00 00 	movabs $0x803d9d,%rdi
  802e10:	00 00 00 
  802e13:	b8 00 00 00 00       	mov    $0x0,%eax
  802e18:	49 b8 6a 02 80 00 00 	movabs $0x80026a,%r8
  802e1f:	00 00 00 
  802e22:	41 ff d0             	callq  *%r8
	}
  802e25:	e9 4a ff ff ff       	jmpq   802d74 <_pipeisclosed+0x11>
  802e2a:	e9 45 ff ff ff       	jmpq   802d74 <_pipeisclosed+0x11>
}
  802e2f:	48 83 c4 28          	add    $0x28,%rsp
  802e33:	5b                   	pop    %rbx
  802e34:	5d                   	pop    %rbp
  802e35:	c3                   	retq   

0000000000802e36 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802e36:	55                   	push   %rbp
  802e37:	48 89 e5             	mov    %rsp,%rbp
  802e3a:	48 83 ec 30          	sub    $0x30,%rsp
  802e3e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e41:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e45:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e48:	48 89 d6             	mov    %rdx,%rsi
  802e4b:	89 c7                	mov    %eax,%edi
  802e4d:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  802e54:	00 00 00 
  802e57:	ff d0                	callq  *%rax
  802e59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e60:	79 05                	jns    802e67 <pipeisclosed+0x31>
		return r;
  802e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e65:	eb 31                	jmp    802e98 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802e67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6b:	48 89 c7             	mov    %rax,%rdi
  802e6e:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  802e75:	00 00 00 
  802e78:	ff d0                	callq  *%rax
  802e7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e86:	48 89 d6             	mov    %rdx,%rsi
  802e89:	48 89 c7             	mov    %rax,%rdi
  802e8c:	48 b8 63 2d 80 00 00 	movabs $0x802d63,%rax
  802e93:	00 00 00 
  802e96:	ff d0                	callq  *%rax
}
  802e98:	c9                   	leaveq 
  802e99:	c3                   	retq   

0000000000802e9a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802e9a:	55                   	push   %rbp
  802e9b:	48 89 e5             	mov    %rsp,%rbp
  802e9e:	48 83 ec 40          	sub    $0x40,%rsp
  802ea2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ea6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802eaa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802eae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb2:	48 89 c7             	mov    %rax,%rdi
  802eb5:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  802ebc:	00 00 00 
  802ebf:	ff d0                	callq  *%rax
  802ec1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802ec5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ec9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802ecd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ed4:	00 
  802ed5:	e9 92 00 00 00       	jmpq   802f6c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802eda:	eb 41                	jmp    802f1d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802edc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802ee1:	74 09                	je     802eec <devpipe_read+0x52>
				return i;
  802ee3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee7:	e9 92 00 00 00       	jmpq   802f7e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802eec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ef0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ef4:	48 89 d6             	mov    %rdx,%rsi
  802ef7:	48 89 c7             	mov    %rax,%rdi
  802efa:	48 b8 63 2d 80 00 00 	movabs $0x802d63,%rax
  802f01:	00 00 00 
  802f04:	ff d0                	callq  *%rax
  802f06:	85 c0                	test   %eax,%eax
  802f08:	74 07                	je     802f11 <devpipe_read+0x77>
				return 0;
  802f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0f:	eb 6d                	jmp    802f7e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802f11:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  802f18:	00 00 00 
  802f1b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802f1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f21:	8b 10                	mov    (%rax),%edx
  802f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f27:	8b 40 04             	mov    0x4(%rax),%eax
  802f2a:	39 c2                	cmp    %eax,%edx
  802f2c:	74 ae                	je     802edc <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f36:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3e:	8b 00                	mov    (%rax),%eax
  802f40:	99                   	cltd   
  802f41:	c1 ea 1b             	shr    $0x1b,%edx
  802f44:	01 d0                	add    %edx,%eax
  802f46:	83 e0 1f             	and    $0x1f,%eax
  802f49:	29 d0                	sub    %edx,%eax
  802f4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f4f:	48 98                	cltq   
  802f51:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802f56:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802f58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5c:	8b 00                	mov    (%rax),%eax
  802f5e:	8d 50 01             	lea    0x1(%rax),%edx
  802f61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f65:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f67:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f70:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f74:	0f 82 60 ff ff ff    	jb     802eda <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802f7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f7e:	c9                   	leaveq 
  802f7f:	c3                   	retq   

0000000000802f80 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802f80:	55                   	push   %rbp
  802f81:	48 89 e5             	mov    %rsp,%rbp
  802f84:	48 83 ec 40          	sub    $0x40,%rsp
  802f88:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f8c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f90:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802f94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f98:	48 89 c7             	mov    %rax,%rdi
  802f9b:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  802fa2:	00 00 00 
  802fa5:	ff d0                	callq  *%rax
  802fa7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802fab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802faf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802fb3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802fba:	00 
  802fbb:	e9 8e 00 00 00       	jmpq   80304e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802fc0:	eb 31                	jmp    802ff3 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802fc2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fc6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fca:	48 89 d6             	mov    %rdx,%rsi
  802fcd:	48 89 c7             	mov    %rax,%rdi
  802fd0:	48 b8 63 2d 80 00 00 	movabs $0x802d63,%rax
  802fd7:	00 00 00 
  802fda:	ff d0                	callq  *%rax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 07                	je     802fe7 <devpipe_write+0x67>
				return 0;
  802fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe5:	eb 79                	jmp    803060 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802fe7:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  802fee:	00 00 00 
  802ff1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ff3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff7:	8b 40 04             	mov    0x4(%rax),%eax
  802ffa:	48 63 d0             	movslq %eax,%rdx
  802ffd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803001:	8b 00                	mov    (%rax),%eax
  803003:	48 98                	cltq   
  803005:	48 83 c0 20          	add    $0x20,%rax
  803009:	48 39 c2             	cmp    %rax,%rdx
  80300c:	73 b4                	jae    802fc2 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80300e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803012:	8b 40 04             	mov    0x4(%rax),%eax
  803015:	99                   	cltd   
  803016:	c1 ea 1b             	shr    $0x1b,%edx
  803019:	01 d0                	add    %edx,%eax
  80301b:	83 e0 1f             	and    $0x1f,%eax
  80301e:	29 d0                	sub    %edx,%eax
  803020:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803024:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803028:	48 01 ca             	add    %rcx,%rdx
  80302b:	0f b6 0a             	movzbl (%rdx),%ecx
  80302e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803032:	48 98                	cltq   
  803034:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803038:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80303c:	8b 40 04             	mov    0x4(%rax),%eax
  80303f:	8d 50 01             	lea    0x1(%rax),%edx
  803042:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803046:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803049:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80304e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803052:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803056:	0f 82 64 ff ff ff    	jb     802fc0 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80305c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803060:	c9                   	leaveq 
  803061:	c3                   	retq   

0000000000803062 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803062:	55                   	push   %rbp
  803063:	48 89 e5             	mov    %rsp,%rbp
  803066:	48 83 ec 20          	sub    $0x20,%rsp
  80306a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80306e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803076:	48 89 c7             	mov    %rax,%rdi
  803079:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  803080:	00 00 00 
  803083:	ff d0                	callq  *%rax
  803085:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803089:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80308d:	48 be b0 3d 80 00 00 	movabs $0x803db0,%rsi
  803094:	00 00 00 
  803097:	48 89 c7             	mov    %rax,%rdi
  80309a:	48 b8 1f 0e 80 00 00 	movabs $0x800e1f,%rax
  8030a1:	00 00 00 
  8030a4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8030a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030aa:	8b 50 04             	mov    0x4(%rax),%edx
  8030ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030b1:	8b 00                	mov    (%rax),%eax
  8030b3:	29 c2                	sub    %eax,%edx
  8030b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8030bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030c3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8030ca:	00 00 00 
	stat->st_dev = &devpipe;
  8030cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d1:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  8030d8:	00 00 00 
  8030db:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8030e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030e7:	c9                   	leaveq 
  8030e8:	c3                   	retq   

00000000008030e9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8030e9:	55                   	push   %rbp
  8030ea:	48 89 e5             	mov    %rsp,%rbp
  8030ed:	48 83 ec 10          	sub    $0x10,%rsp
  8030f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8030f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030f9:	48 89 c6             	mov    %rax,%rsi
  8030fc:	bf 00 00 00 00       	mov    $0x0,%edi
  803101:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  803108:	00 00 00 
  80310b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80310d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803111:	48 89 c7             	mov    %rax,%rdi
  803114:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  80311b:	00 00 00 
  80311e:	ff d0                	callq  *%rax
  803120:	48 89 c6             	mov    %rax,%rsi
  803123:	bf 00 00 00 00       	mov    $0x0,%edi
  803128:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  80312f:	00 00 00 
  803132:	ff d0                	callq  *%rax
}
  803134:	c9                   	leaveq 
  803135:	c3                   	retq   

0000000000803136 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803136:	55                   	push   %rbp
  803137:	48 89 e5             	mov    %rsp,%rbp
  80313a:	48 83 ec 20          	sub    $0x20,%rsp
  80313e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803141:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803144:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803147:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80314b:	be 01 00 00 00       	mov    $0x1,%esi
  803150:	48 89 c7             	mov    %rax,%rdi
  803153:	48 b8 06 16 80 00 00 	movabs $0x801606,%rax
  80315a:	00 00 00 
  80315d:	ff d0                	callq  *%rax
}
  80315f:	c9                   	leaveq 
  803160:	c3                   	retq   

0000000000803161 <getchar>:

int
getchar(void)
{
  803161:	55                   	push   %rbp
  803162:	48 89 e5             	mov    %rsp,%rbp
  803165:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803169:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80316d:	ba 01 00 00 00       	mov    $0x1,%edx
  803172:	48 89 c6             	mov    %rax,%rsi
  803175:	bf 00 00 00 00       	mov    $0x0,%edi
  80317a:	48 b8 b4 20 80 00 00 	movabs $0x8020b4,%rax
  803181:	00 00 00 
  803184:	ff d0                	callq  *%rax
  803186:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803189:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80318d:	79 05                	jns    803194 <getchar+0x33>
		return r;
  80318f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803192:	eb 14                	jmp    8031a8 <getchar+0x47>
	if (r < 1)
  803194:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803198:	7f 07                	jg     8031a1 <getchar+0x40>
		return -E_EOF;
  80319a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80319f:	eb 07                	jmp    8031a8 <getchar+0x47>
	return c;
  8031a1:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8031a5:	0f b6 c0             	movzbl %al,%eax
}
  8031a8:	c9                   	leaveq 
  8031a9:	c3                   	retq   

00000000008031aa <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8031aa:	55                   	push   %rbp
  8031ab:	48 89 e5             	mov    %rsp,%rbp
  8031ae:	48 83 ec 20          	sub    $0x20,%rsp
  8031b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031b5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031bc:	48 89 d6             	mov    %rdx,%rsi
  8031bf:	89 c7                	mov    %eax,%edi
  8031c1:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  8031c8:	00 00 00 
  8031cb:	ff d0                	callq  *%rax
  8031cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031d4:	79 05                	jns    8031db <iscons+0x31>
		return r;
  8031d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d9:	eb 1a                	jmp    8031f5 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8031db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031df:	8b 10                	mov    (%rax),%edx
  8031e1:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  8031e8:	00 00 00 
  8031eb:	8b 00                	mov    (%rax),%eax
  8031ed:	39 c2                	cmp    %eax,%edx
  8031ef:	0f 94 c0             	sete   %al
  8031f2:	0f b6 c0             	movzbl %al,%eax
}
  8031f5:	c9                   	leaveq 
  8031f6:	c3                   	retq   

00000000008031f7 <opencons>:

int
opencons(void)
{
  8031f7:	55                   	push   %rbp
  8031f8:	48 89 e5             	mov    %rsp,%rbp
  8031fb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8031ff:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803203:	48 89 c7             	mov    %rax,%rdi
  803206:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  80320d:	00 00 00 
  803210:	ff d0                	callq  *%rax
  803212:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803215:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803219:	79 05                	jns    803220 <opencons+0x29>
		return r;
  80321b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80321e:	eb 5b                	jmp    80327b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803220:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803224:	ba 07 04 00 00       	mov    $0x407,%edx
  803229:	48 89 c6             	mov    %rax,%rsi
  80322c:	bf 00 00 00 00       	mov    $0x0,%edi
  803231:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  803238:	00 00 00 
  80323b:	ff d0                	callq  *%rax
  80323d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803240:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803244:	79 05                	jns    80324b <opencons+0x54>
		return r;
  803246:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803249:	eb 30                	jmp    80327b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80324b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80324f:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  803256:	00 00 00 
  803259:	8b 12                	mov    (%rdx),%edx
  80325b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80325d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803261:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326c:	48 89 c7             	mov    %rax,%rdi
  80326f:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  803276:	00 00 00 
  803279:	ff d0                	callq  *%rax
}
  80327b:	c9                   	leaveq 
  80327c:	c3                   	retq   

000000000080327d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80327d:	55                   	push   %rbp
  80327e:	48 89 e5             	mov    %rsp,%rbp
  803281:	48 83 ec 30          	sub    $0x30,%rsp
  803285:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803289:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80328d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803291:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803296:	75 07                	jne    80329f <devcons_read+0x22>
		return 0;
  803298:	b8 00 00 00 00       	mov    $0x0,%eax
  80329d:	eb 4b                	jmp    8032ea <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80329f:	eb 0c                	jmp    8032ad <devcons_read+0x30>
		sys_yield();
  8032a1:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8032ad:	48 b8 50 16 80 00 00 	movabs $0x801650,%rax
  8032b4:	00 00 00 
  8032b7:	ff d0                	callq  *%rax
  8032b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c0:	74 df                	je     8032a1 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8032c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c6:	79 05                	jns    8032cd <devcons_read+0x50>
		return c;
  8032c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032cb:	eb 1d                	jmp    8032ea <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8032cd:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8032d1:	75 07                	jne    8032da <devcons_read+0x5d>
		return 0;
  8032d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d8:	eb 10                	jmp    8032ea <devcons_read+0x6d>
	*(char*)vbuf = c;
  8032da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032dd:	89 c2                	mov    %eax,%edx
  8032df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e3:	88 10                	mov    %dl,(%rax)
	return 1;
  8032e5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8032ea:	c9                   	leaveq 
  8032eb:	c3                   	retq   

00000000008032ec <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8032ec:	55                   	push   %rbp
  8032ed:	48 89 e5             	mov    %rsp,%rbp
  8032f0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8032f7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8032fe:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803305:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80330c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803313:	eb 76                	jmp    80338b <devcons_write+0x9f>
		m = n - tot;
  803315:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80331c:	89 c2                	mov    %eax,%edx
  80331e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803321:	29 c2                	sub    %eax,%edx
  803323:	89 d0                	mov    %edx,%eax
  803325:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803328:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80332b:	83 f8 7f             	cmp    $0x7f,%eax
  80332e:	76 07                	jbe    803337 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803330:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803337:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80333a:	48 63 d0             	movslq %eax,%rdx
  80333d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803340:	48 63 c8             	movslq %eax,%rcx
  803343:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80334a:	48 01 c1             	add    %rax,%rcx
  80334d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803354:	48 89 ce             	mov    %rcx,%rsi
  803357:	48 89 c7             	mov    %rax,%rdi
  80335a:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  803361:	00 00 00 
  803364:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803366:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803369:	48 63 d0             	movslq %eax,%rdx
  80336c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803373:	48 89 d6             	mov    %rdx,%rsi
  803376:	48 89 c7             	mov    %rax,%rdi
  803379:	48 b8 06 16 80 00 00 	movabs $0x801606,%rax
  803380:	00 00 00 
  803383:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803385:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803388:	01 45 fc             	add    %eax,-0x4(%rbp)
  80338b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80338e:	48 98                	cltq   
  803390:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803397:	0f 82 78 ff ff ff    	jb     803315 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80339d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033a0:	c9                   	leaveq 
  8033a1:	c3                   	retq   

00000000008033a2 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8033a2:	55                   	push   %rbp
  8033a3:	48 89 e5             	mov    %rsp,%rbp
  8033a6:	48 83 ec 08          	sub    $0x8,%rsp
  8033aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8033ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033b3:	c9                   	leaveq 
  8033b4:	c3                   	retq   

00000000008033b5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8033b5:	55                   	push   %rbp
  8033b6:	48 89 e5             	mov    %rsp,%rbp
  8033b9:	48 83 ec 10          	sub    $0x10,%rsp
  8033bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8033c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c9:	48 be bc 3d 80 00 00 	movabs $0x803dbc,%rsi
  8033d0:	00 00 00 
  8033d3:	48 89 c7             	mov    %rax,%rdi
  8033d6:	48 b8 1f 0e 80 00 00 	movabs $0x800e1f,%rax
  8033dd:	00 00 00 
  8033e0:	ff d0                	callq  *%rax
	return 0;
  8033e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033e7:	c9                   	leaveq 
  8033e8:	c3                   	retq   

00000000008033e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8033e9:	55                   	push   %rbp
  8033ea:	48 89 e5             	mov    %rsp,%rbp
  8033ed:	53                   	push   %rbx
  8033ee:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8033f5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8033fc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803402:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803409:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803410:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803417:	84 c0                	test   %al,%al
  803419:	74 23                	je     80343e <_panic+0x55>
  80341b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803422:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803426:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80342a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80342e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803432:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803436:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80343a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80343e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803445:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80344c:	00 00 00 
  80344f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803456:	00 00 00 
  803459:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80345d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803464:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80346b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803472:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803479:	00 00 00 
  80347c:	48 8b 18             	mov    (%rax),%rbx
  80347f:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  803486:	00 00 00 
  803489:	ff d0                	callq  *%rax
  80348b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803491:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803498:	41 89 c8             	mov    %ecx,%r8d
  80349b:	48 89 d1             	mov    %rdx,%rcx
  80349e:	48 89 da             	mov    %rbx,%rdx
  8034a1:	89 c6                	mov    %eax,%esi
  8034a3:	48 bf c8 3d 80 00 00 	movabs $0x803dc8,%rdi
  8034aa:	00 00 00 
  8034ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b2:	49 b9 6a 02 80 00 00 	movabs $0x80026a,%r9
  8034b9:	00 00 00 
  8034bc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8034bf:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8034c6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8034cd:	48 89 d6             	mov    %rdx,%rsi
  8034d0:	48 89 c7             	mov    %rax,%rdi
  8034d3:	48 b8 be 01 80 00 00 	movabs $0x8001be,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
	cprintf("\n");
  8034df:	48 bf eb 3d 80 00 00 	movabs $0x803deb,%rdi
  8034e6:	00 00 00 
  8034e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ee:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  8034f5:	00 00 00 
  8034f8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8034fa:	cc                   	int3   
  8034fb:	eb fd                	jmp    8034fa <_panic+0x111>

00000000008034fd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8034fd:	55                   	push   %rbp
  8034fe:	48 89 e5             	mov    %rsp,%rbp
  803501:	48 83 ec 30          	sub    $0x30,%rsp
  803505:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803509:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80350d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803511:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803518:	00 00 00 
  80351b:	48 8b 00             	mov    (%rax),%rax
  80351e:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803524:	85 c0                	test   %eax,%eax
  803526:	75 34                	jne    80355c <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803528:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  80352f:	00 00 00 
  803532:	ff d0                	callq  *%rax
  803534:	25 ff 03 00 00       	and    $0x3ff,%eax
  803539:	48 98                	cltq   
  80353b:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803542:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803549:	00 00 00 
  80354c:	48 01 c2             	add    %rax,%rdx
  80354f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803556:	00 00 00 
  803559:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80355c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803561:	75 0e                	jne    803571 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803563:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80356a:	00 00 00 
  80356d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803571:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803575:	48 89 c7             	mov    %rax,%rdi
  803578:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  80357f:	00 00 00 
  803582:	ff d0                	callq  *%rax
  803584:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803587:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80358b:	79 19                	jns    8035a6 <ipc_recv+0xa9>
		*from_env_store = 0;
  80358d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803591:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80359b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8035a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a4:	eb 53                	jmp    8035f9 <ipc_recv+0xfc>
	}
	if(from_env_store)
  8035a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035ab:	74 19                	je     8035c6 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8035ad:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035b4:	00 00 00 
  8035b7:	48 8b 00             	mov    (%rax),%rax
  8035ba:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8035c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c4:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8035c6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035cb:	74 19                	je     8035e6 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8035cd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035d4:	00 00 00 
  8035d7:	48 8b 00             	mov    (%rax),%rax
  8035da:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8035e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e4:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8035e6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035ed:	00 00 00 
  8035f0:	48 8b 00             	mov    (%rax),%rax
  8035f3:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8035f9:	c9                   	leaveq 
  8035fa:	c3                   	retq   

00000000008035fb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8035fb:	55                   	push   %rbp
  8035fc:	48 89 e5             	mov    %rsp,%rbp
  8035ff:	48 83 ec 30          	sub    $0x30,%rsp
  803603:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803606:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803609:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80360d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803610:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803615:	75 0e                	jne    803625 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803617:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80361e:	00 00 00 
  803621:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803625:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803628:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80362b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80362f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803632:	89 c7                	mov    %eax,%edi
  803634:	48 b8 22 19 80 00 00 	movabs $0x801922,%rax
  80363b:	00 00 00 
  80363e:	ff d0                	callq  *%rax
  803640:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803643:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803647:	75 0c                	jne    803655 <ipc_send+0x5a>
			sys_yield();
  803649:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  803650:	00 00 00 
  803653:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803655:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803659:	74 ca                	je     803625 <ipc_send+0x2a>
	if(result != 0)
  80365b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80365f:	74 20                	je     803681 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803661:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803664:	89 c6                	mov    %eax,%esi
  803666:	48 bf ed 3d 80 00 00 	movabs $0x803ded,%rdi
  80366d:	00 00 00 
  803670:	b8 00 00 00 00       	mov    $0x0,%eax
  803675:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  80367c:	00 00 00 
  80367f:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803681:	c9                   	leaveq 
  803682:	c3                   	retq   

0000000000803683 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803683:	55                   	push   %rbp
  803684:	48 89 e5             	mov    %rsp,%rbp
  803687:	48 83 ec 14          	sub    $0x14,%rsp
  80368b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80368e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803695:	eb 4e                	jmp    8036e5 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803697:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80369e:	00 00 00 
  8036a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a4:	48 98                	cltq   
  8036a6:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8036ad:	48 01 d0             	add    %rdx,%rax
  8036b0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8036b6:	8b 00                	mov    (%rax),%eax
  8036b8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8036bb:	75 24                	jne    8036e1 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8036bd:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8036c4:	00 00 00 
  8036c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ca:	48 98                	cltq   
  8036cc:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8036d3:	48 01 d0             	add    %rdx,%rax
  8036d6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8036dc:	8b 40 08             	mov    0x8(%rax),%eax
  8036df:	eb 12                	jmp    8036f3 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8036e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8036e5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8036ec:	7e a9                	jle    803697 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8036ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036f3:	c9                   	leaveq 
  8036f4:	c3                   	retq   

00000000008036f5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8036f5:	55                   	push   %rbp
  8036f6:	48 89 e5             	mov    %rsp,%rbp
  8036f9:	48 83 ec 18          	sub    $0x18,%rsp
  8036fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803705:	48 c1 e8 15          	shr    $0x15,%rax
  803709:	48 89 c2             	mov    %rax,%rdx
  80370c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803713:	01 00 00 
  803716:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80371a:	83 e0 01             	and    $0x1,%eax
  80371d:	48 85 c0             	test   %rax,%rax
  803720:	75 07                	jne    803729 <pageref+0x34>
		return 0;
  803722:	b8 00 00 00 00       	mov    $0x0,%eax
  803727:	eb 53                	jmp    80377c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372d:	48 c1 e8 0c          	shr    $0xc,%rax
  803731:	48 89 c2             	mov    %rax,%rdx
  803734:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80373b:	01 00 00 
  80373e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803742:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803746:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80374a:	83 e0 01             	and    $0x1,%eax
  80374d:	48 85 c0             	test   %rax,%rax
  803750:	75 07                	jne    803759 <pageref+0x64>
		return 0;
  803752:	b8 00 00 00 00       	mov    $0x0,%eax
  803757:	eb 23                	jmp    80377c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803759:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375d:	48 c1 e8 0c          	shr    $0xc,%rax
  803761:	48 89 c2             	mov    %rax,%rdx
  803764:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80376b:	00 00 00 
  80376e:	48 c1 e2 04          	shl    $0x4,%rdx
  803772:	48 01 d0             	add    %rdx,%rax
  803775:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803779:	0f b7 c0             	movzwl %ax,%eax
}
  80377c:	c9                   	leaveq 
  80377d:	c3                   	retq   
