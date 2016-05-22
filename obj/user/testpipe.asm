
obj/user/testpipe:     file format elf64-x86-64


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
  80003c:	e8 fe 04 00 00       	callq  80053f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80004f:	89 bd 6c ff ff ff    	mov    %edi,-0x94(%rbp)
  800055:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80005c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800063:	00 00 00 
  800066:	48 bb e4 44 80 00 00 	movabs $0x8044e4,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	if ((i = pipe(p)) < 0)
  800073:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 b3 37 80 00 00 	movabs $0x8037b3,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
  800089:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80008c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800090:	79 30                	jns    8000c2 <umain+0x7f>
		panic("pipe: %e", i);
  800092:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800095:	89 c1                	mov    %eax,%ecx
  800097:	48 ba f0 44 80 00 00 	movabs $0x8044f0,%rdx
  80009e:	00 00 00 
  8000a1:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a6:	48 bf f9 44 80 00 00 	movabs $0x8044f9,%rdi
  8000ad:	00 00 00 
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  8000bc:	00 00 00 
  8000bf:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000c2:	48 b8 39 25 80 00 00 	movabs $0x802539,%rax
  8000c9:	00 00 00 
  8000cc:	ff d0                	callq  *%rax
  8000ce:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8000d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8000d5:	79 30                	jns    800107 <umain+0xc4>
		panic("fork: %e", i);
  8000d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000da:	89 c1                	mov    %eax,%ecx
  8000dc:	48 ba 09 45 80 00 00 	movabs $0x804509,%rdx
  8000e3:	00 00 00 
  8000e6:	be 11 00 00 00       	mov    $0x11,%esi
  8000eb:	48 bf f9 44 80 00 00 	movabs $0x8044f9,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  800101:	00 00 00 
  800104:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800107:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80010b:	0f 85 5c 01 00 00    	jne    80026d <umain+0x22a>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800111:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  800117:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80011e:	00 00 00 
  800121:	48 8b 00             	mov    (%rax),%rax
  800124:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80012a:	89 c6                	mov    %eax,%esi
  80012c:	48 bf 12 45 80 00 00 	movabs $0x804512,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  800142:	00 00 00 
  800145:	ff d1                	callq  *%rcx
		close(p[1]);
  800147:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  80015b:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800161:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800168:	00 00 00 
  80016b:	48 8b 00             	mov    (%rax),%rax
  80016e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800174:	89 c6                	mov    %eax,%esi
  800176:	48 bf 2f 45 80 00 00 	movabs $0x80452f,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  80018c:	00 00 00 
  80018f:	ff d1                	callq  *%rcx
		i = readn(p[0], buf, sizeof buf-1);
  800191:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800197:	48 8d 4d 80          	lea    -0x80(%rbp),%rcx
  80019b:	ba 63 00 00 00       	mov    $0x63,%edx
  8001a0:	48 89 ce             	mov    %rcx,%rsi
  8001a3:	89 c7                	mov    %eax,%edi
  8001a5:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  8001ac:	00 00 00 
  8001af:	ff d0                	callq  *%rax
  8001b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (i < 0)
  8001b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001b8:	79 30                	jns    8001ea <umain+0x1a7>
			panic("read: %e", i);
  8001ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bd:	89 c1                	mov    %eax,%ecx
  8001bf:	48 ba 4c 45 80 00 00 	movabs $0x80454c,%rdx
  8001c6:	00 00 00 
  8001c9:	be 19 00 00 00       	mov    $0x19,%esi
  8001ce:	48 bf f9 44 80 00 00 	movabs $0x8044f9,%rdi
  8001d5:	00 00 00 
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  8001e4:	00 00 00 
  8001e7:	41 ff d0             	callq  *%r8
		buf[i] = 0;
  8001ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ed:	48 98                	cltq   
  8001ef:	c6 44 05 80 00       	movb   $0x0,-0x80(%rbp,%rax,1)
		if (strcmp(buf, msg) == 0)
  8001f4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001fb:	00 00 00 
  8001fe:	48 8b 10             	mov    (%rax),%rdx
  800201:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800205:	48 89 d6             	mov    %rdx,%rsi
  800208:	48 89 c7             	mov    %rax,%rdi
  80020b:	48 b8 35 15 80 00 00 	movabs $0x801535,%rax
  800212:	00 00 00 
  800215:	ff d0                	callq  *%rax
  800217:	85 c0                	test   %eax,%eax
  800219:	75 1d                	jne    800238 <umain+0x1f5>
			cprintf("\npipe read closed properly\n");
  80021b:	48 bf 55 45 80 00 00 	movabs $0x804555,%rdi
  800222:	00 00 00 
  800225:	b8 00 00 00 00       	mov    $0x0,%eax
  80022a:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  800231:	00 00 00 
  800234:	ff d2                	callq  *%rdx
  800236:	eb 24                	jmp    80025c <umain+0x219>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  800238:	48 8d 55 80          	lea    -0x80(%rbp),%rdx
  80023c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023f:	89 c6                	mov    %eax,%esi
  800241:	48 bf 71 45 80 00 00 	movabs $0x804571,%rdi
  800248:	00 00 00 
  80024b:	b8 00 00 00 00       	mov    $0x0,%eax
  800250:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  800257:	00 00 00 
  80025a:	ff d1                	callq  *%rcx
		exit();
  80025c:	48 b8 c2 05 80 00 00 	movabs $0x8005c2,%rax
  800263:	00 00 00 
  800266:	ff d0                	callq  *%rax
  800268:	e9 2b 01 00 00       	jmpq   800398 <umain+0x355>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80026d:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800273:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80027a:	00 00 00 
  80027d:	48 8b 00             	mov    (%rax),%rax
  800280:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800286:	89 c6                	mov    %eax,%esi
  800288:	48 bf 12 45 80 00 00 	movabs $0x804512,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  80029e:	00 00 00 
  8002a1:	ff d1                	callq  *%rcx
		close(p[0]);
  8002a3:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8002a9:	89 c7                	mov    %eax,%edi
  8002ab:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  8002b2:	00 00 00 
  8002b5:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002b7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  8002bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002c4:	00 00 00 
  8002c7:	48 8b 00             	mov    (%rax),%rax
  8002ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002d0:	89 c6                	mov    %eax,%esi
  8002d2:	48 bf 84 45 80 00 00 	movabs $0x804584,%rdi
  8002d9:	00 00 00 
  8002dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e1:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  8002e8:	00 00 00 
  8002eb:	ff d1                	callq  *%rcx
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8002ed:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002f4:	00 00 00 
  8002f7:	48 8b 00             	mov    (%rax),%rax
  8002fa:	48 89 c7             	mov    %rax,%rdi
  8002fd:	48 b8 67 13 80 00 00 	movabs $0x801367,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax
  800309:	48 63 d0             	movslq %eax,%rdx
  80030c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800313:	00 00 00 
  800316:	48 8b 08             	mov    (%rax),%rcx
  800319:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80031f:	48 89 ce             	mov    %rcx,%rsi
  800322:	89 c7                	mov    %eax,%edi
  800324:	48 b8 44 2e 80 00 00 	movabs $0x802e44,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
  800330:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800333:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80033a:	00 00 00 
  80033d:	48 8b 00             	mov    (%rax),%rax
  800340:	48 89 c7             	mov    %rax,%rdi
  800343:	48 b8 67 13 80 00 00 	movabs $0x801367,%rax
  80034a:	00 00 00 
  80034d:	ff d0                	callq  *%rax
  80034f:	39 45 ec             	cmp    %eax,-0x14(%rbp)
  800352:	74 30                	je     800384 <umain+0x341>
			panic("write: %e", i);
  800354:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800357:	89 c1                	mov    %eax,%ecx
  800359:	48 ba a1 45 80 00 00 	movabs $0x8045a1,%rdx
  800360:	00 00 00 
  800363:	be 25 00 00 00       	mov    $0x25,%esi
  800368:	48 bf f9 44 80 00 00 	movabs $0x8044f9,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  80037e:	00 00 00 
  800381:	41 ff d0             	callq  *%r8
		close(p[1]);
  800384:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80038a:	89 c7                	mov    %eax,%edi
  80038c:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  800393:	00 00 00 
  800396:	ff d0                	callq  *%rax
	}
	wait(pid);
  800398:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80039b:	89 c7                	mov    %eax,%edi
  80039d:	48 b8 7c 3d 80 00 00 	movabs $0x803d7c,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  8003a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003b0:	00 00 00 
  8003b3:	48 bb ab 45 80 00 00 	movabs $0x8045ab,%rbx
  8003ba:	00 00 00 
  8003bd:	48 89 18             	mov    %rbx,(%rax)
	if ((i = pipe(p)) < 0)
  8003c0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003c7:	48 89 c7             	mov    %rax,%rdi
  8003ca:	48 b8 b3 37 80 00 00 	movabs $0x8037b3,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax
  8003d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8003d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003dd:	79 30                	jns    80040f <umain+0x3cc>
		panic("pipe: %e", i);
  8003df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003e2:	89 c1                	mov    %eax,%ecx
  8003e4:	48 ba f0 44 80 00 00 	movabs $0x8044f0,%rdx
  8003eb:	00 00 00 
  8003ee:	be 2c 00 00 00       	mov    $0x2c,%esi
  8003f3:	48 bf f9 44 80 00 00 	movabs $0x8044f9,%rdi
  8003fa:	00 00 00 
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  800409:	00 00 00 
  80040c:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  80040f:	48 b8 39 25 80 00 00 	movabs $0x802539,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
  80041b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80041e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800422:	79 30                	jns    800454 <umain+0x411>
		panic("fork: %e", i);
  800424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800427:	89 c1                	mov    %eax,%ecx
  800429:	48 ba 09 45 80 00 00 	movabs $0x804509,%rdx
  800430:	00 00 00 
  800433:	be 2f 00 00 00       	mov    $0x2f,%esi
  800438:	48 bf f9 44 80 00 00 	movabs $0x8044f9,%rdi
  80043f:	00 00 00 
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  80044e:	00 00 00 
  800451:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800454:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800458:	0f 85 83 00 00 00    	jne    8004e1 <umain+0x49e>
		close(p[0]);
  80045e:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800464:	89 c7                	mov    %eax,%edi
  800466:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
		while (1) {
			cprintf(".");
  800472:	48 bf b8 45 80 00 00 	movabs $0x8045b8,%rdi
  800479:	00 00 00 
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  800488:	00 00 00 
  80048b:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  80048d:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  800493:	ba 01 00 00 00       	mov    $0x1,%edx
  800498:	48 be ba 45 80 00 00 	movabs $0x8045ba,%rsi
  80049f:	00 00 00 
  8004a2:	89 c7                	mov    %eax,%edi
  8004a4:	48 b8 44 2e 80 00 00 	movabs $0x802e44,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
  8004b0:	83 f8 01             	cmp    $0x1,%eax
  8004b3:	74 2a                	je     8004df <umain+0x49c>
				break;
  8004b5:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  8004b6:	48 bf bc 45 80 00 00 	movabs $0x8045bc,%rdi
  8004bd:	00 00 00 
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  8004cc:	00 00 00 
  8004cf:	ff d2                	callq  *%rdx
		exit();
  8004d1:	48 b8 c2 05 80 00 00 	movabs $0x8005c2,%rax
  8004d8:	00 00 00 
  8004db:	ff d0                	callq  *%rax
  8004dd:	eb 02                	jmp    8004e1 <umain+0x49e>
		close(p[0]);
		while (1) {
			cprintf(".");
			if (write(p[1], "x", 1) != 1)
				break;
		}
  8004df:	eb 91                	jmp    800472 <umain+0x42f>
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  8004e1:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8004e7:	89 c7                	mov    %eax,%edi
  8004e9:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  8004f0:	00 00 00 
  8004f3:	ff d0                	callq  *%rax
	close(p[1]);
  8004f5:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8004fb:	89 c7                	mov    %eax,%edi
  8004fd:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
	wait(pid);
  800509:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80050c:	89 c7                	mov    %eax,%edi
  80050e:	48 b8 7c 3d 80 00 00 	movabs $0x803d7c,%rax
  800515:	00 00 00 
  800518:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  80051a:	48 bf d9 45 80 00 00 	movabs $0x8045d9,%rdi
  800521:	00 00 00 
  800524:	b8 00 00 00 00       	mov    $0x0,%eax
  800529:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  800530:	00 00 00 
  800533:	ff d2                	callq  *%rdx
}
  800535:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80053c:	5b                   	pop    %rbx
  80053d:	5d                   	pop    %rbp
  80053e:	c3                   	retq   

000000000080053f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	48 83 ec 10          	sub    $0x10,%rsp
  800547:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80054a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80054e:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax
  80055a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80055f:	48 98                	cltq   
  800561:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800568:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80056f:	00 00 00 
  800572:	48 01 c2             	add    %rax,%rdx
  800575:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80057c:	00 00 00 
  80057f:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800582:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800586:	7e 14                	jle    80059c <libmain+0x5d>
		binaryname = argv[0];
  800588:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058c:	48 8b 10             	mov    (%rax),%rdx
  80058f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800596:	00 00 00 
  800599:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80059c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005a3:	48 89 d6             	mov    %rdx,%rsi
  8005a6:	89 c7                	mov    %eax,%edi
  8005a8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8005af:	00 00 00 
  8005b2:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8005b4:	48 b8 c2 05 80 00 00 	movabs $0x8005c2,%rax
  8005bb:	00 00 00 
  8005be:	ff d0                	callq  *%rax
}
  8005c0:	c9                   	leaveq 
  8005c1:	c3                   	retq   

00000000008005c2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005c2:	55                   	push   %rbp
  8005c3:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005c6:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  8005cd:	00 00 00 
  8005d0:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005d7:	48 b8 42 1c 80 00 00 	movabs $0x801c42,%rax
  8005de:	00 00 00 
  8005e1:	ff d0                	callq  *%rax

}
  8005e3:	5d                   	pop    %rbp
  8005e4:	c3                   	retq   

00000000008005e5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005e5:	55                   	push   %rbp
  8005e6:	48 89 e5             	mov    %rsp,%rbp
  8005e9:	53                   	push   %rbx
  8005ea:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005f1:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005f8:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005fe:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800605:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80060c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800613:	84 c0                	test   %al,%al
  800615:	74 23                	je     80063a <_panic+0x55>
  800617:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80061e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800622:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800626:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80062a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80062e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800632:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800636:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80063a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800641:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800648:	00 00 00 
  80064b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800652:	00 00 00 
  800655:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800659:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800660:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800667:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80066e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800675:	00 00 00 
  800678:	48 8b 18             	mov    (%rax),%rbx
  80067b:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  800682:	00 00 00 
  800685:	ff d0                	callq  *%rax
  800687:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80068d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800694:	41 89 c8             	mov    %ecx,%r8d
  800697:	48 89 d1             	mov    %rdx,%rcx
  80069a:	48 89 da             	mov    %rbx,%rdx
  80069d:	89 c6                	mov    %eax,%esi
  80069f:	48 bf f8 45 80 00 00 	movabs $0x8045f8,%rdi
  8006a6:	00 00 00 
  8006a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ae:	49 b9 1e 08 80 00 00 	movabs $0x80081e,%r9
  8006b5:	00 00 00 
  8006b8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006bb:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006c2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006c9:	48 89 d6             	mov    %rdx,%rsi
  8006cc:	48 89 c7             	mov    %rax,%rdi
  8006cf:	48 b8 72 07 80 00 00 	movabs $0x800772,%rax
  8006d6:	00 00 00 
  8006d9:	ff d0                	callq  *%rax
	cprintf("\n");
  8006db:	48 bf 1b 46 80 00 00 	movabs $0x80461b,%rdi
  8006e2:	00 00 00 
  8006e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ea:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  8006f1:	00 00 00 
  8006f4:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006f6:	cc                   	int3   
  8006f7:	eb fd                	jmp    8006f6 <_panic+0x111>

00000000008006f9 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006f9:	55                   	push   %rbp
  8006fa:	48 89 e5             	mov    %rsp,%rbp
  8006fd:	48 83 ec 10          	sub    $0x10,%rsp
  800701:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800704:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800708:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80070c:	8b 00                	mov    (%rax),%eax
  80070e:	8d 48 01             	lea    0x1(%rax),%ecx
  800711:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800715:	89 0a                	mov    %ecx,(%rdx)
  800717:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80071a:	89 d1                	mov    %edx,%ecx
  80071c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800720:	48 98                	cltq   
  800722:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80072a:	8b 00                	mov    (%rax),%eax
  80072c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800731:	75 2c                	jne    80075f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800737:	8b 00                	mov    (%rax),%eax
  800739:	48 98                	cltq   
  80073b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80073f:	48 83 c2 08          	add    $0x8,%rdx
  800743:	48 89 c6             	mov    %rax,%rsi
  800746:	48 89 d7             	mov    %rdx,%rdi
  800749:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  800750:	00 00 00 
  800753:	ff d0                	callq  *%rax
        b->idx = 0;
  800755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800759:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80075f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800763:	8b 40 04             	mov    0x4(%rax),%eax
  800766:	8d 50 01             	lea    0x1(%rax),%edx
  800769:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80076d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800770:	c9                   	leaveq 
  800771:	c3                   	retq   

0000000000800772 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800772:	55                   	push   %rbp
  800773:	48 89 e5             	mov    %rsp,%rbp
  800776:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80077d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800784:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80078b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800792:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800799:	48 8b 0a             	mov    (%rdx),%rcx
  80079c:	48 89 08             	mov    %rcx,(%rax)
  80079f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007a3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007a7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007ab:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8007af:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007b6:	00 00 00 
    b.cnt = 0;
  8007b9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007c0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8007c3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007ca:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007d1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007d8:	48 89 c6             	mov    %rax,%rsi
  8007db:	48 bf f9 06 80 00 00 	movabs $0x8006f9,%rdi
  8007e2:	00 00 00 
  8007e5:	48 b8 d1 0b 80 00 00 	movabs $0x800bd1,%rax
  8007ec:	00 00 00 
  8007ef:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007f1:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007f7:	48 98                	cltq   
  8007f9:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800800:	48 83 c2 08          	add    $0x8,%rdx
  800804:	48 89 c6             	mov    %rax,%rsi
  800807:	48 89 d7             	mov    %rdx,%rdi
  80080a:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  800811:	00 00 00 
  800814:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800816:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80081c:	c9                   	leaveq 
  80081d:	c3                   	retq   

000000000080081e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80081e:	55                   	push   %rbp
  80081f:	48 89 e5             	mov    %rsp,%rbp
  800822:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800829:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800830:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800837:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80083e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800845:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80084c:	84 c0                	test   %al,%al
  80084e:	74 20                	je     800870 <cprintf+0x52>
  800850:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800854:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800858:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80085c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800860:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800864:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800868:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80086c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800870:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800877:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80087e:	00 00 00 
  800881:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800888:	00 00 00 
  80088b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80088f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800896:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80089d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8008a4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8008ab:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8008b2:	48 8b 0a             	mov    (%rdx),%rcx
  8008b5:	48 89 08             	mov    %rcx,(%rax)
  8008b8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008bc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008c0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008c4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008c8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008cf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008d6:	48 89 d6             	mov    %rdx,%rsi
  8008d9:	48 89 c7             	mov    %rax,%rdi
  8008dc:	48 b8 72 07 80 00 00 	movabs $0x800772,%rax
  8008e3:	00 00 00 
  8008e6:	ff d0                	callq  *%rax
  8008e8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008ee:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008f4:	c9                   	leaveq 
  8008f5:	c3                   	retq   

00000000008008f6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008f6:	55                   	push   %rbp
  8008f7:	48 89 e5             	mov    %rsp,%rbp
  8008fa:	53                   	push   %rbx
  8008fb:	48 83 ec 38          	sub    $0x38,%rsp
  8008ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800903:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800907:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80090b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80090e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800912:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800916:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800919:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80091d:	77 3b                	ja     80095a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80091f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800922:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800926:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80092d:	ba 00 00 00 00       	mov    $0x0,%edx
  800932:	48 f7 f3             	div    %rbx
  800935:	48 89 c2             	mov    %rax,%rdx
  800938:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80093b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80093e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800946:	41 89 f9             	mov    %edi,%r9d
  800949:	48 89 c7             	mov    %rax,%rdi
  80094c:	48 b8 f6 08 80 00 00 	movabs $0x8008f6,%rax
  800953:	00 00 00 
  800956:	ff d0                	callq  *%rax
  800958:	eb 1e                	jmp    800978 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80095a:	eb 12                	jmp    80096e <printnum+0x78>
			putch(padc, putdat);
  80095c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800960:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800963:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800967:	48 89 ce             	mov    %rcx,%rsi
  80096a:	89 d7                	mov    %edx,%edi
  80096c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80096e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800972:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800976:	7f e4                	jg     80095c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800978:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80097b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80097f:	ba 00 00 00 00       	mov    $0x0,%edx
  800984:	48 f7 f1             	div    %rcx
  800987:	48 89 d0             	mov    %rdx,%rax
  80098a:	48 ba 10 48 80 00 00 	movabs $0x804810,%rdx
  800991:	00 00 00 
  800994:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800998:	0f be d0             	movsbl %al,%edx
  80099b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80099f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a3:	48 89 ce             	mov    %rcx,%rsi
  8009a6:	89 d7                	mov    %edx,%edi
  8009a8:	ff d0                	callq  *%rax
}
  8009aa:	48 83 c4 38          	add    $0x38,%rsp
  8009ae:	5b                   	pop    %rbx
  8009af:	5d                   	pop    %rbp
  8009b0:	c3                   	retq   

00000000008009b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009b1:	55                   	push   %rbp
  8009b2:	48 89 e5             	mov    %rsp,%rbp
  8009b5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009bd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8009c0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009c4:	7e 52                	jle    800a18 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	8b 00                	mov    (%rax),%eax
  8009cc:	83 f8 30             	cmp    $0x30,%eax
  8009cf:	73 24                	jae    8009f5 <getuint+0x44>
  8009d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dd:	8b 00                	mov    (%rax),%eax
  8009df:	89 c0                	mov    %eax,%eax
  8009e1:	48 01 d0             	add    %rdx,%rax
  8009e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e8:	8b 12                	mov    (%rdx),%edx
  8009ea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f1:	89 0a                	mov    %ecx,(%rdx)
  8009f3:	eb 17                	jmp    800a0c <getuint+0x5b>
  8009f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009fd:	48 89 d0             	mov    %rdx,%rax
  800a00:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a08:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a0c:	48 8b 00             	mov    (%rax),%rax
  800a0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a13:	e9 a3 00 00 00       	jmpq   800abb <getuint+0x10a>
	else if (lflag)
  800a18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a1c:	74 4f                	je     800a6d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a22:	8b 00                	mov    (%rax),%eax
  800a24:	83 f8 30             	cmp    $0x30,%eax
  800a27:	73 24                	jae    800a4d <getuint+0x9c>
  800a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a35:	8b 00                	mov    (%rax),%eax
  800a37:	89 c0                	mov    %eax,%eax
  800a39:	48 01 d0             	add    %rdx,%rax
  800a3c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a40:	8b 12                	mov    (%rdx),%edx
  800a42:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a49:	89 0a                	mov    %ecx,(%rdx)
  800a4b:	eb 17                	jmp    800a64 <getuint+0xb3>
  800a4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a51:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a55:	48 89 d0             	mov    %rdx,%rax
  800a58:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a60:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a64:	48 8b 00             	mov    (%rax),%rax
  800a67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a6b:	eb 4e                	jmp    800abb <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a71:	8b 00                	mov    (%rax),%eax
  800a73:	83 f8 30             	cmp    $0x30,%eax
  800a76:	73 24                	jae    800a9c <getuint+0xeb>
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a84:	8b 00                	mov    (%rax),%eax
  800a86:	89 c0                	mov    %eax,%eax
  800a88:	48 01 d0             	add    %rdx,%rax
  800a8b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8f:	8b 12                	mov    (%rdx),%edx
  800a91:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a94:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a98:	89 0a                	mov    %ecx,(%rdx)
  800a9a:	eb 17                	jmp    800ab3 <getuint+0x102>
  800a9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aa4:	48 89 d0             	mov    %rdx,%rax
  800aa7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aaf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ab3:	8b 00                	mov    (%rax),%eax
  800ab5:	89 c0                	mov    %eax,%eax
  800ab7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800abb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800abf:	c9                   	leaveq 
  800ac0:	c3                   	retq   

0000000000800ac1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ac1:	55                   	push   %rbp
  800ac2:	48 89 e5             	mov    %rsp,%rbp
  800ac5:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ac9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800acd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800ad0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ad4:	7e 52                	jle    800b28 <getint+0x67>
		x=va_arg(*ap, long long);
  800ad6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ada:	8b 00                	mov    (%rax),%eax
  800adc:	83 f8 30             	cmp    $0x30,%eax
  800adf:	73 24                	jae    800b05 <getint+0x44>
  800ae1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ae9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aed:	8b 00                	mov    (%rax),%eax
  800aef:	89 c0                	mov    %eax,%eax
  800af1:	48 01 d0             	add    %rdx,%rax
  800af4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af8:	8b 12                	mov    (%rdx),%edx
  800afa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800afd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b01:	89 0a                	mov    %ecx,(%rdx)
  800b03:	eb 17                	jmp    800b1c <getint+0x5b>
  800b05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b09:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b0d:	48 89 d0             	mov    %rdx,%rax
  800b10:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b18:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b1c:	48 8b 00             	mov    (%rax),%rax
  800b1f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b23:	e9 a3 00 00 00       	jmpq   800bcb <getint+0x10a>
	else if (lflag)
  800b28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b2c:	74 4f                	je     800b7d <getint+0xbc>
		x=va_arg(*ap, long);
  800b2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b32:	8b 00                	mov    (%rax),%eax
  800b34:	83 f8 30             	cmp    $0x30,%eax
  800b37:	73 24                	jae    800b5d <getint+0x9c>
  800b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b45:	8b 00                	mov    (%rax),%eax
  800b47:	89 c0                	mov    %eax,%eax
  800b49:	48 01 d0             	add    %rdx,%rax
  800b4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b50:	8b 12                	mov    (%rdx),%edx
  800b52:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b59:	89 0a                	mov    %ecx,(%rdx)
  800b5b:	eb 17                	jmp    800b74 <getint+0xb3>
  800b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b61:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b65:	48 89 d0             	mov    %rdx,%rax
  800b68:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b6c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b70:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b74:	48 8b 00             	mov    (%rax),%rax
  800b77:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b7b:	eb 4e                	jmp    800bcb <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b81:	8b 00                	mov    (%rax),%eax
  800b83:	83 f8 30             	cmp    $0x30,%eax
  800b86:	73 24                	jae    800bac <getint+0xeb>
  800b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b94:	8b 00                	mov    (%rax),%eax
  800b96:	89 c0                	mov    %eax,%eax
  800b98:	48 01 d0             	add    %rdx,%rax
  800b9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b9f:	8b 12                	mov    (%rdx),%edx
  800ba1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ba4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba8:	89 0a                	mov    %ecx,(%rdx)
  800baa:	eb 17                	jmp    800bc3 <getint+0x102>
  800bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bb4:	48 89 d0             	mov    %rdx,%rax
  800bb7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bbb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bbf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bc3:	8b 00                	mov    (%rax),%eax
  800bc5:	48 98                	cltq   
  800bc7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bcf:	c9                   	leaveq 
  800bd0:	c3                   	retq   

0000000000800bd1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bd1:	55                   	push   %rbp
  800bd2:	48 89 e5             	mov    %rsp,%rbp
  800bd5:	41 54                	push   %r12
  800bd7:	53                   	push   %rbx
  800bd8:	48 83 ec 60          	sub    $0x60,%rsp
  800bdc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800be0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800be4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800be8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bec:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bf4:	48 8b 0a             	mov    (%rdx),%rcx
  800bf7:	48 89 08             	mov    %rcx,(%rax)
  800bfa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bfe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c02:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c06:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c0a:	eb 17                	jmp    800c23 <vprintfmt+0x52>
			if (ch == '\0')
  800c0c:	85 db                	test   %ebx,%ebx
  800c0e:	0f 84 cc 04 00 00    	je     8010e0 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800c14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1c:	48 89 d6             	mov    %rdx,%rsi
  800c1f:	89 df                	mov    %ebx,%edi
  800c21:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c23:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c27:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c2b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c2f:	0f b6 00             	movzbl (%rax),%eax
  800c32:	0f b6 d8             	movzbl %al,%ebx
  800c35:	83 fb 25             	cmp    $0x25,%ebx
  800c38:	75 d2                	jne    800c0c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c3a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c3e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c45:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c4c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c53:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c5a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c5e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c62:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c66:	0f b6 00             	movzbl (%rax),%eax
  800c69:	0f b6 d8             	movzbl %al,%ebx
  800c6c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c6f:	83 f8 55             	cmp    $0x55,%eax
  800c72:	0f 87 34 04 00 00    	ja     8010ac <vprintfmt+0x4db>
  800c78:	89 c0                	mov    %eax,%eax
  800c7a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c81:	00 
  800c82:	48 b8 38 48 80 00 00 	movabs $0x804838,%rax
  800c89:	00 00 00 
  800c8c:	48 01 d0             	add    %rdx,%rax
  800c8f:	48 8b 00             	mov    (%rax),%rax
  800c92:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c94:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c98:	eb c0                	jmp    800c5a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c9a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c9e:	eb ba                	jmp    800c5a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ca7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800caa:	89 d0                	mov    %edx,%eax
  800cac:	c1 e0 02             	shl    $0x2,%eax
  800caf:	01 d0                	add    %edx,%eax
  800cb1:	01 c0                	add    %eax,%eax
  800cb3:	01 d8                	add    %ebx,%eax
  800cb5:	83 e8 30             	sub    $0x30,%eax
  800cb8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800cbb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cbf:	0f b6 00             	movzbl (%rax),%eax
  800cc2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cc5:	83 fb 2f             	cmp    $0x2f,%ebx
  800cc8:	7e 0c                	jle    800cd6 <vprintfmt+0x105>
  800cca:	83 fb 39             	cmp    $0x39,%ebx
  800ccd:	7f 07                	jg     800cd6 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccf:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd4:	eb d1                	jmp    800ca7 <vprintfmt+0xd6>
			goto process_precision;
  800cd6:	eb 58                	jmp    800d30 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800cd8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cdb:	83 f8 30             	cmp    $0x30,%eax
  800cde:	73 17                	jae    800cf7 <vprintfmt+0x126>
  800ce0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ce4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce7:	89 c0                	mov    %eax,%eax
  800ce9:	48 01 d0             	add    %rdx,%rax
  800cec:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cef:	83 c2 08             	add    $0x8,%edx
  800cf2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cf5:	eb 0f                	jmp    800d06 <vprintfmt+0x135>
  800cf7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cfb:	48 89 d0             	mov    %rdx,%rax
  800cfe:	48 83 c2 08          	add    $0x8,%rdx
  800d02:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d06:	8b 00                	mov    (%rax),%eax
  800d08:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d0b:	eb 23                	jmp    800d30 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800d0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d11:	79 0c                	jns    800d1f <vprintfmt+0x14e>
				width = 0;
  800d13:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d1a:	e9 3b ff ff ff       	jmpq   800c5a <vprintfmt+0x89>
  800d1f:	e9 36 ff ff ff       	jmpq   800c5a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d24:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d2b:	e9 2a ff ff ff       	jmpq   800c5a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d30:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d34:	79 12                	jns    800d48 <vprintfmt+0x177>
				width = precision, precision = -1;
  800d36:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d39:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d3c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d43:	e9 12 ff ff ff       	jmpq   800c5a <vprintfmt+0x89>
  800d48:	e9 0d ff ff ff       	jmpq   800c5a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d4d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d51:	e9 04 ff ff ff       	jmpq   800c5a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d59:	83 f8 30             	cmp    $0x30,%eax
  800d5c:	73 17                	jae    800d75 <vprintfmt+0x1a4>
  800d5e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d65:	89 c0                	mov    %eax,%eax
  800d67:	48 01 d0             	add    %rdx,%rax
  800d6a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d6d:	83 c2 08             	add    $0x8,%edx
  800d70:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d73:	eb 0f                	jmp    800d84 <vprintfmt+0x1b3>
  800d75:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d79:	48 89 d0             	mov    %rdx,%rax
  800d7c:	48 83 c2 08          	add    $0x8,%rdx
  800d80:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d84:	8b 10                	mov    (%rax),%edx
  800d86:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d8e:	48 89 ce             	mov    %rcx,%rsi
  800d91:	89 d7                	mov    %edx,%edi
  800d93:	ff d0                	callq  *%rax
			break;
  800d95:	e9 40 03 00 00       	jmpq   8010da <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d9d:	83 f8 30             	cmp    $0x30,%eax
  800da0:	73 17                	jae    800db9 <vprintfmt+0x1e8>
  800da2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800da6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da9:	89 c0                	mov    %eax,%eax
  800dab:	48 01 d0             	add    %rdx,%rax
  800dae:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800db1:	83 c2 08             	add    $0x8,%edx
  800db4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800db7:	eb 0f                	jmp    800dc8 <vprintfmt+0x1f7>
  800db9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dbd:	48 89 d0             	mov    %rdx,%rax
  800dc0:	48 83 c2 08          	add    $0x8,%rdx
  800dc4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dc8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800dca:	85 db                	test   %ebx,%ebx
  800dcc:	79 02                	jns    800dd0 <vprintfmt+0x1ff>
				err = -err;
  800dce:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dd0:	83 fb 15             	cmp    $0x15,%ebx
  800dd3:	7f 16                	jg     800deb <vprintfmt+0x21a>
  800dd5:	48 b8 60 47 80 00 00 	movabs $0x804760,%rax
  800ddc:	00 00 00 
  800ddf:	48 63 d3             	movslq %ebx,%rdx
  800de2:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800de6:	4d 85 e4             	test   %r12,%r12
  800de9:	75 2e                	jne    800e19 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800deb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800def:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df3:	89 d9                	mov    %ebx,%ecx
  800df5:	48 ba 21 48 80 00 00 	movabs $0x804821,%rdx
  800dfc:	00 00 00 
  800dff:	48 89 c7             	mov    %rax,%rdi
  800e02:	b8 00 00 00 00       	mov    $0x0,%eax
  800e07:	49 b8 e9 10 80 00 00 	movabs $0x8010e9,%r8
  800e0e:	00 00 00 
  800e11:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e14:	e9 c1 02 00 00       	jmpq   8010da <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e19:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e21:	4c 89 e1             	mov    %r12,%rcx
  800e24:	48 ba 2a 48 80 00 00 	movabs $0x80482a,%rdx
  800e2b:	00 00 00 
  800e2e:	48 89 c7             	mov    %rax,%rdi
  800e31:	b8 00 00 00 00       	mov    $0x0,%eax
  800e36:	49 b8 e9 10 80 00 00 	movabs $0x8010e9,%r8
  800e3d:	00 00 00 
  800e40:	41 ff d0             	callq  *%r8
			break;
  800e43:	e9 92 02 00 00       	jmpq   8010da <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4b:	83 f8 30             	cmp    $0x30,%eax
  800e4e:	73 17                	jae    800e67 <vprintfmt+0x296>
  800e50:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e54:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e57:	89 c0                	mov    %eax,%eax
  800e59:	48 01 d0             	add    %rdx,%rax
  800e5c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e5f:	83 c2 08             	add    $0x8,%edx
  800e62:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e65:	eb 0f                	jmp    800e76 <vprintfmt+0x2a5>
  800e67:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e6b:	48 89 d0             	mov    %rdx,%rax
  800e6e:	48 83 c2 08          	add    $0x8,%rdx
  800e72:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e76:	4c 8b 20             	mov    (%rax),%r12
  800e79:	4d 85 e4             	test   %r12,%r12
  800e7c:	75 0a                	jne    800e88 <vprintfmt+0x2b7>
				p = "(null)";
  800e7e:	49 bc 2d 48 80 00 00 	movabs $0x80482d,%r12
  800e85:	00 00 00 
			if (width > 0 && padc != '-')
  800e88:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e8c:	7e 3f                	jle    800ecd <vprintfmt+0x2fc>
  800e8e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e92:	74 39                	je     800ecd <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e94:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e97:	48 98                	cltq   
  800e99:	48 89 c6             	mov    %rax,%rsi
  800e9c:	4c 89 e7             	mov    %r12,%rdi
  800e9f:	48 b8 95 13 80 00 00 	movabs $0x801395,%rax
  800ea6:	00 00 00 
  800ea9:	ff d0                	callq  *%rax
  800eab:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800eae:	eb 17                	jmp    800ec7 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800eb0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800eb4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800eb8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebc:	48 89 ce             	mov    %rcx,%rsi
  800ebf:	89 d7                	mov    %edx,%edi
  800ec1:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ec3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ec7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ecb:	7f e3                	jg     800eb0 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ecd:	eb 37                	jmp    800f06 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800ecf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ed3:	74 1e                	je     800ef3 <vprintfmt+0x322>
  800ed5:	83 fb 1f             	cmp    $0x1f,%ebx
  800ed8:	7e 05                	jle    800edf <vprintfmt+0x30e>
  800eda:	83 fb 7e             	cmp    $0x7e,%ebx
  800edd:	7e 14                	jle    800ef3 <vprintfmt+0x322>
					putch('?', putdat);
  800edf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee7:	48 89 d6             	mov    %rdx,%rsi
  800eea:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800eef:	ff d0                	callq  *%rax
  800ef1:	eb 0f                	jmp    800f02 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800ef3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efb:	48 89 d6             	mov    %rdx,%rsi
  800efe:	89 df                	mov    %ebx,%edi
  800f00:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f02:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f06:	4c 89 e0             	mov    %r12,%rax
  800f09:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f0d:	0f b6 00             	movzbl (%rax),%eax
  800f10:	0f be d8             	movsbl %al,%ebx
  800f13:	85 db                	test   %ebx,%ebx
  800f15:	74 10                	je     800f27 <vprintfmt+0x356>
  800f17:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f1b:	78 b2                	js     800ecf <vprintfmt+0x2fe>
  800f1d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f21:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f25:	79 a8                	jns    800ecf <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f27:	eb 16                	jmp    800f3f <vprintfmt+0x36e>
				putch(' ', putdat);
  800f29:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f31:	48 89 d6             	mov    %rdx,%rsi
  800f34:	bf 20 00 00 00       	mov    $0x20,%edi
  800f39:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f3b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f3f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f43:	7f e4                	jg     800f29 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800f45:	e9 90 01 00 00       	jmpq   8010da <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f4a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f4e:	be 03 00 00 00       	mov    $0x3,%esi
  800f53:	48 89 c7             	mov    %rax,%rdi
  800f56:	48 b8 c1 0a 80 00 00 	movabs $0x800ac1,%rax
  800f5d:	00 00 00 
  800f60:	ff d0                	callq  *%rax
  800f62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6a:	48 85 c0             	test   %rax,%rax
  800f6d:	79 1d                	jns    800f8c <vprintfmt+0x3bb>
				putch('-', putdat);
  800f6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f77:	48 89 d6             	mov    %rdx,%rsi
  800f7a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f7f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f85:	48 f7 d8             	neg    %rax
  800f88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f8c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f93:	e9 d5 00 00 00       	jmpq   80106d <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f98:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f9c:	be 03 00 00 00       	mov    $0x3,%esi
  800fa1:	48 89 c7             	mov    %rax,%rdi
  800fa4:	48 b8 b1 09 80 00 00 	movabs $0x8009b1,%rax
  800fab:	00 00 00 
  800fae:	ff d0                	callq  *%rax
  800fb0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fb4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fbb:	e9 ad 00 00 00       	jmpq   80106d <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800fc0:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800fc3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fc7:	89 d6                	mov    %edx,%esi
  800fc9:	48 89 c7             	mov    %rax,%rdi
  800fcc:	48 b8 c1 0a 80 00 00 	movabs $0x800ac1,%rax
  800fd3:	00 00 00 
  800fd6:	ff d0                	callq  *%rax
  800fd8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800fdc:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800fe3:	e9 85 00 00 00       	jmpq   80106d <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800fe8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ff0:	48 89 d6             	mov    %rdx,%rsi
  800ff3:	bf 30 00 00 00       	mov    $0x30,%edi
  800ff8:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ffa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ffe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801002:	48 89 d6             	mov    %rdx,%rsi
  801005:	bf 78 00 00 00       	mov    $0x78,%edi
  80100a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80100c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80100f:	83 f8 30             	cmp    $0x30,%eax
  801012:	73 17                	jae    80102b <vprintfmt+0x45a>
  801014:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801018:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80101b:	89 c0                	mov    %eax,%eax
  80101d:	48 01 d0             	add    %rdx,%rax
  801020:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801023:	83 c2 08             	add    $0x8,%edx
  801026:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801029:	eb 0f                	jmp    80103a <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80102b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80102f:	48 89 d0             	mov    %rdx,%rax
  801032:	48 83 c2 08          	add    $0x8,%rdx
  801036:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80103a:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80103d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801041:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801048:	eb 23                	jmp    80106d <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80104a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80104e:	be 03 00 00 00       	mov    $0x3,%esi
  801053:	48 89 c7             	mov    %rax,%rdi
  801056:	48 b8 b1 09 80 00 00 	movabs $0x8009b1,%rax
  80105d:	00 00 00 
  801060:	ff d0                	callq  *%rax
  801062:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801066:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80106d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801072:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801075:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801078:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80107c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801080:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801084:	45 89 c1             	mov    %r8d,%r9d
  801087:	41 89 f8             	mov    %edi,%r8d
  80108a:	48 89 c7             	mov    %rax,%rdi
  80108d:	48 b8 f6 08 80 00 00 	movabs $0x8008f6,%rax
  801094:	00 00 00 
  801097:	ff d0                	callq  *%rax
			break;
  801099:	eb 3f                	jmp    8010da <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80109b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80109f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010a3:	48 89 d6             	mov    %rdx,%rsi
  8010a6:	89 df                	mov    %ebx,%edi
  8010a8:	ff d0                	callq  *%rax
			break;
  8010aa:	eb 2e                	jmp    8010da <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010ac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010b0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010b4:	48 89 d6             	mov    %rdx,%rsi
  8010b7:	bf 25 00 00 00       	mov    $0x25,%edi
  8010bc:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010be:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010c3:	eb 05                	jmp    8010ca <vprintfmt+0x4f9>
  8010c5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010ca:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010ce:	48 83 e8 01          	sub    $0x1,%rax
  8010d2:	0f b6 00             	movzbl (%rax),%eax
  8010d5:	3c 25                	cmp    $0x25,%al
  8010d7:	75 ec                	jne    8010c5 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8010d9:	90                   	nop
		}
	}
  8010da:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010db:	e9 43 fb ff ff       	jmpq   800c23 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8010e0:	48 83 c4 60          	add    $0x60,%rsp
  8010e4:	5b                   	pop    %rbx
  8010e5:	41 5c                	pop    %r12
  8010e7:	5d                   	pop    %rbp
  8010e8:	c3                   	retq   

00000000008010e9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010e9:	55                   	push   %rbp
  8010ea:	48 89 e5             	mov    %rsp,%rbp
  8010ed:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010f4:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010fb:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801102:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801109:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801110:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801117:	84 c0                	test   %al,%al
  801119:	74 20                	je     80113b <printfmt+0x52>
  80111b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80111f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801123:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801127:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80112b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80112f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801133:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801137:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80113b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801142:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801149:	00 00 00 
  80114c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801153:	00 00 00 
  801156:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80115a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801161:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801168:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80116f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801176:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80117d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801184:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80118b:	48 89 c7             	mov    %rax,%rdi
  80118e:	48 b8 d1 0b 80 00 00 	movabs $0x800bd1,%rax
  801195:	00 00 00 
  801198:	ff d0                	callq  *%rax
	va_end(ap);
}
  80119a:	c9                   	leaveq 
  80119b:	c3                   	retq   

000000000080119c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80119c:	55                   	push   %rbp
  80119d:	48 89 e5             	mov    %rsp,%rbp
  8011a0:	48 83 ec 10          	sub    $0x10,%rsp
  8011a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011af:	8b 40 10             	mov    0x10(%rax),%eax
  8011b2:	8d 50 01             	lea    0x1(%rax),%edx
  8011b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c0:	48 8b 10             	mov    (%rax),%rdx
  8011c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011cb:	48 39 c2             	cmp    %rax,%rdx
  8011ce:	73 17                	jae    8011e7 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d4:	48 8b 00             	mov    (%rax),%rax
  8011d7:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011df:	48 89 0a             	mov    %rcx,(%rdx)
  8011e2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011e5:	88 10                	mov    %dl,(%rax)
}
  8011e7:	c9                   	leaveq 
  8011e8:	c3                   	retq   

00000000008011e9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011e9:	55                   	push   %rbp
  8011ea:	48 89 e5             	mov    %rsp,%rbp
  8011ed:	48 83 ec 50          	sub    $0x50,%rsp
  8011f1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011f5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011f8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011fc:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801200:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801204:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801208:	48 8b 0a             	mov    (%rdx),%rcx
  80120b:	48 89 08             	mov    %rcx,(%rax)
  80120e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801212:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801216:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80121a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80121e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801222:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801226:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801229:	48 98                	cltq   
  80122b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80122f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801233:	48 01 d0             	add    %rdx,%rax
  801236:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80123a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801241:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801246:	74 06                	je     80124e <vsnprintf+0x65>
  801248:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80124c:	7f 07                	jg     801255 <vsnprintf+0x6c>
		return -E_INVAL;
  80124e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801253:	eb 2f                	jmp    801284 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801255:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801259:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80125d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801261:	48 89 c6             	mov    %rax,%rsi
  801264:	48 bf 9c 11 80 00 00 	movabs $0x80119c,%rdi
  80126b:	00 00 00 
  80126e:	48 b8 d1 0b 80 00 00 	movabs $0x800bd1,%rax
  801275:	00 00 00 
  801278:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80127a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80127e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801281:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801284:	c9                   	leaveq 
  801285:	c3                   	retq   

0000000000801286 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801286:	55                   	push   %rbp
  801287:	48 89 e5             	mov    %rsp,%rbp
  80128a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801291:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801298:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80129e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012a5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012ac:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012b3:	84 c0                	test   %al,%al
  8012b5:	74 20                	je     8012d7 <snprintf+0x51>
  8012b7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012bb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012bf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012c3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012c7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012cb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012cf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012d3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012d7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012de:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012e5:	00 00 00 
  8012e8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012ef:	00 00 00 
  8012f2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012f6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012fd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801304:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80130b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801312:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801319:	48 8b 0a             	mov    (%rdx),%rcx
  80131c:	48 89 08             	mov    %rcx,(%rax)
  80131f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801323:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801327:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80132b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80132f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801336:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80133d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801343:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80134a:	48 89 c7             	mov    %rax,%rdi
  80134d:	48 b8 e9 11 80 00 00 	movabs $0x8011e9,%rax
  801354:	00 00 00 
  801357:	ff d0                	callq  *%rax
  801359:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80135f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801365:	c9                   	leaveq 
  801366:	c3                   	retq   

0000000000801367 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801367:	55                   	push   %rbp
  801368:	48 89 e5             	mov    %rsp,%rbp
  80136b:	48 83 ec 18          	sub    $0x18,%rsp
  80136f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801373:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80137a:	eb 09                	jmp    801385 <strlen+0x1e>
		n++;
  80137c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801380:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801389:	0f b6 00             	movzbl (%rax),%eax
  80138c:	84 c0                	test   %al,%al
  80138e:	75 ec                	jne    80137c <strlen+0x15>
		n++;
	return n;
  801390:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801393:	c9                   	leaveq 
  801394:	c3                   	retq   

0000000000801395 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801395:	55                   	push   %rbp
  801396:	48 89 e5             	mov    %rsp,%rbp
  801399:	48 83 ec 20          	sub    $0x20,%rsp
  80139d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013ac:	eb 0e                	jmp    8013bc <strnlen+0x27>
		n++;
  8013ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013b2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013b7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013bc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013c1:	74 0b                	je     8013ce <strnlen+0x39>
  8013c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c7:	0f b6 00             	movzbl (%rax),%eax
  8013ca:	84 c0                	test   %al,%al
  8013cc:	75 e0                	jne    8013ae <strnlen+0x19>
		n++;
	return n;
  8013ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013d1:	c9                   	leaveq 
  8013d2:	c3                   	retq   

00000000008013d3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013d3:	55                   	push   %rbp
  8013d4:	48 89 e5             	mov    %rsp,%rbp
  8013d7:	48 83 ec 20          	sub    $0x20,%rsp
  8013db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013eb:	90                   	nop
  8013ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013f8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013fc:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801400:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801404:	0f b6 12             	movzbl (%rdx),%edx
  801407:	88 10                	mov    %dl,(%rax)
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	84 c0                	test   %al,%al
  80140e:	75 dc                	jne    8013ec <strcpy+0x19>
		/* do nothing */;
	return ret;
  801410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801414:	c9                   	leaveq 
  801415:	c3                   	retq   

0000000000801416 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801416:	55                   	push   %rbp
  801417:	48 89 e5             	mov    %rsp,%rbp
  80141a:	48 83 ec 20          	sub    $0x20,%rsp
  80141e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801422:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142a:	48 89 c7             	mov    %rax,%rdi
  80142d:	48 b8 67 13 80 00 00 	movabs $0x801367,%rax
  801434:	00 00 00 
  801437:	ff d0                	callq  *%rax
  801439:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80143c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80143f:	48 63 d0             	movslq %eax,%rdx
  801442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801446:	48 01 c2             	add    %rax,%rdx
  801449:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80144d:	48 89 c6             	mov    %rax,%rsi
  801450:	48 89 d7             	mov    %rdx,%rdi
  801453:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  80145a:	00 00 00 
  80145d:	ff d0                	callq  *%rax
	return dst;
  80145f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801463:	c9                   	leaveq 
  801464:	c3                   	retq   

0000000000801465 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801465:	55                   	push   %rbp
  801466:	48 89 e5             	mov    %rsp,%rbp
  801469:	48 83 ec 28          	sub    $0x28,%rsp
  80146d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801471:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801475:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801481:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801488:	00 
  801489:	eb 2a                	jmp    8014b5 <strncpy+0x50>
		*dst++ = *src;
  80148b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801493:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801497:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80149b:	0f b6 12             	movzbl (%rdx),%edx
  80149e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a4:	0f b6 00             	movzbl (%rax),%eax
  8014a7:	84 c0                	test   %al,%al
  8014a9:	74 05                	je     8014b0 <strncpy+0x4b>
			src++;
  8014ab:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014bd:	72 cc                	jb     80148b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014c3:	c9                   	leaveq 
  8014c4:	c3                   	retq   

00000000008014c5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014c5:	55                   	push   %rbp
  8014c6:	48 89 e5             	mov    %rsp,%rbp
  8014c9:	48 83 ec 28          	sub    $0x28,%rsp
  8014cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014e1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014e6:	74 3d                	je     801525 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014e8:	eb 1d                	jmp    801507 <strlcpy+0x42>
			*dst++ = *src++;
  8014ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014f2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014f6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014fa:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014fe:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801502:	0f b6 12             	movzbl (%rdx),%edx
  801505:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801507:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80150c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801511:	74 0b                	je     80151e <strlcpy+0x59>
  801513:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801517:	0f b6 00             	movzbl (%rax),%eax
  80151a:	84 c0                	test   %al,%al
  80151c:	75 cc                	jne    8014ea <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80151e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801522:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801525:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152d:	48 29 c2             	sub    %rax,%rdx
  801530:	48 89 d0             	mov    %rdx,%rax
}
  801533:	c9                   	leaveq 
  801534:	c3                   	retq   

0000000000801535 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801535:	55                   	push   %rbp
  801536:	48 89 e5             	mov    %rsp,%rbp
  801539:	48 83 ec 10          	sub    $0x10,%rsp
  80153d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801541:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801545:	eb 0a                	jmp    801551 <strcmp+0x1c>
		p++, q++;
  801547:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80154c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801551:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801555:	0f b6 00             	movzbl (%rax),%eax
  801558:	84 c0                	test   %al,%al
  80155a:	74 12                	je     80156e <strcmp+0x39>
  80155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801560:	0f b6 10             	movzbl (%rax),%edx
  801563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	38 c2                	cmp    %al,%dl
  80156c:	74 d9                	je     801547 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80156e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801572:	0f b6 00             	movzbl (%rax),%eax
  801575:	0f b6 d0             	movzbl %al,%edx
  801578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157c:	0f b6 00             	movzbl (%rax),%eax
  80157f:	0f b6 c0             	movzbl %al,%eax
  801582:	29 c2                	sub    %eax,%edx
  801584:	89 d0                	mov    %edx,%eax
}
  801586:	c9                   	leaveq 
  801587:	c3                   	retq   

0000000000801588 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801588:	55                   	push   %rbp
  801589:	48 89 e5             	mov    %rsp,%rbp
  80158c:	48 83 ec 18          	sub    $0x18,%rsp
  801590:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801594:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801598:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80159c:	eb 0f                	jmp    8015ad <strncmp+0x25>
		n--, p++, q++;
  80159e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015b2:	74 1d                	je     8015d1 <strncmp+0x49>
  8015b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b8:	0f b6 00             	movzbl (%rax),%eax
  8015bb:	84 c0                	test   %al,%al
  8015bd:	74 12                	je     8015d1 <strncmp+0x49>
  8015bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c3:	0f b6 10             	movzbl (%rax),%edx
  8015c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	38 c2                	cmp    %al,%dl
  8015cf:	74 cd                	je     80159e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015d1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015d6:	75 07                	jne    8015df <strncmp+0x57>
		return 0;
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dd:	eb 18                	jmp    8015f7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e3:	0f b6 00             	movzbl (%rax),%eax
  8015e6:	0f b6 d0             	movzbl %al,%edx
  8015e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ed:	0f b6 00             	movzbl (%rax),%eax
  8015f0:	0f b6 c0             	movzbl %al,%eax
  8015f3:	29 c2                	sub    %eax,%edx
  8015f5:	89 d0                	mov    %edx,%eax
}
  8015f7:	c9                   	leaveq 
  8015f8:	c3                   	retq   

00000000008015f9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015f9:	55                   	push   %rbp
  8015fa:	48 89 e5             	mov    %rsp,%rbp
  8015fd:	48 83 ec 0c          	sub    $0xc,%rsp
  801601:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801605:	89 f0                	mov    %esi,%eax
  801607:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80160a:	eb 17                	jmp    801623 <strchr+0x2a>
		if (*s == c)
  80160c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801610:	0f b6 00             	movzbl (%rax),%eax
  801613:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801616:	75 06                	jne    80161e <strchr+0x25>
			return (char *) s;
  801618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161c:	eb 15                	jmp    801633 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80161e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801627:	0f b6 00             	movzbl (%rax),%eax
  80162a:	84 c0                	test   %al,%al
  80162c:	75 de                	jne    80160c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801633:	c9                   	leaveq 
  801634:	c3                   	retq   

0000000000801635 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801635:	55                   	push   %rbp
  801636:	48 89 e5             	mov    %rsp,%rbp
  801639:	48 83 ec 0c          	sub    $0xc,%rsp
  80163d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801641:	89 f0                	mov    %esi,%eax
  801643:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801646:	eb 13                	jmp    80165b <strfind+0x26>
		if (*s == c)
  801648:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801652:	75 02                	jne    801656 <strfind+0x21>
			break;
  801654:	eb 10                	jmp    801666 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801656:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80165b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165f:	0f b6 00             	movzbl (%rax),%eax
  801662:	84 c0                	test   %al,%al
  801664:	75 e2                	jne    801648 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801666:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80166a:	c9                   	leaveq 
  80166b:	c3                   	retq   

000000000080166c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80166c:	55                   	push   %rbp
  80166d:	48 89 e5             	mov    %rsp,%rbp
  801670:	48 83 ec 18          	sub    $0x18,%rsp
  801674:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801678:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80167b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80167f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801684:	75 06                	jne    80168c <memset+0x20>
		return v;
  801686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168a:	eb 69                	jmp    8016f5 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80168c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801690:	83 e0 03             	and    $0x3,%eax
  801693:	48 85 c0             	test   %rax,%rax
  801696:	75 48                	jne    8016e0 <memset+0x74>
  801698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169c:	83 e0 03             	and    $0x3,%eax
  80169f:	48 85 c0             	test   %rax,%rax
  8016a2:	75 3c                	jne    8016e0 <memset+0x74>
		c &= 0xFF;
  8016a4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016ae:	c1 e0 18             	shl    $0x18,%eax
  8016b1:	89 c2                	mov    %eax,%edx
  8016b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016b6:	c1 e0 10             	shl    $0x10,%eax
  8016b9:	09 c2                	or     %eax,%edx
  8016bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016be:	c1 e0 08             	shl    $0x8,%eax
  8016c1:	09 d0                	or     %edx,%eax
  8016c3:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8016c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ca:	48 c1 e8 02          	shr    $0x2,%rax
  8016ce:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016d8:	48 89 d7             	mov    %rdx,%rdi
  8016db:	fc                   	cld    
  8016dc:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016de:	eb 11                	jmp    8016f1 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016e7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016eb:	48 89 d7             	mov    %rdx,%rdi
  8016ee:	fc                   	cld    
  8016ef:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8016f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016f5:	c9                   	leaveq 
  8016f6:	c3                   	retq   

00000000008016f7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016f7:	55                   	push   %rbp
  8016f8:	48 89 e5             	mov    %rsp,%rbp
  8016fb:	48 83 ec 28          	sub    $0x28,%rsp
  8016ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801703:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801707:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80170b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80170f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801717:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80171b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801723:	0f 83 88 00 00 00    	jae    8017b1 <memmove+0xba>
  801729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801731:	48 01 d0             	add    %rdx,%rax
  801734:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801738:	76 77                	jbe    8017b1 <memmove+0xba>
		s += n;
  80173a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80174a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80174e:	83 e0 03             	and    $0x3,%eax
  801751:	48 85 c0             	test   %rax,%rax
  801754:	75 3b                	jne    801791 <memmove+0x9a>
  801756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80175a:	83 e0 03             	and    $0x3,%eax
  80175d:	48 85 c0             	test   %rax,%rax
  801760:	75 2f                	jne    801791 <memmove+0x9a>
  801762:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801766:	83 e0 03             	and    $0x3,%eax
  801769:	48 85 c0             	test   %rax,%rax
  80176c:	75 23                	jne    801791 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80176e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801772:	48 83 e8 04          	sub    $0x4,%rax
  801776:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80177a:	48 83 ea 04          	sub    $0x4,%rdx
  80177e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801782:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801786:	48 89 c7             	mov    %rax,%rdi
  801789:	48 89 d6             	mov    %rdx,%rsi
  80178c:	fd                   	std    
  80178d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80178f:	eb 1d                	jmp    8017ae <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801791:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801795:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801799:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179d:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a5:	48 89 d7             	mov    %rdx,%rdi
  8017a8:	48 89 c1             	mov    %rax,%rcx
  8017ab:	fd                   	std    
  8017ac:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017ae:	fc                   	cld    
  8017af:	eb 57                	jmp    801808 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b5:	83 e0 03             	and    $0x3,%eax
  8017b8:	48 85 c0             	test   %rax,%rax
  8017bb:	75 36                	jne    8017f3 <memmove+0xfc>
  8017bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c1:	83 e0 03             	and    $0x3,%eax
  8017c4:	48 85 c0             	test   %rax,%rax
  8017c7:	75 2a                	jne    8017f3 <memmove+0xfc>
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	83 e0 03             	and    $0x3,%eax
  8017d0:	48 85 c0             	test   %rax,%rax
  8017d3:	75 1e                	jne    8017f3 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d9:	48 c1 e8 02          	shr    $0x2,%rax
  8017dd:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017e8:	48 89 c7             	mov    %rax,%rdi
  8017eb:	48 89 d6             	mov    %rdx,%rsi
  8017ee:	fc                   	cld    
  8017ef:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017f1:	eb 15                	jmp    801808 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017fb:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017ff:	48 89 c7             	mov    %rax,%rdi
  801802:	48 89 d6             	mov    %rdx,%rsi
  801805:	fc                   	cld    
  801806:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80180c:	c9                   	leaveq 
  80180d:	c3                   	retq   

000000000080180e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80180e:	55                   	push   %rbp
  80180f:	48 89 e5             	mov    %rsp,%rbp
  801812:	48 83 ec 18          	sub    $0x18,%rsp
  801816:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80181a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80181e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801822:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801826:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80182a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182e:	48 89 ce             	mov    %rcx,%rsi
  801831:	48 89 c7             	mov    %rax,%rdi
  801834:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  80183b:	00 00 00 
  80183e:	ff d0                	callq  *%rax
}
  801840:	c9                   	leaveq 
  801841:	c3                   	retq   

0000000000801842 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801842:	55                   	push   %rbp
  801843:	48 89 e5             	mov    %rsp,%rbp
  801846:	48 83 ec 28          	sub    $0x28,%rsp
  80184a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80184e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801852:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80185a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80185e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801862:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801866:	eb 36                	jmp    80189e <memcmp+0x5c>
		if (*s1 != *s2)
  801868:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80186c:	0f b6 10             	movzbl (%rax),%edx
  80186f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801873:	0f b6 00             	movzbl (%rax),%eax
  801876:	38 c2                	cmp    %al,%dl
  801878:	74 1a                	je     801894 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80187a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187e:	0f b6 00             	movzbl (%rax),%eax
  801881:	0f b6 d0             	movzbl %al,%edx
  801884:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801888:	0f b6 00             	movzbl (%rax),%eax
  80188b:	0f b6 c0             	movzbl %al,%eax
  80188e:	29 c2                	sub    %eax,%edx
  801890:	89 d0                	mov    %edx,%eax
  801892:	eb 20                	jmp    8018b4 <memcmp+0x72>
		s1++, s2++;
  801894:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801899:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80189e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018aa:	48 85 c0             	test   %rax,%rax
  8018ad:	75 b9                	jne    801868 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b4:	c9                   	leaveq 
  8018b5:	c3                   	retq   

00000000008018b6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018b6:	55                   	push   %rbp
  8018b7:	48 89 e5             	mov    %rsp,%rbp
  8018ba:	48 83 ec 28          	sub    $0x28,%rsp
  8018be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018c2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018d1:	48 01 d0             	add    %rdx,%rax
  8018d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018d8:	eb 15                	jmp    8018ef <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018de:	0f b6 10             	movzbl (%rax),%edx
  8018e1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018e4:	38 c2                	cmp    %al,%dl
  8018e6:	75 02                	jne    8018ea <memfind+0x34>
			break;
  8018e8:	eb 0f                	jmp    8018f9 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018ea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018f3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018f7:	72 e1                	jb     8018da <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8018f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018fd:	c9                   	leaveq 
  8018fe:	c3                   	retq   

00000000008018ff <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018ff:	55                   	push   %rbp
  801900:	48 89 e5             	mov    %rsp,%rbp
  801903:	48 83 ec 34          	sub    $0x34,%rsp
  801907:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80190b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80190f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801912:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801919:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801920:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801921:	eb 05                	jmp    801928 <strtol+0x29>
		s++;
  801923:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801928:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192c:	0f b6 00             	movzbl (%rax),%eax
  80192f:	3c 20                	cmp    $0x20,%al
  801931:	74 f0                	je     801923 <strtol+0x24>
  801933:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801937:	0f b6 00             	movzbl (%rax),%eax
  80193a:	3c 09                	cmp    $0x9,%al
  80193c:	74 e5                	je     801923 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80193e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801942:	0f b6 00             	movzbl (%rax),%eax
  801945:	3c 2b                	cmp    $0x2b,%al
  801947:	75 07                	jne    801950 <strtol+0x51>
		s++;
  801949:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80194e:	eb 17                	jmp    801967 <strtol+0x68>
	else if (*s == '-')
  801950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801954:	0f b6 00             	movzbl (%rax),%eax
  801957:	3c 2d                	cmp    $0x2d,%al
  801959:	75 0c                	jne    801967 <strtol+0x68>
		s++, neg = 1;
  80195b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801960:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801967:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80196b:	74 06                	je     801973 <strtol+0x74>
  80196d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801971:	75 28                	jne    80199b <strtol+0x9c>
  801973:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801977:	0f b6 00             	movzbl (%rax),%eax
  80197a:	3c 30                	cmp    $0x30,%al
  80197c:	75 1d                	jne    80199b <strtol+0x9c>
  80197e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801982:	48 83 c0 01          	add    $0x1,%rax
  801986:	0f b6 00             	movzbl (%rax),%eax
  801989:	3c 78                	cmp    $0x78,%al
  80198b:	75 0e                	jne    80199b <strtol+0x9c>
		s += 2, base = 16;
  80198d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801992:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801999:	eb 2c                	jmp    8019c7 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80199b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80199f:	75 19                	jne    8019ba <strtol+0xbb>
  8019a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a5:	0f b6 00             	movzbl (%rax),%eax
  8019a8:	3c 30                	cmp    $0x30,%al
  8019aa:	75 0e                	jne    8019ba <strtol+0xbb>
		s++, base = 8;
  8019ac:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019b1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019b8:	eb 0d                	jmp    8019c7 <strtol+0xc8>
	else if (base == 0)
  8019ba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019be:	75 07                	jne    8019c7 <strtol+0xc8>
		base = 10;
  8019c0:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cb:	0f b6 00             	movzbl (%rax),%eax
  8019ce:	3c 2f                	cmp    $0x2f,%al
  8019d0:	7e 1d                	jle    8019ef <strtol+0xf0>
  8019d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d6:	0f b6 00             	movzbl (%rax),%eax
  8019d9:	3c 39                	cmp    $0x39,%al
  8019db:	7f 12                	jg     8019ef <strtol+0xf0>
			dig = *s - '0';
  8019dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e1:	0f b6 00             	movzbl (%rax),%eax
  8019e4:	0f be c0             	movsbl %al,%eax
  8019e7:	83 e8 30             	sub    $0x30,%eax
  8019ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019ed:	eb 4e                	jmp    801a3d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f3:	0f b6 00             	movzbl (%rax),%eax
  8019f6:	3c 60                	cmp    $0x60,%al
  8019f8:	7e 1d                	jle    801a17 <strtol+0x118>
  8019fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fe:	0f b6 00             	movzbl (%rax),%eax
  801a01:	3c 7a                	cmp    $0x7a,%al
  801a03:	7f 12                	jg     801a17 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a09:	0f b6 00             	movzbl (%rax),%eax
  801a0c:	0f be c0             	movsbl %al,%eax
  801a0f:	83 e8 57             	sub    $0x57,%eax
  801a12:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a15:	eb 26                	jmp    801a3d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1b:	0f b6 00             	movzbl (%rax),%eax
  801a1e:	3c 40                	cmp    $0x40,%al
  801a20:	7e 48                	jle    801a6a <strtol+0x16b>
  801a22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a26:	0f b6 00             	movzbl (%rax),%eax
  801a29:	3c 5a                	cmp    $0x5a,%al
  801a2b:	7f 3d                	jg     801a6a <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a31:	0f b6 00             	movzbl (%rax),%eax
  801a34:	0f be c0             	movsbl %al,%eax
  801a37:	83 e8 37             	sub    $0x37,%eax
  801a3a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a40:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a43:	7c 02                	jl     801a47 <strtol+0x148>
			break;
  801a45:	eb 23                	jmp    801a6a <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a47:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a4c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a4f:	48 98                	cltq   
  801a51:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a56:	48 89 c2             	mov    %rax,%rdx
  801a59:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a5c:	48 98                	cltq   
  801a5e:	48 01 d0             	add    %rdx,%rax
  801a61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a65:	e9 5d ff ff ff       	jmpq   8019c7 <strtol+0xc8>

	if (endptr)
  801a6a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a6f:	74 0b                	je     801a7c <strtol+0x17d>
		*endptr = (char *) s;
  801a71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a75:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a79:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a80:	74 09                	je     801a8b <strtol+0x18c>
  801a82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a86:	48 f7 d8             	neg    %rax
  801a89:	eb 04                	jmp    801a8f <strtol+0x190>
  801a8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a8f:	c9                   	leaveq 
  801a90:	c3                   	retq   

0000000000801a91 <strstr>:

char * strstr(const char *in, const char *str)
{
  801a91:	55                   	push   %rbp
  801a92:	48 89 e5             	mov    %rsp,%rbp
  801a95:	48 83 ec 30          	sub    $0x30,%rsp
  801a99:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a9d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801aa1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aa5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801aa9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801aad:	0f b6 00             	movzbl (%rax),%eax
  801ab0:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801ab3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ab7:	75 06                	jne    801abf <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801ab9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abd:	eb 6b                	jmp    801b2a <strstr+0x99>

	len = strlen(str);
  801abf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ac3:	48 89 c7             	mov    %rax,%rdi
  801ac6:	48 b8 67 13 80 00 00 	movabs $0x801367,%rax
  801acd:	00 00 00 
  801ad0:	ff d0                	callq  *%rax
  801ad2:	48 98                	cltq   
  801ad4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801ad8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801adc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ae0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ae4:	0f b6 00             	movzbl (%rax),%eax
  801ae7:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801aea:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801aee:	75 07                	jne    801af7 <strstr+0x66>
				return (char *) 0;
  801af0:	b8 00 00 00 00       	mov    $0x0,%eax
  801af5:	eb 33                	jmp    801b2a <strstr+0x99>
		} while (sc != c);
  801af7:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801afb:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801afe:	75 d8                	jne    801ad8 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b04:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0c:	48 89 ce             	mov    %rcx,%rsi
  801b0f:	48 89 c7             	mov    %rax,%rdi
  801b12:	48 b8 88 15 80 00 00 	movabs $0x801588,%rax
  801b19:	00 00 00 
  801b1c:	ff d0                	callq  *%rax
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	75 b6                	jne    801ad8 <strstr+0x47>

	return (char *) (in - 1);
  801b22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b26:	48 83 e8 01          	sub    $0x1,%rax
}
  801b2a:	c9                   	leaveq 
  801b2b:	c3                   	retq   

0000000000801b2c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b2c:	55                   	push   %rbp
  801b2d:	48 89 e5             	mov    %rsp,%rbp
  801b30:	53                   	push   %rbx
  801b31:	48 83 ec 48          	sub    $0x48,%rsp
  801b35:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b38:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b3b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b3f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b43:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b47:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b4b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b4e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b52:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b56:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b5a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b5e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b62:	4c 89 c3             	mov    %r8,%rbx
  801b65:	cd 30                	int    $0x30
  801b67:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b6b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b6f:	74 3e                	je     801baf <syscall+0x83>
  801b71:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b76:	7e 37                	jle    801baf <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b7c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b7f:	49 89 d0             	mov    %rdx,%r8
  801b82:	89 c1                	mov    %eax,%ecx
  801b84:	48 ba e8 4a 80 00 00 	movabs $0x804ae8,%rdx
  801b8b:	00 00 00 
  801b8e:	be 23 00 00 00       	mov    $0x23,%esi
  801b93:	48 bf 05 4b 80 00 00 	movabs $0x804b05,%rdi
  801b9a:	00 00 00 
  801b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba2:	49 b9 e5 05 80 00 00 	movabs $0x8005e5,%r9
  801ba9:	00 00 00 
  801bac:	41 ff d1             	callq  *%r9

	return ret;
  801baf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bb3:	48 83 c4 48          	add    $0x48,%rsp
  801bb7:	5b                   	pop    %rbx
  801bb8:	5d                   	pop    %rbp
  801bb9:	c3                   	retq   

0000000000801bba <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bba:	55                   	push   %rbp
  801bbb:	48 89 e5             	mov    %rsp,%rbp
  801bbe:	48 83 ec 20          	sub    $0x20,%rsp
  801bc2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801bca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd9:	00 
  801bda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be6:	48 89 d1             	mov    %rdx,%rcx
  801be9:	48 89 c2             	mov    %rax,%rdx
  801bec:	be 00 00 00 00       	mov    $0x0,%esi
  801bf1:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf6:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801bfd:	00 00 00 
  801c00:	ff d0                	callq  *%rax
}
  801c02:	c9                   	leaveq 
  801c03:	c3                   	retq   

0000000000801c04 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c04:	55                   	push   %rbp
  801c05:	48 89 e5             	mov    %rsp,%rbp
  801c08:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c13:	00 
  801c14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c20:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c25:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2a:	be 00 00 00 00       	mov    $0x0,%esi
  801c2f:	bf 01 00 00 00       	mov    $0x1,%edi
  801c34:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801c3b:	00 00 00 
  801c3e:	ff d0                	callq  *%rax
}
  801c40:	c9                   	leaveq 
  801c41:	c3                   	retq   

0000000000801c42 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c42:	55                   	push   %rbp
  801c43:	48 89 e5             	mov    %rsp,%rbp
  801c46:	48 83 ec 10          	sub    $0x10,%rsp
  801c4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c50:	48 98                	cltq   
  801c52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c59:	00 
  801c5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c6b:	48 89 c2             	mov    %rax,%rdx
  801c6e:	be 01 00 00 00       	mov    $0x1,%esi
  801c73:	bf 03 00 00 00       	mov    $0x3,%edi
  801c78:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801c7f:	00 00 00 
  801c82:	ff d0                	callq  *%rax
}
  801c84:	c9                   	leaveq 
  801c85:	c3                   	retq   

0000000000801c86 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c86:	55                   	push   %rbp
  801c87:	48 89 e5             	mov    %rsp,%rbp
  801c8a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c95:	00 
  801c96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cac:	be 00 00 00 00       	mov    $0x0,%esi
  801cb1:	bf 02 00 00 00       	mov    $0x2,%edi
  801cb6:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801cbd:	00 00 00 
  801cc0:	ff d0                	callq  *%rax
}
  801cc2:	c9                   	leaveq 
  801cc3:	c3                   	retq   

0000000000801cc4 <sys_yield>:

void
sys_yield(void)
{
  801cc4:	55                   	push   %rbp
  801cc5:	48 89 e5             	mov    %rsp,%rbp
  801cc8:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ccc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd3:	00 
  801cd4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cda:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ce5:	ba 00 00 00 00       	mov    $0x0,%edx
  801cea:	be 00 00 00 00       	mov    $0x0,%esi
  801cef:	bf 0b 00 00 00       	mov    $0xb,%edi
  801cf4:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801cfb:	00 00 00 
  801cfe:	ff d0                	callq  *%rax
}
  801d00:	c9                   	leaveq 
  801d01:	c3                   	retq   

0000000000801d02 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d02:	55                   	push   %rbp
  801d03:	48 89 e5             	mov    %rsp,%rbp
  801d06:	48 83 ec 20          	sub    $0x20,%rsp
  801d0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d11:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d17:	48 63 c8             	movslq %eax,%rcx
  801d1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d21:	48 98                	cltq   
  801d23:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2a:	00 
  801d2b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d31:	49 89 c8             	mov    %rcx,%r8
  801d34:	48 89 d1             	mov    %rdx,%rcx
  801d37:	48 89 c2             	mov    %rax,%rdx
  801d3a:	be 01 00 00 00       	mov    $0x1,%esi
  801d3f:	bf 04 00 00 00       	mov    $0x4,%edi
  801d44:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801d4b:	00 00 00 
  801d4e:	ff d0                	callq  *%rax
}
  801d50:	c9                   	leaveq 
  801d51:	c3                   	retq   

0000000000801d52 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d52:	55                   	push   %rbp
  801d53:	48 89 e5             	mov    %rsp,%rbp
  801d56:	48 83 ec 30          	sub    $0x30,%rsp
  801d5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d61:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d64:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d68:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d6c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d6f:	48 63 c8             	movslq %eax,%rcx
  801d72:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d79:	48 63 f0             	movslq %eax,%rsi
  801d7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d83:	48 98                	cltq   
  801d85:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d89:	49 89 f9             	mov    %rdi,%r9
  801d8c:	49 89 f0             	mov    %rsi,%r8
  801d8f:	48 89 d1             	mov    %rdx,%rcx
  801d92:	48 89 c2             	mov    %rax,%rdx
  801d95:	be 01 00 00 00       	mov    $0x1,%esi
  801d9a:	bf 05 00 00 00       	mov    $0x5,%edi
  801d9f:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801da6:	00 00 00 
  801da9:	ff d0                	callq  *%rax
}
  801dab:	c9                   	leaveq 
  801dac:	c3                   	retq   

0000000000801dad <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dad:	55                   	push   %rbp
  801dae:	48 89 e5             	mov    %rsp,%rbp
  801db1:	48 83 ec 20          	sub    $0x20,%rsp
  801db5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801dbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc3:	48 98                	cltq   
  801dc5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dcc:	00 
  801dcd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd9:	48 89 d1             	mov    %rdx,%rcx
  801ddc:	48 89 c2             	mov    %rax,%rdx
  801ddf:	be 01 00 00 00       	mov    $0x1,%esi
  801de4:	bf 06 00 00 00       	mov    $0x6,%edi
  801de9:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801df0:	00 00 00 
  801df3:	ff d0                	callq  *%rax
}
  801df5:	c9                   	leaveq 
  801df6:	c3                   	retq   

0000000000801df7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801df7:	55                   	push   %rbp
  801df8:	48 89 e5             	mov    %rsp,%rbp
  801dfb:	48 83 ec 10          	sub    $0x10,%rsp
  801dff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e02:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e08:	48 63 d0             	movslq %eax,%rdx
  801e0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e0e:	48 98                	cltq   
  801e10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e17:	00 
  801e18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e24:	48 89 d1             	mov    %rdx,%rcx
  801e27:	48 89 c2             	mov    %rax,%rdx
  801e2a:	be 01 00 00 00       	mov    $0x1,%esi
  801e2f:	bf 08 00 00 00       	mov    $0x8,%edi
  801e34:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
}
  801e40:	c9                   	leaveq 
  801e41:	c3                   	retq   

0000000000801e42 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e42:	55                   	push   %rbp
  801e43:	48 89 e5             	mov    %rsp,%rbp
  801e46:	48 83 ec 20          	sub    $0x20,%rsp
  801e4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e58:	48 98                	cltq   
  801e5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e61:	00 
  801e62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6e:	48 89 d1             	mov    %rdx,%rcx
  801e71:	48 89 c2             	mov    %rax,%rdx
  801e74:	be 01 00 00 00       	mov    $0x1,%esi
  801e79:	bf 09 00 00 00       	mov    $0x9,%edi
  801e7e:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801e85:	00 00 00 
  801e88:	ff d0                	callq  *%rax
}
  801e8a:	c9                   	leaveq 
  801e8b:	c3                   	retq   

0000000000801e8c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e8c:	55                   	push   %rbp
  801e8d:	48 89 e5             	mov    %rsp,%rbp
  801e90:	48 83 ec 20          	sub    $0x20,%rsp
  801e94:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e97:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e9b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea2:	48 98                	cltq   
  801ea4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eab:	00 
  801eac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb8:	48 89 d1             	mov    %rdx,%rcx
  801ebb:	48 89 c2             	mov    %rax,%rdx
  801ebe:	be 01 00 00 00       	mov    $0x1,%esi
  801ec3:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ec8:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801ecf:	00 00 00 
  801ed2:	ff d0                	callq  *%rax
}
  801ed4:	c9                   	leaveq 
  801ed5:	c3                   	retq   

0000000000801ed6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ed6:	55                   	push   %rbp
  801ed7:	48 89 e5             	mov    %rsp,%rbp
  801eda:	48 83 ec 20          	sub    $0x20,%rsp
  801ede:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ee1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ee5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ee9:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801eec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eef:	48 63 f0             	movslq %eax,%rsi
  801ef2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef9:	48 98                	cltq   
  801efb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f06:	00 
  801f07:	49 89 f1             	mov    %rsi,%r9
  801f0a:	49 89 c8             	mov    %rcx,%r8
  801f0d:	48 89 d1             	mov    %rdx,%rcx
  801f10:	48 89 c2             	mov    %rax,%rdx
  801f13:	be 00 00 00 00       	mov    $0x0,%esi
  801f18:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f1d:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801f24:	00 00 00 
  801f27:	ff d0                	callq  *%rax
}
  801f29:	c9                   	leaveq 
  801f2a:	c3                   	retq   

0000000000801f2b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f2b:	55                   	push   %rbp
  801f2c:	48 89 e5             	mov    %rsp,%rbp
  801f2f:	48 83 ec 10          	sub    $0x10,%rsp
  801f33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f42:	00 
  801f43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f54:	48 89 c2             	mov    %rax,%rdx
  801f57:	be 01 00 00 00       	mov    $0x1,%esi
  801f5c:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f61:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801f68:	00 00 00 
  801f6b:	ff d0                	callq  *%rax
}
  801f6d:	c9                   	leaveq 
  801f6e:	c3                   	retq   

0000000000801f6f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801f6f:	55                   	push   %rbp
  801f70:	48 89 e5             	mov    %rsp,%rbp
  801f73:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801f77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f7e:	00 
  801f7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f90:	ba 00 00 00 00       	mov    $0x0,%edx
  801f95:	be 00 00 00 00       	mov    $0x0,%esi
  801f9a:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f9f:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801fa6:	00 00 00 
  801fa9:	ff d0                	callq  *%rax
}
  801fab:	c9                   	leaveq 
  801fac:	c3                   	retq   

0000000000801fad <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801fad:	55                   	push   %rbp
  801fae:	48 89 e5             	mov    %rsp,%rbp
  801fb1:	48 83 ec 30          	sub    $0x30,%rsp
  801fb5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fb8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fbc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801fbf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801fc3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801fc7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801fca:	48 63 c8             	movslq %eax,%rcx
  801fcd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801fd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fd4:	48 63 f0             	movslq %eax,%rsi
  801fd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fde:	48 98                	cltq   
  801fe0:	48 89 0c 24          	mov    %rcx,(%rsp)
  801fe4:	49 89 f9             	mov    %rdi,%r9
  801fe7:	49 89 f0             	mov    %rsi,%r8
  801fea:	48 89 d1             	mov    %rdx,%rcx
  801fed:	48 89 c2             	mov    %rax,%rdx
  801ff0:	be 00 00 00 00       	mov    $0x0,%esi
  801ff5:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ffa:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  802001:	00 00 00 
  802004:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802006:	c9                   	leaveq 
  802007:	c3                   	retq   

0000000000802008 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802008:	55                   	push   %rbp
  802009:	48 89 e5             	mov    %rsp,%rbp
  80200c:	48 83 ec 20          	sub    $0x20,%rsp
  802010:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802014:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802018:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80201c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802020:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802027:	00 
  802028:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80202e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802034:	48 89 d1             	mov    %rdx,%rcx
  802037:	48 89 c2             	mov    %rax,%rdx
  80203a:	be 00 00 00 00       	mov    $0x0,%esi
  80203f:	bf 10 00 00 00       	mov    $0x10,%edi
  802044:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  80204b:	00 00 00 
  80204e:	ff d0                	callq  *%rax
}
  802050:	c9                   	leaveq 
  802051:	c3                   	retq   

0000000000802052 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  802052:	55                   	push   %rbp
  802053:	48 89 e5             	mov    %rsp,%rbp
  802056:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  80205a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802061:	00 
  802062:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802068:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80206e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802073:	ba 00 00 00 00       	mov    $0x0,%edx
  802078:	be 00 00 00 00       	mov    $0x0,%esi
  80207d:	bf 11 00 00 00       	mov    $0x11,%edi
  802082:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  802089:	00 00 00 
  80208c:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  80208e:	c9                   	leaveq 
  80208f:	c3                   	retq   

0000000000802090 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  802090:	55                   	push   %rbp
  802091:	48 89 e5             	mov    %rsp,%rbp
  802094:	48 83 ec 10          	sub    $0x10,%rsp
  802098:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  80209b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209e:	48 98                	cltq   
  8020a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020a7:	00 
  8020a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020b9:	48 89 c2             	mov    %rax,%rdx
  8020bc:	be 00 00 00 00       	mov    $0x0,%esi
  8020c1:	bf 12 00 00 00       	mov    $0x12,%edi
  8020c6:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  8020cd:	00 00 00 
  8020d0:	ff d0                	callq  *%rax
}
  8020d2:	c9                   	leaveq 
  8020d3:	c3                   	retq   

00000000008020d4 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  8020d4:	55                   	push   %rbp
  8020d5:	48 89 e5             	mov    %rsp,%rbp
  8020d8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  8020dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020e3:	00 
  8020e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8020fa:	be 00 00 00 00       	mov    $0x0,%esi
  8020ff:	bf 13 00 00 00       	mov    $0x13,%edi
  802104:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  80210b:	00 00 00 
  80210e:	ff d0                	callq  *%rax
}
  802110:	c9                   	leaveq 
  802111:	c3                   	retq   

0000000000802112 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  802112:	55                   	push   %rbp
  802113:	48 89 e5             	mov    %rsp,%rbp
  802116:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80211a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802121:	00 
  802122:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802128:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80212e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802133:	ba 00 00 00 00       	mov    $0x0,%edx
  802138:	be 00 00 00 00       	mov    $0x0,%esi
  80213d:	bf 14 00 00 00       	mov    $0x14,%edi
  802142:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  802149:	00 00 00 
  80214c:	ff d0                	callq  *%rax
}
  80214e:	c9                   	leaveq 
  80214f:	c3                   	retq   

0000000000802150 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802150:	55                   	push   %rbp
  802151:	48 89 e5             	mov    %rsp,%rbp
  802154:	48 83 ec 30          	sub    $0x30,%rsp
  802158:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  80215c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802160:	48 8b 00             	mov    (%rax),%rax
  802163:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802167:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80216b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80216f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  802172:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802175:	83 e0 02             	and    $0x2,%eax
  802178:	85 c0                	test   %eax,%eax
  80217a:	75 4d                	jne    8021c9 <pgfault+0x79>
  80217c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802180:	48 c1 e8 0c          	shr    $0xc,%rax
  802184:	48 89 c2             	mov    %rax,%rdx
  802187:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80218e:	01 00 00 
  802191:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802195:	25 00 08 00 00       	and    $0x800,%eax
  80219a:	48 85 c0             	test   %rax,%rax
  80219d:	74 2a                	je     8021c9 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  80219f:	48 ba 18 4b 80 00 00 	movabs $0x804b18,%rdx
  8021a6:	00 00 00 
  8021a9:	be 23 00 00 00       	mov    $0x23,%esi
  8021ae:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  8021b5:	00 00 00 
  8021b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bd:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8021c4:	00 00 00 
  8021c7:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  8021c9:	ba 07 00 00 00       	mov    $0x7,%edx
  8021ce:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d8:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  8021df:	00 00 00 
  8021e2:	ff d0                	callq  *%rax
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	0f 85 cd 00 00 00    	jne    8022b9 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  8021ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8021f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8021fe:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802202:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802206:	ba 00 10 00 00       	mov    $0x1000,%edx
  80220b:	48 89 c6             	mov    %rax,%rsi
  80220e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802213:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  80221a:	00 00 00 
  80221d:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  80221f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802223:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802229:	48 89 c1             	mov    %rax,%rcx
  80222c:	ba 00 00 00 00       	mov    $0x0,%edx
  802231:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802236:	bf 00 00 00 00       	mov    $0x0,%edi
  80223b:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  802242:	00 00 00 
  802245:	ff d0                	callq  *%rax
  802247:	85 c0                	test   %eax,%eax
  802249:	79 2a                	jns    802275 <pgfault+0x125>
				panic("Page map at temp address failed");
  80224b:	48 ba 58 4b 80 00 00 	movabs $0x804b58,%rdx
  802252:	00 00 00 
  802255:	be 30 00 00 00       	mov    $0x30,%esi
  80225a:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  802261:	00 00 00 
  802264:	b8 00 00 00 00       	mov    $0x0,%eax
  802269:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  802270:	00 00 00 
  802273:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802275:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80227a:	bf 00 00 00 00       	mov    $0x0,%edi
  80227f:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802286:	00 00 00 
  802289:	ff d0                	callq  *%rax
  80228b:	85 c0                	test   %eax,%eax
  80228d:	79 54                	jns    8022e3 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  80228f:	48 ba 78 4b 80 00 00 	movabs $0x804b78,%rdx
  802296:	00 00 00 
  802299:	be 32 00 00 00       	mov    $0x32,%esi
  80229e:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  8022a5:	00 00 00 
  8022a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ad:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8022b4:	00 00 00 
  8022b7:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  8022b9:	48 ba a0 4b 80 00 00 	movabs $0x804ba0,%rdx
  8022c0:	00 00 00 
  8022c3:	be 34 00 00 00       	mov    $0x34,%esi
  8022c8:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  8022cf:	00 00 00 
  8022d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d7:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8022de:	00 00 00 
  8022e1:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8022e3:	c9                   	leaveq 
  8022e4:	c3                   	retq   

00000000008022e5 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8022e5:	55                   	push   %rbp
  8022e6:	48 89 e5             	mov    %rsp,%rbp
  8022e9:	48 83 ec 20          	sub    $0x20,%rsp
  8022ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022f0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8022f3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022fa:	01 00 00 
  8022fd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802300:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802304:	25 07 0e 00 00       	and    $0xe07,%eax
  802309:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  80230c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80230f:	48 c1 e0 0c          	shl    $0xc,%rax
  802313:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802317:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231a:	25 00 04 00 00       	and    $0x400,%eax
  80231f:	85 c0                	test   %eax,%eax
  802321:	74 57                	je     80237a <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802323:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802326:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80232a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80232d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802331:	41 89 f0             	mov    %esi,%r8d
  802334:	48 89 c6             	mov    %rax,%rsi
  802337:	bf 00 00 00 00       	mov    $0x0,%edi
  80233c:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  802343:	00 00 00 
  802346:	ff d0                	callq  *%rax
  802348:	85 c0                	test   %eax,%eax
  80234a:	0f 8e 52 01 00 00    	jle    8024a2 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802350:	48 ba d2 4b 80 00 00 	movabs $0x804bd2,%rdx
  802357:	00 00 00 
  80235a:	be 4e 00 00 00       	mov    $0x4e,%esi
  80235f:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  802366:	00 00 00 
  802369:	b8 00 00 00 00       	mov    $0x0,%eax
  80236e:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  802375:	00 00 00 
  802378:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  80237a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237d:	83 e0 02             	and    $0x2,%eax
  802380:	85 c0                	test   %eax,%eax
  802382:	75 10                	jne    802394 <duppage+0xaf>
  802384:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802387:	25 00 08 00 00       	and    $0x800,%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	0f 84 bb 00 00 00    	je     80244f <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802397:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  80239c:	80 cc 08             	or     $0x8,%ah
  80239f:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8023a2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8023a5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8023a9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b0:	41 89 f0             	mov    %esi,%r8d
  8023b3:	48 89 c6             	mov    %rax,%rsi
  8023b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023bb:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  8023c2:	00 00 00 
  8023c5:	ff d0                	callq  *%rax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	7e 2a                	jle    8023f5 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8023cb:	48 ba d2 4b 80 00 00 	movabs $0x804bd2,%rdx
  8023d2:	00 00 00 
  8023d5:	be 55 00 00 00       	mov    $0x55,%esi
  8023da:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  8023e1:	00 00 00 
  8023e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e9:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8023f0:	00 00 00 
  8023f3:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8023f5:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8023f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802400:	41 89 c8             	mov    %ecx,%r8d
  802403:	48 89 d1             	mov    %rdx,%rcx
  802406:	ba 00 00 00 00       	mov    $0x0,%edx
  80240b:	48 89 c6             	mov    %rax,%rsi
  80240e:	bf 00 00 00 00       	mov    $0x0,%edi
  802413:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  80241a:	00 00 00 
  80241d:	ff d0                	callq  *%rax
  80241f:	85 c0                	test   %eax,%eax
  802421:	7e 2a                	jle    80244d <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802423:	48 ba d2 4b 80 00 00 	movabs $0x804bd2,%rdx
  80242a:	00 00 00 
  80242d:	be 57 00 00 00       	mov    $0x57,%esi
  802432:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  802439:	00 00 00 
  80243c:	b8 00 00 00 00       	mov    $0x0,%eax
  802441:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  802448:	00 00 00 
  80244b:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80244d:	eb 53                	jmp    8024a2 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80244f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802452:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802456:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802459:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245d:	41 89 f0             	mov    %esi,%r8d
  802460:	48 89 c6             	mov    %rax,%rsi
  802463:	bf 00 00 00 00       	mov    $0x0,%edi
  802468:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  80246f:	00 00 00 
  802472:	ff d0                	callq  *%rax
  802474:	85 c0                	test   %eax,%eax
  802476:	7e 2a                	jle    8024a2 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802478:	48 ba d2 4b 80 00 00 	movabs $0x804bd2,%rdx
  80247f:	00 00 00 
  802482:	be 5b 00 00 00       	mov    $0x5b,%esi
  802487:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  80248e:	00 00 00 
  802491:	b8 00 00 00 00       	mov    $0x0,%eax
  802496:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80249d:	00 00 00 
  8024a0:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8024a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a7:	c9                   	leaveq 
  8024a8:	c3                   	retq   

00000000008024a9 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8024a9:	55                   	push   %rbp
  8024aa:	48 89 e5             	mov    %rsp,%rbp
  8024ad:	48 83 ec 18          	sub    $0x18,%rsp
  8024b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8024b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8024bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024c1:	48 c1 e8 27          	shr    $0x27,%rax
  8024c5:	48 89 c2             	mov    %rax,%rdx
  8024c8:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8024cf:	01 00 00 
  8024d2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d6:	83 e0 01             	and    $0x1,%eax
  8024d9:	48 85 c0             	test   %rax,%rax
  8024dc:	74 51                	je     80252f <pt_is_mapped+0x86>
  8024de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e2:	48 c1 e0 0c          	shl    $0xc,%rax
  8024e6:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024ea:	48 89 c2             	mov    %rax,%rdx
  8024ed:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8024f4:	01 00 00 
  8024f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fb:	83 e0 01             	and    $0x1,%eax
  8024fe:	48 85 c0             	test   %rax,%rax
  802501:	74 2c                	je     80252f <pt_is_mapped+0x86>
  802503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802507:	48 c1 e0 0c          	shl    $0xc,%rax
  80250b:	48 c1 e8 15          	shr    $0x15,%rax
  80250f:	48 89 c2             	mov    %rax,%rdx
  802512:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802519:	01 00 00 
  80251c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802520:	83 e0 01             	and    $0x1,%eax
  802523:	48 85 c0             	test   %rax,%rax
  802526:	74 07                	je     80252f <pt_is_mapped+0x86>
  802528:	b8 01 00 00 00       	mov    $0x1,%eax
  80252d:	eb 05                	jmp    802534 <pt_is_mapped+0x8b>
  80252f:	b8 00 00 00 00       	mov    $0x0,%eax
  802534:	83 e0 01             	and    $0x1,%eax
}
  802537:	c9                   	leaveq 
  802538:	c3                   	retq   

0000000000802539 <fork>:

envid_t
fork(void)
{
  802539:	55                   	push   %rbp
  80253a:	48 89 e5             	mov    %rsp,%rbp
  80253d:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802541:	48 bf 50 21 80 00 00 	movabs $0x802150,%rdi
  802548:	00 00 00 
  80254b:	48 b8 c4 40 80 00 00 	movabs $0x8040c4,%rax
  802552:	00 00 00 
  802555:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802557:	b8 07 00 00 00       	mov    $0x7,%eax
  80255c:	cd 30                	int    $0x30
  80255e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802561:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802564:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802567:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80256b:	79 30                	jns    80259d <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80256d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802570:	89 c1                	mov    %eax,%ecx
  802572:	48 ba f0 4b 80 00 00 	movabs $0x804bf0,%rdx
  802579:	00 00 00 
  80257c:	be 86 00 00 00       	mov    $0x86,%esi
  802581:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  802588:	00 00 00 
  80258b:	b8 00 00 00 00       	mov    $0x0,%eax
  802590:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  802597:	00 00 00 
  80259a:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80259d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8025a1:	75 3e                	jne    8025e1 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8025a3:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  8025aa:	00 00 00 
  8025ad:	ff d0                	callq  *%rax
  8025af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8025b4:	48 98                	cltq   
  8025b6:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8025bd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8025c4:	00 00 00 
  8025c7:	48 01 c2             	add    %rax,%rdx
  8025ca:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025d1:	00 00 00 
  8025d4:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8025d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dc:	e9 d1 01 00 00       	jmpq   8027b2 <fork+0x279>
	}
	uint64_t ad = 0;
  8025e1:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8025e8:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8025e9:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8025ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8025f2:	e9 df 00 00 00       	jmpq   8026d6 <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8025f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025fb:	48 c1 e8 27          	shr    $0x27,%rax
  8025ff:	48 89 c2             	mov    %rax,%rdx
  802602:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802609:	01 00 00 
  80260c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802610:	83 e0 01             	and    $0x1,%eax
  802613:	48 85 c0             	test   %rax,%rax
  802616:	0f 84 9e 00 00 00    	je     8026ba <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80261c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802620:	48 c1 e8 1e          	shr    $0x1e,%rax
  802624:	48 89 c2             	mov    %rax,%rdx
  802627:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80262e:	01 00 00 
  802631:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802635:	83 e0 01             	and    $0x1,%eax
  802638:	48 85 c0             	test   %rax,%rax
  80263b:	74 73                	je     8026b0 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  80263d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802641:	48 c1 e8 15          	shr    $0x15,%rax
  802645:	48 89 c2             	mov    %rax,%rdx
  802648:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80264f:	01 00 00 
  802652:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802656:	83 e0 01             	and    $0x1,%eax
  802659:	48 85 c0             	test   %rax,%rax
  80265c:	74 48                	je     8026a6 <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80265e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802662:	48 c1 e8 0c          	shr    $0xc,%rax
  802666:	48 89 c2             	mov    %rax,%rdx
  802669:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802670:	01 00 00 
  802673:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802677:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80267b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267f:	83 e0 01             	and    $0x1,%eax
  802682:	48 85 c0             	test   %rax,%rax
  802685:	74 47                	je     8026ce <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802687:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80268b:	48 c1 e8 0c          	shr    $0xc,%rax
  80268f:	89 c2                	mov    %eax,%edx
  802691:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802694:	89 d6                	mov    %edx,%esi
  802696:	89 c7                	mov    %eax,%edi
  802698:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  80269f:	00 00 00 
  8026a2:	ff d0                	callq  *%rax
  8026a4:	eb 28                	jmp    8026ce <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8026a6:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8026ad:	00 
  8026ae:	eb 1e                	jmp    8026ce <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8026b0:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8026b7:	40 
  8026b8:	eb 14                	jmp    8026ce <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8026ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026be:	48 c1 e8 27          	shr    $0x27,%rax
  8026c2:	48 83 c0 01          	add    $0x1,%rax
  8026c6:	48 c1 e0 27          	shl    $0x27,%rax
  8026ca:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8026ce:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8026d5:	00 
  8026d6:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8026dd:	00 
  8026de:	0f 87 13 ff ff ff    	ja     8025f7 <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8026e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8026e7:	ba 07 00 00 00       	mov    $0x7,%edx
  8026ec:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8026f1:	89 c7                	mov    %eax,%edi
  8026f3:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  8026fa:	00 00 00 
  8026fd:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8026ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802702:	ba 07 00 00 00       	mov    $0x7,%edx
  802707:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80270c:	89 c7                	mov    %eax,%edi
  80270e:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  802715:	00 00 00 
  802718:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80271a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80271d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802723:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802728:	ba 00 00 00 00       	mov    $0x0,%edx
  80272d:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802732:	89 c7                	mov    %eax,%edi
  802734:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  80273b:	00 00 00 
  80273e:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802740:	ba 00 10 00 00       	mov    $0x1000,%edx
  802745:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80274a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80274f:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  802756:	00 00 00 
  802759:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80275b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802760:	bf 00 00 00 00       	mov    $0x0,%edi
  802765:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  80276c:	00 00 00 
  80276f:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802771:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802778:	00 00 00 
  80277b:	48 8b 00             	mov    (%rax),%rax
  80277e:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802785:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802788:	48 89 d6             	mov    %rdx,%rsi
  80278b:	89 c7                	mov    %eax,%edi
  80278d:	48 b8 8c 1e 80 00 00 	movabs $0x801e8c,%rax
  802794:	00 00 00 
  802797:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802799:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80279c:	be 02 00 00 00       	mov    $0x2,%esi
  8027a1:	89 c7                	mov    %eax,%edi
  8027a3:	48 b8 f7 1d 80 00 00 	movabs $0x801df7,%rax
  8027aa:	00 00 00 
  8027ad:	ff d0                	callq  *%rax

	return envid;
  8027af:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8027b2:	c9                   	leaveq 
  8027b3:	c3                   	retq   

00000000008027b4 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8027b4:	55                   	push   %rbp
  8027b5:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8027b8:	48 ba 08 4c 80 00 00 	movabs $0x804c08,%rdx
  8027bf:	00 00 00 
  8027c2:	be bf 00 00 00       	mov    $0xbf,%esi
  8027c7:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  8027ce:	00 00 00 
  8027d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d6:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8027dd:	00 00 00 
  8027e0:	ff d1                	callq  *%rcx

00000000008027e2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8027e2:	55                   	push   %rbp
  8027e3:	48 89 e5             	mov    %rsp,%rbp
  8027e6:	48 83 ec 08          	sub    $0x8,%rsp
  8027ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8027ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027f2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8027f9:	ff ff ff 
  8027fc:	48 01 d0             	add    %rdx,%rax
  8027ff:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802803:	c9                   	leaveq 
  802804:	c3                   	retq   

0000000000802805 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802805:	55                   	push   %rbp
  802806:	48 89 e5             	mov    %rsp,%rbp
  802809:	48 83 ec 08          	sub    $0x8,%rsp
  80280d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802811:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802815:	48 89 c7             	mov    %rax,%rdi
  802818:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  80281f:	00 00 00 
  802822:	ff d0                	callq  *%rax
  802824:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80282a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80282e:	c9                   	leaveq 
  80282f:	c3                   	retq   

0000000000802830 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802830:	55                   	push   %rbp
  802831:	48 89 e5             	mov    %rsp,%rbp
  802834:	48 83 ec 18          	sub    $0x18,%rsp
  802838:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80283c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802843:	eb 6b                	jmp    8028b0 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802848:	48 98                	cltq   
  80284a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802850:	48 c1 e0 0c          	shl    $0xc,%rax
  802854:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802858:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285c:	48 c1 e8 15          	shr    $0x15,%rax
  802860:	48 89 c2             	mov    %rax,%rdx
  802863:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80286a:	01 00 00 
  80286d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802871:	83 e0 01             	and    $0x1,%eax
  802874:	48 85 c0             	test   %rax,%rax
  802877:	74 21                	je     80289a <fd_alloc+0x6a>
  802879:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287d:	48 c1 e8 0c          	shr    $0xc,%rax
  802881:	48 89 c2             	mov    %rax,%rdx
  802884:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80288b:	01 00 00 
  80288e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802892:	83 e0 01             	and    $0x1,%eax
  802895:	48 85 c0             	test   %rax,%rax
  802898:	75 12                	jne    8028ac <fd_alloc+0x7c>
			*fd_store = fd;
  80289a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028a2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8028a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028aa:	eb 1a                	jmp    8028c6 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028ac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028b0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028b4:	7e 8f                	jle    802845 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8028b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ba:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8028c1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8028c6:	c9                   	leaveq 
  8028c7:	c3                   	retq   

00000000008028c8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8028c8:	55                   	push   %rbp
  8028c9:	48 89 e5             	mov    %rsp,%rbp
  8028cc:	48 83 ec 20          	sub    $0x20,%rsp
  8028d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8028d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028db:	78 06                	js     8028e3 <fd_lookup+0x1b>
  8028dd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8028e1:	7e 07                	jle    8028ea <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028e8:	eb 6c                	jmp    802956 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8028ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028ed:	48 98                	cltq   
  8028ef:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028f5:	48 c1 e0 0c          	shl    $0xc,%rax
  8028f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8028fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802901:	48 c1 e8 15          	shr    $0x15,%rax
  802905:	48 89 c2             	mov    %rax,%rdx
  802908:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80290f:	01 00 00 
  802912:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802916:	83 e0 01             	and    $0x1,%eax
  802919:	48 85 c0             	test   %rax,%rax
  80291c:	74 21                	je     80293f <fd_lookup+0x77>
  80291e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802922:	48 c1 e8 0c          	shr    $0xc,%rax
  802926:	48 89 c2             	mov    %rax,%rdx
  802929:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802930:	01 00 00 
  802933:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802937:	83 e0 01             	and    $0x1,%eax
  80293a:	48 85 c0             	test   %rax,%rax
  80293d:	75 07                	jne    802946 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80293f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802944:	eb 10                	jmp    802956 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802946:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80294a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80294e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802951:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802956:	c9                   	leaveq 
  802957:	c3                   	retq   

0000000000802958 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802958:	55                   	push   %rbp
  802959:	48 89 e5             	mov    %rsp,%rbp
  80295c:	48 83 ec 30          	sub    $0x30,%rsp
  802960:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802964:	89 f0                	mov    %esi,%eax
  802966:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80296d:	48 89 c7             	mov    %rax,%rdi
  802970:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
  80297c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802980:	48 89 d6             	mov    %rdx,%rsi
  802983:	89 c7                	mov    %eax,%edi
  802985:	48 b8 c8 28 80 00 00 	movabs $0x8028c8,%rax
  80298c:	00 00 00 
  80298f:	ff d0                	callq  *%rax
  802991:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802994:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802998:	78 0a                	js     8029a4 <fd_close+0x4c>
	    || fd != fd2)
  80299a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8029a2:	74 12                	je     8029b6 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8029a4:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8029a8:	74 05                	je     8029af <fd_close+0x57>
  8029aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ad:	eb 05                	jmp    8029b4 <fd_close+0x5c>
  8029af:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b4:	eb 69                	jmp    802a1f <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8029b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ba:	8b 00                	mov    (%rax),%eax
  8029bc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029c0:	48 89 d6             	mov    %rdx,%rsi
  8029c3:	89 c7                	mov    %eax,%edi
  8029c5:	48 b8 21 2a 80 00 00 	movabs $0x802a21,%rax
  8029cc:	00 00 00 
  8029cf:	ff d0                	callq  *%rax
  8029d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d8:	78 2a                	js     802a04 <fd_close+0xac>
		if (dev->dev_close)
  8029da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029de:	48 8b 40 20          	mov    0x20(%rax),%rax
  8029e2:	48 85 c0             	test   %rax,%rax
  8029e5:	74 16                	je     8029fd <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8029e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029eb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8029ef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029f3:	48 89 d7             	mov    %rdx,%rdi
  8029f6:	ff d0                	callq  *%rax
  8029f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029fb:	eb 07                	jmp    802a04 <fd_close+0xac>
		else
			r = 0;
  8029fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802a04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a08:	48 89 c6             	mov    %rax,%rsi
  802a0b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a10:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802a17:	00 00 00 
  802a1a:	ff d0                	callq  *%rax
	return r;
  802a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a1f:	c9                   	leaveq 
  802a20:	c3                   	retq   

0000000000802a21 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802a21:	55                   	push   %rbp
  802a22:	48 89 e5             	mov    %rsp,%rbp
  802a25:	48 83 ec 20          	sub    $0x20,%rsp
  802a29:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802a30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a37:	eb 41                	jmp    802a7a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802a39:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a40:	00 00 00 
  802a43:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a46:	48 63 d2             	movslq %edx,%rdx
  802a49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a4d:	8b 00                	mov    (%rax),%eax
  802a4f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a52:	75 22                	jne    802a76 <dev_lookup+0x55>
			*dev = devtab[i];
  802a54:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a5b:	00 00 00 
  802a5e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a61:	48 63 d2             	movslq %edx,%rdx
  802a64:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a6c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a74:	eb 60                	jmp    802ad6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a76:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a7a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a81:	00 00 00 
  802a84:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a87:	48 63 d2             	movslq %edx,%rdx
  802a8a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a8e:	48 85 c0             	test   %rax,%rax
  802a91:	75 a6                	jne    802a39 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a93:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a9a:	00 00 00 
  802a9d:	48 8b 00             	mov    (%rax),%rax
  802aa0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802aa6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802aa9:	89 c6                	mov    %eax,%esi
  802aab:	48 bf 20 4c 80 00 00 	movabs $0x804c20,%rdi
  802ab2:	00 00 00 
  802ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aba:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  802ac1:	00 00 00 
  802ac4:	ff d1                	callq  *%rcx
	*dev = 0;
  802ac6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aca:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802ad1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ad6:	c9                   	leaveq 
  802ad7:	c3                   	retq   

0000000000802ad8 <close>:

int
close(int fdnum)
{
  802ad8:	55                   	push   %rbp
  802ad9:	48 89 e5             	mov    %rsp,%rbp
  802adc:	48 83 ec 20          	sub    $0x20,%rsp
  802ae0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ae3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ae7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aea:	48 89 d6             	mov    %rdx,%rsi
  802aed:	89 c7                	mov    %eax,%edi
  802aef:	48 b8 c8 28 80 00 00 	movabs $0x8028c8,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax
  802afb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b02:	79 05                	jns    802b09 <close+0x31>
		return r;
  802b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b07:	eb 18                	jmp    802b21 <close+0x49>
	else
		return fd_close(fd, 1);
  802b09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0d:	be 01 00 00 00       	mov    $0x1,%esi
  802b12:	48 89 c7             	mov    %rax,%rdi
  802b15:	48 b8 58 29 80 00 00 	movabs $0x802958,%rax
  802b1c:	00 00 00 
  802b1f:	ff d0                	callq  *%rax
}
  802b21:	c9                   	leaveq 
  802b22:	c3                   	retq   

0000000000802b23 <close_all>:

void
close_all(void)
{
  802b23:	55                   	push   %rbp
  802b24:	48 89 e5             	mov    %rsp,%rbp
  802b27:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802b2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b32:	eb 15                	jmp    802b49 <close_all+0x26>
		close(i);
  802b34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b37:	89 c7                	mov    %eax,%edi
  802b39:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  802b40:	00 00 00 
  802b43:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802b45:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b49:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b4d:	7e e5                	jle    802b34 <close_all+0x11>
		close(i);
}
  802b4f:	c9                   	leaveq 
  802b50:	c3                   	retq   

0000000000802b51 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b51:	55                   	push   %rbp
  802b52:	48 89 e5             	mov    %rsp,%rbp
  802b55:	48 83 ec 40          	sub    $0x40,%rsp
  802b59:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b5c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b5f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b63:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b66:	48 89 d6             	mov    %rdx,%rsi
  802b69:	89 c7                	mov    %eax,%edi
  802b6b:	48 b8 c8 28 80 00 00 	movabs $0x8028c8,%rax
  802b72:	00 00 00 
  802b75:	ff d0                	callq  *%rax
  802b77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7e:	79 08                	jns    802b88 <dup+0x37>
		return r;
  802b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b83:	e9 70 01 00 00       	jmpq   802cf8 <dup+0x1a7>
	close(newfdnum);
  802b88:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b8b:	89 c7                	mov    %eax,%edi
  802b8d:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  802b94:	00 00 00 
  802b97:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802b99:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b9c:	48 98                	cltq   
  802b9e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ba4:	48 c1 e0 0c          	shl    $0xc,%rax
  802ba8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802bac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bb0:	48 89 c7             	mov    %rax,%rdi
  802bb3:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  802bba:	00 00 00 
  802bbd:	ff d0                	callq  *%rax
  802bbf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802bc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc7:	48 89 c7             	mov    %rax,%rdi
  802bca:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  802bd1:	00 00 00 
  802bd4:	ff d0                	callq  *%rax
  802bd6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802bda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bde:	48 c1 e8 15          	shr    $0x15,%rax
  802be2:	48 89 c2             	mov    %rax,%rdx
  802be5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bec:	01 00 00 
  802bef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bf3:	83 e0 01             	and    $0x1,%eax
  802bf6:	48 85 c0             	test   %rax,%rax
  802bf9:	74 73                	je     802c6e <dup+0x11d>
  802bfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bff:	48 c1 e8 0c          	shr    $0xc,%rax
  802c03:	48 89 c2             	mov    %rax,%rdx
  802c06:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c0d:	01 00 00 
  802c10:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c14:	83 e0 01             	and    $0x1,%eax
  802c17:	48 85 c0             	test   %rax,%rax
  802c1a:	74 52                	je     802c6e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c20:	48 c1 e8 0c          	shr    $0xc,%rax
  802c24:	48 89 c2             	mov    %rax,%rdx
  802c27:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c2e:	01 00 00 
  802c31:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c35:	25 07 0e 00 00       	and    $0xe07,%eax
  802c3a:	89 c1                	mov    %eax,%ecx
  802c3c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c44:	41 89 c8             	mov    %ecx,%r8d
  802c47:	48 89 d1             	mov    %rdx,%rcx
  802c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c4f:	48 89 c6             	mov    %rax,%rsi
  802c52:	bf 00 00 00 00       	mov    $0x0,%edi
  802c57:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  802c5e:	00 00 00 
  802c61:	ff d0                	callq  *%rax
  802c63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6a:	79 02                	jns    802c6e <dup+0x11d>
			goto err;
  802c6c:	eb 57                	jmp    802cc5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c72:	48 c1 e8 0c          	shr    $0xc,%rax
  802c76:	48 89 c2             	mov    %rax,%rdx
  802c79:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c80:	01 00 00 
  802c83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c87:	25 07 0e 00 00       	and    $0xe07,%eax
  802c8c:	89 c1                	mov    %eax,%ecx
  802c8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c96:	41 89 c8             	mov    %ecx,%r8d
  802c99:	48 89 d1             	mov    %rdx,%rcx
  802c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca1:	48 89 c6             	mov    %rax,%rsi
  802ca4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ca9:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  802cb0:	00 00 00 
  802cb3:	ff d0                	callq  *%rax
  802cb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cbc:	79 02                	jns    802cc0 <dup+0x16f>
		goto err;
  802cbe:	eb 05                	jmp    802cc5 <dup+0x174>

	return newfdnum;
  802cc0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802cc3:	eb 33                	jmp    802cf8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc9:	48 89 c6             	mov    %rax,%rsi
  802ccc:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd1:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802cd8:	00 00 00 
  802cdb:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802cdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce1:	48 89 c6             	mov    %rax,%rsi
  802ce4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ce9:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802cf0:	00 00 00 
  802cf3:	ff d0                	callq  *%rax
	return r;
  802cf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cf8:	c9                   	leaveq 
  802cf9:	c3                   	retq   

0000000000802cfa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802cfa:	55                   	push   %rbp
  802cfb:	48 89 e5             	mov    %rsp,%rbp
  802cfe:	48 83 ec 40          	sub    $0x40,%rsp
  802d02:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d05:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d09:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d0d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d11:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d14:	48 89 d6             	mov    %rdx,%rsi
  802d17:	89 c7                	mov    %eax,%edi
  802d19:	48 b8 c8 28 80 00 00 	movabs $0x8028c8,%rax
  802d20:	00 00 00 
  802d23:	ff d0                	callq  *%rax
  802d25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2c:	78 24                	js     802d52 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d32:	8b 00                	mov    (%rax),%eax
  802d34:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d38:	48 89 d6             	mov    %rdx,%rsi
  802d3b:	89 c7                	mov    %eax,%edi
  802d3d:	48 b8 21 2a 80 00 00 	movabs $0x802a21,%rax
  802d44:	00 00 00 
  802d47:	ff d0                	callq  *%rax
  802d49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d50:	79 05                	jns    802d57 <read+0x5d>
		return r;
  802d52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d55:	eb 76                	jmp    802dcd <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5b:	8b 40 08             	mov    0x8(%rax),%eax
  802d5e:	83 e0 03             	and    $0x3,%eax
  802d61:	83 f8 01             	cmp    $0x1,%eax
  802d64:	75 3a                	jne    802da0 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d66:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d6d:	00 00 00 
  802d70:	48 8b 00             	mov    (%rax),%rax
  802d73:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d79:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d7c:	89 c6                	mov    %eax,%esi
  802d7e:	48 bf 3f 4c 80 00 00 	movabs $0x804c3f,%rdi
  802d85:	00 00 00 
  802d88:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8d:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  802d94:	00 00 00 
  802d97:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d9e:	eb 2d                	jmp    802dcd <read+0xd3>
	}
	if (!dev->dev_read)
  802da0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da4:	48 8b 40 10          	mov    0x10(%rax),%rax
  802da8:	48 85 c0             	test   %rax,%rax
  802dab:	75 07                	jne    802db4 <read+0xba>
		return -E_NOT_SUPP;
  802dad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802db2:	eb 19                	jmp    802dcd <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802db4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db8:	48 8b 40 10          	mov    0x10(%rax),%rax
  802dbc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802dc0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dc4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802dc8:	48 89 cf             	mov    %rcx,%rdi
  802dcb:	ff d0                	callq  *%rax
}
  802dcd:	c9                   	leaveq 
  802dce:	c3                   	retq   

0000000000802dcf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802dcf:	55                   	push   %rbp
  802dd0:	48 89 e5             	mov    %rsp,%rbp
  802dd3:	48 83 ec 30          	sub    $0x30,%rsp
  802dd7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dda:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dde:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802de2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802de9:	eb 49                	jmp    802e34 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802deb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dee:	48 98                	cltq   
  802df0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802df4:	48 29 c2             	sub    %rax,%rdx
  802df7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfa:	48 63 c8             	movslq %eax,%rcx
  802dfd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e01:	48 01 c1             	add    %rax,%rcx
  802e04:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e07:	48 89 ce             	mov    %rcx,%rsi
  802e0a:	89 c7                	mov    %eax,%edi
  802e0c:	48 b8 fa 2c 80 00 00 	movabs $0x802cfa,%rax
  802e13:	00 00 00 
  802e16:	ff d0                	callq  *%rax
  802e18:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802e1b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e1f:	79 05                	jns    802e26 <readn+0x57>
			return m;
  802e21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e24:	eb 1c                	jmp    802e42 <readn+0x73>
		if (m == 0)
  802e26:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e2a:	75 02                	jne    802e2e <readn+0x5f>
			break;
  802e2c:	eb 11                	jmp    802e3f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e31:	01 45 fc             	add    %eax,-0x4(%rbp)
  802e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e37:	48 98                	cltq   
  802e39:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e3d:	72 ac                	jb     802deb <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e42:	c9                   	leaveq 
  802e43:	c3                   	retq   

0000000000802e44 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e44:	55                   	push   %rbp
  802e45:	48 89 e5             	mov    %rsp,%rbp
  802e48:	48 83 ec 40          	sub    $0x40,%rsp
  802e4c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e4f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e53:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e57:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e5b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e5e:	48 89 d6             	mov    %rdx,%rsi
  802e61:	89 c7                	mov    %eax,%edi
  802e63:	48 b8 c8 28 80 00 00 	movabs $0x8028c8,%rax
  802e6a:	00 00 00 
  802e6d:	ff d0                	callq  *%rax
  802e6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e76:	78 24                	js     802e9c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7c:	8b 00                	mov    (%rax),%eax
  802e7e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e82:	48 89 d6             	mov    %rdx,%rsi
  802e85:	89 c7                	mov    %eax,%edi
  802e87:	48 b8 21 2a 80 00 00 	movabs $0x802a21,%rax
  802e8e:	00 00 00 
  802e91:	ff d0                	callq  *%rax
  802e93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9a:	79 05                	jns    802ea1 <write+0x5d>
		return r;
  802e9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9f:	eb 42                	jmp    802ee3 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ea1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea5:	8b 40 08             	mov    0x8(%rax),%eax
  802ea8:	83 e0 03             	and    $0x3,%eax
  802eab:	85 c0                	test   %eax,%eax
  802ead:	75 07                	jne    802eb6 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802eaf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802eb4:	eb 2d                	jmp    802ee3 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802eb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eba:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ebe:	48 85 c0             	test   %rax,%rax
  802ec1:	75 07                	jne    802eca <write+0x86>
		return -E_NOT_SUPP;
  802ec3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ec8:	eb 19                	jmp    802ee3 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802eca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ece:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ed2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ed6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802eda:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ede:	48 89 cf             	mov    %rcx,%rdi
  802ee1:	ff d0                	callq  *%rax
}
  802ee3:	c9                   	leaveq 
  802ee4:	c3                   	retq   

0000000000802ee5 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ee5:	55                   	push   %rbp
  802ee6:	48 89 e5             	mov    %rsp,%rbp
  802ee9:	48 83 ec 18          	sub    $0x18,%rsp
  802eed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ef0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ef3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ef7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802efa:	48 89 d6             	mov    %rdx,%rsi
  802efd:	89 c7                	mov    %eax,%edi
  802eff:	48 b8 c8 28 80 00 00 	movabs $0x8028c8,%rax
  802f06:	00 00 00 
  802f09:	ff d0                	callq  *%rax
  802f0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f12:	79 05                	jns    802f19 <seek+0x34>
		return r;
  802f14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f17:	eb 0f                	jmp    802f28 <seek+0x43>
	fd->fd_offset = offset;
  802f19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f20:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f28:	c9                   	leaveq 
  802f29:	c3                   	retq   

0000000000802f2a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f2a:	55                   	push   %rbp
  802f2b:	48 89 e5             	mov    %rsp,%rbp
  802f2e:	48 83 ec 30          	sub    $0x30,%rsp
  802f32:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f35:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f38:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f3c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f3f:	48 89 d6             	mov    %rdx,%rsi
  802f42:	89 c7                	mov    %eax,%edi
  802f44:	48 b8 c8 28 80 00 00 	movabs $0x8028c8,%rax
  802f4b:	00 00 00 
  802f4e:	ff d0                	callq  *%rax
  802f50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f57:	78 24                	js     802f7d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5d:	8b 00                	mov    (%rax),%eax
  802f5f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f63:	48 89 d6             	mov    %rdx,%rsi
  802f66:	89 c7                	mov    %eax,%edi
  802f68:	48 b8 21 2a 80 00 00 	movabs $0x802a21,%rax
  802f6f:	00 00 00 
  802f72:	ff d0                	callq  *%rax
  802f74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f7b:	79 05                	jns    802f82 <ftruncate+0x58>
		return r;
  802f7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f80:	eb 72                	jmp    802ff4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f86:	8b 40 08             	mov    0x8(%rax),%eax
  802f89:	83 e0 03             	and    $0x3,%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	75 3a                	jne    802fca <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802f90:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802f97:	00 00 00 
  802f9a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f9d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fa3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fa6:	89 c6                	mov    %eax,%esi
  802fa8:	48 bf 60 4c 80 00 00 	movabs $0x804c60,%rdi
  802faf:	00 00 00 
  802fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb7:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  802fbe:	00 00 00 
  802fc1:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802fc3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fc8:	eb 2a                	jmp    802ff4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802fca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fce:	48 8b 40 30          	mov    0x30(%rax),%rax
  802fd2:	48 85 c0             	test   %rax,%rax
  802fd5:	75 07                	jne    802fde <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802fd7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fdc:	eb 16                	jmp    802ff4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802fe6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fea:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802fed:	89 ce                	mov    %ecx,%esi
  802fef:	48 89 d7             	mov    %rdx,%rdi
  802ff2:	ff d0                	callq  *%rax
}
  802ff4:	c9                   	leaveq 
  802ff5:	c3                   	retq   

0000000000802ff6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ff6:	55                   	push   %rbp
  802ff7:	48 89 e5             	mov    %rsp,%rbp
  802ffa:	48 83 ec 30          	sub    $0x30,%rsp
  802ffe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803001:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803005:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803009:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80300c:	48 89 d6             	mov    %rdx,%rsi
  80300f:	89 c7                	mov    %eax,%edi
  803011:	48 b8 c8 28 80 00 00 	movabs $0x8028c8,%rax
  803018:	00 00 00 
  80301b:	ff d0                	callq  *%rax
  80301d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803020:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803024:	78 24                	js     80304a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803026:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302a:	8b 00                	mov    (%rax),%eax
  80302c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803030:	48 89 d6             	mov    %rdx,%rsi
  803033:	89 c7                	mov    %eax,%edi
  803035:	48 b8 21 2a 80 00 00 	movabs $0x802a21,%rax
  80303c:	00 00 00 
  80303f:	ff d0                	callq  *%rax
  803041:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803044:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803048:	79 05                	jns    80304f <fstat+0x59>
		return r;
  80304a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304d:	eb 5e                	jmp    8030ad <fstat+0xb7>
	if (!dev->dev_stat)
  80304f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803053:	48 8b 40 28          	mov    0x28(%rax),%rax
  803057:	48 85 c0             	test   %rax,%rax
  80305a:	75 07                	jne    803063 <fstat+0x6d>
		return -E_NOT_SUPP;
  80305c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803061:	eb 4a                	jmp    8030ad <fstat+0xb7>
	stat->st_name[0] = 0;
  803063:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803067:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80306a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80306e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803075:	00 00 00 
	stat->st_isdir = 0;
  803078:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80307c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803083:	00 00 00 
	stat->st_dev = dev;
  803086:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80308a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80308e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803095:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803099:	48 8b 40 28          	mov    0x28(%rax),%rax
  80309d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030a1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8030a5:	48 89 ce             	mov    %rcx,%rsi
  8030a8:	48 89 d7             	mov    %rdx,%rdi
  8030ab:	ff d0                	callq  *%rax
}
  8030ad:	c9                   	leaveq 
  8030ae:	c3                   	retq   

00000000008030af <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8030af:	55                   	push   %rbp
  8030b0:	48 89 e5             	mov    %rsp,%rbp
  8030b3:	48 83 ec 20          	sub    $0x20,%rsp
  8030b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8030bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c3:	be 00 00 00 00       	mov    $0x0,%esi
  8030c8:	48 89 c7             	mov    %rax,%rdi
  8030cb:	48 b8 9d 31 80 00 00 	movabs $0x80319d,%rax
  8030d2:	00 00 00 
  8030d5:	ff d0                	callq  *%rax
  8030d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030de:	79 05                	jns    8030e5 <stat+0x36>
		return fd;
  8030e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e3:	eb 2f                	jmp    803114 <stat+0x65>
	r = fstat(fd, stat);
  8030e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8030e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ec:	48 89 d6             	mov    %rdx,%rsi
  8030ef:	89 c7                	mov    %eax,%edi
  8030f1:	48 b8 f6 2f 80 00 00 	movabs $0x802ff6,%rax
  8030f8:	00 00 00 
  8030fb:	ff d0                	callq  *%rax
  8030fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803100:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803103:	89 c7                	mov    %eax,%edi
  803105:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  80310c:	00 00 00 
  80310f:	ff d0                	callq  *%rax
	return r;
  803111:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803114:	c9                   	leaveq 
  803115:	c3                   	retq   

0000000000803116 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803116:	55                   	push   %rbp
  803117:	48 89 e5             	mov    %rsp,%rbp
  80311a:	48 83 ec 10          	sub    $0x10,%rsp
  80311e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803121:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803125:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80312c:	00 00 00 
  80312f:	8b 00                	mov    (%rax),%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	75 1d                	jne    803152 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803135:	bf 01 00 00 00       	mov    $0x1,%edi
  80313a:	48 b8 8a 43 80 00 00 	movabs $0x80438a,%rax
  803141:	00 00 00 
  803144:	ff d0                	callq  *%rax
  803146:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80314d:	00 00 00 
  803150:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803152:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803159:	00 00 00 
  80315c:	8b 00                	mov    (%rax),%eax
  80315e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803161:	b9 07 00 00 00       	mov    $0x7,%ecx
  803166:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80316d:	00 00 00 
  803170:	89 c7                	mov    %eax,%edi
  803172:	48 b8 02 43 80 00 00 	movabs $0x804302,%rax
  803179:	00 00 00 
  80317c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80317e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803182:	ba 00 00 00 00       	mov    $0x0,%edx
  803187:	48 89 c6             	mov    %rax,%rsi
  80318a:	bf 00 00 00 00       	mov    $0x0,%edi
  80318f:	48 b8 04 42 80 00 00 	movabs $0x804204,%rax
  803196:	00 00 00 
  803199:	ff d0                	callq  *%rax
}
  80319b:	c9                   	leaveq 
  80319c:	c3                   	retq   

000000000080319d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80319d:	55                   	push   %rbp
  80319e:	48 89 e5             	mov    %rsp,%rbp
  8031a1:	48 83 ec 30          	sub    $0x30,%rsp
  8031a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031a9:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8031ac:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8031b3:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8031ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8031c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8031c6:	75 08                	jne    8031d0 <open+0x33>
	{
		return r;
  8031c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cb:	e9 f2 00 00 00       	jmpq   8032c2 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8031d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d4:	48 89 c7             	mov    %rax,%rdi
  8031d7:	48 b8 67 13 80 00 00 	movabs $0x801367,%rax
  8031de:	00 00 00 
  8031e1:	ff d0                	callq  *%rax
  8031e3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8031e6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8031ed:	7e 0a                	jle    8031f9 <open+0x5c>
	{
		return -E_BAD_PATH;
  8031ef:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031f4:	e9 c9 00 00 00       	jmpq   8032c2 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8031f9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803200:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803201:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803205:	48 89 c7             	mov    %rax,%rdi
  803208:	48 b8 30 28 80 00 00 	movabs $0x802830,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
  803214:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803217:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321b:	78 09                	js     803226 <open+0x89>
  80321d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803221:	48 85 c0             	test   %rax,%rax
  803224:	75 08                	jne    80322e <open+0x91>
		{
			return r;
  803226:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803229:	e9 94 00 00 00       	jmpq   8032c2 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80322e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803232:	ba 00 04 00 00       	mov    $0x400,%edx
  803237:	48 89 c6             	mov    %rax,%rsi
  80323a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803241:	00 00 00 
  803244:	48 b8 65 14 80 00 00 	movabs $0x801465,%rax
  80324b:	00 00 00 
  80324e:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803250:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803257:	00 00 00 
  80325a:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80325d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803267:	48 89 c6             	mov    %rax,%rsi
  80326a:	bf 01 00 00 00       	mov    $0x1,%edi
  80326f:	48 b8 16 31 80 00 00 	movabs $0x803116,%rax
  803276:	00 00 00 
  803279:	ff d0                	callq  *%rax
  80327b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80327e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803282:	79 2b                	jns    8032af <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803288:	be 00 00 00 00       	mov    $0x0,%esi
  80328d:	48 89 c7             	mov    %rax,%rdi
  803290:	48 b8 58 29 80 00 00 	movabs $0x802958,%rax
  803297:	00 00 00 
  80329a:	ff d0                	callq  *%rax
  80329c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80329f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032a3:	79 05                	jns    8032aa <open+0x10d>
			{
				return d;
  8032a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032a8:	eb 18                	jmp    8032c2 <open+0x125>
			}
			return r;
  8032aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ad:	eb 13                	jmp    8032c2 <open+0x125>
		}	
		return fd2num(fd_store);
  8032af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b3:	48 89 c7             	mov    %rax,%rdi
  8032b6:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  8032bd:	00 00 00 
  8032c0:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8032c2:	c9                   	leaveq 
  8032c3:	c3                   	retq   

00000000008032c4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8032c4:	55                   	push   %rbp
  8032c5:	48 89 e5             	mov    %rsp,%rbp
  8032c8:	48 83 ec 10          	sub    $0x10,%rsp
  8032cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8032d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032d4:	8b 50 0c             	mov    0xc(%rax),%edx
  8032d7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032de:	00 00 00 
  8032e1:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8032e3:	be 00 00 00 00       	mov    $0x0,%esi
  8032e8:	bf 06 00 00 00       	mov    $0x6,%edi
  8032ed:	48 b8 16 31 80 00 00 	movabs $0x803116,%rax
  8032f4:	00 00 00 
  8032f7:	ff d0                	callq  *%rax
}
  8032f9:	c9                   	leaveq 
  8032fa:	c3                   	retq   

00000000008032fb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8032fb:	55                   	push   %rbp
  8032fc:	48 89 e5             	mov    %rsp,%rbp
  8032ff:	48 83 ec 30          	sub    $0x30,%rsp
  803303:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803307:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80330b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80330f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803316:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80331b:	74 07                	je     803324 <devfile_read+0x29>
  80331d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803322:	75 07                	jne    80332b <devfile_read+0x30>
		return -E_INVAL;
  803324:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803329:	eb 77                	jmp    8033a2 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80332b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80332f:	8b 50 0c             	mov    0xc(%rax),%edx
  803332:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803339:	00 00 00 
  80333c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80333e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803345:	00 00 00 
  803348:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80334c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803350:	be 00 00 00 00       	mov    $0x0,%esi
  803355:	bf 03 00 00 00       	mov    $0x3,%edi
  80335a:	48 b8 16 31 80 00 00 	movabs $0x803116,%rax
  803361:	00 00 00 
  803364:	ff d0                	callq  *%rax
  803366:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803369:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80336d:	7f 05                	jg     803374 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80336f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803372:	eb 2e                	jmp    8033a2 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803377:	48 63 d0             	movslq %eax,%rdx
  80337a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803385:	00 00 00 
  803388:	48 89 c7             	mov    %rax,%rdi
  80338b:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803397:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80339f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8033a2:	c9                   	leaveq 
  8033a3:	c3                   	retq   

00000000008033a4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8033a4:	55                   	push   %rbp
  8033a5:	48 89 e5             	mov    %rsp,%rbp
  8033a8:	48 83 ec 30          	sub    $0x30,%rsp
  8033ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8033b8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8033bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033c4:	74 07                	je     8033cd <devfile_write+0x29>
  8033c6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033cb:	75 08                	jne    8033d5 <devfile_write+0x31>
		return r;
  8033cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d0:	e9 9a 00 00 00       	jmpq   80346f <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8033d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033d9:	8b 50 0c             	mov    0xc(%rax),%edx
  8033dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033e3:	00 00 00 
  8033e6:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8033e8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8033ef:	00 
  8033f0:	76 08                	jbe    8033fa <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8033f2:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8033f9:	00 
	}
	fsipcbuf.write.req_n = n;
  8033fa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803401:	00 00 00 
  803404:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803408:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80340c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803410:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803414:	48 89 c6             	mov    %rax,%rsi
  803417:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80341e:	00 00 00 
  803421:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  803428:	00 00 00 
  80342b:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80342d:	be 00 00 00 00       	mov    $0x0,%esi
  803432:	bf 04 00 00 00       	mov    $0x4,%edi
  803437:	48 b8 16 31 80 00 00 	movabs $0x803116,%rax
  80343e:	00 00 00 
  803441:	ff d0                	callq  *%rax
  803443:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803446:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80344a:	7f 20                	jg     80346c <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80344c:	48 bf 86 4c 80 00 00 	movabs $0x804c86,%rdi
  803453:	00 00 00 
  803456:	b8 00 00 00 00       	mov    $0x0,%eax
  80345b:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  803462:	00 00 00 
  803465:	ff d2                	callq  *%rdx
		return r;
  803467:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346a:	eb 03                	jmp    80346f <devfile_write+0xcb>
	}
	return r;
  80346c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80346f:	c9                   	leaveq 
  803470:	c3                   	retq   

0000000000803471 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803471:	55                   	push   %rbp
  803472:	48 89 e5             	mov    %rsp,%rbp
  803475:	48 83 ec 20          	sub    $0x20,%rsp
  803479:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80347d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803485:	8b 50 0c             	mov    0xc(%rax),%edx
  803488:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80348f:	00 00 00 
  803492:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803494:	be 00 00 00 00       	mov    $0x0,%esi
  803499:	bf 05 00 00 00       	mov    $0x5,%edi
  80349e:	48 b8 16 31 80 00 00 	movabs $0x803116,%rax
  8034a5:	00 00 00 
  8034a8:	ff d0                	callq  *%rax
  8034aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b1:	79 05                	jns    8034b8 <devfile_stat+0x47>
		return r;
  8034b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b6:	eb 56                	jmp    80350e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8034b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034bc:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8034c3:	00 00 00 
  8034c6:	48 89 c7             	mov    %rax,%rdi
  8034c9:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  8034d0:	00 00 00 
  8034d3:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8034d5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034dc:	00 00 00 
  8034df:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8034e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034e9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8034ef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034f6:	00 00 00 
  8034f9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8034ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803503:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803509:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80350e:	c9                   	leaveq 
  80350f:	c3                   	retq   

0000000000803510 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803510:	55                   	push   %rbp
  803511:	48 89 e5             	mov    %rsp,%rbp
  803514:	48 83 ec 10          	sub    $0x10,%rsp
  803518:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80351c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80351f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803523:	8b 50 0c             	mov    0xc(%rax),%edx
  803526:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80352d:	00 00 00 
  803530:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803532:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803539:	00 00 00 
  80353c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80353f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803542:	be 00 00 00 00       	mov    $0x0,%esi
  803547:	bf 02 00 00 00       	mov    $0x2,%edi
  80354c:	48 b8 16 31 80 00 00 	movabs $0x803116,%rax
  803553:	00 00 00 
  803556:	ff d0                	callq  *%rax
}
  803558:	c9                   	leaveq 
  803559:	c3                   	retq   

000000000080355a <remove>:

// Delete a file
int
remove(const char *path)
{
  80355a:	55                   	push   %rbp
  80355b:	48 89 e5             	mov    %rsp,%rbp
  80355e:	48 83 ec 10          	sub    $0x10,%rsp
  803562:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803566:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80356a:	48 89 c7             	mov    %rax,%rdi
  80356d:	48 b8 67 13 80 00 00 	movabs $0x801367,%rax
  803574:	00 00 00 
  803577:	ff d0                	callq  *%rax
  803579:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80357e:	7e 07                	jle    803587 <remove+0x2d>
		return -E_BAD_PATH;
  803580:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803585:	eb 33                	jmp    8035ba <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803587:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80358b:	48 89 c6             	mov    %rax,%rsi
  80358e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803595:	00 00 00 
  803598:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  80359f:	00 00 00 
  8035a2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8035a4:	be 00 00 00 00       	mov    $0x0,%esi
  8035a9:	bf 07 00 00 00       	mov    $0x7,%edi
  8035ae:	48 b8 16 31 80 00 00 	movabs $0x803116,%rax
  8035b5:	00 00 00 
  8035b8:	ff d0                	callq  *%rax
}
  8035ba:	c9                   	leaveq 
  8035bb:	c3                   	retq   

00000000008035bc <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8035bc:	55                   	push   %rbp
  8035bd:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8035c0:	be 00 00 00 00       	mov    $0x0,%esi
  8035c5:	bf 08 00 00 00       	mov    $0x8,%edi
  8035ca:	48 b8 16 31 80 00 00 	movabs $0x803116,%rax
  8035d1:	00 00 00 
  8035d4:	ff d0                	callq  *%rax
}
  8035d6:	5d                   	pop    %rbp
  8035d7:	c3                   	retq   

00000000008035d8 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8035d8:	55                   	push   %rbp
  8035d9:	48 89 e5             	mov    %rsp,%rbp
  8035dc:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8035e3:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8035ea:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8035f1:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8035f8:	be 00 00 00 00       	mov    $0x0,%esi
  8035fd:	48 89 c7             	mov    %rax,%rdi
  803600:	48 b8 9d 31 80 00 00 	movabs $0x80319d,%rax
  803607:	00 00 00 
  80360a:	ff d0                	callq  *%rax
  80360c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80360f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803613:	79 28                	jns    80363d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803618:	89 c6                	mov    %eax,%esi
  80361a:	48 bf a2 4c 80 00 00 	movabs $0x804ca2,%rdi
  803621:	00 00 00 
  803624:	b8 00 00 00 00       	mov    $0x0,%eax
  803629:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  803630:	00 00 00 
  803633:	ff d2                	callq  *%rdx
		return fd_src;
  803635:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803638:	e9 74 01 00 00       	jmpq   8037b1 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80363d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803644:	be 01 01 00 00       	mov    $0x101,%esi
  803649:	48 89 c7             	mov    %rax,%rdi
  80364c:	48 b8 9d 31 80 00 00 	movabs $0x80319d,%rax
  803653:	00 00 00 
  803656:	ff d0                	callq  *%rax
  803658:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80365b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80365f:	79 39                	jns    80369a <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803661:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803664:	89 c6                	mov    %eax,%esi
  803666:	48 bf b8 4c 80 00 00 	movabs $0x804cb8,%rdi
  80366d:	00 00 00 
  803670:	b8 00 00 00 00       	mov    $0x0,%eax
  803675:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  80367c:	00 00 00 
  80367f:	ff d2                	callq  *%rdx
		close(fd_src);
  803681:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803684:	89 c7                	mov    %eax,%edi
  803686:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
		return fd_dest;
  803692:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803695:	e9 17 01 00 00       	jmpq   8037b1 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80369a:	eb 74                	jmp    803710 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80369c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80369f:	48 63 d0             	movslq %eax,%rdx
  8036a2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8036a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ac:	48 89 ce             	mov    %rcx,%rsi
  8036af:	89 c7                	mov    %eax,%edi
  8036b1:	48 b8 44 2e 80 00 00 	movabs $0x802e44,%rax
  8036b8:	00 00 00 
  8036bb:	ff d0                	callq  *%rax
  8036bd:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8036c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8036c4:	79 4a                	jns    803710 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8036c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8036c9:	89 c6                	mov    %eax,%esi
  8036cb:	48 bf d2 4c 80 00 00 	movabs $0x804cd2,%rdi
  8036d2:	00 00 00 
  8036d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8036da:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  8036e1:	00 00 00 
  8036e4:	ff d2                	callq  *%rdx
			close(fd_src);
  8036e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e9:	89 c7                	mov    %eax,%edi
  8036eb:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  8036f2:	00 00 00 
  8036f5:	ff d0                	callq  *%rax
			close(fd_dest);
  8036f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036fa:	89 c7                	mov    %eax,%edi
  8036fc:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  803703:	00 00 00 
  803706:	ff d0                	callq  *%rax
			return write_size;
  803708:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80370b:	e9 a1 00 00 00       	jmpq   8037b1 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803710:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803717:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371a:	ba 00 02 00 00       	mov    $0x200,%edx
  80371f:	48 89 ce             	mov    %rcx,%rsi
  803722:	89 c7                	mov    %eax,%edi
  803724:	48 b8 fa 2c 80 00 00 	movabs $0x802cfa,%rax
  80372b:	00 00 00 
  80372e:	ff d0                	callq  *%rax
  803730:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803733:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803737:	0f 8f 5f ff ff ff    	jg     80369c <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80373d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803741:	79 47                	jns    80378a <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803743:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803746:	89 c6                	mov    %eax,%esi
  803748:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  80374f:	00 00 00 
  803752:	b8 00 00 00 00       	mov    $0x0,%eax
  803757:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  80375e:	00 00 00 
  803761:	ff d2                	callq  *%rdx
		close(fd_src);
  803763:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803766:	89 c7                	mov    %eax,%edi
  803768:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  80376f:	00 00 00 
  803772:	ff d0                	callq  *%rax
		close(fd_dest);
  803774:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803777:	89 c7                	mov    %eax,%edi
  803779:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  803780:	00 00 00 
  803783:	ff d0                	callq  *%rax
		return read_size;
  803785:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803788:	eb 27                	jmp    8037b1 <copy+0x1d9>
	}
	close(fd_src);
  80378a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80378d:	89 c7                	mov    %eax,%edi
  80378f:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  803796:	00 00 00 
  803799:	ff d0                	callq  *%rax
	close(fd_dest);
  80379b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80379e:	89 c7                	mov    %eax,%edi
  8037a0:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  8037a7:	00 00 00 
  8037aa:	ff d0                	callq  *%rax
	return 0;
  8037ac:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8037b1:	c9                   	leaveq 
  8037b2:	c3                   	retq   

00000000008037b3 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8037b3:	55                   	push   %rbp
  8037b4:	48 89 e5             	mov    %rsp,%rbp
  8037b7:	53                   	push   %rbx
  8037b8:	48 83 ec 38          	sub    $0x38,%rsp
  8037bc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8037c0:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8037c4:	48 89 c7             	mov    %rax,%rdi
  8037c7:	48 b8 30 28 80 00 00 	movabs $0x802830,%rax
  8037ce:	00 00 00 
  8037d1:	ff d0                	callq  *%rax
  8037d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037da:	0f 88 bf 01 00 00    	js     80399f <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e4:	ba 07 04 00 00       	mov    $0x407,%edx
  8037e9:	48 89 c6             	mov    %rax,%rsi
  8037ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f1:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  8037f8:	00 00 00 
  8037fb:	ff d0                	callq  *%rax
  8037fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803800:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803804:	0f 88 95 01 00 00    	js     80399f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80380a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80380e:	48 89 c7             	mov    %rax,%rdi
  803811:	48 b8 30 28 80 00 00 	movabs $0x802830,%rax
  803818:	00 00 00 
  80381b:	ff d0                	callq  *%rax
  80381d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803820:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803824:	0f 88 5d 01 00 00    	js     803987 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80382a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80382e:	ba 07 04 00 00       	mov    $0x407,%edx
  803833:	48 89 c6             	mov    %rax,%rsi
  803836:	bf 00 00 00 00       	mov    $0x0,%edi
  80383b:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  803842:	00 00 00 
  803845:	ff d0                	callq  *%rax
  803847:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80384a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80384e:	0f 88 33 01 00 00    	js     803987 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803858:	48 89 c7             	mov    %rax,%rdi
  80385b:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  803862:	00 00 00 
  803865:	ff d0                	callq  *%rax
  803867:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80386b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80386f:	ba 07 04 00 00       	mov    $0x407,%edx
  803874:	48 89 c6             	mov    %rax,%rsi
  803877:	bf 00 00 00 00       	mov    $0x0,%edi
  80387c:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  803883:	00 00 00 
  803886:	ff d0                	callq  *%rax
  803888:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80388b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80388f:	79 05                	jns    803896 <pipe+0xe3>
		goto err2;
  803891:	e9 d9 00 00 00       	jmpq   80396f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803896:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80389a:	48 89 c7             	mov    %rax,%rdi
  80389d:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
  8038a9:	48 89 c2             	mov    %rax,%rdx
  8038ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b0:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8038b6:	48 89 d1             	mov    %rdx,%rcx
  8038b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8038be:	48 89 c6             	mov    %rax,%rsi
  8038c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8038c6:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  8038cd:	00 00 00 
  8038d0:	ff d0                	callq  *%rax
  8038d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038d9:	79 1b                	jns    8038f6 <pipe+0x143>
		goto err3;
  8038db:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8038dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038e0:	48 89 c6             	mov    %rax,%rsi
  8038e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8038e8:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  8038ef:	00 00 00 
  8038f2:	ff d0                	callq  *%rax
  8038f4:	eb 79                	jmp    80396f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8038f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038fa:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803901:	00 00 00 
  803904:	8b 12                	mov    (%rdx),%edx
  803906:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803908:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80390c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803913:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803917:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80391e:	00 00 00 
  803921:	8b 12                	mov    (%rdx),%edx
  803923:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803925:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803929:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803934:	48 89 c7             	mov    %rax,%rdi
  803937:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  80393e:	00 00 00 
  803941:	ff d0                	callq  *%rax
  803943:	89 c2                	mov    %eax,%edx
  803945:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803949:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80394b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80394f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803953:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803957:	48 89 c7             	mov    %rax,%rdi
  80395a:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  803961:	00 00 00 
  803964:	ff d0                	callq  *%rax
  803966:	89 03                	mov    %eax,(%rbx)
	return 0;
  803968:	b8 00 00 00 00       	mov    $0x0,%eax
  80396d:	eb 33                	jmp    8039a2 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80396f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803973:	48 89 c6             	mov    %rax,%rsi
  803976:	bf 00 00 00 00       	mov    $0x0,%edi
  80397b:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  803982:	00 00 00 
  803985:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803987:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80398b:	48 89 c6             	mov    %rax,%rsi
  80398e:	bf 00 00 00 00       	mov    $0x0,%edi
  803993:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  80399a:	00 00 00 
  80399d:	ff d0                	callq  *%rax
err:
	return r;
  80399f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039a2:	48 83 c4 38          	add    $0x38,%rsp
  8039a6:	5b                   	pop    %rbx
  8039a7:	5d                   	pop    %rbp
  8039a8:	c3                   	retq   

00000000008039a9 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8039a9:	55                   	push   %rbp
  8039aa:	48 89 e5             	mov    %rsp,%rbp
  8039ad:	53                   	push   %rbx
  8039ae:	48 83 ec 28          	sub    $0x28,%rsp
  8039b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8039ba:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039c1:	00 00 00 
  8039c4:	48 8b 00             	mov    (%rax),%rax
  8039c7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8039d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d4:	48 89 c7             	mov    %rax,%rdi
  8039d7:	48 b8 fc 43 80 00 00 	movabs $0x8043fc,%rax
  8039de:	00 00 00 
  8039e1:	ff d0                	callq  *%rax
  8039e3:	89 c3                	mov    %eax,%ebx
  8039e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e9:	48 89 c7             	mov    %rax,%rdi
  8039ec:	48 b8 fc 43 80 00 00 	movabs $0x8043fc,%rax
  8039f3:	00 00 00 
  8039f6:	ff d0                	callq  *%rax
  8039f8:	39 c3                	cmp    %eax,%ebx
  8039fa:	0f 94 c0             	sete   %al
  8039fd:	0f b6 c0             	movzbl %al,%eax
  803a00:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803a03:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a0a:	00 00 00 
  803a0d:	48 8b 00             	mov    (%rax),%rax
  803a10:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a16:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803a19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a1c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a1f:	75 05                	jne    803a26 <_pipeisclosed+0x7d>
			return ret;
  803a21:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a24:	eb 4f                	jmp    803a75 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803a26:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a29:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a2c:	74 42                	je     803a70 <_pipeisclosed+0xc7>
  803a2e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803a32:	75 3c                	jne    803a70 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803a34:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a3b:	00 00 00 
  803a3e:	48 8b 00             	mov    (%rax),%rax
  803a41:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803a47:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a4d:	89 c6                	mov    %eax,%esi
  803a4f:	48 bf 05 4d 80 00 00 	movabs $0x804d05,%rdi
  803a56:	00 00 00 
  803a59:	b8 00 00 00 00       	mov    $0x0,%eax
  803a5e:	49 b8 1e 08 80 00 00 	movabs $0x80081e,%r8
  803a65:	00 00 00 
  803a68:	41 ff d0             	callq  *%r8
	}
  803a6b:	e9 4a ff ff ff       	jmpq   8039ba <_pipeisclosed+0x11>
  803a70:	e9 45 ff ff ff       	jmpq   8039ba <_pipeisclosed+0x11>
}
  803a75:	48 83 c4 28          	add    $0x28,%rsp
  803a79:	5b                   	pop    %rbx
  803a7a:	5d                   	pop    %rbp
  803a7b:	c3                   	retq   

0000000000803a7c <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803a7c:	55                   	push   %rbp
  803a7d:	48 89 e5             	mov    %rsp,%rbp
  803a80:	48 83 ec 30          	sub    $0x30,%rsp
  803a84:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a87:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a8b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a8e:	48 89 d6             	mov    %rdx,%rsi
  803a91:	89 c7                	mov    %eax,%edi
  803a93:	48 b8 c8 28 80 00 00 	movabs $0x8028c8,%rax
  803a9a:	00 00 00 
  803a9d:	ff d0                	callq  *%rax
  803a9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aa6:	79 05                	jns    803aad <pipeisclosed+0x31>
		return r;
  803aa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aab:	eb 31                	jmp    803ade <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803aad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ab1:	48 89 c7             	mov    %rax,%rdi
  803ab4:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  803abb:	00 00 00 
  803abe:	ff d0                	callq  *%rax
  803ac0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803ac4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ac8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803acc:	48 89 d6             	mov    %rdx,%rsi
  803acf:	48 89 c7             	mov    %rax,%rdi
  803ad2:	48 b8 a9 39 80 00 00 	movabs $0x8039a9,%rax
  803ad9:	00 00 00 
  803adc:	ff d0                	callq  *%rax
}
  803ade:	c9                   	leaveq 
  803adf:	c3                   	retq   

0000000000803ae0 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ae0:	55                   	push   %rbp
  803ae1:	48 89 e5             	mov    %rsp,%rbp
  803ae4:	48 83 ec 40          	sub    $0x40,%rsp
  803ae8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803aec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803af0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803af4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af8:	48 89 c7             	mov    %rax,%rdi
  803afb:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  803b02:	00 00 00 
  803b05:	ff d0                	callq  *%rax
  803b07:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b0f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b13:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b1a:	00 
  803b1b:	e9 92 00 00 00       	jmpq   803bb2 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803b20:	eb 41                	jmp    803b63 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803b22:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803b27:	74 09                	je     803b32 <devpipe_read+0x52>
				return i;
  803b29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b2d:	e9 92 00 00 00       	jmpq   803bc4 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803b32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b3a:	48 89 d6             	mov    %rdx,%rsi
  803b3d:	48 89 c7             	mov    %rax,%rdi
  803b40:	48 b8 a9 39 80 00 00 	movabs $0x8039a9,%rax
  803b47:	00 00 00 
  803b4a:	ff d0                	callq  *%rax
  803b4c:	85 c0                	test   %eax,%eax
  803b4e:	74 07                	je     803b57 <devpipe_read+0x77>
				return 0;
  803b50:	b8 00 00 00 00       	mov    $0x0,%eax
  803b55:	eb 6d                	jmp    803bc4 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b57:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803b5e:	00 00 00 
  803b61:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803b63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b67:	8b 10                	mov    (%rax),%edx
  803b69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6d:	8b 40 04             	mov    0x4(%rax),%eax
  803b70:	39 c2                	cmp    %eax,%edx
  803b72:	74 ae                	je     803b22 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803b74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b7c:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803b80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b84:	8b 00                	mov    (%rax),%eax
  803b86:	99                   	cltd   
  803b87:	c1 ea 1b             	shr    $0x1b,%edx
  803b8a:	01 d0                	add    %edx,%eax
  803b8c:	83 e0 1f             	and    $0x1f,%eax
  803b8f:	29 d0                	sub    %edx,%eax
  803b91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b95:	48 98                	cltq   
  803b97:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803b9c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803b9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba2:	8b 00                	mov    (%rax),%eax
  803ba4:	8d 50 01             	lea    0x1(%rax),%edx
  803ba7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bab:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803bad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803bb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bba:	0f 82 60 ff ff ff    	jb     803b20 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803bc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803bc4:	c9                   	leaveq 
  803bc5:	c3                   	retq   

0000000000803bc6 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803bc6:	55                   	push   %rbp
  803bc7:	48 89 e5             	mov    %rsp,%rbp
  803bca:	48 83 ec 40          	sub    $0x40,%rsp
  803bce:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803bd2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803bd6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803bda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bde:	48 89 c7             	mov    %rax,%rdi
  803be1:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  803be8:	00 00 00 
  803beb:	ff d0                	callq  *%rax
  803bed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803bf1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bf5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bf9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c00:	00 
  803c01:	e9 8e 00 00 00       	jmpq   803c94 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c06:	eb 31                	jmp    803c39 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803c08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c10:	48 89 d6             	mov    %rdx,%rsi
  803c13:	48 89 c7             	mov    %rax,%rdi
  803c16:	48 b8 a9 39 80 00 00 	movabs $0x8039a9,%rax
  803c1d:	00 00 00 
  803c20:	ff d0                	callq  *%rax
  803c22:	85 c0                	test   %eax,%eax
  803c24:	74 07                	je     803c2d <devpipe_write+0x67>
				return 0;
  803c26:	b8 00 00 00 00       	mov    $0x0,%eax
  803c2b:	eb 79                	jmp    803ca6 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803c2d:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803c34:	00 00 00 
  803c37:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3d:	8b 40 04             	mov    0x4(%rax),%eax
  803c40:	48 63 d0             	movslq %eax,%rdx
  803c43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c47:	8b 00                	mov    (%rax),%eax
  803c49:	48 98                	cltq   
  803c4b:	48 83 c0 20          	add    $0x20,%rax
  803c4f:	48 39 c2             	cmp    %rax,%rdx
  803c52:	73 b4                	jae    803c08 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803c54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c58:	8b 40 04             	mov    0x4(%rax),%eax
  803c5b:	99                   	cltd   
  803c5c:	c1 ea 1b             	shr    $0x1b,%edx
  803c5f:	01 d0                	add    %edx,%eax
  803c61:	83 e0 1f             	and    $0x1f,%eax
  803c64:	29 d0                	sub    %edx,%eax
  803c66:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c6a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c6e:	48 01 ca             	add    %rcx,%rdx
  803c71:	0f b6 0a             	movzbl (%rdx),%ecx
  803c74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c78:	48 98                	cltq   
  803c7a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c82:	8b 40 04             	mov    0x4(%rax),%eax
  803c85:	8d 50 01             	lea    0x1(%rax),%edx
  803c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c8c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c8f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c98:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c9c:	0f 82 64 ff ff ff    	jb     803c06 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ca2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ca6:	c9                   	leaveq 
  803ca7:	c3                   	retq   

0000000000803ca8 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ca8:	55                   	push   %rbp
  803ca9:	48 89 e5             	mov    %rsp,%rbp
  803cac:	48 83 ec 20          	sub    $0x20,%rsp
  803cb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803cb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cbc:	48 89 c7             	mov    %rax,%rdi
  803cbf:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  803cc6:	00 00 00 
  803cc9:	ff d0                	callq  *%rax
  803ccb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ccf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cd3:	48 be 18 4d 80 00 00 	movabs $0x804d18,%rsi
  803cda:	00 00 00 
  803cdd:	48 89 c7             	mov    %rax,%rdi
  803ce0:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  803ce7:	00 00 00 
  803cea:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803cec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf0:	8b 50 04             	mov    0x4(%rax),%edx
  803cf3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf7:	8b 00                	mov    (%rax),%eax
  803cf9:	29 c2                	sub    %eax,%edx
  803cfb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cff:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803d05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d09:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803d10:	00 00 00 
	stat->st_dev = &devpipe;
  803d13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d17:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803d1e:	00 00 00 
  803d21:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d2d:	c9                   	leaveq 
  803d2e:	c3                   	retq   

0000000000803d2f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d2f:	55                   	push   %rbp
  803d30:	48 89 e5             	mov    %rsp,%rbp
  803d33:	48 83 ec 10          	sub    $0x10,%rsp
  803d37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d3f:	48 89 c6             	mov    %rax,%rsi
  803d42:	bf 00 00 00 00       	mov    $0x0,%edi
  803d47:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  803d4e:	00 00 00 
  803d51:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803d53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d57:	48 89 c7             	mov    %rax,%rdi
  803d5a:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  803d61:	00 00 00 
  803d64:	ff d0                	callq  *%rax
  803d66:	48 89 c6             	mov    %rax,%rsi
  803d69:	bf 00 00 00 00       	mov    $0x0,%edi
  803d6e:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  803d75:	00 00 00 
  803d78:	ff d0                	callq  *%rax
}
  803d7a:	c9                   	leaveq 
  803d7b:	c3                   	retq   

0000000000803d7c <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803d7c:	55                   	push   %rbp
  803d7d:	48 89 e5             	mov    %rsp,%rbp
  803d80:	48 83 ec 20          	sub    $0x20,%rsp
  803d84:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803d87:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d8b:	75 35                	jne    803dc2 <wait+0x46>
  803d8d:	48 b9 1f 4d 80 00 00 	movabs $0x804d1f,%rcx
  803d94:	00 00 00 
  803d97:	48 ba 2a 4d 80 00 00 	movabs $0x804d2a,%rdx
  803d9e:	00 00 00 
  803da1:	be 09 00 00 00       	mov    $0x9,%esi
  803da6:	48 bf 3f 4d 80 00 00 	movabs $0x804d3f,%rdi
  803dad:	00 00 00 
  803db0:	b8 00 00 00 00       	mov    $0x0,%eax
  803db5:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  803dbc:	00 00 00 
  803dbf:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803dc2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dc5:	25 ff 03 00 00       	and    $0x3ff,%eax
  803dca:	48 98                	cltq   
  803dcc:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803dd3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803dda:	00 00 00 
  803ddd:	48 01 d0             	add    %rdx,%rax
  803de0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  803de4:	eb 0c                	jmp    803df2 <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  803de6:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803ded:	00 00 00 
  803df0:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  803df2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803df6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803dfc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803dff:	75 0e                	jne    803e0f <wait+0x93>
  803e01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e05:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803e0b:	85 c0                	test   %eax,%eax
  803e0d:	75 d7                	jne    803de6 <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  803e0f:	c9                   	leaveq 
  803e10:	c3                   	retq   

0000000000803e11 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803e11:	55                   	push   %rbp
  803e12:	48 89 e5             	mov    %rsp,%rbp
  803e15:	48 83 ec 20          	sub    $0x20,%rsp
  803e19:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803e1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e1f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803e22:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803e26:	be 01 00 00 00       	mov    $0x1,%esi
  803e2b:	48 89 c7             	mov    %rax,%rdi
  803e2e:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803e35:	00 00 00 
  803e38:	ff d0                	callq  *%rax
}
  803e3a:	c9                   	leaveq 
  803e3b:	c3                   	retq   

0000000000803e3c <getchar>:

int
getchar(void)
{
  803e3c:	55                   	push   %rbp
  803e3d:	48 89 e5             	mov    %rsp,%rbp
  803e40:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e44:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803e48:	ba 01 00 00 00       	mov    $0x1,%edx
  803e4d:	48 89 c6             	mov    %rax,%rsi
  803e50:	bf 00 00 00 00       	mov    $0x0,%edi
  803e55:	48 b8 fa 2c 80 00 00 	movabs $0x802cfa,%rax
  803e5c:	00 00 00 
  803e5f:	ff d0                	callq  *%rax
  803e61:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e68:	79 05                	jns    803e6f <getchar+0x33>
		return r;
  803e6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e6d:	eb 14                	jmp    803e83 <getchar+0x47>
	if (r < 1)
  803e6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e73:	7f 07                	jg     803e7c <getchar+0x40>
		return -E_EOF;
  803e75:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e7a:	eb 07                	jmp    803e83 <getchar+0x47>
	return c;
  803e7c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e80:	0f b6 c0             	movzbl %al,%eax
}
  803e83:	c9                   	leaveq 
  803e84:	c3                   	retq   

0000000000803e85 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e85:	55                   	push   %rbp
  803e86:	48 89 e5             	mov    %rsp,%rbp
  803e89:	48 83 ec 20          	sub    $0x20,%rsp
  803e8d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e90:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e97:	48 89 d6             	mov    %rdx,%rsi
  803e9a:	89 c7                	mov    %eax,%edi
  803e9c:	48 b8 c8 28 80 00 00 	movabs $0x8028c8,%rax
  803ea3:	00 00 00 
  803ea6:	ff d0                	callq  *%rax
  803ea8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eaf:	79 05                	jns    803eb6 <iscons+0x31>
		return r;
  803eb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eb4:	eb 1a                	jmp    803ed0 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803eb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eba:	8b 10                	mov    (%rax),%edx
  803ebc:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803ec3:	00 00 00 
  803ec6:	8b 00                	mov    (%rax),%eax
  803ec8:	39 c2                	cmp    %eax,%edx
  803eca:	0f 94 c0             	sete   %al
  803ecd:	0f b6 c0             	movzbl %al,%eax
}
  803ed0:	c9                   	leaveq 
  803ed1:	c3                   	retq   

0000000000803ed2 <opencons>:

int
opencons(void)
{
  803ed2:	55                   	push   %rbp
  803ed3:	48 89 e5             	mov    %rsp,%rbp
  803ed6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803eda:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ede:	48 89 c7             	mov    %rax,%rdi
  803ee1:	48 b8 30 28 80 00 00 	movabs $0x802830,%rax
  803ee8:	00 00 00 
  803eeb:	ff d0                	callq  *%rax
  803eed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ef0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ef4:	79 05                	jns    803efb <opencons+0x29>
		return r;
  803ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef9:	eb 5b                	jmp    803f56 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803efb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eff:	ba 07 04 00 00       	mov    $0x407,%edx
  803f04:	48 89 c6             	mov    %rax,%rsi
  803f07:	bf 00 00 00 00       	mov    $0x0,%edi
  803f0c:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  803f13:	00 00 00 
  803f16:	ff d0                	callq  *%rax
  803f18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f1f:	79 05                	jns    803f26 <opencons+0x54>
		return r;
  803f21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f24:	eb 30                	jmp    803f56 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803f26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f2a:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803f31:	00 00 00 
  803f34:	8b 12                	mov    (%rdx),%edx
  803f36:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803f38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f3c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803f43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f47:	48 89 c7             	mov    %rax,%rdi
  803f4a:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  803f51:	00 00 00 
  803f54:	ff d0                	callq  *%rax
}
  803f56:	c9                   	leaveq 
  803f57:	c3                   	retq   

0000000000803f58 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f58:	55                   	push   %rbp
  803f59:	48 89 e5             	mov    %rsp,%rbp
  803f5c:	48 83 ec 30          	sub    $0x30,%rsp
  803f60:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f64:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f68:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f6c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f71:	75 07                	jne    803f7a <devcons_read+0x22>
		return 0;
  803f73:	b8 00 00 00 00       	mov    $0x0,%eax
  803f78:	eb 4b                	jmp    803fc5 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803f7a:	eb 0c                	jmp    803f88 <devcons_read+0x30>
		sys_yield();
  803f7c:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803f83:	00 00 00 
  803f86:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803f88:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  803f8f:	00 00 00 
  803f92:	ff d0                	callq  *%rax
  803f94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f9b:	74 df                	je     803f7c <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803f9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fa1:	79 05                	jns    803fa8 <devcons_read+0x50>
		return c;
  803fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa6:	eb 1d                	jmp    803fc5 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803fa8:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803fac:	75 07                	jne    803fb5 <devcons_read+0x5d>
		return 0;
  803fae:	b8 00 00 00 00       	mov    $0x0,%eax
  803fb3:	eb 10                	jmp    803fc5 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803fb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb8:	89 c2                	mov    %eax,%edx
  803fba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fbe:	88 10                	mov    %dl,(%rax)
	return 1;
  803fc0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803fc5:	c9                   	leaveq 
  803fc6:	c3                   	retq   

0000000000803fc7 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803fc7:	55                   	push   %rbp
  803fc8:	48 89 e5             	mov    %rsp,%rbp
  803fcb:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803fd2:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803fd9:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803fe0:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803fe7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fee:	eb 76                	jmp    804066 <devcons_write+0x9f>
		m = n - tot;
  803ff0:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803ff7:	89 c2                	mov    %eax,%edx
  803ff9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ffc:	29 c2                	sub    %eax,%edx
  803ffe:	89 d0                	mov    %edx,%eax
  804000:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804003:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804006:	83 f8 7f             	cmp    $0x7f,%eax
  804009:	76 07                	jbe    804012 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80400b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804012:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804015:	48 63 d0             	movslq %eax,%rdx
  804018:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80401b:	48 63 c8             	movslq %eax,%rcx
  80401e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804025:	48 01 c1             	add    %rax,%rcx
  804028:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80402f:	48 89 ce             	mov    %rcx,%rsi
  804032:	48 89 c7             	mov    %rax,%rdi
  804035:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  80403c:	00 00 00 
  80403f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804041:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804044:	48 63 d0             	movslq %eax,%rdx
  804047:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80404e:	48 89 d6             	mov    %rdx,%rsi
  804051:	48 89 c7             	mov    %rax,%rdi
  804054:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  80405b:	00 00 00 
  80405e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804060:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804063:	01 45 fc             	add    %eax,-0x4(%rbp)
  804066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804069:	48 98                	cltq   
  80406b:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804072:	0f 82 78 ff ff ff    	jb     803ff0 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804078:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80407b:	c9                   	leaveq 
  80407c:	c3                   	retq   

000000000080407d <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80407d:	55                   	push   %rbp
  80407e:	48 89 e5             	mov    %rsp,%rbp
  804081:	48 83 ec 08          	sub    $0x8,%rsp
  804085:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804089:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80408e:	c9                   	leaveq 
  80408f:	c3                   	retq   

0000000000804090 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804090:	55                   	push   %rbp
  804091:	48 89 e5             	mov    %rsp,%rbp
  804094:	48 83 ec 10          	sub    $0x10,%rsp
  804098:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80409c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8040a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a4:	48 be 4f 4d 80 00 00 	movabs $0x804d4f,%rsi
  8040ab:	00 00 00 
  8040ae:	48 89 c7             	mov    %rax,%rdi
  8040b1:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  8040b8:	00 00 00 
  8040bb:	ff d0                	callq  *%rax
	return 0;
  8040bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040c2:	c9                   	leaveq 
  8040c3:	c3                   	retq   

00000000008040c4 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8040c4:	55                   	push   %rbp
  8040c5:	48 89 e5             	mov    %rsp,%rbp
  8040c8:	48 83 ec 10          	sub    $0x10,%rsp
  8040cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8040d0:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8040d7:	00 00 00 
  8040da:	48 8b 00             	mov    (%rax),%rax
  8040dd:	48 85 c0             	test   %rax,%rax
  8040e0:	0f 85 84 00 00 00    	jne    80416a <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8040e6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8040ed:	00 00 00 
  8040f0:	48 8b 00             	mov    (%rax),%rax
  8040f3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8040f9:	ba 07 00 00 00       	mov    $0x7,%edx
  8040fe:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804103:	89 c7                	mov    %eax,%edi
  804105:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  80410c:	00 00 00 
  80410f:	ff d0                	callq  *%rax
  804111:	85 c0                	test   %eax,%eax
  804113:	79 2a                	jns    80413f <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804115:	48 ba 58 4d 80 00 00 	movabs $0x804d58,%rdx
  80411c:	00 00 00 
  80411f:	be 23 00 00 00       	mov    $0x23,%esi
  804124:	48 bf 7f 4d 80 00 00 	movabs $0x804d7f,%rdi
  80412b:	00 00 00 
  80412e:	b8 00 00 00 00       	mov    $0x0,%eax
  804133:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80413a:	00 00 00 
  80413d:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  80413f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804146:	00 00 00 
  804149:	48 8b 00             	mov    (%rax),%rax
  80414c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804152:	48 be 7d 41 80 00 00 	movabs $0x80417d,%rsi
  804159:	00 00 00 
  80415c:	89 c7                	mov    %eax,%edi
  80415e:	48 b8 8c 1e 80 00 00 	movabs $0x801e8c,%rax
  804165:	00 00 00 
  804168:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  80416a:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804171:	00 00 00 
  804174:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804178:	48 89 10             	mov    %rdx,(%rax)
}
  80417b:	c9                   	leaveq 
  80417c:	c3                   	retq   

000000000080417d <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80417d:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804180:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  804187:	00 00 00 
call *%rax
  80418a:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  80418c:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804193:	00 
movq 152(%rsp), %rcx  //Load RSP
  804194:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80419b:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  80419c:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  8041a0:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  8041a3:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8041aa:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  8041ab:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  8041af:	4c 8b 3c 24          	mov    (%rsp),%r15
  8041b3:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8041b8:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8041bd:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8041c2:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8041c7:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8041cc:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8041d1:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8041d6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8041db:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8041e0:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8041e5:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8041ea:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8041ef:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8041f4:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8041f9:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  8041fd:	48 83 c4 08          	add    $0x8,%rsp
popfq
  804201:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  804202:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  804203:	c3                   	retq   

0000000000804204 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804204:	55                   	push   %rbp
  804205:	48 89 e5             	mov    %rsp,%rbp
  804208:	48 83 ec 30          	sub    $0x30,%rsp
  80420c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804210:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804214:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804218:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80421f:	00 00 00 
  804222:	48 8b 00             	mov    (%rax),%rax
  804225:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80422b:	85 c0                	test   %eax,%eax
  80422d:	75 34                	jne    804263 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80422f:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  804236:	00 00 00 
  804239:	ff d0                	callq  *%rax
  80423b:	25 ff 03 00 00       	and    $0x3ff,%eax
  804240:	48 98                	cltq   
  804242:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804249:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804250:	00 00 00 
  804253:	48 01 c2             	add    %rax,%rdx
  804256:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80425d:	00 00 00 
  804260:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804263:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804268:	75 0e                	jne    804278 <ipc_recv+0x74>
		pg = (void*) UTOP;
  80426a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804271:	00 00 00 
  804274:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804278:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80427c:	48 89 c7             	mov    %rax,%rdi
  80427f:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  804286:	00 00 00 
  804289:	ff d0                	callq  *%rax
  80428b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80428e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804292:	79 19                	jns    8042ad <ipc_recv+0xa9>
		*from_env_store = 0;
  804294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804298:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80429e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042a2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8042a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042ab:	eb 53                	jmp    804300 <ipc_recv+0xfc>
	}
	if(from_env_store)
  8042ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042b2:	74 19                	je     8042cd <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8042b4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8042bb:	00 00 00 
  8042be:	48 8b 00             	mov    (%rax),%rax
  8042c1:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8042c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042cb:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8042cd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042d2:	74 19                	je     8042ed <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8042d4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8042db:	00 00 00 
  8042de:	48 8b 00             	mov    (%rax),%rax
  8042e1:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8042e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042eb:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8042ed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8042f4:	00 00 00 
  8042f7:	48 8b 00             	mov    (%rax),%rax
  8042fa:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804300:	c9                   	leaveq 
  804301:	c3                   	retq   

0000000000804302 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804302:	55                   	push   %rbp
  804303:	48 89 e5             	mov    %rsp,%rbp
  804306:	48 83 ec 30          	sub    $0x30,%rsp
  80430a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80430d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804310:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804314:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804317:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80431c:	75 0e                	jne    80432c <ipc_send+0x2a>
		pg = (void*)UTOP;
  80431e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804325:	00 00 00 
  804328:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80432c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80432f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804332:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804336:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804339:	89 c7                	mov    %eax,%edi
  80433b:	48 b8 d6 1e 80 00 00 	movabs $0x801ed6,%rax
  804342:	00 00 00 
  804345:	ff d0                	callq  *%rax
  804347:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80434a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80434e:	75 0c                	jne    80435c <ipc_send+0x5a>
			sys_yield();
  804350:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  804357:	00 00 00 
  80435a:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80435c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804360:	74 ca                	je     80432c <ipc_send+0x2a>
	if(result != 0)
  804362:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804366:	74 20                	je     804388 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  804368:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80436b:	89 c6                	mov    %eax,%esi
  80436d:	48 bf 8d 4d 80 00 00 	movabs $0x804d8d,%rdi
  804374:	00 00 00 
  804377:	b8 00 00 00 00       	mov    $0x0,%eax
  80437c:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  804383:	00 00 00 
  804386:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  804388:	c9                   	leaveq 
  804389:	c3                   	retq   

000000000080438a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80438a:	55                   	push   %rbp
  80438b:	48 89 e5             	mov    %rsp,%rbp
  80438e:	48 83 ec 14          	sub    $0x14,%rsp
  804392:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804395:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80439c:	eb 4e                	jmp    8043ec <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80439e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8043a5:	00 00 00 
  8043a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ab:	48 98                	cltq   
  8043ad:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8043b4:	48 01 d0             	add    %rdx,%rax
  8043b7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8043bd:	8b 00                	mov    (%rax),%eax
  8043bf:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8043c2:	75 24                	jne    8043e8 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8043c4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8043cb:	00 00 00 
  8043ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043d1:	48 98                	cltq   
  8043d3:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8043da:	48 01 d0             	add    %rdx,%rax
  8043dd:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8043e3:	8b 40 08             	mov    0x8(%rax),%eax
  8043e6:	eb 12                	jmp    8043fa <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8043e8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8043ec:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8043f3:	7e a9                	jle    80439e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8043f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043fa:	c9                   	leaveq 
  8043fb:	c3                   	retq   

00000000008043fc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8043fc:	55                   	push   %rbp
  8043fd:	48 89 e5             	mov    %rsp,%rbp
  804400:	48 83 ec 18          	sub    $0x18,%rsp
  804404:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804408:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80440c:	48 c1 e8 15          	shr    $0x15,%rax
  804410:	48 89 c2             	mov    %rax,%rdx
  804413:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80441a:	01 00 00 
  80441d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804421:	83 e0 01             	and    $0x1,%eax
  804424:	48 85 c0             	test   %rax,%rax
  804427:	75 07                	jne    804430 <pageref+0x34>
		return 0;
  804429:	b8 00 00 00 00       	mov    $0x0,%eax
  80442e:	eb 53                	jmp    804483 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804434:	48 c1 e8 0c          	shr    $0xc,%rax
  804438:	48 89 c2             	mov    %rax,%rdx
  80443b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804442:	01 00 00 
  804445:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804449:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80444d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804451:	83 e0 01             	and    $0x1,%eax
  804454:	48 85 c0             	test   %rax,%rax
  804457:	75 07                	jne    804460 <pageref+0x64>
		return 0;
  804459:	b8 00 00 00 00       	mov    $0x0,%eax
  80445e:	eb 23                	jmp    804483 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804460:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804464:	48 c1 e8 0c          	shr    $0xc,%rax
  804468:	48 89 c2             	mov    %rax,%rdx
  80446b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804472:	00 00 00 
  804475:	48 c1 e2 04          	shl    $0x4,%rdx
  804479:	48 01 d0             	add    %rdx,%rax
  80447c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804480:	0f b7 c0             	movzwl %ax,%eax
}
  804483:	c9                   	leaveq 
  804484:	c3                   	retq   
