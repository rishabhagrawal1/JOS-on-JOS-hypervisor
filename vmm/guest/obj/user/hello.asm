
vmm/guest/obj/user/hello:     file format elf64-x86-64


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
  800052:	48 bf e0 39 80 00 00 	movabs $0x8039e0,%rdi
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
  800082:	48 bf ee 39 80 00 00 	movabs $0x8039ee,%rdi
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
  800126:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
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
  8003d6:	48 ba 10 3c 80 00 00 	movabs $0x803c10,%rdx
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
  8006ce:	48 b8 38 3c 80 00 00 	movabs $0x803c38,%rax
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
  800821:	48 b8 60 3b 80 00 00 	movabs $0x803b60,%rax
  800828:	00 00 00 
  80082b:	48 63 d3             	movslq %ebx,%rdx
  80082e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800832:	4d 85 e4             	test   %r12,%r12
  800835:	75 2e                	jne    800865 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800837:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80083b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80083f:	89 d9                	mov    %ebx,%ecx
  800841:	48 ba 21 3c 80 00 00 	movabs $0x803c21,%rdx
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
  800870:	48 ba 2a 3c 80 00 00 	movabs $0x803c2a,%rdx
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
  8008ca:	49 bc 2d 3c 80 00 00 	movabs $0x803c2d,%r12
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
  8015d0:	48 ba e8 3e 80 00 00 	movabs $0x803ee8,%rdx
  8015d7:	00 00 00 
  8015da:	be 23 00 00 00       	mov    $0x23,%esi
  8015df:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  8015e6:	00 00 00 
  8015e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ee:	49 b9 eb 32 80 00 00 	movabs $0x8032eb,%r9
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

0000000000801a9e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801a9e:	55                   	push   %rbp
  801a9f:	48 89 e5             	mov    %rsp,%rbp
  801aa2:	48 83 ec 08          	sub    $0x8,%rsp
  801aa6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801aaa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801aae:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ab5:	ff ff ff 
  801ab8:	48 01 d0             	add    %rdx,%rax
  801abb:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801abf:	c9                   	leaveq 
  801ac0:	c3                   	retq   

0000000000801ac1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ac1:	55                   	push   %rbp
  801ac2:	48 89 e5             	mov    %rsp,%rbp
  801ac5:	48 83 ec 08          	sub    $0x8,%rsp
  801ac9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801acd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad1:	48 89 c7             	mov    %rax,%rdi
  801ad4:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  801adb:	00 00 00 
  801ade:	ff d0                	callq  *%rax
  801ae0:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ae6:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801aea:	c9                   	leaveq 
  801aeb:	c3                   	retq   

0000000000801aec <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801aec:	55                   	push   %rbp
  801aed:	48 89 e5             	mov    %rsp,%rbp
  801af0:	48 83 ec 18          	sub    $0x18,%rsp
  801af4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801af8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801aff:	eb 6b                	jmp    801b6c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801b01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b04:	48 98                	cltq   
  801b06:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b0c:	48 c1 e0 0c          	shl    $0xc,%rax
  801b10:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801b14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b18:	48 c1 e8 15          	shr    $0x15,%rax
  801b1c:	48 89 c2             	mov    %rax,%rdx
  801b1f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801b26:	01 00 00 
  801b29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b2d:	83 e0 01             	and    $0x1,%eax
  801b30:	48 85 c0             	test   %rax,%rax
  801b33:	74 21                	je     801b56 <fd_alloc+0x6a>
  801b35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b39:	48 c1 e8 0c          	shr    $0xc,%rax
  801b3d:	48 89 c2             	mov    %rax,%rdx
  801b40:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b47:	01 00 00 
  801b4a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b4e:	83 e0 01             	and    $0x1,%eax
  801b51:	48 85 c0             	test   %rax,%rax
  801b54:	75 12                	jne    801b68 <fd_alloc+0x7c>
			*fd_store = fd;
  801b56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801b61:	b8 00 00 00 00       	mov    $0x0,%eax
  801b66:	eb 1a                	jmp    801b82 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b68:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801b6c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801b70:	7e 8f                	jle    801b01 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801b72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b76:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801b7d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801b82:	c9                   	leaveq 
  801b83:	c3                   	retq   

0000000000801b84 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801b84:	55                   	push   %rbp
  801b85:	48 89 e5             	mov    %rsp,%rbp
  801b88:	48 83 ec 20          	sub    $0x20,%rsp
  801b8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801b8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801b93:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801b97:	78 06                	js     801b9f <fd_lookup+0x1b>
  801b99:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801b9d:	7e 07                	jle    801ba6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ba4:	eb 6c                	jmp    801c12 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ba6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ba9:	48 98                	cltq   
  801bab:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801bb1:	48 c1 e0 0c          	shl    $0xc,%rax
  801bb5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801bb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bbd:	48 c1 e8 15          	shr    $0x15,%rax
  801bc1:	48 89 c2             	mov    %rax,%rdx
  801bc4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801bcb:	01 00 00 
  801bce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bd2:	83 e0 01             	and    $0x1,%eax
  801bd5:	48 85 c0             	test   %rax,%rax
  801bd8:	74 21                	je     801bfb <fd_lookup+0x77>
  801bda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bde:	48 c1 e8 0c          	shr    $0xc,%rax
  801be2:	48 89 c2             	mov    %rax,%rdx
  801be5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bec:	01 00 00 
  801bef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bf3:	83 e0 01             	and    $0x1,%eax
  801bf6:	48 85 c0             	test   %rax,%rax
  801bf9:	75 07                	jne    801c02 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801bfb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c00:	eb 10                	jmp    801c12 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801c02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c06:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c0a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801c0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c12:	c9                   	leaveq 
  801c13:	c3                   	retq   

0000000000801c14 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801c14:	55                   	push   %rbp
  801c15:	48 89 e5             	mov    %rsp,%rbp
  801c18:	48 83 ec 30          	sub    $0x30,%rsp
  801c1c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c20:	89 f0                	mov    %esi,%eax
  801c22:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801c25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c29:	48 89 c7             	mov    %rax,%rdi
  801c2c:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  801c33:	00 00 00 
  801c36:	ff d0                	callq  *%rax
  801c38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c3c:	48 89 d6             	mov    %rdx,%rsi
  801c3f:	89 c7                	mov    %eax,%edi
  801c41:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  801c48:	00 00 00 
  801c4b:	ff d0                	callq  *%rax
  801c4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c54:	78 0a                	js     801c60 <fd_close+0x4c>
	    || fd != fd2)
  801c56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c5a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801c5e:	74 12                	je     801c72 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801c60:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801c64:	74 05                	je     801c6b <fd_close+0x57>
  801c66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c69:	eb 05                	jmp    801c70 <fd_close+0x5c>
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c70:	eb 69                	jmp    801cdb <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c76:	8b 00                	mov    (%rax),%eax
  801c78:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801c7c:	48 89 d6             	mov    %rdx,%rsi
  801c7f:	89 c7                	mov    %eax,%edi
  801c81:	48 b8 dd 1c 80 00 00 	movabs $0x801cdd,%rax
  801c88:	00 00 00 
  801c8b:	ff d0                	callq  *%rax
  801c8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c94:	78 2a                	js     801cc0 <fd_close+0xac>
		if (dev->dev_close)
  801c96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c9a:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c9e:	48 85 c0             	test   %rax,%rax
  801ca1:	74 16                	je     801cb9 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca7:	48 8b 40 20          	mov    0x20(%rax),%rax
  801cab:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801caf:	48 89 d7             	mov    %rdx,%rdi
  801cb2:	ff d0                	callq  *%rax
  801cb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cb7:	eb 07                	jmp    801cc0 <fd_close+0xac>
		else
			r = 0;
  801cb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801cc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc4:	48 89 c6             	mov    %rax,%rsi
  801cc7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ccc:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  801cd3:	00 00 00 
  801cd6:	ff d0                	callq  *%rax
	return r;
  801cd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801cdb:	c9                   	leaveq 
  801cdc:	c3                   	retq   

0000000000801cdd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801cdd:	55                   	push   %rbp
  801cde:	48 89 e5             	mov    %rsp,%rbp
  801ce1:	48 83 ec 20          	sub    $0x20,%rsp
  801ce5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ce8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801cec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801cf3:	eb 41                	jmp    801d36 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801cf5:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801cfc:	00 00 00 
  801cff:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d02:	48 63 d2             	movslq %edx,%rdx
  801d05:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d09:	8b 00                	mov    (%rax),%eax
  801d0b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801d0e:	75 22                	jne    801d32 <dev_lookup+0x55>
			*dev = devtab[i];
  801d10:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801d17:	00 00 00 
  801d1a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d1d:	48 63 d2             	movslq %edx,%rdx
  801d20:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801d24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d28:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d30:	eb 60                	jmp    801d92 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801d32:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d36:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801d3d:	00 00 00 
  801d40:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d43:	48 63 d2             	movslq %edx,%rdx
  801d46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d4a:	48 85 c0             	test   %rax,%rax
  801d4d:	75 a6                	jne    801cf5 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801d4f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801d56:	00 00 00 
  801d59:	48 8b 00             	mov    (%rax),%rax
  801d5c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801d62:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d65:	89 c6                	mov    %eax,%esi
  801d67:	48 bf 18 3f 80 00 00 	movabs $0x803f18,%rdi
  801d6e:	00 00 00 
  801d71:	b8 00 00 00 00       	mov    $0x0,%eax
  801d76:	48 b9 6a 02 80 00 00 	movabs $0x80026a,%rcx
  801d7d:	00 00 00 
  801d80:	ff d1                	callq  *%rcx
	*dev = 0;
  801d82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d86:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801d8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801d92:	c9                   	leaveq 
  801d93:	c3                   	retq   

0000000000801d94 <close>:

int
close(int fdnum)
{
  801d94:	55                   	push   %rbp
  801d95:	48 89 e5             	mov    %rsp,%rbp
  801d98:	48 83 ec 20          	sub    $0x20,%rsp
  801d9c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d9f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801da3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801da6:	48 89 d6             	mov    %rdx,%rsi
  801da9:	89 c7                	mov    %eax,%edi
  801dab:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  801db2:	00 00 00 
  801db5:	ff d0                	callq  *%rax
  801db7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dbe:	79 05                	jns    801dc5 <close+0x31>
		return r;
  801dc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc3:	eb 18                	jmp    801ddd <close+0x49>
	else
		return fd_close(fd, 1);
  801dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc9:	be 01 00 00 00       	mov    $0x1,%esi
  801dce:	48 89 c7             	mov    %rax,%rdi
  801dd1:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  801dd8:	00 00 00 
  801ddb:	ff d0                	callq  *%rax
}
  801ddd:	c9                   	leaveq 
  801dde:	c3                   	retq   

0000000000801ddf <close_all>:

void
close_all(void)
{
  801ddf:	55                   	push   %rbp
  801de0:	48 89 e5             	mov    %rsp,%rbp
  801de3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801de7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dee:	eb 15                	jmp    801e05 <close_all+0x26>
		close(i);
  801df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df3:	89 c7                	mov    %eax,%edi
  801df5:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  801dfc:	00 00 00 
  801dff:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e01:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e05:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e09:	7e e5                	jle    801df0 <close_all+0x11>
		close(i);
}
  801e0b:	c9                   	leaveq 
  801e0c:	c3                   	retq   

0000000000801e0d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e0d:	55                   	push   %rbp
  801e0e:	48 89 e5             	mov    %rsp,%rbp
  801e11:	48 83 ec 40          	sub    $0x40,%rsp
  801e15:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801e18:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e1b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801e1f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e22:	48 89 d6             	mov    %rdx,%rsi
  801e25:	89 c7                	mov    %eax,%edi
  801e27:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  801e2e:	00 00 00 
  801e31:	ff d0                	callq  *%rax
  801e33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e3a:	79 08                	jns    801e44 <dup+0x37>
		return r;
  801e3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e3f:	e9 70 01 00 00       	jmpq   801fb4 <dup+0x1a7>
	close(newfdnum);
  801e44:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e47:	89 c7                	mov    %eax,%edi
  801e49:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  801e50:	00 00 00 
  801e53:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801e55:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e58:	48 98                	cltq   
  801e5a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e60:	48 c1 e0 0c          	shl    $0xc,%rax
  801e64:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801e68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e6c:	48 89 c7             	mov    %rax,%rdi
  801e6f:	48 b8 c1 1a 80 00 00 	movabs $0x801ac1,%rax
  801e76:	00 00 00 
  801e79:	ff d0                	callq  *%rax
  801e7b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801e7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e83:	48 89 c7             	mov    %rax,%rdi
  801e86:	48 b8 c1 1a 80 00 00 	movabs $0x801ac1,%rax
  801e8d:	00 00 00 
  801e90:	ff d0                	callq  *%rax
  801e92:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9a:	48 c1 e8 15          	shr    $0x15,%rax
  801e9e:	48 89 c2             	mov    %rax,%rdx
  801ea1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ea8:	01 00 00 
  801eab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eaf:	83 e0 01             	and    $0x1,%eax
  801eb2:	48 85 c0             	test   %rax,%rax
  801eb5:	74 73                	je     801f2a <dup+0x11d>
  801eb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebb:	48 c1 e8 0c          	shr    $0xc,%rax
  801ebf:	48 89 c2             	mov    %rax,%rdx
  801ec2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec9:	01 00 00 
  801ecc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed0:	83 e0 01             	and    $0x1,%eax
  801ed3:	48 85 c0             	test   %rax,%rax
  801ed6:	74 52                	je     801f2a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801edc:	48 c1 e8 0c          	shr    $0xc,%rax
  801ee0:	48 89 c2             	mov    %rax,%rdx
  801ee3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eea:	01 00 00 
  801eed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef1:	25 07 0e 00 00       	and    $0xe07,%eax
  801ef6:	89 c1                	mov    %eax,%ecx
  801ef8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801efc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f00:	41 89 c8             	mov    %ecx,%r8d
  801f03:	48 89 d1             	mov    %rdx,%rcx
  801f06:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0b:	48 89 c6             	mov    %rax,%rsi
  801f0e:	bf 00 00 00 00       	mov    $0x0,%edi
  801f13:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801f1a:	00 00 00 
  801f1d:	ff d0                	callq  *%rax
  801f1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f26:	79 02                	jns    801f2a <dup+0x11d>
			goto err;
  801f28:	eb 57                	jmp    801f81 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f2e:	48 c1 e8 0c          	shr    $0xc,%rax
  801f32:	48 89 c2             	mov    %rax,%rdx
  801f35:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f3c:	01 00 00 
  801f3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f43:	25 07 0e 00 00       	and    $0xe07,%eax
  801f48:	89 c1                	mov    %eax,%ecx
  801f4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f4e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f52:	41 89 c8             	mov    %ecx,%r8d
  801f55:	48 89 d1             	mov    %rdx,%rcx
  801f58:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5d:	48 89 c6             	mov    %rax,%rsi
  801f60:	bf 00 00 00 00       	mov    $0x0,%edi
  801f65:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801f6c:	00 00 00 
  801f6f:	ff d0                	callq  *%rax
  801f71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f78:	79 02                	jns    801f7c <dup+0x16f>
		goto err;
  801f7a:	eb 05                	jmp    801f81 <dup+0x174>

	return newfdnum;
  801f7c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f7f:	eb 33                	jmp    801fb4 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f85:	48 89 c6             	mov    %rax,%rsi
  801f88:	bf 00 00 00 00       	mov    $0x0,%edi
  801f8d:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  801f94:	00 00 00 
  801f97:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801f99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f9d:	48 89 c6             	mov    %rax,%rsi
  801fa0:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa5:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  801fac:	00 00 00 
  801faf:	ff d0                	callq  *%rax
	return r;
  801fb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fb4:	c9                   	leaveq 
  801fb5:	c3                   	retq   

0000000000801fb6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801fb6:	55                   	push   %rbp
  801fb7:	48 89 e5             	mov    %rsp,%rbp
  801fba:	48 83 ec 40          	sub    $0x40,%rsp
  801fbe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801fc1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801fc5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801fc9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fcd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801fd0:	48 89 d6             	mov    %rdx,%rsi
  801fd3:	89 c7                	mov    %eax,%edi
  801fd5:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  801fdc:	00 00 00 
  801fdf:	ff d0                	callq  *%rax
  801fe1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fe4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fe8:	78 24                	js     80200e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fee:	8b 00                	mov    (%rax),%eax
  801ff0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ff4:	48 89 d6             	mov    %rdx,%rsi
  801ff7:	89 c7                	mov    %eax,%edi
  801ff9:	48 b8 dd 1c 80 00 00 	movabs $0x801cdd,%rax
  802000:	00 00 00 
  802003:	ff d0                	callq  *%rax
  802005:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802008:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80200c:	79 05                	jns    802013 <read+0x5d>
		return r;
  80200e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802011:	eb 76                	jmp    802089 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802013:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802017:	8b 40 08             	mov    0x8(%rax),%eax
  80201a:	83 e0 03             	and    $0x3,%eax
  80201d:	83 f8 01             	cmp    $0x1,%eax
  802020:	75 3a                	jne    80205c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802022:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802029:	00 00 00 
  80202c:	48 8b 00             	mov    (%rax),%rax
  80202f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802035:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802038:	89 c6                	mov    %eax,%esi
  80203a:	48 bf 37 3f 80 00 00 	movabs $0x803f37,%rdi
  802041:	00 00 00 
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	48 b9 6a 02 80 00 00 	movabs $0x80026a,%rcx
  802050:	00 00 00 
  802053:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802055:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80205a:	eb 2d                	jmp    802089 <read+0xd3>
	}
	if (!dev->dev_read)
  80205c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802060:	48 8b 40 10          	mov    0x10(%rax),%rax
  802064:	48 85 c0             	test   %rax,%rax
  802067:	75 07                	jne    802070 <read+0xba>
		return -E_NOT_SUPP;
  802069:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80206e:	eb 19                	jmp    802089 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802070:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802074:	48 8b 40 10          	mov    0x10(%rax),%rax
  802078:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80207c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802080:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802084:	48 89 cf             	mov    %rcx,%rdi
  802087:	ff d0                	callq  *%rax
}
  802089:	c9                   	leaveq 
  80208a:	c3                   	retq   

000000000080208b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80208b:	55                   	push   %rbp
  80208c:	48 89 e5             	mov    %rsp,%rbp
  80208f:	48 83 ec 30          	sub    $0x30,%rsp
  802093:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802096:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80209a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80209e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020a5:	eb 49                	jmp    8020f0 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8020a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020aa:	48 98                	cltq   
  8020ac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8020b0:	48 29 c2             	sub    %rax,%rdx
  8020b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b6:	48 63 c8             	movslq %eax,%rcx
  8020b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020bd:	48 01 c1             	add    %rax,%rcx
  8020c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020c3:	48 89 ce             	mov    %rcx,%rsi
  8020c6:	89 c7                	mov    %eax,%edi
  8020c8:	48 b8 b6 1f 80 00 00 	movabs $0x801fb6,%rax
  8020cf:	00 00 00 
  8020d2:	ff d0                	callq  *%rax
  8020d4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8020d7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020db:	79 05                	jns    8020e2 <readn+0x57>
			return m;
  8020dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020e0:	eb 1c                	jmp    8020fe <readn+0x73>
		if (m == 0)
  8020e2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020e6:	75 02                	jne    8020ea <readn+0x5f>
			break;
  8020e8:	eb 11                	jmp    8020fb <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8020ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020ed:	01 45 fc             	add    %eax,-0x4(%rbp)
  8020f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f3:	48 98                	cltq   
  8020f5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8020f9:	72 ac                	jb     8020a7 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8020fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020fe:	c9                   	leaveq 
  8020ff:	c3                   	retq   

0000000000802100 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802100:	55                   	push   %rbp
  802101:	48 89 e5             	mov    %rsp,%rbp
  802104:	48 83 ec 40          	sub    $0x40,%rsp
  802108:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80210b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80210f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802113:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802117:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80211a:	48 89 d6             	mov    %rdx,%rsi
  80211d:	89 c7                	mov    %eax,%edi
  80211f:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  802126:	00 00 00 
  802129:	ff d0                	callq  *%rax
  80212b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80212e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802132:	78 24                	js     802158 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802138:	8b 00                	mov    (%rax),%eax
  80213a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80213e:	48 89 d6             	mov    %rdx,%rsi
  802141:	89 c7                	mov    %eax,%edi
  802143:	48 b8 dd 1c 80 00 00 	movabs $0x801cdd,%rax
  80214a:	00 00 00 
  80214d:	ff d0                	callq  *%rax
  80214f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802156:	79 05                	jns    80215d <write+0x5d>
		return r;
  802158:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215b:	eb 42                	jmp    80219f <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80215d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802161:	8b 40 08             	mov    0x8(%rax),%eax
  802164:	83 e0 03             	and    $0x3,%eax
  802167:	85 c0                	test   %eax,%eax
  802169:	75 07                	jne    802172 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80216b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802170:	eb 2d                	jmp    80219f <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802176:	48 8b 40 18          	mov    0x18(%rax),%rax
  80217a:	48 85 c0             	test   %rax,%rax
  80217d:	75 07                	jne    802186 <write+0x86>
		return -E_NOT_SUPP;
  80217f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802184:	eb 19                	jmp    80219f <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802186:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80218a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80218e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802192:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802196:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80219a:	48 89 cf             	mov    %rcx,%rdi
  80219d:	ff d0                	callq  *%rax
}
  80219f:	c9                   	leaveq 
  8021a0:	c3                   	retq   

00000000008021a1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8021a1:	55                   	push   %rbp
  8021a2:	48 89 e5             	mov    %rsp,%rbp
  8021a5:	48 83 ec 18          	sub    $0x18,%rsp
  8021a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021ac:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021af:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021b6:	48 89 d6             	mov    %rdx,%rsi
  8021b9:	89 c7                	mov    %eax,%edi
  8021bb:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  8021c2:	00 00 00 
  8021c5:	ff d0                	callq  *%rax
  8021c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ce:	79 05                	jns    8021d5 <seek+0x34>
		return r;
  8021d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d3:	eb 0f                	jmp    8021e4 <seek+0x43>
	fd->fd_offset = offset;
  8021d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021dc:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8021df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e4:	c9                   	leaveq 
  8021e5:	c3                   	retq   

00000000008021e6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8021e6:	55                   	push   %rbp
  8021e7:	48 89 e5             	mov    %rsp,%rbp
  8021ea:	48 83 ec 30          	sub    $0x30,%rsp
  8021ee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021f1:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021f4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021fb:	48 89 d6             	mov    %rdx,%rsi
  8021fe:	89 c7                	mov    %eax,%edi
  802200:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  802207:	00 00 00 
  80220a:	ff d0                	callq  *%rax
  80220c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802213:	78 24                	js     802239 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802219:	8b 00                	mov    (%rax),%eax
  80221b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80221f:	48 89 d6             	mov    %rdx,%rsi
  802222:	89 c7                	mov    %eax,%edi
  802224:	48 b8 dd 1c 80 00 00 	movabs $0x801cdd,%rax
  80222b:	00 00 00 
  80222e:	ff d0                	callq  *%rax
  802230:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802233:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802237:	79 05                	jns    80223e <ftruncate+0x58>
		return r;
  802239:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223c:	eb 72                	jmp    8022b0 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80223e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802242:	8b 40 08             	mov    0x8(%rax),%eax
  802245:	83 e0 03             	and    $0x3,%eax
  802248:	85 c0                	test   %eax,%eax
  80224a:	75 3a                	jne    802286 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80224c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802253:	00 00 00 
  802256:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802259:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80225f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802262:	89 c6                	mov    %eax,%esi
  802264:	48 bf 58 3f 80 00 00 	movabs $0x803f58,%rdi
  80226b:	00 00 00 
  80226e:	b8 00 00 00 00       	mov    $0x0,%eax
  802273:	48 b9 6a 02 80 00 00 	movabs $0x80026a,%rcx
  80227a:	00 00 00 
  80227d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80227f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802284:	eb 2a                	jmp    8022b0 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80228a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80228e:	48 85 c0             	test   %rax,%rax
  802291:	75 07                	jne    80229a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802293:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802298:	eb 16                	jmp    8022b0 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80229a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80229e:	48 8b 40 30          	mov    0x30(%rax),%rax
  8022a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022a6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8022a9:	89 ce                	mov    %ecx,%esi
  8022ab:	48 89 d7             	mov    %rdx,%rdi
  8022ae:	ff d0                	callq  *%rax
}
  8022b0:	c9                   	leaveq 
  8022b1:	c3                   	retq   

00000000008022b2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8022b2:	55                   	push   %rbp
  8022b3:	48 89 e5             	mov    %rsp,%rbp
  8022b6:	48 83 ec 30          	sub    $0x30,%rsp
  8022ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022c1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022c8:	48 89 d6             	mov    %rdx,%rsi
  8022cb:	89 c7                	mov    %eax,%edi
  8022cd:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	callq  *%rax
  8022d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e0:	78 24                	js     802306 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e6:	8b 00                	mov    (%rax),%eax
  8022e8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ec:	48 89 d6             	mov    %rdx,%rsi
  8022ef:	89 c7                	mov    %eax,%edi
  8022f1:	48 b8 dd 1c 80 00 00 	movabs $0x801cdd,%rax
  8022f8:	00 00 00 
  8022fb:	ff d0                	callq  *%rax
  8022fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802300:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802304:	79 05                	jns    80230b <fstat+0x59>
		return r;
  802306:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802309:	eb 5e                	jmp    802369 <fstat+0xb7>
	if (!dev->dev_stat)
  80230b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80230f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802313:	48 85 c0             	test   %rax,%rax
  802316:	75 07                	jne    80231f <fstat+0x6d>
		return -E_NOT_SUPP;
  802318:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80231d:	eb 4a                	jmp    802369 <fstat+0xb7>
	stat->st_name[0] = 0;
  80231f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802323:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802326:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80232a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802331:	00 00 00 
	stat->st_isdir = 0;
  802334:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802338:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80233f:	00 00 00 
	stat->st_dev = dev;
  802342:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802346:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80234a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802351:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802355:	48 8b 40 28          	mov    0x28(%rax),%rax
  802359:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80235d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802361:	48 89 ce             	mov    %rcx,%rsi
  802364:	48 89 d7             	mov    %rdx,%rdi
  802367:	ff d0                	callq  *%rax
}
  802369:	c9                   	leaveq 
  80236a:	c3                   	retq   

000000000080236b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80236b:	55                   	push   %rbp
  80236c:	48 89 e5             	mov    %rsp,%rbp
  80236f:	48 83 ec 20          	sub    $0x20,%rsp
  802373:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802377:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80237b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237f:	be 00 00 00 00       	mov    $0x0,%esi
  802384:	48 89 c7             	mov    %rax,%rdi
  802387:	48 b8 59 24 80 00 00 	movabs $0x802459,%rax
  80238e:	00 00 00 
  802391:	ff d0                	callq  *%rax
  802393:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802396:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80239a:	79 05                	jns    8023a1 <stat+0x36>
		return fd;
  80239c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80239f:	eb 2f                	jmp    8023d0 <stat+0x65>
	r = fstat(fd, stat);
  8023a1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a8:	48 89 d6             	mov    %rdx,%rsi
  8023ab:	89 c7                	mov    %eax,%edi
  8023ad:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  8023b4:	00 00 00 
  8023b7:	ff d0                	callq  *%rax
  8023b9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8023bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023bf:	89 c7                	mov    %eax,%edi
  8023c1:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  8023c8:	00 00 00 
  8023cb:	ff d0                	callq  *%rax
	return r;
  8023cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8023d0:	c9                   	leaveq 
  8023d1:	c3                   	retq   

00000000008023d2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8023d2:	55                   	push   %rbp
  8023d3:	48 89 e5             	mov    %rsp,%rbp
  8023d6:	48 83 ec 10          	sub    $0x10,%rsp
  8023da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8023e1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8023e8:	00 00 00 
  8023eb:	8b 00                	mov    (%rax),%eax
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	75 1d                	jne    80240e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023f1:	bf 01 00 00 00       	mov    $0x1,%edi
  8023f6:	48 b8 ca 38 80 00 00 	movabs $0x8038ca,%rax
  8023fd:	00 00 00 
  802400:	ff d0                	callq  *%rax
  802402:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802409:	00 00 00 
  80240c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80240e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802415:	00 00 00 
  802418:	8b 00                	mov    (%rax),%eax
  80241a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80241d:	b9 07 00 00 00       	mov    $0x7,%ecx
  802422:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802429:	00 00 00 
  80242c:	89 c7                	mov    %eax,%edi
  80242e:	48 b8 fd 34 80 00 00 	movabs $0x8034fd,%rax
  802435:	00 00 00 
  802438:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80243a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243e:	ba 00 00 00 00       	mov    $0x0,%edx
  802443:	48 89 c6             	mov    %rax,%rsi
  802446:	bf 00 00 00 00       	mov    $0x0,%edi
  80244b:	48 b8 ff 33 80 00 00 	movabs $0x8033ff,%rax
  802452:	00 00 00 
  802455:	ff d0                	callq  *%rax
}
  802457:	c9                   	leaveq 
  802458:	c3                   	retq   

0000000000802459 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802459:	55                   	push   %rbp
  80245a:	48 89 e5             	mov    %rsp,%rbp
  80245d:	48 83 ec 30          	sub    $0x30,%rsp
  802461:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802465:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802468:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80246f:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802476:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80247d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802482:	75 08                	jne    80248c <open+0x33>
	{
		return r;
  802484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802487:	e9 f2 00 00 00       	jmpq   80257e <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80248c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802490:	48 89 c7             	mov    %rax,%rdi
  802493:	48 b8 b3 0d 80 00 00 	movabs $0x800db3,%rax
  80249a:	00 00 00 
  80249d:	ff d0                	callq  *%rax
  80249f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8024a2:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8024a9:	7e 0a                	jle    8024b5 <open+0x5c>
	{
		return -E_BAD_PATH;
  8024ab:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8024b0:	e9 c9 00 00 00       	jmpq   80257e <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8024b5:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8024bc:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8024bd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8024c1:	48 89 c7             	mov    %rax,%rdi
  8024c4:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  8024cb:	00 00 00 
  8024ce:	ff d0                	callq  *%rax
  8024d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d7:	78 09                	js     8024e2 <open+0x89>
  8024d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024dd:	48 85 c0             	test   %rax,%rax
  8024e0:	75 08                	jne    8024ea <open+0x91>
		{
			return r;
  8024e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e5:	e9 94 00 00 00       	jmpq   80257e <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8024ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024ee:	ba 00 04 00 00       	mov    $0x400,%edx
  8024f3:	48 89 c6             	mov    %rax,%rsi
  8024f6:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8024fd:	00 00 00 
  802500:	48 b8 b1 0e 80 00 00 	movabs $0x800eb1,%rax
  802507:	00 00 00 
  80250a:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80250c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802513:	00 00 00 
  802516:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802519:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80251f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802523:	48 89 c6             	mov    %rax,%rsi
  802526:	bf 01 00 00 00       	mov    $0x1,%edi
  80252b:	48 b8 d2 23 80 00 00 	movabs $0x8023d2,%rax
  802532:	00 00 00 
  802535:	ff d0                	callq  *%rax
  802537:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253e:	79 2b                	jns    80256b <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802544:	be 00 00 00 00       	mov    $0x0,%esi
  802549:	48 89 c7             	mov    %rax,%rdi
  80254c:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  802553:	00 00 00 
  802556:	ff d0                	callq  *%rax
  802558:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80255b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80255f:	79 05                	jns    802566 <open+0x10d>
			{
				return d;
  802561:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802564:	eb 18                	jmp    80257e <open+0x125>
			}
			return r;
  802566:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802569:	eb 13                	jmp    80257e <open+0x125>
		}	
		return fd2num(fd_store);
  80256b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256f:	48 89 c7             	mov    %rax,%rdi
  802572:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  802579:	00 00 00 
  80257c:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80257e:	c9                   	leaveq 
  80257f:	c3                   	retq   

0000000000802580 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802580:	55                   	push   %rbp
  802581:	48 89 e5             	mov    %rsp,%rbp
  802584:	48 83 ec 10          	sub    $0x10,%rsp
  802588:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80258c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802590:	8b 50 0c             	mov    0xc(%rax),%edx
  802593:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80259a:	00 00 00 
  80259d:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80259f:	be 00 00 00 00       	mov    $0x0,%esi
  8025a4:	bf 06 00 00 00       	mov    $0x6,%edi
  8025a9:	48 b8 d2 23 80 00 00 	movabs $0x8023d2,%rax
  8025b0:	00 00 00 
  8025b3:	ff d0                	callq  *%rax
}
  8025b5:	c9                   	leaveq 
  8025b6:	c3                   	retq   

00000000008025b7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8025b7:	55                   	push   %rbp
  8025b8:	48 89 e5             	mov    %rsp,%rbp
  8025bb:	48 83 ec 30          	sub    $0x30,%rsp
  8025bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8025cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8025d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8025d7:	74 07                	je     8025e0 <devfile_read+0x29>
  8025d9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8025de:	75 07                	jne    8025e7 <devfile_read+0x30>
		return -E_INVAL;
  8025e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025e5:	eb 77                	jmp    80265e <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8025e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025eb:	8b 50 0c             	mov    0xc(%rax),%edx
  8025ee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025f5:	00 00 00 
  8025f8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8025fa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802601:	00 00 00 
  802604:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802608:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80260c:	be 00 00 00 00       	mov    $0x0,%esi
  802611:	bf 03 00 00 00       	mov    $0x3,%edi
  802616:	48 b8 d2 23 80 00 00 	movabs $0x8023d2,%rax
  80261d:	00 00 00 
  802620:	ff d0                	callq  *%rax
  802622:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802625:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802629:	7f 05                	jg     802630 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80262b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262e:	eb 2e                	jmp    80265e <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802630:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802633:	48 63 d0             	movslq %eax,%rdx
  802636:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80263a:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802641:	00 00 00 
  802644:	48 89 c7             	mov    %rax,%rdi
  802647:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  80264e:	00 00 00 
  802651:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802653:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802657:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80265b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80265e:	c9                   	leaveq 
  80265f:	c3                   	retq   

0000000000802660 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802660:	55                   	push   %rbp
  802661:	48 89 e5             	mov    %rsp,%rbp
  802664:	48 83 ec 30          	sub    $0x30,%rsp
  802668:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80266c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802670:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802674:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80267b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802680:	74 07                	je     802689 <devfile_write+0x29>
  802682:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802687:	75 08                	jne    802691 <devfile_write+0x31>
		return r;
  802689:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80268c:	e9 9a 00 00 00       	jmpq   80272b <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802695:	8b 50 0c             	mov    0xc(%rax),%edx
  802698:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80269f:	00 00 00 
  8026a2:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8026a4:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8026ab:	00 
  8026ac:	76 08                	jbe    8026b6 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8026ae:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8026b5:	00 
	}
	fsipcbuf.write.req_n = n;
  8026b6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026bd:	00 00 00 
  8026c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026c4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8026c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d0:	48 89 c6             	mov    %rax,%rsi
  8026d3:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8026da:	00 00 00 
  8026dd:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8026e9:	be 00 00 00 00       	mov    $0x0,%esi
  8026ee:	bf 04 00 00 00       	mov    $0x4,%edi
  8026f3:	48 b8 d2 23 80 00 00 	movabs $0x8023d2,%rax
  8026fa:	00 00 00 
  8026fd:	ff d0                	callq  *%rax
  8026ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802702:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802706:	7f 20                	jg     802728 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802708:	48 bf 7e 3f 80 00 00 	movabs $0x803f7e,%rdi
  80270f:	00 00 00 
  802712:	b8 00 00 00 00       	mov    $0x0,%eax
  802717:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  80271e:	00 00 00 
  802721:	ff d2                	callq  *%rdx
		return r;
  802723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802726:	eb 03                	jmp    80272b <devfile_write+0xcb>
	}
	return r;
  802728:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80272b:	c9                   	leaveq 
  80272c:	c3                   	retq   

000000000080272d <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80272d:	55                   	push   %rbp
  80272e:	48 89 e5             	mov    %rsp,%rbp
  802731:	48 83 ec 20          	sub    $0x20,%rsp
  802735:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802739:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80273d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802741:	8b 50 0c             	mov    0xc(%rax),%edx
  802744:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80274b:	00 00 00 
  80274e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802750:	be 00 00 00 00       	mov    $0x0,%esi
  802755:	bf 05 00 00 00       	mov    $0x5,%edi
  80275a:	48 b8 d2 23 80 00 00 	movabs $0x8023d2,%rax
  802761:	00 00 00 
  802764:	ff d0                	callq  *%rax
  802766:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802769:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80276d:	79 05                	jns    802774 <devfile_stat+0x47>
		return r;
  80276f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802772:	eb 56                	jmp    8027ca <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802774:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802778:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80277f:	00 00 00 
  802782:	48 89 c7             	mov    %rax,%rdi
  802785:	48 b8 1f 0e 80 00 00 	movabs $0x800e1f,%rax
  80278c:	00 00 00 
  80278f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802791:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802798:	00 00 00 
  80279b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8027a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027a5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8027ab:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027b2:	00 00 00 
  8027b5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8027bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027bf:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8027c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ca:	c9                   	leaveq 
  8027cb:	c3                   	retq   

00000000008027cc <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8027cc:	55                   	push   %rbp
  8027cd:	48 89 e5             	mov    %rsp,%rbp
  8027d0:	48 83 ec 10          	sub    $0x10,%rsp
  8027d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027d8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8027db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027df:	8b 50 0c             	mov    0xc(%rax),%edx
  8027e2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027e9:	00 00 00 
  8027ec:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8027ee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027f5:	00 00 00 
  8027f8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027fb:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8027fe:	be 00 00 00 00       	mov    $0x0,%esi
  802803:	bf 02 00 00 00       	mov    $0x2,%edi
  802808:	48 b8 d2 23 80 00 00 	movabs $0x8023d2,%rax
  80280f:	00 00 00 
  802812:	ff d0                	callq  *%rax
}
  802814:	c9                   	leaveq 
  802815:	c3                   	retq   

0000000000802816 <remove>:

// Delete a file
int
remove(const char *path)
{
  802816:	55                   	push   %rbp
  802817:	48 89 e5             	mov    %rsp,%rbp
  80281a:	48 83 ec 10          	sub    $0x10,%rsp
  80281e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802822:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802826:	48 89 c7             	mov    %rax,%rdi
  802829:	48 b8 b3 0d 80 00 00 	movabs $0x800db3,%rax
  802830:	00 00 00 
  802833:	ff d0                	callq  *%rax
  802835:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80283a:	7e 07                	jle    802843 <remove+0x2d>
		return -E_BAD_PATH;
  80283c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802841:	eb 33                	jmp    802876 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802843:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802847:	48 89 c6             	mov    %rax,%rsi
  80284a:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802851:	00 00 00 
  802854:	48 b8 1f 0e 80 00 00 	movabs $0x800e1f,%rax
  80285b:	00 00 00 
  80285e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802860:	be 00 00 00 00       	mov    $0x0,%esi
  802865:	bf 07 00 00 00       	mov    $0x7,%edi
  80286a:	48 b8 d2 23 80 00 00 	movabs $0x8023d2,%rax
  802871:	00 00 00 
  802874:	ff d0                	callq  *%rax
}
  802876:	c9                   	leaveq 
  802877:	c3                   	retq   

0000000000802878 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802878:	55                   	push   %rbp
  802879:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80287c:	be 00 00 00 00       	mov    $0x0,%esi
  802881:	bf 08 00 00 00       	mov    $0x8,%edi
  802886:	48 b8 d2 23 80 00 00 	movabs $0x8023d2,%rax
  80288d:	00 00 00 
  802890:	ff d0                	callq  *%rax
}
  802892:	5d                   	pop    %rbp
  802893:	c3                   	retq   

0000000000802894 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802894:	55                   	push   %rbp
  802895:	48 89 e5             	mov    %rsp,%rbp
  802898:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80289f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8028a6:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8028ad:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8028b4:	be 00 00 00 00       	mov    $0x0,%esi
  8028b9:	48 89 c7             	mov    %rax,%rdi
  8028bc:	48 b8 59 24 80 00 00 	movabs $0x802459,%rax
  8028c3:	00 00 00 
  8028c6:	ff d0                	callq  *%rax
  8028c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8028cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028cf:	79 28                	jns    8028f9 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8028d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d4:	89 c6                	mov    %eax,%esi
  8028d6:	48 bf 9a 3f 80 00 00 	movabs $0x803f9a,%rdi
  8028dd:	00 00 00 
  8028e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e5:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  8028ec:	00 00 00 
  8028ef:	ff d2                	callq  *%rdx
		return fd_src;
  8028f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f4:	e9 74 01 00 00       	jmpq   802a6d <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8028f9:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802900:	be 01 01 00 00       	mov    $0x101,%esi
  802905:	48 89 c7             	mov    %rax,%rdi
  802908:	48 b8 59 24 80 00 00 	movabs $0x802459,%rax
  80290f:	00 00 00 
  802912:	ff d0                	callq  *%rax
  802914:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802917:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80291b:	79 39                	jns    802956 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80291d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802920:	89 c6                	mov    %eax,%esi
  802922:	48 bf b0 3f 80 00 00 	movabs $0x803fb0,%rdi
  802929:	00 00 00 
  80292c:	b8 00 00 00 00       	mov    $0x0,%eax
  802931:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  802938:	00 00 00 
  80293b:	ff d2                	callq  *%rdx
		close(fd_src);
  80293d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802940:	89 c7                	mov    %eax,%edi
  802942:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  802949:	00 00 00 
  80294c:	ff d0                	callq  *%rax
		return fd_dest;
  80294e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802951:	e9 17 01 00 00       	jmpq   802a6d <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802956:	eb 74                	jmp    8029cc <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802958:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80295b:	48 63 d0             	movslq %eax,%rdx
  80295e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802965:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802968:	48 89 ce             	mov    %rcx,%rsi
  80296b:	89 c7                	mov    %eax,%edi
  80296d:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
  802979:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80297c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802980:	79 4a                	jns    8029cc <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802982:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802985:	89 c6                	mov    %eax,%esi
  802987:	48 bf ca 3f 80 00 00 	movabs $0x803fca,%rdi
  80298e:	00 00 00 
  802991:	b8 00 00 00 00       	mov    $0x0,%eax
  802996:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  80299d:	00 00 00 
  8029a0:	ff d2                	callq  *%rdx
			close(fd_src);
  8029a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a5:	89 c7                	mov    %eax,%edi
  8029a7:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  8029ae:	00 00 00 
  8029b1:	ff d0                	callq  *%rax
			close(fd_dest);
  8029b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029b6:	89 c7                	mov    %eax,%edi
  8029b8:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	callq  *%rax
			return write_size;
  8029c4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029c7:	e9 a1 00 00 00       	jmpq   802a6d <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8029cc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8029d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d6:	ba 00 02 00 00       	mov    $0x200,%edx
  8029db:	48 89 ce             	mov    %rcx,%rsi
  8029de:	89 c7                	mov    %eax,%edi
  8029e0:	48 b8 b6 1f 80 00 00 	movabs $0x801fb6,%rax
  8029e7:	00 00 00 
  8029ea:	ff d0                	callq  *%rax
  8029ec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8029ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029f3:	0f 8f 5f ff ff ff    	jg     802958 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8029f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029fd:	79 47                	jns    802a46 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8029ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a02:	89 c6                	mov    %eax,%esi
  802a04:	48 bf dd 3f 80 00 00 	movabs $0x803fdd,%rdi
  802a0b:	00 00 00 
  802a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a13:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  802a1a:	00 00 00 
  802a1d:	ff d2                	callq  *%rdx
		close(fd_src);
  802a1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a22:	89 c7                	mov    %eax,%edi
  802a24:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	callq  *%rax
		close(fd_dest);
  802a30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a33:	89 c7                	mov    %eax,%edi
  802a35:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  802a3c:	00 00 00 
  802a3f:	ff d0                	callq  *%rax
		return read_size;
  802a41:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a44:	eb 27                	jmp    802a6d <copy+0x1d9>
	}
	close(fd_src);
  802a46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a49:	89 c7                	mov    %eax,%edi
  802a4b:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  802a52:	00 00 00 
  802a55:	ff d0                	callq  *%rax
	close(fd_dest);
  802a57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a5a:	89 c7                	mov    %eax,%edi
  802a5c:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
	return 0;
  802a68:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802a6d:	c9                   	leaveq 
  802a6e:	c3                   	retq   

0000000000802a6f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a6f:	55                   	push   %rbp
  802a70:	48 89 e5             	mov    %rsp,%rbp
  802a73:	53                   	push   %rbx
  802a74:	48 83 ec 38          	sub    $0x38,%rsp
  802a78:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a7c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802a80:	48 89 c7             	mov    %rax,%rdi
  802a83:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  802a8a:	00 00 00 
  802a8d:	ff d0                	callq  *%rax
  802a8f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a92:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a96:	0f 88 bf 01 00 00    	js     802c5b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa0:	ba 07 04 00 00       	mov    $0x407,%edx
  802aa5:	48 89 c6             	mov    %rax,%rsi
  802aa8:	bf 00 00 00 00       	mov    $0x0,%edi
  802aad:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  802ab4:	00 00 00 
  802ab7:	ff d0                	callq  *%rax
  802ab9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802abc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ac0:	0f 88 95 01 00 00    	js     802c5b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802ac6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802aca:	48 89 c7             	mov    %rax,%rdi
  802acd:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  802ad4:	00 00 00 
  802ad7:	ff d0                	callq  *%rax
  802ad9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802adc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ae0:	0f 88 5d 01 00 00    	js     802c43 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ae6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aea:	ba 07 04 00 00       	mov    $0x407,%edx
  802aef:	48 89 c6             	mov    %rax,%rsi
  802af2:	bf 00 00 00 00       	mov    $0x0,%edi
  802af7:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  802afe:	00 00 00 
  802b01:	ff d0                	callq  *%rax
  802b03:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b06:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b0a:	0f 88 33 01 00 00    	js     802c43 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802b10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b14:	48 89 c7             	mov    %rax,%rdi
  802b17:	48 b8 c1 1a 80 00 00 	movabs $0x801ac1,%rax
  802b1e:	00 00 00 
  802b21:	ff d0                	callq  *%rax
  802b23:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b2b:	ba 07 04 00 00       	mov    $0x407,%edx
  802b30:	48 89 c6             	mov    %rax,%rsi
  802b33:	bf 00 00 00 00       	mov    $0x0,%edi
  802b38:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
  802b44:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b47:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b4b:	79 05                	jns    802b52 <pipe+0xe3>
		goto err2;
  802b4d:	e9 d9 00 00 00       	jmpq   802c2b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b56:	48 89 c7             	mov    %rax,%rdi
  802b59:	48 b8 c1 1a 80 00 00 	movabs $0x801ac1,%rax
  802b60:	00 00 00 
  802b63:	ff d0                	callq  *%rax
  802b65:	48 89 c2             	mov    %rax,%rdx
  802b68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b6c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802b72:	48 89 d1             	mov    %rdx,%rcx
  802b75:	ba 00 00 00 00       	mov    $0x0,%edx
  802b7a:	48 89 c6             	mov    %rax,%rsi
  802b7d:	bf 00 00 00 00       	mov    $0x0,%edi
  802b82:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  802b89:	00 00 00 
  802b8c:	ff d0                	callq  *%rax
  802b8e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b91:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b95:	79 1b                	jns    802bb2 <pipe+0x143>
		goto err3;
  802b97:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802b98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b9c:	48 89 c6             	mov    %rax,%rsi
  802b9f:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba4:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  802bab:	00 00 00 
  802bae:	ff d0                	callq  *%rax
  802bb0:	eb 79                	jmp    802c2b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802bb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bb6:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  802bbd:	00 00 00 
  802bc0:	8b 12                	mov    (%rdx),%edx
  802bc2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802bc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bc8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802bcf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bd3:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  802bda:	00 00 00 
  802bdd:	8b 12                	mov    (%rdx),%edx
  802bdf:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802be1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802be5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802bec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bf0:	48 89 c7             	mov    %rax,%rdi
  802bf3:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
  802bff:	89 c2                	mov    %eax,%edx
  802c01:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c05:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802c07:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c0b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802c0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c13:	48 89 c7             	mov    %rax,%rdi
  802c16:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  802c1d:	00 00 00 
  802c20:	ff d0                	callq  *%rax
  802c22:	89 03                	mov    %eax,(%rbx)
	return 0;
  802c24:	b8 00 00 00 00       	mov    $0x0,%eax
  802c29:	eb 33                	jmp    802c5e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802c2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c2f:	48 89 c6             	mov    %rax,%rsi
  802c32:	bf 00 00 00 00       	mov    $0x0,%edi
  802c37:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  802c3e:	00 00 00 
  802c41:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802c43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c47:	48 89 c6             	mov    %rax,%rsi
  802c4a:	bf 00 00 00 00       	mov    $0x0,%edi
  802c4f:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  802c56:	00 00 00 
  802c59:	ff d0                	callq  *%rax
err:
	return r;
  802c5b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802c5e:	48 83 c4 38          	add    $0x38,%rsp
  802c62:	5b                   	pop    %rbx
  802c63:	5d                   	pop    %rbp
  802c64:	c3                   	retq   

0000000000802c65 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802c65:	55                   	push   %rbp
  802c66:	48 89 e5             	mov    %rsp,%rbp
  802c69:	53                   	push   %rbx
  802c6a:	48 83 ec 28          	sub    $0x28,%rsp
  802c6e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c72:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c76:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c7d:	00 00 00 
  802c80:	48 8b 00             	mov    (%rax),%rax
  802c83:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c89:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802c8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c90:	48 89 c7             	mov    %rax,%rdi
  802c93:	48 b8 3c 39 80 00 00 	movabs $0x80393c,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	callq  *%rax
  802c9f:	89 c3                	mov    %eax,%ebx
  802ca1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ca5:	48 89 c7             	mov    %rax,%rdi
  802ca8:	48 b8 3c 39 80 00 00 	movabs $0x80393c,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	callq  *%rax
  802cb4:	39 c3                	cmp    %eax,%ebx
  802cb6:	0f 94 c0             	sete   %al
  802cb9:	0f b6 c0             	movzbl %al,%eax
  802cbc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802cbf:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802cc6:	00 00 00 
  802cc9:	48 8b 00             	mov    (%rax),%rax
  802ccc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802cd2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802cd5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cd8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802cdb:	75 05                	jne    802ce2 <_pipeisclosed+0x7d>
			return ret;
  802cdd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ce0:	eb 4f                	jmp    802d31 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802ce2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ce5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802ce8:	74 42                	je     802d2c <_pipeisclosed+0xc7>
  802cea:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802cee:	75 3c                	jne    802d2c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802cf0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802cf7:	00 00 00 
  802cfa:	48 8b 00             	mov    (%rax),%rax
  802cfd:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802d03:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802d06:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d09:	89 c6                	mov    %eax,%esi
  802d0b:	48 bf fd 3f 80 00 00 	movabs $0x803ffd,%rdi
  802d12:	00 00 00 
  802d15:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1a:	49 b8 6a 02 80 00 00 	movabs $0x80026a,%r8
  802d21:	00 00 00 
  802d24:	41 ff d0             	callq  *%r8
	}
  802d27:	e9 4a ff ff ff       	jmpq   802c76 <_pipeisclosed+0x11>
  802d2c:	e9 45 ff ff ff       	jmpq   802c76 <_pipeisclosed+0x11>
}
  802d31:	48 83 c4 28          	add    $0x28,%rsp
  802d35:	5b                   	pop    %rbx
  802d36:	5d                   	pop    %rbp
  802d37:	c3                   	retq   

0000000000802d38 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802d38:	55                   	push   %rbp
  802d39:	48 89 e5             	mov    %rsp,%rbp
  802d3c:	48 83 ec 30          	sub    $0x30,%rsp
  802d40:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d43:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d47:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d4a:	48 89 d6             	mov    %rdx,%rsi
  802d4d:	89 c7                	mov    %eax,%edi
  802d4f:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
  802d5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d62:	79 05                	jns    802d69 <pipeisclosed+0x31>
		return r;
  802d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d67:	eb 31                	jmp    802d9a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802d69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6d:	48 89 c7             	mov    %rax,%rdi
  802d70:	48 b8 c1 1a 80 00 00 	movabs $0x801ac1,%rax
  802d77:	00 00 00 
  802d7a:	ff d0                	callq  *%rax
  802d7c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802d80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d88:	48 89 d6             	mov    %rdx,%rsi
  802d8b:	48 89 c7             	mov    %rax,%rdi
  802d8e:	48 b8 65 2c 80 00 00 	movabs $0x802c65,%rax
  802d95:	00 00 00 
  802d98:	ff d0                	callq  *%rax
}
  802d9a:	c9                   	leaveq 
  802d9b:	c3                   	retq   

0000000000802d9c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d9c:	55                   	push   %rbp
  802d9d:	48 89 e5             	mov    %rsp,%rbp
  802da0:	48 83 ec 40          	sub    $0x40,%rsp
  802da4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802da8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802dac:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802db0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802db4:	48 89 c7             	mov    %rax,%rdi
  802db7:	48 b8 c1 1a 80 00 00 	movabs $0x801ac1,%rax
  802dbe:	00 00 00 
  802dc1:	ff d0                	callq  *%rax
  802dc3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802dc7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dcb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802dcf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802dd6:	00 
  802dd7:	e9 92 00 00 00       	jmpq   802e6e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802ddc:	eb 41                	jmp    802e1f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802dde:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802de3:	74 09                	je     802dee <devpipe_read+0x52>
				return i;
  802de5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de9:	e9 92 00 00 00       	jmpq   802e80 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802dee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802df2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802df6:	48 89 d6             	mov    %rdx,%rsi
  802df9:	48 89 c7             	mov    %rax,%rdi
  802dfc:	48 b8 65 2c 80 00 00 	movabs $0x802c65,%rax
  802e03:	00 00 00 
  802e06:	ff d0                	callq  *%rax
  802e08:	85 c0                	test   %eax,%eax
  802e0a:	74 07                	je     802e13 <devpipe_read+0x77>
				return 0;
  802e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e11:	eb 6d                	jmp    802e80 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802e13:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  802e1a:	00 00 00 
  802e1d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e23:	8b 10                	mov    (%rax),%edx
  802e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e29:	8b 40 04             	mov    0x4(%rax),%eax
  802e2c:	39 c2                	cmp    %eax,%edx
  802e2e:	74 ae                	je     802dde <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e38:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802e3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e40:	8b 00                	mov    (%rax),%eax
  802e42:	99                   	cltd   
  802e43:	c1 ea 1b             	shr    $0x1b,%edx
  802e46:	01 d0                	add    %edx,%eax
  802e48:	83 e0 1f             	and    $0x1f,%eax
  802e4b:	29 d0                	sub    %edx,%eax
  802e4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e51:	48 98                	cltq   
  802e53:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802e58:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5e:	8b 00                	mov    (%rax),%eax
  802e60:	8d 50 01             	lea    0x1(%rax),%edx
  802e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e67:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e69:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e72:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e76:	0f 82 60 ff ff ff    	jb     802ddc <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802e7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e80:	c9                   	leaveq 
  802e81:	c3                   	retq   

0000000000802e82 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e82:	55                   	push   %rbp
  802e83:	48 89 e5             	mov    %rsp,%rbp
  802e86:	48 83 ec 40          	sub    $0x40,%rsp
  802e8a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e8e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e92:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802e96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e9a:	48 89 c7             	mov    %rax,%rdi
  802e9d:	48 b8 c1 1a 80 00 00 	movabs $0x801ac1,%rax
  802ea4:	00 00 00 
  802ea7:	ff d0                	callq  *%rax
  802ea9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802ead:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802eb5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ebc:	00 
  802ebd:	e9 8e 00 00 00       	jmpq   802f50 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ec2:	eb 31                	jmp    802ef5 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802ec4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ec8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ecc:	48 89 d6             	mov    %rdx,%rsi
  802ecf:	48 89 c7             	mov    %rax,%rdi
  802ed2:	48 b8 65 2c 80 00 00 	movabs $0x802c65,%rax
  802ed9:	00 00 00 
  802edc:	ff d0                	callq  *%rax
  802ede:	85 c0                	test   %eax,%eax
  802ee0:	74 07                	je     802ee9 <devpipe_write+0x67>
				return 0;
  802ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee7:	eb 79                	jmp    802f62 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802ee9:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  802ef0:	00 00 00 
  802ef3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ef5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef9:	8b 40 04             	mov    0x4(%rax),%eax
  802efc:	48 63 d0             	movslq %eax,%rdx
  802eff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f03:	8b 00                	mov    (%rax),%eax
  802f05:	48 98                	cltq   
  802f07:	48 83 c0 20          	add    $0x20,%rax
  802f0b:	48 39 c2             	cmp    %rax,%rdx
  802f0e:	73 b4                	jae    802ec4 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f14:	8b 40 04             	mov    0x4(%rax),%eax
  802f17:	99                   	cltd   
  802f18:	c1 ea 1b             	shr    $0x1b,%edx
  802f1b:	01 d0                	add    %edx,%eax
  802f1d:	83 e0 1f             	and    $0x1f,%eax
  802f20:	29 d0                	sub    %edx,%eax
  802f22:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f26:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f2a:	48 01 ca             	add    %rcx,%rdx
  802f2d:	0f b6 0a             	movzbl (%rdx),%ecx
  802f30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f34:	48 98                	cltq   
  802f36:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3e:	8b 40 04             	mov    0x4(%rax),%eax
  802f41:	8d 50 01             	lea    0x1(%rax),%edx
  802f44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f48:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f4b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f54:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f58:	0f 82 64 ff ff ff    	jb     802ec2 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802f5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f62:	c9                   	leaveq 
  802f63:	c3                   	retq   

0000000000802f64 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f64:	55                   	push   %rbp
  802f65:	48 89 e5             	mov    %rsp,%rbp
  802f68:	48 83 ec 20          	sub    $0x20,%rsp
  802f6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f78:	48 89 c7             	mov    %rax,%rdi
  802f7b:	48 b8 c1 1a 80 00 00 	movabs $0x801ac1,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
  802f87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802f8b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f8f:	48 be 10 40 80 00 00 	movabs $0x804010,%rsi
  802f96:	00 00 00 
  802f99:	48 89 c7             	mov    %rax,%rdi
  802f9c:	48 b8 1f 0e 80 00 00 	movabs $0x800e1f,%rax
  802fa3:	00 00 00 
  802fa6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802fa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fac:	8b 50 04             	mov    0x4(%rax),%edx
  802faf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fb3:	8b 00                	mov    (%rax),%eax
  802fb5:	29 c2                	sub    %eax,%edx
  802fb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fbb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802fc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802fcc:	00 00 00 
	stat->st_dev = &devpipe;
  802fcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd3:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  802fda:	00 00 00 
  802fdd:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802fe4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fe9:	c9                   	leaveq 
  802fea:	c3                   	retq   

0000000000802feb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802feb:	55                   	push   %rbp
  802fec:	48 89 e5             	mov    %rsp,%rbp
  802fef:	48 83 ec 10          	sub    $0x10,%rsp
  802ff3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802ff7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffb:	48 89 c6             	mov    %rax,%rsi
  802ffe:	bf 00 00 00 00       	mov    $0x0,%edi
  803003:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  80300a:	00 00 00 
  80300d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80300f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803013:	48 89 c7             	mov    %rax,%rdi
  803016:	48 b8 c1 1a 80 00 00 	movabs $0x801ac1,%rax
  80301d:	00 00 00 
  803020:	ff d0                	callq  *%rax
  803022:	48 89 c6             	mov    %rax,%rsi
  803025:	bf 00 00 00 00       	mov    $0x0,%edi
  80302a:	48 b8 f9 17 80 00 00 	movabs $0x8017f9,%rax
  803031:	00 00 00 
  803034:	ff d0                	callq  *%rax
}
  803036:	c9                   	leaveq 
  803037:	c3                   	retq   

0000000000803038 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803038:	55                   	push   %rbp
  803039:	48 89 e5             	mov    %rsp,%rbp
  80303c:	48 83 ec 20          	sub    $0x20,%rsp
  803040:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803043:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803046:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803049:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80304d:	be 01 00 00 00       	mov    $0x1,%esi
  803052:	48 89 c7             	mov    %rax,%rdi
  803055:	48 b8 06 16 80 00 00 	movabs $0x801606,%rax
  80305c:	00 00 00 
  80305f:	ff d0                	callq  *%rax
}
  803061:	c9                   	leaveq 
  803062:	c3                   	retq   

0000000000803063 <getchar>:

int
getchar(void)
{
  803063:	55                   	push   %rbp
  803064:	48 89 e5             	mov    %rsp,%rbp
  803067:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80306b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80306f:	ba 01 00 00 00       	mov    $0x1,%edx
  803074:	48 89 c6             	mov    %rax,%rsi
  803077:	bf 00 00 00 00       	mov    $0x0,%edi
  80307c:	48 b8 b6 1f 80 00 00 	movabs $0x801fb6,%rax
  803083:	00 00 00 
  803086:	ff d0                	callq  *%rax
  803088:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80308b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308f:	79 05                	jns    803096 <getchar+0x33>
		return r;
  803091:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803094:	eb 14                	jmp    8030aa <getchar+0x47>
	if (r < 1)
  803096:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80309a:	7f 07                	jg     8030a3 <getchar+0x40>
		return -E_EOF;
  80309c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8030a1:	eb 07                	jmp    8030aa <getchar+0x47>
	return c;
  8030a3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8030a7:	0f b6 c0             	movzbl %al,%eax
}
  8030aa:	c9                   	leaveq 
  8030ab:	c3                   	retq   

00000000008030ac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8030ac:	55                   	push   %rbp
  8030ad:	48 89 e5             	mov    %rsp,%rbp
  8030b0:	48 83 ec 20          	sub    $0x20,%rsp
  8030b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030b7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030be:	48 89 d6             	mov    %rdx,%rsi
  8030c1:	89 c7                	mov    %eax,%edi
  8030c3:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  8030ca:	00 00 00 
  8030cd:	ff d0                	callq  *%rax
  8030cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d6:	79 05                	jns    8030dd <iscons+0x31>
		return r;
  8030d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030db:	eb 1a                	jmp    8030f7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8030dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e1:	8b 10                	mov    (%rax),%edx
  8030e3:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  8030ea:	00 00 00 
  8030ed:	8b 00                	mov    (%rax),%eax
  8030ef:	39 c2                	cmp    %eax,%edx
  8030f1:	0f 94 c0             	sete   %al
  8030f4:	0f b6 c0             	movzbl %al,%eax
}
  8030f7:	c9                   	leaveq 
  8030f8:	c3                   	retq   

00000000008030f9 <opencons>:

int
opencons(void)
{
  8030f9:	55                   	push   %rbp
  8030fa:	48 89 e5             	mov    %rsp,%rbp
  8030fd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803101:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803105:	48 89 c7             	mov    %rax,%rdi
  803108:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  80310f:	00 00 00 
  803112:	ff d0                	callq  *%rax
  803114:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803117:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311b:	79 05                	jns    803122 <opencons+0x29>
		return r;
  80311d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803120:	eb 5b                	jmp    80317d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803126:	ba 07 04 00 00       	mov    $0x407,%edx
  80312b:	48 89 c6             	mov    %rax,%rsi
  80312e:	bf 00 00 00 00       	mov    $0x0,%edi
  803133:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
  80313f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803142:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803146:	79 05                	jns    80314d <opencons+0x54>
		return r;
  803148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314b:	eb 30                	jmp    80317d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80314d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803151:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  803158:	00 00 00 
  80315b:	8b 12                	mov    (%rdx),%edx
  80315d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80315f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803163:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80316a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80316e:	48 89 c7             	mov    %rax,%rdi
  803171:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  803178:	00 00 00 
  80317b:	ff d0                	callq  *%rax
}
  80317d:	c9                   	leaveq 
  80317e:	c3                   	retq   

000000000080317f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80317f:	55                   	push   %rbp
  803180:	48 89 e5             	mov    %rsp,%rbp
  803183:	48 83 ec 30          	sub    $0x30,%rsp
  803187:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80318b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80318f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803193:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803198:	75 07                	jne    8031a1 <devcons_read+0x22>
		return 0;
  80319a:	b8 00 00 00 00       	mov    $0x0,%eax
  80319f:	eb 4b                	jmp    8031ec <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8031a1:	eb 0c                	jmp    8031af <devcons_read+0x30>
		sys_yield();
  8031a3:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  8031aa:	00 00 00 
  8031ad:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8031af:	48 b8 50 16 80 00 00 	movabs $0x801650,%rax
  8031b6:	00 00 00 
  8031b9:	ff d0                	callq  *%rax
  8031bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c2:	74 df                	je     8031a3 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8031c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c8:	79 05                	jns    8031cf <devcons_read+0x50>
		return c;
  8031ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cd:	eb 1d                	jmp    8031ec <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8031cf:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8031d3:	75 07                	jne    8031dc <devcons_read+0x5d>
		return 0;
  8031d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031da:	eb 10                	jmp    8031ec <devcons_read+0x6d>
	*(char*)vbuf = c;
  8031dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031df:	89 c2                	mov    %eax,%edx
  8031e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e5:	88 10                	mov    %dl,(%rax)
	return 1;
  8031e7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8031ec:	c9                   	leaveq 
  8031ed:	c3                   	retq   

00000000008031ee <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8031ee:	55                   	push   %rbp
  8031ef:	48 89 e5             	mov    %rsp,%rbp
  8031f2:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8031f9:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803200:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803207:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80320e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803215:	eb 76                	jmp    80328d <devcons_write+0x9f>
		m = n - tot;
  803217:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80321e:	89 c2                	mov    %eax,%edx
  803220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803223:	29 c2                	sub    %eax,%edx
  803225:	89 d0                	mov    %edx,%eax
  803227:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80322a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80322d:	83 f8 7f             	cmp    $0x7f,%eax
  803230:	76 07                	jbe    803239 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803232:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803239:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80323c:	48 63 d0             	movslq %eax,%rdx
  80323f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803242:	48 63 c8             	movslq %eax,%rcx
  803245:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80324c:	48 01 c1             	add    %rax,%rcx
  80324f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803256:	48 89 ce             	mov    %rcx,%rsi
  803259:	48 89 c7             	mov    %rax,%rdi
  80325c:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  803263:	00 00 00 
  803266:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803268:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80326b:	48 63 d0             	movslq %eax,%rdx
  80326e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803275:	48 89 d6             	mov    %rdx,%rsi
  803278:	48 89 c7             	mov    %rax,%rdi
  80327b:	48 b8 06 16 80 00 00 	movabs $0x801606,%rax
  803282:	00 00 00 
  803285:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803287:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80328a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80328d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803290:	48 98                	cltq   
  803292:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803299:	0f 82 78 ff ff ff    	jb     803217 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80329f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032a2:	c9                   	leaveq 
  8032a3:	c3                   	retq   

00000000008032a4 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8032a4:	55                   	push   %rbp
  8032a5:	48 89 e5             	mov    %rsp,%rbp
  8032a8:	48 83 ec 08          	sub    $0x8,%rsp
  8032ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8032b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032b5:	c9                   	leaveq 
  8032b6:	c3                   	retq   

00000000008032b7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8032b7:	55                   	push   %rbp
  8032b8:	48 89 e5             	mov    %rsp,%rbp
  8032bb:	48 83 ec 10          	sub    $0x10,%rsp
  8032bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8032c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032cb:	48 be 1c 40 80 00 00 	movabs $0x80401c,%rsi
  8032d2:	00 00 00 
  8032d5:	48 89 c7             	mov    %rax,%rdi
  8032d8:	48 b8 1f 0e 80 00 00 	movabs $0x800e1f,%rax
  8032df:	00 00 00 
  8032e2:	ff d0                	callq  *%rax
	return 0;
  8032e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032e9:	c9                   	leaveq 
  8032ea:	c3                   	retq   

00000000008032eb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8032eb:	55                   	push   %rbp
  8032ec:	48 89 e5             	mov    %rsp,%rbp
  8032ef:	53                   	push   %rbx
  8032f0:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8032f7:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8032fe:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803304:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80330b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803312:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803319:	84 c0                	test   %al,%al
  80331b:	74 23                	je     803340 <_panic+0x55>
  80331d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803324:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803328:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80332c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803330:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803334:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803338:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80333c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803340:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803347:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80334e:	00 00 00 
  803351:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803358:	00 00 00 
  80335b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80335f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803366:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80336d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803374:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80337b:	00 00 00 
  80337e:	48 8b 18             	mov    (%rax),%rbx
  803381:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  803388:	00 00 00 
  80338b:	ff d0                	callq  *%rax
  80338d:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803393:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80339a:	41 89 c8             	mov    %ecx,%r8d
  80339d:	48 89 d1             	mov    %rdx,%rcx
  8033a0:	48 89 da             	mov    %rbx,%rdx
  8033a3:	89 c6                	mov    %eax,%esi
  8033a5:	48 bf 28 40 80 00 00 	movabs $0x804028,%rdi
  8033ac:	00 00 00 
  8033af:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b4:	49 b9 6a 02 80 00 00 	movabs $0x80026a,%r9
  8033bb:	00 00 00 
  8033be:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8033c1:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8033c8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8033cf:	48 89 d6             	mov    %rdx,%rsi
  8033d2:	48 89 c7             	mov    %rax,%rdi
  8033d5:	48 b8 be 01 80 00 00 	movabs $0x8001be,%rax
  8033dc:	00 00 00 
  8033df:	ff d0                	callq  *%rax
	cprintf("\n");
  8033e1:	48 bf 4b 40 80 00 00 	movabs $0x80404b,%rdi
  8033e8:	00 00 00 
  8033eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f0:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  8033f7:	00 00 00 
  8033fa:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8033fc:	cc                   	int3   
  8033fd:	eb fd                	jmp    8033fc <_panic+0x111>

00000000008033ff <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8033ff:	55                   	push   %rbp
  803400:	48 89 e5             	mov    %rsp,%rbp
  803403:	48 83 ec 30          	sub    $0x30,%rsp
  803407:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80340b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80340f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803413:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80341a:	00 00 00 
  80341d:	48 8b 00             	mov    (%rax),%rax
  803420:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803426:	85 c0                	test   %eax,%eax
  803428:	75 34                	jne    80345e <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80342a:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  803431:	00 00 00 
  803434:	ff d0                	callq  *%rax
  803436:	25 ff 03 00 00       	and    $0x3ff,%eax
  80343b:	48 98                	cltq   
  80343d:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803444:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80344b:	00 00 00 
  80344e:	48 01 c2             	add    %rax,%rdx
  803451:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803458:	00 00 00 
  80345b:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80345e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803463:	75 0e                	jne    803473 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803465:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80346c:	00 00 00 
  80346f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803473:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803477:	48 89 c7             	mov    %rax,%rdi
  80347a:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  803481:	00 00 00 
  803484:	ff d0                	callq  *%rax
  803486:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803489:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348d:	79 19                	jns    8034a8 <ipc_recv+0xa9>
		*from_env_store = 0;
  80348f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803493:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803499:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80349d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8034a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a6:	eb 53                	jmp    8034fb <ipc_recv+0xfc>
	}
	if(from_env_store)
  8034a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034ad:	74 19                	je     8034c8 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8034af:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034b6:	00 00 00 
  8034b9:	48 8b 00             	mov    (%rax),%rax
  8034bc:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8034c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c6:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8034c8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8034cd:	74 19                	je     8034e8 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8034cf:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034d6:	00 00 00 
  8034d9:	48 8b 00             	mov    (%rax),%rax
  8034dc:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8034e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e6:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8034e8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034ef:	00 00 00 
  8034f2:	48 8b 00             	mov    (%rax),%rax
  8034f5:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8034fb:	c9                   	leaveq 
  8034fc:	c3                   	retq   

00000000008034fd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8034fd:	55                   	push   %rbp
  8034fe:	48 89 e5             	mov    %rsp,%rbp
  803501:	48 83 ec 30          	sub    $0x30,%rsp
  803505:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803508:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80350b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80350f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803512:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803517:	75 0e                	jne    803527 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803519:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803520:	00 00 00 
  803523:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803527:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80352a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80352d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803531:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803534:	89 c7                	mov    %eax,%edi
  803536:	48 b8 22 19 80 00 00 	movabs $0x801922,%rax
  80353d:	00 00 00 
  803540:	ff d0                	callq  *%rax
  803542:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803545:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803549:	75 0c                	jne    803557 <ipc_send+0x5a>
			sys_yield();
  80354b:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  803552:	00 00 00 
  803555:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803557:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80355b:	74 ca                	je     803527 <ipc_send+0x2a>
	if(result != 0)
  80355d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803561:	74 20                	je     803583 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803563:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803566:	89 c6                	mov    %eax,%esi
  803568:	48 bf 50 40 80 00 00 	movabs $0x804050,%rdi
  80356f:	00 00 00 
  803572:	b8 00 00 00 00       	mov    $0x0,%eax
  803577:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  80357e:	00 00 00 
  803581:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803583:	c9                   	leaveq 
  803584:	c3                   	retq   

0000000000803585 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803585:	55                   	push   %rbp
  803586:	48 89 e5             	mov    %rsp,%rbp
  803589:	53                   	push   %rbx
  80358a:	48 83 ec 58          	sub    $0x58,%rsp
  80358e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  803592:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803596:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  80359a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  8035a1:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8035a8:	00 
  8035a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ad:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8035b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8035b9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035bd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8035c1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8035c5:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8035c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035cd:	48 c1 e8 27          	shr    $0x27,%rax
  8035d1:	48 89 c2             	mov    %rax,%rdx
  8035d4:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8035db:	01 00 00 
  8035de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035e2:	83 e0 01             	and    $0x1,%eax
  8035e5:	48 85 c0             	test   %rax,%rax
  8035e8:	0f 85 91 00 00 00    	jne    80367f <ipc_host_recv+0xfa>
  8035ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f2:	48 c1 e8 1e          	shr    $0x1e,%rax
  8035f6:	48 89 c2             	mov    %rax,%rdx
  8035f9:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803600:	01 00 00 
  803603:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803607:	83 e0 01             	and    $0x1,%eax
  80360a:	48 85 c0             	test   %rax,%rax
  80360d:	74 70                	je     80367f <ipc_host_recv+0xfa>
  80360f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803613:	48 c1 e8 15          	shr    $0x15,%rax
  803617:	48 89 c2             	mov    %rax,%rdx
  80361a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803621:	01 00 00 
  803624:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803628:	83 e0 01             	and    $0x1,%eax
  80362b:	48 85 c0             	test   %rax,%rax
  80362e:	74 4f                	je     80367f <ipc_host_recv+0xfa>
  803630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803634:	48 c1 e8 0c          	shr    $0xc,%rax
  803638:	48 89 c2             	mov    %rax,%rdx
  80363b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803642:	01 00 00 
  803645:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803649:	83 e0 01             	and    $0x1,%eax
  80364c:	48 85 c0             	test   %rax,%rax
  80364f:	74 2e                	je     80367f <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803655:	ba 07 04 00 00       	mov    $0x407,%edx
  80365a:	48 89 c6             	mov    %rax,%rsi
  80365d:	bf 00 00 00 00       	mov    $0x0,%edi
  803662:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  803669:	00 00 00 
  80366c:	ff d0                	callq  *%rax
  80366e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803671:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803675:	79 08                	jns    80367f <ipc_host_recv+0xfa>
	    	return result;
  803677:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80367a:	e9 84 00 00 00       	jmpq   803703 <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  80367f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803683:	48 c1 e8 0c          	shr    $0xc,%rax
  803687:	48 89 c2             	mov    %rax,%rdx
  80368a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803691:	01 00 00 
  803694:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803698:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80369e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  8036a2:	b8 03 00 00 00       	mov    $0x3,%eax
  8036a7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8036ab:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8036af:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8036b3:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8036b7:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8036bb:	4c 89 c3             	mov    %r8,%rbx
  8036be:	0f 01 c1             	vmcall 
  8036c1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  8036c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8036c8:	7e 36                	jle    803700 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  8036ca:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8036cd:	41 89 c0             	mov    %eax,%r8d
  8036d0:	b9 03 00 00 00       	mov    $0x3,%ecx
  8036d5:	48 ba 68 40 80 00 00 	movabs $0x804068,%rdx
  8036dc:	00 00 00 
  8036df:	be 67 00 00 00       	mov    $0x67,%esi
  8036e4:	48 bf 95 40 80 00 00 	movabs $0x804095,%rdi
  8036eb:	00 00 00 
  8036ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f3:	49 b9 eb 32 80 00 00 	movabs $0x8032eb,%r9
  8036fa:	00 00 00 
  8036fd:	41 ff d1             	callq  *%r9
	return result;
  803700:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  803703:	48 83 c4 58          	add    $0x58,%rsp
  803707:	5b                   	pop    %rbx
  803708:	5d                   	pop    %rbp
  803709:	c3                   	retq   

000000000080370a <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80370a:	55                   	push   %rbp
  80370b:	48 89 e5             	mov    %rsp,%rbp
  80370e:	53                   	push   %rbx
  80370f:	48 83 ec 68          	sub    $0x68,%rsp
  803713:	89 7d ac             	mov    %edi,-0x54(%rbp)
  803716:	89 75 a8             	mov    %esi,-0x58(%rbp)
  803719:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  80371d:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  803720:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803724:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  803728:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  80372f:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803736:	00 
  803737:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80373b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80373f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803743:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80374b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80374f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803753:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  803757:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80375b:	48 c1 e8 27          	shr    $0x27,%rax
  80375f:	48 89 c2             	mov    %rax,%rdx
  803762:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803769:	01 00 00 
  80376c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803770:	83 e0 01             	and    $0x1,%eax
  803773:	48 85 c0             	test   %rax,%rax
  803776:	0f 85 88 00 00 00    	jne    803804 <ipc_host_send+0xfa>
  80377c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803780:	48 c1 e8 1e          	shr    $0x1e,%rax
  803784:	48 89 c2             	mov    %rax,%rdx
  803787:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80378e:	01 00 00 
  803791:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803795:	83 e0 01             	and    $0x1,%eax
  803798:	48 85 c0             	test   %rax,%rax
  80379b:	74 67                	je     803804 <ipc_host_send+0xfa>
  80379d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a1:	48 c1 e8 15          	shr    $0x15,%rax
  8037a5:	48 89 c2             	mov    %rax,%rdx
  8037a8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8037af:	01 00 00 
  8037b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037b6:	83 e0 01             	and    $0x1,%eax
  8037b9:	48 85 c0             	test   %rax,%rax
  8037bc:	74 46                	je     803804 <ipc_host_send+0xfa>
  8037be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c2:	48 c1 e8 0c          	shr    $0xc,%rax
  8037c6:	48 89 c2             	mov    %rax,%rdx
  8037c9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037d0:	01 00 00 
  8037d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037d7:	83 e0 01             	and    $0x1,%eax
  8037da:	48 85 c0             	test   %rax,%rax
  8037dd:	74 25                	je     803804 <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8037df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e3:	48 c1 e8 0c          	shr    $0xc,%rax
  8037e7:	48 89 c2             	mov    %rax,%rdx
  8037ea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037f1:	01 00 00 
  8037f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037f8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8037fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803802:	eb 0e                	jmp    803812 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  803804:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80380b:	00 00 00 
  80380e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  803812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803816:	48 89 c6             	mov    %rax,%rsi
  803819:	48 bf 9f 40 80 00 00 	movabs $0x80409f,%rdi
  803820:	00 00 00 
  803823:	b8 00 00 00 00       	mov    $0x0,%eax
  803828:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  80382f:	00 00 00 
  803832:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  803834:	8b 45 ac             	mov    -0x54(%rbp),%eax
  803837:	48 98                	cltq   
  803839:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  80383d:	8b 45 a8             	mov    -0x58(%rbp),%eax
  803840:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  803844:	8b 45 9c             	mov    -0x64(%rbp),%eax
  803847:	48 98                	cltq   
  803849:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  80384d:	b8 02 00 00 00       	mov    $0x2,%eax
  803852:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803856:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80385a:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  80385e:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803862:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803866:	4c 89 c3             	mov    %r8,%rbx
  803869:	0f 01 c1             	vmcall 
  80386c:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  80386f:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803873:	75 0c                	jne    803881 <ipc_host_send+0x177>
			sys_yield();
  803875:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  80387c:	00 00 00 
  80387f:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  803881:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803885:	74 c6                	je     80384d <ipc_host_send+0x143>
	
	if(result !=0)
  803887:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80388b:	74 36                	je     8038c3 <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  80388d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803890:	41 89 c0             	mov    %eax,%r8d
  803893:	b9 02 00 00 00       	mov    $0x2,%ecx
  803898:	48 ba 68 40 80 00 00 	movabs $0x804068,%rdx
  80389f:	00 00 00 
  8038a2:	be 94 00 00 00       	mov    $0x94,%esi
  8038a7:	48 bf 95 40 80 00 00 	movabs $0x804095,%rdi
  8038ae:	00 00 00 
  8038b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b6:	49 b9 eb 32 80 00 00 	movabs $0x8032eb,%r9
  8038bd:	00 00 00 
  8038c0:	41 ff d1             	callq  *%r9
}
  8038c3:	48 83 c4 68          	add    $0x68,%rsp
  8038c7:	5b                   	pop    %rbx
  8038c8:	5d                   	pop    %rbp
  8038c9:	c3                   	retq   

00000000008038ca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8038ca:	55                   	push   %rbp
  8038cb:	48 89 e5             	mov    %rsp,%rbp
  8038ce:	48 83 ec 14          	sub    $0x14,%rsp
  8038d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8038d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038dc:	eb 4e                	jmp    80392c <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8038de:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8038e5:	00 00 00 
  8038e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038eb:	48 98                	cltq   
  8038ed:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8038f4:	48 01 d0             	add    %rdx,%rax
  8038f7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8038fd:	8b 00                	mov    (%rax),%eax
  8038ff:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803902:	75 24                	jne    803928 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803904:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80390b:	00 00 00 
  80390e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803911:	48 98                	cltq   
  803913:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80391a:	48 01 d0             	add    %rdx,%rax
  80391d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803923:	8b 40 08             	mov    0x8(%rax),%eax
  803926:	eb 12                	jmp    80393a <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803928:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80392c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803933:	7e a9                	jle    8038de <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803935:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80393a:	c9                   	leaveq 
  80393b:	c3                   	retq   

000000000080393c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80393c:	55                   	push   %rbp
  80393d:	48 89 e5             	mov    %rsp,%rbp
  803940:	48 83 ec 18          	sub    $0x18,%rsp
  803944:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394c:	48 c1 e8 15          	shr    $0x15,%rax
  803950:	48 89 c2             	mov    %rax,%rdx
  803953:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80395a:	01 00 00 
  80395d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803961:	83 e0 01             	and    $0x1,%eax
  803964:	48 85 c0             	test   %rax,%rax
  803967:	75 07                	jne    803970 <pageref+0x34>
		return 0;
  803969:	b8 00 00 00 00       	mov    $0x0,%eax
  80396e:	eb 53                	jmp    8039c3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803974:	48 c1 e8 0c          	shr    $0xc,%rax
  803978:	48 89 c2             	mov    %rax,%rdx
  80397b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803982:	01 00 00 
  803985:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803989:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80398d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803991:	83 e0 01             	and    $0x1,%eax
  803994:	48 85 c0             	test   %rax,%rax
  803997:	75 07                	jne    8039a0 <pageref+0x64>
		return 0;
  803999:	b8 00 00 00 00       	mov    $0x0,%eax
  80399e:	eb 23                	jmp    8039c3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8039a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8039a8:	48 89 c2             	mov    %rax,%rdx
  8039ab:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8039b2:	00 00 00 
  8039b5:	48 c1 e2 04          	shl    $0x4,%rdx
  8039b9:	48 01 d0             	add    %rdx,%rax
  8039bc:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8039c0:	0f b7 c0             	movzwl %ax,%eax
}
  8039c3:	c9                   	leaveq 
  8039c4:	c3                   	retq   
