
obj/user/spawnhello:     file format elf64-x86-64


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
  80003c:	e8 a6 00 00 00       	callq  8000e7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800052:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf 20 43 80 00 00 	movabs $0x804320,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	48 be 3e 43 80 00 00 	movabs $0x80433e,%rsi
  80008e:	00 00 00 
  800091:	48 bf 44 43 80 00 00 	movabs $0x804344,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 b9 1c 30 80 00 00 	movabs $0x80301c,%rcx
  8000a7:	00 00 00 
  8000aa:	ff d1                	callq  *%rcx
  8000ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b3:	79 30                	jns    8000e5 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	89 c1                	mov    %eax,%ecx
  8000ba:	48 ba 4f 43 80 00 00 	movabs $0x80434f,%rdx
  8000c1:	00 00 00 
  8000c4:	be 09 00 00 00       	mov    $0x9,%esi
  8000c9:	48 bf 67 43 80 00 00 	movabs $0x804367,%rdi
  8000d0:	00 00 00 
  8000d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d8:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  8000df:	00 00 00 
  8000e2:	41 ff d0             	callq  *%r8
}
  8000e5:	c9                   	leaveq 
  8000e6:	c3                   	retq   

00000000008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	55                   	push   %rbp
  8000e8:	48 89 e5             	mov    %rsp,%rbp
  8000eb:	48 83 ec 10          	sub    $0x10,%rsp
  8000ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f6:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
  800102:	25 ff 03 00 00       	and    $0x3ff,%eax
  800107:	48 98                	cltq   
  800109:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800110:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800117:	00 00 00 
  80011a:	48 01 c2             	add    %rax,%rdx
  80011d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800124:	00 00 00 
  800127:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80012e:	7e 14                	jle    800144 <libmain+0x5d>
		binaryname = argv[0];
  800130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800134:	48 8b 10             	mov    (%rax),%rdx
  800137:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80013e:	00 00 00 
  800141:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800144:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014b:	48 89 d6             	mov    %rdx,%rsi
  80014e:	89 c7                	mov    %eax,%edi
  800150:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80015c:	48 b8 6a 01 80 00 00 	movabs $0x80016a,%rax
  800163:	00 00 00 
  800166:	ff d0                	callq  *%rax
}
  800168:	c9                   	leaveq 
  800169:	c3                   	retq   

000000000080016a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016a:	55                   	push   %rbp
  80016b:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80016e:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80017a:	bf 00 00 00 00       	mov    $0x0,%edi
  80017f:	48 b8 ea 17 80 00 00 	movabs $0x8017ea,%rax
  800186:	00 00 00 
  800189:	ff d0                	callq  *%rax

}
  80018b:	5d                   	pop    %rbp
  80018c:	c3                   	retq   

000000000080018d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018d:	55                   	push   %rbp
  80018e:	48 89 e5             	mov    %rsp,%rbp
  800191:	53                   	push   %rbx
  800192:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800199:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8001a0:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8001a6:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8001ad:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8001b4:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8001bb:	84 c0                	test   %al,%al
  8001bd:	74 23                	je     8001e2 <_panic+0x55>
  8001bf:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8001c6:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8001ca:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8001ce:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8001d2:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8001d6:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8001da:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8001de:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8001e2:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8001e9:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8001f0:	00 00 00 
  8001f3:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8001fa:	00 00 00 
  8001fd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800201:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800208:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80020f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800216:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80021d:	00 00 00 
  800220:	48 8b 18             	mov    (%rax),%rbx
  800223:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  80022a:	00 00 00 
  80022d:	ff d0                	callq  *%rax
  80022f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800235:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80023c:	41 89 c8             	mov    %ecx,%r8d
  80023f:	48 89 d1             	mov    %rdx,%rcx
  800242:	48 89 da             	mov    %rbx,%rdx
  800245:	89 c6                	mov    %eax,%esi
  800247:	48 bf 88 43 80 00 00 	movabs $0x804388,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	49 b9 c6 03 80 00 00 	movabs $0x8003c6,%r9
  80025d:	00 00 00 
  800260:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800263:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80026a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800271:	48 89 d6             	mov    %rdx,%rsi
  800274:	48 89 c7             	mov    %rax,%rdi
  800277:	48 b8 1a 03 80 00 00 	movabs $0x80031a,%rax
  80027e:	00 00 00 
  800281:	ff d0                	callq  *%rax
	cprintf("\n");
  800283:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  80028a:	00 00 00 
  80028d:	b8 00 00 00 00       	mov    $0x0,%eax
  800292:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  800299:	00 00 00 
  80029c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80029e:	cc                   	int3   
  80029f:	eb fd                	jmp    80029e <_panic+0x111>

00000000008002a1 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002a1:	55                   	push   %rbp
  8002a2:	48 89 e5             	mov    %rsp,%rbp
  8002a5:	48 83 ec 10          	sub    $0x10,%rsp
  8002a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002b4:	8b 00                	mov    (%rax),%eax
  8002b6:	8d 48 01             	lea    0x1(%rax),%ecx
  8002b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002bd:	89 0a                	mov    %ecx,(%rdx)
  8002bf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002c2:	89 d1                	mov    %edx,%ecx
  8002c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c8:	48 98                	cltq   
  8002ca:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d2:	8b 00                	mov    (%rax),%eax
  8002d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d9:	75 2c                	jne    800307 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002df:	8b 00                	mov    (%rax),%eax
  8002e1:	48 98                	cltq   
  8002e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002e7:	48 83 c2 08          	add    $0x8,%rdx
  8002eb:	48 89 c6             	mov    %rax,%rsi
  8002ee:	48 89 d7             	mov    %rdx,%rdi
  8002f1:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
        b->idx = 0;
  8002fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800301:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800307:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030b:	8b 40 04             	mov    0x4(%rax),%eax
  80030e:	8d 50 01             	lea    0x1(%rax),%edx
  800311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800315:	89 50 04             	mov    %edx,0x4(%rax)
}
  800318:	c9                   	leaveq 
  800319:	c3                   	retq   

000000000080031a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80031a:	55                   	push   %rbp
  80031b:	48 89 e5             	mov    %rsp,%rbp
  80031e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800325:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80032c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800333:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80033a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800341:	48 8b 0a             	mov    (%rdx),%rcx
  800344:	48 89 08             	mov    %rcx,(%rax)
  800347:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80034b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80034f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800353:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800357:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80035e:	00 00 00 
    b.cnt = 0;
  800361:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800368:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80036b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800372:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800379:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800380:	48 89 c6             	mov    %rax,%rsi
  800383:	48 bf a1 02 80 00 00 	movabs $0x8002a1,%rdi
  80038a:	00 00 00 
  80038d:	48 b8 79 07 80 00 00 	movabs $0x800779,%rax
  800394:	00 00 00 
  800397:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800399:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80039f:	48 98                	cltq   
  8003a1:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003a8:	48 83 c2 08          	add    $0x8,%rdx
  8003ac:	48 89 c6             	mov    %rax,%rsi
  8003af:	48 89 d7             	mov    %rdx,%rdi
  8003b2:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003be:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003c4:	c9                   	leaveq 
  8003c5:	c3                   	retq   

00000000008003c6 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003c6:	55                   	push   %rbp
  8003c7:	48 89 e5             	mov    %rsp,%rbp
  8003ca:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003d1:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003d8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003df:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003e6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003ed:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003f4:	84 c0                	test   %al,%al
  8003f6:	74 20                	je     800418 <cprintf+0x52>
  8003f8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003fc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800400:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800404:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800408:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80040c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800410:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800414:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800418:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80041f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800426:	00 00 00 
  800429:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800430:	00 00 00 
  800433:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800437:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80043e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800445:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80044c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800453:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80045a:	48 8b 0a             	mov    (%rdx),%rcx
  80045d:	48 89 08             	mov    %rcx,(%rax)
  800460:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800464:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800468:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80046c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800470:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800477:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80047e:	48 89 d6             	mov    %rdx,%rsi
  800481:	48 89 c7             	mov    %rax,%rdi
  800484:	48 b8 1a 03 80 00 00 	movabs $0x80031a,%rax
  80048b:	00 00 00 
  80048e:	ff d0                	callq  *%rax
  800490:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800496:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80049c:	c9                   	leaveq 
  80049d:	c3                   	retq   

000000000080049e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80049e:	55                   	push   %rbp
  80049f:	48 89 e5             	mov    %rsp,%rbp
  8004a2:	53                   	push   %rbx
  8004a3:	48 83 ec 38          	sub    $0x38,%rsp
  8004a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004b3:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004b6:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004ba:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004be:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004c1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004c5:	77 3b                	ja     800502 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c7:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004ca:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004ce:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004da:	48 f7 f3             	div    %rbx
  8004dd:	48 89 c2             	mov    %rax,%rdx
  8004e0:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004e3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004e6:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ee:	41 89 f9             	mov    %edi,%r9d
  8004f1:	48 89 c7             	mov    %rax,%rdi
  8004f4:	48 b8 9e 04 80 00 00 	movabs $0x80049e,%rax
  8004fb:	00 00 00 
  8004fe:	ff d0                	callq  *%rax
  800500:	eb 1e                	jmp    800520 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800502:	eb 12                	jmp    800516 <printnum+0x78>
			putch(padc, putdat);
  800504:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800508:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80050b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050f:	48 89 ce             	mov    %rcx,%rsi
  800512:	89 d7                	mov    %edx,%edi
  800514:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800516:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80051a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80051e:	7f e4                	jg     800504 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800520:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800527:	ba 00 00 00 00       	mov    $0x0,%edx
  80052c:	48 f7 f1             	div    %rcx
  80052f:	48 89 d0             	mov    %rdx,%rax
  800532:	48 ba b0 45 80 00 00 	movabs $0x8045b0,%rdx
  800539:	00 00 00 
  80053c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800540:	0f be d0             	movsbl %al,%edx
  800543:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800547:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054b:	48 89 ce             	mov    %rcx,%rsi
  80054e:	89 d7                	mov    %edx,%edi
  800550:	ff d0                	callq  *%rax
}
  800552:	48 83 c4 38          	add    $0x38,%rsp
  800556:	5b                   	pop    %rbx
  800557:	5d                   	pop    %rbp
  800558:	c3                   	retq   

0000000000800559 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800559:	55                   	push   %rbp
  80055a:	48 89 e5             	mov    %rsp,%rbp
  80055d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800561:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800565:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800568:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80056c:	7e 52                	jle    8005c0 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80056e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800572:	8b 00                	mov    (%rax),%eax
  800574:	83 f8 30             	cmp    $0x30,%eax
  800577:	73 24                	jae    80059d <getuint+0x44>
  800579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800585:	8b 00                	mov    (%rax),%eax
  800587:	89 c0                	mov    %eax,%eax
  800589:	48 01 d0             	add    %rdx,%rax
  80058c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800590:	8b 12                	mov    (%rdx),%edx
  800592:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800595:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800599:	89 0a                	mov    %ecx,(%rdx)
  80059b:	eb 17                	jmp    8005b4 <getuint+0x5b>
  80059d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a5:	48 89 d0             	mov    %rdx,%rax
  8005a8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b4:	48 8b 00             	mov    (%rax),%rax
  8005b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005bb:	e9 a3 00 00 00       	jmpq   800663 <getuint+0x10a>
	else if (lflag)
  8005c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c4:	74 4f                	je     800615 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ca:	8b 00                	mov    (%rax),%eax
  8005cc:	83 f8 30             	cmp    $0x30,%eax
  8005cf:	73 24                	jae    8005f5 <getuint+0x9c>
  8005d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dd:	8b 00                	mov    (%rax),%eax
  8005df:	89 c0                	mov    %eax,%eax
  8005e1:	48 01 d0             	add    %rdx,%rax
  8005e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e8:	8b 12                	mov    (%rdx),%edx
  8005ea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f1:	89 0a                	mov    %ecx,(%rdx)
  8005f3:	eb 17                	jmp    80060c <getuint+0xb3>
  8005f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005fd:	48 89 d0             	mov    %rdx,%rax
  800600:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800604:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800608:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80060c:	48 8b 00             	mov    (%rax),%rax
  80060f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800613:	eb 4e                	jmp    800663 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800619:	8b 00                	mov    (%rax),%eax
  80061b:	83 f8 30             	cmp    $0x30,%eax
  80061e:	73 24                	jae    800644 <getuint+0xeb>
  800620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800624:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062c:	8b 00                	mov    (%rax),%eax
  80062e:	89 c0                	mov    %eax,%eax
  800630:	48 01 d0             	add    %rdx,%rax
  800633:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800637:	8b 12                	mov    (%rdx),%edx
  800639:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80063c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800640:	89 0a                	mov    %ecx,(%rdx)
  800642:	eb 17                	jmp    80065b <getuint+0x102>
  800644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800648:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80064c:	48 89 d0             	mov    %rdx,%rax
  80064f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800653:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800657:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065b:	8b 00                	mov    (%rax),%eax
  80065d:	89 c0                	mov    %eax,%eax
  80065f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800667:	c9                   	leaveq 
  800668:	c3                   	retq   

0000000000800669 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800669:	55                   	push   %rbp
  80066a:	48 89 e5             	mov    %rsp,%rbp
  80066d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800671:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800675:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800678:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80067c:	7e 52                	jle    8006d0 <getint+0x67>
		x=va_arg(*ap, long long);
  80067e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800682:	8b 00                	mov    (%rax),%eax
  800684:	83 f8 30             	cmp    $0x30,%eax
  800687:	73 24                	jae    8006ad <getint+0x44>
  800689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	8b 00                	mov    (%rax),%eax
  800697:	89 c0                	mov    %eax,%eax
  800699:	48 01 d0             	add    %rdx,%rax
  80069c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a0:	8b 12                	mov    (%rdx),%edx
  8006a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a9:	89 0a                	mov    %ecx,(%rdx)
  8006ab:	eb 17                	jmp    8006c4 <getint+0x5b>
  8006ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b5:	48 89 d0             	mov    %rdx,%rax
  8006b8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c4:	48 8b 00             	mov    (%rax),%rax
  8006c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006cb:	e9 a3 00 00 00       	jmpq   800773 <getint+0x10a>
	else if (lflag)
  8006d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006d4:	74 4f                	je     800725 <getint+0xbc>
		x=va_arg(*ap, long);
  8006d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006da:	8b 00                	mov    (%rax),%eax
  8006dc:	83 f8 30             	cmp    $0x30,%eax
  8006df:	73 24                	jae    800705 <getint+0x9c>
  8006e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	8b 00                	mov    (%rax),%eax
  8006ef:	89 c0                	mov    %eax,%eax
  8006f1:	48 01 d0             	add    %rdx,%rax
  8006f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f8:	8b 12                	mov    (%rdx),%edx
  8006fa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800701:	89 0a                	mov    %ecx,(%rdx)
  800703:	eb 17                	jmp    80071c <getint+0xb3>
  800705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800709:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80070d:	48 89 d0             	mov    %rdx,%rax
  800710:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800718:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071c:	48 8b 00             	mov    (%rax),%rax
  80071f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800723:	eb 4e                	jmp    800773 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800729:	8b 00                	mov    (%rax),%eax
  80072b:	83 f8 30             	cmp    $0x30,%eax
  80072e:	73 24                	jae    800754 <getint+0xeb>
  800730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800734:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	8b 00                	mov    (%rax),%eax
  80073e:	89 c0                	mov    %eax,%eax
  800740:	48 01 d0             	add    %rdx,%rax
  800743:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800747:	8b 12                	mov    (%rdx),%edx
  800749:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800750:	89 0a                	mov    %ecx,(%rdx)
  800752:	eb 17                	jmp    80076b <getint+0x102>
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075c:	48 89 d0             	mov    %rdx,%rax
  80075f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800763:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800767:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076b:	8b 00                	mov    (%rax),%eax
  80076d:	48 98                	cltq   
  80076f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800777:	c9                   	leaveq 
  800778:	c3                   	retq   

0000000000800779 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800779:	55                   	push   %rbp
  80077a:	48 89 e5             	mov    %rsp,%rbp
  80077d:	41 54                	push   %r12
  80077f:	53                   	push   %rbx
  800780:	48 83 ec 60          	sub    $0x60,%rsp
  800784:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800788:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80078c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800790:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800794:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800798:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80079c:	48 8b 0a             	mov    (%rdx),%rcx
  80079f:	48 89 08             	mov    %rcx,(%rax)
  8007a2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007a6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007aa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007ae:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b2:	eb 17                	jmp    8007cb <vprintfmt+0x52>
			if (ch == '\0')
  8007b4:	85 db                	test   %ebx,%ebx
  8007b6:	0f 84 cc 04 00 00    	je     800c88 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8007bc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007c0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007c4:	48 89 d6             	mov    %rdx,%rsi
  8007c7:	89 df                	mov    %ebx,%edi
  8007c9:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007cf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007d3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007d7:	0f b6 00             	movzbl (%rax),%eax
  8007da:	0f b6 d8             	movzbl %al,%ebx
  8007dd:	83 fb 25             	cmp    $0x25,%ebx
  8007e0:	75 d2                	jne    8007b4 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e2:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007e6:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007ed:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007fb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800802:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800806:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80080a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80080e:	0f b6 00             	movzbl (%rax),%eax
  800811:	0f b6 d8             	movzbl %al,%ebx
  800814:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800817:	83 f8 55             	cmp    $0x55,%eax
  80081a:	0f 87 34 04 00 00    	ja     800c54 <vprintfmt+0x4db>
  800820:	89 c0                	mov    %eax,%eax
  800822:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800829:	00 
  80082a:	48 b8 d8 45 80 00 00 	movabs $0x8045d8,%rax
  800831:	00 00 00 
  800834:	48 01 d0             	add    %rdx,%rax
  800837:	48 8b 00             	mov    (%rax),%rax
  80083a:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80083c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800840:	eb c0                	jmp    800802 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800842:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800846:	eb ba                	jmp    800802 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800848:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80084f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800852:	89 d0                	mov    %edx,%eax
  800854:	c1 e0 02             	shl    $0x2,%eax
  800857:	01 d0                	add    %edx,%eax
  800859:	01 c0                	add    %eax,%eax
  80085b:	01 d8                	add    %ebx,%eax
  80085d:	83 e8 30             	sub    $0x30,%eax
  800860:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800863:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800867:	0f b6 00             	movzbl (%rax),%eax
  80086a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80086d:	83 fb 2f             	cmp    $0x2f,%ebx
  800870:	7e 0c                	jle    80087e <vprintfmt+0x105>
  800872:	83 fb 39             	cmp    $0x39,%ebx
  800875:	7f 07                	jg     80087e <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800877:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80087c:	eb d1                	jmp    80084f <vprintfmt+0xd6>
			goto process_precision;
  80087e:	eb 58                	jmp    8008d8 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800880:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800883:	83 f8 30             	cmp    $0x30,%eax
  800886:	73 17                	jae    80089f <vprintfmt+0x126>
  800888:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80088c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088f:	89 c0                	mov    %eax,%eax
  800891:	48 01 d0             	add    %rdx,%rax
  800894:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800897:	83 c2 08             	add    $0x8,%edx
  80089a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80089d:	eb 0f                	jmp    8008ae <vprintfmt+0x135>
  80089f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a3:	48 89 d0             	mov    %rdx,%rax
  8008a6:	48 83 c2 08          	add    $0x8,%rdx
  8008aa:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ae:	8b 00                	mov    (%rax),%eax
  8008b0:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008b3:	eb 23                	jmp    8008d8 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8008b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008b9:	79 0c                	jns    8008c7 <vprintfmt+0x14e>
				width = 0;
  8008bb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008c2:	e9 3b ff ff ff       	jmpq   800802 <vprintfmt+0x89>
  8008c7:	e9 36 ff ff ff       	jmpq   800802 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008cc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008d3:	e9 2a ff ff ff       	jmpq   800802 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008dc:	79 12                	jns    8008f0 <vprintfmt+0x177>
				width = precision, precision = -1;
  8008de:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008e1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008e4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008eb:	e9 12 ff ff ff       	jmpq   800802 <vprintfmt+0x89>
  8008f0:	e9 0d ff ff ff       	jmpq   800802 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008f9:	e9 04 ff ff ff       	jmpq   800802 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800901:	83 f8 30             	cmp    $0x30,%eax
  800904:	73 17                	jae    80091d <vprintfmt+0x1a4>
  800906:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80090a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090d:	89 c0                	mov    %eax,%eax
  80090f:	48 01 d0             	add    %rdx,%rax
  800912:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800915:	83 c2 08             	add    $0x8,%edx
  800918:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80091b:	eb 0f                	jmp    80092c <vprintfmt+0x1b3>
  80091d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800921:	48 89 d0             	mov    %rdx,%rax
  800924:	48 83 c2 08          	add    $0x8,%rdx
  800928:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80092c:	8b 10                	mov    (%rax),%edx
  80092e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800932:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800936:	48 89 ce             	mov    %rcx,%rsi
  800939:	89 d7                	mov    %edx,%edi
  80093b:	ff d0                	callq  *%rax
			break;
  80093d:	e9 40 03 00 00       	jmpq   800c82 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800942:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800945:	83 f8 30             	cmp    $0x30,%eax
  800948:	73 17                	jae    800961 <vprintfmt+0x1e8>
  80094a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80094e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800951:	89 c0                	mov    %eax,%eax
  800953:	48 01 d0             	add    %rdx,%rax
  800956:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800959:	83 c2 08             	add    $0x8,%edx
  80095c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80095f:	eb 0f                	jmp    800970 <vprintfmt+0x1f7>
  800961:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800965:	48 89 d0             	mov    %rdx,%rax
  800968:	48 83 c2 08          	add    $0x8,%rdx
  80096c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800970:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800972:	85 db                	test   %ebx,%ebx
  800974:	79 02                	jns    800978 <vprintfmt+0x1ff>
				err = -err;
  800976:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800978:	83 fb 15             	cmp    $0x15,%ebx
  80097b:	7f 16                	jg     800993 <vprintfmt+0x21a>
  80097d:	48 b8 00 45 80 00 00 	movabs $0x804500,%rax
  800984:	00 00 00 
  800987:	48 63 d3             	movslq %ebx,%rdx
  80098a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80098e:	4d 85 e4             	test   %r12,%r12
  800991:	75 2e                	jne    8009c1 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800993:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800997:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80099b:	89 d9                	mov    %ebx,%ecx
  80099d:	48 ba c1 45 80 00 00 	movabs $0x8045c1,%rdx
  8009a4:	00 00 00 
  8009a7:	48 89 c7             	mov    %rax,%rdi
  8009aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8009af:	49 b8 91 0c 80 00 00 	movabs $0x800c91,%r8
  8009b6:	00 00 00 
  8009b9:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009bc:	e9 c1 02 00 00       	jmpq   800c82 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009c1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c9:	4c 89 e1             	mov    %r12,%rcx
  8009cc:	48 ba ca 45 80 00 00 	movabs $0x8045ca,%rdx
  8009d3:	00 00 00 
  8009d6:	48 89 c7             	mov    %rax,%rdi
  8009d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009de:	49 b8 91 0c 80 00 00 	movabs $0x800c91,%r8
  8009e5:	00 00 00 
  8009e8:	41 ff d0             	callq  *%r8
			break;
  8009eb:	e9 92 02 00 00       	jmpq   800c82 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f3:	83 f8 30             	cmp    $0x30,%eax
  8009f6:	73 17                	jae    800a0f <vprintfmt+0x296>
  8009f8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ff:	89 c0                	mov    %eax,%eax
  800a01:	48 01 d0             	add    %rdx,%rax
  800a04:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a07:	83 c2 08             	add    $0x8,%edx
  800a0a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0d:	eb 0f                	jmp    800a1e <vprintfmt+0x2a5>
  800a0f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a13:	48 89 d0             	mov    %rdx,%rax
  800a16:	48 83 c2 08          	add    $0x8,%rdx
  800a1a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a1e:	4c 8b 20             	mov    (%rax),%r12
  800a21:	4d 85 e4             	test   %r12,%r12
  800a24:	75 0a                	jne    800a30 <vprintfmt+0x2b7>
				p = "(null)";
  800a26:	49 bc cd 45 80 00 00 	movabs $0x8045cd,%r12
  800a2d:	00 00 00 
			if (width > 0 && padc != '-')
  800a30:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a34:	7e 3f                	jle    800a75 <vprintfmt+0x2fc>
  800a36:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a3a:	74 39                	je     800a75 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a3f:	48 98                	cltq   
  800a41:	48 89 c6             	mov    %rax,%rsi
  800a44:	4c 89 e7             	mov    %r12,%rdi
  800a47:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  800a4e:	00 00 00 
  800a51:	ff d0                	callq  *%rax
  800a53:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a56:	eb 17                	jmp    800a6f <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a58:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a5c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a64:	48 89 ce             	mov    %rcx,%rsi
  800a67:	89 d7                	mov    %edx,%edi
  800a69:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a6b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a73:	7f e3                	jg     800a58 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a75:	eb 37                	jmp    800aae <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a77:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a7b:	74 1e                	je     800a9b <vprintfmt+0x322>
  800a7d:	83 fb 1f             	cmp    $0x1f,%ebx
  800a80:	7e 05                	jle    800a87 <vprintfmt+0x30e>
  800a82:	83 fb 7e             	cmp    $0x7e,%ebx
  800a85:	7e 14                	jle    800a9b <vprintfmt+0x322>
					putch('?', putdat);
  800a87:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8f:	48 89 d6             	mov    %rdx,%rsi
  800a92:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a97:	ff d0                	callq  *%rax
  800a99:	eb 0f                	jmp    800aaa <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa3:	48 89 d6             	mov    %rdx,%rsi
  800aa6:	89 df                	mov    %ebx,%edi
  800aa8:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aaa:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800aae:	4c 89 e0             	mov    %r12,%rax
  800ab1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ab5:	0f b6 00             	movzbl (%rax),%eax
  800ab8:	0f be d8             	movsbl %al,%ebx
  800abb:	85 db                	test   %ebx,%ebx
  800abd:	74 10                	je     800acf <vprintfmt+0x356>
  800abf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ac3:	78 b2                	js     800a77 <vprintfmt+0x2fe>
  800ac5:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ac9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800acd:	79 a8                	jns    800a77 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800acf:	eb 16                	jmp    800ae7 <vprintfmt+0x36e>
				putch(' ', putdat);
  800ad1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad9:	48 89 d6             	mov    %rdx,%rsi
  800adc:	bf 20 00 00 00       	mov    $0x20,%edi
  800ae1:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ae7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aeb:	7f e4                	jg     800ad1 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800aed:	e9 90 01 00 00       	jmpq   800c82 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800af2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800af6:	be 03 00 00 00       	mov    $0x3,%esi
  800afb:	48 89 c7             	mov    %rax,%rdi
  800afe:	48 b8 69 06 80 00 00 	movabs $0x800669,%rax
  800b05:	00 00 00 
  800b08:	ff d0                	callq  *%rax
  800b0a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b12:	48 85 c0             	test   %rax,%rax
  800b15:	79 1d                	jns    800b34 <vprintfmt+0x3bb>
				putch('-', putdat);
  800b17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1f:	48 89 d6             	mov    %rdx,%rsi
  800b22:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b27:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b2d:	48 f7 d8             	neg    %rax
  800b30:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b34:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b3b:	e9 d5 00 00 00       	jmpq   800c15 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b40:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b44:	be 03 00 00 00       	mov    $0x3,%esi
  800b49:	48 89 c7             	mov    %rax,%rdi
  800b4c:	48 b8 59 05 80 00 00 	movabs $0x800559,%rax
  800b53:	00 00 00 
  800b56:	ff d0                	callq  *%rax
  800b58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b5c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b63:	e9 ad 00 00 00       	jmpq   800c15 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800b68:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800b6b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b6f:	89 d6                	mov    %edx,%esi
  800b71:	48 89 c7             	mov    %rax,%rdi
  800b74:	48 b8 69 06 80 00 00 	movabs $0x800669,%rax
  800b7b:	00 00 00 
  800b7e:	ff d0                	callq  *%rax
  800b80:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b84:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b8b:	e9 85 00 00 00       	jmpq   800c15 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800b90:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b98:	48 89 d6             	mov    %rdx,%rsi
  800b9b:	bf 30 00 00 00       	mov    $0x30,%edi
  800ba0:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ba2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800baa:	48 89 d6             	mov    %rdx,%rsi
  800bad:	bf 78 00 00 00       	mov    $0x78,%edi
  800bb2:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bb4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb7:	83 f8 30             	cmp    $0x30,%eax
  800bba:	73 17                	jae    800bd3 <vprintfmt+0x45a>
  800bbc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc3:	89 c0                	mov    %eax,%eax
  800bc5:	48 01 d0             	add    %rdx,%rax
  800bc8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bcb:	83 c2 08             	add    $0x8,%edx
  800bce:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bd1:	eb 0f                	jmp    800be2 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800bd3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd7:	48 89 d0             	mov    %rdx,%rax
  800bda:	48 83 c2 08          	add    $0x8,%rdx
  800bde:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be2:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800be5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800be9:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bf0:	eb 23                	jmp    800c15 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bf2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf6:	be 03 00 00 00       	mov    $0x3,%esi
  800bfb:	48 89 c7             	mov    %rax,%rdi
  800bfe:	48 b8 59 05 80 00 00 	movabs $0x800559,%rax
  800c05:	00 00 00 
  800c08:	ff d0                	callq  *%rax
  800c0a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c0e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c15:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c1a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c1d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c24:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2c:	45 89 c1             	mov    %r8d,%r9d
  800c2f:	41 89 f8             	mov    %edi,%r8d
  800c32:	48 89 c7             	mov    %rax,%rdi
  800c35:	48 b8 9e 04 80 00 00 	movabs $0x80049e,%rax
  800c3c:	00 00 00 
  800c3f:	ff d0                	callq  *%rax
			break;
  800c41:	eb 3f                	jmp    800c82 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4b:	48 89 d6             	mov    %rdx,%rsi
  800c4e:	89 df                	mov    %ebx,%edi
  800c50:	ff d0                	callq  *%rax
			break;
  800c52:	eb 2e                	jmp    800c82 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5c:	48 89 d6             	mov    %rdx,%rsi
  800c5f:	bf 25 00 00 00       	mov    $0x25,%edi
  800c64:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c66:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c6b:	eb 05                	jmp    800c72 <vprintfmt+0x4f9>
  800c6d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c72:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c76:	48 83 e8 01          	sub    $0x1,%rax
  800c7a:	0f b6 00             	movzbl (%rax),%eax
  800c7d:	3c 25                	cmp    $0x25,%al
  800c7f:	75 ec                	jne    800c6d <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c81:	90                   	nop
		}
	}
  800c82:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c83:	e9 43 fb ff ff       	jmpq   8007cb <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c88:	48 83 c4 60          	add    $0x60,%rsp
  800c8c:	5b                   	pop    %rbx
  800c8d:	41 5c                	pop    %r12
  800c8f:	5d                   	pop    %rbp
  800c90:	c3                   	retq   

0000000000800c91 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c91:	55                   	push   %rbp
  800c92:	48 89 e5             	mov    %rsp,%rbp
  800c95:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c9c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ca3:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800caa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cb1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cb8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cbf:	84 c0                	test   %al,%al
  800cc1:	74 20                	je     800ce3 <printfmt+0x52>
  800cc3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cc7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ccb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ccf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cd3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cd7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cdb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cdf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ce3:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cea:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cf1:	00 00 00 
  800cf4:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cfb:	00 00 00 
  800cfe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d02:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d09:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d10:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d17:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d1e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d25:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d2c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d33:	48 89 c7             	mov    %rax,%rdi
  800d36:	48 b8 79 07 80 00 00 	movabs $0x800779,%rax
  800d3d:	00 00 00 
  800d40:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d42:	c9                   	leaveq 
  800d43:	c3                   	retq   

0000000000800d44 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d44:	55                   	push   %rbp
  800d45:	48 89 e5             	mov    %rsp,%rbp
  800d48:	48 83 ec 10          	sub    $0x10,%rsp
  800d4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d57:	8b 40 10             	mov    0x10(%rax),%eax
  800d5a:	8d 50 01             	lea    0x1(%rax),%edx
  800d5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d61:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d68:	48 8b 10             	mov    (%rax),%rdx
  800d6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d73:	48 39 c2             	cmp    %rax,%rdx
  800d76:	73 17                	jae    800d8f <sprintputch+0x4b>
		*b->buf++ = ch;
  800d78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d7c:	48 8b 00             	mov    (%rax),%rax
  800d7f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d87:	48 89 0a             	mov    %rcx,(%rdx)
  800d8a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d8d:	88 10                	mov    %dl,(%rax)
}
  800d8f:	c9                   	leaveq 
  800d90:	c3                   	retq   

0000000000800d91 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d91:	55                   	push   %rbp
  800d92:	48 89 e5             	mov    %rsp,%rbp
  800d95:	48 83 ec 50          	sub    $0x50,%rsp
  800d99:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d9d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800da0:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800da4:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800da8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800dac:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800db0:	48 8b 0a             	mov    (%rdx),%rcx
  800db3:	48 89 08             	mov    %rcx,(%rax)
  800db6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dba:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dbe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dc2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dca:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dce:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800dd1:	48 98                	cltq   
  800dd3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800dd7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ddb:	48 01 d0             	add    %rdx,%rax
  800dde:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800de2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800de9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800dee:	74 06                	je     800df6 <vsnprintf+0x65>
  800df0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800df4:	7f 07                	jg     800dfd <vsnprintf+0x6c>
		return -E_INVAL;
  800df6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dfb:	eb 2f                	jmp    800e2c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800dfd:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e01:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e05:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e09:	48 89 c6             	mov    %rax,%rsi
  800e0c:	48 bf 44 0d 80 00 00 	movabs $0x800d44,%rdi
  800e13:	00 00 00 
  800e16:	48 b8 79 07 80 00 00 	movabs $0x800779,%rax
  800e1d:	00 00 00 
  800e20:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e26:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e29:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e2c:	c9                   	leaveq 
  800e2d:	c3                   	retq   

0000000000800e2e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e2e:	55                   	push   %rbp
  800e2f:	48 89 e5             	mov    %rsp,%rbp
  800e32:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e39:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e40:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e46:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e4d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e54:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e5b:	84 c0                	test   %al,%al
  800e5d:	74 20                	je     800e7f <snprintf+0x51>
  800e5f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e63:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e67:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e6b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e6f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e73:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e77:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e7b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e7f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e86:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e8d:	00 00 00 
  800e90:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e97:	00 00 00 
  800e9a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e9e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ea5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eac:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800eb3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800eba:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ec1:	48 8b 0a             	mov    (%rdx),%rcx
  800ec4:	48 89 08             	mov    %rcx,(%rax)
  800ec7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ecb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ecf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ed3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ed7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ede:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ee5:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800eeb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ef2:	48 89 c7             	mov    %rax,%rdi
  800ef5:	48 b8 91 0d 80 00 00 	movabs $0x800d91,%rax
  800efc:	00 00 00 
  800eff:	ff d0                	callq  *%rax
  800f01:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f07:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f0d:	c9                   	leaveq 
  800f0e:	c3                   	retq   

0000000000800f0f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f0f:	55                   	push   %rbp
  800f10:	48 89 e5             	mov    %rsp,%rbp
  800f13:	48 83 ec 18          	sub    $0x18,%rsp
  800f17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f22:	eb 09                	jmp    800f2d <strlen+0x1e>
		n++;
  800f24:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f28:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f31:	0f b6 00             	movzbl (%rax),%eax
  800f34:	84 c0                	test   %al,%al
  800f36:	75 ec                	jne    800f24 <strlen+0x15>
		n++;
	return n;
  800f38:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f3b:	c9                   	leaveq 
  800f3c:	c3                   	retq   

0000000000800f3d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f3d:	55                   	push   %rbp
  800f3e:	48 89 e5             	mov    %rsp,%rbp
  800f41:	48 83 ec 20          	sub    $0x20,%rsp
  800f45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f54:	eb 0e                	jmp    800f64 <strnlen+0x27>
		n++;
  800f56:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f5a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f5f:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f64:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f69:	74 0b                	je     800f76 <strnlen+0x39>
  800f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6f:	0f b6 00             	movzbl (%rax),%eax
  800f72:	84 c0                	test   %al,%al
  800f74:	75 e0                	jne    800f56 <strnlen+0x19>
		n++;
	return n;
  800f76:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f79:	c9                   	leaveq 
  800f7a:	c3                   	retq   

0000000000800f7b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f7b:	55                   	push   %rbp
  800f7c:	48 89 e5             	mov    %rsp,%rbp
  800f7f:	48 83 ec 20          	sub    $0x20,%rsp
  800f83:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f87:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f93:	90                   	nop
  800f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f98:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f9c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fa4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fa8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fac:	0f b6 12             	movzbl (%rdx),%edx
  800faf:	88 10                	mov    %dl,(%rax)
  800fb1:	0f b6 00             	movzbl (%rax),%eax
  800fb4:	84 c0                	test   %al,%al
  800fb6:	75 dc                	jne    800f94 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fbc:	c9                   	leaveq 
  800fbd:	c3                   	retq   

0000000000800fbe <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fbe:	55                   	push   %rbp
  800fbf:	48 89 e5             	mov    %rsp,%rbp
  800fc2:	48 83 ec 20          	sub    $0x20,%rsp
  800fc6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd2:	48 89 c7             	mov    %rax,%rdi
  800fd5:	48 b8 0f 0f 80 00 00 	movabs $0x800f0f,%rax
  800fdc:	00 00 00 
  800fdf:	ff d0                	callq  *%rax
  800fe1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fe4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fe7:	48 63 d0             	movslq %eax,%rdx
  800fea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fee:	48 01 c2             	add    %rax,%rdx
  800ff1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ff5:	48 89 c6             	mov    %rax,%rsi
  800ff8:	48 89 d7             	mov    %rdx,%rdi
  800ffb:	48 b8 7b 0f 80 00 00 	movabs $0x800f7b,%rax
  801002:	00 00 00 
  801005:	ff d0                	callq  *%rax
	return dst;
  801007:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80100b:	c9                   	leaveq 
  80100c:	c3                   	retq   

000000000080100d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80100d:	55                   	push   %rbp
  80100e:	48 89 e5             	mov    %rsp,%rbp
  801011:	48 83 ec 28          	sub    $0x28,%rsp
  801015:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801019:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80101d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801021:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801025:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801029:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801030:	00 
  801031:	eb 2a                	jmp    80105d <strncpy+0x50>
		*dst++ = *src;
  801033:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801037:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80103b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80103f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801043:	0f b6 12             	movzbl (%rdx),%edx
  801046:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801048:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80104c:	0f b6 00             	movzbl (%rax),%eax
  80104f:	84 c0                	test   %al,%al
  801051:	74 05                	je     801058 <strncpy+0x4b>
			src++;
  801053:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801058:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80105d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801061:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801065:	72 cc                	jb     801033 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80106b:	c9                   	leaveq 
  80106c:	c3                   	retq   

000000000080106d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80106d:	55                   	push   %rbp
  80106e:	48 89 e5             	mov    %rsp,%rbp
  801071:	48 83 ec 28          	sub    $0x28,%rsp
  801075:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801079:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80107d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801081:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801085:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801089:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80108e:	74 3d                	je     8010cd <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801090:	eb 1d                	jmp    8010af <strlcpy+0x42>
			*dst++ = *src++;
  801092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801096:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80109a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80109e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010a2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010a6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010aa:	0f b6 12             	movzbl (%rdx),%edx
  8010ad:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010af:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010b4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010b9:	74 0b                	je     8010c6 <strlcpy+0x59>
  8010bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010bf:	0f b6 00             	movzbl (%rax),%eax
  8010c2:	84 c0                	test   %al,%al
  8010c4:	75 cc                	jne    801092 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ca:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d5:	48 29 c2             	sub    %rax,%rdx
  8010d8:	48 89 d0             	mov    %rdx,%rax
}
  8010db:	c9                   	leaveq 
  8010dc:	c3                   	retq   

00000000008010dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010dd:	55                   	push   %rbp
  8010de:	48 89 e5             	mov    %rsp,%rbp
  8010e1:	48 83 ec 10          	sub    $0x10,%rsp
  8010e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010ed:	eb 0a                	jmp    8010f9 <strcmp+0x1c>
		p++, q++;
  8010ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fd:	0f b6 00             	movzbl (%rax),%eax
  801100:	84 c0                	test   %al,%al
  801102:	74 12                	je     801116 <strcmp+0x39>
  801104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801108:	0f b6 10             	movzbl (%rax),%edx
  80110b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110f:	0f b6 00             	movzbl (%rax),%eax
  801112:	38 c2                	cmp    %al,%dl
  801114:	74 d9                	je     8010ef <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111a:	0f b6 00             	movzbl (%rax),%eax
  80111d:	0f b6 d0             	movzbl %al,%edx
  801120:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801124:	0f b6 00             	movzbl (%rax),%eax
  801127:	0f b6 c0             	movzbl %al,%eax
  80112a:	29 c2                	sub    %eax,%edx
  80112c:	89 d0                	mov    %edx,%eax
}
  80112e:	c9                   	leaveq 
  80112f:	c3                   	retq   

0000000000801130 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801130:	55                   	push   %rbp
  801131:	48 89 e5             	mov    %rsp,%rbp
  801134:	48 83 ec 18          	sub    $0x18,%rsp
  801138:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80113c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801140:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801144:	eb 0f                	jmp    801155 <strncmp+0x25>
		n--, p++, q++;
  801146:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80114b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801150:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801155:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80115a:	74 1d                	je     801179 <strncmp+0x49>
  80115c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801160:	0f b6 00             	movzbl (%rax),%eax
  801163:	84 c0                	test   %al,%al
  801165:	74 12                	je     801179 <strncmp+0x49>
  801167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116b:	0f b6 10             	movzbl (%rax),%edx
  80116e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801172:	0f b6 00             	movzbl (%rax),%eax
  801175:	38 c2                	cmp    %al,%dl
  801177:	74 cd                	je     801146 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801179:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80117e:	75 07                	jne    801187 <strncmp+0x57>
		return 0;
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
  801185:	eb 18                	jmp    80119f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801187:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118b:	0f b6 00             	movzbl (%rax),%eax
  80118e:	0f b6 d0             	movzbl %al,%edx
  801191:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801195:	0f b6 00             	movzbl (%rax),%eax
  801198:	0f b6 c0             	movzbl %al,%eax
  80119b:	29 c2                	sub    %eax,%edx
  80119d:	89 d0                	mov    %edx,%eax
}
  80119f:	c9                   	leaveq 
  8011a0:	c3                   	retq   

00000000008011a1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a1:	55                   	push   %rbp
  8011a2:	48 89 e5             	mov    %rsp,%rbp
  8011a5:	48 83 ec 0c          	sub    $0xc,%rsp
  8011a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ad:	89 f0                	mov    %esi,%eax
  8011af:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011b2:	eb 17                	jmp    8011cb <strchr+0x2a>
		if (*s == c)
  8011b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b8:	0f b6 00             	movzbl (%rax),%eax
  8011bb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011be:	75 06                	jne    8011c6 <strchr+0x25>
			return (char *) s;
  8011c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c4:	eb 15                	jmp    8011db <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cf:	0f b6 00             	movzbl (%rax),%eax
  8011d2:	84 c0                	test   %al,%al
  8011d4:	75 de                	jne    8011b4 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011db:	c9                   	leaveq 
  8011dc:	c3                   	retq   

00000000008011dd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011dd:	55                   	push   %rbp
  8011de:	48 89 e5             	mov    %rsp,%rbp
  8011e1:	48 83 ec 0c          	sub    $0xc,%rsp
  8011e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e9:	89 f0                	mov    %esi,%eax
  8011eb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011ee:	eb 13                	jmp    801203 <strfind+0x26>
		if (*s == c)
  8011f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f4:	0f b6 00             	movzbl (%rax),%eax
  8011f7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011fa:	75 02                	jne    8011fe <strfind+0x21>
			break;
  8011fc:	eb 10                	jmp    80120e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801207:	0f b6 00             	movzbl (%rax),%eax
  80120a:	84 c0                	test   %al,%al
  80120c:	75 e2                	jne    8011f0 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80120e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801212:	c9                   	leaveq 
  801213:	c3                   	retq   

0000000000801214 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801214:	55                   	push   %rbp
  801215:	48 89 e5             	mov    %rsp,%rbp
  801218:	48 83 ec 18          	sub    $0x18,%rsp
  80121c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801220:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801223:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801227:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80122c:	75 06                	jne    801234 <memset+0x20>
		return v;
  80122e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801232:	eb 69                	jmp    80129d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801238:	83 e0 03             	and    $0x3,%eax
  80123b:	48 85 c0             	test   %rax,%rax
  80123e:	75 48                	jne    801288 <memset+0x74>
  801240:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801244:	83 e0 03             	and    $0x3,%eax
  801247:	48 85 c0             	test   %rax,%rax
  80124a:	75 3c                	jne    801288 <memset+0x74>
		c &= 0xFF;
  80124c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801253:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801256:	c1 e0 18             	shl    $0x18,%eax
  801259:	89 c2                	mov    %eax,%edx
  80125b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80125e:	c1 e0 10             	shl    $0x10,%eax
  801261:	09 c2                	or     %eax,%edx
  801263:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801266:	c1 e0 08             	shl    $0x8,%eax
  801269:	09 d0                	or     %edx,%eax
  80126b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80126e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801272:	48 c1 e8 02          	shr    $0x2,%rax
  801276:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801279:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80127d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801280:	48 89 d7             	mov    %rdx,%rdi
  801283:	fc                   	cld    
  801284:	f3 ab                	rep stos %eax,%es:(%rdi)
  801286:	eb 11                	jmp    801299 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801288:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80128f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801293:	48 89 d7             	mov    %rdx,%rdi
  801296:	fc                   	cld    
  801297:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80129d:	c9                   	leaveq 
  80129e:	c3                   	retq   

000000000080129f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80129f:	55                   	push   %rbp
  8012a0:	48 89 e5             	mov    %rsp,%rbp
  8012a3:	48 83 ec 28          	sub    $0x28,%rsp
  8012a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012cb:	0f 83 88 00 00 00    	jae    801359 <memmove+0xba>
  8012d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012d9:	48 01 d0             	add    %rdx,%rax
  8012dc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012e0:	76 77                	jbe    801359 <memmove+0xba>
		s += n;
  8012e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ee:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	83 e0 03             	and    $0x3,%eax
  8012f9:	48 85 c0             	test   %rax,%rax
  8012fc:	75 3b                	jne    801339 <memmove+0x9a>
  8012fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801302:	83 e0 03             	and    $0x3,%eax
  801305:	48 85 c0             	test   %rax,%rax
  801308:	75 2f                	jne    801339 <memmove+0x9a>
  80130a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80130e:	83 e0 03             	and    $0x3,%eax
  801311:	48 85 c0             	test   %rax,%rax
  801314:	75 23                	jne    801339 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801316:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131a:	48 83 e8 04          	sub    $0x4,%rax
  80131e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801322:	48 83 ea 04          	sub    $0x4,%rdx
  801326:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80132a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80132e:	48 89 c7             	mov    %rax,%rdi
  801331:	48 89 d6             	mov    %rdx,%rsi
  801334:	fd                   	std    
  801335:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801337:	eb 1d                	jmp    801356 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801339:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801341:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801345:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801349:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134d:	48 89 d7             	mov    %rdx,%rdi
  801350:	48 89 c1             	mov    %rax,%rcx
  801353:	fd                   	std    
  801354:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801356:	fc                   	cld    
  801357:	eb 57                	jmp    8013b0 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801359:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135d:	83 e0 03             	and    $0x3,%eax
  801360:	48 85 c0             	test   %rax,%rax
  801363:	75 36                	jne    80139b <memmove+0xfc>
  801365:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801369:	83 e0 03             	and    $0x3,%eax
  80136c:	48 85 c0             	test   %rax,%rax
  80136f:	75 2a                	jne    80139b <memmove+0xfc>
  801371:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801375:	83 e0 03             	and    $0x3,%eax
  801378:	48 85 c0             	test   %rax,%rax
  80137b:	75 1e                	jne    80139b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80137d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801381:	48 c1 e8 02          	shr    $0x2,%rax
  801385:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801390:	48 89 c7             	mov    %rax,%rdi
  801393:	48 89 d6             	mov    %rdx,%rsi
  801396:	fc                   	cld    
  801397:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801399:	eb 15                	jmp    8013b0 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80139b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013a7:	48 89 c7             	mov    %rax,%rdi
  8013aa:	48 89 d6             	mov    %rdx,%rsi
  8013ad:	fc                   	cld    
  8013ae:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013b4:	c9                   	leaveq 
  8013b5:	c3                   	retq   

00000000008013b6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013b6:	55                   	push   %rbp
  8013b7:	48 89 e5             	mov    %rsp,%rbp
  8013ba:	48 83 ec 18          	sub    $0x18,%rsp
  8013be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013ce:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d6:	48 89 ce             	mov    %rcx,%rsi
  8013d9:	48 89 c7             	mov    %rax,%rdi
  8013dc:	48 b8 9f 12 80 00 00 	movabs $0x80129f,%rax
  8013e3:	00 00 00 
  8013e6:	ff d0                	callq  *%rax
}
  8013e8:	c9                   	leaveq 
  8013e9:	c3                   	retq   

00000000008013ea <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013ea:	55                   	push   %rbp
  8013eb:	48 89 e5             	mov    %rsp,%rbp
  8013ee:	48 83 ec 28          	sub    $0x28,%rsp
  8013f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801402:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801406:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80140a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80140e:	eb 36                	jmp    801446 <memcmp+0x5c>
		if (*s1 != *s2)
  801410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801414:	0f b6 10             	movzbl (%rax),%edx
  801417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141b:	0f b6 00             	movzbl (%rax),%eax
  80141e:	38 c2                	cmp    %al,%dl
  801420:	74 1a                	je     80143c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801422:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801426:	0f b6 00             	movzbl (%rax),%eax
  801429:	0f b6 d0             	movzbl %al,%edx
  80142c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801430:	0f b6 00             	movzbl (%rax),%eax
  801433:	0f b6 c0             	movzbl %al,%eax
  801436:	29 c2                	sub    %eax,%edx
  801438:	89 d0                	mov    %edx,%eax
  80143a:	eb 20                	jmp    80145c <memcmp+0x72>
		s1++, s2++;
  80143c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801441:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801446:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80144e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801452:	48 85 c0             	test   %rax,%rax
  801455:	75 b9                	jne    801410 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145c:	c9                   	leaveq 
  80145d:	c3                   	retq   

000000000080145e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80145e:	55                   	push   %rbp
  80145f:	48 89 e5             	mov    %rsp,%rbp
  801462:	48 83 ec 28          	sub    $0x28,%rsp
  801466:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80146d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801475:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801479:	48 01 d0             	add    %rdx,%rax
  80147c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801480:	eb 15                	jmp    801497 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801486:	0f b6 10             	movzbl (%rax),%edx
  801489:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80148c:	38 c2                	cmp    %al,%dl
  80148e:	75 02                	jne    801492 <memfind+0x34>
			break;
  801490:	eb 0f                	jmp    8014a1 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801492:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80149f:	72 e1                	jb     801482 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014a5:	c9                   	leaveq 
  8014a6:	c3                   	retq   

00000000008014a7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014a7:	55                   	push   %rbp
  8014a8:	48 89 e5             	mov    %rsp,%rbp
  8014ab:	48 83 ec 34          	sub    $0x34,%rsp
  8014af:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014b7:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014c1:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014c8:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014c9:	eb 05                	jmp    8014d0 <strtol+0x29>
		s++;
  8014cb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d4:	0f b6 00             	movzbl (%rax),%eax
  8014d7:	3c 20                	cmp    $0x20,%al
  8014d9:	74 f0                	je     8014cb <strtol+0x24>
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	0f b6 00             	movzbl (%rax),%eax
  8014e2:	3c 09                	cmp    $0x9,%al
  8014e4:	74 e5                	je     8014cb <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ea:	0f b6 00             	movzbl (%rax),%eax
  8014ed:	3c 2b                	cmp    $0x2b,%al
  8014ef:	75 07                	jne    8014f8 <strtol+0x51>
		s++;
  8014f1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014f6:	eb 17                	jmp    80150f <strtol+0x68>
	else if (*s == '-')
  8014f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	3c 2d                	cmp    $0x2d,%al
  801501:	75 0c                	jne    80150f <strtol+0x68>
		s++, neg = 1;
  801503:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801508:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80150f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801513:	74 06                	je     80151b <strtol+0x74>
  801515:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801519:	75 28                	jne    801543 <strtol+0x9c>
  80151b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151f:	0f b6 00             	movzbl (%rax),%eax
  801522:	3c 30                	cmp    $0x30,%al
  801524:	75 1d                	jne    801543 <strtol+0x9c>
  801526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152a:	48 83 c0 01          	add    $0x1,%rax
  80152e:	0f b6 00             	movzbl (%rax),%eax
  801531:	3c 78                	cmp    $0x78,%al
  801533:	75 0e                	jne    801543 <strtol+0x9c>
		s += 2, base = 16;
  801535:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80153a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801541:	eb 2c                	jmp    80156f <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801543:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801547:	75 19                	jne    801562 <strtol+0xbb>
  801549:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154d:	0f b6 00             	movzbl (%rax),%eax
  801550:	3c 30                	cmp    $0x30,%al
  801552:	75 0e                	jne    801562 <strtol+0xbb>
		s++, base = 8;
  801554:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801559:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801560:	eb 0d                	jmp    80156f <strtol+0xc8>
	else if (base == 0)
  801562:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801566:	75 07                	jne    80156f <strtol+0xc8>
		base = 10;
  801568:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	0f b6 00             	movzbl (%rax),%eax
  801576:	3c 2f                	cmp    $0x2f,%al
  801578:	7e 1d                	jle    801597 <strtol+0xf0>
  80157a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157e:	0f b6 00             	movzbl (%rax),%eax
  801581:	3c 39                	cmp    $0x39,%al
  801583:	7f 12                	jg     801597 <strtol+0xf0>
			dig = *s - '0';
  801585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801589:	0f b6 00             	movzbl (%rax),%eax
  80158c:	0f be c0             	movsbl %al,%eax
  80158f:	83 e8 30             	sub    $0x30,%eax
  801592:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801595:	eb 4e                	jmp    8015e5 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159b:	0f b6 00             	movzbl (%rax),%eax
  80159e:	3c 60                	cmp    $0x60,%al
  8015a0:	7e 1d                	jle    8015bf <strtol+0x118>
  8015a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a6:	0f b6 00             	movzbl (%rax),%eax
  8015a9:	3c 7a                	cmp    $0x7a,%al
  8015ab:	7f 12                	jg     8015bf <strtol+0x118>
			dig = *s - 'a' + 10;
  8015ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b1:	0f b6 00             	movzbl (%rax),%eax
  8015b4:	0f be c0             	movsbl %al,%eax
  8015b7:	83 e8 57             	sub    $0x57,%eax
  8015ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015bd:	eb 26                	jmp    8015e5 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c3:	0f b6 00             	movzbl (%rax),%eax
  8015c6:	3c 40                	cmp    $0x40,%al
  8015c8:	7e 48                	jle    801612 <strtol+0x16b>
  8015ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ce:	0f b6 00             	movzbl (%rax),%eax
  8015d1:	3c 5a                	cmp    $0x5a,%al
  8015d3:	7f 3d                	jg     801612 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d9:	0f b6 00             	movzbl (%rax),%eax
  8015dc:	0f be c0             	movsbl %al,%eax
  8015df:	83 e8 37             	sub    $0x37,%eax
  8015e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015e8:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015eb:	7c 02                	jl     8015ef <strtol+0x148>
			break;
  8015ed:	eb 23                	jmp    801612 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015ef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015f7:	48 98                	cltq   
  8015f9:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8015fe:	48 89 c2             	mov    %rax,%rdx
  801601:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801604:	48 98                	cltq   
  801606:	48 01 d0             	add    %rdx,%rax
  801609:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80160d:	e9 5d ff ff ff       	jmpq   80156f <strtol+0xc8>

	if (endptr)
  801612:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801617:	74 0b                	je     801624 <strtol+0x17d>
		*endptr = (char *) s;
  801619:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80161d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801621:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801624:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801628:	74 09                	je     801633 <strtol+0x18c>
  80162a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162e:	48 f7 d8             	neg    %rax
  801631:	eb 04                	jmp    801637 <strtol+0x190>
  801633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801637:	c9                   	leaveq 
  801638:	c3                   	retq   

0000000000801639 <strstr>:

char * strstr(const char *in, const char *str)
{
  801639:	55                   	push   %rbp
  80163a:	48 89 e5             	mov    %rsp,%rbp
  80163d:	48 83 ec 30          	sub    $0x30,%rsp
  801641:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801645:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801649:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80164d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801651:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80165b:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80165f:	75 06                	jne    801667 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	eb 6b                	jmp    8016d2 <strstr+0x99>

	len = strlen(str);
  801667:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80166b:	48 89 c7             	mov    %rax,%rdi
  80166e:	48 b8 0f 0f 80 00 00 	movabs $0x800f0f,%rax
  801675:	00 00 00 
  801678:	ff d0                	callq  *%rax
  80167a:	48 98                	cltq   
  80167c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801684:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801688:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80168c:	0f b6 00             	movzbl (%rax),%eax
  80168f:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801692:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801696:	75 07                	jne    80169f <strstr+0x66>
				return (char *) 0;
  801698:	b8 00 00 00 00       	mov    $0x0,%eax
  80169d:	eb 33                	jmp    8016d2 <strstr+0x99>
		} while (sc != c);
  80169f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016a3:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016a6:	75 d8                	jne    801680 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016ac:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b4:	48 89 ce             	mov    %rcx,%rsi
  8016b7:	48 89 c7             	mov    %rax,%rdi
  8016ba:	48 b8 30 11 80 00 00 	movabs $0x801130,%rax
  8016c1:	00 00 00 
  8016c4:	ff d0                	callq  *%rax
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	75 b6                	jne    801680 <strstr+0x47>

	return (char *) (in - 1);
  8016ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ce:	48 83 e8 01          	sub    $0x1,%rax
}
  8016d2:	c9                   	leaveq 
  8016d3:	c3                   	retq   

00000000008016d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016d4:	55                   	push   %rbp
  8016d5:	48 89 e5             	mov    %rsp,%rbp
  8016d8:	53                   	push   %rbx
  8016d9:	48 83 ec 48          	sub    $0x48,%rsp
  8016dd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016e0:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016e3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016e7:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016eb:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016ef:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016f6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016fa:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016fe:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801702:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801706:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80170a:	4c 89 c3             	mov    %r8,%rbx
  80170d:	cd 30                	int    $0x30
  80170f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801713:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801717:	74 3e                	je     801757 <syscall+0x83>
  801719:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80171e:	7e 37                	jle    801757 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801720:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801724:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801727:	49 89 d0             	mov    %rdx,%r8
  80172a:	89 c1                	mov    %eax,%ecx
  80172c:	48 ba 88 48 80 00 00 	movabs $0x804888,%rdx
  801733:	00 00 00 
  801736:	be 23 00 00 00       	mov    $0x23,%esi
  80173b:	48 bf a5 48 80 00 00 	movabs $0x8048a5,%rdi
  801742:	00 00 00 
  801745:	b8 00 00 00 00       	mov    $0x0,%eax
  80174a:	49 b9 8d 01 80 00 00 	movabs $0x80018d,%r9
  801751:	00 00 00 
  801754:	41 ff d1             	callq  *%r9

	return ret;
  801757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80175b:	48 83 c4 48          	add    $0x48,%rsp
  80175f:	5b                   	pop    %rbx
  801760:	5d                   	pop    %rbp
  801761:	c3                   	retq   

0000000000801762 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801762:	55                   	push   %rbp
  801763:	48 89 e5             	mov    %rsp,%rbp
  801766:	48 83 ec 20          	sub    $0x20,%rsp
  80176a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80176e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801772:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801776:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80177a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801781:	00 
  801782:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801788:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80178e:	48 89 d1             	mov    %rdx,%rcx
  801791:	48 89 c2             	mov    %rax,%rdx
  801794:	be 00 00 00 00       	mov    $0x0,%esi
  801799:	bf 00 00 00 00       	mov    $0x0,%edi
  80179e:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  8017a5:	00 00 00 
  8017a8:	ff d0                	callq  *%rax
}
  8017aa:	c9                   	leaveq 
  8017ab:	c3                   	retq   

00000000008017ac <sys_cgetc>:

int
sys_cgetc(void)
{
  8017ac:	55                   	push   %rbp
  8017ad:	48 89 e5             	mov    %rsp,%rbp
  8017b0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017b4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017bb:	00 
  8017bc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d2:	be 00 00 00 00       	mov    $0x0,%esi
  8017d7:	bf 01 00 00 00       	mov    $0x1,%edi
  8017dc:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  8017e3:	00 00 00 
  8017e6:	ff d0                	callq  *%rax
}
  8017e8:	c9                   	leaveq 
  8017e9:	c3                   	retq   

00000000008017ea <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017ea:	55                   	push   %rbp
  8017eb:	48 89 e5             	mov    %rsp,%rbp
  8017ee:	48 83 ec 10          	sub    $0x10,%rsp
  8017f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f8:	48 98                	cltq   
  8017fa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801801:	00 
  801802:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801808:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80180e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801813:	48 89 c2             	mov    %rax,%rdx
  801816:	be 01 00 00 00       	mov    $0x1,%esi
  80181b:	bf 03 00 00 00       	mov    $0x3,%edi
  801820:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801827:	00 00 00 
  80182a:	ff d0                	callq  *%rax
}
  80182c:	c9                   	leaveq 
  80182d:	c3                   	retq   

000000000080182e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80182e:	55                   	push   %rbp
  80182f:	48 89 e5             	mov    %rsp,%rbp
  801832:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801836:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80183d:	00 
  80183e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801844:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80184f:	ba 00 00 00 00       	mov    $0x0,%edx
  801854:	be 00 00 00 00       	mov    $0x0,%esi
  801859:	bf 02 00 00 00       	mov    $0x2,%edi
  80185e:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801865:	00 00 00 
  801868:	ff d0                	callq  *%rax
}
  80186a:	c9                   	leaveq 
  80186b:	c3                   	retq   

000000000080186c <sys_yield>:

void
sys_yield(void)
{
  80186c:	55                   	push   %rbp
  80186d:	48 89 e5             	mov    %rsp,%rbp
  801870:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801874:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187b:	00 
  80187c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801882:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801888:	b9 00 00 00 00       	mov    $0x0,%ecx
  80188d:	ba 00 00 00 00       	mov    $0x0,%edx
  801892:	be 00 00 00 00       	mov    $0x0,%esi
  801897:	bf 0b 00 00 00       	mov    $0xb,%edi
  80189c:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  8018a3:	00 00 00 
  8018a6:	ff d0                	callq  *%rax
}
  8018a8:	c9                   	leaveq 
  8018a9:	c3                   	retq   

00000000008018aa <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018aa:	55                   	push   %rbp
  8018ab:	48 89 e5             	mov    %rsp,%rbp
  8018ae:	48 83 ec 20          	sub    $0x20,%rsp
  8018b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018b9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018bf:	48 63 c8             	movslq %eax,%rcx
  8018c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c9:	48 98                	cltq   
  8018cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d2:	00 
  8018d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d9:	49 89 c8             	mov    %rcx,%r8
  8018dc:	48 89 d1             	mov    %rdx,%rcx
  8018df:	48 89 c2             	mov    %rax,%rdx
  8018e2:	be 01 00 00 00       	mov    $0x1,%esi
  8018e7:	bf 04 00 00 00       	mov    $0x4,%edi
  8018ec:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  8018f3:	00 00 00 
  8018f6:	ff d0                	callq  *%rax
}
  8018f8:	c9                   	leaveq 
  8018f9:	c3                   	retq   

00000000008018fa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018fa:	55                   	push   %rbp
  8018fb:	48 89 e5             	mov    %rsp,%rbp
  8018fe:	48 83 ec 30          	sub    $0x30,%rsp
  801902:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801905:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801909:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80190c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801910:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801914:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801917:	48 63 c8             	movslq %eax,%rcx
  80191a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80191e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801921:	48 63 f0             	movslq %eax,%rsi
  801924:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192b:	48 98                	cltq   
  80192d:	48 89 0c 24          	mov    %rcx,(%rsp)
  801931:	49 89 f9             	mov    %rdi,%r9
  801934:	49 89 f0             	mov    %rsi,%r8
  801937:	48 89 d1             	mov    %rdx,%rcx
  80193a:	48 89 c2             	mov    %rax,%rdx
  80193d:	be 01 00 00 00       	mov    $0x1,%esi
  801942:	bf 05 00 00 00       	mov    $0x5,%edi
  801947:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  80194e:	00 00 00 
  801951:	ff d0                	callq  *%rax
}
  801953:	c9                   	leaveq 
  801954:	c3                   	retq   

0000000000801955 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801955:	55                   	push   %rbp
  801956:	48 89 e5             	mov    %rsp,%rbp
  801959:	48 83 ec 20          	sub    $0x20,%rsp
  80195d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801960:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801964:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801968:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196b:	48 98                	cltq   
  80196d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801974:	00 
  801975:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801981:	48 89 d1             	mov    %rdx,%rcx
  801984:	48 89 c2             	mov    %rax,%rdx
  801987:	be 01 00 00 00       	mov    $0x1,%esi
  80198c:	bf 06 00 00 00       	mov    $0x6,%edi
  801991:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801998:	00 00 00 
  80199b:	ff d0                	callq  *%rax
}
  80199d:	c9                   	leaveq 
  80199e:	c3                   	retq   

000000000080199f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80199f:	55                   	push   %rbp
  8019a0:	48 89 e5             	mov    %rsp,%rbp
  8019a3:	48 83 ec 10          	sub    $0x10,%rsp
  8019a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019aa:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b0:	48 63 d0             	movslq %eax,%rdx
  8019b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b6:	48 98                	cltq   
  8019b8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019bf:	00 
  8019c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019cc:	48 89 d1             	mov    %rdx,%rcx
  8019cf:	48 89 c2             	mov    %rax,%rdx
  8019d2:	be 01 00 00 00       	mov    $0x1,%esi
  8019d7:	bf 08 00 00 00       	mov    $0x8,%edi
  8019dc:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  8019e3:	00 00 00 
  8019e6:	ff d0                	callq  *%rax
}
  8019e8:	c9                   	leaveq 
  8019e9:	c3                   	retq   

00000000008019ea <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019ea:	55                   	push   %rbp
  8019eb:	48 89 e5             	mov    %rsp,%rbp
  8019ee:	48 83 ec 20          	sub    $0x20,%rsp
  8019f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a00:	48 98                	cltq   
  801a02:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a09:	00 
  801a0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a16:	48 89 d1             	mov    %rdx,%rcx
  801a19:	48 89 c2             	mov    %rax,%rdx
  801a1c:	be 01 00 00 00       	mov    $0x1,%esi
  801a21:	bf 09 00 00 00       	mov    $0x9,%edi
  801a26:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801a2d:	00 00 00 
  801a30:	ff d0                	callq  *%rax
}
  801a32:	c9                   	leaveq 
  801a33:	c3                   	retq   

0000000000801a34 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a34:	55                   	push   %rbp
  801a35:	48 89 e5             	mov    %rsp,%rbp
  801a38:	48 83 ec 20          	sub    $0x20,%rsp
  801a3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4a:	48 98                	cltq   
  801a4c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a53:	00 
  801a54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a60:	48 89 d1             	mov    %rdx,%rcx
  801a63:	48 89 c2             	mov    %rax,%rdx
  801a66:	be 01 00 00 00       	mov    $0x1,%esi
  801a6b:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a70:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801a77:	00 00 00 
  801a7a:	ff d0                	callq  *%rax
}
  801a7c:	c9                   	leaveq 
  801a7d:	c3                   	retq   

0000000000801a7e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a7e:	55                   	push   %rbp
  801a7f:	48 89 e5             	mov    %rsp,%rbp
  801a82:	48 83 ec 20          	sub    $0x20,%rsp
  801a86:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a89:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a8d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a91:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a97:	48 63 f0             	movslq %eax,%rsi
  801a9a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa1:	48 98                	cltq   
  801aa3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aae:	00 
  801aaf:	49 89 f1             	mov    %rsi,%r9
  801ab2:	49 89 c8             	mov    %rcx,%r8
  801ab5:	48 89 d1             	mov    %rdx,%rcx
  801ab8:	48 89 c2             	mov    %rax,%rdx
  801abb:	be 00 00 00 00       	mov    $0x0,%esi
  801ac0:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ac5:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801acc:	00 00 00 
  801acf:	ff d0                	callq  *%rax
}
  801ad1:	c9                   	leaveq 
  801ad2:	c3                   	retq   

0000000000801ad3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ad3:	55                   	push   %rbp
  801ad4:	48 89 e5             	mov    %rsp,%rbp
  801ad7:	48 83 ec 10          	sub    $0x10,%rsp
  801adb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801adf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aea:	00 
  801aeb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afc:	48 89 c2             	mov    %rax,%rdx
  801aff:	be 01 00 00 00       	mov    $0x1,%esi
  801b04:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b09:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801b10:	00 00 00 
  801b13:	ff d0                	callq  *%rax
}
  801b15:	c9                   	leaveq 
  801b16:	c3                   	retq   

0000000000801b17 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801b17:	55                   	push   %rbp
  801b18:	48 89 e5             	mov    %rsp,%rbp
  801b1b:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b26:	00 
  801b27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b33:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b38:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3d:	be 00 00 00 00       	mov    $0x0,%esi
  801b42:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b47:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801b4e:	00 00 00 
  801b51:	ff d0                	callq  *%rax
}
  801b53:	c9                   	leaveq 
  801b54:	c3                   	retq   

0000000000801b55 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801b55:	55                   	push   %rbp
  801b56:	48 89 e5             	mov    %rsp,%rbp
  801b59:	48 83 ec 30          	sub    $0x30,%rsp
  801b5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b64:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b67:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b6b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801b6f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b72:	48 63 c8             	movslq %eax,%rcx
  801b75:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b79:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b7c:	48 63 f0             	movslq %eax,%rsi
  801b7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b86:	48 98                	cltq   
  801b88:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b8c:	49 89 f9             	mov    %rdi,%r9
  801b8f:	49 89 f0             	mov    %rsi,%r8
  801b92:	48 89 d1             	mov    %rdx,%rcx
  801b95:	48 89 c2             	mov    %rax,%rdx
  801b98:	be 00 00 00 00       	mov    $0x0,%esi
  801b9d:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ba2:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801ba9:	00 00 00 
  801bac:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801bae:	c9                   	leaveq 
  801baf:	c3                   	retq   

0000000000801bb0 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801bb0:	55                   	push   %rbp
  801bb1:	48 89 e5             	mov    %rsp,%rbp
  801bb4:	48 83 ec 20          	sub    $0x20,%rsp
  801bb8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bbc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801bc0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bc8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bcf:	00 
  801bd0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bdc:	48 89 d1             	mov    %rdx,%rcx
  801bdf:	48 89 c2             	mov    %rax,%rdx
  801be2:	be 00 00 00 00       	mov    $0x0,%esi
  801be7:	bf 10 00 00 00       	mov    $0x10,%edi
  801bec:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801bf3:	00 00 00 
  801bf6:	ff d0                	callq  *%rax
}
  801bf8:	c9                   	leaveq 
  801bf9:	c3                   	retq   

0000000000801bfa <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801bfa:	55                   	push   %rbp
  801bfb:	48 89 e5             	mov    %rsp,%rbp
  801bfe:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801c02:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c09:	00 
  801c0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c16:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c20:	be 00 00 00 00       	mov    $0x0,%esi
  801c25:	bf 11 00 00 00       	mov    $0x11,%edi
  801c2a:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801c31:	00 00 00 
  801c34:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801c36:	c9                   	leaveq 
  801c37:	c3                   	retq   

0000000000801c38 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801c38:	55                   	push   %rbp
  801c39:	48 89 e5             	mov    %rsp,%rbp
  801c3c:	48 83 ec 10          	sub    $0x10,%rsp
  801c40:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c46:	48 98                	cltq   
  801c48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4f:	00 
  801c50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c61:	48 89 c2             	mov    %rax,%rdx
  801c64:	be 00 00 00 00       	mov    $0x0,%esi
  801c69:	bf 12 00 00 00       	mov    $0x12,%edi
  801c6e:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801c75:	00 00 00 
  801c78:	ff d0                	callq  *%rax
}
  801c7a:	c9                   	leaveq 
  801c7b:	c3                   	retq   

0000000000801c7c <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801c7c:	55                   	push   %rbp
  801c7d:	48 89 e5             	mov    %rsp,%rbp
  801c80:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801c84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c8b:	00 
  801c8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca2:	be 00 00 00 00       	mov    $0x0,%esi
  801ca7:	bf 13 00 00 00       	mov    $0x13,%edi
  801cac:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801cb3:	00 00 00 
  801cb6:	ff d0                	callq  *%rax
}
  801cb8:	c9                   	leaveq 
  801cb9:	c3                   	retq   

0000000000801cba <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801cba:	55                   	push   %rbp
  801cbb:	48 89 e5             	mov    %rsp,%rbp
  801cbe:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801cc2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc9:	00 
  801cca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cdb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce0:	be 00 00 00 00       	mov    $0x0,%esi
  801ce5:	bf 14 00 00 00       	mov    $0x14,%edi
  801cea:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  801cf1:	00 00 00 
  801cf4:	ff d0                	callq  *%rax
}
  801cf6:	c9                   	leaveq 
  801cf7:	c3                   	retq   

0000000000801cf8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801cf8:	55                   	push   %rbp
  801cf9:	48 89 e5             	mov    %rsp,%rbp
  801cfc:	48 83 ec 08          	sub    $0x8,%rsp
  801d00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d04:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d08:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d0f:	ff ff ff 
  801d12:	48 01 d0             	add    %rdx,%rax
  801d15:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d19:	c9                   	leaveq 
  801d1a:	c3                   	retq   

0000000000801d1b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d1b:	55                   	push   %rbp
  801d1c:	48 89 e5             	mov    %rsp,%rbp
  801d1f:	48 83 ec 08          	sub    $0x8,%rsp
  801d23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2b:	48 89 c7             	mov    %rax,%rdi
  801d2e:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  801d35:	00 00 00 
  801d38:	ff d0                	callq  *%rax
  801d3a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d40:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d44:	c9                   	leaveq 
  801d45:	c3                   	retq   

0000000000801d46 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	48 83 ec 18          	sub    $0x18,%rsp
  801d4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d59:	eb 6b                	jmp    801dc6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5e:	48 98                	cltq   
  801d60:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d66:	48 c1 e0 0c          	shl    $0xc,%rax
  801d6a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d72:	48 c1 e8 15          	shr    $0x15,%rax
  801d76:	48 89 c2             	mov    %rax,%rdx
  801d79:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d80:	01 00 00 
  801d83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d87:	83 e0 01             	and    $0x1,%eax
  801d8a:	48 85 c0             	test   %rax,%rax
  801d8d:	74 21                	je     801db0 <fd_alloc+0x6a>
  801d8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d93:	48 c1 e8 0c          	shr    $0xc,%rax
  801d97:	48 89 c2             	mov    %rax,%rdx
  801d9a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801da1:	01 00 00 
  801da4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da8:	83 e0 01             	and    $0x1,%eax
  801dab:	48 85 c0             	test   %rax,%rax
  801dae:	75 12                	jne    801dc2 <fd_alloc+0x7c>
			*fd_store = fd;
  801db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc0:	eb 1a                	jmp    801ddc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dc2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dc6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dca:	7e 8f                	jle    801d5b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801dcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801dd7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ddc:	c9                   	leaveq 
  801ddd:	c3                   	retq   

0000000000801dde <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801dde:	55                   	push   %rbp
  801ddf:	48 89 e5             	mov    %rsp,%rbp
  801de2:	48 83 ec 20          	sub    $0x20,%rsp
  801de6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801de9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ded:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801df1:	78 06                	js     801df9 <fd_lookup+0x1b>
  801df3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801df7:	7e 07                	jle    801e00 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801df9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dfe:	eb 6c                	jmp    801e6c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e03:	48 98                	cltq   
  801e05:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e0b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e17:	48 c1 e8 15          	shr    $0x15,%rax
  801e1b:	48 89 c2             	mov    %rax,%rdx
  801e1e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e25:	01 00 00 
  801e28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e2c:	83 e0 01             	and    $0x1,%eax
  801e2f:	48 85 c0             	test   %rax,%rax
  801e32:	74 21                	je     801e55 <fd_lookup+0x77>
  801e34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e38:	48 c1 e8 0c          	shr    $0xc,%rax
  801e3c:	48 89 c2             	mov    %rax,%rdx
  801e3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e46:	01 00 00 
  801e49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e4d:	83 e0 01             	and    $0x1,%eax
  801e50:	48 85 c0             	test   %rax,%rax
  801e53:	75 07                	jne    801e5c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e5a:	eb 10                	jmp    801e6c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e60:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e64:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6c:	c9                   	leaveq 
  801e6d:	c3                   	retq   

0000000000801e6e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e6e:	55                   	push   %rbp
  801e6f:	48 89 e5             	mov    %rsp,%rbp
  801e72:	48 83 ec 30          	sub    $0x30,%rsp
  801e76:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e7a:	89 f0                	mov    %esi,%eax
  801e7c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e83:	48 89 c7             	mov    %rax,%rdi
  801e86:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  801e8d:	00 00 00 
  801e90:	ff d0                	callq  *%rax
  801e92:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e96:	48 89 d6             	mov    %rdx,%rsi
  801e99:	89 c7                	mov    %eax,%edi
  801e9b:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  801ea2:	00 00 00 
  801ea5:	ff d0                	callq  *%rax
  801ea7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eaa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eae:	78 0a                	js     801eba <fd_close+0x4c>
	    || fd != fd2)
  801eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801eb8:	74 12                	je     801ecc <fd_close+0x5e>
		return (must_exist ? r : 0);
  801eba:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ebe:	74 05                	je     801ec5 <fd_close+0x57>
  801ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec3:	eb 05                	jmp    801eca <fd_close+0x5c>
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eca:	eb 69                	jmp    801f35 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ecc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed0:	8b 00                	mov    (%rax),%eax
  801ed2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ed6:	48 89 d6             	mov    %rdx,%rsi
  801ed9:	89 c7                	mov    %eax,%edi
  801edb:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  801ee2:	00 00 00 
  801ee5:	ff d0                	callq  *%rax
  801ee7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eee:	78 2a                	js     801f1a <fd_close+0xac>
		if (dev->dev_close)
  801ef0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef4:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ef8:	48 85 c0             	test   %rax,%rax
  801efb:	74 16                	je     801f13 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801efd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f01:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f05:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f09:	48 89 d7             	mov    %rdx,%rdi
  801f0c:	ff d0                	callq  *%rax
  801f0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f11:	eb 07                	jmp    801f1a <fd_close+0xac>
		else
			r = 0;
  801f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1e:	48 89 c6             	mov    %rax,%rsi
  801f21:	bf 00 00 00 00       	mov    $0x0,%edi
  801f26:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  801f2d:	00 00 00 
  801f30:	ff d0                	callq  *%rax
	return r;
  801f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f35:	c9                   	leaveq 
  801f36:	c3                   	retq   

0000000000801f37 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f37:	55                   	push   %rbp
  801f38:	48 89 e5             	mov    %rsp,%rbp
  801f3b:	48 83 ec 20          	sub    $0x20,%rsp
  801f3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f4d:	eb 41                	jmp    801f90 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f4f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f56:	00 00 00 
  801f59:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f5c:	48 63 d2             	movslq %edx,%rdx
  801f5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f63:	8b 00                	mov    (%rax),%eax
  801f65:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f68:	75 22                	jne    801f8c <dev_lookup+0x55>
			*dev = devtab[i];
  801f6a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f71:	00 00 00 
  801f74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f77:	48 63 d2             	movslq %edx,%rdx
  801f7a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f82:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8a:	eb 60                	jmp    801fec <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f8c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f90:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f97:	00 00 00 
  801f9a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f9d:	48 63 d2             	movslq %edx,%rdx
  801fa0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fa4:	48 85 c0             	test   %rax,%rax
  801fa7:	75 a6                	jne    801f4f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fa9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fb0:	00 00 00 
  801fb3:	48 8b 00             	mov    (%rax),%rax
  801fb6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fbc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fbf:	89 c6                	mov    %eax,%esi
  801fc1:	48 bf b8 48 80 00 00 	movabs $0x8048b8,%rdi
  801fc8:	00 00 00 
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	48 b9 c6 03 80 00 00 	movabs $0x8003c6,%rcx
  801fd7:	00 00 00 
  801fda:	ff d1                	callq  *%rcx
	*dev = 0;
  801fdc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fe7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fec:	c9                   	leaveq 
  801fed:	c3                   	retq   

0000000000801fee <close>:

int
close(int fdnum)
{
  801fee:	55                   	push   %rbp
  801fef:	48 89 e5             	mov    %rsp,%rbp
  801ff2:	48 83 ec 20          	sub    $0x20,%rsp
  801ff6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ffd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802000:	48 89 d6             	mov    %rdx,%rsi
  802003:	89 c7                	mov    %eax,%edi
  802005:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  80200c:	00 00 00 
  80200f:	ff d0                	callq  *%rax
  802011:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802014:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802018:	79 05                	jns    80201f <close+0x31>
		return r;
  80201a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80201d:	eb 18                	jmp    802037 <close+0x49>
	else
		return fd_close(fd, 1);
  80201f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802023:	be 01 00 00 00       	mov    $0x1,%esi
  802028:	48 89 c7             	mov    %rax,%rdi
  80202b:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  802032:	00 00 00 
  802035:	ff d0                	callq  *%rax
}
  802037:	c9                   	leaveq 
  802038:	c3                   	retq   

0000000000802039 <close_all>:

void
close_all(void)
{
  802039:	55                   	push   %rbp
  80203a:	48 89 e5             	mov    %rsp,%rbp
  80203d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802041:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802048:	eb 15                	jmp    80205f <close_all+0x26>
		close(i);
  80204a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204d:	89 c7                	mov    %eax,%edi
  80204f:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802056:	00 00 00 
  802059:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80205b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80205f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802063:	7e e5                	jle    80204a <close_all+0x11>
		close(i);
}
  802065:	c9                   	leaveq 
  802066:	c3                   	retq   

0000000000802067 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802067:	55                   	push   %rbp
  802068:	48 89 e5             	mov    %rsp,%rbp
  80206b:	48 83 ec 40          	sub    $0x40,%rsp
  80206f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802072:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802075:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802079:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80207c:	48 89 d6             	mov    %rdx,%rsi
  80207f:	89 c7                	mov    %eax,%edi
  802081:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802088:	00 00 00 
  80208b:	ff d0                	callq  *%rax
  80208d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802090:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802094:	79 08                	jns    80209e <dup+0x37>
		return r;
  802096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802099:	e9 70 01 00 00       	jmpq   80220e <dup+0x1a7>
	close(newfdnum);
  80209e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020a1:	89 c7                	mov    %eax,%edi
  8020a3:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020af:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020b2:	48 98                	cltq   
  8020b4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020ba:	48 c1 e0 0c          	shl    $0xc,%rax
  8020be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c6:	48 89 c7             	mov    %rax,%rdi
  8020c9:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8020d0:	00 00 00 
  8020d3:	ff d0                	callq  *%rax
  8020d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020dd:	48 89 c7             	mov    %rax,%rdi
  8020e0:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8020e7:	00 00 00 
  8020ea:	ff d0                	callq  *%rax
  8020ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f4:	48 c1 e8 15          	shr    $0x15,%rax
  8020f8:	48 89 c2             	mov    %rax,%rdx
  8020fb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802102:	01 00 00 
  802105:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802109:	83 e0 01             	and    $0x1,%eax
  80210c:	48 85 c0             	test   %rax,%rax
  80210f:	74 73                	je     802184 <dup+0x11d>
  802111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802115:	48 c1 e8 0c          	shr    $0xc,%rax
  802119:	48 89 c2             	mov    %rax,%rdx
  80211c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802123:	01 00 00 
  802126:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212a:	83 e0 01             	and    $0x1,%eax
  80212d:	48 85 c0             	test   %rax,%rax
  802130:	74 52                	je     802184 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802136:	48 c1 e8 0c          	shr    $0xc,%rax
  80213a:	48 89 c2             	mov    %rax,%rdx
  80213d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802144:	01 00 00 
  802147:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214b:	25 07 0e 00 00       	and    $0xe07,%eax
  802150:	89 c1                	mov    %eax,%ecx
  802152:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215a:	41 89 c8             	mov    %ecx,%r8d
  80215d:	48 89 d1             	mov    %rdx,%rcx
  802160:	ba 00 00 00 00       	mov    $0x0,%edx
  802165:	48 89 c6             	mov    %rax,%rsi
  802168:	bf 00 00 00 00       	mov    $0x0,%edi
  80216d:	48 b8 fa 18 80 00 00 	movabs $0x8018fa,%rax
  802174:	00 00 00 
  802177:	ff d0                	callq  *%rax
  802179:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802180:	79 02                	jns    802184 <dup+0x11d>
			goto err;
  802182:	eb 57                	jmp    8021db <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802184:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802188:	48 c1 e8 0c          	shr    $0xc,%rax
  80218c:	48 89 c2             	mov    %rax,%rdx
  80218f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802196:	01 00 00 
  802199:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80219d:	25 07 0e 00 00       	and    $0xe07,%eax
  8021a2:	89 c1                	mov    %eax,%ecx
  8021a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021ac:	41 89 c8             	mov    %ecx,%r8d
  8021af:	48 89 d1             	mov    %rdx,%rcx
  8021b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b7:	48 89 c6             	mov    %rax,%rsi
  8021ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bf:	48 b8 fa 18 80 00 00 	movabs $0x8018fa,%rax
  8021c6:	00 00 00 
  8021c9:	ff d0                	callq  *%rax
  8021cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d2:	79 02                	jns    8021d6 <dup+0x16f>
		goto err;
  8021d4:	eb 05                	jmp    8021db <dup+0x174>

	return newfdnum;
  8021d6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021d9:	eb 33                	jmp    80220e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021df:	48 89 c6             	mov    %rax,%rsi
  8021e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e7:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  8021ee:	00 00 00 
  8021f1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f7:	48 89 c6             	mov    %rax,%rsi
  8021fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ff:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  802206:	00 00 00 
  802209:	ff d0                	callq  *%rax
	return r;
  80220b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80220e:	c9                   	leaveq 
  80220f:	c3                   	retq   

0000000000802210 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802210:	55                   	push   %rbp
  802211:	48 89 e5             	mov    %rsp,%rbp
  802214:	48 83 ec 40          	sub    $0x40,%rsp
  802218:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80221b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80221f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802223:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802227:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80222a:	48 89 d6             	mov    %rdx,%rsi
  80222d:	89 c7                	mov    %eax,%edi
  80222f:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802236:	00 00 00 
  802239:	ff d0                	callq  *%rax
  80223b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802242:	78 24                	js     802268 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802248:	8b 00                	mov    (%rax),%eax
  80224a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80224e:	48 89 d6             	mov    %rdx,%rsi
  802251:	89 c7                	mov    %eax,%edi
  802253:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  80225a:	00 00 00 
  80225d:	ff d0                	callq  *%rax
  80225f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802262:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802266:	79 05                	jns    80226d <read+0x5d>
		return r;
  802268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226b:	eb 76                	jmp    8022e3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80226d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802271:	8b 40 08             	mov    0x8(%rax),%eax
  802274:	83 e0 03             	and    $0x3,%eax
  802277:	83 f8 01             	cmp    $0x1,%eax
  80227a:	75 3a                	jne    8022b6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80227c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802283:	00 00 00 
  802286:	48 8b 00             	mov    (%rax),%rax
  802289:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80228f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802292:	89 c6                	mov    %eax,%esi
  802294:	48 bf d7 48 80 00 00 	movabs $0x8048d7,%rdi
  80229b:	00 00 00 
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a3:	48 b9 c6 03 80 00 00 	movabs $0x8003c6,%rcx
  8022aa:	00 00 00 
  8022ad:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022b4:	eb 2d                	jmp    8022e3 <read+0xd3>
	}
	if (!dev->dev_read)
  8022b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ba:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022be:	48 85 c0             	test   %rax,%rax
  8022c1:	75 07                	jne    8022ca <read+0xba>
		return -E_NOT_SUPP;
  8022c3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022c8:	eb 19                	jmp    8022e3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ce:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022d2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022d6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022da:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022de:	48 89 cf             	mov    %rcx,%rdi
  8022e1:	ff d0                	callq  *%rax
}
  8022e3:	c9                   	leaveq 
  8022e4:	c3                   	retq   

00000000008022e5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022e5:	55                   	push   %rbp
  8022e6:	48 89 e5             	mov    %rsp,%rbp
  8022e9:	48 83 ec 30          	sub    $0x30,%rsp
  8022ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022ff:	eb 49                	jmp    80234a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802301:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802304:	48 98                	cltq   
  802306:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80230a:	48 29 c2             	sub    %rax,%rdx
  80230d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802310:	48 63 c8             	movslq %eax,%rcx
  802313:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802317:	48 01 c1             	add    %rax,%rcx
  80231a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80231d:	48 89 ce             	mov    %rcx,%rsi
  802320:	89 c7                	mov    %eax,%edi
  802322:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  802329:	00 00 00 
  80232c:	ff d0                	callq  *%rax
  80232e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802331:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802335:	79 05                	jns    80233c <readn+0x57>
			return m;
  802337:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80233a:	eb 1c                	jmp    802358 <readn+0x73>
		if (m == 0)
  80233c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802340:	75 02                	jne    802344 <readn+0x5f>
			break;
  802342:	eb 11                	jmp    802355 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802344:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802347:	01 45 fc             	add    %eax,-0x4(%rbp)
  80234a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234d:	48 98                	cltq   
  80234f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802353:	72 ac                	jb     802301 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802355:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802358:	c9                   	leaveq 
  802359:	c3                   	retq   

000000000080235a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80235a:	55                   	push   %rbp
  80235b:	48 89 e5             	mov    %rsp,%rbp
  80235e:	48 83 ec 40          	sub    $0x40,%rsp
  802362:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802365:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802369:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80236d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802371:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802374:	48 89 d6             	mov    %rdx,%rsi
  802377:	89 c7                	mov    %eax,%edi
  802379:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802380:	00 00 00 
  802383:	ff d0                	callq  *%rax
  802385:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802388:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238c:	78 24                	js     8023b2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80238e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802392:	8b 00                	mov    (%rax),%eax
  802394:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802398:	48 89 d6             	mov    %rdx,%rsi
  80239b:	89 c7                	mov    %eax,%edi
  80239d:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  8023a4:	00 00 00 
  8023a7:	ff d0                	callq  *%rax
  8023a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b0:	79 05                	jns    8023b7 <write+0x5d>
		return r;
  8023b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b5:	eb 42                	jmp    8023f9 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bb:	8b 40 08             	mov    0x8(%rax),%eax
  8023be:	83 e0 03             	and    $0x3,%eax
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	75 07                	jne    8023cc <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023ca:	eb 2d                	jmp    8023f9 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023d4:	48 85 c0             	test   %rax,%rax
  8023d7:	75 07                	jne    8023e0 <write+0x86>
		return -E_NOT_SUPP;
  8023d9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023de:	eb 19                	jmp    8023f9 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8023e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023e8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023ec:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023f0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023f4:	48 89 cf             	mov    %rcx,%rdi
  8023f7:	ff d0                	callq  *%rax
}
  8023f9:	c9                   	leaveq 
  8023fa:	c3                   	retq   

00000000008023fb <seek>:

int
seek(int fdnum, off_t offset)
{
  8023fb:	55                   	push   %rbp
  8023fc:	48 89 e5             	mov    %rsp,%rbp
  8023ff:	48 83 ec 18          	sub    $0x18,%rsp
  802403:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802406:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802409:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80240d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802410:	48 89 d6             	mov    %rdx,%rsi
  802413:	89 c7                	mov    %eax,%edi
  802415:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  80241c:	00 00 00 
  80241f:	ff d0                	callq  *%rax
  802421:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802424:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802428:	79 05                	jns    80242f <seek+0x34>
		return r;
  80242a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80242d:	eb 0f                	jmp    80243e <seek+0x43>
	fd->fd_offset = offset;
  80242f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802433:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802436:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243e:	c9                   	leaveq 
  80243f:	c3                   	retq   

0000000000802440 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802440:	55                   	push   %rbp
  802441:	48 89 e5             	mov    %rsp,%rbp
  802444:	48 83 ec 30          	sub    $0x30,%rsp
  802448:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80244b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80244e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802452:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802455:	48 89 d6             	mov    %rdx,%rsi
  802458:	89 c7                	mov    %eax,%edi
  80245a:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802461:	00 00 00 
  802464:	ff d0                	callq  *%rax
  802466:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802469:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246d:	78 24                	js     802493 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80246f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802473:	8b 00                	mov    (%rax),%eax
  802475:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802479:	48 89 d6             	mov    %rdx,%rsi
  80247c:	89 c7                	mov    %eax,%edi
  80247e:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  802485:	00 00 00 
  802488:	ff d0                	callq  *%rax
  80248a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80248d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802491:	79 05                	jns    802498 <ftruncate+0x58>
		return r;
  802493:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802496:	eb 72                	jmp    80250a <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249c:	8b 40 08             	mov    0x8(%rax),%eax
  80249f:	83 e0 03             	and    $0x3,%eax
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	75 3a                	jne    8024e0 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024a6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024ad:	00 00 00 
  8024b0:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024b3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024b9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024bc:	89 c6                	mov    %eax,%esi
  8024be:	48 bf f8 48 80 00 00 	movabs $0x8048f8,%rdi
  8024c5:	00 00 00 
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	48 b9 c6 03 80 00 00 	movabs $0x8003c6,%rcx
  8024d4:	00 00 00 
  8024d7:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8024d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024de:	eb 2a                	jmp    80250a <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024e8:	48 85 c0             	test   %rax,%rax
  8024eb:	75 07                	jne    8024f4 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024ed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024f2:	eb 16                	jmp    80250a <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f8:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802500:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802503:	89 ce                	mov    %ecx,%esi
  802505:	48 89 d7             	mov    %rdx,%rdi
  802508:	ff d0                	callq  *%rax
}
  80250a:	c9                   	leaveq 
  80250b:	c3                   	retq   

000000000080250c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80250c:	55                   	push   %rbp
  80250d:	48 89 e5             	mov    %rsp,%rbp
  802510:	48 83 ec 30          	sub    $0x30,%rsp
  802514:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802517:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80251b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80251f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802522:	48 89 d6             	mov    %rdx,%rsi
  802525:	89 c7                	mov    %eax,%edi
  802527:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  80252e:	00 00 00 
  802531:	ff d0                	callq  *%rax
  802533:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802536:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253a:	78 24                	js     802560 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80253c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802540:	8b 00                	mov    (%rax),%eax
  802542:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802546:	48 89 d6             	mov    %rdx,%rsi
  802549:	89 c7                	mov    %eax,%edi
  80254b:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  802552:	00 00 00 
  802555:	ff d0                	callq  *%rax
  802557:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255e:	79 05                	jns    802565 <fstat+0x59>
		return r;
  802560:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802563:	eb 5e                	jmp    8025c3 <fstat+0xb7>
	if (!dev->dev_stat)
  802565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802569:	48 8b 40 28          	mov    0x28(%rax),%rax
  80256d:	48 85 c0             	test   %rax,%rax
  802570:	75 07                	jne    802579 <fstat+0x6d>
		return -E_NOT_SUPP;
  802572:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802577:	eb 4a                	jmp    8025c3 <fstat+0xb7>
	stat->st_name[0] = 0;
  802579:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80257d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802580:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802584:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80258b:	00 00 00 
	stat->st_isdir = 0;
  80258e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802592:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802599:	00 00 00 
	stat->st_dev = dev;
  80259c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025a4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025af:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025b7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025bb:	48 89 ce             	mov    %rcx,%rsi
  8025be:	48 89 d7             	mov    %rdx,%rdi
  8025c1:	ff d0                	callq  *%rax
}
  8025c3:	c9                   	leaveq 
  8025c4:	c3                   	retq   

00000000008025c5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025c5:	55                   	push   %rbp
  8025c6:	48 89 e5             	mov    %rsp,%rbp
  8025c9:	48 83 ec 20          	sub    $0x20,%rsp
  8025cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d9:	be 00 00 00 00       	mov    $0x0,%esi
  8025de:	48 89 c7             	mov    %rax,%rdi
  8025e1:	48 b8 b3 26 80 00 00 	movabs $0x8026b3,%rax
  8025e8:	00 00 00 
  8025eb:	ff d0                	callq  *%rax
  8025ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f4:	79 05                	jns    8025fb <stat+0x36>
		return fd;
  8025f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f9:	eb 2f                	jmp    80262a <stat+0x65>
	r = fstat(fd, stat);
  8025fb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802602:	48 89 d6             	mov    %rdx,%rsi
  802605:	89 c7                	mov    %eax,%edi
  802607:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  80260e:	00 00 00 
  802611:	ff d0                	callq  *%rax
  802613:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802616:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802619:	89 c7                	mov    %eax,%edi
  80261b:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802622:	00 00 00 
  802625:	ff d0                	callq  *%rax
	return r;
  802627:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80262a:	c9                   	leaveq 
  80262b:	c3                   	retq   

000000000080262c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80262c:	55                   	push   %rbp
  80262d:	48 89 e5             	mov    %rsp,%rbp
  802630:	48 83 ec 10          	sub    $0x10,%rsp
  802634:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802637:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80263b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802642:	00 00 00 
  802645:	8b 00                	mov    (%rax),%eax
  802647:	85 c0                	test   %eax,%eax
  802649:	75 1d                	jne    802668 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80264b:	bf 01 00 00 00       	mov    $0x1,%edi
  802650:	48 b8 17 42 80 00 00 	movabs $0x804217,%rax
  802657:	00 00 00 
  80265a:	ff d0                	callq  *%rax
  80265c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802663:	00 00 00 
  802666:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802668:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80266f:	00 00 00 
  802672:	8b 00                	mov    (%rax),%eax
  802674:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802677:	b9 07 00 00 00       	mov    $0x7,%ecx
  80267c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802683:	00 00 00 
  802686:	89 c7                	mov    %eax,%edi
  802688:	48 b8 8f 41 80 00 00 	movabs $0x80418f,%rax
  80268f:	00 00 00 
  802692:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802698:	ba 00 00 00 00       	mov    $0x0,%edx
  80269d:	48 89 c6             	mov    %rax,%rsi
  8026a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026a5:	48 b8 91 40 80 00 00 	movabs $0x804091,%rax
  8026ac:	00 00 00 
  8026af:	ff d0                	callq  *%rax
}
  8026b1:	c9                   	leaveq 
  8026b2:	c3                   	retq   

00000000008026b3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026b3:	55                   	push   %rbp
  8026b4:	48 89 e5             	mov    %rsp,%rbp
  8026b7:	48 83 ec 30          	sub    $0x30,%rsp
  8026bb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026bf:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8026c2:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8026c9:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8026d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8026d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8026dc:	75 08                	jne    8026e6 <open+0x33>
	{
		return r;
  8026de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e1:	e9 f2 00 00 00       	jmpq   8027d8 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8026e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ea:	48 89 c7             	mov    %rax,%rdi
  8026ed:	48 b8 0f 0f 80 00 00 	movabs $0x800f0f,%rax
  8026f4:	00 00 00 
  8026f7:	ff d0                	callq  *%rax
  8026f9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8026fc:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802703:	7e 0a                	jle    80270f <open+0x5c>
	{
		return -E_BAD_PATH;
  802705:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80270a:	e9 c9 00 00 00       	jmpq   8027d8 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80270f:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802716:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802717:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80271b:	48 89 c7             	mov    %rax,%rdi
  80271e:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  802725:	00 00 00 
  802728:	ff d0                	callq  *%rax
  80272a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80272d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802731:	78 09                	js     80273c <open+0x89>
  802733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802737:	48 85 c0             	test   %rax,%rax
  80273a:	75 08                	jne    802744 <open+0x91>
		{
			return r;
  80273c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273f:	e9 94 00 00 00       	jmpq   8027d8 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802748:	ba 00 04 00 00       	mov    $0x400,%edx
  80274d:	48 89 c6             	mov    %rax,%rsi
  802750:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802757:	00 00 00 
  80275a:	48 b8 0d 10 80 00 00 	movabs $0x80100d,%rax
  802761:	00 00 00 
  802764:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802766:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80276d:	00 00 00 
  802770:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802773:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802779:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80277d:	48 89 c6             	mov    %rax,%rsi
  802780:	bf 01 00 00 00       	mov    $0x1,%edi
  802785:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  80278c:	00 00 00 
  80278f:	ff d0                	callq  *%rax
  802791:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802794:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802798:	79 2b                	jns    8027c5 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80279a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279e:	be 00 00 00 00       	mov    $0x0,%esi
  8027a3:	48 89 c7             	mov    %rax,%rdi
  8027a6:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	callq  *%rax
  8027b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8027b5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027b9:	79 05                	jns    8027c0 <open+0x10d>
			{
				return d;
  8027bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027be:	eb 18                	jmp    8027d8 <open+0x125>
			}
			return r;
  8027c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c3:	eb 13                	jmp    8027d8 <open+0x125>
		}	
		return fd2num(fd_store);
  8027c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c9:	48 89 c7             	mov    %rax,%rdi
  8027cc:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  8027d3:	00 00 00 
  8027d6:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8027d8:	c9                   	leaveq 
  8027d9:	c3                   	retq   

00000000008027da <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027da:	55                   	push   %rbp
  8027db:	48 89 e5             	mov    %rsp,%rbp
  8027de:	48 83 ec 10          	sub    $0x10,%rsp
  8027e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ea:	8b 50 0c             	mov    0xc(%rax),%edx
  8027ed:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027f4:	00 00 00 
  8027f7:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027f9:	be 00 00 00 00       	mov    $0x0,%esi
  8027fe:	bf 06 00 00 00       	mov    $0x6,%edi
  802803:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  80280a:	00 00 00 
  80280d:	ff d0                	callq  *%rax
}
  80280f:	c9                   	leaveq 
  802810:	c3                   	retq   

0000000000802811 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802811:	55                   	push   %rbp
  802812:	48 89 e5             	mov    %rsp,%rbp
  802815:	48 83 ec 30          	sub    $0x30,%rsp
  802819:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80281d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802821:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802825:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80282c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802831:	74 07                	je     80283a <devfile_read+0x29>
  802833:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802838:	75 07                	jne    802841 <devfile_read+0x30>
		return -E_INVAL;
  80283a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80283f:	eb 77                	jmp    8028b8 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802845:	8b 50 0c             	mov    0xc(%rax),%edx
  802848:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80284f:	00 00 00 
  802852:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802854:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80285b:	00 00 00 
  80285e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802862:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802866:	be 00 00 00 00       	mov    $0x0,%esi
  80286b:	bf 03 00 00 00       	mov    $0x3,%edi
  802870:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  802877:	00 00 00 
  80287a:	ff d0                	callq  *%rax
  80287c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802883:	7f 05                	jg     80288a <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802885:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802888:	eb 2e                	jmp    8028b8 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80288a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288d:	48 63 d0             	movslq %eax,%rdx
  802890:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802894:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80289b:	00 00 00 
  80289e:	48 89 c7             	mov    %rax,%rdi
  8028a1:	48 b8 9f 12 80 00 00 	movabs $0x80129f,%rax
  8028a8:	00 00 00 
  8028ab:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8028ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8028b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8028b8:	c9                   	leaveq 
  8028b9:	c3                   	retq   

00000000008028ba <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028ba:	55                   	push   %rbp
  8028bb:	48 89 e5             	mov    %rsp,%rbp
  8028be:	48 83 ec 30          	sub    $0x30,%rsp
  8028c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8028ce:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8028d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028da:	74 07                	je     8028e3 <devfile_write+0x29>
  8028dc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028e1:	75 08                	jne    8028eb <devfile_write+0x31>
		return r;
  8028e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e6:	e9 9a 00 00 00       	jmpq   802985 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8028eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ef:	8b 50 0c             	mov    0xc(%rax),%edx
  8028f2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028f9:	00 00 00 
  8028fc:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8028fe:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802905:	00 
  802906:	76 08                	jbe    802910 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802908:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80290f:	00 
	}
	fsipcbuf.write.req_n = n;
  802910:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802917:	00 00 00 
  80291a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80291e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802922:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802926:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80292a:	48 89 c6             	mov    %rax,%rsi
  80292d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802934:	00 00 00 
  802937:	48 b8 9f 12 80 00 00 	movabs $0x80129f,%rax
  80293e:	00 00 00 
  802941:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802943:	be 00 00 00 00       	mov    $0x0,%esi
  802948:	bf 04 00 00 00       	mov    $0x4,%edi
  80294d:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  802954:	00 00 00 
  802957:	ff d0                	callq  *%rax
  802959:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802960:	7f 20                	jg     802982 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802962:	48 bf 1e 49 80 00 00 	movabs $0x80491e,%rdi
  802969:	00 00 00 
  80296c:	b8 00 00 00 00       	mov    $0x0,%eax
  802971:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  802978:	00 00 00 
  80297b:	ff d2                	callq  *%rdx
		return r;
  80297d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802980:	eb 03                	jmp    802985 <devfile_write+0xcb>
	}
	return r;
  802982:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802985:	c9                   	leaveq 
  802986:	c3                   	retq   

0000000000802987 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802987:	55                   	push   %rbp
  802988:	48 89 e5             	mov    %rsp,%rbp
  80298b:	48 83 ec 20          	sub    $0x20,%rsp
  80298f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802993:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299b:	8b 50 0c             	mov    0xc(%rax),%edx
  80299e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029a5:	00 00 00 
  8029a8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029aa:	be 00 00 00 00       	mov    $0x0,%esi
  8029af:	bf 05 00 00 00       	mov    $0x5,%edi
  8029b4:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  8029bb:	00 00 00 
  8029be:	ff d0                	callq  *%rax
  8029c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c7:	79 05                	jns    8029ce <devfile_stat+0x47>
		return r;
  8029c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cc:	eb 56                	jmp    802a24 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8029ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029d2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8029d9:	00 00 00 
  8029dc:	48 89 c7             	mov    %rax,%rdi
  8029df:	48 b8 7b 0f 80 00 00 	movabs $0x800f7b,%rax
  8029e6:	00 00 00 
  8029e9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029eb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029f2:	00 00 00 
  8029f5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ff:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a05:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a0c:	00 00 00 
  802a0f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a19:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a24:	c9                   	leaveq 
  802a25:	c3                   	retq   

0000000000802a26 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a26:	55                   	push   %rbp
  802a27:	48 89 e5             	mov    %rsp,%rbp
  802a2a:	48 83 ec 10          	sub    $0x10,%rsp
  802a2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a32:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a39:	8b 50 0c             	mov    0xc(%rax),%edx
  802a3c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a43:	00 00 00 
  802a46:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a48:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a4f:	00 00 00 
  802a52:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a55:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a58:	be 00 00 00 00       	mov    $0x0,%esi
  802a5d:	bf 02 00 00 00       	mov    $0x2,%edi
  802a62:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  802a69:	00 00 00 
  802a6c:	ff d0                	callq  *%rax
}
  802a6e:	c9                   	leaveq 
  802a6f:	c3                   	retq   

0000000000802a70 <remove>:

// Delete a file
int
remove(const char *path)
{
  802a70:	55                   	push   %rbp
  802a71:	48 89 e5             	mov    %rsp,%rbp
  802a74:	48 83 ec 10          	sub    $0x10,%rsp
  802a78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a80:	48 89 c7             	mov    %rax,%rdi
  802a83:	48 b8 0f 0f 80 00 00 	movabs $0x800f0f,%rax
  802a8a:	00 00 00 
  802a8d:	ff d0                	callq  *%rax
  802a8f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a94:	7e 07                	jle    802a9d <remove+0x2d>
		return -E_BAD_PATH;
  802a96:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a9b:	eb 33                	jmp    802ad0 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aa1:	48 89 c6             	mov    %rax,%rsi
  802aa4:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802aab:	00 00 00 
  802aae:	48 b8 7b 0f 80 00 00 	movabs $0x800f7b,%rax
  802ab5:	00 00 00 
  802ab8:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802aba:	be 00 00 00 00       	mov    $0x0,%esi
  802abf:	bf 07 00 00 00       	mov    $0x7,%edi
  802ac4:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  802acb:	00 00 00 
  802ace:	ff d0                	callq  *%rax
}
  802ad0:	c9                   	leaveq 
  802ad1:	c3                   	retq   

0000000000802ad2 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ad2:	55                   	push   %rbp
  802ad3:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ad6:	be 00 00 00 00       	mov    $0x0,%esi
  802adb:	bf 08 00 00 00       	mov    $0x8,%edi
  802ae0:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  802ae7:	00 00 00 
  802aea:	ff d0                	callq  *%rax
}
  802aec:	5d                   	pop    %rbp
  802aed:	c3                   	retq   

0000000000802aee <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802aee:	55                   	push   %rbp
  802aef:	48 89 e5             	mov    %rsp,%rbp
  802af2:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802af9:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b00:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b07:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b0e:	be 00 00 00 00       	mov    $0x0,%esi
  802b13:	48 89 c7             	mov    %rax,%rdi
  802b16:	48 b8 b3 26 80 00 00 	movabs $0x8026b3,%rax
  802b1d:	00 00 00 
  802b20:	ff d0                	callq  *%rax
  802b22:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b29:	79 28                	jns    802b53 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2e:	89 c6                	mov    %eax,%esi
  802b30:	48 bf 3a 49 80 00 00 	movabs $0x80493a,%rdi
  802b37:	00 00 00 
  802b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3f:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  802b46:	00 00 00 
  802b49:	ff d2                	callq  *%rdx
		return fd_src;
  802b4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4e:	e9 74 01 00 00       	jmpq   802cc7 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b53:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b5a:	be 01 01 00 00       	mov    $0x101,%esi
  802b5f:	48 89 c7             	mov    %rax,%rdi
  802b62:	48 b8 b3 26 80 00 00 	movabs $0x8026b3,%rax
  802b69:	00 00 00 
  802b6c:	ff d0                	callq  *%rax
  802b6e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b71:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b75:	79 39                	jns    802bb0 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b77:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b7a:	89 c6                	mov    %eax,%esi
  802b7c:	48 bf 50 49 80 00 00 	movabs $0x804950,%rdi
  802b83:	00 00 00 
  802b86:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8b:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  802b92:	00 00 00 
  802b95:	ff d2                	callq  *%rdx
		close(fd_src);
  802b97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9a:	89 c7                	mov    %eax,%edi
  802b9c:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802ba3:	00 00 00 
  802ba6:	ff d0                	callq  *%rax
		return fd_dest;
  802ba8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bab:	e9 17 01 00 00       	jmpq   802cc7 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bb0:	eb 74                	jmp    802c26 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802bb2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bb5:	48 63 d0             	movslq %eax,%rdx
  802bb8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bbf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc2:	48 89 ce             	mov    %rcx,%rsi
  802bc5:	89 c7                	mov    %eax,%edi
  802bc7:	48 b8 5a 23 80 00 00 	movabs $0x80235a,%rax
  802bce:	00 00 00 
  802bd1:	ff d0                	callq  *%rax
  802bd3:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802bd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802bda:	79 4a                	jns    802c26 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802bdc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bdf:	89 c6                	mov    %eax,%esi
  802be1:	48 bf 6a 49 80 00 00 	movabs $0x80496a,%rdi
  802be8:	00 00 00 
  802beb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf0:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  802bf7:	00 00 00 
  802bfa:	ff d2                	callq  *%rdx
			close(fd_src);
  802bfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bff:	89 c7                	mov    %eax,%edi
  802c01:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802c08:	00 00 00 
  802c0b:	ff d0                	callq  *%rax
			close(fd_dest);
  802c0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c10:	89 c7                	mov    %eax,%edi
  802c12:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802c19:	00 00 00 
  802c1c:	ff d0                	callq  *%rax
			return write_size;
  802c1e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c21:	e9 a1 00 00 00       	jmpq   802cc7 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c26:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c30:	ba 00 02 00 00       	mov    $0x200,%edx
  802c35:	48 89 ce             	mov    %rcx,%rsi
  802c38:	89 c7                	mov    %eax,%edi
  802c3a:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  802c41:	00 00 00 
  802c44:	ff d0                	callq  *%rax
  802c46:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c49:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c4d:	0f 8f 5f ff ff ff    	jg     802bb2 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802c53:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c57:	79 47                	jns    802ca0 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c59:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c5c:	89 c6                	mov    %eax,%esi
  802c5e:	48 bf 7d 49 80 00 00 	movabs $0x80497d,%rdi
  802c65:	00 00 00 
  802c68:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6d:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  802c74:	00 00 00 
  802c77:	ff d2                	callq  *%rdx
		close(fd_src);
  802c79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7c:	89 c7                	mov    %eax,%edi
  802c7e:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802c85:	00 00 00 
  802c88:	ff d0                	callq  *%rax
		close(fd_dest);
  802c8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c8d:	89 c7                	mov    %eax,%edi
  802c8f:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802c96:	00 00 00 
  802c99:	ff d0                	callq  *%rax
		return read_size;
  802c9b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c9e:	eb 27                	jmp    802cc7 <copy+0x1d9>
	}
	close(fd_src);
  802ca0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca3:	89 c7                	mov    %eax,%edi
  802ca5:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802cac:	00 00 00 
  802caf:	ff d0                	callq  *%rax
	close(fd_dest);
  802cb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cb4:	89 c7                	mov    %eax,%edi
  802cb6:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
	return 0;
  802cc2:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802cc7:	c9                   	leaveq 
  802cc8:	c3                   	retq   

0000000000802cc9 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802cc9:	55                   	push   %rbp
  802cca:	48 89 e5             	mov    %rsp,%rbp
  802ccd:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802cd4:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802cdb:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802ce2:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802ce9:	be 00 00 00 00       	mov    $0x0,%esi
  802cee:	48 89 c7             	mov    %rax,%rdi
  802cf1:	48 b8 b3 26 80 00 00 	movabs $0x8026b3,%rax
  802cf8:	00 00 00 
  802cfb:	ff d0                	callq  *%rax
  802cfd:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d00:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d04:	79 08                	jns    802d0e <spawn+0x45>
		return r;
  802d06:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d09:	e9 0c 03 00 00       	jmpq   80301a <spawn+0x351>
	fd = r;
  802d0e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d11:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802d14:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802d1b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802d1f:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802d26:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802d29:	ba 00 02 00 00       	mov    $0x200,%edx
  802d2e:	48 89 ce             	mov    %rcx,%rsi
  802d31:	89 c7                	mov    %eax,%edi
  802d33:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  802d3a:	00 00 00 
  802d3d:	ff d0                	callq  *%rax
  802d3f:	3d 00 02 00 00       	cmp    $0x200,%eax
  802d44:	75 0d                	jne    802d53 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802d46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d4a:	8b 00                	mov    (%rax),%eax
  802d4c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802d51:	74 43                	je     802d96 <spawn+0xcd>
		close(fd);
  802d53:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802d56:	89 c7                	mov    %eax,%edi
  802d58:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802d5f:	00 00 00 
  802d62:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802d64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d68:	8b 00                	mov    (%rax),%eax
  802d6a:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802d6f:	89 c6                	mov    %eax,%esi
  802d71:	48 bf 98 49 80 00 00 	movabs $0x804998,%rdi
  802d78:	00 00 00 
  802d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d80:	48 b9 c6 03 80 00 00 	movabs $0x8003c6,%rcx
  802d87:	00 00 00 
  802d8a:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802d8c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802d91:	e9 84 02 00 00       	jmpq   80301a <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802d96:	b8 07 00 00 00       	mov    $0x7,%eax
  802d9b:	cd 30                	int    $0x30
  802d9d:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802da0:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802da3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802da6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802daa:	79 08                	jns    802db4 <spawn+0xeb>
		return r;
  802dac:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802daf:	e9 66 02 00 00       	jmpq   80301a <spawn+0x351>
	child = r;
  802db4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802db7:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802dba:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802dbd:	25 ff 03 00 00       	and    $0x3ff,%eax
  802dc2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802dc9:	00 00 00 
  802dcc:	48 98                	cltq   
  802dce:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802dd5:	48 01 d0             	add    %rdx,%rax
  802dd8:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802ddf:	48 89 c6             	mov    %rax,%rsi
  802de2:	b8 18 00 00 00       	mov    $0x18,%eax
  802de7:	48 89 d7             	mov    %rdx,%rdi
  802dea:	48 89 c1             	mov    %rax,%rcx
  802ded:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802df0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802df4:	48 8b 40 18          	mov    0x18(%rax),%rax
  802df8:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802dff:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802e06:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802e0d:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802e14:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e17:	48 89 ce             	mov    %rcx,%rsi
  802e1a:	89 c7                	mov    %eax,%edi
  802e1c:	48 b8 84 32 80 00 00 	movabs $0x803284,%rax
  802e23:	00 00 00 
  802e26:	ff d0                	callq  *%rax
  802e28:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e2b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e2f:	79 08                	jns    802e39 <spawn+0x170>
		return r;
  802e31:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e34:	e9 e1 01 00 00       	jmpq   80301a <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802e39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e3d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802e41:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802e48:	48 01 d0             	add    %rdx,%rax
  802e4b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e56:	e9 a3 00 00 00       	jmpq   802efe <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  802e5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5f:	8b 00                	mov    (%rax),%eax
  802e61:	83 f8 01             	cmp    $0x1,%eax
  802e64:	74 05                	je     802e6b <spawn+0x1a2>
			continue;
  802e66:	e9 8a 00 00 00       	jmpq   802ef5 <spawn+0x22c>
		perm = PTE_P | PTE_U;
  802e6b:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802e72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e76:	8b 40 04             	mov    0x4(%rax),%eax
  802e79:	83 e0 02             	and    $0x2,%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	74 04                	je     802e84 <spawn+0x1bb>
			perm |= PTE_W;
  802e80:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802e84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e88:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802e8c:	41 89 c1             	mov    %eax,%r9d
  802e8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e93:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802e97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9b:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea3:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802ea7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802eaa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ead:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802eb0:	89 3c 24             	mov    %edi,(%rsp)
  802eb3:	89 c7                	mov    %eax,%edi
  802eb5:	48 b8 2d 35 80 00 00 	movabs $0x80352d,%rax
  802ebc:	00 00 00 
  802ebf:	ff d0                	callq  *%rax
  802ec1:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ec4:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ec8:	79 2b                	jns    802ef5 <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802eca:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802ecb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ece:	89 c7                	mov    %eax,%edi
  802ed0:	48 b8 ea 17 80 00 00 	movabs $0x8017ea,%rax
  802ed7:	00 00 00 
  802eda:	ff d0                	callq  *%rax
	close(fd);
  802edc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802edf:	89 c7                	mov    %eax,%edi
  802ee1:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802ee8:	00 00 00 
  802eeb:	ff d0                	callq  *%rax
	return r;
  802eed:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ef0:	e9 25 01 00 00       	jmpq   80301a <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ef5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ef9:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802efe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f02:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802f06:	0f b7 c0             	movzwl %ax,%eax
  802f09:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802f0c:	0f 8f 49 ff ff ff    	jg     802e5b <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802f12:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f15:	89 c7                	mov    %eax,%edi
  802f17:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802f1e:	00 00 00 
  802f21:	ff d0                	callq  *%rax
	fd = -1;
  802f23:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802f2a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f2d:	89 c7                	mov    %eax,%edi
  802f2f:	48 b8 19 37 80 00 00 	movabs $0x803719,%rax
  802f36:	00 00 00 
  802f39:	ff d0                	callq  *%rax
  802f3b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f3e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f42:	79 30                	jns    802f74 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  802f44:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f47:	89 c1                	mov    %eax,%ecx
  802f49:	48 ba b2 49 80 00 00 	movabs $0x8049b2,%rdx
  802f50:	00 00 00 
  802f53:	be 82 00 00 00       	mov    $0x82,%esi
  802f58:	48 bf c8 49 80 00 00 	movabs $0x8049c8,%rdi
  802f5f:	00 00 00 
  802f62:	b8 00 00 00 00       	mov    $0x0,%eax
  802f67:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  802f6e:	00 00 00 
  802f71:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802f74:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802f7b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f7e:	48 89 d6             	mov    %rdx,%rsi
  802f81:	89 c7                	mov    %eax,%edi
  802f83:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  802f8a:	00 00 00 
  802f8d:	ff d0                	callq  *%rax
  802f8f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f92:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f96:	79 30                	jns    802fc8 <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  802f98:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f9b:	89 c1                	mov    %eax,%ecx
  802f9d:	48 ba d4 49 80 00 00 	movabs $0x8049d4,%rdx
  802fa4:	00 00 00 
  802fa7:	be 85 00 00 00       	mov    $0x85,%esi
  802fac:	48 bf c8 49 80 00 00 	movabs $0x8049c8,%rdi
  802fb3:	00 00 00 
  802fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802fbb:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  802fc2:	00 00 00 
  802fc5:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802fc8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802fcb:	be 02 00 00 00       	mov    $0x2,%esi
  802fd0:	89 c7                	mov    %eax,%edi
  802fd2:	48 b8 9f 19 80 00 00 	movabs $0x80199f,%rax
  802fd9:	00 00 00 
  802fdc:	ff d0                	callq  *%rax
  802fde:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802fe1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802fe5:	79 30                	jns    803017 <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  802fe7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802fea:	89 c1                	mov    %eax,%ecx
  802fec:	48 ba ee 49 80 00 00 	movabs $0x8049ee,%rdx
  802ff3:	00 00 00 
  802ff6:	be 88 00 00 00       	mov    $0x88,%esi
  802ffb:	48 bf c8 49 80 00 00 	movabs $0x8049c8,%rdi
  803002:	00 00 00 
  803005:	b8 00 00 00 00       	mov    $0x0,%eax
  80300a:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  803011:	00 00 00 
  803014:	41 ff d0             	callq  *%r8

	return child;
  803017:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80301a:	c9                   	leaveq 
  80301b:	c3                   	retq   

000000000080301c <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80301c:	55                   	push   %rbp
  80301d:	48 89 e5             	mov    %rsp,%rbp
  803020:	41 55                	push   %r13
  803022:	41 54                	push   %r12
  803024:	53                   	push   %rbx
  803025:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80302c:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803033:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  80303a:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803041:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803048:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  80304f:	84 c0                	test   %al,%al
  803051:	74 26                	je     803079 <spawnl+0x5d>
  803053:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80305a:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803061:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803065:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803069:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80306d:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803071:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803075:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803079:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803080:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803087:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80308a:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803091:	00 00 00 
  803094:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80309b:	00 00 00 
  80309e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030a2:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8030a9:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8030b0:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  8030b7:	eb 07                	jmp    8030c0 <spawnl+0xa4>
		argc++;
  8030b9:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8030c0:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8030c6:	83 f8 30             	cmp    $0x30,%eax
  8030c9:	73 23                	jae    8030ee <spawnl+0xd2>
  8030cb:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8030d2:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8030d8:	89 c0                	mov    %eax,%eax
  8030da:	48 01 d0             	add    %rdx,%rax
  8030dd:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8030e3:	83 c2 08             	add    $0x8,%edx
  8030e6:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8030ec:	eb 15                	jmp    803103 <spawnl+0xe7>
  8030ee:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8030f5:	48 89 d0             	mov    %rdx,%rax
  8030f8:	48 83 c2 08          	add    $0x8,%rdx
  8030fc:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803103:	48 8b 00             	mov    (%rax),%rax
  803106:	48 85 c0             	test   %rax,%rax
  803109:	75 ae                	jne    8030b9 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  80310b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803111:	83 c0 02             	add    $0x2,%eax
  803114:	48 89 e2             	mov    %rsp,%rdx
  803117:	48 89 d3             	mov    %rdx,%rbx
  80311a:	48 63 d0             	movslq %eax,%rdx
  80311d:	48 83 ea 01          	sub    $0x1,%rdx
  803121:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803128:	48 63 d0             	movslq %eax,%rdx
  80312b:	49 89 d4             	mov    %rdx,%r12
  80312e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803134:	48 63 d0             	movslq %eax,%rdx
  803137:	49 89 d2             	mov    %rdx,%r10
  80313a:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803140:	48 98                	cltq   
  803142:	48 c1 e0 03          	shl    $0x3,%rax
  803146:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80314a:	b8 10 00 00 00       	mov    $0x10,%eax
  80314f:	48 83 e8 01          	sub    $0x1,%rax
  803153:	48 01 d0             	add    %rdx,%rax
  803156:	bf 10 00 00 00       	mov    $0x10,%edi
  80315b:	ba 00 00 00 00       	mov    $0x0,%edx
  803160:	48 f7 f7             	div    %rdi
  803163:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803167:	48 29 c4             	sub    %rax,%rsp
  80316a:	48 89 e0             	mov    %rsp,%rax
  80316d:	48 83 c0 07          	add    $0x7,%rax
  803171:	48 c1 e8 03          	shr    $0x3,%rax
  803175:	48 c1 e0 03          	shl    $0x3,%rax
  803179:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803180:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803187:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  80318e:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803191:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803197:	8d 50 01             	lea    0x1(%rax),%edx
  80319a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8031a1:	48 63 d2             	movslq %edx,%rdx
  8031a4:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8031ab:	00 

	va_start(vl, arg0);
  8031ac:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8031b3:	00 00 00 
  8031b6:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8031bd:	00 00 00 
  8031c0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8031c4:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8031cb:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8031d2:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8031d9:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8031e0:	00 00 00 
  8031e3:	eb 63                	jmp    803248 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  8031e5:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8031eb:	8d 70 01             	lea    0x1(%rax),%esi
  8031ee:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8031f4:	83 f8 30             	cmp    $0x30,%eax
  8031f7:	73 23                	jae    80321c <spawnl+0x200>
  8031f9:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803200:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803206:	89 c0                	mov    %eax,%eax
  803208:	48 01 d0             	add    %rdx,%rax
  80320b:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803211:	83 c2 08             	add    $0x8,%edx
  803214:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80321a:	eb 15                	jmp    803231 <spawnl+0x215>
  80321c:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803223:	48 89 d0             	mov    %rdx,%rax
  803226:	48 83 c2 08          	add    $0x8,%rdx
  80322a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803231:	48 8b 08             	mov    (%rax),%rcx
  803234:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80323b:	89 f2                	mov    %esi,%edx
  80323d:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803241:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803248:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80324e:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803254:	77 8f                	ja     8031e5 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803256:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80325d:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803264:	48 89 d6             	mov    %rdx,%rsi
  803267:	48 89 c7             	mov    %rax,%rdi
  80326a:	48 b8 c9 2c 80 00 00 	movabs $0x802cc9,%rax
  803271:	00 00 00 
  803274:	ff d0                	callq  *%rax
  803276:	48 89 dc             	mov    %rbx,%rsp
}
  803279:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  80327d:	5b                   	pop    %rbx
  80327e:	41 5c                	pop    %r12
  803280:	41 5d                	pop    %r13
  803282:	5d                   	pop    %rbp
  803283:	c3                   	retq   

0000000000803284 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803284:	55                   	push   %rbp
  803285:	48 89 e5             	mov    %rsp,%rbp
  803288:	48 83 ec 50          	sub    $0x50,%rsp
  80328c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80328f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803293:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803297:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80329e:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  80329f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8032a6:	eb 33                	jmp    8032db <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8032a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032ab:	48 98                	cltq   
  8032ad:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032b4:	00 
  8032b5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032b9:	48 01 d0             	add    %rdx,%rax
  8032bc:	48 8b 00             	mov    (%rax),%rax
  8032bf:	48 89 c7             	mov    %rax,%rdi
  8032c2:	48 b8 0f 0f 80 00 00 	movabs $0x800f0f,%rax
  8032c9:	00 00 00 
  8032cc:	ff d0                	callq  *%rax
  8032ce:	83 c0 01             	add    $0x1,%eax
  8032d1:	48 98                	cltq   
  8032d3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8032d7:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8032db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032de:	48 98                	cltq   
  8032e0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032e7:	00 
  8032e8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032ec:	48 01 d0             	add    %rdx,%rax
  8032ef:	48 8b 00             	mov    (%rax),%rax
  8032f2:	48 85 c0             	test   %rax,%rax
  8032f5:	75 b1                	jne    8032a8 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8032f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032fb:	48 f7 d8             	neg    %rax
  8032fe:	48 05 00 10 40 00    	add    $0x401000,%rax
  803304:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803308:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80330c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803310:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803314:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803318:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80331b:	83 c2 01             	add    $0x1,%edx
  80331e:	c1 e2 03             	shl    $0x3,%edx
  803321:	48 63 d2             	movslq %edx,%rdx
  803324:	48 f7 da             	neg    %rdx
  803327:	48 01 d0             	add    %rdx,%rax
  80332a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80332e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803332:	48 83 e8 10          	sub    $0x10,%rax
  803336:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80333c:	77 0a                	ja     803348 <init_stack+0xc4>
		return -E_NO_MEM;
  80333e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803343:	e9 e3 01 00 00       	jmpq   80352b <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803348:	ba 07 00 00 00       	mov    $0x7,%edx
  80334d:	be 00 00 40 00       	mov    $0x400000,%esi
  803352:	bf 00 00 00 00       	mov    $0x0,%edi
  803357:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  80335e:	00 00 00 
  803361:	ff d0                	callq  *%rax
  803363:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803366:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80336a:	79 08                	jns    803374 <init_stack+0xf0>
		return r;
  80336c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336f:	e9 b7 01 00 00       	jmpq   80352b <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803374:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80337b:	e9 8a 00 00 00       	jmpq   80340a <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803380:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803383:	48 98                	cltq   
  803385:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80338c:	00 
  80338d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803391:	48 01 c2             	add    %rax,%rdx
  803394:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803399:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339d:	48 01 c8             	add    %rcx,%rax
  8033a0:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033a6:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  8033a9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033ac:	48 98                	cltq   
  8033ae:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8033b5:	00 
  8033b6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8033ba:	48 01 d0             	add    %rdx,%rax
  8033bd:	48 8b 10             	mov    (%rax),%rdx
  8033c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033c4:	48 89 d6             	mov    %rdx,%rsi
  8033c7:	48 89 c7             	mov    %rax,%rdi
  8033ca:	48 b8 7b 0f 80 00 00 	movabs $0x800f7b,%rax
  8033d1:	00 00 00 
  8033d4:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8033d6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033d9:	48 98                	cltq   
  8033db:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8033e2:	00 
  8033e3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8033e7:	48 01 d0             	add    %rdx,%rax
  8033ea:	48 8b 00             	mov    (%rax),%rax
  8033ed:	48 89 c7             	mov    %rax,%rdi
  8033f0:	48 b8 0f 0f 80 00 00 	movabs $0x800f0f,%rax
  8033f7:	00 00 00 
  8033fa:	ff d0                	callq  *%rax
  8033fc:	48 98                	cltq   
  8033fe:	48 83 c0 01          	add    $0x1,%rax
  803402:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803406:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80340a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80340d:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803410:	0f 8c 6a ff ff ff    	jl     803380 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803416:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803419:	48 98                	cltq   
  80341b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803422:	00 
  803423:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803427:	48 01 d0             	add    %rdx,%rax
  80342a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803431:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803438:	00 
  803439:	74 35                	je     803470 <init_stack+0x1ec>
  80343b:	48 b9 08 4a 80 00 00 	movabs $0x804a08,%rcx
  803442:	00 00 00 
  803445:	48 ba 2e 4a 80 00 00 	movabs $0x804a2e,%rdx
  80344c:	00 00 00 
  80344f:	be f1 00 00 00       	mov    $0xf1,%esi
  803454:	48 bf c8 49 80 00 00 	movabs $0x8049c8,%rdi
  80345b:	00 00 00 
  80345e:	b8 00 00 00 00       	mov    $0x0,%eax
  803463:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  80346a:	00 00 00 
  80346d:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803470:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803474:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803478:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80347d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803481:	48 01 c8             	add    %rcx,%rax
  803484:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80348a:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  80348d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803491:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803495:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803498:	48 98                	cltq   
  80349a:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80349d:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8034a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034a6:	48 01 d0             	add    %rdx,%rax
  8034a9:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8034af:	48 89 c2             	mov    %rax,%rdx
  8034b2:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8034b6:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8034b9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8034bc:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8034c2:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8034c7:	89 c2                	mov    %eax,%edx
  8034c9:	be 00 00 40 00       	mov    $0x400000,%esi
  8034ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d3:	48 b8 fa 18 80 00 00 	movabs $0x8018fa,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
  8034df:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034e6:	79 02                	jns    8034ea <init_stack+0x266>
		goto error;
  8034e8:	eb 28                	jmp    803512 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8034ea:	be 00 00 40 00       	mov    $0x400000,%esi
  8034ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8034f4:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  8034fb:	00 00 00 
  8034fe:	ff d0                	callq  *%rax
  803500:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803503:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803507:	79 02                	jns    80350b <init_stack+0x287>
		goto error;
  803509:	eb 07                	jmp    803512 <init_stack+0x28e>

	return 0;
  80350b:	b8 00 00 00 00       	mov    $0x0,%eax
  803510:	eb 19                	jmp    80352b <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803512:	be 00 00 40 00       	mov    $0x400000,%esi
  803517:	bf 00 00 00 00       	mov    $0x0,%edi
  80351c:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803523:	00 00 00 
  803526:	ff d0                	callq  *%rax
	return r;
  803528:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80352b:	c9                   	leaveq 
  80352c:	c3                   	retq   

000000000080352d <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  80352d:	55                   	push   %rbp
  80352e:	48 89 e5             	mov    %rsp,%rbp
  803531:	48 83 ec 50          	sub    $0x50,%rsp
  803535:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803538:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80353c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803540:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803543:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803547:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80354b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80354f:	25 ff 0f 00 00       	and    $0xfff,%eax
  803554:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803557:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80355b:	74 21                	je     80357e <map_segment+0x51>
		va -= i;
  80355d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803560:	48 98                	cltq   
  803562:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803566:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803569:	48 98                	cltq   
  80356b:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80356f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803572:	48 98                	cltq   
  803574:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803578:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357b:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80357e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803585:	e9 79 01 00 00       	jmpq   803703 <map_segment+0x1d6>
		if (i >= filesz) {
  80358a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80358d:	48 98                	cltq   
  80358f:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803593:	72 3c                	jb     8035d1 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803595:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803598:	48 63 d0             	movslq %eax,%rdx
  80359b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80359f:	48 01 d0             	add    %rdx,%rax
  8035a2:	48 89 c1             	mov    %rax,%rcx
  8035a5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035a8:	8b 55 10             	mov    0x10(%rbp),%edx
  8035ab:	48 89 ce             	mov    %rcx,%rsi
  8035ae:	89 c7                	mov    %eax,%edi
  8035b0:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8035b7:	00 00 00 
  8035ba:	ff d0                	callq  *%rax
  8035bc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035bf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035c3:	0f 89 33 01 00 00    	jns    8036fc <map_segment+0x1cf>
				return r;
  8035c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035cc:	e9 46 01 00 00       	jmpq   803717 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8035d1:	ba 07 00 00 00       	mov    $0x7,%edx
  8035d6:	be 00 00 40 00       	mov    $0x400000,%esi
  8035db:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e0:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8035e7:	00 00 00 
  8035ea:	ff d0                	callq  *%rax
  8035ec:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035ef:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035f3:	79 08                	jns    8035fd <map_segment+0xd0>
				return r;
  8035f5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035f8:	e9 1a 01 00 00       	jmpq   803717 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8035fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803600:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803603:	01 c2                	add    %eax,%edx
  803605:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803608:	89 d6                	mov    %edx,%esi
  80360a:	89 c7                	mov    %eax,%edi
  80360c:	48 b8 fb 23 80 00 00 	movabs $0x8023fb,%rax
  803613:	00 00 00 
  803616:	ff d0                	callq  *%rax
  803618:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80361b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80361f:	79 08                	jns    803629 <map_segment+0xfc>
				return r;
  803621:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803624:	e9 ee 00 00 00       	jmpq   803717 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803629:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803630:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803633:	48 98                	cltq   
  803635:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803639:	48 29 c2             	sub    %rax,%rdx
  80363c:	48 89 d0             	mov    %rdx,%rax
  80363f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803643:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803646:	48 63 d0             	movslq %eax,%rdx
  803649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80364d:	48 39 c2             	cmp    %rax,%rdx
  803650:	48 0f 47 d0          	cmova  %rax,%rdx
  803654:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803657:	be 00 00 40 00       	mov    $0x400000,%esi
  80365c:	89 c7                	mov    %eax,%edi
  80365e:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  803665:	00 00 00 
  803668:	ff d0                	callq  *%rax
  80366a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80366d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803671:	79 08                	jns    80367b <map_segment+0x14e>
				return r;
  803673:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803676:	e9 9c 00 00 00       	jmpq   803717 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80367b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367e:	48 63 d0             	movslq %eax,%rdx
  803681:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803685:	48 01 d0             	add    %rdx,%rax
  803688:	48 89 c2             	mov    %rax,%rdx
  80368b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80368e:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803692:	48 89 d1             	mov    %rdx,%rcx
  803695:	89 c2                	mov    %eax,%edx
  803697:	be 00 00 40 00       	mov    $0x400000,%esi
  80369c:	bf 00 00 00 00       	mov    $0x0,%edi
  8036a1:	48 b8 fa 18 80 00 00 	movabs $0x8018fa,%rax
  8036a8:	00 00 00 
  8036ab:	ff d0                	callq  *%rax
  8036ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8036b0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036b4:	79 30                	jns    8036e6 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8036b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036b9:	89 c1                	mov    %eax,%ecx
  8036bb:	48 ba 43 4a 80 00 00 	movabs $0x804a43,%rdx
  8036c2:	00 00 00 
  8036c5:	be 24 01 00 00       	mov    $0x124,%esi
  8036ca:	48 bf c8 49 80 00 00 	movabs $0x8049c8,%rdi
  8036d1:	00 00 00 
  8036d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d9:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  8036e0:	00 00 00 
  8036e3:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8036e6:	be 00 00 40 00       	mov    $0x400000,%esi
  8036eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8036f0:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  8036f7:	00 00 00 
  8036fa:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8036fc:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803703:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803706:	48 98                	cltq   
  803708:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80370c:	0f 82 78 fe ff ff    	jb     80358a <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803712:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803717:	c9                   	leaveq 
  803718:	c3                   	retq   

0000000000803719 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803719:	55                   	push   %rbp
  80371a:	48 89 e5             	mov    %rsp,%rbp
  80371d:	48 83 ec 20          	sub    $0x20,%rsp
  803721:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803724:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  80372b:	00 
  80372c:	e9 c9 00 00 00       	jmpq   8037fa <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  803731:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803735:	48 c1 e8 27          	shr    $0x27,%rax
  803739:	48 89 c2             	mov    %rax,%rdx
  80373c:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803743:	01 00 00 
  803746:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80374a:	48 85 c0             	test   %rax,%rax
  80374d:	74 3c                	je     80378b <copy_shared_pages+0x72>
  80374f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803753:	48 c1 e8 1e          	shr    $0x1e,%rax
  803757:	48 89 c2             	mov    %rax,%rdx
  80375a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803761:	01 00 00 
  803764:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803768:	48 85 c0             	test   %rax,%rax
  80376b:	74 1e                	je     80378b <copy_shared_pages+0x72>
  80376d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803771:	48 c1 e8 15          	shr    $0x15,%rax
  803775:	48 89 c2             	mov    %rax,%rdx
  803778:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80377f:	01 00 00 
  803782:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803786:	48 85 c0             	test   %rax,%rax
  803789:	75 02                	jne    80378d <copy_shared_pages+0x74>
                continue;
  80378b:	eb 65                	jmp    8037f2 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  80378d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803791:	48 c1 e8 0c          	shr    $0xc,%rax
  803795:	48 89 c2             	mov    %rax,%rdx
  803798:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80379f:	01 00 00 
  8037a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037a6:	25 00 04 00 00       	and    $0x400,%eax
  8037ab:	48 85 c0             	test   %rax,%rax
  8037ae:	74 42                	je     8037f2 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  8037b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8037b8:	48 89 c2             	mov    %rax,%rdx
  8037bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037c2:	01 00 00 
  8037c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037c9:	25 07 0e 00 00       	and    $0xe07,%eax
  8037ce:	89 c6                	mov    %eax,%esi
  8037d0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8037d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037db:	41 89 f0             	mov    %esi,%r8d
  8037de:	48 89 c6             	mov    %rax,%rsi
  8037e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e6:	48 b8 fa 18 80 00 00 	movabs $0x8018fa,%rax
  8037ed:	00 00 00 
  8037f0:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  8037f2:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8037f9:	00 
  8037fa:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  803801:	00 00 00 
  803804:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803808:	0f 86 23 ff ff ff    	jbe    803731 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  80380e:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  803813:	c9                   	leaveq 
  803814:	c3                   	retq   

0000000000803815 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803815:	55                   	push   %rbp
  803816:	48 89 e5             	mov    %rsp,%rbp
  803819:	53                   	push   %rbx
  80381a:	48 83 ec 38          	sub    $0x38,%rsp
  80381e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803822:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803826:	48 89 c7             	mov    %rax,%rdi
  803829:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  803830:	00 00 00 
  803833:	ff d0                	callq  *%rax
  803835:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803838:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80383c:	0f 88 bf 01 00 00    	js     803a01 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803846:	ba 07 04 00 00       	mov    $0x407,%edx
  80384b:	48 89 c6             	mov    %rax,%rsi
  80384e:	bf 00 00 00 00       	mov    $0x0,%edi
  803853:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  80385a:	00 00 00 
  80385d:	ff d0                	callq  *%rax
  80385f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803862:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803866:	0f 88 95 01 00 00    	js     803a01 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80386c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803870:	48 89 c7             	mov    %rax,%rdi
  803873:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  80387a:	00 00 00 
  80387d:	ff d0                	callq  *%rax
  80387f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803882:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803886:	0f 88 5d 01 00 00    	js     8039e9 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80388c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803890:	ba 07 04 00 00       	mov    $0x407,%edx
  803895:	48 89 c6             	mov    %rax,%rsi
  803898:	bf 00 00 00 00       	mov    $0x0,%edi
  80389d:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
  8038a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038b0:	0f 88 33 01 00 00    	js     8039e9 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8038b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ba:	48 89 c7             	mov    %rax,%rdi
  8038bd:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8038c4:	00 00 00 
  8038c7:	ff d0                	callq  *%rax
  8038c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038d1:	ba 07 04 00 00       	mov    $0x407,%edx
  8038d6:	48 89 c6             	mov    %rax,%rsi
  8038d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8038de:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8038e5:	00 00 00 
  8038e8:	ff d0                	callq  *%rax
  8038ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038f1:	79 05                	jns    8038f8 <pipe+0xe3>
		goto err2;
  8038f3:	e9 d9 00 00 00       	jmpq   8039d1 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038fc:	48 89 c7             	mov    %rax,%rdi
  8038ff:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803906:	00 00 00 
  803909:	ff d0                	callq  *%rax
  80390b:	48 89 c2             	mov    %rax,%rdx
  80390e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803912:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803918:	48 89 d1             	mov    %rdx,%rcx
  80391b:	ba 00 00 00 00       	mov    $0x0,%edx
  803920:	48 89 c6             	mov    %rax,%rsi
  803923:	bf 00 00 00 00       	mov    $0x0,%edi
  803928:	48 b8 fa 18 80 00 00 	movabs $0x8018fa,%rax
  80392f:	00 00 00 
  803932:	ff d0                	callq  *%rax
  803934:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803937:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80393b:	79 1b                	jns    803958 <pipe+0x143>
		goto err3;
  80393d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80393e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803942:	48 89 c6             	mov    %rax,%rsi
  803945:	bf 00 00 00 00       	mov    $0x0,%edi
  80394a:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803951:	00 00 00 
  803954:	ff d0                	callq  *%rax
  803956:	eb 79                	jmp    8039d1 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803958:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80395c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803963:	00 00 00 
  803966:	8b 12                	mov    (%rdx),%edx
  803968:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80396a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80396e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803975:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803979:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803980:	00 00 00 
  803983:	8b 12                	mov    (%rdx),%edx
  803985:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803987:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80398b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803992:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803996:	48 89 c7             	mov    %rax,%rdi
  803999:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  8039a0:	00 00 00 
  8039a3:	ff d0                	callq  *%rax
  8039a5:	89 c2                	mov    %eax,%edx
  8039a7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039ab:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8039ad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039b1:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8039b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039b9:	48 89 c7             	mov    %rax,%rdi
  8039bc:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  8039c3:	00 00 00 
  8039c6:	ff d0                	callq  *%rax
  8039c8:	89 03                	mov    %eax,(%rbx)
	return 0;
  8039ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8039cf:	eb 33                	jmp    803a04 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8039d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039d5:	48 89 c6             	mov    %rax,%rsi
  8039d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8039dd:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  8039e4:	00 00 00 
  8039e7:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8039e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ed:	48 89 c6             	mov    %rax,%rsi
  8039f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8039f5:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  8039fc:	00 00 00 
  8039ff:	ff d0                	callq  *%rax
err:
	return r;
  803a01:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a04:	48 83 c4 38          	add    $0x38,%rsp
  803a08:	5b                   	pop    %rbx
  803a09:	5d                   	pop    %rbp
  803a0a:	c3                   	retq   

0000000000803a0b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a0b:	55                   	push   %rbp
  803a0c:	48 89 e5             	mov    %rsp,%rbp
  803a0f:	53                   	push   %rbx
  803a10:	48 83 ec 28          	sub    $0x28,%rsp
  803a14:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a18:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a1c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a23:	00 00 00 
  803a26:	48 8b 00             	mov    (%rax),%rax
  803a29:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a2f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a36:	48 89 c7             	mov    %rax,%rdi
  803a39:	48 b8 89 42 80 00 00 	movabs $0x804289,%rax
  803a40:	00 00 00 
  803a43:	ff d0                	callq  *%rax
  803a45:	89 c3                	mov    %eax,%ebx
  803a47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a4b:	48 89 c7             	mov    %rax,%rdi
  803a4e:	48 b8 89 42 80 00 00 	movabs $0x804289,%rax
  803a55:	00 00 00 
  803a58:	ff d0                	callq  *%rax
  803a5a:	39 c3                	cmp    %eax,%ebx
  803a5c:	0f 94 c0             	sete   %al
  803a5f:	0f b6 c0             	movzbl %al,%eax
  803a62:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803a65:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a6c:	00 00 00 
  803a6f:	48 8b 00             	mov    (%rax),%rax
  803a72:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a78:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803a7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a7e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a81:	75 05                	jne    803a88 <_pipeisclosed+0x7d>
			return ret;
  803a83:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a86:	eb 4f                	jmp    803ad7 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803a88:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a8b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a8e:	74 42                	je     803ad2 <_pipeisclosed+0xc7>
  803a90:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803a94:	75 3c                	jne    803ad2 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803a96:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a9d:	00 00 00 
  803aa0:	48 8b 00             	mov    (%rax),%rax
  803aa3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803aa9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803aac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aaf:	89 c6                	mov    %eax,%esi
  803ab1:	48 bf 6a 4a 80 00 00 	movabs $0x804a6a,%rdi
  803ab8:	00 00 00 
  803abb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac0:	49 b8 c6 03 80 00 00 	movabs $0x8003c6,%r8
  803ac7:	00 00 00 
  803aca:	41 ff d0             	callq  *%r8
	}
  803acd:	e9 4a ff ff ff       	jmpq   803a1c <_pipeisclosed+0x11>
  803ad2:	e9 45 ff ff ff       	jmpq   803a1c <_pipeisclosed+0x11>
}
  803ad7:	48 83 c4 28          	add    $0x28,%rsp
  803adb:	5b                   	pop    %rbx
  803adc:	5d                   	pop    %rbp
  803add:	c3                   	retq   

0000000000803ade <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ade:	55                   	push   %rbp
  803adf:	48 89 e5             	mov    %rsp,%rbp
  803ae2:	48 83 ec 30          	sub    $0x30,%rsp
  803ae6:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ae9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803aed:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803af0:	48 89 d6             	mov    %rdx,%rsi
  803af3:	89 c7                	mov    %eax,%edi
  803af5:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  803afc:	00 00 00 
  803aff:	ff d0                	callq  *%rax
  803b01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b08:	79 05                	jns    803b0f <pipeisclosed+0x31>
		return r;
  803b0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0d:	eb 31                	jmp    803b40 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803b0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b13:	48 89 c7             	mov    %rax,%rdi
  803b16:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803b1d:	00 00 00 
  803b20:	ff d0                	callq  *%rax
  803b22:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803b26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b2e:	48 89 d6             	mov    %rdx,%rsi
  803b31:	48 89 c7             	mov    %rax,%rdi
  803b34:	48 b8 0b 3a 80 00 00 	movabs $0x803a0b,%rax
  803b3b:	00 00 00 
  803b3e:	ff d0                	callq  *%rax
}
  803b40:	c9                   	leaveq 
  803b41:	c3                   	retq   

0000000000803b42 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b42:	55                   	push   %rbp
  803b43:	48 89 e5             	mov    %rsp,%rbp
  803b46:	48 83 ec 40          	sub    $0x40,%rsp
  803b4a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b4e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b52:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803b56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b5a:	48 89 c7             	mov    %rax,%rdi
  803b5d:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803b64:	00 00 00 
  803b67:	ff d0                	callq  *%rax
  803b69:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b75:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b7c:	00 
  803b7d:	e9 92 00 00 00       	jmpq   803c14 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803b82:	eb 41                	jmp    803bc5 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803b84:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803b89:	74 09                	je     803b94 <devpipe_read+0x52>
				return i;
  803b8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b8f:	e9 92 00 00 00       	jmpq   803c26 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803b94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b9c:	48 89 d6             	mov    %rdx,%rsi
  803b9f:	48 89 c7             	mov    %rax,%rdi
  803ba2:	48 b8 0b 3a 80 00 00 	movabs $0x803a0b,%rax
  803ba9:	00 00 00 
  803bac:	ff d0                	callq  *%rax
  803bae:	85 c0                	test   %eax,%eax
  803bb0:	74 07                	je     803bb9 <devpipe_read+0x77>
				return 0;
  803bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb7:	eb 6d                	jmp    803c26 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803bb9:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803bc0:	00 00 00 
  803bc3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803bc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc9:	8b 10                	mov    (%rax),%edx
  803bcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bcf:	8b 40 04             	mov    0x4(%rax),%eax
  803bd2:	39 c2                	cmp    %eax,%edx
  803bd4:	74 ae                	je     803b84 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803bd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bde:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803be2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be6:	8b 00                	mov    (%rax),%eax
  803be8:	99                   	cltd   
  803be9:	c1 ea 1b             	shr    $0x1b,%edx
  803bec:	01 d0                	add    %edx,%eax
  803bee:	83 e0 1f             	and    $0x1f,%eax
  803bf1:	29 d0                	sub    %edx,%eax
  803bf3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bf7:	48 98                	cltq   
  803bf9:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803bfe:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803c00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c04:	8b 00                	mov    (%rax),%eax
  803c06:	8d 50 01             	lea    0x1(%rax),%edx
  803c09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c0d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c0f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c18:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c1c:	0f 82 60 ff ff ff    	jb     803b82 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803c22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c26:	c9                   	leaveq 
  803c27:	c3                   	retq   

0000000000803c28 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c28:	55                   	push   %rbp
  803c29:	48 89 e5             	mov    %rsp,%rbp
  803c2c:	48 83 ec 40          	sub    $0x40,%rsp
  803c30:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c34:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c38:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c40:	48 89 c7             	mov    %rax,%rdi
  803c43:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803c4a:	00 00 00 
  803c4d:	ff d0                	callq  *%rax
  803c4f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c5b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c62:	00 
  803c63:	e9 8e 00 00 00       	jmpq   803cf6 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c68:	eb 31                	jmp    803c9b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803c6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c72:	48 89 d6             	mov    %rdx,%rsi
  803c75:	48 89 c7             	mov    %rax,%rdi
  803c78:	48 b8 0b 3a 80 00 00 	movabs $0x803a0b,%rax
  803c7f:	00 00 00 
  803c82:	ff d0                	callq  *%rax
  803c84:	85 c0                	test   %eax,%eax
  803c86:	74 07                	je     803c8f <devpipe_write+0x67>
				return 0;
  803c88:	b8 00 00 00 00       	mov    $0x0,%eax
  803c8d:	eb 79                	jmp    803d08 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803c8f:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803c96:	00 00 00 
  803c99:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c9f:	8b 40 04             	mov    0x4(%rax),%eax
  803ca2:	48 63 d0             	movslq %eax,%rdx
  803ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca9:	8b 00                	mov    (%rax),%eax
  803cab:	48 98                	cltq   
  803cad:	48 83 c0 20          	add    $0x20,%rax
  803cb1:	48 39 c2             	cmp    %rax,%rdx
  803cb4:	73 b4                	jae    803c6a <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803cb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cba:	8b 40 04             	mov    0x4(%rax),%eax
  803cbd:	99                   	cltd   
  803cbe:	c1 ea 1b             	shr    $0x1b,%edx
  803cc1:	01 d0                	add    %edx,%eax
  803cc3:	83 e0 1f             	and    $0x1f,%eax
  803cc6:	29 d0                	sub    %edx,%eax
  803cc8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ccc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803cd0:	48 01 ca             	add    %rcx,%rdx
  803cd3:	0f b6 0a             	movzbl (%rdx),%ecx
  803cd6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cda:	48 98                	cltq   
  803cdc:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ce0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce4:	8b 40 04             	mov    0x4(%rax),%eax
  803ce7:	8d 50 01             	lea    0x1(%rax),%edx
  803cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cee:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803cf1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803cf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cfa:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803cfe:	0f 82 64 ff ff ff    	jb     803c68 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d08:	c9                   	leaveq 
  803d09:	c3                   	retq   

0000000000803d0a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803d0a:	55                   	push   %rbp
  803d0b:	48 89 e5             	mov    %rsp,%rbp
  803d0e:	48 83 ec 20          	sub    $0x20,%rsp
  803d12:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d16:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803d1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d1e:	48 89 c7             	mov    %rax,%rdi
  803d21:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803d28:	00 00 00 
  803d2b:	ff d0                	callq  *%rax
  803d2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d35:	48 be 7d 4a 80 00 00 	movabs $0x804a7d,%rsi
  803d3c:	00 00 00 
  803d3f:	48 89 c7             	mov    %rax,%rdi
  803d42:	48 b8 7b 0f 80 00 00 	movabs $0x800f7b,%rax
  803d49:	00 00 00 
  803d4c:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803d4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d52:	8b 50 04             	mov    0x4(%rax),%edx
  803d55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d59:	8b 00                	mov    (%rax),%eax
  803d5b:	29 c2                	sub    %eax,%edx
  803d5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d61:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803d67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d6b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803d72:	00 00 00 
	stat->st_dev = &devpipe;
  803d75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d79:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803d80:	00 00 00 
  803d83:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803d8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d8f:	c9                   	leaveq 
  803d90:	c3                   	retq   

0000000000803d91 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d91:	55                   	push   %rbp
  803d92:	48 89 e5             	mov    %rsp,%rbp
  803d95:	48 83 ec 10          	sub    $0x10,%rsp
  803d99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803d9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da1:	48 89 c6             	mov    %rax,%rsi
  803da4:	bf 00 00 00 00       	mov    $0x0,%edi
  803da9:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803db0:	00 00 00 
  803db3:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803db9:	48 89 c7             	mov    %rax,%rdi
  803dbc:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803dc3:	00 00 00 
  803dc6:	ff d0                	callq  *%rax
  803dc8:	48 89 c6             	mov    %rax,%rsi
  803dcb:	bf 00 00 00 00       	mov    $0x0,%edi
  803dd0:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803dd7:	00 00 00 
  803dda:	ff d0                	callq  *%rax
}
  803ddc:	c9                   	leaveq 
  803ddd:	c3                   	retq   

0000000000803dde <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803dde:	55                   	push   %rbp
  803ddf:	48 89 e5             	mov    %rsp,%rbp
  803de2:	48 83 ec 20          	sub    $0x20,%rsp
  803de6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803de9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dec:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803def:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803df3:	be 01 00 00 00       	mov    $0x1,%esi
  803df8:	48 89 c7             	mov    %rax,%rdi
  803dfb:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  803e02:	00 00 00 
  803e05:	ff d0                	callq  *%rax
}
  803e07:	c9                   	leaveq 
  803e08:	c3                   	retq   

0000000000803e09 <getchar>:

int
getchar(void)
{
  803e09:	55                   	push   %rbp
  803e0a:	48 89 e5             	mov    %rsp,%rbp
  803e0d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e11:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803e15:	ba 01 00 00 00       	mov    $0x1,%edx
  803e1a:	48 89 c6             	mov    %rax,%rsi
  803e1d:	bf 00 00 00 00       	mov    $0x0,%edi
  803e22:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803e29:	00 00 00 
  803e2c:	ff d0                	callq  *%rax
  803e2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e35:	79 05                	jns    803e3c <getchar+0x33>
		return r;
  803e37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3a:	eb 14                	jmp    803e50 <getchar+0x47>
	if (r < 1)
  803e3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e40:	7f 07                	jg     803e49 <getchar+0x40>
		return -E_EOF;
  803e42:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e47:	eb 07                	jmp    803e50 <getchar+0x47>
	return c;
  803e49:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e4d:	0f b6 c0             	movzbl %al,%eax
}
  803e50:	c9                   	leaveq 
  803e51:	c3                   	retq   

0000000000803e52 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e52:	55                   	push   %rbp
  803e53:	48 89 e5             	mov    %rsp,%rbp
  803e56:	48 83 ec 20          	sub    $0x20,%rsp
  803e5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e5d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e64:	48 89 d6             	mov    %rdx,%rsi
  803e67:	89 c7                	mov    %eax,%edi
  803e69:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  803e70:	00 00 00 
  803e73:	ff d0                	callq  *%rax
  803e75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e7c:	79 05                	jns    803e83 <iscons+0x31>
		return r;
  803e7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e81:	eb 1a                	jmp    803e9d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e87:	8b 10                	mov    (%rax),%edx
  803e89:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803e90:	00 00 00 
  803e93:	8b 00                	mov    (%rax),%eax
  803e95:	39 c2                	cmp    %eax,%edx
  803e97:	0f 94 c0             	sete   %al
  803e9a:	0f b6 c0             	movzbl %al,%eax
}
  803e9d:	c9                   	leaveq 
  803e9e:	c3                   	retq   

0000000000803e9f <opencons>:

int
opencons(void)
{
  803e9f:	55                   	push   %rbp
  803ea0:	48 89 e5             	mov    %rsp,%rbp
  803ea3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ea7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803eab:	48 89 c7             	mov    %rax,%rdi
  803eae:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  803eb5:	00 00 00 
  803eb8:	ff d0                	callq  *%rax
  803eba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ebd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ec1:	79 05                	jns    803ec8 <opencons+0x29>
		return r;
  803ec3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec6:	eb 5b                	jmp    803f23 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ec8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ecc:	ba 07 04 00 00       	mov    $0x407,%edx
  803ed1:	48 89 c6             	mov    %rax,%rsi
  803ed4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ed9:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803ee0:	00 00 00 
  803ee3:	ff d0                	callq  *%rax
  803ee5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ee8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eec:	79 05                	jns    803ef3 <opencons+0x54>
		return r;
  803eee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef1:	eb 30                	jmp    803f23 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803ef3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ef7:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803efe:	00 00 00 
  803f01:	8b 12                	mov    (%rdx),%edx
  803f03:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803f05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f09:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f14:	48 89 c7             	mov    %rax,%rdi
  803f17:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  803f1e:	00 00 00 
  803f21:	ff d0                	callq  *%rax
}
  803f23:	c9                   	leaveq 
  803f24:	c3                   	retq   

0000000000803f25 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f25:	55                   	push   %rbp
  803f26:	48 89 e5             	mov    %rsp,%rbp
  803f29:	48 83 ec 30          	sub    $0x30,%rsp
  803f2d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f35:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f39:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f3e:	75 07                	jne    803f47 <devcons_read+0x22>
		return 0;
  803f40:	b8 00 00 00 00       	mov    $0x0,%eax
  803f45:	eb 4b                	jmp    803f92 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803f47:	eb 0c                	jmp    803f55 <devcons_read+0x30>
		sys_yield();
  803f49:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803f50:	00 00 00 
  803f53:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803f55:	48 b8 ac 17 80 00 00 	movabs $0x8017ac,%rax
  803f5c:	00 00 00 
  803f5f:	ff d0                	callq  *%rax
  803f61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f68:	74 df                	je     803f49 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803f6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f6e:	79 05                	jns    803f75 <devcons_read+0x50>
		return c;
  803f70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f73:	eb 1d                	jmp    803f92 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803f75:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803f79:	75 07                	jne    803f82 <devcons_read+0x5d>
		return 0;
  803f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  803f80:	eb 10                	jmp    803f92 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803f82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f85:	89 c2                	mov    %eax,%edx
  803f87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f8b:	88 10                	mov    %dl,(%rax)
	return 1;
  803f8d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f92:	c9                   	leaveq 
  803f93:	c3                   	retq   

0000000000803f94 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f94:	55                   	push   %rbp
  803f95:	48 89 e5             	mov    %rsp,%rbp
  803f98:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803f9f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803fa6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803fad:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803fb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fbb:	eb 76                	jmp    804033 <devcons_write+0x9f>
		m = n - tot;
  803fbd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803fc4:	89 c2                	mov    %eax,%edx
  803fc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc9:	29 c2                	sub    %eax,%edx
  803fcb:	89 d0                	mov    %edx,%eax
  803fcd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803fd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fd3:	83 f8 7f             	cmp    $0x7f,%eax
  803fd6:	76 07                	jbe    803fdf <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803fd8:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803fdf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fe2:	48 63 d0             	movslq %eax,%rdx
  803fe5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe8:	48 63 c8             	movslq %eax,%rcx
  803feb:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803ff2:	48 01 c1             	add    %rax,%rcx
  803ff5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ffc:	48 89 ce             	mov    %rcx,%rsi
  803fff:	48 89 c7             	mov    %rax,%rdi
  804002:	48 b8 9f 12 80 00 00 	movabs $0x80129f,%rax
  804009:	00 00 00 
  80400c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80400e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804011:	48 63 d0             	movslq %eax,%rdx
  804014:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80401b:	48 89 d6             	mov    %rdx,%rsi
  80401e:	48 89 c7             	mov    %rax,%rdi
  804021:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  804028:	00 00 00 
  80402b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80402d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804030:	01 45 fc             	add    %eax,-0x4(%rbp)
  804033:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804036:	48 98                	cltq   
  804038:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80403f:	0f 82 78 ff ff ff    	jb     803fbd <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804045:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804048:	c9                   	leaveq 
  804049:	c3                   	retq   

000000000080404a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80404a:	55                   	push   %rbp
  80404b:	48 89 e5             	mov    %rsp,%rbp
  80404e:	48 83 ec 08          	sub    $0x8,%rsp
  804052:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804056:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80405b:	c9                   	leaveq 
  80405c:	c3                   	retq   

000000000080405d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80405d:	55                   	push   %rbp
  80405e:	48 89 e5             	mov    %rsp,%rbp
  804061:	48 83 ec 10          	sub    $0x10,%rsp
  804065:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804069:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80406d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804071:	48 be 89 4a 80 00 00 	movabs $0x804a89,%rsi
  804078:	00 00 00 
  80407b:	48 89 c7             	mov    %rax,%rdi
  80407e:	48 b8 7b 0f 80 00 00 	movabs $0x800f7b,%rax
  804085:	00 00 00 
  804088:	ff d0                	callq  *%rax
	return 0;
  80408a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80408f:	c9                   	leaveq 
  804090:	c3                   	retq   

0000000000804091 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804091:	55                   	push   %rbp
  804092:	48 89 e5             	mov    %rsp,%rbp
  804095:	48 83 ec 30          	sub    $0x30,%rsp
  804099:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80409d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8040a5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8040ac:	00 00 00 
  8040af:	48 8b 00             	mov    (%rax),%rax
  8040b2:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8040b8:	85 c0                	test   %eax,%eax
  8040ba:	75 34                	jne    8040f0 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8040bc:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  8040c3:	00 00 00 
  8040c6:	ff d0                	callq  *%rax
  8040c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8040cd:	48 98                	cltq   
  8040cf:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8040d6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8040dd:	00 00 00 
  8040e0:	48 01 c2             	add    %rax,%rdx
  8040e3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8040ea:	00 00 00 
  8040ed:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8040f0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8040f5:	75 0e                	jne    804105 <ipc_recv+0x74>
		pg = (void*) UTOP;
  8040f7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8040fe:	00 00 00 
  804101:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804105:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804109:	48 89 c7             	mov    %rax,%rdi
  80410c:	48 b8 d3 1a 80 00 00 	movabs $0x801ad3,%rax
  804113:	00 00 00 
  804116:	ff d0                	callq  *%rax
  804118:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80411b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80411f:	79 19                	jns    80413a <ipc_recv+0xa9>
		*from_env_store = 0;
  804121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804125:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80412b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80412f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804138:	eb 53                	jmp    80418d <ipc_recv+0xfc>
	}
	if(from_env_store)
  80413a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80413f:	74 19                	je     80415a <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  804141:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804148:	00 00 00 
  80414b:	48 8b 00             	mov    (%rax),%rax
  80414e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804158:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80415a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80415f:	74 19                	je     80417a <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  804161:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804168:	00 00 00 
  80416b:	48 8b 00             	mov    (%rax),%rax
  80416e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804174:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804178:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80417a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804181:	00 00 00 
  804184:	48 8b 00             	mov    (%rax),%rax
  804187:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80418d:	c9                   	leaveq 
  80418e:	c3                   	retq   

000000000080418f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80418f:	55                   	push   %rbp
  804190:	48 89 e5             	mov    %rsp,%rbp
  804193:	48 83 ec 30          	sub    $0x30,%rsp
  804197:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80419a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80419d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8041a1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8041a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8041a9:	75 0e                	jne    8041b9 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8041ab:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8041b2:	00 00 00 
  8041b5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8041b9:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8041bc:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8041bf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041c6:	89 c7                	mov    %eax,%edi
  8041c8:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  8041cf:	00 00 00 
  8041d2:	ff d0                	callq  *%rax
  8041d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8041d7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8041db:	75 0c                	jne    8041e9 <ipc_send+0x5a>
			sys_yield();
  8041dd:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  8041e4:	00 00 00 
  8041e7:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8041e9:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8041ed:	74 ca                	je     8041b9 <ipc_send+0x2a>
	if(result != 0)
  8041ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041f3:	74 20                	je     804215 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  8041f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041f8:	89 c6                	mov    %eax,%esi
  8041fa:	48 bf 90 4a 80 00 00 	movabs $0x804a90,%rdi
  804201:	00 00 00 
  804204:	b8 00 00 00 00       	mov    $0x0,%eax
  804209:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  804210:	00 00 00 
  804213:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  804215:	c9                   	leaveq 
  804216:	c3                   	retq   

0000000000804217 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804217:	55                   	push   %rbp
  804218:	48 89 e5             	mov    %rsp,%rbp
  80421b:	48 83 ec 14          	sub    $0x14,%rsp
  80421f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804222:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804229:	eb 4e                	jmp    804279 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80422b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804232:	00 00 00 
  804235:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804238:	48 98                	cltq   
  80423a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804241:	48 01 d0             	add    %rdx,%rax
  804244:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80424a:	8b 00                	mov    (%rax),%eax
  80424c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80424f:	75 24                	jne    804275 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804251:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804258:	00 00 00 
  80425b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80425e:	48 98                	cltq   
  804260:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804267:	48 01 d0             	add    %rdx,%rax
  80426a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804270:	8b 40 08             	mov    0x8(%rax),%eax
  804273:	eb 12                	jmp    804287 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804275:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804279:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804280:	7e a9                	jle    80422b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804282:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804287:	c9                   	leaveq 
  804288:	c3                   	retq   

0000000000804289 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804289:	55                   	push   %rbp
  80428a:	48 89 e5             	mov    %rsp,%rbp
  80428d:	48 83 ec 18          	sub    $0x18,%rsp
  804291:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804295:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804299:	48 c1 e8 15          	shr    $0x15,%rax
  80429d:	48 89 c2             	mov    %rax,%rdx
  8042a0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8042a7:	01 00 00 
  8042aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042ae:	83 e0 01             	and    $0x1,%eax
  8042b1:	48 85 c0             	test   %rax,%rax
  8042b4:	75 07                	jne    8042bd <pageref+0x34>
		return 0;
  8042b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8042bb:	eb 53                	jmp    804310 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8042bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042c1:	48 c1 e8 0c          	shr    $0xc,%rax
  8042c5:	48 89 c2             	mov    %rax,%rdx
  8042c8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8042cf:	01 00 00 
  8042d2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8042da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042de:	83 e0 01             	and    $0x1,%eax
  8042e1:	48 85 c0             	test   %rax,%rax
  8042e4:	75 07                	jne    8042ed <pageref+0x64>
		return 0;
  8042e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8042eb:	eb 23                	jmp    804310 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8042ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042f1:	48 c1 e8 0c          	shr    $0xc,%rax
  8042f5:	48 89 c2             	mov    %rax,%rdx
  8042f8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8042ff:	00 00 00 
  804302:	48 c1 e2 04          	shl    $0x4,%rdx
  804306:	48 01 d0             	add    %rdx,%rax
  804309:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80430d:	0f b7 c0             	movzwl %ax,%eax
}
  804310:	c9                   	leaveq 
  804311:	c3                   	retq   
