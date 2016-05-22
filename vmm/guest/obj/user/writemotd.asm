
vmm/guest/obj/user/writemotd:     file format elf64-x86-64


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
  800060:	48 bf a0 3c 80 00 00 	movabs $0x803ca0,%rdi
  800067:	00 00 00 
  80006a:	48 b8 45 28 80 00 00 	movabs $0x802845,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	79 30                	jns    8000af <umain+0x6c>
		panic("open /newmotd: %e", rfd);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba a9 3c 80 00 00 	movabs $0x803ca9,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf bb 3c 80 00 00 	movabs $0x803cbb,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if ((wfd = open("/motd", O_RDWR)) < 0)
  8000af:	be 02 00 00 00       	mov    $0x2,%esi
  8000b4:	48 bf cc 3c 80 00 00 	movabs $0x803ccc,%rdi
  8000bb:	00 00 00 
  8000be:	48 b8 45 28 80 00 00 	movabs $0x802845,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("open /motd: %e", wfd);
  8000d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba d2 3c 80 00 00 	movabs $0x803cd2,%rdx
  8000df:	00 00 00 
  8000e2:	be 0d 00 00 00       	mov    $0xd,%esi
  8000e7:	48 bf bb 3c 80 00 00 	movabs $0x803cbb,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8
	cprintf("file descriptors %d %d\n", rfd, wfd);
  800103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	89 c6                	mov    %eax,%esi
  80010b:	48 bf e1 3c 80 00 00 	movabs $0x803ce1,%rdi
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
  80012e:	48 ba 00 3d 80 00 00 	movabs $0x803d00,%rdx
  800135:	00 00 00 
  800138:	be 10 00 00 00       	mov    $0x10,%esi
  80013d:	48 bf bb 3c 80 00 00 	movabs $0x803cbb,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 b9 1d 04 80 00 00 	movabs $0x80041d,%rcx
  800153:	00 00 00 
  800156:	ff d1                	callq  *%rcx

	cprintf("OLD MOTD\n===\n");
  800158:	48 bf 32 3d 80 00 00 	movabs $0x803d32,%rdi
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
  8001a8:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001bb:	7f b8                	jg     800175 <umain+0x132>
		sys_cputs(buf, n);
	cprintf("===\n");
  8001bd:	48 bf 40 3d 80 00 00 	movabs $0x803d40,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	callq  *%rdx
	seek(wfd, 0);
  8001d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001db:	be 00 00 00 00       	mov    $0x0,%esi
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 8d 25 80 00 00 	movabs $0x80258d,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax

	if ((r = ftruncate(wfd, 0)) < 0)
  8001ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800207:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("truncate /motd: %e", r);
  80020d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 45 3d 80 00 00 	movabs $0x803d45,%rdx
  800219:	00 00 00 
  80021c:	be 19 00 00 00       	mov    $0x19,%esi
  800221:	48 bf bb 3c 80 00 00 	movabs $0x803cbb,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8

	cprintf("NEW MOTD\n===\n");
  80023d:	48 bf 58 3d 80 00 00 	movabs $0x803d58,%rdi
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
  80028e:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002a3:	74 30                	je     8002d5 <umain+0x292>
			panic("write /motd: %e", r);
  8002a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a8:	89 c1                	mov    %eax,%ecx
  8002aa:	48 ba 66 3d 80 00 00 	movabs $0x803d66,%rdx
  8002b1:	00 00 00 
  8002b4:	be 1f 00 00 00       	mov    $0x1f,%esi
  8002b9:	48 bf bb 3c 80 00 00 	movabs $0x803cbb,%rdi
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
  8002e9:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
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
  800302:	48 bf 40 3d 80 00 00 	movabs $0x803d40,%rdi
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
  800328:	48 ba 76 3d 80 00 00 	movabs $0x803d76,%rdx
  80032f:	00 00 00 
  800332:	be 24 00 00 00       	mov    $0x24,%esi
  800337:	48 bf bb 3c 80 00 00 	movabs $0x803cbb,%rdi
  80033e:	00 00 00 
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  80034d:	00 00 00 
  800350:	41 ff d0             	callq  *%r8

	close(rfd);
  800353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800356:	89 c7                	mov    %eax,%edi
  800358:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	close(wfd);
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
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
  8003ad:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8003c7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  8003fe:	48 b8 cb 21 80 00 00 	movabs $0x8021cb,%rax
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
  8004a6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  8004d7:	48 bf 98 3d 80 00 00 	movabs $0x803d98,%rdi
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
  800513:	48 bf bb 3d 80 00 00 	movabs $0x803dbb,%rdi
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
  8007c2:	48 ba b0 3f 80 00 00 	movabs $0x803fb0,%rdx
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
  800aba:	48 b8 d8 3f 80 00 00 	movabs $0x803fd8,%rax
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
  800c0d:	48 b8 00 3f 80 00 00 	movabs $0x803f00,%rax
  800c14:	00 00 00 
  800c17:	48 63 d3             	movslq %ebx,%rdx
  800c1a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c1e:	4d 85 e4             	test   %r12,%r12
  800c21:	75 2e                	jne    800c51 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c23:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2b:	89 d9                	mov    %ebx,%ecx
  800c2d:	48 ba c1 3f 80 00 00 	movabs $0x803fc1,%rdx
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
  800c5c:	48 ba ca 3f 80 00 00 	movabs $0x803fca,%rdx
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
  800cb6:	49 bc cd 3f 80 00 00 	movabs $0x803fcd,%r12
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
  8019bc:	48 ba 88 42 80 00 00 	movabs $0x804288,%rdx
  8019c3:	00 00 00 
  8019c6:	be 23 00 00 00       	mov    $0x23,%esi
  8019cb:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
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

0000000000801e8a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e8a:	55                   	push   %rbp
  801e8b:	48 89 e5             	mov    %rsp,%rbp
  801e8e:	48 83 ec 08          	sub    $0x8,%rsp
  801e92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e96:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e9a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ea1:	ff ff ff 
  801ea4:	48 01 d0             	add    %rdx,%rax
  801ea7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801eab:	c9                   	leaveq 
  801eac:	c3                   	retq   

0000000000801ead <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ead:	55                   	push   %rbp
  801eae:	48 89 e5             	mov    %rsp,%rbp
  801eb1:	48 83 ec 08          	sub    $0x8,%rsp
  801eb5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801eb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ebd:	48 89 c7             	mov    %rax,%rdi
  801ec0:	48 b8 8a 1e 80 00 00 	movabs $0x801e8a,%rax
  801ec7:	00 00 00 
  801eca:	ff d0                	callq  *%rax
  801ecc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ed2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ed6:	c9                   	leaveq 
  801ed7:	c3                   	retq   

0000000000801ed8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ed8:	55                   	push   %rbp
  801ed9:	48 89 e5             	mov    %rsp,%rbp
  801edc:	48 83 ec 18          	sub    $0x18,%rsp
  801ee0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ee4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801eeb:	eb 6b                	jmp    801f58 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef0:	48 98                	cltq   
  801ef2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ef8:	48 c1 e0 0c          	shl    $0xc,%rax
  801efc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f04:	48 c1 e8 15          	shr    $0x15,%rax
  801f08:	48 89 c2             	mov    %rax,%rdx
  801f0b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f12:	01 00 00 
  801f15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f19:	83 e0 01             	and    $0x1,%eax
  801f1c:	48 85 c0             	test   %rax,%rax
  801f1f:	74 21                	je     801f42 <fd_alloc+0x6a>
  801f21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f25:	48 c1 e8 0c          	shr    $0xc,%rax
  801f29:	48 89 c2             	mov    %rax,%rdx
  801f2c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f33:	01 00 00 
  801f36:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f3a:	83 e0 01             	and    $0x1,%eax
  801f3d:	48 85 c0             	test   %rax,%rax
  801f40:	75 12                	jne    801f54 <fd_alloc+0x7c>
			*fd_store = fd;
  801f42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f4a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f52:	eb 1a                	jmp    801f6e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f54:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f58:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f5c:	7e 8f                	jle    801eed <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f62:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f69:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f6e:	c9                   	leaveq 
  801f6f:	c3                   	retq   

0000000000801f70 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f70:	55                   	push   %rbp
  801f71:	48 89 e5             	mov    %rsp,%rbp
  801f74:	48 83 ec 20          	sub    $0x20,%rsp
  801f78:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f83:	78 06                	js     801f8b <fd_lookup+0x1b>
  801f85:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f89:	7e 07                	jle    801f92 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f90:	eb 6c                	jmp    801ffe <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f92:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f95:	48 98                	cltq   
  801f97:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f9d:	48 c1 e0 0c          	shl    $0xc,%rax
  801fa1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fa5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa9:	48 c1 e8 15          	shr    $0x15,%rax
  801fad:	48 89 c2             	mov    %rax,%rdx
  801fb0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fb7:	01 00 00 
  801fba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbe:	83 e0 01             	and    $0x1,%eax
  801fc1:	48 85 c0             	test   %rax,%rax
  801fc4:	74 21                	je     801fe7 <fd_lookup+0x77>
  801fc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fca:	48 c1 e8 0c          	shr    $0xc,%rax
  801fce:	48 89 c2             	mov    %rax,%rdx
  801fd1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fd8:	01 00 00 
  801fdb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fdf:	83 e0 01             	and    $0x1,%eax
  801fe2:	48 85 c0             	test   %rax,%rax
  801fe5:	75 07                	jne    801fee <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fe7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fec:	eb 10                	jmp    801ffe <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ff6:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffe:	c9                   	leaveq 
  801fff:	c3                   	retq   

0000000000802000 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802000:	55                   	push   %rbp
  802001:	48 89 e5             	mov    %rsp,%rbp
  802004:	48 83 ec 30          	sub    $0x30,%rsp
  802008:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80200c:	89 f0                	mov    %esi,%eax
  80200e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802011:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802015:	48 89 c7             	mov    %rax,%rdi
  802018:	48 b8 8a 1e 80 00 00 	movabs $0x801e8a,%rax
  80201f:	00 00 00 
  802022:	ff d0                	callq  *%rax
  802024:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802028:	48 89 d6             	mov    %rdx,%rsi
  80202b:	89 c7                	mov    %eax,%edi
  80202d:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  802034:	00 00 00 
  802037:	ff d0                	callq  *%rax
  802039:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80203c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802040:	78 0a                	js     80204c <fd_close+0x4c>
	    || fd != fd2)
  802042:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802046:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80204a:	74 12                	je     80205e <fd_close+0x5e>
		return (must_exist ? r : 0);
  80204c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802050:	74 05                	je     802057 <fd_close+0x57>
  802052:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802055:	eb 05                	jmp    80205c <fd_close+0x5c>
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
  80205c:	eb 69                	jmp    8020c7 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80205e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802062:	8b 00                	mov    (%rax),%eax
  802064:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802068:	48 89 d6             	mov    %rdx,%rsi
  80206b:	89 c7                	mov    %eax,%edi
  80206d:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  802074:	00 00 00 
  802077:	ff d0                	callq  *%rax
  802079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80207c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802080:	78 2a                	js     8020ac <fd_close+0xac>
		if (dev->dev_close)
  802082:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802086:	48 8b 40 20          	mov    0x20(%rax),%rax
  80208a:	48 85 c0             	test   %rax,%rax
  80208d:	74 16                	je     8020a5 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80208f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802093:	48 8b 40 20          	mov    0x20(%rax),%rax
  802097:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80209b:	48 89 d7             	mov    %rdx,%rdi
  80209e:	ff d0                	callq  *%rax
  8020a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a3:	eb 07                	jmp    8020ac <fd_close+0xac>
		else
			r = 0;
  8020a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b0:	48 89 c6             	mov    %rax,%rsi
  8020b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b8:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  8020bf:	00 00 00 
  8020c2:	ff d0                	callq  *%rax
	return r;
  8020c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020c7:	c9                   	leaveq 
  8020c8:	c3                   	retq   

00000000008020c9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020c9:	55                   	push   %rbp
  8020ca:	48 89 e5             	mov    %rsp,%rbp
  8020cd:	48 83 ec 20          	sub    $0x20,%rsp
  8020d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020df:	eb 41                	jmp    802122 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020e1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020e8:	00 00 00 
  8020eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020ee:	48 63 d2             	movslq %edx,%rdx
  8020f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020f5:	8b 00                	mov    (%rax),%eax
  8020f7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020fa:	75 22                	jne    80211e <dev_lookup+0x55>
			*dev = devtab[i];
  8020fc:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802103:	00 00 00 
  802106:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802109:	48 63 d2             	movslq %edx,%rdx
  80210c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802110:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802114:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802117:	b8 00 00 00 00       	mov    $0x0,%eax
  80211c:	eb 60                	jmp    80217e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80211e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802122:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802129:	00 00 00 
  80212c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80212f:	48 63 d2             	movslq %edx,%rdx
  802132:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802136:	48 85 c0             	test   %rax,%rax
  802139:	75 a6                	jne    8020e1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80213b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802142:	00 00 00 
  802145:	48 8b 00             	mov    (%rax),%rax
  802148:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80214e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802151:	89 c6                	mov    %eax,%esi
  802153:	48 bf b8 42 80 00 00 	movabs $0x8042b8,%rdi
  80215a:	00 00 00 
  80215d:	b8 00 00 00 00       	mov    $0x0,%eax
  802162:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  802169:	00 00 00 
  80216c:	ff d1                	callq  *%rcx
	*dev = 0;
  80216e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802172:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802179:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80217e:	c9                   	leaveq 
  80217f:	c3                   	retq   

0000000000802180 <close>:

int
close(int fdnum)
{
  802180:	55                   	push   %rbp
  802181:	48 89 e5             	mov    %rsp,%rbp
  802184:	48 83 ec 20          	sub    $0x20,%rsp
  802188:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80218b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80218f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802192:	48 89 d6             	mov    %rdx,%rsi
  802195:	89 c7                	mov    %eax,%edi
  802197:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	callq  *%rax
  8021a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021aa:	79 05                	jns    8021b1 <close+0x31>
		return r;
  8021ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021af:	eb 18                	jmp    8021c9 <close+0x49>
	else
		return fd_close(fd, 1);
  8021b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021b5:	be 01 00 00 00       	mov    $0x1,%esi
  8021ba:	48 89 c7             	mov    %rax,%rdi
  8021bd:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  8021c4:	00 00 00 
  8021c7:	ff d0                	callq  *%rax
}
  8021c9:	c9                   	leaveq 
  8021ca:	c3                   	retq   

00000000008021cb <close_all>:

void
close_all(void)
{
  8021cb:	55                   	push   %rbp
  8021cc:	48 89 e5             	mov    %rsp,%rbp
  8021cf:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021da:	eb 15                	jmp    8021f1 <close_all+0x26>
		close(i);
  8021dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021df:	89 c7                	mov    %eax,%edi
  8021e1:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  8021e8:	00 00 00 
  8021eb:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021f1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021f5:	7e e5                	jle    8021dc <close_all+0x11>
		close(i);
}
  8021f7:	c9                   	leaveq 
  8021f8:	c3                   	retq   

00000000008021f9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021f9:	55                   	push   %rbp
  8021fa:	48 89 e5             	mov    %rsp,%rbp
  8021fd:	48 83 ec 40          	sub    $0x40,%rsp
  802201:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802204:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802207:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80220b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80220e:	48 89 d6             	mov    %rdx,%rsi
  802211:	89 c7                	mov    %eax,%edi
  802213:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  80221a:	00 00 00 
  80221d:	ff d0                	callq  *%rax
  80221f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802222:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802226:	79 08                	jns    802230 <dup+0x37>
		return r;
  802228:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222b:	e9 70 01 00 00       	jmpq   8023a0 <dup+0x1a7>
	close(newfdnum);
  802230:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802233:	89 c7                	mov    %eax,%edi
  802235:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  80223c:	00 00 00 
  80223f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802241:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802244:	48 98                	cltq   
  802246:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80224c:	48 c1 e0 0c          	shl    $0xc,%rax
  802250:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802254:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802258:	48 89 c7             	mov    %rax,%rdi
  80225b:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802262:	00 00 00 
  802265:	ff d0                	callq  *%rax
  802267:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80226b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226f:	48 89 c7             	mov    %rax,%rdi
  802272:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
  80227e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802286:	48 c1 e8 15          	shr    $0x15,%rax
  80228a:	48 89 c2             	mov    %rax,%rdx
  80228d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802294:	01 00 00 
  802297:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229b:	83 e0 01             	and    $0x1,%eax
  80229e:	48 85 c0             	test   %rax,%rax
  8022a1:	74 73                	je     802316 <dup+0x11d>
  8022a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a7:	48 c1 e8 0c          	shr    $0xc,%rax
  8022ab:	48 89 c2             	mov    %rax,%rdx
  8022ae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022b5:	01 00 00 
  8022b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022bc:	83 e0 01             	and    $0x1,%eax
  8022bf:	48 85 c0             	test   %rax,%rax
  8022c2:	74 52                	je     802316 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c8:	48 c1 e8 0c          	shr    $0xc,%rax
  8022cc:	48 89 c2             	mov    %rax,%rdx
  8022cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022d6:	01 00 00 
  8022d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022dd:	25 07 0e 00 00       	and    $0xe07,%eax
  8022e2:	89 c1                	mov    %eax,%ecx
  8022e4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ec:	41 89 c8             	mov    %ecx,%r8d
  8022ef:	48 89 d1             	mov    %rdx,%rcx
  8022f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8022f7:	48 89 c6             	mov    %rax,%rsi
  8022fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ff:	48 b8 8a 1b 80 00 00 	movabs $0x801b8a,%rax
  802306:	00 00 00 
  802309:	ff d0                	callq  *%rax
  80230b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80230e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802312:	79 02                	jns    802316 <dup+0x11d>
			goto err;
  802314:	eb 57                	jmp    80236d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802316:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80231a:	48 c1 e8 0c          	shr    $0xc,%rax
  80231e:	48 89 c2             	mov    %rax,%rdx
  802321:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802328:	01 00 00 
  80232b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80232f:	25 07 0e 00 00       	and    $0xe07,%eax
  802334:	89 c1                	mov    %eax,%ecx
  802336:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80233a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80233e:	41 89 c8             	mov    %ecx,%r8d
  802341:	48 89 d1             	mov    %rdx,%rcx
  802344:	ba 00 00 00 00       	mov    $0x0,%edx
  802349:	48 89 c6             	mov    %rax,%rsi
  80234c:	bf 00 00 00 00       	mov    $0x0,%edi
  802351:	48 b8 8a 1b 80 00 00 	movabs $0x801b8a,%rax
  802358:	00 00 00 
  80235b:	ff d0                	callq  *%rax
  80235d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802360:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802364:	79 02                	jns    802368 <dup+0x16f>
		goto err;
  802366:	eb 05                	jmp    80236d <dup+0x174>

	return newfdnum;
  802368:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80236b:	eb 33                	jmp    8023a0 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80236d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802371:	48 89 c6             	mov    %rax,%rsi
  802374:	bf 00 00 00 00       	mov    $0x0,%edi
  802379:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  802380:	00 00 00 
  802383:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802385:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802389:	48 89 c6             	mov    %rax,%rsi
  80238c:	bf 00 00 00 00       	mov    $0x0,%edi
  802391:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  802398:	00 00 00 
  80239b:	ff d0                	callq  *%rax
	return r;
  80239d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023a0:	c9                   	leaveq 
  8023a1:	c3                   	retq   

00000000008023a2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023a2:	55                   	push   %rbp
  8023a3:	48 89 e5             	mov    %rsp,%rbp
  8023a6:	48 83 ec 40          	sub    $0x40,%rsp
  8023aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023b1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023b5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023bc:	48 89 d6             	mov    %rdx,%rsi
  8023bf:	89 c7                	mov    %eax,%edi
  8023c1:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  8023c8:	00 00 00 
  8023cb:	ff d0                	callq  *%rax
  8023cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d4:	78 24                	js     8023fa <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023da:	8b 00                	mov    (%rax),%eax
  8023dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e0:	48 89 d6             	mov    %rdx,%rsi
  8023e3:	89 c7                	mov    %eax,%edi
  8023e5:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  8023ec:	00 00 00 
  8023ef:	ff d0                	callq  *%rax
  8023f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f8:	79 05                	jns    8023ff <read+0x5d>
		return r;
  8023fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fd:	eb 76                	jmp    802475 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802403:	8b 40 08             	mov    0x8(%rax),%eax
  802406:	83 e0 03             	and    $0x3,%eax
  802409:	83 f8 01             	cmp    $0x1,%eax
  80240c:	75 3a                	jne    802448 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80240e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802415:	00 00 00 
  802418:	48 8b 00             	mov    (%rax),%rax
  80241b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802421:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802424:	89 c6                	mov    %eax,%esi
  802426:	48 bf d7 42 80 00 00 	movabs $0x8042d7,%rdi
  80242d:	00 00 00 
  802430:	b8 00 00 00 00       	mov    $0x0,%eax
  802435:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  80243c:	00 00 00 
  80243f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802441:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802446:	eb 2d                	jmp    802475 <read+0xd3>
	}
	if (!dev->dev_read)
  802448:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802450:	48 85 c0             	test   %rax,%rax
  802453:	75 07                	jne    80245c <read+0xba>
		return -E_NOT_SUPP;
  802455:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80245a:	eb 19                	jmp    802475 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80245c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802460:	48 8b 40 10          	mov    0x10(%rax),%rax
  802464:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802468:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80246c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802470:	48 89 cf             	mov    %rcx,%rdi
  802473:	ff d0                	callq  *%rax
}
  802475:	c9                   	leaveq 
  802476:	c3                   	retq   

0000000000802477 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802477:	55                   	push   %rbp
  802478:	48 89 e5             	mov    %rsp,%rbp
  80247b:	48 83 ec 30          	sub    $0x30,%rsp
  80247f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802482:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802486:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80248a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802491:	eb 49                	jmp    8024dc <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802493:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802496:	48 98                	cltq   
  802498:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80249c:	48 29 c2             	sub    %rax,%rdx
  80249f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a2:	48 63 c8             	movslq %eax,%rcx
  8024a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024a9:	48 01 c1             	add    %rax,%rcx
  8024ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024af:	48 89 ce             	mov    %rcx,%rsi
  8024b2:	89 c7                	mov    %eax,%edi
  8024b4:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  8024bb:	00 00 00 
  8024be:	ff d0                	callq  *%rax
  8024c0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024c3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024c7:	79 05                	jns    8024ce <readn+0x57>
			return m;
  8024c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024cc:	eb 1c                	jmp    8024ea <readn+0x73>
		if (m == 0)
  8024ce:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024d2:	75 02                	jne    8024d6 <readn+0x5f>
			break;
  8024d4:	eb 11                	jmp    8024e7 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024d9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024df:	48 98                	cltq   
  8024e1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024e5:	72 ac                	jb     802493 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024ea:	c9                   	leaveq 
  8024eb:	c3                   	retq   

00000000008024ec <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024ec:	55                   	push   %rbp
  8024ed:	48 89 e5             	mov    %rsp,%rbp
  8024f0:	48 83 ec 40          	sub    $0x40,%rsp
  8024f4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024fb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024ff:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802503:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802506:	48 89 d6             	mov    %rdx,%rsi
  802509:	89 c7                	mov    %eax,%edi
  80250b:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  802512:	00 00 00 
  802515:	ff d0                	callq  *%rax
  802517:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80251e:	78 24                	js     802544 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802524:	8b 00                	mov    (%rax),%eax
  802526:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80252a:	48 89 d6             	mov    %rdx,%rsi
  80252d:	89 c7                	mov    %eax,%edi
  80252f:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  802536:	00 00 00 
  802539:	ff d0                	callq  *%rax
  80253b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802542:	79 05                	jns    802549 <write+0x5d>
		return r;
  802544:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802547:	eb 42                	jmp    80258b <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254d:	8b 40 08             	mov    0x8(%rax),%eax
  802550:	83 e0 03             	and    $0x3,%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	75 07                	jne    80255e <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802557:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80255c:	eb 2d                	jmp    80258b <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80255e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802562:	48 8b 40 18          	mov    0x18(%rax),%rax
  802566:	48 85 c0             	test   %rax,%rax
  802569:	75 07                	jne    802572 <write+0x86>
		return -E_NOT_SUPP;
  80256b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802570:	eb 19                	jmp    80258b <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802572:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802576:	48 8b 40 18          	mov    0x18(%rax),%rax
  80257a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80257e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802582:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802586:	48 89 cf             	mov    %rcx,%rdi
  802589:	ff d0                	callq  *%rax
}
  80258b:	c9                   	leaveq 
  80258c:	c3                   	retq   

000000000080258d <seek>:

int
seek(int fdnum, off_t offset)
{
  80258d:	55                   	push   %rbp
  80258e:	48 89 e5             	mov    %rsp,%rbp
  802591:	48 83 ec 18          	sub    $0x18,%rsp
  802595:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802598:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80259b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80259f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025a2:	48 89 d6             	mov    %rdx,%rsi
  8025a5:	89 c7                	mov    %eax,%edi
  8025a7:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  8025ae:	00 00 00 
  8025b1:	ff d0                	callq  *%rax
  8025b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ba:	79 05                	jns    8025c1 <seek+0x34>
		return r;
  8025bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bf:	eb 0f                	jmp    8025d0 <seek+0x43>
	fd->fd_offset = offset;
  8025c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025c8:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d0:	c9                   	leaveq 
  8025d1:	c3                   	retq   

00000000008025d2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025d2:	55                   	push   %rbp
  8025d3:	48 89 e5             	mov    %rsp,%rbp
  8025d6:	48 83 ec 30          	sub    $0x30,%rsp
  8025da:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025dd:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025e0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025e4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025e7:	48 89 d6             	mov    %rdx,%rsi
  8025ea:	89 c7                	mov    %eax,%edi
  8025ec:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  8025f3:	00 00 00 
  8025f6:	ff d0                	callq  *%rax
  8025f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ff:	78 24                	js     802625 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802605:	8b 00                	mov    (%rax),%eax
  802607:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80260b:	48 89 d6             	mov    %rdx,%rsi
  80260e:	89 c7                	mov    %eax,%edi
  802610:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  802617:	00 00 00 
  80261a:	ff d0                	callq  *%rax
  80261c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802623:	79 05                	jns    80262a <ftruncate+0x58>
		return r;
  802625:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802628:	eb 72                	jmp    80269c <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80262a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262e:	8b 40 08             	mov    0x8(%rax),%eax
  802631:	83 e0 03             	and    $0x3,%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	75 3a                	jne    802672 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802638:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80263f:	00 00 00 
  802642:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802645:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80264b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80264e:	89 c6                	mov    %eax,%esi
  802650:	48 bf f8 42 80 00 00 	movabs $0x8042f8,%rdi
  802657:	00 00 00 
  80265a:	b8 00 00 00 00       	mov    $0x0,%eax
  80265f:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  802666:	00 00 00 
  802669:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80266b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802670:	eb 2a                	jmp    80269c <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802676:	48 8b 40 30          	mov    0x30(%rax),%rax
  80267a:	48 85 c0             	test   %rax,%rax
  80267d:	75 07                	jne    802686 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80267f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802684:	eb 16                	jmp    80269c <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80268e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802692:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802695:	89 ce                	mov    %ecx,%esi
  802697:	48 89 d7             	mov    %rdx,%rdi
  80269a:	ff d0                	callq  *%rax
}
  80269c:	c9                   	leaveq 
  80269d:	c3                   	retq   

000000000080269e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80269e:	55                   	push   %rbp
  80269f:	48 89 e5             	mov    %rsp,%rbp
  8026a2:	48 83 ec 30          	sub    $0x30,%rsp
  8026a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026ad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026b1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026b4:	48 89 d6             	mov    %rdx,%rsi
  8026b7:	89 c7                	mov    %eax,%edi
  8026b9:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  8026c0:	00 00 00 
  8026c3:	ff d0                	callq  *%rax
  8026c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026cc:	78 24                	js     8026f2 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d2:	8b 00                	mov    (%rax),%eax
  8026d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026d8:	48 89 d6             	mov    %rdx,%rsi
  8026db:	89 c7                	mov    %eax,%edi
  8026dd:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
  8026e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f0:	79 05                	jns    8026f7 <fstat+0x59>
		return r;
  8026f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f5:	eb 5e                	jmp    802755 <fstat+0xb7>
	if (!dev->dev_stat)
  8026f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026fb:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026ff:	48 85 c0             	test   %rax,%rax
  802702:	75 07                	jne    80270b <fstat+0x6d>
		return -E_NOT_SUPP;
  802704:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802709:	eb 4a                	jmp    802755 <fstat+0xb7>
	stat->st_name[0] = 0;
  80270b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80270f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802712:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802716:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80271d:	00 00 00 
	stat->st_isdir = 0;
  802720:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802724:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80272b:	00 00 00 
	stat->st_dev = dev;
  80272e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802732:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802736:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80273d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802741:	48 8b 40 28          	mov    0x28(%rax),%rax
  802745:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802749:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80274d:	48 89 ce             	mov    %rcx,%rsi
  802750:	48 89 d7             	mov    %rdx,%rdi
  802753:	ff d0                	callq  *%rax
}
  802755:	c9                   	leaveq 
  802756:	c3                   	retq   

0000000000802757 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802757:	55                   	push   %rbp
  802758:	48 89 e5             	mov    %rsp,%rbp
  80275b:	48 83 ec 20          	sub    $0x20,%rsp
  80275f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802763:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276b:	be 00 00 00 00       	mov    $0x0,%esi
  802770:	48 89 c7             	mov    %rax,%rdi
  802773:	48 b8 45 28 80 00 00 	movabs $0x802845,%rax
  80277a:	00 00 00 
  80277d:	ff d0                	callq  *%rax
  80277f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802782:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802786:	79 05                	jns    80278d <stat+0x36>
		return fd;
  802788:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278b:	eb 2f                	jmp    8027bc <stat+0x65>
	r = fstat(fd, stat);
  80278d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802794:	48 89 d6             	mov    %rdx,%rsi
  802797:	89 c7                	mov    %eax,%edi
  802799:	48 b8 9e 26 80 00 00 	movabs $0x80269e,%rax
  8027a0:	00 00 00 
  8027a3:	ff d0                	callq  *%rax
  8027a5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ab:	89 c7                	mov    %eax,%edi
  8027ad:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  8027b4:	00 00 00 
  8027b7:	ff d0                	callq  *%rax
	return r;
  8027b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027bc:	c9                   	leaveq 
  8027bd:	c3                   	retq   

00000000008027be <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027be:	55                   	push   %rbp
  8027bf:	48 89 e5             	mov    %rsp,%rbp
  8027c2:	48 83 ec 10          	sub    $0x10,%rsp
  8027c6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027cd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027d4:	00 00 00 
  8027d7:	8b 00                	mov    (%rax),%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	75 1d                	jne    8027fa <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027dd:	bf 01 00 00 00       	mov    $0x1,%edi
  8027e2:	48 b8 a2 3b 80 00 00 	movabs $0x803ba2,%rax
  8027e9:	00 00 00 
  8027ec:	ff d0                	callq  *%rax
  8027ee:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8027f5:	00 00 00 
  8027f8:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8027fa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802801:	00 00 00 
  802804:	8b 00                	mov    (%rax),%eax
  802806:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802809:	b9 07 00 00 00       	mov    $0x7,%ecx
  80280e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802815:	00 00 00 
  802818:	89 c7                	mov    %eax,%edi
  80281a:	48 b8 d5 37 80 00 00 	movabs $0x8037d5,%rax
  802821:	00 00 00 
  802824:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802826:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282a:	ba 00 00 00 00       	mov    $0x0,%edx
  80282f:	48 89 c6             	mov    %rax,%rsi
  802832:	bf 00 00 00 00       	mov    $0x0,%edi
  802837:	48 b8 d7 36 80 00 00 	movabs $0x8036d7,%rax
  80283e:	00 00 00 
  802841:	ff d0                	callq  *%rax
}
  802843:	c9                   	leaveq 
  802844:	c3                   	retq   

0000000000802845 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802845:	55                   	push   %rbp
  802846:	48 89 e5             	mov    %rsp,%rbp
  802849:	48 83 ec 30          	sub    $0x30,%rsp
  80284d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802851:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802854:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80285b:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802862:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802869:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80286e:	75 08                	jne    802878 <open+0x33>
	{
		return r;
  802870:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802873:	e9 f2 00 00 00       	jmpq   80296a <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802878:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80287c:	48 89 c7             	mov    %rax,%rdi
  80287f:	48 b8 9f 11 80 00 00 	movabs $0x80119f,%rax
  802886:	00 00 00 
  802889:	ff d0                	callq  *%rax
  80288b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80288e:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802895:	7e 0a                	jle    8028a1 <open+0x5c>
	{
		return -E_BAD_PATH;
  802897:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80289c:	e9 c9 00 00 00       	jmpq   80296a <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8028a1:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8028a8:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8028a9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8028ad:	48 89 c7             	mov    %rax,%rdi
  8028b0:	48 b8 d8 1e 80 00 00 	movabs $0x801ed8,%rax
  8028b7:	00 00 00 
  8028ba:	ff d0                	callq  *%rax
  8028bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c3:	78 09                	js     8028ce <open+0x89>
  8028c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c9:	48 85 c0             	test   %rax,%rax
  8028cc:	75 08                	jne    8028d6 <open+0x91>
		{
			return r;
  8028ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d1:	e9 94 00 00 00       	jmpq   80296a <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8028d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028da:	ba 00 04 00 00       	mov    $0x400,%edx
  8028df:	48 89 c6             	mov    %rax,%rsi
  8028e2:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8028e9:	00 00 00 
  8028ec:	48 b8 9d 12 80 00 00 	movabs $0x80129d,%rax
  8028f3:	00 00 00 
  8028f6:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8028f8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028ff:	00 00 00 
  802902:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802905:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80290b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80290f:	48 89 c6             	mov    %rax,%rsi
  802912:	bf 01 00 00 00       	mov    $0x1,%edi
  802917:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  80291e:	00 00 00 
  802921:	ff d0                	callq  *%rax
  802923:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802926:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80292a:	79 2b                	jns    802957 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80292c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802930:	be 00 00 00 00       	mov    $0x0,%esi
  802935:	48 89 c7             	mov    %rax,%rdi
  802938:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  80293f:	00 00 00 
  802942:	ff d0                	callq  *%rax
  802944:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802947:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80294b:	79 05                	jns    802952 <open+0x10d>
			{
				return d;
  80294d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802950:	eb 18                	jmp    80296a <open+0x125>
			}
			return r;
  802952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802955:	eb 13                	jmp    80296a <open+0x125>
		}	
		return fd2num(fd_store);
  802957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295b:	48 89 c7             	mov    %rax,%rdi
  80295e:	48 b8 8a 1e 80 00 00 	movabs $0x801e8a,%rax
  802965:	00 00 00 
  802968:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80296a:	c9                   	leaveq 
  80296b:	c3                   	retq   

000000000080296c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80296c:	55                   	push   %rbp
  80296d:	48 89 e5             	mov    %rsp,%rbp
  802970:	48 83 ec 10          	sub    $0x10,%rsp
  802974:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802978:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80297c:	8b 50 0c             	mov    0xc(%rax),%edx
  80297f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802986:	00 00 00 
  802989:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80298b:	be 00 00 00 00       	mov    $0x0,%esi
  802990:	bf 06 00 00 00       	mov    $0x6,%edi
  802995:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  80299c:	00 00 00 
  80299f:	ff d0                	callq  *%rax
}
  8029a1:	c9                   	leaveq 
  8029a2:	c3                   	retq   

00000000008029a3 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029a3:	55                   	push   %rbp
  8029a4:	48 89 e5             	mov    %rsp,%rbp
  8029a7:	48 83 ec 30          	sub    $0x30,%rsp
  8029ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8029b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8029be:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029c3:	74 07                	je     8029cc <devfile_read+0x29>
  8029c5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029ca:	75 07                	jne    8029d3 <devfile_read+0x30>
		return -E_INVAL;
  8029cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029d1:	eb 77                	jmp    802a4a <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d7:	8b 50 0c             	mov    0xc(%rax),%edx
  8029da:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029e1:	00 00 00 
  8029e4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029e6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ed:	00 00 00 
  8029f0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029f4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8029f8:	be 00 00 00 00       	mov    $0x0,%esi
  8029fd:	bf 03 00 00 00       	mov    $0x3,%edi
  802a02:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802a09:	00 00 00 
  802a0c:	ff d0                	callq  *%rax
  802a0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a15:	7f 05                	jg     802a1c <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802a17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1a:	eb 2e                	jmp    802a4a <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1f:	48 63 d0             	movslq %eax,%rdx
  802a22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a26:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a2d:	00 00 00 
  802a30:	48 89 c7             	mov    %rax,%rdi
  802a33:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  802a3a:	00 00 00 
  802a3d:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802a3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a43:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802a47:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a4a:	c9                   	leaveq 
  802a4b:	c3                   	retq   

0000000000802a4c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a4c:	55                   	push   %rbp
  802a4d:	48 89 e5             	mov    %rsp,%rbp
  802a50:	48 83 ec 30          	sub    $0x30,%rsp
  802a54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a5c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802a60:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802a67:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a6c:	74 07                	je     802a75 <devfile_write+0x29>
  802a6e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a73:	75 08                	jne    802a7d <devfile_write+0x31>
		return r;
  802a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a78:	e9 9a 00 00 00       	jmpq   802b17 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a81:	8b 50 0c             	mov    0xc(%rax),%edx
  802a84:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a8b:	00 00 00 
  802a8e:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802a90:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a97:	00 
  802a98:	76 08                	jbe    802aa2 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802a9a:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802aa1:	00 
	}
	fsipcbuf.write.req_n = n;
  802aa2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aa9:	00 00 00 
  802aac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ab0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802ab4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ab8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802abc:	48 89 c6             	mov    %rax,%rsi
  802abf:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ac6:	00 00 00 
  802ac9:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  802ad0:	00 00 00 
  802ad3:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802ad5:	be 00 00 00 00       	mov    $0x0,%esi
  802ada:	bf 04 00 00 00       	mov    $0x4,%edi
  802adf:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802ae6:	00 00 00 
  802ae9:	ff d0                	callq  *%rax
  802aeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af2:	7f 20                	jg     802b14 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802af4:	48 bf 1e 43 80 00 00 	movabs $0x80431e,%rdi
  802afb:	00 00 00 
  802afe:	b8 00 00 00 00       	mov    $0x0,%eax
  802b03:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802b0a:	00 00 00 
  802b0d:	ff d2                	callq  *%rdx
		return r;
  802b0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b12:	eb 03                	jmp    802b17 <devfile_write+0xcb>
	}
	return r;
  802b14:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802b17:	c9                   	leaveq 
  802b18:	c3                   	retq   

0000000000802b19 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b19:	55                   	push   %rbp
  802b1a:	48 89 e5             	mov    %rsp,%rbp
  802b1d:	48 83 ec 20          	sub    $0x20,%rsp
  802b21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2d:	8b 50 0c             	mov    0xc(%rax),%edx
  802b30:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b37:	00 00 00 
  802b3a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b3c:	be 00 00 00 00       	mov    $0x0,%esi
  802b41:	bf 05 00 00 00       	mov    $0x5,%edi
  802b46:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802b4d:	00 00 00 
  802b50:	ff d0                	callq  *%rax
  802b52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b59:	79 05                	jns    802b60 <devfile_stat+0x47>
		return r;
  802b5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5e:	eb 56                	jmp    802bb6 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b64:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b6b:	00 00 00 
  802b6e:	48 89 c7             	mov    %rax,%rdi
  802b71:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  802b78:	00 00 00 
  802b7b:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b7d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b84:	00 00 00 
  802b87:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b91:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b97:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b9e:	00 00 00 
  802ba1:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ba7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bab:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb6:	c9                   	leaveq 
  802bb7:	c3                   	retq   

0000000000802bb8 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bb8:	55                   	push   %rbp
  802bb9:	48 89 e5             	mov    %rsp,%rbp
  802bbc:	48 83 ec 10          	sub    $0x10,%rsp
  802bc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bc4:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802bc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bcb:	8b 50 0c             	mov    0xc(%rax),%edx
  802bce:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bd5:	00 00 00 
  802bd8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802bda:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802be1:	00 00 00 
  802be4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802be7:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802bea:	be 00 00 00 00       	mov    $0x0,%esi
  802bef:	bf 02 00 00 00       	mov    $0x2,%edi
  802bf4:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802bfb:	00 00 00 
  802bfe:	ff d0                	callq  *%rax
}
  802c00:	c9                   	leaveq 
  802c01:	c3                   	retq   

0000000000802c02 <remove>:

// Delete a file
int
remove(const char *path)
{
  802c02:	55                   	push   %rbp
  802c03:	48 89 e5             	mov    %rsp,%rbp
  802c06:	48 83 ec 10          	sub    $0x10,%rsp
  802c0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c12:	48 89 c7             	mov    %rax,%rdi
  802c15:	48 b8 9f 11 80 00 00 	movabs $0x80119f,%rax
  802c1c:	00 00 00 
  802c1f:	ff d0                	callq  *%rax
  802c21:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c26:	7e 07                	jle    802c2f <remove+0x2d>
		return -E_BAD_PATH;
  802c28:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c2d:	eb 33                	jmp    802c62 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c33:	48 89 c6             	mov    %rax,%rsi
  802c36:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c3d:	00 00 00 
  802c40:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  802c47:	00 00 00 
  802c4a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c4c:	be 00 00 00 00       	mov    $0x0,%esi
  802c51:	bf 07 00 00 00       	mov    $0x7,%edi
  802c56:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802c5d:	00 00 00 
  802c60:	ff d0                	callq  *%rax
}
  802c62:	c9                   	leaveq 
  802c63:	c3                   	retq   

0000000000802c64 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c64:	55                   	push   %rbp
  802c65:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c68:	be 00 00 00 00       	mov    $0x0,%esi
  802c6d:	bf 08 00 00 00       	mov    $0x8,%edi
  802c72:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802c79:	00 00 00 
  802c7c:	ff d0                	callq  *%rax
}
  802c7e:	5d                   	pop    %rbp
  802c7f:	c3                   	retq   

0000000000802c80 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c80:	55                   	push   %rbp
  802c81:	48 89 e5             	mov    %rsp,%rbp
  802c84:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c8b:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c92:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c99:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802ca0:	be 00 00 00 00       	mov    $0x0,%esi
  802ca5:	48 89 c7             	mov    %rax,%rdi
  802ca8:	48 b8 45 28 80 00 00 	movabs $0x802845,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	callq  *%rax
  802cb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802cb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cbb:	79 28                	jns    802ce5 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802cbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc0:	89 c6                	mov    %eax,%esi
  802cc2:	48 bf 3a 43 80 00 00 	movabs $0x80433a,%rdi
  802cc9:	00 00 00 
  802ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd1:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802cd8:	00 00 00 
  802cdb:	ff d2                	callq  *%rdx
		return fd_src;
  802cdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce0:	e9 74 01 00 00       	jmpq   802e59 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ce5:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802cec:	be 01 01 00 00       	mov    $0x101,%esi
  802cf1:	48 89 c7             	mov    %rax,%rdi
  802cf4:	48 b8 45 28 80 00 00 	movabs $0x802845,%rax
  802cfb:	00 00 00 
  802cfe:	ff d0                	callq  *%rax
  802d00:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d03:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d07:	79 39                	jns    802d42 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d0c:	89 c6                	mov    %eax,%esi
  802d0e:	48 bf 50 43 80 00 00 	movabs $0x804350,%rdi
  802d15:	00 00 00 
  802d18:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1d:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802d24:	00 00 00 
  802d27:	ff d2                	callq  *%rdx
		close(fd_src);
  802d29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2c:	89 c7                	mov    %eax,%edi
  802d2e:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  802d35:	00 00 00 
  802d38:	ff d0                	callq  *%rax
		return fd_dest;
  802d3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d3d:	e9 17 01 00 00       	jmpq   802e59 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d42:	eb 74                	jmp    802db8 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d44:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d47:	48 63 d0             	movslq %eax,%rdx
  802d4a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d51:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d54:	48 89 ce             	mov    %rcx,%rsi
  802d57:	89 c7                	mov    %eax,%edi
  802d59:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  802d60:	00 00 00 
  802d63:	ff d0                	callq  *%rax
  802d65:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d68:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d6c:	79 4a                	jns    802db8 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d6e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d71:	89 c6                	mov    %eax,%esi
  802d73:	48 bf 6a 43 80 00 00 	movabs $0x80436a,%rdi
  802d7a:	00 00 00 
  802d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d82:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802d89:	00 00 00 
  802d8c:	ff d2                	callq  *%rdx
			close(fd_src);
  802d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d91:	89 c7                	mov    %eax,%edi
  802d93:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  802d9a:	00 00 00 
  802d9d:	ff d0                	callq  *%rax
			close(fd_dest);
  802d9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802da2:	89 c7                	mov    %eax,%edi
  802da4:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  802dab:	00 00 00 
  802dae:	ff d0                	callq  *%rax
			return write_size;
  802db0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802db3:	e9 a1 00 00 00       	jmpq   802e59 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802db8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802dbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc2:	ba 00 02 00 00       	mov    $0x200,%edx
  802dc7:	48 89 ce             	mov    %rcx,%rsi
  802dca:	89 c7                	mov    %eax,%edi
  802dcc:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  802dd3:	00 00 00 
  802dd6:	ff d0                	callq  *%rax
  802dd8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ddf:	0f 8f 5f ff ff ff    	jg     802d44 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802de5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802de9:	79 47                	jns    802e32 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802deb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dee:	89 c6                	mov    %eax,%esi
  802df0:	48 bf 7d 43 80 00 00 	movabs $0x80437d,%rdi
  802df7:	00 00 00 
  802dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  802dff:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802e06:	00 00 00 
  802e09:	ff d2                	callq  *%rdx
		close(fd_src);
  802e0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0e:	89 c7                	mov    %eax,%edi
  802e10:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  802e17:	00 00 00 
  802e1a:	ff d0                	callq  *%rax
		close(fd_dest);
  802e1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e1f:	89 c7                	mov    %eax,%edi
  802e21:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  802e28:	00 00 00 
  802e2b:	ff d0                	callq  *%rax
		return read_size;
  802e2d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e30:	eb 27                	jmp    802e59 <copy+0x1d9>
	}
	close(fd_src);
  802e32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e35:	89 c7                	mov    %eax,%edi
  802e37:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  802e3e:	00 00 00 
  802e41:	ff d0                	callq  *%rax
	close(fd_dest);
  802e43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e46:	89 c7                	mov    %eax,%edi
  802e48:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  802e4f:	00 00 00 
  802e52:	ff d0                	callq  *%rax
	return 0;
  802e54:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e59:	c9                   	leaveq 
  802e5a:	c3                   	retq   

0000000000802e5b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802e5b:	55                   	push   %rbp
  802e5c:	48 89 e5             	mov    %rsp,%rbp
  802e5f:	53                   	push   %rbx
  802e60:	48 83 ec 38          	sub    $0x38,%rsp
  802e64:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802e68:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802e6c:	48 89 c7             	mov    %rax,%rdi
  802e6f:	48 b8 d8 1e 80 00 00 	movabs $0x801ed8,%rax
  802e76:	00 00 00 
  802e79:	ff d0                	callq  *%rax
  802e7b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e82:	0f 88 bf 01 00 00    	js     803047 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e8c:	ba 07 04 00 00       	mov    $0x407,%edx
  802e91:	48 89 c6             	mov    %rax,%rsi
  802e94:	bf 00 00 00 00       	mov    $0x0,%edi
  802e99:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  802ea0:	00 00 00 
  802ea3:	ff d0                	callq  *%rax
  802ea5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ea8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802eac:	0f 88 95 01 00 00    	js     803047 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802eb2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802eb6:	48 89 c7             	mov    %rax,%rdi
  802eb9:	48 b8 d8 1e 80 00 00 	movabs $0x801ed8,%rax
  802ec0:	00 00 00 
  802ec3:	ff d0                	callq  *%rax
  802ec5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ec8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ecc:	0f 88 5d 01 00 00    	js     80302f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ed2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ed6:	ba 07 04 00 00       	mov    $0x407,%edx
  802edb:	48 89 c6             	mov    %rax,%rsi
  802ede:	bf 00 00 00 00       	mov    $0x0,%edi
  802ee3:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  802eea:	00 00 00 
  802eed:	ff d0                	callq  *%rax
  802eef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ef2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ef6:	0f 88 33 01 00 00    	js     80302f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802efc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f00:	48 89 c7             	mov    %rax,%rdi
  802f03:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802f0a:	00 00 00 
  802f0d:	ff d0                	callq  *%rax
  802f0f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f17:	ba 07 04 00 00       	mov    $0x407,%edx
  802f1c:	48 89 c6             	mov    %rax,%rsi
  802f1f:	bf 00 00 00 00       	mov    $0x0,%edi
  802f24:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  802f2b:	00 00 00 
  802f2e:	ff d0                	callq  *%rax
  802f30:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f33:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f37:	79 05                	jns    802f3e <pipe+0xe3>
		goto err2;
  802f39:	e9 d9 00 00 00       	jmpq   803017 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f3e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f42:	48 89 c7             	mov    %rax,%rdi
  802f45:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802f4c:	00 00 00 
  802f4f:	ff d0                	callq  *%rax
  802f51:	48 89 c2             	mov    %rax,%rdx
  802f54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f58:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802f5e:	48 89 d1             	mov    %rdx,%rcx
  802f61:	ba 00 00 00 00       	mov    $0x0,%edx
  802f66:	48 89 c6             	mov    %rax,%rsi
  802f69:	bf 00 00 00 00       	mov    $0x0,%edi
  802f6e:	48 b8 8a 1b 80 00 00 	movabs $0x801b8a,%rax
  802f75:	00 00 00 
  802f78:	ff d0                	callq  *%rax
  802f7a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f81:	79 1b                	jns    802f9e <pipe+0x143>
		goto err3;
  802f83:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802f84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f88:	48 89 c6             	mov    %rax,%rsi
  802f8b:	bf 00 00 00 00       	mov    $0x0,%edi
  802f90:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  802f97:	00 00 00 
  802f9a:	ff d0                	callq  *%rax
  802f9c:	eb 79                	jmp    803017 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802f9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802fa9:	00 00 00 
  802fac:	8b 12                	mov    (%rdx),%edx
  802fae:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802fb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fb4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802fbb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fbf:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802fc6:	00 00 00 
  802fc9:	8b 12                	mov    (%rdx),%edx
  802fcb:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802fcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fd1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802fd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fdc:	48 89 c7             	mov    %rax,%rdi
  802fdf:	48 b8 8a 1e 80 00 00 	movabs $0x801e8a,%rax
  802fe6:	00 00 00 
  802fe9:	ff d0                	callq  *%rax
  802feb:	89 c2                	mov    %eax,%edx
  802fed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ff1:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802ff3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ff7:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802ffb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fff:	48 89 c7             	mov    %rax,%rdi
  803002:	48 b8 8a 1e 80 00 00 	movabs $0x801e8a,%rax
  803009:	00 00 00 
  80300c:	ff d0                	callq  *%rax
  80300e:	89 03                	mov    %eax,(%rbx)
	return 0;
  803010:	b8 00 00 00 00       	mov    $0x0,%eax
  803015:	eb 33                	jmp    80304a <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803017:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80301b:	48 89 c6             	mov    %rax,%rsi
  80301e:	bf 00 00 00 00       	mov    $0x0,%edi
  803023:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  80302a:	00 00 00 
  80302d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80302f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803033:	48 89 c6             	mov    %rax,%rsi
  803036:	bf 00 00 00 00       	mov    $0x0,%edi
  80303b:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
err:
	return r;
  803047:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80304a:	48 83 c4 38          	add    $0x38,%rsp
  80304e:	5b                   	pop    %rbx
  80304f:	5d                   	pop    %rbp
  803050:	c3                   	retq   

0000000000803051 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803051:	55                   	push   %rbp
  803052:	48 89 e5             	mov    %rsp,%rbp
  803055:	53                   	push   %rbx
  803056:	48 83 ec 28          	sub    $0x28,%rsp
  80305a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80305e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803062:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803069:	00 00 00 
  80306c:	48 8b 00             	mov    (%rax),%rax
  80306f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803075:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803078:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80307c:	48 89 c7             	mov    %rax,%rdi
  80307f:	48 b8 14 3c 80 00 00 	movabs $0x803c14,%rax
  803086:	00 00 00 
  803089:	ff d0                	callq  *%rax
  80308b:	89 c3                	mov    %eax,%ebx
  80308d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803091:	48 89 c7             	mov    %rax,%rdi
  803094:	48 b8 14 3c 80 00 00 	movabs $0x803c14,%rax
  80309b:	00 00 00 
  80309e:	ff d0                	callq  *%rax
  8030a0:	39 c3                	cmp    %eax,%ebx
  8030a2:	0f 94 c0             	sete   %al
  8030a5:	0f b6 c0             	movzbl %al,%eax
  8030a8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8030ab:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8030b2:	00 00 00 
  8030b5:	48 8b 00             	mov    (%rax),%rax
  8030b8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8030be:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8030c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030c4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8030c7:	75 05                	jne    8030ce <_pipeisclosed+0x7d>
			return ret;
  8030c9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8030cc:	eb 4f                	jmp    80311d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8030ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030d1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8030d4:	74 42                	je     803118 <_pipeisclosed+0xc7>
  8030d6:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8030da:	75 3c                	jne    803118 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8030dc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8030e3:	00 00 00 
  8030e6:	48 8b 00             	mov    (%rax),%rax
  8030e9:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8030ef:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8030f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030f5:	89 c6                	mov    %eax,%esi
  8030f7:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  8030fe:	00 00 00 
  803101:	b8 00 00 00 00       	mov    $0x0,%eax
  803106:	49 b8 56 06 80 00 00 	movabs $0x800656,%r8
  80310d:	00 00 00 
  803110:	41 ff d0             	callq  *%r8
	}
  803113:	e9 4a ff ff ff       	jmpq   803062 <_pipeisclosed+0x11>
  803118:	e9 45 ff ff ff       	jmpq   803062 <_pipeisclosed+0x11>
}
  80311d:	48 83 c4 28          	add    $0x28,%rsp
  803121:	5b                   	pop    %rbx
  803122:	5d                   	pop    %rbp
  803123:	c3                   	retq   

0000000000803124 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803124:	55                   	push   %rbp
  803125:	48 89 e5             	mov    %rsp,%rbp
  803128:	48 83 ec 30          	sub    $0x30,%rsp
  80312c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80312f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803133:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803136:	48 89 d6             	mov    %rdx,%rsi
  803139:	89 c7                	mov    %eax,%edi
  80313b:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
  803147:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314e:	79 05                	jns    803155 <pipeisclosed+0x31>
		return r;
  803150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803153:	eb 31                	jmp    803186 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803159:	48 89 c7             	mov    %rax,%rdi
  80315c:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  803163:	00 00 00 
  803166:	ff d0                	callq  *%rax
  803168:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80316c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803170:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803174:	48 89 d6             	mov    %rdx,%rsi
  803177:	48 89 c7             	mov    %rax,%rdi
  80317a:	48 b8 51 30 80 00 00 	movabs $0x803051,%rax
  803181:	00 00 00 
  803184:	ff d0                	callq  *%rax
}
  803186:	c9                   	leaveq 
  803187:	c3                   	retq   

0000000000803188 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803188:	55                   	push   %rbp
  803189:	48 89 e5             	mov    %rsp,%rbp
  80318c:	48 83 ec 40          	sub    $0x40,%rsp
  803190:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803194:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803198:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80319c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a0:	48 89 c7             	mov    %rax,%rdi
  8031a3:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  8031aa:	00 00 00 
  8031ad:	ff d0                	callq  *%rax
  8031af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8031b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8031bb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8031c2:	00 
  8031c3:	e9 92 00 00 00       	jmpq   80325a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8031c8:	eb 41                	jmp    80320b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8031ca:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8031cf:	74 09                	je     8031da <devpipe_read+0x52>
				return i;
  8031d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031d5:	e9 92 00 00 00       	jmpq   80326c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8031da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e2:	48 89 d6             	mov    %rdx,%rsi
  8031e5:	48 89 c7             	mov    %rax,%rdi
  8031e8:	48 b8 51 30 80 00 00 	movabs $0x803051,%rax
  8031ef:	00 00 00 
  8031f2:	ff d0                	callq  *%rax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 07                	je     8031ff <devpipe_read+0x77>
				return 0;
  8031f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fd:	eb 6d                	jmp    80326c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8031ff:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  803206:	00 00 00 
  803209:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80320b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80320f:	8b 10                	mov    (%rax),%edx
  803211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803215:	8b 40 04             	mov    0x4(%rax),%eax
  803218:	39 c2                	cmp    %eax,%edx
  80321a:	74 ae                	je     8031ca <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80321c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803220:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803224:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80322c:	8b 00                	mov    (%rax),%eax
  80322e:	99                   	cltd   
  80322f:	c1 ea 1b             	shr    $0x1b,%edx
  803232:	01 d0                	add    %edx,%eax
  803234:	83 e0 1f             	and    $0x1f,%eax
  803237:	29 d0                	sub    %edx,%eax
  803239:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80323d:	48 98                	cltq   
  80323f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803244:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80324a:	8b 00                	mov    (%rax),%eax
  80324c:	8d 50 01             	lea    0x1(%rax),%edx
  80324f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803253:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803255:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80325a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80325e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803262:	0f 82 60 ff ff ff    	jb     8031c8 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80326c:	c9                   	leaveq 
  80326d:	c3                   	retq   

000000000080326e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80326e:	55                   	push   %rbp
  80326f:	48 89 e5             	mov    %rsp,%rbp
  803272:	48 83 ec 40          	sub    $0x40,%rsp
  803276:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80327a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80327e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803282:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803286:	48 89 c7             	mov    %rax,%rdi
  803289:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  803290:	00 00 00 
  803293:	ff d0                	callq  *%rax
  803295:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803299:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80329d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8032a1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8032a8:	00 
  8032a9:	e9 8e 00 00 00       	jmpq   80333c <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8032ae:	eb 31                	jmp    8032e1 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8032b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b8:	48 89 d6             	mov    %rdx,%rsi
  8032bb:	48 89 c7             	mov    %rax,%rdi
  8032be:	48 b8 51 30 80 00 00 	movabs $0x803051,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
  8032ca:	85 c0                	test   %eax,%eax
  8032cc:	74 07                	je     8032d5 <devpipe_write+0x67>
				return 0;
  8032ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d3:	eb 79                	jmp    80334e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8032d5:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  8032dc:	00 00 00 
  8032df:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8032e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e5:	8b 40 04             	mov    0x4(%rax),%eax
  8032e8:	48 63 d0             	movslq %eax,%rdx
  8032eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ef:	8b 00                	mov    (%rax),%eax
  8032f1:	48 98                	cltq   
  8032f3:	48 83 c0 20          	add    $0x20,%rax
  8032f7:	48 39 c2             	cmp    %rax,%rdx
  8032fa:	73 b4                	jae    8032b0 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8032fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803300:	8b 40 04             	mov    0x4(%rax),%eax
  803303:	99                   	cltd   
  803304:	c1 ea 1b             	shr    $0x1b,%edx
  803307:	01 d0                	add    %edx,%eax
  803309:	83 e0 1f             	and    $0x1f,%eax
  80330c:	29 d0                	sub    %edx,%eax
  80330e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803312:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803316:	48 01 ca             	add    %rcx,%rdx
  803319:	0f b6 0a             	movzbl (%rdx),%ecx
  80331c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803320:	48 98                	cltq   
  803322:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332a:	8b 40 04             	mov    0x4(%rax),%eax
  80332d:	8d 50 01             	lea    0x1(%rax),%edx
  803330:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803334:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803337:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80333c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803340:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803344:	0f 82 64 ff ff ff    	jb     8032ae <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80334a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80334e:	c9                   	leaveq 
  80334f:	c3                   	retq   

0000000000803350 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803350:	55                   	push   %rbp
  803351:	48 89 e5             	mov    %rsp,%rbp
  803354:	48 83 ec 20          	sub    $0x20,%rsp
  803358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80335c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803364:	48 89 c7             	mov    %rax,%rdi
  803367:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
  803373:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803377:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337b:	48 be b0 43 80 00 00 	movabs $0x8043b0,%rsi
  803382:	00 00 00 
  803385:	48 89 c7             	mov    %rax,%rdi
  803388:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  80338f:	00 00 00 
  803392:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803398:	8b 50 04             	mov    0x4(%rax),%edx
  80339b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80339f:	8b 00                	mov    (%rax),%eax
  8033a1:	29 c2                	sub    %eax,%edx
  8033a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8033ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8033b8:	00 00 00 
	stat->st_dev = &devpipe;
  8033bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033bf:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8033c6:	00 00 00 
  8033c9:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8033d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d5:	c9                   	leaveq 
  8033d6:	c3                   	retq   

00000000008033d7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8033d7:	55                   	push   %rbp
  8033d8:	48 89 e5             	mov    %rsp,%rbp
  8033db:	48 83 ec 10          	sub    $0x10,%rsp
  8033df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8033e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e7:	48 89 c6             	mov    %rax,%rsi
  8033ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ef:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  8033f6:	00 00 00 
  8033f9:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8033fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ff:	48 89 c7             	mov    %rax,%rdi
  803402:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  803409:	00 00 00 
  80340c:	ff d0                	callq  *%rax
  80340e:	48 89 c6             	mov    %rax,%rsi
  803411:	bf 00 00 00 00       	mov    $0x0,%edi
  803416:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  80341d:	00 00 00 
  803420:	ff d0                	callq  *%rax
}
  803422:	c9                   	leaveq 
  803423:	c3                   	retq   

0000000000803424 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803424:	55                   	push   %rbp
  803425:	48 89 e5             	mov    %rsp,%rbp
  803428:	48 83 ec 20          	sub    $0x20,%rsp
  80342c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80342f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803432:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803435:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803439:	be 01 00 00 00       	mov    $0x1,%esi
  80343e:	48 89 c7             	mov    %rax,%rdi
  803441:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  803448:	00 00 00 
  80344b:	ff d0                	callq  *%rax
}
  80344d:	c9                   	leaveq 
  80344e:	c3                   	retq   

000000000080344f <getchar>:

int
getchar(void)
{
  80344f:	55                   	push   %rbp
  803450:	48 89 e5             	mov    %rsp,%rbp
  803453:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803457:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80345b:	ba 01 00 00 00       	mov    $0x1,%edx
  803460:	48 89 c6             	mov    %rax,%rsi
  803463:	bf 00 00 00 00       	mov    $0x0,%edi
  803468:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  80346f:	00 00 00 
  803472:	ff d0                	callq  *%rax
  803474:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803477:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80347b:	79 05                	jns    803482 <getchar+0x33>
		return r;
  80347d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803480:	eb 14                	jmp    803496 <getchar+0x47>
	if (r < 1)
  803482:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803486:	7f 07                	jg     80348f <getchar+0x40>
		return -E_EOF;
  803488:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80348d:	eb 07                	jmp    803496 <getchar+0x47>
	return c;
  80348f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803493:	0f b6 c0             	movzbl %al,%eax
}
  803496:	c9                   	leaveq 
  803497:	c3                   	retq   

0000000000803498 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803498:	55                   	push   %rbp
  803499:	48 89 e5             	mov    %rsp,%rbp
  80349c:	48 83 ec 20          	sub    $0x20,%rsp
  8034a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8034a3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034aa:	48 89 d6             	mov    %rdx,%rsi
  8034ad:	89 c7                	mov    %eax,%edi
  8034af:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  8034b6:	00 00 00 
  8034b9:	ff d0                	callq  *%rax
  8034bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c2:	79 05                	jns    8034c9 <iscons+0x31>
		return r;
  8034c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c7:	eb 1a                	jmp    8034e3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8034c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034cd:	8b 10                	mov    (%rax),%edx
  8034cf:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8034d6:	00 00 00 
  8034d9:	8b 00                	mov    (%rax),%eax
  8034db:	39 c2                	cmp    %eax,%edx
  8034dd:	0f 94 c0             	sete   %al
  8034e0:	0f b6 c0             	movzbl %al,%eax
}
  8034e3:	c9                   	leaveq 
  8034e4:	c3                   	retq   

00000000008034e5 <opencons>:

int
opencons(void)
{
  8034e5:	55                   	push   %rbp
  8034e6:	48 89 e5             	mov    %rsp,%rbp
  8034e9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8034ed:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034f1:	48 89 c7             	mov    %rax,%rdi
  8034f4:	48 b8 d8 1e 80 00 00 	movabs $0x801ed8,%rax
  8034fb:	00 00 00 
  8034fe:	ff d0                	callq  *%rax
  803500:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803507:	79 05                	jns    80350e <opencons+0x29>
		return r;
  803509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350c:	eb 5b                	jmp    803569 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80350e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803512:	ba 07 04 00 00       	mov    $0x407,%edx
  803517:	48 89 c6             	mov    %rax,%rsi
  80351a:	bf 00 00 00 00       	mov    $0x0,%edi
  80351f:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  803526:	00 00 00 
  803529:	ff d0                	callq  *%rax
  80352b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80352e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803532:	79 05                	jns    803539 <opencons+0x54>
		return r;
  803534:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803537:	eb 30                	jmp    803569 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803539:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803544:	00 00 00 
  803547:	8b 12                	mov    (%rdx),%edx
  803549:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80354b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355a:	48 89 c7             	mov    %rax,%rdi
  80355d:	48 b8 8a 1e 80 00 00 	movabs $0x801e8a,%rax
  803564:	00 00 00 
  803567:	ff d0                	callq  *%rax
}
  803569:	c9                   	leaveq 
  80356a:	c3                   	retq   

000000000080356b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80356b:	55                   	push   %rbp
  80356c:	48 89 e5             	mov    %rsp,%rbp
  80356f:	48 83 ec 30          	sub    $0x30,%rsp
  803573:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803577:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80357b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80357f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803584:	75 07                	jne    80358d <devcons_read+0x22>
		return 0;
  803586:	b8 00 00 00 00       	mov    $0x0,%eax
  80358b:	eb 4b                	jmp    8035d8 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80358d:	eb 0c                	jmp    80359b <devcons_read+0x30>
		sys_yield();
  80358f:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  803596:	00 00 00 
  803599:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80359b:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  8035a2:	00 00 00 
  8035a5:	ff d0                	callq  *%rax
  8035a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ae:	74 df                	je     80358f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8035b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b4:	79 05                	jns    8035bb <devcons_read+0x50>
		return c;
  8035b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b9:	eb 1d                	jmp    8035d8 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8035bb:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8035bf:	75 07                	jne    8035c8 <devcons_read+0x5d>
		return 0;
  8035c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c6:	eb 10                	jmp    8035d8 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8035c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cb:	89 c2                	mov    %eax,%edx
  8035cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d1:	88 10                	mov    %dl,(%rax)
	return 1;
  8035d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8035d8:	c9                   	leaveq 
  8035d9:	c3                   	retq   

00000000008035da <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035da:	55                   	push   %rbp
  8035db:	48 89 e5             	mov    %rsp,%rbp
  8035de:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8035e5:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8035ec:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8035f3:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8035fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803601:	eb 76                	jmp    803679 <devcons_write+0x9f>
		m = n - tot;
  803603:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80360a:	89 c2                	mov    %eax,%edx
  80360c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360f:	29 c2                	sub    %eax,%edx
  803611:	89 d0                	mov    %edx,%eax
  803613:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803616:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803619:	83 f8 7f             	cmp    $0x7f,%eax
  80361c:	76 07                	jbe    803625 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80361e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803625:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803628:	48 63 d0             	movslq %eax,%rdx
  80362b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80362e:	48 63 c8             	movslq %eax,%rcx
  803631:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803638:	48 01 c1             	add    %rax,%rcx
  80363b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803642:	48 89 ce             	mov    %rcx,%rsi
  803645:	48 89 c7             	mov    %rax,%rdi
  803648:	48 b8 2f 15 80 00 00 	movabs $0x80152f,%rax
  80364f:	00 00 00 
  803652:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803654:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803657:	48 63 d0             	movslq %eax,%rdx
  80365a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803661:	48 89 d6             	mov    %rdx,%rsi
  803664:	48 89 c7             	mov    %rax,%rdi
  803667:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  80366e:	00 00 00 
  803671:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803673:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803676:	01 45 fc             	add    %eax,-0x4(%rbp)
  803679:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367c:	48 98                	cltq   
  80367e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803685:	0f 82 78 ff ff ff    	jb     803603 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80368b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80368e:	c9                   	leaveq 
  80368f:	c3                   	retq   

0000000000803690 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803690:	55                   	push   %rbp
  803691:	48 89 e5             	mov    %rsp,%rbp
  803694:	48 83 ec 08          	sub    $0x8,%rsp
  803698:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80369c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036a1:	c9                   	leaveq 
  8036a2:	c3                   	retq   

00000000008036a3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8036a3:	55                   	push   %rbp
  8036a4:	48 89 e5             	mov    %rsp,%rbp
  8036a7:	48 83 ec 10          	sub    $0x10,%rsp
  8036ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8036b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b7:	48 be bc 43 80 00 00 	movabs $0x8043bc,%rsi
  8036be:	00 00 00 
  8036c1:	48 89 c7             	mov    %rax,%rdi
  8036c4:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  8036cb:	00 00 00 
  8036ce:	ff d0                	callq  *%rax
	return 0;
  8036d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036d5:	c9                   	leaveq 
  8036d6:	c3                   	retq   

00000000008036d7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8036d7:	55                   	push   %rbp
  8036d8:	48 89 e5             	mov    %rsp,%rbp
  8036db:	48 83 ec 30          	sub    $0x30,%rsp
  8036df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8036eb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036f2:	00 00 00 
  8036f5:	48 8b 00             	mov    (%rax),%rax
  8036f8:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8036fe:	85 c0                	test   %eax,%eax
  803700:	75 34                	jne    803736 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803702:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  803709:	00 00 00 
  80370c:	ff d0                	callq  *%rax
  80370e:	25 ff 03 00 00       	and    $0x3ff,%eax
  803713:	48 98                	cltq   
  803715:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80371c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803723:	00 00 00 
  803726:	48 01 c2             	add    %rax,%rdx
  803729:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803730:	00 00 00 
  803733:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803736:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80373b:	75 0e                	jne    80374b <ipc_recv+0x74>
		pg = (void*) UTOP;
  80373d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803744:	00 00 00 
  803747:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80374b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80374f:	48 89 c7             	mov    %rax,%rdi
  803752:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  803759:	00 00 00 
  80375c:	ff d0                	callq  *%rax
  80375e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803761:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803765:	79 19                	jns    803780 <ipc_recv+0xa9>
		*from_env_store = 0;
  803767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80376b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803775:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80377b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377e:	eb 53                	jmp    8037d3 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803780:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803785:	74 19                	je     8037a0 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803787:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80378e:	00 00 00 
  803791:	48 8b 00             	mov    (%rax),%rax
  803794:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80379a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80379e:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8037a0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8037a5:	74 19                	je     8037c0 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8037a7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037ae:	00 00 00 
  8037b1:	48 8b 00             	mov    (%rax),%rax
  8037b4:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8037ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037be:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8037c0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037c7:	00 00 00 
  8037ca:	48 8b 00             	mov    (%rax),%rax
  8037cd:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8037d3:	c9                   	leaveq 
  8037d4:	c3                   	retq   

00000000008037d5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8037d5:	55                   	push   %rbp
  8037d6:	48 89 e5             	mov    %rsp,%rbp
  8037d9:	48 83 ec 30          	sub    $0x30,%rsp
  8037dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037e0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8037e3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8037e7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8037ea:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8037ef:	75 0e                	jne    8037ff <ipc_send+0x2a>
		pg = (void*)UTOP;
  8037f1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8037f8:	00 00 00 
  8037fb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8037ff:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803802:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803805:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803809:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80380c:	89 c7                	mov    %eax,%edi
  80380e:	48 b8 0e 1d 80 00 00 	movabs $0x801d0e,%rax
  803815:	00 00 00 
  803818:	ff d0                	callq  *%rax
  80381a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80381d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803821:	75 0c                	jne    80382f <ipc_send+0x5a>
			sys_yield();
  803823:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  80382a:	00 00 00 
  80382d:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80382f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803833:	74 ca                	je     8037ff <ipc_send+0x2a>
	if(result != 0)
  803835:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803839:	74 20                	je     80385b <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  80383b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80383e:	89 c6                	mov    %eax,%esi
  803840:	48 bf c8 43 80 00 00 	movabs $0x8043c8,%rdi
  803847:	00 00 00 
  80384a:	b8 00 00 00 00       	mov    $0x0,%eax
  80384f:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  803856:	00 00 00 
  803859:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  80385b:	c9                   	leaveq 
  80385c:	c3                   	retq   

000000000080385d <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80385d:	55                   	push   %rbp
  80385e:	48 89 e5             	mov    %rsp,%rbp
  803861:	53                   	push   %rbx
  803862:	48 83 ec 58          	sub    $0x58,%rsp
  803866:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  80386a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80386e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  803872:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803879:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803880:	00 
  803881:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803885:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803889:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80388d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803891:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803895:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803899:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80389d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8038a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038a5:	48 c1 e8 27          	shr    $0x27,%rax
  8038a9:	48 89 c2             	mov    %rax,%rdx
  8038ac:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8038b3:	01 00 00 
  8038b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038ba:	83 e0 01             	and    $0x1,%eax
  8038bd:	48 85 c0             	test   %rax,%rax
  8038c0:	0f 85 91 00 00 00    	jne    803957 <ipc_host_recv+0xfa>
  8038c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ca:	48 c1 e8 1e          	shr    $0x1e,%rax
  8038ce:	48 89 c2             	mov    %rax,%rdx
  8038d1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8038d8:	01 00 00 
  8038db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038df:	83 e0 01             	and    $0x1,%eax
  8038e2:	48 85 c0             	test   %rax,%rax
  8038e5:	74 70                	je     803957 <ipc_host_recv+0xfa>
  8038e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038eb:	48 c1 e8 15          	shr    $0x15,%rax
  8038ef:	48 89 c2             	mov    %rax,%rdx
  8038f2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8038f9:	01 00 00 
  8038fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803900:	83 e0 01             	and    $0x1,%eax
  803903:	48 85 c0             	test   %rax,%rax
  803906:	74 4f                	je     803957 <ipc_host_recv+0xfa>
  803908:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80390c:	48 c1 e8 0c          	shr    $0xc,%rax
  803910:	48 89 c2             	mov    %rax,%rdx
  803913:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80391a:	01 00 00 
  80391d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803921:	83 e0 01             	and    $0x1,%eax
  803924:	48 85 c0             	test   %rax,%rax
  803927:	74 2e                	je     803957 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80392d:	ba 07 04 00 00       	mov    $0x407,%edx
  803932:	48 89 c6             	mov    %rax,%rsi
  803935:	bf 00 00 00 00       	mov    $0x0,%edi
  80393a:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  803941:	00 00 00 
  803944:	ff d0                	callq  *%rax
  803946:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80394d:	79 08                	jns    803957 <ipc_host_recv+0xfa>
	    	return result;
  80394f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803952:	e9 84 00 00 00       	jmpq   8039db <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80395b:	48 c1 e8 0c          	shr    $0xc,%rax
  80395f:	48 89 c2             	mov    %rax,%rdx
  803962:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803969:	01 00 00 
  80396c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803970:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803976:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  80397a:	b8 03 00 00 00       	mov    $0x3,%eax
  80397f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803983:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803987:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  80398b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80398f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803993:	4c 89 c3             	mov    %r8,%rbx
  803996:	0f 01 c1             	vmcall 
  803999:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  80399c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8039a0:	7e 36                	jle    8039d8 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  8039a2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8039a5:	41 89 c0             	mov    %eax,%r8d
  8039a8:	b9 03 00 00 00       	mov    $0x3,%ecx
  8039ad:	48 ba e0 43 80 00 00 	movabs $0x8043e0,%rdx
  8039b4:	00 00 00 
  8039b7:	be 67 00 00 00       	mov    $0x67,%esi
  8039bc:	48 bf 0d 44 80 00 00 	movabs $0x80440d,%rdi
  8039c3:	00 00 00 
  8039c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039cb:	49 b9 1d 04 80 00 00 	movabs $0x80041d,%r9
  8039d2:	00 00 00 
  8039d5:	41 ff d1             	callq  *%r9
	return result;
  8039d8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  8039db:	48 83 c4 58          	add    $0x58,%rsp
  8039df:	5b                   	pop    %rbx
  8039e0:	5d                   	pop    %rbp
  8039e1:	c3                   	retq   

00000000008039e2 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8039e2:	55                   	push   %rbp
  8039e3:	48 89 e5             	mov    %rsp,%rbp
  8039e6:	53                   	push   %rbx
  8039e7:	48 83 ec 68          	sub    $0x68,%rsp
  8039eb:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8039ee:	89 75 a8             	mov    %esi,-0x58(%rbp)
  8039f1:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  8039f5:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  8039f8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8039fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  803a00:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803a07:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803a0e:	00 
  803a0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a13:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803a17:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a1b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803a1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a23:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803a27:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a2b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  803a2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a33:	48 c1 e8 27          	shr    $0x27,%rax
  803a37:	48 89 c2             	mov    %rax,%rdx
  803a3a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803a41:	01 00 00 
  803a44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a48:	83 e0 01             	and    $0x1,%eax
  803a4b:	48 85 c0             	test   %rax,%rax
  803a4e:	0f 85 88 00 00 00    	jne    803adc <ipc_host_send+0xfa>
  803a54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a58:	48 c1 e8 1e          	shr    $0x1e,%rax
  803a5c:	48 89 c2             	mov    %rax,%rdx
  803a5f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803a66:	01 00 00 
  803a69:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a6d:	83 e0 01             	and    $0x1,%eax
  803a70:	48 85 c0             	test   %rax,%rax
  803a73:	74 67                	je     803adc <ipc_host_send+0xfa>
  803a75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a79:	48 c1 e8 15          	shr    $0x15,%rax
  803a7d:	48 89 c2             	mov    %rax,%rdx
  803a80:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a87:	01 00 00 
  803a8a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a8e:	83 e0 01             	and    $0x1,%eax
  803a91:	48 85 c0             	test   %rax,%rax
  803a94:	74 46                	je     803adc <ipc_host_send+0xfa>
  803a96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a9a:	48 c1 e8 0c          	shr    $0xc,%rax
  803a9e:	48 89 c2             	mov    %rax,%rdx
  803aa1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803aa8:	01 00 00 
  803aab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803aaf:	83 e0 01             	and    $0x1,%eax
  803ab2:	48 85 c0             	test   %rax,%rax
  803ab5:	74 25                	je     803adc <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803ab7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803abb:	48 c1 e8 0c          	shr    $0xc,%rax
  803abf:	48 89 c2             	mov    %rax,%rdx
  803ac2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ac9:	01 00 00 
  803acc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ad0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803ad6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803ada:	eb 0e                	jmp    803aea <ipc_host_send+0x108>
	else
		a3 = UTOP;
  803adc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ae3:	00 00 00 
  803ae6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  803aea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aee:	48 89 c6             	mov    %rax,%rsi
  803af1:	48 bf 17 44 80 00 00 	movabs $0x804417,%rdi
  803af8:	00 00 00 
  803afb:	b8 00 00 00 00       	mov    $0x0,%eax
  803b00:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  803b07:	00 00 00 
  803b0a:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  803b0c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  803b0f:	48 98                	cltq   
  803b11:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  803b15:	8b 45 a8             	mov    -0x58(%rbp),%eax
  803b18:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  803b1c:	8b 45 9c             	mov    -0x64(%rbp),%eax
  803b1f:	48 98                	cltq   
  803b21:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  803b25:	b8 02 00 00 00       	mov    $0x2,%eax
  803b2a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803b2e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803b32:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  803b36:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803b3a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803b3e:	4c 89 c3             	mov    %r8,%rbx
  803b41:	0f 01 c1             	vmcall 
  803b44:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  803b47:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803b4b:	75 0c                	jne    803b59 <ipc_host_send+0x177>
			sys_yield();
  803b4d:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  803b54:	00 00 00 
  803b57:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  803b59:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803b5d:	74 c6                	je     803b25 <ipc_host_send+0x143>
	
	if(result !=0)
  803b5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803b63:	74 36                	je     803b9b <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  803b65:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b68:	41 89 c0             	mov    %eax,%r8d
  803b6b:	b9 02 00 00 00       	mov    $0x2,%ecx
  803b70:	48 ba e0 43 80 00 00 	movabs $0x8043e0,%rdx
  803b77:	00 00 00 
  803b7a:	be 94 00 00 00       	mov    $0x94,%esi
  803b7f:	48 bf 0d 44 80 00 00 	movabs $0x80440d,%rdi
  803b86:	00 00 00 
  803b89:	b8 00 00 00 00       	mov    $0x0,%eax
  803b8e:	49 b9 1d 04 80 00 00 	movabs $0x80041d,%r9
  803b95:	00 00 00 
  803b98:	41 ff d1             	callq  *%r9
}
  803b9b:	48 83 c4 68          	add    $0x68,%rsp
  803b9f:	5b                   	pop    %rbx
  803ba0:	5d                   	pop    %rbp
  803ba1:	c3                   	retq   

0000000000803ba2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803ba2:	55                   	push   %rbp
  803ba3:	48 89 e5             	mov    %rsp,%rbp
  803ba6:	48 83 ec 14          	sub    $0x14,%rsp
  803baa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803bad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bb4:	eb 4e                	jmp    803c04 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803bb6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803bbd:	00 00 00 
  803bc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc3:	48 98                	cltq   
  803bc5:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803bcc:	48 01 d0             	add    %rdx,%rax
  803bcf:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803bd5:	8b 00                	mov    (%rax),%eax
  803bd7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803bda:	75 24                	jne    803c00 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803bdc:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803be3:	00 00 00 
  803be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be9:	48 98                	cltq   
  803beb:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803bf2:	48 01 d0             	add    %rdx,%rax
  803bf5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803bfb:	8b 40 08             	mov    0x8(%rax),%eax
  803bfe:	eb 12                	jmp    803c12 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803c00:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c04:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803c0b:	7e a9                	jle    803bb6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803c0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c12:	c9                   	leaveq 
  803c13:	c3                   	retq   

0000000000803c14 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c14:	55                   	push   %rbp
  803c15:	48 89 e5             	mov    %rsp,%rbp
  803c18:	48 83 ec 18          	sub    $0x18,%rsp
  803c1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c24:	48 c1 e8 15          	shr    $0x15,%rax
  803c28:	48 89 c2             	mov    %rax,%rdx
  803c2b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c32:	01 00 00 
  803c35:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c39:	83 e0 01             	and    $0x1,%eax
  803c3c:	48 85 c0             	test   %rax,%rax
  803c3f:	75 07                	jne    803c48 <pageref+0x34>
		return 0;
  803c41:	b8 00 00 00 00       	mov    $0x0,%eax
  803c46:	eb 53                	jmp    803c9b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c4c:	48 c1 e8 0c          	shr    $0xc,%rax
  803c50:	48 89 c2             	mov    %rax,%rdx
  803c53:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c5a:	01 00 00 
  803c5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c61:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c69:	83 e0 01             	and    $0x1,%eax
  803c6c:	48 85 c0             	test   %rax,%rax
  803c6f:	75 07                	jne    803c78 <pageref+0x64>
		return 0;
  803c71:	b8 00 00 00 00       	mov    $0x0,%eax
  803c76:	eb 23                	jmp    803c9b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c7c:	48 c1 e8 0c          	shr    $0xc,%rax
  803c80:	48 89 c2             	mov    %rax,%rdx
  803c83:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c8a:	00 00 00 
  803c8d:	48 c1 e2 04          	shl    $0x4,%rdx
  803c91:	48 01 d0             	add    %rdx,%rax
  803c94:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c98:	0f b7 c0             	movzwl %ax,%eax
}
  803c9b:	c9                   	leaveq 
  803c9c:	c3                   	retq   
