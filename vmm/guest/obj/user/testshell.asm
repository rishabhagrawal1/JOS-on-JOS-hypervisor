
vmm/guest/obj/user/testshell:     file format elf64-x86-64


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
  800057:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
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
  800091:	48 bf 60 52 80 00 00 	movabs $0x805260,%rdi
  800098:	00 00 00 
  80009b:	48 b8 96 33 80 00 00 	movabs $0x803396,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba 6d 52 80 00 00 	movabs $0x80526d,%rdx
  8000bc:	00 00 00 
  8000bf:	be 13 00 00 00       	mov    $0x13,%esi
  8000c4:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba 94 52 80 00 00 	movabs $0x805294,%rdx
  800108:	00 00 00 
  80010b:	be 15 00 00 00       	mov    $0x15,%esi
  800110:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf a0 52 80 00 00 	movabs $0x8052a0,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba c4 52 80 00 00 	movabs $0x8052c4,%rdx
  80016e:	00 00 00 
  800171:	be 1a 00 00 00       	mov    $0x1a,%esi
  800176:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
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
  8001a6:	48 b8 4a 2d 80 00 00 	movabs $0x802d4a,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 4a 2d 80 00 00 	movabs $0x802d4a,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba cd 52 80 00 00 	movabs $0x8052cd,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be d0 52 80 00 00 	movabs $0x8052d0,%rsi
  800200:	00 00 00 
  800203:	48 bf d3 52 80 00 00 	movabs $0x8052d3,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 ff 3c 80 00 00 	movabs $0x803cff,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba db 52 80 00 00 	movabs $0x8052db,%rdx
  800234:	00 00 00 
  800237:	be 21 00 00 00       	mov    $0x21,%esi
  80023c:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 c1 4a 80 00 00 	movabs $0x804ac1,%rax
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
  80029c:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf e5 52 80 00 00 	movabs $0x8052e5,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 96 33 80 00 00 	movabs $0x803396,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba f8 52 80 00 00 	movabs $0x8052f8,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2c 00 00 00       	mov    $0x2c,%esi
  8002f7:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
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
  800332:	48 b8 f3 2e 80 00 00 	movabs $0x802ef3,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 f3 2e 80 00 00 	movabs $0x802ef3,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba 1b 53 80 00 00 	movabs $0x80531b,%rdx
  800373:	00 00 00 
  800376:	be 33 00 00 00       	mov    $0x33,%esi
  80037b:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
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
  8003a2:	48 ba 35 53 80 00 00 	movabs $0x805335,%rdx
  8003a9:	00 00 00 
  8003ac:	be 35 00 00 00       	mov    $0x35,%esi
  8003b1:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
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
  800426:	48 bf 4f 53 80 00 00 	movabs $0x80534f,%rdi
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
  80045f:	48 b8 de 30 80 00 00 	movabs $0x8030de,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 de 30 80 00 00 	movabs $0x8030de,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf 68 53 80 00 00 	movabs $0x805368,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf 8a 53 80 00 00 	movabs $0x80538a,%rdi
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
  8004e6:	48 b8 f3 2e 80 00 00 	movabs $0x802ef3,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf 99 53 80 00 00 	movabs $0x805399,%rdi
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
  800545:	48 b8 f3 2e 80 00 00 	movabs $0x802ef3,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf a7 53 80 00 00 	movabs $0x8053a7,%rdi
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
  8005c7:	48 b8 f3 2e 80 00 00 	movabs $0x802ef3,%rax
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
  80060e:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
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
  800653:	48 b8 29 2a 80 00 00 	movabs $0x802a29,%rax
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
  8006bc:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
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
  800816:	48 be b1 53 80 00 00 	movabs $0x8053b1,%rsi
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
  8008bd:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
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
  800996:	48 bf c8 53 80 00 00 	movabs $0x8053c8,%rdi
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
  8009d2:	48 bf eb 53 80 00 00 	movabs $0x8053eb,%rdi
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
  800c81:	48 ba f0 55 80 00 00 	movabs $0x8055f0,%rdx
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
  800f79:	48 b8 18 56 80 00 00 	movabs $0x805618,%rax
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
  8010cc:	48 b8 40 55 80 00 00 	movabs $0x805540,%rax
  8010d3:	00 00 00 
  8010d6:	48 63 d3             	movslq %ebx,%rdx
  8010d9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8010dd:	4d 85 e4             	test   %r12,%r12
  8010e0:	75 2e                	jne    801110 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8010e2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010e6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010ea:	89 d9                	mov    %ebx,%ecx
  8010ec:	48 ba 01 56 80 00 00 	movabs $0x805601,%rdx
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
  80111b:	48 ba 0a 56 80 00 00 	movabs $0x80560a,%rdx
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
  801175:	49 bc 0d 56 80 00 00 	movabs $0x80560d,%r12
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
  801e7b:	48 ba c8 58 80 00 00 	movabs $0x8058c8,%rdx
  801e82:	00 00 00 
  801e85:	be 23 00 00 00       	mov    $0x23,%esi
  801e8a:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
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

0000000000802349 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802349:	55                   	push   %rbp
  80234a:	48 89 e5             	mov    %rsp,%rbp
  80234d:	48 83 ec 30          	sub    $0x30,%rsp
  802351:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802355:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802359:	48 8b 00             	mov    (%rax),%rax
  80235c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802360:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802364:	48 8b 40 08          	mov    0x8(%rax),%rax
  802368:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  80236b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80236e:	83 e0 02             	and    $0x2,%eax
  802371:	85 c0                	test   %eax,%eax
  802373:	75 4d                	jne    8023c2 <pgfault+0x79>
  802375:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802379:	48 c1 e8 0c          	shr    $0xc,%rax
  80237d:	48 89 c2             	mov    %rax,%rdx
  802380:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802387:	01 00 00 
  80238a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80238e:	25 00 08 00 00       	and    $0x800,%eax
  802393:	48 85 c0             	test   %rax,%rax
  802396:	74 2a                	je     8023c2 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  802398:	48 ba f8 58 80 00 00 	movabs $0x8058f8,%rdx
  80239f:	00 00 00 
  8023a2:	be 23 00 00 00       	mov    $0x23,%esi
  8023a7:	48 bf 2d 59 80 00 00 	movabs $0x80592d,%rdi
  8023ae:	00 00 00 
  8023b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b6:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  8023bd:	00 00 00 
  8023c0:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  8023c2:	ba 07 00 00 00       	mov    $0x7,%edx
  8023c7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d1:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8023d8:	00 00 00 
  8023db:	ff d0                	callq  *%rax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	0f 85 cd 00 00 00    	jne    8024b2 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  8023e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8023ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8023f7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  8023fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ff:	ba 00 10 00 00       	mov    $0x1000,%edx
  802404:	48 89 c6             	mov    %rax,%rsi
  802407:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80240c:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  802413:	00 00 00 
  802416:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802418:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80241c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802422:	48 89 c1             	mov    %rax,%rcx
  802425:	ba 00 00 00 00       	mov    $0x0,%edx
  80242a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80242f:	bf 00 00 00 00       	mov    $0x0,%edi
  802434:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  80243b:	00 00 00 
  80243e:	ff d0                	callq  *%rax
  802440:	85 c0                	test   %eax,%eax
  802442:	79 2a                	jns    80246e <pgfault+0x125>
				panic("Page map at temp address failed");
  802444:	48 ba 38 59 80 00 00 	movabs $0x805938,%rdx
  80244b:	00 00 00 
  80244e:	be 30 00 00 00       	mov    $0x30,%esi
  802453:	48 bf 2d 59 80 00 00 	movabs $0x80592d,%rdi
  80245a:	00 00 00 
  80245d:	b8 00 00 00 00       	mov    $0x0,%eax
  802462:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  802469:	00 00 00 
  80246c:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  80246e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802473:	bf 00 00 00 00       	mov    $0x0,%edi
  802478:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80247f:	00 00 00 
  802482:	ff d0                	callq  *%rax
  802484:	85 c0                	test   %eax,%eax
  802486:	79 54                	jns    8024dc <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802488:	48 ba 58 59 80 00 00 	movabs $0x805958,%rdx
  80248f:	00 00 00 
  802492:	be 32 00 00 00       	mov    $0x32,%esi
  802497:	48 bf 2d 59 80 00 00 	movabs $0x80592d,%rdi
  80249e:	00 00 00 
  8024a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a6:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  8024ad:	00 00 00 
  8024b0:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  8024b2:	48 ba 80 59 80 00 00 	movabs $0x805980,%rdx
  8024b9:	00 00 00 
  8024bc:	be 34 00 00 00       	mov    $0x34,%esi
  8024c1:	48 bf 2d 59 80 00 00 	movabs $0x80592d,%rdi
  8024c8:	00 00 00 
  8024cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d0:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  8024d7:	00 00 00 
  8024da:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8024dc:	c9                   	leaveq 
  8024dd:	c3                   	retq   

00000000008024de <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8024de:	55                   	push   %rbp
  8024df:	48 89 e5             	mov    %rsp,%rbp
  8024e2:	48 83 ec 20          	sub    $0x20,%rsp
  8024e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024e9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8024ec:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024f3:	01 00 00 
  8024f6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fd:	25 07 0e 00 00       	and    $0xe07,%eax
  802502:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802505:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802508:	48 c1 e0 0c          	shl    $0xc,%rax
  80250c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802510:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802513:	25 00 04 00 00       	and    $0x400,%eax
  802518:	85 c0                	test   %eax,%eax
  80251a:	74 57                	je     802573 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80251c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80251f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802523:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252a:	41 89 f0             	mov    %esi,%r8d
  80252d:	48 89 c6             	mov    %rax,%rsi
  802530:	bf 00 00 00 00       	mov    $0x0,%edi
  802535:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  80253c:	00 00 00 
  80253f:	ff d0                	callq  *%rax
  802541:	85 c0                	test   %eax,%eax
  802543:	0f 8e 52 01 00 00    	jle    80269b <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802549:	48 ba b2 59 80 00 00 	movabs $0x8059b2,%rdx
  802550:	00 00 00 
  802553:	be 4e 00 00 00       	mov    $0x4e,%esi
  802558:	48 bf 2d 59 80 00 00 	movabs $0x80592d,%rdi
  80255f:	00 00 00 
  802562:	b8 00 00 00 00       	mov    $0x0,%eax
  802567:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  80256e:	00 00 00 
  802571:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802576:	83 e0 02             	and    $0x2,%eax
  802579:	85 c0                	test   %eax,%eax
  80257b:	75 10                	jne    80258d <duppage+0xaf>
  80257d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802580:	25 00 08 00 00       	and    $0x800,%eax
  802585:	85 c0                	test   %eax,%eax
  802587:	0f 84 bb 00 00 00    	je     802648 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  80258d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802590:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802595:	80 cc 08             	or     $0x8,%ah
  802598:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80259b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80259e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8025a2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a9:	41 89 f0             	mov    %esi,%r8d
  8025ac:	48 89 c6             	mov    %rax,%rsi
  8025af:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b4:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  8025bb:	00 00 00 
  8025be:	ff d0                	callq  *%rax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	7e 2a                	jle    8025ee <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8025c4:	48 ba b2 59 80 00 00 	movabs $0x8059b2,%rdx
  8025cb:	00 00 00 
  8025ce:	be 55 00 00 00       	mov    $0x55,%esi
  8025d3:	48 bf 2d 59 80 00 00 	movabs $0x80592d,%rdi
  8025da:	00 00 00 
  8025dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e2:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  8025e9:	00 00 00 
  8025ec:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8025ee:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8025f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f9:	41 89 c8             	mov    %ecx,%r8d
  8025fc:	48 89 d1             	mov    %rdx,%rcx
  8025ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802604:	48 89 c6             	mov    %rax,%rsi
  802607:	bf 00 00 00 00       	mov    $0x0,%edi
  80260c:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
  802618:	85 c0                	test   %eax,%eax
  80261a:	7e 2a                	jle    802646 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80261c:	48 ba b2 59 80 00 00 	movabs $0x8059b2,%rdx
  802623:	00 00 00 
  802626:	be 57 00 00 00       	mov    $0x57,%esi
  80262b:	48 bf 2d 59 80 00 00 	movabs $0x80592d,%rdi
  802632:	00 00 00 
  802635:	b8 00 00 00 00       	mov    $0x0,%eax
  80263a:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  802641:	00 00 00 
  802644:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802646:	eb 53                	jmp    80269b <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802648:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80264b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80264f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802656:	41 89 f0             	mov    %esi,%r8d
  802659:	48 89 c6             	mov    %rax,%rsi
  80265c:	bf 00 00 00 00       	mov    $0x0,%edi
  802661:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802668:	00 00 00 
  80266b:	ff d0                	callq  *%rax
  80266d:	85 c0                	test   %eax,%eax
  80266f:	7e 2a                	jle    80269b <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802671:	48 ba b2 59 80 00 00 	movabs $0x8059b2,%rdx
  802678:	00 00 00 
  80267b:	be 5b 00 00 00       	mov    $0x5b,%esi
  802680:	48 bf 2d 59 80 00 00 	movabs $0x80592d,%rdi
  802687:	00 00 00 
  80268a:	b8 00 00 00 00       	mov    $0x0,%eax
  80268f:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  802696:	00 00 00 
  802699:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80269b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a0:	c9                   	leaveq 
  8026a1:	c3                   	retq   

00000000008026a2 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8026a2:	55                   	push   %rbp
  8026a3:	48 89 e5             	mov    %rsp,%rbp
  8026a6:	48 83 ec 18          	sub    $0x18,%rsp
  8026aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8026ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8026b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026ba:	48 c1 e8 27          	shr    $0x27,%rax
  8026be:	48 89 c2             	mov    %rax,%rdx
  8026c1:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8026c8:	01 00 00 
  8026cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026cf:	83 e0 01             	and    $0x1,%eax
  8026d2:	48 85 c0             	test   %rax,%rax
  8026d5:	74 51                	je     802728 <pt_is_mapped+0x86>
  8026d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026db:	48 c1 e0 0c          	shl    $0xc,%rax
  8026df:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026e3:	48 89 c2             	mov    %rax,%rdx
  8026e6:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8026ed:	01 00 00 
  8026f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f4:	83 e0 01             	and    $0x1,%eax
  8026f7:	48 85 c0             	test   %rax,%rax
  8026fa:	74 2c                	je     802728 <pt_is_mapped+0x86>
  8026fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802700:	48 c1 e0 0c          	shl    $0xc,%rax
  802704:	48 c1 e8 15          	shr    $0x15,%rax
  802708:	48 89 c2             	mov    %rax,%rdx
  80270b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802712:	01 00 00 
  802715:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802719:	83 e0 01             	and    $0x1,%eax
  80271c:	48 85 c0             	test   %rax,%rax
  80271f:	74 07                	je     802728 <pt_is_mapped+0x86>
  802721:	b8 01 00 00 00       	mov    $0x1,%eax
  802726:	eb 05                	jmp    80272d <pt_is_mapped+0x8b>
  802728:	b8 00 00 00 00       	mov    $0x0,%eax
  80272d:	83 e0 01             	and    $0x1,%eax
}
  802730:	c9                   	leaveq 
  802731:	c3                   	retq   

0000000000802732 <fork>:

envid_t
fork(void)
{
  802732:	55                   	push   %rbp
  802733:	48 89 e5             	mov    %rsp,%rbp
  802736:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80273a:	48 bf 49 23 80 00 00 	movabs $0x802349,%rdi
  802741:	00 00 00 
  802744:	48 b8 56 4b 80 00 00 	movabs $0x804b56,%rax
  80274b:	00 00 00 
  80274e:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802750:	b8 07 00 00 00       	mov    $0x7,%eax
  802755:	cd 30                	int    $0x30
  802757:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80275a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80275d:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802760:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802764:	79 30                	jns    802796 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802766:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802769:	89 c1                	mov    %eax,%ecx
  80276b:	48 ba d0 59 80 00 00 	movabs $0x8059d0,%rdx
  802772:	00 00 00 
  802775:	be 86 00 00 00       	mov    $0x86,%esi
  80277a:	48 bf 2d 59 80 00 00 	movabs $0x80592d,%rdi
  802781:	00 00 00 
  802784:	b8 00 00 00 00       	mov    $0x0,%eax
  802789:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  802790:	00 00 00 
  802793:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802796:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80279a:	75 3e                	jne    8027da <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80279c:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  8027a3:	00 00 00 
  8027a6:	ff d0                	callq  *%rax
  8027a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8027ad:	48 98                	cltq   
  8027af:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8027b6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8027bd:	00 00 00 
  8027c0:	48 01 c2             	add    %rax,%rdx
  8027c3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8027ca:	00 00 00 
  8027cd:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8027d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d5:	e9 d1 01 00 00       	jmpq   8029ab <fork+0x279>
	}
	uint64_t ad = 0;
  8027da:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8027e1:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8027e2:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8027e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8027eb:	e9 df 00 00 00       	jmpq   8028cf <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8027f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027f4:	48 c1 e8 27          	shr    $0x27,%rax
  8027f8:	48 89 c2             	mov    %rax,%rdx
  8027fb:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802802:	01 00 00 
  802805:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802809:	83 e0 01             	and    $0x1,%eax
  80280c:	48 85 c0             	test   %rax,%rax
  80280f:	0f 84 9e 00 00 00    	je     8028b3 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802815:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802819:	48 c1 e8 1e          	shr    $0x1e,%rax
  80281d:	48 89 c2             	mov    %rax,%rdx
  802820:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802827:	01 00 00 
  80282a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80282e:	83 e0 01             	and    $0x1,%eax
  802831:	48 85 c0             	test   %rax,%rax
  802834:	74 73                	je     8028a9 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  802836:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80283a:	48 c1 e8 15          	shr    $0x15,%rax
  80283e:	48 89 c2             	mov    %rax,%rdx
  802841:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802848:	01 00 00 
  80284b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80284f:	83 e0 01             	and    $0x1,%eax
  802852:	48 85 c0             	test   %rax,%rax
  802855:	74 48                	je     80289f <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802857:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80285b:	48 c1 e8 0c          	shr    $0xc,%rax
  80285f:	48 89 c2             	mov    %rax,%rdx
  802862:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802869:	01 00 00 
  80286c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802870:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802878:	83 e0 01             	and    $0x1,%eax
  80287b:	48 85 c0             	test   %rax,%rax
  80287e:	74 47                	je     8028c7 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802880:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802884:	48 c1 e8 0c          	shr    $0xc,%rax
  802888:	89 c2                	mov    %eax,%edx
  80288a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80288d:	89 d6                	mov    %edx,%esi
  80288f:	89 c7                	mov    %eax,%edi
  802891:	48 b8 de 24 80 00 00 	movabs $0x8024de,%rax
  802898:	00 00 00 
  80289b:	ff d0                	callq  *%rax
  80289d:	eb 28                	jmp    8028c7 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80289f:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8028a6:	00 
  8028a7:	eb 1e                	jmp    8028c7 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8028a9:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8028b0:	40 
  8028b1:	eb 14                	jmp    8028c7 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8028b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028b7:	48 c1 e8 27          	shr    $0x27,%rax
  8028bb:	48 83 c0 01          	add    $0x1,%rax
  8028bf:	48 c1 e0 27          	shl    $0x27,%rax
  8028c3:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8028c7:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8028ce:	00 
  8028cf:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8028d6:	00 
  8028d7:	0f 87 13 ff ff ff    	ja     8027f0 <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8028dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028e0:	ba 07 00 00 00       	mov    $0x7,%edx
  8028e5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8028ea:	89 c7                	mov    %eax,%edi
  8028ec:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8028f3:	00 00 00 
  8028f6:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8028f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028fb:	ba 07 00 00 00       	mov    $0x7,%edx
  802900:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802905:	89 c7                	mov    %eax,%edi
  802907:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  80290e:	00 00 00 
  802911:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802913:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802916:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80291c:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802921:	ba 00 00 00 00       	mov    $0x0,%edx
  802926:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80292b:	89 c7                	mov    %eax,%edi
  80292d:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802934:	00 00 00 
  802937:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802939:	ba 00 10 00 00       	mov    $0x1000,%edx
  80293e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802943:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802948:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  80294f:	00 00 00 
  802952:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802954:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802959:	bf 00 00 00 00       	mov    $0x0,%edi
  80295e:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802965:	00 00 00 
  802968:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80296a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802971:	00 00 00 
  802974:	48 8b 00             	mov    (%rax),%rax
  802977:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80297e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802981:	48 89 d6             	mov    %rdx,%rsi
  802984:	89 c7                	mov    %eax,%edi
  802986:	48 b8 83 21 80 00 00 	movabs $0x802183,%rax
  80298d:	00 00 00 
  802990:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802992:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802995:	be 02 00 00 00       	mov    $0x2,%esi
  80299a:	89 c7                	mov    %eax,%edi
  80299c:	48 b8 ee 20 80 00 00 	movabs $0x8020ee,%rax
  8029a3:	00 00 00 
  8029a6:	ff d0                	callq  *%rax

	return envid;
  8029a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8029ab:	c9                   	leaveq 
  8029ac:	c3                   	retq   

00000000008029ad <sfork>:

	
// Challenge!
int
sfork(void)
{
  8029ad:	55                   	push   %rbp
  8029ae:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8029b1:	48 ba e8 59 80 00 00 	movabs $0x8059e8,%rdx
  8029b8:	00 00 00 
  8029bb:	be bf 00 00 00       	mov    $0xbf,%esi
  8029c0:	48 bf 2d 59 80 00 00 	movabs $0x80592d,%rdi
  8029c7:	00 00 00 
  8029ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8029cf:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  8029d6:	00 00 00 
  8029d9:	ff d1                	callq  *%rcx

00000000008029db <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8029db:	55                   	push   %rbp
  8029dc:	48 89 e5             	mov    %rsp,%rbp
  8029df:	48 83 ec 08          	sub    $0x8,%rsp
  8029e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8029e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029eb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8029f2:	ff ff ff 
  8029f5:	48 01 d0             	add    %rdx,%rax
  8029f8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8029fc:	c9                   	leaveq 
  8029fd:	c3                   	retq   

00000000008029fe <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8029fe:	55                   	push   %rbp
  8029ff:	48 89 e5             	mov    %rsp,%rbp
  802a02:	48 83 ec 08          	sub    $0x8,%rsp
  802a06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802a0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a0e:	48 89 c7             	mov    %rax,%rdi
  802a11:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  802a18:	00 00 00 
  802a1b:	ff d0                	callq  *%rax
  802a1d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802a23:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802a27:	c9                   	leaveq 
  802a28:	c3                   	retq   

0000000000802a29 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802a29:	55                   	push   %rbp
  802a2a:	48 89 e5             	mov    %rsp,%rbp
  802a2d:	48 83 ec 18          	sub    $0x18,%rsp
  802a31:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a3c:	eb 6b                	jmp    802aa9 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a41:	48 98                	cltq   
  802a43:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a49:	48 c1 e0 0c          	shl    $0xc,%rax
  802a4d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802a51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a55:	48 c1 e8 15          	shr    $0x15,%rax
  802a59:	48 89 c2             	mov    %rax,%rdx
  802a5c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a63:	01 00 00 
  802a66:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a6a:	83 e0 01             	and    $0x1,%eax
  802a6d:	48 85 c0             	test   %rax,%rax
  802a70:	74 21                	je     802a93 <fd_alloc+0x6a>
  802a72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a76:	48 c1 e8 0c          	shr    $0xc,%rax
  802a7a:	48 89 c2             	mov    %rax,%rdx
  802a7d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a84:	01 00 00 
  802a87:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a8b:	83 e0 01             	and    $0x1,%eax
  802a8e:	48 85 c0             	test   %rax,%rax
  802a91:	75 12                	jne    802aa5 <fd_alloc+0x7c>
			*fd_store = fd;
  802a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a97:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a9b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa3:	eb 1a                	jmp    802abf <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802aa5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802aa9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802aad:	7e 8f                	jle    802a3e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802aaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802aba:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802abf:	c9                   	leaveq 
  802ac0:	c3                   	retq   

0000000000802ac1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802ac1:	55                   	push   %rbp
  802ac2:	48 89 e5             	mov    %rsp,%rbp
  802ac5:	48 83 ec 20          	sub    $0x20,%rsp
  802ac9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802acc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802ad0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ad4:	78 06                	js     802adc <fd_lookup+0x1b>
  802ad6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802ada:	7e 07                	jle    802ae3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802adc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ae1:	eb 6c                	jmp    802b4f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802ae3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ae6:	48 98                	cltq   
  802ae8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802aee:	48 c1 e0 0c          	shl    $0xc,%rax
  802af2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802af6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802afa:	48 c1 e8 15          	shr    $0x15,%rax
  802afe:	48 89 c2             	mov    %rax,%rdx
  802b01:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b08:	01 00 00 
  802b0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b0f:	83 e0 01             	and    $0x1,%eax
  802b12:	48 85 c0             	test   %rax,%rax
  802b15:	74 21                	je     802b38 <fd_lookup+0x77>
  802b17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b1b:	48 c1 e8 0c          	shr    $0xc,%rax
  802b1f:	48 89 c2             	mov    %rax,%rdx
  802b22:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b29:	01 00 00 
  802b2c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b30:	83 e0 01             	and    $0x1,%eax
  802b33:	48 85 c0             	test   %rax,%rax
  802b36:	75 07                	jne    802b3f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b3d:	eb 10                	jmp    802b4f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802b3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b43:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b47:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b4f:	c9                   	leaveq 
  802b50:	c3                   	retq   

0000000000802b51 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802b51:	55                   	push   %rbp
  802b52:	48 89 e5             	mov    %rsp,%rbp
  802b55:	48 83 ec 30          	sub    $0x30,%rsp
  802b59:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b5d:	89 f0                	mov    %esi,%eax
  802b5f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b66:	48 89 c7             	mov    %rax,%rdi
  802b69:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  802b70:	00 00 00 
  802b73:	ff d0                	callq  *%rax
  802b75:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b79:	48 89 d6             	mov    %rdx,%rsi
  802b7c:	89 c7                	mov    %eax,%edi
  802b7e:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  802b85:	00 00 00 
  802b88:	ff d0                	callq  *%rax
  802b8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b91:	78 0a                	js     802b9d <fd_close+0x4c>
	    || fd != fd2)
  802b93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b97:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802b9b:	74 12                	je     802baf <fd_close+0x5e>
		return (must_exist ? r : 0);
  802b9d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802ba1:	74 05                	je     802ba8 <fd_close+0x57>
  802ba3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba6:	eb 05                	jmp    802bad <fd_close+0x5c>
  802ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bad:	eb 69                	jmp    802c18 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802baf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bb3:	8b 00                	mov    (%rax),%eax
  802bb5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bb9:	48 89 d6             	mov    %rdx,%rsi
  802bbc:	89 c7                	mov    %eax,%edi
  802bbe:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  802bc5:	00 00 00 
  802bc8:	ff d0                	callq  *%rax
  802bca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd1:	78 2a                	js     802bfd <fd_close+0xac>
		if (dev->dev_close)
  802bd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd7:	48 8b 40 20          	mov    0x20(%rax),%rax
  802bdb:	48 85 c0             	test   %rax,%rax
  802bde:	74 16                	je     802bf6 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802be0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be4:	48 8b 40 20          	mov    0x20(%rax),%rax
  802be8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bec:	48 89 d7             	mov    %rdx,%rdi
  802bef:	ff d0                	callq  *%rax
  802bf1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf4:	eb 07                	jmp    802bfd <fd_close+0xac>
		else
			r = 0;
  802bf6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802bfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c01:	48 89 c6             	mov    %rax,%rsi
  802c04:	bf 00 00 00 00       	mov    $0x0,%edi
  802c09:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802c10:	00 00 00 
  802c13:	ff d0                	callq  *%rax
	return r;
  802c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c18:	c9                   	leaveq 
  802c19:	c3                   	retq   

0000000000802c1a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802c1a:	55                   	push   %rbp
  802c1b:	48 89 e5             	mov    %rsp,%rbp
  802c1e:	48 83 ec 20          	sub    $0x20,%rsp
  802c22:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802c29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c30:	eb 41                	jmp    802c73 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802c32:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802c39:	00 00 00 
  802c3c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c3f:	48 63 d2             	movslq %edx,%rdx
  802c42:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c46:	8b 00                	mov    (%rax),%eax
  802c48:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802c4b:	75 22                	jne    802c6f <dev_lookup+0x55>
			*dev = devtab[i];
  802c4d:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802c54:	00 00 00 
  802c57:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c5a:	48 63 d2             	movslq %edx,%rdx
  802c5d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802c61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c65:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802c68:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6d:	eb 60                	jmp    802ccf <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802c6f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c73:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802c7a:	00 00 00 
  802c7d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c80:	48 63 d2             	movslq %edx,%rdx
  802c83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c87:	48 85 c0             	test   %rax,%rax
  802c8a:	75 a6                	jne    802c32 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802c8c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c93:	00 00 00 
  802c96:	48 8b 00             	mov    (%rax),%rax
  802c99:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c9f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ca2:	89 c6                	mov    %eax,%esi
  802ca4:	48 bf 00 5a 80 00 00 	movabs $0x805a00,%rdi
  802cab:	00 00 00 
  802cae:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb3:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  802cba:	00 00 00 
  802cbd:	ff d1                	callq  *%rcx
	*dev = 0;
  802cbf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cc3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802cca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ccf:	c9                   	leaveq 
  802cd0:	c3                   	retq   

0000000000802cd1 <close>:

int
close(int fdnum)
{
  802cd1:	55                   	push   %rbp
  802cd2:	48 89 e5             	mov    %rsp,%rbp
  802cd5:	48 83 ec 20          	sub    $0x20,%rsp
  802cd9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cdc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ce0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ce3:	48 89 d6             	mov    %rdx,%rsi
  802ce6:	89 c7                	mov    %eax,%edi
  802ce8:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  802cef:	00 00 00 
  802cf2:	ff d0                	callq  *%rax
  802cf4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cfb:	79 05                	jns    802d02 <close+0x31>
		return r;
  802cfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d00:	eb 18                	jmp    802d1a <close+0x49>
	else
		return fd_close(fd, 1);
  802d02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d06:	be 01 00 00 00       	mov    $0x1,%esi
  802d0b:	48 89 c7             	mov    %rax,%rdi
  802d0e:	48 b8 51 2b 80 00 00 	movabs $0x802b51,%rax
  802d15:	00 00 00 
  802d18:	ff d0                	callq  *%rax
}
  802d1a:	c9                   	leaveq 
  802d1b:	c3                   	retq   

0000000000802d1c <close_all>:

void
close_all(void)
{
  802d1c:	55                   	push   %rbp
  802d1d:	48 89 e5             	mov    %rsp,%rbp
  802d20:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802d24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d2b:	eb 15                	jmp    802d42 <close_all+0x26>
		close(i);
  802d2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d30:	89 c7                	mov    %eax,%edi
  802d32:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  802d39:	00 00 00 
  802d3c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802d3e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d42:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802d46:	7e e5                	jle    802d2d <close_all+0x11>
		close(i);
}
  802d48:	c9                   	leaveq 
  802d49:	c3                   	retq   

0000000000802d4a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802d4a:	55                   	push   %rbp
  802d4b:	48 89 e5             	mov    %rsp,%rbp
  802d4e:	48 83 ec 40          	sub    $0x40,%rsp
  802d52:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802d55:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802d58:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802d5c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802d5f:	48 89 d6             	mov    %rdx,%rsi
  802d62:	89 c7                	mov    %eax,%edi
  802d64:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  802d6b:	00 00 00 
  802d6e:	ff d0                	callq  *%rax
  802d70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d77:	79 08                	jns    802d81 <dup+0x37>
		return r;
  802d79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7c:	e9 70 01 00 00       	jmpq   802ef1 <dup+0x1a7>
	close(newfdnum);
  802d81:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d84:	89 c7                	mov    %eax,%edi
  802d86:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  802d8d:	00 00 00 
  802d90:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802d92:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d95:	48 98                	cltq   
  802d97:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802d9d:	48 c1 e0 0c          	shl    $0xc,%rax
  802da1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802da5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802da9:	48 89 c7             	mov    %rax,%rdi
  802dac:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  802db3:	00 00 00 
  802db6:	ff d0                	callq  *%rax
  802db8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802dbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc0:	48 89 c7             	mov    %rax,%rdi
  802dc3:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
  802dcf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802dd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd7:	48 c1 e8 15          	shr    $0x15,%rax
  802ddb:	48 89 c2             	mov    %rax,%rdx
  802dde:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802de5:	01 00 00 
  802de8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dec:	83 e0 01             	and    $0x1,%eax
  802def:	48 85 c0             	test   %rax,%rax
  802df2:	74 73                	je     802e67 <dup+0x11d>
  802df4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df8:	48 c1 e8 0c          	shr    $0xc,%rax
  802dfc:	48 89 c2             	mov    %rax,%rdx
  802dff:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e06:	01 00 00 
  802e09:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e0d:	83 e0 01             	and    $0x1,%eax
  802e10:	48 85 c0             	test   %rax,%rax
  802e13:	74 52                	je     802e67 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802e15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e19:	48 c1 e8 0c          	shr    $0xc,%rax
  802e1d:	48 89 c2             	mov    %rax,%rdx
  802e20:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e27:	01 00 00 
  802e2a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e2e:	25 07 0e 00 00       	and    $0xe07,%eax
  802e33:	89 c1                	mov    %eax,%ecx
  802e35:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3d:	41 89 c8             	mov    %ecx,%r8d
  802e40:	48 89 d1             	mov    %rdx,%rcx
  802e43:	ba 00 00 00 00       	mov    $0x0,%edx
  802e48:	48 89 c6             	mov    %rax,%rsi
  802e4b:	bf 00 00 00 00       	mov    $0x0,%edi
  802e50:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802e57:	00 00 00 
  802e5a:	ff d0                	callq  *%rax
  802e5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e63:	79 02                	jns    802e67 <dup+0x11d>
			goto err;
  802e65:	eb 57                	jmp    802ebe <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802e67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e6b:	48 c1 e8 0c          	shr    $0xc,%rax
  802e6f:	48 89 c2             	mov    %rax,%rdx
  802e72:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e79:	01 00 00 
  802e7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e80:	25 07 0e 00 00       	and    $0xe07,%eax
  802e85:	89 c1                	mov    %eax,%ecx
  802e87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e8f:	41 89 c8             	mov    %ecx,%r8d
  802e92:	48 89 d1             	mov    %rdx,%rcx
  802e95:	ba 00 00 00 00       	mov    $0x0,%edx
  802e9a:	48 89 c6             	mov    %rax,%rsi
  802e9d:	bf 00 00 00 00       	mov    $0x0,%edi
  802ea2:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802ea9:	00 00 00 
  802eac:	ff d0                	callq  *%rax
  802eae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb5:	79 02                	jns    802eb9 <dup+0x16f>
		goto err;
  802eb7:	eb 05                	jmp    802ebe <dup+0x174>

	return newfdnum;
  802eb9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ebc:	eb 33                	jmp    802ef1 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec2:	48 89 c6             	mov    %rax,%rsi
  802ec5:	bf 00 00 00 00       	mov    $0x0,%edi
  802eca:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802ed1:	00 00 00 
  802ed4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ed6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eda:	48 89 c6             	mov    %rax,%rsi
  802edd:	bf 00 00 00 00       	mov    $0x0,%edi
  802ee2:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802ee9:	00 00 00 
  802eec:	ff d0                	callq  *%rax
	return r;
  802eee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ef1:	c9                   	leaveq 
  802ef2:	c3                   	retq   

0000000000802ef3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ef3:	55                   	push   %rbp
  802ef4:	48 89 e5             	mov    %rsp,%rbp
  802ef7:	48 83 ec 40          	sub    $0x40,%rsp
  802efb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802efe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f02:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f06:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f0a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f0d:	48 89 d6             	mov    %rdx,%rsi
  802f10:	89 c7                	mov    %eax,%edi
  802f12:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  802f19:	00 00 00 
  802f1c:	ff d0                	callq  *%rax
  802f1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f25:	78 24                	js     802f4b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2b:	8b 00                	mov    (%rax),%eax
  802f2d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f31:	48 89 d6             	mov    %rdx,%rsi
  802f34:	89 c7                	mov    %eax,%edi
  802f36:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	callq  *%rax
  802f42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f49:	79 05                	jns    802f50 <read+0x5d>
		return r;
  802f4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4e:	eb 76                	jmp    802fc6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802f50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f54:	8b 40 08             	mov    0x8(%rax),%eax
  802f57:	83 e0 03             	and    $0x3,%eax
  802f5a:	83 f8 01             	cmp    $0x1,%eax
  802f5d:	75 3a                	jne    802f99 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802f5f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802f66:	00 00 00 
  802f69:	48 8b 00             	mov    (%rax),%rax
  802f6c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f72:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f75:	89 c6                	mov    %eax,%esi
  802f77:	48 bf 1f 5a 80 00 00 	movabs $0x805a1f,%rdi
  802f7e:	00 00 00 
  802f81:	b8 00 00 00 00       	mov    $0x0,%eax
  802f86:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  802f8d:	00 00 00 
  802f90:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f97:	eb 2d                	jmp    802fc6 <read+0xd3>
	}
	if (!dev->dev_read)
  802f99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802fa1:	48 85 c0             	test   %rax,%rax
  802fa4:	75 07                	jne    802fad <read+0xba>
		return -E_NOT_SUPP;
  802fa6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fab:	eb 19                	jmp    802fc6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb1:	48 8b 40 10          	mov    0x10(%rax),%rax
  802fb5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fb9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fbd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fc1:	48 89 cf             	mov    %rcx,%rdi
  802fc4:	ff d0                	callq  *%rax
}
  802fc6:	c9                   	leaveq 
  802fc7:	c3                   	retq   

0000000000802fc8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802fc8:	55                   	push   %rbp
  802fc9:	48 89 e5             	mov    %rsp,%rbp
  802fcc:	48 83 ec 30          	sub    $0x30,%rsp
  802fd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802fdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802fe2:	eb 49                	jmp    80302d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802fe4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe7:	48 98                	cltq   
  802fe9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fed:	48 29 c2             	sub    %rax,%rdx
  802ff0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff3:	48 63 c8             	movslq %eax,%rcx
  802ff6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ffa:	48 01 c1             	add    %rax,%rcx
  802ffd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803000:	48 89 ce             	mov    %rcx,%rsi
  803003:	89 c7                	mov    %eax,%edi
  803005:	48 b8 f3 2e 80 00 00 	movabs $0x802ef3,%rax
  80300c:	00 00 00 
  80300f:	ff d0                	callq  *%rax
  803011:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803014:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803018:	79 05                	jns    80301f <readn+0x57>
			return m;
  80301a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80301d:	eb 1c                	jmp    80303b <readn+0x73>
		if (m == 0)
  80301f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803023:	75 02                	jne    803027 <readn+0x5f>
			break;
  803025:	eb 11                	jmp    803038 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803027:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80302a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80302d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803030:	48 98                	cltq   
  803032:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803036:	72 ac                	jb     802fe4 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803038:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80303b:	c9                   	leaveq 
  80303c:	c3                   	retq   

000000000080303d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80303d:	55                   	push   %rbp
  80303e:	48 89 e5             	mov    %rsp,%rbp
  803041:	48 83 ec 40          	sub    $0x40,%rsp
  803045:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803048:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80304c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803050:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803054:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803057:	48 89 d6             	mov    %rdx,%rsi
  80305a:	89 c7                	mov    %eax,%edi
  80305c:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  803063:	00 00 00 
  803066:	ff d0                	callq  *%rax
  803068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80306b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80306f:	78 24                	js     803095 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803075:	8b 00                	mov    (%rax),%eax
  803077:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80307b:	48 89 d6             	mov    %rdx,%rsi
  80307e:	89 c7                	mov    %eax,%edi
  803080:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  803087:	00 00 00 
  80308a:	ff d0                	callq  *%rax
  80308c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80308f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803093:	79 05                	jns    80309a <write+0x5d>
		return r;
  803095:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803098:	eb 42                	jmp    8030dc <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80309a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309e:	8b 40 08             	mov    0x8(%rax),%eax
  8030a1:	83 e0 03             	and    $0x3,%eax
  8030a4:	85 c0                	test   %eax,%eax
  8030a6:	75 07                	jne    8030af <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8030a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030ad:	eb 2d                	jmp    8030dc <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8030af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8030b7:	48 85 c0             	test   %rax,%rax
  8030ba:	75 07                	jne    8030c3 <write+0x86>
		return -E_NOT_SUPP;
  8030bc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030c1:	eb 19                	jmp    8030dc <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8030c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8030cb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030cf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030d3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8030d7:	48 89 cf             	mov    %rcx,%rdi
  8030da:	ff d0                	callq  *%rax
}
  8030dc:	c9                   	leaveq 
  8030dd:	c3                   	retq   

00000000008030de <seek>:

int
seek(int fdnum, off_t offset)
{
  8030de:	55                   	push   %rbp
  8030df:	48 89 e5             	mov    %rsp,%rbp
  8030e2:	48 83 ec 18          	sub    $0x18,%rsp
  8030e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030e9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030f3:	48 89 d6             	mov    %rdx,%rsi
  8030f6:	89 c7                	mov    %eax,%edi
  8030f8:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  8030ff:	00 00 00 
  803102:	ff d0                	callq  *%rax
  803104:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803107:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80310b:	79 05                	jns    803112 <seek+0x34>
		return r;
  80310d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803110:	eb 0f                	jmp    803121 <seek+0x43>
	fd->fd_offset = offset;
  803112:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803116:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803119:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80311c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803121:	c9                   	leaveq 
  803122:	c3                   	retq   

0000000000803123 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803123:	55                   	push   %rbp
  803124:	48 89 e5             	mov    %rsp,%rbp
  803127:	48 83 ec 30          	sub    $0x30,%rsp
  80312b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80312e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803131:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803135:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803138:	48 89 d6             	mov    %rdx,%rsi
  80313b:	89 c7                	mov    %eax,%edi
  80313d:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  803144:	00 00 00 
  803147:	ff d0                	callq  *%rax
  803149:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803150:	78 24                	js     803176 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803156:	8b 00                	mov    (%rax),%eax
  803158:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80315c:	48 89 d6             	mov    %rdx,%rsi
  80315f:	89 c7                	mov    %eax,%edi
  803161:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  803168:	00 00 00 
  80316b:	ff d0                	callq  *%rax
  80316d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803170:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803174:	79 05                	jns    80317b <ftruncate+0x58>
		return r;
  803176:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803179:	eb 72                	jmp    8031ed <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80317b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80317f:	8b 40 08             	mov    0x8(%rax),%eax
  803182:	83 e0 03             	and    $0x3,%eax
  803185:	85 c0                	test   %eax,%eax
  803187:	75 3a                	jne    8031c3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803189:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803190:	00 00 00 
  803193:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803196:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80319c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80319f:	89 c6                	mov    %eax,%esi
  8031a1:	48 bf 40 5a 80 00 00 	movabs $0x805a40,%rdi
  8031a8:	00 00 00 
  8031ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b0:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  8031b7:	00 00 00 
  8031ba:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8031bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031c1:	eb 2a                	jmp    8031ed <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8031c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8031cb:	48 85 c0             	test   %rax,%rax
  8031ce:	75 07                	jne    8031d7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8031d0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031d5:	eb 16                	jmp    8031ed <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8031d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031db:	48 8b 40 30          	mov    0x30(%rax),%rax
  8031df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031e3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8031e6:	89 ce                	mov    %ecx,%esi
  8031e8:	48 89 d7             	mov    %rdx,%rdi
  8031eb:	ff d0                	callq  *%rax
}
  8031ed:	c9                   	leaveq 
  8031ee:	c3                   	retq   

00000000008031ef <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8031ef:	55                   	push   %rbp
  8031f0:	48 89 e5             	mov    %rsp,%rbp
  8031f3:	48 83 ec 30          	sub    $0x30,%rsp
  8031f7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031fe:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803202:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803205:	48 89 d6             	mov    %rdx,%rsi
  803208:	89 c7                	mov    %eax,%edi
  80320a:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  803211:	00 00 00 
  803214:	ff d0                	callq  *%rax
  803216:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803219:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321d:	78 24                	js     803243 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80321f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803223:	8b 00                	mov    (%rax),%eax
  803225:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803229:	48 89 d6             	mov    %rdx,%rsi
  80322c:	89 c7                	mov    %eax,%edi
  80322e:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  803235:	00 00 00 
  803238:	ff d0                	callq  *%rax
  80323a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80323d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803241:	79 05                	jns    803248 <fstat+0x59>
		return r;
  803243:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803246:	eb 5e                	jmp    8032a6 <fstat+0xb7>
	if (!dev->dev_stat)
  803248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80324c:	48 8b 40 28          	mov    0x28(%rax),%rax
  803250:	48 85 c0             	test   %rax,%rax
  803253:	75 07                	jne    80325c <fstat+0x6d>
		return -E_NOT_SUPP;
  803255:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80325a:	eb 4a                	jmp    8032a6 <fstat+0xb7>
	stat->st_name[0] = 0;
  80325c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803260:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803263:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803267:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80326e:	00 00 00 
	stat->st_isdir = 0;
  803271:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803275:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80327c:	00 00 00 
	stat->st_dev = dev;
  80327f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803283:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803287:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80328e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803292:	48 8b 40 28          	mov    0x28(%rax),%rax
  803296:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80329a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80329e:	48 89 ce             	mov    %rcx,%rsi
  8032a1:	48 89 d7             	mov    %rdx,%rdi
  8032a4:	ff d0                	callq  *%rax
}
  8032a6:	c9                   	leaveq 
  8032a7:	c3                   	retq   

00000000008032a8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8032a8:	55                   	push   %rbp
  8032a9:	48 89 e5             	mov    %rsp,%rbp
  8032ac:	48 83 ec 20          	sub    $0x20,%rsp
  8032b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8032b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032bc:	be 00 00 00 00       	mov    $0x0,%esi
  8032c1:	48 89 c7             	mov    %rax,%rdi
  8032c4:	48 b8 96 33 80 00 00 	movabs $0x803396,%rax
  8032cb:	00 00 00 
  8032ce:	ff d0                	callq  *%rax
  8032d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d7:	79 05                	jns    8032de <stat+0x36>
		return fd;
  8032d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032dc:	eb 2f                	jmp    80330d <stat+0x65>
	r = fstat(fd, stat);
  8032de:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8032e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e5:	48 89 d6             	mov    %rdx,%rsi
  8032e8:	89 c7                	mov    %eax,%edi
  8032ea:	48 b8 ef 31 80 00 00 	movabs $0x8031ef,%rax
  8032f1:	00 00 00 
  8032f4:	ff d0                	callq  *%rax
  8032f6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8032f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fc:	89 c7                	mov    %eax,%edi
  8032fe:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  803305:	00 00 00 
  803308:	ff d0                	callq  *%rax
	return r;
  80330a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80330d:	c9                   	leaveq 
  80330e:	c3                   	retq   

000000000080330f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80330f:	55                   	push   %rbp
  803310:	48 89 e5             	mov    %rsp,%rbp
  803313:	48 83 ec 10          	sub    $0x10,%rsp
  803317:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80331a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80331e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803325:	00 00 00 
  803328:	8b 00                	mov    (%rax),%eax
  80332a:	85 c0                	test   %eax,%eax
  80332c:	75 1d                	jne    80334b <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80332e:	bf 01 00 00 00       	mov    $0x1,%edi
  803333:	48 b8 61 51 80 00 00 	movabs $0x805161,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
  80333f:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803346:	00 00 00 
  803349:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80334b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803352:	00 00 00 
  803355:	8b 00                	mov    (%rax),%eax
  803357:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80335a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80335f:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803366:	00 00 00 
  803369:	89 c7                	mov    %eax,%edi
  80336b:	48 b8 94 4d 80 00 00 	movabs $0x804d94,%rax
  803372:	00 00 00 
  803375:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337b:	ba 00 00 00 00       	mov    $0x0,%edx
  803380:	48 89 c6             	mov    %rax,%rsi
  803383:	bf 00 00 00 00       	mov    $0x0,%edi
  803388:	48 b8 96 4c 80 00 00 	movabs $0x804c96,%rax
  80338f:	00 00 00 
  803392:	ff d0                	callq  *%rax
}
  803394:	c9                   	leaveq 
  803395:	c3                   	retq   

0000000000803396 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803396:	55                   	push   %rbp
  803397:	48 89 e5             	mov    %rsp,%rbp
  80339a:	48 83 ec 30          	sub    $0x30,%rsp
  80339e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033a2:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8033a5:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8033ac:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8033b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8033ba:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033bf:	75 08                	jne    8033c9 <open+0x33>
	{
		return r;
  8033c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c4:	e9 f2 00 00 00       	jmpq   8034bb <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8033c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033cd:	48 89 c7             	mov    %rax,%rdi
  8033d0:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  8033d7:	00 00 00 
  8033da:	ff d0                	callq  *%rax
  8033dc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033df:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8033e6:	7e 0a                	jle    8033f2 <open+0x5c>
	{
		return -E_BAD_PATH;
  8033e8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8033ed:	e9 c9 00 00 00       	jmpq   8034bb <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8033f2:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8033f9:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8033fa:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8033fe:	48 89 c7             	mov    %rax,%rdi
  803401:	48 b8 29 2a 80 00 00 	movabs $0x802a29,%rax
  803408:	00 00 00 
  80340b:	ff d0                	callq  *%rax
  80340d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803410:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803414:	78 09                	js     80341f <open+0x89>
  803416:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80341a:	48 85 c0             	test   %rax,%rax
  80341d:	75 08                	jne    803427 <open+0x91>
		{
			return r;
  80341f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803422:	e9 94 00 00 00       	jmpq   8034bb <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803427:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80342b:	ba 00 04 00 00       	mov    $0x400,%edx
  803430:	48 89 c6             	mov    %rax,%rsi
  803433:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80343a:	00 00 00 
  80343d:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  803444:	00 00 00 
  803447:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803449:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803450:	00 00 00 
  803453:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803456:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80345c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803460:	48 89 c6             	mov    %rax,%rsi
  803463:	bf 01 00 00 00       	mov    $0x1,%edi
  803468:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  80346f:	00 00 00 
  803472:	ff d0                	callq  *%rax
  803474:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803477:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80347b:	79 2b                	jns    8034a8 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80347d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803481:	be 00 00 00 00       	mov    $0x0,%esi
  803486:	48 89 c7             	mov    %rax,%rdi
  803489:	48 b8 51 2b 80 00 00 	movabs $0x802b51,%rax
  803490:	00 00 00 
  803493:	ff d0                	callq  *%rax
  803495:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803498:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80349c:	79 05                	jns    8034a3 <open+0x10d>
			{
				return d;
  80349e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034a1:	eb 18                	jmp    8034bb <open+0x125>
			}
			return r;
  8034a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a6:	eb 13                	jmp    8034bb <open+0x125>
		}	
		return fd2num(fd_store);
  8034a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ac:	48 89 c7             	mov    %rax,%rdi
  8034af:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  8034b6:	00 00 00 
  8034b9:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8034bb:	c9                   	leaveq 
  8034bc:	c3                   	retq   

00000000008034bd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8034bd:	55                   	push   %rbp
  8034be:	48 89 e5             	mov    %rsp,%rbp
  8034c1:	48 83 ec 10          	sub    $0x10,%rsp
  8034c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8034c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034cd:	8b 50 0c             	mov    0xc(%rax),%edx
  8034d0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034d7:	00 00 00 
  8034da:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8034dc:	be 00 00 00 00       	mov    $0x0,%esi
  8034e1:	bf 06 00 00 00       	mov    $0x6,%edi
  8034e6:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  8034ed:	00 00 00 
  8034f0:	ff d0                	callq  *%rax
}
  8034f2:	c9                   	leaveq 
  8034f3:	c3                   	retq   

00000000008034f4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8034f4:	55                   	push   %rbp
  8034f5:	48 89 e5             	mov    %rsp,%rbp
  8034f8:	48 83 ec 30          	sub    $0x30,%rsp
  8034fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803500:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803504:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803508:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80350f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803514:	74 07                	je     80351d <devfile_read+0x29>
  803516:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80351b:	75 07                	jne    803524 <devfile_read+0x30>
		return -E_INVAL;
  80351d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803522:	eb 77                	jmp    80359b <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803524:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803528:	8b 50 0c             	mov    0xc(%rax),%edx
  80352b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803532:	00 00 00 
  803535:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803537:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80353e:	00 00 00 
  803541:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803545:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803549:	be 00 00 00 00       	mov    $0x0,%esi
  80354e:	bf 03 00 00 00       	mov    $0x3,%edi
  803553:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  80355a:	00 00 00 
  80355d:	ff d0                	callq  *%rax
  80355f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803562:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803566:	7f 05                	jg     80356d <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803568:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356b:	eb 2e                	jmp    80359b <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80356d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803570:	48 63 d0             	movslq %eax,%rdx
  803573:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803577:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80357e:	00 00 00 
  803581:	48 89 c7             	mov    %rax,%rdi
  803584:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  80358b:	00 00 00 
  80358e:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803590:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803594:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803598:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80359b:	c9                   	leaveq 
  80359c:	c3                   	retq   

000000000080359d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80359d:	55                   	push   %rbp
  80359e:	48 89 e5             	mov    %rsp,%rbp
  8035a1:	48 83 ec 30          	sub    $0x30,%rsp
  8035a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8035b1:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8035b8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035bd:	74 07                	je     8035c6 <devfile_write+0x29>
  8035bf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035c4:	75 08                	jne    8035ce <devfile_write+0x31>
		return r;
  8035c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c9:	e9 9a 00 00 00       	jmpq   803668 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8035ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d2:	8b 50 0c             	mov    0xc(%rax),%edx
  8035d5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035dc:	00 00 00 
  8035df:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8035e1:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8035e8:	00 
  8035e9:	76 08                	jbe    8035f3 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8035eb:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8035f2:	00 
	}
	fsipcbuf.write.req_n = n;
  8035f3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035fa:	00 00 00 
  8035fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803601:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803605:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803609:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80360d:	48 89 c6             	mov    %rax,%rsi
  803610:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803617:	00 00 00 
  80361a:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  803621:	00 00 00 
  803624:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803626:	be 00 00 00 00       	mov    $0x0,%esi
  80362b:	bf 04 00 00 00       	mov    $0x4,%edi
  803630:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  803637:	00 00 00 
  80363a:	ff d0                	callq  *%rax
  80363c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80363f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803643:	7f 20                	jg     803665 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803645:	48 bf 66 5a 80 00 00 	movabs $0x805a66,%rdi
  80364c:	00 00 00 
  80364f:	b8 00 00 00 00       	mov    $0x0,%eax
  803654:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  80365b:	00 00 00 
  80365e:	ff d2                	callq  *%rdx
		return r;
  803660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803663:	eb 03                	jmp    803668 <devfile_write+0xcb>
	}
	return r;
  803665:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803668:	c9                   	leaveq 
  803669:	c3                   	retq   

000000000080366a <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80366a:	55                   	push   %rbp
  80366b:	48 89 e5             	mov    %rsp,%rbp
  80366e:	48 83 ec 20          	sub    $0x20,%rsp
  803672:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803676:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80367a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80367e:	8b 50 0c             	mov    0xc(%rax),%edx
  803681:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803688:	00 00 00 
  80368b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80368d:	be 00 00 00 00       	mov    $0x0,%esi
  803692:	bf 05 00 00 00       	mov    $0x5,%edi
  803697:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  80369e:	00 00 00 
  8036a1:	ff d0                	callq  *%rax
  8036a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036aa:	79 05                	jns    8036b1 <devfile_stat+0x47>
		return r;
  8036ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036af:	eb 56                	jmp    803707 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8036b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036b5:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8036bc:	00 00 00 
  8036bf:	48 89 c7             	mov    %rax,%rdi
  8036c2:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  8036c9:	00 00 00 
  8036cc:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8036ce:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036d5:	00 00 00 
  8036d8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8036de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8036e8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036ef:	00 00 00 
  8036f2:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8036f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036fc:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803702:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803707:	c9                   	leaveq 
  803708:	c3                   	retq   

0000000000803709 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803709:	55                   	push   %rbp
  80370a:	48 89 e5             	mov    %rsp,%rbp
  80370d:	48 83 ec 10          	sub    $0x10,%rsp
  803711:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803715:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803718:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80371c:	8b 50 0c             	mov    0xc(%rax),%edx
  80371f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803726:	00 00 00 
  803729:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80372b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803732:	00 00 00 
  803735:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803738:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80373b:	be 00 00 00 00       	mov    $0x0,%esi
  803740:	bf 02 00 00 00       	mov    $0x2,%edi
  803745:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  80374c:	00 00 00 
  80374f:	ff d0                	callq  *%rax
}
  803751:	c9                   	leaveq 
  803752:	c3                   	retq   

0000000000803753 <remove>:

// Delete a file
int
remove(const char *path)
{
  803753:	55                   	push   %rbp
  803754:	48 89 e5             	mov    %rsp,%rbp
  803757:	48 83 ec 10          	sub    $0x10,%rsp
  80375b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80375f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803763:	48 89 c7             	mov    %rax,%rdi
  803766:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  80376d:	00 00 00 
  803770:	ff d0                	callq  *%rax
  803772:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803777:	7e 07                	jle    803780 <remove+0x2d>
		return -E_BAD_PATH;
  803779:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80377e:	eb 33                	jmp    8037b3 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803780:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803784:	48 89 c6             	mov    %rax,%rsi
  803787:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80378e:	00 00 00 
  803791:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  803798:	00 00 00 
  80379b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80379d:	be 00 00 00 00       	mov    $0x0,%esi
  8037a2:	bf 07 00 00 00       	mov    $0x7,%edi
  8037a7:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  8037ae:	00 00 00 
  8037b1:	ff d0                	callq  *%rax
}
  8037b3:	c9                   	leaveq 
  8037b4:	c3                   	retq   

00000000008037b5 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8037b5:	55                   	push   %rbp
  8037b6:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8037b9:	be 00 00 00 00       	mov    $0x0,%esi
  8037be:	bf 08 00 00 00       	mov    $0x8,%edi
  8037c3:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  8037ca:	00 00 00 
  8037cd:	ff d0                	callq  *%rax
}
  8037cf:	5d                   	pop    %rbp
  8037d0:	c3                   	retq   

00000000008037d1 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8037d1:	55                   	push   %rbp
  8037d2:	48 89 e5             	mov    %rsp,%rbp
  8037d5:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8037dc:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8037e3:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8037ea:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8037f1:	be 00 00 00 00       	mov    $0x0,%esi
  8037f6:	48 89 c7             	mov    %rax,%rdi
  8037f9:	48 b8 96 33 80 00 00 	movabs $0x803396,%rax
  803800:	00 00 00 
  803803:	ff d0                	callq  *%rax
  803805:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803808:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80380c:	79 28                	jns    803836 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80380e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803811:	89 c6                	mov    %eax,%esi
  803813:	48 bf 82 5a 80 00 00 	movabs $0x805a82,%rdi
  80381a:	00 00 00 
  80381d:	b8 00 00 00 00       	mov    $0x0,%eax
  803822:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  803829:	00 00 00 
  80382c:	ff d2                	callq  *%rdx
		return fd_src;
  80382e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803831:	e9 74 01 00 00       	jmpq   8039aa <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803836:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80383d:	be 01 01 00 00       	mov    $0x101,%esi
  803842:	48 89 c7             	mov    %rax,%rdi
  803845:	48 b8 96 33 80 00 00 	movabs $0x803396,%rax
  80384c:	00 00 00 
  80384f:	ff d0                	callq  *%rax
  803851:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803854:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803858:	79 39                	jns    803893 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80385a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80385d:	89 c6                	mov    %eax,%esi
  80385f:	48 bf 98 5a 80 00 00 	movabs $0x805a98,%rdi
  803866:	00 00 00 
  803869:	b8 00 00 00 00       	mov    $0x0,%eax
  80386e:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  803875:	00 00 00 
  803878:	ff d2                	callq  *%rdx
		close(fd_src);
  80387a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387d:	89 c7                	mov    %eax,%edi
  80387f:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  803886:	00 00 00 
  803889:	ff d0                	callq  *%rax
		return fd_dest;
  80388b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80388e:	e9 17 01 00 00       	jmpq   8039aa <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803893:	eb 74                	jmp    803909 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803895:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803898:	48 63 d0             	movslq %eax,%rdx
  80389b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8038a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038a5:	48 89 ce             	mov    %rcx,%rsi
  8038a8:	89 c7                	mov    %eax,%edi
  8038aa:	48 b8 3d 30 80 00 00 	movabs $0x80303d,%rax
  8038b1:	00 00 00 
  8038b4:	ff d0                	callq  *%rax
  8038b6:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8038b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8038bd:	79 4a                	jns    803909 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8038bf:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038c2:	89 c6                	mov    %eax,%esi
  8038c4:	48 bf b2 5a 80 00 00 	movabs $0x805ab2,%rdi
  8038cb:	00 00 00 
  8038ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d3:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  8038da:	00 00 00 
  8038dd:	ff d2                	callq  *%rdx
			close(fd_src);
  8038df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e2:	89 c7                	mov    %eax,%edi
  8038e4:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  8038eb:	00 00 00 
  8038ee:	ff d0                	callq  *%rax
			close(fd_dest);
  8038f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038f3:	89 c7                	mov    %eax,%edi
  8038f5:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  8038fc:	00 00 00 
  8038ff:	ff d0                	callq  *%rax
			return write_size;
  803901:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803904:	e9 a1 00 00 00       	jmpq   8039aa <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803909:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803910:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803913:	ba 00 02 00 00       	mov    $0x200,%edx
  803918:	48 89 ce             	mov    %rcx,%rsi
  80391b:	89 c7                	mov    %eax,%edi
  80391d:	48 b8 f3 2e 80 00 00 	movabs $0x802ef3,%rax
  803924:	00 00 00 
  803927:	ff d0                	callq  *%rax
  803929:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80392c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803930:	0f 8f 5f ff ff ff    	jg     803895 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803936:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80393a:	79 47                	jns    803983 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80393c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80393f:	89 c6                	mov    %eax,%esi
  803941:	48 bf c5 5a 80 00 00 	movabs $0x805ac5,%rdi
  803948:	00 00 00 
  80394b:	b8 00 00 00 00       	mov    $0x0,%eax
  803950:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  803957:	00 00 00 
  80395a:	ff d2                	callq  *%rdx
		close(fd_src);
  80395c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395f:	89 c7                	mov    %eax,%edi
  803961:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  803968:	00 00 00 
  80396b:	ff d0                	callq  *%rax
		close(fd_dest);
  80396d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803970:	89 c7                	mov    %eax,%edi
  803972:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  803979:	00 00 00 
  80397c:	ff d0                	callq  *%rax
		return read_size;
  80397e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803981:	eb 27                	jmp    8039aa <copy+0x1d9>
	}
	close(fd_src);
  803983:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803986:	89 c7                	mov    %eax,%edi
  803988:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  80398f:	00 00 00 
  803992:	ff d0                	callq  *%rax
	close(fd_dest);
  803994:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803997:	89 c7                	mov    %eax,%edi
  803999:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  8039a0:	00 00 00 
  8039a3:	ff d0                	callq  *%rax
	return 0;
  8039a5:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8039aa:	c9                   	leaveq 
  8039ab:	c3                   	retq   

00000000008039ac <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8039ac:	55                   	push   %rbp
  8039ad:	48 89 e5             	mov    %rsp,%rbp
  8039b0:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  8039b7:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8039be:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8039c5:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8039cc:	be 00 00 00 00       	mov    $0x0,%esi
  8039d1:	48 89 c7             	mov    %rax,%rdi
  8039d4:	48 b8 96 33 80 00 00 	movabs $0x803396,%rax
  8039db:	00 00 00 
  8039de:	ff d0                	callq  *%rax
  8039e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8039e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8039e7:	79 08                	jns    8039f1 <spawn+0x45>
		return r;
  8039e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039ec:	e9 0c 03 00 00       	jmpq   803cfd <spawn+0x351>
	fd = r;
  8039f1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039f4:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8039f7:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8039fe:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803a02:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803a09:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803a0c:	ba 00 02 00 00       	mov    $0x200,%edx
  803a11:	48 89 ce             	mov    %rcx,%rsi
  803a14:	89 c7                	mov    %eax,%edi
  803a16:	48 b8 c8 2f 80 00 00 	movabs $0x802fc8,%rax
  803a1d:	00 00 00 
  803a20:	ff d0                	callq  *%rax
  803a22:	3d 00 02 00 00       	cmp    $0x200,%eax
  803a27:	75 0d                	jne    803a36 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2d:	8b 00                	mov    (%rax),%eax
  803a2f:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803a34:	74 43                	je     803a79 <spawn+0xcd>
		close(fd);
  803a36:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803a39:	89 c7                	mov    %eax,%edi
  803a3b:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  803a42:	00 00 00 
  803a45:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803a47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a4b:	8b 00                	mov    (%rax),%eax
  803a4d:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803a52:	89 c6                	mov    %eax,%esi
  803a54:	48 bf e0 5a 80 00 00 	movabs $0x805ae0,%rdi
  803a5b:	00 00 00 
  803a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a63:	48 b9 15 0b 80 00 00 	movabs $0x800b15,%rcx
  803a6a:	00 00 00 
  803a6d:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803a6f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803a74:	e9 84 02 00 00       	jmpq   803cfd <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803a79:	b8 07 00 00 00       	mov    $0x7,%eax
  803a7e:	cd 30                	int    $0x30
  803a80:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803a83:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803a86:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803a89:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803a8d:	79 08                	jns    803a97 <spawn+0xeb>
		return r;
  803a8f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a92:	e9 66 02 00 00       	jmpq   803cfd <spawn+0x351>
	child = r;
  803a97:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a9a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803a9d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803aa0:	25 ff 03 00 00       	and    $0x3ff,%eax
  803aa5:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803aac:	00 00 00 
  803aaf:	48 98                	cltq   
  803ab1:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803ab8:	48 01 d0             	add    %rdx,%rax
  803abb:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803ac2:	48 89 c6             	mov    %rax,%rsi
  803ac5:	b8 18 00 00 00       	mov    $0x18,%eax
  803aca:	48 89 d7             	mov    %rdx,%rdi
  803acd:	48 89 c1             	mov    %rax,%rcx
  803ad0:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803ad3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad7:	48 8b 40 18          	mov    0x18(%rax),%rax
  803adb:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803ae2:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803ae9:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803af0:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803af7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803afa:	48 89 ce             	mov    %rcx,%rsi
  803afd:	89 c7                	mov    %eax,%edi
  803aff:	48 b8 67 3f 80 00 00 	movabs $0x803f67,%rax
  803b06:	00 00 00 
  803b09:	ff d0                	callq  *%rax
  803b0b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803b0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803b12:	79 08                	jns    803b1c <spawn+0x170>
		return r;
  803b14:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b17:	e9 e1 01 00 00       	jmpq   803cfd <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803b1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b20:	48 8b 40 20          	mov    0x20(%rax),%rax
  803b24:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803b2b:	48 01 d0             	add    %rdx,%rax
  803b2e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803b32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b39:	e9 a3 00 00 00       	jmpq   803be1 <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  803b3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b42:	8b 00                	mov    (%rax),%eax
  803b44:	83 f8 01             	cmp    $0x1,%eax
  803b47:	74 05                	je     803b4e <spawn+0x1a2>
			continue;
  803b49:	e9 8a 00 00 00       	jmpq   803bd8 <spawn+0x22c>
		perm = PTE_P | PTE_U;
  803b4e:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803b55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b59:	8b 40 04             	mov    0x4(%rax),%eax
  803b5c:	83 e0 02             	and    $0x2,%eax
  803b5f:	85 c0                	test   %eax,%eax
  803b61:	74 04                	je     803b67 <spawn+0x1bb>
			perm |= PTE_W;
  803b63:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803b67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6b:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803b6f:	41 89 c1             	mov    %eax,%r9d
  803b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b76:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803b7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7e:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803b82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b86:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803b8a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803b8d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803b90:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803b93:	89 3c 24             	mov    %edi,(%rsp)
  803b96:	89 c7                	mov    %eax,%edi
  803b98:	48 b8 10 42 80 00 00 	movabs $0x804210,%rax
  803b9f:	00 00 00 
  803ba2:	ff d0                	callq  *%rax
  803ba4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803ba7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803bab:	79 2b                	jns    803bd8 <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803bad:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803bae:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803bb1:	89 c7                	mov    %eax,%edi
  803bb3:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  803bba:	00 00 00 
  803bbd:	ff d0                	callq  *%rax
	close(fd);
  803bbf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803bc2:	89 c7                	mov    %eax,%edi
  803bc4:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  803bcb:	00 00 00 
  803bce:	ff d0                	callq  *%rax
	return r;
  803bd0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803bd3:	e9 25 01 00 00       	jmpq   803cfd <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803bd8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803bdc:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803be1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803be5:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803be9:	0f b7 c0             	movzwl %ax,%eax
  803bec:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803bef:	0f 8f 49 ff ff ff    	jg     803b3e <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803bf5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803bf8:	89 c7                	mov    %eax,%edi
  803bfa:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  803c01:	00 00 00 
  803c04:	ff d0                	callq  *%rax
	fd = -1;
  803c06:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803c0d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c10:	89 c7                	mov    %eax,%edi
  803c12:	48 b8 fc 43 80 00 00 	movabs $0x8043fc,%rax
  803c19:	00 00 00 
  803c1c:	ff d0                	callq  *%rax
  803c1e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803c21:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803c25:	79 30                	jns    803c57 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  803c27:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c2a:	89 c1                	mov    %eax,%ecx
  803c2c:	48 ba fa 5a 80 00 00 	movabs $0x805afa,%rdx
  803c33:	00 00 00 
  803c36:	be 82 00 00 00       	mov    $0x82,%esi
  803c3b:	48 bf 10 5b 80 00 00 	movabs $0x805b10,%rdi
  803c42:	00 00 00 
  803c45:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4a:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  803c51:	00 00 00 
  803c54:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803c57:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803c5e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c61:	48 89 d6             	mov    %rdx,%rsi
  803c64:	89 c7                	mov    %eax,%edi
  803c66:	48 b8 39 21 80 00 00 	movabs $0x802139,%rax
  803c6d:	00 00 00 
  803c70:	ff d0                	callq  *%rax
  803c72:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803c75:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803c79:	79 30                	jns    803cab <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  803c7b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c7e:	89 c1                	mov    %eax,%ecx
  803c80:	48 ba 1c 5b 80 00 00 	movabs $0x805b1c,%rdx
  803c87:	00 00 00 
  803c8a:	be 85 00 00 00       	mov    $0x85,%esi
  803c8f:	48 bf 10 5b 80 00 00 	movabs $0x805b10,%rdi
  803c96:	00 00 00 
  803c99:	b8 00 00 00 00       	mov    $0x0,%eax
  803c9e:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  803ca5:	00 00 00 
  803ca8:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803cab:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803cae:	be 02 00 00 00       	mov    $0x2,%esi
  803cb3:	89 c7                	mov    %eax,%edi
  803cb5:	48 b8 ee 20 80 00 00 	movabs $0x8020ee,%rax
  803cbc:	00 00 00 
  803cbf:	ff d0                	callq  *%rax
  803cc1:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803cc4:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803cc8:	79 30                	jns    803cfa <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  803cca:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ccd:	89 c1                	mov    %eax,%ecx
  803ccf:	48 ba 36 5b 80 00 00 	movabs $0x805b36,%rdx
  803cd6:	00 00 00 
  803cd9:	be 88 00 00 00       	mov    $0x88,%esi
  803cde:	48 bf 10 5b 80 00 00 	movabs $0x805b10,%rdi
  803ce5:	00 00 00 
  803ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ced:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  803cf4:	00 00 00 
  803cf7:	41 ff d0             	callq  *%r8

	return child;
  803cfa:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803cfd:	c9                   	leaveq 
  803cfe:	c3                   	retq   

0000000000803cff <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803cff:	55                   	push   %rbp
  803d00:	48 89 e5             	mov    %rsp,%rbp
  803d03:	41 55                	push   %r13
  803d05:	41 54                	push   %r12
  803d07:	53                   	push   %rbx
  803d08:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803d0f:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803d16:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803d1d:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803d24:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803d2b:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803d32:	84 c0                	test   %al,%al
  803d34:	74 26                	je     803d5c <spawnl+0x5d>
  803d36:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803d3d:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803d44:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803d48:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803d4c:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803d50:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803d54:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803d58:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803d5c:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803d63:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803d6a:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803d6d:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803d74:	00 00 00 
  803d77:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803d7e:	00 00 00 
  803d81:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803d85:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803d8c:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803d93:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803d9a:	eb 07                	jmp    803da3 <spawnl+0xa4>
		argc++;
  803d9c:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803da3:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803da9:	83 f8 30             	cmp    $0x30,%eax
  803dac:	73 23                	jae    803dd1 <spawnl+0xd2>
  803dae:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803db5:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803dbb:	89 c0                	mov    %eax,%eax
  803dbd:	48 01 d0             	add    %rdx,%rax
  803dc0:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803dc6:	83 c2 08             	add    $0x8,%edx
  803dc9:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803dcf:	eb 15                	jmp    803de6 <spawnl+0xe7>
  803dd1:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803dd8:	48 89 d0             	mov    %rdx,%rax
  803ddb:	48 83 c2 08          	add    $0x8,%rdx
  803ddf:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803de6:	48 8b 00             	mov    (%rax),%rax
  803de9:	48 85 c0             	test   %rax,%rax
  803dec:	75 ae                	jne    803d9c <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803dee:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803df4:	83 c0 02             	add    $0x2,%eax
  803df7:	48 89 e2             	mov    %rsp,%rdx
  803dfa:	48 89 d3             	mov    %rdx,%rbx
  803dfd:	48 63 d0             	movslq %eax,%rdx
  803e00:	48 83 ea 01          	sub    $0x1,%rdx
  803e04:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803e0b:	48 63 d0             	movslq %eax,%rdx
  803e0e:	49 89 d4             	mov    %rdx,%r12
  803e11:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803e17:	48 63 d0             	movslq %eax,%rdx
  803e1a:	49 89 d2             	mov    %rdx,%r10
  803e1d:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803e23:	48 98                	cltq   
  803e25:	48 c1 e0 03          	shl    $0x3,%rax
  803e29:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803e2d:	b8 10 00 00 00       	mov    $0x10,%eax
  803e32:	48 83 e8 01          	sub    $0x1,%rax
  803e36:	48 01 d0             	add    %rdx,%rax
  803e39:	bf 10 00 00 00       	mov    $0x10,%edi
  803e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  803e43:	48 f7 f7             	div    %rdi
  803e46:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803e4a:	48 29 c4             	sub    %rax,%rsp
  803e4d:	48 89 e0             	mov    %rsp,%rax
  803e50:	48 83 c0 07          	add    $0x7,%rax
  803e54:	48 c1 e8 03          	shr    $0x3,%rax
  803e58:	48 c1 e0 03          	shl    $0x3,%rax
  803e5c:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803e63:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803e6a:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803e71:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803e74:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803e7a:	8d 50 01             	lea    0x1(%rax),%edx
  803e7d:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803e84:	48 63 d2             	movslq %edx,%rdx
  803e87:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803e8e:	00 

	va_start(vl, arg0);
  803e8f:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803e96:	00 00 00 
  803e99:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803ea0:	00 00 00 
  803ea3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ea7:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803eae:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803eb5:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803ebc:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803ec3:	00 00 00 
  803ec6:	eb 63                	jmp    803f2b <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803ec8:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803ece:	8d 70 01             	lea    0x1(%rax),%esi
  803ed1:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803ed7:	83 f8 30             	cmp    $0x30,%eax
  803eda:	73 23                	jae    803eff <spawnl+0x200>
  803edc:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803ee3:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803ee9:	89 c0                	mov    %eax,%eax
  803eeb:	48 01 d0             	add    %rdx,%rax
  803eee:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803ef4:	83 c2 08             	add    $0x8,%edx
  803ef7:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803efd:	eb 15                	jmp    803f14 <spawnl+0x215>
  803eff:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803f06:	48 89 d0             	mov    %rdx,%rax
  803f09:	48 83 c2 08          	add    $0x8,%rdx
  803f0d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803f14:	48 8b 08             	mov    (%rax),%rcx
  803f17:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803f1e:	89 f2                	mov    %esi,%edx
  803f20:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803f24:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803f2b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803f31:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803f37:	77 8f                	ja     803ec8 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803f39:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803f40:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803f47:	48 89 d6             	mov    %rdx,%rsi
  803f4a:	48 89 c7             	mov    %rax,%rdi
  803f4d:	48 b8 ac 39 80 00 00 	movabs $0x8039ac,%rax
  803f54:	00 00 00 
  803f57:	ff d0                	callq  *%rax
  803f59:	48 89 dc             	mov    %rbx,%rsp
}
  803f5c:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803f60:	5b                   	pop    %rbx
  803f61:	41 5c                	pop    %r12
  803f63:	41 5d                	pop    %r13
  803f65:	5d                   	pop    %rbp
  803f66:	c3                   	retq   

0000000000803f67 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803f67:	55                   	push   %rbp
  803f68:	48 89 e5             	mov    %rsp,%rbp
  803f6b:	48 83 ec 50          	sub    $0x50,%rsp
  803f6f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803f72:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803f76:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803f7a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f81:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803f82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803f89:	eb 33                	jmp    803fbe <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803f8b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f8e:	48 98                	cltq   
  803f90:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803f97:	00 
  803f98:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803f9c:	48 01 d0             	add    %rdx,%rax
  803f9f:	48 8b 00             	mov    (%rax),%rax
  803fa2:	48 89 c7             	mov    %rax,%rdi
  803fa5:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  803fac:	00 00 00 
  803faf:	ff d0                	callq  *%rax
  803fb1:	83 c0 01             	add    $0x1,%eax
  803fb4:	48 98                	cltq   
  803fb6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803fba:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803fbe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803fc1:	48 98                	cltq   
  803fc3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803fca:	00 
  803fcb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803fcf:	48 01 d0             	add    %rdx,%rax
  803fd2:	48 8b 00             	mov    (%rax),%rax
  803fd5:	48 85 c0             	test   %rax,%rax
  803fd8:	75 b1                	jne    803f8b <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803fda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fde:	48 f7 d8             	neg    %rax
  803fe1:	48 05 00 10 40 00    	add    $0x401000,%rax
  803fe7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803feb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fef:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803ff3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff7:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803ffb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803ffe:	83 c2 01             	add    $0x1,%edx
  804001:	c1 e2 03             	shl    $0x3,%edx
  804004:	48 63 d2             	movslq %edx,%rdx
  804007:	48 f7 da             	neg    %rdx
  80400a:	48 01 d0             	add    %rdx,%rax
  80400d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  804011:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804015:	48 83 e8 10          	sub    $0x10,%rax
  804019:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80401f:	77 0a                	ja     80402b <init_stack+0xc4>
		return -E_NO_MEM;
  804021:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  804026:	e9 e3 01 00 00       	jmpq   80420e <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80402b:	ba 07 00 00 00       	mov    $0x7,%edx
  804030:	be 00 00 40 00       	mov    $0x400000,%esi
  804035:	bf 00 00 00 00       	mov    $0x0,%edi
  80403a:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804041:	00 00 00 
  804044:	ff d0                	callq  *%rax
  804046:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804049:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80404d:	79 08                	jns    804057 <init_stack+0xf0>
		return r;
  80404f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804052:	e9 b7 01 00 00       	jmpq   80420e <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804057:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80405e:	e9 8a 00 00 00       	jmpq   8040ed <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  804063:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804066:	48 98                	cltq   
  804068:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80406f:	00 
  804070:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804074:	48 01 c2             	add    %rax,%rdx
  804077:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80407c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804080:	48 01 c8             	add    %rcx,%rax
  804083:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804089:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  80408c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80408f:	48 98                	cltq   
  804091:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804098:	00 
  804099:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80409d:	48 01 d0             	add    %rdx,%rax
  8040a0:	48 8b 10             	mov    (%rax),%rdx
  8040a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040a7:	48 89 d6             	mov    %rdx,%rsi
  8040aa:	48 89 c7             	mov    %rax,%rdi
  8040ad:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  8040b4:	00 00 00 
  8040b7:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8040b9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8040bc:	48 98                	cltq   
  8040be:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040c5:	00 
  8040c6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8040ca:	48 01 d0             	add    %rdx,%rax
  8040cd:	48 8b 00             	mov    (%rax),%rax
  8040d0:	48 89 c7             	mov    %rax,%rdi
  8040d3:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  8040da:	00 00 00 
  8040dd:	ff d0                	callq  *%rax
  8040df:	48 98                	cltq   
  8040e1:	48 83 c0 01          	add    $0x1,%rax
  8040e5:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8040e9:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8040ed:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8040f0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8040f3:	0f 8c 6a ff ff ff    	jl     804063 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8040f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040fc:	48 98                	cltq   
  8040fe:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804105:	00 
  804106:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80410a:	48 01 d0             	add    %rdx,%rax
  80410d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  804114:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80411b:	00 
  80411c:	74 35                	je     804153 <init_stack+0x1ec>
  80411e:	48 b9 50 5b 80 00 00 	movabs $0x805b50,%rcx
  804125:	00 00 00 
  804128:	48 ba 76 5b 80 00 00 	movabs $0x805b76,%rdx
  80412f:	00 00 00 
  804132:	be f1 00 00 00       	mov    $0xf1,%esi
  804137:	48 bf 10 5b 80 00 00 	movabs $0x805b10,%rdi
  80413e:	00 00 00 
  804141:	b8 00 00 00 00       	mov    $0x0,%eax
  804146:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  80414d:	00 00 00 
  804150:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804153:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804157:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80415b:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804160:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804164:	48 01 c8             	add    %rcx,%rax
  804167:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80416d:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  804170:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804174:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  804178:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80417b:	48 98                	cltq   
  80417d:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  804180:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  804185:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804189:	48 01 d0             	add    %rdx,%rax
  80418c:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804192:	48 89 c2             	mov    %rax,%rdx
  804195:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804199:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80419c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80419f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8041a5:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8041aa:	89 c2                	mov    %eax,%edx
  8041ac:	be 00 00 40 00       	mov    $0x400000,%esi
  8041b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8041b6:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  8041bd:	00 00 00 
  8041c0:	ff d0                	callq  *%rax
  8041c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041c9:	79 02                	jns    8041cd <init_stack+0x266>
		goto error;
  8041cb:	eb 28                	jmp    8041f5 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8041cd:	be 00 00 40 00       	mov    $0x400000,%esi
  8041d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8041d7:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  8041de:	00 00 00 
  8041e1:	ff d0                	callq  *%rax
  8041e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041ea:	79 02                	jns    8041ee <init_stack+0x287>
		goto error;
  8041ec:	eb 07                	jmp    8041f5 <init_stack+0x28e>

	return 0;
  8041ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8041f3:	eb 19                	jmp    80420e <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8041f5:	be 00 00 40 00       	mov    $0x400000,%esi
  8041fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8041ff:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804206:	00 00 00 
  804209:	ff d0                	callq  *%rax
	return r;
  80420b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80420e:	c9                   	leaveq 
  80420f:	c3                   	retq   

0000000000804210 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  804210:	55                   	push   %rbp
  804211:	48 89 e5             	mov    %rsp,%rbp
  804214:	48 83 ec 50          	sub    $0x50,%rsp
  804218:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80421b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80421f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  804223:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  804226:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80422a:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80422e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804232:	25 ff 0f 00 00       	and    $0xfff,%eax
  804237:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80423a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80423e:	74 21                	je     804261 <map_segment+0x51>
		va -= i;
  804240:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804243:	48 98                	cltq   
  804245:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  804249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424c:	48 98                	cltq   
  80424e:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  804252:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804255:	48 98                	cltq   
  804257:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80425b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80425e:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804261:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804268:	e9 79 01 00 00       	jmpq   8043e6 <map_segment+0x1d6>
		if (i >= filesz) {
  80426d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804270:	48 98                	cltq   
  804272:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  804276:	72 3c                	jb     8042b4 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  804278:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80427b:	48 63 d0             	movslq %eax,%rdx
  80427e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804282:	48 01 d0             	add    %rdx,%rax
  804285:	48 89 c1             	mov    %rax,%rcx
  804288:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80428b:	8b 55 10             	mov    0x10(%rbp),%edx
  80428e:	48 89 ce             	mov    %rcx,%rsi
  804291:	89 c7                	mov    %eax,%edi
  804293:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  80429a:	00 00 00 
  80429d:	ff d0                	callq  *%rax
  80429f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8042a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8042a6:	0f 89 33 01 00 00    	jns    8043df <map_segment+0x1cf>
				return r;
  8042ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042af:	e9 46 01 00 00       	jmpq   8043fa <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8042b4:	ba 07 00 00 00       	mov    $0x7,%edx
  8042b9:	be 00 00 40 00       	mov    $0x400000,%esi
  8042be:	bf 00 00 00 00       	mov    $0x0,%edi
  8042c3:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8042ca:	00 00 00 
  8042cd:	ff d0                	callq  *%rax
  8042cf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8042d2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8042d6:	79 08                	jns    8042e0 <map_segment+0xd0>
				return r;
  8042d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042db:	e9 1a 01 00 00       	jmpq   8043fa <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8042e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042e3:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8042e6:	01 c2                	add    %eax,%edx
  8042e8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8042eb:	89 d6                	mov    %edx,%esi
  8042ed:	89 c7                	mov    %eax,%edi
  8042ef:	48 b8 de 30 80 00 00 	movabs $0x8030de,%rax
  8042f6:	00 00 00 
  8042f9:	ff d0                	callq  *%rax
  8042fb:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8042fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804302:	79 08                	jns    80430c <map_segment+0xfc>
				return r;
  804304:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804307:	e9 ee 00 00 00       	jmpq   8043fa <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80430c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  804313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804316:	48 98                	cltq   
  804318:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80431c:	48 29 c2             	sub    %rax,%rdx
  80431f:	48 89 d0             	mov    %rdx,%rax
  804322:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804326:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804329:	48 63 d0             	movslq %eax,%rdx
  80432c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804330:	48 39 c2             	cmp    %rax,%rdx
  804333:	48 0f 47 d0          	cmova  %rax,%rdx
  804337:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80433a:	be 00 00 40 00       	mov    $0x400000,%esi
  80433f:	89 c7                	mov    %eax,%edi
  804341:	48 b8 c8 2f 80 00 00 	movabs $0x802fc8,%rax
  804348:	00 00 00 
  80434b:	ff d0                	callq  *%rax
  80434d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804350:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804354:	79 08                	jns    80435e <map_segment+0x14e>
				return r;
  804356:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804359:	e9 9c 00 00 00       	jmpq   8043fa <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80435e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804361:	48 63 d0             	movslq %eax,%rdx
  804364:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804368:	48 01 d0             	add    %rdx,%rax
  80436b:	48 89 c2             	mov    %rax,%rdx
  80436e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804371:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  804375:	48 89 d1             	mov    %rdx,%rcx
  804378:	89 c2                	mov    %eax,%edx
  80437a:	be 00 00 40 00       	mov    $0x400000,%esi
  80437f:	bf 00 00 00 00       	mov    $0x0,%edi
  804384:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  80438b:	00 00 00 
  80438e:	ff d0                	callq  *%rax
  804390:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804393:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804397:	79 30                	jns    8043c9 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  804399:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80439c:	89 c1                	mov    %eax,%ecx
  80439e:	48 ba 8b 5b 80 00 00 	movabs $0x805b8b,%rdx
  8043a5:	00 00 00 
  8043a8:	be 24 01 00 00       	mov    $0x124,%esi
  8043ad:	48 bf 10 5b 80 00 00 	movabs $0x805b10,%rdi
  8043b4:	00 00 00 
  8043b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8043bc:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  8043c3:	00 00 00 
  8043c6:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8043c9:	be 00 00 40 00       	mov    $0x400000,%esi
  8043ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8043d3:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  8043da:	00 00 00 
  8043dd:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8043df:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8043e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e9:	48 98                	cltq   
  8043eb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043ef:	0f 82 78 fe ff ff    	jb     80426d <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8043f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043fa:	c9                   	leaveq 
  8043fb:	c3                   	retq   

00000000008043fc <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8043fc:	55                   	push   %rbp
  8043fd:	48 89 e5             	mov    %rsp,%rbp
  804400:	48 83 ec 20          	sub    $0x20,%rsp
  804404:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  804407:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  80440e:	00 
  80440f:	e9 c9 00 00 00       	jmpq   8044dd <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  804414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804418:	48 c1 e8 27          	shr    $0x27,%rax
  80441c:	48 89 c2             	mov    %rax,%rdx
  80441f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804426:	01 00 00 
  804429:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80442d:	48 85 c0             	test   %rax,%rax
  804430:	74 3c                	je     80446e <copy_shared_pages+0x72>
  804432:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804436:	48 c1 e8 1e          	shr    $0x1e,%rax
  80443a:	48 89 c2             	mov    %rax,%rdx
  80443d:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804444:	01 00 00 
  804447:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80444b:	48 85 c0             	test   %rax,%rax
  80444e:	74 1e                	je     80446e <copy_shared_pages+0x72>
  804450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804454:	48 c1 e8 15          	shr    $0x15,%rax
  804458:	48 89 c2             	mov    %rax,%rdx
  80445b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804462:	01 00 00 
  804465:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804469:	48 85 c0             	test   %rax,%rax
  80446c:	75 02                	jne    804470 <copy_shared_pages+0x74>
                continue;
  80446e:	eb 65                	jmp    8044d5 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  804470:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804474:	48 c1 e8 0c          	shr    $0xc,%rax
  804478:	48 89 c2             	mov    %rax,%rdx
  80447b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804482:	01 00 00 
  804485:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804489:	25 00 04 00 00       	and    $0x400,%eax
  80448e:	48 85 c0             	test   %rax,%rax
  804491:	74 42                	je     8044d5 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  804493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804497:	48 c1 e8 0c          	shr    $0xc,%rax
  80449b:	48 89 c2             	mov    %rax,%rdx
  80449e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044a5:	01 00 00 
  8044a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044ac:	25 07 0e 00 00       	and    $0xe07,%eax
  8044b1:	89 c6                	mov    %eax,%esi
  8044b3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8044b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044bb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8044be:	41 89 f0             	mov    %esi,%r8d
  8044c1:	48 89 c6             	mov    %rax,%rsi
  8044c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8044c9:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  8044d0:	00 00 00 
  8044d3:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  8044d5:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8044dc:	00 
  8044dd:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  8044e4:	00 00 00 
  8044e7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8044eb:	0f 86 23 ff ff ff    	jbe    804414 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  8044f1:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  8044f6:	c9                   	leaveq 
  8044f7:	c3                   	retq   

00000000008044f8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8044f8:	55                   	push   %rbp
  8044f9:	48 89 e5             	mov    %rsp,%rbp
  8044fc:	53                   	push   %rbx
  8044fd:	48 83 ec 38          	sub    $0x38,%rsp
  804501:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804505:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804509:	48 89 c7             	mov    %rax,%rdi
  80450c:	48 b8 29 2a 80 00 00 	movabs $0x802a29,%rax
  804513:	00 00 00 
  804516:	ff d0                	callq  *%rax
  804518:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80451b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80451f:	0f 88 bf 01 00 00    	js     8046e4 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804529:	ba 07 04 00 00       	mov    $0x407,%edx
  80452e:	48 89 c6             	mov    %rax,%rsi
  804531:	bf 00 00 00 00       	mov    $0x0,%edi
  804536:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  80453d:	00 00 00 
  804540:	ff d0                	callq  *%rax
  804542:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804545:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804549:	0f 88 95 01 00 00    	js     8046e4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80454f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804553:	48 89 c7             	mov    %rax,%rdi
  804556:	48 b8 29 2a 80 00 00 	movabs $0x802a29,%rax
  80455d:	00 00 00 
  804560:	ff d0                	callq  *%rax
  804562:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804565:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804569:	0f 88 5d 01 00 00    	js     8046cc <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80456f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804573:	ba 07 04 00 00       	mov    $0x407,%edx
  804578:	48 89 c6             	mov    %rax,%rsi
  80457b:	bf 00 00 00 00       	mov    $0x0,%edi
  804580:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804587:	00 00 00 
  80458a:	ff d0                	callq  *%rax
  80458c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80458f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804593:	0f 88 33 01 00 00    	js     8046cc <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804599:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80459d:	48 89 c7             	mov    %rax,%rdi
  8045a0:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  8045a7:	00 00 00 
  8045aa:	ff d0                	callq  *%rax
  8045ac:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8045b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045b4:	ba 07 04 00 00       	mov    $0x407,%edx
  8045b9:	48 89 c6             	mov    %rax,%rsi
  8045bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8045c1:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  8045c8:	00 00 00 
  8045cb:	ff d0                	callq  *%rax
  8045cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8045d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045d4:	79 05                	jns    8045db <pipe+0xe3>
		goto err2;
  8045d6:	e9 d9 00 00 00       	jmpq   8046b4 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8045db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045df:	48 89 c7             	mov    %rax,%rdi
  8045e2:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  8045e9:	00 00 00 
  8045ec:	ff d0                	callq  *%rax
  8045ee:	48 89 c2             	mov    %rax,%rdx
  8045f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045f5:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8045fb:	48 89 d1             	mov    %rdx,%rcx
  8045fe:	ba 00 00 00 00       	mov    $0x0,%edx
  804603:	48 89 c6             	mov    %rax,%rsi
  804606:	bf 00 00 00 00       	mov    $0x0,%edi
  80460b:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  804612:	00 00 00 
  804615:	ff d0                	callq  *%rax
  804617:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80461a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80461e:	79 1b                	jns    80463b <pipe+0x143>
		goto err3;
  804620:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804621:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804625:	48 89 c6             	mov    %rax,%rsi
  804628:	bf 00 00 00 00       	mov    $0x0,%edi
  80462d:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804634:	00 00 00 
  804637:	ff d0                	callq  *%rax
  804639:	eb 79                	jmp    8046b4 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80463b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80463f:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  804646:	00 00 00 
  804649:	8b 12                	mov    (%rdx),%edx
  80464b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80464d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804651:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804658:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80465c:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  804663:	00 00 00 
  804666:	8b 12                	mov    (%rdx),%edx
  804668:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80466a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80466e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804675:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804679:	48 89 c7             	mov    %rax,%rdi
  80467c:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  804683:	00 00 00 
  804686:	ff d0                	callq  *%rax
  804688:	89 c2                	mov    %eax,%edx
  80468a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80468e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804690:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804694:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804698:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80469c:	48 89 c7             	mov    %rax,%rdi
  80469f:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  8046a6:	00 00 00 
  8046a9:	ff d0                	callq  *%rax
  8046ab:	89 03                	mov    %eax,(%rbx)
	return 0;
  8046ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8046b2:	eb 33                	jmp    8046e7 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8046b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046b8:	48 89 c6             	mov    %rax,%rsi
  8046bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8046c0:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  8046c7:	00 00 00 
  8046ca:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8046cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046d0:	48 89 c6             	mov    %rax,%rsi
  8046d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8046d8:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  8046df:	00 00 00 
  8046e2:	ff d0                	callq  *%rax
err:
	return r;
  8046e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8046e7:	48 83 c4 38          	add    $0x38,%rsp
  8046eb:	5b                   	pop    %rbx
  8046ec:	5d                   	pop    %rbp
  8046ed:	c3                   	retq   

00000000008046ee <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8046ee:	55                   	push   %rbp
  8046ef:	48 89 e5             	mov    %rsp,%rbp
  8046f2:	53                   	push   %rbx
  8046f3:	48 83 ec 28          	sub    $0x28,%rsp
  8046f7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046fb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8046ff:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804706:	00 00 00 
  804709:	48 8b 00             	mov    (%rax),%rax
  80470c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804712:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804719:	48 89 c7             	mov    %rax,%rdi
  80471c:	48 b8 d3 51 80 00 00 	movabs $0x8051d3,%rax
  804723:	00 00 00 
  804726:	ff d0                	callq  *%rax
  804728:	89 c3                	mov    %eax,%ebx
  80472a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80472e:	48 89 c7             	mov    %rax,%rdi
  804731:	48 b8 d3 51 80 00 00 	movabs $0x8051d3,%rax
  804738:	00 00 00 
  80473b:	ff d0                	callq  *%rax
  80473d:	39 c3                	cmp    %eax,%ebx
  80473f:	0f 94 c0             	sete   %al
  804742:	0f b6 c0             	movzbl %al,%eax
  804745:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804748:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80474f:	00 00 00 
  804752:	48 8b 00             	mov    (%rax),%rax
  804755:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80475b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80475e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804761:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804764:	75 05                	jne    80476b <_pipeisclosed+0x7d>
			return ret;
  804766:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804769:	eb 4f                	jmp    8047ba <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80476b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80476e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804771:	74 42                	je     8047b5 <_pipeisclosed+0xc7>
  804773:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804777:	75 3c                	jne    8047b5 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804779:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804780:	00 00 00 
  804783:	48 8b 00             	mov    (%rax),%rax
  804786:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80478c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80478f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804792:	89 c6                	mov    %eax,%esi
  804794:	48 bf b2 5b 80 00 00 	movabs $0x805bb2,%rdi
  80479b:	00 00 00 
  80479e:	b8 00 00 00 00       	mov    $0x0,%eax
  8047a3:	49 b8 15 0b 80 00 00 	movabs $0x800b15,%r8
  8047aa:	00 00 00 
  8047ad:	41 ff d0             	callq  *%r8
	}
  8047b0:	e9 4a ff ff ff       	jmpq   8046ff <_pipeisclosed+0x11>
  8047b5:	e9 45 ff ff ff       	jmpq   8046ff <_pipeisclosed+0x11>
}
  8047ba:	48 83 c4 28          	add    $0x28,%rsp
  8047be:	5b                   	pop    %rbx
  8047bf:	5d                   	pop    %rbp
  8047c0:	c3                   	retq   

00000000008047c1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8047c1:	55                   	push   %rbp
  8047c2:	48 89 e5             	mov    %rsp,%rbp
  8047c5:	48 83 ec 30          	sub    $0x30,%rsp
  8047c9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8047cc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8047d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8047d3:	48 89 d6             	mov    %rdx,%rsi
  8047d6:	89 c7                	mov    %eax,%edi
  8047d8:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  8047df:	00 00 00 
  8047e2:	ff d0                	callq  *%rax
  8047e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047eb:	79 05                	jns    8047f2 <pipeisclosed+0x31>
		return r;
  8047ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047f0:	eb 31                	jmp    804823 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8047f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047f6:	48 89 c7             	mov    %rax,%rdi
  8047f9:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  804800:	00 00 00 
  804803:	ff d0                	callq  *%rax
  804805:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804809:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80480d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804811:	48 89 d6             	mov    %rdx,%rsi
  804814:	48 89 c7             	mov    %rax,%rdi
  804817:	48 b8 ee 46 80 00 00 	movabs $0x8046ee,%rax
  80481e:	00 00 00 
  804821:	ff d0                	callq  *%rax
}
  804823:	c9                   	leaveq 
  804824:	c3                   	retq   

0000000000804825 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804825:	55                   	push   %rbp
  804826:	48 89 e5             	mov    %rsp,%rbp
  804829:	48 83 ec 40          	sub    $0x40,%rsp
  80482d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804831:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804835:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80483d:	48 89 c7             	mov    %rax,%rdi
  804840:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  804847:	00 00 00 
  80484a:	ff d0                	callq  *%rax
  80484c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804850:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804854:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804858:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80485f:	00 
  804860:	e9 92 00 00 00       	jmpq   8048f7 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804865:	eb 41                	jmp    8048a8 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804867:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80486c:	74 09                	je     804877 <devpipe_read+0x52>
				return i;
  80486e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804872:	e9 92 00 00 00       	jmpq   804909 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804877:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80487b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80487f:	48 89 d6             	mov    %rdx,%rsi
  804882:	48 89 c7             	mov    %rax,%rdi
  804885:	48 b8 ee 46 80 00 00 	movabs $0x8046ee,%rax
  80488c:	00 00 00 
  80488f:	ff d0                	callq  *%rax
  804891:	85 c0                	test   %eax,%eax
  804893:	74 07                	je     80489c <devpipe_read+0x77>
				return 0;
  804895:	b8 00 00 00 00       	mov    $0x0,%eax
  80489a:	eb 6d                	jmp    804909 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80489c:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  8048a3:	00 00 00 
  8048a6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8048a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048ac:	8b 10                	mov    (%rax),%edx
  8048ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048b2:	8b 40 04             	mov    0x4(%rax),%eax
  8048b5:	39 c2                	cmp    %eax,%edx
  8048b7:	74 ae                	je     804867 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8048b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8048c1:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8048c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048c9:	8b 00                	mov    (%rax),%eax
  8048cb:	99                   	cltd   
  8048cc:	c1 ea 1b             	shr    $0x1b,%edx
  8048cf:	01 d0                	add    %edx,%eax
  8048d1:	83 e0 1f             	and    $0x1f,%eax
  8048d4:	29 d0                	sub    %edx,%eax
  8048d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048da:	48 98                	cltq   
  8048dc:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8048e1:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8048e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048e7:	8b 00                	mov    (%rax),%eax
  8048e9:	8d 50 01             	lea    0x1(%rax),%edx
  8048ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048f0:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8048f2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8048f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048fb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8048ff:	0f 82 60 ff ff ff    	jb     804865 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804905:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804909:	c9                   	leaveq 
  80490a:	c3                   	retq   

000000000080490b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80490b:	55                   	push   %rbp
  80490c:	48 89 e5             	mov    %rsp,%rbp
  80490f:	48 83 ec 40          	sub    $0x40,%rsp
  804913:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804917:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80491b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80491f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804923:	48 89 c7             	mov    %rax,%rdi
  804926:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  80492d:	00 00 00 
  804930:	ff d0                	callq  *%rax
  804932:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804936:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80493a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80493e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804945:	00 
  804946:	e9 8e 00 00 00       	jmpq   8049d9 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80494b:	eb 31                	jmp    80497e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80494d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804955:	48 89 d6             	mov    %rdx,%rsi
  804958:	48 89 c7             	mov    %rax,%rdi
  80495b:	48 b8 ee 46 80 00 00 	movabs $0x8046ee,%rax
  804962:	00 00 00 
  804965:	ff d0                	callq  *%rax
  804967:	85 c0                	test   %eax,%eax
  804969:	74 07                	je     804972 <devpipe_write+0x67>
				return 0;
  80496b:	b8 00 00 00 00       	mov    $0x0,%eax
  804970:	eb 79                	jmp    8049eb <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804972:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  804979:	00 00 00 
  80497c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80497e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804982:	8b 40 04             	mov    0x4(%rax),%eax
  804985:	48 63 d0             	movslq %eax,%rdx
  804988:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80498c:	8b 00                	mov    (%rax),%eax
  80498e:	48 98                	cltq   
  804990:	48 83 c0 20          	add    $0x20,%rax
  804994:	48 39 c2             	cmp    %rax,%rdx
  804997:	73 b4                	jae    80494d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804999:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80499d:	8b 40 04             	mov    0x4(%rax),%eax
  8049a0:	99                   	cltd   
  8049a1:	c1 ea 1b             	shr    $0x1b,%edx
  8049a4:	01 d0                	add    %edx,%eax
  8049a6:	83 e0 1f             	and    $0x1f,%eax
  8049a9:	29 d0                	sub    %edx,%eax
  8049ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8049af:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8049b3:	48 01 ca             	add    %rcx,%rdx
  8049b6:	0f b6 0a             	movzbl (%rdx),%ecx
  8049b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049bd:	48 98                	cltq   
  8049bf:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8049c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049c7:	8b 40 04             	mov    0x4(%rax),%eax
  8049ca:	8d 50 01             	lea    0x1(%rax),%edx
  8049cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049d1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8049d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8049d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049dd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8049e1:	0f 82 64 ff ff ff    	jb     80494b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8049e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8049eb:	c9                   	leaveq 
  8049ec:	c3                   	retq   

00000000008049ed <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8049ed:	55                   	push   %rbp
  8049ee:	48 89 e5             	mov    %rsp,%rbp
  8049f1:	48 83 ec 20          	sub    $0x20,%rsp
  8049f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8049f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8049fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a01:	48 89 c7             	mov    %rax,%rdi
  804a04:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  804a0b:	00 00 00 
  804a0e:	ff d0                	callq  *%rax
  804a10:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804a14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a18:	48 be c5 5b 80 00 00 	movabs $0x805bc5,%rsi
  804a1f:	00 00 00 
  804a22:	48 89 c7             	mov    %rax,%rdi
  804a25:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  804a2c:	00 00 00 
  804a2f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804a31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a35:	8b 50 04             	mov    0x4(%rax),%edx
  804a38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a3c:	8b 00                	mov    (%rax),%eax
  804a3e:	29 c2                	sub    %eax,%edx
  804a40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a44:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804a4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a4e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804a55:	00 00 00 
	stat->st_dev = &devpipe;
  804a58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a5c:	48 b9 00 71 80 00 00 	movabs $0x807100,%rcx
  804a63:	00 00 00 
  804a66:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804a6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a72:	c9                   	leaveq 
  804a73:	c3                   	retq   

0000000000804a74 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804a74:	55                   	push   %rbp
  804a75:	48 89 e5             	mov    %rsp,%rbp
  804a78:	48 83 ec 10          	sub    $0x10,%rsp
  804a7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804a80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a84:	48 89 c6             	mov    %rax,%rsi
  804a87:	bf 00 00 00 00       	mov    $0x0,%edi
  804a8c:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804a93:	00 00 00 
  804a96:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804a98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a9c:	48 89 c7             	mov    %rax,%rdi
  804a9f:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  804aa6:	00 00 00 
  804aa9:	ff d0                	callq  *%rax
  804aab:	48 89 c6             	mov    %rax,%rsi
  804aae:	bf 00 00 00 00       	mov    $0x0,%edi
  804ab3:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  804aba:	00 00 00 
  804abd:	ff d0                	callq  *%rax
}
  804abf:	c9                   	leaveq 
  804ac0:	c3                   	retq   

0000000000804ac1 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804ac1:	55                   	push   %rbp
  804ac2:	48 89 e5             	mov    %rsp,%rbp
  804ac5:	48 83 ec 20          	sub    $0x20,%rsp
  804ac9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804acc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804ad0:	75 35                	jne    804b07 <wait+0x46>
  804ad2:	48 b9 cc 5b 80 00 00 	movabs $0x805bcc,%rcx
  804ad9:	00 00 00 
  804adc:	48 ba d7 5b 80 00 00 	movabs $0x805bd7,%rdx
  804ae3:	00 00 00 
  804ae6:	be 09 00 00 00       	mov    $0x9,%esi
  804aeb:	48 bf ec 5b 80 00 00 	movabs $0x805bec,%rdi
  804af2:	00 00 00 
  804af5:	b8 00 00 00 00       	mov    $0x0,%eax
  804afa:	49 b8 dc 08 80 00 00 	movabs $0x8008dc,%r8
  804b01:	00 00 00 
  804b04:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804b07:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b0a:	25 ff 03 00 00       	and    $0x3ff,%eax
  804b0f:	48 98                	cltq   
  804b11:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804b18:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804b1f:	00 00 00 
  804b22:	48 01 d0             	add    %rdx,%rax
  804b25:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804b29:	eb 0c                	jmp    804b37 <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  804b2b:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  804b32:	00 00 00 
  804b35:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b3b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804b41:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804b44:	75 0e                	jne    804b54 <wait+0x93>
  804b46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b4a:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804b50:	85 c0                	test   %eax,%eax
  804b52:	75 d7                	jne    804b2b <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  804b54:	c9                   	leaveq 
  804b55:	c3                   	retq   

0000000000804b56 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804b56:	55                   	push   %rbp
  804b57:	48 89 e5             	mov    %rsp,%rbp
  804b5a:	48 83 ec 10          	sub    $0x10,%rsp
  804b5e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804b62:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804b69:	00 00 00 
  804b6c:	48 8b 00             	mov    (%rax),%rax
  804b6f:	48 85 c0             	test   %rax,%rax
  804b72:	0f 85 84 00 00 00    	jne    804bfc <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804b78:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804b7f:	00 00 00 
  804b82:	48 8b 00             	mov    (%rax),%rax
  804b85:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804b8b:	ba 07 00 00 00       	mov    $0x7,%edx
  804b90:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804b95:	89 c7                	mov    %eax,%edi
  804b97:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804b9e:	00 00 00 
  804ba1:	ff d0                	callq  *%rax
  804ba3:	85 c0                	test   %eax,%eax
  804ba5:	79 2a                	jns    804bd1 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804ba7:	48 ba f8 5b 80 00 00 	movabs $0x805bf8,%rdx
  804bae:	00 00 00 
  804bb1:	be 23 00 00 00       	mov    $0x23,%esi
  804bb6:	48 bf 1f 5c 80 00 00 	movabs $0x805c1f,%rdi
  804bbd:	00 00 00 
  804bc0:	b8 00 00 00 00       	mov    $0x0,%eax
  804bc5:	48 b9 dc 08 80 00 00 	movabs $0x8008dc,%rcx
  804bcc:	00 00 00 
  804bcf:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804bd1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804bd8:	00 00 00 
  804bdb:	48 8b 00             	mov    (%rax),%rax
  804bde:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804be4:	48 be 0f 4c 80 00 00 	movabs $0x804c0f,%rsi
  804beb:	00 00 00 
  804bee:	89 c7                	mov    %eax,%edi
  804bf0:	48 b8 83 21 80 00 00 	movabs $0x802183,%rax
  804bf7:	00 00 00 
  804bfa:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804bfc:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804c03:	00 00 00 
  804c06:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804c0a:	48 89 10             	mov    %rdx,(%rax)
}
  804c0d:	c9                   	leaveq 
  804c0e:	c3                   	retq   

0000000000804c0f <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804c0f:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804c12:	48 a1 08 a0 80 00 00 	movabs 0x80a008,%rax
  804c19:	00 00 00 
call *%rax
  804c1c:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  804c1e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804c25:	00 
movq 152(%rsp), %rcx  //Load RSP
  804c26:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804c2d:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  804c2e:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  804c32:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  804c35:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804c3c:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  804c3d:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  804c41:	4c 8b 3c 24          	mov    (%rsp),%r15
  804c45:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804c4a:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804c4f:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804c54:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804c59:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804c5e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804c63:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804c68:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804c6d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804c72:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804c77:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804c7c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804c81:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804c86:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804c8b:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  804c8f:	48 83 c4 08          	add    $0x8,%rsp
popfq
  804c93:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  804c94:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  804c95:	c3                   	retq   

0000000000804c96 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804c96:	55                   	push   %rbp
  804c97:	48 89 e5             	mov    %rsp,%rbp
  804c9a:	48 83 ec 30          	sub    $0x30,%rsp
  804c9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804ca2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804ca6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804caa:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804cb1:	00 00 00 
  804cb4:	48 8b 00             	mov    (%rax),%rax
  804cb7:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804cbd:	85 c0                	test   %eax,%eax
  804cbf:	75 34                	jne    804cf5 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  804cc1:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  804cc8:	00 00 00 
  804ccb:	ff d0                	callq  *%rax
  804ccd:	25 ff 03 00 00       	and    $0x3ff,%eax
  804cd2:	48 98                	cltq   
  804cd4:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804cdb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804ce2:	00 00 00 
  804ce5:	48 01 c2             	add    %rax,%rdx
  804ce8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804cef:	00 00 00 
  804cf2:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804cf5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804cfa:	75 0e                	jne    804d0a <ipc_recv+0x74>
		pg = (void*) UTOP;
  804cfc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804d03:	00 00 00 
  804d06:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804d0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d0e:	48 89 c7             	mov    %rax,%rdi
  804d11:	48 b8 22 22 80 00 00 	movabs $0x802222,%rax
  804d18:	00 00 00 
  804d1b:	ff d0                	callq  *%rax
  804d1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804d20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d24:	79 19                	jns    804d3f <ipc_recv+0xa9>
		*from_env_store = 0;
  804d26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d2a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804d30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d34:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804d3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d3d:	eb 53                	jmp    804d92 <ipc_recv+0xfc>
	}
	if(from_env_store)
  804d3f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804d44:	74 19                	je     804d5f <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  804d46:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804d4d:	00 00 00 
  804d50:	48 8b 00             	mov    (%rax),%rax
  804d53:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804d59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d5d:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804d5f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804d64:	74 19                	je     804d7f <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  804d66:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804d6d:	00 00 00 
  804d70:	48 8b 00             	mov    (%rax),%rax
  804d73:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804d79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d7d:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804d7f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804d86:	00 00 00 
  804d89:	48 8b 00             	mov    (%rax),%rax
  804d8c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804d92:	c9                   	leaveq 
  804d93:	c3                   	retq   

0000000000804d94 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804d94:	55                   	push   %rbp
  804d95:	48 89 e5             	mov    %rsp,%rbp
  804d98:	48 83 ec 30          	sub    $0x30,%rsp
  804d9c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804d9f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804da2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804da6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804da9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804dae:	75 0e                	jne    804dbe <ipc_send+0x2a>
		pg = (void*)UTOP;
  804db0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804db7:	00 00 00 
  804dba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804dbe:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804dc1:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804dc4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804dc8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804dcb:	89 c7                	mov    %eax,%edi
  804dcd:	48 b8 cd 21 80 00 00 	movabs $0x8021cd,%rax
  804dd4:	00 00 00 
  804dd7:	ff d0                	callq  *%rax
  804dd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804ddc:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804de0:	75 0c                	jne    804dee <ipc_send+0x5a>
			sys_yield();
  804de2:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  804de9:	00 00 00 
  804dec:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804dee:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804df2:	74 ca                	je     804dbe <ipc_send+0x2a>
	if(result != 0)
  804df4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804df8:	74 20                	je     804e1a <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  804dfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dfd:	89 c6                	mov    %eax,%esi
  804dff:	48 bf 30 5c 80 00 00 	movabs $0x805c30,%rdi
  804e06:	00 00 00 
  804e09:	b8 00 00 00 00       	mov    $0x0,%eax
  804e0e:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  804e15:	00 00 00 
  804e18:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  804e1a:	c9                   	leaveq 
  804e1b:	c3                   	retq   

0000000000804e1c <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804e1c:	55                   	push   %rbp
  804e1d:	48 89 e5             	mov    %rsp,%rbp
  804e20:	53                   	push   %rbx
  804e21:	48 83 ec 58          	sub    $0x58,%rsp
  804e25:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  804e29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804e2d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  804e31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  804e38:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  804e3f:	00 
  804e40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e44:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  804e48:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e4c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  804e50:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804e54:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804e58:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804e5c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  804e60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e64:	48 c1 e8 27          	shr    $0x27,%rax
  804e68:	48 89 c2             	mov    %rax,%rdx
  804e6b:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804e72:	01 00 00 
  804e75:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804e79:	83 e0 01             	and    $0x1,%eax
  804e7c:	48 85 c0             	test   %rax,%rax
  804e7f:	0f 85 91 00 00 00    	jne    804f16 <ipc_host_recv+0xfa>
  804e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e89:	48 c1 e8 1e          	shr    $0x1e,%rax
  804e8d:	48 89 c2             	mov    %rax,%rdx
  804e90:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804e97:	01 00 00 
  804e9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804e9e:	83 e0 01             	and    $0x1,%eax
  804ea1:	48 85 c0             	test   %rax,%rax
  804ea4:	74 70                	je     804f16 <ipc_host_recv+0xfa>
  804ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804eaa:	48 c1 e8 15          	shr    $0x15,%rax
  804eae:	48 89 c2             	mov    %rax,%rdx
  804eb1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804eb8:	01 00 00 
  804ebb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ebf:	83 e0 01             	and    $0x1,%eax
  804ec2:	48 85 c0             	test   %rax,%rax
  804ec5:	74 4f                	je     804f16 <ipc_host_recv+0xfa>
  804ec7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ecb:	48 c1 e8 0c          	shr    $0xc,%rax
  804ecf:	48 89 c2             	mov    %rax,%rdx
  804ed2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804ed9:	01 00 00 
  804edc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ee0:	83 e0 01             	and    $0x1,%eax
  804ee3:	48 85 c0             	test   %rax,%rax
  804ee6:	74 2e                	je     804f16 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804ee8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804eec:	ba 07 04 00 00       	mov    $0x407,%edx
  804ef1:	48 89 c6             	mov    %rax,%rsi
  804ef4:	bf 00 00 00 00       	mov    $0x0,%edi
  804ef9:	48 b8 f9 1f 80 00 00 	movabs $0x801ff9,%rax
  804f00:	00 00 00 
  804f03:	ff d0                	callq  *%rax
  804f05:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  804f08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804f0c:	79 08                	jns    804f16 <ipc_host_recv+0xfa>
	    	return result;
  804f0e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804f11:	e9 84 00 00 00       	jmpq   804f9a <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  804f16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f1a:	48 c1 e8 0c          	shr    $0xc,%rax
  804f1e:	48 89 c2             	mov    %rax,%rdx
  804f21:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804f28:	01 00 00 
  804f2b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f2f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804f35:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  804f39:	b8 03 00 00 00       	mov    $0x3,%eax
  804f3e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  804f42:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  804f46:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  804f4a:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804f4e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  804f52:	4c 89 c3             	mov    %r8,%rbx
  804f55:	0f 01 c1             	vmcall 
  804f58:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  804f5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804f5f:	7e 36                	jle    804f97 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  804f61:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804f64:	41 89 c0             	mov    %eax,%r8d
  804f67:	b9 03 00 00 00       	mov    $0x3,%ecx
  804f6c:	48 ba 48 5c 80 00 00 	movabs $0x805c48,%rdx
  804f73:	00 00 00 
  804f76:	be 67 00 00 00       	mov    $0x67,%esi
  804f7b:	48 bf 75 5c 80 00 00 	movabs $0x805c75,%rdi
  804f82:	00 00 00 
  804f85:	b8 00 00 00 00       	mov    $0x0,%eax
  804f8a:	49 b9 dc 08 80 00 00 	movabs $0x8008dc,%r9
  804f91:	00 00 00 
  804f94:	41 ff d1             	callq  *%r9
	return result;
  804f97:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  804f9a:	48 83 c4 58          	add    $0x58,%rsp
  804f9e:	5b                   	pop    %rbx
  804f9f:	5d                   	pop    %rbp
  804fa0:	c3                   	retq   

0000000000804fa1 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804fa1:	55                   	push   %rbp
  804fa2:	48 89 e5             	mov    %rsp,%rbp
  804fa5:	53                   	push   %rbx
  804fa6:	48 83 ec 68          	sub    $0x68,%rsp
  804faa:	89 7d ac             	mov    %edi,-0x54(%rbp)
  804fad:	89 75 a8             	mov    %esi,-0x58(%rbp)
  804fb0:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  804fb4:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  804fb7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804fbb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  804fbf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  804fc6:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  804fcd:	00 
  804fce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804fd2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  804fd6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804fda:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804fde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804fe2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804fe6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804fea:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  804fee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ff2:	48 c1 e8 27          	shr    $0x27,%rax
  804ff6:	48 89 c2             	mov    %rax,%rdx
  804ff9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  805000:	01 00 00 
  805003:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805007:	83 e0 01             	and    $0x1,%eax
  80500a:	48 85 c0             	test   %rax,%rax
  80500d:	0f 85 88 00 00 00    	jne    80509b <ipc_host_send+0xfa>
  805013:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805017:	48 c1 e8 1e          	shr    $0x1e,%rax
  80501b:	48 89 c2             	mov    %rax,%rdx
  80501e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  805025:	01 00 00 
  805028:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80502c:	83 e0 01             	and    $0x1,%eax
  80502f:	48 85 c0             	test   %rax,%rax
  805032:	74 67                	je     80509b <ipc_host_send+0xfa>
  805034:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805038:	48 c1 e8 15          	shr    $0x15,%rax
  80503c:	48 89 c2             	mov    %rax,%rdx
  80503f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805046:	01 00 00 
  805049:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80504d:	83 e0 01             	and    $0x1,%eax
  805050:	48 85 c0             	test   %rax,%rax
  805053:	74 46                	je     80509b <ipc_host_send+0xfa>
  805055:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805059:	48 c1 e8 0c          	shr    $0xc,%rax
  80505d:	48 89 c2             	mov    %rax,%rdx
  805060:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805067:	01 00 00 
  80506a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80506e:	83 e0 01             	and    $0x1,%eax
  805071:	48 85 c0             	test   %rax,%rax
  805074:	74 25                	je     80509b <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  805076:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80507a:	48 c1 e8 0c          	shr    $0xc,%rax
  80507e:	48 89 c2             	mov    %rax,%rdx
  805081:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805088:	01 00 00 
  80508b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80508f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  805095:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  805099:	eb 0e                	jmp    8050a9 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  80509b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8050a2:	00 00 00 
  8050a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  8050a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050ad:	48 89 c6             	mov    %rax,%rsi
  8050b0:	48 bf 7f 5c 80 00 00 	movabs $0x805c7f,%rdi
  8050b7:	00 00 00 
  8050ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8050bf:	48 ba 15 0b 80 00 00 	movabs $0x800b15,%rdx
  8050c6:	00 00 00 
  8050c9:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  8050cb:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8050ce:	48 98                	cltq   
  8050d0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  8050d4:	8b 45 a8             	mov    -0x58(%rbp),%eax
  8050d7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  8050db:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8050de:	48 98                	cltq   
  8050e0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  8050e4:	b8 02 00 00 00       	mov    $0x2,%eax
  8050e9:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8050ed:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8050f1:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  8050f5:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8050f9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8050fd:	4c 89 c3             	mov    %r8,%rbx
  805100:	0f 01 c1             	vmcall 
  805103:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  805106:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  80510a:	75 0c                	jne    805118 <ipc_host_send+0x177>
			sys_yield();
  80510c:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  805113:	00 00 00 
  805116:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  805118:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  80511c:	74 c6                	je     8050e4 <ipc_host_send+0x143>
	
	if(result !=0)
  80511e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  805122:	74 36                	je     80515a <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  805124:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805127:	41 89 c0             	mov    %eax,%r8d
  80512a:	b9 02 00 00 00       	mov    $0x2,%ecx
  80512f:	48 ba 48 5c 80 00 00 	movabs $0x805c48,%rdx
  805136:	00 00 00 
  805139:	be 94 00 00 00       	mov    $0x94,%esi
  80513e:	48 bf 75 5c 80 00 00 	movabs $0x805c75,%rdi
  805145:	00 00 00 
  805148:	b8 00 00 00 00       	mov    $0x0,%eax
  80514d:	49 b9 dc 08 80 00 00 	movabs $0x8008dc,%r9
  805154:	00 00 00 
  805157:	41 ff d1             	callq  *%r9
}
  80515a:	48 83 c4 68          	add    $0x68,%rsp
  80515e:	5b                   	pop    %rbx
  80515f:	5d                   	pop    %rbp
  805160:	c3                   	retq   

0000000000805161 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805161:	55                   	push   %rbp
  805162:	48 89 e5             	mov    %rsp,%rbp
  805165:	48 83 ec 14          	sub    $0x14,%rsp
  805169:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80516c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805173:	eb 4e                	jmp    8051c3 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  805175:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80517c:	00 00 00 
  80517f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805182:	48 98                	cltq   
  805184:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80518b:	48 01 d0             	add    %rdx,%rax
  80518e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805194:	8b 00                	mov    (%rax),%eax
  805196:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805199:	75 24                	jne    8051bf <ipc_find_env+0x5e>
			return envs[i].env_id;
  80519b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8051a2:	00 00 00 
  8051a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051a8:	48 98                	cltq   
  8051aa:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8051b1:	48 01 d0             	add    %rdx,%rax
  8051b4:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8051ba:	8b 40 08             	mov    0x8(%rax),%eax
  8051bd:	eb 12                	jmp    8051d1 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8051bf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8051c3:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8051ca:	7e a9                	jle    805175 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8051cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8051d1:	c9                   	leaveq 
  8051d2:	c3                   	retq   

00000000008051d3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8051d3:	55                   	push   %rbp
  8051d4:	48 89 e5             	mov    %rsp,%rbp
  8051d7:	48 83 ec 18          	sub    $0x18,%rsp
  8051db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8051df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8051e3:	48 c1 e8 15          	shr    $0x15,%rax
  8051e7:	48 89 c2             	mov    %rax,%rdx
  8051ea:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8051f1:	01 00 00 
  8051f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8051f8:	83 e0 01             	and    $0x1,%eax
  8051fb:	48 85 c0             	test   %rax,%rax
  8051fe:	75 07                	jne    805207 <pageref+0x34>
		return 0;
  805200:	b8 00 00 00 00       	mov    $0x0,%eax
  805205:	eb 53                	jmp    80525a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805207:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80520b:	48 c1 e8 0c          	shr    $0xc,%rax
  80520f:	48 89 c2             	mov    %rax,%rdx
  805212:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805219:	01 00 00 
  80521c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805220:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805224:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805228:	83 e0 01             	and    $0x1,%eax
  80522b:	48 85 c0             	test   %rax,%rax
  80522e:	75 07                	jne    805237 <pageref+0x64>
		return 0;
  805230:	b8 00 00 00 00       	mov    $0x0,%eax
  805235:	eb 23                	jmp    80525a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80523b:	48 c1 e8 0c          	shr    $0xc,%rax
  80523f:	48 89 c2             	mov    %rax,%rdx
  805242:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805249:	00 00 00 
  80524c:	48 c1 e2 04          	shl    $0x4,%rdx
  805250:	48 01 d0             	add    %rdx,%rax
  805253:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805257:	0f b7 c0             	movzwl %ax,%eax
}
  80525a:	c9                   	leaveq 
  80525b:	c3                   	retq   
