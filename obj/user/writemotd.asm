
obj/user/writemotd:     file format elf64-x86-64


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
  80003c:	e8 36 03 00 00       	callq  800377 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004e:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800054:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int rfd, wfd;
	char buf[512];
	int n, r;

	if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  80005b:	be 00 00 00 00       	mov    $0x0,%esi
  800060:	48 bf 60 3a 80 00 00 	movabs $0x803a60,%rdi
  800067:	00 00 00 
  80006a:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	79 30                	jns    8000af <umain+0x6c>
		panic("open /newmotd: %e", rfd);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba 69 3a 80 00 00 	movabs $0x803a69,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf 7b 3a 80 00 00 	movabs $0x803a7b,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if ((wfd = open("/motd", O_RDWR)) < 0)
  8000af:	be 02 00 00 00       	mov    $0x2,%esi
  8000b4:	48 bf 8c 3a 80 00 00 	movabs $0x803a8c,%rdi
  8000bb:	00 00 00 
  8000be:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("open /motd: %e", wfd);
  8000d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba 92 3a 80 00 00 	movabs $0x803a92,%rdx
  8000df:	00 00 00 
  8000e2:	be 0d 00 00 00       	mov    $0xd,%esi
  8000e7:	48 bf 7b 3a 80 00 00 	movabs $0x803a7b,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8
	cprintf("file descriptors %d %d\n", rfd, wfd);
  800103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	89 c6                	mov    %eax,%esi
  80010b:	48 bf a1 3a 80 00 00 	movabs $0x803aa1,%rdi
  800112:	00 00 00 
  800115:	b8 00 00 00 00       	mov    $0x0,%eax
  80011a:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  800121:	00 00 00 
  800124:	ff d1                	callq  *%rcx
	if (rfd == wfd)
  800126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800129:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  80012c:	75 2a                	jne    800158 <umain+0x115>
		panic("open /newmotd and /motd give same file descriptor");
  80012e:	48 ba c0 3a 80 00 00 	movabs $0x803ac0,%rdx
  800135:	00 00 00 
  800138:	be 10 00 00 00       	mov    $0x10,%esi
  80013d:	48 bf 7b 3a 80 00 00 	movabs $0x803a7b,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 b9 1d 04 80 00 00 	movabs $0x80041d,%rcx
  800153:	00 00 00 
  800156:	ff d1                	callq  *%rcx

	cprintf("OLD MOTD\n===\n");
  800158:	48 bf f2 3a 80 00 00 	movabs $0x803af2,%rdi
  80015f:	00 00 00 
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
  800167:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  80016e:	00 00 00 
  800171:	ff d2                	callq  *%rdx
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800173:	eb 1f                	jmp    800194 <umain+0x151>
		sys_cputs(buf, n);
  800175:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800178:	48 63 d0             	movslq %eax,%rdx
  80017b:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800182:	48 89 d6             	mov    %rdx,%rsi
  800185:	48 89 c7             	mov    %rax,%rdi
  800188:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
	cprintf("file descriptors %d %d\n", rfd, wfd);
	if (rfd == wfd)
		panic("open /newmotd and /motd give same file descriptor");

	cprintf("OLD MOTD\n===\n");
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800194:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80019b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019e:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8001a3:	48 89 ce             	mov    %rcx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 a0 24 80 00 00 	movabs $0x8024a0,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001bb:	7f b8                	jg     800175 <umain+0x132>
		sys_cputs(buf, n);
	cprintf("===\n");
  8001bd:	48 bf 00 3b 80 00 00 	movabs $0x803b00,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	callq  *%rdx
	seek(wfd, 0);
  8001d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001db:	be 00 00 00 00       	mov    $0x0,%esi
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 8b 26 80 00 00 	movabs $0x80268b,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax

	if ((r = ftruncate(wfd, 0)) < 0)
  8001ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800207:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("truncate /motd: %e", r);
  80020d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 05 3b 80 00 00 	movabs $0x803b05,%rdx
  800219:	00 00 00 
  80021c:	be 19 00 00 00       	mov    $0x19,%esi
  800221:	48 bf 7b 3a 80 00 00 	movabs $0x803a7b,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8

	cprintf("NEW MOTD\n===\n");
  80023d:	48 bf 18 3b 80 00 00 	movabs $0x803b18,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  800258:	eb 7b                	jmp    8002d5 <umain+0x292>
		sys_cputs(buf, n);
  80025a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80025d:	48 63 d0             	movslq %eax,%rdx
  800260:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800267:	48 89 d6             	mov    %rdx,%rsi
  80026a:	48 89 c7             	mov    %rax,%rdi
  80026d:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  800274:	00 00 00 
  800277:	ff d0                	callq  *%rax
		if ((r = write(wfd, buf, n)) != n)
  800279:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80027c:	48 63 d0             	movslq %eax,%rdx
  80027f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800286:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800289:	48 89 ce             	mov    %rcx,%rsi
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002a3:	74 30                	je     8002d5 <umain+0x292>
			panic("write /motd: %e", r);
  8002a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a8:	89 c1                	mov    %eax,%ecx
  8002aa:	48 ba 26 3b 80 00 00 	movabs $0x803b26,%rdx
  8002b1:	00 00 00 
  8002b4:	be 1f 00 00 00       	mov    $0x1f,%esi
  8002b9:	48 bf 7b 3a 80 00 00 	movabs $0x803a7b,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  8002cf:	00 00 00 
  8002d2:	41 ff d0             	callq  *%r8

	if ((r = ftruncate(wfd, 0)) < 0)
		panic("truncate /motd: %e", r);

	cprintf("NEW MOTD\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  8002d5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8002dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002df:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8002e4:	48 89 ce             	mov    %rcx,%rsi
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	48 b8 a0 24 80 00 00 	movabs $0x8024a0,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002fc:	0f 8f 58 ff ff ff    	jg     80025a <umain+0x217>
		sys_cputs(buf, n);
		if ((r = write(wfd, buf, n)) != n)
			panic("write /motd: %e", r);
	}
	cprintf("===\n");
  800302:	48 bf 00 3b 80 00 00 	movabs $0x803b00,%rdi
  800309:	00 00 00 
  80030c:	b8 00 00 00 00       	mov    $0x0,%eax
  800311:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  800318:	00 00 00 
  80031b:	ff d2                	callq  *%rdx

	if (n < 0)
  80031d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800321:	79 30                	jns    800353 <umain+0x310>
		panic("read /newmotd: %e", n);
  800323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800326:	89 c1                	mov    %eax,%ecx
  800328:	48 ba 36 3b 80 00 00 	movabs $0x803b36,%rdx
  80032f:	00 00 00 
  800332:	be 24 00 00 00       	mov    $0x24,%esi
  800337:	48 bf 7b 3a 80 00 00 	movabs $0x803a7b,%rdi
  80033e:	00 00 00 
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  80034d:	00 00 00 
  800350:	41 ff d0             	callq  *%r8

	close(rfd);
  800353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800356:	89 c7                	mov    %eax,%edi
  800358:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	close(wfd);
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
}
  800375:	c9                   	leaveq 
  800376:	c3                   	retq   

0000000000800377 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	48 83 ec 10          	sub    $0x10,%rsp
  80037f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800386:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  80038d:	00 00 00 
  800390:	ff d0                	callq  *%rax
  800392:	25 ff 03 00 00       	and    $0x3ff,%eax
  800397:	48 98                	cltq   
  800399:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8003a0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003a7:	00 00 00 
  8003aa:	48 01 c2             	add    %rax,%rdx
  8003ad:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003b4:	00 00 00 
  8003b7:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003be:	7e 14                	jle    8003d4 <libmain+0x5d>
		binaryname = argv[0];
  8003c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c4:	48 8b 10             	mov    (%rax),%rdx
  8003c7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8003ce:	00 00 00 
  8003d1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003db:	48 89 d6             	mov    %rdx,%rsi
  8003de:	89 c7                	mov    %eax,%edi
  8003e0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003e7:	00 00 00 
  8003ea:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003ec:	48 b8 fa 03 80 00 00 	movabs $0x8003fa,%rax
  8003f3:	00 00 00 
  8003f6:	ff d0                	callq  *%rax
}
  8003f8:	c9                   	leaveq 
  8003f9:	c3                   	retq   

00000000008003fa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003fa:	55                   	push   %rbp
  8003fb:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003fe:	48 b8 c9 22 80 00 00 	movabs $0x8022c9,%rax
  800405:	00 00 00 
  800408:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80040a:	bf 00 00 00 00       	mov    $0x0,%edi
  80040f:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax

}
  80041b:	5d                   	pop    %rbp
  80041c:	c3                   	retq   

000000000080041d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80041d:	55                   	push   %rbp
  80041e:	48 89 e5             	mov    %rsp,%rbp
  800421:	53                   	push   %rbx
  800422:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800429:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800430:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800436:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80043d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800444:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80044b:	84 c0                	test   %al,%al
  80044d:	74 23                	je     800472 <_panic+0x55>
  80044f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800456:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80045a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80045e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800462:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800466:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80046a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80046e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800472:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800479:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800480:	00 00 00 
  800483:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80048a:	00 00 00 
  80048d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800491:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800498:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80049f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004a6:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8004ad:	00 00 00 
  8004b0:	48 8b 18             	mov    (%rax),%rbx
  8004b3:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  8004ba:	00 00 00 
  8004bd:	ff d0                	callq  *%rax
  8004bf:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004c5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004cc:	41 89 c8             	mov    %ecx,%r8d
  8004cf:	48 89 d1             	mov    %rdx,%rcx
  8004d2:	48 89 da             	mov    %rbx,%rdx
  8004d5:	89 c6                	mov    %eax,%esi
  8004d7:	48 bf 58 3b 80 00 00 	movabs $0x803b58,%rdi
  8004de:	00 00 00 
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e6:	49 b9 56 06 80 00 00 	movabs $0x800656,%r9
  8004ed:	00 00 00 
  8004f0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004f3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004fa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800501:	48 89 d6             	mov    %rdx,%rsi
  800504:	48 89 c7             	mov    %rax,%rdi
  800507:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  80050e:	00 00 00 
  800511:	ff d0                	callq  *%rax
	cprintf("\n");
  800513:	48 bf 7b 3b 80 00 00 	movabs $0x803b7b,%rdi
  80051a:	00 00 00 
  80051d:	b8 00 00 00 00       	mov    $0x0,%eax
  800522:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  800529:	00 00 00 
  80052c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80052e:	cc                   	int3   
  80052f:	eb fd                	jmp    80052e <_panic+0x111>

0000000000800531 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800531:	55                   	push   %rbp
  800532:	48 89 e5             	mov    %rsp,%rbp
  800535:	48 83 ec 10          	sub    $0x10,%rsp
  800539:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80053c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800544:	8b 00                	mov    (%rax),%eax
  800546:	8d 48 01             	lea    0x1(%rax),%ecx
  800549:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80054d:	89 0a                	mov    %ecx,(%rdx)
  80054f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800552:	89 d1                	mov    %edx,%ecx
  800554:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800558:	48 98                	cltq   
  80055a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80055e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800562:	8b 00                	mov    (%rax),%eax
  800564:	3d ff 00 00 00       	cmp    $0xff,%eax
  800569:	75 2c                	jne    800597 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80056b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80056f:	8b 00                	mov    (%rax),%eax
  800571:	48 98                	cltq   
  800573:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800577:	48 83 c2 08          	add    $0x8,%rdx
  80057b:	48 89 c6             	mov    %rax,%rsi
  80057e:	48 89 d7             	mov    %rdx,%rdi
  800581:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  800588:	00 00 00 
  80058b:	ff d0                	callq  *%rax
        b->idx = 0;
  80058d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800591:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80059b:	8b 40 04             	mov    0x4(%rax),%eax
  80059e:	8d 50 01             	lea    0x1(%rax),%edx
  8005a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a5:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005a8:	c9                   	leaveq 
  8005a9:	c3                   	retq   

00000000008005aa <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005aa:	55                   	push   %rbp
  8005ab:	48 89 e5             	mov    %rsp,%rbp
  8005ae:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005b5:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005bc:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005c3:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005ca:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005d1:	48 8b 0a             	mov    (%rdx),%rcx
  8005d4:	48 89 08             	mov    %rcx,(%rax)
  8005d7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005db:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005df:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005e3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005ee:	00 00 00 
    b.cnt = 0;
  8005f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005f8:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005fb:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800602:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800609:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800610:	48 89 c6             	mov    %rax,%rsi
  800613:	48 bf 31 05 80 00 00 	movabs $0x800531,%rdi
  80061a:	00 00 00 
  80061d:	48 b8 09 0a 80 00 00 	movabs $0x800a09,%rax
  800624:	00 00 00 
  800627:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800629:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80062f:	48 98                	cltq   
  800631:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800638:	48 83 c2 08          	add    $0x8,%rdx
  80063c:	48 89 c6             	mov    %rax,%rsi
  80063f:	48 89 d7             	mov    %rdx,%rdi
  800642:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  800649:	00 00 00 
  80064c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80064e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800654:	c9                   	leaveq 
  800655:	c3                   	retq   

0000000000800656 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800656:	55                   	push   %rbp
  800657:	48 89 e5             	mov    %rsp,%rbp
  80065a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800661:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800668:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80066f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800676:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80067d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800684:	84 c0                	test   %al,%al
  800686:	74 20                	je     8006a8 <cprintf+0x52>
  800688:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80068c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800690:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800694:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800698:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80069c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006a0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006a4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006a8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006af:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006b6:	00 00 00 
  8006b9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006c0:	00 00 00 
  8006c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006c7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006ce:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006d5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006dc:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006e3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006ea:	48 8b 0a             	mov    (%rdx),%rcx
  8006ed:	48 89 08             	mov    %rcx,(%rax)
  8006f0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006f4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006f8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006fc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800700:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800707:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80070e:	48 89 d6             	mov    %rdx,%rsi
  800711:	48 89 c7             	mov    %rax,%rdi
  800714:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  80071b:	00 00 00 
  80071e:	ff d0                	callq  *%rax
  800720:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800726:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80072c:	c9                   	leaveq 
  80072d:	c3                   	retq   

000000000080072e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80072e:	55                   	push   %rbp
  80072f:	48 89 e5             	mov    %rsp,%rbp
  800732:	53                   	push   %rbx
  800733:	48 83 ec 38          	sub    $0x38,%rsp
  800737:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80073b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80073f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800743:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800746:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80074a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80074e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800751:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800755:	77 3b                	ja     800792 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800757:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80075a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80075e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800761:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800765:	ba 00 00 00 00       	mov    $0x0,%edx
  80076a:	48 f7 f3             	div    %rbx
  80076d:	48 89 c2             	mov    %rax,%rdx
  800770:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800773:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800776:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80077a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077e:	41 89 f9             	mov    %edi,%r9d
  800781:	48 89 c7             	mov    %rax,%rdi
  800784:	48 b8 2e 07 80 00 00 	movabs $0x80072e,%rax
  80078b:	00 00 00 
  80078e:	ff d0                	callq  *%rax
  800790:	eb 1e                	jmp    8007b0 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800792:	eb 12                	jmp    8007a6 <printnum+0x78>
			putch(padc, putdat);
  800794:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800798:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 89 ce             	mov    %rcx,%rsi
  8007a2:	89 d7                	mov    %edx,%edi
  8007a4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007a6:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007aa:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007ae:	7f e4                	jg     800794 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007b0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bc:	48 f7 f1             	div    %rcx
  8007bf:	48 89 d0             	mov    %rdx,%rax
  8007c2:	48 ba 70 3d 80 00 00 	movabs $0x803d70,%rdx
  8007c9:	00 00 00 
  8007cc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007d0:	0f be d0             	movsbl %al,%edx
  8007d3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007db:	48 89 ce             	mov    %rcx,%rsi
  8007de:	89 d7                	mov    %edx,%edi
  8007e0:	ff d0                	callq  *%rax
}
  8007e2:	48 83 c4 38          	add    $0x38,%rsp
  8007e6:	5b                   	pop    %rbx
  8007e7:	5d                   	pop    %rbp
  8007e8:	c3                   	retq   

00000000008007e9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007e9:	55                   	push   %rbp
  8007ea:	48 89 e5             	mov    %rsp,%rbp
  8007ed:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007f5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007f8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007fc:	7e 52                	jle    800850 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800802:	8b 00                	mov    (%rax),%eax
  800804:	83 f8 30             	cmp    $0x30,%eax
  800807:	73 24                	jae    80082d <getuint+0x44>
  800809:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	8b 00                	mov    (%rax),%eax
  800817:	89 c0                	mov    %eax,%eax
  800819:	48 01 d0             	add    %rdx,%rax
  80081c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800820:	8b 12                	mov    (%rdx),%edx
  800822:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800825:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800829:	89 0a                	mov    %ecx,(%rdx)
  80082b:	eb 17                	jmp    800844 <getuint+0x5b>
  80082d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800831:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800835:	48 89 d0             	mov    %rdx,%rax
  800838:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800840:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800844:	48 8b 00             	mov    (%rax),%rax
  800847:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80084b:	e9 a3 00 00 00       	jmpq   8008f3 <getuint+0x10a>
	else if (lflag)
  800850:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800854:	74 4f                	je     8008a5 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085a:	8b 00                	mov    (%rax),%eax
  80085c:	83 f8 30             	cmp    $0x30,%eax
  80085f:	73 24                	jae    800885 <getuint+0x9c>
  800861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800865:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086d:	8b 00                	mov    (%rax),%eax
  80086f:	89 c0                	mov    %eax,%eax
  800871:	48 01 d0             	add    %rdx,%rax
  800874:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800878:	8b 12                	mov    (%rdx),%edx
  80087a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80087d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800881:	89 0a                	mov    %ecx,(%rdx)
  800883:	eb 17                	jmp    80089c <getuint+0xb3>
  800885:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800889:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80088d:	48 89 d0             	mov    %rdx,%rax
  800890:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800894:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800898:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80089c:	48 8b 00             	mov    (%rax),%rax
  80089f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008a3:	eb 4e                	jmp    8008f3 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a9:	8b 00                	mov    (%rax),%eax
  8008ab:	83 f8 30             	cmp    $0x30,%eax
  8008ae:	73 24                	jae    8008d4 <getuint+0xeb>
  8008b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bc:	8b 00                	mov    (%rax),%eax
  8008be:	89 c0                	mov    %eax,%eax
  8008c0:	48 01 d0             	add    %rdx,%rax
  8008c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c7:	8b 12                	mov    (%rdx),%edx
  8008c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d0:	89 0a                	mov    %ecx,(%rdx)
  8008d2:	eb 17                	jmp    8008eb <getuint+0x102>
  8008d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008dc:	48 89 d0             	mov    %rdx,%rax
  8008df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	89 c0                	mov    %eax,%eax
  8008ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008f7:	c9                   	leaveq 
  8008f8:	c3                   	retq   

00000000008008f9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f9:	55                   	push   %rbp
  8008fa:	48 89 e5             	mov    %rsp,%rbp
  8008fd:	48 83 ec 1c          	sub    $0x1c,%rsp
  800901:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800905:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800908:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80090c:	7e 52                	jle    800960 <getint+0x67>
		x=va_arg(*ap, long long);
  80090e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800912:	8b 00                	mov    (%rax),%eax
  800914:	83 f8 30             	cmp    $0x30,%eax
  800917:	73 24                	jae    80093d <getint+0x44>
  800919:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	8b 00                	mov    (%rax),%eax
  800927:	89 c0                	mov    %eax,%eax
  800929:	48 01 d0             	add    %rdx,%rax
  80092c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800930:	8b 12                	mov    (%rdx),%edx
  800932:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800935:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800939:	89 0a                	mov    %ecx,(%rdx)
  80093b:	eb 17                	jmp    800954 <getint+0x5b>
  80093d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800941:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800945:	48 89 d0             	mov    %rdx,%rax
  800948:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80094c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800950:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800954:	48 8b 00             	mov    (%rax),%rax
  800957:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80095b:	e9 a3 00 00 00       	jmpq   800a03 <getint+0x10a>
	else if (lflag)
  800960:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800964:	74 4f                	je     8009b5 <getint+0xbc>
		x=va_arg(*ap, long);
  800966:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096a:	8b 00                	mov    (%rax),%eax
  80096c:	83 f8 30             	cmp    $0x30,%eax
  80096f:	73 24                	jae    800995 <getint+0x9c>
  800971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800975:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	8b 00                	mov    (%rax),%eax
  80097f:	89 c0                	mov    %eax,%eax
  800981:	48 01 d0             	add    %rdx,%rax
  800984:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800988:	8b 12                	mov    (%rdx),%edx
  80098a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80098d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800991:	89 0a                	mov    %ecx,(%rdx)
  800993:	eb 17                	jmp    8009ac <getint+0xb3>
  800995:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800999:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80099d:	48 89 d0             	mov    %rdx,%rax
  8009a0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ac:	48 8b 00             	mov    (%rax),%rax
  8009af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009b3:	eb 4e                	jmp    800a03 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b9:	8b 00                	mov    (%rax),%eax
  8009bb:	83 f8 30             	cmp    $0x30,%eax
  8009be:	73 24                	jae    8009e4 <getint+0xeb>
  8009c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	8b 00                	mov    (%rax),%eax
  8009ce:	89 c0                	mov    %eax,%eax
  8009d0:	48 01 d0             	add    %rdx,%rax
  8009d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d7:	8b 12                	mov    (%rdx),%edx
  8009d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e0:	89 0a                	mov    %ecx,(%rdx)
  8009e2:	eb 17                	jmp    8009fb <getint+0x102>
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ec:	48 89 d0             	mov    %rdx,%rax
  8009ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009fb:	8b 00                	mov    (%rax),%eax
  8009fd:	48 98                	cltq   
  8009ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a07:	c9                   	leaveq 
  800a08:	c3                   	retq   

0000000000800a09 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a09:	55                   	push   %rbp
  800a0a:	48 89 e5             	mov    %rsp,%rbp
  800a0d:	41 54                	push   %r12
  800a0f:	53                   	push   %rbx
  800a10:	48 83 ec 60          	sub    $0x60,%rsp
  800a14:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a18:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a1c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a20:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a24:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a28:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a2c:	48 8b 0a             	mov    (%rdx),%rcx
  800a2f:	48 89 08             	mov    %rcx,(%rax)
  800a32:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a36:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a3a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a3e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a42:	eb 17                	jmp    800a5b <vprintfmt+0x52>
			if (ch == '\0')
  800a44:	85 db                	test   %ebx,%ebx
  800a46:	0f 84 cc 04 00 00    	je     800f18 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a4c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a54:	48 89 d6             	mov    %rdx,%rsi
  800a57:	89 df                	mov    %ebx,%edi
  800a59:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a5b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a5f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a63:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a67:	0f b6 00             	movzbl (%rax),%eax
  800a6a:	0f b6 d8             	movzbl %al,%ebx
  800a6d:	83 fb 25             	cmp    $0x25,%ebx
  800a70:	75 d2                	jne    800a44 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a72:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a76:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a7d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a8b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a92:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a96:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a9a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a9e:	0f b6 00             	movzbl (%rax),%eax
  800aa1:	0f b6 d8             	movzbl %al,%ebx
  800aa4:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800aa7:	83 f8 55             	cmp    $0x55,%eax
  800aaa:	0f 87 34 04 00 00    	ja     800ee4 <vprintfmt+0x4db>
  800ab0:	89 c0                	mov    %eax,%eax
  800ab2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ab9:	00 
  800aba:	48 b8 98 3d 80 00 00 	movabs $0x803d98,%rax
  800ac1:	00 00 00 
  800ac4:	48 01 d0             	add    %rdx,%rax
  800ac7:	48 8b 00             	mov    (%rax),%rax
  800aca:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800acc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ad0:	eb c0                	jmp    800a92 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ad2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ad6:	eb ba                	jmp    800a92 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800adf:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	c1 e0 02             	shl    $0x2,%eax
  800ae7:	01 d0                	add    %edx,%eax
  800ae9:	01 c0                	add    %eax,%eax
  800aeb:	01 d8                	add    %ebx,%eax
  800aed:	83 e8 30             	sub    $0x30,%eax
  800af0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800af3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800af7:	0f b6 00             	movzbl (%rax),%eax
  800afa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800afd:	83 fb 2f             	cmp    $0x2f,%ebx
  800b00:	7e 0c                	jle    800b0e <vprintfmt+0x105>
  800b02:	83 fb 39             	cmp    $0x39,%ebx
  800b05:	7f 07                	jg     800b0e <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b07:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b0c:	eb d1                	jmp    800adf <vprintfmt+0xd6>
			goto process_precision;
  800b0e:	eb 58                	jmp    800b68 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b13:	83 f8 30             	cmp    $0x30,%eax
  800b16:	73 17                	jae    800b2f <vprintfmt+0x126>
  800b18:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1f:	89 c0                	mov    %eax,%eax
  800b21:	48 01 d0             	add    %rdx,%rax
  800b24:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b27:	83 c2 08             	add    $0x8,%edx
  800b2a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b2d:	eb 0f                	jmp    800b3e <vprintfmt+0x135>
  800b2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b33:	48 89 d0             	mov    %rdx,%rax
  800b36:	48 83 c2 08          	add    $0x8,%rdx
  800b3a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b3e:	8b 00                	mov    (%rax),%eax
  800b40:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b43:	eb 23                	jmp    800b68 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b45:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b49:	79 0c                	jns    800b57 <vprintfmt+0x14e>
				width = 0;
  800b4b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b52:	e9 3b ff ff ff       	jmpq   800a92 <vprintfmt+0x89>
  800b57:	e9 36 ff ff ff       	jmpq   800a92 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b5c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b63:	e9 2a ff ff ff       	jmpq   800a92 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b68:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b6c:	79 12                	jns    800b80 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b6e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b71:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b74:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b7b:	e9 12 ff ff ff       	jmpq   800a92 <vprintfmt+0x89>
  800b80:	e9 0d ff ff ff       	jmpq   800a92 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b85:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b89:	e9 04 ff ff ff       	jmpq   800a92 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b91:	83 f8 30             	cmp    $0x30,%eax
  800b94:	73 17                	jae    800bad <vprintfmt+0x1a4>
  800b96:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9d:	89 c0                	mov    %eax,%eax
  800b9f:	48 01 d0             	add    %rdx,%rax
  800ba2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba5:	83 c2 08             	add    $0x8,%edx
  800ba8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bab:	eb 0f                	jmp    800bbc <vprintfmt+0x1b3>
  800bad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb1:	48 89 d0             	mov    %rdx,%rax
  800bb4:	48 83 c2 08          	add    $0x8,%rdx
  800bb8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bbc:	8b 10                	mov    (%rax),%edx
  800bbe:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc6:	48 89 ce             	mov    %rcx,%rsi
  800bc9:	89 d7                	mov    %edx,%edi
  800bcb:	ff d0                	callq  *%rax
			break;
  800bcd:	e9 40 03 00 00       	jmpq   800f12 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bd2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd5:	83 f8 30             	cmp    $0x30,%eax
  800bd8:	73 17                	jae    800bf1 <vprintfmt+0x1e8>
  800bda:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bde:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be1:	89 c0                	mov    %eax,%eax
  800be3:	48 01 d0             	add    %rdx,%rax
  800be6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800be9:	83 c2 08             	add    $0x8,%edx
  800bec:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bef:	eb 0f                	jmp    800c00 <vprintfmt+0x1f7>
  800bf1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bf5:	48 89 d0             	mov    %rdx,%rax
  800bf8:	48 83 c2 08          	add    $0x8,%rdx
  800bfc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c00:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c02:	85 db                	test   %ebx,%ebx
  800c04:	79 02                	jns    800c08 <vprintfmt+0x1ff>
				err = -err;
  800c06:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c08:	83 fb 15             	cmp    $0x15,%ebx
  800c0b:	7f 16                	jg     800c23 <vprintfmt+0x21a>
  800c0d:	48 b8 c0 3c 80 00 00 	movabs $0x803cc0,%rax
  800c14:	00 00 00 
  800c17:	48 63 d3             	movslq %ebx,%rdx
  800c1a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c1e:	4d 85 e4             	test   %r12,%r12
  800c21:	75 2e                	jne    800c51 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c23:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2b:	89 d9                	mov    %ebx,%ecx
  800c2d:	48 ba 81 3d 80 00 00 	movabs $0x803d81,%rdx
  800c34:	00 00 00 
  800c37:	48 89 c7             	mov    %rax,%rdi
  800c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3f:	49 b8 21 0f 80 00 00 	movabs $0x800f21,%r8
  800c46:	00 00 00 
  800c49:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c4c:	e9 c1 02 00 00       	jmpq   800f12 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c51:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c59:	4c 89 e1             	mov    %r12,%rcx
  800c5c:	48 ba 8a 3d 80 00 00 	movabs $0x803d8a,%rdx
  800c63:	00 00 00 
  800c66:	48 89 c7             	mov    %rax,%rdi
  800c69:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6e:	49 b8 21 0f 80 00 00 	movabs $0x800f21,%r8
  800c75:	00 00 00 
  800c78:	41 ff d0             	callq  *%r8
			break;
  800c7b:	e9 92 02 00 00       	jmpq   800f12 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c80:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c83:	83 f8 30             	cmp    $0x30,%eax
  800c86:	73 17                	jae    800c9f <vprintfmt+0x296>
  800c88:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8f:	89 c0                	mov    %eax,%eax
  800c91:	48 01 d0             	add    %rdx,%rax
  800c94:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c97:	83 c2 08             	add    $0x8,%edx
  800c9a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c9d:	eb 0f                	jmp    800cae <vprintfmt+0x2a5>
  800c9f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca3:	48 89 d0             	mov    %rdx,%rax
  800ca6:	48 83 c2 08          	add    $0x8,%rdx
  800caa:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cae:	4c 8b 20             	mov    (%rax),%r12
  800cb1:	4d 85 e4             	test   %r12,%r12
  800cb4:	75 0a                	jne    800cc0 <vprintfmt+0x2b7>
				p = "(null)";
  800cb6:	49 bc 8d 3d 80 00 00 	movabs $0x803d8d,%r12
  800cbd:	00 00 00 
			if (width > 0 && padc != '-')
  800cc0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cc4:	7e 3f                	jle    800d05 <vprintfmt+0x2fc>
  800cc6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cca:	74 39                	je     800d05 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ccc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ccf:	48 98                	cltq   
  800cd1:	48 89 c6             	mov    %rax,%rsi
  800cd4:	4c 89 e7             	mov    %r12,%rdi
  800cd7:	48 b8 cd 11 80 00 00 	movabs $0x8011cd,%rax
  800cde:	00 00 00 
  800ce1:	ff d0                	callq  *%rax
  800ce3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ce6:	eb 17                	jmp    800cff <vprintfmt+0x2f6>
					putch(padc, putdat);
  800ce8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cec:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cf0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf4:	48 89 ce             	mov    %rcx,%rsi
  800cf7:	89 d7                	mov    %edx,%edi
  800cf9:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cfb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d03:	7f e3                	jg     800ce8 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d05:	eb 37                	jmp    800d3e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d07:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d0b:	74 1e                	je     800d2b <vprintfmt+0x322>
  800d0d:	83 fb 1f             	cmp    $0x1f,%ebx
  800d10:	7e 05                	jle    800d17 <vprintfmt+0x30e>
  800d12:	83 fb 7e             	cmp    $0x7e,%ebx
  800d15:	7e 14                	jle    800d2b <vprintfmt+0x322>
					putch('?', putdat);
  800d17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1f:	48 89 d6             	mov    %rdx,%rsi
  800d22:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d27:	ff d0                	callq  *%rax
  800d29:	eb 0f                	jmp    800d3a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d2b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d33:	48 89 d6             	mov    %rdx,%rsi
  800d36:	89 df                	mov    %ebx,%edi
  800d38:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d3a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d3e:	4c 89 e0             	mov    %r12,%rax
  800d41:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d45:	0f b6 00             	movzbl (%rax),%eax
  800d48:	0f be d8             	movsbl %al,%ebx
  800d4b:	85 db                	test   %ebx,%ebx
  800d4d:	74 10                	je     800d5f <vprintfmt+0x356>
  800d4f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d53:	78 b2                	js     800d07 <vprintfmt+0x2fe>
  800d55:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d59:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d5d:	79 a8                	jns    800d07 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d5f:	eb 16                	jmp    800d77 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d61:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d69:	48 89 d6             	mov    %rdx,%rsi
  800d6c:	bf 20 00 00 00       	mov    $0x20,%edi
  800d71:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d73:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d77:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d7b:	7f e4                	jg     800d61 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d7d:	e9 90 01 00 00       	jmpq   800f12 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d82:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d86:	be 03 00 00 00       	mov    $0x3,%esi
  800d8b:	48 89 c7             	mov    %rax,%rdi
  800d8e:	48 b8 f9 08 80 00 00 	movabs $0x8008f9,%rax
  800d95:	00 00 00 
  800d98:	ff d0                	callq  *%rax
  800d9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da2:	48 85 c0             	test   %rax,%rax
  800da5:	79 1d                	jns    800dc4 <vprintfmt+0x3bb>
				putch('-', putdat);
  800da7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800daf:	48 89 d6             	mov    %rdx,%rsi
  800db2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800db7:	ff d0                	callq  *%rax
				num = -(long long) num;
  800db9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dbd:	48 f7 d8             	neg    %rax
  800dc0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dc4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dcb:	e9 d5 00 00 00       	jmpq   800ea5 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dd0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dd4:	be 03 00 00 00       	mov    $0x3,%esi
  800dd9:	48 89 c7             	mov    %rax,%rdi
  800ddc:	48 b8 e9 07 80 00 00 	movabs $0x8007e9,%rax
  800de3:	00 00 00 
  800de6:	ff d0                	callq  *%rax
  800de8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dec:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800df3:	e9 ad 00 00 00       	jmpq   800ea5 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800df8:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800dfb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dff:	89 d6                	mov    %edx,%esi
  800e01:	48 89 c7             	mov    %rax,%rdi
  800e04:	48 b8 f9 08 80 00 00 	movabs $0x8008f9,%rax
  800e0b:	00 00 00 
  800e0e:	ff d0                	callq  *%rax
  800e10:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e14:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e1b:	e9 85 00 00 00       	jmpq   800ea5 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800e20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e28:	48 89 d6             	mov    %rdx,%rsi
  800e2b:	bf 30 00 00 00       	mov    $0x30,%edi
  800e30:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3a:	48 89 d6             	mov    %rdx,%rsi
  800e3d:	bf 78 00 00 00       	mov    $0x78,%edi
  800e42:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e47:	83 f8 30             	cmp    $0x30,%eax
  800e4a:	73 17                	jae    800e63 <vprintfmt+0x45a>
  800e4c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e53:	89 c0                	mov    %eax,%eax
  800e55:	48 01 d0             	add    %rdx,%rax
  800e58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e5b:	83 c2 08             	add    $0x8,%edx
  800e5e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e61:	eb 0f                	jmp    800e72 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e63:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e67:	48 89 d0             	mov    %rdx,%rax
  800e6a:	48 83 c2 08          	add    $0x8,%rdx
  800e6e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e72:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e79:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e80:	eb 23                	jmp    800ea5 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e82:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e86:	be 03 00 00 00       	mov    $0x3,%esi
  800e8b:	48 89 c7             	mov    %rax,%rdi
  800e8e:	48 b8 e9 07 80 00 00 	movabs $0x8007e9,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
  800e9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e9e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ea5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800eaa:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ead:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800eb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eb4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800eb8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebc:	45 89 c1             	mov    %r8d,%r9d
  800ebf:	41 89 f8             	mov    %edi,%r8d
  800ec2:	48 89 c7             	mov    %rax,%rdi
  800ec5:	48 b8 2e 07 80 00 00 	movabs $0x80072e,%rax
  800ecc:	00 00 00 
  800ecf:	ff d0                	callq  *%rax
			break;
  800ed1:	eb 3f                	jmp    800f12 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ed3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edb:	48 89 d6             	mov    %rdx,%rsi
  800ede:	89 df                	mov    %ebx,%edi
  800ee0:	ff d0                	callq  *%rax
			break;
  800ee2:	eb 2e                	jmp    800f12 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ee4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eec:	48 89 d6             	mov    %rdx,%rsi
  800eef:	bf 25 00 00 00       	mov    $0x25,%edi
  800ef4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ef6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800efb:	eb 05                	jmp    800f02 <vprintfmt+0x4f9>
  800efd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f02:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f06:	48 83 e8 01          	sub    $0x1,%rax
  800f0a:	0f b6 00             	movzbl (%rax),%eax
  800f0d:	3c 25                	cmp    $0x25,%al
  800f0f:	75 ec                	jne    800efd <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800f11:	90                   	nop
		}
	}
  800f12:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f13:	e9 43 fb ff ff       	jmpq   800a5b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f18:	48 83 c4 60          	add    $0x60,%rsp
  800f1c:	5b                   	pop    %rbx
  800f1d:	41 5c                	pop    %r12
  800f1f:	5d                   	pop    %rbp
  800f20:	c3                   	retq   

0000000000800f21 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f21:	55                   	push   %rbp
  800f22:	48 89 e5             	mov    %rsp,%rbp
  800f25:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f2c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f33:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f3a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f41:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f48:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f4f:	84 c0                	test   %al,%al
  800f51:	74 20                	je     800f73 <printfmt+0x52>
  800f53:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f57:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f5b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f5f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f63:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f67:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f6b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f6f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f73:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f7a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f81:	00 00 00 
  800f84:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f8b:	00 00 00 
  800f8e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f92:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f99:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fa7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fae:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fb5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fbc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fc3:	48 89 c7             	mov    %rax,%rdi
  800fc6:	48 b8 09 0a 80 00 00 	movabs $0x800a09,%rax
  800fcd:	00 00 00 
  800fd0:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fd2:	c9                   	leaveq 
  800fd3:	c3                   	retq   

0000000000800fd4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd4:	55                   	push   %rbp
  800fd5:	48 89 e5             	mov    %rsp,%rbp
  800fd8:	48 83 ec 10          	sub    $0x10,%rsp
  800fdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fe3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe7:	8b 40 10             	mov    0x10(%rax),%eax
  800fea:	8d 50 01             	lea    0x1(%rax),%edx
  800fed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ff4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff8:	48 8b 10             	mov    (%rax),%rdx
  800ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fff:	48 8b 40 08          	mov    0x8(%rax),%rax
  801003:	48 39 c2             	cmp    %rax,%rdx
  801006:	73 17                	jae    80101f <sprintputch+0x4b>
		*b->buf++ = ch;
  801008:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100c:	48 8b 00             	mov    (%rax),%rax
  80100f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801013:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801017:	48 89 0a             	mov    %rcx,(%rdx)
  80101a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80101d:	88 10                	mov    %dl,(%rax)
}
  80101f:	c9                   	leaveq 
  801020:	c3                   	retq   

0000000000801021 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801021:	55                   	push   %rbp
  801022:	48 89 e5             	mov    %rsp,%rbp
  801025:	48 83 ec 50          	sub    $0x50,%rsp
  801029:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80102d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801030:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801034:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801038:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80103c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801040:	48 8b 0a             	mov    (%rdx),%rcx
  801043:	48 89 08             	mov    %rcx,(%rax)
  801046:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80104a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80104e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801052:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801056:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80105a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80105e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801061:	48 98                	cltq   
  801063:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801067:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80106b:	48 01 d0             	add    %rdx,%rax
  80106e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801072:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801079:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80107e:	74 06                	je     801086 <vsnprintf+0x65>
  801080:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801084:	7f 07                	jg     80108d <vsnprintf+0x6c>
		return -E_INVAL;
  801086:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108b:	eb 2f                	jmp    8010bc <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80108d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801091:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801095:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801099:	48 89 c6             	mov    %rax,%rsi
  80109c:	48 bf d4 0f 80 00 00 	movabs $0x800fd4,%rdi
  8010a3:	00 00 00 
  8010a6:	48 b8 09 0a 80 00 00 	movabs $0x800a09,%rax
  8010ad:	00 00 00 
  8010b0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010b6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010b9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010bc:	c9                   	leaveq 
  8010bd:	c3                   	retq   

00000000008010be <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010be:	55                   	push   %rbp
  8010bf:	48 89 e5             	mov    %rsp,%rbp
  8010c2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010c9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010d0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010d6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010dd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010e4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010eb:	84 c0                	test   %al,%al
  8010ed:	74 20                	je     80110f <snprintf+0x51>
  8010ef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010f3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010f7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010fb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010ff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801103:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801107:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80110b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80110f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801116:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80111d:	00 00 00 
  801120:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801127:	00 00 00 
  80112a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80112e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801135:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80113c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801143:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80114a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801151:	48 8b 0a             	mov    (%rdx),%rcx
  801154:	48 89 08             	mov    %rcx,(%rax)
  801157:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80115b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80115f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801163:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801167:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80116e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801175:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80117b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801182:	48 89 c7             	mov    %rax,%rdi
  801185:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  80118c:	00 00 00 
  80118f:	ff d0                	callq  *%rax
  801191:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801197:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80119d:	c9                   	leaveq 
  80119e:	c3                   	retq   

000000000080119f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80119f:	55                   	push   %rbp
  8011a0:	48 89 e5             	mov    %rsp,%rbp
  8011a3:	48 83 ec 18          	sub    $0x18,%rsp
  8011a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011b2:	eb 09                	jmp    8011bd <strlen+0x1e>
		n++;
  8011b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c1:	0f b6 00             	movzbl (%rax),%eax
  8011c4:	84 c0                	test   %al,%al
  8011c6:	75 ec                	jne    8011b4 <strlen+0x15>
		n++;
	return n;
  8011c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011cb:	c9                   	leaveq 
  8011cc:	c3                   	retq   

00000000008011cd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011cd:	55                   	push   %rbp
  8011ce:	48 89 e5             	mov    %rsp,%rbp
  8011d1:	48 83 ec 20          	sub    $0x20,%rsp
  8011d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011e4:	eb 0e                	jmp    8011f4 <strnlen+0x27>
		n++;
  8011e6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ef:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011f4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011f9:	74 0b                	je     801206 <strnlen+0x39>
  8011fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ff:	0f b6 00             	movzbl (%rax),%eax
  801202:	84 c0                	test   %al,%al
  801204:	75 e0                	jne    8011e6 <strnlen+0x19>
		n++;
	return n;
  801206:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801209:	c9                   	leaveq 
  80120a:	c3                   	retq   

000000000080120b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80120b:	55                   	push   %rbp
  80120c:	48 89 e5             	mov    %rsp,%rbp
  80120f:	48 83 ec 20          	sub    $0x20,%rsp
  801213:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801217:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80121b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801223:	90                   	nop
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80122c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801230:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801234:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801238:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80123c:	0f b6 12             	movzbl (%rdx),%edx
  80123f:	88 10                	mov    %dl,(%rax)
  801241:	0f b6 00             	movzbl (%rax),%eax
  801244:	84 c0                	test   %al,%al
  801246:	75 dc                	jne    801224 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80124c:	c9                   	leaveq 
  80124d:	c3                   	retq   

000000000080124e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80124e:	55                   	push   %rbp
  80124f:	48 89 e5             	mov    %rsp,%rbp
  801252:	48 83 ec 20          	sub    $0x20,%rsp
  801256:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80125a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80125e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801262:	48 89 c7             	mov    %rax,%rdi
  801265:	48 b8 9f 11 80 00 00 	movabs $0x80119f,%rax
  80126c:	00 00 00 
  80126f:	ff d0                	callq  *%rax
  801271:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801274:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801277:	48 63 d0             	movslq %eax,%rdx
  80127a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127e:	48 01 c2             	add    %rax,%rdx
  801281:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801285:	48 89 c6             	mov    %rax,%rsi
  801288:	48 89 d7             	mov    %rdx,%rdi
  80128b:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  801292:	00 00 00 
  801295:	ff d0                	callq  *%rax
	return dst;
  801297:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80129b:	c9                   	leaveq 
  80129c:	c3                   	retq   

000000000080129d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	48 83 ec 28          	sub    $0x28,%rsp
  8012a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012b9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012c0:	00 
  8012c1:	eb 2a                	jmp    8012ed <strncpy+0x50>
		*dst++ = *src;
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012d3:	0f b6 12             	movzbl (%rdx),%edx
  8012d6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012dc:	0f b6 00             	movzbl (%rax),%eax
  8012df:	84 c0                	test   %al,%al
  8012e1:	74 05                	je     8012e8 <strncpy+0x4b>
			src++;
  8012e3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012f5:	72 cc                	jb     8012c3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012fb:	c9                   	leaveq 
  8012fc:	c3                   	retq   

00000000008012fd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012fd:	55                   	push   %rbp
  8012fe:	48 89 e5             	mov    %rsp,%rbp
  801301:	48 83 ec 28          	sub    $0x28,%rsp
  801305:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801309:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80130d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801315:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801319:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80131e:	74 3d                	je     80135d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801320:	eb 1d                	jmp    80133f <strlcpy+0x42>
			*dst++ = *src++;
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80132a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80132e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801332:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801336:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80133a:	0f b6 12             	movzbl (%rdx),%edx
  80133d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80133f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801344:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801349:	74 0b                	je     801356 <strlcpy+0x59>
  80134b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80134f:	0f b6 00             	movzbl (%rax),%eax
  801352:	84 c0                	test   %al,%al
  801354:	75 cc                	jne    801322 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801356:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80135d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801361:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801365:	48 29 c2             	sub    %rax,%rdx
  801368:	48 89 d0             	mov    %rdx,%rax
}
  80136b:	c9                   	leaveq 
  80136c:	c3                   	retq   

000000000080136d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136d:	55                   	push   %rbp
  80136e:	48 89 e5             	mov    %rsp,%rbp
  801371:	48 83 ec 10          	sub    $0x10,%rsp
  801375:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801379:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80137d:	eb 0a                	jmp    801389 <strcmp+0x1c>
		p++, q++;
  80137f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801384:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	84 c0                	test   %al,%al
  801392:	74 12                	je     8013a6 <strcmp+0x39>
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801398:	0f b6 10             	movzbl (%rax),%edx
  80139b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139f:	0f b6 00             	movzbl (%rax),%eax
  8013a2:	38 c2                	cmp    %al,%dl
  8013a4:	74 d9                	je     80137f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013aa:	0f b6 00             	movzbl (%rax),%eax
  8013ad:	0f b6 d0             	movzbl %al,%edx
  8013b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b4:	0f b6 00             	movzbl (%rax),%eax
  8013b7:	0f b6 c0             	movzbl %al,%eax
  8013ba:	29 c2                	sub    %eax,%edx
  8013bc:	89 d0                	mov    %edx,%eax
}
  8013be:	c9                   	leaveq 
  8013bf:	c3                   	retq   

00000000008013c0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013c0:	55                   	push   %rbp
  8013c1:	48 89 e5             	mov    %rsp,%rbp
  8013c4:	48 83 ec 18          	sub    $0x18,%rsp
  8013c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013d4:	eb 0f                	jmp    8013e5 <strncmp+0x25>
		n--, p++, q++;
  8013d6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ea:	74 1d                	je     801409 <strncmp+0x49>
  8013ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	84 c0                	test   %al,%al
  8013f5:	74 12                	je     801409 <strncmp+0x49>
  8013f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fb:	0f b6 10             	movzbl (%rax),%edx
  8013fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801402:	0f b6 00             	movzbl (%rax),%eax
  801405:	38 c2                	cmp    %al,%dl
  801407:	74 cd                	je     8013d6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801409:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80140e:	75 07                	jne    801417 <strncmp+0x57>
		return 0;
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	eb 18                	jmp    80142f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141b:	0f b6 00             	movzbl (%rax),%eax
  80141e:	0f b6 d0             	movzbl %al,%edx
  801421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801425:	0f b6 00             	movzbl (%rax),%eax
  801428:	0f b6 c0             	movzbl %al,%eax
  80142b:	29 c2                	sub    %eax,%edx
  80142d:	89 d0                	mov    %edx,%eax
}
  80142f:	c9                   	leaveq 
  801430:	c3                   	retq   

0000000000801431 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801431:	55                   	push   %rbp
  801432:	48 89 e5             	mov    %rsp,%rbp
  801435:	48 83 ec 0c          	sub    $0xc,%rsp
  801439:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143d:	89 f0                	mov    %esi,%eax
  80143f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801442:	eb 17                	jmp    80145b <strchr+0x2a>
		if (*s == c)
  801444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801448:	0f b6 00             	movzbl (%rax),%eax
  80144b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80144e:	75 06                	jne    801456 <strchr+0x25>
			return (char *) s;
  801450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801454:	eb 15                	jmp    80146b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801456:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80145b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145f:	0f b6 00             	movzbl (%rax),%eax
  801462:	84 c0                	test   %al,%al
  801464:	75 de                	jne    801444 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146b:	c9                   	leaveq 
  80146c:	c3                   	retq   

000000000080146d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80146d:	55                   	push   %rbp
  80146e:	48 89 e5             	mov    %rsp,%rbp
  801471:	48 83 ec 0c          	sub    $0xc,%rsp
  801475:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801479:	89 f0                	mov    %esi,%eax
  80147b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80147e:	eb 13                	jmp    801493 <strfind+0x26>
		if (*s == c)
  801480:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801484:	0f b6 00             	movzbl (%rax),%eax
  801487:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80148a:	75 02                	jne    80148e <strfind+0x21>
			break;
  80148c:	eb 10                	jmp    80149e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80148e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801497:	0f b6 00             	movzbl (%rax),%eax
  80149a:	84 c0                	test   %al,%al
  80149c:	75 e2                	jne    801480 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80149e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014a2:	c9                   	leaveq 
  8014a3:	c3                   	retq   

00000000008014a4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014a4:	55                   	push   %rbp
  8014a5:	48 89 e5             	mov    %rsp,%rbp
  8014a8:	48 83 ec 18          	sub    $0x18,%rsp
  8014ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014bc:	75 06                	jne    8014c4 <memset+0x20>
		return v;
  8014be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c2:	eb 69                	jmp    80152d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	83 e0 03             	and    $0x3,%eax
  8014cb:	48 85 c0             	test   %rax,%rax
  8014ce:	75 48                	jne    801518 <memset+0x74>
  8014d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d4:	83 e0 03             	and    $0x3,%eax
  8014d7:	48 85 c0             	test   %rax,%rax
  8014da:	75 3c                	jne    801518 <memset+0x74>
		c &= 0xFF;
  8014dc:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e6:	c1 e0 18             	shl    $0x18,%eax
  8014e9:	89 c2                	mov    %eax,%edx
  8014eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ee:	c1 e0 10             	shl    $0x10,%eax
  8014f1:	09 c2                	or     %eax,%edx
  8014f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f6:	c1 e0 08             	shl    $0x8,%eax
  8014f9:	09 d0                	or     %edx,%eax
  8014fb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801502:	48 c1 e8 02          	shr    $0x2,%rax
  801506:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801509:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801510:	48 89 d7             	mov    %rdx,%rdi
  801513:	fc                   	cld    
  801514:	f3 ab                	rep stos %eax,%es:(%rdi)
  801516:	eb 11                	jmp    801529 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801518:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80151c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80151f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801523:	48 89 d7             	mov    %rdx,%rdi
  801526:	fc                   	cld    
  801527:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80152d:	c9                   	leaveq 
  80152e:	c3                   	retq   

000000000080152f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80152f:	55                   	push   %rbp
  801530:	48 89 e5             	mov    %rsp,%rbp
  801533:	48 83 ec 28          	sub    $0x28,%rsp
  801537:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80153b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80153f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801543:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801547:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80154b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801553:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801557:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80155b:	0f 83 88 00 00 00    	jae    8015e9 <memmove+0xba>
  801561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801565:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801569:	48 01 d0             	add    %rdx,%rax
  80156c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801570:	76 77                	jbe    8015e9 <memmove+0xba>
		s += n;
  801572:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801576:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80157a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801586:	83 e0 03             	and    $0x3,%eax
  801589:	48 85 c0             	test   %rax,%rax
  80158c:	75 3b                	jne    8015c9 <memmove+0x9a>
  80158e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801592:	83 e0 03             	and    $0x3,%eax
  801595:	48 85 c0             	test   %rax,%rax
  801598:	75 2f                	jne    8015c9 <memmove+0x9a>
  80159a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159e:	83 e0 03             	and    $0x3,%eax
  8015a1:	48 85 c0             	test   %rax,%rax
  8015a4:	75 23                	jne    8015c9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015aa:	48 83 e8 04          	sub    $0x4,%rax
  8015ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b2:	48 83 ea 04          	sub    $0x4,%rdx
  8015b6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015ba:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015be:	48 89 c7             	mov    %rax,%rdi
  8015c1:	48 89 d6             	mov    %rdx,%rsi
  8015c4:	fd                   	std    
  8015c5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015c7:	eb 1d                	jmp    8015e6 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015cd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	48 89 d7             	mov    %rdx,%rdi
  8015e0:	48 89 c1             	mov    %rax,%rcx
  8015e3:	fd                   	std    
  8015e4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015e6:	fc                   	cld    
  8015e7:	eb 57                	jmp    801640 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ed:	83 e0 03             	and    $0x3,%eax
  8015f0:	48 85 c0             	test   %rax,%rax
  8015f3:	75 36                	jne    80162b <memmove+0xfc>
  8015f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f9:	83 e0 03             	and    $0x3,%eax
  8015fc:	48 85 c0             	test   %rax,%rax
  8015ff:	75 2a                	jne    80162b <memmove+0xfc>
  801601:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801605:	83 e0 03             	and    $0x3,%eax
  801608:	48 85 c0             	test   %rax,%rax
  80160b:	75 1e                	jne    80162b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	48 c1 e8 02          	shr    $0x2,%rax
  801615:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801618:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801620:	48 89 c7             	mov    %rax,%rdi
  801623:	48 89 d6             	mov    %rdx,%rsi
  801626:	fc                   	cld    
  801627:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801629:	eb 15                	jmp    801640 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80162b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801633:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801637:	48 89 c7             	mov    %rax,%rdi
  80163a:	48 89 d6             	mov    %rdx,%rsi
  80163d:	fc                   	cld    
  80163e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801644:	c9                   	leaveq 
  801645:	c3                   	retq   

0000000000801646 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801646:	55                   	push   %rbp
  801647:	48 89 e5             	mov    %rsp,%rbp
  80164a:	48 83 ec 18          	sub    $0x18,%rsp
  80164e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801652:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801656:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80165a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80165e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801666:	48 89 ce             	mov    %rcx,%rsi
  801669:	48 89 c7             	mov    %rax,%rdi
  80166c:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  801673:	00 00 00 
  801676:	ff d0                	callq  *%rax
}
  801678:	c9                   	leaveq 
  801679:	c3                   	retq   

000000000080167a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80167a:	55                   	push   %rbp
  80167b:	48 89 e5             	mov    %rsp,%rbp
  80167e:	48 83 ec 28          	sub    $0x28,%rsp
  801682:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801686:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80168a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80168e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801692:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801696:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80169a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80169e:	eb 36                	jmp    8016d6 <memcmp+0x5c>
		if (*s1 != *s2)
  8016a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a4:	0f b6 10             	movzbl (%rax),%edx
  8016a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ab:	0f b6 00             	movzbl (%rax),%eax
  8016ae:	38 c2                	cmp    %al,%dl
  8016b0:	74 1a                	je     8016cc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b6:	0f b6 00             	movzbl (%rax),%eax
  8016b9:	0f b6 d0             	movzbl %al,%edx
  8016bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c0:	0f b6 00             	movzbl (%rax),%eax
  8016c3:	0f b6 c0             	movzbl %al,%eax
  8016c6:	29 c2                	sub    %eax,%edx
  8016c8:	89 d0                	mov    %edx,%eax
  8016ca:	eb 20                	jmp    8016ec <memcmp+0x72>
		s1++, s2++;
  8016cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016d1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016da:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016e2:	48 85 c0             	test   %rax,%rax
  8016e5:	75 b9                	jne    8016a0 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ec:	c9                   	leaveq 
  8016ed:	c3                   	retq   

00000000008016ee <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016ee:	55                   	push   %rbp
  8016ef:	48 89 e5             	mov    %rsp,%rbp
  8016f2:	48 83 ec 28          	sub    $0x28,%rsp
  8016f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016fa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801701:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801705:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801709:	48 01 d0             	add    %rdx,%rax
  80170c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801710:	eb 15                	jmp    801727 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801716:	0f b6 10             	movzbl (%rax),%edx
  801719:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80171c:	38 c2                	cmp    %al,%dl
  80171e:	75 02                	jne    801722 <memfind+0x34>
			break;
  801720:	eb 0f                	jmp    801731 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801722:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801727:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80172f:	72 e1                	jb     801712 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801735:	c9                   	leaveq 
  801736:	c3                   	retq   

0000000000801737 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801737:	55                   	push   %rbp
  801738:	48 89 e5             	mov    %rsp,%rbp
  80173b:	48 83 ec 34          	sub    $0x34,%rsp
  80173f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801743:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801747:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80174a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801751:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801758:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801759:	eb 05                	jmp    801760 <strtol+0x29>
		s++;
  80175b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801764:	0f b6 00             	movzbl (%rax),%eax
  801767:	3c 20                	cmp    $0x20,%al
  801769:	74 f0                	je     80175b <strtol+0x24>
  80176b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176f:	0f b6 00             	movzbl (%rax),%eax
  801772:	3c 09                	cmp    $0x9,%al
  801774:	74 e5                	je     80175b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	3c 2b                	cmp    $0x2b,%al
  80177f:	75 07                	jne    801788 <strtol+0x51>
		s++;
  801781:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801786:	eb 17                	jmp    80179f <strtol+0x68>
	else if (*s == '-')
  801788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178c:	0f b6 00             	movzbl (%rax),%eax
  80178f:	3c 2d                	cmp    $0x2d,%al
  801791:	75 0c                	jne    80179f <strtol+0x68>
		s++, neg = 1;
  801793:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801798:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80179f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017a3:	74 06                	je     8017ab <strtol+0x74>
  8017a5:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017a9:	75 28                	jne    8017d3 <strtol+0x9c>
  8017ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017af:	0f b6 00             	movzbl (%rax),%eax
  8017b2:	3c 30                	cmp    $0x30,%al
  8017b4:	75 1d                	jne    8017d3 <strtol+0x9c>
  8017b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ba:	48 83 c0 01          	add    $0x1,%rax
  8017be:	0f b6 00             	movzbl (%rax),%eax
  8017c1:	3c 78                	cmp    $0x78,%al
  8017c3:	75 0e                	jne    8017d3 <strtol+0x9c>
		s += 2, base = 16;
  8017c5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017ca:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017d1:	eb 2c                	jmp    8017ff <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017d3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017d7:	75 19                	jne    8017f2 <strtol+0xbb>
  8017d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dd:	0f b6 00             	movzbl (%rax),%eax
  8017e0:	3c 30                	cmp    $0x30,%al
  8017e2:	75 0e                	jne    8017f2 <strtol+0xbb>
		s++, base = 8;
  8017e4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017e9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017f0:	eb 0d                	jmp    8017ff <strtol+0xc8>
	else if (base == 0)
  8017f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017f6:	75 07                	jne    8017ff <strtol+0xc8>
		base = 10;
  8017f8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801803:	0f b6 00             	movzbl (%rax),%eax
  801806:	3c 2f                	cmp    $0x2f,%al
  801808:	7e 1d                	jle    801827 <strtol+0xf0>
  80180a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180e:	0f b6 00             	movzbl (%rax),%eax
  801811:	3c 39                	cmp    $0x39,%al
  801813:	7f 12                	jg     801827 <strtol+0xf0>
			dig = *s - '0';
  801815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801819:	0f b6 00             	movzbl (%rax),%eax
  80181c:	0f be c0             	movsbl %al,%eax
  80181f:	83 e8 30             	sub    $0x30,%eax
  801822:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801825:	eb 4e                	jmp    801875 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801827:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182b:	0f b6 00             	movzbl (%rax),%eax
  80182e:	3c 60                	cmp    $0x60,%al
  801830:	7e 1d                	jle    80184f <strtol+0x118>
  801832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801836:	0f b6 00             	movzbl (%rax),%eax
  801839:	3c 7a                	cmp    $0x7a,%al
  80183b:	7f 12                	jg     80184f <strtol+0x118>
			dig = *s - 'a' + 10;
  80183d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801841:	0f b6 00             	movzbl (%rax),%eax
  801844:	0f be c0             	movsbl %al,%eax
  801847:	83 e8 57             	sub    $0x57,%eax
  80184a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80184d:	eb 26                	jmp    801875 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80184f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801853:	0f b6 00             	movzbl (%rax),%eax
  801856:	3c 40                	cmp    $0x40,%al
  801858:	7e 48                	jle    8018a2 <strtol+0x16b>
  80185a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185e:	0f b6 00             	movzbl (%rax),%eax
  801861:	3c 5a                	cmp    $0x5a,%al
  801863:	7f 3d                	jg     8018a2 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801865:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801869:	0f b6 00             	movzbl (%rax),%eax
  80186c:	0f be c0             	movsbl %al,%eax
  80186f:	83 e8 37             	sub    $0x37,%eax
  801872:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801875:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801878:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80187b:	7c 02                	jl     80187f <strtol+0x148>
			break;
  80187d:	eb 23                	jmp    8018a2 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80187f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801884:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801887:	48 98                	cltq   
  801889:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80188e:	48 89 c2             	mov    %rax,%rdx
  801891:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801894:	48 98                	cltq   
  801896:	48 01 d0             	add    %rdx,%rax
  801899:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80189d:	e9 5d ff ff ff       	jmpq   8017ff <strtol+0xc8>

	if (endptr)
  8018a2:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018a7:	74 0b                	je     8018b4 <strtol+0x17d>
		*endptr = (char *) s;
  8018a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ad:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018b1:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018b8:	74 09                	je     8018c3 <strtol+0x18c>
  8018ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018be:	48 f7 d8             	neg    %rax
  8018c1:	eb 04                	jmp    8018c7 <strtol+0x190>
  8018c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018c7:	c9                   	leaveq 
  8018c8:	c3                   	retq   

00000000008018c9 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018c9:	55                   	push   %rbp
  8018ca:	48 89 e5             	mov    %rsp,%rbp
  8018cd:	48 83 ec 30          	sub    $0x30,%rsp
  8018d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018e1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018e5:	0f b6 00             	movzbl (%rax),%eax
  8018e8:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018eb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018ef:	75 06                	jne    8018f7 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f5:	eb 6b                	jmp    801962 <strstr+0x99>

	len = strlen(str);
  8018f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018fb:	48 89 c7             	mov    %rax,%rdi
  8018fe:	48 b8 9f 11 80 00 00 	movabs $0x80119f,%rax
  801905:	00 00 00 
  801908:	ff d0                	callq  *%rax
  80190a:	48 98                	cltq   
  80190c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801910:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801914:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801918:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80191c:	0f b6 00             	movzbl (%rax),%eax
  80191f:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801922:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801926:	75 07                	jne    80192f <strstr+0x66>
				return (char *) 0;
  801928:	b8 00 00 00 00       	mov    $0x0,%eax
  80192d:	eb 33                	jmp    801962 <strstr+0x99>
		} while (sc != c);
  80192f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801933:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801936:	75 d8                	jne    801910 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801938:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801940:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801944:	48 89 ce             	mov    %rcx,%rsi
  801947:	48 89 c7             	mov    %rax,%rdi
  80194a:	48 b8 c0 13 80 00 00 	movabs $0x8013c0,%rax
  801951:	00 00 00 
  801954:	ff d0                	callq  *%rax
  801956:	85 c0                	test   %eax,%eax
  801958:	75 b6                	jne    801910 <strstr+0x47>

	return (char *) (in - 1);
  80195a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195e:	48 83 e8 01          	sub    $0x1,%rax
}
  801962:	c9                   	leaveq 
  801963:	c3                   	retq   

0000000000801964 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	53                   	push   %rbx
  801969:	48 83 ec 48          	sub    $0x48,%rsp
  80196d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801970:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801973:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801977:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80197b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80197f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801983:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801986:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80198a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80198e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801992:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801996:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80199a:	4c 89 c3             	mov    %r8,%rbx
  80199d:	cd 30                	int    $0x30
  80199f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019a7:	74 3e                	je     8019e7 <syscall+0x83>
  8019a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019ae:	7e 37                	jle    8019e7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019b7:	49 89 d0             	mov    %rdx,%r8
  8019ba:	89 c1                	mov    %eax,%ecx
  8019bc:	48 ba 48 40 80 00 00 	movabs $0x804048,%rdx
  8019c3:	00 00 00 
  8019c6:	be 23 00 00 00       	mov    $0x23,%esi
  8019cb:	48 bf 65 40 80 00 00 	movabs $0x804065,%rdi
  8019d2:	00 00 00 
  8019d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019da:	49 b9 1d 04 80 00 00 	movabs $0x80041d,%r9
  8019e1:	00 00 00 
  8019e4:	41 ff d1             	callq  *%r9

	return ret;
  8019e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019eb:	48 83 c4 48          	add    $0x48,%rsp
  8019ef:	5b                   	pop    %rbx
  8019f0:	5d                   	pop    %rbp
  8019f1:	c3                   	retq   

00000000008019f2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019f2:	55                   	push   %rbp
  8019f3:	48 89 e5             	mov    %rsp,%rbp
  8019f6:	48 83 ec 20          	sub    $0x20,%rsp
  8019fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a11:	00 
  801a12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1e:	48 89 d1             	mov    %rdx,%rcx
  801a21:	48 89 c2             	mov    %rax,%rdx
  801a24:	be 00 00 00 00       	mov    $0x0,%esi
  801a29:	bf 00 00 00 00       	mov    $0x0,%edi
  801a2e:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801a35:	00 00 00 
  801a38:	ff d0                	callq  *%rax
}
  801a3a:	c9                   	leaveq 
  801a3b:	c3                   	retq   

0000000000801a3c <sys_cgetc>:

int
sys_cgetc(void)
{
  801a3c:	55                   	push   %rbp
  801a3d:	48 89 e5             	mov    %rsp,%rbp
  801a40:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a44:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4b:	00 
  801a4c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a52:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a58:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a62:	be 00 00 00 00       	mov    $0x0,%esi
  801a67:	bf 01 00 00 00       	mov    $0x1,%edi
  801a6c:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801a73:	00 00 00 
  801a76:	ff d0                	callq  *%rax
}
  801a78:	c9                   	leaveq 
  801a79:	c3                   	retq   

0000000000801a7a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 83 ec 10          	sub    $0x10,%rsp
  801a82:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a88:	48 98                	cltq   
  801a8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a91:	00 
  801a92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa3:	48 89 c2             	mov    %rax,%rdx
  801aa6:	be 01 00 00 00       	mov    $0x1,%esi
  801aab:	bf 03 00 00 00       	mov    $0x3,%edi
  801ab0:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801ab7:	00 00 00 
  801aba:	ff d0                	callq  *%rax
}
  801abc:	c9                   	leaveq 
  801abd:	c3                   	retq   

0000000000801abe <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801abe:	55                   	push   %rbp
  801abf:	48 89 e5             	mov    %rsp,%rbp
  801ac2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ac6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acd:	00 
  801ace:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ada:	b9 00 00 00 00       	mov    $0x0,%ecx
  801adf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae4:	be 00 00 00 00       	mov    $0x0,%esi
  801ae9:	bf 02 00 00 00       	mov    $0x2,%edi
  801aee:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801af5:	00 00 00 
  801af8:	ff d0                	callq  *%rax
}
  801afa:	c9                   	leaveq 
  801afb:	c3                   	retq   

0000000000801afc <sys_yield>:

void
sys_yield(void)
{
  801afc:	55                   	push   %rbp
  801afd:	48 89 e5             	mov    %rsp,%rbp
  801b00:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0b:	00 
  801b0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b18:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b22:	be 00 00 00 00       	mov    $0x0,%esi
  801b27:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b2c:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801b33:	00 00 00 
  801b36:	ff d0                	callq  *%rax
}
  801b38:	c9                   	leaveq 
  801b39:	c3                   	retq   

0000000000801b3a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b3a:	55                   	push   %rbp
  801b3b:	48 89 e5             	mov    %rsp,%rbp
  801b3e:	48 83 ec 20          	sub    $0x20,%rsp
  801b42:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b49:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b4f:	48 63 c8             	movslq %eax,%rcx
  801b52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b59:	48 98                	cltq   
  801b5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b62:	00 
  801b63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b69:	49 89 c8             	mov    %rcx,%r8
  801b6c:	48 89 d1             	mov    %rdx,%rcx
  801b6f:	48 89 c2             	mov    %rax,%rdx
  801b72:	be 01 00 00 00       	mov    $0x1,%esi
  801b77:	bf 04 00 00 00       	mov    $0x4,%edi
  801b7c:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801b83:	00 00 00 
  801b86:	ff d0                	callq  *%rax
}
  801b88:	c9                   	leaveq 
  801b89:	c3                   	retq   

0000000000801b8a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b8a:	55                   	push   %rbp
  801b8b:	48 89 e5             	mov    %rsp,%rbp
  801b8e:	48 83 ec 30          	sub    $0x30,%rsp
  801b92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b99:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b9c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ba0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ba4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ba7:	48 63 c8             	movslq %eax,%rcx
  801baa:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bb1:	48 63 f0             	movslq %eax,%rsi
  801bb4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbb:	48 98                	cltq   
  801bbd:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bc1:	49 89 f9             	mov    %rdi,%r9
  801bc4:	49 89 f0             	mov    %rsi,%r8
  801bc7:	48 89 d1             	mov    %rdx,%rcx
  801bca:	48 89 c2             	mov    %rax,%rdx
  801bcd:	be 01 00 00 00       	mov    $0x1,%esi
  801bd2:	bf 05 00 00 00       	mov    $0x5,%edi
  801bd7:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801bde:	00 00 00 
  801be1:	ff d0                	callq  *%rax
}
  801be3:	c9                   	leaveq 
  801be4:	c3                   	retq   

0000000000801be5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801be5:	55                   	push   %rbp
  801be6:	48 89 e5             	mov    %rsp,%rbp
  801be9:	48 83 ec 20          	sub    $0x20,%rsp
  801bed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bf4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfb:	48 98                	cltq   
  801bfd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c04:	00 
  801c05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c11:	48 89 d1             	mov    %rdx,%rcx
  801c14:	48 89 c2             	mov    %rax,%rdx
  801c17:	be 01 00 00 00       	mov    $0x1,%esi
  801c1c:	bf 06 00 00 00       	mov    $0x6,%edi
  801c21:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801c28:	00 00 00 
  801c2b:	ff d0                	callq  *%rax
}
  801c2d:	c9                   	leaveq 
  801c2e:	c3                   	retq   

0000000000801c2f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c2f:	55                   	push   %rbp
  801c30:	48 89 e5             	mov    %rsp,%rbp
  801c33:	48 83 ec 10          	sub    $0x10,%rsp
  801c37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c3a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c40:	48 63 d0             	movslq %eax,%rdx
  801c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c46:	48 98                	cltq   
  801c48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4f:	00 
  801c50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5c:	48 89 d1             	mov    %rdx,%rcx
  801c5f:	48 89 c2             	mov    %rax,%rdx
  801c62:	be 01 00 00 00       	mov    $0x1,%esi
  801c67:	bf 08 00 00 00       	mov    $0x8,%edi
  801c6c:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801c73:	00 00 00 
  801c76:	ff d0                	callq  *%rax
}
  801c78:	c9                   	leaveq 
  801c79:	c3                   	retq   

0000000000801c7a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c7a:	55                   	push   %rbp
  801c7b:	48 89 e5             	mov    %rsp,%rbp
  801c7e:	48 83 ec 20          	sub    $0x20,%rsp
  801c82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c90:	48 98                	cltq   
  801c92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c99:	00 
  801c9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca6:	48 89 d1             	mov    %rdx,%rcx
  801ca9:	48 89 c2             	mov    %rax,%rdx
  801cac:	be 01 00 00 00       	mov    $0x1,%esi
  801cb1:	bf 09 00 00 00       	mov    $0x9,%edi
  801cb6:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801cbd:	00 00 00 
  801cc0:	ff d0                	callq  *%rax
}
  801cc2:	c9                   	leaveq 
  801cc3:	c3                   	retq   

0000000000801cc4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cc4:	55                   	push   %rbp
  801cc5:	48 89 e5             	mov    %rsp,%rbp
  801cc8:	48 83 ec 20          	sub    $0x20,%rsp
  801ccc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ccf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cd3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cda:	48 98                	cltq   
  801cdc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce3:	00 
  801ce4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf0:	48 89 d1             	mov    %rdx,%rcx
  801cf3:	48 89 c2             	mov    %rax,%rdx
  801cf6:	be 01 00 00 00       	mov    $0x1,%esi
  801cfb:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d00:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801d07:	00 00 00 
  801d0a:	ff d0                	callq  *%rax
}
  801d0c:	c9                   	leaveq 
  801d0d:	c3                   	retq   

0000000000801d0e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d0e:	55                   	push   %rbp
  801d0f:	48 89 e5             	mov    %rsp,%rbp
  801d12:	48 83 ec 20          	sub    $0x20,%rsp
  801d16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d1d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d21:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d27:	48 63 f0             	movslq %eax,%rsi
  801d2a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d31:	48 98                	cltq   
  801d33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d3e:	00 
  801d3f:	49 89 f1             	mov    %rsi,%r9
  801d42:	49 89 c8             	mov    %rcx,%r8
  801d45:	48 89 d1             	mov    %rdx,%rcx
  801d48:	48 89 c2             	mov    %rax,%rdx
  801d4b:	be 00 00 00 00       	mov    $0x0,%esi
  801d50:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d55:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801d5c:	00 00 00 
  801d5f:	ff d0                	callq  *%rax
}
  801d61:	c9                   	leaveq 
  801d62:	c3                   	retq   

0000000000801d63 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d63:	55                   	push   %rbp
  801d64:	48 89 e5             	mov    %rsp,%rbp
  801d67:	48 83 ec 10          	sub    $0x10,%rsp
  801d6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d7a:	00 
  801d7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d87:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d8c:	48 89 c2             	mov    %rax,%rdx
  801d8f:	be 01 00 00 00       	mov    $0x1,%esi
  801d94:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d99:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801da0:	00 00 00 
  801da3:	ff d0                	callq  *%rax
}
  801da5:	c9                   	leaveq 
  801da6:	c3                   	retq   

0000000000801da7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801da7:	55                   	push   %rbp
  801da8:	48 89 e5             	mov    %rsp,%rbp
  801dab:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801daf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db6:	00 
  801db7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dc8:	ba 00 00 00 00       	mov    $0x0,%edx
  801dcd:	be 00 00 00 00       	mov    $0x0,%esi
  801dd2:	bf 0e 00 00 00       	mov    $0xe,%edi
  801dd7:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801dde:	00 00 00 
  801de1:	ff d0                	callq  *%rax
}
  801de3:	c9                   	leaveq 
  801de4:	c3                   	retq   

0000000000801de5 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801de5:	55                   	push   %rbp
  801de6:	48 89 e5             	mov    %rsp,%rbp
  801de9:	48 83 ec 30          	sub    $0x30,%rsp
  801ded:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801df0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801df4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801df7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dfb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801dff:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e02:	48 63 c8             	movslq %eax,%rcx
  801e05:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e0c:	48 63 f0             	movslq %eax,%rsi
  801e0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e16:	48 98                	cltq   
  801e18:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e1c:	49 89 f9             	mov    %rdi,%r9
  801e1f:	49 89 f0             	mov    %rsi,%r8
  801e22:	48 89 d1             	mov    %rdx,%rcx
  801e25:	48 89 c2             	mov    %rax,%rdx
  801e28:	be 00 00 00 00       	mov    $0x0,%esi
  801e2d:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e32:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801e39:	00 00 00 
  801e3c:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e3e:	c9                   	leaveq 
  801e3f:	c3                   	retq   

0000000000801e40 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e40:	55                   	push   %rbp
  801e41:	48 89 e5             	mov    %rsp,%rbp
  801e44:	48 83 ec 20          	sub    $0x20,%rsp
  801e48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e58:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e5f:	00 
  801e60:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6c:	48 89 d1             	mov    %rdx,%rcx
  801e6f:	48 89 c2             	mov    %rax,%rdx
  801e72:	be 00 00 00 00       	mov    $0x0,%esi
  801e77:	bf 10 00 00 00       	mov    $0x10,%edi
  801e7c:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801e83:	00 00 00 
  801e86:	ff d0                	callq  *%rax
}
  801e88:	c9                   	leaveq 
  801e89:	c3                   	retq   

0000000000801e8a <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801e8a:	55                   	push   %rbp
  801e8b:	48 89 e5             	mov    %rsp,%rbp
  801e8e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801e92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e99:	00 
  801e9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ea0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eab:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb0:	be 00 00 00 00       	mov    $0x0,%esi
  801eb5:	bf 11 00 00 00       	mov    $0x11,%edi
  801eba:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801ec1:	00 00 00 
  801ec4:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801ec6:	c9                   	leaveq 
  801ec7:	c3                   	retq   

0000000000801ec8 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801ec8:	55                   	push   %rbp
  801ec9:	48 89 e5             	mov    %rsp,%rbp
  801ecc:	48 83 ec 10          	sub    $0x10,%rsp
  801ed0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801ed3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed6:	48 98                	cltq   
  801ed8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801edf:	00 
  801ee0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ef1:	48 89 c2             	mov    %rax,%rdx
  801ef4:	be 00 00 00 00       	mov    $0x0,%esi
  801ef9:	bf 12 00 00 00       	mov    $0x12,%edi
  801efe:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801f05:	00 00 00 
  801f08:	ff d0                	callq  *%rax
}
  801f0a:	c9                   	leaveq 
  801f0b:	c3                   	retq   

0000000000801f0c <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801f0c:	55                   	push   %rbp
  801f0d:	48 89 e5             	mov    %rsp,%rbp
  801f10:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801f14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f1b:	00 
  801f1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f28:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f32:	be 00 00 00 00       	mov    $0x0,%esi
  801f37:	bf 13 00 00 00       	mov    $0x13,%edi
  801f3c:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801f43:	00 00 00 
  801f46:	ff d0                	callq  *%rax
}
  801f48:	c9                   	leaveq 
  801f49:	c3                   	retq   

0000000000801f4a <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801f4a:	55                   	push   %rbp
  801f4b:	48 89 e5             	mov    %rsp,%rbp
  801f4e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801f52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f59:	00 
  801f5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f70:	be 00 00 00 00       	mov    $0x0,%esi
  801f75:	bf 14 00 00 00       	mov    $0x14,%edi
  801f7a:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
}
  801f86:	c9                   	leaveq 
  801f87:	c3                   	retq   

0000000000801f88 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801f88:	55                   	push   %rbp
  801f89:	48 89 e5             	mov    %rsp,%rbp
  801f8c:	48 83 ec 08          	sub    $0x8,%rsp
  801f90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f94:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f98:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801f9f:	ff ff ff 
  801fa2:	48 01 d0             	add    %rdx,%rax
  801fa5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801fa9:	c9                   	leaveq 
  801faa:	c3                   	retq   

0000000000801fab <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801fab:	55                   	push   %rbp
  801fac:	48 89 e5             	mov    %rsp,%rbp
  801faf:	48 83 ec 08          	sub    $0x8,%rsp
  801fb3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801fb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fbb:	48 89 c7             	mov    %rax,%rdi
  801fbe:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  801fc5:	00 00 00 
  801fc8:	ff d0                	callq  *%rax
  801fca:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801fd0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801fd4:	c9                   	leaveq 
  801fd5:	c3                   	retq   

0000000000801fd6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801fd6:	55                   	push   %rbp
  801fd7:	48 89 e5             	mov    %rsp,%rbp
  801fda:	48 83 ec 18          	sub    $0x18,%rsp
  801fde:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fe2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fe9:	eb 6b                	jmp    802056 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801feb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fee:	48 98                	cltq   
  801ff0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ff6:	48 c1 e0 0c          	shl    $0xc,%rax
  801ffa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ffe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802002:	48 c1 e8 15          	shr    $0x15,%rax
  802006:	48 89 c2             	mov    %rax,%rdx
  802009:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802010:	01 00 00 
  802013:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802017:	83 e0 01             	and    $0x1,%eax
  80201a:	48 85 c0             	test   %rax,%rax
  80201d:	74 21                	je     802040 <fd_alloc+0x6a>
  80201f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802023:	48 c1 e8 0c          	shr    $0xc,%rax
  802027:	48 89 c2             	mov    %rax,%rdx
  80202a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802031:	01 00 00 
  802034:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802038:	83 e0 01             	and    $0x1,%eax
  80203b:	48 85 c0             	test   %rax,%rax
  80203e:	75 12                	jne    802052 <fd_alloc+0x7c>
			*fd_store = fd;
  802040:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802044:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802048:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
  802050:	eb 1a                	jmp    80206c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802052:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802056:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80205a:	7e 8f                	jle    801feb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80205c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802060:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802067:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80206c:	c9                   	leaveq 
  80206d:	c3                   	retq   

000000000080206e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80206e:	55                   	push   %rbp
  80206f:	48 89 e5             	mov    %rsp,%rbp
  802072:	48 83 ec 20          	sub    $0x20,%rsp
  802076:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802079:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80207d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802081:	78 06                	js     802089 <fd_lookup+0x1b>
  802083:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802087:	7e 07                	jle    802090 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802089:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80208e:	eb 6c                	jmp    8020fc <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802090:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802093:	48 98                	cltq   
  802095:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80209b:	48 c1 e0 0c          	shl    $0xc,%rax
  80209f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8020a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020a7:	48 c1 e8 15          	shr    $0x15,%rax
  8020ab:	48 89 c2             	mov    %rax,%rdx
  8020ae:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020b5:	01 00 00 
  8020b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020bc:	83 e0 01             	and    $0x1,%eax
  8020bf:	48 85 c0             	test   %rax,%rax
  8020c2:	74 21                	je     8020e5 <fd_lookup+0x77>
  8020c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020c8:	48 c1 e8 0c          	shr    $0xc,%rax
  8020cc:	48 89 c2             	mov    %rax,%rdx
  8020cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020d6:	01 00 00 
  8020d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020dd:	83 e0 01             	and    $0x1,%eax
  8020e0:	48 85 c0             	test   %rax,%rax
  8020e3:	75 07                	jne    8020ec <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8020e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020ea:	eb 10                	jmp    8020fc <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8020ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020f4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fc:	c9                   	leaveq 
  8020fd:	c3                   	retq   

00000000008020fe <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8020fe:	55                   	push   %rbp
  8020ff:	48 89 e5             	mov    %rsp,%rbp
  802102:	48 83 ec 30          	sub    $0x30,%rsp
  802106:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80210a:	89 f0                	mov    %esi,%eax
  80210c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80210f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802113:	48 89 c7             	mov    %rax,%rdi
  802116:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  80211d:	00 00 00 
  802120:	ff d0                	callq  *%rax
  802122:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802126:	48 89 d6             	mov    %rdx,%rsi
  802129:	89 c7                	mov    %eax,%edi
  80212b:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  802132:	00 00 00 
  802135:	ff d0                	callq  *%rax
  802137:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80213a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80213e:	78 0a                	js     80214a <fd_close+0x4c>
	    || fd != fd2)
  802140:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802144:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802148:	74 12                	je     80215c <fd_close+0x5e>
		return (must_exist ? r : 0);
  80214a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80214e:	74 05                	je     802155 <fd_close+0x57>
  802150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802153:	eb 05                	jmp    80215a <fd_close+0x5c>
  802155:	b8 00 00 00 00       	mov    $0x0,%eax
  80215a:	eb 69                	jmp    8021c5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80215c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802160:	8b 00                	mov    (%rax),%eax
  802162:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802166:	48 89 d6             	mov    %rdx,%rsi
  802169:	89 c7                	mov    %eax,%edi
  80216b:	48 b8 c7 21 80 00 00 	movabs $0x8021c7,%rax
  802172:	00 00 00 
  802175:	ff d0                	callq  *%rax
  802177:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80217e:	78 2a                	js     8021aa <fd_close+0xac>
		if (dev->dev_close)
  802180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802184:	48 8b 40 20          	mov    0x20(%rax),%rax
  802188:	48 85 c0             	test   %rax,%rax
  80218b:	74 16                	je     8021a3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80218d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802191:	48 8b 40 20          	mov    0x20(%rax),%rax
  802195:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802199:	48 89 d7             	mov    %rdx,%rdi
  80219c:	ff d0                	callq  *%rax
  80219e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021a1:	eb 07                	jmp    8021aa <fd_close+0xac>
		else
			r = 0;
  8021a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8021aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ae:	48 89 c6             	mov    %rax,%rsi
  8021b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b6:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  8021bd:	00 00 00 
  8021c0:	ff d0                	callq  *%rax
	return r;
  8021c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021c5:	c9                   	leaveq 
  8021c6:	c3                   	retq   

00000000008021c7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8021c7:	55                   	push   %rbp
  8021c8:	48 89 e5             	mov    %rsp,%rbp
  8021cb:	48 83 ec 20          	sub    $0x20,%rsp
  8021cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8021d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021dd:	eb 41                	jmp    802220 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8021df:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8021e6:	00 00 00 
  8021e9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021ec:	48 63 d2             	movslq %edx,%rdx
  8021ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f3:	8b 00                	mov    (%rax),%eax
  8021f5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8021f8:	75 22                	jne    80221c <dev_lookup+0x55>
			*dev = devtab[i];
  8021fa:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802201:	00 00 00 
  802204:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802207:	48 63 d2             	movslq %edx,%rdx
  80220a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80220e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802212:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802215:	b8 00 00 00 00       	mov    $0x0,%eax
  80221a:	eb 60                	jmp    80227c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80221c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802220:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802227:	00 00 00 
  80222a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80222d:	48 63 d2             	movslq %edx,%rdx
  802230:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802234:	48 85 c0             	test   %rax,%rax
  802237:	75 a6                	jne    8021df <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802239:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802240:	00 00 00 
  802243:	48 8b 00             	mov    (%rax),%rax
  802246:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80224c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80224f:	89 c6                	mov    %eax,%esi
  802251:	48 bf 78 40 80 00 00 	movabs $0x804078,%rdi
  802258:	00 00 00 
  80225b:	b8 00 00 00 00       	mov    $0x0,%eax
  802260:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  802267:	00 00 00 
  80226a:	ff d1                	callq  *%rcx
	*dev = 0;
  80226c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802270:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802277:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80227c:	c9                   	leaveq 
  80227d:	c3                   	retq   

000000000080227e <close>:

int
close(int fdnum)
{
  80227e:	55                   	push   %rbp
  80227f:	48 89 e5             	mov    %rsp,%rbp
  802282:	48 83 ec 20          	sub    $0x20,%rsp
  802286:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802289:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80228d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802290:	48 89 d6             	mov    %rdx,%rsi
  802293:	89 c7                	mov    %eax,%edi
  802295:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  80229c:	00 00 00 
  80229f:	ff d0                	callq  *%rax
  8022a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a8:	79 05                	jns    8022af <close+0x31>
		return r;
  8022aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ad:	eb 18                	jmp    8022c7 <close+0x49>
	else
		return fd_close(fd, 1);
  8022af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b3:	be 01 00 00 00       	mov    $0x1,%esi
  8022b8:	48 89 c7             	mov    %rax,%rdi
  8022bb:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  8022c2:	00 00 00 
  8022c5:	ff d0                	callq  *%rax
}
  8022c7:	c9                   	leaveq 
  8022c8:	c3                   	retq   

00000000008022c9 <close_all>:

void
close_all(void)
{
  8022c9:	55                   	push   %rbp
  8022ca:	48 89 e5             	mov    %rsp,%rbp
  8022cd:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8022d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022d8:	eb 15                	jmp    8022ef <close_all+0x26>
		close(i);
  8022da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022dd:	89 c7                	mov    %eax,%edi
  8022df:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  8022e6:	00 00 00 
  8022e9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8022eb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022ef:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022f3:	7e e5                	jle    8022da <close_all+0x11>
		close(i);
}
  8022f5:	c9                   	leaveq 
  8022f6:	c3                   	retq   

00000000008022f7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8022f7:	55                   	push   %rbp
  8022f8:	48 89 e5             	mov    %rsp,%rbp
  8022fb:	48 83 ec 40          	sub    $0x40,%rsp
  8022ff:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802302:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802305:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802309:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80230c:	48 89 d6             	mov    %rdx,%rsi
  80230f:	89 c7                	mov    %eax,%edi
  802311:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  802318:	00 00 00 
  80231b:	ff d0                	callq  *%rax
  80231d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802320:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802324:	79 08                	jns    80232e <dup+0x37>
		return r;
  802326:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802329:	e9 70 01 00 00       	jmpq   80249e <dup+0x1a7>
	close(newfdnum);
  80232e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802331:	89 c7                	mov    %eax,%edi
  802333:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  80233a:	00 00 00 
  80233d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80233f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802342:	48 98                	cltq   
  802344:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80234a:	48 c1 e0 0c          	shl    $0xc,%rax
  80234e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802352:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802356:	48 89 c7             	mov    %rax,%rdi
  802359:	48 b8 ab 1f 80 00 00 	movabs $0x801fab,%rax
  802360:	00 00 00 
  802363:	ff d0                	callq  *%rax
  802365:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80236d:	48 89 c7             	mov    %rax,%rdi
  802370:	48 b8 ab 1f 80 00 00 	movabs $0x801fab,%rax
  802377:	00 00 00 
  80237a:	ff d0                	callq  *%rax
  80237c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802384:	48 c1 e8 15          	shr    $0x15,%rax
  802388:	48 89 c2             	mov    %rax,%rdx
  80238b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802392:	01 00 00 
  802395:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802399:	83 e0 01             	and    $0x1,%eax
  80239c:	48 85 c0             	test   %rax,%rax
  80239f:	74 73                	je     802414 <dup+0x11d>
  8023a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a5:	48 c1 e8 0c          	shr    $0xc,%rax
  8023a9:	48 89 c2             	mov    %rax,%rdx
  8023ac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b3:	01 00 00 
  8023b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ba:	83 e0 01             	and    $0x1,%eax
  8023bd:	48 85 c0             	test   %rax,%rax
  8023c0:	74 52                	je     802414 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8023c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c6:	48 c1 e8 0c          	shr    $0xc,%rax
  8023ca:	48 89 c2             	mov    %rax,%rdx
  8023cd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023d4:	01 00 00 
  8023d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023db:	25 07 0e 00 00       	and    $0xe07,%eax
  8023e0:	89 c1                	mov    %eax,%ecx
  8023e2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ea:	41 89 c8             	mov    %ecx,%r8d
  8023ed:	48 89 d1             	mov    %rdx,%rcx
  8023f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f5:	48 89 c6             	mov    %rax,%rsi
  8023f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fd:	48 b8 8a 1b 80 00 00 	movabs $0x801b8a,%rax
  802404:	00 00 00 
  802407:	ff d0                	callq  *%rax
  802409:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80240c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802410:	79 02                	jns    802414 <dup+0x11d>
			goto err;
  802412:	eb 57                	jmp    80246b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802414:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802418:	48 c1 e8 0c          	shr    $0xc,%rax
  80241c:	48 89 c2             	mov    %rax,%rdx
  80241f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802426:	01 00 00 
  802429:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242d:	25 07 0e 00 00       	and    $0xe07,%eax
  802432:	89 c1                	mov    %eax,%ecx
  802434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802438:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80243c:	41 89 c8             	mov    %ecx,%r8d
  80243f:	48 89 d1             	mov    %rdx,%rcx
  802442:	ba 00 00 00 00       	mov    $0x0,%edx
  802447:	48 89 c6             	mov    %rax,%rsi
  80244a:	bf 00 00 00 00       	mov    $0x0,%edi
  80244f:	48 b8 8a 1b 80 00 00 	movabs $0x801b8a,%rax
  802456:	00 00 00 
  802459:	ff d0                	callq  *%rax
  80245b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802462:	79 02                	jns    802466 <dup+0x16f>
		goto err;
  802464:	eb 05                	jmp    80246b <dup+0x174>

	return newfdnum;
  802466:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802469:	eb 33                	jmp    80249e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80246b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246f:	48 89 c6             	mov    %rax,%rsi
  802472:	bf 00 00 00 00       	mov    $0x0,%edi
  802477:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  80247e:	00 00 00 
  802481:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802483:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802487:	48 89 c6             	mov    %rax,%rsi
  80248a:	bf 00 00 00 00       	mov    $0x0,%edi
  80248f:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  802496:	00 00 00 
  802499:	ff d0                	callq  *%rax
	return r;
  80249b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80249e:	c9                   	leaveq 
  80249f:	c3                   	retq   

00000000008024a0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8024a0:	55                   	push   %rbp
  8024a1:	48 89 e5             	mov    %rsp,%rbp
  8024a4:	48 83 ec 40          	sub    $0x40,%rsp
  8024a8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024ab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024af:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024b3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024ba:	48 89 d6             	mov    %rdx,%rsi
  8024bd:	89 c7                	mov    %eax,%edi
  8024bf:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  8024c6:	00 00 00 
  8024c9:	ff d0                	callq  *%rax
  8024cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d2:	78 24                	js     8024f8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d8:	8b 00                	mov    (%rax),%eax
  8024da:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024de:	48 89 d6             	mov    %rdx,%rsi
  8024e1:	89 c7                	mov    %eax,%edi
  8024e3:	48 b8 c7 21 80 00 00 	movabs $0x8021c7,%rax
  8024ea:	00 00 00 
  8024ed:	ff d0                	callq  *%rax
  8024ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f6:	79 05                	jns    8024fd <read+0x5d>
		return r;
  8024f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fb:	eb 76                	jmp    802573 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8024fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802501:	8b 40 08             	mov    0x8(%rax),%eax
  802504:	83 e0 03             	and    $0x3,%eax
  802507:	83 f8 01             	cmp    $0x1,%eax
  80250a:	75 3a                	jne    802546 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80250c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802513:	00 00 00 
  802516:	48 8b 00             	mov    (%rax),%rax
  802519:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80251f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802522:	89 c6                	mov    %eax,%esi
  802524:	48 bf 97 40 80 00 00 	movabs $0x804097,%rdi
  80252b:	00 00 00 
  80252e:	b8 00 00 00 00       	mov    $0x0,%eax
  802533:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  80253a:	00 00 00 
  80253d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80253f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802544:	eb 2d                	jmp    802573 <read+0xd3>
	}
	if (!dev->dev_read)
  802546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80254e:	48 85 c0             	test   %rax,%rax
  802551:	75 07                	jne    80255a <read+0xba>
		return -E_NOT_SUPP;
  802553:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802558:	eb 19                	jmp    802573 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80255a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802562:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802566:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80256a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80256e:	48 89 cf             	mov    %rcx,%rdi
  802571:	ff d0                	callq  *%rax
}
  802573:	c9                   	leaveq 
  802574:	c3                   	retq   

0000000000802575 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802575:	55                   	push   %rbp
  802576:	48 89 e5             	mov    %rsp,%rbp
  802579:	48 83 ec 30          	sub    $0x30,%rsp
  80257d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802580:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802584:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802588:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80258f:	eb 49                	jmp    8025da <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802591:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802594:	48 98                	cltq   
  802596:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80259a:	48 29 c2             	sub    %rax,%rdx
  80259d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a0:	48 63 c8             	movslq %eax,%rcx
  8025a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a7:	48 01 c1             	add    %rax,%rcx
  8025aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025ad:	48 89 ce             	mov    %rcx,%rsi
  8025b0:	89 c7                	mov    %eax,%edi
  8025b2:	48 b8 a0 24 80 00 00 	movabs $0x8024a0,%rax
  8025b9:	00 00 00 
  8025bc:	ff d0                	callq  *%rax
  8025be:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8025c1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025c5:	79 05                	jns    8025cc <readn+0x57>
			return m;
  8025c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025ca:	eb 1c                	jmp    8025e8 <readn+0x73>
		if (m == 0)
  8025cc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025d0:	75 02                	jne    8025d4 <readn+0x5f>
			break;
  8025d2:	eb 11                	jmp    8025e5 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8025d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025d7:	01 45 fc             	add    %eax,-0x4(%rbp)
  8025da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025dd:	48 98                	cltq   
  8025df:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8025e3:	72 ac                	jb     802591 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8025e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025e8:	c9                   	leaveq 
  8025e9:	c3                   	retq   

00000000008025ea <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8025ea:	55                   	push   %rbp
  8025eb:	48 89 e5             	mov    %rsp,%rbp
  8025ee:	48 83 ec 40          	sub    $0x40,%rsp
  8025f2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025f5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025f9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025fd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802601:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802604:	48 89 d6             	mov    %rdx,%rsi
  802607:	89 c7                	mov    %eax,%edi
  802609:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  802610:	00 00 00 
  802613:	ff d0                	callq  *%rax
  802615:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802618:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261c:	78 24                	js     802642 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80261e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802622:	8b 00                	mov    (%rax),%eax
  802624:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802628:	48 89 d6             	mov    %rdx,%rsi
  80262b:	89 c7                	mov    %eax,%edi
  80262d:	48 b8 c7 21 80 00 00 	movabs $0x8021c7,%rax
  802634:	00 00 00 
  802637:	ff d0                	callq  *%rax
  802639:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802640:	79 05                	jns    802647 <write+0x5d>
		return r;
  802642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802645:	eb 42                	jmp    802689 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264b:	8b 40 08             	mov    0x8(%rax),%eax
  80264e:	83 e0 03             	and    $0x3,%eax
  802651:	85 c0                	test   %eax,%eax
  802653:	75 07                	jne    80265c <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802655:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80265a:	eb 2d                	jmp    802689 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80265c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802660:	48 8b 40 18          	mov    0x18(%rax),%rax
  802664:	48 85 c0             	test   %rax,%rax
  802667:	75 07                	jne    802670 <write+0x86>
		return -E_NOT_SUPP;
  802669:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80266e:	eb 19                	jmp    802689 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802670:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802674:	48 8b 40 18          	mov    0x18(%rax),%rax
  802678:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80267c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802680:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802684:	48 89 cf             	mov    %rcx,%rdi
  802687:	ff d0                	callq  *%rax
}
  802689:	c9                   	leaveq 
  80268a:	c3                   	retq   

000000000080268b <seek>:

int
seek(int fdnum, off_t offset)
{
  80268b:	55                   	push   %rbp
  80268c:	48 89 e5             	mov    %rsp,%rbp
  80268f:	48 83 ec 18          	sub    $0x18,%rsp
  802693:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802696:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802699:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80269d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026a0:	48 89 d6             	mov    %rdx,%rsi
  8026a3:	89 c7                	mov    %eax,%edi
  8026a5:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  8026ac:	00 00 00 
  8026af:	ff d0                	callq  *%rax
  8026b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b8:	79 05                	jns    8026bf <seek+0x34>
		return r;
  8026ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026bd:	eb 0f                	jmp    8026ce <seek+0x43>
	fd->fd_offset = offset;
  8026bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8026c6:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ce:	c9                   	leaveq 
  8026cf:	c3                   	retq   

00000000008026d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8026d0:	55                   	push   %rbp
  8026d1:	48 89 e5             	mov    %rsp,%rbp
  8026d4:	48 83 ec 30          	sub    $0x30,%rsp
  8026d8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026db:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026de:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026e5:	48 89 d6             	mov    %rdx,%rsi
  8026e8:	89 c7                	mov    %eax,%edi
  8026ea:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  8026f1:	00 00 00 
  8026f4:	ff d0                	callq  *%rax
  8026f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026fd:	78 24                	js     802723 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802703:	8b 00                	mov    (%rax),%eax
  802705:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802709:	48 89 d6             	mov    %rdx,%rsi
  80270c:	89 c7                	mov    %eax,%edi
  80270e:	48 b8 c7 21 80 00 00 	movabs $0x8021c7,%rax
  802715:	00 00 00 
  802718:	ff d0                	callq  *%rax
  80271a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80271d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802721:	79 05                	jns    802728 <ftruncate+0x58>
		return r;
  802723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802726:	eb 72                	jmp    80279a <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80272c:	8b 40 08             	mov    0x8(%rax),%eax
  80272f:	83 e0 03             	and    $0x3,%eax
  802732:	85 c0                	test   %eax,%eax
  802734:	75 3a                	jne    802770 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802736:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80273d:	00 00 00 
  802740:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802743:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802749:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80274c:	89 c6                	mov    %eax,%esi
  80274e:	48 bf b8 40 80 00 00 	movabs $0x8040b8,%rdi
  802755:	00 00 00 
  802758:	b8 00 00 00 00       	mov    $0x0,%eax
  80275d:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  802764:	00 00 00 
  802767:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802769:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80276e:	eb 2a                	jmp    80279a <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802770:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802774:	48 8b 40 30          	mov    0x30(%rax),%rax
  802778:	48 85 c0             	test   %rax,%rax
  80277b:	75 07                	jne    802784 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80277d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802782:	eb 16                	jmp    80279a <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802784:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802788:	48 8b 40 30          	mov    0x30(%rax),%rax
  80278c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802790:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802793:	89 ce                	mov    %ecx,%esi
  802795:	48 89 d7             	mov    %rdx,%rdi
  802798:	ff d0                	callq  *%rax
}
  80279a:	c9                   	leaveq 
  80279b:	c3                   	retq   

000000000080279c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80279c:	55                   	push   %rbp
  80279d:	48 89 e5             	mov    %rsp,%rbp
  8027a0:	48 83 ec 30          	sub    $0x30,%rsp
  8027a4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027ab:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027af:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027b2:	48 89 d6             	mov    %rdx,%rsi
  8027b5:	89 c7                	mov    %eax,%edi
  8027b7:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  8027be:	00 00 00 
  8027c1:	ff d0                	callq  *%rax
  8027c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ca:	78 24                	js     8027f0 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d0:	8b 00                	mov    (%rax),%eax
  8027d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027d6:	48 89 d6             	mov    %rdx,%rsi
  8027d9:	89 c7                	mov    %eax,%edi
  8027db:	48 b8 c7 21 80 00 00 	movabs $0x8021c7,%rax
  8027e2:	00 00 00 
  8027e5:	ff d0                	callq  *%rax
  8027e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ee:	79 05                	jns    8027f5 <fstat+0x59>
		return r;
  8027f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f3:	eb 5e                	jmp    802853 <fstat+0xb7>
	if (!dev->dev_stat)
  8027f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f9:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027fd:	48 85 c0             	test   %rax,%rax
  802800:	75 07                	jne    802809 <fstat+0x6d>
		return -E_NOT_SUPP;
  802802:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802807:	eb 4a                	jmp    802853 <fstat+0xb7>
	stat->st_name[0] = 0;
  802809:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80280d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802810:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802814:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80281b:	00 00 00 
	stat->st_isdir = 0;
  80281e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802822:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802829:	00 00 00 
	stat->st_dev = dev;
  80282c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802830:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802834:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80283b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80283f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802843:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802847:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80284b:	48 89 ce             	mov    %rcx,%rsi
  80284e:	48 89 d7             	mov    %rdx,%rdi
  802851:	ff d0                	callq  *%rax
}
  802853:	c9                   	leaveq 
  802854:	c3                   	retq   

0000000000802855 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802855:	55                   	push   %rbp
  802856:	48 89 e5             	mov    %rsp,%rbp
  802859:	48 83 ec 20          	sub    $0x20,%rsp
  80285d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802861:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802865:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802869:	be 00 00 00 00       	mov    $0x0,%esi
  80286e:	48 89 c7             	mov    %rax,%rdi
  802871:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  802878:	00 00 00 
  80287b:	ff d0                	callq  *%rax
  80287d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802884:	79 05                	jns    80288b <stat+0x36>
		return fd;
  802886:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802889:	eb 2f                	jmp    8028ba <stat+0x65>
	r = fstat(fd, stat);
  80288b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80288f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802892:	48 89 d6             	mov    %rdx,%rsi
  802895:	89 c7                	mov    %eax,%edi
  802897:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  80289e:	00 00 00 
  8028a1:	ff d0                	callq  *%rax
  8028a3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8028a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a9:	89 c7                	mov    %eax,%edi
  8028ab:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  8028b2:	00 00 00 
  8028b5:	ff d0                	callq  *%rax
	return r;
  8028b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8028ba:	c9                   	leaveq 
  8028bb:	c3                   	retq   

00000000008028bc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8028bc:	55                   	push   %rbp
  8028bd:	48 89 e5             	mov    %rsp,%rbp
  8028c0:	48 83 ec 10          	sub    $0x10,%rsp
  8028c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8028c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8028cb:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8028d2:	00 00 00 
  8028d5:	8b 00                	mov    (%rax),%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	75 1d                	jne    8028f8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8028db:	bf 01 00 00 00       	mov    $0x1,%edi
  8028e0:	48 b8 5b 39 80 00 00 	movabs $0x80395b,%rax
  8028e7:	00 00 00 
  8028ea:	ff d0                	callq  *%rax
  8028ec:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8028f3:	00 00 00 
  8028f6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8028f8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8028ff:	00 00 00 
  802902:	8b 00                	mov    (%rax),%eax
  802904:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802907:	b9 07 00 00 00       	mov    $0x7,%ecx
  80290c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802913:	00 00 00 
  802916:	89 c7                	mov    %eax,%edi
  802918:	48 b8 d3 38 80 00 00 	movabs $0x8038d3,%rax
  80291f:	00 00 00 
  802922:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802924:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802928:	ba 00 00 00 00       	mov    $0x0,%edx
  80292d:	48 89 c6             	mov    %rax,%rsi
  802930:	bf 00 00 00 00       	mov    $0x0,%edi
  802935:	48 b8 d5 37 80 00 00 	movabs $0x8037d5,%rax
  80293c:	00 00 00 
  80293f:	ff d0                	callq  *%rax
}
  802941:	c9                   	leaveq 
  802942:	c3                   	retq   

0000000000802943 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802943:	55                   	push   %rbp
  802944:	48 89 e5             	mov    %rsp,%rbp
  802947:	48 83 ec 30          	sub    $0x30,%rsp
  80294b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80294f:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802952:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802959:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802960:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802967:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80296c:	75 08                	jne    802976 <open+0x33>
	{
		return r;
  80296e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802971:	e9 f2 00 00 00       	jmpq   802a68 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802976:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80297a:	48 89 c7             	mov    %rax,%rdi
  80297d:	48 b8 9f 11 80 00 00 	movabs $0x80119f,%rax
  802984:	00 00 00 
  802987:	ff d0                	callq  *%rax
  802989:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80298c:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802993:	7e 0a                	jle    80299f <open+0x5c>
	{
		return -E_BAD_PATH;
  802995:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80299a:	e9 c9 00 00 00       	jmpq   802a68 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80299f:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8029a6:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8029a7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8029ab:	48 89 c7             	mov    %rax,%rdi
  8029ae:	48 b8 d6 1f 80 00 00 	movabs $0x801fd6,%rax
  8029b5:	00 00 00 
  8029b8:	ff d0                	callq  *%rax
  8029ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c1:	78 09                	js     8029cc <open+0x89>
  8029c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c7:	48 85 c0             	test   %rax,%rax
  8029ca:	75 08                	jne    8029d4 <open+0x91>
		{
			return r;
  8029cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cf:	e9 94 00 00 00       	jmpq   802a68 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8029d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029d8:	ba 00 04 00 00       	mov    $0x400,%edx
  8029dd:	48 89 c6             	mov    %rax,%rsi
  8029e0:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8029e7:	00 00 00 
  8029ea:	48 b8 9d 12 80 00 00 	movabs $0x80129d,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8029f6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029fd:	00 00 00 
  802a00:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802a03:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802a09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0d:	48 89 c6             	mov    %rax,%rsi
  802a10:	bf 01 00 00 00       	mov    $0x1,%edi
  802a15:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802a1c:	00 00 00 
  802a1f:	ff d0                	callq  *%rax
  802a21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a28:	79 2b                	jns    802a55 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802a2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a2e:	be 00 00 00 00       	mov    $0x0,%esi
  802a33:	48 89 c7             	mov    %rax,%rdi
  802a36:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  802a3d:	00 00 00 
  802a40:	ff d0                	callq  *%rax
  802a42:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802a45:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a49:	79 05                	jns    802a50 <open+0x10d>
			{
				return d;
  802a4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a4e:	eb 18                	jmp    802a68 <open+0x125>
			}
			return r;
  802a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a53:	eb 13                	jmp    802a68 <open+0x125>
		}	
		return fd2num(fd_store);
  802a55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a59:	48 89 c7             	mov    %rax,%rdi
  802a5c:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802a68:	c9                   	leaveq 
  802a69:	c3                   	retq   

0000000000802a6a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802a6a:	55                   	push   %rbp
  802a6b:	48 89 e5             	mov    %rsp,%rbp
  802a6e:	48 83 ec 10          	sub    $0x10,%rsp
  802a72:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a7a:	8b 50 0c             	mov    0xc(%rax),%edx
  802a7d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a84:	00 00 00 
  802a87:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802a89:	be 00 00 00 00       	mov    $0x0,%esi
  802a8e:	bf 06 00 00 00       	mov    $0x6,%edi
  802a93:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
}
  802a9f:	c9                   	leaveq 
  802aa0:	c3                   	retq   

0000000000802aa1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802aa1:	55                   	push   %rbp
  802aa2:	48 89 e5             	mov    %rsp,%rbp
  802aa5:	48 83 ec 30          	sub    $0x30,%rsp
  802aa9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ab1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802ab5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802abc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ac1:	74 07                	je     802aca <devfile_read+0x29>
  802ac3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ac8:	75 07                	jne    802ad1 <devfile_read+0x30>
		return -E_INVAL;
  802aca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802acf:	eb 77                	jmp    802b48 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ad1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad5:	8b 50 0c             	mov    0xc(%rax),%edx
  802ad8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802adf:	00 00 00 
  802ae2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ae4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aeb:	00 00 00 
  802aee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802af2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802af6:	be 00 00 00 00       	mov    $0x0,%esi
  802afb:	bf 03 00 00 00       	mov    $0x3,%edi
  802b00:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802b07:	00 00 00 
  802b0a:	ff d0                	callq  *%rax
  802b0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b13:	7f 05                	jg     802b1a <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b18:	eb 2e                	jmp    802b48 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802b1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1d:	48 63 d0             	movslq %eax,%rdx
  802b20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b24:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802b2b:	00 00 00 
  802b2e:	48 89 c7             	mov    %rax,%rdi
  802b31:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802b3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b41:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802b45:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802b48:	c9                   	leaveq 
  802b49:	c3                   	retq   

0000000000802b4a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b4a:	55                   	push   %rbp
  802b4b:	48 89 e5             	mov    %rsp,%rbp
  802b4e:	48 83 ec 30          	sub    $0x30,%rsp
  802b52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b5a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802b5e:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802b65:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802b6a:	74 07                	je     802b73 <devfile_write+0x29>
  802b6c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802b71:	75 08                	jne    802b7b <devfile_write+0x31>
		return r;
  802b73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b76:	e9 9a 00 00 00       	jmpq   802c15 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802b7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7f:	8b 50 0c             	mov    0xc(%rax),%edx
  802b82:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b89:	00 00 00 
  802b8c:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802b8e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802b95:	00 
  802b96:	76 08                	jbe    802ba0 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802b98:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802b9f:	00 
	}
	fsipcbuf.write.req_n = n;
  802ba0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ba7:	00 00 00 
  802baa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bae:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802bb2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bba:	48 89 c6             	mov    %rax,%rsi
  802bbd:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802bc4:	00 00 00 
  802bc7:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  802bce:	00 00 00 
  802bd1:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802bd3:	be 00 00 00 00       	mov    $0x0,%esi
  802bd8:	bf 04 00 00 00       	mov    $0x4,%edi
  802bdd:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802be4:	00 00 00 
  802be7:	ff d0                	callq  *%rax
  802be9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf0:	7f 20                	jg     802c12 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802bf2:	48 bf de 40 80 00 00 	movabs $0x8040de,%rdi
  802bf9:	00 00 00 
  802bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  802c01:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802c08:	00 00 00 
  802c0b:	ff d2                	callq  *%rdx
		return r;
  802c0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c10:	eb 03                	jmp    802c15 <devfile_write+0xcb>
	}
	return r;
  802c12:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802c15:	c9                   	leaveq 
  802c16:	c3                   	retq   

0000000000802c17 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802c17:	55                   	push   %rbp
  802c18:	48 89 e5             	mov    %rsp,%rbp
  802c1b:	48 83 ec 20          	sub    $0x20,%rsp
  802c1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2b:	8b 50 0c             	mov    0xc(%rax),%edx
  802c2e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c35:	00 00 00 
  802c38:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802c3a:	be 00 00 00 00       	mov    $0x0,%esi
  802c3f:	bf 05 00 00 00       	mov    $0x5,%edi
  802c44:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802c4b:	00 00 00 
  802c4e:	ff d0                	callq  *%rax
  802c50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c57:	79 05                	jns    802c5e <devfile_stat+0x47>
		return r;
  802c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c5c:	eb 56                	jmp    802cb4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802c5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c62:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802c69:	00 00 00 
  802c6c:	48 89 c7             	mov    %rax,%rdi
  802c6f:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c7b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c82:	00 00 00 
  802c85:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c8b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c8f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c95:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c9c:	00 00 00 
  802c9f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ca5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ca9:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802caf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cb4:	c9                   	leaveq 
  802cb5:	c3                   	retq   

0000000000802cb6 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802cb6:	55                   	push   %rbp
  802cb7:	48 89 e5             	mov    %rsp,%rbp
  802cba:	48 83 ec 10          	sub    $0x10,%rsp
  802cbe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cc2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802cc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cc9:	8b 50 0c             	mov    0xc(%rax),%edx
  802ccc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cd3:	00 00 00 
  802cd6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802cd8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cdf:	00 00 00 
  802ce2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ce5:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ce8:	be 00 00 00 00       	mov    $0x0,%esi
  802ced:	bf 02 00 00 00       	mov    $0x2,%edi
  802cf2:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802cf9:	00 00 00 
  802cfc:	ff d0                	callq  *%rax
}
  802cfe:	c9                   	leaveq 
  802cff:	c3                   	retq   

0000000000802d00 <remove>:

// Delete a file
int
remove(const char *path)
{
  802d00:	55                   	push   %rbp
  802d01:	48 89 e5             	mov    %rsp,%rbp
  802d04:	48 83 ec 10          	sub    $0x10,%rsp
  802d08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802d0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d10:	48 89 c7             	mov    %rax,%rdi
  802d13:	48 b8 9f 11 80 00 00 	movabs $0x80119f,%rax
  802d1a:	00 00 00 
  802d1d:	ff d0                	callq  *%rax
  802d1f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d24:	7e 07                	jle    802d2d <remove+0x2d>
		return -E_BAD_PATH;
  802d26:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d2b:	eb 33                	jmp    802d60 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d31:	48 89 c6             	mov    %rax,%rsi
  802d34:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802d3b:	00 00 00 
  802d3e:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  802d45:	00 00 00 
  802d48:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802d4a:	be 00 00 00 00       	mov    $0x0,%esi
  802d4f:	bf 07 00 00 00       	mov    $0x7,%edi
  802d54:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802d5b:	00 00 00 
  802d5e:	ff d0                	callq  *%rax
}
  802d60:	c9                   	leaveq 
  802d61:	c3                   	retq   

0000000000802d62 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802d62:	55                   	push   %rbp
  802d63:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d66:	be 00 00 00 00       	mov    $0x0,%esi
  802d6b:	bf 08 00 00 00       	mov    $0x8,%edi
  802d70:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802d77:	00 00 00 
  802d7a:	ff d0                	callq  *%rax
}
  802d7c:	5d                   	pop    %rbp
  802d7d:	c3                   	retq   

0000000000802d7e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802d7e:	55                   	push   %rbp
  802d7f:	48 89 e5             	mov    %rsp,%rbp
  802d82:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d89:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d90:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d97:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d9e:	be 00 00 00 00       	mov    $0x0,%esi
  802da3:	48 89 c7             	mov    %rax,%rdi
  802da6:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
  802db2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802db5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db9:	79 28                	jns    802de3 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbe:	89 c6                	mov    %eax,%esi
  802dc0:	48 bf fa 40 80 00 00 	movabs $0x8040fa,%rdi
  802dc7:	00 00 00 
  802dca:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcf:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802dd6:	00 00 00 
  802dd9:	ff d2                	callq  *%rdx
		return fd_src;
  802ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dde:	e9 74 01 00 00       	jmpq   802f57 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802de3:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802dea:	be 01 01 00 00       	mov    $0x101,%esi
  802def:	48 89 c7             	mov    %rax,%rdi
  802df2:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  802df9:	00 00 00 
  802dfc:	ff d0                	callq  *%rax
  802dfe:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802e01:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e05:	79 39                	jns    802e40 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802e07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e0a:	89 c6                	mov    %eax,%esi
  802e0c:	48 bf 10 41 80 00 00 	movabs $0x804110,%rdi
  802e13:	00 00 00 
  802e16:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1b:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802e22:	00 00 00 
  802e25:	ff d2                	callq  *%rdx
		close(fd_src);
  802e27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2a:	89 c7                	mov    %eax,%edi
  802e2c:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  802e33:	00 00 00 
  802e36:	ff d0                	callq  *%rax
		return fd_dest;
  802e38:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e3b:	e9 17 01 00 00       	jmpq   802f57 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e40:	eb 74                	jmp    802eb6 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802e42:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e45:	48 63 d0             	movslq %eax,%rdx
  802e48:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e52:	48 89 ce             	mov    %rcx,%rsi
  802e55:	89 c7                	mov    %eax,%edi
  802e57:	48 b8 ea 25 80 00 00 	movabs $0x8025ea,%rax
  802e5e:	00 00 00 
  802e61:	ff d0                	callq  *%rax
  802e63:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802e66:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802e6a:	79 4a                	jns    802eb6 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802e6c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e6f:	89 c6                	mov    %eax,%esi
  802e71:	48 bf 2a 41 80 00 00 	movabs $0x80412a,%rdi
  802e78:	00 00 00 
  802e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e80:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802e87:	00 00 00 
  802e8a:	ff d2                	callq  *%rdx
			close(fd_src);
  802e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e8f:	89 c7                	mov    %eax,%edi
  802e91:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  802e98:	00 00 00 
  802e9b:	ff d0                	callq  *%rax
			close(fd_dest);
  802e9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ea0:	89 c7                	mov    %eax,%edi
  802ea2:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  802ea9:	00 00 00 
  802eac:	ff d0                	callq  *%rax
			return write_size;
  802eae:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802eb1:	e9 a1 00 00 00       	jmpq   802f57 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802eb6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec0:	ba 00 02 00 00       	mov    $0x200,%edx
  802ec5:	48 89 ce             	mov    %rcx,%rsi
  802ec8:	89 c7                	mov    %eax,%edi
  802eca:	48 b8 a0 24 80 00 00 	movabs $0x8024a0,%rax
  802ed1:	00 00 00 
  802ed4:	ff d0                	callq  *%rax
  802ed6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ed9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802edd:	0f 8f 5f ff ff ff    	jg     802e42 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ee7:	79 47                	jns    802f30 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802ee9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eec:	89 c6                	mov    %eax,%esi
  802eee:	48 bf 3d 41 80 00 00 	movabs $0x80413d,%rdi
  802ef5:	00 00 00 
  802ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  802efd:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802f04:	00 00 00 
  802f07:	ff d2                	callq  *%rdx
		close(fd_src);
  802f09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0c:	89 c7                	mov    %eax,%edi
  802f0e:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
		close(fd_dest);
  802f1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f1d:	89 c7                	mov    %eax,%edi
  802f1f:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  802f26:	00 00 00 
  802f29:	ff d0                	callq  *%rax
		return read_size;
  802f2b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f2e:	eb 27                	jmp    802f57 <copy+0x1d9>
	}
	close(fd_src);
  802f30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f33:	89 c7                	mov    %eax,%edi
  802f35:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  802f3c:	00 00 00 
  802f3f:	ff d0                	callq  *%rax
	close(fd_dest);
  802f41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f44:	89 c7                	mov    %eax,%edi
  802f46:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  802f4d:	00 00 00 
  802f50:	ff d0                	callq  *%rax
	return 0;
  802f52:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802f57:	c9                   	leaveq 
  802f58:	c3                   	retq   

0000000000802f59 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802f59:	55                   	push   %rbp
  802f5a:	48 89 e5             	mov    %rsp,%rbp
  802f5d:	53                   	push   %rbx
  802f5e:	48 83 ec 38          	sub    $0x38,%rsp
  802f62:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f66:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802f6a:	48 89 c7             	mov    %rax,%rdi
  802f6d:	48 b8 d6 1f 80 00 00 	movabs $0x801fd6,%rax
  802f74:	00 00 00 
  802f77:	ff d0                	callq  *%rax
  802f79:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f80:	0f 88 bf 01 00 00    	js     803145 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8a:	ba 07 04 00 00       	mov    $0x407,%edx
  802f8f:	48 89 c6             	mov    %rax,%rsi
  802f92:	bf 00 00 00 00       	mov    $0x0,%edi
  802f97:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
  802fa3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fa6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802faa:	0f 88 95 01 00 00    	js     803145 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802fb0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802fb4:	48 89 c7             	mov    %rax,%rdi
  802fb7:	48 b8 d6 1f 80 00 00 	movabs $0x801fd6,%rax
  802fbe:	00 00 00 
  802fc1:	ff d0                	callq  *%rax
  802fc3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fc6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fca:	0f 88 5d 01 00 00    	js     80312d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fd0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fd4:	ba 07 04 00 00       	mov    $0x407,%edx
  802fd9:	48 89 c6             	mov    %rax,%rsi
  802fdc:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe1:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  802fe8:	00 00 00 
  802feb:	ff d0                	callq  *%rax
  802fed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ff0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ff4:	0f 88 33 01 00 00    	js     80312d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802ffa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ffe:	48 89 c7             	mov    %rax,%rdi
  803001:	48 b8 ab 1f 80 00 00 	movabs $0x801fab,%rax
  803008:	00 00 00 
  80300b:	ff d0                	callq  *%rax
  80300d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803011:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803015:	ba 07 04 00 00       	mov    $0x407,%edx
  80301a:	48 89 c6             	mov    %rax,%rsi
  80301d:	bf 00 00 00 00       	mov    $0x0,%edi
  803022:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  803029:	00 00 00 
  80302c:	ff d0                	callq  *%rax
  80302e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803031:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803035:	79 05                	jns    80303c <pipe+0xe3>
		goto err2;
  803037:	e9 d9 00 00 00       	jmpq   803115 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80303c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803040:	48 89 c7             	mov    %rax,%rdi
  803043:	48 b8 ab 1f 80 00 00 	movabs $0x801fab,%rax
  80304a:	00 00 00 
  80304d:	ff d0                	callq  *%rax
  80304f:	48 89 c2             	mov    %rax,%rdx
  803052:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803056:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80305c:	48 89 d1             	mov    %rdx,%rcx
  80305f:	ba 00 00 00 00       	mov    $0x0,%edx
  803064:	48 89 c6             	mov    %rax,%rsi
  803067:	bf 00 00 00 00       	mov    $0x0,%edi
  80306c:	48 b8 8a 1b 80 00 00 	movabs $0x801b8a,%rax
  803073:	00 00 00 
  803076:	ff d0                	callq  *%rax
  803078:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80307b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80307f:	79 1b                	jns    80309c <pipe+0x143>
		goto err3;
  803081:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803082:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803086:	48 89 c6             	mov    %rax,%rsi
  803089:	bf 00 00 00 00       	mov    $0x0,%edi
  80308e:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  803095:	00 00 00 
  803098:	ff d0                	callq  *%rax
  80309a:	eb 79                	jmp    803115 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80309c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a0:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  8030a7:	00 00 00 
  8030aa:	8b 12                	mov    (%rdx),%edx
  8030ac:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8030ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8030b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030bd:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  8030c4:	00 00 00 
  8030c7:	8b 12                	mov    (%rdx),%edx
  8030c9:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8030cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030cf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8030d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030da:	48 89 c7             	mov    %rax,%rdi
  8030dd:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  8030e4:	00 00 00 
  8030e7:	ff d0                	callq  *%rax
  8030e9:	89 c2                	mov    %eax,%edx
  8030eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030ef:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8030f1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030f5:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8030f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030fd:	48 89 c7             	mov    %rax,%rdi
  803100:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  803107:	00 00 00 
  80310a:	ff d0                	callq  *%rax
  80310c:	89 03                	mov    %eax,(%rbx)
	return 0;
  80310e:	b8 00 00 00 00       	mov    $0x0,%eax
  803113:	eb 33                	jmp    803148 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803115:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803119:	48 89 c6             	mov    %rax,%rsi
  80311c:	bf 00 00 00 00       	mov    $0x0,%edi
  803121:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  803128:	00 00 00 
  80312b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80312d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803131:	48 89 c6             	mov    %rax,%rsi
  803134:	bf 00 00 00 00       	mov    $0x0,%edi
  803139:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  803140:	00 00 00 
  803143:	ff d0                	callq  *%rax
err:
	return r;
  803145:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803148:	48 83 c4 38          	add    $0x38,%rsp
  80314c:	5b                   	pop    %rbx
  80314d:	5d                   	pop    %rbp
  80314e:	c3                   	retq   

000000000080314f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80314f:	55                   	push   %rbp
  803150:	48 89 e5             	mov    %rsp,%rbp
  803153:	53                   	push   %rbx
  803154:	48 83 ec 28          	sub    $0x28,%rsp
  803158:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80315c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803160:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803167:	00 00 00 
  80316a:	48 8b 00             	mov    (%rax),%rax
  80316d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803173:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803176:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80317a:	48 89 c7             	mov    %rax,%rdi
  80317d:	48 b8 cd 39 80 00 00 	movabs $0x8039cd,%rax
  803184:	00 00 00 
  803187:	ff d0                	callq  *%rax
  803189:	89 c3                	mov    %eax,%ebx
  80318b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80318f:	48 89 c7             	mov    %rax,%rdi
  803192:	48 b8 cd 39 80 00 00 	movabs $0x8039cd,%rax
  803199:	00 00 00 
  80319c:	ff d0                	callq  *%rax
  80319e:	39 c3                	cmp    %eax,%ebx
  8031a0:	0f 94 c0             	sete   %al
  8031a3:	0f b6 c0             	movzbl %al,%eax
  8031a6:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8031a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8031b0:	00 00 00 
  8031b3:	48 8b 00             	mov    (%rax),%rax
  8031b6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8031bc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8031bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031c2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8031c5:	75 05                	jne    8031cc <_pipeisclosed+0x7d>
			return ret;
  8031c7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031ca:	eb 4f                	jmp    80321b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8031cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031cf:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8031d2:	74 42                	je     803216 <_pipeisclosed+0xc7>
  8031d4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8031d8:	75 3c                	jne    803216 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8031da:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8031e1:	00 00 00 
  8031e4:	48 8b 00             	mov    (%rax),%rax
  8031e7:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8031ed:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8031f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031f3:	89 c6                	mov    %eax,%esi
  8031f5:	48 bf 5d 41 80 00 00 	movabs $0x80415d,%rdi
  8031fc:	00 00 00 
  8031ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803204:	49 b8 56 06 80 00 00 	movabs $0x800656,%r8
  80320b:	00 00 00 
  80320e:	41 ff d0             	callq  *%r8
	}
  803211:	e9 4a ff ff ff       	jmpq   803160 <_pipeisclosed+0x11>
  803216:	e9 45 ff ff ff       	jmpq   803160 <_pipeisclosed+0x11>
}
  80321b:	48 83 c4 28          	add    $0x28,%rsp
  80321f:	5b                   	pop    %rbx
  803220:	5d                   	pop    %rbp
  803221:	c3                   	retq   

0000000000803222 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803222:	55                   	push   %rbp
  803223:	48 89 e5             	mov    %rsp,%rbp
  803226:	48 83 ec 30          	sub    $0x30,%rsp
  80322a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80322d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803231:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803234:	48 89 d6             	mov    %rdx,%rsi
  803237:	89 c7                	mov    %eax,%edi
  803239:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  803240:	00 00 00 
  803243:	ff d0                	callq  *%rax
  803245:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803248:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80324c:	79 05                	jns    803253 <pipeisclosed+0x31>
		return r;
  80324e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803251:	eb 31                	jmp    803284 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803257:	48 89 c7             	mov    %rax,%rdi
  80325a:	48 b8 ab 1f 80 00 00 	movabs $0x801fab,%rax
  803261:	00 00 00 
  803264:	ff d0                	callq  *%rax
  803266:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80326a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80326e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803272:	48 89 d6             	mov    %rdx,%rsi
  803275:	48 89 c7             	mov    %rax,%rdi
  803278:	48 b8 4f 31 80 00 00 	movabs $0x80314f,%rax
  80327f:	00 00 00 
  803282:	ff d0                	callq  *%rax
}
  803284:	c9                   	leaveq 
  803285:	c3                   	retq   

0000000000803286 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803286:	55                   	push   %rbp
  803287:	48 89 e5             	mov    %rsp,%rbp
  80328a:	48 83 ec 40          	sub    $0x40,%rsp
  80328e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803292:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803296:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80329a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80329e:	48 89 c7             	mov    %rax,%rdi
  8032a1:	48 b8 ab 1f 80 00 00 	movabs $0x801fab,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax
  8032ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8032b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8032b9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8032c0:	00 
  8032c1:	e9 92 00 00 00       	jmpq   803358 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8032c6:	eb 41                	jmp    803309 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8032c8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8032cd:	74 09                	je     8032d8 <devpipe_read+0x52>
				return i;
  8032cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032d3:	e9 92 00 00 00       	jmpq   80336a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8032d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e0:	48 89 d6             	mov    %rdx,%rsi
  8032e3:	48 89 c7             	mov    %rax,%rdi
  8032e6:	48 b8 4f 31 80 00 00 	movabs $0x80314f,%rax
  8032ed:	00 00 00 
  8032f0:	ff d0                	callq  *%rax
  8032f2:	85 c0                	test   %eax,%eax
  8032f4:	74 07                	je     8032fd <devpipe_read+0x77>
				return 0;
  8032f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032fb:	eb 6d                	jmp    80336a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8032fd:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  803304:	00 00 00 
  803307:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330d:	8b 10                	mov    (%rax),%edx
  80330f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803313:	8b 40 04             	mov    0x4(%rax),%eax
  803316:	39 c2                	cmp    %eax,%edx
  803318:	74 ae                	je     8032c8 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80331a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80331e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803322:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332a:	8b 00                	mov    (%rax),%eax
  80332c:	99                   	cltd   
  80332d:	c1 ea 1b             	shr    $0x1b,%edx
  803330:	01 d0                	add    %edx,%eax
  803332:	83 e0 1f             	and    $0x1f,%eax
  803335:	29 d0                	sub    %edx,%eax
  803337:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80333b:	48 98                	cltq   
  80333d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803342:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803344:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803348:	8b 00                	mov    (%rax),%eax
  80334a:	8d 50 01             	lea    0x1(%rax),%edx
  80334d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803351:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803353:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80335c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803360:	0f 82 60 ff ff ff    	jb     8032c6 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80336a:	c9                   	leaveq 
  80336b:	c3                   	retq   

000000000080336c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80336c:	55                   	push   %rbp
  80336d:	48 89 e5             	mov    %rsp,%rbp
  803370:	48 83 ec 40          	sub    $0x40,%rsp
  803374:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803378:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80337c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803380:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803384:	48 89 c7             	mov    %rax,%rdi
  803387:	48 b8 ab 1f 80 00 00 	movabs $0x801fab,%rax
  80338e:	00 00 00 
  803391:	ff d0                	callq  *%rax
  803393:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803397:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80339b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80339f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8033a6:	00 
  8033a7:	e9 8e 00 00 00       	jmpq   80343a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8033ac:	eb 31                	jmp    8033df <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8033ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b6:	48 89 d6             	mov    %rdx,%rsi
  8033b9:	48 89 c7             	mov    %rax,%rdi
  8033bc:	48 b8 4f 31 80 00 00 	movabs $0x80314f,%rax
  8033c3:	00 00 00 
  8033c6:	ff d0                	callq  *%rax
  8033c8:	85 c0                	test   %eax,%eax
  8033ca:	74 07                	je     8033d3 <devpipe_write+0x67>
				return 0;
  8033cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d1:	eb 79                	jmp    80344c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8033d3:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8033df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e3:	8b 40 04             	mov    0x4(%rax),%eax
  8033e6:	48 63 d0             	movslq %eax,%rdx
  8033e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ed:	8b 00                	mov    (%rax),%eax
  8033ef:	48 98                	cltq   
  8033f1:	48 83 c0 20          	add    $0x20,%rax
  8033f5:	48 39 c2             	cmp    %rax,%rdx
  8033f8:	73 b4                	jae    8033ae <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8033fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033fe:	8b 40 04             	mov    0x4(%rax),%eax
  803401:	99                   	cltd   
  803402:	c1 ea 1b             	shr    $0x1b,%edx
  803405:	01 d0                	add    %edx,%eax
  803407:	83 e0 1f             	and    $0x1f,%eax
  80340a:	29 d0                	sub    %edx,%eax
  80340c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803410:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803414:	48 01 ca             	add    %rcx,%rdx
  803417:	0f b6 0a             	movzbl (%rdx),%ecx
  80341a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80341e:	48 98                	cltq   
  803420:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803424:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803428:	8b 40 04             	mov    0x4(%rax),%eax
  80342b:	8d 50 01             	lea    0x1(%rax),%edx
  80342e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803432:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803435:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80343a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80343e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803442:	0f 82 64 ff ff ff    	jb     8033ac <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80344c:	c9                   	leaveq 
  80344d:	c3                   	retq   

000000000080344e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80344e:	55                   	push   %rbp
  80344f:	48 89 e5             	mov    %rsp,%rbp
  803452:	48 83 ec 20          	sub    $0x20,%rsp
  803456:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80345a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80345e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803462:	48 89 c7             	mov    %rax,%rdi
  803465:	48 b8 ab 1f 80 00 00 	movabs $0x801fab,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
  803471:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803475:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803479:	48 be 70 41 80 00 00 	movabs $0x804170,%rsi
  803480:	00 00 00 
  803483:	48 89 c7             	mov    %rax,%rdi
  803486:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  80348d:	00 00 00 
  803490:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803496:	8b 50 04             	mov    0x4(%rax),%edx
  803499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80349d:	8b 00                	mov    (%rax),%eax
  80349f:	29 c2                	sub    %eax,%edx
  8034a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034a5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8034ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034af:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8034b6:	00 00 00 
	stat->st_dev = &devpipe;
  8034b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034bd:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  8034c4:	00 00 00 
  8034c7:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8034ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034d3:	c9                   	leaveq 
  8034d4:	c3                   	retq   

00000000008034d5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8034d5:	55                   	push   %rbp
  8034d6:	48 89 e5             	mov    %rsp,%rbp
  8034d9:	48 83 ec 10          	sub    $0x10,%rsp
  8034dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8034e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034e5:	48 89 c6             	mov    %rax,%rsi
  8034e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ed:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  8034f4:	00 00 00 
  8034f7:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8034f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034fd:	48 89 c7             	mov    %rax,%rdi
  803500:	48 b8 ab 1f 80 00 00 	movabs $0x801fab,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
  80350c:	48 89 c6             	mov    %rax,%rsi
  80350f:	bf 00 00 00 00       	mov    $0x0,%edi
  803514:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  80351b:	00 00 00 
  80351e:	ff d0                	callq  *%rax
}
  803520:	c9                   	leaveq 
  803521:	c3                   	retq   

0000000000803522 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803522:	55                   	push   %rbp
  803523:	48 89 e5             	mov    %rsp,%rbp
  803526:	48 83 ec 20          	sub    $0x20,%rsp
  80352a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80352d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803530:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803533:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803537:	be 01 00 00 00       	mov    $0x1,%esi
  80353c:	48 89 c7             	mov    %rax,%rdi
  80353f:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  803546:	00 00 00 
  803549:	ff d0                	callq  *%rax
}
  80354b:	c9                   	leaveq 
  80354c:	c3                   	retq   

000000000080354d <getchar>:

int
getchar(void)
{
  80354d:	55                   	push   %rbp
  80354e:	48 89 e5             	mov    %rsp,%rbp
  803551:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803555:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803559:	ba 01 00 00 00       	mov    $0x1,%edx
  80355e:	48 89 c6             	mov    %rax,%rsi
  803561:	bf 00 00 00 00       	mov    $0x0,%edi
  803566:	48 b8 a0 24 80 00 00 	movabs $0x8024a0,%rax
  80356d:	00 00 00 
  803570:	ff d0                	callq  *%rax
  803572:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803575:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803579:	79 05                	jns    803580 <getchar+0x33>
		return r;
  80357b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357e:	eb 14                	jmp    803594 <getchar+0x47>
	if (r < 1)
  803580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803584:	7f 07                	jg     80358d <getchar+0x40>
		return -E_EOF;
  803586:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80358b:	eb 07                	jmp    803594 <getchar+0x47>
	return c;
  80358d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803591:	0f b6 c0             	movzbl %al,%eax
}
  803594:	c9                   	leaveq 
  803595:	c3                   	retq   

0000000000803596 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803596:	55                   	push   %rbp
  803597:	48 89 e5             	mov    %rsp,%rbp
  80359a:	48 83 ec 20          	sub    $0x20,%rsp
  80359e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8035a1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035a8:	48 89 d6             	mov    %rdx,%rsi
  8035ab:	89 c7                	mov    %eax,%edi
  8035ad:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  8035b4:	00 00 00 
  8035b7:	ff d0                	callq  *%rax
  8035b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c0:	79 05                	jns    8035c7 <iscons+0x31>
		return r;
  8035c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c5:	eb 1a                	jmp    8035e1 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8035c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035cb:	8b 10                	mov    (%rax),%edx
  8035cd:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  8035d4:	00 00 00 
  8035d7:	8b 00                	mov    (%rax),%eax
  8035d9:	39 c2                	cmp    %eax,%edx
  8035db:	0f 94 c0             	sete   %al
  8035de:	0f b6 c0             	movzbl %al,%eax
}
  8035e1:	c9                   	leaveq 
  8035e2:	c3                   	retq   

00000000008035e3 <opencons>:

int
opencons(void)
{
  8035e3:	55                   	push   %rbp
  8035e4:	48 89 e5             	mov    %rsp,%rbp
  8035e7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8035eb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8035ef:	48 89 c7             	mov    %rax,%rdi
  8035f2:	48 b8 d6 1f 80 00 00 	movabs $0x801fd6,%rax
  8035f9:	00 00 00 
  8035fc:	ff d0                	callq  *%rax
  8035fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803601:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803605:	79 05                	jns    80360c <opencons+0x29>
		return r;
  803607:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360a:	eb 5b                	jmp    803667 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80360c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803610:	ba 07 04 00 00       	mov    $0x407,%edx
  803615:	48 89 c6             	mov    %rax,%rsi
  803618:	bf 00 00 00 00       	mov    $0x0,%edi
  80361d:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  803624:	00 00 00 
  803627:	ff d0                	callq  *%rax
  803629:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80362c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803630:	79 05                	jns    803637 <opencons+0x54>
		return r;
  803632:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803635:	eb 30                	jmp    803667 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80363b:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  803642:	00 00 00 
  803645:	8b 12                	mov    (%rdx),%edx
  803647:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803649:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803658:	48 89 c7             	mov    %rax,%rdi
  80365b:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  803662:	00 00 00 
  803665:	ff d0                	callq  *%rax
}
  803667:	c9                   	leaveq 
  803668:	c3                   	retq   

0000000000803669 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803669:	55                   	push   %rbp
  80366a:	48 89 e5             	mov    %rsp,%rbp
  80366d:	48 83 ec 30          	sub    $0x30,%rsp
  803671:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803675:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803679:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80367d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803682:	75 07                	jne    80368b <devcons_read+0x22>
		return 0;
  803684:	b8 00 00 00 00       	mov    $0x0,%eax
  803689:	eb 4b                	jmp    8036d6 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80368b:	eb 0c                	jmp    803699 <devcons_read+0x30>
		sys_yield();
  80368d:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  803694:	00 00 00 
  803697:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803699:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  8036a0:	00 00 00 
  8036a3:	ff d0                	callq  *%rax
  8036a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ac:	74 df                	je     80368d <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8036ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b2:	79 05                	jns    8036b9 <devcons_read+0x50>
		return c;
  8036b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b7:	eb 1d                	jmp    8036d6 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8036b9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8036bd:	75 07                	jne    8036c6 <devcons_read+0x5d>
		return 0;
  8036bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c4:	eb 10                	jmp    8036d6 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8036c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c9:	89 c2                	mov    %eax,%edx
  8036cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036cf:	88 10                	mov    %dl,(%rax)
	return 1;
  8036d1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8036d6:	c9                   	leaveq 
  8036d7:	c3                   	retq   

00000000008036d8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8036d8:	55                   	push   %rbp
  8036d9:	48 89 e5             	mov    %rsp,%rbp
  8036dc:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8036e3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8036ea:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8036f1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8036f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036ff:	eb 76                	jmp    803777 <devcons_write+0x9f>
		m = n - tot;
  803701:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803708:	89 c2                	mov    %eax,%edx
  80370a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370d:	29 c2                	sub    %eax,%edx
  80370f:	89 d0                	mov    %edx,%eax
  803711:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803714:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803717:	83 f8 7f             	cmp    $0x7f,%eax
  80371a:	76 07                	jbe    803723 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80371c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803723:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803726:	48 63 d0             	movslq %eax,%rdx
  803729:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80372c:	48 63 c8             	movslq %eax,%rcx
  80372f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803736:	48 01 c1             	add    %rax,%rcx
  803739:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803740:	48 89 ce             	mov    %rcx,%rsi
  803743:	48 89 c7             	mov    %rax,%rdi
  803746:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  80374d:	00 00 00 
  803750:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803752:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803755:	48 63 d0             	movslq %eax,%rdx
  803758:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80375f:	48 89 d6             	mov    %rdx,%rsi
  803762:	48 89 c7             	mov    %rax,%rdi
  803765:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  80376c:	00 00 00 
  80376f:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803771:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803774:	01 45 fc             	add    %eax,-0x4(%rbp)
  803777:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377a:	48 98                	cltq   
  80377c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803783:	0f 82 78 ff ff ff    	jb     803701 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803789:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80378c:	c9                   	leaveq 
  80378d:	c3                   	retq   

000000000080378e <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80378e:	55                   	push   %rbp
  80378f:	48 89 e5             	mov    %rsp,%rbp
  803792:	48 83 ec 08          	sub    $0x8,%rsp
  803796:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80379a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80379f:	c9                   	leaveq 
  8037a0:	c3                   	retq   

00000000008037a1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8037a1:	55                   	push   %rbp
  8037a2:	48 89 e5             	mov    %rsp,%rbp
  8037a5:	48 83 ec 10          	sub    $0x10,%rsp
  8037a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8037b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b5:	48 be 7c 41 80 00 00 	movabs $0x80417c,%rsi
  8037bc:	00 00 00 
  8037bf:	48 89 c7             	mov    %rax,%rdi
  8037c2:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  8037c9:	00 00 00 
  8037cc:	ff d0                	callq  *%rax
	return 0;
  8037ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037d3:	c9                   	leaveq 
  8037d4:	c3                   	retq   

00000000008037d5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8037d5:	55                   	push   %rbp
  8037d6:	48 89 e5             	mov    %rsp,%rbp
  8037d9:	48 83 ec 30          	sub    $0x30,%rsp
  8037dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8037e9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8037f0:	00 00 00 
  8037f3:	48 8b 00             	mov    (%rax),%rax
  8037f6:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8037fc:	85 c0                	test   %eax,%eax
  8037fe:	75 34                	jne    803834 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803800:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  803807:	00 00 00 
  80380a:	ff d0                	callq  *%rax
  80380c:	25 ff 03 00 00       	and    $0x3ff,%eax
  803811:	48 98                	cltq   
  803813:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80381a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803821:	00 00 00 
  803824:	48 01 c2             	add    %rax,%rdx
  803827:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80382e:	00 00 00 
  803831:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803834:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803839:	75 0e                	jne    803849 <ipc_recv+0x74>
		pg = (void*) UTOP;
  80383b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803842:	00 00 00 
  803845:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803849:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80384d:	48 89 c7             	mov    %rax,%rdi
  803850:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  803857:	00 00 00 
  80385a:	ff d0                	callq  *%rax
  80385c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80385f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803863:	79 19                	jns    80387e <ipc_recv+0xa9>
		*from_env_store = 0;
  803865:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803869:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80386f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803873:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803879:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387c:	eb 53                	jmp    8038d1 <ipc_recv+0xfc>
	}
	if(from_env_store)
  80387e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803883:	74 19                	je     80389e <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803885:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80388c:	00 00 00 
  80388f:	48 8b 00             	mov    (%rax),%rax
  803892:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80389c:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80389e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038a3:	74 19                	je     8038be <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8038a5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8038ac:	00 00 00 
  8038af:	48 8b 00             	mov    (%rax),%rax
  8038b2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8038b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038bc:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8038be:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8038c5:	00 00 00 
  8038c8:	48 8b 00             	mov    (%rax),%rax
  8038cb:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8038d1:	c9                   	leaveq 
  8038d2:	c3                   	retq   

00000000008038d3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8038d3:	55                   	push   %rbp
  8038d4:	48 89 e5             	mov    %rsp,%rbp
  8038d7:	48 83 ec 30          	sub    $0x30,%rsp
  8038db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038de:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8038e1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8038e5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8038e8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8038ed:	75 0e                	jne    8038fd <ipc_send+0x2a>
		pg = (void*)UTOP;
  8038ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8038f6:	00 00 00 
  8038f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8038fd:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803900:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803903:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803907:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80390a:	89 c7                	mov    %eax,%edi
  80390c:	48 b8 0e 1d 80 00 00 	movabs $0x801d0e,%rax
  803913:	00 00 00 
  803916:	ff d0                	callq  *%rax
  803918:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80391b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80391f:	75 0c                	jne    80392d <ipc_send+0x5a>
			sys_yield();
  803921:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  803928:	00 00 00 
  80392b:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80392d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803931:	74 ca                	je     8038fd <ipc_send+0x2a>
	if(result != 0)
  803933:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803937:	74 20                	je     803959 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803939:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393c:	89 c6                	mov    %eax,%esi
  80393e:	48 bf 83 41 80 00 00 	movabs $0x804183,%rdi
  803945:	00 00 00 
  803948:	b8 00 00 00 00       	mov    $0x0,%eax
  80394d:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  803954:	00 00 00 
  803957:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803959:	c9                   	leaveq 
  80395a:	c3                   	retq   

000000000080395b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80395b:	55                   	push   %rbp
  80395c:	48 89 e5             	mov    %rsp,%rbp
  80395f:	48 83 ec 14          	sub    $0x14,%rsp
  803963:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803966:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80396d:	eb 4e                	jmp    8039bd <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80396f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803976:	00 00 00 
  803979:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397c:	48 98                	cltq   
  80397e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803985:	48 01 d0             	add    %rdx,%rax
  803988:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80398e:	8b 00                	mov    (%rax),%eax
  803990:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803993:	75 24                	jne    8039b9 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803995:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80399c:	00 00 00 
  80399f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a2:	48 98                	cltq   
  8039a4:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8039ab:	48 01 d0             	add    %rdx,%rax
  8039ae:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8039b4:	8b 40 08             	mov    0x8(%rax),%eax
  8039b7:	eb 12                	jmp    8039cb <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8039b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8039bd:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8039c4:	7e a9                	jle    80396f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8039c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039cb:	c9                   	leaveq 
  8039cc:	c3                   	retq   

00000000008039cd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8039cd:	55                   	push   %rbp
  8039ce:	48 89 e5             	mov    %rsp,%rbp
  8039d1:	48 83 ec 18          	sub    $0x18,%rsp
  8039d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8039d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039dd:	48 c1 e8 15          	shr    $0x15,%rax
  8039e1:	48 89 c2             	mov    %rax,%rdx
  8039e4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8039eb:	01 00 00 
  8039ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039f2:	83 e0 01             	and    $0x1,%eax
  8039f5:	48 85 c0             	test   %rax,%rax
  8039f8:	75 07                	jne    803a01 <pageref+0x34>
		return 0;
  8039fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ff:	eb 53                	jmp    803a54 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803a01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a05:	48 c1 e8 0c          	shr    $0xc,%rax
  803a09:	48 89 c2             	mov    %rax,%rdx
  803a0c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a13:	01 00 00 
  803a16:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803a1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a22:	83 e0 01             	and    $0x1,%eax
  803a25:	48 85 c0             	test   %rax,%rax
  803a28:	75 07                	jne    803a31 <pageref+0x64>
		return 0;
  803a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2f:	eb 23                	jmp    803a54 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803a31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a35:	48 c1 e8 0c          	shr    $0xc,%rax
  803a39:	48 89 c2             	mov    %rax,%rdx
  803a3c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803a43:	00 00 00 
  803a46:	48 c1 e2 04          	shl    $0x4,%rdx
  803a4a:	48 01 d0             	add    %rdx,%rax
  803a4d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803a51:	0f b7 c0             	movzwl %ax,%eax
}
  803a54:	c9                   	leaveq 
  803a55:	c3                   	retq   
