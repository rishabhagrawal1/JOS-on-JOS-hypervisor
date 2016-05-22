
vmm/guest/obj/user/sh:     file format elf64-x86-64


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
  80003c:	e8 26 12 00 00       	callq  801267 <libmain>
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
  8000d8:	48 bf e8 63 80 00 00 	movabs $0x8063e8,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  8000ee:	00 00 00 
  8000f1:	ff d2                	callq  *%rdx
				exit();
  8000f3:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
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
  80013e:	48 bf 00 64 80 00 00 	movabs $0x806400,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  800165:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	48 89 c7             	mov    %rax,%rdi
  800174:	48 b8 06 42 80 00 00 	movabs $0x804206,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800187:	79 34                	jns    8001bd <runcmd+0x17a>
				cprintf("open %s for read: %e", t, fd);
  800189:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800190:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 bf 26 64 80 00 00 	movabs $0x806426,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 46 15 80 00 00 	movabs $0x801546,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx
				exit();
  8001b1:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
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
  8001cd:	48 b8 ba 3b 80 00 00 	movabs $0x803bba,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
				close(fd);
  8001d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
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
  800214:	48 bf 40 64 80 00 00 	movabs $0x806440,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
				exit();
  80022f:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80023b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800242:	be 01 03 00 00       	mov    $0x301,%esi
  800247:	48 89 c7             	mov    %rax,%rdi
  80024a:	48 b8 06 42 80 00 00 	movabs $0x804206,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
  800256:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025d:	79 34                	jns    800293 <runcmd+0x250>
				cprintf("open %s for write: %e", t, fd);
  80025f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800266:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800269:	48 89 c6             	mov    %rax,%rsi
  80026c:	48 bf 66 64 80 00 00 	movabs $0x806466,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 b9 46 15 80 00 00 	movabs $0x801546,%rcx
  800282:	00 00 00 
  800285:	ff d1                	callq  *%rcx
				exit();
  800287:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
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
  8002a3:	48 b8 ba 3b 80 00 00 	movabs $0x803bba,%rax
  8002aa:	00 00 00 
  8002ad:	ff d0                	callq  *%rax
				close(fd);
  8002af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b2:	89 c7                	mov    %eax,%edi
  8002b4:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
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
  8002d4:	48 b8 6c 56 80 00 00 	movabs $0x80566c,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
  8002e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e7:	79 2c                	jns    800315 <runcmd+0x2d2>
				cprintf("pipe: %e", r);
  8002e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002ec:	89 c6                	mov    %eax,%esi
  8002ee:	48 bf 7c 64 80 00 00 	movabs $0x80647c,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  800304:	00 00 00 
  800307:	ff d2                	callq  *%rdx
				exit();
  800309:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
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
  800333:	48 bf 85 64 80 00 00 	movabs $0x806485,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	48 b9 46 15 80 00 00 	movabs $0x801546,%rcx
  800349:	00 00 00 
  80034c:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034e:	48 b8 bd 32 80 00 00 	movabs $0x8032bd,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax
  80035a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800361:	79 2c                	jns    80038f <runcmd+0x34c>
				cprintf("fork: %e", r);
  800363:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf 92 64 80 00 00 	movabs $0x806492,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
				exit();
  800383:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
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
  8003ac:	48 b8 ba 3b 80 00 00 	movabs $0x803bba,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
					close(p[0]);
  8003b8:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003be:	89 c7                	mov    %eax,%edi
  8003c0:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003cc:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003d2:	89 c7                	mov    %eax,%edi
  8003d4:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
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
  800403:	48 b8 ba 3b 80 00 00 	movabs $0x803bba,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax
					close(p[1]);
  80040f:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800415:	89 c7                	mov    %eax,%edi
  800417:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800423:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800429:	89 c7                	mov    %eax,%edi
  80042b:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
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
  80043e:	48 ba 9b 64 80 00 00 	movabs $0x80649b,%rdx
  800445:	00 00 00 
  800448:	be 6f 00 00 00       	mov    $0x6f,%esi
  80044d:	48 bf b7 64 80 00 00 	movabs $0x8064b7,%rdi
  800454:	00 00 00 
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
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
  800489:	48 bf c1 64 80 00 00 	movabs $0x8064c1,%rdi
  800490:	00 00 00 
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
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
  8004d6:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
		strcat(argv0buf, argv[0]);
  8004e2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004e9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f0:	48 89 d6             	mov    %rdx,%rsi
  8004f3:	48 89 c7             	mov    %rax,%rdi
  8004f6:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
		r = stat(argv0buf, &st);
  800502:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  800509:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800510:	48 89 d6             	mov    %rdx,%rsi
  800513:	48 89 c7             	mov    %rax,%rdi
  800516:	48 b8 18 41 80 00 00 	movabs $0x804118,%rax
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
  800581:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
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
  8005d5:	48 bf d0 64 80 00 00 	movabs $0x8064d0,%rdi
  8005dc:	00 00 00 
  8005df:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e4:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
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
  800609:	48 bf de 64 80 00 00 	movabs $0x8064de,%rdi
  800610:	00 00 00 
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
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
  80063a:	48 bf e2 64 80 00 00 	movabs $0x8064e2,%rdi
  800641:	00 00 00 
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  800650:	00 00 00 
  800653:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800655:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80065c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800663:	48 89 d6             	mov    %rdx,%rsi
  800666:	48 89 c7             	mov    %rax,%rdi
  800669:	48 b8 20 4b 80 00 00 	movabs $0x804b20,%rax
  800670:	00 00 00 
  800673:	ff d0                	callq  *%rax
  800675:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800678:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80067c:	79 28                	jns    8006a6 <runcmd+0x663>
		cprintf("spawn %s: %e\n", argv[0], r);
  80067e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800685:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800688:	48 89 c6             	mov    %rax,%rsi
  80068b:	48 bf e4 64 80 00 00 	movabs $0x8064e4,%rdi
  800692:	00 00 00 
  800695:	b8 00 00 00 00       	mov    $0x0,%eax
  80069a:	48 b9 46 15 80 00 00 	movabs $0x801546,%rcx
  8006a1:	00 00 00 
  8006a4:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006a6:	48 b8 8c 3b 80 00 00 	movabs $0x803b8c,%rax
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
  8006eb:	48 bf f2 64 80 00 00 	movabs $0x8064f2,%rdi
  8006f2:	00 00 00 
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fa:	49 b8 46 15 80 00 00 	movabs $0x801546,%r8
  800701:	00 00 00 
  800704:	41 ff d0             	callq  *%r8
		wait(r);
  800707:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070a:	89 c7                	mov    %eax,%edi
  80070c:	48 b8 35 5c 80 00 00 	movabs $0x805c35,%rax
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
  80073d:	48 bf 07 65 80 00 00 	movabs $0x806507,%rdi
  800744:	00 00 00 
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
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
  80078a:	48 bf 1d 65 80 00 00 	movabs $0x80651d,%rdi
  800791:	00 00 00 
  800794:	b8 00 00 00 00       	mov    $0x0,%eax
  800799:	48 b9 46 15 80 00 00 	movabs $0x801546,%rcx
  8007a0:	00 00 00 
  8007a3:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007a8:	89 c7                	mov    %eax,%edi
  8007aa:	48 b8 35 5c 80 00 00 	movabs $0x805c35,%rax
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
  8007db:	48 bf 07 65 80 00 00 	movabs $0x806507,%rdi
  8007e2:	00 00 00 
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  8007f1:	00 00 00 
  8007f4:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007f6:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
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
  800830:	48 bf 3a 65 80 00 00 	movabs $0x80653a,%rdi
  800837:	00 00 00 
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
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
  80086d:	48 bf 49 65 80 00 00 	movabs $0x806549,%rdi
  800874:	00 00 00 
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
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
  8008bb:	48 bf 57 65 80 00 00 	movabs $0x806557,%rdi
  8008c2:	00 00 00 
  8008c5:	48 b8 7b 24 80 00 00 	movabs $0x80247b,%rax
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
  8008f2:	48 bf 5c 65 80 00 00 	movabs $0x80655c,%rdi
  8008f9:	00 00 00 
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
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
  800923:	48 bf 61 65 80 00 00 	movabs $0x806561,%rdi
  80092a:	00 00 00 
  80092d:	48 b8 7b 24 80 00 00 	movabs $0x80247b,%rax
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
  800986:	48 bf 69 65 80 00 00 	movabs $0x806569,%rdi
  80098d:	00 00 00 
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
  800995:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
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
  8009d2:	48 bf 71 65 80 00 00 	movabs $0x806571,%rdi
  8009d9:	00 00 00 
  8009dc:	48 b8 7b 24 80 00 00 	movabs $0x80247b,%rax
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
  800a2d:	48 bf 7d 65 80 00 00 	movabs $0x80657d,%rdi
  800a34:	00 00 00 
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
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
  800b26:	48 bf 88 65 80 00 00 	movabs $0x806588,%rdi
  800b2d:	00 00 00 
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  800b3c:	00 00 00 
  800b3f:	ff d2                	callq  *%rdx
	exit();
  800b41:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
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
  800b82:	48 b8 66 35 80 00 00 	movabs $0x803566,%rax
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
  800be4:	48 b8 ca 35 80 00 00 	movabs $0x8035ca,%rax
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
  800bfe:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  800c05:	00 00 00 
  800c08:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800c0a:	48 b8 75 10 80 00 00 	movabs $0x801075,%rax
  800c11:	00 00 00 
  800c14:	ff d0                	callq  *%rax
  800c16:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800c19:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800c1d:	79 30                	jns    800c4f <umain+0x100>
		panic("opencons: %e", r);
  800c1f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800c22:	89 c1                	mov    %eax,%ecx
  800c24:	48 ba a9 65 80 00 00 	movabs $0x8065a9,%rdx
  800c2b:	00 00 00 
  800c2e:	be 27 01 00 00       	mov    $0x127,%esi
  800c33:	48 bf b7 64 80 00 00 	movabs $0x8064b7,%rdi
  800c3a:	00 00 00 
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c42:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
  800c49:	00 00 00 
  800c4c:	41 ff d0             	callq  *%r8
	if (r != 0)
  800c4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800c53:	74 30                	je     800c85 <umain+0x136>
		panic("first opencons used fd %d", r);
  800c55:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800c58:	89 c1                	mov    %eax,%ecx
  800c5a:	48 ba b6 65 80 00 00 	movabs $0x8065b6,%rdx
  800c61:	00 00 00 
  800c64:	be 29 01 00 00       	mov    $0x129,%esi
  800c69:	48 bf b7 64 80 00 00 	movabs $0x8064b7,%rdi
  800c70:	00 00 00 
  800c73:	b8 00 00 00 00       	mov    $0x0,%eax
  800c78:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
  800c7f:	00 00 00 
  800c82:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800c85:	be 01 00 00 00       	mov    $0x1,%esi
  800c8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8f:	48 b8 ba 3b 80 00 00 	movabs $0x803bba,%rax
  800c96:	00 00 00 
  800c99:	ff d0                	callq  *%rax
  800c9b:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800c9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800ca2:	79 30                	jns    800cd4 <umain+0x185>
		panic("dup: %e", r);
  800ca4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800ca7:	89 c1                	mov    %eax,%ecx
  800ca9:	48 ba d0 65 80 00 00 	movabs $0x8065d0,%rdx
  800cb0:	00 00 00 
  800cb3:	be 2b 01 00 00       	mov    $0x12b,%esi
  800cb8:	48 bf b7 64 80 00 00 	movabs $0x8064b7,%rdi
  800cbf:	00 00 00 
  800cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc7:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
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
  800cf9:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  800d00:	00 00 00 
  800d03:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800d05:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800d09:	48 83 c0 08          	add    $0x8,%rax
  800d0d:	48 8b 00             	mov    (%rax),%rax
  800d10:	be 00 00 00 00       	mov    $0x0,%esi
  800d15:	48 89 c7             	mov    %rax,%rdi
  800d18:	48 b8 06 42 80 00 00 	movabs $0x804206,%rax
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
  800d41:	48 ba d8 65 80 00 00 	movabs $0x8065d8,%rdx
  800d48:	00 00 00 
  800d4b:	be 31 01 00 00       	mov    $0x131,%esi
  800d50:	48 bf b7 64 80 00 00 	movabs $0x8064b7,%rdi
  800d57:	00 00 00 
  800d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5f:	49 b9 0d 13 80 00 00 	movabs $0x80130d,%r9
  800d66:	00 00 00 
  800d69:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800d6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800d70:	74 35                	je     800da7 <umain+0x258>
  800d72:	48 b9 e4 65 80 00 00 	movabs $0x8065e4,%rcx
  800d79:	00 00 00 
  800d7c:	48 ba eb 65 80 00 00 	movabs $0x8065eb,%rdx
  800d83:	00 00 00 
  800d86:	be 32 01 00 00       	mov    $0x132,%esi
  800d8b:	48 bf b7 64 80 00 00 	movabs $0x8064b7,%rdi
  800d92:	00 00 00 
  800d95:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9a:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
  800da1:	00 00 00 
  800da4:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800da7:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800dab:	75 14                	jne    800dc1 <umain+0x272>
		interactive = iscons(0);
  800dad:	bf 00 00 00 00       	mov    $0x0,%edi
  800db2:	48 b8 28 10 80 00 00 	movabs $0x801028,%rax
  800db9:	00 00 00 
  800dbc:	ff d0                	callq  *%rax
  800dbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
	while (1) {
		char *buf;
		#ifndef VMM_GUEST
		buf = readline(interactive ? "$ " : NULL);
		#else
		buf = readline(interactive ? "vm$ " : NULL);
  800dc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dc5:	74 0c                	je     800dd3 <umain+0x284>
  800dc7:	48 b8 00 66 80 00 00 	movabs $0x806600,%rax
  800dce:	00 00 00 
  800dd1:	eb 05                	jmp    800dd8 <umain+0x289>
  800dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd8:	48 89 c7             	mov    %rax,%rdi
  800ddb:	48 b8 8f 20 80 00 00 	movabs $0x80208f,%rax
  800de2:	00 00 00 
  800de5:	ff d0                	callq  *%rax
  800de7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
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
  800e02:	48 bf 05 66 80 00 00 	movabs $0x806605,%rdi
  800e09:	00 00 00 
  800e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e11:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  800e18:	00 00 00 
  800e1b:	ff d2                	callq  *%rdx
			exit();	// end of file
  800e1d:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
  800e24:	00 00 00 
  800e27:	ff d0                	callq  *%rax
		}
		#ifndef VMM_GUEST
		if(strcmp(buf, "vmmanager")==0)
			auto_terminate = true;
		#endif
		if(strcmp(buf, "quit")==0)
  800e29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2d:	48 be 0e 66 80 00 00 	movabs $0x80660e,%rsi
  800e34:	00 00 00 
  800e37:	48 89 c7             	mov    %rax,%rdi
  800e3a:	48 b8 b7 23 80 00 00 	movabs $0x8023b7,%rax
  800e41:	00 00 00 
  800e44:	ff d0                	callq  *%rax
  800e46:	85 c0                	test   %eax,%eax
  800e48:	75 0c                	jne    800e56 <umain+0x307>
			exit();
  800e4a:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
  800e51:	00 00 00 
  800e54:	ff d0                	callq  *%rax
		if (debug)
  800e56:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800e5d:	00 00 00 
  800e60:	8b 00                	mov    (%rax),%eax
  800e62:	85 c0                	test   %eax,%eax
  800e64:	74 22                	je     800e88 <umain+0x339>
			cprintf("LINE: %s\n", buf);
  800e66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6a:	48 89 c6             	mov    %rax,%rsi
  800e6d:	48 bf 13 66 80 00 00 	movabs $0x806613,%rdi
  800e74:	00 00 00 
  800e77:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7c:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  800e83:	00 00 00 
  800e86:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8c:	0f b6 00             	movzbl (%rax),%eax
  800e8f:	3c 23                	cmp    $0x23,%al
  800e91:	75 05                	jne    800e98 <umain+0x349>
			continue;
  800e93:	e9 17 01 00 00       	jmpq   800faf <umain+0x460>
		if (echocmds)
  800e98:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800e9c:	74 22                	je     800ec0 <umain+0x371>
			printf("# %s\n", buf);
  800e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea2:	48 89 c6             	mov    %rax,%rsi
  800ea5:	48 bf 1d 66 80 00 00 	movabs $0x80661d,%rdi
  800eac:	00 00 00 
  800eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb4:	48 ba 6a 4a 80 00 00 	movabs $0x804a6a,%rdx
  800ebb:	00 00 00 
  800ebe:	ff d2                	callq  *%rdx
			//fprintf(1, "# %s\n", buf);
		if (debug)
  800ec0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800ec7:	00 00 00 
  800eca:	8b 00                	mov    (%rax),%eax
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	74 1b                	je     800eeb <umain+0x39c>
			cprintf("BEFORE FORK\n");
  800ed0:	48 bf 23 66 80 00 00 	movabs $0x806623,%rdi
  800ed7:	00 00 00 
  800eda:	b8 00 00 00 00       	mov    $0x0,%eax
  800edf:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  800ee6:	00 00 00 
  800ee9:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800eeb:	48 b8 bd 32 80 00 00 	movabs $0x8032bd,%rax
  800ef2:	00 00 00 
  800ef5:	ff d0                	callq  *%rax
  800ef7:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800efa:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800efe:	79 30                	jns    800f30 <umain+0x3e1>
			panic("fork: %e", r);
  800f00:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f03:	89 c1                	mov    %eax,%ecx
  800f05:	48 ba 92 64 80 00 00 	movabs $0x806492,%rdx
  800f0c:	00 00 00 
  800f0f:	be 53 01 00 00       	mov    $0x153,%esi
  800f14:	48 bf b7 64 80 00 00 	movabs $0x8064b7,%rdi
  800f1b:	00 00 00 
  800f1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f23:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
  800f2a:	00 00 00 
  800f2d:	41 ff d0             	callq  *%r8
		if (debug)
  800f30:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800f37:	00 00 00 
  800f3a:	8b 00                	mov    (%rax),%eax
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	74 20                	je     800f60 <umain+0x411>
			cprintf("FORK: %d\n", r);
  800f40:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f43:	89 c6                	mov    %eax,%esi
  800f45:	48 bf 30 66 80 00 00 	movabs $0x806630,%rdi
  800f4c:	00 00 00 
  800f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f54:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  800f5b:	00 00 00 
  800f5e:	ff d2                	callq  *%rdx
		if (r == 0) {
  800f60:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800f64:	75 21                	jne    800f87 <umain+0x438>
			runcmd(buf);
  800f66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6a:	48 89 c7             	mov    %rax,%rdi
  800f6d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800f74:	00 00 00 
  800f77:	ff d0                	callq  *%rax
			exit();
  800f79:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
  800f80:	00 00 00 
  800f83:	ff d0                	callq  *%rax
  800f85:	eb 28                	jmp    800faf <umain+0x460>
		} else {
			wait(r);
  800f87:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f8a:	89 c7                	mov    %eax,%edi
  800f8c:	48 b8 35 5c 80 00 00 	movabs $0x805c35,%rax
  800f93:	00 00 00 
  800f96:	ff d0                	callq  *%rax
			if (auto_terminate)
  800f98:	80 7d f7 00          	cmpb   $0x0,-0x9(%rbp)
  800f9c:	74 11                	je     800faf <umain+0x460>
				exit();
  800f9e:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
  800fa5:	00 00 00 
  800fa8:	ff d0                	callq  *%rax
		}
	}
  800faa:	e9 12 fe ff ff       	jmpq   800dc1 <umain+0x272>
  800faf:	e9 0d fe ff ff       	jmpq   800dc1 <umain+0x272>

0000000000800fb4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800fb4:	55                   	push   %rbp
  800fb5:	48 89 e5             	mov    %rsp,%rbp
  800fb8:	48 83 ec 20          	sub    $0x20,%rsp
  800fbc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800fbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800fc2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800fc5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800fc9:	be 01 00 00 00       	mov    $0x1,%esi
  800fce:	48 89 c7             	mov    %rax,%rdi
  800fd1:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  800fd8:	00 00 00 
  800fdb:	ff d0                	callq  *%rax
}
  800fdd:	c9                   	leaveq 
  800fde:	c3                   	retq   

0000000000800fdf <getchar>:

int
getchar(void)
{
  800fdf:	55                   	push   %rbp
  800fe0:	48 89 e5             	mov    %rsp,%rbp
  800fe3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800fe7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800feb:	ba 01 00 00 00       	mov    $0x1,%edx
  800ff0:	48 89 c6             	mov    %rax,%rsi
  800ff3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ff8:	48 b8 63 3d 80 00 00 	movabs $0x803d63,%rax
  800fff:	00 00 00 
  801002:	ff d0                	callq  *%rax
  801004:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801007:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80100b:	79 05                	jns    801012 <getchar+0x33>
		return r;
  80100d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801010:	eb 14                	jmp    801026 <getchar+0x47>
	if (r < 1)
  801012:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801016:	7f 07                	jg     80101f <getchar+0x40>
		return -E_EOF;
  801018:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80101d:	eb 07                	jmp    801026 <getchar+0x47>
	return c;
  80101f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801023:	0f b6 c0             	movzbl %al,%eax
}
  801026:	c9                   	leaveq 
  801027:	c3                   	retq   

0000000000801028 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801028:	55                   	push   %rbp
  801029:	48 89 e5             	mov    %rsp,%rbp
  80102c:	48 83 ec 20          	sub    $0x20,%rsp
  801030:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801033:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801037:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80103a:	48 89 d6             	mov    %rdx,%rsi
  80103d:	89 c7                	mov    %eax,%edi
  80103f:	48 b8 31 39 80 00 00 	movabs $0x803931,%rax
  801046:	00 00 00 
  801049:	ff d0                	callq  *%rax
  80104b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80104e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801052:	79 05                	jns    801059 <iscons+0x31>
		return r;
  801054:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801057:	eb 1a                	jmp    801073 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801059:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105d:	8b 10                	mov    (%rax),%edx
  80105f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  801066:	00 00 00 
  801069:	8b 00                	mov    (%rax),%eax
  80106b:	39 c2                	cmp    %eax,%edx
  80106d:	0f 94 c0             	sete   %al
  801070:	0f b6 c0             	movzbl %al,%eax
}
  801073:	c9                   	leaveq 
  801074:	c3                   	retq   

0000000000801075 <opencons>:

int
opencons(void)
{
  801075:	55                   	push   %rbp
  801076:	48 89 e5             	mov    %rsp,%rbp
  801079:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80107d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801081:	48 89 c7             	mov    %rax,%rdi
  801084:	48 b8 99 38 80 00 00 	movabs $0x803899,%rax
  80108b:	00 00 00 
  80108e:	ff d0                	callq  *%rax
  801090:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801093:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801097:	79 05                	jns    80109e <opencons+0x29>
		return r;
  801099:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80109c:	eb 5b                	jmp    8010f9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80109e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a2:	ba 07 04 00 00       	mov    $0x407,%edx
  8010a7:	48 89 c6             	mov    %rax,%rsi
  8010aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8010af:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  8010b6:	00 00 00 
  8010b9:	ff d0                	callq  *%rax
  8010bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010c2:	79 05                	jns    8010c9 <opencons+0x54>
		return r;
  8010c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c7:	eb 30                	jmp    8010f9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8010c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cd:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8010d4:	00 00 00 
  8010d7:	8b 12                	mov    (%rdx),%edx
  8010d9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8010db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010df:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8010e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ea:	48 89 c7             	mov    %rax,%rdi
  8010ed:	48 b8 4b 38 80 00 00 	movabs $0x80384b,%rax
  8010f4:	00 00 00 
  8010f7:	ff d0                	callq  *%rax
}
  8010f9:	c9                   	leaveq 
  8010fa:	c3                   	retq   

00000000008010fb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8010fb:	55                   	push   %rbp
  8010fc:	48 89 e5             	mov    %rsp,%rbp
  8010ff:	48 83 ec 30          	sub    $0x30,%rsp
  801103:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801107:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80110b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80110f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801114:	75 07                	jne    80111d <devcons_read+0x22>
		return 0;
  801116:	b8 00 00 00 00       	mov    $0x0,%eax
  80111b:	eb 4b                	jmp    801168 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80111d:	eb 0c                	jmp    80112b <devcons_read+0x30>
		sys_yield();
  80111f:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  801126:	00 00 00 
  801129:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80112b:	48 b8 86 2a 80 00 00 	movabs $0x802a86,%rax
  801132:	00 00 00 
  801135:	ff d0                	callq  *%rax
  801137:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80113a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80113e:	74 df                	je     80111f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801140:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801144:	79 05                	jns    80114b <devcons_read+0x50>
		return c;
  801146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801149:	eb 1d                	jmp    801168 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80114b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80114f:	75 07                	jne    801158 <devcons_read+0x5d>
		return 0;
  801151:	b8 00 00 00 00       	mov    $0x0,%eax
  801156:	eb 10                	jmp    801168 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801158:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80115b:	89 c2                	mov    %eax,%edx
  80115d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801161:	88 10                	mov    %dl,(%rax)
	return 1;
  801163:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801168:	c9                   	leaveq 
  801169:	c3                   	retq   

000000000080116a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80116a:	55                   	push   %rbp
  80116b:	48 89 e5             	mov    %rsp,%rbp
  80116e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801175:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80117c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801183:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80118a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801191:	eb 76                	jmp    801209 <devcons_write+0x9f>
		m = n - tot;
  801193:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80119a:	89 c2                	mov    %eax,%edx
  80119c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80119f:	29 c2                	sub    %eax,%edx
  8011a1:	89 d0                	mov    %edx,%eax
  8011a3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8011a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011a9:	83 f8 7f             	cmp    $0x7f,%eax
  8011ac:	76 07                	jbe    8011b5 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8011ae:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8011b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011b8:	48 63 d0             	movslq %eax,%rdx
  8011bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011be:	48 63 c8             	movslq %eax,%rcx
  8011c1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8011c8:	48 01 c1             	add    %rax,%rcx
  8011cb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8011d2:	48 89 ce             	mov    %rcx,%rsi
  8011d5:	48 89 c7             	mov    %rax,%rdi
  8011d8:	48 b8 79 25 80 00 00 	movabs $0x802579,%rax
  8011df:	00 00 00 
  8011e2:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8011e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011e7:	48 63 d0             	movslq %eax,%rdx
  8011ea:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8011f1:	48 89 d6             	mov    %rdx,%rsi
  8011f4:	48 89 c7             	mov    %rax,%rdi
  8011f7:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  8011fe:	00 00 00 
  801201:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801203:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801206:	01 45 fc             	add    %eax,-0x4(%rbp)
  801209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80120c:	48 98                	cltq   
  80120e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801215:	0f 82 78 ff ff ff    	jb     801193 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80121b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80121e:	c9                   	leaveq 
  80121f:	c3                   	retq   

0000000000801220 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801220:	55                   	push   %rbp
  801221:	48 89 e5             	mov    %rsp,%rbp
  801224:	48 83 ec 08          	sub    $0x8,%rsp
  801228:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80122c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801231:	c9                   	leaveq 
  801232:	c3                   	retq   

0000000000801233 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801233:	55                   	push   %rbp
  801234:	48 89 e5             	mov    %rsp,%rbp
  801237:	48 83 ec 10          	sub    $0x10,%rsp
  80123b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80123f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801243:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801247:	48 be 3f 66 80 00 00 	movabs $0x80663f,%rsi
  80124e:	00 00 00 
  801251:	48 89 c7             	mov    %rax,%rdi
  801254:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  80125b:	00 00 00 
  80125e:	ff d0                	callq  *%rax
	return 0;
  801260:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801265:	c9                   	leaveq 
  801266:	c3                   	retq   

0000000000801267 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801267:	55                   	push   %rbp
  801268:	48 89 e5             	mov    %rsp,%rbp
  80126b:	48 83 ec 10          	sub    $0x10,%rsp
  80126f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801272:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801276:	48 b8 08 2b 80 00 00 	movabs $0x802b08,%rax
  80127d:	00 00 00 
  801280:	ff d0                	callq  *%rax
  801282:	25 ff 03 00 00       	and    $0x3ff,%eax
  801287:	48 98                	cltq   
  801289:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  801290:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801297:	00 00 00 
  80129a:	48 01 c2             	add    %rax,%rdx
  80129d:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8012a4:	00 00 00 
  8012a7:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8012aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012ae:	7e 14                	jle    8012c4 <libmain+0x5d>
		binaryname = argv[0];
  8012b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b4:	48 8b 10             	mov    (%rax),%rdx
  8012b7:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8012be:	00 00 00 
  8012c1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8012c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8012c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012cb:	48 89 d6             	mov    %rdx,%rsi
  8012ce:	89 c7                	mov    %eax,%edi
  8012d0:	48 b8 4f 0b 80 00 00 	movabs $0x800b4f,%rax
  8012d7:	00 00 00 
  8012da:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8012dc:	48 b8 ea 12 80 00 00 	movabs $0x8012ea,%rax
  8012e3:	00 00 00 
  8012e6:	ff d0                	callq  *%rax
}
  8012e8:	c9                   	leaveq 
  8012e9:	c3                   	retq   

00000000008012ea <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8012ea:	55                   	push   %rbp
  8012eb:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8012ee:	48 b8 8c 3b 80 00 00 	movabs $0x803b8c,%rax
  8012f5:	00 00 00 
  8012f8:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8012fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8012ff:	48 b8 c4 2a 80 00 00 	movabs $0x802ac4,%rax
  801306:	00 00 00 
  801309:	ff d0                	callq  *%rax

}
  80130b:	5d                   	pop    %rbp
  80130c:	c3                   	retq   

000000000080130d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80130d:	55                   	push   %rbp
  80130e:	48 89 e5             	mov    %rsp,%rbp
  801311:	53                   	push   %rbx
  801312:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801319:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801320:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801326:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80132d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801334:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80133b:	84 c0                	test   %al,%al
  80133d:	74 23                	je     801362 <_panic+0x55>
  80133f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801346:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80134a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80134e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801352:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801356:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80135a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80135e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801362:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801369:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801370:	00 00 00 
  801373:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80137a:	00 00 00 
  80137d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801381:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801388:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80138f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801396:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  80139d:	00 00 00 
  8013a0:	48 8b 18             	mov    (%rax),%rbx
  8013a3:	48 b8 08 2b 80 00 00 	movabs $0x802b08,%rax
  8013aa:	00 00 00 
  8013ad:	ff d0                	callq  *%rax
  8013af:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8013b5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8013bc:	41 89 c8             	mov    %ecx,%r8d
  8013bf:	48 89 d1             	mov    %rdx,%rcx
  8013c2:	48 89 da             	mov    %rbx,%rdx
  8013c5:	89 c6                	mov    %eax,%esi
  8013c7:	48 bf 50 66 80 00 00 	movabs $0x806650,%rdi
  8013ce:	00 00 00 
  8013d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d6:	49 b9 46 15 80 00 00 	movabs $0x801546,%r9
  8013dd:	00 00 00 
  8013e0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8013e3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8013ea:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8013f1:	48 89 d6             	mov    %rdx,%rsi
  8013f4:	48 89 c7             	mov    %rax,%rdi
  8013f7:	48 b8 9a 14 80 00 00 	movabs $0x80149a,%rax
  8013fe:	00 00 00 
  801401:	ff d0                	callq  *%rax
	cprintf("\n");
  801403:	48 bf 73 66 80 00 00 	movabs $0x806673,%rdi
  80140a:	00 00 00 
  80140d:	b8 00 00 00 00       	mov    $0x0,%eax
  801412:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  801419:	00 00 00 
  80141c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80141e:	cc                   	int3   
  80141f:	eb fd                	jmp    80141e <_panic+0x111>

0000000000801421 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801421:	55                   	push   %rbp
  801422:	48 89 e5             	mov    %rsp,%rbp
  801425:	48 83 ec 10          	sub    $0x10,%rsp
  801429:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80142c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801434:	8b 00                	mov    (%rax),%eax
  801436:	8d 48 01             	lea    0x1(%rax),%ecx
  801439:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80143d:	89 0a                	mov    %ecx,(%rdx)
  80143f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801442:	89 d1                	mov    %edx,%ecx
  801444:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801448:	48 98                	cltq   
  80144a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80144e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801452:	8b 00                	mov    (%rax),%eax
  801454:	3d ff 00 00 00       	cmp    $0xff,%eax
  801459:	75 2c                	jne    801487 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80145b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145f:	8b 00                	mov    (%rax),%eax
  801461:	48 98                	cltq   
  801463:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801467:	48 83 c2 08          	add    $0x8,%rdx
  80146b:	48 89 c6             	mov    %rax,%rsi
  80146e:	48 89 d7             	mov    %rdx,%rdi
  801471:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  801478:	00 00 00 
  80147b:	ff d0                	callq  *%rax
        b->idx = 0;
  80147d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801481:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148b:	8b 40 04             	mov    0x4(%rax),%eax
  80148e:	8d 50 01             	lea    0x1(%rax),%edx
  801491:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801495:	89 50 04             	mov    %edx,0x4(%rax)
}
  801498:	c9                   	leaveq 
  801499:	c3                   	retq   

000000000080149a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80149a:	55                   	push   %rbp
  80149b:	48 89 e5             	mov    %rsp,%rbp
  80149e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8014a5:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8014ac:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8014b3:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8014ba:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8014c1:	48 8b 0a             	mov    (%rdx),%rcx
  8014c4:	48 89 08             	mov    %rcx,(%rax)
  8014c7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014cb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014cf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014d3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8014d7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8014de:	00 00 00 
    b.cnt = 0;
  8014e1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8014e8:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8014eb:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8014f2:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8014f9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801500:	48 89 c6             	mov    %rax,%rsi
  801503:	48 bf 21 14 80 00 00 	movabs $0x801421,%rdi
  80150a:	00 00 00 
  80150d:	48 b8 f9 18 80 00 00 	movabs $0x8018f9,%rax
  801514:	00 00 00 
  801517:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  801519:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80151f:	48 98                	cltq   
  801521:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801528:	48 83 c2 08          	add    $0x8,%rdx
  80152c:	48 89 c6             	mov    %rax,%rsi
  80152f:	48 89 d7             	mov    %rdx,%rdi
  801532:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  801539:	00 00 00 
  80153c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80153e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801544:	c9                   	leaveq 
  801545:	c3                   	retq   

0000000000801546 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  801546:	55                   	push   %rbp
  801547:	48 89 e5             	mov    %rsp,%rbp
  80154a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801551:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801558:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80155f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801566:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80156d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801574:	84 c0                	test   %al,%al
  801576:	74 20                	je     801598 <cprintf+0x52>
  801578:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80157c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801580:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801584:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801588:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80158c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801590:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801594:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801598:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80159f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8015a6:	00 00 00 
  8015a9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015b0:	00 00 00 
  8015b3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015b7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8015be:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8015c5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8015cc:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8015d3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8015da:	48 8b 0a             	mov    (%rdx),%rcx
  8015dd:	48 89 08             	mov    %rcx,(%rax)
  8015e0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8015e4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8015e8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8015ec:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8015f0:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8015f7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8015fe:	48 89 d6             	mov    %rdx,%rsi
  801601:	48 89 c7             	mov    %rax,%rdi
  801604:	48 b8 9a 14 80 00 00 	movabs $0x80149a,%rax
  80160b:	00 00 00 
  80160e:	ff d0                	callq  *%rax
  801610:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  801616:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80161c:	c9                   	leaveq 
  80161d:	c3                   	retq   

000000000080161e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80161e:	55                   	push   %rbp
  80161f:	48 89 e5             	mov    %rsp,%rbp
  801622:	53                   	push   %rbx
  801623:	48 83 ec 38          	sub    $0x38,%rsp
  801627:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80162b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80162f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801633:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801636:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80163a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80163e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801641:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801645:	77 3b                	ja     801682 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801647:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80164a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80164e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801655:	ba 00 00 00 00       	mov    $0x0,%edx
  80165a:	48 f7 f3             	div    %rbx
  80165d:	48 89 c2             	mov    %rax,%rdx
  801660:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801663:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801666:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80166a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166e:	41 89 f9             	mov    %edi,%r9d
  801671:	48 89 c7             	mov    %rax,%rdi
  801674:	48 b8 1e 16 80 00 00 	movabs $0x80161e,%rax
  80167b:	00 00 00 
  80167e:	ff d0                	callq  *%rax
  801680:	eb 1e                	jmp    8016a0 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801682:	eb 12                	jmp    801696 <printnum+0x78>
			putch(padc, putdat);
  801684:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801688:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80168b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168f:	48 89 ce             	mov    %rcx,%rsi
  801692:	89 d7                	mov    %edx,%edi
  801694:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801696:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80169a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80169e:	7f e4                	jg     801684 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8016a0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	48 f7 f1             	div    %rcx
  8016af:	48 89 d0             	mov    %rdx,%rax
  8016b2:	48 ba 70 68 80 00 00 	movabs $0x806870,%rdx
  8016b9:	00 00 00 
  8016bc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8016c0:	0f be d0             	movsbl %al,%edx
  8016c3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8016c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016cb:	48 89 ce             	mov    %rcx,%rsi
  8016ce:	89 d7                	mov    %edx,%edi
  8016d0:	ff d0                	callq  *%rax
}
  8016d2:	48 83 c4 38          	add    $0x38,%rsp
  8016d6:	5b                   	pop    %rbx
  8016d7:	5d                   	pop    %rbp
  8016d8:	c3                   	retq   

00000000008016d9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8016d9:	55                   	push   %rbp
  8016da:	48 89 e5             	mov    %rsp,%rbp
  8016dd:	48 83 ec 1c          	sub    $0x1c,%rsp
  8016e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016e5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8016e8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8016ec:	7e 52                	jle    801740 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8016ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f2:	8b 00                	mov    (%rax),%eax
  8016f4:	83 f8 30             	cmp    $0x30,%eax
  8016f7:	73 24                	jae    80171d <getuint+0x44>
  8016f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016fd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801705:	8b 00                	mov    (%rax),%eax
  801707:	89 c0                	mov    %eax,%eax
  801709:	48 01 d0             	add    %rdx,%rax
  80170c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801710:	8b 12                	mov    (%rdx),%edx
  801712:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801715:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801719:	89 0a                	mov    %ecx,(%rdx)
  80171b:	eb 17                	jmp    801734 <getuint+0x5b>
  80171d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801721:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801725:	48 89 d0             	mov    %rdx,%rax
  801728:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80172c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801730:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801734:	48 8b 00             	mov    (%rax),%rax
  801737:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80173b:	e9 a3 00 00 00       	jmpq   8017e3 <getuint+0x10a>
	else if (lflag)
  801740:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801744:	74 4f                	je     801795 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174a:	8b 00                	mov    (%rax),%eax
  80174c:	83 f8 30             	cmp    $0x30,%eax
  80174f:	73 24                	jae    801775 <getuint+0x9c>
  801751:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801755:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80175d:	8b 00                	mov    (%rax),%eax
  80175f:	89 c0                	mov    %eax,%eax
  801761:	48 01 d0             	add    %rdx,%rax
  801764:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801768:	8b 12                	mov    (%rdx),%edx
  80176a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80176d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801771:	89 0a                	mov    %ecx,(%rdx)
  801773:	eb 17                	jmp    80178c <getuint+0xb3>
  801775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801779:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80177d:	48 89 d0             	mov    %rdx,%rax
  801780:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801784:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801788:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80178c:	48 8b 00             	mov    (%rax),%rax
  80178f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801793:	eb 4e                	jmp    8017e3 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  801795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801799:	8b 00                	mov    (%rax),%eax
  80179b:	83 f8 30             	cmp    $0x30,%eax
  80179e:	73 24                	jae    8017c4 <getuint+0xeb>
  8017a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ac:	8b 00                	mov    (%rax),%eax
  8017ae:	89 c0                	mov    %eax,%eax
  8017b0:	48 01 d0             	add    %rdx,%rax
  8017b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017b7:	8b 12                	mov    (%rdx),%edx
  8017b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c0:	89 0a                	mov    %ecx,(%rdx)
  8017c2:	eb 17                	jmp    8017db <getuint+0x102>
  8017c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017cc:	48 89 d0             	mov    %rdx,%rax
  8017cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017db:	8b 00                	mov    (%rax),%eax
  8017dd:	89 c0                	mov    %eax,%eax
  8017df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8017e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017e7:	c9                   	leaveq 
  8017e8:	c3                   	retq   

00000000008017e9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8017e9:	55                   	push   %rbp
  8017ea:	48 89 e5             	mov    %rsp,%rbp
  8017ed:	48 83 ec 1c          	sub    $0x1c,%rsp
  8017f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017f5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8017f8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8017fc:	7e 52                	jle    801850 <getint+0x67>
		x=va_arg(*ap, long long);
  8017fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801802:	8b 00                	mov    (%rax),%eax
  801804:	83 f8 30             	cmp    $0x30,%eax
  801807:	73 24                	jae    80182d <getint+0x44>
  801809:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801815:	8b 00                	mov    (%rax),%eax
  801817:	89 c0                	mov    %eax,%eax
  801819:	48 01 d0             	add    %rdx,%rax
  80181c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801820:	8b 12                	mov    (%rdx),%edx
  801822:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801825:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801829:	89 0a                	mov    %ecx,(%rdx)
  80182b:	eb 17                	jmp    801844 <getint+0x5b>
  80182d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801831:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801835:	48 89 d0             	mov    %rdx,%rax
  801838:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80183c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801840:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801844:	48 8b 00             	mov    (%rax),%rax
  801847:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80184b:	e9 a3 00 00 00       	jmpq   8018f3 <getint+0x10a>
	else if (lflag)
  801850:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801854:	74 4f                	je     8018a5 <getint+0xbc>
		x=va_arg(*ap, long);
  801856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80185a:	8b 00                	mov    (%rax),%eax
  80185c:	83 f8 30             	cmp    $0x30,%eax
  80185f:	73 24                	jae    801885 <getint+0x9c>
  801861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801865:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80186d:	8b 00                	mov    (%rax),%eax
  80186f:	89 c0                	mov    %eax,%eax
  801871:	48 01 d0             	add    %rdx,%rax
  801874:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801878:	8b 12                	mov    (%rdx),%edx
  80187a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80187d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801881:	89 0a                	mov    %ecx,(%rdx)
  801883:	eb 17                	jmp    80189c <getint+0xb3>
  801885:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801889:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80188d:	48 89 d0             	mov    %rdx,%rax
  801890:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801894:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801898:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80189c:	48 8b 00             	mov    (%rax),%rax
  80189f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8018a3:	eb 4e                	jmp    8018f3 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8018a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a9:	8b 00                	mov    (%rax),%eax
  8018ab:	83 f8 30             	cmp    $0x30,%eax
  8018ae:	73 24                	jae    8018d4 <getint+0xeb>
  8018b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8018b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018bc:	8b 00                	mov    (%rax),%eax
  8018be:	89 c0                	mov    %eax,%eax
  8018c0:	48 01 d0             	add    %rdx,%rax
  8018c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018c7:	8b 12                	mov    (%rdx),%edx
  8018c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8018cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018d0:	89 0a                	mov    %ecx,(%rdx)
  8018d2:	eb 17                	jmp    8018eb <getint+0x102>
  8018d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8018dc:	48 89 d0             	mov    %rdx,%rax
  8018df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8018e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8018eb:	8b 00                	mov    (%rax),%eax
  8018ed:	48 98                	cltq   
  8018ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8018f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8018f7:	c9                   	leaveq 
  8018f8:	c3                   	retq   

00000000008018f9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018f9:	55                   	push   %rbp
  8018fa:	48 89 e5             	mov    %rsp,%rbp
  8018fd:	41 54                	push   %r12
  8018ff:	53                   	push   %rbx
  801900:	48 83 ec 60          	sub    $0x60,%rsp
  801904:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801908:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80190c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801910:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801914:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801918:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80191c:	48 8b 0a             	mov    (%rdx),%rcx
  80191f:	48 89 08             	mov    %rcx,(%rax)
  801922:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801926:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80192a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80192e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801932:	eb 17                	jmp    80194b <vprintfmt+0x52>
			if (ch == '\0')
  801934:	85 db                	test   %ebx,%ebx
  801936:	0f 84 cc 04 00 00    	je     801e08 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80193c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801940:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801944:	48 89 d6             	mov    %rdx,%rsi
  801947:	89 df                	mov    %ebx,%edi
  801949:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80194b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80194f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801953:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801957:	0f b6 00             	movzbl (%rax),%eax
  80195a:	0f b6 d8             	movzbl %al,%ebx
  80195d:	83 fb 25             	cmp    $0x25,%ebx
  801960:	75 d2                	jne    801934 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801962:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801966:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80196d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801974:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80197b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801982:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801986:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80198a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80198e:	0f b6 00             	movzbl (%rax),%eax
  801991:	0f b6 d8             	movzbl %al,%ebx
  801994:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801997:	83 f8 55             	cmp    $0x55,%eax
  80199a:	0f 87 34 04 00 00    	ja     801dd4 <vprintfmt+0x4db>
  8019a0:	89 c0                	mov    %eax,%eax
  8019a2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8019a9:	00 
  8019aa:	48 b8 98 68 80 00 00 	movabs $0x806898,%rax
  8019b1:	00 00 00 
  8019b4:	48 01 d0             	add    %rdx,%rax
  8019b7:	48 8b 00             	mov    (%rax),%rax
  8019ba:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8019bc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8019c0:	eb c0                	jmp    801982 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8019c2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8019c6:	eb ba                	jmp    801982 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8019c8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8019cf:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8019d2:	89 d0                	mov    %edx,%eax
  8019d4:	c1 e0 02             	shl    $0x2,%eax
  8019d7:	01 d0                	add    %edx,%eax
  8019d9:	01 c0                	add    %eax,%eax
  8019db:	01 d8                	add    %ebx,%eax
  8019dd:	83 e8 30             	sub    $0x30,%eax
  8019e0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8019e3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8019e7:	0f b6 00             	movzbl (%rax),%eax
  8019ea:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8019ed:	83 fb 2f             	cmp    $0x2f,%ebx
  8019f0:	7e 0c                	jle    8019fe <vprintfmt+0x105>
  8019f2:	83 fb 39             	cmp    $0x39,%ebx
  8019f5:	7f 07                	jg     8019fe <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8019f7:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8019fc:	eb d1                	jmp    8019cf <vprintfmt+0xd6>
			goto process_precision;
  8019fe:	eb 58                	jmp    801a58 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  801a00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a03:	83 f8 30             	cmp    $0x30,%eax
  801a06:	73 17                	jae    801a1f <vprintfmt+0x126>
  801a08:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801a0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a0f:	89 c0                	mov    %eax,%eax
  801a11:	48 01 d0             	add    %rdx,%rax
  801a14:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a17:	83 c2 08             	add    $0x8,%edx
  801a1a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801a1d:	eb 0f                	jmp    801a2e <vprintfmt+0x135>
  801a1f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801a23:	48 89 d0             	mov    %rdx,%rax
  801a26:	48 83 c2 08          	add    $0x8,%rdx
  801a2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801a2e:	8b 00                	mov    (%rax),%eax
  801a30:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801a33:	eb 23                	jmp    801a58 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801a35:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801a39:	79 0c                	jns    801a47 <vprintfmt+0x14e>
				width = 0;
  801a3b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801a42:	e9 3b ff ff ff       	jmpq   801982 <vprintfmt+0x89>
  801a47:	e9 36 ff ff ff       	jmpq   801982 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801a4c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801a53:	e9 2a ff ff ff       	jmpq   801982 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801a58:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801a5c:	79 12                	jns    801a70 <vprintfmt+0x177>
				width = precision, precision = -1;
  801a5e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801a61:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801a64:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801a6b:	e9 12 ff ff ff       	jmpq   801982 <vprintfmt+0x89>
  801a70:	e9 0d ff ff ff       	jmpq   801982 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801a75:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801a79:	e9 04 ff ff ff       	jmpq   801982 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801a7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a81:	83 f8 30             	cmp    $0x30,%eax
  801a84:	73 17                	jae    801a9d <vprintfmt+0x1a4>
  801a86:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801a8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a8d:	89 c0                	mov    %eax,%eax
  801a8f:	48 01 d0             	add    %rdx,%rax
  801a92:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a95:	83 c2 08             	add    $0x8,%edx
  801a98:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801a9b:	eb 0f                	jmp    801aac <vprintfmt+0x1b3>
  801a9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801aa1:	48 89 d0             	mov    %rdx,%rax
  801aa4:	48 83 c2 08          	add    $0x8,%rdx
  801aa8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801aac:	8b 10                	mov    (%rax),%edx
  801aae:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801ab2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ab6:	48 89 ce             	mov    %rcx,%rsi
  801ab9:	89 d7                	mov    %edx,%edi
  801abb:	ff d0                	callq  *%rax
			break;
  801abd:	e9 40 03 00 00       	jmpq   801e02 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801ac2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801ac5:	83 f8 30             	cmp    $0x30,%eax
  801ac8:	73 17                	jae    801ae1 <vprintfmt+0x1e8>
  801aca:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801ace:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801ad1:	89 c0                	mov    %eax,%eax
  801ad3:	48 01 d0             	add    %rdx,%rax
  801ad6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801ad9:	83 c2 08             	add    $0x8,%edx
  801adc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801adf:	eb 0f                	jmp    801af0 <vprintfmt+0x1f7>
  801ae1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801ae5:	48 89 d0             	mov    %rdx,%rax
  801ae8:	48 83 c2 08          	add    $0x8,%rdx
  801aec:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801af0:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801af2:	85 db                	test   %ebx,%ebx
  801af4:	79 02                	jns    801af8 <vprintfmt+0x1ff>
				err = -err;
  801af6:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801af8:	83 fb 15             	cmp    $0x15,%ebx
  801afb:	7f 16                	jg     801b13 <vprintfmt+0x21a>
  801afd:	48 b8 c0 67 80 00 00 	movabs $0x8067c0,%rax
  801b04:	00 00 00 
  801b07:	48 63 d3             	movslq %ebx,%rdx
  801b0a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801b0e:	4d 85 e4             	test   %r12,%r12
  801b11:	75 2e                	jne    801b41 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  801b13:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801b17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b1b:	89 d9                	mov    %ebx,%ecx
  801b1d:	48 ba 81 68 80 00 00 	movabs $0x806881,%rdx
  801b24:	00 00 00 
  801b27:	48 89 c7             	mov    %rax,%rdi
  801b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2f:	49 b8 11 1e 80 00 00 	movabs $0x801e11,%r8
  801b36:	00 00 00 
  801b39:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b3c:	e9 c1 02 00 00       	jmpq   801e02 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801b41:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801b45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b49:	4c 89 e1             	mov    %r12,%rcx
  801b4c:	48 ba 8a 68 80 00 00 	movabs $0x80688a,%rdx
  801b53:	00 00 00 
  801b56:	48 89 c7             	mov    %rax,%rdi
  801b59:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5e:	49 b8 11 1e 80 00 00 	movabs $0x801e11,%r8
  801b65:	00 00 00 
  801b68:	41 ff d0             	callq  *%r8
			break;
  801b6b:	e9 92 02 00 00       	jmpq   801e02 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801b70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801b73:	83 f8 30             	cmp    $0x30,%eax
  801b76:	73 17                	jae    801b8f <vprintfmt+0x296>
  801b78:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801b7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801b7f:	89 c0                	mov    %eax,%eax
  801b81:	48 01 d0             	add    %rdx,%rax
  801b84:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801b87:	83 c2 08             	add    $0x8,%edx
  801b8a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801b8d:	eb 0f                	jmp    801b9e <vprintfmt+0x2a5>
  801b8f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801b93:	48 89 d0             	mov    %rdx,%rax
  801b96:	48 83 c2 08          	add    $0x8,%rdx
  801b9a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801b9e:	4c 8b 20             	mov    (%rax),%r12
  801ba1:	4d 85 e4             	test   %r12,%r12
  801ba4:	75 0a                	jne    801bb0 <vprintfmt+0x2b7>
				p = "(null)";
  801ba6:	49 bc 8d 68 80 00 00 	movabs $0x80688d,%r12
  801bad:	00 00 00 
			if (width > 0 && padc != '-')
  801bb0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801bb4:	7e 3f                	jle    801bf5 <vprintfmt+0x2fc>
  801bb6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801bba:	74 39                	je     801bf5 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bbc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801bbf:	48 98                	cltq   
  801bc1:	48 89 c6             	mov    %rax,%rsi
  801bc4:	4c 89 e7             	mov    %r12,%rdi
  801bc7:	48 b8 17 22 80 00 00 	movabs $0x802217,%rax
  801bce:	00 00 00 
  801bd1:	ff d0                	callq  *%rax
  801bd3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801bd6:	eb 17                	jmp    801bef <vprintfmt+0x2f6>
					putch(padc, putdat);
  801bd8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801bdc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801be0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801be4:	48 89 ce             	mov    %rcx,%rsi
  801be7:	89 d7                	mov    %edx,%edi
  801be9:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801beb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801bef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801bf3:	7f e3                	jg     801bd8 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801bf5:	eb 37                	jmp    801c2e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801bf7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801bfb:	74 1e                	je     801c1b <vprintfmt+0x322>
  801bfd:	83 fb 1f             	cmp    $0x1f,%ebx
  801c00:	7e 05                	jle    801c07 <vprintfmt+0x30e>
  801c02:	83 fb 7e             	cmp    $0x7e,%ebx
  801c05:	7e 14                	jle    801c1b <vprintfmt+0x322>
					putch('?', putdat);
  801c07:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c0f:	48 89 d6             	mov    %rdx,%rsi
  801c12:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801c17:	ff d0                	callq  *%rax
  801c19:	eb 0f                	jmp    801c2a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801c1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c23:	48 89 d6             	mov    %rdx,%rsi
  801c26:	89 df                	mov    %ebx,%edi
  801c28:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c2a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801c2e:	4c 89 e0             	mov    %r12,%rax
  801c31:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801c35:	0f b6 00             	movzbl (%rax),%eax
  801c38:	0f be d8             	movsbl %al,%ebx
  801c3b:	85 db                	test   %ebx,%ebx
  801c3d:	74 10                	je     801c4f <vprintfmt+0x356>
  801c3f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c43:	78 b2                	js     801bf7 <vprintfmt+0x2fe>
  801c45:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801c49:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c4d:	79 a8                	jns    801bf7 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c4f:	eb 16                	jmp    801c67 <vprintfmt+0x36e>
				putch(' ', putdat);
  801c51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c59:	48 89 d6             	mov    %rdx,%rsi
  801c5c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c61:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c63:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801c67:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801c6b:	7f e4                	jg     801c51 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801c6d:	e9 90 01 00 00       	jmpq   801e02 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801c72:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c76:	be 03 00 00 00       	mov    $0x3,%esi
  801c7b:	48 89 c7             	mov    %rax,%rdi
  801c7e:	48 b8 e9 17 80 00 00 	movabs $0x8017e9,%rax
  801c85:	00 00 00 
  801c88:	ff d0                	callq  *%rax
  801c8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c92:	48 85 c0             	test   %rax,%rax
  801c95:	79 1d                	jns    801cb4 <vprintfmt+0x3bb>
				putch('-', putdat);
  801c97:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c9f:	48 89 d6             	mov    %rdx,%rsi
  801ca2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801ca7:	ff d0                	callq  *%rax
				num = -(long long) num;
  801ca9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cad:	48 f7 d8             	neg    %rax
  801cb0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801cb4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801cbb:	e9 d5 00 00 00       	jmpq   801d95 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801cc0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801cc4:	be 03 00 00 00       	mov    $0x3,%esi
  801cc9:	48 89 c7             	mov    %rax,%rdi
  801ccc:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  801cd3:	00 00 00 
  801cd6:	ff d0                	callq  *%rax
  801cd8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801cdc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801ce3:	e9 ad 00 00 00       	jmpq   801d95 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  801ce8:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801ceb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801cef:	89 d6                	mov    %edx,%esi
  801cf1:	48 89 c7             	mov    %rax,%rdi
  801cf4:	48 b8 e9 17 80 00 00 	movabs $0x8017e9,%rax
  801cfb:	00 00 00 
  801cfe:	ff d0                	callq  *%rax
  801d00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801d04:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801d0b:	e9 85 00 00 00       	jmpq   801d95 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  801d10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d18:	48 89 d6             	mov    %rdx,%rsi
  801d1b:	bf 30 00 00 00       	mov    $0x30,%edi
  801d20:	ff d0                	callq  *%rax
			putch('x', putdat);
  801d22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d2a:	48 89 d6             	mov    %rdx,%rsi
  801d2d:	bf 78 00 00 00       	mov    $0x78,%edi
  801d32:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801d34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d37:	83 f8 30             	cmp    $0x30,%eax
  801d3a:	73 17                	jae    801d53 <vprintfmt+0x45a>
  801d3c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801d40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d43:	89 c0                	mov    %eax,%eax
  801d45:	48 01 d0             	add    %rdx,%rax
  801d48:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801d4b:	83 c2 08             	add    $0x8,%edx
  801d4e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d51:	eb 0f                	jmp    801d62 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801d53:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801d57:	48 89 d0             	mov    %rdx,%rax
  801d5a:	48 83 c2 08          	add    $0x8,%rdx
  801d5e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801d62:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801d69:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801d70:	eb 23                	jmp    801d95 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801d72:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801d76:	be 03 00 00 00       	mov    $0x3,%esi
  801d7b:	48 89 c7             	mov    %rax,%rdi
  801d7e:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  801d85:	00 00 00 
  801d88:	ff d0                	callq  *%rax
  801d8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801d8e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d95:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801d9a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801d9d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801da0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801da4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801da8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801dac:	45 89 c1             	mov    %r8d,%r9d
  801daf:	41 89 f8             	mov    %edi,%r8d
  801db2:	48 89 c7             	mov    %rax,%rdi
  801db5:	48 b8 1e 16 80 00 00 	movabs $0x80161e,%rax
  801dbc:	00 00 00 
  801dbf:	ff d0                	callq  *%rax
			break;
  801dc1:	eb 3f                	jmp    801e02 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801dc3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801dc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801dcb:	48 89 d6             	mov    %rdx,%rsi
  801dce:	89 df                	mov    %ebx,%edi
  801dd0:	ff d0                	callq  *%rax
			break;
  801dd2:	eb 2e                	jmp    801e02 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801dd4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801dd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ddc:	48 89 d6             	mov    %rdx,%rsi
  801ddf:	bf 25 00 00 00       	mov    $0x25,%edi
  801de4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801de6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801deb:	eb 05                	jmp    801df2 <vprintfmt+0x4f9>
  801ded:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801df2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801df6:	48 83 e8 01          	sub    $0x1,%rax
  801dfa:	0f b6 00             	movzbl (%rax),%eax
  801dfd:	3c 25                	cmp    $0x25,%al
  801dff:	75 ec                	jne    801ded <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801e01:	90                   	nop
		}
	}
  801e02:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801e03:	e9 43 fb ff ff       	jmpq   80194b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801e08:	48 83 c4 60          	add    $0x60,%rsp
  801e0c:	5b                   	pop    %rbx
  801e0d:	41 5c                	pop    %r12
  801e0f:	5d                   	pop    %rbp
  801e10:	c3                   	retq   

0000000000801e11 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e11:	55                   	push   %rbp
  801e12:	48 89 e5             	mov    %rsp,%rbp
  801e15:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801e1c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801e23:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801e2a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801e31:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801e38:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801e3f:	84 c0                	test   %al,%al
  801e41:	74 20                	je     801e63 <printfmt+0x52>
  801e43:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801e47:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801e4b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801e4f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801e53:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801e57:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801e5b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801e5f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801e63:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e6a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801e71:	00 00 00 
  801e74:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801e7b:	00 00 00 
  801e7e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e82:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801e89:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801e90:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801e97:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801e9e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801ea5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801eac:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801eb3:	48 89 c7             	mov    %rax,%rdi
  801eb6:	48 b8 f9 18 80 00 00 	movabs $0x8018f9,%rax
  801ebd:	00 00 00 
  801ec0:	ff d0                	callq  *%rax
	va_end(ap);
}
  801ec2:	c9                   	leaveq 
  801ec3:	c3                   	retq   

0000000000801ec4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ec4:	55                   	push   %rbp
  801ec5:	48 89 e5             	mov    %rsp,%rbp
  801ec8:	48 83 ec 10          	sub    $0x10,%rsp
  801ecc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ecf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed7:	8b 40 10             	mov    0x10(%rax),%eax
  801eda:	8d 50 01             	lea    0x1(%rax),%edx
  801edd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ee1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801ee4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ee8:	48 8b 10             	mov    (%rax),%rdx
  801eeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eef:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ef3:	48 39 c2             	cmp    %rax,%rdx
  801ef6:	73 17                	jae    801f0f <sprintputch+0x4b>
		*b->buf++ = ch;
  801ef8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801efc:	48 8b 00             	mov    (%rax),%rax
  801eff:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801f03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f07:	48 89 0a             	mov    %rcx,(%rdx)
  801f0a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f0d:	88 10                	mov    %dl,(%rax)
}
  801f0f:	c9                   	leaveq 
  801f10:	c3                   	retq   

0000000000801f11 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f11:	55                   	push   %rbp
  801f12:	48 89 e5             	mov    %rsp,%rbp
  801f15:	48 83 ec 50          	sub    $0x50,%rsp
  801f19:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801f1d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801f20:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801f24:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801f28:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801f2c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801f30:	48 8b 0a             	mov    (%rdx),%rcx
  801f33:	48 89 08             	mov    %rcx,(%rax)
  801f36:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f3a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f3e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f42:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f46:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f4a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801f4e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801f51:	48 98                	cltq   
  801f53:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801f57:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f5b:	48 01 d0             	add    %rdx,%rax
  801f5e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801f62:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801f69:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801f6e:	74 06                	je     801f76 <vsnprintf+0x65>
  801f70:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801f74:	7f 07                	jg     801f7d <vsnprintf+0x6c>
		return -E_INVAL;
  801f76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f7b:	eb 2f                	jmp    801fac <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801f7d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801f81:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801f85:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801f89:	48 89 c6             	mov    %rax,%rsi
  801f8c:	48 bf c4 1e 80 00 00 	movabs $0x801ec4,%rdi
  801f93:	00 00 00 
  801f96:	48 b8 f9 18 80 00 00 	movabs $0x8018f9,%rax
  801f9d:	00 00 00 
  801fa0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801fa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fa6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801fa9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801fac:	c9                   	leaveq 
  801fad:	c3                   	retq   

0000000000801fae <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801fae:	55                   	push   %rbp
  801faf:	48 89 e5             	mov    %rsp,%rbp
  801fb2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801fb9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801fc0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801fc6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801fcd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801fd4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801fdb:	84 c0                	test   %al,%al
  801fdd:	74 20                	je     801fff <snprintf+0x51>
  801fdf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801fe3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801fe7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801feb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801fef:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801ff3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801ff7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801ffb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801fff:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802006:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80200d:	00 00 00 
  802010:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802017:	00 00 00 
  80201a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80201e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802025:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80202c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802033:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80203a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802041:	48 8b 0a             	mov    (%rdx),%rcx
  802044:	48 89 08             	mov    %rcx,(%rax)
  802047:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80204b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80204f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802053:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802057:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80205e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802065:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80206b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802072:	48 89 c7             	mov    %rax,%rdi
  802075:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  80207c:	00 00 00 
  80207f:	ff d0                	callq  *%rax
  802081:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802087:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80208d:	c9                   	leaveq 
  80208e:	c3                   	retq   

000000000080208f <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  80208f:	55                   	push   %rbp
  802090:	48 89 e5             	mov    %rsp,%rbp
  802093:	48 83 ec 20          	sub    $0x20,%rsp
  802097:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80209b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8020a0:	74 27                	je     8020c9 <readline+0x3a>
		fprintf(1, "%s", prompt);
  8020a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a6:	48 89 c2             	mov    %rax,%rdx
  8020a9:	48 be 48 6b 80 00 00 	movabs $0x806b48,%rsi
  8020b0:	00 00 00 
  8020b3:	bf 01 00 00 00       	mov    $0x1,%edi
  8020b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bd:	48 b9 b2 49 80 00 00 	movabs $0x8049b2,%rcx
  8020c4:	00 00 00 
  8020c7:	ff d1                	callq  *%rcx
#endif

	i = 0;
  8020c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8020d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d5:	48 b8 28 10 80 00 00 	movabs $0x801028,%rax
  8020dc:	00 00 00 
  8020df:	ff d0                	callq  *%rax
  8020e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8020e4:	48 b8 df 0f 80 00 00 	movabs $0x800fdf,%rax
  8020eb:	00 00 00 
  8020ee:	ff d0                	callq  *%rax
  8020f0:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8020f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020f7:	79 30                	jns    802129 <readline+0x9a>
			if (c != -E_EOF)
  8020f9:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  8020fd:	74 20                	je     80211f <readline+0x90>
				cprintf("read error: %e\n", c);
  8020ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802102:	89 c6                	mov    %eax,%esi
  802104:	48 bf 4b 6b 80 00 00 	movabs $0x806b4b,%rdi
  80210b:	00 00 00 
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
  802113:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  80211a:	00 00 00 
  80211d:	ff d2                	callq  *%rdx
			return NULL;
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	e9 be 00 00 00       	jmpq   8021e7 <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  802129:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  80212d:	74 06                	je     802135 <readline+0xa6>
  80212f:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  802133:	75 26                	jne    80215b <readline+0xcc>
  802135:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802139:	7e 20                	jle    80215b <readline+0xcc>
			if (echoing)
  80213b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80213f:	74 11                	je     802152 <readline+0xc3>
				cputchar('\b');
  802141:	bf 08 00 00 00       	mov    $0x8,%edi
  802146:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  80214d:	00 00 00 
  802150:	ff d0                	callq  *%rax
			i--;
  802152:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  802156:	e9 87 00 00 00       	jmpq   8021e2 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80215b:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  80215f:	7e 3f                	jle    8021a0 <readline+0x111>
  802161:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  802168:	7f 36                	jg     8021a0 <readline+0x111>
			if (echoing)
  80216a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80216e:	74 11                	je     802181 <readline+0xf2>
				cputchar(c);
  802170:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802173:	89 c7                	mov    %eax,%edi
  802175:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  80217c:	00 00 00 
  80217f:	ff d0                	callq  *%rax
			buf[i++] = c;
  802181:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802184:	8d 50 01             	lea    0x1(%rax),%edx
  802187:	89 55 fc             	mov    %edx,-0x4(%rbp)
  80218a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80218d:	89 d1                	mov    %edx,%ecx
  80218f:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  802196:	00 00 00 
  802199:	48 98                	cltq   
  80219b:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  80219e:	eb 42                	jmp    8021e2 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8021a0:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8021a4:	74 06                	je     8021ac <readline+0x11d>
  8021a6:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8021aa:	75 36                	jne    8021e2 <readline+0x153>
			if (echoing)
  8021ac:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021b0:	74 11                	je     8021c3 <readline+0x134>
				cputchar('\n');
  8021b2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021b7:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  8021be:	00 00 00 
  8021c1:	ff d0                	callq  *%rax
			buf[i] = 0;
  8021c3:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  8021ca:	00 00 00 
  8021cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d0:	48 98                	cltq   
  8021d2:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8021d6:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8021dd:	00 00 00 
  8021e0:	eb 05                	jmp    8021e7 <readline+0x158>
		}
	}
  8021e2:	e9 fd fe ff ff       	jmpq   8020e4 <readline+0x55>
}
  8021e7:	c9                   	leaveq 
  8021e8:	c3                   	retq   

00000000008021e9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8021e9:	55                   	push   %rbp
  8021ea:	48 89 e5             	mov    %rsp,%rbp
  8021ed:	48 83 ec 18          	sub    $0x18,%rsp
  8021f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8021f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021fc:	eb 09                	jmp    802207 <strlen+0x1e>
		n++;
  8021fe:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802202:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802207:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220b:	0f b6 00             	movzbl (%rax),%eax
  80220e:	84 c0                	test   %al,%al
  802210:	75 ec                	jne    8021fe <strlen+0x15>
		n++;
	return n;
  802212:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802215:	c9                   	leaveq 
  802216:	c3                   	retq   

0000000000802217 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802217:	55                   	push   %rbp
  802218:	48 89 e5             	mov    %rsp,%rbp
  80221b:	48 83 ec 20          	sub    $0x20,%rsp
  80221f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802223:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802227:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80222e:	eb 0e                	jmp    80223e <strnlen+0x27>
		n++;
  802230:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802234:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802239:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80223e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802243:	74 0b                	je     802250 <strnlen+0x39>
  802245:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802249:	0f b6 00             	movzbl (%rax),%eax
  80224c:	84 c0                	test   %al,%al
  80224e:	75 e0                	jne    802230 <strnlen+0x19>
		n++;
	return n;
  802250:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802253:	c9                   	leaveq 
  802254:	c3                   	retq   

0000000000802255 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802255:	55                   	push   %rbp
  802256:	48 89 e5             	mov    %rsp,%rbp
  802259:	48 83 ec 20          	sub    $0x20,%rsp
  80225d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802261:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802269:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80226d:	90                   	nop
  80226e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802272:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802276:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80227a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80227e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802282:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802286:	0f b6 12             	movzbl (%rdx),%edx
  802289:	88 10                	mov    %dl,(%rax)
  80228b:	0f b6 00             	movzbl (%rax),%eax
  80228e:	84 c0                	test   %al,%al
  802290:	75 dc                	jne    80226e <strcpy+0x19>
		/* do nothing */;
	return ret;
  802292:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802296:	c9                   	leaveq 
  802297:	c3                   	retq   

0000000000802298 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802298:	55                   	push   %rbp
  802299:	48 89 e5             	mov    %rsp,%rbp
  80229c:	48 83 ec 20          	sub    $0x20,%rsp
  8022a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8022a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ac:	48 89 c7             	mov    %rax,%rdi
  8022af:	48 b8 e9 21 80 00 00 	movabs $0x8021e9,%rax
  8022b6:	00 00 00 
  8022b9:	ff d0                	callq  *%rax
  8022bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8022be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c1:	48 63 d0             	movslq %eax,%rdx
  8022c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c8:	48 01 c2             	add    %rax,%rdx
  8022cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022cf:	48 89 c6             	mov    %rax,%rsi
  8022d2:	48 89 d7             	mov    %rdx,%rdi
  8022d5:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  8022dc:	00 00 00 
  8022df:	ff d0                	callq  *%rax
	return dst;
  8022e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8022e5:	c9                   	leaveq 
  8022e6:	c3                   	retq   

00000000008022e7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8022e7:	55                   	push   %rbp
  8022e8:	48 89 e5             	mov    %rsp,%rbp
  8022eb:	48 83 ec 28          	sub    $0x28,%rsp
  8022ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8022fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802303:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80230a:	00 
  80230b:	eb 2a                	jmp    802337 <strncpy+0x50>
		*dst++ = *src;
  80230d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802311:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802315:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802319:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80231d:	0f b6 12             	movzbl (%rdx),%edx
  802320:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802322:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802326:	0f b6 00             	movzbl (%rax),%eax
  802329:	84 c0                	test   %al,%al
  80232b:	74 05                	je     802332 <strncpy+0x4b>
			src++;
  80232d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802332:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80233b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80233f:	72 cc                	jb     80230d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802341:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802345:	c9                   	leaveq 
  802346:	c3                   	retq   

0000000000802347 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802347:	55                   	push   %rbp
  802348:	48 89 e5             	mov    %rsp,%rbp
  80234b:	48 83 ec 28          	sub    $0x28,%rsp
  80234f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802353:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802357:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80235b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802363:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802368:	74 3d                	je     8023a7 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80236a:	eb 1d                	jmp    802389 <strlcpy+0x42>
			*dst++ = *src++;
  80236c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802370:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802374:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802378:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80237c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802380:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802384:	0f b6 12             	movzbl (%rdx),%edx
  802387:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802389:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80238e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802393:	74 0b                	je     8023a0 <strlcpy+0x59>
  802395:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802399:	0f b6 00             	movzbl (%rax),%eax
  80239c:	84 c0                	test   %al,%al
  80239e:	75 cc                	jne    80236c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8023a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a4:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8023a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023af:	48 29 c2             	sub    %rax,%rdx
  8023b2:	48 89 d0             	mov    %rdx,%rax
}
  8023b5:	c9                   	leaveq 
  8023b6:	c3                   	retq   

00000000008023b7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8023b7:	55                   	push   %rbp
  8023b8:	48 89 e5             	mov    %rsp,%rbp
  8023bb:	48 83 ec 10          	sub    $0x10,%rsp
  8023bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8023c7:	eb 0a                	jmp    8023d3 <strcmp+0x1c>
		p++, q++;
  8023c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023ce:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8023d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d7:	0f b6 00             	movzbl (%rax),%eax
  8023da:	84 c0                	test   %al,%al
  8023dc:	74 12                	je     8023f0 <strcmp+0x39>
  8023de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e2:	0f b6 10             	movzbl (%rax),%edx
  8023e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e9:	0f b6 00             	movzbl (%rax),%eax
  8023ec:	38 c2                	cmp    %al,%dl
  8023ee:	74 d9                	je     8023c9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8023f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f4:	0f b6 00             	movzbl (%rax),%eax
  8023f7:	0f b6 d0             	movzbl %al,%edx
  8023fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023fe:	0f b6 00             	movzbl (%rax),%eax
  802401:	0f b6 c0             	movzbl %al,%eax
  802404:	29 c2                	sub    %eax,%edx
  802406:	89 d0                	mov    %edx,%eax
}
  802408:	c9                   	leaveq 
  802409:	c3                   	retq   

000000000080240a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80240a:	55                   	push   %rbp
  80240b:	48 89 e5             	mov    %rsp,%rbp
  80240e:	48 83 ec 18          	sub    $0x18,%rsp
  802412:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802416:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80241a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80241e:	eb 0f                	jmp    80242f <strncmp+0x25>
		n--, p++, q++;
  802420:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802425:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80242a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80242f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802434:	74 1d                	je     802453 <strncmp+0x49>
  802436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80243a:	0f b6 00             	movzbl (%rax),%eax
  80243d:	84 c0                	test   %al,%al
  80243f:	74 12                	je     802453 <strncmp+0x49>
  802441:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802445:	0f b6 10             	movzbl (%rax),%edx
  802448:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244c:	0f b6 00             	movzbl (%rax),%eax
  80244f:	38 c2                	cmp    %al,%dl
  802451:	74 cd                	je     802420 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802453:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802458:	75 07                	jne    802461 <strncmp+0x57>
		return 0;
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	eb 18                	jmp    802479 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802461:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802465:	0f b6 00             	movzbl (%rax),%eax
  802468:	0f b6 d0             	movzbl %al,%edx
  80246b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246f:	0f b6 00             	movzbl (%rax),%eax
  802472:	0f b6 c0             	movzbl %al,%eax
  802475:	29 c2                	sub    %eax,%edx
  802477:	89 d0                	mov    %edx,%eax
}
  802479:	c9                   	leaveq 
  80247a:	c3                   	retq   

000000000080247b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80247b:	55                   	push   %rbp
  80247c:	48 89 e5             	mov    %rsp,%rbp
  80247f:	48 83 ec 0c          	sub    $0xc,%rsp
  802483:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802487:	89 f0                	mov    %esi,%eax
  802489:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80248c:	eb 17                	jmp    8024a5 <strchr+0x2a>
		if (*s == c)
  80248e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802492:	0f b6 00             	movzbl (%rax),%eax
  802495:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802498:	75 06                	jne    8024a0 <strchr+0x25>
			return (char *) s;
  80249a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80249e:	eb 15                	jmp    8024b5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8024a0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8024a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a9:	0f b6 00             	movzbl (%rax),%eax
  8024ac:	84 c0                	test   %al,%al
  8024ae:	75 de                	jne    80248e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8024b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b5:	c9                   	leaveq 
  8024b6:	c3                   	retq   

00000000008024b7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8024b7:	55                   	push   %rbp
  8024b8:	48 89 e5             	mov    %rsp,%rbp
  8024bb:	48 83 ec 0c          	sub    $0xc,%rsp
  8024bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024c3:	89 f0                	mov    %esi,%eax
  8024c5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8024c8:	eb 13                	jmp    8024dd <strfind+0x26>
		if (*s == c)
  8024ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ce:	0f b6 00             	movzbl (%rax),%eax
  8024d1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8024d4:	75 02                	jne    8024d8 <strfind+0x21>
			break;
  8024d6:	eb 10                	jmp    8024e8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8024d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8024dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e1:	0f b6 00             	movzbl (%rax),%eax
  8024e4:	84 c0                	test   %al,%al
  8024e6:	75 e2                	jne    8024ca <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8024e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8024ec:	c9                   	leaveq 
  8024ed:	c3                   	retq   

00000000008024ee <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8024ee:	55                   	push   %rbp
  8024ef:	48 89 e5             	mov    %rsp,%rbp
  8024f2:	48 83 ec 18          	sub    $0x18,%rsp
  8024f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024fa:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8024fd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802501:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802506:	75 06                	jne    80250e <memset+0x20>
		return v;
  802508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80250c:	eb 69                	jmp    802577 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80250e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802512:	83 e0 03             	and    $0x3,%eax
  802515:	48 85 c0             	test   %rax,%rax
  802518:	75 48                	jne    802562 <memset+0x74>
  80251a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251e:	83 e0 03             	and    $0x3,%eax
  802521:	48 85 c0             	test   %rax,%rax
  802524:	75 3c                	jne    802562 <memset+0x74>
		c &= 0xFF;
  802526:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80252d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802530:	c1 e0 18             	shl    $0x18,%eax
  802533:	89 c2                	mov    %eax,%edx
  802535:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802538:	c1 e0 10             	shl    $0x10,%eax
  80253b:	09 c2                	or     %eax,%edx
  80253d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802540:	c1 e0 08             	shl    $0x8,%eax
  802543:	09 d0                	or     %edx,%eax
  802545:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254c:	48 c1 e8 02          	shr    $0x2,%rax
  802550:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802553:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802557:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80255a:	48 89 d7             	mov    %rdx,%rdi
  80255d:	fc                   	cld    
  80255e:	f3 ab                	rep stos %eax,%es:(%rdi)
  802560:	eb 11                	jmp    802573 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802562:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802566:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802569:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80256d:	48 89 d7             	mov    %rdx,%rdi
  802570:	fc                   	cld    
  802571:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802573:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802577:	c9                   	leaveq 
  802578:	c3                   	retq   

0000000000802579 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802579:	55                   	push   %rbp
  80257a:	48 89 e5             	mov    %rsp,%rbp
  80257d:	48 83 ec 28          	sub    $0x28,%rsp
  802581:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802585:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802589:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80258d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802591:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802599:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80259d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025a1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8025a5:	0f 83 88 00 00 00    	jae    802633 <memmove+0xba>
  8025ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025b3:	48 01 d0             	add    %rdx,%rax
  8025b6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8025ba:	76 77                	jbe    802633 <memmove+0xba>
		s += n;
  8025bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8025c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c8:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8025cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025d0:	83 e0 03             	and    $0x3,%eax
  8025d3:	48 85 c0             	test   %rax,%rax
  8025d6:	75 3b                	jne    802613 <memmove+0x9a>
  8025d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025dc:	83 e0 03             	and    $0x3,%eax
  8025df:	48 85 c0             	test   %rax,%rax
  8025e2:	75 2f                	jne    802613 <memmove+0x9a>
  8025e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025e8:	83 e0 03             	and    $0x3,%eax
  8025eb:	48 85 c0             	test   %rax,%rax
  8025ee:	75 23                	jne    802613 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8025f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f4:	48 83 e8 04          	sub    $0x4,%rax
  8025f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025fc:	48 83 ea 04          	sub    $0x4,%rdx
  802600:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802604:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802608:	48 89 c7             	mov    %rax,%rdi
  80260b:	48 89 d6             	mov    %rdx,%rsi
  80260e:	fd                   	std    
  80260f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802611:	eb 1d                	jmp    802630 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802613:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802617:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80261b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80261f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802627:	48 89 d7             	mov    %rdx,%rdi
  80262a:	48 89 c1             	mov    %rax,%rcx
  80262d:	fd                   	std    
  80262e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802630:	fc                   	cld    
  802631:	eb 57                	jmp    80268a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802633:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802637:	83 e0 03             	and    $0x3,%eax
  80263a:	48 85 c0             	test   %rax,%rax
  80263d:	75 36                	jne    802675 <memmove+0xfc>
  80263f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802643:	83 e0 03             	and    $0x3,%eax
  802646:	48 85 c0             	test   %rax,%rax
  802649:	75 2a                	jne    802675 <memmove+0xfc>
  80264b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80264f:	83 e0 03             	and    $0x3,%eax
  802652:	48 85 c0             	test   %rax,%rax
  802655:	75 1e                	jne    802675 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802657:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80265b:	48 c1 e8 02          	shr    $0x2,%rax
  80265f:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802666:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80266a:	48 89 c7             	mov    %rax,%rdi
  80266d:	48 89 d6             	mov    %rdx,%rsi
  802670:	fc                   	cld    
  802671:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802673:	eb 15                	jmp    80268a <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802679:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80267d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802681:	48 89 c7             	mov    %rax,%rdi
  802684:	48 89 d6             	mov    %rdx,%rsi
  802687:	fc                   	cld    
  802688:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80268a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80268e:	c9                   	leaveq 
  80268f:	c3                   	retq   

0000000000802690 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802690:	55                   	push   %rbp
  802691:	48 89 e5             	mov    %rsp,%rbp
  802694:	48 83 ec 18          	sub    $0x18,%rsp
  802698:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80269c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8026a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8026a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026a8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8026ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026b0:	48 89 ce             	mov    %rcx,%rsi
  8026b3:	48 89 c7             	mov    %rax,%rdi
  8026b6:	48 b8 79 25 80 00 00 	movabs $0x802579,%rax
  8026bd:	00 00 00 
  8026c0:	ff d0                	callq  *%rax
}
  8026c2:	c9                   	leaveq 
  8026c3:	c3                   	retq   

00000000008026c4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8026c4:	55                   	push   %rbp
  8026c5:	48 89 e5             	mov    %rsp,%rbp
  8026c8:	48 83 ec 28          	sub    $0x28,%rsp
  8026cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8026d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8026e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8026e8:	eb 36                	jmp    802720 <memcmp+0x5c>
		if (*s1 != *s2)
  8026ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026ee:	0f b6 10             	movzbl (%rax),%edx
  8026f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f5:	0f b6 00             	movzbl (%rax),%eax
  8026f8:	38 c2                	cmp    %al,%dl
  8026fa:	74 1a                	je     802716 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8026fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802700:	0f b6 00             	movzbl (%rax),%eax
  802703:	0f b6 d0             	movzbl %al,%edx
  802706:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80270a:	0f b6 00             	movzbl (%rax),%eax
  80270d:	0f b6 c0             	movzbl %al,%eax
  802710:	29 c2                	sub    %eax,%edx
  802712:	89 d0                	mov    %edx,%eax
  802714:	eb 20                	jmp    802736 <memcmp+0x72>
		s1++, s2++;
  802716:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80271b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802720:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802724:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802728:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80272c:	48 85 c0             	test   %rax,%rax
  80272f:	75 b9                	jne    8026ea <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802736:	c9                   	leaveq 
  802737:	c3                   	retq   

0000000000802738 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802738:	55                   	push   %rbp
  802739:	48 89 e5             	mov    %rsp,%rbp
  80273c:	48 83 ec 28          	sub    $0x28,%rsp
  802740:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802744:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802747:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80274b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80274f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802753:	48 01 d0             	add    %rdx,%rax
  802756:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80275a:	eb 15                	jmp    802771 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80275c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802760:	0f b6 10             	movzbl (%rax),%edx
  802763:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802766:	38 c2                	cmp    %al,%dl
  802768:	75 02                	jne    80276c <memfind+0x34>
			break;
  80276a:	eb 0f                	jmp    80277b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80276c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802775:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802779:	72 e1                	jb     80275c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80277b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80277f:	c9                   	leaveq 
  802780:	c3                   	retq   

0000000000802781 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802781:	55                   	push   %rbp
  802782:	48 89 e5             	mov    %rsp,%rbp
  802785:	48 83 ec 34          	sub    $0x34,%rsp
  802789:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80278d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802791:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  802794:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80279b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8027a2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027a3:	eb 05                	jmp    8027aa <strtol+0x29>
		s++;
  8027a5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ae:	0f b6 00             	movzbl (%rax),%eax
  8027b1:	3c 20                	cmp    $0x20,%al
  8027b3:	74 f0                	je     8027a5 <strtol+0x24>
  8027b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b9:	0f b6 00             	movzbl (%rax),%eax
  8027bc:	3c 09                	cmp    $0x9,%al
  8027be:	74 e5                	je     8027a5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8027c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c4:	0f b6 00             	movzbl (%rax),%eax
  8027c7:	3c 2b                	cmp    $0x2b,%al
  8027c9:	75 07                	jne    8027d2 <strtol+0x51>
		s++;
  8027cb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027d0:	eb 17                	jmp    8027e9 <strtol+0x68>
	else if (*s == '-')
  8027d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d6:	0f b6 00             	movzbl (%rax),%eax
  8027d9:	3c 2d                	cmp    $0x2d,%al
  8027db:	75 0c                	jne    8027e9 <strtol+0x68>
		s++, neg = 1;
  8027dd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8027e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8027ed:	74 06                	je     8027f5 <strtol+0x74>
  8027ef:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8027f3:	75 28                	jne    80281d <strtol+0x9c>
  8027f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f9:	0f b6 00             	movzbl (%rax),%eax
  8027fc:	3c 30                	cmp    $0x30,%al
  8027fe:	75 1d                	jne    80281d <strtol+0x9c>
  802800:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802804:	48 83 c0 01          	add    $0x1,%rax
  802808:	0f b6 00             	movzbl (%rax),%eax
  80280b:	3c 78                	cmp    $0x78,%al
  80280d:	75 0e                	jne    80281d <strtol+0x9c>
		s += 2, base = 16;
  80280f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802814:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80281b:	eb 2c                	jmp    802849 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80281d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802821:	75 19                	jne    80283c <strtol+0xbb>
  802823:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802827:	0f b6 00             	movzbl (%rax),%eax
  80282a:	3c 30                	cmp    $0x30,%al
  80282c:	75 0e                	jne    80283c <strtol+0xbb>
		s++, base = 8;
  80282e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802833:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80283a:	eb 0d                	jmp    802849 <strtol+0xc8>
	else if (base == 0)
  80283c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802840:	75 07                	jne    802849 <strtol+0xc8>
		base = 10;
  802842:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802849:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284d:	0f b6 00             	movzbl (%rax),%eax
  802850:	3c 2f                	cmp    $0x2f,%al
  802852:	7e 1d                	jle    802871 <strtol+0xf0>
  802854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802858:	0f b6 00             	movzbl (%rax),%eax
  80285b:	3c 39                	cmp    $0x39,%al
  80285d:	7f 12                	jg     802871 <strtol+0xf0>
			dig = *s - '0';
  80285f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802863:	0f b6 00             	movzbl (%rax),%eax
  802866:	0f be c0             	movsbl %al,%eax
  802869:	83 e8 30             	sub    $0x30,%eax
  80286c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80286f:	eb 4e                	jmp    8028bf <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802875:	0f b6 00             	movzbl (%rax),%eax
  802878:	3c 60                	cmp    $0x60,%al
  80287a:	7e 1d                	jle    802899 <strtol+0x118>
  80287c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802880:	0f b6 00             	movzbl (%rax),%eax
  802883:	3c 7a                	cmp    $0x7a,%al
  802885:	7f 12                	jg     802899 <strtol+0x118>
			dig = *s - 'a' + 10;
  802887:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80288b:	0f b6 00             	movzbl (%rax),%eax
  80288e:	0f be c0             	movsbl %al,%eax
  802891:	83 e8 57             	sub    $0x57,%eax
  802894:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802897:	eb 26                	jmp    8028bf <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289d:	0f b6 00             	movzbl (%rax),%eax
  8028a0:	3c 40                	cmp    $0x40,%al
  8028a2:	7e 48                	jle    8028ec <strtol+0x16b>
  8028a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a8:	0f b6 00             	movzbl (%rax),%eax
  8028ab:	3c 5a                	cmp    $0x5a,%al
  8028ad:	7f 3d                	jg     8028ec <strtol+0x16b>
			dig = *s - 'A' + 10;
  8028af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b3:	0f b6 00             	movzbl (%rax),%eax
  8028b6:	0f be c0             	movsbl %al,%eax
  8028b9:	83 e8 37             	sub    $0x37,%eax
  8028bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8028bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028c2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8028c5:	7c 02                	jl     8028c9 <strtol+0x148>
			break;
  8028c7:	eb 23                	jmp    8028ec <strtol+0x16b>
		s++, val = (val * base) + dig;
  8028c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8028ce:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8028d1:	48 98                	cltq   
  8028d3:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8028d8:	48 89 c2             	mov    %rax,%rdx
  8028db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028de:	48 98                	cltq   
  8028e0:	48 01 d0             	add    %rdx,%rax
  8028e3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8028e7:	e9 5d ff ff ff       	jmpq   802849 <strtol+0xc8>

	if (endptr)
  8028ec:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8028f1:	74 0b                	je     8028fe <strtol+0x17d>
		*endptr = (char *) s;
  8028f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028f7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028fb:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8028fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802902:	74 09                	je     80290d <strtol+0x18c>
  802904:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802908:	48 f7 d8             	neg    %rax
  80290b:	eb 04                	jmp    802911 <strtol+0x190>
  80290d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802911:	c9                   	leaveq 
  802912:	c3                   	retq   

0000000000802913 <strstr>:

char * strstr(const char *in, const char *str)
{
  802913:	55                   	push   %rbp
  802914:	48 89 e5             	mov    %rsp,%rbp
  802917:	48 83 ec 30          	sub    $0x30,%rsp
  80291b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80291f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  802923:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802927:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80292b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80292f:	0f b6 00             	movzbl (%rax),%eax
  802932:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  802935:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802939:	75 06                	jne    802941 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80293b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80293f:	eb 6b                	jmp    8029ac <strstr+0x99>

	len = strlen(str);
  802941:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802945:	48 89 c7             	mov    %rax,%rdi
  802948:	48 b8 e9 21 80 00 00 	movabs $0x8021e9,%rax
  80294f:	00 00 00 
  802952:	ff d0                	callq  *%rax
  802954:	48 98                	cltq   
  802956:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80295a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80295e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802962:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802966:	0f b6 00             	movzbl (%rax),%eax
  802969:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80296c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802970:	75 07                	jne    802979 <strstr+0x66>
				return (char *) 0;
  802972:	b8 00 00 00 00       	mov    $0x0,%eax
  802977:	eb 33                	jmp    8029ac <strstr+0x99>
		} while (sc != c);
  802979:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80297d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802980:	75 d8                	jne    80295a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  802982:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802986:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80298a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80298e:	48 89 ce             	mov    %rcx,%rsi
  802991:	48 89 c7             	mov    %rax,%rdi
  802994:	48 b8 0a 24 80 00 00 	movabs $0x80240a,%rax
  80299b:	00 00 00 
  80299e:	ff d0                	callq  *%rax
  8029a0:	85 c0                	test   %eax,%eax
  8029a2:	75 b6                	jne    80295a <strstr+0x47>

	return (char *) (in - 1);
  8029a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a8:	48 83 e8 01          	sub    $0x1,%rax
}
  8029ac:	c9                   	leaveq 
  8029ad:	c3                   	retq   

00000000008029ae <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8029ae:	55                   	push   %rbp
  8029af:	48 89 e5             	mov    %rsp,%rbp
  8029b2:	53                   	push   %rbx
  8029b3:	48 83 ec 48          	sub    $0x48,%rsp
  8029b7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029ba:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8029bd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8029c1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8029c5:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8029c9:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029cd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029d0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8029d4:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8029d8:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8029dc:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8029e0:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8029e4:	4c 89 c3             	mov    %r8,%rbx
  8029e7:	cd 30                	int    $0x30
  8029e9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8029ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8029f1:	74 3e                	je     802a31 <syscall+0x83>
  8029f3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029f8:	7e 37                	jle    802a31 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8029fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029fe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a01:	49 89 d0             	mov    %rdx,%r8
  802a04:	89 c1                	mov    %eax,%ecx
  802a06:	48 ba 5b 6b 80 00 00 	movabs $0x806b5b,%rdx
  802a0d:	00 00 00 
  802a10:	be 23 00 00 00       	mov    $0x23,%esi
  802a15:	48 bf 78 6b 80 00 00 	movabs $0x806b78,%rdi
  802a1c:	00 00 00 
  802a1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a24:	49 b9 0d 13 80 00 00 	movabs $0x80130d,%r9
  802a2b:	00 00 00 
  802a2e:	41 ff d1             	callq  *%r9

	return ret;
  802a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802a35:	48 83 c4 48          	add    $0x48,%rsp
  802a39:	5b                   	pop    %rbx
  802a3a:	5d                   	pop    %rbp
  802a3b:	c3                   	retq   

0000000000802a3c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802a3c:	55                   	push   %rbp
  802a3d:	48 89 e5             	mov    %rsp,%rbp
  802a40:	48 83 ec 20          	sub    $0x20,%rsp
  802a44:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a48:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802a4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a54:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a5b:	00 
  802a5c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a62:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a68:	48 89 d1             	mov    %rdx,%rcx
  802a6b:	48 89 c2             	mov    %rax,%rdx
  802a6e:	be 00 00 00 00       	mov    $0x0,%esi
  802a73:	bf 00 00 00 00       	mov    $0x0,%edi
  802a78:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802a7f:	00 00 00 
  802a82:	ff d0                	callq  *%rax
}
  802a84:	c9                   	leaveq 
  802a85:	c3                   	retq   

0000000000802a86 <sys_cgetc>:

int
sys_cgetc(void)
{
  802a86:	55                   	push   %rbp
  802a87:	48 89 e5             	mov    %rsp,%rbp
  802a8a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802a8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a95:	00 
  802a96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802aa2:	b9 00 00 00 00       	mov    $0x0,%ecx
  802aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  802aac:	be 00 00 00 00       	mov    $0x0,%esi
  802ab1:	bf 01 00 00 00       	mov    $0x1,%edi
  802ab6:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802abd:	00 00 00 
  802ac0:	ff d0                	callq  *%rax
}
  802ac2:	c9                   	leaveq 
  802ac3:	c3                   	retq   

0000000000802ac4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802ac4:	55                   	push   %rbp
  802ac5:	48 89 e5             	mov    %rsp,%rbp
  802ac8:	48 83 ec 10          	sub    $0x10,%rsp
  802acc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802acf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad2:	48 98                	cltq   
  802ad4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802adb:	00 
  802adc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ae2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ae8:	b9 00 00 00 00       	mov    $0x0,%ecx
  802aed:	48 89 c2             	mov    %rax,%rdx
  802af0:	be 01 00 00 00       	mov    $0x1,%esi
  802af5:	bf 03 00 00 00       	mov    $0x3,%edi
  802afa:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802b01:	00 00 00 
  802b04:	ff d0                	callq  *%rax
}
  802b06:	c9                   	leaveq 
  802b07:	c3                   	retq   

0000000000802b08 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802b08:	55                   	push   %rbp
  802b09:	48 89 e5             	mov    %rsp,%rbp
  802b0c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802b10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b17:	00 
  802b18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b24:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b29:	ba 00 00 00 00       	mov    $0x0,%edx
  802b2e:	be 00 00 00 00       	mov    $0x0,%esi
  802b33:	bf 02 00 00 00       	mov    $0x2,%edi
  802b38:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
}
  802b44:	c9                   	leaveq 
  802b45:	c3                   	retq   

0000000000802b46 <sys_yield>:

void
sys_yield(void)
{
  802b46:	55                   	push   %rbp
  802b47:	48 89 e5             	mov    %rsp,%rbp
  802b4a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802b4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b55:	00 
  802b56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b62:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b67:	ba 00 00 00 00       	mov    $0x0,%edx
  802b6c:	be 00 00 00 00       	mov    $0x0,%esi
  802b71:	bf 0b 00 00 00       	mov    $0xb,%edi
  802b76:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802b7d:	00 00 00 
  802b80:	ff d0                	callq  *%rax
}
  802b82:	c9                   	leaveq 
  802b83:	c3                   	retq   

0000000000802b84 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802b84:	55                   	push   %rbp
  802b85:	48 89 e5             	mov    %rsp,%rbp
  802b88:	48 83 ec 20          	sub    $0x20,%rsp
  802b8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b93:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802b96:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b99:	48 63 c8             	movslq %eax,%rcx
  802b9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ba0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba3:	48 98                	cltq   
  802ba5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bac:	00 
  802bad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bb3:	49 89 c8             	mov    %rcx,%r8
  802bb6:	48 89 d1             	mov    %rdx,%rcx
  802bb9:	48 89 c2             	mov    %rax,%rdx
  802bbc:	be 01 00 00 00       	mov    $0x1,%esi
  802bc1:	bf 04 00 00 00       	mov    $0x4,%edi
  802bc6:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802bcd:	00 00 00 
  802bd0:	ff d0                	callq  *%rax
}
  802bd2:	c9                   	leaveq 
  802bd3:	c3                   	retq   

0000000000802bd4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802bd4:	55                   	push   %rbp
  802bd5:	48 89 e5             	mov    %rsp,%rbp
  802bd8:	48 83 ec 30          	sub    $0x30,%rsp
  802bdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802be3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802be6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802bea:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802bee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802bf1:	48 63 c8             	movslq %eax,%rcx
  802bf4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802bf8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bfb:	48 63 f0             	movslq %eax,%rsi
  802bfe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c05:	48 98                	cltq   
  802c07:	48 89 0c 24          	mov    %rcx,(%rsp)
  802c0b:	49 89 f9             	mov    %rdi,%r9
  802c0e:	49 89 f0             	mov    %rsi,%r8
  802c11:	48 89 d1             	mov    %rdx,%rcx
  802c14:	48 89 c2             	mov    %rax,%rdx
  802c17:	be 01 00 00 00       	mov    $0x1,%esi
  802c1c:	bf 05 00 00 00       	mov    $0x5,%edi
  802c21:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802c28:	00 00 00 
  802c2b:	ff d0                	callq  *%rax
}
  802c2d:	c9                   	leaveq 
  802c2e:	c3                   	retq   

0000000000802c2f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802c2f:	55                   	push   %rbp
  802c30:	48 89 e5             	mov    %rsp,%rbp
  802c33:	48 83 ec 20          	sub    $0x20,%rsp
  802c37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802c3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c45:	48 98                	cltq   
  802c47:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c4e:	00 
  802c4f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c55:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c5b:	48 89 d1             	mov    %rdx,%rcx
  802c5e:	48 89 c2             	mov    %rax,%rdx
  802c61:	be 01 00 00 00       	mov    $0x1,%esi
  802c66:	bf 06 00 00 00       	mov    $0x6,%edi
  802c6b:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
}
  802c77:	c9                   	leaveq 
  802c78:	c3                   	retq   

0000000000802c79 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802c79:	55                   	push   %rbp
  802c7a:	48 89 e5             	mov    %rsp,%rbp
  802c7d:	48 83 ec 10          	sub    $0x10,%rsp
  802c81:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c84:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802c87:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c8a:	48 63 d0             	movslq %eax,%rdx
  802c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c90:	48 98                	cltq   
  802c92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c99:	00 
  802c9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ca0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ca6:	48 89 d1             	mov    %rdx,%rcx
  802ca9:	48 89 c2             	mov    %rax,%rdx
  802cac:	be 01 00 00 00       	mov    $0x1,%esi
  802cb1:	bf 08 00 00 00       	mov    $0x8,%edi
  802cb6:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
}
  802cc2:	c9                   	leaveq 
  802cc3:	c3                   	retq   

0000000000802cc4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802cc4:	55                   	push   %rbp
  802cc5:	48 89 e5             	mov    %rsp,%rbp
  802cc8:	48 83 ec 20          	sub    $0x20,%rsp
  802ccc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ccf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802cd3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cda:	48 98                	cltq   
  802cdc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ce3:	00 
  802ce4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802cea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802cf0:	48 89 d1             	mov    %rdx,%rcx
  802cf3:	48 89 c2             	mov    %rax,%rdx
  802cf6:	be 01 00 00 00       	mov    $0x1,%esi
  802cfb:	bf 09 00 00 00       	mov    $0x9,%edi
  802d00:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802d07:	00 00 00 
  802d0a:	ff d0                	callq  *%rax
}
  802d0c:	c9                   	leaveq 
  802d0d:	c3                   	retq   

0000000000802d0e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802d0e:	55                   	push   %rbp
  802d0f:	48 89 e5             	mov    %rsp,%rbp
  802d12:	48 83 ec 20          	sub    $0x20,%rsp
  802d16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802d1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d24:	48 98                	cltq   
  802d26:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d2d:	00 
  802d2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d3a:	48 89 d1             	mov    %rdx,%rcx
  802d3d:	48 89 c2             	mov    %rax,%rdx
  802d40:	be 01 00 00 00       	mov    $0x1,%esi
  802d45:	bf 0a 00 00 00       	mov    $0xa,%edi
  802d4a:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802d51:	00 00 00 
  802d54:	ff d0                	callq  *%rax
}
  802d56:	c9                   	leaveq 
  802d57:	c3                   	retq   

0000000000802d58 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802d58:	55                   	push   %rbp
  802d59:	48 89 e5             	mov    %rsp,%rbp
  802d5c:	48 83 ec 20          	sub    $0x20,%rsp
  802d60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d67:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d6b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802d6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d71:	48 63 f0             	movslq %eax,%rsi
  802d74:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7b:	48 98                	cltq   
  802d7d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d88:	00 
  802d89:	49 89 f1             	mov    %rsi,%r9
  802d8c:	49 89 c8             	mov    %rcx,%r8
  802d8f:	48 89 d1             	mov    %rdx,%rcx
  802d92:	48 89 c2             	mov    %rax,%rdx
  802d95:	be 00 00 00 00       	mov    $0x0,%esi
  802d9a:	bf 0c 00 00 00       	mov    $0xc,%edi
  802d9f:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802da6:	00 00 00 
  802da9:	ff d0                	callq  *%rax
}
  802dab:	c9                   	leaveq 
  802dac:	c3                   	retq   

0000000000802dad <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802dad:	55                   	push   %rbp
  802dae:	48 89 e5             	mov    %rsp,%rbp
  802db1:	48 83 ec 10          	sub    $0x10,%rsp
  802db5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802db9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dbd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802dc4:	00 
  802dc5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802dcb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802dd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  802dd6:	48 89 c2             	mov    %rax,%rdx
  802dd9:	be 01 00 00 00       	mov    $0x1,%esi
  802dde:	bf 0d 00 00 00       	mov    $0xd,%edi
  802de3:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
}
  802def:	c9                   	leaveq 
  802df0:	c3                   	retq   

0000000000802df1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802df1:	55                   	push   %rbp
  802df2:	48 89 e5             	mov    %rsp,%rbp
  802df5:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802df9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802e00:	00 
  802e01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802e07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802e0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e12:	ba 00 00 00 00       	mov    $0x0,%edx
  802e17:	be 00 00 00 00       	mov    $0x0,%esi
  802e1c:	bf 0e 00 00 00       	mov    $0xe,%edi
  802e21:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802e28:	00 00 00 
  802e2b:	ff d0                	callq  *%rax
}
  802e2d:	c9                   	leaveq 
  802e2e:	c3                   	retq   

0000000000802e2f <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802e2f:	55                   	push   %rbp
  802e30:	48 89 e5             	mov    %rsp,%rbp
  802e33:	48 83 ec 30          	sub    $0x30,%rsp
  802e37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e3e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802e41:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802e45:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802e49:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e4c:	48 63 c8             	movslq %eax,%rcx
  802e4f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802e53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e56:	48 63 f0             	movslq %eax,%rsi
  802e59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e60:	48 98                	cltq   
  802e62:	48 89 0c 24          	mov    %rcx,(%rsp)
  802e66:	49 89 f9             	mov    %rdi,%r9
  802e69:	49 89 f0             	mov    %rsi,%r8
  802e6c:	48 89 d1             	mov    %rdx,%rcx
  802e6f:	48 89 c2             	mov    %rax,%rdx
  802e72:	be 00 00 00 00       	mov    $0x0,%esi
  802e77:	bf 0f 00 00 00       	mov    $0xf,%edi
  802e7c:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802e83:	00 00 00 
  802e86:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802e88:	c9                   	leaveq 
  802e89:	c3                   	retq   

0000000000802e8a <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802e8a:	55                   	push   %rbp
  802e8b:	48 89 e5             	mov    %rsp,%rbp
  802e8e:	48 83 ec 20          	sub    $0x20,%rsp
  802e92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e96:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802e9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ea9:	00 
  802eaa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802eb0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802eb6:	48 89 d1             	mov    %rdx,%rcx
  802eb9:	48 89 c2             	mov    %rax,%rdx
  802ebc:	be 00 00 00 00       	mov    $0x0,%esi
  802ec1:	bf 10 00 00 00       	mov    $0x10,%edi
  802ec6:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	callq  *%rax
}
  802ed2:	c9                   	leaveq 
  802ed3:	c3                   	retq   

0000000000802ed4 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802ed4:	55                   	push   %rbp
  802ed5:	48 89 e5             	mov    %rsp,%rbp
  802ed8:	48 83 ec 30          	sub    $0x30,%rsp
  802edc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802ee0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee4:	48 8b 00             	mov    (%rax),%rax
  802ee7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802eeb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eef:	48 8b 40 08          	mov    0x8(%rax),%rax
  802ef3:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  802ef6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ef9:	83 e0 02             	and    $0x2,%eax
  802efc:	85 c0                	test   %eax,%eax
  802efe:	75 4d                	jne    802f4d <pgfault+0x79>
  802f00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f04:	48 c1 e8 0c          	shr    $0xc,%rax
  802f08:	48 89 c2             	mov    %rax,%rdx
  802f0b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f12:	01 00 00 
  802f15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f19:	25 00 08 00 00       	and    $0x800,%eax
  802f1e:	48 85 c0             	test   %rax,%rax
  802f21:	74 2a                	je     802f4d <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  802f23:	48 ba 88 6b 80 00 00 	movabs $0x806b88,%rdx
  802f2a:	00 00 00 
  802f2d:	be 23 00 00 00       	mov    $0x23,%esi
  802f32:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  802f39:	00 00 00 
  802f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f41:	48 b9 0d 13 80 00 00 	movabs $0x80130d,%rcx
  802f48:	00 00 00 
  802f4b:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  802f4d:	ba 07 00 00 00       	mov    $0x7,%edx
  802f52:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802f57:	bf 00 00 00 00       	mov    $0x0,%edi
  802f5c:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  802f63:	00 00 00 
  802f66:	ff d0                	callq  *%rax
  802f68:	85 c0                	test   %eax,%eax
  802f6a:	0f 85 cd 00 00 00    	jne    80303d <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  802f70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802f78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802f82:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802f86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f8a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f8f:	48 89 c6             	mov    %rax,%rsi
  802f92:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802f97:	48 b8 79 25 80 00 00 	movabs $0x802579,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802fa3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fa7:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802fad:	48 89 c1             	mov    %rax,%rcx
  802fb0:	ba 00 00 00 00       	mov    $0x0,%edx
  802fb5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802fba:	bf 00 00 00 00       	mov    $0x0,%edi
  802fbf:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  802fc6:	00 00 00 
  802fc9:	ff d0                	callq  *%rax
  802fcb:	85 c0                	test   %eax,%eax
  802fcd:	79 2a                	jns    802ff9 <pgfault+0x125>
				panic("Page map at temp address failed");
  802fcf:	48 ba c8 6b 80 00 00 	movabs $0x806bc8,%rdx
  802fd6:	00 00 00 
  802fd9:	be 30 00 00 00       	mov    $0x30,%esi
  802fde:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  802fe5:	00 00 00 
  802fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fed:	48 b9 0d 13 80 00 00 	movabs $0x80130d,%rcx
  802ff4:	00 00 00 
  802ff7:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802ff9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802ffe:	bf 00 00 00 00       	mov    $0x0,%edi
  803003:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  80300a:	00 00 00 
  80300d:	ff d0                	callq  *%rax
  80300f:	85 c0                	test   %eax,%eax
  803011:	79 54                	jns    803067 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  803013:	48 ba e8 6b 80 00 00 	movabs $0x806be8,%rdx
  80301a:	00 00 00 
  80301d:	be 32 00 00 00       	mov    $0x32,%esi
  803022:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  803029:	00 00 00 
  80302c:	b8 00 00 00 00       	mov    $0x0,%eax
  803031:	48 b9 0d 13 80 00 00 	movabs $0x80130d,%rcx
  803038:	00 00 00 
  80303b:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  80303d:	48 ba 10 6c 80 00 00 	movabs $0x806c10,%rdx
  803044:	00 00 00 
  803047:	be 34 00 00 00       	mov    $0x34,%esi
  80304c:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  803053:	00 00 00 
  803056:	b8 00 00 00 00       	mov    $0x0,%eax
  80305b:	48 b9 0d 13 80 00 00 	movabs $0x80130d,%rcx
  803062:	00 00 00 
  803065:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  803067:	c9                   	leaveq 
  803068:	c3                   	retq   

0000000000803069 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  803069:	55                   	push   %rbp
  80306a:	48 89 e5             	mov    %rsp,%rbp
  80306d:	48 83 ec 20          	sub    $0x20,%rsp
  803071:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803074:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  803077:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80307e:	01 00 00 
  803081:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803084:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803088:	25 07 0e 00 00       	and    $0xe07,%eax
  80308d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  803090:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803093:	48 c1 e0 0c          	shl    $0xc,%rax
  803097:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  80309b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309e:	25 00 04 00 00       	and    $0x400,%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 57                	je     8030fe <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8030a7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8030aa:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8030ae:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b5:	41 89 f0             	mov    %esi,%r8d
  8030b8:	48 89 c6             	mov    %rax,%rsi
  8030bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8030c0:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
  8030cc:	85 c0                	test   %eax,%eax
  8030ce:	0f 8e 52 01 00 00    	jle    803226 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8030d4:	48 ba 42 6c 80 00 00 	movabs $0x806c42,%rdx
  8030db:	00 00 00 
  8030de:	be 4e 00 00 00       	mov    $0x4e,%esi
  8030e3:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  8030ea:	00 00 00 
  8030ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f2:	48 b9 0d 13 80 00 00 	movabs $0x80130d,%rcx
  8030f9:	00 00 00 
  8030fc:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  8030fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803101:	83 e0 02             	and    $0x2,%eax
  803104:	85 c0                	test   %eax,%eax
  803106:	75 10                	jne    803118 <duppage+0xaf>
  803108:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310b:	25 00 08 00 00       	and    $0x800,%eax
  803110:	85 c0                	test   %eax,%eax
  803112:	0f 84 bb 00 00 00    	je     8031d3 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  803118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311b:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  803120:	80 cc 08             	or     $0x8,%ah
  803123:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  803126:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803129:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80312d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803134:	41 89 f0             	mov    %esi,%r8d
  803137:	48 89 c6             	mov    %rax,%rsi
  80313a:	bf 00 00 00 00       	mov    $0x0,%edi
  80313f:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  803146:	00 00 00 
  803149:	ff d0                	callq  *%rax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	7e 2a                	jle    803179 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  80314f:	48 ba 42 6c 80 00 00 	movabs $0x806c42,%rdx
  803156:	00 00 00 
  803159:	be 55 00 00 00       	mov    $0x55,%esi
  80315e:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  803165:	00 00 00 
  803168:	b8 00 00 00 00       	mov    $0x0,%eax
  80316d:	48 b9 0d 13 80 00 00 	movabs $0x80130d,%rcx
  803174:	00 00 00 
  803177:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  803179:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80317c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803180:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803184:	41 89 c8             	mov    %ecx,%r8d
  803187:	48 89 d1             	mov    %rdx,%rcx
  80318a:	ba 00 00 00 00       	mov    $0x0,%edx
  80318f:	48 89 c6             	mov    %rax,%rsi
  803192:	bf 00 00 00 00       	mov    $0x0,%edi
  803197:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  80319e:	00 00 00 
  8031a1:	ff d0                	callq  *%rax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	7e 2a                	jle    8031d1 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  8031a7:	48 ba 42 6c 80 00 00 	movabs $0x806c42,%rdx
  8031ae:	00 00 00 
  8031b1:	be 57 00 00 00       	mov    $0x57,%esi
  8031b6:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  8031bd:	00 00 00 
  8031c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c5:	48 b9 0d 13 80 00 00 	movabs $0x80130d,%rcx
  8031cc:	00 00 00 
  8031cf:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8031d1:	eb 53                	jmp    803226 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8031d3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031d6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031da:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e1:	41 89 f0             	mov    %esi,%r8d
  8031e4:	48 89 c6             	mov    %rax,%rsi
  8031e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8031ec:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  8031f3:	00 00 00 
  8031f6:	ff d0                	callq  *%rax
  8031f8:	85 c0                	test   %eax,%eax
  8031fa:	7e 2a                	jle    803226 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8031fc:	48 ba 42 6c 80 00 00 	movabs $0x806c42,%rdx
  803203:	00 00 00 
  803206:	be 5b 00 00 00       	mov    $0x5b,%esi
  80320b:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  803212:	00 00 00 
  803215:	b8 00 00 00 00       	mov    $0x0,%eax
  80321a:	48 b9 0d 13 80 00 00 	movabs $0x80130d,%rcx
  803221:	00 00 00 
  803224:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  803226:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80322b:	c9                   	leaveq 
  80322c:	c3                   	retq   

000000000080322d <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  80322d:	55                   	push   %rbp
  80322e:	48 89 e5             	mov    %rsp,%rbp
  803231:	48 83 ec 18          	sub    $0x18,%rsp
  803235:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  803239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80323d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  803241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803245:	48 c1 e8 27          	shr    $0x27,%rax
  803249:	48 89 c2             	mov    %rax,%rdx
  80324c:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803253:	01 00 00 
  803256:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80325a:	83 e0 01             	and    $0x1,%eax
  80325d:	48 85 c0             	test   %rax,%rax
  803260:	74 51                	je     8032b3 <pt_is_mapped+0x86>
  803262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803266:	48 c1 e0 0c          	shl    $0xc,%rax
  80326a:	48 c1 e8 1e          	shr    $0x1e,%rax
  80326e:	48 89 c2             	mov    %rax,%rdx
  803271:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803278:	01 00 00 
  80327b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80327f:	83 e0 01             	and    $0x1,%eax
  803282:	48 85 c0             	test   %rax,%rax
  803285:	74 2c                	je     8032b3 <pt_is_mapped+0x86>
  803287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80328b:	48 c1 e0 0c          	shl    $0xc,%rax
  80328f:	48 c1 e8 15          	shr    $0x15,%rax
  803293:	48 89 c2             	mov    %rax,%rdx
  803296:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80329d:	01 00 00 
  8032a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032a4:	83 e0 01             	and    $0x1,%eax
  8032a7:	48 85 c0             	test   %rax,%rax
  8032aa:	74 07                	je     8032b3 <pt_is_mapped+0x86>
  8032ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8032b1:	eb 05                	jmp    8032b8 <pt_is_mapped+0x8b>
  8032b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b8:	83 e0 01             	and    $0x1,%eax
}
  8032bb:	c9                   	leaveq 
  8032bc:	c3                   	retq   

00000000008032bd <fork>:

envid_t
fork(void)
{
  8032bd:	55                   	push   %rbp
  8032be:	48 89 e5             	mov    %rsp,%rbp
  8032c1:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8032c5:	48 bf d4 2e 80 00 00 	movabs $0x802ed4,%rdi
  8032cc:	00 00 00 
  8032cf:	48 b8 ca 5c 80 00 00 	movabs $0x805cca,%rax
  8032d6:	00 00 00 
  8032d9:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8032db:	b8 07 00 00 00       	mov    $0x7,%eax
  8032e0:	cd 30                	int    $0x30
  8032e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8032e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8032e8:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8032eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032ef:	79 30                	jns    803321 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8032f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032f4:	89 c1                	mov    %eax,%ecx
  8032f6:	48 ba 60 6c 80 00 00 	movabs $0x806c60,%rdx
  8032fd:	00 00 00 
  803300:	be 86 00 00 00       	mov    $0x86,%esi
  803305:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  80330c:	00 00 00 
  80330f:	b8 00 00 00 00       	mov    $0x0,%eax
  803314:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
  80331b:	00 00 00 
  80331e:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  803321:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803325:	75 3e                	jne    803365 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  803327:	48 b8 08 2b 80 00 00 	movabs $0x802b08,%rax
  80332e:	00 00 00 
  803331:	ff d0                	callq  *%rax
  803333:	25 ff 03 00 00       	and    $0x3ff,%eax
  803338:	48 98                	cltq   
  80333a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803341:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803348:	00 00 00 
  80334b:	48 01 c2             	add    %rax,%rdx
  80334e:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803355:	00 00 00 
  803358:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80335b:	b8 00 00 00 00       	mov    $0x0,%eax
  803360:	e9 d1 01 00 00       	jmpq   803536 <fork+0x279>
	}
	uint64_t ad = 0;
  803365:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80336c:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80336d:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  803372:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803376:	e9 df 00 00 00       	jmpq   80345a <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80337b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80337f:	48 c1 e8 27          	shr    $0x27,%rax
  803383:	48 89 c2             	mov    %rax,%rdx
  803386:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80338d:	01 00 00 
  803390:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803394:	83 e0 01             	and    $0x1,%eax
  803397:	48 85 c0             	test   %rax,%rax
  80339a:	0f 84 9e 00 00 00    	je     80343e <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8033a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a4:	48 c1 e8 1e          	shr    $0x1e,%rax
  8033a8:	48 89 c2             	mov    %rax,%rdx
  8033ab:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8033b2:	01 00 00 
  8033b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033b9:	83 e0 01             	and    $0x1,%eax
  8033bc:	48 85 c0             	test   %rax,%rax
  8033bf:	74 73                	je     803434 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  8033c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c5:	48 c1 e8 15          	shr    $0x15,%rax
  8033c9:	48 89 c2             	mov    %rax,%rdx
  8033cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8033d3:	01 00 00 
  8033d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033da:	83 e0 01             	and    $0x1,%eax
  8033dd:	48 85 c0             	test   %rax,%rax
  8033e0:	74 48                	je     80342a <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8033e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8033ea:	48 89 c2             	mov    %rax,%rdx
  8033ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8033f4:	01 00 00 
  8033f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033fb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8033ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803403:	83 e0 01             	and    $0x1,%eax
  803406:	48 85 c0             	test   %rax,%rax
  803409:	74 47                	je     803452 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80340b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80340f:	48 c1 e8 0c          	shr    $0xc,%rax
  803413:	89 c2                	mov    %eax,%edx
  803415:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803418:	89 d6                	mov    %edx,%esi
  80341a:	89 c7                	mov    %eax,%edi
  80341c:	48 b8 69 30 80 00 00 	movabs $0x803069,%rax
  803423:	00 00 00 
  803426:	ff d0                	callq  *%rax
  803428:	eb 28                	jmp    803452 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80342a:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  803431:	00 
  803432:	eb 1e                	jmp    803452 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  803434:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80343b:	40 
  80343c:	eb 14                	jmp    803452 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80343e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803442:	48 c1 e8 27          	shr    $0x27,%rax
  803446:	48 83 c0 01          	add    $0x1,%rax
  80344a:	48 c1 e0 27          	shl    $0x27,%rax
  80344e:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  803452:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  803459:	00 
  80345a:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  803461:	00 
  803462:	0f 87 13 ff ff ff    	ja     80337b <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  803468:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80346b:	ba 07 00 00 00       	mov    $0x7,%edx
  803470:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803475:	89 c7                	mov    %eax,%edi
  803477:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  80347e:	00 00 00 
  803481:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  803483:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803486:	ba 07 00 00 00       	mov    $0x7,%edx
  80348b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  803490:	89 c7                	mov    %eax,%edi
  803492:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  803499:	00 00 00 
  80349c:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80349e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034a1:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8034a7:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8034ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8034b1:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8034b6:	89 c7                	mov    %eax,%edi
  8034b8:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  8034bf:	00 00 00 
  8034c2:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8034c4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8034c9:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8034ce:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8034d3:	48 b8 79 25 80 00 00 	movabs $0x802579,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8034df:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8034e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e9:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  8034f0:	00 00 00 
  8034f3:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8034f5:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8034fc:	00 00 00 
  8034ff:	48 8b 00             	mov    (%rax),%rax
  803502:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  803509:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80350c:	48 89 d6             	mov    %rdx,%rsi
  80350f:	89 c7                	mov    %eax,%edi
  803511:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  803518:	00 00 00 
  80351b:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80351d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803520:	be 02 00 00 00       	mov    $0x2,%esi
  803525:	89 c7                	mov    %eax,%edi
  803527:	48 b8 79 2c 80 00 00 	movabs $0x802c79,%rax
  80352e:	00 00 00 
  803531:	ff d0                	callq  *%rax

	return envid;
  803533:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  803536:	c9                   	leaveq 
  803537:	c3                   	retq   

0000000000803538 <sfork>:

	
// Challenge!
int
sfork(void)
{
  803538:	55                   	push   %rbp
  803539:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80353c:	48 ba 78 6c 80 00 00 	movabs $0x806c78,%rdx
  803543:	00 00 00 
  803546:	be bf 00 00 00       	mov    $0xbf,%esi
  80354b:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  803552:	00 00 00 
  803555:	b8 00 00 00 00       	mov    $0x0,%eax
  80355a:	48 b9 0d 13 80 00 00 	movabs $0x80130d,%rcx
  803561:	00 00 00 
  803564:	ff d1                	callq  *%rcx

0000000000803566 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  803566:	55                   	push   %rbp
  803567:	48 89 e5             	mov    %rsp,%rbp
  80356a:	48 83 ec 18          	sub    $0x18,%rsp
  80356e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803572:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803576:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  80357a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803582:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  803585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803589:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80358d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  803591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803595:	8b 00                	mov    (%rax),%eax
  803597:	83 f8 01             	cmp    $0x1,%eax
  80359a:	7e 13                	jle    8035af <argstart+0x49>
  80359c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8035a1:	74 0c                	je     8035af <argstart+0x49>
  8035a3:	48 b8 8e 6c 80 00 00 	movabs $0x806c8e,%rax
  8035aa:	00 00 00 
  8035ad:	eb 05                	jmp    8035b4 <argstart+0x4e>
  8035af:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035b8:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8035bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c0:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8035c7:	00 
}
  8035c8:	c9                   	leaveq 
  8035c9:	c3                   	retq   

00000000008035ca <argnext>:

int
argnext(struct Argstate *args)
{
  8035ca:	55                   	push   %rbp
  8035cb:	48 89 e5             	mov    %rsp,%rbp
  8035ce:	48 83 ec 20          	sub    $0x20,%rsp
  8035d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  8035d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035da:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8035e1:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8035e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8035ea:	48 85 c0             	test   %rax,%rax
  8035ed:	75 0a                	jne    8035f9 <argnext+0x2f>
		return -1;
  8035ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8035f4:	e9 25 01 00 00       	jmpq   80371e <argnext+0x154>

	if (!*args->curarg) {
  8035f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fd:	48 8b 40 10          	mov    0x10(%rax),%rax
  803601:	0f b6 00             	movzbl (%rax),%eax
  803604:	84 c0                	test   %al,%al
  803606:	0f 85 d7 00 00 00    	jne    8036e3 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80360c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803610:	48 8b 00             	mov    (%rax),%rax
  803613:	8b 00                	mov    (%rax),%eax
  803615:	83 f8 01             	cmp    $0x1,%eax
  803618:	0f 84 ef 00 00 00    	je     80370d <argnext+0x143>
		    || args->argv[1][0] != '-'
  80361e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803622:	48 8b 40 08          	mov    0x8(%rax),%rax
  803626:	48 83 c0 08          	add    $0x8,%rax
  80362a:	48 8b 00             	mov    (%rax),%rax
  80362d:	0f b6 00             	movzbl (%rax),%eax
  803630:	3c 2d                	cmp    $0x2d,%al
  803632:	0f 85 d5 00 00 00    	jne    80370d <argnext+0x143>
		    || args->argv[1][1] == '\0')
  803638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80363c:	48 8b 40 08          	mov    0x8(%rax),%rax
  803640:	48 83 c0 08          	add    $0x8,%rax
  803644:	48 8b 00             	mov    (%rax),%rax
  803647:	48 83 c0 01          	add    $0x1,%rax
  80364b:	0f b6 00             	movzbl (%rax),%eax
  80364e:	84 c0                	test   %al,%al
  803650:	0f 84 b7 00 00 00    	je     80370d <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  803656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80365a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80365e:	48 83 c0 08          	add    $0x8,%rax
  803662:	48 8b 00             	mov    (%rax),%rax
  803665:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366d:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803671:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803675:	48 8b 00             	mov    (%rax),%rax
  803678:	8b 00                	mov    (%rax),%eax
  80367a:	83 e8 01             	sub    $0x1,%eax
  80367d:	48 98                	cltq   
  80367f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803686:	00 
  803687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80368b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80368f:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803697:	48 8b 40 08          	mov    0x8(%rax),%rax
  80369b:	48 83 c0 08          	add    $0x8,%rax
  80369f:	48 89 ce             	mov    %rcx,%rsi
  8036a2:	48 89 c7             	mov    %rax,%rdi
  8036a5:	48 b8 79 25 80 00 00 	movabs $0x802579,%rax
  8036ac:	00 00 00 
  8036af:	ff d0                	callq  *%rax
		(*args->argc)--;
  8036b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b5:	48 8b 00             	mov    (%rax),%rax
  8036b8:	8b 10                	mov    (%rax),%edx
  8036ba:	83 ea 01             	sub    $0x1,%edx
  8036bd:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8036bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8036c7:	0f b6 00             	movzbl (%rax),%eax
  8036ca:	3c 2d                	cmp    $0x2d,%al
  8036cc:	75 15                	jne    8036e3 <argnext+0x119>
  8036ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8036d6:	48 83 c0 01          	add    $0x1,%rax
  8036da:	0f b6 00             	movzbl (%rax),%eax
  8036dd:	84 c0                	test   %al,%al
  8036df:	75 02                	jne    8036e3 <argnext+0x119>
			goto endofargs;
  8036e1:	eb 2a                	jmp    80370d <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  8036e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8036eb:	0f b6 00             	movzbl (%rax),%eax
  8036ee:	0f b6 c0             	movzbl %al,%eax
  8036f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8036f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8036fc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803704:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  803708:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370b:	eb 11                	jmp    80371e <argnext+0x154>

endofargs:
	args->curarg = 0;
  80370d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803711:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803718:	00 
	return -1;
  803719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80371e:	c9                   	leaveq 
  80371f:	c3                   	retq   

0000000000803720 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  803720:	55                   	push   %rbp
  803721:	48 89 e5             	mov    %rsp,%rbp
  803724:	48 83 ec 10          	sub    $0x10,%rsp
  803728:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80372c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803730:	48 8b 40 18          	mov    0x18(%rax),%rax
  803734:	48 85 c0             	test   %rax,%rax
  803737:	74 0a                	je     803743 <argvalue+0x23>
  803739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373d:	48 8b 40 18          	mov    0x18(%rax),%rax
  803741:	eb 13                	jmp    803756 <argvalue+0x36>
  803743:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803747:	48 89 c7             	mov    %rax,%rdi
  80374a:	48 b8 58 37 80 00 00 	movabs $0x803758,%rax
  803751:	00 00 00 
  803754:	ff d0                	callq  *%rax
}
  803756:	c9                   	leaveq 
  803757:	c3                   	retq   

0000000000803758 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  803758:	55                   	push   %rbp
  803759:	48 89 e5             	mov    %rsp,%rbp
  80375c:	53                   	push   %rbx
  80375d:	48 83 ec 18          	sub    $0x18,%rsp
  803761:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  803765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803769:	48 8b 40 10          	mov    0x10(%rax),%rax
  80376d:	48 85 c0             	test   %rax,%rax
  803770:	75 0a                	jne    80377c <argnextvalue+0x24>
		return 0;
  803772:	b8 00 00 00 00       	mov    $0x0,%eax
  803777:	e9 c8 00 00 00       	jmpq   803844 <argnextvalue+0xec>
	if (*args->curarg) {
  80377c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803780:	48 8b 40 10          	mov    0x10(%rax),%rax
  803784:	0f b6 00             	movzbl (%rax),%eax
  803787:	84 c0                	test   %al,%al
  803789:	74 27                	je     8037b2 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  80378b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80378f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803797:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  80379b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80379f:	48 bb 8e 6c 80 00 00 	movabs $0x806c8e,%rbx
  8037a6:	00 00 00 
  8037a9:	48 89 58 10          	mov    %rbx,0x10(%rax)
  8037ad:	e9 8a 00 00 00       	jmpq   80383c <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  8037b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b6:	48 8b 00             	mov    (%rax),%rax
  8037b9:	8b 00                	mov    (%rax),%eax
  8037bb:	83 f8 01             	cmp    $0x1,%eax
  8037be:	7e 64                	jle    803824 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  8037c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8037cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d0:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8037d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d8:	48 8b 00             	mov    (%rax),%rax
  8037db:	8b 00                	mov    (%rax),%eax
  8037dd:	83 e8 01             	sub    $0x1,%eax
  8037e0:	48 98                	cltq   
  8037e2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8037e9:	00 
  8037ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037f2:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8037f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037fa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037fe:	48 83 c0 08          	add    $0x8,%rax
  803802:	48 89 ce             	mov    %rcx,%rsi
  803805:	48 89 c7             	mov    %rax,%rdi
  803808:	48 b8 79 25 80 00 00 	movabs $0x802579,%rax
  80380f:	00 00 00 
  803812:	ff d0                	callq  *%rax
		(*args->argc)--;
  803814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803818:	48 8b 00             	mov    (%rax),%rax
  80381b:	8b 10                	mov    (%rax),%edx
  80381d:	83 ea 01             	sub    $0x1,%edx
  803820:	89 10                	mov    %edx,(%rax)
  803822:	eb 18                	jmp    80383c <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  803824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803828:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80382f:	00 
		args->curarg = 0;
  803830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803834:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80383b:	00 
	}
	return (char*) args->argvalue;
  80383c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803840:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  803844:	48 83 c4 18          	add    $0x18,%rsp
  803848:	5b                   	pop    %rbx
  803849:	5d                   	pop    %rbp
  80384a:	c3                   	retq   

000000000080384b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80384b:	55                   	push   %rbp
  80384c:	48 89 e5             	mov    %rsp,%rbp
  80384f:	48 83 ec 08          	sub    $0x8,%rsp
  803853:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  803857:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80385b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  803862:	ff ff ff 
  803865:	48 01 d0             	add    %rdx,%rax
  803868:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80386c:	c9                   	leaveq 
  80386d:	c3                   	retq   

000000000080386e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80386e:	55                   	push   %rbp
  80386f:	48 89 e5             	mov    %rsp,%rbp
  803872:	48 83 ec 08          	sub    $0x8,%rsp
  803876:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80387a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80387e:	48 89 c7             	mov    %rax,%rdi
  803881:	48 b8 4b 38 80 00 00 	movabs $0x80384b,%rax
  803888:	00 00 00 
  80388b:	ff d0                	callq  *%rax
  80388d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  803893:	48 c1 e0 0c          	shl    $0xc,%rax
}
  803897:	c9                   	leaveq 
  803898:	c3                   	retq   

0000000000803899 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  803899:	55                   	push   %rbp
  80389a:	48 89 e5             	mov    %rsp,%rbp
  80389d:	48 83 ec 18          	sub    $0x18,%rsp
  8038a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8038a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038ac:	eb 6b                	jmp    803919 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8038ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b1:	48 98                	cltq   
  8038b3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8038b9:	48 c1 e0 0c          	shl    $0xc,%rax
  8038bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8038c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c5:	48 c1 e8 15          	shr    $0x15,%rax
  8038c9:	48 89 c2             	mov    %rax,%rdx
  8038cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8038d3:	01 00 00 
  8038d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038da:	83 e0 01             	and    $0x1,%eax
  8038dd:	48 85 c0             	test   %rax,%rax
  8038e0:	74 21                	je     803903 <fd_alloc+0x6a>
  8038e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8038ea:	48 89 c2             	mov    %rax,%rdx
  8038ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8038f4:	01 00 00 
  8038f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038fb:	83 e0 01             	and    $0x1,%eax
  8038fe:	48 85 c0             	test   %rax,%rax
  803901:	75 12                	jne    803915 <fd_alloc+0x7c>
			*fd_store = fd;
  803903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803907:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80390b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80390e:	b8 00 00 00 00       	mov    $0x0,%eax
  803913:	eb 1a                	jmp    80392f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  803915:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803919:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80391d:	7e 8f                	jle    8038ae <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80391f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803923:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80392a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80392f:	c9                   	leaveq 
  803930:	c3                   	retq   

0000000000803931 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803931:	55                   	push   %rbp
  803932:	48 89 e5             	mov    %rsp,%rbp
  803935:	48 83 ec 20          	sub    $0x20,%rsp
  803939:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80393c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803940:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803944:	78 06                	js     80394c <fd_lookup+0x1b>
  803946:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80394a:	7e 07                	jle    803953 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80394c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803951:	eb 6c                	jmp    8039bf <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  803953:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803956:	48 98                	cltq   
  803958:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80395e:	48 c1 e0 0c          	shl    $0xc,%rax
  803962:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  803966:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80396a:	48 c1 e8 15          	shr    $0x15,%rax
  80396e:	48 89 c2             	mov    %rax,%rdx
  803971:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803978:	01 00 00 
  80397b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80397f:	83 e0 01             	and    $0x1,%eax
  803982:	48 85 c0             	test   %rax,%rax
  803985:	74 21                	je     8039a8 <fd_lookup+0x77>
  803987:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80398b:	48 c1 e8 0c          	shr    $0xc,%rax
  80398f:	48 89 c2             	mov    %rax,%rdx
  803992:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803999:	01 00 00 
  80399c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039a0:	83 e0 01             	and    $0x1,%eax
  8039a3:	48 85 c0             	test   %rax,%rax
  8039a6:	75 07                	jne    8039af <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8039a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8039ad:	eb 10                	jmp    8039bf <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8039af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039b7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8039ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039bf:	c9                   	leaveq 
  8039c0:	c3                   	retq   

00000000008039c1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8039c1:	55                   	push   %rbp
  8039c2:	48 89 e5             	mov    %rsp,%rbp
  8039c5:	48 83 ec 30          	sub    $0x30,%rsp
  8039c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039cd:	89 f0                	mov    %esi,%eax
  8039cf:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8039d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d6:	48 89 c7             	mov    %rax,%rdi
  8039d9:	48 b8 4b 38 80 00 00 	movabs $0x80384b,%rax
  8039e0:	00 00 00 
  8039e3:	ff d0                	callq  *%rax
  8039e5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8039e9:	48 89 d6             	mov    %rdx,%rsi
  8039ec:	89 c7                	mov    %eax,%edi
  8039ee:	48 b8 31 39 80 00 00 	movabs $0x803931,%rax
  8039f5:	00 00 00 
  8039f8:	ff d0                	callq  *%rax
  8039fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a01:	78 0a                	js     803a0d <fd_close+0x4c>
	    || fd != fd2)
  803a03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a07:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803a0b:	74 12                	je     803a1f <fd_close+0x5e>
		return (must_exist ? r : 0);
  803a0d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803a11:	74 05                	je     803a18 <fd_close+0x57>
  803a13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a16:	eb 05                	jmp    803a1d <fd_close+0x5c>
  803a18:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1d:	eb 69                	jmp    803a88 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803a1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a23:	8b 00                	mov    (%rax),%eax
  803a25:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a29:	48 89 d6             	mov    %rdx,%rsi
  803a2c:	89 c7                	mov    %eax,%edi
  803a2e:	48 b8 8a 3a 80 00 00 	movabs $0x803a8a,%rax
  803a35:	00 00 00 
  803a38:	ff d0                	callq  *%rax
  803a3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a41:	78 2a                	js     803a6d <fd_close+0xac>
		if (dev->dev_close)
  803a43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a47:	48 8b 40 20          	mov    0x20(%rax),%rax
  803a4b:	48 85 c0             	test   %rax,%rax
  803a4e:	74 16                	je     803a66 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  803a50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a54:	48 8b 40 20          	mov    0x20(%rax),%rax
  803a58:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a5c:	48 89 d7             	mov    %rdx,%rdi
  803a5f:	ff d0                	callq  *%rax
  803a61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a64:	eb 07                	jmp    803a6d <fd_close+0xac>
		else
			r = 0;
  803a66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803a6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a71:	48 89 c6             	mov    %rax,%rsi
  803a74:	bf 00 00 00 00       	mov    $0x0,%edi
  803a79:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  803a80:	00 00 00 
  803a83:	ff d0                	callq  *%rax
	return r;
  803a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a88:	c9                   	leaveq 
  803a89:	c3                   	retq   

0000000000803a8a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803a8a:	55                   	push   %rbp
  803a8b:	48 89 e5             	mov    %rsp,%rbp
  803a8e:	48 83 ec 20          	sub    $0x20,%rsp
  803a92:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a95:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  803a99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803aa0:	eb 41                	jmp    803ae3 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803aa2:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803aa9:	00 00 00 
  803aac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803aaf:	48 63 d2             	movslq %edx,%rdx
  803ab2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ab6:	8b 00                	mov    (%rax),%eax
  803ab8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803abb:	75 22                	jne    803adf <dev_lookup+0x55>
			*dev = devtab[i];
  803abd:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803ac4:	00 00 00 
  803ac7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803aca:	48 63 d2             	movslq %edx,%rdx
  803acd:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  803ad1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803ad8:	b8 00 00 00 00       	mov    $0x0,%eax
  803add:	eb 60                	jmp    803b3f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  803adf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ae3:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803aea:	00 00 00 
  803aed:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803af0:	48 63 d2             	movslq %edx,%rdx
  803af3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803af7:	48 85 c0             	test   %rax,%rax
  803afa:	75 a6                	jne    803aa2 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  803afc:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803b03:	00 00 00 
  803b06:	48 8b 00             	mov    (%rax),%rax
  803b09:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803b0f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b12:	89 c6                	mov    %eax,%esi
  803b14:	48 bf 90 6c 80 00 00 	movabs $0x806c90,%rdi
  803b1b:	00 00 00 
  803b1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803b23:	48 b9 46 15 80 00 00 	movabs $0x801546,%rcx
  803b2a:	00 00 00 
  803b2d:	ff d1                	callq  *%rcx
	*dev = 0;
  803b2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b33:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803b3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803b3f:	c9                   	leaveq 
  803b40:	c3                   	retq   

0000000000803b41 <close>:

int
close(int fdnum)
{
  803b41:	55                   	push   %rbp
  803b42:	48 89 e5             	mov    %rsp,%rbp
  803b45:	48 83 ec 20          	sub    $0x20,%rsp
  803b49:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b53:	48 89 d6             	mov    %rdx,%rsi
  803b56:	89 c7                	mov    %eax,%edi
  803b58:	48 b8 31 39 80 00 00 	movabs $0x803931,%rax
  803b5f:	00 00 00 
  803b62:	ff d0                	callq  *%rax
  803b64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b6b:	79 05                	jns    803b72 <close+0x31>
		return r;
  803b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b70:	eb 18                	jmp    803b8a <close+0x49>
	else
		return fd_close(fd, 1);
  803b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b76:	be 01 00 00 00       	mov    $0x1,%esi
  803b7b:	48 89 c7             	mov    %rax,%rdi
  803b7e:	48 b8 c1 39 80 00 00 	movabs $0x8039c1,%rax
  803b85:	00 00 00 
  803b88:	ff d0                	callq  *%rax
}
  803b8a:	c9                   	leaveq 
  803b8b:	c3                   	retq   

0000000000803b8c <close_all>:

void
close_all(void)
{
  803b8c:	55                   	push   %rbp
  803b8d:	48 89 e5             	mov    %rsp,%rbp
  803b90:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803b94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b9b:	eb 15                	jmp    803bb2 <close_all+0x26>
		close(i);
  803b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba0:	89 c7                	mov    %eax,%edi
  803ba2:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  803ba9:	00 00 00 
  803bac:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803bae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803bb2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803bb6:	7e e5                	jle    803b9d <close_all+0x11>
		close(i);
}
  803bb8:	c9                   	leaveq 
  803bb9:	c3                   	retq   

0000000000803bba <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  803bba:	55                   	push   %rbp
  803bbb:	48 89 e5             	mov    %rsp,%rbp
  803bbe:	48 83 ec 40          	sub    $0x40,%rsp
  803bc2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803bc5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803bc8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803bcc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803bcf:	48 89 d6             	mov    %rdx,%rsi
  803bd2:	89 c7                	mov    %eax,%edi
  803bd4:	48 b8 31 39 80 00 00 	movabs $0x803931,%rax
  803bdb:	00 00 00 
  803bde:	ff d0                	callq  *%rax
  803be0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803be3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be7:	79 08                	jns    803bf1 <dup+0x37>
		return r;
  803be9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bec:	e9 70 01 00 00       	jmpq   803d61 <dup+0x1a7>
	close(newfdnum);
  803bf1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803bf4:	89 c7                	mov    %eax,%edi
  803bf6:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  803bfd:	00 00 00 
  803c00:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803c02:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803c05:	48 98                	cltq   
  803c07:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803c0d:	48 c1 e0 0c          	shl    $0xc,%rax
  803c11:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803c15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c19:	48 89 c7             	mov    %rax,%rdi
  803c1c:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  803c23:	00 00 00 
  803c26:	ff d0                	callq  *%rax
  803c28:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803c2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c30:	48 89 c7             	mov    %rax,%rdi
  803c33:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  803c3a:	00 00 00 
  803c3d:	ff d0                	callq  *%rax
  803c3f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803c43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c47:	48 c1 e8 15          	shr    $0x15,%rax
  803c4b:	48 89 c2             	mov    %rax,%rdx
  803c4e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c55:	01 00 00 
  803c58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c5c:	83 e0 01             	and    $0x1,%eax
  803c5f:	48 85 c0             	test   %rax,%rax
  803c62:	74 73                	je     803cd7 <dup+0x11d>
  803c64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c68:	48 c1 e8 0c          	shr    $0xc,%rax
  803c6c:	48 89 c2             	mov    %rax,%rdx
  803c6f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c76:	01 00 00 
  803c79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c7d:	83 e0 01             	and    $0x1,%eax
  803c80:	48 85 c0             	test   %rax,%rax
  803c83:	74 52                	je     803cd7 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c89:	48 c1 e8 0c          	shr    $0xc,%rax
  803c8d:	48 89 c2             	mov    %rax,%rdx
  803c90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c97:	01 00 00 
  803c9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c9e:	25 07 0e 00 00       	and    $0xe07,%eax
  803ca3:	89 c1                	mov    %eax,%ecx
  803ca5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ca9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cad:	41 89 c8             	mov    %ecx,%r8d
  803cb0:	48 89 d1             	mov    %rdx,%rcx
  803cb3:	ba 00 00 00 00       	mov    $0x0,%edx
  803cb8:	48 89 c6             	mov    %rax,%rsi
  803cbb:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc0:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
  803ccc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ccf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd3:	79 02                	jns    803cd7 <dup+0x11d>
			goto err;
  803cd5:	eb 57                	jmp    803d2e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803cd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cdb:	48 c1 e8 0c          	shr    $0xc,%rax
  803cdf:	48 89 c2             	mov    %rax,%rdx
  803ce2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ce9:	01 00 00 
  803cec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cf0:	25 07 0e 00 00       	and    $0xe07,%eax
  803cf5:	89 c1                	mov    %eax,%ecx
  803cf7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cfb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cff:	41 89 c8             	mov    %ecx,%r8d
  803d02:	48 89 d1             	mov    %rdx,%rcx
  803d05:	ba 00 00 00 00       	mov    $0x0,%edx
  803d0a:	48 89 c6             	mov    %rax,%rsi
  803d0d:	bf 00 00 00 00       	mov    $0x0,%edi
  803d12:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  803d19:	00 00 00 
  803d1c:	ff d0                	callq  *%rax
  803d1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d25:	79 02                	jns    803d29 <dup+0x16f>
		goto err;
  803d27:	eb 05                	jmp    803d2e <dup+0x174>

	return newfdnum;
  803d29:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803d2c:	eb 33                	jmp    803d61 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803d2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d32:	48 89 c6             	mov    %rax,%rsi
  803d35:	bf 00 00 00 00       	mov    $0x0,%edi
  803d3a:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  803d41:	00 00 00 
  803d44:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803d46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d4a:	48 89 c6             	mov    %rax,%rsi
  803d4d:	bf 00 00 00 00       	mov    $0x0,%edi
  803d52:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  803d59:	00 00 00 
  803d5c:	ff d0                	callq  *%rax
	return r;
  803d5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d61:	c9                   	leaveq 
  803d62:	c3                   	retq   

0000000000803d63 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803d63:	55                   	push   %rbp
  803d64:	48 89 e5             	mov    %rsp,%rbp
  803d67:	48 83 ec 40          	sub    $0x40,%rsp
  803d6b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803d6e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d72:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803d76:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d7a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d7d:	48 89 d6             	mov    %rdx,%rsi
  803d80:	89 c7                	mov    %eax,%edi
  803d82:	48 b8 31 39 80 00 00 	movabs $0x803931,%rax
  803d89:	00 00 00 
  803d8c:	ff d0                	callq  *%rax
  803d8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d95:	78 24                	js     803dbb <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803d97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d9b:	8b 00                	mov    (%rax),%eax
  803d9d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803da1:	48 89 d6             	mov    %rdx,%rsi
  803da4:	89 c7                	mov    %eax,%edi
  803da6:	48 b8 8a 3a 80 00 00 	movabs $0x803a8a,%rax
  803dad:	00 00 00 
  803db0:	ff d0                	callq  *%rax
  803db2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803db5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db9:	79 05                	jns    803dc0 <read+0x5d>
		return r;
  803dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbe:	eb 76                	jmp    803e36 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803dc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dc4:	8b 40 08             	mov    0x8(%rax),%eax
  803dc7:	83 e0 03             	and    $0x3,%eax
  803dca:	83 f8 01             	cmp    $0x1,%eax
  803dcd:	75 3a                	jne    803e09 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803dcf:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803dd6:	00 00 00 
  803dd9:	48 8b 00             	mov    (%rax),%rax
  803ddc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803de2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803de5:	89 c6                	mov    %eax,%esi
  803de7:	48 bf af 6c 80 00 00 	movabs $0x806caf,%rdi
  803dee:	00 00 00 
  803df1:	b8 00 00 00 00       	mov    $0x0,%eax
  803df6:	48 b9 46 15 80 00 00 	movabs $0x801546,%rcx
  803dfd:	00 00 00 
  803e00:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803e02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e07:	eb 2d                	jmp    803e36 <read+0xd3>
	}
	if (!dev->dev_read)
  803e09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e0d:	48 8b 40 10          	mov    0x10(%rax),%rax
  803e11:	48 85 c0             	test   %rax,%rax
  803e14:	75 07                	jne    803e1d <read+0xba>
		return -E_NOT_SUPP;
  803e16:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803e1b:	eb 19                	jmp    803e36 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803e1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e21:	48 8b 40 10          	mov    0x10(%rax),%rax
  803e25:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e29:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803e2d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803e31:	48 89 cf             	mov    %rcx,%rdi
  803e34:	ff d0                	callq  *%rax
}
  803e36:	c9                   	leaveq 
  803e37:	c3                   	retq   

0000000000803e38 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803e38:	55                   	push   %rbp
  803e39:	48 89 e5             	mov    %rsp,%rbp
  803e3c:	48 83 ec 30          	sub    $0x30,%rsp
  803e40:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e43:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e47:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803e4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e52:	eb 49                	jmp    803e9d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803e54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e57:	48 98                	cltq   
  803e59:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803e5d:	48 29 c2             	sub    %rax,%rdx
  803e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e63:	48 63 c8             	movslq %eax,%rcx
  803e66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e6a:	48 01 c1             	add    %rax,%rcx
  803e6d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e70:	48 89 ce             	mov    %rcx,%rsi
  803e73:	89 c7                	mov    %eax,%edi
  803e75:	48 b8 63 3d 80 00 00 	movabs $0x803d63,%rax
  803e7c:	00 00 00 
  803e7f:	ff d0                	callq  *%rax
  803e81:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803e84:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e88:	79 05                	jns    803e8f <readn+0x57>
			return m;
  803e8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e8d:	eb 1c                	jmp    803eab <readn+0x73>
		if (m == 0)
  803e8f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e93:	75 02                	jne    803e97 <readn+0x5f>
			break;
  803e95:	eb 11                	jmp    803ea8 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803e97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e9a:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea0:	48 98                	cltq   
  803ea2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803ea6:	72 ac                	jb     803e54 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803ea8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803eab:	c9                   	leaveq 
  803eac:	c3                   	retq   

0000000000803ead <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803ead:	55                   	push   %rbp
  803eae:	48 89 e5             	mov    %rsp,%rbp
  803eb1:	48 83 ec 40          	sub    $0x40,%rsp
  803eb5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803eb8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ebc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803ec0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ec4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ec7:	48 89 d6             	mov    %rdx,%rsi
  803eca:	89 c7                	mov    %eax,%edi
  803ecc:	48 b8 31 39 80 00 00 	movabs $0x803931,%rax
  803ed3:	00 00 00 
  803ed6:	ff d0                	callq  *%rax
  803ed8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803edb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803edf:	78 24                	js     803f05 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee5:	8b 00                	mov    (%rax),%eax
  803ee7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803eeb:	48 89 d6             	mov    %rdx,%rsi
  803eee:	89 c7                	mov    %eax,%edi
  803ef0:	48 b8 8a 3a 80 00 00 	movabs $0x803a8a,%rax
  803ef7:	00 00 00 
  803efa:	ff d0                	callq  *%rax
  803efc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f03:	79 05                	jns    803f0a <write+0x5d>
		return r;
  803f05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f08:	eb 42                	jmp    803f4c <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f0e:	8b 40 08             	mov    0x8(%rax),%eax
  803f11:	83 e0 03             	and    $0x3,%eax
  803f14:	85 c0                	test   %eax,%eax
  803f16:	75 07                	jne    803f1f <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803f18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803f1d:	eb 2d                	jmp    803f4c <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803f1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f23:	48 8b 40 18          	mov    0x18(%rax),%rax
  803f27:	48 85 c0             	test   %rax,%rax
  803f2a:	75 07                	jne    803f33 <write+0x86>
		return -E_NOT_SUPP;
  803f2c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803f31:	eb 19                	jmp    803f4c <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  803f33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f37:	48 8b 40 18          	mov    0x18(%rax),%rax
  803f3b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803f43:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803f47:	48 89 cf             	mov    %rcx,%rdi
  803f4a:	ff d0                	callq  *%rax
}
  803f4c:	c9                   	leaveq 
  803f4d:	c3                   	retq   

0000000000803f4e <seek>:

int
seek(int fdnum, off_t offset)
{
  803f4e:	55                   	push   %rbp
  803f4f:	48 89 e5             	mov    %rsp,%rbp
  803f52:	48 83 ec 18          	sub    $0x18,%rsp
  803f56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f59:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f5c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f63:	48 89 d6             	mov    %rdx,%rsi
  803f66:	89 c7                	mov    %eax,%edi
  803f68:	48 b8 31 39 80 00 00 	movabs $0x803931,%rax
  803f6f:	00 00 00 
  803f72:	ff d0                	callq  *%rax
  803f74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f7b:	79 05                	jns    803f82 <seek+0x34>
		return r;
  803f7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f80:	eb 0f                	jmp    803f91 <seek+0x43>
	fd->fd_offset = offset;
  803f82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f86:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f89:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f91:	c9                   	leaveq 
  803f92:	c3                   	retq   

0000000000803f93 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803f93:	55                   	push   %rbp
  803f94:	48 89 e5             	mov    %rsp,%rbp
  803f97:	48 83 ec 30          	sub    $0x30,%rsp
  803f9b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803f9e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803fa1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803fa5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fa8:	48 89 d6             	mov    %rdx,%rsi
  803fab:	89 c7                	mov    %eax,%edi
  803fad:	48 b8 31 39 80 00 00 	movabs $0x803931,%rax
  803fb4:	00 00 00 
  803fb7:	ff d0                	callq  *%rax
  803fb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc0:	78 24                	js     803fe6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803fc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fc6:	8b 00                	mov    (%rax),%eax
  803fc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803fcc:	48 89 d6             	mov    %rdx,%rsi
  803fcf:	89 c7                	mov    %eax,%edi
  803fd1:	48 b8 8a 3a 80 00 00 	movabs $0x803a8a,%rax
  803fd8:	00 00 00 
  803fdb:	ff d0                	callq  *%rax
  803fdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fe0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fe4:	79 05                	jns    803feb <ftruncate+0x58>
		return r;
  803fe6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe9:	eb 72                	jmp    80405d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fef:	8b 40 08             	mov    0x8(%rax),%eax
  803ff2:	83 e0 03             	and    $0x3,%eax
  803ff5:	85 c0                	test   %eax,%eax
  803ff7:	75 3a                	jne    804033 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803ff9:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  804000:	00 00 00 
  804003:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  804006:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80400c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80400f:	89 c6                	mov    %eax,%esi
  804011:	48 bf d0 6c 80 00 00 	movabs $0x806cd0,%rdi
  804018:	00 00 00 
  80401b:	b8 00 00 00 00       	mov    $0x0,%eax
  804020:	48 b9 46 15 80 00 00 	movabs $0x801546,%rcx
  804027:	00 00 00 
  80402a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80402c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804031:	eb 2a                	jmp    80405d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  804033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804037:	48 8b 40 30          	mov    0x30(%rax),%rax
  80403b:	48 85 c0             	test   %rax,%rax
  80403e:	75 07                	jne    804047 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  804040:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804045:	eb 16                	jmp    80405d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  804047:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80404b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80404f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804053:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804056:	89 ce                	mov    %ecx,%esi
  804058:	48 89 d7             	mov    %rdx,%rdi
  80405b:	ff d0                	callq  *%rax
}
  80405d:	c9                   	leaveq 
  80405e:	c3                   	retq   

000000000080405f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80405f:	55                   	push   %rbp
  804060:	48 89 e5             	mov    %rsp,%rbp
  804063:	48 83 ec 30          	sub    $0x30,%rsp
  804067:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80406a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80406e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804072:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804075:	48 89 d6             	mov    %rdx,%rsi
  804078:	89 c7                	mov    %eax,%edi
  80407a:	48 b8 31 39 80 00 00 	movabs $0x803931,%rax
  804081:	00 00 00 
  804084:	ff d0                	callq  *%rax
  804086:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804089:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80408d:	78 24                	js     8040b3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80408f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804093:	8b 00                	mov    (%rax),%eax
  804095:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804099:	48 89 d6             	mov    %rdx,%rsi
  80409c:	89 c7                	mov    %eax,%edi
  80409e:	48 b8 8a 3a 80 00 00 	movabs $0x803a8a,%rax
  8040a5:	00 00 00 
  8040a8:	ff d0                	callq  *%rax
  8040aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040b1:	79 05                	jns    8040b8 <fstat+0x59>
		return r;
  8040b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b6:	eb 5e                	jmp    804116 <fstat+0xb7>
	if (!dev->dev_stat)
  8040b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040bc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8040c0:	48 85 c0             	test   %rax,%rax
  8040c3:	75 07                	jne    8040cc <fstat+0x6d>
		return -E_NOT_SUPP;
  8040c5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8040ca:	eb 4a                	jmp    804116 <fstat+0xb7>
	stat->st_name[0] = 0;
  8040cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040d0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8040d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040d7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8040de:	00 00 00 
	stat->st_isdir = 0;
  8040e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040e5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8040ec:	00 00 00 
	stat->st_dev = dev;
  8040ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040f7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8040fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804102:	48 8b 40 28          	mov    0x28(%rax),%rax
  804106:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80410a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80410e:	48 89 ce             	mov    %rcx,%rsi
  804111:	48 89 d7             	mov    %rdx,%rdi
  804114:	ff d0                	callq  *%rax
}
  804116:	c9                   	leaveq 
  804117:	c3                   	retq   

0000000000804118 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  804118:	55                   	push   %rbp
  804119:	48 89 e5             	mov    %rsp,%rbp
  80411c:	48 83 ec 20          	sub    $0x20,%rsp
  804120:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804124:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  804128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80412c:	be 00 00 00 00       	mov    $0x0,%esi
  804131:	48 89 c7             	mov    %rax,%rdi
  804134:	48 b8 06 42 80 00 00 	movabs $0x804206,%rax
  80413b:	00 00 00 
  80413e:	ff d0                	callq  *%rax
  804140:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804143:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804147:	79 05                	jns    80414e <stat+0x36>
		return fd;
  804149:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80414c:	eb 2f                	jmp    80417d <stat+0x65>
	r = fstat(fd, stat);
  80414e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804155:	48 89 d6             	mov    %rdx,%rsi
  804158:	89 c7                	mov    %eax,%edi
  80415a:	48 b8 5f 40 80 00 00 	movabs $0x80405f,%rax
  804161:	00 00 00 
  804164:	ff d0                	callq  *%rax
  804166:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  804169:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416c:	89 c7                	mov    %eax,%edi
  80416e:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  804175:	00 00 00 
  804178:	ff d0                	callq  *%rax
	return r;
  80417a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80417d:	c9                   	leaveq 
  80417e:	c3                   	retq   

000000000080417f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80417f:	55                   	push   %rbp
  804180:	48 89 e5             	mov    %rsp,%rbp
  804183:	48 83 ec 10          	sub    $0x10,%rsp
  804187:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80418a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80418e:	48 b8 20 94 80 00 00 	movabs $0x809420,%rax
  804195:	00 00 00 
  804198:	8b 00                	mov    (%rax),%eax
  80419a:	85 c0                	test   %eax,%eax
  80419c:	75 1d                	jne    8041bb <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80419e:	bf 01 00 00 00       	mov    $0x1,%edi
  8041a3:	48 b8 d5 62 80 00 00 	movabs $0x8062d5,%rax
  8041aa:	00 00 00 
  8041ad:	ff d0                	callq  *%rax
  8041af:	48 ba 20 94 80 00 00 	movabs $0x809420,%rdx
  8041b6:	00 00 00 
  8041b9:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8041bb:	48 b8 20 94 80 00 00 	movabs $0x809420,%rax
  8041c2:	00 00 00 
  8041c5:	8b 00                	mov    (%rax),%eax
  8041c7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8041ca:	b9 07 00 00 00       	mov    $0x7,%ecx
  8041cf:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8041d6:	00 00 00 
  8041d9:	89 c7                	mov    %eax,%edi
  8041db:	48 b8 08 5f 80 00 00 	movabs $0x805f08,%rax
  8041e2:	00 00 00 
  8041e5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8041e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8041f0:	48 89 c6             	mov    %rax,%rsi
  8041f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8041f8:	48 b8 0a 5e 80 00 00 	movabs $0x805e0a,%rax
  8041ff:	00 00 00 
  804202:	ff d0                	callq  *%rax
}
  804204:	c9                   	leaveq 
  804205:	c3                   	retq   

0000000000804206 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  804206:	55                   	push   %rbp
  804207:	48 89 e5             	mov    %rsp,%rbp
  80420a:	48 83 ec 30          	sub    $0x30,%rsp
  80420e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804212:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  804215:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80421c:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  804223:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80422a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80422f:	75 08                	jne    804239 <open+0x33>
	{
		return r;
  804231:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804234:	e9 f2 00 00 00       	jmpq   80432b <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  804239:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80423d:	48 89 c7             	mov    %rax,%rdi
  804240:	48 b8 e9 21 80 00 00 	movabs $0x8021e9,%rax
  804247:	00 00 00 
  80424a:	ff d0                	callq  *%rax
  80424c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80424f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  804256:	7e 0a                	jle    804262 <open+0x5c>
	{
		return -E_BAD_PATH;
  804258:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80425d:	e9 c9 00 00 00       	jmpq   80432b <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  804262:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  804269:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80426a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80426e:	48 89 c7             	mov    %rax,%rdi
  804271:	48 b8 99 38 80 00 00 	movabs $0x803899,%rax
  804278:	00 00 00 
  80427b:	ff d0                	callq  *%rax
  80427d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804280:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804284:	78 09                	js     80428f <open+0x89>
  804286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80428a:	48 85 c0             	test   %rax,%rax
  80428d:	75 08                	jne    804297 <open+0x91>
		{
			return r;
  80428f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804292:	e9 94 00 00 00       	jmpq   80432b <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  804297:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80429b:	ba 00 04 00 00       	mov    $0x400,%edx
  8042a0:	48 89 c6             	mov    %rax,%rsi
  8042a3:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8042aa:	00 00 00 
  8042ad:	48 b8 e7 22 80 00 00 	movabs $0x8022e7,%rax
  8042b4:	00 00 00 
  8042b7:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8042b9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8042c0:	00 00 00 
  8042c3:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8042c6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8042cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042d0:	48 89 c6             	mov    %rax,%rsi
  8042d3:	bf 01 00 00 00       	mov    $0x1,%edi
  8042d8:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  8042df:	00 00 00 
  8042e2:	ff d0                	callq  *%rax
  8042e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042eb:	79 2b                	jns    804318 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8042ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042f1:	be 00 00 00 00       	mov    $0x0,%esi
  8042f6:	48 89 c7             	mov    %rax,%rdi
  8042f9:	48 b8 c1 39 80 00 00 	movabs $0x8039c1,%rax
  804300:	00 00 00 
  804303:	ff d0                	callq  *%rax
  804305:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804308:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80430c:	79 05                	jns    804313 <open+0x10d>
			{
				return d;
  80430e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804311:	eb 18                	jmp    80432b <open+0x125>
			}
			return r;
  804313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804316:	eb 13                	jmp    80432b <open+0x125>
		}	
		return fd2num(fd_store);
  804318:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80431c:	48 89 c7             	mov    %rax,%rdi
  80431f:	48 b8 4b 38 80 00 00 	movabs $0x80384b,%rax
  804326:	00 00 00 
  804329:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80432b:	c9                   	leaveq 
  80432c:	c3                   	retq   

000000000080432d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80432d:	55                   	push   %rbp
  80432e:	48 89 e5             	mov    %rsp,%rbp
  804331:	48 83 ec 10          	sub    $0x10,%rsp
  804335:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  804339:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80433d:	8b 50 0c             	mov    0xc(%rax),%edx
  804340:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804347:	00 00 00 
  80434a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80434c:	be 00 00 00 00       	mov    $0x0,%esi
  804351:	bf 06 00 00 00       	mov    $0x6,%edi
  804356:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  80435d:	00 00 00 
  804360:	ff d0                	callq  *%rax
}
  804362:	c9                   	leaveq 
  804363:	c3                   	retq   

0000000000804364 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  804364:	55                   	push   %rbp
  804365:	48 89 e5             	mov    %rsp,%rbp
  804368:	48 83 ec 30          	sub    $0x30,%rsp
  80436c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804370:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804374:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  804378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80437f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804384:	74 07                	je     80438d <devfile_read+0x29>
  804386:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80438b:	75 07                	jne    804394 <devfile_read+0x30>
		return -E_INVAL;
  80438d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804392:	eb 77                	jmp    80440b <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  804394:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804398:	8b 50 0c             	mov    0xc(%rax),%edx
  80439b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8043a2:	00 00 00 
  8043a5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8043a7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8043ae:	00 00 00 
  8043b1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8043b5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8043b9:	be 00 00 00 00       	mov    $0x0,%esi
  8043be:	bf 03 00 00 00       	mov    $0x3,%edi
  8043c3:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  8043ca:	00 00 00 
  8043cd:	ff d0                	callq  *%rax
  8043cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043d6:	7f 05                	jg     8043dd <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8043d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043db:	eb 2e                	jmp    80440b <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8043dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e0:	48 63 d0             	movslq %eax,%rdx
  8043e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043e7:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8043ee:	00 00 00 
  8043f1:	48 89 c7             	mov    %rax,%rdi
  8043f4:	48 b8 79 25 80 00 00 	movabs $0x802579,%rax
  8043fb:	00 00 00 
  8043fe:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  804400:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804404:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  804408:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80440b:	c9                   	leaveq 
  80440c:	c3                   	retq   

000000000080440d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80440d:	55                   	push   %rbp
  80440e:	48 89 e5             	mov    %rsp,%rbp
  804411:	48 83 ec 30          	sub    $0x30,%rsp
  804415:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804419:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80441d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  804421:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  804428:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80442d:	74 07                	je     804436 <devfile_write+0x29>
  80442f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804434:	75 08                	jne    80443e <devfile_write+0x31>
		return r;
  804436:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804439:	e9 9a 00 00 00       	jmpq   8044d8 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80443e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804442:	8b 50 0c             	mov    0xc(%rax),%edx
  804445:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80444c:	00 00 00 
  80444f:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  804451:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  804458:	00 
  804459:	76 08                	jbe    804463 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80445b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  804462:	00 
	}
	fsipcbuf.write.req_n = n;
  804463:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80446a:	00 00 00 
  80446d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804471:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  804475:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804479:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80447d:	48 89 c6             	mov    %rax,%rsi
  804480:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  804487:	00 00 00 
  80448a:	48 b8 79 25 80 00 00 	movabs $0x802579,%rax
  804491:	00 00 00 
  804494:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  804496:	be 00 00 00 00       	mov    $0x0,%esi
  80449b:	bf 04 00 00 00       	mov    $0x4,%edi
  8044a0:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  8044a7:	00 00 00 
  8044aa:	ff d0                	callq  *%rax
  8044ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044b3:	7f 20                	jg     8044d5 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8044b5:	48 bf f6 6c 80 00 00 	movabs $0x806cf6,%rdi
  8044bc:	00 00 00 
  8044bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8044c4:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  8044cb:	00 00 00 
  8044ce:	ff d2                	callq  *%rdx
		return r;
  8044d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044d3:	eb 03                	jmp    8044d8 <devfile_write+0xcb>
	}
	return r;
  8044d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8044d8:	c9                   	leaveq 
  8044d9:	c3                   	retq   

00000000008044da <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8044da:	55                   	push   %rbp
  8044db:	48 89 e5             	mov    %rsp,%rbp
  8044de:	48 83 ec 20          	sub    $0x20,%rsp
  8044e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8044ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044ee:	8b 50 0c             	mov    0xc(%rax),%edx
  8044f1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8044f8:	00 00 00 
  8044fb:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8044fd:	be 00 00 00 00       	mov    $0x0,%esi
  804502:	bf 05 00 00 00       	mov    $0x5,%edi
  804507:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  80450e:	00 00 00 
  804511:	ff d0                	callq  *%rax
  804513:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804516:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80451a:	79 05                	jns    804521 <devfile_stat+0x47>
		return r;
  80451c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80451f:	eb 56                	jmp    804577 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  804521:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804525:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80452c:	00 00 00 
  80452f:	48 89 c7             	mov    %rax,%rdi
  804532:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  804539:	00 00 00 
  80453c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80453e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804545:	00 00 00 
  804548:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80454e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804552:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  804558:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80455f:	00 00 00 
  804562:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  804568:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80456c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  804572:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804577:	c9                   	leaveq 
  804578:	c3                   	retq   

0000000000804579 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  804579:	55                   	push   %rbp
  80457a:	48 89 e5             	mov    %rsp,%rbp
  80457d:	48 83 ec 10          	sub    $0x10,%rsp
  804581:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804585:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  804588:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80458c:	8b 50 0c             	mov    0xc(%rax),%edx
  80458f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804596:	00 00 00 
  804599:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80459b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8045a2:	00 00 00 
  8045a5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8045a8:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8045ab:	be 00 00 00 00       	mov    $0x0,%esi
  8045b0:	bf 02 00 00 00       	mov    $0x2,%edi
  8045b5:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  8045bc:	00 00 00 
  8045bf:	ff d0                	callq  *%rax
}
  8045c1:	c9                   	leaveq 
  8045c2:	c3                   	retq   

00000000008045c3 <remove>:

// Delete a file
int
remove(const char *path)
{
  8045c3:	55                   	push   %rbp
  8045c4:	48 89 e5             	mov    %rsp,%rbp
  8045c7:	48 83 ec 10          	sub    $0x10,%rsp
  8045cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8045cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045d3:	48 89 c7             	mov    %rax,%rdi
  8045d6:	48 b8 e9 21 80 00 00 	movabs $0x8021e9,%rax
  8045dd:	00 00 00 
  8045e0:	ff d0                	callq  *%rax
  8045e2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8045e7:	7e 07                	jle    8045f0 <remove+0x2d>
		return -E_BAD_PATH;
  8045e9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8045ee:	eb 33                	jmp    804623 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8045f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045f4:	48 89 c6             	mov    %rax,%rsi
  8045f7:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8045fe:	00 00 00 
  804601:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  804608:	00 00 00 
  80460b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80460d:	be 00 00 00 00       	mov    $0x0,%esi
  804612:	bf 07 00 00 00       	mov    $0x7,%edi
  804617:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  80461e:	00 00 00 
  804621:	ff d0                	callq  *%rax
}
  804623:	c9                   	leaveq 
  804624:	c3                   	retq   

0000000000804625 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  804625:	55                   	push   %rbp
  804626:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  804629:	be 00 00 00 00       	mov    $0x0,%esi
  80462e:	bf 08 00 00 00       	mov    $0x8,%edi
  804633:	48 b8 7f 41 80 00 00 	movabs $0x80417f,%rax
  80463a:	00 00 00 
  80463d:	ff d0                	callq  *%rax
}
  80463f:	5d                   	pop    %rbp
  804640:	c3                   	retq   

0000000000804641 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  804641:	55                   	push   %rbp
  804642:	48 89 e5             	mov    %rsp,%rbp
  804645:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80464c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  804653:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80465a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  804661:	be 00 00 00 00       	mov    $0x0,%esi
  804666:	48 89 c7             	mov    %rax,%rdi
  804669:	48 b8 06 42 80 00 00 	movabs $0x804206,%rax
  804670:	00 00 00 
  804673:	ff d0                	callq  *%rax
  804675:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  804678:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80467c:	79 28                	jns    8046a6 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80467e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804681:	89 c6                	mov    %eax,%esi
  804683:	48 bf 12 6d 80 00 00 	movabs $0x806d12,%rdi
  80468a:	00 00 00 
  80468d:	b8 00 00 00 00       	mov    $0x0,%eax
  804692:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  804699:	00 00 00 
  80469c:	ff d2                	callq  *%rdx
		return fd_src;
  80469e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046a1:	e9 74 01 00 00       	jmpq   80481a <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8046a6:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8046ad:	be 01 01 00 00       	mov    $0x101,%esi
  8046b2:	48 89 c7             	mov    %rax,%rdi
  8046b5:	48 b8 06 42 80 00 00 	movabs $0x804206,%rax
  8046bc:	00 00 00 
  8046bf:	ff d0                	callq  *%rax
  8046c1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8046c4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8046c8:	79 39                	jns    804703 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8046ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046cd:	89 c6                	mov    %eax,%esi
  8046cf:	48 bf 28 6d 80 00 00 	movabs $0x806d28,%rdi
  8046d6:	00 00 00 
  8046d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8046de:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  8046e5:	00 00 00 
  8046e8:	ff d2                	callq  *%rdx
		close(fd_src);
  8046ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ed:	89 c7                	mov    %eax,%edi
  8046ef:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  8046f6:	00 00 00 
  8046f9:	ff d0                	callq  *%rax
		return fd_dest;
  8046fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046fe:	e9 17 01 00 00       	jmpq   80481a <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  804703:	eb 74                	jmp    804779 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  804705:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804708:	48 63 d0             	movslq %eax,%rdx
  80470b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  804712:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804715:	48 89 ce             	mov    %rcx,%rsi
  804718:	89 c7                	mov    %eax,%edi
  80471a:	48 b8 ad 3e 80 00 00 	movabs $0x803ead,%rax
  804721:	00 00 00 
  804724:	ff d0                	callq  *%rax
  804726:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  804729:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80472d:	79 4a                	jns    804779 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80472f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804732:	89 c6                	mov    %eax,%esi
  804734:	48 bf 42 6d 80 00 00 	movabs $0x806d42,%rdi
  80473b:	00 00 00 
  80473e:	b8 00 00 00 00       	mov    $0x0,%eax
  804743:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  80474a:	00 00 00 
  80474d:	ff d2                	callq  *%rdx
			close(fd_src);
  80474f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804752:	89 c7                	mov    %eax,%edi
  804754:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  80475b:	00 00 00 
  80475e:	ff d0                	callq  *%rax
			close(fd_dest);
  804760:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804763:	89 c7                	mov    %eax,%edi
  804765:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  80476c:	00 00 00 
  80476f:	ff d0                	callq  *%rax
			return write_size;
  804771:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804774:	e9 a1 00 00 00       	jmpq   80481a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  804779:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  804780:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804783:	ba 00 02 00 00       	mov    $0x200,%edx
  804788:	48 89 ce             	mov    %rcx,%rsi
  80478b:	89 c7                	mov    %eax,%edi
  80478d:	48 b8 63 3d 80 00 00 	movabs $0x803d63,%rax
  804794:	00 00 00 
  804797:	ff d0                	callq  *%rax
  804799:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80479c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8047a0:	0f 8f 5f ff ff ff    	jg     804705 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8047a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8047aa:	79 47                	jns    8047f3 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8047ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8047af:	89 c6                	mov    %eax,%esi
  8047b1:	48 bf 55 6d 80 00 00 	movabs $0x806d55,%rdi
  8047b8:	00 00 00 
  8047bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8047c0:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  8047c7:	00 00 00 
  8047ca:	ff d2                	callq  *%rdx
		close(fd_src);
  8047cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047cf:	89 c7                	mov    %eax,%edi
  8047d1:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  8047d8:	00 00 00 
  8047db:	ff d0                	callq  *%rax
		close(fd_dest);
  8047dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047e0:	89 c7                	mov    %eax,%edi
  8047e2:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  8047e9:	00 00 00 
  8047ec:	ff d0                	callq  *%rax
		return read_size;
  8047ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8047f1:	eb 27                	jmp    80481a <copy+0x1d9>
	}
	close(fd_src);
  8047f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047f6:	89 c7                	mov    %eax,%edi
  8047f8:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  8047ff:	00 00 00 
  804802:	ff d0                	callq  *%rax
	close(fd_dest);
  804804:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804807:	89 c7                	mov    %eax,%edi
  804809:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  804810:	00 00 00 
  804813:	ff d0                	callq  *%rax
	return 0;
  804815:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80481a:	c9                   	leaveq 
  80481b:	c3                   	retq   

000000000080481c <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80481c:	55                   	push   %rbp
  80481d:	48 89 e5             	mov    %rsp,%rbp
  804820:	48 83 ec 20          	sub    $0x20,%rsp
  804824:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  804828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80482c:	8b 40 0c             	mov    0xc(%rax),%eax
  80482f:	85 c0                	test   %eax,%eax
  804831:	7e 67                	jle    80489a <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  804833:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804837:	8b 40 04             	mov    0x4(%rax),%eax
  80483a:	48 63 d0             	movslq %eax,%rdx
  80483d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804841:	48 8d 48 10          	lea    0x10(%rax),%rcx
  804845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804849:	8b 00                	mov    (%rax),%eax
  80484b:	48 89 ce             	mov    %rcx,%rsi
  80484e:	89 c7                	mov    %eax,%edi
  804850:	48 b8 ad 3e 80 00 00 	movabs $0x803ead,%rax
  804857:	00 00 00 
  80485a:	ff d0                	callq  *%rax
  80485c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  80485f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804863:	7e 13                	jle    804878 <writebuf+0x5c>
			b->result += result;
  804865:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804869:	8b 50 08             	mov    0x8(%rax),%edx
  80486c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80486f:	01 c2                	add    %eax,%edx
  804871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804875:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  804878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80487c:	8b 40 04             	mov    0x4(%rax),%eax
  80487f:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  804882:	74 16                	je     80489a <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  804884:	b8 00 00 00 00       	mov    $0x0,%eax
  804889:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80488d:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  804891:	89 c2                	mov    %eax,%edx
  804893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804897:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  80489a:	c9                   	leaveq 
  80489b:	c3                   	retq   

000000000080489c <putch>:

static void
putch(int ch, void *thunk)
{
  80489c:	55                   	push   %rbp
  80489d:	48 89 e5             	mov    %rsp,%rbp
  8048a0:	48 83 ec 20          	sub    $0x20,%rsp
  8048a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8048a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  8048ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  8048b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048b7:	8b 40 04             	mov    0x4(%rax),%eax
  8048ba:	8d 48 01             	lea    0x1(%rax),%ecx
  8048bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8048c1:	89 4a 04             	mov    %ecx,0x4(%rdx)
  8048c4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8048c7:	89 d1                	mov    %edx,%ecx
  8048c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8048cd:	48 98                	cltq   
  8048cf:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  8048d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048d7:	8b 40 04             	mov    0x4(%rax),%eax
  8048da:	3d 00 01 00 00       	cmp    $0x100,%eax
  8048df:	75 1e                	jne    8048ff <putch+0x63>
		writebuf(b);
  8048e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048e5:	48 89 c7             	mov    %rax,%rdi
  8048e8:	48 b8 1c 48 80 00 00 	movabs $0x80481c,%rax
  8048ef:	00 00 00 
  8048f2:	ff d0                	callq  *%rax
		b->idx = 0;
  8048f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  8048ff:	c9                   	leaveq 
  804900:	c3                   	retq   

0000000000804901 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  804901:	55                   	push   %rbp
  804902:	48 89 e5             	mov    %rsp,%rbp
  804905:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  80490c:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  804912:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  804919:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  804920:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  804926:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  80492c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  804933:	00 00 00 
	b.result = 0;
  804936:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  80493d:	00 00 00 
	b.error = 1;
  804940:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  804947:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80494a:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  804951:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  804958:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80495f:	48 89 c6             	mov    %rax,%rsi
  804962:	48 bf 9c 48 80 00 00 	movabs $0x80489c,%rdi
  804969:	00 00 00 
  80496c:	48 b8 f9 18 80 00 00 	movabs $0x8018f9,%rax
  804973:	00 00 00 
  804976:	ff d0                	callq  *%rax
	if (b.idx > 0)
  804978:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  80497e:	85 c0                	test   %eax,%eax
  804980:	7e 16                	jle    804998 <vfprintf+0x97>
		writebuf(&b);
  804982:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  804989:	48 89 c7             	mov    %rax,%rdi
  80498c:	48 b8 1c 48 80 00 00 	movabs $0x80481c,%rax
  804993:	00 00 00 
  804996:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  804998:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80499e:	85 c0                	test   %eax,%eax
  8049a0:	74 08                	je     8049aa <vfprintf+0xa9>
  8049a2:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8049a8:	eb 06                	jmp    8049b0 <vfprintf+0xaf>
  8049aa:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8049b0:	c9                   	leaveq 
  8049b1:	c3                   	retq   

00000000008049b2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8049b2:	55                   	push   %rbp
  8049b3:	48 89 e5             	mov    %rsp,%rbp
  8049b6:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8049bd:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8049c3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8049ca:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8049d1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8049d8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8049df:	84 c0                	test   %al,%al
  8049e1:	74 20                	je     804a03 <fprintf+0x51>
  8049e3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8049e7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8049eb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8049ef:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8049f3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8049f7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8049fb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8049ff:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804a03:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804a0a:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  804a11:	00 00 00 
  804a14:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804a1b:	00 00 00 
  804a1e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804a22:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804a29:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804a30:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  804a37:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804a3e:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  804a45:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804a4b:	48 89 ce             	mov    %rcx,%rsi
  804a4e:	89 c7                	mov    %eax,%edi
  804a50:	48 b8 01 49 80 00 00 	movabs $0x804901,%rax
  804a57:	00 00 00 
  804a5a:	ff d0                	callq  *%rax
  804a5c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804a62:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804a68:	c9                   	leaveq 
  804a69:	c3                   	retq   

0000000000804a6a <printf>:

int
printf(const char *fmt, ...)
{
  804a6a:	55                   	push   %rbp
  804a6b:	48 89 e5             	mov    %rsp,%rbp
  804a6e:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  804a75:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  804a7c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804a83:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804a8a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804a91:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804a98:	84 c0                	test   %al,%al
  804a9a:	74 20                	je     804abc <printf+0x52>
  804a9c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804aa0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804aa4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804aa8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804aac:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804ab0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804ab4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804ab8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804abc:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804ac3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  804aca:	00 00 00 
  804acd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804ad4:	00 00 00 
  804ad7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804adb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804ae2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804ae9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  804af0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804af7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804afe:	48 89 c6             	mov    %rax,%rsi
  804b01:	bf 01 00 00 00       	mov    $0x1,%edi
  804b06:	48 b8 01 49 80 00 00 	movabs $0x804901,%rax
  804b0d:	00 00 00 
  804b10:	ff d0                	callq  *%rax
  804b12:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804b18:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804b1e:	c9                   	leaveq 
  804b1f:	c3                   	retq   

0000000000804b20 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  804b20:	55                   	push   %rbp
  804b21:	48 89 e5             	mov    %rsp,%rbp
  804b24:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  804b2b:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  804b32:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  804b39:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  804b40:	be 00 00 00 00       	mov    $0x0,%esi
  804b45:	48 89 c7             	mov    %rax,%rdi
  804b48:	48 b8 06 42 80 00 00 	movabs $0x804206,%rax
  804b4f:	00 00 00 
  804b52:	ff d0                	callq  *%rax
  804b54:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804b57:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804b5b:	79 08                	jns    804b65 <spawn+0x45>
		return r;
  804b5d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804b60:	e9 0c 03 00 00       	jmpq   804e71 <spawn+0x351>
	fd = r;
  804b65:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804b68:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  804b6b:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  804b72:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  804b76:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  804b7d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804b80:	ba 00 02 00 00       	mov    $0x200,%edx
  804b85:	48 89 ce             	mov    %rcx,%rsi
  804b88:	89 c7                	mov    %eax,%edi
  804b8a:	48 b8 38 3e 80 00 00 	movabs $0x803e38,%rax
  804b91:	00 00 00 
  804b94:	ff d0                	callq  *%rax
  804b96:	3d 00 02 00 00       	cmp    $0x200,%eax
  804b9b:	75 0d                	jne    804baa <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  804b9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ba1:	8b 00                	mov    (%rax),%eax
  804ba3:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  804ba8:	74 43                	je     804bed <spawn+0xcd>
		close(fd);
  804baa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804bad:	89 c7                	mov    %eax,%edi
  804baf:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  804bb6:	00 00 00 
  804bb9:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  804bbb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bbf:	8b 00                	mov    (%rax),%eax
  804bc1:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  804bc6:	89 c6                	mov    %eax,%esi
  804bc8:	48 bf 70 6d 80 00 00 	movabs $0x806d70,%rdi
  804bcf:	00 00 00 
  804bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  804bd7:	48 b9 46 15 80 00 00 	movabs $0x801546,%rcx
  804bde:	00 00 00 
  804be1:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  804be3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  804be8:	e9 84 02 00 00       	jmpq   804e71 <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  804bed:	b8 07 00 00 00       	mov    $0x7,%eax
  804bf2:	cd 30                	int    $0x30
  804bf4:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  804bf7:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804bfa:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804bfd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804c01:	79 08                	jns    804c0b <spawn+0xeb>
		return r;
  804c03:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c06:	e9 66 02 00 00       	jmpq   804e71 <spawn+0x351>
	child = r;
  804c0b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c0e:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  804c11:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804c14:	25 ff 03 00 00       	and    $0x3ff,%eax
  804c19:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804c20:	00 00 00 
  804c23:	48 98                	cltq   
  804c25:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804c2c:	48 01 d0             	add    %rdx,%rax
  804c2f:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804c36:	48 89 c6             	mov    %rax,%rsi
  804c39:	b8 18 00 00 00       	mov    $0x18,%eax
  804c3e:	48 89 d7             	mov    %rdx,%rdi
  804c41:	48 89 c1             	mov    %rax,%rcx
  804c44:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  804c47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c4b:	48 8b 40 18          	mov    0x18(%rax),%rax
  804c4f:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  804c56:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  804c5d:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  804c64:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  804c6b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804c6e:	48 89 ce             	mov    %rcx,%rsi
  804c71:	89 c7                	mov    %eax,%edi
  804c73:	48 b8 db 50 80 00 00 	movabs $0x8050db,%rax
  804c7a:	00 00 00 
  804c7d:	ff d0                	callq  *%rax
  804c7f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804c82:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804c86:	79 08                	jns    804c90 <spawn+0x170>
		return r;
  804c88:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c8b:	e9 e1 01 00 00       	jmpq   804e71 <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  804c90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c94:	48 8b 40 20          	mov    0x20(%rax),%rax
  804c98:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  804c9f:	48 01 d0             	add    %rdx,%rax
  804ca2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804ca6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804cad:	e9 a3 00 00 00       	jmpq   804d55 <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  804cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cb6:	8b 00                	mov    (%rax),%eax
  804cb8:	83 f8 01             	cmp    $0x1,%eax
  804cbb:	74 05                	je     804cc2 <spawn+0x1a2>
			continue;
  804cbd:	e9 8a 00 00 00       	jmpq   804d4c <spawn+0x22c>
		perm = PTE_P | PTE_U;
  804cc2:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  804cc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ccd:	8b 40 04             	mov    0x4(%rax),%eax
  804cd0:	83 e0 02             	and    $0x2,%eax
  804cd3:	85 c0                	test   %eax,%eax
  804cd5:	74 04                	je     804cdb <spawn+0x1bb>
			perm |= PTE_W;
  804cd7:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804cdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cdf:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804ce3:	41 89 c1             	mov    %eax,%r9d
  804ce6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cea:	4c 8b 40 20          	mov    0x20(%rax),%r8
  804cee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cf2:	48 8b 50 28          	mov    0x28(%rax),%rdx
  804cf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cfa:	48 8b 70 10          	mov    0x10(%rax),%rsi
  804cfe:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  804d01:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804d04:	8b 7d ec             	mov    -0x14(%rbp),%edi
  804d07:	89 3c 24             	mov    %edi,(%rsp)
  804d0a:	89 c7                	mov    %eax,%edi
  804d0c:	48 b8 84 53 80 00 00 	movabs $0x805384,%rax
  804d13:	00 00 00 
  804d16:	ff d0                	callq  *%rax
  804d18:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804d1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804d1f:	79 2b                	jns    804d4c <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  804d21:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804d22:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804d25:	89 c7                	mov    %eax,%edi
  804d27:	48 b8 c4 2a 80 00 00 	movabs $0x802ac4,%rax
  804d2e:	00 00 00 
  804d31:	ff d0                	callq  *%rax
	close(fd);
  804d33:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804d36:	89 c7                	mov    %eax,%edi
  804d38:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  804d3f:	00 00 00 
  804d42:	ff d0                	callq  *%rax
	return r;
  804d44:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804d47:	e9 25 01 00 00       	jmpq   804e71 <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804d4c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804d50:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  804d55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d59:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  804d5d:	0f b7 c0             	movzwl %ax,%eax
  804d60:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  804d63:	0f 8f 49 ff ff ff    	jg     804cb2 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  804d69:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804d6c:	89 c7                	mov    %eax,%edi
  804d6e:	48 b8 41 3b 80 00 00 	movabs $0x803b41,%rax
  804d75:	00 00 00 
  804d78:	ff d0                	callq  *%rax
	fd = -1;
  804d7a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  804d81:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804d84:	89 c7                	mov    %eax,%edi
  804d86:	48 b8 70 55 80 00 00 	movabs $0x805570,%rax
  804d8d:	00 00 00 
  804d90:	ff d0                	callq  *%rax
  804d92:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804d95:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804d99:	79 30                	jns    804dcb <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  804d9b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804d9e:	89 c1                	mov    %eax,%ecx
  804da0:	48 ba 8a 6d 80 00 00 	movabs $0x806d8a,%rdx
  804da7:	00 00 00 
  804daa:	be 82 00 00 00       	mov    $0x82,%esi
  804daf:	48 bf a0 6d 80 00 00 	movabs $0x806da0,%rdi
  804db6:	00 00 00 
  804db9:	b8 00 00 00 00       	mov    $0x0,%eax
  804dbe:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
  804dc5:	00 00 00 
  804dc8:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  804dcb:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804dd2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804dd5:	48 89 d6             	mov    %rdx,%rsi
  804dd8:	89 c7                	mov    %eax,%edi
  804dda:	48 b8 c4 2c 80 00 00 	movabs $0x802cc4,%rax
  804de1:	00 00 00 
  804de4:	ff d0                	callq  *%rax
  804de6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804de9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804ded:	79 30                	jns    804e1f <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  804def:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804df2:	89 c1                	mov    %eax,%ecx
  804df4:	48 ba ac 6d 80 00 00 	movabs $0x806dac,%rdx
  804dfb:	00 00 00 
  804dfe:	be 85 00 00 00       	mov    $0x85,%esi
  804e03:	48 bf a0 6d 80 00 00 	movabs $0x806da0,%rdi
  804e0a:	00 00 00 
  804e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  804e12:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
  804e19:	00 00 00 
  804e1c:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804e1f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804e22:	be 02 00 00 00       	mov    $0x2,%esi
  804e27:	89 c7                	mov    %eax,%edi
  804e29:	48 b8 79 2c 80 00 00 	movabs $0x802c79,%rax
  804e30:	00 00 00 
  804e33:	ff d0                	callq  *%rax
  804e35:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804e38:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804e3c:	79 30                	jns    804e6e <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  804e3e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804e41:	89 c1                	mov    %eax,%ecx
  804e43:	48 ba c6 6d 80 00 00 	movabs $0x806dc6,%rdx
  804e4a:	00 00 00 
  804e4d:	be 88 00 00 00       	mov    $0x88,%esi
  804e52:	48 bf a0 6d 80 00 00 	movabs $0x806da0,%rdi
  804e59:	00 00 00 
  804e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  804e61:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
  804e68:	00 00 00 
  804e6b:	41 ff d0             	callq  *%r8

	return child;
  804e6e:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  804e71:	c9                   	leaveq 
  804e72:	c3                   	retq   

0000000000804e73 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  804e73:	55                   	push   %rbp
  804e74:	48 89 e5             	mov    %rsp,%rbp
  804e77:	41 55                	push   %r13
  804e79:	41 54                	push   %r12
  804e7b:	53                   	push   %rbx
  804e7c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804e83:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  804e8a:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  804e91:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  804e98:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  804e9f:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  804ea6:	84 c0                	test   %al,%al
  804ea8:	74 26                	je     804ed0 <spawnl+0x5d>
  804eaa:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  804eb1:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  804eb8:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  804ebc:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  804ec0:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  804ec4:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  804ec8:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  804ecc:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  804ed0:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804ed7:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  804ede:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804ee1:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804ee8:	00 00 00 
  804eeb:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804ef2:	00 00 00 
  804ef5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804ef9:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804f00:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804f07:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  804f0e:	eb 07                	jmp    804f17 <spawnl+0xa4>
		argc++;
  804f10:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  804f17:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804f1d:	83 f8 30             	cmp    $0x30,%eax
  804f20:	73 23                	jae    804f45 <spawnl+0xd2>
  804f22:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804f29:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804f2f:	89 c0                	mov    %eax,%eax
  804f31:	48 01 d0             	add    %rdx,%rax
  804f34:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804f3a:	83 c2 08             	add    $0x8,%edx
  804f3d:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804f43:	eb 15                	jmp    804f5a <spawnl+0xe7>
  804f45:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804f4c:	48 89 d0             	mov    %rdx,%rax
  804f4f:	48 83 c2 08          	add    $0x8,%rdx
  804f53:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804f5a:	48 8b 00             	mov    (%rax),%rax
  804f5d:	48 85 c0             	test   %rax,%rax
  804f60:	75 ae                	jne    804f10 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  804f62:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804f68:	83 c0 02             	add    $0x2,%eax
  804f6b:	48 89 e2             	mov    %rsp,%rdx
  804f6e:	48 89 d3             	mov    %rdx,%rbx
  804f71:	48 63 d0             	movslq %eax,%rdx
  804f74:	48 83 ea 01          	sub    $0x1,%rdx
  804f78:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  804f7f:	48 63 d0             	movslq %eax,%rdx
  804f82:	49 89 d4             	mov    %rdx,%r12
  804f85:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  804f8b:	48 63 d0             	movslq %eax,%rdx
  804f8e:	49 89 d2             	mov    %rdx,%r10
  804f91:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  804f97:	48 98                	cltq   
  804f99:	48 c1 e0 03          	shl    $0x3,%rax
  804f9d:	48 8d 50 07          	lea    0x7(%rax),%rdx
  804fa1:	b8 10 00 00 00       	mov    $0x10,%eax
  804fa6:	48 83 e8 01          	sub    $0x1,%rax
  804faa:	48 01 d0             	add    %rdx,%rax
  804fad:	bf 10 00 00 00       	mov    $0x10,%edi
  804fb2:	ba 00 00 00 00       	mov    $0x0,%edx
  804fb7:	48 f7 f7             	div    %rdi
  804fba:	48 6b c0 10          	imul   $0x10,%rax,%rax
  804fbe:	48 29 c4             	sub    %rax,%rsp
  804fc1:	48 89 e0             	mov    %rsp,%rax
  804fc4:	48 83 c0 07          	add    $0x7,%rax
  804fc8:	48 c1 e8 03          	shr    $0x3,%rax
  804fcc:	48 c1 e0 03          	shl    $0x3,%rax
  804fd0:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  804fd7:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804fde:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  804fe5:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  804fe8:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804fee:	8d 50 01             	lea    0x1(%rax),%edx
  804ff1:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804ff8:	48 63 d2             	movslq %edx,%rdx
  804ffb:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  805002:	00 

	va_start(vl, arg0);
  805003:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80500a:	00 00 00 
  80500d:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  805014:	00 00 00 
  805017:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80501b:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  805022:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  805029:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  805030:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  805037:	00 00 00 
  80503a:	eb 63                	jmp    80509f <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  80503c:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  805042:	8d 70 01             	lea    0x1(%rax),%esi
  805045:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80504b:	83 f8 30             	cmp    $0x30,%eax
  80504e:	73 23                	jae    805073 <spawnl+0x200>
  805050:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  805057:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80505d:	89 c0                	mov    %eax,%eax
  80505f:	48 01 d0             	add    %rdx,%rax
  805062:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  805068:	83 c2 08             	add    $0x8,%edx
  80506b:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  805071:	eb 15                	jmp    805088 <spawnl+0x215>
  805073:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80507a:	48 89 d0             	mov    %rdx,%rax
  80507d:	48 83 c2 08          	add    $0x8,%rdx
  805081:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  805088:	48 8b 08             	mov    (%rax),%rcx
  80508b:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  805092:	89 f2                	mov    %esi,%edx
  805094:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  805098:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80509f:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8050a5:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8050ab:	77 8f                	ja     80503c <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8050ad:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8050b4:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8050bb:	48 89 d6             	mov    %rdx,%rsi
  8050be:	48 89 c7             	mov    %rax,%rdi
  8050c1:	48 b8 20 4b 80 00 00 	movabs $0x804b20,%rax
  8050c8:	00 00 00 
  8050cb:	ff d0                	callq  *%rax
  8050cd:	48 89 dc             	mov    %rbx,%rsp
}
  8050d0:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8050d4:	5b                   	pop    %rbx
  8050d5:	41 5c                	pop    %r12
  8050d7:	41 5d                	pop    %r13
  8050d9:	5d                   	pop    %rbp
  8050da:	c3                   	retq   

00000000008050db <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8050db:	55                   	push   %rbp
  8050dc:	48 89 e5             	mov    %rsp,%rbp
  8050df:	48 83 ec 50          	sub    $0x50,%rsp
  8050e3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8050e6:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8050ea:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8050ee:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8050f5:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8050f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8050fd:	eb 33                	jmp    805132 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8050ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805102:	48 98                	cltq   
  805104:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80510b:	00 
  80510c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805110:	48 01 d0             	add    %rdx,%rax
  805113:	48 8b 00             	mov    (%rax),%rax
  805116:	48 89 c7             	mov    %rax,%rdi
  805119:	48 b8 e9 21 80 00 00 	movabs $0x8021e9,%rax
  805120:	00 00 00 
  805123:	ff d0                	callq  *%rax
  805125:	83 c0 01             	add    $0x1,%eax
  805128:	48 98                	cltq   
  80512a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80512e:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  805132:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805135:	48 98                	cltq   
  805137:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80513e:	00 
  80513f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805143:	48 01 d0             	add    %rdx,%rax
  805146:	48 8b 00             	mov    (%rax),%rax
  805149:	48 85 c0             	test   %rax,%rax
  80514c:	75 b1                	jne    8050ff <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80514e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805152:	48 f7 d8             	neg    %rax
  805155:	48 05 00 10 40 00    	add    $0x401000,%rax
  80515b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80515f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805163:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  805167:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80516b:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80516f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805172:	83 c2 01             	add    $0x1,%edx
  805175:	c1 e2 03             	shl    $0x3,%edx
  805178:	48 63 d2             	movslq %edx,%rdx
  80517b:	48 f7 da             	neg    %rdx
  80517e:	48 01 d0             	add    %rdx,%rax
  805181:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  805185:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805189:	48 83 e8 10          	sub    $0x10,%rax
  80518d:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  805193:	77 0a                	ja     80519f <init_stack+0xc4>
		return -E_NO_MEM;
  805195:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80519a:	e9 e3 01 00 00       	jmpq   805382 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80519f:	ba 07 00 00 00       	mov    $0x7,%edx
  8051a4:	be 00 00 40 00       	mov    $0x400000,%esi
  8051a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8051ae:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  8051b5:	00 00 00 
  8051b8:	ff d0                	callq  *%rax
  8051ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8051bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8051c1:	79 08                	jns    8051cb <init_stack+0xf0>
		return r;
  8051c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8051c6:	e9 b7 01 00 00       	jmpq   805382 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8051cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8051d2:	e9 8a 00 00 00       	jmpq   805261 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8051d7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8051da:	48 98                	cltq   
  8051dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8051e3:	00 
  8051e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8051e8:	48 01 c2             	add    %rax,%rdx
  8051eb:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8051f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8051f4:	48 01 c8             	add    %rcx,%rax
  8051f7:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8051fd:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  805200:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805203:	48 98                	cltq   
  805205:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80520c:	00 
  80520d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805211:	48 01 d0             	add    %rdx,%rax
  805214:	48 8b 10             	mov    (%rax),%rdx
  805217:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80521b:	48 89 d6             	mov    %rdx,%rsi
  80521e:	48 89 c7             	mov    %rax,%rdi
  805221:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  805228:	00 00 00 
  80522b:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80522d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805230:	48 98                	cltq   
  805232:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805239:	00 
  80523a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80523e:	48 01 d0             	add    %rdx,%rax
  805241:	48 8b 00             	mov    (%rax),%rax
  805244:	48 89 c7             	mov    %rax,%rdi
  805247:	48 b8 e9 21 80 00 00 	movabs $0x8021e9,%rax
  80524e:	00 00 00 
  805251:	ff d0                	callq  *%rax
  805253:	48 98                	cltq   
  805255:	48 83 c0 01          	add    $0x1,%rax
  805259:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80525d:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  805261:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805264:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  805267:	0f 8c 6a ff ff ff    	jl     8051d7 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80526d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805270:	48 98                	cltq   
  805272:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805279:	00 
  80527a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80527e:	48 01 d0             	add    %rdx,%rax
  805281:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  805288:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80528f:	00 
  805290:	74 35                	je     8052c7 <init_stack+0x1ec>
  805292:	48 b9 e0 6d 80 00 00 	movabs $0x806de0,%rcx
  805299:	00 00 00 
  80529c:	48 ba 06 6e 80 00 00 	movabs $0x806e06,%rdx
  8052a3:	00 00 00 
  8052a6:	be f1 00 00 00       	mov    $0xf1,%esi
  8052ab:	48 bf a0 6d 80 00 00 	movabs $0x806da0,%rdi
  8052b2:	00 00 00 
  8052b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8052ba:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
  8052c1:	00 00 00 
  8052c4:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8052c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8052cb:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8052cf:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8052d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8052d8:	48 01 c8             	add    %rcx,%rax
  8052db:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8052e1:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8052e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8052e8:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8052ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052ef:	48 98                	cltq   
  8052f1:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8052f4:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8052f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8052fd:	48 01 d0             	add    %rdx,%rax
  805300:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805306:	48 89 c2             	mov    %rax,%rdx
  805309:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80530d:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  805310:	8b 45 cc             	mov    -0x34(%rbp),%eax
  805313:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  805319:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80531e:	89 c2                	mov    %eax,%edx
  805320:	be 00 00 40 00       	mov    $0x400000,%esi
  805325:	bf 00 00 00 00       	mov    $0x0,%edi
  80532a:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  805331:	00 00 00 
  805334:	ff d0                	callq  *%rax
  805336:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805339:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80533d:	79 02                	jns    805341 <init_stack+0x266>
		goto error;
  80533f:	eb 28                	jmp    805369 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  805341:	be 00 00 40 00       	mov    $0x400000,%esi
  805346:	bf 00 00 00 00       	mov    $0x0,%edi
  80534b:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  805352:	00 00 00 
  805355:	ff d0                	callq  *%rax
  805357:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80535a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80535e:	79 02                	jns    805362 <init_stack+0x287>
		goto error;
  805360:	eb 07                	jmp    805369 <init_stack+0x28e>

	return 0;
  805362:	b8 00 00 00 00       	mov    $0x0,%eax
  805367:	eb 19                	jmp    805382 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  805369:	be 00 00 40 00       	mov    $0x400000,%esi
  80536e:	bf 00 00 00 00       	mov    $0x0,%edi
  805373:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  80537a:	00 00 00 
  80537d:	ff d0                	callq  *%rax
	return r;
  80537f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  805382:	c9                   	leaveq 
  805383:	c3                   	retq   

0000000000805384 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  805384:	55                   	push   %rbp
  805385:	48 89 e5             	mov    %rsp,%rbp
  805388:	48 83 ec 50          	sub    $0x50,%rsp
  80538c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80538f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805393:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  805397:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80539a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80539e:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8053a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8053a6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8053ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8053ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8053b2:	74 21                	je     8053d5 <map_segment+0x51>
		va -= i;
  8053b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053b7:	48 98                	cltq   
  8053b9:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8053bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053c0:	48 98                	cltq   
  8053c2:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8053c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053c9:	48 98                	cltq   
  8053cb:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8053cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053d2:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8053d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8053dc:	e9 79 01 00 00       	jmpq   80555a <map_segment+0x1d6>
		if (i >= filesz) {
  8053e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053e4:	48 98                	cltq   
  8053e6:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8053ea:	72 3c                	jb     805428 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8053ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053ef:	48 63 d0             	movslq %eax,%rdx
  8053f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8053f6:	48 01 d0             	add    %rdx,%rax
  8053f9:	48 89 c1             	mov    %rax,%rcx
  8053fc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8053ff:	8b 55 10             	mov    0x10(%rbp),%edx
  805402:	48 89 ce             	mov    %rcx,%rsi
  805405:	89 c7                	mov    %eax,%edi
  805407:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  80540e:	00 00 00 
  805411:	ff d0                	callq  *%rax
  805413:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805416:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80541a:	0f 89 33 01 00 00    	jns    805553 <map_segment+0x1cf>
				return r;
  805420:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805423:	e9 46 01 00 00       	jmpq   80556e <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  805428:	ba 07 00 00 00       	mov    $0x7,%edx
  80542d:	be 00 00 40 00       	mov    $0x400000,%esi
  805432:	bf 00 00 00 00       	mov    $0x0,%edi
  805437:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  80543e:	00 00 00 
  805441:	ff d0                	callq  *%rax
  805443:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805446:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80544a:	79 08                	jns    805454 <map_segment+0xd0>
				return r;
  80544c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80544f:	e9 1a 01 00 00       	jmpq   80556e <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  805454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805457:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80545a:	01 c2                	add    %eax,%edx
  80545c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80545f:	89 d6                	mov    %edx,%esi
  805461:	89 c7                	mov    %eax,%edi
  805463:	48 b8 4e 3f 80 00 00 	movabs $0x803f4e,%rax
  80546a:	00 00 00 
  80546d:	ff d0                	callq  *%rax
  80546f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805472:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805476:	79 08                	jns    805480 <map_segment+0xfc>
				return r;
  805478:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80547b:	e9 ee 00 00 00       	jmpq   80556e <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  805480:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  805487:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80548a:	48 98                	cltq   
  80548c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  805490:	48 29 c2             	sub    %rax,%rdx
  805493:	48 89 d0             	mov    %rdx,%rax
  805496:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80549a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80549d:	48 63 d0             	movslq %eax,%rdx
  8054a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8054a4:	48 39 c2             	cmp    %rax,%rdx
  8054a7:	48 0f 47 d0          	cmova  %rax,%rdx
  8054ab:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8054ae:	be 00 00 40 00       	mov    $0x400000,%esi
  8054b3:	89 c7                	mov    %eax,%edi
  8054b5:	48 b8 38 3e 80 00 00 	movabs $0x803e38,%rax
  8054bc:	00 00 00 
  8054bf:	ff d0                	callq  *%rax
  8054c1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8054c4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8054c8:	79 08                	jns    8054d2 <map_segment+0x14e>
				return r;
  8054ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8054cd:	e9 9c 00 00 00       	jmpq   80556e <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8054d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054d5:	48 63 d0             	movslq %eax,%rdx
  8054d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054dc:	48 01 d0             	add    %rdx,%rax
  8054df:	48 89 c2             	mov    %rax,%rdx
  8054e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8054e5:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8054e9:	48 89 d1             	mov    %rdx,%rcx
  8054ec:	89 c2                	mov    %eax,%edx
  8054ee:	be 00 00 40 00       	mov    $0x400000,%esi
  8054f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8054f8:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  8054ff:	00 00 00 
  805502:	ff d0                	callq  *%rax
  805504:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805507:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80550b:	79 30                	jns    80553d <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  80550d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805510:	89 c1                	mov    %eax,%ecx
  805512:	48 ba 1b 6e 80 00 00 	movabs $0x806e1b,%rdx
  805519:	00 00 00 
  80551c:	be 24 01 00 00       	mov    $0x124,%esi
  805521:	48 bf a0 6d 80 00 00 	movabs $0x806da0,%rdi
  805528:	00 00 00 
  80552b:	b8 00 00 00 00       	mov    $0x0,%eax
  805530:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
  805537:	00 00 00 
  80553a:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  80553d:	be 00 00 40 00       	mov    $0x400000,%esi
  805542:	bf 00 00 00 00       	mov    $0x0,%edi
  805547:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  80554e:	00 00 00 
  805551:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805553:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80555a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80555d:	48 98                	cltq   
  80555f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805563:	0f 82 78 fe ff ff    	jb     8053e1 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  805569:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80556e:	c9                   	leaveq 
  80556f:	c3                   	retq   

0000000000805570 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  805570:	55                   	push   %rbp
  805571:	48 89 e5             	mov    %rsp,%rbp
  805574:	48 83 ec 20          	sub    $0x20,%rsp
  805578:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  80557b:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  805582:	00 
  805583:	e9 c9 00 00 00       	jmpq   805651 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  805588:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80558c:	48 c1 e8 27          	shr    $0x27,%rax
  805590:	48 89 c2             	mov    %rax,%rdx
  805593:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80559a:	01 00 00 
  80559d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055a1:	48 85 c0             	test   %rax,%rax
  8055a4:	74 3c                	je     8055e2 <copy_shared_pages+0x72>
  8055a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055aa:	48 c1 e8 1e          	shr    $0x1e,%rax
  8055ae:	48 89 c2             	mov    %rax,%rdx
  8055b1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8055b8:	01 00 00 
  8055bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055bf:	48 85 c0             	test   %rax,%rax
  8055c2:	74 1e                	je     8055e2 <copy_shared_pages+0x72>
  8055c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055c8:	48 c1 e8 15          	shr    $0x15,%rax
  8055cc:	48 89 c2             	mov    %rax,%rdx
  8055cf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8055d6:	01 00 00 
  8055d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055dd:	48 85 c0             	test   %rax,%rax
  8055e0:	75 02                	jne    8055e4 <copy_shared_pages+0x74>
                continue;
  8055e2:	eb 65                	jmp    805649 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  8055e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055e8:	48 c1 e8 0c          	shr    $0xc,%rax
  8055ec:	48 89 c2             	mov    %rax,%rdx
  8055ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8055f6:	01 00 00 
  8055f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055fd:	25 00 04 00 00       	and    $0x400,%eax
  805602:	48 85 c0             	test   %rax,%rax
  805605:	74 42                	je     805649 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  805607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80560b:	48 c1 e8 0c          	shr    $0xc,%rax
  80560f:	48 89 c2             	mov    %rax,%rdx
  805612:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805619:	01 00 00 
  80561c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805620:	25 07 0e 00 00       	and    $0xe07,%eax
  805625:	89 c6                	mov    %eax,%esi
  805627:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80562b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80562f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805632:	41 89 f0             	mov    %esi,%r8d
  805635:	48 89 c6             	mov    %rax,%rsi
  805638:	bf 00 00 00 00       	mov    $0x0,%edi
  80563d:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  805644:	00 00 00 
  805647:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  805649:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  805650:	00 
  805651:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  805658:	00 00 00 
  80565b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80565f:	0f 86 23 ff ff ff    	jbe    805588 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  805665:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  80566a:	c9                   	leaveq 
  80566b:	c3                   	retq   

000000000080566c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80566c:	55                   	push   %rbp
  80566d:	48 89 e5             	mov    %rsp,%rbp
  805670:	53                   	push   %rbx
  805671:	48 83 ec 38          	sub    $0x38,%rsp
  805675:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805679:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80567d:	48 89 c7             	mov    %rax,%rdi
  805680:	48 b8 99 38 80 00 00 	movabs $0x803899,%rax
  805687:	00 00 00 
  80568a:	ff d0                	callq  *%rax
  80568c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80568f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805693:	0f 88 bf 01 00 00    	js     805858 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80569d:	ba 07 04 00 00       	mov    $0x407,%edx
  8056a2:	48 89 c6             	mov    %rax,%rsi
  8056a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8056aa:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  8056b1:	00 00 00 
  8056b4:	ff d0                	callq  *%rax
  8056b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8056b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8056bd:	0f 88 95 01 00 00    	js     805858 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8056c3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8056c7:	48 89 c7             	mov    %rax,%rdi
  8056ca:	48 b8 99 38 80 00 00 	movabs $0x803899,%rax
  8056d1:	00 00 00 
  8056d4:	ff d0                	callq  *%rax
  8056d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8056d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8056dd:	0f 88 5d 01 00 00    	js     805840 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8056e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8056e7:	ba 07 04 00 00       	mov    $0x407,%edx
  8056ec:	48 89 c6             	mov    %rax,%rsi
  8056ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8056f4:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  8056fb:	00 00 00 
  8056fe:	ff d0                	callq  *%rax
  805700:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805703:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805707:	0f 88 33 01 00 00    	js     805840 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80570d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805711:	48 89 c7             	mov    %rax,%rdi
  805714:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  80571b:	00 00 00 
  80571e:	ff d0                	callq  *%rax
  805720:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805724:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805728:	ba 07 04 00 00       	mov    $0x407,%edx
  80572d:	48 89 c6             	mov    %rax,%rsi
  805730:	bf 00 00 00 00       	mov    $0x0,%edi
  805735:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  80573c:	00 00 00 
  80573f:	ff d0                	callq  *%rax
  805741:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805744:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805748:	79 05                	jns    80574f <pipe+0xe3>
		goto err2;
  80574a:	e9 d9 00 00 00       	jmpq   805828 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80574f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805753:	48 89 c7             	mov    %rax,%rdi
  805756:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  80575d:	00 00 00 
  805760:	ff d0                	callq  *%rax
  805762:	48 89 c2             	mov    %rax,%rdx
  805765:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805769:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80576f:	48 89 d1             	mov    %rdx,%rcx
  805772:	ba 00 00 00 00       	mov    $0x0,%edx
  805777:	48 89 c6             	mov    %rax,%rsi
  80577a:	bf 00 00 00 00       	mov    $0x0,%edi
  80577f:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  805786:	00 00 00 
  805789:	ff d0                	callq  *%rax
  80578b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80578e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805792:	79 1b                	jns    8057af <pipe+0x143>
		goto err3;
  805794:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  805795:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805799:	48 89 c6             	mov    %rax,%rsi
  80579c:	bf 00 00 00 00       	mov    $0x0,%edi
  8057a1:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  8057a8:	00 00 00 
  8057ab:	ff d0                	callq  *%rax
  8057ad:	eb 79                	jmp    805828 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8057af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8057b3:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  8057ba:	00 00 00 
  8057bd:	8b 12                	mov    (%rdx),%edx
  8057bf:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8057c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8057c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8057cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8057d0:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  8057d7:	00 00 00 
  8057da:	8b 12                	mov    (%rdx),%edx
  8057dc:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8057de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8057e2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8057e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8057ed:	48 89 c7             	mov    %rax,%rdi
  8057f0:	48 b8 4b 38 80 00 00 	movabs $0x80384b,%rax
  8057f7:	00 00 00 
  8057fa:	ff d0                	callq  *%rax
  8057fc:	89 c2                	mov    %eax,%edx
  8057fe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805802:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  805804:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805808:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80580c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805810:	48 89 c7             	mov    %rax,%rdi
  805813:	48 b8 4b 38 80 00 00 	movabs $0x80384b,%rax
  80581a:	00 00 00 
  80581d:	ff d0                	callq  *%rax
  80581f:	89 03                	mov    %eax,(%rbx)
	return 0;
  805821:	b8 00 00 00 00       	mov    $0x0,%eax
  805826:	eb 33                	jmp    80585b <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  805828:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80582c:	48 89 c6             	mov    %rax,%rsi
  80582f:	bf 00 00 00 00       	mov    $0x0,%edi
  805834:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  80583b:	00 00 00 
  80583e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  805840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805844:	48 89 c6             	mov    %rax,%rsi
  805847:	bf 00 00 00 00       	mov    $0x0,%edi
  80584c:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  805853:	00 00 00 
  805856:	ff d0                	callq  *%rax
err:
	return r;
  805858:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80585b:	48 83 c4 38          	add    $0x38,%rsp
  80585f:	5b                   	pop    %rbx
  805860:	5d                   	pop    %rbp
  805861:	c3                   	retq   

0000000000805862 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  805862:	55                   	push   %rbp
  805863:	48 89 e5             	mov    %rsp,%rbp
  805866:	53                   	push   %rbx
  805867:	48 83 ec 28          	sub    $0x28,%rsp
  80586b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80586f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  805873:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80587a:	00 00 00 
  80587d:	48 8b 00             	mov    (%rax),%rax
  805880:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805886:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  805889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80588d:	48 89 c7             	mov    %rax,%rdi
  805890:	48 b8 47 63 80 00 00 	movabs $0x806347,%rax
  805897:	00 00 00 
  80589a:	ff d0                	callq  *%rax
  80589c:	89 c3                	mov    %eax,%ebx
  80589e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8058a2:	48 89 c7             	mov    %rax,%rdi
  8058a5:	48 b8 47 63 80 00 00 	movabs $0x806347,%rax
  8058ac:	00 00 00 
  8058af:	ff d0                	callq  *%rax
  8058b1:	39 c3                	cmp    %eax,%ebx
  8058b3:	0f 94 c0             	sete   %al
  8058b6:	0f b6 c0             	movzbl %al,%eax
  8058b9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8058bc:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8058c3:	00 00 00 
  8058c6:	48 8b 00             	mov    (%rax),%rax
  8058c9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8058cf:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8058d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8058d5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8058d8:	75 05                	jne    8058df <_pipeisclosed+0x7d>
			return ret;
  8058da:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8058dd:	eb 4f                	jmp    80592e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8058df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8058e2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8058e5:	74 42                	je     805929 <_pipeisclosed+0xc7>
  8058e7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8058eb:	75 3c                	jne    805929 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8058ed:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8058f4:	00 00 00 
  8058f7:	48 8b 00             	mov    (%rax),%rax
  8058fa:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  805900:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805903:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805906:	89 c6                	mov    %eax,%esi
  805908:	48 bf 42 6e 80 00 00 	movabs $0x806e42,%rdi
  80590f:	00 00 00 
  805912:	b8 00 00 00 00       	mov    $0x0,%eax
  805917:	49 b8 46 15 80 00 00 	movabs $0x801546,%r8
  80591e:	00 00 00 
  805921:	41 ff d0             	callq  *%r8
	}
  805924:	e9 4a ff ff ff       	jmpq   805873 <_pipeisclosed+0x11>
  805929:	e9 45 ff ff ff       	jmpq   805873 <_pipeisclosed+0x11>
}
  80592e:	48 83 c4 28          	add    $0x28,%rsp
  805932:	5b                   	pop    %rbx
  805933:	5d                   	pop    %rbp
  805934:	c3                   	retq   

0000000000805935 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  805935:	55                   	push   %rbp
  805936:	48 89 e5             	mov    %rsp,%rbp
  805939:	48 83 ec 30          	sub    $0x30,%rsp
  80593d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805940:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805944:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805947:	48 89 d6             	mov    %rdx,%rsi
  80594a:	89 c7                	mov    %eax,%edi
  80594c:	48 b8 31 39 80 00 00 	movabs $0x803931,%rax
  805953:	00 00 00 
  805956:	ff d0                	callq  *%rax
  805958:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80595b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80595f:	79 05                	jns    805966 <pipeisclosed+0x31>
		return r;
  805961:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805964:	eb 31                	jmp    805997 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  805966:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80596a:	48 89 c7             	mov    %rax,%rdi
  80596d:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  805974:	00 00 00 
  805977:	ff d0                	callq  *%rax
  805979:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80597d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805981:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805985:	48 89 d6             	mov    %rdx,%rsi
  805988:	48 89 c7             	mov    %rax,%rdi
  80598b:	48 b8 62 58 80 00 00 	movabs $0x805862,%rax
  805992:	00 00 00 
  805995:	ff d0                	callq  *%rax
}
  805997:	c9                   	leaveq 
  805998:	c3                   	retq   

0000000000805999 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  805999:	55                   	push   %rbp
  80599a:	48 89 e5             	mov    %rsp,%rbp
  80599d:	48 83 ec 40          	sub    $0x40,%rsp
  8059a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8059a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8059a9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8059ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8059b1:	48 89 c7             	mov    %rax,%rdi
  8059b4:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  8059bb:	00 00 00 
  8059be:	ff d0                	callq  *%rax
  8059c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8059c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8059c8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8059cc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8059d3:	00 
  8059d4:	e9 92 00 00 00       	jmpq   805a6b <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8059d9:	eb 41                	jmp    805a1c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8059db:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8059e0:	74 09                	je     8059eb <devpipe_read+0x52>
				return i;
  8059e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8059e6:	e9 92 00 00 00       	jmpq   805a7d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8059eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8059ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8059f3:	48 89 d6             	mov    %rdx,%rsi
  8059f6:	48 89 c7             	mov    %rax,%rdi
  8059f9:	48 b8 62 58 80 00 00 	movabs $0x805862,%rax
  805a00:	00 00 00 
  805a03:	ff d0                	callq  *%rax
  805a05:	85 c0                	test   %eax,%eax
  805a07:	74 07                	je     805a10 <devpipe_read+0x77>
				return 0;
  805a09:	b8 00 00 00 00       	mov    $0x0,%eax
  805a0e:	eb 6d                	jmp    805a7d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  805a10:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805a17:	00 00 00 
  805a1a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  805a1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a20:	8b 10                	mov    (%rax),%edx
  805a22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a26:	8b 40 04             	mov    0x4(%rax),%eax
  805a29:	39 c2                	cmp    %eax,%edx
  805a2b:	74 ae                	je     8059db <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  805a2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805a31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805a35:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  805a39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a3d:	8b 00                	mov    (%rax),%eax
  805a3f:	99                   	cltd   
  805a40:	c1 ea 1b             	shr    $0x1b,%edx
  805a43:	01 d0                	add    %edx,%eax
  805a45:	83 e0 1f             	and    $0x1f,%eax
  805a48:	29 d0                	sub    %edx,%eax
  805a4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805a4e:	48 98                	cltq   
  805a50:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  805a55:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  805a57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a5b:	8b 00                	mov    (%rax),%eax
  805a5d:	8d 50 01             	lea    0x1(%rax),%edx
  805a60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a64:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805a66:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805a6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805a6f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805a73:	0f 82 60 ff ff ff    	jb     8059d9 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  805a79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805a7d:	c9                   	leaveq 
  805a7e:	c3                   	retq   

0000000000805a7f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  805a7f:	55                   	push   %rbp
  805a80:	48 89 e5             	mov    %rsp,%rbp
  805a83:	48 83 ec 40          	sub    $0x40,%rsp
  805a87:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805a8b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805a8f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  805a93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805a97:	48 89 c7             	mov    %rax,%rdi
  805a9a:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  805aa1:	00 00 00 
  805aa4:	ff d0                	callq  *%rax
  805aa6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805aaa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805aae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805ab2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805ab9:	00 
  805aba:	e9 8e 00 00 00       	jmpq   805b4d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  805abf:	eb 31                	jmp    805af2 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  805ac1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805ac5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805ac9:	48 89 d6             	mov    %rdx,%rsi
  805acc:	48 89 c7             	mov    %rax,%rdi
  805acf:	48 b8 62 58 80 00 00 	movabs $0x805862,%rax
  805ad6:	00 00 00 
  805ad9:	ff d0                	callq  *%rax
  805adb:	85 c0                	test   %eax,%eax
  805add:	74 07                	je     805ae6 <devpipe_write+0x67>
				return 0;
  805adf:	b8 00 00 00 00       	mov    $0x0,%eax
  805ae4:	eb 79                	jmp    805b5f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  805ae6:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805aed:	00 00 00 
  805af0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  805af2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805af6:	8b 40 04             	mov    0x4(%rax),%eax
  805af9:	48 63 d0             	movslq %eax,%rdx
  805afc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b00:	8b 00                	mov    (%rax),%eax
  805b02:	48 98                	cltq   
  805b04:	48 83 c0 20          	add    $0x20,%rax
  805b08:	48 39 c2             	cmp    %rax,%rdx
  805b0b:	73 b4                	jae    805ac1 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  805b0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b11:	8b 40 04             	mov    0x4(%rax),%eax
  805b14:	99                   	cltd   
  805b15:	c1 ea 1b             	shr    $0x1b,%edx
  805b18:	01 d0                	add    %edx,%eax
  805b1a:	83 e0 1f             	and    $0x1f,%eax
  805b1d:	29 d0                	sub    %edx,%eax
  805b1f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805b23:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805b27:	48 01 ca             	add    %rcx,%rdx
  805b2a:	0f b6 0a             	movzbl (%rdx),%ecx
  805b2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805b31:	48 98                	cltq   
  805b33:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  805b37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b3b:	8b 40 04             	mov    0x4(%rax),%eax
  805b3e:	8d 50 01             	lea    0x1(%rax),%edx
  805b41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b45:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805b48:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805b4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b51:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805b55:	0f 82 64 ff ff ff    	jb     805abf <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  805b5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805b5f:	c9                   	leaveq 
  805b60:	c3                   	retq   

0000000000805b61 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  805b61:	55                   	push   %rbp
  805b62:	48 89 e5             	mov    %rsp,%rbp
  805b65:	48 83 ec 20          	sub    $0x20,%rsp
  805b69:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805b6d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  805b71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b75:	48 89 c7             	mov    %rax,%rdi
  805b78:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  805b7f:	00 00 00 
  805b82:	ff d0                	callq  *%rax
  805b84:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  805b88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b8c:	48 be 55 6e 80 00 00 	movabs $0x806e55,%rsi
  805b93:	00 00 00 
  805b96:	48 89 c7             	mov    %rax,%rdi
  805b99:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  805ba0:	00 00 00 
  805ba3:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  805ba5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ba9:	8b 50 04             	mov    0x4(%rax),%edx
  805bac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805bb0:	8b 00                	mov    (%rax),%eax
  805bb2:	29 c2                	sub    %eax,%edx
  805bb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805bb8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  805bbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805bc2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805bc9:	00 00 00 
	stat->st_dev = &devpipe;
  805bcc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805bd0:	48 b9 20 81 80 00 00 	movabs $0x808120,%rcx
  805bd7:	00 00 00 
  805bda:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  805be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805be6:	c9                   	leaveq 
  805be7:	c3                   	retq   

0000000000805be8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  805be8:	55                   	push   %rbp
  805be9:	48 89 e5             	mov    %rsp,%rbp
  805bec:	48 83 ec 10          	sub    $0x10,%rsp
  805bf0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  805bf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805bf8:	48 89 c6             	mov    %rax,%rsi
  805bfb:	bf 00 00 00 00       	mov    $0x0,%edi
  805c00:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  805c07:	00 00 00 
  805c0a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  805c0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805c10:	48 89 c7             	mov    %rax,%rdi
  805c13:	48 b8 6e 38 80 00 00 	movabs $0x80386e,%rax
  805c1a:	00 00 00 
  805c1d:	ff d0                	callq  *%rax
  805c1f:	48 89 c6             	mov    %rax,%rsi
  805c22:	bf 00 00 00 00       	mov    $0x0,%edi
  805c27:	48 b8 2f 2c 80 00 00 	movabs $0x802c2f,%rax
  805c2e:	00 00 00 
  805c31:	ff d0                	callq  *%rax
}
  805c33:	c9                   	leaveq 
  805c34:	c3                   	retq   

0000000000805c35 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  805c35:	55                   	push   %rbp
  805c36:	48 89 e5             	mov    %rsp,%rbp
  805c39:	48 83 ec 20          	sub    $0x20,%rsp
  805c3d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  805c40:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805c44:	75 35                	jne    805c7b <wait+0x46>
  805c46:	48 b9 5c 6e 80 00 00 	movabs $0x806e5c,%rcx
  805c4d:	00 00 00 
  805c50:	48 ba 67 6e 80 00 00 	movabs $0x806e67,%rdx
  805c57:	00 00 00 
  805c5a:	be 09 00 00 00       	mov    $0x9,%esi
  805c5f:	48 bf 7c 6e 80 00 00 	movabs $0x806e7c,%rdi
  805c66:	00 00 00 
  805c69:	b8 00 00 00 00       	mov    $0x0,%eax
  805c6e:	49 b8 0d 13 80 00 00 	movabs $0x80130d,%r8
  805c75:	00 00 00 
  805c78:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  805c7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805c7e:	25 ff 03 00 00       	and    $0x3ff,%eax
  805c83:	48 98                	cltq   
  805c85:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  805c8c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805c93:	00 00 00 
  805c96:	48 01 d0             	add    %rdx,%rax
  805c99:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  805c9d:	eb 0c                	jmp    805cab <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  805c9f:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805ca6:	00 00 00 
  805ca9:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  805cab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805caf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805cb5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805cb8:	75 0e                	jne    805cc8 <wait+0x93>
  805cba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805cbe:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805cc4:	85 c0                	test   %eax,%eax
  805cc6:	75 d7                	jne    805c9f <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  805cc8:	c9                   	leaveq 
  805cc9:	c3                   	retq   

0000000000805cca <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805cca:	55                   	push   %rbp
  805ccb:	48 89 e5             	mov    %rsp,%rbp
  805cce:	48 83 ec 10          	sub    $0x10,%rsp
  805cd2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  805cd6:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  805cdd:	00 00 00 
  805ce0:	48 8b 00             	mov    (%rax),%rax
  805ce3:	48 85 c0             	test   %rax,%rax
  805ce6:	0f 85 84 00 00 00    	jne    805d70 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  805cec:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805cf3:	00 00 00 
  805cf6:	48 8b 00             	mov    (%rax),%rax
  805cf9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805cff:	ba 07 00 00 00       	mov    $0x7,%edx
  805d04:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805d09:	89 c7                	mov    %eax,%edi
  805d0b:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  805d12:	00 00 00 
  805d15:	ff d0                	callq  *%rax
  805d17:	85 c0                	test   %eax,%eax
  805d19:	79 2a                	jns    805d45 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  805d1b:	48 ba 88 6e 80 00 00 	movabs $0x806e88,%rdx
  805d22:	00 00 00 
  805d25:	be 23 00 00 00       	mov    $0x23,%esi
  805d2a:	48 bf af 6e 80 00 00 	movabs $0x806eaf,%rdi
  805d31:	00 00 00 
  805d34:	b8 00 00 00 00       	mov    $0x0,%eax
  805d39:	48 b9 0d 13 80 00 00 	movabs $0x80130d,%rcx
  805d40:	00 00 00 
  805d43:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  805d45:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805d4c:	00 00 00 
  805d4f:	48 8b 00             	mov    (%rax),%rax
  805d52:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805d58:	48 be 83 5d 80 00 00 	movabs $0x805d83,%rsi
  805d5f:	00 00 00 
  805d62:	89 c7                	mov    %eax,%edi
  805d64:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  805d6b:	00 00 00 
  805d6e:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  805d70:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  805d77:	00 00 00 
  805d7a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805d7e:	48 89 10             	mov    %rdx,(%rax)
}
  805d81:	c9                   	leaveq 
  805d82:	c3                   	retq   

0000000000805d83 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  805d83:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  805d86:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  805d8d:	00 00 00 
call *%rax
  805d90:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  805d92:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  805d99:	00 
movq 152(%rsp), %rcx  //Load RSP
  805d9a:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  805da1:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  805da2:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  805da6:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  805da9:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  805db0:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  805db1:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  805db5:	4c 8b 3c 24          	mov    (%rsp),%r15
  805db9:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  805dbe:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805dc3:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  805dc8:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  805dcd:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805dd2:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805dd7:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  805ddc:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  805de1:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805de6:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805deb:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  805df0:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805df5:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805dfa:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805dff:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  805e03:	48 83 c4 08          	add    $0x8,%rsp
popfq
  805e07:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  805e08:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  805e09:	c3                   	retq   

0000000000805e0a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805e0a:	55                   	push   %rbp
  805e0b:	48 89 e5             	mov    %rsp,%rbp
  805e0e:	48 83 ec 30          	sub    $0x30,%rsp
  805e12:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805e16:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805e1a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  805e1e:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805e25:	00 00 00 
  805e28:	48 8b 00             	mov    (%rax),%rax
  805e2b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805e31:	85 c0                	test   %eax,%eax
  805e33:	75 34                	jne    805e69 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  805e35:	48 b8 08 2b 80 00 00 	movabs $0x802b08,%rax
  805e3c:	00 00 00 
  805e3f:	ff d0                	callq  *%rax
  805e41:	25 ff 03 00 00       	and    $0x3ff,%eax
  805e46:	48 98                	cltq   
  805e48:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  805e4f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805e56:	00 00 00 
  805e59:	48 01 c2             	add    %rax,%rdx
  805e5c:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805e63:	00 00 00 
  805e66:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  805e69:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805e6e:	75 0e                	jne    805e7e <ipc_recv+0x74>
		pg = (void*) UTOP;
  805e70:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805e77:	00 00 00 
  805e7a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  805e7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805e82:	48 89 c7             	mov    %rax,%rdi
  805e85:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  805e8c:	00 00 00 
  805e8f:	ff d0                	callq  *%rax
  805e91:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  805e94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805e98:	79 19                	jns    805eb3 <ipc_recv+0xa9>
		*from_env_store = 0;
  805e9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805e9e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  805ea4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805ea8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  805eae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805eb1:	eb 53                	jmp    805f06 <ipc_recv+0xfc>
	}
	if(from_env_store)
  805eb3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805eb8:	74 19                	je     805ed3 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  805eba:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805ec1:	00 00 00 
  805ec4:	48 8b 00             	mov    (%rax),%rax
  805ec7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  805ecd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ed1:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  805ed3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805ed8:	74 19                	je     805ef3 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  805eda:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805ee1:	00 00 00 
  805ee4:	48 8b 00             	mov    (%rax),%rax
  805ee7:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  805eed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805ef1:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  805ef3:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805efa:	00 00 00 
  805efd:	48 8b 00             	mov    (%rax),%rax
  805f00:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  805f06:	c9                   	leaveq 
  805f07:	c3                   	retq   

0000000000805f08 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805f08:	55                   	push   %rbp
  805f09:	48 89 e5             	mov    %rsp,%rbp
  805f0c:	48 83 ec 30          	sub    $0x30,%rsp
  805f10:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805f13:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805f16:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805f1a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  805f1d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805f22:	75 0e                	jne    805f32 <ipc_send+0x2a>
		pg = (void*)UTOP;
  805f24:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805f2b:	00 00 00 
  805f2e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  805f32:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805f35:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805f38:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805f3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805f3f:	89 c7                	mov    %eax,%edi
  805f41:	48 b8 58 2d 80 00 00 	movabs $0x802d58,%rax
  805f48:	00 00 00 
  805f4b:	ff d0                	callq  *%rax
  805f4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  805f50:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805f54:	75 0c                	jne    805f62 <ipc_send+0x5a>
			sys_yield();
  805f56:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805f5d:	00 00 00 
  805f60:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  805f62:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805f66:	74 ca                	je     805f32 <ipc_send+0x2a>
	if(result != 0)
  805f68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f6c:	74 20                	je     805f8e <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  805f6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f71:	89 c6                	mov    %eax,%esi
  805f73:	48 bf c0 6e 80 00 00 	movabs $0x806ec0,%rdi
  805f7a:	00 00 00 
  805f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  805f82:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  805f89:	00 00 00 
  805f8c:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  805f8e:	c9                   	leaveq 
  805f8f:	c3                   	retq   

0000000000805f90 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  805f90:	55                   	push   %rbp
  805f91:	48 89 e5             	mov    %rsp,%rbp
  805f94:	53                   	push   %rbx
  805f95:	48 83 ec 58          	sub    $0x58,%rsp
  805f99:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  805f9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  805fa1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  805fa5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  805fac:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  805fb3:	00 
  805fb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805fb8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  805fbc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805fc0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  805fc4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805fc8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  805fcc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805fd0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  805fd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805fd8:	48 c1 e8 27          	shr    $0x27,%rax
  805fdc:	48 89 c2             	mov    %rax,%rdx
  805fdf:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  805fe6:	01 00 00 
  805fe9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805fed:	83 e0 01             	and    $0x1,%eax
  805ff0:	48 85 c0             	test   %rax,%rax
  805ff3:	0f 85 91 00 00 00    	jne    80608a <ipc_host_recv+0xfa>
  805ff9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ffd:	48 c1 e8 1e          	shr    $0x1e,%rax
  806001:	48 89 c2             	mov    %rax,%rdx
  806004:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80600b:	01 00 00 
  80600e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806012:	83 e0 01             	and    $0x1,%eax
  806015:	48 85 c0             	test   %rax,%rax
  806018:	74 70                	je     80608a <ipc_host_recv+0xfa>
  80601a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80601e:	48 c1 e8 15          	shr    $0x15,%rax
  806022:	48 89 c2             	mov    %rax,%rdx
  806025:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80602c:	01 00 00 
  80602f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806033:	83 e0 01             	and    $0x1,%eax
  806036:	48 85 c0             	test   %rax,%rax
  806039:	74 4f                	je     80608a <ipc_host_recv+0xfa>
  80603b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80603f:	48 c1 e8 0c          	shr    $0xc,%rax
  806043:	48 89 c2             	mov    %rax,%rdx
  806046:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80604d:	01 00 00 
  806050:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806054:	83 e0 01             	and    $0x1,%eax
  806057:	48 85 c0             	test   %rax,%rax
  80605a:	74 2e                	je     80608a <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80605c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806060:	ba 07 04 00 00       	mov    $0x407,%edx
  806065:	48 89 c6             	mov    %rax,%rsi
  806068:	bf 00 00 00 00       	mov    $0x0,%edi
  80606d:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  806074:	00 00 00 
  806077:	ff d0                	callq  *%rax
  806079:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80607c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  806080:	79 08                	jns    80608a <ipc_host_recv+0xfa>
	    	return result;
  806082:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  806085:	e9 84 00 00 00       	jmpq   80610e <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  80608a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80608e:	48 c1 e8 0c          	shr    $0xc,%rax
  806092:	48 89 c2             	mov    %rax,%rdx
  806095:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80609c:	01 00 00 
  80609f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8060a3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8060a9:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  8060ad:	b8 03 00 00 00       	mov    $0x3,%eax
  8060b2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8060b6:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8060ba:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8060be:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8060c2:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8060c6:	4c 89 c3             	mov    %r8,%rbx
  8060c9:	0f 01 c1             	vmcall 
  8060cc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  8060cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8060d3:	7e 36                	jle    80610b <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  8060d5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8060d8:	41 89 c0             	mov    %eax,%r8d
  8060db:	b9 03 00 00 00       	mov    $0x3,%ecx
  8060e0:	48 ba d8 6e 80 00 00 	movabs $0x806ed8,%rdx
  8060e7:	00 00 00 
  8060ea:	be 67 00 00 00       	mov    $0x67,%esi
  8060ef:	48 bf 05 6f 80 00 00 	movabs $0x806f05,%rdi
  8060f6:	00 00 00 
  8060f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8060fe:	49 b9 0d 13 80 00 00 	movabs $0x80130d,%r9
  806105:	00 00 00 
  806108:	41 ff d1             	callq  *%r9
	return result;
  80610b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  80610e:	48 83 c4 58          	add    $0x58,%rsp
  806112:	5b                   	pop    %rbx
  806113:	5d                   	pop    %rbp
  806114:	c3                   	retq   

0000000000806115 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  806115:	55                   	push   %rbp
  806116:	48 89 e5             	mov    %rsp,%rbp
  806119:	53                   	push   %rbx
  80611a:	48 83 ec 68          	sub    $0x68,%rsp
  80611e:	89 7d ac             	mov    %edi,-0x54(%rbp)
  806121:	89 75 a8             	mov    %esi,-0x58(%rbp)
  806124:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  806128:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  80612b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80612f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  806133:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  80613a:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  806141:	00 
  806142:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806146:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80614a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80614e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  806152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806156:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80615a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80615e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  806162:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806166:	48 c1 e8 27          	shr    $0x27,%rax
  80616a:	48 89 c2             	mov    %rax,%rdx
  80616d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  806174:	01 00 00 
  806177:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80617b:	83 e0 01             	and    $0x1,%eax
  80617e:	48 85 c0             	test   %rax,%rax
  806181:	0f 85 88 00 00 00    	jne    80620f <ipc_host_send+0xfa>
  806187:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80618b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80618f:	48 89 c2             	mov    %rax,%rdx
  806192:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  806199:	01 00 00 
  80619c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8061a0:	83 e0 01             	and    $0x1,%eax
  8061a3:	48 85 c0             	test   %rax,%rax
  8061a6:	74 67                	je     80620f <ipc_host_send+0xfa>
  8061a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8061ac:	48 c1 e8 15          	shr    $0x15,%rax
  8061b0:	48 89 c2             	mov    %rax,%rdx
  8061b3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8061ba:	01 00 00 
  8061bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8061c1:	83 e0 01             	and    $0x1,%eax
  8061c4:	48 85 c0             	test   %rax,%rax
  8061c7:	74 46                	je     80620f <ipc_host_send+0xfa>
  8061c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8061cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8061d1:	48 89 c2             	mov    %rax,%rdx
  8061d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8061db:	01 00 00 
  8061de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8061e2:	83 e0 01             	and    $0x1,%eax
  8061e5:	48 85 c0             	test   %rax,%rax
  8061e8:	74 25                	je     80620f <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8061ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8061ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8061f2:	48 89 c2             	mov    %rax,%rdx
  8061f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8061fc:	01 00 00 
  8061ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806203:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  806209:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80620d:	eb 0e                	jmp    80621d <ipc_host_send+0x108>
	else
		a3 = UTOP;
  80620f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  806216:	00 00 00 
  806219:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  80621d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806221:	48 89 c6             	mov    %rax,%rsi
  806224:	48 bf 0f 6f 80 00 00 	movabs $0x806f0f,%rdi
  80622b:	00 00 00 
  80622e:	b8 00 00 00 00       	mov    $0x0,%eax
  806233:	48 ba 46 15 80 00 00 	movabs $0x801546,%rdx
  80623a:	00 00 00 
  80623d:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  80623f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  806242:	48 98                	cltq   
  806244:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  806248:	8b 45 a8             	mov    -0x58(%rbp),%eax
  80624b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  80624f:	8b 45 9c             	mov    -0x64(%rbp),%eax
  806252:	48 98                	cltq   
  806254:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  806258:	b8 02 00 00 00       	mov    $0x2,%eax
  80625d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  806261:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  806265:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  806269:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80626d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  806271:	4c 89 c3             	mov    %r8,%rbx
  806274:	0f 01 c1             	vmcall 
  806277:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  80627a:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  80627e:	75 0c                	jne    80628c <ipc_host_send+0x177>
			sys_yield();
  806280:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  806287:	00 00 00 
  80628a:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  80628c:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  806290:	74 c6                	je     806258 <ipc_host_send+0x143>
	
	if(result !=0)
  806292:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  806296:	74 36                	je     8062ce <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  806298:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80629b:	41 89 c0             	mov    %eax,%r8d
  80629e:	b9 02 00 00 00       	mov    $0x2,%ecx
  8062a3:	48 ba d8 6e 80 00 00 	movabs $0x806ed8,%rdx
  8062aa:	00 00 00 
  8062ad:	be 94 00 00 00       	mov    $0x94,%esi
  8062b2:	48 bf 05 6f 80 00 00 	movabs $0x806f05,%rdi
  8062b9:	00 00 00 
  8062bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8062c1:	49 b9 0d 13 80 00 00 	movabs $0x80130d,%r9
  8062c8:	00 00 00 
  8062cb:	41 ff d1             	callq  *%r9
}
  8062ce:	48 83 c4 68          	add    $0x68,%rsp
  8062d2:	5b                   	pop    %rbx
  8062d3:	5d                   	pop    %rbp
  8062d4:	c3                   	retq   

00000000008062d5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8062d5:	55                   	push   %rbp
  8062d6:	48 89 e5             	mov    %rsp,%rbp
  8062d9:	48 83 ec 14          	sub    $0x14,%rsp
  8062dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8062e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8062e7:	eb 4e                	jmp    806337 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8062e9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8062f0:	00 00 00 
  8062f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8062f6:	48 98                	cltq   
  8062f8:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8062ff:	48 01 d0             	add    %rdx,%rax
  806302:	48 05 d0 00 00 00    	add    $0xd0,%rax
  806308:	8b 00                	mov    (%rax),%eax
  80630a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80630d:	75 24                	jne    806333 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80630f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  806316:	00 00 00 
  806319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80631c:	48 98                	cltq   
  80631e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  806325:	48 01 d0             	add    %rdx,%rax
  806328:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80632e:	8b 40 08             	mov    0x8(%rax),%eax
  806331:	eb 12                	jmp    806345 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  806333:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  806337:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80633e:	7e a9                	jle    8062e9 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  806340:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806345:	c9                   	leaveq 
  806346:	c3                   	retq   

0000000000806347 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  806347:	55                   	push   %rbp
  806348:	48 89 e5             	mov    %rsp,%rbp
  80634b:	48 83 ec 18          	sub    $0x18,%rsp
  80634f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  806353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806357:	48 c1 e8 15          	shr    $0x15,%rax
  80635b:	48 89 c2             	mov    %rax,%rdx
  80635e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  806365:	01 00 00 
  806368:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80636c:	83 e0 01             	and    $0x1,%eax
  80636f:	48 85 c0             	test   %rax,%rax
  806372:	75 07                	jne    80637b <pageref+0x34>
		return 0;
  806374:	b8 00 00 00 00       	mov    $0x0,%eax
  806379:	eb 53                	jmp    8063ce <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80637b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80637f:	48 c1 e8 0c          	shr    $0xc,%rax
  806383:	48 89 c2             	mov    %rax,%rdx
  806386:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80638d:	01 00 00 
  806390:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806394:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  806398:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80639c:	83 e0 01             	and    $0x1,%eax
  80639f:	48 85 c0             	test   %rax,%rax
  8063a2:	75 07                	jne    8063ab <pageref+0x64>
		return 0;
  8063a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8063a9:	eb 23                	jmp    8063ce <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8063ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8063af:	48 c1 e8 0c          	shr    $0xc,%rax
  8063b3:	48 89 c2             	mov    %rax,%rdx
  8063b6:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8063bd:	00 00 00 
  8063c0:	48 c1 e2 04          	shl    $0x4,%rdx
  8063c4:	48 01 d0             	add    %rdx,%rax
  8063c7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8063cb:	0f b7 c0             	movzwl %ax,%eax
}
  8063ce:	c9                   	leaveq 
  8063cf:	c3                   	retq   
