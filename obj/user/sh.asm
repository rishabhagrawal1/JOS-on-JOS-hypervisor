
obj/user/sh:     file format elf64-x86-64


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
  80003c:	e8 4b 12 00 00       	callq  80128c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 60 05 00 00 	sub    $0x560,%rsp
  80004e:	48 89 bd a8 fa ff ff 	mov    %rdi,-0x558(%rbp)
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	gettoken(s, 0);
  80005c:	48 8b 85 a8 fa ff ff 	mov    -0x558(%rbp),%rax
  800063:	be 00 00 00 00       	mov    $0x0,%esi
  800068:	48 89 c7             	mov    %rax,%rdi
  80006b:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800072:	00 00 00 
  800075:	ff d0                	callq  *%rax

again:
	argc = 0;
  800077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80007e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800085:	48 89 c6             	mov    %rax,%rsi
  800088:	bf 00 00 00 00       	mov    $0x0,%edi
  80008d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
  800099:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80009c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80009f:	83 f8 3e             	cmp    $0x3e,%eax
  8000a2:	0f 84 4c 01 00 00    	je     8001f4 <runcmd+0x1b1>
  8000a8:	83 f8 3e             	cmp    $0x3e,%eax
  8000ab:	7f 12                	jg     8000bf <runcmd+0x7c>
  8000ad:	85 c0                	test   %eax,%eax
  8000af:	0f 84 b9 03 00 00    	je     80046e <runcmd+0x42b>
  8000b5:	83 f8 3c             	cmp    $0x3c,%eax
  8000b8:	74 64                	je     80011e <runcmd+0xdb>
  8000ba:	e9 7a 03 00 00       	jmpq   800439 <runcmd+0x3f6>
  8000bf:	83 f8 77             	cmp    $0x77,%eax
  8000c2:	74 0e                	je     8000d2 <runcmd+0x8f>
  8000c4:	83 f8 7c             	cmp    $0x7c,%eax
  8000c7:	0f 84 fd 01 00 00    	je     8002ca <runcmd+0x287>
  8000cd:	e9 67 03 00 00       	jmpq   800439 <runcmd+0x3f6>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8000d2:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
  8000d6:	75 27                	jne    8000ff <runcmd+0xbc>
				cprintf("too many arguments\n");
  8000d8:	48 bf c8 61 80 00 00 	movabs $0x8061c8,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  8000ee:	00 00 00 
  8000f1:	ff d2                	callq  *%rdx
				exit();
  8000f3:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	callq  *%rax
			}
			argv[argc++] = t;
  8000ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800102:	8d 50 01             	lea    0x1(%rax),%edx
  800105:	89 55 fc             	mov    %edx,-0x4(%rbp)
  800108:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80010f:	48 98                	cltq   
  800111:	48 89 94 c5 60 ff ff 	mov    %rdx,-0xa0(%rbp,%rax,8)
  800118:	ff 
			break;
  800119:	e9 4b 03 00 00       	jmpq   800469 <runcmd+0x426>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80011e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800125:	48 89 c6             	mov    %rax,%rsi
  800128:	bf 00 00 00 00       	mov    $0x0,%edi
  80012d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	83 f8 77             	cmp    $0x77,%eax
  80013c:	74 27                	je     800165 <runcmd+0x122>
				cprintf("syntax error: < not followed by word\n");
  80013e:	48 bf e0 61 80 00 00 	movabs $0x8061e0,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  800165:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	48 89 c7             	mov    %rax,%rdi
  800174:	48 b8 29 43 80 00 00 	movabs $0x804329,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800187:	79 34                	jns    8001bd <runcmd+0x17a>
				cprintf("open %s for read: %e", t, fd);
  800189:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800190:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 bf 06 62 80 00 00 	movabs $0x806206,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 6b 15 80 00 00 	movabs $0x80156b,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx
				exit();
  8001b1:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  8001b8:	00 00 00 
  8001bb:	ff d0                	callq  *%rax
			}
			if (fd != 0) {
  8001bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001c1:	74 2c                	je     8001ef <runcmd+0x1ac>
				dup(fd, 0);
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	be 00 00 00 00       	mov    $0x0,%esi
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 dd 3c 80 00 00 	movabs $0x803cdd,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
				close(fd);
  8001d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
			}
			break;
  8001ea:	e9 7a 02 00 00       	jmpq   800469 <runcmd+0x426>
  8001ef:	e9 75 02 00 00       	jmpq   800469 <runcmd+0x426>

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8001f4:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  8001fb:	48 89 c6             	mov    %rax,%rsi
  8001fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800203:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	callq  *%rax
  80020f:	83 f8 77             	cmp    $0x77,%eax
  800212:	74 27                	je     80023b <runcmd+0x1f8>
				cprintf("syntax error: > not followed by word\n");
  800214:	48 bf 20 62 80 00 00 	movabs $0x806220,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
				exit();
  80022f:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80023b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800242:	be 01 03 00 00       	mov    $0x301,%esi
  800247:	48 89 c7             	mov    %rax,%rdi
  80024a:	48 b8 29 43 80 00 00 	movabs $0x804329,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
  800256:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025d:	79 34                	jns    800293 <runcmd+0x250>
				cprintf("open %s for write: %e", t, fd);
  80025f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800266:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800269:	48 89 c6             	mov    %rax,%rsi
  80026c:	48 bf 46 62 80 00 00 	movabs $0x806246,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 b9 6b 15 80 00 00 	movabs $0x80156b,%rcx
  800282:	00 00 00 
  800285:	ff d1                	callq  *%rcx
				exit();
  800287:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
			}
			if (fd != 1) {
  800293:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  800297:	74 2c                	je     8002c5 <runcmd+0x282>
				dup(fd, 1);
  800299:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80029c:	be 01 00 00 00       	mov    $0x1,%esi
  8002a1:	89 c7                	mov    %eax,%edi
  8002a3:	48 b8 dd 3c 80 00 00 	movabs $0x803cdd,%rax
  8002aa:	00 00 00 
  8002ad:	ff d0                	callq  *%rax
				close(fd);
  8002af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b2:	89 c7                	mov    %eax,%edi
  8002b4:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
			}
			break;
  8002c0:	e9 a4 01 00 00       	jmpq   800469 <runcmd+0x426>
  8002c5:	e9 9f 01 00 00       	jmpq   800469 <runcmd+0x426>

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8002ca:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002d1:	48 89 c7             	mov    %rax,%rdi
  8002d4:	48 b8 8f 57 80 00 00 	movabs $0x80578f,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
  8002e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e7:	79 2c                	jns    800315 <runcmd+0x2d2>
				cprintf("pipe: %e", r);
  8002e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002ec:	89 c6                	mov    %eax,%esi
  8002ee:	48 bf 5c 62 80 00 00 	movabs $0x80625c,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800304:	00 00 00 
  800307:	ff d2                	callq  *%rdx
				exit();
  800309:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
			}
			if (debug)
  800315:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80031c:	00 00 00 
  80031f:	8b 00                	mov    (%rax),%eax
  800321:	85 c0                	test   %eax,%eax
  800323:	74 29                	je     80034e <runcmd+0x30b>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800325:	8b 95 44 fb ff ff    	mov    -0x4bc(%rbp),%edx
  80032b:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800331:	89 c6                	mov    %eax,%esi
  800333:	48 bf 65 62 80 00 00 	movabs $0x806265,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	48 b9 6b 15 80 00 00 	movabs $0x80156b,%rcx
  800349:	00 00 00 
  80034c:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034e:	48 b8 e0 33 80 00 00 	movabs $0x8033e0,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax
  80035a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800361:	79 2c                	jns    80038f <runcmd+0x34c>
				cprintf("fork: %e", r);
  800363:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf 72 62 80 00 00 	movabs $0x806272,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
				exit();
  800383:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  80038a:	00 00 00 
  80038d:	ff d0                	callq  *%rax
			}
			if (r == 0) {
  80038f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800393:	75 50                	jne    8003e5 <runcmd+0x3a2>
				if (p[0] != 0) {
  800395:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	74 2d                	je     8003cc <runcmd+0x389>
					dup(p[0], 0);
  80039f:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003a5:	be 00 00 00 00       	mov    $0x0,%esi
  8003aa:	89 c7                	mov    %eax,%edi
  8003ac:	48 b8 dd 3c 80 00 00 	movabs $0x803cdd,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
					close(p[0]);
  8003b8:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003be:	89 c7                	mov    %eax,%edi
  8003c0:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003cc:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003d2:	89 c7                	mov    %eax,%edi
  8003d4:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	callq  *%rax
				goto again;
  8003e0:	e9 92 fc ff ff       	jmpq   800077 <runcmd+0x34>
			} else {
				pipe_child = r;
  8003e5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%rbp)
				if (p[1] != 1) {
  8003eb:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003f1:	83 f8 01             	cmp    $0x1,%eax
  8003f4:	74 2d                	je     800423 <runcmd+0x3e0>
					dup(p[1], 1);
  8003f6:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003fc:	be 01 00 00 00       	mov    $0x1,%esi
  800401:	89 c7                	mov    %eax,%edi
  800403:	48 b8 dd 3c 80 00 00 	movabs $0x803cdd,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax
					close(p[1]);
  80040f:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800415:	89 c7                	mov    %eax,%edi
  800417:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800423:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800429:	89 c7                	mov    %eax,%edi
  80042b:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  800432:	00 00 00 
  800435:	ff d0                	callq  *%rax
				goto runit;
  800437:	eb 36                	jmp    80046f <runcmd+0x42c>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800439:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80043c:	89 c1                	mov    %eax,%ecx
  80043e:	48 ba 7b 62 80 00 00 	movabs $0x80627b,%rdx
  800445:	00 00 00 
  800448:	be 6f 00 00 00       	mov    $0x6f,%esi
  80044d:	48 bf 97 62 80 00 00 	movabs $0x806297,%rdi
  800454:	00 00 00 
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  800463:	00 00 00 
  800466:	41 ff d0             	callq  *%r8
			break;

		}
	}
  800469:	e9 10 fc ff ff       	jmpq   80007e <runcmd+0x3b>
			panic("| not implemented");
			break;

		case 0:		// String is complete
			// Run the current command!
			goto runit;
  80046e:	90                   	nop
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  80046f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800473:	75 34                	jne    8004a9 <runcmd+0x466>
		if (debug)
  800475:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80047c:	00 00 00 
  80047f:	8b 00                	mov    (%rax),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	0f 84 79 03 00 00    	je     800802 <runcmd+0x7bf>
			cprintf("EMPTY COMMAND\n");
  800489:	48 bf a1 62 80 00 00 	movabs $0x8062a1,%rdi
  800490:	00 00 00 
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  80049f:	00 00 00 
  8004a2:	ff d2                	callq  *%rdx
		return;
  8004a4:	e9 59 03 00 00       	jmpq   800802 <runcmd+0x7bf>
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  8004a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004b0:	e9 8a 00 00 00       	jmpq   80053f <runcmd+0x4fc>
		strcpy(argv0buf, PATH[i]);
  8004b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8004bc:	00 00 00 
  8004bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8004c2:	48 63 d2             	movslq %edx,%rdx
  8004c5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004c9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004d0:	48 89 d6             	mov    %rdx,%rsi
  8004d3:	48 89 c7             	mov    %rax,%rdi
  8004d6:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
		strcat(argv0buf, argv[0]);
  8004e2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004e9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f0:	48 89 d6             	mov    %rdx,%rsi
  8004f3:	48 89 c7             	mov    %rax,%rdi
  8004f6:	48 b8 bd 22 80 00 00 	movabs $0x8022bd,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
		r = stat(argv0buf, &st);
  800502:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  800509:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800510:	48 89 d6             	mov    %rdx,%rsi
  800513:	48 89 c7             	mov    %rax,%rdi
  800516:	48 b8 3b 42 80 00 00 	movabs $0x80423b,%rax
  80051d:	00 00 00 
  800520:	ff d0                	callq  *%rax
  800522:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r==0) {
  800525:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800529:	75 10                	jne    80053b <runcmd+0x4f8>
			argv[0] = argv0buf;
  80052b:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800532:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
			break; 
  800539:	eb 19                	jmp    800554 <runcmd+0x511>
		return;
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  80053b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80053f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800546:	00 00 00 
  800549:	8b 00                	mov    (%rax),%eax
  80054b:	39 45 f8             	cmp    %eax,-0x8(%rbp)
  80054e:	0f 8c 61 ff ff ff    	jl     8004b5 <runcmd+0x472>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800554:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80055b:	0f b6 00             	movzbl (%rax),%eax
  80055e:	3c 2f                	cmp    $0x2f,%al
  800560:	74 39                	je     80059b <runcmd+0x558>
		argv0buf[0] = '/';
  800562:	c6 85 50 fb ff ff 2f 	movb   $0x2f,-0x4b0(%rbp)
		strcpy(argv0buf + 1, argv[0]);
  800569:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800570:	48 8d 95 50 fb ff ff 	lea    -0x4b0(%rbp),%rdx
  800577:	48 83 c2 01          	add    $0x1,%rdx
  80057b:	48 89 c6             	mov    %rax,%rsi
  80057e:	48 89 d7             	mov    %rdx,%rdi
  800581:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  800588:	00 00 00 
  80058b:	ff d0                	callq  *%rax
		argv[0] = argv0buf;
  80058d:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800594:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
	}
	argv[argc] = 0;
  80059b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059e:	48 98                	cltq   
  8005a0:	48 c7 84 c5 60 ff ff 	movq   $0x0,-0xa0(%rbp,%rax,8)
  8005a7:	ff 00 00 00 00 

	// Print the command.
	if (debug) {
  8005ac:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8005b3:	00 00 00 
  8005b6:	8b 00                	mov    (%rax),%eax
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	0f 84 95 00 00 00    	je     800655 <runcmd+0x612>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8005c0:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8005c7:	00 00 00 
  8005ca:	48 8b 00             	mov    (%rax),%rax
  8005cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8005d3:	89 c6                	mov    %eax,%esi
  8005d5:	48 bf b0 62 80 00 00 	movabs $0x8062b0,%rdi
  8005dc:	00 00 00 
  8005df:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e4:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  8005eb:	00 00 00 
  8005ee:	ff d2                	callq  *%rdx
		for (i = 0; argv[i]; i++)
  8005f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8005f7:	eb 2f                	jmp    800628 <runcmd+0x5e5>
			cprintf(" %s", argv[i]);
  8005f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fc:	48 98                	cltq   
  8005fe:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800605:	ff 
  800606:	48 89 c6             	mov    %rax,%rsi
  800609:	48 bf be 62 80 00 00 	movabs $0x8062be,%rdi
  800610:	00 00 00 
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  80061f:	00 00 00 
  800622:	ff d2                	callq  *%rdx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800624:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800628:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062b:	48 98                	cltq   
  80062d:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800634:	ff 
  800635:	48 85 c0             	test   %rax,%rax
  800638:	75 bf                	jne    8005f9 <runcmd+0x5b6>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80063a:	48 bf c2 62 80 00 00 	movabs $0x8062c2,%rdi
  800641:	00 00 00 
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800650:	00 00 00 
  800653:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800655:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80065c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800663:	48 89 d6             	mov    %rdx,%rsi
  800666:	48 89 c7             	mov    %rax,%rdi
  800669:	48 b8 43 4c 80 00 00 	movabs $0x804c43,%rax
  800670:	00 00 00 
  800673:	ff d0                	callq  *%rax
  800675:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800678:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80067c:	79 28                	jns    8006a6 <runcmd+0x663>
		cprintf("spawn %s: %e\n", argv[0], r);
  80067e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800685:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800688:	48 89 c6             	mov    %rax,%rsi
  80068b:	48 bf c4 62 80 00 00 	movabs $0x8062c4,%rdi
  800692:	00 00 00 
  800695:	b8 00 00 00 00       	mov    $0x0,%eax
  80069a:	48 b9 6b 15 80 00 00 	movabs $0x80156b,%rcx
  8006a1:	00 00 00 
  8006a4:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006a6:	48 b8 af 3c 80 00 00 	movabs $0x803caf,%rax
  8006ad:	00 00 00 
  8006b0:	ff d0                	callq  *%rax
	if (r >= 0) {
  8006b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8006b6:	0f 88 9c 00 00 00    	js     800758 <runcmd+0x715>
		if (debug)
  8006bc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8006c3:	00 00 00 
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	74 3b                	je     800707 <runcmd+0x6c4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8006cc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8006d3:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8006da:	00 00 00 
  8006dd:	48 8b 00             	mov    (%rax),%rax
  8006e0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8006e6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8006e9:	89 c6                	mov    %eax,%esi
  8006eb:	48 bf d2 62 80 00 00 	movabs $0x8062d2,%rdi
  8006f2:	00 00 00 
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fa:	49 b8 6b 15 80 00 00 	movabs $0x80156b,%r8
  800701:	00 00 00 
  800704:	41 ff d0             	callq  *%r8
		wait(r);
  800707:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070a:	89 c7                	mov    %eax,%edi
  80070c:	48 b8 58 5d 80 00 00 	movabs $0x805d58,%rax
  800713:	00 00 00 
  800716:	ff d0                	callq  *%rax
		if (debug)
  800718:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80071f:	00 00 00 
  800722:	8b 00                	mov    (%rax),%eax
  800724:	85 c0                	test   %eax,%eax
  800726:	74 30                	je     800758 <runcmd+0x715>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800728:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80072f:	00 00 00 
  800732:	48 8b 00             	mov    (%rax),%rax
  800735:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80073b:	89 c6                	mov    %eax,%esi
  80073d:	48 bf e7 62 80 00 00 	movabs $0x8062e7,%rdi
  800744:	00 00 00 
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800753:	00 00 00 
  800756:	ff d2                	callq  *%rdx
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800758:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80075c:	0f 84 94 00 00 00    	je     8007f6 <runcmd+0x7b3>
		if (debug)
  800762:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800769:	00 00 00 
  80076c:	8b 00                	mov    (%rax),%eax
  80076e:	85 c0                	test   %eax,%eax
  800770:	74 33                	je     8007a5 <runcmd+0x762>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800772:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  800779:	00 00 00 
  80077c:	48 8b 00             	mov    (%rax),%rax
  80077f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800785:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800788:	89 c6                	mov    %eax,%esi
  80078a:	48 bf fd 62 80 00 00 	movabs $0x8062fd,%rdi
  800791:	00 00 00 
  800794:	b8 00 00 00 00       	mov    $0x0,%eax
  800799:	48 b9 6b 15 80 00 00 	movabs $0x80156b,%rcx
  8007a0:	00 00 00 
  8007a3:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007a8:	89 c7                	mov    %eax,%edi
  8007aa:	48 b8 58 5d 80 00 00 	movabs $0x805d58,%rax
  8007b1:	00 00 00 
  8007b4:	ff d0                	callq  *%rax
		if (debug)
  8007b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8007bd:	00 00 00 
  8007c0:	8b 00                	mov    (%rax),%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 30                	je     8007f6 <runcmd+0x7b3>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8007c6:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8007cd:	00 00 00 
  8007d0:	48 8b 00             	mov    (%rax),%rax
  8007d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8007d9:	89 c6                	mov    %eax,%esi
  8007db:	48 bf e7 62 80 00 00 	movabs $0x8062e7,%rdi
  8007e2:	00 00 00 
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  8007f1:	00 00 00 
  8007f4:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007f6:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  8007fd:	00 00 00 
  800800:	ff d0                	callq  *%rax
}
  800802:	c9                   	leaveq 
  800803:	c3                   	retq   

0000000000800804 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800804:	55                   	push   %rbp
  800805:	48 89 e5             	mov    %rsp,%rbp
  800808:	48 83 ec 30          	sub    $0x30,%rsp
  80080c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800810:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800814:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int t;

	if (s == 0) {
  800818:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80081d:	75 36                	jne    800855 <_gettoken+0x51>
		if (debug > 1)
  80081f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800826:	00 00 00 
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	83 f8 01             	cmp    $0x1,%eax
  80082e:	7e 1b                	jle    80084b <_gettoken+0x47>
			cprintf("GETTOKEN NULL\n");
  800830:	48 bf 1a 63 80 00 00 	movabs $0x80631a,%rdi
  800837:	00 00 00 
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800846:	00 00 00 
  800849:	ff d2                	callq  *%rdx
		return 0;
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	e9 04 02 00 00       	jmpq   800a59 <_gettoken+0x255>
	}

	if (debug > 1)
  800855:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80085c:	00 00 00 
  80085f:	8b 00                	mov    (%rax),%eax
  800861:	83 f8 01             	cmp    $0x1,%eax
  800864:	7e 22                	jle    800888 <_gettoken+0x84>
		cprintf("GETTOKEN: %s\n", s);
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	48 89 c6             	mov    %rax,%rsi
  80086d:	48 bf 29 63 80 00 00 	movabs $0x806329,%rdi
  800874:	00 00 00 
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800883:	00 00 00 
  800886:	ff d2                	callq  *%rdx

	*p1 = 0;
  800888:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80088c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*p2 = 0;
  800893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800897:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	while (strchr(WHITESPACE, *s))
  80089e:	eb 0f                	jmp    8008af <_gettoken+0xab>
		*s++ = 0;
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008ac:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8008af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b3:	0f b6 00             	movzbl (%rax),%eax
  8008b6:	0f be c0             	movsbl %al,%eax
  8008b9:	89 c6                	mov    %eax,%esi
  8008bb:	48 bf 37 63 80 00 00 	movabs $0x806337,%rdi
  8008c2:	00 00 00 
  8008c5:	48 b8 a0 24 80 00 00 	movabs $0x8024a0,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
  8008d1:	48 85 c0             	test   %rax,%rax
  8008d4:	75 ca                	jne    8008a0 <_gettoken+0x9c>
		*s++ = 0;
	if (*s == 0) {
  8008d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008da:	0f b6 00             	movzbl (%rax),%eax
  8008dd:	84 c0                	test   %al,%al
  8008df:	75 36                	jne    800917 <_gettoken+0x113>
		if (debug > 1)
  8008e1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8008e8:	00 00 00 
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	83 f8 01             	cmp    $0x1,%eax
  8008f0:	7e 1b                	jle    80090d <_gettoken+0x109>
			cprintf("EOL\n");
  8008f2:	48 bf 3c 63 80 00 00 	movabs $0x80633c,%rdi
  8008f9:	00 00 00 
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800908:	00 00 00 
  80090b:	ff d2                	callq  *%rdx
		return 0;
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	e9 42 01 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	if (strchr(SYMBOLS, *s)) {
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	0f be c0             	movsbl %al,%eax
  800921:	89 c6                	mov    %eax,%esi
  800923:	48 bf 41 63 80 00 00 	movabs $0x806341,%rdi
  80092a:	00 00 00 
  80092d:	48 b8 a0 24 80 00 00 	movabs $0x8024a0,%rax
  800934:	00 00 00 
  800937:	ff d0                	callq  *%rax
  800939:	48 85 c0             	test   %rax,%rax
  80093c:	74 6b                	je     8009a9 <_gettoken+0x1a5>
		t = *s;
  80093e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800942:	0f b6 00             	movzbl (%rax),%eax
  800945:	0f be c0             	movsbl %al,%eax
  800948:	89 45 fc             	mov    %eax,-0x4(%rbp)
		*p1 = s;
  80094b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80094f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800953:	48 89 10             	mov    %rdx,(%rax)
		*s++ = 0;
  800956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80095e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800962:	c6 00 00             	movb   $0x0,(%rax)
		*p2 = s;
  800965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800969:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096d:	48 89 10             	mov    %rdx,(%rax)
		if (debug > 1)
  800970:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800977:	00 00 00 
  80097a:	8b 00                	mov    (%rax),%eax
  80097c:	83 f8 01             	cmp    $0x1,%eax
  80097f:	7e 20                	jle    8009a1 <_gettoken+0x19d>
			cprintf("TOK %c\n", t);
  800981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800984:	89 c6                	mov    %eax,%esi
  800986:	48 bf 49 63 80 00 00 	movabs $0x806349,%rdi
  80098d:	00 00 00 
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
  800995:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  80099c:	00 00 00 
  80099f:	ff d2                	callq  *%rdx
		return t;
  8009a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a4:	e9 b0 00 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	*p1 = s;
  8009a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b1:	48 89 10             	mov    %rdx,(%rax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009b4:	eb 05                	jmp    8009bb <_gettoken+0x1b7>
		s++;
  8009b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	0f b6 00             	movzbl (%rax),%eax
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 27                	je     8009ed <_gettoken+0x1e9>
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	0f b6 00             	movzbl (%rax),%eax
  8009cd:	0f be c0             	movsbl %al,%eax
  8009d0:	89 c6                	mov    %eax,%esi
  8009d2:	48 bf 51 63 80 00 00 	movabs $0x806351,%rdi
  8009d9:	00 00 00 
  8009dc:	48 b8 a0 24 80 00 00 	movabs $0x8024a0,%rax
  8009e3:	00 00 00 
  8009e6:	ff d0                	callq  *%rax
  8009e8:	48 85 c0             	test   %rax,%rax
  8009eb:	74 c9                	je     8009b6 <_gettoken+0x1b2>
		s++;
	*p2 = s;
  8009ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	48 89 10             	mov    %rdx,(%rax)
	if (debug > 1) {
  8009f8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8009ff:	00 00 00 
  800a02:	8b 00                	mov    (%rax),%eax
  800a04:	83 f8 01             	cmp    $0x1,%eax
  800a07:	7e 4b                	jle    800a54 <_gettoken+0x250>
		t = **p2;
  800a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a0d:	48 8b 00             	mov    (%rax),%rax
  800a10:	0f b6 00             	movzbl (%rax),%eax
  800a13:	0f be c0             	movsbl %al,%eax
  800a16:	89 45 fc             	mov    %eax,-0x4(%rbp)
		**p2 = 0;
  800a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1d:	48 8b 00             	mov    (%rax),%rax
  800a20:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("WORD: %s\n", *p1);
  800a23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a27:	48 8b 00             	mov    (%rax),%rax
  800a2a:	48 89 c6             	mov    %rax,%rsi
  800a2d:	48 bf 5d 63 80 00 00 	movabs $0x80635d,%rdi
  800a34:	00 00 00 
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800a43:	00 00 00 
  800a46:	ff d2                	callq  *%rdx
		**p2 = t;
  800a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a4c:	48 8b 00             	mov    (%rax),%rax
  800a4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a52:	88 10                	mov    %dl,(%rax)
	}
	return 'w';
  800a54:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800a59:	c9                   	leaveq 
  800a5a:	c3                   	retq   

0000000000800a5b <gettoken>:

int
gettoken(char *s, char **p1)
{
  800a5b:	55                   	push   %rbp
  800a5c:	48 89 e5             	mov    %rsp,%rbp
  800a5f:	48 83 ec 10          	sub    $0x10,%rsp
  800a63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800a6b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800a70:	74 3a                	je     800aac <gettoken+0x51>
		nc = _gettoken(s, &np1, &np2);
  800a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a76:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800a7d:	00 00 00 
  800a80:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800a87:	00 00 00 
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
  800a99:	48 ba 18 90 80 00 00 	movabs $0x809018,%rdx
  800aa0:	00 00 00 
  800aa3:	89 02                	mov    %eax,(%rdx)
		return 0;
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaa:	eb 74                	jmp    800b20 <gettoken+0xc5>
	}
	c = nc;
  800aac:	48 b8 18 90 80 00 00 	movabs $0x809018,%rax
  800ab3:	00 00 00 
  800ab6:	8b 10                	mov    (%rax),%edx
  800ab8:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
  800abf:	00 00 00 
  800ac2:	89 10                	mov    %edx,(%rax)
	*p1 = np1;
  800ac4:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  800acb:	00 00 00 
  800ace:	48 8b 10             	mov    (%rax),%rdx
  800ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad5:	48 89 10             	mov    %rdx,(%rax)
	nc = _gettoken(np2, &np1, &np2);
  800ad8:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  800adf:	00 00 00 
  800ae2:	48 8b 00             	mov    (%rax),%rax
  800ae5:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800aec:	00 00 00 
  800aef:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800af6:	00 00 00 
  800af9:	48 89 c7             	mov    %rax,%rdi
  800afc:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800b03:	00 00 00 
  800b06:	ff d0                	callq  *%rax
  800b08:	48 ba 18 90 80 00 00 	movabs $0x809018,%rdx
  800b0f:	00 00 00 
  800b12:	89 02                	mov    %eax,(%rdx)
	return c;
  800b14:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
  800b1b:	00 00 00 
  800b1e:	8b 00                	mov    (%rax),%eax
}
  800b20:	c9                   	leaveq 
  800b21:	c3                   	retq   

0000000000800b22 <usage>:


void
usage(void)
{
  800b22:	55                   	push   %rbp
  800b23:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: sh [-dix] [command-file]\n");
  800b26:	48 bf 68 63 80 00 00 	movabs $0x806368,%rdi
  800b2d:	00 00 00 
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800b3c:	00 00 00 
  800b3f:	ff d2                	callq  *%rdx
	exit();
  800b41:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  800b48:	00 00 00 
  800b4b:	ff d0                	callq  *%rax
}
  800b4d:	5d                   	pop    %rbp
  800b4e:	c3                   	retq   

0000000000800b4f <umain>:

void
umain(int argc, char **argv)
{
  800b4f:	55                   	push   %rbp
  800b50:	48 89 e5             	mov    %rsp,%rbp
  800b53:	48 83 ec 50          	sub    $0x50,%rsp
  800b57:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800b5a:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int r, interactive, echocmds;
	struct Argstate args;
	bool auto_terminate = false;
  800b5e:	c6 45 f7 00          	movb   $0x0,-0x9(%rbp)
	interactive = '?';
  800b62:	c7 45 fc 3f 00 00 00 	movl   $0x3f,-0x4(%rbp)
	echocmds = 0;
  800b69:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	argstart(&argc, argv, &args);
  800b70:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  800b74:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800b78:	48 8d 45 bc          	lea    -0x44(%rbp),%rax
  800b7c:	48 89 ce             	mov    %rcx,%rsi
  800b7f:	48 89 c7             	mov    %rax,%rdi
  800b82:	48 b8 89 36 80 00 00 	movabs $0x803689,%rax
  800b89:	00 00 00 
  800b8c:	ff d0                	callq  *%rax
	while ((r = argnext(&args)) >= 0)
  800b8e:	eb 4d                	jmp    800bdd <umain+0x8e>
		switch (r) {
  800b90:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800b93:	83 f8 69             	cmp    $0x69,%eax
  800b96:	74 27                	je     800bbf <umain+0x70>
  800b98:	83 f8 78             	cmp    $0x78,%eax
  800b9b:	74 2b                	je     800bc8 <umain+0x79>
  800b9d:	83 f8 64             	cmp    $0x64,%eax
  800ba0:	75 2f                	jne    800bd1 <umain+0x82>
		case 'd':
			debug++;
  800ba2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800ba9:	00 00 00 
  800bac:	8b 00                	mov    (%rax),%eax
  800bae:	8d 50 01             	lea    0x1(%rax),%edx
  800bb1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800bb8:	00 00 00 
  800bbb:	89 10                	mov    %edx,(%rax)
			break;
  800bbd:	eb 1e                	jmp    800bdd <umain+0x8e>
		case 'i':
			interactive = 1;
  800bbf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
			break;
  800bc6:	eb 15                	jmp    800bdd <umain+0x8e>
		case 'x':
			echocmds = 1;
  800bc8:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
			break;
  800bcf:	eb 0c                	jmp    800bdd <umain+0x8e>
		default:
			usage();
  800bd1:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800bd8:	00 00 00 
  800bdb:	ff d0                	callq  *%rax
	struct Argstate args;
	bool auto_terminate = false;
	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800bdd:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  800be1:	48 89 c7             	mov    %rax,%rdi
  800be4:	48 b8 ed 36 80 00 00 	movabs $0x8036ed,%rax
  800beb:	00 00 00 
  800bee:	ff d0                	callq  *%rax
  800bf0:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800bf7:	79 97                	jns    800b90 <umain+0x41>
			echocmds = 1;
			break;
		default:
			usage();
		}
	close(0);
  800bf9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bfe:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  800c05:	00 00 00 
  800c08:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800c0a:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  800c11:	00 00 00 
  800c14:	ff d0                	callq  *%rax
  800c16:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800c19:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800c1d:	79 30                	jns    800c4f <umain+0x100>
		panic("opencons: %e", r);
  800c1f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800c22:	89 c1                	mov    %eax,%ecx
  800c24:	48 ba 89 63 80 00 00 	movabs $0x806389,%rdx
  800c2b:	00 00 00 
  800c2e:	be 27 01 00 00       	mov    $0x127,%esi
  800c33:	48 bf 97 62 80 00 00 	movabs $0x806297,%rdi
  800c3a:	00 00 00 
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c42:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  800c49:	00 00 00 
  800c4c:	41 ff d0             	callq  *%r8
	if (r != 0)
  800c4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800c53:	74 30                	je     800c85 <umain+0x136>
		panic("first opencons used fd %d", r);
  800c55:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800c58:	89 c1                	mov    %eax,%ecx
  800c5a:	48 ba 96 63 80 00 00 	movabs $0x806396,%rdx
  800c61:	00 00 00 
  800c64:	be 29 01 00 00       	mov    $0x129,%esi
  800c69:	48 bf 97 62 80 00 00 	movabs $0x806297,%rdi
  800c70:	00 00 00 
  800c73:	b8 00 00 00 00       	mov    $0x0,%eax
  800c78:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  800c7f:	00 00 00 
  800c82:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800c85:	be 01 00 00 00       	mov    $0x1,%esi
  800c8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8f:	48 b8 dd 3c 80 00 00 	movabs $0x803cdd,%rax
  800c96:	00 00 00 
  800c99:	ff d0                	callq  *%rax
  800c9b:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800c9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800ca2:	79 30                	jns    800cd4 <umain+0x185>
		panic("dup: %e", r);
  800ca4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800ca7:	89 c1                	mov    %eax,%ecx
  800ca9:	48 ba b0 63 80 00 00 	movabs $0x8063b0,%rdx
  800cb0:	00 00 00 
  800cb3:	be 2b 01 00 00       	mov    $0x12b,%esi
  800cb8:	48 bf 97 62 80 00 00 	movabs $0x806297,%rdi
  800cbf:	00 00 00 
  800cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc7:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  800cce:	00 00 00 
  800cd1:	41 ff d0             	callq  *%r8
	if (argc > 2)
  800cd4:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800cd7:	83 f8 02             	cmp    $0x2,%eax
  800cda:	7e 0c                	jle    800ce8 <umain+0x199>
		usage();
  800cdc:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800ce3:	00 00 00 
  800ce6:	ff d0                	callq  *%rax
	if (argc == 2) {
  800ce8:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800ceb:	83 f8 02             	cmp    $0x2,%eax
  800cee:	0f 85 b3 00 00 00    	jne    800da7 <umain+0x258>
		close(0);
  800cf4:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf9:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  800d00:	00 00 00 
  800d03:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800d05:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800d09:	48 83 c0 08          	add    $0x8,%rax
  800d0d:	48 8b 00             	mov    (%rax),%rax
  800d10:	be 00 00 00 00       	mov    $0x0,%esi
  800d15:	48 89 c7             	mov    %rax,%rdi
  800d18:	48 b8 29 43 80 00 00 	movabs $0x804329,%rax
  800d1f:	00 00 00 
  800d22:	ff d0                	callq  *%rax
  800d24:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800d27:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800d2b:	79 3f                	jns    800d6c <umain+0x21d>
			panic("open %s: %e", argv[1], r);
  800d2d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800d31:	48 83 c0 08          	add    $0x8,%rax
  800d35:	48 8b 00             	mov    (%rax),%rax
  800d38:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800d3b:	41 89 d0             	mov    %edx,%r8d
  800d3e:	48 89 c1             	mov    %rax,%rcx
  800d41:	48 ba b8 63 80 00 00 	movabs $0x8063b8,%rdx
  800d48:	00 00 00 
  800d4b:	be 31 01 00 00       	mov    $0x131,%esi
  800d50:	48 bf 97 62 80 00 00 	movabs $0x806297,%rdi
  800d57:	00 00 00 
  800d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5f:	49 b9 32 13 80 00 00 	movabs $0x801332,%r9
  800d66:	00 00 00 
  800d69:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800d6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800d70:	74 35                	je     800da7 <umain+0x258>
  800d72:	48 b9 c4 63 80 00 00 	movabs $0x8063c4,%rcx
  800d79:	00 00 00 
  800d7c:	48 ba cb 63 80 00 00 	movabs $0x8063cb,%rdx
  800d83:	00 00 00 
  800d86:	be 32 01 00 00       	mov    $0x132,%esi
  800d8b:	48 bf 97 62 80 00 00 	movabs $0x806297,%rdi
  800d92:	00 00 00 
  800d95:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9a:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  800da1:	00 00 00 
  800da4:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800da7:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800dab:	75 14                	jne    800dc1 <umain+0x272>
		interactive = iscons(0);
  800dad:	bf 00 00 00 00       	mov    $0x0,%edi
  800db2:	48 b8 4d 10 80 00 00 	movabs $0x80104d,%rax
  800db9:	00 00 00 
  800dbc:	ff d0                	callq  *%rax
  800dbe:	89 45 fc             	mov    %eax,-0x4(%rbp)

	while (1) {
		char *buf;
		#ifndef VMM_GUEST
		buf = readline(interactive ? "$ " : NULL);
  800dc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dc5:	74 0c                	je     800dd3 <umain+0x284>
  800dc7:	48 b8 e0 63 80 00 00 	movabs $0x8063e0,%rax
  800dce:	00 00 00 
  800dd1:	eb 05                	jmp    800dd8 <umain+0x289>
  800dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd8:	48 89 c7             	mov    %rax,%rdi
  800ddb:	48 b8 b4 20 80 00 00 	movabs $0x8020b4,%rax
  800de2:	00 00 00 
  800de5:	ff d0                	callq  *%rax
  800de7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		#else
		buf = readline(interactive ? "vm$ " : NULL);
		#endif
		if (buf == NULL) {
  800deb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800df0:	75 37                	jne    800e29 <umain+0x2da>
			if (debug)
  800df2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800df9:	00 00 00 
  800dfc:	8b 00                	mov    (%rax),%eax
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	74 1b                	je     800e1d <umain+0x2ce>
				cprintf("EXITING\n");
  800e02:	48 bf e3 63 80 00 00 	movabs $0x8063e3,%rdi
  800e09:	00 00 00 
  800e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e11:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800e18:	00 00 00 
  800e1b:	ff d2                	callq  *%rdx
			exit();	// end of file
  800e1d:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  800e24:	00 00 00 
  800e27:	ff d0                	callq  *%rax
		}
		#ifndef VMM_GUEST
		if(strcmp(buf, "vmmanager")==0)
  800e29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2d:	48 be ec 63 80 00 00 	movabs $0x8063ec,%rsi
  800e34:	00 00 00 
  800e37:	48 89 c7             	mov    %rax,%rdi
  800e3a:	48 b8 dc 23 80 00 00 	movabs $0x8023dc,%rax
  800e41:	00 00 00 
  800e44:	ff d0                	callq  *%rax
  800e46:	85 c0                	test   %eax,%eax
  800e48:	75 04                	jne    800e4e <umain+0x2ff>
			auto_terminate = true;
  800e4a:	c6 45 f7 01          	movb   $0x1,-0x9(%rbp)
		#endif
		if(strcmp(buf, "quit")==0)
  800e4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e52:	48 be f6 63 80 00 00 	movabs $0x8063f6,%rsi
  800e59:	00 00 00 
  800e5c:	48 89 c7             	mov    %rax,%rdi
  800e5f:	48 b8 dc 23 80 00 00 	movabs $0x8023dc,%rax
  800e66:	00 00 00 
  800e69:	ff d0                	callq  *%rax
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	75 0c                	jne    800e7b <umain+0x32c>
			exit();
  800e6f:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  800e76:	00 00 00 
  800e79:	ff d0                	callq  *%rax
		if (debug)
  800e7b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800e82:	00 00 00 
  800e85:	8b 00                	mov    (%rax),%eax
  800e87:	85 c0                	test   %eax,%eax
  800e89:	74 22                	je     800ead <umain+0x35e>
			cprintf("LINE: %s\n", buf);
  800e8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8f:	48 89 c6             	mov    %rax,%rsi
  800e92:	48 bf fb 63 80 00 00 	movabs $0x8063fb,%rdi
  800e99:	00 00 00 
  800e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea1:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800ea8:	00 00 00 
  800eab:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800ead:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb1:	0f b6 00             	movzbl (%rax),%eax
  800eb4:	3c 23                	cmp    $0x23,%al
  800eb6:	75 05                	jne    800ebd <umain+0x36e>
			continue;
  800eb8:	e9 17 01 00 00       	jmpq   800fd4 <umain+0x485>
		if (echocmds)
  800ebd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ec1:	74 22                	je     800ee5 <umain+0x396>
			printf("# %s\n", buf);
  800ec3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec7:	48 89 c6             	mov    %rax,%rsi
  800eca:	48 bf 05 64 80 00 00 	movabs $0x806405,%rdi
  800ed1:	00 00 00 
  800ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed9:	48 ba 8d 4b 80 00 00 	movabs $0x804b8d,%rdx
  800ee0:	00 00 00 
  800ee3:	ff d2                	callq  *%rdx
			//fprintf(1, "# %s\n", buf);
		if (debug)
  800ee5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800eec:	00 00 00 
  800eef:	8b 00                	mov    (%rax),%eax
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	74 1b                	je     800f10 <umain+0x3c1>
			cprintf("BEFORE FORK\n");
  800ef5:	48 bf 0b 64 80 00 00 	movabs $0x80640b,%rdi
  800efc:	00 00 00 
  800eff:	b8 00 00 00 00       	mov    $0x0,%eax
  800f04:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800f0b:	00 00 00 
  800f0e:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800f10:	48 b8 e0 33 80 00 00 	movabs $0x8033e0,%rax
  800f17:	00 00 00 
  800f1a:	ff d0                	callq  *%rax
  800f1c:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800f1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800f23:	79 30                	jns    800f55 <umain+0x406>
			panic("fork: %e", r);
  800f25:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f28:	89 c1                	mov    %eax,%ecx
  800f2a:	48 ba 72 62 80 00 00 	movabs $0x806272,%rdx
  800f31:	00 00 00 
  800f34:	be 53 01 00 00       	mov    $0x153,%esi
  800f39:	48 bf 97 62 80 00 00 	movabs $0x806297,%rdi
  800f40:	00 00 00 
  800f43:	b8 00 00 00 00       	mov    $0x0,%eax
  800f48:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  800f4f:	00 00 00 
  800f52:	41 ff d0             	callq  *%r8
		if (debug)
  800f55:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800f5c:	00 00 00 
  800f5f:	8b 00                	mov    (%rax),%eax
  800f61:	85 c0                	test   %eax,%eax
  800f63:	74 20                	je     800f85 <umain+0x436>
			cprintf("FORK: %d\n", r);
  800f65:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f68:	89 c6                	mov    %eax,%esi
  800f6a:	48 bf 18 64 80 00 00 	movabs $0x806418,%rdi
  800f71:	00 00 00 
  800f74:	b8 00 00 00 00       	mov    $0x0,%eax
  800f79:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  800f80:	00 00 00 
  800f83:	ff d2                	callq  *%rdx
		if (r == 0) {
  800f85:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800f89:	75 21                	jne    800fac <umain+0x45d>
			runcmd(buf);
  800f8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8f:	48 89 c7             	mov    %rax,%rdi
  800f92:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800f99:	00 00 00 
  800f9c:	ff d0                	callq  *%rax
			exit();
  800f9e:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  800fa5:	00 00 00 
  800fa8:	ff d0                	callq  *%rax
  800faa:	eb 28                	jmp    800fd4 <umain+0x485>
		} else {
			wait(r);
  800fac:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800faf:	89 c7                	mov    %eax,%edi
  800fb1:	48 b8 58 5d 80 00 00 	movabs $0x805d58,%rax
  800fb8:	00 00 00 
  800fbb:	ff d0                	callq  *%rax
			if (auto_terminate)
  800fbd:	80 7d f7 00          	cmpb   $0x0,-0x9(%rbp)
  800fc1:	74 11                	je     800fd4 <umain+0x485>
				exit();
  800fc3:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  800fca:	00 00 00 
  800fcd:	ff d0                	callq  *%rax
		}
	}
  800fcf:	e9 ed fd ff ff       	jmpq   800dc1 <umain+0x272>
  800fd4:	e9 e8 fd ff ff       	jmpq   800dc1 <umain+0x272>

0000000000800fd9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800fd9:	55                   	push   %rbp
  800fda:	48 89 e5             	mov    %rsp,%rbp
  800fdd:	48 83 ec 20          	sub    $0x20,%rsp
  800fe1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800fe4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800fe7:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800fea:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800fee:	be 01 00 00 00       	mov    $0x1,%esi
  800ff3:	48 89 c7             	mov    %rax,%rdi
  800ff6:	48 b8 61 2a 80 00 00 	movabs $0x802a61,%rax
  800ffd:	00 00 00 
  801000:	ff d0                	callq  *%rax
}
  801002:	c9                   	leaveq 
  801003:	c3                   	retq   

0000000000801004 <getchar>:

int
getchar(void)
{
  801004:	55                   	push   %rbp
  801005:	48 89 e5             	mov    %rsp,%rbp
  801008:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80100c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801010:	ba 01 00 00 00       	mov    $0x1,%edx
  801015:	48 89 c6             	mov    %rax,%rsi
  801018:	bf 00 00 00 00       	mov    $0x0,%edi
  80101d:	48 b8 86 3e 80 00 00 	movabs $0x803e86,%rax
  801024:	00 00 00 
  801027:	ff d0                	callq  *%rax
  801029:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80102c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801030:	79 05                	jns    801037 <getchar+0x33>
		return r;
  801032:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801035:	eb 14                	jmp    80104b <getchar+0x47>
	if (r < 1)
  801037:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80103b:	7f 07                	jg     801044 <getchar+0x40>
		return -E_EOF;
  80103d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801042:	eb 07                	jmp    80104b <getchar+0x47>
	return c;
  801044:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801048:	0f b6 c0             	movzbl %al,%eax
}
  80104b:	c9                   	leaveq 
  80104c:	c3                   	retq   

000000000080104d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80104d:	55                   	push   %rbp
  80104e:	48 89 e5             	mov    %rsp,%rbp
  801051:	48 83 ec 20          	sub    $0x20,%rsp
  801055:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801058:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80105c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80105f:	48 89 d6             	mov    %rdx,%rsi
  801062:	89 c7                	mov    %eax,%edi
  801064:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  80106b:	00 00 00 
  80106e:	ff d0                	callq  *%rax
  801070:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801073:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801077:	79 05                	jns    80107e <iscons+0x31>
		return r;
  801079:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80107c:	eb 1a                	jmp    801098 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80107e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801082:	8b 10                	mov    (%rax),%edx
  801084:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80108b:	00 00 00 
  80108e:	8b 00                	mov    (%rax),%eax
  801090:	39 c2                	cmp    %eax,%edx
  801092:	0f 94 c0             	sete   %al
  801095:	0f b6 c0             	movzbl %al,%eax
}
  801098:	c9                   	leaveq 
  801099:	c3                   	retq   

000000000080109a <opencons>:

int
opencons(void)
{
  80109a:	55                   	push   %rbp
  80109b:	48 89 e5             	mov    %rsp,%rbp
  80109e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8010a2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8010a6:	48 89 c7             	mov    %rax,%rdi
  8010a9:	48 b8 bc 39 80 00 00 	movabs $0x8039bc,%rax
  8010b0:	00 00 00 
  8010b3:	ff d0                	callq  *%rax
  8010b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010bc:	79 05                	jns    8010c3 <opencons+0x29>
		return r;
  8010be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c1:	eb 5b                	jmp    80111e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c7:	ba 07 04 00 00       	mov    $0x407,%edx
  8010cc:	48 89 c6             	mov    %rax,%rsi
  8010cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8010d4:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  8010db:	00 00 00 
  8010de:	ff d0                	callq  *%rax
  8010e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010e7:	79 05                	jns    8010ee <opencons+0x54>
		return r;
  8010e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ec:	eb 30                	jmp    80111e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8010ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f2:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8010f9:	00 00 00 
  8010fc:	8b 12                	mov    (%rdx),%edx
  8010fe:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801100:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801104:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80110b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110f:	48 89 c7             	mov    %rax,%rdi
  801112:	48 b8 6e 39 80 00 00 	movabs $0x80396e,%rax
  801119:	00 00 00 
  80111c:	ff d0                	callq  *%rax
}
  80111e:	c9                   	leaveq 
  80111f:	c3                   	retq   

0000000000801120 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801120:	55                   	push   %rbp
  801121:	48 89 e5             	mov    %rsp,%rbp
  801124:	48 83 ec 30          	sub    $0x30,%rsp
  801128:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801130:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801134:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801139:	75 07                	jne    801142 <devcons_read+0x22>
		return 0;
  80113b:	b8 00 00 00 00       	mov    $0x0,%eax
  801140:	eb 4b                	jmp    80118d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801142:	eb 0c                	jmp    801150 <devcons_read+0x30>
		sys_yield();
  801144:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  80114b:	00 00 00 
  80114e:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801150:	48 b8 ab 2a 80 00 00 	movabs $0x802aab,%rax
  801157:	00 00 00 
  80115a:	ff d0                	callq  *%rax
  80115c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80115f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801163:	74 df                	je     801144 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801165:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801169:	79 05                	jns    801170 <devcons_read+0x50>
		return c;
  80116b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80116e:	eb 1d                	jmp    80118d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801170:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801174:	75 07                	jne    80117d <devcons_read+0x5d>
		return 0;
  801176:	b8 00 00 00 00       	mov    $0x0,%eax
  80117b:	eb 10                	jmp    80118d <devcons_read+0x6d>
	*(char*)vbuf = c;
  80117d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801180:	89 c2                	mov    %eax,%edx
  801182:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801186:	88 10                	mov    %dl,(%rax)
	return 1;
  801188:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80118d:	c9                   	leaveq 
  80118e:	c3                   	retq   

000000000080118f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80118f:	55                   	push   %rbp
  801190:	48 89 e5             	mov    %rsp,%rbp
  801193:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80119a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8011a1:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8011a8:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8011af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011b6:	eb 76                	jmp    80122e <devcons_write+0x9f>
		m = n - tot;
  8011b8:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8011bf:	89 c2                	mov    %eax,%edx
  8011c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
  8011c8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8011cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011ce:	83 f8 7f             	cmp    $0x7f,%eax
  8011d1:	76 07                	jbe    8011da <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8011d3:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8011da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011dd:	48 63 d0             	movslq %eax,%rdx
  8011e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e3:	48 63 c8             	movslq %eax,%rcx
  8011e6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8011ed:	48 01 c1             	add    %rax,%rcx
  8011f0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8011f7:	48 89 ce             	mov    %rcx,%rsi
  8011fa:	48 89 c7             	mov    %rax,%rdi
  8011fd:	48 b8 9e 25 80 00 00 	movabs $0x80259e,%rax
  801204:	00 00 00 
  801207:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801209:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80120c:	48 63 d0             	movslq %eax,%rdx
  80120f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801216:	48 89 d6             	mov    %rdx,%rsi
  801219:	48 89 c7             	mov    %rax,%rdi
  80121c:	48 b8 61 2a 80 00 00 	movabs $0x802a61,%rax
  801223:	00 00 00 
  801226:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801228:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80122b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80122e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801231:	48 98                	cltq   
  801233:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80123a:	0f 82 78 ff ff ff    	jb     8011b8 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801240:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801243:	c9                   	leaveq 
  801244:	c3                   	retq   

0000000000801245 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801245:	55                   	push   %rbp
  801246:	48 89 e5             	mov    %rsp,%rbp
  801249:	48 83 ec 08          	sub    $0x8,%rsp
  80124d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801256:	c9                   	leaveq 
  801257:	c3                   	retq   

0000000000801258 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801258:	55                   	push   %rbp
  801259:	48 89 e5             	mov    %rsp,%rbp
  80125c:	48 83 ec 10          	sub    $0x10,%rsp
  801260:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801264:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126c:	48 be 27 64 80 00 00 	movabs $0x806427,%rsi
  801273:	00 00 00 
  801276:	48 89 c7             	mov    %rax,%rdi
  801279:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  801280:	00 00 00 
  801283:	ff d0                	callq  *%rax
	return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128a:	c9                   	leaveq 
  80128b:	c3                   	retq   

000000000080128c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80128c:	55                   	push   %rbp
  80128d:	48 89 e5             	mov    %rsp,%rbp
  801290:	48 83 ec 10          	sub    $0x10,%rsp
  801294:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801297:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80129b:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  8012a2:	00 00 00 
  8012a5:	ff d0                	callq  *%rax
  8012a7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012ac:	48 98                	cltq   
  8012ae:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8012b5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8012bc:	00 00 00 
  8012bf:	48 01 c2             	add    %rax,%rdx
  8012c2:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8012c9:	00 00 00 
  8012cc:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8012cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012d3:	7e 14                	jle    8012e9 <libmain+0x5d>
		binaryname = argv[0];
  8012d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d9:	48 8b 10             	mov    (%rax),%rdx
  8012dc:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8012e3:	00 00 00 
  8012e6:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8012e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8012ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012f0:	48 89 d6             	mov    %rdx,%rsi
  8012f3:	89 c7                	mov    %eax,%edi
  8012f5:	48 b8 4f 0b 80 00 00 	movabs $0x800b4f,%rax
  8012fc:	00 00 00 
  8012ff:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  801301:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  801308:	00 00 00 
  80130b:	ff d0                	callq  *%rax
}
  80130d:	c9                   	leaveq 
  80130e:	c3                   	retq   

000000000080130f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80130f:	55                   	push   %rbp
  801310:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  801313:	48 b8 af 3c 80 00 00 	movabs $0x803caf,%rax
  80131a:	00 00 00 
  80131d:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80131f:	bf 00 00 00 00       	mov    $0x0,%edi
  801324:	48 b8 e9 2a 80 00 00 	movabs $0x802ae9,%rax
  80132b:	00 00 00 
  80132e:	ff d0                	callq  *%rax

}
  801330:	5d                   	pop    %rbp
  801331:	c3                   	retq   

0000000000801332 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801332:	55                   	push   %rbp
  801333:	48 89 e5             	mov    %rsp,%rbp
  801336:	53                   	push   %rbx
  801337:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80133e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801345:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80134b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801352:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801359:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801360:	84 c0                	test   %al,%al
  801362:	74 23                	je     801387 <_panic+0x55>
  801364:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80136b:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80136f:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801373:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801377:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80137b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80137f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801383:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801387:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80138e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801395:	00 00 00 
  801398:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80139f:	00 00 00 
  8013a2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8013a6:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8013ad:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8013b4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8013bb:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8013c2:	00 00 00 
  8013c5:	48 8b 18             	mov    (%rax),%rbx
  8013c8:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  8013cf:	00 00 00 
  8013d2:	ff d0                	callq  *%rax
  8013d4:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8013da:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8013e1:	41 89 c8             	mov    %ecx,%r8d
  8013e4:	48 89 d1             	mov    %rdx,%rcx
  8013e7:	48 89 da             	mov    %rbx,%rdx
  8013ea:	89 c6                	mov    %eax,%esi
  8013ec:	48 bf 38 64 80 00 00 	movabs $0x806438,%rdi
  8013f3:	00 00 00 
  8013f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fb:	49 b9 6b 15 80 00 00 	movabs $0x80156b,%r9
  801402:	00 00 00 
  801405:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801408:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80140f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801416:	48 89 d6             	mov    %rdx,%rsi
  801419:	48 89 c7             	mov    %rax,%rdi
  80141c:	48 b8 bf 14 80 00 00 	movabs $0x8014bf,%rax
  801423:	00 00 00 
  801426:	ff d0                	callq  *%rax
	cprintf("\n");
  801428:	48 bf 5b 64 80 00 00 	movabs $0x80645b,%rdi
  80142f:	00 00 00 
  801432:	b8 00 00 00 00       	mov    $0x0,%eax
  801437:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  80143e:	00 00 00 
  801441:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801443:	cc                   	int3   
  801444:	eb fd                	jmp    801443 <_panic+0x111>

0000000000801446 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801446:	55                   	push   %rbp
  801447:	48 89 e5             	mov    %rsp,%rbp
  80144a:	48 83 ec 10          	sub    $0x10,%rsp
  80144e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801451:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801455:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801459:	8b 00                	mov    (%rax),%eax
  80145b:	8d 48 01             	lea    0x1(%rax),%ecx
  80145e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801462:	89 0a                	mov    %ecx,(%rdx)
  801464:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801467:	89 d1                	mov    %edx,%ecx
  801469:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80146d:	48 98                	cltq   
  80146f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801477:	8b 00                	mov    (%rax),%eax
  801479:	3d ff 00 00 00       	cmp    $0xff,%eax
  80147e:	75 2c                	jne    8014ac <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801484:	8b 00                	mov    (%rax),%eax
  801486:	48 98                	cltq   
  801488:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80148c:	48 83 c2 08          	add    $0x8,%rdx
  801490:	48 89 c6             	mov    %rax,%rsi
  801493:	48 89 d7             	mov    %rdx,%rdi
  801496:	48 b8 61 2a 80 00 00 	movabs $0x802a61,%rax
  80149d:	00 00 00 
  8014a0:	ff d0                	callq  *%rax
        b->idx = 0;
  8014a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8014ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b0:	8b 40 04             	mov    0x4(%rax),%eax
  8014b3:	8d 50 01             	lea    0x1(%rax),%edx
  8014b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ba:	89 50 04             	mov    %edx,0x4(%rax)
}
  8014bd:	c9                   	leaveq 
  8014be:	c3                   	retq   

00000000008014bf <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8014bf:	55                   	push   %rbp
  8014c0:	48 89 e5             	mov    %rsp,%rbp
  8014c3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8014ca:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8014d1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8014d8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8014df:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8014e6:	48 8b 0a             	mov    (%rdx),%rcx
  8014e9:	48 89 08             	mov    %rcx,(%rax)
  8014ec:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014f0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014f4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014f8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8014fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801503:	00 00 00 
    b.cnt = 0;
  801506:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80150d:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801510:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801517:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80151e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801525:	48 89 c6             	mov    %rax,%rsi
  801528:	48 bf 46 14 80 00 00 	movabs $0x801446,%rdi
  80152f:	00 00 00 
  801532:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  801539:	00 00 00 
  80153c:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80153e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801544:	48 98                	cltq   
  801546:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80154d:	48 83 c2 08          	add    $0x8,%rdx
  801551:	48 89 c6             	mov    %rax,%rsi
  801554:	48 89 d7             	mov    %rdx,%rdi
  801557:	48 b8 61 2a 80 00 00 	movabs $0x802a61,%rax
  80155e:	00 00 00 
  801561:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  801563:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801569:	c9                   	leaveq 
  80156a:	c3                   	retq   

000000000080156b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80156b:	55                   	push   %rbp
  80156c:	48 89 e5             	mov    %rsp,%rbp
  80156f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801576:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80157d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801584:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80158b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801592:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801599:	84 c0                	test   %al,%al
  80159b:	74 20                	je     8015bd <cprintf+0x52>
  80159d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015a1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015a5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015a9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015ad:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015b1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015b5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015b9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8015bd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8015c4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8015cb:	00 00 00 
  8015ce:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015d5:	00 00 00 
  8015d8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015dc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8015e3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8015ea:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8015f1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8015f8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8015ff:	48 8b 0a             	mov    (%rdx),%rcx
  801602:	48 89 08             	mov    %rcx,(%rax)
  801605:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801609:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80160d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801611:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  801615:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80161c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801623:	48 89 d6             	mov    %rdx,%rsi
  801626:	48 89 c7             	mov    %rax,%rdi
  801629:	48 b8 bf 14 80 00 00 	movabs $0x8014bf,%rax
  801630:	00 00 00 
  801633:	ff d0                	callq  *%rax
  801635:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80163b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801641:	c9                   	leaveq 
  801642:	c3                   	retq   

0000000000801643 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801643:	55                   	push   %rbp
  801644:	48 89 e5             	mov    %rsp,%rbp
  801647:	53                   	push   %rbx
  801648:	48 83 ec 38          	sub    $0x38,%rsp
  80164c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801650:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801654:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801658:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80165b:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80165f:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801663:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801666:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80166a:	77 3b                	ja     8016a7 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80166c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80166f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801673:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801676:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167a:	ba 00 00 00 00       	mov    $0x0,%edx
  80167f:	48 f7 f3             	div    %rbx
  801682:	48 89 c2             	mov    %rax,%rdx
  801685:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801688:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80168b:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80168f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801693:	41 89 f9             	mov    %edi,%r9d
  801696:	48 89 c7             	mov    %rax,%rdi
  801699:	48 b8 43 16 80 00 00 	movabs $0x801643,%rax
  8016a0:	00 00 00 
  8016a3:	ff d0                	callq  *%rax
  8016a5:	eb 1e                	jmp    8016c5 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8016a7:	eb 12                	jmp    8016bb <printnum+0x78>
			putch(padc, putdat);
  8016a9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8016ad:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8016b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b4:	48 89 ce             	mov    %rcx,%rsi
  8016b7:	89 d7                	mov    %edx,%edi
  8016b9:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8016bb:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8016bf:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8016c3:	7f e4                	jg     8016a9 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8016c5:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8016c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d1:	48 f7 f1             	div    %rcx
  8016d4:	48 89 d0             	mov    %rdx,%rax
  8016d7:	48 ba 50 66 80 00 00 	movabs $0x806650,%rdx
  8016de:	00 00 00 
  8016e1:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8016e5:	0f be d0             	movsbl %al,%edx
  8016e8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8016ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f0:	48 89 ce             	mov    %rcx,%rsi
  8016f3:	89 d7                	mov    %edx,%edi
  8016f5:	ff d0                	callq  *%rax
}
  8016f7:	48 83 c4 38          	add    $0x38,%rsp
  8016fb:	5b                   	pop    %rbx
  8016fc:	5d                   	pop    %rbp
  8016fd:	c3                   	retq   

00000000008016fe <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8016fe:	55                   	push   %rbp
  8016ff:	48 89 e5             	mov    %rsp,%rbp
  801702:	48 83 ec 1c          	sub    $0x1c,%rsp
  801706:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80170a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80170d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801711:	7e 52                	jle    801765 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801717:	8b 00                	mov    (%rax),%eax
  801719:	83 f8 30             	cmp    $0x30,%eax
  80171c:	73 24                	jae    801742 <getuint+0x44>
  80171e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801722:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172a:	8b 00                	mov    (%rax),%eax
  80172c:	89 c0                	mov    %eax,%eax
  80172e:	48 01 d0             	add    %rdx,%rax
  801731:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801735:	8b 12                	mov    (%rdx),%edx
  801737:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80173a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80173e:	89 0a                	mov    %ecx,(%rdx)
  801740:	eb 17                	jmp    801759 <getuint+0x5b>
  801742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801746:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80174a:	48 89 d0             	mov    %rdx,%rax
  80174d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801751:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801755:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801759:	48 8b 00             	mov    (%rax),%rax
  80175c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801760:	e9 a3 00 00 00       	jmpq   801808 <getuint+0x10a>
	else if (lflag)
  801765:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801769:	74 4f                	je     8017ba <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80176b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80176f:	8b 00                	mov    (%rax),%eax
  801771:	83 f8 30             	cmp    $0x30,%eax
  801774:	73 24                	jae    80179a <getuint+0x9c>
  801776:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80177e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801782:	8b 00                	mov    (%rax),%eax
  801784:	89 c0                	mov    %eax,%eax
  801786:	48 01 d0             	add    %rdx,%rax
  801789:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80178d:	8b 12                	mov    (%rdx),%edx
  80178f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801792:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801796:	89 0a                	mov    %ecx,(%rdx)
  801798:	eb 17                	jmp    8017b1 <getuint+0xb3>
  80179a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80179e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017a2:	48 89 d0             	mov    %rdx,%rax
  8017a5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ad:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017b1:	48 8b 00             	mov    (%rax),%rax
  8017b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8017b8:	eb 4e                	jmp    801808 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8017ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017be:	8b 00                	mov    (%rax),%eax
  8017c0:	83 f8 30             	cmp    $0x30,%eax
  8017c3:	73 24                	jae    8017e9 <getuint+0xeb>
  8017c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d1:	8b 00                	mov    (%rax),%eax
  8017d3:	89 c0                	mov    %eax,%eax
  8017d5:	48 01 d0             	add    %rdx,%rax
  8017d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017dc:	8b 12                	mov    (%rdx),%edx
  8017de:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e5:	89 0a                	mov    %ecx,(%rdx)
  8017e7:	eb 17                	jmp    801800 <getuint+0x102>
  8017e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017f1:	48 89 d0             	mov    %rdx,%rax
  8017f4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801800:	8b 00                	mov    (%rax),%eax
  801802:	89 c0                	mov    %eax,%eax
  801804:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801808:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80180c:	c9                   	leaveq 
  80180d:	c3                   	retq   

000000000080180e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80180e:	55                   	push   %rbp
  80180f:	48 89 e5             	mov    %rsp,%rbp
  801812:	48 83 ec 1c          	sub    $0x1c,%rsp
  801816:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80181a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80181d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801821:	7e 52                	jle    801875 <getint+0x67>
		x=va_arg(*ap, long long);
  801823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801827:	8b 00                	mov    (%rax),%eax
  801829:	83 f8 30             	cmp    $0x30,%eax
  80182c:	73 24                	jae    801852 <getint+0x44>
  80182e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801832:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801836:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183a:	8b 00                	mov    (%rax),%eax
  80183c:	89 c0                	mov    %eax,%eax
  80183e:	48 01 d0             	add    %rdx,%rax
  801841:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801845:	8b 12                	mov    (%rdx),%edx
  801847:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80184a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80184e:	89 0a                	mov    %ecx,(%rdx)
  801850:	eb 17                	jmp    801869 <getint+0x5b>
  801852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801856:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80185a:	48 89 d0             	mov    %rdx,%rax
  80185d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801861:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801865:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801869:	48 8b 00             	mov    (%rax),%rax
  80186c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801870:	e9 a3 00 00 00       	jmpq   801918 <getint+0x10a>
	else if (lflag)
  801875:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801879:	74 4f                	je     8018ca <getint+0xbc>
		x=va_arg(*ap, long);
  80187b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80187f:	8b 00                	mov    (%rax),%eax
  801881:	83 f8 30             	cmp    $0x30,%eax
  801884:	73 24                	jae    8018aa <getint+0x9c>
  801886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80188a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80188e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801892:	8b 00                	mov    (%rax),%eax
  801894:	89 c0                	mov    %eax,%eax
  801896:	48 01 d0             	add    %rdx,%rax
  801899:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80189d:	8b 12                	mov    (%rdx),%edx
  80189f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8018a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a6:	89 0a                	mov    %ecx,(%rdx)
  8018a8:	eb 17                	jmp    8018c1 <getint+0xb3>
  8018aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ae:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8018b2:	48 89 d0             	mov    %rdx,%rax
  8018b5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8018b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018bd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8018c1:	48 8b 00             	mov    (%rax),%rax
  8018c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8018c8:	eb 4e                	jmp    801918 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8018ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ce:	8b 00                	mov    (%rax),%eax
  8018d0:	83 f8 30             	cmp    $0x30,%eax
  8018d3:	73 24                	jae    8018f9 <getint+0xeb>
  8018d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8018dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e1:	8b 00                	mov    (%rax),%eax
  8018e3:	89 c0                	mov    %eax,%eax
  8018e5:	48 01 d0             	add    %rdx,%rax
  8018e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ec:	8b 12                	mov    (%rdx),%edx
  8018ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8018f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018f5:	89 0a                	mov    %ecx,(%rdx)
  8018f7:	eb 17                	jmp    801910 <getint+0x102>
  8018f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018fd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801901:	48 89 d0             	mov    %rdx,%rax
  801904:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801908:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80190c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801910:	8b 00                	mov    (%rax),%eax
  801912:	48 98                	cltq   
  801914:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801918:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80191c:	c9                   	leaveq 
  80191d:	c3                   	retq   

000000000080191e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80191e:	55                   	push   %rbp
  80191f:	48 89 e5             	mov    %rsp,%rbp
  801922:	41 54                	push   %r12
  801924:	53                   	push   %rbx
  801925:	48 83 ec 60          	sub    $0x60,%rsp
  801929:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80192d:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801931:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801935:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801939:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80193d:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801941:	48 8b 0a             	mov    (%rdx),%rcx
  801944:	48 89 08             	mov    %rcx,(%rax)
  801947:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80194b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80194f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801953:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801957:	eb 17                	jmp    801970 <vprintfmt+0x52>
			if (ch == '\0')
  801959:	85 db                	test   %ebx,%ebx
  80195b:	0f 84 cc 04 00 00    	je     801e2d <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801961:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801965:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801969:	48 89 d6             	mov    %rdx,%rsi
  80196c:	89 df                	mov    %ebx,%edi
  80196e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801970:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801974:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801978:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80197c:	0f b6 00             	movzbl (%rax),%eax
  80197f:	0f b6 d8             	movzbl %al,%ebx
  801982:	83 fb 25             	cmp    $0x25,%ebx
  801985:	75 d2                	jne    801959 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801987:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80198b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801992:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801999:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8019a0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8019a7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8019ab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019af:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8019b3:	0f b6 00             	movzbl (%rax),%eax
  8019b6:	0f b6 d8             	movzbl %al,%ebx
  8019b9:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8019bc:	83 f8 55             	cmp    $0x55,%eax
  8019bf:	0f 87 34 04 00 00    	ja     801df9 <vprintfmt+0x4db>
  8019c5:	89 c0                	mov    %eax,%eax
  8019c7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8019ce:	00 
  8019cf:	48 b8 78 66 80 00 00 	movabs $0x806678,%rax
  8019d6:	00 00 00 
  8019d9:	48 01 d0             	add    %rdx,%rax
  8019dc:	48 8b 00             	mov    (%rax),%rax
  8019df:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8019e1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8019e5:	eb c0                	jmp    8019a7 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8019e7:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8019eb:	eb ba                	jmp    8019a7 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8019ed:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8019f4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8019f7:	89 d0                	mov    %edx,%eax
  8019f9:	c1 e0 02             	shl    $0x2,%eax
  8019fc:	01 d0                	add    %edx,%eax
  8019fe:	01 c0                	add    %eax,%eax
  801a00:	01 d8                	add    %ebx,%eax
  801a02:	83 e8 30             	sub    $0x30,%eax
  801a05:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  801a08:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801a0c:	0f b6 00             	movzbl (%rax),%eax
  801a0f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801a12:	83 fb 2f             	cmp    $0x2f,%ebx
  801a15:	7e 0c                	jle    801a23 <vprintfmt+0x105>
  801a17:	83 fb 39             	cmp    $0x39,%ebx
  801a1a:	7f 07                	jg     801a23 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801a1c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801a21:	eb d1                	jmp    8019f4 <vprintfmt+0xd6>
			goto process_precision;
  801a23:	eb 58                	jmp    801a7d <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  801a25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a28:	83 f8 30             	cmp    $0x30,%eax
  801a2b:	73 17                	jae    801a44 <vprintfmt+0x126>
  801a2d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801a31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a34:	89 c0                	mov    %eax,%eax
  801a36:	48 01 d0             	add    %rdx,%rax
  801a39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a3c:	83 c2 08             	add    $0x8,%edx
  801a3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801a42:	eb 0f                	jmp    801a53 <vprintfmt+0x135>
  801a44:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801a48:	48 89 d0             	mov    %rdx,%rax
  801a4b:	48 83 c2 08          	add    $0x8,%rdx
  801a4f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801a53:	8b 00                	mov    (%rax),%eax
  801a55:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801a58:	eb 23                	jmp    801a7d <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801a5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801a5e:	79 0c                	jns    801a6c <vprintfmt+0x14e>
				width = 0;
  801a60:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801a67:	e9 3b ff ff ff       	jmpq   8019a7 <vprintfmt+0x89>
  801a6c:	e9 36 ff ff ff       	jmpq   8019a7 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801a71:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801a78:	e9 2a ff ff ff       	jmpq   8019a7 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801a7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801a81:	79 12                	jns    801a95 <vprintfmt+0x177>
				width = precision, precision = -1;
  801a83:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801a86:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801a89:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801a90:	e9 12 ff ff ff       	jmpq   8019a7 <vprintfmt+0x89>
  801a95:	e9 0d ff ff ff       	jmpq   8019a7 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801a9a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801a9e:	e9 04 ff ff ff       	jmpq   8019a7 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801aa3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801aa6:	83 f8 30             	cmp    $0x30,%eax
  801aa9:	73 17                	jae    801ac2 <vprintfmt+0x1a4>
  801aab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801aaf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801ab2:	89 c0                	mov    %eax,%eax
  801ab4:	48 01 d0             	add    %rdx,%rax
  801ab7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801aba:	83 c2 08             	add    $0x8,%edx
  801abd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801ac0:	eb 0f                	jmp    801ad1 <vprintfmt+0x1b3>
  801ac2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801ac6:	48 89 d0             	mov    %rdx,%rax
  801ac9:	48 83 c2 08          	add    $0x8,%rdx
  801acd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801ad1:	8b 10                	mov    (%rax),%edx
  801ad3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801ad7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801adb:	48 89 ce             	mov    %rcx,%rsi
  801ade:	89 d7                	mov    %edx,%edi
  801ae0:	ff d0                	callq  *%rax
			break;
  801ae2:	e9 40 03 00 00       	jmpq   801e27 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801ae7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801aea:	83 f8 30             	cmp    $0x30,%eax
  801aed:	73 17                	jae    801b06 <vprintfmt+0x1e8>
  801aef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801af3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801af6:	89 c0                	mov    %eax,%eax
  801af8:	48 01 d0             	add    %rdx,%rax
  801afb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801afe:	83 c2 08             	add    $0x8,%edx
  801b01:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801b04:	eb 0f                	jmp    801b15 <vprintfmt+0x1f7>
  801b06:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801b0a:	48 89 d0             	mov    %rdx,%rax
  801b0d:	48 83 c2 08          	add    $0x8,%rdx
  801b11:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801b15:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801b17:	85 db                	test   %ebx,%ebx
  801b19:	79 02                	jns    801b1d <vprintfmt+0x1ff>
				err = -err;
  801b1b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801b1d:	83 fb 15             	cmp    $0x15,%ebx
  801b20:	7f 16                	jg     801b38 <vprintfmt+0x21a>
  801b22:	48 b8 a0 65 80 00 00 	movabs $0x8065a0,%rax
  801b29:	00 00 00 
  801b2c:	48 63 d3             	movslq %ebx,%rdx
  801b2f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801b33:	4d 85 e4             	test   %r12,%r12
  801b36:	75 2e                	jne    801b66 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  801b38:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801b3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b40:	89 d9                	mov    %ebx,%ecx
  801b42:	48 ba 61 66 80 00 00 	movabs $0x806661,%rdx
  801b49:	00 00 00 
  801b4c:	48 89 c7             	mov    %rax,%rdi
  801b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b54:	49 b8 36 1e 80 00 00 	movabs $0x801e36,%r8
  801b5b:	00 00 00 
  801b5e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b61:	e9 c1 02 00 00       	jmpq   801e27 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801b66:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801b6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b6e:	4c 89 e1             	mov    %r12,%rcx
  801b71:	48 ba 6a 66 80 00 00 	movabs $0x80666a,%rdx
  801b78:	00 00 00 
  801b7b:	48 89 c7             	mov    %rax,%rdi
  801b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b83:	49 b8 36 1e 80 00 00 	movabs $0x801e36,%r8
  801b8a:	00 00 00 
  801b8d:	41 ff d0             	callq  *%r8
			break;
  801b90:	e9 92 02 00 00       	jmpq   801e27 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801b95:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801b98:	83 f8 30             	cmp    $0x30,%eax
  801b9b:	73 17                	jae    801bb4 <vprintfmt+0x296>
  801b9d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801ba1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801ba4:	89 c0                	mov    %eax,%eax
  801ba6:	48 01 d0             	add    %rdx,%rax
  801ba9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801bac:	83 c2 08             	add    $0x8,%edx
  801baf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801bb2:	eb 0f                	jmp    801bc3 <vprintfmt+0x2a5>
  801bb4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801bb8:	48 89 d0             	mov    %rdx,%rax
  801bbb:	48 83 c2 08          	add    $0x8,%rdx
  801bbf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801bc3:	4c 8b 20             	mov    (%rax),%r12
  801bc6:	4d 85 e4             	test   %r12,%r12
  801bc9:	75 0a                	jne    801bd5 <vprintfmt+0x2b7>
				p = "(null)";
  801bcb:	49 bc 6d 66 80 00 00 	movabs $0x80666d,%r12
  801bd2:	00 00 00 
			if (width > 0 && padc != '-')
  801bd5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801bd9:	7e 3f                	jle    801c1a <vprintfmt+0x2fc>
  801bdb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801bdf:	74 39                	je     801c1a <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801be1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801be4:	48 98                	cltq   
  801be6:	48 89 c6             	mov    %rax,%rsi
  801be9:	4c 89 e7             	mov    %r12,%rdi
  801bec:	48 b8 3c 22 80 00 00 	movabs $0x80223c,%rax
  801bf3:	00 00 00 
  801bf6:	ff d0                	callq  *%rax
  801bf8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801bfb:	eb 17                	jmp    801c14 <vprintfmt+0x2f6>
					putch(padc, putdat);
  801bfd:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801c01:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801c05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c09:	48 89 ce             	mov    %rcx,%rsi
  801c0c:	89 d7                	mov    %edx,%edi
  801c0e:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c10:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801c14:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801c18:	7f e3                	jg     801bfd <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c1a:	eb 37                	jmp    801c53 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801c1c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801c20:	74 1e                	je     801c40 <vprintfmt+0x322>
  801c22:	83 fb 1f             	cmp    $0x1f,%ebx
  801c25:	7e 05                	jle    801c2c <vprintfmt+0x30e>
  801c27:	83 fb 7e             	cmp    $0x7e,%ebx
  801c2a:	7e 14                	jle    801c40 <vprintfmt+0x322>
					putch('?', putdat);
  801c2c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c34:	48 89 d6             	mov    %rdx,%rsi
  801c37:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801c3c:	ff d0                	callq  *%rax
  801c3e:	eb 0f                	jmp    801c4f <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801c40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c48:	48 89 d6             	mov    %rdx,%rsi
  801c4b:	89 df                	mov    %ebx,%edi
  801c4d:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c4f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801c53:	4c 89 e0             	mov    %r12,%rax
  801c56:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801c5a:	0f b6 00             	movzbl (%rax),%eax
  801c5d:	0f be d8             	movsbl %al,%ebx
  801c60:	85 db                	test   %ebx,%ebx
  801c62:	74 10                	je     801c74 <vprintfmt+0x356>
  801c64:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c68:	78 b2                	js     801c1c <vprintfmt+0x2fe>
  801c6a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801c6e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c72:	79 a8                	jns    801c1c <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c74:	eb 16                	jmp    801c8c <vprintfmt+0x36e>
				putch(' ', putdat);
  801c76:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c7e:	48 89 d6             	mov    %rdx,%rsi
  801c81:	bf 20 00 00 00       	mov    $0x20,%edi
  801c86:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c88:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801c8c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801c90:	7f e4                	jg     801c76 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801c92:	e9 90 01 00 00       	jmpq   801e27 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801c97:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c9b:	be 03 00 00 00       	mov    $0x3,%esi
  801ca0:	48 89 c7             	mov    %rax,%rdi
  801ca3:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801caa:	00 00 00 
  801cad:	ff d0                	callq  *%rax
  801caf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801cb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cb7:	48 85 c0             	test   %rax,%rax
  801cba:	79 1d                	jns    801cd9 <vprintfmt+0x3bb>
				putch('-', putdat);
  801cbc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cc0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cc4:	48 89 d6             	mov    %rdx,%rsi
  801cc7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801ccc:	ff d0                	callq  *%rax
				num = -(long long) num;
  801cce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cd2:	48 f7 d8             	neg    %rax
  801cd5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801cd9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801ce0:	e9 d5 00 00 00       	jmpq   801dba <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801ce5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801ce9:	be 03 00 00 00       	mov    $0x3,%esi
  801cee:	48 89 c7             	mov    %rax,%rdi
  801cf1:	48 b8 fe 16 80 00 00 	movabs $0x8016fe,%rax
  801cf8:	00 00 00 
  801cfb:	ff d0                	callq  *%rax
  801cfd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801d01:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801d08:	e9 ad 00 00 00       	jmpq   801dba <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  801d0d:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801d10:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801d14:	89 d6                	mov    %edx,%esi
  801d16:	48 89 c7             	mov    %rax,%rdi
  801d19:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801d20:	00 00 00 
  801d23:	ff d0                	callq  *%rax
  801d25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801d29:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801d30:	e9 85 00 00 00       	jmpq   801dba <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  801d35:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d3d:	48 89 d6             	mov    %rdx,%rsi
  801d40:	bf 30 00 00 00       	mov    $0x30,%edi
  801d45:	ff d0                	callq  *%rax
			putch('x', putdat);
  801d47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d4f:	48 89 d6             	mov    %rdx,%rsi
  801d52:	bf 78 00 00 00       	mov    $0x78,%edi
  801d57:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801d59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d5c:	83 f8 30             	cmp    $0x30,%eax
  801d5f:	73 17                	jae    801d78 <vprintfmt+0x45a>
  801d61:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801d65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d68:	89 c0                	mov    %eax,%eax
  801d6a:	48 01 d0             	add    %rdx,%rax
  801d6d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801d70:	83 c2 08             	add    $0x8,%edx
  801d73:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d76:	eb 0f                	jmp    801d87 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801d78:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801d7c:	48 89 d0             	mov    %rdx,%rax
  801d7f:	48 83 c2 08          	add    $0x8,%rdx
  801d83:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801d87:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801d8e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801d95:	eb 23                	jmp    801dba <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801d97:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801d9b:	be 03 00 00 00       	mov    $0x3,%esi
  801da0:	48 89 c7             	mov    %rax,%rdi
  801da3:	48 b8 fe 16 80 00 00 	movabs $0x8016fe,%rax
  801daa:	00 00 00 
  801dad:	ff d0                	callq  *%rax
  801daf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801db3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801dba:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801dbf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801dc2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801dc5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801dc9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801dcd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801dd1:	45 89 c1             	mov    %r8d,%r9d
  801dd4:	41 89 f8             	mov    %edi,%r8d
  801dd7:	48 89 c7             	mov    %rax,%rdi
  801dda:	48 b8 43 16 80 00 00 	movabs $0x801643,%rax
  801de1:	00 00 00 
  801de4:	ff d0                	callq  *%rax
			break;
  801de6:	eb 3f                	jmp    801e27 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801de8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801dec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801df0:	48 89 d6             	mov    %rdx,%rsi
  801df3:	89 df                	mov    %ebx,%edi
  801df5:	ff d0                	callq  *%rax
			break;
  801df7:	eb 2e                	jmp    801e27 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801df9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801dfd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801e01:	48 89 d6             	mov    %rdx,%rsi
  801e04:	bf 25 00 00 00       	mov    $0x25,%edi
  801e09:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e0b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801e10:	eb 05                	jmp    801e17 <vprintfmt+0x4f9>
  801e12:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801e17:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801e1b:	48 83 e8 01          	sub    $0x1,%rax
  801e1f:	0f b6 00             	movzbl (%rax),%eax
  801e22:	3c 25                	cmp    $0x25,%al
  801e24:	75 ec                	jne    801e12 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801e26:	90                   	nop
		}
	}
  801e27:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801e28:	e9 43 fb ff ff       	jmpq   801970 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801e2d:	48 83 c4 60          	add    $0x60,%rsp
  801e31:	5b                   	pop    %rbx
  801e32:	41 5c                	pop    %r12
  801e34:	5d                   	pop    %rbp
  801e35:	c3                   	retq   

0000000000801e36 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e36:	55                   	push   %rbp
  801e37:	48 89 e5             	mov    %rsp,%rbp
  801e3a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801e41:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801e48:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801e4f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801e56:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801e5d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801e64:	84 c0                	test   %al,%al
  801e66:	74 20                	je     801e88 <printfmt+0x52>
  801e68:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801e6c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801e70:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801e74:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801e78:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801e7c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801e80:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801e84:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801e88:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e8f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801e96:	00 00 00 
  801e99:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801ea0:	00 00 00 
  801ea3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ea7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801eae:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801eb5:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801ebc:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801ec3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801eca:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801ed1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801ed8:	48 89 c7             	mov    %rax,%rdi
  801edb:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  801ee2:	00 00 00 
  801ee5:	ff d0                	callq  *%rax
	va_end(ap);
}
  801ee7:	c9                   	leaveq 
  801ee8:	c3                   	retq   

0000000000801ee9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ee9:	55                   	push   %rbp
  801eea:	48 89 e5             	mov    %rsp,%rbp
  801eed:	48 83 ec 10          	sub    $0x10,%rsp
  801ef1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ef4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801ef8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801efc:	8b 40 10             	mov    0x10(%rax),%eax
  801eff:	8d 50 01             	lea    0x1(%rax),%edx
  801f02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f06:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801f09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0d:	48 8b 10             	mov    (%rax),%rdx
  801f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f14:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f18:	48 39 c2             	cmp    %rax,%rdx
  801f1b:	73 17                	jae    801f34 <sprintputch+0x4b>
		*b->buf++ = ch;
  801f1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f21:	48 8b 00             	mov    (%rax),%rax
  801f24:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801f28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f2c:	48 89 0a             	mov    %rcx,(%rdx)
  801f2f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f32:	88 10                	mov    %dl,(%rax)
}
  801f34:	c9                   	leaveq 
  801f35:	c3                   	retq   

0000000000801f36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f36:	55                   	push   %rbp
  801f37:	48 89 e5             	mov    %rsp,%rbp
  801f3a:	48 83 ec 50          	sub    $0x50,%rsp
  801f3e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801f42:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801f45:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801f49:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801f4d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801f51:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801f55:	48 8b 0a             	mov    (%rdx),%rcx
  801f58:	48 89 08             	mov    %rcx,(%rax)
  801f5b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f5f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f63:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f67:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f6b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f6f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801f73:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801f76:	48 98                	cltq   
  801f78:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801f7c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f80:	48 01 d0             	add    %rdx,%rax
  801f83:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801f87:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801f8e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801f93:	74 06                	je     801f9b <vsnprintf+0x65>
  801f95:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801f99:	7f 07                	jg     801fa2 <vsnprintf+0x6c>
		return -E_INVAL;
  801f9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fa0:	eb 2f                	jmp    801fd1 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801fa2:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801fa6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801faa:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801fae:	48 89 c6             	mov    %rax,%rsi
  801fb1:	48 bf e9 1e 80 00 00 	movabs $0x801ee9,%rdi
  801fb8:	00 00 00 
  801fbb:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  801fc2:	00 00 00 
  801fc5:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801fc7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fcb:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801fce:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801fd1:	c9                   	leaveq 
  801fd2:	c3                   	retq   

0000000000801fd3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801fd3:	55                   	push   %rbp
  801fd4:	48 89 e5             	mov    %rsp,%rbp
  801fd7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801fde:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801fe5:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801feb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801ff2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801ff9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802000:	84 c0                	test   %al,%al
  802002:	74 20                	je     802024 <snprintf+0x51>
  802004:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802008:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80200c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802010:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802014:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802018:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80201c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802020:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802024:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80202b:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802032:	00 00 00 
  802035:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80203c:	00 00 00 
  80203f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802043:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80204a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802051:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802058:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80205f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802066:	48 8b 0a             	mov    (%rdx),%rcx
  802069:	48 89 08             	mov    %rcx,(%rax)
  80206c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802070:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802074:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802078:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80207c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802083:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80208a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802090:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802097:	48 89 c7             	mov    %rax,%rdi
  80209a:	48 b8 36 1f 80 00 00 	movabs $0x801f36,%rax
  8020a1:	00 00 00 
  8020a4:	ff d0                	callq  *%rax
  8020a6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8020ac:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8020b2:	c9                   	leaveq 
  8020b3:	c3                   	retq   

00000000008020b4 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8020b4:	55                   	push   %rbp
  8020b5:	48 89 e5             	mov    %rsp,%rbp
  8020b8:	48 83 ec 20          	sub    $0x20,%rsp
  8020bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8020c0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8020c5:	74 27                	je     8020ee <readline+0x3a>
		fprintf(1, "%s", prompt);
  8020c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020cb:	48 89 c2             	mov    %rax,%rdx
  8020ce:	48 be 28 69 80 00 00 	movabs $0x806928,%rsi
  8020d5:	00 00 00 
  8020d8:	bf 01 00 00 00       	mov    $0x1,%edi
  8020dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e2:	48 b9 d5 4a 80 00 00 	movabs $0x804ad5,%rcx
  8020e9:	00 00 00 
  8020ec:	ff d1                	callq  *%rcx
#endif

	i = 0;
  8020ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8020f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020fa:	48 b8 4d 10 80 00 00 	movabs $0x80104d,%rax
  802101:	00 00 00 
  802104:	ff d0                	callq  *%rax
  802106:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  802109:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  802110:	00 00 00 
  802113:	ff d0                	callq  *%rax
  802115:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  802118:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80211c:	79 30                	jns    80214e <readline+0x9a>
			if (c != -E_EOF)
  80211e:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  802122:	74 20                	je     802144 <readline+0x90>
				cprintf("read error: %e\n", c);
  802124:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802127:	89 c6                	mov    %eax,%esi
  802129:	48 bf 2b 69 80 00 00 	movabs $0x80692b,%rdi
  802130:	00 00 00 
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
  802138:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  80213f:	00 00 00 
  802142:	ff d2                	callq  *%rdx
			return NULL;
  802144:	b8 00 00 00 00       	mov    $0x0,%eax
  802149:	e9 be 00 00 00       	jmpq   80220c <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80214e:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  802152:	74 06                	je     80215a <readline+0xa6>
  802154:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  802158:	75 26                	jne    802180 <readline+0xcc>
  80215a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80215e:	7e 20                	jle    802180 <readline+0xcc>
			if (echoing)
  802160:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802164:	74 11                	je     802177 <readline+0xc3>
				cputchar('\b');
  802166:	bf 08 00 00 00       	mov    $0x8,%edi
  80216b:	48 b8 d9 0f 80 00 00 	movabs $0x800fd9,%rax
  802172:	00 00 00 
  802175:	ff d0                	callq  *%rax
			i--;
  802177:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  80217b:	e9 87 00 00 00       	jmpq   802207 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  802180:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  802184:	7e 3f                	jle    8021c5 <readline+0x111>
  802186:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  80218d:	7f 36                	jg     8021c5 <readline+0x111>
			if (echoing)
  80218f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802193:	74 11                	je     8021a6 <readline+0xf2>
				cputchar(c);
  802195:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802198:	89 c7                	mov    %eax,%edi
  80219a:	48 b8 d9 0f 80 00 00 	movabs $0x800fd9,%rax
  8021a1:	00 00 00 
  8021a4:	ff d0                	callq  *%rax
			buf[i++] = c;
  8021a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a9:	8d 50 01             	lea    0x1(%rax),%edx
  8021ac:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8021af:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8021b2:	89 d1                	mov    %edx,%ecx
  8021b4:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  8021bb:	00 00 00 
  8021be:	48 98                	cltq   
  8021c0:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8021c3:	eb 42                	jmp    802207 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8021c5:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8021c9:	74 06                	je     8021d1 <readline+0x11d>
  8021cb:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8021cf:	75 36                	jne    802207 <readline+0x153>
			if (echoing)
  8021d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021d5:	74 11                	je     8021e8 <readline+0x134>
				cputchar('\n');
  8021d7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021dc:	48 b8 d9 0f 80 00 00 	movabs $0x800fd9,%rax
  8021e3:	00 00 00 
  8021e6:	ff d0                	callq  *%rax
			buf[i] = 0;
  8021e8:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  8021ef:	00 00 00 
  8021f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f5:	48 98                	cltq   
  8021f7:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8021fb:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802202:	00 00 00 
  802205:	eb 05                	jmp    80220c <readline+0x158>
		}
	}
  802207:	e9 fd fe ff ff       	jmpq   802109 <readline+0x55>
}
  80220c:	c9                   	leaveq 
  80220d:	c3                   	retq   

000000000080220e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80220e:	55                   	push   %rbp
  80220f:	48 89 e5             	mov    %rsp,%rbp
  802212:	48 83 ec 18          	sub    $0x18,%rsp
  802216:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80221a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802221:	eb 09                	jmp    80222c <strlen+0x1e>
		n++;
  802223:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802227:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80222c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802230:	0f b6 00             	movzbl (%rax),%eax
  802233:	84 c0                	test   %al,%al
  802235:	75 ec                	jne    802223 <strlen+0x15>
		n++;
	return n;
  802237:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80223a:	c9                   	leaveq 
  80223b:	c3                   	retq   

000000000080223c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80223c:	55                   	push   %rbp
  80223d:	48 89 e5             	mov    %rsp,%rbp
  802240:	48 83 ec 20          	sub    $0x20,%rsp
  802244:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802248:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80224c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802253:	eb 0e                	jmp    802263 <strnlen+0x27>
		n++;
  802255:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802259:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80225e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802263:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802268:	74 0b                	je     802275 <strnlen+0x39>
  80226a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226e:	0f b6 00             	movzbl (%rax),%eax
  802271:	84 c0                	test   %al,%al
  802273:	75 e0                	jne    802255 <strnlen+0x19>
		n++;
	return n;
  802275:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802278:	c9                   	leaveq 
  802279:	c3                   	retq   

000000000080227a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80227a:	55                   	push   %rbp
  80227b:	48 89 e5             	mov    %rsp,%rbp
  80227e:	48 83 ec 20          	sub    $0x20,%rsp
  802282:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802286:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80228a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802292:	90                   	nop
  802293:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802297:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80229b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80229f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022a3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8022a7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8022ab:	0f b6 12             	movzbl (%rdx),%edx
  8022ae:	88 10                	mov    %dl,(%rax)
  8022b0:	0f b6 00             	movzbl (%rax),%eax
  8022b3:	84 c0                	test   %al,%al
  8022b5:	75 dc                	jne    802293 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8022b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022bb:	c9                   	leaveq 
  8022bc:	c3                   	retq   

00000000008022bd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8022bd:	55                   	push   %rbp
  8022be:	48 89 e5             	mov    %rsp,%rbp
  8022c1:	48 83 ec 20          	sub    $0x20,%rsp
  8022c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8022cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d1:	48 89 c7             	mov    %rax,%rdi
  8022d4:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  8022db:	00 00 00 
  8022de:	ff d0                	callq  *%rax
  8022e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8022e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e6:	48 63 d0             	movslq %eax,%rdx
  8022e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ed:	48 01 c2             	add    %rax,%rdx
  8022f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022f4:	48 89 c6             	mov    %rax,%rsi
  8022f7:	48 89 d7             	mov    %rdx,%rdi
  8022fa:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  802301:	00 00 00 
  802304:	ff d0                	callq  *%rax
	return dst;
  802306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80230a:	c9                   	leaveq 
  80230b:	c3                   	retq   

000000000080230c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80230c:	55                   	push   %rbp
  80230d:	48 89 e5             	mov    %rsp,%rbp
  802310:	48 83 ec 28          	sub    $0x28,%rsp
  802314:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802318:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80231c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802320:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802324:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802328:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80232f:	00 
  802330:	eb 2a                	jmp    80235c <strncpy+0x50>
		*dst++ = *src;
  802332:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802336:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80233a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80233e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802342:	0f b6 12             	movzbl (%rdx),%edx
  802345:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802347:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80234b:	0f b6 00             	movzbl (%rax),%eax
  80234e:	84 c0                	test   %al,%al
  802350:	74 05                	je     802357 <strncpy+0x4b>
			src++;
  802352:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802357:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80235c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802360:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802364:	72 cc                	jb     802332 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802366:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80236a:	c9                   	leaveq 
  80236b:	c3                   	retq   

000000000080236c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80236c:	55                   	push   %rbp
  80236d:	48 89 e5             	mov    %rsp,%rbp
  802370:	48 83 ec 28          	sub    $0x28,%rsp
  802374:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802378:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80237c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802384:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802388:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80238d:	74 3d                	je     8023cc <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80238f:	eb 1d                	jmp    8023ae <strlcpy+0x42>
			*dst++ = *src++;
  802391:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802395:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802399:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80239d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023a1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8023a5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8023a9:	0f b6 12             	movzbl (%rdx),%edx
  8023ac:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8023ae:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8023b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8023b8:	74 0b                	je     8023c5 <strlcpy+0x59>
  8023ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023be:	0f b6 00             	movzbl (%rax),%eax
  8023c1:	84 c0                	test   %al,%al
  8023c3:	75 cc                	jne    802391 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8023c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8023cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d4:	48 29 c2             	sub    %rax,%rdx
  8023d7:	48 89 d0             	mov    %rdx,%rax
}
  8023da:	c9                   	leaveq 
  8023db:	c3                   	retq   

00000000008023dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8023dc:	55                   	push   %rbp
  8023dd:	48 89 e5             	mov    %rsp,%rbp
  8023e0:	48 83 ec 10          	sub    $0x10,%rsp
  8023e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8023ec:	eb 0a                	jmp    8023f8 <strcmp+0x1c>
		p++, q++;
  8023ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023f3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8023f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023fc:	0f b6 00             	movzbl (%rax),%eax
  8023ff:	84 c0                	test   %al,%al
  802401:	74 12                	je     802415 <strcmp+0x39>
  802403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802407:	0f b6 10             	movzbl (%rax),%edx
  80240a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80240e:	0f b6 00             	movzbl (%rax),%eax
  802411:	38 c2                	cmp    %al,%dl
  802413:	74 d9                	je     8023ee <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802419:	0f b6 00             	movzbl (%rax),%eax
  80241c:	0f b6 d0             	movzbl %al,%edx
  80241f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802423:	0f b6 00             	movzbl (%rax),%eax
  802426:	0f b6 c0             	movzbl %al,%eax
  802429:	29 c2                	sub    %eax,%edx
  80242b:	89 d0                	mov    %edx,%eax
}
  80242d:	c9                   	leaveq 
  80242e:	c3                   	retq   

000000000080242f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80242f:	55                   	push   %rbp
  802430:	48 89 e5             	mov    %rsp,%rbp
  802433:	48 83 ec 18          	sub    $0x18,%rsp
  802437:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80243b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80243f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802443:	eb 0f                	jmp    802454 <strncmp+0x25>
		n--, p++, q++;
  802445:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80244a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80244f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802454:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802459:	74 1d                	je     802478 <strncmp+0x49>
  80245b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245f:	0f b6 00             	movzbl (%rax),%eax
  802462:	84 c0                	test   %al,%al
  802464:	74 12                	je     802478 <strncmp+0x49>
  802466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80246a:	0f b6 10             	movzbl (%rax),%edx
  80246d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802471:	0f b6 00             	movzbl (%rax),%eax
  802474:	38 c2                	cmp    %al,%dl
  802476:	74 cd                	je     802445 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802478:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80247d:	75 07                	jne    802486 <strncmp+0x57>
		return 0;
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
  802484:	eb 18                	jmp    80249e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80248a:	0f b6 00             	movzbl (%rax),%eax
  80248d:	0f b6 d0             	movzbl %al,%edx
  802490:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802494:	0f b6 00             	movzbl (%rax),%eax
  802497:	0f b6 c0             	movzbl %al,%eax
  80249a:	29 c2                	sub    %eax,%edx
  80249c:	89 d0                	mov    %edx,%eax
}
  80249e:	c9                   	leaveq 
  80249f:	c3                   	retq   

00000000008024a0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8024a0:	55                   	push   %rbp
  8024a1:	48 89 e5             	mov    %rsp,%rbp
  8024a4:	48 83 ec 0c          	sub    $0xc,%rsp
  8024a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024ac:	89 f0                	mov    %esi,%eax
  8024ae:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8024b1:	eb 17                	jmp    8024ca <strchr+0x2a>
		if (*s == c)
  8024b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024b7:	0f b6 00             	movzbl (%rax),%eax
  8024ba:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8024bd:	75 06                	jne    8024c5 <strchr+0x25>
			return (char *) s;
  8024bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024c3:	eb 15                	jmp    8024da <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8024c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8024ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ce:	0f b6 00             	movzbl (%rax),%eax
  8024d1:	84 c0                	test   %al,%al
  8024d3:	75 de                	jne    8024b3 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024da:	c9                   	leaveq 
  8024db:	c3                   	retq   

00000000008024dc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8024dc:	55                   	push   %rbp
  8024dd:	48 89 e5             	mov    %rsp,%rbp
  8024e0:	48 83 ec 0c          	sub    $0xc,%rsp
  8024e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024e8:	89 f0                	mov    %esi,%eax
  8024ea:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8024ed:	eb 13                	jmp    802502 <strfind+0x26>
		if (*s == c)
  8024ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024f3:	0f b6 00             	movzbl (%rax),%eax
  8024f6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8024f9:	75 02                	jne    8024fd <strfind+0x21>
			break;
  8024fb:	eb 10                	jmp    80250d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8024fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802502:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802506:	0f b6 00             	movzbl (%rax),%eax
  802509:	84 c0                	test   %al,%al
  80250b:	75 e2                	jne    8024ef <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80250d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802511:	c9                   	leaveq 
  802512:	c3                   	retq   

0000000000802513 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802513:	55                   	push   %rbp
  802514:	48 89 e5             	mov    %rsp,%rbp
  802517:	48 83 ec 18          	sub    $0x18,%rsp
  80251b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80251f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802522:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802526:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80252b:	75 06                	jne    802533 <memset+0x20>
		return v;
  80252d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802531:	eb 69                	jmp    80259c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802537:	83 e0 03             	and    $0x3,%eax
  80253a:	48 85 c0             	test   %rax,%rax
  80253d:	75 48                	jne    802587 <memset+0x74>
  80253f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802543:	83 e0 03             	and    $0x3,%eax
  802546:	48 85 c0             	test   %rax,%rax
  802549:	75 3c                	jne    802587 <memset+0x74>
		c &= 0xFF;
  80254b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802552:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802555:	c1 e0 18             	shl    $0x18,%eax
  802558:	89 c2                	mov    %eax,%edx
  80255a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80255d:	c1 e0 10             	shl    $0x10,%eax
  802560:	09 c2                	or     %eax,%edx
  802562:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802565:	c1 e0 08             	shl    $0x8,%eax
  802568:	09 d0                	or     %edx,%eax
  80256a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80256d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802571:	48 c1 e8 02          	shr    $0x2,%rax
  802575:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802578:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80257c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80257f:	48 89 d7             	mov    %rdx,%rdi
  802582:	fc                   	cld    
  802583:	f3 ab                	rep stos %eax,%es:(%rdi)
  802585:	eb 11                	jmp    802598 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802587:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80258b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80258e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802592:	48 89 d7             	mov    %rdx,%rdi
  802595:	fc                   	cld    
  802596:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802598:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80259c:	c9                   	leaveq 
  80259d:	c3                   	retq   

000000000080259e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80259e:	55                   	push   %rbp
  80259f:	48 89 e5             	mov    %rsp,%rbp
  8025a2:	48 83 ec 28          	sub    $0x28,%rsp
  8025a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8025b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8025ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8025c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8025ca:	0f 83 88 00 00 00    	jae    802658 <memmove+0xba>
  8025d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025d8:	48 01 d0             	add    %rdx,%rax
  8025db:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8025df:	76 77                	jbe    802658 <memmove+0xba>
		s += n;
  8025e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025e5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8025e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025ed:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8025f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025f5:	83 e0 03             	and    $0x3,%eax
  8025f8:	48 85 c0             	test   %rax,%rax
  8025fb:	75 3b                	jne    802638 <memmove+0x9a>
  8025fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802601:	83 e0 03             	and    $0x3,%eax
  802604:	48 85 c0             	test   %rax,%rax
  802607:	75 2f                	jne    802638 <memmove+0x9a>
  802609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80260d:	83 e0 03             	and    $0x3,%eax
  802610:	48 85 c0             	test   %rax,%rax
  802613:	75 23                	jne    802638 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802615:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802619:	48 83 e8 04          	sub    $0x4,%rax
  80261d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802621:	48 83 ea 04          	sub    $0x4,%rdx
  802625:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802629:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80262d:	48 89 c7             	mov    %rax,%rdi
  802630:	48 89 d6             	mov    %rdx,%rsi
  802633:	fd                   	std    
  802634:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802636:	eb 1d                	jmp    802655 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802644:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80264c:	48 89 d7             	mov    %rdx,%rdi
  80264f:	48 89 c1             	mov    %rax,%rcx
  802652:	fd                   	std    
  802653:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802655:	fc                   	cld    
  802656:	eb 57                	jmp    8026af <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802658:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80265c:	83 e0 03             	and    $0x3,%eax
  80265f:	48 85 c0             	test   %rax,%rax
  802662:	75 36                	jne    80269a <memmove+0xfc>
  802664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802668:	83 e0 03             	and    $0x3,%eax
  80266b:	48 85 c0             	test   %rax,%rax
  80266e:	75 2a                	jne    80269a <memmove+0xfc>
  802670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802674:	83 e0 03             	and    $0x3,%eax
  802677:	48 85 c0             	test   %rax,%rax
  80267a:	75 1e                	jne    80269a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80267c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802680:	48 c1 e8 02          	shr    $0x2,%rax
  802684:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802687:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80268f:	48 89 c7             	mov    %rax,%rdi
  802692:	48 89 d6             	mov    %rdx,%rsi
  802695:	fc                   	cld    
  802696:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802698:	eb 15                	jmp    8026af <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80269a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026a2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8026a6:	48 89 c7             	mov    %rax,%rdi
  8026a9:	48 89 d6             	mov    %rdx,%rsi
  8026ac:	fc                   	cld    
  8026ad:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8026af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8026b3:	c9                   	leaveq 
  8026b4:	c3                   	retq   

00000000008026b5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8026b5:	55                   	push   %rbp
  8026b6:	48 89 e5             	mov    %rsp,%rbp
  8026b9:	48 83 ec 18          	sub    $0x18,%rsp
  8026bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8026c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8026c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026cd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8026d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026d5:	48 89 ce             	mov    %rcx,%rsi
  8026d8:	48 89 c7             	mov    %rax,%rdi
  8026db:	48 b8 9e 25 80 00 00 	movabs $0x80259e,%rax
  8026e2:	00 00 00 
  8026e5:	ff d0                	callq  *%rax
}
  8026e7:	c9                   	leaveq 
  8026e8:	c3                   	retq   

00000000008026e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8026e9:	55                   	push   %rbp
  8026ea:	48 89 e5             	mov    %rsp,%rbp
  8026ed:	48 83 ec 28          	sub    $0x28,%rsp
  8026f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8026fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802701:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802705:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802709:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80270d:	eb 36                	jmp    802745 <memcmp+0x5c>
		if (*s1 != *s2)
  80270f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802713:	0f b6 10             	movzbl (%rax),%edx
  802716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271a:	0f b6 00             	movzbl (%rax),%eax
  80271d:	38 c2                	cmp    %al,%dl
  80271f:	74 1a                	je     80273b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  802721:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802725:	0f b6 00             	movzbl (%rax),%eax
  802728:	0f b6 d0             	movzbl %al,%edx
  80272b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272f:	0f b6 00             	movzbl (%rax),%eax
  802732:	0f b6 c0             	movzbl %al,%eax
  802735:	29 c2                	sub    %eax,%edx
  802737:	89 d0                	mov    %edx,%eax
  802739:	eb 20                	jmp    80275b <memcmp+0x72>
		s1++, s2++;
  80273b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802740:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802749:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80274d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802751:	48 85 c0             	test   %rax,%rax
  802754:	75 b9                	jne    80270f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802756:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275b:	c9                   	leaveq 
  80275c:	c3                   	retq   

000000000080275d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80275d:	55                   	push   %rbp
  80275e:	48 89 e5             	mov    %rsp,%rbp
  802761:	48 83 ec 28          	sub    $0x28,%rsp
  802765:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802769:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80276c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802770:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802774:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802778:	48 01 d0             	add    %rdx,%rax
  80277b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80277f:	eb 15                	jmp    802796 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802781:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802785:	0f b6 10             	movzbl (%rax),%edx
  802788:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80278b:	38 c2                	cmp    %al,%dl
  80278d:	75 02                	jne    802791 <memfind+0x34>
			break;
  80278f:	eb 0f                	jmp    8027a0 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802791:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80279e:	72 e1                	jb     802781 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8027a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8027a4:	c9                   	leaveq 
  8027a5:	c3                   	retq   

00000000008027a6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8027a6:	55                   	push   %rbp
  8027a7:	48 89 e5             	mov    %rsp,%rbp
  8027aa:	48 83 ec 34          	sub    $0x34,%rsp
  8027ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027b6:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8027b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8027c0:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8027c7:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027c8:	eb 05                	jmp    8027cf <strtol+0x29>
		s++;
  8027ca:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d3:	0f b6 00             	movzbl (%rax),%eax
  8027d6:	3c 20                	cmp    $0x20,%al
  8027d8:	74 f0                	je     8027ca <strtol+0x24>
  8027da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027de:	0f b6 00             	movzbl (%rax),%eax
  8027e1:	3c 09                	cmp    $0x9,%al
  8027e3:	74 e5                	je     8027ca <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8027e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027e9:	0f b6 00             	movzbl (%rax),%eax
  8027ec:	3c 2b                	cmp    $0x2b,%al
  8027ee:	75 07                	jne    8027f7 <strtol+0x51>
		s++;
  8027f0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027f5:	eb 17                	jmp    80280e <strtol+0x68>
	else if (*s == '-')
  8027f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027fb:	0f b6 00             	movzbl (%rax),%eax
  8027fe:	3c 2d                	cmp    $0x2d,%al
  802800:	75 0c                	jne    80280e <strtol+0x68>
		s++, neg = 1;
  802802:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802807:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80280e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802812:	74 06                	je     80281a <strtol+0x74>
  802814:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  802818:	75 28                	jne    802842 <strtol+0x9c>
  80281a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80281e:	0f b6 00             	movzbl (%rax),%eax
  802821:	3c 30                	cmp    $0x30,%al
  802823:	75 1d                	jne    802842 <strtol+0x9c>
  802825:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802829:	48 83 c0 01          	add    $0x1,%rax
  80282d:	0f b6 00             	movzbl (%rax),%eax
  802830:	3c 78                	cmp    $0x78,%al
  802832:	75 0e                	jne    802842 <strtol+0x9c>
		s += 2, base = 16;
  802834:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802839:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802840:	eb 2c                	jmp    80286e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802842:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802846:	75 19                	jne    802861 <strtol+0xbb>
  802848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284c:	0f b6 00             	movzbl (%rax),%eax
  80284f:	3c 30                	cmp    $0x30,%al
  802851:	75 0e                	jne    802861 <strtol+0xbb>
		s++, base = 8;
  802853:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802858:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80285f:	eb 0d                	jmp    80286e <strtol+0xc8>
	else if (base == 0)
  802861:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802865:	75 07                	jne    80286e <strtol+0xc8>
		base = 10;
  802867:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80286e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802872:	0f b6 00             	movzbl (%rax),%eax
  802875:	3c 2f                	cmp    $0x2f,%al
  802877:	7e 1d                	jle    802896 <strtol+0xf0>
  802879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80287d:	0f b6 00             	movzbl (%rax),%eax
  802880:	3c 39                	cmp    $0x39,%al
  802882:	7f 12                	jg     802896 <strtol+0xf0>
			dig = *s - '0';
  802884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802888:	0f b6 00             	movzbl (%rax),%eax
  80288b:	0f be c0             	movsbl %al,%eax
  80288e:	83 e8 30             	sub    $0x30,%eax
  802891:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802894:	eb 4e                	jmp    8028e4 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289a:	0f b6 00             	movzbl (%rax),%eax
  80289d:	3c 60                	cmp    $0x60,%al
  80289f:	7e 1d                	jle    8028be <strtol+0x118>
  8028a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a5:	0f b6 00             	movzbl (%rax),%eax
  8028a8:	3c 7a                	cmp    $0x7a,%al
  8028aa:	7f 12                	jg     8028be <strtol+0x118>
			dig = *s - 'a' + 10;
  8028ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b0:	0f b6 00             	movzbl (%rax),%eax
  8028b3:	0f be c0             	movsbl %al,%eax
  8028b6:	83 e8 57             	sub    $0x57,%eax
  8028b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8028bc:	eb 26                	jmp    8028e4 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8028be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028c2:	0f b6 00             	movzbl (%rax),%eax
  8028c5:	3c 40                	cmp    $0x40,%al
  8028c7:	7e 48                	jle    802911 <strtol+0x16b>
  8028c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028cd:	0f b6 00             	movzbl (%rax),%eax
  8028d0:	3c 5a                	cmp    $0x5a,%al
  8028d2:	7f 3d                	jg     802911 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8028d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028d8:	0f b6 00             	movzbl (%rax),%eax
  8028db:	0f be c0             	movsbl %al,%eax
  8028de:	83 e8 37             	sub    $0x37,%eax
  8028e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8028e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028e7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8028ea:	7c 02                	jl     8028ee <strtol+0x148>
			break;
  8028ec:	eb 23                	jmp    802911 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8028ee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8028f3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8028f6:	48 98                	cltq   
  8028f8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8028fd:	48 89 c2             	mov    %rax,%rdx
  802900:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802903:	48 98                	cltq   
  802905:	48 01 d0             	add    %rdx,%rax
  802908:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80290c:	e9 5d ff ff ff       	jmpq   80286e <strtol+0xc8>

	if (endptr)
  802911:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802916:	74 0b                	je     802923 <strtol+0x17d>
		*endptr = (char *) s;
  802918:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80291c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802920:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  802923:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802927:	74 09                	je     802932 <strtol+0x18c>
  802929:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292d:	48 f7 d8             	neg    %rax
  802930:	eb 04                	jmp    802936 <strtol+0x190>
  802932:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802936:	c9                   	leaveq 
  802937:	c3                   	retq   

0000000000802938 <strstr>:

char * strstr(const char *in, const char *str)
{
  802938:	55                   	push   %rbp
  802939:	48 89 e5             	mov    %rsp,%rbp
  80293c:	48 83 ec 30          	sub    $0x30,%rsp
  802940:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802944:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  802948:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80294c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802950:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802954:	0f b6 00             	movzbl (%rax),%eax
  802957:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80295a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80295e:	75 06                	jne    802966 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  802960:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802964:	eb 6b                	jmp    8029d1 <strstr+0x99>

	len = strlen(str);
  802966:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80296a:	48 89 c7             	mov    %rax,%rdi
  80296d:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
  802979:	48 98                	cltq   
  80297b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80297f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802983:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802987:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80298b:	0f b6 00             	movzbl (%rax),%eax
  80298e:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  802991:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802995:	75 07                	jne    80299e <strstr+0x66>
				return (char *) 0;
  802997:	b8 00 00 00 00       	mov    $0x0,%eax
  80299c:	eb 33                	jmp    8029d1 <strstr+0x99>
		} while (sc != c);
  80299e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8029a2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8029a5:	75 d8                	jne    80297f <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8029a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029ab:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029b3:	48 89 ce             	mov    %rcx,%rsi
  8029b6:	48 89 c7             	mov    %rax,%rdi
  8029b9:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	75 b6                	jne    80297f <strstr+0x47>

	return (char *) (in - 1);
  8029c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029cd:	48 83 e8 01          	sub    $0x1,%rax
}
  8029d1:	c9                   	leaveq 
  8029d2:	c3                   	retq   

00000000008029d3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8029d3:	55                   	push   %rbp
  8029d4:	48 89 e5             	mov    %rsp,%rbp
  8029d7:	53                   	push   %rbx
  8029d8:	48 83 ec 48          	sub    $0x48,%rsp
  8029dc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029df:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8029e2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8029e6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8029ea:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8029ee:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029f5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8029f9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8029fd:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802a01:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802a05:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802a09:	4c 89 c3             	mov    %r8,%rbx
  802a0c:	cd 30                	int    $0x30
  802a0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802a12:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802a16:	74 3e                	je     802a56 <syscall+0x83>
  802a18:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a1d:	7e 37                	jle    802a56 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a23:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a26:	49 89 d0             	mov    %rdx,%r8
  802a29:	89 c1                	mov    %eax,%ecx
  802a2b:	48 ba 3b 69 80 00 00 	movabs $0x80693b,%rdx
  802a32:	00 00 00 
  802a35:	be 23 00 00 00       	mov    $0x23,%esi
  802a3a:	48 bf 58 69 80 00 00 	movabs $0x806958,%rdi
  802a41:	00 00 00 
  802a44:	b8 00 00 00 00       	mov    $0x0,%eax
  802a49:	49 b9 32 13 80 00 00 	movabs $0x801332,%r9
  802a50:	00 00 00 
  802a53:	41 ff d1             	callq  *%r9

	return ret;
  802a56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802a5a:	48 83 c4 48          	add    $0x48,%rsp
  802a5e:	5b                   	pop    %rbx
  802a5f:	5d                   	pop    %rbp
  802a60:	c3                   	retq   

0000000000802a61 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802a61:	55                   	push   %rbp
  802a62:	48 89 e5             	mov    %rsp,%rbp
  802a65:	48 83 ec 20          	sub    $0x20,%rsp
  802a69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802a71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a80:	00 
  802a81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a8d:	48 89 d1             	mov    %rdx,%rcx
  802a90:	48 89 c2             	mov    %rax,%rdx
  802a93:	be 00 00 00 00       	mov    $0x0,%esi
  802a98:	bf 00 00 00 00       	mov    $0x0,%edi
  802a9d:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802aa4:	00 00 00 
  802aa7:	ff d0                	callq  *%rax
}
  802aa9:	c9                   	leaveq 
  802aaa:	c3                   	retq   

0000000000802aab <sys_cgetc>:

int
sys_cgetc(void)
{
  802aab:	55                   	push   %rbp
  802aac:	48 89 e5             	mov    %rsp,%rbp
  802aaf:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802ab3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802aba:	00 
  802abb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ac1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ac7:	b9 00 00 00 00       	mov    $0x0,%ecx
  802acc:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad1:	be 00 00 00 00       	mov    $0x0,%esi
  802ad6:	bf 01 00 00 00       	mov    $0x1,%edi
  802adb:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802ae2:	00 00 00 
  802ae5:	ff d0                	callq  *%rax
}
  802ae7:	c9                   	leaveq 
  802ae8:	c3                   	retq   

0000000000802ae9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802ae9:	55                   	push   %rbp
  802aea:	48 89 e5             	mov    %rsp,%rbp
  802aed:	48 83 ec 10          	sub    $0x10,%rsp
  802af1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802af4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af7:	48 98                	cltq   
  802af9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b00:	00 
  802b01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b12:	48 89 c2             	mov    %rax,%rdx
  802b15:	be 01 00 00 00       	mov    $0x1,%esi
  802b1a:	bf 03 00 00 00       	mov    $0x3,%edi
  802b1f:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802b26:	00 00 00 
  802b29:	ff d0                	callq  *%rax
}
  802b2b:	c9                   	leaveq 
  802b2c:	c3                   	retq   

0000000000802b2d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802b2d:	55                   	push   %rbp
  802b2e:	48 89 e5             	mov    %rsp,%rbp
  802b31:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802b35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b3c:	00 
  802b3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b49:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  802b53:	be 00 00 00 00       	mov    $0x0,%esi
  802b58:	bf 02 00 00 00       	mov    $0x2,%edi
  802b5d:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802b64:	00 00 00 
  802b67:	ff d0                	callq  *%rax
}
  802b69:	c9                   	leaveq 
  802b6a:	c3                   	retq   

0000000000802b6b <sys_yield>:

void
sys_yield(void)
{
  802b6b:	55                   	push   %rbp
  802b6c:	48 89 e5             	mov    %rsp,%rbp
  802b6f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802b73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b7a:	00 
  802b7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b87:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b91:	be 00 00 00 00       	mov    $0x0,%esi
  802b96:	bf 0b 00 00 00       	mov    $0xb,%edi
  802b9b:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802ba2:	00 00 00 
  802ba5:	ff d0                	callq  *%rax
}
  802ba7:	c9                   	leaveq 
  802ba8:	c3                   	retq   

0000000000802ba9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802ba9:	55                   	push   %rbp
  802baa:	48 89 e5             	mov    %rsp,%rbp
  802bad:	48 83 ec 20          	sub    $0x20,%rsp
  802bb1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bb4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802bb8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802bbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bbe:	48 63 c8             	movslq %eax,%rcx
  802bc1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc8:	48 98                	cltq   
  802bca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bd1:	00 
  802bd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bd8:	49 89 c8             	mov    %rcx,%r8
  802bdb:	48 89 d1             	mov    %rdx,%rcx
  802bde:	48 89 c2             	mov    %rax,%rdx
  802be1:	be 01 00 00 00       	mov    $0x1,%esi
  802be6:	bf 04 00 00 00       	mov    $0x4,%edi
  802beb:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802bf2:	00 00 00 
  802bf5:	ff d0                	callq  *%rax
}
  802bf7:	c9                   	leaveq 
  802bf8:	c3                   	retq   

0000000000802bf9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802bf9:	55                   	push   %rbp
  802bfa:	48 89 e5             	mov    %rsp,%rbp
  802bfd:	48 83 ec 30          	sub    $0x30,%rsp
  802c01:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c04:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c08:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802c0b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802c0f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802c13:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c16:	48 63 c8             	movslq %eax,%rcx
  802c19:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802c1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c20:	48 63 f0             	movslq %eax,%rsi
  802c23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2a:	48 98                	cltq   
  802c2c:	48 89 0c 24          	mov    %rcx,(%rsp)
  802c30:	49 89 f9             	mov    %rdi,%r9
  802c33:	49 89 f0             	mov    %rsi,%r8
  802c36:	48 89 d1             	mov    %rdx,%rcx
  802c39:	48 89 c2             	mov    %rax,%rdx
  802c3c:	be 01 00 00 00       	mov    $0x1,%esi
  802c41:	bf 05 00 00 00       	mov    $0x5,%edi
  802c46:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802c4d:	00 00 00 
  802c50:	ff d0                	callq  *%rax
}
  802c52:	c9                   	leaveq 
  802c53:	c3                   	retq   

0000000000802c54 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802c54:	55                   	push   %rbp
  802c55:	48 89 e5             	mov    %rsp,%rbp
  802c58:	48 83 ec 20          	sub    $0x20,%rsp
  802c5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802c63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6a:	48 98                	cltq   
  802c6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c73:	00 
  802c74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c80:	48 89 d1             	mov    %rdx,%rcx
  802c83:	48 89 c2             	mov    %rax,%rdx
  802c86:	be 01 00 00 00       	mov    $0x1,%esi
  802c8b:	bf 06 00 00 00       	mov    $0x6,%edi
  802c90:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	callq  *%rax
}
  802c9c:	c9                   	leaveq 
  802c9d:	c3                   	retq   

0000000000802c9e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802c9e:	55                   	push   %rbp
  802c9f:	48 89 e5             	mov    %rsp,%rbp
  802ca2:	48 83 ec 10          	sub    $0x10,%rsp
  802ca6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ca9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802cac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802caf:	48 63 d0             	movslq %eax,%rdx
  802cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb5:	48 98                	cltq   
  802cb7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802cbe:	00 
  802cbf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802cc5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ccb:	48 89 d1             	mov    %rdx,%rcx
  802cce:	48 89 c2             	mov    %rax,%rdx
  802cd1:	be 01 00 00 00       	mov    $0x1,%esi
  802cd6:	bf 08 00 00 00       	mov    $0x8,%edi
  802cdb:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802ce2:	00 00 00 
  802ce5:	ff d0                	callq  *%rax
}
  802ce7:	c9                   	leaveq 
  802ce8:	c3                   	retq   

0000000000802ce9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802ce9:	55                   	push   %rbp
  802cea:	48 89 e5             	mov    %rsp,%rbp
  802ced:	48 83 ec 20          	sub    $0x20,%rsp
  802cf1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cf4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802cf8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cff:	48 98                	cltq   
  802d01:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d08:	00 
  802d09:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d0f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d15:	48 89 d1             	mov    %rdx,%rcx
  802d18:	48 89 c2             	mov    %rax,%rdx
  802d1b:	be 01 00 00 00       	mov    $0x1,%esi
  802d20:	bf 09 00 00 00       	mov    $0x9,%edi
  802d25:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802d2c:	00 00 00 
  802d2f:	ff d0                	callq  *%rax
}
  802d31:	c9                   	leaveq 
  802d32:	c3                   	retq   

0000000000802d33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802d33:	55                   	push   %rbp
  802d34:	48 89 e5             	mov    %rsp,%rbp
  802d37:	48 83 ec 20          	sub    $0x20,%rsp
  802d3b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802d42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d49:	48 98                	cltq   
  802d4b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d52:	00 
  802d53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d5f:	48 89 d1             	mov    %rdx,%rcx
  802d62:	48 89 c2             	mov    %rax,%rdx
  802d65:	be 01 00 00 00       	mov    $0x1,%esi
  802d6a:	bf 0a 00 00 00       	mov    $0xa,%edi
  802d6f:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802d76:	00 00 00 
  802d79:	ff d0                	callq  *%rax
}
  802d7b:	c9                   	leaveq 
  802d7c:	c3                   	retq   

0000000000802d7d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802d7d:	55                   	push   %rbp
  802d7e:	48 89 e5             	mov    %rsp,%rbp
  802d81:	48 83 ec 20          	sub    $0x20,%rsp
  802d85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d8c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d90:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802d93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d96:	48 63 f0             	movslq %eax,%rsi
  802d99:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da0:	48 98                	cltq   
  802da2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802da6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802dad:	00 
  802dae:	49 89 f1             	mov    %rsi,%r9
  802db1:	49 89 c8             	mov    %rcx,%r8
  802db4:	48 89 d1             	mov    %rdx,%rcx
  802db7:	48 89 c2             	mov    %rax,%rdx
  802dba:	be 00 00 00 00       	mov    $0x0,%esi
  802dbf:	bf 0c 00 00 00       	mov    $0xc,%edi
  802dc4:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	callq  *%rax
}
  802dd0:	c9                   	leaveq 
  802dd1:	c3                   	retq   

0000000000802dd2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802dd2:	55                   	push   %rbp
  802dd3:	48 89 e5             	mov    %rsp,%rbp
  802dd6:	48 83 ec 10          	sub    $0x10,%rsp
  802dda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802dde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802de9:	00 
  802dea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802df0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802df6:	b9 00 00 00 00       	mov    $0x0,%ecx
  802dfb:	48 89 c2             	mov    %rax,%rdx
  802dfe:	be 01 00 00 00       	mov    $0x1,%esi
  802e03:	bf 0d 00 00 00       	mov    $0xd,%edi
  802e08:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802e0f:	00 00 00 
  802e12:	ff d0                	callq  *%rax
}
  802e14:	c9                   	leaveq 
  802e15:	c3                   	retq   

0000000000802e16 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802e16:	55                   	push   %rbp
  802e17:	48 89 e5             	mov    %rsp,%rbp
  802e1a:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802e1e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802e25:	00 
  802e26:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802e2c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802e32:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e37:	ba 00 00 00 00       	mov    $0x0,%edx
  802e3c:	be 00 00 00 00       	mov    $0x0,%esi
  802e41:	bf 0e 00 00 00       	mov    $0xe,%edi
  802e46:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802e4d:	00 00 00 
  802e50:	ff d0                	callq  *%rax
}
  802e52:	c9                   	leaveq 
  802e53:	c3                   	retq   

0000000000802e54 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802e54:	55                   	push   %rbp
  802e55:	48 89 e5             	mov    %rsp,%rbp
  802e58:	48 83 ec 30          	sub    $0x30,%rsp
  802e5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e63:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802e66:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802e6a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802e6e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e71:	48 63 c8             	movslq %eax,%rcx
  802e74:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802e78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e7b:	48 63 f0             	movslq %eax,%rsi
  802e7e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e85:	48 98                	cltq   
  802e87:	48 89 0c 24          	mov    %rcx,(%rsp)
  802e8b:	49 89 f9             	mov    %rdi,%r9
  802e8e:	49 89 f0             	mov    %rsi,%r8
  802e91:	48 89 d1             	mov    %rdx,%rcx
  802e94:	48 89 c2             	mov    %rax,%rdx
  802e97:	be 00 00 00 00       	mov    $0x0,%esi
  802e9c:	bf 0f 00 00 00       	mov    $0xf,%edi
  802ea1:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802ea8:	00 00 00 
  802eab:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802ead:	c9                   	leaveq 
  802eae:	c3                   	retq   

0000000000802eaf <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802eaf:	55                   	push   %rbp
  802eb0:	48 89 e5             	mov    %rsp,%rbp
  802eb3:	48 83 ec 20          	sub    $0x20,%rsp
  802eb7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ebb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802ebf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ec3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ece:	00 
  802ecf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ed5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802edb:	48 89 d1             	mov    %rdx,%rcx
  802ede:	48 89 c2             	mov    %rax,%rdx
  802ee1:	be 00 00 00 00       	mov    $0x0,%esi
  802ee6:	bf 10 00 00 00       	mov    $0x10,%edi
  802eeb:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802ef2:	00 00 00 
  802ef5:	ff d0                	callq  *%rax
}
  802ef7:	c9                   	leaveq 
  802ef8:	c3                   	retq   

0000000000802ef9 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  802ef9:	55                   	push   %rbp
  802efa:	48 89 e5             	mov    %rsp,%rbp
  802efd:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  802f01:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802f08:	00 
  802f09:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802f0f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802f15:	b9 00 00 00 00       	mov    $0x0,%ecx
  802f1a:	ba 00 00 00 00       	mov    $0x0,%edx
  802f1f:	be 00 00 00 00       	mov    $0x0,%esi
  802f24:	bf 11 00 00 00       	mov    $0x11,%edi
  802f29:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802f30:	00 00 00 
  802f33:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  802f35:	c9                   	leaveq 
  802f36:	c3                   	retq   

0000000000802f37 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  802f37:	55                   	push   %rbp
  802f38:	48 89 e5             	mov    %rsp,%rbp
  802f3b:	48 83 ec 10          	sub    $0x10,%rsp
  802f3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  802f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f45:	48 98                	cltq   
  802f47:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802f4e:	00 
  802f4f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802f55:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802f5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802f60:	48 89 c2             	mov    %rax,%rdx
  802f63:	be 00 00 00 00       	mov    $0x0,%esi
  802f68:	bf 12 00 00 00       	mov    $0x12,%edi
  802f6d:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802f74:	00 00 00 
  802f77:	ff d0                	callq  *%rax
}
  802f79:	c9                   	leaveq 
  802f7a:	c3                   	retq   

0000000000802f7b <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  802f7b:	55                   	push   %rbp
  802f7c:	48 89 e5             	mov    %rsp,%rbp
  802f7f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802f83:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802f8a:	00 
  802f8b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802f91:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802f97:	b9 00 00 00 00       	mov    $0x0,%ecx
  802f9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802fa1:	be 00 00 00 00       	mov    $0x0,%esi
  802fa6:	bf 13 00 00 00       	mov    $0x13,%edi
  802fab:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802fb2:	00 00 00 
  802fb5:	ff d0                	callq  *%rax
}
  802fb7:	c9                   	leaveq 
  802fb8:	c3                   	retq   

0000000000802fb9 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  802fb9:	55                   	push   %rbp
  802fba:	48 89 e5             	mov    %rsp,%rbp
  802fbd:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802fc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802fc8:	00 
  802fc9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802fcf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802fd5:	b9 00 00 00 00       	mov    $0x0,%ecx
  802fda:	ba 00 00 00 00       	mov    $0x0,%edx
  802fdf:	be 00 00 00 00       	mov    $0x0,%esi
  802fe4:	bf 14 00 00 00       	mov    $0x14,%edi
  802fe9:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
}
  802ff5:	c9                   	leaveq 
  802ff6:	c3                   	retq   

0000000000802ff7 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802ff7:	55                   	push   %rbp
  802ff8:	48 89 e5             	mov    %rsp,%rbp
  802ffb:	48 83 ec 30          	sub    $0x30,%rsp
  802fff:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  803003:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803007:	48 8b 00             	mov    (%rax),%rax
  80300a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80300e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803012:	48 8b 40 08          	mov    0x8(%rax),%rax
  803016:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  803019:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80301c:	83 e0 02             	and    $0x2,%eax
  80301f:	85 c0                	test   %eax,%eax
  803021:	75 4d                	jne    803070 <pgfault+0x79>
  803023:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803027:	48 c1 e8 0c          	shr    $0xc,%rax
  80302b:	48 89 c2             	mov    %rax,%rdx
  80302e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803035:	01 00 00 
  803038:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80303c:	25 00 08 00 00       	and    $0x800,%eax
  803041:	48 85 c0             	test   %rax,%rax
  803044:	74 2a                	je     803070 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  803046:	48 ba 68 69 80 00 00 	movabs $0x806968,%rdx
  80304d:	00 00 00 
  803050:	be 23 00 00 00       	mov    $0x23,%esi
  803055:	48 bf 9d 69 80 00 00 	movabs $0x80699d,%rdi
  80305c:	00 00 00 
  80305f:	b8 00 00 00 00       	mov    $0x0,%eax
  803064:	48 b9 32 13 80 00 00 	movabs $0x801332,%rcx
  80306b:	00 00 00 
  80306e:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  803070:	ba 07 00 00 00       	mov    $0x7,%edx
  803075:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80307a:	bf 00 00 00 00       	mov    $0x0,%edi
  80307f:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  803086:	00 00 00 
  803089:	ff d0                	callq  *%rax
  80308b:	85 c0                	test   %eax,%eax
  80308d:	0f 85 cd 00 00 00    	jne    803160 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  803093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803097:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80309b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8030a5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  8030a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ad:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030b2:	48 89 c6             	mov    %rax,%rsi
  8030b5:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8030ba:	48 b8 9e 25 80 00 00 	movabs $0x80259e,%rax
  8030c1:	00 00 00 
  8030c4:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  8030c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ca:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8030d0:	48 89 c1             	mov    %rax,%rcx
  8030d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8030d8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8030dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8030e2:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  8030e9:	00 00 00 
  8030ec:	ff d0                	callq  *%rax
  8030ee:	85 c0                	test   %eax,%eax
  8030f0:	79 2a                	jns    80311c <pgfault+0x125>
				panic("Page map at temp address failed");
  8030f2:	48 ba a8 69 80 00 00 	movabs $0x8069a8,%rdx
  8030f9:	00 00 00 
  8030fc:	be 30 00 00 00       	mov    $0x30,%esi
  803101:	48 bf 9d 69 80 00 00 	movabs $0x80699d,%rdi
  803108:	00 00 00 
  80310b:	b8 00 00 00 00       	mov    $0x0,%eax
  803110:	48 b9 32 13 80 00 00 	movabs $0x801332,%rcx
  803117:	00 00 00 
  80311a:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  80311c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  803121:	bf 00 00 00 00       	mov    $0x0,%edi
  803126:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  80312d:	00 00 00 
  803130:	ff d0                	callq  *%rax
  803132:	85 c0                	test   %eax,%eax
  803134:	79 54                	jns    80318a <pgfault+0x193>
				panic("Page unmap from temp location failed");
  803136:	48 ba c8 69 80 00 00 	movabs $0x8069c8,%rdx
  80313d:	00 00 00 
  803140:	be 32 00 00 00       	mov    $0x32,%esi
  803145:	48 bf 9d 69 80 00 00 	movabs $0x80699d,%rdi
  80314c:	00 00 00 
  80314f:	b8 00 00 00 00       	mov    $0x0,%eax
  803154:	48 b9 32 13 80 00 00 	movabs $0x801332,%rcx
  80315b:	00 00 00 
  80315e:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  803160:	48 ba f0 69 80 00 00 	movabs $0x8069f0,%rdx
  803167:	00 00 00 
  80316a:	be 34 00 00 00       	mov    $0x34,%esi
  80316f:	48 bf 9d 69 80 00 00 	movabs $0x80699d,%rdi
  803176:	00 00 00 
  803179:	b8 00 00 00 00       	mov    $0x0,%eax
  80317e:	48 b9 32 13 80 00 00 	movabs $0x801332,%rcx
  803185:	00 00 00 
  803188:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  80318a:	c9                   	leaveq 
  80318b:	c3                   	retq   

000000000080318c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80318c:	55                   	push   %rbp
  80318d:	48 89 e5             	mov    %rsp,%rbp
  803190:	48 83 ec 20          	sub    $0x20,%rsp
  803194:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803197:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  80319a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8031a1:	01 00 00 
  8031a4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8031b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  8031b3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031b6:	48 c1 e0 0c          	shl    $0xc,%rax
  8031ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  8031be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c1:	25 00 04 00 00       	and    $0x400,%eax
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	74 57                	je     803221 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8031ca:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031cd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031d1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d8:	41 89 f0             	mov    %esi,%r8d
  8031db:	48 89 c6             	mov    %rax,%rsi
  8031de:	bf 00 00 00 00       	mov    $0x0,%edi
  8031e3:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  8031ea:	00 00 00 
  8031ed:	ff d0                	callq  *%rax
  8031ef:	85 c0                	test   %eax,%eax
  8031f1:	0f 8e 52 01 00 00    	jle    803349 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8031f7:	48 ba 22 6a 80 00 00 	movabs $0x806a22,%rdx
  8031fe:	00 00 00 
  803201:	be 4e 00 00 00       	mov    $0x4e,%esi
  803206:	48 bf 9d 69 80 00 00 	movabs $0x80699d,%rdi
  80320d:	00 00 00 
  803210:	b8 00 00 00 00       	mov    $0x0,%eax
  803215:	48 b9 32 13 80 00 00 	movabs $0x801332,%rcx
  80321c:	00 00 00 
  80321f:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  803221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803224:	83 e0 02             	and    $0x2,%eax
  803227:	85 c0                	test   %eax,%eax
  803229:	75 10                	jne    80323b <duppage+0xaf>
  80322b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322e:	25 00 08 00 00       	and    $0x800,%eax
  803233:	85 c0                	test   %eax,%eax
  803235:	0f 84 bb 00 00 00    	je     8032f6 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  80323b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323e:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  803243:	80 cc 08             	or     $0x8,%ah
  803246:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  803249:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80324c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803250:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803253:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803257:	41 89 f0             	mov    %esi,%r8d
  80325a:	48 89 c6             	mov    %rax,%rsi
  80325d:	bf 00 00 00 00       	mov    $0x0,%edi
  803262:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  803269:	00 00 00 
  80326c:	ff d0                	callq  *%rax
  80326e:	85 c0                	test   %eax,%eax
  803270:	7e 2a                	jle    80329c <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  803272:	48 ba 22 6a 80 00 00 	movabs $0x806a22,%rdx
  803279:	00 00 00 
  80327c:	be 55 00 00 00       	mov    $0x55,%esi
  803281:	48 bf 9d 69 80 00 00 	movabs $0x80699d,%rdi
  803288:	00 00 00 
  80328b:	b8 00 00 00 00       	mov    $0x0,%eax
  803290:	48 b9 32 13 80 00 00 	movabs $0x801332,%rcx
  803297:	00 00 00 
  80329a:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80329c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80329f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a7:	41 89 c8             	mov    %ecx,%r8d
  8032aa:	48 89 d1             	mov    %rdx,%rcx
  8032ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8032b2:	48 89 c6             	mov    %rax,%rsi
  8032b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ba:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  8032c1:	00 00 00 
  8032c4:	ff d0                	callq  *%rax
  8032c6:	85 c0                	test   %eax,%eax
  8032c8:	7e 2a                	jle    8032f4 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  8032ca:	48 ba 22 6a 80 00 00 	movabs $0x806a22,%rdx
  8032d1:	00 00 00 
  8032d4:	be 57 00 00 00       	mov    $0x57,%esi
  8032d9:	48 bf 9d 69 80 00 00 	movabs $0x80699d,%rdi
  8032e0:	00 00 00 
  8032e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e8:	48 b9 32 13 80 00 00 	movabs $0x801332,%rcx
  8032ef:	00 00 00 
  8032f2:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8032f4:	eb 53                	jmp    803349 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8032f6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8032f9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8032fd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803304:	41 89 f0             	mov    %esi,%r8d
  803307:	48 89 c6             	mov    %rax,%rsi
  80330a:	bf 00 00 00 00       	mov    $0x0,%edi
  80330f:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  803316:	00 00 00 
  803319:	ff d0                	callq  *%rax
  80331b:	85 c0                	test   %eax,%eax
  80331d:	7e 2a                	jle    803349 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80331f:	48 ba 22 6a 80 00 00 	movabs $0x806a22,%rdx
  803326:	00 00 00 
  803329:	be 5b 00 00 00       	mov    $0x5b,%esi
  80332e:	48 bf 9d 69 80 00 00 	movabs $0x80699d,%rdi
  803335:	00 00 00 
  803338:	b8 00 00 00 00       	mov    $0x0,%eax
  80333d:	48 b9 32 13 80 00 00 	movabs $0x801332,%rcx
  803344:	00 00 00 
  803347:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  803349:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80334e:	c9                   	leaveq 
  80334f:	c3                   	retq   

0000000000803350 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  803350:	55                   	push   %rbp
  803351:	48 89 e5             	mov    %rsp,%rbp
  803354:	48 83 ec 18          	sub    $0x18,%rsp
  803358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80335c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803360:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  803364:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803368:	48 c1 e8 27          	shr    $0x27,%rax
  80336c:	48 89 c2             	mov    %rax,%rdx
  80336f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803376:	01 00 00 
  803379:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80337d:	83 e0 01             	and    $0x1,%eax
  803380:	48 85 c0             	test   %rax,%rax
  803383:	74 51                	je     8033d6 <pt_is_mapped+0x86>
  803385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803389:	48 c1 e0 0c          	shl    $0xc,%rax
  80338d:	48 c1 e8 1e          	shr    $0x1e,%rax
  803391:	48 89 c2             	mov    %rax,%rdx
  803394:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80339b:	01 00 00 
  80339e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033a2:	83 e0 01             	and    $0x1,%eax
  8033a5:	48 85 c0             	test   %rax,%rax
  8033a8:	74 2c                	je     8033d6 <pt_is_mapped+0x86>
  8033aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ae:	48 c1 e0 0c          	shl    $0xc,%rax
  8033b2:	48 c1 e8 15          	shr    $0x15,%rax
  8033b6:	48 89 c2             	mov    %rax,%rdx
  8033b9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8033c0:	01 00 00 
  8033c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033c7:	83 e0 01             	and    $0x1,%eax
  8033ca:	48 85 c0             	test   %rax,%rax
  8033cd:	74 07                	je     8033d6 <pt_is_mapped+0x86>
  8033cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8033d4:	eb 05                	jmp    8033db <pt_is_mapped+0x8b>
  8033d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033db:	83 e0 01             	and    $0x1,%eax
}
  8033de:	c9                   	leaveq 
  8033df:	c3                   	retq   

00000000008033e0 <fork>:

envid_t
fork(void)
{
  8033e0:	55                   	push   %rbp
  8033e1:	48 89 e5             	mov    %rsp,%rbp
  8033e4:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8033e8:	48 bf f7 2f 80 00 00 	movabs $0x802ff7,%rdi
  8033ef:	00 00 00 
  8033f2:	48 b8 ed 5d 80 00 00 	movabs $0x805ded,%rax
  8033f9:	00 00 00 
  8033fc:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8033fe:	b8 07 00 00 00       	mov    $0x7,%eax
  803403:	cd 30                	int    $0x30
  803405:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803408:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80340b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80340e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803412:	79 30                	jns    803444 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  803414:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803417:	89 c1                	mov    %eax,%ecx
  803419:	48 ba 40 6a 80 00 00 	movabs $0x806a40,%rdx
  803420:	00 00 00 
  803423:	be 86 00 00 00       	mov    $0x86,%esi
  803428:	48 bf 9d 69 80 00 00 	movabs $0x80699d,%rdi
  80342f:	00 00 00 
  803432:	b8 00 00 00 00       	mov    $0x0,%eax
  803437:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  80343e:	00 00 00 
  803441:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  803444:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803448:	75 3e                	jne    803488 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80344a:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  803451:	00 00 00 
  803454:	ff d0                	callq  *%rax
  803456:	25 ff 03 00 00       	and    $0x3ff,%eax
  80345b:	48 98                	cltq   
  80345d:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803464:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80346b:	00 00 00 
  80346e:	48 01 c2             	add    %rax,%rdx
  803471:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803478:	00 00 00 
  80347b:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80347e:	b8 00 00 00 00       	mov    $0x0,%eax
  803483:	e9 d1 01 00 00       	jmpq   803659 <fork+0x279>
	}
	uint64_t ad = 0;
  803488:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80348f:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  803490:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  803495:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803499:	e9 df 00 00 00       	jmpq   80357d <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80349e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a2:	48 c1 e8 27          	shr    $0x27,%rax
  8034a6:	48 89 c2             	mov    %rax,%rdx
  8034a9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8034b0:	01 00 00 
  8034b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034b7:	83 e0 01             	and    $0x1,%eax
  8034ba:	48 85 c0             	test   %rax,%rax
  8034bd:	0f 84 9e 00 00 00    	je     803561 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8034c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c7:	48 c1 e8 1e          	shr    $0x1e,%rax
  8034cb:	48 89 c2             	mov    %rax,%rdx
  8034ce:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8034d5:	01 00 00 
  8034d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034dc:	83 e0 01             	and    $0x1,%eax
  8034df:	48 85 c0             	test   %rax,%rax
  8034e2:	74 73                	je     803557 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  8034e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034e8:	48 c1 e8 15          	shr    $0x15,%rax
  8034ec:	48 89 c2             	mov    %rax,%rdx
  8034ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8034f6:	01 00 00 
  8034f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034fd:	83 e0 01             	and    $0x1,%eax
  803500:	48 85 c0             	test   %rax,%rax
  803503:	74 48                	je     80354d <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  803505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803509:	48 c1 e8 0c          	shr    $0xc,%rax
  80350d:	48 89 c2             	mov    %rax,%rdx
  803510:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803517:	01 00 00 
  80351a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80351e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803526:	83 e0 01             	and    $0x1,%eax
  803529:	48 85 c0             	test   %rax,%rax
  80352c:	74 47                	je     803575 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80352e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803532:	48 c1 e8 0c          	shr    $0xc,%rax
  803536:	89 c2                	mov    %eax,%edx
  803538:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80353b:	89 d6                	mov    %edx,%esi
  80353d:	89 c7                	mov    %eax,%edi
  80353f:	48 b8 8c 31 80 00 00 	movabs $0x80318c,%rax
  803546:	00 00 00 
  803549:	ff d0                	callq  *%rax
  80354b:	eb 28                	jmp    803575 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80354d:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  803554:	00 
  803555:	eb 1e                	jmp    803575 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  803557:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80355e:	40 
  80355f:	eb 14                	jmp    803575 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  803561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803565:	48 c1 e8 27          	shr    $0x27,%rax
  803569:	48 83 c0 01          	add    $0x1,%rax
  80356d:	48 c1 e0 27          	shl    $0x27,%rax
  803571:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  803575:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80357c:	00 
  80357d:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  803584:	00 
  803585:	0f 87 13 ff ff ff    	ja     80349e <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80358b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80358e:	ba 07 00 00 00       	mov    $0x7,%edx
  803593:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803598:	89 c7                	mov    %eax,%edi
  80359a:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  8035a1:	00 00 00 
  8035a4:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8035a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035a9:	ba 07 00 00 00       	mov    $0x7,%edx
  8035ae:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8035b3:	89 c7                	mov    %eax,%edi
  8035b5:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  8035bc:	00 00 00 
  8035bf:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8035c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035c4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8035ca:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8035cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8035d4:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8035d9:	89 c7                	mov    %eax,%edi
  8035db:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  8035e2:	00 00 00 
  8035e5:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8035e7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8035ec:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8035f1:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8035f6:	48 b8 9e 25 80 00 00 	movabs $0x80259e,%rax
  8035fd:	00 00 00 
  803600:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  803602:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  803607:	bf 00 00 00 00       	mov    $0x0,%edi
  80360c:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  803613:	00 00 00 
  803616:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  803618:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80361f:	00 00 00 
  803622:	48 8b 00             	mov    (%rax),%rax
  803625:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80362c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80362f:	48 89 d6             	mov    %rdx,%rsi
  803632:	89 c7                	mov    %eax,%edi
  803634:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  80363b:	00 00 00 
  80363e:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  803640:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803643:	be 02 00 00 00       	mov    $0x2,%esi
  803648:	89 c7                	mov    %eax,%edi
  80364a:	48 b8 9e 2c 80 00 00 	movabs $0x802c9e,%rax
  803651:	00 00 00 
  803654:	ff d0                	callq  *%rax

	return envid;
  803656:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  803659:	c9                   	leaveq 
  80365a:	c3                   	retq   

000000000080365b <sfork>:

	
// Challenge!
int
sfork(void)
{
  80365b:	55                   	push   %rbp
  80365c:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80365f:	48 ba 58 6a 80 00 00 	movabs $0x806a58,%rdx
  803666:	00 00 00 
  803669:	be bf 00 00 00       	mov    $0xbf,%esi
  80366e:	48 bf 9d 69 80 00 00 	movabs $0x80699d,%rdi
  803675:	00 00 00 
  803678:	b8 00 00 00 00       	mov    $0x0,%eax
  80367d:	48 b9 32 13 80 00 00 	movabs $0x801332,%rcx
  803684:	00 00 00 
  803687:	ff d1                	callq  *%rcx

0000000000803689 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  803689:	55                   	push   %rbp
  80368a:	48 89 e5             	mov    %rsp,%rbp
  80368d:	48 83 ec 18          	sub    $0x18,%rsp
  803691:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803695:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803699:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  80369d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036a5:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  8036a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036b0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8036b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b8:	8b 00                	mov    (%rax),%eax
  8036ba:	83 f8 01             	cmp    $0x1,%eax
  8036bd:	7e 13                	jle    8036d2 <argstart+0x49>
  8036bf:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8036c4:	74 0c                	je     8036d2 <argstart+0x49>
  8036c6:	48 b8 6e 6a 80 00 00 	movabs $0x806a6e,%rax
  8036cd:	00 00 00 
  8036d0:	eb 05                	jmp    8036d7 <argstart+0x4e>
  8036d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036db:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8036df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e3:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8036ea:	00 
}
  8036eb:	c9                   	leaveq 
  8036ec:	c3                   	retq   

00000000008036ed <argnext>:

int
argnext(struct Argstate *args)
{
  8036ed:	55                   	push   %rbp
  8036ee:	48 89 e5             	mov    %rsp,%rbp
  8036f1:	48 83 ec 20          	sub    $0x20,%rsp
  8036f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  8036f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036fd:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803704:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  803705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803709:	48 8b 40 10          	mov    0x10(%rax),%rax
  80370d:	48 85 c0             	test   %rax,%rax
  803710:	75 0a                	jne    80371c <argnext+0x2f>
		return -1;
  803712:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  803717:	e9 25 01 00 00       	jmpq   803841 <argnext+0x154>

	if (!*args->curarg) {
  80371c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803720:	48 8b 40 10          	mov    0x10(%rax),%rax
  803724:	0f b6 00             	movzbl (%rax),%eax
  803727:	84 c0                	test   %al,%al
  803729:	0f 85 d7 00 00 00    	jne    803806 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80372f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803733:	48 8b 00             	mov    (%rax),%rax
  803736:	8b 00                	mov    (%rax),%eax
  803738:	83 f8 01             	cmp    $0x1,%eax
  80373b:	0f 84 ef 00 00 00    	je     803830 <argnext+0x143>
		    || args->argv[1][0] != '-'
  803741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803745:	48 8b 40 08          	mov    0x8(%rax),%rax
  803749:	48 83 c0 08          	add    $0x8,%rax
  80374d:	48 8b 00             	mov    (%rax),%rax
  803750:	0f b6 00             	movzbl (%rax),%eax
  803753:	3c 2d                	cmp    $0x2d,%al
  803755:	0f 85 d5 00 00 00    	jne    803830 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  80375b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80375f:	48 8b 40 08          	mov    0x8(%rax),%rax
  803763:	48 83 c0 08          	add    $0x8,%rax
  803767:	48 8b 00             	mov    (%rax),%rax
  80376a:	48 83 c0 01          	add    $0x1,%rax
  80376e:	0f b6 00             	movzbl (%rax),%eax
  803771:	84 c0                	test   %al,%al
  803773:	0f 84 b7 00 00 00    	je     803830 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  803779:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80377d:	48 8b 40 08          	mov    0x8(%rax),%rax
  803781:	48 83 c0 08          	add    $0x8,%rax
  803785:	48 8b 00             	mov    (%rax),%rax
  803788:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80378c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803790:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803798:	48 8b 00             	mov    (%rax),%rax
  80379b:	8b 00                	mov    (%rax),%eax
  80379d:	83 e8 01             	sub    $0x1,%eax
  8037a0:	48 98                	cltq   
  8037a2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8037a9:	00 
  8037aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037ae:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037b2:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8037b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037ba:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037be:	48 83 c0 08          	add    $0x8,%rax
  8037c2:	48 89 ce             	mov    %rcx,%rsi
  8037c5:	48 89 c7             	mov    %rax,%rdi
  8037c8:	48 b8 9e 25 80 00 00 	movabs $0x80259e,%rax
  8037cf:	00 00 00 
  8037d2:	ff d0                	callq  *%rax
		(*args->argc)--;
  8037d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d8:	48 8b 00             	mov    (%rax),%rax
  8037db:	8b 10                	mov    (%rax),%edx
  8037dd:	83 ea 01             	sub    $0x1,%edx
  8037e0:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8037e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037e6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8037ea:	0f b6 00             	movzbl (%rax),%eax
  8037ed:	3c 2d                	cmp    $0x2d,%al
  8037ef:	75 15                	jne    803806 <argnext+0x119>
  8037f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8037f9:	48 83 c0 01          	add    $0x1,%rax
  8037fd:	0f b6 00             	movzbl (%rax),%eax
  803800:	84 c0                	test   %al,%al
  803802:	75 02                	jne    803806 <argnext+0x119>
			goto endofargs;
  803804:	eb 2a                	jmp    803830 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  803806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80380a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80380e:	0f b6 00             	movzbl (%rax),%eax
  803811:	0f b6 c0             	movzbl %al,%eax
  803814:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  803817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80381b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80381f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803827:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  80382b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382e:	eb 11                	jmp    803841 <argnext+0x154>

endofargs:
	args->curarg = 0;
  803830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803834:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80383b:	00 
	return -1;
  80383c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803841:	c9                   	leaveq 
  803842:	c3                   	retq   

0000000000803843 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  803843:	55                   	push   %rbp
  803844:	48 89 e5             	mov    %rsp,%rbp
  803847:	48 83 ec 10          	sub    $0x10,%rsp
  80384b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80384f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803853:	48 8b 40 18          	mov    0x18(%rax),%rax
  803857:	48 85 c0             	test   %rax,%rax
  80385a:	74 0a                	je     803866 <argvalue+0x23>
  80385c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803860:	48 8b 40 18          	mov    0x18(%rax),%rax
  803864:	eb 13                	jmp    803879 <argvalue+0x36>
  803866:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80386a:	48 89 c7             	mov    %rax,%rdi
  80386d:	48 b8 7b 38 80 00 00 	movabs $0x80387b,%rax
  803874:	00 00 00 
  803877:	ff d0                	callq  *%rax
}
  803879:	c9                   	leaveq 
  80387a:	c3                   	retq   

000000000080387b <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  80387b:	55                   	push   %rbp
  80387c:	48 89 e5             	mov    %rsp,%rbp
  80387f:	53                   	push   %rbx
  803880:	48 83 ec 18          	sub    $0x18,%rsp
  803884:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  803888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80388c:	48 8b 40 10          	mov    0x10(%rax),%rax
  803890:	48 85 c0             	test   %rax,%rax
  803893:	75 0a                	jne    80389f <argnextvalue+0x24>
		return 0;
  803895:	b8 00 00 00 00       	mov    $0x0,%eax
  80389a:	e9 c8 00 00 00       	jmpq   803967 <argnextvalue+0xec>
	if (*args->curarg) {
  80389f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038a3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8038a7:	0f b6 00             	movzbl (%rax),%eax
  8038aa:	84 c0                	test   %al,%al
  8038ac:	74 27                	je     8038d5 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  8038ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038b2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8038b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ba:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8038be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038c2:	48 bb 6e 6a 80 00 00 	movabs $0x806a6e,%rbx
  8038c9:	00 00 00 
  8038cc:	48 89 58 10          	mov    %rbx,0x10(%rax)
  8038d0:	e9 8a 00 00 00       	jmpq   80395f <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  8038d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038d9:	48 8b 00             	mov    (%rax),%rax
  8038dc:	8b 00                	mov    (%rax),%eax
  8038de:	83 f8 01             	cmp    $0x1,%eax
  8038e1:	7e 64                	jle    803947 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  8038e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8038eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8038ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038f3:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8038f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038fb:	48 8b 00             	mov    (%rax),%rax
  8038fe:	8b 00                	mov    (%rax),%eax
  803900:	83 e8 01             	sub    $0x1,%eax
  803903:	48 98                	cltq   
  803905:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80390c:	00 
  80390d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803911:	48 8b 40 08          	mov    0x8(%rax),%rax
  803915:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803919:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80391d:	48 8b 40 08          	mov    0x8(%rax),%rax
  803921:	48 83 c0 08          	add    $0x8,%rax
  803925:	48 89 ce             	mov    %rcx,%rsi
  803928:	48 89 c7             	mov    %rax,%rdi
  80392b:	48 b8 9e 25 80 00 00 	movabs $0x80259e,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
		(*args->argc)--;
  803937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80393b:	48 8b 00             	mov    (%rax),%rax
  80393e:	8b 10                	mov    (%rax),%edx
  803940:	83 ea 01             	sub    $0x1,%edx
  803943:	89 10                	mov    %edx,(%rax)
  803945:	eb 18                	jmp    80395f <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  803947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394b:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803952:	00 
		args->curarg = 0;
  803953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803957:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80395e:	00 
	}
	return (char*) args->argvalue;
  80395f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803963:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  803967:	48 83 c4 18          	add    $0x18,%rsp
  80396b:	5b                   	pop    %rbx
  80396c:	5d                   	pop    %rbp
  80396d:	c3                   	retq   

000000000080396e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80396e:	55                   	push   %rbp
  80396f:	48 89 e5             	mov    %rsp,%rbp
  803972:	48 83 ec 08          	sub    $0x8,%rsp
  803976:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80397a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80397e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  803985:	ff ff ff 
  803988:	48 01 d0             	add    %rdx,%rax
  80398b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80398f:	c9                   	leaveq 
  803990:	c3                   	retq   

0000000000803991 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  803991:	55                   	push   %rbp
  803992:	48 89 e5             	mov    %rsp,%rbp
  803995:	48 83 ec 08          	sub    $0x8,%rsp
  803999:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80399d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a1:	48 89 c7             	mov    %rax,%rdi
  8039a4:	48 b8 6e 39 80 00 00 	movabs $0x80396e,%rax
  8039ab:	00 00 00 
  8039ae:	ff d0                	callq  *%rax
  8039b0:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8039b6:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8039ba:	c9                   	leaveq 
  8039bb:	c3                   	retq   

00000000008039bc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8039bc:	55                   	push   %rbp
  8039bd:	48 89 e5             	mov    %rsp,%rbp
  8039c0:	48 83 ec 18          	sub    $0x18,%rsp
  8039c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8039c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039cf:	eb 6b                	jmp    803a3c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8039d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d4:	48 98                	cltq   
  8039d6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8039dc:	48 c1 e0 0c          	shl    $0xc,%rax
  8039e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8039e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e8:	48 c1 e8 15          	shr    $0x15,%rax
  8039ec:	48 89 c2             	mov    %rax,%rdx
  8039ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8039f6:	01 00 00 
  8039f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039fd:	83 e0 01             	and    $0x1,%eax
  803a00:	48 85 c0             	test   %rax,%rax
  803a03:	74 21                	je     803a26 <fd_alloc+0x6a>
  803a05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a09:	48 c1 e8 0c          	shr    $0xc,%rax
  803a0d:	48 89 c2             	mov    %rax,%rdx
  803a10:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a17:	01 00 00 
  803a1a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a1e:	83 e0 01             	and    $0x1,%eax
  803a21:	48 85 c0             	test   %rax,%rax
  803a24:	75 12                	jne    803a38 <fd_alloc+0x7c>
			*fd_store = fd;
  803a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a2e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803a31:	b8 00 00 00 00       	mov    $0x0,%eax
  803a36:	eb 1a                	jmp    803a52 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  803a38:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803a3c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803a40:	7e 8f                	jle    8039d1 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  803a42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a46:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  803a4d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  803a52:	c9                   	leaveq 
  803a53:	c3                   	retq   

0000000000803a54 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803a54:	55                   	push   %rbp
  803a55:	48 89 e5             	mov    %rsp,%rbp
  803a58:	48 83 ec 20          	sub    $0x20,%rsp
  803a5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803a63:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a67:	78 06                	js     803a6f <fd_lookup+0x1b>
  803a69:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  803a6d:	7e 07                	jle    803a76 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803a6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803a74:	eb 6c                	jmp    803ae2 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  803a76:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a79:	48 98                	cltq   
  803a7b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803a81:	48 c1 e0 0c          	shl    $0xc,%rax
  803a85:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  803a89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8d:	48 c1 e8 15          	shr    $0x15,%rax
  803a91:	48 89 c2             	mov    %rax,%rdx
  803a94:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a9b:	01 00 00 
  803a9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803aa2:	83 e0 01             	and    $0x1,%eax
  803aa5:	48 85 c0             	test   %rax,%rax
  803aa8:	74 21                	je     803acb <fd_lookup+0x77>
  803aaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aae:	48 c1 e8 0c          	shr    $0xc,%rax
  803ab2:	48 89 c2             	mov    %rax,%rdx
  803ab5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803abc:	01 00 00 
  803abf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ac3:	83 e0 01             	and    $0x1,%eax
  803ac6:	48 85 c0             	test   %rax,%rax
  803ac9:	75 07                	jne    803ad2 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803acb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803ad0:	eb 10                	jmp    803ae2 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  803ad2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ada:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  803add:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ae2:	c9                   	leaveq 
  803ae3:	c3                   	retq   

0000000000803ae4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  803ae4:	55                   	push   %rbp
  803ae5:	48 89 e5             	mov    %rsp,%rbp
  803ae8:	48 83 ec 30          	sub    $0x30,%rsp
  803aec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803af0:	89 f0                	mov    %esi,%eax
  803af2:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  803af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af9:	48 89 c7             	mov    %rax,%rdi
  803afc:	48 b8 6e 39 80 00 00 	movabs $0x80396e,%rax
  803b03:	00 00 00 
  803b06:	ff d0                	callq  *%rax
  803b08:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b0c:	48 89 d6             	mov    %rdx,%rsi
  803b0f:	89 c7                	mov    %eax,%edi
  803b11:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  803b18:	00 00 00 
  803b1b:	ff d0                	callq  *%rax
  803b1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b24:	78 0a                	js     803b30 <fd_close+0x4c>
	    || fd != fd2)
  803b26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803b2e:	74 12                	je     803b42 <fd_close+0x5e>
		return (must_exist ? r : 0);
  803b30:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803b34:	74 05                	je     803b3b <fd_close+0x57>
  803b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b39:	eb 05                	jmp    803b40 <fd_close+0x5c>
  803b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b40:	eb 69                	jmp    803bab <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803b42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b46:	8b 00                	mov    (%rax),%eax
  803b48:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b4c:	48 89 d6             	mov    %rdx,%rsi
  803b4f:	89 c7                	mov    %eax,%edi
  803b51:	48 b8 ad 3b 80 00 00 	movabs $0x803bad,%rax
  803b58:	00 00 00 
  803b5b:	ff d0                	callq  *%rax
  803b5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b64:	78 2a                	js     803b90 <fd_close+0xac>
		if (dev->dev_close)
  803b66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b6a:	48 8b 40 20          	mov    0x20(%rax),%rax
  803b6e:	48 85 c0             	test   %rax,%rax
  803b71:	74 16                	je     803b89 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  803b73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b77:	48 8b 40 20          	mov    0x20(%rax),%rax
  803b7b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b7f:	48 89 d7             	mov    %rdx,%rdi
  803b82:	ff d0                	callq  *%rax
  803b84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b87:	eb 07                	jmp    803b90 <fd_close+0xac>
		else
			r = 0;
  803b89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803b90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b94:	48 89 c6             	mov    %rax,%rsi
  803b97:	bf 00 00 00 00       	mov    $0x0,%edi
  803b9c:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  803ba3:	00 00 00 
  803ba6:	ff d0                	callq  *%rax
	return r;
  803ba8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bab:	c9                   	leaveq 
  803bac:	c3                   	retq   

0000000000803bad <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803bad:	55                   	push   %rbp
  803bae:	48 89 e5             	mov    %rsp,%rbp
  803bb1:	48 83 ec 20          	sub    $0x20,%rsp
  803bb5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bb8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  803bbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bc3:	eb 41                	jmp    803c06 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803bc5:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803bcc:	00 00 00 
  803bcf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bd2:	48 63 d2             	movslq %edx,%rdx
  803bd5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bd9:	8b 00                	mov    (%rax),%eax
  803bdb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803bde:	75 22                	jne    803c02 <dev_lookup+0x55>
			*dev = devtab[i];
  803be0:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803be7:	00 00 00 
  803bea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bed:	48 63 d2             	movslq %edx,%rdx
  803bf0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  803bf4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bf8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  803c00:	eb 60                	jmp    803c62 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  803c02:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c06:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803c0d:	00 00 00 
  803c10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c13:	48 63 d2             	movslq %edx,%rdx
  803c16:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c1a:	48 85 c0             	test   %rax,%rax
  803c1d:	75 a6                	jne    803bc5 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  803c1f:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803c26:	00 00 00 
  803c29:	48 8b 00             	mov    (%rax),%rax
  803c2c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803c32:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c35:	89 c6                	mov    %eax,%esi
  803c37:	48 bf 70 6a 80 00 00 	movabs $0x806a70,%rdi
  803c3e:	00 00 00 
  803c41:	b8 00 00 00 00       	mov    $0x0,%eax
  803c46:	48 b9 6b 15 80 00 00 	movabs $0x80156b,%rcx
  803c4d:	00 00 00 
  803c50:	ff d1                	callq  *%rcx
	*dev = 0;
  803c52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c56:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803c5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803c62:	c9                   	leaveq 
  803c63:	c3                   	retq   

0000000000803c64 <close>:

int
close(int fdnum)
{
  803c64:	55                   	push   %rbp
  803c65:	48 89 e5             	mov    %rsp,%rbp
  803c68:	48 83 ec 20          	sub    $0x20,%rsp
  803c6c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c6f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c73:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c76:	48 89 d6             	mov    %rdx,%rsi
  803c79:	89 c7                	mov    %eax,%edi
  803c7b:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  803c82:	00 00 00 
  803c85:	ff d0                	callq  *%rax
  803c87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c8e:	79 05                	jns    803c95 <close+0x31>
		return r;
  803c90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c93:	eb 18                	jmp    803cad <close+0x49>
	else
		return fd_close(fd, 1);
  803c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c99:	be 01 00 00 00       	mov    $0x1,%esi
  803c9e:	48 89 c7             	mov    %rax,%rdi
  803ca1:	48 b8 e4 3a 80 00 00 	movabs $0x803ae4,%rax
  803ca8:	00 00 00 
  803cab:	ff d0                	callq  *%rax
}
  803cad:	c9                   	leaveq 
  803cae:	c3                   	retq   

0000000000803caf <close_all>:

void
close_all(void)
{
  803caf:	55                   	push   %rbp
  803cb0:	48 89 e5             	mov    %rsp,%rbp
  803cb3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803cb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cbe:	eb 15                	jmp    803cd5 <close_all+0x26>
		close(i);
  803cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc3:	89 c7                	mov    %eax,%edi
  803cc5:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  803ccc:	00 00 00 
  803ccf:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803cd1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803cd5:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803cd9:	7e e5                	jle    803cc0 <close_all+0x11>
		close(i);
}
  803cdb:	c9                   	leaveq 
  803cdc:	c3                   	retq   

0000000000803cdd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  803cdd:	55                   	push   %rbp
  803cde:	48 89 e5             	mov    %rsp,%rbp
  803ce1:	48 83 ec 40          	sub    $0x40,%rsp
  803ce5:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803ce8:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803ceb:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803cef:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803cf2:	48 89 d6             	mov    %rdx,%rsi
  803cf5:	89 c7                	mov    %eax,%edi
  803cf7:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  803cfe:	00 00 00 
  803d01:	ff d0                	callq  *%rax
  803d03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d0a:	79 08                	jns    803d14 <dup+0x37>
		return r;
  803d0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d0f:	e9 70 01 00 00       	jmpq   803e84 <dup+0x1a7>
	close(newfdnum);
  803d14:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803d17:	89 c7                	mov    %eax,%edi
  803d19:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  803d20:	00 00 00 
  803d23:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803d25:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803d28:	48 98                	cltq   
  803d2a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803d30:	48 c1 e0 0c          	shl    $0xc,%rax
  803d34:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803d38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d3c:	48 89 c7             	mov    %rax,%rdi
  803d3f:	48 b8 91 39 80 00 00 	movabs $0x803991,%rax
  803d46:	00 00 00 
  803d49:	ff d0                	callq  *%rax
  803d4b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803d4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d53:	48 89 c7             	mov    %rax,%rdi
  803d56:	48 b8 91 39 80 00 00 	movabs $0x803991,%rax
  803d5d:	00 00 00 
  803d60:	ff d0                	callq  *%rax
  803d62:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803d66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d6a:	48 c1 e8 15          	shr    $0x15,%rax
  803d6e:	48 89 c2             	mov    %rax,%rdx
  803d71:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d78:	01 00 00 
  803d7b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d7f:	83 e0 01             	and    $0x1,%eax
  803d82:	48 85 c0             	test   %rax,%rax
  803d85:	74 73                	je     803dfa <dup+0x11d>
  803d87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d8b:	48 c1 e8 0c          	shr    $0xc,%rax
  803d8f:	48 89 c2             	mov    %rax,%rdx
  803d92:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d99:	01 00 00 
  803d9c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803da0:	83 e0 01             	and    $0x1,%eax
  803da3:	48 85 c0             	test   %rax,%rax
  803da6:	74 52                	je     803dfa <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803da8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dac:	48 c1 e8 0c          	shr    $0xc,%rax
  803db0:	48 89 c2             	mov    %rax,%rdx
  803db3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803dba:	01 00 00 
  803dbd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dc1:	25 07 0e 00 00       	and    $0xe07,%eax
  803dc6:	89 c1                	mov    %eax,%ecx
  803dc8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803dcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dd0:	41 89 c8             	mov    %ecx,%r8d
  803dd3:	48 89 d1             	mov    %rdx,%rcx
  803dd6:	ba 00 00 00 00       	mov    $0x0,%edx
  803ddb:	48 89 c6             	mov    %rax,%rsi
  803dde:	bf 00 00 00 00       	mov    $0x0,%edi
  803de3:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  803dea:	00 00 00 
  803ded:	ff d0                	callq  *%rax
  803def:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803df2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803df6:	79 02                	jns    803dfa <dup+0x11d>
			goto err;
  803df8:	eb 57                	jmp    803e51 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803dfa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dfe:	48 c1 e8 0c          	shr    $0xc,%rax
  803e02:	48 89 c2             	mov    %rax,%rdx
  803e05:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e0c:	01 00 00 
  803e0f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e13:	25 07 0e 00 00       	and    $0xe07,%eax
  803e18:	89 c1                	mov    %eax,%ecx
  803e1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e22:	41 89 c8             	mov    %ecx,%r8d
  803e25:	48 89 d1             	mov    %rdx,%rcx
  803e28:	ba 00 00 00 00       	mov    $0x0,%edx
  803e2d:	48 89 c6             	mov    %rax,%rsi
  803e30:	bf 00 00 00 00       	mov    $0x0,%edi
  803e35:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  803e3c:	00 00 00 
  803e3f:	ff d0                	callq  *%rax
  803e41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e48:	79 02                	jns    803e4c <dup+0x16f>
		goto err;
  803e4a:	eb 05                	jmp    803e51 <dup+0x174>

	return newfdnum;
  803e4c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803e4f:	eb 33                	jmp    803e84 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803e51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e55:	48 89 c6             	mov    %rax,%rsi
  803e58:	bf 00 00 00 00       	mov    $0x0,%edi
  803e5d:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  803e64:	00 00 00 
  803e67:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803e69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e6d:	48 89 c6             	mov    %rax,%rsi
  803e70:	bf 00 00 00 00       	mov    $0x0,%edi
  803e75:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  803e7c:	00 00 00 
  803e7f:	ff d0                	callq  *%rax
	return r;
  803e81:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e84:	c9                   	leaveq 
  803e85:	c3                   	retq   

0000000000803e86 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803e86:	55                   	push   %rbp
  803e87:	48 89 e5             	mov    %rsp,%rbp
  803e8a:	48 83 ec 40          	sub    $0x40,%rsp
  803e8e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803e91:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e95:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803e99:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803e9d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ea0:	48 89 d6             	mov    %rdx,%rsi
  803ea3:	89 c7                	mov    %eax,%edi
  803ea5:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  803eac:	00 00 00 
  803eaf:	ff d0                	callq  *%rax
  803eb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb8:	78 24                	js     803ede <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803eba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ebe:	8b 00                	mov    (%rax),%eax
  803ec0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ec4:	48 89 d6             	mov    %rdx,%rsi
  803ec7:	89 c7                	mov    %eax,%edi
  803ec9:	48 b8 ad 3b 80 00 00 	movabs $0x803bad,%rax
  803ed0:	00 00 00 
  803ed3:	ff d0                	callq  *%rax
  803ed5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ed8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803edc:	79 05                	jns    803ee3 <read+0x5d>
		return r;
  803ede:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee1:	eb 76                	jmp    803f59 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803ee3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee7:	8b 40 08             	mov    0x8(%rax),%eax
  803eea:	83 e0 03             	and    $0x3,%eax
  803eed:	83 f8 01             	cmp    $0x1,%eax
  803ef0:	75 3a                	jne    803f2c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803ef2:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803ef9:	00 00 00 
  803efc:	48 8b 00             	mov    (%rax),%rax
  803eff:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f05:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f08:	89 c6                	mov    %eax,%esi
  803f0a:	48 bf 8f 6a 80 00 00 	movabs $0x806a8f,%rdi
  803f11:	00 00 00 
  803f14:	b8 00 00 00 00       	mov    $0x0,%eax
  803f19:	48 b9 6b 15 80 00 00 	movabs $0x80156b,%rcx
  803f20:	00 00 00 
  803f23:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803f25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803f2a:	eb 2d                	jmp    803f59 <read+0xd3>
	}
	if (!dev->dev_read)
  803f2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f30:	48 8b 40 10          	mov    0x10(%rax),%rax
  803f34:	48 85 c0             	test   %rax,%rax
  803f37:	75 07                	jne    803f40 <read+0xba>
		return -E_NOT_SUPP;
  803f39:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803f3e:	eb 19                	jmp    803f59 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803f40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f44:	48 8b 40 10          	mov    0x10(%rax),%rax
  803f48:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f4c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803f50:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803f54:	48 89 cf             	mov    %rcx,%rdi
  803f57:	ff d0                	callq  *%rax
}
  803f59:	c9                   	leaveq 
  803f5a:	c3                   	retq   

0000000000803f5b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803f5b:	55                   	push   %rbp
  803f5c:	48 89 e5             	mov    %rsp,%rbp
  803f5f:	48 83 ec 30          	sub    $0x30,%rsp
  803f63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f75:	eb 49                	jmp    803fc0 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803f77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f7a:	48 98                	cltq   
  803f7c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803f80:	48 29 c2             	sub    %rax,%rdx
  803f83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f86:	48 63 c8             	movslq %eax,%rcx
  803f89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f8d:	48 01 c1             	add    %rax,%rcx
  803f90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f93:	48 89 ce             	mov    %rcx,%rsi
  803f96:	89 c7                	mov    %eax,%edi
  803f98:	48 b8 86 3e 80 00 00 	movabs $0x803e86,%rax
  803f9f:	00 00 00 
  803fa2:	ff d0                	callq  *%rax
  803fa4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803fa7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803fab:	79 05                	jns    803fb2 <readn+0x57>
			return m;
  803fad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fb0:	eb 1c                	jmp    803fce <readn+0x73>
		if (m == 0)
  803fb2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803fb6:	75 02                	jne    803fba <readn+0x5f>
			break;
  803fb8:	eb 11                	jmp    803fcb <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803fba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fbd:	01 45 fc             	add    %eax,-0x4(%rbp)
  803fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc3:	48 98                	cltq   
  803fc5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803fc9:	72 ac                	jb     803f77 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803fcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fce:	c9                   	leaveq 
  803fcf:	c3                   	retq   

0000000000803fd0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803fd0:	55                   	push   %rbp
  803fd1:	48 89 e5             	mov    %rsp,%rbp
  803fd4:	48 83 ec 40          	sub    $0x40,%rsp
  803fd8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803fdb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803fdf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803fe3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803fe7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fea:	48 89 d6             	mov    %rdx,%rsi
  803fed:	89 c7                	mov    %eax,%edi
  803fef:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  803ff6:	00 00 00 
  803ff9:	ff d0                	callq  *%rax
  803ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ffe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804002:	78 24                	js     804028 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  804004:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804008:	8b 00                	mov    (%rax),%eax
  80400a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80400e:	48 89 d6             	mov    %rdx,%rsi
  804011:	89 c7                	mov    %eax,%edi
  804013:	48 b8 ad 3b 80 00 00 	movabs $0x803bad,%rax
  80401a:	00 00 00 
  80401d:	ff d0                	callq  *%rax
  80401f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804022:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804026:	79 05                	jns    80402d <write+0x5d>
		return r;
  804028:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80402b:	eb 42                	jmp    80406f <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80402d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804031:	8b 40 08             	mov    0x8(%rax),%eax
  804034:	83 e0 03             	and    $0x3,%eax
  804037:	85 c0                	test   %eax,%eax
  804039:	75 07                	jne    804042 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80403b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804040:	eb 2d                	jmp    80406f <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  804042:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804046:	48 8b 40 18          	mov    0x18(%rax),%rax
  80404a:	48 85 c0             	test   %rax,%rax
  80404d:	75 07                	jne    804056 <write+0x86>
		return -E_NOT_SUPP;
  80404f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804054:	eb 19                	jmp    80406f <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  804056:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80405a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80405e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804062:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  804066:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80406a:	48 89 cf             	mov    %rcx,%rdi
  80406d:	ff d0                	callq  *%rax
}
  80406f:	c9                   	leaveq 
  804070:	c3                   	retq   

0000000000804071 <seek>:

int
seek(int fdnum, off_t offset)
{
  804071:	55                   	push   %rbp
  804072:	48 89 e5             	mov    %rsp,%rbp
  804075:	48 83 ec 18          	sub    $0x18,%rsp
  804079:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80407c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80407f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804083:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804086:	48 89 d6             	mov    %rdx,%rsi
  804089:	89 c7                	mov    %eax,%edi
  80408b:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  804092:	00 00 00 
  804095:	ff d0                	callq  *%rax
  804097:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80409a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80409e:	79 05                	jns    8040a5 <seek+0x34>
		return r;
  8040a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a3:	eb 0f                	jmp    8040b4 <seek+0x43>
	fd->fd_offset = offset;
  8040a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8040ac:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8040af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040b4:	c9                   	leaveq 
  8040b5:	c3                   	retq   

00000000008040b6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8040b6:	55                   	push   %rbp
  8040b7:	48 89 e5             	mov    %rsp,%rbp
  8040ba:	48 83 ec 30          	sub    $0x30,%rsp
  8040be:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8040c1:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8040c4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8040c8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040cb:	48 89 d6             	mov    %rdx,%rsi
  8040ce:	89 c7                	mov    %eax,%edi
  8040d0:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  8040d7:	00 00 00 
  8040da:	ff d0                	callq  *%rax
  8040dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040e3:	78 24                	js     804109 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8040e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040e9:	8b 00                	mov    (%rax),%eax
  8040eb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8040ef:	48 89 d6             	mov    %rdx,%rsi
  8040f2:	89 c7                	mov    %eax,%edi
  8040f4:	48 b8 ad 3b 80 00 00 	movabs $0x803bad,%rax
  8040fb:	00 00 00 
  8040fe:	ff d0                	callq  *%rax
  804100:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804103:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804107:	79 05                	jns    80410e <ftruncate+0x58>
		return r;
  804109:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80410c:	eb 72                	jmp    804180 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80410e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804112:	8b 40 08             	mov    0x8(%rax),%eax
  804115:	83 e0 03             	and    $0x3,%eax
  804118:	85 c0                	test   %eax,%eax
  80411a:	75 3a                	jne    804156 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80411c:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  804123:	00 00 00 
  804126:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  804129:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80412f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804132:	89 c6                	mov    %eax,%esi
  804134:	48 bf b0 6a 80 00 00 	movabs $0x806ab0,%rdi
  80413b:	00 00 00 
  80413e:	b8 00 00 00 00       	mov    $0x0,%eax
  804143:	48 b9 6b 15 80 00 00 	movabs $0x80156b,%rcx
  80414a:	00 00 00 
  80414d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80414f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804154:	eb 2a                	jmp    804180 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  804156:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80415a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80415e:	48 85 c0             	test   %rax,%rax
  804161:	75 07                	jne    80416a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  804163:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804168:	eb 16                	jmp    804180 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80416a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80416e:	48 8b 40 30          	mov    0x30(%rax),%rax
  804172:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804176:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804179:	89 ce                	mov    %ecx,%esi
  80417b:	48 89 d7             	mov    %rdx,%rdi
  80417e:	ff d0                	callq  *%rax
}
  804180:	c9                   	leaveq 
  804181:	c3                   	retq   

0000000000804182 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  804182:	55                   	push   %rbp
  804183:	48 89 e5             	mov    %rsp,%rbp
  804186:	48 83 ec 30          	sub    $0x30,%rsp
  80418a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80418d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  804191:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804195:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804198:	48 89 d6             	mov    %rdx,%rsi
  80419b:	89 c7                	mov    %eax,%edi
  80419d:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  8041a4:	00 00 00 
  8041a7:	ff d0                	callq  *%rax
  8041a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041b0:	78 24                	js     8041d6 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8041b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041b6:	8b 00                	mov    (%rax),%eax
  8041b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8041bc:	48 89 d6             	mov    %rdx,%rsi
  8041bf:	89 c7                	mov    %eax,%edi
  8041c1:	48 b8 ad 3b 80 00 00 	movabs $0x803bad,%rax
  8041c8:	00 00 00 
  8041cb:	ff d0                	callq  *%rax
  8041cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041d4:	79 05                	jns    8041db <fstat+0x59>
		return r;
  8041d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d9:	eb 5e                	jmp    804239 <fstat+0xb7>
	if (!dev->dev_stat)
  8041db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041df:	48 8b 40 28          	mov    0x28(%rax),%rax
  8041e3:	48 85 c0             	test   %rax,%rax
  8041e6:	75 07                	jne    8041ef <fstat+0x6d>
		return -E_NOT_SUPP;
  8041e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8041ed:	eb 4a                	jmp    804239 <fstat+0xb7>
	stat->st_name[0] = 0;
  8041ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041f3:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8041f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041fa:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  804201:	00 00 00 
	stat->st_isdir = 0;
  804204:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804208:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80420f:	00 00 00 
	stat->st_dev = dev;
  804212:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804216:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80421a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  804221:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804225:	48 8b 40 28          	mov    0x28(%rax),%rax
  804229:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80422d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  804231:	48 89 ce             	mov    %rcx,%rsi
  804234:	48 89 d7             	mov    %rdx,%rdi
  804237:	ff d0                	callq  *%rax
}
  804239:	c9                   	leaveq 
  80423a:	c3                   	retq   

000000000080423b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80423b:	55                   	push   %rbp
  80423c:	48 89 e5             	mov    %rsp,%rbp
  80423f:	48 83 ec 20          	sub    $0x20,%rsp
  804243:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804247:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80424b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80424f:	be 00 00 00 00       	mov    $0x0,%esi
  804254:	48 89 c7             	mov    %rax,%rdi
  804257:	48 b8 29 43 80 00 00 	movabs $0x804329,%rax
  80425e:	00 00 00 
  804261:	ff d0                	callq  *%rax
  804263:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804266:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80426a:	79 05                	jns    804271 <stat+0x36>
		return fd;
  80426c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80426f:	eb 2f                	jmp    8042a0 <stat+0x65>
	r = fstat(fd, stat);
  804271:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804275:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804278:	48 89 d6             	mov    %rdx,%rsi
  80427b:	89 c7                	mov    %eax,%edi
  80427d:	48 b8 82 41 80 00 00 	movabs $0x804182,%rax
  804284:	00 00 00 
  804287:	ff d0                	callq  *%rax
  804289:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80428c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80428f:	89 c7                	mov    %eax,%edi
  804291:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  804298:	00 00 00 
  80429b:	ff d0                	callq  *%rax
	return r;
  80429d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8042a0:	c9                   	leaveq 
  8042a1:	c3                   	retq   

00000000008042a2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8042a2:	55                   	push   %rbp
  8042a3:	48 89 e5             	mov    %rsp,%rbp
  8042a6:	48 83 ec 10          	sub    $0x10,%rsp
  8042aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8042ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8042b1:	48 b8 20 94 80 00 00 	movabs $0x809420,%rax
  8042b8:	00 00 00 
  8042bb:	8b 00                	mov    (%rax),%eax
  8042bd:	85 c0                	test   %eax,%eax
  8042bf:	75 1d                	jne    8042de <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8042c1:	bf 01 00 00 00       	mov    $0x1,%edi
  8042c6:	48 b8 b3 60 80 00 00 	movabs $0x8060b3,%rax
  8042cd:	00 00 00 
  8042d0:	ff d0                	callq  *%rax
  8042d2:	48 ba 20 94 80 00 00 	movabs $0x809420,%rdx
  8042d9:	00 00 00 
  8042dc:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8042de:	48 b8 20 94 80 00 00 	movabs $0x809420,%rax
  8042e5:	00 00 00 
  8042e8:	8b 00                	mov    (%rax),%eax
  8042ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8042ed:	b9 07 00 00 00       	mov    $0x7,%ecx
  8042f2:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8042f9:	00 00 00 
  8042fc:	89 c7                	mov    %eax,%edi
  8042fe:	48 b8 2b 60 80 00 00 	movabs $0x80602b,%rax
  804305:	00 00 00 
  804308:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80430a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80430e:	ba 00 00 00 00       	mov    $0x0,%edx
  804313:	48 89 c6             	mov    %rax,%rsi
  804316:	bf 00 00 00 00       	mov    $0x0,%edi
  80431b:	48 b8 2d 5f 80 00 00 	movabs $0x805f2d,%rax
  804322:	00 00 00 
  804325:	ff d0                	callq  *%rax
}
  804327:	c9                   	leaveq 
  804328:	c3                   	retq   

0000000000804329 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  804329:	55                   	push   %rbp
  80432a:	48 89 e5             	mov    %rsp,%rbp
  80432d:	48 83 ec 30          	sub    $0x30,%rsp
  804331:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804335:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  804338:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80433f:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  804346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80434d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804352:	75 08                	jne    80435c <open+0x33>
	{
		return r;
  804354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804357:	e9 f2 00 00 00       	jmpq   80444e <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80435c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804360:	48 89 c7             	mov    %rax,%rdi
  804363:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  80436a:	00 00 00 
  80436d:	ff d0                	callq  *%rax
  80436f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804372:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  804379:	7e 0a                	jle    804385 <open+0x5c>
	{
		return -E_BAD_PATH;
  80437b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  804380:	e9 c9 00 00 00       	jmpq   80444e <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  804385:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80438c:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80438d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804391:	48 89 c7             	mov    %rax,%rdi
  804394:	48 b8 bc 39 80 00 00 	movabs $0x8039bc,%rax
  80439b:	00 00 00 
  80439e:	ff d0                	callq  *%rax
  8043a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043a7:	78 09                	js     8043b2 <open+0x89>
  8043a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043ad:	48 85 c0             	test   %rax,%rax
  8043b0:	75 08                	jne    8043ba <open+0x91>
		{
			return r;
  8043b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043b5:	e9 94 00 00 00       	jmpq   80444e <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8043ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043be:	ba 00 04 00 00       	mov    $0x400,%edx
  8043c3:	48 89 c6             	mov    %rax,%rsi
  8043c6:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8043cd:	00 00 00 
  8043d0:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  8043d7:	00 00 00 
  8043da:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8043dc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8043e3:	00 00 00 
  8043e6:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8043e9:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8043ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043f3:	48 89 c6             	mov    %rax,%rsi
  8043f6:	bf 01 00 00 00       	mov    $0x1,%edi
  8043fb:	48 b8 a2 42 80 00 00 	movabs $0x8042a2,%rax
  804402:	00 00 00 
  804405:	ff d0                	callq  *%rax
  804407:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80440a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80440e:	79 2b                	jns    80443b <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  804410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804414:	be 00 00 00 00       	mov    $0x0,%esi
  804419:	48 89 c7             	mov    %rax,%rdi
  80441c:	48 b8 e4 3a 80 00 00 	movabs $0x803ae4,%rax
  804423:	00 00 00 
  804426:	ff d0                	callq  *%rax
  804428:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80442b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80442f:	79 05                	jns    804436 <open+0x10d>
			{
				return d;
  804431:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804434:	eb 18                	jmp    80444e <open+0x125>
			}
			return r;
  804436:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804439:	eb 13                	jmp    80444e <open+0x125>
		}	
		return fd2num(fd_store);
  80443b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80443f:	48 89 c7             	mov    %rax,%rdi
  804442:	48 b8 6e 39 80 00 00 	movabs $0x80396e,%rax
  804449:	00 00 00 
  80444c:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80444e:	c9                   	leaveq 
  80444f:	c3                   	retq   

0000000000804450 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  804450:	55                   	push   %rbp
  804451:	48 89 e5             	mov    %rsp,%rbp
  804454:	48 83 ec 10          	sub    $0x10,%rsp
  804458:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80445c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804460:	8b 50 0c             	mov    0xc(%rax),%edx
  804463:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80446a:	00 00 00 
  80446d:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80446f:	be 00 00 00 00       	mov    $0x0,%esi
  804474:	bf 06 00 00 00       	mov    $0x6,%edi
  804479:	48 b8 a2 42 80 00 00 	movabs $0x8042a2,%rax
  804480:	00 00 00 
  804483:	ff d0                	callq  *%rax
}
  804485:	c9                   	leaveq 
  804486:	c3                   	retq   

0000000000804487 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  804487:	55                   	push   %rbp
  804488:	48 89 e5             	mov    %rsp,%rbp
  80448b:	48 83 ec 30          	sub    $0x30,%rsp
  80448f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804493:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804497:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80449b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8044a2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8044a7:	74 07                	je     8044b0 <devfile_read+0x29>
  8044a9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8044ae:	75 07                	jne    8044b7 <devfile_read+0x30>
		return -E_INVAL;
  8044b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8044b5:	eb 77                	jmp    80452e <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8044b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044bb:	8b 50 0c             	mov    0xc(%rax),%edx
  8044be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8044c5:	00 00 00 
  8044c8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8044ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8044d1:	00 00 00 
  8044d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8044d8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8044dc:	be 00 00 00 00       	mov    $0x0,%esi
  8044e1:	bf 03 00 00 00       	mov    $0x3,%edi
  8044e6:	48 b8 a2 42 80 00 00 	movabs $0x8042a2,%rax
  8044ed:	00 00 00 
  8044f0:	ff d0                	callq  *%rax
  8044f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044f9:	7f 05                	jg     804500 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8044fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044fe:	eb 2e                	jmp    80452e <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  804500:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804503:	48 63 d0             	movslq %eax,%rdx
  804506:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80450a:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  804511:	00 00 00 
  804514:	48 89 c7             	mov    %rax,%rdi
  804517:	48 b8 9e 25 80 00 00 	movabs $0x80259e,%rax
  80451e:	00 00 00 
  804521:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  804523:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804527:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80452b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80452e:	c9                   	leaveq 
  80452f:	c3                   	retq   

0000000000804530 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  804530:	55                   	push   %rbp
  804531:	48 89 e5             	mov    %rsp,%rbp
  804534:	48 83 ec 30          	sub    $0x30,%rsp
  804538:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80453c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804540:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  804544:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80454b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804550:	74 07                	je     804559 <devfile_write+0x29>
  804552:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804557:	75 08                	jne    804561 <devfile_write+0x31>
		return r;
  804559:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80455c:	e9 9a 00 00 00       	jmpq   8045fb <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  804561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804565:	8b 50 0c             	mov    0xc(%rax),%edx
  804568:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80456f:	00 00 00 
  804572:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  804574:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80457b:	00 
  80457c:	76 08                	jbe    804586 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80457e:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  804585:	00 
	}
	fsipcbuf.write.req_n = n;
  804586:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80458d:	00 00 00 
  804590:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804594:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  804598:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80459c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045a0:	48 89 c6             	mov    %rax,%rsi
  8045a3:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  8045aa:	00 00 00 
  8045ad:	48 b8 9e 25 80 00 00 	movabs $0x80259e,%rax
  8045b4:	00 00 00 
  8045b7:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8045b9:	be 00 00 00 00       	mov    $0x0,%esi
  8045be:	bf 04 00 00 00       	mov    $0x4,%edi
  8045c3:	48 b8 a2 42 80 00 00 	movabs $0x8042a2,%rax
  8045ca:	00 00 00 
  8045cd:	ff d0                	callq  *%rax
  8045cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045d6:	7f 20                	jg     8045f8 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8045d8:	48 bf d6 6a 80 00 00 	movabs $0x806ad6,%rdi
  8045df:	00 00 00 
  8045e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8045e7:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  8045ee:	00 00 00 
  8045f1:	ff d2                	callq  *%rdx
		return r;
  8045f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045f6:	eb 03                	jmp    8045fb <devfile_write+0xcb>
	}
	return r;
  8045f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8045fb:	c9                   	leaveq 
  8045fc:	c3                   	retq   

00000000008045fd <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8045fd:	55                   	push   %rbp
  8045fe:	48 89 e5             	mov    %rsp,%rbp
  804601:	48 83 ec 20          	sub    $0x20,%rsp
  804605:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804609:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80460d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804611:	8b 50 0c             	mov    0xc(%rax),%edx
  804614:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80461b:	00 00 00 
  80461e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  804620:	be 00 00 00 00       	mov    $0x0,%esi
  804625:	bf 05 00 00 00       	mov    $0x5,%edi
  80462a:	48 b8 a2 42 80 00 00 	movabs $0x8042a2,%rax
  804631:	00 00 00 
  804634:	ff d0                	callq  *%rax
  804636:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804639:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80463d:	79 05                	jns    804644 <devfile_stat+0x47>
		return r;
  80463f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804642:	eb 56                	jmp    80469a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  804644:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804648:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80464f:	00 00 00 
  804652:	48 89 c7             	mov    %rax,%rdi
  804655:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  80465c:	00 00 00 
  80465f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  804661:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804668:	00 00 00 
  80466b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  804671:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804675:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80467b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804682:	00 00 00 
  804685:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80468b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80468f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  804695:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80469a:	c9                   	leaveq 
  80469b:	c3                   	retq   

000000000080469c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80469c:	55                   	push   %rbp
  80469d:	48 89 e5             	mov    %rsp,%rbp
  8046a0:	48 83 ec 10          	sub    $0x10,%rsp
  8046a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8046a8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8046ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046af:	8b 50 0c             	mov    0xc(%rax),%edx
  8046b2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8046b9:	00 00 00 
  8046bc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8046be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8046c5:	00 00 00 
  8046c8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8046cb:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8046ce:	be 00 00 00 00       	mov    $0x0,%esi
  8046d3:	bf 02 00 00 00       	mov    $0x2,%edi
  8046d8:	48 b8 a2 42 80 00 00 	movabs $0x8042a2,%rax
  8046df:	00 00 00 
  8046e2:	ff d0                	callq  *%rax
}
  8046e4:	c9                   	leaveq 
  8046e5:	c3                   	retq   

00000000008046e6 <remove>:

// Delete a file
int
remove(const char *path)
{
  8046e6:	55                   	push   %rbp
  8046e7:	48 89 e5             	mov    %rsp,%rbp
  8046ea:	48 83 ec 10          	sub    $0x10,%rsp
  8046ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8046f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046f6:	48 89 c7             	mov    %rax,%rdi
  8046f9:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  804700:	00 00 00 
  804703:	ff d0                	callq  *%rax
  804705:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80470a:	7e 07                	jle    804713 <remove+0x2d>
		return -E_BAD_PATH;
  80470c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  804711:	eb 33                	jmp    804746 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  804713:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804717:	48 89 c6             	mov    %rax,%rsi
  80471a:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  804721:	00 00 00 
  804724:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  80472b:	00 00 00 
  80472e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  804730:	be 00 00 00 00       	mov    $0x0,%esi
  804735:	bf 07 00 00 00       	mov    $0x7,%edi
  80473a:	48 b8 a2 42 80 00 00 	movabs $0x8042a2,%rax
  804741:	00 00 00 
  804744:	ff d0                	callq  *%rax
}
  804746:	c9                   	leaveq 
  804747:	c3                   	retq   

0000000000804748 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  804748:	55                   	push   %rbp
  804749:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80474c:	be 00 00 00 00       	mov    $0x0,%esi
  804751:	bf 08 00 00 00       	mov    $0x8,%edi
  804756:	48 b8 a2 42 80 00 00 	movabs $0x8042a2,%rax
  80475d:	00 00 00 
  804760:	ff d0                	callq  *%rax
}
  804762:	5d                   	pop    %rbp
  804763:	c3                   	retq   

0000000000804764 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  804764:	55                   	push   %rbp
  804765:	48 89 e5             	mov    %rsp,%rbp
  804768:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80476f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  804776:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80477d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  804784:	be 00 00 00 00       	mov    $0x0,%esi
  804789:	48 89 c7             	mov    %rax,%rdi
  80478c:	48 b8 29 43 80 00 00 	movabs $0x804329,%rax
  804793:	00 00 00 
  804796:	ff d0                	callq  *%rax
  804798:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80479b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80479f:	79 28                	jns    8047c9 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8047a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a4:	89 c6                	mov    %eax,%esi
  8047a6:	48 bf f2 6a 80 00 00 	movabs $0x806af2,%rdi
  8047ad:	00 00 00 
  8047b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8047b5:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  8047bc:	00 00 00 
  8047bf:	ff d2                	callq  *%rdx
		return fd_src;
  8047c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047c4:	e9 74 01 00 00       	jmpq   80493d <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8047c9:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8047d0:	be 01 01 00 00       	mov    $0x101,%esi
  8047d5:	48 89 c7             	mov    %rax,%rdi
  8047d8:	48 b8 29 43 80 00 00 	movabs $0x804329,%rax
  8047df:	00 00 00 
  8047e2:	ff d0                	callq  *%rax
  8047e4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8047e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8047eb:	79 39                	jns    804826 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8047ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047f0:	89 c6                	mov    %eax,%esi
  8047f2:	48 bf 08 6b 80 00 00 	movabs $0x806b08,%rdi
  8047f9:	00 00 00 
  8047fc:	b8 00 00 00 00       	mov    $0x0,%eax
  804801:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  804808:	00 00 00 
  80480b:	ff d2                	callq  *%rdx
		close(fd_src);
  80480d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804810:	89 c7                	mov    %eax,%edi
  804812:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  804819:	00 00 00 
  80481c:	ff d0                	callq  *%rax
		return fd_dest;
  80481e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804821:	e9 17 01 00 00       	jmpq   80493d <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  804826:	eb 74                	jmp    80489c <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  804828:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80482b:	48 63 d0             	movslq %eax,%rdx
  80482e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  804835:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804838:	48 89 ce             	mov    %rcx,%rsi
  80483b:	89 c7                	mov    %eax,%edi
  80483d:	48 b8 d0 3f 80 00 00 	movabs $0x803fd0,%rax
  804844:	00 00 00 
  804847:	ff d0                	callq  *%rax
  804849:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80484c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  804850:	79 4a                	jns    80489c <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  804852:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804855:	89 c6                	mov    %eax,%esi
  804857:	48 bf 22 6b 80 00 00 	movabs $0x806b22,%rdi
  80485e:	00 00 00 
  804861:	b8 00 00 00 00       	mov    $0x0,%eax
  804866:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  80486d:	00 00 00 
  804870:	ff d2                	callq  *%rdx
			close(fd_src);
  804872:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804875:	89 c7                	mov    %eax,%edi
  804877:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  80487e:	00 00 00 
  804881:	ff d0                	callq  *%rax
			close(fd_dest);
  804883:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804886:	89 c7                	mov    %eax,%edi
  804888:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  80488f:	00 00 00 
  804892:	ff d0                	callq  *%rax
			return write_size;
  804894:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804897:	e9 a1 00 00 00       	jmpq   80493d <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80489c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8048a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048a6:	ba 00 02 00 00       	mov    $0x200,%edx
  8048ab:	48 89 ce             	mov    %rcx,%rsi
  8048ae:	89 c7                	mov    %eax,%edi
  8048b0:	48 b8 86 3e 80 00 00 	movabs $0x803e86,%rax
  8048b7:	00 00 00 
  8048ba:	ff d0                	callq  *%rax
  8048bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8048bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8048c3:	0f 8f 5f ff ff ff    	jg     804828 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8048c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8048cd:	79 47                	jns    804916 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8048cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8048d2:	89 c6                	mov    %eax,%esi
  8048d4:	48 bf 35 6b 80 00 00 	movabs $0x806b35,%rdi
  8048db:	00 00 00 
  8048de:	b8 00 00 00 00       	mov    $0x0,%eax
  8048e3:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  8048ea:	00 00 00 
  8048ed:	ff d2                	callq  *%rdx
		close(fd_src);
  8048ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048f2:	89 c7                	mov    %eax,%edi
  8048f4:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  8048fb:	00 00 00 
  8048fe:	ff d0                	callq  *%rax
		close(fd_dest);
  804900:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804903:	89 c7                	mov    %eax,%edi
  804905:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  80490c:	00 00 00 
  80490f:	ff d0                	callq  *%rax
		return read_size;
  804911:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804914:	eb 27                	jmp    80493d <copy+0x1d9>
	}
	close(fd_src);
  804916:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804919:	89 c7                	mov    %eax,%edi
  80491b:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  804922:	00 00 00 
  804925:	ff d0                	callq  *%rax
	close(fd_dest);
  804927:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80492a:	89 c7                	mov    %eax,%edi
  80492c:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  804933:	00 00 00 
  804936:	ff d0                	callq  *%rax
	return 0;
  804938:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80493d:	c9                   	leaveq 
  80493e:	c3                   	retq   

000000000080493f <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80493f:	55                   	push   %rbp
  804940:	48 89 e5             	mov    %rsp,%rbp
  804943:	48 83 ec 20          	sub    $0x20,%rsp
  804947:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  80494b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80494f:	8b 40 0c             	mov    0xc(%rax),%eax
  804952:	85 c0                	test   %eax,%eax
  804954:	7e 67                	jle    8049bd <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  804956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80495a:	8b 40 04             	mov    0x4(%rax),%eax
  80495d:	48 63 d0             	movslq %eax,%rdx
  804960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804964:	48 8d 48 10          	lea    0x10(%rax),%rcx
  804968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80496c:	8b 00                	mov    (%rax),%eax
  80496e:	48 89 ce             	mov    %rcx,%rsi
  804971:	89 c7                	mov    %eax,%edi
  804973:	48 b8 d0 3f 80 00 00 	movabs $0x803fd0,%rax
  80497a:	00 00 00 
  80497d:	ff d0                	callq  *%rax
  80497f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  804982:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804986:	7e 13                	jle    80499b <writebuf+0x5c>
			b->result += result;
  804988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80498c:	8b 50 08             	mov    0x8(%rax),%edx
  80498f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804992:	01 c2                	add    %eax,%edx
  804994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804998:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  80499b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80499f:	8b 40 04             	mov    0x4(%rax),%eax
  8049a2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8049a5:	74 16                	je     8049bd <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8049a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8049ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049b0:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8049b4:	89 c2                	mov    %eax,%edx
  8049b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049ba:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  8049bd:	c9                   	leaveq 
  8049be:	c3                   	retq   

00000000008049bf <putch>:

static void
putch(int ch, void *thunk)
{
  8049bf:	55                   	push   %rbp
  8049c0:	48 89 e5             	mov    %rsp,%rbp
  8049c3:	48 83 ec 20          	sub    $0x20,%rsp
  8049c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8049ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  8049ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  8049d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049da:	8b 40 04             	mov    0x4(%rax),%eax
  8049dd:	8d 48 01             	lea    0x1(%rax),%ecx
  8049e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8049e4:	89 4a 04             	mov    %ecx,0x4(%rdx)
  8049e7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8049ea:	89 d1                	mov    %edx,%ecx
  8049ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8049f0:	48 98                	cltq   
  8049f2:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  8049f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049fa:	8b 40 04             	mov    0x4(%rax),%eax
  8049fd:	3d 00 01 00 00       	cmp    $0x100,%eax
  804a02:	75 1e                	jne    804a22 <putch+0x63>
		writebuf(b);
  804a04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a08:	48 89 c7             	mov    %rax,%rdi
  804a0b:	48 b8 3f 49 80 00 00 	movabs $0x80493f,%rax
  804a12:	00 00 00 
  804a15:	ff d0                	callq  *%rax
		b->idx = 0;
  804a17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  804a22:	c9                   	leaveq 
  804a23:	c3                   	retq   

0000000000804a24 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  804a24:	55                   	push   %rbp
  804a25:	48 89 e5             	mov    %rsp,%rbp
  804a28:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  804a2f:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  804a35:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  804a3c:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  804a43:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  804a49:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  804a4f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  804a56:	00 00 00 
	b.result = 0;
  804a59:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  804a60:	00 00 00 
	b.error = 1;
  804a63:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  804a6a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  804a6d:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  804a74:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  804a7b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  804a82:	48 89 c6             	mov    %rax,%rsi
  804a85:	48 bf bf 49 80 00 00 	movabs $0x8049bf,%rdi
  804a8c:	00 00 00 
  804a8f:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  804a96:	00 00 00 
  804a99:	ff d0                	callq  *%rax
	if (b.idx > 0)
  804a9b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  804aa1:	85 c0                	test   %eax,%eax
  804aa3:	7e 16                	jle    804abb <vfprintf+0x97>
		writebuf(&b);
  804aa5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  804aac:	48 89 c7             	mov    %rax,%rdi
  804aaf:	48 b8 3f 49 80 00 00 	movabs $0x80493f,%rax
  804ab6:	00 00 00 
  804ab9:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  804abb:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804ac1:	85 c0                	test   %eax,%eax
  804ac3:	74 08                	je     804acd <vfprintf+0xa9>
  804ac5:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804acb:	eb 06                	jmp    804ad3 <vfprintf+0xaf>
  804acd:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  804ad3:	c9                   	leaveq 
  804ad4:	c3                   	retq   

0000000000804ad5 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  804ad5:	55                   	push   %rbp
  804ad6:	48 89 e5             	mov    %rsp,%rbp
  804ad9:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  804ae0:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  804ae6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804aed:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804af4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804afb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804b02:	84 c0                	test   %al,%al
  804b04:	74 20                	je     804b26 <fprintf+0x51>
  804b06:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804b0a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804b0e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804b12:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804b16:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804b1a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804b1e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804b22:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804b26:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804b2d:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  804b34:	00 00 00 
  804b37:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804b3e:	00 00 00 
  804b41:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804b45:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804b4c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804b53:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  804b5a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804b61:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  804b68:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804b6e:	48 89 ce             	mov    %rcx,%rsi
  804b71:	89 c7                	mov    %eax,%edi
  804b73:	48 b8 24 4a 80 00 00 	movabs $0x804a24,%rax
  804b7a:	00 00 00 
  804b7d:	ff d0                	callq  *%rax
  804b7f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804b85:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804b8b:	c9                   	leaveq 
  804b8c:	c3                   	retq   

0000000000804b8d <printf>:

int
printf(const char *fmt, ...)
{
  804b8d:	55                   	push   %rbp
  804b8e:	48 89 e5             	mov    %rsp,%rbp
  804b91:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  804b98:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  804b9f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804ba6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804bad:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804bb4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804bbb:	84 c0                	test   %al,%al
  804bbd:	74 20                	je     804bdf <printf+0x52>
  804bbf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804bc3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804bc7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804bcb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804bcf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804bd3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804bd7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804bdb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804bdf:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804be6:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  804bed:	00 00 00 
  804bf0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804bf7:	00 00 00 
  804bfa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804bfe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804c05:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804c0c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  804c13:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804c1a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804c21:	48 89 c6             	mov    %rax,%rsi
  804c24:	bf 01 00 00 00       	mov    $0x1,%edi
  804c29:	48 b8 24 4a 80 00 00 	movabs $0x804a24,%rax
  804c30:	00 00 00 
  804c33:	ff d0                	callq  *%rax
  804c35:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804c3b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804c41:	c9                   	leaveq 
  804c42:	c3                   	retq   

0000000000804c43 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  804c43:	55                   	push   %rbp
  804c44:	48 89 e5             	mov    %rsp,%rbp
  804c47:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  804c4e:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  804c55:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  804c5c:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  804c63:	be 00 00 00 00       	mov    $0x0,%esi
  804c68:	48 89 c7             	mov    %rax,%rdi
  804c6b:	48 b8 29 43 80 00 00 	movabs $0x804329,%rax
  804c72:	00 00 00 
  804c75:	ff d0                	callq  *%rax
  804c77:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804c7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804c7e:	79 08                	jns    804c88 <spawn+0x45>
		return r;
  804c80:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c83:	e9 0c 03 00 00       	jmpq   804f94 <spawn+0x351>
	fd = r;
  804c88:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c8b:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  804c8e:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  804c95:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  804c99:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  804ca0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ca3:	ba 00 02 00 00       	mov    $0x200,%edx
  804ca8:	48 89 ce             	mov    %rcx,%rsi
  804cab:	89 c7                	mov    %eax,%edi
  804cad:	48 b8 5b 3f 80 00 00 	movabs $0x803f5b,%rax
  804cb4:	00 00 00 
  804cb7:	ff d0                	callq  *%rax
  804cb9:	3d 00 02 00 00       	cmp    $0x200,%eax
  804cbe:	75 0d                	jne    804ccd <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  804cc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804cc4:	8b 00                	mov    (%rax),%eax
  804cc6:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  804ccb:	74 43                	je     804d10 <spawn+0xcd>
		close(fd);
  804ccd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804cd0:	89 c7                	mov    %eax,%edi
  804cd2:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  804cd9:	00 00 00 
  804cdc:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  804cde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ce2:	8b 00                	mov    (%rax),%eax
  804ce4:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  804ce9:	89 c6                	mov    %eax,%esi
  804ceb:	48 bf 50 6b 80 00 00 	movabs $0x806b50,%rdi
  804cf2:	00 00 00 
  804cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  804cfa:	48 b9 6b 15 80 00 00 	movabs $0x80156b,%rcx
  804d01:	00 00 00 
  804d04:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  804d06:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  804d0b:	e9 84 02 00 00       	jmpq   804f94 <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  804d10:	b8 07 00 00 00       	mov    $0x7,%eax
  804d15:	cd 30                	int    $0x30
  804d17:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  804d1a:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804d1d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804d20:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804d24:	79 08                	jns    804d2e <spawn+0xeb>
		return r;
  804d26:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804d29:	e9 66 02 00 00       	jmpq   804f94 <spawn+0x351>
	child = r;
  804d2e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804d31:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  804d34:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804d37:	25 ff 03 00 00       	and    $0x3ff,%eax
  804d3c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804d43:	00 00 00 
  804d46:	48 98                	cltq   
  804d48:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804d4f:	48 01 d0             	add    %rdx,%rax
  804d52:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804d59:	48 89 c6             	mov    %rax,%rsi
  804d5c:	b8 18 00 00 00       	mov    $0x18,%eax
  804d61:	48 89 d7             	mov    %rdx,%rdi
  804d64:	48 89 c1             	mov    %rax,%rcx
  804d67:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  804d6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d6e:	48 8b 40 18          	mov    0x18(%rax),%rax
  804d72:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  804d79:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  804d80:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  804d87:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  804d8e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804d91:	48 89 ce             	mov    %rcx,%rsi
  804d94:	89 c7                	mov    %eax,%edi
  804d96:	48 b8 fe 51 80 00 00 	movabs $0x8051fe,%rax
  804d9d:	00 00 00 
  804da0:	ff d0                	callq  *%rax
  804da2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804da5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804da9:	79 08                	jns    804db3 <spawn+0x170>
		return r;
  804dab:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804dae:	e9 e1 01 00 00       	jmpq   804f94 <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  804db3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804db7:	48 8b 40 20          	mov    0x20(%rax),%rax
  804dbb:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  804dc2:	48 01 d0             	add    %rdx,%rax
  804dc5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804dc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804dd0:	e9 a3 00 00 00       	jmpq   804e78 <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  804dd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804dd9:	8b 00                	mov    (%rax),%eax
  804ddb:	83 f8 01             	cmp    $0x1,%eax
  804dde:	74 05                	je     804de5 <spawn+0x1a2>
			continue;
  804de0:	e9 8a 00 00 00       	jmpq   804e6f <spawn+0x22c>
		perm = PTE_P | PTE_U;
  804de5:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  804dec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804df0:	8b 40 04             	mov    0x4(%rax),%eax
  804df3:	83 e0 02             	and    $0x2,%eax
  804df6:	85 c0                	test   %eax,%eax
  804df8:	74 04                	je     804dfe <spawn+0x1bb>
			perm |= PTE_W;
  804dfa:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804dfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e02:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804e06:	41 89 c1             	mov    %eax,%r9d
  804e09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e0d:	4c 8b 40 20          	mov    0x20(%rax),%r8
  804e11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e15:	48 8b 50 28          	mov    0x28(%rax),%rdx
  804e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e1d:	48 8b 70 10          	mov    0x10(%rax),%rsi
  804e21:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  804e24:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804e27:	8b 7d ec             	mov    -0x14(%rbp),%edi
  804e2a:	89 3c 24             	mov    %edi,(%rsp)
  804e2d:	89 c7                	mov    %eax,%edi
  804e2f:	48 b8 a7 54 80 00 00 	movabs $0x8054a7,%rax
  804e36:	00 00 00 
  804e39:	ff d0                	callq  *%rax
  804e3b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804e3e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804e42:	79 2b                	jns    804e6f <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  804e44:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804e45:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804e48:	89 c7                	mov    %eax,%edi
  804e4a:	48 b8 e9 2a 80 00 00 	movabs $0x802ae9,%rax
  804e51:	00 00 00 
  804e54:	ff d0                	callq  *%rax
	close(fd);
  804e56:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e59:	89 c7                	mov    %eax,%edi
  804e5b:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  804e62:	00 00 00 
  804e65:	ff d0                	callq  *%rax
	return r;
  804e67:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804e6a:	e9 25 01 00 00       	jmpq   804f94 <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804e6f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804e73:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  804e78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e7c:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  804e80:	0f b7 c0             	movzwl %ax,%eax
  804e83:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  804e86:	0f 8f 49 ff ff ff    	jg     804dd5 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  804e8c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e8f:	89 c7                	mov    %eax,%edi
  804e91:	48 b8 64 3c 80 00 00 	movabs $0x803c64,%rax
  804e98:	00 00 00 
  804e9b:	ff d0                	callq  *%rax
	fd = -1;
  804e9d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  804ea4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804ea7:	89 c7                	mov    %eax,%edi
  804ea9:	48 b8 93 56 80 00 00 	movabs $0x805693,%rax
  804eb0:	00 00 00 
  804eb3:	ff d0                	callq  *%rax
  804eb5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804eb8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804ebc:	79 30                	jns    804eee <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  804ebe:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804ec1:	89 c1                	mov    %eax,%ecx
  804ec3:	48 ba 6a 6b 80 00 00 	movabs $0x806b6a,%rdx
  804eca:	00 00 00 
  804ecd:	be 82 00 00 00       	mov    $0x82,%esi
  804ed2:	48 bf 80 6b 80 00 00 	movabs $0x806b80,%rdi
  804ed9:	00 00 00 
  804edc:	b8 00 00 00 00       	mov    $0x0,%eax
  804ee1:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  804ee8:	00 00 00 
  804eeb:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  804eee:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804ef5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804ef8:	48 89 d6             	mov    %rdx,%rsi
  804efb:	89 c7                	mov    %eax,%edi
  804efd:	48 b8 e9 2c 80 00 00 	movabs $0x802ce9,%rax
  804f04:	00 00 00 
  804f07:	ff d0                	callq  *%rax
  804f09:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804f0c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804f10:	79 30                	jns    804f42 <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  804f12:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804f15:	89 c1                	mov    %eax,%ecx
  804f17:	48 ba 8c 6b 80 00 00 	movabs $0x806b8c,%rdx
  804f1e:	00 00 00 
  804f21:	be 85 00 00 00       	mov    $0x85,%esi
  804f26:	48 bf 80 6b 80 00 00 	movabs $0x806b80,%rdi
  804f2d:	00 00 00 
  804f30:	b8 00 00 00 00       	mov    $0x0,%eax
  804f35:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  804f3c:	00 00 00 
  804f3f:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804f42:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804f45:	be 02 00 00 00       	mov    $0x2,%esi
  804f4a:	89 c7                	mov    %eax,%edi
  804f4c:	48 b8 9e 2c 80 00 00 	movabs $0x802c9e,%rax
  804f53:	00 00 00 
  804f56:	ff d0                	callq  *%rax
  804f58:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804f5b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804f5f:	79 30                	jns    804f91 <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  804f61:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804f64:	89 c1                	mov    %eax,%ecx
  804f66:	48 ba a6 6b 80 00 00 	movabs $0x806ba6,%rdx
  804f6d:	00 00 00 
  804f70:	be 88 00 00 00       	mov    $0x88,%esi
  804f75:	48 bf 80 6b 80 00 00 	movabs $0x806b80,%rdi
  804f7c:	00 00 00 
  804f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  804f84:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  804f8b:	00 00 00 
  804f8e:	41 ff d0             	callq  *%r8

	return child;
  804f91:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  804f94:	c9                   	leaveq 
  804f95:	c3                   	retq   

0000000000804f96 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  804f96:	55                   	push   %rbp
  804f97:	48 89 e5             	mov    %rsp,%rbp
  804f9a:	41 55                	push   %r13
  804f9c:	41 54                	push   %r12
  804f9e:	53                   	push   %rbx
  804f9f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804fa6:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  804fad:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  804fb4:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  804fbb:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  804fc2:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  804fc9:	84 c0                	test   %al,%al
  804fcb:	74 26                	je     804ff3 <spawnl+0x5d>
  804fcd:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  804fd4:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  804fdb:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  804fdf:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  804fe3:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  804fe7:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  804feb:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  804fef:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  804ff3:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804ffa:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  805001:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  805004:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80500b:	00 00 00 
  80500e:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  805015:	00 00 00 
  805018:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80501c:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  805023:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80502a:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  805031:	eb 07                	jmp    80503a <spawnl+0xa4>
		argc++;
  805033:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80503a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  805040:	83 f8 30             	cmp    $0x30,%eax
  805043:	73 23                	jae    805068 <spawnl+0xd2>
  805045:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80504c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  805052:	89 c0                	mov    %eax,%eax
  805054:	48 01 d0             	add    %rdx,%rax
  805057:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80505d:	83 c2 08             	add    $0x8,%edx
  805060:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  805066:	eb 15                	jmp    80507d <spawnl+0xe7>
  805068:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80506f:	48 89 d0             	mov    %rdx,%rax
  805072:	48 83 c2 08          	add    $0x8,%rdx
  805076:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80507d:	48 8b 00             	mov    (%rax),%rax
  805080:	48 85 c0             	test   %rax,%rax
  805083:	75 ae                	jne    805033 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  805085:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80508b:	83 c0 02             	add    $0x2,%eax
  80508e:	48 89 e2             	mov    %rsp,%rdx
  805091:	48 89 d3             	mov    %rdx,%rbx
  805094:	48 63 d0             	movslq %eax,%rdx
  805097:	48 83 ea 01          	sub    $0x1,%rdx
  80509b:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8050a2:	48 63 d0             	movslq %eax,%rdx
  8050a5:	49 89 d4             	mov    %rdx,%r12
  8050a8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8050ae:	48 63 d0             	movslq %eax,%rdx
  8050b1:	49 89 d2             	mov    %rdx,%r10
  8050b4:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8050ba:	48 98                	cltq   
  8050bc:	48 c1 e0 03          	shl    $0x3,%rax
  8050c0:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8050c4:	b8 10 00 00 00       	mov    $0x10,%eax
  8050c9:	48 83 e8 01          	sub    $0x1,%rax
  8050cd:	48 01 d0             	add    %rdx,%rax
  8050d0:	bf 10 00 00 00       	mov    $0x10,%edi
  8050d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8050da:	48 f7 f7             	div    %rdi
  8050dd:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8050e1:	48 29 c4             	sub    %rax,%rsp
  8050e4:	48 89 e0             	mov    %rsp,%rax
  8050e7:	48 83 c0 07          	add    $0x7,%rax
  8050eb:	48 c1 e8 03          	shr    $0x3,%rax
  8050ef:	48 c1 e0 03          	shl    $0x3,%rax
  8050f3:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8050fa:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  805101:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  805108:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80510b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  805111:	8d 50 01             	lea    0x1(%rax),%edx
  805114:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80511b:	48 63 d2             	movslq %edx,%rdx
  80511e:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  805125:	00 

	va_start(vl, arg0);
  805126:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80512d:	00 00 00 
  805130:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  805137:	00 00 00 
  80513a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80513e:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  805145:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80514c:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  805153:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80515a:	00 00 00 
  80515d:	eb 63                	jmp    8051c2 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  80515f:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  805165:	8d 70 01             	lea    0x1(%rax),%esi
  805168:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80516e:	83 f8 30             	cmp    $0x30,%eax
  805171:	73 23                	jae    805196 <spawnl+0x200>
  805173:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80517a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  805180:	89 c0                	mov    %eax,%eax
  805182:	48 01 d0             	add    %rdx,%rax
  805185:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80518b:	83 c2 08             	add    $0x8,%edx
  80518e:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  805194:	eb 15                	jmp    8051ab <spawnl+0x215>
  805196:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80519d:	48 89 d0             	mov    %rdx,%rax
  8051a0:	48 83 c2 08          	add    $0x8,%rdx
  8051a4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8051ab:	48 8b 08             	mov    (%rax),%rcx
  8051ae:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8051b5:	89 f2                	mov    %esi,%edx
  8051b7:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8051bb:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8051c2:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8051c8:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8051ce:	77 8f                	ja     80515f <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8051d0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8051d7:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8051de:	48 89 d6             	mov    %rdx,%rsi
  8051e1:	48 89 c7             	mov    %rax,%rdi
  8051e4:	48 b8 43 4c 80 00 00 	movabs $0x804c43,%rax
  8051eb:	00 00 00 
  8051ee:	ff d0                	callq  *%rax
  8051f0:	48 89 dc             	mov    %rbx,%rsp
}
  8051f3:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8051f7:	5b                   	pop    %rbx
  8051f8:	41 5c                	pop    %r12
  8051fa:	41 5d                	pop    %r13
  8051fc:	5d                   	pop    %rbp
  8051fd:	c3                   	retq   

00000000008051fe <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8051fe:	55                   	push   %rbp
  8051ff:	48 89 e5             	mov    %rsp,%rbp
  805202:	48 83 ec 50          	sub    $0x50,%rsp
  805206:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805209:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80520d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  805211:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805218:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  805219:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  805220:	eb 33                	jmp    805255 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  805222:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805225:	48 98                	cltq   
  805227:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80522e:	00 
  80522f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805233:	48 01 d0             	add    %rdx,%rax
  805236:	48 8b 00             	mov    (%rax),%rax
  805239:	48 89 c7             	mov    %rax,%rdi
  80523c:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  805243:	00 00 00 
  805246:	ff d0                	callq  *%rax
  805248:	83 c0 01             	add    $0x1,%eax
  80524b:	48 98                	cltq   
  80524d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  805251:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  805255:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805258:	48 98                	cltq   
  80525a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805261:	00 
  805262:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805266:	48 01 d0             	add    %rdx,%rax
  805269:	48 8b 00             	mov    (%rax),%rax
  80526c:	48 85 c0             	test   %rax,%rax
  80526f:	75 b1                	jne    805222 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  805271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805275:	48 f7 d8             	neg    %rax
  805278:	48 05 00 10 40 00    	add    $0x401000,%rax
  80527e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  805282:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805286:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80528a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80528e:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  805292:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805295:	83 c2 01             	add    $0x1,%edx
  805298:	c1 e2 03             	shl    $0x3,%edx
  80529b:	48 63 d2             	movslq %edx,%rdx
  80529e:	48 f7 da             	neg    %rdx
  8052a1:	48 01 d0             	add    %rdx,%rax
  8052a4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8052a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8052ac:	48 83 e8 10          	sub    $0x10,%rax
  8052b0:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8052b6:	77 0a                	ja     8052c2 <init_stack+0xc4>
		return -E_NO_MEM;
  8052b8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8052bd:	e9 e3 01 00 00       	jmpq   8054a5 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8052c2:	ba 07 00 00 00       	mov    $0x7,%edx
  8052c7:	be 00 00 40 00       	mov    $0x400000,%esi
  8052cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8052d1:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  8052d8:	00 00 00 
  8052db:	ff d0                	callq  *%rax
  8052dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8052e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8052e4:	79 08                	jns    8052ee <init_stack+0xf0>
		return r;
  8052e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8052e9:	e9 b7 01 00 00       	jmpq   8054a5 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8052ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8052f5:	e9 8a 00 00 00       	jmpq   805384 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8052fa:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8052fd:	48 98                	cltq   
  8052ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805306:	00 
  805307:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80530b:	48 01 c2             	add    %rax,%rdx
  80530e:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805313:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805317:	48 01 c8             	add    %rcx,%rax
  80531a:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805320:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  805323:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805326:	48 98                	cltq   
  805328:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80532f:	00 
  805330:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805334:	48 01 d0             	add    %rdx,%rax
  805337:	48 8b 10             	mov    (%rax),%rdx
  80533a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80533e:	48 89 d6             	mov    %rdx,%rsi
  805341:	48 89 c7             	mov    %rax,%rdi
  805344:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  80534b:	00 00 00 
  80534e:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  805350:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805353:	48 98                	cltq   
  805355:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80535c:	00 
  80535d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805361:	48 01 d0             	add    %rdx,%rax
  805364:	48 8b 00             	mov    (%rax),%rax
  805367:	48 89 c7             	mov    %rax,%rdi
  80536a:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  805371:	00 00 00 
  805374:	ff d0                	callq  *%rax
  805376:	48 98                	cltq   
  805378:	48 83 c0 01          	add    $0x1,%rax
  80537c:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  805380:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  805384:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805387:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80538a:	0f 8c 6a ff ff ff    	jl     8052fa <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  805390:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805393:	48 98                	cltq   
  805395:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80539c:	00 
  80539d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8053a1:	48 01 d0             	add    %rdx,%rax
  8053a4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8053ab:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8053b2:	00 
  8053b3:	74 35                	je     8053ea <init_stack+0x1ec>
  8053b5:	48 b9 c0 6b 80 00 00 	movabs $0x806bc0,%rcx
  8053bc:	00 00 00 
  8053bf:	48 ba e6 6b 80 00 00 	movabs $0x806be6,%rdx
  8053c6:	00 00 00 
  8053c9:	be f1 00 00 00       	mov    $0xf1,%esi
  8053ce:	48 bf 80 6b 80 00 00 	movabs $0x806b80,%rdi
  8053d5:	00 00 00 
  8053d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8053dd:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  8053e4:	00 00 00 
  8053e7:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8053ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8053ee:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8053f2:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8053f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8053fb:	48 01 c8             	add    %rcx,%rax
  8053fe:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805404:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  805407:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80540b:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80540f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805412:	48 98                	cltq   
  805414:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  805417:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80541c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805420:	48 01 d0             	add    %rdx,%rax
  805423:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805429:	48 89 c2             	mov    %rax,%rdx
  80542c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  805430:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  805433:	8b 45 cc             	mov    -0x34(%rbp),%eax
  805436:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80543c:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805441:	89 c2                	mov    %eax,%edx
  805443:	be 00 00 40 00       	mov    $0x400000,%esi
  805448:	bf 00 00 00 00       	mov    $0x0,%edi
  80544d:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  805454:	00 00 00 
  805457:	ff d0                	callq  *%rax
  805459:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80545c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805460:	79 02                	jns    805464 <init_stack+0x266>
		goto error;
  805462:	eb 28                	jmp    80548c <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  805464:	be 00 00 40 00       	mov    $0x400000,%esi
  805469:	bf 00 00 00 00       	mov    $0x0,%edi
  80546e:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  805475:	00 00 00 
  805478:	ff d0                	callq  *%rax
  80547a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80547d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805481:	79 02                	jns    805485 <init_stack+0x287>
		goto error;
  805483:	eb 07                	jmp    80548c <init_stack+0x28e>

	return 0;
  805485:	b8 00 00 00 00       	mov    $0x0,%eax
  80548a:	eb 19                	jmp    8054a5 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  80548c:	be 00 00 40 00       	mov    $0x400000,%esi
  805491:	bf 00 00 00 00       	mov    $0x0,%edi
  805496:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  80549d:	00 00 00 
  8054a0:	ff d0                	callq  *%rax
	return r;
  8054a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8054a5:	c9                   	leaveq 
  8054a6:	c3                   	retq   

00000000008054a7 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8054a7:	55                   	push   %rbp
  8054a8:	48 89 e5             	mov    %rsp,%rbp
  8054ab:	48 83 ec 50          	sub    $0x50,%rsp
  8054af:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8054b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8054b6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8054ba:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8054bd:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8054c1:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8054c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054c9:	25 ff 0f 00 00       	and    $0xfff,%eax
  8054ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054d5:	74 21                	je     8054f8 <map_segment+0x51>
		va -= i;
  8054d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054da:	48 98                	cltq   
  8054dc:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8054e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054e3:	48 98                	cltq   
  8054e5:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8054e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054ec:	48 98                	cltq   
  8054ee:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8054f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054f5:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8054f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8054ff:	e9 79 01 00 00       	jmpq   80567d <map_segment+0x1d6>
		if (i >= filesz) {
  805504:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805507:	48 98                	cltq   
  805509:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80550d:	72 3c                	jb     80554b <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80550f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805512:	48 63 d0             	movslq %eax,%rdx
  805515:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805519:	48 01 d0             	add    %rdx,%rax
  80551c:	48 89 c1             	mov    %rax,%rcx
  80551f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805522:	8b 55 10             	mov    0x10(%rbp),%edx
  805525:	48 89 ce             	mov    %rcx,%rsi
  805528:	89 c7                	mov    %eax,%edi
  80552a:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  805531:	00 00 00 
  805534:	ff d0                	callq  *%rax
  805536:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805539:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80553d:	0f 89 33 01 00 00    	jns    805676 <map_segment+0x1cf>
				return r;
  805543:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805546:	e9 46 01 00 00       	jmpq   805691 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80554b:	ba 07 00 00 00       	mov    $0x7,%edx
  805550:	be 00 00 40 00       	mov    $0x400000,%esi
  805555:	bf 00 00 00 00       	mov    $0x0,%edi
  80555a:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  805561:	00 00 00 
  805564:	ff d0                	callq  *%rax
  805566:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805569:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80556d:	79 08                	jns    805577 <map_segment+0xd0>
				return r;
  80556f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805572:	e9 1a 01 00 00       	jmpq   805691 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  805577:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80557a:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80557d:	01 c2                	add    %eax,%edx
  80557f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  805582:	89 d6                	mov    %edx,%esi
  805584:	89 c7                	mov    %eax,%edi
  805586:	48 b8 71 40 80 00 00 	movabs $0x804071,%rax
  80558d:	00 00 00 
  805590:	ff d0                	callq  *%rax
  805592:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805595:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805599:	79 08                	jns    8055a3 <map_segment+0xfc>
				return r;
  80559b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80559e:	e9 ee 00 00 00       	jmpq   805691 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8055a3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8055aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055ad:	48 98                	cltq   
  8055af:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8055b3:	48 29 c2             	sub    %rax,%rdx
  8055b6:	48 89 d0             	mov    %rdx,%rax
  8055b9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8055bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8055c0:	48 63 d0             	movslq %eax,%rdx
  8055c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055c7:	48 39 c2             	cmp    %rax,%rdx
  8055ca:	48 0f 47 d0          	cmova  %rax,%rdx
  8055ce:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8055d1:	be 00 00 40 00       	mov    $0x400000,%esi
  8055d6:	89 c7                	mov    %eax,%edi
  8055d8:	48 b8 5b 3f 80 00 00 	movabs $0x803f5b,%rax
  8055df:	00 00 00 
  8055e2:	ff d0                	callq  *%rax
  8055e4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8055e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8055eb:	79 08                	jns    8055f5 <map_segment+0x14e>
				return r;
  8055ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8055f0:	e9 9c 00 00 00       	jmpq   805691 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8055f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055f8:	48 63 d0             	movslq %eax,%rdx
  8055fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8055ff:	48 01 d0             	add    %rdx,%rax
  805602:	48 89 c2             	mov    %rax,%rdx
  805605:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805608:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80560c:	48 89 d1             	mov    %rdx,%rcx
  80560f:	89 c2                	mov    %eax,%edx
  805611:	be 00 00 40 00       	mov    $0x400000,%esi
  805616:	bf 00 00 00 00       	mov    $0x0,%edi
  80561b:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  805622:	00 00 00 
  805625:	ff d0                	callq  *%rax
  805627:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80562a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80562e:	79 30                	jns    805660 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  805630:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805633:	89 c1                	mov    %eax,%ecx
  805635:	48 ba fb 6b 80 00 00 	movabs $0x806bfb,%rdx
  80563c:	00 00 00 
  80563f:	be 24 01 00 00       	mov    $0x124,%esi
  805644:	48 bf 80 6b 80 00 00 	movabs $0x806b80,%rdi
  80564b:	00 00 00 
  80564e:	b8 00 00 00 00       	mov    $0x0,%eax
  805653:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  80565a:	00 00 00 
  80565d:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  805660:	be 00 00 40 00       	mov    $0x400000,%esi
  805665:	bf 00 00 00 00       	mov    $0x0,%edi
  80566a:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  805671:	00 00 00 
  805674:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805676:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80567d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805680:	48 98                	cltq   
  805682:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805686:	0f 82 78 fe ff ff    	jb     805504 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  80568c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805691:	c9                   	leaveq 
  805692:	c3                   	retq   

0000000000805693 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  805693:	55                   	push   %rbp
  805694:	48 89 e5             	mov    %rsp,%rbp
  805697:	48 83 ec 20          	sub    $0x20,%rsp
  80569b:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  80569e:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8056a5:	00 
  8056a6:	e9 c9 00 00 00       	jmpq   805774 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  8056ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056af:	48 c1 e8 27          	shr    $0x27,%rax
  8056b3:	48 89 c2             	mov    %rax,%rdx
  8056b6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8056bd:	01 00 00 
  8056c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8056c4:	48 85 c0             	test   %rax,%rax
  8056c7:	74 3c                	je     805705 <copy_shared_pages+0x72>
  8056c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056cd:	48 c1 e8 1e          	shr    $0x1e,%rax
  8056d1:	48 89 c2             	mov    %rax,%rdx
  8056d4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8056db:	01 00 00 
  8056de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8056e2:	48 85 c0             	test   %rax,%rax
  8056e5:	74 1e                	je     805705 <copy_shared_pages+0x72>
  8056e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056eb:	48 c1 e8 15          	shr    $0x15,%rax
  8056ef:	48 89 c2             	mov    %rax,%rdx
  8056f2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8056f9:	01 00 00 
  8056fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805700:	48 85 c0             	test   %rax,%rax
  805703:	75 02                	jne    805707 <copy_shared_pages+0x74>
                continue;
  805705:	eb 65                	jmp    80576c <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  805707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80570b:	48 c1 e8 0c          	shr    $0xc,%rax
  80570f:	48 89 c2             	mov    %rax,%rdx
  805712:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805719:	01 00 00 
  80571c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805720:	25 00 04 00 00       	and    $0x400,%eax
  805725:	48 85 c0             	test   %rax,%rax
  805728:	74 42                	je     80576c <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  80572a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80572e:	48 c1 e8 0c          	shr    $0xc,%rax
  805732:	48 89 c2             	mov    %rax,%rdx
  805735:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80573c:	01 00 00 
  80573f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805743:	25 07 0e 00 00       	and    $0xe07,%eax
  805748:	89 c6                	mov    %eax,%esi
  80574a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80574e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805752:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805755:	41 89 f0             	mov    %esi,%r8d
  805758:	48 89 c6             	mov    %rax,%rsi
  80575b:	bf 00 00 00 00       	mov    $0x0,%edi
  805760:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  805767:	00 00 00 
  80576a:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  80576c:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  805773:	00 
  805774:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  80577b:	00 00 00 
  80577e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  805782:	0f 86 23 ff ff ff    	jbe    8056ab <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  805788:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  80578d:	c9                   	leaveq 
  80578e:	c3                   	retq   

000000000080578f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80578f:	55                   	push   %rbp
  805790:	48 89 e5             	mov    %rsp,%rbp
  805793:	53                   	push   %rbx
  805794:	48 83 ec 38          	sub    $0x38,%rsp
  805798:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80579c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8057a0:	48 89 c7             	mov    %rax,%rdi
  8057a3:	48 b8 bc 39 80 00 00 	movabs $0x8039bc,%rax
  8057aa:	00 00 00 
  8057ad:	ff d0                	callq  *%rax
  8057af:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8057b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8057b6:	0f 88 bf 01 00 00    	js     80597b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8057bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8057c0:	ba 07 04 00 00       	mov    $0x407,%edx
  8057c5:	48 89 c6             	mov    %rax,%rsi
  8057c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8057cd:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  8057d4:	00 00 00 
  8057d7:	ff d0                	callq  *%rax
  8057d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8057dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8057e0:	0f 88 95 01 00 00    	js     80597b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8057e6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8057ea:	48 89 c7             	mov    %rax,%rdi
  8057ed:	48 b8 bc 39 80 00 00 	movabs $0x8039bc,%rax
  8057f4:	00 00 00 
  8057f7:	ff d0                	callq  *%rax
  8057f9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8057fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805800:	0f 88 5d 01 00 00    	js     805963 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805806:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80580a:	ba 07 04 00 00       	mov    $0x407,%edx
  80580f:	48 89 c6             	mov    %rax,%rsi
  805812:	bf 00 00 00 00       	mov    $0x0,%edi
  805817:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  80581e:	00 00 00 
  805821:	ff d0                	callq  *%rax
  805823:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805826:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80582a:	0f 88 33 01 00 00    	js     805963 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805834:	48 89 c7             	mov    %rax,%rdi
  805837:	48 b8 91 39 80 00 00 	movabs $0x803991,%rax
  80583e:	00 00 00 
  805841:	ff d0                	callq  *%rax
  805843:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805847:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80584b:	ba 07 04 00 00       	mov    $0x407,%edx
  805850:	48 89 c6             	mov    %rax,%rsi
  805853:	bf 00 00 00 00       	mov    $0x0,%edi
  805858:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  80585f:	00 00 00 
  805862:	ff d0                	callq  *%rax
  805864:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805867:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80586b:	79 05                	jns    805872 <pipe+0xe3>
		goto err2;
  80586d:	e9 d9 00 00 00       	jmpq   80594b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805872:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805876:	48 89 c7             	mov    %rax,%rdi
  805879:	48 b8 91 39 80 00 00 	movabs $0x803991,%rax
  805880:	00 00 00 
  805883:	ff d0                	callq  *%rax
  805885:	48 89 c2             	mov    %rax,%rdx
  805888:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80588c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  805892:	48 89 d1             	mov    %rdx,%rcx
  805895:	ba 00 00 00 00       	mov    $0x0,%edx
  80589a:	48 89 c6             	mov    %rax,%rsi
  80589d:	bf 00 00 00 00       	mov    $0x0,%edi
  8058a2:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  8058a9:	00 00 00 
  8058ac:	ff d0                	callq  *%rax
  8058ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8058b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8058b5:	79 1b                	jns    8058d2 <pipe+0x143>
		goto err3;
  8058b7:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8058b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8058bc:	48 89 c6             	mov    %rax,%rsi
  8058bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8058c4:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  8058cb:	00 00 00 
  8058ce:	ff d0                	callq  *%rax
  8058d0:	eb 79                	jmp    80594b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8058d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8058d6:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  8058dd:	00 00 00 
  8058e0:	8b 12                	mov    (%rdx),%edx
  8058e2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8058e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8058e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8058ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8058f3:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  8058fa:	00 00 00 
  8058fd:	8b 12                	mov    (%rdx),%edx
  8058ff:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  805901:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805905:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80590c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805910:	48 89 c7             	mov    %rax,%rdi
  805913:	48 b8 6e 39 80 00 00 	movabs $0x80396e,%rax
  80591a:	00 00 00 
  80591d:	ff d0                	callq  *%rax
  80591f:	89 c2                	mov    %eax,%edx
  805921:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805925:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  805927:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80592b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80592f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805933:	48 89 c7             	mov    %rax,%rdi
  805936:	48 b8 6e 39 80 00 00 	movabs $0x80396e,%rax
  80593d:	00 00 00 
  805940:	ff d0                	callq  *%rax
  805942:	89 03                	mov    %eax,(%rbx)
	return 0;
  805944:	b8 00 00 00 00       	mov    $0x0,%eax
  805949:	eb 33                	jmp    80597e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80594b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80594f:	48 89 c6             	mov    %rax,%rsi
  805952:	bf 00 00 00 00       	mov    $0x0,%edi
  805957:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  80595e:	00 00 00 
  805961:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  805963:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805967:	48 89 c6             	mov    %rax,%rsi
  80596a:	bf 00 00 00 00       	mov    $0x0,%edi
  80596f:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  805976:	00 00 00 
  805979:	ff d0                	callq  *%rax
err:
	return r;
  80597b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80597e:	48 83 c4 38          	add    $0x38,%rsp
  805982:	5b                   	pop    %rbx
  805983:	5d                   	pop    %rbp
  805984:	c3                   	retq   

0000000000805985 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  805985:	55                   	push   %rbp
  805986:	48 89 e5             	mov    %rsp,%rbp
  805989:	53                   	push   %rbx
  80598a:	48 83 ec 28          	sub    $0x28,%rsp
  80598e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805992:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  805996:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80599d:	00 00 00 
  8059a0:	48 8b 00             	mov    (%rax),%rax
  8059a3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8059a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8059ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8059b0:	48 89 c7             	mov    %rax,%rdi
  8059b3:	48 b8 25 61 80 00 00 	movabs $0x806125,%rax
  8059ba:	00 00 00 
  8059bd:	ff d0                	callq  *%rax
  8059bf:	89 c3                	mov    %eax,%ebx
  8059c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8059c5:	48 89 c7             	mov    %rax,%rdi
  8059c8:	48 b8 25 61 80 00 00 	movabs $0x806125,%rax
  8059cf:	00 00 00 
  8059d2:	ff d0                	callq  *%rax
  8059d4:	39 c3                	cmp    %eax,%ebx
  8059d6:	0f 94 c0             	sete   %al
  8059d9:	0f b6 c0             	movzbl %al,%eax
  8059dc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8059df:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8059e6:	00 00 00 
  8059e9:	48 8b 00             	mov    (%rax),%rax
  8059ec:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8059f2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8059f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8059f8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8059fb:	75 05                	jne    805a02 <_pipeisclosed+0x7d>
			return ret;
  8059fd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  805a00:	eb 4f                	jmp    805a51 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  805a02:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805a05:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805a08:	74 42                	je     805a4c <_pipeisclosed+0xc7>
  805a0a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  805a0e:	75 3c                	jne    805a4c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  805a10:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805a17:	00 00 00 
  805a1a:	48 8b 00             	mov    (%rax),%rax
  805a1d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  805a23:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805a26:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805a29:	89 c6                	mov    %eax,%esi
  805a2b:	48 bf 22 6c 80 00 00 	movabs $0x806c22,%rdi
  805a32:	00 00 00 
  805a35:	b8 00 00 00 00       	mov    $0x0,%eax
  805a3a:	49 b8 6b 15 80 00 00 	movabs $0x80156b,%r8
  805a41:	00 00 00 
  805a44:	41 ff d0             	callq  *%r8
	}
  805a47:	e9 4a ff ff ff       	jmpq   805996 <_pipeisclosed+0x11>
  805a4c:	e9 45 ff ff ff       	jmpq   805996 <_pipeisclosed+0x11>
}
  805a51:	48 83 c4 28          	add    $0x28,%rsp
  805a55:	5b                   	pop    %rbx
  805a56:	5d                   	pop    %rbp
  805a57:	c3                   	retq   

0000000000805a58 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  805a58:	55                   	push   %rbp
  805a59:	48 89 e5             	mov    %rsp,%rbp
  805a5c:	48 83 ec 30          	sub    $0x30,%rsp
  805a60:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805a63:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805a67:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805a6a:	48 89 d6             	mov    %rdx,%rsi
  805a6d:	89 c7                	mov    %eax,%edi
  805a6f:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  805a76:	00 00 00 
  805a79:	ff d0                	callq  *%rax
  805a7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a82:	79 05                	jns    805a89 <pipeisclosed+0x31>
		return r;
  805a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a87:	eb 31                	jmp    805aba <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  805a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a8d:	48 89 c7             	mov    %rax,%rdi
  805a90:	48 b8 91 39 80 00 00 	movabs $0x803991,%rax
  805a97:	00 00 00 
  805a9a:	ff d0                	callq  *%rax
  805a9c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  805aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805aa4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805aa8:	48 89 d6             	mov    %rdx,%rsi
  805aab:	48 89 c7             	mov    %rax,%rdi
  805aae:	48 b8 85 59 80 00 00 	movabs $0x805985,%rax
  805ab5:	00 00 00 
  805ab8:	ff d0                	callq  *%rax
}
  805aba:	c9                   	leaveq 
  805abb:	c3                   	retq   

0000000000805abc <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  805abc:	55                   	push   %rbp
  805abd:	48 89 e5             	mov    %rsp,%rbp
  805ac0:	48 83 ec 40          	sub    $0x40,%rsp
  805ac4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805ac8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805acc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  805ad0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805ad4:	48 89 c7             	mov    %rax,%rdi
  805ad7:	48 b8 91 39 80 00 00 	movabs $0x803991,%rax
  805ade:	00 00 00 
  805ae1:	ff d0                	callq  *%rax
  805ae3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805ae7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805aeb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805aef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805af6:	00 
  805af7:	e9 92 00 00 00       	jmpq   805b8e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  805afc:	eb 41                	jmp    805b3f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  805afe:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  805b03:	74 09                	je     805b0e <devpipe_read+0x52>
				return i;
  805b05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b09:	e9 92 00 00 00       	jmpq   805ba0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  805b0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805b12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805b16:	48 89 d6             	mov    %rdx,%rsi
  805b19:	48 89 c7             	mov    %rax,%rdi
  805b1c:	48 b8 85 59 80 00 00 	movabs $0x805985,%rax
  805b23:	00 00 00 
  805b26:	ff d0                	callq  *%rax
  805b28:	85 c0                	test   %eax,%eax
  805b2a:	74 07                	je     805b33 <devpipe_read+0x77>
				return 0;
  805b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  805b31:	eb 6d                	jmp    805ba0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  805b33:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  805b3a:	00 00 00 
  805b3d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  805b3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b43:	8b 10                	mov    (%rax),%edx
  805b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b49:	8b 40 04             	mov    0x4(%rax),%eax
  805b4c:	39 c2                	cmp    %eax,%edx
  805b4e:	74 ae                	je     805afe <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  805b50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805b58:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  805b5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b60:	8b 00                	mov    (%rax),%eax
  805b62:	99                   	cltd   
  805b63:	c1 ea 1b             	shr    $0x1b,%edx
  805b66:	01 d0                	add    %edx,%eax
  805b68:	83 e0 1f             	and    $0x1f,%eax
  805b6b:	29 d0                	sub    %edx,%eax
  805b6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805b71:	48 98                	cltq   
  805b73:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  805b78:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  805b7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b7e:	8b 00                	mov    (%rax),%eax
  805b80:	8d 50 01             	lea    0x1(%rax),%edx
  805b83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b87:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805b89:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805b8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b92:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805b96:	0f 82 60 ff ff ff    	jb     805afc <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  805b9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805ba0:	c9                   	leaveq 
  805ba1:	c3                   	retq   

0000000000805ba2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  805ba2:	55                   	push   %rbp
  805ba3:	48 89 e5             	mov    %rsp,%rbp
  805ba6:	48 83 ec 40          	sub    $0x40,%rsp
  805baa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805bae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805bb2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  805bb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805bba:	48 89 c7             	mov    %rax,%rdi
  805bbd:	48 b8 91 39 80 00 00 	movabs $0x803991,%rax
  805bc4:	00 00 00 
  805bc7:	ff d0                	callq  *%rax
  805bc9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805bcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805bd1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805bd5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805bdc:	00 
  805bdd:	e9 8e 00 00 00       	jmpq   805c70 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  805be2:	eb 31                	jmp    805c15 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  805be4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805be8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805bec:	48 89 d6             	mov    %rdx,%rsi
  805bef:	48 89 c7             	mov    %rax,%rdi
  805bf2:	48 b8 85 59 80 00 00 	movabs $0x805985,%rax
  805bf9:	00 00 00 
  805bfc:	ff d0                	callq  *%rax
  805bfe:	85 c0                	test   %eax,%eax
  805c00:	74 07                	je     805c09 <devpipe_write+0x67>
				return 0;
  805c02:	b8 00 00 00 00       	mov    $0x0,%eax
  805c07:	eb 79                	jmp    805c82 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  805c09:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  805c10:	00 00 00 
  805c13:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  805c15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805c19:	8b 40 04             	mov    0x4(%rax),%eax
  805c1c:	48 63 d0             	movslq %eax,%rdx
  805c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805c23:	8b 00                	mov    (%rax),%eax
  805c25:	48 98                	cltq   
  805c27:	48 83 c0 20          	add    $0x20,%rax
  805c2b:	48 39 c2             	cmp    %rax,%rdx
  805c2e:	73 b4                	jae    805be4 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  805c30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805c34:	8b 40 04             	mov    0x4(%rax),%eax
  805c37:	99                   	cltd   
  805c38:	c1 ea 1b             	shr    $0x1b,%edx
  805c3b:	01 d0                	add    %edx,%eax
  805c3d:	83 e0 1f             	and    $0x1f,%eax
  805c40:	29 d0                	sub    %edx,%eax
  805c42:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805c46:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805c4a:	48 01 ca             	add    %rcx,%rdx
  805c4d:	0f b6 0a             	movzbl (%rdx),%ecx
  805c50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805c54:	48 98                	cltq   
  805c56:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  805c5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805c5e:	8b 40 04             	mov    0x4(%rax),%eax
  805c61:	8d 50 01             	lea    0x1(%rax),%edx
  805c64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805c68:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805c6b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805c70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805c74:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805c78:	0f 82 64 ff ff ff    	jb     805be2 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  805c7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805c82:	c9                   	leaveq 
  805c83:	c3                   	retq   

0000000000805c84 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  805c84:	55                   	push   %rbp
  805c85:	48 89 e5             	mov    %rsp,%rbp
  805c88:	48 83 ec 20          	sub    $0x20,%rsp
  805c8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805c90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  805c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c98:	48 89 c7             	mov    %rax,%rdi
  805c9b:	48 b8 91 39 80 00 00 	movabs $0x803991,%rax
  805ca2:	00 00 00 
  805ca5:	ff d0                	callq  *%rax
  805ca7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  805cab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805caf:	48 be 35 6c 80 00 00 	movabs $0x806c35,%rsi
  805cb6:	00 00 00 
  805cb9:	48 89 c7             	mov    %rax,%rdi
  805cbc:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  805cc3:	00 00 00 
  805cc6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  805cc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ccc:	8b 50 04             	mov    0x4(%rax),%edx
  805ccf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805cd3:	8b 00                	mov    (%rax),%eax
  805cd5:	29 c2                	sub    %eax,%edx
  805cd7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805cdb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  805ce1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805ce5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805cec:	00 00 00 
	stat->st_dev = &devpipe;
  805cef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805cf3:	48 b9 20 81 80 00 00 	movabs $0x808120,%rcx
  805cfa:	00 00 00 
  805cfd:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  805d04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805d09:	c9                   	leaveq 
  805d0a:	c3                   	retq   

0000000000805d0b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  805d0b:	55                   	push   %rbp
  805d0c:	48 89 e5             	mov    %rsp,%rbp
  805d0f:	48 83 ec 10          	sub    $0x10,%rsp
  805d13:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  805d17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805d1b:	48 89 c6             	mov    %rax,%rsi
  805d1e:	bf 00 00 00 00       	mov    $0x0,%edi
  805d23:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  805d2a:	00 00 00 
  805d2d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  805d2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805d33:	48 89 c7             	mov    %rax,%rdi
  805d36:	48 b8 91 39 80 00 00 	movabs $0x803991,%rax
  805d3d:	00 00 00 
  805d40:	ff d0                	callq  *%rax
  805d42:	48 89 c6             	mov    %rax,%rsi
  805d45:	bf 00 00 00 00       	mov    $0x0,%edi
  805d4a:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  805d51:	00 00 00 
  805d54:	ff d0                	callq  *%rax
}
  805d56:	c9                   	leaveq 
  805d57:	c3                   	retq   

0000000000805d58 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  805d58:	55                   	push   %rbp
  805d59:	48 89 e5             	mov    %rsp,%rbp
  805d5c:	48 83 ec 20          	sub    $0x20,%rsp
  805d60:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  805d63:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805d67:	75 35                	jne    805d9e <wait+0x46>
  805d69:	48 b9 3c 6c 80 00 00 	movabs $0x806c3c,%rcx
  805d70:	00 00 00 
  805d73:	48 ba 47 6c 80 00 00 	movabs $0x806c47,%rdx
  805d7a:	00 00 00 
  805d7d:	be 09 00 00 00       	mov    $0x9,%esi
  805d82:	48 bf 5c 6c 80 00 00 	movabs $0x806c5c,%rdi
  805d89:	00 00 00 
  805d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  805d91:	49 b8 32 13 80 00 00 	movabs $0x801332,%r8
  805d98:	00 00 00 
  805d9b:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  805d9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805da1:	25 ff 03 00 00       	and    $0x3ff,%eax
  805da6:	48 98                	cltq   
  805da8:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  805daf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805db6:	00 00 00 
  805db9:	48 01 d0             	add    %rdx,%rax
  805dbc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  805dc0:	eb 0c                	jmp    805dce <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  805dc2:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  805dc9:	00 00 00 
  805dcc:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  805dce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805dd2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805dd8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805ddb:	75 0e                	jne    805deb <wait+0x93>
  805ddd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805de1:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805de7:	85 c0                	test   %eax,%eax
  805de9:	75 d7                	jne    805dc2 <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  805deb:	c9                   	leaveq 
  805dec:	c3                   	retq   

0000000000805ded <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805ded:	55                   	push   %rbp
  805dee:	48 89 e5             	mov    %rsp,%rbp
  805df1:	48 83 ec 10          	sub    $0x10,%rsp
  805df5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  805df9:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  805e00:	00 00 00 
  805e03:	48 8b 00             	mov    (%rax),%rax
  805e06:	48 85 c0             	test   %rax,%rax
  805e09:	0f 85 84 00 00 00    	jne    805e93 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  805e0f:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805e16:	00 00 00 
  805e19:	48 8b 00             	mov    (%rax),%rax
  805e1c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805e22:	ba 07 00 00 00       	mov    $0x7,%edx
  805e27:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805e2c:	89 c7                	mov    %eax,%edi
  805e2e:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  805e35:	00 00 00 
  805e38:	ff d0                	callq  *%rax
  805e3a:	85 c0                	test   %eax,%eax
  805e3c:	79 2a                	jns    805e68 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  805e3e:	48 ba 68 6c 80 00 00 	movabs $0x806c68,%rdx
  805e45:	00 00 00 
  805e48:	be 23 00 00 00       	mov    $0x23,%esi
  805e4d:	48 bf 8f 6c 80 00 00 	movabs $0x806c8f,%rdi
  805e54:	00 00 00 
  805e57:	b8 00 00 00 00       	mov    $0x0,%eax
  805e5c:	48 b9 32 13 80 00 00 	movabs $0x801332,%rcx
  805e63:	00 00 00 
  805e66:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  805e68:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805e6f:	00 00 00 
  805e72:	48 8b 00             	mov    (%rax),%rax
  805e75:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805e7b:	48 be a6 5e 80 00 00 	movabs $0x805ea6,%rsi
  805e82:	00 00 00 
  805e85:	89 c7                	mov    %eax,%edi
  805e87:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  805e8e:	00 00 00 
  805e91:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  805e93:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  805e9a:	00 00 00 
  805e9d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805ea1:	48 89 10             	mov    %rdx,(%rax)
}
  805ea4:	c9                   	leaveq 
  805ea5:	c3                   	retq   

0000000000805ea6 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  805ea6:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  805ea9:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  805eb0:	00 00 00 
call *%rax
  805eb3:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  805eb5:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  805ebc:	00 
movq 152(%rsp), %rcx  //Load RSP
  805ebd:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  805ec4:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  805ec5:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  805ec9:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  805ecc:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  805ed3:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  805ed4:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  805ed8:	4c 8b 3c 24          	mov    (%rsp),%r15
  805edc:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  805ee1:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805ee6:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  805eeb:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  805ef0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805ef5:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805efa:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  805eff:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  805f04:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805f09:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805f0e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  805f13:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805f18:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805f1d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805f22:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  805f26:	48 83 c4 08          	add    $0x8,%rsp
popfq
  805f2a:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  805f2b:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  805f2c:	c3                   	retq   

0000000000805f2d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805f2d:	55                   	push   %rbp
  805f2e:	48 89 e5             	mov    %rsp,%rbp
  805f31:	48 83 ec 30          	sub    $0x30,%rsp
  805f35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805f39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805f3d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  805f41:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805f48:	00 00 00 
  805f4b:	48 8b 00             	mov    (%rax),%rax
  805f4e:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805f54:	85 c0                	test   %eax,%eax
  805f56:	75 34                	jne    805f8c <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  805f58:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  805f5f:	00 00 00 
  805f62:	ff d0                	callq  *%rax
  805f64:	25 ff 03 00 00       	and    $0x3ff,%eax
  805f69:	48 98                	cltq   
  805f6b:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  805f72:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805f79:	00 00 00 
  805f7c:	48 01 c2             	add    %rax,%rdx
  805f7f:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805f86:	00 00 00 
  805f89:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  805f8c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805f91:	75 0e                	jne    805fa1 <ipc_recv+0x74>
		pg = (void*) UTOP;
  805f93:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805f9a:	00 00 00 
  805f9d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  805fa1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805fa5:	48 89 c7             	mov    %rax,%rdi
  805fa8:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  805faf:	00 00 00 
  805fb2:	ff d0                	callq  *%rax
  805fb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  805fb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805fbb:	79 19                	jns    805fd6 <ipc_recv+0xa9>
		*from_env_store = 0;
  805fbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805fc1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  805fc7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805fcb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  805fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805fd4:	eb 53                	jmp    806029 <ipc_recv+0xfc>
	}
	if(from_env_store)
  805fd6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805fdb:	74 19                	je     805ff6 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  805fdd:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805fe4:	00 00 00 
  805fe7:	48 8b 00             	mov    (%rax),%rax
  805fea:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  805ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ff4:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  805ff6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805ffb:	74 19                	je     806016 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  805ffd:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  806004:	00 00 00 
  806007:	48 8b 00             	mov    (%rax),%rax
  80600a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  806010:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806014:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  806016:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80601d:	00 00 00 
  806020:	48 8b 00             	mov    (%rax),%rax
  806023:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  806029:	c9                   	leaveq 
  80602a:	c3                   	retq   

000000000080602b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80602b:	55                   	push   %rbp
  80602c:	48 89 e5             	mov    %rsp,%rbp
  80602f:	48 83 ec 30          	sub    $0x30,%rsp
  806033:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806036:	89 75 e8             	mov    %esi,-0x18(%rbp)
  806039:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80603d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  806040:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  806045:	75 0e                	jne    806055 <ipc_send+0x2a>
		pg = (void*)UTOP;
  806047:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80604e:	00 00 00 
  806051:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  806055:	8b 75 e8             	mov    -0x18(%rbp),%esi
  806058:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80605b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80605f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806062:	89 c7                	mov    %eax,%edi
  806064:	48 b8 7d 2d 80 00 00 	movabs $0x802d7d,%rax
  80606b:	00 00 00 
  80606e:	ff d0                	callq  *%rax
  806070:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  806073:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  806077:	75 0c                	jne    806085 <ipc_send+0x5a>
			sys_yield();
  806079:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  806080:	00 00 00 
  806083:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  806085:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  806089:	74 ca                	je     806055 <ipc_send+0x2a>
	if(result != 0)
  80608b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80608f:	74 20                	je     8060b1 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  806091:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806094:	89 c6                	mov    %eax,%esi
  806096:	48 bf 9d 6c 80 00 00 	movabs $0x806c9d,%rdi
  80609d:	00 00 00 
  8060a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8060a5:	48 ba 6b 15 80 00 00 	movabs $0x80156b,%rdx
  8060ac:	00 00 00 
  8060af:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  8060b1:	c9                   	leaveq 
  8060b2:	c3                   	retq   

00000000008060b3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8060b3:	55                   	push   %rbp
  8060b4:	48 89 e5             	mov    %rsp,%rbp
  8060b7:	48 83 ec 14          	sub    $0x14,%rsp
  8060bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8060be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8060c5:	eb 4e                	jmp    806115 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8060c7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8060ce:	00 00 00 
  8060d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8060d4:	48 98                	cltq   
  8060d6:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8060dd:	48 01 d0             	add    %rdx,%rax
  8060e0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8060e6:	8b 00                	mov    (%rax),%eax
  8060e8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8060eb:	75 24                	jne    806111 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8060ed:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8060f4:	00 00 00 
  8060f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8060fa:	48 98                	cltq   
  8060fc:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  806103:	48 01 d0             	add    %rdx,%rax
  806106:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80610c:	8b 40 08             	mov    0x8(%rax),%eax
  80610f:	eb 12                	jmp    806123 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  806111:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  806115:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80611c:	7e a9                	jle    8060c7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80611e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806123:	c9                   	leaveq 
  806124:	c3                   	retq   

0000000000806125 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  806125:	55                   	push   %rbp
  806126:	48 89 e5             	mov    %rsp,%rbp
  806129:	48 83 ec 18          	sub    $0x18,%rsp
  80612d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  806131:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806135:	48 c1 e8 15          	shr    $0x15,%rax
  806139:	48 89 c2             	mov    %rax,%rdx
  80613c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  806143:	01 00 00 
  806146:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80614a:	83 e0 01             	and    $0x1,%eax
  80614d:	48 85 c0             	test   %rax,%rax
  806150:	75 07                	jne    806159 <pageref+0x34>
		return 0;
  806152:	b8 00 00 00 00       	mov    $0x0,%eax
  806157:	eb 53                	jmp    8061ac <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  806159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80615d:	48 c1 e8 0c          	shr    $0xc,%rax
  806161:	48 89 c2             	mov    %rax,%rdx
  806164:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80616b:	01 00 00 
  80616e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806172:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  806176:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80617a:	83 e0 01             	and    $0x1,%eax
  80617d:	48 85 c0             	test   %rax,%rax
  806180:	75 07                	jne    806189 <pageref+0x64>
		return 0;
  806182:	b8 00 00 00 00       	mov    $0x0,%eax
  806187:	eb 23                	jmp    8061ac <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  806189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80618d:	48 c1 e8 0c          	shr    $0xc,%rax
  806191:	48 89 c2             	mov    %rax,%rdx
  806194:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80619b:	00 00 00 
  80619e:	48 c1 e2 04          	shl    $0x4,%rdx
  8061a2:	48 01 d0             	add    %rdx,%rax
  8061a5:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8061a9:	0f b7 c0             	movzwl %ax,%eax
}
  8061ac:	c9                   	leaveq 
  8061ad:	c3                   	retq   
