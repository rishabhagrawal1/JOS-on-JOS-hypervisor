
vmm/guest/obj/user/testpipe:     file format elf64-x86-64


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
  800066:	48 bb 24 47 80 00 00 	movabs $0x804724,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	if ((i = pipe(p)) < 0)
  800073:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 b5 36 80 00 00 	movabs $0x8036b5,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
  800089:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80008c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800090:	79 30                	jns    8000c2 <umain+0x7f>
		panic("pipe: %e", i);
  800092:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800095:	89 c1                	mov    %eax,%ecx
  800097:	48 ba 30 47 80 00 00 	movabs $0x804730,%rdx
  80009e:	00 00 00 
  8000a1:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a6:	48 bf 39 47 80 00 00 	movabs $0x804739,%rdi
  8000ad:	00 00 00 
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  8000bc:	00 00 00 
  8000bf:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000c2:	48 b8 3b 24 80 00 00 	movabs $0x80243b,%rax
  8000c9:	00 00 00 
  8000cc:	ff d0                	callq  *%rax
  8000ce:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8000d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8000d5:	79 30                	jns    800107 <umain+0xc4>
		panic("fork: %e", i);
  8000d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000da:	89 c1                	mov    %eax,%ecx
  8000dc:	48 ba 49 47 80 00 00 	movabs $0x804749,%rdx
  8000e3:	00 00 00 
  8000e6:	be 11 00 00 00       	mov    $0x11,%esi
  8000eb:	48 bf 39 47 80 00 00 	movabs $0x804739,%rdi
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
  80012c:	48 bf 52 47 80 00 00 	movabs $0x804752,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  800142:	00 00 00 
  800145:	ff d1                	callq  *%rcx
		close(p[1]);
  800147:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  80015b:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800161:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800168:	00 00 00 
  80016b:	48 8b 00             	mov    (%rax),%rax
  80016e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800174:	89 c6                	mov    %eax,%esi
  800176:	48 bf 6f 47 80 00 00 	movabs $0x80476f,%rdi
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
  8001a5:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  8001ac:	00 00 00 
  8001af:	ff d0                	callq  *%rax
  8001b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (i < 0)
  8001b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001b8:	79 30                	jns    8001ea <umain+0x1a7>
			panic("read: %e", i);
  8001ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bd:	89 c1                	mov    %eax,%ecx
  8001bf:	48 ba 8c 47 80 00 00 	movabs $0x80478c,%rdx
  8001c6:	00 00 00 
  8001c9:	be 19 00 00 00       	mov    $0x19,%esi
  8001ce:	48 bf 39 47 80 00 00 	movabs $0x804739,%rdi
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
  80021b:	48 bf 95 47 80 00 00 	movabs $0x804795,%rdi
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
  800241:	48 bf b1 47 80 00 00 	movabs $0x8047b1,%rdi
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
  800288:	48 bf 52 47 80 00 00 	movabs $0x804752,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  80029e:	00 00 00 
  8002a1:	ff d1                	callq  *%rcx
		close(p[0]);
  8002a3:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8002a9:	89 c7                	mov    %eax,%edi
  8002ab:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  8002b2:	00 00 00 
  8002b5:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002b7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  8002bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002c4:	00 00 00 
  8002c7:	48 8b 00             	mov    (%rax),%rax
  8002ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002d0:	89 c6                	mov    %eax,%esi
  8002d2:	48 bf c4 47 80 00 00 	movabs $0x8047c4,%rdi
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
  800324:	48 b8 46 2d 80 00 00 	movabs $0x802d46,%rax
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
  800359:	48 ba e1 47 80 00 00 	movabs $0x8047e1,%rdx
  800360:	00 00 00 
  800363:	be 25 00 00 00       	mov    $0x25,%esi
  800368:	48 bf 39 47 80 00 00 	movabs $0x804739,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  80037e:	00 00 00 
  800381:	41 ff d0             	callq  *%r8
		close(p[1]);
  800384:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80038a:	89 c7                	mov    %eax,%edi
  80038c:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  800393:	00 00 00 
  800396:	ff d0                	callq  *%rax
	}
	wait(pid);
  800398:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80039b:	89 c7                	mov    %eax,%edi
  80039d:	48 b8 7e 3c 80 00 00 	movabs $0x803c7e,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  8003a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003b0:	00 00 00 
  8003b3:	48 bb eb 47 80 00 00 	movabs $0x8047eb,%rbx
  8003ba:	00 00 00 
  8003bd:	48 89 18             	mov    %rbx,(%rax)
	if ((i = pipe(p)) < 0)
  8003c0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003c7:	48 89 c7             	mov    %rax,%rdi
  8003ca:	48 b8 b5 36 80 00 00 	movabs $0x8036b5,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax
  8003d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8003d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003dd:	79 30                	jns    80040f <umain+0x3cc>
		panic("pipe: %e", i);
  8003df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003e2:	89 c1                	mov    %eax,%ecx
  8003e4:	48 ba 30 47 80 00 00 	movabs $0x804730,%rdx
  8003eb:	00 00 00 
  8003ee:	be 2c 00 00 00       	mov    $0x2c,%esi
  8003f3:	48 bf 39 47 80 00 00 	movabs $0x804739,%rdi
  8003fa:	00 00 00 
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  800409:	00 00 00 
  80040c:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  80040f:	48 b8 3b 24 80 00 00 	movabs $0x80243b,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
  80041b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80041e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800422:	79 30                	jns    800454 <umain+0x411>
		panic("fork: %e", i);
  800424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800427:	89 c1                	mov    %eax,%ecx
  800429:	48 ba 49 47 80 00 00 	movabs $0x804749,%rdx
  800430:	00 00 00 
  800433:	be 2f 00 00 00       	mov    $0x2f,%esi
  800438:	48 bf 39 47 80 00 00 	movabs $0x804739,%rdi
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
  800466:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
		while (1) {
			cprintf(".");
  800472:	48 bf f8 47 80 00 00 	movabs $0x8047f8,%rdi
  800479:	00 00 00 
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  800488:	00 00 00 
  80048b:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  80048d:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  800493:	ba 01 00 00 00       	mov    $0x1,%edx
  800498:	48 be fa 47 80 00 00 	movabs $0x8047fa,%rsi
  80049f:	00 00 00 
  8004a2:	89 c7                	mov    %eax,%edi
  8004a4:	48 b8 46 2d 80 00 00 	movabs $0x802d46,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
  8004b0:	83 f8 01             	cmp    $0x1,%eax
  8004b3:	74 2a                	je     8004df <umain+0x49c>
				break;
  8004b5:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  8004b6:	48 bf fc 47 80 00 00 	movabs $0x8047fc,%rdi
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
  8004e9:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  8004f0:	00 00 00 
  8004f3:	ff d0                	callq  *%rax
	close(p[1]);
  8004f5:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8004fb:	89 c7                	mov    %eax,%edi
  8004fd:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
	wait(pid);
  800509:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80050c:	89 c7                	mov    %eax,%edi
  80050e:	48 b8 7e 3c 80 00 00 	movabs $0x803c7e,%rax
  800515:	00 00 00 
  800518:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  80051a:	48 bf 19 48 80 00 00 	movabs $0x804819,%rdi
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
  8005c6:	48 b8 25 2a 80 00 00 	movabs $0x802a25,%rax
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
  80069f:	48 bf 38 48 80 00 00 	movabs $0x804838,%rdi
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
  8006db:	48 bf 5b 48 80 00 00 	movabs $0x80485b,%rdi
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
  80098a:	48 ba 50 4a 80 00 00 	movabs $0x804a50,%rdx
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
  800c82:	48 b8 78 4a 80 00 00 	movabs $0x804a78,%rax
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
  800dd5:	48 b8 a0 49 80 00 00 	movabs $0x8049a0,%rax
  800ddc:	00 00 00 
  800ddf:	48 63 d3             	movslq %ebx,%rdx
  800de2:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800de6:	4d 85 e4             	test   %r12,%r12
  800de9:	75 2e                	jne    800e19 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800deb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800def:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df3:	89 d9                	mov    %ebx,%ecx
  800df5:	48 ba 61 4a 80 00 00 	movabs $0x804a61,%rdx
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
  800e24:	48 ba 6a 4a 80 00 00 	movabs $0x804a6a,%rdx
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
  800e7e:	49 bc 6d 4a 80 00 00 	movabs $0x804a6d,%r12
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
  801b84:	48 ba 28 4d 80 00 00 	movabs $0x804d28,%rdx
  801b8b:	00 00 00 
  801b8e:	be 23 00 00 00       	mov    $0x23,%esi
  801b93:	48 bf 45 4d 80 00 00 	movabs $0x804d45,%rdi
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

0000000000802052 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802052:	55                   	push   %rbp
  802053:	48 89 e5             	mov    %rsp,%rbp
  802056:	48 83 ec 30          	sub    $0x30,%rsp
  80205a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  80205e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802062:	48 8b 00             	mov    (%rax),%rax
  802065:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802069:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80206d:	48 8b 40 08          	mov    0x8(%rax),%rax
  802071:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  802074:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802077:	83 e0 02             	and    $0x2,%eax
  80207a:	85 c0                	test   %eax,%eax
  80207c:	75 4d                	jne    8020cb <pgfault+0x79>
  80207e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802082:	48 c1 e8 0c          	shr    $0xc,%rax
  802086:	48 89 c2             	mov    %rax,%rdx
  802089:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802090:	01 00 00 
  802093:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802097:	25 00 08 00 00       	and    $0x800,%eax
  80209c:	48 85 c0             	test   %rax,%rax
  80209f:	74 2a                	je     8020cb <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  8020a1:	48 ba 58 4d 80 00 00 	movabs $0x804d58,%rdx
  8020a8:	00 00 00 
  8020ab:	be 23 00 00 00       	mov    $0x23,%esi
  8020b0:	48 bf 8d 4d 80 00 00 	movabs $0x804d8d,%rdi
  8020b7:	00 00 00 
  8020ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bf:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8020c6:	00 00 00 
  8020c9:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  8020cb:	ba 07 00 00 00       	mov    $0x7,%edx
  8020d0:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020da:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  8020e1:	00 00 00 
  8020e4:	ff d0                	callq  *%rax
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	0f 85 cd 00 00 00    	jne    8021bb <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  8020ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020f2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8020f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020fa:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802100:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802104:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802108:	ba 00 10 00 00       	mov    $0x1000,%edx
  80210d:	48 89 c6             	mov    %rax,%rsi
  802110:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802115:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  80211c:	00 00 00 
  80211f:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802121:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802125:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80212b:	48 89 c1             	mov    %rax,%rcx
  80212e:	ba 00 00 00 00       	mov    $0x0,%edx
  802133:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802138:	bf 00 00 00 00       	mov    $0x0,%edi
  80213d:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  802144:	00 00 00 
  802147:	ff d0                	callq  *%rax
  802149:	85 c0                	test   %eax,%eax
  80214b:	79 2a                	jns    802177 <pgfault+0x125>
				panic("Page map at temp address failed");
  80214d:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  802154:	00 00 00 
  802157:	be 30 00 00 00       	mov    $0x30,%esi
  80215c:	48 bf 8d 4d 80 00 00 	movabs $0x804d8d,%rdi
  802163:	00 00 00 
  802166:	b8 00 00 00 00       	mov    $0x0,%eax
  80216b:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  802172:	00 00 00 
  802175:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802177:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80217c:	bf 00 00 00 00       	mov    $0x0,%edi
  802181:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802188:	00 00 00 
  80218b:	ff d0                	callq  *%rax
  80218d:	85 c0                	test   %eax,%eax
  80218f:	79 54                	jns    8021e5 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802191:	48 ba b8 4d 80 00 00 	movabs $0x804db8,%rdx
  802198:	00 00 00 
  80219b:	be 32 00 00 00       	mov    $0x32,%esi
  8021a0:	48 bf 8d 4d 80 00 00 	movabs $0x804d8d,%rdi
  8021a7:	00 00 00 
  8021aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021af:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8021b6:	00 00 00 
  8021b9:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  8021bb:	48 ba e0 4d 80 00 00 	movabs $0x804de0,%rdx
  8021c2:	00 00 00 
  8021c5:	be 34 00 00 00       	mov    $0x34,%esi
  8021ca:	48 bf 8d 4d 80 00 00 	movabs $0x804d8d,%rdi
  8021d1:	00 00 00 
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d9:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8021e0:	00 00 00 
  8021e3:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8021e5:	c9                   	leaveq 
  8021e6:	c3                   	retq   

00000000008021e7 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8021e7:	55                   	push   %rbp
  8021e8:	48 89 e5             	mov    %rsp,%rbp
  8021eb:	48 83 ec 20          	sub    $0x20,%rsp
  8021ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021f2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8021f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021fc:	01 00 00 
  8021ff:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802202:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802206:	25 07 0e 00 00       	and    $0xe07,%eax
  80220b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  80220e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802211:	48 c1 e0 0c          	shl    $0xc,%rax
  802215:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802219:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221c:	25 00 04 00 00       	and    $0x400,%eax
  802221:	85 c0                	test   %eax,%eax
  802223:	74 57                	je     80227c <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802225:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802228:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80222c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80222f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802233:	41 89 f0             	mov    %esi,%r8d
  802236:	48 89 c6             	mov    %rax,%rsi
  802239:	bf 00 00 00 00       	mov    $0x0,%edi
  80223e:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  802245:	00 00 00 
  802248:	ff d0                	callq  *%rax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	0f 8e 52 01 00 00    	jle    8023a4 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802252:	48 ba 12 4e 80 00 00 	movabs $0x804e12,%rdx
  802259:	00 00 00 
  80225c:	be 4e 00 00 00       	mov    $0x4e,%esi
  802261:	48 bf 8d 4d 80 00 00 	movabs $0x804d8d,%rdi
  802268:	00 00 00 
  80226b:	b8 00 00 00 00       	mov    $0x0,%eax
  802270:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  802277:	00 00 00 
  80227a:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  80227c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80227f:	83 e0 02             	and    $0x2,%eax
  802282:	85 c0                	test   %eax,%eax
  802284:	75 10                	jne    802296 <duppage+0xaf>
  802286:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802289:	25 00 08 00 00       	and    $0x800,%eax
  80228e:	85 c0                	test   %eax,%eax
  802290:	0f 84 bb 00 00 00    	je     802351 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802296:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802299:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  80229e:	80 cc 08             	or     $0x8,%ah
  8022a1:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8022a4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8022a7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8022ab:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b2:	41 89 f0             	mov    %esi,%r8d
  8022b5:	48 89 c6             	mov    %rax,%rsi
  8022b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8022bd:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  8022c4:	00 00 00 
  8022c7:	ff d0                	callq  *%rax
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	7e 2a                	jle    8022f7 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8022cd:	48 ba 12 4e 80 00 00 	movabs $0x804e12,%rdx
  8022d4:	00 00 00 
  8022d7:	be 55 00 00 00       	mov    $0x55,%esi
  8022dc:	48 bf 8d 4d 80 00 00 	movabs $0x804d8d,%rdi
  8022e3:	00 00 00 
  8022e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022eb:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8022f2:	00 00 00 
  8022f5:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8022f7:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8022fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802302:	41 89 c8             	mov    %ecx,%r8d
  802305:	48 89 d1             	mov    %rdx,%rcx
  802308:	ba 00 00 00 00       	mov    $0x0,%edx
  80230d:	48 89 c6             	mov    %rax,%rsi
  802310:	bf 00 00 00 00       	mov    $0x0,%edi
  802315:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  80231c:	00 00 00 
  80231f:	ff d0                	callq  *%rax
  802321:	85 c0                	test   %eax,%eax
  802323:	7e 2a                	jle    80234f <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802325:	48 ba 12 4e 80 00 00 	movabs $0x804e12,%rdx
  80232c:	00 00 00 
  80232f:	be 57 00 00 00       	mov    $0x57,%esi
  802334:	48 bf 8d 4d 80 00 00 	movabs $0x804d8d,%rdi
  80233b:	00 00 00 
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
  802343:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80234a:	00 00 00 
  80234d:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80234f:	eb 53                	jmp    8023a4 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802351:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802354:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802358:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80235b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235f:	41 89 f0             	mov    %esi,%r8d
  802362:	48 89 c6             	mov    %rax,%rsi
  802365:	bf 00 00 00 00       	mov    $0x0,%edi
  80236a:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  802371:	00 00 00 
  802374:	ff d0                	callq  *%rax
  802376:	85 c0                	test   %eax,%eax
  802378:	7e 2a                	jle    8023a4 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80237a:	48 ba 12 4e 80 00 00 	movabs $0x804e12,%rdx
  802381:	00 00 00 
  802384:	be 5b 00 00 00       	mov    $0x5b,%esi
  802389:	48 bf 8d 4d 80 00 00 	movabs $0x804d8d,%rdi
  802390:	00 00 00 
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
  802398:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80239f:	00 00 00 
  8023a2:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8023a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a9:	c9                   	leaveq 
  8023aa:	c3                   	retq   

00000000008023ab <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8023ab:	55                   	push   %rbp
  8023ac:	48 89 e5             	mov    %rsp,%rbp
  8023af:	48 83 ec 18          	sub    $0x18,%rsp
  8023b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8023b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8023bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c3:	48 c1 e8 27          	shr    $0x27,%rax
  8023c7:	48 89 c2             	mov    %rax,%rdx
  8023ca:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023d1:	01 00 00 
  8023d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023d8:	83 e0 01             	and    $0x1,%eax
  8023db:	48 85 c0             	test   %rax,%rax
  8023de:	74 51                	je     802431 <pt_is_mapped+0x86>
  8023e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e4:	48 c1 e0 0c          	shl    $0xc,%rax
  8023e8:	48 c1 e8 1e          	shr    $0x1e,%rax
  8023ec:	48 89 c2             	mov    %rax,%rdx
  8023ef:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023f6:	01 00 00 
  8023f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023fd:	83 e0 01             	and    $0x1,%eax
  802400:	48 85 c0             	test   %rax,%rax
  802403:	74 2c                	je     802431 <pt_is_mapped+0x86>
  802405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802409:	48 c1 e0 0c          	shl    $0xc,%rax
  80240d:	48 c1 e8 15          	shr    $0x15,%rax
  802411:	48 89 c2             	mov    %rax,%rdx
  802414:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80241b:	01 00 00 
  80241e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802422:	83 e0 01             	and    $0x1,%eax
  802425:	48 85 c0             	test   %rax,%rax
  802428:	74 07                	je     802431 <pt_is_mapped+0x86>
  80242a:	b8 01 00 00 00       	mov    $0x1,%eax
  80242f:	eb 05                	jmp    802436 <pt_is_mapped+0x8b>
  802431:	b8 00 00 00 00       	mov    $0x0,%eax
  802436:	83 e0 01             	and    $0x1,%eax
}
  802439:	c9                   	leaveq 
  80243a:	c3                   	retq   

000000000080243b <fork>:

envid_t
fork(void)
{
  80243b:	55                   	push   %rbp
  80243c:	48 89 e5             	mov    %rsp,%rbp
  80243f:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802443:	48 bf 52 20 80 00 00 	movabs $0x802052,%rdi
  80244a:	00 00 00 
  80244d:	48 b8 c6 3f 80 00 00 	movabs $0x803fc6,%rax
  802454:	00 00 00 
  802457:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802459:	b8 07 00 00 00       	mov    $0x7,%eax
  80245e:	cd 30                	int    $0x30
  802460:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802463:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802466:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802469:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80246d:	79 30                	jns    80249f <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80246f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802472:	89 c1                	mov    %eax,%ecx
  802474:	48 ba 30 4e 80 00 00 	movabs $0x804e30,%rdx
  80247b:	00 00 00 
  80247e:	be 86 00 00 00       	mov    $0x86,%esi
  802483:	48 bf 8d 4d 80 00 00 	movabs $0x804d8d,%rdi
  80248a:	00 00 00 
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
  802492:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  802499:	00 00 00 
  80249c:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80249f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8024a3:	75 3e                	jne    8024e3 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8024a5:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8024b6:	48 98                	cltq   
  8024b8:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8024bf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8024c6:	00 00 00 
  8024c9:	48 01 c2             	add    %rax,%rdx
  8024cc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024d3:	00 00 00 
  8024d6:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8024d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024de:	e9 d1 01 00 00       	jmpq   8026b4 <fork+0x279>
	}
	uint64_t ad = 0;
  8024e3:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8024ea:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8024eb:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8024f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8024f4:	e9 df 00 00 00       	jmpq   8025d8 <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8024f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024fd:	48 c1 e8 27          	shr    $0x27,%rax
  802501:	48 89 c2             	mov    %rax,%rdx
  802504:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80250b:	01 00 00 
  80250e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802512:	83 e0 01             	and    $0x1,%eax
  802515:	48 85 c0             	test   %rax,%rax
  802518:	0f 84 9e 00 00 00    	je     8025bc <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80251e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802522:	48 c1 e8 1e          	shr    $0x1e,%rax
  802526:	48 89 c2             	mov    %rax,%rdx
  802529:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802530:	01 00 00 
  802533:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802537:	83 e0 01             	and    $0x1,%eax
  80253a:	48 85 c0             	test   %rax,%rax
  80253d:	74 73                	je     8025b2 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  80253f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802543:	48 c1 e8 15          	shr    $0x15,%rax
  802547:	48 89 c2             	mov    %rax,%rdx
  80254a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802551:	01 00 00 
  802554:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802558:	83 e0 01             	and    $0x1,%eax
  80255b:	48 85 c0             	test   %rax,%rax
  80255e:	74 48                	je     8025a8 <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802560:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802564:	48 c1 e8 0c          	shr    $0xc,%rax
  802568:	48 89 c2             	mov    %rax,%rdx
  80256b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802572:	01 00 00 
  802575:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802579:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80257d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802581:	83 e0 01             	and    $0x1,%eax
  802584:	48 85 c0             	test   %rax,%rax
  802587:	74 47                	je     8025d0 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80258d:	48 c1 e8 0c          	shr    $0xc,%rax
  802591:	89 c2                	mov    %eax,%edx
  802593:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802596:	89 d6                	mov    %edx,%esi
  802598:	89 c7                	mov    %eax,%edi
  80259a:	48 b8 e7 21 80 00 00 	movabs $0x8021e7,%rax
  8025a1:	00 00 00 
  8025a4:	ff d0                	callq  *%rax
  8025a6:	eb 28                	jmp    8025d0 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8025a8:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8025af:	00 
  8025b0:	eb 1e                	jmp    8025d0 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8025b2:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8025b9:	40 
  8025ba:	eb 14                	jmp    8025d0 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8025bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c0:	48 c1 e8 27          	shr    $0x27,%rax
  8025c4:	48 83 c0 01          	add    $0x1,%rax
  8025c8:	48 c1 e0 27          	shl    $0x27,%rax
  8025cc:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8025d0:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8025d7:	00 
  8025d8:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8025df:	00 
  8025e0:	0f 87 13 ff ff ff    	ja     8024f9 <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8025e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025e9:	ba 07 00 00 00       	mov    $0x7,%edx
  8025ee:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8025f3:	89 c7                	mov    %eax,%edi
  8025f5:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  8025fc:	00 00 00 
  8025ff:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802601:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802604:	ba 07 00 00 00       	mov    $0x7,%edx
  802609:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80260e:	89 c7                	mov    %eax,%edi
  802610:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  802617:	00 00 00 
  80261a:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80261c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80261f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802625:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80262a:	ba 00 00 00 00       	mov    $0x0,%edx
  80262f:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802634:	89 c7                	mov    %eax,%edi
  802636:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  80263d:	00 00 00 
  802640:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802642:	ba 00 10 00 00       	mov    $0x1000,%edx
  802647:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80264c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802651:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  802658:	00 00 00 
  80265b:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80265d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802662:	bf 00 00 00 00       	mov    $0x0,%edi
  802667:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  80266e:	00 00 00 
  802671:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802673:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80267a:	00 00 00 
  80267d:	48 8b 00             	mov    (%rax),%rax
  802680:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802687:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80268a:	48 89 d6             	mov    %rdx,%rsi
  80268d:	89 c7                	mov    %eax,%edi
  80268f:	48 b8 8c 1e 80 00 00 	movabs $0x801e8c,%rax
  802696:	00 00 00 
  802699:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80269b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80269e:	be 02 00 00 00       	mov    $0x2,%esi
  8026a3:	89 c7                	mov    %eax,%edi
  8026a5:	48 b8 f7 1d 80 00 00 	movabs $0x801df7,%rax
  8026ac:	00 00 00 
  8026af:	ff d0                	callq  *%rax

	return envid;
  8026b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8026b4:	c9                   	leaveq 
  8026b5:	c3                   	retq   

00000000008026b6 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8026b6:	55                   	push   %rbp
  8026b7:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8026ba:	48 ba 48 4e 80 00 00 	movabs $0x804e48,%rdx
  8026c1:	00 00 00 
  8026c4:	be bf 00 00 00       	mov    $0xbf,%esi
  8026c9:	48 bf 8d 4d 80 00 00 	movabs $0x804d8d,%rdi
  8026d0:	00 00 00 
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d8:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8026df:	00 00 00 
  8026e2:	ff d1                	callq  *%rcx

00000000008026e4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8026e4:	55                   	push   %rbp
  8026e5:	48 89 e5             	mov    %rsp,%rbp
  8026e8:	48 83 ec 08          	sub    $0x8,%rsp
  8026ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026f4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026fb:	ff ff ff 
  8026fe:	48 01 d0             	add    %rdx,%rax
  802701:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802705:	c9                   	leaveq 
  802706:	c3                   	retq   

0000000000802707 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802707:	55                   	push   %rbp
  802708:	48 89 e5             	mov    %rsp,%rbp
  80270b:	48 83 ec 08          	sub    $0x8,%rsp
  80270f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802713:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802717:	48 89 c7             	mov    %rax,%rdi
  80271a:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  802721:	00 00 00 
  802724:	ff d0                	callq  *%rax
  802726:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80272c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802730:	c9                   	leaveq 
  802731:	c3                   	retq   

0000000000802732 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802732:	55                   	push   %rbp
  802733:	48 89 e5             	mov    %rsp,%rbp
  802736:	48 83 ec 18          	sub    $0x18,%rsp
  80273a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80273e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802745:	eb 6b                	jmp    8027b2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802747:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80274a:	48 98                	cltq   
  80274c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802752:	48 c1 e0 0c          	shl    $0xc,%rax
  802756:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80275a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275e:	48 c1 e8 15          	shr    $0x15,%rax
  802762:	48 89 c2             	mov    %rax,%rdx
  802765:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80276c:	01 00 00 
  80276f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802773:	83 e0 01             	and    $0x1,%eax
  802776:	48 85 c0             	test   %rax,%rax
  802779:	74 21                	je     80279c <fd_alloc+0x6a>
  80277b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80277f:	48 c1 e8 0c          	shr    $0xc,%rax
  802783:	48 89 c2             	mov    %rax,%rdx
  802786:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80278d:	01 00 00 
  802790:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802794:	83 e0 01             	and    $0x1,%eax
  802797:	48 85 c0             	test   %rax,%rax
  80279a:	75 12                	jne    8027ae <fd_alloc+0x7c>
			*fd_store = fd;
  80279c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027a4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ac:	eb 1a                	jmp    8027c8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027b2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027b6:	7e 8f                	jle    802747 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8027b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8027c3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027c8:	c9                   	leaveq 
  8027c9:	c3                   	retq   

00000000008027ca <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027ca:	55                   	push   %rbp
  8027cb:	48 89 e5             	mov    %rsp,%rbp
  8027ce:	48 83 ec 20          	sub    $0x20,%rsp
  8027d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027dd:	78 06                	js     8027e5 <fd_lookup+0x1b>
  8027df:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8027e3:	7e 07                	jle    8027ec <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027ea:	eb 6c                	jmp    802858 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8027ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027ef:	48 98                	cltq   
  8027f1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027f7:	48 c1 e0 0c          	shl    $0xc,%rax
  8027fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802803:	48 c1 e8 15          	shr    $0x15,%rax
  802807:	48 89 c2             	mov    %rax,%rdx
  80280a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802811:	01 00 00 
  802814:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802818:	83 e0 01             	and    $0x1,%eax
  80281b:	48 85 c0             	test   %rax,%rax
  80281e:	74 21                	je     802841 <fd_lookup+0x77>
  802820:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802824:	48 c1 e8 0c          	shr    $0xc,%rax
  802828:	48 89 c2             	mov    %rax,%rdx
  80282b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802832:	01 00 00 
  802835:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802839:	83 e0 01             	and    $0x1,%eax
  80283c:	48 85 c0             	test   %rax,%rax
  80283f:	75 07                	jne    802848 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802841:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802846:	eb 10                	jmp    802858 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802848:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802850:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802853:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802858:	c9                   	leaveq 
  802859:	c3                   	retq   

000000000080285a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80285a:	55                   	push   %rbp
  80285b:	48 89 e5             	mov    %rsp,%rbp
  80285e:	48 83 ec 30          	sub    $0x30,%rsp
  802862:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802866:	89 f0                	mov    %esi,%eax
  802868:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80286b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80286f:	48 89 c7             	mov    %rax,%rdi
  802872:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax
  80287e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802882:	48 89 d6             	mov    %rdx,%rsi
  802885:	89 c7                	mov    %eax,%edi
  802887:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  80288e:	00 00 00 
  802891:	ff d0                	callq  *%rax
  802893:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802896:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80289a:	78 0a                	js     8028a6 <fd_close+0x4c>
	    || fd != fd2)
  80289c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8028a4:	74 12                	je     8028b8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8028a6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8028aa:	74 05                	je     8028b1 <fd_close+0x57>
  8028ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028af:	eb 05                	jmp    8028b6 <fd_close+0x5c>
  8028b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b6:	eb 69                	jmp    802921 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8028b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028bc:	8b 00                	mov    (%rax),%eax
  8028be:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028c2:	48 89 d6             	mov    %rdx,%rsi
  8028c5:	89 c7                	mov    %eax,%edi
  8028c7:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  8028ce:	00 00 00 
  8028d1:	ff d0                	callq  *%rax
  8028d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028da:	78 2a                	js     802906 <fd_close+0xac>
		if (dev->dev_close)
  8028dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028e4:	48 85 c0             	test   %rax,%rax
  8028e7:	74 16                	je     8028ff <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8028e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ed:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028f1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028f5:	48 89 d7             	mov    %rdx,%rdi
  8028f8:	ff d0                	callq  *%rax
  8028fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fd:	eb 07                	jmp    802906 <fd_close+0xac>
		else
			r = 0;
  8028ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80290a:	48 89 c6             	mov    %rax,%rsi
  80290d:	bf 00 00 00 00       	mov    $0x0,%edi
  802912:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802919:	00 00 00 
  80291c:	ff d0                	callq  *%rax
	return r;
  80291e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802921:	c9                   	leaveq 
  802922:	c3                   	retq   

0000000000802923 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802923:	55                   	push   %rbp
  802924:	48 89 e5             	mov    %rsp,%rbp
  802927:	48 83 ec 20          	sub    $0x20,%rsp
  80292b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80292e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802932:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802939:	eb 41                	jmp    80297c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80293b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802942:	00 00 00 
  802945:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802948:	48 63 d2             	movslq %edx,%rdx
  80294b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294f:	8b 00                	mov    (%rax),%eax
  802951:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802954:	75 22                	jne    802978 <dev_lookup+0x55>
			*dev = devtab[i];
  802956:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80295d:	00 00 00 
  802960:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802963:	48 63 d2             	movslq %edx,%rdx
  802966:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80296a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80296e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802971:	b8 00 00 00 00       	mov    $0x0,%eax
  802976:	eb 60                	jmp    8029d8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802978:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80297c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802983:	00 00 00 
  802986:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802989:	48 63 d2             	movslq %edx,%rdx
  80298c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802990:	48 85 c0             	test   %rax,%rax
  802993:	75 a6                	jne    80293b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802995:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80299c:	00 00 00 
  80299f:	48 8b 00             	mov    (%rax),%rax
  8029a2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029a8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8029ab:	89 c6                	mov    %eax,%esi
  8029ad:	48 bf 60 4e 80 00 00 	movabs $0x804e60,%rdi
  8029b4:	00 00 00 
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bc:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  8029c3:	00 00 00 
  8029c6:	ff d1                	callq  *%rcx
	*dev = 0;
  8029c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029cc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8029d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8029d8:	c9                   	leaveq 
  8029d9:	c3                   	retq   

00000000008029da <close>:

int
close(int fdnum)
{
  8029da:	55                   	push   %rbp
  8029db:	48 89 e5             	mov    %rsp,%rbp
  8029de:	48 83 ec 20          	sub    $0x20,%rsp
  8029e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029e5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029ec:	48 89 d6             	mov    %rdx,%rsi
  8029ef:	89 c7                	mov    %eax,%edi
  8029f1:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  8029f8:	00 00 00 
  8029fb:	ff d0                	callq  *%rax
  8029fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a04:	79 05                	jns    802a0b <close+0x31>
		return r;
  802a06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a09:	eb 18                	jmp    802a23 <close+0x49>
	else
		return fd_close(fd, 1);
  802a0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0f:	be 01 00 00 00       	mov    $0x1,%esi
  802a14:	48 89 c7             	mov    %rax,%rdi
  802a17:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  802a1e:	00 00 00 
  802a21:	ff d0                	callq  *%rax
}
  802a23:	c9                   	leaveq 
  802a24:	c3                   	retq   

0000000000802a25 <close_all>:

void
close_all(void)
{
  802a25:	55                   	push   %rbp
  802a26:	48 89 e5             	mov    %rsp,%rbp
  802a29:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a34:	eb 15                	jmp    802a4b <close_all+0x26>
		close(i);
  802a36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a39:	89 c7                	mov    %eax,%edi
  802a3b:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  802a42:	00 00 00 
  802a45:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a47:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a4b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a4f:	7e e5                	jle    802a36 <close_all+0x11>
		close(i);
}
  802a51:	c9                   	leaveq 
  802a52:	c3                   	retq   

0000000000802a53 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a53:	55                   	push   %rbp
  802a54:	48 89 e5             	mov    %rsp,%rbp
  802a57:	48 83 ec 40          	sub    $0x40,%rsp
  802a5b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a5e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a61:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a65:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a68:	48 89 d6             	mov    %rdx,%rsi
  802a6b:	89 c7                	mov    %eax,%edi
  802a6d:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802a74:	00 00 00 
  802a77:	ff d0                	callq  *%rax
  802a79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a80:	79 08                	jns    802a8a <dup+0x37>
		return r;
  802a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a85:	e9 70 01 00 00       	jmpq   802bfa <dup+0x1a7>
	close(newfdnum);
  802a8a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a8d:	89 c7                	mov    %eax,%edi
  802a8f:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  802a96:	00 00 00 
  802a99:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a9b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a9e:	48 98                	cltq   
  802aa0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802aa6:	48 c1 e0 0c          	shl    $0xc,%rax
  802aaa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802aae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ab2:	48 89 c7             	mov    %rax,%rdi
  802ab5:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  802abc:	00 00 00 
  802abf:	ff d0                	callq  *%rax
  802ac1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802ac5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac9:	48 89 c7             	mov    %rax,%rdi
  802acc:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
  802ad8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802adc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae0:	48 c1 e8 15          	shr    $0x15,%rax
  802ae4:	48 89 c2             	mov    %rax,%rdx
  802ae7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802aee:	01 00 00 
  802af1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802af5:	83 e0 01             	and    $0x1,%eax
  802af8:	48 85 c0             	test   %rax,%rax
  802afb:	74 73                	je     802b70 <dup+0x11d>
  802afd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b01:	48 c1 e8 0c          	shr    $0xc,%rax
  802b05:	48 89 c2             	mov    %rax,%rdx
  802b08:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b0f:	01 00 00 
  802b12:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b16:	83 e0 01             	and    $0x1,%eax
  802b19:	48 85 c0             	test   %rax,%rax
  802b1c:	74 52                	je     802b70 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802b1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b22:	48 c1 e8 0c          	shr    $0xc,%rax
  802b26:	48 89 c2             	mov    %rax,%rdx
  802b29:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b30:	01 00 00 
  802b33:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b37:	25 07 0e 00 00       	and    $0xe07,%eax
  802b3c:	89 c1                	mov    %eax,%ecx
  802b3e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b46:	41 89 c8             	mov    %ecx,%r8d
  802b49:	48 89 d1             	mov    %rdx,%rcx
  802b4c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b51:	48 89 c6             	mov    %rax,%rsi
  802b54:	bf 00 00 00 00       	mov    $0x0,%edi
  802b59:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  802b60:	00 00 00 
  802b63:	ff d0                	callq  *%rax
  802b65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6c:	79 02                	jns    802b70 <dup+0x11d>
			goto err;
  802b6e:	eb 57                	jmp    802bc7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b74:	48 c1 e8 0c          	shr    $0xc,%rax
  802b78:	48 89 c2             	mov    %rax,%rdx
  802b7b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b82:	01 00 00 
  802b85:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b89:	25 07 0e 00 00       	and    $0xe07,%eax
  802b8e:	89 c1                	mov    %eax,%ecx
  802b90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b98:	41 89 c8             	mov    %ecx,%r8d
  802b9b:	48 89 d1             	mov    %rdx,%rcx
  802b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba3:	48 89 c6             	mov    %rax,%rsi
  802ba6:	bf 00 00 00 00       	mov    $0x0,%edi
  802bab:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  802bb2:	00 00 00 
  802bb5:	ff d0                	callq  *%rax
  802bb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbe:	79 02                	jns    802bc2 <dup+0x16f>
		goto err;
  802bc0:	eb 05                	jmp    802bc7 <dup+0x174>

	return newfdnum;
  802bc2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bc5:	eb 33                	jmp    802bfa <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802bc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcb:	48 89 c6             	mov    %rax,%rsi
  802bce:	bf 00 00 00 00       	mov    $0x0,%edi
  802bd3:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802bda:	00 00 00 
  802bdd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802bdf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802be3:	48 89 c6             	mov    %rax,%rsi
  802be6:	bf 00 00 00 00       	mov    $0x0,%edi
  802beb:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802bf2:	00 00 00 
  802bf5:	ff d0                	callq  *%rax
	return r;
  802bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bfa:	c9                   	leaveq 
  802bfb:	c3                   	retq   

0000000000802bfc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bfc:	55                   	push   %rbp
  802bfd:	48 89 e5             	mov    %rsp,%rbp
  802c00:	48 83 ec 40          	sub    $0x40,%rsp
  802c04:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c07:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c0b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c0f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c13:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c16:	48 89 d6             	mov    %rdx,%rsi
  802c19:	89 c7                	mov    %eax,%edi
  802c1b:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802c22:	00 00 00 
  802c25:	ff d0                	callq  *%rax
  802c27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2e:	78 24                	js     802c54 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c34:	8b 00                	mov    (%rax),%eax
  802c36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c3a:	48 89 d6             	mov    %rdx,%rsi
  802c3d:	89 c7                	mov    %eax,%edi
  802c3f:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	callq  *%rax
  802c4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c52:	79 05                	jns    802c59 <read+0x5d>
		return r;
  802c54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c57:	eb 76                	jmp    802ccf <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5d:	8b 40 08             	mov    0x8(%rax),%eax
  802c60:	83 e0 03             	and    $0x3,%eax
  802c63:	83 f8 01             	cmp    $0x1,%eax
  802c66:	75 3a                	jne    802ca2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c68:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c6f:	00 00 00 
  802c72:	48 8b 00             	mov    (%rax),%rax
  802c75:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c7b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c7e:	89 c6                	mov    %eax,%esi
  802c80:	48 bf 7f 4e 80 00 00 	movabs $0x804e7f,%rdi
  802c87:	00 00 00 
  802c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8f:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  802c96:	00 00 00 
  802c99:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ca0:	eb 2d                	jmp    802ccf <read+0xd3>
	}
	if (!dev->dev_read)
  802ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca6:	48 8b 40 10          	mov    0x10(%rax),%rax
  802caa:	48 85 c0             	test   %rax,%rax
  802cad:	75 07                	jne    802cb6 <read+0xba>
		return -E_NOT_SUPP;
  802caf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cb4:	eb 19                	jmp    802ccf <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802cb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cba:	48 8b 40 10          	mov    0x10(%rax),%rax
  802cbe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cc2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cc6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cca:	48 89 cf             	mov    %rcx,%rdi
  802ccd:	ff d0                	callq  *%rax
}
  802ccf:	c9                   	leaveq 
  802cd0:	c3                   	retq   

0000000000802cd1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802cd1:	55                   	push   %rbp
  802cd2:	48 89 e5             	mov    %rsp,%rbp
  802cd5:	48 83 ec 30          	sub    $0x30,%rsp
  802cd9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cdc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ce0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ce4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ceb:	eb 49                	jmp    802d36 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf0:	48 98                	cltq   
  802cf2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cf6:	48 29 c2             	sub    %rax,%rdx
  802cf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfc:	48 63 c8             	movslq %eax,%rcx
  802cff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d03:	48 01 c1             	add    %rax,%rcx
  802d06:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d09:	48 89 ce             	mov    %rcx,%rsi
  802d0c:	89 c7                	mov    %eax,%edi
  802d0e:	48 b8 fc 2b 80 00 00 	movabs $0x802bfc,%rax
  802d15:	00 00 00 
  802d18:	ff d0                	callq  *%rax
  802d1a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802d1d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d21:	79 05                	jns    802d28 <readn+0x57>
			return m;
  802d23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d26:	eb 1c                	jmp    802d44 <readn+0x73>
		if (m == 0)
  802d28:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d2c:	75 02                	jne    802d30 <readn+0x5f>
			break;
  802d2e:	eb 11                	jmp    802d41 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d33:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d39:	48 98                	cltq   
  802d3b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d3f:	72 ac                	jb     802ced <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802d41:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d44:	c9                   	leaveq 
  802d45:	c3                   	retq   

0000000000802d46 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d46:	55                   	push   %rbp
  802d47:	48 89 e5             	mov    %rsp,%rbp
  802d4a:	48 83 ec 40          	sub    $0x40,%rsp
  802d4e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d51:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d55:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d59:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d5d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d60:	48 89 d6             	mov    %rdx,%rsi
  802d63:	89 c7                	mov    %eax,%edi
  802d65:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802d6c:	00 00 00 
  802d6f:	ff d0                	callq  *%rax
  802d71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d78:	78 24                	js     802d9e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7e:	8b 00                	mov    (%rax),%eax
  802d80:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d84:	48 89 d6             	mov    %rdx,%rsi
  802d87:	89 c7                	mov    %eax,%edi
  802d89:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802d90:	00 00 00 
  802d93:	ff d0                	callq  *%rax
  802d95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d9c:	79 05                	jns    802da3 <write+0x5d>
		return r;
  802d9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da1:	eb 42                	jmp    802de5 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802da3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da7:	8b 40 08             	mov    0x8(%rax),%eax
  802daa:	83 e0 03             	and    $0x3,%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	75 07                	jne    802db8 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802db1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802db6:	eb 2d                	jmp    802de5 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802db8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbc:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dc0:	48 85 c0             	test   %rax,%rax
  802dc3:	75 07                	jne    802dcc <write+0x86>
		return -E_NOT_SUPP;
  802dc5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dca:	eb 19                	jmp    802de5 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802dcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd0:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dd4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802dd8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ddc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802de0:	48 89 cf             	mov    %rcx,%rdi
  802de3:	ff d0                	callq  *%rax
}
  802de5:	c9                   	leaveq 
  802de6:	c3                   	retq   

0000000000802de7 <seek>:

int
seek(int fdnum, off_t offset)
{
  802de7:	55                   	push   %rbp
  802de8:	48 89 e5             	mov    %rsp,%rbp
  802deb:	48 83 ec 18          	sub    $0x18,%rsp
  802def:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802df2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802df5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802df9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dfc:	48 89 d6             	mov    %rdx,%rsi
  802dff:	89 c7                	mov    %eax,%edi
  802e01:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802e08:	00 00 00 
  802e0b:	ff d0                	callq  *%rax
  802e0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e14:	79 05                	jns    802e1b <seek+0x34>
		return r;
  802e16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e19:	eb 0f                	jmp    802e2a <seek+0x43>
	fd->fd_offset = offset;
  802e1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e22:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2a:	c9                   	leaveq 
  802e2b:	c3                   	retq   

0000000000802e2c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e2c:	55                   	push   %rbp
  802e2d:	48 89 e5             	mov    %rsp,%rbp
  802e30:	48 83 ec 30          	sub    $0x30,%rsp
  802e34:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e37:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e3a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e3e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e41:	48 89 d6             	mov    %rdx,%rsi
  802e44:	89 c7                	mov    %eax,%edi
  802e46:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802e4d:	00 00 00 
  802e50:	ff d0                	callq  *%rax
  802e52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e59:	78 24                	js     802e7f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5f:	8b 00                	mov    (%rax),%eax
  802e61:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e65:	48 89 d6             	mov    %rdx,%rsi
  802e68:	89 c7                	mov    %eax,%edi
  802e6a:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802e71:	00 00 00 
  802e74:	ff d0                	callq  *%rax
  802e76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7d:	79 05                	jns    802e84 <ftruncate+0x58>
		return r;
  802e7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e82:	eb 72                	jmp    802ef6 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e88:	8b 40 08             	mov    0x8(%rax),%eax
  802e8b:	83 e0 03             	and    $0x3,%eax
  802e8e:	85 c0                	test   %eax,%eax
  802e90:	75 3a                	jne    802ecc <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e92:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e99:	00 00 00 
  802e9c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e9f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ea5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ea8:	89 c6                	mov    %eax,%esi
  802eaa:	48 bf a0 4e 80 00 00 	movabs $0x804ea0,%rdi
  802eb1:	00 00 00 
  802eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb9:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  802ec0:	00 00 00 
  802ec3:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ec5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802eca:	eb 2a                	jmp    802ef6 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ecc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed0:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ed4:	48 85 c0             	test   %rax,%rax
  802ed7:	75 07                	jne    802ee0 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802ed9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ede:	eb 16                	jmp    802ef6 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ee0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee4:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ee8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802eec:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802eef:	89 ce                	mov    %ecx,%esi
  802ef1:	48 89 d7             	mov    %rdx,%rdi
  802ef4:	ff d0                	callq  *%rax
}
  802ef6:	c9                   	leaveq 
  802ef7:	c3                   	retq   

0000000000802ef8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ef8:	55                   	push   %rbp
  802ef9:	48 89 e5             	mov    %rsp,%rbp
  802efc:	48 83 ec 30          	sub    $0x30,%rsp
  802f00:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f03:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f07:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f0b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f0e:	48 89 d6             	mov    %rdx,%rsi
  802f11:	89 c7                	mov    %eax,%edi
  802f13:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802f1a:	00 00 00 
  802f1d:	ff d0                	callq  *%rax
  802f1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f26:	78 24                	js     802f4c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2c:	8b 00                	mov    (%rax),%eax
  802f2e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f32:	48 89 d6             	mov    %rdx,%rsi
  802f35:	89 c7                	mov    %eax,%edi
  802f37:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802f3e:	00 00 00 
  802f41:	ff d0                	callq  *%rax
  802f43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f4a:	79 05                	jns    802f51 <fstat+0x59>
		return r;
  802f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4f:	eb 5e                	jmp    802faf <fstat+0xb7>
	if (!dev->dev_stat)
  802f51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f55:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f59:	48 85 c0             	test   %rax,%rax
  802f5c:	75 07                	jne    802f65 <fstat+0x6d>
		return -E_NOT_SUPP;
  802f5e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f63:	eb 4a                	jmp    802faf <fstat+0xb7>
	stat->st_name[0] = 0;
  802f65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f69:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f6c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f70:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f77:	00 00 00 
	stat->st_isdir = 0;
  802f7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f7e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f85:	00 00 00 
	stat->st_dev = dev;
  802f88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f90:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9b:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fa3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802fa7:	48 89 ce             	mov    %rcx,%rsi
  802faa:	48 89 d7             	mov    %rdx,%rdi
  802fad:	ff d0                	callq  *%rax
}
  802faf:	c9                   	leaveq 
  802fb0:	c3                   	retq   

0000000000802fb1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802fb1:	55                   	push   %rbp
  802fb2:	48 89 e5             	mov    %rsp,%rbp
  802fb5:	48 83 ec 20          	sub    $0x20,%rsp
  802fb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fbd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802fc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc5:	be 00 00 00 00       	mov    $0x0,%esi
  802fca:	48 89 c7             	mov    %rax,%rdi
  802fcd:	48 b8 9f 30 80 00 00 	movabs $0x80309f,%rax
  802fd4:	00 00 00 
  802fd7:	ff d0                	callq  *%rax
  802fd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe0:	79 05                	jns    802fe7 <stat+0x36>
		return fd;
  802fe2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe5:	eb 2f                	jmp    803016 <stat+0x65>
	r = fstat(fd, stat);
  802fe7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802feb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fee:	48 89 d6             	mov    %rdx,%rsi
  802ff1:	89 c7                	mov    %eax,%edi
  802ff3:	48 b8 f8 2e 80 00 00 	movabs $0x802ef8,%rax
  802ffa:	00 00 00 
  802ffd:	ff d0                	callq  *%rax
  802fff:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803002:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803005:	89 c7                	mov    %eax,%edi
  803007:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  80300e:	00 00 00 
  803011:	ff d0                	callq  *%rax
	return r;
  803013:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803016:	c9                   	leaveq 
  803017:	c3                   	retq   

0000000000803018 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803018:	55                   	push   %rbp
  803019:	48 89 e5             	mov    %rsp,%rbp
  80301c:	48 83 ec 10          	sub    $0x10,%rsp
  803020:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803023:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803027:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80302e:	00 00 00 
  803031:	8b 00                	mov    (%rax),%eax
  803033:	85 c0                	test   %eax,%eax
  803035:	75 1d                	jne    803054 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803037:	bf 01 00 00 00       	mov    $0x1,%edi
  80303c:	48 b8 d1 45 80 00 00 	movabs $0x8045d1,%rax
  803043:	00 00 00 
  803046:	ff d0                	callq  *%rax
  803048:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80304f:	00 00 00 
  803052:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803054:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80305b:	00 00 00 
  80305e:	8b 00                	mov    (%rax),%eax
  803060:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803063:	b9 07 00 00 00       	mov    $0x7,%ecx
  803068:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80306f:	00 00 00 
  803072:	89 c7                	mov    %eax,%edi
  803074:	48 b8 04 42 80 00 00 	movabs $0x804204,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803080:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803084:	ba 00 00 00 00       	mov    $0x0,%edx
  803089:	48 89 c6             	mov    %rax,%rsi
  80308c:	bf 00 00 00 00       	mov    $0x0,%edi
  803091:	48 b8 06 41 80 00 00 	movabs $0x804106,%rax
  803098:	00 00 00 
  80309b:	ff d0                	callq  *%rax
}
  80309d:	c9                   	leaveq 
  80309e:	c3                   	retq   

000000000080309f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80309f:	55                   	push   %rbp
  8030a0:	48 89 e5             	mov    %rsp,%rbp
  8030a3:	48 83 ec 30          	sub    $0x30,%rsp
  8030a7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030ab:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8030ae:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8030b5:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8030bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8030c3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8030c8:	75 08                	jne    8030d2 <open+0x33>
	{
		return r;
  8030ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cd:	e9 f2 00 00 00       	jmpq   8031c4 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8030d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030d6:	48 89 c7             	mov    %rax,%rdi
  8030d9:	48 b8 67 13 80 00 00 	movabs $0x801367,%rax
  8030e0:	00 00 00 
  8030e3:	ff d0                	callq  *%rax
  8030e5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8030e8:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8030ef:	7e 0a                	jle    8030fb <open+0x5c>
	{
		return -E_BAD_PATH;
  8030f1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030f6:	e9 c9 00 00 00       	jmpq   8031c4 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8030fb:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803102:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803103:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803107:	48 89 c7             	mov    %rax,%rdi
  80310a:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  803111:	00 00 00 
  803114:	ff d0                	callq  *%rax
  803116:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803119:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311d:	78 09                	js     803128 <open+0x89>
  80311f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803123:	48 85 c0             	test   %rax,%rax
  803126:	75 08                	jne    803130 <open+0x91>
		{
			return r;
  803128:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312b:	e9 94 00 00 00       	jmpq   8031c4 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803130:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803134:	ba 00 04 00 00       	mov    $0x400,%edx
  803139:	48 89 c6             	mov    %rax,%rsi
  80313c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803143:	00 00 00 
  803146:	48 b8 65 14 80 00 00 	movabs $0x801465,%rax
  80314d:	00 00 00 
  803150:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803152:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803159:	00 00 00 
  80315c:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80315f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803165:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803169:	48 89 c6             	mov    %rax,%rsi
  80316c:	bf 01 00 00 00       	mov    $0x1,%edi
  803171:	48 b8 18 30 80 00 00 	movabs $0x803018,%rax
  803178:	00 00 00 
  80317b:	ff d0                	callq  *%rax
  80317d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803180:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803184:	79 2b                	jns    8031b1 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80318a:	be 00 00 00 00       	mov    $0x0,%esi
  80318f:	48 89 c7             	mov    %rax,%rdi
  803192:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  803199:	00 00 00 
  80319c:	ff d0                	callq  *%rax
  80319e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8031a1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031a5:	79 05                	jns    8031ac <open+0x10d>
			{
				return d;
  8031a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031aa:	eb 18                	jmp    8031c4 <open+0x125>
			}
			return r;
  8031ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031af:	eb 13                	jmp    8031c4 <open+0x125>
		}	
		return fd2num(fd_store);
  8031b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b5:	48 89 c7             	mov    %rax,%rdi
  8031b8:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  8031bf:	00 00 00 
  8031c2:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8031c4:	c9                   	leaveq 
  8031c5:	c3                   	retq   

00000000008031c6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8031c6:	55                   	push   %rbp
  8031c7:	48 89 e5             	mov    %rsp,%rbp
  8031ca:	48 83 ec 10          	sub    $0x10,%rsp
  8031ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8031d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031d6:	8b 50 0c             	mov    0xc(%rax),%edx
  8031d9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031e0:	00 00 00 
  8031e3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031e5:	be 00 00 00 00       	mov    $0x0,%esi
  8031ea:	bf 06 00 00 00       	mov    $0x6,%edi
  8031ef:	48 b8 18 30 80 00 00 	movabs $0x803018,%rax
  8031f6:	00 00 00 
  8031f9:	ff d0                	callq  *%rax
}
  8031fb:	c9                   	leaveq 
  8031fc:	c3                   	retq   

00000000008031fd <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031fd:	55                   	push   %rbp
  8031fe:	48 89 e5             	mov    %rsp,%rbp
  803201:	48 83 ec 30          	sub    $0x30,%rsp
  803205:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803209:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80320d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803218:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80321d:	74 07                	je     803226 <devfile_read+0x29>
  80321f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803224:	75 07                	jne    80322d <devfile_read+0x30>
		return -E_INVAL;
  803226:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80322b:	eb 77                	jmp    8032a4 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80322d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803231:	8b 50 0c             	mov    0xc(%rax),%edx
  803234:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80323b:	00 00 00 
  80323e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803240:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803247:	00 00 00 
  80324a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80324e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803252:	be 00 00 00 00       	mov    $0x0,%esi
  803257:	bf 03 00 00 00       	mov    $0x3,%edi
  80325c:	48 b8 18 30 80 00 00 	movabs $0x803018,%rax
  803263:	00 00 00 
  803266:	ff d0                	callq  *%rax
  803268:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80326b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326f:	7f 05                	jg     803276 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803271:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803274:	eb 2e                	jmp    8032a4 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803276:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803279:	48 63 d0             	movslq %eax,%rdx
  80327c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803280:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803287:	00 00 00 
  80328a:	48 89 c7             	mov    %rax,%rdi
  80328d:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  803294:	00 00 00 
  803297:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803299:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80329d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8032a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8032a4:	c9                   	leaveq 
  8032a5:	c3                   	retq   

00000000008032a6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8032a6:	55                   	push   %rbp
  8032a7:	48 89 e5             	mov    %rsp,%rbp
  8032aa:	48 83 ec 30          	sub    $0x30,%rsp
  8032ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8032ba:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8032c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8032c6:	74 07                	je     8032cf <devfile_write+0x29>
  8032c8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8032cd:	75 08                	jne    8032d7 <devfile_write+0x31>
		return r;
  8032cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d2:	e9 9a 00 00 00       	jmpq   803371 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8032d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032db:	8b 50 0c             	mov    0xc(%rax),%edx
  8032de:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032e5:	00 00 00 
  8032e8:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8032ea:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8032f1:	00 
  8032f2:	76 08                	jbe    8032fc <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8032f4:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8032fb:	00 
	}
	fsipcbuf.write.req_n = n;
  8032fc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803303:	00 00 00 
  803306:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80330a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80330e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803312:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803316:	48 89 c6             	mov    %rax,%rsi
  803319:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803320:	00 00 00 
  803323:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80332f:	be 00 00 00 00       	mov    $0x0,%esi
  803334:	bf 04 00 00 00       	mov    $0x4,%edi
  803339:	48 b8 18 30 80 00 00 	movabs $0x803018,%rax
  803340:	00 00 00 
  803343:	ff d0                	callq  *%rax
  803345:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803348:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80334c:	7f 20                	jg     80336e <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80334e:	48 bf c6 4e 80 00 00 	movabs $0x804ec6,%rdi
  803355:	00 00 00 
  803358:	b8 00 00 00 00       	mov    $0x0,%eax
  80335d:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  803364:	00 00 00 
  803367:	ff d2                	callq  *%rdx
		return r;
  803369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336c:	eb 03                	jmp    803371 <devfile_write+0xcb>
	}
	return r;
  80336e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803371:	c9                   	leaveq 
  803372:	c3                   	retq   

0000000000803373 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803373:	55                   	push   %rbp
  803374:	48 89 e5             	mov    %rsp,%rbp
  803377:	48 83 ec 20          	sub    $0x20,%rsp
  80337b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80337f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803387:	8b 50 0c             	mov    0xc(%rax),%edx
  80338a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803391:	00 00 00 
  803394:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803396:	be 00 00 00 00       	mov    $0x0,%esi
  80339b:	bf 05 00 00 00       	mov    $0x5,%edi
  8033a0:	48 b8 18 30 80 00 00 	movabs $0x803018,%rax
  8033a7:	00 00 00 
  8033aa:	ff d0                	callq  *%rax
  8033ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b3:	79 05                	jns    8033ba <devfile_stat+0x47>
		return r;
  8033b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b8:	eb 56                	jmp    803410 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8033ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033be:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8033c5:	00 00 00 
  8033c8:	48 89 c7             	mov    %rax,%rdi
  8033cb:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  8033d2:	00 00 00 
  8033d5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8033d7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033de:	00 00 00 
  8033e1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8033e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033eb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033f1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033f8:	00 00 00 
  8033fb:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803401:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803405:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80340b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803410:	c9                   	leaveq 
  803411:	c3                   	retq   

0000000000803412 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803412:	55                   	push   %rbp
  803413:	48 89 e5             	mov    %rsp,%rbp
  803416:	48 83 ec 10          	sub    $0x10,%rsp
  80341a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80341e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803421:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803425:	8b 50 0c             	mov    0xc(%rax),%edx
  803428:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80342f:	00 00 00 
  803432:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803434:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80343b:	00 00 00 
  80343e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803441:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803444:	be 00 00 00 00       	mov    $0x0,%esi
  803449:	bf 02 00 00 00       	mov    $0x2,%edi
  80344e:	48 b8 18 30 80 00 00 	movabs $0x803018,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
}
  80345a:	c9                   	leaveq 
  80345b:	c3                   	retq   

000000000080345c <remove>:

// Delete a file
int
remove(const char *path)
{
  80345c:	55                   	push   %rbp
  80345d:	48 89 e5             	mov    %rsp,%rbp
  803460:	48 83 ec 10          	sub    $0x10,%rsp
  803464:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80346c:	48 89 c7             	mov    %rax,%rdi
  80346f:	48 b8 67 13 80 00 00 	movabs $0x801367,%rax
  803476:	00 00 00 
  803479:	ff d0                	callq  *%rax
  80347b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803480:	7e 07                	jle    803489 <remove+0x2d>
		return -E_BAD_PATH;
  803482:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803487:	eb 33                	jmp    8034bc <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803489:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80348d:	48 89 c6             	mov    %rax,%rsi
  803490:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803497:	00 00 00 
  80349a:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8034a6:	be 00 00 00 00       	mov    $0x0,%esi
  8034ab:	bf 07 00 00 00       	mov    $0x7,%edi
  8034b0:	48 b8 18 30 80 00 00 	movabs $0x803018,%rax
  8034b7:	00 00 00 
  8034ba:	ff d0                	callq  *%rax
}
  8034bc:	c9                   	leaveq 
  8034bd:	c3                   	retq   

00000000008034be <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8034be:	55                   	push   %rbp
  8034bf:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8034c2:	be 00 00 00 00       	mov    $0x0,%esi
  8034c7:	bf 08 00 00 00       	mov    $0x8,%edi
  8034cc:	48 b8 18 30 80 00 00 	movabs $0x803018,%rax
  8034d3:	00 00 00 
  8034d6:	ff d0                	callq  *%rax
}
  8034d8:	5d                   	pop    %rbp
  8034d9:	c3                   	retq   

00000000008034da <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8034da:	55                   	push   %rbp
  8034db:	48 89 e5             	mov    %rsp,%rbp
  8034de:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8034e5:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8034ec:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8034f3:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8034fa:	be 00 00 00 00       	mov    $0x0,%esi
  8034ff:	48 89 c7             	mov    %rax,%rdi
  803502:	48 b8 9f 30 80 00 00 	movabs $0x80309f,%rax
  803509:	00 00 00 
  80350c:	ff d0                	callq  *%rax
  80350e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803515:	79 28                	jns    80353f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803517:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351a:	89 c6                	mov    %eax,%esi
  80351c:	48 bf e2 4e 80 00 00 	movabs $0x804ee2,%rdi
  803523:	00 00 00 
  803526:	b8 00 00 00 00       	mov    $0x0,%eax
  80352b:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  803532:	00 00 00 
  803535:	ff d2                	callq  *%rdx
		return fd_src;
  803537:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353a:	e9 74 01 00 00       	jmpq   8036b3 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80353f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803546:	be 01 01 00 00       	mov    $0x101,%esi
  80354b:	48 89 c7             	mov    %rax,%rdi
  80354e:	48 b8 9f 30 80 00 00 	movabs $0x80309f,%rax
  803555:	00 00 00 
  803558:	ff d0                	callq  *%rax
  80355a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80355d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803561:	79 39                	jns    80359c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803563:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803566:	89 c6                	mov    %eax,%esi
  803568:	48 bf f8 4e 80 00 00 	movabs $0x804ef8,%rdi
  80356f:	00 00 00 
  803572:	b8 00 00 00 00       	mov    $0x0,%eax
  803577:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  80357e:	00 00 00 
  803581:	ff d2                	callq  *%rdx
		close(fd_src);
  803583:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803586:	89 c7                	mov    %eax,%edi
  803588:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  80358f:	00 00 00 
  803592:	ff d0                	callq  *%rax
		return fd_dest;
  803594:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803597:	e9 17 01 00 00       	jmpq   8036b3 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80359c:	eb 74                	jmp    803612 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80359e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035a1:	48 63 d0             	movslq %eax,%rdx
  8035a4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035ae:	48 89 ce             	mov    %rcx,%rsi
  8035b1:	89 c7                	mov    %eax,%edi
  8035b3:	48 b8 46 2d 80 00 00 	movabs $0x802d46,%rax
  8035ba:	00 00 00 
  8035bd:	ff d0                	callq  *%rax
  8035bf:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8035c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8035c6:	79 4a                	jns    803612 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8035c8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035cb:	89 c6                	mov    %eax,%esi
  8035cd:	48 bf 12 4f 80 00 00 	movabs $0x804f12,%rdi
  8035d4:	00 00 00 
  8035d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035dc:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  8035e3:	00 00 00 
  8035e6:	ff d2                	callq  *%rdx
			close(fd_src);
  8035e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035eb:	89 c7                	mov    %eax,%edi
  8035ed:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  8035f4:	00 00 00 
  8035f7:	ff d0                	callq  *%rax
			close(fd_dest);
  8035f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035fc:	89 c7                	mov    %eax,%edi
  8035fe:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  803605:	00 00 00 
  803608:	ff d0                	callq  *%rax
			return write_size;
  80360a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80360d:	e9 a1 00 00 00       	jmpq   8036b3 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803612:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803619:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80361c:	ba 00 02 00 00       	mov    $0x200,%edx
  803621:	48 89 ce             	mov    %rcx,%rsi
  803624:	89 c7                	mov    %eax,%edi
  803626:	48 b8 fc 2b 80 00 00 	movabs $0x802bfc,%rax
  80362d:	00 00 00 
  803630:	ff d0                	callq  *%rax
  803632:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803635:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803639:	0f 8f 5f ff ff ff    	jg     80359e <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80363f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803643:	79 47                	jns    80368c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803645:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803648:	89 c6                	mov    %eax,%esi
  80364a:	48 bf 25 4f 80 00 00 	movabs $0x804f25,%rdi
  803651:	00 00 00 
  803654:	b8 00 00 00 00       	mov    $0x0,%eax
  803659:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  803660:	00 00 00 
  803663:	ff d2                	callq  *%rdx
		close(fd_src);
  803665:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803668:	89 c7                	mov    %eax,%edi
  80366a:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  803671:	00 00 00 
  803674:	ff d0                	callq  *%rax
		close(fd_dest);
  803676:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803679:	89 c7                	mov    %eax,%edi
  80367b:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  803682:	00 00 00 
  803685:	ff d0                	callq  *%rax
		return read_size;
  803687:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80368a:	eb 27                	jmp    8036b3 <copy+0x1d9>
	}
	close(fd_src);
  80368c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368f:	89 c7                	mov    %eax,%edi
  803691:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  803698:	00 00 00 
  80369b:	ff d0                	callq  *%rax
	close(fd_dest);
  80369d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036a0:	89 c7                	mov    %eax,%edi
  8036a2:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  8036a9:	00 00 00 
  8036ac:	ff d0                	callq  *%rax
	return 0;
  8036ae:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8036b3:	c9                   	leaveq 
  8036b4:	c3                   	retq   

00000000008036b5 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8036b5:	55                   	push   %rbp
  8036b6:	48 89 e5             	mov    %rsp,%rbp
  8036b9:	53                   	push   %rbx
  8036ba:	48 83 ec 38          	sub    $0x38,%rsp
  8036be:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8036c2:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8036c6:	48 89 c7             	mov    %rax,%rdi
  8036c9:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  8036d0:	00 00 00 
  8036d3:	ff d0                	callq  *%rax
  8036d5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036dc:	0f 88 bf 01 00 00    	js     8038a1 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e6:	ba 07 04 00 00       	mov    $0x407,%edx
  8036eb:	48 89 c6             	mov    %rax,%rsi
  8036ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8036f3:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  8036fa:	00 00 00 
  8036fd:	ff d0                	callq  *%rax
  8036ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803702:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803706:	0f 88 95 01 00 00    	js     8038a1 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80370c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803710:	48 89 c7             	mov    %rax,%rdi
  803713:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  80371a:	00 00 00 
  80371d:	ff d0                	callq  *%rax
  80371f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803722:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803726:	0f 88 5d 01 00 00    	js     803889 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80372c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803730:	ba 07 04 00 00       	mov    $0x407,%edx
  803735:	48 89 c6             	mov    %rax,%rsi
  803738:	bf 00 00 00 00       	mov    $0x0,%edi
  80373d:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  803744:	00 00 00 
  803747:	ff d0                	callq  *%rax
  803749:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80374c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803750:	0f 88 33 01 00 00    	js     803889 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803756:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80375a:	48 89 c7             	mov    %rax,%rdi
  80375d:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  803764:	00 00 00 
  803767:	ff d0                	callq  *%rax
  803769:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80376d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803771:	ba 07 04 00 00       	mov    $0x407,%edx
  803776:	48 89 c6             	mov    %rax,%rsi
  803779:	bf 00 00 00 00       	mov    $0x0,%edi
  80377e:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  803785:	00 00 00 
  803788:	ff d0                	callq  *%rax
  80378a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80378d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803791:	79 05                	jns    803798 <pipe+0xe3>
		goto err2;
  803793:	e9 d9 00 00 00       	jmpq   803871 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803798:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80379c:	48 89 c7             	mov    %rax,%rdi
  80379f:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  8037a6:	00 00 00 
  8037a9:	ff d0                	callq  *%rax
  8037ab:	48 89 c2             	mov    %rax,%rdx
  8037ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b2:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8037b8:	48 89 d1             	mov    %rdx,%rcx
  8037bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8037c0:	48 89 c6             	mov    %rax,%rsi
  8037c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c8:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  8037cf:	00 00 00 
  8037d2:	ff d0                	callq  *%rax
  8037d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037db:	79 1b                	jns    8037f8 <pipe+0x143>
		goto err3;
  8037dd:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8037de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e2:	48 89 c6             	mov    %rax,%rsi
  8037e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ea:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  8037f1:	00 00 00 
  8037f4:	ff d0                	callq  *%rax
  8037f6:	eb 79                	jmp    803871 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037fc:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803803:	00 00 00 
  803806:	8b 12                	mov    (%rdx),%edx
  803808:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80380a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803815:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803819:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803820:	00 00 00 
  803823:	8b 12                	mov    (%rdx),%edx
  803825:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803827:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80382b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803836:	48 89 c7             	mov    %rax,%rdi
  803839:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  803840:	00 00 00 
  803843:	ff d0                	callq  *%rax
  803845:	89 c2                	mov    %eax,%edx
  803847:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80384b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80384d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803851:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803855:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803859:	48 89 c7             	mov    %rax,%rdi
  80385c:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  803863:	00 00 00 
  803866:	ff d0                	callq  *%rax
  803868:	89 03                	mov    %eax,(%rbx)
	return 0;
  80386a:	b8 00 00 00 00       	mov    $0x0,%eax
  80386f:	eb 33                	jmp    8038a4 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803871:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803875:	48 89 c6             	mov    %rax,%rsi
  803878:	bf 00 00 00 00       	mov    $0x0,%edi
  80387d:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  803884:	00 00 00 
  803887:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80388d:	48 89 c6             	mov    %rax,%rsi
  803890:	bf 00 00 00 00       	mov    $0x0,%edi
  803895:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
err:
	return r;
  8038a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8038a4:	48 83 c4 38          	add    $0x38,%rsp
  8038a8:	5b                   	pop    %rbx
  8038a9:	5d                   	pop    %rbp
  8038aa:	c3                   	retq   

00000000008038ab <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8038ab:	55                   	push   %rbp
  8038ac:	48 89 e5             	mov    %rsp,%rbp
  8038af:	53                   	push   %rbx
  8038b0:	48 83 ec 28          	sub    $0x28,%rsp
  8038b4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038b8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8038bc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038c3:	00 00 00 
  8038c6:	48 8b 00             	mov    (%rax),%rax
  8038c9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8038d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038d6:	48 89 c7             	mov    %rax,%rdi
  8038d9:	48 b8 43 46 80 00 00 	movabs $0x804643,%rax
  8038e0:	00 00 00 
  8038e3:	ff d0                	callq  *%rax
  8038e5:	89 c3                	mov    %eax,%ebx
  8038e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038eb:	48 89 c7             	mov    %rax,%rdi
  8038ee:	48 b8 43 46 80 00 00 	movabs $0x804643,%rax
  8038f5:	00 00 00 
  8038f8:	ff d0                	callq  *%rax
  8038fa:	39 c3                	cmp    %eax,%ebx
  8038fc:	0f 94 c0             	sete   %al
  8038ff:	0f b6 c0             	movzbl %al,%eax
  803902:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803905:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80390c:	00 00 00 
  80390f:	48 8b 00             	mov    (%rax),%rax
  803912:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803918:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80391b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80391e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803921:	75 05                	jne    803928 <_pipeisclosed+0x7d>
			return ret;
  803923:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803926:	eb 4f                	jmp    803977 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803928:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80392b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80392e:	74 42                	je     803972 <_pipeisclosed+0xc7>
  803930:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803934:	75 3c                	jne    803972 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803936:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80393d:	00 00 00 
  803940:	48 8b 00             	mov    (%rax),%rax
  803943:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803949:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80394c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80394f:	89 c6                	mov    %eax,%esi
  803951:	48 bf 45 4f 80 00 00 	movabs $0x804f45,%rdi
  803958:	00 00 00 
  80395b:	b8 00 00 00 00       	mov    $0x0,%eax
  803960:	49 b8 1e 08 80 00 00 	movabs $0x80081e,%r8
  803967:	00 00 00 
  80396a:	41 ff d0             	callq  *%r8
	}
  80396d:	e9 4a ff ff ff       	jmpq   8038bc <_pipeisclosed+0x11>
  803972:	e9 45 ff ff ff       	jmpq   8038bc <_pipeisclosed+0x11>
}
  803977:	48 83 c4 28          	add    $0x28,%rsp
  80397b:	5b                   	pop    %rbx
  80397c:	5d                   	pop    %rbp
  80397d:	c3                   	retq   

000000000080397e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80397e:	55                   	push   %rbp
  80397f:	48 89 e5             	mov    %rsp,%rbp
  803982:	48 83 ec 30          	sub    $0x30,%rsp
  803986:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803989:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80398d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803990:	48 89 d6             	mov    %rdx,%rsi
  803993:	89 c7                	mov    %eax,%edi
  803995:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  80399c:	00 00 00 
  80399f:	ff d0                	callq  *%rax
  8039a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a8:	79 05                	jns    8039af <pipeisclosed+0x31>
		return r;
  8039aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ad:	eb 31                	jmp    8039e0 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8039af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b3:	48 89 c7             	mov    %rax,%rdi
  8039b6:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  8039bd:	00 00 00 
  8039c0:	ff d0                	callq  *%rax
  8039c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8039c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039ce:	48 89 d6             	mov    %rdx,%rsi
  8039d1:	48 89 c7             	mov    %rax,%rdi
  8039d4:	48 b8 ab 38 80 00 00 	movabs $0x8038ab,%rax
  8039db:	00 00 00 
  8039de:	ff d0                	callq  *%rax
}
  8039e0:	c9                   	leaveq 
  8039e1:	c3                   	retq   

00000000008039e2 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039e2:	55                   	push   %rbp
  8039e3:	48 89 e5             	mov    %rsp,%rbp
  8039e6:	48 83 ec 40          	sub    $0x40,%rsp
  8039ea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039f2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039fa:	48 89 c7             	mov    %rax,%rdi
  8039fd:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  803a04:	00 00 00 
  803a07:	ff d0                	callq  *%rax
  803a09:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a15:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a1c:	00 
  803a1d:	e9 92 00 00 00       	jmpq   803ab4 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803a22:	eb 41                	jmp    803a65 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803a24:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a29:	74 09                	je     803a34 <devpipe_read+0x52>
				return i;
  803a2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a2f:	e9 92 00 00 00       	jmpq   803ac6 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a3c:	48 89 d6             	mov    %rdx,%rsi
  803a3f:	48 89 c7             	mov    %rax,%rdi
  803a42:	48 b8 ab 38 80 00 00 	movabs $0x8038ab,%rax
  803a49:	00 00 00 
  803a4c:	ff d0                	callq  *%rax
  803a4e:	85 c0                	test   %eax,%eax
  803a50:	74 07                	je     803a59 <devpipe_read+0x77>
				return 0;
  803a52:	b8 00 00 00 00       	mov    $0x0,%eax
  803a57:	eb 6d                	jmp    803ac6 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a59:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803a60:	00 00 00 
  803a63:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a69:	8b 10                	mov    (%rax),%edx
  803a6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a6f:	8b 40 04             	mov    0x4(%rax),%eax
  803a72:	39 c2                	cmp    %eax,%edx
  803a74:	74 ae                	je     803a24 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a7e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a86:	8b 00                	mov    (%rax),%eax
  803a88:	99                   	cltd   
  803a89:	c1 ea 1b             	shr    $0x1b,%edx
  803a8c:	01 d0                	add    %edx,%eax
  803a8e:	83 e0 1f             	and    $0x1f,%eax
  803a91:	29 d0                	sub    %edx,%eax
  803a93:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a97:	48 98                	cltq   
  803a99:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a9e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803aa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa4:	8b 00                	mov    (%rax),%eax
  803aa6:	8d 50 01             	lea    0x1(%rax),%edx
  803aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aad:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803aaf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ab4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ab8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803abc:	0f 82 60 ff ff ff    	jb     803a22 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ac6:	c9                   	leaveq 
  803ac7:	c3                   	retq   

0000000000803ac8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ac8:	55                   	push   %rbp
  803ac9:	48 89 e5             	mov    %rsp,%rbp
  803acc:	48 83 ec 40          	sub    $0x40,%rsp
  803ad0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ad4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ad8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803adc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae0:	48 89 c7             	mov    %rax,%rdi
  803ae3:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  803aea:	00 00 00 
  803aed:	ff d0                	callq  *%rax
  803aef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803af3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803af7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803afb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b02:	00 
  803b03:	e9 8e 00 00 00       	jmpq   803b96 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b08:	eb 31                	jmp    803b3b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803b0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b12:	48 89 d6             	mov    %rdx,%rsi
  803b15:	48 89 c7             	mov    %rax,%rdi
  803b18:	48 b8 ab 38 80 00 00 	movabs $0x8038ab,%rax
  803b1f:	00 00 00 
  803b22:	ff d0                	callq  *%rax
  803b24:	85 c0                	test   %eax,%eax
  803b26:	74 07                	je     803b2f <devpipe_write+0x67>
				return 0;
  803b28:	b8 00 00 00 00       	mov    $0x0,%eax
  803b2d:	eb 79                	jmp    803ba8 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b2f:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803b36:	00 00 00 
  803b39:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3f:	8b 40 04             	mov    0x4(%rax),%eax
  803b42:	48 63 d0             	movslq %eax,%rdx
  803b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b49:	8b 00                	mov    (%rax),%eax
  803b4b:	48 98                	cltq   
  803b4d:	48 83 c0 20          	add    $0x20,%rax
  803b51:	48 39 c2             	cmp    %rax,%rdx
  803b54:	73 b4                	jae    803b0a <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5a:	8b 40 04             	mov    0x4(%rax),%eax
  803b5d:	99                   	cltd   
  803b5e:	c1 ea 1b             	shr    $0x1b,%edx
  803b61:	01 d0                	add    %edx,%eax
  803b63:	83 e0 1f             	and    $0x1f,%eax
  803b66:	29 d0                	sub    %edx,%eax
  803b68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b6c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b70:	48 01 ca             	add    %rcx,%rdx
  803b73:	0f b6 0a             	movzbl (%rdx),%ecx
  803b76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b7a:	48 98                	cltq   
  803b7c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b84:	8b 40 04             	mov    0x4(%rax),%eax
  803b87:	8d 50 01             	lea    0x1(%rax),%edx
  803b8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b91:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b9a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b9e:	0f 82 64 ff ff ff    	jb     803b08 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ba4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ba8:	c9                   	leaveq 
  803ba9:	c3                   	retq   

0000000000803baa <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803baa:	55                   	push   %rbp
  803bab:	48 89 e5             	mov    %rsp,%rbp
  803bae:	48 83 ec 20          	sub    $0x20,%rsp
  803bb2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bb6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803bba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bbe:	48 89 c7             	mov    %rax,%rdi
  803bc1:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  803bc8:	00 00 00 
  803bcb:	ff d0                	callq  *%rax
  803bcd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803bd1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd5:	48 be 58 4f 80 00 00 	movabs $0x804f58,%rsi
  803bdc:	00 00 00 
  803bdf:	48 89 c7             	mov    %rax,%rdi
  803be2:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  803be9:	00 00 00 
  803bec:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803bee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bf2:	8b 50 04             	mov    0x4(%rax),%edx
  803bf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bf9:	8b 00                	mov    (%rax),%eax
  803bfb:	29 c2                	sub    %eax,%edx
  803bfd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c01:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803c07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c0b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803c12:	00 00 00 
	stat->st_dev = &devpipe;
  803c15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c19:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803c20:	00 00 00 
  803c23:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803c2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c2f:	c9                   	leaveq 
  803c30:	c3                   	retq   

0000000000803c31 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c31:	55                   	push   %rbp
  803c32:	48 89 e5             	mov    %rsp,%rbp
  803c35:	48 83 ec 10          	sub    $0x10,%rsp
  803c39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c41:	48 89 c6             	mov    %rax,%rsi
  803c44:	bf 00 00 00 00       	mov    $0x0,%edi
  803c49:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  803c50:	00 00 00 
  803c53:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c59:	48 89 c7             	mov    %rax,%rdi
  803c5c:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  803c63:	00 00 00 
  803c66:	ff d0                	callq  *%rax
  803c68:	48 89 c6             	mov    %rax,%rsi
  803c6b:	bf 00 00 00 00       	mov    $0x0,%edi
  803c70:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  803c77:	00 00 00 
  803c7a:	ff d0                	callq  *%rax
}
  803c7c:	c9                   	leaveq 
  803c7d:	c3                   	retq   

0000000000803c7e <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803c7e:	55                   	push   %rbp
  803c7f:	48 89 e5             	mov    %rsp,%rbp
  803c82:	48 83 ec 20          	sub    $0x20,%rsp
  803c86:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803c89:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c8d:	75 35                	jne    803cc4 <wait+0x46>
  803c8f:	48 b9 5f 4f 80 00 00 	movabs $0x804f5f,%rcx
  803c96:	00 00 00 
  803c99:	48 ba 6a 4f 80 00 00 	movabs $0x804f6a,%rdx
  803ca0:	00 00 00 
  803ca3:	be 09 00 00 00       	mov    $0x9,%esi
  803ca8:	48 bf 7f 4f 80 00 00 	movabs $0x804f7f,%rdi
  803caf:	00 00 00 
  803cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb7:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  803cbe:	00 00 00 
  803cc1:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803cc4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cc7:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ccc:	48 98                	cltq   
  803cce:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803cd5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803cdc:	00 00 00 
  803cdf:	48 01 d0             	add    %rdx,%rax
  803ce2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  803ce6:	eb 0c                	jmp    803cf4 <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  803ce8:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803cef:	00 00 00 
  803cf2:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  803cf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803cfe:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d01:	75 0e                	jne    803d11 <wait+0x93>
  803d03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d07:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803d0d:	85 c0                	test   %eax,%eax
  803d0f:	75 d7                	jne    803ce8 <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  803d11:	c9                   	leaveq 
  803d12:	c3                   	retq   

0000000000803d13 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803d13:	55                   	push   %rbp
  803d14:	48 89 e5             	mov    %rsp,%rbp
  803d17:	48 83 ec 20          	sub    $0x20,%rsp
  803d1b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803d1e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d21:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803d24:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803d28:	be 01 00 00 00       	mov    $0x1,%esi
  803d2d:	48 89 c7             	mov    %rax,%rdi
  803d30:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803d37:	00 00 00 
  803d3a:	ff d0                	callq  *%rax
}
  803d3c:	c9                   	leaveq 
  803d3d:	c3                   	retq   

0000000000803d3e <getchar>:

int
getchar(void)
{
  803d3e:	55                   	push   %rbp
  803d3f:	48 89 e5             	mov    %rsp,%rbp
  803d42:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803d46:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803d4a:	ba 01 00 00 00       	mov    $0x1,%edx
  803d4f:	48 89 c6             	mov    %rax,%rsi
  803d52:	bf 00 00 00 00       	mov    $0x0,%edi
  803d57:	48 b8 fc 2b 80 00 00 	movabs $0x802bfc,%rax
  803d5e:	00 00 00 
  803d61:	ff d0                	callq  *%rax
  803d63:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803d66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d6a:	79 05                	jns    803d71 <getchar+0x33>
		return r;
  803d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6f:	eb 14                	jmp    803d85 <getchar+0x47>
	if (r < 1)
  803d71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d75:	7f 07                	jg     803d7e <getchar+0x40>
		return -E_EOF;
  803d77:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803d7c:	eb 07                	jmp    803d85 <getchar+0x47>
	return c;
  803d7e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803d82:	0f b6 c0             	movzbl %al,%eax
}
  803d85:	c9                   	leaveq 
  803d86:	c3                   	retq   

0000000000803d87 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803d87:	55                   	push   %rbp
  803d88:	48 89 e5             	mov    %rsp,%rbp
  803d8b:	48 83 ec 20          	sub    $0x20,%rsp
  803d8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d92:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d96:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d99:	48 89 d6             	mov    %rdx,%rsi
  803d9c:	89 c7                	mov    %eax,%edi
  803d9e:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  803da5:	00 00 00 
  803da8:	ff d0                	callq  *%rax
  803daa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db1:	79 05                	jns    803db8 <iscons+0x31>
		return r;
  803db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db6:	eb 1a                	jmp    803dd2 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803db8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dbc:	8b 10                	mov    (%rax),%edx
  803dbe:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803dc5:	00 00 00 
  803dc8:	8b 00                	mov    (%rax),%eax
  803dca:	39 c2                	cmp    %eax,%edx
  803dcc:	0f 94 c0             	sete   %al
  803dcf:	0f b6 c0             	movzbl %al,%eax
}
  803dd2:	c9                   	leaveq 
  803dd3:	c3                   	retq   

0000000000803dd4 <opencons>:

int
opencons(void)
{
  803dd4:	55                   	push   %rbp
  803dd5:	48 89 e5             	mov    %rsp,%rbp
  803dd8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ddc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803de0:	48 89 c7             	mov    %rax,%rdi
  803de3:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  803dea:	00 00 00 
  803ded:	ff d0                	callq  *%rax
  803def:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803df2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803df6:	79 05                	jns    803dfd <opencons+0x29>
		return r;
  803df8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dfb:	eb 5b                	jmp    803e58 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803dfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e01:	ba 07 04 00 00       	mov    $0x407,%edx
  803e06:	48 89 c6             	mov    %rax,%rsi
  803e09:	bf 00 00 00 00       	mov    $0x0,%edi
  803e0e:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  803e15:	00 00 00 
  803e18:	ff d0                	callq  *%rax
  803e1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e21:	79 05                	jns    803e28 <opencons+0x54>
		return r;
  803e23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e26:	eb 30                	jmp    803e58 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803e28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e2c:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803e33:	00 00 00 
  803e36:	8b 12                	mov    (%rdx),%edx
  803e38:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803e45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e49:	48 89 c7             	mov    %rax,%rdi
  803e4c:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  803e53:	00 00 00 
  803e56:	ff d0                	callq  *%rax
}
  803e58:	c9                   	leaveq 
  803e59:	c3                   	retq   

0000000000803e5a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e5a:	55                   	push   %rbp
  803e5b:	48 89 e5             	mov    %rsp,%rbp
  803e5e:	48 83 ec 30          	sub    $0x30,%rsp
  803e62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803e6e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e73:	75 07                	jne    803e7c <devcons_read+0x22>
		return 0;
  803e75:	b8 00 00 00 00       	mov    $0x0,%eax
  803e7a:	eb 4b                	jmp    803ec7 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803e7c:	eb 0c                	jmp    803e8a <devcons_read+0x30>
		sys_yield();
  803e7e:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803e85:	00 00 00 
  803e88:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803e8a:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  803e91:	00 00 00 
  803e94:	ff d0                	callq  *%rax
  803e96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e9d:	74 df                	je     803e7e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803e9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea3:	79 05                	jns    803eaa <devcons_read+0x50>
		return c;
  803ea5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea8:	eb 1d                	jmp    803ec7 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803eaa:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803eae:	75 07                	jne    803eb7 <devcons_read+0x5d>
		return 0;
  803eb0:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb5:	eb 10                	jmp    803ec7 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803eb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eba:	89 c2                	mov    %eax,%edx
  803ebc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ec0:	88 10                	mov    %dl,(%rax)
	return 1;
  803ec2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ec7:	c9                   	leaveq 
  803ec8:	c3                   	retq   

0000000000803ec9 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ec9:	55                   	push   %rbp
  803eca:	48 89 e5             	mov    %rsp,%rbp
  803ecd:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803ed4:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803edb:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803ee2:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ee9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ef0:	eb 76                	jmp    803f68 <devcons_write+0x9f>
		m = n - tot;
  803ef2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803ef9:	89 c2                	mov    %eax,%edx
  803efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803efe:	29 c2                	sub    %eax,%edx
  803f00:	89 d0                	mov    %edx,%eax
  803f02:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f08:	83 f8 7f             	cmp    $0x7f,%eax
  803f0b:	76 07                	jbe    803f14 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803f0d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803f14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f17:	48 63 d0             	movslq %eax,%rdx
  803f1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f1d:	48 63 c8             	movslq %eax,%rcx
  803f20:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803f27:	48 01 c1             	add    %rax,%rcx
  803f2a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f31:	48 89 ce             	mov    %rcx,%rsi
  803f34:	48 89 c7             	mov    %rax,%rdi
  803f37:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  803f3e:	00 00 00 
  803f41:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803f43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f46:	48 63 d0             	movslq %eax,%rdx
  803f49:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f50:	48 89 d6             	mov    %rdx,%rsi
  803f53:	48 89 c7             	mov    %rax,%rdi
  803f56:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803f5d:	00 00 00 
  803f60:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f65:	01 45 fc             	add    %eax,-0x4(%rbp)
  803f68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f6b:	48 98                	cltq   
  803f6d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803f74:	0f 82 78 ff ff ff    	jb     803ef2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803f7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f7d:	c9                   	leaveq 
  803f7e:	c3                   	retq   

0000000000803f7f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803f7f:	55                   	push   %rbp
  803f80:	48 89 e5             	mov    %rsp,%rbp
  803f83:	48 83 ec 08          	sub    $0x8,%rsp
  803f87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803f8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f90:	c9                   	leaveq 
  803f91:	c3                   	retq   

0000000000803f92 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803f92:	55                   	push   %rbp
  803f93:	48 89 e5             	mov    %rsp,%rbp
  803f96:	48 83 ec 10          	sub    $0x10,%rsp
  803f9a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803fa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa6:	48 be 8f 4f 80 00 00 	movabs $0x804f8f,%rsi
  803fad:	00 00 00 
  803fb0:	48 89 c7             	mov    %rax,%rdi
  803fb3:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  803fba:	00 00 00 
  803fbd:	ff d0                	callq  *%rax
	return 0;
  803fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fc4:	c9                   	leaveq 
  803fc5:	c3                   	retq   

0000000000803fc6 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803fc6:	55                   	push   %rbp
  803fc7:	48 89 e5             	mov    %rsp,%rbp
  803fca:	48 83 ec 10          	sub    $0x10,%rsp
  803fce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803fd2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803fd9:	00 00 00 
  803fdc:	48 8b 00             	mov    (%rax),%rax
  803fdf:	48 85 c0             	test   %rax,%rax
  803fe2:	0f 85 84 00 00 00    	jne    80406c <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803fe8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fef:	00 00 00 
  803ff2:	48 8b 00             	mov    (%rax),%rax
  803ff5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803ffb:	ba 07 00 00 00       	mov    $0x7,%edx
  804000:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804005:	89 c7                	mov    %eax,%edi
  804007:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  80400e:	00 00 00 
  804011:	ff d0                	callq  *%rax
  804013:	85 c0                	test   %eax,%eax
  804015:	79 2a                	jns    804041 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804017:	48 ba 98 4f 80 00 00 	movabs $0x804f98,%rdx
  80401e:	00 00 00 
  804021:	be 23 00 00 00       	mov    $0x23,%esi
  804026:	48 bf bf 4f 80 00 00 	movabs $0x804fbf,%rdi
  80402d:	00 00 00 
  804030:	b8 00 00 00 00       	mov    $0x0,%eax
  804035:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80403c:	00 00 00 
  80403f:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804041:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804048:	00 00 00 
  80404b:	48 8b 00             	mov    (%rax),%rax
  80404e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804054:	48 be 7f 40 80 00 00 	movabs $0x80407f,%rsi
  80405b:	00 00 00 
  80405e:	89 c7                	mov    %eax,%edi
  804060:	48 b8 8c 1e 80 00 00 	movabs $0x801e8c,%rax
  804067:	00 00 00 
  80406a:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  80406c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804073:	00 00 00 
  804076:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80407a:	48 89 10             	mov    %rdx,(%rax)
}
  80407d:	c9                   	leaveq 
  80407e:	c3                   	retq   

000000000080407f <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80407f:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804082:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  804089:	00 00 00 
call *%rax
  80408c:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  80408e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804095:	00 
movq 152(%rsp), %rcx  //Load RSP
  804096:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80409d:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  80409e:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  8040a2:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  8040a5:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8040ac:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  8040ad:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  8040b1:	4c 8b 3c 24          	mov    (%rsp),%r15
  8040b5:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8040ba:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8040bf:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8040c4:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8040c9:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8040ce:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8040d3:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8040d8:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8040dd:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8040e2:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8040e7:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8040ec:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8040f1:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8040f6:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8040fb:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  8040ff:	48 83 c4 08          	add    $0x8,%rsp
popfq
  804103:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  804104:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  804105:	c3                   	retq   

0000000000804106 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804106:	55                   	push   %rbp
  804107:	48 89 e5             	mov    %rsp,%rbp
  80410a:	48 83 ec 30          	sub    $0x30,%rsp
  80410e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804112:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804116:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80411a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804121:	00 00 00 
  804124:	48 8b 00             	mov    (%rax),%rax
  804127:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80412d:	85 c0                	test   %eax,%eax
  80412f:	75 34                	jne    804165 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  804131:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  804138:	00 00 00 
  80413b:	ff d0                	callq  *%rax
  80413d:	25 ff 03 00 00       	and    $0x3ff,%eax
  804142:	48 98                	cltq   
  804144:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80414b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804152:	00 00 00 
  804155:	48 01 c2             	add    %rax,%rdx
  804158:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80415f:	00 00 00 
  804162:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804165:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80416a:	75 0e                	jne    80417a <ipc_recv+0x74>
		pg = (void*) UTOP;
  80416c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804173:	00 00 00 
  804176:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80417a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80417e:	48 89 c7             	mov    %rax,%rdi
  804181:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  804188:	00 00 00 
  80418b:	ff d0                	callq  *%rax
  80418d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804190:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804194:	79 19                	jns    8041af <ipc_recv+0xa9>
		*from_env_store = 0;
  804196:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80419a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8041a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041a4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8041aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041ad:	eb 53                	jmp    804202 <ipc_recv+0xfc>
	}
	if(from_env_store)
  8041af:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8041b4:	74 19                	je     8041cf <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8041b6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8041bd:	00 00 00 
  8041c0:	48 8b 00             	mov    (%rax),%rax
  8041c3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8041c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041cd:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8041cf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8041d4:	74 19                	je     8041ef <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8041d6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8041dd:	00 00 00 
  8041e0:	48 8b 00             	mov    (%rax),%rax
  8041e3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8041e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041ed:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8041ef:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8041f6:	00 00 00 
  8041f9:	48 8b 00             	mov    (%rax),%rax
  8041fc:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804202:	c9                   	leaveq 
  804203:	c3                   	retq   

0000000000804204 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804204:	55                   	push   %rbp
  804205:	48 89 e5             	mov    %rsp,%rbp
  804208:	48 83 ec 30          	sub    $0x30,%rsp
  80420c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80420f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804212:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804216:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804219:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80421e:	75 0e                	jne    80422e <ipc_send+0x2a>
		pg = (void*)UTOP;
  804220:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804227:	00 00 00 
  80422a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80422e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804231:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804234:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804238:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80423b:	89 c7                	mov    %eax,%edi
  80423d:	48 b8 d6 1e 80 00 00 	movabs $0x801ed6,%rax
  804244:	00 00 00 
  804247:	ff d0                	callq  *%rax
  804249:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80424c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804250:	75 0c                	jne    80425e <ipc_send+0x5a>
			sys_yield();
  804252:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  804259:	00 00 00 
  80425c:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80425e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804262:	74 ca                	je     80422e <ipc_send+0x2a>
	if(result != 0)
  804264:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804268:	74 20                	je     80428a <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  80426a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80426d:	89 c6                	mov    %eax,%esi
  80426f:	48 bf d0 4f 80 00 00 	movabs $0x804fd0,%rdi
  804276:	00 00 00 
  804279:	b8 00 00 00 00       	mov    $0x0,%eax
  80427e:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  804285:	00 00 00 
  804288:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  80428a:	c9                   	leaveq 
  80428b:	c3                   	retq   

000000000080428c <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80428c:	55                   	push   %rbp
  80428d:	48 89 e5             	mov    %rsp,%rbp
  804290:	53                   	push   %rbx
  804291:	48 83 ec 58          	sub    $0x58,%rsp
  804295:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  804299:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80429d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  8042a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  8042a8:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8042af:	00 
  8042b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042b4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8042b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042bc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8042c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042c4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8042c8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8042cc:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8042d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042d4:	48 c1 e8 27          	shr    $0x27,%rax
  8042d8:	48 89 c2             	mov    %rax,%rdx
  8042db:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8042e2:	01 00 00 
  8042e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042e9:	83 e0 01             	and    $0x1,%eax
  8042ec:	48 85 c0             	test   %rax,%rax
  8042ef:	0f 85 91 00 00 00    	jne    804386 <ipc_host_recv+0xfa>
  8042f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042f9:	48 c1 e8 1e          	shr    $0x1e,%rax
  8042fd:	48 89 c2             	mov    %rax,%rdx
  804300:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804307:	01 00 00 
  80430a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80430e:	83 e0 01             	and    $0x1,%eax
  804311:	48 85 c0             	test   %rax,%rax
  804314:	74 70                	je     804386 <ipc_host_recv+0xfa>
  804316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80431a:	48 c1 e8 15          	shr    $0x15,%rax
  80431e:	48 89 c2             	mov    %rax,%rdx
  804321:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804328:	01 00 00 
  80432b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80432f:	83 e0 01             	and    $0x1,%eax
  804332:	48 85 c0             	test   %rax,%rax
  804335:	74 4f                	je     804386 <ipc_host_recv+0xfa>
  804337:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80433b:	48 c1 e8 0c          	shr    $0xc,%rax
  80433f:	48 89 c2             	mov    %rax,%rdx
  804342:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804349:	01 00 00 
  80434c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804350:	83 e0 01             	and    $0x1,%eax
  804353:	48 85 c0             	test   %rax,%rax
  804356:	74 2e                	je     804386 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804358:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80435c:	ba 07 04 00 00       	mov    $0x407,%edx
  804361:	48 89 c6             	mov    %rax,%rsi
  804364:	bf 00 00 00 00       	mov    $0x0,%edi
  804369:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  804370:	00 00 00 
  804373:	ff d0                	callq  *%rax
  804375:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  804378:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80437c:	79 08                	jns    804386 <ipc_host_recv+0xfa>
	    	return result;
  80437e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804381:	e9 84 00 00 00       	jmpq   80440a <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  804386:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80438a:	48 c1 e8 0c          	shr    $0xc,%rax
  80438e:	48 89 c2             	mov    %rax,%rdx
  804391:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804398:	01 00 00 
  80439b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80439f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8043a5:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  8043a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8043ae:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8043b2:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8043b6:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8043ba:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8043be:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8043c2:	4c 89 c3             	mov    %r8,%rbx
  8043c5:	0f 01 c1             	vmcall 
  8043c8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  8043cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8043cf:	7e 36                	jle    804407 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  8043d1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8043d4:	41 89 c0             	mov    %eax,%r8d
  8043d7:	b9 03 00 00 00       	mov    $0x3,%ecx
  8043dc:	48 ba e8 4f 80 00 00 	movabs $0x804fe8,%rdx
  8043e3:	00 00 00 
  8043e6:	be 67 00 00 00       	mov    $0x67,%esi
  8043eb:	48 bf 15 50 80 00 00 	movabs $0x805015,%rdi
  8043f2:	00 00 00 
  8043f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8043fa:	49 b9 e5 05 80 00 00 	movabs $0x8005e5,%r9
  804401:	00 00 00 
  804404:	41 ff d1             	callq  *%r9
	return result;
  804407:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  80440a:	48 83 c4 58          	add    $0x58,%rsp
  80440e:	5b                   	pop    %rbx
  80440f:	5d                   	pop    %rbp
  804410:	c3                   	retq   

0000000000804411 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804411:	55                   	push   %rbp
  804412:	48 89 e5             	mov    %rsp,%rbp
  804415:	53                   	push   %rbx
  804416:	48 83 ec 68          	sub    $0x68,%rsp
  80441a:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80441d:	89 75 a8             	mov    %esi,-0x58(%rbp)
  804420:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  804424:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  804427:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80442b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  80442f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  804436:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80443d:	00 
  80443e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804442:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  804446:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80444a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80444e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804452:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804456:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80445a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80445e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804462:	48 c1 e8 27          	shr    $0x27,%rax
  804466:	48 89 c2             	mov    %rax,%rdx
  804469:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804470:	01 00 00 
  804473:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804477:	83 e0 01             	and    $0x1,%eax
  80447a:	48 85 c0             	test   %rax,%rax
  80447d:	0f 85 88 00 00 00    	jne    80450b <ipc_host_send+0xfa>
  804483:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804487:	48 c1 e8 1e          	shr    $0x1e,%rax
  80448b:	48 89 c2             	mov    %rax,%rdx
  80448e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804495:	01 00 00 
  804498:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80449c:	83 e0 01             	and    $0x1,%eax
  80449f:	48 85 c0             	test   %rax,%rax
  8044a2:	74 67                	je     80450b <ipc_host_send+0xfa>
  8044a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044a8:	48 c1 e8 15          	shr    $0x15,%rax
  8044ac:	48 89 c2             	mov    %rax,%rdx
  8044af:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8044b6:	01 00 00 
  8044b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044bd:	83 e0 01             	and    $0x1,%eax
  8044c0:	48 85 c0             	test   %rax,%rax
  8044c3:	74 46                	je     80450b <ipc_host_send+0xfa>
  8044c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044c9:	48 c1 e8 0c          	shr    $0xc,%rax
  8044cd:	48 89 c2             	mov    %rax,%rdx
  8044d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044d7:	01 00 00 
  8044da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044de:	83 e0 01             	and    $0x1,%eax
  8044e1:	48 85 c0             	test   %rax,%rax
  8044e4:	74 25                	je     80450b <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8044e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044ea:	48 c1 e8 0c          	shr    $0xc,%rax
  8044ee:	48 89 c2             	mov    %rax,%rdx
  8044f1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044f8:	01 00 00 
  8044fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044ff:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804505:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804509:	eb 0e                	jmp    804519 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  80450b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804512:	00 00 00 
  804515:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  804519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80451d:	48 89 c6             	mov    %rax,%rsi
  804520:	48 bf 1f 50 80 00 00 	movabs $0x80501f,%rdi
  804527:	00 00 00 
  80452a:	b8 00 00 00 00       	mov    $0x0,%eax
  80452f:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  804536:	00 00 00 
  804539:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  80453b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80453e:	48 98                	cltq   
  804540:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  804544:	8b 45 a8             	mov    -0x58(%rbp),%eax
  804547:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  80454b:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80454e:	48 98                	cltq   
  804550:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  804554:	b8 02 00 00 00       	mov    $0x2,%eax
  804559:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80455d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  804561:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  804565:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804569:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80456d:	4c 89 c3             	mov    %r8,%rbx
  804570:	0f 01 c1             	vmcall 
  804573:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  804576:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  80457a:	75 0c                	jne    804588 <ipc_host_send+0x177>
			sys_yield();
  80457c:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  804583:	00 00 00 
  804586:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  804588:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  80458c:	74 c6                	je     804554 <ipc_host_send+0x143>
	
	if(result !=0)
  80458e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  804592:	74 36                	je     8045ca <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  804594:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804597:	41 89 c0             	mov    %eax,%r8d
  80459a:	b9 02 00 00 00       	mov    $0x2,%ecx
  80459f:	48 ba e8 4f 80 00 00 	movabs $0x804fe8,%rdx
  8045a6:	00 00 00 
  8045a9:	be 94 00 00 00       	mov    $0x94,%esi
  8045ae:	48 bf 15 50 80 00 00 	movabs $0x805015,%rdi
  8045b5:	00 00 00 
  8045b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8045bd:	49 b9 e5 05 80 00 00 	movabs $0x8005e5,%r9
  8045c4:	00 00 00 
  8045c7:	41 ff d1             	callq  *%r9
}
  8045ca:	48 83 c4 68          	add    $0x68,%rsp
  8045ce:	5b                   	pop    %rbx
  8045cf:	5d                   	pop    %rbp
  8045d0:	c3                   	retq   

00000000008045d1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8045d1:	55                   	push   %rbp
  8045d2:	48 89 e5             	mov    %rsp,%rbp
  8045d5:	48 83 ec 14          	sub    $0x14,%rsp
  8045d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8045dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045e3:	eb 4e                	jmp    804633 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8045e5:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8045ec:	00 00 00 
  8045ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045f2:	48 98                	cltq   
  8045f4:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8045fb:	48 01 d0             	add    %rdx,%rax
  8045fe:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804604:	8b 00                	mov    (%rax),%eax
  804606:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804609:	75 24                	jne    80462f <ipc_find_env+0x5e>
			return envs[i].env_id;
  80460b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804612:	00 00 00 
  804615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804618:	48 98                	cltq   
  80461a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804621:	48 01 d0             	add    %rdx,%rax
  804624:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80462a:	8b 40 08             	mov    0x8(%rax),%eax
  80462d:	eb 12                	jmp    804641 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80462f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804633:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80463a:	7e a9                	jle    8045e5 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80463c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804641:	c9                   	leaveq 
  804642:	c3                   	retq   

0000000000804643 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804643:	55                   	push   %rbp
  804644:	48 89 e5             	mov    %rsp,%rbp
  804647:	48 83 ec 18          	sub    $0x18,%rsp
  80464b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80464f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804653:	48 c1 e8 15          	shr    $0x15,%rax
  804657:	48 89 c2             	mov    %rax,%rdx
  80465a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804661:	01 00 00 
  804664:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804668:	83 e0 01             	and    $0x1,%eax
  80466b:	48 85 c0             	test   %rax,%rax
  80466e:	75 07                	jne    804677 <pageref+0x34>
		return 0;
  804670:	b8 00 00 00 00       	mov    $0x0,%eax
  804675:	eb 53                	jmp    8046ca <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80467b:	48 c1 e8 0c          	shr    $0xc,%rax
  80467f:	48 89 c2             	mov    %rax,%rdx
  804682:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804689:	01 00 00 
  80468c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804690:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804694:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804698:	83 e0 01             	and    $0x1,%eax
  80469b:	48 85 c0             	test   %rax,%rax
  80469e:	75 07                	jne    8046a7 <pageref+0x64>
		return 0;
  8046a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8046a5:	eb 23                	jmp    8046ca <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8046a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8046af:	48 89 c2             	mov    %rax,%rdx
  8046b2:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8046b9:	00 00 00 
  8046bc:	48 c1 e2 04          	shl    $0x4,%rdx
  8046c0:	48 01 d0             	add    %rdx,%rax
  8046c3:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8046c7:	0f b7 c0             	movzwl %ax,%eax
}
  8046ca:	c9                   	leaveq 
  8046cb:	c3                   	retq   
