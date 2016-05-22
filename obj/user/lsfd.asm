
obj/user/lsfd:     file format elf64-x86-64


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
  80003c:	e8 7c 01 00 00       	callq  8001bd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: lsfd [-1]\n");
  800047:	48 bf a0 3e 80 00 00 	movabs $0x803ea0,%rdi
  80004e:	00 00 00 
  800051:	b8 00 00 00 00       	mov    $0x0,%eax
  800056:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  80005d:	00 00 00 
  800060:	ff d2                	callq  *%rdx
	exit();
  800062:	48 b8 40 02 80 00 00 	movabs $0x800240,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
}
  80006e:	5d                   	pop    %rbp
  80006f:	c3                   	retq   

0000000000800070 <umain>:

void
umain(int argc, char **argv)
{
  800070:	55                   	push   %rbp
  800071:	48 89 e5             	mov    %rsp,%rbp
  800074:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80007b:	89 bd 3c ff ff ff    	mov    %edi,-0xc4(%rbp)
  800081:	48 89 b5 30 ff ff ff 	mov    %rsi,-0xd0(%rbp)
	int i, usefprint = 0;
  800088:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  80008f:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800096:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
  80009d:	48 8d 85 3c ff ff ff 	lea    -0xc4(%rbp),%rax
  8000a4:	48 89 ce             	mov    %rcx,%rsi
  8000a7:	48 89 c7             	mov    %rax,%rdi
  8000aa:	48 b8 ba 1c 80 00 00 	movabs $0x801cba,%rax
  8000b1:	00 00 00 
  8000b4:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000b6:	eb 1b                	jmp    8000d3 <umain+0x63>
		if (i == '1')
  8000b8:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  8000bc:	75 09                	jne    8000c7 <umain+0x57>
			usefprint = 1;
  8000be:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  8000c5:	eb 0c                	jmp    8000d3 <umain+0x63>
		else
			usage();
  8000c7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ce:	00 00 00 
  8000d1:	ff d0                	callq  *%rax
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8000d3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f0:	79 c6                	jns    8000b8 <umain+0x48>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8000f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000f9:	e9 b3 00 00 00       	jmpq   8001b1 <umain+0x141>
		if (fstat(i, &st) >= 0) {
  8000fe:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800108:	48 89 d6             	mov    %rdx,%rsi
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 b3 27 80 00 00 	movabs $0x8027b3,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
  800119:	85 c0                	test   %eax,%eax
  80011b:	0f 88 8c 00 00 00    	js     8001ad <umain+0x13d>
			if (usefprint)
  800121:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800125:	74 4a                	je     800171 <umain+0x101>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80012f:	8b 7d e0             	mov    -0x20(%rbp),%edi
  800132:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800135:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80013c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80013f:	48 89 0c 24          	mov    %rcx,(%rsp)
  800143:	41 89 f9             	mov    %edi,%r9d
  800146:	41 89 f0             	mov    %esi,%r8d
  800149:	48 89 d1             	mov    %rdx,%rcx
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	48 be b8 3e 80 00 00 	movabs $0x803eb8,%rsi
  800155:	00 00 00 
  800158:	bf 01 00 00 00       	mov    $0x1,%edi
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	49 ba 06 31 80 00 00 	movabs $0x803106,%r10
  800169:	00 00 00 
  80016c:	41 ff d2             	callq  *%r10
  80016f:	eb 3c                	jmp    8001ad <umain+0x13d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800175:	48 8b 78 08          	mov    0x8(%rax),%rdi
  800179:	8b 75 e0             	mov    -0x20(%rbp),%esi
  80017c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80017f:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800189:	49 89 f9             	mov    %rdi,%r9
  80018c:	41 89 f0             	mov    %esi,%r8d
  80018f:	89 c6                	mov    %eax,%esi
  800191:	48 bf b8 3e 80 00 00 	movabs $0x803eb8,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	49 ba 88 03 80 00 00 	movabs $0x800388,%r10
  8001a7:	00 00 00 
  8001aa:	41 ff d2             	callq  *%r10
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8001ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8001b5:	0f 8e 43 ff ff ff    	jle    8000fe <umain+0x8e>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  8001bb:	c9                   	leaveq 
  8001bc:	c3                   	retq   

00000000008001bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001bd:	55                   	push   %rbp
  8001be:	48 89 e5             	mov    %rsp,%rbp
  8001c1:	48 83 ec 10          	sub    $0x10,%rsp
  8001c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001cc:	48 b8 f0 17 80 00 00 	movabs $0x8017f0,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax
  8001d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001dd:	48 98                	cltq   
  8001df:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001e6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001ed:	00 00 00 
  8001f0:	48 01 c2             	add    %rax,%rdx
  8001f3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001fa:	00 00 00 
  8001fd:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800200:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800204:	7e 14                	jle    80021a <libmain+0x5d>
		binaryname = argv[0];
  800206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800214:	00 00 00 
  800217:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80021a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800221:	48 89 d6             	mov    %rdx,%rsi
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 70 00 80 00 00 	movabs $0x800070,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800232:	48 b8 40 02 80 00 00 	movabs $0x800240,%rax
  800239:	00 00 00 
  80023c:	ff d0                	callq  *%rax
}
  80023e:	c9                   	leaveq 
  80023f:	c3                   	retq   

0000000000800240 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800240:	55                   	push   %rbp
  800241:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800244:	48 b8 e0 22 80 00 00 	movabs $0x8022e0,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800250:	bf 00 00 00 00       	mov    $0x0,%edi
  800255:	48 b8 ac 17 80 00 00 	movabs $0x8017ac,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax

}
  800261:	5d                   	pop    %rbp
  800262:	c3                   	retq   

0000000000800263 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800263:	55                   	push   %rbp
  800264:	48 89 e5             	mov    %rsp,%rbp
  800267:	48 83 ec 10          	sub    $0x10,%rsp
  80026b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80026e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800276:	8b 00                	mov    (%rax),%eax
  800278:	8d 48 01             	lea    0x1(%rax),%ecx
  80027b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80027f:	89 0a                	mov    %ecx,(%rdx)
  800281:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800284:	89 d1                	mov    %edx,%ecx
  800286:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80028a:	48 98                	cltq   
  80028c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800290:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800294:	8b 00                	mov    (%rax),%eax
  800296:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029b:	75 2c                	jne    8002c9 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80029d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a1:	8b 00                	mov    (%rax),%eax
  8002a3:	48 98                	cltq   
  8002a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002a9:	48 83 c2 08          	add    $0x8,%rdx
  8002ad:	48 89 c6             	mov    %rax,%rsi
  8002b0:	48 89 d7             	mov    %rdx,%rdi
  8002b3:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
        b->idx = 0;
  8002bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002c3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8002c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002cd:	8b 40 04             	mov    0x4(%rax),%eax
  8002d0:	8d 50 01             	lea    0x1(%rax),%edx
  8002d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d7:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002da:	c9                   	leaveq 
  8002db:	c3                   	retq   

00000000008002dc <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8002dc:	55                   	push   %rbp
  8002dd:	48 89 e5             	mov    %rsp,%rbp
  8002e0:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8002e7:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002ee:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002f5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002fc:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800303:	48 8b 0a             	mov    (%rdx),%rcx
  800306:	48 89 08             	mov    %rcx,(%rax)
  800309:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80030d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800311:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800315:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800319:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800320:	00 00 00 
    b.cnt = 0;
  800323:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80032a:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80032d:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800334:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80033b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800342:	48 89 c6             	mov    %rax,%rsi
  800345:	48 bf 63 02 80 00 00 	movabs $0x800263,%rdi
  80034c:	00 00 00 
  80034f:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  800356:	00 00 00 
  800359:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80035b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800361:	48 98                	cltq   
  800363:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80036a:	48 83 c2 08          	add    $0x8,%rdx
  80036e:	48 89 c6             	mov    %rax,%rsi
  800371:	48 89 d7             	mov    %rdx,%rdi
  800374:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  80037b:	00 00 00 
  80037e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800380:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800386:	c9                   	leaveq 
  800387:	c3                   	retq   

0000000000800388 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800388:	55                   	push   %rbp
  800389:	48 89 e5             	mov    %rsp,%rbp
  80038c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800393:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80039a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003a1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003a8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003af:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003b6:	84 c0                	test   %al,%al
  8003b8:	74 20                	je     8003da <cprintf+0x52>
  8003ba:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003be:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003c2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003c6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003ca:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003ce:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003d2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003d6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8003da:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8003e1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8003e8:	00 00 00 
  8003eb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003f2:	00 00 00 
  8003f5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003f9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800400:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800407:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80040e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800415:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80041c:	48 8b 0a             	mov    (%rdx),%rcx
  80041f:	48 89 08             	mov    %rcx,(%rax)
  800422:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800426:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80042a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80042e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800432:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800439:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800440:	48 89 d6             	mov    %rdx,%rsi
  800443:	48 89 c7             	mov    %rax,%rdi
  800446:	48 b8 dc 02 80 00 00 	movabs $0x8002dc,%rax
  80044d:	00 00 00 
  800450:	ff d0                	callq  *%rax
  800452:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800458:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80045e:	c9                   	leaveq 
  80045f:	c3                   	retq   

0000000000800460 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800460:	55                   	push   %rbp
  800461:	48 89 e5             	mov    %rsp,%rbp
  800464:	53                   	push   %rbx
  800465:	48 83 ec 38          	sub    $0x38,%rsp
  800469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80046d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800471:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800475:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800478:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80047c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800480:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800483:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800487:	77 3b                	ja     8004c4 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800489:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80048c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800490:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800493:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800497:	ba 00 00 00 00       	mov    $0x0,%edx
  80049c:	48 f7 f3             	div    %rbx
  80049f:	48 89 c2             	mov    %rax,%rdx
  8004a2:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004a5:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004a8:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b0:	41 89 f9             	mov    %edi,%r9d
  8004b3:	48 89 c7             	mov    %rax,%rdi
  8004b6:	48 b8 60 04 80 00 00 	movabs $0x800460,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
  8004c2:	eb 1e                	jmp    8004e2 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004c4:	eb 12                	jmp    8004d8 <printnum+0x78>
			putch(padc, putdat);
  8004c6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004ca:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8004cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d1:	48 89 ce             	mov    %rcx,%rsi
  8004d4:	89 d7                	mov    %edx,%edi
  8004d6:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004d8:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8004dc:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8004e0:	7f e4                	jg     8004c6 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004e2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ee:	48 f7 f1             	div    %rcx
  8004f1:	48 89 d0             	mov    %rdx,%rax
  8004f4:	48 ba f0 40 80 00 00 	movabs $0x8040f0,%rdx
  8004fb:	00 00 00 
  8004fe:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800502:	0f be d0             	movsbl %al,%edx
  800505:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050d:	48 89 ce             	mov    %rcx,%rsi
  800510:	89 d7                	mov    %edx,%edi
  800512:	ff d0                	callq  *%rax
}
  800514:	48 83 c4 38          	add    $0x38,%rsp
  800518:	5b                   	pop    %rbx
  800519:	5d                   	pop    %rbp
  80051a:	c3                   	retq   

000000000080051b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 83 ec 1c          	sub    $0x1c,%rsp
  800523:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800527:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80052a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80052e:	7e 52                	jle    800582 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800534:	8b 00                	mov    (%rax),%eax
  800536:	83 f8 30             	cmp    $0x30,%eax
  800539:	73 24                	jae    80055f <getuint+0x44>
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
  80055d:	eb 17                	jmp    800576 <getuint+0x5b>
  80055f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800563:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800567:	48 89 d0             	mov    %rdx,%rax
  80056a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80056e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800572:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800576:	48 8b 00             	mov    (%rax),%rax
  800579:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80057d:	e9 a3 00 00 00       	jmpq   800625 <getuint+0x10a>
	else if (lflag)
  800582:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800586:	74 4f                	je     8005d7 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058c:	8b 00                	mov    (%rax),%eax
  80058e:	83 f8 30             	cmp    $0x30,%eax
  800591:	73 24                	jae    8005b7 <getuint+0x9c>
  800593:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800597:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059f:	8b 00                	mov    (%rax),%eax
  8005a1:	89 c0                	mov    %eax,%eax
  8005a3:	48 01 d0             	add    %rdx,%rax
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	8b 12                	mov    (%rdx),%edx
  8005ac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b3:	89 0a                	mov    %ecx,(%rdx)
  8005b5:	eb 17                	jmp    8005ce <getuint+0xb3>
  8005b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005bf:	48 89 d0             	mov    %rdx,%rax
  8005c2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ce:	48 8b 00             	mov    (%rax),%rax
  8005d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005d5:	eb 4e                	jmp    800625 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8005d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005db:	8b 00                	mov    (%rax),%eax
  8005dd:	83 f8 30             	cmp    $0x30,%eax
  8005e0:	73 24                	jae    800606 <getuint+0xeb>
  8005e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	89 c0                	mov    %eax,%eax
  8005f2:	48 01 d0             	add    %rdx,%rax
  8005f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f9:	8b 12                	mov    (%rdx),%edx
  8005fb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800602:	89 0a                	mov    %ecx,(%rdx)
  800604:	eb 17                	jmp    80061d <getuint+0x102>
  800606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060e:	48 89 d0             	mov    %rdx,%rax
  800611:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800615:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800619:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061d:	8b 00                	mov    (%rax),%eax
  80061f:	89 c0                	mov    %eax,%eax
  800621:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800625:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800629:	c9                   	leaveq 
  80062a:	c3                   	retq   

000000000080062b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80062b:	55                   	push   %rbp
  80062c:	48 89 e5             	mov    %rsp,%rbp
  80062f:	48 83 ec 1c          	sub    $0x1c,%rsp
  800633:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800637:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80063a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80063e:	7e 52                	jle    800692 <getint+0x67>
		x=va_arg(*ap, long long);
  800640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800644:	8b 00                	mov    (%rax),%eax
  800646:	83 f8 30             	cmp    $0x30,%eax
  800649:	73 24                	jae    80066f <getint+0x44>
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
  80066d:	eb 17                	jmp    800686 <getint+0x5b>
  80066f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800673:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800677:	48 89 d0             	mov    %rdx,%rax
  80067a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800682:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80068d:	e9 a3 00 00 00       	jmpq   800735 <getint+0x10a>
	else if (lflag)
  800692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800696:	74 4f                	je     8006e7 <getint+0xbc>
		x=va_arg(*ap, long);
  800698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069c:	8b 00                	mov    (%rax),%eax
  80069e:	83 f8 30             	cmp    $0x30,%eax
  8006a1:	73 24                	jae    8006c7 <getint+0x9c>
  8006a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006af:	8b 00                	mov    (%rax),%eax
  8006b1:	89 c0                	mov    %eax,%eax
  8006b3:	48 01 d0             	add    %rdx,%rax
  8006b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ba:	8b 12                	mov    (%rdx),%edx
  8006bc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c3:	89 0a                	mov    %ecx,(%rdx)
  8006c5:	eb 17                	jmp    8006de <getint+0xb3>
  8006c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006cf:	48 89 d0             	mov    %rdx,%rax
  8006d2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006de:	48 8b 00             	mov    (%rax),%rax
  8006e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006e5:	eb 4e                	jmp    800735 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	8b 00                	mov    (%rax),%eax
  8006ed:	83 f8 30             	cmp    $0x30,%eax
  8006f0:	73 24                	jae    800716 <getint+0xeb>
  8006f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fe:	8b 00                	mov    (%rax),%eax
  800700:	89 c0                	mov    %eax,%eax
  800702:	48 01 d0             	add    %rdx,%rax
  800705:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800709:	8b 12                	mov    (%rdx),%edx
  80070b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800712:	89 0a                	mov    %ecx,(%rdx)
  800714:	eb 17                	jmp    80072d <getint+0x102>
  800716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80071e:	48 89 d0             	mov    %rdx,%rax
  800721:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800725:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800729:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80072d:	8b 00                	mov    (%rax),%eax
  80072f:	48 98                	cltq   
  800731:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800739:	c9                   	leaveq 
  80073a:	c3                   	retq   

000000000080073b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80073b:	55                   	push   %rbp
  80073c:	48 89 e5             	mov    %rsp,%rbp
  80073f:	41 54                	push   %r12
  800741:	53                   	push   %rbx
  800742:	48 83 ec 60          	sub    $0x60,%rsp
  800746:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80074a:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80074e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800752:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800756:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80075a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80075e:	48 8b 0a             	mov    (%rdx),%rcx
  800761:	48 89 08             	mov    %rcx,(%rax)
  800764:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800768:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80076c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800770:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800774:	eb 17                	jmp    80078d <vprintfmt+0x52>
			if (ch == '\0')
  800776:	85 db                	test   %ebx,%ebx
  800778:	0f 84 cc 04 00 00    	je     800c4a <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80077e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800782:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800786:	48 89 d6             	mov    %rdx,%rsi
  800789:	89 df                	mov    %ebx,%edi
  80078b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80078d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800791:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800795:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800799:	0f b6 00             	movzbl (%rax),%eax
  80079c:	0f b6 d8             	movzbl %al,%ebx
  80079f:	83 fb 25             	cmp    $0x25,%ebx
  8007a2:	75 d2                	jne    800776 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007a4:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007a8:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007af:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007bd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007c4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007c8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007cc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007d0:	0f b6 00             	movzbl (%rax),%eax
  8007d3:	0f b6 d8             	movzbl %al,%ebx
  8007d6:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8007d9:	83 f8 55             	cmp    $0x55,%eax
  8007dc:	0f 87 34 04 00 00    	ja     800c16 <vprintfmt+0x4db>
  8007e2:	89 c0                	mov    %eax,%eax
  8007e4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007eb:	00 
  8007ec:	48 b8 18 41 80 00 00 	movabs $0x804118,%rax
  8007f3:	00 00 00 
  8007f6:	48 01 d0             	add    %rdx,%rax
  8007f9:	48 8b 00             	mov    (%rax),%rax
  8007fc:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8007fe:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800802:	eb c0                	jmp    8007c4 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800804:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800808:	eb ba                	jmp    8007c4 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800811:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800814:	89 d0                	mov    %edx,%eax
  800816:	c1 e0 02             	shl    $0x2,%eax
  800819:	01 d0                	add    %edx,%eax
  80081b:	01 c0                	add    %eax,%eax
  80081d:	01 d8                	add    %ebx,%eax
  80081f:	83 e8 30             	sub    $0x30,%eax
  800822:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800825:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800829:	0f b6 00             	movzbl (%rax),%eax
  80082c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80082f:	83 fb 2f             	cmp    $0x2f,%ebx
  800832:	7e 0c                	jle    800840 <vprintfmt+0x105>
  800834:	83 fb 39             	cmp    $0x39,%ebx
  800837:	7f 07                	jg     800840 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800839:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80083e:	eb d1                	jmp    800811 <vprintfmt+0xd6>
			goto process_precision;
  800840:	eb 58                	jmp    80089a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800842:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800845:	83 f8 30             	cmp    $0x30,%eax
  800848:	73 17                	jae    800861 <vprintfmt+0x126>
  80084a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80084e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800851:	89 c0                	mov    %eax,%eax
  800853:	48 01 d0             	add    %rdx,%rax
  800856:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800859:	83 c2 08             	add    $0x8,%edx
  80085c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80085f:	eb 0f                	jmp    800870 <vprintfmt+0x135>
  800861:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800865:	48 89 d0             	mov    %rdx,%rax
  800868:	48 83 c2 08          	add    $0x8,%rdx
  80086c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800870:	8b 00                	mov    (%rax),%eax
  800872:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800875:	eb 23                	jmp    80089a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800877:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80087b:	79 0c                	jns    800889 <vprintfmt+0x14e>
				width = 0;
  80087d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800884:	e9 3b ff ff ff       	jmpq   8007c4 <vprintfmt+0x89>
  800889:	e9 36 ff ff ff       	jmpq   8007c4 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80088e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800895:	e9 2a ff ff ff       	jmpq   8007c4 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80089a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80089e:	79 12                	jns    8008b2 <vprintfmt+0x177>
				width = precision, precision = -1;
  8008a0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008a3:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008ad:	e9 12 ff ff ff       	jmpq   8007c4 <vprintfmt+0x89>
  8008b2:	e9 0d ff ff ff       	jmpq   8007c4 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b7:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008bb:	e9 04 ff ff ff       	jmpq   8007c4 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c3:	83 f8 30             	cmp    $0x30,%eax
  8008c6:	73 17                	jae    8008df <vprintfmt+0x1a4>
  8008c8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cf:	89 c0                	mov    %eax,%eax
  8008d1:	48 01 d0             	add    %rdx,%rax
  8008d4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008d7:	83 c2 08             	add    $0x8,%edx
  8008da:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008dd:	eb 0f                	jmp    8008ee <vprintfmt+0x1b3>
  8008df:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008e3:	48 89 d0             	mov    %rdx,%rax
  8008e6:	48 83 c2 08          	add    $0x8,%rdx
  8008ea:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ee:	8b 10                	mov    (%rax),%edx
  8008f0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008f4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f8:	48 89 ce             	mov    %rcx,%rsi
  8008fb:	89 d7                	mov    %edx,%edi
  8008fd:	ff d0                	callq  *%rax
			break;
  8008ff:	e9 40 03 00 00       	jmpq   800c44 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800904:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800907:	83 f8 30             	cmp    $0x30,%eax
  80090a:	73 17                	jae    800923 <vprintfmt+0x1e8>
  80090c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800910:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800913:	89 c0                	mov    %eax,%eax
  800915:	48 01 d0             	add    %rdx,%rax
  800918:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80091b:	83 c2 08             	add    $0x8,%edx
  80091e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800921:	eb 0f                	jmp    800932 <vprintfmt+0x1f7>
  800923:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800927:	48 89 d0             	mov    %rdx,%rax
  80092a:	48 83 c2 08          	add    $0x8,%rdx
  80092e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800932:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800934:	85 db                	test   %ebx,%ebx
  800936:	79 02                	jns    80093a <vprintfmt+0x1ff>
				err = -err;
  800938:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80093a:	83 fb 15             	cmp    $0x15,%ebx
  80093d:	7f 16                	jg     800955 <vprintfmt+0x21a>
  80093f:	48 b8 40 40 80 00 00 	movabs $0x804040,%rax
  800946:	00 00 00 
  800949:	48 63 d3             	movslq %ebx,%rdx
  80094c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800950:	4d 85 e4             	test   %r12,%r12
  800953:	75 2e                	jne    800983 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800955:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800959:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80095d:	89 d9                	mov    %ebx,%ecx
  80095f:	48 ba 01 41 80 00 00 	movabs $0x804101,%rdx
  800966:	00 00 00 
  800969:	48 89 c7             	mov    %rax,%rdi
  80096c:	b8 00 00 00 00       	mov    $0x0,%eax
  800971:	49 b8 53 0c 80 00 00 	movabs $0x800c53,%r8
  800978:	00 00 00 
  80097b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80097e:	e9 c1 02 00 00       	jmpq   800c44 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800983:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800987:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098b:	4c 89 e1             	mov    %r12,%rcx
  80098e:	48 ba 0a 41 80 00 00 	movabs $0x80410a,%rdx
  800995:	00 00 00 
  800998:	48 89 c7             	mov    %rax,%rdi
  80099b:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a0:	49 b8 53 0c 80 00 00 	movabs $0x800c53,%r8
  8009a7:	00 00 00 
  8009aa:	41 ff d0             	callq  *%r8
			break;
  8009ad:	e9 92 02 00 00       	jmpq   800c44 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b5:	83 f8 30             	cmp    $0x30,%eax
  8009b8:	73 17                	jae    8009d1 <vprintfmt+0x296>
  8009ba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c1:	89 c0                	mov    %eax,%eax
  8009c3:	48 01 d0             	add    %rdx,%rax
  8009c6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009c9:	83 c2 08             	add    $0x8,%edx
  8009cc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009cf:	eb 0f                	jmp    8009e0 <vprintfmt+0x2a5>
  8009d1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009d5:	48 89 d0             	mov    %rdx,%rax
  8009d8:	48 83 c2 08          	add    $0x8,%rdx
  8009dc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e0:	4c 8b 20             	mov    (%rax),%r12
  8009e3:	4d 85 e4             	test   %r12,%r12
  8009e6:	75 0a                	jne    8009f2 <vprintfmt+0x2b7>
				p = "(null)";
  8009e8:	49 bc 0d 41 80 00 00 	movabs $0x80410d,%r12
  8009ef:	00 00 00 
			if (width > 0 && padc != '-')
  8009f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009f6:	7e 3f                	jle    800a37 <vprintfmt+0x2fc>
  8009f8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009fc:	74 39                	je     800a37 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009fe:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a01:	48 98                	cltq   
  800a03:	48 89 c6             	mov    %rax,%rsi
  800a06:	4c 89 e7             	mov    %r12,%rdi
  800a09:	48 b8 ff 0e 80 00 00 	movabs $0x800eff,%rax
  800a10:	00 00 00 
  800a13:	ff d0                	callq  *%rax
  800a15:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a18:	eb 17                	jmp    800a31 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a1a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a1e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a26:	48 89 ce             	mov    %rcx,%rsi
  800a29:	89 d7                	mov    %edx,%edi
  800a2b:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a2d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a31:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a35:	7f e3                	jg     800a1a <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a37:	eb 37                	jmp    800a70 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a39:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a3d:	74 1e                	je     800a5d <vprintfmt+0x322>
  800a3f:	83 fb 1f             	cmp    $0x1f,%ebx
  800a42:	7e 05                	jle    800a49 <vprintfmt+0x30e>
  800a44:	83 fb 7e             	cmp    $0x7e,%ebx
  800a47:	7e 14                	jle    800a5d <vprintfmt+0x322>
					putch('?', putdat);
  800a49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a51:	48 89 d6             	mov    %rdx,%rsi
  800a54:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a59:	ff d0                	callq  *%rax
  800a5b:	eb 0f                	jmp    800a6c <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a65:	48 89 d6             	mov    %rdx,%rsi
  800a68:	89 df                	mov    %ebx,%edi
  800a6a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a70:	4c 89 e0             	mov    %r12,%rax
  800a73:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a77:	0f b6 00             	movzbl (%rax),%eax
  800a7a:	0f be d8             	movsbl %al,%ebx
  800a7d:	85 db                	test   %ebx,%ebx
  800a7f:	74 10                	je     800a91 <vprintfmt+0x356>
  800a81:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a85:	78 b2                	js     800a39 <vprintfmt+0x2fe>
  800a87:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a8b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a8f:	79 a8                	jns    800a39 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a91:	eb 16                	jmp    800aa9 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a93:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9b:	48 89 d6             	mov    %rdx,%rsi
  800a9e:	bf 20 00 00 00       	mov    $0x20,%edi
  800aa3:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800aa9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aad:	7f e4                	jg     800a93 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800aaf:	e9 90 01 00 00       	jmpq   800c44 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ab4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ab8:	be 03 00 00 00       	mov    $0x3,%esi
  800abd:	48 89 c7             	mov    %rax,%rdi
  800ac0:	48 b8 2b 06 80 00 00 	movabs $0x80062b,%rax
  800ac7:	00 00 00 
  800aca:	ff d0                	callq  *%rax
  800acc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ad0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad4:	48 85 c0             	test   %rax,%rax
  800ad7:	79 1d                	jns    800af6 <vprintfmt+0x3bb>
				putch('-', putdat);
  800ad9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800add:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae1:	48 89 d6             	mov    %rdx,%rsi
  800ae4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ae9:	ff d0                	callq  *%rax
				num = -(long long) num;
  800aeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aef:	48 f7 d8             	neg    %rax
  800af2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800af6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800afd:	e9 d5 00 00 00       	jmpq   800bd7 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b02:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b06:	be 03 00 00 00       	mov    $0x3,%esi
  800b0b:	48 89 c7             	mov    %rax,%rdi
  800b0e:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  800b15:	00 00 00 
  800b18:	ff d0                	callq  *%rax
  800b1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b1e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b25:	e9 ad 00 00 00       	jmpq   800bd7 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800b2a:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800b2d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b31:	89 d6                	mov    %edx,%esi
  800b33:	48 89 c7             	mov    %rax,%rdi
  800b36:	48 b8 2b 06 80 00 00 	movabs $0x80062b,%rax
  800b3d:	00 00 00 
  800b40:	ff d0                	callq  *%rax
  800b42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b46:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b4d:	e9 85 00 00 00       	jmpq   800bd7 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800b52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5a:	48 89 d6             	mov    %rdx,%rsi
  800b5d:	bf 30 00 00 00       	mov    $0x30,%edi
  800b62:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b64:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6c:	48 89 d6             	mov    %rdx,%rsi
  800b6f:	bf 78 00 00 00       	mov    $0x78,%edi
  800b74:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b76:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b79:	83 f8 30             	cmp    $0x30,%eax
  800b7c:	73 17                	jae    800b95 <vprintfmt+0x45a>
  800b7e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b85:	89 c0                	mov    %eax,%eax
  800b87:	48 01 d0             	add    %rdx,%rax
  800b8a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b8d:	83 c2 08             	add    $0x8,%edx
  800b90:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b93:	eb 0f                	jmp    800ba4 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b95:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b99:	48 89 d0             	mov    %rdx,%rax
  800b9c:	48 83 c2 08          	add    $0x8,%rdx
  800ba0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba4:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ba7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bab:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bb2:	eb 23                	jmp    800bd7 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bb4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bb8:	be 03 00 00 00       	mov    $0x3,%esi
  800bbd:	48 89 c7             	mov    %rax,%rdi
  800bc0:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  800bc7:	00 00 00 
  800bca:	ff d0                	callq  *%rax
  800bcc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800bd0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bd7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800bdc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800bdf:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800be2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800be6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bee:	45 89 c1             	mov    %r8d,%r9d
  800bf1:	41 89 f8             	mov    %edi,%r8d
  800bf4:	48 89 c7             	mov    %rax,%rdi
  800bf7:	48 b8 60 04 80 00 00 	movabs $0x800460,%rax
  800bfe:	00 00 00 
  800c01:	ff d0                	callq  *%rax
			break;
  800c03:	eb 3f                	jmp    800c44 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0d:	48 89 d6             	mov    %rdx,%rsi
  800c10:	89 df                	mov    %ebx,%edi
  800c12:	ff d0                	callq  *%rax
			break;
  800c14:	eb 2e                	jmp    800c44 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1e:	48 89 d6             	mov    %rdx,%rsi
  800c21:	bf 25 00 00 00       	mov    $0x25,%edi
  800c26:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c28:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c2d:	eb 05                	jmp    800c34 <vprintfmt+0x4f9>
  800c2f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c34:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c38:	48 83 e8 01          	sub    $0x1,%rax
  800c3c:	0f b6 00             	movzbl (%rax),%eax
  800c3f:	3c 25                	cmp    $0x25,%al
  800c41:	75 ec                	jne    800c2f <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c43:	90                   	nop
		}
	}
  800c44:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c45:	e9 43 fb ff ff       	jmpq   80078d <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c4a:	48 83 c4 60          	add    $0x60,%rsp
  800c4e:	5b                   	pop    %rbx
  800c4f:	41 5c                	pop    %r12
  800c51:	5d                   	pop    %rbp
  800c52:	c3                   	retq   

0000000000800c53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c53:	55                   	push   %rbp
  800c54:	48 89 e5             	mov    %rsp,%rbp
  800c57:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c5e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c65:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c6c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c73:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c7a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c81:	84 c0                	test   %al,%al
  800c83:	74 20                	je     800ca5 <printfmt+0x52>
  800c85:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c89:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c8d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c91:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c95:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c99:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c9d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ca1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ca5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cac:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cb3:	00 00 00 
  800cb6:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cbd:	00 00 00 
  800cc0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cc4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ccb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800cd2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800cd9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ce0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ce7:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800cee:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800cf5:	48 89 c7             	mov    %rax,%rdi
  800cf8:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  800cff:	00 00 00 
  800d02:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d04:	c9                   	leaveq 
  800d05:	c3                   	retq   

0000000000800d06 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d06:	55                   	push   %rbp
  800d07:	48 89 e5             	mov    %rsp,%rbp
  800d0a:	48 83 ec 10          	sub    $0x10,%rsp
  800d0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d19:	8b 40 10             	mov    0x10(%rax),%eax
  800d1c:	8d 50 01             	lea    0x1(%rax),%edx
  800d1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d23:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d2a:	48 8b 10             	mov    (%rax),%rdx
  800d2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d31:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d35:	48 39 c2             	cmp    %rax,%rdx
  800d38:	73 17                	jae    800d51 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d3e:	48 8b 00             	mov    (%rax),%rax
  800d41:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d49:	48 89 0a             	mov    %rcx,(%rdx)
  800d4c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d4f:	88 10                	mov    %dl,(%rax)
}
  800d51:	c9                   	leaveq 
  800d52:	c3                   	retq   

0000000000800d53 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d53:	55                   	push   %rbp
  800d54:	48 89 e5             	mov    %rsp,%rbp
  800d57:	48 83 ec 50          	sub    $0x50,%rsp
  800d5b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d5f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d62:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d66:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d6a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d6e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d72:	48 8b 0a             	mov    (%rdx),%rcx
  800d75:	48 89 08             	mov    %rcx,(%rax)
  800d78:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d7c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d80:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d84:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d88:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d8c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d90:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d93:	48 98                	cltq   
  800d95:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d99:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d9d:	48 01 d0             	add    %rdx,%rax
  800da0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800da4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800dab:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800db0:	74 06                	je     800db8 <vsnprintf+0x65>
  800db2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800db6:	7f 07                	jg     800dbf <vsnprintf+0x6c>
		return -E_INVAL;
  800db8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dbd:	eb 2f                	jmp    800dee <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800dbf:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800dc3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800dc7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800dcb:	48 89 c6             	mov    %rax,%rsi
  800dce:	48 bf 06 0d 80 00 00 	movabs $0x800d06,%rdi
  800dd5:	00 00 00 
  800dd8:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  800ddf:	00 00 00 
  800de2:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800de4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800de8:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800deb:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800dee:	c9                   	leaveq 
  800def:	c3                   	retq   

0000000000800df0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df0:	55                   	push   %rbp
  800df1:	48 89 e5             	mov    %rsp,%rbp
  800df4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800dfb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e02:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e08:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e0f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e16:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e1d:	84 c0                	test   %al,%al
  800e1f:	74 20                	je     800e41 <snprintf+0x51>
  800e21:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e25:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e29:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e2d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e31:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e35:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e39:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e3d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e41:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e48:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e4f:	00 00 00 
  800e52:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e59:	00 00 00 
  800e5c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e60:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e67:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e6e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e75:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e7c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e83:	48 8b 0a             	mov    (%rdx),%rcx
  800e86:	48 89 08             	mov    %rcx,(%rax)
  800e89:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e8d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e91:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e95:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e99:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ea0:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ea7:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ead:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800eb4:	48 89 c7             	mov    %rax,%rdi
  800eb7:	48 b8 53 0d 80 00 00 	movabs $0x800d53,%rax
  800ebe:	00 00 00 
  800ec1:	ff d0                	callq  *%rax
  800ec3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ec9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ecf:	c9                   	leaveq 
  800ed0:	c3                   	retq   

0000000000800ed1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ed1:	55                   	push   %rbp
  800ed2:	48 89 e5             	mov    %rsp,%rbp
  800ed5:	48 83 ec 18          	sub    $0x18,%rsp
  800ed9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800edd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ee4:	eb 09                	jmp    800eef <strlen+0x1e>
		n++;
  800ee6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800eea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef3:	0f b6 00             	movzbl (%rax),%eax
  800ef6:	84 c0                	test   %al,%al
  800ef8:	75 ec                	jne    800ee6 <strlen+0x15>
		n++;
	return n;
  800efa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800efd:	c9                   	leaveq 
  800efe:	c3                   	retq   

0000000000800eff <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800eff:	55                   	push   %rbp
  800f00:	48 89 e5             	mov    %rsp,%rbp
  800f03:	48 83 ec 20          	sub    $0x20,%rsp
  800f07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f16:	eb 0e                	jmp    800f26 <strnlen+0x27>
		n++;
  800f18:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f21:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f26:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f2b:	74 0b                	je     800f38 <strnlen+0x39>
  800f2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f31:	0f b6 00             	movzbl (%rax),%eax
  800f34:	84 c0                	test   %al,%al
  800f36:	75 e0                	jne    800f18 <strnlen+0x19>
		n++;
	return n;
  800f38:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f3b:	c9                   	leaveq 
  800f3c:	c3                   	retq   

0000000000800f3d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f3d:	55                   	push   %rbp
  800f3e:	48 89 e5             	mov    %rsp,%rbp
  800f41:	48 83 ec 20          	sub    $0x20,%rsp
  800f45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f51:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f55:	90                   	nop
  800f56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f5e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f62:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f66:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f6a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f6e:	0f b6 12             	movzbl (%rdx),%edx
  800f71:	88 10                	mov    %dl,(%rax)
  800f73:	0f b6 00             	movzbl (%rax),%eax
  800f76:	84 c0                	test   %al,%al
  800f78:	75 dc                	jne    800f56 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f7e:	c9                   	leaveq 
  800f7f:	c3                   	retq   

0000000000800f80 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f80:	55                   	push   %rbp
  800f81:	48 89 e5             	mov    %rsp,%rbp
  800f84:	48 83 ec 20          	sub    $0x20,%rsp
  800f88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f94:	48 89 c7             	mov    %rax,%rdi
  800f97:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  800f9e:	00 00 00 
  800fa1:	ff d0                	callq  *%rax
  800fa3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fa9:	48 63 d0             	movslq %eax,%rdx
  800fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb0:	48 01 c2             	add    %rax,%rdx
  800fb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fb7:	48 89 c6             	mov    %rax,%rsi
  800fba:	48 89 d7             	mov    %rdx,%rdi
  800fbd:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	callq  *%rax
	return dst;
  800fc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fcd:	c9                   	leaveq 
  800fce:	c3                   	retq   

0000000000800fcf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fcf:	55                   	push   %rbp
  800fd0:	48 89 e5             	mov    %rsp,%rbp
  800fd3:	48 83 ec 28          	sub    $0x28,%rsp
  800fd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fdb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fdf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800feb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ff2:	00 
  800ff3:	eb 2a                	jmp    80101f <strncpy+0x50>
		*dst++ = *src;
  800ff5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ffd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801001:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801005:	0f b6 12             	movzbl (%rdx),%edx
  801008:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80100a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80100e:	0f b6 00             	movzbl (%rax),%eax
  801011:	84 c0                	test   %al,%al
  801013:	74 05                	je     80101a <strncpy+0x4b>
			src++;
  801015:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80101a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80101f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801023:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801027:	72 cc                	jb     800ff5 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801029:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80102d:	c9                   	leaveq 
  80102e:	c3                   	retq   

000000000080102f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80102f:	55                   	push   %rbp
  801030:	48 89 e5             	mov    %rsp,%rbp
  801033:	48 83 ec 28          	sub    $0x28,%rsp
  801037:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80103f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801043:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801047:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80104b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801050:	74 3d                	je     80108f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801052:	eb 1d                	jmp    801071 <strlcpy+0x42>
			*dst++ = *src++;
  801054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801058:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80105c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801060:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801064:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801068:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80106c:	0f b6 12             	movzbl (%rdx),%edx
  80106f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801071:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801076:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80107b:	74 0b                	je     801088 <strlcpy+0x59>
  80107d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801081:	0f b6 00             	movzbl (%rax),%eax
  801084:	84 c0                	test   %al,%al
  801086:	75 cc                	jne    801054 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80108f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801097:	48 29 c2             	sub    %rax,%rdx
  80109a:	48 89 d0             	mov    %rdx,%rax
}
  80109d:	c9                   	leaveq 
  80109e:	c3                   	retq   

000000000080109f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80109f:	55                   	push   %rbp
  8010a0:	48 89 e5             	mov    %rsp,%rbp
  8010a3:	48 83 ec 10          	sub    $0x10,%rsp
  8010a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010af:	eb 0a                	jmp    8010bb <strcmp+0x1c>
		p++, q++;
  8010b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bf:	0f b6 00             	movzbl (%rax),%eax
  8010c2:	84 c0                	test   %al,%al
  8010c4:	74 12                	je     8010d8 <strcmp+0x39>
  8010c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ca:	0f b6 10             	movzbl (%rax),%edx
  8010cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d1:	0f b6 00             	movzbl (%rax),%eax
  8010d4:	38 c2                	cmp    %al,%dl
  8010d6:	74 d9                	je     8010b1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dc:	0f b6 00             	movzbl (%rax),%eax
  8010df:	0f b6 d0             	movzbl %al,%edx
  8010e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e6:	0f b6 00             	movzbl (%rax),%eax
  8010e9:	0f b6 c0             	movzbl %al,%eax
  8010ec:	29 c2                	sub    %eax,%edx
  8010ee:	89 d0                	mov    %edx,%eax
}
  8010f0:	c9                   	leaveq 
  8010f1:	c3                   	retq   

00000000008010f2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010f2:	55                   	push   %rbp
  8010f3:	48 89 e5             	mov    %rsp,%rbp
  8010f6:	48 83 ec 18          	sub    $0x18,%rsp
  8010fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801102:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801106:	eb 0f                	jmp    801117 <strncmp+0x25>
		n--, p++, q++;
  801108:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80110d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801112:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801117:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80111c:	74 1d                	je     80113b <strncmp+0x49>
  80111e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	84 c0                	test   %al,%al
  801127:	74 12                	je     80113b <strncmp+0x49>
  801129:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112d:	0f b6 10             	movzbl (%rax),%edx
  801130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801134:	0f b6 00             	movzbl (%rax),%eax
  801137:	38 c2                	cmp    %al,%dl
  801139:	74 cd                	je     801108 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80113b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801140:	75 07                	jne    801149 <strncmp+0x57>
		return 0;
  801142:	b8 00 00 00 00       	mov    $0x0,%eax
  801147:	eb 18                	jmp    801161 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801149:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114d:	0f b6 00             	movzbl (%rax),%eax
  801150:	0f b6 d0             	movzbl %al,%edx
  801153:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801157:	0f b6 00             	movzbl (%rax),%eax
  80115a:	0f b6 c0             	movzbl %al,%eax
  80115d:	29 c2                	sub    %eax,%edx
  80115f:	89 d0                	mov    %edx,%eax
}
  801161:	c9                   	leaveq 
  801162:	c3                   	retq   

0000000000801163 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801163:	55                   	push   %rbp
  801164:	48 89 e5             	mov    %rsp,%rbp
  801167:	48 83 ec 0c          	sub    $0xc,%rsp
  80116b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80116f:	89 f0                	mov    %esi,%eax
  801171:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801174:	eb 17                	jmp    80118d <strchr+0x2a>
		if (*s == c)
  801176:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117a:	0f b6 00             	movzbl (%rax),%eax
  80117d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801180:	75 06                	jne    801188 <strchr+0x25>
			return (char *) s;
  801182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801186:	eb 15                	jmp    80119d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801188:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80118d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801191:	0f b6 00             	movzbl (%rax),%eax
  801194:	84 c0                	test   %al,%al
  801196:	75 de                	jne    801176 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801198:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119d:	c9                   	leaveq 
  80119e:	c3                   	retq   

000000000080119f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80119f:	55                   	push   %rbp
  8011a0:	48 89 e5             	mov    %rsp,%rbp
  8011a3:	48 83 ec 0c          	sub    $0xc,%rsp
  8011a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ab:	89 f0                	mov    %esi,%eax
  8011ad:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011b0:	eb 13                	jmp    8011c5 <strfind+0x26>
		if (*s == c)
  8011b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b6:	0f b6 00             	movzbl (%rax),%eax
  8011b9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011bc:	75 02                	jne    8011c0 <strfind+0x21>
			break;
  8011be:	eb 10                	jmp    8011d0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c9:	0f b6 00             	movzbl (%rax),%eax
  8011cc:	84 c0                	test   %al,%al
  8011ce:	75 e2                	jne    8011b2 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8011d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 18          	sub    $0x18,%rsp
  8011de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e2:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011e9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011ee:	75 06                	jne    8011f6 <memset+0x20>
		return v;
  8011f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f4:	eb 69                	jmp    80125f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fa:	83 e0 03             	and    $0x3,%eax
  8011fd:	48 85 c0             	test   %rax,%rax
  801200:	75 48                	jne    80124a <memset+0x74>
  801202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801206:	83 e0 03             	and    $0x3,%eax
  801209:	48 85 c0             	test   %rax,%rax
  80120c:	75 3c                	jne    80124a <memset+0x74>
		c &= 0xFF;
  80120e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801215:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801218:	c1 e0 18             	shl    $0x18,%eax
  80121b:	89 c2                	mov    %eax,%edx
  80121d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801220:	c1 e0 10             	shl    $0x10,%eax
  801223:	09 c2                	or     %eax,%edx
  801225:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801228:	c1 e0 08             	shl    $0x8,%eax
  80122b:	09 d0                	or     %edx,%eax
  80122d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801234:	48 c1 e8 02          	shr    $0x2,%rax
  801238:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80123b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801242:	48 89 d7             	mov    %rdx,%rdi
  801245:	fc                   	cld    
  801246:	f3 ab                	rep stos %eax,%es:(%rdi)
  801248:	eb 11                	jmp    80125b <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80124a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801251:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801255:	48 89 d7             	mov    %rdx,%rdi
  801258:	fc                   	cld    
  801259:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80125f:	c9                   	leaveq 
  801260:	c3                   	retq   

0000000000801261 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801261:	55                   	push   %rbp
  801262:	48 89 e5             	mov    %rsp,%rbp
  801265:	48 83 ec 28          	sub    $0x28,%rsp
  801269:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80126d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801271:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801275:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801279:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80127d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801281:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801289:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80128d:	0f 83 88 00 00 00    	jae    80131b <memmove+0xba>
  801293:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801297:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80129b:	48 01 d0             	add    %rdx,%rax
  80129e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012a2:	76 77                	jbe    80131b <memmove+0xba>
		s += n;
  8012a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a8:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b0:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b8:	83 e0 03             	and    $0x3,%eax
  8012bb:	48 85 c0             	test   %rax,%rax
  8012be:	75 3b                	jne    8012fb <memmove+0x9a>
  8012c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c4:	83 e0 03             	and    $0x3,%eax
  8012c7:	48 85 c0             	test   %rax,%rax
  8012ca:	75 2f                	jne    8012fb <memmove+0x9a>
  8012cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d0:	83 e0 03             	and    $0x3,%eax
  8012d3:	48 85 c0             	test   %rax,%rax
  8012d6:	75 23                	jne    8012fb <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012dc:	48 83 e8 04          	sub    $0x4,%rax
  8012e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e4:	48 83 ea 04          	sub    $0x4,%rdx
  8012e8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012ec:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012f0:	48 89 c7             	mov    %rax,%rdi
  8012f3:	48 89 d6             	mov    %rdx,%rsi
  8012f6:	fd                   	std    
  8012f7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012f9:	eb 1d                	jmp    801318 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ff:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801307:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80130b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80130f:	48 89 d7             	mov    %rdx,%rdi
  801312:	48 89 c1             	mov    %rax,%rcx
  801315:	fd                   	std    
  801316:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801318:	fc                   	cld    
  801319:	eb 57                	jmp    801372 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80131b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131f:	83 e0 03             	and    $0x3,%eax
  801322:	48 85 c0             	test   %rax,%rax
  801325:	75 36                	jne    80135d <memmove+0xfc>
  801327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132b:	83 e0 03             	and    $0x3,%eax
  80132e:	48 85 c0             	test   %rax,%rax
  801331:	75 2a                	jne    80135d <memmove+0xfc>
  801333:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801337:	83 e0 03             	and    $0x3,%eax
  80133a:	48 85 c0             	test   %rax,%rax
  80133d:	75 1e                	jne    80135d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80133f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801343:	48 c1 e8 02          	shr    $0x2,%rax
  801347:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80134a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801352:	48 89 c7             	mov    %rax,%rdi
  801355:	48 89 d6             	mov    %rdx,%rsi
  801358:	fc                   	cld    
  801359:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80135b:	eb 15                	jmp    801372 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80135d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801361:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801365:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801369:	48 89 c7             	mov    %rax,%rdi
  80136c:	48 89 d6             	mov    %rdx,%rsi
  80136f:	fc                   	cld    
  801370:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801376:	c9                   	leaveq 
  801377:	c3                   	retq   

0000000000801378 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801378:	55                   	push   %rbp
  801379:	48 89 e5             	mov    %rsp,%rbp
  80137c:	48 83 ec 18          	sub    $0x18,%rsp
  801380:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801384:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801388:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80138c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801390:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801398:	48 89 ce             	mov    %rcx,%rsi
  80139b:	48 89 c7             	mov    %rax,%rdi
  80139e:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  8013a5:	00 00 00 
  8013a8:	ff d0                	callq  *%rax
}
  8013aa:	c9                   	leaveq 
  8013ab:	c3                   	retq   

00000000008013ac <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013ac:	55                   	push   %rbp
  8013ad:	48 89 e5             	mov    %rsp,%rbp
  8013b0:	48 83 ec 28          	sub    $0x28,%rsp
  8013b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013d0:	eb 36                	jmp    801408 <memcmp+0x5c>
		if (*s1 != *s2)
  8013d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d6:	0f b6 10             	movzbl (%rax),%edx
  8013d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013dd:	0f b6 00             	movzbl (%rax),%eax
  8013e0:	38 c2                	cmp    %al,%dl
  8013e2:	74 1a                	je     8013fe <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8013e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e8:	0f b6 00             	movzbl (%rax),%eax
  8013eb:	0f b6 d0             	movzbl %al,%edx
  8013ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f2:	0f b6 00             	movzbl (%rax),%eax
  8013f5:	0f b6 c0             	movzbl %al,%eax
  8013f8:	29 c2                	sub    %eax,%edx
  8013fa:	89 d0                	mov    %edx,%eax
  8013fc:	eb 20                	jmp    80141e <memcmp+0x72>
		s1++, s2++;
  8013fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801403:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801410:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801414:	48 85 c0             	test   %rax,%rax
  801417:	75 b9                	jne    8013d2 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801419:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141e:	c9                   	leaveq 
  80141f:	c3                   	retq   

0000000000801420 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801420:	55                   	push   %rbp
  801421:	48 89 e5             	mov    %rsp,%rbp
  801424:	48 83 ec 28          	sub    $0x28,%rsp
  801428:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80142f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801437:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80143b:	48 01 d0             	add    %rdx,%rax
  80143e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801442:	eb 15                	jmp    801459 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801448:	0f b6 10             	movzbl (%rax),%edx
  80144b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80144e:	38 c2                	cmp    %al,%dl
  801450:	75 02                	jne    801454 <memfind+0x34>
			break;
  801452:	eb 0f                	jmp    801463 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801454:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801461:	72 e1                	jb     801444 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801463:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801467:	c9                   	leaveq 
  801468:	c3                   	retq   

0000000000801469 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801469:	55                   	push   %rbp
  80146a:	48 89 e5             	mov    %rsp,%rbp
  80146d:	48 83 ec 34          	sub    $0x34,%rsp
  801471:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801475:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801479:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80147c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801483:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80148a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80148b:	eb 05                	jmp    801492 <strtol+0x29>
		s++;
  80148d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801496:	0f b6 00             	movzbl (%rax),%eax
  801499:	3c 20                	cmp    $0x20,%al
  80149b:	74 f0                	je     80148d <strtol+0x24>
  80149d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a1:	0f b6 00             	movzbl (%rax),%eax
  8014a4:	3c 09                	cmp    $0x9,%al
  8014a6:	74 e5                	je     80148d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ac:	0f b6 00             	movzbl (%rax),%eax
  8014af:	3c 2b                	cmp    $0x2b,%al
  8014b1:	75 07                	jne    8014ba <strtol+0x51>
		s++;
  8014b3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014b8:	eb 17                	jmp    8014d1 <strtol+0x68>
	else if (*s == '-')
  8014ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014be:	0f b6 00             	movzbl (%rax),%eax
  8014c1:	3c 2d                	cmp    $0x2d,%al
  8014c3:	75 0c                	jne    8014d1 <strtol+0x68>
		s++, neg = 1;
  8014c5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014d5:	74 06                	je     8014dd <strtol+0x74>
  8014d7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014db:	75 28                	jne    801505 <strtol+0x9c>
  8014dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e1:	0f b6 00             	movzbl (%rax),%eax
  8014e4:	3c 30                	cmp    $0x30,%al
  8014e6:	75 1d                	jne    801505 <strtol+0x9c>
  8014e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ec:	48 83 c0 01          	add    $0x1,%rax
  8014f0:	0f b6 00             	movzbl (%rax),%eax
  8014f3:	3c 78                	cmp    $0x78,%al
  8014f5:	75 0e                	jne    801505 <strtol+0x9c>
		s += 2, base = 16;
  8014f7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014fc:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801503:	eb 2c                	jmp    801531 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801505:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801509:	75 19                	jne    801524 <strtol+0xbb>
  80150b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150f:	0f b6 00             	movzbl (%rax),%eax
  801512:	3c 30                	cmp    $0x30,%al
  801514:	75 0e                	jne    801524 <strtol+0xbb>
		s++, base = 8;
  801516:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80151b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801522:	eb 0d                	jmp    801531 <strtol+0xc8>
	else if (base == 0)
  801524:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801528:	75 07                	jne    801531 <strtol+0xc8>
		base = 10;
  80152a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801531:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801535:	0f b6 00             	movzbl (%rax),%eax
  801538:	3c 2f                	cmp    $0x2f,%al
  80153a:	7e 1d                	jle    801559 <strtol+0xf0>
  80153c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801540:	0f b6 00             	movzbl (%rax),%eax
  801543:	3c 39                	cmp    $0x39,%al
  801545:	7f 12                	jg     801559 <strtol+0xf0>
			dig = *s - '0';
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	0f be c0             	movsbl %al,%eax
  801551:	83 e8 30             	sub    $0x30,%eax
  801554:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801557:	eb 4e                	jmp    8015a7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801559:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155d:	0f b6 00             	movzbl (%rax),%eax
  801560:	3c 60                	cmp    $0x60,%al
  801562:	7e 1d                	jle    801581 <strtol+0x118>
  801564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801568:	0f b6 00             	movzbl (%rax),%eax
  80156b:	3c 7a                	cmp    $0x7a,%al
  80156d:	7f 12                	jg     801581 <strtol+0x118>
			dig = *s - 'a' + 10;
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	0f b6 00             	movzbl (%rax),%eax
  801576:	0f be c0             	movsbl %al,%eax
  801579:	83 e8 57             	sub    $0x57,%eax
  80157c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80157f:	eb 26                	jmp    8015a7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	3c 40                	cmp    $0x40,%al
  80158a:	7e 48                	jle    8015d4 <strtol+0x16b>
  80158c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	3c 5a                	cmp    $0x5a,%al
  801595:	7f 3d                	jg     8015d4 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159b:	0f b6 00             	movzbl (%rax),%eax
  80159e:	0f be c0             	movsbl %al,%eax
  8015a1:	83 e8 37             	sub    $0x37,%eax
  8015a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015aa:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015ad:	7c 02                	jl     8015b1 <strtol+0x148>
			break;
  8015af:	eb 23                	jmp    8015d4 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015b1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015b6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015b9:	48 98                	cltq   
  8015bb:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8015c0:	48 89 c2             	mov    %rax,%rdx
  8015c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015c6:	48 98                	cltq   
  8015c8:	48 01 d0             	add    %rdx,%rax
  8015cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015cf:	e9 5d ff ff ff       	jmpq   801531 <strtol+0xc8>

	if (endptr)
  8015d4:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015d9:	74 0b                	je     8015e6 <strtol+0x17d>
		*endptr = (char *) s;
  8015db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015e3:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015ea:	74 09                	je     8015f5 <strtol+0x18c>
  8015ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f0:	48 f7 d8             	neg    %rax
  8015f3:	eb 04                	jmp    8015f9 <strtol+0x190>
  8015f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015f9:	c9                   	leaveq 
  8015fa:	c3                   	retq   

00000000008015fb <strstr>:

char * strstr(const char *in, const char *str)
{
  8015fb:	55                   	push   %rbp
  8015fc:	48 89 e5             	mov    %rsp,%rbp
  8015ff:	48 83 ec 30          	sub    $0x30,%rsp
  801603:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801607:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80160b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80160f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801613:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801617:	0f b6 00             	movzbl (%rax),%eax
  80161a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80161d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801621:	75 06                	jne    801629 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801627:	eb 6b                	jmp    801694 <strstr+0x99>

	len = strlen(str);
  801629:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80162d:	48 89 c7             	mov    %rax,%rdi
  801630:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  801637:	00 00 00 
  80163a:	ff d0                	callq  *%rax
  80163c:	48 98                	cltq   
  80163e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801646:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80164a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80164e:	0f b6 00             	movzbl (%rax),%eax
  801651:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801654:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801658:	75 07                	jne    801661 <strstr+0x66>
				return (char *) 0;
  80165a:	b8 00 00 00 00       	mov    $0x0,%eax
  80165f:	eb 33                	jmp    801694 <strstr+0x99>
		} while (sc != c);
  801661:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801665:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801668:	75 d8                	jne    801642 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80166a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80166e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801672:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801676:	48 89 ce             	mov    %rcx,%rsi
  801679:	48 89 c7             	mov    %rax,%rdi
  80167c:	48 b8 f2 10 80 00 00 	movabs $0x8010f2,%rax
  801683:	00 00 00 
  801686:	ff d0                	callq  *%rax
  801688:	85 c0                	test   %eax,%eax
  80168a:	75 b6                	jne    801642 <strstr+0x47>

	return (char *) (in - 1);
  80168c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801690:	48 83 e8 01          	sub    $0x1,%rax
}
  801694:	c9                   	leaveq 
  801695:	c3                   	retq   

0000000000801696 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801696:	55                   	push   %rbp
  801697:	48 89 e5             	mov    %rsp,%rbp
  80169a:	53                   	push   %rbx
  80169b:	48 83 ec 48          	sub    $0x48,%rsp
  80169f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016a2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016a5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016a9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016ad:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016b1:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016b5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016b8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016bc:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016c0:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016c4:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016c8:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016cc:	4c 89 c3             	mov    %r8,%rbx
  8016cf:	cd 30                	int    $0x30
  8016d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016d9:	74 3e                	je     801719 <syscall+0x83>
  8016db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016e0:	7e 37                	jle    801719 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016e6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016e9:	49 89 d0             	mov    %rdx,%r8
  8016ec:	89 c1                	mov    %eax,%ecx
  8016ee:	48 ba c8 43 80 00 00 	movabs $0x8043c8,%rdx
  8016f5:	00 00 00 
  8016f8:	be 23 00 00 00       	mov    $0x23,%esi
  8016fd:	48 bf e5 43 80 00 00 	movabs $0x8043e5,%rdi
  801704:	00 00 00 
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
  80170c:	49 b9 f0 3a 80 00 00 	movabs $0x803af0,%r9
  801713:	00 00 00 
  801716:	41 ff d1             	callq  *%r9

	return ret;
  801719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80171d:	48 83 c4 48          	add    $0x48,%rsp
  801721:	5b                   	pop    %rbx
  801722:	5d                   	pop    %rbp
  801723:	c3                   	retq   

0000000000801724 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801724:	55                   	push   %rbp
  801725:	48 89 e5             	mov    %rsp,%rbp
  801728:	48 83 ec 20          	sub    $0x20,%rsp
  80172c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801730:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801734:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801738:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80173c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801743:	00 
  801744:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80174a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801750:	48 89 d1             	mov    %rdx,%rcx
  801753:	48 89 c2             	mov    %rax,%rdx
  801756:	be 00 00 00 00       	mov    $0x0,%esi
  80175b:	bf 00 00 00 00       	mov    $0x0,%edi
  801760:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801767:	00 00 00 
  80176a:	ff d0                	callq  *%rax
}
  80176c:	c9                   	leaveq 
  80176d:	c3                   	retq   

000000000080176e <sys_cgetc>:

int
sys_cgetc(void)
{
  80176e:	55                   	push   %rbp
  80176f:	48 89 e5             	mov    %rsp,%rbp
  801772:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801776:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80177d:	00 
  80177e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801784:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80178a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80178f:	ba 00 00 00 00       	mov    $0x0,%edx
  801794:	be 00 00 00 00       	mov    $0x0,%esi
  801799:	bf 01 00 00 00       	mov    $0x1,%edi
  80179e:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8017a5:	00 00 00 
  8017a8:	ff d0                	callq  *%rax
}
  8017aa:	c9                   	leaveq 
  8017ab:	c3                   	retq   

00000000008017ac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017ac:	55                   	push   %rbp
  8017ad:	48 89 e5             	mov    %rsp,%rbp
  8017b0:	48 83 ec 10          	sub    $0x10,%rsp
  8017b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017ba:	48 98                	cltq   
  8017bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017c3:	00 
  8017c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d5:	48 89 c2             	mov    %rax,%rdx
  8017d8:	be 01 00 00 00       	mov    $0x1,%esi
  8017dd:	bf 03 00 00 00       	mov    $0x3,%edi
  8017e2:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8017e9:	00 00 00 
  8017ec:	ff d0                	callq  *%rax
}
  8017ee:	c9                   	leaveq 
  8017ef:	c3                   	retq   

00000000008017f0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017f0:	55                   	push   %rbp
  8017f1:	48 89 e5             	mov    %rsp,%rbp
  8017f4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017ff:	00 
  801800:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801806:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80180c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801811:	ba 00 00 00 00       	mov    $0x0,%edx
  801816:	be 00 00 00 00       	mov    $0x0,%esi
  80181b:	bf 02 00 00 00       	mov    $0x2,%edi
  801820:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801827:	00 00 00 
  80182a:	ff d0                	callq  *%rax
}
  80182c:	c9                   	leaveq 
  80182d:	c3                   	retq   

000000000080182e <sys_yield>:

void
sys_yield(void)
{
  80182e:	55                   	push   %rbp
  80182f:	48 89 e5             	mov    %rsp,%rbp
  801832:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801836:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80183d:	00 
  80183e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801844:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80184f:	ba 00 00 00 00       	mov    $0x0,%edx
  801854:	be 00 00 00 00       	mov    $0x0,%esi
  801859:	bf 0b 00 00 00       	mov    $0xb,%edi
  80185e:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801865:	00 00 00 
  801868:	ff d0                	callq  *%rax
}
  80186a:	c9                   	leaveq 
  80186b:	c3                   	retq   

000000000080186c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80186c:	55                   	push   %rbp
  80186d:	48 89 e5             	mov    %rsp,%rbp
  801870:	48 83 ec 20          	sub    $0x20,%rsp
  801874:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801877:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80187b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80187e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801881:	48 63 c8             	movslq %eax,%rcx
  801884:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801888:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80188b:	48 98                	cltq   
  80188d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801894:	00 
  801895:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80189b:	49 89 c8             	mov    %rcx,%r8
  80189e:	48 89 d1             	mov    %rdx,%rcx
  8018a1:	48 89 c2             	mov    %rax,%rdx
  8018a4:	be 01 00 00 00       	mov    $0x1,%esi
  8018a9:	bf 04 00 00 00       	mov    $0x4,%edi
  8018ae:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8018b5:	00 00 00 
  8018b8:	ff d0                	callq  *%rax
}
  8018ba:	c9                   	leaveq 
  8018bb:	c3                   	retq   

00000000008018bc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018bc:	55                   	push   %rbp
  8018bd:	48 89 e5             	mov    %rsp,%rbp
  8018c0:	48 83 ec 30          	sub    $0x30,%rsp
  8018c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018cb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018ce:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018d2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018d6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018d9:	48 63 c8             	movslq %eax,%rcx
  8018dc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018e3:	48 63 f0             	movslq %eax,%rsi
  8018e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ed:	48 98                	cltq   
  8018ef:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018f3:	49 89 f9             	mov    %rdi,%r9
  8018f6:	49 89 f0             	mov    %rsi,%r8
  8018f9:	48 89 d1             	mov    %rdx,%rcx
  8018fc:	48 89 c2             	mov    %rax,%rdx
  8018ff:	be 01 00 00 00       	mov    $0x1,%esi
  801904:	bf 05 00 00 00       	mov    $0x5,%edi
  801909:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801910:	00 00 00 
  801913:	ff d0                	callq  *%rax
}
  801915:	c9                   	leaveq 
  801916:	c3                   	retq   

0000000000801917 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801917:	55                   	push   %rbp
  801918:	48 89 e5             	mov    %rsp,%rbp
  80191b:	48 83 ec 20          	sub    $0x20,%rsp
  80191f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801922:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801926:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192d:	48 98                	cltq   
  80192f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801936:	00 
  801937:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801943:	48 89 d1             	mov    %rdx,%rcx
  801946:	48 89 c2             	mov    %rax,%rdx
  801949:	be 01 00 00 00       	mov    $0x1,%esi
  80194e:	bf 06 00 00 00       	mov    $0x6,%edi
  801953:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  80195a:	00 00 00 
  80195d:	ff d0                	callq  *%rax
}
  80195f:	c9                   	leaveq 
  801960:	c3                   	retq   

0000000000801961 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801961:	55                   	push   %rbp
  801962:	48 89 e5             	mov    %rsp,%rbp
  801965:	48 83 ec 10          	sub    $0x10,%rsp
  801969:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80196c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80196f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801972:	48 63 d0             	movslq %eax,%rdx
  801975:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801978:	48 98                	cltq   
  80197a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801981:	00 
  801982:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801988:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198e:	48 89 d1             	mov    %rdx,%rcx
  801991:	48 89 c2             	mov    %rax,%rdx
  801994:	be 01 00 00 00       	mov    $0x1,%esi
  801999:	bf 08 00 00 00       	mov    $0x8,%edi
  80199e:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8019a5:	00 00 00 
  8019a8:	ff d0                	callq  *%rax
}
  8019aa:	c9                   	leaveq 
  8019ab:	c3                   	retq   

00000000008019ac <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019ac:	55                   	push   %rbp
  8019ad:	48 89 e5             	mov    %rsp,%rbp
  8019b0:	48 83 ec 20          	sub    $0x20,%rsp
  8019b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c2:	48 98                	cltq   
  8019c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019cb:	00 
  8019cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d8:	48 89 d1             	mov    %rdx,%rcx
  8019db:	48 89 c2             	mov    %rax,%rdx
  8019de:	be 01 00 00 00       	mov    $0x1,%esi
  8019e3:	bf 09 00 00 00       	mov    $0x9,%edi
  8019e8:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	callq  *%rax
}
  8019f4:	c9                   	leaveq 
  8019f5:	c3                   	retq   

00000000008019f6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019f6:	55                   	push   %rbp
  8019f7:	48 89 e5             	mov    %rsp,%rbp
  8019fa:	48 83 ec 20          	sub    $0x20,%rsp
  8019fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0c:	48 98                	cltq   
  801a0e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a15:	00 
  801a16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a22:	48 89 d1             	mov    %rdx,%rcx
  801a25:	48 89 c2             	mov    %rax,%rdx
  801a28:	be 01 00 00 00       	mov    $0x1,%esi
  801a2d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a32:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801a39:	00 00 00 
  801a3c:	ff d0                	callq  *%rax
}
  801a3e:	c9                   	leaveq 
  801a3f:	c3                   	retq   

0000000000801a40 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a40:	55                   	push   %rbp
  801a41:	48 89 e5             	mov    %rsp,%rbp
  801a44:	48 83 ec 20          	sub    $0x20,%rsp
  801a48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a4f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a53:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a56:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a59:	48 63 f0             	movslq %eax,%rsi
  801a5c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a63:	48 98                	cltq   
  801a65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a70:	00 
  801a71:	49 89 f1             	mov    %rsi,%r9
  801a74:	49 89 c8             	mov    %rcx,%r8
  801a77:	48 89 d1             	mov    %rdx,%rcx
  801a7a:	48 89 c2             	mov    %rax,%rdx
  801a7d:	be 00 00 00 00       	mov    $0x0,%esi
  801a82:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a87:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801a8e:	00 00 00 
  801a91:	ff d0                	callq  *%rax
}
  801a93:	c9                   	leaveq 
  801a94:	c3                   	retq   

0000000000801a95 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a95:	55                   	push   %rbp
  801a96:	48 89 e5             	mov    %rsp,%rbp
  801a99:	48 83 ec 10          	sub    $0x10,%rsp
  801a9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801aa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aa5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aac:	00 
  801aad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801abe:	48 89 c2             	mov    %rax,%rdx
  801ac1:	be 01 00 00 00       	mov    $0x1,%esi
  801ac6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801acb:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801ad2:	00 00 00 
  801ad5:	ff d0                	callq  *%rax
}
  801ad7:	c9                   	leaveq 
  801ad8:	c3                   	retq   

0000000000801ad9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801ad9:	55                   	push   %rbp
  801ada:	48 89 e5             	mov    %rsp,%rbp
  801add:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ae1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae8:	00 
  801ae9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afa:	ba 00 00 00 00       	mov    $0x0,%edx
  801aff:	be 00 00 00 00       	mov    $0x0,%esi
  801b04:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b09:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801b10:	00 00 00 
  801b13:	ff d0                	callq  *%rax
}
  801b15:	c9                   	leaveq 
  801b16:	c3                   	retq   

0000000000801b17 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801b17:	55                   	push   %rbp
  801b18:	48 89 e5             	mov    %rsp,%rbp
  801b1b:	48 83 ec 30          	sub    $0x30,%rsp
  801b1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b26:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b29:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b2d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801b31:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b34:	48 63 c8             	movslq %eax,%rcx
  801b37:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b3e:	48 63 f0             	movslq %eax,%rsi
  801b41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b48:	48 98                	cltq   
  801b4a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b4e:	49 89 f9             	mov    %rdi,%r9
  801b51:	49 89 f0             	mov    %rsi,%r8
  801b54:	48 89 d1             	mov    %rdx,%rcx
  801b57:	48 89 c2             	mov    %rax,%rdx
  801b5a:	be 00 00 00 00       	mov    $0x0,%esi
  801b5f:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b64:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801b6b:	00 00 00 
  801b6e:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801b70:	c9                   	leaveq 
  801b71:	c3                   	retq   

0000000000801b72 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	48 83 ec 20          	sub    $0x20,%rsp
  801b7a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801b82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b91:	00 
  801b92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b9e:	48 89 d1             	mov    %rdx,%rcx
  801ba1:	48 89 c2             	mov    %rax,%rdx
  801ba4:	be 00 00 00 00       	mov    $0x0,%esi
  801ba9:	bf 10 00 00 00       	mov    $0x10,%edi
  801bae:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801bb5:	00 00 00 
  801bb8:	ff d0                	callq  *%rax
}
  801bba:	c9                   	leaveq 
  801bbb:	c3                   	retq   

0000000000801bbc <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801bbc:	55                   	push   %rbp
  801bbd:	48 89 e5             	mov    %rsp,%rbp
  801bc0:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801bc4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bcb:	00 
  801bcc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bdd:	ba 00 00 00 00       	mov    $0x0,%edx
  801be2:	be 00 00 00 00       	mov    $0x0,%esi
  801be7:	bf 11 00 00 00       	mov    $0x11,%edi
  801bec:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801bf3:	00 00 00 
  801bf6:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801bf8:	c9                   	leaveq 
  801bf9:	c3                   	retq   

0000000000801bfa <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801bfa:	55                   	push   %rbp
  801bfb:	48 89 e5             	mov    %rsp,%rbp
  801bfe:	48 83 ec 10          	sub    $0x10,%rsp
  801c02:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801c05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c08:	48 98                	cltq   
  801c0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c11:	00 
  801c12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c23:	48 89 c2             	mov    %rax,%rdx
  801c26:	be 00 00 00 00       	mov    $0x0,%esi
  801c2b:	bf 12 00 00 00       	mov    $0x12,%edi
  801c30:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801c37:	00 00 00 
  801c3a:	ff d0                	callq  *%rax
}
  801c3c:	c9                   	leaveq 
  801c3d:	c3                   	retq   

0000000000801c3e <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801c3e:	55                   	push   %rbp
  801c3f:	48 89 e5             	mov    %rsp,%rbp
  801c42:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801c46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4d:	00 
  801c4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c64:	be 00 00 00 00       	mov    $0x0,%esi
  801c69:	bf 13 00 00 00       	mov    $0x13,%edi
  801c6e:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801c75:	00 00 00 
  801c78:	ff d0                	callq  *%rax
}
  801c7a:	c9                   	leaveq 
  801c7b:	c3                   	retq   

0000000000801c7c <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801c7c:	55                   	push   %rbp
  801c7d:	48 89 e5             	mov    %rsp,%rbp
  801c80:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801c84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c8b:	00 
  801c8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca2:	be 00 00 00 00       	mov    $0x0,%esi
  801ca7:	bf 14 00 00 00       	mov    $0x14,%edi
  801cac:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801cb3:	00 00 00 
  801cb6:	ff d0                	callq  *%rax
}
  801cb8:	c9                   	leaveq 
  801cb9:	c3                   	retq   

0000000000801cba <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801cba:	55                   	push   %rbp
  801cbb:	48 89 e5             	mov    %rsp,%rbp
  801cbe:	48 83 ec 18          	sub    $0x18,%rsp
  801cc2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801cce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cd2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cd6:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cdd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801ce5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce9:	8b 00                	mov    (%rax),%eax
  801ceb:	83 f8 01             	cmp    $0x1,%eax
  801cee:	7e 13                	jle    801d03 <argstart+0x49>
  801cf0:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801cf5:	74 0c                	je     801d03 <argstart+0x49>
  801cf7:	48 b8 f3 43 80 00 00 	movabs $0x8043f3,%rax
  801cfe:	00 00 00 
  801d01:	eb 05                	jmp    801d08 <argstart+0x4e>
  801d03:	b8 00 00 00 00       	mov    $0x0,%eax
  801d08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d0c:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801d10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d14:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801d1b:	00 
}
  801d1c:	c9                   	leaveq 
  801d1d:	c3                   	retq   

0000000000801d1e <argnext>:

int
argnext(struct Argstate *args)
{
  801d1e:	55                   	push   %rbp
  801d1f:	48 89 e5             	mov    %rsp,%rbp
  801d22:	48 83 ec 20          	sub    $0x20,%rsp
  801d26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2e:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801d35:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801d36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3a:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d3e:	48 85 c0             	test   %rax,%rax
  801d41:	75 0a                	jne    801d4d <argnext+0x2f>
		return -1;
  801d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d48:	e9 25 01 00 00       	jmpq   801e72 <argnext+0x154>

	if (!*args->curarg) {
  801d4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d51:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d55:	0f b6 00             	movzbl (%rax),%eax
  801d58:	84 c0                	test   %al,%al
  801d5a:	0f 85 d7 00 00 00    	jne    801e37 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801d60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d64:	48 8b 00             	mov    (%rax),%rax
  801d67:	8b 00                	mov    (%rax),%eax
  801d69:	83 f8 01             	cmp    $0x1,%eax
  801d6c:	0f 84 ef 00 00 00    	je     801e61 <argnext+0x143>
		    || args->argv[1][0] != '-'
  801d72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d76:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d7a:	48 83 c0 08          	add    $0x8,%rax
  801d7e:	48 8b 00             	mov    (%rax),%rax
  801d81:	0f b6 00             	movzbl (%rax),%eax
  801d84:	3c 2d                	cmp    $0x2d,%al
  801d86:	0f 85 d5 00 00 00    	jne    801e61 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  801d8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d90:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d94:	48 83 c0 08          	add    $0x8,%rax
  801d98:	48 8b 00             	mov    (%rax),%rax
  801d9b:	48 83 c0 01          	add    $0x1,%rax
  801d9f:	0f b6 00             	movzbl (%rax),%eax
  801da2:	84 c0                	test   %al,%al
  801da4:	0f 84 b7 00 00 00    	je     801e61 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801daa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dae:	48 8b 40 08          	mov    0x8(%rax),%rax
  801db2:	48 83 c0 08          	add    $0x8,%rax
  801db6:	48 8b 00             	mov    (%rax),%rax
  801db9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801dbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc1:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc9:	48 8b 00             	mov    (%rax),%rax
  801dcc:	8b 00                	mov    (%rax),%eax
  801dce:	83 e8 01             	sub    $0x1,%eax
  801dd1:	48 98                	cltq   
  801dd3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801dda:	00 
  801ddb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ddf:	48 8b 40 08          	mov    0x8(%rax),%rax
  801de3:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801de7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801deb:	48 8b 40 08          	mov    0x8(%rax),%rax
  801def:	48 83 c0 08          	add    $0x8,%rax
  801df3:	48 89 ce             	mov    %rcx,%rsi
  801df6:	48 89 c7             	mov    %rax,%rdi
  801df9:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  801e00:	00 00 00 
  801e03:	ff d0                	callq  *%rax
		(*args->argc)--;
  801e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e09:	48 8b 00             	mov    (%rax),%rax
  801e0c:	8b 10                	mov    (%rax),%edx
  801e0e:	83 ea 01             	sub    $0x1,%edx
  801e11:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e17:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e1b:	0f b6 00             	movzbl (%rax),%eax
  801e1e:	3c 2d                	cmp    $0x2d,%al
  801e20:	75 15                	jne    801e37 <argnext+0x119>
  801e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e26:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e2a:	48 83 c0 01          	add    $0x1,%rax
  801e2e:	0f b6 00             	movzbl (%rax),%eax
  801e31:	84 c0                	test   %al,%al
  801e33:	75 02                	jne    801e37 <argnext+0x119>
			goto endofargs;
  801e35:	eb 2a                	jmp    801e61 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  801e37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e3b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e3f:	0f b6 00             	movzbl (%rax),%eax
  801e42:	0f b6 c0             	movzbl %al,%eax
  801e45:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801e48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e4c:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e50:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e58:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801e5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e5f:	eb 11                	jmp    801e72 <argnext+0x154>

endofargs:
	args->curarg = 0;
  801e61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e65:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801e6c:	00 
	return -1;
  801e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801e72:	c9                   	leaveq 
  801e73:	c3                   	retq   

0000000000801e74 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801e74:	55                   	push   %rbp
  801e75:	48 89 e5             	mov    %rsp,%rbp
  801e78:	48 83 ec 10          	sub    $0x10,%rsp
  801e7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801e80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e84:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e88:	48 85 c0             	test   %rax,%rax
  801e8b:	74 0a                	je     801e97 <argvalue+0x23>
  801e8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e91:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e95:	eb 13                	jmp    801eaa <argvalue+0x36>
  801e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e9b:	48 89 c7             	mov    %rax,%rdi
  801e9e:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  801ea5:	00 00 00 
  801ea8:	ff d0                	callq  *%rax
}
  801eaa:	c9                   	leaveq 
  801eab:	c3                   	retq   

0000000000801eac <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801eac:	55                   	push   %rbp
  801ead:	48 89 e5             	mov    %rsp,%rbp
  801eb0:	53                   	push   %rbx
  801eb1:	48 83 ec 18          	sub    $0x18,%rsp
  801eb5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  801eb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebd:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ec1:	48 85 c0             	test   %rax,%rax
  801ec4:	75 0a                	jne    801ed0 <argnextvalue+0x24>
		return 0;
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecb:	e9 c8 00 00 00       	jmpq   801f98 <argnextvalue+0xec>
	if (*args->curarg) {
  801ed0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed4:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ed8:	0f b6 00             	movzbl (%rax),%eax
  801edb:	84 c0                	test   %al,%al
  801edd:	74 27                	je     801f06 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  801edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801ee7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eeb:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef3:	48 bb f3 43 80 00 00 	movabs $0x8043f3,%rbx
  801efa:	00 00 00 
  801efd:	48 89 58 10          	mov    %rbx,0x10(%rax)
  801f01:	e9 8a 00 00 00       	jmpq   801f90 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  801f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f0a:	48 8b 00             	mov    (%rax),%rax
  801f0d:	8b 00                	mov    (%rax),%eax
  801f0f:	83 f8 01             	cmp    $0x1,%eax
  801f12:	7e 64                	jle    801f78 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  801f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f18:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f1c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801f20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f24:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2c:	48 8b 00             	mov    (%rax),%rax
  801f2f:	8b 00                	mov    (%rax),%eax
  801f31:	83 e8 01             	sub    $0x1,%eax
  801f34:	48 98                	cltq   
  801f36:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801f3d:	00 
  801f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f42:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f46:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f52:	48 83 c0 08          	add    $0x8,%rax
  801f56:	48 89 ce             	mov    %rcx,%rsi
  801f59:	48 89 c7             	mov    %rax,%rdi
  801f5c:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  801f63:	00 00 00 
  801f66:	ff d0                	callq  *%rax
		(*args->argc)--;
  801f68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f6c:	48 8b 00             	mov    (%rax),%rax
  801f6f:	8b 10                	mov    (%rax),%edx
  801f71:	83 ea 01             	sub    $0x1,%edx
  801f74:	89 10                	mov    %edx,(%rax)
  801f76:	eb 18                	jmp    801f90 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  801f78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f7c:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801f83:	00 
		args->curarg = 0;
  801f84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f88:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801f8f:	00 
	}
	return (char*) args->argvalue;
  801f90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f94:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801f98:	48 83 c4 18          	add    $0x18,%rsp
  801f9c:	5b                   	pop    %rbx
  801f9d:	5d                   	pop    %rbp
  801f9e:	c3                   	retq   

0000000000801f9f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801f9f:	55                   	push   %rbp
  801fa0:	48 89 e5             	mov    %rsp,%rbp
  801fa3:	48 83 ec 08          	sub    $0x8,%rsp
  801fa7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801faf:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801fb6:	ff ff ff 
  801fb9:	48 01 d0             	add    %rdx,%rax
  801fbc:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801fc0:	c9                   	leaveq 
  801fc1:	c3                   	retq   

0000000000801fc2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801fc2:	55                   	push   %rbp
  801fc3:	48 89 e5             	mov    %rsp,%rbp
  801fc6:	48 83 ec 08          	sub    $0x8,%rsp
  801fca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801fce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd2:	48 89 c7             	mov    %rax,%rdi
  801fd5:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  801fdc:	00 00 00 
  801fdf:	ff d0                	callq  *%rax
  801fe1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801fe7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801feb:	c9                   	leaveq 
  801fec:	c3                   	retq   

0000000000801fed <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801fed:	55                   	push   %rbp
  801fee:	48 89 e5             	mov    %rsp,%rbp
  801ff1:	48 83 ec 18          	sub    $0x18,%rsp
  801ff5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ff9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802000:	eb 6b                	jmp    80206d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802002:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802005:	48 98                	cltq   
  802007:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80200d:	48 c1 e0 0c          	shl    $0xc,%rax
  802011:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802015:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802019:	48 c1 e8 15          	shr    $0x15,%rax
  80201d:	48 89 c2             	mov    %rax,%rdx
  802020:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802027:	01 00 00 
  80202a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80202e:	83 e0 01             	and    $0x1,%eax
  802031:	48 85 c0             	test   %rax,%rax
  802034:	74 21                	je     802057 <fd_alloc+0x6a>
  802036:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80203a:	48 c1 e8 0c          	shr    $0xc,%rax
  80203e:	48 89 c2             	mov    %rax,%rdx
  802041:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802048:	01 00 00 
  80204b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204f:	83 e0 01             	and    $0x1,%eax
  802052:	48 85 c0             	test   %rax,%rax
  802055:	75 12                	jne    802069 <fd_alloc+0x7c>
			*fd_store = fd;
  802057:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80205f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802062:	b8 00 00 00 00       	mov    $0x0,%eax
  802067:	eb 1a                	jmp    802083 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802069:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80206d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802071:	7e 8f                	jle    802002 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802077:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80207e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802083:	c9                   	leaveq 
  802084:	c3                   	retq   

0000000000802085 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802085:	55                   	push   %rbp
  802086:	48 89 e5             	mov    %rsp,%rbp
  802089:	48 83 ec 20          	sub    $0x20,%rsp
  80208d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802090:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802094:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802098:	78 06                	js     8020a0 <fd_lookup+0x1b>
  80209a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80209e:	7e 07                	jle    8020a7 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8020a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020a5:	eb 6c                	jmp    802113 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8020a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020aa:	48 98                	cltq   
  8020ac:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020b2:	48 c1 e0 0c          	shl    $0xc,%rax
  8020b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8020ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020be:	48 c1 e8 15          	shr    $0x15,%rax
  8020c2:	48 89 c2             	mov    %rax,%rdx
  8020c5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020cc:	01 00 00 
  8020cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d3:	83 e0 01             	and    $0x1,%eax
  8020d6:	48 85 c0             	test   %rax,%rax
  8020d9:	74 21                	je     8020fc <fd_lookup+0x77>
  8020db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020df:	48 c1 e8 0c          	shr    $0xc,%rax
  8020e3:	48 89 c2             	mov    %rax,%rdx
  8020e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ed:	01 00 00 
  8020f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020f4:	83 e0 01             	and    $0x1,%eax
  8020f7:	48 85 c0             	test   %rax,%rax
  8020fa:	75 07                	jne    802103 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8020fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802101:	eb 10                	jmp    802113 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802103:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802107:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80210b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802113:	c9                   	leaveq 
  802114:	c3                   	retq   

0000000000802115 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802115:	55                   	push   %rbp
  802116:	48 89 e5             	mov    %rsp,%rbp
  802119:	48 83 ec 30          	sub    $0x30,%rsp
  80211d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802121:	89 f0                	mov    %esi,%eax
  802123:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802126:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212a:	48 89 c7             	mov    %rax,%rdi
  80212d:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  802134:	00 00 00 
  802137:	ff d0                	callq  *%rax
  802139:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80213d:	48 89 d6             	mov    %rdx,%rsi
  802140:	89 c7                	mov    %eax,%edi
  802142:	48 b8 85 20 80 00 00 	movabs $0x802085,%rax
  802149:	00 00 00 
  80214c:	ff d0                	callq  *%rax
  80214e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802151:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802155:	78 0a                	js     802161 <fd_close+0x4c>
	    || fd != fd2)
  802157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80215b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80215f:	74 12                	je     802173 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802161:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802165:	74 05                	je     80216c <fd_close+0x57>
  802167:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216a:	eb 05                	jmp    802171 <fd_close+0x5c>
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
  802171:	eb 69                	jmp    8021dc <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802173:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802177:	8b 00                	mov    (%rax),%eax
  802179:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80217d:	48 89 d6             	mov    %rdx,%rsi
  802180:	89 c7                	mov    %eax,%edi
  802182:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  802189:	00 00 00 
  80218c:	ff d0                	callq  *%rax
  80218e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802191:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802195:	78 2a                	js     8021c1 <fd_close+0xac>
		if (dev->dev_close)
  802197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80219f:	48 85 c0             	test   %rax,%rax
  8021a2:	74 16                	je     8021ba <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8021a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021ac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021b0:	48 89 d7             	mov    %rdx,%rdi
  8021b3:	ff d0                	callq  *%rax
  8021b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b8:	eb 07                	jmp    8021c1 <fd_close+0xac>
		else
			r = 0;
  8021ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8021c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021c5:	48 89 c6             	mov    %rax,%rsi
  8021c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8021cd:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  8021d4:	00 00 00 
  8021d7:	ff d0                	callq  *%rax
	return r;
  8021d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021dc:	c9                   	leaveq 
  8021dd:	c3                   	retq   

00000000008021de <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8021de:	55                   	push   %rbp
  8021df:	48 89 e5             	mov    %rsp,%rbp
  8021e2:	48 83 ec 20          	sub    $0x20,%rsp
  8021e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8021ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021f4:	eb 41                	jmp    802237 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8021f6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8021fd:	00 00 00 
  802200:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802203:	48 63 d2             	movslq %edx,%rdx
  802206:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220a:	8b 00                	mov    (%rax),%eax
  80220c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80220f:	75 22                	jne    802233 <dev_lookup+0x55>
			*dev = devtab[i];
  802211:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802218:	00 00 00 
  80221b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80221e:	48 63 d2             	movslq %edx,%rdx
  802221:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802225:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802229:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80222c:	b8 00 00 00 00       	mov    $0x0,%eax
  802231:	eb 60                	jmp    802293 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802233:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802237:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80223e:	00 00 00 
  802241:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802244:	48 63 d2             	movslq %edx,%rdx
  802247:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80224b:	48 85 c0             	test   %rax,%rax
  80224e:	75 a6                	jne    8021f6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802250:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802257:	00 00 00 
  80225a:	48 8b 00             	mov    (%rax),%rax
  80225d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802263:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802266:	89 c6                	mov    %eax,%esi
  802268:	48 bf f8 43 80 00 00 	movabs $0x8043f8,%rdi
  80226f:	00 00 00 
  802272:	b8 00 00 00 00       	mov    $0x0,%eax
  802277:	48 b9 88 03 80 00 00 	movabs $0x800388,%rcx
  80227e:	00 00 00 
  802281:	ff d1                	callq  *%rcx
	*dev = 0;
  802283:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802287:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80228e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802293:	c9                   	leaveq 
  802294:	c3                   	retq   

0000000000802295 <close>:

int
close(int fdnum)
{
  802295:	55                   	push   %rbp
  802296:	48 89 e5             	mov    %rsp,%rbp
  802299:	48 83 ec 20          	sub    $0x20,%rsp
  80229d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022a7:	48 89 d6             	mov    %rdx,%rsi
  8022aa:	89 c7                	mov    %eax,%edi
  8022ac:	48 b8 85 20 80 00 00 	movabs $0x802085,%rax
  8022b3:	00 00 00 
  8022b6:	ff d0                	callq  *%rax
  8022b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022bf:	79 05                	jns    8022c6 <close+0x31>
		return r;
  8022c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c4:	eb 18                	jmp    8022de <close+0x49>
	else
		return fd_close(fd, 1);
  8022c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ca:	be 01 00 00 00       	mov    $0x1,%esi
  8022cf:	48 89 c7             	mov    %rax,%rdi
  8022d2:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  8022d9:	00 00 00 
  8022dc:	ff d0                	callq  *%rax
}
  8022de:	c9                   	leaveq 
  8022df:	c3                   	retq   

00000000008022e0 <close_all>:

void
close_all(void)
{
  8022e0:	55                   	push   %rbp
  8022e1:	48 89 e5             	mov    %rsp,%rbp
  8022e4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8022e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022ef:	eb 15                	jmp    802306 <close_all+0x26>
		close(i);
  8022f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f4:	89 c7                	mov    %eax,%edi
  8022f6:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  8022fd:	00 00 00 
  802300:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802302:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802306:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80230a:	7e e5                	jle    8022f1 <close_all+0x11>
		close(i);
}
  80230c:	c9                   	leaveq 
  80230d:	c3                   	retq   

000000000080230e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80230e:	55                   	push   %rbp
  80230f:	48 89 e5             	mov    %rsp,%rbp
  802312:	48 83 ec 40          	sub    $0x40,%rsp
  802316:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802319:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80231c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802320:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802323:	48 89 d6             	mov    %rdx,%rsi
  802326:	89 c7                	mov    %eax,%edi
  802328:	48 b8 85 20 80 00 00 	movabs $0x802085,%rax
  80232f:	00 00 00 
  802332:	ff d0                	callq  *%rax
  802334:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802337:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80233b:	79 08                	jns    802345 <dup+0x37>
		return r;
  80233d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802340:	e9 70 01 00 00       	jmpq   8024b5 <dup+0x1a7>
	close(newfdnum);
  802345:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802348:	89 c7                	mov    %eax,%edi
  80234a:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802351:	00 00 00 
  802354:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802356:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802359:	48 98                	cltq   
  80235b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802361:	48 c1 e0 0c          	shl    $0xc,%rax
  802365:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802369:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80236d:	48 89 c7             	mov    %rax,%rdi
  802370:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  802377:	00 00 00 
  80237a:	ff d0                	callq  *%rax
  80237c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802384:	48 89 c7             	mov    %rax,%rdi
  802387:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  80238e:	00 00 00 
  802391:	ff d0                	callq  *%rax
  802393:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802397:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239b:	48 c1 e8 15          	shr    $0x15,%rax
  80239f:	48 89 c2             	mov    %rax,%rdx
  8023a2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023a9:	01 00 00 
  8023ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b0:	83 e0 01             	and    $0x1,%eax
  8023b3:	48 85 c0             	test   %rax,%rax
  8023b6:	74 73                	je     80242b <dup+0x11d>
  8023b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8023c0:	48 89 c2             	mov    %rax,%rdx
  8023c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023ca:	01 00 00 
  8023cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023d1:	83 e0 01             	and    $0x1,%eax
  8023d4:	48 85 c0             	test   %rax,%rax
  8023d7:	74 52                	je     80242b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8023d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023dd:	48 c1 e8 0c          	shr    $0xc,%rax
  8023e1:	48 89 c2             	mov    %rax,%rdx
  8023e4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023eb:	01 00 00 
  8023ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8023f7:	89 c1                	mov    %eax,%ecx
  8023f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802401:	41 89 c8             	mov    %ecx,%r8d
  802404:	48 89 d1             	mov    %rdx,%rcx
  802407:	ba 00 00 00 00       	mov    $0x0,%edx
  80240c:	48 89 c6             	mov    %rax,%rsi
  80240f:	bf 00 00 00 00       	mov    $0x0,%edi
  802414:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  80241b:	00 00 00 
  80241e:	ff d0                	callq  *%rax
  802420:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802423:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802427:	79 02                	jns    80242b <dup+0x11d>
			goto err;
  802429:	eb 57                	jmp    802482 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80242b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80242f:	48 c1 e8 0c          	shr    $0xc,%rax
  802433:	48 89 c2             	mov    %rax,%rdx
  802436:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80243d:	01 00 00 
  802440:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802444:	25 07 0e 00 00       	and    $0xe07,%eax
  802449:	89 c1                	mov    %eax,%ecx
  80244b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80244f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802453:	41 89 c8             	mov    %ecx,%r8d
  802456:	48 89 d1             	mov    %rdx,%rcx
  802459:	ba 00 00 00 00       	mov    $0x0,%edx
  80245e:	48 89 c6             	mov    %rax,%rsi
  802461:	bf 00 00 00 00       	mov    $0x0,%edi
  802466:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  80246d:	00 00 00 
  802470:	ff d0                	callq  *%rax
  802472:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802475:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802479:	79 02                	jns    80247d <dup+0x16f>
		goto err;
  80247b:	eb 05                	jmp    802482 <dup+0x174>

	return newfdnum;
  80247d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802480:	eb 33                	jmp    8024b5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802486:	48 89 c6             	mov    %rax,%rsi
  802489:	bf 00 00 00 00       	mov    $0x0,%edi
  80248e:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  802495:	00 00 00 
  802498:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80249a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80249e:	48 89 c6             	mov    %rax,%rsi
  8024a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a6:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  8024ad:	00 00 00 
  8024b0:	ff d0                	callq  *%rax
	return r;
  8024b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024b5:	c9                   	leaveq 
  8024b6:	c3                   	retq   

00000000008024b7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8024b7:	55                   	push   %rbp
  8024b8:	48 89 e5             	mov    %rsp,%rbp
  8024bb:	48 83 ec 40          	sub    $0x40,%rsp
  8024bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024c6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024ca:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024ce:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024d1:	48 89 d6             	mov    %rdx,%rsi
  8024d4:	89 c7                	mov    %eax,%edi
  8024d6:	48 b8 85 20 80 00 00 	movabs $0x802085,%rax
  8024dd:	00 00 00 
  8024e0:	ff d0                	callq  *%rax
  8024e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e9:	78 24                	js     80250f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ef:	8b 00                	mov    (%rax),%eax
  8024f1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024f5:	48 89 d6             	mov    %rdx,%rsi
  8024f8:	89 c7                	mov    %eax,%edi
  8024fa:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  802501:	00 00 00 
  802504:	ff d0                	callq  *%rax
  802506:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802509:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250d:	79 05                	jns    802514 <read+0x5d>
		return r;
  80250f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802512:	eb 76                	jmp    80258a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802518:	8b 40 08             	mov    0x8(%rax),%eax
  80251b:	83 e0 03             	and    $0x3,%eax
  80251e:	83 f8 01             	cmp    $0x1,%eax
  802521:	75 3a                	jne    80255d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802523:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80252a:	00 00 00 
  80252d:	48 8b 00             	mov    (%rax),%rax
  802530:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802536:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802539:	89 c6                	mov    %eax,%esi
  80253b:	48 bf 17 44 80 00 00 	movabs $0x804417,%rdi
  802542:	00 00 00 
  802545:	b8 00 00 00 00       	mov    $0x0,%eax
  80254a:	48 b9 88 03 80 00 00 	movabs $0x800388,%rcx
  802551:	00 00 00 
  802554:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802556:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80255b:	eb 2d                	jmp    80258a <read+0xd3>
	}
	if (!dev->dev_read)
  80255d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802561:	48 8b 40 10          	mov    0x10(%rax),%rax
  802565:	48 85 c0             	test   %rax,%rax
  802568:	75 07                	jne    802571 <read+0xba>
		return -E_NOT_SUPP;
  80256a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80256f:	eb 19                	jmp    80258a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802571:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802575:	48 8b 40 10          	mov    0x10(%rax),%rax
  802579:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80257d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802581:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802585:	48 89 cf             	mov    %rcx,%rdi
  802588:	ff d0                	callq  *%rax
}
  80258a:	c9                   	leaveq 
  80258b:	c3                   	retq   

000000000080258c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80258c:	55                   	push   %rbp
  80258d:	48 89 e5             	mov    %rsp,%rbp
  802590:	48 83 ec 30          	sub    $0x30,%rsp
  802594:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802597:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80259b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80259f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025a6:	eb 49                	jmp    8025f1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8025a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ab:	48 98                	cltq   
  8025ad:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025b1:	48 29 c2             	sub    %rax,%rdx
  8025b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b7:	48 63 c8             	movslq %eax,%rcx
  8025ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025be:	48 01 c1             	add    %rax,%rcx
  8025c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025c4:	48 89 ce             	mov    %rcx,%rsi
  8025c7:	89 c7                	mov    %eax,%edi
  8025c9:	48 b8 b7 24 80 00 00 	movabs $0x8024b7,%rax
  8025d0:	00 00 00 
  8025d3:	ff d0                	callq  *%rax
  8025d5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8025d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025dc:	79 05                	jns    8025e3 <readn+0x57>
			return m;
  8025de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025e1:	eb 1c                	jmp    8025ff <readn+0x73>
		if (m == 0)
  8025e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025e7:	75 02                	jne    8025eb <readn+0x5f>
			break;
  8025e9:	eb 11                	jmp    8025fc <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8025eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025ee:	01 45 fc             	add    %eax,-0x4(%rbp)
  8025f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f4:	48 98                	cltq   
  8025f6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8025fa:	72 ac                	jb     8025a8 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8025fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025ff:	c9                   	leaveq 
  802600:	c3                   	retq   

0000000000802601 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802601:	55                   	push   %rbp
  802602:	48 89 e5             	mov    %rsp,%rbp
  802605:	48 83 ec 40          	sub    $0x40,%rsp
  802609:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80260c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802610:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802614:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802618:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80261b:	48 89 d6             	mov    %rdx,%rsi
  80261e:	89 c7                	mov    %eax,%edi
  802620:	48 b8 85 20 80 00 00 	movabs $0x802085,%rax
  802627:	00 00 00 
  80262a:	ff d0                	callq  *%rax
  80262c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802633:	78 24                	js     802659 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802639:	8b 00                	mov    (%rax),%eax
  80263b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80263f:	48 89 d6             	mov    %rdx,%rsi
  802642:	89 c7                	mov    %eax,%edi
  802644:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  80264b:	00 00 00 
  80264e:	ff d0                	callq  *%rax
  802650:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802653:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802657:	79 05                	jns    80265e <write+0x5d>
		return r;
  802659:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80265c:	eb 42                	jmp    8026a0 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80265e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802662:	8b 40 08             	mov    0x8(%rax),%eax
  802665:	83 e0 03             	and    $0x3,%eax
  802668:	85 c0                	test   %eax,%eax
  80266a:	75 07                	jne    802673 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80266c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802671:	eb 2d                	jmp    8026a0 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802673:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802677:	48 8b 40 18          	mov    0x18(%rax),%rax
  80267b:	48 85 c0             	test   %rax,%rax
  80267e:	75 07                	jne    802687 <write+0x86>
		return -E_NOT_SUPP;
  802680:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802685:	eb 19                	jmp    8026a0 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802687:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80268f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802693:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802697:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80269b:	48 89 cf             	mov    %rcx,%rdi
  80269e:	ff d0                	callq  *%rax
}
  8026a0:	c9                   	leaveq 
  8026a1:	c3                   	retq   

00000000008026a2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8026a2:	55                   	push   %rbp
  8026a3:	48 89 e5             	mov    %rsp,%rbp
  8026a6:	48 83 ec 18          	sub    $0x18,%rsp
  8026aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026ad:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026b7:	48 89 d6             	mov    %rdx,%rsi
  8026ba:	89 c7                	mov    %eax,%edi
  8026bc:	48 b8 85 20 80 00 00 	movabs $0x802085,%rax
  8026c3:	00 00 00 
  8026c6:	ff d0                	callq  *%rax
  8026c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026cf:	79 05                	jns    8026d6 <seek+0x34>
		return r;
  8026d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d4:	eb 0f                	jmp    8026e5 <seek+0x43>
	fd->fd_offset = offset;
  8026d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026da:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8026dd:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8026e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e5:	c9                   	leaveq 
  8026e6:	c3                   	retq   

00000000008026e7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8026e7:	55                   	push   %rbp
  8026e8:	48 89 e5             	mov    %rsp,%rbp
  8026eb:	48 83 ec 30          	sub    $0x30,%rsp
  8026ef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026f2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026f5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026f9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026fc:	48 89 d6             	mov    %rdx,%rsi
  8026ff:	89 c7                	mov    %eax,%edi
  802701:	48 b8 85 20 80 00 00 	movabs $0x802085,%rax
  802708:	00 00 00 
  80270b:	ff d0                	callq  *%rax
  80270d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802710:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802714:	78 24                	js     80273a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80271a:	8b 00                	mov    (%rax),%eax
  80271c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802720:	48 89 d6             	mov    %rdx,%rsi
  802723:	89 c7                	mov    %eax,%edi
  802725:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  80272c:	00 00 00 
  80272f:	ff d0                	callq  *%rax
  802731:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802734:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802738:	79 05                	jns    80273f <ftruncate+0x58>
		return r;
  80273a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273d:	eb 72                	jmp    8027b1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80273f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802743:	8b 40 08             	mov    0x8(%rax),%eax
  802746:	83 e0 03             	and    $0x3,%eax
  802749:	85 c0                	test   %eax,%eax
  80274b:	75 3a                	jne    802787 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80274d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802754:	00 00 00 
  802757:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80275a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802760:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802763:	89 c6                	mov    %eax,%esi
  802765:	48 bf 38 44 80 00 00 	movabs $0x804438,%rdi
  80276c:	00 00 00 
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
  802774:	48 b9 88 03 80 00 00 	movabs $0x800388,%rcx
  80277b:	00 00 00 
  80277e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802780:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802785:	eb 2a                	jmp    8027b1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802787:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80278f:	48 85 c0             	test   %rax,%rax
  802792:	75 07                	jne    80279b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802794:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802799:	eb 16                	jmp    8027b1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80279b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80279f:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027a7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8027aa:	89 ce                	mov    %ecx,%esi
  8027ac:	48 89 d7             	mov    %rdx,%rdi
  8027af:	ff d0                	callq  *%rax
}
  8027b1:	c9                   	leaveq 
  8027b2:	c3                   	retq   

00000000008027b3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8027b3:	55                   	push   %rbp
  8027b4:	48 89 e5             	mov    %rsp,%rbp
  8027b7:	48 83 ec 30          	sub    $0x30,%rsp
  8027bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027c2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027c9:	48 89 d6             	mov    %rdx,%rsi
  8027cc:	89 c7                	mov    %eax,%edi
  8027ce:	48 b8 85 20 80 00 00 	movabs $0x802085,%rax
  8027d5:	00 00 00 
  8027d8:	ff d0                	callq  *%rax
  8027da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e1:	78 24                	js     802807 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e7:	8b 00                	mov    (%rax),%eax
  8027e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027ed:	48 89 d6             	mov    %rdx,%rsi
  8027f0:	89 c7                	mov    %eax,%edi
  8027f2:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  8027f9:	00 00 00 
  8027fc:	ff d0                	callq  *%rax
  8027fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802801:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802805:	79 05                	jns    80280c <fstat+0x59>
		return r;
  802807:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280a:	eb 5e                	jmp    80286a <fstat+0xb7>
	if (!dev->dev_stat)
  80280c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802810:	48 8b 40 28          	mov    0x28(%rax),%rax
  802814:	48 85 c0             	test   %rax,%rax
  802817:	75 07                	jne    802820 <fstat+0x6d>
		return -E_NOT_SUPP;
  802819:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80281e:	eb 4a                	jmp    80286a <fstat+0xb7>
	stat->st_name[0] = 0;
  802820:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802824:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802827:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80282b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802832:	00 00 00 
	stat->st_isdir = 0;
  802835:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802839:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802840:	00 00 00 
	stat->st_dev = dev;
  802843:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802847:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80284b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802852:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802856:	48 8b 40 28          	mov    0x28(%rax),%rax
  80285a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80285e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802862:	48 89 ce             	mov    %rcx,%rsi
  802865:	48 89 d7             	mov    %rdx,%rdi
  802868:	ff d0                	callq  *%rax
}
  80286a:	c9                   	leaveq 
  80286b:	c3                   	retq   

000000000080286c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80286c:	55                   	push   %rbp
  80286d:	48 89 e5             	mov    %rsp,%rbp
  802870:	48 83 ec 20          	sub    $0x20,%rsp
  802874:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802878:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80287c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802880:	be 00 00 00 00       	mov    $0x0,%esi
  802885:	48 89 c7             	mov    %rax,%rdi
  802888:	48 b8 5a 29 80 00 00 	movabs $0x80295a,%rax
  80288f:	00 00 00 
  802892:	ff d0                	callq  *%rax
  802894:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802897:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80289b:	79 05                	jns    8028a2 <stat+0x36>
		return fd;
  80289d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a0:	eb 2f                	jmp    8028d1 <stat+0x65>
	r = fstat(fd, stat);
  8028a2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a9:	48 89 d6             	mov    %rdx,%rsi
  8028ac:	89 c7                	mov    %eax,%edi
  8028ae:	48 b8 b3 27 80 00 00 	movabs $0x8027b3,%rax
  8028b5:	00 00 00 
  8028b8:	ff d0                	callq  *%rax
  8028ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8028bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c0:	89 c7                	mov    %eax,%edi
  8028c2:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  8028c9:	00 00 00 
  8028cc:	ff d0                	callq  *%rax
	return r;
  8028ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8028d1:	c9                   	leaveq 
  8028d2:	c3                   	retq   

00000000008028d3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8028d3:	55                   	push   %rbp
  8028d4:	48 89 e5             	mov    %rsp,%rbp
  8028d7:	48 83 ec 10          	sub    $0x10,%rsp
  8028db:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8028de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8028e2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028e9:	00 00 00 
  8028ec:	8b 00                	mov    (%rax),%eax
  8028ee:	85 c0                	test   %eax,%eax
  8028f0:	75 1d                	jne    80290f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8028f2:	bf 01 00 00 00       	mov    $0x1,%edi
  8028f7:	48 b8 8a 3d 80 00 00 	movabs $0x803d8a,%rax
  8028fe:	00 00 00 
  802901:	ff d0                	callq  *%rax
  802903:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80290a:	00 00 00 
  80290d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80290f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802916:	00 00 00 
  802919:	8b 00                	mov    (%rax),%eax
  80291b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80291e:	b9 07 00 00 00       	mov    $0x7,%ecx
  802923:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80292a:	00 00 00 
  80292d:	89 c7                	mov    %eax,%edi
  80292f:	48 b8 02 3d 80 00 00 	movabs $0x803d02,%rax
  802936:	00 00 00 
  802939:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80293b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80293f:	ba 00 00 00 00       	mov    $0x0,%edx
  802944:	48 89 c6             	mov    %rax,%rsi
  802947:	bf 00 00 00 00       	mov    $0x0,%edi
  80294c:	48 b8 04 3c 80 00 00 	movabs $0x803c04,%rax
  802953:	00 00 00 
  802956:	ff d0                	callq  *%rax
}
  802958:	c9                   	leaveq 
  802959:	c3                   	retq   

000000000080295a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80295a:	55                   	push   %rbp
  80295b:	48 89 e5             	mov    %rsp,%rbp
  80295e:	48 83 ec 30          	sub    $0x30,%rsp
  802962:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802966:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802969:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802970:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802977:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80297e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802983:	75 08                	jne    80298d <open+0x33>
	{
		return r;
  802985:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802988:	e9 f2 00 00 00       	jmpq   802a7f <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80298d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802991:	48 89 c7             	mov    %rax,%rdi
  802994:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  80299b:	00 00 00 
  80299e:	ff d0                	callq  *%rax
  8029a0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8029a3:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8029aa:	7e 0a                	jle    8029b6 <open+0x5c>
	{
		return -E_BAD_PATH;
  8029ac:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029b1:	e9 c9 00 00 00       	jmpq   802a7f <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8029b6:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8029bd:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8029be:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8029c2:	48 89 c7             	mov    %rax,%rdi
  8029c5:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  8029cc:	00 00 00 
  8029cf:	ff d0                	callq  *%rax
  8029d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d8:	78 09                	js     8029e3 <open+0x89>
  8029da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029de:	48 85 c0             	test   %rax,%rax
  8029e1:	75 08                	jne    8029eb <open+0x91>
		{
			return r;
  8029e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e6:	e9 94 00 00 00       	jmpq   802a7f <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8029eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ef:	ba 00 04 00 00       	mov    $0x400,%edx
  8029f4:	48 89 c6             	mov    %rax,%rsi
  8029f7:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8029fe:	00 00 00 
  802a01:	48 b8 cf 0f 80 00 00 	movabs $0x800fcf,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802a0d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a14:	00 00 00 
  802a17:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802a1a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a24:	48 89 c6             	mov    %rax,%rsi
  802a27:	bf 01 00 00 00       	mov    $0x1,%edi
  802a2c:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  802a33:	00 00 00 
  802a36:	ff d0                	callq  *%rax
  802a38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a3f:	79 2b                	jns    802a6c <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802a41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a45:	be 00 00 00 00       	mov    $0x0,%esi
  802a4a:	48 89 c7             	mov    %rax,%rdi
  802a4d:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  802a54:	00 00 00 
  802a57:	ff d0                	callq  *%rax
  802a59:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802a5c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a60:	79 05                	jns    802a67 <open+0x10d>
			{
				return d;
  802a62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a65:	eb 18                	jmp    802a7f <open+0x125>
			}
			return r;
  802a67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6a:	eb 13                	jmp    802a7f <open+0x125>
		}	
		return fd2num(fd_store);
  802a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a70:	48 89 c7             	mov    %rax,%rdi
  802a73:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  802a7a:	00 00 00 
  802a7d:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802a7f:	c9                   	leaveq 
  802a80:	c3                   	retq   

0000000000802a81 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802a81:	55                   	push   %rbp
  802a82:	48 89 e5             	mov    %rsp,%rbp
  802a85:	48 83 ec 10          	sub    $0x10,%rsp
  802a89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a91:	8b 50 0c             	mov    0xc(%rax),%edx
  802a94:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a9b:	00 00 00 
  802a9e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802aa0:	be 00 00 00 00       	mov    $0x0,%esi
  802aa5:	bf 06 00 00 00       	mov    $0x6,%edi
  802aaa:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  802ab1:	00 00 00 
  802ab4:	ff d0                	callq  *%rax
}
  802ab6:	c9                   	leaveq 
  802ab7:	c3                   	retq   

0000000000802ab8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802ab8:	55                   	push   %rbp
  802ab9:	48 89 e5             	mov    %rsp,%rbp
  802abc:	48 83 ec 30          	sub    $0x30,%rsp
  802ac0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ac4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ac8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802acc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802ad3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ad8:	74 07                	je     802ae1 <devfile_read+0x29>
  802ada:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802adf:	75 07                	jne    802ae8 <devfile_read+0x30>
		return -E_INVAL;
  802ae1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ae6:	eb 77                	jmp    802b5f <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ae8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aec:	8b 50 0c             	mov    0xc(%rax),%edx
  802aef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802af6:	00 00 00 
  802af9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802afb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b02:	00 00 00 
  802b05:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b09:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802b0d:	be 00 00 00 00       	mov    $0x0,%esi
  802b12:	bf 03 00 00 00       	mov    $0x3,%edi
  802b17:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  802b1e:	00 00 00 
  802b21:	ff d0                	callq  *%rax
  802b23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b2a:	7f 05                	jg     802b31 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802b2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2f:	eb 2e                	jmp    802b5f <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802b31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b34:	48 63 d0             	movslq %eax,%rdx
  802b37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b3b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b42:	00 00 00 
  802b45:	48 89 c7             	mov    %rax,%rdi
  802b48:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802b54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b58:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802b5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802b5f:	c9                   	leaveq 
  802b60:	c3                   	retq   

0000000000802b61 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b61:	55                   	push   %rbp
  802b62:	48 89 e5             	mov    %rsp,%rbp
  802b65:	48 83 ec 30          	sub    $0x30,%rsp
  802b69:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b6d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b71:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802b75:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802b7c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802b81:	74 07                	je     802b8a <devfile_write+0x29>
  802b83:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802b88:	75 08                	jne    802b92 <devfile_write+0x31>
		return r;
  802b8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8d:	e9 9a 00 00 00       	jmpq   802c2c <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802b92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b96:	8b 50 0c             	mov    0xc(%rax),%edx
  802b99:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ba0:	00 00 00 
  802ba3:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802ba5:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802bac:	00 
  802bad:	76 08                	jbe    802bb7 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802baf:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802bb6:	00 
	}
	fsipcbuf.write.req_n = n;
  802bb7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bbe:	00 00 00 
  802bc1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bc5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802bc9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bcd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bd1:	48 89 c6             	mov    %rax,%rsi
  802bd4:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802bdb:	00 00 00 
  802bde:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  802be5:	00 00 00 
  802be8:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802bea:	be 00 00 00 00       	mov    $0x0,%esi
  802bef:	bf 04 00 00 00       	mov    $0x4,%edi
  802bf4:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  802bfb:	00 00 00 
  802bfe:	ff d0                	callq  *%rax
  802c00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c07:	7f 20                	jg     802c29 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802c09:	48 bf 5e 44 80 00 00 	movabs $0x80445e,%rdi
  802c10:	00 00 00 
  802c13:	b8 00 00 00 00       	mov    $0x0,%eax
  802c18:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802c1f:	00 00 00 
  802c22:	ff d2                	callq  *%rdx
		return r;
  802c24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c27:	eb 03                	jmp    802c2c <devfile_write+0xcb>
	}
	return r;
  802c29:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802c2c:	c9                   	leaveq 
  802c2d:	c3                   	retq   

0000000000802c2e <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802c2e:	55                   	push   %rbp
  802c2f:	48 89 e5             	mov    %rsp,%rbp
  802c32:	48 83 ec 20          	sub    $0x20,%rsp
  802c36:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c3a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802c3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c42:	8b 50 0c             	mov    0xc(%rax),%edx
  802c45:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c4c:	00 00 00 
  802c4f:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802c51:	be 00 00 00 00       	mov    $0x0,%esi
  802c56:	bf 05 00 00 00       	mov    $0x5,%edi
  802c5b:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  802c62:	00 00 00 
  802c65:	ff d0                	callq  *%rax
  802c67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6e:	79 05                	jns    802c75 <devfile_stat+0x47>
		return r;
  802c70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c73:	eb 56                	jmp    802ccb <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802c75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c79:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c80:	00 00 00 
  802c83:	48 89 c7             	mov    %rax,%rdi
  802c86:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  802c8d:	00 00 00 
  802c90:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c92:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c99:	00 00 00 
  802c9c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ca2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ca6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802cac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cb3:	00 00 00 
  802cb6:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802cbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cc0:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ccb:	c9                   	leaveq 
  802ccc:	c3                   	retq   

0000000000802ccd <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ccd:	55                   	push   %rbp
  802cce:	48 89 e5             	mov    %rsp,%rbp
  802cd1:	48 83 ec 10          	sub    $0x10,%rsp
  802cd5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cd9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802cdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce0:	8b 50 0c             	mov    0xc(%rax),%edx
  802ce3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cea:	00 00 00 
  802ced:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802cef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cf6:	00 00 00 
  802cf9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802cfc:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802cff:	be 00 00 00 00       	mov    $0x0,%esi
  802d04:	bf 02 00 00 00       	mov    $0x2,%edi
  802d09:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  802d10:	00 00 00 
  802d13:	ff d0                	callq  *%rax
}
  802d15:	c9                   	leaveq 
  802d16:	c3                   	retq   

0000000000802d17 <remove>:

// Delete a file
int
remove(const char *path)
{
  802d17:	55                   	push   %rbp
  802d18:	48 89 e5             	mov    %rsp,%rbp
  802d1b:	48 83 ec 10          	sub    $0x10,%rsp
  802d1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802d23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d27:	48 89 c7             	mov    %rax,%rdi
  802d2a:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	callq  *%rax
  802d36:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d3b:	7e 07                	jle    802d44 <remove+0x2d>
		return -E_BAD_PATH;
  802d3d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d42:	eb 33                	jmp    802d77 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d48:	48 89 c6             	mov    %rax,%rsi
  802d4b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d52:	00 00 00 
  802d55:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  802d5c:	00 00 00 
  802d5f:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802d61:	be 00 00 00 00       	mov    $0x0,%esi
  802d66:	bf 07 00 00 00       	mov    $0x7,%edi
  802d6b:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  802d72:	00 00 00 
  802d75:	ff d0                	callq  *%rax
}
  802d77:	c9                   	leaveq 
  802d78:	c3                   	retq   

0000000000802d79 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802d79:	55                   	push   %rbp
  802d7a:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d7d:	be 00 00 00 00       	mov    $0x0,%esi
  802d82:	bf 08 00 00 00       	mov    $0x8,%edi
  802d87:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  802d8e:	00 00 00 
  802d91:	ff d0                	callq  *%rax
}
  802d93:	5d                   	pop    %rbp
  802d94:	c3                   	retq   

0000000000802d95 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802d95:	55                   	push   %rbp
  802d96:	48 89 e5             	mov    %rsp,%rbp
  802d99:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802da0:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802da7:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802dae:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802db5:	be 00 00 00 00       	mov    $0x0,%esi
  802dba:	48 89 c7             	mov    %rax,%rdi
  802dbd:	48 b8 5a 29 80 00 00 	movabs $0x80295a,%rax
  802dc4:	00 00 00 
  802dc7:	ff d0                	callq  *%rax
  802dc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802dcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd0:	79 28                	jns    802dfa <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802dd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd5:	89 c6                	mov    %eax,%esi
  802dd7:	48 bf 7a 44 80 00 00 	movabs $0x80447a,%rdi
  802dde:	00 00 00 
  802de1:	b8 00 00 00 00       	mov    $0x0,%eax
  802de6:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802ded:	00 00 00 
  802df0:	ff d2                	callq  *%rdx
		return fd_src;
  802df2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df5:	e9 74 01 00 00       	jmpq   802f6e <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802dfa:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802e01:	be 01 01 00 00       	mov    $0x101,%esi
  802e06:	48 89 c7             	mov    %rax,%rdi
  802e09:	48 b8 5a 29 80 00 00 	movabs $0x80295a,%rax
  802e10:	00 00 00 
  802e13:	ff d0                	callq  *%rax
  802e15:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802e18:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e1c:	79 39                	jns    802e57 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802e1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e21:	89 c6                	mov    %eax,%esi
  802e23:	48 bf 90 44 80 00 00 	movabs $0x804490,%rdi
  802e2a:	00 00 00 
  802e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e32:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802e39:	00 00 00 
  802e3c:	ff d2                	callq  *%rdx
		close(fd_src);
  802e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e41:	89 c7                	mov    %eax,%edi
  802e43:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802e4a:	00 00 00 
  802e4d:	ff d0                	callq  *%rax
		return fd_dest;
  802e4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e52:	e9 17 01 00 00       	jmpq   802f6e <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e57:	eb 74                	jmp    802ecd <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802e59:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e5c:	48 63 d0             	movslq %eax,%rdx
  802e5f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e66:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e69:	48 89 ce             	mov    %rcx,%rsi
  802e6c:	89 c7                	mov    %eax,%edi
  802e6e:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802e75:	00 00 00 
  802e78:	ff d0                	callq  *%rax
  802e7a:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802e7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802e81:	79 4a                	jns    802ecd <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802e83:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e86:	89 c6                	mov    %eax,%esi
  802e88:	48 bf aa 44 80 00 00 	movabs $0x8044aa,%rdi
  802e8f:	00 00 00 
  802e92:	b8 00 00 00 00       	mov    $0x0,%eax
  802e97:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802e9e:	00 00 00 
  802ea1:	ff d2                	callq  *%rdx
			close(fd_src);
  802ea3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea6:	89 c7                	mov    %eax,%edi
  802ea8:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802eaf:	00 00 00 
  802eb2:	ff d0                	callq  *%rax
			close(fd_dest);
  802eb4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eb7:	89 c7                	mov    %eax,%edi
  802eb9:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802ec0:	00 00 00 
  802ec3:	ff d0                	callq  *%rax
			return write_size;
  802ec5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ec8:	e9 a1 00 00 00       	jmpq   802f6e <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ecd:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ed4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed7:	ba 00 02 00 00       	mov    $0x200,%edx
  802edc:	48 89 ce             	mov    %rcx,%rsi
  802edf:	89 c7                	mov    %eax,%edi
  802ee1:	48 b8 b7 24 80 00 00 	movabs $0x8024b7,%rax
  802ee8:	00 00 00 
  802eeb:	ff d0                	callq  *%rax
  802eed:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ef0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ef4:	0f 8f 5f ff ff ff    	jg     802e59 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802efa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802efe:	79 47                	jns    802f47 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802f00:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f03:	89 c6                	mov    %eax,%esi
  802f05:	48 bf bd 44 80 00 00 	movabs $0x8044bd,%rdi
  802f0c:	00 00 00 
  802f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f14:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802f1b:	00 00 00 
  802f1e:	ff d2                	callq  *%rdx
		close(fd_src);
  802f20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f23:	89 c7                	mov    %eax,%edi
  802f25:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802f2c:	00 00 00 
  802f2f:	ff d0                	callq  *%rax
		close(fd_dest);
  802f31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f34:	89 c7                	mov    %eax,%edi
  802f36:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	callq  *%rax
		return read_size;
  802f42:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f45:	eb 27                	jmp    802f6e <copy+0x1d9>
	}
	close(fd_src);
  802f47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4a:	89 c7                	mov    %eax,%edi
  802f4c:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802f53:	00 00 00 
  802f56:	ff d0                	callq  *%rax
	close(fd_dest);
  802f58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f5b:	89 c7                	mov    %eax,%edi
  802f5d:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	callq  *%rax
	return 0;
  802f69:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802f6e:	c9                   	leaveq 
  802f6f:	c3                   	retq   

0000000000802f70 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802f70:	55                   	push   %rbp
  802f71:	48 89 e5             	mov    %rsp,%rbp
  802f74:	48 83 ec 20          	sub    $0x20,%rsp
  802f78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f80:	8b 40 0c             	mov    0xc(%rax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	7e 67                	jle    802fee <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802f87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8b:	8b 40 04             	mov    0x4(%rax),%eax
  802f8e:	48 63 d0             	movslq %eax,%rdx
  802f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f95:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802f99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f9d:	8b 00                	mov    (%rax),%eax
  802f9f:	48 89 ce             	mov    %rcx,%rsi
  802fa2:	89 c7                	mov    %eax,%edi
  802fa4:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802fab:	00 00 00 
  802fae:	ff d0                	callq  *%rax
  802fb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802fb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb7:	7e 13                	jle    802fcc <writebuf+0x5c>
			b->result += result;
  802fb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fbd:	8b 50 08             	mov    0x8(%rax),%edx
  802fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc3:	01 c2                	add    %eax,%edx
  802fc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc9:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802fcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd0:	8b 40 04             	mov    0x4(%rax),%eax
  802fd3:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802fd6:	74 16                	je     802fee <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe1:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802fe5:	89 c2                	mov    %eax,%edx
  802fe7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802feb:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802fee:	c9                   	leaveq 
  802fef:	c3                   	retq   

0000000000802ff0 <putch>:

static void
putch(int ch, void *thunk)
{
  802ff0:	55                   	push   %rbp
  802ff1:	48 89 e5             	mov    %rsp,%rbp
  802ff4:	48 83 ec 20          	sub    $0x20,%rsp
  802ff8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ffb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802fff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803003:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  803007:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80300b:	8b 40 04             	mov    0x4(%rax),%eax
  80300e:	8d 48 01             	lea    0x1(%rax),%ecx
  803011:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803015:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803018:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80301b:	89 d1                	mov    %edx,%ecx
  80301d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803021:	48 98                	cltq   
  803023:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803027:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80302b:	8b 40 04             	mov    0x4(%rax),%eax
  80302e:	3d 00 01 00 00       	cmp    $0x100,%eax
  803033:	75 1e                	jne    803053 <putch+0x63>
		writebuf(b);
  803035:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803039:	48 89 c7             	mov    %rax,%rdi
  80303c:	48 b8 70 2f 80 00 00 	movabs $0x802f70,%rax
  803043:	00 00 00 
  803046:	ff d0                	callq  *%rax
		b->idx = 0;
  803048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80304c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  803053:	c9                   	leaveq 
  803054:	c3                   	retq   

0000000000803055 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803055:	55                   	push   %rbp
  803056:	48 89 e5             	mov    %rsp,%rbp
  803059:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  803060:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  803066:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  80306d:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  803074:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  80307a:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  803080:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  803087:	00 00 00 
	b.result = 0;
  80308a:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803091:	00 00 00 
	b.error = 1;
  803094:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  80309b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80309e:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8030a5:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8030ac:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8030b3:	48 89 c6             	mov    %rax,%rsi
  8030b6:	48 bf f0 2f 80 00 00 	movabs $0x802ff0,%rdi
  8030bd:	00 00 00 
  8030c0:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8030cc:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8030d2:	85 c0                	test   %eax,%eax
  8030d4:	7e 16                	jle    8030ec <vfprintf+0x97>
		writebuf(&b);
  8030d6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8030dd:	48 89 c7             	mov    %rax,%rdi
  8030e0:	48 b8 70 2f 80 00 00 	movabs $0x802f70,%rax
  8030e7:	00 00 00 
  8030ea:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8030ec:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8030f2:	85 c0                	test   %eax,%eax
  8030f4:	74 08                	je     8030fe <vfprintf+0xa9>
  8030f6:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8030fc:	eb 06                	jmp    803104 <vfprintf+0xaf>
  8030fe:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803104:	c9                   	leaveq 
  803105:	c3                   	retq   

0000000000803106 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803106:	55                   	push   %rbp
  803107:	48 89 e5             	mov    %rsp,%rbp
  80310a:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803111:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803117:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80311e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803125:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80312c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803133:	84 c0                	test   %al,%al
  803135:	74 20                	je     803157 <fprintf+0x51>
  803137:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80313b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80313f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803143:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803147:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80314b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80314f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803153:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803157:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80315e:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803165:	00 00 00 
  803168:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80316f:	00 00 00 
  803172:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803176:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80317d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803184:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80318b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803192:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  803199:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80319f:	48 89 ce             	mov    %rcx,%rsi
  8031a2:	89 c7                	mov    %eax,%edi
  8031a4:	48 b8 55 30 80 00 00 	movabs $0x803055,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
  8031b0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8031b6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8031bc:	c9                   	leaveq 
  8031bd:	c3                   	retq   

00000000008031be <printf>:

int
printf(const char *fmt, ...)
{
  8031be:	55                   	push   %rbp
  8031bf:	48 89 e5             	mov    %rsp,%rbp
  8031c2:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8031c9:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8031d0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8031d7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8031de:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8031e5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8031ec:	84 c0                	test   %al,%al
  8031ee:	74 20                	je     803210 <printf+0x52>
  8031f0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8031f4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8031f8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8031fc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803200:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803204:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803208:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80320c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803210:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803217:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80321e:	00 00 00 
  803221:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803228:	00 00 00 
  80322b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80322f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803236:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80323d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803244:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80324b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803252:	48 89 c6             	mov    %rax,%rsi
  803255:	bf 01 00 00 00       	mov    $0x1,%edi
  80325a:	48 b8 55 30 80 00 00 	movabs $0x803055,%rax
  803261:	00 00 00 
  803264:	ff d0                	callq  *%rax
  803266:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80326c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803272:	c9                   	leaveq 
  803273:	c3                   	retq   

0000000000803274 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803274:	55                   	push   %rbp
  803275:	48 89 e5             	mov    %rsp,%rbp
  803278:	53                   	push   %rbx
  803279:	48 83 ec 38          	sub    $0x38,%rsp
  80327d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803281:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803285:	48 89 c7             	mov    %rax,%rdi
  803288:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  80328f:	00 00 00 
  803292:	ff d0                	callq  *%rax
  803294:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803297:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80329b:	0f 88 bf 01 00 00    	js     803460 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a5:	ba 07 04 00 00       	mov    $0x407,%edx
  8032aa:	48 89 c6             	mov    %rax,%rsi
  8032ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b2:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
  8032be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c5:	0f 88 95 01 00 00    	js     803460 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032cb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032cf:	48 89 c7             	mov    %rax,%rdi
  8032d2:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  8032d9:	00 00 00 
  8032dc:	ff d0                	callq  *%rax
  8032de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032e5:	0f 88 5d 01 00 00    	js     803448 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ef:	ba 07 04 00 00       	mov    $0x407,%edx
  8032f4:	48 89 c6             	mov    %rax,%rsi
  8032f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8032fc:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803303:	00 00 00 
  803306:	ff d0                	callq  *%rax
  803308:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80330b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80330f:	0f 88 33 01 00 00    	js     803448 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803315:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803319:	48 89 c7             	mov    %rax,%rdi
  80331c:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  803323:	00 00 00 
  803326:	ff d0                	callq  *%rax
  803328:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80332c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803330:	ba 07 04 00 00       	mov    $0x407,%edx
  803335:	48 89 c6             	mov    %rax,%rsi
  803338:	bf 00 00 00 00       	mov    $0x0,%edi
  80333d:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803344:	00 00 00 
  803347:	ff d0                	callq  *%rax
  803349:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80334c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803350:	79 05                	jns    803357 <pipe+0xe3>
		goto err2;
  803352:	e9 d9 00 00 00       	jmpq   803430 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803357:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80335b:	48 89 c7             	mov    %rax,%rdi
  80335e:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  803365:	00 00 00 
  803368:	ff d0                	callq  *%rax
  80336a:	48 89 c2             	mov    %rax,%rdx
  80336d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803371:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803377:	48 89 d1             	mov    %rdx,%rcx
  80337a:	ba 00 00 00 00       	mov    $0x0,%edx
  80337f:	48 89 c6             	mov    %rax,%rsi
  803382:	bf 00 00 00 00       	mov    $0x0,%edi
  803387:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  80338e:	00 00 00 
  803391:	ff d0                	callq  *%rax
  803393:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803396:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80339a:	79 1b                	jns    8033b7 <pipe+0x143>
		goto err3;
  80339c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80339d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a1:	48 89 c6             	mov    %rax,%rsi
  8033a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a9:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  8033b0:	00 00 00 
  8033b3:	ff d0                	callq  *%rax
  8033b5:	eb 79                	jmp    803430 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8033b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033bb:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8033c2:	00 00 00 
  8033c5:	8b 12                	mov    (%rdx),%edx
  8033c7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8033c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033cd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8033df:	00 00 00 
  8033e2:	8b 12                	mov    (%rdx),%edx
  8033e4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ea:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f5:	48 89 c7             	mov    %rax,%rdi
  8033f8:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  8033ff:	00 00 00 
  803402:	ff d0                	callq  *%rax
  803404:	89 c2                	mov    %eax,%edx
  803406:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80340a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80340c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803410:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803414:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803418:	48 89 c7             	mov    %rax,%rdi
  80341b:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  803422:	00 00 00 
  803425:	ff d0                	callq  *%rax
  803427:	89 03                	mov    %eax,(%rbx)
	return 0;
  803429:	b8 00 00 00 00       	mov    $0x0,%eax
  80342e:	eb 33                	jmp    803463 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803430:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803434:	48 89 c6             	mov    %rax,%rsi
  803437:	bf 00 00 00 00       	mov    $0x0,%edi
  80343c:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  803443:	00 00 00 
  803446:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80344c:	48 89 c6             	mov    %rax,%rsi
  80344f:	bf 00 00 00 00       	mov    $0x0,%edi
  803454:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax
err:
	return r;
  803460:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803463:	48 83 c4 38          	add    $0x38,%rsp
  803467:	5b                   	pop    %rbx
  803468:	5d                   	pop    %rbp
  803469:	c3                   	retq   

000000000080346a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80346a:	55                   	push   %rbp
  80346b:	48 89 e5             	mov    %rsp,%rbp
  80346e:	53                   	push   %rbx
  80346f:	48 83 ec 28          	sub    $0x28,%rsp
  803473:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803477:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80347b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803482:	00 00 00 
  803485:	48 8b 00             	mov    (%rax),%rax
  803488:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80348e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803491:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803495:	48 89 c7             	mov    %rax,%rdi
  803498:	48 b8 fc 3d 80 00 00 	movabs $0x803dfc,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
  8034a4:	89 c3                	mov    %eax,%ebx
  8034a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034aa:	48 89 c7             	mov    %rax,%rdi
  8034ad:	48 b8 fc 3d 80 00 00 	movabs $0x803dfc,%rax
  8034b4:	00 00 00 
  8034b7:	ff d0                	callq  *%rax
  8034b9:	39 c3                	cmp    %eax,%ebx
  8034bb:	0f 94 c0             	sete   %al
  8034be:	0f b6 c0             	movzbl %al,%eax
  8034c1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034c4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034cb:	00 00 00 
  8034ce:	48 8b 00             	mov    (%rax),%rax
  8034d1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034d7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034dd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034e0:	75 05                	jne    8034e7 <_pipeisclosed+0x7d>
			return ret;
  8034e2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034e5:	eb 4f                	jmp    803536 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8034e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ea:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034ed:	74 42                	je     803531 <_pipeisclosed+0xc7>
  8034ef:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034f3:	75 3c                	jne    803531 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034f5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034fc:	00 00 00 
  8034ff:	48 8b 00             	mov    (%rax),%rax
  803502:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803508:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80350b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80350e:	89 c6                	mov    %eax,%esi
  803510:	48 bf dd 44 80 00 00 	movabs $0x8044dd,%rdi
  803517:	00 00 00 
  80351a:	b8 00 00 00 00       	mov    $0x0,%eax
  80351f:	49 b8 88 03 80 00 00 	movabs $0x800388,%r8
  803526:	00 00 00 
  803529:	41 ff d0             	callq  *%r8
	}
  80352c:	e9 4a ff ff ff       	jmpq   80347b <_pipeisclosed+0x11>
  803531:	e9 45 ff ff ff       	jmpq   80347b <_pipeisclosed+0x11>
}
  803536:	48 83 c4 28          	add    $0x28,%rsp
  80353a:	5b                   	pop    %rbx
  80353b:	5d                   	pop    %rbp
  80353c:	c3                   	retq   

000000000080353d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80353d:	55                   	push   %rbp
  80353e:	48 89 e5             	mov    %rsp,%rbp
  803541:	48 83 ec 30          	sub    $0x30,%rsp
  803545:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803548:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80354c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80354f:	48 89 d6             	mov    %rdx,%rsi
  803552:	89 c7                	mov    %eax,%edi
  803554:	48 b8 85 20 80 00 00 	movabs $0x802085,%rax
  80355b:	00 00 00 
  80355e:	ff d0                	callq  *%rax
  803560:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803563:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803567:	79 05                	jns    80356e <pipeisclosed+0x31>
		return r;
  803569:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356c:	eb 31                	jmp    80359f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80356e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803572:	48 89 c7             	mov    %rax,%rdi
  803575:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  80357c:	00 00 00 
  80357f:	ff d0                	callq  *%rax
  803581:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803589:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80358d:	48 89 d6             	mov    %rdx,%rsi
  803590:	48 89 c7             	mov    %rax,%rdi
  803593:	48 b8 6a 34 80 00 00 	movabs $0x80346a,%rax
  80359a:	00 00 00 
  80359d:	ff d0                	callq  *%rax
}
  80359f:	c9                   	leaveq 
  8035a0:	c3                   	retq   

00000000008035a1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035a1:	55                   	push   %rbp
  8035a2:	48 89 e5             	mov    %rsp,%rbp
  8035a5:	48 83 ec 40          	sub    $0x40,%rsp
  8035a9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035b1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8035b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035b9:	48 89 c7             	mov    %rax,%rdi
  8035bc:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  8035c3:	00 00 00 
  8035c6:	ff d0                	callq  *%rax
  8035c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035d4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035db:	00 
  8035dc:	e9 92 00 00 00       	jmpq   803673 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8035e1:	eb 41                	jmp    803624 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035e3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035e8:	74 09                	je     8035f3 <devpipe_read+0x52>
				return i;
  8035ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ee:	e9 92 00 00 00       	jmpq   803685 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035fb:	48 89 d6             	mov    %rdx,%rsi
  8035fe:	48 89 c7             	mov    %rax,%rdi
  803601:	48 b8 6a 34 80 00 00 	movabs $0x80346a,%rax
  803608:	00 00 00 
  80360b:	ff d0                	callq  *%rax
  80360d:	85 c0                	test   %eax,%eax
  80360f:	74 07                	je     803618 <devpipe_read+0x77>
				return 0;
  803611:	b8 00 00 00 00       	mov    $0x0,%eax
  803616:	eb 6d                	jmp    803685 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803618:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  80361f:	00 00 00 
  803622:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803624:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803628:	8b 10                	mov    (%rax),%edx
  80362a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362e:	8b 40 04             	mov    0x4(%rax),%eax
  803631:	39 c2                	cmp    %eax,%edx
  803633:	74 ae                	je     8035e3 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803635:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803639:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80363d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803641:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803645:	8b 00                	mov    (%rax),%eax
  803647:	99                   	cltd   
  803648:	c1 ea 1b             	shr    $0x1b,%edx
  80364b:	01 d0                	add    %edx,%eax
  80364d:	83 e0 1f             	and    $0x1f,%eax
  803650:	29 d0                	sub    %edx,%eax
  803652:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803656:	48 98                	cltq   
  803658:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80365d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80365f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803663:	8b 00                	mov    (%rax),%eax
  803665:	8d 50 01             	lea    0x1(%rax),%edx
  803668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80366e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803677:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80367b:	0f 82 60 ff ff ff    	jb     8035e1 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803681:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803685:	c9                   	leaveq 
  803686:	c3                   	retq   

0000000000803687 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803687:	55                   	push   %rbp
  803688:	48 89 e5             	mov    %rsp,%rbp
  80368b:	48 83 ec 40          	sub    $0x40,%rsp
  80368f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803693:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803697:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80369b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80369f:	48 89 c7             	mov    %rax,%rdi
  8036a2:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  8036a9:	00 00 00 
  8036ac:	ff d0                	callq  *%rax
  8036ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036ba:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036c1:	00 
  8036c2:	e9 8e 00 00 00       	jmpq   803755 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036c7:	eb 31                	jmp    8036fa <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d1:	48 89 d6             	mov    %rdx,%rsi
  8036d4:	48 89 c7             	mov    %rax,%rdi
  8036d7:	48 b8 6a 34 80 00 00 	movabs $0x80346a,%rax
  8036de:	00 00 00 
  8036e1:	ff d0                	callq  *%rax
  8036e3:	85 c0                	test   %eax,%eax
  8036e5:	74 07                	je     8036ee <devpipe_write+0x67>
				return 0;
  8036e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ec:	eb 79                	jmp    803767 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036ee:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  8036f5:	00 00 00 
  8036f8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036fe:	8b 40 04             	mov    0x4(%rax),%eax
  803701:	48 63 d0             	movslq %eax,%rdx
  803704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803708:	8b 00                	mov    (%rax),%eax
  80370a:	48 98                	cltq   
  80370c:	48 83 c0 20          	add    $0x20,%rax
  803710:	48 39 c2             	cmp    %rax,%rdx
  803713:	73 b4                	jae    8036c9 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803719:	8b 40 04             	mov    0x4(%rax),%eax
  80371c:	99                   	cltd   
  80371d:	c1 ea 1b             	shr    $0x1b,%edx
  803720:	01 d0                	add    %edx,%eax
  803722:	83 e0 1f             	and    $0x1f,%eax
  803725:	29 d0                	sub    %edx,%eax
  803727:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80372b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80372f:	48 01 ca             	add    %rcx,%rdx
  803732:	0f b6 0a             	movzbl (%rdx),%ecx
  803735:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803739:	48 98                	cltq   
  80373b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80373f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803743:	8b 40 04             	mov    0x4(%rax),%eax
  803746:	8d 50 01             	lea    0x1(%rax),%edx
  803749:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803750:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803759:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80375d:	0f 82 64 ff ff ff    	jb     8036c7 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803767:	c9                   	leaveq 
  803768:	c3                   	retq   

0000000000803769 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803769:	55                   	push   %rbp
  80376a:	48 89 e5             	mov    %rsp,%rbp
  80376d:	48 83 ec 20          	sub    $0x20,%rsp
  803771:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803775:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803779:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80377d:	48 89 c7             	mov    %rax,%rdi
  803780:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  803787:	00 00 00 
  80378a:	ff d0                	callq  *%rax
  80378c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803790:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803794:	48 be f0 44 80 00 00 	movabs $0x8044f0,%rsi
  80379b:	00 00 00 
  80379e:	48 89 c7             	mov    %rax,%rdi
  8037a1:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  8037a8:	00 00 00 
  8037ab:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8037ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b1:	8b 50 04             	mov    0x4(%rax),%edx
  8037b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b8:	8b 00                	mov    (%rax),%eax
  8037ba:	29 c2                	sub    %eax,%edx
  8037bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ca:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037d1:	00 00 00 
	stat->st_dev = &devpipe;
  8037d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037d8:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8037df:	00 00 00 
  8037e2:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8037e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037ee:	c9                   	leaveq 
  8037ef:	c3                   	retq   

00000000008037f0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037f0:	55                   	push   %rbp
  8037f1:	48 89 e5             	mov    %rsp,%rbp
  8037f4:	48 83 ec 10          	sub    $0x10,%rsp
  8037f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803800:	48 89 c6             	mov    %rax,%rsi
  803803:	bf 00 00 00 00       	mov    $0x0,%edi
  803808:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  80380f:	00 00 00 
  803812:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803814:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803818:	48 89 c7             	mov    %rax,%rdi
  80381b:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  803822:	00 00 00 
  803825:	ff d0                	callq  *%rax
  803827:	48 89 c6             	mov    %rax,%rsi
  80382a:	bf 00 00 00 00       	mov    $0x0,%edi
  80382f:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
}
  80383b:	c9                   	leaveq 
  80383c:	c3                   	retq   

000000000080383d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80383d:	55                   	push   %rbp
  80383e:	48 89 e5             	mov    %rsp,%rbp
  803841:	48 83 ec 20          	sub    $0x20,%rsp
  803845:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803848:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80384b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80384e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803852:	be 01 00 00 00       	mov    $0x1,%esi
  803857:	48 89 c7             	mov    %rax,%rdi
  80385a:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  803861:	00 00 00 
  803864:	ff d0                	callq  *%rax
}
  803866:	c9                   	leaveq 
  803867:	c3                   	retq   

0000000000803868 <getchar>:

int
getchar(void)
{
  803868:	55                   	push   %rbp
  803869:	48 89 e5             	mov    %rsp,%rbp
  80386c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803870:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803874:	ba 01 00 00 00       	mov    $0x1,%edx
  803879:	48 89 c6             	mov    %rax,%rsi
  80387c:	bf 00 00 00 00       	mov    $0x0,%edi
  803881:	48 b8 b7 24 80 00 00 	movabs $0x8024b7,%rax
  803888:	00 00 00 
  80388b:	ff d0                	callq  *%rax
  80388d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803890:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803894:	79 05                	jns    80389b <getchar+0x33>
		return r;
  803896:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803899:	eb 14                	jmp    8038af <getchar+0x47>
	if (r < 1)
  80389b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80389f:	7f 07                	jg     8038a8 <getchar+0x40>
		return -E_EOF;
  8038a1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038a6:	eb 07                	jmp    8038af <getchar+0x47>
	return c;
  8038a8:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038ac:	0f b6 c0             	movzbl %al,%eax
}
  8038af:	c9                   	leaveq 
  8038b0:	c3                   	retq   

00000000008038b1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8038b1:	55                   	push   %rbp
  8038b2:	48 89 e5             	mov    %rsp,%rbp
  8038b5:	48 83 ec 20          	sub    $0x20,%rsp
  8038b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038c3:	48 89 d6             	mov    %rdx,%rsi
  8038c6:	89 c7                	mov    %eax,%edi
  8038c8:	48 b8 85 20 80 00 00 	movabs $0x802085,%rax
  8038cf:	00 00 00 
  8038d2:	ff d0                	callq  *%rax
  8038d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038db:	79 05                	jns    8038e2 <iscons+0x31>
		return r;
  8038dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e0:	eb 1a                	jmp    8038fc <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e6:	8b 10                	mov    (%rax),%edx
  8038e8:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8038ef:	00 00 00 
  8038f2:	8b 00                	mov    (%rax),%eax
  8038f4:	39 c2                	cmp    %eax,%edx
  8038f6:	0f 94 c0             	sete   %al
  8038f9:	0f b6 c0             	movzbl %al,%eax
}
  8038fc:	c9                   	leaveq 
  8038fd:	c3                   	retq   

00000000008038fe <opencons>:

int
opencons(void)
{
  8038fe:	55                   	push   %rbp
  8038ff:	48 89 e5             	mov    %rsp,%rbp
  803902:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803906:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80390a:	48 89 c7             	mov    %rax,%rdi
  80390d:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  803914:	00 00 00 
  803917:	ff d0                	callq  *%rax
  803919:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80391c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803920:	79 05                	jns    803927 <opencons+0x29>
		return r;
  803922:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803925:	eb 5b                	jmp    803982 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803927:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392b:	ba 07 04 00 00       	mov    $0x407,%edx
  803930:	48 89 c6             	mov    %rax,%rsi
  803933:	bf 00 00 00 00       	mov    $0x0,%edi
  803938:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  80393f:	00 00 00 
  803942:	ff d0                	callq  *%rax
  803944:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803947:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80394b:	79 05                	jns    803952 <opencons+0x54>
		return r;
  80394d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803950:	eb 30                	jmp    803982 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803952:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803956:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80395d:	00 00 00 
  803960:	8b 12                	mov    (%rdx),%edx
  803962:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803964:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803968:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80396f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803973:	48 89 c7             	mov    %rax,%rdi
  803976:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  80397d:	00 00 00 
  803980:	ff d0                	callq  *%rax
}
  803982:	c9                   	leaveq 
  803983:	c3                   	retq   

0000000000803984 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803984:	55                   	push   %rbp
  803985:	48 89 e5             	mov    %rsp,%rbp
  803988:	48 83 ec 30          	sub    $0x30,%rsp
  80398c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803990:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803994:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803998:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80399d:	75 07                	jne    8039a6 <devcons_read+0x22>
		return 0;
  80399f:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a4:	eb 4b                	jmp    8039f1 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8039a6:	eb 0c                	jmp    8039b4 <devcons_read+0x30>
		sys_yield();
  8039a8:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  8039af:	00 00 00 
  8039b2:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039b4:	48 b8 6e 17 80 00 00 	movabs $0x80176e,%rax
  8039bb:	00 00 00 
  8039be:	ff d0                	callq  *%rax
  8039c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039c7:	74 df                	je     8039a8 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8039c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039cd:	79 05                	jns    8039d4 <devcons_read+0x50>
		return c;
  8039cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d2:	eb 1d                	jmp    8039f1 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8039d4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8039d8:	75 07                	jne    8039e1 <devcons_read+0x5d>
		return 0;
  8039da:	b8 00 00 00 00       	mov    $0x0,%eax
  8039df:	eb 10                	jmp    8039f1 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8039e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e4:	89 c2                	mov    %eax,%edx
  8039e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ea:	88 10                	mov    %dl,(%rax)
	return 1;
  8039ec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039f1:	c9                   	leaveq 
  8039f2:	c3                   	retq   

00000000008039f3 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039f3:	55                   	push   %rbp
  8039f4:	48 89 e5             	mov    %rsp,%rbp
  8039f7:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8039fe:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a05:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a0c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a1a:	eb 76                	jmp    803a92 <devcons_write+0x9f>
		m = n - tot;
  803a1c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a23:	89 c2                	mov    %eax,%edx
  803a25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a28:	29 c2                	sub    %eax,%edx
  803a2a:	89 d0                	mov    %edx,%eax
  803a2c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a32:	83 f8 7f             	cmp    $0x7f,%eax
  803a35:	76 07                	jbe    803a3e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a37:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a41:	48 63 d0             	movslq %eax,%rdx
  803a44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a47:	48 63 c8             	movslq %eax,%rcx
  803a4a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a51:	48 01 c1             	add    %rax,%rcx
  803a54:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a5b:	48 89 ce             	mov    %rcx,%rsi
  803a5e:	48 89 c7             	mov    %rax,%rdi
  803a61:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  803a68:	00 00 00 
  803a6b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a6d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a70:	48 63 d0             	movslq %eax,%rdx
  803a73:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a7a:	48 89 d6             	mov    %rdx,%rsi
  803a7d:	48 89 c7             	mov    %rax,%rdi
  803a80:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  803a87:	00 00 00 
  803a8a:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a8f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a95:	48 98                	cltq   
  803a97:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a9e:	0f 82 78 ff ff ff    	jb     803a1c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803aa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803aa7:	c9                   	leaveq 
  803aa8:	c3                   	retq   

0000000000803aa9 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803aa9:	55                   	push   %rbp
  803aaa:	48 89 e5             	mov    %rsp,%rbp
  803aad:	48 83 ec 08          	sub    $0x8,%rsp
  803ab1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ab5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803aba:	c9                   	leaveq 
  803abb:	c3                   	retq   

0000000000803abc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803abc:	55                   	push   %rbp
  803abd:	48 89 e5             	mov    %rsp,%rbp
  803ac0:	48 83 ec 10          	sub    $0x10,%rsp
  803ac4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ac8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803acc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad0:	48 be fc 44 80 00 00 	movabs $0x8044fc,%rsi
  803ad7:	00 00 00 
  803ada:	48 89 c7             	mov    %rax,%rdi
  803add:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  803ae4:	00 00 00 
  803ae7:	ff d0                	callq  *%rax
	return 0;
  803ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803aee:	c9                   	leaveq 
  803aef:	c3                   	retq   

0000000000803af0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803af0:	55                   	push   %rbp
  803af1:	48 89 e5             	mov    %rsp,%rbp
  803af4:	53                   	push   %rbx
  803af5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803afc:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803b03:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803b09:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803b10:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803b17:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803b1e:	84 c0                	test   %al,%al
  803b20:	74 23                	je     803b45 <_panic+0x55>
  803b22:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803b29:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803b2d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803b31:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803b35:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803b39:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803b3d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803b41:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803b45:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b4c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803b53:	00 00 00 
  803b56:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803b5d:	00 00 00 
  803b60:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b64:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803b6b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803b72:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803b79:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803b80:	00 00 00 
  803b83:	48 8b 18             	mov    (%rax),%rbx
  803b86:	48 b8 f0 17 80 00 00 	movabs $0x8017f0,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
  803b92:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803b98:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803b9f:	41 89 c8             	mov    %ecx,%r8d
  803ba2:	48 89 d1             	mov    %rdx,%rcx
  803ba5:	48 89 da             	mov    %rbx,%rdx
  803ba8:	89 c6                	mov    %eax,%esi
  803baa:	48 bf 08 45 80 00 00 	movabs $0x804508,%rdi
  803bb1:	00 00 00 
  803bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb9:	49 b9 88 03 80 00 00 	movabs $0x800388,%r9
  803bc0:	00 00 00 
  803bc3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803bc6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803bcd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803bd4:	48 89 d6             	mov    %rdx,%rsi
  803bd7:	48 89 c7             	mov    %rax,%rdi
  803bda:	48 b8 dc 02 80 00 00 	movabs $0x8002dc,%rax
  803be1:	00 00 00 
  803be4:	ff d0                	callq  *%rax
	cprintf("\n");
  803be6:	48 bf 2b 45 80 00 00 	movabs $0x80452b,%rdi
  803bed:	00 00 00 
  803bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf5:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  803bfc:	00 00 00 
  803bff:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803c01:	cc                   	int3   
  803c02:	eb fd                	jmp    803c01 <_panic+0x111>

0000000000803c04 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c04:	55                   	push   %rbp
  803c05:	48 89 e5             	mov    %rsp,%rbp
  803c08:	48 83 ec 30          	sub    $0x30,%rsp
  803c0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c14:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803c18:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c1f:	00 00 00 
  803c22:	48 8b 00             	mov    (%rax),%rax
  803c25:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803c2b:	85 c0                	test   %eax,%eax
  803c2d:	75 34                	jne    803c63 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803c2f:	48 b8 f0 17 80 00 00 	movabs $0x8017f0,%rax
  803c36:	00 00 00 
  803c39:	ff d0                	callq  *%rax
  803c3b:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c40:	48 98                	cltq   
  803c42:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803c49:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c50:	00 00 00 
  803c53:	48 01 c2             	add    %rax,%rdx
  803c56:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c5d:	00 00 00 
  803c60:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803c63:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c68:	75 0e                	jne    803c78 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803c6a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c71:	00 00 00 
  803c74:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803c78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c7c:	48 89 c7             	mov    %rax,%rdi
  803c7f:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  803c86:	00 00 00 
  803c89:	ff d0                	callq  *%rax
  803c8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803c8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c92:	79 19                	jns    803cad <ipc_recv+0xa9>
		*from_env_store = 0;
  803c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c98:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803c9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ca2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803ca8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cab:	eb 53                	jmp    803d00 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803cad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803cb2:	74 19                	je     803ccd <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803cb4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cbb:	00 00 00 
  803cbe:	48 8b 00             	mov    (%rax),%rax
  803cc1:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803cc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ccb:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803ccd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cd2:	74 19                	je     803ced <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803cd4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cdb:	00 00 00 
  803cde:	48 8b 00             	mov    (%rax),%rax
  803ce1:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ce7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ceb:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803ced:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cf4:	00 00 00 
  803cf7:	48 8b 00             	mov    (%rax),%rax
  803cfa:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803d00:	c9                   	leaveq 
  803d01:	c3                   	retq   

0000000000803d02 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d02:	55                   	push   %rbp
  803d03:	48 89 e5             	mov    %rsp,%rbp
  803d06:	48 83 ec 30          	sub    $0x30,%rsp
  803d0a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d0d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d10:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803d14:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803d17:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d1c:	75 0e                	jne    803d2c <ipc_send+0x2a>
		pg = (void*)UTOP;
  803d1e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d25:	00 00 00 
  803d28:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803d2c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d2f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d32:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d36:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d39:	89 c7                	mov    %eax,%edi
  803d3b:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  803d42:	00 00 00 
  803d45:	ff d0                	callq  *%rax
  803d47:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803d4a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d4e:	75 0c                	jne    803d5c <ipc_send+0x5a>
			sys_yield();
  803d50:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  803d57:	00 00 00 
  803d5a:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803d5c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d60:	74 ca                	je     803d2c <ipc_send+0x2a>
	if(result != 0)
  803d62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d66:	74 20                	je     803d88 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803d68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6b:	89 c6                	mov    %eax,%esi
  803d6d:	48 bf 2d 45 80 00 00 	movabs $0x80452d,%rdi
  803d74:	00 00 00 
  803d77:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7c:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  803d83:	00 00 00 
  803d86:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803d88:	c9                   	leaveq 
  803d89:	c3                   	retq   

0000000000803d8a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d8a:	55                   	push   %rbp
  803d8b:	48 89 e5             	mov    %rsp,%rbp
  803d8e:	48 83 ec 14          	sub    $0x14,%rsp
  803d92:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803d95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d9c:	eb 4e                	jmp    803dec <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803d9e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803da5:	00 00 00 
  803da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dab:	48 98                	cltq   
  803dad:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803db4:	48 01 d0             	add    %rdx,%rax
  803db7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803dbd:	8b 00                	mov    (%rax),%eax
  803dbf:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803dc2:	75 24                	jne    803de8 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803dc4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803dcb:	00 00 00 
  803dce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd1:	48 98                	cltq   
  803dd3:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803dda:	48 01 d0             	add    %rdx,%rax
  803ddd:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803de3:	8b 40 08             	mov    0x8(%rax),%eax
  803de6:	eb 12                	jmp    803dfa <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803de8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803dec:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803df3:	7e a9                	jle    803d9e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dfa:	c9                   	leaveq 
  803dfb:	c3                   	retq   

0000000000803dfc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803dfc:	55                   	push   %rbp
  803dfd:	48 89 e5             	mov    %rsp,%rbp
  803e00:	48 83 ec 18          	sub    $0x18,%rsp
  803e04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e0c:	48 c1 e8 15          	shr    $0x15,%rax
  803e10:	48 89 c2             	mov    %rax,%rdx
  803e13:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e1a:	01 00 00 
  803e1d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e21:	83 e0 01             	and    $0x1,%eax
  803e24:	48 85 c0             	test   %rax,%rax
  803e27:	75 07                	jne    803e30 <pageref+0x34>
		return 0;
  803e29:	b8 00 00 00 00       	mov    $0x0,%eax
  803e2e:	eb 53                	jmp    803e83 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e34:	48 c1 e8 0c          	shr    $0xc,%rax
  803e38:	48 89 c2             	mov    %rax,%rdx
  803e3b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e42:	01 00 00 
  803e45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e49:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e51:	83 e0 01             	and    $0x1,%eax
  803e54:	48 85 c0             	test   %rax,%rax
  803e57:	75 07                	jne    803e60 <pageref+0x64>
		return 0;
  803e59:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5e:	eb 23                	jmp    803e83 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e64:	48 c1 e8 0c          	shr    $0xc,%rax
  803e68:	48 89 c2             	mov    %rax,%rdx
  803e6b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e72:	00 00 00 
  803e75:	48 c1 e2 04          	shl    $0x4,%rdx
  803e79:	48 01 d0             	add    %rdx,%rax
  803e7c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e80:	0f b7 c0             	movzwl %ax,%eax
}
  803e83:	c9                   	leaveq 
  803e84:	c3                   	retq   
