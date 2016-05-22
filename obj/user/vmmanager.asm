
obj/user/vmmanager:     file format elf64-x86-64


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
  80003c:	e8 e4 00 00 00       	callq  800125 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#ifndef VMM_GUEST
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *buf;
	sys_vmx_list_vms();
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	48 ba 7e 1c 80 00 00 	movabs $0x801c7e,%rdx
  80005e:	00 00 00 
  800061:	ff d2                	callq  *%rdx
	buf = readline("Please select a VM to resume: ");
  800063:	48 bf 80 3c 80 00 00 	movabs $0x803c80,%rdi
  80006a:	00 00 00 
  80006d:	48 b8 39 0e 80 00 00 	movabs $0x800e39,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (!(strlen(buf) == 1
  80007d:	eb 35                	jmp    8000b4 <umain+0x71>
		&& buf[0] >= '1' 
		&& buf[0] <= '9')) {
error:		cprintf("Please enter a correct vm number\n");
  80007f:	48 bf a0 3c 80 00 00 	movabs $0x803ca0,%rdi
  800086:	00 00 00 
  800089:	b8 00 00 00 00       	mov    $0x0,%eax
  80008e:	48 ba f0 02 80 00 00 	movabs $0x8002f0,%rdx
  800095:	00 00 00 
  800098:	ff d2                	callq  *%rdx
		buf = readline("Please select a VM to resume: ");
  80009a:	48 bf 80 3c 80 00 00 	movabs $0x803c80,%rdi
  8000a1:	00 00 00 
  8000a4:	48 b8 39 0e 80 00 00 	movabs $0x800e39,%rax
  8000ab:	00 00 00 
  8000ae:	ff d0                	callq  *%rax
  8000b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
umain(int argc, char **argv)
{
	char *buf;
	sys_vmx_list_vms();
	buf = readline("Please select a VM to resume: ");
	while (!(strlen(buf) == 1
  8000b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000b8:	48 89 c7             	mov    %rax,%rdi
  8000bb:	48 b8 93 0f 80 00 00 	movabs $0x800f93,%rax
  8000c2:	00 00 00 
  8000c5:	ff d0                	callq  *%rax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	75 b3                	jne    80007f <umain+0x3c>
		&& buf[0] >= '1' 
  8000cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000d0:	0f b6 00             	movzbl (%rax),%eax
  8000d3:	3c 30                	cmp    $0x30,%al
  8000d5:	7e a8                	jle    80007f <umain+0x3c>
		&& buf[0] <= '9')) {
  8000d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000db:	0f b6 00             	movzbl (%rax),%eax
umain(int argc, char **argv)
{
	char *buf;
	sys_vmx_list_vms();
	buf = readline("Please select a VM to resume: ");
	while (!(strlen(buf) == 1
  8000de:	3c 39                	cmp    $0x39,%al
  8000e0:	7f 9d                	jg     80007f <umain+0x3c>
		&& buf[0] <= '9')) {
error:		cprintf("Please enter a correct vm number\n");
		buf = readline("Please select a VM to resume: ");
	}
	
	if (sys_vmx_sel_resume(buf[0] - '1' + 1)) {
  8000e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000e6:	0f b6 00             	movzbl (%rax),%eax
  8000e9:	0f be c0             	movsbl %al,%eax
  8000ec:	83 e8 30             	sub    $0x30,%eax
  8000ef:	89 c7                	mov    %eax,%edi
  8000f1:	48 b8 bc 1c 80 00 00 	movabs $0x801cbc,%rax
  8000f8:	00 00 00 
  8000fb:	ff d0                	callq  *%rax
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	74 1d                	je     80011e <umain+0xdb>
		cprintf("Press Enter to Continue\n");
  800101:	48 bf c2 3c 80 00 00 	movabs $0x803cc2,%rdi
  800108:	00 00 00 
  80010b:	b8 00 00 00 00       	mov    $0x0,%eax
  800110:	48 ba f0 02 80 00 00 	movabs $0x8002f0,%rdx
  800117:	00 00 00 
  80011a:	ff d2                	callq  *%rdx
  80011c:	eb 05                	jmp    800123 <umain+0xe0>
	}
	else {		
		goto error;
  80011e:	e9 5c ff ff ff       	jmpq   80007f <umain+0x3c>
	}
	
}
  800123:	c9                   	leaveq 
  800124:	c3                   	retq   

0000000000800125 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800125:	55                   	push   %rbp
  800126:	48 89 e5             	mov    %rsp,%rbp
  800129:	48 83 ec 10          	sub    $0x10,%rsp
  80012d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800130:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800134:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80013b:	00 00 00 
  80013e:	ff d0                	callq  *%rax
  800140:	25 ff 03 00 00       	and    $0x3ff,%eax
  800145:	48 98                	cltq   
  800147:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80014e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800155:	00 00 00 
  800158:	48 01 c2             	add    %rax,%rdx
  80015b:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  800162:	00 00 00 
  800165:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800168:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80016c:	7e 14                	jle    800182 <libmain+0x5d>
		binaryname = argv[0];
  80016e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800172:	48 8b 10             	mov    (%rax),%rdx
  800175:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80017c:	00 00 00 
  80017f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800182:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800189:	48 89 d6             	mov    %rdx,%rsi
  80018c:	89 c7                	mov    %eax,%edi
  80018e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800195:	00 00 00 
  800198:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80019a:	48 b8 a8 01 80 00 00 	movabs $0x8001a8,%rax
  8001a1:	00 00 00 
  8001a4:	ff d0                	callq  *%rax
}
  8001a6:	c9                   	leaveq 
  8001a7:	c3                   	retq   

00000000008001a8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a8:	55                   	push   %rbp
  8001a9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001ac:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  8001b3:	00 00 00 
  8001b6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001bd:	48 b8 6e 18 80 00 00 	movabs $0x80186e,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax

}
  8001c9:	5d                   	pop    %rbp
  8001ca:	c3                   	retq   

00000000008001cb <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001cb:	55                   	push   %rbp
  8001cc:	48 89 e5             	mov    %rsp,%rbp
  8001cf:	48 83 ec 10          	sub    $0x10,%rsp
  8001d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001de:	8b 00                	mov    (%rax),%eax
  8001e0:	8d 48 01             	lea    0x1(%rax),%ecx
  8001e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e7:	89 0a                	mov    %ecx,(%rdx)
  8001e9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001ec:	89 d1                	mov    %edx,%ecx
  8001ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f2:	48 98                	cltq   
  8001f4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001fc:	8b 00                	mov    (%rax),%eax
  8001fe:	3d ff 00 00 00       	cmp    $0xff,%eax
  800203:	75 2c                	jne    800231 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800209:	8b 00                	mov    (%rax),%eax
  80020b:	48 98                	cltq   
  80020d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800211:	48 83 c2 08          	add    $0x8,%rdx
  800215:	48 89 c6             	mov    %rax,%rsi
  800218:	48 89 d7             	mov    %rdx,%rdi
  80021b:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  800222:	00 00 00 
  800225:	ff d0                	callq  *%rax
        b->idx = 0;
  800227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800231:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800235:	8b 40 04             	mov    0x4(%rax),%eax
  800238:	8d 50 01             	lea    0x1(%rax),%edx
  80023b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800242:	c9                   	leaveq 
  800243:	c3                   	retq   

0000000000800244 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800244:	55                   	push   %rbp
  800245:	48 89 e5             	mov    %rsp,%rbp
  800248:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80024f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800256:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80025d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800264:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80026b:	48 8b 0a             	mov    (%rdx),%rcx
  80026e:	48 89 08             	mov    %rcx,(%rax)
  800271:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800275:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800279:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80027d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800281:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800288:	00 00 00 
    b.cnt = 0;
  80028b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800292:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800295:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80029c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002a3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002aa:	48 89 c6             	mov    %rax,%rsi
  8002ad:	48 bf cb 01 80 00 00 	movabs $0x8001cb,%rdi
  8002b4:	00 00 00 
  8002b7:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002c3:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002c9:	48 98                	cltq   
  8002cb:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002d2:	48 83 c2 08          	add    $0x8,%rdx
  8002d6:	48 89 c6             	mov    %rax,%rsi
  8002d9:	48 89 d7             	mov    %rdx,%rdi
  8002dc:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  8002e3:	00 00 00 
  8002e6:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002ee:	c9                   	leaveq 
  8002ef:	c3                   	retq   

00000000008002f0 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002f0:	55                   	push   %rbp
  8002f1:	48 89 e5             	mov    %rsp,%rbp
  8002f4:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002fb:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800302:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800309:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800310:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800317:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80031e:	84 c0                	test   %al,%al
  800320:	74 20                	je     800342 <cprintf+0x52>
  800322:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800326:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80032a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80032e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800332:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800336:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80033a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80033e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800342:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800349:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800350:	00 00 00 
  800353:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80035a:	00 00 00 
  80035d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800361:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800368:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80036f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800376:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80037d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800384:	48 8b 0a             	mov    (%rdx),%rcx
  800387:	48 89 08             	mov    %rcx,(%rax)
  80038a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80038e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800392:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800396:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80039a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003a1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003a8:	48 89 d6             	mov    %rdx,%rsi
  8003ab:	48 89 c7             	mov    %rax,%rdi
  8003ae:	48 b8 44 02 80 00 00 	movabs $0x800244,%rax
  8003b5:	00 00 00 
  8003b8:	ff d0                	callq  *%rax
  8003ba:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003c0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003c6:	c9                   	leaveq 
  8003c7:	c3                   	retq   

00000000008003c8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003c8:	55                   	push   %rbp
  8003c9:	48 89 e5             	mov    %rsp,%rbp
  8003cc:	53                   	push   %rbx
  8003cd:	48 83 ec 38          	sub    $0x38,%rsp
  8003d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003dd:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003e0:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003e4:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003e8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003eb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003ef:	77 3b                	ja     80042c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f1:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003f4:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003f8:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800404:	48 f7 f3             	div    %rbx
  800407:	48 89 c2             	mov    %rax,%rdx
  80040a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80040d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800410:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800414:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800418:	41 89 f9             	mov    %edi,%r9d
  80041b:	48 89 c7             	mov    %rax,%rdi
  80041e:	48 b8 c8 03 80 00 00 	movabs $0x8003c8,%rax
  800425:	00 00 00 
  800428:	ff d0                	callq  *%rax
  80042a:	eb 1e                	jmp    80044a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042c:	eb 12                	jmp    800440 <printnum+0x78>
			putch(padc, putdat);
  80042e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800432:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800435:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800439:	48 89 ce             	mov    %rcx,%rsi
  80043c:	89 d7                	mov    %edx,%edi
  80043e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800440:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800444:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800448:	7f e4                	jg     80042e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80044a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80044d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800451:	ba 00 00 00 00       	mov    $0x0,%edx
  800456:	48 f7 f1             	div    %rcx
  800459:	48 89 d0             	mov    %rdx,%rax
  80045c:	48 ba f0 3e 80 00 00 	movabs $0x803ef0,%rdx
  800463:	00 00 00 
  800466:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80046a:	0f be d0             	movsbl %al,%edx
  80046d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800475:	48 89 ce             	mov    %rcx,%rsi
  800478:	89 d7                	mov    %edx,%edi
  80047a:	ff d0                	callq  *%rax
}
  80047c:	48 83 c4 38          	add    $0x38,%rsp
  800480:	5b                   	pop    %rbx
  800481:	5d                   	pop    %rbp
  800482:	c3                   	retq   

0000000000800483 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800483:	55                   	push   %rbp
  800484:	48 89 e5             	mov    %rsp,%rbp
  800487:	48 83 ec 1c          	sub    $0x1c,%rsp
  80048b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80048f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800492:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800496:	7e 52                	jle    8004ea <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049c:	8b 00                	mov    (%rax),%eax
  80049e:	83 f8 30             	cmp    $0x30,%eax
  8004a1:	73 24                	jae    8004c7 <getuint+0x44>
  8004a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004af:	8b 00                	mov    (%rax),%eax
  8004b1:	89 c0                	mov    %eax,%eax
  8004b3:	48 01 d0             	add    %rdx,%rax
  8004b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ba:	8b 12                	mov    (%rdx),%edx
  8004bc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c3:	89 0a                	mov    %ecx,(%rdx)
  8004c5:	eb 17                	jmp    8004de <getuint+0x5b>
  8004c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004cf:	48 89 d0             	mov    %rdx,%rax
  8004d2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004de:	48 8b 00             	mov    (%rax),%rax
  8004e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004e5:	e9 a3 00 00 00       	jmpq   80058d <getuint+0x10a>
	else if (lflag)
  8004ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004ee:	74 4f                	je     80053f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f4:	8b 00                	mov    (%rax),%eax
  8004f6:	83 f8 30             	cmp    $0x30,%eax
  8004f9:	73 24                	jae    80051f <getuint+0x9c>
  8004fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ff:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800503:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800507:	8b 00                	mov    (%rax),%eax
  800509:	89 c0                	mov    %eax,%eax
  80050b:	48 01 d0             	add    %rdx,%rax
  80050e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800512:	8b 12                	mov    (%rdx),%edx
  800514:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800517:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051b:	89 0a                	mov    %ecx,(%rdx)
  80051d:	eb 17                	jmp    800536 <getuint+0xb3>
  80051f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800523:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800527:	48 89 d0             	mov    %rdx,%rax
  80052a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80052e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800532:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800536:	48 8b 00             	mov    (%rax),%rax
  800539:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80053d:	eb 4e                	jmp    80058d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80053f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800543:	8b 00                	mov    (%rax),%eax
  800545:	83 f8 30             	cmp    $0x30,%eax
  800548:	73 24                	jae    80056e <getuint+0xeb>
  80054a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800552:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800556:	8b 00                	mov    (%rax),%eax
  800558:	89 c0                	mov    %eax,%eax
  80055a:	48 01 d0             	add    %rdx,%rax
  80055d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800561:	8b 12                	mov    (%rdx),%edx
  800563:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800566:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056a:	89 0a                	mov    %ecx,(%rdx)
  80056c:	eb 17                	jmp    800585 <getuint+0x102>
  80056e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800572:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800576:	48 89 d0             	mov    %rdx,%rax
  800579:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80057d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800581:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800585:	8b 00                	mov    (%rax),%eax
  800587:	89 c0                	mov    %eax,%eax
  800589:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80058d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800591:	c9                   	leaveq 
  800592:	c3                   	retq   

0000000000800593 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800593:	55                   	push   %rbp
  800594:	48 89 e5             	mov    %rsp,%rbp
  800597:	48 83 ec 1c          	sub    $0x1c,%rsp
  80059b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80059f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005a2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005a6:	7e 52                	jle    8005fa <getint+0x67>
		x=va_arg(*ap, long long);
  8005a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ac:	8b 00                	mov    (%rax),%eax
  8005ae:	83 f8 30             	cmp    $0x30,%eax
  8005b1:	73 24                	jae    8005d7 <getint+0x44>
  8005b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bf:	8b 00                	mov    (%rax),%eax
  8005c1:	89 c0                	mov    %eax,%eax
  8005c3:	48 01 d0             	add    %rdx,%rax
  8005c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ca:	8b 12                	mov    (%rdx),%edx
  8005cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d3:	89 0a                	mov    %ecx,(%rdx)
  8005d5:	eb 17                	jmp    8005ee <getint+0x5b>
  8005d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005df:	48 89 d0             	mov    %rdx,%rax
  8005e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ee:	48 8b 00             	mov    (%rax),%rax
  8005f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005f5:	e9 a3 00 00 00       	jmpq   80069d <getint+0x10a>
	else if (lflag)
  8005fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005fe:	74 4f                	je     80064f <getint+0xbc>
		x=va_arg(*ap, long);
  800600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800604:	8b 00                	mov    (%rax),%eax
  800606:	83 f8 30             	cmp    $0x30,%eax
  800609:	73 24                	jae    80062f <getint+0x9c>
  80060b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800617:	8b 00                	mov    (%rax),%eax
  800619:	89 c0                	mov    %eax,%eax
  80061b:	48 01 d0             	add    %rdx,%rax
  80061e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800622:	8b 12                	mov    (%rdx),%edx
  800624:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800627:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062b:	89 0a                	mov    %ecx,(%rdx)
  80062d:	eb 17                	jmp    800646 <getint+0xb3>
  80062f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800633:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800637:	48 89 d0             	mov    %rdx,%rax
  80063a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80063e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800642:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800646:	48 8b 00             	mov    (%rax),%rax
  800649:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80064d:	eb 4e                	jmp    80069d <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80064f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800653:	8b 00                	mov    (%rax),%eax
  800655:	83 f8 30             	cmp    $0x30,%eax
  800658:	73 24                	jae    80067e <getint+0xeb>
  80065a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800666:	8b 00                	mov    (%rax),%eax
  800668:	89 c0                	mov    %eax,%eax
  80066a:	48 01 d0             	add    %rdx,%rax
  80066d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800671:	8b 12                	mov    (%rdx),%edx
  800673:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800676:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067a:	89 0a                	mov    %ecx,(%rdx)
  80067c:	eb 17                	jmp    800695 <getint+0x102>
  80067e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800682:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800686:	48 89 d0             	mov    %rdx,%rax
  800689:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80068d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800691:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800695:	8b 00                	mov    (%rax),%eax
  800697:	48 98                	cltq   
  800699:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80069d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006a1:	c9                   	leaveq 
  8006a2:	c3                   	retq   

00000000008006a3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006a3:	55                   	push   %rbp
  8006a4:	48 89 e5             	mov    %rsp,%rbp
  8006a7:	41 54                	push   %r12
  8006a9:	53                   	push   %rbx
  8006aa:	48 83 ec 60          	sub    $0x60,%rsp
  8006ae:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006b2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006b6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ba:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006be:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006c2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006c6:	48 8b 0a             	mov    (%rdx),%rcx
  8006c9:	48 89 08             	mov    %rcx,(%rax)
  8006cc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006dc:	eb 17                	jmp    8006f5 <vprintfmt+0x52>
			if (ch == '\0')
  8006de:	85 db                	test   %ebx,%ebx
  8006e0:	0f 84 cc 04 00 00    	je     800bb2 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8006e6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006ea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006ee:	48 89 d6             	mov    %rdx,%rsi
  8006f1:	89 df                	mov    %ebx,%edi
  8006f3:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006fd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800701:	0f b6 00             	movzbl (%rax),%eax
  800704:	0f b6 d8             	movzbl %al,%ebx
  800707:	83 fb 25             	cmp    $0x25,%ebx
  80070a:	75 d2                	jne    8006de <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80070c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800710:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800717:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80071e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800725:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800730:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800734:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800738:	0f b6 00             	movzbl (%rax),%eax
  80073b:	0f b6 d8             	movzbl %al,%ebx
  80073e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800741:	83 f8 55             	cmp    $0x55,%eax
  800744:	0f 87 34 04 00 00    	ja     800b7e <vprintfmt+0x4db>
  80074a:	89 c0                	mov    %eax,%eax
  80074c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800753:	00 
  800754:	48 b8 18 3f 80 00 00 	movabs $0x803f18,%rax
  80075b:	00 00 00 
  80075e:	48 01 d0             	add    %rdx,%rax
  800761:	48 8b 00             	mov    (%rax),%rax
  800764:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800766:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80076a:	eb c0                	jmp    80072c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80076c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800770:	eb ba                	jmp    80072c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800772:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800779:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80077c:	89 d0                	mov    %edx,%eax
  80077e:	c1 e0 02             	shl    $0x2,%eax
  800781:	01 d0                	add    %edx,%eax
  800783:	01 c0                	add    %eax,%eax
  800785:	01 d8                	add    %ebx,%eax
  800787:	83 e8 30             	sub    $0x30,%eax
  80078a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80078d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800791:	0f b6 00             	movzbl (%rax),%eax
  800794:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800797:	83 fb 2f             	cmp    $0x2f,%ebx
  80079a:	7e 0c                	jle    8007a8 <vprintfmt+0x105>
  80079c:	83 fb 39             	cmp    $0x39,%ebx
  80079f:	7f 07                	jg     8007a8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007a6:	eb d1                	jmp    800779 <vprintfmt+0xd6>
			goto process_precision;
  8007a8:	eb 58                	jmp    800802 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ad:	83 f8 30             	cmp    $0x30,%eax
  8007b0:	73 17                	jae    8007c9 <vprintfmt+0x126>
  8007b2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007b6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b9:	89 c0                	mov    %eax,%eax
  8007bb:	48 01 d0             	add    %rdx,%rax
  8007be:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c1:	83 c2 08             	add    $0x8,%edx
  8007c4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007c7:	eb 0f                	jmp    8007d8 <vprintfmt+0x135>
  8007c9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007cd:	48 89 d0             	mov    %rdx,%rax
  8007d0:	48 83 c2 08          	add    $0x8,%rdx
  8007d4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007d8:	8b 00                	mov    (%rax),%eax
  8007da:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007dd:	eb 23                	jmp    800802 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007df:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007e3:	79 0c                	jns    8007f1 <vprintfmt+0x14e>
				width = 0;
  8007e5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007ec:	e9 3b ff ff ff       	jmpq   80072c <vprintfmt+0x89>
  8007f1:	e9 36 ff ff ff       	jmpq   80072c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007f6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007fd:	e9 2a ff ff ff       	jmpq   80072c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800802:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800806:	79 12                	jns    80081a <vprintfmt+0x177>
				width = precision, precision = -1;
  800808:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80080b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80080e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800815:	e9 12 ff ff ff       	jmpq   80072c <vprintfmt+0x89>
  80081a:	e9 0d ff ff ff       	jmpq   80072c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80081f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800823:	e9 04 ff ff ff       	jmpq   80072c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800828:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082b:	83 f8 30             	cmp    $0x30,%eax
  80082e:	73 17                	jae    800847 <vprintfmt+0x1a4>
  800830:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800834:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800837:	89 c0                	mov    %eax,%eax
  800839:	48 01 d0             	add    %rdx,%rax
  80083c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80083f:	83 c2 08             	add    $0x8,%edx
  800842:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800845:	eb 0f                	jmp    800856 <vprintfmt+0x1b3>
  800847:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80084b:	48 89 d0             	mov    %rdx,%rax
  80084e:	48 83 c2 08          	add    $0x8,%rdx
  800852:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800856:	8b 10                	mov    (%rax),%edx
  800858:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80085c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800860:	48 89 ce             	mov    %rcx,%rsi
  800863:	89 d7                	mov    %edx,%edi
  800865:	ff d0                	callq  *%rax
			break;
  800867:	e9 40 03 00 00       	jmpq   800bac <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80086c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086f:	83 f8 30             	cmp    $0x30,%eax
  800872:	73 17                	jae    80088b <vprintfmt+0x1e8>
  800874:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800878:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087b:	89 c0                	mov    %eax,%eax
  80087d:	48 01 d0             	add    %rdx,%rax
  800880:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800883:	83 c2 08             	add    $0x8,%edx
  800886:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800889:	eb 0f                	jmp    80089a <vprintfmt+0x1f7>
  80088b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80088f:	48 89 d0             	mov    %rdx,%rax
  800892:	48 83 c2 08          	add    $0x8,%rdx
  800896:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80089a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80089c:	85 db                	test   %ebx,%ebx
  80089e:	79 02                	jns    8008a2 <vprintfmt+0x1ff>
				err = -err;
  8008a0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008a2:	83 fb 15             	cmp    $0x15,%ebx
  8008a5:	7f 16                	jg     8008bd <vprintfmt+0x21a>
  8008a7:	48 b8 40 3e 80 00 00 	movabs $0x803e40,%rax
  8008ae:	00 00 00 
  8008b1:	48 63 d3             	movslq %ebx,%rdx
  8008b4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008b8:	4d 85 e4             	test   %r12,%r12
  8008bb:	75 2e                	jne    8008eb <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008bd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c5:	89 d9                	mov    %ebx,%ecx
  8008c7:	48 ba 01 3f 80 00 00 	movabs $0x803f01,%rdx
  8008ce:	00 00 00 
  8008d1:	48 89 c7             	mov    %rax,%rdi
  8008d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d9:	49 b8 bb 0b 80 00 00 	movabs $0x800bbb,%r8
  8008e0:	00 00 00 
  8008e3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e6:	e9 c1 02 00 00       	jmpq   800bac <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008eb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f3:	4c 89 e1             	mov    %r12,%rcx
  8008f6:	48 ba 0a 3f 80 00 00 	movabs $0x803f0a,%rdx
  8008fd:	00 00 00 
  800900:	48 89 c7             	mov    %rax,%rdi
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
  800908:	49 b8 bb 0b 80 00 00 	movabs $0x800bbb,%r8
  80090f:	00 00 00 
  800912:	41 ff d0             	callq  *%r8
			break;
  800915:	e9 92 02 00 00       	jmpq   800bac <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80091a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091d:	83 f8 30             	cmp    $0x30,%eax
  800920:	73 17                	jae    800939 <vprintfmt+0x296>
  800922:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800926:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800929:	89 c0                	mov    %eax,%eax
  80092b:	48 01 d0             	add    %rdx,%rax
  80092e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800931:	83 c2 08             	add    $0x8,%edx
  800934:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800937:	eb 0f                	jmp    800948 <vprintfmt+0x2a5>
  800939:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80093d:	48 89 d0             	mov    %rdx,%rax
  800940:	48 83 c2 08          	add    $0x8,%rdx
  800944:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800948:	4c 8b 20             	mov    (%rax),%r12
  80094b:	4d 85 e4             	test   %r12,%r12
  80094e:	75 0a                	jne    80095a <vprintfmt+0x2b7>
				p = "(null)";
  800950:	49 bc 0d 3f 80 00 00 	movabs $0x803f0d,%r12
  800957:	00 00 00 
			if (width > 0 && padc != '-')
  80095a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80095e:	7e 3f                	jle    80099f <vprintfmt+0x2fc>
  800960:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800964:	74 39                	je     80099f <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800966:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800969:	48 98                	cltq   
  80096b:	48 89 c6             	mov    %rax,%rsi
  80096e:	4c 89 e7             	mov    %r12,%rdi
  800971:	48 b8 c1 0f 80 00 00 	movabs $0x800fc1,%rax
  800978:	00 00 00 
  80097b:	ff d0                	callq  *%rax
  80097d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800980:	eb 17                	jmp    800999 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800982:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800986:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80098a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098e:	48 89 ce             	mov    %rcx,%rsi
  800991:	89 d7                	mov    %edx,%edi
  800993:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800995:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800999:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099d:	7f e3                	jg     800982 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80099f:	eb 37                	jmp    8009d8 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009a5:	74 1e                	je     8009c5 <vprintfmt+0x322>
  8009a7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009aa:	7e 05                	jle    8009b1 <vprintfmt+0x30e>
  8009ac:	83 fb 7e             	cmp    $0x7e,%ebx
  8009af:	7e 14                	jle    8009c5 <vprintfmt+0x322>
					putch('?', putdat);
  8009b1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b9:	48 89 d6             	mov    %rdx,%rsi
  8009bc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009c1:	ff d0                	callq  *%rax
  8009c3:	eb 0f                	jmp    8009d4 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009c5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009cd:	48 89 d6             	mov    %rdx,%rsi
  8009d0:	89 df                	mov    %ebx,%edi
  8009d2:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d8:	4c 89 e0             	mov    %r12,%rax
  8009db:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009df:	0f b6 00             	movzbl (%rax),%eax
  8009e2:	0f be d8             	movsbl %al,%ebx
  8009e5:	85 db                	test   %ebx,%ebx
  8009e7:	74 10                	je     8009f9 <vprintfmt+0x356>
  8009e9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009ed:	78 b2                	js     8009a1 <vprintfmt+0x2fe>
  8009ef:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009f3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009f7:	79 a8                	jns    8009a1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f9:	eb 16                	jmp    800a11 <vprintfmt+0x36e>
				putch(' ', putdat);
  8009fb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a03:	48 89 d6             	mov    %rdx,%rsi
  800a06:	bf 20 00 00 00       	mov    $0x20,%edi
  800a0b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a11:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a15:	7f e4                	jg     8009fb <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a17:	e9 90 01 00 00       	jmpq   800bac <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a1c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a20:	be 03 00 00 00       	mov    $0x3,%esi
  800a25:	48 89 c7             	mov    %rax,%rdi
  800a28:	48 b8 93 05 80 00 00 	movabs $0x800593,%rax
  800a2f:	00 00 00 
  800a32:	ff d0                	callq  *%rax
  800a34:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3c:	48 85 c0             	test   %rax,%rax
  800a3f:	79 1d                	jns    800a5e <vprintfmt+0x3bb>
				putch('-', putdat);
  800a41:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a49:	48 89 d6             	mov    %rdx,%rsi
  800a4c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a51:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a57:	48 f7 d8             	neg    %rax
  800a5a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a5e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a65:	e9 d5 00 00 00       	jmpq   800b3f <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a6a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a6e:	be 03 00 00 00       	mov    $0x3,%esi
  800a73:	48 89 c7             	mov    %rax,%rdi
  800a76:	48 b8 83 04 80 00 00 	movabs $0x800483,%rax
  800a7d:	00 00 00 
  800a80:	ff d0                	callq  *%rax
  800a82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a86:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a8d:	e9 ad 00 00 00       	jmpq   800b3f <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800a92:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800a95:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a99:	89 d6                	mov    %edx,%esi
  800a9b:	48 89 c7             	mov    %rax,%rdi
  800a9e:	48 b8 93 05 80 00 00 	movabs $0x800593,%rax
  800aa5:	00 00 00 
  800aa8:	ff d0                	callq  *%rax
  800aaa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800aae:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ab5:	e9 85 00 00 00       	jmpq   800b3f <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800aba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800abe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac2:	48 89 d6             	mov    %rdx,%rsi
  800ac5:	bf 30 00 00 00       	mov    $0x30,%edi
  800aca:	ff d0                	callq  *%rax
			putch('x', putdat);
  800acc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad4:	48 89 d6             	mov    %rdx,%rsi
  800ad7:	bf 78 00 00 00       	mov    $0x78,%edi
  800adc:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ade:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae1:	83 f8 30             	cmp    $0x30,%eax
  800ae4:	73 17                	jae    800afd <vprintfmt+0x45a>
  800ae6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aed:	89 c0                	mov    %eax,%eax
  800aef:	48 01 d0             	add    %rdx,%rax
  800af2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af5:	83 c2 08             	add    $0x8,%edx
  800af8:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800afb:	eb 0f                	jmp    800b0c <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800afd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b01:	48 89 d0             	mov    %rdx,%rax
  800b04:	48 83 c2 08          	add    $0x8,%rdx
  800b08:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0c:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b0f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b13:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b1a:	eb 23                	jmp    800b3f <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b1c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b20:	be 03 00 00 00       	mov    $0x3,%esi
  800b25:	48 89 c7             	mov    %rax,%rdi
  800b28:	48 b8 83 04 80 00 00 	movabs $0x800483,%rax
  800b2f:	00 00 00 
  800b32:	ff d0                	callq  *%rax
  800b34:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b38:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b3f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b44:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b47:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b4e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b56:	45 89 c1             	mov    %r8d,%r9d
  800b59:	41 89 f8             	mov    %edi,%r8d
  800b5c:	48 89 c7             	mov    %rax,%rdi
  800b5f:	48 b8 c8 03 80 00 00 	movabs $0x8003c8,%rax
  800b66:	00 00 00 
  800b69:	ff d0                	callq  *%rax
			break;
  800b6b:	eb 3f                	jmp    800bac <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b75:	48 89 d6             	mov    %rdx,%rsi
  800b78:	89 df                	mov    %ebx,%edi
  800b7a:	ff d0                	callq  *%rax
			break;
  800b7c:	eb 2e                	jmp    800bac <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b7e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b82:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b86:	48 89 d6             	mov    %rdx,%rsi
  800b89:	bf 25 00 00 00       	mov    $0x25,%edi
  800b8e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b90:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b95:	eb 05                	jmp    800b9c <vprintfmt+0x4f9>
  800b97:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b9c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba0:	48 83 e8 01          	sub    $0x1,%rax
  800ba4:	0f b6 00             	movzbl (%rax),%eax
  800ba7:	3c 25                	cmp    $0x25,%al
  800ba9:	75 ec                	jne    800b97 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bab:	90                   	nop
		}
	}
  800bac:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bad:	e9 43 fb ff ff       	jmpq   8006f5 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bb2:	48 83 c4 60          	add    $0x60,%rsp
  800bb6:	5b                   	pop    %rbx
  800bb7:	41 5c                	pop    %r12
  800bb9:	5d                   	pop    %rbp
  800bba:	c3                   	retq   

0000000000800bbb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bbb:	55                   	push   %rbp
  800bbc:	48 89 e5             	mov    %rsp,%rbp
  800bbf:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bc6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bcd:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bd4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bdb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800be2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800be9:	84 c0                	test   %al,%al
  800beb:	74 20                	je     800c0d <printfmt+0x52>
  800bed:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bf1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bf5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bf9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bfd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c01:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c05:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c09:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c0d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c14:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c1b:	00 00 00 
  800c1e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c25:	00 00 00 
  800c28:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c2c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c33:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c3a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c41:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c48:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c4f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c56:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c5d:	48 89 c7             	mov    %rax,%rdi
  800c60:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  800c67:	00 00 00 
  800c6a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c6c:	c9                   	leaveq 
  800c6d:	c3                   	retq   

0000000000800c6e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c6e:	55                   	push   %rbp
  800c6f:	48 89 e5             	mov    %rsp,%rbp
  800c72:	48 83 ec 10          	sub    $0x10,%rsp
  800c76:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c79:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c81:	8b 40 10             	mov    0x10(%rax),%eax
  800c84:	8d 50 01             	lea    0x1(%rax),%edx
  800c87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c92:	48 8b 10             	mov    (%rax),%rdx
  800c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c99:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c9d:	48 39 c2             	cmp    %rax,%rdx
  800ca0:	73 17                	jae    800cb9 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca6:	48 8b 00             	mov    (%rax),%rax
  800ca9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cb1:	48 89 0a             	mov    %rcx,(%rdx)
  800cb4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cb7:	88 10                	mov    %dl,(%rax)
}
  800cb9:	c9                   	leaveq 
  800cba:	c3                   	retq   

0000000000800cbb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cbb:	55                   	push   %rbp
  800cbc:	48 89 e5             	mov    %rsp,%rbp
  800cbf:	48 83 ec 50          	sub    $0x50,%rsp
  800cc3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cc7:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cca:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cce:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cd2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cd6:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cda:	48 8b 0a             	mov    (%rdx),%rcx
  800cdd:	48 89 08             	mov    %rcx,(%rax)
  800ce0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ce4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ce8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cec:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cf0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cf4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cf8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cfb:	48 98                	cltq   
  800cfd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d01:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d05:	48 01 d0             	add    %rdx,%rax
  800d08:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d0c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d13:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d18:	74 06                	je     800d20 <vsnprintf+0x65>
  800d1a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d1e:	7f 07                	jg     800d27 <vsnprintf+0x6c>
		return -E_INVAL;
  800d20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d25:	eb 2f                	jmp    800d56 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d27:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d2b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d2f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d33:	48 89 c6             	mov    %rax,%rsi
  800d36:	48 bf 6e 0c 80 00 00 	movabs $0x800c6e,%rdi
  800d3d:	00 00 00 
  800d40:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  800d47:	00 00 00 
  800d4a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d4c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d50:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d53:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d56:	c9                   	leaveq 
  800d57:	c3                   	retq   

0000000000800d58 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d58:	55                   	push   %rbp
  800d59:	48 89 e5             	mov    %rsp,%rbp
  800d5c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d63:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d6a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d70:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d77:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d7e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d85:	84 c0                	test   %al,%al
  800d87:	74 20                	je     800da9 <snprintf+0x51>
  800d89:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d8d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d91:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d95:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d99:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d9d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800da5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800da9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800db0:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800db7:	00 00 00 
  800dba:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dc1:	00 00 00 
  800dc4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dc8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dcf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dd6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ddd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800de4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800deb:	48 8b 0a             	mov    (%rdx),%rcx
  800dee:	48 89 08             	mov    %rcx,(%rax)
  800df1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800df5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800df9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dfd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e01:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e08:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e0f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e15:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e1c:	48 89 c7             	mov    %rax,%rdi
  800e1f:	48 b8 bb 0c 80 00 00 	movabs $0x800cbb,%rax
  800e26:	00 00 00 
  800e29:	ff d0                	callq  *%rax
  800e2b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e31:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e37:	c9                   	leaveq 
  800e38:	c3                   	retq   

0000000000800e39 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800e39:	55                   	push   %rbp
  800e3a:	48 89 e5             	mov    %rsp,%rbp
  800e3d:	48 83 ec 20          	sub    $0x20,%rsp
  800e41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800e45:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800e4a:	74 27                	je     800e73 <readline+0x3a>
		fprintf(1, "%s", prompt);
  800e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e50:	48 89 c2             	mov    %rax,%rdx
  800e53:	48 be c8 41 80 00 00 	movabs $0x8041c8,%rsi
  800e5a:	00 00 00 
  800e5d:	bf 01 00 00 00       	mov    $0x1,%edi
  800e62:	b8 00 00 00 00       	mov    $0x0,%eax
  800e67:	48 b9 e3 2e 80 00 00 	movabs $0x802ee3,%rcx
  800e6e:	00 00 00 
  800e71:	ff d1                	callq  *%rcx
#endif

	i = 0;
  800e73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  800e7a:	bf 00 00 00 00       	mov    $0x0,%edi
  800e7f:	48 b8 8e 36 80 00 00 	movabs $0x80368e,%rax
  800e86:	00 00 00 
  800e89:	ff d0                	callq  *%rax
  800e8b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  800e8e:	48 b8 45 36 80 00 00 	movabs $0x803645,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
  800e9a:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  800e9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800ea1:	79 30                	jns    800ed3 <readline+0x9a>
			if (c != -E_EOF)
  800ea3:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  800ea7:	74 20                	je     800ec9 <readline+0x90>
				cprintf("read error: %e\n", c);
  800ea9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800eac:	89 c6                	mov    %eax,%esi
  800eae:	48 bf cb 41 80 00 00 	movabs $0x8041cb,%rdi
  800eb5:	00 00 00 
  800eb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebd:	48 ba f0 02 80 00 00 	movabs $0x8002f0,%rdx
  800ec4:	00 00 00 
  800ec7:	ff d2                	callq  *%rdx
			return NULL;
  800ec9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ece:	e9 be 00 00 00       	jmpq   800f91 <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800ed3:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  800ed7:	74 06                	je     800edf <readline+0xa6>
  800ed9:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  800edd:	75 26                	jne    800f05 <readline+0xcc>
  800edf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ee3:	7e 20                	jle    800f05 <readline+0xcc>
			if (echoing)
  800ee5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ee9:	74 11                	je     800efc <readline+0xc3>
				cputchar('\b');
  800eeb:	bf 08 00 00 00       	mov    $0x8,%edi
  800ef0:	48 b8 1a 36 80 00 00 	movabs $0x80361a,%rax
  800ef7:	00 00 00 
  800efa:	ff d0                	callq  *%rax
			i--;
  800efc:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  800f00:	e9 87 00 00 00       	jmpq   800f8c <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800f05:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  800f09:	7e 3f                	jle    800f4a <readline+0x111>
  800f0b:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  800f12:	7f 36                	jg     800f4a <readline+0x111>
			if (echoing)
  800f14:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800f18:	74 11                	je     800f2b <readline+0xf2>
				cputchar(c);
  800f1a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800f1d:	89 c7                	mov    %eax,%edi
  800f1f:	48 b8 1a 36 80 00 00 	movabs $0x80361a,%rax
  800f26:	00 00 00 
  800f29:	ff d0                	callq  *%rax
			buf[i++] = c;
  800f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f2e:	8d 50 01             	lea    0x1(%rax),%edx
  800f31:	89 55 fc             	mov    %edx,-0x4(%rbp)
  800f34:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800f37:	89 d1                	mov    %edx,%ecx
  800f39:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f40:	00 00 00 
  800f43:	48 98                	cltq   
  800f45:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  800f48:	eb 42                	jmp    800f8c <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  800f4a:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  800f4e:	74 06                	je     800f56 <readline+0x11d>
  800f50:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  800f54:	75 36                	jne    800f8c <readline+0x153>
			if (echoing)
  800f56:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800f5a:	74 11                	je     800f6d <readline+0x134>
				cputchar('\n');
  800f5c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800f61:	48 b8 1a 36 80 00 00 	movabs $0x80361a,%rax
  800f68:	00 00 00 
  800f6b:	ff d0                	callq  *%rax
			buf[i] = 0;
  800f6d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f74:	00 00 00 
  800f77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f7a:	48 98                	cltq   
  800f7c:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  800f80:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800f87:	00 00 00 
  800f8a:	eb 05                	jmp    800f91 <readline+0x158>
		}
	}
  800f8c:	e9 fd fe ff ff       	jmpq   800e8e <readline+0x55>
}
  800f91:	c9                   	leaveq 
  800f92:	c3                   	retq   

0000000000800f93 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f93:	55                   	push   %rbp
  800f94:	48 89 e5             	mov    %rsp,%rbp
  800f97:	48 83 ec 18          	sub    $0x18,%rsp
  800f9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fa6:	eb 09                	jmp    800fb1 <strlen+0x1e>
		n++;
  800fa8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fac:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb5:	0f b6 00             	movzbl (%rax),%eax
  800fb8:	84 c0                	test   %al,%al
  800fba:	75 ec                	jne    800fa8 <strlen+0x15>
		n++;
	return n;
  800fbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fbf:	c9                   	leaveq 
  800fc0:	c3                   	retq   

0000000000800fc1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fc1:	55                   	push   %rbp
  800fc2:	48 89 e5             	mov    %rsp,%rbp
  800fc5:	48 83 ec 20          	sub    $0x20,%rsp
  800fc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fd8:	eb 0e                	jmp    800fe8 <strnlen+0x27>
		n++;
  800fda:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fde:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fe3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800fe8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800fed:	74 0b                	je     800ffa <strnlen+0x39>
  800fef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff3:	0f b6 00             	movzbl (%rax),%eax
  800ff6:	84 c0                	test   %al,%al
  800ff8:	75 e0                	jne    800fda <strnlen+0x19>
		n++;
	return n;
  800ffa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ffd:	c9                   	leaveq 
  800ffe:	c3                   	retq   

0000000000800fff <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fff:	55                   	push   %rbp
  801000:	48 89 e5             	mov    %rsp,%rbp
  801003:	48 83 ec 20          	sub    $0x20,%rsp
  801007:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80100b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80100f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801013:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801017:	90                   	nop
  801018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801020:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801024:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801028:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80102c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801030:	0f b6 12             	movzbl (%rdx),%edx
  801033:	88 10                	mov    %dl,(%rax)
  801035:	0f b6 00             	movzbl (%rax),%eax
  801038:	84 c0                	test   %al,%al
  80103a:	75 dc                	jne    801018 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80103c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801040:	c9                   	leaveq 
  801041:	c3                   	retq   

0000000000801042 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801042:	55                   	push   %rbp
  801043:	48 89 e5             	mov    %rsp,%rbp
  801046:	48 83 ec 20          	sub    $0x20,%rsp
  80104a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80104e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801056:	48 89 c7             	mov    %rax,%rdi
  801059:	48 b8 93 0f 80 00 00 	movabs $0x800f93,%rax
  801060:	00 00 00 
  801063:	ff d0                	callq  *%rax
  801065:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80106b:	48 63 d0             	movslq %eax,%rdx
  80106e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801072:	48 01 c2             	add    %rax,%rdx
  801075:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801079:	48 89 c6             	mov    %rax,%rsi
  80107c:	48 89 d7             	mov    %rdx,%rdi
  80107f:	48 b8 ff 0f 80 00 00 	movabs $0x800fff,%rax
  801086:	00 00 00 
  801089:	ff d0                	callq  *%rax
	return dst;
  80108b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80108f:	c9                   	leaveq 
  801090:	c3                   	retq   

0000000000801091 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801091:	55                   	push   %rbp
  801092:	48 89 e5             	mov    %rsp,%rbp
  801095:	48 83 ec 28          	sub    $0x28,%rsp
  801099:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80109d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010ad:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010b4:	00 
  8010b5:	eb 2a                	jmp    8010e1 <strncpy+0x50>
		*dst++ = *src;
  8010b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010c7:	0f b6 12             	movzbl (%rdx),%edx
  8010ca:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d0:	0f b6 00             	movzbl (%rax),%eax
  8010d3:	84 c0                	test   %al,%al
  8010d5:	74 05                	je     8010dc <strncpy+0x4b>
			src++;
  8010d7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010dc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010e9:	72 cc                	jb     8010b7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010ef:	c9                   	leaveq 
  8010f0:	c3                   	retq   

00000000008010f1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010f1:	55                   	push   %rbp
  8010f2:	48 89 e5             	mov    %rsp,%rbp
  8010f5:	48 83 ec 28          	sub    $0x28,%rsp
  8010f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801101:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801109:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80110d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801112:	74 3d                	je     801151 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801114:	eb 1d                	jmp    801133 <strlcpy+0x42>
			*dst++ = *src++;
  801116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80111e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801122:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801126:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80112a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80112e:	0f b6 12             	movzbl (%rdx),%edx
  801131:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801133:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801138:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80113d:	74 0b                	je     80114a <strlcpy+0x59>
  80113f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801143:	0f b6 00             	movzbl (%rax),%eax
  801146:	84 c0                	test   %al,%al
  801148:	75 cc                	jne    801116 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80114a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801151:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801155:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801159:	48 29 c2             	sub    %rax,%rdx
  80115c:	48 89 d0             	mov    %rdx,%rax
}
  80115f:	c9                   	leaveq 
  801160:	c3                   	retq   

0000000000801161 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801161:	55                   	push   %rbp
  801162:	48 89 e5             	mov    %rsp,%rbp
  801165:	48 83 ec 10          	sub    $0x10,%rsp
  801169:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80116d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801171:	eb 0a                	jmp    80117d <strcmp+0x1c>
		p++, q++;
  801173:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801178:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80117d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801181:	0f b6 00             	movzbl (%rax),%eax
  801184:	84 c0                	test   %al,%al
  801186:	74 12                	je     80119a <strcmp+0x39>
  801188:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118c:	0f b6 10             	movzbl (%rax),%edx
  80118f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801193:	0f b6 00             	movzbl (%rax),%eax
  801196:	38 c2                	cmp    %al,%dl
  801198:	74 d9                	je     801173 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80119a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119e:	0f b6 00             	movzbl (%rax),%eax
  8011a1:	0f b6 d0             	movzbl %al,%edx
  8011a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a8:	0f b6 00             	movzbl (%rax),%eax
  8011ab:	0f b6 c0             	movzbl %al,%eax
  8011ae:	29 c2                	sub    %eax,%edx
  8011b0:	89 d0                	mov    %edx,%eax
}
  8011b2:	c9                   	leaveq 
  8011b3:	c3                   	retq   

00000000008011b4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011b4:	55                   	push   %rbp
  8011b5:	48 89 e5             	mov    %rsp,%rbp
  8011b8:	48 83 ec 18          	sub    $0x18,%rsp
  8011bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011c4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011c8:	eb 0f                	jmp    8011d9 <strncmp+0x25>
		n--, p++, q++;
  8011ca:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011de:	74 1d                	je     8011fd <strncmp+0x49>
  8011e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e4:	0f b6 00             	movzbl (%rax),%eax
  8011e7:	84 c0                	test   %al,%al
  8011e9:	74 12                	je     8011fd <strncmp+0x49>
  8011eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ef:	0f b6 10             	movzbl (%rax),%edx
  8011f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f6:	0f b6 00             	movzbl (%rax),%eax
  8011f9:	38 c2                	cmp    %al,%dl
  8011fb:	74 cd                	je     8011ca <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011fd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801202:	75 07                	jne    80120b <strncmp+0x57>
		return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 18                	jmp    801223 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120f:	0f b6 00             	movzbl (%rax),%eax
  801212:	0f b6 d0             	movzbl %al,%edx
  801215:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801219:	0f b6 00             	movzbl (%rax),%eax
  80121c:	0f b6 c0             	movzbl %al,%eax
  80121f:	29 c2                	sub    %eax,%edx
  801221:	89 d0                	mov    %edx,%eax
}
  801223:	c9                   	leaveq 
  801224:	c3                   	retq   

0000000000801225 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801225:	55                   	push   %rbp
  801226:	48 89 e5             	mov    %rsp,%rbp
  801229:	48 83 ec 0c          	sub    $0xc,%rsp
  80122d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801231:	89 f0                	mov    %esi,%eax
  801233:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801236:	eb 17                	jmp    80124f <strchr+0x2a>
		if (*s == c)
  801238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123c:	0f b6 00             	movzbl (%rax),%eax
  80123f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801242:	75 06                	jne    80124a <strchr+0x25>
			return (char *) s;
  801244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801248:	eb 15                	jmp    80125f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80124a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80124f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801253:	0f b6 00             	movzbl (%rax),%eax
  801256:	84 c0                	test   %al,%al
  801258:	75 de                	jne    801238 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80125a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80125f:	c9                   	leaveq 
  801260:	c3                   	retq   

0000000000801261 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801261:	55                   	push   %rbp
  801262:	48 89 e5             	mov    %rsp,%rbp
  801265:	48 83 ec 0c          	sub    $0xc,%rsp
  801269:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126d:	89 f0                	mov    %esi,%eax
  80126f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801272:	eb 13                	jmp    801287 <strfind+0x26>
		if (*s == c)
  801274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801278:	0f b6 00             	movzbl (%rax),%eax
  80127b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80127e:	75 02                	jne    801282 <strfind+0x21>
			break;
  801280:	eb 10                	jmp    801292 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801282:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128b:	0f b6 00             	movzbl (%rax),%eax
  80128e:	84 c0                	test   %al,%al
  801290:	75 e2                	jne    801274 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801292:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801296:	c9                   	leaveq 
  801297:	c3                   	retq   

0000000000801298 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801298:	55                   	push   %rbp
  801299:	48 89 e5             	mov    %rsp,%rbp
  80129c:	48 83 ec 18          	sub    $0x18,%rsp
  8012a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a4:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012a7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012ab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012b0:	75 06                	jne    8012b8 <memset+0x20>
		return v;
  8012b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b6:	eb 69                	jmp    801321 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bc:	83 e0 03             	and    $0x3,%eax
  8012bf:	48 85 c0             	test   %rax,%rax
  8012c2:	75 48                	jne    80130c <memset+0x74>
  8012c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c8:	83 e0 03             	and    $0x3,%eax
  8012cb:	48 85 c0             	test   %rax,%rax
  8012ce:	75 3c                	jne    80130c <memset+0x74>
		c &= 0xFF;
  8012d0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012da:	c1 e0 18             	shl    $0x18,%eax
  8012dd:	89 c2                	mov    %eax,%edx
  8012df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012e2:	c1 e0 10             	shl    $0x10,%eax
  8012e5:	09 c2                	or     %eax,%edx
  8012e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012ea:	c1 e0 08             	shl    $0x8,%eax
  8012ed:	09 d0                	or     %edx,%eax
  8012ef:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f6:	48 c1 e8 02          	shr    $0x2,%rax
  8012fa:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801301:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801304:	48 89 d7             	mov    %rdx,%rdi
  801307:	fc                   	cld    
  801308:	f3 ab                	rep stos %eax,%es:(%rdi)
  80130a:	eb 11                	jmp    80131d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80130c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801310:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801313:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801317:	48 89 d7             	mov    %rdx,%rdi
  80131a:	fc                   	cld    
  80131b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801321:	c9                   	leaveq 
  801322:	c3                   	retq   

0000000000801323 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801323:	55                   	push   %rbp
  801324:	48 89 e5             	mov    %rsp,%rbp
  801327:	48 83 ec 28          	sub    $0x28,%rsp
  80132b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80132f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801333:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801337:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80133f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801343:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80134f:	0f 83 88 00 00 00    	jae    8013dd <memmove+0xba>
  801355:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801359:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135d:	48 01 d0             	add    %rdx,%rax
  801360:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801364:	76 77                	jbe    8013dd <memmove+0xba>
		s += n;
  801366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80136e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801372:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137a:	83 e0 03             	and    $0x3,%eax
  80137d:	48 85 c0             	test   %rax,%rax
  801380:	75 3b                	jne    8013bd <memmove+0x9a>
  801382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801386:	83 e0 03             	and    $0x3,%eax
  801389:	48 85 c0             	test   %rax,%rax
  80138c:	75 2f                	jne    8013bd <memmove+0x9a>
  80138e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801392:	83 e0 03             	and    $0x3,%eax
  801395:	48 85 c0             	test   %rax,%rax
  801398:	75 23                	jne    8013bd <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80139a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139e:	48 83 e8 04          	sub    $0x4,%rax
  8013a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a6:	48 83 ea 04          	sub    $0x4,%rdx
  8013aa:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013ae:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013b2:	48 89 c7             	mov    %rax,%rdi
  8013b5:	48 89 d6             	mov    %rdx,%rsi
  8013b8:	fd                   	std    
  8013b9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013bb:	eb 1d                	jmp    8013da <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c9:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d1:	48 89 d7             	mov    %rdx,%rdi
  8013d4:	48 89 c1             	mov    %rax,%rcx
  8013d7:	fd                   	std    
  8013d8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013da:	fc                   	cld    
  8013db:	eb 57                	jmp    801434 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e1:	83 e0 03             	and    $0x3,%eax
  8013e4:	48 85 c0             	test   %rax,%rax
  8013e7:	75 36                	jne    80141f <memmove+0xfc>
  8013e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ed:	83 e0 03             	and    $0x3,%eax
  8013f0:	48 85 c0             	test   %rax,%rax
  8013f3:	75 2a                	jne    80141f <memmove+0xfc>
  8013f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f9:	83 e0 03             	and    $0x3,%eax
  8013fc:	48 85 c0             	test   %rax,%rax
  8013ff:	75 1e                	jne    80141f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801401:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801405:	48 c1 e8 02          	shr    $0x2,%rax
  801409:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80140c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801410:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801414:	48 89 c7             	mov    %rax,%rdi
  801417:	48 89 d6             	mov    %rdx,%rsi
  80141a:	fc                   	cld    
  80141b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80141d:	eb 15                	jmp    801434 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80141f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801423:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801427:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80142b:	48 89 c7             	mov    %rax,%rdi
  80142e:	48 89 d6             	mov    %rdx,%rsi
  801431:	fc                   	cld    
  801432:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801438:	c9                   	leaveq 
  801439:	c3                   	retq   

000000000080143a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80143a:	55                   	push   %rbp
  80143b:	48 89 e5             	mov    %rsp,%rbp
  80143e:	48 83 ec 18          	sub    $0x18,%rsp
  801442:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801446:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80144a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80144e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801452:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145a:	48 89 ce             	mov    %rcx,%rsi
  80145d:	48 89 c7             	mov    %rax,%rdi
  801460:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  801467:	00 00 00 
  80146a:	ff d0                	callq  *%rax
}
  80146c:	c9                   	leaveq 
  80146d:	c3                   	retq   

000000000080146e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80146e:	55                   	push   %rbp
  80146f:	48 89 e5             	mov    %rsp,%rbp
  801472:	48 83 ec 28          	sub    $0x28,%rsp
  801476:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80147a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80147e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801486:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80148a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80148e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801492:	eb 36                	jmp    8014ca <memcmp+0x5c>
		if (*s1 != *s2)
  801494:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801498:	0f b6 10             	movzbl (%rax),%edx
  80149b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	38 c2                	cmp    %al,%dl
  8014a4:	74 1a                	je     8014c0 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014aa:	0f b6 00             	movzbl (%rax),%eax
  8014ad:	0f b6 d0             	movzbl %al,%edx
  8014b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b4:	0f b6 00             	movzbl (%rax),%eax
  8014b7:	0f b6 c0             	movzbl %al,%eax
  8014ba:	29 c2                	sub    %eax,%edx
  8014bc:	89 d0                	mov    %edx,%eax
  8014be:	eb 20                	jmp    8014e0 <memcmp+0x72>
		s1++, s2++;
  8014c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014c5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ce:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014d6:	48 85 c0             	test   %rax,%rax
  8014d9:	75 b9                	jne    801494 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e0:	c9                   	leaveq 
  8014e1:	c3                   	retq   

00000000008014e2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014e2:	55                   	push   %rbp
  8014e3:	48 89 e5             	mov    %rsp,%rbp
  8014e6:	48 83 ec 28          	sub    $0x28,%rsp
  8014ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ee:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014fd:	48 01 d0             	add    %rdx,%rax
  801500:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801504:	eb 15                	jmp    80151b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150a:	0f b6 10             	movzbl (%rax),%edx
  80150d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801510:	38 c2                	cmp    %al,%dl
  801512:	75 02                	jne    801516 <memfind+0x34>
			break;
  801514:	eb 0f                	jmp    801525 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801516:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80151b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801523:	72 e1                	jb     801506 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801529:	c9                   	leaveq 
  80152a:	c3                   	retq   

000000000080152b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80152b:	55                   	push   %rbp
  80152c:	48 89 e5             	mov    %rsp,%rbp
  80152f:	48 83 ec 34          	sub    $0x34,%rsp
  801533:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801537:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80153b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80153e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801545:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80154c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80154d:	eb 05                	jmp    801554 <strtol+0x29>
		s++;
  80154f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801558:	0f b6 00             	movzbl (%rax),%eax
  80155b:	3c 20                	cmp    $0x20,%al
  80155d:	74 f0                	je     80154f <strtol+0x24>
  80155f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801563:	0f b6 00             	movzbl (%rax),%eax
  801566:	3c 09                	cmp    $0x9,%al
  801568:	74 e5                	je     80154f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	0f b6 00             	movzbl (%rax),%eax
  801571:	3c 2b                	cmp    $0x2b,%al
  801573:	75 07                	jne    80157c <strtol+0x51>
		s++;
  801575:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80157a:	eb 17                	jmp    801593 <strtol+0x68>
	else if (*s == '-')
  80157c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801580:	0f b6 00             	movzbl (%rax),%eax
  801583:	3c 2d                	cmp    $0x2d,%al
  801585:	75 0c                	jne    801593 <strtol+0x68>
		s++, neg = 1;
  801587:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80158c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801593:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801597:	74 06                	je     80159f <strtol+0x74>
  801599:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80159d:	75 28                	jne    8015c7 <strtol+0x9c>
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	3c 30                	cmp    $0x30,%al
  8015a8:	75 1d                	jne    8015c7 <strtol+0x9c>
  8015aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ae:	48 83 c0 01          	add    $0x1,%rax
  8015b2:	0f b6 00             	movzbl (%rax),%eax
  8015b5:	3c 78                	cmp    $0x78,%al
  8015b7:	75 0e                	jne    8015c7 <strtol+0x9c>
		s += 2, base = 16;
  8015b9:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015be:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015c5:	eb 2c                	jmp    8015f3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015cb:	75 19                	jne    8015e6 <strtol+0xbb>
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	3c 30                	cmp    $0x30,%al
  8015d6:	75 0e                	jne    8015e6 <strtol+0xbb>
		s++, base = 8;
  8015d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015dd:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015e4:	eb 0d                	jmp    8015f3 <strtol+0xc8>
	else if (base == 0)
  8015e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015ea:	75 07                	jne    8015f3 <strtol+0xc8>
		base = 10;
  8015ec:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f7:	0f b6 00             	movzbl (%rax),%eax
  8015fa:	3c 2f                	cmp    $0x2f,%al
  8015fc:	7e 1d                	jle    80161b <strtol+0xf0>
  8015fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801602:	0f b6 00             	movzbl (%rax),%eax
  801605:	3c 39                	cmp    $0x39,%al
  801607:	7f 12                	jg     80161b <strtol+0xf0>
			dig = *s - '0';
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	0f b6 00             	movzbl (%rax),%eax
  801610:	0f be c0             	movsbl %al,%eax
  801613:	83 e8 30             	sub    $0x30,%eax
  801616:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801619:	eb 4e                	jmp    801669 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80161b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	3c 60                	cmp    $0x60,%al
  801624:	7e 1d                	jle    801643 <strtol+0x118>
  801626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	3c 7a                	cmp    $0x7a,%al
  80162f:	7f 12                	jg     801643 <strtol+0x118>
			dig = *s - 'a' + 10;
  801631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801635:	0f b6 00             	movzbl (%rax),%eax
  801638:	0f be c0             	movsbl %al,%eax
  80163b:	83 e8 57             	sub    $0x57,%eax
  80163e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801641:	eb 26                	jmp    801669 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801647:	0f b6 00             	movzbl (%rax),%eax
  80164a:	3c 40                	cmp    $0x40,%al
  80164c:	7e 48                	jle    801696 <strtol+0x16b>
  80164e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801652:	0f b6 00             	movzbl (%rax),%eax
  801655:	3c 5a                	cmp    $0x5a,%al
  801657:	7f 3d                	jg     801696 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801659:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165d:	0f b6 00             	movzbl (%rax),%eax
  801660:	0f be c0             	movsbl %al,%eax
  801663:	83 e8 37             	sub    $0x37,%eax
  801666:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801669:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80166c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80166f:	7c 02                	jl     801673 <strtol+0x148>
			break;
  801671:	eb 23                	jmp    801696 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801673:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801678:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80167b:	48 98                	cltq   
  80167d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801682:	48 89 c2             	mov    %rax,%rdx
  801685:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801688:	48 98                	cltq   
  80168a:	48 01 d0             	add    %rdx,%rax
  80168d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801691:	e9 5d ff ff ff       	jmpq   8015f3 <strtol+0xc8>

	if (endptr)
  801696:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80169b:	74 0b                	je     8016a8 <strtol+0x17d>
		*endptr = (char *) s;
  80169d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016a1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016a5:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016ac:	74 09                	je     8016b7 <strtol+0x18c>
  8016ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b2:	48 f7 d8             	neg    %rax
  8016b5:	eb 04                	jmp    8016bb <strtol+0x190>
  8016b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016bb:	c9                   	leaveq 
  8016bc:	c3                   	retq   

00000000008016bd <strstr>:

char * strstr(const char *in, const char *str)
{
  8016bd:	55                   	push   %rbp
  8016be:	48 89 e5             	mov    %rsp,%rbp
  8016c1:	48 83 ec 30          	sub    $0x30,%rsp
  8016c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016d1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016d5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016d9:	0f b6 00             	movzbl (%rax),%eax
  8016dc:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8016df:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016e3:	75 06                	jne    8016eb <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8016e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e9:	eb 6b                	jmp    801756 <strstr+0x99>

	len = strlen(str);
  8016eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ef:	48 89 c7             	mov    %rax,%rdi
  8016f2:	48 b8 93 0f 80 00 00 	movabs $0x800f93,%rax
  8016f9:	00 00 00 
  8016fc:	ff d0                	callq  *%rax
  8016fe:	48 98                	cltq   
  801700:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801708:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80170c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801716:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80171a:	75 07                	jne    801723 <strstr+0x66>
				return (char *) 0;
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
  801721:	eb 33                	jmp    801756 <strstr+0x99>
		} while (sc != c);
  801723:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801727:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80172a:	75 d8                	jne    801704 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80172c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801730:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	48 89 ce             	mov    %rcx,%rsi
  80173b:	48 89 c7             	mov    %rax,%rdi
  80173e:	48 b8 b4 11 80 00 00 	movabs $0x8011b4,%rax
  801745:	00 00 00 
  801748:	ff d0                	callq  *%rax
  80174a:	85 c0                	test   %eax,%eax
  80174c:	75 b6                	jne    801704 <strstr+0x47>

	return (char *) (in - 1);
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	48 83 e8 01          	sub    $0x1,%rax
}
  801756:	c9                   	leaveq 
  801757:	c3                   	retq   

0000000000801758 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801758:	55                   	push   %rbp
  801759:	48 89 e5             	mov    %rsp,%rbp
  80175c:	53                   	push   %rbx
  80175d:	48 83 ec 48          	sub    $0x48,%rsp
  801761:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801764:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801767:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80176b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80176f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801773:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801777:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80177a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80177e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801782:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801786:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80178a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80178e:	4c 89 c3             	mov    %r8,%rbx
  801791:	cd 30                	int    $0x30
  801793:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801797:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80179b:	74 3e                	je     8017db <syscall+0x83>
  80179d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017a2:	7e 37                	jle    8017db <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017ab:	49 89 d0             	mov    %rdx,%r8
  8017ae:	89 c1                	mov    %eax,%ecx
  8017b0:	48 ba db 41 80 00 00 	movabs $0x8041db,%rdx
  8017b7:	00 00 00 
  8017ba:	be 23 00 00 00       	mov    $0x23,%esi
  8017bf:	48 bf f8 41 80 00 00 	movabs $0x8041f8,%rdi
  8017c6:	00 00 00 
  8017c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ce:	49 b9 cd 38 80 00 00 	movabs $0x8038cd,%r9
  8017d5:	00 00 00 
  8017d8:	41 ff d1             	callq  *%r9

	return ret;
  8017db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017df:	48 83 c4 48          	add    $0x48,%rsp
  8017e3:	5b                   	pop    %rbx
  8017e4:	5d                   	pop    %rbp
  8017e5:	c3                   	retq   

00000000008017e6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017e6:	55                   	push   %rbp
  8017e7:	48 89 e5             	mov    %rsp,%rbp
  8017ea:	48 83 ec 20          	sub    $0x20,%rsp
  8017ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801805:	00 
  801806:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80180c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801812:	48 89 d1             	mov    %rdx,%rcx
  801815:	48 89 c2             	mov    %rax,%rdx
  801818:	be 00 00 00 00       	mov    $0x0,%esi
  80181d:	bf 00 00 00 00       	mov    $0x0,%edi
  801822:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801829:	00 00 00 
  80182c:	ff d0                	callq  *%rax
}
  80182e:	c9                   	leaveq 
  80182f:	c3                   	retq   

0000000000801830 <sys_cgetc>:

int
sys_cgetc(void)
{
  801830:	55                   	push   %rbp
  801831:	48 89 e5             	mov    %rsp,%rbp
  801834:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801838:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80183f:	00 
  801840:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801846:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
  801856:	be 00 00 00 00       	mov    $0x0,%esi
  80185b:	bf 01 00 00 00       	mov    $0x1,%edi
  801860:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801867:	00 00 00 
  80186a:	ff d0                	callq  *%rax
}
  80186c:	c9                   	leaveq 
  80186d:	c3                   	retq   

000000000080186e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80186e:	55                   	push   %rbp
  80186f:	48 89 e5             	mov    %rsp,%rbp
  801872:	48 83 ec 10          	sub    $0x10,%rsp
  801876:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801879:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80187c:	48 98                	cltq   
  80187e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801885:	00 
  801886:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801892:	b9 00 00 00 00       	mov    $0x0,%ecx
  801897:	48 89 c2             	mov    %rax,%rdx
  80189a:	be 01 00 00 00       	mov    $0x1,%esi
  80189f:	bf 03 00 00 00       	mov    $0x3,%edi
  8018a4:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  8018ab:	00 00 00 
  8018ae:	ff d0                	callq  *%rax
}
  8018b0:	c9                   	leaveq 
  8018b1:	c3                   	retq   

00000000008018b2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018ba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c1:	00 
  8018c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	be 00 00 00 00       	mov    $0x0,%esi
  8018dd:	bf 02 00 00 00       	mov    $0x2,%edi
  8018e2:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  8018e9:	00 00 00 
  8018ec:	ff d0                	callq  *%rax
}
  8018ee:	c9                   	leaveq 
  8018ef:	c3                   	retq   

00000000008018f0 <sys_yield>:

void
sys_yield(void)
{
  8018f0:	55                   	push   %rbp
  8018f1:	48 89 e5             	mov    %rsp,%rbp
  8018f4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ff:	00 
  801900:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801906:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801911:	ba 00 00 00 00       	mov    $0x0,%edx
  801916:	be 00 00 00 00       	mov    $0x0,%esi
  80191b:	bf 0b 00 00 00       	mov    $0xb,%edi
  801920:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801927:	00 00 00 
  80192a:	ff d0                	callq  *%rax
}
  80192c:	c9                   	leaveq 
  80192d:	c3                   	retq   

000000000080192e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80192e:	55                   	push   %rbp
  80192f:	48 89 e5             	mov    %rsp,%rbp
  801932:	48 83 ec 20          	sub    $0x20,%rsp
  801936:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801939:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80193d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801940:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801943:	48 63 c8             	movslq %eax,%rcx
  801946:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80194a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194d:	48 98                	cltq   
  80194f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801956:	00 
  801957:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195d:	49 89 c8             	mov    %rcx,%r8
  801960:	48 89 d1             	mov    %rdx,%rcx
  801963:	48 89 c2             	mov    %rax,%rdx
  801966:	be 01 00 00 00       	mov    $0x1,%esi
  80196b:	bf 04 00 00 00       	mov    $0x4,%edi
  801970:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801977:	00 00 00 
  80197a:	ff d0                	callq  *%rax
}
  80197c:	c9                   	leaveq 
  80197d:	c3                   	retq   

000000000080197e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80197e:	55                   	push   %rbp
  80197f:	48 89 e5             	mov    %rsp,%rbp
  801982:	48 83 ec 30          	sub    $0x30,%rsp
  801986:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801989:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80198d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801990:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801994:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801998:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80199b:	48 63 c8             	movslq %eax,%rcx
  80199e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019a5:	48 63 f0             	movslq %eax,%rsi
  8019a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019af:	48 98                	cltq   
  8019b1:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019b5:	49 89 f9             	mov    %rdi,%r9
  8019b8:	49 89 f0             	mov    %rsi,%r8
  8019bb:	48 89 d1             	mov    %rdx,%rcx
  8019be:	48 89 c2             	mov    %rax,%rdx
  8019c1:	be 01 00 00 00       	mov    $0x1,%esi
  8019c6:	bf 05 00 00 00       	mov    $0x5,%edi
  8019cb:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  8019d2:	00 00 00 
  8019d5:	ff d0                	callq  *%rax
}
  8019d7:	c9                   	leaveq 
  8019d8:	c3                   	retq   

00000000008019d9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019d9:	55                   	push   %rbp
  8019da:	48 89 e5             	mov    %rsp,%rbp
  8019dd:	48 83 ec 20          	sub    $0x20,%rsp
  8019e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ef:	48 98                	cltq   
  8019f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f8:	00 
  8019f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a05:	48 89 d1             	mov    %rdx,%rcx
  801a08:	48 89 c2             	mov    %rax,%rdx
  801a0b:	be 01 00 00 00       	mov    $0x1,%esi
  801a10:	bf 06 00 00 00       	mov    $0x6,%edi
  801a15:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801a1c:	00 00 00 
  801a1f:	ff d0                	callq  *%rax
}
  801a21:	c9                   	leaveq 
  801a22:	c3                   	retq   

0000000000801a23 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a23:	55                   	push   %rbp
  801a24:	48 89 e5             	mov    %rsp,%rbp
  801a27:	48 83 ec 10          	sub    $0x10,%rsp
  801a2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a34:	48 63 d0             	movslq %eax,%rdx
  801a37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a3a:	48 98                	cltq   
  801a3c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a43:	00 
  801a44:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a50:	48 89 d1             	mov    %rdx,%rcx
  801a53:	48 89 c2             	mov    %rax,%rdx
  801a56:	be 01 00 00 00       	mov    $0x1,%esi
  801a5b:	bf 08 00 00 00       	mov    $0x8,%edi
  801a60:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801a67:	00 00 00 
  801a6a:	ff d0                	callq  *%rax
}
  801a6c:	c9                   	leaveq 
  801a6d:	c3                   	retq   

0000000000801a6e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a6e:	55                   	push   %rbp
  801a6f:	48 89 e5             	mov    %rsp,%rbp
  801a72:	48 83 ec 20          	sub    $0x20,%rsp
  801a76:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a79:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a7d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a84:	48 98                	cltq   
  801a86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8d:	00 
  801a8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9a:	48 89 d1             	mov    %rdx,%rcx
  801a9d:	48 89 c2             	mov    %rax,%rdx
  801aa0:	be 01 00 00 00       	mov    $0x1,%esi
  801aa5:	bf 09 00 00 00       	mov    $0x9,%edi
  801aaa:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 20          	sub    $0x20,%rsp
  801ac0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ac7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ace:	48 98                	cltq   
  801ad0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad7:	00 
  801ad8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ade:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae4:	48 89 d1             	mov    %rdx,%rcx
  801ae7:	48 89 c2             	mov    %rax,%rdx
  801aea:	be 01 00 00 00       	mov    $0x1,%esi
  801aef:	bf 0a 00 00 00       	mov    $0xa,%edi
  801af4:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801afb:	00 00 00 
  801afe:	ff d0                	callq  *%rax
}
  801b00:	c9                   	leaveq 
  801b01:	c3                   	retq   

0000000000801b02 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b02:	55                   	push   %rbp
  801b03:	48 89 e5             	mov    %rsp,%rbp
  801b06:	48 83 ec 20          	sub    $0x20,%rsp
  801b0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b11:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b15:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1b:	48 63 f0             	movslq %eax,%rsi
  801b1e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b25:	48 98                	cltq   
  801b27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b2b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b32:	00 
  801b33:	49 89 f1             	mov    %rsi,%r9
  801b36:	49 89 c8             	mov    %rcx,%r8
  801b39:	48 89 d1             	mov    %rdx,%rcx
  801b3c:	48 89 c2             	mov    %rax,%rdx
  801b3f:	be 00 00 00 00       	mov    $0x0,%esi
  801b44:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b49:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801b50:	00 00 00 
  801b53:	ff d0                	callq  *%rax
}
  801b55:	c9                   	leaveq 
  801b56:	c3                   	retq   

0000000000801b57 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b57:	55                   	push   %rbp
  801b58:	48 89 e5             	mov    %rsp,%rbp
  801b5b:	48 83 ec 10          	sub    $0x10,%rsp
  801b5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6e:	00 
  801b6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b80:	48 89 c2             	mov    %rax,%rdx
  801b83:	be 01 00 00 00       	mov    $0x1,%esi
  801b88:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b8d:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801b94:	00 00 00 
  801b97:	ff d0                	callq  *%rax
}
  801b99:	c9                   	leaveq 
  801b9a:	c3                   	retq   

0000000000801b9b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801b9b:	55                   	push   %rbp
  801b9c:	48 89 e5             	mov    %rsp,%rbp
  801b9f:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ba3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801baa:	00 
  801bab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bbc:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc1:	be 00 00 00 00       	mov    $0x0,%esi
  801bc6:	bf 0e 00 00 00       	mov    $0xe,%edi
  801bcb:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801bd2:	00 00 00 
  801bd5:	ff d0                	callq  *%rax
}
  801bd7:	c9                   	leaveq 
  801bd8:	c3                   	retq   

0000000000801bd9 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801bd9:	55                   	push   %rbp
  801bda:	48 89 e5             	mov    %rsp,%rbp
  801bdd:	48 83 ec 30          	sub    $0x30,%rsp
  801be1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801be4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801be8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801beb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bef:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801bf3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bf6:	48 63 c8             	movslq %eax,%rcx
  801bf9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bfd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c00:	48 63 f0             	movslq %eax,%rsi
  801c03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0a:	48 98                	cltq   
  801c0c:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c10:	49 89 f9             	mov    %rdi,%r9
  801c13:	49 89 f0             	mov    %rsi,%r8
  801c16:	48 89 d1             	mov    %rdx,%rcx
  801c19:	48 89 c2             	mov    %rax,%rdx
  801c1c:	be 00 00 00 00       	mov    $0x0,%esi
  801c21:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c26:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801c32:	c9                   	leaveq 
  801c33:	c3                   	retq   

0000000000801c34 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801c34:	55                   	push   %rbp
  801c35:	48 89 e5             	mov    %rsp,%rbp
  801c38:	48 83 ec 20          	sub    $0x20,%rsp
  801c3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801c44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c53:	00 
  801c54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c60:	48 89 d1             	mov    %rdx,%rcx
  801c63:	48 89 c2             	mov    %rax,%rdx
  801c66:	be 00 00 00 00       	mov    $0x0,%esi
  801c6b:	bf 10 00 00 00       	mov    $0x10,%edi
  801c70:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801c77:	00 00 00 
  801c7a:	ff d0                	callq  *%rax
}
  801c7c:	c9                   	leaveq 
  801c7d:	c3                   	retq   

0000000000801c7e <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801c7e:	55                   	push   %rbp
  801c7f:	48 89 e5             	mov    %rsp,%rbp
  801c82:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801c86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c8d:	00 
  801c8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca4:	be 00 00 00 00       	mov    $0x0,%esi
  801ca9:	bf 11 00 00 00       	mov    $0x11,%edi
  801cae:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801cb5:	00 00 00 
  801cb8:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801cba:	c9                   	leaveq 
  801cbb:	c3                   	retq   

0000000000801cbc <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801cbc:	55                   	push   %rbp
  801cbd:	48 89 e5             	mov    %rsp,%rbp
  801cc0:	48 83 ec 10          	sub    $0x10,%rsp
  801cc4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801cc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cca:	48 98                	cltq   
  801ccc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd3:	00 
  801cd4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cda:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ce5:	48 89 c2             	mov    %rax,%rdx
  801ce8:	be 00 00 00 00       	mov    $0x0,%esi
  801ced:	bf 12 00 00 00       	mov    $0x12,%edi
  801cf2:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801cf9:	00 00 00 
  801cfc:	ff d0                	callq  *%rax
}
  801cfe:	c9                   	leaveq 
  801cff:	c3                   	retq   

0000000000801d00 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801d00:	55                   	push   %rbp
  801d01:	48 89 e5             	mov    %rsp,%rbp
  801d04:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801d08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d0f:	00 
  801d10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d21:	ba 00 00 00 00       	mov    $0x0,%edx
  801d26:	be 00 00 00 00       	mov    $0x0,%esi
  801d2b:	bf 13 00 00 00       	mov    $0x13,%edi
  801d30:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801d37:	00 00 00 
  801d3a:	ff d0                	callq  *%rax
}
  801d3c:	c9                   	leaveq 
  801d3d:	c3                   	retq   

0000000000801d3e <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801d3e:	55                   	push   %rbp
  801d3f:	48 89 e5             	mov    %rsp,%rbp
  801d42:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801d46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4d:	00 
  801d4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d64:	be 00 00 00 00       	mov    $0x0,%esi
  801d69:	bf 14 00 00 00       	mov    $0x14,%edi
  801d6e:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801d75:	00 00 00 
  801d78:	ff d0                	callq  *%rax
}
  801d7a:	c9                   	leaveq 
  801d7b:	c3                   	retq   

0000000000801d7c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d7c:	55                   	push   %rbp
  801d7d:	48 89 e5             	mov    %rsp,%rbp
  801d80:	48 83 ec 08          	sub    $0x8,%rsp
  801d84:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d88:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d8c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d93:	ff ff ff 
  801d96:	48 01 d0             	add    %rdx,%rax
  801d99:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d9d:	c9                   	leaveq 
  801d9e:	c3                   	retq   

0000000000801d9f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d9f:	55                   	push   %rbp
  801da0:	48 89 e5             	mov    %rsp,%rbp
  801da3:	48 83 ec 08          	sub    $0x8,%rsp
  801da7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801dab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801daf:	48 89 c7             	mov    %rax,%rdi
  801db2:	48 b8 7c 1d 80 00 00 	movabs $0x801d7c,%rax
  801db9:	00 00 00 
  801dbc:	ff d0                	callq  *%rax
  801dbe:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801dc4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801dc8:	c9                   	leaveq 
  801dc9:	c3                   	retq   

0000000000801dca <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dca:	55                   	push   %rbp
  801dcb:	48 89 e5             	mov    %rsp,%rbp
  801dce:	48 83 ec 18          	sub    $0x18,%rsp
  801dd2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ddd:	eb 6b                	jmp    801e4a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de2:	48 98                	cltq   
  801de4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dea:	48 c1 e0 0c          	shl    $0xc,%rax
  801dee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df6:	48 c1 e8 15          	shr    $0x15,%rax
  801dfa:	48 89 c2             	mov    %rax,%rdx
  801dfd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e04:	01 00 00 
  801e07:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e0b:	83 e0 01             	and    $0x1,%eax
  801e0e:	48 85 c0             	test   %rax,%rax
  801e11:	74 21                	je     801e34 <fd_alloc+0x6a>
  801e13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e17:	48 c1 e8 0c          	shr    $0xc,%rax
  801e1b:	48 89 c2             	mov    %rax,%rdx
  801e1e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e25:	01 00 00 
  801e28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e2c:	83 e0 01             	and    $0x1,%eax
  801e2f:	48 85 c0             	test   %rax,%rax
  801e32:	75 12                	jne    801e46 <fd_alloc+0x7c>
			*fd_store = fd;
  801e34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e3c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e44:	eb 1a                	jmp    801e60 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e46:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e4a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e4e:	7e 8f                	jle    801ddf <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e54:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e5b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e60:	c9                   	leaveq 
  801e61:	c3                   	retq   

0000000000801e62 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e62:	55                   	push   %rbp
  801e63:	48 89 e5             	mov    %rsp,%rbp
  801e66:	48 83 ec 20          	sub    $0x20,%rsp
  801e6a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e6d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e71:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e75:	78 06                	js     801e7d <fd_lookup+0x1b>
  801e77:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e7b:	7e 07                	jle    801e84 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e82:	eb 6c                	jmp    801ef0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e84:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e87:	48 98                	cltq   
  801e89:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e8f:	48 c1 e0 0c          	shl    $0xc,%rax
  801e93:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e9b:	48 c1 e8 15          	shr    $0x15,%rax
  801e9f:	48 89 c2             	mov    %rax,%rdx
  801ea2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ea9:	01 00 00 
  801eac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb0:	83 e0 01             	and    $0x1,%eax
  801eb3:	48 85 c0             	test   %rax,%rax
  801eb6:	74 21                	je     801ed9 <fd_lookup+0x77>
  801eb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ebc:	48 c1 e8 0c          	shr    $0xc,%rax
  801ec0:	48 89 c2             	mov    %rax,%rdx
  801ec3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eca:	01 00 00 
  801ecd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed1:	83 e0 01             	and    $0x1,%eax
  801ed4:	48 85 c0             	test   %rax,%rax
  801ed7:	75 07                	jne    801ee0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ed9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ede:	eb 10                	jmp    801ef0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ee0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ee4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ee8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef0:	c9                   	leaveq 
  801ef1:	c3                   	retq   

0000000000801ef2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ef2:	55                   	push   %rbp
  801ef3:	48 89 e5             	mov    %rsp,%rbp
  801ef6:	48 83 ec 30          	sub    $0x30,%rsp
  801efa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801efe:	89 f0                	mov    %esi,%eax
  801f00:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f07:	48 89 c7             	mov    %rax,%rdi
  801f0a:	48 b8 7c 1d 80 00 00 	movabs $0x801d7c,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	callq  *%rax
  801f16:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f1a:	48 89 d6             	mov    %rdx,%rsi
  801f1d:	89 c7                	mov    %eax,%edi
  801f1f:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  801f26:	00 00 00 
  801f29:	ff d0                	callq  *%rax
  801f2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f32:	78 0a                	js     801f3e <fd_close+0x4c>
	    || fd != fd2)
  801f34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f38:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f3c:	74 12                	je     801f50 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f3e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f42:	74 05                	je     801f49 <fd_close+0x57>
  801f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f47:	eb 05                	jmp    801f4e <fd_close+0x5c>
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	eb 69                	jmp    801fb9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f54:	8b 00                	mov    (%rax),%eax
  801f56:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f5a:	48 89 d6             	mov    %rdx,%rsi
  801f5d:	89 c7                	mov    %eax,%edi
  801f5f:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
  801f6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f72:	78 2a                	js     801f9e <fd_close+0xac>
		if (dev->dev_close)
  801f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f78:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f7c:	48 85 c0             	test   %rax,%rax
  801f7f:	74 16                	je     801f97 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f85:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f89:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f8d:	48 89 d7             	mov    %rdx,%rdi
  801f90:	ff d0                	callq  *%rax
  801f92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f95:	eb 07                	jmp    801f9e <fd_close+0xac>
		else
			r = 0;
  801f97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa2:	48 89 c6             	mov    %rax,%rsi
  801fa5:	bf 00 00 00 00       	mov    $0x0,%edi
  801faa:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  801fb1:	00 00 00 
  801fb4:	ff d0                	callq  *%rax
	return r;
  801fb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fb9:	c9                   	leaveq 
  801fba:	c3                   	retq   

0000000000801fbb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fbb:	55                   	push   %rbp
  801fbc:	48 89 e5             	mov    %rsp,%rbp
  801fbf:	48 83 ec 20          	sub    $0x20,%rsp
  801fc3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fc6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fd1:	eb 41                	jmp    802014 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fd3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fda:	00 00 00 
  801fdd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fe0:	48 63 d2             	movslq %edx,%rdx
  801fe3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe7:	8b 00                	mov    (%rax),%eax
  801fe9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fec:	75 22                	jne    802010 <dev_lookup+0x55>
			*dev = devtab[i];
  801fee:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ff5:	00 00 00 
  801ff8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ffb:	48 63 d2             	movslq %edx,%rdx
  801ffe:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802002:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802006:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802009:	b8 00 00 00 00       	mov    $0x0,%eax
  80200e:	eb 60                	jmp    802070 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802010:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802014:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80201b:	00 00 00 
  80201e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802021:	48 63 d2             	movslq %edx,%rdx
  802024:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802028:	48 85 c0             	test   %rax,%rax
  80202b:	75 a6                	jne    801fd3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80202d:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802034:	00 00 00 
  802037:	48 8b 00             	mov    (%rax),%rax
  80203a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802040:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802043:	89 c6                	mov    %eax,%esi
  802045:	48 bf 08 42 80 00 00 	movabs $0x804208,%rdi
  80204c:	00 00 00 
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
  802054:	48 b9 f0 02 80 00 00 	movabs $0x8002f0,%rcx
  80205b:	00 00 00 
  80205e:	ff d1                	callq  *%rcx
	*dev = 0;
  802060:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802064:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80206b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802070:	c9                   	leaveq 
  802071:	c3                   	retq   

0000000000802072 <close>:

int
close(int fdnum)
{
  802072:	55                   	push   %rbp
  802073:	48 89 e5             	mov    %rsp,%rbp
  802076:	48 83 ec 20          	sub    $0x20,%rsp
  80207a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80207d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802081:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802084:	48 89 d6             	mov    %rdx,%rsi
  802087:	89 c7                	mov    %eax,%edi
  802089:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  802090:	00 00 00 
  802093:	ff d0                	callq  *%rax
  802095:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802098:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80209c:	79 05                	jns    8020a3 <close+0x31>
		return r;
  80209e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a1:	eb 18                	jmp    8020bb <close+0x49>
	else
		return fd_close(fd, 1);
  8020a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020a7:	be 01 00 00 00       	mov    $0x1,%esi
  8020ac:	48 89 c7             	mov    %rax,%rdi
  8020af:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  8020b6:	00 00 00 
  8020b9:	ff d0                	callq  *%rax
}
  8020bb:	c9                   	leaveq 
  8020bc:	c3                   	retq   

00000000008020bd <close_all>:

void
close_all(void)
{
  8020bd:	55                   	push   %rbp
  8020be:	48 89 e5             	mov    %rsp,%rbp
  8020c1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020cc:	eb 15                	jmp    8020e3 <close_all+0x26>
		close(i);
  8020ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d1:	89 c7                	mov    %eax,%edi
  8020d3:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  8020da:	00 00 00 
  8020dd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020df:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020e3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020e7:	7e e5                	jle    8020ce <close_all+0x11>
		close(i);
}
  8020e9:	c9                   	leaveq 
  8020ea:	c3                   	retq   

00000000008020eb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020eb:	55                   	push   %rbp
  8020ec:	48 89 e5             	mov    %rsp,%rbp
  8020ef:	48 83 ec 40          	sub    $0x40,%rsp
  8020f3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020f6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020f9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020fd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802100:	48 89 d6             	mov    %rdx,%rsi
  802103:	89 c7                	mov    %eax,%edi
  802105:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  80210c:	00 00 00 
  80210f:	ff d0                	callq  *%rax
  802111:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802114:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802118:	79 08                	jns    802122 <dup+0x37>
		return r;
  80211a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80211d:	e9 70 01 00 00       	jmpq   802292 <dup+0x1a7>
	close(newfdnum);
  802122:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802125:	89 c7                	mov    %eax,%edi
  802127:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  80212e:	00 00 00 
  802131:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802133:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802136:	48 98                	cltq   
  802138:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80213e:	48 c1 e0 0c          	shl    $0xc,%rax
  802142:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802146:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80214a:	48 89 c7             	mov    %rax,%rdi
  80214d:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  802154:	00 00 00 
  802157:	ff d0                	callq  *%rax
  802159:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80215d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802161:	48 89 c7             	mov    %rax,%rdi
  802164:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  80216b:	00 00 00 
  80216e:	ff d0                	callq  *%rax
  802170:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802178:	48 c1 e8 15          	shr    $0x15,%rax
  80217c:	48 89 c2             	mov    %rax,%rdx
  80217f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802186:	01 00 00 
  802189:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80218d:	83 e0 01             	and    $0x1,%eax
  802190:	48 85 c0             	test   %rax,%rax
  802193:	74 73                	je     802208 <dup+0x11d>
  802195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802199:	48 c1 e8 0c          	shr    $0xc,%rax
  80219d:	48 89 c2             	mov    %rax,%rdx
  8021a0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021a7:	01 00 00 
  8021aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ae:	83 e0 01             	and    $0x1,%eax
  8021b1:	48 85 c0             	test   %rax,%rax
  8021b4:	74 52                	je     802208 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ba:	48 c1 e8 0c          	shr    $0xc,%rax
  8021be:	48 89 c2             	mov    %rax,%rdx
  8021c1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021c8:	01 00 00 
  8021cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021cf:	25 07 0e 00 00       	and    $0xe07,%eax
  8021d4:	89 c1                	mov    %eax,%ecx
  8021d6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021de:	41 89 c8             	mov    %ecx,%r8d
  8021e1:	48 89 d1             	mov    %rdx,%rcx
  8021e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e9:	48 89 c6             	mov    %rax,%rsi
  8021ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f1:	48 b8 7e 19 80 00 00 	movabs $0x80197e,%rax
  8021f8:	00 00 00 
  8021fb:	ff d0                	callq  *%rax
  8021fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802200:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802204:	79 02                	jns    802208 <dup+0x11d>
			goto err;
  802206:	eb 57                	jmp    80225f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802208:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80220c:	48 c1 e8 0c          	shr    $0xc,%rax
  802210:	48 89 c2             	mov    %rax,%rdx
  802213:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80221a:	01 00 00 
  80221d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802221:	25 07 0e 00 00       	and    $0xe07,%eax
  802226:	89 c1                	mov    %eax,%ecx
  802228:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80222c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802230:	41 89 c8             	mov    %ecx,%r8d
  802233:	48 89 d1             	mov    %rdx,%rcx
  802236:	ba 00 00 00 00       	mov    $0x0,%edx
  80223b:	48 89 c6             	mov    %rax,%rsi
  80223e:	bf 00 00 00 00       	mov    $0x0,%edi
  802243:	48 b8 7e 19 80 00 00 	movabs $0x80197e,%rax
  80224a:	00 00 00 
  80224d:	ff d0                	callq  *%rax
  80224f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802256:	79 02                	jns    80225a <dup+0x16f>
		goto err;
  802258:	eb 05                	jmp    80225f <dup+0x174>

	return newfdnum;
  80225a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80225d:	eb 33                	jmp    802292 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80225f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802263:	48 89 c6             	mov    %rax,%rsi
  802266:	bf 00 00 00 00       	mov    $0x0,%edi
  80226b:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  802272:	00 00 00 
  802275:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802277:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80227b:	48 89 c6             	mov    %rax,%rsi
  80227e:	bf 00 00 00 00       	mov    $0x0,%edi
  802283:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  80228a:	00 00 00 
  80228d:	ff d0                	callq  *%rax
	return r;
  80228f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802292:	c9                   	leaveq 
  802293:	c3                   	retq   

0000000000802294 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802294:	55                   	push   %rbp
  802295:	48 89 e5             	mov    %rsp,%rbp
  802298:	48 83 ec 40          	sub    $0x40,%rsp
  80229c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80229f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022a3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022a7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022ab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022ae:	48 89 d6             	mov    %rdx,%rsi
  8022b1:	89 c7                	mov    %eax,%edi
  8022b3:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  8022ba:	00 00 00 
  8022bd:	ff d0                	callq  *%rax
  8022bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c6:	78 24                	js     8022ec <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cc:	8b 00                	mov    (%rax),%eax
  8022ce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022d2:	48 89 d6             	mov    %rdx,%rsi
  8022d5:	89 c7                	mov    %eax,%edi
  8022d7:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  8022de:	00 00 00 
  8022e1:	ff d0                	callq  *%rax
  8022e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ea:	79 05                	jns    8022f1 <read+0x5d>
		return r;
  8022ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ef:	eb 76                	jmp    802367 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f5:	8b 40 08             	mov    0x8(%rax),%eax
  8022f8:	83 e0 03             	and    $0x3,%eax
  8022fb:	83 f8 01             	cmp    $0x1,%eax
  8022fe:	75 3a                	jne    80233a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802300:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802307:	00 00 00 
  80230a:	48 8b 00             	mov    (%rax),%rax
  80230d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802313:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802316:	89 c6                	mov    %eax,%esi
  802318:	48 bf 27 42 80 00 00 	movabs $0x804227,%rdi
  80231f:	00 00 00 
  802322:	b8 00 00 00 00       	mov    $0x0,%eax
  802327:	48 b9 f0 02 80 00 00 	movabs $0x8002f0,%rcx
  80232e:	00 00 00 
  802331:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802333:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802338:	eb 2d                	jmp    802367 <read+0xd3>
	}
	if (!dev->dev_read)
  80233a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80233e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802342:	48 85 c0             	test   %rax,%rax
  802345:	75 07                	jne    80234e <read+0xba>
		return -E_NOT_SUPP;
  802347:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80234c:	eb 19                	jmp    802367 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80234e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802352:	48 8b 40 10          	mov    0x10(%rax),%rax
  802356:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80235a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80235e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802362:	48 89 cf             	mov    %rcx,%rdi
  802365:	ff d0                	callq  *%rax
}
  802367:	c9                   	leaveq 
  802368:	c3                   	retq   

0000000000802369 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802369:	55                   	push   %rbp
  80236a:	48 89 e5             	mov    %rsp,%rbp
  80236d:	48 83 ec 30          	sub    $0x30,%rsp
  802371:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802374:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802378:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80237c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802383:	eb 49                	jmp    8023ce <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802388:	48 98                	cltq   
  80238a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80238e:	48 29 c2             	sub    %rax,%rdx
  802391:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802394:	48 63 c8             	movslq %eax,%rcx
  802397:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80239b:	48 01 c1             	add    %rax,%rcx
  80239e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023a1:	48 89 ce             	mov    %rcx,%rsi
  8023a4:	89 c7                	mov    %eax,%edi
  8023a6:	48 b8 94 22 80 00 00 	movabs $0x802294,%rax
  8023ad:	00 00 00 
  8023b0:	ff d0                	callq  *%rax
  8023b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023b5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023b9:	79 05                	jns    8023c0 <readn+0x57>
			return m;
  8023bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023be:	eb 1c                	jmp    8023dc <readn+0x73>
		if (m == 0)
  8023c0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023c4:	75 02                	jne    8023c8 <readn+0x5f>
			break;
  8023c6:	eb 11                	jmp    8023d9 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023cb:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d1:	48 98                	cltq   
  8023d3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023d7:	72 ac                	jb     802385 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8023d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023dc:	c9                   	leaveq 
  8023dd:	c3                   	retq   

00000000008023de <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023de:	55                   	push   %rbp
  8023df:	48 89 e5             	mov    %rsp,%rbp
  8023e2:	48 83 ec 40          	sub    $0x40,%rsp
  8023e6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023ed:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023f1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023f8:	48 89 d6             	mov    %rdx,%rsi
  8023fb:	89 c7                	mov    %eax,%edi
  8023fd:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  802404:	00 00 00 
  802407:	ff d0                	callq  *%rax
  802409:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80240c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802410:	78 24                	js     802436 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802416:	8b 00                	mov    (%rax),%eax
  802418:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80241c:	48 89 d6             	mov    %rdx,%rsi
  80241f:	89 c7                	mov    %eax,%edi
  802421:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  802428:	00 00 00 
  80242b:	ff d0                	callq  *%rax
  80242d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802430:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802434:	79 05                	jns    80243b <write+0x5d>
		return r;
  802436:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802439:	eb 42                	jmp    80247d <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80243b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243f:	8b 40 08             	mov    0x8(%rax),%eax
  802442:	83 e0 03             	and    $0x3,%eax
  802445:	85 c0                	test   %eax,%eax
  802447:	75 07                	jne    802450 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802449:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80244e:	eb 2d                	jmp    80247d <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802450:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802454:	48 8b 40 18          	mov    0x18(%rax),%rax
  802458:	48 85 c0             	test   %rax,%rax
  80245b:	75 07                	jne    802464 <write+0x86>
		return -E_NOT_SUPP;
  80245d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802462:	eb 19                	jmp    80247d <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802464:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802468:	48 8b 40 18          	mov    0x18(%rax),%rax
  80246c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802470:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802474:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802478:	48 89 cf             	mov    %rcx,%rdi
  80247b:	ff d0                	callq  *%rax
}
  80247d:	c9                   	leaveq 
  80247e:	c3                   	retq   

000000000080247f <seek>:

int
seek(int fdnum, off_t offset)
{
  80247f:	55                   	push   %rbp
  802480:	48 89 e5             	mov    %rsp,%rbp
  802483:	48 83 ec 18          	sub    $0x18,%rsp
  802487:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80248a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80248d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802491:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802494:	48 89 d6             	mov    %rdx,%rsi
  802497:	89 c7                	mov    %eax,%edi
  802499:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  8024a0:	00 00 00 
  8024a3:	ff d0                	callq  *%rax
  8024a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ac:	79 05                	jns    8024b3 <seek+0x34>
		return r;
  8024ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b1:	eb 0f                	jmp    8024c2 <seek+0x43>
	fd->fd_offset = offset;
  8024b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024ba:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c2:	c9                   	leaveq 
  8024c3:	c3                   	retq   

00000000008024c4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024c4:	55                   	push   %rbp
  8024c5:	48 89 e5             	mov    %rsp,%rbp
  8024c8:	48 83 ec 30          	sub    $0x30,%rsp
  8024cc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024cf:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024d2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024d6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024d9:	48 89 d6             	mov    %rdx,%rsi
  8024dc:	89 c7                	mov    %eax,%edi
  8024de:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  8024e5:	00 00 00 
  8024e8:	ff d0                	callq  *%rax
  8024ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f1:	78 24                	js     802517 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f7:	8b 00                	mov    (%rax),%eax
  8024f9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024fd:	48 89 d6             	mov    %rdx,%rsi
  802500:	89 c7                	mov    %eax,%edi
  802502:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  802509:	00 00 00 
  80250c:	ff d0                	callq  *%rax
  80250e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802515:	79 05                	jns    80251c <ftruncate+0x58>
		return r;
  802517:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251a:	eb 72                	jmp    80258e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80251c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802520:	8b 40 08             	mov    0x8(%rax),%eax
  802523:	83 e0 03             	and    $0x3,%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	75 3a                	jne    802564 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80252a:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802531:	00 00 00 
  802534:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802537:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80253d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802540:	89 c6                	mov    %eax,%esi
  802542:	48 bf 48 42 80 00 00 	movabs $0x804248,%rdi
  802549:	00 00 00 
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
  802551:	48 b9 f0 02 80 00 00 	movabs $0x8002f0,%rcx
  802558:	00 00 00 
  80255b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80255d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802562:	eb 2a                	jmp    80258e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802568:	48 8b 40 30          	mov    0x30(%rax),%rax
  80256c:	48 85 c0             	test   %rax,%rax
  80256f:	75 07                	jne    802578 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802571:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802576:	eb 16                	jmp    80258e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802580:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802584:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802587:	89 ce                	mov    %ecx,%esi
  802589:	48 89 d7             	mov    %rdx,%rdi
  80258c:	ff d0                	callq  *%rax
}
  80258e:	c9                   	leaveq 
  80258f:	c3                   	retq   

0000000000802590 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802590:	55                   	push   %rbp
  802591:	48 89 e5             	mov    %rsp,%rbp
  802594:	48 83 ec 30          	sub    $0x30,%rsp
  802598:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80259b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80259f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025a3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025a6:	48 89 d6             	mov    %rdx,%rsi
  8025a9:	89 c7                	mov    %eax,%edi
  8025ab:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  8025b2:	00 00 00 
  8025b5:	ff d0                	callq  *%rax
  8025b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025be:	78 24                	js     8025e4 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c4:	8b 00                	mov    (%rax),%eax
  8025c6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025ca:	48 89 d6             	mov    %rdx,%rsi
  8025cd:	89 c7                	mov    %eax,%edi
  8025cf:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  8025d6:	00 00 00 
  8025d9:	ff d0                	callq  *%rax
  8025db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e2:	79 05                	jns    8025e9 <fstat+0x59>
		return r;
  8025e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e7:	eb 5e                	jmp    802647 <fstat+0xb7>
	if (!dev->dev_stat)
  8025e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ed:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025f1:	48 85 c0             	test   %rax,%rax
  8025f4:	75 07                	jne    8025fd <fstat+0x6d>
		return -E_NOT_SUPP;
  8025f6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025fb:	eb 4a                	jmp    802647 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802601:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802604:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802608:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80260f:	00 00 00 
	stat->st_isdir = 0;
  802612:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802616:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80261d:	00 00 00 
	stat->st_dev = dev;
  802620:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802624:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802628:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80262f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802633:	48 8b 40 28          	mov    0x28(%rax),%rax
  802637:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80263b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80263f:	48 89 ce             	mov    %rcx,%rsi
  802642:	48 89 d7             	mov    %rdx,%rdi
  802645:	ff d0                	callq  *%rax
}
  802647:	c9                   	leaveq 
  802648:	c3                   	retq   

0000000000802649 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802649:	55                   	push   %rbp
  80264a:	48 89 e5             	mov    %rsp,%rbp
  80264d:	48 83 ec 20          	sub    $0x20,%rsp
  802651:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802655:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265d:	be 00 00 00 00       	mov    $0x0,%esi
  802662:	48 89 c7             	mov    %rax,%rdi
  802665:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  80266c:	00 00 00 
  80266f:	ff d0                	callq  *%rax
  802671:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802674:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802678:	79 05                	jns    80267f <stat+0x36>
		return fd;
  80267a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267d:	eb 2f                	jmp    8026ae <stat+0x65>
	r = fstat(fd, stat);
  80267f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802683:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802686:	48 89 d6             	mov    %rdx,%rsi
  802689:	89 c7                	mov    %eax,%edi
  80268b:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  802692:	00 00 00 
  802695:	ff d0                	callq  *%rax
  802697:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80269a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269d:	89 c7                	mov    %eax,%edi
  80269f:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  8026a6:	00 00 00 
  8026a9:	ff d0                	callq  *%rax
	return r;
  8026ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026ae:	c9                   	leaveq 
  8026af:	c3                   	retq   

00000000008026b0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026b0:	55                   	push   %rbp
  8026b1:	48 89 e5             	mov    %rsp,%rbp
  8026b4:	48 83 ec 10          	sub    $0x10,%rsp
  8026b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026bf:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  8026c6:	00 00 00 
  8026c9:	8b 00                	mov    (%rax),%eax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	75 1d                	jne    8026ec <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026cf:	bf 01 00 00 00       	mov    $0x1,%edi
  8026d4:	48 b8 67 3b 80 00 00 	movabs $0x803b67,%rax
  8026db:	00 00 00 
  8026de:	ff d0                	callq  *%rax
  8026e0:	48 ba 00 74 80 00 00 	movabs $0x807400,%rdx
  8026e7:	00 00 00 
  8026ea:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026ec:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  8026f3:	00 00 00 
  8026f6:	8b 00                	mov    (%rax),%eax
  8026f8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026fb:	b9 07 00 00 00       	mov    $0x7,%ecx
  802700:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802707:	00 00 00 
  80270a:	89 c7                	mov    %eax,%edi
  80270c:	48 b8 df 3a 80 00 00 	movabs $0x803adf,%rax
  802713:	00 00 00 
  802716:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802718:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271c:	ba 00 00 00 00       	mov    $0x0,%edx
  802721:	48 89 c6             	mov    %rax,%rsi
  802724:	bf 00 00 00 00       	mov    $0x0,%edi
  802729:	48 b8 e1 39 80 00 00 	movabs $0x8039e1,%rax
  802730:	00 00 00 
  802733:	ff d0                	callq  *%rax
}
  802735:	c9                   	leaveq 
  802736:	c3                   	retq   

0000000000802737 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802737:	55                   	push   %rbp
  802738:	48 89 e5             	mov    %rsp,%rbp
  80273b:	48 83 ec 30          	sub    $0x30,%rsp
  80273f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802743:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802746:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80274d:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802754:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80275b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802760:	75 08                	jne    80276a <open+0x33>
	{
		return r;
  802762:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802765:	e9 f2 00 00 00       	jmpq   80285c <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80276a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276e:	48 89 c7             	mov    %rax,%rdi
  802771:	48 b8 93 0f 80 00 00 	movabs $0x800f93,%rax
  802778:	00 00 00 
  80277b:	ff d0                	callq  *%rax
  80277d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802780:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802787:	7e 0a                	jle    802793 <open+0x5c>
	{
		return -E_BAD_PATH;
  802789:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80278e:	e9 c9 00 00 00       	jmpq   80285c <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802793:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80279a:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80279b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80279f:	48 89 c7             	mov    %rax,%rdi
  8027a2:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
  8027ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b5:	78 09                	js     8027c0 <open+0x89>
  8027b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bb:	48 85 c0             	test   %rax,%rax
  8027be:	75 08                	jne    8027c8 <open+0x91>
		{
			return r;
  8027c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c3:	e9 94 00 00 00       	jmpq   80285c <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8027c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027cc:	ba 00 04 00 00       	mov    $0x400,%edx
  8027d1:	48 89 c6             	mov    %rax,%rsi
  8027d4:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8027db:	00 00 00 
  8027de:	48 b8 91 10 80 00 00 	movabs $0x801091,%rax
  8027e5:	00 00 00 
  8027e8:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8027ea:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027f1:	00 00 00 
  8027f4:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027f7:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8027fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802801:	48 89 c6             	mov    %rax,%rsi
  802804:	bf 01 00 00 00       	mov    $0x1,%edi
  802809:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  802810:	00 00 00 
  802813:	ff d0                	callq  *%rax
  802815:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802818:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281c:	79 2b                	jns    802849 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80281e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802822:	be 00 00 00 00       	mov    $0x0,%esi
  802827:	48 89 c7             	mov    %rax,%rdi
  80282a:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  802831:	00 00 00 
  802834:	ff d0                	callq  *%rax
  802836:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802839:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80283d:	79 05                	jns    802844 <open+0x10d>
			{
				return d;
  80283f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802842:	eb 18                	jmp    80285c <open+0x125>
			}
			return r;
  802844:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802847:	eb 13                	jmp    80285c <open+0x125>
		}	
		return fd2num(fd_store);
  802849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284d:	48 89 c7             	mov    %rax,%rdi
  802850:	48 b8 7c 1d 80 00 00 	movabs $0x801d7c,%rax
  802857:	00 00 00 
  80285a:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80285c:	c9                   	leaveq 
  80285d:	c3                   	retq   

000000000080285e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80285e:	55                   	push   %rbp
  80285f:	48 89 e5             	mov    %rsp,%rbp
  802862:	48 83 ec 10          	sub    $0x10,%rsp
  802866:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80286a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80286e:	8b 50 0c             	mov    0xc(%rax),%edx
  802871:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802878:	00 00 00 
  80287b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80287d:	be 00 00 00 00       	mov    $0x0,%esi
  802882:	bf 06 00 00 00       	mov    $0x6,%edi
  802887:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  80288e:	00 00 00 
  802891:	ff d0                	callq  *%rax
}
  802893:	c9                   	leaveq 
  802894:	c3                   	retq   

0000000000802895 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802895:	55                   	push   %rbp
  802896:	48 89 e5             	mov    %rsp,%rbp
  802899:	48 83 ec 30          	sub    $0x30,%rsp
  80289d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8028a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8028b0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028b5:	74 07                	je     8028be <devfile_read+0x29>
  8028b7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028bc:	75 07                	jne    8028c5 <devfile_read+0x30>
		return -E_INVAL;
  8028be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028c3:	eb 77                	jmp    80293c <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c9:	8b 50 0c             	mov    0xc(%rax),%edx
  8028cc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028d3:	00 00 00 
  8028d6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028d8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028df:	00 00 00 
  8028e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028e6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8028ea:	be 00 00 00 00       	mov    $0x0,%esi
  8028ef:	bf 03 00 00 00       	mov    $0x3,%edi
  8028f4:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  8028fb:	00 00 00 
  8028fe:	ff d0                	callq  *%rax
  802900:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802903:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802907:	7f 05                	jg     80290e <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802909:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290c:	eb 2e                	jmp    80293c <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80290e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802911:	48 63 d0             	movslq %eax,%rdx
  802914:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802918:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80291f:	00 00 00 
  802922:	48 89 c7             	mov    %rax,%rdi
  802925:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  80292c:	00 00 00 
  80292f:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802931:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802935:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802939:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80293c:	c9                   	leaveq 
  80293d:	c3                   	retq   

000000000080293e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80293e:	55                   	push   %rbp
  80293f:	48 89 e5             	mov    %rsp,%rbp
  802942:	48 83 ec 30          	sub    $0x30,%rsp
  802946:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80294a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80294e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802952:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802959:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80295e:	74 07                	je     802967 <devfile_write+0x29>
  802960:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802965:	75 08                	jne    80296f <devfile_write+0x31>
		return r;
  802967:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296a:	e9 9a 00 00 00       	jmpq   802a09 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80296f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802973:	8b 50 0c             	mov    0xc(%rax),%edx
  802976:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80297d:	00 00 00 
  802980:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802982:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802989:	00 
  80298a:	76 08                	jbe    802994 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80298c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802993:	00 
	}
	fsipcbuf.write.req_n = n;
  802994:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80299b:	00 00 00 
  80299e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029a2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8029a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ae:	48 89 c6             	mov    %rax,%rsi
  8029b1:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8029b8:	00 00 00 
  8029bb:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  8029c2:	00 00 00 
  8029c5:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8029c7:	be 00 00 00 00       	mov    $0x0,%esi
  8029cc:	bf 04 00 00 00       	mov    $0x4,%edi
  8029d1:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  8029d8:	00 00 00 
  8029db:	ff d0                	callq  *%rax
  8029dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e4:	7f 20                	jg     802a06 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8029e6:	48 bf 6e 42 80 00 00 	movabs $0x80426e,%rdi
  8029ed:	00 00 00 
  8029f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f5:	48 ba f0 02 80 00 00 	movabs $0x8002f0,%rdx
  8029fc:	00 00 00 
  8029ff:	ff d2                	callq  *%rdx
		return r;
  802a01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a04:	eb 03                	jmp    802a09 <devfile_write+0xcb>
	}
	return r;
  802a06:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a09:	c9                   	leaveq 
  802a0a:	c3                   	retq   

0000000000802a0b <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a0b:	55                   	push   %rbp
  802a0c:	48 89 e5             	mov    %rsp,%rbp
  802a0f:	48 83 ec 20          	sub    $0x20,%rsp
  802a13:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a17:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1f:	8b 50 0c             	mov    0xc(%rax),%edx
  802a22:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a29:	00 00 00 
  802a2c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a2e:	be 00 00 00 00       	mov    $0x0,%esi
  802a33:	bf 05 00 00 00       	mov    $0x5,%edi
  802a38:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  802a3f:	00 00 00 
  802a42:	ff d0                	callq  *%rax
  802a44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4b:	79 05                	jns    802a52 <devfile_stat+0x47>
		return r;
  802a4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a50:	eb 56                	jmp    802aa8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a56:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a5d:	00 00 00 
  802a60:	48 89 c7             	mov    %rax,%rdi
  802a63:	48 b8 ff 0f 80 00 00 	movabs $0x800fff,%rax
  802a6a:	00 00 00 
  802a6d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a6f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a76:	00 00 00 
  802a79:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a83:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a89:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a90:	00 00 00 
  802a93:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a9d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aa8:	c9                   	leaveq 
  802aa9:	c3                   	retq   

0000000000802aaa <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802aaa:	55                   	push   %rbp
  802aab:	48 89 e5             	mov    %rsp,%rbp
  802aae:	48 83 ec 10          	sub    $0x10,%rsp
  802ab2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ab6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ab9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802abd:	8b 50 0c             	mov    0xc(%rax),%edx
  802ac0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ac7:	00 00 00 
  802aca:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802acc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ad3:	00 00 00 
  802ad6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ad9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802adc:	be 00 00 00 00       	mov    $0x0,%esi
  802ae1:	bf 02 00 00 00       	mov    $0x2,%edi
  802ae6:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	callq  *%rax
}
  802af2:	c9                   	leaveq 
  802af3:	c3                   	retq   

0000000000802af4 <remove>:

// Delete a file
int
remove(const char *path)
{
  802af4:	55                   	push   %rbp
  802af5:	48 89 e5             	mov    %rsp,%rbp
  802af8:	48 83 ec 10          	sub    $0x10,%rsp
  802afc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b04:	48 89 c7             	mov    %rax,%rdi
  802b07:	48 b8 93 0f 80 00 00 	movabs $0x800f93,%rax
  802b0e:	00 00 00 
  802b11:	ff d0                	callq  *%rax
  802b13:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b18:	7e 07                	jle    802b21 <remove+0x2d>
		return -E_BAD_PATH;
  802b1a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b1f:	eb 33                	jmp    802b54 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b25:	48 89 c6             	mov    %rax,%rsi
  802b28:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b2f:	00 00 00 
  802b32:	48 b8 ff 0f 80 00 00 	movabs $0x800fff,%rax
  802b39:	00 00 00 
  802b3c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b3e:	be 00 00 00 00       	mov    $0x0,%esi
  802b43:	bf 07 00 00 00       	mov    $0x7,%edi
  802b48:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
}
  802b54:	c9                   	leaveq 
  802b55:	c3                   	retq   

0000000000802b56 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b56:	55                   	push   %rbp
  802b57:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b5a:	be 00 00 00 00       	mov    $0x0,%esi
  802b5f:	bf 08 00 00 00       	mov    $0x8,%edi
  802b64:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  802b6b:	00 00 00 
  802b6e:	ff d0                	callq  *%rax
}
  802b70:	5d                   	pop    %rbp
  802b71:	c3                   	retq   

0000000000802b72 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b72:	55                   	push   %rbp
  802b73:	48 89 e5             	mov    %rsp,%rbp
  802b76:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b7d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b84:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b8b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b92:	be 00 00 00 00       	mov    $0x0,%esi
  802b97:	48 89 c7             	mov    %rax,%rdi
  802b9a:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  802ba1:	00 00 00 
  802ba4:	ff d0                	callq  *%rax
  802ba6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ba9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bad:	79 28                	jns    802bd7 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb2:	89 c6                	mov    %eax,%esi
  802bb4:	48 bf 8a 42 80 00 00 	movabs $0x80428a,%rdi
  802bbb:	00 00 00 
  802bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc3:	48 ba f0 02 80 00 00 	movabs $0x8002f0,%rdx
  802bca:	00 00 00 
  802bcd:	ff d2                	callq  *%rdx
		return fd_src;
  802bcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd2:	e9 74 01 00 00       	jmpq   802d4b <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bd7:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802bde:	be 01 01 00 00       	mov    $0x101,%esi
  802be3:	48 89 c7             	mov    %rax,%rdi
  802be6:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  802bed:	00 00 00 
  802bf0:	ff d0                	callq  *%rax
  802bf2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bf5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bf9:	79 39                	jns    802c34 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bfb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bfe:	89 c6                	mov    %eax,%esi
  802c00:	48 bf a0 42 80 00 00 	movabs $0x8042a0,%rdi
  802c07:	00 00 00 
  802c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0f:	48 ba f0 02 80 00 00 	movabs $0x8002f0,%rdx
  802c16:	00 00 00 
  802c19:	ff d2                	callq  *%rdx
		close(fd_src);
  802c1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1e:	89 c7                	mov    %eax,%edi
  802c20:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  802c27:	00 00 00 
  802c2a:	ff d0                	callq  *%rax
		return fd_dest;
  802c2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c2f:	e9 17 01 00 00       	jmpq   802d4b <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c34:	eb 74                	jmp    802caa <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c36:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c39:	48 63 d0             	movslq %eax,%rdx
  802c3c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c46:	48 89 ce             	mov    %rcx,%rsi
  802c49:	89 c7                	mov    %eax,%edi
  802c4b:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  802c52:	00 00 00 
  802c55:	ff d0                	callq  *%rax
  802c57:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c5e:	79 4a                	jns    802caa <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c60:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c63:	89 c6                	mov    %eax,%esi
  802c65:	48 bf ba 42 80 00 00 	movabs $0x8042ba,%rdi
  802c6c:	00 00 00 
  802c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c74:	48 ba f0 02 80 00 00 	movabs $0x8002f0,%rdx
  802c7b:	00 00 00 
  802c7e:	ff d2                	callq  *%rdx
			close(fd_src);
  802c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c83:	89 c7                	mov    %eax,%edi
  802c85:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  802c8c:	00 00 00 
  802c8f:	ff d0                	callq  *%rax
			close(fd_dest);
  802c91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c94:	89 c7                	mov    %eax,%edi
  802c96:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  802c9d:	00 00 00 
  802ca0:	ff d0                	callq  *%rax
			return write_size;
  802ca2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ca5:	e9 a1 00 00 00       	jmpq   802d4b <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802caa:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb4:	ba 00 02 00 00       	mov    $0x200,%edx
  802cb9:	48 89 ce             	mov    %rcx,%rsi
  802cbc:	89 c7                	mov    %eax,%edi
  802cbe:	48 b8 94 22 80 00 00 	movabs $0x802294,%rax
  802cc5:	00 00 00 
  802cc8:	ff d0                	callq  *%rax
  802cca:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cd1:	0f 8f 5f ff ff ff    	jg     802c36 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802cd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cdb:	79 47                	jns    802d24 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802cdd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ce0:	89 c6                	mov    %eax,%esi
  802ce2:	48 bf cd 42 80 00 00 	movabs $0x8042cd,%rdi
  802ce9:	00 00 00 
  802cec:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf1:	48 ba f0 02 80 00 00 	movabs $0x8002f0,%rdx
  802cf8:	00 00 00 
  802cfb:	ff d2                	callq  *%rdx
		close(fd_src);
  802cfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d00:	89 c7                	mov    %eax,%edi
  802d02:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  802d09:	00 00 00 
  802d0c:	ff d0                	callq  *%rax
		close(fd_dest);
  802d0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d11:	89 c7                	mov    %eax,%edi
  802d13:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  802d1a:	00 00 00 
  802d1d:	ff d0                	callq  *%rax
		return read_size;
  802d1f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d22:	eb 27                	jmp    802d4b <copy+0x1d9>
	}
	close(fd_src);
  802d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
	close(fd_dest);
  802d35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d38:	89 c7                	mov    %eax,%edi
  802d3a:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  802d41:	00 00 00 
  802d44:	ff d0                	callq  *%rax
	return 0;
  802d46:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d4b:	c9                   	leaveq 
  802d4c:	c3                   	retq   

0000000000802d4d <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802d4d:	55                   	push   %rbp
  802d4e:	48 89 e5             	mov    %rsp,%rbp
  802d51:	48 83 ec 20          	sub    $0x20,%rsp
  802d55:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802d59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5d:	8b 40 0c             	mov    0xc(%rax),%eax
  802d60:	85 c0                	test   %eax,%eax
  802d62:	7e 67                	jle    802dcb <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d68:	8b 40 04             	mov    0x4(%rax),%eax
  802d6b:	48 63 d0             	movslq %eax,%rdx
  802d6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d72:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7a:	8b 00                	mov    (%rax),%eax
  802d7c:	48 89 ce             	mov    %rcx,%rsi
  802d7f:	89 c7                	mov    %eax,%edi
  802d81:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  802d88:	00 00 00 
  802d8b:	ff d0                	callq  *%rax
  802d8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802d90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d94:	7e 13                	jle    802da9 <writebuf+0x5c>
			b->result += result;
  802d96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9a:	8b 50 08             	mov    0x8(%rax),%edx
  802d9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da0:	01 c2                	add    %eax,%edx
  802da2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da6:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802da9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dad:	8b 40 04             	mov    0x4(%rax),%eax
  802db0:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802db3:	74 16                	je     802dcb <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802db5:	b8 00 00 00 00       	mov    $0x0,%eax
  802dba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbe:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802dc2:	89 c2                	mov    %eax,%edx
  802dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc8:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802dcb:	c9                   	leaveq 
  802dcc:	c3                   	retq   

0000000000802dcd <putch>:

static void
putch(int ch, void *thunk)
{
  802dcd:	55                   	push   %rbp
  802dce:	48 89 e5             	mov    %rsp,%rbp
  802dd1:	48 83 ec 20          	sub    $0x20,%rsp
  802dd5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dd8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802ddc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802de0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802de4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de8:	8b 40 04             	mov    0x4(%rax),%eax
  802deb:	8d 48 01             	lea    0x1(%rax),%ecx
  802dee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802df2:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802df5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802df8:	89 d1                	mov    %edx,%ecx
  802dfa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802dfe:	48 98                	cltq   
  802e00:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802e04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e08:	8b 40 04             	mov    0x4(%rax),%eax
  802e0b:	3d 00 01 00 00       	cmp    $0x100,%eax
  802e10:	75 1e                	jne    802e30 <putch+0x63>
		writebuf(b);
  802e12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e16:	48 89 c7             	mov    %rax,%rdi
  802e19:	48 b8 4d 2d 80 00 00 	movabs $0x802d4d,%rax
  802e20:	00 00 00 
  802e23:	ff d0                	callq  *%rax
		b->idx = 0;
  802e25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802e30:	c9                   	leaveq 
  802e31:	c3                   	retq   

0000000000802e32 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802e32:	55                   	push   %rbp
  802e33:	48 89 e5             	mov    %rsp,%rbp
  802e36:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802e3d:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802e43:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802e4a:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802e51:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802e57:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802e5d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802e64:	00 00 00 
	b.result = 0;
  802e67:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802e6e:	00 00 00 
	b.error = 1;
  802e71:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802e78:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802e7b:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802e82:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802e89:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802e90:	48 89 c6             	mov    %rax,%rsi
  802e93:	48 bf cd 2d 80 00 00 	movabs $0x802dcd,%rdi
  802e9a:	00 00 00 
  802e9d:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  802ea4:	00 00 00 
  802ea7:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802ea9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802eaf:	85 c0                	test   %eax,%eax
  802eb1:	7e 16                	jle    802ec9 <vfprintf+0x97>
		writebuf(&b);
  802eb3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802eba:	48 89 c7             	mov    %rax,%rdi
  802ebd:	48 b8 4d 2d 80 00 00 	movabs $0x802d4d,%rax
  802ec4:	00 00 00 
  802ec7:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802ec9:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 08                	je     802edb <vfprintf+0xa9>
  802ed3:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ed9:	eb 06                	jmp    802ee1 <vfprintf+0xaf>
  802edb:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802ee1:	c9                   	leaveq 
  802ee2:	c3                   	retq   

0000000000802ee3 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802ee3:	55                   	push   %rbp
  802ee4:	48 89 e5             	mov    %rsp,%rbp
  802ee7:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802eee:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802ef4:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802efb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f02:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f09:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f10:	84 c0                	test   %al,%al
  802f12:	74 20                	je     802f34 <fprintf+0x51>
  802f14:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802f18:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802f1c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802f20:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802f24:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f28:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f2c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f30:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f34:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802f3b:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802f42:	00 00 00 
  802f45:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f4c:	00 00 00 
  802f4f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f53:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802f5a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f61:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802f68:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f6f:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802f76:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802f7c:	48 89 ce             	mov    %rcx,%rsi
  802f7f:	89 c7                	mov    %eax,%edi
  802f81:	48 b8 32 2e 80 00 00 	movabs $0x802e32,%rax
  802f88:	00 00 00 
  802f8b:	ff d0                	callq  *%rax
  802f8d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802f93:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802f99:	c9                   	leaveq 
  802f9a:	c3                   	retq   

0000000000802f9b <printf>:

int
printf(const char *fmt, ...)
{
  802f9b:	55                   	push   %rbp
  802f9c:	48 89 e5             	mov    %rsp,%rbp
  802f9f:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802fa6:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802fad:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802fb4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fbb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fc2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fc9:	84 c0                	test   %al,%al
  802fcb:	74 20                	je     802fed <printf+0x52>
  802fcd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fd1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802fd5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fd9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fdd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802fe1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802fe5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802fe9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802fed:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802ff4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802ffb:	00 00 00 
  802ffe:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803005:	00 00 00 
  803008:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80300c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803013:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80301a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803021:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803028:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80302f:	48 89 c6             	mov    %rax,%rsi
  803032:	bf 01 00 00 00       	mov    $0x1,%edi
  803037:	48 b8 32 2e 80 00 00 	movabs $0x802e32,%rax
  80303e:	00 00 00 
  803041:	ff d0                	callq  *%rax
  803043:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803049:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80304f:	c9                   	leaveq 
  803050:	c3                   	retq   

0000000000803051 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803051:	55                   	push   %rbp
  803052:	48 89 e5             	mov    %rsp,%rbp
  803055:	53                   	push   %rbx
  803056:	48 83 ec 38          	sub    $0x38,%rsp
  80305a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80305e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803062:	48 89 c7             	mov    %rax,%rdi
  803065:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  80306c:	00 00 00 
  80306f:	ff d0                	callq  *%rax
  803071:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803074:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803078:	0f 88 bf 01 00 00    	js     80323d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80307e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803082:	ba 07 04 00 00       	mov    $0x407,%edx
  803087:	48 89 c6             	mov    %rax,%rsi
  80308a:	bf 00 00 00 00       	mov    $0x0,%edi
  80308f:	48 b8 2e 19 80 00 00 	movabs $0x80192e,%rax
  803096:	00 00 00 
  803099:	ff d0                	callq  *%rax
  80309b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80309e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030a2:	0f 88 95 01 00 00    	js     80323d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8030a8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8030ac:	48 89 c7             	mov    %rax,%rdi
  8030af:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  8030b6:	00 00 00 
  8030b9:	ff d0                	callq  *%rax
  8030bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030c2:	0f 88 5d 01 00 00    	js     803225 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030cc:	ba 07 04 00 00       	mov    $0x407,%edx
  8030d1:	48 89 c6             	mov    %rax,%rsi
  8030d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8030d9:	48 b8 2e 19 80 00 00 	movabs $0x80192e,%rax
  8030e0:	00 00 00 
  8030e3:	ff d0                	callq  *%rax
  8030e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030ec:	0f 88 33 01 00 00    	js     803225 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8030f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030f6:	48 89 c7             	mov    %rax,%rdi
  8030f9:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  803100:	00 00 00 
  803103:	ff d0                	callq  *%rax
  803105:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80310d:	ba 07 04 00 00       	mov    $0x407,%edx
  803112:	48 89 c6             	mov    %rax,%rsi
  803115:	bf 00 00 00 00       	mov    $0x0,%edi
  80311a:	48 b8 2e 19 80 00 00 	movabs $0x80192e,%rax
  803121:	00 00 00 
  803124:	ff d0                	callq  *%rax
  803126:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803129:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80312d:	79 05                	jns    803134 <pipe+0xe3>
		goto err2;
  80312f:	e9 d9 00 00 00       	jmpq   80320d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803134:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803138:	48 89 c7             	mov    %rax,%rdi
  80313b:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
  803147:	48 89 c2             	mov    %rax,%rdx
  80314a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803154:	48 89 d1             	mov    %rdx,%rcx
  803157:	ba 00 00 00 00       	mov    $0x0,%edx
  80315c:	48 89 c6             	mov    %rax,%rsi
  80315f:	bf 00 00 00 00       	mov    $0x0,%edi
  803164:	48 b8 7e 19 80 00 00 	movabs $0x80197e,%rax
  80316b:	00 00 00 
  80316e:	ff d0                	callq  *%rax
  803170:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803173:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803177:	79 1b                	jns    803194 <pipe+0x143>
		goto err3;
  803179:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80317a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317e:	48 89 c6             	mov    %rax,%rsi
  803181:	bf 00 00 00 00       	mov    $0x0,%edi
  803186:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  80318d:	00 00 00 
  803190:	ff d0                	callq  *%rax
  803192:	eb 79                	jmp    80320d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803194:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803198:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80319f:	00 00 00 
  8031a2:	8b 12                	mov    (%rdx),%edx
  8031a4:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8031a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8031b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031b5:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8031bc:	00 00 00 
  8031bf:	8b 12                	mov    (%rdx),%edx
  8031c1:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8031c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8031ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d2:	48 89 c7             	mov    %rax,%rdi
  8031d5:	48 b8 7c 1d 80 00 00 	movabs $0x801d7c,%rax
  8031dc:	00 00 00 
  8031df:	ff d0                	callq  *%rax
  8031e1:	89 c2                	mov    %eax,%edx
  8031e3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031e7:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8031e9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031ed:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8031f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031f5:	48 89 c7             	mov    %rax,%rdi
  8031f8:	48 b8 7c 1d 80 00 00 	movabs $0x801d7c,%rax
  8031ff:	00 00 00 
  803202:	ff d0                	callq  *%rax
  803204:	89 03                	mov    %eax,(%rbx)
	return 0;
  803206:	b8 00 00 00 00       	mov    $0x0,%eax
  80320b:	eb 33                	jmp    803240 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80320d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803211:	48 89 c6             	mov    %rax,%rsi
  803214:	bf 00 00 00 00       	mov    $0x0,%edi
  803219:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  803220:	00 00 00 
  803223:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803225:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803229:	48 89 c6             	mov    %rax,%rsi
  80322c:	bf 00 00 00 00       	mov    $0x0,%edi
  803231:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  803238:	00 00 00 
  80323b:	ff d0                	callq  *%rax
err:
	return r;
  80323d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803240:	48 83 c4 38          	add    $0x38,%rsp
  803244:	5b                   	pop    %rbx
  803245:	5d                   	pop    %rbp
  803246:	c3                   	retq   

0000000000803247 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803247:	55                   	push   %rbp
  803248:	48 89 e5             	mov    %rsp,%rbp
  80324b:	53                   	push   %rbx
  80324c:	48 83 ec 28          	sub    $0x28,%rsp
  803250:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803254:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803258:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80325f:	00 00 00 
  803262:	48 8b 00             	mov    (%rax),%rax
  803265:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80326b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80326e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803272:	48 89 c7             	mov    %rax,%rdi
  803275:	48 b8 d9 3b 80 00 00 	movabs $0x803bd9,%rax
  80327c:	00 00 00 
  80327f:	ff d0                	callq  *%rax
  803281:	89 c3                	mov    %eax,%ebx
  803283:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803287:	48 89 c7             	mov    %rax,%rdi
  80328a:	48 b8 d9 3b 80 00 00 	movabs $0x803bd9,%rax
  803291:	00 00 00 
  803294:	ff d0                	callq  *%rax
  803296:	39 c3                	cmp    %eax,%ebx
  803298:	0f 94 c0             	sete   %al
  80329b:	0f b6 c0             	movzbl %al,%eax
  80329e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8032a1:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8032a8:	00 00 00 
  8032ab:	48 8b 00             	mov    (%rax),%rax
  8032ae:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032b4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8032b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ba:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032bd:	75 05                	jne    8032c4 <_pipeisclosed+0x7d>
			return ret;
  8032bf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032c2:	eb 4f                	jmp    803313 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8032c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032c7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032ca:	74 42                	je     80330e <_pipeisclosed+0xc7>
  8032cc:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8032d0:	75 3c                	jne    80330e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8032d2:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8032d9:	00 00 00 
  8032dc:	48 8b 00             	mov    (%rax),%rax
  8032df:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8032e5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8032e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032eb:	89 c6                	mov    %eax,%esi
  8032ed:	48 bf ed 42 80 00 00 	movabs $0x8042ed,%rdi
  8032f4:	00 00 00 
  8032f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032fc:	49 b8 f0 02 80 00 00 	movabs $0x8002f0,%r8
  803303:	00 00 00 
  803306:	41 ff d0             	callq  *%r8
	}
  803309:	e9 4a ff ff ff       	jmpq   803258 <_pipeisclosed+0x11>
  80330e:	e9 45 ff ff ff       	jmpq   803258 <_pipeisclosed+0x11>
}
  803313:	48 83 c4 28          	add    $0x28,%rsp
  803317:	5b                   	pop    %rbx
  803318:	5d                   	pop    %rbp
  803319:	c3                   	retq   

000000000080331a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80331a:	55                   	push   %rbp
  80331b:	48 89 e5             	mov    %rsp,%rbp
  80331e:	48 83 ec 30          	sub    $0x30,%rsp
  803322:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803325:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803329:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80332c:	48 89 d6             	mov    %rdx,%rsi
  80332f:	89 c7                	mov    %eax,%edi
  803331:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  803338:	00 00 00 
  80333b:	ff d0                	callq  *%rax
  80333d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803340:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803344:	79 05                	jns    80334b <pipeisclosed+0x31>
		return r;
  803346:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803349:	eb 31                	jmp    80337c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80334b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334f:	48 89 c7             	mov    %rax,%rdi
  803352:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  803359:	00 00 00 
  80335c:	ff d0                	callq  *%rax
  80335e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803366:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80336a:	48 89 d6             	mov    %rdx,%rsi
  80336d:	48 89 c7             	mov    %rax,%rdi
  803370:	48 b8 47 32 80 00 00 	movabs $0x803247,%rax
  803377:	00 00 00 
  80337a:	ff d0                	callq  *%rax
}
  80337c:	c9                   	leaveq 
  80337d:	c3                   	retq   

000000000080337e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80337e:	55                   	push   %rbp
  80337f:	48 89 e5             	mov    %rsp,%rbp
  803382:	48 83 ec 40          	sub    $0x40,%rsp
  803386:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80338a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80338e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803396:	48 89 c7             	mov    %rax,%rdi
  803399:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  8033a0:	00 00 00 
  8033a3:	ff d0                	callq  *%rax
  8033a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8033a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8033b1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8033b8:	00 
  8033b9:	e9 92 00 00 00       	jmpq   803450 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8033be:	eb 41                	jmp    803401 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8033c0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8033c5:	74 09                	je     8033d0 <devpipe_read+0x52>
				return i;
  8033c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033cb:	e9 92 00 00 00       	jmpq   803462 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8033d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d8:	48 89 d6             	mov    %rdx,%rsi
  8033db:	48 89 c7             	mov    %rax,%rdi
  8033de:	48 b8 47 32 80 00 00 	movabs $0x803247,%rax
  8033e5:	00 00 00 
  8033e8:	ff d0                	callq  *%rax
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	74 07                	je     8033f5 <devpipe_read+0x77>
				return 0;
  8033ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f3:	eb 6d                	jmp    803462 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8033f5:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  8033fc:	00 00 00 
  8033ff:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803401:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803405:	8b 10                	mov    (%rax),%edx
  803407:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80340b:	8b 40 04             	mov    0x4(%rax),%eax
  80340e:	39 c2                	cmp    %eax,%edx
  803410:	74 ae                	je     8033c0 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803412:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803416:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80341a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80341e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803422:	8b 00                	mov    (%rax),%eax
  803424:	99                   	cltd   
  803425:	c1 ea 1b             	shr    $0x1b,%edx
  803428:	01 d0                	add    %edx,%eax
  80342a:	83 e0 1f             	and    $0x1f,%eax
  80342d:	29 d0                	sub    %edx,%eax
  80342f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803433:	48 98                	cltq   
  803435:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80343a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80343c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803440:	8b 00                	mov    (%rax),%eax
  803442:	8d 50 01             	lea    0x1(%rax),%edx
  803445:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803449:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80344b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803454:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803458:	0f 82 60 ff ff ff    	jb     8033be <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80345e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803462:	c9                   	leaveq 
  803463:	c3                   	retq   

0000000000803464 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803464:	55                   	push   %rbp
  803465:	48 89 e5             	mov    %rsp,%rbp
  803468:	48 83 ec 40          	sub    $0x40,%rsp
  80346c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803470:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803474:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80347c:	48 89 c7             	mov    %rax,%rdi
  80347f:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  803486:	00 00 00 
  803489:	ff d0                	callq  *%rax
  80348b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80348f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803493:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803497:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80349e:	00 
  80349f:	e9 8e 00 00 00       	jmpq   803532 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034a4:	eb 31                	jmp    8034d7 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8034a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034ae:	48 89 d6             	mov    %rdx,%rsi
  8034b1:	48 89 c7             	mov    %rax,%rdi
  8034b4:	48 b8 47 32 80 00 00 	movabs $0x803247,%rax
  8034bb:	00 00 00 
  8034be:	ff d0                	callq  *%rax
  8034c0:	85 c0                	test   %eax,%eax
  8034c2:	74 07                	je     8034cb <devpipe_write+0x67>
				return 0;
  8034c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c9:	eb 79                	jmp    803544 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8034cb:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  8034d2:	00 00 00 
  8034d5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034db:	8b 40 04             	mov    0x4(%rax),%eax
  8034de:	48 63 d0             	movslq %eax,%rdx
  8034e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e5:	8b 00                	mov    (%rax),%eax
  8034e7:	48 98                	cltq   
  8034e9:	48 83 c0 20          	add    $0x20,%rax
  8034ed:	48 39 c2             	cmp    %rax,%rdx
  8034f0:	73 b4                	jae    8034a6 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8034f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f6:	8b 40 04             	mov    0x4(%rax),%eax
  8034f9:	99                   	cltd   
  8034fa:	c1 ea 1b             	shr    $0x1b,%edx
  8034fd:	01 d0                	add    %edx,%eax
  8034ff:	83 e0 1f             	and    $0x1f,%eax
  803502:	29 d0                	sub    %edx,%eax
  803504:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803508:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80350c:	48 01 ca             	add    %rcx,%rdx
  80350f:	0f b6 0a             	movzbl (%rdx),%ecx
  803512:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803516:	48 98                	cltq   
  803518:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80351c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803520:	8b 40 04             	mov    0x4(%rax),%eax
  803523:	8d 50 01             	lea    0x1(%rax),%edx
  803526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80352d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803536:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80353a:	0f 82 64 ff ff ff    	jb     8034a4 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803540:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803544:	c9                   	leaveq 
  803545:	c3                   	retq   

0000000000803546 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803546:	55                   	push   %rbp
  803547:	48 89 e5             	mov    %rsp,%rbp
  80354a:	48 83 ec 20          	sub    $0x20,%rsp
  80354e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803552:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803556:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355a:	48 89 c7             	mov    %rax,%rdi
  80355d:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  803564:	00 00 00 
  803567:	ff d0                	callq  *%rax
  803569:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80356d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803571:	48 be 00 43 80 00 00 	movabs $0x804300,%rsi
  803578:	00 00 00 
  80357b:	48 89 c7             	mov    %rax,%rdi
  80357e:	48 b8 ff 0f 80 00 00 	movabs $0x800fff,%rax
  803585:	00 00 00 
  803588:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80358a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80358e:	8b 50 04             	mov    0x4(%rax),%edx
  803591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803595:	8b 00                	mov    (%rax),%eax
  803597:	29 c2                	sub    %eax,%edx
  803599:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80359d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8035a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8035ae:	00 00 00 
	stat->st_dev = &devpipe;
  8035b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b5:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8035bc:	00 00 00 
  8035bf:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8035c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035cb:	c9                   	leaveq 
  8035cc:	c3                   	retq   

00000000008035cd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8035cd:	55                   	push   %rbp
  8035ce:	48 89 e5             	mov    %rsp,%rbp
  8035d1:	48 83 ec 10          	sub    $0x10,%rsp
  8035d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8035d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035dd:	48 89 c6             	mov    %rax,%rsi
  8035e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e5:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  8035ec:	00 00 00 
  8035ef:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8035f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f5:	48 89 c7             	mov    %rax,%rdi
  8035f8:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  8035ff:	00 00 00 
  803602:	ff d0                	callq  *%rax
  803604:	48 89 c6             	mov    %rax,%rsi
  803607:	bf 00 00 00 00       	mov    $0x0,%edi
  80360c:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  803613:	00 00 00 
  803616:	ff d0                	callq  *%rax
}
  803618:	c9                   	leaveq 
  803619:	c3                   	retq   

000000000080361a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80361a:	55                   	push   %rbp
  80361b:	48 89 e5             	mov    %rsp,%rbp
  80361e:	48 83 ec 20          	sub    $0x20,%rsp
  803622:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803625:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803628:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80362b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80362f:	be 01 00 00 00       	mov    $0x1,%esi
  803634:	48 89 c7             	mov    %rax,%rdi
  803637:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  80363e:	00 00 00 
  803641:	ff d0                	callq  *%rax
}
  803643:	c9                   	leaveq 
  803644:	c3                   	retq   

0000000000803645 <getchar>:

int
getchar(void)
{
  803645:	55                   	push   %rbp
  803646:	48 89 e5             	mov    %rsp,%rbp
  803649:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80364d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803651:	ba 01 00 00 00       	mov    $0x1,%edx
  803656:	48 89 c6             	mov    %rax,%rsi
  803659:	bf 00 00 00 00       	mov    $0x0,%edi
  80365e:	48 b8 94 22 80 00 00 	movabs $0x802294,%rax
  803665:	00 00 00 
  803668:	ff d0                	callq  *%rax
  80366a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80366d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803671:	79 05                	jns    803678 <getchar+0x33>
		return r;
  803673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803676:	eb 14                	jmp    80368c <getchar+0x47>
	if (r < 1)
  803678:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80367c:	7f 07                	jg     803685 <getchar+0x40>
		return -E_EOF;
  80367e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803683:	eb 07                	jmp    80368c <getchar+0x47>
	return c;
  803685:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803689:	0f b6 c0             	movzbl %al,%eax
}
  80368c:	c9                   	leaveq 
  80368d:	c3                   	retq   

000000000080368e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80368e:	55                   	push   %rbp
  80368f:	48 89 e5             	mov    %rsp,%rbp
  803692:	48 83 ec 20          	sub    $0x20,%rsp
  803696:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803699:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80369d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a0:	48 89 d6             	mov    %rdx,%rsi
  8036a3:	89 c7                	mov    %eax,%edi
  8036a5:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  8036ac:	00 00 00 
  8036af:	ff d0                	callq  *%rax
  8036b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b8:	79 05                	jns    8036bf <iscons+0x31>
		return r;
  8036ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bd:	eb 1a                	jmp    8036d9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8036bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c3:	8b 10                	mov    (%rax),%edx
  8036c5:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8036cc:	00 00 00 
  8036cf:	8b 00                	mov    (%rax),%eax
  8036d1:	39 c2                	cmp    %eax,%edx
  8036d3:	0f 94 c0             	sete   %al
  8036d6:	0f b6 c0             	movzbl %al,%eax
}
  8036d9:	c9                   	leaveq 
  8036da:	c3                   	retq   

00000000008036db <opencons>:

int
opencons(void)
{
  8036db:	55                   	push   %rbp
  8036dc:	48 89 e5             	mov    %rsp,%rbp
  8036df:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8036e3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036e7:	48 89 c7             	mov    %rax,%rdi
  8036ea:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  8036f1:	00 00 00 
  8036f4:	ff d0                	callq  *%rax
  8036f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036fd:	79 05                	jns    803704 <opencons+0x29>
		return r;
  8036ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803702:	eb 5b                	jmp    80375f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803708:	ba 07 04 00 00       	mov    $0x407,%edx
  80370d:	48 89 c6             	mov    %rax,%rsi
  803710:	bf 00 00 00 00       	mov    $0x0,%edi
  803715:	48 b8 2e 19 80 00 00 	movabs $0x80192e,%rax
  80371c:	00 00 00 
  80371f:	ff d0                	callq  *%rax
  803721:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803724:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803728:	79 05                	jns    80372f <opencons+0x54>
		return r;
  80372a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80372d:	eb 30                	jmp    80375f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80372f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803733:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80373a:	00 00 00 
  80373d:	8b 12                	mov    (%rdx),%edx
  80373f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803745:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80374c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803750:	48 89 c7             	mov    %rax,%rdi
  803753:	48 b8 7c 1d 80 00 00 	movabs $0x801d7c,%rax
  80375a:	00 00 00 
  80375d:	ff d0                	callq  *%rax
}
  80375f:	c9                   	leaveq 
  803760:	c3                   	retq   

0000000000803761 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803761:	55                   	push   %rbp
  803762:	48 89 e5             	mov    %rsp,%rbp
  803765:	48 83 ec 30          	sub    $0x30,%rsp
  803769:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80376d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803771:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803775:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80377a:	75 07                	jne    803783 <devcons_read+0x22>
		return 0;
  80377c:	b8 00 00 00 00       	mov    $0x0,%eax
  803781:	eb 4b                	jmp    8037ce <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803783:	eb 0c                	jmp    803791 <devcons_read+0x30>
		sys_yield();
  803785:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  80378c:	00 00 00 
  80378f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803791:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  803798:	00 00 00 
  80379b:	ff d0                	callq  *%rax
  80379d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a4:	74 df                	je     803785 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8037a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037aa:	79 05                	jns    8037b1 <devcons_read+0x50>
		return c;
  8037ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037af:	eb 1d                	jmp    8037ce <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8037b1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8037b5:	75 07                	jne    8037be <devcons_read+0x5d>
		return 0;
  8037b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037bc:	eb 10                	jmp    8037ce <devcons_read+0x6d>
	*(char*)vbuf = c;
  8037be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c1:	89 c2                	mov    %eax,%edx
  8037c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c7:	88 10                	mov    %dl,(%rax)
	return 1;
  8037c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8037ce:	c9                   	leaveq 
  8037cf:	c3                   	retq   

00000000008037d0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037d0:	55                   	push   %rbp
  8037d1:	48 89 e5             	mov    %rsp,%rbp
  8037d4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8037db:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8037e2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8037e9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8037f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037f7:	eb 76                	jmp    80386f <devcons_write+0x9f>
		m = n - tot;
  8037f9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803800:	89 c2                	mov    %eax,%edx
  803802:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803805:	29 c2                	sub    %eax,%edx
  803807:	89 d0                	mov    %edx,%eax
  803809:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80380c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80380f:	83 f8 7f             	cmp    $0x7f,%eax
  803812:	76 07                	jbe    80381b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803814:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80381b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80381e:	48 63 d0             	movslq %eax,%rdx
  803821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803824:	48 63 c8             	movslq %eax,%rcx
  803827:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80382e:	48 01 c1             	add    %rax,%rcx
  803831:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803838:	48 89 ce             	mov    %rcx,%rsi
  80383b:	48 89 c7             	mov    %rax,%rdi
  80383e:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  803845:	00 00 00 
  803848:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80384a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80384d:	48 63 d0             	movslq %eax,%rdx
  803850:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803857:	48 89 d6             	mov    %rdx,%rsi
  80385a:	48 89 c7             	mov    %rax,%rdi
  80385d:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  803864:	00 00 00 
  803867:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803869:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80386c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80386f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803872:	48 98                	cltq   
  803874:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80387b:	0f 82 78 ff ff ff    	jb     8037f9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803881:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803884:	c9                   	leaveq 
  803885:	c3                   	retq   

0000000000803886 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803886:	55                   	push   %rbp
  803887:	48 89 e5             	mov    %rsp,%rbp
  80388a:	48 83 ec 08          	sub    $0x8,%rsp
  80388e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803892:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803897:	c9                   	leaveq 
  803898:	c3                   	retq   

0000000000803899 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803899:	55                   	push   %rbp
  80389a:	48 89 e5             	mov    %rsp,%rbp
  80389d:	48 83 ec 10          	sub    $0x10,%rsp
  8038a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8038a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ad:	48 be 0c 43 80 00 00 	movabs $0x80430c,%rsi
  8038b4:	00 00 00 
  8038b7:	48 89 c7             	mov    %rax,%rdi
  8038ba:	48 b8 ff 0f 80 00 00 	movabs $0x800fff,%rax
  8038c1:	00 00 00 
  8038c4:	ff d0                	callq  *%rax
	return 0;
  8038c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038cb:	c9                   	leaveq 
  8038cc:	c3                   	retq   

00000000008038cd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8038cd:	55                   	push   %rbp
  8038ce:	48 89 e5             	mov    %rsp,%rbp
  8038d1:	53                   	push   %rbx
  8038d2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8038d9:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8038e0:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8038e6:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8038ed:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8038f4:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8038fb:	84 c0                	test   %al,%al
  8038fd:	74 23                	je     803922 <_panic+0x55>
  8038ff:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803906:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80390a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80390e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803912:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803916:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80391a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80391e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803922:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803929:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803930:	00 00 00 
  803933:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80393a:	00 00 00 
  80393d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803941:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803948:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80394f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803956:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80395d:	00 00 00 
  803960:	48 8b 18             	mov    (%rax),%rbx
  803963:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80396a:	00 00 00 
  80396d:	ff d0                	callq  *%rax
  80396f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803975:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80397c:	41 89 c8             	mov    %ecx,%r8d
  80397f:	48 89 d1             	mov    %rdx,%rcx
  803982:	48 89 da             	mov    %rbx,%rdx
  803985:	89 c6                	mov    %eax,%esi
  803987:	48 bf 18 43 80 00 00 	movabs $0x804318,%rdi
  80398e:	00 00 00 
  803991:	b8 00 00 00 00       	mov    $0x0,%eax
  803996:	49 b9 f0 02 80 00 00 	movabs $0x8002f0,%r9
  80399d:	00 00 00 
  8039a0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8039a3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8039aa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8039b1:	48 89 d6             	mov    %rdx,%rsi
  8039b4:	48 89 c7             	mov    %rax,%rdi
  8039b7:	48 b8 44 02 80 00 00 	movabs $0x800244,%rax
  8039be:	00 00 00 
  8039c1:	ff d0                	callq  *%rax
	cprintf("\n");
  8039c3:	48 bf 3b 43 80 00 00 	movabs $0x80433b,%rdi
  8039ca:	00 00 00 
  8039cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d2:	48 ba f0 02 80 00 00 	movabs $0x8002f0,%rdx
  8039d9:	00 00 00 
  8039dc:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8039de:	cc                   	int3   
  8039df:	eb fd                	jmp    8039de <_panic+0x111>

00000000008039e1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8039e1:	55                   	push   %rbp
  8039e2:	48 89 e5             	mov    %rsp,%rbp
  8039e5:	48 83 ec 30          	sub    $0x30,%rsp
  8039e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8039f5:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8039fc:	00 00 00 
  8039ff:	48 8b 00             	mov    (%rax),%rax
  803a02:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803a08:	85 c0                	test   %eax,%eax
  803a0a:	75 34                	jne    803a40 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803a0c:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  803a13:	00 00 00 
  803a16:	ff d0                	callq  *%rax
  803a18:	25 ff 03 00 00       	and    $0x3ff,%eax
  803a1d:	48 98                	cltq   
  803a1f:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803a26:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803a2d:	00 00 00 
  803a30:	48 01 c2             	add    %rax,%rdx
  803a33:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803a3a:	00 00 00 
  803a3d:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803a40:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a45:	75 0e                	jne    803a55 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803a47:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803a4e:	00 00 00 
  803a51:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803a55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a59:	48 89 c7             	mov    %rax,%rdi
  803a5c:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  803a63:	00 00 00 
  803a66:	ff d0                	callq  *%rax
  803a68:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803a6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a6f:	79 19                	jns    803a8a <ipc_recv+0xa9>
		*from_env_store = 0;
  803a71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a75:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803a7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a7f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a88:	eb 53                	jmp    803add <ipc_recv+0xfc>
	}
	if(from_env_store)
  803a8a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a8f:	74 19                	je     803aaa <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803a91:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803a98:	00 00 00 
  803a9b:	48 8b 00             	mov    (%rax),%rax
  803a9e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803aa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aa8:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803aaa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803aaf:	74 19                	je     803aca <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803ab1:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803ab8:	00 00 00 
  803abb:	48 8b 00             	mov    (%rax),%rax
  803abe:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ac4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac8:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803aca:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803ad1:	00 00 00 
  803ad4:	48 8b 00             	mov    (%rax),%rax
  803ad7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803add:	c9                   	leaveq 
  803ade:	c3                   	retq   

0000000000803adf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803adf:	55                   	push   %rbp
  803ae0:	48 89 e5             	mov    %rsp,%rbp
  803ae3:	48 83 ec 30          	sub    $0x30,%rsp
  803ae7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803aea:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803aed:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803af1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803af4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803af9:	75 0e                	jne    803b09 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803afb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803b02:	00 00 00 
  803b05:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803b09:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b0c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803b0f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b13:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b16:	89 c7                	mov    %eax,%edi
  803b18:	48 b8 02 1b 80 00 00 	movabs $0x801b02,%rax
  803b1f:	00 00 00 
  803b22:	ff d0                	callq  *%rax
  803b24:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803b27:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b2b:	75 0c                	jne    803b39 <ipc_send+0x5a>
			sys_yield();
  803b2d:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  803b34:	00 00 00 
  803b37:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803b39:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b3d:	74 ca                	je     803b09 <ipc_send+0x2a>
	if(result != 0)
  803b3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b43:	74 20                	je     803b65 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803b45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b48:	89 c6                	mov    %eax,%esi
  803b4a:	48 bf 3d 43 80 00 00 	movabs $0x80433d,%rdi
  803b51:	00 00 00 
  803b54:	b8 00 00 00 00       	mov    $0x0,%eax
  803b59:	48 ba f0 02 80 00 00 	movabs $0x8002f0,%rdx
  803b60:	00 00 00 
  803b63:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803b65:	c9                   	leaveq 
  803b66:	c3                   	retq   

0000000000803b67 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b67:	55                   	push   %rbp
  803b68:	48 89 e5             	mov    %rsp,%rbp
  803b6b:	48 83 ec 14          	sub    $0x14,%rsp
  803b6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803b72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b79:	eb 4e                	jmp    803bc9 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803b7b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803b82:	00 00 00 
  803b85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b88:	48 98                	cltq   
  803b8a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803b91:	48 01 d0             	add    %rdx,%rax
  803b94:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b9a:	8b 00                	mov    (%rax),%eax
  803b9c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b9f:	75 24                	jne    803bc5 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803ba1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803ba8:	00 00 00 
  803bab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bae:	48 98                	cltq   
  803bb0:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803bb7:	48 01 d0             	add    %rdx,%rax
  803bba:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803bc0:	8b 40 08             	mov    0x8(%rax),%eax
  803bc3:	eb 12                	jmp    803bd7 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803bc5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803bc9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803bd0:	7e a9                	jle    803b7b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bd7:	c9                   	leaveq 
  803bd8:	c3                   	retq   

0000000000803bd9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803bd9:	55                   	push   %rbp
  803bda:	48 89 e5             	mov    %rsp,%rbp
  803bdd:	48 83 ec 18          	sub    $0x18,%rsp
  803be1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803be5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803be9:	48 c1 e8 15          	shr    $0x15,%rax
  803bed:	48 89 c2             	mov    %rax,%rdx
  803bf0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bf7:	01 00 00 
  803bfa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bfe:	83 e0 01             	and    $0x1,%eax
  803c01:	48 85 c0             	test   %rax,%rax
  803c04:	75 07                	jne    803c0d <pageref+0x34>
		return 0;
  803c06:	b8 00 00 00 00       	mov    $0x0,%eax
  803c0b:	eb 53                	jmp    803c60 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c11:	48 c1 e8 0c          	shr    $0xc,%rax
  803c15:	48 89 c2             	mov    %rax,%rdx
  803c18:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c1f:	01 00 00 
  803c22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2e:	83 e0 01             	and    $0x1,%eax
  803c31:	48 85 c0             	test   %rax,%rax
  803c34:	75 07                	jne    803c3d <pageref+0x64>
		return 0;
  803c36:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3b:	eb 23                	jmp    803c60 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c41:	48 c1 e8 0c          	shr    $0xc,%rax
  803c45:	48 89 c2             	mov    %rax,%rdx
  803c48:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c4f:	00 00 00 
  803c52:	48 c1 e2 04          	shl    $0x4,%rdx
  803c56:	48 01 d0             	add    %rdx,%rax
  803c59:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c5d:	0f b7 c0             	movzwl %ax,%eax
}
  803c60:	c9                   	leaveq 
  803c61:	c3                   	retq   
