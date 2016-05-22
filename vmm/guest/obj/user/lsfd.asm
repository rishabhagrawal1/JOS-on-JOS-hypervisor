
vmm/guest/obj/user/lsfd:     file format elf64-x86-64


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
  800047:	48 bf e0 40 80 00 00 	movabs $0x8040e0,%rdi
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
  8000aa:	48 b8 bc 1b 80 00 00 	movabs $0x801bbc,%rax
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
  8000dd:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
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
  80010d:	48 b8 b5 26 80 00 00 	movabs $0x8026b5,%rax
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
  80014e:	48 be f8 40 80 00 00 	movabs $0x8040f8,%rsi
  800155:	00 00 00 
  800158:	bf 01 00 00 00       	mov    $0x1,%edi
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	49 ba 08 30 80 00 00 	movabs $0x803008,%r10
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
  800191:	48 bf f8 40 80 00 00 	movabs $0x8040f8,%rdi
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
  800244:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
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
  8004f4:	48 ba 30 43 80 00 00 	movabs $0x804330,%rdx
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
  8007ec:	48 b8 58 43 80 00 00 	movabs $0x804358,%rax
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
  80093f:	48 b8 80 42 80 00 00 	movabs $0x804280,%rax
  800946:	00 00 00 
  800949:	48 63 d3             	movslq %ebx,%rdx
  80094c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800950:	4d 85 e4             	test   %r12,%r12
  800953:	75 2e                	jne    800983 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800955:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800959:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80095d:	89 d9                	mov    %ebx,%ecx
  80095f:	48 ba 41 43 80 00 00 	movabs $0x804341,%rdx
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
  80098e:	48 ba 4a 43 80 00 00 	movabs $0x80434a,%rdx
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
  8009e8:	49 bc 4d 43 80 00 00 	movabs $0x80434d,%r12
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
  8016ee:	48 ba 08 46 80 00 00 	movabs $0x804608,%rdx
  8016f5:	00 00 00 
  8016f8:	be 23 00 00 00       	mov    $0x23,%esi
  8016fd:	48 bf 25 46 80 00 00 	movabs $0x804625,%rdi
  801704:	00 00 00 
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
  80170c:	49 b9 f2 39 80 00 00 	movabs $0x8039f2,%r9
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

0000000000801bbc <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801bbc:	55                   	push   %rbp
  801bbd:	48 89 e5             	mov    %rsp,%rbp
  801bc0:	48 83 ec 18          	sub    $0x18,%rsp
  801bc4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bc8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bcc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bd8:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801be7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801beb:	8b 00                	mov    (%rax),%eax
  801bed:	83 f8 01             	cmp    $0x1,%eax
  801bf0:	7e 13                	jle    801c05 <argstart+0x49>
  801bf2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801bf7:	74 0c                	je     801c05 <argstart+0x49>
  801bf9:	48 b8 33 46 80 00 00 	movabs $0x804633,%rax
  801c00:	00 00 00 
  801c03:	eb 05                	jmp    801c0a <argstart+0x4e>
  801c05:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c0e:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c16:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801c1d:	00 
}
  801c1e:	c9                   	leaveq 
  801c1f:	c3                   	retq   

0000000000801c20 <argnext>:

int
argnext(struct Argstate *args)
{
  801c20:	55                   	push   %rbp
  801c21:	48 89 e5             	mov    %rsp,%rbp
  801c24:	48 83 ec 20          	sub    $0x20,%rsp
  801c28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c30:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801c37:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801c38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c3c:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c40:	48 85 c0             	test   %rax,%rax
  801c43:	75 0a                	jne    801c4f <argnext+0x2f>
		return -1;
  801c45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c4a:	e9 25 01 00 00       	jmpq   801d74 <argnext+0x154>

	if (!*args->curarg) {
  801c4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c53:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c57:	0f b6 00             	movzbl (%rax),%eax
  801c5a:	84 c0                	test   %al,%al
  801c5c:	0f 85 d7 00 00 00    	jne    801d39 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801c62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c66:	48 8b 00             	mov    (%rax),%rax
  801c69:	8b 00                	mov    (%rax),%eax
  801c6b:	83 f8 01             	cmp    $0x1,%eax
  801c6e:	0f 84 ef 00 00 00    	je     801d63 <argnext+0x143>
		    || args->argv[1][0] != '-'
  801c74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c78:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c7c:	48 83 c0 08          	add    $0x8,%rax
  801c80:	48 8b 00             	mov    (%rax),%rax
  801c83:	0f b6 00             	movzbl (%rax),%eax
  801c86:	3c 2d                	cmp    $0x2d,%al
  801c88:	0f 85 d5 00 00 00    	jne    801d63 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  801c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c92:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c96:	48 83 c0 08          	add    $0x8,%rax
  801c9a:	48 8b 00             	mov    (%rax),%rax
  801c9d:	48 83 c0 01          	add    $0x1,%rax
  801ca1:	0f b6 00             	movzbl (%rax),%eax
  801ca4:	84 c0                	test   %al,%al
  801ca6:	0f 84 b7 00 00 00    	je     801d63 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801cac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cb0:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cb4:	48 83 c0 08          	add    $0x8,%rax
  801cb8:	48 8b 00             	mov    (%rax),%rax
  801cbb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801cbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc3:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801cc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ccb:	48 8b 00             	mov    (%rax),%rax
  801cce:	8b 00                	mov    (%rax),%eax
  801cd0:	83 e8 01             	sub    $0x1,%eax
  801cd3:	48 98                	cltq   
  801cd5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801cdc:	00 
  801cdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce1:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ce5:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801ce9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ced:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cf1:	48 83 c0 08          	add    $0x8,%rax
  801cf5:	48 89 ce             	mov    %rcx,%rsi
  801cf8:	48 89 c7             	mov    %rax,%rdi
  801cfb:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  801d02:	00 00 00 
  801d05:	ff d0                	callq  *%rax
		(*args->argc)--;
  801d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d0b:	48 8b 00             	mov    (%rax),%rax
  801d0e:	8b 10                	mov    (%rax),%edx
  801d10:	83 ea 01             	sub    $0x1,%edx
  801d13:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801d15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d19:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d1d:	0f b6 00             	movzbl (%rax),%eax
  801d20:	3c 2d                	cmp    $0x2d,%al
  801d22:	75 15                	jne    801d39 <argnext+0x119>
  801d24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d28:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d2c:	48 83 c0 01          	add    $0x1,%rax
  801d30:	0f b6 00             	movzbl (%rax),%eax
  801d33:	84 c0                	test   %al,%al
  801d35:	75 02                	jne    801d39 <argnext+0x119>
			goto endofargs;
  801d37:	eb 2a                	jmp    801d63 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  801d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3d:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d41:	0f b6 00             	movzbl (%rax),%eax
  801d44:	0f b6 c0             	movzbl %al,%eax
  801d47:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801d4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d4e:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d52:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d5a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801d5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d61:	eb 11                	jmp    801d74 <argnext+0x154>

endofargs:
	args->curarg = 0;
  801d63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d67:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801d6e:	00 
	return -1;
  801d6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801d74:	c9                   	leaveq 
  801d75:	c3                   	retq   

0000000000801d76 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801d76:	55                   	push   %rbp
  801d77:	48 89 e5             	mov    %rsp,%rbp
  801d7a:	48 83 ec 10          	sub    $0x10,%rsp
  801d7e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d86:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d8a:	48 85 c0             	test   %rax,%rax
  801d8d:	74 0a                	je     801d99 <argvalue+0x23>
  801d8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d93:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d97:	eb 13                	jmp    801dac <argvalue+0x36>
  801d99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d9d:	48 89 c7             	mov    %rax,%rdi
  801da0:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  801da7:	00 00 00 
  801daa:	ff d0                	callq  *%rax
}
  801dac:	c9                   	leaveq 
  801dad:	c3                   	retq   

0000000000801dae <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801dae:	55                   	push   %rbp
  801daf:	48 89 e5             	mov    %rsp,%rbp
  801db2:	53                   	push   %rbx
  801db3:	48 83 ec 18          	sub    $0x18,%rsp
  801db7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  801dbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dbf:	48 8b 40 10          	mov    0x10(%rax),%rax
  801dc3:	48 85 c0             	test   %rax,%rax
  801dc6:	75 0a                	jne    801dd2 <argnextvalue+0x24>
		return 0;
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcd:	e9 c8 00 00 00       	jmpq   801e9a <argnextvalue+0xec>
	if (*args->curarg) {
  801dd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd6:	48 8b 40 10          	mov    0x10(%rax),%rax
  801dda:	0f b6 00             	movzbl (%rax),%eax
  801ddd:	84 c0                	test   %al,%al
  801ddf:	74 27                	je     801e08 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  801de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801de9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ded:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801df1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df5:	48 bb 33 46 80 00 00 	movabs $0x804633,%rbx
  801dfc:	00 00 00 
  801dff:	48 89 58 10          	mov    %rbx,0x10(%rax)
  801e03:	e9 8a 00 00 00       	jmpq   801e92 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  801e08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0c:	48 8b 00             	mov    (%rax),%rax
  801e0f:	8b 00                	mov    (%rax),%eax
  801e11:	83 f8 01             	cmp    $0x1,%eax
  801e14:	7e 64                	jle    801e7a <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  801e16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1a:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e1e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e26:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2e:	48 8b 00             	mov    (%rax),%rax
  801e31:	8b 00                	mov    (%rax),%eax
  801e33:	83 e8 01             	sub    $0x1,%eax
  801e36:	48 98                	cltq   
  801e38:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801e3f:	00 
  801e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e44:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e48:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e50:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e54:	48 83 c0 08          	add    $0x8,%rax
  801e58:	48 89 ce             	mov    %rcx,%rsi
  801e5b:	48 89 c7             	mov    %rax,%rdi
  801e5e:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  801e65:	00 00 00 
  801e68:	ff d0                	callq  *%rax
		(*args->argc)--;
  801e6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e6e:	48 8b 00             	mov    (%rax),%rax
  801e71:	8b 10                	mov    (%rax),%edx
  801e73:	83 ea 01             	sub    $0x1,%edx
  801e76:	89 10                	mov    %edx,(%rax)
  801e78:	eb 18                	jmp    801e92 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  801e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e7e:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801e85:	00 
		args->curarg = 0;
  801e86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8a:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801e91:	00 
	}
	return (char*) args->argvalue;
  801e92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e96:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801e9a:	48 83 c4 18          	add    $0x18,%rsp
  801e9e:	5b                   	pop    %rbx
  801e9f:	5d                   	pop    %rbp
  801ea0:	c3                   	retq   

0000000000801ea1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801ea1:	55                   	push   %rbp
  801ea2:	48 89 e5             	mov    %rsp,%rbp
  801ea5:	48 83 ec 08          	sub    $0x8,%rsp
  801ea9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ead:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eb1:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801eb8:	ff ff ff 
  801ebb:	48 01 d0             	add    %rdx,%rax
  801ebe:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ec2:	c9                   	leaveq 
  801ec3:	c3                   	retq   

0000000000801ec4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ec4:	55                   	push   %rbp
  801ec5:	48 89 e5             	mov    %rsp,%rbp
  801ec8:	48 83 ec 08          	sub    $0x8,%rsp
  801ecc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ed0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed4:	48 89 c7             	mov    %rax,%rdi
  801ed7:	48 b8 a1 1e 80 00 00 	movabs $0x801ea1,%rax
  801ede:	00 00 00 
  801ee1:	ff d0                	callq  *%rax
  801ee3:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ee9:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801eed:	c9                   	leaveq 
  801eee:	c3                   	retq   

0000000000801eef <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801eef:	55                   	push   %rbp
  801ef0:	48 89 e5             	mov    %rsp,%rbp
  801ef3:	48 83 ec 18          	sub    $0x18,%rsp
  801ef7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801efb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f02:	eb 6b                	jmp    801f6f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f07:	48 98                	cltq   
  801f09:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f0f:	48 c1 e0 0c          	shl    $0xc,%rax
  801f13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f1b:	48 c1 e8 15          	shr    $0x15,%rax
  801f1f:	48 89 c2             	mov    %rax,%rdx
  801f22:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f29:	01 00 00 
  801f2c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f30:	83 e0 01             	and    $0x1,%eax
  801f33:	48 85 c0             	test   %rax,%rax
  801f36:	74 21                	je     801f59 <fd_alloc+0x6a>
  801f38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f3c:	48 c1 e8 0c          	shr    $0xc,%rax
  801f40:	48 89 c2             	mov    %rax,%rdx
  801f43:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f4a:	01 00 00 
  801f4d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f51:	83 e0 01             	and    $0x1,%eax
  801f54:	48 85 c0             	test   %rax,%rax
  801f57:	75 12                	jne    801f6b <fd_alloc+0x7c>
			*fd_store = fd;
  801f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f61:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f64:	b8 00 00 00 00       	mov    $0x0,%eax
  801f69:	eb 1a                	jmp    801f85 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f6b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f6f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f73:	7e 8f                	jle    801f04 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f79:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f80:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f85:	c9                   	leaveq 
  801f86:	c3                   	retq   

0000000000801f87 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f87:	55                   	push   %rbp
  801f88:	48 89 e5             	mov    %rsp,%rbp
  801f8b:	48 83 ec 20          	sub    $0x20,%rsp
  801f8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f96:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f9a:	78 06                	js     801fa2 <fd_lookup+0x1b>
  801f9c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801fa0:	7e 07                	jle    801fa9 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fa2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fa7:	eb 6c                	jmp    802015 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801fa9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fac:	48 98                	cltq   
  801fae:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fb4:	48 c1 e0 0c          	shl    $0xc,%rax
  801fb8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc0:	48 c1 e8 15          	shr    $0x15,%rax
  801fc4:	48 89 c2             	mov    %rax,%rdx
  801fc7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fce:	01 00 00 
  801fd1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd5:	83 e0 01             	and    $0x1,%eax
  801fd8:	48 85 c0             	test   %rax,%rax
  801fdb:	74 21                	je     801ffe <fd_lookup+0x77>
  801fdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe1:	48 c1 e8 0c          	shr    $0xc,%rax
  801fe5:	48 89 c2             	mov    %rax,%rdx
  801fe8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fef:	01 00 00 
  801ff2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ff6:	83 e0 01             	and    $0x1,%eax
  801ff9:	48 85 c0             	test   %rax,%rax
  801ffc:	75 07                	jne    802005 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ffe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802003:	eb 10                	jmp    802015 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802005:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802009:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80200d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802015:	c9                   	leaveq 
  802016:	c3                   	retq   

0000000000802017 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802017:	55                   	push   %rbp
  802018:	48 89 e5             	mov    %rsp,%rbp
  80201b:	48 83 ec 30          	sub    $0x30,%rsp
  80201f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802023:	89 f0                	mov    %esi,%eax
  802025:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802028:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80202c:	48 89 c7             	mov    %rax,%rdi
  80202f:	48 b8 a1 1e 80 00 00 	movabs $0x801ea1,%rax
  802036:	00 00 00 
  802039:	ff d0                	callq  *%rax
  80203b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80203f:	48 89 d6             	mov    %rdx,%rsi
  802042:	89 c7                	mov    %eax,%edi
  802044:	48 b8 87 1f 80 00 00 	movabs $0x801f87,%rax
  80204b:	00 00 00 
  80204e:	ff d0                	callq  *%rax
  802050:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802053:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802057:	78 0a                	js     802063 <fd_close+0x4c>
	    || fd != fd2)
  802059:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80205d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802061:	74 12                	je     802075 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802063:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802067:	74 05                	je     80206e <fd_close+0x57>
  802069:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206c:	eb 05                	jmp    802073 <fd_close+0x5c>
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
  802073:	eb 69                	jmp    8020de <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802075:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802079:	8b 00                	mov    (%rax),%eax
  80207b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80207f:	48 89 d6             	mov    %rdx,%rsi
  802082:	89 c7                	mov    %eax,%edi
  802084:	48 b8 e0 20 80 00 00 	movabs $0x8020e0,%rax
  80208b:	00 00 00 
  80208e:	ff d0                	callq  *%rax
  802090:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802093:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802097:	78 2a                	js     8020c3 <fd_close+0xac>
		if (dev->dev_close)
  802099:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209d:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020a1:	48 85 c0             	test   %rax,%rax
  8020a4:	74 16                	je     8020bc <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8020a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020aa:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020ae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8020b2:	48 89 d7             	mov    %rdx,%rdi
  8020b5:	ff d0                	callq  *%rax
  8020b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ba:	eb 07                	jmp    8020c3 <fd_close+0xac>
		else
			r = 0;
  8020bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c7:	48 89 c6             	mov    %rax,%rsi
  8020ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8020cf:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  8020d6:	00 00 00 
  8020d9:	ff d0                	callq  *%rax
	return r;
  8020db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020de:	c9                   	leaveq 
  8020df:	c3                   	retq   

00000000008020e0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020e0:	55                   	push   %rbp
  8020e1:	48 89 e5             	mov    %rsp,%rbp
  8020e4:	48 83 ec 20          	sub    $0x20,%rsp
  8020e8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020f6:	eb 41                	jmp    802139 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020f8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020ff:	00 00 00 
  802102:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802105:	48 63 d2             	movslq %edx,%rdx
  802108:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80210c:	8b 00                	mov    (%rax),%eax
  80210e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802111:	75 22                	jne    802135 <dev_lookup+0x55>
			*dev = devtab[i];
  802113:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80211a:	00 00 00 
  80211d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802120:	48 63 d2             	movslq %edx,%rdx
  802123:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802127:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80212b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80212e:	b8 00 00 00 00       	mov    $0x0,%eax
  802133:	eb 60                	jmp    802195 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802135:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802139:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802140:	00 00 00 
  802143:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802146:	48 63 d2             	movslq %edx,%rdx
  802149:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214d:	48 85 c0             	test   %rax,%rax
  802150:	75 a6                	jne    8020f8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802152:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802159:	00 00 00 
  80215c:	48 8b 00             	mov    (%rax),%rax
  80215f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802165:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802168:	89 c6                	mov    %eax,%esi
  80216a:	48 bf 38 46 80 00 00 	movabs $0x804638,%rdi
  802171:	00 00 00 
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
  802179:	48 b9 88 03 80 00 00 	movabs $0x800388,%rcx
  802180:	00 00 00 
  802183:	ff d1                	callq  *%rcx
	*dev = 0;
  802185:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802189:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802190:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802195:	c9                   	leaveq 
  802196:	c3                   	retq   

0000000000802197 <close>:

int
close(int fdnum)
{
  802197:	55                   	push   %rbp
  802198:	48 89 e5             	mov    %rsp,%rbp
  80219b:	48 83 ec 20          	sub    $0x20,%rsp
  80219f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021a2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021a9:	48 89 d6             	mov    %rdx,%rsi
  8021ac:	89 c7                	mov    %eax,%edi
  8021ae:	48 b8 87 1f 80 00 00 	movabs $0x801f87,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	callq  *%rax
  8021ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c1:	79 05                	jns    8021c8 <close+0x31>
		return r;
  8021c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c6:	eb 18                	jmp    8021e0 <close+0x49>
	else
		return fd_close(fd, 1);
  8021c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021cc:	be 01 00 00 00       	mov    $0x1,%esi
  8021d1:	48 89 c7             	mov    %rax,%rdi
  8021d4:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  8021db:	00 00 00 
  8021de:	ff d0                	callq  *%rax
}
  8021e0:	c9                   	leaveq 
  8021e1:	c3                   	retq   

00000000008021e2 <close_all>:

void
close_all(void)
{
  8021e2:	55                   	push   %rbp
  8021e3:	48 89 e5             	mov    %rsp,%rbp
  8021e6:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021f1:	eb 15                	jmp    802208 <close_all+0x26>
		close(i);
  8021f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f6:	89 c7                	mov    %eax,%edi
  8021f8:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  8021ff:	00 00 00 
  802202:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802204:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802208:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80220c:	7e e5                	jle    8021f3 <close_all+0x11>
		close(i);
}
  80220e:	c9                   	leaveq 
  80220f:	c3                   	retq   

0000000000802210 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802210:	55                   	push   %rbp
  802211:	48 89 e5             	mov    %rsp,%rbp
  802214:	48 83 ec 40          	sub    $0x40,%rsp
  802218:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80221b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80221e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802222:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802225:	48 89 d6             	mov    %rdx,%rsi
  802228:	89 c7                	mov    %eax,%edi
  80222a:	48 b8 87 1f 80 00 00 	movabs $0x801f87,%rax
  802231:	00 00 00 
  802234:	ff d0                	callq  *%rax
  802236:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802239:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80223d:	79 08                	jns    802247 <dup+0x37>
		return r;
  80223f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802242:	e9 70 01 00 00       	jmpq   8023b7 <dup+0x1a7>
	close(newfdnum);
  802247:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80224a:	89 c7                	mov    %eax,%edi
  80224c:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802258:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80225b:	48 98                	cltq   
  80225d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802263:	48 c1 e0 0c          	shl    $0xc,%rax
  802267:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80226b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80226f:	48 89 c7             	mov    %rax,%rdi
  802272:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
  80227e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802286:	48 89 c7             	mov    %rax,%rdi
  802289:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  802290:	00 00 00 
  802293:	ff d0                	callq  *%rax
  802295:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229d:	48 c1 e8 15          	shr    $0x15,%rax
  8022a1:	48 89 c2             	mov    %rax,%rdx
  8022a4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022ab:	01 00 00 
  8022ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b2:	83 e0 01             	and    $0x1,%eax
  8022b5:	48 85 c0             	test   %rax,%rax
  8022b8:	74 73                	je     80232d <dup+0x11d>
  8022ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022be:	48 c1 e8 0c          	shr    $0xc,%rax
  8022c2:	48 89 c2             	mov    %rax,%rdx
  8022c5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022cc:	01 00 00 
  8022cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d3:	83 e0 01             	and    $0x1,%eax
  8022d6:	48 85 c0             	test   %rax,%rax
  8022d9:	74 52                	je     80232d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022df:	48 c1 e8 0c          	shr    $0xc,%rax
  8022e3:	48 89 c2             	mov    %rax,%rdx
  8022e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ed:	01 00 00 
  8022f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f4:	25 07 0e 00 00       	and    $0xe07,%eax
  8022f9:	89 c1                	mov    %eax,%ecx
  8022fb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802303:	41 89 c8             	mov    %ecx,%r8d
  802306:	48 89 d1             	mov    %rdx,%rcx
  802309:	ba 00 00 00 00       	mov    $0x0,%edx
  80230e:	48 89 c6             	mov    %rax,%rsi
  802311:	bf 00 00 00 00       	mov    $0x0,%edi
  802316:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  80231d:	00 00 00 
  802320:	ff d0                	callq  *%rax
  802322:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802325:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802329:	79 02                	jns    80232d <dup+0x11d>
			goto err;
  80232b:	eb 57                	jmp    802384 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80232d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802331:	48 c1 e8 0c          	shr    $0xc,%rax
  802335:	48 89 c2             	mov    %rax,%rdx
  802338:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80233f:	01 00 00 
  802342:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802346:	25 07 0e 00 00       	and    $0xe07,%eax
  80234b:	89 c1                	mov    %eax,%ecx
  80234d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802351:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802355:	41 89 c8             	mov    %ecx,%r8d
  802358:	48 89 d1             	mov    %rdx,%rcx
  80235b:	ba 00 00 00 00       	mov    $0x0,%edx
  802360:	48 89 c6             	mov    %rax,%rsi
  802363:	bf 00 00 00 00       	mov    $0x0,%edi
  802368:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  80236f:	00 00 00 
  802372:	ff d0                	callq  *%rax
  802374:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802377:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80237b:	79 02                	jns    80237f <dup+0x16f>
		goto err;
  80237d:	eb 05                	jmp    802384 <dup+0x174>

	return newfdnum;
  80237f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802382:	eb 33                	jmp    8023b7 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802388:	48 89 c6             	mov    %rax,%rsi
  80238b:	bf 00 00 00 00       	mov    $0x0,%edi
  802390:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  802397:	00 00 00 
  80239a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80239c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a0:	48 89 c6             	mov    %rax,%rsi
  8023a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8023a8:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  8023af:	00 00 00 
  8023b2:	ff d0                	callq  *%rax
	return r;
  8023b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023b7:	c9                   	leaveq 
  8023b8:	c3                   	retq   

00000000008023b9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023b9:	55                   	push   %rbp
  8023ba:	48 89 e5             	mov    %rsp,%rbp
  8023bd:	48 83 ec 40          	sub    $0x40,%rsp
  8023c1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023c4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023c8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023cc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023d3:	48 89 d6             	mov    %rdx,%rsi
  8023d6:	89 c7                	mov    %eax,%edi
  8023d8:	48 b8 87 1f 80 00 00 	movabs $0x801f87,%rax
  8023df:	00 00 00 
  8023e2:	ff d0                	callq  *%rax
  8023e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023eb:	78 24                	js     802411 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f1:	8b 00                	mov    (%rax),%eax
  8023f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023f7:	48 89 d6             	mov    %rdx,%rsi
  8023fa:	89 c7                	mov    %eax,%edi
  8023fc:	48 b8 e0 20 80 00 00 	movabs $0x8020e0,%rax
  802403:	00 00 00 
  802406:	ff d0                	callq  *%rax
  802408:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80240b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80240f:	79 05                	jns    802416 <read+0x5d>
		return r;
  802411:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802414:	eb 76                	jmp    80248c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802416:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80241a:	8b 40 08             	mov    0x8(%rax),%eax
  80241d:	83 e0 03             	and    $0x3,%eax
  802420:	83 f8 01             	cmp    $0x1,%eax
  802423:	75 3a                	jne    80245f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802425:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80242c:	00 00 00 
  80242f:	48 8b 00             	mov    (%rax),%rax
  802432:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802438:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80243b:	89 c6                	mov    %eax,%esi
  80243d:	48 bf 57 46 80 00 00 	movabs $0x804657,%rdi
  802444:	00 00 00 
  802447:	b8 00 00 00 00       	mov    $0x0,%eax
  80244c:	48 b9 88 03 80 00 00 	movabs $0x800388,%rcx
  802453:	00 00 00 
  802456:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802458:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80245d:	eb 2d                	jmp    80248c <read+0xd3>
	}
	if (!dev->dev_read)
  80245f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802463:	48 8b 40 10          	mov    0x10(%rax),%rax
  802467:	48 85 c0             	test   %rax,%rax
  80246a:	75 07                	jne    802473 <read+0xba>
		return -E_NOT_SUPP;
  80246c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802471:	eb 19                	jmp    80248c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802477:	48 8b 40 10          	mov    0x10(%rax),%rax
  80247b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80247f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802483:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802487:	48 89 cf             	mov    %rcx,%rdi
  80248a:	ff d0                	callq  *%rax
}
  80248c:	c9                   	leaveq 
  80248d:	c3                   	retq   

000000000080248e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80248e:	55                   	push   %rbp
  80248f:	48 89 e5             	mov    %rsp,%rbp
  802492:	48 83 ec 30          	sub    $0x30,%rsp
  802496:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802499:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80249d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024a8:	eb 49                	jmp    8024f3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ad:	48 98                	cltq   
  8024af:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024b3:	48 29 c2             	sub    %rax,%rdx
  8024b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b9:	48 63 c8             	movslq %eax,%rcx
  8024bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024c0:	48 01 c1             	add    %rax,%rcx
  8024c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024c6:	48 89 ce             	mov    %rcx,%rsi
  8024c9:	89 c7                	mov    %eax,%edi
  8024cb:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  8024d2:	00 00 00 
  8024d5:	ff d0                	callq  *%rax
  8024d7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024da:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024de:	79 05                	jns    8024e5 <readn+0x57>
			return m;
  8024e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024e3:	eb 1c                	jmp    802501 <readn+0x73>
		if (m == 0)
  8024e5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024e9:	75 02                	jne    8024ed <readn+0x5f>
			break;
  8024eb:	eb 11                	jmp    8024fe <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024f0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f6:	48 98                	cltq   
  8024f8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024fc:	72 ac                	jb     8024aa <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802501:	c9                   	leaveq 
  802502:	c3                   	retq   

0000000000802503 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802503:	55                   	push   %rbp
  802504:	48 89 e5             	mov    %rsp,%rbp
  802507:	48 83 ec 40          	sub    $0x40,%rsp
  80250b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80250e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802512:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802516:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80251a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80251d:	48 89 d6             	mov    %rdx,%rsi
  802520:	89 c7                	mov    %eax,%edi
  802522:	48 b8 87 1f 80 00 00 	movabs $0x801f87,%rax
  802529:	00 00 00 
  80252c:	ff d0                	callq  *%rax
  80252e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802531:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802535:	78 24                	js     80255b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802537:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253b:	8b 00                	mov    (%rax),%eax
  80253d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802541:	48 89 d6             	mov    %rdx,%rsi
  802544:	89 c7                	mov    %eax,%edi
  802546:	48 b8 e0 20 80 00 00 	movabs $0x8020e0,%rax
  80254d:	00 00 00 
  802550:	ff d0                	callq  *%rax
  802552:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802555:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802559:	79 05                	jns    802560 <write+0x5d>
		return r;
  80255b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80255e:	eb 42                	jmp    8025a2 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802564:	8b 40 08             	mov    0x8(%rax),%eax
  802567:	83 e0 03             	and    $0x3,%eax
  80256a:	85 c0                	test   %eax,%eax
  80256c:	75 07                	jne    802575 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80256e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802573:	eb 2d                	jmp    8025a2 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802579:	48 8b 40 18          	mov    0x18(%rax),%rax
  80257d:	48 85 c0             	test   %rax,%rax
  802580:	75 07                	jne    802589 <write+0x86>
		return -E_NOT_SUPP;
  802582:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802587:	eb 19                	jmp    8025a2 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802589:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80258d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802591:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802595:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802599:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80259d:	48 89 cf             	mov    %rcx,%rdi
  8025a0:	ff d0                	callq  *%rax
}
  8025a2:	c9                   	leaveq 
  8025a3:	c3                   	retq   

00000000008025a4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025a4:	55                   	push   %rbp
  8025a5:	48 89 e5             	mov    %rsp,%rbp
  8025a8:	48 83 ec 18          	sub    $0x18,%rsp
  8025ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025af:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025b2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025b9:	48 89 d6             	mov    %rdx,%rsi
  8025bc:	89 c7                	mov    %eax,%edi
  8025be:	48 b8 87 1f 80 00 00 	movabs $0x801f87,%rax
  8025c5:	00 00 00 
  8025c8:	ff d0                	callq  *%rax
  8025ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d1:	79 05                	jns    8025d8 <seek+0x34>
		return r;
  8025d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d6:	eb 0f                	jmp    8025e7 <seek+0x43>
	fd->fd_offset = offset;
  8025d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025dc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025df:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e7:	c9                   	leaveq 
  8025e8:	c3                   	retq   

00000000008025e9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025e9:	55                   	push   %rbp
  8025ea:	48 89 e5             	mov    %rsp,%rbp
  8025ed:	48 83 ec 30          	sub    $0x30,%rsp
  8025f1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025f4:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025f7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025fb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025fe:	48 89 d6             	mov    %rdx,%rsi
  802601:	89 c7                	mov    %eax,%edi
  802603:	48 b8 87 1f 80 00 00 	movabs $0x801f87,%rax
  80260a:	00 00 00 
  80260d:	ff d0                	callq  *%rax
  80260f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802612:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802616:	78 24                	js     80263c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80261c:	8b 00                	mov    (%rax),%eax
  80261e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802622:	48 89 d6             	mov    %rdx,%rsi
  802625:	89 c7                	mov    %eax,%edi
  802627:	48 b8 e0 20 80 00 00 	movabs $0x8020e0,%rax
  80262e:	00 00 00 
  802631:	ff d0                	callq  *%rax
  802633:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802636:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263a:	79 05                	jns    802641 <ftruncate+0x58>
		return r;
  80263c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263f:	eb 72                	jmp    8026b3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802645:	8b 40 08             	mov    0x8(%rax),%eax
  802648:	83 e0 03             	and    $0x3,%eax
  80264b:	85 c0                	test   %eax,%eax
  80264d:	75 3a                	jne    802689 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80264f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802656:	00 00 00 
  802659:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80265c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802662:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802665:	89 c6                	mov    %eax,%esi
  802667:	48 bf 78 46 80 00 00 	movabs $0x804678,%rdi
  80266e:	00 00 00 
  802671:	b8 00 00 00 00       	mov    $0x0,%eax
  802676:	48 b9 88 03 80 00 00 	movabs $0x800388,%rcx
  80267d:	00 00 00 
  802680:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802682:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802687:	eb 2a                	jmp    8026b3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802691:	48 85 c0             	test   %rax,%rax
  802694:	75 07                	jne    80269d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802696:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80269b:	eb 16                	jmp    8026b3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80269d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026a9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026ac:	89 ce                	mov    %ecx,%esi
  8026ae:	48 89 d7             	mov    %rdx,%rdi
  8026b1:	ff d0                	callq  *%rax
}
  8026b3:	c9                   	leaveq 
  8026b4:	c3                   	retq   

00000000008026b5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026b5:	55                   	push   %rbp
  8026b6:	48 89 e5             	mov    %rsp,%rbp
  8026b9:	48 83 ec 30          	sub    $0x30,%rsp
  8026bd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026c0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026c4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026c8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026cb:	48 89 d6             	mov    %rdx,%rsi
  8026ce:	89 c7                	mov    %eax,%edi
  8026d0:	48 b8 87 1f 80 00 00 	movabs $0x801f87,%rax
  8026d7:	00 00 00 
  8026da:	ff d0                	callq  *%rax
  8026dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026e3:	78 24                	js     802709 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e9:	8b 00                	mov    (%rax),%eax
  8026eb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026ef:	48 89 d6             	mov    %rdx,%rsi
  8026f2:	89 c7                	mov    %eax,%edi
  8026f4:	48 b8 e0 20 80 00 00 	movabs $0x8020e0,%rax
  8026fb:	00 00 00 
  8026fe:	ff d0                	callq  *%rax
  802700:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802703:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802707:	79 05                	jns    80270e <fstat+0x59>
		return r;
  802709:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80270c:	eb 5e                	jmp    80276c <fstat+0xb7>
	if (!dev->dev_stat)
  80270e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802712:	48 8b 40 28          	mov    0x28(%rax),%rax
  802716:	48 85 c0             	test   %rax,%rax
  802719:	75 07                	jne    802722 <fstat+0x6d>
		return -E_NOT_SUPP;
  80271b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802720:	eb 4a                	jmp    80276c <fstat+0xb7>
	stat->st_name[0] = 0;
  802722:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802726:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802729:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80272d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802734:	00 00 00 
	stat->st_isdir = 0;
  802737:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80273b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802742:	00 00 00 
	stat->st_dev = dev;
  802745:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802749:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80274d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802758:	48 8b 40 28          	mov    0x28(%rax),%rax
  80275c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802760:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802764:	48 89 ce             	mov    %rcx,%rsi
  802767:	48 89 d7             	mov    %rdx,%rdi
  80276a:	ff d0                	callq  *%rax
}
  80276c:	c9                   	leaveq 
  80276d:	c3                   	retq   

000000000080276e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80276e:	55                   	push   %rbp
  80276f:	48 89 e5             	mov    %rsp,%rbp
  802772:	48 83 ec 20          	sub    $0x20,%rsp
  802776:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80277a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80277e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802782:	be 00 00 00 00       	mov    $0x0,%esi
  802787:	48 89 c7             	mov    %rax,%rdi
  80278a:	48 b8 5c 28 80 00 00 	movabs $0x80285c,%rax
  802791:	00 00 00 
  802794:	ff d0                	callq  *%rax
  802796:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802799:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279d:	79 05                	jns    8027a4 <stat+0x36>
		return fd;
  80279f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a2:	eb 2f                	jmp    8027d3 <stat+0x65>
	r = fstat(fd, stat);
  8027a4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ab:	48 89 d6             	mov    %rdx,%rsi
  8027ae:	89 c7                	mov    %eax,%edi
  8027b0:	48 b8 b5 26 80 00 00 	movabs $0x8026b5,%rax
  8027b7:	00 00 00 
  8027ba:	ff d0                	callq  *%rax
  8027bc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c2:	89 c7                	mov    %eax,%edi
  8027c4:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  8027cb:	00 00 00 
  8027ce:	ff d0                	callq  *%rax
	return r;
  8027d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027d3:	c9                   	leaveq 
  8027d4:	c3                   	retq   

00000000008027d5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027d5:	55                   	push   %rbp
  8027d6:	48 89 e5             	mov    %rsp,%rbp
  8027d9:	48 83 ec 10          	sub    $0x10,%rsp
  8027dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027e4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027eb:	00 00 00 
  8027ee:	8b 00                	mov    (%rax),%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	75 1d                	jne    802811 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027f4:	bf 01 00 00 00       	mov    $0x1,%edi
  8027f9:	48 b8 d1 3f 80 00 00 	movabs $0x803fd1,%rax
  802800:	00 00 00 
  802803:	ff d0                	callq  *%rax
  802805:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80280c:	00 00 00 
  80280f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802811:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802818:	00 00 00 
  80281b:	8b 00                	mov    (%rax),%eax
  80281d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802820:	b9 07 00 00 00       	mov    $0x7,%ecx
  802825:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80282c:	00 00 00 
  80282f:	89 c7                	mov    %eax,%edi
  802831:	48 b8 04 3c 80 00 00 	movabs $0x803c04,%rax
  802838:	00 00 00 
  80283b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80283d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802841:	ba 00 00 00 00       	mov    $0x0,%edx
  802846:	48 89 c6             	mov    %rax,%rsi
  802849:	bf 00 00 00 00       	mov    $0x0,%edi
  80284e:	48 b8 06 3b 80 00 00 	movabs $0x803b06,%rax
  802855:	00 00 00 
  802858:	ff d0                	callq  *%rax
}
  80285a:	c9                   	leaveq 
  80285b:	c3                   	retq   

000000000080285c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80285c:	55                   	push   %rbp
  80285d:	48 89 e5             	mov    %rsp,%rbp
  802860:	48 83 ec 30          	sub    $0x30,%rsp
  802864:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802868:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80286b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802872:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802879:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802880:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802885:	75 08                	jne    80288f <open+0x33>
	{
		return r;
  802887:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288a:	e9 f2 00 00 00       	jmpq   802981 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80288f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802893:	48 89 c7             	mov    %rax,%rdi
  802896:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  80289d:	00 00 00 
  8028a0:	ff d0                	callq  *%rax
  8028a2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8028a5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8028ac:	7e 0a                	jle    8028b8 <open+0x5c>
	{
		return -E_BAD_PATH;
  8028ae:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028b3:	e9 c9 00 00 00       	jmpq   802981 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8028b8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8028bf:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8028c0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8028c4:	48 89 c7             	mov    %rax,%rdi
  8028c7:	48 b8 ef 1e 80 00 00 	movabs $0x801eef,%rax
  8028ce:	00 00 00 
  8028d1:	ff d0                	callq  *%rax
  8028d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028da:	78 09                	js     8028e5 <open+0x89>
  8028dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e0:	48 85 c0             	test   %rax,%rax
  8028e3:	75 08                	jne    8028ed <open+0x91>
		{
			return r;
  8028e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e8:	e9 94 00 00 00       	jmpq   802981 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8028ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028f1:	ba 00 04 00 00       	mov    $0x400,%edx
  8028f6:	48 89 c6             	mov    %rax,%rsi
  8028f9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802900:	00 00 00 
  802903:	48 b8 cf 0f 80 00 00 	movabs $0x800fcf,%rax
  80290a:	00 00 00 
  80290d:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80290f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802916:	00 00 00 
  802919:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80291c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802926:	48 89 c6             	mov    %rax,%rsi
  802929:	bf 01 00 00 00       	mov    $0x1,%edi
  80292e:	48 b8 d5 27 80 00 00 	movabs $0x8027d5,%rax
  802935:	00 00 00 
  802938:	ff d0                	callq  *%rax
  80293a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802941:	79 2b                	jns    80296e <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802943:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802947:	be 00 00 00 00       	mov    $0x0,%esi
  80294c:	48 89 c7             	mov    %rax,%rdi
  80294f:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  802956:	00 00 00 
  802959:	ff d0                	callq  *%rax
  80295b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80295e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802962:	79 05                	jns    802969 <open+0x10d>
			{
				return d;
  802964:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802967:	eb 18                	jmp    802981 <open+0x125>
			}
			return r;
  802969:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296c:	eb 13                	jmp    802981 <open+0x125>
		}	
		return fd2num(fd_store);
  80296e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802972:	48 89 c7             	mov    %rax,%rdi
  802975:	48 b8 a1 1e 80 00 00 	movabs $0x801ea1,%rax
  80297c:	00 00 00 
  80297f:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802981:	c9                   	leaveq 
  802982:	c3                   	retq   

0000000000802983 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802983:	55                   	push   %rbp
  802984:	48 89 e5             	mov    %rsp,%rbp
  802987:	48 83 ec 10          	sub    $0x10,%rsp
  80298b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80298f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802993:	8b 50 0c             	mov    0xc(%rax),%edx
  802996:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80299d:	00 00 00 
  8029a0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029a2:	be 00 00 00 00       	mov    $0x0,%esi
  8029a7:	bf 06 00 00 00       	mov    $0x6,%edi
  8029ac:	48 b8 d5 27 80 00 00 	movabs $0x8027d5,%rax
  8029b3:	00 00 00 
  8029b6:	ff d0                	callq  *%rax
}
  8029b8:	c9                   	leaveq 
  8029b9:	c3                   	retq   

00000000008029ba <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029ba:	55                   	push   %rbp
  8029bb:	48 89 e5             	mov    %rsp,%rbp
  8029be:	48 83 ec 30          	sub    $0x30,%rsp
  8029c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8029ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8029d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029da:	74 07                	je     8029e3 <devfile_read+0x29>
  8029dc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029e1:	75 07                	jne    8029ea <devfile_read+0x30>
		return -E_INVAL;
  8029e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029e8:	eb 77                	jmp    802a61 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ee:	8b 50 0c             	mov    0xc(%rax),%edx
  8029f1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029f8:	00 00 00 
  8029fb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029fd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a04:	00 00 00 
  802a07:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a0b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802a0f:	be 00 00 00 00       	mov    $0x0,%esi
  802a14:	bf 03 00 00 00       	mov    $0x3,%edi
  802a19:	48 b8 d5 27 80 00 00 	movabs $0x8027d5,%rax
  802a20:	00 00 00 
  802a23:	ff d0                	callq  *%rax
  802a25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2c:	7f 05                	jg     802a33 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802a2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a31:	eb 2e                	jmp    802a61 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802a33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a36:	48 63 d0             	movslq %eax,%rdx
  802a39:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a3d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a44:	00 00 00 
  802a47:	48 89 c7             	mov    %rax,%rdi
  802a4a:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  802a51:	00 00 00 
  802a54:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802a56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a5a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802a5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a61:	c9                   	leaveq 
  802a62:	c3                   	retq   

0000000000802a63 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a63:	55                   	push   %rbp
  802a64:	48 89 e5             	mov    %rsp,%rbp
  802a67:	48 83 ec 30          	sub    $0x30,%rsp
  802a6b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a6f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a73:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802a77:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802a7e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a83:	74 07                	je     802a8c <devfile_write+0x29>
  802a85:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a8a:	75 08                	jne    802a94 <devfile_write+0x31>
		return r;
  802a8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8f:	e9 9a 00 00 00       	jmpq   802b2e <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a98:	8b 50 0c             	mov    0xc(%rax),%edx
  802a9b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aa2:	00 00 00 
  802aa5:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802aa7:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802aae:	00 
  802aaf:	76 08                	jbe    802ab9 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802ab1:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802ab8:	00 
	}
	fsipcbuf.write.req_n = n;
  802ab9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ac0:	00 00 00 
  802ac3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ac7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802acb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802acf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad3:	48 89 c6             	mov    %rax,%rsi
  802ad6:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802add:	00 00 00 
  802ae0:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  802ae7:	00 00 00 
  802aea:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802aec:	be 00 00 00 00       	mov    $0x0,%esi
  802af1:	bf 04 00 00 00       	mov    $0x4,%edi
  802af6:	48 b8 d5 27 80 00 00 	movabs $0x8027d5,%rax
  802afd:	00 00 00 
  802b00:	ff d0                	callq  *%rax
  802b02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b09:	7f 20                	jg     802b2b <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802b0b:	48 bf 9e 46 80 00 00 	movabs $0x80469e,%rdi
  802b12:	00 00 00 
  802b15:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1a:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802b21:	00 00 00 
  802b24:	ff d2                	callq  *%rdx
		return r;
  802b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b29:	eb 03                	jmp    802b2e <devfile_write+0xcb>
	}
	return r;
  802b2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802b2e:	c9                   	leaveq 
  802b2f:	c3                   	retq   

0000000000802b30 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b30:	55                   	push   %rbp
  802b31:	48 89 e5             	mov    %rsp,%rbp
  802b34:	48 83 ec 20          	sub    $0x20,%rsp
  802b38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b44:	8b 50 0c             	mov    0xc(%rax),%edx
  802b47:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b4e:	00 00 00 
  802b51:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b53:	be 00 00 00 00       	mov    $0x0,%esi
  802b58:	bf 05 00 00 00       	mov    $0x5,%edi
  802b5d:	48 b8 d5 27 80 00 00 	movabs $0x8027d5,%rax
  802b64:	00 00 00 
  802b67:	ff d0                	callq  *%rax
  802b69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b70:	79 05                	jns    802b77 <devfile_stat+0x47>
		return r;
  802b72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b75:	eb 56                	jmp    802bcd <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b7b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b82:	00 00 00 
  802b85:	48 89 c7             	mov    %rax,%rdi
  802b88:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  802b8f:	00 00 00 
  802b92:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b94:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b9b:	00 00 00 
  802b9e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ba4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ba8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802bae:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bb5:	00 00 00 
  802bb8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802bbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bc2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bcd:	c9                   	leaveq 
  802bce:	c3                   	retq   

0000000000802bcf <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bcf:	55                   	push   %rbp
  802bd0:	48 89 e5             	mov    %rsp,%rbp
  802bd3:	48 83 ec 10          	sub    $0x10,%rsp
  802bd7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bdb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802bde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802be2:	8b 50 0c             	mov    0xc(%rax),%edx
  802be5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bec:	00 00 00 
  802bef:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802bf1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bf8:	00 00 00 
  802bfb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802bfe:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c01:	be 00 00 00 00       	mov    $0x0,%esi
  802c06:	bf 02 00 00 00       	mov    $0x2,%edi
  802c0b:	48 b8 d5 27 80 00 00 	movabs $0x8027d5,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	callq  *%rax
}
  802c17:	c9                   	leaveq 
  802c18:	c3                   	retq   

0000000000802c19 <remove>:

// Delete a file
int
remove(const char *path)
{
  802c19:	55                   	push   %rbp
  802c1a:	48 89 e5             	mov    %rsp,%rbp
  802c1d:	48 83 ec 10          	sub    $0x10,%rsp
  802c21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c29:	48 89 c7             	mov    %rax,%rdi
  802c2c:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  802c33:	00 00 00 
  802c36:	ff d0                	callq  *%rax
  802c38:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c3d:	7e 07                	jle    802c46 <remove+0x2d>
		return -E_BAD_PATH;
  802c3f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c44:	eb 33                	jmp    802c79 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c4a:	48 89 c6             	mov    %rax,%rsi
  802c4d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c54:	00 00 00 
  802c57:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  802c5e:	00 00 00 
  802c61:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c63:	be 00 00 00 00       	mov    $0x0,%esi
  802c68:	bf 07 00 00 00       	mov    $0x7,%edi
  802c6d:	48 b8 d5 27 80 00 00 	movabs $0x8027d5,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
}
  802c79:	c9                   	leaveq 
  802c7a:	c3                   	retq   

0000000000802c7b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c7b:	55                   	push   %rbp
  802c7c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c7f:	be 00 00 00 00       	mov    $0x0,%esi
  802c84:	bf 08 00 00 00       	mov    $0x8,%edi
  802c89:	48 b8 d5 27 80 00 00 	movabs $0x8027d5,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	callq  *%rax
}
  802c95:	5d                   	pop    %rbp
  802c96:	c3                   	retq   

0000000000802c97 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c97:	55                   	push   %rbp
  802c98:	48 89 e5             	mov    %rsp,%rbp
  802c9b:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ca2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802ca9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802cb0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802cb7:	be 00 00 00 00       	mov    $0x0,%esi
  802cbc:	48 89 c7             	mov    %rax,%rdi
  802cbf:	48 b8 5c 28 80 00 00 	movabs $0x80285c,%rax
  802cc6:	00 00 00 
  802cc9:	ff d0                	callq  *%rax
  802ccb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802cce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd2:	79 28                	jns    802cfc <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802cd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd7:	89 c6                	mov    %eax,%esi
  802cd9:	48 bf ba 46 80 00 00 	movabs $0x8046ba,%rdi
  802ce0:	00 00 00 
  802ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce8:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802cef:	00 00 00 
  802cf2:	ff d2                	callq  *%rdx
		return fd_src;
  802cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf7:	e9 74 01 00 00       	jmpq   802e70 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802cfc:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d03:	be 01 01 00 00       	mov    $0x101,%esi
  802d08:	48 89 c7             	mov    %rax,%rdi
  802d0b:	48 b8 5c 28 80 00 00 	movabs $0x80285c,%rax
  802d12:	00 00 00 
  802d15:	ff d0                	callq  *%rax
  802d17:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d1e:	79 39                	jns    802d59 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d23:	89 c6                	mov    %eax,%esi
  802d25:	48 bf d0 46 80 00 00 	movabs $0x8046d0,%rdi
  802d2c:	00 00 00 
  802d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d34:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802d3b:	00 00 00 
  802d3e:	ff d2                	callq  *%rdx
		close(fd_src);
  802d40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d43:	89 c7                	mov    %eax,%edi
  802d45:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  802d4c:	00 00 00 
  802d4f:	ff d0                	callq  *%rax
		return fd_dest;
  802d51:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d54:	e9 17 01 00 00       	jmpq   802e70 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d59:	eb 74                	jmp    802dcf <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d5b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d5e:	48 63 d0             	movslq %eax,%rdx
  802d61:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d6b:	48 89 ce             	mov    %rcx,%rsi
  802d6e:	89 c7                	mov    %eax,%edi
  802d70:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  802d77:	00 00 00 
  802d7a:	ff d0                	callq  *%rax
  802d7c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d83:	79 4a                	jns    802dcf <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d85:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d88:	89 c6                	mov    %eax,%esi
  802d8a:	48 bf ea 46 80 00 00 	movabs $0x8046ea,%rdi
  802d91:	00 00 00 
  802d94:	b8 00 00 00 00       	mov    $0x0,%eax
  802d99:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802da0:	00 00 00 
  802da3:	ff d2                	callq  *%rdx
			close(fd_src);
  802da5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da8:	89 c7                	mov    %eax,%edi
  802daa:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  802db1:	00 00 00 
  802db4:	ff d0                	callq  *%rax
			close(fd_dest);
  802db6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802db9:	89 c7                	mov    %eax,%edi
  802dbb:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  802dc2:	00 00 00 
  802dc5:	ff d0                	callq  *%rax
			return write_size;
  802dc7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dca:	e9 a1 00 00 00       	jmpq   802e70 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802dcf:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd9:	ba 00 02 00 00       	mov    $0x200,%edx
  802dde:	48 89 ce             	mov    %rcx,%rsi
  802de1:	89 c7                	mov    %eax,%edi
  802de3:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
  802def:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802df2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802df6:	0f 8f 5f ff ff ff    	jg     802d5b <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e00:	79 47                	jns    802e49 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e02:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e05:	89 c6                	mov    %eax,%esi
  802e07:	48 bf fd 46 80 00 00 	movabs $0x8046fd,%rdi
  802e0e:	00 00 00 
  802e11:	b8 00 00 00 00       	mov    $0x0,%eax
  802e16:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802e1d:	00 00 00 
  802e20:	ff d2                	callq  *%rdx
		close(fd_src);
  802e22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e25:	89 c7                	mov    %eax,%edi
  802e27:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  802e2e:	00 00 00 
  802e31:	ff d0                	callq  *%rax
		close(fd_dest);
  802e33:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e36:	89 c7                	mov    %eax,%edi
  802e38:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  802e3f:	00 00 00 
  802e42:	ff d0                	callq  *%rax
		return read_size;
  802e44:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e47:	eb 27                	jmp    802e70 <copy+0x1d9>
	}
	close(fd_src);
  802e49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4c:	89 c7                	mov    %eax,%edi
  802e4e:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  802e55:	00 00 00 
  802e58:	ff d0                	callq  *%rax
	close(fd_dest);
  802e5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e5d:	89 c7                	mov    %eax,%edi
  802e5f:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  802e66:	00 00 00 
  802e69:	ff d0                	callq  *%rax
	return 0;
  802e6b:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e70:	c9                   	leaveq 
  802e71:	c3                   	retq   

0000000000802e72 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802e72:	55                   	push   %rbp
  802e73:	48 89 e5             	mov    %rsp,%rbp
  802e76:	48 83 ec 20          	sub    $0x20,%rsp
  802e7a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e82:	8b 40 0c             	mov    0xc(%rax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	7e 67                	jle    802ef0 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802e89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8d:	8b 40 04             	mov    0x4(%rax),%eax
  802e90:	48 63 d0             	movslq %eax,%rdx
  802e93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e97:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802e9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9f:	8b 00                	mov    (%rax),%eax
  802ea1:	48 89 ce             	mov    %rcx,%rsi
  802ea4:	89 c7                	mov    %eax,%edi
  802ea6:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  802ead:	00 00 00 
  802eb0:	ff d0                	callq  *%rax
  802eb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802eb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb9:	7e 13                	jle    802ece <writebuf+0x5c>
			b->result += result;
  802ebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ebf:	8b 50 08             	mov    0x8(%rax),%edx
  802ec2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec5:	01 c2                	add    %eax,%edx
  802ec7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ecb:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802ece:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed2:	8b 40 04             	mov    0x4(%rax),%eax
  802ed5:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802ed8:	74 16                	je     802ef0 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802eda:	b8 00 00 00 00       	mov    $0x0,%eax
  802edf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee3:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802ee7:	89 c2                	mov    %eax,%edx
  802ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eed:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802ef0:	c9                   	leaveq 
  802ef1:	c3                   	retq   

0000000000802ef2 <putch>:

static void
putch(int ch, void *thunk)
{
  802ef2:	55                   	push   %rbp
  802ef3:	48 89 e5             	mov    %rsp,%rbp
  802ef6:	48 83 ec 20          	sub    $0x20,%rsp
  802efa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802efd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802f01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802f09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f0d:	8b 40 04             	mov    0x4(%rax),%eax
  802f10:	8d 48 01             	lea    0x1(%rax),%ecx
  802f13:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f17:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802f1a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f1d:	89 d1                	mov    %edx,%ecx
  802f1f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f23:	48 98                	cltq   
  802f25:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802f29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f2d:	8b 40 04             	mov    0x4(%rax),%eax
  802f30:	3d 00 01 00 00       	cmp    $0x100,%eax
  802f35:	75 1e                	jne    802f55 <putch+0x63>
		writebuf(b);
  802f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f3b:	48 89 c7             	mov    %rax,%rdi
  802f3e:	48 b8 72 2e 80 00 00 	movabs $0x802e72,%rax
  802f45:	00 00 00 
  802f48:	ff d0                	callq  *%rax
		b->idx = 0;
  802f4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802f55:	c9                   	leaveq 
  802f56:	c3                   	retq   

0000000000802f57 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802f57:	55                   	push   %rbp
  802f58:	48 89 e5             	mov    %rsp,%rbp
  802f5b:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802f62:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802f68:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802f6f:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802f76:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802f7c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802f82:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802f89:	00 00 00 
	b.result = 0;
  802f8c:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802f93:	00 00 00 
	b.error = 1;
  802f96:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802f9d:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802fa0:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802fa7:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802fae:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802fb5:	48 89 c6             	mov    %rax,%rsi
  802fb8:	48 bf f2 2e 80 00 00 	movabs $0x802ef2,%rdi
  802fbf:	00 00 00 
  802fc2:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  802fc9:	00 00 00 
  802fcc:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802fce:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	7e 16                	jle    802fee <vfprintf+0x97>
		writebuf(&b);
  802fd8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802fdf:	48 89 c7             	mov    %rax,%rdi
  802fe2:	48 b8 72 2e 80 00 00 	movabs $0x802e72,%rax
  802fe9:	00 00 00 
  802fec:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802fee:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ff4:	85 c0                	test   %eax,%eax
  802ff6:	74 08                	je     803000 <vfprintf+0xa9>
  802ff8:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ffe:	eb 06                	jmp    803006 <vfprintf+0xaf>
  803000:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803006:	c9                   	leaveq 
  803007:	c3                   	retq   

0000000000803008 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803008:	55                   	push   %rbp
  803009:	48 89 e5             	mov    %rsp,%rbp
  80300c:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803013:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803019:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803020:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803027:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80302e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803035:	84 c0                	test   %al,%al
  803037:	74 20                	je     803059 <fprintf+0x51>
  803039:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80303d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803041:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803045:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803049:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80304d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803051:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803055:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803059:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803060:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803067:	00 00 00 
  80306a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803071:	00 00 00 
  803074:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803078:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80307f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803086:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80308d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803094:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80309b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030a1:	48 89 ce             	mov    %rcx,%rsi
  8030a4:	89 c7                	mov    %eax,%edi
  8030a6:	48 b8 57 2f 80 00 00 	movabs $0x802f57,%rax
  8030ad:	00 00 00 
  8030b0:	ff d0                	callq  *%rax
  8030b2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8030b8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8030be:	c9                   	leaveq 
  8030bf:	c3                   	retq   

00000000008030c0 <printf>:

int
printf(const char *fmt, ...)
{
  8030c0:	55                   	push   %rbp
  8030c1:	48 89 e5             	mov    %rsp,%rbp
  8030c4:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8030cb:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8030d2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8030d9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8030e0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8030e7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8030ee:	84 c0                	test   %al,%al
  8030f0:	74 20                	je     803112 <printf+0x52>
  8030f2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8030f6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8030fa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8030fe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803102:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803106:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80310a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80310e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803112:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803119:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803120:	00 00 00 
  803123:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80312a:	00 00 00 
  80312d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803131:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803138:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80313f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803146:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80314d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803154:	48 89 c6             	mov    %rax,%rsi
  803157:	bf 01 00 00 00       	mov    $0x1,%edi
  80315c:	48 b8 57 2f 80 00 00 	movabs $0x802f57,%rax
  803163:	00 00 00 
  803166:	ff d0                	callq  *%rax
  803168:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80316e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803174:	c9                   	leaveq 
  803175:	c3                   	retq   

0000000000803176 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803176:	55                   	push   %rbp
  803177:	48 89 e5             	mov    %rsp,%rbp
  80317a:	53                   	push   %rbx
  80317b:	48 83 ec 38          	sub    $0x38,%rsp
  80317f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803183:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803187:	48 89 c7             	mov    %rax,%rdi
  80318a:	48 b8 ef 1e 80 00 00 	movabs $0x801eef,%rax
  803191:	00 00 00 
  803194:	ff d0                	callq  *%rax
  803196:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803199:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80319d:	0f 88 bf 01 00 00    	js     803362 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a7:	ba 07 04 00 00       	mov    $0x407,%edx
  8031ac:	48 89 c6             	mov    %rax,%rsi
  8031af:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b4:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  8031bb:	00 00 00 
  8031be:	ff d0                	callq  *%rax
  8031c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031c7:	0f 88 95 01 00 00    	js     803362 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8031cd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8031d1:	48 89 c7             	mov    %rax,%rdi
  8031d4:	48 b8 ef 1e 80 00 00 	movabs $0x801eef,%rax
  8031db:	00 00 00 
  8031de:	ff d0                	callq  *%rax
  8031e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031e7:	0f 88 5d 01 00 00    	js     80334a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031f1:	ba 07 04 00 00       	mov    $0x407,%edx
  8031f6:	48 89 c6             	mov    %rax,%rsi
  8031f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8031fe:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803205:	00 00 00 
  803208:	ff d0                	callq  *%rax
  80320a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80320d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803211:	0f 88 33 01 00 00    	js     80334a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803217:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80321b:	48 89 c7             	mov    %rax,%rdi
  80321e:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  803225:	00 00 00 
  803228:	ff d0                	callq  *%rax
  80322a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80322e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803232:	ba 07 04 00 00       	mov    $0x407,%edx
  803237:	48 89 c6             	mov    %rax,%rsi
  80323a:	bf 00 00 00 00       	mov    $0x0,%edi
  80323f:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
  80324b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80324e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803252:	79 05                	jns    803259 <pipe+0xe3>
		goto err2;
  803254:	e9 d9 00 00 00       	jmpq   803332 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803259:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80325d:	48 89 c7             	mov    %rax,%rdi
  803260:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  803267:	00 00 00 
  80326a:	ff d0                	callq  *%rax
  80326c:	48 89 c2             	mov    %rax,%rdx
  80326f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803273:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803279:	48 89 d1             	mov    %rdx,%rcx
  80327c:	ba 00 00 00 00       	mov    $0x0,%edx
  803281:	48 89 c6             	mov    %rax,%rsi
  803284:	bf 00 00 00 00       	mov    $0x0,%edi
  803289:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  803290:	00 00 00 
  803293:	ff d0                	callq  *%rax
  803295:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803298:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80329c:	79 1b                	jns    8032b9 <pipe+0x143>
		goto err3;
  80329e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80329f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032a3:	48 89 c6             	mov    %rax,%rsi
  8032a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ab:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  8032b2:	00 00 00 
  8032b5:	ff d0                	callq  *%rax
  8032b7:	eb 79                	jmp    803332 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8032b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032bd:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8032c4:	00 00 00 
  8032c7:	8b 12                	mov    (%rdx),%edx
  8032c9:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8032cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8032d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032da:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8032e1:	00 00 00 
  8032e4:	8b 12                	mov    (%rdx),%edx
  8032e6:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8032e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8032f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f7:	48 89 c7             	mov    %rax,%rdi
  8032fa:	48 b8 a1 1e 80 00 00 	movabs $0x801ea1,%rax
  803301:	00 00 00 
  803304:	ff d0                	callq  *%rax
  803306:	89 c2                	mov    %eax,%edx
  803308:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80330c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80330e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803312:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803316:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80331a:	48 89 c7             	mov    %rax,%rdi
  80331d:	48 b8 a1 1e 80 00 00 	movabs $0x801ea1,%rax
  803324:	00 00 00 
  803327:	ff d0                	callq  *%rax
  803329:	89 03                	mov    %eax,(%rbx)
	return 0;
  80332b:	b8 00 00 00 00       	mov    $0x0,%eax
  803330:	eb 33                	jmp    803365 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803332:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803336:	48 89 c6             	mov    %rax,%rsi
  803339:	bf 00 00 00 00       	mov    $0x0,%edi
  80333e:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  803345:	00 00 00 
  803348:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80334a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80334e:	48 89 c6             	mov    %rax,%rsi
  803351:	bf 00 00 00 00       	mov    $0x0,%edi
  803356:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  80335d:	00 00 00 
  803360:	ff d0                	callq  *%rax
err:
	return r;
  803362:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803365:	48 83 c4 38          	add    $0x38,%rsp
  803369:	5b                   	pop    %rbx
  80336a:	5d                   	pop    %rbp
  80336b:	c3                   	retq   

000000000080336c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80336c:	55                   	push   %rbp
  80336d:	48 89 e5             	mov    %rsp,%rbp
  803370:	53                   	push   %rbx
  803371:	48 83 ec 28          	sub    $0x28,%rsp
  803375:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803379:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80337d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803384:	00 00 00 
  803387:	48 8b 00             	mov    (%rax),%rax
  80338a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803390:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803393:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803397:	48 89 c7             	mov    %rax,%rdi
  80339a:	48 b8 43 40 80 00 00 	movabs $0x804043,%rax
  8033a1:	00 00 00 
  8033a4:	ff d0                	callq  *%rax
  8033a6:	89 c3                	mov    %eax,%ebx
  8033a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ac:	48 89 c7             	mov    %rax,%rdi
  8033af:	48 b8 43 40 80 00 00 	movabs $0x804043,%rax
  8033b6:	00 00 00 
  8033b9:	ff d0                	callq  *%rax
  8033bb:	39 c3                	cmp    %eax,%ebx
  8033bd:	0f 94 c0             	sete   %al
  8033c0:	0f b6 c0             	movzbl %al,%eax
  8033c3:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8033c6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033cd:	00 00 00 
  8033d0:	48 8b 00             	mov    (%rax),%rax
  8033d3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033d9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8033dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033df:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8033e2:	75 05                	jne    8033e9 <_pipeisclosed+0x7d>
			return ret;
  8033e4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033e7:	eb 4f                	jmp    803438 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8033e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033ec:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8033ef:	74 42                	je     803433 <_pipeisclosed+0xc7>
  8033f1:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8033f5:	75 3c                	jne    803433 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8033f7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033fe:	00 00 00 
  803401:	48 8b 00             	mov    (%rax),%rax
  803404:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80340a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80340d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803410:	89 c6                	mov    %eax,%esi
  803412:	48 bf 1d 47 80 00 00 	movabs $0x80471d,%rdi
  803419:	00 00 00 
  80341c:	b8 00 00 00 00       	mov    $0x0,%eax
  803421:	49 b8 88 03 80 00 00 	movabs $0x800388,%r8
  803428:	00 00 00 
  80342b:	41 ff d0             	callq  *%r8
	}
  80342e:	e9 4a ff ff ff       	jmpq   80337d <_pipeisclosed+0x11>
  803433:	e9 45 ff ff ff       	jmpq   80337d <_pipeisclosed+0x11>
}
  803438:	48 83 c4 28          	add    $0x28,%rsp
  80343c:	5b                   	pop    %rbx
  80343d:	5d                   	pop    %rbp
  80343e:	c3                   	retq   

000000000080343f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80343f:	55                   	push   %rbp
  803440:	48 89 e5             	mov    %rsp,%rbp
  803443:	48 83 ec 30          	sub    $0x30,%rsp
  803447:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80344a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80344e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803451:	48 89 d6             	mov    %rdx,%rsi
  803454:	89 c7                	mov    %eax,%edi
  803456:	48 b8 87 1f 80 00 00 	movabs $0x801f87,%rax
  80345d:	00 00 00 
  803460:	ff d0                	callq  *%rax
  803462:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803465:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803469:	79 05                	jns    803470 <pipeisclosed+0x31>
		return r;
  80346b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346e:	eb 31                	jmp    8034a1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803474:	48 89 c7             	mov    %rax,%rdi
  803477:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  80347e:	00 00 00 
  803481:	ff d0                	callq  *%rax
  803483:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80348b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80348f:	48 89 d6             	mov    %rdx,%rsi
  803492:	48 89 c7             	mov    %rax,%rdi
  803495:	48 b8 6c 33 80 00 00 	movabs $0x80336c,%rax
  80349c:	00 00 00 
  80349f:	ff d0                	callq  *%rax
}
  8034a1:	c9                   	leaveq 
  8034a2:	c3                   	retq   

00000000008034a3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034a3:	55                   	push   %rbp
  8034a4:	48 89 e5             	mov    %rsp,%rbp
  8034a7:	48 83 ec 40          	sub    $0x40,%rsp
  8034ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034b3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8034b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034bb:	48 89 c7             	mov    %rax,%rdi
  8034be:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  8034c5:	00 00 00 
  8034c8:	ff d0                	callq  *%rax
  8034ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034d2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8034d6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034dd:	00 
  8034de:	e9 92 00 00 00       	jmpq   803575 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8034e3:	eb 41                	jmp    803526 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8034e5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8034ea:	74 09                	je     8034f5 <devpipe_read+0x52>
				return i;
  8034ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f0:	e9 92 00 00 00       	jmpq   803587 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8034f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034fd:	48 89 d6             	mov    %rdx,%rsi
  803500:	48 89 c7             	mov    %rax,%rdi
  803503:	48 b8 6c 33 80 00 00 	movabs $0x80336c,%rax
  80350a:	00 00 00 
  80350d:	ff d0                	callq  *%rax
  80350f:	85 c0                	test   %eax,%eax
  803511:	74 07                	je     80351a <devpipe_read+0x77>
				return 0;
  803513:	b8 00 00 00 00       	mov    $0x0,%eax
  803518:	eb 6d                	jmp    803587 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80351a:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  803521:	00 00 00 
  803524:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352a:	8b 10                	mov    (%rax),%edx
  80352c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803530:	8b 40 04             	mov    0x4(%rax),%eax
  803533:	39 c2                	cmp    %eax,%edx
  803535:	74 ae                	je     8034e5 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80353b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80353f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803543:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803547:	8b 00                	mov    (%rax),%eax
  803549:	99                   	cltd   
  80354a:	c1 ea 1b             	shr    $0x1b,%edx
  80354d:	01 d0                	add    %edx,%eax
  80354f:	83 e0 1f             	and    $0x1f,%eax
  803552:	29 d0                	sub    %edx,%eax
  803554:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803558:	48 98                	cltq   
  80355a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80355f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803561:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803565:	8b 00                	mov    (%rax),%eax
  803567:	8d 50 01             	lea    0x1(%rax),%edx
  80356a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803570:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803575:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803579:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80357d:	0f 82 60 ff ff ff    	jb     8034e3 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803583:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803587:	c9                   	leaveq 
  803588:	c3                   	retq   

0000000000803589 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803589:	55                   	push   %rbp
  80358a:	48 89 e5             	mov    %rsp,%rbp
  80358d:	48 83 ec 40          	sub    $0x40,%rsp
  803591:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803595:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803599:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80359d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035a1:	48 89 c7             	mov    %rax,%rdi
  8035a4:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  8035ab:	00 00 00 
  8035ae:	ff d0                	callq  *%rax
  8035b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035bc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035c3:	00 
  8035c4:	e9 8e 00 00 00       	jmpq   803657 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035c9:	eb 31                	jmp    8035fc <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8035cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d3:	48 89 d6             	mov    %rdx,%rsi
  8035d6:	48 89 c7             	mov    %rax,%rdi
  8035d9:	48 b8 6c 33 80 00 00 	movabs $0x80336c,%rax
  8035e0:	00 00 00 
  8035e3:	ff d0                	callq  *%rax
  8035e5:	85 c0                	test   %eax,%eax
  8035e7:	74 07                	je     8035f0 <devpipe_write+0x67>
				return 0;
  8035e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ee:	eb 79                	jmp    803669 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8035f0:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  8035f7:	00 00 00 
  8035fa:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803600:	8b 40 04             	mov    0x4(%rax),%eax
  803603:	48 63 d0             	movslq %eax,%rdx
  803606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360a:	8b 00                	mov    (%rax),%eax
  80360c:	48 98                	cltq   
  80360e:	48 83 c0 20          	add    $0x20,%rax
  803612:	48 39 c2             	cmp    %rax,%rdx
  803615:	73 b4                	jae    8035cb <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803617:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361b:	8b 40 04             	mov    0x4(%rax),%eax
  80361e:	99                   	cltd   
  80361f:	c1 ea 1b             	shr    $0x1b,%edx
  803622:	01 d0                	add    %edx,%eax
  803624:	83 e0 1f             	and    $0x1f,%eax
  803627:	29 d0                	sub    %edx,%eax
  803629:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80362d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803631:	48 01 ca             	add    %rcx,%rdx
  803634:	0f b6 0a             	movzbl (%rdx),%ecx
  803637:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80363b:	48 98                	cltq   
  80363d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803641:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803645:	8b 40 04             	mov    0x4(%rax),%eax
  803648:	8d 50 01             	lea    0x1(%rax),%edx
  80364b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803652:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803657:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80365b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80365f:	0f 82 64 ff ff ff    	jb     8035c9 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803665:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803669:	c9                   	leaveq 
  80366a:	c3                   	retq   

000000000080366b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80366b:	55                   	push   %rbp
  80366c:	48 89 e5             	mov    %rsp,%rbp
  80366f:	48 83 ec 20          	sub    $0x20,%rsp
  803673:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803677:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80367b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80367f:	48 89 c7             	mov    %rax,%rdi
  803682:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  803689:	00 00 00 
  80368c:	ff d0                	callq  *%rax
  80368e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803692:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803696:	48 be 30 47 80 00 00 	movabs $0x804730,%rsi
  80369d:	00 00 00 
  8036a0:	48 89 c7             	mov    %rax,%rdi
  8036a3:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  8036aa:	00 00 00 
  8036ad:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8036af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b3:	8b 50 04             	mov    0x4(%rax),%edx
  8036b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ba:	8b 00                	mov    (%rax),%eax
  8036bc:	29 c2                	sub    %eax,%edx
  8036be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036c2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8036c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036cc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8036d3:	00 00 00 
	stat->st_dev = &devpipe;
  8036d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036da:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8036e1:	00 00 00 
  8036e4:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8036eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036f0:	c9                   	leaveq 
  8036f1:	c3                   	retq   

00000000008036f2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8036f2:	55                   	push   %rbp
  8036f3:	48 89 e5             	mov    %rsp,%rbp
  8036f6:	48 83 ec 10          	sub    $0x10,%rsp
  8036fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8036fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803702:	48 89 c6             	mov    %rax,%rsi
  803705:	bf 00 00 00 00       	mov    $0x0,%edi
  80370a:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  803711:	00 00 00 
  803714:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803716:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80371a:	48 89 c7             	mov    %rax,%rdi
  80371d:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  803724:	00 00 00 
  803727:	ff d0                	callq  *%rax
  803729:	48 89 c6             	mov    %rax,%rsi
  80372c:	bf 00 00 00 00       	mov    $0x0,%edi
  803731:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  803738:	00 00 00 
  80373b:	ff d0                	callq  *%rax
}
  80373d:	c9                   	leaveq 
  80373e:	c3                   	retq   

000000000080373f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80373f:	55                   	push   %rbp
  803740:	48 89 e5             	mov    %rsp,%rbp
  803743:	48 83 ec 20          	sub    $0x20,%rsp
  803747:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80374a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80374d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803750:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803754:	be 01 00 00 00       	mov    $0x1,%esi
  803759:	48 89 c7             	mov    %rax,%rdi
  80375c:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  803763:	00 00 00 
  803766:	ff d0                	callq  *%rax
}
  803768:	c9                   	leaveq 
  803769:	c3                   	retq   

000000000080376a <getchar>:

int
getchar(void)
{
  80376a:	55                   	push   %rbp
  80376b:	48 89 e5             	mov    %rsp,%rbp
  80376e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803772:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803776:	ba 01 00 00 00       	mov    $0x1,%edx
  80377b:	48 89 c6             	mov    %rax,%rsi
  80377e:	bf 00 00 00 00       	mov    $0x0,%edi
  803783:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  80378a:	00 00 00 
  80378d:	ff d0                	callq  *%rax
  80378f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803792:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803796:	79 05                	jns    80379d <getchar+0x33>
		return r;
  803798:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379b:	eb 14                	jmp    8037b1 <getchar+0x47>
	if (r < 1)
  80379d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a1:	7f 07                	jg     8037aa <getchar+0x40>
		return -E_EOF;
  8037a3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8037a8:	eb 07                	jmp    8037b1 <getchar+0x47>
	return c;
  8037aa:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8037ae:	0f b6 c0             	movzbl %al,%eax
}
  8037b1:	c9                   	leaveq 
  8037b2:	c3                   	retq   

00000000008037b3 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8037b3:	55                   	push   %rbp
  8037b4:	48 89 e5             	mov    %rsp,%rbp
  8037b7:	48 83 ec 20          	sub    $0x20,%rsp
  8037bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037be:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037c5:	48 89 d6             	mov    %rdx,%rsi
  8037c8:	89 c7                	mov    %eax,%edi
  8037ca:	48 b8 87 1f 80 00 00 	movabs $0x801f87,%rax
  8037d1:	00 00 00 
  8037d4:	ff d0                	callq  *%rax
  8037d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037dd:	79 05                	jns    8037e4 <iscons+0x31>
		return r;
  8037df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e2:	eb 1a                	jmp    8037fe <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8037e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e8:	8b 10                	mov    (%rax),%edx
  8037ea:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8037f1:	00 00 00 
  8037f4:	8b 00                	mov    (%rax),%eax
  8037f6:	39 c2                	cmp    %eax,%edx
  8037f8:	0f 94 c0             	sete   %al
  8037fb:	0f b6 c0             	movzbl %al,%eax
}
  8037fe:	c9                   	leaveq 
  8037ff:	c3                   	retq   

0000000000803800 <opencons>:

int
opencons(void)
{
  803800:	55                   	push   %rbp
  803801:	48 89 e5             	mov    %rsp,%rbp
  803804:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803808:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80380c:	48 89 c7             	mov    %rax,%rdi
  80380f:	48 b8 ef 1e 80 00 00 	movabs $0x801eef,%rax
  803816:	00 00 00 
  803819:	ff d0                	callq  *%rax
  80381b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80381e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803822:	79 05                	jns    803829 <opencons+0x29>
		return r;
  803824:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803827:	eb 5b                	jmp    803884 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803829:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80382d:	ba 07 04 00 00       	mov    $0x407,%edx
  803832:	48 89 c6             	mov    %rax,%rsi
  803835:	bf 00 00 00 00       	mov    $0x0,%edi
  80383a:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803841:	00 00 00 
  803844:	ff d0                	callq  *%rax
  803846:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803849:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384d:	79 05                	jns    803854 <opencons+0x54>
		return r;
  80384f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803852:	eb 30                	jmp    803884 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803854:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803858:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80385f:	00 00 00 
  803862:	8b 12                	mov    (%rdx),%edx
  803864:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803866:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803871:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803875:	48 89 c7             	mov    %rax,%rdi
  803878:	48 b8 a1 1e 80 00 00 	movabs $0x801ea1,%rax
  80387f:	00 00 00 
  803882:	ff d0                	callq  *%rax
}
  803884:	c9                   	leaveq 
  803885:	c3                   	retq   

0000000000803886 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803886:	55                   	push   %rbp
  803887:	48 89 e5             	mov    %rsp,%rbp
  80388a:	48 83 ec 30          	sub    $0x30,%rsp
  80388e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803892:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803896:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80389a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80389f:	75 07                	jne    8038a8 <devcons_read+0x22>
		return 0;
  8038a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a6:	eb 4b                	jmp    8038f3 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8038a8:	eb 0c                	jmp    8038b6 <devcons_read+0x30>
		sys_yield();
  8038aa:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  8038b1:	00 00 00 
  8038b4:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8038b6:	48 b8 6e 17 80 00 00 	movabs $0x80176e,%rax
  8038bd:	00 00 00 
  8038c0:	ff d0                	callq  *%rax
  8038c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c9:	74 df                	je     8038aa <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8038cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038cf:	79 05                	jns    8038d6 <devcons_read+0x50>
		return c;
  8038d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d4:	eb 1d                	jmp    8038f3 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8038d6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8038da:	75 07                	jne    8038e3 <devcons_read+0x5d>
		return 0;
  8038dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e1:	eb 10                	jmp    8038f3 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8038e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e6:	89 c2                	mov    %eax,%edx
  8038e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ec:	88 10                	mov    %dl,(%rax)
	return 1;
  8038ee:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8038f3:	c9                   	leaveq 
  8038f4:	c3                   	retq   

00000000008038f5 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038f5:	55                   	push   %rbp
  8038f6:	48 89 e5             	mov    %rsp,%rbp
  8038f9:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803900:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803907:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80390e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803915:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80391c:	eb 76                	jmp    803994 <devcons_write+0x9f>
		m = n - tot;
  80391e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803925:	89 c2                	mov    %eax,%edx
  803927:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80392a:	29 c2                	sub    %eax,%edx
  80392c:	89 d0                	mov    %edx,%eax
  80392e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803931:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803934:	83 f8 7f             	cmp    $0x7f,%eax
  803937:	76 07                	jbe    803940 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803939:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803940:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803943:	48 63 d0             	movslq %eax,%rdx
  803946:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803949:	48 63 c8             	movslq %eax,%rcx
  80394c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803953:	48 01 c1             	add    %rax,%rcx
  803956:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80395d:	48 89 ce             	mov    %rcx,%rsi
  803960:	48 89 c7             	mov    %rax,%rdi
  803963:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  80396a:	00 00 00 
  80396d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80396f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803972:	48 63 d0             	movslq %eax,%rdx
  803975:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80397c:	48 89 d6             	mov    %rdx,%rsi
  80397f:	48 89 c7             	mov    %rax,%rdi
  803982:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  803989:	00 00 00 
  80398c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80398e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803991:	01 45 fc             	add    %eax,-0x4(%rbp)
  803994:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803997:	48 98                	cltq   
  803999:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8039a0:	0f 82 78 ff ff ff    	jb     80391e <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8039a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039a9:	c9                   	leaveq 
  8039aa:	c3                   	retq   

00000000008039ab <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8039ab:	55                   	push   %rbp
  8039ac:	48 89 e5             	mov    %rsp,%rbp
  8039af:	48 83 ec 08          	sub    $0x8,%rsp
  8039b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8039b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039bc:	c9                   	leaveq 
  8039bd:	c3                   	retq   

00000000008039be <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8039be:	55                   	push   %rbp
  8039bf:	48 89 e5             	mov    %rsp,%rbp
  8039c2:	48 83 ec 10          	sub    $0x10,%rsp
  8039c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8039ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d2:	48 be 3c 47 80 00 00 	movabs $0x80473c,%rsi
  8039d9:	00 00 00 
  8039dc:	48 89 c7             	mov    %rax,%rdi
  8039df:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  8039e6:	00 00 00 
  8039e9:	ff d0                	callq  *%rax
	return 0;
  8039eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039f0:	c9                   	leaveq 
  8039f1:	c3                   	retq   

00000000008039f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8039f2:	55                   	push   %rbp
  8039f3:	48 89 e5             	mov    %rsp,%rbp
  8039f6:	53                   	push   %rbx
  8039f7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8039fe:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803a05:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803a0b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803a12:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803a19:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803a20:	84 c0                	test   %al,%al
  803a22:	74 23                	je     803a47 <_panic+0x55>
  803a24:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803a2b:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803a2f:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803a33:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803a37:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803a3b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803a3f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803a43:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803a47:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803a4e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803a55:	00 00 00 
  803a58:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803a5f:	00 00 00 
  803a62:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803a66:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803a6d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803a74:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803a7b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803a82:	00 00 00 
  803a85:	48 8b 18             	mov    (%rax),%rbx
  803a88:	48 b8 f0 17 80 00 00 	movabs $0x8017f0,%rax
  803a8f:	00 00 00 
  803a92:	ff d0                	callq  *%rax
  803a94:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803a9a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803aa1:	41 89 c8             	mov    %ecx,%r8d
  803aa4:	48 89 d1             	mov    %rdx,%rcx
  803aa7:	48 89 da             	mov    %rbx,%rdx
  803aaa:	89 c6                	mov    %eax,%esi
  803aac:	48 bf 48 47 80 00 00 	movabs $0x804748,%rdi
  803ab3:	00 00 00 
  803ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  803abb:	49 b9 88 03 80 00 00 	movabs $0x800388,%r9
  803ac2:	00 00 00 
  803ac5:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803ac8:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803acf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803ad6:	48 89 d6             	mov    %rdx,%rsi
  803ad9:	48 89 c7             	mov    %rax,%rdi
  803adc:	48 b8 dc 02 80 00 00 	movabs $0x8002dc,%rax
  803ae3:	00 00 00 
  803ae6:	ff d0                	callq  *%rax
	cprintf("\n");
  803ae8:	48 bf 6b 47 80 00 00 	movabs $0x80476b,%rdi
  803aef:	00 00 00 
  803af2:	b8 00 00 00 00       	mov    $0x0,%eax
  803af7:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  803afe:	00 00 00 
  803b01:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803b03:	cc                   	int3   
  803b04:	eb fd                	jmp    803b03 <_panic+0x111>

0000000000803b06 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803b06:	55                   	push   %rbp
  803b07:	48 89 e5             	mov    %rsp,%rbp
  803b0a:	48 83 ec 30          	sub    $0x30,%rsp
  803b0e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b16:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803b1a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b21:	00 00 00 
  803b24:	48 8b 00             	mov    (%rax),%rax
  803b27:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803b2d:	85 c0                	test   %eax,%eax
  803b2f:	75 34                	jne    803b65 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803b31:	48 b8 f0 17 80 00 00 	movabs $0x8017f0,%rax
  803b38:	00 00 00 
  803b3b:	ff d0                	callq  *%rax
  803b3d:	25 ff 03 00 00       	and    $0x3ff,%eax
  803b42:	48 98                	cltq   
  803b44:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803b4b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803b52:	00 00 00 
  803b55:	48 01 c2             	add    %rax,%rdx
  803b58:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b5f:	00 00 00 
  803b62:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803b65:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b6a:	75 0e                	jne    803b7a <ipc_recv+0x74>
		pg = (void*) UTOP;
  803b6c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803b73:	00 00 00 
  803b76:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803b7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b7e:	48 89 c7             	mov    %rax,%rdi
  803b81:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  803b88:	00 00 00 
  803b8b:	ff d0                	callq  *%rax
  803b8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803b90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b94:	79 19                	jns    803baf <ipc_recv+0xa9>
		*from_env_store = 0;
  803b96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b9a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803ba0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803baa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bad:	eb 53                	jmp    803c02 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803baf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803bb4:	74 19                	je     803bcf <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803bb6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bbd:	00 00 00 
  803bc0:	48 8b 00             	mov    (%rax),%rax
  803bc3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bcd:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803bcf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bd4:	74 19                	je     803bef <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803bd6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bdd:	00 00 00 
  803be0:	48 8b 00             	mov    (%rax),%rax
  803be3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803be9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bed:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803bef:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bf6:	00 00 00 
  803bf9:	48 8b 00             	mov    (%rax),%rax
  803bfc:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803c02:	c9                   	leaveq 
  803c03:	c3                   	retq   

0000000000803c04 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c04:	55                   	push   %rbp
  803c05:	48 89 e5             	mov    %rsp,%rbp
  803c08:	48 83 ec 30          	sub    $0x30,%rsp
  803c0c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c0f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803c12:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803c16:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803c19:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c1e:	75 0e                	jne    803c2e <ipc_send+0x2a>
		pg = (void*)UTOP;
  803c20:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c27:	00 00 00 
  803c2a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803c2e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803c31:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803c34:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803c38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c3b:	89 c7                	mov    %eax,%edi
  803c3d:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  803c44:	00 00 00 
  803c47:	ff d0                	callq  *%rax
  803c49:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803c4c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803c50:	75 0c                	jne    803c5e <ipc_send+0x5a>
			sys_yield();
  803c52:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  803c59:	00 00 00 
  803c5c:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803c5e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803c62:	74 ca                	je     803c2e <ipc_send+0x2a>
	if(result != 0)
  803c64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c68:	74 20                	je     803c8a <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6d:	89 c6                	mov    %eax,%esi
  803c6f:	48 bf 70 47 80 00 00 	movabs $0x804770,%rdi
  803c76:	00 00 00 
  803c79:	b8 00 00 00 00       	mov    $0x0,%eax
  803c7e:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  803c85:	00 00 00 
  803c88:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803c8a:	c9                   	leaveq 
  803c8b:	c3                   	retq   

0000000000803c8c <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803c8c:	55                   	push   %rbp
  803c8d:	48 89 e5             	mov    %rsp,%rbp
  803c90:	53                   	push   %rbx
  803c91:	48 83 ec 58          	sub    $0x58,%rsp
  803c95:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  803c99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c9d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  803ca1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803ca8:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803caf:	00 
  803cb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cb4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803cb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cbc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803cc0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cc4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803cc8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803ccc:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  803cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cd4:	48 c1 e8 27          	shr    $0x27,%rax
  803cd8:	48 89 c2             	mov    %rax,%rdx
  803cdb:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803ce2:	01 00 00 
  803ce5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ce9:	83 e0 01             	and    $0x1,%eax
  803cec:	48 85 c0             	test   %rax,%rax
  803cef:	0f 85 91 00 00 00    	jne    803d86 <ipc_host_recv+0xfa>
  803cf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cf9:	48 c1 e8 1e          	shr    $0x1e,%rax
  803cfd:	48 89 c2             	mov    %rax,%rdx
  803d00:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803d07:	01 00 00 
  803d0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d0e:	83 e0 01             	and    $0x1,%eax
  803d11:	48 85 c0             	test   %rax,%rax
  803d14:	74 70                	je     803d86 <ipc_host_recv+0xfa>
  803d16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d1a:	48 c1 e8 15          	shr    $0x15,%rax
  803d1e:	48 89 c2             	mov    %rax,%rdx
  803d21:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d28:	01 00 00 
  803d2b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d2f:	83 e0 01             	and    $0x1,%eax
  803d32:	48 85 c0             	test   %rax,%rax
  803d35:	74 4f                	je     803d86 <ipc_host_recv+0xfa>
  803d37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d3b:	48 c1 e8 0c          	shr    $0xc,%rax
  803d3f:	48 89 c2             	mov    %rax,%rdx
  803d42:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d49:	01 00 00 
  803d4c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d50:	83 e0 01             	and    $0x1,%eax
  803d53:	48 85 c0             	test   %rax,%rax
  803d56:	74 2e                	je     803d86 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d5c:	ba 07 04 00 00       	mov    $0x407,%edx
  803d61:	48 89 c6             	mov    %rax,%rsi
  803d64:	bf 00 00 00 00       	mov    $0x0,%edi
  803d69:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803d70:	00 00 00 
  803d73:	ff d0                	callq  *%rax
  803d75:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803d78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803d7c:	79 08                	jns    803d86 <ipc_host_recv+0xfa>
	    	return result;
  803d7e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803d81:	e9 84 00 00 00       	jmpq   803e0a <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803d86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d8a:	48 c1 e8 0c          	shr    $0xc,%rax
  803d8e:	48 89 c2             	mov    %rax,%rdx
  803d91:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d98:	01 00 00 
  803d9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d9f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803da5:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  803da9:	b8 03 00 00 00       	mov    $0x3,%eax
  803dae:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803db2:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803db6:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  803dba:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803dbe:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803dc2:	4c 89 c3             	mov    %r8,%rbx
  803dc5:	0f 01 c1             	vmcall 
  803dc8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  803dcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803dcf:	7e 36                	jle    803e07 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  803dd1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803dd4:	41 89 c0             	mov    %eax,%r8d
  803dd7:	b9 03 00 00 00       	mov    $0x3,%ecx
  803ddc:	48 ba 88 47 80 00 00 	movabs $0x804788,%rdx
  803de3:	00 00 00 
  803de6:	be 67 00 00 00       	mov    $0x67,%esi
  803deb:	48 bf b5 47 80 00 00 	movabs $0x8047b5,%rdi
  803df2:	00 00 00 
  803df5:	b8 00 00 00 00       	mov    $0x0,%eax
  803dfa:	49 b9 f2 39 80 00 00 	movabs $0x8039f2,%r9
  803e01:	00 00 00 
  803e04:	41 ff d1             	callq  *%r9
	return result;
  803e07:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  803e0a:	48 83 c4 58          	add    $0x58,%rsp
  803e0e:	5b                   	pop    %rbx
  803e0f:	5d                   	pop    %rbp
  803e10:	c3                   	retq   

0000000000803e11 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e11:	55                   	push   %rbp
  803e12:	48 89 e5             	mov    %rsp,%rbp
  803e15:	53                   	push   %rbx
  803e16:	48 83 ec 68          	sub    $0x68,%rsp
  803e1a:	89 7d ac             	mov    %edi,-0x54(%rbp)
  803e1d:	89 75 a8             	mov    %esi,-0x58(%rbp)
  803e20:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  803e24:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  803e27:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803e2b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  803e2f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803e36:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803e3d:	00 
  803e3e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e42:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803e46:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803e4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e52:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803e56:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803e5a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  803e5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e62:	48 c1 e8 27          	shr    $0x27,%rax
  803e66:	48 89 c2             	mov    %rax,%rdx
  803e69:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803e70:	01 00 00 
  803e73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e77:	83 e0 01             	and    $0x1,%eax
  803e7a:	48 85 c0             	test   %rax,%rax
  803e7d:	0f 85 88 00 00 00    	jne    803f0b <ipc_host_send+0xfa>
  803e83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e87:	48 c1 e8 1e          	shr    $0x1e,%rax
  803e8b:	48 89 c2             	mov    %rax,%rdx
  803e8e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803e95:	01 00 00 
  803e98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e9c:	83 e0 01             	and    $0x1,%eax
  803e9f:	48 85 c0             	test   %rax,%rax
  803ea2:	74 67                	je     803f0b <ipc_host_send+0xfa>
  803ea4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ea8:	48 c1 e8 15          	shr    $0x15,%rax
  803eac:	48 89 c2             	mov    %rax,%rdx
  803eaf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803eb6:	01 00 00 
  803eb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ebd:	83 e0 01             	and    $0x1,%eax
  803ec0:	48 85 c0             	test   %rax,%rax
  803ec3:	74 46                	je     803f0b <ipc_host_send+0xfa>
  803ec5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ec9:	48 c1 e8 0c          	shr    $0xc,%rax
  803ecd:	48 89 c2             	mov    %rax,%rdx
  803ed0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ed7:	01 00 00 
  803eda:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ede:	83 e0 01             	and    $0x1,%eax
  803ee1:	48 85 c0             	test   %rax,%rax
  803ee4:	74 25                	je     803f0b <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803ee6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eea:	48 c1 e8 0c          	shr    $0xc,%rax
  803eee:	48 89 c2             	mov    %rax,%rdx
  803ef1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ef8:	01 00 00 
  803efb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803eff:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803f05:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803f09:	eb 0e                	jmp    803f19 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  803f0b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f12:	00 00 00 
  803f15:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  803f19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f1d:	48 89 c6             	mov    %rax,%rsi
  803f20:	48 bf bf 47 80 00 00 	movabs $0x8047bf,%rdi
  803f27:	00 00 00 
  803f2a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f2f:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  803f36:	00 00 00 
  803f39:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  803f3b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  803f3e:	48 98                	cltq   
  803f40:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  803f44:	8b 45 a8             	mov    -0x58(%rbp),%eax
  803f47:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  803f4b:	8b 45 9c             	mov    -0x64(%rbp),%eax
  803f4e:	48 98                	cltq   
  803f50:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  803f54:	b8 02 00 00 00       	mov    $0x2,%eax
  803f59:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803f5d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803f61:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  803f65:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803f69:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803f6d:	4c 89 c3             	mov    %r8,%rbx
  803f70:	0f 01 c1             	vmcall 
  803f73:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  803f76:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803f7a:	75 0c                	jne    803f88 <ipc_host_send+0x177>
			sys_yield();
  803f7c:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  803f83:	00 00 00 
  803f86:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  803f88:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803f8c:	74 c6                	je     803f54 <ipc_host_send+0x143>
	
	if(result !=0)
  803f8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803f92:	74 36                	je     803fca <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  803f94:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f97:	41 89 c0             	mov    %eax,%r8d
  803f9a:	b9 02 00 00 00       	mov    $0x2,%ecx
  803f9f:	48 ba 88 47 80 00 00 	movabs $0x804788,%rdx
  803fa6:	00 00 00 
  803fa9:	be 94 00 00 00       	mov    $0x94,%esi
  803fae:	48 bf b5 47 80 00 00 	movabs $0x8047b5,%rdi
  803fb5:	00 00 00 
  803fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  803fbd:	49 b9 f2 39 80 00 00 	movabs $0x8039f2,%r9
  803fc4:	00 00 00 
  803fc7:	41 ff d1             	callq  *%r9
}
  803fca:	48 83 c4 68          	add    $0x68,%rsp
  803fce:	5b                   	pop    %rbx
  803fcf:	5d                   	pop    %rbp
  803fd0:	c3                   	retq   

0000000000803fd1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803fd1:	55                   	push   %rbp
  803fd2:	48 89 e5             	mov    %rsp,%rbp
  803fd5:	48 83 ec 14          	sub    $0x14,%rsp
  803fd9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803fdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fe3:	eb 4e                	jmp    804033 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803fe5:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803fec:	00 00 00 
  803fef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ff2:	48 98                	cltq   
  803ff4:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803ffb:	48 01 d0             	add    %rdx,%rax
  803ffe:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804004:	8b 00                	mov    (%rax),%eax
  804006:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804009:	75 24                	jne    80402f <ipc_find_env+0x5e>
			return envs[i].env_id;
  80400b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804012:	00 00 00 
  804015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804018:	48 98                	cltq   
  80401a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804021:	48 01 d0             	add    %rdx,%rax
  804024:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80402a:	8b 40 08             	mov    0x8(%rax),%eax
  80402d:	eb 12                	jmp    804041 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80402f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804033:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80403a:	7e a9                	jle    803fe5 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80403c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804041:	c9                   	leaveq 
  804042:	c3                   	retq   

0000000000804043 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804043:	55                   	push   %rbp
  804044:	48 89 e5             	mov    %rsp,%rbp
  804047:	48 83 ec 18          	sub    $0x18,%rsp
  80404b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80404f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804053:	48 c1 e8 15          	shr    $0x15,%rax
  804057:	48 89 c2             	mov    %rax,%rdx
  80405a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804061:	01 00 00 
  804064:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804068:	83 e0 01             	and    $0x1,%eax
  80406b:	48 85 c0             	test   %rax,%rax
  80406e:	75 07                	jne    804077 <pageref+0x34>
		return 0;
  804070:	b8 00 00 00 00       	mov    $0x0,%eax
  804075:	eb 53                	jmp    8040ca <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804077:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80407b:	48 c1 e8 0c          	shr    $0xc,%rax
  80407f:	48 89 c2             	mov    %rax,%rdx
  804082:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804089:	01 00 00 
  80408c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804090:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804094:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804098:	83 e0 01             	and    $0x1,%eax
  80409b:	48 85 c0             	test   %rax,%rax
  80409e:	75 07                	jne    8040a7 <pageref+0x64>
		return 0;
  8040a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a5:	eb 23                	jmp    8040ca <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8040af:	48 89 c2             	mov    %rax,%rdx
  8040b2:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040b9:	00 00 00 
  8040bc:	48 c1 e2 04          	shl    $0x4,%rdx
  8040c0:	48 01 d0             	add    %rdx,%rax
  8040c3:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8040c7:	0f b7 c0             	movzwl %ax,%eax
}
  8040ca:	c9                   	leaveq 
  8040cb:	c3                   	retq   
