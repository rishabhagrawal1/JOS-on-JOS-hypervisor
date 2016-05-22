
obj/user/testshell:     file format elf64-x86-64


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
  80003c:	e8 f5 07 00 00       	callq  800836 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800052:	bf 00 00 00 00       	mov    $0x0,%edi
  800057:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  80006f:	00 00 00 
  800072:	ff d0                	callq  *%rax
	opencons();
  800074:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
	opencons();
  800080:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800087:	00 00 00 
  80008a:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008c:	be 00 00 00 00       	mov    $0x0,%esi
  800091:	48 bf 20 50 80 00 00 	movabs $0x805020,%rdi
  800098:	00 00 00 
  80009b:	48 b8 94 34 80 00 00 	movabs $0x803494,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba 2d 50 80 00 00 	movabs $0x80502d,%rdx
  8000bc:	00 00 00 
  8000bf:	be 13 00 00 00       	mov    $0x13,%esi
  8000c4:	48 bf 43 50 80 00 00 	movabs $0x805043,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 f6 45 80 00 00 	movabs $0x8045f6,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba 54 50 80 00 00 	movabs $0x805054,%rdx
  800108:	00 00 00 
  80010b:	be 15 00 00 00       	mov    $0x15,%esi
  800110:	48 bf 43 50 80 00 00 	movabs $0x805043,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf 60 50 80 00 00 	movabs $0x805060,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 30 28 80 00 00 	movabs $0x802830,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba 84 50 80 00 00 	movabs $0x805084,%rdx
  80016e:	00 00 00 
  800171:	be 1a 00 00 00       	mov    $0x1a,%esi
  800176:	48 bf 43 50 80 00 00 	movabs $0x805043,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  80018c:	00 00 00 
  80018f:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800192:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800196:	0f 85 fb 00 00 00    	jne    800297 <umain+0x254>
		dup(rfd, 0);
  80019c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	48 b8 48 2e 80 00 00 	movabs $0x802e48,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 48 2e 80 00 00 	movabs $0x802e48,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba 8d 50 80 00 00 	movabs $0x80508d,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be 90 50 80 00 00 	movabs $0x805090,%rsi
  800200:	00 00 00 
  800203:	48 bf 93 50 80 00 00 	movabs $0x805093,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 fd 3d 80 00 00 	movabs $0x803dfd,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba 9b 50 80 00 00 	movabs $0x80509b,%rdx
  800234:	00 00 00 
  800237:	be 21 00 00 00       	mov    $0x21,%esi
  80023c:	48 bf 43 50 80 00 00 	movabs $0x805043,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 bf 4b 80 00 00 	movabs $0x804bbf,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
		exit();
  80028b:	48 b8 b9 08 80 00 00 	movabs $0x8008b9,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	}
	close(rfd);
  800297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029a:	89 c7                	mov    %eax,%edi
  80029c:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf a5 50 80 00 00 	movabs $0x8050a5,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 94 34 80 00 00 	movabs $0x803494,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba b8 50 80 00 00 	movabs $0x8050b8,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2c 00 00 00       	mov    $0x2c,%esi
  8002f7:	48 bf 43 50 80 00 00 	movabs $0x805043,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  80030d:	00 00 00 
  800310:	41 ff d0             	callq  *%r8

	nloff = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  80031a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  800321:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800328:	ba 01 00 00 00       	mov    $0x1,%edx
  80032d:	48 89 ce             	mov    %rcx,%rsi
  800330:	89 c7                	mov    %eax,%edi
  800332:	48 b8 f1 2f 80 00 00 	movabs $0x802ff1,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 f1 2f 80 00 00 	movabs $0x802ff1,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba db 50 80 00 00 	movabs $0x8050db,%rdx
  800373:	00 00 00 
  800376:	be 33 00 00 00       	mov    $0x33,%esi
  80037b:	48 bf 43 50 80 00 00 	movabs $0x805043,%rdi
  800382:	00 00 00 
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  800391:	00 00 00 
  800394:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  800397:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039b:	79 30                	jns    8003cd <umain+0x38a>
			panic("reading testshell.key: %e", n2);
  80039d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003a0:	89 c1                	mov    %eax,%ecx
  8003a2:	48 ba f5 50 80 00 00 	movabs $0x8050f5,%rdx
  8003a9:	00 00 00 
  8003ac:	be 35 00 00 00       	mov    $0x35,%esi
  8003b1:	48 bf 43 50 80 00 00 	movabs $0x805043,%rdi
  8003b8:	00 00 00 
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8003c7:	00 00 00 
  8003ca:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003d1:	75 08                	jne    8003db <umain+0x398>
  8003d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003d7:	75 02                	jne    8003db <umain+0x398>
			break;
  8003d9:	eb 4b                	jmp    800426 <umain+0x3e3>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003db:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003df:	75 12                	jne    8003f3 <umain+0x3b0>
  8003e1:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  8003e5:	75 0c                	jne    8003f3 <umain+0x3b0>
  8003e7:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8003eb:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8003ef:	38 c2                	cmp    %al,%dl
  8003f1:	74 19                	je     80040c <umain+0x3c9>
			wrong(rfd, kfd, nloff);
  8003f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8003f6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8003f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003fc:	89 ce                	mov    %ecx,%esi
  8003fe:	89 c7                	mov    %eax,%edi
  800400:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
		if (c1 == '\n')
  80040c:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800410:	3c 0a                	cmp    $0xa,%al
  800412:	75 09                	jne    80041d <umain+0x3da>
			nloff = off+1;
  800414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800417:	83 c0 01             	add    $0x1,%eax
  80041a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  80041d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
  800421:	e9 fb fe ff ff       	jmpq   800321 <umain+0x2de>
	cprintf("shell ran correctly\n");
  800426:	48 bf 0f 51 80 00 00 	movabs $0x80510f,%rdi
  80042d:	00 00 00 
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  80043c:	00 00 00 
  80043f:	ff d2                	callq  *%rdx


    static __inline void
breakpoint(void)
{
    __asm __volatile("int3");
  800441:	cc                   	int3   

	breakpoint();
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80044c:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80044f:	89 75 88             	mov    %esi,-0x78(%rbp)
  800452:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800455:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800458:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80045b:	89 d6                	mov    %edx,%esi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf 28 51 80 00 00 	movabs $0x805128,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf 4a 51 80 00 00 	movabs $0x80514a,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004b7:	eb 1c                	jmp    8004d5 <wrong+0x91>
		sys_cputs(buf, n);
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	48 63 d0             	movslq %eax,%rdx
  8004bf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004d9:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004dc:	ba 63 00 00 00       	mov    $0x63,%edx
  8004e1:	48 89 ce             	mov    %rcx,%rsi
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 f1 2f 80 00 00 	movabs $0x802ff1,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf 59 51 80 00 00 	movabs $0x805159,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800516:	eb 1c                	jmp    800534 <wrong+0xf0>
		sys_cputs(buf, n);
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 63 d0             	movslq %eax,%rdx
  80051e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800522:	48 89 d6             	mov    %rdx,%rsi
  800525:	48 89 c7             	mov    %rax,%rdi
  800528:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800534:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800538:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80053b:	ba 63 00 00 00       	mov    $0x63,%edx
  800540:	48 89 ce             	mov    %rcx,%rsi
  800543:	89 c7                	mov    %eax,%edi
  800545:	48 b8 f1 2f 80 00 00 	movabs $0x802ff1,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf 67 51 80 00 00 	movabs $0x805167,%rdi
  800561:	00 00 00 
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  800570:	00 00 00 
  800573:	ff d2                	callq  *%rdx
	exit();
  800575:	48 b8 b9 08 80 00 00 	movabs $0x8008b9,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
}
  800581:	c9                   	leaveq 
  800582:	c3                   	retq   

0000000000800583 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800583:	55                   	push   %rbp
  800584:	48 89 e5             	mov    %rsp,%rbp
  800587:	48 83 ec 20          	sub    $0x20,%rsp
  80058b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80058e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800591:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800594:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800598:	be 01 00 00 00       	mov    $0x1,%esi
  80059d:	48 89 c7             	mov    %rax,%rdi
  8005a0:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	callq  *%rax
}
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <getchar>:

int
getchar(void)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005b6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8005bf:	48 89 c6             	mov    %rax,%rsi
  8005c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c7:	48 b8 f1 2f 80 00 00 	movabs $0x802ff1,%rax
  8005ce:	00 00 00 
  8005d1:	ff d0                	callq  *%rax
  8005d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005da:	79 05                	jns    8005e1 <getchar+0x33>
		return r;
  8005dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005df:	eb 14                	jmp    8005f5 <getchar+0x47>
	if (r < 1)
  8005e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e5:	7f 07                	jg     8005ee <getchar+0x40>
		return -E_EOF;
  8005e7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8005ec:	eb 07                	jmp    8005f5 <getchar+0x47>
	return c;
  8005ee:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8005f2:	0f b6 c0             	movzbl %al,%eax
}
  8005f5:	c9                   	leaveq 
  8005f6:	c3                   	retq   

00000000008005f7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8005f7:	55                   	push   %rbp
  8005f8:	48 89 e5             	mov    %rsp,%rbp
  8005fb:	48 83 ec 20          	sub    $0x20,%rsp
  8005ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800602:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800606:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800609:	48 89 d6             	mov    %rdx,%rsi
  80060c:	89 c7                	mov    %eax,%edi
  80060e:	48 b8 bf 2b 80 00 00 	movabs $0x802bbf,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
  80061a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80061d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800621:	79 05                	jns    800628 <iscons+0x31>
		return r;
  800623:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800626:	eb 1a                	jmp    800642 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062c:	8b 10                	mov    (%rax),%edx
  80062e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800635:	00 00 00 
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	39 c2                	cmp    %eax,%edx
  80063c:	0f 94 c0             	sete   %al
  80063f:	0f b6 c0             	movzbl %al,%eax
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <opencons>:

int
opencons(void)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80064c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800650:	48 89 c7             	mov    %rax,%rdi
  800653:	48 b8 27 2b 80 00 00 	movabs $0x802b27,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	callq  *%rax
  80065f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800662:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800666:	79 05                	jns    80066d <opencons+0x29>
		return r;
  800668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80066b:	eb 5b                	jmp    8006c8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80066d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800671:	ba 07 04 00 00       	mov    $0x407,%edx
  800676:	48 89 c6             	mov    %rax,%rsi
  800679:	bf 00 00 00 00       	mov    $0x0,%edi
  80067e:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  800685:	00 00 00 
  800688:	ff d0                	callq  *%rax
  80068a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80068d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800691:	79 05                	jns    800698 <opencons+0x54>
		return r;
  800693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800696:	eb 30                	jmp    8006c8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8006a3:	00 00 00 
  8006a6:	8b 12                	mov    (%rdx),%edx
  8006a8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b9:	48 89 c7             	mov    %rax,%rdi
  8006bc:	48 b8 d9 2a 80 00 00 	movabs $0x802ad9,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
}
  8006c8:	c9                   	leaveq 
  8006c9:	c3                   	retq   

00000000008006ca <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006ca:	55                   	push   %rbp
  8006cb:	48 89 e5             	mov    %rsp,%rbp
  8006ce:	48 83 ec 30          	sub    $0x30,%rsp
  8006d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006de:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006e3:	75 07                	jne    8006ec <devcons_read+0x22>
		return 0;
  8006e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ea:	eb 4b                	jmp    800737 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8006ec:	eb 0c                	jmp    8006fa <devcons_read+0x30>
		sys_yield();
  8006ee:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  8006f5:	00 00 00 
  8006f8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8006fa:	48 b8 fb 1e 80 00 00 	movabs $0x801efb,%rax
  800701:	00 00 00 
  800704:	ff d0                	callq  *%rax
  800706:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800709:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070d:	74 df                	je     8006ee <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80070f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800713:	79 05                	jns    80071a <devcons_read+0x50>
		return c;
  800715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800718:	eb 1d                	jmp    800737 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80071a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80071e:	75 07                	jne    800727 <devcons_read+0x5d>
		return 0;
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	eb 10                	jmp    800737 <devcons_read+0x6d>
	*(char*)vbuf = c;
  800727:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800730:	88 10                	mov    %dl,(%rax)
	return 1;
  800732:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800737:	c9                   	leaveq 
  800738:	c3                   	retq   

0000000000800739 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800744:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80074b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800752:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800759:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800760:	eb 76                	jmp    8007d8 <devcons_write+0x9f>
		m = n - tot;
  800762:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800769:	89 c2                	mov    %eax,%edx
  80076b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80076e:	29 c2                	sub    %eax,%edx
  800770:	89 d0                	mov    %edx,%eax
  800772:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800778:	83 f8 7f             	cmp    $0x7f,%eax
  80077b:	76 07                	jbe    800784 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80077d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  800784:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800787:	48 63 d0             	movslq %eax,%rdx
  80078a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80078d:	48 63 c8             	movslq %eax,%rcx
  800790:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800797:	48 01 c1             	add    %rax,%rcx
  80079a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007b6:	48 63 d0             	movslq %eax,%rdx
  8007b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007c0:	48 89 d6             	mov    %rdx,%rsi
  8007c3:	48 89 c7             	mov    %rax,%rdi
  8007c6:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  8007cd:	00 00 00 
  8007d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8007d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007e4:	0f 82 78 ff ff ff    	jb     800762 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8007ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ed:	c9                   	leaveq 
  8007ee:	c3                   	retq   

00000000008007ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8007ef:	55                   	push   %rbp
  8007f0:	48 89 e5             	mov    %rsp,%rbp
  8007f3:	48 83 ec 08          	sub    $0x8,%rsp
  8007f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 10          	sub    $0x10,%rsp
  80080a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800816:	48 be 71 51 80 00 00 	movabs $0x805171,%rsi
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
	return 0;
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   

0000000000800836 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800836:	55                   	push   %rbp
  800837:	48 89 e5             	mov    %rsp,%rbp
  80083a:	48 83 ec 10          	sub    $0x10,%rsp
  80083e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800841:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800845:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  80084c:	00 00 00 
  80084f:	ff d0                	callq  *%rax
  800851:	25 ff 03 00 00       	and    $0x3ff,%eax
  800856:	48 98                	cltq   
  800858:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80085f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800866:	00 00 00 
  800869:	48 01 c2             	add    %rax,%rdx
  80086c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800873:	00 00 00 
  800876:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800879:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80087d:	7e 14                	jle    800893 <libmain+0x5d>
		binaryname = argv[0];
  80087f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800883:	48 8b 10             	mov    (%rax),%rdx
  800886:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  80088d:	00 00 00 
  800890:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800893:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800897:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80089a:	48 89 d6             	mov    %rdx,%rsi
  80089d:	89 c7                	mov    %eax,%edi
  80089f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8008a6:	00 00 00 
  8008a9:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8008ab:	48 b8 b9 08 80 00 00 	movabs $0x8008b9,%rax
  8008b2:	00 00 00 
  8008b5:	ff d0                	callq  *%rax
}
  8008b7:	c9                   	leaveq 
  8008b8:	c3                   	retq   

00000000008008b9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008b9:	55                   	push   %rbp
  8008ba:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8008bd:	48 b8 1a 2e 80 00 00 	movabs $0x802e1a,%rax
  8008c4:	00 00 00 
  8008c7:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8008c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8008ce:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  8008d5:	00 00 00 
  8008d8:	ff d0                	callq  *%rax

}
  8008da:	5d                   	pop    %rbp
  8008db:	c3                   	retq   

00000000008008dc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008dc:	55                   	push   %rbp
  8008dd:	48 89 e5             	mov    %rsp,%rbp
  8008e0:	53                   	push   %rbx
  8008e1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8008e8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8008ef:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8008f5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8008fc:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800903:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80090a:	84 c0                	test   %al,%al
  80090c:	74 23                	je     800931 <_panic+0x55>
  80090e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800915:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800919:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80091d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800921:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800925:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800929:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80092d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800931:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800938:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80093f:	00 00 00 
  800942:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800949:	00 00 00 
  80094c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800950:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800957:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80095e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800965:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  80096c:	00 00 00 
  80096f:	48 8b 18             	mov    (%rax),%rbx
  800972:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  800979:	00 00 00 
  80097c:	ff d0                	callq  *%rax
  80097e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800984:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80098b:	41 89 c8             	mov    %ecx,%r8d
  80098e:	48 89 d1             	mov    %rdx,%rcx
  800991:	48 89 da             	mov    %rbx,%rdx
  800994:	89 c6                	mov    %eax,%esi
  800996:	48 bf 88 51 80 00 00 	movabs $0x805188,%rdi
  80099d:	00 00 00 
  8009a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a5:	49 b9 15 0b 80 00 00 	movabs $0x800b15,%r9
  8009ac:	00 00 00 
  8009af:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009b2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009b9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009c0:	48 89 d6             	mov    %rdx,%rsi
  8009c3:	48 89 c7             	mov    %rax,%rdi
  8009c6:	48 b8 69 0a 80 00 00 	movabs $0x800a69,%rax
  8009cd:	00 00 00 
  8009d0:	ff d0                	callq  *%rax
	cprintf("\n");
  8009d2:	48 bf ab 51 80 00 00 	movabs $0x8051ab,%rdi
  8009d9:	00 00 00 
  8009dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e1:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  8009e8:	00 00 00 
  8009eb:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009ed:	cc                   	int3   
  8009ee:	eb fd                	jmp    8009ed <_panic+0x111>

00000000008009f0 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8009f0:	55                   	push   %rbp
  8009f1:	48 89 e5             	mov    %rsp,%rbp
  8009f4:	48 83 ec 10          	sub    $0x10,%rsp
  8009f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8009fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8009ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a03:	8b 00                	mov    (%rax),%eax
  800a05:	8d 48 01             	lea    0x1(%rax),%ecx
  800a08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a0c:	89 0a                	mov    %ecx,(%rdx)
  800a0e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a11:	89 d1                	mov    %edx,%ecx
  800a13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a17:	48 98                	cltq   
  800a19:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800a1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a21:	8b 00                	mov    (%rax),%eax
  800a23:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a28:	75 2c                	jne    800a56 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800a2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a2e:	8b 00                	mov    (%rax),%eax
  800a30:	48 98                	cltq   
  800a32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a36:	48 83 c2 08          	add    $0x8,%rdx
  800a3a:	48 89 c6             	mov    %rax,%rsi
  800a3d:	48 89 d7             	mov    %rdx,%rdi
  800a40:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  800a47:	00 00 00 
  800a4a:	ff d0                	callq  *%rax
        b->idx = 0;
  800a4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a50:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a5a:	8b 40 04             	mov    0x4(%rax),%eax
  800a5d:	8d 50 01             	lea    0x1(%rax),%edx
  800a60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a64:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a67:	c9                   	leaveq 
  800a68:	c3                   	retq   

0000000000800a69 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800a69:	55                   	push   %rbp
  800a6a:	48 89 e5             	mov    %rsp,%rbp
  800a6d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a74:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800a7b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800a82:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800a89:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800a90:	48 8b 0a             	mov    (%rdx),%rcx
  800a93:	48 89 08             	mov    %rcx,(%rax)
  800a96:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a9a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a9e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800aa2:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800aa6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800aad:	00 00 00 
    b.cnt = 0;
  800ab0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800ab7:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800aba:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ac1:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800ac8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800acf:	48 89 c6             	mov    %rax,%rsi
  800ad2:	48 bf f0 09 80 00 00 	movabs $0x8009f0,%rdi
  800ad9:	00 00 00 
  800adc:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  800ae3:	00 00 00 
  800ae6:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800ae8:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800aee:	48 98                	cltq   
  800af0:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800af7:	48 83 c2 08          	add    $0x8,%rdx
  800afb:	48 89 c6             	mov    %rax,%rsi
  800afe:	48 89 d7             	mov    %rdx,%rdi
  800b01:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  800b08:	00 00 00 
  800b0b:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b0d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b13:	c9                   	leaveq 
  800b14:	c3                   	retq   

0000000000800b15 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b15:	55                   	push   %rbp
  800b16:	48 89 e5             	mov    %rsp,%rbp
  800b19:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b20:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b27:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b2e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b35:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b3c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b43:	84 c0                	test   %al,%al
  800b45:	74 20                	je     800b67 <cprintf+0x52>
  800b47:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b4b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b4f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b53:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b57:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b5b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b5f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b63:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b67:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800b6e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b75:	00 00 00 
  800b78:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800b7f:	00 00 00 
  800b82:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b86:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800b8d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b94:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800b9b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ba2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ba9:	48 8b 0a             	mov    (%rdx),%rcx
  800bac:	48 89 08             	mov    %rcx,(%rax)
  800baf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bb3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bb7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bbb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800bbf:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800bc6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bcd:	48 89 d6             	mov    %rdx,%rsi
  800bd0:	48 89 c7             	mov    %rax,%rdi
  800bd3:	48 b8 69 0a 80 00 00 	movabs $0x800a69,%rax
  800bda:	00 00 00 
  800bdd:	ff d0                	callq  *%rax
  800bdf:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800be5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800beb:	c9                   	leaveq 
  800bec:	c3                   	retq   

0000000000800bed <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bed:	55                   	push   %rbp
  800bee:	48 89 e5             	mov    %rsp,%rbp
  800bf1:	53                   	push   %rbx
  800bf2:	48 83 ec 38          	sub    $0x38,%rsp
  800bf6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800bfa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800bfe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800c02:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800c05:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800c09:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c0d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800c10:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c14:	77 3b                	ja     800c51 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c16:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800c19:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c1d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800c20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c24:	ba 00 00 00 00       	mov    $0x0,%edx
  800c29:	48 f7 f3             	div    %rbx
  800c2c:	48 89 c2             	mov    %rax,%rdx
  800c2f:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800c32:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c35:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c3d:	41 89 f9             	mov    %edi,%r9d
  800c40:	48 89 c7             	mov    %rax,%rdi
  800c43:	48 b8 ed 0b 80 00 00 	movabs $0x800bed,%rax
  800c4a:	00 00 00 
  800c4d:	ff d0                	callq  *%rax
  800c4f:	eb 1e                	jmp    800c6f <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c51:	eb 12                	jmp    800c65 <printnum+0x78>
			putch(padc, putdat);
  800c53:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c57:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800c5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c5e:	48 89 ce             	mov    %rcx,%rsi
  800c61:	89 d7                	mov    %edx,%edi
  800c63:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c65:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800c69:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800c6d:	7f e4                	jg     800c53 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c6f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c76:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7b:	48 f7 f1             	div    %rcx
  800c7e:	48 89 d0             	mov    %rdx,%rax
  800c81:	48 ba b0 53 80 00 00 	movabs $0x8053b0,%rdx
  800c88:	00 00 00 
  800c8b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800c8f:	0f be d0             	movsbl %al,%edx
  800c92:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9a:	48 89 ce             	mov    %rcx,%rsi
  800c9d:	89 d7                	mov    %edx,%edi
  800c9f:	ff d0                	callq  *%rax
}
  800ca1:	48 83 c4 38          	add    $0x38,%rsp
  800ca5:	5b                   	pop    %rbx
  800ca6:	5d                   	pop    %rbp
  800ca7:	c3                   	retq   

0000000000800ca8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ca8:	55                   	push   %rbp
  800ca9:	48 89 e5             	mov    %rsp,%rbp
  800cac:	48 83 ec 1c          	sub    $0x1c,%rsp
  800cb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cb4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800cb7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800cbb:	7e 52                	jle    800d0f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc1:	8b 00                	mov    (%rax),%eax
  800cc3:	83 f8 30             	cmp    $0x30,%eax
  800cc6:	73 24                	jae    800cec <getuint+0x44>
  800cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd4:	8b 00                	mov    (%rax),%eax
  800cd6:	89 c0                	mov    %eax,%eax
  800cd8:	48 01 d0             	add    %rdx,%rax
  800cdb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cdf:	8b 12                	mov    (%rdx),%edx
  800ce1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ce4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ce8:	89 0a                	mov    %ecx,(%rdx)
  800cea:	eb 17                	jmp    800d03 <getuint+0x5b>
  800cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800cf4:	48 89 d0             	mov    %rdx,%rax
  800cf7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800cfb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d03:	48 8b 00             	mov    (%rax),%rax
  800d06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d0a:	e9 a3 00 00 00       	jmpq   800db2 <getuint+0x10a>
	else if (lflag)
  800d0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d13:	74 4f                	je     800d64 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d19:	8b 00                	mov    (%rax),%eax
  800d1b:	83 f8 30             	cmp    $0x30,%eax
  800d1e:	73 24                	jae    800d44 <getuint+0x9c>
  800d20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d24:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2c:	8b 00                	mov    (%rax),%eax
  800d2e:	89 c0                	mov    %eax,%eax
  800d30:	48 01 d0             	add    %rdx,%rax
  800d33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d37:	8b 12                	mov    (%rdx),%edx
  800d39:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d3c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d40:	89 0a                	mov    %ecx,(%rdx)
  800d42:	eb 17                	jmp    800d5b <getuint+0xb3>
  800d44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d48:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d4c:	48 89 d0             	mov    %rdx,%rax
  800d4f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d57:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d5b:	48 8b 00             	mov    (%rax),%rax
  800d5e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d62:	eb 4e                	jmp    800db2 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d68:	8b 00                	mov    (%rax),%eax
  800d6a:	83 f8 30             	cmp    $0x30,%eax
  800d6d:	73 24                	jae    800d93 <getuint+0xeb>
  800d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d73:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7b:	8b 00                	mov    (%rax),%eax
  800d7d:	89 c0                	mov    %eax,%eax
  800d7f:	48 01 d0             	add    %rdx,%rax
  800d82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d86:	8b 12                	mov    (%rdx),%edx
  800d88:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d8b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d8f:	89 0a                	mov    %ecx,(%rdx)
  800d91:	eb 17                	jmp    800daa <getuint+0x102>
  800d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d97:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d9b:	48 89 d0             	mov    %rdx,%rax
  800d9e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800da2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800daa:	8b 00                	mov    (%rax),%eax
  800dac:	89 c0                	mov    %eax,%eax
  800dae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800db6:	c9                   	leaveq 
  800db7:	c3                   	retq   

0000000000800db8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800db8:	55                   	push   %rbp
  800db9:	48 89 e5             	mov    %rsp,%rbp
  800dbc:	48 83 ec 1c          	sub    $0x1c,%rsp
  800dc0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dc4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800dc7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800dcb:	7e 52                	jle    800e1f <getint+0x67>
		x=va_arg(*ap, long long);
  800dcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd1:	8b 00                	mov    (%rax),%eax
  800dd3:	83 f8 30             	cmp    $0x30,%eax
  800dd6:	73 24                	jae    800dfc <getint+0x44>
  800dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de4:	8b 00                	mov    (%rax),%eax
  800de6:	89 c0                	mov    %eax,%eax
  800de8:	48 01 d0             	add    %rdx,%rax
  800deb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800def:	8b 12                	mov    (%rdx),%edx
  800df1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800df4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800df8:	89 0a                	mov    %ecx,(%rdx)
  800dfa:	eb 17                	jmp    800e13 <getint+0x5b>
  800dfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e00:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e04:	48 89 d0             	mov    %rdx,%rax
  800e07:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e0f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e13:	48 8b 00             	mov    (%rax),%rax
  800e16:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e1a:	e9 a3 00 00 00       	jmpq   800ec2 <getint+0x10a>
	else if (lflag)
  800e1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e23:	74 4f                	je     800e74 <getint+0xbc>
		x=va_arg(*ap, long);
  800e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e29:	8b 00                	mov    (%rax),%eax
  800e2b:	83 f8 30             	cmp    $0x30,%eax
  800e2e:	73 24                	jae    800e54 <getint+0x9c>
  800e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e34:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3c:	8b 00                	mov    (%rax),%eax
  800e3e:	89 c0                	mov    %eax,%eax
  800e40:	48 01 d0             	add    %rdx,%rax
  800e43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e47:	8b 12                	mov    (%rdx),%edx
  800e49:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e50:	89 0a                	mov    %ecx,(%rdx)
  800e52:	eb 17                	jmp    800e6b <getint+0xb3>
  800e54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e58:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e5c:	48 89 d0             	mov    %rdx,%rax
  800e5f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e63:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e67:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e6b:	48 8b 00             	mov    (%rax),%rax
  800e6e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e72:	eb 4e                	jmp    800ec2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e78:	8b 00                	mov    (%rax),%eax
  800e7a:	83 f8 30             	cmp    $0x30,%eax
  800e7d:	73 24                	jae    800ea3 <getint+0xeb>
  800e7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e83:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	8b 00                	mov    (%rax),%eax
  800e8d:	89 c0                	mov    %eax,%eax
  800e8f:	48 01 d0             	add    %rdx,%rax
  800e92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e96:	8b 12                	mov    (%rdx),%edx
  800e98:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e9f:	89 0a                	mov    %ecx,(%rdx)
  800ea1:	eb 17                	jmp    800eba <getint+0x102>
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800eab:	48 89 d0             	mov    %rdx,%rax
  800eae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800eb2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eb6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800eba:	8b 00                	mov    (%rax),%eax
  800ebc:	48 98                	cltq   
  800ebe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ec2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ec6:	c9                   	leaveq 
  800ec7:	c3                   	retq   

0000000000800ec8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ec8:	55                   	push   %rbp
  800ec9:	48 89 e5             	mov    %rsp,%rbp
  800ecc:	41 54                	push   %r12
  800ece:	53                   	push   %rbx
  800ecf:	48 83 ec 60          	sub    $0x60,%rsp
  800ed3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ed7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800edb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800edf:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ee3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ee7:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800eeb:	48 8b 0a             	mov    (%rdx),%rcx
  800eee:	48 89 08             	mov    %rcx,(%rax)
  800ef1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ef5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ef9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800efd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f01:	eb 17                	jmp    800f1a <vprintfmt+0x52>
			if (ch == '\0')
  800f03:	85 db                	test   %ebx,%ebx
  800f05:	0f 84 cc 04 00 00    	je     8013d7 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800f0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f13:	48 89 d6             	mov    %rdx,%rsi
  800f16:	89 df                	mov    %ebx,%edi
  800f18:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f1a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f1e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f22:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f26:	0f b6 00             	movzbl (%rax),%eax
  800f29:	0f b6 d8             	movzbl %al,%ebx
  800f2c:	83 fb 25             	cmp    $0x25,%ebx
  800f2f:	75 d2                	jne    800f03 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f31:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f35:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f3c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f4a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f51:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f55:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f59:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f5d:	0f b6 00             	movzbl (%rax),%eax
  800f60:	0f b6 d8             	movzbl %al,%ebx
  800f63:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800f66:	83 f8 55             	cmp    $0x55,%eax
  800f69:	0f 87 34 04 00 00    	ja     8013a3 <vprintfmt+0x4db>
  800f6f:	89 c0                	mov    %eax,%eax
  800f71:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800f78:	00 
  800f79:	48 b8 d8 53 80 00 00 	movabs $0x8053d8,%rax
  800f80:	00 00 00 
  800f83:	48 01 d0             	add    %rdx,%rax
  800f86:	48 8b 00             	mov    (%rax),%rax
  800f89:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800f8b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800f8f:	eb c0                	jmp    800f51 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f91:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800f95:	eb ba                	jmp    800f51 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f97:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800f9e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800fa1:	89 d0                	mov    %edx,%eax
  800fa3:	c1 e0 02             	shl    $0x2,%eax
  800fa6:	01 d0                	add    %edx,%eax
  800fa8:	01 c0                	add    %eax,%eax
  800faa:	01 d8                	add    %ebx,%eax
  800fac:	83 e8 30             	sub    $0x30,%eax
  800faf:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fb2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fb6:	0f b6 00             	movzbl (%rax),%eax
  800fb9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fbc:	83 fb 2f             	cmp    $0x2f,%ebx
  800fbf:	7e 0c                	jle    800fcd <vprintfmt+0x105>
  800fc1:	83 fb 39             	cmp    $0x39,%ebx
  800fc4:	7f 07                	jg     800fcd <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fcb:	eb d1                	jmp    800f9e <vprintfmt+0xd6>
			goto process_precision;
  800fcd:	eb 58                	jmp    801027 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800fcf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fd2:	83 f8 30             	cmp    $0x30,%eax
  800fd5:	73 17                	jae    800fee <vprintfmt+0x126>
  800fd7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fdb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fde:	89 c0                	mov    %eax,%eax
  800fe0:	48 01 d0             	add    %rdx,%rax
  800fe3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fe6:	83 c2 08             	add    $0x8,%edx
  800fe9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fec:	eb 0f                	jmp    800ffd <vprintfmt+0x135>
  800fee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ff2:	48 89 d0             	mov    %rdx,%rax
  800ff5:	48 83 c2 08          	add    $0x8,%rdx
  800ff9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ffd:	8b 00                	mov    (%rax),%eax
  800fff:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801002:	eb 23                	jmp    801027 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801004:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801008:	79 0c                	jns    801016 <vprintfmt+0x14e>
				width = 0;
  80100a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801011:	e9 3b ff ff ff       	jmpq   800f51 <vprintfmt+0x89>
  801016:	e9 36 ff ff ff       	jmpq   800f51 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80101b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801022:	e9 2a ff ff ff       	jmpq   800f51 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801027:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80102b:	79 12                	jns    80103f <vprintfmt+0x177>
				width = precision, precision = -1;
  80102d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801030:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801033:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80103a:	e9 12 ff ff ff       	jmpq   800f51 <vprintfmt+0x89>
  80103f:	e9 0d ff ff ff       	jmpq   800f51 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801044:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801048:	e9 04 ff ff ff       	jmpq   800f51 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80104d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801050:	83 f8 30             	cmp    $0x30,%eax
  801053:	73 17                	jae    80106c <vprintfmt+0x1a4>
  801055:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801059:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80105c:	89 c0                	mov    %eax,%eax
  80105e:	48 01 d0             	add    %rdx,%rax
  801061:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801064:	83 c2 08             	add    $0x8,%edx
  801067:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80106a:	eb 0f                	jmp    80107b <vprintfmt+0x1b3>
  80106c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801070:	48 89 d0             	mov    %rdx,%rax
  801073:	48 83 c2 08          	add    $0x8,%rdx
  801077:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80107b:	8b 10                	mov    (%rax),%edx
  80107d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801081:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801085:	48 89 ce             	mov    %rcx,%rsi
  801088:	89 d7                	mov    %edx,%edi
  80108a:	ff d0                	callq  *%rax
			break;
  80108c:	e9 40 03 00 00       	jmpq   8013d1 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801091:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801094:	83 f8 30             	cmp    $0x30,%eax
  801097:	73 17                	jae    8010b0 <vprintfmt+0x1e8>
  801099:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80109d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010a0:	89 c0                	mov    %eax,%eax
  8010a2:	48 01 d0             	add    %rdx,%rax
  8010a5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010a8:	83 c2 08             	add    $0x8,%edx
  8010ab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010ae:	eb 0f                	jmp    8010bf <vprintfmt+0x1f7>
  8010b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010b4:	48 89 d0             	mov    %rdx,%rax
  8010b7:	48 83 c2 08          	add    $0x8,%rdx
  8010bb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010bf:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010c1:	85 db                	test   %ebx,%ebx
  8010c3:	79 02                	jns    8010c7 <vprintfmt+0x1ff>
				err = -err;
  8010c5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010c7:	83 fb 15             	cmp    $0x15,%ebx
  8010ca:	7f 16                	jg     8010e2 <vprintfmt+0x21a>
  8010cc:	48 b8 00 53 80 00 00 	movabs $0x805300,%rax
  8010d3:	00 00 00 
  8010d6:	48 63 d3             	movslq %ebx,%rdx
  8010d9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8010dd:	4d 85 e4             	test   %r12,%r12
  8010e0:	75 2e                	jne    801110 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8010e2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010e6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010ea:	89 d9                	mov    %ebx,%ecx
  8010ec:	48 ba c1 53 80 00 00 	movabs $0x8053c1,%rdx
  8010f3:	00 00 00 
  8010f6:	48 89 c7             	mov    %rax,%rdi
  8010f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fe:	49 b8 e0 13 80 00 00 	movabs $0x8013e0,%r8
  801105:	00 00 00 
  801108:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80110b:	e9 c1 02 00 00       	jmpq   8013d1 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801110:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801114:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801118:	4c 89 e1             	mov    %r12,%rcx
  80111b:	48 ba ca 53 80 00 00 	movabs $0x8053ca,%rdx
  801122:	00 00 00 
  801125:	48 89 c7             	mov    %rax,%rdi
  801128:	b8 00 00 00 00       	mov    $0x0,%eax
  80112d:	49 b8 e0 13 80 00 00 	movabs $0x8013e0,%r8
  801134:	00 00 00 
  801137:	41 ff d0             	callq  *%r8
			break;
  80113a:	e9 92 02 00 00       	jmpq   8013d1 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80113f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801142:	83 f8 30             	cmp    $0x30,%eax
  801145:	73 17                	jae    80115e <vprintfmt+0x296>
  801147:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80114b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80114e:	89 c0                	mov    %eax,%eax
  801150:	48 01 d0             	add    %rdx,%rax
  801153:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801156:	83 c2 08             	add    $0x8,%edx
  801159:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80115c:	eb 0f                	jmp    80116d <vprintfmt+0x2a5>
  80115e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801162:	48 89 d0             	mov    %rdx,%rax
  801165:	48 83 c2 08          	add    $0x8,%rdx
  801169:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80116d:	4c 8b 20             	mov    (%rax),%r12
  801170:	4d 85 e4             	test   %r12,%r12
  801173:	75 0a                	jne    80117f <vprintfmt+0x2b7>
				p = "(null)";
  801175:	49 bc cd 53 80 00 00 	movabs $0x8053cd,%r12
  80117c:	00 00 00 
			if (width > 0 && padc != '-')
  80117f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801183:	7e 3f                	jle    8011c4 <vprintfmt+0x2fc>
  801185:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801189:	74 39                	je     8011c4 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80118b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80118e:	48 98                	cltq   
  801190:	48 89 c6             	mov    %rax,%rsi
  801193:	4c 89 e7             	mov    %r12,%rdi
  801196:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  80119d:	00 00 00 
  8011a0:	ff d0                	callq  *%rax
  8011a2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8011a5:	eb 17                	jmp    8011be <vprintfmt+0x2f6>
					putch(padc, putdat);
  8011a7:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8011ab:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8011af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011b3:	48 89 ce             	mov    %rcx,%rsi
  8011b6:	89 d7                	mov    %edx,%edi
  8011b8:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011ba:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011be:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011c2:	7f e3                	jg     8011a7 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011c4:	eb 37                	jmp    8011fd <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8011c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8011ca:	74 1e                	je     8011ea <vprintfmt+0x322>
  8011cc:	83 fb 1f             	cmp    $0x1f,%ebx
  8011cf:	7e 05                	jle    8011d6 <vprintfmt+0x30e>
  8011d1:	83 fb 7e             	cmp    $0x7e,%ebx
  8011d4:	7e 14                	jle    8011ea <vprintfmt+0x322>
					putch('?', putdat);
  8011d6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011da:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011de:	48 89 d6             	mov    %rdx,%rsi
  8011e1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8011e6:	ff d0                	callq  *%rax
  8011e8:	eb 0f                	jmp    8011f9 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8011ea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011f2:	48 89 d6             	mov    %rdx,%rsi
  8011f5:	89 df                	mov    %ebx,%edi
  8011f7:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011f9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011fd:	4c 89 e0             	mov    %r12,%rax
  801200:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801204:	0f b6 00             	movzbl (%rax),%eax
  801207:	0f be d8             	movsbl %al,%ebx
  80120a:	85 db                	test   %ebx,%ebx
  80120c:	74 10                	je     80121e <vprintfmt+0x356>
  80120e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801212:	78 b2                	js     8011c6 <vprintfmt+0x2fe>
  801214:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801218:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80121c:	79 a8                	jns    8011c6 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80121e:	eb 16                	jmp    801236 <vprintfmt+0x36e>
				putch(' ', putdat);
  801220:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801224:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801228:	48 89 d6             	mov    %rdx,%rsi
  80122b:	bf 20 00 00 00       	mov    $0x20,%edi
  801230:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801232:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801236:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80123a:	7f e4                	jg     801220 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80123c:	e9 90 01 00 00       	jmpq   8013d1 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801241:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801245:	be 03 00 00 00       	mov    $0x3,%esi
  80124a:	48 89 c7             	mov    %rax,%rdi
  80124d:	48 b8 b8 0d 80 00 00 	movabs $0x800db8,%rax
  801254:	00 00 00 
  801257:	ff d0                	callq  *%rax
  801259:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80125d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801261:	48 85 c0             	test   %rax,%rax
  801264:	79 1d                	jns    801283 <vprintfmt+0x3bb>
				putch('-', putdat);
  801266:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80126a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80126e:	48 89 d6             	mov    %rdx,%rsi
  801271:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801276:	ff d0                	callq  *%rax
				num = -(long long) num;
  801278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127c:	48 f7 d8             	neg    %rax
  80127f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801283:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80128a:	e9 d5 00 00 00       	jmpq   801364 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80128f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801293:	be 03 00 00 00       	mov    $0x3,%esi
  801298:	48 89 c7             	mov    %rax,%rdi
  80129b:	48 b8 a8 0c 80 00 00 	movabs $0x800ca8,%rax
  8012a2:	00 00 00 
  8012a5:	ff d0                	callq  *%rax
  8012a7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8012ab:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012b2:	e9 ad 00 00 00       	jmpq   801364 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8012b7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8012ba:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012be:	89 d6                	mov    %edx,%esi
  8012c0:	48 89 c7             	mov    %rax,%rdi
  8012c3:	48 b8 b8 0d 80 00 00 	movabs $0x800db8,%rax
  8012ca:	00 00 00 
  8012cd:	ff d0                	callq  *%rax
  8012cf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8012d3:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8012da:	e9 85 00 00 00       	jmpq   801364 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8012df:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012e3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012e7:	48 89 d6             	mov    %rdx,%rsi
  8012ea:	bf 30 00 00 00       	mov    $0x30,%edi
  8012ef:	ff d0                	callq  *%rax
			putch('x', putdat);
  8012f1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f9:	48 89 d6             	mov    %rdx,%rsi
  8012fc:	bf 78 00 00 00       	mov    $0x78,%edi
  801301:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801303:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801306:	83 f8 30             	cmp    $0x30,%eax
  801309:	73 17                	jae    801322 <vprintfmt+0x45a>
  80130b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80130f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801312:	89 c0                	mov    %eax,%eax
  801314:	48 01 d0             	add    %rdx,%rax
  801317:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80131a:	83 c2 08             	add    $0x8,%edx
  80131d:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801320:	eb 0f                	jmp    801331 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801322:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801326:	48 89 d0             	mov    %rdx,%rax
  801329:	48 83 c2 08          	add    $0x8,%rdx
  80132d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801331:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801334:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801338:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80133f:	eb 23                	jmp    801364 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801341:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801345:	be 03 00 00 00       	mov    $0x3,%esi
  80134a:	48 89 c7             	mov    %rax,%rdi
  80134d:	48 b8 a8 0c 80 00 00 	movabs $0x800ca8,%rax
  801354:	00 00 00 
  801357:	ff d0                	callq  *%rax
  801359:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80135d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801364:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801369:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80136c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80136f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801373:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801377:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80137b:	45 89 c1             	mov    %r8d,%r9d
  80137e:	41 89 f8             	mov    %edi,%r8d
  801381:	48 89 c7             	mov    %rax,%rdi
  801384:	48 b8 ed 0b 80 00 00 	movabs $0x800bed,%rax
  80138b:	00 00 00 
  80138e:	ff d0                	callq  *%rax
			break;
  801390:	eb 3f                	jmp    8013d1 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801392:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801396:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80139a:	48 89 d6             	mov    %rdx,%rsi
  80139d:	89 df                	mov    %ebx,%edi
  80139f:	ff d0                	callq  *%rax
			break;
  8013a1:	eb 2e                	jmp    8013d1 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8013a3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013a7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013ab:	48 89 d6             	mov    %rdx,%rsi
  8013ae:	bf 25 00 00 00       	mov    $0x25,%edi
  8013b3:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8013b5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013ba:	eb 05                	jmp    8013c1 <vprintfmt+0x4f9>
  8013bc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013c1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013c5:	48 83 e8 01          	sub    $0x1,%rax
  8013c9:	0f b6 00             	movzbl (%rax),%eax
  8013cc:	3c 25                	cmp    $0x25,%al
  8013ce:	75 ec                	jne    8013bc <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8013d0:	90                   	nop
		}
	}
  8013d1:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013d2:	e9 43 fb ff ff       	jmpq   800f1a <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8013d7:	48 83 c4 60          	add    $0x60,%rsp
  8013db:	5b                   	pop    %rbx
  8013dc:	41 5c                	pop    %r12
  8013de:	5d                   	pop    %rbp
  8013df:	c3                   	retq   

00000000008013e0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8013e0:	55                   	push   %rbp
  8013e1:	48 89 e5             	mov    %rsp,%rbp
  8013e4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8013eb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8013f2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8013f9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801400:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801407:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80140e:	84 c0                	test   %al,%al
  801410:	74 20                	je     801432 <printfmt+0x52>
  801412:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801416:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80141a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80141e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801422:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801426:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80142a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80142e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801432:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801439:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801440:	00 00 00 
  801443:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80144a:	00 00 00 
  80144d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801451:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801458:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80145f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801466:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80146d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801474:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80147b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801482:	48 89 c7             	mov    %rax,%rdi
  801485:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  80148c:	00 00 00 
  80148f:	ff d0                	callq  *%rax
	va_end(ap);
}
  801491:	c9                   	leaveq 
  801492:	c3                   	retq   

0000000000801493 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801493:	55                   	push   %rbp
  801494:	48 89 e5             	mov    %rsp,%rbp
  801497:	48 83 ec 10          	sub    $0x10,%rsp
  80149b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80149e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8014a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a6:	8b 40 10             	mov    0x10(%rax),%eax
  8014a9:	8d 50 01             	lea    0x1(%rax),%edx
  8014ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8014b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b7:	48 8b 10             	mov    (%rax),%rdx
  8014ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014be:	48 8b 40 08          	mov    0x8(%rax),%rax
  8014c2:	48 39 c2             	cmp    %rax,%rdx
  8014c5:	73 17                	jae    8014de <sprintputch+0x4b>
		*b->buf++ = ch;
  8014c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cb:	48 8b 00             	mov    (%rax),%rax
  8014ce:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8014d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8014d6:	48 89 0a             	mov    %rcx,(%rdx)
  8014d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8014dc:	88 10                	mov    %dl,(%rax)
}
  8014de:	c9                   	leaveq 
  8014df:	c3                   	retq   

00000000008014e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014e0:	55                   	push   %rbp
  8014e1:	48 89 e5             	mov    %rsp,%rbp
  8014e4:	48 83 ec 50          	sub    $0x50,%rsp
  8014e8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8014ec:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8014ef:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8014f3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8014f7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8014fb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8014ff:	48 8b 0a             	mov    (%rdx),%rcx
  801502:	48 89 08             	mov    %rcx,(%rax)
  801505:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801509:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80150d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801511:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801515:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801519:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80151d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801520:	48 98                	cltq   
  801522:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801526:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80152a:	48 01 d0             	add    %rdx,%rax
  80152d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801531:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801538:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80153d:	74 06                	je     801545 <vsnprintf+0x65>
  80153f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801543:	7f 07                	jg     80154c <vsnprintf+0x6c>
		return -E_INVAL;
  801545:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80154a:	eb 2f                	jmp    80157b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80154c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801550:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801554:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801558:	48 89 c6             	mov    %rax,%rsi
  80155b:	48 bf 93 14 80 00 00 	movabs $0x801493,%rdi
  801562:	00 00 00 
  801565:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  80156c:	00 00 00 
  80156f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801571:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801575:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801578:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80157b:	c9                   	leaveq 
  80157c:	c3                   	retq   

000000000080157d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80157d:	55                   	push   %rbp
  80157e:	48 89 e5             	mov    %rsp,%rbp
  801581:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801588:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80158f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801595:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80159c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015a3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8015aa:	84 c0                	test   %al,%al
  8015ac:	74 20                	je     8015ce <snprintf+0x51>
  8015ae:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015b2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015b6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015ba:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015be:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015c2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015c6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015ca:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8015ce:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8015d5:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8015dc:	00 00 00 
  8015df:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015e6:	00 00 00 
  8015e9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015ed:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8015f4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8015fb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801602:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801609:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801610:	48 8b 0a             	mov    (%rdx),%rcx
  801613:	48 89 08             	mov    %rcx,(%rax)
  801616:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80161a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80161e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801622:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801626:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80162d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801634:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80163a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801641:	48 89 c7             	mov    %rax,%rdi
  801644:	48 b8 e0 14 80 00 00 	movabs $0x8014e0,%rax
  80164b:	00 00 00 
  80164e:	ff d0                	callq  *%rax
  801650:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801656:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80165c:	c9                   	leaveq 
  80165d:	c3                   	retq   

000000000080165e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80165e:	55                   	push   %rbp
  80165f:	48 89 e5             	mov    %rsp,%rbp
  801662:	48 83 ec 18          	sub    $0x18,%rsp
  801666:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80166a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801671:	eb 09                	jmp    80167c <strlen+0x1e>
		n++;
  801673:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801677:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80167c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801680:	0f b6 00             	movzbl (%rax),%eax
  801683:	84 c0                	test   %al,%al
  801685:	75 ec                	jne    801673 <strlen+0x15>
		n++;
	return n;
  801687:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80168a:	c9                   	leaveq 
  80168b:	c3                   	retq   

000000000080168c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80168c:	55                   	push   %rbp
  80168d:	48 89 e5             	mov    %rsp,%rbp
  801690:	48 83 ec 20          	sub    $0x20,%rsp
  801694:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801698:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80169c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016a3:	eb 0e                	jmp    8016b3 <strnlen+0x27>
		n++;
  8016a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016a9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016ae:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8016b3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8016b8:	74 0b                	je     8016c5 <strnlen+0x39>
  8016ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016be:	0f b6 00             	movzbl (%rax),%eax
  8016c1:	84 c0                	test   %al,%al
  8016c3:	75 e0                	jne    8016a5 <strnlen+0x19>
		n++;
	return n;
  8016c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016c8:	c9                   	leaveq 
  8016c9:	c3                   	retq   

00000000008016ca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016ca:	55                   	push   %rbp
  8016cb:	48 89 e5             	mov    %rsp,%rbp
  8016ce:	48 83 ec 20          	sub    $0x20,%rsp
  8016d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8016da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8016e2:	90                   	nop
  8016e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8016ef:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8016f3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8016f7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8016fb:	0f b6 12             	movzbl (%rdx),%edx
  8016fe:	88 10                	mov    %dl,(%rax)
  801700:	0f b6 00             	movzbl (%rax),%eax
  801703:	84 c0                	test   %al,%al
  801705:	75 dc                	jne    8016e3 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80170b:	c9                   	leaveq 
  80170c:	c3                   	retq   

000000000080170d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80170d:	55                   	push   %rbp
  80170e:	48 89 e5             	mov    %rsp,%rbp
  801711:	48 83 ec 20          	sub    $0x20,%rsp
  801715:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801719:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80171d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801721:	48 89 c7             	mov    %rax,%rdi
  801724:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  80172b:	00 00 00 
  80172e:	ff d0                	callq  *%rax
  801730:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801733:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801736:	48 63 d0             	movslq %eax,%rdx
  801739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80173d:	48 01 c2             	add    %rax,%rdx
  801740:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801744:	48 89 c6             	mov    %rax,%rsi
  801747:	48 89 d7             	mov    %rdx,%rdi
  80174a:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  801751:	00 00 00 
  801754:	ff d0                	callq  *%rax
	return dst;
  801756:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80175a:	c9                   	leaveq 
  80175b:	c3                   	retq   

000000000080175c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80175c:	55                   	push   %rbp
  80175d:	48 89 e5             	mov    %rsp,%rbp
  801760:	48 83 ec 28          	sub    $0x28,%rsp
  801764:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801768:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80176c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801774:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801778:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80177f:	00 
  801780:	eb 2a                	jmp    8017ac <strncpy+0x50>
		*dst++ = *src;
  801782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801786:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80178a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80178e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801792:	0f b6 12             	movzbl (%rdx),%edx
  801795:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801797:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80179b:	0f b6 00             	movzbl (%rax),%eax
  80179e:	84 c0                	test   %al,%al
  8017a0:	74 05                	je     8017a7 <strncpy+0x4b>
			src++;
  8017a2:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017a7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8017b4:	72 cc                	jb     801782 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017ba:	c9                   	leaveq 
  8017bb:	c3                   	retq   

00000000008017bc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8017bc:	55                   	push   %rbp
  8017bd:	48 89 e5             	mov    %rsp,%rbp
  8017c0:	48 83 ec 28          	sub    $0x28,%rsp
  8017c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8017d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8017d8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017dd:	74 3d                	je     80181c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8017df:	eb 1d                	jmp    8017fe <strlcpy+0x42>
			*dst++ = *src++;
  8017e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017f1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8017f5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8017f9:	0f b6 12             	movzbl (%rdx),%edx
  8017fc:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8017fe:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801803:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801808:	74 0b                	je     801815 <strlcpy+0x59>
  80180a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80180e:	0f b6 00             	movzbl (%rax),%eax
  801811:	84 c0                	test   %al,%al
  801813:	75 cc                	jne    8017e1 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801819:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80181c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801820:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801824:	48 29 c2             	sub    %rax,%rdx
  801827:	48 89 d0             	mov    %rdx,%rax
}
  80182a:	c9                   	leaveq 
  80182b:	c3                   	retq   

000000000080182c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80182c:	55                   	push   %rbp
  80182d:	48 89 e5             	mov    %rsp,%rbp
  801830:	48 83 ec 10          	sub    $0x10,%rsp
  801834:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801838:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80183c:	eb 0a                	jmp    801848 <strcmp+0x1c>
		p++, q++;
  80183e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801843:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184c:	0f b6 00             	movzbl (%rax),%eax
  80184f:	84 c0                	test   %al,%al
  801851:	74 12                	je     801865 <strcmp+0x39>
  801853:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801857:	0f b6 10             	movzbl (%rax),%edx
  80185a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80185e:	0f b6 00             	movzbl (%rax),%eax
  801861:	38 c2                	cmp    %al,%dl
  801863:	74 d9                	je     80183e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801869:	0f b6 00             	movzbl (%rax),%eax
  80186c:	0f b6 d0             	movzbl %al,%edx
  80186f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801873:	0f b6 00             	movzbl (%rax),%eax
  801876:	0f b6 c0             	movzbl %al,%eax
  801879:	29 c2                	sub    %eax,%edx
  80187b:	89 d0                	mov    %edx,%eax
}
  80187d:	c9                   	leaveq 
  80187e:	c3                   	retq   

000000000080187f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80187f:	55                   	push   %rbp
  801880:	48 89 e5             	mov    %rsp,%rbp
  801883:	48 83 ec 18          	sub    $0x18,%rsp
  801887:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80188b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80188f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801893:	eb 0f                	jmp    8018a4 <strncmp+0x25>
		n--, p++, q++;
  801895:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80189a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80189f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8018a4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018a9:	74 1d                	je     8018c8 <strncmp+0x49>
  8018ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018af:	0f b6 00             	movzbl (%rax),%eax
  8018b2:	84 c0                	test   %al,%al
  8018b4:	74 12                	je     8018c8 <strncmp+0x49>
  8018b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ba:	0f b6 10             	movzbl (%rax),%edx
  8018bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c1:	0f b6 00             	movzbl (%rax),%eax
  8018c4:	38 c2                	cmp    %al,%dl
  8018c6:	74 cd                	je     801895 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8018c8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018cd:	75 07                	jne    8018d6 <strncmp+0x57>
		return 0;
  8018cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d4:	eb 18                	jmp    8018ee <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018da:	0f b6 00             	movzbl (%rax),%eax
  8018dd:	0f b6 d0             	movzbl %al,%edx
  8018e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e4:	0f b6 00             	movzbl (%rax),%eax
  8018e7:	0f b6 c0             	movzbl %al,%eax
  8018ea:	29 c2                	sub    %eax,%edx
  8018ec:	89 d0                	mov    %edx,%eax
}
  8018ee:	c9                   	leaveq 
  8018ef:	c3                   	retq   

00000000008018f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018f0:	55                   	push   %rbp
  8018f1:	48 89 e5             	mov    %rsp,%rbp
  8018f4:	48 83 ec 0c          	sub    $0xc,%rsp
  8018f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018fc:	89 f0                	mov    %esi,%eax
  8018fe:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801901:	eb 17                	jmp    80191a <strchr+0x2a>
		if (*s == c)
  801903:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801907:	0f b6 00             	movzbl (%rax),%eax
  80190a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80190d:	75 06                	jne    801915 <strchr+0x25>
			return (char *) s;
  80190f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801913:	eb 15                	jmp    80192a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801915:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80191a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191e:	0f b6 00             	movzbl (%rax),%eax
  801921:	84 c0                	test   %al,%al
  801923:	75 de                	jne    801903 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801925:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192a:	c9                   	leaveq 
  80192b:	c3                   	retq   

000000000080192c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80192c:	55                   	push   %rbp
  80192d:	48 89 e5             	mov    %rsp,%rbp
  801930:	48 83 ec 0c          	sub    $0xc,%rsp
  801934:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801938:	89 f0                	mov    %esi,%eax
  80193a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80193d:	eb 13                	jmp    801952 <strfind+0x26>
		if (*s == c)
  80193f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801943:	0f b6 00             	movzbl (%rax),%eax
  801946:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801949:	75 02                	jne    80194d <strfind+0x21>
			break;
  80194b:	eb 10                	jmp    80195d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80194d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801952:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801956:	0f b6 00             	movzbl (%rax),%eax
  801959:	84 c0                	test   %al,%al
  80195b:	75 e2                	jne    80193f <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80195d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801961:	c9                   	leaveq 
  801962:	c3                   	retq   

0000000000801963 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801963:	55                   	push   %rbp
  801964:	48 89 e5             	mov    %rsp,%rbp
  801967:	48 83 ec 18          	sub    $0x18,%rsp
  80196b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80196f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801972:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801976:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80197b:	75 06                	jne    801983 <memset+0x20>
		return v;
  80197d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801981:	eb 69                	jmp    8019ec <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801983:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801987:	83 e0 03             	and    $0x3,%eax
  80198a:	48 85 c0             	test   %rax,%rax
  80198d:	75 48                	jne    8019d7 <memset+0x74>
  80198f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801993:	83 e0 03             	and    $0x3,%eax
  801996:	48 85 c0             	test   %rax,%rax
  801999:	75 3c                	jne    8019d7 <memset+0x74>
		c &= 0xFF;
  80199b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8019a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019a5:	c1 e0 18             	shl    $0x18,%eax
  8019a8:	89 c2                	mov    %eax,%edx
  8019aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019ad:	c1 e0 10             	shl    $0x10,%eax
  8019b0:	09 c2                	or     %eax,%edx
  8019b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019b5:	c1 e0 08             	shl    $0x8,%eax
  8019b8:	09 d0                	or     %edx,%eax
  8019ba:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8019bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c1:	48 c1 e8 02          	shr    $0x2,%rax
  8019c5:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8019c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019cf:	48 89 d7             	mov    %rdx,%rdi
  8019d2:	fc                   	cld    
  8019d3:	f3 ab                	rep stos %eax,%es:(%rdi)
  8019d5:	eb 11                	jmp    8019e8 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8019d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019de:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019e2:	48 89 d7             	mov    %rdx,%rdi
  8019e5:	fc                   	cld    
  8019e6:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8019e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019ec:	c9                   	leaveq 
  8019ed:	c3                   	retq   

00000000008019ee <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019ee:	55                   	push   %rbp
  8019ef:	48 89 e5             	mov    %rsp,%rbp
  8019f2:	48 83 ec 28          	sub    $0x28,%rsp
  8019f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a0e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a16:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a1a:	0f 83 88 00 00 00    	jae    801aa8 <memmove+0xba>
  801a20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a28:	48 01 d0             	add    %rdx,%rax
  801a2b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a2f:	76 77                	jbe    801aa8 <memmove+0xba>
		s += n;
  801a31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a35:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a45:	83 e0 03             	and    $0x3,%eax
  801a48:	48 85 c0             	test   %rax,%rax
  801a4b:	75 3b                	jne    801a88 <memmove+0x9a>
  801a4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a51:	83 e0 03             	and    $0x3,%eax
  801a54:	48 85 c0             	test   %rax,%rax
  801a57:	75 2f                	jne    801a88 <memmove+0x9a>
  801a59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5d:	83 e0 03             	and    $0x3,%eax
  801a60:	48 85 c0             	test   %rax,%rax
  801a63:	75 23                	jne    801a88 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801a65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a69:	48 83 e8 04          	sub    $0x4,%rax
  801a6d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a71:	48 83 ea 04          	sub    $0x4,%rdx
  801a75:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801a79:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801a7d:	48 89 c7             	mov    %rax,%rdi
  801a80:	48 89 d6             	mov    %rdx,%rsi
  801a83:	fd                   	std    
  801a84:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801a86:	eb 1d                	jmp    801aa5 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801a88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a8c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a94:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801a98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9c:	48 89 d7             	mov    %rdx,%rdi
  801a9f:	48 89 c1             	mov    %rax,%rcx
  801aa2:	fd                   	std    
  801aa3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801aa5:	fc                   	cld    
  801aa6:	eb 57                	jmp    801aff <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801aa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aac:	83 e0 03             	and    $0x3,%eax
  801aaf:	48 85 c0             	test   %rax,%rax
  801ab2:	75 36                	jne    801aea <memmove+0xfc>
  801ab4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ab8:	83 e0 03             	and    $0x3,%eax
  801abb:	48 85 c0             	test   %rax,%rax
  801abe:	75 2a                	jne    801aea <memmove+0xfc>
  801ac0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac4:	83 e0 03             	and    $0x3,%eax
  801ac7:	48 85 c0             	test   %rax,%rax
  801aca:	75 1e                	jne    801aea <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801acc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad0:	48 c1 e8 02          	shr    $0x2,%rax
  801ad4:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801ad7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801adb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801adf:	48 89 c7             	mov    %rax,%rdi
  801ae2:	48 89 d6             	mov    %rdx,%rsi
  801ae5:	fc                   	cld    
  801ae6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ae8:	eb 15                	jmp    801aff <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801aea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801af2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801af6:	48 89 c7             	mov    %rax,%rdi
  801af9:	48 89 d6             	mov    %rdx,%rsi
  801afc:	fc                   	cld    
  801afd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b03:	c9                   	leaveq 
  801b04:	c3                   	retq   

0000000000801b05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b05:	55                   	push   %rbp
  801b06:	48 89 e5             	mov    %rsp,%rbp
  801b09:	48 83 ec 18          	sub    $0x18,%rsp
  801b0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b15:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b1d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b25:	48 89 ce             	mov    %rcx,%rsi
  801b28:	48 89 c7             	mov    %rax,%rdi
  801b2b:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  801b32:	00 00 00 
  801b35:	ff d0                	callq  *%rax
}
  801b37:	c9                   	leaveq 
  801b38:	c3                   	retq   

0000000000801b39 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b39:	55                   	push   %rbp
  801b3a:	48 89 e5             	mov    %rsp,%rbp
  801b3d:	48 83 ec 28          	sub    $0x28,%rsp
  801b41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b49:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b51:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801b55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b59:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801b5d:	eb 36                	jmp    801b95 <memcmp+0x5c>
		if (*s1 != *s2)
  801b5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b63:	0f b6 10             	movzbl (%rax),%edx
  801b66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b6a:	0f b6 00             	movzbl (%rax),%eax
  801b6d:	38 c2                	cmp    %al,%dl
  801b6f:	74 1a                	je     801b8b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801b71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b75:	0f b6 00             	movzbl (%rax),%eax
  801b78:	0f b6 d0             	movzbl %al,%edx
  801b7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b7f:	0f b6 00             	movzbl (%rax),%eax
  801b82:	0f b6 c0             	movzbl %al,%eax
  801b85:	29 c2                	sub    %eax,%edx
  801b87:	89 d0                	mov    %edx,%eax
  801b89:	eb 20                	jmp    801bab <memcmp+0x72>
		s1++, s2++;
  801b8b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b90:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801b95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b99:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801b9d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ba1:	48 85 c0             	test   %rax,%rax
  801ba4:	75 b9                	jne    801b5f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801ba6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bab:	c9                   	leaveq 
  801bac:	c3                   	retq   

0000000000801bad <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801bad:	55                   	push   %rbp
  801bae:	48 89 e5             	mov    %rsp,%rbp
  801bb1:	48 83 ec 28          	sub    $0x28,%rsp
  801bb5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801bbc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801bc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bc4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bc8:	48 01 d0             	add    %rdx,%rax
  801bcb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801bcf:	eb 15                	jmp    801be6 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd5:	0f b6 10             	movzbl (%rax),%edx
  801bd8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bdb:	38 c2                	cmp    %al,%dl
  801bdd:	75 02                	jne    801be1 <memfind+0x34>
			break;
  801bdf:	eb 0f                	jmp    801bf0 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801be1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801be6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bea:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801bee:	72 e1                	jb     801bd1 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801bf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bf4:	c9                   	leaveq 
  801bf5:	c3                   	retq   

0000000000801bf6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bf6:	55                   	push   %rbp
  801bf7:	48 89 e5             	mov    %rsp,%rbp
  801bfa:	48 83 ec 34          	sub    $0x34,%rsp
  801bfe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c02:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c06:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c10:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c17:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c18:	eb 05                	jmp    801c1f <strtol+0x29>
		s++;
  801c1a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c23:	0f b6 00             	movzbl (%rax),%eax
  801c26:	3c 20                	cmp    $0x20,%al
  801c28:	74 f0                	je     801c1a <strtol+0x24>
  801c2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2e:	0f b6 00             	movzbl (%rax),%eax
  801c31:	3c 09                	cmp    $0x9,%al
  801c33:	74 e5                	je     801c1a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c39:	0f b6 00             	movzbl (%rax),%eax
  801c3c:	3c 2b                	cmp    $0x2b,%al
  801c3e:	75 07                	jne    801c47 <strtol+0x51>
		s++;
  801c40:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c45:	eb 17                	jmp    801c5e <strtol+0x68>
	else if (*s == '-')
  801c47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4b:	0f b6 00             	movzbl (%rax),%eax
  801c4e:	3c 2d                	cmp    $0x2d,%al
  801c50:	75 0c                	jne    801c5e <strtol+0x68>
		s++, neg = 1;
  801c52:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c57:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c5e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c62:	74 06                	je     801c6a <strtol+0x74>
  801c64:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801c68:	75 28                	jne    801c92 <strtol+0x9c>
  801c6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c6e:	0f b6 00             	movzbl (%rax),%eax
  801c71:	3c 30                	cmp    $0x30,%al
  801c73:	75 1d                	jne    801c92 <strtol+0x9c>
  801c75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c79:	48 83 c0 01          	add    $0x1,%rax
  801c7d:	0f b6 00             	movzbl (%rax),%eax
  801c80:	3c 78                	cmp    $0x78,%al
  801c82:	75 0e                	jne    801c92 <strtol+0x9c>
		s += 2, base = 16;
  801c84:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801c89:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801c90:	eb 2c                	jmp    801cbe <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801c92:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c96:	75 19                	jne    801cb1 <strtol+0xbb>
  801c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9c:	0f b6 00             	movzbl (%rax),%eax
  801c9f:	3c 30                	cmp    $0x30,%al
  801ca1:	75 0e                	jne    801cb1 <strtol+0xbb>
		s++, base = 8;
  801ca3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ca8:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801caf:	eb 0d                	jmp    801cbe <strtol+0xc8>
	else if (base == 0)
  801cb1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cb5:	75 07                	jne    801cbe <strtol+0xc8>
		base = 10;
  801cb7:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc2:	0f b6 00             	movzbl (%rax),%eax
  801cc5:	3c 2f                	cmp    $0x2f,%al
  801cc7:	7e 1d                	jle    801ce6 <strtol+0xf0>
  801cc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ccd:	0f b6 00             	movzbl (%rax),%eax
  801cd0:	3c 39                	cmp    $0x39,%al
  801cd2:	7f 12                	jg     801ce6 <strtol+0xf0>
			dig = *s - '0';
  801cd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd8:	0f b6 00             	movzbl (%rax),%eax
  801cdb:	0f be c0             	movsbl %al,%eax
  801cde:	83 e8 30             	sub    $0x30,%eax
  801ce1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ce4:	eb 4e                	jmp    801d34 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801ce6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cea:	0f b6 00             	movzbl (%rax),%eax
  801ced:	3c 60                	cmp    $0x60,%al
  801cef:	7e 1d                	jle    801d0e <strtol+0x118>
  801cf1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf5:	0f b6 00             	movzbl (%rax),%eax
  801cf8:	3c 7a                	cmp    $0x7a,%al
  801cfa:	7f 12                	jg     801d0e <strtol+0x118>
			dig = *s - 'a' + 10;
  801cfc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d00:	0f b6 00             	movzbl (%rax),%eax
  801d03:	0f be c0             	movsbl %al,%eax
  801d06:	83 e8 57             	sub    $0x57,%eax
  801d09:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d0c:	eb 26                	jmp    801d34 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d12:	0f b6 00             	movzbl (%rax),%eax
  801d15:	3c 40                	cmp    $0x40,%al
  801d17:	7e 48                	jle    801d61 <strtol+0x16b>
  801d19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d1d:	0f b6 00             	movzbl (%rax),%eax
  801d20:	3c 5a                	cmp    $0x5a,%al
  801d22:	7f 3d                	jg     801d61 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801d24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d28:	0f b6 00             	movzbl (%rax),%eax
  801d2b:	0f be c0             	movsbl %al,%eax
  801d2e:	83 e8 37             	sub    $0x37,%eax
  801d31:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d37:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d3a:	7c 02                	jl     801d3e <strtol+0x148>
			break;
  801d3c:	eb 23                	jmp    801d61 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801d3e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d43:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d46:	48 98                	cltq   
  801d48:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801d4d:	48 89 c2             	mov    %rax,%rdx
  801d50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d53:	48 98                	cltq   
  801d55:	48 01 d0             	add    %rdx,%rax
  801d58:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801d5c:	e9 5d ff ff ff       	jmpq   801cbe <strtol+0xc8>

	if (endptr)
  801d61:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801d66:	74 0b                	je     801d73 <strtol+0x17d>
		*endptr = (char *) s;
  801d68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d6c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d70:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801d73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d77:	74 09                	je     801d82 <strtol+0x18c>
  801d79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d7d:	48 f7 d8             	neg    %rax
  801d80:	eb 04                	jmp    801d86 <strtol+0x190>
  801d82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801d86:	c9                   	leaveq 
  801d87:	c3                   	retq   

0000000000801d88 <strstr>:

char * strstr(const char *in, const char *str)
{
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
  801d8c:	48 83 ec 30          	sub    $0x30,%rsp
  801d90:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d94:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801d98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d9c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801da0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801da4:	0f b6 00             	movzbl (%rax),%eax
  801da7:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801daa:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801dae:	75 06                	jne    801db6 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801db0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db4:	eb 6b                	jmp    801e21 <strstr+0x99>

	len = strlen(str);
  801db6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dba:	48 89 c7             	mov    %rax,%rdi
  801dbd:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  801dc4:	00 00 00 
  801dc7:	ff d0                	callq  *%rax
  801dc9:	48 98                	cltq   
  801dcb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801dcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801dd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ddb:	0f b6 00             	movzbl (%rax),%eax
  801dde:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801de1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801de5:	75 07                	jne    801dee <strstr+0x66>
				return (char *) 0;
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dec:	eb 33                	jmp    801e21 <strstr+0x99>
		} while (sc != c);
  801dee:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801df2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801df5:	75 d8                	jne    801dcf <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801df7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dfb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801dff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e03:	48 89 ce             	mov    %rcx,%rsi
  801e06:	48 89 c7             	mov    %rax,%rdi
  801e09:	48 b8 7f 18 80 00 00 	movabs $0x80187f,%rax
  801e10:	00 00 00 
  801e13:	ff d0                	callq  *%rax
  801e15:	85 c0                	test   %eax,%eax
  801e17:	75 b6                	jne    801dcf <strstr+0x47>

	return (char *) (in - 1);
  801e19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e1d:	48 83 e8 01          	sub    $0x1,%rax
}
  801e21:	c9                   	leaveq 
  801e22:	c3                   	retq   

0000000000801e23 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e23:	55                   	push   %rbp
  801e24:	48 89 e5             	mov    %rsp,%rbp
  801e27:	53                   	push   %rbx
  801e28:	48 83 ec 48          	sub    $0x48,%rsp
  801e2c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e2f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e32:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e36:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e3a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e3e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e42:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e45:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e49:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801e4d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801e51:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801e55:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801e59:	4c 89 c3             	mov    %r8,%rbx
  801e5c:	cd 30                	int    $0x30
  801e5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801e62:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801e66:	74 3e                	je     801ea6 <syscall+0x83>
  801e68:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801e6d:	7e 37                	jle    801ea6 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801e6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e73:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e76:	49 89 d0             	mov    %rdx,%r8
  801e79:	89 c1                	mov    %eax,%ecx
  801e7b:	48 ba 88 56 80 00 00 	movabs $0x805688,%rdx
  801e82:	00 00 00 
  801e85:	be 23 00 00 00       	mov    $0x23,%esi
  801e8a:	48 bf a5 56 80 00 00 	movabs $0x8056a5,%rdi
  801e91:	00 00 00 
  801e94:	b8 00 00 00 00       	mov    $0x0,%eax
  801e99:	49 b9 dc 08 80 00 00 	movabs $0x8008dc,%r9
  801ea0:	00 00 00 
  801ea3:	41 ff d1             	callq  *%r9

	return ret;
  801ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801eaa:	48 83 c4 48          	add    $0x48,%rsp
  801eae:	5b                   	pop    %rbx
  801eaf:	5d                   	pop    %rbp
  801eb0:	c3                   	retq   

0000000000801eb1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801eb1:	55                   	push   %rbp
  801eb2:	48 89 e5             	mov    %rsp,%rbp
  801eb5:	48 83 ec 20          	sub    $0x20,%rsp
  801eb9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ebd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ec1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ec9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ed0:	00 
  801ed1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ed7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801edd:	48 89 d1             	mov    %rdx,%rcx
  801ee0:	48 89 c2             	mov    %rax,%rdx
  801ee3:	be 00 00 00 00       	mov    $0x0,%esi
  801ee8:	bf 00 00 00 00       	mov    $0x0,%edi
  801eed:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  801ef4:	00 00 00 
  801ef7:	ff d0                	callq  *%rax
}
  801ef9:	c9                   	leaveq 
  801efa:	c3                   	retq   

0000000000801efb <sys_cgetc>:

int
sys_cgetc(void)
{
  801efb:	55                   	push   %rbp
  801efc:	48 89 e5             	mov    %rsp,%rbp
  801eff:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f03:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f0a:	00 
  801f0b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f11:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f17:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f21:	be 00 00 00 00       	mov    $0x0,%esi
  801f26:	bf 01 00 00 00       	mov    $0x1,%edi
  801f2b:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  801f32:	00 00 00 
  801f35:	ff d0                	callq  *%rax
}
  801f37:	c9                   	leaveq 
  801f38:	c3                   	retq   

0000000000801f39 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f39:	55                   	push   %rbp
  801f3a:	48 89 e5             	mov    %rsp,%rbp
  801f3d:	48 83 ec 10          	sub    $0x10,%rsp
  801f41:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f47:	48 98                	cltq   
  801f49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f50:	00 
  801f51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f57:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f62:	48 89 c2             	mov    %rax,%rdx
  801f65:	be 01 00 00 00       	mov    $0x1,%esi
  801f6a:	bf 03 00 00 00       	mov    $0x3,%edi
  801f6f:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  801f76:	00 00 00 
  801f79:	ff d0                	callq  *%rax
}
  801f7b:	c9                   	leaveq 
  801f7c:	c3                   	retq   

0000000000801f7d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801f7d:	55                   	push   %rbp
  801f7e:	48 89 e5             	mov    %rsp,%rbp
  801f81:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801f85:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f8c:	00 
  801f8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f99:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa3:	be 00 00 00 00       	mov    $0x0,%esi
  801fa8:	bf 02 00 00 00       	mov    $0x2,%edi
  801fad:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  801fb4:	00 00 00 
  801fb7:	ff d0                	callq  *%rax
}
  801fb9:	c9                   	leaveq 
  801fba:	c3                   	retq   

0000000000801fbb <sys_yield>:

void
sys_yield(void)
{
  801fbb:	55                   	push   %rbp
  801fbc:	48 89 e5             	mov    %rsp,%rbp
  801fbf:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801fc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fca:	00 
  801fcb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fdc:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe1:	be 00 00 00 00       	mov    $0x0,%esi
  801fe6:	bf 0b 00 00 00       	mov    $0xb,%edi
  801feb:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  801ff2:	00 00 00 
  801ff5:	ff d0                	callq  *%rax
}
  801ff7:	c9                   	leaveq 
  801ff8:	c3                   	retq   

0000000000801ff9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801ff9:	55                   	push   %rbp
  801ffa:	48 89 e5             	mov    %rsp,%rbp
  801ffd:	48 83 ec 20          	sub    $0x20,%rsp
  802001:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802004:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802008:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80200b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80200e:	48 63 c8             	movslq %eax,%rcx
  802011:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802018:	48 98                	cltq   
  80201a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802021:	00 
  802022:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802028:	49 89 c8             	mov    %rcx,%r8
  80202b:	48 89 d1             	mov    %rdx,%rcx
  80202e:	48 89 c2             	mov    %rax,%rdx
  802031:	be 01 00 00 00       	mov    $0x1,%esi
  802036:	bf 04 00 00 00       	mov    $0x4,%edi
  80203b:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  802042:	00 00 00 
  802045:	ff d0                	callq  *%rax
}
  802047:	c9                   	leaveq 
  802048:	c3                   	retq   

0000000000802049 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802049:	55                   	push   %rbp
  80204a:	48 89 e5             	mov    %rsp,%rbp
  80204d:	48 83 ec 30          	sub    $0x30,%rsp
  802051:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802054:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802058:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80205b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80205f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802063:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802066:	48 63 c8             	movslq %eax,%rcx
  802069:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80206d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802070:	48 63 f0             	movslq %eax,%rsi
  802073:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207a:	48 98                	cltq   
  80207c:	48 89 0c 24          	mov    %rcx,(%rsp)
  802080:	49 89 f9             	mov    %rdi,%r9
  802083:	49 89 f0             	mov    %rsi,%r8
  802086:	48 89 d1             	mov    %rdx,%rcx
  802089:	48 89 c2             	mov    %rax,%rdx
  80208c:	be 01 00 00 00       	mov    $0x1,%esi
  802091:	bf 05 00 00 00       	mov    $0x5,%edi
  802096:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  80209d:	00 00 00 
  8020a0:	ff d0                	callq  *%rax
}
  8020a2:	c9                   	leaveq 
  8020a3:	c3                   	retq   

00000000008020a4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8020a4:	55                   	push   %rbp
  8020a5:	48 89 e5             	mov    %rsp,%rbp
  8020a8:	48 83 ec 20          	sub    $0x20,%rsp
  8020ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8020b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ba:	48 98                	cltq   
  8020bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020c3:	00 
  8020c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020d0:	48 89 d1             	mov    %rdx,%rcx
  8020d3:	48 89 c2             	mov    %rax,%rdx
  8020d6:	be 01 00 00 00       	mov    $0x1,%esi
  8020db:	bf 06 00 00 00       	mov    $0x6,%edi
  8020e0:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  8020e7:	00 00 00 
  8020ea:	ff d0                	callq  *%rax
}
  8020ec:	c9                   	leaveq 
  8020ed:	c3                   	retq   

00000000008020ee <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8020ee:	55                   	push   %rbp
  8020ef:	48 89 e5             	mov    %rsp,%rbp
  8020f2:	48 83 ec 10          	sub    $0x10,%rsp
  8020f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020f9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8020fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020ff:	48 63 d0             	movslq %eax,%rdx
  802102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802105:	48 98                	cltq   
  802107:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80210e:	00 
  80210f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802115:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80211b:	48 89 d1             	mov    %rdx,%rcx
  80211e:	48 89 c2             	mov    %rax,%rdx
  802121:	be 01 00 00 00       	mov    $0x1,%esi
  802126:	bf 08 00 00 00       	mov    $0x8,%edi
  80212b:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  802132:	00 00 00 
  802135:	ff d0                	callq  *%rax
}
  802137:	c9                   	leaveq 
  802138:	c3                   	retq   

0000000000802139 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802139:	55                   	push   %rbp
  80213a:	48 89 e5             	mov    %rsp,%rbp
  80213d:	48 83 ec 20          	sub    $0x20,%rsp
  802141:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802144:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802148:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80214c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214f:	48 98                	cltq   
  802151:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802158:	00 
  802159:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80215f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802165:	48 89 d1             	mov    %rdx,%rcx
  802168:	48 89 c2             	mov    %rax,%rdx
  80216b:	be 01 00 00 00       	mov    $0x1,%esi
  802170:	bf 09 00 00 00       	mov    $0x9,%edi
  802175:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  80217c:	00 00 00 
  80217f:	ff d0                	callq  *%rax
}
  802181:	c9                   	leaveq 
  802182:	c3                   	retq   

0000000000802183 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802183:	55                   	push   %rbp
  802184:	48 89 e5             	mov    %rsp,%rbp
  802187:	48 83 ec 20          	sub    $0x20,%rsp
  80218b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80218e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802192:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802196:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802199:	48 98                	cltq   
  80219b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021a2:	00 
  8021a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021af:	48 89 d1             	mov    %rdx,%rcx
  8021b2:	48 89 c2             	mov    %rax,%rdx
  8021b5:	be 01 00 00 00       	mov    $0x1,%esi
  8021ba:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021bf:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  8021c6:	00 00 00 
  8021c9:	ff d0                	callq  *%rax
}
  8021cb:	c9                   	leaveq 
  8021cc:	c3                   	retq   

00000000008021cd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8021cd:	55                   	push   %rbp
  8021ce:	48 89 e5             	mov    %rsp,%rbp
  8021d1:	48 83 ec 20          	sub    $0x20,%rsp
  8021d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8021e0:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8021e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021e6:	48 63 f0             	movslq %eax,%rsi
  8021e9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f0:	48 98                	cltq   
  8021f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021fd:	00 
  8021fe:	49 89 f1             	mov    %rsi,%r9
  802201:	49 89 c8             	mov    %rcx,%r8
  802204:	48 89 d1             	mov    %rdx,%rcx
  802207:	48 89 c2             	mov    %rax,%rdx
  80220a:	be 00 00 00 00       	mov    $0x0,%esi
  80220f:	bf 0c 00 00 00       	mov    $0xc,%edi
  802214:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	callq  *%rax
}
  802220:	c9                   	leaveq 
  802221:	c3                   	retq   

0000000000802222 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802222:	55                   	push   %rbp
  802223:	48 89 e5             	mov    %rsp,%rbp
  802226:	48 83 ec 10          	sub    $0x10,%rsp
  80222a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80222e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802232:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802239:	00 
  80223a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802240:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802246:	b9 00 00 00 00       	mov    $0x0,%ecx
  80224b:	48 89 c2             	mov    %rax,%rdx
  80224e:	be 01 00 00 00       	mov    $0x1,%esi
  802253:	bf 0d 00 00 00       	mov    $0xd,%edi
  802258:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  80225f:	00 00 00 
  802262:	ff d0                	callq  *%rax
}
  802264:	c9                   	leaveq 
  802265:	c3                   	retq   

0000000000802266 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802266:	55                   	push   %rbp
  802267:	48 89 e5             	mov    %rsp,%rbp
  80226a:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  80226e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802275:	00 
  802276:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80227c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802282:	b9 00 00 00 00       	mov    $0x0,%ecx
  802287:	ba 00 00 00 00       	mov    $0x0,%edx
  80228c:	be 00 00 00 00       	mov    $0x0,%esi
  802291:	bf 0e 00 00 00       	mov    $0xe,%edi
  802296:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  80229d:	00 00 00 
  8022a0:	ff d0                	callq  *%rax
}
  8022a2:	c9                   	leaveq 
  8022a3:	c3                   	retq   

00000000008022a4 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8022a4:	55                   	push   %rbp
  8022a5:	48 89 e5             	mov    %rsp,%rbp
  8022a8:	48 83 ec 30          	sub    $0x30,%rsp
  8022ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8022b3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8022b6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8022ba:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8022be:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022c1:	48 63 c8             	movslq %eax,%rcx
  8022c4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8022c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022cb:	48 63 f0             	movslq %eax,%rsi
  8022ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d5:	48 98                	cltq   
  8022d7:	48 89 0c 24          	mov    %rcx,(%rsp)
  8022db:	49 89 f9             	mov    %rdi,%r9
  8022de:	49 89 f0             	mov    %rsi,%r8
  8022e1:	48 89 d1             	mov    %rdx,%rcx
  8022e4:	48 89 c2             	mov    %rax,%rdx
  8022e7:	be 00 00 00 00       	mov    $0x0,%esi
  8022ec:	bf 0f 00 00 00       	mov    $0xf,%edi
  8022f1:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  8022f8:	00 00 00 
  8022fb:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8022fd:	c9                   	leaveq 
  8022fe:	c3                   	retq   

00000000008022ff <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8022ff:	55                   	push   %rbp
  802300:	48 89 e5             	mov    %rsp,%rbp
  802303:	48 83 ec 20          	sub    $0x20,%rsp
  802307:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80230b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80230f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802317:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80231e:	00 
  80231f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802325:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80232b:	48 89 d1             	mov    %rdx,%rcx
  80232e:	48 89 c2             	mov    %rax,%rdx
  802331:	be 00 00 00 00       	mov    $0x0,%esi
  802336:	bf 10 00 00 00       	mov    $0x10,%edi
  80233b:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  802342:	00 00 00 
  802345:	ff d0                	callq  *%rax
}
  802347:	c9                   	leaveq 
  802348:	c3                   	retq   

0000000000802349 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  802349:	55                   	push   %rbp
  80234a:	48 89 e5             	mov    %rsp,%rbp
  80234d:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  802351:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802358:	00 
  802359:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80235f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802365:	b9 00 00 00 00       	mov    $0x0,%ecx
  80236a:	ba 00 00 00 00       	mov    $0x0,%edx
  80236f:	be 00 00 00 00       	mov    $0x0,%esi
  802374:	bf 11 00 00 00       	mov    $0x11,%edi
  802379:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  802380:	00 00 00 
  802383:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  802385:	c9                   	leaveq 
  802386:	c3                   	retq   

0000000000802387 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  802387:	55                   	push   %rbp
  802388:	48 89 e5             	mov    %rsp,%rbp
  80238b:	48 83 ec 10          	sub    $0x10,%rsp
  80238f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  802392:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802395:	48 98                	cltq   
  802397:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80239e:	00 
  80239f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023b0:	48 89 c2             	mov    %rax,%rdx
  8023b3:	be 00 00 00 00       	mov    $0x0,%esi
  8023b8:	bf 12 00 00 00       	mov    $0x12,%edi
  8023bd:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  8023c4:	00 00 00 
  8023c7:	ff d0                	callq  *%rax
}
  8023c9:	c9                   	leaveq 
  8023ca:	c3                   	retq   

00000000008023cb <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  8023cb:	55                   	push   %rbp
  8023cc:	48 89 e5             	mov    %rsp,%rbp
  8023cf:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  8023d3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023da:	00 
  8023db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f1:	be 00 00 00 00       	mov    $0x0,%esi
  8023f6:	bf 13 00 00 00       	mov    $0x13,%edi
  8023fb:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  802402:	00 00 00 
  802405:	ff d0                	callq  *%rax
}
  802407:	c9                   	leaveq 
  802408:	c3                   	retq   

0000000000802409 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  802409:	55                   	push   %rbp
  80240a:	48 89 e5             	mov    %rsp,%rbp
  80240d:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802411:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802418:	00 
  802419:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80241f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802425:	b9 00 00 00 00       	mov    $0x0,%ecx
  80242a:	ba 00 00 00 00       	mov    $0x0,%edx
  80242f:	be 00 00 00 00       	mov    $0x0,%esi
  802434:	bf 14 00 00 00       	mov    $0x14,%edi
  802439:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
  802440:	00 00 00 
  802443:	ff d0                	callq  *%rax
}
  802445:	c9                   	leaveq 
  802446:	c3                   	retq   

0000000000802447 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802447:	55                   	push   %rbp
  802448:	48 89 e5             	mov    %rsp,%rbp
  80244b:	48 83 ec 30          	sub    $0x30,%rsp
  80244f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802457:	48 8b 00             	mov    (%rax),%rax
  80245a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80245e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802462:	48 8b 40 08          	mov    0x8(%rax),%rax
  802466:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  802469:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80246c:	83 e0 02             	and    $0x2,%eax
  80246f:	85 c0                	test   %eax,%eax
  802471:	75 4d                	jne    8024c0 <pgfault+0x79>
  802473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802477:	48 c1 e8 0c          	shr    $0xc,%rax
  80247b:	48 89 c2             	mov    %rax,%rdx
  80247e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802485:	01 00 00 
  802488:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80248c:	25 00 08 00 00       	and    $0x800,%eax
  802491:	48 85 c0             	test   %rax,%rax
  802494:	74 2a                	je     8024c0 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  802496:	48 ba b8 56 80 00 00 	movabs $0x8056b8,%rdx
  80249d:	00 00 00 
  8024a0:	be 23 00 00 00       	mov    $0x23,%esi
  8024a5:	48 bf ed 56 80 00 00 	movabs $0x8056ed,%rdi
  8024ac:	00 00 00 
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b4:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  8024bb:	00 00 00 
  8024be:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  8024c0:	ba 07 00 00 00       	mov    $0x7,%edx
  8024c5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8024cf:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8024d6:	00 00 00 
  8024d9:	ff d0                	callq  *%rax
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	0f 85 cd 00 00 00    	jne    8025b0 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  8024e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8024eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ef:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8024f5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  8024f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024fd:	ba 00 10 00 00       	mov    $0x1000,%edx
  802502:	48 89 c6             	mov    %rax,%rsi
  802505:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80250a:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  802511:	00 00 00 
  802514:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802516:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80251a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802520:	48 89 c1             	mov    %rax,%rcx
  802523:	ba 00 00 00 00       	mov    $0x0,%edx
  802528:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80252d:	bf 00 00 00 00       	mov    $0x0,%edi
  802532:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802539:	00 00 00 
  80253c:	ff d0                	callq  *%rax
  80253e:	85 c0                	test   %eax,%eax
  802540:	79 2a                	jns    80256c <pgfault+0x125>
				panic("Page map at temp address failed");
  802542:	48 ba f8 56 80 00 00 	movabs $0x8056f8,%rdx
  802549:	00 00 00 
  80254c:	be 30 00 00 00       	mov    $0x30,%esi
  802551:	48 bf ed 56 80 00 00 	movabs $0x8056ed,%rdi
  802558:	00 00 00 
  80255b:	b8 00 00 00 00       	mov    $0x0,%eax
  802560:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  802567:	00 00 00 
  80256a:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  80256c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802571:	bf 00 00 00 00       	mov    $0x0,%edi
  802576:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80257d:	00 00 00 
  802580:	ff d0                	callq  *%rax
  802582:	85 c0                	test   %eax,%eax
  802584:	79 54                	jns    8025da <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802586:	48 ba 18 57 80 00 00 	movabs $0x805718,%rdx
  80258d:	00 00 00 
  802590:	be 32 00 00 00       	mov    $0x32,%esi
  802595:	48 bf ed 56 80 00 00 	movabs $0x8056ed,%rdi
  80259c:	00 00 00 
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a4:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  8025ab:	00 00 00 
  8025ae:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  8025b0:	48 ba 40 57 80 00 00 	movabs $0x805740,%rdx
  8025b7:	00 00 00 
  8025ba:	be 34 00 00 00       	mov    $0x34,%esi
  8025bf:	48 bf ed 56 80 00 00 	movabs $0x8056ed,%rdi
  8025c6:	00 00 00 
  8025c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ce:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  8025d5:	00 00 00 
  8025d8:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8025da:	c9                   	leaveq 
  8025db:	c3                   	retq   

00000000008025dc <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8025dc:	55                   	push   %rbp
  8025dd:	48 89 e5             	mov    %rsp,%rbp
  8025e0:	48 83 ec 20          	sub    $0x20,%rsp
  8025e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025e7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8025ea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025f1:	01 00 00 
  8025f4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025fb:	25 07 0e 00 00       	and    $0xe07,%eax
  802600:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802603:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802606:	48 c1 e0 0c          	shl    $0xc,%rax
  80260a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  80260e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802611:	25 00 04 00 00       	and    $0x400,%eax
  802616:	85 c0                	test   %eax,%eax
  802618:	74 57                	je     802671 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80261a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80261d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802621:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802624:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802628:	41 89 f0             	mov    %esi,%r8d
  80262b:	48 89 c6             	mov    %rax,%rsi
  80262e:	bf 00 00 00 00       	mov    $0x0,%edi
  802633:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  80263a:	00 00 00 
  80263d:	ff d0                	callq  *%rax
  80263f:	85 c0                	test   %eax,%eax
  802641:	0f 8e 52 01 00 00    	jle    802799 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802647:	48 ba 72 57 80 00 00 	movabs $0x805772,%rdx
  80264e:	00 00 00 
  802651:	be 4e 00 00 00       	mov    $0x4e,%esi
  802656:	48 bf ed 56 80 00 00 	movabs $0x8056ed,%rdi
  80265d:	00 00 00 
  802660:	b8 00 00 00 00       	mov    $0x0,%eax
  802665:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  80266c:	00 00 00 
  80266f:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802671:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802674:	83 e0 02             	and    $0x2,%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	75 10                	jne    80268b <duppage+0xaf>
  80267b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267e:	25 00 08 00 00       	and    $0x800,%eax
  802683:	85 c0                	test   %eax,%eax
  802685:	0f 84 bb 00 00 00    	je     802746 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  80268b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80268e:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802693:	80 cc 08             	or     $0x8,%ah
  802696:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802699:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80269c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8026a0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8026a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a7:	41 89 f0             	mov    %esi,%r8d
  8026aa:	48 89 c6             	mov    %rax,%rsi
  8026ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b2:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	callq  *%rax
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	7e 2a                	jle    8026ec <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8026c2:	48 ba 72 57 80 00 00 	movabs $0x805772,%rdx
  8026c9:	00 00 00 
  8026cc:	be 55 00 00 00       	mov    $0x55,%esi
  8026d1:	48 bf ed 56 80 00 00 	movabs $0x8056ed,%rdi
  8026d8:	00 00 00 
  8026db:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e0:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  8026e7:	00 00 00 
  8026ea:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8026ec:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8026ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f7:	41 89 c8             	mov    %ecx,%r8d
  8026fa:	48 89 d1             	mov    %rdx,%rcx
  8026fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802702:	48 89 c6             	mov    %rax,%rsi
  802705:	bf 00 00 00 00       	mov    $0x0,%edi
  80270a:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802711:	00 00 00 
  802714:	ff d0                	callq  *%rax
  802716:	85 c0                	test   %eax,%eax
  802718:	7e 2a                	jle    802744 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80271a:	48 ba 72 57 80 00 00 	movabs $0x805772,%rdx
  802721:	00 00 00 
  802724:	be 57 00 00 00       	mov    $0x57,%esi
  802729:	48 bf ed 56 80 00 00 	movabs $0x8056ed,%rdi
  802730:	00 00 00 
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
  802738:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  80273f:	00 00 00 
  802742:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802744:	eb 53                	jmp    802799 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802746:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802749:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80274d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802750:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802754:	41 89 f0             	mov    %esi,%r8d
  802757:	48 89 c6             	mov    %rax,%rsi
  80275a:	bf 00 00 00 00       	mov    $0x0,%edi
  80275f:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802766:	00 00 00 
  802769:	ff d0                	callq  *%rax
  80276b:	85 c0                	test   %eax,%eax
  80276d:	7e 2a                	jle    802799 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80276f:	48 ba 72 57 80 00 00 	movabs $0x805772,%rdx
  802776:	00 00 00 
  802779:	be 5b 00 00 00       	mov    $0x5b,%esi
  80277e:	48 bf ed 56 80 00 00 	movabs $0x8056ed,%rdi
  802785:	00 00 00 
  802788:	b8 00 00 00 00       	mov    $0x0,%eax
  80278d:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  802794:	00 00 00 
  802797:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802799:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80279e:	c9                   	leaveq 
  80279f:	c3                   	retq   

00000000008027a0 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8027a0:	55                   	push   %rbp
  8027a1:	48 89 e5             	mov    %rsp,%rbp
  8027a4:	48 83 ec 18          	sub    $0x18,%rsp
  8027a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8027ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8027b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027b8:	48 c1 e8 27          	shr    $0x27,%rax
  8027bc:	48 89 c2             	mov    %rax,%rdx
  8027bf:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8027c6:	01 00 00 
  8027c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027cd:	83 e0 01             	and    $0x1,%eax
  8027d0:	48 85 c0             	test   %rax,%rax
  8027d3:	74 51                	je     802826 <pt_is_mapped+0x86>
  8027d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027d9:	48 c1 e0 0c          	shl    $0xc,%rax
  8027dd:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027e1:	48 89 c2             	mov    %rax,%rdx
  8027e4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8027eb:	01 00 00 
  8027ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f2:	83 e0 01             	and    $0x1,%eax
  8027f5:	48 85 c0             	test   %rax,%rax
  8027f8:	74 2c                	je     802826 <pt_is_mapped+0x86>
  8027fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027fe:	48 c1 e0 0c          	shl    $0xc,%rax
  802802:	48 c1 e8 15          	shr    $0x15,%rax
  802806:	48 89 c2             	mov    %rax,%rdx
  802809:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802810:	01 00 00 
  802813:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802817:	83 e0 01             	and    $0x1,%eax
  80281a:	48 85 c0             	test   %rax,%rax
  80281d:	74 07                	je     802826 <pt_is_mapped+0x86>
  80281f:	b8 01 00 00 00       	mov    $0x1,%eax
  802824:	eb 05                	jmp    80282b <pt_is_mapped+0x8b>
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
  80282b:	83 e0 01             	and    $0x1,%eax
}
  80282e:	c9                   	leaveq 
  80282f:	c3                   	retq   

0000000000802830 <fork>:

envid_t
fork(void)
{
  802830:	55                   	push   %rbp
  802831:	48 89 e5             	mov    %rsp,%rbp
  802834:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802838:	48 bf 47 24 80 00 00 	movabs $0x802447,%rdi
  80283f:	00 00 00 
  802842:	48 b8 54 4c 80 00 00 	movabs $0x804c54,%rax
  802849:	00 00 00 
  80284c:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80284e:	b8 07 00 00 00       	mov    $0x7,%eax
  802853:	cd 30                	int    $0x30
  802855:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802858:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80285b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80285e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802862:	79 30                	jns    802894 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802864:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802867:	89 c1                	mov    %eax,%ecx
  802869:	48 ba 90 57 80 00 00 	movabs $0x805790,%rdx
  802870:	00 00 00 
  802873:	be 86 00 00 00       	mov    $0x86,%esi
  802878:	48 bf ed 56 80 00 00 	movabs $0x8056ed,%rdi
  80287f:	00 00 00 
  802882:	b8 00 00 00 00       	mov    $0x0,%eax
  802887:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  80288e:	00 00 00 
  802891:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802894:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802898:	75 3e                	jne    8028d8 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80289a:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  8028a1:	00 00 00 
  8028a4:	ff d0                	callq  *%rax
  8028a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8028ab:	48 98                	cltq   
  8028ad:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8028b4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8028bb:	00 00 00 
  8028be:	48 01 c2             	add    %rax,%rdx
  8028c1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8028c8:	00 00 00 
  8028cb:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8028ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d3:	e9 d1 01 00 00       	jmpq   802aa9 <fork+0x279>
	}
	uint64_t ad = 0;
  8028d8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8028df:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8028e0:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8028e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8028e9:	e9 df 00 00 00       	jmpq   8029cd <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8028ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028f2:	48 c1 e8 27          	shr    $0x27,%rax
  8028f6:	48 89 c2             	mov    %rax,%rdx
  8028f9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802900:	01 00 00 
  802903:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802907:	83 e0 01             	and    $0x1,%eax
  80290a:	48 85 c0             	test   %rax,%rax
  80290d:	0f 84 9e 00 00 00    	je     8029b1 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802913:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802917:	48 c1 e8 1e          	shr    $0x1e,%rax
  80291b:	48 89 c2             	mov    %rax,%rdx
  80291e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802925:	01 00 00 
  802928:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292c:	83 e0 01             	and    $0x1,%eax
  80292f:	48 85 c0             	test   %rax,%rax
  802932:	74 73                	je     8029a7 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  802934:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802938:	48 c1 e8 15          	shr    $0x15,%rax
  80293c:	48 89 c2             	mov    %rax,%rdx
  80293f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802946:	01 00 00 
  802949:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294d:	83 e0 01             	and    $0x1,%eax
  802950:	48 85 c0             	test   %rax,%rax
  802953:	74 48                	je     80299d <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802955:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802959:	48 c1 e8 0c          	shr    $0xc,%rax
  80295d:	48 89 c2             	mov    %rax,%rdx
  802960:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802967:	01 00 00 
  80296a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802972:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802976:	83 e0 01             	and    $0x1,%eax
  802979:	48 85 c0             	test   %rax,%rax
  80297c:	74 47                	je     8029c5 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80297e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802982:	48 c1 e8 0c          	shr    $0xc,%rax
  802986:	89 c2                	mov    %eax,%edx
  802988:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80298b:	89 d6                	mov    %edx,%esi
  80298d:	89 c7                	mov    %eax,%edi
  80298f:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  802996:	00 00 00 
  802999:	ff d0                	callq  *%rax
  80299b:	eb 28                	jmp    8029c5 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80299d:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8029a4:	00 
  8029a5:	eb 1e                	jmp    8029c5 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8029a7:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8029ae:	40 
  8029af:	eb 14                	jmp    8029c5 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8029b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029b5:	48 c1 e8 27          	shr    $0x27,%rax
  8029b9:	48 83 c0 01          	add    $0x1,%rax
  8029bd:	48 c1 e0 27          	shl    $0x27,%rax
  8029c1:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8029c5:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8029cc:	00 
  8029cd:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8029d4:	00 
  8029d5:	0f 87 13 ff ff ff    	ja     8028ee <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8029db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029de:	ba 07 00 00 00       	mov    $0x7,%edx
  8029e3:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8029e8:	89 c7                	mov    %eax,%edi
  8029ea:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8029f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029f9:	ba 07 00 00 00       	mov    $0x7,%edx
  8029fe:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802a03:	89 c7                	mov    %eax,%edi
  802a05:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  802a0c:	00 00 00 
  802a0f:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802a11:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a14:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802a1a:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a24:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802a29:	89 c7                	mov    %eax,%edi
  802a2b:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802a32:	00 00 00 
  802a35:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802a37:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a3c:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802a41:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802a46:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  802a4d:	00 00 00 
  802a50:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802a52:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802a57:	bf 00 00 00 00       	mov    $0x0,%edi
  802a5c:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802a68:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a6f:	00 00 00 
  802a72:	48 8b 00             	mov    (%rax),%rax
  802a75:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802a7c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a7f:	48 89 d6             	mov    %rdx,%rsi
  802a82:	89 c7                	mov    %eax,%edi
  802a84:	48 b8 83 21 80 00 00 	movabs $0x802183,%rax
  802a8b:	00 00 00 
  802a8e:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802a90:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a93:	be 02 00 00 00       	mov    $0x2,%esi
  802a98:	89 c7                	mov    %eax,%edi
  802a9a:	48 b8 ee 20 80 00 00 	movabs $0x8020ee,%rax
  802aa1:	00 00 00 
  802aa4:	ff d0                	callq  *%rax

	return envid;
  802aa6:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802aa9:	c9                   	leaveq 
  802aaa:	c3                   	retq   

0000000000802aab <sfork>:

	
// Challenge!
int
sfork(void)
{
  802aab:	55                   	push   %rbp
  802aac:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802aaf:	48 ba a8 57 80 00 00 	movabs $0x8057a8,%rdx
  802ab6:	00 00 00 
  802ab9:	be bf 00 00 00       	mov    $0xbf,%esi
  802abe:	48 bf ed 56 80 00 00 	movabs $0x8056ed,%rdi
  802ac5:	00 00 00 
  802ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  802acd:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  802ad4:	00 00 00 
  802ad7:	ff d1                	callq  *%rcx

0000000000802ad9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802ad9:	55                   	push   %rbp
  802ada:	48 89 e5             	mov    %rsp,%rbp
  802add:	48 83 ec 08          	sub    $0x8,%rsp
  802ae1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802ae5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ae9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802af0:	ff ff ff 
  802af3:	48 01 d0             	add    %rdx,%rax
  802af6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802afa:	c9                   	leaveq 
  802afb:	c3                   	retq   

0000000000802afc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802afc:	55                   	push   %rbp
  802afd:	48 89 e5             	mov    %rsp,%rbp
  802b00:	48 83 ec 08          	sub    $0x8,%rsp
  802b04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802b08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b0c:	48 89 c7             	mov    %rax,%rdi
  802b0f:	48 b8 d9 2a 80 00 00 	movabs $0x802ad9,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
  802b1b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802b21:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802b25:	c9                   	leaveq 
  802b26:	c3                   	retq   

0000000000802b27 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802b27:	55                   	push   %rbp
  802b28:	48 89 e5             	mov    %rsp,%rbp
  802b2b:	48 83 ec 18          	sub    $0x18,%rsp
  802b2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b3a:	eb 6b                	jmp    802ba7 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3f:	48 98                	cltq   
  802b41:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b47:	48 c1 e0 0c          	shl    $0xc,%rax
  802b4b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802b4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b53:	48 c1 e8 15          	shr    $0x15,%rax
  802b57:	48 89 c2             	mov    %rax,%rdx
  802b5a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b61:	01 00 00 
  802b64:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b68:	83 e0 01             	and    $0x1,%eax
  802b6b:	48 85 c0             	test   %rax,%rax
  802b6e:	74 21                	je     802b91 <fd_alloc+0x6a>
  802b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b74:	48 c1 e8 0c          	shr    $0xc,%rax
  802b78:	48 89 c2             	mov    %rax,%rdx
  802b7b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b82:	01 00 00 
  802b85:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b89:	83 e0 01             	and    $0x1,%eax
  802b8c:	48 85 c0             	test   %rax,%rax
  802b8f:	75 12                	jne    802ba3 <fd_alloc+0x7c>
			*fd_store = fd;
  802b91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b99:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba1:	eb 1a                	jmp    802bbd <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802ba3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ba7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802bab:	7e 8f                	jle    802b3c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802bb8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802bbd:	c9                   	leaveq 
  802bbe:	c3                   	retq   

0000000000802bbf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802bbf:	55                   	push   %rbp
  802bc0:	48 89 e5             	mov    %rsp,%rbp
  802bc3:	48 83 ec 20          	sub    $0x20,%rsp
  802bc7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802bce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bd2:	78 06                	js     802bda <fd_lookup+0x1b>
  802bd4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802bd8:	7e 07                	jle    802be1 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802bda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bdf:	eb 6c                	jmp    802c4d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802be1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802be4:	48 98                	cltq   
  802be6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802bec:	48 c1 e0 0c          	shl    $0xc,%rax
  802bf0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802bf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bf8:	48 c1 e8 15          	shr    $0x15,%rax
  802bfc:	48 89 c2             	mov    %rax,%rdx
  802bff:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c06:	01 00 00 
  802c09:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c0d:	83 e0 01             	and    $0x1,%eax
  802c10:	48 85 c0             	test   %rax,%rax
  802c13:	74 21                	je     802c36 <fd_lookup+0x77>
  802c15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c19:	48 c1 e8 0c          	shr    $0xc,%rax
  802c1d:	48 89 c2             	mov    %rax,%rdx
  802c20:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c27:	01 00 00 
  802c2a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c2e:	83 e0 01             	and    $0x1,%eax
  802c31:	48 85 c0             	test   %rax,%rax
  802c34:	75 07                	jne    802c3d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802c36:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c3b:	eb 10                	jmp    802c4d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802c3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c41:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c45:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c4d:	c9                   	leaveq 
  802c4e:	c3                   	retq   

0000000000802c4f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802c4f:	55                   	push   %rbp
  802c50:	48 89 e5             	mov    %rsp,%rbp
  802c53:	48 83 ec 30          	sub    $0x30,%rsp
  802c57:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c5b:	89 f0                	mov    %esi,%eax
  802c5d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c64:	48 89 c7             	mov    %rax,%rdi
  802c67:	48 b8 d9 2a 80 00 00 	movabs $0x802ad9,%rax
  802c6e:	00 00 00 
  802c71:	ff d0                	callq  *%rax
  802c73:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c77:	48 89 d6             	mov    %rdx,%rsi
  802c7a:	89 c7                	mov    %eax,%edi
  802c7c:	48 b8 bf 2b 80 00 00 	movabs $0x802bbf,%rax
  802c83:	00 00 00 
  802c86:	ff d0                	callq  *%rax
  802c88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8f:	78 0a                	js     802c9b <fd_close+0x4c>
	    || fd != fd2)
  802c91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c95:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802c99:	74 12                	je     802cad <fd_close+0x5e>
		return (must_exist ? r : 0);
  802c9b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802c9f:	74 05                	je     802ca6 <fd_close+0x57>
  802ca1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca4:	eb 05                	jmp    802cab <fd_close+0x5c>
  802ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cab:	eb 69                	jmp    802d16 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802cad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb1:	8b 00                	mov    (%rax),%eax
  802cb3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cb7:	48 89 d6             	mov    %rdx,%rsi
  802cba:	89 c7                	mov    %eax,%edi
  802cbc:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  802cc3:	00 00 00 
  802cc6:	ff d0                	callq  *%rax
  802cc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ccb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ccf:	78 2a                	js     802cfb <fd_close+0xac>
		if (dev->dev_close)
  802cd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd5:	48 8b 40 20          	mov    0x20(%rax),%rax
  802cd9:	48 85 c0             	test   %rax,%rax
  802cdc:	74 16                	je     802cf4 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802cde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce2:	48 8b 40 20          	mov    0x20(%rax),%rax
  802ce6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cea:	48 89 d7             	mov    %rdx,%rdi
  802ced:	ff d0                	callq  *%rax
  802cef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf2:	eb 07                	jmp    802cfb <fd_close+0xac>
		else
			r = 0;
  802cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802cfb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cff:	48 89 c6             	mov    %rax,%rsi
  802d02:	bf 00 00 00 00       	mov    $0x0,%edi
  802d07:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802d0e:	00 00 00 
  802d11:	ff d0                	callq  *%rax
	return r;
  802d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d16:	c9                   	leaveq 
  802d17:	c3                   	retq   

0000000000802d18 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802d18:	55                   	push   %rbp
  802d19:	48 89 e5             	mov    %rsp,%rbp
  802d1c:	48 83 ec 20          	sub    $0x20,%rsp
  802d20:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802d27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d2e:	eb 41                	jmp    802d71 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802d30:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802d37:	00 00 00 
  802d3a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d3d:	48 63 d2             	movslq %edx,%rdx
  802d40:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d44:	8b 00                	mov    (%rax),%eax
  802d46:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802d49:	75 22                	jne    802d6d <dev_lookup+0x55>
			*dev = devtab[i];
  802d4b:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802d52:	00 00 00 
  802d55:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d58:	48 63 d2             	movslq %edx,%rdx
  802d5b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802d5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d63:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802d66:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6b:	eb 60                	jmp    802dcd <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802d6d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d71:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802d78:	00 00 00 
  802d7b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d7e:	48 63 d2             	movslq %edx,%rdx
  802d81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d85:	48 85 c0             	test   %rax,%rax
  802d88:	75 a6                	jne    802d30 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802d8a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d91:	00 00 00 
  802d94:	48 8b 00             	mov    (%rax),%rax
  802d97:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d9d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802da0:	89 c6                	mov    %eax,%esi
  802da2:	48 bf c0 57 80 00 00 	movabs $0x8057c0,%rdi
  802da9:	00 00 00 
  802dac:	b8 00 00 00 00       	mov    $0x0,%eax
  802db1:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  802db8:	00 00 00 
  802dbb:	ff d1                	callq  *%rcx
	*dev = 0;
  802dbd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dc1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802dc8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802dcd:	c9                   	leaveq 
  802dce:	c3                   	retq   

0000000000802dcf <close>:

int
close(int fdnum)
{
  802dcf:	55                   	push   %rbp
  802dd0:	48 89 e5             	mov    %rsp,%rbp
  802dd3:	48 83 ec 20          	sub    $0x20,%rsp
  802dd7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802dda:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dde:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802de1:	48 89 d6             	mov    %rdx,%rsi
  802de4:	89 c7                	mov    %eax,%edi
  802de6:	48 b8 bf 2b 80 00 00 	movabs $0x802bbf,%rax
  802ded:	00 00 00 
  802df0:	ff d0                	callq  *%rax
  802df2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df9:	79 05                	jns    802e00 <close+0x31>
		return r;
  802dfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfe:	eb 18                	jmp    802e18 <close+0x49>
	else
		return fd_close(fd, 1);
  802e00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e04:	be 01 00 00 00       	mov    $0x1,%esi
  802e09:	48 89 c7             	mov    %rax,%rdi
  802e0c:	48 b8 4f 2c 80 00 00 	movabs $0x802c4f,%rax
  802e13:	00 00 00 
  802e16:	ff d0                	callq  *%rax
}
  802e18:	c9                   	leaveq 
  802e19:	c3                   	retq   

0000000000802e1a <close_all>:

void
close_all(void)
{
  802e1a:	55                   	push   %rbp
  802e1b:	48 89 e5             	mov    %rsp,%rbp
  802e1e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802e22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e29:	eb 15                	jmp    802e40 <close_all+0x26>
		close(i);
  802e2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2e:	89 c7                	mov    %eax,%edi
  802e30:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  802e37:	00 00 00 
  802e3a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802e3c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e40:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802e44:	7e e5                	jle    802e2b <close_all+0x11>
		close(i);
}
  802e46:	c9                   	leaveq 
  802e47:	c3                   	retq   

0000000000802e48 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802e48:	55                   	push   %rbp
  802e49:	48 89 e5             	mov    %rsp,%rbp
  802e4c:	48 83 ec 40          	sub    $0x40,%rsp
  802e50:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802e53:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802e56:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802e5a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802e5d:	48 89 d6             	mov    %rdx,%rsi
  802e60:	89 c7                	mov    %eax,%edi
  802e62:	48 b8 bf 2b 80 00 00 	movabs $0x802bbf,%rax
  802e69:	00 00 00 
  802e6c:	ff d0                	callq  *%rax
  802e6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e75:	79 08                	jns    802e7f <dup+0x37>
		return r;
  802e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7a:	e9 70 01 00 00       	jmpq   802fef <dup+0x1a7>
	close(newfdnum);
  802e7f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e82:	89 c7                	mov    %eax,%edi
  802e84:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  802e8b:	00 00 00 
  802e8e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802e90:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e93:	48 98                	cltq   
  802e95:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e9b:	48 c1 e0 0c          	shl    $0xc,%rax
  802e9f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802ea3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ea7:	48 89 c7             	mov    %rax,%rdi
  802eaa:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  802eb1:	00 00 00 
  802eb4:	ff d0                	callq  *%rax
  802eb6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802eba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ebe:	48 89 c7             	mov    %rax,%rdi
  802ec1:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  802ec8:	00 00 00 
  802ecb:	ff d0                	callq  *%rax
  802ecd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802ed1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed5:	48 c1 e8 15          	shr    $0x15,%rax
  802ed9:	48 89 c2             	mov    %rax,%rdx
  802edc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ee3:	01 00 00 
  802ee6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802eea:	83 e0 01             	and    $0x1,%eax
  802eed:	48 85 c0             	test   %rax,%rax
  802ef0:	74 73                	je     802f65 <dup+0x11d>
  802ef2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef6:	48 c1 e8 0c          	shr    $0xc,%rax
  802efa:	48 89 c2             	mov    %rax,%rdx
  802efd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f04:	01 00 00 
  802f07:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f0b:	83 e0 01             	and    $0x1,%eax
  802f0e:	48 85 c0             	test   %rax,%rax
  802f11:	74 52                	je     802f65 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802f13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f17:	48 c1 e8 0c          	shr    $0xc,%rax
  802f1b:	48 89 c2             	mov    %rax,%rdx
  802f1e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f25:	01 00 00 
  802f28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f2c:	25 07 0e 00 00       	and    $0xe07,%eax
  802f31:	89 c1                	mov    %eax,%ecx
  802f33:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3b:	41 89 c8             	mov    %ecx,%r8d
  802f3e:	48 89 d1             	mov    %rdx,%rcx
  802f41:	ba 00 00 00 00       	mov    $0x0,%edx
  802f46:	48 89 c6             	mov    %rax,%rsi
  802f49:	bf 00 00 00 00       	mov    $0x0,%edi
  802f4e:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802f55:	00 00 00 
  802f58:	ff d0                	callq  *%rax
  802f5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f61:	79 02                	jns    802f65 <dup+0x11d>
			goto err;
  802f63:	eb 57                	jmp    802fbc <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f69:	48 c1 e8 0c          	shr    $0xc,%rax
  802f6d:	48 89 c2             	mov    %rax,%rdx
  802f70:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f77:	01 00 00 
  802f7a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f7e:	25 07 0e 00 00       	and    $0xe07,%eax
  802f83:	89 c1                	mov    %eax,%ecx
  802f85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f8d:	41 89 c8             	mov    %ecx,%r8d
  802f90:	48 89 d1             	mov    %rdx,%rcx
  802f93:	ba 00 00 00 00       	mov    $0x0,%edx
  802f98:	48 89 c6             	mov    %rax,%rsi
  802f9b:	bf 00 00 00 00       	mov    $0x0,%edi
  802fa0:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802fa7:	00 00 00 
  802faa:	ff d0                	callq  *%rax
  802fac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802faf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb3:	79 02                	jns    802fb7 <dup+0x16f>
		goto err;
  802fb5:	eb 05                	jmp    802fbc <dup+0x174>

	return newfdnum;
  802fb7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802fba:	eb 33                	jmp    802fef <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc0:	48 89 c6             	mov    %rax,%rsi
  802fc3:	bf 00 00 00 00       	mov    $0x0,%edi
  802fc8:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802fcf:	00 00 00 
  802fd2:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802fd4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd8:	48 89 c6             	mov    %rax,%rsi
  802fdb:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe0:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802fe7:	00 00 00 
  802fea:	ff d0                	callq  *%rax
	return r;
  802fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fef:	c9                   	leaveq 
  802ff0:	c3                   	retq   

0000000000802ff1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ff1:	55                   	push   %rbp
  802ff2:	48 89 e5             	mov    %rsp,%rbp
  802ff5:	48 83 ec 40          	sub    $0x40,%rsp
  802ff9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ffc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803000:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803004:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803008:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80300b:	48 89 d6             	mov    %rdx,%rsi
  80300e:	89 c7                	mov    %eax,%edi
  803010:	48 b8 bf 2b 80 00 00 	movabs $0x802bbf,%rax
  803017:	00 00 00 
  80301a:	ff d0                	callq  *%rax
  80301c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80301f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803023:	78 24                	js     803049 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803029:	8b 00                	mov    (%rax),%eax
  80302b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80302f:	48 89 d6             	mov    %rdx,%rsi
  803032:	89 c7                	mov    %eax,%edi
  803034:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  80303b:	00 00 00 
  80303e:	ff d0                	callq  *%rax
  803040:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803043:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803047:	79 05                	jns    80304e <read+0x5d>
		return r;
  803049:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304c:	eb 76                	jmp    8030c4 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80304e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803052:	8b 40 08             	mov    0x8(%rax),%eax
  803055:	83 e0 03             	and    $0x3,%eax
  803058:	83 f8 01             	cmp    $0x1,%eax
  80305b:	75 3a                	jne    803097 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80305d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803064:	00 00 00 
  803067:	48 8b 00             	mov    (%rax),%rax
  80306a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803070:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803073:	89 c6                	mov    %eax,%esi
  803075:	48 bf df 57 80 00 00 	movabs $0x8057df,%rdi
  80307c:	00 00 00 
  80307f:	b8 00 00 00 00       	mov    $0x0,%eax
  803084:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  80308b:	00 00 00 
  80308e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803090:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803095:	eb 2d                	jmp    8030c4 <read+0xd3>
	}
	if (!dev->dev_read)
  803097:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80309f:	48 85 c0             	test   %rax,%rax
  8030a2:	75 07                	jne    8030ab <read+0xba>
		return -E_NOT_SUPP;
  8030a4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030a9:	eb 19                	jmp    8030c4 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8030ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030af:	48 8b 40 10          	mov    0x10(%rax),%rax
  8030b3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030b7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030bb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8030bf:	48 89 cf             	mov    %rcx,%rdi
  8030c2:	ff d0                	callq  *%rax
}
  8030c4:	c9                   	leaveq 
  8030c5:	c3                   	retq   

00000000008030c6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8030c6:	55                   	push   %rbp
  8030c7:	48 89 e5             	mov    %rsp,%rbp
  8030ca:	48 83 ec 30          	sub    $0x30,%rsp
  8030ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8030d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8030e0:	eb 49                	jmp    80312b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8030e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e5:	48 98                	cltq   
  8030e7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030eb:	48 29 c2             	sub    %rax,%rdx
  8030ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f1:	48 63 c8             	movslq %eax,%rcx
  8030f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f8:	48 01 c1             	add    %rax,%rcx
  8030fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030fe:	48 89 ce             	mov    %rcx,%rsi
  803101:	89 c7                	mov    %eax,%edi
  803103:	48 b8 f1 2f 80 00 00 	movabs $0x802ff1,%rax
  80310a:	00 00 00 
  80310d:	ff d0                	callq  *%rax
  80310f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803112:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803116:	79 05                	jns    80311d <readn+0x57>
			return m;
  803118:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80311b:	eb 1c                	jmp    803139 <readn+0x73>
		if (m == 0)
  80311d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803121:	75 02                	jne    803125 <readn+0x5f>
			break;
  803123:	eb 11                	jmp    803136 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803125:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803128:	01 45 fc             	add    %eax,-0x4(%rbp)
  80312b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312e:	48 98                	cltq   
  803130:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803134:	72 ac                	jb     8030e2 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803136:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803139:	c9                   	leaveq 
  80313a:	c3                   	retq   

000000000080313b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80313b:	55                   	push   %rbp
  80313c:	48 89 e5             	mov    %rsp,%rbp
  80313f:	48 83 ec 40          	sub    $0x40,%rsp
  803143:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803146:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80314a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80314e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803152:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803155:	48 89 d6             	mov    %rdx,%rsi
  803158:	89 c7                	mov    %eax,%edi
  80315a:	48 b8 bf 2b 80 00 00 	movabs $0x802bbf,%rax
  803161:	00 00 00 
  803164:	ff d0                	callq  *%rax
  803166:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803169:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316d:	78 24                	js     803193 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80316f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803173:	8b 00                	mov    (%rax),%eax
  803175:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803179:	48 89 d6             	mov    %rdx,%rsi
  80317c:	89 c7                	mov    %eax,%edi
  80317e:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  803185:	00 00 00 
  803188:	ff d0                	callq  *%rax
  80318a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80318d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803191:	79 05                	jns    803198 <write+0x5d>
		return r;
  803193:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803196:	eb 42                	jmp    8031da <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803198:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319c:	8b 40 08             	mov    0x8(%rax),%eax
  80319f:	83 e0 03             	and    $0x3,%eax
  8031a2:	85 c0                	test   %eax,%eax
  8031a4:	75 07                	jne    8031ad <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8031a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031ab:	eb 2d                	jmp    8031da <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8031ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8031b5:	48 85 c0             	test   %rax,%rax
  8031b8:	75 07                	jne    8031c1 <write+0x86>
		return -E_NOT_SUPP;
  8031ba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031bf:	eb 19                	jmp    8031da <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8031c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8031c9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031cd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8031d1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8031d5:	48 89 cf             	mov    %rcx,%rdi
  8031d8:	ff d0                	callq  *%rax
}
  8031da:	c9                   	leaveq 
  8031db:	c3                   	retq   

00000000008031dc <seek>:

int
seek(int fdnum, off_t offset)
{
  8031dc:	55                   	push   %rbp
  8031dd:	48 89 e5             	mov    %rsp,%rbp
  8031e0:	48 83 ec 18          	sub    $0x18,%rsp
  8031e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031e7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031ea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031f1:	48 89 d6             	mov    %rdx,%rsi
  8031f4:	89 c7                	mov    %eax,%edi
  8031f6:	48 b8 bf 2b 80 00 00 	movabs $0x802bbf,%rax
  8031fd:	00 00 00 
  803200:	ff d0                	callq  *%rax
  803202:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803205:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803209:	79 05                	jns    803210 <seek+0x34>
		return r;
  80320b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320e:	eb 0f                	jmp    80321f <seek+0x43>
	fd->fd_offset = offset;
  803210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803214:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803217:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80321a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80321f:	c9                   	leaveq 
  803220:	c3                   	retq   

0000000000803221 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803221:	55                   	push   %rbp
  803222:	48 89 e5             	mov    %rsp,%rbp
  803225:	48 83 ec 30          	sub    $0x30,%rsp
  803229:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80322c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80322f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803233:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803236:	48 89 d6             	mov    %rdx,%rsi
  803239:	89 c7                	mov    %eax,%edi
  80323b:	48 b8 bf 2b 80 00 00 	movabs $0x802bbf,%rax
  803242:	00 00 00 
  803245:	ff d0                	callq  *%rax
  803247:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80324a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80324e:	78 24                	js     803274 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803250:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803254:	8b 00                	mov    (%rax),%eax
  803256:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80325a:	48 89 d6             	mov    %rdx,%rsi
  80325d:	89 c7                	mov    %eax,%edi
  80325f:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  803266:	00 00 00 
  803269:	ff d0                	callq  *%rax
  80326b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80326e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803272:	79 05                	jns    803279 <ftruncate+0x58>
		return r;
  803274:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803277:	eb 72                	jmp    8032eb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803279:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80327d:	8b 40 08             	mov    0x8(%rax),%eax
  803280:	83 e0 03             	and    $0x3,%eax
  803283:	85 c0                	test   %eax,%eax
  803285:	75 3a                	jne    8032c1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803287:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80328e:	00 00 00 
  803291:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803294:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80329a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80329d:	89 c6                	mov    %eax,%esi
  80329f:	48 bf 00 58 80 00 00 	movabs $0x805800,%rdi
  8032a6:	00 00 00 
  8032a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ae:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  8032b5:	00 00 00 
  8032b8:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8032ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8032bf:	eb 2a                	jmp    8032eb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8032c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032c9:	48 85 c0             	test   %rax,%rax
  8032cc:	75 07                	jne    8032d5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8032ce:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032d3:	eb 16                	jmp    8032eb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8032d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032e1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8032e4:	89 ce                	mov    %ecx,%esi
  8032e6:	48 89 d7             	mov    %rdx,%rdi
  8032e9:	ff d0                	callq  *%rax
}
  8032eb:	c9                   	leaveq 
  8032ec:	c3                   	retq   

00000000008032ed <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8032ed:	55                   	push   %rbp
  8032ee:	48 89 e5             	mov    %rsp,%rbp
  8032f1:	48 83 ec 30          	sub    $0x30,%rsp
  8032f5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8032f8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8032fc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803300:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803303:	48 89 d6             	mov    %rdx,%rsi
  803306:	89 c7                	mov    %eax,%edi
  803308:	48 b8 bf 2b 80 00 00 	movabs $0x802bbf,%rax
  80330f:	00 00 00 
  803312:	ff d0                	callq  *%rax
  803314:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803317:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80331b:	78 24                	js     803341 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80331d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803321:	8b 00                	mov    (%rax),%eax
  803323:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803327:	48 89 d6             	mov    %rdx,%rsi
  80332a:	89 c7                	mov    %eax,%edi
  80332c:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  803333:	00 00 00 
  803336:	ff d0                	callq  *%rax
  803338:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80333b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80333f:	79 05                	jns    803346 <fstat+0x59>
		return r;
  803341:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803344:	eb 5e                	jmp    8033a4 <fstat+0xb7>
	if (!dev->dev_stat)
  803346:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80334a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80334e:	48 85 c0             	test   %rax,%rax
  803351:	75 07                	jne    80335a <fstat+0x6d>
		return -E_NOT_SUPP;
  803353:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803358:	eb 4a                	jmp    8033a4 <fstat+0xb7>
	stat->st_name[0] = 0;
  80335a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80335e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803361:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803365:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80336c:	00 00 00 
	stat->st_isdir = 0;
  80336f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803373:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80337a:	00 00 00 
	stat->st_dev = dev;
  80337d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803381:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803385:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80338c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803390:	48 8b 40 28          	mov    0x28(%rax),%rax
  803394:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803398:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80339c:	48 89 ce             	mov    %rcx,%rsi
  80339f:	48 89 d7             	mov    %rdx,%rdi
  8033a2:	ff d0                	callq  *%rax
}
  8033a4:	c9                   	leaveq 
  8033a5:	c3                   	retq   

00000000008033a6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8033a6:	55                   	push   %rbp
  8033a7:	48 89 e5             	mov    %rsp,%rbp
  8033aa:	48 83 ec 20          	sub    $0x20,%rsp
  8033ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8033b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ba:	be 00 00 00 00       	mov    $0x0,%esi
  8033bf:	48 89 c7             	mov    %rax,%rdi
  8033c2:	48 b8 94 34 80 00 00 	movabs $0x803494,%rax
  8033c9:	00 00 00 
  8033cc:	ff d0                	callq  *%rax
  8033ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d5:	79 05                	jns    8033dc <stat+0x36>
		return fd;
  8033d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033da:	eb 2f                	jmp    80340b <stat+0x65>
	r = fstat(fd, stat);
  8033dc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e3:	48 89 d6             	mov    %rdx,%rsi
  8033e6:	89 c7                	mov    %eax,%edi
  8033e8:	48 b8 ed 32 80 00 00 	movabs $0x8032ed,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
  8033f4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8033f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fa:	89 c7                	mov    %eax,%edi
  8033fc:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  803403:	00 00 00 
  803406:	ff d0                	callq  *%rax
	return r;
  803408:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80340b:	c9                   	leaveq 
  80340c:	c3                   	retq   

000000000080340d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80340d:	55                   	push   %rbp
  80340e:	48 89 e5             	mov    %rsp,%rbp
  803411:	48 83 ec 10          	sub    $0x10,%rsp
  803415:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803418:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80341c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803423:	00 00 00 
  803426:	8b 00                	mov    (%rax),%eax
  803428:	85 c0                	test   %eax,%eax
  80342a:	75 1d                	jne    803449 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80342c:	bf 01 00 00 00       	mov    $0x1,%edi
  803431:	48 b8 1a 4f 80 00 00 	movabs $0x804f1a,%rax
  803438:	00 00 00 
  80343b:	ff d0                	callq  *%rax
  80343d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803444:	00 00 00 
  803447:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803449:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803450:	00 00 00 
  803453:	8b 00                	mov    (%rax),%eax
  803455:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803458:	b9 07 00 00 00       	mov    $0x7,%ecx
  80345d:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803464:	00 00 00 
  803467:	89 c7                	mov    %eax,%edi
  803469:	48 b8 92 4e 80 00 00 	movabs $0x804e92,%rax
  803470:	00 00 00 
  803473:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803475:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803479:	ba 00 00 00 00       	mov    $0x0,%edx
  80347e:	48 89 c6             	mov    %rax,%rsi
  803481:	bf 00 00 00 00       	mov    $0x0,%edi
  803486:	48 b8 94 4d 80 00 00 	movabs $0x804d94,%rax
  80348d:	00 00 00 
  803490:	ff d0                	callq  *%rax
}
  803492:	c9                   	leaveq 
  803493:	c3                   	retq   

0000000000803494 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803494:	55                   	push   %rbp
  803495:	48 89 e5             	mov    %rsp,%rbp
  803498:	48 83 ec 30          	sub    $0x30,%rsp
  80349c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034a0:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8034a3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8034aa:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8034b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8034b8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8034bd:	75 08                	jne    8034c7 <open+0x33>
	{
		return r;
  8034bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c2:	e9 f2 00 00 00       	jmpq   8035b9 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8034c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034cb:	48 89 c7             	mov    %rax,%rdi
  8034ce:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  8034d5:	00 00 00 
  8034d8:	ff d0                	callq  *%rax
  8034da:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8034dd:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8034e4:	7e 0a                	jle    8034f0 <open+0x5c>
	{
		return -E_BAD_PATH;
  8034e6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034eb:	e9 c9 00 00 00       	jmpq   8035b9 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8034f0:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8034f7:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8034f8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8034fc:	48 89 c7             	mov    %rax,%rdi
  8034ff:	48 b8 27 2b 80 00 00 	movabs $0x802b27,%rax
  803506:	00 00 00 
  803509:	ff d0                	callq  *%rax
  80350b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80350e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803512:	78 09                	js     80351d <open+0x89>
  803514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803518:	48 85 c0             	test   %rax,%rax
  80351b:	75 08                	jne    803525 <open+0x91>
		{
			return r;
  80351d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803520:	e9 94 00 00 00       	jmpq   8035b9 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803529:	ba 00 04 00 00       	mov    $0x400,%edx
  80352e:	48 89 c6             	mov    %rax,%rsi
  803531:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803538:	00 00 00 
  80353b:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  803542:	00 00 00 
  803545:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803547:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80354e:	00 00 00 
  803551:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803554:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80355a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355e:	48 89 c6             	mov    %rax,%rsi
  803561:	bf 01 00 00 00       	mov    $0x1,%edi
  803566:	48 b8 0d 34 80 00 00 	movabs $0x80340d,%rax
  80356d:	00 00 00 
  803570:	ff d0                	callq  *%rax
  803572:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803575:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803579:	79 2b                	jns    8035a6 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80357b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357f:	be 00 00 00 00       	mov    $0x0,%esi
  803584:	48 89 c7             	mov    %rax,%rdi
  803587:	48 b8 4f 2c 80 00 00 	movabs $0x802c4f,%rax
  80358e:	00 00 00 
  803591:	ff d0                	callq  *%rax
  803593:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803596:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80359a:	79 05                	jns    8035a1 <open+0x10d>
			{
				return d;
  80359c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80359f:	eb 18                	jmp    8035b9 <open+0x125>
			}
			return r;
  8035a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a4:	eb 13                	jmp    8035b9 <open+0x125>
		}	
		return fd2num(fd_store);
  8035a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035aa:	48 89 c7             	mov    %rax,%rdi
  8035ad:	48 b8 d9 2a 80 00 00 	movabs $0x802ad9,%rax
  8035b4:	00 00 00 
  8035b7:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8035b9:	c9                   	leaveq 
  8035ba:	c3                   	retq   

00000000008035bb <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8035bb:	55                   	push   %rbp
  8035bc:	48 89 e5             	mov    %rsp,%rbp
  8035bf:	48 83 ec 10          	sub    $0x10,%rsp
  8035c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8035c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035cb:	8b 50 0c             	mov    0xc(%rax),%edx
  8035ce:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035d5:	00 00 00 
  8035d8:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8035da:	be 00 00 00 00       	mov    $0x0,%esi
  8035df:	bf 06 00 00 00       	mov    $0x6,%edi
  8035e4:	48 b8 0d 34 80 00 00 	movabs $0x80340d,%rax
  8035eb:	00 00 00 
  8035ee:	ff d0                	callq  *%rax
}
  8035f0:	c9                   	leaveq 
  8035f1:	c3                   	retq   

00000000008035f2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8035f2:	55                   	push   %rbp
  8035f3:	48 89 e5             	mov    %rsp,%rbp
  8035f6:	48 83 ec 30          	sub    $0x30,%rsp
  8035fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803602:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803606:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80360d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803612:	74 07                	je     80361b <devfile_read+0x29>
  803614:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803619:	75 07                	jne    803622 <devfile_read+0x30>
		return -E_INVAL;
  80361b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803620:	eb 77                	jmp    803699 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803626:	8b 50 0c             	mov    0xc(%rax),%edx
  803629:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803630:	00 00 00 
  803633:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803635:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80363c:	00 00 00 
  80363f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803643:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803647:	be 00 00 00 00       	mov    $0x0,%esi
  80364c:	bf 03 00 00 00       	mov    $0x3,%edi
  803651:	48 b8 0d 34 80 00 00 	movabs $0x80340d,%rax
  803658:	00 00 00 
  80365b:	ff d0                	callq  *%rax
  80365d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803660:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803664:	7f 05                	jg     80366b <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803666:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803669:	eb 2e                	jmp    803699 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80366b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366e:	48 63 d0             	movslq %eax,%rdx
  803671:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803675:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80367c:	00 00 00 
  80367f:	48 89 c7             	mov    %rax,%rdi
  803682:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  803689:	00 00 00 
  80368c:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80368e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803692:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803696:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803699:	c9                   	leaveq 
  80369a:	c3                   	retq   

000000000080369b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80369b:	55                   	push   %rbp
  80369c:	48 89 e5             	mov    %rsp,%rbp
  80369f:	48 83 ec 30          	sub    $0x30,%rsp
  8036a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8036af:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8036b6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036bb:	74 07                	je     8036c4 <devfile_write+0x29>
  8036bd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8036c2:	75 08                	jne    8036cc <devfile_write+0x31>
		return r;
  8036c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c7:	e9 9a 00 00 00       	jmpq   803766 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8036cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d0:	8b 50 0c             	mov    0xc(%rax),%edx
  8036d3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036da:	00 00 00 
  8036dd:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8036df:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8036e6:	00 
  8036e7:	76 08                	jbe    8036f1 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8036e9:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8036f0:	00 
	}
	fsipcbuf.write.req_n = n;
  8036f1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036f8:	00 00 00 
  8036fb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8036ff:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803703:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803707:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80370b:	48 89 c6             	mov    %rax,%rsi
  80370e:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803715:	00 00 00 
  803718:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  80371f:	00 00 00 
  803722:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803724:	be 00 00 00 00       	mov    $0x0,%esi
  803729:	bf 04 00 00 00       	mov    $0x4,%edi
  80372e:	48 b8 0d 34 80 00 00 	movabs $0x80340d,%rax
  803735:	00 00 00 
  803738:	ff d0                	callq  *%rax
  80373a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80373d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803741:	7f 20                	jg     803763 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803743:	48 bf 26 58 80 00 00 	movabs $0x805826,%rdi
  80374a:	00 00 00 
  80374d:	b8 00 00 00 00       	mov    $0x0,%eax
  803752:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  803759:	00 00 00 
  80375c:	ff d2                	callq  *%rdx
		return r;
  80375e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803761:	eb 03                	jmp    803766 <devfile_write+0xcb>
	}
	return r;
  803763:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803766:	c9                   	leaveq 
  803767:	c3                   	retq   

0000000000803768 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803768:	55                   	push   %rbp
  803769:	48 89 e5             	mov    %rsp,%rbp
  80376c:	48 83 ec 20          	sub    $0x20,%rsp
  803770:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803774:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80377c:	8b 50 0c             	mov    0xc(%rax),%edx
  80377f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803786:	00 00 00 
  803789:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80378b:	be 00 00 00 00       	mov    $0x0,%esi
  803790:	bf 05 00 00 00       	mov    $0x5,%edi
  803795:	48 b8 0d 34 80 00 00 	movabs $0x80340d,%rax
  80379c:	00 00 00 
  80379f:	ff d0                	callq  *%rax
  8037a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a8:	79 05                	jns    8037af <devfile_stat+0x47>
		return r;
  8037aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ad:	eb 56                	jmp    803805 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8037af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b3:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8037ba:	00 00 00 
  8037bd:	48 89 c7             	mov    %rax,%rdi
  8037c0:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  8037c7:	00 00 00 
  8037ca:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8037cc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037d3:	00 00 00 
  8037d6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8037dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8037e6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037ed:	00 00 00 
  8037f0:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8037f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037fa:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803800:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803805:	c9                   	leaveq 
  803806:	c3                   	retq   

0000000000803807 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803807:	55                   	push   %rbp
  803808:	48 89 e5             	mov    %rsp,%rbp
  80380b:	48 83 ec 10          	sub    $0x10,%rsp
  80380f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803813:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803816:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80381a:	8b 50 0c             	mov    0xc(%rax),%edx
  80381d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803824:	00 00 00 
  803827:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803829:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803830:	00 00 00 
  803833:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803836:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803839:	be 00 00 00 00       	mov    $0x0,%esi
  80383e:	bf 02 00 00 00       	mov    $0x2,%edi
  803843:	48 b8 0d 34 80 00 00 	movabs $0x80340d,%rax
  80384a:	00 00 00 
  80384d:	ff d0                	callq  *%rax
}
  80384f:	c9                   	leaveq 
  803850:	c3                   	retq   

0000000000803851 <remove>:

// Delete a file
int
remove(const char *path)
{
  803851:	55                   	push   %rbp
  803852:	48 89 e5             	mov    %rsp,%rbp
  803855:	48 83 ec 10          	sub    $0x10,%rsp
  803859:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80385d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803861:	48 89 c7             	mov    %rax,%rdi
  803864:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  80386b:	00 00 00 
  80386e:	ff d0                	callq  *%rax
  803870:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803875:	7e 07                	jle    80387e <remove+0x2d>
		return -E_BAD_PATH;
  803877:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80387c:	eb 33                	jmp    8038b1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80387e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803882:	48 89 c6             	mov    %rax,%rsi
  803885:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80388c:	00 00 00 
  80388f:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80389b:	be 00 00 00 00       	mov    $0x0,%esi
  8038a0:	bf 07 00 00 00       	mov    $0x7,%edi
  8038a5:	48 b8 0d 34 80 00 00 	movabs $0x80340d,%rax
  8038ac:	00 00 00 
  8038af:	ff d0                	callq  *%rax
}
  8038b1:	c9                   	leaveq 
  8038b2:	c3                   	retq   

00000000008038b3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8038b3:	55                   	push   %rbp
  8038b4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8038b7:	be 00 00 00 00       	mov    $0x0,%esi
  8038bc:	bf 08 00 00 00       	mov    $0x8,%edi
  8038c1:	48 b8 0d 34 80 00 00 	movabs $0x80340d,%rax
  8038c8:	00 00 00 
  8038cb:	ff d0                	callq  *%rax
}
  8038cd:	5d                   	pop    %rbp
  8038ce:	c3                   	retq   

00000000008038cf <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8038cf:	55                   	push   %rbp
  8038d0:	48 89 e5             	mov    %rsp,%rbp
  8038d3:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8038da:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8038e1:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8038e8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8038ef:	be 00 00 00 00       	mov    $0x0,%esi
  8038f4:	48 89 c7             	mov    %rax,%rdi
  8038f7:	48 b8 94 34 80 00 00 	movabs $0x803494,%rax
  8038fe:	00 00 00 
  803901:	ff d0                	callq  *%rax
  803903:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803906:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80390a:	79 28                	jns    803934 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80390c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80390f:	89 c6                	mov    %eax,%esi
  803911:	48 bf 42 58 80 00 00 	movabs $0x805842,%rdi
  803918:	00 00 00 
  80391b:	b8 00 00 00 00       	mov    $0x0,%eax
  803920:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  803927:	00 00 00 
  80392a:	ff d2                	callq  *%rdx
		return fd_src;
  80392c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80392f:	e9 74 01 00 00       	jmpq   803aa8 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803934:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80393b:	be 01 01 00 00       	mov    $0x101,%esi
  803940:	48 89 c7             	mov    %rax,%rdi
  803943:	48 b8 94 34 80 00 00 	movabs $0x803494,%rax
  80394a:	00 00 00 
  80394d:	ff d0                	callq  *%rax
  80394f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803952:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803956:	79 39                	jns    803991 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803958:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80395b:	89 c6                	mov    %eax,%esi
  80395d:	48 bf 58 58 80 00 00 	movabs $0x805858,%rdi
  803964:	00 00 00 
  803967:	b8 00 00 00 00       	mov    $0x0,%eax
  80396c:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  803973:	00 00 00 
  803976:	ff d2                	callq  *%rdx
		close(fd_src);
  803978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397b:	89 c7                	mov    %eax,%edi
  80397d:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  803984:	00 00 00 
  803987:	ff d0                	callq  *%rax
		return fd_dest;
  803989:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80398c:	e9 17 01 00 00       	jmpq   803aa8 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803991:	eb 74                	jmp    803a07 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803993:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803996:	48 63 d0             	movslq %eax,%rdx
  803999:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8039a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039a3:	48 89 ce             	mov    %rcx,%rsi
  8039a6:	89 c7                	mov    %eax,%edi
  8039a8:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  8039af:	00 00 00 
  8039b2:	ff d0                	callq  *%rax
  8039b4:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8039b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8039bb:	79 4a                	jns    803a07 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8039bd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8039c0:	89 c6                	mov    %eax,%esi
  8039c2:	48 bf 72 58 80 00 00 	movabs $0x805872,%rdi
  8039c9:	00 00 00 
  8039cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d1:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  8039d8:	00 00 00 
  8039db:	ff d2                	callq  *%rdx
			close(fd_src);
  8039dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e0:	89 c7                	mov    %eax,%edi
  8039e2:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  8039e9:	00 00 00 
  8039ec:	ff d0                	callq  *%rax
			close(fd_dest);
  8039ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039f1:	89 c7                	mov    %eax,%edi
  8039f3:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  8039fa:	00 00 00 
  8039fd:	ff d0                	callq  *%rax
			return write_size;
  8039ff:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a02:	e9 a1 00 00 00       	jmpq   803aa8 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803a07:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a11:	ba 00 02 00 00       	mov    $0x200,%edx
  803a16:	48 89 ce             	mov    %rcx,%rsi
  803a19:	89 c7                	mov    %eax,%edi
  803a1b:	48 b8 f1 2f 80 00 00 	movabs $0x802ff1,%rax
  803a22:	00 00 00 
  803a25:	ff d0                	callq  *%rax
  803a27:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803a2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803a2e:	0f 8f 5f ff ff ff    	jg     803993 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803a34:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803a38:	79 47                	jns    803a81 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803a3a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a3d:	89 c6                	mov    %eax,%esi
  803a3f:	48 bf 85 58 80 00 00 	movabs $0x805885,%rdi
  803a46:	00 00 00 
  803a49:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4e:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  803a55:	00 00 00 
  803a58:	ff d2                	callq  *%rdx
		close(fd_src);
  803a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5d:	89 c7                	mov    %eax,%edi
  803a5f:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
		close(fd_dest);
  803a6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a6e:	89 c7                	mov    %eax,%edi
  803a70:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  803a77:	00 00 00 
  803a7a:	ff d0                	callq  *%rax
		return read_size;
  803a7c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a7f:	eb 27                	jmp    803aa8 <copy+0x1d9>
	}
	close(fd_src);
  803a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a84:	89 c7                	mov    %eax,%edi
  803a86:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  803a8d:	00 00 00 
  803a90:	ff d0                	callq  *%rax
	close(fd_dest);
  803a92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a95:	89 c7                	mov    %eax,%edi
  803a97:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  803a9e:	00 00 00 
  803aa1:	ff d0                	callq  *%rax
	return 0;
  803aa3:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803aa8:	c9                   	leaveq 
  803aa9:	c3                   	retq   

0000000000803aaa <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803aaa:	55                   	push   %rbp
  803aab:	48 89 e5             	mov    %rsp,%rbp
  803aae:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803ab5:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803abc:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803ac3:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803aca:	be 00 00 00 00       	mov    $0x0,%esi
  803acf:	48 89 c7             	mov    %rax,%rdi
  803ad2:	48 b8 94 34 80 00 00 	movabs $0x803494,%rax
  803ad9:	00 00 00 
  803adc:	ff d0                	callq  *%rax
  803ade:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803ae1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803ae5:	79 08                	jns    803aef <spawn+0x45>
		return r;
  803ae7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803aea:	e9 0c 03 00 00       	jmpq   803dfb <spawn+0x351>
	fd = r;
  803aef:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803af2:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803af5:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803afc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803b00:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803b07:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803b0a:	ba 00 02 00 00       	mov    $0x200,%edx
  803b0f:	48 89 ce             	mov    %rcx,%rsi
  803b12:	89 c7                	mov    %eax,%edi
  803b14:	48 b8 c6 30 80 00 00 	movabs $0x8030c6,%rax
  803b1b:	00 00 00 
  803b1e:	ff d0                	callq  *%rax
  803b20:	3d 00 02 00 00       	cmp    $0x200,%eax
  803b25:	75 0d                	jne    803b34 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803b27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b2b:	8b 00                	mov    (%rax),%eax
  803b2d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803b32:	74 43                	je     803b77 <spawn+0xcd>
		close(fd);
  803b34:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803b37:	89 c7                	mov    %eax,%edi
  803b39:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  803b40:	00 00 00 
  803b43:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803b45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b49:	8b 00                	mov    (%rax),%eax
  803b4b:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803b50:	89 c6                	mov    %eax,%esi
  803b52:	48 bf a0 58 80 00 00 	movabs $0x8058a0,%rdi
  803b59:	00 00 00 
  803b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  803b61:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  803b68:	00 00 00 
  803b6b:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803b6d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803b72:	e9 84 02 00 00       	jmpq   803dfb <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803b77:	b8 07 00 00 00       	mov    $0x7,%eax
  803b7c:	cd 30                	int    $0x30
  803b7e:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803b81:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803b84:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803b87:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803b8b:	79 08                	jns    803b95 <spawn+0xeb>
		return r;
  803b8d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b90:	e9 66 02 00 00       	jmpq   803dfb <spawn+0x351>
	child = r;
  803b95:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b98:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803b9b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803b9e:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ba3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803baa:	00 00 00 
  803bad:	48 98                	cltq   
  803baf:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803bb6:	48 01 d0             	add    %rdx,%rax
  803bb9:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803bc0:	48 89 c6             	mov    %rax,%rsi
  803bc3:	b8 18 00 00 00       	mov    $0x18,%eax
  803bc8:	48 89 d7             	mov    %rdx,%rdi
  803bcb:	48 89 c1             	mov    %rax,%rcx
  803bce:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803bd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd5:	48 8b 40 18          	mov    0x18(%rax),%rax
  803bd9:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803be0:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803be7:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803bee:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803bf5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803bf8:	48 89 ce             	mov    %rcx,%rsi
  803bfb:	89 c7                	mov    %eax,%edi
  803bfd:	48 b8 65 40 80 00 00 	movabs $0x804065,%rax
  803c04:	00 00 00 
  803c07:	ff d0                	callq  *%rax
  803c09:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803c0c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803c10:	79 08                	jns    803c1a <spawn+0x170>
		return r;
  803c12:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c15:	e9 e1 01 00 00       	jmpq   803dfb <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803c1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c1e:	48 8b 40 20          	mov    0x20(%rax),%rax
  803c22:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803c29:	48 01 d0             	add    %rdx,%rax
  803c2c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c37:	e9 a3 00 00 00       	jmpq   803cdf <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  803c3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c40:	8b 00                	mov    (%rax),%eax
  803c42:	83 f8 01             	cmp    $0x1,%eax
  803c45:	74 05                	je     803c4c <spawn+0x1a2>
			continue;
  803c47:	e9 8a 00 00 00       	jmpq   803cd6 <spawn+0x22c>
		perm = PTE_P | PTE_U;
  803c4c:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803c53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c57:	8b 40 04             	mov    0x4(%rax),%eax
  803c5a:	83 e0 02             	and    $0x2,%eax
  803c5d:	85 c0                	test   %eax,%eax
  803c5f:	74 04                	je     803c65 <spawn+0x1bb>
			perm |= PTE_W;
  803c61:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803c65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c69:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803c6d:	41 89 c1             	mov    %eax,%r9d
  803c70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c74:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803c78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c7c:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803c80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c84:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803c88:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803c8b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c8e:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803c91:	89 3c 24             	mov    %edi,(%rsp)
  803c94:	89 c7                	mov    %eax,%edi
  803c96:	48 b8 0e 43 80 00 00 	movabs $0x80430e,%rax
  803c9d:	00 00 00 
  803ca0:	ff d0                	callq  *%rax
  803ca2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803ca5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803ca9:	79 2b                	jns    803cd6 <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803cab:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803cac:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803caf:	89 c7                	mov    %eax,%edi
  803cb1:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  803cb8:	00 00 00 
  803cbb:	ff d0                	callq  *%rax
	close(fd);
  803cbd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803cc0:	89 c7                	mov    %eax,%edi
  803cc2:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  803cc9:	00 00 00 
  803ccc:	ff d0                	callq  *%rax
	return r;
  803cce:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803cd1:	e9 25 01 00 00       	jmpq   803dfb <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803cd6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803cda:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803cdf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ce3:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803ce7:	0f b7 c0             	movzwl %ax,%eax
  803cea:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803ced:	0f 8f 49 ff ff ff    	jg     803c3c <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803cf3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803cf6:	89 c7                	mov    %eax,%edi
  803cf8:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  803cff:	00 00 00 
  803d02:	ff d0                	callq  *%rax
	fd = -1;
  803d04:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803d0b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803d0e:	89 c7                	mov    %eax,%edi
  803d10:	48 b8 fa 44 80 00 00 	movabs $0x8044fa,%rax
  803d17:	00 00 00 
  803d1a:	ff d0                	callq  *%rax
  803d1c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803d1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803d23:	79 30                	jns    803d55 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  803d25:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803d28:	89 c1                	mov    %eax,%ecx
  803d2a:	48 ba ba 58 80 00 00 	movabs $0x8058ba,%rdx
  803d31:	00 00 00 
  803d34:	be 82 00 00 00       	mov    $0x82,%esi
  803d39:	48 bf d0 58 80 00 00 	movabs $0x8058d0,%rdi
  803d40:	00 00 00 
  803d43:	b8 00 00 00 00       	mov    $0x0,%eax
  803d48:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  803d4f:	00 00 00 
  803d52:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803d55:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803d5c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803d5f:	48 89 d6             	mov    %rdx,%rsi
  803d62:	89 c7                	mov    %eax,%edi
  803d64:	48 b8 39 21 80 00 00 	movabs $0x802139,%rax
  803d6b:	00 00 00 
  803d6e:	ff d0                	callq  *%rax
  803d70:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803d73:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803d77:	79 30                	jns    803da9 <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  803d79:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803d7c:	89 c1                	mov    %eax,%ecx
  803d7e:	48 ba dc 58 80 00 00 	movabs $0x8058dc,%rdx
  803d85:	00 00 00 
  803d88:	be 85 00 00 00       	mov    $0x85,%esi
  803d8d:	48 bf d0 58 80 00 00 	movabs $0x8058d0,%rdi
  803d94:	00 00 00 
  803d97:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9c:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  803da3:	00 00 00 
  803da6:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803da9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803dac:	be 02 00 00 00       	mov    $0x2,%esi
  803db1:	89 c7                	mov    %eax,%edi
  803db3:	48 b8 ee 20 80 00 00 	movabs $0x8020ee,%rax
  803dba:	00 00 00 
  803dbd:	ff d0                	callq  *%rax
  803dbf:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803dc2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803dc6:	79 30                	jns    803df8 <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  803dc8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803dcb:	89 c1                	mov    %eax,%ecx
  803dcd:	48 ba f6 58 80 00 00 	movabs $0x8058f6,%rdx
  803dd4:	00 00 00 
  803dd7:	be 88 00 00 00       	mov    $0x88,%esi
  803ddc:	48 bf d0 58 80 00 00 	movabs $0x8058d0,%rdi
  803de3:	00 00 00 
  803de6:	b8 00 00 00 00       	mov    $0x0,%eax
  803deb:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  803df2:	00 00 00 
  803df5:	41 ff d0             	callq  *%r8

	return child;
  803df8:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803dfb:	c9                   	leaveq 
  803dfc:	c3                   	retq   

0000000000803dfd <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803dfd:	55                   	push   %rbp
  803dfe:	48 89 e5             	mov    %rsp,%rbp
  803e01:	41 55                	push   %r13
  803e03:	41 54                	push   %r12
  803e05:	53                   	push   %rbx
  803e06:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803e0d:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803e14:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803e1b:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803e22:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803e29:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803e30:	84 c0                	test   %al,%al
  803e32:	74 26                	je     803e5a <spawnl+0x5d>
  803e34:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803e3b:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803e42:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803e46:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803e4a:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803e4e:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803e52:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803e56:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803e5a:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803e61:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803e68:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803e6b:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803e72:	00 00 00 
  803e75:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803e7c:	00 00 00 
  803e7f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803e83:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803e8a:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803e91:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803e98:	eb 07                	jmp    803ea1 <spawnl+0xa4>
		argc++;
  803e9a:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803ea1:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803ea7:	83 f8 30             	cmp    $0x30,%eax
  803eaa:	73 23                	jae    803ecf <spawnl+0xd2>
  803eac:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803eb3:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803eb9:	89 c0                	mov    %eax,%eax
  803ebb:	48 01 d0             	add    %rdx,%rax
  803ebe:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803ec4:	83 c2 08             	add    $0x8,%edx
  803ec7:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803ecd:	eb 15                	jmp    803ee4 <spawnl+0xe7>
  803ecf:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803ed6:	48 89 d0             	mov    %rdx,%rax
  803ed9:	48 83 c2 08          	add    $0x8,%rdx
  803edd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803ee4:	48 8b 00             	mov    (%rax),%rax
  803ee7:	48 85 c0             	test   %rax,%rax
  803eea:	75 ae                	jne    803e9a <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803eec:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803ef2:	83 c0 02             	add    $0x2,%eax
  803ef5:	48 89 e2             	mov    %rsp,%rdx
  803ef8:	48 89 d3             	mov    %rdx,%rbx
  803efb:	48 63 d0             	movslq %eax,%rdx
  803efe:	48 83 ea 01          	sub    $0x1,%rdx
  803f02:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803f09:	48 63 d0             	movslq %eax,%rdx
  803f0c:	49 89 d4             	mov    %rdx,%r12
  803f0f:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803f15:	48 63 d0             	movslq %eax,%rdx
  803f18:	49 89 d2             	mov    %rdx,%r10
  803f1b:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803f21:	48 98                	cltq   
  803f23:	48 c1 e0 03          	shl    $0x3,%rax
  803f27:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803f2b:	b8 10 00 00 00       	mov    $0x10,%eax
  803f30:	48 83 e8 01          	sub    $0x1,%rax
  803f34:	48 01 d0             	add    %rdx,%rax
  803f37:	bf 10 00 00 00       	mov    $0x10,%edi
  803f3c:	ba 00 00 00 00       	mov    $0x0,%edx
  803f41:	48 f7 f7             	div    %rdi
  803f44:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803f48:	48 29 c4             	sub    %rax,%rsp
  803f4b:	48 89 e0             	mov    %rsp,%rax
  803f4e:	48 83 c0 07          	add    $0x7,%rax
  803f52:	48 c1 e8 03          	shr    $0x3,%rax
  803f56:	48 c1 e0 03          	shl    $0x3,%rax
  803f5a:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803f61:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803f68:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803f6f:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803f72:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803f78:	8d 50 01             	lea    0x1(%rax),%edx
  803f7b:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803f82:	48 63 d2             	movslq %edx,%rdx
  803f85:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803f8c:	00 

	va_start(vl, arg0);
  803f8d:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803f94:	00 00 00 
  803f97:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803f9e:	00 00 00 
  803fa1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803fa5:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803fac:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803fb3:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803fba:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803fc1:	00 00 00 
  803fc4:	eb 63                	jmp    804029 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803fc6:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803fcc:	8d 70 01             	lea    0x1(%rax),%esi
  803fcf:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803fd5:	83 f8 30             	cmp    $0x30,%eax
  803fd8:	73 23                	jae    803ffd <spawnl+0x200>
  803fda:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803fe1:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803fe7:	89 c0                	mov    %eax,%eax
  803fe9:	48 01 d0             	add    %rdx,%rax
  803fec:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803ff2:	83 c2 08             	add    $0x8,%edx
  803ff5:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803ffb:	eb 15                	jmp    804012 <spawnl+0x215>
  803ffd:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804004:	48 89 d0             	mov    %rdx,%rax
  804007:	48 83 c2 08          	add    $0x8,%rdx
  80400b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804012:	48 8b 08             	mov    (%rax),%rcx
  804015:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80401c:	89 f2                	mov    %esi,%edx
  80401e:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  804022:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  804029:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80402f:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  804035:	77 8f                	ja     803fc6 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  804037:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80403e:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  804045:	48 89 d6             	mov    %rdx,%rsi
  804048:	48 89 c7             	mov    %rax,%rdi
  80404b:	48 b8 aa 3a 80 00 00 	movabs $0x803aaa,%rax
  804052:	00 00 00 
  804055:	ff d0                	callq  *%rax
  804057:	48 89 dc             	mov    %rbx,%rsp
}
  80405a:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  80405e:	5b                   	pop    %rbx
  80405f:	41 5c                	pop    %r12
  804061:	41 5d                	pop    %r13
  804063:	5d                   	pop    %rbp
  804064:	c3                   	retq   

0000000000804065 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  804065:	55                   	push   %rbp
  804066:	48 89 e5             	mov    %rsp,%rbp
  804069:	48 83 ec 50          	sub    $0x50,%rsp
  80406d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  804070:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  804074:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  804078:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80407f:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  804080:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  804087:	eb 33                	jmp    8040bc <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  804089:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80408c:	48 98                	cltq   
  80408e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804095:	00 
  804096:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80409a:	48 01 d0             	add    %rdx,%rax
  80409d:	48 8b 00             	mov    (%rax),%rax
  8040a0:	48 89 c7             	mov    %rax,%rdi
  8040a3:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  8040aa:	00 00 00 
  8040ad:	ff d0                	callq  *%rax
  8040af:	83 c0 01             	add    $0x1,%eax
  8040b2:	48 98                	cltq   
  8040b4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8040b8:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8040bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040bf:	48 98                	cltq   
  8040c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040c8:	00 
  8040c9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8040cd:	48 01 d0             	add    %rdx,%rax
  8040d0:	48 8b 00             	mov    (%rax),%rax
  8040d3:	48 85 c0             	test   %rax,%rax
  8040d6:	75 b1                	jne    804089 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8040d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040dc:	48 f7 d8             	neg    %rax
  8040df:	48 05 00 10 40 00    	add    $0x401000,%rax
  8040e5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8040e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040ed:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8040f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040f5:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8040f9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8040fc:	83 c2 01             	add    $0x1,%edx
  8040ff:	c1 e2 03             	shl    $0x3,%edx
  804102:	48 63 d2             	movslq %edx,%rdx
  804105:	48 f7 da             	neg    %rdx
  804108:	48 01 d0             	add    %rdx,%rax
  80410b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80410f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804113:	48 83 e8 10          	sub    $0x10,%rax
  804117:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80411d:	77 0a                	ja     804129 <init_stack+0xc4>
		return -E_NO_MEM;
  80411f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  804124:	e9 e3 01 00 00       	jmpq   80430c <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804129:	ba 07 00 00 00       	mov    $0x7,%edx
  80412e:	be 00 00 40 00       	mov    $0x400000,%esi
  804133:	bf 00 00 00 00       	mov    $0x0,%edi
  804138:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  80413f:	00 00 00 
  804142:	ff d0                	callq  *%rax
  804144:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804147:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80414b:	79 08                	jns    804155 <init_stack+0xf0>
		return r;
  80414d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804150:	e9 b7 01 00 00       	jmpq   80430c <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804155:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80415c:	e9 8a 00 00 00       	jmpq   8041eb <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  804161:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804164:	48 98                	cltq   
  804166:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80416d:	00 
  80416e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804172:	48 01 c2             	add    %rax,%rdx
  804175:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80417a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80417e:	48 01 c8             	add    %rcx,%rax
  804181:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804187:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  80418a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80418d:	48 98                	cltq   
  80418f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804196:	00 
  804197:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80419b:	48 01 d0             	add    %rdx,%rax
  80419e:	48 8b 10             	mov    (%rax),%rdx
  8041a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041a5:	48 89 d6             	mov    %rdx,%rsi
  8041a8:	48 89 c7             	mov    %rax,%rdi
  8041ab:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  8041b2:	00 00 00 
  8041b5:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8041b7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8041ba:	48 98                	cltq   
  8041bc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8041c3:	00 
  8041c4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041c8:	48 01 d0             	add    %rdx,%rax
  8041cb:	48 8b 00             	mov    (%rax),%rax
  8041ce:	48 89 c7             	mov    %rax,%rdi
  8041d1:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  8041d8:	00 00 00 
  8041db:	ff d0                	callq  *%rax
  8041dd:	48 98                	cltq   
  8041df:	48 83 c0 01          	add    $0x1,%rax
  8041e3:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8041e7:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8041eb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8041ee:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8041f1:	0f 8c 6a ff ff ff    	jl     804161 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8041f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041fa:	48 98                	cltq   
  8041fc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804203:	00 
  804204:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804208:	48 01 d0             	add    %rdx,%rax
  80420b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  804212:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804219:	00 
  80421a:	74 35                	je     804251 <init_stack+0x1ec>
  80421c:	48 b9 10 59 80 00 00 	movabs $0x805910,%rcx
  804223:	00 00 00 
  804226:	48 ba 36 59 80 00 00 	movabs $0x805936,%rdx
  80422d:	00 00 00 
  804230:	be f1 00 00 00       	mov    $0xf1,%esi
  804235:	48 bf d0 58 80 00 00 	movabs $0x8058d0,%rdi
  80423c:	00 00 00 
  80423f:	b8 00 00 00 00       	mov    $0x0,%eax
  804244:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  80424b:	00 00 00 
  80424e:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804251:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804255:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  804259:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80425e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804262:	48 01 c8             	add    %rcx,%rax
  804265:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80426b:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  80426e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804272:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  804276:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804279:	48 98                	cltq   
  80427b:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80427e:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  804283:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804287:	48 01 d0             	add    %rdx,%rax
  80428a:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804290:	48 89 c2             	mov    %rax,%rdx
  804293:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804297:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80429a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80429d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8042a3:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8042a8:	89 c2                	mov    %eax,%edx
  8042aa:	be 00 00 40 00       	mov    $0x400000,%esi
  8042af:	bf 00 00 00 00       	mov    $0x0,%edi
  8042b4:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  8042bb:	00 00 00 
  8042be:	ff d0                	callq  *%rax
  8042c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042c7:	79 02                	jns    8042cb <init_stack+0x266>
		goto error;
  8042c9:	eb 28                	jmp    8042f3 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8042cb:	be 00 00 40 00       	mov    $0x400000,%esi
  8042d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8042d5:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  8042dc:	00 00 00 
  8042df:	ff d0                	callq  *%rax
  8042e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042e8:	79 02                	jns    8042ec <init_stack+0x287>
		goto error;
  8042ea:	eb 07                	jmp    8042f3 <init_stack+0x28e>

	return 0;
  8042ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8042f1:	eb 19                	jmp    80430c <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8042f3:	be 00 00 40 00       	mov    $0x400000,%esi
  8042f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8042fd:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804304:	00 00 00 
  804307:	ff d0                	callq  *%rax
	return r;
  804309:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80430c:	c9                   	leaveq 
  80430d:	c3                   	retq   

000000000080430e <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  80430e:	55                   	push   %rbp
  80430f:	48 89 e5             	mov    %rsp,%rbp
  804312:	48 83 ec 50          	sub    $0x50,%rsp
  804316:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804319:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80431d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  804321:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  804324:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804328:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80432c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804330:	25 ff 0f 00 00       	and    $0xfff,%eax
  804335:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804338:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80433c:	74 21                	je     80435f <map_segment+0x51>
		va -= i;
  80433e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804341:	48 98                	cltq   
  804343:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  804347:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80434a:	48 98                	cltq   
  80434c:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  804350:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804353:	48 98                	cltq   
  804355:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  804359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80435c:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80435f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804366:	e9 79 01 00 00       	jmpq   8044e4 <map_segment+0x1d6>
		if (i >= filesz) {
  80436b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80436e:	48 98                	cltq   
  804370:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  804374:	72 3c                	jb     8043b2 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  804376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804379:	48 63 d0             	movslq %eax,%rdx
  80437c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804380:	48 01 d0             	add    %rdx,%rax
  804383:	48 89 c1             	mov    %rax,%rcx
  804386:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804389:	8b 55 10             	mov    0x10(%rbp),%edx
  80438c:	48 89 ce             	mov    %rcx,%rsi
  80438f:	89 c7                	mov    %eax,%edi
  804391:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804398:	00 00 00 
  80439b:	ff d0                	callq  *%rax
  80439d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8043a0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8043a4:	0f 89 33 01 00 00    	jns    8044dd <map_segment+0x1cf>
				return r;
  8043aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043ad:	e9 46 01 00 00       	jmpq   8044f8 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8043b2:	ba 07 00 00 00       	mov    $0x7,%edx
  8043b7:	be 00 00 40 00       	mov    $0x400000,%esi
  8043bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8043c1:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8043c8:	00 00 00 
  8043cb:	ff d0                	callq  *%rax
  8043cd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8043d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8043d4:	79 08                	jns    8043de <map_segment+0xd0>
				return r;
  8043d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043d9:	e9 1a 01 00 00       	jmpq   8044f8 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8043de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e1:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8043e4:	01 c2                	add    %eax,%edx
  8043e6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8043e9:	89 d6                	mov    %edx,%esi
  8043eb:	89 c7                	mov    %eax,%edi
  8043ed:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  8043f4:	00 00 00 
  8043f7:	ff d0                	callq  *%rax
  8043f9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8043fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804400:	79 08                	jns    80440a <map_segment+0xfc>
				return r;
  804402:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804405:	e9 ee 00 00 00       	jmpq   8044f8 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80440a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  804411:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804414:	48 98                	cltq   
  804416:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80441a:	48 29 c2             	sub    %rax,%rdx
  80441d:	48 89 d0             	mov    %rdx,%rax
  804420:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804424:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804427:	48 63 d0             	movslq %eax,%rdx
  80442a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80442e:	48 39 c2             	cmp    %rax,%rdx
  804431:	48 0f 47 d0          	cmova  %rax,%rdx
  804435:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804438:	be 00 00 40 00       	mov    $0x400000,%esi
  80443d:	89 c7                	mov    %eax,%edi
  80443f:	48 b8 c6 30 80 00 00 	movabs $0x8030c6,%rax
  804446:	00 00 00 
  804449:	ff d0                	callq  *%rax
  80444b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80444e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804452:	79 08                	jns    80445c <map_segment+0x14e>
				return r;
  804454:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804457:	e9 9c 00 00 00       	jmpq   8044f8 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80445c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80445f:	48 63 d0             	movslq %eax,%rdx
  804462:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804466:	48 01 d0             	add    %rdx,%rax
  804469:	48 89 c2             	mov    %rax,%rdx
  80446c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80446f:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  804473:	48 89 d1             	mov    %rdx,%rcx
  804476:	89 c2                	mov    %eax,%edx
  804478:	be 00 00 40 00       	mov    $0x400000,%esi
  80447d:	bf 00 00 00 00       	mov    $0x0,%edi
  804482:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  804489:	00 00 00 
  80448c:	ff d0                	callq  *%rax
  80448e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804491:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804495:	79 30                	jns    8044c7 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  804497:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80449a:	89 c1                	mov    %eax,%ecx
  80449c:	48 ba 4b 59 80 00 00 	movabs $0x80594b,%rdx
  8044a3:	00 00 00 
  8044a6:	be 24 01 00 00       	mov    $0x124,%esi
  8044ab:	48 bf d0 58 80 00 00 	movabs $0x8058d0,%rdi
  8044b2:	00 00 00 
  8044b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ba:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8044c1:	00 00 00 
  8044c4:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8044c7:	be 00 00 40 00       	mov    $0x400000,%esi
  8044cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8044d1:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  8044d8:	00 00 00 
  8044db:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8044dd:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8044e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044e7:	48 98                	cltq   
  8044e9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8044ed:	0f 82 78 fe ff ff    	jb     80436b <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8044f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044f8:	c9                   	leaveq 
  8044f9:	c3                   	retq   

00000000008044fa <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8044fa:	55                   	push   %rbp
  8044fb:	48 89 e5             	mov    %rsp,%rbp
  8044fe:	48 83 ec 20          	sub    $0x20,%rsp
  804502:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  804505:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  80450c:	00 
  80450d:	e9 c9 00 00 00       	jmpq   8045db <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  804512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804516:	48 c1 e8 27          	shr    $0x27,%rax
  80451a:	48 89 c2             	mov    %rax,%rdx
  80451d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804524:	01 00 00 
  804527:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80452b:	48 85 c0             	test   %rax,%rax
  80452e:	74 3c                	je     80456c <copy_shared_pages+0x72>
  804530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804534:	48 c1 e8 1e          	shr    $0x1e,%rax
  804538:	48 89 c2             	mov    %rax,%rdx
  80453b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804542:	01 00 00 
  804545:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804549:	48 85 c0             	test   %rax,%rax
  80454c:	74 1e                	je     80456c <copy_shared_pages+0x72>
  80454e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804552:	48 c1 e8 15          	shr    $0x15,%rax
  804556:	48 89 c2             	mov    %rax,%rdx
  804559:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804560:	01 00 00 
  804563:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804567:	48 85 c0             	test   %rax,%rax
  80456a:	75 02                	jne    80456e <copy_shared_pages+0x74>
                continue;
  80456c:	eb 65                	jmp    8045d3 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  80456e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804572:	48 c1 e8 0c          	shr    $0xc,%rax
  804576:	48 89 c2             	mov    %rax,%rdx
  804579:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804580:	01 00 00 
  804583:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804587:	25 00 04 00 00       	and    $0x400,%eax
  80458c:	48 85 c0             	test   %rax,%rax
  80458f:	74 42                	je     8045d3 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  804591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804595:	48 c1 e8 0c          	shr    $0xc,%rax
  804599:	48 89 c2             	mov    %rax,%rdx
  80459c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8045a3:	01 00 00 
  8045a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045aa:	25 07 0e 00 00       	and    $0xe07,%eax
  8045af:	89 c6                	mov    %eax,%esi
  8045b1:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8045b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045b9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8045bc:	41 89 f0             	mov    %esi,%r8d
  8045bf:	48 89 c6             	mov    %rax,%rsi
  8045c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8045c7:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  8045ce:	00 00 00 
  8045d1:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  8045d3:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8045da:	00 
  8045db:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  8045e2:	00 00 00 
  8045e5:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8045e9:	0f 86 23 ff ff ff    	jbe    804512 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  8045ef:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  8045f4:	c9                   	leaveq 
  8045f5:	c3                   	retq   

00000000008045f6 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8045f6:	55                   	push   %rbp
  8045f7:	48 89 e5             	mov    %rsp,%rbp
  8045fa:	53                   	push   %rbx
  8045fb:	48 83 ec 38          	sub    $0x38,%rsp
  8045ff:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804603:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804607:	48 89 c7             	mov    %rax,%rdi
  80460a:	48 b8 27 2b 80 00 00 	movabs $0x802b27,%rax
  804611:	00 00 00 
  804614:	ff d0                	callq  *%rax
  804616:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804619:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80461d:	0f 88 bf 01 00 00    	js     8047e2 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804627:	ba 07 04 00 00       	mov    $0x407,%edx
  80462c:	48 89 c6             	mov    %rax,%rsi
  80462f:	bf 00 00 00 00       	mov    $0x0,%edi
  804634:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  80463b:	00 00 00 
  80463e:	ff d0                	callq  *%rax
  804640:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804643:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804647:	0f 88 95 01 00 00    	js     8047e2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80464d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804651:	48 89 c7             	mov    %rax,%rdi
  804654:	48 b8 27 2b 80 00 00 	movabs $0x802b27,%rax
  80465b:	00 00 00 
  80465e:	ff d0                	callq  *%rax
  804660:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804663:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804667:	0f 88 5d 01 00 00    	js     8047ca <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80466d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804671:	ba 07 04 00 00       	mov    $0x407,%edx
  804676:	48 89 c6             	mov    %rax,%rsi
  804679:	bf 00 00 00 00       	mov    $0x0,%edi
  80467e:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804685:	00 00 00 
  804688:	ff d0                	callq  *%rax
  80468a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80468d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804691:	0f 88 33 01 00 00    	js     8047ca <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804697:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80469b:	48 89 c7             	mov    %rax,%rdi
  80469e:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  8046a5:	00 00 00 
  8046a8:	ff d0                	callq  *%rax
  8046aa:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8046ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046b2:	ba 07 04 00 00       	mov    $0x407,%edx
  8046b7:	48 89 c6             	mov    %rax,%rsi
  8046ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8046bf:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8046c6:	00 00 00 
  8046c9:	ff d0                	callq  *%rax
  8046cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8046ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8046d2:	79 05                	jns    8046d9 <pipe+0xe3>
		goto err2;
  8046d4:	e9 d9 00 00 00       	jmpq   8047b2 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8046d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046dd:	48 89 c7             	mov    %rax,%rdi
  8046e0:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  8046e7:	00 00 00 
  8046ea:	ff d0                	callq  *%rax
  8046ec:	48 89 c2             	mov    %rax,%rdx
  8046ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046f3:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8046f9:	48 89 d1             	mov    %rdx,%rcx
  8046fc:	ba 00 00 00 00       	mov    $0x0,%edx
  804701:	48 89 c6             	mov    %rax,%rsi
  804704:	bf 00 00 00 00       	mov    $0x0,%edi
  804709:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  804710:	00 00 00 
  804713:	ff d0                	callq  *%rax
  804715:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804718:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80471c:	79 1b                	jns    804739 <pipe+0x143>
		goto err3;
  80471e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80471f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804723:	48 89 c6             	mov    %rax,%rsi
  804726:	bf 00 00 00 00       	mov    $0x0,%edi
  80472b:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804732:	00 00 00 
  804735:	ff d0                	callq  *%rax
  804737:	eb 79                	jmp    8047b2 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804739:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80473d:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  804744:	00 00 00 
  804747:	8b 12                	mov    (%rdx),%edx
  804749:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80474b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80474f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804756:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80475a:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  804761:	00 00 00 
  804764:	8b 12                	mov    (%rdx),%edx
  804766:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804768:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80476c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804777:	48 89 c7             	mov    %rax,%rdi
  80477a:	48 b8 d9 2a 80 00 00 	movabs $0x802ad9,%rax
  804781:	00 00 00 
  804784:	ff d0                	callq  *%rax
  804786:	89 c2                	mov    %eax,%edx
  804788:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80478c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80478e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804792:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804796:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80479a:	48 89 c7             	mov    %rax,%rdi
  80479d:	48 b8 d9 2a 80 00 00 	movabs $0x802ad9,%rax
  8047a4:	00 00 00 
  8047a7:	ff d0                	callq  *%rax
  8047a9:	89 03                	mov    %eax,(%rbx)
	return 0;
  8047ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8047b0:	eb 33                	jmp    8047e5 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8047b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047b6:	48 89 c6             	mov    %rax,%rsi
  8047b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8047be:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  8047c5:	00 00 00 
  8047c8:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8047ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047ce:	48 89 c6             	mov    %rax,%rsi
  8047d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8047d6:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  8047dd:	00 00 00 
  8047e0:	ff d0                	callq  *%rax
err:
	return r;
  8047e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8047e5:	48 83 c4 38          	add    $0x38,%rsp
  8047e9:	5b                   	pop    %rbx
  8047ea:	5d                   	pop    %rbp
  8047eb:	c3                   	retq   

00000000008047ec <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8047ec:	55                   	push   %rbp
  8047ed:	48 89 e5             	mov    %rsp,%rbp
  8047f0:	53                   	push   %rbx
  8047f1:	48 83 ec 28          	sub    $0x28,%rsp
  8047f5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8047f9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8047fd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804804:	00 00 00 
  804807:	48 8b 00             	mov    (%rax),%rax
  80480a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804810:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804813:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804817:	48 89 c7             	mov    %rax,%rdi
  80481a:	48 b8 8c 4f 80 00 00 	movabs $0x804f8c,%rax
  804821:	00 00 00 
  804824:	ff d0                	callq  *%rax
  804826:	89 c3                	mov    %eax,%ebx
  804828:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80482c:	48 89 c7             	mov    %rax,%rdi
  80482f:	48 b8 8c 4f 80 00 00 	movabs $0x804f8c,%rax
  804836:	00 00 00 
  804839:	ff d0                	callq  *%rax
  80483b:	39 c3                	cmp    %eax,%ebx
  80483d:	0f 94 c0             	sete   %al
  804840:	0f b6 c0             	movzbl %al,%eax
  804843:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804846:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80484d:	00 00 00 
  804850:	48 8b 00             	mov    (%rax),%rax
  804853:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804859:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80485c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80485f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804862:	75 05                	jne    804869 <_pipeisclosed+0x7d>
			return ret;
  804864:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804867:	eb 4f                	jmp    8048b8 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804869:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80486c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80486f:	74 42                	je     8048b3 <_pipeisclosed+0xc7>
  804871:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804875:	75 3c                	jne    8048b3 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804877:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80487e:	00 00 00 
  804881:	48 8b 00             	mov    (%rax),%rax
  804884:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80488a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80488d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804890:	89 c6                	mov    %eax,%esi
  804892:	48 bf 72 59 80 00 00 	movabs $0x805972,%rdi
  804899:	00 00 00 
  80489c:	b8 00 00 00 00       	mov    $0x0,%eax
  8048a1:	49 b8 15 0b 80 00 00 	movabs $0x800b15,%r8
  8048a8:	00 00 00 
  8048ab:	41 ff d0             	callq  *%r8
	}
  8048ae:	e9 4a ff ff ff       	jmpq   8047fd <_pipeisclosed+0x11>
  8048b3:	e9 45 ff ff ff       	jmpq   8047fd <_pipeisclosed+0x11>
}
  8048b8:	48 83 c4 28          	add    $0x28,%rsp
  8048bc:	5b                   	pop    %rbx
  8048bd:	5d                   	pop    %rbp
  8048be:	c3                   	retq   

00000000008048bf <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8048bf:	55                   	push   %rbp
  8048c0:	48 89 e5             	mov    %rsp,%rbp
  8048c3:	48 83 ec 30          	sub    $0x30,%rsp
  8048c7:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8048ca:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8048ce:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8048d1:	48 89 d6             	mov    %rdx,%rsi
  8048d4:	89 c7                	mov    %eax,%edi
  8048d6:	48 b8 bf 2b 80 00 00 	movabs $0x802bbf,%rax
  8048dd:	00 00 00 
  8048e0:	ff d0                	callq  *%rax
  8048e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048e9:	79 05                	jns    8048f0 <pipeisclosed+0x31>
		return r;
  8048eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048ee:	eb 31                	jmp    804921 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8048f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048f4:	48 89 c7             	mov    %rax,%rdi
  8048f7:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  8048fe:	00 00 00 
  804901:	ff d0                	callq  *%rax
  804903:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80490b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80490f:	48 89 d6             	mov    %rdx,%rsi
  804912:	48 89 c7             	mov    %rax,%rdi
  804915:	48 b8 ec 47 80 00 00 	movabs $0x8047ec,%rax
  80491c:	00 00 00 
  80491f:	ff d0                	callq  *%rax
}
  804921:	c9                   	leaveq 
  804922:	c3                   	retq   

0000000000804923 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804923:	55                   	push   %rbp
  804924:	48 89 e5             	mov    %rsp,%rbp
  804927:	48 83 ec 40          	sub    $0x40,%rsp
  80492b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80492f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804933:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80493b:	48 89 c7             	mov    %rax,%rdi
  80493e:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  804945:	00 00 00 
  804948:	ff d0                	callq  *%rax
  80494a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80494e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804952:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804956:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80495d:	00 
  80495e:	e9 92 00 00 00       	jmpq   8049f5 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804963:	eb 41                	jmp    8049a6 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804965:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80496a:	74 09                	je     804975 <devpipe_read+0x52>
				return i;
  80496c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804970:	e9 92 00 00 00       	jmpq   804a07 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804975:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804979:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80497d:	48 89 d6             	mov    %rdx,%rsi
  804980:	48 89 c7             	mov    %rax,%rdi
  804983:	48 b8 ec 47 80 00 00 	movabs $0x8047ec,%rax
  80498a:	00 00 00 
  80498d:	ff d0                	callq  *%rax
  80498f:	85 c0                	test   %eax,%eax
  804991:	74 07                	je     80499a <devpipe_read+0x77>
				return 0;
  804993:	b8 00 00 00 00       	mov    $0x0,%eax
  804998:	eb 6d                	jmp    804a07 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80499a:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  8049a1:	00 00 00 
  8049a4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8049a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049aa:	8b 10                	mov    (%rax),%edx
  8049ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049b0:	8b 40 04             	mov    0x4(%rax),%eax
  8049b3:	39 c2                	cmp    %eax,%edx
  8049b5:	74 ae                	je     804965 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8049b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8049bf:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8049c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049c7:	8b 00                	mov    (%rax),%eax
  8049c9:	99                   	cltd   
  8049ca:	c1 ea 1b             	shr    $0x1b,%edx
  8049cd:	01 d0                	add    %edx,%eax
  8049cf:	83 e0 1f             	and    $0x1f,%eax
  8049d2:	29 d0                	sub    %edx,%eax
  8049d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049d8:	48 98                	cltq   
  8049da:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8049df:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8049e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049e5:	8b 00                	mov    (%rax),%eax
  8049e7:	8d 50 01             	lea    0x1(%rax),%edx
  8049ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049ee:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8049f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8049f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049f9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8049fd:	0f 82 60 ff ff ff    	jb     804963 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804a03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804a07:	c9                   	leaveq 
  804a08:	c3                   	retq   

0000000000804a09 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804a09:	55                   	push   %rbp
  804a0a:	48 89 e5             	mov    %rsp,%rbp
  804a0d:	48 83 ec 40          	sub    $0x40,%rsp
  804a11:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804a15:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804a19:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804a1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a21:	48 89 c7             	mov    %rax,%rdi
  804a24:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  804a2b:	00 00 00 
  804a2e:	ff d0                	callq  *%rax
  804a30:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804a34:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804a3c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804a43:	00 
  804a44:	e9 8e 00 00 00       	jmpq   804ad7 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804a49:	eb 31                	jmp    804a7c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804a4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a53:	48 89 d6             	mov    %rdx,%rsi
  804a56:	48 89 c7             	mov    %rax,%rdi
  804a59:	48 b8 ec 47 80 00 00 	movabs $0x8047ec,%rax
  804a60:	00 00 00 
  804a63:	ff d0                	callq  *%rax
  804a65:	85 c0                	test   %eax,%eax
  804a67:	74 07                	je     804a70 <devpipe_write+0x67>
				return 0;
  804a69:	b8 00 00 00 00       	mov    $0x0,%eax
  804a6e:	eb 79                	jmp    804ae9 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804a70:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  804a77:	00 00 00 
  804a7a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804a7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a80:	8b 40 04             	mov    0x4(%rax),%eax
  804a83:	48 63 d0             	movslq %eax,%rdx
  804a86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a8a:	8b 00                	mov    (%rax),%eax
  804a8c:	48 98                	cltq   
  804a8e:	48 83 c0 20          	add    $0x20,%rax
  804a92:	48 39 c2             	cmp    %rax,%rdx
  804a95:	73 b4                	jae    804a4b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804a97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a9b:	8b 40 04             	mov    0x4(%rax),%eax
  804a9e:	99                   	cltd   
  804a9f:	c1 ea 1b             	shr    $0x1b,%edx
  804aa2:	01 d0                	add    %edx,%eax
  804aa4:	83 e0 1f             	and    $0x1f,%eax
  804aa7:	29 d0                	sub    %edx,%eax
  804aa9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804aad:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804ab1:	48 01 ca             	add    %rcx,%rdx
  804ab4:	0f b6 0a             	movzbl (%rdx),%ecx
  804ab7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804abb:	48 98                	cltq   
  804abd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804ac1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ac5:	8b 40 04             	mov    0x4(%rax),%eax
  804ac8:	8d 50 01             	lea    0x1(%rax),%edx
  804acb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804acf:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804ad2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804ad7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804adb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804adf:	0f 82 64 ff ff ff    	jb     804a49 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804ae5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804ae9:	c9                   	leaveq 
  804aea:	c3                   	retq   

0000000000804aeb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804aeb:	55                   	push   %rbp
  804aec:	48 89 e5             	mov    %rsp,%rbp
  804aef:	48 83 ec 20          	sub    $0x20,%rsp
  804af3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804af7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804afb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aff:	48 89 c7             	mov    %rax,%rdi
  804b02:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  804b09:	00 00 00 
  804b0c:	ff d0                	callq  *%rax
  804b0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804b12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b16:	48 be 85 59 80 00 00 	movabs $0x805985,%rsi
  804b1d:	00 00 00 
  804b20:	48 89 c7             	mov    %rax,%rdi
  804b23:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  804b2a:	00 00 00 
  804b2d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804b2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b33:	8b 50 04             	mov    0x4(%rax),%edx
  804b36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b3a:	8b 00                	mov    (%rax),%eax
  804b3c:	29 c2                	sub    %eax,%edx
  804b3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b42:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804b48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b4c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804b53:	00 00 00 
	stat->st_dev = &devpipe;
  804b56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b5a:	48 b9 00 71 80 00 00 	movabs $0x807100,%rcx
  804b61:	00 00 00 
  804b64:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804b6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b70:	c9                   	leaveq 
  804b71:	c3                   	retq   

0000000000804b72 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804b72:	55                   	push   %rbp
  804b73:	48 89 e5             	mov    %rsp,%rbp
  804b76:	48 83 ec 10          	sub    $0x10,%rsp
  804b7a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804b7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b82:	48 89 c6             	mov    %rax,%rsi
  804b85:	bf 00 00 00 00       	mov    $0x0,%edi
  804b8a:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804b91:	00 00 00 
  804b94:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804b96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b9a:	48 89 c7             	mov    %rax,%rdi
  804b9d:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  804ba4:	00 00 00 
  804ba7:	ff d0                	callq  *%rax
  804ba9:	48 89 c6             	mov    %rax,%rsi
  804bac:	bf 00 00 00 00       	mov    $0x0,%edi
  804bb1:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804bb8:	00 00 00 
  804bbb:	ff d0                	callq  *%rax
}
  804bbd:	c9                   	leaveq 
  804bbe:	c3                   	retq   

0000000000804bbf <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804bbf:	55                   	push   %rbp
  804bc0:	48 89 e5             	mov    %rsp,%rbp
  804bc3:	48 83 ec 20          	sub    $0x20,%rsp
  804bc7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804bca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804bce:	75 35                	jne    804c05 <wait+0x46>
  804bd0:	48 b9 8c 59 80 00 00 	movabs $0x80598c,%rcx
  804bd7:	00 00 00 
  804bda:	48 ba 97 59 80 00 00 	movabs $0x805997,%rdx
  804be1:	00 00 00 
  804be4:	be 09 00 00 00       	mov    $0x9,%esi
  804be9:	48 bf ac 59 80 00 00 	movabs $0x8059ac,%rdi
  804bf0:	00 00 00 
  804bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  804bf8:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  804bff:	00 00 00 
  804c02:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804c05:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804c08:	25 ff 03 00 00       	and    $0x3ff,%eax
  804c0d:	48 98                	cltq   
  804c0f:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804c16:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804c1d:	00 00 00 
  804c20:	48 01 d0             	add    %rdx,%rax
  804c23:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804c27:	eb 0c                	jmp    804c35 <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  804c29:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  804c30:	00 00 00 
  804c33:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804c35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c39:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804c3f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804c42:	75 0e                	jne    804c52 <wait+0x93>
  804c44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c48:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804c4e:	85 c0                	test   %eax,%eax
  804c50:	75 d7                	jne    804c29 <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  804c52:	c9                   	leaveq 
  804c53:	c3                   	retq   

0000000000804c54 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804c54:	55                   	push   %rbp
  804c55:	48 89 e5             	mov    %rsp,%rbp
  804c58:	48 83 ec 10          	sub    $0x10,%rsp
  804c5c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804c60:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804c67:	00 00 00 
  804c6a:	48 8b 00             	mov    (%rax),%rax
  804c6d:	48 85 c0             	test   %rax,%rax
  804c70:	0f 85 84 00 00 00    	jne    804cfa <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804c76:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804c7d:	00 00 00 
  804c80:	48 8b 00             	mov    (%rax),%rax
  804c83:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804c89:	ba 07 00 00 00       	mov    $0x7,%edx
  804c8e:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804c93:	89 c7                	mov    %eax,%edi
  804c95:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804c9c:	00 00 00 
  804c9f:	ff d0                	callq  *%rax
  804ca1:	85 c0                	test   %eax,%eax
  804ca3:	79 2a                	jns    804ccf <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804ca5:	48 ba b8 59 80 00 00 	movabs $0x8059b8,%rdx
  804cac:	00 00 00 
  804caf:	be 23 00 00 00       	mov    $0x23,%esi
  804cb4:	48 bf df 59 80 00 00 	movabs $0x8059df,%rdi
  804cbb:	00 00 00 
  804cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  804cc3:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  804cca:	00 00 00 
  804ccd:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804ccf:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804cd6:	00 00 00 
  804cd9:	48 8b 00             	mov    (%rax),%rax
  804cdc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804ce2:	48 be 0d 4d 80 00 00 	movabs $0x804d0d,%rsi
  804ce9:	00 00 00 
  804cec:	89 c7                	mov    %eax,%edi
  804cee:	48 b8 83 21 80 00 00 	movabs $0x802183,%rax
  804cf5:	00 00 00 
  804cf8:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804cfa:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804d01:	00 00 00 
  804d04:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804d08:	48 89 10             	mov    %rdx,(%rax)
}
  804d0b:	c9                   	leaveq 
  804d0c:	c3                   	retq   

0000000000804d0d <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804d0d:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804d10:	48 a1 08 a0 80 00 00 	movabs 0x80a008,%rax
  804d17:	00 00 00 
call *%rax
  804d1a:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  804d1c:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804d23:	00 
movq 152(%rsp), %rcx  //Load RSP
  804d24:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804d2b:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  804d2c:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  804d30:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  804d33:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804d3a:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  804d3b:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  804d3f:	4c 8b 3c 24          	mov    (%rsp),%r15
  804d43:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804d48:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804d4d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804d52:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804d57:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804d5c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804d61:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804d66:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804d6b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804d70:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804d75:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804d7a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804d7f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804d84:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804d89:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  804d8d:	48 83 c4 08          	add    $0x8,%rsp
popfq
  804d91:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  804d92:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  804d93:	c3                   	retq   

0000000000804d94 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804d94:	55                   	push   %rbp
  804d95:	48 89 e5             	mov    %rsp,%rbp
  804d98:	48 83 ec 30          	sub    $0x30,%rsp
  804d9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804da0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804da4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804da8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804daf:	00 00 00 
  804db2:	48 8b 00             	mov    (%rax),%rax
  804db5:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804dbb:	85 c0                	test   %eax,%eax
  804dbd:	75 34                	jne    804df3 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  804dbf:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  804dc6:	00 00 00 
  804dc9:	ff d0                	callq  *%rax
  804dcb:	25 ff 03 00 00       	and    $0x3ff,%eax
  804dd0:	48 98                	cltq   
  804dd2:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804dd9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804de0:	00 00 00 
  804de3:	48 01 c2             	add    %rax,%rdx
  804de6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804ded:	00 00 00 
  804df0:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804df3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804df8:	75 0e                	jne    804e08 <ipc_recv+0x74>
		pg = (void*) UTOP;
  804dfa:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804e01:	00 00 00 
  804e04:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804e08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e0c:	48 89 c7             	mov    %rax,%rdi
  804e0f:	48 b8 22 22 80 00 00 	movabs $0x802222,%rax
  804e16:	00 00 00 
  804e19:	ff d0                	callq  *%rax
  804e1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804e1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e22:	79 19                	jns    804e3d <ipc_recv+0xa9>
		*from_env_store = 0;
  804e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e28:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804e2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e32:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804e38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e3b:	eb 53                	jmp    804e90 <ipc_recv+0xfc>
	}
	if(from_env_store)
  804e3d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804e42:	74 19                	je     804e5d <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  804e44:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804e4b:	00 00 00 
  804e4e:	48 8b 00             	mov    (%rax),%rax
  804e51:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804e57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e5b:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804e5d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804e62:	74 19                	je     804e7d <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  804e64:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804e6b:	00 00 00 
  804e6e:	48 8b 00             	mov    (%rax),%rax
  804e71:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804e77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e7b:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804e7d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804e84:	00 00 00 
  804e87:	48 8b 00             	mov    (%rax),%rax
  804e8a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804e90:	c9                   	leaveq 
  804e91:	c3                   	retq   

0000000000804e92 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804e92:	55                   	push   %rbp
  804e93:	48 89 e5             	mov    %rsp,%rbp
  804e96:	48 83 ec 30          	sub    $0x30,%rsp
  804e9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804e9d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804ea0:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804ea4:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804ea7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804eac:	75 0e                	jne    804ebc <ipc_send+0x2a>
		pg = (void*)UTOP;
  804eae:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804eb5:	00 00 00 
  804eb8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804ebc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804ebf:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804ec2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804ec6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ec9:	89 c7                	mov    %eax,%edi
  804ecb:	48 b8 cd 21 80 00 00 	movabs $0x8021cd,%rax
  804ed2:	00 00 00 
  804ed5:	ff d0                	callq  *%rax
  804ed7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804eda:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804ede:	75 0c                	jne    804eec <ipc_send+0x5a>
			sys_yield();
  804ee0:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  804ee7:	00 00 00 
  804eea:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804eec:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804ef0:	74 ca                	je     804ebc <ipc_send+0x2a>
	if(result != 0)
  804ef2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ef6:	74 20                	je     804f18 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  804ef8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804efb:	89 c6                	mov    %eax,%esi
  804efd:	48 bf ed 59 80 00 00 	movabs $0x8059ed,%rdi
  804f04:	00 00 00 
  804f07:	b8 00 00 00 00       	mov    $0x0,%eax
  804f0c:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  804f13:	00 00 00 
  804f16:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  804f18:	c9                   	leaveq 
  804f19:	c3                   	retq   

0000000000804f1a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804f1a:	55                   	push   %rbp
  804f1b:	48 89 e5             	mov    %rsp,%rbp
  804f1e:	48 83 ec 14          	sub    $0x14,%rsp
  804f22:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804f25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804f2c:	eb 4e                	jmp    804f7c <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804f2e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804f35:	00 00 00 
  804f38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f3b:	48 98                	cltq   
  804f3d:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804f44:	48 01 d0             	add    %rdx,%rax
  804f47:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804f4d:	8b 00                	mov    (%rax),%eax
  804f4f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804f52:	75 24                	jne    804f78 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804f54:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804f5b:	00 00 00 
  804f5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f61:	48 98                	cltq   
  804f63:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804f6a:	48 01 d0             	add    %rdx,%rax
  804f6d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804f73:	8b 40 08             	mov    0x8(%rax),%eax
  804f76:	eb 12                	jmp    804f8a <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804f78:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804f7c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804f83:	7e a9                	jle    804f2e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804f85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804f8a:	c9                   	leaveq 
  804f8b:	c3                   	retq   

0000000000804f8c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804f8c:	55                   	push   %rbp
  804f8d:	48 89 e5             	mov    %rsp,%rbp
  804f90:	48 83 ec 18          	sub    $0x18,%rsp
  804f94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f9c:	48 c1 e8 15          	shr    $0x15,%rax
  804fa0:	48 89 c2             	mov    %rax,%rdx
  804fa3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804faa:	01 00 00 
  804fad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804fb1:	83 e0 01             	and    $0x1,%eax
  804fb4:	48 85 c0             	test   %rax,%rax
  804fb7:	75 07                	jne    804fc0 <pageref+0x34>
		return 0;
  804fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  804fbe:	eb 53                	jmp    805013 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804fc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804fc4:	48 c1 e8 0c          	shr    $0xc,%rax
  804fc8:	48 89 c2             	mov    %rax,%rdx
  804fcb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804fd2:	01 00 00 
  804fd5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804fd9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804fdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804fe1:	83 e0 01             	and    $0x1,%eax
  804fe4:	48 85 c0             	test   %rax,%rax
  804fe7:	75 07                	jne    804ff0 <pageref+0x64>
		return 0;
  804fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  804fee:	eb 23                	jmp    805013 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804ff0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ff4:	48 c1 e8 0c          	shr    $0xc,%rax
  804ff8:	48 89 c2             	mov    %rax,%rdx
  804ffb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805002:	00 00 00 
  805005:	48 c1 e2 04          	shl    $0x4,%rdx
  805009:	48 01 d0             	add    %rdx,%rax
  80500c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805010:	0f b7 c0             	movzwl %ax,%eax
}
  805013:	c9                   	leaveq 
  805014:	c3                   	retq   
