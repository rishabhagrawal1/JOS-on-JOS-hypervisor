
obj/user/cat:     file format elf64-x86-64


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
  80003c:	e8 08 02 00 00       	callq  800249 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800052:	eb 68                	jmp    8000bc <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800054:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800058:	48 89 c2             	mov    %rax,%rdx
  80005b:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800062:	00 00 00 
  800065:	bf 01 00 00 00       	mov    $0x1,%edi
  80006a:	48 b8 bc 24 80 00 00 	movabs $0x8024bc,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800079:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007c:	48 98                	cltq   
  80007e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800082:	74 38                	je     8000bc <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800084:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008b:	41 89 d0             	mov    %edx,%r8d
  80008e:	48 89 c1             	mov    %rax,%rcx
  800091:	48 ba 40 3c 80 00 00 	movabs $0x803c40,%rdx
  800098:	00 00 00 
  80009b:	be 0d 00 00 00       	mov    $0xd,%esi
  8000a0:	48 bf 5b 3c 80 00 00 	movabs $0x803c5b,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	49 b9 ef 02 80 00 00 	movabs $0x8002ef,%r9
  8000b6:	00 00 00 
  8000b9:	41 ff d1             	callq  *%r9
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000bf:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c4:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 72 23 80 00 00 	movabs $0x802372,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	48 98                	cltq   
  8000de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e7:	0f 8f 67 ff ff ff    	jg     800054 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000ed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f2:	79 39                	jns    80012d <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fc:	49 89 d0             	mov    %rdx,%r8
  8000ff:	48 89 c1             	mov    %rax,%rcx
  800102:	48 ba 66 3c 80 00 00 	movabs $0x803c66,%rdx
  800109:	00 00 00 
  80010c:	be 0f 00 00 00       	mov    $0xf,%esi
  800111:	48 bf 5b 3c 80 00 00 	movabs $0x803c5b,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b9 ef 02 80 00 00 	movabs $0x8002ef,%r9
  800127:	00 00 00 
  80012a:	41 ff d1             	callq  *%r9
}
  80012d:	c9                   	leaveq 
  80012e:	c3                   	retq   

000000000080012f <umain>:

void
umain(int argc, char **argv)
{
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
  800133:	53                   	push   %rbx
  800134:	48 83 ec 28          	sub    $0x28,%rsp
  800138:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80013b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "cat";
  80013f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800146:	00 00 00 
  800149:	48 bb 7b 3c 80 00 00 	movabs $0x803c7b,%rbx
  800150:	00 00 00 
  800153:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  800156:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  80015a:	75 20                	jne    80017c <umain+0x4d>
		cat(0, "<stdin>");
  80015c:	48 be 7f 3c 80 00 00 	movabs $0x803c7f,%rsi
  800163:	00 00 00 
  800166:	bf 00 00 00 00       	mov    $0x0,%edi
  80016b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800172:	00 00 00 
  800175:	ff d0                	callq  *%rax
  800177:	e9 c6 00 00 00       	jmpq   800242 <umain+0x113>
	else
		for (i = 1; i < argc; i++) {
  80017c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  800183:	e9 ae 00 00 00       	jmpq   800236 <umain+0x107>
			f = open(argv[i], O_RDONLY);
  800188:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80018b:	48 98                	cltq   
  80018d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800194:	00 
  800195:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800199:	48 01 d0             	add    %rdx,%rax
  80019c:	48 8b 00             	mov    (%rax),%rax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	48 89 c7             	mov    %rax,%rdi
  8001a7:	48 b8 15 28 80 00 00 	movabs $0x802815,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
  8001b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  8001b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8001ba:	79 3a                	jns    8001f6 <umain+0xc7>
				printf("can't open %s: %e\n", argv[i], f);
  8001bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bf:	48 98                	cltq   
  8001c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001c8:	00 
  8001c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8001cd:	48 01 d0             	add    %rdx,%rax
  8001d0:	48 8b 00             	mov    (%rax),%rax
  8001d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8001d6:	48 89 c6             	mov    %rax,%rsi
  8001d9:	48 bf 87 3c 80 00 00 	movabs $0x803c87,%rdi
  8001e0:	00 00 00 
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e8:	48 b9 79 30 80 00 00 	movabs $0x803079,%rcx
  8001ef:	00 00 00 
  8001f2:	ff d1                	callq  *%rcx
  8001f4:	eb 3c                	jmp    800232 <umain+0x103>
			else {
				cat(f, argv[i]);
  8001f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800202:	00 
  800203:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800207:	48 01 d0             	add    %rdx,%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800210:	48 89 d6             	mov    %rdx,%rsi
  800213:	89 c7                	mov    %eax,%edi
  800215:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	callq  *%rax
				close(f);
  800221:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 50 21 80 00 00 	movabs $0x802150,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800232:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800236:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800239:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  80023c:	0f 8c 46 ff ff ff    	jl     800188 <umain+0x59>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800242:	48 83 c4 28          	add    $0x28,%rsp
  800246:	5b                   	pop    %rbx
  800247:	5d                   	pop    %rbp
  800248:	c3                   	retq   

0000000000800249 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800249:	55                   	push   %rbp
  80024a:	48 89 e5             	mov    %rsp,%rbp
  80024d:	48 83 ec 10          	sub    $0x10,%rsp
  800251:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800254:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800258:	48 b8 90 19 80 00 00 	movabs $0x801990,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
  800264:	25 ff 03 00 00       	and    $0x3ff,%eax
  800269:	48 98                	cltq   
  80026b:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800272:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800279:	00 00 00 
  80027c:	48 01 c2             	add    %rax,%rdx
  80027f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800286:	00 00 00 
  800289:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80028c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800290:	7e 14                	jle    8002a6 <libmain+0x5d>
		binaryname = argv[0];
  800292:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800296:	48 8b 10             	mov    (%rax),%rdx
  800299:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002a0:	00 00 00 
  8002a3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ad:	48 89 d6             	mov    %rdx,%rsi
  8002b0:	89 c7                	mov    %eax,%edi
  8002b2:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8002b9:	00 00 00 
  8002bc:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8002be:	48 b8 cc 02 80 00 00 	movabs $0x8002cc,%rax
  8002c5:	00 00 00 
  8002c8:	ff d0                	callq  *%rax
}
  8002ca:	c9                   	leaveq 
  8002cb:	c3                   	retq   

00000000008002cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002cc:	55                   	push   %rbp
  8002cd:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002d0:	48 b8 9b 21 80 00 00 	movabs $0x80219b,%rax
  8002d7:	00 00 00 
  8002da:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8002e1:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  8002e8:	00 00 00 
  8002eb:	ff d0                	callq  *%rax

}
  8002ed:	5d                   	pop    %rbp
  8002ee:	c3                   	retq   

00000000008002ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002ef:	55                   	push   %rbp
  8002f0:	48 89 e5             	mov    %rsp,%rbp
  8002f3:	53                   	push   %rbx
  8002f4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002fb:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800302:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800308:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80030f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800316:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80031d:	84 c0                	test   %al,%al
  80031f:	74 23                	je     800344 <_panic+0x55>
  800321:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800328:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80032c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800330:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800334:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800338:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80033c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800340:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800344:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80034b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800352:	00 00 00 
  800355:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80035c:	00 00 00 
  80035f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800363:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80036a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800371:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800378:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80037f:	00 00 00 
  800382:	48 8b 18             	mov    (%rax),%rbx
  800385:	48 b8 90 19 80 00 00 	movabs $0x801990,%rax
  80038c:	00 00 00 
  80038f:	ff d0                	callq  *%rax
  800391:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800397:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80039e:	41 89 c8             	mov    %ecx,%r8d
  8003a1:	48 89 d1             	mov    %rdx,%rcx
  8003a4:	48 89 da             	mov    %rbx,%rdx
  8003a7:	89 c6                	mov    %eax,%esi
  8003a9:	48 bf a8 3c 80 00 00 	movabs $0x803ca8,%rdi
  8003b0:	00 00 00 
  8003b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b8:	49 b9 28 05 80 00 00 	movabs $0x800528,%r9
  8003bf:	00 00 00 
  8003c2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003c5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003cc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d3:	48 89 d6             	mov    %rdx,%rsi
  8003d6:	48 89 c7             	mov    %rax,%rdi
  8003d9:	48 b8 7c 04 80 00 00 	movabs $0x80047c,%rax
  8003e0:	00 00 00 
  8003e3:	ff d0                	callq  *%rax
	cprintf("\n");
  8003e5:	48 bf cb 3c 80 00 00 	movabs $0x803ccb,%rdi
  8003ec:	00 00 00 
  8003ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f4:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  8003fb:	00 00 00 
  8003fe:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800400:	cc                   	int3   
  800401:	eb fd                	jmp    800400 <_panic+0x111>

0000000000800403 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800403:	55                   	push   %rbp
  800404:	48 89 e5             	mov    %rsp,%rbp
  800407:	48 83 ec 10          	sub    $0x10,%rsp
  80040b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80040e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800416:	8b 00                	mov    (%rax),%eax
  800418:	8d 48 01             	lea    0x1(%rax),%ecx
  80041b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80041f:	89 0a                	mov    %ecx,(%rdx)
  800421:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800424:	89 d1                	mov    %edx,%ecx
  800426:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042a:	48 98                	cltq   
  80042c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800434:	8b 00                	mov    (%rax),%eax
  800436:	3d ff 00 00 00       	cmp    $0xff,%eax
  80043b:	75 2c                	jne    800469 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80043d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800441:	8b 00                	mov    (%rax),%eax
  800443:	48 98                	cltq   
  800445:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800449:	48 83 c2 08          	add    $0x8,%rdx
  80044d:	48 89 c6             	mov    %rax,%rsi
  800450:	48 89 d7             	mov    %rdx,%rdi
  800453:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  80045a:	00 00 00 
  80045d:	ff d0                	callq  *%rax
        b->idx = 0;
  80045f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800463:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046d:	8b 40 04             	mov    0x4(%rax),%eax
  800470:	8d 50 01             	lea    0x1(%rax),%edx
  800473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800477:	89 50 04             	mov    %edx,0x4(%rax)
}
  80047a:	c9                   	leaveq 
  80047b:	c3                   	retq   

000000000080047c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80047c:	55                   	push   %rbp
  80047d:	48 89 e5             	mov    %rsp,%rbp
  800480:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800487:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80048e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800495:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80049c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004a3:	48 8b 0a             	mov    (%rdx),%rcx
  8004a6:	48 89 08             	mov    %rcx,(%rax)
  8004a9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004ad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004b1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004b5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004c0:	00 00 00 
    b.cnt = 0;
  8004c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004ca:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004cd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004d4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004db:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004e2:	48 89 c6             	mov    %rax,%rsi
  8004e5:	48 bf 03 04 80 00 00 	movabs $0x800403,%rdi
  8004ec:	00 00 00 
  8004ef:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  8004f6:	00 00 00 
  8004f9:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004fb:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800501:	48 98                	cltq   
  800503:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80050a:	48 83 c2 08          	add    $0x8,%rdx
  80050e:	48 89 c6             	mov    %rax,%rsi
  800511:	48 89 d7             	mov    %rdx,%rdi
  800514:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  80051b:	00 00 00 
  80051e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800520:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800526:	c9                   	leaveq 
  800527:	c3                   	retq   

0000000000800528 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800528:	55                   	push   %rbp
  800529:	48 89 e5             	mov    %rsp,%rbp
  80052c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800533:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80053a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800541:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800548:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80054f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800556:	84 c0                	test   %al,%al
  800558:	74 20                	je     80057a <cprintf+0x52>
  80055a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80055e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800562:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800566:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80056a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80056e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800572:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800576:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80057a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800581:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800588:	00 00 00 
  80058b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800592:	00 00 00 
  800595:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800599:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005a0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005a7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005ae:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005b5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005bc:	48 8b 0a             	mov    (%rdx),%rcx
  8005bf:	48 89 08             	mov    %rcx,(%rax)
  8005c2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005ce:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005d2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005e0:	48 89 d6             	mov    %rdx,%rsi
  8005e3:	48 89 c7             	mov    %rax,%rdi
  8005e6:	48 b8 7c 04 80 00 00 	movabs $0x80047c,%rax
  8005ed:	00 00 00 
  8005f0:	ff d0                	callq  *%rax
  8005f2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005f8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005fe:	c9                   	leaveq 
  8005ff:	c3                   	retq   

0000000000800600 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800600:	55                   	push   %rbp
  800601:	48 89 e5             	mov    %rsp,%rbp
  800604:	53                   	push   %rbx
  800605:	48 83 ec 38          	sub    $0x38,%rsp
  800609:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80060d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800611:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800615:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800618:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80061c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800620:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800623:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800627:	77 3b                	ja     800664 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800629:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80062c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800630:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800637:	ba 00 00 00 00       	mov    $0x0,%edx
  80063c:	48 f7 f3             	div    %rbx
  80063f:	48 89 c2             	mov    %rax,%rdx
  800642:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800645:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800648:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80064c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800650:	41 89 f9             	mov    %edi,%r9d
  800653:	48 89 c7             	mov    %rax,%rdi
  800656:	48 b8 00 06 80 00 00 	movabs $0x800600,%rax
  80065d:	00 00 00 
  800660:	ff d0                	callq  *%rax
  800662:	eb 1e                	jmp    800682 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800664:	eb 12                	jmp    800678 <printnum+0x78>
			putch(padc, putdat);
  800666:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80066a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	48 89 ce             	mov    %rcx,%rsi
  800674:	89 d7                	mov    %edx,%edi
  800676:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800678:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80067c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800680:	7f e4                	jg     800666 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800682:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	48 f7 f1             	div    %rcx
  800691:	48 89 d0             	mov    %rdx,%rax
  800694:	48 ba d0 3e 80 00 00 	movabs $0x803ed0,%rdx
  80069b:	00 00 00 
  80069e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006a2:	0f be d0             	movsbl %al,%edx
  8006a5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ad:	48 89 ce             	mov    %rcx,%rsi
  8006b0:	89 d7                	mov    %edx,%edi
  8006b2:	ff d0                	callq  *%rax
}
  8006b4:	48 83 c4 38          	add    $0x38,%rsp
  8006b8:	5b                   	pop    %rbx
  8006b9:	5d                   	pop    %rbp
  8006ba:	c3                   	retq   

00000000008006bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006bb:	55                   	push   %rbp
  8006bc:	48 89 e5             	mov    %rsp,%rbp
  8006bf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006ca:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006ce:	7e 52                	jle    800722 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	8b 00                	mov    (%rax),%eax
  8006d6:	83 f8 30             	cmp    $0x30,%eax
  8006d9:	73 24                	jae    8006ff <getuint+0x44>
  8006db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006df:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	8b 00                	mov    (%rax),%eax
  8006e9:	89 c0                	mov    %eax,%eax
  8006eb:	48 01 d0             	add    %rdx,%rax
  8006ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f2:	8b 12                	mov    (%rdx),%edx
  8006f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fb:	89 0a                	mov    %ecx,(%rdx)
  8006fd:	eb 17                	jmp    800716 <getuint+0x5b>
  8006ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800703:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800707:	48 89 d0             	mov    %rdx,%rax
  80070a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80070e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800712:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800716:	48 8b 00             	mov    (%rax),%rax
  800719:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80071d:	e9 a3 00 00 00       	jmpq   8007c5 <getuint+0x10a>
	else if (lflag)
  800722:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800726:	74 4f                	je     800777 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072c:	8b 00                	mov    (%rax),%eax
  80072e:	83 f8 30             	cmp    $0x30,%eax
  800731:	73 24                	jae    800757 <getuint+0x9c>
  800733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800737:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	8b 00                	mov    (%rax),%eax
  800741:	89 c0                	mov    %eax,%eax
  800743:	48 01 d0             	add    %rdx,%rax
  800746:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074a:	8b 12                	mov    (%rdx),%edx
  80074c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800753:	89 0a                	mov    %ecx,(%rdx)
  800755:	eb 17                	jmp    80076e <getuint+0xb3>
  800757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075f:	48 89 d0             	mov    %rdx,%rax
  800762:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076e:	48 8b 00             	mov    (%rax),%rax
  800771:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800775:	eb 4e                	jmp    8007c5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077b:	8b 00                	mov    (%rax),%eax
  80077d:	83 f8 30             	cmp    $0x30,%eax
  800780:	73 24                	jae    8007a6 <getuint+0xeb>
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078e:	8b 00                	mov    (%rax),%eax
  800790:	89 c0                	mov    %eax,%eax
  800792:	48 01 d0             	add    %rdx,%rax
  800795:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800799:	8b 12                	mov    (%rdx),%edx
  80079b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80079e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a2:	89 0a                	mov    %ecx,(%rdx)
  8007a4:	eb 17                	jmp    8007bd <getuint+0x102>
  8007a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ae:	48 89 d0             	mov    %rdx,%rax
  8007b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007bd:	8b 00                	mov    (%rax),%eax
  8007bf:	89 c0                	mov    %eax,%eax
  8007c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007c9:	c9                   	leaveq 
  8007ca:	c3                   	retq   

00000000008007cb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007cb:	55                   	push   %rbp
  8007cc:	48 89 e5             	mov    %rsp,%rbp
  8007cf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007d7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007de:	7e 52                	jle    800832 <getint+0x67>
		x=va_arg(*ap, long long);
  8007e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e4:	8b 00                	mov    (%rax),%eax
  8007e6:	83 f8 30             	cmp    $0x30,%eax
  8007e9:	73 24                	jae    80080f <getint+0x44>
  8007eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	8b 00                	mov    (%rax),%eax
  8007f9:	89 c0                	mov    %eax,%eax
  8007fb:	48 01 d0             	add    %rdx,%rax
  8007fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800802:	8b 12                	mov    (%rdx),%edx
  800804:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800807:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080b:	89 0a                	mov    %ecx,(%rdx)
  80080d:	eb 17                	jmp    800826 <getint+0x5b>
  80080f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800813:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800817:	48 89 d0             	mov    %rdx,%rax
  80081a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800822:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800826:	48 8b 00             	mov    (%rax),%rax
  800829:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80082d:	e9 a3 00 00 00       	jmpq   8008d5 <getint+0x10a>
	else if (lflag)
  800832:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800836:	74 4f                	je     800887 <getint+0xbc>
		x=va_arg(*ap, long);
  800838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083c:	8b 00                	mov    (%rax),%eax
  80083e:	83 f8 30             	cmp    $0x30,%eax
  800841:	73 24                	jae    800867 <getint+0x9c>
  800843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800847:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084f:	8b 00                	mov    (%rax),%eax
  800851:	89 c0                	mov    %eax,%eax
  800853:	48 01 d0             	add    %rdx,%rax
  800856:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085a:	8b 12                	mov    (%rdx),%edx
  80085c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80085f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800863:	89 0a                	mov    %ecx,(%rdx)
  800865:	eb 17                	jmp    80087e <getint+0xb3>
  800867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80086f:	48 89 d0             	mov    %rdx,%rax
  800872:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800876:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087e:	48 8b 00             	mov    (%rax),%rax
  800881:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800885:	eb 4e                	jmp    8008d5 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088b:	8b 00                	mov    (%rax),%eax
  80088d:	83 f8 30             	cmp    $0x30,%eax
  800890:	73 24                	jae    8008b6 <getint+0xeb>
  800892:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800896:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80089a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089e:	8b 00                	mov    (%rax),%eax
  8008a0:	89 c0                	mov    %eax,%eax
  8008a2:	48 01 d0             	add    %rdx,%rax
  8008a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a9:	8b 12                	mov    (%rdx),%edx
  8008ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b2:	89 0a                	mov    %ecx,(%rdx)
  8008b4:	eb 17                	jmp    8008cd <getint+0x102>
  8008b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008be:	48 89 d0             	mov    %rdx,%rax
  8008c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008cd:	8b 00                	mov    (%rax),%eax
  8008cf:	48 98                	cltq   
  8008d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008d9:	c9                   	leaveq 
  8008da:	c3                   	retq   

00000000008008db <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008db:	55                   	push   %rbp
  8008dc:	48 89 e5             	mov    %rsp,%rbp
  8008df:	41 54                	push   %r12
  8008e1:	53                   	push   %rbx
  8008e2:	48 83 ec 60          	sub    $0x60,%rsp
  8008e6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008ea:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008ee:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008f6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008fa:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008fe:	48 8b 0a             	mov    (%rdx),%rcx
  800901:	48 89 08             	mov    %rcx,(%rax)
  800904:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800908:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80090c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800910:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800914:	eb 17                	jmp    80092d <vprintfmt+0x52>
			if (ch == '\0')
  800916:	85 db                	test   %ebx,%ebx
  800918:	0f 84 cc 04 00 00    	je     800dea <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80091e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800922:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800926:	48 89 d6             	mov    %rdx,%rsi
  800929:	89 df                	mov    %ebx,%edi
  80092b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800931:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800935:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800939:	0f b6 00             	movzbl (%rax),%eax
  80093c:	0f b6 d8             	movzbl %al,%ebx
  80093f:	83 fb 25             	cmp    $0x25,%ebx
  800942:	75 d2                	jne    800916 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800944:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800948:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80094f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800956:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80095d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800964:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800968:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80096c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800970:	0f b6 00             	movzbl (%rax),%eax
  800973:	0f b6 d8             	movzbl %al,%ebx
  800976:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800979:	83 f8 55             	cmp    $0x55,%eax
  80097c:	0f 87 34 04 00 00    	ja     800db6 <vprintfmt+0x4db>
  800982:	89 c0                	mov    %eax,%eax
  800984:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80098b:	00 
  80098c:	48 b8 f8 3e 80 00 00 	movabs $0x803ef8,%rax
  800993:	00 00 00 
  800996:	48 01 d0             	add    %rdx,%rax
  800999:	48 8b 00             	mov    (%rax),%rax
  80099c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80099e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009a2:	eb c0                	jmp    800964 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009a8:	eb ba                	jmp    800964 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009aa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009b1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009b4:	89 d0                	mov    %edx,%eax
  8009b6:	c1 e0 02             	shl    $0x2,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	01 c0                	add    %eax,%eax
  8009bd:	01 d8                	add    %ebx,%eax
  8009bf:	83 e8 30             	sub    $0x30,%eax
  8009c2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009c5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009c9:	0f b6 00             	movzbl (%rax),%eax
  8009cc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009cf:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d2:	7e 0c                	jle    8009e0 <vprintfmt+0x105>
  8009d4:	83 fb 39             	cmp    $0x39,%ebx
  8009d7:	7f 07                	jg     8009e0 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009de:	eb d1                	jmp    8009b1 <vprintfmt+0xd6>
			goto process_precision;
  8009e0:	eb 58                	jmp    800a3a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e5:	83 f8 30             	cmp    $0x30,%eax
  8009e8:	73 17                	jae    800a01 <vprintfmt+0x126>
  8009ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f1:	89 c0                	mov    %eax,%eax
  8009f3:	48 01 d0             	add    %rdx,%rax
  8009f6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f9:	83 c2 08             	add    $0x8,%edx
  8009fc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009ff:	eb 0f                	jmp    800a10 <vprintfmt+0x135>
  800a01:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a05:	48 89 d0             	mov    %rdx,%rax
  800a08:	48 83 c2 08          	add    $0x8,%rdx
  800a0c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a10:	8b 00                	mov    (%rax),%eax
  800a12:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a15:	eb 23                	jmp    800a3a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a17:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a1b:	79 0c                	jns    800a29 <vprintfmt+0x14e>
				width = 0;
  800a1d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a24:	e9 3b ff ff ff       	jmpq   800964 <vprintfmt+0x89>
  800a29:	e9 36 ff ff ff       	jmpq   800964 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a2e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a35:	e9 2a ff ff ff       	jmpq   800964 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3e:	79 12                	jns    800a52 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a40:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a43:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a46:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a4d:	e9 12 ff ff ff       	jmpq   800964 <vprintfmt+0x89>
  800a52:	e9 0d ff ff ff       	jmpq   800964 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a57:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a5b:	e9 04 ff ff ff       	jmpq   800964 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a63:	83 f8 30             	cmp    $0x30,%eax
  800a66:	73 17                	jae    800a7f <vprintfmt+0x1a4>
  800a68:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6f:	89 c0                	mov    %eax,%eax
  800a71:	48 01 d0             	add    %rdx,%rax
  800a74:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a77:	83 c2 08             	add    $0x8,%edx
  800a7a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a7d:	eb 0f                	jmp    800a8e <vprintfmt+0x1b3>
  800a7f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a83:	48 89 d0             	mov    %rdx,%rax
  800a86:	48 83 c2 08          	add    $0x8,%rdx
  800a8a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a8e:	8b 10                	mov    (%rax),%edx
  800a90:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a98:	48 89 ce             	mov    %rcx,%rsi
  800a9b:	89 d7                	mov    %edx,%edi
  800a9d:	ff d0                	callq  *%rax
			break;
  800a9f:	e9 40 03 00 00       	jmpq   800de4 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800aa4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa7:	83 f8 30             	cmp    $0x30,%eax
  800aaa:	73 17                	jae    800ac3 <vprintfmt+0x1e8>
  800aac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab3:	89 c0                	mov    %eax,%eax
  800ab5:	48 01 d0             	add    %rdx,%rax
  800ab8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800abb:	83 c2 08             	add    $0x8,%edx
  800abe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac1:	eb 0f                	jmp    800ad2 <vprintfmt+0x1f7>
  800ac3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac7:	48 89 d0             	mov    %rdx,%rax
  800aca:	48 83 c2 08          	add    $0x8,%rdx
  800ace:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad2:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ad4:	85 db                	test   %ebx,%ebx
  800ad6:	79 02                	jns    800ada <vprintfmt+0x1ff>
				err = -err;
  800ad8:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ada:	83 fb 15             	cmp    $0x15,%ebx
  800add:	7f 16                	jg     800af5 <vprintfmt+0x21a>
  800adf:	48 b8 20 3e 80 00 00 	movabs $0x803e20,%rax
  800ae6:	00 00 00 
  800ae9:	48 63 d3             	movslq %ebx,%rdx
  800aec:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800af0:	4d 85 e4             	test   %r12,%r12
  800af3:	75 2e                	jne    800b23 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800af5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800af9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afd:	89 d9                	mov    %ebx,%ecx
  800aff:	48 ba e1 3e 80 00 00 	movabs $0x803ee1,%rdx
  800b06:	00 00 00 
  800b09:	48 89 c7             	mov    %rax,%rdi
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	49 b8 f3 0d 80 00 00 	movabs $0x800df3,%r8
  800b18:	00 00 00 
  800b1b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b1e:	e9 c1 02 00 00       	jmpq   800de4 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b23:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2b:	4c 89 e1             	mov    %r12,%rcx
  800b2e:	48 ba ea 3e 80 00 00 	movabs $0x803eea,%rdx
  800b35:	00 00 00 
  800b38:	48 89 c7             	mov    %rax,%rdi
  800b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b40:	49 b8 f3 0d 80 00 00 	movabs $0x800df3,%r8
  800b47:	00 00 00 
  800b4a:	41 ff d0             	callq  *%r8
			break;
  800b4d:	e9 92 02 00 00       	jmpq   800de4 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b55:	83 f8 30             	cmp    $0x30,%eax
  800b58:	73 17                	jae    800b71 <vprintfmt+0x296>
  800b5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b61:	89 c0                	mov    %eax,%eax
  800b63:	48 01 d0             	add    %rdx,%rax
  800b66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b69:	83 c2 08             	add    $0x8,%edx
  800b6c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b6f:	eb 0f                	jmp    800b80 <vprintfmt+0x2a5>
  800b71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b75:	48 89 d0             	mov    %rdx,%rax
  800b78:	48 83 c2 08          	add    $0x8,%rdx
  800b7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b80:	4c 8b 20             	mov    (%rax),%r12
  800b83:	4d 85 e4             	test   %r12,%r12
  800b86:	75 0a                	jne    800b92 <vprintfmt+0x2b7>
				p = "(null)";
  800b88:	49 bc ed 3e 80 00 00 	movabs $0x803eed,%r12
  800b8f:	00 00 00 
			if (width > 0 && padc != '-')
  800b92:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b96:	7e 3f                	jle    800bd7 <vprintfmt+0x2fc>
  800b98:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b9c:	74 39                	je     800bd7 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b9e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ba1:	48 98                	cltq   
  800ba3:	48 89 c6             	mov    %rax,%rsi
  800ba6:	4c 89 e7             	mov    %r12,%rdi
  800ba9:	48 b8 9f 10 80 00 00 	movabs $0x80109f,%rax
  800bb0:	00 00 00 
  800bb3:	ff d0                	callq  *%rax
  800bb5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bb8:	eb 17                	jmp    800bd1 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800bba:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bbe:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc6:	48 89 ce             	mov    %rcx,%rsi
  800bc9:	89 d7                	mov    %edx,%edi
  800bcb:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bcd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd5:	7f e3                	jg     800bba <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd7:	eb 37                	jmp    800c10 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800bd9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bdd:	74 1e                	je     800bfd <vprintfmt+0x322>
  800bdf:	83 fb 1f             	cmp    $0x1f,%ebx
  800be2:	7e 05                	jle    800be9 <vprintfmt+0x30e>
  800be4:	83 fb 7e             	cmp    $0x7e,%ebx
  800be7:	7e 14                	jle    800bfd <vprintfmt+0x322>
					putch('?', putdat);
  800be9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf1:	48 89 d6             	mov    %rdx,%rsi
  800bf4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bf9:	ff d0                	callq  *%rax
  800bfb:	eb 0f                	jmp    800c0c <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800bfd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c05:	48 89 d6             	mov    %rdx,%rsi
  800c08:	89 df                	mov    %ebx,%edi
  800c0a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c0c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c10:	4c 89 e0             	mov    %r12,%rax
  800c13:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c17:	0f b6 00             	movzbl (%rax),%eax
  800c1a:	0f be d8             	movsbl %al,%ebx
  800c1d:	85 db                	test   %ebx,%ebx
  800c1f:	74 10                	je     800c31 <vprintfmt+0x356>
  800c21:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c25:	78 b2                	js     800bd9 <vprintfmt+0x2fe>
  800c27:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c2b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c2f:	79 a8                	jns    800bd9 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c31:	eb 16                	jmp    800c49 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3b:	48 89 d6             	mov    %rdx,%rsi
  800c3e:	bf 20 00 00 00       	mov    $0x20,%edi
  800c43:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c45:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c49:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4d:	7f e4                	jg     800c33 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c4f:	e9 90 01 00 00       	jmpq   800de4 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c54:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c58:	be 03 00 00 00       	mov    $0x3,%esi
  800c5d:	48 89 c7             	mov    %rax,%rdi
  800c60:	48 b8 cb 07 80 00 00 	movabs $0x8007cb,%rax
  800c67:	00 00 00 
  800c6a:	ff d0                	callq  *%rax
  800c6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c74:	48 85 c0             	test   %rax,%rax
  800c77:	79 1d                	jns    800c96 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c81:	48 89 d6             	mov    %rdx,%rsi
  800c84:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c89:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c8f:	48 f7 d8             	neg    %rax
  800c92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c96:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c9d:	e9 d5 00 00 00       	jmpq   800d77 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ca2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ca6:	be 03 00 00 00       	mov    $0x3,%esi
  800cab:	48 89 c7             	mov    %rax,%rdi
  800cae:	48 b8 bb 06 80 00 00 	movabs $0x8006bb,%rax
  800cb5:	00 00 00 
  800cb8:	ff d0                	callq  *%rax
  800cba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cbe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cc5:	e9 ad 00 00 00       	jmpq   800d77 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800cca:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800ccd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd1:	89 d6                	mov    %edx,%esi
  800cd3:	48 89 c7             	mov    %rax,%rdi
  800cd6:	48 b8 cb 07 80 00 00 	movabs $0x8007cb,%rax
  800cdd:	00 00 00 
  800ce0:	ff d0                	callq  *%rax
  800ce2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ce6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ced:	e9 85 00 00 00       	jmpq   800d77 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800cf2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfa:	48 89 d6             	mov    %rdx,%rsi
  800cfd:	bf 30 00 00 00       	mov    $0x30,%edi
  800d02:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0c:	48 89 d6             	mov    %rdx,%rsi
  800d0f:	bf 78 00 00 00       	mov    $0x78,%edi
  800d14:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d16:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d19:	83 f8 30             	cmp    $0x30,%eax
  800d1c:	73 17                	jae    800d35 <vprintfmt+0x45a>
  800d1e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d25:	89 c0                	mov    %eax,%eax
  800d27:	48 01 d0             	add    %rdx,%rax
  800d2a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d2d:	83 c2 08             	add    $0x8,%edx
  800d30:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d33:	eb 0f                	jmp    800d44 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d35:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d39:	48 89 d0             	mov    %rdx,%rax
  800d3c:	48 83 c2 08          	add    $0x8,%rdx
  800d40:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d44:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d4b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d52:	eb 23                	jmp    800d77 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d54:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d58:	be 03 00 00 00       	mov    $0x3,%esi
  800d5d:	48 89 c7             	mov    %rax,%rdi
  800d60:	48 b8 bb 06 80 00 00 	movabs $0x8006bb,%rax
  800d67:	00 00 00 
  800d6a:	ff d0                	callq  *%rax
  800d6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d70:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d77:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d7c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d7f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d86:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d8e:	45 89 c1             	mov    %r8d,%r9d
  800d91:	41 89 f8             	mov    %edi,%r8d
  800d94:	48 89 c7             	mov    %rax,%rdi
  800d97:	48 b8 00 06 80 00 00 	movabs $0x800600,%rax
  800d9e:	00 00 00 
  800da1:	ff d0                	callq  *%rax
			break;
  800da3:	eb 3f                	jmp    800de4 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800da5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dad:	48 89 d6             	mov    %rdx,%rsi
  800db0:	89 df                	mov    %ebx,%edi
  800db2:	ff d0                	callq  *%rax
			break;
  800db4:	eb 2e                	jmp    800de4 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800db6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dbe:	48 89 d6             	mov    %rdx,%rsi
  800dc1:	bf 25 00 00 00       	mov    $0x25,%edi
  800dc6:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dc8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dcd:	eb 05                	jmp    800dd4 <vprintfmt+0x4f9>
  800dcf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dd4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dd8:	48 83 e8 01          	sub    $0x1,%rax
  800ddc:	0f b6 00             	movzbl (%rax),%eax
  800ddf:	3c 25                	cmp    $0x25,%al
  800de1:	75 ec                	jne    800dcf <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800de3:	90                   	nop
		}
	}
  800de4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800de5:	e9 43 fb ff ff       	jmpq   80092d <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800dea:	48 83 c4 60          	add    $0x60,%rsp
  800dee:	5b                   	pop    %rbx
  800def:	41 5c                	pop    %r12
  800df1:	5d                   	pop    %rbp
  800df2:	c3                   	retq   

0000000000800df3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800df3:	55                   	push   %rbp
  800df4:	48 89 e5             	mov    %rsp,%rbp
  800df7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dfe:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e05:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e0c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e13:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e1a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e21:	84 c0                	test   %al,%al
  800e23:	74 20                	je     800e45 <printfmt+0x52>
  800e25:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e29:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e2d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e31:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e35:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e39:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e3d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e41:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e45:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e4c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e53:	00 00 00 
  800e56:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e5d:	00 00 00 
  800e60:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e64:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e6b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e72:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e79:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e80:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e87:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e8e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e95:	48 89 c7             	mov    %rax,%rdi
  800e98:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  800e9f:	00 00 00 
  800ea2:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ea4:	c9                   	leaveq 
  800ea5:	c3                   	retq   

0000000000800ea6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ea6:	55                   	push   %rbp
  800ea7:	48 89 e5             	mov    %rsp,%rbp
  800eaa:	48 83 ec 10          	sub    $0x10,%rsp
  800eae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb9:	8b 40 10             	mov    0x10(%rax),%eax
  800ebc:	8d 50 01             	lea    0x1(%rax),%edx
  800ebf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ec6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eca:	48 8b 10             	mov    (%rax),%rdx
  800ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ed5:	48 39 c2             	cmp    %rax,%rdx
  800ed8:	73 17                	jae    800ef1 <sprintputch+0x4b>
		*b->buf++ = ch;
  800eda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ede:	48 8b 00             	mov    (%rax),%rax
  800ee1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ee5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ee9:	48 89 0a             	mov    %rcx,(%rdx)
  800eec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eef:	88 10                	mov    %dl,(%rax)
}
  800ef1:	c9                   	leaveq 
  800ef2:	c3                   	retq   

0000000000800ef3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ef3:	55                   	push   %rbp
  800ef4:	48 89 e5             	mov    %rsp,%rbp
  800ef7:	48 83 ec 50          	sub    $0x50,%rsp
  800efb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800eff:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f02:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f06:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f0a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f0e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f12:	48 8b 0a             	mov    (%rdx),%rcx
  800f15:	48 89 08             	mov    %rcx,(%rax)
  800f18:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f1c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f20:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f24:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f28:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f2c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f30:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f33:	48 98                	cltq   
  800f35:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f39:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f3d:	48 01 d0             	add    %rdx,%rax
  800f40:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f44:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f4b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f50:	74 06                	je     800f58 <vsnprintf+0x65>
  800f52:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f56:	7f 07                	jg     800f5f <vsnprintf+0x6c>
		return -E_INVAL;
  800f58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5d:	eb 2f                	jmp    800f8e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f5f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f63:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f67:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f6b:	48 89 c6             	mov    %rax,%rsi
  800f6e:	48 bf a6 0e 80 00 00 	movabs $0x800ea6,%rdi
  800f75:	00 00 00 
  800f78:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  800f7f:	00 00 00 
  800f82:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f88:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f8b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f8e:	c9                   	leaveq 
  800f8f:	c3                   	retq   

0000000000800f90 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f90:	55                   	push   %rbp
  800f91:	48 89 e5             	mov    %rsp,%rbp
  800f94:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f9b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fa2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fa8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800faf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fb6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fbd:	84 c0                	test   %al,%al
  800fbf:	74 20                	je     800fe1 <snprintf+0x51>
  800fc1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fc5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fc9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fcd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fd1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fd5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fd9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fdd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fe1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fe8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fef:	00 00 00 
  800ff2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ff9:	00 00 00 
  800ffc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801000:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801007:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80100e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801015:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80101c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801023:	48 8b 0a             	mov    (%rdx),%rcx
  801026:	48 89 08             	mov    %rcx,(%rax)
  801029:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80102d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801031:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801035:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801039:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801040:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801047:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80104d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801054:	48 89 c7             	mov    %rax,%rdi
  801057:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  80105e:	00 00 00 
  801061:	ff d0                	callq  *%rax
  801063:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801069:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80106f:	c9                   	leaveq 
  801070:	c3                   	retq   

0000000000801071 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801071:	55                   	push   %rbp
  801072:	48 89 e5             	mov    %rsp,%rbp
  801075:	48 83 ec 18          	sub    $0x18,%rsp
  801079:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801084:	eb 09                	jmp    80108f <strlen+0x1e>
		n++;
  801086:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80108a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80108f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801093:	0f b6 00             	movzbl (%rax),%eax
  801096:	84 c0                	test   %al,%al
  801098:	75 ec                	jne    801086 <strlen+0x15>
		n++;
	return n;
  80109a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80109d:	c9                   	leaveq 
  80109e:	c3                   	retq   

000000000080109f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80109f:	55                   	push   %rbp
  8010a0:	48 89 e5             	mov    %rsp,%rbp
  8010a3:	48 83 ec 20          	sub    $0x20,%rsp
  8010a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010b6:	eb 0e                	jmp    8010c6 <strnlen+0x27>
		n++;
  8010b8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010bc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010c1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010c6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010cb:	74 0b                	je     8010d8 <strnlen+0x39>
  8010cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d1:	0f b6 00             	movzbl (%rax),%eax
  8010d4:	84 c0                	test   %al,%al
  8010d6:	75 e0                	jne    8010b8 <strnlen+0x19>
		n++;
	return n;
  8010d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010db:	c9                   	leaveq 
  8010dc:	c3                   	retq   

00000000008010dd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010dd:	55                   	push   %rbp
  8010de:	48 89 e5             	mov    %rsp,%rbp
  8010e1:	48 83 ec 20          	sub    $0x20,%rsp
  8010e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010f5:	90                   	nop
  8010f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801102:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801106:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80110a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80110e:	0f b6 12             	movzbl (%rdx),%edx
  801111:	88 10                	mov    %dl,(%rax)
  801113:	0f b6 00             	movzbl (%rax),%eax
  801116:	84 c0                	test   %al,%al
  801118:	75 dc                	jne    8010f6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80111a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80111e:	c9                   	leaveq 
  80111f:	c3                   	retq   

0000000000801120 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801120:	55                   	push   %rbp
  801121:	48 89 e5             	mov    %rsp,%rbp
  801124:	48 83 ec 20          	sub    $0x20,%rsp
  801128:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801134:	48 89 c7             	mov    %rax,%rdi
  801137:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  80113e:	00 00 00 
  801141:	ff d0                	callq  *%rax
  801143:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801149:	48 63 d0             	movslq %eax,%rdx
  80114c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801150:	48 01 c2             	add    %rax,%rdx
  801153:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801157:	48 89 c6             	mov    %rax,%rsi
  80115a:	48 89 d7             	mov    %rdx,%rdi
  80115d:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  801164:	00 00 00 
  801167:	ff d0                	callq  *%rax
	return dst;
  801169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80116d:	c9                   	leaveq 
  80116e:	c3                   	retq   

000000000080116f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80116f:	55                   	push   %rbp
  801170:	48 89 e5             	mov    %rsp,%rbp
  801173:	48 83 ec 28          	sub    $0x28,%rsp
  801177:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80117b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80117f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801183:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801187:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80118b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801192:	00 
  801193:	eb 2a                	jmp    8011bf <strncpy+0x50>
		*dst++ = *src;
  801195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801199:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80119d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011a5:	0f b6 12             	movzbl (%rdx),%edx
  8011a8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ae:	0f b6 00             	movzbl (%rax),%eax
  8011b1:	84 c0                	test   %al,%al
  8011b3:	74 05                	je     8011ba <strncpy+0x4b>
			src++;
  8011b5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011c7:	72 cc                	jb     801195 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011cd:	c9                   	leaveq 
  8011ce:	c3                   	retq   

00000000008011cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011cf:	55                   	push   %rbp
  8011d0:	48 89 e5             	mov    %rsp,%rbp
  8011d3:	48 83 ec 28          	sub    $0x28,%rsp
  8011d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011eb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011f0:	74 3d                	je     80122f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011f2:	eb 1d                	jmp    801211 <strlcpy+0x42>
			*dst++ = *src++;
  8011f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801200:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801204:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801208:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80120c:	0f b6 12             	movzbl (%rdx),%edx
  80120f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801211:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801216:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80121b:	74 0b                	je     801228 <strlcpy+0x59>
  80121d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801221:	0f b6 00             	movzbl (%rax),%eax
  801224:	84 c0                	test   %al,%al
  801226:	75 cc                	jne    8011f4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80122f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801233:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801237:	48 29 c2             	sub    %rax,%rdx
  80123a:	48 89 d0             	mov    %rdx,%rax
}
  80123d:	c9                   	leaveq 
  80123e:	c3                   	retq   

000000000080123f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80123f:	55                   	push   %rbp
  801240:	48 89 e5             	mov    %rsp,%rbp
  801243:	48 83 ec 10          	sub    $0x10,%rsp
  801247:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80124b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80124f:	eb 0a                	jmp    80125b <strcmp+0x1c>
		p++, q++;
  801251:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801256:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	84 c0                	test   %al,%al
  801264:	74 12                	je     801278 <strcmp+0x39>
  801266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126a:	0f b6 10             	movzbl (%rax),%edx
  80126d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801271:	0f b6 00             	movzbl (%rax),%eax
  801274:	38 c2                	cmp    %al,%dl
  801276:	74 d9                	je     801251 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127c:	0f b6 00             	movzbl (%rax),%eax
  80127f:	0f b6 d0             	movzbl %al,%edx
  801282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801286:	0f b6 00             	movzbl (%rax),%eax
  801289:	0f b6 c0             	movzbl %al,%eax
  80128c:	29 c2                	sub    %eax,%edx
  80128e:	89 d0                	mov    %edx,%eax
}
  801290:	c9                   	leaveq 
  801291:	c3                   	retq   

0000000000801292 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801292:	55                   	push   %rbp
  801293:	48 89 e5             	mov    %rsp,%rbp
  801296:	48 83 ec 18          	sub    $0x18,%rsp
  80129a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80129e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012a6:	eb 0f                	jmp    8012b7 <strncmp+0x25>
		n--, p++, q++;
  8012a8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012bc:	74 1d                	je     8012db <strncmp+0x49>
  8012be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c2:	0f b6 00             	movzbl (%rax),%eax
  8012c5:	84 c0                	test   %al,%al
  8012c7:	74 12                	je     8012db <strncmp+0x49>
  8012c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cd:	0f b6 10             	movzbl (%rax),%edx
  8012d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d4:	0f b6 00             	movzbl (%rax),%eax
  8012d7:	38 c2                	cmp    %al,%dl
  8012d9:	74 cd                	je     8012a8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e0:	75 07                	jne    8012e9 <strncmp+0x57>
		return 0;
  8012e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e7:	eb 18                	jmp    801301 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ed:	0f b6 00             	movzbl (%rax),%eax
  8012f0:	0f b6 d0             	movzbl %al,%edx
  8012f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f7:	0f b6 00             	movzbl (%rax),%eax
  8012fa:	0f b6 c0             	movzbl %al,%eax
  8012fd:	29 c2                	sub    %eax,%edx
  8012ff:	89 d0                	mov    %edx,%eax
}
  801301:	c9                   	leaveq 
  801302:	c3                   	retq   

0000000000801303 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801303:	55                   	push   %rbp
  801304:	48 89 e5             	mov    %rsp,%rbp
  801307:	48 83 ec 0c          	sub    $0xc,%rsp
  80130b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130f:	89 f0                	mov    %esi,%eax
  801311:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801314:	eb 17                	jmp    80132d <strchr+0x2a>
		if (*s == c)
  801316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131a:	0f b6 00             	movzbl (%rax),%eax
  80131d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801320:	75 06                	jne    801328 <strchr+0x25>
			return (char *) s;
  801322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801326:	eb 15                	jmp    80133d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801328:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801331:	0f b6 00             	movzbl (%rax),%eax
  801334:	84 c0                	test   %al,%al
  801336:	75 de                	jne    801316 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133d:	c9                   	leaveq 
  80133e:	c3                   	retq   

000000000080133f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80133f:	55                   	push   %rbp
  801340:	48 89 e5             	mov    %rsp,%rbp
  801343:	48 83 ec 0c          	sub    $0xc,%rsp
  801347:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80134b:	89 f0                	mov    %esi,%eax
  80134d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801350:	eb 13                	jmp    801365 <strfind+0x26>
		if (*s == c)
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80135c:	75 02                	jne    801360 <strfind+0x21>
			break;
  80135e:	eb 10                	jmp    801370 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801360:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801369:	0f b6 00             	movzbl (%rax),%eax
  80136c:	84 c0                	test   %al,%al
  80136e:	75 e2                	jne    801352 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801370:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801374:	c9                   	leaveq 
  801375:	c3                   	retq   

0000000000801376 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801376:	55                   	push   %rbp
  801377:	48 89 e5             	mov    %rsp,%rbp
  80137a:	48 83 ec 18          	sub    $0x18,%rsp
  80137e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801382:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801385:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801389:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80138e:	75 06                	jne    801396 <memset+0x20>
		return v;
  801390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801394:	eb 69                	jmp    8013ff <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139a:	83 e0 03             	and    $0x3,%eax
  80139d:	48 85 c0             	test   %rax,%rax
  8013a0:	75 48                	jne    8013ea <memset+0x74>
  8013a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a6:	83 e0 03             	and    $0x3,%eax
  8013a9:	48 85 c0             	test   %rax,%rax
  8013ac:	75 3c                	jne    8013ea <memset+0x74>
		c &= 0xFF;
  8013ae:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b8:	c1 e0 18             	shl    $0x18,%eax
  8013bb:	89 c2                	mov    %eax,%edx
  8013bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c0:	c1 e0 10             	shl    $0x10,%eax
  8013c3:	09 c2                	or     %eax,%edx
  8013c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c8:	c1 e0 08             	shl    $0x8,%eax
  8013cb:	09 d0                	or     %edx,%eax
  8013cd:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d4:	48 c1 e8 02          	shr    $0x2,%rax
  8013d8:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e2:	48 89 d7             	mov    %rdx,%rdi
  8013e5:	fc                   	cld    
  8013e6:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013e8:	eb 11                	jmp    8013fb <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013f5:	48 89 d7             	mov    %rdx,%rdi
  8013f8:	fc                   	cld    
  8013f9:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013ff:	c9                   	leaveq 
  801400:	c3                   	retq   

0000000000801401 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801401:	55                   	push   %rbp
  801402:	48 89 e5             	mov    %rsp,%rbp
  801405:	48 83 ec 28          	sub    $0x28,%rsp
  801409:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801411:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801415:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801419:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80141d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801421:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80142d:	0f 83 88 00 00 00    	jae    8014bb <memmove+0xba>
  801433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801437:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80143b:	48 01 d0             	add    %rdx,%rax
  80143e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801442:	76 77                	jbe    8014bb <memmove+0xba>
		s += n;
  801444:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801448:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801458:	83 e0 03             	and    $0x3,%eax
  80145b:	48 85 c0             	test   %rax,%rax
  80145e:	75 3b                	jne    80149b <memmove+0x9a>
  801460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801464:	83 e0 03             	and    $0x3,%eax
  801467:	48 85 c0             	test   %rax,%rax
  80146a:	75 2f                	jne    80149b <memmove+0x9a>
  80146c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801470:	83 e0 03             	and    $0x3,%eax
  801473:	48 85 c0             	test   %rax,%rax
  801476:	75 23                	jne    80149b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147c:	48 83 e8 04          	sub    $0x4,%rax
  801480:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801484:	48 83 ea 04          	sub    $0x4,%rdx
  801488:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80148c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801490:	48 89 c7             	mov    %rax,%rdi
  801493:	48 89 d6             	mov    %rdx,%rsi
  801496:	fd                   	std    
  801497:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801499:	eb 1d                	jmp    8014b8 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80149b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014af:	48 89 d7             	mov    %rdx,%rdi
  8014b2:	48 89 c1             	mov    %rax,%rcx
  8014b5:	fd                   	std    
  8014b6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014b8:	fc                   	cld    
  8014b9:	eb 57                	jmp    801512 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bf:	83 e0 03             	and    $0x3,%eax
  8014c2:	48 85 c0             	test   %rax,%rax
  8014c5:	75 36                	jne    8014fd <memmove+0xfc>
  8014c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cb:	83 e0 03             	and    $0x3,%eax
  8014ce:	48 85 c0             	test   %rax,%rax
  8014d1:	75 2a                	jne    8014fd <memmove+0xfc>
  8014d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d7:	83 e0 03             	and    $0x3,%eax
  8014da:	48 85 c0             	test   %rax,%rax
  8014dd:	75 1e                	jne    8014fd <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e3:	48 c1 e8 02          	shr    $0x2,%rax
  8014e7:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f2:	48 89 c7             	mov    %rax,%rdi
  8014f5:	48 89 d6             	mov    %rdx,%rsi
  8014f8:	fc                   	cld    
  8014f9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014fb:	eb 15                	jmp    801512 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801501:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801505:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801509:	48 89 c7             	mov    %rax,%rdi
  80150c:	48 89 d6             	mov    %rdx,%rsi
  80150f:	fc                   	cld    
  801510:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801512:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801516:	c9                   	leaveq 
  801517:	c3                   	retq   

0000000000801518 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801518:	55                   	push   %rbp
  801519:	48 89 e5             	mov    %rsp,%rbp
  80151c:	48 83 ec 18          	sub    $0x18,%rsp
  801520:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801524:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801528:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80152c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801530:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801534:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801538:	48 89 ce             	mov    %rcx,%rsi
  80153b:	48 89 c7             	mov    %rax,%rdi
  80153e:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  801545:	00 00 00 
  801548:	ff d0                	callq  *%rax
}
  80154a:	c9                   	leaveq 
  80154b:	c3                   	retq   

000000000080154c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80154c:	55                   	push   %rbp
  80154d:	48 89 e5             	mov    %rsp,%rbp
  801550:	48 83 ec 28          	sub    $0x28,%rsp
  801554:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801558:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80155c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801564:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801568:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80156c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801570:	eb 36                	jmp    8015a8 <memcmp+0x5c>
		if (*s1 != *s2)
  801572:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801576:	0f b6 10             	movzbl (%rax),%edx
  801579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157d:	0f b6 00             	movzbl (%rax),%eax
  801580:	38 c2                	cmp    %al,%dl
  801582:	74 1a                	je     80159e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801588:	0f b6 00             	movzbl (%rax),%eax
  80158b:	0f b6 d0             	movzbl %al,%edx
  80158e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801592:	0f b6 00             	movzbl (%rax),%eax
  801595:	0f b6 c0             	movzbl %al,%eax
  801598:	29 c2                	sub    %eax,%edx
  80159a:	89 d0                	mov    %edx,%eax
  80159c:	eb 20                	jmp    8015be <memcmp+0x72>
		s1++, s2++;
  80159e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ac:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015b4:	48 85 c0             	test   %rax,%rax
  8015b7:	75 b9                	jne    801572 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015be:	c9                   	leaveq 
  8015bf:	c3                   	retq   

00000000008015c0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015c0:	55                   	push   %rbp
  8015c1:	48 89 e5             	mov    %rsp,%rbp
  8015c4:	48 83 ec 28          	sub    $0x28,%rsp
  8015c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015cc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015db:	48 01 d0             	add    %rdx,%rax
  8015de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015e2:	eb 15                	jmp    8015f9 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e8:	0f b6 10             	movzbl (%rax),%edx
  8015eb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015ee:	38 c2                	cmp    %al,%dl
  8015f0:	75 02                	jne    8015f4 <memfind+0x34>
			break;
  8015f2:	eb 0f                	jmp    801603 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015f4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801601:	72 e1                	jb     8015e4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801607:	c9                   	leaveq 
  801608:	c3                   	retq   

0000000000801609 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801609:	55                   	push   %rbp
  80160a:	48 89 e5             	mov    %rsp,%rbp
  80160d:	48 83 ec 34          	sub    $0x34,%rsp
  801611:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801615:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801619:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80161c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801623:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80162a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80162b:	eb 05                	jmp    801632 <strtol+0x29>
		s++;
  80162d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801636:	0f b6 00             	movzbl (%rax),%eax
  801639:	3c 20                	cmp    $0x20,%al
  80163b:	74 f0                	je     80162d <strtol+0x24>
  80163d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801641:	0f b6 00             	movzbl (%rax),%eax
  801644:	3c 09                	cmp    $0x9,%al
  801646:	74 e5                	je     80162d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	3c 2b                	cmp    $0x2b,%al
  801651:	75 07                	jne    80165a <strtol+0x51>
		s++;
  801653:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801658:	eb 17                	jmp    801671 <strtol+0x68>
	else if (*s == '-')
  80165a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165e:	0f b6 00             	movzbl (%rax),%eax
  801661:	3c 2d                	cmp    $0x2d,%al
  801663:	75 0c                	jne    801671 <strtol+0x68>
		s++, neg = 1;
  801665:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80166a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801671:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801675:	74 06                	je     80167d <strtol+0x74>
  801677:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80167b:	75 28                	jne    8016a5 <strtol+0x9c>
  80167d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801681:	0f b6 00             	movzbl (%rax),%eax
  801684:	3c 30                	cmp    $0x30,%al
  801686:	75 1d                	jne    8016a5 <strtol+0x9c>
  801688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168c:	48 83 c0 01          	add    $0x1,%rax
  801690:	0f b6 00             	movzbl (%rax),%eax
  801693:	3c 78                	cmp    $0x78,%al
  801695:	75 0e                	jne    8016a5 <strtol+0x9c>
		s += 2, base = 16;
  801697:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80169c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016a3:	eb 2c                	jmp    8016d1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016a9:	75 19                	jne    8016c4 <strtol+0xbb>
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	0f b6 00             	movzbl (%rax),%eax
  8016b2:	3c 30                	cmp    $0x30,%al
  8016b4:	75 0e                	jne    8016c4 <strtol+0xbb>
		s++, base = 8;
  8016b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016bb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016c2:	eb 0d                	jmp    8016d1 <strtol+0xc8>
	else if (base == 0)
  8016c4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016c8:	75 07                	jne    8016d1 <strtol+0xc8>
		base = 10;
  8016ca:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	0f b6 00             	movzbl (%rax),%eax
  8016d8:	3c 2f                	cmp    $0x2f,%al
  8016da:	7e 1d                	jle    8016f9 <strtol+0xf0>
  8016dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e0:	0f b6 00             	movzbl (%rax),%eax
  8016e3:	3c 39                	cmp    $0x39,%al
  8016e5:	7f 12                	jg     8016f9 <strtol+0xf0>
			dig = *s - '0';
  8016e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016eb:	0f b6 00             	movzbl (%rax),%eax
  8016ee:	0f be c0             	movsbl %al,%eax
  8016f1:	83 e8 30             	sub    $0x30,%eax
  8016f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016f7:	eb 4e                	jmp    801747 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fd:	0f b6 00             	movzbl (%rax),%eax
  801700:	3c 60                	cmp    $0x60,%al
  801702:	7e 1d                	jle    801721 <strtol+0x118>
  801704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801708:	0f b6 00             	movzbl (%rax),%eax
  80170b:	3c 7a                	cmp    $0x7a,%al
  80170d:	7f 12                	jg     801721 <strtol+0x118>
			dig = *s - 'a' + 10;
  80170f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801713:	0f b6 00             	movzbl (%rax),%eax
  801716:	0f be c0             	movsbl %al,%eax
  801719:	83 e8 57             	sub    $0x57,%eax
  80171c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80171f:	eb 26                	jmp    801747 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801725:	0f b6 00             	movzbl (%rax),%eax
  801728:	3c 40                	cmp    $0x40,%al
  80172a:	7e 48                	jle    801774 <strtol+0x16b>
  80172c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801730:	0f b6 00             	movzbl (%rax),%eax
  801733:	3c 5a                	cmp    $0x5a,%al
  801735:	7f 3d                	jg     801774 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173b:	0f b6 00             	movzbl (%rax),%eax
  80173e:	0f be c0             	movsbl %al,%eax
  801741:	83 e8 37             	sub    $0x37,%eax
  801744:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801747:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80174a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80174d:	7c 02                	jl     801751 <strtol+0x148>
			break;
  80174f:	eb 23                	jmp    801774 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801751:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801756:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801759:	48 98                	cltq   
  80175b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801760:	48 89 c2             	mov    %rax,%rdx
  801763:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801766:	48 98                	cltq   
  801768:	48 01 d0             	add    %rdx,%rax
  80176b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80176f:	e9 5d ff ff ff       	jmpq   8016d1 <strtol+0xc8>

	if (endptr)
  801774:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801779:	74 0b                	je     801786 <strtol+0x17d>
		*endptr = (char *) s;
  80177b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80177f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801783:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801786:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80178a:	74 09                	je     801795 <strtol+0x18c>
  80178c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801790:	48 f7 d8             	neg    %rax
  801793:	eb 04                	jmp    801799 <strtol+0x190>
  801795:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801799:	c9                   	leaveq 
  80179a:	c3                   	retq   

000000000080179b <strstr>:

char * strstr(const char *in, const char *str)
{
  80179b:	55                   	push   %rbp
  80179c:	48 89 e5             	mov    %rsp,%rbp
  80179f:	48 83 ec 30          	sub    $0x30,%rsp
  8017a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017af:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017b3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017b7:	0f b6 00             	movzbl (%rax),%eax
  8017ba:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017bd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017c1:	75 06                	jne    8017c9 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	eb 6b                	jmp    801834 <strstr+0x99>

	len = strlen(str);
  8017c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017cd:	48 89 c7             	mov    %rax,%rdi
  8017d0:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	callq  *%rax
  8017dc:	48 98                	cltq   
  8017de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017ee:	0f b6 00             	movzbl (%rax),%eax
  8017f1:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017f4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017f8:	75 07                	jne    801801 <strstr+0x66>
				return (char *) 0;
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ff:	eb 33                	jmp    801834 <strstr+0x99>
		} while (sc != c);
  801801:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801805:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801808:	75 d8                	jne    8017e2 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80180a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80180e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801812:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801816:	48 89 ce             	mov    %rcx,%rsi
  801819:	48 89 c7             	mov    %rax,%rdi
  80181c:	48 b8 92 12 80 00 00 	movabs $0x801292,%rax
  801823:	00 00 00 
  801826:	ff d0                	callq  *%rax
  801828:	85 c0                	test   %eax,%eax
  80182a:	75 b6                	jne    8017e2 <strstr+0x47>

	return (char *) (in - 1);
  80182c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801830:	48 83 e8 01          	sub    $0x1,%rax
}
  801834:	c9                   	leaveq 
  801835:	c3                   	retq   

0000000000801836 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801836:	55                   	push   %rbp
  801837:	48 89 e5             	mov    %rsp,%rbp
  80183a:	53                   	push   %rbx
  80183b:	48 83 ec 48          	sub    $0x48,%rsp
  80183f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801842:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801845:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801849:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80184d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801851:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801855:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801858:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80185c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801860:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801864:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801868:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80186c:	4c 89 c3             	mov    %r8,%rbx
  80186f:	cd 30                	int    $0x30
  801871:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801875:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801879:	74 3e                	je     8018b9 <syscall+0x83>
  80187b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801880:	7e 37                	jle    8018b9 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801882:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801886:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801889:	49 89 d0             	mov    %rdx,%r8
  80188c:	89 c1                	mov    %eax,%ecx
  80188e:	48 ba a8 41 80 00 00 	movabs $0x8041a8,%rdx
  801895:	00 00 00 
  801898:	be 23 00 00 00       	mov    $0x23,%esi
  80189d:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  8018a4:	00 00 00 
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ac:	49 b9 ef 02 80 00 00 	movabs $0x8002ef,%r9
  8018b3:	00 00 00 
  8018b6:	41 ff d1             	callq  *%r9

	return ret;
  8018b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018bd:	48 83 c4 48          	add    $0x48,%rsp
  8018c1:	5b                   	pop    %rbx
  8018c2:	5d                   	pop    %rbp
  8018c3:	c3                   	retq   

00000000008018c4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018c4:	55                   	push   %rbp
  8018c5:	48 89 e5             	mov    %rsp,%rbp
  8018c8:	48 83 ec 20          	sub    $0x20,%rsp
  8018cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e3:	00 
  8018e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f0:	48 89 d1             	mov    %rdx,%rcx
  8018f3:	48 89 c2             	mov    %rax,%rdx
  8018f6:	be 00 00 00 00       	mov    $0x0,%esi
  8018fb:	bf 00 00 00 00       	mov    $0x0,%edi
  801900:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801907:	00 00 00 
  80190a:	ff d0                	callq  *%rax
}
  80190c:	c9                   	leaveq 
  80190d:	c3                   	retq   

000000000080190e <sys_cgetc>:

int
sys_cgetc(void)
{
  80190e:	55                   	push   %rbp
  80190f:	48 89 e5             	mov    %rsp,%rbp
  801912:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801916:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191d:	00 
  80191e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801924:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192f:	ba 00 00 00 00       	mov    $0x0,%edx
  801934:	be 00 00 00 00       	mov    $0x0,%esi
  801939:	bf 01 00 00 00       	mov    $0x1,%edi
  80193e:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801945:	00 00 00 
  801948:	ff d0                	callq  *%rax
}
  80194a:	c9                   	leaveq 
  80194b:	c3                   	retq   

000000000080194c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80194c:	55                   	push   %rbp
  80194d:	48 89 e5             	mov    %rsp,%rbp
  801950:	48 83 ec 10          	sub    $0x10,%rsp
  801954:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80195a:	48 98                	cltq   
  80195c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801963:	00 
  801964:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801970:	b9 00 00 00 00       	mov    $0x0,%ecx
  801975:	48 89 c2             	mov    %rax,%rdx
  801978:	be 01 00 00 00       	mov    $0x1,%esi
  80197d:	bf 03 00 00 00       	mov    $0x3,%edi
  801982:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801989:	00 00 00 
  80198c:	ff d0                	callq  *%rax
}
  80198e:	c9                   	leaveq 
  80198f:	c3                   	retq   

0000000000801990 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801990:	55                   	push   %rbp
  801991:	48 89 e5             	mov    %rsp,%rbp
  801994:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801998:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80199f:	00 
  8019a0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b6:	be 00 00 00 00       	mov    $0x0,%esi
  8019bb:	bf 02 00 00 00       	mov    $0x2,%edi
  8019c0:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  8019c7:	00 00 00 
  8019ca:	ff d0                	callq  *%rax
}
  8019cc:	c9                   	leaveq 
  8019cd:	c3                   	retq   

00000000008019ce <sys_yield>:

void
sys_yield(void)
{
  8019ce:	55                   	push   %rbp
  8019cf:	48 89 e5             	mov    %rsp,%rbp
  8019d2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019dd:	00 
  8019de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f4:	be 00 00 00 00       	mov    $0x0,%esi
  8019f9:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019fe:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801a05:	00 00 00 
  801a08:	ff d0                	callq  *%rax
}
  801a0a:	c9                   	leaveq 
  801a0b:	c3                   	retq   

0000000000801a0c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a0c:	55                   	push   %rbp
  801a0d:	48 89 e5             	mov    %rsp,%rbp
  801a10:	48 83 ec 20          	sub    $0x20,%rsp
  801a14:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a1b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a21:	48 63 c8             	movslq %eax,%rcx
  801a24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2b:	48 98                	cltq   
  801a2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a34:	00 
  801a35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3b:	49 89 c8             	mov    %rcx,%r8
  801a3e:	48 89 d1             	mov    %rdx,%rcx
  801a41:	48 89 c2             	mov    %rax,%rdx
  801a44:	be 01 00 00 00       	mov    $0x1,%esi
  801a49:	bf 04 00 00 00       	mov    $0x4,%edi
  801a4e:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801a55:	00 00 00 
  801a58:	ff d0                	callq  *%rax
}
  801a5a:	c9                   	leaveq 
  801a5b:	c3                   	retq   

0000000000801a5c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a5c:	55                   	push   %rbp
  801a5d:	48 89 e5             	mov    %rsp,%rbp
  801a60:	48 83 ec 30          	sub    $0x30,%rsp
  801a64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a6b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a6e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a72:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a76:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a79:	48 63 c8             	movslq %eax,%rcx
  801a7c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a83:	48 63 f0             	movslq %eax,%rsi
  801a86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8d:	48 98                	cltq   
  801a8f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a93:	49 89 f9             	mov    %rdi,%r9
  801a96:	49 89 f0             	mov    %rsi,%r8
  801a99:	48 89 d1             	mov    %rdx,%rcx
  801a9c:	48 89 c2             	mov    %rax,%rdx
  801a9f:	be 01 00 00 00       	mov    $0x1,%esi
  801aa4:	bf 05 00 00 00       	mov    $0x5,%edi
  801aa9:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801ab0:	00 00 00 
  801ab3:	ff d0                	callq  *%rax
}
  801ab5:	c9                   	leaveq 
  801ab6:	c3                   	retq   

0000000000801ab7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ab7:	55                   	push   %rbp
  801ab8:	48 89 e5             	mov    %rsp,%rbp
  801abb:	48 83 ec 20          	sub    $0x20,%rsp
  801abf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ac6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801acd:	48 98                	cltq   
  801acf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad6:	00 
  801ad7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801add:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae3:	48 89 d1             	mov    %rdx,%rcx
  801ae6:	48 89 c2             	mov    %rax,%rdx
  801ae9:	be 01 00 00 00       	mov    $0x1,%esi
  801aee:	bf 06 00 00 00       	mov    $0x6,%edi
  801af3:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801afa:	00 00 00 
  801afd:	ff d0                	callq  *%rax
}
  801aff:	c9                   	leaveq 
  801b00:	c3                   	retq   

0000000000801b01 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b01:	55                   	push   %rbp
  801b02:	48 89 e5             	mov    %rsp,%rbp
  801b05:	48 83 ec 10          	sub    $0x10,%rsp
  801b09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b0c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b12:	48 63 d0             	movslq %eax,%rdx
  801b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b18:	48 98                	cltq   
  801b1a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b21:	00 
  801b22:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2e:	48 89 d1             	mov    %rdx,%rcx
  801b31:	48 89 c2             	mov    %rax,%rdx
  801b34:	be 01 00 00 00       	mov    $0x1,%esi
  801b39:	bf 08 00 00 00       	mov    $0x8,%edi
  801b3e:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801b45:	00 00 00 
  801b48:	ff d0                	callq  *%rax
}
  801b4a:	c9                   	leaveq 
  801b4b:	c3                   	retq   

0000000000801b4c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b4c:	55                   	push   %rbp
  801b4d:	48 89 e5             	mov    %rsp,%rbp
  801b50:	48 83 ec 20          	sub    $0x20,%rsp
  801b54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b62:	48 98                	cltq   
  801b64:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6b:	00 
  801b6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b78:	48 89 d1             	mov    %rdx,%rcx
  801b7b:	48 89 c2             	mov    %rax,%rdx
  801b7e:	be 01 00 00 00       	mov    $0x1,%esi
  801b83:	bf 09 00 00 00       	mov    $0x9,%edi
  801b88:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801b8f:	00 00 00 
  801b92:	ff d0                	callq  *%rax
}
  801b94:	c9                   	leaveq 
  801b95:	c3                   	retq   

0000000000801b96 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b96:	55                   	push   %rbp
  801b97:	48 89 e5             	mov    %rsp,%rbp
  801b9a:	48 83 ec 20          	sub    $0x20,%rsp
  801b9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ba5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bac:	48 98                	cltq   
  801bae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb5:	00 
  801bb6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc2:	48 89 d1             	mov    %rdx,%rcx
  801bc5:	48 89 c2             	mov    %rax,%rdx
  801bc8:	be 01 00 00 00       	mov    $0x1,%esi
  801bcd:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bd2:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	callq  *%rax
}
  801bde:	c9                   	leaveq 
  801bdf:	c3                   	retq   

0000000000801be0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801be0:	55                   	push   %rbp
  801be1:	48 89 e5             	mov    %rsp,%rbp
  801be4:	48 83 ec 20          	sub    $0x20,%rsp
  801be8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801beb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bf3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bf6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bf9:	48 63 f0             	movslq %eax,%rsi
  801bfc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c03:	48 98                	cltq   
  801c05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c10:	00 
  801c11:	49 89 f1             	mov    %rsi,%r9
  801c14:	49 89 c8             	mov    %rcx,%r8
  801c17:	48 89 d1             	mov    %rdx,%rcx
  801c1a:	48 89 c2             	mov    %rax,%rdx
  801c1d:	be 00 00 00 00       	mov    $0x0,%esi
  801c22:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c27:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801c2e:	00 00 00 
  801c31:	ff d0                	callq  *%rax
}
  801c33:	c9                   	leaveq 
  801c34:	c3                   	retq   

0000000000801c35 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c35:	55                   	push   %rbp
  801c36:	48 89 e5             	mov    %rsp,%rbp
  801c39:	48 83 ec 10          	sub    $0x10,%rsp
  801c3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4c:	00 
  801c4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c59:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c5e:	48 89 c2             	mov    %rax,%rdx
  801c61:	be 01 00 00 00       	mov    $0x1,%esi
  801c66:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c6b:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801c72:	00 00 00 
  801c75:	ff d0                	callq  *%rax
}
  801c77:	c9                   	leaveq 
  801c78:	c3                   	retq   

0000000000801c79 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c79:	55                   	push   %rbp
  801c7a:	48 89 e5             	mov    %rsp,%rbp
  801c7d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c88:	00 
  801c89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c95:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9f:	be 00 00 00 00       	mov    $0x0,%esi
  801ca4:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ca9:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801cb0:	00 00 00 
  801cb3:	ff d0                	callq  *%rax
}
  801cb5:	c9                   	leaveq 
  801cb6:	c3                   	retq   

0000000000801cb7 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	48 83 ec 30          	sub    $0x30,%rsp
  801cbf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cc6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cc9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ccd:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801cd1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801cd4:	48 63 c8             	movslq %eax,%rcx
  801cd7:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cdb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cde:	48 63 f0             	movslq %eax,%rsi
  801ce1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce8:	48 98                	cltq   
  801cea:	48 89 0c 24          	mov    %rcx,(%rsp)
  801cee:	49 89 f9             	mov    %rdi,%r9
  801cf1:	49 89 f0             	mov    %rsi,%r8
  801cf4:	48 89 d1             	mov    %rdx,%rcx
  801cf7:	48 89 c2             	mov    %rax,%rdx
  801cfa:	be 00 00 00 00       	mov    $0x0,%esi
  801cff:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d04:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801d0b:	00 00 00 
  801d0e:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d10:	c9                   	leaveq 
  801d11:	c3                   	retq   

0000000000801d12 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d12:	55                   	push   %rbp
  801d13:	48 89 e5             	mov    %rsp,%rbp
  801d16:	48 83 ec 20          	sub    $0x20,%rsp
  801d1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d31:	00 
  801d32:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d38:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d3e:	48 89 d1             	mov    %rdx,%rcx
  801d41:	48 89 c2             	mov    %rax,%rdx
  801d44:	be 00 00 00 00       	mov    $0x0,%esi
  801d49:	bf 10 00 00 00       	mov    $0x10,%edi
  801d4e:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801d55:	00 00 00 
  801d58:	ff d0                	callq  *%rax
}
  801d5a:	c9                   	leaveq 
  801d5b:	c3                   	retq   

0000000000801d5c <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801d5c:	55                   	push   %rbp
  801d5d:	48 89 e5             	mov    %rsp,%rbp
  801d60:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801d64:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d6b:	00 
  801d6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d78:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d82:	be 00 00 00 00       	mov    $0x0,%esi
  801d87:	bf 11 00 00 00       	mov    $0x11,%edi
  801d8c:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801d93:	00 00 00 
  801d96:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801d98:	c9                   	leaveq 
  801d99:	c3                   	retq   

0000000000801d9a <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801d9a:	55                   	push   %rbp
  801d9b:	48 89 e5             	mov    %rsp,%rbp
  801d9e:	48 83 ec 10          	sub    $0x10,%rsp
  801da2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801da5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da8:	48 98                	cltq   
  801daa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db1:	00 
  801db2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dc3:	48 89 c2             	mov    %rax,%rdx
  801dc6:	be 00 00 00 00       	mov    $0x0,%esi
  801dcb:	bf 12 00 00 00       	mov    $0x12,%edi
  801dd0:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801dd7:	00 00 00 
  801dda:	ff d0                	callq  *%rax
}
  801ddc:	c9                   	leaveq 
  801ddd:	c3                   	retq   

0000000000801dde <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801dde:	55                   	push   %rbp
  801ddf:	48 89 e5             	mov    %rsp,%rbp
  801de2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801de6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ded:	00 
  801dee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dfa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dff:	ba 00 00 00 00       	mov    $0x0,%edx
  801e04:	be 00 00 00 00       	mov    $0x0,%esi
  801e09:	bf 13 00 00 00       	mov    $0x13,%edi
  801e0e:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801e15:	00 00 00 
  801e18:	ff d0                	callq  *%rax
}
  801e1a:	c9                   	leaveq 
  801e1b:	c3                   	retq   

0000000000801e1c <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801e1c:	55                   	push   %rbp
  801e1d:	48 89 e5             	mov    %rsp,%rbp
  801e20:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e24:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e2b:	00 
  801e2c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e32:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e38:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e42:	be 00 00 00 00       	mov    $0x0,%esi
  801e47:	bf 14 00 00 00       	mov    $0x14,%edi
  801e4c:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  801e53:	00 00 00 
  801e56:	ff d0                	callq  *%rax
}
  801e58:	c9                   	leaveq 
  801e59:	c3                   	retq   

0000000000801e5a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e5a:	55                   	push   %rbp
  801e5b:	48 89 e5             	mov    %rsp,%rbp
  801e5e:	48 83 ec 08          	sub    $0x8,%rsp
  801e62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e66:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e6a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e71:	ff ff ff 
  801e74:	48 01 d0             	add    %rdx,%rax
  801e77:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e7b:	c9                   	leaveq 
  801e7c:	c3                   	retq   

0000000000801e7d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e7d:	55                   	push   %rbp
  801e7e:	48 89 e5             	mov    %rsp,%rbp
  801e81:	48 83 ec 08          	sub    $0x8,%rsp
  801e85:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e8d:	48 89 c7             	mov    %rax,%rdi
  801e90:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  801e97:	00 00 00 
  801e9a:	ff d0                	callq  *%rax
  801e9c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ea2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ea6:	c9                   	leaveq 
  801ea7:	c3                   	retq   

0000000000801ea8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ea8:	55                   	push   %rbp
  801ea9:	48 89 e5             	mov    %rsp,%rbp
  801eac:	48 83 ec 18          	sub    $0x18,%rsp
  801eb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801eb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ebb:	eb 6b                	jmp    801f28 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec0:	48 98                	cltq   
  801ec2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ec8:	48 c1 e0 0c          	shl    $0xc,%rax
  801ecc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ed0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed4:	48 c1 e8 15          	shr    $0x15,%rax
  801ed8:	48 89 c2             	mov    %rax,%rdx
  801edb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ee2:	01 00 00 
  801ee5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee9:	83 e0 01             	and    $0x1,%eax
  801eec:	48 85 c0             	test   %rax,%rax
  801eef:	74 21                	je     801f12 <fd_alloc+0x6a>
  801ef1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef5:	48 c1 e8 0c          	shr    $0xc,%rax
  801ef9:	48 89 c2             	mov    %rax,%rdx
  801efc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f03:	01 00 00 
  801f06:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f0a:	83 e0 01             	and    $0x1,%eax
  801f0d:	48 85 c0             	test   %rax,%rax
  801f10:	75 12                	jne    801f24 <fd_alloc+0x7c>
			*fd_store = fd;
  801f12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f1a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f22:	eb 1a                	jmp    801f3e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f24:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f28:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f2c:	7e 8f                	jle    801ebd <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f32:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f39:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f3e:	c9                   	leaveq 
  801f3f:	c3                   	retq   

0000000000801f40 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f40:	55                   	push   %rbp
  801f41:	48 89 e5             	mov    %rsp,%rbp
  801f44:	48 83 ec 20          	sub    $0x20,%rsp
  801f48:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f53:	78 06                	js     801f5b <fd_lookup+0x1b>
  801f55:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f59:	7e 07                	jle    801f62 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f5b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f60:	eb 6c                	jmp    801fce <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f62:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f65:	48 98                	cltq   
  801f67:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f6d:	48 c1 e0 0c          	shl    $0xc,%rax
  801f71:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f79:	48 c1 e8 15          	shr    $0x15,%rax
  801f7d:	48 89 c2             	mov    %rax,%rdx
  801f80:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f87:	01 00 00 
  801f8a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f8e:	83 e0 01             	and    $0x1,%eax
  801f91:	48 85 c0             	test   %rax,%rax
  801f94:	74 21                	je     801fb7 <fd_lookup+0x77>
  801f96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9a:	48 c1 e8 0c          	shr    $0xc,%rax
  801f9e:	48 89 c2             	mov    %rax,%rdx
  801fa1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fa8:	01 00 00 
  801fab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801faf:	83 e0 01             	and    $0x1,%eax
  801fb2:	48 85 c0             	test   %rax,%rax
  801fb5:	75 07                	jne    801fbe <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fbc:	eb 10                	jmp    801fce <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fc2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fc6:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fce:	c9                   	leaveq 
  801fcf:	c3                   	retq   

0000000000801fd0 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fd0:	55                   	push   %rbp
  801fd1:	48 89 e5             	mov    %rsp,%rbp
  801fd4:	48 83 ec 30          	sub    $0x30,%rsp
  801fd8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fdc:	89 f0                	mov    %esi,%eax
  801fde:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fe1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe5:	48 89 c7             	mov    %rax,%rdi
  801fe8:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  801fef:	00 00 00 
  801ff2:	ff d0                	callq  *%rax
  801ff4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ff8:	48 89 d6             	mov    %rdx,%rsi
  801ffb:	89 c7                	mov    %eax,%edi
  801ffd:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  802004:	00 00 00 
  802007:	ff d0                	callq  *%rax
  802009:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80200c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802010:	78 0a                	js     80201c <fd_close+0x4c>
	    || fd != fd2)
  802012:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802016:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80201a:	74 12                	je     80202e <fd_close+0x5e>
		return (must_exist ? r : 0);
  80201c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802020:	74 05                	je     802027 <fd_close+0x57>
  802022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802025:	eb 05                	jmp    80202c <fd_close+0x5c>
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
  80202c:	eb 69                	jmp    802097 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80202e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802032:	8b 00                	mov    (%rax),%eax
  802034:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802038:	48 89 d6             	mov    %rdx,%rsi
  80203b:	89 c7                	mov    %eax,%edi
  80203d:	48 b8 99 20 80 00 00 	movabs $0x802099,%rax
  802044:	00 00 00 
  802047:	ff d0                	callq  *%rax
  802049:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80204c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802050:	78 2a                	js     80207c <fd_close+0xac>
		if (dev->dev_close)
  802052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802056:	48 8b 40 20          	mov    0x20(%rax),%rax
  80205a:	48 85 c0             	test   %rax,%rax
  80205d:	74 16                	je     802075 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80205f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802063:	48 8b 40 20          	mov    0x20(%rax),%rax
  802067:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80206b:	48 89 d7             	mov    %rdx,%rdi
  80206e:	ff d0                	callq  *%rax
  802070:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802073:	eb 07                	jmp    80207c <fd_close+0xac>
		else
			r = 0;
  802075:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80207c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802080:	48 89 c6             	mov    %rax,%rsi
  802083:	bf 00 00 00 00       	mov    $0x0,%edi
  802088:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  80208f:	00 00 00 
  802092:	ff d0                	callq  *%rax
	return r;
  802094:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802097:	c9                   	leaveq 
  802098:	c3                   	retq   

0000000000802099 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802099:	55                   	push   %rbp
  80209a:	48 89 e5             	mov    %rsp,%rbp
  80209d:	48 83 ec 20          	sub    $0x20,%rsp
  8020a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020af:	eb 41                	jmp    8020f2 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020b1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020b8:	00 00 00 
  8020bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020be:	48 63 d2             	movslq %edx,%rdx
  8020c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c5:	8b 00                	mov    (%rax),%eax
  8020c7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020ca:	75 22                	jne    8020ee <dev_lookup+0x55>
			*dev = devtab[i];
  8020cc:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020d3:	00 00 00 
  8020d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020d9:	48 63 d2             	movslq %edx,%rdx
  8020dc:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020e4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ec:	eb 60                	jmp    80214e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020ee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020f2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020f9:	00 00 00 
  8020fc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020ff:	48 63 d2             	movslq %edx,%rdx
  802102:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802106:	48 85 c0             	test   %rax,%rax
  802109:	75 a6                	jne    8020b1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80210b:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802112:	00 00 00 
  802115:	48 8b 00             	mov    (%rax),%rax
  802118:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80211e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802121:	89 c6                	mov    %eax,%esi
  802123:	48 bf d8 41 80 00 00 	movabs $0x8041d8,%rdi
  80212a:	00 00 00 
  80212d:	b8 00 00 00 00       	mov    $0x0,%eax
  802132:	48 b9 28 05 80 00 00 	movabs $0x800528,%rcx
  802139:	00 00 00 
  80213c:	ff d1                	callq  *%rcx
	*dev = 0;
  80213e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802142:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802149:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80214e:	c9                   	leaveq 
  80214f:	c3                   	retq   

0000000000802150 <close>:

int
close(int fdnum)
{
  802150:	55                   	push   %rbp
  802151:	48 89 e5             	mov    %rsp,%rbp
  802154:	48 83 ec 20          	sub    $0x20,%rsp
  802158:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80215b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80215f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802162:	48 89 d6             	mov    %rdx,%rsi
  802165:	89 c7                	mov    %eax,%edi
  802167:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  80216e:	00 00 00 
  802171:	ff d0                	callq  *%rax
  802173:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802176:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80217a:	79 05                	jns    802181 <close+0x31>
		return r;
  80217c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80217f:	eb 18                	jmp    802199 <close+0x49>
	else
		return fd_close(fd, 1);
  802181:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802185:	be 01 00 00 00       	mov    $0x1,%esi
  80218a:	48 89 c7             	mov    %rax,%rdi
  80218d:	48 b8 d0 1f 80 00 00 	movabs $0x801fd0,%rax
  802194:	00 00 00 
  802197:	ff d0                	callq  *%rax
}
  802199:	c9                   	leaveq 
  80219a:	c3                   	retq   

000000000080219b <close_all>:

void
close_all(void)
{
  80219b:	55                   	push   %rbp
  80219c:	48 89 e5             	mov    %rsp,%rbp
  80219f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021aa:	eb 15                	jmp    8021c1 <close_all+0x26>
		close(i);
  8021ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021af:	89 c7                	mov    %eax,%edi
  8021b1:	48 b8 50 21 80 00 00 	movabs $0x802150,%rax
  8021b8:	00 00 00 
  8021bb:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021c1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021c5:	7e e5                	jle    8021ac <close_all+0x11>
		close(i);
}
  8021c7:	c9                   	leaveq 
  8021c8:	c3                   	retq   

00000000008021c9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021c9:	55                   	push   %rbp
  8021ca:	48 89 e5             	mov    %rsp,%rbp
  8021cd:	48 83 ec 40          	sub    $0x40,%rsp
  8021d1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021d4:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021d7:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021db:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021de:	48 89 d6             	mov    %rdx,%rsi
  8021e1:	89 c7                	mov    %eax,%edi
  8021e3:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  8021ea:	00 00 00 
  8021ed:	ff d0                	callq  *%rax
  8021ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f6:	79 08                	jns    802200 <dup+0x37>
		return r;
  8021f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021fb:	e9 70 01 00 00       	jmpq   802370 <dup+0x1a7>
	close(newfdnum);
  802200:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802203:	89 c7                	mov    %eax,%edi
  802205:	48 b8 50 21 80 00 00 	movabs $0x802150,%rax
  80220c:	00 00 00 
  80220f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802211:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802214:	48 98                	cltq   
  802216:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80221c:	48 c1 e0 0c          	shl    $0xc,%rax
  802220:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802224:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802228:	48 89 c7             	mov    %rax,%rdi
  80222b:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  802232:	00 00 00 
  802235:	ff d0                	callq  *%rax
  802237:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80223b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80223f:	48 89 c7             	mov    %rax,%rdi
  802242:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  802249:	00 00 00 
  80224c:	ff d0                	callq  *%rax
  80224e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802256:	48 c1 e8 15          	shr    $0x15,%rax
  80225a:	48 89 c2             	mov    %rax,%rdx
  80225d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802264:	01 00 00 
  802267:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80226b:	83 e0 01             	and    $0x1,%eax
  80226e:	48 85 c0             	test   %rax,%rax
  802271:	74 73                	je     8022e6 <dup+0x11d>
  802273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802277:	48 c1 e8 0c          	shr    $0xc,%rax
  80227b:	48 89 c2             	mov    %rax,%rdx
  80227e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802285:	01 00 00 
  802288:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228c:	83 e0 01             	and    $0x1,%eax
  80228f:	48 85 c0             	test   %rax,%rax
  802292:	74 52                	je     8022e6 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802298:	48 c1 e8 0c          	shr    $0xc,%rax
  80229c:	48 89 c2             	mov    %rax,%rdx
  80229f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a6:	01 00 00 
  8022a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8022b2:	89 c1                	mov    %eax,%ecx
  8022b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bc:	41 89 c8             	mov    %ecx,%r8d
  8022bf:	48 89 d1             	mov    %rdx,%rcx
  8022c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c7:	48 89 c6             	mov    %rax,%rsi
  8022ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8022cf:	48 b8 5c 1a 80 00 00 	movabs $0x801a5c,%rax
  8022d6:	00 00 00 
  8022d9:	ff d0                	callq  *%rax
  8022db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e2:	79 02                	jns    8022e6 <dup+0x11d>
			goto err;
  8022e4:	eb 57                	jmp    80233d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8022e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ea:	48 c1 e8 0c          	shr    $0xc,%rax
  8022ee:	48 89 c2             	mov    %rax,%rdx
  8022f1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022f8:	01 00 00 
  8022fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ff:	25 07 0e 00 00       	and    $0xe07,%eax
  802304:	89 c1                	mov    %eax,%ecx
  802306:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80230a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80230e:	41 89 c8             	mov    %ecx,%r8d
  802311:	48 89 d1             	mov    %rdx,%rcx
  802314:	ba 00 00 00 00       	mov    $0x0,%edx
  802319:	48 89 c6             	mov    %rax,%rsi
  80231c:	bf 00 00 00 00       	mov    $0x0,%edi
  802321:	48 b8 5c 1a 80 00 00 	movabs $0x801a5c,%rax
  802328:	00 00 00 
  80232b:	ff d0                	callq  *%rax
  80232d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802330:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802334:	79 02                	jns    802338 <dup+0x16f>
		goto err;
  802336:	eb 05                	jmp    80233d <dup+0x174>

	return newfdnum;
  802338:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80233b:	eb 33                	jmp    802370 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80233d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802341:	48 89 c6             	mov    %rax,%rsi
  802344:	bf 00 00 00 00       	mov    $0x0,%edi
  802349:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  802350:	00 00 00 
  802353:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802355:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802359:	48 89 c6             	mov    %rax,%rsi
  80235c:	bf 00 00 00 00       	mov    $0x0,%edi
  802361:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  802368:	00 00 00 
  80236b:	ff d0                	callq  *%rax
	return r;
  80236d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802370:	c9                   	leaveq 
  802371:	c3                   	retq   

0000000000802372 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802372:	55                   	push   %rbp
  802373:	48 89 e5             	mov    %rsp,%rbp
  802376:	48 83 ec 40          	sub    $0x40,%rsp
  80237a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80237d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802381:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802385:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802389:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80238c:	48 89 d6             	mov    %rdx,%rsi
  80238f:	89 c7                	mov    %eax,%edi
  802391:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  802398:	00 00 00 
  80239b:	ff d0                	callq  *%rax
  80239d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a4:	78 24                	js     8023ca <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023aa:	8b 00                	mov    (%rax),%eax
  8023ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b0:	48 89 d6             	mov    %rdx,%rsi
  8023b3:	89 c7                	mov    %eax,%edi
  8023b5:	48 b8 99 20 80 00 00 	movabs $0x802099,%rax
  8023bc:	00 00 00 
  8023bf:	ff d0                	callq  *%rax
  8023c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c8:	79 05                	jns    8023cf <read+0x5d>
		return r;
  8023ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cd:	eb 76                	jmp    802445 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d3:	8b 40 08             	mov    0x8(%rax),%eax
  8023d6:	83 e0 03             	and    $0x3,%eax
  8023d9:	83 f8 01             	cmp    $0x1,%eax
  8023dc:	75 3a                	jne    802418 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023de:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8023e5:	00 00 00 
  8023e8:	48 8b 00             	mov    (%rax),%rax
  8023eb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023f1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023f4:	89 c6                	mov    %eax,%esi
  8023f6:	48 bf f7 41 80 00 00 	movabs $0x8041f7,%rdi
  8023fd:	00 00 00 
  802400:	b8 00 00 00 00       	mov    $0x0,%eax
  802405:	48 b9 28 05 80 00 00 	movabs $0x800528,%rcx
  80240c:	00 00 00 
  80240f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802411:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802416:	eb 2d                	jmp    802445 <read+0xd3>
	}
	if (!dev->dev_read)
  802418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802420:	48 85 c0             	test   %rax,%rax
  802423:	75 07                	jne    80242c <read+0xba>
		return -E_NOT_SUPP;
  802425:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80242a:	eb 19                	jmp    802445 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80242c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802430:	48 8b 40 10          	mov    0x10(%rax),%rax
  802434:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802438:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80243c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802440:	48 89 cf             	mov    %rcx,%rdi
  802443:	ff d0                	callq  *%rax
}
  802445:	c9                   	leaveq 
  802446:	c3                   	retq   

0000000000802447 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802447:	55                   	push   %rbp
  802448:	48 89 e5             	mov    %rsp,%rbp
  80244b:	48 83 ec 30          	sub    $0x30,%rsp
  80244f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802452:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802456:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80245a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802461:	eb 49                	jmp    8024ac <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802463:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802466:	48 98                	cltq   
  802468:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80246c:	48 29 c2             	sub    %rax,%rdx
  80246f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802472:	48 63 c8             	movslq %eax,%rcx
  802475:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802479:	48 01 c1             	add    %rax,%rcx
  80247c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80247f:	48 89 ce             	mov    %rcx,%rsi
  802482:	89 c7                	mov    %eax,%edi
  802484:	48 b8 72 23 80 00 00 	movabs $0x802372,%rax
  80248b:	00 00 00 
  80248e:	ff d0                	callq  *%rax
  802490:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802493:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802497:	79 05                	jns    80249e <readn+0x57>
			return m;
  802499:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80249c:	eb 1c                	jmp    8024ba <readn+0x73>
		if (m == 0)
  80249e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024a2:	75 02                	jne    8024a6 <readn+0x5f>
			break;
  8024a4:	eb 11                	jmp    8024b7 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024a9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024af:	48 98                	cltq   
  8024b1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024b5:	72 ac                	jb     802463 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024ba:	c9                   	leaveq 
  8024bb:	c3                   	retq   

00000000008024bc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024bc:	55                   	push   %rbp
  8024bd:	48 89 e5             	mov    %rsp,%rbp
  8024c0:	48 83 ec 40          	sub    $0x40,%rsp
  8024c4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024c7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024cb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024cf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024d3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024d6:	48 89 d6             	mov    %rdx,%rsi
  8024d9:	89 c7                	mov    %eax,%edi
  8024db:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  8024e2:	00 00 00 
  8024e5:	ff d0                	callq  *%rax
  8024e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ee:	78 24                	js     802514 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f4:	8b 00                	mov    (%rax),%eax
  8024f6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024fa:	48 89 d6             	mov    %rdx,%rsi
  8024fd:	89 c7                	mov    %eax,%edi
  8024ff:	48 b8 99 20 80 00 00 	movabs $0x802099,%rax
  802506:	00 00 00 
  802509:	ff d0                	callq  *%rax
  80250b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802512:	79 05                	jns    802519 <write+0x5d>
		return r;
  802514:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802517:	eb 42                	jmp    80255b <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251d:	8b 40 08             	mov    0x8(%rax),%eax
  802520:	83 e0 03             	and    $0x3,%eax
  802523:	85 c0                	test   %eax,%eax
  802525:	75 07                	jne    80252e <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802527:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80252c:	eb 2d                	jmp    80255b <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80252e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802532:	48 8b 40 18          	mov    0x18(%rax),%rax
  802536:	48 85 c0             	test   %rax,%rax
  802539:	75 07                	jne    802542 <write+0x86>
		return -E_NOT_SUPP;
  80253b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802540:	eb 19                	jmp    80255b <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802542:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802546:	48 8b 40 18          	mov    0x18(%rax),%rax
  80254a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80254e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802552:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802556:	48 89 cf             	mov    %rcx,%rdi
  802559:	ff d0                	callq  *%rax
}
  80255b:	c9                   	leaveq 
  80255c:	c3                   	retq   

000000000080255d <seek>:

int
seek(int fdnum, off_t offset)
{
  80255d:	55                   	push   %rbp
  80255e:	48 89 e5             	mov    %rsp,%rbp
  802561:	48 83 ec 18          	sub    $0x18,%rsp
  802565:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802568:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80256b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80256f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802572:	48 89 d6             	mov    %rdx,%rsi
  802575:	89 c7                	mov    %eax,%edi
  802577:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  80257e:	00 00 00 
  802581:	ff d0                	callq  *%rax
  802583:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258a:	79 05                	jns    802591 <seek+0x34>
		return r;
  80258c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258f:	eb 0f                	jmp    8025a0 <seek+0x43>
	fd->fd_offset = offset;
  802591:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802595:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802598:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80259b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a0:	c9                   	leaveq 
  8025a1:	c3                   	retq   

00000000008025a2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025a2:	55                   	push   %rbp
  8025a3:	48 89 e5             	mov    %rsp,%rbp
  8025a6:	48 83 ec 30          	sub    $0x30,%rsp
  8025aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ad:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025b0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025b7:	48 89 d6             	mov    %rdx,%rsi
  8025ba:	89 c7                	mov    %eax,%edi
  8025bc:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  8025c3:	00 00 00 
  8025c6:	ff d0                	callq  *%rax
  8025c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025cf:	78 24                	js     8025f5 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d5:	8b 00                	mov    (%rax),%eax
  8025d7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025db:	48 89 d6             	mov    %rdx,%rsi
  8025de:	89 c7                	mov    %eax,%edi
  8025e0:	48 b8 99 20 80 00 00 	movabs $0x802099,%rax
  8025e7:	00 00 00 
  8025ea:	ff d0                	callq  *%rax
  8025ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f3:	79 05                	jns    8025fa <ftruncate+0x58>
		return r;
  8025f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f8:	eb 72                	jmp    80266c <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fe:	8b 40 08             	mov    0x8(%rax),%eax
  802601:	83 e0 03             	and    $0x3,%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	75 3a                	jne    802642 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802608:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80260f:	00 00 00 
  802612:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802615:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80261b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80261e:	89 c6                	mov    %eax,%esi
  802620:	48 bf 18 42 80 00 00 	movabs $0x804218,%rdi
  802627:	00 00 00 
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
  80262f:	48 b9 28 05 80 00 00 	movabs $0x800528,%rcx
  802636:	00 00 00 
  802639:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80263b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802640:	eb 2a                	jmp    80266c <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802642:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802646:	48 8b 40 30          	mov    0x30(%rax),%rax
  80264a:	48 85 c0             	test   %rax,%rax
  80264d:	75 07                	jne    802656 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80264f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802654:	eb 16                	jmp    80266c <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802656:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80265a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80265e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802662:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802665:	89 ce                	mov    %ecx,%esi
  802667:	48 89 d7             	mov    %rdx,%rdi
  80266a:	ff d0                	callq  *%rax
}
  80266c:	c9                   	leaveq 
  80266d:	c3                   	retq   

000000000080266e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80266e:	55                   	push   %rbp
  80266f:	48 89 e5             	mov    %rsp,%rbp
  802672:	48 83 ec 30          	sub    $0x30,%rsp
  802676:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802679:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80267d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802681:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802684:	48 89 d6             	mov    %rdx,%rsi
  802687:	89 c7                	mov    %eax,%edi
  802689:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  802690:	00 00 00 
  802693:	ff d0                	callq  *%rax
  802695:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802698:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269c:	78 24                	js     8026c2 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80269e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a2:	8b 00                	mov    (%rax),%eax
  8026a4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026a8:	48 89 d6             	mov    %rdx,%rsi
  8026ab:	89 c7                	mov    %eax,%edi
  8026ad:	48 b8 99 20 80 00 00 	movabs $0x802099,%rax
  8026b4:	00 00 00 
  8026b7:	ff d0                	callq  *%rax
  8026b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c0:	79 05                	jns    8026c7 <fstat+0x59>
		return r;
  8026c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c5:	eb 5e                	jmp    802725 <fstat+0xb7>
	if (!dev->dev_stat)
  8026c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026cb:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026cf:	48 85 c0             	test   %rax,%rax
  8026d2:	75 07                	jne    8026db <fstat+0x6d>
		return -E_NOT_SUPP;
  8026d4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026d9:	eb 4a                	jmp    802725 <fstat+0xb7>
	stat->st_name[0] = 0;
  8026db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026df:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026e6:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026ed:	00 00 00 
	stat->st_isdir = 0;
  8026f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026f4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026fb:	00 00 00 
	stat->st_dev = dev;
  8026fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802702:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802706:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80270d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802711:	48 8b 40 28          	mov    0x28(%rax),%rax
  802715:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802719:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80271d:	48 89 ce             	mov    %rcx,%rsi
  802720:	48 89 d7             	mov    %rdx,%rdi
  802723:	ff d0                	callq  *%rax
}
  802725:	c9                   	leaveq 
  802726:	c3                   	retq   

0000000000802727 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802727:	55                   	push   %rbp
  802728:	48 89 e5             	mov    %rsp,%rbp
  80272b:	48 83 ec 20          	sub    $0x20,%rsp
  80272f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802733:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80273b:	be 00 00 00 00       	mov    $0x0,%esi
  802740:	48 89 c7             	mov    %rax,%rdi
  802743:	48 b8 15 28 80 00 00 	movabs $0x802815,%rax
  80274a:	00 00 00 
  80274d:	ff d0                	callq  *%rax
  80274f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802752:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802756:	79 05                	jns    80275d <stat+0x36>
		return fd;
  802758:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275b:	eb 2f                	jmp    80278c <stat+0x65>
	r = fstat(fd, stat);
  80275d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802761:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802764:	48 89 d6             	mov    %rdx,%rsi
  802767:	89 c7                	mov    %eax,%edi
  802769:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  802770:	00 00 00 
  802773:	ff d0                	callq  *%rax
  802775:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802778:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277b:	89 c7                	mov    %eax,%edi
  80277d:	48 b8 50 21 80 00 00 	movabs $0x802150,%rax
  802784:	00 00 00 
  802787:	ff d0                	callq  *%rax
	return r;
  802789:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80278c:	c9                   	leaveq 
  80278d:	c3                   	retq   

000000000080278e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80278e:	55                   	push   %rbp
  80278f:	48 89 e5             	mov    %rsp,%rbp
  802792:	48 83 ec 10          	sub    $0x10,%rsp
  802796:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802799:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80279d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027a4:	00 00 00 
  8027a7:	8b 00                	mov    (%rax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	75 1d                	jne    8027ca <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027ad:	bf 01 00 00 00       	mov    $0x1,%edi
  8027b2:	48 b8 31 3b 80 00 00 	movabs $0x803b31,%rax
  8027b9:	00 00 00 
  8027bc:	ff d0                	callq  *%rax
  8027be:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8027c5:	00 00 00 
  8027c8:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8027ca:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027d1:	00 00 00 
  8027d4:	8b 00                	mov    (%rax),%eax
  8027d6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8027d9:	b9 07 00 00 00       	mov    $0x7,%ecx
  8027de:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8027e5:	00 00 00 
  8027e8:	89 c7                	mov    %eax,%edi
  8027ea:	48 b8 a9 3a 80 00 00 	movabs $0x803aa9,%rax
  8027f1:	00 00 00 
  8027f4:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ff:	48 89 c6             	mov    %rax,%rsi
  802802:	bf 00 00 00 00       	mov    $0x0,%edi
  802807:	48 b8 ab 39 80 00 00 	movabs $0x8039ab,%rax
  80280e:	00 00 00 
  802811:	ff d0                	callq  *%rax
}
  802813:	c9                   	leaveq 
  802814:	c3                   	retq   

0000000000802815 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802815:	55                   	push   %rbp
  802816:	48 89 e5             	mov    %rsp,%rbp
  802819:	48 83 ec 30          	sub    $0x30,%rsp
  80281d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802821:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802824:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80282b:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802832:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802839:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80283e:	75 08                	jne    802848 <open+0x33>
	{
		return r;
  802840:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802843:	e9 f2 00 00 00       	jmpq   80293a <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284c:	48 89 c7             	mov    %rax,%rdi
  80284f:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  802856:	00 00 00 
  802859:	ff d0                	callq  *%rax
  80285b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80285e:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802865:	7e 0a                	jle    802871 <open+0x5c>
	{
		return -E_BAD_PATH;
  802867:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80286c:	e9 c9 00 00 00       	jmpq   80293a <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802871:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802878:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802879:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80287d:	48 89 c7             	mov    %rax,%rdi
  802880:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802887:	00 00 00 
  80288a:	ff d0                	callq  *%rax
  80288c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802893:	78 09                	js     80289e <open+0x89>
  802895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802899:	48 85 c0             	test   %rax,%rax
  80289c:	75 08                	jne    8028a6 <open+0x91>
		{
			return r;
  80289e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a1:	e9 94 00 00 00       	jmpq   80293a <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8028a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028aa:	ba 00 04 00 00       	mov    $0x400,%edx
  8028af:	48 89 c6             	mov    %rax,%rsi
  8028b2:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8028b9:	00 00 00 
  8028bc:	48 b8 6f 11 80 00 00 	movabs $0x80116f,%rax
  8028c3:	00 00 00 
  8028c6:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8028c8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8028cf:	00 00 00 
  8028d2:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8028d5:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8028db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028df:	48 89 c6             	mov    %rax,%rsi
  8028e2:	bf 01 00 00 00       	mov    $0x1,%edi
  8028e7:	48 b8 8e 27 80 00 00 	movabs $0x80278e,%rax
  8028ee:	00 00 00 
  8028f1:	ff d0                	callq  *%rax
  8028f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fa:	79 2b                	jns    802927 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8028fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802900:	be 00 00 00 00       	mov    $0x0,%esi
  802905:	48 89 c7             	mov    %rax,%rdi
  802908:	48 b8 d0 1f 80 00 00 	movabs $0x801fd0,%rax
  80290f:	00 00 00 
  802912:	ff d0                	callq  *%rax
  802914:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802917:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80291b:	79 05                	jns    802922 <open+0x10d>
			{
				return d;
  80291d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802920:	eb 18                	jmp    80293a <open+0x125>
			}
			return r;
  802922:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802925:	eb 13                	jmp    80293a <open+0x125>
		}	
		return fd2num(fd_store);
  802927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292b:	48 89 c7             	mov    %rax,%rdi
  80292e:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  802935:	00 00 00 
  802938:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80293a:	c9                   	leaveq 
  80293b:	c3                   	retq   

000000000080293c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80293c:	55                   	push   %rbp
  80293d:	48 89 e5             	mov    %rsp,%rbp
  802940:	48 83 ec 10          	sub    $0x10,%rsp
  802944:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802948:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80294c:	8b 50 0c             	mov    0xc(%rax),%edx
  80294f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802956:	00 00 00 
  802959:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80295b:	be 00 00 00 00       	mov    $0x0,%esi
  802960:	bf 06 00 00 00       	mov    $0x6,%edi
  802965:	48 b8 8e 27 80 00 00 	movabs $0x80278e,%rax
  80296c:	00 00 00 
  80296f:	ff d0                	callq  *%rax
}
  802971:	c9                   	leaveq 
  802972:	c3                   	retq   

0000000000802973 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802973:	55                   	push   %rbp
  802974:	48 89 e5             	mov    %rsp,%rbp
  802977:	48 83 ec 30          	sub    $0x30,%rsp
  80297b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80297f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802983:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802987:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80298e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802993:	74 07                	je     80299c <devfile_read+0x29>
  802995:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80299a:	75 07                	jne    8029a3 <devfile_read+0x30>
		return -E_INVAL;
  80299c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029a1:	eb 77                	jmp    802a1a <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a7:	8b 50 0c             	mov    0xc(%rax),%edx
  8029aa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8029b1:	00 00 00 
  8029b4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8029bd:	00 00 00 
  8029c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029c4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8029c8:	be 00 00 00 00       	mov    $0x0,%esi
  8029cd:	bf 03 00 00 00       	mov    $0x3,%edi
  8029d2:	48 b8 8e 27 80 00 00 	movabs $0x80278e,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	callq  *%rax
  8029de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e5:	7f 05                	jg     8029ec <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8029e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ea:	eb 2e                	jmp    802a1a <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8029ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ef:	48 63 d0             	movslq %eax,%rdx
  8029f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f6:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8029fd:	00 00 00 
  802a00:	48 89 c7             	mov    %rax,%rdi
  802a03:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  802a0a:	00 00 00 
  802a0d:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802a0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802a17:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a1a:	c9                   	leaveq 
  802a1b:	c3                   	retq   

0000000000802a1c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a1c:	55                   	push   %rbp
  802a1d:	48 89 e5             	mov    %rsp,%rbp
  802a20:	48 83 ec 30          	sub    $0x30,%rsp
  802a24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a2c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802a30:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802a37:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a3c:	74 07                	je     802a45 <devfile_write+0x29>
  802a3e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a43:	75 08                	jne    802a4d <devfile_write+0x31>
		return r;
  802a45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a48:	e9 9a 00 00 00       	jmpq   802ae7 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a51:	8b 50 0c             	mov    0xc(%rax),%edx
  802a54:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802a5b:	00 00 00 
  802a5e:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802a60:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a67:	00 
  802a68:	76 08                	jbe    802a72 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802a6a:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a71:	00 
	}
	fsipcbuf.write.req_n = n;
  802a72:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802a79:	00 00 00 
  802a7c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a80:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802a84:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a8c:	48 89 c6             	mov    %rax,%rsi
  802a8f:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  802a96:	00 00 00 
  802a99:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  802aa0:	00 00 00 
  802aa3:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802aa5:	be 00 00 00 00       	mov    $0x0,%esi
  802aaa:	bf 04 00 00 00       	mov    $0x4,%edi
  802aaf:	48 b8 8e 27 80 00 00 	movabs $0x80278e,%rax
  802ab6:	00 00 00 
  802ab9:	ff d0                	callq  *%rax
  802abb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802abe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac2:	7f 20                	jg     802ae4 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802ac4:	48 bf 3e 42 80 00 00 	movabs $0x80423e,%rdi
  802acb:	00 00 00 
  802ace:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad3:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802ada:	00 00 00 
  802add:	ff d2                	callq  *%rdx
		return r;
  802adf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae2:	eb 03                	jmp    802ae7 <devfile_write+0xcb>
	}
	return r;
  802ae4:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802ae7:	c9                   	leaveq 
  802ae8:	c3                   	retq   

0000000000802ae9 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ae9:	55                   	push   %rbp
  802aea:	48 89 e5             	mov    %rsp,%rbp
  802aed:	48 83 ec 20          	sub    $0x20,%rsp
  802af1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802af5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802af9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afd:	8b 50 0c             	mov    0xc(%rax),%edx
  802b00:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b07:	00 00 00 
  802b0a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b0c:	be 00 00 00 00       	mov    $0x0,%esi
  802b11:	bf 05 00 00 00       	mov    $0x5,%edi
  802b16:	48 b8 8e 27 80 00 00 	movabs $0x80278e,%rax
  802b1d:	00 00 00 
  802b20:	ff d0                	callq  *%rax
  802b22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b29:	79 05                	jns    802b30 <devfile_stat+0x47>
		return r;
  802b2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2e:	eb 56                	jmp    802b86 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b34:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802b3b:	00 00 00 
  802b3e:	48 89 c7             	mov    %rax,%rdi
  802b41:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  802b48:	00 00 00 
  802b4b:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b4d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b54:	00 00 00 
  802b57:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b61:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b67:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b6e:	00 00 00 
  802b71:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b7b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b86:	c9                   	leaveq 
  802b87:	c3                   	retq   

0000000000802b88 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b88:	55                   	push   %rbp
  802b89:	48 89 e5             	mov    %rsp,%rbp
  802b8c:	48 83 ec 10          	sub    $0x10,%rsp
  802b90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b94:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b9b:	8b 50 0c             	mov    0xc(%rax),%edx
  802b9e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ba5:	00 00 00 
  802ba8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802baa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802bb1:	00 00 00 
  802bb4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802bb7:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802bba:	be 00 00 00 00       	mov    $0x0,%esi
  802bbf:	bf 02 00 00 00       	mov    $0x2,%edi
  802bc4:	48 b8 8e 27 80 00 00 	movabs $0x80278e,%rax
  802bcb:	00 00 00 
  802bce:	ff d0                	callq  *%rax
}
  802bd0:	c9                   	leaveq 
  802bd1:	c3                   	retq   

0000000000802bd2 <remove>:

// Delete a file
int
remove(const char *path)
{
  802bd2:	55                   	push   %rbp
  802bd3:	48 89 e5             	mov    %rsp,%rbp
  802bd6:	48 83 ec 10          	sub    $0x10,%rsp
  802bda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802bde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802be2:	48 89 c7             	mov    %rax,%rdi
  802be5:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  802bec:	00 00 00 
  802bef:	ff d0                	callq  *%rax
  802bf1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bf6:	7e 07                	jle    802bff <remove+0x2d>
		return -E_BAD_PATH;
  802bf8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bfd:	eb 33                	jmp    802c32 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802bff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c03:	48 89 c6             	mov    %rax,%rsi
  802c06:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802c0d:	00 00 00 
  802c10:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  802c17:	00 00 00 
  802c1a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c1c:	be 00 00 00 00       	mov    $0x0,%esi
  802c21:	bf 07 00 00 00       	mov    $0x7,%edi
  802c26:	48 b8 8e 27 80 00 00 	movabs $0x80278e,%rax
  802c2d:	00 00 00 
  802c30:	ff d0                	callq  *%rax
}
  802c32:	c9                   	leaveq 
  802c33:	c3                   	retq   

0000000000802c34 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c34:	55                   	push   %rbp
  802c35:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c38:	be 00 00 00 00       	mov    $0x0,%esi
  802c3d:	bf 08 00 00 00       	mov    $0x8,%edi
  802c42:	48 b8 8e 27 80 00 00 	movabs $0x80278e,%rax
  802c49:	00 00 00 
  802c4c:	ff d0                	callq  *%rax
}
  802c4e:	5d                   	pop    %rbp
  802c4f:	c3                   	retq   

0000000000802c50 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c50:	55                   	push   %rbp
  802c51:	48 89 e5             	mov    %rsp,%rbp
  802c54:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c5b:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c62:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c69:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c70:	be 00 00 00 00       	mov    $0x0,%esi
  802c75:	48 89 c7             	mov    %rax,%rdi
  802c78:	48 b8 15 28 80 00 00 	movabs $0x802815,%rax
  802c7f:	00 00 00 
  802c82:	ff d0                	callq  *%rax
  802c84:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8b:	79 28                	jns    802cb5 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c90:	89 c6                	mov    %eax,%esi
  802c92:	48 bf 5a 42 80 00 00 	movabs $0x80425a,%rdi
  802c99:	00 00 00 
  802c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca1:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802ca8:	00 00 00 
  802cab:	ff d2                	callq  *%rdx
		return fd_src;
  802cad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb0:	e9 74 01 00 00       	jmpq   802e29 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802cb5:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802cbc:	be 01 01 00 00       	mov    $0x101,%esi
  802cc1:	48 89 c7             	mov    %rax,%rdi
  802cc4:	48 b8 15 28 80 00 00 	movabs $0x802815,%rax
  802ccb:	00 00 00 
  802cce:	ff d0                	callq  *%rax
  802cd0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802cd3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cd7:	79 39                	jns    802d12 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802cd9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cdc:	89 c6                	mov    %eax,%esi
  802cde:	48 bf 70 42 80 00 00 	movabs $0x804270,%rdi
  802ce5:	00 00 00 
  802ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ced:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802cf4:	00 00 00 
  802cf7:	ff d2                	callq  *%rdx
		close(fd_src);
  802cf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfc:	89 c7                	mov    %eax,%edi
  802cfe:	48 b8 50 21 80 00 00 	movabs $0x802150,%rax
  802d05:	00 00 00 
  802d08:	ff d0                	callq  *%rax
		return fd_dest;
  802d0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d0d:	e9 17 01 00 00       	jmpq   802e29 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d12:	eb 74                	jmp    802d88 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d14:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d17:	48 63 d0             	movslq %eax,%rdx
  802d1a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d24:	48 89 ce             	mov    %rcx,%rsi
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	48 b8 bc 24 80 00 00 	movabs $0x8024bc,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
  802d35:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d38:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d3c:	79 4a                	jns    802d88 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d3e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d41:	89 c6                	mov    %eax,%esi
  802d43:	48 bf 8a 42 80 00 00 	movabs $0x80428a,%rdi
  802d4a:	00 00 00 
  802d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d52:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802d59:	00 00 00 
  802d5c:	ff d2                	callq  *%rdx
			close(fd_src);
  802d5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d61:	89 c7                	mov    %eax,%edi
  802d63:	48 b8 50 21 80 00 00 	movabs $0x802150,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
			close(fd_dest);
  802d6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d72:	89 c7                	mov    %eax,%edi
  802d74:	48 b8 50 21 80 00 00 	movabs $0x802150,%rax
  802d7b:	00 00 00 
  802d7e:	ff d0                	callq  *%rax
			return write_size;
  802d80:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d83:	e9 a1 00 00 00       	jmpq   802e29 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d88:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d92:	ba 00 02 00 00       	mov    $0x200,%edx
  802d97:	48 89 ce             	mov    %rcx,%rsi
  802d9a:	89 c7                	mov    %eax,%edi
  802d9c:	48 b8 72 23 80 00 00 	movabs $0x802372,%rax
  802da3:	00 00 00 
  802da6:	ff d0                	callq  *%rax
  802da8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802dab:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802daf:	0f 8f 5f ff ff ff    	jg     802d14 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802db5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802db9:	79 47                	jns    802e02 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802dbb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dbe:	89 c6                	mov    %eax,%esi
  802dc0:	48 bf 9d 42 80 00 00 	movabs $0x80429d,%rdi
  802dc7:	00 00 00 
  802dca:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcf:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802dd6:	00 00 00 
  802dd9:	ff d2                	callq  *%rdx
		close(fd_src);
  802ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dde:	89 c7                	mov    %eax,%edi
  802de0:	48 b8 50 21 80 00 00 	movabs $0x802150,%rax
  802de7:	00 00 00 
  802dea:	ff d0                	callq  *%rax
		close(fd_dest);
  802dec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802def:	89 c7                	mov    %eax,%edi
  802df1:	48 b8 50 21 80 00 00 	movabs $0x802150,%rax
  802df8:	00 00 00 
  802dfb:	ff d0                	callq  *%rax
		return read_size;
  802dfd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e00:	eb 27                	jmp    802e29 <copy+0x1d9>
	}
	close(fd_src);
  802e02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e05:	89 c7                	mov    %eax,%edi
  802e07:	48 b8 50 21 80 00 00 	movabs $0x802150,%rax
  802e0e:	00 00 00 
  802e11:	ff d0                	callq  *%rax
	close(fd_dest);
  802e13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e16:	89 c7                	mov    %eax,%edi
  802e18:	48 b8 50 21 80 00 00 	movabs $0x802150,%rax
  802e1f:	00 00 00 
  802e22:	ff d0                	callq  *%rax
	return 0;
  802e24:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e29:	c9                   	leaveq 
  802e2a:	c3                   	retq   

0000000000802e2b <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802e2b:	55                   	push   %rbp
  802e2c:	48 89 e5             	mov    %rsp,%rbp
  802e2f:	48 83 ec 20          	sub    $0x20,%rsp
  802e33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802e37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3b:	8b 40 0c             	mov    0xc(%rax),%eax
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	7e 67                	jle    802ea9 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802e42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e46:	8b 40 04             	mov    0x4(%rax),%eax
  802e49:	48 63 d0             	movslq %eax,%rdx
  802e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e50:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802e54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e58:	8b 00                	mov    (%rax),%eax
  802e5a:	48 89 ce             	mov    %rcx,%rsi
  802e5d:	89 c7                	mov    %eax,%edi
  802e5f:	48 b8 bc 24 80 00 00 	movabs $0x8024bc,%rax
  802e66:	00 00 00 
  802e69:	ff d0                	callq  *%rax
  802e6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802e6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e72:	7e 13                	jle    802e87 <writebuf+0x5c>
			b->result += result;
  802e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e78:	8b 50 08             	mov    0x8(%rax),%edx
  802e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7e:	01 c2                	add    %eax,%edx
  802e80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e84:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8b:	8b 40 04             	mov    0x4(%rax),%eax
  802e8e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e91:	74 16                	je     802ea9 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802e93:	b8 00 00 00 00       	mov    $0x0,%eax
  802e98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9c:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802ea0:	89 c2                	mov    %eax,%edx
  802ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea6:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802ea9:	c9                   	leaveq 
  802eaa:	c3                   	retq   

0000000000802eab <putch>:

static void
putch(int ch, void *thunk)
{
  802eab:	55                   	push   %rbp
  802eac:	48 89 e5             	mov    %rsp,%rbp
  802eaf:	48 83 ec 20          	sub    $0x20,%rsp
  802eb3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802eb6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802eba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ebe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802ec2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec6:	8b 40 04             	mov    0x4(%rax),%eax
  802ec9:	8d 48 01             	lea    0x1(%rax),%ecx
  802ecc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ed0:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802ed3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ed6:	89 d1                	mov    %edx,%ecx
  802ed8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802edc:	48 98                	cltq   
  802ede:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802ee2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee6:	8b 40 04             	mov    0x4(%rax),%eax
  802ee9:	3d 00 01 00 00       	cmp    $0x100,%eax
  802eee:	75 1e                	jne    802f0e <putch+0x63>
		writebuf(b);
  802ef0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ef4:	48 89 c7             	mov    %rax,%rdi
  802ef7:	48 b8 2b 2e 80 00 00 	movabs $0x802e2b,%rax
  802efe:	00 00 00 
  802f01:	ff d0                	callq  *%rax
		b->idx = 0;
  802f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802f0e:	c9                   	leaveq 
  802f0f:	c3                   	retq   

0000000000802f10 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802f10:	55                   	push   %rbp
  802f11:	48 89 e5             	mov    %rsp,%rbp
  802f14:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802f1b:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802f21:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802f28:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802f2f:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802f35:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802f3b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802f42:	00 00 00 
	b.result = 0;
  802f45:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802f4c:	00 00 00 
	b.error = 1;
  802f4f:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802f56:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802f59:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802f60:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802f67:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f6e:	48 89 c6             	mov    %rax,%rsi
  802f71:	48 bf ab 2e 80 00 00 	movabs $0x802eab,%rdi
  802f78:	00 00 00 
  802f7b:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802f87:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	7e 16                	jle    802fa7 <vfprintf+0x97>
		writebuf(&b);
  802f91:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f98:	48 89 c7             	mov    %rax,%rdi
  802f9b:	48 b8 2b 2e 80 00 00 	movabs $0x802e2b,%rax
  802fa2:	00 00 00 
  802fa5:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802fa7:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802fad:	85 c0                	test   %eax,%eax
  802faf:	74 08                	je     802fb9 <vfprintf+0xa9>
  802fb1:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802fb7:	eb 06                	jmp    802fbf <vfprintf+0xaf>
  802fb9:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802fbf:	c9                   	leaveq 
  802fc0:	c3                   	retq   

0000000000802fc1 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802fc1:	55                   	push   %rbp
  802fc2:	48 89 e5             	mov    %rsp,%rbp
  802fc5:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802fcc:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802fd2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802fd9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fe0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fe7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fee:	84 c0                	test   %al,%al
  802ff0:	74 20                	je     803012 <fprintf+0x51>
  802ff2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802ff6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802ffa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802ffe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803002:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803006:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80300a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80300e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803012:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803019:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803020:	00 00 00 
  803023:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80302a:	00 00 00 
  80302d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803031:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803038:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80303f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  803046:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80304d:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  803054:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80305a:	48 89 ce             	mov    %rcx,%rsi
  80305d:	89 c7                	mov    %eax,%edi
  80305f:	48 b8 10 2f 80 00 00 	movabs $0x802f10,%rax
  803066:	00 00 00 
  803069:	ff d0                	callq  *%rax
  80306b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803071:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803077:	c9                   	leaveq 
  803078:	c3                   	retq   

0000000000803079 <printf>:

int
printf(const char *fmt, ...)
{
  803079:	55                   	push   %rbp
  80307a:	48 89 e5             	mov    %rsp,%rbp
  80307d:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803084:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80308b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803092:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803099:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8030a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8030a7:	84 c0                	test   %al,%al
  8030a9:	74 20                	je     8030cb <printf+0x52>
  8030ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8030af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8030b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8030b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8030bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8030bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8030c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8030c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8030cb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8030d2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8030d9:	00 00 00 
  8030dc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8030e3:	00 00 00 
  8030e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030f8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8030ff:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803106:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80310d:	48 89 c6             	mov    %rax,%rsi
  803110:	bf 01 00 00 00       	mov    $0x1,%edi
  803115:	48 b8 10 2f 80 00 00 	movabs $0x802f10,%rax
  80311c:	00 00 00 
  80311f:	ff d0                	callq  *%rax
  803121:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803127:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80312d:	c9                   	leaveq 
  80312e:	c3                   	retq   

000000000080312f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80312f:	55                   	push   %rbp
  803130:	48 89 e5             	mov    %rsp,%rbp
  803133:	53                   	push   %rbx
  803134:	48 83 ec 38          	sub    $0x38,%rsp
  803138:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80313c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803140:	48 89 c7             	mov    %rax,%rdi
  803143:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  80314a:	00 00 00 
  80314d:	ff d0                	callq  *%rax
  80314f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803152:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803156:	0f 88 bf 01 00 00    	js     80331b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80315c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803160:	ba 07 04 00 00       	mov    $0x407,%edx
  803165:	48 89 c6             	mov    %rax,%rsi
  803168:	bf 00 00 00 00       	mov    $0x0,%edi
  80316d:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  803174:	00 00 00 
  803177:	ff d0                	callq  *%rax
  803179:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80317c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803180:	0f 88 95 01 00 00    	js     80331b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803186:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80318a:	48 89 c7             	mov    %rax,%rdi
  80318d:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
  803199:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80319c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031a0:	0f 88 5d 01 00 00    	js     803303 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8031af:	48 89 c6             	mov    %rax,%rsi
  8031b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b7:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
  8031c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031ca:	0f 88 33 01 00 00    	js     803303 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8031d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d4:	48 89 c7             	mov    %rax,%rdi
  8031d7:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  8031de:	00 00 00 
  8031e1:	ff d0                	callq  *%rax
  8031e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031eb:	ba 07 04 00 00       	mov    $0x407,%edx
  8031f0:	48 89 c6             	mov    %rax,%rsi
  8031f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8031f8:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  8031ff:	00 00 00 
  803202:	ff d0                	callq  *%rax
  803204:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803207:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80320b:	79 05                	jns    803212 <pipe+0xe3>
		goto err2;
  80320d:	e9 d9 00 00 00       	jmpq   8032eb <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803212:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803216:	48 89 c7             	mov    %rax,%rdi
  803219:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  803220:	00 00 00 
  803223:	ff d0                	callq  *%rax
  803225:	48 89 c2             	mov    %rax,%rdx
  803228:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80322c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803232:	48 89 d1             	mov    %rdx,%rcx
  803235:	ba 00 00 00 00       	mov    $0x0,%edx
  80323a:	48 89 c6             	mov    %rax,%rsi
  80323d:	bf 00 00 00 00       	mov    $0x0,%edi
  803242:	48 b8 5c 1a 80 00 00 	movabs $0x801a5c,%rax
  803249:	00 00 00 
  80324c:	ff d0                	callq  *%rax
  80324e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803251:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803255:	79 1b                	jns    803272 <pipe+0x143>
		goto err3;
  803257:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803258:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80325c:	48 89 c6             	mov    %rax,%rsi
  80325f:	bf 00 00 00 00       	mov    $0x0,%edi
  803264:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  80326b:	00 00 00 
  80326e:	ff d0                	callq  *%rax
  803270:	eb 79                	jmp    8032eb <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803272:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803276:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80327d:	00 00 00 
  803280:	8b 12                	mov    (%rdx),%edx
  803282:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803284:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803288:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80328f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803293:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80329a:	00 00 00 
  80329d:	8b 12                	mov    (%rdx),%edx
  80329f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8032a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032a5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8032ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b0:	48 89 c7             	mov    %rax,%rdi
  8032b3:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  8032ba:	00 00 00 
  8032bd:	ff d0                	callq  *%rax
  8032bf:	89 c2                	mov    %eax,%edx
  8032c1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032c5:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8032c7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032cb:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8032cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032d3:	48 89 c7             	mov    %rax,%rdi
  8032d6:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  8032dd:	00 00 00 
  8032e0:	ff d0                	callq  *%rax
  8032e2:	89 03                	mov    %eax,(%rbx)
	return 0;
  8032e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e9:	eb 33                	jmp    80331e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8032eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ef:	48 89 c6             	mov    %rax,%rsi
  8032f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f7:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  8032fe:	00 00 00 
  803301:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803303:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803307:	48 89 c6             	mov    %rax,%rsi
  80330a:	bf 00 00 00 00       	mov    $0x0,%edi
  80330f:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  803316:	00 00 00 
  803319:	ff d0                	callq  *%rax
err:
	return r;
  80331b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80331e:	48 83 c4 38          	add    $0x38,%rsp
  803322:	5b                   	pop    %rbx
  803323:	5d                   	pop    %rbp
  803324:	c3                   	retq   

0000000000803325 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803325:	55                   	push   %rbp
  803326:	48 89 e5             	mov    %rsp,%rbp
  803329:	53                   	push   %rbx
  80332a:	48 83 ec 28          	sub    $0x28,%rsp
  80332e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803332:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803336:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80333d:	00 00 00 
  803340:	48 8b 00             	mov    (%rax),%rax
  803343:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803349:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80334c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803350:	48 89 c7             	mov    %rax,%rdi
  803353:	48 b8 a3 3b 80 00 00 	movabs $0x803ba3,%rax
  80335a:	00 00 00 
  80335d:	ff d0                	callq  *%rax
  80335f:	89 c3                	mov    %eax,%ebx
  803361:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803365:	48 89 c7             	mov    %rax,%rdi
  803368:	48 b8 a3 3b 80 00 00 	movabs $0x803ba3,%rax
  80336f:	00 00 00 
  803372:	ff d0                	callq  *%rax
  803374:	39 c3                	cmp    %eax,%ebx
  803376:	0f 94 c0             	sete   %al
  803379:	0f b6 c0             	movzbl %al,%eax
  80337c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80337f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803386:	00 00 00 
  803389:	48 8b 00             	mov    (%rax),%rax
  80338c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803392:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803395:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803398:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80339b:	75 05                	jne    8033a2 <_pipeisclosed+0x7d>
			return ret;
  80339d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033a0:	eb 4f                	jmp    8033f1 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8033a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033a5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8033a8:	74 42                	je     8033ec <_pipeisclosed+0xc7>
  8033aa:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8033ae:	75 3c                	jne    8033ec <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8033b0:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8033b7:	00 00 00 
  8033ba:	48 8b 00             	mov    (%rax),%rax
  8033bd:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8033c3:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8033c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033c9:	89 c6                	mov    %eax,%esi
  8033cb:	48 bf bd 42 80 00 00 	movabs $0x8042bd,%rdi
  8033d2:	00 00 00 
  8033d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033da:	49 b8 28 05 80 00 00 	movabs $0x800528,%r8
  8033e1:	00 00 00 
  8033e4:	41 ff d0             	callq  *%r8
	}
  8033e7:	e9 4a ff ff ff       	jmpq   803336 <_pipeisclosed+0x11>
  8033ec:	e9 45 ff ff ff       	jmpq   803336 <_pipeisclosed+0x11>
}
  8033f1:	48 83 c4 28          	add    $0x28,%rsp
  8033f5:	5b                   	pop    %rbx
  8033f6:	5d                   	pop    %rbp
  8033f7:	c3                   	retq   

00000000008033f8 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8033f8:	55                   	push   %rbp
  8033f9:	48 89 e5             	mov    %rsp,%rbp
  8033fc:	48 83 ec 30          	sub    $0x30,%rsp
  803400:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803403:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803407:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80340a:	48 89 d6             	mov    %rdx,%rsi
  80340d:	89 c7                	mov    %eax,%edi
  80340f:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  803416:	00 00 00 
  803419:	ff d0                	callq  *%rax
  80341b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80341e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803422:	79 05                	jns    803429 <pipeisclosed+0x31>
		return r;
  803424:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803427:	eb 31                	jmp    80345a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80342d:	48 89 c7             	mov    %rax,%rdi
  803430:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  803437:	00 00 00 
  80343a:	ff d0                	callq  *%rax
  80343c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803440:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803444:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803448:	48 89 d6             	mov    %rdx,%rsi
  80344b:	48 89 c7             	mov    %rax,%rdi
  80344e:	48 b8 25 33 80 00 00 	movabs $0x803325,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
}
  80345a:	c9                   	leaveq 
  80345b:	c3                   	retq   

000000000080345c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80345c:	55                   	push   %rbp
  80345d:	48 89 e5             	mov    %rsp,%rbp
  803460:	48 83 ec 40          	sub    $0x40,%rsp
  803464:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803468:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80346c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803470:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803474:	48 89 c7             	mov    %rax,%rdi
  803477:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  80347e:	00 00 00 
  803481:	ff d0                	callq  *%rax
  803483:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803487:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80348b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80348f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803496:	00 
  803497:	e9 92 00 00 00       	jmpq   80352e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80349c:	eb 41                	jmp    8034df <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80349e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8034a3:	74 09                	je     8034ae <devpipe_read+0x52>
				return i;
  8034a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a9:	e9 92 00 00 00       	jmpq   803540 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8034ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034b6:	48 89 d6             	mov    %rdx,%rsi
  8034b9:	48 89 c7             	mov    %rax,%rdi
  8034bc:	48 b8 25 33 80 00 00 	movabs $0x803325,%rax
  8034c3:	00 00 00 
  8034c6:	ff d0                	callq  *%rax
  8034c8:	85 c0                	test   %eax,%eax
  8034ca:	74 07                	je     8034d3 <devpipe_read+0x77>
				return 0;
  8034cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d1:	eb 6d                	jmp    803540 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8034d3:	48 b8 ce 19 80 00 00 	movabs $0x8019ce,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8034df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e3:	8b 10                	mov    (%rax),%edx
  8034e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e9:	8b 40 04             	mov    0x4(%rax),%eax
  8034ec:	39 c2                	cmp    %eax,%edx
  8034ee:	74 ae                	je     80349e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8034f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034f8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8034fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803500:	8b 00                	mov    (%rax),%eax
  803502:	99                   	cltd   
  803503:	c1 ea 1b             	shr    $0x1b,%edx
  803506:	01 d0                	add    %edx,%eax
  803508:	83 e0 1f             	and    $0x1f,%eax
  80350b:	29 d0                	sub    %edx,%eax
  80350d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803511:	48 98                	cltq   
  803513:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803518:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80351a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351e:	8b 00                	mov    (%rax),%eax
  803520:	8d 50 01             	lea    0x1(%rax),%edx
  803523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803527:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803529:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80352e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803532:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803536:	0f 82 60 ff ff ff    	jb     80349c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80353c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803540:	c9                   	leaveq 
  803541:	c3                   	retq   

0000000000803542 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803542:	55                   	push   %rbp
  803543:	48 89 e5             	mov    %rsp,%rbp
  803546:	48 83 ec 40          	sub    $0x40,%rsp
  80354a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80354e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803552:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803556:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80355a:	48 89 c7             	mov    %rax,%rdi
  80355d:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  803564:	00 00 00 
  803567:	ff d0                	callq  *%rax
  803569:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80356d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803571:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803575:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80357c:	00 
  80357d:	e9 8e 00 00 00       	jmpq   803610 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803582:	eb 31                	jmp    8035b5 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803584:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80358c:	48 89 d6             	mov    %rdx,%rsi
  80358f:	48 89 c7             	mov    %rax,%rdi
  803592:	48 b8 25 33 80 00 00 	movabs $0x803325,%rax
  803599:	00 00 00 
  80359c:	ff d0                	callq  *%rax
  80359e:	85 c0                	test   %eax,%eax
  8035a0:	74 07                	je     8035a9 <devpipe_write+0x67>
				return 0;
  8035a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a7:	eb 79                	jmp    803622 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8035a9:	48 b8 ce 19 80 00 00 	movabs $0x8019ce,%rax
  8035b0:	00 00 00 
  8035b3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b9:	8b 40 04             	mov    0x4(%rax),%eax
  8035bc:	48 63 d0             	movslq %eax,%rdx
  8035bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c3:	8b 00                	mov    (%rax),%eax
  8035c5:	48 98                	cltq   
  8035c7:	48 83 c0 20          	add    $0x20,%rax
  8035cb:	48 39 c2             	cmp    %rax,%rdx
  8035ce:	73 b4                	jae    803584 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8035d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d4:	8b 40 04             	mov    0x4(%rax),%eax
  8035d7:	99                   	cltd   
  8035d8:	c1 ea 1b             	shr    $0x1b,%edx
  8035db:	01 d0                	add    %edx,%eax
  8035dd:	83 e0 1f             	and    $0x1f,%eax
  8035e0:	29 d0                	sub    %edx,%eax
  8035e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035e6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8035ea:	48 01 ca             	add    %rcx,%rdx
  8035ed:	0f b6 0a             	movzbl (%rdx),%ecx
  8035f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035f4:	48 98                	cltq   
  8035f6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8035fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fe:	8b 40 04             	mov    0x4(%rax),%eax
  803601:	8d 50 01             	lea    0x1(%rax),%edx
  803604:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803608:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80360b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803614:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803618:	0f 82 64 ff ff ff    	jb     803582 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80361e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803622:	c9                   	leaveq 
  803623:	c3                   	retq   

0000000000803624 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803624:	55                   	push   %rbp
  803625:	48 89 e5             	mov    %rsp,%rbp
  803628:	48 83 ec 20          	sub    $0x20,%rsp
  80362c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803630:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803638:	48 89 c7             	mov    %rax,%rdi
  80363b:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  803642:	00 00 00 
  803645:	ff d0                	callq  *%rax
  803647:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80364b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80364f:	48 be d0 42 80 00 00 	movabs $0x8042d0,%rsi
  803656:	00 00 00 
  803659:	48 89 c7             	mov    %rax,%rdi
  80365c:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  803663:	00 00 00 
  803666:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803668:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80366c:	8b 50 04             	mov    0x4(%rax),%edx
  80366f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803673:	8b 00                	mov    (%rax),%eax
  803675:	29 c2                	sub    %eax,%edx
  803677:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80367b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803681:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803685:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80368c:	00 00 00 
	stat->st_dev = &devpipe;
  80368f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803693:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  80369a:	00 00 00 
  80369d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8036a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036a9:	c9                   	leaveq 
  8036aa:	c3                   	retq   

00000000008036ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8036ab:	55                   	push   %rbp
  8036ac:	48 89 e5             	mov    %rsp,%rbp
  8036af:	48 83 ec 10          	sub    $0x10,%rsp
  8036b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8036b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036bb:	48 89 c6             	mov    %rax,%rsi
  8036be:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c3:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  8036ca:	00 00 00 
  8036cd:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8036cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d3:	48 89 c7             	mov    %rax,%rdi
  8036d6:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  8036dd:	00 00 00 
  8036e0:	ff d0                	callq  *%rax
  8036e2:	48 89 c6             	mov    %rax,%rsi
  8036e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ea:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  8036f1:	00 00 00 
  8036f4:	ff d0                	callq  *%rax
}
  8036f6:	c9                   	leaveq 
  8036f7:	c3                   	retq   

00000000008036f8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8036f8:	55                   	push   %rbp
  8036f9:	48 89 e5             	mov    %rsp,%rbp
  8036fc:	48 83 ec 20          	sub    $0x20,%rsp
  803700:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803703:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803706:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803709:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80370d:	be 01 00 00 00       	mov    $0x1,%esi
  803712:	48 89 c7             	mov    %rax,%rdi
  803715:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  80371c:	00 00 00 
  80371f:	ff d0                	callq  *%rax
}
  803721:	c9                   	leaveq 
  803722:	c3                   	retq   

0000000000803723 <getchar>:

int
getchar(void)
{
  803723:	55                   	push   %rbp
  803724:	48 89 e5             	mov    %rsp,%rbp
  803727:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80372b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80372f:	ba 01 00 00 00       	mov    $0x1,%edx
  803734:	48 89 c6             	mov    %rax,%rsi
  803737:	bf 00 00 00 00       	mov    $0x0,%edi
  80373c:	48 b8 72 23 80 00 00 	movabs $0x802372,%rax
  803743:	00 00 00 
  803746:	ff d0                	callq  *%rax
  803748:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80374b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374f:	79 05                	jns    803756 <getchar+0x33>
		return r;
  803751:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803754:	eb 14                	jmp    80376a <getchar+0x47>
	if (r < 1)
  803756:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80375a:	7f 07                	jg     803763 <getchar+0x40>
		return -E_EOF;
  80375c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803761:	eb 07                	jmp    80376a <getchar+0x47>
	return c;
  803763:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803767:	0f b6 c0             	movzbl %al,%eax
}
  80376a:	c9                   	leaveq 
  80376b:	c3                   	retq   

000000000080376c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80376c:	55                   	push   %rbp
  80376d:	48 89 e5             	mov    %rsp,%rbp
  803770:	48 83 ec 20          	sub    $0x20,%rsp
  803774:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803777:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80377b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80377e:	48 89 d6             	mov    %rdx,%rsi
  803781:	89 c7                	mov    %eax,%edi
  803783:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  80378a:	00 00 00 
  80378d:	ff d0                	callq  *%rax
  80378f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803792:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803796:	79 05                	jns    80379d <iscons+0x31>
		return r;
  803798:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379b:	eb 1a                	jmp    8037b7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80379d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a1:	8b 10                	mov    (%rax),%edx
  8037a3:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8037aa:	00 00 00 
  8037ad:	8b 00                	mov    (%rax),%eax
  8037af:	39 c2                	cmp    %eax,%edx
  8037b1:	0f 94 c0             	sete   %al
  8037b4:	0f b6 c0             	movzbl %al,%eax
}
  8037b7:	c9                   	leaveq 
  8037b8:	c3                   	retq   

00000000008037b9 <opencons>:

int
opencons(void)
{
  8037b9:	55                   	push   %rbp
  8037ba:	48 89 e5             	mov    %rsp,%rbp
  8037bd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8037c1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8037c5:	48 89 c7             	mov    %rax,%rdi
  8037c8:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  8037cf:	00 00 00 
  8037d2:	ff d0                	callq  *%rax
  8037d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037db:	79 05                	jns    8037e2 <opencons+0x29>
		return r;
  8037dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e0:	eb 5b                	jmp    80383d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8037e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e6:	ba 07 04 00 00       	mov    $0x407,%edx
  8037eb:	48 89 c6             	mov    %rax,%rsi
  8037ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f3:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  8037fa:	00 00 00 
  8037fd:	ff d0                	callq  *%rax
  8037ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803802:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803806:	79 05                	jns    80380d <opencons+0x54>
		return r;
  803808:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80380b:	eb 30                	jmp    80383d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80380d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803811:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803818:	00 00 00 
  80381b:	8b 12                	mov    (%rdx),%edx
  80381d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80381f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803823:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80382a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80382e:	48 89 c7             	mov    %rax,%rdi
  803831:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  803838:	00 00 00 
  80383b:	ff d0                	callq  *%rax
}
  80383d:	c9                   	leaveq 
  80383e:	c3                   	retq   

000000000080383f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80383f:	55                   	push   %rbp
  803840:	48 89 e5             	mov    %rsp,%rbp
  803843:	48 83 ec 30          	sub    $0x30,%rsp
  803847:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80384b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80384f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803853:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803858:	75 07                	jne    803861 <devcons_read+0x22>
		return 0;
  80385a:	b8 00 00 00 00       	mov    $0x0,%eax
  80385f:	eb 4b                	jmp    8038ac <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803861:	eb 0c                	jmp    80386f <devcons_read+0x30>
		sys_yield();
  803863:	48 b8 ce 19 80 00 00 	movabs $0x8019ce,%rax
  80386a:	00 00 00 
  80386d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80386f:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  803876:	00 00 00 
  803879:	ff d0                	callq  *%rax
  80387b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80387e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803882:	74 df                	je     803863 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803884:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803888:	79 05                	jns    80388f <devcons_read+0x50>
		return c;
  80388a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388d:	eb 1d                	jmp    8038ac <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80388f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803893:	75 07                	jne    80389c <devcons_read+0x5d>
		return 0;
  803895:	b8 00 00 00 00       	mov    $0x0,%eax
  80389a:	eb 10                	jmp    8038ac <devcons_read+0x6d>
	*(char*)vbuf = c;
  80389c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80389f:	89 c2                	mov    %eax,%edx
  8038a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038a5:	88 10                	mov    %dl,(%rax)
	return 1;
  8038a7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8038ac:	c9                   	leaveq 
  8038ad:	c3                   	retq   

00000000008038ae <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038ae:	55                   	push   %rbp
  8038af:	48 89 e5             	mov    %rsp,%rbp
  8038b2:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8038b9:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8038c0:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8038c7:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8038ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038d5:	eb 76                	jmp    80394d <devcons_write+0x9f>
		m = n - tot;
  8038d7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8038de:	89 c2                	mov    %eax,%edx
  8038e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e3:	29 c2                	sub    %eax,%edx
  8038e5:	89 d0                	mov    %edx,%eax
  8038e7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8038ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038ed:	83 f8 7f             	cmp    $0x7f,%eax
  8038f0:	76 07                	jbe    8038f9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8038f2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8038f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038fc:	48 63 d0             	movslq %eax,%rdx
  8038ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803902:	48 63 c8             	movslq %eax,%rcx
  803905:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80390c:	48 01 c1             	add    %rax,%rcx
  80390f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803916:	48 89 ce             	mov    %rcx,%rsi
  803919:	48 89 c7             	mov    %rax,%rdi
  80391c:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  803923:	00 00 00 
  803926:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803928:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80392b:	48 63 d0             	movslq %eax,%rdx
  80392e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803935:	48 89 d6             	mov    %rdx,%rsi
  803938:	48 89 c7             	mov    %rax,%rdi
  80393b:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  803942:	00 00 00 
  803945:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803947:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80394a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80394d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803950:	48 98                	cltq   
  803952:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803959:	0f 82 78 ff ff ff    	jb     8038d7 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80395f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803962:	c9                   	leaveq 
  803963:	c3                   	retq   

0000000000803964 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803964:	55                   	push   %rbp
  803965:	48 89 e5             	mov    %rsp,%rbp
  803968:	48 83 ec 08          	sub    $0x8,%rsp
  80396c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803970:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803975:	c9                   	leaveq 
  803976:	c3                   	retq   

0000000000803977 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803977:	55                   	push   %rbp
  803978:	48 89 e5             	mov    %rsp,%rbp
  80397b:	48 83 ec 10          	sub    $0x10,%rsp
  80397f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803983:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803987:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398b:	48 be dc 42 80 00 00 	movabs $0x8042dc,%rsi
  803992:	00 00 00 
  803995:	48 89 c7             	mov    %rax,%rdi
  803998:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  80399f:	00 00 00 
  8039a2:	ff d0                	callq  *%rax
	return 0;
  8039a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039a9:	c9                   	leaveq 
  8039aa:	c3                   	retq   

00000000008039ab <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8039ab:	55                   	push   %rbp
  8039ac:	48 89 e5             	mov    %rsp,%rbp
  8039af:	48 83 ec 30          	sub    $0x30,%rsp
  8039b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8039bf:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8039c6:	00 00 00 
  8039c9:	48 8b 00             	mov    (%rax),%rax
  8039cc:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8039d2:	85 c0                	test   %eax,%eax
  8039d4:	75 34                	jne    803a0a <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8039d6:	48 b8 90 19 80 00 00 	movabs $0x801990,%rax
  8039dd:	00 00 00 
  8039e0:	ff d0                	callq  *%rax
  8039e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8039e7:	48 98                	cltq   
  8039e9:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8039f0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8039f7:	00 00 00 
  8039fa:	48 01 c2             	add    %rax,%rdx
  8039fd:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803a04:	00 00 00 
  803a07:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803a0a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a0f:	75 0e                	jne    803a1f <ipc_recv+0x74>
		pg = (void*) UTOP;
  803a11:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803a18:	00 00 00 
  803a1b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803a1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a23:	48 89 c7             	mov    %rax,%rdi
  803a26:	48 b8 35 1c 80 00 00 	movabs $0x801c35,%rax
  803a2d:	00 00 00 
  803a30:	ff d0                	callq  *%rax
  803a32:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803a35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a39:	79 19                	jns    803a54 <ipc_recv+0xa9>
		*from_env_store = 0;
  803a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a3f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803a45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a49:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a52:	eb 53                	jmp    803aa7 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803a54:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a59:	74 19                	je     803a74 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803a5b:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803a62:	00 00 00 
  803a65:	48 8b 00             	mov    (%rax),%rax
  803a68:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803a6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a72:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803a74:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a79:	74 19                	je     803a94 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803a7b:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803a82:	00 00 00 
  803a85:	48 8b 00             	mov    (%rax),%rax
  803a88:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803a8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a92:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803a94:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803a9b:	00 00 00 
  803a9e:	48 8b 00             	mov    (%rax),%rax
  803aa1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803aa7:	c9                   	leaveq 
  803aa8:	c3                   	retq   

0000000000803aa9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803aa9:	55                   	push   %rbp
  803aaa:	48 89 e5             	mov    %rsp,%rbp
  803aad:	48 83 ec 30          	sub    $0x30,%rsp
  803ab1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ab4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ab7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803abb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803abe:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ac3:	75 0e                	jne    803ad3 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803ac5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803acc:	00 00 00 
  803acf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803ad3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ad6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ad9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803add:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ae0:	89 c7                	mov    %eax,%edi
  803ae2:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  803ae9:	00 00 00 
  803aec:	ff d0                	callq  *%rax
  803aee:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803af1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803af5:	75 0c                	jne    803b03 <ipc_send+0x5a>
			sys_yield();
  803af7:	48 b8 ce 19 80 00 00 	movabs $0x8019ce,%rax
  803afe:	00 00 00 
  803b01:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803b03:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b07:	74 ca                	je     803ad3 <ipc_send+0x2a>
	if(result != 0)
  803b09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b0d:	74 20                	je     803b2f <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803b0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b12:	89 c6                	mov    %eax,%esi
  803b14:	48 bf e3 42 80 00 00 	movabs $0x8042e3,%rdi
  803b1b:	00 00 00 
  803b1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803b23:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  803b2a:	00 00 00 
  803b2d:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803b2f:	c9                   	leaveq 
  803b30:	c3                   	retq   

0000000000803b31 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b31:	55                   	push   %rbp
  803b32:	48 89 e5             	mov    %rsp,%rbp
  803b35:	48 83 ec 14          	sub    $0x14,%rsp
  803b39:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803b3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b43:	eb 4e                	jmp    803b93 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803b45:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803b4c:	00 00 00 
  803b4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b52:	48 98                	cltq   
  803b54:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803b5b:	48 01 d0             	add    %rdx,%rax
  803b5e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b64:	8b 00                	mov    (%rax),%eax
  803b66:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b69:	75 24                	jne    803b8f <ipc_find_env+0x5e>
			return envs[i].env_id;
  803b6b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803b72:	00 00 00 
  803b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b78:	48 98                	cltq   
  803b7a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803b81:	48 01 d0             	add    %rdx,%rax
  803b84:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803b8a:	8b 40 08             	mov    0x8(%rax),%eax
  803b8d:	eb 12                	jmp    803ba1 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803b8f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b93:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803b9a:	7e a9                	jle    803b45 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ba1:	c9                   	leaveq 
  803ba2:	c3                   	retq   

0000000000803ba3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ba3:	55                   	push   %rbp
  803ba4:	48 89 e5             	mov    %rsp,%rbp
  803ba7:	48 83 ec 18          	sub    $0x18,%rsp
  803bab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803baf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bb3:	48 c1 e8 15          	shr    $0x15,%rax
  803bb7:	48 89 c2             	mov    %rax,%rdx
  803bba:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bc1:	01 00 00 
  803bc4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bc8:	83 e0 01             	and    $0x1,%eax
  803bcb:	48 85 c0             	test   %rax,%rax
  803bce:	75 07                	jne    803bd7 <pageref+0x34>
		return 0;
  803bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd5:	eb 53                	jmp    803c2a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bdb:	48 c1 e8 0c          	shr    $0xc,%rax
  803bdf:	48 89 c2             	mov    %rax,%rdx
  803be2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803be9:	01 00 00 
  803bec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bf0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803bf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bf8:	83 e0 01             	and    $0x1,%eax
  803bfb:	48 85 c0             	test   %rax,%rax
  803bfe:	75 07                	jne    803c07 <pageref+0x64>
		return 0;
  803c00:	b8 00 00 00 00       	mov    $0x0,%eax
  803c05:	eb 23                	jmp    803c2a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c0b:	48 c1 e8 0c          	shr    $0xc,%rax
  803c0f:	48 89 c2             	mov    %rax,%rdx
  803c12:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c19:	00 00 00 
  803c1c:	48 c1 e2 04          	shl    $0x4,%rdx
  803c20:	48 01 d0             	add    %rdx,%rax
  803c23:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c27:	0f b7 c0             	movzwl %ax,%eax
}
  803c2a:	c9                   	leaveq 
  803c2b:	c3                   	retq   
